	.file	"branchy_cmp.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	_is_pow2
	.def	_is_pow2;	.scl	2;	.type	32;	.endef
_is_pow2:
LFB2:
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
LFE2:
	.p2align 4
	.globl	_is_pow2_branchy
	.def	_is_pow2_branchy;	.scl	2;	.type	32;	.endef
_is_pow2_branchy:
LFB3:
	.cfi_startproc
	push	edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	xor	edx, edx
	push	esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	push	ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	ecx, DWORD PTR [esp+16]
	mov	ebx, DWORD PTR [esp+20]
	mov	eax, ecx
	or	eax, ebx
	je	L4
	mov	eax, ecx
	xor	eax, 1
	or	eax, ebx
	je	L9
	mov	esi, ecx
	xor	edi, edi
	and	esi, 1
	mov	eax, esi
	or	eax, edi
	je	L6
	jmp	L4
	.p2align 4,,10
	.p2align 3
L7:
	mov	eax, ecx
	xor	edx, edx
	and	eax, 1
	or	eax, edx
	jne	L11
L6:
	shrd	ecx, ebx, 1
	shr	ebx
	mov	eax, ecx
	xor	eax, 1
	or	eax, ebx
	jne	L7
L9:
	mov	edx, 1
L4:
	pop	ebx
	.cfi_remember_state
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	mov	eax, edx
	pop	esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	pop	edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.p2align 4,,10
	.p2align 3
L11:
	.cfi_restore_state
	xor	edx, edx
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	pop	esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	mov	eax, edx
	pop	edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
LFE3:
	.p2align 4
	.globl	_sat_add32
	.def	_sat_add32;	.scl	2;	.type	32;	.endef
_sat_add32:
LFB4:
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
LFE4:
	.p2align 4
	.globl	_sat_add32_branchy
	.def	_sat_add32_branchy;	.scl	2;	.type	32;	.endef
_sat_add32_branchy:
LFB5:
	.cfi_startproc
	push	esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	push	ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	mov	ecx, DWORD PTR [esp+16]
	mov	eax, DWORD PTR [esp+12]
	mov	ebx, ecx
	cdq
	sar	ebx, 31
	add	eax, ecx
	mov	ecx, 2147483647
	adc	edx, ebx
	cmp	ecx, eax
	mov	ecx, 0
	sbb	ecx, edx
	mov	ecx, 2147483647
	jl	L16
	mov	ebx, eax
	cmp	eax, -2147483648
	mov	eax, edx
	mov	ecx, -2147483648
	sbb	eax, -1
	cmovge	ecx, ebx
L16:
	mov	eax, ecx
	pop	ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	pop	esi
	.cfi_restore 6
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
LFE5:
	.ident	"GCC: (i686-posix-dwarf-rev1, Built by MinGW-Builds project) 13.1.0"
