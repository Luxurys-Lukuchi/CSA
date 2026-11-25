f2c:
        subss   xmm0, DWORD PTR .LC0[rip]
        mulss   xmm0, DWORD PTR .LC1[rip]
        ret
sqrt_demo:
        pxor    xmm0, xmm0
        pxor    xmm1, xmm1
        cvtsi2ss        xmm0, edi
        comiss  xmm0, xmm1
        jb      .L4
        sqrtss  xmm0, xmm0
.L4:
        cvttss2si       eax, xmm0
        movss   DWORD PTR [rsi], xmm0
        mov     DWORD PTR [rdx], eax
        ret
e_const:
        movsd   xmm1, QWORD PTR .LC3[rip]
        movapd  xmm3, xmm0
        mov     eax, 1
        comisd  xmm1, xmm3
        movapd  xmm0, xmm1
        jb      .L7
.L10:
        pxor    xmm2, xmm2
        cvtsi2sd        xmm2, eax
        add     eax, 1
        divsd   xmm1, xmm2
        comisd  xmm1, xmm3
        addsd   xmm0, xmm1
        jnb     .L10
.L7:
        ret
add_ld:
        fld     TBYTE PTR [rsp+8]
        fld     TBYTE PTR [rsp+24]
        faddp   st(1), st
        ret
.LC5:
        .string "f2c(32)  = %.9g\n"
.LC8:
        .string "f2c(212) = %.9g\n"
.LC10:
        .string "f2c(-40) = %.9g\n"
.LC12:
        .string "sqrt_demo(%d): dst = %.9g, idst = %d\n"
.LC16:
        .string "e_const(%.0e) = %.17g (M_E = %.17g)\n"
.LC17:
        .string "add_ld(1, 2) = %.21Lg\n"
main:
        push    rbp
        pxor    xmm0, xmm0
        mov     edi, OFFSET FLAT:.LC5
        mov     eax, 1
        push    rbx
        sub     rsp, 72
        call    printf
        mov     edi, OFFSET FLAT:.LC8
        mov     eax, 1
        movsd   xmm0, QWORD PTR .LC7[rip]
        lea     rbx, [rsp+16]
        lea     rbp, [rsp+28]
        call    printf
        mov     edi, OFFSET FLAT:.LC10
        mov     eax, 1
        movsd   xmm0, QWORD PTR .LC9[rip]
        call    printf
        mov     rax, QWORD PTR .LC11[rip]
        mov     DWORD PTR [rsp+24], -1
        mov     QWORD PTR [rsp+16], rax
.L19:
        mov     esi, DWORD PTR [rbx]
        pxor    xmm0, xmm0
        pxor    xmm5, xmm5
        cvtsi2ss        xmm0, esi
        comiss  xmm0, xmm5
        jb      .L17
        sqrtss  xmm0, xmm0
.L17:
        cvttss2si       edx, xmm0
        mov     edi, OFFSET FLAT:.LC12
        add     rbx, 4
        cvtss2sd        xmm0, xmm0
        mov     eax, 1
        call    printf
        cmp     rbx, rbp
        jne     .L19
        mov     rax, QWORD PTR .LC14[rip]
        lea     rbx, [rsp+32]
        lea     rbp, [rsp+56]
        movapd  xmm0, XMMWORD PTR .LC13[rip]
        movsd   xmm4, QWORD PTR .LC3[rip]
        mov     QWORD PTR [rsp+48], rax
        movaps  XMMWORD PTR [rsp+32], xmm0
.L23:
        movsd   xmm3, QWORD PTR [rbx]
        movapd  xmm1, xmm4
        movapd  xmm0, xmm4
        mov     eax, 1
        comisd  xmm4, xmm3
        jb      .L20
.L22:
        pxor    xmm2, xmm2
        cvtsi2sd        xmm2, eax
        add     eax, 1
        divsd   xmm0, xmm2
        comisd  xmm0, xmm3
        addsd   xmm1, xmm0
        jnb     .L22
.L20:
        movsd   xmm2, QWORD PTR .LC15[rip]
        movapd  xmm0, xmm3
        mov     edi, OFFSET FLAT:.LC16
        mov     eax, 3
        add     rbx, 8
        call    printf
        cmp     rbx, rbp
        movsd   xmm4, QWORD PTR .LC3[rip]
        jne     .L23
        fld     DWORD PTR .LC18[rip]
        mov     edi, OFFSET FLAT:.LC17
        xor     eax, eax
        fstp    TBYTE PTR [rsp]
        push    QWORD PTR [rsp+8]
        push    QWORD PTR [rsp+8]
        call    printf
        add     rsp, 88
        xor     eax, eax
        pop     rbx
        pop     rbp
        ret
.LC0:
        .long   1107296256
.LC1:
        .long   1057896676
.LC3:
        .long   0
        .long   1072693248
.LC7:
        .long   536870912
        .long   1079574528
.LC9:
        .long   0
        .long   -1069285376
.LC11:
        .long   100
        .long   2
.LC13:
        .long   -1598689907
        .long   1051772663
        .long   -2127697391
        .long   1030854553
.LC14:
        .long   -1747416644
        .long   1016910514
.LC15:
        .long   -1961601175
        .long   1074118410
.LC18:
        .long   1077936128
