fma_expr:
        mulss   xmm0, xmm1
        addss   xmm0, xmm2
        ret
.LC3:
        .string "a = %.10g (0x%08x)\n"
.LC4:
        .string "b = %.10g (0x%08x)\n"
.LC5:
        .string "c = %.10g (0x%08x)\n"
.LC6:
        .string "a * b + c = %.10g (hex float: %a, bits: 0x%08x)\n"
main:
        sub     rsp, 40
        mov     edi, OFFSET FLAT:.LC3
        mov     eax, 1
        movss   xmm0, DWORD PTR .LC0[rip]
        movss   DWORD PTR [rsp+20], xmm0
        movss   xmm0, DWORD PTR .LC1[rip]
        movss   DWORD PTR [rsp+24], xmm0
        movss   xmm0, DWORD PTR .LC2[rip]
        movss   DWORD PTR [rsp+28], xmm0
        movss   xmm2, DWORD PTR [rsp+28]
        movss   xmm1, DWORD PTR [rsp+24]
        movss   xmm0, DWORD PTR [rsp+20]
        call    fma_expr
        mov     esi, DWORD PTR [rsp+20]
        movss   DWORD PTR [rsp+12], xmm0
        movss   xmm0, DWORD PTR [rsp+20]
        cvtss2sd        xmm0, xmm0
        call    printf
        mov     esi, DWORD PTR [rsp+24]
        movss   xmm0, DWORD PTR [rsp+24]
        mov     edi, OFFSET FLAT:.LC4
        mov     eax, 1
        cvtss2sd        xmm0, xmm0
        call    printf
        mov     esi, DWORD PTR [rsp+28]
        movss   xmm0, DWORD PTR [rsp+28]
        mov     edi, OFFSET FLAT:.LC5
        mov     eax, 1
        cvtss2sd        xmm0, xmm0
        call    printf
        movss   xmm2, DWORD PTR [rsp+12]
        pxor    xmm1, xmm1
        mov     edi, OFFSET FLAT:.LC6
        mov     eax, 2
        cvtss2sd        xmm1, xmm2
        movd    esi, xmm2
        movapd  xmm0, xmm1
        call    printf
        xor     eax, eax
        add     rsp, 40
        ret
.LC0:
        .long   1065353217
.LC1:
        .long   1065353214
.LC2:
        .long   -1082130432
