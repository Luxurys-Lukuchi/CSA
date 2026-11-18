; Target: x86-64 gcc -O2 -masm=intel

mul_ijk:
        movsx   rax, DWORD PTR n[rip]
        test    eax, eax
        jle     .L9
        lea     r11, [rax+rax*2]
        mov     r8d, OFFSET FLAT:a
        push    rbx
        mov     r10d, OFFSET FLAT:c
        sal     r11, 11
        lea     r9, b[0+rax*8]
        lea     rbx, [r11+r8]
        add     r11, OFFSET FLAT:b
.L3:
        mov     rcx, r11
        mov     esi, OFFSET FLAT:b
        mov     rdi, r10
.L6:
        mov     rax, rsi
        mov     rdx, r8
        pxor    xmm1, xmm1
.L4:
        movsd   xmm0, QWORD PTR [rdx]
        mulsd   xmm0, QWORD PTR [rax]
        add     rax, 6144
        add     rdx, 8
        addsd   xmm1, xmm0
        cmp     rax, rcx
        jne     .L4
        add     rsi, 8
        movsd   QWORD PTR [rdi], xmm1
        lea     rcx, [rax+8]
        add     rdi, 8
        cmp     rsi, r9
        jne     .L6
        add     r8, 6144
        add     r10, 6144
        cmp     r8, rbx
        jne     .L3
        pop     rbx
        ret
.L9:
        ret

mul_ikj:
        movsx   rsi, DWORD PTR n[rip]
        test    esi, esi
        jle     .L13
        lea     r8, [rsi+rsi*2]
        xor     edx, edx
        sal     rsi, 3
        sal     r8, 11
.L15:
        lea     rdi, a[rdx]
        xor     ecx, ecx
.L17:
        movsd   xmm1, QWORD PTR [rdi]
        xor     eax, eax
.L16:
        movsd   xmm0, QWORD PTR b[rcx+rax]
        mulsd   xmm0, xmm1
        addsd   xmm0, QWORD PTR c[rax+rdx]
        movsd   QWORD PTR c[rdx+rax], xmm0
        add     rax, 8
        cmp     rsi, rax
        jne     .L16
        add     rcx, 6144
        add     rdi, 8
        cmp     rcx, r8
        jne     .L17
        add     rdx, 6144
        cmp     rdx, r8
        jne     .L15
.L13:
        ret