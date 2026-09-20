	.file	"falcon-sign.c"
# GNU C99 (Debian 14.2.0-19) version 14.2.0 (x86_64-linux-gnu)
#	compiled by GNU C version 14.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.27-GMP

# warning: MPFR header version 4.2.1 differs from library version 4.2.2.
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O -std=c99 -fasynchronous-unwind-tables
	.text
	.type	ft_fpr_is_positive_finite, @function
ft_fpr_is_positive_finite:
.LFB70:
	.cfi_startproc
# candidate/source/falcon-sign.c:2631: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	movq	%rdi, %rdx	# x, tmp121
	notq	%rdx	# tmp121
	movabsq	$9218868437227405312, %rax	#, tmp108
	testq	%rax, %rdx	# tmp108, tmp121
	je	.L3	#,
	testq	%rdi, %rdi	# x
	js	.L3	#,
# candidate/source/falcon-sign.c:2631: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	addq	%rdi, %rdi	# tmp122
	setne	%al	#, <retval>
	movzbl	%al, %eax	# <retval>, <retval>
	ret	
.L3:
# candidate/source/falcon-sign.c:2631: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	movl	$0, %eax	#, <retval>
# candidate/source/falcon-sign.c:2632: }
	ret	
	.cfi_endproc
.LFE70:
	.size	ft_fpr_is_positive_finite, .-ft_fpr_is_positive_finite
	.type	ffLDL_ternary_normalize_inner, @function
ffLDL_ternary_normalize_inner:
.LFB47:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 64
	movq	%rdi, %r13	# tmp138, tree
	movq	%rsi, %rbp	# tmp139, sigma
	movq	%rcx, %r12	# tmp141, leaves
	movq	%r8, %rbx	# tmp142, leaf_index
# candidate/source/falcon-sign.c:969: 	if (logn == 1) {
	cmpl	$1, %edx	#, logn
	je	.L8	#,
# candidate/source/falcon-sign.c:995: 	s = (size_t)1 << logn;
	movl	$1, %r14d	#, tmp131
	movl	%edx, %ecx	# logn, tmp150
	salq	%cl, %r14	# tmp150, s
# candidate/source/falcon-sign.c:996: 	s += ffLDL_ternary_normalize_inner(
	leal	-1(%rdx), %r15d	#, _15
# candidate/source/falcon-sign.c:997: 		tree + s, sigma, logn - 1, leaves, leaf_index);
	movl	$8, %edi	#, tmp133
	salq	%cl, %rdi	# tmp151, _16
# candidate/source/falcon-sign.c:996: 	s += ffLDL_ternary_normalize_inner(
	addq	%r13, %rdi	# tree, _17
	movq	%r12, %rcx	# leaves,
	movl	%r15d, %edx	# _15,
	call	ffLDL_ternary_normalize_inner	#
# candidate/source/falcon-sign.c:996: 	s += ffLDL_ternary_normalize_inner(
	addq	%rax, %r14	# tmp147, s
# candidate/source/falcon-sign.c:998: 	s += ffLDL_ternary_normalize_inner(
	leaq	0(%r13,%r14,8), %rdi	#, _19
	movq	%rbx, %r8	# leaf_index,
	movq	%r12, %rcx	# leaves,
	movl	%r15d, %edx	# _15,
	movq	%rbp, %rsi	# sigma,
	call	ffLDL_ternary_normalize_inner	#
# candidate/source/falcon-sign.c:998: 	s += ffLDL_ternary_normalize_inner(
	addq	%r14, %rax	# s, <retval>
.L4:
# candidate/source/falcon-sign.c:1001: }
	addq	$8, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
.L8:
	.cfi_restore_state
# candidate/source/falcon-sign.c:988: 			fpr_sqrt(leaves[(*leaf_index) ++]));
	movq	(%r8), %rax	# *leaf_index_28(D), _1
# candidate/source/falcon-sign.c:988: 			fpr_sqrt(leaves[(*leaf_index) ++]));
	leaq	1(%rax), %rdx	#, tmp127
	movq	%rdx, (%r8)	# tmp127, *leaf_index_28(D)
# candidate/source/falcon-sign.c:987: 		tree[2] = fpr_div(sigma,
	movq	(%rcx,%rax,8), %rdi	# *_4, *_4
	call	fpr_sqrt@PLT	#
	movq	%rax, %rsi	# tmp143, _6
# candidate/source/falcon-sign.c:987: 		tree[2] = fpr_div(sigma,
	movq	%rbp, %rdi	# sigma,
	call	fpr_div@PLT	#
# candidate/source/falcon-sign.c:987: 		tree[2] = fpr_div(sigma,
	movq	%rax, 16(%r13)	# tmp144, MEM[(fpr *)tree_24(D) + 16B]
# candidate/source/falcon-sign.c:990: 			fpr_sqrt(leaves[(*leaf_index) ++]));
	movq	(%rbx), %rax	# *leaf_index_28(D), _8
# candidate/source/falcon-sign.c:990: 			fpr_sqrt(leaves[(*leaf_index) ++]));
	leaq	1(%rax), %rdx	#, tmp129
	movq	%rdx, (%rbx)	# tmp129, *leaf_index_28(D)
# candidate/source/falcon-sign.c:989: 		tree[3] = fpr_div(sigma,
	movq	(%r12,%rax,8), %rdi	# *_11, *_11
	call	fpr_sqrt@PLT	#
	movq	%rax, %rsi	# tmp145, _13
# candidate/source/falcon-sign.c:989: 		tree[3] = fpr_div(sigma,
	movq	%rbp, %rdi	# sigma,
	call	fpr_div@PLT	#
# candidate/source/falcon-sign.c:989: 		tree[3] = fpr_div(sigma,
	movq	%rax, 24(%r13)	# tmp146, MEM[(fpr *)tree_24(D) + 24B]
# candidate/source/falcon-sign.c:992: 		return 4;
	movl	$4, %eax	#, <retval>
	jmp	.L4	#
	.cfi_endproc
.LFE47:
	.size	ffLDL_ternary_normalize_inner, .-ffLDL_ternary_normalize_inner
	.type	ffLDL_ternary_normalize_depth1, @function
ffLDL_ternary_normalize_depth1:
.LFB48:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 64
	movq	%rdi, %r15	# tmp125, tree
	movq	%rsi, %r12	# tmp126, sigma
	movq	%rcx, %r13	# tmp128, leaves
	movq	%r8, %r14	# tmp129, leaf_index
# candidate/source/falcon-sign.c:1009: 	s = (size_t)3 << logn;
	movl	$3, %ebx	#, tmp117
	movl	%edx, %ecx	# logn, tmp134
	salq	%cl, %rbx	# tmp134, s
# candidate/source/falcon-sign.c:1010: 	s += ffLDL_ternary_normalize_inner(
	leal	-1(%rdx), %ebp	#, _1
	leaq	(%rdi,%rbx,8), %rdi	#, _3
	movq	%r13, %rcx	# leaves,
	movl	%ebp, %edx	# _1,
	call	ffLDL_ternary_normalize_inner	#
# candidate/source/falcon-sign.c:1010: 	s += ffLDL_ternary_normalize_inner(
	addq	%rax, %rbx	# tmp130, s
# candidate/source/falcon-sign.c:1012: 	s += ffLDL_ternary_normalize_inner(
	leaq	(%r15,%rbx,8), %rdi	#, _5
	movq	%r14, %r8	# leaf_index,
	movq	%r13, %rcx	# leaves,
	movl	%ebp, %edx	# _1,
	movq	%r12, %rsi	# sigma,
	call	ffLDL_ternary_normalize_inner	#
# candidate/source/falcon-sign.c:1012: 	s += ffLDL_ternary_normalize_inner(
	addq	%rax, %rbx	# tmp131, s
# candidate/source/falcon-sign.c:1014: 	s += ffLDL_ternary_normalize_inner(
	leaq	(%r15,%rbx,8), %rdi	#, _7
	movq	%r14, %r8	# leaf_index,
	movq	%r13, %rcx	# leaves,
	movl	%ebp, %edx	# _1,
	movq	%r12, %rsi	# sigma,
	call	ffLDL_ternary_normalize_inner	#
# candidate/source/falcon-sign.c:1014: 	s += ffLDL_ternary_normalize_inner(
	addq	%rbx, %rax	# s, s_23
# candidate/source/falcon-sign.c:1017: }
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE48:
	.size	ffLDL_ternary_normalize_depth1, .-ffLDL_ternary_normalize_depth1
	.type	ffLDL_binary_normalize, @function
ffLDL_binary_normalize:
.LFB37:
	.cfi_startproc
	pushq	%r13	#
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12	#
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp	#
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx	#
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbp	# tmp124, tree
	movq	%rsi, %r12	# tmp125, sigma
# candidate/source/falcon-sign.c:447: 	if (n == 1) {
	testl	%edx, %edx	# logn
	jne	.L12	#,
# candidate/source/falcon-sign.c:448: 		tree[0] = fpr_div(sigma, fpr_sqrt(tree[0]));
	movq	(%rdi), %rdi	# *tree_14(D), *tree_14(D)
	call	fpr_sqrt@PLT	#
	movq	%rax, %rsi	# tmp127, _2
# candidate/source/falcon-sign.c:448: 		tree[0] = fpr_div(sigma, fpr_sqrt(tree[0]));
	movq	%r12, %rdi	# sigma,
	call	fpr_div@PLT	#
# candidate/source/falcon-sign.c:448: 		tree[0] = fpr_div(sigma, fpr_sqrt(tree[0]));
	movq	%rax, 0(%rbp)	# tmp128, *tree_14(D)
.L11:
# candidate/source/falcon-sign.c:455: }
	addq	$8, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx	#
	.cfi_def_cfa_offset 32
	popq	%rbp	#
	.cfi_def_cfa_offset 24
	popq	%r12	#
	.cfi_def_cfa_offset 16
	popq	%r13	#
	.cfi_def_cfa_offset 8
	ret	
.L12:
	.cfi_restore_state
	movl	%edx, %ebx	# tmp126, logn
# candidate/source/falcon-sign.c:450: 		ffLDL_binary_normalize(tree + n,
	leal	-1(%rdx), %r13d	#, _4
# candidate/source/falcon-sign.c:450: 		ffLDL_binary_normalize(tree + n,
	movl	$8, %edi	#, tmp115
	movl	%edx, %ecx	# logn, tmp130
	salq	%cl, %rdi	# tmp130, _5
# candidate/source/falcon-sign.c:450: 		ffLDL_binary_normalize(tree + n,
	addq	%rbp, %rdi	# tree, _6
	movl	%r13d, %edx	# _4,
	call	ffLDL_binary_normalize	#
# candidate/source/falcon-sign.c:452: 		ffLDL_binary_normalize(tree + n + ffLDL_treesize(logn - 1),
	movl	%ebx, %eax	# logn, _7
	movl	%r13d, %ecx	# _4, tmp132
	sall	%cl, %eax	# tmp132, _7
# candidate/source/falcon-sign.c:446: 	n = MKN(logn, 0);
	movl	$1, %edx	#, tmp120
	movl	%ebx, %ecx	# logn, tmp133
	salq	%cl, %rdx	# tmp133, n_13
# candidate/source/falcon-sign.c:452: 		ffLDL_binary_normalize(tree + n + ffLDL_treesize(logn - 1),
	addq	%rdx, %rax	# n_13, _8
# candidate/source/falcon-sign.c:452: 		ffLDL_binary_normalize(tree + n + ffLDL_treesize(logn - 1),
	leaq	0(%rbp,%rax,8), %rdi	#, _10
	movl	%r13d, %edx	# _4,
	movq	%r12, %rsi	# sigma,
	call	ffLDL_binary_normalize	#
# candidate/source/falcon-sign.c:455: }
	jmp	.L11	#
	.cfi_endproc
.LFE37:
	.size	ffLDL_binary_normalize, .-ffLDL_binary_normalize
	.type	LDL_dim2_fft3, @function
LDL_dim2_fft3:
.LFB38:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp	#,
	.cfi_def_cfa_offset 80
	movq	%rdi, %rbp	# tmp126, d11
	movq	%rsi, %r14	# tmp127, l10
	movq	%rdx, (%rsp)	# tmp128, %sfp
	movq	%rcx, %r15	# tmp129, g10
	movq	%r8, 8(%rsp)	# tmp130, %sfp
	movl	%r9d, %ebx	# tmp131, logn
	movl	80(%rsp), %r12d	# full, full
# candidate/source/falcon-sign.c:511: 	n = MKN(logn, full);
	leal	1(%r12,%r12), %r13d	#, _3
	movl	%r9d, %ecx	# logn, _4
	subl	%r12d, %ecx	# full, _4
# candidate/source/falcon-sign.c:511: 	n = MKN(logn, full);
	salq	%cl, %r13	# _4, n_8
# candidate/source/falcon-sign.c:518: 	memcpy(l10, g10, n * sizeof *g10);
	salq	$3, %r13	#, _5
	movq	%r13, %rdx	# _5,
	movq	%r15, %rsi	# g10,
	movq	%r14, %rdi	# l10,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:519: 	falcon_poly_div_autoadj_fft3(l10, g00, logn, full);
	movl	%r12d, %ecx	# full,
	movl	%ebx, %edx	# logn,
	movq	(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# l10,
	call	falcon_poly_div_autoadj_fft3@PLT	#
# candidate/source/falcon-sign.c:526: 	memcpy(d11, g10, n * sizeof *g10);
	movq	%r13, %rdx	# _5,
	movq	%r15, %rsi	# g10,
	movq	%rbp, %rdi	# d11,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:527: 	falcon_poly_muladj_fft3(d11, l10, logn, full);
	movl	%r12d, %ecx	# full,
	movl	%ebx, %edx	# logn,
	movq	%r14, %rsi	# l10,
	movq	%rbp, %rdi	# d11,
	call	falcon_poly_muladj_fft3@PLT	#
# candidate/source/falcon-sign.c:528: 	falcon_poly_neg_fft3(d11, logn, full);
	movl	%r12d, %edx	# full,
	movl	%ebx, %esi	# logn,
	movq	%rbp, %rdi	# d11,
	call	falcon_poly_neg3@PLT	#
# candidate/source/falcon-sign.c:529: 	falcon_poly_add_fft3(d11, g11, logn, full);
	movl	%r12d, %ecx	# full,
	movl	%ebx, %edx	# logn,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# d11,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:530: }
	addq	$24, %rsp	#,
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE38:
	.size	LDL_dim2_fft3, .-LDL_dim2_fft3
	.type	ffLDL_inner_fft3, @function
ffLDL_inner_fft3:
.LFB40:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp	#,
	.cfi_def_cfa_offset 96
	movq	%rdi, (%rsp)	# tmp129, %sfp
	movq	%rsi, 8(%rsp)	# tmp130, %sfp
	movq	%rdx, 16(%rsp)	# tmp131, %sfp
	movq	%rcx, 24(%rsp)	# tmp132, %sfp
	movq	%r9, %rbx	# tmp134, tmp
# candidate/source/falcon-sign.c:605: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp120
	movl	%r8d, %ecx	# logn, tmp139
	salq	%cl, %rax	# tmp139, tmp120
# candidate/source/falcon-sign.c:606: 	hn = n >> 1;
	movq	%rax, %r12	# n, hn
	shrq	%r12	# hn
# candidate/source/falcon-sign.c:608: 	if (logn == 1) {
	cmpl	$1, %r8d	#, logn
	je	.L21	#,
	movl	%r8d, %ebp	# tmp133, logn
	movq	%rax, %r14	# tmp120, n
# candidate/source/falcon-sign.c:634: 	t1 = tmp + hn;
	salq	$3, %r12	#, _3
# candidate/source/falcon-sign.c:634: 	t1 = tmp + hn;
	leaq	(%r9,%r12), %r13	#, t1
# candidate/source/falcon-sign.c:635: 	t2 = t1 + hn;
	addq	%r13, %r12	# t1, t2
# candidate/source/falcon-sign.c:637: 	falcon_poly_split_deep_fft3(t0, t1, g00, logn);
	movl	%r8d, %ecx	# logn,
	movq	8(%rsp), %rdx	# %sfp,
	movq	%r13, %rsi	# t1,
	movq	%r9, %rdi	# tmp,
	call	falcon_poly_split_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:638: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	leal	-1(%rbp), %r15d	#, _4
	movl	$0, %edx	#,
	movl	%r15d, %esi	# _4,
	movq	%r13, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# candidate/source/falcon-sign.c:639: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	movl	$8, %edi	#, tmp124
	movl	%ebp, %ecx	# logn, tmp144
	salq	%cl, %rdi	# tmp144, _5
# candidate/source/falcon-sign.c:639: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	movq	(%rsp), %rax	# %sfp, tree
	addq	%rax, %rdi	# tree, _6
	movq	%r12, %r9	# t2,
	movl	%r15d, %r8d	# _4,
	movq	%rbx, %rcx	# tmp,
	movq	%r13, %rdx	# t1,
	movq	%rbx, %rsi	# tmp,
	call	ffLDL_inner_fft3	#
# candidate/source/falcon-sign.c:639: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	addq	%rax, %r14	# tmp135, s
# candidate/source/falcon-sign.c:641: 	LDL_dim2_fft3(t2, tree, g00, g10, g11, logn, 0);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 104
	pushq	$0	#
	.cfi_def_cfa_offset 112
	movl	%ebp, %r9d	# logn,
	movq	40(%rsp), %r8	# %sfp,
	movq	32(%rsp), %rcx	# %sfp,
	movq	24(%rsp), %rdx	# %sfp,
	movq	16(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# t2,
	call	LDL_dim2_fft3	#
# candidate/source/falcon-sign.c:643: 	falcon_poly_split_deep_fft3(t0, t1, t2, logn);
	movl	%ebp, %ecx	# logn,
	movq	%r12, %rdx	# t2,
	movq	%r13, %rsi	# t1,
	movq	%rbx, %rdi	# tmp,
	call	falcon_poly_split_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:644: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	movl	$0, %edx	#,
	movl	%r15d, %esi	# _4,
	movq	%r13, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# candidate/source/falcon-sign.c:645: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	movq	16(%rsp), %rax	# %sfp, tree
	leaq	(%rax,%r14,8), %rdi	#, _8
	movq	%r12, %r9	# t2,
	movl	%r15d, %r8d	# _4,
	movq	%rbx, %rcx	# tmp,
	movq	%r13, %rdx	# t1,
	movq	%rbx, %rsi	# tmp,
	call	ffLDL_inner_fft3	#
# candidate/source/falcon-sign.c:645: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	addq	%r14, %rax	# s, <retval>
# candidate/source/falcon-sign.c:647: 	return s;
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 96
.L17:
# candidate/source/falcon-sign.c:648: }
	addq	$40, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
.L21:
	.cfi_restore_state
# candidate/source/falcon-sign.c:620: 		LDL_dim2_fft3(tmp, tree, g00, g10, g11, logn, 0);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 104
	pushq	$0	#
	.cfi_def_cfa_offset 112
	movl	$1, %r9d	#,
	movq	40(%rsp), %r8	# %sfp,
	movq	32(%rsp), %rcx	# %sfp,
	movq	24(%rsp), %r14	# %sfp, g00
	movq	%r14, %rdx	# g00,
	movq	16(%rsp), %r15	# %sfp, tree
	movq	%r15, %rsi	# tree,
	movq	%rbx, %rdi	# tmp,
	call	LDL_dim2_fft3	#
# candidate/source/falcon-sign.c:622: 		tree[2] = g00[0];
	movq	(%r14), %rax	# *g00_18(D), *g00_18(D)
	movq	%rax, 16(%r15)	# *g00_18(D), MEM[(fpr *)tree_21(D) + 16B]
# candidate/source/falcon-sign.c:623: 		tree[3] = tmp[0];
	movq	(%rbx), %rax	# *tmp_14(D), *tmp_14(D)
	movq	%rax, 24(%r15)	# *tmp_14(D), MEM[(fpr *)tree_21(D) + 24B]
# candidate/source/falcon-sign.c:624: 		return 4;
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 96
	movl	$4, %eax	#, <retval>
	jmp	.L17	#
	.cfi_endproc
.LFE40:
	.size	ffLDL_inner_fft3, .-ffLDL_inner_fft3
	.type	ffLDL_depth1_fft3, @function
ffLDL_depth1_fft3:
.LFB41:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$80, %rsp	#,
	.cfi_def_cfa_offset 136
	movq	%rdx, %r11	# tmp165, g10
	movq	%rcx, %rax	# g11, tmp166
	movq	%r8, 40(%rsp)	# tmp167, %sfp
	movq	%r9, 64(%rsp)	# tmp168, %sfp
	movl	144(%rsp), %ebx	# logn, logn
# candidate/source/falcon-sign.c:668: 	l20 = l10 + n;
	movl	$8, %r14d	#, tmp131
	movl	%ebx, %ecx	# logn, tmp173
	salq	%cl, %r14	# tmp173, _1
# candidate/source/falcon-sign.c:668: 	l20 = l10 + n;
	leaq	(%rdi,%r14), %rcx	#, l20
# candidate/source/falcon-sign.c:669: 	l21 = l20 + n;
	movq	%rcx, 16(%rsp)	# l20, %sfp
	leaq	(%rcx,%r14), %r15	#, l21
# candidate/source/falcon-sign.c:671: 	d22 = d11 + n;
	movq	%r14, %rcx	# _1, d22
	addq	152(%rsp), %rcx	# tmp, d22
# candidate/source/falcon-sign.c:672: 	t0 = d22 + n;
	movq	%rcx, 8(%rsp)	# d22, %sfp
	leaq	(%rcx,%r14), %r12	#, t0
# candidate/source/falcon-sign.c:665: 	n = (size_t)1 << logn;
	movl	$1, %ebp	#, tmp133
	movl	%ebx, %ecx	# logn, tmp179
	salq	%cl, %rbp	# tmp179, n_11
# candidate/source/falcon-sign.c:666: 	hn = n >> 1;
	shrq	%rbp	# hn_12
# candidate/source/falcon-sign.c:673: 	t1 = t0 + hn;
	salq	$3, %rbp	#, _2
# candidate/source/falcon-sign.c:673: 	t1 = t0 + hn;
	leaq	(%r12,%rbp), %r13	#, t1
# candidate/source/falcon-sign.c:674: 	t2 = t1 + hn;
	addq	%r13, %rbp	# t1, t2
# candidate/source/falcon-sign.c:675: 	s = 3 * n;
	movl	$3, %edx	#, tmp135
	salq	%cl, %rdx	# tmp181, tmp135
	movq	%rdx, 56(%rsp)	# tmp135, %sfp
# candidate/source/falcon-sign.c:565: 	LDL_dim2_fft3(d11, l10, g00, g10, g11, logn, full);
	pushq	$0	#
	.cfi_def_cfa_offset 144
	movl	%ebx, %r9d	# logn,
	movq	%rax, %r8	# tmp166,
	movq	%r11, 56(%rsp)	# g10, %sfp
	movq	%r11, %rcx	# g10,
	movq	%rsi, 40(%rsp)	# g00, %sfp
	movq	%rsi, %rdx	# g00,
	movq	%rdi, 32(%rsp)	# tree, %sfp
	movq	%rdi, %rsi	# tree,
	movq	160(%rsp), %rdi	# tmp,
	call	LDL_dim2_fft3	#
# candidate/source/falcon-sign.c:570: 	memcpy(l20, g20, n * sizeof *g20);
	movq	%r14, %rdx	# _1,
	movq	48(%rsp), %rsi	# %sfp,
	movq	24(%rsp), %rdi	# %sfp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:571: 	falcon_poly_div_autoadj_fft3(l20, g00, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	40(%rsp), %rsi	# %sfp,
	movq	24(%rsp), %rdi	# %sfp,
	call	falcon_poly_div_autoadj_fft3@PLT	#
# candidate/source/falcon-sign.c:577: 	memcpy(l21, g20, n * sizeof *g20);
	movq	%r14, %rdx	# _1,
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# l21,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:578: 	falcon_poly_muladj_fft3(l21, g10, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	56(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# l21,
	call	falcon_poly_muladj_fft3@PLT	#
# candidate/source/falcon-sign.c:579: 	falcon_poly_div_autoadj_fft3(l21, g00, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	40(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# l21,
	call	falcon_poly_div_autoadj_fft3@PLT	#
# candidate/source/falcon-sign.c:580: 	falcon_poly_neg_fft3(l21, logn, full);
	movl	$0, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%r15, %rdi	# l21,
	call	falcon_poly_neg3@PLT	#
# candidate/source/falcon-sign.c:581: 	falcon_poly_add_fft3(l21, g21, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	72(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# l21,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:582: 	falcon_poly_div_autoadj_fft3(l21, d11, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	160(%rsp), %rsi	# tmp,
	movq	%r15, %rdi	# l21,
	call	falcon_poly_div_autoadj_fft3@PLT	#
# candidate/source/falcon-sign.c:587: 	memcpy(d22, l20, n * sizeof *l20);
	movq	%r14, %rdx	# _1,
	movq	24(%rsp), %rsi	# %sfp,
	movq	16(%rsp), %rdi	# %sfp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:588: 	falcon_poly_muladj_fft3(d22, g20, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	48(%rsp), %rsi	# %sfp,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_muladj_fft3@PLT	#
# candidate/source/falcon-sign.c:589: 	falcon_poly_neg_fft3(d22, logn, full);
	movl	$0, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_neg3@PLT	#
# candidate/source/falcon-sign.c:590: 	falcon_poly_add_fft3(d22, g22, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	144(%rsp), %rsi	# g22,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:591: 	memcpy(tmp, l21, n * sizeof *l21);
	movq	%r14, %rdx	# _1,
	movq	%r15, %rsi	# l21,
	movq	%rbp, %rdi	# t2,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:592: 	falcon_poly_mulselfadj_fft3(tmp, logn, full);
	movl	$0, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%rbp, %rdi	# t2,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# candidate/source/falcon-sign.c:593: 	falcon_poly_mul_autoadj_fft3(tmp, d11, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	160(%rsp), %rsi	# tmp,
	movq	%rbp, %rdi	# t2,
	call	falcon_poly_mul_autoadj_fft3@PLT	#
# candidate/source/falcon-sign.c:594: 	falcon_poly_sub_fft3(d22, tmp, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%rbp, %rsi	# t2,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_sub3@PLT	#
# candidate/source/falcon-sign.c:690: 	falcon_poly_split_deep_fft3(t0, t1, g00, logn);
	movl	%ebx, %ecx	# logn,
	movq	40(%rsp), %rdx	# %sfp,
	movq	%r13, %rsi	# t1,
	movq	%r12, %rdi	# t0,
	call	falcon_poly_split_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:691: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	leal	-1(%rbx), %r15d	#, _3
	movl	$0, %edx	#,
	movl	%r15d, %esi	# _3,
	movq	%r13, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# candidate/source/falcon-sign.c:692: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	movq	32(%rsp), %rax	# %sfp, tree
	movq	64(%rsp), %r14	# %sfp, s
	leaq	(%rax,%r14,8), %rdi	#, _5
	movq	%rbp, %r9	# t2,
	movl	%r15d, %r8d	# _3,
	movq	%r12, %rcx	# t0,
	movq	%r13, %rdx	# t1,
	movq	%r12, %rsi	# t0,
	call	ffLDL_inner_fft3	#
# candidate/source/falcon-sign.c:692: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	addq	%rax, %r14	# tmp169, s
# candidate/source/falcon-sign.c:694: 	falcon_poly_split_deep_fft3(t0, t1, d11, logn);
	movl	%ebx, %ecx	# logn,
	movq	160(%rsp), %rdx	# tmp,
	movq	%r13, %rsi	# t1,
	movq	%r12, %rdi	# t0,
	call	falcon_poly_split_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:695: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	movl	$0, %edx	#,
	movl	%r15d, %esi	# _3,
	movq	%r13, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# candidate/source/falcon-sign.c:696: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	movq	32(%rsp), %rax	# %sfp, tree
	leaq	(%rax,%r14,8), %rdi	#, _7
	movq	%rbp, %r9	# t2,
	movl	%r15d, %r8d	# _3,
	movq	%r12, %rcx	# t0,
	movq	%r13, %rdx	# t1,
	movq	%r12, %rsi	# t0,
	call	ffLDL_inner_fft3	#
# candidate/source/falcon-sign.c:696: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	addq	%rax, %r14	# tmp170, s
# candidate/source/falcon-sign.c:698: 	falcon_poly_split_deep_fft3(t0, t1, d22, logn);
	movl	%ebx, %ecx	# logn,
	movq	16(%rsp), %rdx	# %sfp,
	movq	%r13, %rsi	# t1,
	movq	%r12, %rdi	# t0,
	call	falcon_poly_split_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:699: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	movl	$0, %edx	#,
	movl	%r15d, %esi	# _3,
	movq	%r13, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# candidate/source/falcon-sign.c:700: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	movq	32(%rsp), %rax	# %sfp, tree
	leaq	(%rax,%r14,8), %rdi	#, _9
	movq	%rbp, %r9	# t2,
	movl	%r15d, %r8d	# _3,
	movq	%r12, %rcx	# t0,
	movq	%r13, %rdx	# t1,
	movq	%r12, %rsi	# t0,
	call	ffLDL_inner_fft3	#
# candidate/source/falcon-sign.c:700: 	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);
	addq	%r14, %rax	# s, s_44
# candidate/source/falcon-sign.c:703: }
	addq	$88, %rsp	#,
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE41:
	.size	ffLDL_depth1_fft3, .-ffLDL_depth1_fft3
	.type	LDL_fft, @function
LDL_fft:
.LFB32:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp	#,
	.cfi_def_cfa_offset 80
	movq	%rdi, %r14	# tmp122, d11
	movq	%rsi, %r13	# tmp123, l10
	movq	%rdx, %r15	# tmp124, g00
	movq	%rcx, %rsi	# tmp125, g01
	movq	%r8, 8(%rsp)	# tmp126, %sfp
	movl	%r9d, %ebx	# tmp127, logn
	movq	80(%rsp), %rbp	# tmp, tmp
# candidate/source/falcon-sign.c:303: 	memcpy(tmp, g01, n * sizeof *g01);
	movl	$8, %r12d	#, tmp106
	movl	%r9d, %ecx	# logn, tmp129
	salq	%cl, %r12	# tmp129, _1
	movq	%r12, %rdx	# _1,
	movq	%rbp, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:304: 	falcon_poly_div_fft(tmp, g00, logn);
	movl	%ebx, %edx	# logn,
	movq	%r15, %rsi	# g00,
	movq	%rbp, %rdi	# tmp,
	call	falcon_poly_div_fft@PLT	#
# candidate/source/falcon-sign.c:307: 	memcpy(l10, tmp, n * sizeof *tmp);
	movq	%r12, %rdx	# _1,
	movq	%rbp, %rsi	# tmp,
	movq	%r13, %rdi	# l10,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:308: 	falcon_poly_adj_fft(l10, logn);
	movl	%ebx, %esi	# logn,
	movq	%r13, %rdi	# l10,
	call	falcon_poly_adj_fft@PLT	#
# candidate/source/falcon-sign.c:309: 	falcon_poly_mul_fft(tmp, l10, logn);
	movl	%ebx, %edx	# logn,
	movq	%r13, %rsi	# l10,
	movq	%rbp, %rdi	# tmp,
	call	falcon_poly_mul_fft@PLT	#
# candidate/source/falcon-sign.c:312: 	falcon_poly_mul_fft(tmp, g00, logn);
	movl	%ebx, %edx	# logn,
	movq	%r15, %rsi	# g00,
	movq	%rbp, %rdi	# tmp,
	call	falcon_poly_mul_fft@PLT	#
# candidate/source/falcon-sign.c:313: 	memcpy(d11, g11, n * sizeof *g11);
	movq	%r12, %rdx	# _1,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# d11,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:314: 	falcon_poly_sub_fft(d11, tmp, logn);
	movl	%ebx, %edx	# logn,
	movq	%rbp, %rsi	# tmp,
	movq	%r14, %rdi	# d11,
	call	falcon_poly_sub@PLT	#
# candidate/source/falcon-sign.c:315: }
	addq	$24, %rsp	#,
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE32:
	.size	LDL_fft, .-LDL_fft
	.type	ffLDL_fft_inner, @function
ffLDL_fft_inner:
.LFB35:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp	#,
	.cfi_def_cfa_offset 96
	movq	%rdi, %r13	# tmp129, tree
	movq	%rsi, %rbp	# tmp130, g0
# candidate/source/falcon-sign.c:361: 	if (n == 1) {
	testl	%ecx, %ecx	# logn
	jne	.L27	#,
# candidate/source/falcon-sign.c:362: 		tree[0] = g0[0];
	movq	(%rsi), %rax	# *g0_20(D), *g0_20(D)
	movq	%rax, (%rdi)	# *g0_20(D), *tree_19(D)
.L26:
# candidate/source/falcon-sign.c:391: }
	addq	$40, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
.L27:
	.cfi_restore_state
	movq	%rdx, %r14	# tmp131, g1
	movl	%ecx, %ebx	# tmp132, logn
	movq	%r8, %r12	# tmp133, tmp
# candidate/source/falcon-sign.c:360: 	n = MKN(logn, 0);
	movl	$1, %eax	#, tmp119
	salq	%cl, %rax	# tmp136, tmp119
	movq	%rax, %r15	# tmp119, n
# candidate/source/falcon-sign.c:372: 	LDLqc_fft(tmp, tree, g0, g1, logn, tmp + n);
	movl	$8, %eax	#, tmp120
	salq	%cl, %rax	# tmp138, tmp120
# candidate/source/falcon-sign.c:325: 	LDL_fft(d11, l10, g00, g01, g00, logn, tmp);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 104
# candidate/source/falcon-sign.c:372: 	LDLqc_fft(tmp, tree, g0, g1, logn, tmp + n);
	movq	%rax, 8(%rsp)	# _2, %sfp
	addq	%r8, %rax	# tmp, _3
# candidate/source/falcon-sign.c:325: 	LDL_fft(d11, l10, g00, g01, g00, logn, tmp);
	pushq	%rax	# _3
	.cfi_def_cfa_offset 112
	movl	%ecx, %r9d	# logn,
	movq	%rsi, %r8	# g0,
	movq	%rdx, %rcx	# g1,
	movq	%rsi, %rdx	# g0,
	movq	%rdi, %rsi	# tree,
	movq	%r12, %rdi	# tmp,
	call	LDL_fft	#
# candidate/source/falcon-sign.c:365: 	hn = n >> 1;
	movq	%r15, 40(%rsp)	# n, %sfp
	shrq	%r15	# hn_16
# candidate/source/falcon-sign.c:380: 	falcon_poly_split_fft(g1, g1 + hn, g0, logn);
	salq	$3, %r15	#, _4
# candidate/source/falcon-sign.c:380: 	falcon_poly_split_fft(g1, g1 + hn, g0, logn);
	leaq	(%r14,%r15), %rdx	#, _5
	movq	%rdx, %rsi	# _5, _5
	movl	%ebx, %ecx	# logn,
	movq	%rbp, %rdx	# g0,
	movq	%rsi, 24(%rsp)	# _5, %sfp
	movq	%r14, %rdi	# g1,
	call	falcon_poly_split_fft@PLT	#
# candidate/source/falcon-sign.c:381: 	falcon_poly_split_fft(g0, g0 + hn, tmp, logn);
	leaq	0(%rbp,%r15), %rcx	#, _6
	movq	%rcx, %r10	# _6, _6
	movl	%ebx, %ecx	# logn,
	movq	%r12, %rdx	# tmp,
	movq	%r10, 32(%rsp)	# _6, %sfp
	movq	%r10, %rsi	# _6,
	movq	%rbp, %rdi	# g0,
	call	falcon_poly_split_fft@PLT	#
# candidate/source/falcon-sign.c:387: 	ffLDL_fft_inner(tree + n,
	leal	-1(%rbx), %r15d	#, _7
	movq	16(%rsp), %rdi	# %sfp, _2
	addq	%r13, %rdi	# tree, _8
	movq	%r12, %r8	# tmp,
	movl	%r15d, %ecx	# _7,
	movq	24(%rsp), %rdx	# %sfp,
	movq	%r14, %rsi	# g1,
	call	ffLDL_fft_inner	#
# candidate/source/falcon-sign.c:389: 	ffLDL_fft_inner(tree + n + ffLDL_treesize(logn - 1),
	movl	%r15d, %ecx	# _7, tmp144
	sall	%cl, %ebx	# tmp144, _9
	movq	40(%rsp), %rax	# %sfp, n
	addq	%rax, %rbx	# n, _10
# candidate/source/falcon-sign.c:389: 	ffLDL_fft_inner(tree + n + ffLDL_treesize(logn - 1),
	leaq	0(%r13,%rbx,8), %rdi	#, _12
	movq	%r12, %r8	# tmp,
	movl	%r15d, %ecx	# _7,
	movq	32(%rsp), %rdx	# %sfp,
	movq	%rbp, %rsi	# g0,
	call	ffLDL_fft_inner	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 96
	jmp	.L26	#
	.cfi_endproc
.LFE35:
	.size	ffLDL_fft_inner, .-ffLDL_fft_inner
	.type	smallints_to_fpr, @function
smallints_to_fpr:
.LFB50:
	.cfi_startproc
	pushq	%r13	#
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12	#
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp	#
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx	#
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 48
# candidate/source/falcon-sign.c:1053: 	n = MKN(logn, ter);
	leal	1(%rcx,%rcx), %ebp	#, _3
	subl	%ecx, %edx	# ter, _4
# candidate/source/falcon-sign.c:1053: 	n = MKN(logn, ter);
	movl	%edx, %ecx	# _4, tmp122
	salq	%cl, %rbp	# tmp122, n
# candidate/source/falcon-sign.c:1054: 	for (u = 0; u < n; u ++) {
	testq	%rbp, %rbp	# n
	je	.L30	#,
	movq	%rdi, %r12	# tmp116, r
	movq	%rsi, %r13	# tmp117, t
# candidate/source/falcon-sign.c:1054: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L32:
# candidate/source/falcon-sign.c:1055: 		r[u] = fpr_of(t[u]);
	movswq	0(%r13,%rbx,2), %rdi	# MEM[(const int16_t *)t_17(D) + u_25 * 2], _8
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# candidate/source/falcon-sign.c:1055: 		r[u] = fpr_of(t[u]);
	movq	%rax, (%r12,%rbx,8)	# tmp120, MEM[(fpr *)r_18(D) + u_25 * 8]
# candidate/source/falcon-sign.c:1054: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# candidate/source/falcon-sign.c:1054: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %rbp	# u, n
	jne	.L32	#,
.L30:
# candidate/source/falcon-sign.c:1057: }
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 40
	popq	%rbx	#
	.cfi_def_cfa_offset 32
	popq	%rbp	#
	.cfi_def_cfa_offset 24
	popq	%r12	#
	.cfi_def_cfa_offset 16
	popq	%r13	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE50:
	.size	smallints_to_fpr, .-smallints_to_fpr
	.type	ffSampling_inner_fft3, @function
ffSampling_inner_fft3:
.LFB59:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp	#,
	.cfi_def_cfa_offset 144
	movq	%rdi, 8(%rsp)	# tmp180, %sfp
	movq	%rsi, 16(%rsp)	# tmp181, %sfp
	movq	%rdx, %r14	# tmp182, z0
	movq	%rcx, %rbx	# tmp183, z1
	movq	%r8, (%rsp)	# tmp184, %sfp
	movq	%r9, 40(%rsp)	# tmp185, %sfp
	movq	144(%rsp), %rdx	# t1, t1
	movl	152(%rsp), %ebp	# logn, logn
	movq	160(%rsp), %r12	# tmp, tmp
# candidate/source/falcon-sign.c:1633: 	if (logn == 0) {
	testl	%ebp, %ebp	# logn
	je	.L39	#,
# candidate/source/falcon-sign.c:1652: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp163
	movl	%ebp, %ecx	# logn, tmp206
	salq	%cl, %rax	# tmp206, n
# candidate/source/falcon-sign.c:1653: 	hn = n >> 1;
	movq	%rax, %rcx	# n, hn_17
	shrq	%rcx	# hn_17
# candidate/source/falcon-sign.c:1655: 	y1 = y0 + hn;
	leaq	0(,%rcx,8), %r13	#, _6
# candidate/source/falcon-sign.c:1655: 	y1 = y0 + hn;
	leaq	(%r12,%r13), %rcx	#, y1
	movq	%rcx, 32(%rsp)	# y1, %sfp
# candidate/source/falcon-sign.c:1657: 	tree0 = tree + n;
	movl	$8, %esi	#, tmp165
	movl	%ebp, %ecx	# logn, tmp210
	salq	%cl, %rsi	# tmp210, tmp165
	movq	%rsi, %r15	# tmp165, _7
# candidate/source/falcon-sign.c:1657: 	tree0 = tree + n;
	movq	(%rsp), %rdi	# %sfp, tree
	leaq	(%rdi,%rsi), %rsi	#, tree0
	movq	%rsi, 64(%rsp)	# tree0, %sfp
# candidate/source/falcon-sign.c:1658: 	tree1 = tree + n + (logn << (logn - 1));
	leal	-1(%rbp), %esi	#, _8
# candidate/source/falcon-sign.c:1658: 	tree1 = tree + n + (logn << (logn - 1));
	movl	%ebp, %r10d	# logn, _10
	movl	%esi, 28(%rsp)	# _8, %sfp
	movzbl	28(%rsp), %ecx	# %sfp, tmp215
	sall	%cl, %r10d	# tmp215, _10
	addq	%r10, %rax	# _10, _11
# candidate/source/falcon-sign.c:1658: 	tree1 = tree + n + (logn << (logn - 1));
	leaq	(%rdi,%rax,8), %r10	#, tree1
	movq	%r10, 72(%rsp)	# tree1, %sfp
# candidate/source/falcon-sign.c:1664: 	x1 = x0 + hn;
	leaq	(%rbx,%r13), %r11	#, x1
# candidate/source/falcon-sign.c:1665: 	falcon_poly_split_deep_fft3(x0, x1, t1, logn);
	movl	%ebp, %ecx	# logn,
	movq	%r11, 56(%rsp)	# x1, %sfp
	movq	%r11, %rsi	# x1,
	movq	%rbx, %rdi	# z1,
	call	falcon_poly_split_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:1666: 	ffSampling_inner_fft3(samp, samp_ctx,
	leaq	(%r12,%r15), %rdx	#, _13
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 152
	movq	%rdx, 56(%rsp)	# _13, %sfp
	pushq	%rdx	#
	.cfi_def_cfa_offset 160
	movl	44(%rsp), %eax	# %sfp, _8
	pushq	%rax	# _8
	.cfi_def_cfa_offset 168
	pushq	80(%rsp)	# %sfp
	.cfi_def_cfa_offset 176
	movq	%rbx, %r9	# z1,
	movq	104(%rsp), %r8	# %sfp,
	movq	64(%rsp), %rcx	# %sfp,
	movq	%r12, %rdx	# tmp,
	movq	48(%rsp), %rsi	# %sfp,
	movq	40(%rsp), %rdi	# %sfp,
	call	ffSampling_inner_fft3	#
# candidate/source/falcon-sign.c:1668: 	falcon_poly_merge_deep_fft3(z1, y0, y1, logn);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 144
	movl	%ebp, %ecx	# logn,
	movq	32(%rsp), %rdx	# %sfp,
	movq	%r12, %rsi	# tmp,
	movq	%rbx, %rdi	# z1,
	call	falcon_poly_merge_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:1674: 	memcpy(tmp, z1, n * sizeof *t1);
	movq	%r15, %rdx	# _7,
	movq	%rbx, %rsi	# z1,
	movq	%r12, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1675: 	falcon_poly_mul_fft3(tmp, tree, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# tmp,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1676: 	falcon_poly_add_fft3(tmp, t0, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	40(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# tmp,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:1682: 	x1 = x0 + hn;
	addq	%r14, %r13	# z0, x1
# candidate/source/falcon-sign.c:1683: 	falcon_poly_split_deep_fft3(x0, x1, tmp, logn);
	movl	%ebp, %ecx	# logn,
	movq	%r12, %rdx	# tmp,
	movq	%r13, %rsi	# x1,
	movq	%r14, %rdi	# z0,
	call	falcon_poly_split_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:1684: 	ffSampling_inner_fft3(samp, samp_ctx,
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 152
	pushq	56(%rsp)	# %sfp
	.cfi_def_cfa_offset 160
	movl	44(%rsp), %eax	# %sfp, _8
	pushq	%rax	# _8
	.cfi_def_cfa_offset 168
	pushq	%r13	# x1
	.cfi_def_cfa_offset 176
	movq	%r14, %r9	# z0,
	movq	96(%rsp), %r8	# %sfp,
	movq	64(%rsp), %r13	# %sfp, y1
	movq	%r13, %rcx	# y1,
	movq	%r12, %rdx	# tmp,
	movq	48(%rsp), %rsi	# %sfp,
	movq	40(%rsp), %rdi	# %sfp,
	call	ffSampling_inner_fft3	#
# candidate/source/falcon-sign.c:1686: 	falcon_poly_merge_deep_fft3(z0, y0, y1, logn);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 144
	movl	%ebp, %ecx	# logn,
	movq	%r13, %rdx	# y1,
	movq	%r12, %rsi	# tmp,
	movq	%r14, %rdi	# z0,
	call	falcon_poly_merge_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:1691: 	memcpy(tmp, z1, n * sizeof *z1);
	movq	%r15, %rdx	# _7,
	movq	%rbx, %rsi	# z1,
	movq	%r12, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1692: 	falcon_poly_mul_fft3(tmp, tree, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# tmp,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1693: 	falcon_poly_sub_fft3(z0, tmp, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	%r12, %rsi	# tmp,
	movq	%r14, %rdi	# z0,
	call	falcon_poly_sub3@PLT	#
.L35:
# candidate/source/falcon-sign.c:1694: }
	addq	$88, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
.L39:
	.cfi_restore_state
# candidate/source/falcon-sign.c:1637: 		sigma = tree[0];
	movq	(%r8), %r15	# *tree_20(D), sigma
# candidate/source/falcon-sign.c:1638: 		r1 = *t1;
	movq	(%rdx), %rbp	# *t1_26(D), r1
# candidate/source/falcon-sign.c:1639: 		r0 = *t0;
	movq	(%r9), %r13	# *t0_34(D), r0
# candidate/source/falcon-sign.c:1641: 			samp(samp_ctx, r1, fpr_mul(fpr_IW1I, sigma))));
	movq	%r15, %rsi	# sigma,
	movabsq	$4607879128087016220, %rdi	#, tmp148
	call	fpr_mul@PLT	#
	movq	%rax, %rdx	# tmp186, _1
# candidate/source/falcon-sign.c:1641: 			samp(samp_ctx, r1, fpr_mul(fpr_IW1I, sigma))));
	movq	%rbp, %rsi	# r1,
	movq	16(%rsp), %rdi	# %sfp,
	movq	8(%rsp), %rax	# %sfp, samp
	call	*%rax	# samp
# candidate/source/falcon-sign.c:1640: 		r1 = fpr_sub(r1, fpr_of(
	movslq	%eax, %rdi	# tmp187, _3
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# candidate/source/fpr-emulated.h:156: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r12	#, tmp151
	movq	%rax, %rsi	# tmp188, tmp188
	xorq	%r12, %rsi	# tmp151, tmp188
# candidate/source/fpr-emulated.h:157: 	return fpr_add(x, y);
	movq	%rbp, %rdi	# r1,
	call	fpr_add@PLT	#
# candidate/source/fpr-emulated.h:172: 	x -= (uint64_t)1 << 52;
	movabsq	$-4503599627370496, %rbp	#, tmp152
	movq	%rax, (%rsp)	# _69, %sfp
	addq	%rax, %rbp	# _69, x
# candidate/source/fpr-emulated.h:173: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rbp, %rcx	# x, _60
	shrq	$52, %rcx	#, _60
	movq	%rcx, %rax	# _60, _60
# candidate/source/fpr-emulated.h:173: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %eax	#, _62
# candidate/source/fpr-emulated.h:173: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %eax	#, _63
# candidate/source/fpr-emulated.h:173: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %eax	#, t_64
# candidate/source/fpr-emulated.h:174: 	x &= (uint64_t)t - 1;
	movl	%eax, %eax	# t_64, _65
# candidate/source/fpr-emulated.h:174: 	x &= (uint64_t)t - 1;
	subq	$1, %rax	#, _66
# candidate/source/fpr-emulated.h:174: 	x &= (uint64_t)t - 1;
	andq	%rax, %rbp	# _66, x
# candidate/source/falcon-sign.c:1643: 		r0 = fpr_add(r0, rx);
	movq	%rbp, %rsi	# x,
	movq	%r13, %rdi	# r0,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp190, r0
# candidate/source/falcon-sign.c:1645: 			samp(samp_ctx, r0, sigma)));
	movq	%r15, %rdx	# sigma,
	movq	%rax, %rsi	# r0,
	movq	16(%rsp), %rdi	# %sfp,
	movq	8(%rsp), %rax	# %sfp, samp
	call	*%rax	# samp
# candidate/source/falcon-sign.c:1644: 		r0 = fpr_sub(r0, fpr_of(
	movslq	%eax, %rdi	# tmp191, _5
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# candidate/source/fpr-emulated.h:156: 	y ^= (uint64_t)1 << 63;
	xorq	%r12, %rax	# tmp151, tmp192
	movq	%rax, %rsi	# tmp192, y_56
# candidate/source/fpr-emulated.h:157: 	return fpr_add(x, y);
	movq	%r13, %rdi	# r0,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp193, _57
# candidate/source/fpr-emulated.h:156: 	y ^= (uint64_t)1 << 63;
	movq	%rbp, %rsi	# x, x
	xorq	%r12, %rsi	# tmp151, x
# candidate/source/fpr-emulated.h:157: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
# candidate/source/falcon-sign.c:1647: 		*z0 = r0;
	movq	%rax, (%r14)	# tmp194, *z0_36(D)
# candidate/source/falcon-sign.c:1648: 		*z1 = r1;
	movq	(%rsp), %rdx	# %sfp, _69
	movq	%rdx, (%rbx)	# _69, *z1_23(D)
# candidate/source/falcon-sign.c:1649: 		return;
	jmp	.L35	#
	.cfi_endproc
.LFE59:
	.size	ffSampling_inner_fft3, .-ffSampling_inner_fft3
	.type	ffSampling_depth1_fft3, @function
ffSampling_depth1_fft3:
.LFB60:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$104, %rsp	#,
	.cfi_def_cfa_offset 160
	movq	%rdi, 56(%rsp)	# tmp179, %sfp
	movq	%rsi, 64(%rsp)	# tmp180, %sfp
	movq	%rdx, %r12	# tmp181, z0
	movq	%rcx, 8(%rsp)	# tmp182, %sfp
	movl	184(%rsp), %ebp	# logn, logn
	movq	192(%rsp), %rbx	# tmp, tmp
# candidate/source/falcon-sign.c:1710: 	tree0 = tree + 3 * n;
	movl	$24, %eax	#, tmp130
	movl	%ebp, %ecx	# logn, tmp186
	salq	%cl, %rax	# tmp186, _1
# candidate/source/falcon-sign.c:1710: 	tree0 = tree + 3 * n;
	movq	%r9, 32(%rsp)	# tree, %sfp
	leaq	(%r9,%rax), %r10	#, tree0
# candidate/source/falcon-sign.c:1711: 	tree1 = tree0 + (logn << (logn - 1));
	leal	-1(%rbp), %r11d	#, _2
# candidate/source/falcon-sign.c:1711: 	tree1 = tree0 + (logn << (logn - 1));
	movl	%ebp, %r14d	# logn, _4
	movl	%r11d, 44(%rsp)	# _2, %sfp
	movzbl	44(%rsp), %ecx	# %sfp, tmp191
	sall	%cl, %r14d	# tmp191, _4
# candidate/source/falcon-sign.c:1711: 	tree1 = tree0 + (logn << (logn - 1));
	salq	$3, %r14	#, _5
# candidate/source/falcon-sign.c:1711: 	tree1 = tree0 + (logn << (logn - 1));
	movq	%r10, 80(%rsp)	# tree0, %sfp
	leaq	(%r10,%r14), %r15	#, tree1
# candidate/source/falcon-sign.c:1712: 	tree2 = tree1 + (logn << (logn - 1));
	movq	%r15, 88(%rsp)	# tree1, %sfp
	addq	%r15, %r14	# tree1, tree2
	movq	%r14, 72(%rsp)	# tree2, %sfp
# candidate/source/falcon-sign.c:1707: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp134
	movl	%ebp, %ecx	# logn, tmp196
	salq	%cl, %rax	# tmp196, n_13
# candidate/source/falcon-sign.c:1708: 	hn = n >> 1;
	shrq	%rax	# hn_14
# candidate/source/falcon-sign.c:1714: 	y1 = y0 + hn;
	leaq	0(,%rax,8), %r14	#, _6
# candidate/source/falcon-sign.c:1714: 	y1 = y0 + hn;
	leaq	(%rbx,%r14), %r10	#, y1
	movq	%r10, 24(%rsp)	# y1, %sfp
# candidate/source/falcon-sign.c:1720: 	x1 = x0 + hn;
	leaq	(%r8,%r14), %r15	#, x1
# candidate/source/falcon-sign.c:1721: 	falcon_poly_split_deep_fft3(x0, x1, t2, logn);
	movl	%ebp, %ecx	# logn,
	movq	176(%rsp), %rdx	# t2,
	movq	%r15, %rsi	# x1,
	movq	%r8, 16(%rsp)	# z2, %sfp
	movq	%r8, %rdi	# z2,
	call	falcon_poly_split_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:1723: 		y0, y1, tree2, x0, x1, logn - 1, tmp + n);
	movl	$8, %r13d	#, tmp136
	movl	%ebp, %ecx	# logn, tmp199
	salq	%cl, %r13	# tmp199, _7
# candidate/source/falcon-sign.c:1722: 	ffSampling_inner_fft3(samp, samp_ctx,
	leaq	(%rbx,%r13), %rdx	#, _8
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 168
	movq	%rdx, 56(%rsp)	# _8, %sfp
	pushq	%rdx	#
	.cfi_def_cfa_offset 176
	movl	60(%rsp), %r11d	# %sfp, _2
	pushq	%r11	# _2
	.cfi_def_cfa_offset 184
	pushq	%r15	# x1
	.cfi_def_cfa_offset 192
	movq	48(%rsp), %r15	# %sfp, z2
	movq	%r15, %r9	# z2,
	movq	104(%rsp), %r8	# %sfp,
	movq	56(%rsp), %rcx	# %sfp,
	movq	%rbx, %rdx	# tmp,
	movq	96(%rsp), %rsi	# %sfp,
	movq	88(%rsp), %rdi	# %sfp,
	call	ffSampling_inner_fft3	#
# candidate/source/falcon-sign.c:1724: 	falcon_poly_merge_deep_fft3(z2, y0, y1, logn);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 160
	movl	%ebp, %ecx	# logn,
	movq	24(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# tmp,
	movq	%r15, %rdi	# z2,
	call	falcon_poly_merge_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:1730: 	memcpy(tmp, z2, n * sizeof *z2);
	movq	%r13, %rdx	# _7,
	movq	%r15, 16(%rsp)	# z2, %sfp
	movq	%r15, %rsi	# z2,
	movq	%rbx, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1731: 	falcon_poly_mul_fft3(tmp, tree + 2 * n, logn, 0);
	movl	$16, %eax	#, tmp143
	movl	%ebp, %ecx	# logn, tmp202
	salq	%cl, %rax	# tmp202, _9
	movq	32(%rsp), %r9	# %sfp, tree
	addq	%r9, %rax	# tree, _10
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	%rax, 72(%rsp)	# _10, %sfp
	movq	%rax, %rsi	# _10,
	movq	%rbx, %rdi	# tmp,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1732: 	falcon_poly_add_fft3(tmp, t1, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	168(%rsp), %rsi	# t1,
	movq	%rbx, %rdi	# tmp,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:1738: 	x1 = x0 + hn;
	movq	8(%rsp), %rax	# %sfp, z1
	leaq	(%rax,%r14), %r15	#, x1
# candidate/source/falcon-sign.c:1739: 	falcon_poly_split_deep_fft3(x0, x1, tmp, logn);
	movl	%ebp, %ecx	# logn,
	movq	%rbx, %rdx	# tmp,
	movq	%r15, %rsi	# x1,
	movq	%rax, %rdi	# z1,
	call	falcon_poly_split_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:1740: 	ffSampling_inner_fft3(samp, samp_ctx,
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 168
	pushq	56(%rsp)	# %sfp
	.cfi_def_cfa_offset 176
	movl	60(%rsp), %r11d	# %sfp, _2
	pushq	%r11	# _2
	.cfi_def_cfa_offset 184
	pushq	%r15	# x1
	.cfi_def_cfa_offset 192
	movq	40(%rsp), %r15	# %sfp, z1
	movq	%r15, %r9	# z1,
	movq	120(%rsp), %r8	# %sfp,
	movq	56(%rsp), %rcx	# %sfp,
	movq	%rbx, %rdx	# tmp,
	movq	96(%rsp), %rsi	# %sfp,
	movq	88(%rsp), %rdi	# %sfp,
	call	ffSampling_inner_fft3	#
# candidate/source/falcon-sign.c:1742: 	falcon_poly_merge_deep_fft3(z1, y0, y1, logn);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 160
	movl	%ebp, %ecx	# logn,
	movq	24(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# tmp,
	movq	%r15, 8(%rsp)	# z1, %sfp
	movq	%r15, %rdi	# z1,
	call	falcon_poly_merge_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:1743: 	memcpy(tmp, z2, n * sizeof *z2);
	movq	%r13, %rdx	# _7,
	movq	16(%rsp), %r15	# %sfp, z2
	movq	%r15, %rsi	# z2,
	movq	%rbx, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1744: 	falcon_poly_mul_fft3(tmp, tree + 2 * n, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	72(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# tmp,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1745: 	falcon_poly_sub_fft3(z1, tmp, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	%rbx, %rsi	# tmp,
	movq	8(%rsp), %rdi	# %sfp,
	call	falcon_poly_sub3@PLT	#
# candidate/source/falcon-sign.c:1752: 	memcpy(z0, t0, n * sizeof *t0);
	movq	%r13, %rdx	# _7,
	movq	160(%rsp), %rsi	# t0,
	movq	%r12, %rdi	# z0,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1753: 	memcpy(tmp, z1, n * sizeof *z1);
	movq	%r13, %rdx	# _7,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1754: 	falcon_poly_mul_fft3(tmp, tree, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	32(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# tmp,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1755: 	falcon_poly_add_fft3(z0, tmp, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	%rbx, %rsi	# tmp,
	movq	%r12, %rdi	# z0,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:1756: 	memcpy(tmp, z2, n * sizeof *z1);
	movq	%r13, %rdx	# _7,
	movq	%r15, 16(%rsp)	# z2, %sfp
	movq	%r15, %rsi	# z2,
	movq	%rbx, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1757: 	falcon_poly_mul_fft3(tmp, tree + n, logn, 0);
	movq	32(%rsp), %r9	# %sfp, tree
	leaq	(%r9,%r13), %r15	#, _11
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	%r15, %rsi	# _11,
	movq	%rbx, %rdi	# tmp,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1758: 	falcon_poly_add_fft3(z0, tmp, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	%rbx, %rsi	# tmp,
	movq	%r12, %rdi	# z0,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:1764: 	x1 = x0 + hn;
	addq	%r12, %r14	# z0, x1
# candidate/source/falcon-sign.c:1765: 	memcpy(tmp, z0, n * sizeof *z0);
	movq	%r13, %rdx	# _7,
	movq	%r12, %rsi	# z0,
	movq	%rbx, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1766: 	falcon_poly_split_deep_fft3(x0, x1, tmp, logn);
	movl	%ebp, %ecx	# logn,
	movq	%rbx, %rdx	# tmp,
	movq	%r14, %rsi	# x1,
	movq	%r12, %rdi	# z0,
	call	falcon_poly_split_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:1767: 	ffSampling_inner_fft3(samp, samp_ctx,
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 168
	pushq	56(%rsp)	# %sfp
	.cfi_def_cfa_offset 176
	movl	60(%rsp), %r11d	# %sfp, _2
	pushq	%r11	# _2
	.cfi_def_cfa_offset 184
	pushq	%r14	# x1
	.cfi_def_cfa_offset 192
	movq	%r12, %r9	# z0,
	movq	112(%rsp), %r8	# %sfp,
	movq	56(%rsp), %r14	# %sfp, y1
	movq	%r14, %rcx	# y1,
	movq	%rbx, %rdx	# tmp,
	movq	96(%rsp), %rsi	# %sfp,
	movq	88(%rsp), %rdi	# %sfp,
	call	ffSampling_inner_fft3	#
# candidate/source/falcon-sign.c:1769: 	falcon_poly_merge_deep_fft3(z0, y0, y1, logn);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 160
	movl	%ebp, %ecx	# logn,
	movq	%r14, %rdx	# y1,
	movq	%rbx, %rsi	# tmp,
	movq	%r12, %rdi	# z0,
	call	falcon_poly_merge_deep_fft3@PLT	#
# candidate/source/falcon-sign.c:1774: 	memcpy(tmp, z1, n * sizeof *z1);
	movq	%r13, %rdx	# _7,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1775: 	falcon_poly_mul_fft3(tmp, tree, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	32(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# tmp,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1776: 	falcon_poly_sub_fft3(z0, tmp, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	%rbx, %rsi	# tmp,
	movq	%r12, %rdi	# z0,
	call	falcon_poly_sub3@PLT	#
# candidate/source/falcon-sign.c:1777: 	memcpy(tmp, z2, n * sizeof *z1);
	movq	%r13, %rdx	# _7,
	movq	16(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1778: 	falcon_poly_mul_fft3(tmp, tree + n, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	%r15, %rsi	# _11,
	movq	%rbx, %rdi	# tmp,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1779: 	falcon_poly_sub_fft3(z0, tmp, logn, 0);
	movl	$0, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	%rbx, %rsi	# tmp,
	movq	%r12, %rdi	# z0,
	call	falcon_poly_sub3@PLT	#
# candidate/source/falcon-sign.c:1780: }
	addq	$104, %rsp	#,
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE60:
	.size	ffSampling_depth1_fft3, .-ffSampling_depth1_fft3
	.type	ffSampling_fft, @function
ffSampling_fft:
.LFB58:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp	#,
	.cfi_def_cfa_offset 144
	movq	%rdi, 8(%rsp)	# samp, %sfp
	movq	%rsi, 16(%rsp)	# samp_ctx, %sfp
	movq	%rdx, %r15	# tmp148, z0
	movq	%rcx, %r13	# tmp149, z1
	movq	%r8, %r14	# tmp150, tree
	movq	%r9, 48(%rsp)	# t0, %sfp
	movl	152(%rsp), %ebx	# logn, logn
	movq	160(%rsp), %r12	# tmp, tmp
# candidate/source/falcon-sign.c:1574: 	if (n == 1) {
	testl	%ebx, %ebx	# logn
	jne	.L43	#,
	movq	%rdi, %rax	# tmp146, samp
	movq	%rsi, %rdi	# tmp147, samp_ctx
# candidate/source/falcon-sign.c:1578: 		x1 = t1[0];
	movq	144(%rsp), %rbx	# t1, tmp157
	movq	(%rbx), %rbx	# *t1_25(D), x1
# candidate/source/falcon-sign.c:1579: 		sigma = tree[0];
	movq	(%r8), %rbp	# *tree_19(D), sigma
# candidate/source/falcon-sign.c:1580: 		z0[0] = fpr_of(samp(samp_ctx, x0, sigma));
	movq	(%r9), %rsi	# *t0_35(D), *t0_35(D)
	movq	%rbp, %rdx	# sigma,
	movq	%rdi, %r12	# samp_ctx, samp_ctx
	movq	%rax, %r14	# samp, samp
	call	*%rax	# samp
# candidate/source/falcon-sign.c:1580: 		z0[0] = fpr_of(samp(samp_ctx, x0, sigma));
	movslq	%eax, %rdi	# tmp152, _2
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# candidate/source/falcon-sign.c:1580: 		z0[0] = fpr_of(samp(samp_ctx, x0, sigma));
	movq	%rax, (%r15)	# tmp153, *z0_37(D)
# candidate/source/falcon-sign.c:1581: 		z1[0] = fpr_of(samp(samp_ctx, x1, sigma));
	movq	%rbp, %rdx	# sigma,
	movq	%rbx, %rsi	# x1,
	movq	%r12, %rdi	# samp_ctx,
	call	*%r14	# samp
# candidate/source/falcon-sign.c:1581: 		z1[0] = fpr_of(samp(samp_ctx, x1, sigma));
	movslq	%eax, %rdi	# tmp154, _4
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# candidate/source/falcon-sign.c:1581: 		z1[0] = fpr_of(samp(samp_ctx, x1, sigma));
	movq	%rax, 0(%r13)	# tmp155, *z1_24(D)
.L42:
# candidate/source/falcon-sign.c:1614: }
	addq	$88, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
.L43:
	.cfi_restore_state
# candidate/source/falcon-sign.c:1573: 	n = (size_t)1 << logn;
	movl	$1, %ebp	#, tmp134
	movl	%ebx, %ecx	# logn, tmp161
	salq	%cl, %rbp	# tmp161, n
# candidate/source/falcon-sign.c:1586: 	tree0 = tree + n;
	movl	$8, %eax	#, tmp135
	salq	%cl, %rax	# tmp163, tmp135
# candidate/source/falcon-sign.c:1586: 	tree0 = tree + n;
	movq	%rax, 24(%rsp)	# _5, %sfp
	leaq	(%r8,%rax), %rdx	#, tree0
	movq	%rdx, 64(%rsp)	# tree0, %sfp
# candidate/source/falcon-sign.c:1587: 	tree1 = tree + n + ffLDL_treesize(logn - 1);
	leal	-1(%rbx), %edx	#, _6
# candidate/source/falcon-sign.c:1587: 	tree1 = tree + n + ffLDL_treesize(logn - 1);
	movl	%ebx, %esi	# logn, _7
	movl	%edx, 36(%rsp)	# _6, %sfp
	movzbl	36(%rsp), %ecx	# %sfp, tmp168
	sall	%cl, %esi	# tmp168, _7
	movq	%rsi, %rax	# _7, _7
	addq	%rbp, %rax	# n, _8
# candidate/source/falcon-sign.c:1587: 	tree1 = tree + n + ffLDL_treesize(logn - 1);
	leaq	(%r8,%rax,8), %rcx	#, tree1
	movq	%rcx, 72(%rsp)	# tree1, %sfp
# candidate/source/falcon-sign.c:1585: 	hn = n >> 1;
	shrq	%rbp	# hn_18
# candidate/source/falcon-sign.c:1594: 	falcon_poly_split_fft(z1, z1 + hn, t1, logn);
	salq	$3, %rbp	#, _10
# candidate/source/falcon-sign.c:1594: 	falcon_poly_split_fft(z1, z1 + hn, t1, logn);
	leaq	0(%r13,%rbp), %rcx	#, _11
	movq	%rcx, %rsi	# _11, _11
	movl	%ebx, %ecx	# logn,
	movq	144(%rsp), %rdx	# t1,
	movq	%rsi, 40(%rsp)	# _11, %sfp
	movq	%r13, %rdi	# z1,
	call	falcon_poly_split_fft@PLT	#
# candidate/source/falcon-sign.c:1595: 	ffSampling_fft(samp, samp_ctx, tmp, tmp + hn,
	movq	24(%rsp), %rax	# %sfp, _5
	leaq	(%r12,%rax), %r10	#, _12
	leaq	(%r12,%rbp), %rcx	#, _13
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 152
	movq	%r10, 64(%rsp)	# _12, %sfp
	pushq	%r10	#
	.cfi_def_cfa_offset 160
	movl	52(%rsp), %edi	# %sfp, _6
	pushq	%rdi	# _6
	.cfi_def_cfa_offset 168
	pushq	64(%rsp)	# %sfp
	.cfi_def_cfa_offset 176
	movq	%r13, %r9	# z1,
	movq	104(%rsp), %r8	# %sfp,
	movq	%rcx, 72(%rsp)	# _13, %sfp
	movq	%r12, %rdx	# tmp,
	movq	48(%rsp), %rsi	# %sfp,
	movq	40(%rsp), %rdi	# %sfp,
	call	ffSampling_fft	#
# candidate/source/falcon-sign.c:1597: 	falcon_poly_merge_fft(z1, tmp, tmp + hn, logn);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 144
	movl	%ebx, %ecx	# logn,
	movq	40(%rsp), %rdx	# %sfp,
	movq	%r12, %rsi	# tmp,
	movq	%r13, %rdi	# z1,
	call	falcon_poly_merge_fft@PLT	#
# candidate/source/falcon-sign.c:1602: 	memcpy(tmp, t1, n * sizeof *t1);
	movq	24(%rsp), %rdx	# %sfp,
	movq	144(%rsp), %rsi	# t1,
	movq	%r12, %rdi	# tmp,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1603: 	falcon_poly_sub_fft(tmp, z1, logn);
	movl	%ebx, %edx	# logn,
	movq	%r13, %rsi	# z1,
	movq	%r12, %rdi	# tmp,
	call	falcon_poly_sub@PLT	#
# candidate/source/falcon-sign.c:1604: 	falcon_poly_mul_fft(tmp, tree, logn);
	movl	%ebx, %edx	# logn,
	movq	%r14, %rsi	# tree,
	movq	%r12, %rdi	# tmp,
	call	falcon_poly_mul_fft@PLT	#
# candidate/source/falcon-sign.c:1605: 	falcon_poly_add_fft(tmp, t0, logn);
	movl	%ebx, %edx	# logn,
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# tmp,
	call	falcon_poly_add@PLT	#
# candidate/source/falcon-sign.c:1610: 	falcon_poly_split_fft(z0, z0 + hn, tmp, logn);
	addq	%r15, %rbp	# z0, _14
	movl	%ebx, %ecx	# logn,
	movq	%r12, %rdx	# tmp,
	movq	%rbp, %rsi	# _14,
	movq	%r15, %rdi	# z0,
	call	falcon_poly_split_fft@PLT	#
# candidate/source/falcon-sign.c:1611: 	ffSampling_fft(samp, samp_ctx, tmp, tmp + hn,
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 152
	pushq	64(%rsp)	# %sfp
	.cfi_def_cfa_offset 160
	movl	52(%rsp), %eax	# %sfp, _6
	pushq	%rax	# _6
	.cfi_def_cfa_offset 168
	pushq	%rbp	# _14
	.cfi_def_cfa_offset 176
	movq	%r15, %r9	# z0,
	movq	96(%rsp), %r8	# %sfp,
	movq	72(%rsp), %r14	# %sfp, _13
	movq	%r14, %rcx	# _13,
	movq	%r12, %rdx	# tmp,
	movq	48(%rsp), %rsi	# %sfp,
	movq	40(%rsp), %rdi	# %sfp,
	call	ffSampling_fft	#
# candidate/source/falcon-sign.c:1613: 	falcon_poly_merge_fft(z0, tmp, tmp + hn, logn);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 144
	movl	%ebx, %ecx	# logn,
	movq	%r14, %rdx	# _13,
	movq	%r12, %rsi	# tmp,
	movq	%r15, %rdi	# z0,
	call	falcon_poly_merge_fft@PLT	#
	jmp	.L42	#
	.cfi_endproc
.LFE58:
	.size	ffSampling_fft, .-ffSampling_fft
	.type	BerExp, @function
BerExp:
.LFB66:
	.cfi_startproc
	pushq	%r13	#
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12	#
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp	#
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx	#
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx	# tmp301, p
	movq	%rsi, %rbp	# tmp302, x
# candidate/source/falcon-sign.c:2481: 	s = fpr_floor(fpr_mul(x, fpr_inv_ln2));
	movabsq	$4609176140021203710, %rsi	#, tmp223
	movq	%rbp, %rdi	# x,
	call	fpr_mul@PLT	#
# candidate/source/fpr-emulated.h:124: 	e = (int)(x >> 52) & 0x7FF;
	movq	%rax, %rdx	# _1, _75
	shrq	$52, %rdx	#, _75
# candidate/source/fpr-emulated.h:124: 	e = (int)(x >> 52) & 0x7FF;
	andl	$2047, %edx	#, e
	movq	%rax, %rdi	# _1, _84
	sarq	$63, %rdi	#, _84
# candidate/source/fpr-emulated.h:126: 	xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
	movq	%rax, %rcx	# _1, _79
	salq	$10, %rcx	#, _79
# candidate/source/fpr-emulated.h:126: 	xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
	btrq	$63, %rcx	#, _80
	btsq	$62, %rcx	#, _81
# candidate/source/fpr-emulated.h:128: 	xi = (xi ^ -(int64_t)t) + (int64_t)t;
	xorq	%rdi, %rcx	# _84, _85
# candidate/source/fpr-emulated.h:125: 	t = x >> 63;
	shrq	$63, %rax	#, t_78
# candidate/source/fpr-emulated.h:128: 	xi = (xi ^ -(int64_t)t) + (int64_t)t;
	leaq	(%rax,%rcx), %rsi	#, xi
# candidate/source/fpr-emulated.h:129: 	cc = 1085 - e;
	movl	$1085, %ecx	#, tmp231
	subl	%edx, %ecx	# e, cc
# candidate/source/fpr-emulated.h:132: 	mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
	subl	$1022, %edx	#, _99
# candidate/source/fpr-emulated.h:132: 	mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
	shrl	$31, %edx	#, _101
# candidate/source/fpr-emulated.h:132: 	mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
	movl	%edx, %eax	# _101, _102
# candidate/source/fpr-emulated.h:28: 	x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
	movq	%rsi, %r12	# xi, _90
	sarq	$32, %r12	#, _90
# candidate/source/fpr-emulated.h:28: 	x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
	testb	$32, %cl	#, cc
	cmove	%rsi, %r12	# _90,, xi, x_96
# candidate/source/fpr-emulated.h:29: 	return x >> (n & 31);
	andl	$31, %ecx	#, _97
# candidate/source/fpr-emulated.h:29: 	return x >> (n & 31);
	sarq	%cl, %r12	# _97, _98
# candidate/source/fpr-emulated.h:133: 	xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
	leaq	-1(%rax), %rdx	#, _104
	andq	%rdx, %r12	# _104, _106
# candidate/source/fpr-emulated.h:133: 	xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
	negq	%rax	# tmp242
	andq	%rax, %rdi	# tmp242, _108
# candidate/source/fpr-emulated.h:133: 	xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
	orq	%rdi, %r12	# _108, _109
# candidate/source/falcon-sign.c:2482: 	r = fpr_sub(x, fpr_mul(fpr_of(s), fpr_log2));
	movslq	%r12d, %rdi	# _109, _3
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp304, _41
# candidate/source/falcon-sign.c:2482: 	r = fpr_sub(x, fpr_mul(fpr_of(s), fpr_log2));
	movabsq	$4604418534313441775, %rsi	#, tmp245
	call	fpr_mul@PLT	#
# candidate/source/fpr-emulated.h:156: 	y ^= (uint64_t)1 << 63;
	btcq	$63, %rax	#, tmp305
	movq	%rax, %rsi	# tmp305, y_21
# candidate/source/fpr-emulated.h:157: 	return fpr_add(x, y);
	movq	%rbp, %rdi	# x,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp306, _40
# candidate/source/falcon-sign.c:2452: 	*over = (63U - sw) >> 31;
	movl	$63, %eax	#, tmp248
	subl	%r12d, %eax	# _109, _67
# candidate/source/falcon-sign.c:2452: 	*over = (63U - sw) >> 31;
	movl	%eax, %ebp	# _67, _68
	shrl	$31, %ebp	#, _68
# candidate/source/falcon-sign.c:2453: 	*safe_s = sw ^ ((sw ^ 63U) & (0U - *over));
	movl	%r12d, %edx	# _109, _69
	xorl	$63, %edx	#, _69
# candidate/source/falcon-sign.c:2453: 	*safe_s = sw ^ ((sw ^ 63U) & (0U - *over));
	sarl	$31, %eax	#, _71
# candidate/source/falcon-sign.c:2453: 	*safe_s = sw ^ ((sw ^ 63U) & (0U - *over));
	andl	%edx, %eax	# _69, _73
# candidate/source/falcon-sign.c:2453: 	*safe_s = sw ^ ((sw ^ 63U) & (0U - *over));
	xorl	%eax, %r12d	# _73, _74
# candidate/source/internal.h:824: 	u = p->ptr;
	movq	4096(%rbx), %rax	# p_26(D)->ptr, u
# candidate/source/internal.h:825: 	if (u >= (sizeof p->buf.d) - 9) {
	cmpq	$4086, %rax	#, u
	ja	.L52	#,
.L47:
# candidate/source/internal.h:829: 	p->ptr = u + 8;
	leaq	8(%rax), %rdx	#, tmp252
	movq	%rdx, 4096(%rbx)	# tmp252, p_26(D)->ptr
# candidate/source/internal.h:838: 		memcpy(&x, p->buf.d + u, sizeof x);
	movq	(%rbx,%rax), %rdx	# MEM <unsigned long> [(char * {ref-all})_65], _66
# candidate/source/falcon-sign.c:2499: 	w ^= (w >> safe_s) << safe_s;
	movq	%rdx, %rax	# _66, _6
	movl	%r12d, %ecx	# _74, tmp317
	shrq	%cl, %rax	# tmp317, _6
# candidate/source/falcon-sign.c:2499: 	w ^= (w >> safe_s) << safe_s;
	salq	%cl, %rax	# tmp318, _7
# candidate/source/falcon-sign.c:2499: 	w ^= (w >> safe_s) << safe_s;
	xorq	%rdx, %rax	# _66, w
# candidate/source/falcon-sign.c:2500: 	b = 1 - (int)((w | -w) >> 63);
	movq	%rax, %rdx	# w, _8
	negq	%rdx	# _8
# candidate/source/falcon-sign.c:2500: 	b = 1 - (int)((w | -w) >> 63);
	orq	%rax, %rdx	# w, _9
# candidate/source/falcon-sign.c:2500: 	b = 1 - (int)((w | -w) >> 63);
	shrq	$63, %rdx	#, _10
# candidate/source/falcon-sign.c:2500: 	b = 1 - (int)((w | -w) >> 63);
	xorl	$1, %edx	#, b
# candidate/source/falcon-sign.c:2501: 	b &= 1 ^ (int)over;
	xorl	$1, %ebp	#, _44
# candidate/source/falcon-sign.c:2501: 	b &= 1 ^ (int)over;
	andl	%edx, %ebp	# b, b
# candidate/source/fpr-emulated.h:279: 	z = (uint64_t)fpr_trunc(fpr_mul(r, fpr_p63)) << 1;
	movabsq	$4890909195324358656, %rsi	#, tmp259
	movq	%r13, %rdi	# _40,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp307, _51
# candidate/source/fpr-emulated.h:143: 	e = (int)(x >> 52) & 0x7FF;
	movq	%rax, %rdi	# _51, _111
	shrq	$52, %rdi	#, _111
# candidate/source/fpr-emulated.h:143: 	e = (int)(x >> 52) & 0x7FF;
	andl	$2047, %edi	#, e
# candidate/source/fpr-emulated.h:144: 	xu = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	salq	$10, %rax	#, _114
# candidate/source/fpr-emulated.h:144: 	xu = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rdx	#, tmp263
	andq	%rdx, %rax	# tmp263, _115
# candidate/source/fpr-emulated.h:144: 	xu = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	btsq	$62, %rax	#, xu
# candidate/source/fpr-emulated.h:145: 	cc = 1085 - e;
	movl	$1085, %ecx	#, tmp265
	subl	%edi, %ecx	# e, cc
# candidate/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdx	# xu, _119
	shrq	$32, %rdx	#, _119
# candidate/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, cc
	cmovne	%rdx, %rax	# _119,, x_125
# candidate/source/fpr-emulated.h:22: 	return x >> (n & 31);
	andl	$31, %ecx	#, _126
# candidate/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rax	# _126, x_125
	movq	%rax, %rdx	# x_125, _127
# candidate/source/fpr-emulated.h:147: 	xu &= -(uint64_t)((uint32_t)(cc - 64) >> 31);
	movl	$1021, %eax	#, tmp272
	subl	%edi, %eax	# e, _128
# candidate/source/fpr-emulated.h:147: 	xu &= -(uint64_t)((uint32_t)(cc - 64) >> 31);
	shrl	$31, %eax	#, _130
# candidate/source/fpr-emulated.h:147: 	xu &= -(uint64_t)((uint32_t)(cc - 64) >> 31);
	movl	%eax, %eax	# _130, _131
# candidate/source/fpr-emulated.h:147: 	xu &= -(uint64_t)((uint32_t)(cc - 64) >> 31);
	negq	%rax	# tmp275
	andq	%rdx, %rax	# _127, xu_132
# candidate/source/fpr-emulated.h:149: 	xu = (xu ^ -t) + t;
	movq	%rsi, %rdx	# _51, _135
	sarq	$63, %rdx	#, _135
# candidate/source/fpr-emulated.h:149: 	xu = (xu ^ -t) + t;
	xorq	%rdx, %rax	# _135, _137
# candidate/source/fpr-emulated.h:148: 	t = x >> 63;
	shrq	$63, %rsi	#, t_133
# candidate/source/fpr-emulated.h:149: 	xu = (xu ^ -t) + t;
	addq	%rax, %rsi	# _137, xu_138
# candidate/source/fpr-emulated.h:279: 	z = (uint64_t)fpr_trunc(fpr_mul(r, fpr_p63)) << 1;
	addq	%rsi, %rsi	# z
# candidate/source/fpr-emulated.h:260: 	x1 = (uint32_t)(x >> 32);
	movq	%rsi, %rdi	# z, _140
	shrq	$32, %rdi	#, _140
	leaq	8+fpr_expm_p63_coefficients(%rip), %rcx	#, ivtmp.146
	leaq	96(%rcx), %r8	#, _158
# candidate/source/fpr-emulated.h:278: 	y = fpr_expm_p63_coefficients[0];
	movabsq	$19127174051, %rdx	#, y
	movl	%esi, %esi	# z, _142
.L48:
# candidate/source/fpr-emulated.h:262: 	y1 = (uint32_t)(y >> 32);
	movq	%rdx, %r10	# y, _141
	shrq	$32, %r10	#, _141
	movl	%edx, %edx	# y, _144
# candidate/source/fpr-emulated.h:264: 		+ (((uint64_t)x0 * (uint64_t)y0) >> 32);
	movq	%rsi, %rax	# _142, _145
	imulq	%rdx, %rax	# _144, _145
# candidate/source/fpr-emulated.h:264: 		+ (((uint64_t)x0 * (uint64_t)y0) >> 32);
	shrq	$32, %rax	#, _146
# candidate/source/fpr-emulated.h:263: 	a = (uint64_t)x0 * (uint64_t)y1
	movq	%r10, %r9	# _141, _143
	imulq	%rsi, %r9	# _142, _143
# candidate/source/fpr-emulated.h:263: 	a = (uint64_t)x0 * (uint64_t)y1
	addq	%r9, %rax	# _143, a
# candidate/source/fpr-emulated.h:265: 	b = (uint64_t)x1 * (uint64_t)y0;
	imulq	%rdi, %rdx	# _140, _144
	movq	%rdx, %r9	# _144, b
# candidate/source/fpr-emulated.h:268: 	c += (uint64_t)x1 * (uint64_t)y1;
	imulq	%rdi, %r10	# _140, _157
# candidate/source/fpr-emulated.h:281: 		y = fpr_expm_p63_coefficients[u] - fpr_mul_high_u64(z, y);
	movq	(%rcx), %rdx	# MEM[(long unsigned int *)_156], _124
	subq	%r10, %rdx	# _157, _124
# candidate/source/fpr-emulated.h:266: 	c = (a >> 32) + (b >> 32);
	movq	%r9, %r10	# b, _150
	shrq	$32, %r10	#, _150
# candidate/source/fpr-emulated.h:281: 		y = fpr_expm_p63_coefficients[u] - fpr_mul_high_u64(z, y);
	subq	%r10, %rdx	# _150, _123
# candidate/source/fpr-emulated.h:266: 	c = (a >> 32) + (b >> 32);
	movq	%rax, %r10	# a, _149
	shrq	$32, %r10	#, _149
# candidate/source/fpr-emulated.h:281: 		y = fpr_expm_p63_coefficients[u] - fpr_mul_high_u64(z, y);
	subq	%r10, %rdx	# _149, _118
# candidate/source/fpr-emulated.h:267: 	c += ((uint64_t)(uint32_t)a + (uint64_t)(uint32_t)b) >> 32;
	movl	%eax, %eax	# a, _152
	movl	%r9d, %r9d	# b, _153
	addq	%r9, %rax	# _153, _154
# candidate/source/fpr-emulated.h:267: 	c += ((uint64_t)(uint32_t)a + (uint64_t)(uint32_t)b) >> 32;
	shrq	$32, %rax	#, _155
# candidate/source/fpr-emulated.h:281: 		y = fpr_expm_p63_coefficients[u] - fpr_mul_high_u64(z, y);
	subq	%rax, %rdx	# _155, y
# candidate/source/fpr-emulated.h:280: 	for (u = 1; u < 13; u ++) {
	addq	$8, %rcx	#, ivtmp.146
	cmpq	%r8, %rcx	# _158, ivtmp.146
	jne	.L48	#,
# candidate/source/falcon-sign.c:2507: 	z = fpr_expm_scaled(r) >> 8;
	shrq	$8, %rdx	#, y
	movq	%rdx, %r12	# y, z
# candidate/source/internal.h:824: 	u = p->ptr;
	movq	4096(%rbx), %rdx	# p_26(D)->ptr, u
# candidate/source/internal.h:825: 	if (u >= (sizeof p->buf.d) - 9) {
	cmpq	$4086, %rdx	#, u
	ja	.L53	#,
.L49:
# candidate/source/internal.h:829: 	p->ptr = u + 8;
	leaq	8(%rdx), %rax	#, tmp295
	movq	%rax, 4096(%rbx)	# tmp295, p_26(D)->ptr
# candidate/source/falcon-sign.c:2509: 	w &= ((uint64_t)1 << 55) - 1;
	movabsq	$36028797018963967, %rax	#, tmp298
	andq	(%rbx,%rdx), %rax	# MEM <unsigned long> [(char * {ref-all})_49], w_36
# candidate/source/falcon-sign.c:2510: 	b &= (int)((w - z) >> 63);
	subq	%r12, %rax	# z, _15
# candidate/source/falcon-sign.c:2510: 	b &= (int)((w - z) >> 63);
	shrq	$63, %rax	#, _16
# candidate/source/falcon-sign.c:2510: 	b &= (int)((w - z) >> 63);
	andl	%ebp, %eax	# b, b_37
# candidate/source/falcon-sign.c:2513: }
	addq	$8, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx	#
	.cfi_def_cfa_offset 32
	popq	%rbp	#
	.cfi_def_cfa_offset 24
	popq	%r12	#
	.cfi_def_cfa_offset 16
	popq	%r13	#
	.cfi_def_cfa_offset 8
	ret	
.L52:
	.cfi_restore_state
# candidate/source/internal.h:826: 		falcon_prng_refill(p);
	movq	%rbx, %rdi	# p,
	call	falcon_prng_refill@PLT	#
# candidate/source/internal.h:827: 		u = 0;
	movl	$0, %eax	#, u
	jmp	.L47	#
.L53:
# candidate/source/internal.h:826: 		falcon_prng_refill(p);
	movq	%rbx, %rdi	# p,
	call	falcon_prng_refill@PLT	#
# candidate/source/internal.h:827: 		u = 0;
	movl	$0, %edx	#, u
	jmp	.L49	#
	.cfi_endproc
.LFE66:
	.size	BerExp, .-BerExp
	.type	sampler, @function
sampler:
.LFB67:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$56, %rsp	#,
	.cfi_def_cfa_offset 112
	movq	%rdi, %r14	# tmp312, ctx
	movq	%rsi, %rbx	# tmp313, mu
	movq	%rdx, %rbp	# tmp314, sigma
# candidate/source/fpr-emulated.h:124: 	e = (int)(x >> 52) & 0x7FF;
	movq	%rsi, %rax	# mu, _54
	shrq	$52, %rax	#, _54
# candidate/source/fpr-emulated.h:124: 	e = (int)(x >> 52) & 0x7FF;
	andl	$2047, %eax	#, e
	sarq	$63, %rsi	#, _63
# candidate/source/fpr-emulated.h:126: 	xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
	movq	%rbx, %rdx	# mu, _58
	salq	$10, %rdx	#, _58
# candidate/source/fpr-emulated.h:126: 	xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
	btrq	$63, %rdx	#, _59
	btsq	$62, %rdx	#, _60
# candidate/source/fpr-emulated.h:128: 	xi = (xi ^ -(int64_t)t) + (int64_t)t;
	xorq	%rsi, %rdx	# _63, _64
# candidate/source/fpr-emulated.h:125: 	t = x >> 63;
	movq	%rbx, %rdi	# mu, t_57
	shrq	$63, %rdi	#, t_57
# candidate/source/fpr-emulated.h:128: 	xi = (xi ^ -(int64_t)t) + (int64_t)t;
	addq	%rdx, %rdi	# _64, xi
# candidate/source/fpr-emulated.h:129: 	cc = 1085 - e;
	movl	$1085, %ecx	#, tmp242
	subl	%eax, %ecx	# e, cc
# candidate/source/fpr-emulated.h:132: 	mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
	subl	$1022, %eax	#, _78
# candidate/source/fpr-emulated.h:132: 	mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
	shrl	$31, %eax	#, _80
# candidate/source/fpr-emulated.h:132: 	mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
	movl	%eax, %eax	# _80, _81
# candidate/source/fpr-emulated.h:28: 	x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
	movq	%rdi, %rdx	# xi, _69
	sarq	$32, %rdx	#, _69
# candidate/source/fpr-emulated.h:28: 	x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
	testb	$32, %cl	#, cc
	cmove	%rdi, %rdx	# _69,, xi, x_75
# candidate/source/fpr-emulated.h:29: 	return x >> (n & 31);
	andl	$31, %ecx	#, _76
# candidate/source/fpr-emulated.h:29: 	return x >> (n & 31);
	sarq	%cl, %rdx	# _76, _77
# candidate/source/fpr-emulated.h:133: 	xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
	leaq	-1(%rax), %rcx	#, _83
	andq	%rcx, %rdx	# _83, _85
# candidate/source/fpr-emulated.h:133: 	xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
	negq	%rax	# tmp253
	andq	%rax, %rsi	# tmp253, _87
# candidate/source/fpr-emulated.h:133: 	xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
	orq	%rsi, %rdx	# _87, _85
	movq	%rdx, %r13	# _85, _88
# candidate/source/falcon-sign.c:2543: 	r = fpr_sub(mu, fpr_of(s));
	movslq	%edx, %rdi	# _88, _2
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# candidate/source/fpr-emulated.h:156: 	y ^= (uint64_t)1 << 63;
	btcq	$63, %rax	#, tmp315
	movq	%rax, %rsi	# tmp315, y_33
# candidate/source/fpr-emulated.h:157: 	return fpr_add(x, y);
	movq	%rbx, %rdi	# mu,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp316, _34
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$2, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %r12	# tmp317, _32
# candidate/source/fpr-emulated.h:188: 	return fpr_mul(x, x);
	movq	%rbp, %rsi	# sigma,
	movq	%rbp, %rdi	# sigma,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp318, _31
# candidate/source/falcon-sign.c:2548: 	dss = fpr_inv(fpr_mul(fpr_sqr(sigma), fpr_of(2)));
	movq	%r12, %rsi	# _32,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp319, _3
# candidate/source/fpr-emulated.h:194: 	return fpr_div(fpr_one, x);
	movabsq	$4607182418800017408, %rdi	#, tmp259
	call	fpr_div@PLT	#
	movq	%rax, 24(%rsp)	# tmp320, %sfp
	leaq	352+CDF0(%rip), %r15	#, _68
# candidate/source/fpr-emulated.h:156: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rax	#, y_40
	xorq	%rbx, %rax	# _34, y_40
	movq	%rax, 32(%rsp)	# y_40, %sfp
	movq	%r13, 40(%rsp)	# _88, %sfp
	jmp	.L60	#
.L66:
# candidate/source/internal.h:863: 		falcon_prng_refill(p);
	movq	%r14, %rdi	# ctx,
	call	falcon_prng_refill@PLT	#
	jmp	.L55	#
.L67:
# candidate/source/internal.h:826: 		falcon_prng_refill(p);
	movq	%r14, %rdi	# ctx,
	call	falcon_prng_refill@PLT	#
# candidate/source/internal.h:838: 		memcpy(&x, p->buf.d + u, sizeof x);
	movq	%r14, %r12	# ctx, _175
# candidate/source/internal.h:838: 		memcpy(&x, p->buf.d + u, sizeof x);
	movq	(%r14), %rbx	# MEM <unsigned long> [(char * {ref-all})ctx_14(D)], _177
# candidate/source/internal.h:824: 	u = p->ptr;
	movl	$8, %ebp	#, u
.L57:
# candidate/source/internal.h:829: 	p->ptr = u + 8;
	leaq	8(%rbp), %rcx	#, _168
# candidate/source/internal.h:829: 	p->ptr = u + 8;
	movq	%rcx, 4096(%r14)	# _168, MEM[(struct prng *)ctx_14(D)].ptr
# candidate/source/internal.h:838: 		memcpy(&x, p->buf.d + u, sizeof x);
	movq	(%r12,%rbp), %r10	# MEM <unsigned long> [(char * {ref-all})_170], _171
	leaq	CDFs(%rip), %r11	#, ivtmp.169
	movl	$0, %r8d	#, ivtmp.163
# candidate/source/falcon-sign.c:2299: 	result = 0;
	movl	$0, %edx	#, result
# candidate/source/falcon-sign.c:2300: 	not_found = 1;
	movl	$1, %eax	#, not_found
# candidate/source/falcon-sign.c:2306: 		d = (uint64_t)msb - (uint64_t)CDF8[z];
	movzbl	%r13b, %r12d	# _180, _98
	movq	%rbp, 8(%rsp)	# u, %sfp
	movq	%rcx, 16(%rsp)	# _168, %sfp
.L58:
# candidate/source/falcon-sign.c:2306: 		d = (uint64_t)msb - (uint64_t)CDF8[z];
	leaq	CDF8(%rip), %rcx	#, tmp363
	movzbl	(%rcx,%r8), %ebp	# MEM[(unsigned char *)&CDF8 + ivtmp.163_4 * 1], _101
# candidate/source/falcon-sign.c:2307: 		msb_gt = ((uint64_t)CDF8[z] - (uint64_t)msb) >> 63;
	movq	%rbp, %r9	# _101, _103
	subq	%r12, %r9	# _98, _103
# candidate/source/falcon-sign.c:2310: 		d = hi - CDFs[z].hi;
	movq	(%r11), %rsi	# MEM[(long unsigned int *)_1], _108
# candidate/source/falcon-sign.c:2311: 		hi_gt = (CDFs[z].hi - hi) >> 63;
	movq	%rsi, %rcx	# _108, _110
	subq	%rbx, %rcx	# _177, _110
# candidate/source/falcon-sign.c:2310: 		d = hi - CDFs[z].hi;
	movq	%rbx, %rdi	# _177, d_109
	subq	%rsi, %rdi	# _108, d_109
# candidate/source/falcon-sign.c:2312: 		hi_eq = ~(d | (0 - d)) >> 63;
	orq	%rcx, %rdi	# _110, _112
# candidate/source/falcon-sign.c:2312: 		hi_eq = ~(d | (0 - d)) >> 63;
	notq	%rdi	# _113
# candidate/source/falcon-sign.c:2312: 		hi_eq = ~(d | (0 - d)) >> 63;
	shrq	$63, %rdi	#, hi_eq_114
# candidate/source/falcon-sign.c:2313: 		lo_ge = ~((lo - CDFs[z].lo) >> 63);
	movq	%r10, %rsi	# _171, _116
	subq	8(%r11), %rsi	# MEM[(long unsigned int *)_1 + 8B], _116
# candidate/source/falcon-sign.c:2313: 		lo_ge = ~((lo - CDFs[z].lo) >> 63);
	shrq	$63, %rsi	#, _117
# candidate/source/falcon-sign.c:2313: 		lo_ge = ~((lo - CDFs[z].lo) >> 63);
	notq	%rsi	# lo_ge_118
# candidate/source/falcon-sign.c:2315: 		ge = msb_gt | (msb_eq & (hi_gt | (hi_eq & lo_ge)));
	andq	%rdi, %rsi	# hi_eq_114, _119
# candidate/source/falcon-sign.c:2311: 		hi_gt = (CDFs[z].hi - hi) >> 63;
	shrq	$63, %rcx	#, hi_gt_111
# candidate/source/falcon-sign.c:2315: 		ge = msb_gt | (msb_eq & (hi_gt | (hi_eq & lo_ge)));
	orq	%rsi, %rcx	# _119, _120
# candidate/source/falcon-sign.c:2306: 		d = (uint64_t)msb - (uint64_t)CDF8[z];
	movq	%r12, %rsi	# _98, d_102
	subq	%rbp, %rsi	# _101, d_102
# candidate/source/falcon-sign.c:2308: 		msb_eq = ~(d | (0 - d)) >> 63;
	orq	%r9, %rsi	# _103, _105
# candidate/source/falcon-sign.c:2308: 		msb_eq = ~(d | (0 - d)) >> 63;
	notq	%rsi	# _106
# candidate/source/falcon-sign.c:2308: 		msb_eq = ~(d | (0 - d)) >> 63;
	shrq	$63, %rsi	#, msb_eq_107
# candidate/source/falcon-sign.c:2315: 		ge = msb_gt | (msb_eq & (hi_gt | (hi_eq & lo_ge)));
	andq	%rsi, %rcx	# msb_eq_107, _121
# candidate/source/falcon-sign.c:2307: 		msb_gt = ((uint64_t)CDF8[z] - (uint64_t)msb) >> 63;
	shrq	$63, %r9	#, msb_gt_104
# candidate/source/falcon-sign.c:2315: 		ge = msb_gt | (msb_eq & (hi_gt | (hi_eq & lo_ge)));
	orq	%r9, %rcx	# msb_gt_104, ge
# candidate/source/falcon-sign.c:2316: 		sel = ge & not_found;
	movq	%rax, %rsi	# not_found, sel_124
	andq	%rcx, %rsi	# ge, sel_124
# candidate/source/falcon-sign.c:2317: 		result += (int)(sel * (uint64_t)z);
	negl	%esi	# tmp278
	andl	%r8d, %esi	# ivtmp.163, _127
# candidate/source/falcon-sign.c:2317: 		result += (int)(sel * (uint64_t)z);
	addl	%esi, %edx	# _127, result
# candidate/source/falcon-sign.c:2318: 		not_found &= ~ge;
	notq	%rcx	# _131
# candidate/source/falcon-sign.c:2318: 		not_found &= ~ge;
	andq	%rcx, %rax	# _131, not_found
# candidate/source/falcon-sign.c:2303: 	for (z = 0; z < (int)(sizeof CDF8); z ++) {
	addq	$1, %r8	#, ivtmp.163
	addq	$16, %r11	#, ivtmp.169
	cmpq	$6, %r8	#, ivtmp.163
	jne	.L58	#,
# candidate/source/falcon-sign.c:2329: 	msb_nz = (uint64_t)0 - ((0 - (uint64_t)msb) >> 63); /* all-ones if msb != 0 */
	movq	8(%rsp), %rbp	# %sfp, u
	movq	16(%rsp), %rcx	# %sfp, _168
	negb	%r13b	# _180
	sbbq	%r12, %r12	# msb_nz
	leaq	CDF0(%rip), %r9	#, ivtmp.158
	movl	$6, %r11d	#, ivtmp.159
.L59:
# candidate/source/falcon-sign.c:2333: 		d = hi - CDF0[z].hi;
	movq	(%r9), %r8	# MEM[(long unsigned int *)_169], _139
# candidate/source/falcon-sign.c:2334: 		hi_gt = (CDF0[z].hi - hi) >> 63;
	movq	%r8, %rdi	# _139, _141
	subq	%rbx, %rdi	# _177, _141
# candidate/source/falcon-sign.c:2333: 		d = hi - CDF0[z].hi;
	movq	%rbx, %rsi	# _177, d_140
	subq	%r8, %rsi	# _139, d_140
# candidate/source/falcon-sign.c:2335: 		hi_eq = ~(d | (0 - d)) >> 63;
	orq	%rdi, %rsi	# _141, _143
# candidate/source/falcon-sign.c:2335: 		hi_eq = ~(d | (0 - d)) >> 63;
	notq	%rsi	# _144
# candidate/source/falcon-sign.c:2335: 		hi_eq = ~(d | (0 - d)) >> 63;
	shrq	$63, %rsi	#, hi_eq_145
# candidate/source/falcon-sign.c:2336: 		lo_ge = ~((lo - CDF0[z].lo) >> 63);
	movq	%r10, %r8	# _171, _147
	subq	8(%r9), %r8	# MEM[(long unsigned int *)_169 + 8B], _147
# candidate/source/falcon-sign.c:2336: 		lo_ge = ~((lo - CDF0[z].lo) >> 63);
	shrq	$63, %r8	#, _148
# candidate/source/falcon-sign.c:2336: 		lo_ge = ~((lo - CDF0[z].lo) >> 63);
	notq	%r8	# lo_ge_149
# candidate/source/falcon-sign.c:2338: 		ge = (msb_nz | (hi_gt | (hi_eq & lo_ge))) & 1;
	andq	%r8, %rsi	# lo_ge_149, _150
# candidate/source/falcon-sign.c:2334: 		hi_gt = (CDF0[z].hi - hi) >> 63;
	shrq	$63, %rdi	#, hi_gt_142
# candidate/source/falcon-sign.c:2338: 		ge = (msb_nz | (hi_gt | (hi_eq & lo_ge))) & 1;
	orq	%r12, %rdi	# msb_nz, _173
	orq	%rdi, %rsi	# _173, _152
# candidate/source/falcon-sign.c:2338: 		ge = (msb_nz | (hi_gt | (hi_eq & lo_ge))) & 1;
	andl	$1, %esi	#, ge
# candidate/source/falcon-sign.c:2339: 		sel = ge & not_found;
	movq	%rax, %rdi	# not_found, sel_155
	andq	%rsi, %rdi	# ge, sel_155
# candidate/source/falcon-sign.c:2340: 		result += (int)(sel * (uint64_t)(z + (int)(sizeof CDF8)));
	negl	%edi	# tmp295
	andl	%r11d, %edi	# ivtmp.159, _159
# candidate/source/falcon-sign.c:2340: 		result += (int)(sel * (uint64_t)(z + (int)(sizeof CDF8)));
	addl	%edi, %edx	# _159, result
# candidate/source/falcon-sign.c:2341: 		not_found &= ~ge;
	notq	%rsi	# _163
# candidate/source/falcon-sign.c:2341: 		not_found &= ~ge;
	andq	%rsi, %rax	# _163, not_found
# candidate/source/falcon-sign.c:2330: 	for (z = 0; z < (int)(sizeof CDF0 / sizeof CDF0[0]); z ++) {
	addq	$16, %r9	#, ivtmp.158
	addl	$1, %r11d	#, ivtmp.159
	cmpq	%r9, %r15	# ivtmp.158, _68
	jne	.L59	#,
# candidate/source/internal.h:861: 	v = p->buf.d[p->ptr ++];
	addq	$9, %rbp	#, tmp298
	movq	%rbp, 4096(%r14)	# tmp298, MEM[(struct prng *)ctx_14(D)].ptr
# candidate/source/falcon-sign.c:2569: 		b = falcon_prng_get_u8(p) & 1;
	movzbl	(%r14,%rcx), %ebp	# MEM[(struct prng *)ctx_14(D)].buf.d[_168], MEM[(struct prng *)ctx_14(D)].buf.d[_168]
	andl	$1, %ebp	#, b
# candidate/source/falcon-sign.c:2570: 		z = b + ((b << 1) - 1) * z;
	leal	-1(%rbp,%rbp), %ebx	#, _6
# candidate/source/falcon-sign.c:2570: 		z = b + ((b << 1) - 1) * z;
	imull	%edx, %ebx	# result, _7
# candidate/source/falcon-sign.c:2570: 		z = b + ((b << 1) - 1) * z;
	addl	%ebx, %ebp	# _7, z
# candidate/source/falcon-sign.c:2593: 		x = fpr_mul(fpr_sqr(fpr_sub(fpr_of(z), r)), dss);
	movslq	%ebp, %rdi	# z, _8
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp321, _42
# candidate/source/fpr-emulated.h:157: 	return fpr_add(x, y);
	movq	32(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp322, _41
# candidate/source/fpr-emulated.h:188: 	return fpr_mul(x, x);
	movq	%rax, %rsi	# _41,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp323, _39
# candidate/source/falcon-sign.c:2593: 		x = fpr_mul(fpr_sqr(fpr_sub(fpr_of(z), r)), dss);
	movq	24(%rsp), %rsi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp324, x
# candidate/source/falcon-sign.c:2594: 		x = fpr_sub(x, fpr_mul(fpr_of((z - b) * (z - b)), fpr_inv_8));
	imull	%ebx, %ebx	# _7, _9
# candidate/source/falcon-sign.c:2594: 		x = fpr_sub(x, fpr_mul(fpr_of((z - b) * (z - b)), fpr_inv_8));
	movslq	%ebx, %rdi	# _9, _10
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp325, _38
# candidate/source/falcon-sign.c:2594: 		x = fpr_sub(x, fpr_mul(fpr_of((z - b) * (z - b)), fpr_inv_8));
	movabsq	$4593671619917905920, %rsi	#, tmp308
	call	fpr_mul@PLT	#
# candidate/source/fpr-emulated.h:156: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_36
	xorq	%rax, %rsi	# tmp326, y_36
# candidate/source/fpr-emulated.h:157: 	return fpr_add(x, y);
	movq	%r12, %rdi	# x,
	call	fpr_add@PLT	#
	movq	%rax, %rsi	# tmp327, _37
# candidate/source/falcon-sign.c:2595: 		if (BerExp(p, x)) {
	movq	%r14, %rdi	# ctx,
	call	BerExp	#
# candidate/source/falcon-sign.c:2595: 		if (BerExp(p, x)) {
	testl	%eax, %eax	# tmp328
	jne	.L65	#,
.L60:
# candidate/source/internal.h:861: 	v = p->buf.d[p->ptr ++];
	movq	4096(%r14), %rdx	# MEM[(struct prng *)ctx_14(D)].ptr, _178
# candidate/source/internal.h:861: 	v = p->buf.d[p->ptr ++];
	leaq	1(%rdx), %rax	#, _179
	movq	%rax, 4096(%r14)	# _179, MEM[(struct prng *)ctx_14(D)].ptr
# candidate/source/internal.h:861: 	v = p->buf.d[p->ptr ++];
	movzbl	(%r14,%rdx), %r13d	# MEM[(struct prng *)ctx_14(D)].buf.d[_178], _180
# candidate/source/internal.h:862: 	if (p->ptr == sizeof p->buf.d) {
	cmpq	$4096, %rax	#, _179
	je	.L66	#,
.L55:
# candidate/source/internal.h:824: 	u = p->ptr;
	movq	4096(%r14), %rax	# MEM[(struct prng *)ctx_14(D)].ptr, u
# candidate/source/internal.h:825: 	if (u >= (sizeof p->buf.d) - 9) {
	cmpq	$4086, %rax	#, u
	ja	.L67	#,
# candidate/source/internal.h:829: 	p->ptr = u + 8;
	leaq	8(%rax), %rbp	#, u
# candidate/source/internal.h:829: 	p->ptr = u + 8;
	movq	%rbp, 4096(%r14)	# u, MEM[(struct prng *)ctx_14(D)].ptr
# candidate/source/internal.h:838: 		memcpy(&x, p->buf.d + u, sizeof x);
	movq	%r14, %r12	# ctx, _175
# candidate/source/internal.h:838: 		memcpy(&x, p->buf.d + u, sizeof x);
	movq	(%r14,%rax), %rbx	# MEM <unsigned long> [(char * {ref-all})_176], _177
# candidate/source/internal.h:825: 	if (u >= (sizeof p->buf.d) - 9) {
	cmpq	$4086, %rbp	#, u
	jbe	.L57	#,
# candidate/source/internal.h:826: 		falcon_prng_refill(p);
	movq	%r14, %rdi	# ctx,
	call	falcon_prng_refill@PLT	#
# candidate/source/internal.h:827: 		u = 0;
	movl	$0, %ebp	#, u
	jmp	.L57	#
.L65:
# candidate/source/falcon-sign.c:2600: 			return s + z;
	movq	40(%rsp), %r13	# %sfp, _88
	leal	0(%rbp,%r13), %eax	#, _30
# candidate/source/falcon-sign.c:2603: }
	addq	$56, %rsp	#,
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE67:
	.size	sampler, .-sampler
	.type	clear_private, @function
clear_private:
.LFB80:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx	# tmp111, fs
# candidate/source/falcon-sign.c:3052: 	if (fs->sk != NULL) {
	movq	856(%rdi), %rax	# fs_10(D)->sk, p
# candidate/source/falcon-sign.c:3052: 	if (fs->sk != NULL) {
	testq	%rax, %rax	# p
	je	.L69	#,
# candidate/source/falcon-sign.c:3054: 		cleanse(fs->sk, fs->sk_len);
	movq	864(%rdi), %rcx	# fs_10(D)->sk_len, _2
# candidate/source/falcon-sign.c:3022: 	while (len -- > 0) {
	testq	%rcx, %rcx	# _2
	je	.L70	#,
	addq	%rax, %rcx	# p, _34
	.p2align 4
.L71:
	movq	%rax, %rdx	# p, p
# candidate/source/falcon-sign.c:3023: 		*p ++ = 0;
	addq	$1, %rax	#, p
# candidate/source/falcon-sign.c:3023: 		*p ++ = 0;
	movb	$0, (%rdx)	#, *p_39
# candidate/source/falcon-sign.c:3022: 	while (len -- > 0) {
	cmpq	%rcx, %rax	# _34, p
	jne	.L71	#,
.L70:
# candidate/source/falcon-sign.c:3056: 		free(fs->sk);
	movq	856(%rbx), %rdi	# fs_10(D)->sk, fs_10(D)->sk
	call	free@PLT	#
# candidate/source/falcon-sign.c:3057: 		fs->sk = NULL;
	movq	$0, 856(%rbx)	#, fs_10(D)->sk
# candidate/source/falcon-sign.c:3058: 		fs->sk_len = 0;
	movq	$0, 864(%rbx)	#, fs_10(D)->sk_len
.L69:
# candidate/source/falcon-sign.c:3060: 	if (fs->tmp != NULL) {
	movq	872(%rbx), %rax	# fs_10(D)->tmp, p
# candidate/source/falcon-sign.c:3060: 	if (fs->tmp != NULL) {
	testq	%rax, %rax	# p
	je	.L72	#,
# candidate/source/falcon-sign.c:3062: 		cleanse(fs->tmp, fs->tmp_len);
	movq	880(%rbx), %rcx	# fs_10(D)->tmp_len, _5
# candidate/source/falcon-sign.c:3022: 	while (len -- > 0) {
	testq	%rcx, %rcx	# _5
	je	.L73	#,
	addq	%rax, %rcx	# p, _28
	.p2align 4
.L74:
	movq	%rax, %rdx	# p, p
# candidate/source/falcon-sign.c:3023: 		*p ++ = 0;
	addq	$1, %rax	#, p
# candidate/source/falcon-sign.c:3023: 		*p ++ = 0;
	movb	$0, (%rdx)	#, *p_35
# candidate/source/falcon-sign.c:3022: 	while (len -- > 0) {
	cmpq	%rcx, %rax	# _28, p
	jne	.L74	#,
.L73:
# candidate/source/falcon-sign.c:3064: 		free(fs->tmp);
	movq	872(%rbx), %rdi	# fs_10(D)->tmp, fs_10(D)->tmp
	call	free@PLT	#
# candidate/source/falcon-sign.c:3065: 		fs->tmp = NULL;
	movq	$0, 872(%rbx)	#, fs_10(D)->tmp
# candidate/source/falcon-sign.c:3066: 		fs->tmp_len = 0;
	movq	$0, 880(%rbx)	#, fs_10(D)->tmp_len
.L72:
# candidate/source/falcon-sign.c:3068: 	fs->q = 0;
	movl	$0, 840(%rbx)	#, fs_10(D)->q
# candidate/source/falcon-sign.c:3069: 	fs->logn = 0;
	movl	$0, 844(%rbx)	#, fs_10(D)->logn
# candidate/source/falcon-sign.c:3070: 	fs->ternary = 0;
	movl	$0, 848(%rbx)	#, fs_10(D)->ternary
# candidate/source/falcon-sign.c:3071: }
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE80:
	.size	clear_private, .-clear_private
	.type	ft_stable_positive, @function
ft_stable_positive:
.LFB43:
	.cfi_startproc
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx	#
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx	# tmp119, x
	movq	%rsi, %rbp	# tmp120, bad
# candidate/source/falcon-sign.c:766: 	valid = (uint32_t)ft_fpr_is_positive_finite(x);
	call	ft_fpr_is_positive_finite	#
# candidate/source/falcon-sign.c:767: 	*bad |= valid ^ 1U;
	movl	%eax, %edx	# _1, _18
	xorl	$1, %edx	#, _18
# candidate/source/falcon-sign.c:767: 	*bad |= valid ^ 1U;
	orl	%edx, 0(%rbp)	# _18, *bad_13(D)
# candidate/source/falcon-sign.c:768: 	mask = (uint64_t)0 - (uint64_t)valid;
	movl	%eax, %edx	# _1, _5
# candidate/source/falcon-sign.c:768: 	mask = (uint64_t)0 - (uint64_t)valid;
	movq	%rdx, %rax	# _5, mask_15
	negq	%rax	# mask_15
# candidate/source/falcon-sign.c:770: 	return ft_fpr_from_bits((xb & mask) | (ft_fpr_bits(fpr_one) & ~mask));
	andq	%rbx, %rax	# x, _6
# candidate/source/falcon-sign.c:770: 	return ft_fpr_from_bits((xb & mask) | (ft_fpr_bits(fpr_one) & ~mask));
	subq	$1, %rdx	#, _17
	movabsq	$4607182418800017408, %rcx	#, tmp118
	andq	%rcx, %rdx	# tmp118, _8
# candidate/source/falcon-sign.c:770: 	return ft_fpr_from_bits((xb & mask) | (ft_fpr_bits(fpr_one) & ~mask));
	orq	%rdx, %rax	# _8, _9
# candidate/source/falcon-sign.c:771: }
	popq	%rbx	#
	.cfi_def_cfa_offset 16
	popq	%rbp	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE43:
	.size	ft_stable_positive, .-ft_stable_positive
	.type	ft_stable_binary_inplace, @function
ft_stable_binary_inplace:
.LFB44:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$56, %rsp	#,
	.cfi_def_cfa_offset 112
	movq	%rdi, 32(%rsp)	# tmp167, %sfp
	movq	%rsi, 40(%rsp)	# n, %sfp
	movq	%rdx, 8(%rsp)	# tmp169, %sfp
	movq	%rcx, %rbx	# tmp170, bad
# candidate/source/falcon-sign.c:779: 	if (n == 1) {
	cmpq	$1, %rsi	#, n
	je	.L87	#,
# candidate/source/falcon-sign.c:784: 	for (u = 0; u < hn; u ++) {
	movq	40(%rsp), %rax	# %sfp, hn
	shrq	%rax	# hn
	movq	%rax, 16(%rsp)	# hn, %sfp
	je	.L83	#,
	movq	32(%rsp), %r15	# %sfp, ivtmp.197
	movq	8(%rsp), %rcx	# %sfp, scratch
	leaq	(%rcx,%rax,8), %rax	#, _76
	movq	%rax, 24(%rsp)	# _76, %sfp
# candidate/source/falcon-sign.c:784: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebp	#, u
.L84:
# candidate/source/falcon-sign.c:787: 		a = ft_stable_positive(values[(u << 1) + 0], bad);
	movq	(%r15), %rdi	# MEM[(fpr *)_74], MEM[(fpr *)_74]
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive	#
	movq	%rax, %r13	# tmp172, a
# candidate/source/falcon-sign.c:788: 		b = ft_stable_positive(values[(u << 1) + 1], bad);
	movq	8(%r15), %rdi	# MEM[(fpr *)_74 + 8B], MEM[(fpr *)_74 + 8B]
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive	#
	movq	%rax, %r14	# tmp173, b
# candidate/source/falcon-sign.c:789: 		sum = ft_stable_positive(fpr_add(a, b), bad);
	movq	%rax, %rsi	# b,
	movq	%r13, %rdi	# a,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp174, _9
# candidate/source/falcon-sign.c:789: 		sum = ft_stable_positive(fpr_add(a, b), bad);
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive	#
	movq	%rax, %r12	# tmp175, sum
# candidate/source/falcon-sign.c:790: 		product = ft_stable_positive(fpr_mul(a, b), bad);
	movq	%r14, %rsi	# b,
	movq	%r13, %rdi	# a,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp176, _10
# candidate/source/falcon-sign.c:790: 		product = ft_stable_positive(fpr_mul(a, b), bad);
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive	#
	movq	%rax, %r13	# tmp177, product
# candidate/source/fpr-emulated.h:172: 	x -= (uint64_t)1 << 52;
	movabsq	$-4503599627370496, %rax	#, tmp189
	leaq	(%r12,%rax), %rdi	#, x
# candidate/source/fpr-emulated.h:173: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rdi, %rax	# x, _61
	shrq	$52, %rax	#, _61
# candidate/source/fpr-emulated.h:173: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %eax	#, _63
# candidate/source/fpr-emulated.h:173: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %eax	#, _64
# candidate/source/fpr-emulated.h:173: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %eax	#, t_65
# candidate/source/fpr-emulated.h:174: 	x &= (uint64_t)t - 1;
	movl	%eax, %eax	# t_65, _66
# candidate/source/fpr-emulated.h:174: 	x &= (uint64_t)t - 1;
	subq	$1, %rax	#, _67
# candidate/source/fpr-emulated.h:174: 	x &= (uint64_t)t - 1;
	andq	%rax, %rdi	# _67, x_68
# candidate/source/falcon-sign.c:791: 		scratch[u] = ft_stable_positive(fpr_half(sum), bad);
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive	#
# candidate/source/falcon-sign.c:791: 		scratch[u] = ft_stable_positive(fpr_half(sum), bad);
	movq	8(%rsp), %rcx	# %sfp, scratch
	movq	%rax, (%rcx,%rbp,8)	# tmp178, MEM[(fpr *)scratch_29(D) + u_71 * 8]
# candidate/source/fpr-emulated.h:181: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	movq	%r13, %rdi	# product, _47
	shrq	$52, %rdi	#, _47
# candidate/source/fpr-emulated.h:181: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	andl	$2047, %edi	#, _54
# candidate/source/fpr-emulated.h:181: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addl	$2047, %edi	#, _55
# candidate/source/fpr-emulated.h:181: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrl	$11, %edi	#, _56
# candidate/source/fpr-emulated.h:181: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	salq	$52, %rdi	#, _58
# candidate/source/fpr-emulated.h:181: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addq	%r13, %rdi	# product, x_59
# candidate/source/falcon-sign.c:792: 		scratch[u + hn] = ft_stable_positive(
	movq	%r12, %rsi	# sum,
	call	fpr_div@PLT	#
	movq	%rax, %rdi	# tmp179, _14
# candidate/source/falcon-sign.c:792: 		scratch[u + hn] = ft_stable_positive(
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive	#
# candidate/source/falcon-sign.c:792: 		scratch[u + hn] = ft_stable_positive(
	movq	24(%rsp), %rdx	# %sfp, _76
	movq	%rax, (%rdx,%rbp,8)	# tmp180, MEM[(fpr *)_76 + u_71 * 8]
# candidate/source/falcon-sign.c:784: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbp	#, u
# candidate/source/falcon-sign.c:784: 	for (u = 0; u < hn; u ++) {
	addq	$16, %r15	#, ivtmp.197
	cmpq	%rbp, 16(%rsp)	# u, %sfp
	jne	.L84	#,
.L83:
# candidate/source/falcon-sign.c:795: 	memcpy(values, scratch, n * sizeof *values);
	movq	40(%rsp), %rdx	# %sfp, n
	salq	$3, %rdx	#, n
	movq	8(%rsp), %rbp	# %sfp, scratch
	movq	%rbp, %rsi	# scratch,
	movq	32(%rsp), %r14	# %sfp, values
	movq	%r14, %rdi	# values,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:796: 	ft_stable_binary_inplace(values, hn, scratch, bad);
	movq	%rbx, %rcx	# bad,
	movq	%rbp, %rdx	# scratch,
	movq	16(%rsp), %r15	# %sfp, hn
	movq	%r15, %rsi	# hn,
	movq	%r14, %rdi	# values,
	call	ft_stable_binary_inplace	#
# candidate/source/falcon-sign.c:797: 	ft_stable_binary_inplace(values + hn, hn, scratch, bad);
	movq	%r15, %rsi	# hn, hn
	leaq	(%r14,%r15,8), %rdi	#, _21
	movq	%rbx, %rcx	# bad,
	movq	%rbp, %rdx	# scratch,
	call	ft_stable_binary_inplace	#
.L80:
# candidate/source/falcon-sign.c:798: }
	addq	$56, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
.L87:
	.cfi_restore_state
# candidate/source/falcon-sign.c:780: 		values[0] = ft_stable_positive(values[0], bad);
	movq	%rdi, %r15	# tmp167, values
	movq	(%rdi), %rdi	# *values_28(D), *values_28(D)
	movq	%rcx, %rsi	# bad,
	call	ft_stable_positive	#
# candidate/source/falcon-sign.c:780: 		values[0] = ft_stable_positive(values[0], bad);
	movq	%rax, (%r15)	# tmp171, *values_28(D)
# candidate/source/falcon-sign.c:781: 		return;
	jmp	.L80	#
	.cfi_endproc
.LFE44:
	.size	ft_stable_binary_inplace, .-ft_stable_binary_inplace
	.type	sampler_large, @function
sampler_large:
.LFB78:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp	#,
	.cfi_def_cfa_offset 144
	movq	%rdx, %rbx	# tmp317, sigma
# candidate/source/falcon-sign.c:2850: 	if (tsc->fault != FT_SAMPLER_FAULT_NONE) {
	movl	4368(%rdi), %eax	# MEM[(struct ternary_sampler_context *)ctx_29(D)].fault, _1
	movl	%eax, %edx	# _1, _1
	movl	%eax, 8(%rsp)	# _1, %sfp
# candidate/source/falcon-sign.c:2851: 		return 0;
	movl	$0, %eax	#, <retval>
# candidate/source/falcon-sign.c:2850: 	if (tsc->fault != FT_SAMPLER_FAULT_NONE) {
	testl	%edx, %edx	# _1
	jne	.L88	#,
	movq	%rdi, %r12	# tmp315, ctx
	movq	%rsi, %rbp	# tmp316, mu
# candidate/source/falcon-sign.c:2856: 	if (!ft_fpr_is_finite(mu) || !ft_fpr_is_positive_finite(sigma)) {
	movabsq	$9218868437227405312, %rdx	#, tmp234
	movq	%rsi, %rax	# mu, tmp340
	notq	%rax	# tmp340
	testq	%rdx, %rax	# tmp234, tmp340
	je	.L90	#,
# candidate/source/falcon-sign.c:2856: 	if (!ft_fpr_is_finite(mu) || !ft_fpr_is_positive_finite(sigma)) {
	movq	%rbx, %rdi	# sigma,
	call	ft_fpr_is_positive_finite	#
# candidate/source/falcon-sign.c:2856: 	if (!ft_fpr_is_finite(mu) || !ft_fpr_is_positive_finite(sigma)) {
	testl	%eax, %eax	# tmp318
	jne	.L91	#,
.L90:
# candidate/source/falcon-sign.c:2857: 		tsc->fault = FT_SAMPLER_FAULT_INVALID_SIGMA;
	movl	$1, 4368(%r12)	#, MEM[(struct ternary_sampler_context *)ctx_29(D)].fault
# candidate/source/falcon-sign.c:2861: 		return 0;
	movl	$0, %eax	#, <retval>
.L88:
# candidate/source/falcon-sign.c:2972: }
	addq	$88, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
.L91:
	.cfi_restore_state
# candidate/source/fpr-emulated.h:124: 	e = (int)(x >> 52) & 0x7FF;
	movq	%rbp, %rax	# mu, _93
	shrq	$52, %rax	#, _93
# candidate/source/fpr-emulated.h:124: 	e = (int)(x >> 52) & 0x7FF;
	andl	$2047, %eax	#, e
	movq	%rbp, %rsi	# mu, _102
	sarq	$63, %rsi	#, _102
# candidate/source/fpr-emulated.h:126: 	xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
	movq	%rbp, %rdx	# mu, _97
	salq	$10, %rdx	#, _97
# candidate/source/fpr-emulated.h:126: 	xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
	btrq	$63, %rdx	#, _98
	btsq	$62, %rdx	#, _99
# candidate/source/fpr-emulated.h:128: 	xi = (xi ^ -(int64_t)t) + (int64_t)t;
	xorq	%rsi, %rdx	# _102, _103
# candidate/source/fpr-emulated.h:125: 	t = x >> 63;
	movq	%rbp, %rdi	# mu, t_96
	shrq	$63, %rdi	#, t_96
# candidate/source/fpr-emulated.h:128: 	xi = (xi ^ -(int64_t)t) + (int64_t)t;
	addq	%rdx, %rdi	# _103, xi
# candidate/source/fpr-emulated.h:129: 	cc = 1085 - e;
	movl	$1085, %ecx	#, tmp243
	subl	%eax, %ecx	# e, cc
# candidate/source/fpr-emulated.h:132: 	mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
	subl	$1022, %eax	#, _117
# candidate/source/fpr-emulated.h:132: 	mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
	shrl	$31, %eax	#, _119
# candidate/source/fpr-emulated.h:132: 	mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
	movl	%eax, %eax	# _119, _120
# candidate/source/fpr-emulated.h:28: 	x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
	movq	%rdi, %rdx	# xi, _108
	sarq	$32, %rdx	#, _108
# candidate/source/fpr-emulated.h:28: 	x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
	testb	$32, %cl	#, cc
	cmove	%rdi, %rdx	# _108,, xi, x_114
# candidate/source/fpr-emulated.h:29: 	return x >> (n & 31);
	andl	$31, %ecx	#, _115
# candidate/source/fpr-emulated.h:29: 	return x >> (n & 31);
	sarq	%cl, %rdx	# _115, _116
# candidate/source/fpr-emulated.h:133: 	xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
	leaq	-1(%rax), %rcx	#, _122
	andq	%rcx, %rdx	# _122, _124
# candidate/source/fpr-emulated.h:133: 	xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
	negq	%rax	# tmp254
	andq	%rax, %rsi	# tmp254, _126
# candidate/source/fpr-emulated.h:133: 	xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
	orq	%rsi, %rdx	# _126, _124
	movq	%rdx, %r15	# _124, _127
# candidate/source/falcon-sign.c:2865: 	r = fpr_sub(mu, fpr_of(s));
	movslq	%edx, %rdi	# _127, _5
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# candidate/source/fpr-emulated.h:156: 	y ^= (uint64_t)1 << 63;
	btcq	$63, %rax	#, tmp319
	movq	%rax, %rsi	# tmp319, y_36
# candidate/source/fpr-emulated.h:157: 	return fpr_add(x, y);
	movq	%rbp, %rdi	# mu,
	call	fpr_add@PLT	#
	movq	%rax, 16(%rsp)	# tmp320, %sfp
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$2, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rbp	# tmp321, _39
# candidate/source/fpr-emulated.h:188: 	return fpr_mul(x, x);
	movq	%rbx, %rsi	# sigma,
	movq	%rbx, %rdi	# sigma,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp322, _45
# candidate/source/falcon-sign.c:2866: 	dss = fpr_inv(fpr_mul(fpr_sqr(sigma), fpr_of(2)));
	movq	%rbp, %rsi	# _39,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp323, _6
# candidate/source/fpr-emulated.h:194: 	return fpr_div(fpr_one, x);
	movabsq	$4607182418800017408, %rdi	#, tmp260
	call	fpr_div@PLT	#
	movq	%rax, %rbx	# tmp324, _55
# candidate/source/falcon-sign.c:2870: 	if (!ft_fpr_is_positive_finite(dss)) {
	movq	%rax, %rdi	# _55,
	call	ft_fpr_is_positive_finite	#
	leaq	49152+ft_adaptive_cdf(%rip), %r13	#, _88
# candidate/source/falcon-sign.c:2814: 			ft_adaptive_cdf_inv_2sigma0_sq_bits[level]);
	leaq	ft_adaptive_cdf_inv_2sigma0_sq_bits(%rip), %r14	#, tmp312
# candidate/source/fpr-emulated.h:156: 	y ^= (uint64_t)1 << 63;
	movq	16(%rsp), %rdx	# %sfp, y_69
	movabsq	$-9223372036854775808, %rsi	#, tmp385
	xorq	%rsi, %rdx	# tmp385, y_69
	movq	%rdx, 32(%rsp)	# y_69, %sfp
# candidate/source/falcon-sign.c:2870: 	if (!ft_fpr_is_positive_finite(dss)) {
	testl	%eax, %eax	# <retval>
	je	.L114	#,
	movq	%r12, %rbp	# ctx, ctx
	movq	%r15, 40(%rsp)	# _127, %sfp
	movq	%rbx, %r15	# _55, _55
	jmp	.L105	#
.L114:
# candidate/source/falcon-sign.c:2871: 		tsc->fault = FT_SAMPLER_FAULT_INVALID_SIGMA;
	movl	$1, 4368(%r12)	#, MEM[(struct ternary_sampler_context *)ctx_29(D)].fault
# candidate/source/falcon-sign.c:2875: 		return 0;
	jmp	.L88	#
.L119:
# candidate/source/internal.h:826: 		falcon_prng_refill(p);
	movq	%rbp, %rdi	# ctx,
	call	falcon_prng_refill@PLT	#
# candidate/source/internal.h:838: 		memcpy(&x, p->buf.d + u, sizeof x);
	movq	0(%rbp), %rbx	# MEM <unsigned long> [(char * {ref-all})ctx_29(D)], _21
# candidate/source/internal.h:824: 	u = p->ptr;
	movl	$8, %edx	#, u
.L94:
# candidate/source/internal.h:829: 	p->ptr = u + 8;
	leaq	8(%rdx), %rsi	#, _182
# candidate/source/internal.h:829: 	p->ptr = u + 8;
	movq	%rsi, 4096(%rbp)	# _182, MEM[(struct prng *)ctx_29(D)].ptr
# candidate/source/internal.h:838: 		memcpy(&x, p->buf.d + u, sizeof x);
	movq	0(%rbp,%rdx), %rdi	# MEM <unsigned long> [(char * {ref-all})_184], _185
	leaq	48(%rsp), %rcx	#, ivtmp.232
	leaq	8192+ft_adaptive_cdf(%rip), %r9	#, ivtmp.234
	movq	%r15, (%rsp)	# _55, %sfp
.L95:
	leaq	-8192(%r9), %r8	#, ivtmp.221
# candidate/source/falcon-sign.c:2773: 		z = 0;
	movl	$0, %r12d	#, z
.L96:
# candidate/source/falcon-sign.c:2777: 				ft_adaptive_cdf[level][u][1]);
	movq	8(%r8), %rax	# MEM[(long unsigned int *)_171 + 8B], _169
# candidate/source/falcon-sign.c:2776: 				ft_adaptive_cdf[level][u][0],
	movq	(%r8), %r11	# MEM[(long unsigned int *)_171], _170
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	movq	%rbx, %r10	# _21, _208
	xorq	%r11, %r10	# _170, _208
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	movq	%rdi, %r15	# _185, _198
	subq	%rax, %r15	# _169, _198
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	xorq	%rax, %r15	# _169, _199
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	xorq	%rdi, %rax	# _185, _197
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	orq	%rax, %r15	# _197, _200
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	xorq	%rdi, %r15	# _185, _201
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	shrq	$63, %r15	#, _202
# candidate/source/falcon-sign.c:2744: 	return 1 ^ ((q | (0 - q)) >> 63);
	movq	%r10, %rax	# _208, _204
	negq	%rax	# _204
# candidate/source/falcon-sign.c:2744: 	return 1 ^ ((q | (0 - q)) >> 63);
	orq	%r10, %rax	# _208, _205
# candidate/source/falcon-sign.c:2744: 	return 1 ^ ((q | (0 - q)) >> 63);
	shrq	$63, %rax	#, _206
# candidate/source/falcon-sign.c:2744: 	return 1 ^ ((q | (0 - q)) >> 63);
	xorq	$1, %rax	#, _207
# candidate/source/falcon-sign.c:2756: 	return hi_lt | (hi_eq & lo_lt);
	andq	%r15, %rax	# _202, _195
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	movq	%rbx, %r15	# _21, _209
	subq	%r11, %r15	# _170, _209
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	xorq	%r11, %r15	# _170, _210
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	orq	%r10, %r15	# _208, _211
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	xorq	%rbx, %r15	# _21, _212
# candidate/source/falcon-sign.c:2735: 	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
	shrq	$63, %r15	#, _213
# candidate/source/falcon-sign.c:2756: 	return hi_lt | (hi_eq & lo_lt);
	orq	%r15, %rax	# _213, _196
# candidate/source/falcon-sign.c:2775: 			z += ft_ct_lt_u128(hi, lo,
	addq	%rax, %r12	# _196, z
# candidate/source/falcon-sign.c:2774: 		for (u = 0; u < FT_ADAPTIVE_CDF_TABLE_LEN; u ++) {
	addq	$16, %r8	#, ivtmp.221
	cmpq	%r8, %r9	# ivtmp.221, ivtmp.234
	jne	.L96	#,
# candidate/source/falcon-sign.c:2779: 		samples[level] = (int)z;
	movl	%r12d, (%rcx)	# z, MEM[(int *)_112]
# candidate/source/falcon-sign.c:2770: 	for (level = 0; level < FT_ADAPTIVE_CDF_LEVELS; level ++) {
	addq	$4, %rcx	#, ivtmp.232
	addq	$8192, %r9	#, ivtmp.234
	cmpq	%r9, %r13	# ivtmp.234, _88
	jne	.L95	#,
# candidate/source/falcon-sign.c:2804: 	found = 0;
	movq	(%rsp), %r15	# %sfp, _55
	movl	8(%rsp), %r8d	# %sfp, found
	movl	$0, %ecx	#, ivtmp.208
# candidate/source/falcon-sign.c:2807: 	coefficient_bits = 0;
	movl	$0, %r12d	#, coefficient_bits
# candidate/source/falcon-sign.c:2806: 	selected_sample = 0;
	movl	$0, %ebx	#, selected_sample
# candidate/source/falcon-sign.c:2818: 		selected_sample += samples[level] * (int)take;
	leaq	48(%rsp), %r9	#, tmp288
.L97:
# candidate/source/falcon-sign.c:2814: 			ft_adaptive_cdf_inv_2sigma0_sq_bits[level]);
	movq	(%r14,%rcx,8), %r10	# MEM[(long unsigned int *)&ft_adaptive_cdf_inv_2sigma0_sq_bits + ivtmp.208_167 * 8], _132
# candidate/source/fpr-emulated.h:207: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	movq	%r15, %rdi	# _55, _140
	andq	%r10, %rdi	# _132, _140
# candidate/source/fpr-emulated.h:207: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	shrq	$63, %rdi	#, _141
# candidate/source/fpr-emulated.h:207: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	cmpq	%r10, %r15	# _132, _55
	setne	%al	#, _138
	movzbl	%al, %eax	# _138, _138
# candidate/source/fpr-emulated.h:207: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	andl	%edi, %eax	# _141, _143
# candidate/source/fpr-emulated.h:205: 	cc0 = sx < sy;
	cmpq	%r10, %r15	# _132, _55
# candidate/source/fpr-emulated.h:207: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	setge	%dil	#, _144
	movzbl	%dil, %edi	# _144, _144
# candidate/source/falcon-sign.c:2815: 		ge = (unsigned)(1 ^ fpr_lt(dss, coefficient));
	xorl	%eax, %edi	# _143, ge
# candidate/source/falcon-sign.c:2816: 		take = (1U ^ found) & ge;
	movl	%r8d, %eax	# found, _148
	xorl	$1, %eax	#, _148
# candidate/source/falcon-sign.c:2816: 		take = (1U ^ found) & ge;
	andl	%edi, %eax	# ge, take
# candidate/source/falcon-sign.c:2818: 		selected_sample += samples[level] * (int)take;
	movl	%eax, %r11d	# take, tmp289
	negl	%r11d	# tmp289
	andl	(%r9,%rcx,4), %r11d	# MEM[(int *)&samples + ivtmp.208_167 * 4], _154
# candidate/source/falcon-sign.c:2818: 		selected_sample += samples[level] * (int)take;
	addl	%r11d, %ebx	# _154, selected_sample
# candidate/source/falcon-sign.c:2817: 		mask = (uint64_t)0 - (uint64_t)take;
	movl	%eax, %eax	# take, _150
# candidate/source/falcon-sign.c:2821: 			ft_adaptive_cdf_inv_2sigma0_sq_bits[level] & mask;
	negq	%rax	# tmp292
	andq	%r10, %rax	# _132, _160
# candidate/source/falcon-sign.c:2820: 		coefficient_bits |=
	orq	%rax, %r12	# _160, coefficient_bits
# candidate/source/falcon-sign.c:2822: 		found |= ge;
	orl	%edi, %r8d	# ge, found
# candidate/source/falcon-sign.c:2808: 	for (level = 0; level < FT_ADAPTIVE_CDF_LEVELS; level ++) {
	addq	$1, %rcx	#, ivtmp.208
	cmpq	$5, %rcx	#, ivtmp.208
	jne	.L97	#,
# candidate/source/falcon-sign.c:2908: 		if (!ft_adaptive_proposal(p, dss, &k,
	testl	%r8d, %r8d	# found
	je	.L115	#,
# candidate/source/internal.h:861: 	v = p->buf.d[p->ptr ++];
	addq	$9, %rdx	#, tmp294
	movq	%rdx, 4096(%rbp)	# tmp294, MEM[(struct prng *)ctx_29(D)].ptr
# candidate/source/falcon-sign.c:2922: 		z = b ? (1 + k) : -k;
	testb	$1, 0(%rbp,%rsi)	#, MEM[(struct prng *)ctx_29(D)].buf.d[_182]
	je	.L99	#,
# candidate/source/falcon-sign.c:2922: 		z = b ? (1 + k) : -k;
	leal	1(%rbx), %eax	#, iftmp.29_27
	movl	%eax, 12(%rsp)	# iftmp.29_27, %sfp
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$1, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp326, _71
# candidate/source/fpr-emulated.h:157: 	return fpr_add(x, y);
	movq	32(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, (%rsp)	# tmp327, %sfp
.L100:
# candidate/source/fpr-emulated.h:156: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_72
	xorq	%r12, %rsi	# coefficient_bits, y_72
# candidate/source/fpr-emulated.h:157: 	return fpr_add(x, y);
	movq	%r15, %rdi	# _55,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp328, _73
# candidate/source/falcon-sign.c:2650: 	return (int)(e != 0x7FF && ((w >> 63) == 0 || (w << 1) == 0));
	movq	%rax, %rdx	# _73, tmp339
	notq	%rdx	# tmp339
	movabsq	$9218868437227405312, %rax	#, tmp302
	testq	%rax, %rdx	# tmp302, tmp339
	je	.L101	#,
# candidate/source/falcon-sign.c:2650: 	return (int)(e != 0x7FF && ((w >> 63) == 0 || (w << 1) == 0));
	testq	%r12, %r12	# _73
	js	.L116	#,
.L102:
# candidate/source/falcon-sign.c:2939: 		kk = (int64_t)k * (int64_t)k;
	movslq	%ebx, %rbx	# selected_sample, _15
# candidate/source/falcon-sign.c:2939: 		kk = (int64_t)k * (int64_t)k;
	movq	%rbx, %rdi	# _15, kk_46
	imulq	%rbx, %rdi	# _15, kk_46
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp329, _76
# candidate/source/falcon-sign.c:2940: 		x = fpr_mul(fpr_of(kk), gap);
	movq	%r12, %rsi	# _73,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp330, x
# candidate/source/fpr-emulated.h:188: 	return fpr_mul(x, x);
	movq	(%rsp), %rsi	# %sfp, iftmp.32_24
	movq	%rsi, %rdi	# iftmp.32_24,
	call	fpr_mul@PLT	#
	movq	%rax, 24(%rsp)	# tmp331, %sfp
# candidate/source/falcon-sign.c:2941: 		tail_term = fpr_add(
	leaq	(%rbx,%rbx), %rdi	#, _16
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp332, _74
# candidate/source/falcon-sign.c:2941: 		tail_term = fpr_add(
	movq	(%rsp), %rsi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp333, _17
# candidate/source/falcon-sign.c:2941: 		tail_term = fpr_add(
	movq	24(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp334, tail_term
# candidate/source/falcon-sign.c:2944: 		x = fpr_add(x, fpr_mul(tail_term, dss));
	movq	%r15, %rsi	# _55,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp335, _18
# candidate/source/falcon-sign.c:2944: 		x = fpr_add(x, fpr_mul(tail_term, dss));
	movq	%r12, %rdi	# x,
	call	fpr_add@PLT	#
	movq	%rax, %rsi	# tmp336, x
# candidate/source/falcon-sign.c:2650: 	return (int)(e != 0x7FF && ((w >> 63) == 0 || (w << 1) == 0));
	movq	%rax, %rdx	# x, tmp338
	notq	%rdx	# tmp338
	movabsq	$9218868437227405312, %rax	#, tmp308
	testq	%rax, %rdx	# tmp308, tmp338
	je	.L103	#,
# candidate/source/falcon-sign.c:2650: 	return (int)(e != 0x7FF && ((w >> 63) == 0 || (w << 1) == 0));
	testq	%rsi, %rsi	# x
	js	.L117	#,
.L104:
# candidate/source/falcon-sign.c:2960: 		if (BerExp(p, x)) {
	movq	%rbp, %rdi	# ctx,
	call	BerExp	#
# candidate/source/falcon-sign.c:2960: 		if (BerExp(p, x)) {
	testl	%eax, %eax	# tmp337
	jne	.L118	#,
.L105:
# candidate/source/internal.h:824: 	u = p->ptr;
	movq	4096(%rbp), %rax	# MEM[(struct prng *)ctx_29(D)].ptr, u
# candidate/source/internal.h:825: 	if (u >= (sizeof p->buf.d) - 9) {
	cmpq	$4086, %rax	#, u
	ja	.L119	#,
# candidate/source/internal.h:829: 	p->ptr = u + 8;
	leaq	8(%rax), %rdx	#, u
# candidate/source/internal.h:829: 	p->ptr = u + 8;
	movq	%rdx, 4096(%rbp)	# u, MEM[(struct prng *)ctx_29(D)].ptr
# candidate/source/internal.h:838: 		memcpy(&x, p->buf.d + u, sizeof x);
	movq	0(%rbp,%rax), %rbx	# MEM <unsigned long> [(char * {ref-all})_190], _21
# candidate/source/internal.h:825: 	if (u >= (sizeof p->buf.d) - 9) {
	cmpq	$4086, %rdx	#, u
	jbe	.L94	#,
# candidate/source/internal.h:826: 		falcon_prng_refill(p);
	movq	%rbp, %rdi	# ctx,
	call	falcon_prng_refill@PLT	#
# candidate/source/internal.h:827: 		u = 0;
	movl	$0, %edx	#, u
	jmp	.L94	#
.L115:
# candidate/source/falcon-sign.c:2911: 			tsc->fault = FT_SAMPLER_FAULT_PROPOSAL_RANGE;
	movl	$2, 4368(%rbp)	#, MEM[(struct ternary_sampler_context *)ctx_29(D)].fault
# candidate/source/falcon-sign.c:2915: 			return 0;
	movl	$0, %eax	#, <retval>
	jmp	.L88	#
.L99:
# candidate/source/falcon-sign.c:2922: 		z = b ? (1 + k) : -k;
	movl	%ebx, %eax	# selected_sample, iftmp.29_27
	negl	%eax	# iftmp.29_27
	movl	%eax, 12(%rsp)	# iftmp.29_27, %sfp
# candidate/source/falcon-sign.c:2923: 		delta = b ? fpr_sub(fpr_of(1), r) : r;
	movq	16(%rsp), %rax	# %sfp, _35
	movq	%rax, (%rsp)	# _35, %sfp
	jmp	.L100	#
.L116:
# candidate/source/falcon-sign.c:2932: 		if (!ft_fpr_is_nonnegative_finite(gap)) {
	movq	%r12, %rax	# _73, tmp341
	addq	%rax, %rax	# tmp341
	je	.L102	#,
.L101:
# candidate/source/falcon-sign.c:2933: 			tsc->fault = FT_SAMPLER_FAULT_PROPOSAL_RANGE;
	movl	$2, 4368(%rbp)	#, MEM[(struct ternary_sampler_context *)ctx_29(D)].fault
# candidate/source/falcon-sign.c:2937: 			return 0;
	movl	$0, %eax	#, <retval>
	jmp	.L88	#
.L117:
# candidate/source/falcon-sign.c:2953: 		if (!ft_fpr_is_nonnegative_finite(x)) {
	movq	%rsi, %rax	# x, tmp342
	addq	%rax, %rax	# tmp342
	je	.L104	#,
.L103:
# candidate/source/falcon-sign.c:2954: 			tsc->fault = FT_SAMPLER_FAULT_NEGATIVE_X;
	movl	$3, 4368(%rbp)	#, MEM[(struct ternary_sampler_context *)ctx_29(D)].fault
# candidate/source/falcon-sign.c:2958: 			return 0;
	movl	$0, %eax	#, <retval>
	jmp	.L88	#
.L118:
# candidate/source/falcon-sign.c:2968: 			return s + z;
	movq	40(%rsp), %r15	# %sfp, _127
	movl	12(%rsp), %eax	# %sfp, iftmp.29_27
	addl	%r15d, %eax	# _127, iftmp.29_27
	jmp	.L88	#
	.cfi_endproc
.LFE78:
	.size	sampler_large, .-sampler_large
	.globl	falcon_sign_new
	.type	falcon_sign_new, @function
falcon_sign_new:
.LFB81:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
# candidate/source/falcon-sign.c:3079: 	fs = malloc(sizeof *fs);
	movl	$888, %edi	#,
	call	malloc@PLT	#
	movq	%rax, %rbx	# tmp103, <retval>
# candidate/source/falcon-sign.c:3080: 	if (fs == NULL) {
	testq	%rax, %rax	# <retval>
	je	.L120	#,
# candidate/source/falcon-sign.c:3083: 	fs->seeded = 0;
	movl	$0, 832(%rax)	#, fs_5->seeded
# candidate/source/falcon-sign.c:3084: 	fs->flipped = 0;
	movl	$0, 836(%rax)	#, fs_5->flipped
# candidate/source/falcon-sign.c:3085: 	fs->q = 0;
	movl	$0, 840(%rax)	#, fs_5->q
# candidate/source/falcon-sign.c:3086: 	fs->logn = 0;
	movl	$0, 844(%rax)	#, fs_5->logn
# candidate/source/falcon-sign.c:3087: 	fs->ternary = 0;
	movl	$0, 848(%rax)	#, fs_5->ternary
# candidate/source/falcon-sign.c:3088: 	fs->sk = NULL;
	movq	$0, 856(%rax)	#, fs_5->sk
# candidate/source/falcon-sign.c:3089: 	fs->sk_len = 0;
	movq	$0, 864(%rax)	#, fs_5->sk_len
# candidate/source/falcon-sign.c:3090: 	fs->tmp = NULL;
	movq	$0, 872(%rax)	#, fs_5->tmp
# candidate/source/falcon-sign.c:3091: 	fs->tmp_len = 0;
	movq	$0, 880(%rax)	#, fs_5->tmp_len
# candidate/source/falcon-sign.c:3092: 	shake_init(&fs->rng, 512);
	leaq	416(%rax), %rdi	#, _1
	movl	$512, %esi	#,
	call	shake_init@PLT	#
.L120:
# candidate/source/falcon-sign.c:3094: }
	movq	%rbx, %rax	# <retval>,
	popq	%rbx	#
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
# candidate/source/falcon-sign.c:3100: 	if (fs != NULL) {
	testq	%rdi, %rdi	# fs
	je	.L126	#,
# candidate/source/falcon-sign.c:3099: {
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx	# tmp99, fs
# candidate/source/falcon-sign.c:3101: 		clear_private(fs);
	call	clear_private	#
# candidate/source/falcon-sign.c:3102: 		free(fs);
	movq	%rbx, %rdi	# fs,
	call	free@PLT	#
# candidate/source/falcon-sign.c:3104: }
	popq	%rbx	#
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
	pushq	%r14	#
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13	#
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12	#
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp	#
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx	#
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$32, %rsp	#,
	.cfi_def_cfa_offset 80
	movq	%rdi, %rbx	# tmp109, fs
	movq	%rsi, %r12	# tmp110, seed
	movq	%rdx, %rbp	# tmp111, len
# candidate/source/falcon-sign.c:3111: 	if (replace) {
	testl	%ecx, %ecx	# tmp112
	jne	.L134	#,
# candidate/source/falcon-sign.c:3118: 	if (fs->flipped) {
	cmpl	$0, 836(%rdi)	#, fs_9(D)->flipped
	jne	.L135	#,
.L132:
# candidate/source/falcon-sign.c:3126: 	shake_inject(&fs->rng, seed, len);
	leaq	416(%rbx), %rdi	#, _4
	movq	%rbp, %rdx	# len,
	movq	%r12, %rsi	# seed,
	call	shake_inject@PLT	#
.L129:
# candidate/source/falcon-sign.c:3127: }
	addq	$32, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx	#
	.cfi_def_cfa_offset 40
	popq	%rbp	#
	.cfi_def_cfa_offset 32
	popq	%r12	#
	.cfi_def_cfa_offset 24
	popq	%r13	#
	.cfi_def_cfa_offset 16
	popq	%r14	#
	.cfi_def_cfa_offset 8
	ret	
.L134:
	.cfi_restore_state
# candidate/source/falcon-sign.c:3112: 		shake_init(&fs->rng, 512);
	leaq	416(%rdi), %r13	#, _1
	movl	$512, %esi	#,
	movq	%r13, %rdi	# _1,
	call	shake_init@PLT	#
# candidate/source/falcon-sign.c:3113: 		shake_inject(&fs->rng, seed, len);
	movq	%rbp, %rdx	# len,
	movq	%r12, %rsi	# seed,
	movq	%r13, %rdi	# _1,
	call	shake_inject@PLT	#
# candidate/source/falcon-sign.c:3114: 		fs->seeded = 1;
	movl	$1, 832(%rbx)	#, fs_9(D)->seeded
# candidate/source/falcon-sign.c:3115: 		fs->flipped = 0;
	movl	$0, 836(%rbx)	#, fs_9(D)->flipped
# candidate/source/falcon-sign.c:3116: 		return;
	jmp	.L129	#
.L135:
# candidate/source/falcon-sign.c:3121: 		shake_extract(&fs->rng, tmp, sizeof tmp);
	leaq	416(%rdi), %r13	#, _3
	movl	$32, %edx	#,
	movq	%rsp, %rsi	#,
	movq	%r13, %rdi	# _3,
	call	shake_extract@PLT	#
# candidate/source/falcon-sign.c:3122: 		shake_init(&fs->rng, 512);
	movl	$512, %esi	#,
	movq	%r13, %rdi	# _3,
	call	shake_init@PLT	#
# candidate/source/falcon-sign.c:3123: 		shake_inject(&fs->rng, tmp, sizeof tmp);
	movl	$32, %edx	#,
	movq	%rsp, %rsi	#,
	movq	%r13, %rdi	# _3,
	call	shake_inject@PLT	#
# candidate/source/falcon-sign.c:3124: 		fs->flipped = 0;
	movl	$0, 836(%rbx)	#, fs_9(D)->flipped
	jmp	.L132	#
	.cfi_endproc
.LFE83:
	.size	falcon_sign_set_seed, .-falcon_sign_set_seed
	.type	rng_ready, @function
rng_ready:
.LFB84:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp	#,
	.cfi_def_cfa_offset 48
	movq	%rdi, %rbx	# tmp107, fs
# candidate/source/falcon-sign.c:3132: 	if (!fs->seeded) {
	cmpl	$0, 832(%rdi)	#, fs_9(D)->seeded
	je	.L142	#,
.L137:
# candidate/source/falcon-sign.c:3145: 	return 1;
	movl	$1, %eax	#, <retval>
# candidate/source/falcon-sign.c:3141: 	if (!fs->flipped) {
	cmpl	$0, 836(%rbx)	#, fs_9(D)->flipped
	je	.L143	#,
.L136:
# candidate/source/falcon-sign.c:3146: }
	addq	$32, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret	
.L142:
	.cfi_restore_state
# candidate/source/falcon-sign.c:3135: 		if (!falcon_get_seed(tmp, sizeof tmp)) {
	movq	%rsp, %rdi	#, tmp103
	movl	$32, %esi	#,
	call	falcon_get_seed@PLT	#
# candidate/source/falcon-sign.c:3135: 		if (!falcon_get_seed(tmp, sizeof tmp)) {
	testl	%eax, %eax	# <retval>
	je	.L136	#,
# candidate/source/falcon-sign.c:3138: 		falcon_sign_set_seed(fs, tmp, sizeof tmp, 0);
	movq	%rsp, %rsi	#, tmp104
	movl	$0, %ecx	#,
	movl	$32, %edx	#,
	movq	%rbx, %rdi	# fs,
	call	falcon_sign_set_seed	#
# candidate/source/falcon-sign.c:3139: 		fs->seeded = 1;
	movl	$1, 832(%rbx)	#, fs_9(D)->seeded
	jmp	.L137	#
.L143:
# candidate/source/falcon-sign.c:3142: 		shake_flip(&fs->rng);
	leaq	416(%rbx), %rdi	#, _4
	call	shake_flip@PLT	#
# candidate/source/falcon-sign.c:3143: 		fs->flipped = 1;
	movl	$1, 836(%rbx)	#, fs_9(D)->flipped
# candidate/source/falcon-sign.c:3145: 	return 1;
	movl	$1, %eax	#, <retval>
	jmp	.L136	#
	.cfi_endproc
.LFE84:
	.size	rng_ready, .-rng_ready
	.globl	falcon_sign_set_private_key
	.type	falcon_sign_set_private_key, @function
falcon_sign_set_private_key:
.LFB85:
	.cfi_startproc
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24712, %rsp	#,
	.cfi_def_cfa_offset 24768
	movq	%rdi, %r14	# tmp563, fs
	movq	%rdi, 32(%rsp)	# fs, %sfp
	movq	%rsi, %rbx	# tmp564, skey
	movq	%rdx, %rbp	# tmp565, len
# candidate/source/falcon-sign.c:3167: 	clear_private(fs);
	call	clear_private	#
# candidate/source/falcon-sign.c:3168: 	if (skey == NULL || len < 1) {
	testq	%rbx, %rbx	# skey
	je	.L145	#,
	testq	%rbp, %rbp	# len
	je	.L145	#,
# candidate/source/falcon-sign.c:3191: 	fb = *skey_buf ++;
	movzbl	(%rbx), %eax	# MEM[(const unsigned char *)skey_58(D)], _4
# candidate/source/falcon-sign.c:3191: 	fb = *skey_buf ++;
	movzbl	%al, %ecx	# _4, fb
# candidate/source/falcon-sign.c:3193: 	fs->logn = fb & 0x0F;
	movl	%eax, %edx	# _4, _5
	andl	$15, %edx	#, _5
# candidate/source/falcon-sign.c:3193: 	fs->logn = fb & 0x0F;
	movl	%edx, 844(%r14)	# _5, fs_56(D)->logn
# candidate/source/falcon-sign.c:3195: 	fs->ternary = fb >> 7;
	movl	%ecx, %esi	# fb, _8
	sarl	$7, %esi	#, _8
# candidate/source/falcon-sign.c:3195: 	fs->ternary = fb >> 7;
	movl	%esi, 848(%r14)	# _8, fs_56(D)->ternary
# candidate/source/falcon-sign.c:3196: 	if (fs->ternary) {
	je	.L146	#,
# candidate/source/falcon-sign.c:3197: 		fs->q = 18433;
	movl	$18433, 840(%r14)	#, fs_56(D)->q
# candidate/source/falcon-sign.c:3198: 		if (fs->logn != 10) {
	cmpl	$10, %edx	#, _5
	je	.L147	#,
.L145:
# candidate/source/falcon-sign.c:3275: 	clear_private(fs);
	movq	32(%rsp), %rdi	# %sfp,
	call	clear_private	#
# candidate/source/falcon-sign.c:3276: 	return 0;
	movl	$0, %eax	#, <retval>
.L144:
# candidate/source/falcon-sign.c:3277: }
	addq	$24712, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
.L146:
	.cfi_restore_state
# candidate/source/falcon-sign.c:3202: 		fs->q = 12289;
	movq	32(%rsp), %rdi	# %sfp, fs
	movl	$12289, 840(%rdi)	#, fs_56(D)->q
# candidate/source/falcon-sign.c:3203: 		if (fs->logn < 1 || fs->logn > 10) {
	subl	$1, %edx	#, _9
# candidate/source/falcon-sign.c:3203: 		if (fs->logn < 1 || fs->logn > 10) {
	cmpl	$9, %edx	#, _9
	ja	.L145	#,
.L147:
# candidate/source/falcon-sign.c:3191: 	fb = *skey_buf ++;
	addq	$1, %rbx	#, skey_buf
# candidate/source/falcon-sign.c:3192: 	len --;
	leaq	-1(%rbp), %rdi	#, ivtmp.269
	andl	$16, %eax	#, _4
	movl	%eax, %r14d	# _4, _81
# candidate/source/falcon-sign.c:3207: 	comp = (fb >> 5) & 0x03;
	sarl	$5, %ecx	#, _10
# candidate/source/falcon-sign.c:3207: 	comp = (fb >> 5) & 0x03;
	andl	$3, %ecx	#, _10
	movl	%ecx, %r13d	# _10, comp
	leaq	128(%rsp), %rbp	#, ivtmp.318
	cmpb	$1, %al	#, _81
	sbbq	%rax, %rax	# _558
	andl	$6144, %eax	#, _558
	leaq	18560(%rsp,%rax), %r15	#, _560
# candidate/source/falcon-sign.c:3194: 	has_G = !(fb & 0x10);
	movq	%rbp, %r12	# ivtmp.318, ivtmp.325
	movb	%r14b, 8(%rsp)	# _81, %sfp
	movq	%rbp, 16(%rsp)	# ivtmp.318, %sfp
	movq	%rdi, %rbp	# ivtmp.269, ivtmp.269
	movq	32(%rsp), %r14	# %sfp, fs
.L148:
# candidate/source/falcon-sign.c:3216: 		elen = falcon_decode_small(ske[i], fs->logn,
	movl	840(%r14), %ecx	# fs_56(D)->q, fs_56(D)->q
	movl	844(%r14), %esi	# fs_56(D)->logn, fs_56(D)->logn
	movq	%rbp, %r9	# ivtmp.269,
	movq	%rbx, %r8	# skey_buf,
	movl	%r13d, %edx	# comp,
	movq	%r12, %rdi	# ivtmp.325,
	call	falcon_decode_small@PLT	#
# candidate/source/falcon-sign.c:3218: 		if (elen == 0) {
	testq	%rax, %rax	# elen
	je	.L145	#,
# candidate/source/falcon-sign.c:3221: 		skey_buf += elen;
	addq	%rax, %rbx	# elen, skey_buf
# candidate/source/falcon-sign.c:3222: 		len -= elen;
	subq	%rax, %rbp	# elen, ivtmp.269
# candidate/source/falcon-sign.c:3213: 	for (i = 0; i < 3 + has_G; i ++) {
	addq	$6144, %r12	#, ivtmp.325
	cmpq	%r15, %r12	# _560, ivtmp.325
	jne	.L148	#,
# candidate/source/falcon-sign.c:3224: 	if (len != 0) {
	movzbl	8(%rsp), %r14d	# %sfp, _81
	movq	%rbp, %rax	# ivtmp.269, ivtmp.269
	movq	%rbp, 64(%rsp)	# ivtmp.269, %sfp
	movq	16(%rsp), %rbp	# %sfp, ivtmp.318
	testq	%rax, %rax	# ivtmp.269
	jne	.L145	#,
# candidate/source/falcon-sign.c:3231: 	if (!has_G) {
	testb	%r14b, %r14b	# _81
	jne	.L181	#,
.L149:
# candidate/source/falcon-sign.c:3242: 	if (fs->ternary) {
	movq	32(%rsp), %rax	# %sfp, fs
	movl	848(%rax), %ebx	# fs_56(D)->ternary, _19
# candidate/source/falcon-sign.c:3242: 	if (fs->ternary) {
	testl	%ebx, %ebx	# _19
	je	.L150	#,
# candidate/source/falcon-sign.c:3243: 		fs->sk_len = ((size_t)(3 * (fs->logn + 6)) << (fs->logn - 1))
	movl	844(%rax), %eax	# fs_56(D)->logn, _20
# candidate/source/falcon-sign.c:3243: 		fs->sk_len = ((size_t)(3 * (fs->logn + 6)) << (fs->logn - 1))
	leal	-1(%rax), %ecx	#, _24
# candidate/source/falcon-sign.c:3243: 		fs->sk_len = ((size_t)(3 * (fs->logn + 6)) << (fs->logn - 1))
	leal	18(%rax,%rax,2), %eax	#, _23
# candidate/source/falcon-sign.c:3243: 		fs->sk_len = ((size_t)(3 * (fs->logn + 6)) << (fs->logn - 1))
	salq	%cl, %rax	# _24, _25
# candidate/source/falcon-sign.c:3244: 			* sizeof(fpr);
	leaq	0(,%rax,8), %rdi	#, _14
# candidate/source/falcon-sign.c:3245: 		fs->tmp_len = ((size_t)21 << (fs->logn - 1)) * sizeof(fpr);
	movl	$168, %eax	#, _27
# candidate/source/falcon-sign.c:3245: 		fs->tmp_len = ((size_t)21 << (fs->logn - 1)) * sizeof(fpr);
	salq	%cl, %rax	# _24, _27
	movq	%rax, %r12	# _27, _419
.L151:
# candidate/source/falcon-sign.c:3243: 		fs->sk_len = ((size_t)(3 * (fs->logn + 6)) << (fs->logn - 1))
	movq	32(%rsp), %r15	# %sfp, fs
	movq	%rdi, 864(%r15)	# _14, fs_56(D)->sk_len
# candidate/source/falcon-sign.c:3245: 		fs->tmp_len = ((size_t)21 << (fs->logn - 1)) * sizeof(fpr);
	movq	%r12, 880(%r15)	# _419, fs_56(D)->tmp_len
# candidate/source/falcon-sign.c:3251: 	fs->sk = malloc(fs->sk_len);
	call	malloc@PLT	#
	movq	%rax, 40(%rsp)	# _37, %sfp
# candidate/source/falcon-sign.c:3251: 	fs->sk = malloc(fs->sk_len);
	movq	%rax, 856(%r15)	# _37, fs_56(D)->sk
# candidate/source/falcon-sign.c:3252: 	if (fs->sk == NULL) {
	testq	%rax, %rax	# _37
	je	.L145	#,
# candidate/source/falcon-sign.c:3255: 	fs->tmp = malloc(fs->tmp_len);
	movq	%r12, %rdi	# _419,
	call	malloc@PLT	#
	movq	%rax, %r14	# tmp569, _39
	movq	%rax, 8(%rsp)	# _39, %sfp
# candidate/source/falcon-sign.c:3255: 	fs->tmp = malloc(fs->tmp_len);
	movq	%rax, 872(%r15)	# _39, fs_56(D)->tmp
# candidate/source/falcon-sign.c:3256: 	if (fs->tmp == NULL) {
	testq	%rax, %rax	# _39
	je	.L145	#,
# candidate/source/falcon-sign.c:3260: 	if (fs->ternary
	testl	%ebx, %ebx	# _19
	je	.L152	#,
# candidate/source/falcon-sign.c:1111: 	memset(relation, 0, n * sizeof *relation);
	movl	$12288, %edx	#,
	movl	$0, %esi	#,
	movq	%rax, %rdi	# _39,
	call	memset@PLT	#
	movq	%r14, %r11	# _39, ivtmp.316
# candidate/source/falcon-sign.c:1113: 	for (i = 0; i < n; i ++) {
	movq	64(%rsp), %rdi	# %sfp, i
# candidate/source/falcon-sign.c:1112: 	bad = 0;
	movl	$0, %r10d	#, bad
	jmp	.L157	#
.L181:
# candidate/source/falcon-sign.c:3232: 		if (!falcon_complete_private(ske[3],
	leaq	128(%rsp), %rsi	#, tmp350
	leaq	12416(%rsp), %rcx	#, tmp351
	leaq	6272(%rsp), %rdx	#, tmp353
	leaq	18560(%rsp), %rdi	#, tmp356
	movq	32(%rsp), %rax	# %sfp, fs
	movl	848(%rax), %r9d	# fs_56(D)->ternary,
	movl	844(%rax), %r8d	# fs_56(D)->logn,
	call	falcon_complete_private@PLT	#
# candidate/source/falcon-sign.c:3232: 		if (!falcon_complete_private(ske[3],
	testl	%eax, %eax	# tmp567
	jne	.L149	#,
	jmp	.L145	#
.L150:
# candidate/source/falcon-sign.c:3247: 		fs->sk_len = ((size_t)(fs->logn + 5) << fs->logn)
	movq	32(%rsp), %rax	# %sfp, fs
	movl	844(%rax), %ecx	# fs_56(D)->logn, _29
# candidate/source/falcon-sign.c:3247: 		fs->sk_len = ((size_t)(fs->logn + 5) << fs->logn)
	leal	5(%rcx), %eax	#, _31
# candidate/source/falcon-sign.c:3247: 		fs->sk_len = ((size_t)(fs->logn + 5) << fs->logn)
	salq	%cl, %rax	# _29, _32
# candidate/source/falcon-sign.c:3248: 			* sizeof(fpr);
	leaq	0(,%rax,8), %rdi	#, _14
# candidate/source/falcon-sign.c:3249: 		fs->tmp_len = ((size_t)7 << fs->logn) * sizeof(fpr);
	movl	$56, %eax	#, _34
# candidate/source/falcon-sign.c:3249: 		fs->tmp_len = ((size_t)7 << fs->logn) * sizeof(fpr);
	salq	%cl, %rax	# _29, _34
	movq	%rax, %r12	# _34, _419
	jmp	.L151	#
.L153:
# candidate/source/falcon-sign.c:1131: 				if (u < hn) {
	cmpq	$767, %rsi	#, ivtmp.307
	ja	.L155	#,
# candidate/source/falcon-sign.c:1132: 					relation[u] -= v;
	subq	%rcx, -12288(%rdx)	# v, MEM[(int64_t *)_543 + -12288B]
# candidate/source/falcon-sign.c:1133: 					relation[u + hn] += v;
	addq	%rcx, -6144(%rdx)	# v, MEM[(int64_t *)_543 + -6144B]
.L154:
# candidate/source/falcon-sign.c:1120: 		for (j = 0; j < n; j ++) {
	addq	$8, %rdx	#, ivtmp.306
	addq	$1, %rsi	#, ivtmp.307
	cmpq	%rsi, %rdi	# ivtmp.307, i
	je	.L182	#,
.L156:
# candidate/source/falcon-sign.c:1124: 			v = (int64_t)fi * (int64_t)G[j]
	movswq	21504(%rbp,%rsi,2), %rcx	# MEM[(const int16_t *)_537 + 21504B + ivtmp.307_531 * 2], _112
# candidate/source/falcon-sign.c:1124: 			v = (int64_t)fi * (int64_t)G[j]
	imulq	%r13, %rcx	# _107, _113
# candidate/source/falcon-sign.c:1125: 				- (int64_t)gi * (int64_t)F[j];
	movswq	15360(%rbp,%rsi,2), %r8	# MEM[(const int16_t *)_537 + 15360B + ivtmp.307_531 * 2], _117
# candidate/source/falcon-sign.c:1125: 				- (int64_t)gi * (int64_t)F[j];
	imulq	%r9, %r8	# _114, _118
# candidate/source/falcon-sign.c:1124: 			v = (int64_t)fi * (int64_t)G[j]
	subq	%r8, %rcx	# _118, v
# candidate/source/falcon-sign.c:1127: 			if (k < n) {
	cmpq	$-1536, %rsi	#, ivtmp.307
	jb	.L153	#,
# candidate/source/falcon-sign.c:1128: 				relation[k] += v;
	addq	%rcx, (%rdx)	# v, MEM[(int64_t *)_539]
	jmp	.L154	#
.L155:
# candidate/source/falcon-sign.c:1135: 					relation[u - hn] -= v;
	subq	%rcx, -18432(%rdx)	# v, MEM[(int64_t *)_541 + -18432B]
	jmp	.L154	#
.L182:
# candidate/source/falcon-sign.c:1113: 	for (i = 0; i < n; i ++) {
	addq	$1, %rdi	#, i
# candidate/source/falcon-sign.c:1113: 	for (i = 0; i < n; i ++) {
	addq	$8, %r11	#, ivtmp.316
	subq	$2, %rbp	#, ivtmp.318
	cmpq	$1536, %rdi	#, i
	je	.L183	#,
.L157:
# candidate/source/falcon-sign.c:1116: 		fi = f[i];
	movzwl	128(%rsp,%rdi,2), %r13d	# MEM[(const int16_t *)&ske + i_473 * 2], _93
# candidate/source/falcon-sign.c:1117: 		gi = g[i];
	movzwl	6272(%rsp,%rdi,2), %r9d	# MEM[(const int16_t *)&ske + 6144B + i_473 * 2], _95
# candidate/source/falcon-sign.c:1118: 		bad |= (uint32_t)((fi < -1) | (fi > 1));
	movswl	%r13w, %edx	# _93, fi.4_96
	addl	$1, %edx	#, _97
	cmpl	$2, %edx	#, _97
	seta	%dl	#, _98
# candidate/source/falcon-sign.c:1119: 		bad |= (uint32_t)((gi < -1) | (gi > 1));
	movswl	%r9w, %ecx	# _95, gi.5_102
	addl	$1, %ecx	#, _103
	cmpl	$2, %ecx	#, _103
	seta	%cl	#, _104
# candidate/source/falcon-sign.c:1119: 		bad |= (uint32_t)((gi < -1) | (gi > 1));
	orl	%ecx, %edx	# _104, _512
	movzbl	%dl, %edx	# _512, _283
	orl	%edx, %r10d	# _283, bad
	leaq	-1536(%rdi), %rsi	#, ivtmp.307
	movq	%r11, %rdx	# ivtmp.316, ivtmp.306
# candidate/source/falcon-sign.c:1124: 			v = (int64_t)fi * (int64_t)G[j]
	movswq	%r13w, %r13	# _93, _107
# candidate/source/falcon-sign.c:1125: 				- (int64_t)gi * (int64_t)F[j];
	movswq	%r9w, %r9	# _95, _114
	jmp	.L156	#
.L183:
# candidate/source/falcon-sign.c:1140: 	relation[0] -= 18433;
	movq	8(%rsp), %rdi	# %sfp, _39
	subq	$18433, (%rdi)	#, MEM[(int64_t *)_39]
	leaq	12288(%rdi), %rcx	#, _153
.L158:
# candidate/source/falcon-sign.c:1142: 		bad |= (uint32_t)(relation[i] != 0);
	cmpq	$0, (%rax)	#, MEM[(int64_t *)_370]
	setne	%dl	#, _148
	movzbl	%dl, %edx	# _148, _148
# candidate/source/falcon-sign.c:1142: 		bad |= (uint32_t)(relation[i] != 0);
	orl	%edx, %r10d	# _148, bad
# candidate/source/falcon-sign.c:1141: 	for (i = 0; i < n; i ++) {
	addq	$8, %rax	#, ivtmp.296
	cmpq	%rax, %rcx	# ivtmp.296, _153
	jne	.L158	#,
# candidate/source/falcon-sign.c:3261: 		&& !ft_validate_ternary_private(ske[0], ske[1], ske[2], ske[3],
	testl	%r10d, %r10d	# bad
	jne	.L145	#,
.L152:
# candidate/source/falcon-sign.c:3266: 	memset(fs->tmp, 0, fs->tmp_len);
	movq	%r12, %rdx	# _419,
	movl	$0, %esi	#,
	movq	8(%rsp), %rdi	# %sfp,
	call	memset@PLT	#
# candidate/source/falcon-sign.c:3267: 	if (!load_skey(fs->sk, fs->q, ske[0], ske[1], ske[2], ske[3],
	movq	32(%rsp), %rax	# %sfp, fs
	movl	844(%rax), %r15d	# fs_56(D)->logn, _41
	movl	840(%rax), %eax	# fs_56(D)->q, _42
	movl	%eax, 56(%rsp)	# _42, %sfp
# candidate/source/falcon-sign.c:1170: 	n = MKN(logn, ter);
	leal	1(%rbx,%rbx), %eax	#, _157
	movl	%r15d, %ecx	# _41, _158
	subl	%ebx, %ecx	# _19, _158
# candidate/source/falcon-sign.c:1170: 	n = MKN(logn, ter);
	movq	%rax, %r13	# _157, _157
	salq	%cl, %r13	# _158, _157
# candidate/source/falcon-sign.c:1172: 	b01 = sk + skoff_b01(logn, ter);
	leaq	0(,%r13,8), %rbp	#, _160
# candidate/source/falcon-sign.c:1172: 	b01 = sk + skoff_b01(logn, ter);
	movq	40(%rsp), %rax	# %sfp, _37
	leaq	(%rax,%rbp), %r12	#, b01
# candidate/source/falcon-sign.c:1173: 	b10 = sk + skoff_b10(logn, ter);
	leaq	(%r12,%rbp), %rax	#, b10
# candidate/source/falcon-sign.c:1174: 	b11 = sk + skoff_b11(logn, ter);
	movq	%rax, 24(%rsp)	# b10, %sfp
	leaq	(%rax,%rbp), %r14	#, b11
	movq	%r14, 48(%rsp)	# b11, %sfp
# candidate/source/falcon-sign.c:1175: 	tree = sk + skoff_tree(logn, ter);
	leaq	(%r14,%rbp), %rdi	#, tree
	movq	%rdi, 16(%rsp)	# tree, %sfp
# candidate/source/falcon-sign.c:1186: 	smallints_to_fpr(f, f_src, logn, ter);
	leaq	128(%rsp), %rsi	#, tmp405
	movl	%ebx, %ecx	# _19,
	movl	%r15d, %edx	# _41,
	movq	%r12, %rdi	# b01,
	call	smallints_to_fpr	#
# candidate/source/falcon-sign.c:1187: 	smallints_to_fpr(g, g_src, logn, ter);
	leaq	6272(%rsp), %rsi	#, tmp407
	movl	%ebx, %ecx	# _19,
	movl	%r15d, %edx	# _41,
	movq	40(%rsp), %rdi	# %sfp,
	call	smallints_to_fpr	#
# candidate/source/falcon-sign.c:1188: 	smallints_to_fpr(F, F_src, logn, ter);
	leaq	12416(%rsp), %rsi	#, tmp409
	movl	%ebx, %ecx	# _19,
	movl	%r15d, %edx	# _41,
	movq	%r14, %rdi	# b11,
	call	smallints_to_fpr	#
# candidate/source/falcon-sign.c:1189: 	smallints_to_fpr(G, G_src, logn, ter);
	leaq	18560(%rsp), %rsi	#, tmp411
	movl	%ebx, %ecx	# _19,
	movl	%r15d, %edx	# _41,
	movq	24(%rsp), %rdi	# %sfp,
	call	smallints_to_fpr	#
# candidate/source/falcon-sign.c:1194: 	if (ter) {
	testl	%ebx, %ebx	# _19
	je	.L159	#,
# candidate/source/falcon-sign.c:1195: 		falcon_FFT3(f, logn, 1);
	movl	$1, %edx	#,
	movl	%r15d, %esi	# _41,
	movq	%r12, %rdi	# b01,
	call	falcon_FFT3@PLT	#
# candidate/source/falcon-sign.c:1196: 		falcon_FFT3(g, logn, 1);
	movl	$1, %edx	#,
	movl	%r15d, %esi	# _41,
	movq	40(%rsp), %rdi	# %sfp,
	call	falcon_FFT3@PLT	#
# candidate/source/falcon-sign.c:1197: 		falcon_FFT3(F, logn, 1);
	movl	$1, %edx	#,
	movl	%r15d, %esi	# _41,
	movq	%r14, %rdi	# b11,
	call	falcon_FFT3@PLT	#
# candidate/source/falcon-sign.c:1198: 		falcon_FFT3(G, logn, 1);
	movl	$1, %edx	#,
	movl	%r15d, %esi	# _41,
	movq	24(%rsp), %rdi	# %sfp,
	call	falcon_FFT3@PLT	#
# candidate/source/falcon-sign.c:1199: 		falcon_poly_neg_fft3(f, logn, 1);
	movl	$1, %edx	#,
	movl	%r15d, %esi	# _41,
	movq	%r12, %rdi	# b01,
	call	falcon_poly_neg3@PLT	#
# candidate/source/falcon-sign.c:1200: 		falcon_poly_neg_fft3(F, logn, 1);
	movl	$1, %edx	#,
	movl	%r15d, %esi	# _41,
	movq	%r14, %rdi	# b11,
	call	falcon_poly_neg3@PLT	#
# candidate/source/falcon-sign.c:1223: 		if (logn != 10 || n != 1536 || q != 18433) {
	cmpl	$10, %r15d	#, _41
	setne	%al	#, _168
# candidate/source/falcon-sign.c:1223: 		if (logn != 10 || n != 1536 || q != 18433) {
	cmpl	$18433, 56(%rsp)	#, %sfp
	setne	%dl	#, _510
	orb	%dl, %al	# _510, tmp610
	jne	.L145	#,
	cmpq	$1536, %r13	#, n
	jne	.L145	#,
# candidate/source/falcon-sign.c:1228: 		g10 = g00 + n;
	movq	8(%rsp), %r15	# %sfp, _39
	leaq	12288(%r15), %rbp	#, g10
# candidate/source/falcon-sign.c:1229: 		g11 = g10 + n;
	leaq	24576(%r15), %r14	#, g11
# candidate/source/falcon-sign.c:1230: 		gxx = g11 + n;
	leaq	36864(%r15), %rbx	#, gxx
# candidate/source/falcon-sign.c:1232: 		memcpy(g00, b00, n * sizeof *b00);
	movl	$12288, %edx	#,
	movq	40(%rsp), %r13	# %sfp, _37
	movq	%r13, %rsi	# _37,
	movq	%r15, %rdi	# _39,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1233: 		falcon_poly_mulselfadj_fft3(g00, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%r15, %rdi	# _39,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# candidate/source/falcon-sign.c:1234: 		memcpy(gxx, b01, n * sizeof *b01);
	movl	$12288, %edx	#,
	movq	%r12, %rsi	# b01,
	movq	%rbx, %rdi	# gxx,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1235: 		falcon_poly_mulselfadj_fft3(gxx, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# candidate/source/falcon-sign.c:1236: 		falcon_poly_add_fft3(g00, gxx, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%rbx, %rsi	# gxx,
	movq	%r15, %rdi	# _39,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:1238: 		memcpy(g10, b10, n * sizeof *b10);
	movl	$12288, %edx	#,
	movq	24(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# g10,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1239: 		falcon_poly_muladj_fft3(g10, b00, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%r13, %rsi	# _37,
	movq	%rbp, %rdi	# g10,
	call	falcon_poly_muladj_fft3@PLT	#
# candidate/source/falcon-sign.c:1240: 		memcpy(gxx, b11, n * sizeof *b11);
	movl	$12288, %edx	#,
	movq	48(%rsp), %r13	# %sfp, b11
	movq	%r13, %rsi	# b11,
	movq	%rbx, %rdi	# gxx,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1241: 		falcon_poly_muladj_fft3(gxx, b01, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%r12, %rsi	# b01,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_muladj_fft3@PLT	#
# candidate/source/falcon-sign.c:1242: 		falcon_poly_add_fft3(g10, gxx, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%rbx, %rsi	# gxx,
	movq	%rbp, %rdi	# g10,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:1244: 		memcpy(g11, b10, n * sizeof *b10);
	movl	$12288, %edx	#,
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# g11,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1245: 		falcon_poly_mulselfadj_fft3(g11, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%r14, %rdi	# g11,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# candidate/source/falcon-sign.c:1246: 		memcpy(gxx, b11, n * sizeof *b11);
	movl	$12288, %edx	#,
	movq	%r13, %rsi	# b11,
	movq	%rbx, %rdi	# gxx,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1247: 		falcon_poly_mulselfadj_fft3(gxx, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# candidate/source/falcon-sign.c:1248: 		falcon_poly_add_fft3(g11, gxx, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%rbx, %rsi	# gxx,
	movq	%r14, %rdi	# g11,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:718: 	t1 = t0 + tn;
	movq	%r15, %rax	# _39, _39
	leaq	40960(%r15), %r12	#, t1
# candidate/source/falcon-sign.c:719: 	t2 = t1 + tn;
	leaq	45056(%r15), %r15	#, t2
# candidate/source/falcon-sign.c:720: 	t3 = t2 + tn;
	leaq	49152(%rax), %r13	#, t3
# candidate/source/falcon-sign.c:732: 	falcon_poly_split_top_fft3(t0, t1, t2, g00, logn);
	movl	$10, %r8d	#,
	movq	%rax, 8(%rsp)	# _39, %sfp
	movq	%rax, %rcx	# _39,
	movq	%r15, %rdx	# t2,
	movq	%r12, %rsi	# t1,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_split_top_fft3@PLT	#
# candidate/source/falcon-sign.c:733: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	movl	$0, %edx	#,
	movl	$9, %esi	#,
	movq	%r12, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# candidate/source/falcon-sign.c:734: 	falcon_poly_adj_fft3(t2, logn - 1, 0);
	movl	$0, %edx	#,
	movl	$9, %esi	#,
	movq	%r15, %rdi	# t2,
	call	falcon_poly_adj_fft3@PLT	#
# candidate/source/falcon-sign.c:735: 	s += ffLDL_depth1_fft3(tree + s, t0, t1, t0, t2, t1, t0, logn - 1, t3);
	movq	16(%rsp), %rax	# %sfp, tree
	leaq	12288(%rax), %rdi	#, _277
	movq	%rdi, 72(%rsp)	# _277, %sfp
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 24776
	movq	%r13, 32(%rsp)	# t3, %sfp
	pushq	%r13	#
	.cfi_def_cfa_offset 24784
	pushq	$9	#
	.cfi_def_cfa_offset 24792
	pushq	%rbx	# gxx
	.cfi_def_cfa_offset 24800
	movq	%r12, %r9	# t1,
	movq	%r15, %r8	# t2,
	movq	%rbx, %rcx	# gxx,
	movq	%r12, %rdx	# t1,
	movq	%rbx, %rsi	# gxx,
	call	ffLDL_depth1_fft3	#
	movq	%rax, %r13	# tmp570, _278
# candidate/source/falcon-sign.c:741: 	LDL_dim2_fft3(d11, l10, g00, g10, g11, logn, 1);
	addq	$24, %rsp	#,
	.cfi_def_cfa_offset 24776
	pushq	$1	#
	.cfi_def_cfa_offset 24784
	movl	$10, %r9d	#,
	movq	%r14, %r8	# g11,
	movq	%rbp, %rcx	# g10,
	movq	24(%rsp), %r14	# %sfp, _39
	movq	%r14, %rdx	# _39,
	movq	32(%rsp), %rsi	# %sfp,
	movq	40(%rsp), %rdi	# %sfp,
	call	LDL_dim2_fft3	#
# candidate/source/falcon-sign.c:746: 	falcon_poly_split_top_fft3(t0, t1, t2, d11, logn);
	movl	$10, %r8d	#,
	movq	40(%rsp), %rcx	# %sfp,
	movq	%r15, %rdx	# t2,
	movq	%r12, %rsi	# t1,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_split_top_fft3@PLT	#
# candidate/source/falcon-sign.c:747: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	movl	$0, %edx	#,
	movl	$9, %esi	#,
	movq	%r12, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# candidate/source/falcon-sign.c:748: 	falcon_poly_adj_fft3(t2, logn - 1, 0);
	movl	$0, %edx	#,
	movl	$9, %esi	#,
	movq	%r15, %rdi	# t2,
	call	falcon_poly_adj_fft3@PLT	#
# candidate/source/falcon-sign.c:749: 	s += ffLDL_depth1_fft3(tree + s, t0, t1, t0, t2, t1, t0, logn - 1, t3);
	movq	32(%rsp), %rax	# %sfp, tree
	leaq	12288(%rax,%r13,8), %rdi	#, _281
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 24776
	pushq	32(%rsp)	# %sfp
	.cfi_def_cfa_offset 24784
	pushq	$9	#
	.cfi_def_cfa_offset 24792
	pushq	%rbx	# gxx
	.cfi_def_cfa_offset 24800
	movq	%r12, %r9	# t1,
	movq	%r15, %r8	# t2,
	movq	%rbx, %rcx	# gxx,
	movq	%r12, %rdx	# t1,
	movq	%rbx, %rsi	# gxx,
	call	ffLDL_depth1_fft3	#
# candidate/source/falcon-sign.c:851: 	smallints_to_fpr(f, f_src, logn, 1);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 24768
	leaq	128(%rsp), %rsi	#, tmp482
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%r14, %rdi	# _39,
	call	smallints_to_fpr	#
# candidate/source/falcon-sign.c:852: 	smallints_to_fpr(g, g_src, logn, 1);
	leaq	6272(%rsp), %rsi	#, tmp484
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%rbp, %rdi	# g10,
	call	smallints_to_fpr	#
# candidate/source/falcon-sign.c:853: 	falcon_FFT3(f, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%r14, %rbx	# _39, _39
	movq	%r14, %rdi	# _39,
	call	falcon_FFT3@PLT	#
# candidate/source/falcon-sign.c:854: 	falcon_FFT3(g, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%rbp, %rdi	# g10,
	call	falcon_FFT3@PLT	#
# candidate/source/falcon-sign.c:855: 	falcon_poly_mulselfadj_fft3(f, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%r14, %rdi	# _39,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# candidate/source/falcon-sign.c:856: 	falcon_poly_mulselfadj_fft3(g, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%rbp, %rdi	# g10,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# candidate/source/falcon-sign.c:857: 	falcon_poly_add_fft3(f, g, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%rbp, %rsi	# g10,
	movq	%r14, %rdi	# _39,
	call	falcon_poly_add3@PLT	#
	leaq	6144(%r14), %r15	#, _421
	movl	$0, %r12d	#, bad_lsm.249
# candidate/source/falcon-sign.c:865: 		valid &= (uint32_t)(1 ^ fpr_lt(f[u], fpr_onehalf));
	movabsq	$4602678819172646911, %r14	#, tmp486
# candidate/source/falcon-sign.c:870: 			(xb & mask) | (ft_fpr_bits(fpr_one) & ~mask));
	movabsq	$4607182418800017408, %r13	#, tmp491
.L164:
# candidate/source/falcon-sign.c:864: 		valid = (uint32_t)ft_fpr_is_positive_finite(f[u]);
	movq	(%rbx), %rbp	# MEM[(fpr *)_420], _212
	movq	%rbp, %rdi	# _212,
	call	ft_fpr_is_positive_finite	#
	movl	%eax, %edx	#, tmp571
# candidate/source/falcon-sign.c:865: 		valid &= (uint32_t)(1 ^ fpr_lt(f[u], fpr_onehalf));
	cmpq	%r14, %rbp	# tmp486, _212
	setg	%al	#, _216
	movzbl	%al, %eax	# _216, _216
# candidate/source/falcon-sign.c:865: 		valid &= (uint32_t)(1 ^ fpr_lt(f[u], fpr_onehalf));
	andl	%edx, %eax	# tmp571, valid
# candidate/source/falcon-sign.c:866: 		bad |= valid ^ 1U;
	movl	%eax, %edx	# valid, _219
	xorl	$1, %edx	#, _219
# candidate/source/falcon-sign.c:866: 		bad |= valid ^ 1U;
	orl	%edx, %r12d	# _219, bad_lsm.249
# candidate/source/falcon-sign.c:867: 		mask = (uint64_t)0 - (uint64_t)valid;
	movl	%eax, %eax	# valid, _222
# candidate/source/falcon-sign.c:870: 			(xb & mask) | (ft_fpr_bits(fpr_one) & ~mask));
	leaq	-1(%rax), %rdx	#, _227
	andq	%r13, %rdx	# tmp491, _228
# candidate/source/falcon-sign.c:870: 			(xb & mask) | (ft_fpr_bits(fpr_one) & ~mask));
	negq	%rax	# tmp492
	andq	%rax, %rbp	# tmp492, _225
# candidate/source/falcon-sign.c:869: 		f[u] = ft_fpr_from_bits(
	movq	%rdx, %rax	# _228, _228
	orq	%rbp, %rax	# _225, _228
# candidate/source/falcon-sign.c:869: 		f[u] = ft_fpr_from_bits(
	movq	%rax, (%rbx)	# _229, MEM[(fpr *)_420]
# candidate/source/falcon-sign.c:860: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbx	#, ivtmp.289
	cmpq	%r15, %rbx	# _421, ivtmp.289
	jne	.L164	#,
	movl	%r12d, 120(%rsp)	# bad_lsm.249, MEM[(unsigned int *)_557]
	movq	8(%rsp), %rbx	# %sfp, _39
	movq	%rax, 6136(%rbx)	# _229, MEM[(fpr *)_39 + 6136B]
# candidate/source/falcon-sign.c:873: 	leaves = f + hn;
	leaq	6144(%rbx), %r12	#, leaves
	movq	%r12, 24(%rsp)	# leaves, %sfp
# candidate/source/falcon-sign.c:874: 	scratch = leaves + n;
	leaq	18432(%rbx), %rbp	#, scratch
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$3, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, 40(%rsp)	# tmp572, %sfp
	movq	%r12, 56(%rsp)	# leaves, %sfp
	leaq	8192(%rbx), %rax	#, _49
	movq	%rax, 48(%rsp)	# _49, %sfp
# candidate/source/falcon-sign.c:811: 		a = ft_stable_positive(roots[u + 0], bad);
	leaq	120(%rsp), %r15	#, tmp494
	movq	%rbp, 104(%rsp)	# scratch, %sfp
.L165:
	movq	(%rbx), %rdi	# MEM[(const fpr *)_354], MEM[(const fpr *)_354]
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
	movq	%rax, %r14	# tmp573, a
# candidate/source/falcon-sign.c:812: 		b = ft_stable_positive(roots[u + 1], bad);
	movq	8(%rbx), %rdi	# MEM[(const fpr *)_354 + 8B], MEM[(const fpr *)_354 + 8B]
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
	movq	%rax, %rbp	# tmp574, b
# candidate/source/falcon-sign.c:813: 		c = ft_stable_positive(roots[u + 2], bad);
	movq	16(%rbx), %rdi	# MEM[(const fpr *)_354 + 16B], MEM[(const fpr *)_354 + 16B]
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
	movq	%rax, %r13	# tmp575, c
# candidate/source/falcon-sign.c:814: 		e1 = ft_stable_positive(fpr_add(fpr_add(a, b), c), bad);
	movq	%rbp, %rsi	# b,
	movq	%r14, %rdi	# a,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp576, _300
# candidate/source/falcon-sign.c:814: 		e1 = ft_stable_positive(fpr_add(fpr_add(a, b), c), bad);
	movq	%r13, %rsi	# c,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp577, _301
# candidate/source/falcon-sign.c:814: 		e1 = ft_stable_positive(fpr_add(fpr_add(a, b), c), bad);
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
	movq	%rax, 80(%rsp)	# tmp578, %sfp
# candidate/source/falcon-sign.c:815: 		ab = ft_stable_positive(fpr_mul(a, b), bad);
	movq	%rbp, %rsi	# b,
	movq	%r14, %rdi	# a,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp579, _303
# candidate/source/falcon-sign.c:815: 		ab = ft_stable_positive(fpr_mul(a, b), bad);
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
	movq	%rax, 88(%rsp)	# tmp580, %sfp
# candidate/source/falcon-sign.c:816: 		ac = ft_stable_positive(fpr_mul(a, c), bad);
	movq	%r13, %rsi	# c,
	movq	%r14, %rdi	# a,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp581, _305
# candidate/source/falcon-sign.c:816: 		ac = ft_stable_positive(fpr_mul(a, c), bad);
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
	movq	%rax, %r14	# tmp582, ac
# candidate/source/falcon-sign.c:817: 		bc = ft_stable_positive(fpr_mul(b, c), bad);
	movq	%r13, %rsi	# c,
	movq	%rbp, %rdi	# b,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp583, _307
# candidate/source/falcon-sign.c:817: 		bc = ft_stable_positive(fpr_mul(b, c), bad);
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
	movq	%rax, 96(%rsp)	# tmp584, %sfp
# candidate/source/falcon-sign.c:818: 		e2 = ft_stable_positive(fpr_add(fpr_add(ab, ac), bc), bad);
	movq	%r14, %rsi	# ac,
	movq	88(%rsp), %rbp	# %sfp, ab
	movq	%rbp, %rdi	# ab,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp585, _309
# candidate/source/falcon-sign.c:818: 		e2 = ft_stable_positive(fpr_add(fpr_add(ab, ac), bc), bad);
	movq	96(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp586, _310
# candidate/source/falcon-sign.c:818: 		e2 = ft_stable_positive(fpr_add(fpr_add(ab, ac), bc), bad);
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
	movq	%rax, %r14	# tmp587, e2
# candidate/source/falcon-sign.c:819: 		abc = ft_stable_positive(fpr_mul(ab, c), bad);
	movq	%r13, %rsi	# c,
	movq	%rbp, %rdi	# ab,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp588, _312
# candidate/source/falcon-sign.c:819: 		abc = ft_stable_positive(fpr_mul(ab, c), bad);
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
	movq	%rax, %r13	# tmp589, abc
# candidate/source/falcon-sign.c:820: 		leaves[v] = ft_stable_positive(fpr_div(e1, three), bad);
	movq	40(%rsp), %rsi	# %sfp,
	movq	80(%rsp), %rbp	# %sfp, e1
	movq	%rbp, %rdi	# e1,
	call	fpr_div@PLT	#
	movq	%rax, %rdi	# tmp590, _314
# candidate/source/falcon-sign.c:820: 		leaves[v] = ft_stable_positive(fpr_div(e1, three), bad);
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
# candidate/source/falcon-sign.c:820: 		leaves[v] = ft_stable_positive(fpr_div(e1, three), bad);
	movq	%rax, (%r12)	# tmp591, MEM[(fpr *)_353]
# candidate/source/falcon-sign.c:821: 		leaves[256 + v] = ft_stable_positive(fpr_div(e2, e1), bad);
	movq	%rbp, %rsi	# e1,
	movq	%r14, %rdi	# e2,
	call	fpr_div@PLT	#
	movq	%rax, %rdi	# tmp592, _319
# candidate/source/falcon-sign.c:821: 		leaves[256 + v] = ft_stable_positive(fpr_div(e2, e1), bad);
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
# candidate/source/falcon-sign.c:821: 		leaves[256 + v] = ft_stable_positive(fpr_div(e2, e1), bad);
	movq	%rax, 2048(%r12)	# tmp593, MEM[(fpr *)_353 + 2048B]
# candidate/source/falcon-sign.c:822: 		leaves[512 + v] = ft_stable_positive(
	movq	%r13, %rsi	# abc,
	movq	40(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp594, _324
# candidate/source/falcon-sign.c:822: 		leaves[512 + v] = ft_stable_positive(
	movq	%r14, %rsi	# e2,
	call	fpr_div@PLT	#
	movq	%rax, %rdi	# tmp595, _325
# candidate/source/falcon-sign.c:822: 		leaves[512 + v] = ft_stable_positive(
	movq	%r15, %rsi	# tmp494,
	call	ft_stable_positive	#
# candidate/source/falcon-sign.c:822: 		leaves[512 + v] = ft_stable_positive(
	movq	%rax, 4096(%r12)	# tmp596, MEM[(fpr *)_353 + 4096B]
# candidate/source/falcon-sign.c:808: 	for (u = 0, v = 0; u < 768; u += 3, v ++) {
	addq	$24, %rbx	#, ivtmp.279
	addq	$8, %r12	#, ivtmp.280
	cmpq	%r12, 48(%rsp)	# ivtmp.280, %sfp
	jne	.L165	#,
# candidate/source/falcon-sign.c:825: 	ft_stable_binary_inplace(leaves + 0, 256, scratch, bad);
	movq	104(%rsp), %rbp	# %sfp, scratch
	leaq	120(%rsp), %rbx	#, tmp509
	movq	%rbx, %rcx	# tmp509,
	movq	%rbp, %rdx	# scratch,
	movl	$256, %esi	#,
	movq	24(%rsp), %rdi	# %sfp,
	call	ft_stable_binary_inplace	#
# candidate/source/falcon-sign.c:826: 	ft_stable_binary_inplace(leaves + 256, 256, scratch, bad);
	movq	8(%rsp), %r13	# %sfp, _39
	leaq	8192(%r13), %rdi	#, _332
	movq	%rbx, %rcx	# tmp509,
	movq	%rbp, %rdx	# scratch,
	movl	$256, %esi	#,
	call	ft_stable_binary_inplace	#
# candidate/source/falcon-sign.c:827: 	ft_stable_binary_inplace(leaves + 512, 256, scratch, bad);
	leaq	10240(%r13), %rdi	#, _333
	movq	%rbx, %rcx	# tmp509,
	movq	%rbp, %rdx	# scratch,
	movl	$256, %esi	#,
	call	ft_stable_binary_inplace	#
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$339775489, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rbx	# tmp597, _235
# candidate/source/falcon-sign.c:878: 		leaves[n - 1 - u] = ft_stable_positive(
	leaq	120(%rsp), %rbp	#, tmp515
	movq	64(%rsp), %r12	# %sfp, ivtmp.269
.L166:
# candidate/source/falcon-sign.c:878: 		leaves[n - 1 - u] = ft_stable_positive(
	movq	6144(%r13,%r12), %rsi	# MEM[(fpr *)_39 + 6144B + ivtmp.269_521 * 1], MEM[(fpr *)_39 + 6144B + ivtmp.269_521 * 1]
	movq	%rbx, %rdi	# _235,
	call	fpr_div@PLT	#
	movq	%rax, %rdi	# tmp598, _240
# candidate/source/falcon-sign.c:878: 		leaves[n - 1 - u] = ft_stable_positive(
	movq	%rbp, %rsi	# tmp515,
	call	ft_stable_positive	#
	movq	%rax, %rdx	#, tmp599
# candidate/source/falcon-sign.c:878: 		leaves[n - 1 - u] = ft_stable_positive(
	movq	%r12, %rax	# ivtmp.269, _474
	negq	%rax	# _474
	movq	%rdx, 18424(%r13,%rax)	# tmp599, MEM[(fpr *)_39 + 18424B + _474 * 1]
# candidate/source/falcon-sign.c:877: 	for (u = 0; u < hn; u ++) {
	addq	$8, %r12	#, ivtmp.269
	cmpq	$6144, %r12	#, ivtmp.269
	jne	.L166	#,
	movq	8(%rsp), %r14	# %sfp, _39
	addq	$18432, %r14	#, _39
# candidate/source/falcon-sign.c:887: 		leaves[u] = ft_stable_positive(leaves[u], &bad);
	leaq	120(%rsp), %r13	#, tmp517
# candidate/source/falcon-sign.c:889: 		valid = (uint32_t)(1 ^ (uint32_t)((bits - FT1536_LEAF_MIN_BITS) >> 63));
	movabsq	$-4652218416473572215, %r12	#, tmp520
# candidate/source/falcon-sign.c:890: 		valid &= (uint32_t)(1 ^ (uint32_t)((FT1536_LEAF_MAX_BITS - bits) >> 63));
	movabsq	$4689448209939135824, %rbp	#, tmp523
	movq	56(%rsp), %r15	# %sfp, ivtmp.256
.L167:
# candidate/source/falcon-sign.c:887: 		leaves[u] = ft_stable_positive(leaves[u], &bad);
	movq	(%r15), %rdi	# MEM[(fpr *)_527], MEM[(fpr *)_527]
	movq	%r13, %rsi	# tmp517,
	call	ft_stable_positive	#
	movq	%rax, %rdx	# tmp600, _251
# candidate/source/falcon-sign.c:887: 		leaves[u] = ft_stable_positive(leaves[u], &bad);
	movq	%rax, (%r15)	# _251, MEM[(fpr *)_527]
# candidate/source/falcon-sign.c:889: 		valid = (uint32_t)(1 ^ (uint32_t)((bits - FT1536_LEAF_MIN_BITS) >> 63));
	leaq	(%rax,%r12), %rax	#, _253
# candidate/source/falcon-sign.c:889: 		valid = (uint32_t)(1 ^ (uint32_t)((bits - FT1536_LEAF_MIN_BITS) >> 63));
	shrq	$63, %rax	#, _254
# candidate/source/falcon-sign.c:889: 		valid = (uint32_t)(1 ^ (uint32_t)((bits - FT1536_LEAF_MIN_BITS) >> 63));
	xorl	$1, %eax	#, valid
# candidate/source/falcon-sign.c:890: 		valid &= (uint32_t)(1 ^ (uint32_t)((FT1536_LEAF_MAX_BITS - bits) >> 63));
	movq	%rbp, %rbx	# tmp523, _257
	subq	%rdx, %rbx	# _251, _257
# candidate/source/falcon-sign.c:890: 		valid &= (uint32_t)(1 ^ (uint32_t)((FT1536_LEAF_MAX_BITS - bits) >> 63));
	shrq	$63, %rbx	#, _258
# candidate/source/falcon-sign.c:890: 		valid &= (uint32_t)(1 ^ (uint32_t)((FT1536_LEAF_MAX_BITS - bits) >> 63));
	xorl	$1, %ebx	#, _260
# candidate/source/falcon-sign.c:890: 		valid &= (uint32_t)(1 ^ (uint32_t)((FT1536_LEAF_MAX_BITS - bits) >> 63));
	andl	%eax, %ebx	# valid, valid_261
# candidate/source/falcon-sign.c:891: 		bad |= valid ^ 1U;
	xorl	$1, %ebx	#, _262
# candidate/source/falcon-sign.c:891: 		bad |= valid ^ 1U;
	orl	120(%rsp), %ebx	# MEM[(unsigned int *)_557], _264
	movl	%ebx, 120(%rsp)	# _264, MEM[(unsigned int *)_557]
# candidate/source/falcon-sign.c:883: 	for (u = 0; u < n; u ++) {
	addq	$8, %r15	#, ivtmp.256
	cmpq	%r14, %r15	# _523, ivtmp.256
	jne	.L167	#,
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$768, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %r12	# tmp601, _175
# candidate/source/falcon-sign.c:1028: 	leaf_index = 0;
	movq	$0, 120(%rsp)	#, MEM[(long unsigned int *)_557]
# candidate/source/falcon-sign.c:1030: 	s += ffLDL_ternary_normalize_depth1(
	leaq	120(%rsp), %r13	#, tmp528
	movq	%r13, %r8	# tmp528,
	movq	24(%rsp), %r14	# %sfp, leaves
	movq	%r14, %rcx	# leaves,
	movl	$9, %edx	#,
	movq	%rax, %rsi	# _175,
	movq	72(%rsp), %rdi	# %sfp,
	call	ffLDL_ternary_normalize_depth1	#
# candidate/source/falcon-sign.c:1030: 	s += ffLDL_ternary_normalize_depth1(
	leaq	1536(%rax), %rbp	#, s
# candidate/source/falcon-sign.c:1032: 	s += ffLDL_ternary_normalize_depth1(
	movq	16(%rsp), %rax	# %sfp, tree
	leaq	(%rax,%rbp,8), %rdi	#, _200
	movq	%r13, %r8	# tmp528,
	movq	%r14, %rcx	# leaves,
	movl	$9, %edx	#,
	movq	%r12, %rsi	# _175,
	call	ffLDL_ternary_normalize_depth1	#
# candidate/source/falcon-sign.c:1038: 	*leaf_count = leaf_index;
	movq	120(%rsp), %rdx	# MEM[(long unsigned int *)_557], leaf_index.20_203
# candidate/source/falcon-sign.c:1267: 			&& leaf_count == n
	testl	%ebx, %ebx	# _264
	jne	.L145	#,
	cmpq	$1536, %rdx	#, leaf_index.20_203
	jne	.L145	#,
# candidate/source/falcon-sign.c:1032: 	s += ffLDL_ternary_normalize_depth1(
	addq	%rax, %rbp	# _201, s_202
# candidate/source/falcon-sign.c:3267: 	if (!load_skey(fs->sk, fs->q, ske[0], ske[1], ske[2], ske[3],
	cmpq	$18432, %rbp	#, s_202
	jne	.L145	#,
# candidate/source/falcon-sign.c:3272: 	return 1;
	movl	$1, %eax	#, <retval>
	jmp	.L144	#
.L159:
# candidate/source/falcon-sign.c:1202: 		falcon_FFT(f, logn);
	movl	%r15d, %esi	# _41,
	movq	%r12, %rdi	# b01,
	call	falcon_FFT@PLT	#
# candidate/source/falcon-sign.c:1203: 		falcon_FFT(g, logn);
	movl	%r15d, %esi	# _41,
	movq	40(%rsp), %rdi	# %sfp,
	call	falcon_FFT@PLT	#
# candidate/source/falcon-sign.c:1204: 		falcon_FFT(F, logn);
	movl	%r15d, %esi	# _41,
	movq	48(%rsp), %rbx	# %sfp, b11
	movq	%rbx, %rdi	# b11,
	call	falcon_FFT@PLT	#
# candidate/source/falcon-sign.c:1205: 		falcon_FFT(G, logn);
	movl	%r15d, %esi	# _41,
	movq	24(%rsp), %rdi	# %sfp,
	call	falcon_FFT@PLT	#
# candidate/source/falcon-sign.c:1206: 		falcon_poly_neg_fft(f, logn);
	movl	%r15d, %esi	# _41,
	movq	%r12, %rdi	# b01,
	call	falcon_poly_neg@PLT	#
# candidate/source/falcon-sign.c:1207: 		falcon_poly_neg_fft(F, logn);
	movl	%r15d, %esi	# _41,
	movq	%rbx, 48(%rsp)	# b11, %sfp
	movq	%rbx, %rdi	# b11,
	call	falcon_poly_neg@PLT	#
# candidate/source/falcon-sign.c:1277: 		g01 = g00 + n;
	movq	8(%rsp), %rax	# %sfp, _39
	leaq	(%rax,%rbp), %r13	#, g01
# candidate/source/falcon-sign.c:1278: 		g11 = g01 + n;
	leaq	0(%r13,%rbp), %r14	#, g11
	movq	%r14, 32(%rsp)	# g11, %sfp
# candidate/source/falcon-sign.c:1279: 		gxx = g11 + n;
	leaq	(%r14,%rbp), %rbx	#, gxx
# candidate/source/falcon-sign.c:1281: 		memcpy(g00, b00, n * sizeof *b00);
	movq	%rbp, %rdx	# _160,
	movq	40(%rsp), %rsi	# %sfp,
	movq	%rax, %rdi	# _39,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1282: 		falcon_poly_mulselfadj_fft(g00, logn);
	movl	%r15d, %esi	# _41,
	movq	8(%rsp), %rdi	# %sfp,
	call	falcon_poly_mulselfadj_fft@PLT	#
# candidate/source/falcon-sign.c:1283: 		memcpy(gxx, b01, n * sizeof *b01);
	movq	%rbp, %rdx	# _160,
	movq	%r12, %rsi	# b01,
	movq	%rbx, %rdi	# gxx,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1284: 		falcon_poly_mulselfadj_fft(gxx, logn);
	movl	%r15d, %esi	# _41,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_mulselfadj_fft@PLT	#
# candidate/source/falcon-sign.c:1285: 		falcon_poly_add_fft(g00, gxx, logn);
	movl	%r15d, %edx	# _41,
	movq	%rbx, %rsi	# gxx,
	movq	8(%rsp), %rdi	# %sfp,
	call	falcon_poly_add@PLT	#
# candidate/source/falcon-sign.c:1287: 		memcpy(g01, b00, n * sizeof *b00);
	movq	%rbp, %rdx	# _160,
	movq	40(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# g01,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1288: 		falcon_poly_muladj_fft(g01, b10, logn);
	movl	%r15d, %edx	# _41,
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# g01,
	call	falcon_poly_muladj_fft@PLT	#
# candidate/source/falcon-sign.c:1289: 		memcpy(gxx, b01, n * sizeof *b01);
	movq	%rbp, %rdx	# _160,
	movq	%r12, %rsi	# b01,
	movq	%rbx, %rdi	# gxx,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1290: 		falcon_poly_muladj_fft(gxx, b11, logn);
	movl	%r15d, %edx	# _41,
	movq	48(%rsp), %r12	# %sfp, b11
	movq	%r12, %rsi	# b11,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_muladj_fft@PLT	#
# candidate/source/falcon-sign.c:1291: 		falcon_poly_add_fft(g01, gxx, logn);
	movl	%r15d, %edx	# _41,
	movq	%rbx, %rsi	# gxx,
	movq	%r13, %rdi	# g01,
	call	falcon_poly_add@PLT	#
# candidate/source/falcon-sign.c:1293: 		memcpy(g11, b10, n * sizeof *b10);
	movq	%rbp, %rdx	# _160,
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# g11,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1294: 		falcon_poly_mulselfadj_fft(g11, logn);
	movl	%r15d, %esi	# _41,
	movq	%r14, %rdi	# g11,
	call	falcon_poly_mulselfadj_fft@PLT	#
# candidate/source/falcon-sign.c:1295: 		memcpy(gxx, b11, n * sizeof *b11);
	movq	%rbp, %rdx	# _160,
	movq	%r12, %rsi	# b11,
	movq	%rbx, %rdi	# gxx,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1296: 		falcon_poly_mulselfadj_fft(gxx, logn);
	movl	%r15d, %esi	# _41,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_mulselfadj_fft@PLT	#
# candidate/source/falcon-sign.c:1297: 		falcon_poly_add_fft(g11, gxx, logn);
	movl	%r15d, %edx	# _41,
	movq	%rbx, %rsi	# gxx,
	movq	%r14, %rdi	# g11,
	call	falcon_poly_add@PLT	#
# candidate/source/falcon-sign.c:413: 	if (n == 1) {
	testl	%r15d, %r15d	# _41
	jne	.L184	#,
# candidate/source/falcon-sign.c:414: 		tree[0] = g00[0];
	movq	8(%rsp), %rax	# %sfp, _39
	movq	(%rax), %rax	# MEM[(const fpr *)_39], MEM[(const fpr *)_39]
	movq	16(%rsp), %rbx	# %sfp, tree
	movq	%rax, (%rbx)	# MEM[(const fpr *)_39], *tree_167
.L169:
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$100, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rbx	# tmp604, _183
	movl	$0, %esi	#,
	movl	$155, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp605, _184
# candidate/source/falcon-sign.c:1308: 		sigma = fpr_mul(fpr_sqrt(fpr_of(q)),
	movq	%rbx, %rsi	# _183,
	call	fpr_div@PLT	#
	movq	%rax, %rbx	# tmp606, _185
# candidate/source/falcon-sign.c:1308: 		sigma = fpr_mul(fpr_sqrt(fpr_of(q)),
	movl	56(%rsp), %edi	# %sfp, _186
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp607, _187
# candidate/source/falcon-sign.c:1308: 		sigma = fpr_mul(fpr_sqrt(fpr_of(q)),
	call	fpr_sqrt@PLT	#
	movq	%rax, %rdi	# tmp608, _188
# candidate/source/falcon-sign.c:1308: 		sigma = fpr_mul(fpr_sqrt(fpr_of(q)),
	movq	%rbx, %rsi	# _185,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp609, sigma
# candidate/source/falcon-sign.c:1314: 		ffLDL_binary_normalize(tree, sigma, logn);
	movl	%r15d, %edx	# _41,
	movq	16(%rsp), %rdi	# %sfp,
	call	ffLDL_binary_normalize	#
# candidate/source/falcon-sign.c:3272: 	return 1;
	movl	$1, %eax	#, <retval>
	jmp	.L144	#
.L184:
# candidate/source/falcon-sign.c:412: 	n = MKN(logn, 0);
	movl	$1, %eax	#, tmp538
	movl	%r15d, %ecx	# _41, tmp731
	salq	%cl, %rax	# tmp731, tmp538
	movq	%rax, 24(%rsp)	# tmp538, %sfp
# candidate/source/falcon-sign.c:419: 	d11 = tmp + n;
	movl	$8, %r12d	#, tmp539
	salq	%cl, %r12	# tmp732, _337
# candidate/source/falcon-sign.c:419: 	d11 = tmp + n;
	leaq	(%rbx,%r12), %r14	#, d11
# candidate/source/falcon-sign.c:420: 	tmp += n << 1;
	movl	$16, %eax	#, tmp541
	salq	%cl, %rax	# tmp733, _339
	leaq	(%rbx,%rax), %rbp	#, tmp
# candidate/source/falcon-sign.c:422: 	memcpy(d00, g00, n * sizeof *g00);
	movq	%r12, %rdx	# _337,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# gxx,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:423: 	LDL_fft(d11, tree, g00, g01, g11, logn, tmp);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 24776
	pushq	%rbp	# tmp
	.cfi_def_cfa_offset 24784
	movl	%r15d, %r9d	# _41,
	movq	48(%rsp), %r8	# %sfp,
	movq	%r13, %rcx	# g01,
	movq	24(%rsp), %rdx	# %sfp,
	movq	32(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# d11,
	call	LDL_fft	#
# candidate/source/falcon-sign.c:417: 	hn = n >> 1;
	movq	40(%rsp), %r13	# %sfp, hn_336
	shrq	%r13	# hn_336
# candidate/source/falcon-sign.c:425: 	falcon_poly_split_fft(tmp, tmp + hn, d00, logn);
	salq	$3, %r13	#, _341
# candidate/source/falcon-sign.c:425: 	falcon_poly_split_fft(tmp, tmp + hn, d00, logn);
	leaq	0(%rbp,%r13), %rsi	#, _342
	movl	%r15d, %ecx	# _41,
	movq	%rbx, %rdx	# gxx,
	movq	%rbp, %rdi	# tmp,
	call	falcon_poly_split_fft@PLT	#
# candidate/source/falcon-sign.c:426: 	falcon_poly_split_fft(d00, d00 + hn, d11, logn);
	leaq	(%rbx,%r13), %rdx	#, _343
	movq	%rdx, %r10	# _343, _343
	movl	%r15d, %ecx	# _41,
	movq	%r14, %rdx	# d11,
	movq	%r10, 24(%rsp)	# _343, %sfp
	movq	%r10, %rsi	# _343,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_split_fft@PLT	#
# candidate/source/falcon-sign.c:427: 	memcpy(d11, tmp, n * sizeof *tmp);
	movq	%r12, %rdx	# _337,
	movq	%rbp, %rsi	# tmp,
	movq	%r14, %rdi	# d11,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:428: 	ffLDL_fft_inner(tree + n,
	leal	-1(%r15), %r11d	#, _344
	leaq	(%r14,%r13), %rdx	#, _345
	movq	32(%rsp), %rdi	# %sfp, tree
	addq	%r12, %rdi	# _337, _346
	movq	%rbp, %r8	# tmp,
	movl	%r11d, %r12d	# _344, _344
	movl	%r11d, %ecx	# _344,
	movq	%r14, %rsi	# d11,
	call	ffLDL_fft_inner	#
# candidate/source/falcon-sign.c:430: 	ffLDL_fft_inner(tree + n + ffLDL_treesize(logn - 1),
	movl	%r15d, %eax	# _41, _348
	movl	%r12d, %ecx	# _344, tmp739
	sall	%cl, %eax	# tmp739, _348
	movq	40(%rsp), %r13	# %sfp, n
	addq	%r13, %rax	# n, _349
# candidate/source/falcon-sign.c:430: 	ffLDL_fft_inner(tree + n + ffLDL_treesize(logn - 1),
	movq	32(%rsp), %rdi	# %sfp, tree
	leaq	(%rdi,%rax,8), %rdi	#, _351
	movq	%rbp, %r8	# tmp,
	movl	%r12d, %ecx	# _344,
	movq	24(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# gxx,
	call	ffLDL_fft_inner	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 24768
	jmp	.L169	#
	.cfi_endproc
.LFE85:
	.size	falcon_sign_set_private_key, .-falcon_sign_set_private_key
	.globl	falcon_sign_start_external_nonce
	.type	falcon_sign_start_external_nonce, @function
falcon_sign_start_external_nonce:
.LFB87:
	.cfi_startproc
	pushq	%r12	#
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp	#
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx	#
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rdi, %rbx	# tmp102, fs
	movq	%rsi, %rbp	# tmp103, r
	movq	%rdx, %r12	# tmp104, rlen
# candidate/source/falcon-sign.c:3295: 	shake_init(&fs->sc, 512);
	movl	$512, %esi	#,
	call	shake_init@PLT	#
# candidate/source/falcon-sign.c:3296: 	shake_inject(&fs->sc, r, rlen);
	movq	%r12, %rdx	# rlen,
	movq	%rbp, %rsi	# r,
	movq	%rbx, %rdi	# fs,
	call	shake_inject@PLT	#
# candidate/source/falcon-sign.c:3297: }
	popq	%rbx	#
	.cfi_def_cfa_offset 24
	popq	%rbp	#
	.cfi_def_cfa_offset 16
	popq	%r12	#
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
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx	#
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx	# tmp104, fs
	movq	%rsi, %rbp	# tmp105, r
# candidate/source/falcon-sign.c:3283: 	if (!rng_ready(fs)) {
	call	rng_ready	#
# candidate/source/falcon-sign.c:3283: 	if (!rng_ready(fs)) {
	testl	%eax, %eax	# <retval>
	jne	.L190	#,
.L187:
# candidate/source/falcon-sign.c:3289: }
	addq	$8, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx	#
	.cfi_def_cfa_offset 16
	popq	%rbp	#
	.cfi_def_cfa_offset 8
	ret	
.L190:
	.cfi_restore_state
# candidate/source/falcon-sign.c:3286: 	shake_extract(&fs->rng, r, 40);
	leaq	416(%rbx), %rdi	#, _2
	movl	$40, %edx	#,
	movq	%rbp, %rsi	# r,
	call	shake_extract@PLT	#
# candidate/source/falcon-sign.c:3287: 	falcon_sign_start_external_nonce(fs, r, 40);
	movl	$40, %edx	#,
	movq	%rbp, %rsi	# r,
	movq	%rbx, %rdi	# fs,
	call	falcon_sign_start_external_nonce	#
# candidate/source/falcon-sign.c:3288: 	return 1;
	movl	$1, %eax	#, <retval>
	jmp	.L187	#
	.cfi_endproc
.LFE86:
	.size	falcon_sign_start, .-falcon_sign_start
	.globl	falcon_sign_update
	.type	falcon_sign_update, @function
falcon_sign_update:
.LFB88:
	.cfi_startproc
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
# candidate/source/falcon-sign.c:3303: 	shake_inject(&fs->sc, data, len);
	call	shake_inject@PLT	#
# candidate/source/falcon-sign.c:3304: }
	addq	$8, %rsp	#,
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
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$27384, %rsp	#,
	.cfi_def_cfa_offset 27440
	movq	%rdi, 24(%rsp)	# fs, %sfp
# candidate/source/falcon-sign.c:3316: 		return 0;
	movl	$0, %eax	#, <retval>
# candidate/source/falcon-sign.c:3315: 	if (fs->sk == NULL) {
	cmpq	$0, 856(%rdi)	#, fs_39(D)->sk
	je	.L193	#,
	movq	%rsi, %r12	# tmp669, sig
	movq	%rdx, %rbx	# tmp670, sig_max_len
	movl	%ecx, %r13d	# tmp671, comp
	movq	%rdi, %r15	# fs, fs
# candidate/source/falcon-sign.c:3318: 	if (!rng_ready(fs)) {
	call	rng_ready	#
# candidate/source/falcon-sign.c:3321: 	if (sig_max_len < 2) {
	testl	%eax, %eax	# tmp672
	je	.L208	#,
	cmpq	$1, %rbx	#, sig_max_len
	jbe	.L208	#,
# candidate/source/falcon-sign.c:3324: 	shake_flip(&fs->sc);
	movq	%r15, %rdi	# fs,
	call	shake_flip@PLT	#
# candidate/source/falcon-sign.c:3325: 	falcon_hash_to_point(&fs->sc, fs->q, hm, fs->logn);
	movq	%r15, %rdi	# fs, fs
	movl	844(%r15), %ecx	# fs_39(D)->logn, fs_39(D)->logn
	leaq	21232(%rsp), %rdx	#, tmp396
	movl	840(%r15), %esi	# fs_39(D)->q, fs_39(D)->q
	call	falcon_hash_to_point@PLT	#
	movl	$16, 184(%rsp)	#, %sfp
# candidate/source/fpr-emulated.h:163: 	x ^= (uint64_t)1 << 63;
	movq	%r12, 168(%rsp)	# sig, %sfp
	movq	%rbx, 176(%rsp)	# sig_max_len, %sfp
	movl	%r13d, 188(%rsp)	# comp, %sfp
	jmp	.L206	#
.L195:
# candidate/source/falcon-sign.c:3361: 			falcon_prng_init(&p, &fs->rng, 0);
	movq	24(%rsp), %rax	# %sfp, fs
	leaq	416(%rax), %rsi	#, _8
	leaq	192(%rsp), %rbx	#, tmp401
	movl	$0, %edx	#,
	movq	%rbx, %rdi	# tmp401,
	call	falcon_prng_init@PLT	#
# candidate/source/falcon-sign.c:3363: 			samp_ctx = &p;
	movq	%rbx, 88(%rsp)	# tmp401, %sfp
# candidate/source/falcon-sign.c:3362: 			samp = sampler;
	leaq	sampler(%rip), %rax	#, samp
	movq	%rax, 80(%rsp)	# samp, %sfp
	jmp	.L196	#
.L199:
# candidate/source/falcon-sign.c:1940: 		falcon_FFT(t0, logn);
	movl	%ebp, %esi	# _11,
	movq	%rbx, %rdi	# _9,
	call	falcon_FFT@PLT	#
# candidate/source/falcon-sign.c:1941: 		ni = fpr_inverse_of(q);
	movl	72(%rsp), %edi	# %sfp, _109
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp676, _261
# candidate/source/fpr-emulated.h:95: 	return fpr_div(fpr_one, fpr_of(i));
	movabsq	$4607182418800017408, %rdi	#,
	call	fpr_div@PLT	#
	movq	%rax, %r13	# tmp677, _262
# candidate/source/falcon-sign.c:1942: 		memcpy(t1, t0, n * sizeof *t0);
	movq	32(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# _9,
	movq	%r12, %rdi	# t1,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1943: 		falcon_poly_mul_fft(t1, b01, logn);
	movl	%ebp, %edx	# _11,
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# t1,
	call	falcon_poly_mul_fft@PLT	#
# candidate/source/fpr-emulated.h:163: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rax	#, x_111
	xorq	%r13, %rax	# _262, x_111
	movq	%rax, %rsi	# x_111, x_111
# candidate/source/falcon-sign.c:1944: 		falcon_poly_mulconst_fft(t1, fpr_neg(ni), logn);
	movl	%ebp, %edx	# _11,
	movq	%r12, %rdi	# t1,
	call	falcon_poly_mulconst@PLT	#
# candidate/source/falcon-sign.c:1945: 		falcon_poly_mul_fft(t0, b11, logn);
	movl	%ebp, %edx	# _11,
	movq	56(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# _9,
	call	falcon_poly_mul_fft@PLT	#
# candidate/source/falcon-sign.c:1946: 		falcon_poly_mulconst_fft(t0, ni, logn);
	movl	%ebp, %edx	# _11,
	movq	%r13, %rsi	# _262,
	movq	%rbx, %rdi	# _9,
	call	falcon_poly_mulconst@PLT	#
# candidate/source/falcon-sign.c:1951: 		ffSampling_fft(samp, samp_ctx, tx, ty, tree, t0, t1, logn, tz);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 27448
	pushq	48(%rsp)	# %sfp
	.cfi_def_cfa_offset 27456
	pushq	%rbp	# _11
	.cfi_def_cfa_offset 27464
	pushq	%r12	# t1
	.cfi_def_cfa_offset 27472
	movq	%rbx, %r9	# _9,
	movq	96(%rsp), %r8	# %sfp,
	movq	48(%rsp), %r14	# %sfp, ty
	movq	%r14, %rcx	# ty,
	movq	40(%rsp), %rdx	# %sfp,
	movq	120(%rsp), %rsi	# %sfp,
	movq	112(%rsp), %rdi	# %sfp,
	call	ffSampling_fft	#
# candidate/source/falcon-sign.c:1956: 		memcpy(t0, tx, n * sizeof *tx);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 27440
	movq	32(%rsp), %r13	# %sfp, _71
	movq	%r13, %rdx	# _71,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# _9,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1957: 		memcpy(t1, ty, n * sizeof *ty);
	movq	%r13, %rdx	# _71,
	movq	%r14, %rsi	# ty,
	movq	%r12, %rdi	# t1,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1958: 		falcon_poly_mul_fft(tx, b00, logn);
	movl	%ebp, %edx	# _11,
	movq	112(%rsp), %rsi	# %sfp,
	movq	8(%rsp), %rdi	# %sfp,
	call	falcon_poly_mul_fft@PLT	#
# candidate/source/falcon-sign.c:1959: 		falcon_poly_mul_fft(ty, b10, logn);
	movl	%ebp, %edx	# _11,
	movq	120(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# ty,
	call	falcon_poly_mul_fft@PLT	#
# candidate/source/falcon-sign.c:1960: 		falcon_poly_add(tx, ty, logn);
	movl	%ebp, %edx	# _11,
	movq	%r14, %rsi	# ty,
	movq	8(%rsp), %rdi	# %sfp,
	call	falcon_poly_add@PLT	#
# candidate/source/falcon-sign.c:1961: 		memcpy(ty, t0, n * sizeof *t0);
	movq	%r13, %rdx	# _71,
	movq	%rbx, %rsi	# _9,
	movq	%r14, %rdi	# ty,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1962: 		falcon_poly_mul_fft(ty, b01, logn);
	movl	%ebp, %edx	# _11,
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# ty,
	call	falcon_poly_mul_fft@PLT	#
# candidate/source/falcon-sign.c:1964: 		memcpy(t0, tx, n * sizeof *tx);
	movq	%r13, %rdx	# _71,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# _9,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1965: 		falcon_poly_mul_fft(t1, b11, logn);
	movl	%ebp, %edx	# _11,
	movq	56(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# t1,
	call	falcon_poly_mul_fft@PLT	#
# candidate/source/falcon-sign.c:1966: 		falcon_poly_add_fft(t1, ty, logn);
	movl	%ebp, %edx	# _11,
	movq	%r14, %rsi	# ty,
	movq	%r12, %rdi	# t1,
	call	falcon_poly_add@PLT	#
# candidate/source/falcon-sign.c:1968: 		falcon_iFFT(t0, logn);
	movl	%ebp, %esi	# _11,
	movq	%rbx, %rdi	# _9,
	call	falcon_iFFT@PLT	#
# candidate/source/falcon-sign.c:1969: 		falcon_iFFT(t1, logn);
	movl	%ebp, %esi	# _11,
	movq	%r12, %rdi	# t1,
	call	falcon_iFFT@PLT	#
# candidate/source/falcon-sign.c:1974: 		for (u = 0; u < n; u ++) {
	testq	%r15, %r15	# n
	je	.L200	#,
# candidate/source/falcon-sign.c:1974: 		for (u = 0; u < n; u ++) {
	movl	$0, %esi	#, u
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387904, %r13	#, tmp568
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	$1085, %ebp	#, tmp570
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	$1021, %r11d	#, tmp572
# candidate/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	$63, %r10d	#, tmp576
.L202:
# candidate/source/falcon-sign.c:1985: 			s1[u] = (int16_t)(hm[u] - fpr_rint(t0[u]));
	movq	(%rbx,%rsi,8), %rdx	# MEM[(fpr *)_9 + u_244 * 8], _118
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdx, %rcx	# _118, _317
	salq	$10, %rcx	#, _317
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp798
	andq	%rax, %rcx	# tmp798, _318
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r13, %rcx	# tmp568, m
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rdx, %rdi	# _118, _320
	shrq	$52, %rdi	#, _320
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %edi	#, _322
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%ebp, %r14d	# tmp570, e
	subl	%edi, %r14d	# _322, e
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r11d, %r9d	# tmp572, _324
	subl	%edi, %r9d	# _322, _324
	movl	%r9d, %eax	# _324, _324
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _326
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _326, _327
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp575
	andq	%rcx, %rax	# m, m
# candidate/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r14d, %r8d	# e, e
	andl	$63, %r8d	#, e
# candidate/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	%r10d, %ecx	# tmp576, _330
	subl	%r8d, %ecx	# e, _330
# candidate/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdi	# m, _331
	salq	$32, %rdi	#, _331
# candidate/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _330
	cmove	%rax, %rdi	# _331,, m, x_337
# candidate/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _338
# candidate/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdi	# _338, _339
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdi, %r9	# _339, _341
	shrq	$32, %r9	#, _341
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r9d	#, _343
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edi, %r9d	# _339, dd
# candidate/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _351
	shrq	$32, %rcx	#, _351
# candidate/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r8d	#, tmp682
	movq	%rax, %r8	# m, m
	cmovne	%rcx, %r8	# _351,, m
# candidate/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r14d, %ecx	# e, e
	andl	$31, %ecx	#, e
# candidate/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %r8	# _358, _359
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r9d, %ecx	# dd, _347
	negl	%ecx	# _347
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r9d, %ecx	# dd, _348
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _349
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdi	#, _345
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edi, %ecx	# _345, f_350
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %edi	#, _360
	shrl	%cl, %edi	# f_350, _360
	movl	%edi, %eax	# _360, _360
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %eax	#, _362
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%r8, %rax	# _359, m_363
# candidate/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rdx, %rcx	# _118, _366
	sarq	$63, %rcx	#, _366
	xorq	%rcx, %rax	# _366, _368
# candidate/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rdx	#, _364
# candidate/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rdx, %rax	# _364, _370
# candidate/source/falcon-sign.c:1985: 			s1[u] = (int16_t)(hm[u] - fpr_rint(t0[u]));
	movzwl	21232(%rsp,%rsi,2), %edx	# MEM[(const uint16_t *)&hm + u_244 * 2], _121
	subl	%eax, %edx	# _370, _121
# candidate/source/falcon-sign.c:1985: 			s1[u] = (int16_t)(hm[u] - fpr_rint(t0[u]));
	movw	%dx, 15088(%rsp,%rsi,2)	# _121, MEM[(int16_t *)&s1 + u_244 * 2]
# candidate/source/falcon-sign.c:1986: 			s2[u] = (int16_t)-fpr_rint(t1[u]);
	movq	(%r12,%rsi,8), %rdx	# MEM[(fpr *)t1_72 + u_244 * 8], _125
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdx, %rcx	# _125, _263
	salq	$10, %rcx	#, _263
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp814
	andq	%rax, %rcx	# tmp814, _264
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r13, %rcx	# tmp568, m
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rdx, %rdi	# _125, _266
	shrq	$52, %rdi	#, _266
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %edi	#, _268
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%ebp, %r14d	# tmp570, e
	subl	%edi, %r14d	# _268, e
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r11d, %eax	# tmp572, _270
	subl	%edi, %eax	# _268, _270
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _272
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _272, _273
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp619
	andq	%rcx, %rax	# m, m
# candidate/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r14d, %r8d	# e, e
	andl	$63, %r8d	#, e
# candidate/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	%r10d, %ecx	# tmp576, _276
	subl	%r8d, %ecx	# e, _276
# candidate/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdi	# m, _277
	salq	$32, %rdi	#, _277
# candidate/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _276
	cmove	%rax, %rdi	# _277,, m, x_283
# candidate/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _284
# candidate/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdi	# _284, _285
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdi, %r9	# _285, _287
	shrq	$32, %r9	#, _287
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r9d	#, _289
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edi, %r9d	# _285, dd
# candidate/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _297
	shrq	$32, %rcx	#, _297
# candidate/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r8d	#, tmp683
	cmovne	%rcx, %rax	# _297,, m
	movq	%rax, %r8	# m, x_303
# candidate/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r14d, %ecx	# e, e
	andl	$31, %ecx	#, e
# candidate/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %r8	# _304, _305
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r9d, %ecx	# dd, _293
	negl	%ecx	# _293
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r9d, %ecx	# dd, _294
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _295
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdi	#, _291
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edi, %ecx	# _291, f_296
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %eax	#, _306
	shrl	%cl, %eax	# f_296, _306
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %eax	#, _308
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%r8, %rax	# _305, m_309
# candidate/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rdx, %rcx	# _125, _312
	sarq	$63, %rcx	#, _312
	xorq	%rcx, %rax	# _312, _314
# candidate/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rdx	#, _310
# candidate/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rdx, %rax	# _310, _316
# candidate/source/falcon-sign.c:1986: 			s2[u] = (int16_t)-fpr_rint(t1[u]);
	negl	%eax	# tmp648
	movw	%ax, 8944(%rsp,%rsi,2)	# tmp648, MEM[(int16_t *)&s2 + u_244 * 2]
# candidate/source/falcon-sign.c:1974: 		for (u = 0; u < n; u ++) {
	addq	$1, %rsi	#, u
# candidate/source/falcon-sign.c:1974: 		for (u = 0; u < n; u ++) {
	cmpq	%rsi, %r15	# u, n
	jne	.L202	#,
.L200:
# candidate/source/falcon-sign.c:3374: 		if (fs->ternary && tsc.fault != FT_SAMPLER_FAULT_NONE) {
	movq	24(%rsp), %rax	# %sfp, fs
	movl	848(%rax), %ecx	# fs_39(D)->ternary, _14
# candidate/source/falcon-sign.c:3374: 		if (fs->ternary && tsc.fault != FT_SAMPLER_FAULT_NONE) {
	testl	%ecx, %ecx	# _14
	je	.L203	#,
# candidate/source/falcon-sign.c:3374: 		if (fs->ternary && tsc.fault != FT_SAMPLER_FAULT_NONE) {
	cmpl	$0, 8928(%rsp)	#, tsc.fault
	jne	.L204	#,
.L203:
# candidate/source/falcon-sign.c:3388: 			short_ok = falcon_is_short(s1, s2, fs->logn, fs->ternary);
	movq	24(%rsp), %rax	# %sfp, fs
	movl	844(%rax), %edx	# fs_39(D)->logn, fs_39(D)->logn
	leaq	8944(%rsp), %rsi	#, tmp650
	leaq	15088(%rsp), %rdi	#, tmp651
	call	falcon_is_short@PLT	#
# candidate/source/falcon-sign.c:3402: 			if (short_ok) {
	testl	%eax, %eax	# tmp678
	jne	.L205	#,
# candidate/source/falcon-sign.c:3332: 		if (++ sign_loop_attempts > SIGN_MAX_ATTEMPTS) {
	subl	$1, 184(%rsp)	#, %sfp
	je	.L204	#,
.L206:
# candidate/source/falcon-sign.c:3355: 		if (fs->ternary) {
	movq	24(%rsp), %rax	# %sfp, fs
	cmpl	$0, 848(%rax)	#, fs_39(D)->ternary
	je	.L195	#,
# candidate/source/falcon-sign.c:3356: 			falcon_prng_init(&tsc.p, &fs->rng, 0);
	leaq	416(%rax), %rsi	#, _7
	leaq	4560(%rsp), %rbx	#, tmp399
	movl	$0, %edx	#,
	movq	%rbx, %rdi	# tmp399,
	call	falcon_prng_init@PLT	#
# candidate/source/falcon-sign.c:3357: 			tsc.fault = FT_SAMPLER_FAULT_NONE;
	movl	$0, 8928(%rsp)	#, tsc.fault
# candidate/source/falcon-sign.c:3359: 			samp_ctx = &tsc;
	movq	%rbx, 88(%rsp)	# tmp399, %sfp
# candidate/source/falcon-sign.c:3358: 			samp = sampler_large;
	leaq	sampler_large(%rip), %rax	#, samp
	movq	%rax, 80(%rsp)	# samp, %sfp
.L196:
# candidate/source/falcon-sign.c:3372: 		do_sign(samp, samp_ctx, s1, s2,
	movq	24(%rsp), %rax	# %sfp, fs
	movq	872(%rax), %rbx	# fs_39(D)->tmp, _9
	movl	848(%rax), %edx	# fs_39(D)->ternary, _10
	movl	844(%rax), %ebp	# fs_39(D)->logn, _11
# candidate/source/falcon-sign.c:3373: 			fs->q, fs->sk, hm, fs->logn, fs->ternary, fs->tmp);
	movq	856(%rax), %rsi	# fs_39(D)->sk, _12
	movq	%rsi, 112(%rsp)	# _12, %sfp
# candidate/source/falcon-sign.c:3372: 		do_sign(samp, samp_ctx, s1, s2,
	movl	840(%rax), %eax	# fs_39(D)->q, _13
	movl	%eax, 72(%rsp)	# _13, %sfp
# candidate/source/falcon-sign.c:1859: 	n = MKN(logn, ter);
	leal	1(%rdx,%rdx), %eax	#, _68
	movl	%ebp, %ecx	# _11, _69
	subl	%edx, %ecx	# _10, _69
# candidate/source/falcon-sign.c:1859: 	n = MKN(logn, ter);
	salq	%cl, %rax	# _69, _68
	movq	%rax, %r15	# _68, n
# candidate/source/falcon-sign.c:1861: 	t1 = t0 + n;
	leaq	0(,%rax,8), %rax	#, _71
	movq	%rax, 32(%rsp)	# _71, %sfp
# candidate/source/falcon-sign.c:1861: 	t1 = t0 + n;
	leaq	(%rbx,%rax), %r12	#, t1
# candidate/source/falcon-sign.c:1862: 	tx = t1 + n;
	leaq	(%r12,%rax), %rdi	#, tx
	movq	%rdi, 8(%rsp)	# tx, %sfp
# candidate/source/falcon-sign.c:1863: 	ty = tx + n;
	addq	%rax, %rdi	# _71, ty
	movq	%rdi, 16(%rsp)	# ty, %sfp
# candidate/source/falcon-sign.c:1864: 	tz = ty + n;
	addq	%rax, %rdi	# _71, tz
	movq	%rdi, 40(%rsp)	# tz, %sfp
# candidate/source/falcon-sign.c:1866: 	b01 = sk + skoff_b01(logn, ter);
	addq	%rax, %rsi	# _71, b01
	movq	%rsi, 48(%rsp)	# b01, %sfp
# candidate/source/falcon-sign.c:1867: 	b10 = sk + skoff_b10(logn, ter);
	addq	%rax, %rsi	# _71, b10
	movq	%rsi, 120(%rsp)	# b10, %sfp
# candidate/source/falcon-sign.c:1868: 	b11 = sk + skoff_b11(logn, ter);
	addq	%rax, %rsi	# _71, b11
	movq	%rsi, 56(%rsp)	# b11, %sfp
# candidate/source/falcon-sign.c:1869: 	tree = sk + skoff_tree(logn, ter);
	addq	%rsi, %rax	# b11, tree
	movq	%rax, 64(%rsp)	# tree, %sfp
# candidate/source/falcon-sign.c:1874: 	for (u = 0; u < n; u ++) {
	testq	%r15, %r15	# n
	je	.L197	#,
# candidate/source/falcon-sign.c:1874: 	for (u = 0; u < n; u ++) {
	movl	$0, %r13d	#, u
# candidate/source/falcon-sign.c:1875: 		t0[u] = fpr_of(hm[u]);
	leaq	21232(%rsp), %r14	#, tmp406
	movl	%edx, 96(%rsp)	# _10, %sfp
.L198:
# candidate/source/falcon-sign.c:1875: 		t0[u] = fpr_of(hm[u]);
	movzwl	(%r14,%r13,2), %edi	# MEM[(const uint16_t *)&hm + u_282 * 2], _87
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# candidate/source/falcon-sign.c:1875: 		t0[u] = fpr_of(hm[u]);
	movq	%rax, (%rbx,%r13,8)	# tmp673, MEM[(fpr *)_9 + u_282 * 8]
# candidate/source/falcon-sign.c:1874: 	for (u = 0; u < n; u ++) {
	addq	$1, %r13	#, u
# candidate/source/falcon-sign.c:1874: 	for (u = 0; u < n; u ++) {
	cmpq	%r13, %r15	# u, n
	jne	.L198	#,
	movl	96(%rsp), %edx	# %sfp, _10
.L197:
# candidate/source/falcon-sign.c:1881: 	if (ter) {
	testl	%edx, %edx	# _10
	je	.L199	#,
# candidate/source/falcon-sign.c:1886: 		falcon_FFT3(t0, logn, 1);
	movl	$1, %edx	#,
	movl	%ebp, %esi	# _11,
	movq	%rbx, %rdi	# _9,
	call	falcon_FFT3@PLT	#
# candidate/source/falcon-sign.c:1887: 		ni = fpr_inverse_of(q);
	movl	72(%rsp), %edi	# %sfp, _92
# candidate/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp674, _151
# candidate/source/fpr-emulated.h:95: 	return fpr_div(fpr_one, fpr_of(i));
	movabsq	$4607182418800017408, %rdi	#,
	call	fpr_div@PLT	#
	movq	%rax, %r13	# tmp675, _152
# candidate/source/falcon-sign.c:1888: 		memcpy(t1, t0, n * sizeof *t0);
	movq	32(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# _9,
	movq	%r12, %rdi	# t1,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1889: 		falcon_poly_mul_fft3(t1, b01, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# t1,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/fpr-emulated.h:163: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rax	#, x_94
	xorq	%r13, %rax	# _152, x_94
	movq	%rax, %rsi	# x_94, x_94
# candidate/source/falcon-sign.c:1890: 		falcon_poly_mulconst_fft3(t1, fpr_neg(ni), logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	%r12, %rdi	# t1,
	call	falcon_poly_mulconst3@PLT	#
# candidate/source/falcon-sign.c:1891: 		falcon_poly_mul_fft3(t0, b11, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	56(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# _9,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1892: 		falcon_poly_mulconst_fft3(t0, ni, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	%r13, %rsi	# _152,
	movq	%rbx, %rdi	# _9,
	call	falcon_poly_mulconst3@PLT	#
# candidate/source/falcon-sign.c:1793: 	n = (size_t)3 << (logn - 1);
	leal	-1(%rbp), %edi	#, _132
# candidate/source/falcon-sign.c:1793: 	n = (size_t)3 << (logn - 1);
	movl	$24, %eax	#, n_133
# candidate/source/falcon-sign.c:1796: 	tree0 = tree + n;
	movl	%edi, %ecx	# _132, tmp746
	salq	%cl, %rax	# tmp746, n_133
# candidate/source/falcon-sign.c:1796: 	tree0 = tree + n;
	movq	64(%rsp), %r11	# %sfp, tree
	movq	%rax, 96(%rsp)	# _134, %sfp
	leaq	(%r11,%rax), %r10	#, tree0
# candidate/source/falcon-sign.c:1797: 	tree1 = tree0 + 3 * ((logn + 1) << (logn - 2));
	leal	1(%rbp), %eax	#, _136
# candidate/source/falcon-sign.c:1797: 	tree1 = tree0 + 3 * ((logn + 1) << (logn - 2));
	leal	-2(%rbp), %ecx	#, _137
# candidate/source/falcon-sign.c:1797: 	tree1 = tree0 + 3 * ((logn + 1) << (logn - 2));
	sall	%cl, %eax	# _137, _138
# candidate/source/falcon-sign.c:1797: 	tree1 = tree0 + 3 * ((logn + 1) << (logn - 2));
	leal	(%rax,%rax,2), %eax	#, _140
# candidate/source/falcon-sign.c:1797: 	tree1 = tree0 + 3 * ((logn + 1) << (logn - 2));
	movq	%r10, 136(%rsp)	# tree0, %sfp
	leaq	(%r10,%rax,8), %r14	#, tree1
	movq	%r14, 160(%rsp)	# tree1, %sfp
# candidate/source/falcon-sign.c:1799: 	y1 = y0 + tn;
	movl	$8, %r13d	#, tmp427
	movl	%edi, 132(%rsp)	# _132, %sfp
	movzbl	132(%rsp), %ecx	# %sfp, tmp752
	salq	%cl, %r13	# tmp752, _143
# candidate/source/falcon-sign.c:1799: 	y1 = y0 + tn;
	movq	40(%rsp), %rax	# %sfp, tz
	leaq	(%rax,%r13), %rdi	#, y1
# candidate/source/falcon-sign.c:1800: 	y2 = y1 + tn;
	movq	%rdi, 72(%rsp)	# y1, %sfp
	leaq	(%rdi,%r13), %r11	#, y2
	movq	%r11, 104(%rsp)	# y2, %sfp
# candidate/source/falcon-sign.c:1807: 	x1 = x0 + tn;
	movq	16(%rsp), %rdi	# %sfp, ty
	leaq	(%rdi,%r13), %r14	#, x1
# candidate/source/falcon-sign.c:1808: 	x2 = x1 + tn;
	leaq	(%r14,%r13), %r8	#, x2
	movq	%r8, %rdx	# x2, x2
# candidate/source/falcon-sign.c:1809: 	falcon_poly_split_top_fft3(x0, x1, x2, t1, logn);
	movl	%ebp, %r8d	# _11,
	movq	%r12, %rcx	# t1,
	movq	%rdx, 144(%rsp)	# x2, %sfp
	movq	%r14, %rsi	# x1,
	call	falcon_poly_split_top_fft3@PLT	#
# candidate/source/falcon-sign.c:1810: 	ffSampling_depth1_fft3(samp, samp_ctx,
	movq	40(%rsp), %rax	# %sfp, tz
	movq	96(%rsp), %rcx	# %sfp, _134
	leaq	(%rax,%rcx), %r8	#, _148
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 27448
	movq	%r8, 160(%rsp)	# _148, %sfp
	pushq	%r8	#
	.cfi_def_cfa_offset 27456
	movl	148(%rsp), %r10d	# %sfp, _132
	pushq	%r10	# _132
	.cfi_def_cfa_offset 27464
	pushq	168(%rsp)	# %sfp
	.cfi_def_cfa_offset 27472
	pushq	%r14	# x1
	.cfi_def_cfa_offset 27480
	pushq	56(%rsp)	# %sfp
	.cfi_def_cfa_offset 27488
	movq	208(%rsp), %r9	# %sfp,
	movq	152(%rsp), %r8	# %sfp,
	movq	120(%rsp), %rcx	# %sfp,
	movq	%rax, %r14	# tz, tz
	movq	%rax, %rdx	# tz,
	movq	136(%rsp), %rsi	# %sfp,
	movq	128(%rsp), %rdi	# %sfp,
	call	ffSampling_depth1_fft3	#
# candidate/source/falcon-sign.c:1812: 	falcon_poly_merge_top_fft3(z1, y0, y1, y2, logn);
	addq	$48, %rsp	#,
	.cfi_def_cfa_offset 27440
	movl	%ebp, %r8d	# _11,
	movq	104(%rsp), %rcx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	%r14, %rsi	# tz,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_merge_top_fft3@PLT	#
# candidate/source/falcon-sign.c:1818: 	memcpy(tmp, z1, n * sizeof *z1);
	movq	96(%rsp), %rdx	# %sfp,
	movq	16(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# tz,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1819: 	falcon_poly_mul_fft3(tmp, tree, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	64(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# tz,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1820: 	falcon_poly_add_fft3(tmp, t0, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	%rbx, %rsi	# _9,
	movq	%r14, 40(%rsp)	# tz, %sfp
	movq	%r14, %rdi	# tz,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:1826: 	x1 = x0 + tn;
	movq	8(%rsp), %rax	# %sfp, tx
	leaq	(%rax,%r13), %r14	#, x1
# candidate/source/falcon-sign.c:1827: 	x2 = x1 + tn;
	addq	%r14, %r13	# x1, x2
# candidate/source/falcon-sign.c:1828: 	falcon_poly_split_top_fft3(x0, x1, x2, tmp, logn);
	movl	%ebp, %r8d	# _11,
	movq	40(%rsp), %rcx	# %sfp,
	movq	%r13, %rdx	# x2,
	movq	%r14, %rsi	# x1,
	movq	%rax, %rdi	# tx,
	call	falcon_poly_split_top_fft3@PLT	#
# candidate/source/falcon-sign.c:1829: 	ffSampling_depth1_fft3(samp, samp_ctx,
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 27448
	pushq	160(%rsp)	# %sfp
	.cfi_def_cfa_offset 27456
	movl	148(%rsp), %r10d	# %sfp, _132
	pushq	%r10	# _132
	.cfi_def_cfa_offset 27464
	pushq	%r13	# x2
	.cfi_def_cfa_offset 27472
	pushq	%r14	# x1
	.cfi_def_cfa_offset 27480
	movq	48(%rsp), %r13	# %sfp, tx
	pushq	%r13	# tx
	.cfi_def_cfa_offset 27488
	movq	184(%rsp), %r9	# %sfp,
	movq	152(%rsp), %r8	# %sfp,
	movq	120(%rsp), %rcx	# %sfp,
	movq	88(%rsp), %r14	# %sfp, tz
	movq	%r14, %rdx	# tz,
	movq	136(%rsp), %rsi	# %sfp,
	movq	128(%rsp), %rdi	# %sfp,
	call	ffSampling_depth1_fft3	#
# candidate/source/falcon-sign.c:1831: 	falcon_poly_merge_top_fft3(z0, y0, y1, y2, logn);
	addq	$48, %rsp	#,
	.cfi_def_cfa_offset 27440
	movl	%ebp, %r8d	# _11,
	movq	104(%rsp), %rcx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	%r14, %rsi	# tz,
	movq	%r13, 8(%rsp)	# tx, %sfp
	movq	%r13, %rdi	# tx,
	call	falcon_poly_merge_top_fft3@PLT	#
# candidate/source/falcon-sign.c:1836: 	memcpy(tmp, z1, n * sizeof *z1);
	movq	96(%rsp), %rdx	# %sfp,
	movq	16(%rsp), %r13	# %sfp, ty
	movq	%r13, %rsi	# ty,
	movq	%r14, %rdi	# tz,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1837: 	falcon_poly_mul_fft3(tmp, tree, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	64(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# tz,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1838: 	falcon_poly_sub_fft3(z0, tmp, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	%r14, %rsi	# tz,
	movq	8(%rsp), %r14	# %sfp, tx
	movq	%r14, %rdi	# tx,
	call	falcon_poly_sub3@PLT	#
# candidate/source/falcon-sign.c:1902: 		memcpy(t0, tx, n * sizeof *tx);
	movq	32(%rsp), %rdx	# %sfp,
	movq	%r14, %rsi	# tx,
	movq	%rbx, %rdi	# _9,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1903: 		memcpy(t1, ty, n * sizeof *ty);
	movq	32(%rsp), %rdx	# %sfp,
	movq	%r13, %rsi	# ty,
	movq	%r12, %rdi	# t1,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1904: 		falcon_poly_mul_fft3(tx, b00, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	112(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# tx,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1905: 		falcon_poly_mul_fft3(ty, b10, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	120(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# ty,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1906: 		falcon_poly_add_fft3(tx, ty, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	%r13, %rsi	# ty,
	movq	%r14, 8(%rsp)	# tx, %sfp
	movq	%r14, %rdi	# tx,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:1907: 		memcpy(ty, t0, n * sizeof *t0);
	movq	32(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# _9,
	movq	%r13, %rdi	# ty,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1908: 		falcon_poly_mul_fft3(ty, b01, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# ty,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1910: 		memcpy(t0, tx, n * sizeof *tx);
	movq	32(%rsp), %rdx	# %sfp,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# _9,
	call	memcpy@PLT	#
# candidate/source/falcon-sign.c:1911: 		falcon_poly_mul_fft3(t1, b11, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	56(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# t1,
	call	falcon_poly_mul_fft3@PLT	#
# candidate/source/falcon-sign.c:1912: 		falcon_poly_add_fft3(t1, ty, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# _11,
	movq	%r13, %rsi	# ty,
	movq	%r12, %rdi	# t1,
	call	falcon_poly_add3@PLT	#
# candidate/source/falcon-sign.c:1914: 		falcon_iFFT3(t0, logn, 1);
	movl	$1, %edx	#,
	movl	%ebp, %esi	# _11,
	movq	%rbx, %rdi	# _9,
	call	falcon_iFFT3@PLT	#
# candidate/source/falcon-sign.c:1915: 		falcon_iFFT3(t1, logn, 1);
	movl	$1, %edx	#,
	movl	%ebp, %esi	# _11,
	movq	%r12, %rdi	# t1,
	call	falcon_iFFT3@PLT	#
# candidate/source/falcon-sign.c:1920: 		for (u = 0; u < n; u ++) {
	testq	%r15, %r15	# n
	je	.L200	#,
# candidate/source/falcon-sign.c:1920: 		for (u = 0; u < n; u ++) {
	movl	$0, %esi	#, u
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387904, %r13	#, tmp461
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	$1085, %ebp	#, tmp463
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	$1021, %r11d	#, tmp465
# candidate/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	$63, %r10d	#, tmp469
.L201:
# candidate/source/falcon-sign.c:1931: 			s1[u] = (int16_t)fpr_rint(t0[u]);
	movq	(%rbx,%rsi,8), %rdx	# MEM[(fpr *)_9 + u_281 * 8], _98
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdx, %rcx	# _98, _207
	salq	$10, %rcx	#, _207
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp766
	andq	%rax, %rcx	# tmp766, _208
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r13, %rcx	# tmp461, m
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rdx, %rdi	# _98, _210
	shrq	$52, %rdi	#, _210
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %edi	#, _212
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%ebp, %r14d	# tmp463, e
	subl	%edi, %r14d	# _212, e
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r11d, %r9d	# tmp465, _214
	subl	%edi, %r9d	# _212, _214
	movl	%r9d, %eax	# _214, _214
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _216
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _216, _217
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp468
	andq	%rcx, %rax	# m, m
# candidate/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r14d, %r8d	# e, e
	andl	$63, %r8d	#, e
# candidate/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	%r10d, %ecx	# tmp469, _220
	subl	%r8d, %ecx	# e, _220
# candidate/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdi	# m, _221
	salq	$32, %rdi	#, _221
# candidate/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _220
	cmove	%rax, %rdi	# _221,, m, x_227
# candidate/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _228
# candidate/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdi	# _228, _229
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdi, %r9	# _229, _231
	shrq	$32, %r9	#, _231
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r9d	#, _233
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edi, %r9d	# _229, dd
# candidate/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _241
	shrq	$32, %rcx	#, _241
# candidate/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r8d	#, tmp680
	movq	%rax, %r8	# m, m
	cmovne	%rcx, %r8	# _241,, m
# candidate/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r14d, %ecx	# e, e
	andl	$31, %ecx	#, e
# candidate/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %r8	# _248, _249
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r9d, %ecx	# dd, _237
	negl	%ecx	# _237
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r9d, %ecx	# dd, _238
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _239
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdi	#, _235
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edi, %ecx	# _235, f_240
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %edi	#, _250
	shrl	%cl, %edi	# f_240, _250
	movl	%edi, %eax	# _250, _250
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %eax	#, _252
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%r8, %rax	# _249, m_253
# candidate/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rdx, %rcx	# _98, _256
	sarq	$63, %rcx	#, _256
	xorq	%rcx, %rax	# _256, _258
# candidate/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rdx	#, _254
# candidate/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rdx, %rax	# _254, _260
# candidate/source/falcon-sign.c:1931: 			s1[u] = (int16_t)fpr_rint(t0[u]);
	movw	%ax, 15088(%rsp,%rsi,2)	# _260, MEM[(int16_t *)&s1 + u_281 * 2]
# candidate/source/falcon-sign.c:1932: 			s2[u] = (int16_t)fpr_rint(t1[u]);
	movq	(%r12,%rsi,8), %rdx	# MEM[(fpr *)t1_72 + u_281 * 8], _104
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdx, %rcx	# _104, _153
	salq	$10, %rcx	#, _153
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp781
	andq	%rax, %rcx	# tmp781, _154
# candidate/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r13, %rcx	# tmp461, m
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rdx, %rdi	# _104, _156
	shrq	$52, %rdi	#, _156
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %edi	#, _158
# candidate/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%ebp, %r14d	# tmp463, e
	subl	%edi, %r14d	# _158, e
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r11d, %eax	# tmp465, _160
	subl	%edi, %eax	# _158, _160
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _162
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _162, _163
# candidate/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp507
	andq	%rcx, %rax	# m, m
# candidate/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r14d, %r8d	# e, e
	andl	$63, %r8d	#, e
# candidate/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	%r10d, %ecx	# tmp469, _166
	subl	%r8d, %ecx	# e, _166
# candidate/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdi	# m, _167
	salq	$32, %rdi	#, _167
# candidate/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _166
	cmove	%rax, %rdi	# _167,, m, x_173
# candidate/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _174
# candidate/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdi	# _174, _175
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdi, %r9	# _175, _177
	shrq	$32, %r9	#, _177
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r9d	#, _179
# candidate/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edi, %r9d	# _175, dd
# candidate/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _187
	shrq	$32, %rcx	#, _187
# candidate/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r8d	#, tmp681
	cmovne	%rcx, %rax	# _187,, m
	movq	%rax, %r8	# m, x_193
# candidate/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r14d, %ecx	# e, e
	andl	$31, %ecx	#, e
# candidate/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %r8	# _194, _195
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r9d, %ecx	# dd, _183
	negl	%ecx	# _183
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r9d, %ecx	# dd, _184
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _185
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdi	#, _181
# candidate/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edi, %ecx	# _181, f_186
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %eax	#, _196
	shrl	%cl, %eax	# f_186, _196
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %eax	#, _198
# candidate/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%r8, %rax	# _195, m_199
# candidate/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rdx, %rcx	# _104, _202
	sarq	$63, %rcx	#, _202
	xorq	%rcx, %rax	# _202, _204
# candidate/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rdx	#, _200
# candidate/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rdx, %rax	# _200, _206
# candidate/source/falcon-sign.c:1932: 			s2[u] = (int16_t)fpr_rint(t1[u]);
	movw	%ax, 8944(%rsp,%rsi,2)	# _206, MEM[(int16_t *)&s2 + u_281 * 2]
# candidate/source/falcon-sign.c:1920: 		for (u = 0; u < n; u ++) {
	addq	$1, %rsi	#, u
# candidate/source/falcon-sign.c:1920: 		for (u = 0; u < n; u ++) {
	cmpq	%rsi, %r15	# u, n
	jne	.L201	#,
	jmp	.L200	#
.L204:
# candidate/source/falcon-sign.c:3333: 			return 0;
	movl	$0, %eax	#, <retval>
	jmp	.L193	#
.L205:
# candidate/source/falcon-sign.c:3412: 	sig_len = falcon_encode_small(sig_buf + 1, sig_max_len - 1,
	movq	168(%rsp), %r12	# %sfp, sig
	movq	176(%rsp), %rbx	# %sfp, sig_max_len
	movl	188(%rsp), %r13d	# %sfp, comp
	movq	24(%rsp), %rax	# %sfp, fs
	movl	840(%rax), %ecx	# fs_39(D)->q, fs_39(D)->q
	leaq	-1(%rbx), %rsi	#, _19
# candidate/source/falcon-sign.c:3412: 	sig_len = falcon_encode_small(sig_buf + 1, sig_max_len - 1,
	leaq	1(%r12), %rdi	#, _20
# candidate/source/falcon-sign.c:3412: 	sig_len = falcon_encode_small(sig_buf + 1, sig_max_len - 1,
	movq	%rax, %rbx	# fs, fs
	movl	844(%rax), %r9d	# fs_39(D)->logn,
	leaq	8944(%rsp), %r8	#,
	movl	%r13d, %edx	# comp,
	call	falcon_encode_small@PLT	#
# candidate/source/falcon-sign.c:3414: 	if (sig_len == 0) {
	testq	%rax, %rax	# <retval>
	je	.L193	#,
# candidate/source/falcon-sign.c:3420: 	sig_buf[0] = (fs->ternary << 7) | (comp << 5) | fs->logn;
	movl	%r13d, %edx	# comp, _25
	sall	$5, %edx	#, _25
# candidate/source/falcon-sign.c:3420: 	sig_buf[0] = (fs->ternary << 7) | (comp << 5) | fs->logn;
	orb	844(%rbx), %dl	# fs_39(D)->logn, _34
# candidate/source/falcon-sign.c:3420: 	sig_buf[0] = (fs->ternary << 7) | (comp << 5) | fs->logn;
	movl	848(%rbx), %ecx	# fs_39(D)->ternary, fs_39(D)->ternary
	sall	$7, %ecx	#, _23
# candidate/source/falcon-sign.c:3420: 	sig_buf[0] = (fs->ternary << 7) | (comp << 5) | fs->logn;
	orl	%ecx, %edx	# _23, tmp662
	movb	%dl, (%r12)	# tmp662, MEM[(unsigned char *)sig_55(D)]
# candidate/source/falcon-sign.c:3421: 	return sig_len + 1;
	addq	$1, %rax	#, <retval>
	jmp	.L193	#
.L208:
# candidate/source/falcon-sign.c:3322: 		return 0;
	movl	$0, %eax	#, <retval>
.L193:
# candidate/source/falcon-sign.c:3422: }
	addq	$27384, %rsp	#,
	.cfi_def_cfa_offset 56
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
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
# hi:
	.quad	4031913084411455523
# lo:
	.quad	-7527879395188308033
# hi:
	.quad	596125951946700678
# lo:
	.quad	5229758529120913067
# hi:
	.quad	69230930161336360
# lo:
	.quad	-4818650938196620221
# hi:
	.quad	6302293744552402
# lo:
	.quad	7352830732370919967
# hi:
	.quad	449018771521685
# lo:
	.quad	-8681764675673989188
# hi:
	.quad	25008954620675
# lo:
	.quad	-7080206969534889451
# hi:
	.quad	1087957639417
# lo:
	.quad	2775583653356073882
# hi:
	.quad	36942382845
# lo:
	.quad	-2433995223356097912
# hi:
	.quad	978618449
# lo:
	.quad	2690982465095676317
# hi:
	.quad	20216591
# lo:
	.quad	2875354667081992134
# hi:
	.quad	325595
# lo:
	.quad	3253399177098153241
# hi:
	.quad	4087
# lo:
	.quad	3145154105398596933
# hi:
	.quad	39
# lo:
	.quad	-332240649642460458
# hi:
	.quad	0
# lo:
	.quad	5621630163842613476
# hi:
	.quad	0
# lo:
	.quad	33383367111730198
# hi:
	.quad	0
# lo:
	.quad	154437016759436
# hi:
	.quad	0
# lo:
	.quad	556541887369
# hi:
	.quad	0
# lo:
	.quad	1562239343
# hi:
	.quad	0
# lo:
	.quad	3415730
# hi:
	.quad	0
# lo:
	.quad	5817
# hi:
	.quad	0
# lo:
	.quad	8
# hi:
	.quad	0
# lo:
	.quad	0
	.align 32
	.type	CDFs, @object
	.size	CDFs, 96
CDFs:
# hi:
	.quad	-2678677258295294960
# lo:
	.quad	2878715985279770247
# hi:
	.quad	-5268329278199080015
# lo:
	.quad	2650718273802340096
# hi:
	.quad	1313815201007480117
# lo:
	.quad	632549813042453946
# hi:
	.quad	7906626931797828486
# lo:
	.quad	889294877069012273
# hi:
	.quad	-1743811193595018592
# lo:
	.quad	-8289815805723892678
# hi:
	.quad	3033535791909276021
# lo:
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
