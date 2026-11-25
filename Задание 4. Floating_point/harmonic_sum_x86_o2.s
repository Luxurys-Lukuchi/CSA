sum_pairwise:
        cmp     edi, esi
        je      .L74
        mov     eax, esi
        push    r15
        sub     eax, edi
        push    r14
        push    r13
        push    r12
        mov     r12d, esi
        push    rbp
        push    rbx
        mov     ebx, eax
        shr     ebx, 31
        add     ebx, eax
        sar     ebx
        sub     rsp, 40
        add     ebx, edi
        cmp     edi, ebx
        je      .L75
        test    eax, eax
        lea     edx, [rax+3]
        cmovns  edx, eax
        sar     edx, 2
        lea     r13d, [rdx+rdi]
        cmp     edi, r13d
        je      .L76
        test    eax, eax
        lea     r14d, [rax+7]
        cmovns  r14d, eax
        sar     r14d, 3
        add     r14d, edi
        cmp     edi, r14d
        je      .L77
        test    eax, eax
        lea     ebp, [rax+15]
        cmovns  ebp, eax
        sar     ebp, 4
        add     ebp, edi
        cmp     edi, ebp
        je      .L78
        test    eax, eax
        lea     r15d, [rax+31]
        cmovns  r15d, eax
        sar     r15d, 5
        add     r15d, edi
        cmp     edi, r15d
        je      .L79
        test    eax, eax
        lea     edx, [rax+63]
        cmovs   eax, edx
        sar     eax, 6
        add     eax, edi
        mov     esi, eax
        mov     DWORD PTR [rsp+16], eax
        call    sum_pairwise
        mov     eax, DWORD PTR [rsp+16]
        mov     esi, r15d
        movss   DWORD PTR [rsp+12], xmm0
        lea     edi, [rax+1]
        call    sum_pairwise
        movss   xmm1, DWORD PTR [rsp+12]
        addss   xmm1, xmm0
.L13:
        lea     edi, [r15+1]
        cmp     ebp, edi
        je      .L80
        mov     eax, ebp
        movss   DWORD PTR [rsp+16], xmm1
        sub     eax, edi
        mov     r15d, eax
        shr     r15d, 31
        add     r15d, eax
        sar     r15d
        add     r15d, edi
        mov     esi, r15d
        call    sum_pairwise
        lea     edi, [r15+1]
        mov     esi, ebp
        movss   DWORD PTR [rsp+12], xmm0
        call    sum_pairwise
        addss   xmm0, DWORD PTR [rsp+12]
        movss   xmm1, DWORD PTR [rsp+16]
.L15:
        addss   xmm0, xmm1
        movss   DWORD PTR [rsp+12], xmm0
.L11:
        lea     edi, [rbp+1]
        cmp     r14d, edi
        je      .L81
        mov     eax, r14d
        sub     eax, edi
        mov     ebp, eax
        shr     ebp, 31
        add     ebp, eax
        sar     ebp
        add     ebp, edi
        cmp     edi, ebp
        je      .L82
        test    eax, eax
        lea     r15d, [rax+3]
        cmovns  r15d, eax
        sar     r15d, 2
        add     r15d, edi
        mov     esi, r15d
        call    sum_pairwise
        lea     edi, [r15+1]
        mov     esi, ebp
        movss   DWORD PTR [rsp+16], xmm0
        call    sum_pairwise
        movss   xmm3, DWORD PTR [rsp+16]
        addss   xmm3, xmm0
        movss   DWORD PTR [rsp+16], xmm3
.L19:
        lea     edi, [rbp+1]
        mov     esi, r14d
        call    sum_pairwise
        movss   xmm1, DWORD PTR [rsp+16]
        addss   xmm1, xmm0
.L17:
        addss   xmm1, DWORD PTR [rsp+12]
.L9:
        lea     edi, [r14+1]
        cmp     r13d, edi
        je      .L83
        mov     eax, r13d
        sub     eax, edi
        mov     ebp, eax
        shr     ebp, 31
        add     ebp, eax
        sar     ebp
        add     ebp, edi
        cmp     edi, ebp
        je      .L84
        test    eax, eax
        lea     r14d, [rax+3]
        movss   DWORD PTR [rsp+16], xmm1
        cmovns  r14d, eax
        sar     r14d, 2
        add     r14d, edi
        mov     esi, r14d
        call    sum_pairwise
        lea     edi, [r14+1]
        mov     esi, ebp
        movss   DWORD PTR [rsp+12], xmm0
        call    sum_pairwise
        movss   xmm2, DWORD PTR [rsp+12]
        movss   xmm1, DWORD PTR [rsp+16]
        addss   xmm2, xmm0
.L23:
        lea     edi, [rbp+1]
        cmp     r13d, edi
        je      .L85
        mov     eax, r13d
        movss   DWORD PTR [rsp+20], xmm2
        sub     eax, edi
        movss   DWORD PTR [rsp+16], xmm1
        mov     ebp, eax
        shr     ebp, 31
        add     ebp, eax
        sar     ebp
        add     ebp, edi
        mov     esi, ebp
        call    sum_pairwise
        lea     edi, [rbp+1]
        mov     esi, r13d
        movss   DWORD PTR [rsp+12], xmm0
        call    sum_pairwise
        addss   xmm0, DWORD PTR [rsp+12]
        movss   xmm2, DWORD PTR [rsp+20]
        movss   xmm1, DWORD PTR [rsp+16]
.L25:
        addss   xmm0, xmm2
.L21:
        addss   xmm0, xmm1
        lea     edi, [r13+1]
        movss   DWORD PTR [rsp+12], xmm0
        cmp     ebx, edi
        je      .L86
.L26:
        mov     eax, ebx
        sub     eax, edi
        mov     ebp, eax
        shr     ebp, 31
        add     ebp, eax
        sar     ebp
        add     ebp, edi
        cmp     edi, ebp
        je      .L87
        test    eax, eax
        lea     r13d, [rax+3]
        cmovns  r13d, eax
        sar     r13d, 2
        add     r13d, edi
        cmp     edi, r13d
        je      .L88
        test    eax, eax
        lea     r14d, [rax+7]
        cmovns  r14d, eax
        sar     r14d, 3
        add     r14d, edi
        mov     esi, r14d
        call    sum_pairwise
        lea     edi, [r14+1]
        mov     esi, r13d
        movss   DWORD PTR [rsp+16], xmm0
        call    sum_pairwise
        movss   xmm1, DWORD PTR [rsp+16]
        addss   xmm1, xmm0
.L31:
        lea     edi, [r13+1]
        cmp     ebp, edi
        je      .L89
        mov     eax, ebp
        movss   DWORD PTR [rsp+20], xmm1
        sub     eax, edi
        mov     r13d, eax
        shr     r13d, 31
        add     r13d, eax
        sar     r13d
        add     r13d, edi
        mov     esi, r13d
        call    sum_pairwise
        lea     edi, [r13+1]
        mov     esi, ebp
        movss   DWORD PTR [rsp+16], xmm0
        call    sum_pairwise
        addss   xmm0, DWORD PTR [rsp+16]
        movss   xmm1, DWORD PTR [rsp+20]
.L33:
        movaps  xmm2, xmm0
        addss   xmm2, xmm1
.L29:
        lea     edi, [rbp+1]
        cmp     ebx, edi
        je      .L90
        mov     eax, ebx
        sub     eax, edi
        mov     ebp, eax
        shr     ebp, 31
        add     ebp, eax
        sar     ebp
        add     ebp, edi
        cmp     edi, ebp
        je      .L91
        test    eax, eax
        lea     r13d, [rax+3]
        movss   DWORD PTR [rsp+20], xmm2
        cmovns  r13d, eax
        sar     r13d, 2
        add     r13d, edi
        mov     esi, r13d
        call    sum_pairwise
        lea     edi, [r13+1]
        mov     esi, ebp
        movss   DWORD PTR [rsp+16], xmm0
        call    sum_pairwise
        movss   xmm1, DWORD PTR [rsp+16]
        movss   xmm2, DWORD PTR [rsp+20]
        addss   xmm1, xmm0
.L37:
        lea     edi, [rbp+1]
        cmp     ebx, edi
        je      .L92
        mov     eax, ebx
        movss   DWORD PTR [rsp+24], xmm1
        sub     eax, edi
        movss   DWORD PTR [rsp+20], xmm2
        mov     ebp, eax
        shr     ebp, 31
        add     ebp, eax
        sar     ebp
        add     ebp, edi
        mov     esi, ebp
        call    sum_pairwise
        lea     edi, [rbp+1]
        mov     esi, ebx
        movss   DWORD PTR [rsp+16], xmm0
        call    sum_pairwise
        addss   xmm0, DWORD PTR [rsp+16]
        movss   xmm1, DWORD PTR [rsp+24]
        movss   xmm2, DWORD PTR [rsp+20]
.L39:
        addss   xmm0, xmm1
.L35:
        addss   xmm0, xmm2
.L27:
        addss   xmm0, DWORD PTR [rsp+12]
        lea     edi, [rbx+1]
        movss   DWORD PTR [rsp+12], xmm0
        cmp     edi, r12d
        jne     .L40
.L93:
        pxor    xmm1, xmm1
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm1, r12d
        divss   xmm0, xmm1
.L41:
        addss   xmm0, DWORD PTR [rsp+12]
        add     rsp, 40
        pop     rbx
        pop     rbp
        pop     r12
        pop     r13
        pop     r14
        pop     r15
        ret
.L75:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        lea     edi, [rbx+1]
        cvtsi2ss        xmm0, ebx
        divss   xmm1, xmm0
        movss   DWORD PTR [rsp+12], xmm1
        cmp     edi, r12d
        je      .L93
.L40:
        mov     eax, r12d
        sub     eax, edi
        mov     r13d, eax
        shr     r13d, 31
        add     r13d, eax
        sar     r13d
        add     r13d, edi
        cmp     edi, r13d
        je      .L94
        test    eax, eax
        lea     ebp, [rax+3]
        cmovns  ebp, eax
        sar     ebp, 2
        add     ebp, edi
        cmp     edi, ebp
        je      .L95
        test    eax, eax
        lea     r14d, [rax+7]
        cmovns  r14d, eax
        sar     r14d, 3
        add     r14d, edi
        cmp     edi, r14d
        je      .L96
        test    eax, eax
        lea     ebx, [rax+15]
        cmovns  ebx, eax
        sar     ebx, 4
        add     ebx, edi
        mov     esi, ebx
        call    sum_pairwise
        lea     edi, [rbx+1]
        mov     esi, r14d
        movss   DWORD PTR [rsp+16], xmm0
        call    sum_pairwise
        movss   xmm2, DWORD PTR [rsp+16]
        addss   xmm2, xmm0
.L47:
        lea     edi, [r14+1]
        cmp     ebp, edi
        je      .L97
        mov     eax, ebp
        movss   DWORD PTR [rsp+20], xmm2
        sub     eax, edi
        mov     ebx, eax
        shr     ebx, 31
        add     ebx, eax
        sar     ebx
        add     ebx, edi
        mov     esi, ebx
        call    sum_pairwise
        lea     edi, [rbx+1]
        mov     esi, ebp
        movss   DWORD PTR [rsp+16], xmm0
        call    sum_pairwise
        movss   xmm1, DWORD PTR [rsp+16]
        movss   xmm2, DWORD PTR [rsp+20]
        addss   xmm1, xmm0
.L49:
        addss   xmm1, xmm2
.L45:
        lea     edi, [rbp+1]
        cmp     r13d, edi
        je      .L98
        mov     eax, r13d
        sub     eax, edi
        mov     ebx, eax
        shr     ebx, 31
        add     ebx, eax
        sar     ebx
        add     ebx, edi
        cmp     edi, ebx
        je      .L99
        test    eax, eax
        lea     ebp, [rax+3]
        movss   DWORD PTR [rsp+20], xmm1
        cmovns  ebp, eax
        sar     ebp, 2
        add     ebp, edi
        mov     esi, ebp
        call    sum_pairwise
        lea     edi, [rbp+1]
        mov     esi, ebx
        movss   DWORD PTR [rsp+16], xmm0
        call    sum_pairwise
        movss   xmm2, DWORD PTR [rsp+16]
        movss   xmm1, DWORD PTR [rsp+20]
        addss   xmm2, xmm0
.L53:
        lea     edi, [rbx+1]
        cmp     r13d, edi
        je      .L100
        mov     eax, r13d
        movss   DWORD PTR [rsp+24], xmm2
        sub     eax, edi
        movss   DWORD PTR [rsp+20], xmm1
        mov     ebx, eax
        shr     ebx, 31
        add     ebx, eax
        sar     ebx
        add     ebx, edi
        mov     esi, ebx
        call    sum_pairwise
        lea     edi, [rbx+1]
        mov     esi, r13d
        movss   DWORD PTR [rsp+16], xmm0
        call    sum_pairwise
        addss   xmm0, DWORD PTR [rsp+16]
        movss   xmm2, DWORD PTR [rsp+24]
        movss   xmm1, DWORD PTR [rsp+20]
.L55:
        addss   xmm0, xmm2
.L51:
        addss   xmm0, xmm1
        lea     edi, [r13+1]
        movss   DWORD PTR [rsp+16], xmm0
        cmp     r12d, edi
        je      .L101
.L56:
        mov     eax, r12d
        sub     eax, edi
        mov     ebx, eax
        shr     ebx, 31
        add     ebx, eax
        sar     ebx
        add     ebx, edi
        cmp     edi, ebx
        je      .L102
        test    eax, eax
        lea     ebp, [rax+3]
        cmovns  ebp, eax
        sar     ebp, 2
        add     ebp, edi
        cmp     edi, ebp
        je      .L103
        test    eax, eax
        lea     r13d, [rax+7]
        cmovns  r13d, eax
        sar     r13d, 3
        add     r13d, edi
        mov     esi, r13d
        call    sum_pairwise
        lea     edi, [r13+1]
        mov     esi, ebp
        movss   DWORD PTR [rsp+20], xmm0
        call    sum_pairwise
        movss   xmm2, DWORD PTR [rsp+20]
        addss   xmm2, xmm0
.L61:
        lea     edi, [rbp+1]
        cmp     ebx, edi
        je      .L104
        mov     eax, ebx
        movss   DWORD PTR [rsp+24], xmm2
        sub     eax, edi
        mov     ebp, eax
        shr     ebp, 31
        add     ebp, eax
        sar     ebp
        add     ebp, edi
        mov     esi, ebp
        call    sum_pairwise
        lea     edi, [rbp+1]
        mov     esi, ebx
        movss   DWORD PTR [rsp+20], xmm0
        call    sum_pairwise
        movss   xmm1, DWORD PTR [rsp+20]
        movss   xmm2, DWORD PTR [rsp+24]
        addss   xmm1, xmm0
.L63:
        addss   xmm1, xmm2
.L59:
        lea     edi, [rbx+1]
        cmp     r12d, edi
        je      .L105
        mov     eax, r12d
        sub     eax, edi
        mov     ebx, eax
        shr     ebx, 31
        add     ebx, eax
        sar     ebx
        add     ebx, edi
        cmp     edi, ebx
        je      .L106
        test    eax, eax
        lea     ebp, [rax+3]
        movss   DWORD PTR [rsp+24], xmm1
        cmovns  ebp, eax
        sar     ebp, 2
        add     ebp, edi
        mov     esi, ebp
        call    sum_pairwise
        lea     edi, [rbp+1]
        mov     esi, ebx
        movss   DWORD PTR [rsp+20], xmm0
        call    sum_pairwise
        movss   xmm2, DWORD PTR [rsp+20]
        movss   xmm1, DWORD PTR [rsp+24]
        addss   xmm2, xmm0
.L67:
        lea     edi, [rbx+1]
        cmp     r12d, edi
        je      .L107
        mov     eax, r12d
        movss   DWORD PTR [rsp+28], xmm2
        sub     eax, edi
        movss   DWORD PTR [rsp+24], xmm1
        mov     ebx, eax
        shr     ebx, 31
        add     ebx, eax
        sar     ebx
        add     ebx, edi
        mov     esi, ebx
        call    sum_pairwise
        lea     edi, [rbx+1]
        mov     esi, r12d
        movss   DWORD PTR [rsp+20], xmm0
        call    sum_pairwise
        addss   xmm0, DWORD PTR [rsp+20]
        movss   xmm2, DWORD PTR [rsp+28]
        movss   xmm1, DWORD PTR [rsp+24]
.L69:
        addss   xmm0, xmm2
.L65:
        addss   xmm0, xmm1
.L57:
        addss   xmm0, DWORD PTR [rsp+16]
        jmp     .L41
.L74:
        pxor    xmm1, xmm1
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm1, edi
        divss   xmm0, xmm1
        ret
.L95:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebp
        divss   xmm1, xmm0
        jmp     .L45
.L77:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, r14d
        divss   xmm1, xmm0
        jmp     .L9
.L94:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        lea     edi, [r13+1]
        cvtsi2ss        xmm0, r13d
        divss   xmm1, xmm0
        movss   DWORD PTR [rsp+16], xmm1
        cmp     r12d, edi
        jne     .L56
.L101:
        pxor    xmm1, xmm1
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm1, r12d
        divss   xmm0, xmm1
        jmp     .L57
.L76:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        lea     edi, [r13+1]
        cvtsi2ss        xmm0, r13d
        divss   xmm1, xmm0
        movss   DWORD PTR [rsp+12], xmm1
        cmp     ebx, edi
        jne     .L26
.L86:
        pxor    xmm1, xmm1
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm1, ebx
        divss   xmm0, xmm1
        jmp     .L27
.L102:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebx
        divss   xmm1, xmm0
        jmp     .L59
.L98:
        pxor    xmm2, xmm2
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm2, r13d
        divss   xmm0, xmm2
        jmp     .L51
.L87:
        pxor    xmm1, xmm1
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm1, ebp
        movaps  xmm2, xmm0
        divss   xmm2, xmm1
        jmp     .L29
.L83:
        pxor    xmm2, xmm2
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm2, r13d
        divss   xmm0, xmm2
        jmp     .L21
.L105:
        pxor    xmm2, xmm2
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm2, r12d
        divss   xmm0, xmm2
        jmp     .L65
.L90:
        pxor    xmm1, xmm1
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm1, ebx
        divss   xmm0, xmm1
        jmp     .L35
.L104:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebx
        divss   xmm1, xmm0
        jmp     .L63
.L89:
        pxor    xmm2, xmm2
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm2, ebp
        divss   xmm0, xmm2
        jmp     .L33
.L92:
        pxor    xmm3, xmm3
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm3, ebx
        divss   xmm0, xmm3
        jmp     .L39
.L91:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebp
        divss   xmm1, xmm0
        jmp     .L37
.L100:
        pxor    xmm3, xmm3
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm3, r13d
        divss   xmm0, xmm3
        jmp     .L55
.L85:
        pxor    xmm3, xmm3
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm3, r13d
        divss   xmm0, xmm3
        jmp     .L25
.L107:
        pxor    xmm3, xmm3
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm3, r12d
        divss   xmm0, xmm3
        jmp     .L69
.L106:
        pxor    xmm0, xmm0
        movss   xmm2, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebx
        divss   xmm2, xmm0
        jmp     .L67
.L88:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, r13d
        divss   xmm1, xmm0
        jmp     .L31
.L84:
        pxor    xmm0, xmm0
        movss   xmm2, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebp
        divss   xmm2, xmm0
        jmp     .L23
.L81:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, r14d
        divss   xmm1, xmm0
        jmp     .L17
.L78:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebp
        divss   xmm1, xmm0
        movss   DWORD PTR [rsp+12], xmm1
        jmp     .L11
.L103:
        pxor    xmm0, xmm0
        movss   xmm2, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebp
        divss   xmm2, xmm0
        jmp     .L61
.L99:
        pxor    xmm0, xmm0
        movss   xmm2, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebx
        divss   xmm2, xmm0
        jmp     .L53
.L97:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebp
        divss   xmm1, xmm0
        jmp     .L49
.L96:
        pxor    xmm0, xmm0
        movss   xmm2, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, r14d
        divss   xmm2, xmm0
        jmp     .L47
.L79:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, r15d
        divss   xmm1, xmm0
        jmp     .L13
.L82:
        pxor    xmm0, xmm0
        movss   xmm1, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm0, ebp
        divss   xmm1, xmm0
        movss   DWORD PTR [rsp+16], xmm1
        jmp     .L19
.L80:
        pxor    xmm2, xmm2
        movss   xmm0, DWORD PTR .LC0[rip]
        cvtsi2ss        xmm2, ebp
        divss   xmm0, xmm2
        jmp     .L15
.LC8:
        .string "Reference (long double): %.12Lf\n\n"
.LC9:
        .string "Rel. error"
.LC10:
        .string "Result (float)"
.LC11:
        .string "Method"
.LC12:
        .string "%-12s | %-14s | %-14s\n"
.LC13:
        .string "-------------|----------------|----------------"
.LC14:
        .string "Forward"
.LC15:
        .string "%-12s | %-14.8f | %.6e\n"
.LC16:
        .string "Backward"
.LC17:
        .string "Pairwise"
.LC18:
        .string "Kahan"
main:
        fldz
        sub     rsp, 56
        mov     eax, 10000000
        fld1
.L109:
        mov     DWORD PTR [rsp+32], eax
        fild    DWORD PTR [rsp+32]
        fdivr   st, st(1)
        faddp   st(2), st
        sub     eax, 1
        jne     .L109
        fstp    st(0)
        movss   xmm3, DWORD PTR .LC0[rip]
        mov     edx, 4
        xor     eax, eax
        pxor    xmm4, xmm4
        movdqa  xmm5, XMMWORD PTR .LC2[rip]
        movd    xmm6, edx
        shufps  xmm3, xmm3, 0
        pshufd  xmm6, xmm6, 0
.L110:
        movdqa  xmm1, xmm5
        movaps  xmm0, xmm3
        paddd   xmm5, xmm6
        add     eax, 1
        cvtdq2ps        xmm1, xmm1
        divps   xmm0, xmm1
        movaps  xmm1, xmm0
        movaps  xmm2, xmm0
        addss   xmm1, xmm4
        shufps  xmm2, xmm0, 85
        addss   xmm1, xmm2
        movaps  xmm2, xmm0
        unpckhps        xmm2, xmm0
        shufps  xmm0, xmm0, 255
        addss   xmm1, xmm2
        movaps  xmm4, xmm1
        addss   xmm4, xmm0
        cmp     eax, 2500000
        jne     .L110
        mov     ecx, -4
        movdqa  xmm5, XMMWORD PTR .LC3[rip]
        xor     eax, eax
        pxor    xmm2, xmm2
        movd    xmm6, ecx
        pshufd  xmm6, xmm6, 0
.L111:
        movdqa  xmm1, xmm5
        movaps  xmm0, xmm3
        paddd   xmm5, xmm6
        add     eax, 1
        cvtdq2ps        xmm1, xmm1
        divps   xmm0, xmm1
        movaps  xmm1, xmm0
        addss   xmm1, xmm2
        movaps  xmm2, xmm0
        shufps  xmm2, xmm0, 85
        addss   xmm2, xmm1
        movaps  xmm1, xmm0
        unpckhps        xmm1, xmm0
        shufps  xmm0, xmm0, 255
        addss   xmm2, xmm1
        addss   xmm2, xmm0
        cmp     eax, 2500000
        jne     .L111
        mov     esi, 10000000
        mov     edi, 1
        fstp    TBYTE PTR [rsp+16]
        movss   DWORD PTR [rsp], xmm2
        call    sum_pairwise
        fld     TBYTE PTR [rsp+16]
        pxor    xmm3, xmm3
        movss   xmm6, DWORD PTR .LC0[rip]
        movss   xmm2, DWORD PTR [rsp]
        movss   DWORD PTR [rsp+32], xmm0
        mov     eax, 1
        movaps  xmm1, xmm3
.L112:
        pxor    xmm5, xmm5
        movaps  xmm0, xmm6
        cvtsi2ss        xmm5, eax
        add     eax, 1
        divss   xmm0, xmm5
        movaps  xmm5, xmm3
        subss   xmm0, xmm1
        addss   xmm3, xmm0
        movaps  xmm1, xmm3
        subss   xmm1, xmm5
        subss   xmm1, xmm0
        cmp     eax, 10000001
        jne     .L112
        movss   DWORD PTR [rsp+16], xmm4
        sub     rsp, 16
        mov     edi, OFFSET FLAT:.LC8
        xor     eax, eax
        movss   DWORD PTR [rsp+60], xmm2
        movss   DWORD PTR [rsp+56], xmm3
        fld     st(0)
        fstp    TBYTE PTR [rsp]
        fstp    TBYTE PTR [rsp+16]
        call    printf
        mov     ecx, OFFSET FLAT:.LC9
        mov     edx, OFFSET FLAT:.LC10
        xor     eax, eax
        mov     esi, OFFSET FLAT:.LC11
        mov     edi, OFFSET FLAT:.LC12
        call    printf
        mov     edi, OFFSET FLAT:.LC13
        call    puts
        fld     TBYTE PTR [rsp+16]
        movss   xmm4, DWORD PTR [rsp+32]
        mov     esi, OFFSET FLAT:.LC14
        mov     edi, OFFSET FLAT:.LC15
        pxor    xmm0, xmm0
        mov     eax, 2
        movss   DWORD PTR [rsp+16], xmm4
        cvtss2sd        xmm0, xmm4
        fld     st(0)
        fsubr   DWORD PTR [rsp+16]
        fabs
        fdiv    st, st(1)
        fxch    st(1)
        fstp    TBYTE PTR [rsp+32]
        fstp    QWORD PTR [rsp+16]
        movsd   xmm1, QWORD PTR [rsp+16]
        call    printf
        fld     TBYTE PTR [rsp+32]
        movss   xmm2, DWORD PTR [rsp+60]
        mov     esi, OFFSET FLAT:.LC16
        mov     edi, OFFSET FLAT:.LC15
        pxor    xmm0, xmm0
        mov     eax, 2
        movss   DWORD PTR [rsp+16], xmm2
        cvtss2sd        xmm0, xmm2
        fld     st(0)
        fsubr   DWORD PTR [rsp+16]
        fabs
        fdivrp  st(1), st
        fstp    QWORD PTR [rsp+16]
        movsd   xmm1, QWORD PTR [rsp+16]
        call    printf
        fld     TBYTE PTR [rsp+32]
        mov     esi, OFFSET FLAT:.LC17
        mov     edi, OFFSET FLAT:.LC15
        pxor    xmm0, xmm0
        mov     eax, 2
        cvtss2sd        xmm0, DWORD PTR [rsp+48]
        fld     st(0)
        fsubr   DWORD PTR [rsp+48]
        fabs
        fdivrp  st(1), st
        fstp    QWORD PTR [rsp+16]
        movsd   xmm1, QWORD PTR [rsp+16]
        call    printf
        fld     TBYTE PTR [rsp+32]
        movss   xmm3, DWORD PTR [rsp+56]
        pxor    xmm0, xmm0
        mov     esi, OFFSET FLAT:.LC18
        mov     edi, OFFSET FLAT:.LC15
        mov     eax, 2
        movss   DWORD PTR [rsp+48], xmm3
        cvtss2sd        xmm0, xmm3
        fld     st(0)
        fsubr   DWORD PTR [rsp+48]
        fabs
        fdivrp  st(1), st
        fstp    QWORD PTR [rsp+48]
        movsd   xmm1, QWORD PTR [rsp+48]
        call    printf
        xor     eax, eax
        add     rsp, 72
        ret
.LC0:
        .long   1065353216
.LC2:
        .long   1
        .long   2
        .long   3
        .long   4
.LC3:
        .long   10000000
        .long   9999999
        .long   9999998
        .long   9999997
