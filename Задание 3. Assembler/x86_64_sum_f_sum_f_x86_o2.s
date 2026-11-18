; Target: x86-64 gcc -O2 -masm=intel

sum:
        test    rsi, rsi
        jle     .L4
        lea     rdx, [rdi+rsi*8]
        xor     eax, eax
.L3:
        add     rax, QWORD PTR [rdi]
        add     rdi, 8
        cmp     rdi, rdx
        jne     .L3
        ret
.L4:
        xor     eax, eax
        ret

f:
        test    rdi, rdi
        jle     .L4
        xor     eax, eax
        xor     edx, edx
.L3:
        mov     rcx, rax
        imul    rcx, rax
        add     rax, 1
        add     rdx, rcx
        cmp     rdi, rax
        jne     .L3
        mov     rax, rdx
        ret
.L4:
        xor     edx, edx
        mov     rax, rdx
        ret