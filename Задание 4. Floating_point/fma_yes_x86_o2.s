fma_expr:
        vfmadd132ss     xmm0, xmm2, xmm1
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
        vmovss  xmm0, DWORD PTR .LC0[rip]
        vmovss  DWORD PTR [rsp+20], xmm0
        vmovss  xmm0, DWORD PTR .LC1[rip]
        vmovss  DWORD PTR [rsp+24], xmm0
        vmovss  xmm0, DWORD PTR .LC2[rip]
        vmovss  DWORD PTR [rsp+28], xmm0
        vmovss  xmm2, DWORD PTR [rsp+28]
        vmovss  xmm1, DWORD PTR [rsp+24]
        vmovss  xmm0, DWORD PTR [rsp+20]
        call    fma_expr
        mov     esi, DWORD PTR [rsp+20]
        vmovss  DWORD PTR [rsp+12], xmm0
        vmovss  xmm0, DWORD PTR [rsp+20]
        vcvtss2sd       xmm0, xmm0, xmm0
        call    printf
        mov     esi, DWORD PTR [rsp+24]
        vmovss  xmm0, DWORD PTR [rsp+24]
        mov     edi, OFFSET FLAT:.LC4
        mov     eax, 1
        vcvtss2sd       xmm0, xmm0, xmm0
        call    printf
        mov     esi, DWORD PTR [rsp+28]
        vmovss  xmm0, DWORD PTR [rsp+28]
        mov     edi, OFFSET FLAT:.LC5
        mov     eax, 1
        vcvtss2sd       xmm0, xmm0, xmm0
        call    printf
        vmovss  xmm2, DWORD PTR [rsp+12]
        mov     edi, OFFSET FLAT:.LC6
        mov     eax, 2
        vcvtss2sd       xmm1, xmm2, xmm2
        movd    esi, xmm2
        vmovapd xmm0, xmm1
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
