.LC0:
        .string "%-14g s=%u e=%3u (2^%4d) m=0x%06x\n"
print_float:
        movd    r8d, xmm0
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 1
        cvtss2sd        xmm0, xmm0
        mov     edx, r8d
        mov     esi, r8d
        and     r8d, 8388607
        shr     edx, 23
        shr     esi, 31
        movzx   edx, dl
        lea     ecx, [rdx-127]
        jmp     printf
main:
        sub     rsp, 24
        movss   xmm0, DWORD PTR .LC2[rip]
        mov     DWORD PTR [rsp+12], 0x00000000
        call    print_float
        movss   xmm0, DWORD PTR .LC3[rip]
        call    print_float
        movss   xmm0, DWORD PTR .LC4[rip]
        call    print_float
        movss   xmm0, DWORD PTR .LC5[rip]
        call    print_float
        movss   xmm1, DWORD PTR [rsp+12]
        movss   xmm0, DWORD PTR .LC2[rip]
        divss   xmm0, xmm1
        call    print_float
        movss   xmm0, DWORD PTR [rsp+12]
        movss   xmm1, DWORD PTR [rsp+12]
        divss   xmm0, xmm1
        call    print_float
        xor     eax, eax
        add     rsp, 24
        ret
.LC2:
        .long   1065353216
.LC3:
        .long   -1060634624
.LC4:
        .long   1036831949
.LC5:
        .long   71362
