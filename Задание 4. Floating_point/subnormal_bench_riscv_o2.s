main:
        addi    sp, sp, -16
        sd      ra, 8(sp)
        lui     a0, 260096
        fmv.w.x fa0, a0
.Lpcrel_hi0:
        auipc   a0, %pcrel_hi(.L.str)
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi0)
        call    bench
        lui     a0, 3484
        addi    a0, a0, 2013
        fmv.w.x fa0, a0
.Lpcrel_hi1:
        auipc   a0, %pcrel_hi(.L.str.1)
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi1)
        call    bench
        li      a0, 0
        ld      ra, 8(sp)
        addi    sp, sp, 16
        ret

.LCPI1_0:
        .quad   0x3e112e0be826d695
bench:
        addi    sp, sp, -128
        sd      ra, 120(sp)
        sd      s0, 112(sp)
        sd      s1, 104(sp)
        fsd     fs0, 96(sp)
        fsd     fs1, 88(sp)
        fsd     fs2, 80(sp)
        fsd     fs3, 72(sp)
        fmv.w.x fa5, zero
        fsw     fa0, 52(sp)
        fsw     fa5, 4(sp)
        flw     fs0, 52(sp)
        mv      s0, a0
        li      a0, 1
        addi    a1, sp, 56
        call    clock_gettime
        ld      a0, 56(sp)
        ld      a1, 64(sp)
        fcvt.d.l        fa5, a0
.Lpcrel_hi2:
        auipc   a0, %pcrel_hi(.LCPI1_0)
        fcvt.d.l        fa4, a1
        fld     fs1, %pcrel_lo(.Lpcrel_hi2)(a0)
        fmadd.d fs2, fa4, fs1, fa5
        fmv.s   fa0, fs0
        call    mul_loop
        fsw     fa0, 4(sp)
        li      a0, 1
        addi    a1, sp, 56
        call    clock_gettime
        ld      a0, 56(sp)
        ld      a1, 64(sp)
        fcvt.d.l        fa5, a0
        fcvt.d.l        fa4, a1
        fmadd.d fa5, fa4, fs1, fa5
        lui     a0, 66109
        fsub.d  fa5, fa5, fs2
        slli    a0, a0, 34
        fmv.d.x fs2, a0
        fmul.d  fa5, fa5, fs2
        fsd     fa5, 8(sp)
        flw     fa4, 4(sp)
        fcvt.d.s        fa4, fa4
        fmv.x.d a3, fa5
        fmv.x.d a4, fa4
.Lpcrel_hi3:
        auipc   s1, %pcrel_hi(.L.str.2)
        addi    s1, s1, %pcrel_lo(.Lpcrel_hi3)
        li      a2, 1
        mv      a0, s1
        mv      a1, s0
        call    printf
        flw     fs0, 52(sp)
        li      a0, 1
        addi    a1, sp, 56
        call    clock_gettime
        ld      a0, 56(sp)
        ld      a1, 64(sp)
        fcvt.d.l        fa5, a0
        fcvt.d.l        fa4, a1
        fmadd.d fs3, fa4, fs1, fa5
        fmv.s   fa0, fs0
        call    mul_loop
        fsw     fa0, 4(sp)
        li      a0, 1
        addi    a1, sp, 56
        call    clock_gettime
        ld      a0, 56(sp)
        ld      a1, 64(sp)
        fcvt.d.l        fa5, a0
        fcvt.d.l        fa4, a1
        fmadd.d fa5, fa4, fs1, fa5
        fsub.d  fa5, fa5, fs3
        fmul.d  fa5, fa5, fs2
        fsd     fa5, 16(sp)
        flw     fa4, 4(sp)
        fcvt.d.s        fa4, fa4
        fmv.x.d a3, fa5
        fmv.x.d a4, fa4
        li      a2, 2
        mv      a0, s1
        mv      a1, s0
        call    printf
        flw     fs0, 52(sp)
        li      a0, 1
        addi    a1, sp, 56
        call    clock_gettime
        ld      a0, 56(sp)
        ld      a1, 64(sp)
        fcvt.d.l        fa5, a0
        fcvt.d.l        fa4, a1
        fmadd.d fs3, fa4, fs1, fa5
        fmv.s   fa0, fs0
        call    mul_loop
        fsw     fa0, 4(sp)
        li      a0, 1
        addi    a1, sp, 56
        call    clock_gettime
        ld      a0, 56(sp)
        ld      a1, 64(sp)
        fcvt.d.l        fa5, a0
        fcvt.d.l        fa4, a1
        fmadd.d fa5, fa4, fs1, fa5
        fsub.d  fa5, fa5, fs3
        fmul.d  fa5, fa5, fs2
        fsd     fa5, 24(sp)
        flw     fa4, 4(sp)
        fcvt.d.s        fa4, fa4
        fmv.x.d a3, fa5
        fmv.x.d a4, fa4
        li      a2, 3
        mv      a0, s1
        mv      a1, s0
        call    printf
        flw     fs0, 52(sp)
        li      a0, 1
        addi    a1, sp, 56
        call    clock_gettime
        ld      a0, 56(sp)
        ld      a1, 64(sp)
        fcvt.d.l        fa5, a0
        fcvt.d.l        fa4, a1
        fmadd.d fs3, fa4, fs1, fa5
        fmv.s   fa0, fs0
        call    mul_loop
        fsw     fa0, 4(sp)
        li      a0, 1
        addi    a1, sp, 56
        call    clock_gettime
        ld      a0, 56(sp)
        ld      a1, 64(sp)
        fcvt.d.l        fa5, a0
        fcvt.d.l        fa4, a1
        fmadd.d fa5, fa4, fs1, fa5
        fsub.d  fa5, fa5, fs3
        fmul.d  fa5, fa5, fs2
        fsd     fa5, 32(sp)
        flw     fa4, 4(sp)
        fcvt.d.s        fa4, fa4
        fmv.x.d a3, fa5
        fmv.x.d a4, fa4
        li      a2, 4
        mv      a0, s1
        mv      a1, s0
        call    printf
        flw     fs0, 52(sp)
        li      a0, 1
        addi    a1, sp, 56
        call    clock_gettime
        ld      a0, 56(sp)
        ld      a1, 64(sp)
        fcvt.d.l        fa5, a0
        fcvt.d.l        fa4, a1
        fmadd.d fs3, fa4, fs1, fa5
        fmv.s   fa0, fs0
        call    mul_loop
        fsw     fa0, 4(sp)
        li      a0, 1
        addi    a1, sp, 56
        call    clock_gettime
        ld      a0, 56(sp)
        ld      a1, 64(sp)
        fcvt.d.l        fa5, a0
        fcvt.d.l        fa4, a1
        fmadd.d fa5, fa4, fs1, fa5
        fsub.d  fa5, fa5, fs3
        fmul.d  fa5, fa5, fs2
        fsd     fa5, 40(sp)
        flw     fa4, 4(sp)
        fcvt.d.s        fa4, fa4
        fmv.x.d a3, fa5
        fmv.x.d a4, fa4
        li      a2, 5
        mv      a0, s1
        mv      a1, s0
        call    printf
.Lpcrel_hi4:
        auipc   a3, %pcrel_hi(cmp_double)
        addi    a3, a3, %pcrel_lo(.Lpcrel_hi4)
        addi    a0, sp, 8
        li      a1, 5
        li      a2, 8
        call    qsort
        ld      a2, 24(sp)
.Lpcrel_hi5:
        auipc   a0, %pcrel_hi(.L.str.3)
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi5)
        mv      a1, s0
        call    printf
        ld      ra, 120(sp)
        ld      s0, 112(sp)
        ld      s1, 104(sp)
        fld     fs0, 96(sp)
        fld     fs1, 88(sp)
        fld     fs2, 80(sp)
        fld     fs3, 72(sp)
        addi    sp, sp, 128
        ret

mul_loop:
        lui     a0, 258048
        fmv.w.x fa5, a0
        lui     a0, 488
        addi    a0, a0, 1152
.LBB2_1:
        fmul.s  fa4, fa0, fa5
        fadd.s  fa0, fa4, fa4
        addiw   a0, a0, -1
        bnez    a0, .LBB2_1
        ret

cmp_double:
        fld     fa5, 0(a0)
        fld     fa4, 0(a1)
        flt.d   a0, fa4, fa5
        flt.d   a1, fa5, fa4
        sub     a0, a0, a1
        ret

.L.str:
        .asciz  "Normal (1.0)            "

.L.str.1:
        .asciz  "Subnormal (2e-38)       "

.L.str.2:
        .asciz  "%s run %d: %.3f ms (res = %g)\n"

.L.str.3:
        .asciz  "==> %s MEDIAN: %.3f ms\n\n"
