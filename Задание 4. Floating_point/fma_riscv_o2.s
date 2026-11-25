fma_expr:
        fmadd.s fa0, fa0, fa1, fa2
        ret

main:
        addi    sp, sp, -32
        sd      ra, 24(sp)
        fsd     fs0, 16(sp)
        lui     a0, 260096
        fmv.w.x fs0, a0
        li      a0, -23
        fmv.s   fa0, fs0
        call    ldexpf
        lui     a0, 784384
        fadd.s  fa5, fa0, fs0
        fsub.s  fa4, fs0, fa0
        fmv.w.x fa3, a0
        fsw     fa5, 12(sp)
        fsw     fa4, 8(sp)
        fsw     fa3, 4(sp)
        flw     fa0, 12(sp)
        flw     fa1, 8(sp)
        flw     fa2, 4(sp)
        call    fma_expr
        flw     fa5, 12(sp)
        flw     fa4, 12(sp)
        fmv.x.w a2, fa4
        fcvt.d.s        fa5, fa5
        fmv.s   fs0, fa0
        fmv.x.d a1, fa5
.Lpcrel_hi0:
        auipc   a0, %pcrel_hi(.L.str)
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi0)
        call    printf
        flw     fa5, 8(sp)
        flw     fa4, 8(sp)
        fmv.x.w a2, fa4
        fcvt.d.s        fa5, fa5
        fmv.x.d a1, fa5
.Lpcrel_hi1:
        auipc   a0, %pcrel_hi(.L.str.1)
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi1)
        call    printf
        flw     fa5, 4(sp)
        flw     fa4, 4(sp)
        fmv.x.w a2, fa4
        fcvt.d.s        fa5, fa5
        fmv.x.d a1, fa5
.Lpcrel_hi2:
        auipc   a0, %pcrel_hi(.L.str.2)
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi2)
        call    printf
        fcvt.d.s        fa5, fs0
        fmv.x.w a3, fs0
        fmv.x.d a1, fa5
.Lpcrel_hi3:
        auipc   a0, %pcrel_hi(.L.str.3)
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi3)
        mv      a2, a1
        call    printf
        li      a0, 0
        ld      ra, 24(sp)
        fld     fs0, 16(sp)
        addi    sp, sp, 32
        ret

.L.str:
        .asciz  "a = %.10g (0x%08x)\n"

.L.str.1:
        .asciz  "b = %.10g (0x%08x)\n"

.L.str.2:
        .asciz  "c = %.10g (0x%08x)\n"

.L.str.3:
        .asciz  "a * b + c = %.10g (hex float: %a, bits: 0x%08x)\n"
