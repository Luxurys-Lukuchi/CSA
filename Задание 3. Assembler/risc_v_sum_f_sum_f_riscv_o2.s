# Target: RISC-V (64-bits) gcc -O2 -march=rv64gc

sum:
        ble     a1,zero,.L4
        slli    a1,a1,3
        mv      a5,a0
        add     a3,a0,a1
        li      a0,0
.L3:
        ld      a4,0(a5)
        addi    a5,a5,8
        add     a0,a0,a4
        bne     a5,a3,.L3
        ret
.L4:
        li      a0,0
        ret

f:
        mv      a3,a0
        ble     a0,zero,.L4
        li      a5,0
        li      a0,0
.L3:
        mul     a4,a5,a5
        addi    a5,a5,1
        add     a0,a0,a4
        bne     a3,a5,.L3
        ret
.L4:
        li      a0,0
        ret