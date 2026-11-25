mul_loop:
        test    edi, edi
        jle     .L2
        movss   xmm1, DWORD PTR .LC0[rip]
        xor     eax, eax
.L3:
        mulss   xmm0, xmm1
        add     eax, 1
        addss   xmm0, xmm0
        cmp     edi, eax
        jne     .L3
.L2:
        ret
cmp_double:
        movsd   xmm0, QWORD PTR [rdi]
        movsd   xmm1, QWORD PTR [rsi]
        xor     eax, eax
        comisd  xmm0, xmm1
        seta    al
        xor     edx, edx
        comisd  xmm1, xmm0
        seta    dl
        sub     eax, edx
        ret
.LC4:
        .string "%s run %d: %.3f ms (res = %g)\n"
.LC5:
        .string "==> %s MEDIAN: %.3f ms\n\n"
bench:
        push    r13
        mov     r13d, 1
        push    r12
        push    rbp
        mov     rbp, rdi
        push    rbx
        sub     rsp, 104
        movss   DWORD PTR [rsp+12], xmm0
        lea     rbx, [rsp+32]
        lea     r12, [rsp+48]
        mov     DWORD PTR [rsp+28], 0x00000000
.L8:
        movss   xmm3, DWORD PTR [rsp+12]
        mov     rsi, rbx
        mov     edi, 1
        movss   DWORD PTR [rsp+8], xmm3
        call    clock_gettime
        pxor    xmm0, xmm0
        pxor    xmm1, xmm1
        mov     edi, 2000000
        cvtsi2sd        xmm0, QWORD PTR [rsp+40]
        mulsd   xmm0, QWORD PTR .LC2[rip]
        cvtsi2sd        xmm1, QWORD PTR [rsp+32]
        movapd  xmm2, xmm0
        movss   xmm0, DWORD PTR [rsp+8]
        addsd   xmm2, xmm1
        movsd   QWORD PTR [rsp], xmm2
        call    mul_loop
        mov     rsi, rbx
        mov     edi, 1
        movss   DWORD PTR [rsp+28], xmm0
        call    clock_gettime
        pxor    xmm0, xmm0
        pxor    xmm1, xmm1
        mov     edx, r13d
        cvtsi2sd        xmm0, QWORD PTR [rsp+40]
        mulsd   xmm0, QWORD PTR .LC2[rip]
        mov     rsi, rbp
        mov     edi, OFFSET FLAT:.LC4
        cvtsi2sd        xmm1, QWORD PTR [rsp+32]
        mov     eax, 2
        addsd   xmm0, xmm1
        subsd   xmm0, QWORD PTR [rsp]
        movss   xmm1, DWORD PTR [rsp+28]
        mulsd   xmm0, QWORD PTR .LC3[rip]
        cvtss2sd        xmm1, xmm1
        movsd   QWORD PTR [r12-8+r13*8], xmm0
        add     r13, 1
        call    printf
        cmp     r13, 6
        jne     .L8
        mov     rdi, r12
        mov     ecx, OFFSET FLAT:cmp_double
        mov     edx, 8
        mov     esi, 5
        call    qsort
        movsd   xmm0, QWORD PTR [rsp+64]
        mov     rsi, rbp
        mov     edi, OFFSET FLAT:.LC5
        mov     eax, 1
        call    printf
        add     rsp, 104
        pop     rbx
        pop     rbp
        pop     r12
        pop     r13
        ret
.LC6:
        .string "Normal (1.0)            "
.LC8:
        .string "Subnormal (2e-38)       "
.LC10:
        .string "Subnormal + FTZ/DAZ     "
main:
        sub     rsp, 24
        movss   xmm0, DWORD PTR .LC7[rip]
        mov     edi, OFFSET FLAT:.LC6
        call    bench
        movss   xmm0, DWORD PTR .LC9[rip]
        mov     edi, OFFSET FLAT:.LC8
        call    bench
        stmxcsr DWORD PTR [rsp+12]
        or      DWORD PTR [rsp+12], 32832
        ldmxcsr DWORD PTR [rsp+12]
        movss   xmm0, DWORD PTR .LC9[rip]
        mov     edi, OFFSET FLAT:.LC10
        call    bench
        xor     eax, eax
        add     rsp, 24
        ret
.LC0:
        .long   1056964608
.LC2:
        .long   -400107883
        .long   1041313291
.LC3:
        .long   0
        .long   1083129856
.LC7:
        .long   1065353216
.LC9:
        .long   14272477
