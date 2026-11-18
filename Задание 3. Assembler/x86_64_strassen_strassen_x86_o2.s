; Target: x86-64 gcc -O2 -masm=intel

strassen_rec:
        push    r15
        movsx   r10, edi
        mov     r15, rcx
        push    r14
        push    r13
        push    r12
        push    rbp
        push    rbx
        sub     rsp, 232
        mov     QWORD PTR [rsp+48], rsi
        mov     rbp, QWORD PTR [rsp+296]
        mov     DWORD PTR [rsp+56], edx
        mov     DWORD PTR [rsp+28], r8d
        mov     QWORD PTR [rsp+104], r9
        cmp     r10d, 64
        jle     .L59
        mov     edi, r10d
        mov     rsi, QWORD PTR [rsp+48]
        mov     edx, DWORD PTR [rsp+56]
        xor     r8d, r8d
        sar     edi
        movsx   rcx, edi
        mov     QWORD PTR [rsp+168], rsi
        lea     rbx, [0+rcx*8]
        mov     QWORD PTR [rsp+112], rcx
        lea     rax, [rsi+rbx]
        mov     QWORD PTR [rsp+120], rax
        mov     eax, edx
        imul    eax, edi
        cdqe
        lea     r10, [rsi+rax*8]
        add     rax, rcx
        lea     r11, [rsi+rax*8]
        lea     rax, [r15+rbx]
        mov     QWORD PTR [rsp+128], r10
        mov     QWORD PTR [rsp+136], rax
        mov     eax, DWORD PTR [rsp+28]
        mov     QWORD PTR [rsp+72], r11
        imul    eax, edi
        mov     QWORD PTR [rsp+184], r11
        cdqe
        lea     r14, [r15+rax*8]
        add     rax, rcx
        lea     rax, [r15+rax*8]
        mov     QWORD PTR [rsp+64], rax
        mov     eax, DWORD PTR [rsp+288]
        imul    eax, edi
        cdqe
        mov     QWORD PTR [rsp+144], rax
        add     rax, rcx
        mov     QWORD PTR [rsp+152], rax
        mov     eax, edi
        imul    eax, edi
        cdqe
        sal     rax, 3
        lea     r12, [rbp+0+rax]
        lea     r13, [r12+rax]
        lea     rcx, [r13+0+rax]
        mov     QWORD PTR [rsp+80], rcx
        add     rcx, rax
        mov     QWORD PTR [rsp+88], rcx
        add     rcx, rax
        mov     QWORD PTR [rsp+96], rcx
        add     rcx, rax
        lea     r10, [rcx+rax]
        mov     QWORD PTR [rsp+160], rcx
        lea     rcx, [r10+rax]
        mov     QWORD PTR [rsp+8], r10
        add     rax, rcx
        mov     QWORD PTR [rsp+176], r10
        mov     QWORD PTR [rsp+16], rax
        movsx   rax, edx
        mov     rdx, rsi
        mov     rsi, r10
        lea     r9, [0+rax*8]
        mov     QWORD PTR [rsp], rcx
        mov     rcx, r11
        mov     QWORD PTR [rsp+40], r9
.L10:
        xor     eax, eax
.L11:
        movsd   xmm0, QWORD PTR [rdx+rax]
        addsd   xmm0, QWORD PTR [rcx+rax]
        movsd   QWORD PTR [rsi+rax], xmm0
        add     rax, 8
        cmp     rbx, rax
        jne     .L11
        add     r8d, 1
        add     rdx, r9
        add     rcx, r9
        add     rsi, rbx
        cmp     edi, r8d
        jne     .L10
        movsx   rax, DWORD PTR [rsp+28]
        mov     rcx, QWORD PTR [rsp+64]
        mov     r11, r15
        mov     rdx, r15
        mov     rsi, QWORD PTR [rsp]
        xor     r8d, r8d
        lea     r9, [0+rax*8]
        mov     QWORD PTR [rsp+200], rcx
        mov     QWORD PTR [rsp+32], r9
        mov     QWORD PTR [rsp+192], rsi
.L12:
        xor     eax, eax
.L13:
        movsd   xmm0, QWORD PTR [rdx+rax]
        addsd   xmm0, QWORD PTR [rcx+rax]
        movsd   QWORD PTR [rsi+rax], xmm0
        add     rax, 8
        cmp     rbx, rax
        jne     .L13
        add     r8d, 1
        add     rdx, r9
        add     rcx, r9
        add     rsi, rbx
        cmp     edi, r8d
        jne     .L12
        mov     QWORD PTR [rsp+216], r11
        mov     r8d, edi
        mov     edx, edi
        mov     r9, rbp
        push    QWORD PTR [rsp+16]
        push    rdi
        mov     rcx, QWORD PTR [rsp+16]
        mov     rsi, QWORD PTR [rsp+24]
        mov     DWORD PTR [rsp+224], edi
        call    strassen_rec
        mov     r10, QWORD PTR [rsp+144]
        pop     rsi
        xor     r8d, r8d
        pop     rdi
        mov     rsi, QWORD PTR [rsp+8]
        mov     rcx, QWORD PTR [rsp+72]
        mov     edi, DWORD PTR [rsp+208]
        mov     rdx, r10
        mov     r11, QWORD PTR [rsp+216]
        mov     r9, QWORD PTR [rsp+40]
.L15:
        xor     eax, eax
.L16:
        movsd   xmm0, QWORD PTR [rdx+rax]
        addsd   xmm0, QWORD PTR [rcx+rax]
        movsd   QWORD PTR [rsi+rax], xmm0
        add     rax, 8
        cmp     rbx, rax
        jne     .L16
        add     r8d, 1
        add     rdx, r9
        add     rcx, r9
        add     rsi, rbx
        cmp     edi, r8d
        jne     .L15
        mov     QWORD PTR [rsp+216], r10
        mov     edx, edi
        mov     r9, r12
        mov     rcx, r15
        mov     QWORD PTR [rsp+208], r11
        push    QWORD PTR [rsp+16]
        push    rdi
        mov     r8d, DWORD PTR [rsp+44]
        mov     rsi, QWORD PTR [rsp+24]
        mov     DWORD PTR [rsp+144], edi
        call    strassen_rec
        mov     rax, QWORD PTR [rsp+152]
        pop     rdx
        xor     r9d, r9d
        pop     rcx
        mov     edi, DWORD PTR [rsp+128]
        mov     r8, QWORD PTR [rsp]
        mov     rsi, QWORD PTR [rsp+64]
        mov     QWORD PTR [rsp+128], r14
        mov     rcx, rax
        mov     r14, QWORD PTR [rsp+32]
        mov     r10, QWORD PTR [rsp+216]
        mov     r11, QWORD PTR [rsp+208]
.L18:
        xor     edx, edx
.L19:
        movsd   xmm0, QWORD PTR [rcx+rdx]
        subsd   xmm0, QWORD PTR [rsi+rdx]
        movsd   QWORD PTR [r8+rdx], xmm0
        add     rdx, 8
        cmp     rbx, rdx
        jne     .L19
        add     r9d, 1
        add     rcx, r14
        add     rsi, r14
        add     r8, rbx
        cmp     edi, r9d
        jne     .L18
        mov     QWORD PTR [rsp+216], r10
        mov     r8d, edi
        mov     r9, r13
        mov     r14, QWORD PTR [rsp+128]
        mov     QWORD PTR [rsp+208], rax
        mov     QWORD PTR [rsp+136], r11
        push    QWORD PTR [rsp+16]
        push    rdi
        mov     rcx, QWORD PTR [rsp+16]
        mov     rsi, QWORD PTR [rsp+64]
        mov     edx, DWORD PTR [rsp+72]
        mov     DWORD PTR [rsp+144], edi
        call    strassen_rec
        pop     r11
        mov     rsi, r15
        pop     rax
        mov     r8, QWORD PTR [rsp]
        mov     r15, QWORD PTR [rsp+32]
        mov     rcx, r14
        xor     r9d, r9d
        mov     edi, DWORD PTR [rsp+128]
        mov     r10, QWORD PTR [rsp+216]
        mov     rax, QWORD PTR [rsp+208]
        mov     r11, QWORD PTR [rsp+136]
.L21:
        xor     edx, edx
.L22:
        movsd   xmm0, QWORD PTR [rcx+rdx]
        subsd   xmm0, QWORD PTR [rsi+rdx]
        movsd   QWORD PTR [r8+rdx], xmm0
        add     rdx, 8
        cmp     rbx, rdx
        jne     .L22
        add     r9d, 1
        add     rcx, r15
        add     rsi, r15
        add     r8, rbx
        cmp     edi, r9d
        jne     .L21
        mov     QWORD PTR [rsp+136], rax
        mov     r8d, edi
        mov     QWORD PTR [rsp+128], r11
        mov     QWORD PTR [rsp+208], r10
        push    QWORD PTR [rsp+16]
        push    rdi
        mov     rcx, QWORD PTR [rsp+16]
        mov     edx, DWORD PTR [rsp+72]
        mov     rsi, QWORD PTR [rsp+88]
        mov     r9, QWORD PTR [rsp+96]
        mov     DWORD PTR [rsp+72], edi
        call    strassen_rec
        mov     r15, QWORD PTR [rsp+136]
        pop     r9
        xor     r9d, r9d
        pop     r10
        mov     rcx, QWORD PTR [rsp+48]
        mov     r8, QWORD PTR [rsp+8]
        mov     QWORD PTR [rsp+48], r12
        mov     rsi, r15
        mov     edi, DWORD PTR [rsp+56]
        mov     r10, QWORD PTR [rsp+208]
        mov     rax, QWORD PTR [rsp+136]
        mov     r11, QWORD PTR [rsp+128]
        mov     r12, QWORD PTR [rsp+40]
.L24:
        xor     edx, edx
.L25:
        movsd   xmm0, QWORD PTR [rcx+rdx]
        addsd   xmm0, QWORD PTR [rsi+rdx]
        movsd   QWORD PTR [r8+rdx], xmm0
        add     rdx, 8
        cmp     rbx, rdx
        jne     .L25
        add     r9d, 1
        add     rcx, r12
        add     rsi, r12
        add     r8, rbx
        cmp     edi, r9d
        jne     .L24
        mov     QWORD PTR [rsp+72], r10
        mov     r12, QWORD PTR [rsp+48]
        mov     edx, edi
        mov     QWORD PTR [rsp+56], rax
        mov     QWORD PTR [rsp+48], r11
        push    QWORD PTR [rsp+16]
        push    rdi
        mov     r9, QWORD PTR [rsp+104]
        mov     r8d, DWORD PTR [rsp+44]
        mov     rcx, QWORD PTR [rsp+80]
        mov     rsi, QWORD PTR [rsp+24]
        mov     DWORD PTR [rsp+44], edi
        call    strassen_rec
        pop     rdi
        pop     r8
        xor     esi, esi
        mov     rcx, QWORD PTR [rsp+8]
        mov     edi, DWORD PTR [rsp+28]
        mov     r8, QWORD PTR [rsp+168]
        mov     r10, QWORD PTR [rsp+72]
        mov     rax, QWORD PTR [rsp+56]
        mov     r11, QWORD PTR [rsp+48]
        mov     r9, QWORD PTR [rsp+40]
.L27:
        xor     edx, edx
.L28:
        movsd   xmm0, QWORD PTR [r10+rdx]
        subsd   xmm0, QWORD PTR [r8+rdx]
        movsd   QWORD PTR [rcx+rdx], xmm0
        add     rdx, 8
        cmp     rbx, rdx
        jne     .L28
        add     esi, 1
        add     r10, r9
        add     r8, r9
        add     rcx, rbx
        cmp     edi, esi
        jne     .L27
        mov     rcx, QWORD PTR [rsp]
        mov     r8, QWORD PTR [rsp+32]
        xor     esi, esi
.L29:
        xor     edx, edx
.L30:
        movsd   xmm0, QWORD PTR [r11+rdx]
        addsd   xmm0, QWORD PTR [rax+rdx]
        movsd   QWORD PTR [rcx+rdx], xmm0
        add     rdx, 8
        cmp     rbx, rdx
        jne     .L30
        add     esi, 1
        add     r11, r8
        add     rax, r8
        add     rcx, rbx
        cmp     edi, esi
        jne     .L29
        push    QWORD PTR [rsp+16]
        mov     r8d, edi
        mov     edx, edi
        push    rdi
        mov     r9, QWORD PTR [rsp+112]
        mov     rcx, QWORD PTR [rsp+16]
        mov     rsi, QWORD PTR [rsp+24]
        mov     DWORD PTR [rsp+44], edi
        call    strassen_rec
        pop     rcx
        pop     rsi
        xor     edx, edx
        mov     edi, DWORD PTR [rsp+28]
        mov     rcx, QWORD PTR [rsp+176]
        mov     rsi, QWORD PTR [rsp+184]
        mov     r8, QWORD PTR [rsp+40]
.L32:
        xor     eax, eax
.L33:
        movsd   xmm0, QWORD PTR [r15+rax]
        subsd   xmm0, QWORD PTR [rsi+rax]
        movsd   QWORD PTR [rcx+rax], xmm0
        add     rax, 8
        cmp     rbx, rax
        jne     .L33
        add     edx, 1
        add     r15, r8
        add     rsi, r8
        add     rcx, rbx
        cmp     edi, edx
        jne     .L32
        mov     r8, QWORD PTR [rsp+32]
        mov     rcx, QWORD PTR [rsp+192]
        xor     edx, edx
        mov     rsi, QWORD PTR [rsp+200]
.L34:
        xor     eax, eax
.L35:
        movsd   xmm0, QWORD PTR [r14+rax]
        addsd   xmm0, QWORD PTR [rsi+rax]
        movsd   QWORD PTR [rcx+rax], xmm0
        add     rax, 8
        cmp     rbx, rax
        jne     .L35
        add     edx, 1
        add     r14, r8
        add     rsi, r8
        add     rcx, rbx
        cmp     edi, edx
        jne     .L34
        push    QWORD PTR [rsp+16]
        mov     r8d, edi
        mov     edx, edi
        push    rdi
        mov     r15, QWORD PTR [rsp+176]
        mov     rcx, QWORD PTR [rsp+16]
        mov     rsi, QWORD PTR [rsp+24]
        mov     r9, r15
        mov     DWORD PTR [rsp+16], edi
        call    strassen_rec
        mov     rsi, QWORD PTR [rsp+120]
        mov     rcx, rbx
        xor     r8d, r8d
        movsx   rax, DWORD PTR [rsp+304]
        lea     r9, [0+rax*8]
        pop     rax
        pop     rdx
        mov     edi, DWORD PTR [rsp]
        mov     QWORD PTR [rsp+16], r9
        mov     r10, QWORD PTR [rsp+112]
        mov     r14, QWORD PTR [rsp+96]
        mov     QWORD PTR [rsp], rbx
        mov     DWORD PTR [rsp+8], edi
        mov     r11, QWORD PTR [rsp+144]
        mov     rbx, QWORD PTR [rsp+152]
        mov     rdi, QWORD PTR [rsp+80]
        mov     r9, QWORD PTR [rsp+88]
.L37:
        mov     rdx, QWORD PTR [rsp]
        mov     rax, rcx
        sub     rax, rdx
        mov     rdx, rsi
.L38:
        movsd   xmm0, QWORD PTR [rbp+0+rax]
        addsd   xmm0, QWORD PTR [rdi+rax]
        subsd   xmm0, QWORD PTR [r9+rax]
        addsd   xmm0, QWORD PTR [r15+rax]
        movsd   QWORD PTR [rdx], xmm0
        movsd   xmm0, QWORD PTR [r13+0+rax]
        addsd   xmm0, QWORD PTR [r9+rax]
        movsd   QWORD PTR [rdx+r10*8], xmm0
        movsd   xmm0, QWORD PTR [r12+rax]
        addsd   xmm0, QWORD PTR [rdi+rax]
        movsd   QWORD PTR [rdx+r11*8], xmm0
        movsd   xmm0, QWORD PTR [rbp+0+rax]
        subsd   xmm0, QWORD PTR [r12+rax]
        addsd   xmm0, QWORD PTR [r13+0+rax]
        addsd   xmm0, QWORD PTR [r14+rax]
        add     rax, 8
        movsd   QWORD PTR [rdx+rbx*8], xmm0
        add     rdx, 8
        cmp     rcx, rax
        jne     .L38
        mov     rax, QWORD PTR [rsp+16]
        add     r8d, 1
        add     rsi, rax
        mov     rax, QWORD PTR [rsp]
        add     rcx, rax
        cmp     DWORD PTR [rsp+8], r8d
        jne     .L37
.L1:
        add     rsp, 232
        pop     rbx
        pop     rbp
        pop     r12
        pop     r13
        pop     r14
        pop     r15
        ret
.L59:
        test    r10d, r10d
        jle     .L1
        movsx   r11, DWORD PTR [rsp+288]
        mov     r8d, r10d
        xor     esi, esi
        xor     eax, eax
        sal     r8, 3
        mov     rdx, QWORD PTR [rsp+104]
        sal     r11, 3
        mov     r9d, r8d
.L6:
        lea     rdi, [rdx+8]
        mov     rcx, rdx
        mov     QWORD PTR [rdx], 0
        mov     QWORD PTR [rdx-8+r9], 0
        and     rdi, -8
        add     rdx, r11
        sub     rcx, rdi
        add     ecx, r8d
        shr     ecx, 3
        rep stosq
        mov     ecx, esi
        lea     esi, [rsi+1]
        cmp     r10d, esi
        jne     .L6
        movsx   rdx, DWORD PTR [rsp+56]
        mov     r9, QWORD PTR [rsp+48]
        sal     r10, 3
        xor     r12d, r12d
        mov     rsi, QWORD PTR [rsp+104]
        movsx   rbp, DWORD PTR [rsp+28]
        sal     rdx, 3
        add     r9, r10
        add     rsi, r10
        sal     rbp, 3
.L5:
        mov     r8, r9
        mov     r13, rsi
        mov     rbx, r15
        sub     r8, r10
        sub     r13, r10
.L9:
        movsd   xmm1, QWORD PTR [r8]
        mov     rdi, rbx
        mov     rax, r13
.L8:
        movsd   xmm0, QWORD PTR [rdi]
        add     rax, 8
        add     rdi, 8
        mulsd   xmm0, xmm1
        addsd   xmm0, QWORD PTR [rax-8]
        movsd   QWORD PTR [rax-8], xmm0
        cmp     rsi, rax
        jne     .L8
        add     r8, 8
        add     rbx, rbp
        cmp     r9, r8
        jne     .L9
        lea     eax, [r12+1]
        add     r9, rdx
        add     rsi, r11
        cmp     ecx, r12d
        je      .L1
        mov     r12d, eax
        jmp     .L5

strassen:
        push    r15
        push    r14
        push    r13
        push    r12
        push    rbp
        push    rbx
        sub     rsp, 56
        movsx   rbp, DWORD PTR n[rip]
        cmp     ebp, 1
        jle     .L61
        mov     r13d, 1
.L62:
        add     r13d, r13d
        cmp     r13d, ebp
        jl      .L62
        movsx   rbx, r13d
        mov     r12, rbx
        imul    r12, rbx
        lea     rdi, [r12+r12*2]
        sal     rdi, 3
        call    malloc
        mov     QWORD PTR [rsp+16], rax
        cmp     r13d, ebp
        je      .L68
        mov     rdi, r12
        mov     esi, 8
        sal     rbx, 3
        call    calloc
        mov     rdi, r12
        mov     esi, 8
        mov     QWORD PTR [rsp+40], rax
        mov     r14, rax
        call    calloc
        mov     rdi, r12
        mov     esi, 8
        mov     r15, rax
        mov     QWORD PTR [rsp+24], rax
        call    calloc
        mov     r12, r15
        xor     r15d, r15d
        mov     QWORD PTR [rsp+32], rax
        lea     rax, [0+rbp*8]
        sal     rbp, 13
        mov     QWORD PTR [rsp+8], rax
.L65:
        mov     rdx, QWORD PTR [rsp+8]
        lea     rsi, a[r15]
        mov     rdi, r14
        add     r14, rbx
        call    memcpy
        mov     rdx, QWORD PTR [rsp+8]
        lea     rsi, b[r15]
        mov     rdi, r12
        add     r15, 8192
        add     r12, rbx
        call    memcpy
        cmp     r15, rbp
        jne     .L65
        push    QWORD PTR [rsp+16]
        mov     edi, r13d
        mov     r8d, r13d
        mov     edx, r13d
        push    r13
        mov     r12, QWORD PTR [rsp+48]
        mov     rcx, QWORD PTR [rsp+40]
        mov     rsi, QWORD PTR [rsp+56]
        mov     r9, r12
        call    strassen_rec
        mov     ecx, OFFSET FLAT:c
        pop     rsi
        pop     rdi
        add     r15, rcx
.L66:
        mov     rdx, QWORD PTR [rsp+8]
        mov     rsi, r12
        mov     rdi, rcx
        add     r12, rbx
        call    memcpy
        mov     rcx, rax
        add     rcx, 8192
        cmp     r15, rcx
        jne     .L66
.L67:
        mov     rdi, QWORD PTR [rsp+40]
        call    free
        mov     rdi, QWORD PTR [rsp+24]
        call    free
        mov     rdi, QWORD PTR [rsp+32]
        call    free
.L64:
        mov     rdi, QWORD PTR [rsp+16]
        add     rsp, 56
        pop     rbx
        pop     rbp
        pop     r12
        pop     r13
        pop     r14
        pop     r15
        jmp     free
.L76:
        mov     r13d, 1
.L68:
        push    QWORD PTR [rsp+16]
        mov     r9d, OFFSET FLAT:c
        mov     r8d, 1024
        mov     ecx, OFFSET FLAT:b
        push    1024
        mov     edx, 1024
        mov     esi, OFFSET FLAT:a
        mov     edi, r13d
        call    strassen_rec
        pop     r8
        pop     r9
        jmp     .L64
.L61:
        mov     edi, 24
        call    malloc
        mov     QWORD PTR [rsp+16], rax
        cmp     ebp, 1
        je      .L76
        mov     esi, 8
        mov     edi, 1
        call    calloc
        mov     esi, 8
        mov     edi, 1
        mov     QWORD PTR [rsp+40], rax
        mov     r14, rax
        call    calloc
        mov     esi, 8
        mov     edi, 1
        mov     QWORD PTR [rsp+24], rax
        mov     rbx, rax
        call    calloc
        mov     edx, 1
        mov     rcx, rbx
        mov     rsi, r14
        mov     QWORD PTR [rsp+32], rax
        mov     r9, rax
        mov     r8d, 1
        mov     edi, 1
        push    QWORD PTR [rsp+16]
        push    1
        call    strassen_rec
        pop     rax
        pop     rdx
        jmp     .L67