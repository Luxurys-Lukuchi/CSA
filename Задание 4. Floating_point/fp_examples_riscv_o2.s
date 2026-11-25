f2c:
        lui     a5,%hi(.LC0)
        flw     fa4,%lo(.LC0)(a5)
        lui     a5,%hi(.LC1)
        flw     fa5,%lo(.LC1)(a5)
        fsub.s  fa0,fa0,fa4
        fmul.s  fa0,fa0,fa5
        ret
sqrt_demo:
        fcvt.s.w        fa5,a0
        fmv.s.x fa4,zero
        fge.s   a5,fa5,fa4
        beq     a5,zero,.L4
        fsqrt.s fa5,fa5
.L4:
        fcvt.w.s a5,fa5,rtz
        fsw     fa5,0(a1)
        sw      a5,0(a2)
        ret
e_const:
        lui     a5,%hi(.LC2)
        fld     fa5,%lo(.LC2)(a5)
        fmv.d   fa3,fa0
        li      a5,1
        fmv.d   fa0,fa5
        fle.d   a4,fa3,fa5
        beq     a4,zero,.L7
.L10:
        fcvt.d.w        fa4,a5
        addiw   a5,a5,1
        fdiv.d  fa5,fa5,fa4
        fle.d   a4,fa3,fa5
        fadd.d  fa0,fa0,fa5
        bne     a4,zero,.L10
.L7:
        ret
add_ld:
        addi    sp,sp,-16
        sd      ra,8(sp)
        call    __addtf3
        ld      ra,8(sp)
        addi    sp,sp,16
        jr      ra
.LC3:
        .string "f2c(32)  = %.9g\n"
.LC5:
        .string "f2c(212) = %.9g\n"
.LC7:
        .string "f2c(-40) = %.9g\n"
.LC8:
        .string "sqrt_demo(%d): dst = %.9g, idst = %d\n"
.LC13:
        .string "e_const(%.0e) = %.17g (M_E = %.17g)\n"
.LC15:
        .string "add_ld(1, 2) = %.21Lg\n"
main:
        lui     a0,%hi(.LC3)
        addi    sp,sp,-96
        mv      a1,zero
        addi    a0,a0,%lo(.LC3)
        sd      ra,88(sp)
        sd      s0,80(sp)
        sd      s1,72(sp)
        sd      s2,64(sp)
        fsd     fs0,56(sp)
        fsd     fs1,48(sp)
        call    printf
        lui     a5,%hi(.LC4)
        ld      a1,%lo(.LC4)(a5)
        lui     a0,%hi(.LC5)
        addi    a0,a0,%lo(.LC5)
        call    printf
        lui     a5,%hi(.LC6)
        ld      a1,%lo(.LC6)(a5)
        lui     a0,%hi(.LC7)
        addi    a0,a0,%lo(.LC7)
        call    printf
        li      a5,1
        slli    a5,a5,33
        fmv.s.x fs0,zero
        addi    a5,a5,100
        li      a4,-1
        sd      a5,8(sp)
        sw      a4,16(sp)
        addi    s0,sp,8
        addi    s2,sp,20
        lui     s1,%hi(.LC8)
.L22:
        lw      a1,0(s0)
        fcvt.s.w        fa5,a1
        fge.s   a5,fa5,fs0
        beq     a5,zero,.L20
        fsqrt.s fa5,fa5
.L20:
        fcvt.w.s a3,fa5,rtz
        fcvt.d.s        fa5,fa5
        addi    a0,s1,%lo(.LC8)
        sext.w  a3,a3
        fmv.x.d a2,fa5
        addi    s0,s0,4
        call    printf
        bne     s2,s0,.L22
        lui     a4,%hi(.LC10)
        lui     a5,%hi(.LC11)
        lui     a3,%hi(.LC9)
        fld     fa4,%lo(.LC10)(a4)
        fld     fa5,%lo(.LC11)(a5)
        fld     fa3,%lo(.LC9)(a3)
        lui     a4,%hi(.LC2)
        lui     a5,%hi(.LC12)
        fld     fs0,%lo(.LC2)(a4)
        fld     fs1,%lo(.LC12)(a5)
        fsd     fa3,24(sp)
        fsd     fa4,32(sp)
        fsd     fa5,40(sp)
        addi    s0,sp,24
        lui     s1,%hi(.LC13)
.L26:
        fld     fa2,0(s0)
        fmv.d   fa3,fs0
        fmv.d   fa5,fs0
        fle.d   a4,fa2,fs0
        li      a5,1
        beq     a4,zero,.L23
.L25:
        fcvt.d.w        fa4,a5
        addiw   a5,a5,1
        fdiv.d  fa5,fa5,fa4
        fle.d   a4,fa2,fa5
        fadd.d  fa3,fa3,fa5
        bne     a4,zero,.L25
.L23:
        fmv.x.d a3,fs1
        fmv.x.d a2,fa3
        fmv.x.d a1,fa2
        addi    a0,s1,%lo(.LC13)
        addi    s0,s0,8
        call    printf
        addi    a5,sp,48
        bne     s0,a5,.L26
        li      a3,134221824
        lui     a0,%hi(.LC15)
        slli    a3,a3,35
        addi    a0,a0,%lo(.LC15)
        li      a2,0
        call    printf
        ld      ra,88(sp)
        ld      s0,80(sp)
        ld      s1,72(sp)
        ld      s2,64(sp)
        fld     fs0,56(sp)
        fld     fs1,48(sp)
        li      a0,0
        addi    sp,sp,96
        jr      ra
.LC0:
        .word   1107296256
.LC1:
        .word   1057896676
.LC2:
        .word   0
        .word   1072693248
.LC4:
        .word   536870912
        .word   1079574528
.LC6:
        .word   0
        .word   -1069285376
.LC9:
        .word   -1598689907
        .word   1051772663
.LC10:
        .word   -2127697391
        .word   1030854553
.LC11:
        .word   -1747416644
        .word   1016910514
.LC12:
        .word   -1961601175
        .word   1074118410
