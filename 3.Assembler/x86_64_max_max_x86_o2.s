; Target: x86-64 gcc -O2 -masm=intel

max2:
        cmp     esi, edi
        mov     eax, edi
        cmovge  eax, esi
        ret

max3:
        cmp     edi, edx
        mov     eax, esi
        cmovl   edi, edx
        cmp     edi, esi
        cmovge  eax, edi
        ret