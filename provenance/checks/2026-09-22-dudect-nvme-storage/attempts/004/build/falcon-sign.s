	.file	"falcon-sign.c"
	.text
	.type	ft_fpr_is_positive_finite, @function
ft_fpr_is_positive_finite:
.LFB70:
	.cfi_startproc
	movq	%rdi, %rdx
	notq	%rdx
	movabsq	$9218868437227405312, %rax
	testq	%rax, %rdx
	je	.L3
	testq	%rdi, %rdi
	js	.L3
	addq	%rdi, %rdi
	setne	%al
	movzbl	%al, %eax
	ret
.L3:
	movl	$0, %eax
	ret
	.cfi_endproc
.LFE70:
	.size	ft_fpr_is_positive_finite, .-ft_fpr_is_positive_finite
	.type	ffLDL_ternary_normalize_inner, @function
ffLDL_ternary_normalize_inner:
.LFB47:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %r13
	movq	%rsi, %rbp
	movq	%rcx, %r12
	movq	%r8, %rbx
	cmpl	$1, %edx
	je	.L8
	movl	$1, %r14d
	movl	%edx, %ecx
	salq	%cl, %r14
	leal	-1(%rdx), %r15d
	movl	$8, %edi
	salq	%cl, %rdi
	addq	%r13, %rdi
	movq	%r12, %rcx
	movl	%r15d, %edx
	call	ffLDL_ternary_normalize_inner
	addq	%rax, %r14
	leaq	0(%r13,%r14,8), %rdi
	movq	%rbx, %r8
	movq	%r12, %rcx
	movl	%r15d, %edx
	movq	%rbp, %rsi
	call	ffLDL_ternary_normalize_inner
	addq	%r14, %rax
.L4:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L8:
	.cfi_restore_state
	movq	(%r8), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, (%r8)
	movq	(%rcx,%rax,8), %rdi
	call	fpr_sqrt@PLT
	movq	%rax, %rsi
	movq	%rbp, %rdi
	call	fpr_div@PLT
	movq	%rax, 16(%r13)
	movq	(%rbx), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, (%rbx)
	movq	(%r12,%rax,8), %rdi
	call	fpr_sqrt@PLT
	movq	%rax, %rsi
	movq	%rbp, %rdi
	call	fpr_div@PLT
	movq	%rax, 24(%r13)
	movl	$4, %eax
	jmp	.L4
	.cfi_endproc
.LFE47:
	.size	ffLDL_ternary_normalize_inner, .-ffLDL_ternary_normalize_inner
	.type	ffLDL_ternary_normalize_depth1, @function
ffLDL_ternary_normalize_depth1:
.LFB48:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	movq	%rdi, %r15
	movq	%rsi, %r12
	movq	%rcx, %r13
	movq	%r8, %r14
	movl	$3, %ebx
	movl	%edx, %ecx
	salq	%cl, %rbx
	leal	-1(%rdx), %ebp
	leaq	(%rdi,%rbx,8), %rdi
	movq	%r13, %rcx
	movl	%ebp, %edx
	call	ffLDL_ternary_normalize_inner
	addq	%rax, %rbx
	leaq	(%r15,%rbx,8), %rdi
	movq	%r14, %r8
	movq	%r13, %rcx
	movl	%ebp, %edx
	movq	%r12, %rsi
	call	ffLDL_ternary_normalize_inner
	addq	%rax, %rbx
	leaq	(%r15,%rbx,8), %rdi
	movq	%r14, %r8
	movq	%r13, %rcx
	movl	%ebp, %edx
	movq	%r12, %rsi
	call	ffLDL_ternary_normalize_inner
	addq	%rbx, %rax
	addq	$8, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE48:
	.size	ffLDL_ternary_normalize_depth1, .-ffLDL_ternary_normalize_depth1
	.type	ffLDL_binary_normalize, @function
ffLDL_binary_normalize:
.LFB37:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbp
	movq	%rsi, %r12
	testl	%edx, %edx
	jne	.L12
	movq	(%rdi), %rdi
	call	fpr_sqrt@PLT
	movq	%rax, %rsi
	movq	%r12, %rdi
	call	fpr_div@PLT
	movq	%rax, 0(%rbp)
.L11:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L12:
	.cfi_restore_state
	movl	%edx, %ebx
	leal	-1(%rdx), %r13d
	movl	$8, %edi
	movl	%edx, %ecx
	salq	%cl, %rdi
	addq	%rbp, %rdi
	movl	%r13d, %edx
	call	ffLDL_binary_normalize
	movl	%ebx, %eax
	movl	%r13d, %ecx
	sall	%cl, %eax
	movl	$1, %edx
	movl	%ebx, %ecx
	salq	%cl, %rdx
	addq	%rdx, %rax
	leaq	0(%rbp,%rax,8), %rdi
	movl	%r13d, %edx
	movq	%r12, %rsi
	call	ffLDL_binary_normalize
	jmp	.L11
	.cfi_endproc
.LFE37:
	.size	ffLDL_binary_normalize, .-ffLDL_binary_normalize
	.type	LDL_dim2_fft3, @function
LDL_dim2_fft3:
.LFB38:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, %rbp
	movq	%rsi, %r14
	movq	%rdx, (%rsp)
	movq	%rcx, %r15
	movq	%r8, 8(%rsp)
	movl	%r9d, %ebx
	movl	80(%rsp), %r12d
	leal	1(%r12,%r12), %r13d
	movl	%r9d, %ecx
	subl	%r12d, %ecx
	salq	%cl, %r13
	salq	$3, %r13
	movq	%r13, %rdx
	movq	%r15, %rsi
	movq	%r14, %rdi
	call	memcpy@PLT
	movl	%r12d, %ecx
	movl	%ebx, %edx
	movq	(%rsp), %rsi
	movq	%r14, %rdi
	call	falcon_poly_div_autoadj_fft3@PLT
	movq	%r13, %rdx
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	memcpy@PLT
	movl	%r12d, %ecx
	movl	%ebx, %edx
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	falcon_poly_muladj_fft3@PLT
	movl	%r12d, %edx
	movl	%ebx, %esi
	movq	%rbp, %rdi
	call	falcon_poly_neg3@PLT
	movl	%r12d, %ecx
	movl	%ebx, %edx
	movq	8(%rsp), %rsi
	movq	%rbp, %rdi
	call	falcon_poly_add3@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE38:
	.size	LDL_dim2_fft3, .-LDL_dim2_fft3
	.type	ffLDL_inner_fft3, @function
ffLDL_inner_fft3:
.LFB40:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	%rdi, (%rsp)
	movq	%rsi, 8(%rsp)
	movq	%rdx, 16(%rsp)
	movq	%rcx, 24(%rsp)
	movq	%r9, %rbx
	movl	$1, %eax
	movl	%r8d, %ecx
	salq	%cl, %rax
	movq	%rax, %r12
	shrq	%r12
	cmpl	$1, %r8d
	je	.L21
	movl	%r8d, %ebp
	movq	%rax, %r14
	salq	$3, %r12
	leaq	(%r9,%r12), %r13
	addq	%r13, %r12
	movl	%r8d, %ecx
	movq	8(%rsp), %rdx
	movq	%r13, %rsi
	movq	%r9, %rdi
	call	falcon_poly_split_deep_fft3@PLT
	leal	-1(%rbp), %r15d
	movl	$0, %edx
	movl	%r15d, %esi
	movq	%r13, %rdi
	call	falcon_poly_adj_fft3@PLT
	movl	$8, %edi
	movl	%ebp, %ecx
	salq	%cl, %rdi
	movq	(%rsp), %rax
	addq	%rax, %rdi
	movq	%r12, %r9
	movl	%r15d, %r8d
	movq	%rbx, %rcx
	movq	%r13, %rdx
	movq	%rbx, %rsi
	call	ffLDL_inner_fft3
	addq	%rax, %r14
	subq	$8, %rsp
	.cfi_def_cfa_offset 104
	pushq	$0
	.cfi_def_cfa_offset 112
	movl	%ebp, %r9d
	movq	40(%rsp), %r8
	movq	32(%rsp), %rcx
	movq	24(%rsp), %rdx
	movq	16(%rsp), %rsi
	movq	%r12, %rdi
	call	LDL_dim2_fft3
	movl	%ebp, %ecx
	movq	%r12, %rdx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_split_deep_fft3@PLT
	movl	$0, %edx
	movl	%r15d, %esi
	movq	%r13, %rdi
	call	falcon_poly_adj_fft3@PLT
	movq	16(%rsp), %rax
	leaq	(%rax,%r14,8), %rdi
	movq	%r12, %r9
	movl	%r15d, %r8d
	movq	%rbx, %rcx
	movq	%r13, %rdx
	movq	%rbx, %rsi
	call	ffLDL_inner_fft3
	addq	%r14, %rax
	addq	$16, %rsp
	.cfi_def_cfa_offset 96
.L17:
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L21:
	.cfi_restore_state
	subq	$8, %rsp
	.cfi_def_cfa_offset 104
	pushq	$0
	.cfi_def_cfa_offset 112
	movl	$1, %r9d
	movq	40(%rsp), %r8
	movq	32(%rsp), %rcx
	movq	24(%rsp), %r14
	movq	%r14, %rdx
	movq	16(%rsp), %r15
	movq	%r15, %rsi
	movq	%rbx, %rdi
	call	LDL_dim2_fft3
	movq	(%r14), %rax
	movq	%rax, 16(%r15)
	movq	(%rbx), %rax
	movq	%rax, 24(%r15)
	addq	$16, %rsp
	.cfi_def_cfa_offset 96
	movl	$4, %eax
	jmp	.L17
	.cfi_endproc
.LFE40:
	.size	ffLDL_inner_fft3, .-ffLDL_inner_fft3
	.type	ffLDL_depth1_fft3, @function
ffLDL_depth1_fft3:
.LFB41:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$80, %rsp
	.cfi_def_cfa_offset 136
	movq	%rdx, %r11
	movq	%rcx, %rax
	movq	%r8, 40(%rsp)
	movq	%r9, 64(%rsp)
	movl	144(%rsp), %ebx
	movl	$8, %r14d
	movl	%ebx, %ecx
	salq	%cl, %r14
	leaq	(%rdi,%r14), %rcx
	movq	%rcx, 16(%rsp)
	leaq	(%rcx,%r14), %r15
	movq	%r14, %rcx
	addq	152(%rsp), %rcx
	movq	%rcx, 8(%rsp)
	leaq	(%rcx,%r14), %r12
	movl	$1, %ebp
	movl	%ebx, %ecx
	salq	%cl, %rbp
	shrq	%rbp
	salq	$3, %rbp
	leaq	(%r12,%rbp), %r13
	addq	%r13, %rbp
	movl	$3, %edx
	salq	%cl, %rdx
	movq	%rdx, 56(%rsp)
	pushq	$0
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d
	movq	%rax, %r8
	movq	%r11, 56(%rsp)
	movq	%r11, %rcx
	movq	%rsi, 40(%rsp)
	movq	%rsi, %rdx
	movq	%rdi, 32(%rsp)
	movq	%rdi, %rsi
	movq	160(%rsp), %rdi
	call	LDL_dim2_fft3
	movq	%r14, %rdx
	movq	48(%rsp), %rsi
	movq	24(%rsp), %rdi
	call	memcpy@PLT
	movl	$0, %ecx
	movl	%ebx, %edx
	movq	40(%rsp), %rsi
	movq	24(%rsp), %rdi
	call	falcon_poly_div_autoadj_fft3@PLT
	movq	%r14, %rdx
	movq	48(%rsp), %rsi
	movq	%r15, %rdi
	call	memcpy@PLT
	movl	$0, %ecx
	movl	%ebx, %edx
	movq	56(%rsp), %rsi
	movq	%r15, %rdi
	call	falcon_poly_muladj_fft3@PLT
	movl	$0, %ecx
	movl	%ebx, %edx
	movq	40(%rsp), %rsi
	movq	%r15, %rdi
	call	falcon_poly_div_autoadj_fft3@PLT
	movl	$0, %edx
	movl	%ebx, %esi
	movq	%r15, %rdi
	call	falcon_poly_neg3@PLT
	movl	$0, %ecx
	movl	%ebx, %edx
	movq	72(%rsp), %rsi
	movq	%r15, %rdi
	call	falcon_poly_add3@PLT
	movl	$0, %ecx
	movl	%ebx, %edx
	movq	160(%rsp), %rsi
	movq	%r15, %rdi
	call	falcon_poly_div_autoadj_fft3@PLT
	movq	%r14, %rdx
	movq	24(%rsp), %rsi
	movq	16(%rsp), %rdi
	call	memcpy@PLT
	movl	$0, %ecx
	movl	%ebx, %edx
	movq	48(%rsp), %rsi
	movq	16(%rsp), %rdi
	call	falcon_poly_muladj_fft3@PLT
	movl	$0, %edx
	movl	%ebx, %esi
	movq	16(%rsp), %rdi
	call	falcon_poly_neg3@PLT
	movl	$0, %ecx
	movl	%ebx, %edx
	movq	144(%rsp), %rsi
	movq	16(%rsp), %rdi
	call	falcon_poly_add3@PLT
	movq	%r14, %rdx
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	memcpy@PLT
	movl	$0, %edx
	movl	%ebx, %esi
	movq	%rbp, %rdi
	call	falcon_poly_mulselfadj_fft3@PLT
	movl	$0, %ecx
	movl	%ebx, %edx
	movq	160(%rsp), %rsi
	movq	%rbp, %rdi
	call	falcon_poly_mul_autoadj_fft3@PLT
	movl	$0, %ecx
	movl	%ebx, %edx
	movq	%rbp, %rsi
	movq	16(%rsp), %rdi
	call	falcon_poly_sub3@PLT
	movl	%ebx, %ecx
	movq	40(%rsp), %rdx
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	falcon_poly_split_deep_fft3@PLT
	leal	-1(%rbx), %r15d
	movl	$0, %edx
	movl	%r15d, %esi
	movq	%r13, %rdi
	call	falcon_poly_adj_fft3@PLT
	movq	32(%rsp), %rax
	movq	64(%rsp), %r14
	leaq	(%rax,%r14,8), %rdi
	movq	%rbp, %r9
	movl	%r15d, %r8d
	movq	%r12, %rcx
	movq	%r13, %rdx
	movq	%r12, %rsi
	call	ffLDL_inner_fft3
	addq	%rax, %r14
	movl	%ebx, %ecx
	movq	160(%rsp), %rdx
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	falcon_poly_split_deep_fft3@PLT
	movl	$0, %edx
	movl	%r15d, %esi
	movq	%r13, %rdi
	call	falcon_poly_adj_fft3@PLT
	movq	32(%rsp), %rax
	leaq	(%rax,%r14,8), %rdi
	movq	%rbp, %r9
	movl	%r15d, %r8d
	movq	%r12, %rcx
	movq	%r13, %rdx
	movq	%r12, %rsi
	call	ffLDL_inner_fft3
	addq	%rax, %r14
	movl	%ebx, %ecx
	movq	16(%rsp), %rdx
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	falcon_poly_split_deep_fft3@PLT
	movl	$0, %edx
	movl	%r15d, %esi
	movq	%r13, %rdi
	call	falcon_poly_adj_fft3@PLT
	movq	32(%rsp), %rax
	leaq	(%rax,%r14,8), %rdi
	movq	%rbp, %r9
	movl	%r15d, %r8d
	movq	%r12, %rcx
	movq	%r13, %rdx
	movq	%r12, %rsi
	call	ffLDL_inner_fft3
	addq	%r14, %rax
	addq	$88, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE41:
	.size	ffLDL_depth1_fft3, .-ffLDL_depth1_fft3
	.type	LDL_fft, @function
LDL_fft:
.LFB32:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, %r14
	movq	%rsi, %r13
	movq	%rdx, %r15
	movq	%rcx, %rsi
	movq	%r8, 8(%rsp)
	movl	%r9d, %ebx
	movq	80(%rsp), %rbp
	movl	$8, %r12d
	movl	%r9d, %ecx
	salq	%cl, %r12
	movq	%r12, %rdx
	movq	%rbp, %rdi
	call	memcpy@PLT
	movl	%ebx, %edx
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	falcon_poly_div_fft@PLT
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%r13, %rdi
	call	memcpy@PLT
	movl	%ebx, %esi
	movq	%r13, %rdi
	call	falcon_poly_adj_fft@PLT
	movl	%ebx, %edx
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	falcon_poly_mul_fft@PLT
	movl	%ebx, %edx
	movq	%r15, %rsi
	movq	%rbp, %rdi
	call	falcon_poly_mul_fft@PLT
	movq	%r12, %rdx
	movq	8(%rsp), %rsi
	movq	%r14, %rdi
	call	memcpy@PLT
	movl	%ebx, %edx
	movq	%rbp, %rsi
	movq	%r14, %rdi
	call	falcon_poly_sub@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE32:
	.size	LDL_fft, .-LDL_fft
	.type	ffLDL_fft_inner, @function
ffLDL_fft_inner:
.LFB35:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	%rdi, %r13
	movq	%rsi, %rbp
	testl	%ecx, %ecx
	jne	.L27
	movq	(%rsi), %rax
	movq	%rax, (%rdi)
.L26:
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L27:
	.cfi_restore_state
	movq	%rdx, %r14
	movl	%ecx, %ebx
	movq	%r8, %r12
	movl	$1, %eax
	salq	%cl, %rax
	movq	%rax, %r15
	movl	$8, %eax
	salq	%cl, %rax
	subq	$8, %rsp
	.cfi_def_cfa_offset 104
	movq	%rax, 8(%rsp)
	addq	%r8, %rax
	pushq	%rax
	.cfi_def_cfa_offset 112
	movl	%ecx, %r9d
	movq	%rsi, %r8
	movq	%rdx, %rcx
	movq	%rsi, %rdx
	movq	%rdi, %rsi
	movq	%r12, %rdi
	call	LDL_fft
	movq	%r15, 40(%rsp)
	shrq	%r15
	salq	$3, %r15
	leaq	(%r14,%r15), %rdx
	movq	%rdx, %rsi
	movl	%ebx, %ecx
	movq	%rbp, %rdx
	movq	%rsi, 24(%rsp)
	movq	%r14, %rdi
	call	falcon_poly_split_fft@PLT
	leaq	0(%rbp,%r15), %rcx
	movq	%rcx, %r10
	movl	%ebx, %ecx
	movq	%r12, %rdx
	movq	%r10, 32(%rsp)
	movq	%r10, %rsi
	movq	%rbp, %rdi
	call	falcon_poly_split_fft@PLT
	leal	-1(%rbx), %r15d
	movq	16(%rsp), %rdi
	addq	%r13, %rdi
	movq	%r12, %r8
	movl	%r15d, %ecx
	movq	24(%rsp), %rdx
	movq	%r14, %rsi
	call	ffLDL_fft_inner
	movl	%r15d, %ecx
	sall	%cl, %ebx
	movq	40(%rsp), %rax
	addq	%rax, %rbx
	leaq	0(%r13,%rbx,8), %rdi
	movq	%r12, %r8
	movl	%r15d, %ecx
	movq	32(%rsp), %rdx
	movq	%rbp, %rsi
	call	ffLDL_fft_inner
	addq	$16, %rsp
	.cfi_def_cfa_offset 96
	jmp	.L26
	.cfi_endproc
.LFE35:
	.size	ffLDL_fft_inner, .-ffLDL_fft_inner
	.type	smallints_to_fpr, @function
smallints_to_fpr:
.LFB50:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	leal	1(%rcx,%rcx), %ebp
	subl	%ecx, %edx
	movl	%edx, %ecx
	salq	%cl, %rbp
	testq	%rbp, %rbp
	je	.L30
	movq	%rdi, %r12
	movq	%rsi, %r13
	movl	$0, %ebx
.L32:
	movswq	0(%r13,%rbx,2), %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, (%r12,%rbx,8)
	addq	$1, %rbx
	cmpq	%rbx, %rbp
	jne	.L32
.L30:
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE50:
	.size	smallints_to_fpr, .-smallints_to_fpr
	.type	ffSampling_inner_fft3, @function
ffSampling_inner_fft3:
.LFB59:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movq	%rdi, 8(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rdx, %r14
	movq	%rcx, %rbx
	movq	%r8, (%rsp)
	movq	%r9, 40(%rsp)
	movq	144(%rsp), %rdx
	movl	152(%rsp), %ebp
	movq	160(%rsp), %r12
	testl	%ebp, %ebp
	je	.L39
	movl	$1, %eax
	movl	%ebp, %ecx
	salq	%cl, %rax
	movq	%rax, %rcx
	shrq	%rcx
	leaq	0(,%rcx,8), %r13
	leaq	(%r12,%r13), %rcx
	movq	%rcx, 32(%rsp)
	movl	$8, %esi
	movl	%ebp, %ecx
	salq	%cl, %rsi
	movq	%rsi, %r15
	movq	(%rsp), %rdi
	leaq	(%rdi,%rsi), %rsi
	movq	%rsi, 64(%rsp)
	leal	-1(%rbp), %esi
	movl	%ebp, %r10d
	movl	%esi, 28(%rsp)
	movzbl	28(%rsp), %ecx
	sall	%cl, %r10d
	addq	%r10, %rax
	leaq	(%rdi,%rax,8), %r10
	movq	%r10, 72(%rsp)
	leaq	(%rbx,%r13), %r11
	movl	%ebp, %ecx
	movq	%r11, 56(%rsp)
	movq	%r11, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_split_deep_fft3@PLT
	leaq	(%r12,%r15), %rdx
	subq	$8, %rsp
	.cfi_def_cfa_offset 152
	movq	%rdx, 56(%rsp)
	pushq	%rdx
	.cfi_def_cfa_offset 160
	movl	44(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	80(%rsp)
	.cfi_def_cfa_offset 176
	movq	%rbx, %r9
	movq	104(%rsp), %r8
	movq	64(%rsp), %rcx
	movq	%r12, %rdx
	movq	48(%rsp), %rsi
	movq	40(%rsp), %rdi
	call	ffSampling_inner_fft3
	addq	$32, %rsp
	.cfi_def_cfa_offset 144
	movl	%ebp, %ecx
	movq	32(%rsp), %rdx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_merge_deep_fft3@PLT
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	memcpy@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	(%rsp), %rsi
	movq	%r12, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	40(%rsp), %rsi
	movq	%r12, %rdi
	call	falcon_poly_add3@PLT
	addq	%r14, %r13
	movl	%ebp, %ecx
	movq	%r12, %rdx
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	falcon_poly_split_deep_fft3@PLT
	subq	$8, %rsp
	.cfi_def_cfa_offset 152
	pushq	56(%rsp)
	.cfi_def_cfa_offset 160
	movl	44(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%r13
	.cfi_def_cfa_offset 176
	movq	%r14, %r9
	movq	96(%rsp), %r8
	movq	64(%rsp), %r13
	movq	%r13, %rcx
	movq	%r12, %rdx
	movq	48(%rsp), %rsi
	movq	40(%rsp), %rdi
	call	ffSampling_inner_fft3
	addq	$32, %rsp
	.cfi_def_cfa_offset 144
	movl	%ebp, %ecx
	movq	%r13, %rdx
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	falcon_poly_merge_deep_fft3@PLT
	movq	%r15, %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	memcpy@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	(%rsp), %rsi
	movq	%r12, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	falcon_poly_sub3@PLT
.L35:
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L39:
	.cfi_restore_state
	movq	(%r8), %r15
	movq	(%rdx), %rbp
	movq	(%r9), %r13
	movq	%r15, %rsi
	movabsq	$4607879128087016220, %rdi
	call	fpr_mul@PLT
	movq	%rax, %rdx
	movq	%rbp, %rsi
	movq	16(%rsp), %rdi
	movq	8(%rsp), %rax
	call	*%rax
	movslq	%eax, %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movabsq	$-9223372036854775808, %r12
	movq	%rax, %rsi
	xorq	%r12, %rsi
	movq	%rbp, %rdi
	call	fpr_add@PLT
	movabsq	$-4503599627370496, %rbp
	movq	%rax, (%rsp)
	addq	%rax, %rbp
	movq	%rbp, %rcx
	shrq	$52, %rcx
	movq	%rcx, %rax
	andl	$2047, %eax
	addl	$1, %eax
	shrl	$11, %eax
	movl	%eax, %eax
	subq	$1, %rax
	andq	%rax, %rbp
	movq	%rbp, %rsi
	movq	%r13, %rdi
	call	fpr_add@PLT
	movq	%rax, %r13
	movq	%r15, %rdx
	movq	%rax, %rsi
	movq	16(%rsp), %rdi
	movq	8(%rsp), %rax
	call	*%rax
	movslq	%eax, %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	xorq	%r12, %rax
	movq	%rax, %rsi
	movq	%r13, %rdi
	call	fpr_add@PLT
	movq	%rax, %rdi
	movq	%rbp, %rsi
	xorq	%r12, %rsi
	call	fpr_add@PLT
	movq	%rax, (%r14)
	movq	(%rsp), %rdx
	movq	%rdx, (%rbx)
	jmp	.L35
	.cfi_endproc
.LFE59:
	.size	ffSampling_inner_fft3, .-ffSampling_inner_fft3
	.type	ffSampling_depth1_fft3, @function
ffSampling_depth1_fft3:
.LFB60:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$104, %rsp
	.cfi_def_cfa_offset 160
	movq	%rdi, 56(%rsp)
	movq	%rsi, 64(%rsp)
	movq	%rdx, %r12
	movq	%rcx, 8(%rsp)
	movl	184(%rsp), %ebp
	movq	192(%rsp), %rbx
	movl	$24, %eax
	movl	%ebp, %ecx
	salq	%cl, %rax
	movq	%r9, 32(%rsp)
	leaq	(%r9,%rax), %r10
	leal	-1(%rbp), %r11d
	movl	%ebp, %r14d
	movl	%r11d, 44(%rsp)
	movzbl	44(%rsp), %ecx
	sall	%cl, %r14d
	salq	$3, %r14
	movq	%r10, 80(%rsp)
	leaq	(%r10,%r14), %r15
	movq	%r15, 88(%rsp)
	addq	%r15, %r14
	movq	%r14, 72(%rsp)
	movl	$1, %eax
	movl	%ebp, %ecx
	salq	%cl, %rax
	shrq	%rax
	leaq	0(,%rax,8), %r14
	leaq	(%rbx,%r14), %r10
	movq	%r10, 24(%rsp)
	leaq	(%r8,%r14), %r15
	movl	%ebp, %ecx
	movq	176(%rsp), %rdx
	movq	%r15, %rsi
	movq	%r8, 16(%rsp)
	movq	%r8, %rdi
	call	falcon_poly_split_deep_fft3@PLT
	movl	$8, %r13d
	movl	%ebp, %ecx
	salq	%cl, %r13
	leaq	(%rbx,%r13), %rdx
	subq	$8, %rsp
	.cfi_def_cfa_offset 168
	movq	%rdx, 56(%rsp)
	pushq	%rdx
	.cfi_def_cfa_offset 176
	movl	60(%rsp), %r11d
	pushq	%r11
	.cfi_def_cfa_offset 184
	pushq	%r15
	.cfi_def_cfa_offset 192
	movq	48(%rsp), %r15
	movq	%r15, %r9
	movq	104(%rsp), %r8
	movq	56(%rsp), %rcx
	movq	%rbx, %rdx
	movq	96(%rsp), %rsi
	movq	88(%rsp), %rdi
	call	ffSampling_inner_fft3
	addq	$32, %rsp
	.cfi_def_cfa_offset 160
	movl	%ebp, %ecx
	movq	24(%rsp), %rdx
	movq	%rbx, %rsi
	movq	%r15, %rdi
	call	falcon_poly_merge_deep_fft3@PLT
	movq	%r13, %rdx
	movq	%r15, 16(%rsp)
	movq	%r15, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	$16, %eax
	movl	%ebp, %ecx
	salq	%cl, %rax
	movq	32(%rsp), %r9
	addq	%r9, %rax
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	%rax, 72(%rsp)
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	168(%rsp), %rsi
	movq	%rbx, %rdi
	call	falcon_poly_add3@PLT
	movq	8(%rsp), %rax
	leaq	(%rax,%r14), %r15
	movl	%ebp, %ecx
	movq	%rbx, %rdx
	movq	%r15, %rsi
	movq	%rax, %rdi
	call	falcon_poly_split_deep_fft3@PLT
	subq	$8, %rsp
	.cfi_def_cfa_offset 168
	pushq	56(%rsp)
	.cfi_def_cfa_offset 176
	movl	60(%rsp), %r11d
	pushq	%r11
	.cfi_def_cfa_offset 184
	pushq	%r15
	.cfi_def_cfa_offset 192
	movq	40(%rsp), %r15
	movq	%r15, %r9
	movq	120(%rsp), %r8
	movq	56(%rsp), %rcx
	movq	%rbx, %rdx
	movq	96(%rsp), %rsi
	movq	88(%rsp), %rdi
	call	ffSampling_inner_fft3
	addq	$32, %rsp
	.cfi_def_cfa_offset 160
	movl	%ebp, %ecx
	movq	24(%rsp), %rdx
	movq	%rbx, %rsi
	movq	%r15, 8(%rsp)
	movq	%r15, %rdi
	call	falcon_poly_merge_deep_fft3@PLT
	movq	%r13, %rdx
	movq	16(%rsp), %r15
	movq	%r15, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	72(%rsp), %rsi
	movq	%rbx, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movq	8(%rsp), %rdi
	call	falcon_poly_sub3@PLT
	movq	%r13, %rdx
	movq	160(%rsp), %rsi
	movq	%r12, %rdi
	call	memcpy@PLT
	movq	%r13, %rdx
	movq	8(%rsp), %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	falcon_poly_add3@PLT
	movq	%r13, %rdx
	movq	%r15, 16(%rsp)
	movq	%r15, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movq	32(%rsp), %r9
	leaq	(%r9,%r13), %r15
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	%r15, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	falcon_poly_add3@PLT
	addq	%r12, %r14
	movq	%r13, %rdx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	%ebp, %ecx
	movq	%rbx, %rdx
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	falcon_poly_split_deep_fft3@PLT
	subq	$8, %rsp
	.cfi_def_cfa_offset 168
	pushq	56(%rsp)
	.cfi_def_cfa_offset 176
	movl	60(%rsp), %r11d
	pushq	%r11
	.cfi_def_cfa_offset 184
	pushq	%r14
	.cfi_def_cfa_offset 192
	movq	%r12, %r9
	movq	112(%rsp), %r8
	movq	56(%rsp), %r14
	movq	%r14, %rcx
	movq	%rbx, %rdx
	movq	96(%rsp), %rsi
	movq	88(%rsp), %rdi
	call	ffSampling_inner_fft3
	addq	$32, %rsp
	.cfi_def_cfa_offset 160
	movl	%ebp, %ecx
	movq	%r14, %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	falcon_poly_merge_deep_fft3@PLT
	movq	%r13, %rdx
	movq	8(%rsp), %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	falcon_poly_sub3@PLT
	movq	%r13, %rdx
	movq	16(%rsp), %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	%r15, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$0, %ecx
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	falcon_poly_sub3@PLT
	addq	$104, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE60:
	.size	ffSampling_depth1_fft3, .-ffSampling_depth1_fft3
	.type	ffSampling_fft, @function
ffSampling_fft:
.LFB58:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movq	%rdi, 8(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rdx, %r15
	movq	%rcx, %r13
	movq	%r8, %r14
	movq	%r9, 48(%rsp)
	movl	152(%rsp), %ebx
	movq	160(%rsp), %r12
	testl	%ebx, %ebx
	jne	.L43
	movq	%rdi, %rax
	movq	%rsi, %rdi
	movq	144(%rsp), %rbx
	movq	(%rbx), %rbx
	movq	(%r8), %rbp
	movq	(%r9), %rsi
	movq	%rbp, %rdx
	movq	%rdi, %r12
	movq	%rax, %r14
	call	*%rax
	movslq	%eax, %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, (%r15)
	movq	%rbp, %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	*%r14
	movslq	%eax, %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, 0(%r13)
.L42:
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L43:
	.cfi_restore_state
	movl	$1, %ebp
	movl	%ebx, %ecx
	salq	%cl, %rbp
	movl	$8, %eax
	salq	%cl, %rax
	movq	%rax, 24(%rsp)
	leaq	(%r8,%rax), %rdx
	movq	%rdx, 64(%rsp)
	leal	-1(%rbx), %edx
	movl	%ebx, %esi
	movl	%edx, 36(%rsp)
	movzbl	36(%rsp), %ecx
	sall	%cl, %esi
	movq	%rsi, %rax
	addq	%rbp, %rax
	leaq	(%r8,%rax,8), %rcx
	movq	%rcx, 72(%rsp)
	shrq	%rbp
	salq	$3, %rbp
	leaq	0(%r13,%rbp), %rcx
	movq	%rcx, %rsi
	movl	%ebx, %ecx
	movq	144(%rsp), %rdx
	movq	%rsi, 40(%rsp)
	movq	%r13, %rdi
	call	falcon_poly_split_fft@PLT
	movq	24(%rsp), %rax
	leaq	(%r12,%rax), %r10
	leaq	(%r12,%rbp), %rcx
	subq	$8, %rsp
	.cfi_def_cfa_offset 152
	movq	%r10, 64(%rsp)
	pushq	%r10
	.cfi_def_cfa_offset 160
	movl	52(%rsp), %edi
	pushq	%rdi
	.cfi_def_cfa_offset 168
	pushq	64(%rsp)
	.cfi_def_cfa_offset 176
	movq	%r13, %r9
	movq	104(%rsp), %r8
	movq	%rcx, 72(%rsp)
	movq	%r12, %rdx
	movq	48(%rsp), %rsi
	movq	40(%rsp), %rdi
	call	ffSampling_fft
	addq	$32, %rsp
	.cfi_def_cfa_offset 144
	movl	%ebx, %ecx
	movq	40(%rsp), %rdx
	movq	%r12, %rsi
	movq	%r13, %rdi
	call	falcon_poly_merge_fft@PLT
	movq	24(%rsp), %rdx
	movq	144(%rsp), %rsi
	movq	%r12, %rdi
	call	memcpy@PLT
	movl	%ebx, %edx
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	falcon_poly_sub@PLT
	movl	%ebx, %edx
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	falcon_poly_mul_fft@PLT
	movl	%ebx, %edx
	movq	48(%rsp), %rsi
	movq	%r12, %rdi
	call	falcon_poly_add@PLT
	addq	%r15, %rbp
	movl	%ebx, %ecx
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%r15, %rdi
	call	falcon_poly_split_fft@PLT
	subq	$8, %rsp
	.cfi_def_cfa_offset 152
	pushq	64(%rsp)
	.cfi_def_cfa_offset 160
	movl	52(%rsp), %eax
	pushq	%rax
	.cfi_def_cfa_offset 168
	pushq	%rbp
	.cfi_def_cfa_offset 176
	movq	%r15, %r9
	movq	96(%rsp), %r8
	movq	72(%rsp), %r14
	movq	%r14, %rcx
	movq	%r12, %rdx
	movq	48(%rsp), %rsi
	movq	40(%rsp), %rdi
	call	ffSampling_fft
	addq	$32, %rsp
	.cfi_def_cfa_offset 144
	movl	%ebx, %ecx
	movq	%r14, %rdx
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	falcon_poly_merge_fft@PLT
	jmp	.L42
	.cfi_endproc
.LFE58:
	.size	ffSampling_fft, .-ffSampling_fft
	.type	BerExp, @function
BerExp:
.LFB66:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movabsq	$4609176140021203710, %rsi
	movq	%rbp, %rdi
	call	fpr_mul@PLT
	movq	%rax, %rdx
	shrq	$52, %rdx
	andl	$2047, %edx
	movq	%rax, %rdi
	sarq	$63, %rdi
	movq	%rax, %rcx
	salq	$10, %rcx
	btrq	$63, %rcx
	btsq	$62, %rcx
	xorq	%rdi, %rcx
	shrq	$63, %rax
	leaq	(%rax,%rcx), %rsi
	movl	$1085, %ecx
	subl	%edx, %ecx
	subl	$1022, %edx
	shrl	$31, %edx
	movl	%edx, %eax
	movq	%rsi, %r12
	sarq	$32, %r12
	testb	$32, %cl
	cmove	%rsi, %r12
	andl	$31, %ecx
	sarq	%cl, %r12
	leaq	-1(%rax), %rdx
	andq	%rdx, %r12
	negq	%rax
	andq	%rax, %rdi
	orq	%rdi, %r12
	movslq	%r12d, %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, %rdi
	movabsq	$4604418534313441775, %rsi
	call	fpr_mul@PLT
	btcq	$63, %rax
	movq	%rax, %rsi
	movq	%rbp, %rdi
	call	fpr_add@PLT
	movq	%rax, %r13
	movl	$63, %eax
	subl	%r12d, %eax
	movl	%eax, %ebp
	shrl	$31, %ebp
	movl	%r12d, %edx
	xorl	$63, %edx
	sarl	$31, %eax
	andl	%edx, %eax
	xorl	%eax, %r12d
	movq	4096(%rbx), %rax
	cmpq	$4086, %rax
	ja	.L52
.L47:
	leaq	8(%rax), %rdx
	movq	%rdx, 4096(%rbx)
	movq	(%rbx,%rax), %rdx
	movq	%rdx, %rax
	movl	%r12d, %ecx
	shrq	%cl, %rax
	salq	%cl, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	negq	%rdx
	orq	%rax, %rdx
	shrq	$63, %rdx
	xorl	$1, %edx
	xorl	$1, %ebp
	andl	%edx, %ebp
	movabsq	$4890909195324358656, %rsi
	movq	%r13, %rdi
	call	fpr_mul@PLT
	movq	%rax, %rsi
	movq	%rax, %rdi
	shrq	$52, %rdi
	andl	$2047, %edi
	salq	$10, %rax
	movabsq	$4611686018427387903, %rdx
	andq	%rdx, %rax
	btsq	$62, %rax
	movl	$1085, %ecx
	subl	%edi, %ecx
	movq	%rax, %rdx
	shrq	$32, %rdx
	testb	$32, %cl
	cmovne	%rdx, %rax
	andl	$31, %ecx
	shrq	%cl, %rax
	movq	%rax, %rdx
	movl	$1021, %eax
	subl	%edi, %eax
	shrl	$31, %eax
	movl	%eax, %eax
	negq	%rax
	andq	%rdx, %rax
	movq	%rsi, %rdx
	sarq	$63, %rdx
	xorq	%rdx, %rax
	shrq	$63, %rsi
	addq	%rax, %rsi
	addq	%rsi, %rsi
	movq	%rsi, %rdi
	shrq	$32, %rdi
	leaq	8+fpr_expm_p63_coefficients(%rip), %rcx
	leaq	96(%rcx), %r8
	movabsq	$19127174051, %rdx
	movl	%esi, %esi
.L48:
	movq	%rdx, %r10
	shrq	$32, %r10
	movl	%edx, %edx
	movq	%rsi, %rax
	imulq	%rdx, %rax
	shrq	$32, %rax
	movq	%r10, %r9
	imulq	%rsi, %r9
	addq	%r9, %rax
	imulq	%rdi, %rdx
	movq	%rdx, %r9
	imulq	%rdi, %r10
	movq	(%rcx), %rdx
	subq	%r10, %rdx
	movq	%r9, %r10
	shrq	$32, %r10
	subq	%r10, %rdx
	movq	%rax, %r10
	shrq	$32, %r10
	subq	%r10, %rdx
	movl	%eax, %eax
	movl	%r9d, %r9d
	addq	%r9, %rax
	shrq	$32, %rax
	subq	%rax, %rdx
	addq	$8, %rcx
	cmpq	%r8, %rcx
	jne	.L48
	shrq	$8, %rdx
	movq	%rdx, %r12
	movq	4096(%rbx), %rdx
	cmpq	$4086, %rdx
	ja	.L53
.L49:
	leaq	8(%rdx), %rax
	movq	%rax, 4096(%rbx)
	movabsq	$36028797018963967, %rax
	andq	(%rbx,%rdx), %rax
	subq	%r12, %rax
	shrq	$63, %rax
	andl	%ebp, %eax
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L52:
	.cfi_restore_state
	movq	%rbx, %rdi
	call	falcon_prng_refill@PLT
	movl	$0, %eax
	jmp	.L47
.L53:
	movq	%rbx, %rdi
	call	falcon_prng_refill@PLT
	movl	$0, %edx
	jmp	.L49
	.cfi_endproc
.LFE66:
	.size	BerExp, .-BerExp
	.type	sampler, @function
sampler:
.LFB67:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%rdi, %r14
	movq	%rsi, %rbx
	movq	%rdx, %rbp
	movq	%rsi, %rax
	shrq	$52, %rax
	andl	$2047, %eax
	sarq	$63, %rsi
	movq	%rbx, %rdx
	salq	$10, %rdx
	btrq	$63, %rdx
	btsq	$62, %rdx
	xorq	%rsi, %rdx
	movq	%rbx, %rdi
	shrq	$63, %rdi
	addq	%rdx, %rdi
	movl	$1085, %ecx
	subl	%eax, %ecx
	subl	$1022, %eax
	shrl	$31, %eax
	movl	%eax, %eax
	movq	%rdi, %rdx
	sarq	$32, %rdx
	testb	$32, %cl
	cmove	%rdi, %rdx
	andl	$31, %ecx
	sarq	%cl, %rdx
	leaq	-1(%rax), %rcx
	andq	%rcx, %rdx
	negq	%rax
	andq	%rax, %rsi
	orq	%rsi, %rdx
	movq	%rdx, %r13
	movslq	%edx, %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	btcq	$63, %rax
	movq	%rax, %rsi
	movq	%rbx, %rdi
	call	fpr_add@PLT
	movq	%rax, %rbx
	movl	$0, %esi
	movl	$2, %edi
	call	fpr_scaled@PLT
	movq	%rax, %r12
	movq	%rbp, %rsi
	movq	%rbp, %rdi
	call	fpr_mul@PLT
	movq	%rax, %rdi
	movq	%r12, %rsi
	call	fpr_mul@PLT
	movq	%rax, %rsi
	movabsq	$4607182418800017408, %rdi
	call	fpr_div@PLT
	movq	%rax, 24(%rsp)
	leaq	352+CDF0(%rip), %r15
	movabsq	$-9223372036854775808, %rax
	xorq	%rbx, %rax
	movq	%rax, 32(%rsp)
	movq	%r13, 40(%rsp)
	jmp	.L60
.L66:
	movq	%r14, %rdi
	call	falcon_prng_refill@PLT
	jmp	.L55
.L67:
	movq	%r14, %rdi
	call	falcon_prng_refill@PLT
	movq	%r14, %r12
	movq	(%r14), %rbx
	movl	$8, %ebp
.L57:
	leaq	8(%rbp), %rcx
	movq	%rcx, 4096(%r14)
	movq	(%r12,%rbp), %r10
	leaq	CDFs(%rip), %r11
	movl	$0, %r8d
	movl	$0, %edx
	movl	$1, %eax
	movzbl	%r13b, %r12d
	movq	%rbp, 8(%rsp)
	movq	%rcx, 16(%rsp)
.L58:
	leaq	CDF8(%rip), %rcx
	movzbl	(%rcx,%r8), %ebp
	movq	%rbp, %r9
	subq	%r12, %r9
	movq	(%r11), %rsi
	movq	%rsi, %rcx
	subq	%rbx, %rcx
	movq	%rbx, %rdi
	subq	%rsi, %rdi
	orq	%rcx, %rdi
	notq	%rdi
	shrq	$63, %rdi
	movq	%r10, %rsi
	subq	8(%r11), %rsi
	shrq	$63, %rsi
	notq	%rsi
	andq	%rdi, %rsi
	shrq	$63, %rcx
	orq	%rsi, %rcx
	movq	%r12, %rsi
	subq	%rbp, %rsi
	orq	%r9, %rsi
	notq	%rsi
	shrq	$63, %rsi
	andq	%rsi, %rcx
	shrq	$63, %r9
	orq	%r9, %rcx
	movq	%rax, %rsi
	andq	%rcx, %rsi
	negl	%esi
	andl	%r8d, %esi
	addl	%esi, %edx
	notq	%rcx
	andq	%rcx, %rax
	addq	$1, %r8
	addq	$16, %r11
	cmpq	$6, %r8
	jne	.L58
	movq	8(%rsp), %rbp
	movq	16(%rsp), %rcx
	negb	%r13b
	sbbq	%r12, %r12
	leaq	CDF0(%rip), %r9
	movl	$6, %r11d
.L59:
	movq	(%r9), %r8
	movq	%r8, %rdi
	subq	%rbx, %rdi
	movq	%rbx, %rsi
	subq	%r8, %rsi
	orq	%rdi, %rsi
	notq	%rsi
	shrq	$63, %rsi
	movq	%r10, %r8
	subq	8(%r9), %r8
	shrq	$63, %r8
	notq	%r8
	andq	%r8, %rsi
	shrq	$63, %rdi
	orq	%r12, %rdi
	orq	%rdi, %rsi
	andl	$1, %esi
	movq	%rax, %rdi
	andq	%rsi, %rdi
	negl	%edi
	andl	%r11d, %edi
	addl	%edi, %edx
	notq	%rsi
	andq	%rsi, %rax
	addq	$16, %r9
	addl	$1, %r11d
	cmpq	%r9, %r15
	jne	.L59
	addq	$9, %rbp
	movq	%rbp, 4096(%r14)
	movzbl	(%r14,%rcx), %ebp
	andl	$1, %ebp
	leal	-1(%rbp,%rbp), %ebx
	imull	%edx, %ebx
	addl	%ebx, %ebp
	movslq	%ebp, %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, %rdi
	movq	32(%rsp), %rsi
	call	fpr_add@PLT
	movq	%rax, %rdi
	movq	%rax, %rsi
	call	fpr_mul@PLT
	movq	%rax, %rdi
	movq	24(%rsp), %rsi
	call	fpr_mul@PLT
	movq	%rax, %r12
	imull	%ebx, %ebx
	movslq	%ebx, %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, %rdi
	movabsq	$4593671619917905920, %rsi
	call	fpr_mul@PLT
	movabsq	$-9223372036854775808, %rsi
	xorq	%rax, %rsi
	movq	%r12, %rdi
	call	fpr_add@PLT
	movq	%rax, %rsi
	movq	%r14, %rdi
	call	BerExp
	testl	%eax, %eax
	jne	.L65
.L60:
	movq	4096(%r14), %rdx
	leaq	1(%rdx), %rax
	movq	%rax, 4096(%r14)
	movzbl	(%r14,%rdx), %r13d
	cmpq	$4096, %rax
	je	.L66
.L55:
	movq	4096(%r14), %rax
	cmpq	$4086, %rax
	ja	.L67
	leaq	8(%rax), %rbp
	movq	%rbp, 4096(%r14)
	movq	%r14, %r12
	movq	(%r14,%rax), %rbx
	cmpq	$4086, %rbp
	jbe	.L57
	movq	%r14, %rdi
	call	falcon_prng_refill@PLT
	movl	$0, %ebp
	jmp	.L57
.L65:
	movq	40(%rsp), %r13
	leal	0(%rbp,%r13), %eax
	addq	$56, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE67:
	.size	sampler, .-sampler
	.type	clear_private, @function
clear_private:
.LFB80:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	movq	856(%rdi), %rax
	testq	%rax, %rax
	je	.L69
	movq	864(%rdi), %rcx
	testq	%rcx, %rcx
	je	.L70
	addq	%rax, %rcx
	.p2align 4
.L71:
	movq	%rax, %rdx
	addq	$1, %rax
	movb	$0, (%rdx)
	cmpq	%rcx, %rax
	jne	.L71
.L70:
	movq	856(%rbx), %rdi
	call	free@PLT
	movq	$0, 856(%rbx)
	movq	$0, 864(%rbx)
.L69:
	movq	872(%rbx), %rax
	testq	%rax, %rax
	je	.L72
	movq	880(%rbx), %rcx
	testq	%rcx, %rcx
	je	.L73
	addq	%rax, %rcx
	.p2align 4
.L74:
	movq	%rax, %rdx
	addq	$1, %rax
	movb	$0, (%rdx)
	cmpq	%rcx, %rax
	jne	.L74
.L73:
	movq	872(%rbx), %rdi
	call	free@PLT
	movq	$0, 872(%rbx)
	movq	$0, 880(%rbx)
.L72:
	movl	$0, 840(%rbx)
	movl	$0, 844(%rbx)
	movl	$0, 848(%rbx)
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE80:
	.size	clear_private, .-clear_private
	.type	ft_stable_positive, @function
ft_stable_positive:
.LFB43:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	call	ft_fpr_is_positive_finite
	movl	%eax, %edx
	xorl	$1, %edx
	orl	%edx, 0(%rbp)
	movl	%eax, %edx
	movq	%rdx, %rax
	negq	%rax
	andq	%rbx, %rax
	subq	$1, %rdx
	movabsq	$4607182418800017408, %rcx
	andq	%rcx, %rdx
	orq	%rdx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE43:
	.size	ft_stable_positive, .-ft_stable_positive
	.type	ft_stable_binary_inplace, @function
ft_stable_binary_inplace:
.LFB44:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%rdi, 32(%rsp)
	movq	%rsi, 40(%rsp)
	movq	%rdx, 8(%rsp)
	movq	%rcx, %rbx
	cmpq	$1, %rsi
	je	.L87
	movq	40(%rsp), %rax
	shrq	%rax
	movq	%rax, 16(%rsp)
	je	.L83
	movq	32(%rsp), %r15
	movq	8(%rsp), %rcx
	leaq	(%rcx,%rax,8), %rax
	movq	%rax, 24(%rsp)
	movl	$0, %ebp
.L84:
	movq	(%r15), %rdi
	movq	%rbx, %rsi
	call	ft_stable_positive
	movq	%rax, %r13
	movq	8(%r15), %rdi
	movq	%rbx, %rsi
	call	ft_stable_positive
	movq	%rax, %r14
	movq	%rax, %rsi
	movq	%r13, %rdi
	call	fpr_add@PLT
	movq	%rax, %rdi
	movq	%rbx, %rsi
	call	ft_stable_positive
	movq	%rax, %r12
	movq	%r14, %rsi
	movq	%r13, %rdi
	call	fpr_mul@PLT
	movq	%rax, %rdi
	movq	%rbx, %rsi
	call	ft_stable_positive
	movq	%rax, %r13
	movabsq	$-4503599627370496, %rax
	leaq	(%r12,%rax), %rdi
	movq	%rdi, %rax
	shrq	$52, %rax
	andl	$2047, %eax
	addl	$1, %eax
	shrl	$11, %eax
	movl	%eax, %eax
	subq	$1, %rax
	andq	%rax, %rdi
	movq	%rbx, %rsi
	call	ft_stable_positive
	movq	8(%rsp), %rcx
	movq	%rax, (%rcx,%rbp,8)
	movq	%r13, %rdi
	shrq	$52, %rdi
	andl	$2047, %edi
	addl	$2047, %edi
	shrl	$11, %edi
	salq	$52, %rdi
	addq	%r13, %rdi
	movq	%r12, %rsi
	call	fpr_div@PLT
	movq	%rax, %rdi
	movq	%rbx, %rsi
	call	ft_stable_positive
	movq	24(%rsp), %rdx
	movq	%rax, (%rdx,%rbp,8)
	addq	$1, %rbp
	addq	$16, %r15
	cmpq	%rbp, 16(%rsp)
	jne	.L84
.L83:
	movq	40(%rsp), %rdx
	salq	$3, %rdx
	movq	8(%rsp), %rbp
	movq	%rbp, %rsi
	movq	32(%rsp), %r14
	movq	%r14, %rdi
	call	memcpy@PLT
	movq	%rbx, %rcx
	movq	%rbp, %rdx
	movq	16(%rsp), %r15
	movq	%r15, %rsi
	movq	%r14, %rdi
	call	ft_stable_binary_inplace
	movq	%r15, %rsi
	leaq	(%r14,%r15,8), %rdi
	movq	%rbx, %rcx
	movq	%rbp, %rdx
	call	ft_stable_binary_inplace
.L80:
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L87:
	.cfi_restore_state
	movq	%rdi, %r15
	movq	(%rdi), %rdi
	movq	%rcx, %rsi
	call	ft_stable_positive
	movq	%rax, (%r15)
	jmp	.L80
	.cfi_endproc
.LFE44:
	.size	ft_stable_binary_inplace, .-ft_stable_binary_inplace
	.type	sampler_large, @function
sampler_large:
.LFB78:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movq	%rdx, %rbx
	movl	4368(%rdi), %eax
	movl	%eax, %edx
	movl	%eax, 8(%rsp)
	movl	$0, %eax
	testl	%edx, %edx
	jne	.L88
	movq	%rdi, %r12
	movq	%rsi, %rbp
	movabsq	$9218868437227405312, %rdx
	movq	%rsi, %rax
	notq	%rax
	testq	%rdx, %rax
	je	.L90
	movq	%rbx, %rdi
	call	ft_fpr_is_positive_finite
	testl	%eax, %eax
	jne	.L91
.L90:
	movl	$1, 4368(%r12)
	movl	$0, %eax
.L88:
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L91:
	.cfi_restore_state
	movq	%rbp, %rax
	shrq	$52, %rax
	andl	$2047, %eax
	movq	%rbp, %rsi
	sarq	$63, %rsi
	movq	%rbp, %rdx
	salq	$10, %rdx
	btrq	$63, %rdx
	btsq	$62, %rdx
	xorq	%rsi, %rdx
	movq	%rbp, %rdi
	shrq	$63, %rdi
	addq	%rdx, %rdi
	movl	$1085, %ecx
	subl	%eax, %ecx
	subl	$1022, %eax
	shrl	$31, %eax
	movl	%eax, %eax
	movq	%rdi, %rdx
	sarq	$32, %rdx
	testb	$32, %cl
	cmove	%rdi, %rdx
	andl	$31, %ecx
	sarq	%cl, %rdx
	leaq	-1(%rax), %rcx
	andq	%rcx, %rdx
	negq	%rax
	andq	%rax, %rsi
	orq	%rsi, %rdx
	movq	%rdx, %r15
	movslq	%edx, %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	btcq	$63, %rax
	movq	%rax, %rsi
	movq	%rbp, %rdi
	call	fpr_add@PLT
	movq	%rax, 16(%rsp)
	movl	$0, %esi
	movl	$2, %edi
	call	fpr_scaled@PLT
	movq	%rax, %rbp
	movq	%rbx, %rsi
	movq	%rbx, %rdi
	call	fpr_mul@PLT
	movq	%rax, %rdi
	movq	%rbp, %rsi
	call	fpr_mul@PLT
	movq	%rax, %rsi
	movabsq	$4607182418800017408, %rdi
	call	fpr_div@PLT
	movq	%rax, %rbx
	movq	%rax, %rdi
	call	ft_fpr_is_positive_finite
	leaq	49152+ft_adaptive_cdf(%rip), %r13
	leaq	ft_adaptive_cdf_inv_2sigma0_sq_bits(%rip), %r14
	movq	16(%rsp), %rdx
	movabsq	$-9223372036854775808, %rsi
	xorq	%rsi, %rdx
	movq	%rdx, 32(%rsp)
	testl	%eax, %eax
	je	.L114
	movq	%r12, %rbp
	movq	%r15, 40(%rsp)
	movq	%rbx, %r15
	jmp	.L105
.L114:
	movl	$1, 4368(%r12)
	jmp	.L88
.L119:
	movq	%rbp, %rdi
	call	falcon_prng_refill@PLT
	movq	0(%rbp), %rbx
	movl	$8, %edx
.L94:
	leaq	8(%rdx), %rsi
	movq	%rsi, 4096(%rbp)
	movq	0(%rbp,%rdx), %rdi
	leaq	48(%rsp), %rcx
	leaq	8192+ft_adaptive_cdf(%rip), %r9
	movq	%r15, (%rsp)
.L95:
	leaq	-8192(%r9), %r8
	movl	$0, %r12d
.L96:
	movq	8(%r8), %rax
	movq	(%r8), %r11
	movq	%rbx, %r10
	xorq	%r11, %r10
	movq	%rdi, %r15
	subq	%rax, %r15
	xorq	%rax, %r15
	xorq	%rdi, %rax
	orq	%rax, %r15
	xorq	%rdi, %r15
	shrq	$63, %r15
	movq	%r10, %rax
	negq	%rax
	orq	%r10, %rax
	shrq	$63, %rax
	xorq	$1, %rax
	andq	%r15, %rax
	movq	%rbx, %r15
	subq	%r11, %r15
	xorq	%r11, %r15
	orq	%r10, %r15
	xorq	%rbx, %r15
	shrq	$63, %r15
	orq	%r15, %rax
	addq	%rax, %r12
	addq	$16, %r8
	cmpq	%r8, %r9
	jne	.L96
	movl	%r12d, (%rcx)
	addq	$4, %rcx
	addq	$8192, %r9
	cmpq	%r9, %r13
	jne	.L95
	movq	(%rsp), %r15
	movl	8(%rsp), %r8d
	movl	$0, %ecx
	movl	$0, %r12d
	movl	$0, %ebx
	leaq	48(%rsp), %r9
.L97:
	movq	(%r14,%rcx,8), %r10
	movq	%r15, %rdi
	andq	%r10, %rdi
	shrq	$63, %rdi
	cmpq	%r10, %r15
	setne	%al
	movzbl	%al, %eax
	andl	%edi, %eax
	cmpq	%r10, %r15
	setge	%dil
	movzbl	%dil, %edi
	xorl	%eax, %edi
	movl	%r8d, %eax
	xorl	$1, %eax
	andl	%edi, %eax
	movl	%eax, %r11d
	negl	%r11d
	andl	(%r9,%rcx,4), %r11d
	addl	%r11d, %ebx
	movl	%eax, %eax
	negq	%rax
	andq	%r10, %rax
	orq	%rax, %r12
	orl	%edi, %r8d
	addq	$1, %rcx
	cmpq	$5, %rcx
	jne	.L97
	testl	%r8d, %r8d
	je	.L115
	addq	$9, %rdx
	movq	%rdx, 4096(%rbp)
	testb	$1, 0(%rbp,%rsi)
	je	.L99
	leal	1(%rbx), %eax
	movl	%eax, 12(%rsp)
	movl	$0, %esi
	movl	$1, %edi
	call	fpr_scaled@PLT
	movq	%rax, %rdi
	movq	32(%rsp), %rsi
	call	fpr_add@PLT
	movq	%rax, (%rsp)
.L100:
	movabsq	$-9223372036854775808, %rsi
	xorq	%r12, %rsi
	movq	%r15, %rdi
	call	fpr_add@PLT
	movq	%rax, %r12
	movq	%rax, %rdx
	notq	%rdx
	movabsq	$9218868437227405312, %rax
	testq	%rax, %rdx
	je	.L101
	testq	%r12, %r12
	js	.L116
.L102:
	movslq	%ebx, %rbx
	movq	%rbx, %rdi
	imulq	%rbx, %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, %rdi
	movq	%r12, %rsi
	call	fpr_mul@PLT
	movq	%rax, %r12
	movq	(%rsp), %rsi
	movq	%rsi, %rdi
	call	fpr_mul@PLT
	movq	%rax, 24(%rsp)
	leaq	(%rbx,%rbx), %rdi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, %rdi
	movq	(%rsp), %rsi
	call	fpr_mul@PLT
	movq	%rax, %rdi
	movq	24(%rsp), %rsi
	call	fpr_add@PLT
	movq	%rax, %rdi
	movq	%r15, %rsi
	call	fpr_mul@PLT
	movq	%rax, %rsi
	movq	%r12, %rdi
	call	fpr_add@PLT
	movq	%rax, %rsi
	movq	%rax, %rdx
	notq	%rdx
	movabsq	$9218868437227405312, %rax
	testq	%rax, %rdx
	je	.L103
	testq	%rsi, %rsi
	js	.L117
.L104:
	movq	%rbp, %rdi
	call	BerExp
	testl	%eax, %eax
	jne	.L118
.L105:
	movq	4096(%rbp), %rax
	cmpq	$4086, %rax
	ja	.L119
	leaq	8(%rax), %rdx
	movq	%rdx, 4096(%rbp)
	movq	0(%rbp,%rax), %rbx
	cmpq	$4086, %rdx
	jbe	.L94
	movq	%rbp, %rdi
	call	falcon_prng_refill@PLT
	movl	$0, %edx
	jmp	.L94
.L115:
	movl	$2, 4368(%rbp)
	movl	$0, %eax
	jmp	.L88
.L99:
	movl	%ebx, %eax
	negl	%eax
	movl	%eax, 12(%rsp)
	movq	16(%rsp), %rax
	movq	%rax, (%rsp)
	jmp	.L100
.L116:
	movq	%r12, %rax
	addq	%rax, %rax
	je	.L102
.L101:
	movl	$2, 4368(%rbp)
	movl	$0, %eax
	jmp	.L88
.L117:
	movq	%rsi, %rax
	addq	%rax, %rax
	je	.L104
.L103:
	movl	$3, 4368(%rbp)
	movl	$0, %eax
	jmp	.L88
.L118:
	movq	40(%rsp), %r15
	movl	12(%rsp), %eax
	addl	%r15d, %eax
	jmp	.L88
	.cfi_endproc
.LFE78:
	.size	sampler_large, .-sampler_large
	.globl	falcon_sign_new
	.type	falcon_sign_new, @function
falcon_sign_new:
.LFB81:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	$888, %edi
	call	malloc@PLT
	movq	%rax, %rbx
	testq	%rax, %rax
	je	.L120
	movl	$0, 832(%rax)
	movl	$0, 836(%rax)
	movl	$0, 840(%rax)
	movl	$0, 844(%rax)
	movl	$0, 848(%rax)
	movq	$0, 856(%rax)
	movq	$0, 864(%rax)
	movq	$0, 872(%rax)
	movq	$0, 880(%rax)
	leaq	416(%rax), %rdi
	movl	$512, %esi
	call	shake_init@PLT
.L120:
	movq	%rbx, %rax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE81:
	.size	falcon_sign_new, .-falcon_sign_new
	.globl	falcon_sign_free
	.type	falcon_sign_free, @function
falcon_sign_free:
.LFB82:
	.cfi_startproc
	testq	%rdi, %rdi
	je	.L126
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	call	clear_private
	movq	%rbx, %rdi
	call	free@PLT
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L126:
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE82:
	.size	falcon_sign_free, .-falcon_sign_free
	.globl	falcon_sign_set_seed
	.type	falcon_sign_set_seed, @function
falcon_sign_set_seed:
.LFB83:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$32, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, %rbx
	movq	%rsi, %r12
	movq	%rdx, %rbp
	testl	%ecx, %ecx
	jne	.L134
	cmpl	$0, 836(%rdi)
	jne	.L135
.L132:
	leaq	416(%rbx), %rdi
	movq	%rbp, %rdx
	movq	%r12, %rsi
	call	shake_inject@PLT
.L129:
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L134:
	.cfi_restore_state
	leaq	416(%rdi), %r13
	movl	$512, %esi
	movq	%r13, %rdi
	call	shake_init@PLT
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%r13, %rdi
	call	shake_inject@PLT
	movl	$1, 832(%rbx)
	movl	$0, 836(%rbx)
	jmp	.L129
.L135:
	leaq	416(%rdi), %r13
	movl	$32, %edx
	movq	%rsp, %rsi
	movq	%r13, %rdi
	call	shake_extract@PLT
	movl	$512, %esi
	movq	%r13, %rdi
	call	shake_init@PLT
	movl	$32, %edx
	movq	%rsp, %rsi
	movq	%r13, %rdi
	call	shake_inject@PLT
	movl	$0, 836(%rbx)
	jmp	.L132
	.cfi_endproc
.LFE83:
	.size	falcon_sign_set_seed, .-falcon_sign_set_seed
	.type	rng_ready, @function
rng_ready:
.LFB84:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx
	cmpl	$0, 832(%rdi)
	je	.L142
.L137:
	movl	$1, %eax
	cmpl	$0, 836(%rbx)
	je	.L143
.L136:
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L142:
	.cfi_restore_state
	movq	%rsp, %rdi
	movl	$32, %esi
	call	falcon_get_seed@PLT
	testl	%eax, %eax
	je	.L136
	movq	%rsp, %rsi
	movl	$0, %ecx
	movl	$32, %edx
	movq	%rbx, %rdi
	call	falcon_sign_set_seed
	movl	$1, 832(%rbx)
	jmp	.L137
.L143:
	leaq	416(%rbx), %rdi
	call	shake_flip@PLT
	movl	$1, 836(%rbx)
	movl	$1, %eax
	jmp	.L136
	.cfi_endproc
.LFE84:
	.size	rng_ready, .-rng_ready
	.globl	falcon_sign_set_private_key
	.type	falcon_sign_set_private_key, @function
falcon_sign_set_private_key:
.LFB85:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24712, %rsp
	.cfi_def_cfa_offset 24768
	movq	%rdi, %r14
	movq	%rdi, 32(%rsp)
	movq	%rsi, %rbx
	movq	%rdx, %rbp
	call	clear_private
	testq	%rbx, %rbx
	je	.L145
	testq	%rbp, %rbp
	je	.L145
	movzbl	(%rbx), %eax
	movzbl	%al, %ecx
	movl	%eax, %edx
	andl	$15, %edx
	movl	%edx, 844(%r14)
	movl	%ecx, %esi
	sarl	$7, %esi
	movl	%esi, 848(%r14)
	je	.L146
	movl	$18433, 840(%r14)
	cmpl	$10, %edx
	je	.L147
.L145:
	movq	32(%rsp), %rdi
	call	clear_private
	movl	$0, %eax
.L144:
	addq	$24712, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L146:
	.cfi_restore_state
	movq	32(%rsp), %rdi
	movl	$12289, 840(%rdi)
	subl	$1, %edx
	cmpl	$9, %edx
	ja	.L145
.L147:
	addq	$1, %rbx
	leaq	-1(%rbp), %rdi
	andl	$16, %eax
	movl	%eax, %r14d
	sarl	$5, %ecx
	andl	$3, %ecx
	movl	%ecx, %r13d
	leaq	128(%rsp), %rbp
	cmpb	$1, %al
	sbbq	%rax, %rax
	andl	$6144, %eax
	leaq	18560(%rsp,%rax), %r15
	movq	%rbp, %r12
	movb	%r14b, 8(%rsp)
	movq	%rbp, 16(%rsp)
	movq	%rdi, %rbp
	movq	32(%rsp), %r14
.L148:
	movl	840(%r14), %ecx
	movl	844(%r14), %esi
	movq	%rbp, %r9
	movq	%rbx, %r8
	movl	%r13d, %edx
	movq	%r12, %rdi
	call	falcon_decode_small@PLT
	testq	%rax, %rax
	je	.L145
	addq	%rax, %rbx
	subq	%rax, %rbp
	addq	$6144, %r12
	cmpq	%r15, %r12
	jne	.L148
	movzbl	8(%rsp), %r14d
	movq	%rbp, %rax
	movq	%rbp, 64(%rsp)
	movq	16(%rsp), %rbp
	testq	%rax, %rax
	jne	.L145
	testb	%r14b, %r14b
	jne	.L181
.L149:
	movq	32(%rsp), %rax
	movl	848(%rax), %ebx
	testl	%ebx, %ebx
	je	.L150
	movl	844(%rax), %eax
	leal	-1(%rax), %ecx
	leal	18(%rax,%rax,2), %eax
	salq	%cl, %rax
	leaq	0(,%rax,8), %rdi
	movl	$168, %eax
	salq	%cl, %rax
	movq	%rax, %r12
.L151:
	movq	32(%rsp), %r15
	movq	%rdi, 864(%r15)
	movq	%r12, 880(%r15)
	call	malloc@PLT
	movq	%rax, 40(%rsp)
	movq	%rax, 856(%r15)
	testq	%rax, %rax
	je	.L145
	movq	%r12, %rdi
	call	malloc@PLT
	movq	%rax, %r14
	movq	%rax, 8(%rsp)
	movq	%rax, 872(%r15)
	testq	%rax, %rax
	je	.L145
	testl	%ebx, %ebx
	je	.L152
	movl	$12288, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movq	%r14, %r11
	movq	64(%rsp), %rdi
	movl	$0, %r10d
	jmp	.L157
.L181:
	leaq	128(%rsp), %rsi
	leaq	12416(%rsp), %rcx
	leaq	6272(%rsp), %rdx
	leaq	18560(%rsp), %rdi
	movq	32(%rsp), %rax
	movl	848(%rax), %r9d
	movl	844(%rax), %r8d
	call	falcon_complete_private@PLT
	testl	%eax, %eax
	jne	.L149
	jmp	.L145
.L150:
	movq	32(%rsp), %rax
	movl	844(%rax), %ecx
	leal	5(%rcx), %eax
	salq	%cl, %rax
	leaq	0(,%rax,8), %rdi
	movl	$56, %eax
	salq	%cl, %rax
	movq	%rax, %r12
	jmp	.L151
.L153:
	cmpq	$767, %rsi
	ja	.L155
	subq	%rcx, -12288(%rdx)
	addq	%rcx, -6144(%rdx)
.L154:
	addq	$8, %rdx
	addq	$1, %rsi
	cmpq	%rsi, %rdi
	je	.L182
.L156:
	movswq	21504(%rbp,%rsi,2), %rcx
	imulq	%r13, %rcx
	movswq	15360(%rbp,%rsi,2), %r8
	imulq	%r9, %r8
	subq	%r8, %rcx
	cmpq	$-1536, %rsi
	jb	.L153
	addq	%rcx, (%rdx)
	jmp	.L154
.L155:
	subq	%rcx, -18432(%rdx)
	jmp	.L154
.L182:
	addq	$1, %rdi
	addq	$8, %r11
	subq	$2, %rbp
	cmpq	$1536, %rdi
	je	.L183
.L157:
	movzwl	128(%rsp,%rdi,2), %r13d
	movzwl	6272(%rsp,%rdi,2), %r9d
	movswl	%r13w, %edx
	addl	$1, %edx
	cmpl	$2, %edx
	seta	%dl
	movswl	%r9w, %ecx
	addl	$1, %ecx
	cmpl	$2, %ecx
	seta	%cl
	orl	%ecx, %edx
	movzbl	%dl, %edx
	orl	%edx, %r10d
	leaq	-1536(%rdi), %rsi
	movq	%r11, %rdx
	movswq	%r13w, %r13
	movswq	%r9w, %r9
	jmp	.L156
.L183:
	movq	8(%rsp), %rdi
	subq	$18433, (%rdi)
	leaq	12288(%rdi), %rcx
.L158:
	cmpq	$0, (%rax)
	setne	%dl
	movzbl	%dl, %edx
	orl	%edx, %r10d
	addq	$8, %rax
	cmpq	%rax, %rcx
	jne	.L158
	testl	%r10d, %r10d
	jne	.L145
.L152:
	movq	%r12, %rdx
	movl	$0, %esi
	movq	8(%rsp), %rdi
	call	memset@PLT
	movq	32(%rsp), %rax
	movl	844(%rax), %r15d
	movl	840(%rax), %eax
	movl	%eax, 56(%rsp)
	leal	1(%rbx,%rbx), %eax
	movl	%r15d, %ecx
	subl	%ebx, %ecx
	movq	%rax, %r13
	salq	%cl, %r13
	leaq	0(,%r13,8), %rbp
	movq	40(%rsp), %rax
	leaq	(%rax,%rbp), %r12
	leaq	(%r12,%rbp), %rax
	movq	%rax, 24(%rsp)
	leaq	(%rax,%rbp), %r14
	movq	%r14, 48(%rsp)
	leaq	(%r14,%rbp), %rdi
	movq	%rdi, 16(%rsp)
	leaq	128(%rsp), %rsi
	movl	%ebx, %ecx
	movl	%r15d, %edx
	movq	%r12, %rdi
	call	smallints_to_fpr
	leaq	6272(%rsp), %rsi
	movl	%ebx, %ecx
	movl	%r15d, %edx
	movq	40(%rsp), %rdi
	call	smallints_to_fpr
	leaq	12416(%rsp), %rsi
	movl	%ebx, %ecx
	movl	%r15d, %edx
	movq	%r14, %rdi
	call	smallints_to_fpr
	leaq	18560(%rsp), %rsi
	movl	%ebx, %ecx
	movl	%r15d, %edx
	movq	24(%rsp), %rdi
	call	smallints_to_fpr
	testl	%ebx, %ebx
	je	.L159
	movl	$1, %edx
	movl	%r15d, %esi
	movq	%r12, %rdi
	call	falcon_FFT3@PLT
	movl	$1, %edx
	movl	%r15d, %esi
	movq	40(%rsp), %rdi
	call	falcon_FFT3@PLT
	movl	$1, %edx
	movl	%r15d, %esi
	movq	%r14, %rdi
	call	falcon_FFT3@PLT
	movl	$1, %edx
	movl	%r15d, %esi
	movq	24(%rsp), %rdi
	call	falcon_FFT3@PLT
	movl	$1, %edx
	movl	%r15d, %esi
	movq	%r12, %rdi
	call	falcon_poly_neg3@PLT
	movl	$1, %edx
	movl	%r15d, %esi
	movq	%r14, %rdi
	call	falcon_poly_neg3@PLT
	cmpl	$10, %r15d
	setne	%al
	cmpl	$18433, 56(%rsp)
	setne	%dl
	orb	%dl, %al
	jne	.L145
	cmpq	$1536, %r13
	jne	.L145
	movq	8(%rsp), %r15
	leaq	12288(%r15), %rbp
	leaq	24576(%r15), %r14
	leaq	36864(%r15), %rbx
	movl	$12288, %edx
	movq	40(%rsp), %r13
	movq	%r13, %rsi
	movq	%r15, %rdi
	call	memcpy@PLT
	movl	$1, %edx
	movl	$10, %esi
	movq	%r15, %rdi
	call	falcon_poly_mulselfadj_fft3@PLT
	movl	$12288, %edx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	$1, %edx
	movl	$10, %esi
	movq	%rbx, %rdi
	call	falcon_poly_mulselfadj_fft3@PLT
	movl	$1, %ecx
	movl	$10, %edx
	movq	%rbx, %rsi
	movq	%r15, %rdi
	call	falcon_poly_add3@PLT
	movl	$12288, %edx
	movq	24(%rsp), %rsi
	movq	%rbp, %rdi
	call	memcpy@PLT
	movl	$1, %ecx
	movl	$10, %edx
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	falcon_poly_muladj_fft3@PLT
	movl	$12288, %edx
	movq	48(%rsp), %r13
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	$1, %ecx
	movl	$10, %edx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_muladj_fft3@PLT
	movl	$1, %ecx
	movl	$10, %edx
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	falcon_poly_add3@PLT
	movl	$12288, %edx
	movq	24(%rsp), %rsi
	movq	%r14, %rdi
	call	memcpy@PLT
	movl	$1, %edx
	movl	$10, %esi
	movq	%r14, %rdi
	call	falcon_poly_mulselfadj_fft3@PLT
	movl	$12288, %edx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	$1, %edx
	movl	$10, %esi
	movq	%rbx, %rdi
	call	falcon_poly_mulselfadj_fft3@PLT
	movl	$1, %ecx
	movl	$10, %edx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	call	falcon_poly_add3@PLT
	movq	%r15, %rax
	leaq	40960(%r15), %r12
	leaq	45056(%r15), %r15
	leaq	49152(%rax), %r13
	movl	$10, %r8d
	movq	%rax, 8(%rsp)
	movq	%rax, %rcx
	movq	%r15, %rdx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_split_top_fft3@PLT
	movl	$0, %edx
	movl	$9, %esi
	movq	%r12, %rdi
	call	falcon_poly_adj_fft3@PLT
	movl	$0, %edx
	movl	$9, %esi
	movq	%r15, %rdi
	call	falcon_poly_adj_fft3@PLT
	movq	16(%rsp), %rax
	leaq	12288(%rax), %rdi
	movq	%rdi, 72(%rsp)
	subq	$8, %rsp
	.cfi_def_cfa_offset 24776
	movq	%r13, 32(%rsp)
	pushq	%r13
	.cfi_def_cfa_offset 24784
	pushq	$9
	.cfi_def_cfa_offset 24792
	pushq	%rbx
	.cfi_def_cfa_offset 24800
	movq	%r12, %r9
	movq	%r15, %r8
	movq	%rbx, %rcx
	movq	%r12, %rdx
	movq	%rbx, %rsi
	call	ffLDL_depth1_fft3
	movq	%rax, %r13
	addq	$24, %rsp
	.cfi_def_cfa_offset 24776
	pushq	$1
	.cfi_def_cfa_offset 24784
	movl	$10, %r9d
	movq	%r14, %r8
	movq	%rbp, %rcx
	movq	24(%rsp), %r14
	movq	%r14, %rdx
	movq	32(%rsp), %rsi
	movq	40(%rsp), %rdi
	call	LDL_dim2_fft3
	movl	$10, %r8d
	movq	40(%rsp), %rcx
	movq	%r15, %rdx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_split_top_fft3@PLT
	movl	$0, %edx
	movl	$9, %esi
	movq	%r12, %rdi
	call	falcon_poly_adj_fft3@PLT
	movl	$0, %edx
	movl	$9, %esi
	movq	%r15, %rdi
	call	falcon_poly_adj_fft3@PLT
	movq	32(%rsp), %rax
	leaq	12288(%rax,%r13,8), %rdi
	addq	$8, %rsp
	.cfi_def_cfa_offset 24776
	pushq	32(%rsp)
	.cfi_def_cfa_offset 24784
	pushq	$9
	.cfi_def_cfa_offset 24792
	pushq	%rbx
	.cfi_def_cfa_offset 24800
	movq	%r12, %r9
	movq	%r15, %r8
	movq	%rbx, %rcx
	movq	%r12, %rdx
	movq	%rbx, %rsi
	call	ffLDL_depth1_fft3
	addq	$32, %rsp
	.cfi_def_cfa_offset 24768
	leaq	128(%rsp), %rsi
	movl	$1, %ecx
	movl	$10, %edx
	movq	%r14, %rdi
	call	smallints_to_fpr
	leaq	6272(%rsp), %rsi
	movl	$1, %ecx
	movl	$10, %edx
	movq	%rbp, %rdi
	call	smallints_to_fpr
	movl	$1, %edx
	movl	$10, %esi
	movq	%r14, %rbx
	movq	%r14, %rdi
	call	falcon_FFT3@PLT
	movl	$1, %edx
	movl	$10, %esi
	movq	%rbp, %rdi
	call	falcon_FFT3@PLT
	movl	$1, %edx
	movl	$10, %esi
	movq	%r14, %rdi
	call	falcon_poly_mulselfadj_fft3@PLT
	movl	$1, %edx
	movl	$10, %esi
	movq	%rbp, %rdi
	call	falcon_poly_mulselfadj_fft3@PLT
	movl	$1, %ecx
	movl	$10, %edx
	movq	%rbp, %rsi
	movq	%r14, %rdi
	call	falcon_poly_add3@PLT
	leaq	6144(%r14), %r15
	movl	$0, %r12d
	movabsq	$4602678819172646911, %r14
	movabsq	$4607182418800017408, %r13
.L164:
	movq	(%rbx), %rbp
	movq	%rbp, %rdi
	call	ft_fpr_is_positive_finite
	movl	%eax, %edx
	cmpq	%r14, %rbp
	setg	%al
	movzbl	%al, %eax
	andl	%edx, %eax
	movl	%eax, %edx
	xorl	$1, %edx
	orl	%edx, %r12d
	movl	%eax, %eax
	leaq	-1(%rax), %rdx
	andq	%r13, %rdx
	negq	%rax
	andq	%rax, %rbp
	movq	%rdx, %rax
	orq	%rbp, %rax
	movq	%rax, (%rbx)
	addq	$8, %rbx
	cmpq	%r15, %rbx
	jne	.L164
	movl	%r12d, 120(%rsp)
	movq	8(%rsp), %rbx
	movq	%rax, 6136(%rbx)
	leaq	6144(%rbx), %r12
	movq	%r12, 24(%rsp)
	leaq	18432(%rbx), %rbp
	movl	$0, %esi
	movl	$3, %edi
	call	fpr_scaled@PLT
	movq	%rax, 40(%rsp)
	movq	%r12, 56(%rsp)
	leaq	8192(%rbx), %rax
	movq	%rax, 48(%rsp)
	leaq	120(%rsp), %r15
	movq	%rbp, 104(%rsp)
.L165:
	movq	(%rbx), %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, %r14
	movq	8(%rbx), %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, %rbp
	movq	16(%rbx), %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, %r13
	movq	%rbp, %rsi
	movq	%r14, %rdi
	call	fpr_add@PLT
	movq	%rax, %rdi
	movq	%r13, %rsi
	call	fpr_add@PLT
	movq	%rax, %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, 80(%rsp)
	movq	%rbp, %rsi
	movq	%r14, %rdi
	call	fpr_mul@PLT
	movq	%rax, %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, 88(%rsp)
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	fpr_mul@PLT
	movq	%rax, %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, %r14
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	fpr_mul@PLT
	movq	%rax, %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, 96(%rsp)
	movq	%r14, %rsi
	movq	88(%rsp), %rbp
	movq	%rbp, %rdi
	call	fpr_add@PLT
	movq	%rax, %rdi
	movq	96(%rsp), %rsi
	call	fpr_add@PLT
	movq	%rax, %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, %r14
	movq	%r13, %rsi
	movq	%rbp, %rdi
	call	fpr_mul@PLT
	movq	%rax, %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, %r13
	movq	40(%rsp), %rsi
	movq	80(%rsp), %rbp
	movq	%rbp, %rdi
	call	fpr_div@PLT
	movq	%rax, %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, (%r12)
	movq	%rbp, %rsi
	movq	%r14, %rdi
	call	fpr_div@PLT
	movq	%rax, %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, 2048(%r12)
	movq	%r13, %rsi
	movq	40(%rsp), %rdi
	call	fpr_mul@PLT
	movq	%rax, %rdi
	movq	%r14, %rsi
	call	fpr_div@PLT
	movq	%rax, %rdi
	movq	%r15, %rsi
	call	ft_stable_positive
	movq	%rax, 4096(%r12)
	addq	$24, %rbx
	addq	$8, %r12
	cmpq	%r12, 48(%rsp)
	jne	.L165
	movq	104(%rsp), %rbp
	leaq	120(%rsp), %rbx
	movq	%rbx, %rcx
	movq	%rbp, %rdx
	movl	$256, %esi
	movq	24(%rsp), %rdi
	call	ft_stable_binary_inplace
	movq	8(%rsp), %r13
	leaq	8192(%r13), %rdi
	movq	%rbx, %rcx
	movq	%rbp, %rdx
	movl	$256, %esi
	call	ft_stable_binary_inplace
	leaq	10240(%r13), %rdi
	movq	%rbx, %rcx
	movq	%rbp, %rdx
	movl	$256, %esi
	call	ft_stable_binary_inplace
	movl	$0, %esi
	movl	$339775489, %edi
	call	fpr_scaled@PLT
	movq	%rax, %rbx
	leaq	120(%rsp), %rbp
	movq	64(%rsp), %r12
.L166:
	movq	6144(%r13,%r12), %rsi
	movq	%rbx, %rdi
	call	fpr_div@PLT
	movq	%rax, %rdi
	movq	%rbp, %rsi
	call	ft_stable_positive
	movq	%rax, %rdx
	movq	%r12, %rax
	negq	%rax
	movq	%rdx, 18424(%r13,%rax)
	addq	$8, %r12
	cmpq	$6144, %r12
	jne	.L166
	movq	8(%rsp), %r14
	addq	$18432, %r14
	leaq	120(%rsp), %r13
	movabsq	$-4652218416473572215, %r12
	movabsq	$4689448209939135824, %rbp
	movq	56(%rsp), %r15
.L167:
	movq	(%r15), %rdi
	movq	%r13, %rsi
	call	ft_stable_positive
	movq	%rax, %rdx
	movq	%rax, (%r15)
	leaq	(%rax,%r12), %rax
	shrq	$63, %rax
	xorl	$1, %eax
	movq	%rbp, %rbx
	subq	%rdx, %rbx
	shrq	$63, %rbx
	xorl	$1, %ebx
	andl	%eax, %ebx
	xorl	$1, %ebx
	orl	120(%rsp), %ebx
	movl	%ebx, 120(%rsp)
	addq	$8, %r15
	cmpq	%r14, %r15
	jne	.L167
	movl	$0, %esi
	movl	$768, %edi
	call	fpr_scaled@PLT
	movq	%rax, %r12
	movq	$0, 120(%rsp)
	leaq	120(%rsp), %r13
	movq	%r13, %r8
	movq	24(%rsp), %r14
	movq	%r14, %rcx
	movl	$9, %edx
	movq	%rax, %rsi
	movq	72(%rsp), %rdi
	call	ffLDL_ternary_normalize_depth1
	leaq	1536(%rax), %rbp
	movq	16(%rsp), %rax
	leaq	(%rax,%rbp,8), %rdi
	movq	%r13, %r8
	movq	%r14, %rcx
	movl	$9, %edx
	movq	%r12, %rsi
	call	ffLDL_ternary_normalize_depth1
	movq	120(%rsp), %rdx
	testl	%ebx, %ebx
	jne	.L145
	cmpq	$1536, %rdx
	jne	.L145
	addq	%rax, %rbp
	cmpq	$18432, %rbp
	jne	.L145
	movl	$1, %eax
	jmp	.L144
.L159:
	movl	%r15d, %esi
	movq	%r12, %rdi
	call	falcon_FFT@PLT
	movl	%r15d, %esi
	movq	40(%rsp), %rdi
	call	falcon_FFT@PLT
	movl	%r15d, %esi
	movq	48(%rsp), %rbx
	movq	%rbx, %rdi
	call	falcon_FFT@PLT
	movl	%r15d, %esi
	movq	24(%rsp), %rdi
	call	falcon_FFT@PLT
	movl	%r15d, %esi
	movq	%r12, %rdi
	call	falcon_poly_neg@PLT
	movl	%r15d, %esi
	movq	%rbx, 48(%rsp)
	movq	%rbx, %rdi
	call	falcon_poly_neg@PLT
	movq	8(%rsp), %rax
	leaq	(%rax,%rbp), %r13
	leaq	0(%r13,%rbp), %r14
	movq	%r14, 32(%rsp)
	leaq	(%r14,%rbp), %rbx
	movq	%rbp, %rdx
	movq	40(%rsp), %rsi
	movq	%rax, %rdi
	call	memcpy@PLT
	movl	%r15d, %esi
	movq	8(%rsp), %rdi
	call	falcon_poly_mulselfadj_fft@PLT
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	%r15d, %esi
	movq	%rbx, %rdi
	call	falcon_poly_mulselfadj_fft@PLT
	movl	%r15d, %edx
	movq	%rbx, %rsi
	movq	8(%rsp), %rdi
	call	falcon_poly_add@PLT
	movq	%rbp, %rdx
	movq	40(%rsp), %rsi
	movq	%r13, %rdi
	call	memcpy@PLT
	movl	%r15d, %edx
	movq	24(%rsp), %rsi
	movq	%r13, %rdi
	call	falcon_poly_muladj_fft@PLT
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	%r15d, %edx
	movq	48(%rsp), %r12
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_muladj_fft@PLT
	movl	%r15d, %edx
	movq	%rbx, %rsi
	movq	%r13, %rdi
	call	falcon_poly_add@PLT
	movq	%rbp, %rdx
	movq	24(%rsp), %rsi
	movq	%r14, %rdi
	call	memcpy@PLT
	movl	%r15d, %esi
	movq	%r14, %rdi
	call	falcon_poly_mulselfadj_fft@PLT
	movq	%rbp, %rdx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	%r15d, %esi
	movq	%rbx, %rdi
	call	falcon_poly_mulselfadj_fft@PLT
	movl	%r15d, %edx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	call	falcon_poly_add@PLT
	testl	%r15d, %r15d
	jne	.L184
	movq	8(%rsp), %rax
	movq	(%rax), %rax
	movq	16(%rsp), %rbx
	movq	%rax, (%rbx)
.L169:
	movl	$0, %esi
	movl	$100, %edi
	call	fpr_scaled@PLT
	movq	%rax, %rbx
	movl	$0, %esi
	movl	$155, %edi
	call	fpr_scaled@PLT
	movq	%rax, %rdi
	movq	%rbx, %rsi
	call	fpr_div@PLT
	movq	%rax, %rbx
	movl	56(%rsp), %edi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, %rdi
	call	fpr_sqrt@PLT
	movq	%rax, %rdi
	movq	%rbx, %rsi
	call	fpr_mul@PLT
	movq	%rax, %rsi
	movl	%r15d, %edx
	movq	16(%rsp), %rdi
	call	ffLDL_binary_normalize
	movl	$1, %eax
	jmp	.L144
.L184:
	movl	$1, %eax
	movl	%r15d, %ecx
	salq	%cl, %rax
	movq	%rax, 24(%rsp)
	movl	$8, %r12d
	salq	%cl, %r12
	leaq	(%rbx,%r12), %r14
	movl	$16, %eax
	salq	%cl, %rax
	leaq	(%rbx,%rax), %rbp
	movq	%r12, %rdx
	movq	8(%rsp), %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	subq	$8, %rsp
	.cfi_def_cfa_offset 24776
	pushq	%rbp
	.cfi_def_cfa_offset 24784
	movl	%r15d, %r9d
	movq	48(%rsp), %r8
	movq	%r13, %rcx
	movq	24(%rsp), %rdx
	movq	32(%rsp), %rsi
	movq	%r14, %rdi
	call	LDL_fft
	movq	40(%rsp), %r13
	shrq	%r13
	salq	$3, %r13
	leaq	0(%rbp,%r13), %rsi
	movl	%r15d, %ecx
	movq	%rbx, %rdx
	movq	%rbp, %rdi
	call	falcon_poly_split_fft@PLT
	leaq	(%rbx,%r13), %rdx
	movq	%rdx, %r10
	movl	%r15d, %ecx
	movq	%r14, %rdx
	movq	%r10, 24(%rsp)
	movq	%r10, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_split_fft@PLT
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%r14, %rdi
	call	memcpy@PLT
	leal	-1(%r15), %r11d
	leaq	(%r14,%r13), %rdx
	movq	32(%rsp), %rdi
	addq	%r12, %rdi
	movq	%rbp, %r8
	movl	%r11d, %r12d
	movl	%r11d, %ecx
	movq	%r14, %rsi
	call	ffLDL_fft_inner
	movl	%r15d, %eax
	movl	%r12d, %ecx
	sall	%cl, %eax
	movq	40(%rsp), %r13
	addq	%r13, %rax
	movq	32(%rsp), %rdi
	leaq	(%rdi,%rax,8), %rdi
	movq	%rbp, %r8
	movl	%r12d, %ecx
	movq	24(%rsp), %rdx
	movq	%rbx, %rsi
	call	ffLDL_fft_inner
	addq	$16, %rsp
	.cfi_def_cfa_offset 24768
	jmp	.L169
	.cfi_endproc
.LFE85:
	.size	falcon_sign_set_private_key, .-falcon_sign_set_private_key
	.globl	falcon_sign_start_external_nonce
	.type	falcon_sign_start_external_nonce, @function
falcon_sign_start_external_nonce:
.LFB87:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movq	%rdx, %r12
	movl	$512, %esi
	call	shake_init@PLT
	movq	%r12, %rdx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	shake_inject@PLT
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE87:
	.size	falcon_sign_start_external_nonce, .-falcon_sign_start_external_nonce
	.globl	falcon_sign_start
	.type	falcon_sign_start, @function
falcon_sign_start:
.LFB86:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	call	rng_ready
	testl	%eax, %eax
	jne	.L190
.L187:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L190:
	.cfi_restore_state
	leaq	416(%rbx), %rdi
	movl	$40, %edx
	movq	%rbp, %rsi
	call	shake_extract@PLT
	movl	$40, %edx
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	falcon_sign_start_external_nonce
	movl	$1, %eax
	jmp	.L187
	.cfi_endproc
.LFE86:
	.size	falcon_sign_start, .-falcon_sign_start
	.globl	falcon_sign_update
	.type	falcon_sign_update, @function
falcon_sign_update:
.LFB88:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	shake_inject@PLT
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE88:
	.size	falcon_sign_update, .-falcon_sign_update
	.globl	falcon_sign_generate
	.type	falcon_sign_generate, @function
falcon_sign_generate:
.LFB89:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$27384, %rsp
	.cfi_def_cfa_offset 27440
	movq	%rdi, 24(%rsp)
	movl	$0, %eax
	cmpq	$0, 856(%rdi)
	je	.L193
	movq	%rsi, %r12
	movq	%rdx, %rbx
	movl	%ecx, %r13d
	movq	%rdi, %r15
	call	rng_ready
	testl	%eax, %eax
	je	.L208
	cmpq	$1, %rbx
	jbe	.L208
	movq	%r15, %rdi
	call	shake_flip@PLT
	movq	%r15, %rdi
	movl	844(%r15), %ecx
	leaq	21232(%rsp), %rdx
	movl	840(%r15), %esi
	call	falcon_hash_to_point@PLT
	movl	$16, 184(%rsp)
	movq	%r12, 168(%rsp)
	movq	%rbx, 176(%rsp)
	movl	%r13d, 188(%rsp)
	jmp	.L206
.L195:
	movq	24(%rsp), %rax
	leaq	416(%rax), %rsi
	leaq	192(%rsp), %rbx
	movl	$0, %edx
	movq	%rbx, %rdi
	call	falcon_prng_init@PLT
	movq	%rbx, 88(%rsp)
	leaq	sampler(%rip), %rax
	movq	%rax, 80(%rsp)
	jmp	.L196
.L199:
	movl	%ebp, %esi
	movq	%rbx, %rdi
	call	falcon_FFT@PLT
	movl	72(%rsp), %edi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, %rsi
	movabsq	$4607182418800017408, %rdi
	call	fpr_div@PLT
	movq	%rax, %r13
	movq	32(%rsp), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	memcpy@PLT
	movl	%ebp, %edx
	movq	48(%rsp), %rsi
	movq	%r12, %rdi
	call	falcon_poly_mul_fft@PLT
	movabsq	$-9223372036854775808, %rax
	xorq	%r13, %rax
	movq	%rax, %rsi
	movl	%ebp, %edx
	movq	%r12, %rdi
	call	falcon_poly_mulconst@PLT
	movl	%ebp, %edx
	movq	56(%rsp), %rsi
	movq	%rbx, %rdi
	call	falcon_poly_mul_fft@PLT
	movl	%ebp, %edx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_mulconst@PLT
	subq	$8, %rsp
	.cfi_def_cfa_offset 27448
	pushq	48(%rsp)
	.cfi_def_cfa_offset 27456
	pushq	%rbp
	.cfi_def_cfa_offset 27464
	pushq	%r12
	.cfi_def_cfa_offset 27472
	movq	%rbx, %r9
	movq	96(%rsp), %r8
	movq	48(%rsp), %r14
	movq	%r14, %rcx
	movq	40(%rsp), %rdx
	movq	120(%rsp), %rsi
	movq	112(%rsp), %rdi
	call	ffSampling_fft
	addq	$32, %rsp
	.cfi_def_cfa_offset 27440
	movq	32(%rsp), %r13
	movq	%r13, %rdx
	movq	8(%rsp), %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movq	%r13, %rdx
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	memcpy@PLT
	movl	%ebp, %edx
	movq	112(%rsp), %rsi
	movq	8(%rsp), %rdi
	call	falcon_poly_mul_fft@PLT
	movl	%ebp, %edx
	movq	120(%rsp), %rsi
	movq	%r14, %rdi
	call	falcon_poly_mul_fft@PLT
	movl	%ebp, %edx
	movq	%r14, %rsi
	movq	8(%rsp), %rdi
	call	falcon_poly_add@PLT
	movq	%r13, %rdx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	call	memcpy@PLT
	movl	%ebp, %edx
	movq	48(%rsp), %rsi
	movq	%r14, %rdi
	call	falcon_poly_mul_fft@PLT
	movq	%r13, %rdx
	movq	8(%rsp), %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	%ebp, %edx
	movq	56(%rsp), %rsi
	movq	%r12, %rdi
	call	falcon_poly_mul_fft@PLT
	movl	%ebp, %edx
	movq	%r14, %rsi
	movq	%r12, %rdi
	call	falcon_poly_add@PLT
	movl	%ebp, %esi
	movq	%rbx, %rdi
	call	falcon_iFFT@PLT
	movl	%ebp, %esi
	movq	%r12, %rdi
	call	falcon_iFFT@PLT
	testq	%r15, %r15
	je	.L200
	movl	$0, %esi
	movabsq	$4611686018427387904, %r13
	movl	$1085, %ebp
	movl	$1021, %r11d
	movl	$63, %r10d
.L202:
	movq	(%rbx,%rsi,8), %rdx
	movq	%rdx, %rcx
	salq	$10, %rcx
	movabsq	$4611686018427387903, %rax
	andq	%rax, %rcx
	orq	%r13, %rcx
	movq	%rdx, %rdi
	shrq	$52, %rdi
	andl	$2047, %edi
	movl	%ebp, %r14d
	subl	%edi, %r14d
	movl	%r11d, %r9d
	subl	%edi, %r9d
	movl	%r9d, %eax
	shrl	$31, %eax
	movl	%eax, %eax
	negq	%rax
	andq	%rcx, %rax
	movl	%r14d, %r8d
	andl	$63, %r8d
	movl	%r10d, %ecx
	subl	%r8d, %ecx
	movq	%rax, %rdi
	salq	$32, %rdi
	testb	$32, %cl
	cmove	%rax, %rdi
	andl	$31, %ecx
	salq	%cl, %rdi
	movq	%rdi, %r9
	shrq	$32, %r9
	andl	$536870911, %r9d
	orl	%edi, %r9d
	movq	%rax, %rcx
	shrq	$32, %rcx
	shrl	$5, %r8d
	movq	%rax, %r8
	cmovne	%rcx, %r8
	movl	%r14d, %ecx
	andl	$31, %ecx
	shrq	%cl, %r8
	movl	%r9d, %ecx
	negl	%ecx
	orl	%r9d, %ecx
	shrl	$31, %ecx
	shrq	$61, %rdi
	orl	%edi, %ecx
	movl	$200, %edi
	shrl	%cl, %edi
	movl	%edi, %eax
	andl	$1, %eax
	addq	%r8, %rax
	movq	%rdx, %rcx
	sarq	$63, %rcx
	xorq	%rcx, %rax
	shrq	$63, %rdx
	addq	%rdx, %rax
	movzwl	21232(%rsp,%rsi,2), %edx
	subl	%eax, %edx
	movw	%dx, 15088(%rsp,%rsi,2)
	movq	(%r12,%rsi,8), %rdx
	movq	%rdx, %rcx
	salq	$10, %rcx
	movabsq	$4611686018427387903, %rax
	andq	%rax, %rcx
	orq	%r13, %rcx
	movq	%rdx, %rdi
	shrq	$52, %rdi
	andl	$2047, %edi
	movl	%ebp, %r14d
	subl	%edi, %r14d
	movl	%r11d, %eax
	subl	%edi, %eax
	shrl	$31, %eax
	movl	%eax, %eax
	negq	%rax
	andq	%rcx, %rax
	movl	%r14d, %r8d
	andl	$63, %r8d
	movl	%r10d, %ecx
	subl	%r8d, %ecx
	movq	%rax, %rdi
	salq	$32, %rdi
	testb	$32, %cl
	cmove	%rax, %rdi
	andl	$31, %ecx
	salq	%cl, %rdi
	movq	%rdi, %r9
	shrq	$32, %r9
	andl	$536870911, %r9d
	orl	%edi, %r9d
	movq	%rax, %rcx
	shrq	$32, %rcx
	shrl	$5, %r8d
	cmovne	%rcx, %rax
	movq	%rax, %r8
	movl	%r14d, %ecx
	andl	$31, %ecx
	shrq	%cl, %r8
	movl	%r9d, %ecx
	negl	%ecx
	orl	%r9d, %ecx
	shrl	$31, %ecx
	shrq	$61, %rdi
	orl	%edi, %ecx
	movl	$200, %eax
	shrl	%cl, %eax
	andl	$1, %eax
	addq	%r8, %rax
	movq	%rdx, %rcx
	sarq	$63, %rcx
	xorq	%rcx, %rax
	shrq	$63, %rdx
	addq	%rdx, %rax
	negl	%eax
	movw	%ax, 8944(%rsp,%rsi,2)
	addq	$1, %rsi
	cmpq	%rsi, %r15
	jne	.L202
.L200:
	movq	24(%rsp), %rax
	movl	848(%rax), %ecx
	testl	%ecx, %ecx
	je	.L203
	cmpl	$0, 8928(%rsp)
	jne	.L204
.L203:
	movq	24(%rsp), %rax
	movl	844(%rax), %edx
	leaq	8944(%rsp), %rsi
	leaq	15088(%rsp), %rdi
	call	falcon_is_short@PLT
	testl	%eax, %eax
	jne	.L205
	subl	$1, 184(%rsp)
	je	.L204
.L206:
	movq	24(%rsp), %rax
	cmpl	$0, 848(%rax)
	je	.L195
	leaq	416(%rax), %rsi
	leaq	4560(%rsp), %rbx
	movl	$0, %edx
	movq	%rbx, %rdi
	call	falcon_prng_init@PLT
	movl	$0, 8928(%rsp)
	movq	%rbx, 88(%rsp)
	leaq	sampler_large(%rip), %rax
	movq	%rax, 80(%rsp)
.L196:
	movq	24(%rsp), %rax
	movq	872(%rax), %rbx
	movl	848(%rax), %edx
	movl	844(%rax), %ebp
	movq	856(%rax), %rsi
	movq	%rsi, 112(%rsp)
	movl	840(%rax), %eax
	movl	%eax, 72(%rsp)
	leal	1(%rdx,%rdx), %eax
	movl	%ebp, %ecx
	subl	%edx, %ecx
	salq	%cl, %rax
	movq	%rax, %r15
	leaq	0(,%rax,8), %rax
	movq	%rax, 32(%rsp)
	leaq	(%rbx,%rax), %r12
	leaq	(%r12,%rax), %rdi
	movq	%rdi, 8(%rsp)
	addq	%rax, %rdi
	movq	%rdi, 16(%rsp)
	addq	%rax, %rdi
	movq	%rdi, 40(%rsp)
	addq	%rax, %rsi
	movq	%rsi, 48(%rsp)
	addq	%rax, %rsi
	movq	%rsi, 120(%rsp)
	addq	%rax, %rsi
	movq	%rsi, 56(%rsp)
	addq	%rsi, %rax
	movq	%rax, 64(%rsp)
	testq	%r15, %r15
	je	.L197
	movl	$0, %r13d
	leaq	21232(%rsp), %r14
	movl	%edx, 96(%rsp)
.L198:
	movzwl	(%r14,%r13,2), %edi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, (%rbx,%r13,8)
	addq	$1, %r13
	cmpq	%r13, %r15
	jne	.L198
	movl	96(%rsp), %edx
.L197:
	testl	%edx, %edx
	je	.L199
	movl	$1, %edx
	movl	%ebp, %esi
	movq	%rbx, %rdi
	call	falcon_FFT3@PLT
	movl	72(%rsp), %edi
	movl	$0, %esi
	call	fpr_scaled@PLT
	movq	%rax, %rsi
	movabsq	$4607182418800017408, %rdi
	call	fpr_div@PLT
	movq	%rax, %r13
	movq	32(%rsp), %rdx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	memcpy@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	48(%rsp), %rsi
	movq	%r12, %rdi
	call	falcon_poly_mul_fft3@PLT
	movabsq	$-9223372036854775808, %rax
	xorq	%r13, %rax
	movq	%rax, %rsi
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	%r12, %rdi
	call	falcon_poly_mulconst3@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	56(%rsp), %rsi
	movq	%rbx, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	falcon_poly_mulconst3@PLT
	leal	-1(%rbp), %edi
	movl	$24, %eax
	movl	%edi, %ecx
	salq	%cl, %rax
	movq	64(%rsp), %r11
	movq	%rax, 96(%rsp)
	leaq	(%r11,%rax), %r10
	leal	1(%rbp), %eax
	leal	-2(%rbp), %ecx
	sall	%cl, %eax
	leal	(%rax,%rax,2), %eax
	movq	%r10, 136(%rsp)
	leaq	(%r10,%rax,8), %r14
	movq	%r14, 160(%rsp)
	movl	$8, %r13d
	movl	%edi, 132(%rsp)
	movzbl	132(%rsp), %ecx
	salq	%cl, %r13
	movq	40(%rsp), %rax
	leaq	(%rax,%r13), %rdi
	movq	%rdi, 72(%rsp)
	leaq	(%rdi,%r13), %r11
	movq	%r11, 104(%rsp)
	movq	16(%rsp), %rdi
	leaq	(%rdi,%r13), %r14
	leaq	(%r14,%r13), %r8
	movq	%r8, %rdx
	movl	%ebp, %r8d
	movq	%r12, %rcx
	movq	%rdx, 144(%rsp)
	movq	%r14, %rsi
	call	falcon_poly_split_top_fft3@PLT
	movq	40(%rsp), %rax
	movq	96(%rsp), %rcx
	leaq	(%rax,%rcx), %r8
	subq	$8, %rsp
	.cfi_def_cfa_offset 27448
	movq	%r8, 160(%rsp)
	pushq	%r8
	.cfi_def_cfa_offset 27456
	movl	148(%rsp), %r10d
	pushq	%r10
	.cfi_def_cfa_offset 27464
	pushq	168(%rsp)
	.cfi_def_cfa_offset 27472
	pushq	%r14
	.cfi_def_cfa_offset 27480
	pushq	56(%rsp)
	.cfi_def_cfa_offset 27488
	movq	208(%rsp), %r9
	movq	152(%rsp), %r8
	movq	120(%rsp), %rcx
	movq	%rax, %r14
	movq	%rax, %rdx
	movq	136(%rsp), %rsi
	movq	128(%rsp), %rdi
	call	ffSampling_depth1_fft3
	addq	$48, %rsp
	.cfi_def_cfa_offset 27440
	movl	%ebp, %r8d
	movq	104(%rsp), %rcx
	movq	72(%rsp), %rdx
	movq	%r14, %rsi
	movq	16(%rsp), %rdi
	call	falcon_poly_merge_top_fft3@PLT
	movq	96(%rsp), %rdx
	movq	16(%rsp), %rsi
	movq	%r14, %rdi
	call	memcpy@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	64(%rsp), %rsi
	movq	%r14, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	%rbx, %rsi
	movq	%r14, 40(%rsp)
	movq	%r14, %rdi
	call	falcon_poly_add3@PLT
	movq	8(%rsp), %rax
	leaq	(%rax,%r13), %r14
	addq	%r14, %r13
	movl	%ebp, %r8d
	movq	40(%rsp), %rcx
	movq	%r13, %rdx
	movq	%r14, %rsi
	movq	%rax, %rdi
	call	falcon_poly_split_top_fft3@PLT
	subq	$8, %rsp
	.cfi_def_cfa_offset 27448
	pushq	160(%rsp)
	.cfi_def_cfa_offset 27456
	movl	148(%rsp), %r10d
	pushq	%r10
	.cfi_def_cfa_offset 27464
	pushq	%r13
	.cfi_def_cfa_offset 27472
	pushq	%r14
	.cfi_def_cfa_offset 27480
	movq	48(%rsp), %r13
	pushq	%r13
	.cfi_def_cfa_offset 27488
	movq	184(%rsp), %r9
	movq	152(%rsp), %r8
	movq	120(%rsp), %rcx
	movq	88(%rsp), %r14
	movq	%r14, %rdx
	movq	136(%rsp), %rsi
	movq	128(%rsp), %rdi
	call	ffSampling_depth1_fft3
	addq	$48, %rsp
	.cfi_def_cfa_offset 27440
	movl	%ebp, %r8d
	movq	104(%rsp), %rcx
	movq	72(%rsp), %rdx
	movq	%r14, %rsi
	movq	%r13, 8(%rsp)
	movq	%r13, %rdi
	call	falcon_poly_merge_top_fft3@PLT
	movq	96(%rsp), %rdx
	movq	16(%rsp), %r13
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	memcpy@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	64(%rsp), %rsi
	movq	%r14, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	%r14, %rsi
	movq	8(%rsp), %r14
	movq	%r14, %rdi
	call	falcon_poly_sub3@PLT
	movq	32(%rsp), %rdx
	movq	%r14, %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movq	32(%rsp), %rdx
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	memcpy@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	112(%rsp), %rsi
	movq	%r14, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	120(%rsp), %rsi
	movq	%r13, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	%r13, %rsi
	movq	%r14, 8(%rsp)
	movq	%r14, %rdi
	call	falcon_poly_add3@PLT
	movq	32(%rsp), %rdx
	movq	%rbx, %rsi
	movq	%r13, %rdi
	call	memcpy@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	48(%rsp), %rsi
	movq	%r13, %rdi
	call	falcon_poly_mul_fft3@PLT
	movq	32(%rsp), %rdx
	movq	8(%rsp), %rsi
	movq	%rbx, %rdi
	call	memcpy@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	56(%rsp), %rsi
	movq	%r12, %rdi
	call	falcon_poly_mul_fft3@PLT
	movl	$1, %ecx
	movl	%ebp, %edx
	movq	%r13, %rsi
	movq	%r12, %rdi
	call	falcon_poly_add3@PLT
	movl	$1, %edx
	movl	%ebp, %esi
	movq	%rbx, %rdi
	call	falcon_iFFT3@PLT
	movl	$1, %edx
	movl	%ebp, %esi
	movq	%r12, %rdi
	call	falcon_iFFT3@PLT
	testq	%r15, %r15
	je	.L200
	movl	$0, %esi
	movabsq	$4611686018427387904, %r13
	movl	$1085, %ebp
	movl	$1021, %r11d
	movl	$63, %r10d
.L201:
	movq	(%rbx,%rsi,8), %rdx
	movq	%rdx, %rcx
	salq	$10, %rcx
	movabsq	$4611686018427387903, %rax
	andq	%rax, %rcx
	orq	%r13, %rcx
	movq	%rdx, %rdi
	shrq	$52, %rdi
	andl	$2047, %edi
	movl	%ebp, %r14d
	subl	%edi, %r14d
	movl	%r11d, %r9d
	subl	%edi, %r9d
	movl	%r9d, %eax
	shrl	$31, %eax
	movl	%eax, %eax
	negq	%rax
	andq	%rcx, %rax
	movl	%r14d, %r8d
	andl	$63, %r8d
	movl	%r10d, %ecx
	subl	%r8d, %ecx
	movq	%rax, %rdi
	salq	$32, %rdi
	testb	$32, %cl
	cmove	%rax, %rdi
	andl	$31, %ecx
	salq	%cl, %rdi
	movq	%rdi, %r9
	shrq	$32, %r9
	andl	$536870911, %r9d
	orl	%edi, %r9d
	movq	%rax, %rcx
	shrq	$32, %rcx
	shrl	$5, %r8d
	movq	%rax, %r8
	cmovne	%rcx, %r8
	movl	%r14d, %ecx
	andl	$31, %ecx
	shrq	%cl, %r8
	movl	%r9d, %ecx
	negl	%ecx
	orl	%r9d, %ecx
	shrl	$31, %ecx
	shrq	$61, %rdi
	orl	%edi, %ecx
	movl	$200, %edi
	shrl	%cl, %edi
	movl	%edi, %eax
	andl	$1, %eax
	addq	%r8, %rax
	movq	%rdx, %rcx
	sarq	$63, %rcx
	xorq	%rcx, %rax
	shrq	$63, %rdx
	addq	%rdx, %rax
	movw	%ax, 15088(%rsp,%rsi,2)
	movq	(%r12,%rsi,8), %rdx
	movq	%rdx, %rcx
	salq	$10, %rcx
	movabsq	$4611686018427387903, %rax
	andq	%rax, %rcx
	orq	%r13, %rcx
	movq	%rdx, %rdi
	shrq	$52, %rdi
	andl	$2047, %edi
	movl	%ebp, %r14d
	subl	%edi, %r14d
	movl	%r11d, %eax
	subl	%edi, %eax
	shrl	$31, %eax
	movl	%eax, %eax
	negq	%rax
	andq	%rcx, %rax
	movl	%r14d, %r8d
	andl	$63, %r8d
	movl	%r10d, %ecx
	subl	%r8d, %ecx
	movq	%rax, %rdi
	salq	$32, %rdi
	testb	$32, %cl
	cmove	%rax, %rdi
	andl	$31, %ecx
	salq	%cl, %rdi
	movq	%rdi, %r9
	shrq	$32, %r9
	andl	$536870911, %r9d
	orl	%edi, %r9d
	movq	%rax, %rcx
	shrq	$32, %rcx
	shrl	$5, %r8d
	cmovne	%rcx, %rax
	movq	%rax, %r8
	movl	%r14d, %ecx
	andl	$31, %ecx
	shrq	%cl, %r8
	movl	%r9d, %ecx
	negl	%ecx
	orl	%r9d, %ecx
	shrl	$31, %ecx
	shrq	$61, %rdi
	orl	%edi, %ecx
	movl	$200, %eax
	shrl	%cl, %eax
	andl	$1, %eax
	addq	%r8, %rax
	movq	%rdx, %rcx
	sarq	$63, %rcx
	xorq	%rcx, %rax
	shrq	$63, %rdx
	addq	%rdx, %rax
	movw	%ax, 8944(%rsp,%rsi,2)
	addq	$1, %rsi
	cmpq	%rsi, %r15
	jne	.L201
	jmp	.L200
.L204:
	movl	$0, %eax
	jmp	.L193
.L205:
	movq	168(%rsp), %r12
	movq	176(%rsp), %rbx
	movl	188(%rsp), %r13d
	movq	24(%rsp), %rax
	movl	840(%rax), %ecx
	leaq	-1(%rbx), %rsi
	leaq	1(%r12), %rdi
	movq	%rax, %rbx
	movl	844(%rax), %r9d
	leaq	8944(%rsp), %r8
	movl	%r13d, %edx
	call	falcon_encode_small@PLT
	testq	%rax, %rax
	je	.L193
	movl	%r13d, %edx
	sall	$5, %edx
	orb	844(%rbx), %dl
	movl	848(%rbx), %ecx
	sall	$7, %ecx
	orl	%ecx, %edx
	movb	%dl, (%r12)
	addq	$1, %rax
	jmp	.L193
.L208:
	movl	$0, %eax
.L193:
	addq	$27384, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE89:
	.size	falcon_sign_generate, .-falcon_sign_generate
	.section	.rodata
	.align 32
	.type	CDF0, @object
	.size	CDF0, 352
CDF0:
	.quad	4031913084411455523
	.quad	-7527879395188308033
	.quad	596125951946700678
	.quad	5229758529120913067
	.quad	69230930161336360
	.quad	-4818650938196620221
	.quad	6302293744552402
	.quad	7352830732370919967
	.quad	449018771521685
	.quad	-8681764675673989188
	.quad	25008954620675
	.quad	-7080206969534889451
	.quad	1087957639417
	.quad	2775583653356073882
	.quad	36942382845
	.quad	-2433995223356097912
	.quad	978618449
	.quad	2690982465095676317
	.quad	20216591
	.quad	2875354667081992134
	.quad	325595
	.quad	3253399177098153241
	.quad	4087
	.quad	3145154105398596933
	.quad	39
	.quad	-332240649642460458
	.quad	0
	.quad	5621630163842613476
	.quad	0
	.quad	33383367111730198
	.quad	0
	.quad	154437016759436
	.quad	0
	.quad	556541887369
	.quad	0
	.quad	1562239343
	.quad	0
	.quad	3415730
	.quad	0
	.quad	5817
	.quad	0
	.quad	8
	.quad	0
	.quad	0
	.align 32
	.type	CDFs, @object
	.size	CDFs, 96
CDFs:
	.quad	-2678677258295294960
	.quad	2878715985279770247
	.quad	-5268329278199080015
	.quad	2650718273802340096
	.quad	1313815201007480117
	.quad	632549813042453946
	.quad	7906626931797828486
	.quad	889294877069012273
	.quad	-1743811193595018592
	.quad	-8289815805723892678
	.quad	3033535791909276021
	.quad	-9140852352074434853
	.type	CDF8, @object
	.size	CDF8, 6
CDF8:
	.ascii	"\252_,\020\004\001"
	.align 32
	.type	ft_adaptive_cdf, @object
	.size	ft_adaptive_cdf, 40960
ft_adaptive_cdf:
	.quad	-5585698290684357278
	.quad	-6193897119312153348
	.quad	7806896963754487748
	.quad	-8317722741716630942
	.quad	4062691428401757708
	.quad	-3437639928603628679
	.quad	1791715974944572614
	.quad	1131232196543415969
	.quad	663982939486702418
	.quad	-8285790777146060000
	.quad	205480902982363162
	.quad	-5517281544107996776
	.quad	52858833213387332
	.quad	-1822450547494009265
	.quad	11264466882686183
	.quad	6402942527299198922
	.quad	1983509262044379
	.quad	528584377842064364
	.quad	288031217321451
	.quad	3323640802786710131
	.quad	34440907249949
	.quad	-3555626841984392335
	.quad	3387143639027
	.quad	-7985803893748539492
	.quad	273729206155
	.quad	4154952407859878138
	.quad	18164586717
	.quad	5025769011716514427
	.quad	989235429
	.quad	-3582114696005657143
	.quad	44192296
	.quad	6814955709367163543
	.quad	1618856
	.quad	-357456540155438412
	.quad	48613
	.quad	-5740664554846614195
	.quad	1196
	.quad	8301927825880451400
	.quad	24
	.quad	2373930578663425549
	.quad	0
	.quad	7354088428325324242
	.quad	0
	.quad	99537325746473300
	.quad	0
	.quad	1103521004104849
	.quad	0
	.quad	10020207975859
	.quad	0
	.quad	74515224141
	.quad	0
	.quad	453796867
	.quad	0
	.quad	2263115
	.quad	0
	.quad	9242
	.quad	0
	.quad	31
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	-3021584048173866706
	.quad	-3437620866184418872
	.quad	-5968564920384533938
	.quad	7431689668279310431
	.quad	-8702607228912817960
	.quad	6099097060328714098
	.quad	7331352975985286279
	.quad	7638439653485460598
	.quad	5305924617712826635
	.quad	-889318498466832234
	.quad	3688587223697089370
	.quad	-1646849234906729837
	.quad	2460102825353418410
	.quad	-5755355846917830632
	.quad	1572489244027592596
	.quad	-8075770444159268897
	.quad	962441945873093836
	.quad	-3002641423866388249
	.quad	563611454839583318
	.quad	8582801130833214415
	.quad	315584732403236953
	.quad	-7761174997841171604
	.quad	168863194239697174
	.quad	-6423420274480875074
	.quad	86302270356227783
	.quad	892129302104811908
	.quad	42110592298514338
	.quad	-7836441871990363367
	.quad	19610115678007791
	.quad	-1712604671653688321
	.quad	8712582037490748
	.quad	6211560136626546902
	.quad	3692047085741121
	.quad	-3320604604358149619
	.quad	1491872988991110
	.quad	1193648627099954367
	.quad	574703971375562
	.quad	4775509138714396746
	.quad	211017639288851
	.quad	-436518533274796215
	.quad	73837935730313
	.quad	-2581783632371449848
	.quad	24618342968074
	.quad	2708690906234567796
	.quad	7819806441492
	.quad	-5557563418345642488
	.quad	2366120110128
	.quad	-6090517952134336876
	.quad	681918261738
	.quad	6094648388007837006
	.quad	187170999874
	.quad	-8466228933936206472
	.quad	48923293467
	.quad	963726982674711791
	.quad	12176644016
	.quad	-5818745751285003178
	.quad	2885636022
	.quad	8760224084796948804
	.quad	651069968
	.quad	2418427164677120435
	.quad	139848790
	.quad	-5167565152387749712
	.quad	28596297
	.quad	-3694079897592471855
	.quad	5566191
	.quad	-9026512576944058012
	.quad	1031294
	.quad	-5512624832795781355
	.quad	181871
	.quad	8035988793249604396
	.quad	30527
	.quad	1847732285243861385
	.quad	4876
	.quad	-4793777970870330784
	.quad	741
	.quad	8292042617070591979
	.quad	107
	.quad	5204881337291465740
	.quad	14
	.quad	-4196371452666637164
	.quad	1
	.quad	-1185114781871158876
	.quad	0
	.quad	4452704326664921662
	.quad	0
	.quad	528354183233036624
	.quad	0
	.quad	59657397085039772
	.quad	0
	.quad	6409620579345062
	.quad	0
	.quad	655270824330326
	.quad	0
	.quad	63741459459463
	.quad	0
	.quad	5899680904883
	.quad	0
	.quad	519557417592
	.quad	0
	.quad	43534211222
	.quad	0
	.quad	3470674742
	.quad	0
	.quad	263255608
	.quad	0
	.quad	18998379
	.quad	0
	.quad	1304445
	.quad	0
	.quad	85212
	.quad	0
	.quad	5296
	.quad	0
	.quad	313
	.quad	0
	.quad	18
	.quad	0
	.quad	1
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	-1575300746997383485
	.quad	-6266288932903280668
	.quad	-3140786567919626486
	.quad	5640603969068712604
	.quad	-4677193000891811308
	.quad	808824660875537233
	.quad	-6166329177391704345
	.quad	-6626527798802822695
	.quad	-7591720237934935204
	.quad	6643822227615715586
	.quad	-8939146370983039390
	.quad	3954371237875415309
	.quad	8249694506825339503
	.quad	5139244116674995860
	.quad	7089954086467265050
	.quad	-5087988973786644242
	.quad	6033998417220001997
	.quad	-300488726555208904
	.quad	5084483269485260468
	.quad	-3664838185104835458
	.quad	4241285541300408586
	.quad	2319215863189622710
	.quad	3501802400706431213
	.quad	2535803808687359933
	.quad	2861332912010593433
	.quad	-2960359238236483510
	.quad	2313510327571634514
	.quad	3449598710846216162
	.quad	1850753602815739783
	.quad	1279788645692094637
	.quad	1464709552282681241
	.quad	4631908547858267796
	.quad	1146661816669529927
	.quad	-1730109603510832047
	.quad	887888750944425467
	.quad	6682461457288373454
	.quad	679958751171581064
	.quad	8286180834781903350
	.quad	514957759583783055
	.quad	-2589399817937545327
	.quad	385649199934276106
	.quad	7493303825524552426
	.quad	285571039653290305
	.quad	2619219310023198758
	.quad	209077867534078181
	.quad	-7855307239881465581
	.quad	151337791936735470
	.quad	3799774517928043585
	.quad	108294711554766332
	.quad	-7431132240318100457
	.quad	76606286197995909
	.quad	-6533217924509661242
	.quad	53566985504885385
	.quad	-5630993958465710908
	.quad	37024176875176693
	.quad	-4442712210561215252
	.quad	25293569000971513
	.quad	8343482415093642660
	.quad	17078653352024472
	.quad	654072693283661313
	.quad	11397231749765667
	.quad	9048440913506541350
	.quad	7516780363614337
	.quad	-855388626248690456
	.quad	4899327950004504
	.quad	5475473609801618395
	.quad	3155728748357890
	.quad	-2964885520723732447
	.quad	2008669509602222
	.quad	4544799471672693723
	.quad	1263429175484580
	.quad	-2952583897680767006
	.quad	785263744526000
	.quad	8745159226220012927
	.quad	482271635458820
	.quad	-6878271846327857912
	.quad	292664018568209
	.quad	4390947671336579390
	.quad	175484540208930
	.quad	4708029167400035434
	.quad	103965996940459
	.quad	3050179058884905135
	.quad	60858075924886
	.quad	9160112435413466504
	.quad	35197475389176
	.quad	8455939218226418562
	.quad	20112386540125
	.quad	9027250889036438903
	.quad	11354481177612
	.quad	3283705957058491652
	.quad	6333091304746
	.quad	-4304572092478174112
	.quad	3489815719915
	.quad	-1882430833817862022
	.quad	1899859052779
	.quad	1834311012578470355
	.quad	1021801587699
	.quad	-4193207676869284521
	.quad	542915842366
	.quad	-862301868379716053
	.quad	284979700673
	.quad	6263127660289298833
	.quad	147776637487
	.quad	-8865988902183020904
	.quad	75701291674
	.quad	-4080734992475361649
	.quad	38309094854
	.quad	-215931423543231587
	.quad	19151254660
	.quad	-7301747163149094422
	.quad	9457691810
	.quad	-1490304345488366699
	.quad	4613831239
	.quad	-5917650993525638882
	.quad	2223428071
	.quad	3131246559802990542
	.quad	1058438609
	.quad	3418716178553875155
	.quad	497721049
	.quad	5307841303745579646
	.quad	231196243
	.quad	2837946150732794247
	.quad	106083244
	.quad	3981900449803623443
	.quad	48081834
	.quad	4135761907339548123
	.quad	21526853
	.quad	-5529870933850777929
	.quad	9520123
	.quad	-4320308950968331924
	.quad	4158765
	.quad	-6224131796908245198
	.quad	1794500
	.quad	6594273466572622439
	.quad	764852
	.quad	436677670987471458
	.quad	322005
	.quad	-3808158743101521373
	.quad	133906
	.quad	136597609063833792
	.quad	55002
	.quad	-4738606865119869808
	.quad	22315
	.quad	-1816683616474129590
	.quad	8943
	.quad	1920481891807669858
	.quad	3540
	.quad	102069696834344077
	.quad	1384
	.quad	1376859271941524374
	.quad	534
	.quad	-9099221086047892898
	.quad	203
	.quad	-2139461844393650208
	.quad	76
	.quad	-3406737536386257717
	.quad	28
	.quad	-7646503188917367226
	.quad	10
	.quad	-9096070468560869236
	.quad	3
	.quad	-3422509283480805721
	.quad	1
	.quad	6784629327128576243
	.quad	0
	.quad	8936252034079364217
	.quad	0
	.quad	3126047579509823670
	.quad	0
	.quad	1080090355131528408
	.quad	0
	.quad	368593470205377657
	.quad	0
	.quad	124238725951138998
	.quad	0
	.quad	41360610552049655
	.quad	0
	.quad	13599919216633939
	.quad	0
	.quad	4416762271296861
	.quad	0
	.quad	1416736019160214
	.quad	0
	.quad	448838398091787
	.quad	0
	.quad	140444974147441
	.quad	0
	.quad	43404677817068
	.quad	0
	.quad	13248906701002
	.quad	0
	.quad	3994254938825
	.quad	0
	.quad	1189331291711
	.quad	0
	.quad	349768225440
	.quad	0
	.quad	101593857086
	.quad	0
	.quad	29144949006
	.quad	0
	.quad	8257852060
	.quad	0
	.quad	2310883540
	.quad	0
	.quad	638697799
	.quad	0
	.quad	174348589
	.quad	0
	.quad	47005253
	.quad	0
	.quad	12516375
	.quad	0
	.quad	3291655
	.quad	0
	.quad	854974
	.quad	0
	.quad	219328
	.quad	0
	.quad	55569
	.quad	0
	.quad	13905
	.quad	0
	.quad	3437
	.quad	0
	.quad	839
	.quad	0
	.quad	202
	.quad	0
	.quad	48
	.quad	0
	.quad	11
	.quad	0
	.quad	3
	.quad	0
	.quad	1
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	-804832999609108281
	.quad	-8104847884548173620
	.quad	-1608409429606985835
	.quad	7535171075961544893
	.quad	-2408227909665428221
	.quad	4288111913028101275
	.quad	-3201822152931457615
	.quad	6928789251525602430
	.quad	-3986783754977716112
	.quad	7253020379803916392
	.quad	-4760784086563698474
	.quad	676099967218907246
	.quad	-5521594959054726427
	.quad	2092757125138988827
	.quad	-6267107757752409679
	.quad	6161014783674436141
	.quad	-6995350771068851672
	.quad	8982267094805765028
	.quad	-7704504481531965562
	.quad	8590996572297028133
	.quad	-8392914627010432954
	.quad	-649157239272938173
	.quad	-9059102886162127581
	.quad	-5573394652359729343
	.quad	8744968983966791718
	.quad	992346722856316236
	.quad	8126917165870249065
	.quad	253120757395280289
	.quad	7534397062604997742
	.quad	-1560639662534717333
	.quad	6968126323206809970
	.quad	8403993841030165546
	.quad	6428630629857830852
	.quad	-8308721303238452119
	.quad	5916247676111460903
	.quad	7341914687190478027
	.quad	5431133245751258116
	.quad	2880001640994933977
	.quad	4973269197579876640
	.quad	-2760706989007327951
	.quad	4542473136489881442
	.quad	-7375406698911923143
	.quad	4138409532173793310
	.quad	-5750027795650925396
	.quad	3760602033930028881
	.quad	3780888646077716732
	.quad	3408446723184898219
	.quad	-6631011392563294232
	.quad	3081226044385817344
	.quad	7215963122669730879
	.quad	2778123159487038519
	.quad	2858704600948609450
	.quad	2498236480877881711
	.quad	-7746481377145899256
	.quad	2240594151720182865
	.quad	310026182652092118
	.quad	2004168260610520448
	.quad	1713152583111850015
	.quad	1787888598551759090
	.quad	-632774723178949551
	.quad	1590655789664956890
	.quad	2823466936251217360
	.quad	1411353652148026974
	.quad	-5069482049475539173
	.quad	1248860671959754169
	.quad	-2354874804127942090
	.quad	1102060497882026277
	.quad	-6482256308934316373
	.quad	969851392349286581
	.quad	2767272119963007294
	.quad	851154597160954631
	.quad	9064610581836295777
	.quad	744921596418158992
	.quad	-3472353441403631992
	.quad	650140280345515946
	.quad	-9203560539529608035
	.quad	565840032757107175
	.quad	618396950109475226
	.quad	491095781579126120
	.quad	-8660476047738388583
	.quad	425031065913744136
	.quad	-952098800832438134
	.quad	366820184566246716
	.quad	-4746930745110696453
	.quad	315689499782510811
	.quad	3553957000497427266
	.quad	270917976245019886
	.quad	-7888480031130696682
	.quad	231837039297794812
	.quad	2392325534005611644
	.quad	197829838104406179
	.quad	-9022434679840580785
	.quad	168329999213805313
	.quad	6115487293663830463
	.quad	142819954065106728
	.quad	8996280684997188009
	.quad	120828920567365536
	.quad	2711597205929474674
	.quad	101930614310796361
	.quad	-384631480627560710
	.quad	85740759464735511
	.quad	-8975003243308209468
	.quad	71914463246809399
	.quad	-3975995133135285851
	.quad	60143511242199483
	.quad	189571979140531794
	.quad	50153634025189938
	.quad	4672088886844510272
	.quad	41701788676430001
	.quad	-318742201852790971
	.quad	34573492061157342
	.quad	687743295752624304
	.quad	28580236271346901
	.quad	-7810216993874338378
	.quad	23557010546582040
	.quad	3354408103921960753
	.quad	19359948356470075
	.quad	-1993431997378292359
	.quad	15864113209252943
	.quad	2706727913098858531
	.quad	12961432182213771
	.quad	4590105828113170008
	.quad	10558782165110776
	.quad	240141886391857420
	.quad	8576230366727934
	.quad	4064591324444260618
	.quad	6945427741085087
	.quad	9117914249594935128
	.quad	5608151616894179
	.quad	-5085069932547434577
	.quad	4514991925798225
	.quad	5283111291958784277
	.quad	3624173979922128
	.quad	4998701690002624519
	.quad	2900509701519952
	.quad	-4052873579215583908
	.quad	2314468509311593
	.quad	-3303042617582001718
	.quad	1841358669514457
	.quad	-7630569161710574895
	.quad	1460609777799121
	.quad	2225063088041568192
	.quad	1155147106895564
	.quad	846911659099438809
	.quad	910848791896786
	.quad	-7376285211236528797
	.quad	716077193659101
	.quad	8804738818282811598
	.quad	561276246307786
	.quad	-1438023316805414018
	.quad	438627128124641
	.quad	6619620235305833875
	.quad	341755170600546
	.quad	-8685403208072480643
	.quad	265481516813836
	.quad	2439057546253820645
	.quad	205613640003462
	.quad	7129286363170169269
	.quad	158769422234684
	.quad	1877200100723405000
	.quad	122230060581900
	.quad	-7228476814114951383
	.quad	93817606274881
	.quad	4630016512270352798
	.quad	71793445209760
	.quad	3834012012296484462
	.quad	54774492625225
	.quad	-6878193912314221886
	.quad	41664298816017
	.quad	2598307703133434935
	.quad	31596646118731
	.quad	4390327493364000707
	.quad	23889560769541
	.quad	4330591657821355769
	.quad	18007968137780
	.quad	1546995525409178906
	.quad	13533488419136
	.quad	4500807734978744454
	.quad	10140104665506
	.quad	7016636355820291482
	.quad	7574638813167
	.quad	-1618132732571747285
	.quad	5641147032628
	.quad	-6158768474305389277
	.quad	4188496151826
	.quad	906025866711955763
	.quad	3100510913118
	.quad	7110811217446997227
	.quad	2288190093681
	.quad	-6386056558042638931
	.quad	1683580554460
	.quad	-2807981726666753084
	.quad	1234974391608
	.quad	8859498032441229577
	.quad	903157641190
	.quad	-6377343062184193030
	.quad	658491312160
	.quad	-8601966926706690183
	.quad	478648561800
	.quad	-6281757930152240342
	.quad	346867047050
	.quad	3389442258503196811
	.quad	250604159583
	.quad	-4181447077785891913
	.quad	180506082686
	.quad	8673557998878562106
	.quad	129620335927
	.quad	-8253217613592989326
	.quad	92796499667
	.quad	2646957671988141103
	.quad	66231810474
	.quad	5902926610326712040
	.quad	47127855889
	.quad	4830889632550436722
	.quad	33432142946
	.quad	-4772015163737427581
	.quad	23644258303
	.quad	-5193544954686373292
	.quad	16670998124
	.quad	4357070803336442944
	.quad	11718483958
	.quad	4398768440241907218
	.quad	8212108538
	.quad	-7609908432951127487
	.quad	5737343741
	.quad	-6233463484383386607
	.quad	3996129238
	.quad	-5756036994344689096
	.quad	2774854281
	.quad	8764506444258101413
	.quad	1920933746
	.quad	-7065475489726029159
	.quad	1325731868
	.quad	-9106214308216853168
	.quad	912157173
	.quad	-8503073107938503634
	.quad	625682354
	.quad	-297153418050595966
	.quad	427866190
	.quad	2882213804920418337
	.quad	291696662
	.quad	2714804760131381581
	.quad	198254922
	.quad	5369594252493235641
	.quad	134333750
	.quad	2737163164571410405
	.quad	90743298
	.quad	7720628985159948
	.quad	61109941
	.quad	7420085667817029067
	.quad	41027655
	.quad	5206084983417326955
	.quad	27460516
	.quad	190056397188214299
	.quad	18323460
	.quad	-2416065555609359649
	.quad	12189132
	.quad	4462428889213553009
	.quad	8083588
	.quad	-5161467093323211127
	.quad	5344430
	.quad	-8447737615643228713
	.quad	3522606
	.quad	-6495716100618920308
	.quad	2314685
	.quad	-5134687078295116835
	.quad	1516298
	.quad	-4775690273556226552
	.quad	990243
	.quad	-6211055825118088635
	.quad	644708
	.quad	-2879921535099902969
	.quad	418455
	.quad	6903343482226220699
	.quad	270768
	.quad	-6771741135925553179
	.quad	174667
	.quad	690697186919888851
	.quad	112327
	.quad	-6421520537110091844
	.quad	72015
	.quad	7023178291621539998
	.quad	46028
	.quad	8458932702488427837
	.quad	29328
	.quad	-9124781085735297359
	.quad	18630
	.quad	2097130244581090578
	.quad	11797
	.quad	-2750187008116132568
	.quad	7448
	.quad	3863772101954001486
	.quad	4687
	.quad	-5058914274881708062
	.quad	2941
	.quad	4820630559784600515
	.quad	1839
	.quad	-4057942952484229196
	.quad	1147
	.quad	4648582368713951495
	.quad	713
	.quad	3714538655551607253
	.quad	442
	.quad	64507155256642058
	.quad	273
	.quad	1583974037076538693
	.quad	168
	.quad	3735947909229182857
	.quad	103
	.quad	5205155599879252169
	.quad	63
	.quad	4120248968739402103
	.quad	38
	.quad	-7703875186078697953
	.quad	23
	.quad	8715978998089320516
	.quad	14
	.quad	4353635674362204931
	.quad	8
	.quad	-7240736880640052352
	.quad	5
	.quad	3472842487682484676
	.quad	3
	.quad	2170109832489425343
	.quad	1
	.quad	-2441983069172075278
	.quad	1
	.quad	2127708473598745114
	.quad	0
	.quad	-6197591589643535114
	.quad	0
	.quad	7270115085712485297
	.quad	0
	.quad	4301637930841198179
	.quad	0
	.quad	2537368686383943501
	.quad	0
	.quad	1492073752634354031
	.quad	0
	.quad	874689344402943664
	.quad	0
	.quad	511180234666832065
	.quad	0
	.quad	297817892396848909
	.quad	0
	.quad	172975215744971419
	.quad	0
	.quad	100155127262463852
	.quad	0
	.quad	57812074771859215
	.quad	0
	.quad	33267475089646622
	.quad	0
	.quad	19084329095910657
	.quad	0
	.quad	10914141600757013
	.quad	0
	.quad	6222397650095932
	.quad	0
	.quad	3536562136422496
	.quad	0
	.quad	2003826160758530
	.quad	0
	.quad	1131863034325769
	.quad	0
	.quad	637356860083273
	.quad	0
	.quad	357788417745611
	.quad	0
	.quad	200227897999813
	.quad	0
	.quad	111706249597682
	.quad	0
	.quad	62127632354342
	.quad	0
	.quad	34446608007524
	.quad	0
	.quad	19039797740259
	.quad	0
	.quad	10491372044756
	.quad	0
	.quad	5763100854453
	.quad	0
	.quad	3155978317718
	.quad	0
	.quad	1722921730343
	.quad	0
	.quad	937671512532
	.quad	0
	.quad	508732427550
	.quad	0
	.quad	275157616485
	.quad	0
	.quad	148363465153
	.quad	0
	.quad	79749065801
	.quad	0
	.quad	42734373768
	.quad	0
	.quad	22828747560
	.quad	0
	.quad	12157372637
	.quad	0
	.quad	6454315244
	.quad	0
	.quad	3415964299
	.quad	0
	.quad	1802308293
	.quad	0
	.quad	947976022
	.quad	0
	.quad	497070562
	.quad	0
	.quad	259831058
	.quad	0
	.quad	135399268
	.quad	0
	.quad	70338600
	.quad	0
	.quad	36426981
	.quad	0
	.quad	18806354
	.quad	0
	.quad	9679166
	.quad	0
	.quad	4966187
	.quad	0
	.quad	2540153
	.quad	0
	.quad	1295234
	.quad	0
	.quad	658398
	.quad	0
	.quad	333641
	.quad	0
	.quad	168548
	.quad	0
	.quad	84882
	.quad	0
	.quad	42615
	.quad	0
	.quad	21328
	.quad	0
	.quad	10642
	.quad	0
	.quad	5293
	.quad	0
	.quad	2625
	.quad	0
	.quad	1297
	.quad	0
	.quad	639
	.quad	0
	.quad	314
	.quad	0
	.quad	154
	.quad	0
	.quad	75
	.quad	0
	.quad	37
	.quad	0
	.quad	18
	.quad	0
	.quad	9
	.quad	0
	.quad	4
	.quad	0
	.quad	2
	.quad	0
	.quad	1
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	-523566464918115051
	.quad	1856879543224439531
	.quad	-1046792177186421381
	.quad	-3749027658516402073
	.quad	-1568996961559895188
	.quad	1544424865956070197
	.quad	-2089504624308410106
	.quad	3449151401204498800
	.quad	-2607645578809093317
	.quad	8344424996771080457
	.quad	-3122759428286857904
	.quad	-5413222662473718778
	.quad	-3634197489108160599
	.quad	-4777692645860635438
	.quad	-4141325238571160090
	.quad	1800773155638938727
	.quad	-4643524671816517512
	.quad	8062820180986817658
	.quad	-5140196553299192612
	.quad	7573996989988472996
	.quad	-5630762549203328343
	.quad	-1025613017281035619
	.quad	-6114667228238874919
	.quad	4988090017321982721
	.quad	-6591379919417934817
	.quad	9082402333538420614
	.quad	-7060396416657794757
	.quad	3213166128369732055
	.quad	-7521240521382241923
	.quad	7244958247682784880
	.quad	-7973465415678333911
	.quad	3039924504011476739
	.quad	-8416654859997101125
	.quad	-7474046213702966895
	.quad	-8850424210848207003
	.quad	-7819573712309937590
	.quad	9172322818294766078
	.quad	-4763410752074241179
	.quad	8758417212219513239
	.quad	8685091962280839793
	.quad	8354888631113015988
	.quad	-5033997656698857957
	.quad	7961988834131698521
	.quad	587307186275433468
	.quad	7579935652373354015
	.quad	-7353849872032575172
	.quad	7208913064993686652
	.quad	4139601535578720123
	.quad	6849071446920976504
	.quad	8104379531402894524
	.quad	6500527981737662737
	.quad	-1441695486195303126
	.quad	6163367232213334263
	.quad	3419272271295886816
	.quad	5837641859988654318
	.quad	-1330337322427268133
	.quad	5523373485031221344
	.quad	2451779378930526358
	.quad	5220553674717934273
	.quad	5750985781434919278
	.quad	4929145051748266808
	.quad	-7535031566784314688
	.quad	4649082509561666994
	.quad	-1803957508238365330
	.quad	4380274523521329692
	.quad	5850470123980512437
	.quad	4122604545835659318
	.quad	4146995604373451212
	.quad	3875932472016296579
	.quad	-3971506698046599431
	.quad	3640096166614774321
	.quad	-3780061399523310659
	.quad	3414913036034629858
	.quad	-6234597671729273411
	.quad	3200181636376957731
	.quad	-3029778176561948523
	.quad	2995683304538760820
	.quad	-7248552099471298207
	.quad	2801183801137992990
	.quad	7986349419078318146
	.quad	2616434954279075839
	.quad	5757245521888367802
	.quad	2441176293689490450
	.quad	-4769345467306618163
	.quad	2275136665342884783
	.quad	7281060301266975971
	.quad	2118035817327744285
	.quad	-3814615083194633030
	.quad	1969585948413581030
	.quad	-5425066008807895210
	.quad	1829493211499256789
	.quad	5916928760221340842
	.quad	1697459164890962872
	.quad	682754441269900108
	.quad	1573182165141190246
	.quad	570602227007834952
	.quad	1456358695975663957
	.quad	5070065337516521655
	.quad	1346684628633983076
	.quad	2278239388324147863
	.quad	1243856409743357403
	.quad	-1479142167263422165
	.quad	1147572173625658086
	.quad	1451069575138029612
	.quad	1057532776698896691
	.quad	-5164256153204350890
	.quad	973442752368767813
	.quad	5770320683581856888
	.quad	895011185508282423
	.quad	8976705953085554449
	.quad	821952506288757650
	.quad	-6462536802617259769
	.quad	753987203749230828
	.quad	4419788503815072224
	.quad	690842460070197814
	.quad	859853964679961637
	.quad	632252707048647458
	.quad	6300537188682210702
	.quad	577960106752614157
	.quad	8449334116638624191
	.quad	527714958763541732
	.quad	-2921503536756820430
	.quad	481276036792960062
	.quad	-1279711208002031098
	.quad	438410857786270092
	.quad	7753847625188944461
	.quad	398895886901350651
	.quad	2176517930861818246
	.quad	362516681974318167
	.quad	-6665314042792965322
	.quad	329067981260649163
	.quad	-2787348904816297547
	.quad	298353738369005521
	.quad	283389186384310661
	.quad	270187108389845113
	.quad	7688196445538605774
	.quad	244390389263929313
	.quad	-8858925912183042047
	.quad	220794922440082375
	.quad	1236474729379543677
	.quad	199240956840141604
	.quad	-4045510883533488637
	.quad	179577480085229809
	.quad	931907826222844675
	.quad	161662020844641000
	.quad	-8805802533159860459
	.quad	145360426050155674
	.quad	4049712570152321241
	.quad	130546616577886957
	.quad	-9216956814547240404
	.quad	117102324840150668
	.quad	5856204464001608818
	.quad	104916817554613619
	.quad	5575546462615743001
	.quad	93886606770250993
	.quad	-8417740913916290490
	.quad	83915152032435229
	.quad	-940054585988337708
	.quad	74912556365615969
	.quad	-4096734952724362616
	.quad	66795258544174663
	.quad	-7857773195114143574
	.quad	59485723912585894
	.quad	2340818770183942706
	.quad	52912135807213029
	.quad	7665290700263860780
	.quad	47008089425909518
	.quad	5783492071408710467
	.quad	41712289789865166
	.quad	-2467168835174736613
	.quad	36968255246380583
	.quad	-1089197828553585781
	.quad	32724027772802675
	.quad	913018483906103502
	.quad	28931891161824001
	.quad	6198160498380837107
	.quad	25548097997646021
	.quad	-11806601783073804
	.quad	22532606171840501
	.quad	-5151771592240799409
	.quad	19848825537639067
	.quad	3190638843336242386
	.quad	17463375162190061
	.quad	-5128860926776496661
	.quad	15345851508238159
	.quad	4858825432585157317
	.quad	13468607759755656
	.quad	8502067917278690252
	.quad	11806544400206292
	.quad	406701124664913531
	.quad	10336911057160596
	.quad	8090275915984987390
	.quad	9039119542615307
	.quad	-4829983382366353368
	.quad	7894567944223473
	.quad	7782040502513720679
	.quad	6886475558271801
	.quad	-8566747419271828669
	.quad	5999728400146501
	.quad	3523732881658969020
	.quad	5220734981663364
	.quad	-6287236554062402307
	.quad	4537292006425283
	.quad	1823006849750198522
	.quad	3938459603712662
	.quad	7114227820269969750
	.quad	3414445697699854
	.quad	6037489413883627267
	.quad	2956499091411713
	.quad	-7910530672432851459
	.quad	2556810833181905
	.quad	2017668710262763877
	.quad	2208423426853748
	.quad	-928991709029177975
	.quad	1905147444998040
	.quad	3046493217652550000
	.quad	1641485106455791
	.quad	172978725869180460
	.quad	1412560385019002
	.quad	6937029766169456867
	.quad	1214055224540665
	.quad	-5333844958883965890
	.quad	1042151446749263
	.quad	-3159226530599810771
	.quad	893477951099436
	.quad	3090008218051161952
	.quad	765062820719783
	.quad	1560224070431933726
	.quad	654289964556147
	.quad	-1970199825974729790
	.quad	558859942823668
	.quad	4629092219533538220
	.quad	476754640576749
	.quad	-4192747915151559289
	.quad	406205472319016
	.quad	5698629223838526082
	.quad	345664818872900
	.quad	846098989423622002
	.quad	293780416008530
	.quad	3320828418905336814
	.quad	249372432419943
	.quad	4268654333990411949
	.quad	211412992385806
	.quad	6059031283773268768
	.quad	179007915738765
	.quad	127997801033868391
	.quad	151380464491668
	.quad	6585922436750689224
	.quad	127856901550270
	.quad	8614252484138515825
	.quad	107853682319065
	.quad	-73865938356720384
	.quad	90866114634773
	.quad	-5720645313465639734
	.quad	76458336310412
	.quad	1552263311095852274
	.quad	64254472624585
	.quad	-4512573569361471016
	.quad	53930848339374
	.quad	5544832161379133637
	.quad	45209140279533
	.quad	-3991090106665066927
	.quad	37850367167128
	.quad	8012296412652253830
	.quad	31649623297490
	.quad	-4014127473493253591
	.quad	26431471788330
	.quad	969330700538067034
	.quad	22045921561998
	.quad	-7908427777292924310
	.quad	18364919962857
	.quad	8043404509811123385
	.quad	15279300001276
	.quad	-2153223251240175989
	.quad	12696127688642
	.quad	-5450301293270654384
	.quad	10536400820367
	.quad	-6647620158700841588
	.quad	8733055913256
	.quad	1984282513670921470
	.quad	7229244846451
	.quad	3196474862661965665
	.quad	5976847127873
	.quad	-4994272522654324982
	.quad	4935187645931
	.quad	3762211130041243926
	.quad	4069933303552
	.quad	8323550418162153492
	.quad	3352145101146
	.quad	-610316344060279909
	.quad	2757465068202
	.quad	-5220300349259195275
	.quad	2265419969587
	.quad	-8576857453207904105
	.quad	1858825960137
	.quad	7373276354214021564
	.quad	1523280355968
	.quad	4308837488131678599
	.quad	1246728457528
	.quad	3208899345023798317
	.quad	1019094920346
	.quad	-8146780401566184156
	.quad	831970545641
	.quad	-4925885454531970162
	.quad	678346573657
	.quad	5095881202958001223
	.quad	552389625432
	.quad	7987217584804394321
	.quad	449251369770
	.quad	-3579290907423310922
	.quad	364907806092
	.quad	4738898715973448255
	.quad	296023763909
	.quad	-1383512856453485509
	.quad	239838837861
	.quad	9163888132502453436
	.quad	194071514345
	.quad	3598510787208889929
	.quad	156838711568
	.quad	1377693052209983347
	.quad	126588357893
	.quad	1718030934813279661
	.quad	102042981526
	.quad	3236584663328893382
	.quad	82152584717
	.quad	-3193793322617728872
	.quad	66055333893
	.quad	-5218006196164243868
	.quad	53044818900
	.quad	-6619533511174488780
	.quad	42542824649
	.quad	9092145177160853960
	.quad	34076721075
	.quad	8059544966642847789
	.quad	27260716225
	.quad	1064293502096833523
	.quad	21780335670
	.quad	-9118285531638947630
	.quad	17379592182
	.quad	-4925413358024251191
	.quad	13850395148
	.quad	822346220981068201
	.quad	11023821740
	.quad	-495421706701066443
	.quad	8762933244
	.quad	5629754975792763433
	.quad	6956871755
	.quad	-1585742537597689804
	.quad	5516016243
	.quad	-3644822231130925767
	.quad	4368013714
	.quad	8728183233442453704
	.quad	3454532185
	.quad	-2047659019880168795
	.quad	2728608098
	.quad	5747283071990548572
	.quad	2152482519
	.quad	-3083182184870476846
	.quad	1695838663
	.quad	2020331695628916326
	.quad	1334368384
	.quad	6414838152704646943
	.quad	1048607960
	.quad	-5052301022683259265
	.quad	822993942
	.quad	-8828070115637672505
	.quad	645098594
	.quad	3106185758709264182
	.quad	505011664
	.quad	-6660966394276462821
	.quad	394841207
	.quad	2340734894196693460
	.quad	308311107
	.quad	-2547419492671467838
	.quad	240437057
	.quad	-401617109840870022
	.quad	187266056
	.quad	-1755819103305938013
	.quad	145667293
	.quad	4763015285624503055
	.quad	113164512
	.quad	4631143270441411859
	.quad	87801832
	.quad	-3479033500219447723
	.quad	68036494
	.quad	6124623862718040154
	.quad	52653251
	.quad	-6651833108262490261
	.quad	40696146
	.quad	-5054855475781514342
	.quad	31414207
	.quad	-1263044270818503404
	.quad	24218295
	.quad	8140287281518420699
	.quad	18646854
	.quad	2766751311798924792
	.quad	14338774
	.quad	3357342621642802439
	.quad	11011914
	.quad	-6738608765459863568
	.quad	8446133
	.quad	376420708042035360
	.quad	6469894
	.quad	3899317892337409822
	.quad	4949718
	.quad	-1577776291806237832
	.quad	3781881
	.quad	6953837488980916135
	.quad	2885886
	.quad	2521436459310245783
	.quad	2199349
	.quad	-2485568849772439776
	.quad	1673991
	.quad	6278306039549270692
	.quad	1272494
	.quad	1357583437284589837
	.quad	966055
	.quad	2941803730995315961
	.quad	732472
	.quad	-789284871805130243
	.quad	554657
	.quad	4809912397764106474
	.quad	419470
	.quad	4675328974668283950
	.quad	316826
	.quad	1374292698339086359
	.quad	238992
	.quad	5147442029407546901
	.quad	180048
	.quad	-5789691342815717495
	.quad	135468
	.quad	-4746245768707870539
	.quad	101796
	.quad	2228390355024056722
	.quad	76395
	.quad	4329537789890042734
	.quad	57259
	.quad	956163509953763060
	.quad	42861
	.quad	4563539326309201610
	.quad	32042
	.quad	-6815649645923646263
	.quad	23924
	.quad	363326768549490073
	.quad	17839
	.quad	-9202036391715968078
	.quad	13285
	.quad	6884809556114681285
	.quad	9881
	.quad	2663527967843655722
	.quad	7339
	.quad	-4040820509925705977
	.quad	5445
	.quad	779514236156817250
	.quad	4034
	.quad	4413177285066366078
	.quad	2985
	.quad	2521146934103632331
	.quad	2206
	.quad	318166810286377127
	.quad	1628
	.quad	2851801379800860233
	.quad	1200
	.quad	2197978777492325968
	.quad	883
	.quad	8790727988054110069
	.quad	649
	.quad	-8439885116571424256
	.quad	476
	.quad	-1144292096315220919
	.quad	349
	.quad	-4607660912415070734
	.quad	256
	.quad	2782553882118460940
	.quad	187
	.quad	6627667121063464949
	.quad	136
	.quad	-2467975114158014229
	.quad	99
	.quad	-2721531034901136907
	.quad	72
	.quad	-4519542259062320317
	.quad	52
	.quad	-1052111112683417329
	.quad	38
	.quad	8789071683541208859
	.quad	27
	.quad	-1347908347711903092
	.quad	20
	.quad	4497779594053082492
	.quad	14
	.quad	-6353327824874745952
	.quad	10
	.quad	-7446645773884701098
	.quad	7
	.quad	-6428300487585740984
	.quad	5
	.quad	-8891330033576221412
	.quad	3
	.quad	-474760521316322538
	.quad	2
	.quad	-2606048365753736541
	.quad	2
	.quad	989918219048912307
	.quad	1
	.quad	8733082327520556937
	.quad	1
	.quad	1028600461629026845
	.quad	0
	.quad	-4509901693172833499
	.quad	0
	.quad	-8486170471530853946
	.quad	0
	.quad	7109597022753888214
	.quad	0
	.quad	5068112562070069071
	.quad	0
	.quad	3608179244616512654
	.quad	0
	.quad	2565491009104736072
	.quad	0
	.quad	1821769332680772104
	.quad	0
	.quad	1291982795339981490
	.quad	0
	.quad	915082993686355625
	.quad	0
	.quad	647298508026796426
	.quad	0
	.quad	457287208671672607
	.quad	0
	.quad	322636713191339639
	.quad	0
	.quad	227341519682347750
	.quad	0
	.quad	159986719960001094
	.quad	0
	.quad	112442183853150038
	.quad	0
	.quad	78925025444270622
	.quad	0
	.quad	55327401168527005
	.quad	0
	.quad	38735204593169904
	.quad	0
	.quad	27083914936646607
	.quad	0
	.quad	18912850669192999
	.quad	0
	.quad	13189929470991385
	.quad	0
	.quad	9186875754353075
	.quad	0
	.quad	6390473894671985
	.quad	0
	.quad	4439541325188683
	.quad	0
	.quad	3080228394573075
	.quad	0
	.quad	2134359051219929
	.quad	0
	.quad	1477038268558593
	.quad	0
	.quad	1020835317780157
	.quad	0
	.quad	704626971606079
	.quad	0
	.quad	485738403695188
	.quad	0
	.quad	334414567195342
	.quad	0
	.quad	229936261937432
	.quad	0
	.quad	157895315852229
	.quad	0
	.quad	108285546454609
	.quad	0
	.quad	74167078509173
	.quad	0
	.quad	50733082756542
	.quad	0
	.quad	34658574919307
	.quad	0
	.quad	23646642561585
	.quad	0
	.quad	16112672368080
	.quad	0
	.quad	10964906657166
	.quad	0
	.quad	7452149234155
	.quad	0
	.quad	5058215856184
	.quad	0
	.quad	3428880535394
	.quad	0
	.quad	2321381397331
	.quad	0
	.quad	1569566661267
	.quad	0
	.quad	1059868832771
	.quad	0
	.quad	714765427121
	.quad	0
	.quad	481408756812
	.quad	0
	.quad	323819827106
	.quad	0
	.quad	217536362028
	.quad	0
	.quad	145948364189
	.quad	0
	.quad	97792493444
	.quad	0
	.quad	65441116026
	.quad	0
	.quad	43735564533
	.quad	0
	.quad	29191580611
	.quad	0
	.quad	19458945103
	.quad	0
	.quad	12954473157
	.quad	0
	.quad	8613089740
	.quad	0
	.quad	5719221500
	.quad	0
	.quad	3792744286
	.quad	0
	.quad	2511937819
	.quad	0
	.quad	1661509606
	.quad	0
	.quad	1097578151
	.quad	0
	.quad	724113508
	.quad	0
	.quad	477107693
	.quad	0
	.quad	313953074
	.quad	0
	.quad	206324872
	.quad	0
	.quad	135418167
	.quad	0
	.quad	88764795
	.quad	0
	.quad	58108950
	.quad	0
	.quad	37991263
	.quad	0
	.quad	24806349
	.quad	0
	.quad	16176343
	.quad	0
	.quad	10535040
	.quad	0
	.quad	6852206
	.quad	0
	.quad	4451054
	.quad	0
	.quad	2887578
	.quad	0
	.quad	1870866
	.quad	0
	.quad	1210570
	.quad	0
	.quad	782304
	.quad	0
	.quad	504893
	.quad	0
	.quad	325433
	.quad	0
	.quad	209489
	.quad	0
	.quad	134679
	.quad	0
	.quad	86472
	.quad	0
	.quad	55449
	.quad	0
	.quad	35509
	.quad	0
	.quad	22711
	.quad	0
	.quad	14506
	.quad	0
	.quad	9254
	.quad	0
	.quad	5896
	.quad	0
	.quad	3751
	.quad	0
	.quad	2384
	.quad	0
	.quad	1513
	.quad	0
	.quad	959
	.quad	0
	.quad	607
	.quad	0
	.quad	384
	.quad	0
	.quad	242
	.quad	0
	.quad	153
	.quad	0
	.quad	96
	.quad	0
	.quad	60
	.quad	0
	.quad	38
	.quad	0
	.quad	24
	.quad	0
	.quad	15
	.quad	0
	.quad	9
	.quad	0
	.quad	6
	.quad	0
	.quad	4
	.quad	0
	.quad	2
	.quad	0
	.quad	1
	.quad	0
	.quad	1
	.quad	0
	.quad	1
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.align 32
	.type	ft_adaptive_cdf_inv_2sigma0_sq_bits, @object
	.size	ft_adaptive_cdf_inv_2sigma0_sq_bits, 40
ft_adaptive_cdf_inv_2sigma0_sq_bits:
	.quad	4591870180066957722
	.quad	4582862980812216730
	.quad	4573855781557475738
	.quad	4564848582302734746
	.quad	4559144022774732117
	.align 32
	.type	fpr_expm_p63_coefficients, @object
	.size	fpr_expm_p63_coefficients, 104
fpr_expm_p63_coefficients:
	.quad	19127174051
	.quad	233346759686
	.quad	2542029181962
	.quad	25415798087749
	.quad	228754078003076
	.quad	1830034511206115
	.quad	12810238987800554
	.quad	76861433589428176
	.quad	384307168197152512
	.quad	1537228672812056320
	.quad	4611686018427565056
	.quad	9223372036854728704
	.quad	-9223372036854775808
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
