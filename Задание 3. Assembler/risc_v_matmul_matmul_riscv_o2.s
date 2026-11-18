# Target: RISC-V (64-bits) gcc -O2 -march=rv64gc

mul_ijk:
        lui     a5,%hi(n)
        lw      a5,%lo(n)(a5)
        ble     a5,zero,.L1
        slli    t3,a5,1
        add     t3,t3,a5
        lui     a6,%hi(a)
        lui     t4,%hi(b)
        slli    t3,t3,11
        addi    t4,t4,%lo(b)
        slli    a5,a5,3
        addi    a6,a6,%lo(a)
        lui     t1,%hi(c)
        li      a2,8192
        add     t5,a6,t3
        add     a7,a5,t4
        add     t3,t4,t3
        addi    t1,t1,%lo(c)
        addi    a2,a2,-2048
.L3:
        mv      a3,t3
        mv      a1,t4
        mv      a0,t1
.L6:
        fmv.d.x fa5,zero
        mv      a5,a1
        mv      a4,a6
.L4:
        fld     fa3,0(a4)
        fld     fa4,0(a5)
        add     a5,a5,a2
        addi    a4,a4,8
        fmadd.d fa5,fa3,fa4,fa5
        bne     a5,a3,.L4
        fsd     fa5,0(a0)
        addi    a1,a1,8
        addi    a0,a0,8
        addi    a3,a5,8
        bne     a1,a7,.L6
        add     a6,a6,a2
        add     t1,t1,a2
        bne     a6,t5,.L3
.L1:
        ret

mul_ikj:
        lui     a5,%hi(n)
        lw      a5,%lo(n)(a5)
        ble     a5,zero,.L9
        slli    a7,a5,1
        add     a7,a7,a5
        lui     t1,%hi(a)
        lui     t3,%hi(b)
        lui     a6,%hi(c)
        slli    a7,a7,11
        slli    a5,a5,3
        addi    t1,t1,%lo(a)
        addi    t3,t3,%lo(b)
        addi    a6,a6,%lo(c)
        li      a0,8192
        add     t4,t1,a7
        add     a3,a5,a6
        add     a7,t3,a7
        addi    a0,a0,-2048
.L11:
        mv      a2,t3
        mv      a1,t1
.L13:
        fld     fa3,0(a1)
        mv      a4,a2
        mv      a5,a6
.L12:
        fld     fa4,0(a5)
        fld     fa5,0(a4)
        addi    a5,a5,8
        addi    a4,a4,8
        fmadd.d fa5,fa5,fa3,fa4
        fsd     fa5,-8(a5)
        bne     a5,a3,.L12
        add     a2,a2,a0
        addi    a1,a1,8
        bne     a2,a7,.L13
        add     t1,t1,a0
        add     a6,a6,a0
        add     a3,a3,a0
        bne     t1,t4,.L11
.L9:
        ret