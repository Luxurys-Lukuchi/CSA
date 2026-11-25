main:
        addi    sp, sp, -96
        sd      ra, 88(sp)
        sd      s0, 80(sp)
        sd      s1, 72(sp)
        sd      s2, 64(sp)
        sd      s3, 56(sp)
        sd      s4, 48(sp)
        fsd     fs0, 40(sp)
        fsd     fs1, 32(sp)
        fsd     fs2, 24(sp)
        fsd     fs3, 16(sp)
        fsd     fs4, 8(sp)
        li      s0, 0
        li      s1, 0
        lui     s2, 2441
        addi    s2, s2, 1665
        lui     s3, 16383
        slli    s3, s3, 36
        li      s4, 1
.LBB0_1:
        addiw   s2, s2, -1
        mv      a0, s2
        call    __floatunsitf
        mv      a2, a0
        mv      a3, a1
        li      a0, 0
        mv      a1, s3
        call    __divtf3
        mv      a2, a0
        mv      a3, a1
        mv      a0, s0
        mv      a1, s1
        call    __addtf3
        mv      s0, a0
        mv      s1, a1
        bltu    s4, s2, .LBB0_1
        lui     a0, 260096
        fmv.w.x fs3, zero
        fmv.w.x fa5, a0
        lui     a1, 2441
        li      a0, 1
        addi    a1, a1, 1664
.LBB0_3:
        fcvt.s.wu       fa4, a0
        fdiv.s  fa4, fa5, fa4
        fadd.s  fs3, fs3, fa4
        addiw   a1, a1, -1
        addi    a0, a0, 1
        bnez    a1, .LBB0_3
        lui     a0, 260096
        fmv.w.x fs2, zero
        fmv.w.x fa5, a0
        lui     a0, 2441
        addi    a0, a0, 1665
        li      a1, 1
.LBB0_5:
        addiw   a0, a0, -1
        fcvt.s.wu       fa4, a0
        fdiv.s  fa4, fa5, fa4
        fadd.s  fs2, fs2, fa4
        bltu    a1, a0, .LBB0_5
        lui     s2, 2441
        addi    s2, s2, 1664
        li      a0, 1
        mv      a1, s2
        li      s3, 1
        call    sum_pairwise
        fmv.s   fs1, fa0
        fmv.w.x fs0, zero
        lui     a0, 260096
        fmv.w.x fa5, a0
        fmv.s   fa4, fs0
.LBB0_7:
        fcvt.s.wu       fa3, s3
        fdiv.s  fa3, fa5, fa3
        fsub.s  fa4, fa3, fa4
        fmv.s   fa3, fs0
        fadd.s  fs0, fs0, fa4
        fsub.s  fa3, fs0, fa3
        fsub.s  fa4, fa3, fa4
        addiw   s2, s2, -1
        addi    s3, s3, 1
        bnez    s2, .LBB0_7
.Lpcrel_hi0:
        auipc   a0, %pcrel_hi(.L.str)
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi0)
        mv      a2, s0
        mv      a3, s1
        call    printf
.Lpcrel_hi1:
        auipc   a0, %pcrel_hi(.L.str.1)
.Lpcrel_hi2:
        auipc   a1, %pcrel_hi(.L.str.2)
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi1)
        addi    a1, a1, %pcrel_lo(.Lpcrel_hi2)
.Lpcrel_hi3:
        auipc   a2, %pcrel_hi(.L.str.3)
.Lpcrel_hi4:
        auipc   a3, %pcrel_hi(.L.str.4)
        addi    a2, a2, %pcrel_lo(.Lpcrel_hi3)
        addi    a3, a3, %pcrel_lo(.Lpcrel_hi4)
        call    printf
.Lpcrel_hi5:
        auipc   a0, %pcrel_hi(.Lstr)
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi5)
        call    puts
        fcvt.d.s        fs4, fs3
        fmv.s   fa0, fs3
        call    __extendsftf2
        mv      a2, s0
        mv      a3, s1
        call    __subtf3
        li      a2, -1
        srli    s3, a2, 1
        and     a1, a1, s3
        mv      a2, s0
        mv      a3, s1
        call    __divtf3
        call    __trunctfdf2
        fmv.x.d a3, fa0
        fmv.x.d a2, fs4
.Lpcrel_hi6:
        auipc   a0, %pcrel_hi(.L.str.6)
.Lpcrel_hi7:
        auipc   a1, %pcrel_hi(.L.str.7)
        addi    s2, a0, %pcrel_lo(.Lpcrel_hi6)
        addi    a1, a1, %pcrel_lo(.Lpcrel_hi7)
        mv      a0, s2
        call    printf
        fcvt.d.s        fs3, fs2
        fmv.s   fa0, fs2
        call    __extendsftf2
        mv      a2, s0
        mv      a3, s1
        call    __subtf3
        and     a1, a1, s3
        mv      a2, s0
        mv      a3, s1
        call    __divtf3
        call    __trunctfdf2
        fmv.x.d a3, fa0
        fmv.x.d a2, fs3
.Lpcrel_hi8:
        auipc   a1, %pcrel_hi(.L.str.8)
        addi    a1, a1, %pcrel_lo(.Lpcrel_hi8)
        mv      a0, s2
        call    printf
        fcvt.d.s        fs2, fs1
        fmv.s   fa0, fs1
        call    __extendsftf2
        mv      a2, s0
        mv      a3, s1
        call    __subtf3
        and     a1, a1, s3
        mv      a2, s0
        mv      a3, s1
        call    __divtf3
        call    __trunctfdf2
        fmv.x.d a3, fa0
        fmv.x.d a2, fs2
.Lpcrel_hi9:
        auipc   a1, %pcrel_hi(.L.str.9)
        addi    a1, a1, %pcrel_lo(.Lpcrel_hi9)
        mv      a0, s2
        call    printf
        fcvt.d.s        fs1, fs0
        fmv.s   fa0, fs0
        call    __extendsftf2
        mv      a2, s0
        mv      a3, s1
        call    __subtf3
        and     a1, a1, s3
        mv      a2, s0
        mv      a3, s1
        call    __divtf3
        call    __trunctfdf2
        fmv.x.d a3, fa0
        fmv.x.d a2, fs1
.Lpcrel_hi10:
        auipc   a1, %pcrel_hi(.L.str.10)
        addi    a1, a1, %pcrel_lo(.Lpcrel_hi10)
        mv      a0, s2
        call    printf
        li      a0, 0
        ld      ra, 88(sp)
        ld      s0, 80(sp)
        ld      s1, 72(sp)
        ld      s2, 64(sp)
        ld      s3, 56(sp)
        ld      s4, 48(sp)
        fld     fs0, 40(sp)
        fld     fs1, 32(sp)
        fld     fs2, 24(sp)
        fld     fs3, 16(sp)
        fld     fs4, 8(sp)
        addi    sp, sp, 96
        ret

sum_pairwise:
        bne     a1, a0, .LBB1_2
        lui     a1, 260096
        fcvt.s.w        fa5, a0
        fmv.w.x fa4, a1
        fdiv.s  fa0, fa4, fa5
        ret
.LBB1_2:
        addi    sp, sp, -32
        sd      ra, 24(sp)
        sd      s0, 16(sp)
        sd      s1, 8(sp)
        fsd     fs0, 0(sp)
        sub     a2, a1, a0
        srliw   a3, a2, 31
        add     a2, a2, a3
        sraiw   s0, a2, 1
        addw    s0, s0, a0
        mv      s1, a1
        mv      a1, s0
        call    sum_pairwise
        fmv.s   fs0, fa0
        addiw   a0, s0, 1
        mv      a1, s1
        call    sum_pairwise
        fadd.s  fa0, fs0, fa0
        ld      ra, 24(sp)
        ld      s0, 16(sp)
        ld      s1, 8(sp)
        fld     fs0, 0(sp)
        addi    sp, sp, 32
        ret

.L.str:
        .asciz  "Reference (long double): %.12Lf\n\n"

.L.str.1:
        .asciz  "%-12s | %-14s | %-14s\n"

.L.str.2:
        .asciz  "Method"

.L.str.3:
        .asciz  "Result (float)"

.L.str.4:
        .asciz  "Rel. error"

.L.str.6:
        .asciz  "%-12s | %-14.8f | %.6e\n"

.L.str.7:
        .asciz  "Forward"

.L.str.8:
        .asciz  "Backward"

.L.str.9:
        .asciz  "Pairwise"

.L.str.10:
        .asciz  "Kahan"

.Lstr:
        .asciz  "-------------|----------------|----------------"
