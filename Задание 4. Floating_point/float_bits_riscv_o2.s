print_float:
.Lpcrel_hi0:
        auipc   a0, %pcrel_hi(.L.str)
        fmv.x.w a3, fa0
        fcvt.d.s        fa5, fa0
        addi    a0, a0, %pcrel_lo(.Lpcrel_hi0)
        fmv.x.d a1, fa5
        srliw   a2, a3, 31
        slli    a4, a3, 33
        slli    a5, a3, 41
        srli    a3, a4, 56
        srli    a5, a5, 41
        addi    a4, a3, -127
        tail    printf

main:
        addi    sp, sp, -32
        sd      ra, 24(sp)
        sd      s0, 16(sp)
        sd      s1, 8(sp)
        fmv.w.x fa5, zero
.Lpcrel_hi1:
        auipc   a0, %pcrel_hi(.promoted_doubles.main)
        addi    s1, a0, %pcrel_lo(.Lpcrel_hi1)
        fsw     fa5, 4(sp)
.Lpcrel_hi2:
        auipc   a0, %pcrel_hi(.L.str)
        li      a1, 1023
        li      a3, 127
        addi    s0, a0, %pcrel_lo(.Lpcrel_hi2)
        slli    a1, a1, 52
        mv      a0, s0
        li      a2, 0
        li      a4, 0
        li      a5, 0
        call    printf
        lui     a1, 1032217
        li      a2, 1
        li      a3, 129
        slli    a1, a1, 36
        li      a4, 2
        lui     a5, 1152
        mv      a0, s0
        call    printf
        ld      a1, 0(s1)
        lui     a0, 1229
        li      a3, 123
        li      a4, -4
        addi    a5, a0, -819
        mv      a0, s0
        li      a2, 0
        call    printf
        ld      a1, 8(s1)
        lui     a0, 17
        li      a4, -127
        addi    a5, a0, 1730
        mv      a0, s0
        li      a2, 0
        li      a3, 0
        call    printf
        lui     a0, 260096
        flw     fa5, 4(sp)
        fmv.w.x fa4, a0
        fdiv.s  fa5, fa4, fa5
        fmv.x.w a0, fa5
        fcvt.d.s        fa5, fa5
        fmv.x.d a1, fa5
        srliw   a2, a0, 31
        slli    a3, a0, 33
        lui     a4, 2048
        srli    a3, a3, 56
        addi    s1, a4, -1
        and     a5, a0, s1
        addi    a4, a3, -127
        mv      a0, s0
        call    printf
        flw     fa5, 4(sp)
        flw     fa4, 4(sp)
        fdiv.s  fa5, fa5, fa4
        fmv.x.w a5, fa5
        fcvt.d.s        fa5, fa5
        fmv.x.d a1, fa5
        slli    a3, a5, 33
        srliw   a2, a5, 31
        srli    a3, a3, 56
        and     a5, a5, s1
        addi    a4, a3, -127
        mv      a0, s0
        call    printf
        li      a0, 0
        ld      ra, 24(sp)
        ld      s0, 16(sp)
        ld      s1, 8(sp)
        addi    sp, sp, 32
        ret

.L.str:
        .asciz  "%-14g s=%u e=%3u (2^%4d) m=0x%06x\n"

.promoted_doubles.main:
        .quad   0x3fb99999a0000000
        .quad   0x37a16c2000000000
