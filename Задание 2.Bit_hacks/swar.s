	.file	"bits.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.def	_cmp_double;	.scl	3;	.type	32;	.endef
_cmp_double:
LFB72:
	.cfi_startproc
	mov	eax, DWORD PTR [esp+4]
	fld	QWORD PTR [eax]
	mov	eax, DWORD PTR [esp+8]
	fld	QWORD PTR [eax]
	fxch	st(1)
	xor	eax, eax
	fcomi	st, st(1)
	fxch	st(1)
	seta	al
	xor	edx, edx
	fcomip	st, st(1)
	fstp	st(0)
	seta	dl
	sub	eax, edx
	ret
	.cfi_endproc
LFE72:
	.p2align 4
	.def	_printf;	.scl	3;	.type	32;	.endef
_printf:
LFB9:
	.cfi_startproc
	push	ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	sub	esp, 24
	.cfi_def_cfa_offset 32
	mov	DWORD PTR [esp], 1
	lea	ebx, [esp+36]
	call	[DWORD PTR __imp____acrt_iob_func]
	mov	edx, DWORD PTR [esp+32]
	mov	DWORD PTR [esp+8], ebx
	mov	DWORD PTR [esp], eax
	mov	DWORD PTR [esp+4], edx
	call	___mingw_vfprintf
	add	esp, 24
	.cfi_def_cfa_offset 8
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
LFE9:
	.p2align 4
	.globl	_bswap32
	.def	_bswap32;	.scl	2;	.type	32;	.endef
_bswap32:
LFB58:
	.cfi_startproc
	mov	eax, DWORD PTR [esp+4]
	bswap	eax
	ret
	.cfi_endproc
LFE58:
	.p2align 4
	.globl	_is_pow2
	.def	_is_pow2;	.scl	2;	.type	32;	.endef
_is_pow2:
LFB59:
	.cfi_startproc
	push	edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	push	esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	push	ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	ecx, DWORD PTR [esp+16]
	mov	ebx, DWORD PTR [esp+20]
	mov	eax, ecx
	add	eax, -1
	mov	edx, ebx
	adc	edx, -1
	and	eax, ecx
	and	edx, ebx
	or	eax, edx
	sete	al
	mov	esi, eax
	mov	eax, ecx
	or	eax, ebx
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	setne	al
	movzx	eax, al
	and	eax, esi
	pop	esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	pop	edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
LFE59:
	.p2align 4
	.globl	_parity32
	.def	_parity32;	.scl	2;	.type	32;	.endef
_parity32:
LFB60:
	.cfi_startproc
	mov	edx, DWORD PTR [esp+4]
	mov	eax, edx
	shr	eax, 16
	xor	eax, edx
	mov	edx, eax
	shr	edx, 8
	xor	edx, eax
	mov	eax, edx
	shr	eax, 4
	xor	eax, edx
	mov	edx, eax
	shr	edx, 2
	xor	edx, eax
	mov	eax, edx
	shr	eax
	xor	eax, edx
	and	eax, 1
	ret
	.cfi_endproc
LFE60:
	.p2align 4
	.globl	_popcount32
	.def	_popcount32;	.scl	2;	.type	32;	.endef
_popcount32:
LFB61:
	.cfi_startproc
	mov	eax, DWORD PTR [esp+4]
	mov	edx, eax
	shr	edx
	and	edx, 1431655765
	sub	eax, edx
	mov	edx, eax
	shr	eax, 2
	and	eax, 858993459
	and	edx, 858993459
	add	edx, eax
	mov	eax, edx
	shr	eax, 4
	add	eax, edx
	and	eax, 252645135
	imul	eax, eax, 16843009
	shr	eax, 24
	ret
	.cfi_endproc
LFE61:
	.p2align 4
	.globl	_ctz32
	.def	_ctz32;	.scl	2;	.type	32;	.endef
_ctz32:
LFB62:
	.cfi_startproc
	mov	edx, DWORD PTR [esp+4]
	mov	eax, edx
	neg	eax
	and	eax, edx
	sub	eax, 1
	mov	edx, eax
	shr	edx
	and	edx, 1431655765
	sub	eax, edx
	mov	edx, eax
	shr	eax, 2
	and	eax, 858993459
	and	edx, 858993459
	add	edx, eax
	mov	eax, edx
	shr	eax, 4
	add	eax, edx
	and	eax, 252645135
	imul	eax, eax, 16843009
	shr	eax, 24
	ret
	.cfi_endproc
LFE62:
	.p2align 4
	.globl	_clz32
	.def	_clz32;	.scl	2;	.type	32;	.endef
_clz32:
LFB63:
	.cfi_startproc
	mov	edx, DWORD PTR [esp+4]
	mov	eax, edx
	shr	eax
	or	eax, edx
	mov	edx, eax
	shr	edx, 2
	or	edx, eax
	mov	eax, edx
	shr	eax, 4
	or	eax, edx
	mov	edx, eax
	shr	edx, 8
	or	edx, eax
	mov	eax, edx
	shr	eax, 16
	or	eax, edx
	not	eax
	mov	edx, eax
	shr	edx
	and	edx, 1431655765
	sub	eax, edx
	mov	edx, eax
	shr	eax, 2
	and	eax, 858993459
	and	edx, 858993459
	add	edx, eax
	mov	eax, edx
	shr	eax, 4
	add	eax, edx
	and	eax, 252645135
	imul	eax, eax, 16843009
	shr	eax, 24
	ret
	.cfi_endproc
LFE63:
	.p2align 4
	.globl	_next_pow2
	.def	_next_pow2;	.scl	2;	.type	32;	.endef
_next_pow2:
LFB64:
	.cfi_startproc
	push	ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	mov	eax, DWORD PTR [esp+8]
	mov	edx, DWORD PTR [esp+12]
	mov	ecx, eax
	or	ecx, edx
	sete	cl
	add	eax, -1
	movzx	ecx, cl
	adc	edx, -1
	add	eax, ecx
	adc	edx, 0
	mov	ecx, eax
	mov	ebx, edx
	shrd	ecx, ebx, 1
	shr	ebx
	or	ecx, eax
	or	ebx, edx
	mov	edx, ebx
	mov	eax, ecx
	shrd	eax, edx, 2
	shr	edx, 2
	or	eax, ecx
	or	edx, ebx
	mov	ebx, edx
	mov	ecx, eax
	shrd	ecx, ebx, 4
	shr	ebx, 4
	or	ecx, eax
	or	ebx, edx
	mov	edx, ebx
	mov	eax, ecx
	shrd	eax, edx, 8
	shr	edx, 8
	or	eax, ecx
	or	edx, ebx
	mov	ebx, edx
	mov	ecx, eax
	shrd	ecx, ebx, 16
	shr	ebx, 16
	or	ebx, edx
	or	ecx, eax
	mov	edx, ebx
	mov	eax, edx
	xor	edx, edx
	or	eax, ecx
	or	edx, ebx
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	add	eax, 1
	adc	edx, 0
	ret
	.cfi_endproc
LFE64:
	.p2align 4
	.globl	_sign_extend
	.def	_sign_extend;	.scl	2;	.type	32;	.endef
_sign_extend:
LFB65:
	.cfi_startproc
	push	edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	push	esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	mov	eax, DWORD PTR [esp+20]
	lea	ecx, [eax-1]
	mov	edi, ecx
	shr	edi, 5
	and	edi, 1
	mov	esi, edi
	sal	edi, cl
	xor	esi, 1
	mov	edx, edi
	sal	esi, cl
	mov	eax, esi
	shld	edx, esi, 1
	add	eax, esi
	add	eax, -1
	adc	edx, -1
	and	eax, DWORD PTR [esp+12]
	and	edx, DWORD PTR [esp+16]
	xor	eax, esi
	xor	edx, edi
	sub	eax, esi
	pop	esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	sbb	edx, edi
	pop	edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
LFE65:
	.p2align 4
	.globl	_sat_add32
	.def	_sat_add32;	.scl	2;	.type	32;	.endef
_sat_add32:
LFB66:
	.cfi_startproc
	push	ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	mov	edx, DWORD PTR [esp+8]
	mov	eax, DWORD PTR [esp+12]
	mov	ebx, edx
	lea	ecx, [eax+edx]
	xor	eax, edx
	shr	edx, 31
	xor	ebx, ecx
	not	eax
	add	edx, 2147483647
	and	eax, ebx
	xor	edx, ecx
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 4
	sar	eax, 31
	and	eax, edx
	xor	eax, ecx
	ret
	.cfi_endproc
LFE66:
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC3:
	.ascii "run %d: %.6f s, sum %llu\12\0"
	.align 4
LC6:
	.ascii "median %.6f s, min %.6f, max %.6f, ns/element %.2f\12\0"
LC7:
	.ascii "popcount32\0"
	.align 4
LC8:
	.ascii "FAIL %-12s got %llu, want %llu\12\0"
LC9:
	.ascii "parity32\0"
LC10:
	.ascii "ctz32\0"
LC11:
	.ascii "clz32\0"
LC12:
	.ascii "is_pow2\0"
	.def	___popcountsi2;	.scl	2;	.type	32;	.endef
LC13:
	.ascii "sign_extend\0"
	.align 4
LC14:
	.ascii "FAIL %-12s got %lld, want %lld\12\0"
LC15:
	.ascii "sat_add32\0"
LC16:
	.ascii "FAIL next_pow2(%llu) = %llu\12\0"
LC17:
	.ascii "FAILED: %d\12\0"
LC18:
	.ascii "OK\0"
	.data
	.align 32
LC0:
	.long	0
	.long	0
	.long	1
	.long	0
	.long	2
	.long	0
	.long	3
	.long	0
	.long	7
	.long	0
	.long	8
	.long	0
	.long	9
	.long	0
	.long	2147483647
	.long	0
	.long	-2147483648
	.long	0
	.long	-1
	.long	1073741823
	.long	0
	.long	1073741824
	.long	0
	.long	-2147483648
	.section	.text.startup,"x"
	.p2align 4
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB74:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	edi
	push	esi
	push	ebx
	and	esp, -16
	sub	esp, 224
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	call	___main
	cmp	DWORD PTR [ebp+8], 1
	jle	L52
	mov	eax, DWORD PTR [ebp+12]
	mov	eax, DWORD PTR [eax+4]
	cmp	BYTE PTR [eax], 45
	je	L53
L52:
	mov	eax, 1
	mov	esi, 14
	mov	DWORD PTR [esp+56], 200000
	mov	DWORD PTR [esp+88], eax
	mov	eax, esi
	jmp	L21
	.p2align 4,,10
	.p2align 3
L26:
	add	eax, 1
	mov	DWORD PTR _fails, eax
L25:
	mov	ebx, DWORD PTR [esp+88]
	mov	eax, ebx
	mov	edx, ebx
	shr	eax, 16
	xor	edx, eax
	xor	dl, dh
	setnp	dl
	xor	eax, ebx
	xor	ebx, ebx
	movzx	edx, dl
	mov	DWORD PTR [esp+80], edx
	sar	edx, 31
	mov	esi, DWORD PTR [esp+80]
	mov	DWORD PTR [esp+84], edx
	mov	edx, eax
	shr	edx, 8
	xor	eax, edx
	mov	edx, eax
	shr	edx, 4
	xor	edx, eax
	mov	eax, edx
	shr	eax, 2
	xor	eax, edx
	mov	edx, eax
	shr	edx
	xor	eax, edx
	mov	edx, DWORD PTR [esp+84]
	and	eax, 1
	xor	esi, eax
	mov	ecx, eax
	xor	edx, ebx
	mov	eax, esi
	or	eax, edx
	je	L27
	mov	eax, DWORD PTR _fails
	cmp	eax, 9
	jle	L62
L28:
	add	eax, 1
	mov	DWORD PTR _fails, eax
L27:
	mov	ebx, DWORD PTR [esp+88]
	test	ebx, ebx
	je	L30
	xor	eax, eax
	mov	edi, DWORD PTR [esp+72]
	rep bsf	eax, ebx
	mov	DWORD PTR [esp+80], eax
	sar	eax, 31
	mov	DWORD PTR [esp+84], eax
	mov	eax, -1013904223
	sub	eax, edi
	and	eax, ebx
	xor	ebx, ebx
	sub	eax, 1
	mov	edx, eax
	shr	edx
	and	edx, 1431655765
	sub	eax, edx
	mov	edx, eax
	shr	eax, 2
	and	edx, 858993459
	and	eax, 858993459
	add	eax, edx
	mov	edx, eax
	shr	edx, 4
	add	edx, eax
	mov	eax, DWORD PTR [esp+80]
	and	edx, 252645135
	imul	edx, edx, 16843009
	shr	edx, 24
	mov	ecx, edx
	mov	edx, DWORD PTR [esp+84]
	xor	eax, ecx
	xor	edx, ebx
	or	eax, edx
	je	L31
	mov	eax, DWORD PTR _fails
	cmp	eax, 9
	jle	L63
L32:
	add	eax, 1
	mov	DWORD PTR _fails, eax
L31:
	mov	ecx, DWORD PTR [esp+88]
	bsr	eax, ecx
	xor	ebx, ebx
	xor	eax, 31
	mov	DWORD PTR [esp+80], eax
	sar	eax, 31
	mov	DWORD PTR [esp+84], eax
	mov	eax, DWORD PTR [esp+64]
	or	eax, ecx
	mov	edx, eax
	shr	edx, 2
	or	edx, eax
	mov	eax, edx
	shr	eax, 4
	or	eax, edx
	mov	edx, eax
	shr	edx, 8
	or	edx, eax
	mov	eax, edx
	shr	eax, 16
	or	edx, eax
	not	edx
	mov	eax, edx
	shr	eax
	and	eax, 1431655765
	sub	edx, eax
	mov	eax, edx
	shr	edx, 2
	and	eax, 858993459
	and	edx, 858993459
	add	edx, eax
	mov	eax, edx
	shr	eax, 4
	add	eax, edx
	mov	edx, DWORD PTR [esp+84]
	and	eax, 252645135
	imul	eax, eax, 16843009
	xor	edx, ebx
	shr	eax, 24
	mov	ecx, eax
	mov	eax, DWORD PTR [esp+80]
	xor	eax, ecx
	or	eax, edx
	je	L33
	mov	eax, DWORD PTR _fails
	cmp	eax, 9
	jle	L64
L34:
	add	eax, 1
	mov	DWORD PTR _fails, eax
L33:
	mov	esi, DWORD PTR [esp+72]
	mov	edi, DWORD PTR [esp+88]
	xor	eax, eax
	mov	DWORD PTR [esp+84], 0
	mov	ecx, DWORD PTR [esp+84]
	add	esi, 1013904222
	test	edi, esi
	sete	al
	xor	ebx, ebx
	mov	DWORD PTR [esp+80], eax
	mov	eax, edi
	mov	edx, ebx
	add	eax, -1
	adc	edx, -1
	and	eax, edi
	and	edx, ebx
	xor	ebx, ebx
	or	eax, edx
	mov	edx, DWORD PTR [esp+80]
	sete	bl
	xor	esi, esi
	mov	edi, edx
	mov	eax, ebx
	mov	edx, ecx
	xor	edi, eax
	xor	edx, esi
	mov	eax, edi
	or	eax, edx
	je	L30
	mov	eax, DWORD PTR _fails
	cmp	eax, 9
	jle	L65
L36:
	add	eax, 1
	mov	DWORD PTR _fails, eax
L30:
	sub	DWORD PTR [esp+56], 1
	je	L54
	imul	eax, DWORD PTR [esp+88], 1664525
	add	eax, 1013904223
	mov	DWORD PTR [esp], eax
	call	___popcountsi2
L21:
	imul	edi, DWORD PTR [esp+88], 1664525
	mov	DWORD PTR [esp+80], eax
	sar	eax, 31
	mov	DWORD PTR [esp+84], eax
	mov	esi, DWORD PTR [esp+80]
	lea	ebx, [edi+1013904223]
	mov	DWORD PTR [esp+72], edi
	mov	edi, DWORD PTR [esp+84]
	mov	eax, ebx
	mov	edx, ebx
	mov	DWORD PTR [esp+88], ebx
	xor	ebx, ebx
	shr	eax
	mov	DWORD PTR [esp+68], esi
	mov	DWORD PTR [esp+64], eax
	and	eax, 1431655765
	sub	edx, eax
	mov	eax, edx
	shr	edx, 2
	and	eax, 858993459
	and	edx, 858993459
	add	edx, eax
	mov	eax, edx
	shr	eax, 4
	add	eax, edx
	mov	edx, edi
	and	eax, 252645135
	xor	edx, ebx
	imul	eax, eax, 16843009
	shr	eax, 24
	xor	esi, eax
	mov	ecx, eax
	mov	eax, esi
	or	eax, edx
	je	L25
	mov	eax, DWORD PTR _fails
	cmp	eax, 9
	jg	L26
	mov	eax, DWORD PTR [esp+80]
	mov	edx, DWORD PTR [esp+84]
	mov	DWORD PTR [esp+8], ecx
	mov	DWORD PTR [esp+12], ebx
	mov	DWORD PTR [esp+16], eax
	mov	DWORD PTR [esp+20], edx
	mov	DWORD PTR [esp+4], OFFSET FLAT:LC7
	mov	DWORD PTR [esp], OFFSET FLAT:LC8
	call	_printf
	mov	eax, DWORD PTR _fails
	jmp	L26
	.p2align 4,,10
	.p2align 3
L65:
	mov	eax, DWORD PTR [esp+80]
	mov	edx, DWORD PTR [esp+84]
	mov	DWORD PTR [esp+8], ebx
	mov	DWORD PTR [esp+12], esi
	mov	DWORD PTR [esp+16], eax
	mov	DWORD PTR [esp+20], edx
	mov	DWORD PTR [esp+4], OFFSET FLAT:LC12
	mov	DWORD PTR [esp], OFFSET FLAT:LC8
	call	_printf
	mov	eax, DWORD PTR _fails
	jmp	L36
	.p2align 4,,10
	.p2align 3
L62:
	mov	eax, DWORD PTR [esp+80]
	mov	edx, DWORD PTR [esp+84]
	mov	DWORD PTR [esp+8], ecx
	mov	DWORD PTR [esp+12], ebx
	mov	DWORD PTR [esp+16], eax
	mov	DWORD PTR [esp+20], edx
	mov	DWORD PTR [esp+4], OFFSET FLAT:LC9
	mov	DWORD PTR [esp], OFFSET FLAT:LC8
	call	_printf
	mov	eax, DWORD PTR _fails
	jmp	L28
	.p2align 4,,10
	.p2align 3
L64:
	mov	eax, DWORD PTR [esp+80]
	mov	edx, DWORD PTR [esp+84]
	mov	DWORD PTR [esp+8], ecx
	mov	DWORD PTR [esp+12], ebx
	mov	DWORD PTR [esp+16], eax
	mov	DWORD PTR [esp+20], edx
	mov	DWORD PTR [esp+4], OFFSET FLAT:LC11
	mov	DWORD PTR [esp], OFFSET FLAT:LC8
	call	_printf
	mov	eax, DWORD PTR _fails
	jmp	L34
	.p2align 4,,10
	.p2align 3
L63:
	mov	eax, DWORD PTR [esp+80]
	mov	edx, DWORD PTR [esp+84]
	mov	DWORD PTR [esp+8], ecx
	mov	DWORD PTR [esp+12], ebx
	mov	DWORD PTR [esp+16], eax
	mov	DWORD PTR [esp+20], edx
	mov	DWORD PTR [esp+4], OFFSET FLAT:LC10
	mov	DWORD PTR [esp], OFFSET FLAT:LC8
	call	_printf
	mov	eax, DWORD PTR _fails
	jmp	L32
L54:
	mov	ecx, 63
	jmp	L37
	.p2align 4,,10
	.p2align 3
L39:
	add	eax, 1
	mov	DWORD PTR _fails, eax
L38:
	mov	eax, -252645136
	mov	edx, -252645136
	xor	ebx, ebx
	shld	edx, eax, cl
	sal	eax, cl
	test	cl, 32
	cmovne	edx, eax
	cmovne	eax, ebx
	shrd	eax, edx, cl
	sar	edx, cl
	mov	ebx, edx
	sar	ebx, 31
	test	cl, 32
	cmovne	eax, edx
	cmovne	edx, ebx
	mov	DWORD PTR [esp+88], eax
	mov	eax, DWORD PTR [esp+80]
	mov	DWORD PTR [esp+92], edx
	mov	edx, DWORD PTR [esp+84]
	and	eax, -252645136
	mov	ebx, DWORD PTR [esp+92]
	and	edx, -252645136
	xor	eax, esi
	xor	edx, edi
	sub	eax, esi
	sbb	edx, edi
	mov	esi, eax
	mov	DWORD PTR [esp+80], eax
	mov	eax, DWORD PTR [esp+88]
	mov	DWORD PTR [esp+84], edx
	mov	edx, DWORD PTR [esp+84]
	xor	eax, esi
	xor	edx, ebx
	or	eax, edx
	je	L40
	mov	eax, DWORD PTR _fails
	cmp	eax, 9
	jle	L66
L41:
	add	eax, 1
	mov	DWORD PTR _fails, eax
L40:
	sub	ecx, 1
	jb	L67
L37:
	mov	eax, 252645135
	mov	edx, 252645135
	xor	esi, esi
	shld	edx, eax, cl
	sal	eax, cl
	test	cl, 32
	cmovne	edx, eax
	cmovne	eax, esi
	shrd	eax, edx, cl
	sar	edx, cl
	mov	edi, edx
	sar	edi, 31
	test	cl, 32
	cmovne	eax, edx
	cmovne	edx, edi
	xor	esi, esi
	mov	edi, -2147483648
	shrd	esi, edi, cl
	mov	DWORD PTR [esp+88], eax
	shr	edi, cl
	xor	eax, eax
	test	cl, 32
	cmovne	esi, edi
	cmovne	edi, eax
	mov	DWORD PTR [esp+92], edx
	mov	ebx, DWORD PTR [esp+88]
	mov	eax, esi
	mov	edx, edi
	mov	DWORD PTR [esp+72], ebx
	add	eax, esi
	shld	edx, esi, 1
	add	eax, -1
	adc	edx, -1
	mov	DWORD PTR [esp+80], eax
	and	eax, 252645135
	mov	DWORD PTR [esp+84], edx
	xor	eax, esi
	and	edx, 252645135
	xor	edx, edi
	sub	eax, esi
	mov	DWORD PTR [esp+64], eax
	mov	ebx, DWORD PTR [esp+64]
	sbb	edx, edi
	mov	DWORD PTR [esp+56], eax
	mov	eax, DWORD PTR [esp+92]
	mov	DWORD PTR [esp+60], edx
	mov	DWORD PTR [esp+68], eax
	mov	eax, DWORD PTR [esp+72]
	xor	ebx, eax
	mov	eax, ebx
	mov	ebx, DWORD PTR [esp+68]
	xor	edx, ebx
	or	eax, edx
	je	L38
	mov	eax, DWORD PTR _fails
	cmp	eax, 9
	jg	L39
	mov	eax, DWORD PTR [esp+88]
	mov	edx, DWORD PTR [esp+92]
	mov	DWORD PTR [esp+72], ecx
	mov	DWORD PTR [esp+4], OFFSET FLAT:LC13
	mov	DWORD PTR [esp+16], eax
	mov	eax, DWORD PTR [esp+56]
	mov	DWORD PTR [esp+20], edx
	mov	edx, DWORD PTR [esp+60]
	mov	DWORD PTR [esp+8], eax
	mov	DWORD PTR [esp+12], edx
	mov	DWORD PTR [esp], OFFSET FLAT:LC14
	call	_printf
	mov	eax, DWORD PTR _fails
	mov	ecx, DWORD PTR [esp+72]
	jmp	L39
	.p2align 4,,10
	.p2align 3
L66:
	mov	eax, DWORD PTR [esp+88]
	mov	edx, DWORD PTR [esp+92]
	mov	DWORD PTR [esp+72], ecx
	mov	DWORD PTR [esp+4], OFFSET FLAT:LC13
	mov	DWORD PTR [esp+16], eax
	mov	eax, DWORD PTR [esp+80]
	mov	DWORD PTR [esp+20], edx
	mov	edx, DWORD PTR [esp+84]
	mov	DWORD PTR [esp+8], eax
	mov	DWORD PTR [esp+12], edx
	mov	DWORD PTR [esp], OFFSET FLAT:LC14
	call	_printf
	mov	eax, DWORD PTR _fails
	mov	ecx, DWORD PTR [esp+72]
	jmp	L41
L67:
	lea	eax, [esp+128]
	mov	DWORD PTR [esp+100], 2147483647
	lea	esi, [esp+104]
	mov	DWORD PTR [esp+104], -2147483648
	mov	DWORD PTR [esp+108], -1
	mov	DWORD PTR [esp+112], 0
	mov	DWORD PTR [esp+116], 1
	mov	DWORD PTR [esp+120], 12345
	mov	DWORD PTR [esp+124], -12345
	mov	DWORD PTR [esp+68], eax
	mov	DWORD PTR [esp+80], 2147483647
	.p2align 4,,10
	.p2align 3
L42:
	mov	edi, DWORD PTR [esp+80]
	lea	ebx, [esp+100]
	mov	DWORD PTR [esp+52], esi
	mov	DWORD PTR [esp+88], ebx
	mov	eax, edi
	mov	DWORD PTR [esp+56], edi
	sar	edi, 31
	shr	eax, 31
	mov	DWORD PTR [esp+60], edi
	add	eax, 2147483647
	mov	DWORD PTR [esp+64], eax
	jmp	L45
	.p2align 4,,10
	.p2align 3
L44:
	add	eax, 1
	mov	DWORD PTR _fails, eax
L43:
	add	DWORD PTR [esp+88], 4
	mov	eax, DWORD PTR [esp+88]
	cmp	DWORD PTR [esp+68], eax
	je	L68
L45:
	mov	eax, DWORD PTR [esp+88]
	mov	edx, -2147483648
	mov	ecx, DWORD PTR [eax]
	mov	eax, -1
	mov	edi, ecx
	mov	esi, ecx
	sar	edi, 31
	add	esi, DWORD PTR [esp+56]
	adc	edi, DWORD PTR [esp+60]
	mov	ebx, edi
	cmp	esi, edx
	sbb	ebx, eax
	cmovl	esi, edx
	cmovl	edi, eax
	mov	edx, 2147483647
	xor	eax, eax
	mov	ebx, eax
	cmp	edx, esi
	sbb	ebx, edi
	cmovl	esi, edx
	mov	edx, DWORD PTR [esp+80]
	cmovl	edi, eax
	lea	eax, [ecx+edx]
	xor	ecx, edx
	not	ecx
	xor	edx, eax
	and	ecx, edx
	mov	edx, DWORD PTR [esp+64]
	sar	ecx, 31
	xor	edx, eax
	and	ecx, edx
	xor	ecx, eax
	mov	edx, ecx
	sar	ecx, 31
	mov	eax, edx
	mov	DWORD PTR [esp+72], edx
	mov	edx, ecx
	xor	eax, esi
	xor	edx, edi
	mov	DWORD PTR [esp+76], ecx
	or	eax, edx
	je	L43
	mov	eax, DWORD PTR _fails
	cmp	eax, 9
	jg	L44
	mov	eax, DWORD PTR [esp+72]
	mov	edx, DWORD PTR [esp+76]
	mov	DWORD PTR [esp+16], esi
	mov	DWORD PTR [esp+20], edi
	mov	DWORD PTR [esp+8], eax
	mov	DWORD PTR [esp+12], edx
	mov	DWORD PTR [esp+4], OFFSET FLAT:LC15
	mov	DWORD PTR [esp], OFFSET FLAT:LC14
	call	_printf
	mov	eax, DWORD PTR _fails
	jmp	L44
	.p2align 4,,10
	.p2align 3
L68:
	mov	esi, DWORD PTR [esp+52]
	cmp	DWORD PTR [esp+68], esi
	je	L46
	mov	eax, DWORD PTR [esi]
	add	esi, 4
	mov	DWORD PTR [esp+80], eax
	jmp	L42
L46:
	mov	edi, DWORD PTR [esp+68]
	mov	esi, OFFSET FLAT:LC0
	mov	ecx, 24
	lea	eax, [esp+128]
	rep movsd
	mov	DWORD PTR [esp+88], eax
	.p2align 4,,10
	.p2align 3
L49:
	mov	eax, DWORD PTR [esp+88]
	mov	esi, DWORD PTR [eax]
	mov	edi, DWORD PTR [eax+4]
	mov	ecx, esi
	mov	ebx, edi
	mov	edx, esi
	add	ecx, -1
	adc	ebx, -1
	or	edx, edi
	sete	dl
	movzx	edx, dl
	add	ecx, edx
	adc	ebx, 0
	mov	eax, ecx
	mov	edx, ebx
	shrd	ecx, ebx, 1
	shr	ebx
	or	ecx, eax
	or	ebx, edx
	mov	eax, ecx
	mov	edx, ebx
	shrd	eax, edx, 2
	shr	edx, 2
	or	eax, ecx
	or	edx, ebx
	mov	ebx, edx
	mov	ecx, eax
	shrd	ecx, ebx, 4
	shr	ebx, 4
	or	ecx, eax
	or	ebx, edx
	mov	edx, ebx
	mov	eax, ecx
	shrd	eax, edx, 8
	shr	edx, 8
	or	eax, ecx
	or	edx, ebx
	mov	ebx, edx
	mov	ecx, eax
	shrd	ecx, ebx, 16
	shr	ebx, 16
	or	ebx, edx
	or	ecx, eax
	mov	edx, ebx
	mov	eax, edx
	xor	edx, edx
	or	eax, ecx
	or	edx, ebx
	mov	ecx, eax
	mov	ebx, edx
	mov	DWORD PTR [esp+80], eax
	add	ecx, 1
	mov	DWORD PTR [esp+84], edx
	adc	ebx, 0
	cmp	ecx, esi
	mov	eax, ebx
	sbb	eax, edi
	jc	L47
	mov	edx, DWORD PTR [esp+84]
	mov	eax, DWORD PTR [esp+80]
	and	edx, ebx
	and	eax, ecx
	mov	DWORD PTR [esp+84], edx
	mov	edx, DWORD PTR [esp+84]
	mov	DWORD PTR [esp+80], eax
	or	eax, edx
	jne	L47
	mov	eax, 1
	cmp	eax, esi
	mov	eax, 0
	sbb	eax, edi
	jnc	L48
	mov	edx, ebx
	mov	eax, ecx
	shrd	eax, edx, 1
	shr	edx
	cmp	eax, esi
	mov	eax, edx
	sbb	eax, edi
	jc	L48
	.p2align 4,,10
	.p2align 3
L47:
	mov	DWORD PTR [esp+12], ecx
	mov	DWORD PTR [esp+16], ebx
	mov	DWORD PTR [esp+4], esi
	mov	DWORD PTR [esp+8], edi
	mov	DWORD PTR [esp], OFFSET FLAT:LC16
	call	_printf
	add	DWORD PTR _fails, 1
L48:
	add	DWORD PTR [esp+88], 8
	mov	eax, DWORD PTR [esp+88]
	lea	edi, [esp+224]
	cmp	edi, eax
	jne	L49
	mov	eax, DWORD PTR _fails
	test	eax, eax
	jne	L69
	mov	DWORD PTR [esp], OFFSET FLAT:LC18
	call	_puts
L24:
	xor	eax, eax
L18:
	lea	esp, [ebp-12]
	pop	ebx
	.cfi_remember_state
	.cfi_restore 3
	pop	esi
	.cfi_restore 6
	pop	edi
	.cfi_restore 7
	pop	ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
L69:
	.cfi_restore_state
	mov	DWORD PTR [esp+4], eax
	mov	DWORD PTR [esp], OFFSET FLAT:LC17
	call	_printf
	mov	eax, 1
	jmp	L18
L53:
	xor	ecx, ecx
	mov	eax, -1831433054
	.p2align 4,,10
	.p2align 3
L20:
	mov	edx, eax
	sal	edx, 13
	xor	eax, edx
	mov	edx, eax
	shr	edx, 17
	xor	eax, edx
	mov	edx, eax
	sal	edx, 5
	xor	eax, edx
	mov	DWORD PTR _a.0[0+ecx*4], eax
	add	ecx, 1
	cmp	ecx, 4194304
	jne	L20
	lea	eax, [esp+128]
	xor	ebx, ebx
	mov	DWORD PTR [esp+68], eax
L23:
	lea	eax, [esp+100]
	mov	DWORD PTR [esp], 1
	xor	esi, esi
	xor	edi, edi
	mov	DWORD PTR [esp+4], eax
	call	_clock_gettime
	fild	DWORD PTR [esp+104]
	xor	ecx, ecx
	fld	TBYTE PTR LC2
	fmulp	st(1), st
	fild	DWORD PTR [esp+100]
	faddp	st(1), st
	fstp	QWORD PTR [esp+88]
	.p2align 4,,10
	.p2align 3
L22:
	mov	eax, DWORD PTR _a.0[0+ecx*4]
	mov	edx, eax
	shr	edx
	and	edx, 1431655765
	sub	eax, edx
	mov	edx, eax
	shr	eax, 2
	and	eax, 858993459
	and	edx, 858993459
	add	edx, eax
	mov	eax, edx
	shr	eax, 4
	add	eax, edx
	and	eax, 252645135
	imul	eax, eax, 16843009
	shr	eax, 24
	add	esi, eax
	adc	edi, 0
	add	ecx, 1
	cmp	ecx, 4194304
	jne	L22
	lea	eax, [esp+100]
	mov	DWORD PTR [esp], 1
	mov	DWORD PTR [esp+4], eax
	call	_clock_gettime
	fild	DWORD PTR [esp+104]
	mov	eax, DWORD PTR [esp+68]
	fld	TBYTE PTR LC2
	fmulp	st(1), st
	fild	DWORD PTR [esp+100]
	faddp	st(1), st
	fstp	QWORD PTR [esp+80]
	fld	QWORD PTR [esp+80]
	fsub	QWORD PTR [esp+88]
	fstp	QWORD PTR [esp+88]
	fld	QWORD PTR [esp+88]
	fst	QWORD PTR [eax+ebx*8]
	add	ebx, 1
	mov	DWORD PTR [esp+16], esi
	mov	DWORD PTR [esp+20], edi
	mov	DWORD PTR [esp+4], ebx
	mov	DWORD PTR [esp], OFFSET FLAT:LC3
	fstp	QWORD PTR [esp+8]
	call	_printf
	cmp	ebx, 5
	jne	L23
	mov	eax, DWORD PTR [esp+68]
	mov	DWORD PTR [esp+12], OFFSET FLAT:_cmp_double
	mov	DWORD PTR [esp+8], 8
	mov	DWORD PTR [esp+4], 5
	mov	DWORD PTR [esp], eax
	call	_qsort
	fld	DWORD PTR LC4
	fmul	QWORD PTR [esp+144]
	mov	DWORD PTR [esp], OFFSET FLAT:LC6
	fmul	DWORD PTR LC5
	fstp	QWORD PTR [esp+28]
	fld	QWORD PTR [esp+160]
	fstp	QWORD PTR [esp+20]
	fld	QWORD PTR [esp+128]
	fstp	QWORD PTR [esp+12]
	fld	QWORD PTR [esp+144]
	fstp	QWORD PTR [esp+4]
	call	_printf
	jmp	L24
	.cfi_endproc
LFE74:
.lcomm _a.0,16777216,32
.lcomm _fails,4,4
	.section .rdata,"dr"
	.align 16
LC2:
	.long	917808535
	.long	-1989124287
	.long	16353
	.align 4
LC4:
	.long	1315859240
	.align 4
LC5:
	.long	880803840
	.ident	"GCC: (i686-posix-dwarf-rev1, Built by MinGW-Builds project) 13.1.0"
	.def	___mingw_vfprintf;	.scl	2;	.type	32;	.endef
	.def	_puts;	.scl	2;	.type	32;	.endef
	.def	_clock_gettime;	.scl	2;	.type	32;	.endef
	.def	_qsort;	.scl	2;	.type	32;	.endef
