	.file	"falcon-fft.c"
# GNU C99 (Debian 14.2.0-19) version 14.2.0 (x86_64-linux-gnu)
#	compiled by GNU C version 14.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.27-GMP

# warning: MPFR header version 4.2.1 differs from library version 4.2.2.
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O -std=c99 -fasynchronous-unwind-tables
	.text
	.globl	falcon_FFT
	.type	falcon_FFT, @function
falcon_FFT:
.LFB32:
	.cfi_startproc
# inputs/bootstrap/source/falcon-fft.c:221: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp153
	movl	%esi, %ecx	# logn, tmp214
	salq	%cl, %rax	# tmp214, n_32
# inputs/bootstrap/source/falcon-fft.c:222: 	hn = n >> 1;
	shrq	%rax	# n_32
# inputs/bootstrap/source/falcon-fft.c:224: 	for (u = 1, m = 2; u < logn; u ++, m <<= 1) {
	cmpl	$1, %esi	#, logn
	jbe	.L12	#,
# inputs/bootstrap/source/falcon-fft.c:177: {
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
	subq	$152, %rsp	#,
	.cfi_def_cfa_offset 208
	movq	%rdi, %rdx	# tmp177, f
	movq	%rax, %r13	# n_32, hn
# inputs/bootstrap/source/falcon-fft.c:224: 	for (u = 1, m = 2; u < logn; u ++, m <<= 1) {
	movl	$2, %ebx	#, m
# inputs/bootstrap/source/falcon-fft.c:224: 	for (u = 1, m = 2; u < logn; u ++, m <<= 1) {
	movl	$1, %r15d	#, u
	leaq	8(%rdi), %rax	#, _24
	movq	%rax, 112(%rsp)	# _24, %sfp
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r12	#, tmp175
	movq	%r13, 136(%rsp)	# hn, %sfp
	movq	%r13, %rcx	# ht, ht
	movl	%esi, 132(%rsp)	# logn, %sfp
	movl	%r15d, %r14d	# u, u
.L7:
	movq	%rcx, %r15	# ht, t
# inputs/bootstrap/source/falcon-fft.c:227: 		ht = t >> 1;
	shrq	%rcx	# ht
# inputs/bootstrap/source/falcon-fft.c:229: 		for (i1 = 0, j1 = 0; i1 < hm; i1 ++, j1 += t) {
	movq	%rbx, %rax	# m, hm
	shrq	%rax	# hm
	movq	%rax, 88(%rsp)	# hm, %sfp
	je	.L3	#,
	movq	%rbx, %r9	# m, _116
	salq	$4, %r9	#, _116
	leaq	fpr_gm_tab(%rip), %rax	#, tmp219
	addq	%rax, %r9	# tmp219, ivtmp.75
# inputs/bootstrap/source/falcon-fft.c:229: 		for (i1 = 0, j1 = 0; i1 < hm; i1 ++, j1 += t) {
	movl	$0, %r8d	#, j1
# inputs/bootstrap/source/falcon-fft.c:229: 		for (i1 = 0, j1 = 0; i1 < hm; i1 ++, j1 += t) {
	movl	$0, %esi	#, i1
	leal	-1(%rcx), %eax	#, _107
	movq	%rax, 104(%rsp)	# _107, %sfp
	movq	%r15, 96(%rsp)	# t, %sfp
	movl	%r14d, 128(%rsp)	# u, %sfp
	movq	136(%rsp), %r14	# %sfp, hn
	movq	%rbx, 120(%rsp)	# m, %sfp
	movq	%r8, %rdi	# j1, j1
	movq	%r9, %r8	# ivtmp.75, ivtmp.75
.L6:
# inputs/bootstrap/source/falcon-fft.c:233: 			s_re = fpr_gm_tab[((m + i1) << 1) + 0];
	movq	(%r8), %r9	# MEM[(long unsigned int *)_118], s_re
# inputs/bootstrap/source/falcon-fft.c:234: 			s_im = fpr_gm_tab[((m + i1) << 1) + 1];
	movq	8(%r8), %rax	# MEM[(long unsigned int *)_118 + 8B], s_im
	movq	%rax, 24(%rsp)	# s_im, %sfp
# inputs/bootstrap/source/falcon-fft.c:236: 			for (j = j1; j < j2; j ++) {
	leal	(%rdi,%rcx), %r10d	#, j2_120
	cmpl	%r10d, %edi	# j2_120, j1
	jnb	.L4	#,
	movl	%edi, %r10d	# j1, _130
	leaq	(%rdx,%r10,8), %rbp	#, ivtmp.64
	leaq	(%rcx,%r10), %r11	#, _74
	leaq	(%rdx,%r11,8), %r15	#, ivtmp.66
	movq	104(%rsp), %rax	# %sfp, _107
	addq	%rax, %r10	# _107, _108
	movq	112(%rsp), %rax	# %sfp, _24
	leaq	(%rax,%r10,8), %rax	#, _112
	movq	%rax, 40(%rsp)	# _112, %sfp
	movq	%rcx, 48(%rsp)	# ht, %sfp
	movq	%r9, 32(%rsp)	# s_re, %sfp
	movq	%rsi, 56(%rsp)	# i1, %sfp
	movq	%rdi, 64(%rsp)	# j1, %sfp
	movq	%r8, 72(%rsp)	# ivtmp.75, %sfp
	movq	%rdx, 80(%rsp)	# f, %sfp
.L5:
# inputs/bootstrap/source/falcon-fft.c:239: 				x_re = f[j];
	movq	0(%rbp), %rax	# MEM[(fpr *)_94], x_re
	movq	%rax, (%rsp)	# x_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:240: 				x_im = f[j + hn];
	movq	0(%rbp,%r14,8), %rdx	# MEM[(fpr *)_94 + hn_33 * 8], x_im
	movq	%rdx, 8(%rsp)	# x_im, %sfp
# inputs/bootstrap/source/falcon-fft.c:241: 				y_re = f[j + ht];
	movq	(%r15), %r13	# MEM[(fpr *)_98], y_re
# inputs/bootstrap/source/falcon-fft.c:242: 				y_im = f[j + ht + hn];
	movq	(%r15,%r14,8), %rbx	# MEM[(fpr *)_98 + hn_33 * 8], y_im
# inputs/bootstrap/source/falcon-fft.c:243: 				FPC_MUL(y_re, y_im, y_re, y_im, s_re, s_im);
	movq	24(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# y_im,
	call	fpr_mul@PLT	#
	movq	%rax, 16(%rsp)	# tmp179, %sfp
# inputs/bootstrap/source/falcon-fft.c:243: 				FPC_MUL(y_re, y_im, y_re, y_im, s_re, s_im);
	movq	32(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# y_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp180, _19
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	16(%rsp), %rcx	# %sfp, _18
	xorq	%r12, %rcx	# tmp175, _18
	movq	%rcx, %rsi	# _18, y_68
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 16(%rsp)	# tmp181, %sfp
# inputs/bootstrap/source/falcon-fft.c:243: 				FPC_MUL(y_re, y_im, y_re, y_im, s_re, s_im);
	movq	32(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# y_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp182, _20
# inputs/bootstrap/source/falcon-fft.c:243: 				FPC_MUL(y_re, y_im, y_re, y_im, s_re, s_im);
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# y_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp183, _21
# inputs/bootstrap/source/falcon-fft.c:243: 				FPC_MUL(y_re, y_im, y_re, y_im, s_re, s_im);
	movq	%rbx, %rsi	# _20,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp184, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:244: 				FPC_ADD(f[j], f[j + hn],
	movq	16(%rsp), %rsi	# %sfp,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp185, fpct_re
# inputs/bootstrap/source/falcon-fft.c:244: 				FPC_ADD(f[j], f[j + hn],
	movq	%rbx, %rsi	# fpct_d_im,
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:244: 				FPC_ADD(f[j], f[j + hn],
	movq	%r13, 0(%rbp)	# fpct_re, MEM[(fpr *)_94]
	movq	%rax, 0(%rbp,%r14,8)	# tmp186, MEM[(fpr *)_94 + hn_33 * 8]
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	16(%rsp), %rsi	# %sfp, _69
	xorq	%r12, %rsi	# tmp175, _69
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp187, _67
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%r12, %rbx	# tmp175, fpct_d_im
	movq	%rbx, %rsi	# fpct_d_im, y_64
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:246: 				FPC_SUB(f[j + ht], f[j + ht + hn],
	movq	%r13, (%r15)	# _67, MEM[(fpr *)_98]
	movq	%rax, (%r15,%r14,8)	# tmp188, MEM[(fpr *)_98 + hn_33 * 8]
# inputs/bootstrap/source/falcon-fft.c:236: 			for (j = j1; j < j2; j ++) {
	addq	$8, %rbp	#, ivtmp.64
	addq	$8, %r15	#, ivtmp.66
	movq	40(%rsp), %rax	# %sfp, _112
	cmpq	%rax, %rbp	# _112, ivtmp.64
	jne	.L5	#,
	movq	48(%rsp), %rcx	# %sfp, ht
	movq	56(%rsp), %rsi	# %sfp, i1
	movq	64(%rsp), %rdi	# %sfp, j1
	movq	72(%rsp), %r8	# %sfp, ivtmp.75
	movq	80(%rsp), %rdx	# %sfp, f
.L4:
# inputs/bootstrap/source/falcon-fft.c:229: 		for (i1 = 0, j1 = 0; i1 < hm; i1 ++, j1 += t) {
	addq	$1, %rsi	#, i1
# inputs/bootstrap/source/falcon-fft.c:229: 		for (i1 = 0, j1 = 0; i1 < hm; i1 ++, j1 += t) {
	movq	96(%rsp), %rax	# %sfp, t
	addq	%rax, %rdi	# t, j1
# inputs/bootstrap/source/falcon-fft.c:229: 		for (i1 = 0, j1 = 0; i1 < hm; i1 ++, j1 += t) {
	addq	$16, %r8	#, ivtmp.75
	cmpq	%rsi, 88(%rsp)	# i1, %sfp
	jne	.L6	#,
	movl	128(%rsp), %r14d	# %sfp, u
	movq	120(%rsp), %rbx	# %sfp, m
.L3:
# inputs/bootstrap/source/falcon-fft.c:224: 	for (u = 1, m = 2; u < logn; u ++, m <<= 1) {
	addl	$1, %r14d	#, u
# inputs/bootstrap/source/falcon-fft.c:224: 	for (u = 1, m = 2; u < logn; u ++, m <<= 1) {
	addq	%rbx, %rbx	# m
# inputs/bootstrap/source/falcon-fft.c:224: 	for (u = 1, m = 2; u < logn; u ++, m <<= 1) {
	cmpl	%r14d, 132(%rsp)	# u, %sfp
	jne	.L7	#,
# inputs/bootstrap/source/falcon-fft.c:252: }
	addq	$152, %rsp	#,
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
.L12:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	ret	
	.cfi_endproc
.LFE32:
	.size	falcon_FFT, .-falcon_FFT
	.globl	falcon_iFFT
	.type	falcon_iFFT, @function
falcon_iFFT:
.LFB33:
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
	subq	$136, %rsp	#,
	.cfi_def_cfa_offset 192
	movq	%rdi, 8(%rsp)	# f, %sfp
	movl	%esi, %ebp	# tmp163, logn
# inputs/bootstrap/source/falcon-fft.c:302: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp145
	movl	%esi, %ecx	# logn, tmp201
	salq	%cl, %rax	# tmp201, tmp145
	movq	%rax, %rbx	# tmp145, n
# inputs/bootstrap/source/falcon-fft.c:305: 	hn = n >> 1;
	movq	%rax, %r14	# n, hn
	shrq	%r14	# hn
# inputs/bootstrap/source/falcon-fft.c:306: 	for (u = logn; u > 1; u --) {
	cmpl	$1, %esi	#, logn
	jbe	.L16	#,
	movl	%esi, %r13d	# logn, u
	leaq	(%rdi,%r14,8), %rax	#, _29
	movq	%rax, 32(%rsp)	# _29, %sfp
# inputs/bootstrap/source/falcon-fft.c:304: 	m = n;
	movq	%rbx, %r12	# n, m
# inputs/bootstrap/source/falcon-fft.c:303: 	t = 1;
	movl	$1, %edx	#, t
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r15	#, tmp152
	movq	%rbx, 112(%rsp)	# n, %sfp
	movq	%r14, 88(%rsp)	# hn, %sfp
	movl	%esi, 124(%rsp)	# logn, %sfp
.L20:
# inputs/bootstrap/source/falcon-fft.c:309: 		hm = m >> 1;
	shrq	%r12	# m
	movq	%rdx, %r8	# t, ivtmp.110
# inputs/bootstrap/source/falcon-fft.c:310: 		dt = t << 1;
	addq	%rdx, %rdx	# t
	movq	%r12, %r9	# m, _89
	salq	$4, %r9	#, _89
	leaq	fpr_gm_tab(%rip), %rax	#, tmp206
	leaq	(%r9,%rax), %rcx	#, ivtmp.109
	movq	8(%rsp), %rax	# %sfp, f
	leaq	(%rax,%r8,8), %rbx	#, _31
	movq	%rbx, 16(%rsp)	# _31, %sfp
	movq	88(%rsp), %rbx	# %sfp, hn
	leaq	(%rbx,%r8), %rdi	#, _32
	leaq	(%rax,%rdi,8), %rax	#, _93
	movq	%rax, 24(%rsp)	# _93, %sfp
# inputs/bootstrap/source/falcon-fft.c:311: 		for (i1 = 0, j1 = 0; j1 < hn; i1 ++, j1 += dt) {
	movl	$0, %esi	#, j1
	movq	%r12, 96(%rsp)	# m, %sfp
	movq	%r13, 104(%rsp)	# u, %sfp
.L19:
# inputs/bootstrap/source/falcon-fft.c:316: 			s_re = fpr_gm_tab[((hm + i1) << 1) + 0];
	movq	(%rcx), %r9	# MEM[(long unsigned int *)_112], s_re
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movq	%r15, %r10	# tmp152, x
	xorq	8(%rcx), %r10	# MEM[(long unsigned int *)_112 + 8B], x
# inputs/bootstrap/source/falcon-fft.c:318: 			for (j = j1; j < j2; j ++) {
	cmpq	%r8, %rsi	# ivtmp.110, j1
	jnb	.L17	#,
# inputs/bootstrap/source/falcon-fft.c:318: 			for (j = j1; j < j2; j ++) {
	movq	%rsi, %rbp	# j1, j
	movq	%rdx, 64(%rsp)	# t, %sfp
	movq	%r9, 56(%rsp)	# s_re, %sfp
	movq	%r10, (%rsp)	# x, %sfp
	movq	%rsi, 72(%rsp)	# j1, %sfp
	movq	%rcx, 80(%rsp)	# ivtmp.109, %sfp
	movq	%r8, 48(%rsp)	# ivtmp.110, %sfp
.L18:
# inputs/bootstrap/source/falcon-fft.c:321: 				x_re = f[j];
	movq	8(%rsp), %rdx	# %sfp, f
	movq	(%rdx,%rbp,8), %r14	# MEM[(fpr *)f_45(D) + j_102 * 8], x_re
# inputs/bootstrap/source/falcon-fft.c:322: 				x_im = f[j + hn];
	movq	32(%rsp), %rax	# %sfp, _29
	movq	(%rax,%rbp,8), %r13	# MEM[(fpr *)_29 + j_102 * 8], x_im
# inputs/bootstrap/source/falcon-fft.c:323: 				y_re = f[j + t];
	movq	16(%rsp), %rbx	# %sfp, _31
	movq	(%rbx,%rbp,8), %r12	# MEM[(fpr *)_31 + j_102 * 8], y_re
# inputs/bootstrap/source/falcon-fft.c:324: 				y_im = f[j + t + hn];
	movq	24(%rsp), %rdi	# %sfp, _93
	movq	(%rdi,%rbp,8), %rbx	# MEM[(fpr *)_93 + j_102 * 8], y_im
# inputs/bootstrap/source/falcon-fft.c:325: 				FPC_ADD(f[j], f[j + hn],
	movq	%r12, %rsi	# y_re,
	movq	%r14, %rdi	# x_re,
	call	fpr_add@PLT	#
	movq	%rax, 40(%rsp)	# tmp164, %sfp
# inputs/bootstrap/source/falcon-fft.c:325: 				FPC_ADD(f[j], f[j + hn],
	movq	%rbx, %rsi	# y_im,
	movq	%r13, %rdi	# x_im,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:325: 				FPC_ADD(f[j], f[j + hn],
	movq	8(%rsp), %rdx	# %sfp, f
	movq	40(%rsp), %rsi	# %sfp, fpct_re
	movq	%rsi, (%rdx,%rbp,8)	# fpct_re, MEM[(fpr *)f_45(D) + j_102 * 8]
	movq	32(%rsp), %rcx	# %sfp, _29
	movq	%rax, (%rcx,%rbp,8)	# tmp165, MEM[(fpr *)_29 + j_102 * 8]
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r12, %rsi	# y_re, y_re
	xorq	%r15, %rsi	# tmp152, y_re
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	%r14, %rdi	# x_re,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp166, _81
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%rbx, %rsi	# y_im, y_im
	xorq	%r15, %rsi	# tmp152, y_im
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	%r13, %rdi	# x_im,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp167, _79
# inputs/bootstrap/source/falcon-fft.c:328: 				FPC_MUL(f[j + t], f[j + t + hn],
	movq	(%rsp), %rsi	# %sfp,
	movq	%rax, %rdi	# _79,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp168, _16
# inputs/bootstrap/source/falcon-fft.c:328: 				FPC_MUL(f[j + t], f[j + t + hn],
	movq	56(%rsp), %r14	# %sfp, s_re
	movq	%r14, %rsi	# s_re,
	movq	%r12, %rdi	# _81,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp169, _17
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%rbx, %rax	# _16, _16
	xorq	%r15, %rax	# tmp152, _16
	movq	%rax, %rsi	# _16, y_76
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp170, _77
# inputs/bootstrap/source/falcon-fft.c:328: 				FPC_MUL(f[j + t], f[j + t + hn],
	movq	%r14, %rsi	# s_re,
	movq	%r13, %rdi	# _79,
	call	fpr_mul@PLT	#
	movq	%rax, %r13	# tmp171, _18
# inputs/bootstrap/source/falcon-fft.c:328: 				FPC_MUL(f[j + t], f[j + t + hn],
	movq	(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# _81,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp172, _19
# inputs/bootstrap/source/falcon-fft.c:328: 				FPC_MUL(f[j + t], f[j + t + hn],
	movq	%r13, %rsi	# _18,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:328: 				FPC_MUL(f[j + t], f[j + t + hn],
	movq	16(%rsp), %rcx	# %sfp, _31
	movq	%rbx, (%rcx,%rbp,8)	# _77, MEM[(fpr *)_31 + j_102 * 8]
	movq	24(%rsp), %rdi	# %sfp, _93
	movq	%rax, (%rdi,%rbp,8)	# tmp173, MEM[(fpr *)_93 + j_102 * 8]
# inputs/bootstrap/source/falcon-fft.c:318: 			for (j = j1; j < j2; j ++) {
	addq	$1, %rbp	#, j
# inputs/bootstrap/source/falcon-fft.c:318: 			for (j = j1; j < j2; j ++) {
	movq	48(%rsp), %rax	# %sfp, ivtmp.110
	cmpq	%rax, %rbp	# ivtmp.110, j
	jne	.L18	#,
	movq	64(%rsp), %rdx	# %sfp, t
	movq	72(%rsp), %rsi	# %sfp, j1
	movq	80(%rsp), %rcx	# %sfp, ivtmp.109
	movq	%rax, %r8	# ivtmp.110, ivtmp.110
.L17:
# inputs/bootstrap/source/falcon-fft.c:311: 		for (i1 = 0, j1 = 0; j1 < hn; i1 ++, j1 += dt) {
	addq	%rdx, %rsi	# t, j1
# inputs/bootstrap/source/falcon-fft.c:311: 		for (i1 = 0, j1 = 0; j1 < hn; i1 ++, j1 += dt) {
	addq	$16, %rcx	#, ivtmp.109
	addq	%rdx, %r8	# t, ivtmp.110
	movq	88(%rsp), %rax	# %sfp, hn
	cmpq	%rax, %rsi	# hn, j1
	jb	.L19	#,
# inputs/bootstrap/source/falcon-fft.c:306: 	for (u = logn; u > 1; u --) {
	movq	96(%rsp), %r12	# %sfp, m
	movq	104(%rsp), %r13	# %sfp, u
	subq	$1, %r13	#, u
# inputs/bootstrap/source/falcon-fft.c:306: 	for (u = logn; u > 1; u --) {
	cmpq	$1, %r13	#, u
	jne	.L20	#,
	movq	112(%rsp), %rbx	# %sfp, n
	movl	124(%rsp), %ebp	# %sfp, logn
.L21:
# inputs/bootstrap/source/falcon-fft.c:343: 		ni = fpr_scaled(2, -(int)logn);
	movl	%ebp, %esi	# logn, logn
	negl	%esi	# logn
	movl	$2, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %r12	# tmp174, ni
# inputs/bootstrap/source/falcon-fft.c:344: 		for (u = 0; u < n; u ++) {
	movl	$0, %ebp	#, u
	movq	8(%rsp), %r13	# %sfp, f
.L23:
# inputs/bootstrap/source/falcon-fft.c:345: 			f[u] = fpr_mul(f[u], ni);
	movq	0(%r13,%rbp,8), %rdi	# MEM[(fpr *)f_45(D) + u_97 * 8], MEM[(fpr *)f_45(D) + u_97 * 8]
	movq	%r12, %rsi	# ni,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:345: 			f[u] = fpr_mul(f[u], ni);
	movq	%rax, 0(%r13,%rbp,8)	# tmp175, MEM[(fpr *)f_45(D) + u_97 * 8]
# inputs/bootstrap/source/falcon-fft.c:344: 		for (u = 0; u < n; u ++) {
	addq	$1, %rbp	#, u
# inputs/bootstrap/source/falcon-fft.c:344: 		for (u = 0; u < n; u ++) {
	cmpq	%rbp, %rbx	# u, n
	jne	.L23	#,
	jmp	.L15	#
.L16:
# inputs/bootstrap/source/falcon-fft.c:340: 	if (logn > 0) {
	testl	%esi, %esi	# logn
	jne	.L21	#,
.L15:
# inputs/bootstrap/source/falcon-fft.c:348: }
	addq	$136, %rsp	#,
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
.LFE33:
	.size	falcon_iFFT, .-falcon_iFFT
	.globl	falcon_poly_add
	.type	falcon_poly_add, @function
falcon_poly_add:
.LFB34:
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
	movq	%rdi, %rbp	# tmp109, a
	movq	%rsi, %r13	# tmp110, b
# inputs/bootstrap/source/falcon-fft.c:356: 	n = (size_t)1 << logn;
	movl	$1, %r12d	#, tmp106
	movl	%edx, %ecx	# tmp111, tmp114
	salq	%cl, %r12	# tmp114, n
# inputs/bootstrap/source/falcon-fft.c:357: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L30:
# inputs/bootstrap/source/falcon-fft.c:358: 		a[u] = fpr_add(a[u], b[u]);
	movq	0(%r13,%rbx,8), %rsi	# MEM[(const fpr *)b_12(D) + u_19 * 8], MEM[(const fpr *)b_12(D) + u_19 * 8]
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_13(D) + u_19 * 8], MEM[(fpr *)a_13(D) + u_19 * 8]
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:358: 		a[u] = fpr_add(a[u], b[u]);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp112, MEM[(fpr *)a_13(D) + u_19 * 8]
# inputs/bootstrap/source/falcon-fft.c:357: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:357: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r12	# u, n
	jne	.L30	#,
# inputs/bootstrap/source/falcon-fft.c:360: }
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
.LFE34:
	.size	falcon_poly_add, .-falcon_poly_add
	.globl	falcon_poly_addconst
	.type	falcon_poly_addconst, @function
falcon_poly_addconst:
.LFB35:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx	# tmp104, a
# inputs/bootstrap/source/falcon-fft.c:367: 	a[0] = fpr_add(a[0], x);
	movq	(%rdi), %rdi	# *a_4(D), *a_4(D)
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:367: 	a[0] = fpr_add(a[0], x);
	movq	%rax, (%rbx)	# tmp106, *a_4(D)
# inputs/bootstrap/source/falcon-fft.c:368: }
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE35:
	.size	falcon_poly_addconst, .-falcon_poly_addconst
	.globl	falcon_poly_addconst_fft
	.type	falcon_poly_addconst_fft, @function
falcon_poly_addconst_fft:
.LFB36:
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
	movq	%rdi, %rbp	# tmp109, a
	movq	%rsi, %r13	# tmp110, x
# inputs/bootstrap/source/falcon-fft.c:376: 	hn = (size_t)1 << (logn - 1);
	leal	-1(%rdx), %ecx	#, _1
# inputs/bootstrap/source/falcon-fft.c:376: 	hn = (size_t)1 << (logn - 1);
	movl	$1, %r12d	#, tmp107
	salq	%cl, %r12	# _1, hn
# inputs/bootstrap/source/falcon-fft.c:377: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L36:
# inputs/bootstrap/source/falcon-fft.c:378: 		a[u] = fpr_add(a[u], x);
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_11(D) + u_18 * 8], MEM[(fpr *)a_11(D) + u_18 * 8]
	movq	%r13, %rsi	# x,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:378: 		a[u] = fpr_add(a[u], x);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp112, MEM[(fpr *)a_11(D) + u_18 * 8]
# inputs/bootstrap/source/falcon-fft.c:377: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:377: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, %r12	# u, hn
	jne	.L36	#,
# inputs/bootstrap/source/falcon-fft.c:380: }
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
.LFE36:
	.size	falcon_poly_addconst_fft, .-falcon_poly_addconst_fft
	.globl	falcon_poly_sub
	.type	falcon_poly_sub, @function
falcon_poly_sub:
.LFB37:
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
	movq	%rdi, %rbp	# tmp111, a
	movq	%rsi, %r13	# tmp112, b
# inputs/bootstrap/source/falcon-fft.c:388: 	n = (size_t)1 << logn;
	movl	$1, %r12d	#, tmp107
	movl	%edx, %ecx	# tmp113, tmp116
	salq	%cl, %r12	# tmp116, n
# inputs/bootstrap/source/falcon-fft.c:389: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r14	#, tmp109
.L40:
	movq	%r14, %rsi	# tmp109, y_15
	xorq	0(%r13,%rbx,8), %rsi	# MEM[(const fpr *)b_11(D) + u_20 * 8], y_15
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_12(D) + u_20 * 8], MEM[(fpr *)a_12(D) + u_20 * 8]
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:390: 		a[u] = fpr_sub(a[u], b[u]);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp114, MEM[(fpr *)a_12(D) + u_20 * 8]
# inputs/bootstrap/source/falcon-fft.c:389: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:389: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r12	# u, n
	jne	.L40	#,
# inputs/bootstrap/source/falcon-fft.c:392: }
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
	.cfi_endproc
.LFE37:
	.size	falcon_poly_sub, .-falcon_poly_sub
	.globl	falcon_poly_neg
	.type	falcon_poly_neg, @function
falcon_poly_neg:
.LFB38:
	.cfi_startproc
	movq	%rdi, %rax	# a, ivtmp.148
	movl	$8, %edx	#, tmp107
	movl	%esi, %ecx	# tmp110, tmp112
	salq	%cl, %rdx	# tmp112, _19
	addq	%rdx, %rdi	# _19, _21
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdx	#, tmp108
	.p2align 4
.L44:
	xorq	%rdx, (%rax)	# tmp108, MEM[(fpr *)_13]
# inputs/bootstrap/source/falcon-fft.c:401: 	for (u = 0; u < n; u ++) {
	addq	$8, %rax	#, ivtmp.148
	cmpq	%rdi, %rax	# _21, ivtmp.148
	jne	.L44	#,
# inputs/bootstrap/source/falcon-fft.c:404: }
	ret	
	.cfi_endproc
.LFE38:
	.size	falcon_poly_neg, .-falcon_poly_neg
	.globl	falcon_poly_adj
	.type	falcon_poly_adj, @function
falcon_poly_adj:
.LFB39:
	.cfi_startproc
# inputs/bootstrap/source/falcon-fft.c:412: 	n = (size_t)1 << logn;
	movl	$1, %edx	#, tmp121
	movl	%esi, %ecx	# tmp133, tmp135
	salq	%cl, %rdx	# tmp135, n
# inputs/bootstrap/source/falcon-fft.c:413: 	hn = n >> 1;
	movq	%rdx, %r10	# n, hn
	shrq	%r10	# hn
# inputs/bootstrap/source/falcon-fft.c:414: 	for (u = 1; u < hn; u ++) {
	cmpq	$3, %rdx	#, n
	jbe	.L47	#,
	leaq	8(%rdi), %rax	#, ivtmp.155
	leaq	-8(%rdi,%rdx,8), %rdx	#, ivtmp.157
	leaq	(%rdi,%r10,8), %r9	#, _43
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rcx	#, tmp125
	.p2align 5
.L48:
	movq	%rcx, %rsi	# tmp125, x
	xorq	(%rax), %rsi	# MEM[(fpr *)_37], x
	movq	%rcx, %r8	# tmp125, x_18
	xorq	(%rdx), %r8	# MEM[(fpr *)_39], x_18
# inputs/bootstrap/source/falcon-fft.c:418: 		a[u] = fpr_neg(a[n - u]);
	movq	%r8, (%rax)	# x_18, MEM[(fpr *)_37]
# inputs/bootstrap/source/falcon-fft.c:419: 		a[n - u] = t;
	movq	%rsi, (%rdx)	# x, MEM[(fpr *)_39]
# inputs/bootstrap/source/falcon-fft.c:414: 	for (u = 1; u < hn; u ++) {
	addq	$8, %rax	#, ivtmp.155
	subq	$8, %rdx	#, ivtmp.157
	cmpq	%r9, %rax	# _43, ivtmp.155
	jne	.L48	#,
.L47:
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	btcq	$63, (%rdi,%r10,8)	#, *_9
# inputs/bootstrap/source/falcon-fft.c:422: }
	ret	
	.cfi_endproc
.LFE39:
	.size	falcon_poly_adj, .-falcon_poly_adj
	.globl	falcon_poly_adj_fft
	.type	falcon_poly_adj_fft, @function
falcon_poly_adj_fft:
.LFB40:
	.cfi_startproc
	movl	%esi, %ecx	# tmp117, logn
# inputs/bootstrap/source/falcon-fft.c:430: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp111
	salq	%cl, %rax	# logn, n
# inputs/bootstrap/source/falcon-fft.c:431: 	for (u = (n >> 1); u < n; u ++) {
	movq	%rax, %rdx	# n, u
	shrq	%rdx	# u
# inputs/bootstrap/source/falcon-fft.c:431: 	for (u = (n >> 1); u < n; u ++) {
	cmpq	%rax, %rdx	# n, u
	jnb	.L50	#,
	leaq	(%rdi,%rdx,8), %rax	#, ivtmp.166
	movl	$8, %edx	#, tmp114
	salq	%cl, %rdx	# logn, _23
	addq	%rdx, %rdi	# _23, _25
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdx	#, tmp115
	.p2align 4
.L52:
	xorq	%rdx, (%rax)	# tmp115, MEM[(fpr *)_21]
# inputs/bootstrap/source/falcon-fft.c:431: 	for (u = (n >> 1); u < n; u ++) {
	addq	$8, %rax	#, ivtmp.166
	cmpq	%rdi, %rax	# _25, ivtmp.166
	jne	.L52	#,
.L50:
# inputs/bootstrap/source/falcon-fft.c:434: }
	ret	
	.cfi_endproc
.LFE40:
	.size	falcon_poly_adj_fft, .-falcon_poly_adj_fft
	.globl	falcon_poly_mul_fft
	.type	falcon_poly_mul_fft, @function
falcon_poly_mul_fft:
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
	subq	$40, %rsp	#,
	.cfi_def_cfa_offset 96
	movq	%rsi, 24(%rsp)	# tmp121, %sfp
# inputs/bootstrap/source/falcon-fft.c:442: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp117
	movl	%edx, %ecx	# tmp122, tmp130
	salq	%cl, %rax	# tmp130, n_15
# inputs/bootstrap/source/falcon-fft.c:444: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_15
	movq	%rax, 16(%rsp)	# hn, %sfp
	je	.L54	#,
	movq	%rdi, %r12	# tmp120, a
	leaq	0(,%rax,8), %rbp	#, ivtmp.177
# inputs/bootstrap/source/falcon-fft.c:444: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L56:
# inputs/bootstrap/source/falcon-fft.c:447: 		a_re = a[u];
	movq	(%r12,%rbx,8), %rax	# MEM[(fpr *)a_18(D) + u_38 * 8], a_re
	movq	%rax, (%rsp)	# a_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:448: 		a_im = a[u + hn];
	movq	(%r12,%rbp), %r14	# MEM[(fpr *)a_18(D) + ivtmp.177_12 * 1], a_im
# inputs/bootstrap/source/falcon-fft.c:449: 		b_re = b[u];
	movq	24(%rsp), %rcx	# %sfp, b
	movq	(%rcx,%rbx,8), %r15	# MEM[(const fpr *)b_21(D) + u_38 * 8], b_re
# inputs/bootstrap/source/falcon-fft.c:450: 		b_im = b[u + hn];
	movq	(%rcx,%rbp), %r13	# MEM[(const fpr *)b_21(D) + ivtmp.177_12 * 1], b_im
# inputs/bootstrap/source/falcon-fft.c:451: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# b_im,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp123, %sfp
# inputs/bootstrap/source/falcon-fft.c:451: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r15, %rsi	# b_re,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp124, _9
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	8(%rsp), %rsi	# %sfp, _8
	movabsq	$-9223372036854775808, %rdx	#, tmp137
	xorq	%rdx, %rsi	# tmp137, _8
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp125, %sfp
# inputs/bootstrap/source/falcon-fft.c:451: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r15, %rsi	# b_re,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp126, _10
# inputs/bootstrap/source/falcon-fft.c:451: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# b_im,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp127, _11
# inputs/bootstrap/source/falcon-fft.c:451: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# _10,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:451: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rdx	# %sfp, _34
	movq	%rdx, (%r12,%rbx,8)	# _34, MEM[(fpr *)a_18(D) + u_38 * 8]
	movq	%rax, (%r12,%rbp)	# tmp128, MEM[(fpr *)a_18(D) + ivtmp.177_12 * 1]
# inputs/bootstrap/source/falcon-fft.c:444: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:444: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbp	#, ivtmp.177
	cmpq	%rbx, 16(%rsp)	# u, %sfp
	jne	.L56	#,
.L54:
# inputs/bootstrap/source/falcon-fft.c:453: }
	addq	$40, %rsp	#,
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
	.size	falcon_poly_mul_fft, .-falcon_poly_mul_fft
	.globl	falcon_poly_sqr_fft
	.type	falcon_poly_sqr_fft, @function
falcon_poly_sqr_fft:
.LFB42:
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
# inputs/bootstrap/source/falcon-fft.c:461: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp121
	movl	%esi, %ecx	# tmp133, tmp139
	salq	%cl, %rax	# tmp139, n_10
# inputs/bootstrap/source/falcon-fft.c:463: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_10
	movq	%rax, 8(%rsp)	# hn, %sfp
	je	.L59	#,
	movq	%rdi, %r14	# tmp132, a
	leaq	(%rdi,%rax,8), %r15	#, _36
# inputs/bootstrap/source/falcon-fft.c:463: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L61:
# inputs/bootstrap/source/falcon-fft.c:466: 		a_re = a[u];
	movq	(%r14,%rbx,8), %r12	# MEM[(fpr *)a_13(D) + u_37 * 8], a_re
# inputs/bootstrap/source/falcon-fft.c:467: 		a_im = a[u + hn];
	movq	(%r15,%rbx,8), %r13	# MEM[(fpr *)_36 + u_37 * 8], a_im
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%r13, %rsi	# a_im,
	movq	%r13, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp134, _31
	movq	%r12, %rsi	# a_re,
	movq	%r12, %rdi	# a_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp135, _30
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_28
	xorq	%rbp, %rsi	# _31, y_28
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp136, _29
# inputs/bootstrap/source/falcon-fft.c:468: 		FPC_SQR(a[u], a[u + hn], a_re, a_im);
	movq	%r13, %rsi	# a_im,
	movq	%r12, %rdi	# a_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rcx	# tmp137, _6
# inputs/bootstrap/source/falcon-fft.c:468: 		FPC_SQR(a[u], a[u + hn], a_re, a_im);
	movq	%rbp, (%r14,%rbx,8)	# _29, MEM[(fpr *)a_13(D) + u_37 * 8]
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrq	$52, %rax	#, _17
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	andl	$2047, %eax	#, _22
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addl	$2047, %eax	#, _23
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrl	$11, %eax	#, _24
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	movq	%rax, %rdx	# _24, _26
	salq	$52, %rdx	#, _26
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	leaq	(%rdx,%rcx), %rax	#, tmp131
	movq	%rax, (%r15,%rbx,8)	# tmp131, MEM[(fpr *)_36 + u_37 * 8]
# inputs/bootstrap/source/falcon-fft.c:463: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:463: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, 8(%rsp)	# u, %sfp
	jne	.L61	#,
.L59:
# inputs/bootstrap/source/falcon-fft.c:470: }
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
.LFE42:
	.size	falcon_poly_sqr_fft, .-falcon_poly_sqr_fft
	.globl	falcon_poly_muladj_fft
	.type	falcon_poly_muladj_fft, @function
falcon_poly_muladj_fft:
.LFB43:
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
	movq	%rsi, 24(%rsp)	# tmp123, %sfp
# inputs/bootstrap/source/falcon-fft.c:478: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp118
	movl	%edx, %ecx	# tmp124, tmp132
	salq	%cl, %rax	# tmp132, n_16
# inputs/bootstrap/source/falcon-fft.c:480: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_16
	movq	%rax, 16(%rsp)	# hn, %sfp
	je	.L64	#,
	movq	%rdi, %r12	# tmp122, a
	leaq	0(,%rax,8), %rbp	#, ivtmp.196
# inputs/bootstrap/source/falcon-fft.c:480: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L66:
# inputs/bootstrap/source/falcon-fft.c:483: 		a_re = a[u];
	movq	(%r12,%rbx,8), %rax	# MEM[(fpr *)a_19(D) + u_39 * 8], a_re
	movq	%rax, (%rsp)	# a_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:484: 		a_im = a[u + hn];
	movq	(%r12,%rbp), %r14	# MEM[(fpr *)a_19(D) + ivtmp.196_13 * 1], a_im
# inputs/bootstrap/source/falcon-fft.c:485: 		b_re = b[u];
	movq	24(%rsp), %rcx	# %sfp, b
	movq	(%rcx,%rbx,8), %r15	# MEM[(const fpr *)b_22(D) + u_39 * 8], b_re
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r13	#, x
	xorq	(%rcx,%rbp), %r13	# MEM[(const fpr *)b_22(D) + ivtmp.196_13 * 1], x
# inputs/bootstrap/source/falcon-fft.c:487: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# x,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp125, %sfp
# inputs/bootstrap/source/falcon-fft.c:487: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r15, %rsi	# b_re,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp126, _10
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	8(%rsp), %rsi	# %sfp, _9
	movabsq	$-9223372036854775808, %rdx	#, tmp140
	xorq	%rdx, %rsi	# tmp140, _9
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp127, %sfp
# inputs/bootstrap/source/falcon-fft.c:487: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r15, %rsi	# b_re,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp128, _11
# inputs/bootstrap/source/falcon-fft.c:487: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# x,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp129, _12
# inputs/bootstrap/source/falcon-fft.c:487: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# _11,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:487: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rdx	# %sfp, _34
	movq	%rdx, (%r12,%rbx,8)	# _34, MEM[(fpr *)a_19(D) + u_39 * 8]
	movq	%rax, (%r12,%rbp)	# tmp130, MEM[(fpr *)a_19(D) + ivtmp.196_13 * 1]
# inputs/bootstrap/source/falcon-fft.c:480: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:480: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbp	#, ivtmp.196
	cmpq	%rbx, 16(%rsp)	# u, %sfp
	jne	.L66	#,
.L64:
# inputs/bootstrap/source/falcon-fft.c:489: }
	addq	$40, %rsp	#,
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
.LFE43:
	.size	falcon_poly_muladj_fft, .-falcon_poly_muladj_fft
	.globl	falcon_poly_mulselfadj_fft
	.type	falcon_poly_mulselfadj_fft, @function
falcon_poly_mulselfadj_fft:
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
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 64
# inputs/bootstrap/source/falcon-fft.c:501: 	n = (size_t)1 << logn;
	movl	$1, %r14d	#, tmp112
	movl	%esi, %ecx	# tmp115, tmp121
	salq	%cl, %r14	# tmp121, n_10
# inputs/bootstrap/source/falcon-fft.c:503: 	for (u = 0; u < hn; u ++) {
	shrq	%r14	# hn
	je	.L69	#,
	movq	%rdi, %r12	# tmp114, a
	leaq	(%rdi,%r14,8), %r13	#, _27
# inputs/bootstrap/source/falcon-fft.c:503: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L71:
# inputs/bootstrap/source/falcon-fft.c:506: 		a_re = a[u];
	movq	(%r12,%rbx,8), %r15	# MEM[(fpr *)a_13(D) + u_28 * 8], a_re
# inputs/bootstrap/source/falcon-fft.c:507: 		a_im = a[u + hn];
	movq	0(%r13,%rbx,8), %rdi	# MEM[(fpr *)_27 + u_28 * 8], a_im
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp116, _22
	movq	%r15, %rsi	# a_re,
	movq	%r15, %rdi	# a_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp117, _21
# inputs/bootstrap/source/falcon-fft.c:508: 		a[u] = fpr_add(fpr_sqr(a_re), fpr_sqr(a_im));
	movq	%rbp, %rsi	# _22,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:508: 		a[u] = fpr_add(fpr_sqr(a_re), fpr_sqr(a_im));
	movq	%rax, (%r12,%rbx,8)	# tmp118, MEM[(fpr *)a_13(D) + u_28 * 8]
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$0, %edi	#,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-fft.c:509: 		a[u + hn] = fpr_of(0);
	movq	%rax, 0(%r13,%rbx,8)	# tmp119, MEM[(fpr *)_27 + u_28 * 8]
# inputs/bootstrap/source/falcon-fft.c:503: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:503: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, %r14	# u, hn
	jne	.L71	#,
.L69:
# inputs/bootstrap/source/falcon-fft.c:511: }
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
.LFE44:
	.size	falcon_poly_mulselfadj_fft, .-falcon_poly_mulselfadj_fft
	.globl	falcon_poly_mulconst
	.type	falcon_poly_mulconst, @function
falcon_poly_mulconst:
.LFB45:
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
	movq	%rdi, %rbp	# tmp107, a
	movq	%rsi, %r13	# tmp108, x
# inputs/bootstrap/source/falcon-fft.c:519: 	n = (size_t)1 << logn;
	movl	$1, %r12d	#, tmp105
	movl	%edx, %ecx	# tmp109, tmp112
	salq	%cl, %r12	# tmp112, n
# inputs/bootstrap/source/falcon-fft.c:520: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L75:
# inputs/bootstrap/source/falcon-fft.c:521: 		a[u] = fpr_mul(a[u], x);
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_10(D) + u_17 * 8], MEM[(fpr *)a_10(D) + u_17 * 8]
	movq	%r13, %rsi	# x,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:521: 		a[u] = fpr_mul(a[u], x);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp110, MEM[(fpr *)a_10(D) + u_17 * 8]
# inputs/bootstrap/source/falcon-fft.c:520: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:520: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r12	# u, n
	jne	.L75	#,
# inputs/bootstrap/source/falcon-fft.c:523: }
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
.LFE45:
	.size	falcon_poly_mulconst, .-falcon_poly_mulconst
	.globl	falcon_poly_inv_fft
	.type	falcon_poly_inv_fft, @function
falcon_poly_inv_fft:
.LFB46:
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
# inputs/bootstrap/source/falcon-fft.c:531: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp114
	movl	%esi, %ecx	# tmp119, tmp126
	salq	%cl, %rax	# tmp126, n_9
# inputs/bootstrap/source/falcon-fft.c:533: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_9
	movq	%rax, 8(%rsp)	# hn, %sfp
	je	.L78	#,
	movq	%rdi, %r14	# tmp118, a
	leaq	(%rdi,%rax,8), %r15	#, _30
# inputs/bootstrap/source/falcon-fft.c:533: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L80:
# inputs/bootstrap/source/falcon-fft.c:536: 		a_re = a[u];
	movq	(%r14,%rbx,8), %r13	# MEM[(fpr *)a_12(D) + u_31 * 8], a_re
# inputs/bootstrap/source/falcon-fft.c:537: 		a_im = a[u + hn];
	movq	(%r15,%rbx,8), %rbp	# MEM[(fpr *)_30 + u_31 * 8], a_im
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rbp, %rsi	# a_im,
	movq	%rbp, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp120, _26
	movq	%r13, %rsi	# a_re,
	movq	%r13, %rdi	# a_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp121, _25
# inputs/bootstrap/source/falcon-fft.c:538: 		FPC_INV(a[u], a[u + hn], a_re, a_im);
	movq	%r12, %rsi	# _26,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp122, fpct_m
# inputs/bootstrap/source/falcon-fft.c:538: 		FPC_INV(a[u], a[u + hn], a_re, a_im);
	movq	%rax, %rsi	# fpct_m,
	movq	%r13, %rdi	# a_re,
	call	fpr_div@PLT	#
	movq	%rax, %r13	# tmp123, fpct_d_re
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdi	#, x_19
	xorq	%rbp, %rdi	# a_im, x_19
# inputs/bootstrap/source/falcon-fft.c:538: 		FPC_INV(a[u], a[u + hn], a_re, a_im);
	movq	%r12, %rsi	# fpct_m,
	call	fpr_div@PLT	#
# inputs/bootstrap/source/falcon-fft.c:538: 		FPC_INV(a[u], a[u + hn], a_re, a_im);
	movq	%r13, (%r14,%rbx,8)	# fpct_d_re, MEM[(fpr *)a_12(D) + u_31 * 8]
	movq	%rax, (%r15,%rbx,8)	# tmp124, MEM[(fpr *)_30 + u_31 * 8]
# inputs/bootstrap/source/falcon-fft.c:533: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:533: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, 8(%rsp)	# u, %sfp
	jne	.L80	#,
.L78:
# inputs/bootstrap/source/falcon-fft.c:540: }
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
.LFE46:
	.size	falcon_poly_inv_fft, .-falcon_poly_inv_fft
	.globl	falcon_poly_div_fft
	.type	falcon_poly_div_fft, @function
falcon_poly_div_fft:
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
	subq	$40, %rsp	#,
	.cfi_def_cfa_offset 96
	movq	%rsi, 24(%rsp)	# tmp129, %sfp
# inputs/bootstrap/source/falcon-fft.c:548: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp123
	movl	%edx, %ecx	# tmp130, tmp143
	salq	%cl, %rax	# tmp143, n_15
# inputs/bootstrap/source/falcon-fft.c:550: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_15
	movq	%rax, 16(%rsp)	# hn, %sfp
	je	.L83	#,
	movq	%rdi, %r13	# tmp128, a
	leaq	0(,%rax,8), %r12	#, ivtmp.229
# inputs/bootstrap/source/falcon-fft.c:550: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L85:
# inputs/bootstrap/source/falcon-fft.c:553: 		a_re = a[u];
	movq	0(%r13,%rbx,8), %rax	# MEM[(fpr *)a_18(D) + u_49 * 8], a_re
	movq	%rax, (%rsp)	# a_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:554: 		a_im = a[u + hn];
	movq	0(%r13,%r12), %r15	# MEM[(fpr *)a_18(D) + ivtmp.229_12 * 1], a_im
# inputs/bootstrap/source/falcon-fft.c:555: 		b_re = b[u];
	movq	24(%rsp), %rcx	# %sfp, b
	movq	(%rcx,%rbx,8), %r14	# MEM[(const fpr *)b_21(D) + u_49 * 8], b_re
# inputs/bootstrap/source/falcon-fft.c:556: 		b_im = b[u + hn];
	movq	(%rcx,%r12), %rbp	# MEM[(const fpr *)b_21(D) + ivtmp.229_12 * 1], b_im
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rbp, %rsi	# b_im,
	movq	%rbp, %rdi	# b_im,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp131, %sfp
	movq	%r14, %rsi	# b_re,
	movq	%r14, %rdi	# b_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp132, _42
# inputs/bootstrap/source/falcon-fft.c:557: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:557: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%rax, 8(%rsp)	# fpct_m, %sfp
	movq	%rax, %rsi	# fpct_m,
	movq	%r14, %rdi	# b_re,
	call	fpr_div@PLT	#
	movq	%rax, %r14	# tmp134, fpct_b_re
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdi	#, x_41
	xorq	%rbp, %rdi	# b_im, x_41
# inputs/bootstrap/source/falcon-fft.c:557: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rsi	# %sfp,
	call	fpr_div@PLT	#
	movq	%rax, %rbp	# tmp135, fpct_b_im
# inputs/bootstrap/source/falcon-fft.c:557: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%rax, %rsi	# fpct_b_im,
	movq	%r15, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp136, %sfp
# inputs/bootstrap/source/falcon-fft.c:557: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# fpct_b_re,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp137, _9
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	8(%rsp), %rsi	# %sfp, _8
	movabsq	$-9223372036854775808, %rdx	#, tmp151
	xorq	%rdx, %rsi	# tmp151, _8
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp138, %sfp
# inputs/bootstrap/source/falcon-fft.c:557: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# fpct_b_re,
	movq	%r15, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp139, _10
# inputs/bootstrap/source/falcon-fft.c:557: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%rbp, %rsi	# fpct_b_im,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp140, _11
# inputs/bootstrap/source/falcon-fft.c:557: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# _10,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:557: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rdx	# %sfp, _40
	movq	%rdx, 0(%r13,%rbx,8)	# _40, MEM[(fpr *)a_18(D) + u_49 * 8]
	movq	%rax, 0(%r13,%r12)	# tmp141, MEM[(fpr *)a_18(D) + ivtmp.229_12 * 1]
# inputs/bootstrap/source/falcon-fft.c:550: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:550: 	for (u = 0; u < hn; u ++) {
	addq	$8, %r12	#, ivtmp.229
	cmpq	%rbx, 16(%rsp)	# u, %sfp
	jne	.L85	#,
.L83:
# inputs/bootstrap/source/falcon-fft.c:559: }
	addq	$40, %rsp	#,
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
.LFE47:
	.size	falcon_poly_div_fft, .-falcon_poly_div_fft
	.globl	falcon_poly_divadj_fft
	.type	falcon_poly_divadj_fft, @function
falcon_poly_divadj_fft:
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
	subq	$40, %rsp	#,
	.cfi_def_cfa_offset 96
	movq	%rsi, 24(%rsp)	# tmp128, %sfp
# inputs/bootstrap/source/falcon-fft.c:567: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp123
	movl	%edx, %ecx	# tmp129, tmp142
	salq	%cl, %rax	# tmp142, n_16
# inputs/bootstrap/source/falcon-fft.c:569: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_16
	movq	%rax, 16(%rsp)	# hn, %sfp
	je	.L88	#,
	movq	%rdi, %r12	# tmp127, a
	leaq	0(,%rax,8), %rbp	#, ivtmp.240
# inputs/bootstrap/source/falcon-fft.c:569: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L90:
# inputs/bootstrap/source/falcon-fft.c:572: 		a_re = a[u];
	movq	(%r12,%rbx,8), %rax	# MEM[(fpr *)a_19(D) + u_49 * 8], a_re
	movq	%rax, (%rsp)	# a_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:573: 		a_im = a[u + hn];
	movq	(%r12,%rbp), %r14	# MEM[(fpr *)a_19(D) + ivtmp.240_13 * 1], a_im
# inputs/bootstrap/source/falcon-fft.c:574: 		b_re = b[u];
	movq	24(%rsp), %rcx	# %sfp, b
	movq	(%rcx,%rbx,8), %r13	# MEM[(const fpr *)b_22(D) + u_49 * 8], b_re
# inputs/bootstrap/source/falcon-fft.c:575: 		b_im = fpr_neg(b[u + hn]);
	movq	(%rcx,%rbp), %r15	# MEM[(const fpr *)b_22(D) + ivtmp.240_13 * 1], _8
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdi	#, x
	xorq	%r15, %rdi	# _8, x
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# x,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp130, %sfp
	movq	%r13, %rsi	# b_re,
	movq	%r13, %rdi	# b_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp131, _41
# inputs/bootstrap/source/falcon-fft.c:576: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:576: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%rax, 8(%rsp)	# fpct_m, %sfp
	movq	%rax, %rsi	# fpct_m,
	movq	%r13, %rdi	# b_re,
	call	fpr_div@PLT	#
	movq	%rax, %r13	# tmp133, fpct_b_re
# inputs/bootstrap/source/falcon-fft.c:576: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# _8,
	call	fpr_div@PLT	#
	movq	%rax, %r15	# tmp134, fpct_b_im
# inputs/bootstrap/source/falcon-fft.c:576: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%rax, %rsi	# fpct_b_im,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp135, %sfp
# inputs/bootstrap/source/falcon-fft.c:576: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# fpct_b_re,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp136, _10
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	8(%rsp), %rsi	# %sfp, _9
	movabsq	$-9223372036854775808, %rdx	#, tmp150
	xorq	%rdx, %rsi	# tmp150, _9
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp137, %sfp
# inputs/bootstrap/source/falcon-fft.c:576: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# fpct_b_re,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r13	# tmp138, _11
# inputs/bootstrap/source/falcon-fft.c:576: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r15, %rsi	# fpct_b_im,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp139, _12
# inputs/bootstrap/source/falcon-fft.c:576: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# _11,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:576: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rdx	# %sfp, _24
	movq	%rdx, (%r12,%rbx,8)	# _24, MEM[(fpr *)a_19(D) + u_49 * 8]
	movq	%rax, (%r12,%rbp)	# tmp140, MEM[(fpr *)a_19(D) + ivtmp.240_13 * 1]
# inputs/bootstrap/source/falcon-fft.c:569: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:569: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbp	#, ivtmp.240
	cmpq	%rbx, 16(%rsp)	# u, %sfp
	jne	.L90	#,
.L88:
# inputs/bootstrap/source/falcon-fft.c:578: }
	addq	$40, %rsp	#,
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
	.size	falcon_poly_divadj_fft, .-falcon_poly_divadj_fft
	.globl	falcon_poly_invnorm2_fft
	.type	falcon_poly_invnorm2_fft, @function
falcon_poly_invnorm2_fft:
.LFB49:
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
	movq	%rdi, 16(%rsp)	# tmp121, %sfp
	movq	%rsi, 24(%rsp)	# tmp122, %sfp
# inputs/bootstrap/source/falcon-fft.c:587: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp119
	salq	%cl, %rax	# tmp124, n_15
# inputs/bootstrap/source/falcon-fft.c:589: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_15
	movq	%rax, 8(%rsp)	# hn, %sfp
	je	.L93	#,
	movq	%rdx, %r15	# tmp123, b
	leaq	0(,%rax,8), %rbp	#, ivtmp.252
# inputs/bootstrap/source/falcon-fft.c:589: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L95:
# inputs/bootstrap/source/falcon-fft.c:593: 		a_re = a[u];
	movq	24(%rsp), %rax	# %sfp, a
	movq	(%rax,%rbx,8), %r12	# MEM[(const fpr *)a_18(D) + u_42 * 8], a_re
# inputs/bootstrap/source/falcon-fft.c:594: 		a_im = a[u + hn];
	movq	(%rax,%rbp), %r13	# MEM[(const fpr *)a_18(D) + ivtmp.252_12 * 1], a_im
# inputs/bootstrap/source/falcon-fft.c:595: 		b_re = b[u];
	movq	(%r15,%rbx,8), %r14	# MEM[(const fpr *)b_21(D) + u_42 * 8], b_re
# inputs/bootstrap/source/falcon-fft.c:596: 		b_im = b[u + hn];
	movq	(%r15,%rbp), %rdi	# MEM[(const fpr *)b_21(D) + ivtmp.252_12 * 1], b_im
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# b_im,
	call	fpr_mul@PLT	#
	movq	%rax, (%rsp)	# tmp125, %sfp
	movq	%r14, %rsi	# b_re,
	movq	%r14, %rdi	# b_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp126, _33
# inputs/bootstrap/source/falcon-fft.c:597: 		d[u] = fpr_inv(fpr_add(
	movq	(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp127, _8
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%r13, %rsi	# a_im,
	movq	%r13, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r13	# tmp128, _32
	movq	%r12, %rsi	# a_re,
	movq	%r12, %rdi	# a_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp129, _31
# inputs/bootstrap/source/falcon-fft.c:597: 		d[u] = fpr_inv(fpr_add(
	movq	%r13, %rsi	# _32,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp130, _9
# inputs/bootstrap/source/falcon-fft.c:597: 		d[u] = fpr_inv(fpr_add(
	movq	%r14, %rsi	# _8,
	call	fpr_add@PLT	#
	movq	%rax, %rsi	# tmp131, _10
# inputs/bootstrap/source/fpr-emulated.h:192: 	return fpr_div(fpr_one, x);
	movabsq	$4607182418800017408, %rdi	#,
	call	fpr_div@PLT	#
# inputs/bootstrap/source/falcon-fft.c:597: 		d[u] = fpr_inv(fpr_add(
	movq	16(%rsp), %rdx	# %sfp, d
	movq	%rax, (%rdx,%rbx,8)	# tmp132, MEM[(fpr *)d_27(D) + u_42 * 8]
# inputs/bootstrap/source/falcon-fft.c:589: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:589: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbp	#, ivtmp.252
	cmpq	%rbx, 8(%rsp)	# u, %sfp
	jne	.L95	#,
.L93:
# inputs/bootstrap/source/falcon-fft.c:601: }
	addq	$40, %rsp	#,
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
.LFE49:
	.size	falcon_poly_invnorm2_fft, .-falcon_poly_invnorm2_fft
	.globl	falcon_poly_add_muladj_fft
	.type	falcon_poly_add_muladj_fft, @function
falcon_poly_add_muladj_fft:
.LFB50:
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
	movq	%rdi, 48(%rsp)	# tmp142, %sfp
	movq	%rsi, 56(%rsp)	# tmp143, %sfp
	movq	%rdx, 64(%rsp)	# tmp144, %sfp
	movq	%rcx, 72(%rsp)	# tmp145, %sfp
	movq	%r8, 80(%rsp)	# tmp146, %sfp
# inputs/bootstrap/source/falcon-fft.c:611: 	n = (size_t)1 << logn;
	movl	$1, %edx	#, tmp135
	movl	%r9d, %ecx	# tmp147, tmp166
	salq	%cl, %rdx	# tmp166, n_27
# inputs/bootstrap/source/falcon-fft.c:613: 	for (u = 0; u < hn; u ++) {
	shrq	%rdx	# hn
	je	.L98	#,
	leaq	0(,%rdx,8), %rbx	#, ivtmp.269
# inputs/bootstrap/source/falcon-fft.c:613: 	for (u = 0; u < hn; u ++) {
	movl	$0, %r15d	#, u
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rbp	#, tmp136
	movq	%rdx, 88(%rsp)	# hn, %sfp
.L100:
# inputs/bootstrap/source/falcon-fft.c:618: 		F_re = F[u];
	movq	56(%rsp), %rax	# %sfp, F
	movq	(%rax,%r15,8), %r12	# MEM[(const fpr *)F_30(D) + u_70 * 8], F_re
# inputs/bootstrap/source/falcon-fft.c:619: 		F_im = F[u + hn];
	movq	(%rax,%rbx), %r13	# MEM[(const fpr *)F_30(D) + ivtmp.269_24 * 1], F_im
# inputs/bootstrap/source/falcon-fft.c:620: 		G_re = G[u];
	movq	64(%rsp), %rax	# %sfp, G
	movq	(%rax,%r15,8), %rcx	# MEM[(const fpr *)G_33(D) + u_70 * 8], G_re
	movq	%rcx, (%rsp)	# G_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:621: 		G_im = G[u + hn];
	movq	(%rax,%rbx), %r14	# MEM[(const fpr *)G_33(D) + ivtmp.269_24 * 1], G_im
	movq	%r14, 32(%rsp)	# G_im, %sfp
# inputs/bootstrap/source/falcon-fft.c:622: 		f_re = f[u];
	movq	72(%rsp), %rax	# %sfp, f
	movq	(%rax,%r15,8), %r14	# MEM[(const fpr *)f_36(D) + u_70 * 8], f_re
# inputs/bootstrap/source/falcon-fft.c:624: 		g_re = g[u];
	movq	80(%rsp), %rdx	# %sfp, g
	movq	(%rdx,%r15,8), %rsi	# MEM[(const fpr *)g_39(D) + u_70 * 8], g_re
	movq	%rsi, 8(%rsp)	# g_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:625: 		g_im = g[u + hn];
	movq	(%rdx,%rbx), %rdx	# MEM[(const fpr *)g_39(D) + ivtmp.269_24 * 1], g_im
	movq	%rdx, 40(%rsp)	# g_im, %sfp
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movq	%rax, %rdx	# f, f
	movq	%rbp, %rax	# tmp136, x
	xorq	(%rdx,%rbx), %rax	# MEM[(const fpr *)f_36(D) + ivtmp.269_24 * 1], x
# inputs/bootstrap/source/falcon-fft.c:627: 		FPC_MUL(a_re, a_im, F_re, F_im, f_re, fpr_neg(f_im));
	movq	%rax, 16(%rsp)	# x, %sfp
	movq	%rax, %rsi	# x,
	movq	%r13, %rdi	# F_im,
	call	fpr_mul@PLT	#
	movq	%rax, 24(%rsp)	# tmp148, %sfp
# inputs/bootstrap/source/falcon-fft.c:627: 		FPC_MUL(a_re, a_im, F_re, F_im, f_re, fpr_neg(f_im));
	movq	%r14, %rsi	# f_re,
	movq	%r12, %rdi	# F_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp149, _13
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	24(%rsp), %r10	# %sfp, _12
	xorq	%rbp, %r10	# tmp136, _12
	movq	%r10, %rsi	# _12, y_63
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 24(%rsp)	# tmp150, %sfp
# inputs/bootstrap/source/falcon-fft.c:627: 		FPC_MUL(a_re, a_im, F_re, F_im, f_re, fpr_neg(f_im));
	movq	%r14, %rsi	# f_re,
	movq	%r13, %rdi	# F_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r13	# tmp151, _14
# inputs/bootstrap/source/falcon-fft.c:627: 		FPC_MUL(a_re, a_im, F_re, F_im, f_re, fpr_neg(f_im));
	movq	16(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# F_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp152, _15
# inputs/bootstrap/source/falcon-fft.c:627: 		FPC_MUL(a_re, a_im, F_re, F_im, f_re, fpr_neg(f_im));
	movq	%r13, %rsi	# _14,
	call	fpr_add@PLT	#
	movq	%rax, 16(%rsp)	# tmp153, %sfp
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movq	40(%rsp), %r13	# %sfp, g_im
	xorq	%rbp, %r13	# tmp136, g_im
# inputs/bootstrap/source/falcon-fft.c:628: 		FPC_MUL(b_re, b_im, G_re, G_im, g_re, fpr_neg(g_im));
	movq	%r13, %rsi	# x,
	movq	32(%rsp), %r14	# %sfp, G_im
	movq	%r14, %rdi	# G_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp154, _16
# inputs/bootstrap/source/falcon-fft.c:628: 		FPC_MUL(b_re, b_im, G_re, G_im, g_re, fpr_neg(g_im));
	movq	8(%rsp), %rsi	# %sfp,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp155, _17
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%rbp, %r12	# tmp136, _16
	movq	%r12, %rsi	# _16, y_49
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp156, _42
# inputs/bootstrap/source/falcon-fft.c:628: 		FPC_MUL(b_re, b_im, G_re, G_im, g_re, fpr_neg(g_im));
	movq	8(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# G_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp157, _18
# inputs/bootstrap/source/falcon-fft.c:628: 		FPC_MUL(b_re, b_im, G_re, G_im, g_re, fpr_neg(g_im));
	movq	%r13, %rsi	# x,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp158, _19
# inputs/bootstrap/source/falcon-fft.c:628: 		FPC_MUL(b_re, b_im, G_re, G_im, g_re, fpr_neg(g_im));
	movq	%r14, %rsi	# _18,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp159, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:629: 		d[u] = fpr_add(a_re, b_re);
	movq	%r12, %rsi	# _42,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:629: 		d[u] = fpr_add(a_re, b_re);
	movq	48(%rsp), %r14	# %sfp, d
	movq	%rax, (%r14,%r15,8)	# tmp160, MEM[(fpr *)d_56(D) + u_70 * 8]
# inputs/bootstrap/source/falcon-fft.c:630: 		d[u + hn] = fpr_add(a_im, b_im);
	movq	%r13, %rsi	# fpct_d_im,
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:630: 		d[u + hn] = fpr_add(a_im, b_im);
	movq	%rax, (%r14,%rbx)	# tmp161, MEM[(fpr *)d_56(D) + ivtmp.269_24 * 1]
# inputs/bootstrap/source/falcon-fft.c:613: 	for (u = 0; u < hn; u ++) {
	addq	$1, %r15	#, u
# inputs/bootstrap/source/falcon-fft.c:613: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbx	#, ivtmp.269
	cmpq	%r15, 88(%rsp)	# u, %sfp
	jne	.L100	#,
.L98:
# inputs/bootstrap/source/falcon-fft.c:632: }
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
.LFE50:
	.size	falcon_poly_add_muladj_fft, .-falcon_poly_add_muladj_fft
	.globl	falcon_poly_mul_autoadj_fft
	.type	falcon_poly_mul_autoadj_fft, @function
falcon_poly_mul_autoadj_fft:
.LFB51:
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
# inputs/bootstrap/source/falcon-fft.c:641: 	n = (size_t)1 << logn;
	movl	$1, %r14d	#, tmp113
	movl	%edx, %ecx	# tmp121, tmp125
	salq	%cl, %r14	# tmp125, n_16
# inputs/bootstrap/source/falcon-fft.c:643: 	for (u = 0; u < hn; u ++) {
	shrq	%r14	# hn
	je	.L103	#,
	movq	%rdi, %rbp	# tmp119, a
	movq	%rsi, %r12	# tmp120, b
	leaq	(%rdi,%r14,8), %r13	#, _27
# inputs/bootstrap/source/falcon-fft.c:643: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L105:
# inputs/bootstrap/source/falcon-fft.c:644: 		a[u] = fpr_mul(a[u], b[u]);
	movq	(%r12,%rbx,8), %rsi	# MEM[(const fpr *)b_19(D) + u_28 * 8], MEM[(const fpr *)b_19(D) + u_28 * 8]
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_20(D) + u_28 * 8], MEM[(fpr *)a_20(D) + u_28 * 8]
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:644: 		a[u] = fpr_mul(a[u], b[u]);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp122, MEM[(fpr *)a_20(D) + u_28 * 8]
# inputs/bootstrap/source/falcon-fft.c:645: 		a[u + hn] = fpr_mul(a[u + hn], b[u]);
	movq	(%r12,%rbx,8), %rsi	# MEM[(const fpr *)b_19(D) + u_28 * 8], MEM[(const fpr *)b_19(D) + u_28 * 8]
	movq	0(%r13,%rbx,8), %rdi	# MEM[(fpr *)_27 + u_28 * 8], MEM[(fpr *)_27 + u_28 * 8]
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:645: 		a[u + hn] = fpr_mul(a[u + hn], b[u]);
	movq	%rax, 0(%r13,%rbx,8)	# tmp123, MEM[(fpr *)_27 + u_28 * 8]
# inputs/bootstrap/source/falcon-fft.c:643: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:643: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, %r14	# u, hn
	jne	.L105	#,
.L103:
# inputs/bootstrap/source/falcon-fft.c:647: }
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
	.cfi_endproc
.LFE51:
	.size	falcon_poly_mul_autoadj_fft, .-falcon_poly_mul_autoadj_fft
	.globl	falcon_poly_div_autoadj_fft
	.type	falcon_poly_div_autoadj_fft, @function
falcon_poly_div_autoadj_fft:
.LFB52:
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
# inputs/bootstrap/source/falcon-fft.c:656: 	n = (size_t)1 << logn;
	movl	$1, %r14d	#, tmp113
	movl	%edx, %ecx	# tmp121, tmp125
	salq	%cl, %r14	# tmp125, n_16
# inputs/bootstrap/source/falcon-fft.c:658: 	for (u = 0; u < hn; u ++) {
	shrq	%r14	# hn
	je	.L108	#,
	movq	%rdi, %rbp	# tmp119, a
	movq	%rsi, %r12	# tmp120, b
	leaq	(%rdi,%r14,8), %r13	#, _27
# inputs/bootstrap/source/falcon-fft.c:658: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L110:
# inputs/bootstrap/source/falcon-fft.c:659: 		a[u] = fpr_div(a[u], b[u]);
	movq	(%r12,%rbx,8), %rsi	# MEM[(const fpr *)b_19(D) + u_28 * 8], MEM[(const fpr *)b_19(D) + u_28 * 8]
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_20(D) + u_28 * 8], MEM[(fpr *)a_20(D) + u_28 * 8]
	call	fpr_div@PLT	#
# inputs/bootstrap/source/falcon-fft.c:659: 		a[u] = fpr_div(a[u], b[u]);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp122, MEM[(fpr *)a_20(D) + u_28 * 8]
# inputs/bootstrap/source/falcon-fft.c:660: 		a[u + hn] = fpr_div(a[u + hn], b[u]);
	movq	(%r12,%rbx,8), %rsi	# MEM[(const fpr *)b_19(D) + u_28 * 8], MEM[(const fpr *)b_19(D) + u_28 * 8]
	movq	0(%r13,%rbx,8), %rdi	# MEM[(fpr *)_27 + u_28 * 8], MEM[(fpr *)_27 + u_28 * 8]
	call	fpr_div@PLT	#
# inputs/bootstrap/source/falcon-fft.c:660: 		a[u + hn] = fpr_div(a[u + hn], b[u]);
	movq	%rax, 0(%r13,%rbx,8)	# tmp123, MEM[(fpr *)_27 + u_28 * 8]
# inputs/bootstrap/source/falcon-fft.c:658: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:658: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, %r14	# u, hn
	jne	.L110	#,
.L108:
# inputs/bootstrap/source/falcon-fft.c:662: }
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
	.cfi_endproc
.LFE52:
	.size	falcon_poly_div_autoadj_fft, .-falcon_poly_div_autoadj_fft
	.globl	falcon_poly_split_fft
	.type	falcon_poly_split_fft, @function
falcon_poly_split_fft:
.LFB53:
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
	subq	$72, %rsp	#,
	.cfi_def_cfa_offset 128
	movq	%rsi, 40(%rsp)	# f1, %sfp
# inputs/bootstrap/source/falcon-fft.c:677: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp173
	salq	%cl, %rax	# tmp216, tmp173
	movq	%rax, %rcx	# tmp173, n
# inputs/bootstrap/source/falcon-fft.c:678: 	hn = n >> 1;
	movq	%rax, %rbx	# n, hn
	shrq	%rbx	# hn
	movq	%rbx, 32(%rsp)	# hn, %sfp
# inputs/bootstrap/source/falcon-fft.c:687: 	f0[0] = f[0];
	movq	(%rdx), %rax	# *f_38(D), *f_38(D)
	movq	%rax, (%rdi)	# *f_38(D), *f0_39(D)
# inputs/bootstrap/source/falcon-fft.c:688: 	f1[0] = f[hn];
	movq	(%rdx,%rbx,8), %rax	# *_3, *_3
	movq	%rax, (%rsi)	# *_3, *f1_41(D)
# inputs/bootstrap/source/falcon-fft.c:690: 	for (u = 0; u < qn; u ++) {
	shrq	$2, %rcx	#, qn
	je	.L113	#,
	movq	%rdx, %rbp	# tmp215, f
	salq	$4, %rbx	#, _117
	leaq	fpr_gm_tab(%rip), %rax	#, tmp177
	addq	%rbx, %rax	# _117, ivtmp.297
	movq	%rax, (%rsp)	# ivtmp.297, %sfp
	leaq	0(,%rcx,8), %rax	#, ivtmp.308
	movq	%rax, 8(%rsp)	# ivtmp.308, %sfp
# inputs/bootstrap/source/falcon-fft.c:690: 	for (u = 0; u < qn; u ++) {
	movl	$0, %r12d	#, u
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%rcx, 48(%rsp)	# qn, %sfp
	movq	%rdi, 56(%rsp)	# f0, %sfp
.L115:
# inputs/bootstrap/source/falcon-fft.c:694: 		a_re = f[(u << 1) + 0];
	movq	0(%rbp), %r15	# MEM[(const fpr *)_122], a_re
# inputs/bootstrap/source/falcon-fft.c:695: 		a_im = f[(u << 1) + 0 + hn];
	movq	32(%rsp), %rax	# %sfp, hn
	movq	0(%rbp,%rax,8), %rcx	# MEM[(const fpr *)_122 + hn_35 * 8], a_im
	movq	%rcx, 16(%rsp)	# a_im, %sfp
# inputs/bootstrap/source/falcon-fft.c:696: 		b_re = f[(u << 1) + 1];
	movq	8(%rbp), %r14	# MEM[(const fpr *)_122 + 8B], b_re
# inputs/bootstrap/source/falcon-fft.c:697: 		b_im = f[(u << 1) + 1 + hn];
	movq	8(%rbp,%rax,8), %r13	# MEM[(const fpr *)_122 + 8B + hn_35 * 8], b_im
# inputs/bootstrap/source/falcon-fft.c:699: 		FPC_ADD(t_re, t_im, a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# b_re,
	movq	%r15, %rdi	# a_re,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp217, fpct_re
# inputs/bootstrap/source/falcon-fft.c:699: 		FPC_ADD(t_re, t_im, a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# b_im,
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rdx	#, tmp218
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	movabsq	$-4503599627370496, %rcx	#, tmp242
	addq	%rcx, %rbx	# tmp242, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rbx, %rax	# x, _98
	shrq	$52, %rax	#, _98
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %eax	#, _100
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %eax	#, _101
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %eax	#, t_102
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%eax, %eax	# t_102, _103
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rax	#, _104
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rax, %rbx	# _104, tmp184
	movq	56(%rsp), %rsi	# %sfp, f0
	movq	%rbx, (%rsi,%r12,8)	# tmp184, MEM[(fpr *)f0_39(D) + u_111 * 8]
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	leaq	(%rdx,%rcx), %rax	#, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rax, %rdx	# x, _89
	shrq	$52, %rdx	#, _89
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %edx	#, _91
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %edx	#, _92
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %edx	#, t_93
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%edx, %edx	# t_93, _94
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rdx	#, _95
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rdx, %rax	# _95, tmp191
	movq	8(%rsp), %rbx	# %sfp, ivtmp.308
	movq	%rax, (%rsi,%rbx)	# tmp191, MEM[(fpr *)f0_39(D) + ivtmp.308_119 * 1]
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_86
	xorq	%r14, %rsi	# b_re, y_86
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	%r15, %rdi	# a_re,
	call	fpr_add@PLT	#
	movq	%rax, 24(%rsp)	# tmp219, %sfp
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_84
	xorq	%r13, %rsi	# b_im, y_84
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp220, _85
# inputs/bootstrap/source/falcon-fft.c:704: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	(%rsp), %rsi	# %sfp, ivtmp.297
	movq	(%rsi), %r15	# MEM[(long unsigned int *)_124], fpct_b_re
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r14	#, x
	xorq	8(%rsi), %r14	# MEM[(long unsigned int *)_124 + 8B], x
# inputs/bootstrap/source/falcon-fft.c:704: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	%r14, %rsi	# x,
	movq	%rax, %rdi	# _85,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp221, _25
# inputs/bootstrap/source/falcon-fft.c:704: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	%r15, %rsi	# fpct_b_re,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp222, _26
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rax	#, y_81
	xorq	%rbx, %rax	# _25, y_81
	movq	%rax, %rsi	# y_81, y_81
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp223, _82
# inputs/bootstrap/source/falcon-fft.c:704: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	%r15, %rsi	# fpct_b_re,
	movq	%r13, %rdi	# _85,
	call	fpr_mul@PLT	#
	movq	%rax, %r13	# tmp224, _27
# inputs/bootstrap/source/falcon-fft.c:704: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	%r14, %rsi	# x,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp225, _28
# inputs/bootstrap/source/falcon-fft.c:704: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	%r13, %rsi	# _27,
	call	fpr_add@PLT	#
	movq	%rax, %rdx	#, tmp226
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	movabsq	$-4503599627370496, %rcx	#, tmp255
	addq	%rcx, %rbx	# tmp255, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rbx, %rax	# x, _73
	shrq	$52, %rax	#, _73
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %eax	#, _75
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %eax	#, _76
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %eax	#, t_77
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%eax, %eax	# t_77, _78
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rax	#, _79
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rax, %rbx	# _79, tmp205
	movq	40(%rsp), %r9	# %sfp, f1
	movq	%rbx, (%r9,%r12,8)	# tmp205, MEM[(fpr *)f1_41(D) + u_111 * 8]
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	leaq	(%rdx,%rcx), %rax	#, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rax, %rdx	# x, _63
	shrq	$52, %rdx	#, _63
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %edx	#, _53
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %edx	#, _51
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %edx	#, t_68
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%edx, %edx	# t_68, _69
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rdx	#, _70
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rdx, %rax	# _70, tmp212
	movq	8(%rsp), %rdi	# %sfp, ivtmp.308
	movq	%rax, (%r9,%rdi)	# tmp212, MEM[(fpr *)f1_41(D) + ivtmp.308_119 * 1]
# inputs/bootstrap/source/falcon-fft.c:690: 	for (u = 0; u < qn; u ++) {
	addq	$1, %r12	#, u
# inputs/bootstrap/source/falcon-fft.c:690: 	for (u = 0; u < qn; u ++) {
	addq	$16, %rbp	#, ivtmp.293
	addq	$16, (%rsp)	#, %sfp
	addq	$8, %rdi	#, ivtmp.308
	movq	%rdi, 8(%rsp)	# ivtmp.308, %sfp
	cmpq	%r12, 48(%rsp)	# u, %sfp
	jne	.L115	#,
.L113:
# inputs/bootstrap/source/falcon-fft.c:710: }
	addq	$72, %rsp	#,
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
.LFE53:
	.size	falcon_poly_split_fft, .-falcon_poly_split_fft
	.globl	falcon_poly_merge_fft
	.type	falcon_poly_merge_fft, @function
falcon_poly_merge_fft:
.LFB54:
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
	movq	%rsi, 56(%rsp)	# f0, %sfp
	movq	%rdx, %rbx	# tmp149, f1
	movq	%rdx, 64(%rsp)	# f1, %sfp
# inputs/bootstrap/source/falcon-fft.c:719: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp136
	salq	%cl, %rax	# tmp150, tmp136
	movq	%rax, %rcx	# tmp136, n
# inputs/bootstrap/source/falcon-fft.c:720: 	hn = n >> 1;
	shrq	%rax	# hn
	movq	%rax, %rdx	# hn, hn
# inputs/bootstrap/source/falcon-fft.c:726: 	f[0] = f0[0];
	movq	(%rsi), %rax	# *f0_37(D), *f0_37(D)
	movq	%rax, (%rdi)	# *f0_37(D), *f_38(D)
# inputs/bootstrap/source/falcon-fft.c:727: 	f[hn] = f1[0];
	movq	(%rbx), %rax	# *f1_40(D), *f1_40(D)
	movq	%rax, (%rdi,%rdx,8)	# *f1_40(D), *_3
# inputs/bootstrap/source/falcon-fft.c:729: 	for (u = 0; u < qn; u ++) {
	shrq	$2, %rcx	#, qn
	je	.L118	#,
	movq	%rdx, %rsi	# hn, _77
	salq	$4, %rsi	#, _77
	leaq	fpr_gm_tab(%rip), %rax	#, tmp140
	leaq	(%rsi,%rax), %rbp	#, ivtmp.319
	movq	%rdi, %r14	# f, ivtmp.320
	leaq	0(,%rcx,8), %rbx	#, ivtmp.329
# inputs/bootstrap/source/falcon-fft.c:729: 	for (u = 0; u < qn; u ++) {
	movl	$0, %r15d	#, u
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%rbp, %r13	# ivtmp.319, ivtmp.319
	movq	%rdx, 48(%rsp)	# hn, %sfp
	movq	%rcx, 72(%rsp)	# qn, %sfp
.L120:
# inputs/bootstrap/source/falcon-fft.c:733: 		a_re = f0[u];
	movq	56(%rsp), %rax	# %sfp, f0
	movq	(%rax,%r15,8), %rdx	# MEM[(const fpr *)f0_37(D) + u_74 * 8], a_re
	movq	%rdx, 8(%rsp)	# a_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:734: 		a_im = f0[u + qn];
	movq	(%rax,%rbx), %rax	# MEM[(const fpr *)f0_37(D) + ivtmp.329_82 * 1], a_im
	movq	%rax, 16(%rsp)	# a_im, %sfp
# inputs/bootstrap/source/falcon-fft.c:735: 		FPC_MUL(b_re, b_im, f1[u], f1[u + qn],
	movq	64(%rsp), %rcx	# %sfp, f1
	movq	(%rcx,%r15,8), %rdi	# MEM[(const fpr *)f1_40(D) + u_74 * 8], fpct_a_re
	movq	%rdi, 24(%rsp)	# fpct_a_re, %sfp
	movq	(%rcx,%rbx), %rcx	# MEM[(const fpr *)f1_40(D) + ivtmp.329_82 * 1], fpct_a_im
	movq	0(%r13), %rbp	# MEM[(long unsigned int *)_85], fpct_b_re
	movq	8(%r13), %rsi	# MEM[(long unsigned int *)_85 + 8B], fpct_b_im
	movq	%rsi, 40(%rsp)	# fpct_b_im, %sfp
	movq	%rcx, 32(%rsp)	# fpct_a_im, %sfp
	movq	%rcx, %rdi	# fpct_a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp151, _15
# inputs/bootstrap/source/falcon-fft.c:735: 		FPC_MUL(b_re, b_im, f1[u], f1[u + qn],
	movq	%rbp, %rsi	# fpct_b_re,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp152, _16
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r8	#, y_67
	xorq	%r12, %r8	# _15, y_67
	movq	%r8, %rsi	# y_67, y_67
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp153, _68
# inputs/bootstrap/source/falcon-fft.c:735: 		FPC_MUL(b_re, b_im, f1[u], f1[u + qn],
	movq	%rbp, %rsi	# fpct_b_re,
	movq	32(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp154, _17
# inputs/bootstrap/source/falcon-fft.c:735: 		FPC_MUL(b_re, b_im, f1[u], f1[u + qn],
	movq	40(%rsp), %rsi	# %sfp,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp155, _18
# inputs/bootstrap/source/falcon-fft.c:735: 		FPC_MUL(b_re, b_im, f1[u], f1[u + qn],
	movq	%rbp, %rsi	# _17,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp156, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:738: 		FPC_ADD(t_re, t_im, a_re, a_im, b_re, b_im);
	movq	%r12, %rsi	# _68,
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, 24(%rsp)	# tmp157, %sfp
# inputs/bootstrap/source/falcon-fft.c:738: 		FPC_ADD(t_re, t_im, a_re, a_im, b_re, b_im);
	movq	%rbp, %rsi	# fpct_d_im,
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:739: 		f[(u << 1) + 0] = t_re;
	movq	24(%rsp), %rcx	# %sfp, fpct_re
	movq	%rcx, (%r14)	# fpct_re, MEM[(fpr *)_86]
# inputs/bootstrap/source/falcon-fft.c:740: 		f[(u << 1) + 0 + hn] = t_im;
	movq	48(%rsp), %rcx	# %sfp, hn
	movq	%rax, (%r14,%rcx,8)	# tmp158, MEM[(fpr *)_86 + hn_34 * 8]
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_65
	xorq	%r12, %rsi	# _68, y_65
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp159, _66
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_63
	xorq	%rbp, %rsi	# fpct_d_im, y_63
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:742: 		f[(u << 1) + 1] = t_re;
	movq	%r12, 8(%r14)	# _66, MEM[(fpr *)_86 + 8B]
# inputs/bootstrap/source/falcon-fft.c:743: 		f[(u << 1) + 1 + hn] = t_im;
	movq	48(%rsp), %rcx	# %sfp, hn
	movq	%rax, 8(%r14,%rcx,8)	# tmp160, MEM[(fpr *)_86 + 8B + hn_34 * 8]
# inputs/bootstrap/source/falcon-fft.c:729: 	for (u = 0; u < qn; u ++) {
	addq	$1, %r15	#, u
# inputs/bootstrap/source/falcon-fft.c:729: 	for (u = 0; u < qn; u ++) {
	addq	$16, %r13	#, ivtmp.319
	addq	$16, %r14	#, ivtmp.320
	addq	$8, %rbx	#, ivtmp.329
	cmpq	%r15, 72(%rsp)	# u, %sfp
	jne	.L120	#,
.L118:
# inputs/bootstrap/source/falcon-fft.c:745: }
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
.LFE54:
	.size	falcon_poly_merge_fft, .-falcon_poly_merge_fft
	.globl	falcon_FFT3
	.type	falcon_FFT3, @function
falcon_FFT3:
.LFB55:
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
	subq	$152, %rsp	#,
	.cfi_def_cfa_offset 208
# inputs/bootstrap/source/falcon-fft.c:763: 	n = MKN(logn, full);
	leal	1(%rdx,%rdx), %eax	#, _3
	movq	%rax, 128(%rsp)	# _3, %sfp
	movl	%esi, %ecx	# logn, _4
	subl	%edx, %ecx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:763: 	n = MKN(logn, full);
	salq	%cl, %rax	# _4, n_90
# inputs/bootstrap/source/falcon-fft.c:771: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_90
	movq	%rax, 104(%rsp)	# hn, %sfp
	je	.L123	#,
	leaq	(%rdi,%rax,8), %rax	#, _308
	movq	%rax, 48(%rsp)	# _308, %sfp
# inputs/bootstrap/source/falcon-fft.c:771: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
# inputs/bootstrap/source/falcon-fft.c:776: 		a[u] = fpr_add(a0, fpr_mul(a1, fpr_W1R));
	movabsq	$4602678819172646912, %r13	#, tmp242
# inputs/bootstrap/source/falcon-fft.c:777: 		a[u + hn] = fpr_mul(a1, fpr_W1I);
	movabsq	$4605975682916830378, %r14	#, tmp243
	movl	%esi, 8(%rsp)	# logn, %sfp
	movq	%rax, %r12	# _308, _308
	movl	%edx, 16(%rsp)	# full, %sfp
	movq	%rdi, %r15	# a, a
.L125:
# inputs/bootstrap/source/falcon-fft.c:774: 		a0 = a[u];
	movq	(%r15,%rbx,8), %rax	# MEM[(fpr *)a_94(D) + u_262 * 8], a0
	movq	%rax, (%rsp)	# a0, %sfp
# inputs/bootstrap/source/falcon-fft.c:775: 		a1 = a[u + hn];
	movq	(%r12,%rbx,8), %rbp	# MEM[(fpr *)_308 + u_262 * 8], a1
# inputs/bootstrap/source/falcon-fft.c:776: 		a[u] = fpr_add(a0, fpr_mul(a1, fpr_W1R));
	movq	%r13, %rsi	# tmp242,
	movq	%rbp, %rdi	# a1,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp302, _10
# inputs/bootstrap/source/falcon-fft.c:776: 		a[u] = fpr_add(a0, fpr_mul(a1, fpr_W1R));
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:776: 		a[u] = fpr_add(a0, fpr_mul(a1, fpr_W1R));
	movq	%rax, (%r15,%rbx,8)	# tmp303, MEM[(fpr *)a_94(D) + u_262 * 8]
# inputs/bootstrap/source/falcon-fft.c:777: 		a[u + hn] = fpr_mul(a1, fpr_W1I);
	movq	%r14, %rsi	# tmp243,
	movq	%rbp, %rdi	# a1,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:777: 		a[u + hn] = fpr_mul(a1, fpr_W1I);
	movq	%rax, (%r12,%rbx,8)	# tmp304, MEM[(fpr *)_308 + u_262 * 8]
# inputs/bootstrap/source/falcon-fft.c:771: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:771: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, 104(%rsp)	# u, %sfp
	jne	.L125	#,
# inputs/bootstrap/source/falcon-fft.c:785: 	for (m = 2; t > tmin; m <<= 1) {
	movq	%r15, %r10	# a, a
	movl	8(%rsp), %r12d	# %sfp, logn
	movl	16(%rsp), %r15d	# %sfp, full
	movq	104(%rsp), %rax	# %sfp, hn
	cmpq	%rax, 128(%rsp)	# hn, %sfp
	jnb	.L126	#,
# inputs/bootstrap/source/falcon-fft.c:785: 	for (m = 2; t > tmin; m <<= 1) {
	movl	$2, %r13d	#, m
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rbp	#, tmp297
	movq	%rax, %r14	# ht, ht
	movl	%r12d, 136(%rsp)	# logn, %sfp
	movl	%r15d, 140(%rsp)	# full, %sfp
.L131:
	movq	%r14, %rdx	# ht, t
# inputs/bootstrap/source/falcon-fft.c:788: 		ht = t >> 1;
	shrq	%r14	# ht
# inputs/bootstrap/source/falcon-fft.c:790: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	movq	%r13, %r15	# m, hm
	shrq	%r15	# hm
	je	.L127	#,
	movq	%r13, %r12	# m, _301
	salq	$4, %r12	#, _301
	leaq	fpr_gm3_square(%rip), %rax	#, tmp409
	addq	%rax, %r12	# tmp409, ivtmp.363
	leaq	(%r10,%r14,8), %rax	#, _289
	movq	%rax, 32(%rsp)	# _289, %sfp
	movq	104(%rsp), %rax	# %sfp, hn
	addq	%r14, %rax	# ht, _292
	leaq	(%r10,%rax,8), %rax	#, _294
	movq	%rax, 40(%rsp)	# _294, %sfp
	movq	%r14, %r8	# ht, ivtmp.364
# inputs/bootstrap/source/falcon-fft.c:790: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	movl	$0, %ecx	#, u1
	movq	%r14, 112(%rsp)	# ht, %sfp
	movq	%r15, 96(%rsp)	# hm, %sfp
	movq	%r13, 120(%rsp)	# m, %sfp
	movq	%rdx, %r15	# t, t
	movq	%rcx, %rdx	# u1, u1
	movq	%r12, %rsi	# ivtmp.363, ivtmp.363
	movq	%r10, 24(%rsp)	# a, %sfp
.L130:
# inputs/bootstrap/source/falcon-fft.c:794: 			sr = fpr_gm3_square[((m + u1) << 1) + 0];
	movq	(%rsi), %r9	# MEM[(long unsigned int *)_305], sr
# inputs/bootstrap/source/falcon-fft.c:795: 			si = fpr_gm3_square[((m + u1) << 1) + 1];
	movq	8(%rsi), %r10	# MEM[(long unsigned int *)_305 + 8B], si
# inputs/bootstrap/source/falcon-fft.c:797: 			for (v = v1; v < v2; v ++) {
	cmpq	%r8, %rcx	# ivtmp.364, v1
	jnb	.L128	#,
# inputs/bootstrap/source/falcon-fft.c:797: 			for (v = v1; v < v2; v ++) {
	movq	%rcx, %r14	# v1, v
	movq	%r9, 8(%rsp)	# sr, %sfp
	movq	%r10, 16(%rsp)	# si, %sfp
	movq	%rdx, 64(%rsp)	# u1, %sfp
	movq	%rcx, 72(%rsp)	# v1, %sfp
	movq	%r15, 80(%rsp)	# t, %sfp
	movq	%rsi, 88(%rsp)	# ivtmp.363, %sfp
	movq	%r8, 56(%rsp)	# ivtmp.364, %sfp
.L129:
# inputs/bootstrap/source/falcon-fft.c:800: 				a0r = a[v];
	movq	24(%rsp), %rax	# %sfp, a
	movq	(%rax,%r14,8), %r13	# MEM[(fpr *)a_94(D) + v_268 * 8], a0r
# inputs/bootstrap/source/falcon-fft.c:801: 				a0i = a[v + hn];
	movq	48(%rsp), %rcx	# %sfp, _308
	movq	(%rcx,%r14,8), %rbx	# MEM[(fpr *)_308 + v_268 * 8], a0i
	movq	%rbx, (%rsp)	# a0i, %sfp
# inputs/bootstrap/source/falcon-fft.c:802: 				a1r = a[v + ht];
	movq	32(%rsp), %rdi	# %sfp, _289
	movq	(%rdi,%r14,8), %rbx	# MEM[(fpr *)_289 + v_268 * 8], a1r
# inputs/bootstrap/source/falcon-fft.c:803: 				a1i = a[v + ht + hn];
	movq	40(%rsp), %rsi	# %sfp, _294
	movq	(%rsi,%r14,8), %r15	# MEM[(fpr *)_294 + v_268 * 8], a1i
# inputs/bootstrap/source/falcon-fft.c:804: 				FPC_MUL(a1r, a1i, a1r, a1i, sr, si);
	movq	16(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# a1i,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp305, _27
# inputs/bootstrap/source/falcon-fft.c:804: 				FPC_MUL(a1r, a1i, a1r, a1i, sr, si);
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# a1r,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp306, _28
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%rbp, %r12	# tmp297, _27
	movq	%r12, %rsi	# _27, y_211
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp307, _212
# inputs/bootstrap/source/falcon-fft.c:804: 				FPC_MUL(a1r, a1i, a1r, a1i, sr, si);
	movq	8(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# a1i,
	call	fpr_mul@PLT	#
	movq	%rax, %r15	# tmp308, _29
# inputs/bootstrap/source/falcon-fft.c:804: 				FPC_MUL(a1r, a1i, a1r, a1i, sr, si);
	movq	16(%rsp), %rsi	# %sfp,
	movq	%rbx, %rdi	# a1r,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp309, _30
# inputs/bootstrap/source/falcon-fft.c:804: 				FPC_MUL(a1r, a1i, a1r, a1i, sr, si);
	movq	%r15, %rsi	# _29,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp310, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:805: 				FPC_ADD(a[v], a[v + hn],
	movq	%r12, %rsi	# _212,
	movq	%r13, %rdi	# a0r,
	call	fpr_add@PLT	#
	movq	%rax, %r15	# tmp311, fpct_re
# inputs/bootstrap/source/falcon-fft.c:805: 				FPC_ADD(a[v], a[v + hn],
	movq	%rbx, %rsi	# fpct_d_im,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:805: 				FPC_ADD(a[v], a[v + hn],
	movq	24(%rsp), %rdx	# %sfp, a
	movq	%r15, (%rdx,%r14,8)	# fpct_re, MEM[(fpr *)a_94(D) + v_268 * 8]
	movq	48(%rsp), %rcx	# %sfp, _308
	movq	%rax, (%rcx,%r14,8)	# tmp312, MEM[(fpr *)_308 + v_268 * 8]
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%rbp, %r12	# tmp297, _212
	movq	%r12, %rsi	# _212, y_209
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	%r13, %rdi	# a0r,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp313, _210
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%rbp, %rbx	# tmp297, fpct_d_im
	movq	%rbx, %rsi	# fpct_d_im, y_122
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:807: 				FPC_SUB(a[v + ht], a[v + ht + hn],
	movq	32(%rsp), %rdi	# %sfp, _289
	movq	%r12, (%rdi,%r14,8)	# _210, MEM[(fpr *)_289 + v_268 * 8]
	movq	40(%rsp), %rsi	# %sfp, _294
	movq	%rax, (%rsi,%r14,8)	# tmp314, MEM[(fpr *)_294 + v_268 * 8]
# inputs/bootstrap/source/falcon-fft.c:797: 			for (v = v1; v < v2; v ++) {
	addq	$1, %r14	#, v
# inputs/bootstrap/source/falcon-fft.c:797: 			for (v = v1; v < v2; v ++) {
	movq	56(%rsp), %rax	# %sfp, ivtmp.364
	cmpq	%rax, %r14	# ivtmp.364, v
	jne	.L129	#,
	movq	64(%rsp), %rdx	# %sfp, u1
	movq	72(%rsp), %rcx	# %sfp, v1
	movq	80(%rsp), %r15	# %sfp, t
	movq	88(%rsp), %rsi	# %sfp, ivtmp.363
	movq	%rax, %r8	# ivtmp.364, ivtmp.364
.L128:
# inputs/bootstrap/source/falcon-fft.c:790: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	addq	$1, %rdx	#, u1
# inputs/bootstrap/source/falcon-fft.c:790: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	addq	%r15, %rcx	# t, v1
# inputs/bootstrap/source/falcon-fft.c:790: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	addq	$16, %rsi	#, ivtmp.363
	addq	%r15, %r8	# t, ivtmp.364
	cmpq	%rdx, 96(%rsp)	# u1, %sfp
	jne	.L130	#,
	movq	112(%rsp), %r14	# %sfp, ht
	movq	120(%rsp), %r13	# %sfp, m
	movq	24(%rsp), %r10	# %sfp, a
.L127:
# inputs/bootstrap/source/falcon-fft.c:785: 	for (m = 2; t > tmin; m <<= 1) {
	addq	%r13, %r13	# m
# inputs/bootstrap/source/falcon-fft.c:785: 	for (m = 2; t > tmin; m <<= 1) {
	cmpq	%r14, 128(%rsp)	# ht, %sfp
	jb	.L131	#,
	movl	136(%rsp), %r12d	# %sfp, logn
	movl	140(%rsp), %r15d	# %sfp, full
.L126:
# inputs/bootstrap/source/falcon-fft.c:817: 	if (full) {
	testl	%r15d, %r15d	# full
	je	.L123	#,
	movq	%r10, %r14	# a, ivtmp.345
	movq	104(%rsp), %rax	# %sfp, hn
	leaq	(%r10,%rax,8), %r13	#, ivtmp.346
	movl	$8, %eax	#, tmp293
	movl	%r12d, %ecx	# logn, tmp448
	salq	%cl, %rax	# tmp448, _82
	leaq	fpr_gm3_cubic(%rip), %rdx	#, tmp294
	addq	%rdx, %rax	# tmp294, ivtmp.347
	movq	%rax, 8(%rsp)	# ivtmp.347, %sfp
# inputs/bootstrap/source/falcon-fft.c:820: 		for (u = 0, v = (size_t)1 << logn; u < hn; u += 3, v += 2) {
	movq	$0, 16(%rsp)	#, %sfp
.L132:
# inputs/bootstrap/source/falcon-fft.c:826: 			fAr = a[u];
	movq	(%r14), %r15	# MEM[(fpr *)_261], fAr
	movq	%r15, 24(%rsp)	# fAr, %sfp
# inputs/bootstrap/source/falcon-fft.c:827: 			fAi = a[u + hn];
	movq	0(%r13), %r12	# MEM[(fpr *)_253], fAi
	movq	%r12, 32(%rsp)	# fAi, %sfp
# inputs/bootstrap/source/falcon-fft.c:828: 			fBr = a[u + 1];
	movq	8(%r14), %rbp	# MEM[(fpr *)_261 + 8B], fBr
# inputs/bootstrap/source/falcon-fft.c:829: 			fBi = a[u + 1 + hn];
	movq	8(%r13), %r15	# MEM[(fpr *)_253 + 8B], fBi
# inputs/bootstrap/source/falcon-fft.c:830: 			fCr = a[u + 2];
	movq	16(%r14), %rax	# MEM[(fpr *)_261 + 16B], fCr
	movq	%rax, 40(%rsp)	# fCr, %sfp
# inputs/bootstrap/source/falcon-fft.c:831: 			fCi = a[u + 2 + hn];
	movq	16(%r13), %rdx	# MEM[(fpr *)_253 + 16B], fCi
	movq	%rdx, 56(%rsp)	# fCi, %sfp
# inputs/bootstrap/source/falcon-fft.c:833: 			xr = fpr_gm3_cubic[v + 0];
	movq	8(%rsp), %rax	# %sfp, ivtmp.347
	movq	(%rax), %r12	# MEM[(long unsigned int *)_282], xr
# inputs/bootstrap/source/falcon-fft.c:834: 			xi = fpr_gm3_cubic[v + 1];
	movq	8(%rax), %rbx	# MEM[(long unsigned int *)_282 + 8B], xi
# inputs/bootstrap/source/falcon-fft.c:835: 			FPC_MUL(fB0r, fB0i, fBr, fBi, xr, xi);
	movq	%rbx, %rsi	# xi,
	movq	%r15, %rdi	# fBi,
	call	fpr_mul@PLT	#
	movq	%rax, (%rsp)	# tmp315, %sfp
# inputs/bootstrap/source/falcon-fft.c:835: 			FPC_MUL(fB0r, fB0i, fBr, fBi, xr, xi);
	movq	%r12, %rsi	# xr,
	movq	%rbp, %rdi	# fBr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp316, _50
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	(%rsp), %rsi	# %sfp, _49
	movabsq	$-9223372036854775808, %rcx	#, tmp435
	xorq	%rcx, %rsi	# tmp435, _49
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, (%rsp)	# tmp317, %sfp
# inputs/bootstrap/source/falcon-fft.c:835: 			FPC_MUL(fB0r, fB0i, fBr, fBi, xr, xi);
	movq	%r12, %rsi	# xr,
	movq	%r15, %rdi	# fBi,
	call	fpr_mul@PLT	#
	movq	%rax, %r15	# tmp318, _51
# inputs/bootstrap/source/falcon-fft.c:835: 			FPC_MUL(fB0r, fB0i, fBr, fBi, xr, xi);
	movq	%rbx, %rsi	# xi,
	movq	%rbp, %rdi	# fBr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp319, _52
# inputs/bootstrap/source/falcon-fft.c:835: 			FPC_MUL(fB0r, fB0i, fBr, fBi, xr, xi);
	movq	%r15, %rsi	# _51,
	call	fpr_add@PLT	#
	movq	%rax, %r15	# tmp320, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:836: 			FPC_MUL(fB1r, fB1i, fB0r, fB0i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%rax, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp321, _53
# inputs/bootstrap/source/falcon-fft.c:836: 			FPC_MUL(fB1r, fB1i, fB0r, fB0i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp322, _54
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_233
	xorq	%rbp, %rsi	# _53, y_233
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 88(%rsp)	# tmp323, %sfp
# inputs/bootstrap/source/falcon-fft.c:836: 			FPC_MUL(fB1r, fB1i, fB0r, fB0i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r15, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp324, _55
# inputs/bootstrap/source/falcon-fft.c:836: 			FPC_MUL(fB1r, fB1i, fB0r, fB0i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp325, _56
# inputs/bootstrap/source/falcon-fft.c:836: 			FPC_MUL(fB1r, fB1i, fB0r, fB0i, fpr_W2R, fpr_W2I);
	movq	%rbp, %rsi	# _55,
	call	fpr_add@PLT	#
	movq	%rax, 64(%rsp)	# tmp326, %sfp
# inputs/bootstrap/source/falcon-fft.c:837: 			FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%r15, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp327, _57
# inputs/bootstrap/source/falcon-fft.c:837: 			FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp328, _58
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_231
	xorq	%rbp, %rsi	# _57, y_231
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 80(%rsp)	# tmp329, %sfp
# inputs/bootstrap/source/falcon-fft.c:837: 			FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r15, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp330, _59
# inputs/bootstrap/source/falcon-fft.c:837: 			FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp331, _60
# inputs/bootstrap/source/falcon-fft.c:837: 			FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movq	%rbp, %rsi	# _59,
	call	fpr_add@PLT	#
	movq	%rax, 72(%rsp)	# tmp332, %sfp
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rbx, %rsi	# xi,
	movq	%rbx, %rdi	# xi,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp333, _230
	movq	%r12, %rsi	# xr,
	movq	%r12, %rdi	# xr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp334, _229
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_227
	xorq	%rbp, %rsi	# _230, y_227
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 48(%rsp)	# tmp335, %sfp
# inputs/bootstrap/source/falcon-fft.c:838: 			FPC_SQR(xr, xi, xr, xi);
	movq	%rbx, %rsi	# xi,
	movq	%r12, %rdi	# xr,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	movq	%rax, %rbx	# _61, _219
	shrq	$52, %rbx	#, _219
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	andl	$2047, %ebx	#, _221
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addl	$2047, %ebx	#, _222
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrl	$11, %ebx	#, _223
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	salq	$52, %rbx	#, _225
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addq	%rax, %rbx	# _61, x
# inputs/bootstrap/source/falcon-fft.c:839: 			FPC_MUL(fC0r, fC0i, fCr, fCi, xr, xi);
	movq	%rbx, %rsi	# x,
	movq	56(%rsp), %r12	# %sfp, fCi
	movq	%r12, %rdi	# fCi,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp337, _62
# inputs/bootstrap/source/falcon-fft.c:839: 			FPC_MUL(fC0r, fC0i, fCr, fCi, xr, xi);
	movq	48(%rsp), %rsi	# %sfp,
	movq	40(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp338, _63
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdx	#, y_217
	xorq	%rbp, %rdx	# _62, y_217
	movq	%rdx, %rsi	# y_217, y_217
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp339, _218
# inputs/bootstrap/source/falcon-fft.c:839: 			FPC_MUL(fC0r, fC0i, fCr, fCi, xr, xi);
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# fCi,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp340, _64
# inputs/bootstrap/source/falcon-fft.c:839: 			FPC_MUL(fC0r, fC0i, fCr, fCi, xr, xi);
	movq	%rbx, %rsi	# x,
	movq	40(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp341, _65
# inputs/bootstrap/source/falcon-fft.c:839: 			FPC_MUL(fC0r, fC0i, fCr, fCi, xr, xi);
	movq	%r12, %rsi	# _64,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp342, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:840: 			FPC_MUL(fC1r, fC1i, fC0r, fC0i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%rax, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp343, _66
# inputs/bootstrap/source/falcon-fft.c:840: 			FPC_MUL(fC1r, fC1i, fC0r, fC0i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%rbp, %rdi	# _218,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp344, _67
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_215
	xorq	%r12, %rsi	# _66, y_215
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 56(%rsp)	# tmp345, %sfp
# inputs/bootstrap/source/falcon-fft.c:840: 			FPC_MUL(fC1r, fC1i, fC0r, fC0i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%rbx, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp346, _68
# inputs/bootstrap/source/falcon-fft.c:840: 			FPC_MUL(fC1r, fC1i, fC0r, fC0i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%rbp, %rdi	# _218,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp347, _69
# inputs/bootstrap/source/falcon-fft.c:840: 			FPC_MUL(fC1r, fC1i, fC0r, fC0i, fpr_W2R, fpr_W2I);
	movq	%r12, %rsi	# _68,
	call	fpr_add@PLT	#
	movq	%rax, 40(%rsp)	# tmp348, %sfp
# inputs/bootstrap/source/falcon-fft.c:841: 			FPC_MUL(fC2r, fC2i, fC0r, fC0i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%rbx, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp349, _70
# inputs/bootstrap/source/falcon-fft.c:841: 			FPC_MUL(fC2r, fC2i, fC0r, fC0i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%rbp, %rdi	# _218,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp350, _71
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdx	#, y_213
	xorq	%r12, %rdx	# _70, y_213
	movq	%rdx, %rsi	# y_213, y_213
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 48(%rsp)	# tmp351, %sfp
# inputs/bootstrap/source/falcon-fft.c:841: 			FPC_MUL(fC2r, fC2i, fC0r, fC0i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%rbx, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp352, _72
# inputs/bootstrap/source/falcon-fft.c:841: 			FPC_MUL(fC2r, fC2i, fC0r, fC0i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%rbp, %rdi	# _218,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp353, _73
# inputs/bootstrap/source/falcon-fft.c:841: 			FPC_MUL(fC2r, fC2i, fC0r, fC0i, fpr_W4R, fpr_W4I);
	movq	%r12, %rsi	# _72,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp354, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:842: 			FPC_ADD(fB0r, fB0i, fB0r, fB0i, fC0r, fC0i);
	movq	%rbp, %rsi	# _218,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp355, fpct_re
# inputs/bootstrap/source/falcon-fft.c:842: 			FPC_ADD(fB0r, fB0i, fB0r, fB0i, fC0r, fC0i);
	movq	%rbx, %rsi	# fpct_d_im,
	movq	%r15, %rdi	# fpct_d_im,
	call	fpr_add@PLT	#
	movq	%rax, %r15	# tmp356, fpct_im
# inputs/bootstrap/source/falcon-fft.c:843: 			FPC_ADD(fB1r, fB1i, fB1r, fB1i, fC2r, fC2i);
	movq	48(%rsp), %rsi	# %sfp,
	movq	88(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, (%rsp)	# tmp357, %sfp
# inputs/bootstrap/source/falcon-fft.c:843: 			FPC_ADD(fB1r, fB1i, fB1r, fB1i, fC2r, fC2i);
	movq	%r12, %rsi	# fpct_d_im,
	movq	64(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp358, fpct_im
# inputs/bootstrap/source/falcon-fft.c:844: 			FPC_ADD(fB2r, fB2i, fB2r, fB2i, fC1r, fC1i);
	movq	56(%rsp), %rsi	# %sfp,
	movq	80(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, 48(%rsp)	# tmp359, %sfp
# inputs/bootstrap/source/falcon-fft.c:844: 			FPC_ADD(fB2r, fB2i, fB2r, fB2i, fC1r, fC1i);
	movq	40(%rsp), %rsi	# %sfp,
	movq	72(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp360, fpct_im
# inputs/bootstrap/source/falcon-fft.c:845: 			FPC_ADD(a[u + 0], a[u + 0 + hn], fAr, fAi, fB0r, fB0i);
	movq	%rbp, %rsi	# fpct_re,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp361, fpct_re
# inputs/bootstrap/source/falcon-fft.c:845: 			FPC_ADD(a[u + 0], a[u + 0 + hn], fAr, fAi, fB0r, fB0i);
	movq	%r15, %rsi	# fpct_im,
	movq	32(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:845: 			FPC_ADD(a[u + 0], a[u + 0 + hn], fAr, fAi, fB0r, fB0i);
	movq	%rbp, (%r14)	# fpct_re, MEM[(fpr *)_261]
	movq	%rax, 0(%r13)	# tmp362, MEM[(fpr *)_253]
# inputs/bootstrap/source/falcon-fft.c:846: 			FPC_ADD(a[u + 1], a[u + 1 + hn], fAr, fAi, fB1r, fB1i);
	movq	(%rsp), %rsi	# %sfp,
	movq	24(%rsp), %r15	# %sfp, fAr
	movq	%r15, %rdi	# fAr,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp363, fpct_re
# inputs/bootstrap/source/falcon-fft.c:846: 			FPC_ADD(a[u + 1], a[u + 1 + hn], fAr, fAi, fB1r, fB1i);
	movq	%r12, %rsi	# fpct_im,
	movq	32(%rsp), %r12	# %sfp, fAi
	movq	%r12, %rdi	# fAi,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:846: 			FPC_ADD(a[u + 1], a[u + 1 + hn], fAr, fAi, fB1r, fB1i);
	movq	%rbp, 8(%r14)	# fpct_re, MEM[(fpr *)_261 + 8B]
	movq	%rax, 8(%r13)	# tmp364, MEM[(fpr *)_253 + 8B]
# inputs/bootstrap/source/falcon-fft.c:847: 			FPC_ADD(a[u + 2], a[u + 2 + hn], fAr, fAi, fB2r, fB2i);
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# fAr,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp365, fpct_re
# inputs/bootstrap/source/falcon-fft.c:847: 			FPC_ADD(a[u + 2], a[u + 2 + hn], fAr, fAi, fB2r, fB2i);
	movq	%rbx, %rsi	# fpct_im,
	movq	%r12, %rdi	# fAi,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:847: 			FPC_ADD(a[u + 2], a[u + 2 + hn], fAr, fAi, fB2r, fB2i);
	movq	%rbp, 16(%r14)	# fpct_re, MEM[(fpr *)_261 + 16B]
	movq	%rax, 16(%r13)	# tmp366, MEM[(fpr *)_253 + 16B]
# inputs/bootstrap/source/falcon-fft.c:820: 		for (u = 0, v = (size_t)1 << logn; u < hn; u += 3, v += 2) {
	addq	$3, 16(%rsp)	#, %sfp
	movq	16(%rsp), %rdx	# %sfp, u
# inputs/bootstrap/source/falcon-fft.c:820: 		for (u = 0, v = (size_t)1 << logn; u < hn; u += 3, v += 2) {
	addq	$24, %r14	#, ivtmp.345
	addq	$24, %r13	#, ivtmp.346
	addq	$16, 8(%rsp)	#, %sfp
	movq	104(%rsp), %rax	# %sfp, hn
	cmpq	%rax, %rdx	# hn, u
	jb	.L132	#,
.L123:
# inputs/bootstrap/source/falcon-fft.c:850: }
	addq	$152, %rsp	#,
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
.LFE55:
	.size	falcon_FFT3, .-falcon_FFT3
	.globl	falcon_iFFT3
	.type	falcon_iFFT3, @function
falcon_iFFT3:
.LFB56:
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
	subq	$168, %rsp	#,
	.cfi_def_cfa_offset 224
	movq	%rdi, 16(%rsp)	# a, %sfp
# inputs/bootstrap/source/falcon-fft.c:859: 	n = MKN(logn, full);
	movl	%esi, %ebp	# logn, _4
	subl	%edx, %ebp	# full, _4
	leal	1(%rdx,%rdx), %eax	#, _3
# inputs/bootstrap/source/falcon-fft.c:859: 	n = MKN(logn, full);
	movl	%ebp, %ecx	# _4, tmp458
	salq	%cl, %rax	# tmp458, _3
	movq	%rax, 112(%rsp)	# n, %sfp
# inputs/bootstrap/source/falcon-fft.c:860: 	hn = n >> 1;
	shrq	%rax	# hn
	movq	%rax, %r9	# hn, hn
# inputs/bootstrap/source/falcon-fft.c:865: 	if (full) {
	testl	%edx, %edx	# full
	je	.L141	#,
# inputs/bootstrap/source/falcon-fft.c:868: 		for (u = 0, v = (size_t)1 << logn; u < hn; u += 3, v += 2) {
	testq	%rax, %rax	# hn
	je	.L142	#,
	movq	%rdi, %r15	# a, ivtmp.419
	leaq	(%rdi,%rax,8), %r12	#, ivtmp.420
	movl	$8, %edi	#, tmp271
	movl	%esi, %ecx	# logn, tmp462
	salq	%cl, %rdi	# tmp462, _335
	leaq	fpr_gm3_cubic(%rip), %rcx	#, tmp272
	leaq	(%rdi,%rcx), %rax	#, ivtmp.421
	movq	%rax, 32(%rsp)	# ivtmp.421, %sfp
# inputs/bootstrap/source/falcon-fft.c:868: 		for (u = 0, v = (size_t)1 << logn; u < hn; u += 3, v += 2) {
	movq	$0, 64(%rsp)	#, %sfp
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rbx	#, tmp273
# inputs/bootstrap/source/falcon-fft.c:882: 			FPC_MUL(f12r, f12i, f1r, f1i, fpr_W2R, fpr_W2I);
	movl	%ebp, 152(%rsp)	# _4, %sfp
	movq	%r9, 144(%rsp)	# hn, %sfp
	movl	%edx, 156(%rsp)	# full, %sfp
.L143:
# inputs/bootstrap/source/falcon-fft.c:872: 			f0r = a[u];
	movq	(%r15), %rax	# MEM[(fpr *)_337], f0r
	movq	%rax, 40(%rsp)	# f0r, %sfp
# inputs/bootstrap/source/falcon-fft.c:873: 			f0i = a[u + hn];
	movq	(%r12), %rcx	# MEM[(fpr *)_343], f0i
	movq	%rcx, 48(%rsp)	# f0i, %sfp
# inputs/bootstrap/source/falcon-fft.c:874: 			f1r = a[u + 1];
	movq	8(%r15), %rbp	# MEM[(fpr *)_337 + 8B], f1r
# inputs/bootstrap/source/falcon-fft.c:875: 			f1i = a[u + 1 + hn];
	movq	8(%r12), %rax	# MEM[(fpr *)_343 + 8B], f1i
# inputs/bootstrap/source/falcon-fft.c:876: 			f2r = a[u + 2];
	movq	16(%r15), %r13	# MEM[(fpr *)_337 + 16B], f2r
# inputs/bootstrap/source/falcon-fft.c:877: 			f2i = a[u + 2 + hn];
	movq	16(%r12), %rcx	# MEM[(fpr *)_343 + 16B], f2i
	movq	%rcx, 24(%rsp)	# f2i, %sfp
# inputs/bootstrap/source/falcon-fft.c:879: 			xr = fpr_gm3_cubic[v + 0];
	movq	32(%rsp), %rdi	# %sfp, ivtmp.421
	movq	(%rdi), %rdx	# MEM[(long unsigned int *)_349], xr
	movq	%rdx, 72(%rsp)	# xr, %sfp
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movq	%rbx, %r14	# tmp273, x
	xorq	8(%rdi), %r14	# MEM[(long unsigned int *)_349 + 8B], x
	movq	%r14, 56(%rsp)	# x, %sfp
# inputs/bootstrap/source/falcon-fft.c:881: 			FPC_MUL(f11r, f11i, f1r, f1i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%rax, 8(%rsp)	# f1i, %sfp
	movq	%rax, %rdi	# f1i,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp356, _24
# inputs/bootstrap/source/falcon-fft.c:881: 			FPC_MUL(f11r, f11i, f1r, f1i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%rbp, %rdi	# f1r,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp357, _25
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r14, %rsi	# _24, _24
	xorq	%rbx, %rsi	# tmp273, _24
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 136(%rsp)	# tmp358, %sfp
# inputs/bootstrap/source/falcon-fft.c:881: 			FPC_MUL(f11r, f11i, f1r, f1i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp359, _26
# inputs/bootstrap/source/falcon-fft.c:881: 			FPC_MUL(f11r, f11i, f1r, f1i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%rbp, %rdi	# f1r,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp360, _27
# inputs/bootstrap/source/falcon-fft.c:881: 			FPC_MUL(f11r, f11i, f1r, f1i, fpr_W4R, fpr_W4I);
	movq	%r14, %rsi	# _26,
	call	fpr_add@PLT	#
	movq	%rax, 80(%rsp)	# tmp361, %sfp
# inputs/bootstrap/source/falcon-fft.c:882: 			FPC_MUL(f12r, f12i, f1r, f1i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp362, _28
# inputs/bootstrap/source/falcon-fft.c:882: 			FPC_MUL(f12r, f12i, f1r, f1i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%rbp, %rdi	# f1r,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp363, _29
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r14, %rsi	# _28, _28
	xorq	%rbx, %rsi	# tmp273, _28
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 128(%rsp)	# tmp364, %sfp
# inputs/bootstrap/source/falcon-fft.c:882: 			FPC_MUL(f12r, f12i, f1r, f1i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp365, _30
# inputs/bootstrap/source/falcon-fft.c:882: 			FPC_MUL(f12r, f12i, f1r, f1i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%rbp, %rdi	# f1r,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp366, _31
# inputs/bootstrap/source/falcon-fft.c:882: 			FPC_MUL(f12r, f12i, f1r, f1i, fpr_W2R, fpr_W2I);
	movq	%r14, %rsi	# _30,
	call	fpr_add@PLT	#
	movq	%rax, 88(%rsp)	# tmp367, %sfp
# inputs/bootstrap/source/falcon-fft.c:883: 			FPC_MUL(f21r, f21i, f2r, f2i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp368, _32
# inputs/bootstrap/source/falcon-fft.c:883: 			FPC_MUL(f21r, f21i, f2r, f2i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r13, %rdi	# f2r,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp369, _33
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r14, %rsi	# _32, _32
	xorq	%rbx, %rsi	# tmp273, _32
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 120(%rsp)	# tmp370, %sfp
# inputs/bootstrap/source/falcon-fft.c:883: 			FPC_MUL(f21r, f21i, f2r, f2i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp371, _34
# inputs/bootstrap/source/falcon-fft.c:883: 			FPC_MUL(f21r, f21i, f2r, f2i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%r13, %rdi	# f2r,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp372, _35
# inputs/bootstrap/source/falcon-fft.c:883: 			FPC_MUL(f21r, f21i, f2r, f2i, fpr_W4R, fpr_W4I);
	movq	%r14, %rsi	# _34,
	call	fpr_add@PLT	#
	movq	%rax, 96(%rsp)	# tmp373, %sfp
# inputs/bootstrap/source/falcon-fft.c:884: 			FPC_MUL(f22r, f22i, f2r, f2i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp374, _36
# inputs/bootstrap/source/falcon-fft.c:884: 			FPC_MUL(f22r, f22i, f2r, f2i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r13, %rdi	# f2r,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp375, _37
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r14, %r9	# _36, _36
	xorq	%rbx, %r9	# tmp273, _36
	movq	%r9, %rsi	# _36, y_236
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 104(%rsp)	# tmp376, %sfp
# inputs/bootstrap/source/falcon-fft.c:884: 			FPC_MUL(f22r, f22i, f2r, f2i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp377, _38
# inputs/bootstrap/source/falcon-fft.c:884: 			FPC_MUL(f22r, f22i, f2r, f2i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%r13, %rdi	# f2r,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp378, _39
# inputs/bootstrap/source/falcon-fft.c:884: 			FPC_MUL(f22r, f22i, f2r, f2i, fpr_W2R, fpr_W2I);
	movq	%r14, %rsi	# _38,
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp379, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:886: 			FPC_ADD(f1r, f1i, f1r, f1i, f2r, f2i);
	movq	%r13, %rsi	# f2r,
	movq	%rbp, %rdi	# f1r,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp380, fpct_re
# inputs/bootstrap/source/falcon-fft.c:886: 			FPC_ADD(f1r, f1i, f1r, f1i, f2r, f2i);
	movq	24(%rsp), %rsi	# %sfp,
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp381, fpct_im
# inputs/bootstrap/source/falcon-fft.c:887: 			FPC_ADD(a[u], a[u + hn], f0r, f0i, f1r, f1i);
	movq	%rbp, %rsi	# fpct_re,
	movq	40(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp382, fpct_re
# inputs/bootstrap/source/falcon-fft.c:887: 			FPC_ADD(a[u], a[u + hn], f0r, f0i, f1r, f1i);
	movq	%r13, %rsi	# fpct_im,
	movq	48(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:887: 			FPC_ADD(a[u], a[u + hn], f0r, f0i, f1r, f1i);
	movq	%rbp, (%r15)	# fpct_re, MEM[(fpr *)_337]
	movq	%rax, (%r12)	# tmp383, MEM[(fpr *)_343]
# inputs/bootstrap/source/falcon-fft.c:889: 			FPC_ADD(f11r, f11i, f11r, f11i, f22r, f22i);
	movq	104(%rsp), %rsi	# %sfp,
	movq	136(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp384, fpct_re
# inputs/bootstrap/source/falcon-fft.c:889: 			FPC_ADD(f11r, f11i, f11r, f11i, f22r, f22i);
	movq	%r14, %rsi	# fpct_d_im,
	movq	80(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp385, fpct_im
# inputs/bootstrap/source/falcon-fft.c:890: 			FPC_ADD(f11r, f11i, f11r, f11i, f0r, f0i);
	movq	40(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# fpct_re,
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp386, fpct_re
# inputs/bootstrap/source/falcon-fft.c:890: 			FPC_ADD(f11r, f11i, f11r, f11i, f0r, f0i);
	movq	48(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# fpct_im,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp387, fpct_im
# inputs/bootstrap/source/falcon-fft.c:891: 			FPC_MUL(a[u + 1], a[u + 1 + hn], xr, xi, f11r, f11i);
	movq	%rax, %rsi	# fpct_im,
	movq	56(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp388, _40
# inputs/bootstrap/source/falcon-fft.c:891: 			FPC_MUL(a[u + 1], a[u + 1 + hn], xr, xi, f11r, f11i);
	movq	%r14, %rsi	# fpct_re,
	movq	72(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp389, _41
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%rbx, %rbp	# tmp273, _40
	movq	%rbp, %rsi	# _40, y_234
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp390, _235
# inputs/bootstrap/source/falcon-fft.c:891: 			FPC_MUL(a[u + 1], a[u + 1 + hn], xr, xi, f11r, f11i);
	movq	%r14, %rsi	# fpct_re,
	movq	56(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp391, _42
# inputs/bootstrap/source/falcon-fft.c:891: 			FPC_MUL(a[u + 1], a[u + 1 + hn], xr, xi, f11r, f11i);
	movq	%r13, %rsi	# fpct_im,
	movq	72(%rsp), %r13	# %sfp, xr
	movq	%r13, %rdi	# xr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp392, _43
# inputs/bootstrap/source/falcon-fft.c:891: 			FPC_MUL(a[u + 1], a[u + 1 + hn], xr, xi, f11r, f11i);
	movq	%r14, %rsi	# _42,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:891: 			FPC_MUL(a[u + 1], a[u + 1 + hn], xr, xi, f11r, f11i);
	movq	%rbp, 8(%r15)	# _235, MEM[(fpr *)_337 + 8B]
	movq	%rax, 8(%r12)	# tmp393, MEM[(fpr *)_343 + 8B]
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	56(%rsp), %r14	# %sfp, x
	movq	%r14, %rsi	# x,
	movq	%r14, %rdi	# x,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp394, _233
	movq	%r13, %rsi	# xr,
	movq	%r13, %rdi	# xr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp395, _232
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%rbx, %rbp	# tmp273, _233
	movq	%rbp, %rsi	# _233, y_230
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 24(%rsp)	# tmp396, %sfp
# inputs/bootstrap/source/falcon-fft.c:893: 			FPC_SQR(xr, xi, xr, xi);
	movq	%r14, %rsi	# x,
	movq	%r13, %rdi	# xr,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	movq	%rax, %rbp	# _44, _163
	shrq	$52, %rbp	#, _163
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	andl	$2047, %ebp	#, _224
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addl	$2047, %ebp	#, _225
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrl	$11, %ebp	#, _226
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	salq	$52, %rbp	#, _228
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addq	%rax, %rbp	# _44, x
# inputs/bootstrap/source/falcon-fft.c:894: 			FPC_ADD(f12r, f12i, f12r, f12i, f21r, f21i);
	movq	120(%rsp), %rsi	# %sfp,
	movq	128(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp398, fpct_re
# inputs/bootstrap/source/falcon-fft.c:894: 			FPC_ADD(f12r, f12i, f12r, f12i, f21r, f21i);
	movq	96(%rsp), %rsi	# %sfp,
	movq	88(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp399, fpct_im
# inputs/bootstrap/source/falcon-fft.c:895: 			FPC_ADD(f12r, f12i, f12r, f12i, f0r, f0i);
	movq	40(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# fpct_re,
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp400, %sfp
# inputs/bootstrap/source/falcon-fft.c:895: 			FPC_ADD(f12r, f12i, f12r, f12i, f0r, f0i);
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# fpct_im,
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp401, fpct_im
# inputs/bootstrap/source/falcon-fft.c:896: 			FPC_MUL(a[u + 2], a[u + 2 + hn], xr, xi, f12r, f12i);
	movq	%rax, %rsi	# fpct_im,
	movq	%rbp, %rdi	# x,
	call	fpr_mul@PLT	#
	movq	%rax, %r13	# tmp402, _45
# inputs/bootstrap/source/falcon-fft.c:896: 			FPC_MUL(a[u + 2], a[u + 2 + hn], xr, xi, f12r, f12i);
	movq	8(%rsp), %rsi	# %sfp,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp403, _46
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%rbx, %r13	# tmp273, _45
	movq	%r13, %rsi	# _45, y_193
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp404, _201
# inputs/bootstrap/source/falcon-fft.c:896: 			FPC_MUL(a[u + 2], a[u + 2 + hn], xr, xi, f12r, f12i);
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# x,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp405, _47
# inputs/bootstrap/source/falcon-fft.c:896: 			FPC_MUL(a[u + 2], a[u + 2 + hn], xr, xi, f12r, f12i);
	movq	%r14, %rsi	# fpct_im,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp406, _48
# inputs/bootstrap/source/falcon-fft.c:896: 			FPC_MUL(a[u + 2], a[u + 2 + hn], xr, xi, f12r, f12i);
	movq	%rbp, %rsi	# _47,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:896: 			FPC_MUL(a[u + 2], a[u + 2 + hn], xr, xi, f12r, f12i);
	movq	%r13, 16(%r15)	# _201, MEM[(fpr *)_337 + 16B]
	movq	%rax, 16(%r12)	# tmp407, MEM[(fpr *)_343 + 16B]
# inputs/bootstrap/source/falcon-fft.c:868: 		for (u = 0, v = (size_t)1 << logn; u < hn; u += 3, v += 2) {
	addq	$3, 64(%rsp)	#, %sfp
	movq	64(%rsp), %rax	# %sfp, u
# inputs/bootstrap/source/falcon-fft.c:868: 		for (u = 0, v = (size_t)1 << logn; u < hn; u += 3, v += 2) {
	addq	$24, %r15	#, ivtmp.419
	addq	$24, %r12	#, ivtmp.420
	addq	$16, 32(%rsp)	#, %sfp
	movq	144(%rsp), %rcx	# %sfp, hn
	cmpq	%rcx, %rax	# hn, u
	jb	.L143	#,
	movl	152(%rsp), %ebp	# %sfp, _4
	movq	144(%rsp), %r9	# %sfp, hn
	movl	156(%rsp), %r13d	# %sfp, full
# inputs/bootstrap/source/falcon-fft.c:903: 	t = 2 + (full << 2);
	leal	2(,%r13,4), %r8d	#, _7
# inputs/bootstrap/source/falcon-fft.c:903: 	t = 2 + (full << 2);
	movl	%r8d, %r12d	# _7, t
# inputs/bootstrap/source/falcon-fft.c:904: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	leal	-1(%rbp), %ecx	#, _9
# inputs/bootstrap/source/falcon-fft.c:904: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	movl	$1, %edx	#, tmp349
	salq	%cl, %rdx	# _9, tmp349
	movq	%rdx, %rbp	# tmp349, hm
# inputs/bootstrap/source/falcon-fft.c:904: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	movq	112(%rsp), %rax	# %sfp, n
	cmpq	%rax, %r12	# n, t
	jb	.L156	#,
	jmp	.L158	#
.L141:
# inputs/bootstrap/source/falcon-fft.c:903: 	t = 2 + (full << 2);
	leal	2(,%rdx,4), %r8d	#, _50
# inputs/bootstrap/source/falcon-fft.c:903: 	t = 2 + (full << 2);
	movl	%r8d, %r12d	# _50, t
# inputs/bootstrap/source/falcon-fft.c:904: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	leal	-1(%rbp), %ecx	#, _51
# inputs/bootstrap/source/falcon-fft.c:904: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	movl	$1, %edx	#, tmp313
	salq	%cl, %rdx	# _51, tmp313
	movq	%rdx, %rbp	# tmp313, hm
# inputs/bootstrap/source/falcon-fft.c:904: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	movq	112(%rsp), %rax	# %sfp, n
	cmpq	%rax, %r12	# n, t
	jnb	.L145	#,
.L156:
	movq	16(%rsp), %rax	# %sfp, a
	leaq	(%rax,%r9,8), %rax	#, _81
	movq	%rax, 40(%rsp)	# _81, %sfp
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r13	#, tmp351
	movq	%r9, 120(%rsp)	# hn, %sfp
	movq	%rbp, %r15	# hm, hm
	movq	%r12, %rdx	# t, t
.L150:
# inputs/bootstrap/source/falcon-fft.c:907: 		ht = t >> 1;
	movq	%rdx, %r8	# t, ivtmp.407
	shrq	%r8	# ivtmp.407
	movq	%r15, %r12	# hm, m
# inputs/bootstrap/source/falcon-fft.c:909: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	shrq	%r15	# hm
	je	.L146	#,
	salq	$4, %r12	#, _318
	leaq	fpr_gm3_square(%rip), %rax	#, tmp489
	leaq	(%r12,%rax), %rsi	#, ivtmp.406
	movq	16(%rsp), %rcx	# %sfp, a
	leaq	(%rcx,%r8,8), %rax	#, _288
	movq	%rax, 32(%rsp)	# _288, %sfp
	movq	120(%rsp), %rax	# %sfp, hn
	addq	%r8, %rax	# ivtmp.407, _184
	leaq	(%rcx,%rax,8), %rax	#, _280
	movq	%rax, 24(%rsp)	# _280, %sfp
# inputs/bootstrap/source/falcon-fft.c:909: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	movl	$0, %ecx	#, v1
# inputs/bootstrap/source/falcon-fft.c:909: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	movl	$0, %r12d	#, u1
	movq	%r15, 104(%rsp)	# hm, %sfp
	movq	%rdx, %r15	# t, t
	movq	%r12, %rdx	# u1, u1
.L149:
# inputs/bootstrap/source/falcon-fft.c:913: 			sr = fpr_gm3_square[((m + u1) << 1) + 0];
	movq	(%rsi), %r9	# MEM[(long unsigned int *)_322], sr
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movq	%r13, %r10	# tmp351, x
	xorq	8(%rsi), %r10	# MEM[(long unsigned int *)_322 + 8B], x
# inputs/bootstrap/source/falcon-fft.c:916: 			for (v = v1; v < v2; v ++) {
	cmpq	%r8, %rcx	# ivtmp.407, v1
	jnb	.L147	#,
# inputs/bootstrap/source/falcon-fft.c:916: 			for (v = v1; v < v2; v ++) {
	movq	%rcx, %rbx	# v1, v
	movq	%r15, 72(%rsp)	# t, %sfp
	movq	%r9, 64(%rsp)	# sr, %sfp
	movq	%rdx, 80(%rsp)	# u1, %sfp
	movq	%rcx, 88(%rsp)	# v1, %sfp
	movq	%r10, 8(%rsp)	# x, %sfp
	movq	%rsi, 96(%rsp)	# ivtmp.406, %sfp
	movq	%r8, 56(%rsp)	# ivtmp.407, %sfp
.L148:
# inputs/bootstrap/source/falcon-fft.c:919: 				a0r = a[v];
	movq	16(%rsp), %rdx	# %sfp, a
	movq	(%rdx,%rbx,8), %r15	# MEM[(fpr *)a_103(D) + v_301 * 8], a0r
# inputs/bootstrap/source/falcon-fft.c:920: 				a0i = a[v + hn];
	movq	40(%rsp), %rax	# %sfp, _81
	movq	(%rax,%rbx,8), %r14	# MEM[(fpr *)_81 + v_301 * 8], a0i
# inputs/bootstrap/source/falcon-fft.c:921: 				a1r = a[v + ht];
	movq	32(%rsp), %rdi	# %sfp, _288
	movq	(%rdi,%rbx,8), %r12	# MEM[(fpr *)_288 + v_301 * 8], a1r
# inputs/bootstrap/source/falcon-fft.c:922: 				a1i = a[v + ht + hn];
	movq	24(%rsp), %rsi	# %sfp, _280
	movq	(%rsi,%rbx,8), %rbp	# MEM[(fpr *)_280 + v_301 * 8], a1i
# inputs/bootstrap/source/falcon-fft.c:923: 				FPC_ADD(a[v], a[v + hn],
	movq	%r12, %rsi	# a1r,
	movq	%r15, %rdi	# a0r,
	call	fpr_add@PLT	#
	movq	%rax, 48(%rsp)	# tmp408, %sfp
# inputs/bootstrap/source/falcon-fft.c:923: 				FPC_ADD(a[v], a[v + hn],
	movq	%rbp, %rsi	# a1i,
	movq	%r14, %rdi	# a0i,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:923: 				FPC_ADD(a[v], a[v + hn],
	movq	16(%rsp), %rdx	# %sfp, a
	movq	48(%rsp), %r11	# %sfp, fpct_re
	movq	%r11, (%rdx,%rbx,8)	# fpct_re, MEM[(fpr *)a_103(D) + v_301 * 8]
	movq	40(%rsp), %rcx	# %sfp, _81
	movq	%rax, (%rcx,%rbx,8)	# tmp409, MEM[(fpr *)_81 + v_301 * 8]
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%r13, %r12	# tmp351, a1r
	movq	%r12, %rsi	# a1r, y_250
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	%r15, %rdi	# a0r,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp410, _251
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%r13, %rbp	# tmp351, a1i
	movq	%rbp, %rsi	# a1i, y_248
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	%r14, %rdi	# a0i,
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp411, _249
# inputs/bootstrap/source/falcon-fft.c:926: 				FPC_MUL(a[v + ht], a[v + ht + hn],
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rax, %rdi	# _249,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp412, _67
# inputs/bootstrap/source/falcon-fft.c:926: 				FPC_MUL(a[v + ht], a[v + ht + hn],
	movq	64(%rsp), %r15	# %sfp, sr
	movq	%r15, %rsi	# sr,
	movq	%r12, %rdi	# _251,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp413, _68
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%r13, %rbp	# tmp351, _67
	movq	%rbp, %rsi	# _67, y_246
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp414, _247
# inputs/bootstrap/source/falcon-fft.c:926: 				FPC_MUL(a[v + ht], a[v + ht + hn],
	movq	%r15, %rsi	# sr,
	movq	%r14, %rdi	# _249,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp415, _69
# inputs/bootstrap/source/falcon-fft.c:926: 				FPC_MUL(a[v + ht], a[v + ht + hn],
	movq	8(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# _251,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp416, _70
# inputs/bootstrap/source/falcon-fft.c:926: 				FPC_MUL(a[v + ht], a[v + ht + hn],
	movq	%r14, %rsi	# _69,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:926: 				FPC_MUL(a[v + ht], a[v + ht + hn],
	movq	32(%rsp), %rdi	# %sfp, _288
	movq	%rbp, (%rdi,%rbx,8)	# _247, MEM[(fpr *)_288 + v_301 * 8]
	movq	24(%rsp), %rsi	# %sfp, _280
	movq	%rax, (%rsi,%rbx,8)	# tmp417, MEM[(fpr *)_280 + v_301 * 8]
# inputs/bootstrap/source/falcon-fft.c:916: 			for (v = v1; v < v2; v ++) {
	addq	$1, %rbx	#, v
# inputs/bootstrap/source/falcon-fft.c:916: 			for (v = v1; v < v2; v ++) {
	movq	56(%rsp), %rax	# %sfp, ivtmp.407
	cmpq	%rax, %rbx	# ivtmp.407, v
	jne	.L148	#,
	movq	72(%rsp), %r15	# %sfp, t
	movq	80(%rsp), %rdx	# %sfp, u1
	movq	88(%rsp), %rcx	# %sfp, v1
	movq	96(%rsp), %rsi	# %sfp, ivtmp.406
	movq	%rax, %r8	# ivtmp.407, ivtmp.407
.L147:
# inputs/bootstrap/source/falcon-fft.c:909: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	addq	$1, %rdx	#, u1
# inputs/bootstrap/source/falcon-fft.c:909: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	addq	%r15, %rcx	# t, v1
# inputs/bootstrap/source/falcon-fft.c:909: 		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
	addq	$16, %rsi	#, ivtmp.406
	addq	%r15, %r8	# t, ivtmp.407
	cmpq	%rdx, 104(%rsp)	# u1, %sfp
	jne	.L149	#,
	movq	%r15, %rdx	# t, t
	movq	104(%rsp), %r15	# %sfp, hm
.L146:
# inputs/bootstrap/source/falcon-fft.c:930: 		t <<= 1;
	addq	%rdx, %rdx	# t
# inputs/bootstrap/source/falcon-fft.c:904: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	movq	112(%rsp), %rax	# %sfp, n
	cmpq	%rax, %rdx	# n, t
	jb	.L150	#,
	movq	120(%rsp), %r9	# %sfp, hn
.L145:
# inputs/bootstrap/source/falcon-fft.c:947: 	for (u = 0; u < hn; u ++) {
	testq	%r9, %r9	# hn
	je	.L151	#,
.L158:
	movq	16(%rsp), %r13	# %sfp, a
	leaq	0(%r13,%r9,8), %r12	#, _287
# inputs/bootstrap/source/falcon-fft.c:947: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	movabsq	$-4503599627370496, %r15	#, tmp330
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r14	#, tmp338
	movq	%r9, 24(%rsp)	# hn, %sfp
.L152:
# inputs/bootstrap/source/falcon-fft.c:950: 		xr = a[u];
	movq	0(%r13,%rbx,8), %rax	# MEM[(fpr *)a_103(D) + u_294 * 8], xr
	movq	%rax, 8(%rsp)	# xr, %sfp
# inputs/bootstrap/source/falcon-fft.c:952: 		a1 = fpr_mul(xi, fpr_IW1I);
	movq	(%r12,%rbx,8), %rdi	# MEM[(fpr *)_287 + u_294 * 8], MEM[(fpr *)_287 + u_294 * 8]
	movabsq	$4607879128087016220, %rsi	#,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp418, a1
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	leaq	(%rax,%r15), %rsi	#, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rsi, %rax	# x, _255
	shrq	$52, %rax	#, _255
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %eax	#, _257
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %eax	#, _258
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %eax	#, t_259
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%eax, %eax	# t_259, _260
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rax	#, _261
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rax, %rsi	# _261, x_262
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%r14, %rsi	# tmp338, y_252
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:954: 		a[u] = a0;
	movq	%rax, 0(%r13,%rbx,8)	# tmp419, MEM[(fpr *)a_103(D) + u_294 * 8]
# inputs/bootstrap/source/falcon-fft.c:955: 		a[u + hn] = a1;
	movq	%rbp, (%r12,%rbx,8)	# a1, MEM[(fpr *)_287 + u_294 * 8]
# inputs/bootstrap/source/falcon-fft.c:947: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:947: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, 24(%rsp)	# u, %sfp
	jne	.L152	#,
	movq	24(%rsp), %r9	# %sfp, hn
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movq	%r9, %rdi	# hn,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp423, _185
# inputs/bootstrap/source/fpr-emulated.h:95: 	return fpr_div(fpr_one, fpr_of(i));
	movabsq	$4607182418800017408, %rdi	#, tmp345
	call	fpr_div@PLT	#
	movq	%rax, %r12	# tmp424, _13
.L157:
# inputs/bootstrap/source/falcon-fft.c:947: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
	movq	112(%rsp), %r13	# %sfp, n
	movq	16(%rsp), %rbp	# %sfp, a
.L155:
# inputs/bootstrap/source/falcon-fft.c:963: 		a[u] = fpr_mul(ni, a[u]);
	movq	0(%rbp,%rbx,8), %rsi	# MEM[(fpr *)a_103(D) + u_295 * 8], MEM[(fpr *)a_103(D) + u_295 * 8]
	movq	%r12, %rdi	# _13,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:963: 		a[u] = fpr_mul(ni, a[u]);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp422, MEM[(fpr *)a_103(D) + u_295 * 8]
# inputs/bootstrap/source/falcon-fft.c:962: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:962: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r13	# u, n
	jne	.L155	#,
.L140:
# inputs/bootstrap/source/falcon-fft.c:965: }
	addq	$168, %rsp	#,
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
.L142:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-fft.c:903: 	t = 2 + (full << 2);
	leal	2(,%rdx,4), %r8d	#, _281
# inputs/bootstrap/source/falcon-fft.c:903: 	t = 2 + (full << 2);
	movl	%r8d, %r12d	# _281, t
# inputs/bootstrap/source/falcon-fft.c:904: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	leal	-1(%rbp), %ecx	#, _82
# inputs/bootstrap/source/falcon-fft.c:904: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	movl	$1, %edx	#, tmp344
	salq	%cl, %rdx	# _82, tmp344
	movq	%rdx, %rbp	# tmp344, hm
# inputs/bootstrap/source/falcon-fft.c:904: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	movq	112(%rsp), %rax	# %sfp, n
	cmpq	%rax, %r12	# n, t
	jb	.L156	#,
.L151:
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movq	%r9, %rdi	# hn,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp420, _276
# inputs/bootstrap/source/fpr-emulated.h:95: 	return fpr_div(fpr_one, fpr_of(i));
	movabsq	$4607182418800017408, %rdi	#, tmp339
	call	fpr_div@PLT	#
	movq	%rax, %r12	# tmp421, _13
# inputs/bootstrap/source/falcon-fft.c:962: 	for (u = 0; u < n; u ++) {
	cmpq	$0, 112(%rsp)	#, %sfp
	je	.L140	#,
	jmp	.L157	#
	.cfi_endproc
.LFE56:
	.size	falcon_iFFT3, .-falcon_iFFT3
	.globl	falcon_poly_add3
	.type	falcon_poly_add3, @function
falcon_poly_add3:
.LFB57:
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
# inputs/bootstrap/source/falcon-fft.c:974: 	n = MKN(logn, full);
	leal	1(%rcx,%rcx), %r12d	#, _3
	subl	%ecx, %edx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:974: 	n = MKN(logn, full);
	movl	%edx, %ecx	# _4, tmp123
	salq	%cl, %r12	# tmp123, n
# inputs/bootstrap/source/falcon-fft.c:975: 	for (u = 0; u < n; u ++) {
	testq	%r12, %r12	# n
	je	.L169	#,
	movq	%rdi, %rbp	# tmp117, a
	movq	%rsi, %r13	# tmp118, b
# inputs/bootstrap/source/falcon-fft.c:975: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L171:
# inputs/bootstrap/source/falcon-fft.c:976: 		a[u] = fpr_add(a[u], b[u]);
	movq	0(%r13,%rbx,8), %rsi	# MEM[(const fpr *)b_17(D) + u_24 * 8], MEM[(const fpr *)b_17(D) + u_24 * 8]
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_18(D) + u_24 * 8], MEM[(fpr *)a_18(D) + u_24 * 8]
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:976: 		a[u] = fpr_add(a[u], b[u]);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp121, MEM[(fpr *)a_18(D) + u_24 * 8]
# inputs/bootstrap/source/falcon-fft.c:975: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:975: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r12	# u, n
	jne	.L171	#,
.L169:
# inputs/bootstrap/source/falcon-fft.c:978: }
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
.LFE57:
	.size	falcon_poly_add3, .-falcon_poly_add3
	.globl	falcon_poly_addconst3
	.type	falcon_poly_addconst3, @function
falcon_poly_addconst3:
.LFB58:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx	# tmp105, a
# inputs/bootstrap/source/falcon-fft.c:986: 	a[0] = fpr_add(a[0], x);
	movq	(%rdi), %rdi	# *a_4(D), *a_4(D)
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:986: 	a[0] = fpr_add(a[0], x);
	movq	%rax, (%rbx)	# tmp107, *a_4(D)
# inputs/bootstrap/source/falcon-fft.c:987: }
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE58:
	.size	falcon_poly_addconst3, .-falcon_poly_addconst3
	.globl	falcon_poly_addconst_fft3
	.type	falcon_poly_addconst_fft3, @function
falcon_poly_addconst_fft3:
.LFB59:
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
# inputs/bootstrap/source/falcon-fft.c:995: 	n = MKN(logn, full);
	leal	1(%rcx,%rcx), %r12d	#, _3
	subl	%ecx, %edx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:995: 	n = MKN(logn, full);
	movl	%edx, %ecx	# _4, tmp121
	salq	%cl, %r12	# tmp121, n
# inputs/bootstrap/source/falcon-fft.c:996: 	for (u = 0; u < n; u ++) {
	testq	%r12, %r12	# n
	je	.L176	#,
	movq	%rdi, %rbp	# tmp115, a
	movq	%rsi, %r13	# tmp116, x
# inputs/bootstrap/source/falcon-fft.c:996: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L178:
# inputs/bootstrap/source/falcon-fft.c:997: 		a[u] = fpr_add(a[u], x);
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_15(D) + u_22 * 8], MEM[(fpr *)a_15(D) + u_22 * 8]
	movq	%r13, %rsi	# x,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:997: 		a[u] = fpr_add(a[u], x);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp119, MEM[(fpr *)a_15(D) + u_22 * 8]
# inputs/bootstrap/source/falcon-fft.c:996: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:996: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r12	# u, n
	jne	.L178	#,
.L176:
# inputs/bootstrap/source/falcon-fft.c:999: }
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
.LFE59:
	.size	falcon_poly_addconst_fft3, .-falcon_poly_addconst_fft3
	.globl	falcon_poly_sub3
	.type	falcon_poly_sub3, @function
falcon_poly_sub3:
.LFB60:
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
# inputs/bootstrap/source/falcon-fft.c:1008: 	n = MKN(logn, full);
	leal	1(%rcx,%rcx), %r12d	#, _3
	subl	%ecx, %edx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:1008: 	n = MKN(logn, full);
	movl	%edx, %ecx	# _4, tmp125
	salq	%cl, %r12	# tmp125, n
# inputs/bootstrap/source/falcon-fft.c:1009: 	for (u = 0; u < n; u ++) {
	testq	%r12, %r12	# n
	je	.L181	#,
	movq	%rdi, %rbp	# tmp119, a
	movq	%rsi, %r13	# tmp120, b
# inputs/bootstrap/source/falcon-fft.c:1009: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r14	#, tmp117
.L183:
	movq	%r14, %rsi	# tmp117, y_20
	xorq	0(%r13,%rbx,8), %rsi	# MEM[(const fpr *)b_16(D) + u_25 * 8], y_20
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_17(D) + u_25 * 8], MEM[(fpr *)a_17(D) + u_25 * 8]
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1010: 		a[u] = fpr_sub(a[u], b[u]);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp123, MEM[(fpr *)a_17(D) + u_25 * 8]
# inputs/bootstrap/source/falcon-fft.c:1009: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1009: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r12	# u, n
	jne	.L183	#,
.L181:
# inputs/bootstrap/source/falcon-fft.c:1012: }
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
	.cfi_endproc
.LFE60:
	.size	falcon_poly_sub3, .-falcon_poly_sub3
	.globl	falcon_poly_neg3
	.type	falcon_poly_neg3, @function
falcon_poly_neg3:
.LFB61:
	.cfi_startproc
# inputs/bootstrap/source/falcon-fft.c:1020: 	n = MKN(logn, full);
	leal	1(%rdx,%rdx), %eax	#, _3
	subl	%edx, %esi	# full, tmp119
	movl	%esi, %ecx	# tmp119, _4
# inputs/bootstrap/source/falcon-fft.c:1020: 	n = MKN(logn, full);
	salq	%cl, %rax	# _4, _3
	movq	%rax, %rdx	# _3, n
# inputs/bootstrap/source/falcon-fft.c:1021: 	for (u = 0; u < n; u ++) {
	testq	%rax, %rax	# n
	je	.L186	#,
	movq	%rdi, %rax	# a, ivtmp.451
	leaq	(%rdi,%rdx,8), %rcx	#, _27
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdx	#, tmp117
	.p2align 4
.L188:
	xorq	%rdx, (%rax)	# tmp117, MEM[(fpr *)_23]
# inputs/bootstrap/source/falcon-fft.c:1021: 	for (u = 0; u < n; u ++) {
	addq	$8, %rax	#, ivtmp.451
	cmpq	%rcx, %rax	# _27, ivtmp.451
	jne	.L188	#,
.L186:
# inputs/bootstrap/source/falcon-fft.c:1024: }
	ret	
	.cfi_endproc
.LFE61:
	.size	falcon_poly_neg3, .-falcon_poly_neg3
	.globl	falcon_poly_adj_fft3
	.type	falcon_poly_adj_fft3, @function
falcon_poly_adj_fft3:
.LFB62:
	.cfi_startproc
	movl	%edx, %eax	# tmp125, full
# inputs/bootstrap/source/falcon-fft.c:1032: 	n = MKN(logn, full);
	leal	1(%rdx,%rdx), %edx	#, _3
	subl	%eax, %esi	# full, tmp124
	movl	%esi, %ecx	# tmp124, _4
# inputs/bootstrap/source/falcon-fft.c:1032: 	n = MKN(logn, full);
	salq	%cl, %rdx	# _4, n
# inputs/bootstrap/source/falcon-fft.c:1033: 	hn = n >> 1;
	movq	%rdx, %rax	# n, hn
	shrq	%rax	# hn
# inputs/bootstrap/source/falcon-fft.c:1034: 	for (u = hn; u < n; u ++) {
	cmpq	%rdx, %rax	# n, hn
	jnb	.L190	#,
	leaq	(%rdi,%rax,8), %rax	#, ivtmp.458
	leaq	(%rdi,%rdx,8), %rcx	#, _30
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdx	#, tmp122
	.p2align 4
.L192:
	xorq	%rdx, (%rax)	# tmp122, MEM[(fpr *)_26]
# inputs/bootstrap/source/falcon-fft.c:1034: 	for (u = hn; u < n; u ++) {
	addq	$8, %rax	#, ivtmp.458
	cmpq	%rcx, %rax	# _30, ivtmp.458
	jne	.L192	#,
.L190:
# inputs/bootstrap/source/falcon-fft.c:1037: }
	ret	
	.cfi_endproc
.LFE62:
	.size	falcon_poly_adj_fft3, .-falcon_poly_adj_fft3
	.globl	falcon_poly_mul_fft3
	.type	falcon_poly_mul_fft3, @function
falcon_poly_mul_fft3:
.LFB63:
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
	movq	%rsi, 24(%rsp)	# tmp129, %sfp
# inputs/bootstrap/source/falcon-fft.c:1046: 	n = MKN(logn, full);
	leal	1(%rcx,%rcx), %eax	#, _3
	subl	%ecx, %edx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:1046: 	n = MKN(logn, full);
	movl	%edx, %ecx	# _4, tmp139
	salq	%cl, %rax	# tmp139, n_20
# inputs/bootstrap/source/falcon-fft.c:1048: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_20
	movq	%rax, 16(%rsp)	# hn, %sfp
	je	.L194	#,
	movq	%rdi, %r12	# tmp128, a
	leaq	0(,%rax,8), %rbp	#, ivtmp.469
# inputs/bootstrap/source/falcon-fft.c:1048: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L196:
# inputs/bootstrap/source/falcon-fft.c:1051: 		a_re = a[u];
	movq	(%r12,%rbx,8), %rax	# MEM[(fpr *)a_23(D) + u_43 * 8], a_re
	movq	%rax, (%rsp)	# a_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:1052: 		a_im = a[u + hn];
	movq	(%r12,%rbp), %r14	# MEM[(fpr *)a_23(D) + ivtmp.469_16 * 1], a_im
# inputs/bootstrap/source/falcon-fft.c:1053: 		b_re = b[u];
	movq	24(%rsp), %rdx	# %sfp, b
	movq	(%rdx,%rbx,8), %r15	# MEM[(const fpr *)b_26(D) + u_43 * 8], b_re
# inputs/bootstrap/source/falcon-fft.c:1054: 		b_im = b[u + hn];
	movq	(%rdx,%rbp), %r13	# MEM[(const fpr *)b_26(D) + ivtmp.469_16 * 1], b_im
# inputs/bootstrap/source/falcon-fft.c:1055: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# b_im,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp132, %sfp
# inputs/bootstrap/source/falcon-fft.c:1055: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r15, %rsi	# b_re,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp133, _13
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	8(%rsp), %rsi	# %sfp, _12
	movabsq	$-9223372036854775808, %rcx	#, tmp146
	xorq	%rcx, %rsi	# tmp146, _12
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp134, %sfp
# inputs/bootstrap/source/falcon-fft.c:1055: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r15, %rsi	# b_re,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp135, _14
# inputs/bootstrap/source/falcon-fft.c:1055: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# b_im,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp136, _15
# inputs/bootstrap/source/falcon-fft.c:1055: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# _14,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1055: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rcx	# %sfp, _39
	movq	%rcx, (%r12,%rbx,8)	# _39, MEM[(fpr *)a_23(D) + u_43 * 8]
	movq	%rax, (%r12,%rbp)	# tmp137, MEM[(fpr *)a_23(D) + ivtmp.469_16 * 1]
# inputs/bootstrap/source/falcon-fft.c:1048: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1048: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbp	#, ivtmp.469
	cmpq	%rbx, 16(%rsp)	# u, %sfp
	jne	.L196	#,
.L194:
# inputs/bootstrap/source/falcon-fft.c:1057: }
	addq	$40, %rsp	#,
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
.LFE63:
	.size	falcon_poly_mul_fft3, .-falcon_poly_mul_fft3
	.globl	falcon_poly_sqr_fft3
	.type	falcon_poly_sqr_fft3, @function
falcon_poly_sqr_fft3:
.LFB64:
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
# inputs/bootstrap/source/falcon-fft.c:1065: 	n = MKN(logn, full);
	leal	1(%rdx,%rdx), %eax	#, _3
	movl	%esi, %ecx	# tmp141, tmp141
	subl	%edx, %ecx	# full, tmp141
# inputs/bootstrap/source/falcon-fft.c:1065: 	n = MKN(logn, full);
	salq	%cl, %rax	# _4, n_15
# inputs/bootstrap/source/falcon-fft.c:1067: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_15
	movq	%rax, 8(%rsp)	# hn, %sfp
	je	.L199	#,
	movq	%rdi, %r14	# tmp140, a
	leaq	(%rdi,%rax,8), %r15	#, _40
# inputs/bootstrap/source/falcon-fft.c:1067: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L201:
# inputs/bootstrap/source/falcon-fft.c:1070: 		a_re = a[u];
	movq	(%r14,%rbx,8), %r12	# MEM[(fpr *)a_18(D) + u_42 * 8], a_re
# inputs/bootstrap/source/falcon-fft.c:1071: 		a_im = a[u + hn];
	movq	(%r15,%rbx,8), %r13	# MEM[(fpr *)_40 + u_42 * 8], a_im
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%r13, %rsi	# a_im,
	movq	%r13, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp143, _36
	movq	%r12, %rsi	# a_re,
	movq	%r12, %rdi	# a_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp144, _35
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_33
	xorq	%rbp, %rsi	# _36, y_33
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp145, _34
# inputs/bootstrap/source/falcon-fft.c:1072: 		FPC_SQR(a[u], a[u + hn], a_re, a_im);
	movq	%r13, %rsi	# a_im,
	movq	%r12, %rdi	# a_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rcx	# tmp146, _10
# inputs/bootstrap/source/falcon-fft.c:1072: 		FPC_SQR(a[u], a[u + hn], a_re, a_im);
	movq	%rbp, (%r14,%rbx,8)	# _34, MEM[(fpr *)a_18(D) + u_42 * 8]
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrq	$52, %rax	#, _22
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	andl	$2047, %eax	#, _27
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addl	$2047, %eax	#, _28
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrl	$11, %eax	#, _29
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	movq	%rax, %rdx	# _29, _31
	salq	$52, %rdx	#, _31
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	leaq	(%rdx,%rcx), %rax	#, tmp139
	movq	%rax, (%r15,%rbx,8)	# tmp139, MEM[(fpr *)_40 + u_42 * 8]
# inputs/bootstrap/source/falcon-fft.c:1067: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1067: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, 8(%rsp)	# u, %sfp
	jne	.L201	#,
.L199:
# inputs/bootstrap/source/falcon-fft.c:1074: }
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
.LFE64:
	.size	falcon_poly_sqr_fft3, .-falcon_poly_sqr_fft3
	.globl	falcon_poly_muladj_fft3
	.type	falcon_poly_muladj_fft3, @function
falcon_poly_muladj_fft3:
.LFB65:
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
	movq	%rsi, 24(%rsp)	# tmp131, %sfp
# inputs/bootstrap/source/falcon-fft.c:1083: 	n = MKN(logn, full);
	leal	1(%rcx,%rcx), %eax	#, _3
	subl	%ecx, %edx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:1083: 	n = MKN(logn, full);
	movl	%edx, %ecx	# _4, tmp141
	salq	%cl, %rax	# tmp141, n_21
# inputs/bootstrap/source/falcon-fft.c:1085: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_21
	movq	%rax, 16(%rsp)	# hn, %sfp
	je	.L204	#,
	movq	%rdi, %r12	# tmp130, a
	leaq	0(,%rax,8), %rbp	#, ivtmp.488
# inputs/bootstrap/source/falcon-fft.c:1085: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L206:
# inputs/bootstrap/source/falcon-fft.c:1088: 		a_re = a[u];
	movq	(%r12,%rbx,8), %rax	# MEM[(fpr *)a_24(D) + u_44 * 8], a_re
	movq	%rax, (%rsp)	# a_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:1089: 		a_im = a[u + hn];
	movq	(%r12,%rbp), %r14	# MEM[(fpr *)a_24(D) + ivtmp.488_17 * 1], a_im
# inputs/bootstrap/source/falcon-fft.c:1090: 		b_re = b[u];
	movq	24(%rsp), %rdx	# %sfp, b
	movq	(%rdx,%rbx,8), %r15	# MEM[(const fpr *)b_27(D) + u_44 * 8], b_re
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r13	#, x
	xorq	(%rdx,%rbp), %r13	# MEM[(const fpr *)b_27(D) + ivtmp.488_17 * 1], x
# inputs/bootstrap/source/falcon-fft.c:1092: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# x,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp134, %sfp
# inputs/bootstrap/source/falcon-fft.c:1092: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r15, %rsi	# b_re,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp135, _14
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	8(%rsp), %rsi	# %sfp, _13
	movabsq	$-9223372036854775808, %rcx	#, tmp149
	xorq	%rcx, %rsi	# tmp149, _13
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp136, %sfp
# inputs/bootstrap/source/falcon-fft.c:1092: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r15, %rsi	# b_re,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp137, _15
# inputs/bootstrap/source/falcon-fft.c:1092: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# x,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp138, _16
# inputs/bootstrap/source/falcon-fft.c:1092: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# _15,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1092: 		FPC_MUL(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rcx	# %sfp, _39
	movq	%rcx, (%r12,%rbx,8)	# _39, MEM[(fpr *)a_24(D) + u_44 * 8]
	movq	%rax, (%r12,%rbp)	# tmp139, MEM[(fpr *)a_24(D) + ivtmp.488_17 * 1]
# inputs/bootstrap/source/falcon-fft.c:1085: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1085: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbp	#, ivtmp.488
	cmpq	%rbx, 16(%rsp)	# u, %sfp
	jne	.L206	#,
.L204:
# inputs/bootstrap/source/falcon-fft.c:1094: }
	addq	$40, %rsp	#,
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
.LFE65:
	.size	falcon_poly_muladj_fft3, .-falcon_poly_muladj_fft3
	.globl	falcon_poly_mulselfadj_fft3
	.type	falcon_poly_mulselfadj_fft3, @function
falcon_poly_mulselfadj_fft3:
.LFB66:
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
# inputs/bootstrap/source/falcon-fft.c:1106: 	n = MKN(logn, full);
	leal	1(%rdx,%rdx), %r14d	#, _3
	movl	%esi, %ecx	# tmp123, tmp123
	subl	%edx, %ecx	# full, tmp123
# inputs/bootstrap/source/falcon-fft.c:1106: 	n = MKN(logn, full);
	salq	%cl, %r14	# _4, n_15
# inputs/bootstrap/source/falcon-fft.c:1108: 	for (u = 0; u < hn; u ++) {
	shrq	%r14	# hn
	je	.L209	#,
	movq	%rdi, %r12	# tmp122, a
	leaq	(%rdi,%r14,8), %r13	#, _32
# inputs/bootstrap/source/falcon-fft.c:1108: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L211:
# inputs/bootstrap/source/falcon-fft.c:1111: 		a_re = a[u];
	movq	(%r12,%rbx,8), %r15	# MEM[(fpr *)a_18(D) + u_33 * 8], a_re
# inputs/bootstrap/source/falcon-fft.c:1112: 		a_im = a[u + hn];
	movq	0(%r13,%rbx,8), %rdi	# MEM[(fpr *)_32 + u_33 * 8], a_im
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp125, _27
	movq	%r15, %rsi	# a_re,
	movq	%r15, %rdi	# a_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp126, _26
# inputs/bootstrap/source/falcon-fft.c:1113: 		a[u] = fpr_add(fpr_sqr(a_re), fpr_sqr(a_im));
	movq	%rbp, %rsi	# _27,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1113: 		a[u] = fpr_add(fpr_sqr(a_re), fpr_sqr(a_im));
	movq	%rax, (%r12,%rbx,8)	# tmp127, MEM[(fpr *)a_18(D) + u_33 * 8]
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$0, %edi	#,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1114: 		a[u + hn] = fpr_of(0);
	movq	%rax, 0(%r13,%rbx,8)	# tmp128, MEM[(fpr *)_32 + u_33 * 8]
# inputs/bootstrap/source/falcon-fft.c:1108: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1108: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, %r14	# u, hn
	jne	.L211	#,
.L209:
# inputs/bootstrap/source/falcon-fft.c:1116: }
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
.LFE66:
	.size	falcon_poly_mulselfadj_fft3, .-falcon_poly_mulselfadj_fft3
	.globl	falcon_poly_mulconst3
	.type	falcon_poly_mulconst3, @function
falcon_poly_mulconst3:
.LFB67:
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
# inputs/bootstrap/source/falcon-fft.c:1124: 	n = MKN(logn, full);
	leal	1(%rcx,%rcx), %r12d	#, _3
	subl	%ecx, %edx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:1124: 	n = MKN(logn, full);
	movl	%edx, %ecx	# _4, tmp121
	salq	%cl, %r12	# tmp121, n
# inputs/bootstrap/source/falcon-fft.c:1125: 	for (u = 0; u < n; u ++) {
	testq	%r12, %r12	# n
	je	.L214	#,
	movq	%rdi, %rbp	# tmp115, a
	movq	%rsi, %r13	# tmp116, x
# inputs/bootstrap/source/falcon-fft.c:1125: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L216:
# inputs/bootstrap/source/falcon-fft.c:1126: 		a[u] = fpr_mul(a[u], x);
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_15(D) + u_22 * 8], MEM[(fpr *)a_15(D) + u_22 * 8]
	movq	%r13, %rsi	# x,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1126: 		a[u] = fpr_mul(a[u], x);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp119, MEM[(fpr *)a_15(D) + u_22 * 8]
# inputs/bootstrap/source/falcon-fft.c:1125: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1125: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r12	# u, n
	jne	.L216	#,
.L214:
# inputs/bootstrap/source/falcon-fft.c:1128: }
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
.LFE67:
	.size	falcon_poly_mulconst3, .-falcon_poly_mulconst3
	.globl	falcon_poly_inv_fft3
	.type	falcon_poly_inv_fft3, @function
falcon_poly_inv_fft3:
.LFB68:
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
# inputs/bootstrap/source/falcon-fft.c:1136: 	n = MKN(logn, full);
	leal	1(%rdx,%rdx), %eax	#, _3
	movl	%esi, %ecx	# tmp127, tmp127
	subl	%edx, %ecx	# full, tmp127
# inputs/bootstrap/source/falcon-fft.c:1136: 	n = MKN(logn, full);
	salq	%cl, %rax	# _4, n_14
# inputs/bootstrap/source/falcon-fft.c:1138: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_14
	movq	%rax, 8(%rsp)	# hn, %sfp
	je	.L219	#,
	movq	%rdi, %r14	# tmp126, a
	leaq	(%rdi,%rax,8), %r15	#, _35
# inputs/bootstrap/source/falcon-fft.c:1138: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L221:
# inputs/bootstrap/source/falcon-fft.c:1141: 		a_re = a[u];
	movq	(%r14,%rbx,8), %r13	# MEM[(fpr *)a_17(D) + u_36 * 8], a_re
# inputs/bootstrap/source/falcon-fft.c:1142: 		a_im = a[u + hn];
	movq	(%r15,%rbx,8), %rbp	# MEM[(fpr *)_35 + u_36 * 8], a_im
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rbp, %rsi	# a_im,
	movq	%rbp, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp129, _31
	movq	%r13, %rsi	# a_re,
	movq	%r13, %rdi	# a_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp130, _30
# inputs/bootstrap/source/falcon-fft.c:1143: 		FPC_INV(a[u], a[u + hn], a_re, a_im);
	movq	%r12, %rsi	# _31,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp131, fpct_m
# inputs/bootstrap/source/falcon-fft.c:1143: 		FPC_INV(a[u], a[u + hn], a_re, a_im);
	movq	%rax, %rsi	# fpct_m,
	movq	%r13, %rdi	# a_re,
	call	fpr_div@PLT	#
	movq	%rax, %r13	# tmp132, fpct_d_re
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdi	#, x_24
	xorq	%rbp, %rdi	# a_im, x_24
# inputs/bootstrap/source/falcon-fft.c:1143: 		FPC_INV(a[u], a[u + hn], a_re, a_im);
	movq	%r12, %rsi	# fpct_m,
	call	fpr_div@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1143: 		FPC_INV(a[u], a[u + hn], a_re, a_im);
	movq	%r13, (%r14,%rbx,8)	# fpct_d_re, MEM[(fpr *)a_17(D) + u_36 * 8]
	movq	%rax, (%r15,%rbx,8)	# tmp133, MEM[(fpr *)_35 + u_36 * 8]
# inputs/bootstrap/source/falcon-fft.c:1138: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1138: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, 8(%rsp)	# u, %sfp
	jne	.L221	#,
.L219:
# inputs/bootstrap/source/falcon-fft.c:1145: }
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
.LFE68:
	.size	falcon_poly_inv_fft3, .-falcon_poly_inv_fft3
	.globl	falcon_poly_div_fft3
	.type	falcon_poly_div_fft3, @function
falcon_poly_div_fft3:
.LFB69:
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
	movq	%rsi, 24(%rsp)	# tmp137, %sfp
# inputs/bootstrap/source/falcon-fft.c:1154: 	n = MKN(logn, full);
	leal	1(%rcx,%rcx), %eax	#, _3
	subl	%ecx, %edx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:1154: 	n = MKN(logn, full);
	movl	%edx, %ecx	# _4, tmp152
	salq	%cl, %rax	# tmp152, n_20
# inputs/bootstrap/source/falcon-fft.c:1156: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_20
	movq	%rax, 16(%rsp)	# hn, %sfp
	je	.L224	#,
	movq	%rdi, %r13	# tmp136, a
	leaq	0(,%rax,8), %r12	#, ivtmp.521
# inputs/bootstrap/source/falcon-fft.c:1156: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L226:
# inputs/bootstrap/source/falcon-fft.c:1159: 		a_re = a[u];
	movq	0(%r13,%rbx,8), %rax	# MEM[(fpr *)a_23(D) + u_54 * 8], a_re
	movq	%rax, (%rsp)	# a_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:1160: 		a_im = a[u + hn];
	movq	0(%r13,%r12), %r15	# MEM[(fpr *)a_23(D) + ivtmp.521_16 * 1], a_im
# inputs/bootstrap/source/falcon-fft.c:1161: 		b_re = b[u];
	movq	24(%rsp), %rdx	# %sfp, b
	movq	(%rdx,%rbx,8), %r14	# MEM[(const fpr *)b_26(D) + u_54 * 8], b_re
# inputs/bootstrap/source/falcon-fft.c:1162: 		b_im = b[u + hn];
	movq	(%rdx,%r12), %rbp	# MEM[(const fpr *)b_26(D) + ivtmp.521_16 * 1], b_im
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rbp, %rsi	# b_im,
	movq	%rbp, %rdi	# b_im,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp140, %sfp
	movq	%r14, %rsi	# b_re,
	movq	%r14, %rdi	# b_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp141, _47
# inputs/bootstrap/source/falcon-fft.c:1163: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1163: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%rax, 8(%rsp)	# fpct_m, %sfp
	movq	%rax, %rsi	# fpct_m,
	movq	%r14, %rdi	# b_re,
	call	fpr_div@PLT	#
	movq	%rax, %r14	# tmp143, fpct_b_re
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdi	#, x_46
	xorq	%rbp, %rdi	# b_im, x_46
# inputs/bootstrap/source/falcon-fft.c:1163: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rsi	# %sfp,
	call	fpr_div@PLT	#
	movq	%rax, %rbp	# tmp144, fpct_b_im
# inputs/bootstrap/source/falcon-fft.c:1163: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%rax, %rsi	# fpct_b_im,
	movq	%r15, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp145, %sfp
# inputs/bootstrap/source/falcon-fft.c:1163: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# fpct_b_re,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp146, _13
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	8(%rsp), %rsi	# %sfp, _12
	movabsq	$-9223372036854775808, %rcx	#, tmp160
	xorq	%rcx, %rsi	# tmp160, _12
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp147, %sfp
# inputs/bootstrap/source/falcon-fft.c:1163: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# fpct_b_re,
	movq	%r15, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp148, _14
# inputs/bootstrap/source/falcon-fft.c:1163: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%rbp, %rsi	# fpct_b_im,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp149, _15
# inputs/bootstrap/source/falcon-fft.c:1163: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r14, %rsi	# _14,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1163: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rcx	# %sfp, _45
	movq	%rcx, 0(%r13,%rbx,8)	# _45, MEM[(fpr *)a_23(D) + u_54 * 8]
	movq	%rax, 0(%r13,%r12)	# tmp150, MEM[(fpr *)a_23(D) + ivtmp.521_16 * 1]
# inputs/bootstrap/source/falcon-fft.c:1156: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1156: 	for (u = 0; u < hn; u ++) {
	addq	$8, %r12	#, ivtmp.521
	cmpq	%rbx, 16(%rsp)	# u, %sfp
	jne	.L226	#,
.L224:
# inputs/bootstrap/source/falcon-fft.c:1165: }
	addq	$40, %rsp	#,
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
.LFE69:
	.size	falcon_poly_div_fft3, .-falcon_poly_div_fft3
	.globl	falcon_poly_divadj_fft3
	.type	falcon_poly_divadj_fft3, @function
falcon_poly_divadj_fft3:
.LFB70:
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
	movq	%rsi, 24(%rsp)	# tmp136, %sfp
# inputs/bootstrap/source/falcon-fft.c:1174: 	n = MKN(logn, full);
	leal	1(%rcx,%rcx), %eax	#, _3
	subl	%ecx, %edx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:1174: 	n = MKN(logn, full);
	movl	%edx, %ecx	# _4, tmp151
	salq	%cl, %rax	# tmp151, n_21
# inputs/bootstrap/source/falcon-fft.c:1176: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_21
	movq	%rax, 16(%rsp)	# hn, %sfp
	je	.L229	#,
	movq	%rdi, %r12	# tmp135, a
	leaq	0(,%rax,8), %rbp	#, ivtmp.532
# inputs/bootstrap/source/falcon-fft.c:1176: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L231:
# inputs/bootstrap/source/falcon-fft.c:1179: 		a_re = a[u];
	movq	(%r12,%rbx,8), %rax	# MEM[(fpr *)a_24(D) + u_54 * 8], a_re
	movq	%rax, (%rsp)	# a_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:1180: 		a_im = a[u + hn];
	movq	(%r12,%rbp), %r14	# MEM[(fpr *)a_24(D) + ivtmp.532_17 * 1], a_im
# inputs/bootstrap/source/falcon-fft.c:1181: 		b_re = b[u];
	movq	24(%rsp), %rdx	# %sfp, b
	movq	(%rdx,%rbx,8), %r13	# MEM[(const fpr *)b_27(D) + u_54 * 8], b_re
# inputs/bootstrap/source/falcon-fft.c:1182: 		b_im = fpr_neg(b[u + hn]);
	movq	(%rdx,%rbp), %r15	# MEM[(const fpr *)b_27(D) + ivtmp.532_17 * 1], _12
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rdi	#, x
	xorq	%r15, %rdi	# _12, x
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# x,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp139, %sfp
	movq	%r13, %rsi	# b_re,
	movq	%r13, %rdi	# b_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp140, _46
# inputs/bootstrap/source/falcon-fft.c:1183: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1183: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%rax, 8(%rsp)	# fpct_m, %sfp
	movq	%rax, %rsi	# fpct_m,
	movq	%r13, %rdi	# b_re,
	call	fpr_div@PLT	#
	movq	%rax, %r13	# tmp142, fpct_b_re
# inputs/bootstrap/source/falcon-fft.c:1183: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# _12,
	call	fpr_div@PLT	#
	movq	%rax, %r15	# tmp143, fpct_b_im
# inputs/bootstrap/source/falcon-fft.c:1183: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%rax, %rsi	# fpct_b_im,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, 8(%rsp)	# tmp144, %sfp
# inputs/bootstrap/source/falcon-fft.c:1183: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# fpct_b_re,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp145, _14
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	8(%rsp), %rsi	# %sfp, _13
	movabsq	$-9223372036854775808, %rcx	#, tmp159
	xorq	%rcx, %rsi	# tmp159, _13
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp146, %sfp
# inputs/bootstrap/source/falcon-fft.c:1183: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# fpct_b_re,
	movq	%r14, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r13	# tmp147, _15
# inputs/bootstrap/source/falcon-fft.c:1183: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r15, %rsi	# fpct_b_im,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp148, _16
# inputs/bootstrap/source/falcon-fft.c:1183: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# _15,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1183: 		FPC_DIV(a[u], a[u + hn], a_re, a_im, b_re, b_im);
	movq	8(%rsp), %rcx	# %sfp, _29
	movq	%rcx, (%r12,%rbx,8)	# _29, MEM[(fpr *)a_24(D) + u_54 * 8]
	movq	%rax, (%r12,%rbp)	# tmp149, MEM[(fpr *)a_24(D) + ivtmp.532_17 * 1]
# inputs/bootstrap/source/falcon-fft.c:1176: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1176: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbp	#, ivtmp.532
	cmpq	%rbx, 16(%rsp)	# u, %sfp
	jne	.L231	#,
.L229:
# inputs/bootstrap/source/falcon-fft.c:1185: }
	addq	$40, %rsp	#,
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
.LFE70:
	.size	falcon_poly_divadj_fft3, .-falcon_poly_divadj_fft3
	.globl	falcon_poly_invnorm2_fft3
	.type	falcon_poly_invnorm2_fft3, @function
falcon_poly_invnorm2_fft3:
.LFB71:
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
	movq	%rdi, 16(%rsp)	# tmp129, %sfp
	movq	%rsi, 24(%rsp)	# tmp130, %sfp
# inputs/bootstrap/source/falcon-fft.c:1195: 	n = MKN(logn, full);
	leal	1(%r8,%r8), %eax	#, _3
	subl	%r8d, %ecx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:1195: 	n = MKN(logn, full);
	salq	%cl, %rax	# _4, n_20
# inputs/bootstrap/source/falcon-fft.c:1197: 	for (u = 0; u < hn; u ++) {
	shrq	%rax	# n_20
	movq	%rax, 8(%rsp)	# hn, %sfp
	je	.L234	#,
	movq	%rdx, %r15	# tmp131, b
	leaq	0(,%rax,8), %rbp	#, ivtmp.544
# inputs/bootstrap/source/falcon-fft.c:1197: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L236:
# inputs/bootstrap/source/falcon-fft.c:1201: 		a_re = a[u];
	movq	24(%rsp), %rax	# %sfp, a
	movq	(%rax,%rbx,8), %r12	# MEM[(const fpr *)a_23(D) + u_47 * 8], a_re
# inputs/bootstrap/source/falcon-fft.c:1202: 		a_im = a[u + hn];
	movq	(%rax,%rbp), %r13	# MEM[(const fpr *)a_23(D) + ivtmp.544_16 * 1], a_im
# inputs/bootstrap/source/falcon-fft.c:1203: 		b_re = b[u];
	movq	(%r15,%rbx,8), %r14	# MEM[(const fpr *)b_26(D) + u_47 * 8], b_re
# inputs/bootstrap/source/falcon-fft.c:1204: 		b_im = b[u + hn];
	movq	(%r15,%rbp), %rdi	# MEM[(const fpr *)b_26(D) + ivtmp.544_16 * 1], b_im
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# b_im,
	call	fpr_mul@PLT	#
	movq	%rax, (%rsp)	# tmp134, %sfp
	movq	%r14, %rsi	# b_re,
	movq	%r14, %rdi	# b_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp135, _38
# inputs/bootstrap/source/falcon-fft.c:1205: 		d[u] = fpr_inv(fpr_add(
	movq	(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp136, _12
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%r13, %rsi	# a_im,
	movq	%r13, %rdi	# a_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r13	# tmp137, _37
	movq	%r12, %rsi	# a_re,
	movq	%r12, %rdi	# a_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp138, _36
# inputs/bootstrap/source/falcon-fft.c:1205: 		d[u] = fpr_inv(fpr_add(
	movq	%r13, %rsi	# _37,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp139, _13
# inputs/bootstrap/source/falcon-fft.c:1205: 		d[u] = fpr_inv(fpr_add(
	movq	%r14, %rsi	# _12,
	call	fpr_add@PLT	#
	movq	%rax, %rsi	# tmp140, _14
# inputs/bootstrap/source/fpr-emulated.h:192: 	return fpr_div(fpr_one, x);
	movabsq	$4607182418800017408, %rdi	#,
	call	fpr_div@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1205: 		d[u] = fpr_inv(fpr_add(
	movq	16(%rsp), %rdx	# %sfp, d
	movq	%rax, (%rdx,%rbx,8)	# tmp141, MEM[(fpr *)d_32(D) + u_47 * 8]
# inputs/bootstrap/source/falcon-fft.c:1197: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1197: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbp	#, ivtmp.544
	cmpq	%rbx, 8(%rsp)	# u, %sfp
	jne	.L236	#,
.L234:
# inputs/bootstrap/source/falcon-fft.c:1209: }
	addq	$40, %rsp	#,
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
.LFE71:
	.size	falcon_poly_invnorm2_fft3, .-falcon_poly_invnorm2_fft3
	.globl	falcon_poly_add_muladj_fft3
	.type	falcon_poly_add_muladj_fft3, @function
falcon_poly_add_muladj_fft3:
.LFB72:
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
	movq	%rdi, 48(%rsp)	# tmp150, %sfp
	movq	%rsi, 56(%rsp)	# tmp151, %sfp
	movq	%rdx, 64(%rsp)	# tmp152, %sfp
	movq	%rcx, 72(%rsp)	# tmp153, %sfp
	movq	%r8, 80(%rsp)	# tmp154, %sfp
	movl	160(%rsp), %eax	# full, full
# inputs/bootstrap/source/falcon-fft.c:1220: 	n = MKN(logn, full);
	leal	1(%rax,%rax), %edx	#, _3
	movl	%r9d, %ecx	# tmp155, tmp155
	subl	%eax, %ecx	# full, tmp155
# inputs/bootstrap/source/falcon-fft.c:1220: 	n = MKN(logn, full);
	salq	%cl, %rdx	# _4, n_32
# inputs/bootstrap/source/falcon-fft.c:1222: 	for (u = 0; u < hn; u ++) {
	shrq	%rdx	# hn
	je	.L239	#,
	leaq	0(,%rdx,8), %rbx	#, ivtmp.561
# inputs/bootstrap/source/falcon-fft.c:1222: 	for (u = 0; u < hn; u ++) {
	movl	$0, %r15d	#, u
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rbp	#, tmp144
	movq	%rdx, 88(%rsp)	# hn, %sfp
.L241:
# inputs/bootstrap/source/falcon-fft.c:1227: 		F_re = F[u];
	movq	56(%rsp), %rax	# %sfp, F
	movq	(%rax,%r15,8), %r12	# MEM[(const fpr *)F_35(D) + u_75 * 8], F_re
# inputs/bootstrap/source/falcon-fft.c:1228: 		F_im = F[u + hn];
	movq	(%rax,%rbx), %r13	# MEM[(const fpr *)F_35(D) + ivtmp.561_28 * 1], F_im
# inputs/bootstrap/source/falcon-fft.c:1229: 		G_re = G[u];
	movq	64(%rsp), %rax	# %sfp, G
	movq	(%rax,%r15,8), %rcx	# MEM[(const fpr *)G_38(D) + u_75 * 8], G_re
	movq	%rcx, (%rsp)	# G_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:1230: 		G_im = G[u + hn];
	movq	(%rax,%rbx), %r14	# MEM[(const fpr *)G_38(D) + ivtmp.561_28 * 1], G_im
	movq	%r14, 32(%rsp)	# G_im, %sfp
# inputs/bootstrap/source/falcon-fft.c:1231: 		f_re = f[u];
	movq	72(%rsp), %rax	# %sfp, f
	movq	(%rax,%r15,8), %r14	# MEM[(const fpr *)f_41(D) + u_75 * 8], f_re
# inputs/bootstrap/source/falcon-fft.c:1233: 		g_re = g[u];
	movq	80(%rsp), %rdx	# %sfp, g
	movq	(%rdx,%r15,8), %rsi	# MEM[(const fpr *)g_44(D) + u_75 * 8], g_re
	movq	%rsi, 8(%rsp)	# g_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:1234: 		g_im = g[u + hn];
	movq	(%rdx,%rbx), %rdx	# MEM[(const fpr *)g_44(D) + ivtmp.561_28 * 1], g_im
	movq	%rdx, 40(%rsp)	# g_im, %sfp
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movq	%rax, %rdx	# f, f
	movq	%rbp, %rax	# tmp144, x
	xorq	(%rdx,%rbx), %rax	# MEM[(const fpr *)f_41(D) + ivtmp.561_28 * 1], x
# inputs/bootstrap/source/falcon-fft.c:1236: 		FPC_MUL(a_re, a_im, F_re, F_im, f_re, fpr_neg(f_im));
	movq	%rax, 16(%rsp)	# x, %sfp
	movq	%rax, %rsi	# x,
	movq	%r13, %rdi	# F_im,
	call	fpr_mul@PLT	#
	movq	%rax, 24(%rsp)	# tmp156, %sfp
# inputs/bootstrap/source/falcon-fft.c:1236: 		FPC_MUL(a_re, a_im, F_re, F_im, f_re, fpr_neg(f_im));
	movq	%r14, %rsi	# f_re,
	movq	%r12, %rdi	# F_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp157, _17
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	24(%rsp), %r10	# %sfp, _16
	xorq	%rbp, %r10	# tmp144, _16
	movq	%r10, %rsi	# _16, y_68
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 24(%rsp)	# tmp158, %sfp
# inputs/bootstrap/source/falcon-fft.c:1236: 		FPC_MUL(a_re, a_im, F_re, F_im, f_re, fpr_neg(f_im));
	movq	%r14, %rsi	# f_re,
	movq	%r13, %rdi	# F_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r13	# tmp159, _18
# inputs/bootstrap/source/falcon-fft.c:1236: 		FPC_MUL(a_re, a_im, F_re, F_im, f_re, fpr_neg(f_im));
	movq	16(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# F_re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp160, _19
# inputs/bootstrap/source/falcon-fft.c:1236: 		FPC_MUL(a_re, a_im, F_re, F_im, f_re, fpr_neg(f_im));
	movq	%r13, %rsi	# _18,
	call	fpr_add@PLT	#
	movq	%rax, 16(%rsp)	# tmp161, %sfp
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movq	40(%rsp), %r13	# %sfp, g_im
	xorq	%rbp, %r13	# tmp144, g_im
# inputs/bootstrap/source/falcon-fft.c:1237: 		FPC_MUL(b_re, b_im, G_re, G_im, g_re, fpr_neg(g_im));
	movq	%r13, %rsi	# x,
	movq	32(%rsp), %r14	# %sfp, G_im
	movq	%r14, %rdi	# G_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp162, _20
# inputs/bootstrap/source/falcon-fft.c:1237: 		FPC_MUL(b_re, b_im, G_re, G_im, g_re, fpr_neg(g_im));
	movq	8(%rsp), %rsi	# %sfp,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp163, _21
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%rbp, %r12	# tmp144, _20
	movq	%r12, %rsi	# _20, y_54
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp164, _47
# inputs/bootstrap/source/falcon-fft.c:1237: 		FPC_MUL(b_re, b_im, G_re, G_im, g_re, fpr_neg(g_im));
	movq	8(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# G_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp165, _22
# inputs/bootstrap/source/falcon-fft.c:1237: 		FPC_MUL(b_re, b_im, G_re, G_im, g_re, fpr_neg(g_im));
	movq	%r13, %rsi	# x,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp166, _23
# inputs/bootstrap/source/falcon-fft.c:1237: 		FPC_MUL(b_re, b_im, G_re, G_im, g_re, fpr_neg(g_im));
	movq	%r14, %rsi	# _22,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp167, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:1238: 		d[u] = fpr_add(a_re, b_re);
	movq	%r12, %rsi	# _47,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1238: 		d[u] = fpr_add(a_re, b_re);
	movq	48(%rsp), %r14	# %sfp, d
	movq	%rax, (%r14,%r15,8)	# tmp168, MEM[(fpr *)d_61(D) + u_75 * 8]
# inputs/bootstrap/source/falcon-fft.c:1239: 		d[u + hn] = fpr_add(a_im, b_im);
	movq	%r13, %rsi	# fpct_d_im,
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1239: 		d[u + hn] = fpr_add(a_im, b_im);
	movq	%rax, (%r14,%rbx)	# tmp169, MEM[(fpr *)d_61(D) + ivtmp.561_28 * 1]
# inputs/bootstrap/source/falcon-fft.c:1222: 	for (u = 0; u < hn; u ++) {
	addq	$1, %r15	#, u
# inputs/bootstrap/source/falcon-fft.c:1222: 	for (u = 0; u < hn; u ++) {
	addq	$8, %rbx	#, ivtmp.561
	cmpq	%r15, 88(%rsp)	# u, %sfp
	jne	.L241	#,
.L239:
# inputs/bootstrap/source/falcon-fft.c:1241: }
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
.LFE72:
	.size	falcon_poly_add_muladj_fft3, .-falcon_poly_add_muladj_fft3
	.globl	falcon_poly_mul_autoadj_fft3
	.type	falcon_poly_mul_autoadj_fft3, @function
falcon_poly_mul_autoadj_fft3:
.LFB73:
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
# inputs/bootstrap/source/falcon-fft.c:1250: 	n = MKN(logn, full);
	leal	1(%rcx,%rcx), %r14d	#, _3
	subl	%ecx, %edx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:1250: 	n = MKN(logn, full);
	movl	%edx, %ecx	# _4, tmp134
	salq	%cl, %r14	# tmp134, n_21
# inputs/bootstrap/source/falcon-fft.c:1252: 	for (u = 0; u < hn; u ++) {
	shrq	%r14	# hn
	je	.L244	#,
	movq	%rdi, %rbp	# tmp127, a
	movq	%rsi, %r12	# tmp128, b
	leaq	(%rdi,%r14,8), %r13	#, _32
# inputs/bootstrap/source/falcon-fft.c:1252: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L246:
# inputs/bootstrap/source/falcon-fft.c:1253: 		a[u] = fpr_mul(a[u], b[u]);
	movq	(%r12,%rbx,8), %rsi	# MEM[(const fpr *)b_24(D) + u_33 * 8], MEM[(const fpr *)b_24(D) + u_33 * 8]
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_25(D) + u_33 * 8], MEM[(fpr *)a_25(D) + u_33 * 8]
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1253: 		a[u] = fpr_mul(a[u], b[u]);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp131, MEM[(fpr *)a_25(D) + u_33 * 8]
# inputs/bootstrap/source/falcon-fft.c:1254: 		a[u + hn] = fpr_mul(a[u + hn], b[u]);
	movq	(%r12,%rbx,8), %rsi	# MEM[(const fpr *)b_24(D) + u_33 * 8], MEM[(const fpr *)b_24(D) + u_33 * 8]
	movq	0(%r13,%rbx,8), %rdi	# MEM[(fpr *)_32 + u_33 * 8], MEM[(fpr *)_32 + u_33 * 8]
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1254: 		a[u + hn] = fpr_mul(a[u + hn], b[u]);
	movq	%rax, 0(%r13,%rbx,8)	# tmp132, MEM[(fpr *)_32 + u_33 * 8]
# inputs/bootstrap/source/falcon-fft.c:1252: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1252: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, %r14	# u, hn
	jne	.L246	#,
.L244:
# inputs/bootstrap/source/falcon-fft.c:1256: }
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
	.cfi_endproc
.LFE73:
	.size	falcon_poly_mul_autoadj_fft3, .-falcon_poly_mul_autoadj_fft3
	.globl	falcon_poly_div_autoadj_fft3
	.type	falcon_poly_div_autoadj_fft3, @function
falcon_poly_div_autoadj_fft3:
.LFB74:
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
# inputs/bootstrap/source/falcon-fft.c:1265: 	n = MKN(logn, full);
	leal	1(%rcx,%rcx), %r14d	#, _3
	subl	%ecx, %edx	# full, _4
# inputs/bootstrap/source/falcon-fft.c:1265: 	n = MKN(logn, full);
	movl	%edx, %ecx	# _4, tmp134
	salq	%cl, %r14	# tmp134, n_21
# inputs/bootstrap/source/falcon-fft.c:1267: 	for (u = 0; u < hn; u ++) {
	shrq	%r14	# hn
	je	.L249	#,
	movq	%rdi, %rbp	# tmp127, a
	movq	%rsi, %r12	# tmp128, b
	leaq	(%rdi,%r14,8), %r13	#, _32
# inputs/bootstrap/source/falcon-fft.c:1267: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebx	#, u
.L251:
# inputs/bootstrap/source/falcon-fft.c:1268: 		a[u] = fpr_div(a[u], b[u]);
	movq	(%r12,%rbx,8), %rsi	# MEM[(const fpr *)b_24(D) + u_33 * 8], MEM[(const fpr *)b_24(D) + u_33 * 8]
	movq	0(%rbp,%rbx,8), %rdi	# MEM[(fpr *)a_25(D) + u_33 * 8], MEM[(fpr *)a_25(D) + u_33 * 8]
	call	fpr_div@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1268: 		a[u] = fpr_div(a[u], b[u]);
	movq	%rax, 0(%rbp,%rbx,8)	# tmp131, MEM[(fpr *)a_25(D) + u_33 * 8]
# inputs/bootstrap/source/falcon-fft.c:1269: 		a[u + hn] = fpr_div(a[u + hn], b[u]);
	movq	(%r12,%rbx,8), %rsi	# MEM[(const fpr *)b_24(D) + u_33 * 8], MEM[(const fpr *)b_24(D) + u_33 * 8]
	movq	0(%r13,%rbx,8), %rdi	# MEM[(fpr *)_32 + u_33 * 8], MEM[(fpr *)_32 + u_33 * 8]
	call	fpr_div@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1269: 		a[u + hn] = fpr_div(a[u + hn], b[u]);
	movq	%rax, 0(%r13,%rbx,8)	# tmp132, MEM[(fpr *)_32 + u_33 * 8]
# inputs/bootstrap/source/falcon-fft.c:1267: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-fft.c:1267: 	for (u = 0; u < hn; u ++) {
	cmpq	%rbx, %r14	# u, hn
	jne	.L251	#,
.L249:
# inputs/bootstrap/source/falcon-fft.c:1271: }
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
	.cfi_endproc
.LFE74:
	.size	falcon_poly_div_autoadj_fft3, .-falcon_poly_div_autoadj_fft3
	.globl	falcon_poly_split_top_fft3
	.type	falcon_poly_split_top_fft3, @function
falcon_poly_split_top_fft3:
.LFB75:
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
	subq	$184, %rsp	#,
	.cfi_def_cfa_offset 240
	movq	%rdi, 144(%rsp)	# tmp268, %sfp
	movq	%rsi, 152(%rsp)	# tmp269, %sfp
	movq	%rdx, 160(%rsp)	# tmp270, %sfp
	movq	%rcx, %rax	# tmp271, f
# inputs/bootstrap/source/falcon-fft.c:1281: 	n = (size_t)3 << (logn - 1);
	leal	-1(%r8), %ecx	#, _1
# inputs/bootstrap/source/falcon-fft.c:1281: 	n = (size_t)3 << (logn - 1);
	movl	$3, %edx	#, tmp216
	salq	%cl, %rdx	# _1, n_75
# inputs/bootstrap/source/falcon-fft.c:1284: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	shrq	%rdx	# hn
	je	.L254	#,
	leal	-2(%r8), %esi	#, _2
	movq	%rax, 24(%rsp)	# f, %sfp
	leaq	(%rax,%rdx,8), %rax	#, ivtmp.588
	movq	%rax, 32(%rsp)	# ivtmp.588, %sfp
	movl	$8, %eax	#, tmp219
	movq	%rax, %rdi	# tmp219, _154
	movl	%r8d, %ecx	# logn, tmp347
	salq	%cl, %rdi	# tmp347, _154
	leaq	fpr_gm3_cubic(%rip), %rcx	#, tmp220
	addq	%rdi, %rcx	# _154, ivtmp.589
	movq	%rcx, 16(%rsp)	# ivtmp.589, %sfp
	movl	%esi, %ecx	# _2, tmp350
	salq	%cl, %rax	# tmp350, tmp219
	movq	%rax, 40(%rsp)	# tmp219, %sfp
# inputs/bootstrap/source/falcon-fft.c:1284: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	movq	$0, 48(%rsp)	#, %sfp
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r15	#, tmp222
# inputs/bootstrap/source/falcon-fft.c:1299: 		FPC_MUL(fB2r, fB2i, fBr, fBi, fpr_W2R, fpr_W2I);
	movq	%rdx, 168(%rsp)	# hn, %sfp
.L256:
# inputs/bootstrap/source/falcon-fft.c:1289: 		fAr = f[u];
	movq	24(%rsp), %rax	# %sfp, ivtmp.587
	movq	(%rax), %r12	# MEM[(const fpr *)_235], fAr
	movq	%r12, (%rsp)	# fAr, %sfp
# inputs/bootstrap/source/falcon-fft.c:1290: 		fAi = f[u + hn];
	movq	32(%rsp), %rdx	# %sfp, ivtmp.588
	movq	(%rdx), %r13	# MEM[(const fpr *)_238], fAi
	movq	%r13, 8(%rsp)	# fAi, %sfp
# inputs/bootstrap/source/falcon-fft.c:1291: 		fBr = f[u + 1];
	movq	8(%rax), %r12	# MEM[(const fpr *)_235 + 8B], fBr
# inputs/bootstrap/source/falcon-fft.c:1292: 		fBi = f[u + 1 + hn];
	movq	8(%rdx), %rbx	# MEM[(const fpr *)_238 + 8B], fBi
# inputs/bootstrap/source/falcon-fft.c:1293: 		fCr = f[u + 2];
	movq	16(%rax), %r13	# MEM[(const fpr *)_235 + 16B], fCr
# inputs/bootstrap/source/falcon-fft.c:1294: 		fCi = f[u + 2 + hn];
	movq	16(%rdx), %rbp	# MEM[(const fpr *)_238 + 16B], fCi
# inputs/bootstrap/source/falcon-fft.c:1296: 		xr = fpr_gm3_cubic[(v << 1) + ((size_t)1 << logn) + 0];
	movq	16(%rsp), %rdi	# %sfp, ivtmp.589
	movq	(%rdi), %rcx	# MEM[(long unsigned int *)_241], xr
	movq	%rcx, 56(%rsp)	# xr, %sfp
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movq	%r15, %r14	# tmp222, x
	xorq	8(%rdi), %r14	# MEM[(long unsigned int *)_241 + 8B], x
	movq	%r14, 136(%rsp)	# x, %sfp
# inputs/bootstrap/source/falcon-fft.c:1298: 		FPC_MUL(fB1r, fB1i, fBr, fBi, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%rbx, %rdi	# fBi,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp273, _25
# inputs/bootstrap/source/falcon-fft.c:1298: 		FPC_MUL(fB1r, fB1i, fBr, fBi, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r12, %rdi	# fBr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp274, _26
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r14, %rsi	# _25, _25
	xorq	%r15, %rsi	# tmp222, _25
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 128(%rsp)	# tmp275, %sfp
# inputs/bootstrap/source/falcon-fft.c:1298: 		FPC_MUL(fB1r, fB1i, fBr, fBi, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%rbx, %rdi	# fBi,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp276, _27
# inputs/bootstrap/source/falcon-fft.c:1298: 		FPC_MUL(fB1r, fB1i, fBr, fBi, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%r12, %rdi	# fBr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp277, _28
# inputs/bootstrap/source/falcon-fft.c:1298: 		FPC_MUL(fB1r, fB1i, fBr, fBi, fpr_W4R, fpr_W4I);
	movq	%r14, %rsi	# _27,
	call	fpr_add@PLT	#
	movq	%rax, 64(%rsp)	# tmp278, %sfp
# inputs/bootstrap/source/falcon-fft.c:1299: 		FPC_MUL(fB2r, fB2i, fBr, fBi, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%rbx, %rdi	# fBi,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp279, _29
# inputs/bootstrap/source/falcon-fft.c:1299: 		FPC_MUL(fB2r, fB2i, fBr, fBi, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r12, %rdi	# fBr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp280, _30
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r14, %rsi	# _29, _29
	xorq	%r15, %rsi	# tmp222, _29
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 120(%rsp)	# tmp281, %sfp
# inputs/bootstrap/source/falcon-fft.c:1299: 		FPC_MUL(fB2r, fB2i, fBr, fBi, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%rbx, %rdi	# fBi,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp282, _31
# inputs/bootstrap/source/falcon-fft.c:1299: 		FPC_MUL(fB2r, fB2i, fBr, fBi, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%r12, %rdi	# fBr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp283, _32
# inputs/bootstrap/source/falcon-fft.c:1299: 		FPC_MUL(fB2r, fB2i, fBr, fBi, fpr_W2R, fpr_W2I);
	movq	%r14, %rsi	# _31,
	call	fpr_add@PLT	#
	movq	%rax, 72(%rsp)	# tmp284, %sfp
# inputs/bootstrap/source/falcon-fft.c:1300: 		FPC_MUL(fC1r, fC1i, fCr, fCi, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%rbp, %rdi	# fCi,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp285, _33
# inputs/bootstrap/source/falcon-fft.c:1300: 		FPC_MUL(fC1r, fC1i, fCr, fCi, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r13, %rdi	# fCr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp286, _34
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r14, %rsi	# _33, _33
	xorq	%r15, %rsi	# tmp222, _33
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 112(%rsp)	# tmp287, %sfp
# inputs/bootstrap/source/falcon-fft.c:1300: 		FPC_MUL(fC1r, fC1i, fCr, fCi, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%rbp, %rdi	# fCi,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp288, _35
# inputs/bootstrap/source/falcon-fft.c:1300: 		FPC_MUL(fC1r, fC1i, fCr, fCi, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%r13, %rdi	# fCr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp289, _36
# inputs/bootstrap/source/falcon-fft.c:1300: 		FPC_MUL(fC1r, fC1i, fCr, fCi, fpr_W4R, fpr_W4I);
	movq	%r14, %rsi	# _35,
	call	fpr_add@PLT	#
	movq	%rax, 80(%rsp)	# tmp290, %sfp
# inputs/bootstrap/source/falcon-fft.c:1301: 		FPC_MUL(fC2r, fC2i, fCr, fCi, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%rbp, %rdi	# fCi,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp291, _37
# inputs/bootstrap/source/falcon-fft.c:1301: 		FPC_MUL(fC2r, fC2i, fCr, fCi, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r13, %rdi	# fCr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp292, _38
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r14, %r9	# _37, _37
	xorq	%r15, %r9	# tmp222, _37
	movq	%r9, %rsi	# _37, y_187
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 104(%rsp)	# tmp293, %sfp
# inputs/bootstrap/source/falcon-fft.c:1301: 		FPC_MUL(fC2r, fC2i, fCr, fCi, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%rbp, %rdi	# fCi,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp294, _39
# inputs/bootstrap/source/falcon-fft.c:1301: 		FPC_MUL(fC2r, fC2i, fCr, fCi, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%r13, %rdi	# fCr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp295, _40
# inputs/bootstrap/source/falcon-fft.c:1301: 		FPC_MUL(fC2r, fC2i, fCr, fCi, fpr_W2R, fpr_W2I);
	movq	%r14, %rsi	# _39,
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp296, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:1303: 		FPC_ADD(fBr, fBi, fBr, fBi, fCr, fCi);
	movq	%r13, %rsi	# fCr,
	movq	%r12, %rdi	# fBr,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp297, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1303: 		FPC_ADD(fBr, fBi, fBr, fBi, fCr, fCi);
	movq	%rbp, %rsi	# fCi,
	movq	%rbx, %rdi	# fBi,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp298, fpct_im
# inputs/bootstrap/source/falcon-fft.c:1304: 		FPC_ADD(t0r, t0i, fAr, fAi, fBr, fBi);
	movq	%r12, %rsi	# fpct_re,
	movq	(%rsp), %r12	# %sfp, fAr
	movq	%r12, %rdi	# fAr,
	call	fpr_add@PLT	#
	movq	%rax, 88(%rsp)	# tmp299, %sfp
# inputs/bootstrap/source/falcon-fft.c:1304: 		FPC_ADD(t0r, t0i, fAr, fAi, fBr, fBi);
	movq	%rbx, %rsi	# fpct_im,
	movq	8(%rsp), %r13	# %sfp, fAi
	movq	%r13, %rdi	# fAi,
	call	fpr_add@PLT	#
	movq	%rax, 96(%rsp)	# tmp300, %sfp
# inputs/bootstrap/source/falcon-fft.c:1306: 		FPC_ADD(fB1r, fB1i, fB1r, fB1i, fC2r, fC2i);
	movq	104(%rsp), %rsi	# %sfp,
	movq	128(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp301, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1306: 		FPC_ADD(fB1r, fB1i, fB1r, fB1i, fC2r, fC2i);
	movq	%r14, %rsi	# fpct_d_im,
	movq	64(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp302, fpct_im
# inputs/bootstrap/source/falcon-fft.c:1307: 		FPC_ADD(fB1r, fB1i, fB1r, fB1i, fAr, fAi);
	movq	%r12, (%rsp)	# fAr, %sfp
	movq	%r12, %rsi	# fAr,
	movq	%rbp, %rdi	# fpct_re,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp303, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1307: 		FPC_ADD(fB1r, fB1i, fB1r, fB1i, fAr, fAi);
	movq	%r13, 8(%rsp)	# fAi, %sfp
	movq	%r13, %rsi	# fAi,
	movq	%rbx, %rdi	# fpct_im,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp304, fpct_im
# inputs/bootstrap/source/falcon-fft.c:1308: 		FPC_MUL(t1r, t1i, xr, xi, fB1r, fB1i);
	movq	%rax, %rsi	# fpct_im,
	movq	136(%rsp), %r14	# %sfp, x
	movq	%r14, %rdi	# x,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp305, _41
# inputs/bootstrap/source/falcon-fft.c:1308: 		FPC_MUL(t1r, t1i, xr, xi, fB1r, fB1i);
	movq	%r12, %rsi	# fpct_re,
	movq	56(%rsp), %r13	# %sfp, xr
	movq	%r13, %rdi	# xr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp306, _42
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%r15, %rbx	# tmp222, _41
	movq	%rbx, %rsi	# _41, y_185
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 64(%rsp)	# tmp307, %sfp
# inputs/bootstrap/source/falcon-fft.c:1308: 		FPC_MUL(t1r, t1i, xr, xi, fB1r, fB1i);
	movq	%r12, %rsi	# fpct_re,
	movq	%r14, %rdi	# x,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp308, _43
# inputs/bootstrap/source/falcon-fft.c:1308: 		FPC_MUL(t1r, t1i, xr, xi, fB1r, fB1i);
	movq	%rbp, %rsi	# fpct_im,
	movq	%r13, %rdi	# xr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp309, _44
# inputs/bootstrap/source/falcon-fft.c:1308: 		FPC_MUL(t1r, t1i, xr, xi, fB1r, fB1i);
	movq	%rbx, %rsi	# _43,
	call	fpr_add@PLT	#
	movq	%rax, 56(%rsp)	# tmp310, %sfp
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%r14, %rsi	# x,
	movq	%r14, %rdi	# x,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp311, _184
	movq	%r13, %rsi	# xr,
	movq	%r13, %rdi	# xr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp312, _183
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%r15, %rbx	# tmp222, _184
	movq	%rbx, %rsi	# _184, y_181
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp313, _182
# inputs/bootstrap/source/falcon-fft.c:1310: 		FPC_SQR(xr, xi, xr, xi);
	movq	%r14, %rsi	# x,
	movq	%r13, %rdi	# xr,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	movq	%rax, %rbx	# _45, _173
	shrq	$52, %rbx	#, _173
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	andl	$2047, %ebx	#, _175
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addl	$2047, %ebx	#, _176
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrl	$11, %ebx	#, _177
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	salq	$52, %rbx	#, _179
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addq	%rax, %rbx	# _45, x
# inputs/bootstrap/source/falcon-fft.c:1311: 		FPC_ADD(fB2r, fB2i, fB2r, fB2i, fC1r, fC1i);
	movq	112(%rsp), %rsi	# %sfp,
	movq	120(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp315, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1311: 		FPC_ADD(fB2r, fB2i, fB2r, fB2i, fC1r, fC1i);
	movq	80(%rsp), %rsi	# %sfp,
	movq	72(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp316, fpct_im
# inputs/bootstrap/source/falcon-fft.c:1312: 		FPC_ADD(fB2r, fB2i, fB2r, fB2i, fAr, fAi);
	movq	(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# fpct_re,
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp317, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1312: 		FPC_ADD(fB2r, fB2i, fB2r, fB2i, fAr, fAi);
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# fpct_im,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp318, fpct_im
# inputs/bootstrap/source/falcon-fft.c:1313: 		FPC_MUL(t2r, t2i, xr, xi, fB2r, fB2i);
	movq	%rax, %rsi	# fpct_im,
	movq	%rbx, %rdi	# x,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp319, _46
# inputs/bootstrap/source/falcon-fft.c:1313: 		FPC_MUL(t2r, t2i, xr, xi, fB2r, fB2i);
	movq	%r14, %rsi	# fpct_re,
	movq	%r12, %rdi	# _182,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp320, _47
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%rbp, %rsi	# _46, _46
	xorq	%r15, %rsi	# tmp222, _46
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, (%rsp)	# tmp321, %sfp
# inputs/bootstrap/source/falcon-fft.c:1313: 		FPC_MUL(t2r, t2i, xr, xi, fB2r, fB2i);
	movq	%r14, %rsi	# fpct_re,
	movq	%rbx, %rdi	# x,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp322, _48
# inputs/bootstrap/source/falcon-fft.c:1313: 		FPC_MUL(t2r, t2i, xr, xi, fB2r, fB2i);
	movq	%r13, %rsi	# fpct_im,
	movq	%r12, %rdi	# _182,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp323, _49
# inputs/bootstrap/source/falcon-fft.c:1313: 		FPC_MUL(t2r, t2i, xr, xi, fB2r, fB2i);
	movq	%rbx, %rsi	# _48,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp324, fpct_d_im
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$3, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp325, _215
# inputs/bootstrap/source/fpr-emulated.h:95: 	return fpr_div(fpr_one, fpr_of(i));
	movabsq	$4607182418800017408, %rbx	#, tmp259
	movq	%rbx, %rdi	# tmp259,
	call	fpr_div@PLT	#
	movq	%rax, %rsi	# tmp326, _216
# inputs/bootstrap/source/falcon-fft.c:1315: 		f0[v] = fpr_mul(t0r, fpr_inverse_of(3));
	movq	88(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1315: 		f0[v] = fpr_mul(t0r, fpr_inverse_of(3));
	movq	144(%rsp), %r13	# %sfp, f0
	movq	48(%rsp), %r14	# %sfp, v
	movq	%rax, 0(%r13,%r14,8)	# tmp327, MEM[(fpr *)f0_151(D) + v_222 * 8]
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$3, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp328, _213
# inputs/bootstrap/source/fpr-emulated.h:95: 	return fpr_div(fpr_one, fpr_of(i));
	movq	%rbx, %rdi	# tmp259,
	call	fpr_div@PLT	#
	movq	%rax, %rsi	# tmp329, _214
# inputs/bootstrap/source/falcon-fft.c:1316: 		f0[v + qn] = fpr_mul(t0i, fpr_inverse_of(3));
	movq	96(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1316: 		f0[v + qn] = fpr_mul(t0i, fpr_inverse_of(3));
	movq	40(%rsp), %r12	# %sfp, ivtmp.597
	movq	%rax, 0(%r13,%r12)	# tmp330, MEM[(fpr *)f0_151(D) + ivtmp.597_161 * 1]
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$3, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp331, _211
# inputs/bootstrap/source/fpr-emulated.h:95: 	return fpr_div(fpr_one, fpr_of(i));
	movq	%rbx, %rdi	# tmp259,
	call	fpr_div@PLT	#
	movq	%rax, %rsi	# tmp332, _212
# inputs/bootstrap/source/falcon-fft.c:1317: 		f1[v] = fpr_mul(t1r, fpr_inverse_of(3));
	movq	64(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1317: 		f1[v] = fpr_mul(t1r, fpr_inverse_of(3));
	movq	152(%rsp), %r13	# %sfp, f1
	movq	%rax, 0(%r13,%r14,8)	# tmp333, MEM[(fpr *)f1_158(D) + v_222 * 8]
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$3, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp334, _209
# inputs/bootstrap/source/fpr-emulated.h:95: 	return fpr_div(fpr_one, fpr_of(i));
	movq	%rbx, %rdi	# tmp259,
	call	fpr_div@PLT	#
	movq	%rax, %rsi	# tmp335, _210
# inputs/bootstrap/source/falcon-fft.c:1318: 		f1[v + qn] = fpr_mul(t1i, fpr_inverse_of(3));
	movq	56(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1318: 		f1[v + qn] = fpr_mul(t1i, fpr_inverse_of(3));
	movq	%rax, 0(%r13,%r12)	# tmp336, MEM[(fpr *)f1_158(D) + ivtmp.597_161 * 1]
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$3, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp337, _207
# inputs/bootstrap/source/fpr-emulated.h:95: 	return fpr_div(fpr_one, fpr_of(i));
	movq	%rbx, %rdi	# tmp259,
	call	fpr_div@PLT	#
	movq	%rax, %rsi	# tmp338, _208
# inputs/bootstrap/source/falcon-fft.c:1319: 		f2[v] = fpr_mul(t2r, fpr_inverse_of(3));
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1319: 		f2[v] = fpr_mul(t2r, fpr_inverse_of(3));
	movq	160(%rsp), %r13	# %sfp, f2
	movq	%rax, 0(%r13,%r14,8)	# tmp339, MEM[(fpr *)f2_165(D) + v_222 * 8]
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$3, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp340, _205
# inputs/bootstrap/source/fpr-emulated.h:95: 	return fpr_div(fpr_one, fpr_of(i));
	movq	%rbx, %rdi	# tmp259,
	call	fpr_div@PLT	#
	movq	%rax, %rsi	# tmp341, _206
# inputs/bootstrap/source/falcon-fft.c:1320: 		f2[v + qn] = fpr_mul(t2i, fpr_inverse_of(3));
	movq	%rbp, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1320: 		f2[v + qn] = fpr_mul(t2i, fpr_inverse_of(3));
	movq	%rax, 0(%r13,%r12)	# tmp342, MEM[(fpr *)f2_165(D) + ivtmp.597_161 * 1]
# inputs/bootstrap/source/falcon-fft.c:1284: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	addq	$1, %r14	#, v
	movq	%r14, 48(%rsp)	# v, %sfp
# inputs/bootstrap/source/falcon-fft.c:1284: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	addq	$24, 24(%rsp)	#, %sfp
	addq	$24, 32(%rsp)	#, %sfp
	addq	$16, 16(%rsp)	#, %sfp
	addq	$8, %r12	#, ivtmp.597
	movq	%r12, 40(%rsp)	# ivtmp.597, %sfp
	leaq	(%r14,%r14,2), %rax	#, u_243
	movq	168(%rsp), %rcx	# %sfp, hn
	cmpq	%rcx, %rax	# hn, u_243
	jb	.L256	#,
.L254:
# inputs/bootstrap/source/falcon-fft.c:1322: }
	addq	$184, %rsp	#,
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
.LFE75:
	.size	falcon_poly_split_top_fft3, .-falcon_poly_split_top_fft3
	.globl	falcon_poly_split_deep_fft3
	.type	falcon_poly_split_deep_fft3, @function
falcon_poly_split_deep_fft3:
.LFB76:
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
	subq	$72, %rsp	#,
	.cfi_def_cfa_offset 128
	movq	%rdi, 32(%rsp)	# tmp234, %sfp
	movq	%rsi, 40(%rsp)	# tmp235, %sfp
	movq	%rdx, %rbp	# tmp236, f
# inputs/bootstrap/source/falcon-fft.c:1334: 	if (logn == 1) {
	cmpl	$1, %ecx	#, logn
	je	.L265	#,
# inputs/bootstrap/source/falcon-fft.c:1345: 	n = (size_t)1 << logn;
	movl	$1, %esi	#, tmp195
	salq	%cl, %rsi	# logn, n
# inputs/bootstrap/source/falcon-fft.c:1346: 	hn = n >> 1;
	movq	%rsi, %rax	# n, hn
	shrq	%rax	# hn
	movq	%rax, 48(%rsp)	# hn, %sfp
# inputs/bootstrap/source/falcon-fft.c:1349: 	m = (size_t)1 << (logn - 1);
	subl	$1, %ecx	#, _1
# inputs/bootstrap/source/falcon-fft.c:1350: 	for (u = 0; u < qn; u ++) {
	shrq	$2, %rsi	#, n
	je	.L259	#,
	movl	$16, %eax	#, tmp197
	salq	%cl, %rax	# _1, _131
	leaq	fpr_gm3_square(%rip), %rdx	#, tmp198
	addq	%rdx, %rax	# tmp198, ivtmp.608
	movq	%rax, (%rsp)	# ivtmp.608, %sfp
	leaq	0(,%rsi,8), %rax	#, ivtmp.619
	movq	%rax, 8(%rsp)	# ivtmp.619, %sfp
# inputs/bootstrap/source/falcon-fft.c:1350: 	for (u = 0; u < qn; u ++) {
	movl	$0, %r14d	#, u
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%rsi, 56(%rsp)	# qn, %sfp
.L262:
# inputs/bootstrap/source/falcon-fft.c:1354: 		a_re = f[(u << 1) + 0];
	movq	0(%rbp), %r15	# MEM[(const fpr *)_136], a_re
# inputs/bootstrap/source/falcon-fft.c:1355: 		a_im = f[(u << 1) + 0 + hn];
	movq	48(%rsp), %rax	# %sfp, hn
	movq	0(%rbp,%rax,8), %rcx	# MEM[(const fpr *)_136 + hn_33 * 8], a_im
	movq	%rcx, 16(%rsp)	# a_im, %sfp
# inputs/bootstrap/source/falcon-fft.c:1356: 		b_re = f[(u << 1) + 1];
	movq	8(%rbp), %r13	# MEM[(const fpr *)_136 + 8B], b_re
# inputs/bootstrap/source/falcon-fft.c:1357: 		b_im = f[(u << 1) + 1 + hn];
	movq	8(%rbp,%rax,8), %r12	# MEM[(const fpr *)_136 + 8B + hn_33 * 8], b_im
# inputs/bootstrap/source/falcon-fft.c:1359: 		FPC_ADD(t_re, t_im, a_re, a_im, b_re, b_im);
	movq	%r13, %rsi	# b_re,
	movq	%r15, %rdi	# a_re,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp240, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1359: 		FPC_ADD(t_re, t_im, a_re, a_im, b_re, b_im);
	movq	%r12, %rsi	# b_im,
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rdx	#, tmp241
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	movabsq	$-4503599627370496, %rcx	#, tmp264
	addq	%rcx, %rbx	# tmp264, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rbx, %rax	# x, _112
	shrq	$52, %rax	#, _112
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %eax	#, _114
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %eax	#, _115
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %eax	#, t_116
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%eax, %eax	# t_116, _117
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rax	#, _118
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rax, %rbx	# _118, tmp205
	movq	32(%rsp), %rsi	# %sfp, f0
	movq	%rbx, (%rsi,%r14,8)	# tmp205, MEM[(fpr *)f0_46(D) + u_126 * 8]
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	leaq	(%rdx,%rcx), %rax	#, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rax, %rdx	# x, _103
	shrq	$52, %rdx	#, _103
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %edx	#, _105
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %edx	#, _106
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %edx	#, t_107
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%edx, %edx	# t_107, _108
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rdx	#, _109
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rdx, %rax	# _109, tmp212
	movq	8(%rsp), %rbx	# %sfp, ivtmp.619
	movq	%rax, (%rsi,%rbx)	# tmp212, MEM[(fpr *)f0_46(D) + ivtmp.619_133 * 1]
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_100
	xorq	%r13, %rsi	# b_re, y_100
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	%r15, %rdi	# a_re,
	call	fpr_add@PLT	#
	movq	%rax, 24(%rsp)	# tmp242, %sfp
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_98
	xorq	%r12, %rsi	# b_im, y_98
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp243, _99
# inputs/bootstrap/source/falcon-fft.c:1364: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	(%rsp), %rsi	# %sfp, ivtmp.608
	movq	(%rsi), %r15	# MEM[(long unsigned int *)_138], fpct_b_re
# inputs/bootstrap/source/fpr-emulated.h:161: 	x ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r13	#, x
	xorq	8(%rsi), %r13	# MEM[(long unsigned int *)_138 + 8B], x
# inputs/bootstrap/source/falcon-fft.c:1364: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	%r13, %rsi	# x,
	movq	%rax, %rdi	# _99,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp244, _22
# inputs/bootstrap/source/falcon-fft.c:1364: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	%r15, %rsi	# fpct_b_re,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp245, _23
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rax	#, y_95
	xorq	%rbx, %rax	# _22, y_95
	movq	%rax, %rsi	# y_95, y_95
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp246, _96
# inputs/bootstrap/source/falcon-fft.c:1364: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	%r15, %rsi	# fpct_b_re,
	movq	%r12, %rdi	# _99,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp247, _24
# inputs/bootstrap/source/falcon-fft.c:1364: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	%r13, %rsi	# x,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp248, _25
# inputs/bootstrap/source/falcon-fft.c:1364: 		FPC_MUL(t_re, t_im, t_re, t_im,
	movq	%r12, %rsi	# _24,
	call	fpr_add@PLT	#
	movq	%rax, %rdx	#, tmp249
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	movabsq	$-4503599627370496, %rcx	#, tmp277
	addq	%rcx, %rbx	# tmp277, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rbx, %rax	# x, _87
	shrq	$52, %rax	#, _87
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %eax	#, _89
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %eax	#, _90
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %eax	#, t_91
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%eax, %eax	# t_91, _92
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rax	#, _93
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rax, %rbx	# _93, tmp226
	movq	40(%rsp), %r9	# %sfp, f1
	movq	%rbx, (%r9,%r14,8)	# tmp226, MEM[(fpr *)f1_59(D) + u_126 * 8]
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	leaq	(%rdx,%rcx), %rax	#, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rax, %rdx	# x, _78
	shrq	$52, %rdx	#, _78
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %edx	#, _80
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %edx	#, _81
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %edx	#, t_82
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%edx, %edx	# t_82, _83
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rdx	#, _84
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rdx, %rax	# _84, tmp233
	movq	8(%rsp), %rdi	# %sfp, ivtmp.619
	movq	%rax, (%r9,%rdi)	# tmp233, MEM[(fpr *)f1_59(D) + ivtmp.619_133 * 1]
# inputs/bootstrap/source/falcon-fft.c:1350: 	for (u = 0; u < qn; u ++) {
	addq	$1, %r14	#, u
# inputs/bootstrap/source/falcon-fft.c:1350: 	for (u = 0; u < qn; u ++) {
	addq	$16, %rbp	#, ivtmp.604
	addq	$16, (%rsp)	#, %sfp
	addq	$8, %rdi	#, ivtmp.619
	movq	%rdi, 8(%rsp)	# ivtmp.619, %sfp
	cmpq	%r14, 56(%rsp)	# u, %sfp
	jne	.L262	#,
.L259:
# inputs/bootstrap/source/falcon-fft.c:1370: }
	addq	$72, %rsp	#,
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
.L265:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-fft.c:1337: 		re = f[0];
	movq	(%rdx), %rbx	# *f_37(D), re
# inputs/bootstrap/source/falcon-fft.c:1339: 		xx = fpr_mul(fpr_IW1I, im);
	movq	8(%rdx), %rsi	# MEM[(const fpr *)f_37(D) + 8B], MEM[(const fpr *)f_37(D) + 8B]
	movabsq	$4607879128087016220, %rdi	#, tmp185
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1340: 		*f1 = xx;
	movq	40(%rsp), %rcx	# %sfp, f1
	movq	%rax, (%rcx)	# xx, *f1_59(D)
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	movabsq	$-4503599627370496, %rdx	#, tmp186
	leaq	(%rax,%rdx), %rsi	#, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rsi, %rax	# x, _49
	shrq	$52, %rax	#, _49
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %eax	#, _70
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %eax	#, _72
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %eax	#, t_73
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%eax, %eax	# t_73, _74
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rax	#, _75
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rax, %rsi	# _75, x_76
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	btcq	$63, %rsi	#, y_62
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	%rbx, %rdi	# re,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1341: 		*f0 = fpr_sub(re, fpr_half(xx));
	movq	32(%rsp), %rbx	# %sfp, f0
	movq	%rax, (%rbx)	# tmp239, *f0_46(D)
# inputs/bootstrap/source/falcon-fft.c:1342: 		return;
	jmp	.L259	#
	.cfi_endproc
.LFE76:
	.size	falcon_poly_split_deep_fft3, .-falcon_poly_split_deep_fft3
	.globl	falcon_poly_merge_top_fft3
	.type	falcon_poly_merge_top_fft3, @function
falcon_poly_merge_top_fft3:
.LFB77:
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
	subq	$152, %rsp	#,
	.cfi_def_cfa_offset 208
	movq	%rsi, 112(%rsp)	# tmp243, %sfp
	movq	%rdx, 120(%rsp)	# tmp244, %sfp
	movq	%rcx, 128(%rsp)	# tmp245, %sfp
# inputs/bootstrap/source/falcon-fft.c:1380: 	n = (size_t)3 << (logn - 1);
	leal	-1(%r8), %ecx	#, _1
# inputs/bootstrap/source/falcon-fft.c:1380: 	n = (size_t)3 << (logn - 1);
	movl	$3, %esi	#, tmp197
	salq	%cl, %rsi	# _1, n_62
# inputs/bootstrap/source/falcon-fft.c:1383: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	shrq	%rsi	# n_62
	je	.L266	#,
	movq	%rdi, %rax	# tmp242, f
	leal	-2(%r8), %edi	#, _2
	movl	$8, %edx	#, tmp199
	movq	%rdx, %rbx	# tmp199, _181
	movl	%r8d, %ecx	# logn, tmp304
	salq	%cl, %rbx	# tmp304, _181
	leaq	fpr_gm3_cubic(%rip), %rcx	#, tmp200
	addq	%rbx, %rcx	# _181, ivtmp.634
	movq	%rcx, 16(%rsp)	# ivtmp.634, %sfp
	movq	%rax, 48(%rsp)	# f, %sfp
	leaq	(%rax,%rsi,8), %rax	#, ivtmp.636
	movq	%rax, 72(%rsp)	# ivtmp.636, %sfp
	movl	%edi, %ecx	# _2, tmp308
	salq	%cl, %rdx	# tmp308, tmp199
	movq	%rdx, 24(%rsp)	# tmp199, %sfp
# inputs/bootstrap/source/falcon-fft.c:1383: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	movl	$0, %r13d	#, v
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r14	#, tmp204
# inputs/bootstrap/source/falcon-fft.c:1400: 		FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movq	%rsi, 136(%rsp)	# hn, %sfp
	movq	%r13, %r15	# v, v
.L268:
# inputs/bootstrap/source/falcon-fft.c:1389: 		fAr = f0[v];
	movq	112(%rsp), %rcx	# %sfp, f0
	movq	(%rcx,%r15,8), %rax	# MEM[(const fpr *)f0_66(D) + v_184 * 8], fAr
	movq	%rax, 32(%rsp)	# fAr, %sfp
# inputs/bootstrap/source/falcon-fft.c:1390: 		fAi = f0[v + qn];
	movq	24(%rsp), %rax	# %sfp, ivtmp.638
	movq	(%rcx,%rax), %rcx	# MEM[(const fpr *)f0_66(D) + ivtmp.638_195 * 1], fAi
	movq	%rcx, 40(%rsp)	# fAi, %sfp
# inputs/bootstrap/source/falcon-fft.c:1391: 		fBr = f1[v];
	movq	120(%rsp), %rdx	# %sfp, f1
	movq	(%rdx,%r15,8), %r13	# MEM[(const fpr *)f1_69(D) + v_184 * 8], fBr
# inputs/bootstrap/source/falcon-fft.c:1392: 		fBi = f1[v + qn];
	movq	(%rdx,%rax), %r12	# MEM[(const fpr *)f1_69(D) + ivtmp.638_195 * 1], fBi
# inputs/bootstrap/source/falcon-fft.c:1393: 		fCr = f2[v];
	movq	128(%rsp), %rdx	# %sfp, f2
	movq	(%rdx,%r15,8), %rbx	# MEM[(const fpr *)f2_72(D) + v_184 * 8], fCr
	movq	%rbx, 56(%rsp)	# fCr, %sfp
# inputs/bootstrap/source/falcon-fft.c:1394: 		fCi = f2[v + qn];
	movq	(%rdx,%rax), %rdx	# MEM[(const fpr *)f2_72(D) + ivtmp.638_195 * 1], fCi
	movq	%rdx, 64(%rsp)	# fCi, %sfp
# inputs/bootstrap/source/falcon-fft.c:1396: 		xr = fpr_gm3_cubic[(v << 1) + ((size_t)1 << logn) + 0];
	movq	16(%rsp), %rdx	# %sfp, ivtmp.634
	movq	(%rdx), %rbx	# MEM[(long unsigned int *)_198], xr
# inputs/bootstrap/source/falcon-fft.c:1397: 		xi = fpr_gm3_cubic[(v << 1) + ((size_t)1 << logn) + 1];
	movq	8(%rdx), %rbp	# MEM[(long unsigned int *)_198 + 8B], xi
# inputs/bootstrap/source/falcon-fft.c:1398: 		FPC_MUL(fB0r, fB0i, fBr, fBi, xr, xi);
	movq	%rbp, %rsi	# xi,
	movq	%r12, %rdi	# fBi,
	call	fpr_mul@PLT	#
	movq	%rax, (%rsp)	# tmp247, %sfp
# inputs/bootstrap/source/falcon-fft.c:1398: 		FPC_MUL(fB0r, fB0i, fBr, fBi, xr, xi);
	movq	%rbx, %rsi	# xr,
	movq	%r13, %rdi	# fBr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp248, _17
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	(%rsp), %rsi	# %sfp, _16
	xorq	%r14, %rsi	# tmp204, _16
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp249, %sfp
# inputs/bootstrap/source/falcon-fft.c:1398: 		FPC_MUL(fB0r, fB0i, fBr, fBi, xr, xi);
	movq	%rbx, %rsi	# xr,
	movq	%r12, %rdi	# fBi,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp250, _18
# inputs/bootstrap/source/falcon-fft.c:1398: 		FPC_MUL(fB0r, fB0i, fBr, fBi, xr, xi);
	movq	%rbp, %rsi	# xi,
	movq	%r13, %rdi	# fBr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp251, _19
# inputs/bootstrap/source/falcon-fft.c:1398: 		FPC_MUL(fB0r, fB0i, fBr, fBi, xr, xi);
	movq	%r12, %rsi	# _18,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1399: 		FPC_MUL(fB1r, fB1i, fB0r, fB0i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%rax, (%rsp)	# fpct_d_im, %sfp
	movq	%rax, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp253, _20
# inputs/bootstrap/source/falcon-fft.c:1399: 		FPC_MUL(fB1r, fB1i, fB0r, fB0i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	8(%rsp), %r13	# %sfp, _170
	movq	%r13, %rdi	# _170,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp254, _21
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r12, %rsi	# _20, _20
	xorq	%r14, %rsi	# tmp204, _20
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 104(%rsp)	# tmp255, %sfp
# inputs/bootstrap/source/falcon-fft.c:1399: 		FPC_MUL(fB1r, fB1i, fB0r, fB0i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp256, _22
# inputs/bootstrap/source/falcon-fft.c:1399: 		FPC_MUL(fB1r, fB1i, fB0r, fB0i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%r13, %rdi	# _170,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp257, _23
# inputs/bootstrap/source/falcon-fft.c:1399: 		FPC_MUL(fB1r, fB1i, fB0r, fB0i, fpr_W2R, fpr_W2I);
	movq	%r12, %rsi	# _22,
	call	fpr_add@PLT	#
	movq	%rax, 80(%rsp)	# tmp258, %sfp
# inputs/bootstrap/source/falcon-fft.c:1400: 		FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp259, _24
# inputs/bootstrap/source/falcon-fft.c:1400: 		FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r13, %rdi	# _170,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp260, _25
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r12, %rsi	# _24, _24
	xorq	%r14, %rsi	# tmp204, _24
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 96(%rsp)	# tmp261, %sfp
# inputs/bootstrap/source/falcon-fft.c:1400: 		FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp262, _26
# inputs/bootstrap/source/falcon-fft.c:1400: 		FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%r13, 8(%rsp)	# _170, %sfp
	movq	%r13, %rdi	# _170,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp263, _27
# inputs/bootstrap/source/falcon-fft.c:1400: 		FPC_MUL(fB2r, fB2i, fB0r, fB0i, fpr_W4R, fpr_W4I);
	movq	%r12, %rsi	# _26,
	call	fpr_add@PLT	#
	movq	%rax, 88(%rsp)	# tmp264, %sfp
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rbp, %rsi	# xi,
	movq	%rbp, %rdi	# xi,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp265, _164
	movq	%rbx, %rsi	# xr,
	movq	%rbx, %rdi	# xr,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp266, _163
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r12, %rsi	# _164, _164
	xorq	%r14, %rsi	# tmp204, _164
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp267, _162
# inputs/bootstrap/source/falcon-fft.c:1401: 		FPC_SQR(xr, xi, xr, xi);
	movq	%rbp, %rsi	# xi,
	movq	%rbx, %rdi	# xr,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	movq	%rax, %rbx	# _28, _153
	shrq	$52, %rbx	#, _153
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	andl	$2047, %ebx	#, _155
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addl	$2047, %ebx	#, _156
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrl	$11, %ebx	#, _157
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	salq	$52, %rbx	#, _159
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addq	%rax, %rbx	# _28, x
# inputs/bootstrap/source/falcon-fft.c:1402: 		FPC_MUL(fC0r, fC0i, fCr, fCi, xr, xi);
	movq	%rbx, %rsi	# x,
	movq	64(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp269, _29
# inputs/bootstrap/source/falcon-fft.c:1402: 		FPC_MUL(fC0r, fC0i, fCr, fCi, xr, xi);
	movq	%r12, %rsi	# _162,
	movq	56(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp270, _30
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%rbp, %rsi	# _29, _29
	xorq	%r14, %rsi	# tmp204, _29
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp271, _152
# inputs/bootstrap/source/falcon-fft.c:1402: 		FPC_MUL(fC0r, fC0i, fCr, fCi, xr, xi);
	movq	%r12, %rsi	# _162,
	movq	64(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp272, _31
# inputs/bootstrap/source/falcon-fft.c:1402: 		FPC_MUL(fC0r, fC0i, fCr, fCi, xr, xi);
	movq	%rbx, %rsi	# x,
	movq	56(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp273, _32
# inputs/bootstrap/source/falcon-fft.c:1402: 		FPC_MUL(fC0r, fC0i, fCr, fCi, xr, xi);
	movq	%rbp, %rsi	# _31,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp274, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:1403: 		FPC_MUL(fC1r, fC1i, fC0r, fC0i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%rax, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp275, _33
# inputs/bootstrap/source/falcon-fft.c:1403: 		FPC_MUL(fC1r, fC1i, fC0r, fC0i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r13, %rdi	# _152,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp276, _34
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%r14, %rbx	# tmp204, _33
	movq	%rbx, %rsi	# _33, y_149
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 64(%rsp)	# tmp277, %sfp
# inputs/bootstrap/source/falcon-fft.c:1403: 		FPC_MUL(fC1r, fC1i, fC0r, fC0i, fpr_W2R, fpr_W2I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r12, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp278, _35
# inputs/bootstrap/source/falcon-fft.c:1403: 		FPC_MUL(fC1r, fC1i, fC0r, fC0i, fpr_W2R, fpr_W2I);
	movabsq	$4605975682916830378, %rsi	#,
	movq	%r13, %rdi	# _152,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp279, _36
# inputs/bootstrap/source/falcon-fft.c:1403: 		FPC_MUL(fC1r, fC1i, fC0r, fC0i, fpr_W2R, fpr_W2I);
	movq	%rbx, %rsi	# _35,
	call	fpr_add@PLT	#
	movq	%rax, 56(%rsp)	# tmp280, %sfp
# inputs/bootstrap/source/falcon-fft.c:1404: 		FPC_MUL(fC2r, fC2i, fC0r, fC0i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%r12, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp281, _37
# inputs/bootstrap/source/falcon-fft.c:1404: 		FPC_MUL(fC2r, fC2i, fC0r, fC0i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r13, %rdi	# _152,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp282, _38
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	xorq	%r14, %rbx	# tmp204, _37
	movq	%rbx, %rsi	# _37, y_96
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp283, _148
# inputs/bootstrap/source/falcon-fft.c:1404: 		FPC_MUL(fC2r, fC2i, fC0r, fC0i, fpr_W4R, fpr_W4I);
	movabsq	$-4620693217682128896, %rsi	#,
	movq	%r12, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %rbx	# tmp284, _39
# inputs/bootstrap/source/falcon-fft.c:1404: 		FPC_MUL(fC2r, fC2i, fC0r, fC0i, fpr_W4R, fpr_W4I);
	movabsq	$-4617396353937945430, %rsi	#,
	movq	%r13, %rdi	# _152,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp285, _40
# inputs/bootstrap/source/falcon-fft.c:1404: 		FPC_MUL(fC2r, fC2i, fC0r, fC0i, fpr_W4R, fpr_W4I);
	movq	%rbx, %rsi	# _39,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp286, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:1405: 		FPC_ADD(fB0r, fB0i, fB0r, fB0i, fC0r, fC0i);
	movq	%r13, %rsi	# _152,
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp287, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1405: 		FPC_ADD(fB0r, fB0i, fB0r, fB0i, fC0r, fC0i);
	movq	%r12, %rsi	# fpct_d_im,
	movq	(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, (%rsp)	# tmp288, %sfp
# inputs/bootstrap/source/falcon-fft.c:1406: 		FPC_ADD(fB1r, fB1i, fB1r, fB1i, fC2r, fC2i);
	movq	%rbp, %rsi	# _148,
	movq	104(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp289, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1406: 		FPC_ADD(fB1r, fB1i, fB1r, fB1i, fC2r, fC2i);
	movq	%rbx, %rsi	# fpct_d_im,
	movq	80(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp290, fpct_im
# inputs/bootstrap/source/falcon-fft.c:1407: 		FPC_ADD(fB2r, fB2i, fB2r, fB2i, fC1r, fC1i);
	movq	64(%rsp), %rsi	# %sfp,
	movq	96(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp291, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1407: 		FPC_ADD(fB2r, fB2i, fB2r, fB2i, fC1r, fC1i);
	movq	56(%rsp), %rsi	# %sfp,
	movq	88(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, 8(%rsp)	# tmp292, %sfp
# inputs/bootstrap/source/falcon-fft.c:1408: 		FPC_ADD(f[u + 0], f[u + 0 + hn], fAr, fAi, fB0r, fB0i);
	movq	%r13, %rsi	# fpct_re,
	movq	32(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r13	# tmp293, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1408: 		FPC_ADD(f[u + 0], f[u + 0 + hn], fAr, fAi, fB0r, fB0i);
	movq	(%rsp), %rsi	# %sfp,
	movq	40(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1408: 		FPC_ADD(f[u + 0], f[u + 0 + hn], fAr, fAi, fB0r, fB0i);
	movq	48(%rsp), %rdx	# %sfp, ivtmp.635
	movq	%r13, (%rdx)	# fpct_re, MEM[(fpr *)_200]
	movq	72(%rsp), %r13	# %sfp, ivtmp.636
	movq	%rax, 0(%r13)	# tmp294, MEM[(fpr *)_203]
# inputs/bootstrap/source/falcon-fft.c:1409: 		FPC_ADD(f[u + 1], f[u + 1 + hn], fAr, fAi, fB1r, fB1i);
	movq	%r12, %rsi	# fpct_re,
	movq	32(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp295, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1409: 		FPC_ADD(f[u + 1], f[u + 1 + hn], fAr, fAi, fB1r, fB1i);
	movq	%rbp, %rsi	# fpct_im,
	movq	40(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1409: 		FPC_ADD(f[u + 1], f[u + 1 + hn], fAr, fAi, fB1r, fB1i);
	movq	48(%rsp), %rbp	# %sfp, ivtmp.635
	movq	%r12, 8(%rbp)	# fpct_re, MEM[(fpr *)_200 + 8B]
	movq	%rax, 8(%r13)	# tmp296, MEM[(fpr *)_203 + 8B]
# inputs/bootstrap/source/falcon-fft.c:1410: 		FPC_ADD(f[u + 2], f[u + 2 + hn], fAr, fAi, fB2r, fB2i);
	movq	%rbx, %rsi	# fpct_re,
	movq	32(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %rbx	# tmp297, fpct_re
# inputs/bootstrap/source/falcon-fft.c:1410: 		FPC_ADD(f[u + 2], f[u + 2 + hn], fAr, fAi, fB2r, fB2i);
	movq	8(%rsp), %rsi	# %sfp,
	movq	40(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1410: 		FPC_ADD(f[u + 2], f[u + 2 + hn], fAr, fAi, fB2r, fB2i);
	movq	%rbx, 16(%rbp)	# fpct_re, MEM[(fpr *)_200 + 16B]
	movq	%r13, %rcx	# ivtmp.636, ivtmp.636
	movq	%rax, 16(%r13)	# tmp298, MEM[(fpr *)_203 + 16B]
# inputs/bootstrap/source/falcon-fft.c:1383: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	addq	$1, %r15	#, v
# inputs/bootstrap/source/falcon-fft.c:1383: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	addq	$16, 16(%rsp)	#, %sfp
	addq	$24, %rbp	#, ivtmp.635
	movq	%rbp, 48(%rsp)	# ivtmp.635, %sfp
	addq	$24, %rcx	#, ivtmp.636
	movq	%rcx, 72(%rsp)	# ivtmp.636, %sfp
	addq	$8, 24(%rsp)	#, %sfp
	leaq	(%r15,%r15,2), %rax	#, u_206
	movq	136(%rsp), %rcx	# %sfp, hn
	cmpq	%rcx, %rax	# hn, u_206
	jb	.L268	#,
.L266:
# inputs/bootstrap/source/falcon-fft.c:1412: }
	addq	$152, %rsp	#,
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
.LFE77:
	.size	falcon_poly_merge_top_fft3, .-falcon_poly_merge_top_fft3
	.globl	falcon_poly_merge_deep_fft3
	.type	falcon_poly_merge_deep_fft3, @function
falcon_poly_merge_deep_fft3:
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
	movq	%rdi, %r14	# tmp150, f
	movq	%rsi, 56(%rsp)	# tmp151, %sfp
	movq	%rdx, 64(%rsp)	# tmp152, %sfp
# inputs/bootstrap/source/falcon-fft.c:1424: 	if (logn == 1) {
	cmpl	$1, %ecx	#, logn
	je	.L277	#,
# inputs/bootstrap/source/falcon-fft.c:1434: 	n = (size_t)1 << logn;
	movl	$1, %edx	#, tmp140
	salq	%cl, %rdx	# logn, n
# inputs/bootstrap/source/falcon-fft.c:1435: 	hn = n >> 1;
	movq	%rdx, %rax	# n, hn
	shrq	%rax	# hn
	movq	%rax, 48(%rsp)	# hn, %sfp
# inputs/bootstrap/source/falcon-fft.c:1438: 	m = (size_t)1 << (logn - 1);
	subl	$1, %ecx	#, _4
# inputs/bootstrap/source/falcon-fft.c:1439: 	for (u = 0; u < qn; u ++) {
	shrq	$2, %rdx	#, qn
	je	.L271	#,
	movl	$16, %eax	#, tmp142
	salq	%cl, %rax	# _4, _83
	leaq	fpr_gm3_square(%rip), %rcx	#, tmp143
	leaq	(%rax,%rcx), %rbp	#, ivtmp.649
	leaq	0(,%rdx,8), %rbx	#, ivtmp.659
# inputs/bootstrap/source/falcon-fft.c:1439: 	for (u = 0; u < qn; u ++) {
	movl	$0, %r15d	#, u
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%rbp, %r13	# ivtmp.649, ivtmp.649
	movq	%rdx, 72(%rsp)	# qn, %sfp
.L274:
# inputs/bootstrap/source/falcon-fft.c:1443: 		a_re = f0[u];
	movq	56(%rsp), %rax	# %sfp, f0
	movq	(%rax,%r15,8), %rdx	# MEM[(const fpr *)f0_39(D) + u_81 * 8], a_re
	movq	%rdx, 8(%rsp)	# a_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:1444: 		a_im = f0[u + qn];
	movq	(%rax,%rbx), %rax	# MEM[(const fpr *)f0_39(D) + ivtmp.659_88 * 1], a_im
	movq	%rax, 16(%rsp)	# a_im, %sfp
# inputs/bootstrap/source/falcon-fft.c:1445: 		b_re = f1[u];
	movq	64(%rsp), %rcx	# %sfp, f1
	movq	(%rcx,%r15,8), %rdi	# MEM[(const fpr *)f1_42(D) + u_81 * 8], b_re
	movq	%rdi, 24(%rsp)	# b_re, %sfp
# inputs/bootstrap/source/falcon-fft.c:1446: 		b_im = f1[u + qn];
	movq	(%rcx,%rbx), %rcx	# MEM[(const fpr *)f1_42(D) + ivtmp.659_88 * 1], b_im
# inputs/bootstrap/source/falcon-fft.c:1447: 		FPC_MUL(t_re, t_im, b_re, b_im,
	movq	0(%r13), %rbp	# MEM[(long unsigned int *)_91], fpct_b_re
	movq	8(%r13), %rsi	# MEM[(long unsigned int *)_91 + 8B], fpct_b_im
	movq	%rsi, 40(%rsp)	# fpct_b_im, %sfp
	movq	%rcx, 32(%rsp)	# b_im, %sfp
	movq	%rcx, %rdi	# b_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp157, _15
# inputs/bootstrap/source/falcon-fft.c:1447: 		FPC_MUL(t_re, t_im, b_re, b_im,
	movq	%rbp, %rsi	# fpct_b_re,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp158, _16
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r8	#, y_74
	xorq	%r12, %r8	# _15, y_74
	movq	%r8, %rsi	# y_74, y_74
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp159, _75
# inputs/bootstrap/source/falcon-fft.c:1447: 		FPC_MUL(t_re, t_im, b_re, b_im,
	movq	%rbp, %rsi	# fpct_b_re,
	movq	32(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rbp	# tmp160, _17
# inputs/bootstrap/source/falcon-fft.c:1447: 		FPC_MUL(t_re, t_im, b_re, b_im,
	movq	40(%rsp), %rsi	# %sfp,
	movq	24(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp161, _18
# inputs/bootstrap/source/falcon-fft.c:1447: 		FPC_MUL(t_re, t_im, b_re, b_im,
	movq	%rbp, %rsi	# _17,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp162, fpct_d_im
# inputs/bootstrap/source/falcon-fft.c:1450: 		FPC_ADD(f[(u << 1) + 0], f[(u << 1) + 0 + hn],
	movq	%r12, %rsi	# _75,
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, 24(%rsp)	# tmp163, %sfp
# inputs/bootstrap/source/falcon-fft.c:1450: 		FPC_ADD(f[(u << 1) + 0], f[(u << 1) + 0 + hn],
	movq	%rbp, %rsi	# fpct_d_im,
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1450: 		FPC_ADD(f[(u << 1) + 0], f[(u << 1) + 0 + hn],
	movq	24(%rsp), %rcx	# %sfp, fpct_re
	movq	%rcx, (%r14)	# fpct_re, MEM[(fpr *)_92]
	movq	48(%rsp), %rcx	# %sfp, hn
	movq	%rax, (%r14,%rcx,8)	# tmp164, MEM[(fpr *)_92 + hn_35 * 8]
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_72
	xorq	%r12, %rsi	# _75, y_72
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	8(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp165, _73
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %rsi	#, y_70
	xorq	%rbp, %rsi	# fpct_d_im, y_70
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1452: 		FPC_SUB(f[(u << 1) + 1], f[(u << 1) + 1 + hn],
	movq	%r12, 8(%r14)	# _73, MEM[(fpr *)_92 + 8B]
	movq	48(%rsp), %rcx	# %sfp, hn
	movq	%rax, 8(%r14,%rcx,8)	# tmp166, MEM[(fpr *)_92 + 8B + hn_35 * 8]
# inputs/bootstrap/source/falcon-fft.c:1439: 	for (u = 0; u < qn; u ++) {
	addq	$1, %r15	#, u
# inputs/bootstrap/source/falcon-fft.c:1439: 	for (u = 0; u < qn; u ++) {
	addq	$16, %r13	#, ivtmp.649
	addq	$16, %r14	#, ivtmp.650
	addq	$8, %rbx	#, ivtmp.659
	cmpq	%r15, 72(%rsp)	# u, %sfp
	jne	.L274	#,
.L271:
# inputs/bootstrap/source/falcon-fft.c:1455: }
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
.L277:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-fft.c:1427: 		x = *f0;
	movq	(%rsi), %r12	# *f0_39(D), x
# inputs/bootstrap/source/falcon-fft.c:1428: 		y = *f1;
	movq	(%rdx), %rbp	# *f1_42(D), y
# inputs/bootstrap/source/falcon-fft.c:1429: 		f[0] = fpr_add(x, fpr_mul(y, fpr_W1R));
	movabsq	$4602678819172646912, %rsi	#, tmp138
	movq	%rbp, %rdi	# y,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp154, _1
# inputs/bootstrap/source/falcon-fft.c:1429: 		f[0] = fpr_add(x, fpr_mul(y, fpr_W1R));
	movq	%r12, %rdi	# x,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1429: 		f[0] = fpr_add(x, fpr_mul(y, fpr_W1R));
	movq	%rax, (%r14)	# tmp155, *f_57(D)
# inputs/bootstrap/source/falcon-fft.c:1430: 		f[1] = fpr_mul(y, fpr_W1I);
	movabsq	$4605975682916830378, %rsi	#, tmp139
	movq	%rbp, %rdi	# y,
	call	fpr_mul@PLT	#
# inputs/bootstrap/source/falcon-fft.c:1430: 		f[1] = fpr_mul(y, fpr_W1I);
	movq	%rax, 8(%r14)	# tmp156, MEM[(fpr *)f_57(D) + 8B]
# inputs/bootstrap/source/falcon-fft.c:1431: 		return;
	jmp	.L271	#
	.cfi_endproc
.LFE78:
	.size	falcon_poly_merge_deep_fft3, .-falcon_poly_merge_deep_fft3
	.section	.rodata
	.align 32
	.type	fpr_gm3_cubic, @object
	.size	fpr_gm3_cubic, 32768
fpr_gm3_cubic:
	.quad	4607182418800017408
	.quad	0
	.quad	4607182418800017408
	.quad	0
	.quad	4606639218218904860
	.quad	4599832907078044661
	.quad	-4627947681618365560
	.quad	4607045579204271127
	.quad	4607045579204271127
	.quad	4595424355236410249
	.quad	4599832907078044663
	.quad	4606639218218904859
	.quad	4603964935624201757
	.quad	4605075134482436153
	.quad	-4623539129776731151
	.quad	4606639218218904860
	.quad	4607148143687505314
	.quad	4590944653792149762
	.quad	4601284833702287443
	.quad	4606338514369238887
	.quad	4605553485228115783
	.quad	4603341536795314552
	.quad	-4632427383062626057
	.quad	4607148143687505314
	.quad	4606338514369238887
	.quad	4601284833702287443
	.quad	4590944653792149760
	.quad	4607148143687505314
	.quad	4603341536795314553
	.quad	4605553485228115782
	.quad	-4622087203152488367
	.quad	4606338514369238888
	.quad	4607173845942158839
	.quad	4586447037249703441
	.quad	4601989743447922487
	.quad	4606164702860826481
	.quad	4605771814347457168
	.quad	4603014784177150555
	.quad	-4636924999605072383
	.quad	4607173845942158839
	.quad	4606765538153289697
	.quad	4599088654024288286
	.quad	4596966079207974258
	.quad	4606968912213013686
	.quad	4604260395159822504
	.quad	4604816023423929988
	.quad	-4624283382830487525
	.quad	4606765538153289697
	.quad	4606968912213013686
	.quad	4596966079207974257
	.quad	4599088654024288285
	.quad	4606765538153289697
	.quad	4604816023423929988
	.quad	4604260395159822503
	.quad	-4626405957646801562
	.quad	4606968912213013687
	.quad	4606164702860826481
	.quad	4601989743447922487
	.quad	4586447037249703442
	.quad	4607173845942158839
	.quad	4603014784177150555
	.quad	4605771814347457168
	.quad	-4621382293406853315
	.quad	4606164702860826480
	.quad	4607180275330508917
	.quad	4581944933927641835
	.quad	4602336343279804913
	.quad	4606072072125896567
	.quad	4605875581109671008
	.quad	4602847913649559421
	.quad	-4641427102927133998
	.quad	4607180275330508917
	.quad	4606822579878215551
	.quad	4598712571291175637
	.quad	4597731557059426440
	.quad	4606924291112596997
	.quad	4604403815425962139
	.quad	4604681695685992796
	.quad	-4624659465563600171
	.quad	4606822579878215551
	.quad	4607077588605776311
	.quad	4594648842893409399
	.quad	4600200723174543410
	.quad	4606570000130893178
	.quad	4605199794480174685
	.quad	4603813036977457567
	.quad	-4628723193961366409
	.quad	4607077588605776311
	.quad	4606419612417856976
	.quad	4600926859287395958
	.quad	4592509105735425709
	.quad	4607128883054083053
	.quad	4603501263369338034
	.quad	4605439026783824379
	.quad	-4622445177567379851
	.quad	4606419612417856976
	.quad	4607128883054083053
	.quad	4592509105735425697
	.quad	4600926859287395959
	.quad	4606419612417856975
	.quad	4605439026783824379
	.quad	4603501263369338033
	.quad	-4630862931119350108
	.quad	4607128883054083053
	.quad	4606570000130893179
	.quad	4600200723174543409
	.quad	4594648842893409403
	.quad	4607077588605776311
	.quad	4603813036977457568
	.quad	4605199794480174684
	.quad	-4623171313680232400
	.quad	4606570000130893179
	.quad	4606924291112596997
	.quad	4597731557059426439
	.quad	4598712571291175639
	.quad	4606822579878215550
	.quad	4604681695685992797
	.quad	4604403815425962139
	.quad	-4625640479795349365
	.quad	4606924291112596997
	.quad	4606072072125896567
	.quad	4602336343279804911
	.quad	4581944933927641846
	.quad	4607180275330508917
	.quad	4602847913649559420
	.quad	4605875581109671009
	.quad	-4621035693574970900
	.quad	4606072072125896568
	.quad	4607181882916699096
	.quad	4577441708409984386
	.quad	4602508106953020744
	.quad	4606024344505051779
	.quad	4605926093151474733
	.quad	4602763639399141684
	.quad	-4645930328444791465
	.quad	4607181882916699096
	.quad	4606849558982912513
	.quad	4598523618984384712
	.quad	4598112790264389587
	.quad	4606900417625938195
	.quad	4604474418092698799
	.quad	4604613366489448972
	.quad	-4624848417870391095
	.quad	4606849558982912513
	.quad	4607092005287934273
	.quad	4594260085386961817
	.quad	4600383476794949121
	.quad	4606533890655574311
	.quad	4605260874381467713
	.quad	4603736076849412673
	.quad	-4629111951467813999
	.quad	4607092005287934274
	.quad	4606458692325131552
	.quad	4600746566453394570
	.quad	4593289978061985987
	.quad	4607117654038060029
	.quad	4603580180770315704
	.quad	4605380497650278921
	.quad	-4622625470401381239
	.quad	4606458692325131552
	.quad	4607156173013081786
	.quad	4590161260329570368
	.quad	4601462472687802021
	.quad	4606296505877752155
	.quad	4605609400919451476
	.quad	4603260746628133737
	.quad	-4633210776525205450
	.quad	4607156173013081786
	.quad	4606672318595337402
	.quad	4599647888368388837
	.quad	4595811017794750059
	.quad	4607027990293722581
	.quad	4604039856068481122
	.quad	4605011569219283744
	.quad	-4623724148486386975
	.quad	4606672318595337403
	.quad	4606989654517306848
	.quad	4596581925645694536
	.quad	4599275739700525709
	.quad	4606735482320455637
	.quad	4604882005981665859
	.quad	4604187594625996952
	.quad	-4626790111209081274
	.quad	4606989654517306848
	.quad	4606209594952780485
	.quad	4601814948531169788
	.quad	4588017188692217266
	.quad	4607169024905031858
	.quad	4603097360598399924
	.quad	4605718571974254057
	.quad	-4621557088323606019
	.quad	4606209594952780485
	.quad	4607169024905031858
	.quad	4588017188692217266
	.quad	4601814948531169788
	.quad	4606209594952780485
	.quad	4605718571974254058
	.quad	4603097360598399924
	.quad	-4635354848162558560
	.quad	4607169024905031858
	.quad	4606735482320455637
	.quad	4599275739700525711
	.quad	4596581925645694538
	.quad	4606989654517306848
	.quad	4604187594625996953
	.quad	4604882005981665859
	.quad	-4624096297154250101
	.quad	4606735482320455638
	.quad	4607027990293722581
	.quad	4595811017794750057
	.quad	4599647888368388839
	.quad	4606672318595337402
	.quad	4605011569219283744
	.quad	4604039856068481122
	.quad	-4627561019060025753
	.quad	4607027990293722581
	.quad	4606296505877752156
	.quad	4601462472687802016
	.quad	4590161260329570366
	.quad	4607156173013081786
	.quad	4603260746628133738
	.quad	4605609400919451476
	.quad	-4621909564166973796
	.quad	4606296505877752158
	.quad	4607117654038060029
	.quad	4593289978061985975
	.quad	4600746566453394571
	.quad	4606458692325131552
	.quad	4605380497650278921
	.quad	4603580180770315703
	.quad	-4630082058792789830
	.quad	4607117654038060029
	.quad	4606533890655574312
	.quad	4600383476794949120
	.quad	4594260085386961814
	.quad	4607092005287934273
	.quad	4603736076849412673
	.quad	4605260874381467714
	.quad	-4622988560059826689
	.quad	4606533890655574312
	.quad	4606900417625938195
	.quad	4598112790264389587
	.quad	4598523618984384715
	.quad	4606849558982912512
	.quad	4604613366489448972
	.quad	4604474418092698799
	.quad	-4625259246590386218
	.quad	4606900417625938195
	.quad	4606024344505051779
	.quad	4602508106953020743
	.quad	4577441708409984414
	.quad	4607181882916699096
	.quad	4602763639399141686
	.quad	4605926093151474733
	.quad	-4620863929901755066
	.quad	4606024344505051779
	.quad	4607182284828191491
	.quad	4572938202312128858
	.quad	4602593595767058692
	.quad	4606000130097569672
	.quad	4605951003690081814
	.quad	4602721296903615105
	.quad	-4650433834542647155
	.quad	4607182284828191491
	.quad	4606862661671240416
	.quad	4598428924920796858
	.quad	4598239115057815562
	.quad	4606888091370991066
	.quad	4604509438869545596
	.quad	4604578914101285593
	.quad	-4624943111933978954
	.quad	4606862661671240416
	.quad	4607098815853174172
	.quad	4594065476525407104
	.quad	4600474555469142997
	.quad	4606515462670391855
	.quad	4605291098611673936
	.quad	4603697348077555635
	.quad	-4629306560329368709
	.quad	4607098815853174172
	.quad	4606477862945917416
	.quad	4600656102998678362
	.quad	4593675827531314357
	.quad	4607111640418987854
	.quad	4603619398878601632
	.quad	4605350911135722684
	.quad	-4622715933856097449
	.quad	4606477862945917417
	.quad	4607159786989248319
	.quad	4589769312493254891
	.quad	4601550945859770439
	.quad	4606275138933151328
	.quad	4605637027454390083
	.quad	4603220124018316060
	.quad	-4633602724361520920
	.quad	4607159786989248319
	.quad	4606688489873842896
	.quad	4599555110965695918
	.quad	4596004055527019456
	.quad	4607018800681046782
	.quad	4604077055157151784
	.quad	4604979481064721887
	.quad	-4623816925889079892
	.quad	4606688489873842896
	.quad	4606999632507734178
	.quad	4596389515185764921
	.quad	4599369033864079492
	.quad	4606720072206153220
	.quad	4604914698482345847
	.quad	4604150925534647393
	.quad	-4626982521669010893
	.quad	4606999632507734178
	.quad	4606231682824305388
	.quad	4601727186402831589
	.quad	4588801925525465074
	.quad	4607166213030803401
	.quad	4603138429788340567
	.quad	4605691613793700974
	.quad	-4621644850451944223
	.quad	4606231682824305389
	.quad	4607175854961642494
	.quad	4585661669348864695
	.quad	4602076771036586546
	.quad	4606141899975834814
	.quad	4605798096956267923
	.quad	4602973279402302181
	.quad	-4637710367505911112
	.quad	4607175854961642494
	.quad	4606780182977728806
	.quad	4598994868076977168
	.quad	4597157810882631314
	.quad	4606958148516184138
	.quad	4604296524436648515
	.quad	4604782735329704834
	.quad	-4624377168777798637
	.quad	4606780182977728806
	.quad	4607053977978913869
	.quad	4595230741912669812
	.quad	4599925142881122582
	.quad	4606622290105638580
	.quad	4605106609700104983
	.quad	4603927216497305537
	.quad	-4628141294942106001
	.quad	4607053977978913869
	.quad	4606359154666467899
	.quad	4601195673173096296
	.quad	4591336076114243402
	.quad	4607143728576949513
	.quad	4603381701949354326
	.quad	4605525197735083090
	.quad	-4622176363681679512
	.quad	4606359154666467899
	.quad	4607134098116996264
	.quad	4592118313720774463
	.quad	4601016683303380186
	.quad	4606399704293906449
	.quad	4605467967661705256
	.quad	4603461566424259131
	.quad	-4631253723134001349
	.quad	4607134098116996264
	.quad	4606587680546854987
	.quad	4600109053664835312
	.quad	4594842979973652376
	.quad	4607069982917721689
	.quad	4603851266044256993
	.quad	4605168940626075751
	.quad	-4623262983189940498
	.quad	4606587680546854987
	.quad	4606935837634126845
	.quad	4597540555501247495
	.quad	4598806823913478174
	.quad	4606808704264413375
	.quad	4604715570461735357
	.quad	4604368235636340718
	.quad	-4625831481353528312
	.quad	4606935837634126845
	.quad	4606095583919471292
	.quad	4602250073530204885
	.quad	4583516511340545332
	.quad	4607179069703633158
	.quad	4602889842897483675
	.quad	4605849981109092498
	.quad	-4621121963324570924
	.quad	4606095583919471292
	.quad	4607179069703633158
	.quad	4583516511340545355
	.quad	4602250073530204886
	.quad	4606095583919471292
	.quad	4605849981109092498
	.quad	4602889842897483675
	.quad	-4639855525514230512
	.quad	4607179069703633158
	.quad	4606808704264413375
	.quad	4598806823913478173
	.quad	4597540555501247500
	.quad	4606935837634126845
	.quad	4604368235636340719
	.quad	4604715570461735357
	.quad	-4624565212941297640
	.quad	4606808704264413376
	.quad	4607069982917721689
	.quad	4594842979973652368
	.quad	4600109053664835312
	.quad	4606587680546854987
	.quad	4605168940626075751
	.quad	4603851266044256993
	.quad	-4628529056881123437
	.quad	4607069982917721689
	.quad	4606399704293906448
	.quad	4601016683303380187
	.quad	4592118313720774468
	.quad	4607134098116996264
	.quad	4603461566424259131
	.quad	4605467967661705256
	.quad	-4622355353551395621
	.quad	4606399704293906448
	.quad	4607143728576949513
	.quad	4591336076114243398
	.quad	4601195673173096295
	.quad	4606359154666467900
	.quad	4605525197735083091
	.quad	4603381701949354325
	.quad	-4632035960740532414
	.quad	4607143728576949513
	.quad	4606622290105638580
	.quad	4599925142881122582
	.quad	4595230741912669811
	.quad	4607053977978913869
	.quad	4603927216497305538
	.quad	4605106609700104982
	.quad	-4623446893973653228
	.quad	4606622290105638580
	.quad	4606958148516184139
	.quad	4597157810882631308
	.quad	4598994868076977169
	.quad	4606780182977728806
	.quad	4604782735329704835
	.quad	4604296524436648515
	.quad	-4626214225972144498
	.quad	4606958148516184139
	.quad	4606141899975834814
	.quad	4602076771036586545
	.quad	4585661669348864713
	.quad	4607175854961642494
	.quad	4602973279402302183
	.quad	4605798096956267922
	.quad	-4621295265818189267
	.quad	4606141899975834815
	.quad	4607166213030803401
	.quad	4588801925525465058
	.quad	4601727186402831590
	.quad	4606231682824305388
	.quad	4605691613793700974
	.quad	4603138429788340567
	.quad	-4634570111329310752
	.quad	4607166213030803401
	.quad	4606720072206153221
	.quad	4599369033864079487
	.quad	4596389515185764919
	.quad	4606999632507734178
	.quad	4604150925534647394
	.quad	4604914698482345847
	.quad	-4624003002990696318
	.quad	4606720072206153221
	.quad	4607018800681046782
	.quad	4596004055527019458
	.quad	4599555110965695918
	.quad	4606688489873842896
	.quad	4604979481064721887
	.quad	4604077055157151783
	.quad	-4627367981327756356
	.quad	4607018800681046782
	.quad	4606275138933151328
	.quad	4601550945859770438
	.quad	4589769312493254897
	.quad	4607159786989248319
	.quad	4603220124018316061
	.quad	4605637027454390083
	.quad	-4621821090995005371
	.quad	4606275138933151328
	.quad	4607111640418987854
	.quad	4593675827531314356
	.quad	4600656102998678365
	.quad	4606477862945917416
	.quad	4605350911135722684
	.quad	4603619398878601632
	.quad	-4629696209323461455
	.quad	4607111640418987854
	.quad	4606515462670391856
	.quad	4600474555469142995
	.quad	4594065476525407104
	.quad	4607098815853174172
	.quad	4603697348077555634
	.quad	4605291098611673936
	.quad	-4622897481385632816
	.quad	4606515462670391857
	.quad	4606888091370991065
	.quad	4598239115057815565
	.quad	4598428924920796860
	.quad	4606862661671240415
	.quad	4604578914101285593
	.quad	4604509438869545596
	.quad	-4625132921796960248
	.quad	4606888091370991066
	.quad	4606000130097569672
	.quad	4602593595767058691
	.quad	4572938202312128794
	.quad	4607182284828191491
	.quad	4602721296903615105
	.quad	4605951003690081814
	.quad	-4620778441087717118
	.quad	4606000130097569673
	.quad	4607182385306998657
	.quad	4568434626067267525
	.quad	4602636240804545080
	.quad	4605987935558566219
	.quad	4605963372263484363
	.quad	4602700074863679077
	.quad	-4654937410787508047
	.quad	4607182385306998657
	.quad	4606869116127612920
	.quad	4598381524643160706
	.quad	4598286619358767412
	.quad	4606881831024768234
	.quad	4604526878662140842
	.quad	4604561616407182173
	.quad	-4624990512211615101
	.quad	4606869116127612920
	.quad	4607102121601902643
	.quad	4593968117099574380
	.quad	4600520019085905970
	.quad	4606506155604540149
	.quad	4605306131402280410
	.quad	4603677922017902619
	.quad	-4629403919755201429
	.quad	4607102121601902643
	.quad	4606487355672395907
	.quad	4600610793188214614
	.quad	4593773291878075871
	.quad	4607108533908653467
	.quad	4603638947273499121
	.quad	4605336037775510796
	.quad	-4622761243666561196
	.quad	4606487355672395908
	.quad	4607161493757337631
	.quad	4589573280899107428
	.quad	4601595094712978766
	.quad	4606264365063040824
	.quad	4605650757533548012
	.quad	4603199756359801208
	.quad	-4633798755955668379
	.quad	4607161493757337631
	.quad	4606696480573970745
	.quad	4599508656458981179
	.quad	4596100498493145636
	.quad	4607014107203672837
	.quad	4604095588933135208
	.quad	4604963361023318192
	.quad	-4623863380395794626
	.quad	4606696480573970744
	.quad	4607004523081378245
	.quad	4596293229039181514
	.quad	4599415617562210426
	.quad	4606712271798845136
	.quad	4604930969611683613
	.quad	4604132524259225992
	.quad	-4627078807815594298
	.quad	4607004523081378245
	.quad	4606242636927822390
	.quad	4601683215312183327
	.quad	4589181109648202268
	.quad	4607164706790062744
	.quad	4603158909092924042
	.quad	4605678050804692723
	.quad	-4621688821542592477
	.quad	4606242636927822390
	.quad	4607176759069161222
	.quad	4585268922573927290
	.quad	4602120191229649048
	.quad	4606130409619196990
	.quad	4605811153273063687
	.quad	4602952473413289657
	.quad	-4638103114280848541
	.quad	4607176759069161222
	.quad	4606787409425109412
	.quad	4598947915545828530
	.quad	4597253587946885925
	.quad	4606952668670407695
	.quad	4604314520856446390
	.quad	4604766017511021787
	.quad	-4624424121308947282
	.quad	4606787409425109412
	.quad	4607058078335482396
	.quad	4595133867258558713
	.quad	4599971191193412633
	.quad	4606613731786827610
	.quad	4605122270044821788
	.quad	4603908292697729040
	.quad	-4628238169596217098
	.quad	4607058078335482396
	.quad	4606369383558142351
	.quad	4601151008808680222
	.quad	4591531713577854027
	.quad	4607141420965888129
	.quad	4603401726520500978
	.quad	4605510971943806214
	.quad	-4622221028046095588
	.quad	4606369383558142352
	.quad	4607136605718006140
	.quad	4591922833835489309
	.quad	4601061513541036518
	.quad	4606389658447253234
	.quad	4605482356800712687
	.quad	4603441658906440841
	.quad	-4631449203019286499
	.quad	4607136605718006140
	.quad	4606596426943088237
	.quad	4600063146927203822
	.quad	4594939985568106340
	.quad	4607066080834643375
	.quad	4603870317329994425
	.quad	4605153435623695506
	.quad	-4623308889927571987
	.quad	4606596426943088237
	.quad	4606941513187897698
	.quad	4597444960967809247
	.quad	4598853893114459252
	.quad	4606801670121479696
	.quad	4604732434952161242
	.quad	4604350376589621033
	.quad	-4625927075886966559
	.quad	4606941513187897698
	.quad	4606107251504902429
	.quad	4602206842798669656
	.quad	4584302215295182653
	.quad	4607178366446133540
	.quad	4602910755005751673
	.quad	4605837095445941219
	.quad	-4621165194056106152
	.quad	4606107251504902429
	.quad	4607180777690918878
	.quad	4581159072157108984
	.quad	4602379381656286403
	.quad	4606060228092608873
	.quad	4605888295256712466
	.quad	4602826896821728637
	.quad	-4642212964697666832
	.quad	4607180777690918878
	.quad	4606829421245891884
	.quad	4598665388570805659
	.quad	4597826962663699227
	.quad	4606918420230708837
	.quad	4604421535904258967
	.quad	4604664685652600935
	.quad	-4624706648283970146
	.quad	4606829421245891884
	.quad	4607081292154189543
	.quad	4594551712851407022
	.quad	4600246485264878995
	.quad	4606561066242652885
	.quad	4605215143102434986
	.quad	4603793859480703005
	.quad	-4628820324003368793
	.quad	4607081292154189543
	.quad	4606429474547098683
	.quad	4600881866177084246
	.quad	4592704414958493393
	.quad	4607126175630963849
	.quad	4603521052501374685
	.quad	4605424475260182624
	.quad	-4622490170677691562
	.quad	4606429474547098683
	.quad	4607150251154164800
	.quad	4590748871844652692
	.quad	4601329329203980642
	.quad	4606328103117185065
	.quad	4605567546719499094
	.quad	4603321396511127439
	.quad	-4632623165010123124
	.quad	4607150251154164800
	.quad	4606647587887466739
	.quad	4599786720273209301
	.quad	4595521092466148129
	.quad	4607041280848658130
	.quad	4603983730671006441
	.quad	4605059319843563564
	.quad	-4623585316581566510
	.quad	4606647587887466739
	.quad	4606974195984017778
	.quad	4596870126023469567
	.quad	4599135486742969918
	.quad	4606758119885143934
	.quad	4604832593451910398
	.quad	4604242262571485779
	.quad	-4626501910831306242
	.quad	4606974195984017778
	.quad	4606176015219596543
	.quad	4601946136699540246
	.quad	4586839652534867586
	.quad	4607172741045134876
	.quad	4603035482654317712
	.quad	4605758588250904470
	.quad	-4621425900155235563
	.quad	4606176015219596544
	.quad	4607170330517607906
	.quad	4587624731175417493
	.quad	4601858738916177684
	.quad	4606198461349038850
	.quad	4605731966965312409
	.quad	4603076771018472026
	.quad	-4635747305679358324
	.quad	4607170330517607906
	.quad	4606743091912845809
	.quad	4599229029928926352
	.quad	4596678048528094907
	.quad	4606984567174729342
	.quad	4604205862169219126
	.quad	4604865584853455938
	.quad	-4624143006925849459
	.quad	4606743091912845809
	.quad	4607032486360681799
	.quad	4595714424464217655
	.quad	4599694210574386660
	.quad	4606664138137224651
	.quad	4605027537093804094
	.quad	4604021191032441429
	.quad	-4627657612390558152
	.quad	4607032486360681799
	.quad	4606307098793337708
	.quad	4601418149027011960
	.quad	4590357173656844238
	.quad	4607154265831881503
	.quad	4603281001277328484
	.quad	4605595504669127795
	.quad	-4621953887827763853
	.quad	4606307098793337709
	.quad	4607120561102074868
	.quad	4593094852573604903
	.quad	4600791719424875373
	.quad	4606449014573395013
	.quad	4605395210584590016
	.quad	4603560511348590142
	.quad	-4630277184281170898
	.quad	4607120561102074868
	.quad	4606543011437857165
	.quad	4600337862414865229
	.quad	4594357333375388583
	.quad	4607088500522072638
	.quad	4603755379273592984
	.quad	4605245683166643876
	.quad	-4623034174439910575
	.quad	4606543011437857164
	.quad	4606906483442992825
	.quad	4598017579974985940
	.quad	4598570912066101953
	.quad	4606842910848401075
	.quad	4604630520927288446
	.quad	4604456837368894808
	.quad	-4625354456879789878
	.quad	4606906483442992826
	.quad	4606036364193449237
	.quad	4602465263812244715
	.quad	4579013642383981667
	.quad	4607181581487002861
	.quad	4602784759539833464
	.quad	4605913551371528486
	.quad	-4620906773042531092
	.quad	4606036364193449237
	.quad	4607181581487002861
	.quad	4579013642383981544
	.quad	4602465263812244714
	.quad	4606036364193449238
	.quad	4605913551371528486
	.quad	4602784759539833464
	.quad	-4644358394470794212
	.quad	4607181581487002861
	.quad	4606842910848401075
	.quad	4598570912066101955
	.quad	4598017579974985942
	.quad	4606906483442992825
	.quad	4604456837368894808
	.quad	4604630520927288445
	.quad	-4624801124788673857
	.quad	4606842910848401076
	.quad	4607088500522072638
	.quad	4594357333375388580
	.quad	4600337862414865231
	.quad	4606543011437857164
	.quad	4605245683166643876
	.quad	4603755379273592983
	.quad	-4629014703479387230
	.quad	4607088500522072638
	.quad	4606449014573395013
	.quad	4600791719424875373
	.quad	4593094852573604918
	.quad	4607120561102074868
	.quad	4603560511348590143
	.quad	4605395210584590015
	.quad	-4622580317429900437
	.quad	4606449014573395014
	.quad	4607154265831881503
	.quad	4590357173656844229
	.quad	4601418149027011961
	.quad	4606307098793337707
	.quad	4605595504669127795
	.quad	4603281001277328483
	.quad	-4633014863197931579
	.quad	4607154265831881503
	.quad	4606664138137224651
	.quad	4599694210574386658
	.quad	4595714424464217661
	.quad	4607032486360681799
	.quad	4604021191032441430
	.quad	4605027537093804093
	.quad	-4623677826280389147
	.quad	4606664138137224651
	.quad	4606984567174729342
	.quad	4596678048528094908
	.quad	4599229029928926351
	.quad	4606743091912845809
	.quad	4604865584853455938
	.quad	4604205862169219126
	.quad	-4626693988326680898
	.quad	4606984567174729342
	.quad	4606198461349038850
	.quad	4601858738916177681
	.quad	4587624731175417502
	.quad	4607170330517607906
	.quad	4603076771018472025
	.quad	4605731966965312409
	.quad	-4621513297938598126
	.quad	4606198461349038850
	.quad	4607172741045134876
	.quad	4586839652534867593
	.quad	4601946136699540247
	.quad	4606176015219596543
	.quad	4605758588250904470
	.quad	4603035482654317713
	.quad	-4636532384319908240
	.quad	4607172741045134876
	.quad	4606758119885143934
	.quad	4599135486742969916
	.quad	4596870126023469570
	.quad	4606974195984017778
	.quad	4604242262571485780
	.quad	4604832593451910398
	.quad	-4624236550111805896
	.quad	4606758119885143935
	.quad	4607041280848658131
	.quad	4595521092466148119
	.quad	4599786720273209300
	.quad	4606647587887466739
	.quad	4605059319843563565
	.quad	4603983730671006440
	.quad	-4627850944388627684
	.quad	4607041280848658130
	.quad	4606328103117185064
	.quad	4601329329203980643
	.quad	4590748871844652693
	.quad	4607150251154164800
	.quad	4603321396511127439
	.quad	4605567546719499094
	.quad	-4622042707650795161
	.quad	4606328103117185063
	.quad	4607126175630963849
	.quad	4592704414958493401
	.quad	4600881866177084248
	.quad	4606429474547098683
	.quad	4605424475260182624
	.quad	4603521052501374686
	.quad	-4630667621896282423
	.quad	4607126175630963849
	.quad	4606561066242652885
	.quad	4600246485264878995
	.quad	4594551712851407020
	.quad	4607081292154189543
	.quad	4603793859480703005
	.quad	4605215143102434986
	.quad	-4623125551589896815
	.quad	4606561066242652886
	.quad	4606918420230708837
	.quad	4597826962663699221
	.quad	4598665388570805660
	.quad	4606829421245891884
	.quad	4604664685652600935
	.quad	4604421535904258967
	.quad	-4625545074191076586
	.quad	4606918420230708837
	.quad	4606060228092608874
	.quad	4602379381656286400
	.quad	4581159072157109012
	.quad	4607180777690918878
	.quad	4602826896821728638
	.quad	4605888295256712465
	.quad	-4620992655198489410
	.quad	4606060228092608875
	.quad	4607178366446133540
	.quad	4584302215295182629
	.quad	4602206842798669657
	.quad	4606107251504902428
	.quad	4605837095445941219
	.quad	4602910755005751671
	.quad	-4639069821559593190
	.quad	4607178366446133540
	.quad	4606801670121479697
	.quad	4598853893114459248
	.quad	4597444960967809245
	.quad	4606941513187897698
	.quad	4604350376589621034
	.quad	4604732434952161241
	.quad	-4624518143740316558
	.quad	4606801670121479697
	.quad	4607066080834643375
	.quad	4594939985568106342
	.quad	4600063146927203823
	.quad	4606596426943088237
	.quad	4605153435623695507
	.quad	4603870317329994424
	.quad	-4628432051286669472
	.quad	4607066080834643376
	.quad	4606389658447253234
	.quad	4601061513541036517
	.quad	4591922833835489317
	.quad	4607136605718006140
	.quad	4603441658906440841
	.quad	4605482356800712687
	.quad	-4622310523313739292
	.quad	4606389658447253235
	.quad	4607141420965888129
	.quad	4591531713577854027
	.quad	4601151008808680226
	.quad	4606369383558142351
	.quad	4605510971943806214
	.quad	4603401726520500978
	.quad	-4631840323276921789
	.quad	4607141420965888130
	.quad	4606613731786827611
	.quad	4599971191193412631
	.quad	4595133867258558714
	.quad	4607058078335482396
	.quad	4603908292697729041
	.quad	4605122270044821788
	.quad	-4623400845661363181
	.quad	4606613731786827611
	.quad	4606952668670407695
	.quad	4597253587946885923
	.quad	4598947915545828532
	.quad	4606787409425109411
	.quad	4604766017511021787
	.quad	4604314520856446390
	.quad	-4626118448907889887
	.quad	4606952668670407695
	.quad	4606130409619196990
	.quad	4602120191229649048
	.quad	4585268922573927285
	.quad	4607176759069161222
	.quad	4602952473413289658
	.quad	4605811153273063687
	.quad	-4621251845625126766
	.quad	4606130409619196992
	.quad	4607164706790062744
	.quad	4589181109648202264
	.quad	4601683215312183326
	.quad	4606242636927822391
	.quad	4605678050804692724
	.quad	4603158909092924040
	.quad	-4634190927206573549
	.quad	4607164706790062744
	.quad	4606712271798845136
	.quad	4599415617562210426
	.quad	4596293229039181514
	.quad	4607004523081378245
	.quad	4604132524259225992
	.quad	4604930969611683613
	.quad	-4623956419292565384
	.quad	4606712271798845136
	.quad	4607014107203672838
	.quad	4596100498493145632
	.quad	4599508656458981180
	.quad	4606696480573970744
	.quad	4604963361023318192
	.quad	4604095588933135208
	.quad	-4627271538361630176
	.quad	4607014107203672838
	.quad	4606264365063040824
	.quad	4601595094712978766
	.quad	4589573280899107438
	.quad	4607161493757337631
	.quad	4603199756359801209
	.quad	4605650757533548011
	.quad	-4621776942141797044
	.quad	4606264365063040824
	.quad	4607108533908653467
	.quad	4593773291878075865
	.quad	4600610793188214614
	.quad	4606487355672395907
	.quad	4605336037775510797
	.quad	4603638947273499120
	.quad	-4629598744976699941
	.quad	4607108533908653467
	.quad	4606506155604540150
	.quad	4600520019085905968
	.quad	4593968117099574383
	.quad	4607102121601902643
	.quad	4603677922017902620
	.quad	4605306131402280410
	.quad	-4622852017768869840
	.quad	4606506155604540150
	.quad	4606881831024768235
	.quad	4598286619358767411
	.quad	4598381524643160709
	.quad	4606869116127612919
	.quad	4604561616407182174
	.quad	4604526878662140841
	.quad	-4625085417496008402
	.quad	4606881831024768235
	.quad	4605987935558566219
	.quad	4602636240804545080
	.quad	4568434626067268043
	.quad	4607182385306998657
	.quad	4602700074863679078
	.quad	4605963372263484363
	.quad	-4620735796050230730
	.quad	4605987935558566220
	.quad	4607182410426758828
	.quad	4563931032285532471
	.quad	4602657538342071525
	.quad	4605981816494854828
	.quad	4605969534835896644
	.quad	4602689451214676027
	.quad	-4659441004569243754
	.quad	4607182410426758828
	.quad	4606872319112771844
	.quad	4598357811347063510
	.quad	4598310358660753971
	.quad	4606878676567259509
	.quad	4604535580852680713
	.quad	4604552949741347819
	.quad	-4625014225507712301
	.quad	4606872319112771845
	.quad	4607103749581957238
	.quad	4593919423954624652
	.quad	4600542731816218872
	.quad	4606501478833505568
	.quad	4605313627917483261
	.quad	4603668193632800761
	.quad	-4629452612900151157
	.quad	4607103749581957238
	.quad	4606492078858695057
	.quad	4600588118909565877
	.quad	4593822011253318756
	.quad	4607106955738313152
	.quad	4603648706242483174
	.quad	4605328581117999225
	.quad	-4622783917945209929
	.quad	4606492078858695056
	.quad	4607162322080749021
	.quad	4589475251320810994
	.quad	4601617147062671906
	.quad	4606258955563514110
	.quad	4605657601731308352
	.quad	4603189558508366030
	.quad	-4633896785533964826
	.quad	4607162322080749021
	.quad	4606700452163177137
	.quad	4599485412905375736
	.quad	4596148700687351499
	.quad	4607011735812417609
	.quad	4604104839318682701
	.quad	4604955282063973119
	.quad	-4623886623949400073
	.quad	4606700452163177137
	.quad	4607006943746815520
	.quad	4596245066049952456
	.quad	4599438893413744980
	.quad	4606708347782954247
	.quad	4604939086343099989
	.quad	4604123306998895988
	.quad	-4627126970804823356
	.quad	4607006943746815520
	.quad	4606248091485805447
	.quad	4601661207403233488
	.quad	4589279165513073430
	.quad	4607163928598605027
	.quad	4603169134855941243
	.quad	4605671248379566884
	.quad	-4621710829451542319
	.quad	4606248091485805446
	.quad	4607177186019341476
	.quad	4585072534758145429
	.quad	4602141877784511905
	.quad	4606124642249656058
	.quad	4605817660142009120
	.quad	4602942057086038483
	.quad	-4638299502096630398
	.quad	4607177186019341476
	.quad	4606790998633999460
	.quad	4598924424543600424
	.quad	4597301453974045813
	.quad	4606949904265928939
	.quad	4604323501953081687
	.quad	4604757640213121863
	.quad	-4624447612311175384
	.quad	4606790998633999460
	.quad	4607060103742656697
	.quad	4595085413248585560
	.quad	4599994197802362922
	.quad	4606609429089646919
	.quad	4605130080850134386
	.quad	4603898814800428197
	.quad	-4628286623606190250
	.quad	4607060103742656698
	.quad	4606374475156388921
	.quad	4601128655746771647
	.quad	4591629513248701072
	.quad	4607140242153838379
	.quad	4603411724239405514
	.quad	4605503838583196903
	.quad	-4622243381108004159
	.quad	4606374475156388920
	.quad	4607137834527659210
	.quad	4591825073559315186
	.quad	4601083908071351531
	.quad	4606384612610368326
	.quad	4605489530998349544
	.quad	4603431690450936406
	.quad	-4631546963295460620
	.quad	4607137834527659210
	.quad	4606600776659733774
	.quad	4600040175712000429
	.quad	4594988472313241297
	.quad	4607064104995956826
	.quad	4603879827098909572
	.quad	4605145663654057306
	.quad	-4623331861142775380
	.quad	4606600776659733774
	.quad	4606944326519488765
	.quad	4597397140573459502
	.quad	4598877413284213253
	.quad	4606798128988813111
	.quad	4604740848918082093
	.quad	4604341429836335100
	.quad	-4625974896281316311
	.quad	4606944326519488765
	.quad	4606113063181744662
	.quad	4602185203609298695
	.quad	4584679732095612080
	.quad	4607177989708574759
	.quad	4602921197862878370
	.quad	4605830631240506060
	.quad	-4621186833245477116
	.quad	4606113063181744662
	.quad	4607181003756150655
	.quad	4580766125562695826
	.quad	4602400876579836453
	.quad	4606054284080304799
	.quad	4605894630825483803
	.quad	4602816375425185389
	.quad	-4642605911292079982
	.quad	4607181003756150655
	.quad	4606832817797585881
	.quad	4598641783261786998
	.quad	4597874641361635904
	.quad	4606915460403506440
	.quad	4604430378731565901
	.quad	4604656162529810761
	.quad	-4624730253592988811
	.quad	4606832817797585881
	.quad	4607083119092361754
	.quad	4594503132770914452
	.quad	4600269347994963435
	.quad	4606556575907459593
	.quad	4605222797787364836
	.quad	4603784255053832997
	.quad	-4628868904083861353
	.quad	4607083119092361754
	.quad	4606434382596373278
	.quad	4600859349492675146
	.quad	4592802047238420901
	.quad	4607124796955216399
	.quad	4603530932167831787
	.quad	4605417179274466282
	.quad	-4622512687362100666
	.quad	4606434382596373279
	.quad	4607151279858401530
	.quad	4590650963811243391
	.quad	4601351555619259129
	.quad	4606322874749098972
	.quad	4605574556855589164
	.quad	4603311312007724925
	.quad	-4632721073043532422
	.quad	4607151279858401530
	.quad	4606651749097420967
	.quad	4599763609795187984
	.quad	4595569443408176701
	.quad	4607039106942683643
	.quad	4603993112004042612
	.quad	4605051393318010647
	.quad	-4623608427059587823
	.quad	4606651749097420967
	.quad	4606976813332895741
	.quad	4596822127906551897
	.quad	4599158887886140139
	.quad	4606754386811148108
	.quad	4604840859907143989
	.quad	4604233179348778632
	.quad	-4626549908948223918
	.quad	4606976813332895741
	.quad	4606181649091171014
	.quad	4601924310228642826
	.quad	4587035941733640403
	.quad	4607172163503315671
	.quad	4603045818347947219
	.quad	4605751954047555642
	.quad	-4621447726626132979
	.quad	4606181649091171013
	.quad	4607170958238431750
	.quad	4587428481418827464
	.quad	4601880611296338212
	.quad	4606192872166325345
	.quad	4605738643392385781
	.quad	4603066462549215605
	.quad	-4635943555435948349
	.quad	4607170958238431750
	.quad	4606746872818013899
	.quad	4599205659522598131
	.quad	4596726089069585092
	.quad	4606981998933072153
	.quad	4604214979130726047
	.quad	4604857355623251481
	.quad	-4624166377332177678
	.quad	4606746872818013899
	.quad	4607034709694607715
	.quad	4595666109497074049
	.quad	4599717354902777262
	.quad	4606660024229992639
	.quad	4605035501928357982
	.quad	4604011842202172045
	.quad	-4627705927357701766
	.quad	4607034709694607715
	.quad	4606312372577412281
	.quad	4601395965572059100
	.quad	4590455114535274067
	.quad	4607153287199125943
	.quad	4603291114372049353
	.quad	4605588535843398639
	.quad	-4621976071282716708
	.quad	4606312372577412281
	.quad	4607121989688162221
	.quad	4592997266227455821
	.quad	4600814276074669631
	.quad	4606444152618603836
	.quad	4605402546923067475
	.quad	4603550661609780366
	.quad	-4630374770627319996
	.quad	4607121989688162221
	.quad	4606547548496669685
	.quad	4600315036612429534
	.quad	4594405942942555776
	.quad	4607086723279653821
	.quad	4603765014932392014
	.quad	4605238067833664598
	.quad	-4623057000242346273
	.quad	4606547548496669685
	.quad	4606909492004100100
	.quad	4597969950105880025
	.quad	4598594544965521556
	.quad	4606839562605110573
	.quad	4604639080151274423
	.quad	4604448029480292282
	.quad	-4625402086748895784
	.quad	4606909492004100100
	.quad	4606042352119632811
	.quad	4602443817697734463
	.quad	4579799588181162967
	.quad	4607181405654566259
	.quad	4602795306764651987
	.quad	4605907258894631099
	.quad	-4620928219157041346
	.quad	4606042352119632811
	.quad	4607182008513398300
	.quad	4576655723155766310
	.quad	4602529503899630973
	.quad	4606018312765185342
	.quad	4605932342431205454
	.quad	4602753066522535774
	.quad	-4646716313699009523
	.quad	4607182008513398300
	.quad	4606852858861772992
	.quad	4598499958890016110
	.quad	4598160370507668843
	.quad	4606897360381268630
	.quad	4604483190895213536
	.quad	4604604771307489638
	.quad	-4624872077964759700
	.quad	4606852858861772992
	.quad	4607093732804860901
	.quad	4594211447146509295
	.quad	4600406265287789378
	.quad	4606529306949061674
	.quad	4605268450235068206
	.quad	4603726410119919171
	.quad	-4629160589708266519
	.quad	4607093732804860901
	.quad	4606463508104083680
	.quad	4600723970215658093
	.quad	4593387516841433451
	.quad	4607116175565537463
	.quad	4603590000416661376
	.quad	4605373121081800114
	.quad	-4622648066639117720
	.quad	4606463508104083681
	.quad	4607157101557980607
	.quad	4590063288244975626
	.quad	4601484612811231028
	.quad	4606291186765935918
	.quad	4605616328318209580
	.quad	4603250605111318052
	.quad	-4633308748609800191
	.quad	4607157101557980607
	.quad	4606676385131008731
	.quad	4599624710576905572
	.quad	4595859295978548967
	.quad	4607025717569048531
	.quad	4604049172239548705
	.quad	4605003566209005345
	.quad	-4623747326277870235
	.quad	4606676385131008731
	.quad	4606992173608768590
	.quad	4596533843483499561
	.quad	4599299078978952321
	.quad	4606731653647381590
	.quad	4604890197849140555
	.quad	4604178444078245391
	.quad	-4626838193371276248
	.quad	4606992173608768590
	.quad	4606215139353108607
	.quad	4601793030607739124
	.quad	4588213395722755511
	.quad	4607168347015707097
	.quad	4603107641670790496
	.quad	4605711853435173540
	.quad	-4621579006247036687
	.quad	4606215139353108608
	.quad	4607174373295309332
	.quad	4586250711893276901
	.quad	4602011523644332036
	.quad	4606159024394663244
	.quad	4605778406216070590
	.quad	4603004421432096275
	.quad	-4637121324961498919
	.quad	4607174373295309332
	.quad	4606769223333647316
	.quad	4599065222535849996
	.quad	4597014034097161577
	.quad	4606966245800711339
	.quad	4604269444491739302
	.quad	4604807719881990778
	.quad	-4624306814318925815
	.quad	4606769223333647317
	.quad	4607047703645917976
	.quad	4595375969128558387
	.quad	4599855983318986494
	.quad	4606635009775858405
	.quad	4605083022566352665
	.quad	4603955521945377688
	.quad	-4627996067726217421
	.quad	4607047703645917976
	.quad	4606343697233849634
	.quad	4601262564698600408
	.quad	4591042527342232524
	.quad	4607147064929000837
	.quad	4603351592538653594
	.quad	4605546433898966185
	.quad	-4622109472156175397
	.quad	4606343697233849633
	.quad	4607130211796421065
	.quad	4592411429155411599
	.quad	4600949335629645719
	.quad	4606414658356225897
	.quad	4605446282294695063
	.quad	4603491353940551165
	.quad	-4630960607699364204
	.quad	4607130211796421065
	.quad	4606574443667329965
	.quad	4600177823899374830
	.quad	4594697392674331453
	.quad	4607075712002421065
	.quad	4603822610011686610
	.quad	4605192100571380958
	.quad	-4623194212955400978
	.quad	4606574443667329965
	.quad	4606927202156367399
	.quad	4597683830330471956
	.quad	4598736148614803096
	.quad	4606819135074952937
	.quad	4604690182564968804
	.quad	4604394937807918811
	.quad	-4625688206524303855
	.quad	4606927202156367399
	.quad	4606077972124859323
	.quad	4602314799906892009
	.quad	4582337847642658397
	.quad	4607179999036264739
	.quad	4602858409041771695
	.quad	4605869202555039498
	.quad	-4621057236947883799
	.quad	4606077972124859323
	.quad	4607179396222266473
	.quad	4583123637079594446
	.quad	4602271664991992983
	.quad	4606089728032575194
	.quad	4605856402542851116
	.quad	4602879373685222941
	.quad	-4640248399775181412
	.quad	4607179396222266473
	.quad	4606812197261602330
	.quad	4598783274969763894
	.quad	4597588329462603119
	.quad	4606932975422499257
	.quad	4604377147896570271
	.quad	4604707119968585406
	.quad	-4624588761885011915
	.quad	4606812197261602330
	.quad	4607071909154858557
	.quad	4594794461304689724
	.quad	4600131989101911912
	.quad	4606583283883528896
	.quad	4605176673629990322
	.quad	4603841724562855563
	.quad	-4628577575550086088
	.quad	4607071909154858557
	.quad	4606404704284997145
	.quad	4600994247679388903
	.quad	4592216032966442083
	.quad	4607132819330301682
	.quad	4603471505449560191
	.quad	4605460752747087501
	.quad	-4622377789175386904
	.quad	4606404704284997145
	.quad	4607144857371670751
	.quad	4591238238685216204
	.quad	4601217984392562162
	.quad	4606354017392057949
	.quad	4605532290139301540
	.quad	4603371675134342630
	.quad	-4632133798169559605
	.quad	4607144857371670751
	.quad	4606626545711356915
	.quad	4599902101263397544
	.quad	4595279162376694824
	.quad	4607051903037143178
	.quad	4603936662364397365
	.quad	4605098760189817064
	.quad	-4623469935591378268
	.quad	4606626545711356916
	.quad	4606960863947293495
	.quad	4597109900023608837
	.quad	4599018329518601823
	.quad	4606776545752673927
	.quad	4604791075819405574
	.quad	4604287509146945543
	.quad	-4626262136831166977
	.quad	4606960863947293496
	.quad	4606147622941568410
	.quad	4602055037479115325
	.quad	4585858027577810959
	.quad	4607175377805984971
	.quad	4602983669025380270
	.quad	4605791547532692377
	.quad	-4621316999375660483
	.quad	4606147622941568410
	.quad	4607166941077285882
	.quad	4588605764504132668
	.quad	4601749149502777340
	.quad	4606226183299137715
	.quad	4605698374332366575
	.quad	4603128176284850173
	.quad	-4634766272350643138
	.quad	4607166941077285882
	.quad	4606723948583067612
	.quad	4599345726104093235
	.quad	4596437638164100519
	.quad	4606997162608620121
	.quad	4604160109515526463
	.quad	4604906544114676340
	.quad	-4624026310750682574
	.quad	4606723948583067612
	.quad	4607021122758439211
	.quad	4595955814934409469
	.quad	4599578321832435280
	.quad	4606684470777778044
	.quad	4604987522116809533
	.quad	4604067771801174531
	.quad	-4627416221920366344
	.quad	4607021122758439211
	.quad	4606280503283703941
	.quad	4601528849438338424
	.quad	4589867314144636753
	.quad	4607158908547743684
	.quad	4603230293787527431
	.quad	4605630141598519964
	.quad	-4621843187416437388
	.quad	4606280503283703942
	.quad	4607113168753206187
	.quad	4593582545564104164
	.quad	4600678738446251703
	.quad	4606473093423387302
	.quad	4605358327810769897
	.quad	4603609609489033297
	.quad	-4629789491290671648
	.quad	4607113168753206187
	.quad	4606520092947904940
	.quad	4600451804667220563
	.quad	4594114142625275868
	.quad	4607097138090646467
	.quad	4603707045715989147
	.quad	4605283562364219830
	.quad	-4622920232187555245
	.quad	4606520092947904940
	.quad	4606891197248065704
	.quad	4598215350147172026
	.quad	4598452611814207470
	.quad	4606859410212027199
	.quad	4604587545097394147
	.quad	4604500701299914929
	.quad	-4625156686707603783
	.quad	4606891197248065704
	.quad	4606006205550189198
	.quad	4602572248346385972
	.quad	4574510225430680693
	.quad	4607182209469331309
	.quad	4602731895255091283
	.quad	4605944797712087653
	.quad	-4620799788508389833
	.quad	4606006205550189198
	.quad	4607182209469331309
	.quad	4574510225430680791
	.quad	4602572248346385973
	.quad	4606006205550189198
	.quad	4605944797712087653
	.quad	4602731895255091283
	.quad	-4648861811424095256
	.quad	4607182209469331310
	.quad	4606859410212027199
	.quad	4598452611814207469
	.quad	4598215350147172028
	.quad	4606891197248065703
	.quad	4604500701299914929
	.quad	4604587545097394147
	.quad	-4624919425040568340
	.quad	4606859410212027199
	.quad	4607097138090646467
	.quad	4594114142625275861
	.quad	4600451804667220562
	.quad	4606520092947904941
	.quad	4605283562364219831
	.quad	4603707045715989146
	.quad	-4629257894229499944
	.quad	4607097138090646467
	.quad	4606473093423387302
	.quad	4600678738446251701
	.quad	4593582545564104168
	.quad	4607113168753206187
	.quad	4603609609489033297
	.quad	4605358327810769897
	.quad	-4622693298408524107
	.quad	4606473093423387302
	.quad	4607158908547743684
	.quad	4589867314144636748
	.quad	4601528849438338426
	.quad	4606280503283703941
	.quad	4605630141598519964
	.quad	4603230293787527432
	.quad	-4633504722710139064
	.quad	4607158908547743684
	.quad	4606684470777778044
	.quad	4599578321832435280
	.quad	4595955814934409468
	.quad	4607021122758439211
	.quad	4604067771801174531
	.quad	4604987522116809533
	.quad	-4623793715022340534
	.quad	4606684470777778045
	.quad	4606997162608620121
	.quad	4596437638164100514
	.quad	4599345726104093236
	.quad	4606723948583067612
	.quad	4604906544114676340
	.quad	4604160109515526463
	.quad	-4626934398690675294
	.quad	4606997162608620121
	.quad	4606226183299137716
	.quad	4601749149502777338
	.quad	4588605764504132688
	.quad	4607166941077285882
	.quad	4603128176284850173
	.quad	4605698374332366575
	.quad	-4621622887351998470
	.quad	4606226183299137716
	.quad	4607175377805984971
	.quad	4585858027577810945
	.quad	4602055037479115327
	.quad	4606147622941568409
	.quad	4605791547532692378
	.quad	4602983669025380268
	.quad	-4637514009276964866
	.quad	4607175377805984971
	.quad	4606776545752673927
	.quad	4599018329518601823
	.quad	4597109900023608843
	.quad	4606960863947293495
	.quad	4604287509146945544
	.quad	4604791075819405573
	.quad	-4624353707336173987
	.quad	4606776545752673927
	.quad	4607051903037143178
	.quad	4595279162376694826
	.quad	4599902101263397545
	.quad	4606626545711356915
	.quad	4605098760189817064
	.quad	4603936662364397365
	.quad	-4628092874478080988
	.quad	4607051903037143178
	.quad	4606354017392057949
	.quad	4601217984392562161
	.quad	4591238238685216212
	.quad	4607144857371670751
	.quad	4603371675134342630
	.quad	4605532290139301540
	.quad	-4622154052462213652
	.quad	4606354017392057950
	.quad	4607132819330301682
	.quad	4592216032966442081
	.quad	4600994247679388906
	.quad	4606404704284997145
	.quad	4605460752747087501
	.quad	4603471505449560191
	.quad	-4631156003888333734
	.quad	4607132819330301683
	.quad	4606583283883528897
	.quad	4600131989101911909
	.quad	4594794461304689724
	.quad	4607071909154858557
	.quad	4603841724562855562
	.quad	4605176673629990322
	.quad	-4623240047752863898
	.quad	4606583283883528897
	.quad	4606932975422499258
	.quad	4597588329462603115
	.quad	4598783274969763896
	.quad	4606812197261602329
	.quad	4604707119968585407
	.quad	4604377147896570270
	.quad	-4625783707392172693
	.quad	4606932975422499258
	.quad	4606089728032575194
	.quad	4602271664991992983
	.quad	4583123637079594432
	.quad	4607179396222266473
	.quad	4602879373685222941
	.quad	4605856402542851116
	.quad	-4621100371862782823
	.quad	4606089728032575194
	.quad	4607179999036264739
	.quad	4582337847642658331
	.quad	4602314799906892008
	.quad	4606077972124859323
	.quad	4605869202555039498
	.quad	4602858409041771695
	.quad	-4641034189212117446
	.quad	4607179999036264739
	.quad	4606819135074952937
	.quad	4598736148614803097
	.quad	4597683830330471958
	.quad	4606927202156367399
	.quad	4604394937807918811
	.quad	4604690182564968803
	.quad	-4624635888239972711
	.quad	4606819135074952937
	.quad	4607075712002421065
	.quad	4594697392674331450
	.quad	4600177823899374832
	.quad	4606574443667329964
	.quad	4605192100571380958
	.quad	4603822610011686610
	.quad	-4628674644180444360
	.quad	4607075712002421065
	.quad	4606414658356225897
	.quad	4600949335629645719
	.quad	4592411429155411613
	.quad	4607130211796421065
	.quad	4603491353940551166
	.quad	4605446282294695062
	.quad	-4622422701225130087
	.quad	4606414658356225897
	.quad	4607147064929000837
	.quad	4591042527342232512
	.quad	4601262564698600409
	.quad	4606343697233849634
	.quad	4605546433898966185
	.quad	4603351592538653593
	.quad	-4632329509512543293
	.quad	4607147064929000837
	.quad	4606635009775858405
	.quad	4599855983318986493
	.quad	4595375969128558391
	.quad	4607047703645917975
	.quad	4603955521945377689
	.quad	4605083022566352665
	.quad	-4623516053535789316
	.quad	4606635009775858405
	.quad	4606966245800711339
	.quad	4597014034097161577
	.quad	4599065222535849995
	.quad	4606769223333647316
	.quad	4604807719881990778
	.quad	4604269444491739301
	.quad	-4626358002757614235
	.quad	4606966245800711339
	.quad	4606159024394663245
	.quad	4602011523644332033
	.quad	4586250711893276907
	.quad	4607174373295309332
	.quad	4603004421432096274
	.quad	4605778406216070591
	.quad	-4621360513210443774
	.quad	4606159024394663244
	.quad	4607168347015707097
	.quad	4588213395722755514
	.quad	4601793030607739123
	.quad	4606215139353108608
	.quad	4605711853435173540
	.quad	4603107641670790495
	.quad	-4635158641132020315
	.quad	4607168347015707097
	.quad	4606731653647381590
	.quad	4599299078978952319
	.quad	4596533843483499564
	.quad	4606992173608768590
	.quad	4604178444078245391
	.quad	4604890197849140555
	.quad	-4624072957875823490
	.quad	4606731653647381590
	.quad	4607025717569048531
	.quad	4595859295978548966
	.quad	4599624710576905575
	.quad	4606676385131008731
	.quad	4605003566209005345
	.quad	4604049172239548705
	.quad	-4627512740876226845
	.quad	4607025717569048531
	.quad	4606291186765935918
	.quad	4601484612811231029
	.quad	4590063288244975626
	.quad	4607157101557980607
	.quad	4603250605111318052
	.quad	4605616328318209580
	.quad	-4621887424043544782
	.quad	4606291186765935918
	.quad	4607116175565537463
	.quad	4593387516841433458
	.quad	4600723970215658094
	.quad	4606463508104083680
	.quad	4605373121081800114
	.quad	4603590000416661377
	.quad	-4629984520013342366
	.quad	4607116175565537463
	.quad	4606529306949061674
	.quad	4600406265287789377
	.quad	4594211447146509293
	.quad	4607093732804860901
	.quad	4603726410119919172
	.quad	4605268450235068206
	.quad	-4622965771566986435
	.quad	4606529306949061675
	.quad	4606897360381268631
	.quad	4598160370507668835
	.quad	4598499958890016111
	.quad	4606852858861772992
	.quad	4604604771307489639
	.quad	4604483190895213535
	.quad	-4625211666347106977
	.quad	4606897360381268631
	.quad	4606018312765185343
	.quad	4602529503899630970
	.quad	4576655723155766356
	.quad	4607182008513398300
	.quad	4602753066522535775
	.quad	4605932342431205453
	.quad	-4620842532955144833
	.quad	4606018312765185341
	.quad	4607181405654566259
	.quad	4579799588181162989
	.quad	4602443817697734464
	.quad	4606042352119632811
	.quad	4605907258894631099
	.quad	4602795306764651987
	.quad	-4643572448673612911
	.quad	4607181405654566259
	.quad	4606839562605110574
	.quad	4598594544965521554
	.quad	4597969950105880021
	.quad	4606909492004100100
	.quad	4604448029480292282
	.quad	4604639080151274423
	.quad	-4624777491889254254
	.quad	4606839562605110574
	.quad	4607086723279653821
	.quad	4594405942942555775
	.quad	4600315036612429537
	.quad	4606547548496669685
	.quad	4605238067833664597
	.quad	4603765014932392014
	.quad	-4628966093912220037
	.quad	4607086723279653821
	.quad	4606444152618603836
	.quad	4600814276074669628
	.quad	4592997266227455821
	.quad	4607121989688162221
	.quad	4603550661609780367
	.quad	4605402546923067475
	.quad	-4622557760780106179
	.quad	4606444152618603836
	.quad	4607153287199125943
	.quad	4590455114535274059
	.quad	4601395965572059102
	.quad	4606312372577412281
	.quad	4605588535843398640
	.quad	4603291114372049352
	.quad	-4632916922319501750
	.quad	4607153287199125943
	.quad	4606660024229992639
	.quad	4599717354902777261
	.quad	4595666109497074047
	.quad	4607034709694607715
	.quad	4604011842202172045
	.quad	4605035501928357982
	.quad	-4623654681951998549
	.quad	4606660024229992639
	.quad	4606981998933072152
	.quad	4596726089069585094
	.quad	4599205659522598136
	.quad	4606746872818013898
	.quad	4604857355623251482
	.quad	4604214979130726046
	.quad	-4626645947785190721
	.quad	4606981998933072153
	.quad	4606192872166325345
	.quad	4601880611296338211
	.quad	4587428481418827477
	.quad	4607170958238431750
	.quad	4603066462549215605
	.quad	4605738643392385780
	.quad	-4621491425558437602
	.quad	4606192872166325346
	.quad	4607172163503315672
	.quad	4587035941733640382
	.quad	4601924310228642827
	.quad	4606181649091171014
	.quad	4605751954047555642
	.quad	4603045818347947218
	.quad	-4636336095121135423
	.quad	4607172163503315672
	.quad	4606754386811148108
	.quad	4599158887886140138
	.quad	4596822127906551902
	.quad	4606976813332895741
	.quad	4604233179348778632
	.quad	4604840859907143989
	.quad	-4624213148968635671
	.quad	4606754386811148108
	.quad	4607039106942683643
	.quad	4595569443408176702
	.quad	4599763609795187983
	.quad	4606651749097420967
	.quad	4605051393318010647
	.quad	4603993112004042611
	.quad	-4627802593446599111
	.quad	4607039106942683644
	.quad	4606322874749098972
	.quad	4601351555619259130
	.quad	4590650963811243394
	.quad	4607151279858401530
	.quad	4603311312007724926
	.quad	4605574556855589163
	.quad	-4622020481235516677
	.quad	4606322874749098972
	.quad	4607124796955216399
	.quad	4592802047238420897
	.quad	4600859349492675144
	.quad	4606434382596373279
	.quad	4605417179274466283
	.quad	4603530932167831786
	.quad	-4630569989616354916
	.quad	4607124796955216399
	.quad	4606556575907459593
	.quad	4600269347994963435
	.quad	4594503132770914459
	.quad	4607083119092361754
	.quad	4603784255053832997
	.quad	4605222797787364836
	.quad	-4623102688859812371
	.quad	4606556575907459593
	.quad	4606915460403506440
	.quad	4597874641361635899
	.quad	4598641783261786999
	.quad	4606832817797585880
	.quad	4604656162529810762
	.quad	4604430378731565901
	.quad	-4625497395493139916
	.quad	4606915460403506441
	.quad	4606054284080304799
	.quad	4602400876579836452
	.quad	4580766125562695861
	.quad	4607181003756150655
	.quad	4602816375425185390
	.quad	4605894630825483802
	.quad	-4620971160274939357
	.quad	4606054284080304800
	.quad	4607177989708574759
	.quad	4584679732095612072
	.quad	4602185203609298698
	.quad	4606113063181744661
	.quad	4605830631240506059
	.quad	4602921197862878372
	.quad	-4638692304759163746
	.quad	4607177989708574759
	.quad	4606798128988813112
	.quad	4598877413284213249
	.quad	4597397140573459501
	.quad	4606944326519488765
	.quad	4604341429836335100
	.quad	4604740848918082092
	.quad	-4624494623570562561
	.quad	4606798128988813112
	.quad	4607064104995956826
	.quad	4594988472313241292
	.quad	4600040175712000430
	.quad	4606600776659733774
	.quad	4605145663654057307
	.quad	4603879827098909572
	.quad	-4628383564541534515
	.quad	4607064104995956826
	.quad	4606384612610368326
	.quad	4601083908071351530
	.quad	4591825073559315197
	.quad	4607137834527659210
	.quad	4603431690450936406
	.quad	4605489530998349543
	.quad	-4622288128783424276
	.quad	4606384612610368326
	.quad	4607140242153838379
	.quad	4591629513248701073
	.quad	4601128655746771651
	.quad	4606374475156388920
	.quad	4605503838583196902
	.quad	4603411724239405515
	.quad	-4631742523606074745
	.quad	4607140242153838379
	.quad	4606609429089646919
	.quad	4599994197802362920
	.quad	4595085413248585562
	.quad	4607060103742656697
	.quad	4603898814800428197
	.quad	4605130080850134385
	.quad	-4623377839052412888
	.quad	4606609429089646919
	.quad	4606949904265928939
	.quad	4597301453974045812
	.quad	4598924424543600423
	.quad	4606790998633999460
	.quad	4604757640213121864
	.quad	4604323501953081686
	.quad	-4626070582880729999
	.quad	4606949904265928939
	.quad	4606124642249656058
	.quad	4602141877784511905
	.quad	4585072534758145428
	.quad	4607177186019341476
	.quad	4602942057086038483
	.quad	4605817660142009120
	.quad	-4621230159070263904
	.quad	4606124642249656058
	.quad	4607163928598605027
	.quad	4589279165513073430
	.quad	4601661207403233488
	.quad	4606248091485805447
	.quad	4605671248379566884
	.quad	4603169134855941242
	.quad	-4634092871341702387
	.quad	4607163928598605027
	.quad	4606708347782954246
	.quad	4599438893413744981
	.quad	4596245066049952457
	.quad	4607006943746815520
	.quad	4604123306998895989
	.quad	4604939086343099989
	.quad	-4623933143441030826
	.quad	4606708347782954246
	.quad	4607011735812417609
	.quad	4596148700687351496
	.quad	4599485412905375737
	.quad	4606700452163177137
	.quad	4604955282063973119
	.quad	4604104839318682701
	.quad	-4627223336167424313
	.quad	4607011735812417609
	.quad	4606258955563514111
	.quad	4601617147062671901
	.quad	4589475251320810991
	.quad	4607162322080749021
	.quad	4603189558508366030
	.quad	4605657601731308352
	.quad	-4621754889792103904
	.quad	4606258955563514110
	.quad	4607106955738313153
	.quad	4593822011253318750
	.quad	4600588118909565878
	.quad	4606492078858695056
	.quad	4605328581117999225
	.quad	4603648706242483173
	.quad	-4629550025601457057
	.quad	4607106955738313153
	.quad	4606501478833505567
	.quad	4600542731816218875
	.quad	4593919423954624656
	.quad	4607103749581957238
	.quad	4603668193632800762
	.quad	4605313627917483260
	.quad	-4622829305038556938
	.quad	4606501478833505568
	.quad	4606878676567259509
	.quad	4598310358660753970
	.quad	4598357811347063513
	.quad	4606872319112771844
	.quad	4604552949741347820
	.quad	4604535580852680713
	.quad	-4625061678194021840
	.quad	4606878676567259509
	.quad	4605981816494854828
	.quad	4602657538342071523
	.quad	4563931032285532618
	.quad	4607182410426758828
	.quad	4602689451214676027
	.quad	4605969534835896643
	.quad	-4620714498512704291
	.quad	4605981816494854830
	.quad	4607182416706702520
	.quad	4559427434119571345
	.quad	4602668180848201710
	.quad	4605978751519419632
	.quad	4605972610688513383
	.quad	4602684136241554624
	.quad	-4663944602735204139
	.quad	4607182416706702520
	.quad	4606873914541984184
	.quad	4598345951428981241
	.quad	4598322225080312360
	.quad	4606877093269966767
	.quad	4604539927514429107
	.quad	4604548611960780965
	.quad	-4625026085425794564
	.quad	4606873914541984184
	.quad	4607104557347077838
	.quad	4593895074063746518
	.quad	4600554083393379395
	.quad	4606499134642260531
	.quad	4605317371198957758
	.quad	4603663325609341100
	.quad	-4629476962791029294
	.quad	4607104557347077838
	.quad	4606494434653762976
	.quad	4600576776945326984
	.quad	4593846367701773984
	.quad	4607106160425628358
	.quad	4603653581911917827
	.quad	4605324847800953336
	.quad	-4622795259909448824
	.quad	4606494434653762976
	.quad	4607162729976617532
	.quad	4589426233166093168
	.quad	4601628167700348483
	.quad	4606256245177028475
	.quad	4605661018614162445
	.quad	4603184456085396252
	.quad	-4633945803688682642
	.quad	4607162729976617532
	.quad	4606702432014330563
	.quad	4599473787072414369
	.quad	4596172796923027750
	.quad	4607010543955571845
	.quad	4604109460378317621
	.quad	4604951237856207483
	.quad	-4623898249782361441
	.quad	4606702432014330563
	.quad	4607008147922213952
	.quad	4596220979615526104
	.quad	4599450527321193318
	.quad	4606706379825136607
	.quad	4604943139993888937
	.quad	4604118694220570252
	.quad	-4627151057239249702
	.quad	4607008147922213952
	.quad	4606250813136911712
	.quad	4601650197875749190
	.quad	4589328190239438747
	.quad	4607163533235732216
	.quad	4603174244256810581
	.quad	4605667841939877484
	.quad	-4621721838979026623
	.quad	4606250813136911713
	.quad	4607177393218184432
	.quad	4584974337402918349
	.quad	4602152715158881250
	.quad	4606121753021766846
	.quad	4605820908248821602
	.quad	4602936845597696767
	.quad	-4638397699451857459
	.quad	4607177393218184432
	.quad	4606792787231820016
	.quad	4598912675377427895
	.quad	4597325381322444310
	.quad	4606948515945535562
	.quad	4604327988215774574
	.quad	4604753446973842793
	.quad	-4624459361477347914
	.quad	4606792787231820016
	.quad	4607061110251813821
	.quad	4595061182112279478
	.quad	4600005696701321863
	.quad	4606607271860107869
	.quad	4605133981404671857
	.quad	4603894071860105851
	.quad	-4628310854742496336
	.quad	4607061110251813821
	.quad	4606377015239468305
	.quad	4601117474014070327
	.quad	4591678408239329300
	.quad	4607139646497137519
	.quad	4603416719449055315
	.quad	4605500266792447759
	.quad	-4622254562840705481
	.quad	4606377015239468305
	.quad	4607138442683768163
	.quad	4591776188417360918
	.quad	4601095100171160486
	.quad	4606382083967636003
	.quad	4605493112998361505
	.quad	4603426702557140881
	.quad	-4631595848437414895
	.quad	4607138442683768163
	.quad	4606602945644145865
	.quad	4600028685661483354
	.quad	4595012711633342579
	.quad	4607063110878928841
	.quad	4603884578007140124
	.quad	4605141772808444075
	.quad	-4623343351193292456
	.quad	4606602945644145865
	.quad	4606945727071667327
	.quad	4597373224633270164
	.quad	4598889169742271490
	.quad	4606796352410055405
	.quad	4604745051324371720
	.quad	4604336952159484542
	.quad	-4625998812221505651
	.quad	4606945727071667327
	.quad	4606115963486465634
	.quad	4602174378076309206
	.quad	4584777936026007101
	.quad	4607177795062894465
	.quad	4602926415983692821
	.quad	4605827393799577343
	.quad	-4621197658778466603
	.quad	4606115963486465634
	.quad	4607181110509834250
	.quad	4580569648657828583
	.quad	4602411617957949545
	.quad	4606051306580068190
	.quad	4605897793228524295
	.quad	4602811111489812438
	.quad	-4642802388196947253
	.quad	4607181110509834250
	.quad	4606834510037629118
	.quad	4598629977139267359
	.quad	4597898474645766781
	.quad	4606913974395743274
	.quad	4604434795785062556
	.quad	4604651896448821280
	.quad	-4624742059715508452
	.quad	4606834510037629118
	.quad	4607084026350948147
	.quad	4594478839005308095
	.quad	4600280774762634174
	.quad	4606554324895742416
	.quad	4605226620217049248
	.quad	4603779448928584021
	.quad	-4628893197849467713
	.quad	4607084026350948147
	.quad	4606436830863177043
	.quad	4600848086136468632
	.quad	4592850857716062808
	.quad	4607124101377412073
	.quad	4603535868268130717
	.quad	4605413526231564807
	.quad	-4622523950718307178
	.quad	4606436830863177043
	.quad	4607151787952404787
	.quad	4590602005609260083
	.quad	4601362663474922676
	.quad	4606320254883789346
	.quad	4605578056765527452
	.quad	4603306266173896409
	.quad	-4632770031245515738
	.quad	4607151787952404787
	.quad	4606653823792926802
	.quad	4599752050306071385
	.quad	4595593614421647855
	.quad	4607038013809417665
	.quad	4603997798615334932
	.quad	4605047425260148693
	.quad	-4623619986548704423
	.quad	4606653823792926802
	.quad	4606978115871044718
	.quad	4596798123505964811
	.quad	4599170584634644635
	.quad	4606752514292201134
	.quad	4604844988488343787
	.quad	4604228633512675362
	.quad	-4626573913348810992
	.quad	4606978115871044717
	.quad	4606184460445418389
	.quad	4601913391236766855
	.quad	4587134081562405848
	.quad	4607171868459543943
	.quad	4603050982800113475
	.quad	4605748631662505176
	.quad	-4621458645618008956
	.quad	4606184460445418390
	.quad	4607171265826961928
	.quad	4587330351450613419
	.quad	4601891541765536631
	.quad	4606190071984299702
	.quad	4605741976333373516
	.quad	4603061304903146573
	.quad	-4636041685404162408
	.quad	4607171265826961928
	.quad	4606748757294760886
	.quad	4599193970458308603
	.quad	4596750104076321473
	.quad	4606980708671735502
	.quad	4604219533401534161
	.quad	4604853236348314374
	.quad	-4624178066396467209
	.quad	4606748757294760887
	.quad	4607035815184868730
	.quad	4595641947477329360
	.quad	4599728922854491096
	.quad	4606657961360174228
	.quad	4605039479563475745
	.quad	4604007163716576141
	.quad	-4627730089377446450
	.quad	4607035815184868730
	.quad	4606315003796725624
	.quad	4601384868456483201
	.quad	4590504080948517286
	.quad	4607152791623000251
	.quad	4603296167353711611
	.quad	4605585046261056581
	.quad	-4621987168398292605
	.quad	4606315003796725623
	.quad	4607122697743558773
	.quad	4592948467233265179
	.quad	4600825549422228237
	.quad	4606441715875427621
	.quad	4605406210054165091
	.quad	4603545732991397614
	.quad	-4630423569621510628
	.quad	4607122697743558773
	.quad	4606549811189298456
	.quad	4600303619076676347
	.quad	4594430244079835075
	.quad	4607085828445012995
	.quad	4603769828865627783
	.quad	4605234255241973544
	.quad	-4623068417778099462
	.quad	4606549811189298456
	.quad	4606910990195346563
	.quad	4597946129028963935
	.quad	4598606357985645436
	.quad	4606837882442175227
	.quad	4604643355257568099
	.quad	4604443621161476804
	.quad	-4625425907825811877
	.quad	4606910990195346563
	.quad	4606045340598345673
	.quad	4602433088521888411
	.quad	4580176688089394183
	.quad	4607181311459088754
	.quad	4602800577157097510
	.quad	4605904107264565353
	.quad	-4620938948332887398
	.quad	4606045340598345674
	.quad	4607182065032103403
	.quad	4576262726601182000
	.quad	4602540196199582008
	.quad	4606015291426237060
	.quad	4605935461663422552
	.quad	4602747776891265360
	.quad	-4647109310253593889
	.quad	4607182065032103403
	.quad	4606854502751415327
	.quad	4598488125473697068
	.quad	4598179686955260811
	.quad	4606895825677380150
	.quad	4604487572899484576
	.quad	4604600469232737882
	.quad	-4624883911381078744
	.quad	4606854502751415327
	.quad	4607094590345412920
	.quad	4594187124504283497
	.quad	4600417654841368746
	.quad	4606527009270686273
	.quad	4605272233217249255
	.quad	4603721572883681506
	.quad	-4629184912350492314
	.quad	4607094590345412920
	.quad	4606465910215408778
	.quad	4600712667177166968
	.quad	4593436280160626916
	.quad	4607115430095344936
	.quad	4603594906465714411
	.quad	4605369427778226029
	.quad	-4622659369677608838
	.quad	4606465910215408778
	.quad	4607157559568244300
	.quad	4590014298427127768
	.quad	4601495677428190477
	.quad	4606288521550843979
	.quad	4605619786830348624
	.quad	4603245530813102021
	.quad	-4633357738427648055
	.quad	4607157559568244300
	.quad	4606678412472185529
	.quad	4599613117527892654
	.quad	4595883430410807577
	.quad	4607024575035756546
	.quad	4604053826230763179
	.quad	4604999559942117492
	.quad	-4623758919326883155
	.quad	4606678412472185529
	.quad	4606993427007488639
	.quad	4596509797261259983
	.quad	4599310744697334628
	.quad	4606729733344734277
	.quad	4604894289102053137
	.quad	4604173864617774285
	.quad	-4626862239593515822
	.quad	4606993427007488639
	.quad	4606217905948372534
	.quad	4601782065981115886
	.quad	4588311493646456801
	.quad	4607168001800831838
	.quad	4603112778769226855
	.quad	4605708488910206136
	.quad	-4621589970873659921
	.quad	4606217905948372534
	.quad	4607174630697610145
	.quad	4586152544946293183
	.quad	4602022407930370330
	.quad	4606156179594501500
	.quad	4605781696850095328
	.quad	4602999236691377941
	.quad	-4637219491908482619
	.quad	4607174630697610145
	.quad	4606771059932394853
	.quad	4599053503028412962
	.quad	4597038006076977276
	.quad	4606964906465024006
	.quad	4604273964909770485
	.quad	4604803563485784391
	.quad	-4624318533826362846
	.quad	4606771059932394853
	.quad	4607048759680968401
	.quad	4595351771740741223
	.quad	4599867517130314366
	.quad	4606632899655562214
	.quad	4605086961793010765
	.quad	4603950811074764180
	.quad	-4628020265114034590
	.quad	4607048759680968401
	.quad	4606346282971580510
	.quad	4601251424901656434
	.quad	4591091459681741947
	.quad	4607146519294327306
	.quad	4603356616802452049
	.quad	4605542903094258383
	.quad	-4622120611953119377
	.quad	4606346282971580511
	.quad	4607130869924198776
	.quad	4592362585452731755
	.quad	4600960568729257341
	.quad	4606412175580182840
	.quad	4605449904981486987
	.quad	4603486395518523066
	.quad	-4631009451402044054
	.quad	4607130869924198776
	.quad	4606576659580008312
	.quad	4600166369722913284
	.quad	4594721663715278409
	.quad	4607074767494977695
	.quad	4603827392592474014
	.quad	4605188248723822567
	.quad	-4623205667131862526
	.quad	4606576659580008312
	.quad	4606928651576586329
	.quad	4597659961023107031
	.quad	4598747933748296409
	.quad	4606817406646262673
	.quad	4604694421463119771
	.quad	4604390494661391084
	.quad	-4625712075831668783
	.quad	4606928651576586329
	.quad	4606080916615116795
	.quad	4602304022191786333
	.quad	4582534299887998165
	.quad	4607179854610852487
	.quad	4602863653473912280
	.quad	4605866007912630101
	.quad	-4621068014662989479
	.quad	4606080916615116796
	.quad	4607179553203783305
	.quad	4582927194697776769
	.quad	4602282454729324440
	.quad	4606086794570340795
	.quad	4605859607905048518
	.quad	4602874135798074044
	.quad	-4640444842156999052
	.quad	4607179553203783305
	.quad	4606813937738781179
	.quad	4598771496931253000
	.quad	4597612210578075185
	.quad	4606931538210323125
	.quad	4604381599703649585
	.quad	4604702890166896238
	.quad	-4624600539923522810
	.quad	4606813937738781179
	.quad	4607072866070754542
	.quad	4594770198041737141
	.quad	4600143452318855713
	.quad	4606581079689135032
	.quad	4605180535251334602
	.quad	4603836949870279646
	.quad	-4628601838813038665
	.quad	4607072866070754542
	.quad	4606407198543411778
	.quad	4600983024759347817
	.quad	4592264887335541510
	.quad	4607132173691442086
	.quad	4603476471270721138
	.quad	4605457140209364706
	.quad	-4622389012095427992
	.quad	4606407198543411778
	.quad	4607145415515405740
	.quad	4591189315375975908
	.quad	4601229134743456973
	.quad	4606351443051883894
	.quad	4605535831212782522
	.quad	4603366658102630213
	.quad	-4632182721478799893
	.quad	4607145415515405740
	.quad	4606628667622327925
	.quad	4599890576107878903
	.quad	4595303368353560271
	.quad	4607050859377068981
	.quad	4603941381282082491
	.quad	4605094830606571713
	.quad	-4623481460746896905
	.quad	4606628667622327925
	.quad	4606962215537689701
	.quad	4597085939051340748
	.quad	4599030056514339800
	.quad	4606774721142759040
	.quad	4604795241452557710
	.quad	4604282997239472761
	.quad	-4626286097803435069
	.quad	4606962215537689701
	.quad	4606150478866629207
	.quad	4602044164852818385
	.quad	4585956202742929394
	.quad	4607175132953064692
	.quad	4602988860485608459
	.quad	4605788267509933274
	.quad	-4621327872001957421
	.quad	4606150478866629207
	.quad	4607167298831457857
	.quad	4588507678082739541
	.quad	4601760125423535910
	.quad	4606223427922670419
	.quad	4605701749357236351
	.quad	4603123046078642862
	.quad	-4634864358772036279
	.quad	4607167298831457857
	.quad	4606725880811681941
	.quad	4599334068265325592
	.quad	4596461694590381176
	.quad	4606995921507994138
	.quad	4604164697334284303
	.quad	4604902462236720503
	.quad	-4624037968589450218
	.quad	4606725880811681941
	.quad	4607022277629917959
	.quad	4595931689899953552
	.quad	4599589923150267028
	.quad	4606682455296509756
	.quad	4604991537894155224
	.quad	4604063126013737405
	.quad	-4627440346954822264
	.quad	4607022277629917959
	.quad	4606283179808486545
	.quad	4601517795746884574
	.quad	4589916311354185675
	.quad	4607158463063335815
	.quad	4603235375148846488
	.quad	4605626693472108951
	.quad	-4621854241107891236
	.quad	4606283179808486545
	.quad	4607113926688829899
	.quad	4593533794544625065
	.quad	4600690051287207736
	.quad	4606470702876174426
	.quad	4605362031140991909
	.quad	4603604711004178991
	.quad	-4629838242310150754
	.quad	4607113926688829899
	.quad	4606522402269037218
	.quad	4600440424536376123
	.quad	4594138472232359769
	.quad	4607096292988701405
	.quad	4603711890679466304
	.quad	4605279789283581132
	.quad	-4622931612318399686
	.quad	4606522402269037218
	.quad	4606892744110062517
	.quad	4598203464521136525
	.quad	4598464451930290909
	.quad	4606857778427303712
	.quad	4604591856125688410
	.quad	4604496328103870024
	.quad	-4625168572333639280
	.quad	4606892744110062516
	.quad	4606009237817332102
	.quad	4602561568427926510
	.quad	4575296231692386013
	.quad	4607182165510093259
	.quad	4602737191255082965
	.quad	4605941689305310984
	.quad	-4620810468426849300
	.quad	4606009237817332103
	.quad	4607182316227778595
	.quad	4572152186185973065
	.quad	4602604263259349471
	.quad	4605997086914916976
	.quad	4605954101258414710
	.quad	4602715994557056819
	.quad	-4651219850668802804
	.quad	4607182316227778595
	.quad	4606864281344218837
	.quad	4598417078154479572
	.quad	4598250994331377453
	.quad	4606886532357356880
	.quad	4604513803239070054
	.quad	4604574594137483070
	.quad	-4624954958700296241
	.quad	4606864281344218838
	.quad	4607099648512976976
	.quad	4594041140055242705
	.quad	4600485926129646205
	.quad	4606513141716163245
	.quad	4605294861774986425
	.quad	4603692495407106833
	.quad	-4629330896799533102
	.quad	4607099648512976976
	.quad	4606480241919017736
	.quad	4600644780402582223
	.quad	4593700196789227094
	.quad	4607110870021103616
	.quad	4603624289778765465
	.quad	4605347197794344820
	.quad	-4622727256452193582
	.quad	4606480241919017736
	.quad	4607160219945936777
	.quad	4589720308096974040
	.quad	4601561988579477979
	.quad	4606272451109874718
	.quad	4605640465180648579
	.quad	4603215035615150747
	.quad	-4633651728757801761
	.quad	4607160219945936777
	.quad	4606690493486771347
	.quad	4599543501427576928
	.quad	4596028171062750858
	.quad	4607017633476212424
	.quad	4604081692721376920
	.quad	4604975455793717488
	.quad	-4623828535427198879
	.quad	4606690493486771347
	.quad	4607000861305074220
	.quad	4596365448656077996
	.quad	4599380683774464437
	.quad	4606718128059654934
	.quad	4604918770968269291
	.quad	4604146329376794963
	.quad	-4627006588198697814
	.quad	4607000861305074220
	.quad	4606234426970449535
	.quad	4601716199233853061
	.quad	4588900000034226888
	.quad	4607165842738831298
	.quad	4603143553080857729
	.quad	4605688228283047508
	.quad	-4621655837620922749
	.quad	4606234426970449536
	.quad	4607176087264157951
	.quad	4585563486376305992
	.quad	4602087631957658868
	.quad	4606139032937822103
	.quad	4605801366354040130
	.quad	4602968081244281479
	.quad	-4637808550478469829
	.quad	4607176087264157951
	.quad	4606781995591178184
	.quad	4598983133641995584
	.quad	4597181760747116282
	.quad	4606956784676733145
	.quad	4604301027814688313
	.quad	4604778560477032969
	.quad	-4624388903212780223
	.quad	4606781995591178184
	.quad	4607055009259645911
	.quad	4595206527448016521
	.quad	4599936659332619021
	.quad	4606620156412869300
	.quad	4605110529623499026
	.quad	4603922489552289361
	.quad	-4628165509406759287
	.quad	4607055009259645911
	.quad	4606361717598315942
	.quad	4601184512314895707
	.quad	4591384990188554545
	.quad	4607143157926487939
	.quad	4603386711727993045
	.quad	4605521646407642239
	.quad	-4622187524539880098
	.quad	4606361717598315941
	.quad	4607134731264236857
	.quad	4592069448889627078
	.quad	4601027895996902098
	.quad	4606397198563554426
	.quad	4605471570035246658
	.quad	4603456593224738767
	.quad	-4631302587965148741
	.quad	4607134731264236857
	.quad	4606589873013743602
	.quad	4600097581455363124
	.quad	4594867235357110506
	.quad	4607069013597376139
	.quad	4603856032828647537
	.quad	4605165069247099832
	.quad	-4623274455399412689
	.quad	4606589873013743603
	.quad	4606937262632247917
	.quad	4597516662677569726
	.quad	4598818594807735793
	.quad	4606806951746026847
	.quad	4604719791149268272
	.quad	4604363775187332982
	.quad	-4625855374177206086
	.quad	4606937262632247917
	.quad	4606098506341411120
	.quad	4602239271815784158
	.quad	4583712943037066990
	.quad	4607178900166668444
	.quad	4602895074217729325
	.quad	4605846765040516024
	.quad	-4621132765038991656
	.quad	4606098506341411121
	.quad	4607180407199212417
	.quad	4581748472640595084
	.quad	4602347108927598579
	.quad	4606069116619933657
	.quad	4605878765018928309
	.quad	4602842662694366087
	.quad	-4641623564214180713
	.quad	4607180407199212417
	.quad	4606824296251186724
	.quad	4598700779112000447
	.quad	4597755414458832175
	.quad	4606922829490398604
	.quad	4604408249893351342
	.quad	4604677447709112537
	.quad	-4624671257742775362
	.quad	4606824296251186724
	.quad	4607078520700815925
	.quad	4594624564176000690
	.quad	4600212168262606645
	.quad	4606567772509200137
	.quad	4605203636537833820
	.quad	4603808246528465562
	.quad	-4628747472678775122
	.quad	4607078520700815925
	.quad	4606422083701142303
	.quad	4600915616055205030
	.quad	4592557938567358990
	.quad	4607128212440140362
	.quad	4603506214371490808
	.quad	4605435393963118047
	.quad	-4622456420799570780
	.quad	4606422083701142304
	.quad	4607148676810834843
	.quad	4590895712627068979
	.quad	4601295962898679665
	.quad	4606335917244768060
	.quad	4605557005749280054
	.quad	4603336505320447971
	.quad	-4632476324227706832
	.quad	4607148676810834843
	.quad	4606641316539699001
	.quad	4599821364659156750
	.quad	4595448543933954641
	.quad	4607044510798662165
	.quad	4603969638428036749
	.quad	4605071185628844198
	.quad	-4623550672195619055
	.quad	4606641316539699000
	.quad	4606970239288389327
	.quad	4596942096320892510
	.quad	4599100365994398371
	.quad	4606763689573392520
	.quad	4604820170565803249
	.quad	4604255866250143101
	.quad	-4626429940533883297
	.quad	4606970239288389327
	.quad	4606167536524188570
	.quad	4601978847547674876
	.quad	4586545195567892398
	.quad	4607173575991554278
	.quad	4603019962176669799
	.quad	4605768513115932446
	.quad	-4621393189307100932
	.quad	4606167536524188570
	.quad	4607169357579166271
	.quad	4587919079676579140
	.quad	4601825901817789565
	.quad	4606206817150293377
	.quad	4605721925985244332
	.quad	4603092216629224449
	.quad	-4635452957178196699
	.quad	4607169357579166271
	.quad	4606737390689102768
	.quad	4599264066151329725
	.quad	4596605961563300896
	.quad	4606988388825736053
	.quad	4604192165709024149
	.quad	4604877905370911399
	.quad	-4624107970703446088
	.quad	4606737390689102768
	.quad	4607029120484048262
	.quad	4595786874065649901
	.quad	4599659473100085931
	.quad	4606670279402733034
	.quad	4605015565958954415
	.quad	4604035193892958257
	.quad	-4627585162789125905
	.quad	4607029120484048262
	.quad	4606299159772004083
	.quad	4601451397191623388
	.quad	4590210242550778924
	.quad	4607155702478878255
	.quad	4603265813842019521
	.quad	4605605932036052334
	.quad	-4621920639663152417
	.quad	4606299159772004082
	.quad	4607118387039702860
	.quad	4593241202647068882
	.quad	4600757859642136985
	.quad	4606456278659742940
	.quad	4605384180911754946
	.quad	4603575267177587328
	.quad	-4630130834207706931
	.quad	4607118387039702860
	.quad	4606536176681580999
	.quad	4600372077866280536
	.quad	4594284400962581034
	.quad	4607091135312362631
	.quad	4603740906338175323
	.quad	4605257081513569597
	.quad	-4622999958988495275
	.quad	4606536176681581000
	.quad	4606901940165298243
	.quad	4598088993900802442
	.quad	4598535445651436841
	.quad	4606847902995228183
	.quad	4604617659592661429
	.quad	4604470027298532783
	.quad	-4625283042953973366
	.quad	4606901940165298243
	.quad	4606027354903166326
	.quad	4602497402316307045
	.quad	4577834696744284995
	.quad	4607181813838763374
	.quad	4602768922639562811
	.quad	4605922963106865834
	.quad	-4620874634538468767
	.quad	4606027354903166327
	.quad	4607181663123880230
	.quad	4578620663913945907
	.quad	4602475980740940559
	.quad	4606033364748761771
	.quad	4605916692215435326
	.quad	4602779482712362911
	.quad	-4644751372940829905
	.quad	4607181663123880230
	.quad	4606844578927199936
	.quad	4598559092197791028
	.quad	4598041388745036957
	.quad	4606904973074530421
	.quad	4604461236934587867
	.quad	4604626236813574551
	.quad	-4624812944656984782
	.quad	4606844578927199936
	.quad	4607089382929024551
	.quad	4594333024968094861
	.quad	4600349270670938096
	.quad	4606540737073782282
	.quad	4605249485904392423
	.quad	4603750557552508465
	.quad	-4629039011886680953
	.quad	4607089382929024551
	.quad	4606451439782750094
	.quad	4600780436133124266
	.quad	4593143639880204313
	.quad	4607119840572048087
	.quad	4603565432464438914
	.quad	4605391537380620171
	.quad	-4622591600721651546
	.quad	4606451439782750095
	.quad	4607154748888056495
	.quad	4590308199237181438
	.quad	4601429235356077848
	.quad	4606304456231027780
	.quad	4605598983909275717
	.quad	4603275941168970531
	.quad	-4633063837617594376
	.quad	4607154748888056495
	.quad	4606666189172726071
	.quad	4599682634208467591
	.quad	4595738577389159329
	.quad	4607031368518050325
	.quad	4604025861372769490
	.quad	4605023549898070094
	.quad	-4623689402646308216
	.quad	4606666189172726070
	.quad	4606985845153856138
	.quad	4596654023015670788
	.quad	4599240711260102262
	.quad	4606741195486182106
	.quad	4604869694804898265
	.quad	4604201299482757968
	.quad	-4626718013839105020
	.quad	4606985845153856138
	.quad	4606201250347128809
	.quad	4601847797015382055
	.quad	4587722850872574792
	.quad	4607170010385606010
	.quad	4603081921836867942
	.quad	4605728623482330037
	.quad	-4621524239839393750
	.quad	4606201250347128808
	.quad	4607173023542913905
	.quad	4586741503256097307
	.quad	4601957044168416547
	.quad	4606173192704888124
	.quad	4605761900066119194
	.quad	4603030311417658590
	.quad	-4636630533598678506
	.quad	4607173023542913905
	.quad	4606759980438457619
	.quad	4599123782359181257
	.quad	4596894119717490187
	.quad	4606972881174505359
	.quad	4604246799953867691
	.quad	4604828455581718930
	.quad	-4624248254495594549
	.quad	4606759980438457618
	.quad	4607042361620356188
	.quad	4595496912560064662
	.quad	4599798271251372056
	.quad	4606645501374952515
	.quad	4605063278307570205
	.quad	4603979035953623120
	.quad	-4627875124294711144
	.quad	4607042361620356187
	.quad	4606330711617531337
	.quad	4601318210654696745
	.quad	4590797821630570130
	.quad	4607149730544409479
	.quad	4603326435176014067
	.quad	4605564036496605687
	.quad	-4622053826200079064
	.quad	4606330711617531337
	.quad	4607126858728266152
	.quad	4592655593201588214
	.quad	4600893119494820869
	.quad	4606427014766909160
	.quad	4605428118199606249
	.quad	4603516108939808677
	.quad	-4630716443653187603
	.quad	4607126858728266152
	.quad	4606563305564041852
	.quad	4600235049313092100
	.quad	4594575999143712764
	.quad	4607080372475452902
	.quad	4603798657777859812
	.quad	4605211310850747516
	.quad	-4623136987541683710
	.quad	4606563305564041852
	.quad	4606919894048772315
	.quad	4597803117272054916
	.quad	4598677187746332717
	.quad	4606827716935819873
	.quad	4604668942690440001
	.quad	4604417110134558917
	.quad	-4625568919582720893
	.quad	4606919894048772315
	.quad	4606063194601913507
	.quad	4602368628120840483
	.quad	4581355541664009668
	.quad	4607180658379475773
	.quad	4602832154278008491
	.quad	4605885122093926452
	.quad	-4621003408733935326
	.quad	4606063194601913507
	.quad	4607178548537836914
	.quad	4584105795105686265
	.quad	4602217656444993034
	.quad	4606104340135482488
	.quad	4605840322207443041
	.quad	4602905530274293359
	.quad	-4639266241749089582
	.quad	4607178548537836914
	.quad	4606803434673742624
	.quad	4598842129413695880
	.quad	4597468865399742294
	.quad	4606940100409792856
	.quad	4604354845661897876
	.quad	4604728223396440907
	.quad	-4624529907441079928
	.quad	4606803434673742624
	.quad	4607067062555383551
	.quad	4594915738165609768
	.quad	4600074628081212906
	.quad	4606594246212876579
	.quad	4605157316744107993
	.quad	4603865558473730057
	.quad	-4628456298689166042
	.quad	4607067062555383551
	.quad	4606392175639060468
	.quad	4601050311120939642
	.quad	4591971708924269279
	.quad	4607135985065033184
	.quad	4603446639463516324
	.quad	4605478764606422424
	.quad	-4622321725733836169
	.quad	4606392175639060469
	.quad	4607142004120689097
	.quad	4591482808943093396
	.quad	4601162180127497568
	.quad	4606366832045341789
	.quad	4605514533510350730
	.quad	4603396724015893274
	.quad	-4631889227911682411
	.quad	4607142004120689097
	.quad	4606615877252469319
	.quad	4599959683494114965
	.quad	4595158090109703915
	.quad	4607057059438406645
	.quad	4603913027650302123
	.quad	4605118359797677197
	.quad	-4623412353360660840
	.quad	4606615877252469319
	.quad	4606954044753208152
	.quad	4597229649290373108
	.quad	4598959657370965270
	.quad	4606785608815708217
	.quad	4604770201565748796
	.quad	4604310026026678476
	.quad	-4626142387564402705
	.quad	4606954044753208152
	.quad	4606133287758167985
	.quad	4602109342059235646
	.quad	4585367112943199202
	.quad	4607176539318022374
	.quad	4602957678247357513
	.quad	4605807894513955187
	.quad	-4621262694795540159
	.quad	4606133287758167984
	.quad	4607165089618285941
	.quad	4589096136820011980
	.quad	4601694213683419386
	.quad	4606239904023480929
	.quad	4605681446786967333
	.quad	4603153792735529207
	.quad	-4634275900034763821
	.quad	4607165089618285941
	.quad	4606714227855094466
	.quad	4599403975628943039
	.quad	4596317305571597620
	.quad	4607003306592464549
	.quad	4604137128736945990
	.quad	4604926906534828918
	.quad	-4623968061225832774
	.quad	4606714227855094467
	.quad	4607015286736980059
	.quad	4596076392557020843
	.quad	4599520274168821439
	.quad	4606694488837763809
	.quad	4604967395771142455
	.quad	4604090959611522300
	.quad	-4627295644297754969
	.quad	4607015286736980059
	.quad	4606267064173567517
	.quad	4601584063011212343
	.quad	4589622292277120979
	.quad	4607161073330179764
	.quad	4603204851783526551
	.quad	4605647330221823011
	.quad	-4621787973843563471
	.quad	4606267064173567519
	.quad	4607109316765575439
	.quad	4593748928973933430
	.quad	4600622125492085245
	.quad	4606484988283360059
	.quad	4605339761112510558
	.quad	4603634063978485777
	.quad	-4629623107880842379
	.quad	4607109316765575439
	.quad	4606508488182155889
	.quad	4600508657943310669
	.quad	4593992460331012948
	.quad	4607101301387725347
	.quad	4603682782375022972
	.quad	4605302378172036507
	.quad	-4622863378911465136
	.quad	4606508488182155888
	.quad	4606883402183517998
	.quad	4598274746487373488
	.quad	4598393378010153474
	.quad	4606867508573155112
	.quad	4604565945288421328
	.quad	4604522523137394221
	.quad	-4625097290367402319
	.quad	4606883402183517998
	.quad	4605990989643998215
	.quad	4602625585783048117
	.quad	4570006671472225971
	.quad	4607182366467193854
	.quad	4602705383534622754
	.quad	4605960285546553242
	.quad	-4620746451071727691
	.quad	4605990989643998216
	.quad	4607182366467193854
	.quad	4570006671472225742
	.quad	4602625585783048118
	.quad	4605990989643998215
	.quad	4605960285546553242
	.quad	4602705383534622755
	.quad	-4653365365382550120
	.quad	4607182366467193854
	.quad	4606867508573155112
	.quad	4598393378010153474
	.quad	4598274746487373487
	.quad	4606883402183517998
	.quad	4604522523137394222
	.quad	4604565945288421327
	.quad	-4624978658844622336
	.quad	4606867508573155112
	.quad	4607101301387725347
	.quad	4593992460331012950
	.quad	4600508657943310674
	.quad	4606508488182155888
	.quad	4605302378172036507
	.quad	4603682782375022972
	.quad	-4629379576523762864
	.quad	4607101301387725347
	.quad	4606484988283360059
	.quad	4600622125492085244
	.quad	4593748928973933433
	.quad	4607109316765575439
	.quad	4603634063978485778
	.quad	4605339761112510557
	.quad	-4622749911362690565
	.quad	4606484988283360059
	.quad	4607161073330179764
	.quad	4589622292277120978
	.quad	4601584063011212347
	.quad	4606267064173567517
	.quad	4605647330221823011
	.quad	4603204851783526552
	.quad	-4633749744577654837
	.quad	4607161073330179764
	.quad	4606694488837763809
	.quad	4599520274168821436
	.quad	4596076392557020843
	.quad	4607015286736980059
	.quad	4604090959611522300
	.quad	4604967395771142455
	.quad	-4623851762685954375
	.quad	4606694488837763810
	.quad	4607003306592464550
	.quad	4596317305571597616
	.quad	4599403975628943037
	.quad	4606714227855094467
	.quad	4604926906534828918
	.quad	4604137128736945990
	.quad	-4627054731283178192
	.quad	4607003306592464550
	.quad	4606239904023480929
	.quad	4601694213683419385
	.quad	4589096136820012005
	.quad	4607165089618285941
	.quad	4603153792735529208
	.quad	4605681446786967332
	.quad	-4621677823171356420
	.quad	4606239904023480929
	.quad	4607176539318022374
	.quad	4585367112943199193
	.quad	4602109342059235644
	.quad	4606133287758167985
	.quad	4605807894513955188
	.quad	4602957678247357511
	.quad	-4638004923911576624
	.quad	4607176539318022374
	.quad	4606785608815708217
	.quad	4598959657370965270
	.quad	4597229649290373115
	.quad	4606954044753208151
	.quad	4604310026026678477
	.quad	4604770201565748795
	.quad	-4624412379483810540
	.quad	4606785608815708217
	.quad	4607057059438406646
	.quad	4595158090109703910
	.quad	4599959683494114966
	.quad	4606615877252469319
	.quad	4605118359797677198
	.quad	4603913027650302123
	.quad	-4628213946745071897
	.quad	4607057059438406646
	.quad	4606366832045341789
	.quad	4601162180127497567
	.quad	4591482808943093406
	.quad	4607142004120689097
	.quad	4603396724015893275
	.quad	4605514533510350729
	.quad	-4622209856727278242
	.quad	4606366832045341789
	.quad	4607135985065033184
	.quad	4591971708924269280
	.quad	4601050311120939641
	.quad	4606392175639060469
	.quad	4605478764606422424
	.quad	4603446639463516323
	.quad	-4631400327930506537
	.quad	4607135985065033184
	.quad	4606594246212876579
	.quad	4600074628081212907
	.quad	4594915738165609770
	.quad	4607067062555383551
	.quad	4603865558473730057
	.quad	4605157316744107993
	.quad	-4623297408773562901
	.quad	4606594246212876579
	.quad	4606940100409792856
	.quad	4597468865399742291
	.quad	4598842129413695882
	.quad	4606803434673742624
	.quad	4604728223396440908
	.quad	4604354845661897876
	.quad	-4625903171455033510
	.quad	4606940100409792856
	.quad	4606104340135482489
	.quad	4602217656444993030
	.quad	4584105795105686262
	.quad	4607178548537836914
	.quad	4602905530274293359
	.quad	4605840322207443041
	.quad	-4621154380409782779
	.quad	4606104340135482489
	.quad	4607180658379475773
	.quad	4581355541664009677
	.quad	4602368628120840488
	.quad	4606063194601913505
	.quad	4605885122093926452
	.quad	4602832154278008491
	.quad	-4642016495190766175
	.quad	4607180658379475773
	.quad	4606827716935819874
	.quad	4598677187746332715
	.quad	4597803117272054919
	.quad	4606919894048772314
	.quad	4604417110134558917
	.quad	4604668942690440000
	.quad	-4624694849108443097
	.quad	4606827716935819874
	.quad	4607080372475452902
	.quad	4594575999143712762
	.quad	4600235049313092100
	.quad	4606563305564041852
	.quad	4605211310850747517
	.quad	4603798657777859811
	.quad	-4628796037711063049
	.quad	4607080372475452902
	.quad	4606427014766909160
	.quad	4600893119494820870
	.quad	4592655593201588214
	.quad	4607126858728266152
	.quad	4603516108939808677
	.quad	4605428118199606249
	.quad	-4622478917359954937
	.quad	4606427014766909160
	.quad	4607149730544409479
	.quad	4590797821630570122
	.quad	4601318210654696746
	.quad	4606330711617531337
	.quad	4605564036496605688
	.quad	4603326435176014066
	.quad	-4632574215224205687
	.quad	4607149730544409479
	.quad	4606645501374952515
	.quad	4599798271251372055
	.quad	4595496912560064668
	.quad	4607042361620356187
	.quad	4603979035953623120
	.quad	4605063278307570205
	.quad	-4623573765603403754
	.quad	4606645501374952515
	.quad	4606972881174505359
	.quad	4596894119717490181
	.quad	4599123782359181257
	.quad	4606759980438457619
	.quad	4604828455581718930
	.quad	4604246799953867691
	.quad	-4626477917137285626
	.quad	4606972881174505359
	.quad	4606173192704888123
	.quad	4601957044168416550
	.quad	4586741503256097319
	.quad	4607173023542913905
	.quad	4603030311417658591
	.quad	4605761900066119193
	.quad	-4621414992686359263
	.quad	4606173192704888124
	.quad	4607170010385606010
	.quad	4587722850872574770
	.quad	4601847797015382056
	.quad	4606201250347128808
	.quad	4605728623482330038
	.quad	4603081921836867942
	.quad	-4635649185982201034
	.quad	4607170010385606010
	.quad	4606741195486182106
	.quad	4599240711260102261
	.quad	4596654023015670784
	.quad	4606985845153856138
	.quad	4604201299482757968
	.quad	4604869694804898265
	.quad	-4624131325594673548
	.quad	4606741195486182106
	.quad	4607031368518050325
	.quad	4595738577389159329
	.quad	4599682634208467594
	.quad	4606666189172726070
	.quad	4605023549898070094
	.quad	4604025861372769490
	.quad	-4627633459465616483
	.quad	4607031368518050326
	.quad	4606304456231027781
	.quad	4601429235356077846
	.quad	4590308199237181440
	.quad	4607154748888056495
	.quad	4603275941168970532
	.quad	4605598983909275717
	.quad	-4621942801498697962
	.quad	4606304456231027781
	.quad	4607119840572048087
	.quad	4593143639880204306
	.quad	4600780436133124268
	.quad	4606451439782750093
	.quad	4605391537380620172
	.quad	4603565432464438914
	.quad	-4630228396974571504
	.quad	4607119840572048087
	.quad	4606540737073782282
	.quad	4600349270670938092
	.quad	4594333024968094859
	.quad	4607089382929024551
	.quad	4603750557552508465
	.quad	4605249485904392423
	.quad	-4623022766183837718
	.quad	4606540737073782283
	.quad	4606904973074530420
	.quad	4598041388745036960
	.quad	4598559092197791029
	.quad	4606844578927199935
	.quad	4604626236813574551
	.quad	4604461236934587867
	.quad	-4625330648109738855
	.quad	4606904973074530421
	.quad	4606033364748761771
	.quad	4602475980740940558
	.quad	4578620663913945974
	.quad	4607181663123880230
	.quad	4602779482712362910
	.quad	4605916692215435326
	.quad	-4620896056113835251
	.quad	4606033364748761771
	.quad	4607181813838763374
	.quad	4577834696744284912
	.quad	4602497402316307046
	.quad	4606027354903166326
	.quad	4605922963106865834
	.quad	4602768922639562812
	.quad	-4645537340110490883
	.quad	4607181813838763374
	.quad	4606847902995228183
	.quad	4598535445651436839
	.quad	4598088993900802446
	.quad	4606901940165298243
	.quad	4604470027298532783
	.quad	4604617659592661429
	.quad	-4624836591203338966
	.quad	4606847902995228183
	.quad	4607091135312362631
	.quad	4594284400962581035
	.quad	4600372077866280535
	.quad	4606536176681580999
	.quad	4605257081513569597
	.quad	4603740906338175322
	.quad	-4629087635892194778
	.quad	4607091135312362631
	.quad	4606456278659742941
	.quad	4600757859642136983
	.quad	4593241202647068886
	.quad	4607118387039702860
	.quad	4603575267177587328
	.quad	4605384180911754946
	.quad	-4622614177212638825
	.quad	4606456278659742940
	.quad	4607155702478878255
	.quad	4590210242550778919
	.quad	4601451397191623390
	.quad	4606299159772004083
	.quad	4605605932036052335
	.quad	4603265813842019521
	.quad	-4633161794303996892
	.quad	4607155702478878255
	.quad	4606670279402733034
	.quad	4599659473100085931
	.quad	4595786874065649908
	.quad	4607029120484048262
	.quad	4604035193892958257
	.quad	4605015565958954415
	.quad	-4623712563754689879
	.quad	4606670279402733035
	.quad	4606988388825736052
	.quad	4596605961563300898
	.quad	4599264066151329726
	.quad	4606737390689102767
	.quad	4604877905370911400
	.quad	4604192165709024149
	.quad	-4626766075291474917
	.quad	4606988388825736053
	.quad	4606206817150293377
	.quad	4601825901817789563
	.quad	4587919079676579126
	.quad	4607169357579166271
	.quad	4603092216629224448
	.quad	4605721925985244333
	.quad	-4621546135036986245
	.quad	4606206817150293377
	.quad	4607173575991554278
	.quad	4586545195567892415
	.quad	4601978847547674878
	.quad	4606167536524188569
	.quad	4605768513115932446
	.quad	4603019962176669799
	.quad	-4636826841286883427
	.quad	4607173575991554278
	.quad	4606763689573392520
	.quad	4599100365994398370
	.quad	4596942096320892508
	.quad	4606970239288389327
	.quad	4604255866250143102
	.quad	4604820170565803249
	.quad	-4624271670860377440
	.quad	4606763689573392521
	.quad	4607044510798662165
	.quad	4595448543933954635
	.quad	4599821364659156751
	.quad	4606641316539699001
	.quad	4605071185628844198
	.quad	4603969638428036749
	.quad	-4627923492920821171
	.quad	4607044510798662165
	.quad	4606335917244768060
	.quad	4601295962898679664
	.quad	4590895712627068985
	.quad	4607148676810834843
	.quad	4603336505320447971
	.quad	4605557005749280054
	.quad	-4622076073956096149
	.quad	4606335917244768061
	.quad	4607128212440140362
	.quad	4592557938567358971
	.quad	4600915616055205030
	.quad	4606422083701142303
	.quad	4605435393963118048
	.quad	4603506214371490807
	.quad	-4630814098287416827
	.quad	4607128212440140362
	.quad	4606567772509200137
	.quad	4600212168262606646
	.quad	4594624564176000690
	.quad	4607078520700815925
	.quad	4603808246528465563
	.quad	4605203636537833820
	.quad	-4623159868592169161
	.quad	4606567772509200137
	.quad	4606922829490398605
	.quad	4597755414458832171
	.quad	4598700779112000448
	.quad	4606824296251186724
	.quad	4604677447709112537
	.quad	4604408249893351341
	.quad	-4625616622395943645
	.quad	4606922829490398605
	.quad	4606069116619933657
	.quad	4602347108927598580
	.quad	4581748472640595131
	.quad	4607180407199212417
	.quad	4602842662694366088
	.quad	4605878765018928309
	.quad	-4621024927927177227
	.quad	4606069116619933657
	.quad	4607178900166668444
	.quad	4583712943037066984
	.quad	4602239271815784161
	.quad	4606098506341411119
	.quad	4605846765040516024
	.quad	4602895074217729325
	.quad	-4639659093817708854
	.quad	4607178900166668444
	.quad	4606806951746026847
	.quad	4598818594807735790
	.quad	4597516662677569727
	.quad	4606937262632247917
	.quad	4604363775187332982
	.quad	4604719791149268271
	.quad	-4624553442047040021
	.quad	4606806951746026848
	.quad	4607069013597376139
	.quad	4594867235357110503
	.quad	4600097581455363125
	.quad	4606589873013743602
	.quad	4605165069247099833
	.quad	4603856032828647537
	.quad	-4628504801497665306
	.quad	4607069013597376139
	.quad	4606397198563554427
	.quad	4601027895996902097
	.quad	4592069448889627076
	.quad	4607134731264236857
	.quad	4603456593224738768
	.quad	4605471570035246657
	.quad	-4622344140857873715
	.quad	4606397198563554428
	.quad	4607143157926487939
	.quad	4591384990188554550
	.quad	4601184512314895708
	.quad	4606361717598315941
	.quad	4605521646407642239
	.quad	4603386711727993044
	.quad	-4631987046666221272
	.quad	4607143157926487939
	.quad	4606620156412869300
	.quad	4599936659332619020
	.quad	4595206527448016525
	.quad	4607055009259645911
	.quad	4603922489552289361
	.quad	4605110529623499026
	.quad	-4623435377522156789
	.quad	4606620156412869300
	.quad	4606956784676733145
	.quad	4597181760747116282
	.quad	4598983133641995587
	.quad	4606781995591178183
	.quad	4604778560477032969
	.quad	4604301027814688313
	.quad	-4626190276107659522
	.quad	4606956784676733144
	.quad	4606139032937822103
	.quad	4602087631957658865
	.quad	4585563486376305997
	.quad	4607176087264157951
	.quad	4602968081244281479
	.quad	4605801366354040130
	.quad	-4621284404897116942
	.quad	4606139032937822103
	.quad	4607165842738831298
	.quad	4588900000034226859
	.quad	4601716199233853061
	.quad	4606234426970449535
	.quad	4605688228283047509
	.quad	4603143553080857727
	.quad	-4634472036820548938
	.quad	4607165842738831298
	.quad	4606718128059654935
	.quad	4599380683774464435
	.quad	4596365448656077999
	.quad	4607000861305074220
	.quad	4604146329376794963
	.quad	4604918770968269291
	.quad	-4623991353080311373
	.quad	4606718128059654935
	.quad	4607017633476212424
	.quad	4596028171062750856
	.quad	4599543501427576931
	.quad	4606690493486771346
	.quad	4604975455793717488
	.quad	4604081692721376920
	.quad	-4627343865792024954
	.quad	4607017633476212424
	.quad	4606272451109874718
	.quad	4601561988579477980
	.quad	4589720308096974056
	.quad	4607160219945936777
	.quad	4603215035615150749
	.quad	4605640465180648578
	.quad	-4621810048275297831
	.quad	4606272451109874719
	.quad	4607110870021103616
	.quad	4593700196789227089
	.quad	4600644780402582224
	.quad	4606480241919017736
	.quad	4605347197794344820
	.quad	4603624289778765464
	.quad	-4629671840065548718
	.quad	4607110870021103616
	.quad	4606513141716163245
	.quad	4600485926129646204
	.quad	4594041140055242710
	.quad	4607099648512976976
	.quad	4603692495407106835
	.quad	4605294861774986424
	.quad	-4622886110725129605
	.quad	4606513141716163245
	.quad	4606886532357356880
	.quad	4598250994331377453
	.quad	4598417078154479573
	.quad	4606864281344218837
	.quad	4604574594137483071
	.quad	4604513803239070054
	.quad	-4625121042523398358
	.quad	4606886532357356881
	.quad	4605997086914916977
	.quad	4602604263259349468
	.quad	4572152186185973145
	.quad	4607182316227778595
	.quad	4602715994557056819
	.quad	4605954101258414710
	.quad	-4620767773595426342
	.quad	4605997086914916977
	.quad	4607182165510093259
	.quad	4575296231692386000
	.quad	4602561568427926510
	.quad	4606009237817332102
	.quad	4605941689305310984
	.quad	4602737191255082964
	.quad	-4648075805162389936
	.quad	4607182165510093259
	.quad	4606857778427303713
	.quad	4598464451930290906
	.quad	4598203464521136526
	.quad	4606892744110062516
	.quad	4604496328103870024
	.quad	4604591856125688410
	.quad	-4624907584924484901
	.quad	4606857778427303713
	.quad	4607096292988701405
	.quad	4594138472232359765
	.quad	4600440424536376125
	.quad	4606522402269037217
	.quad	4605279789283581132
	.quad	4603711890679466304
	.quad	-4629233564622416044
	.quad	4607096292988701405
	.quad	4606470702876174426
	.quad	4600690051287207736
	.quad	4593533794544625062
	.quad	4607113926688829899
	.quad	4603604711004178991
	.quad	4605362031140991909
	.quad	-4622681985567568074
	.quad	4606470702876174426
	.quad	4607158463063335815
	.quad	4589916311354185679
	.quad	4601517795746884574
	.quad	4606283179808486545
	.quad	4605626693472108952
	.quad	4603235375148846488
	.quad	-4633455725500590142
	.quad	4607158463063335815
	.quad	4606682455296509757
	.quad	4599589923150267027
	.quad	4595931689899953549
	.quad	4607022277629917959
	.quad	4604063126013737406
	.quad	4604991537894155224
	.quad	-4623782113704508786
	.quad	4606682455296509757
	.quad	4606995921507994138
	.quad	4596461694590381175
	.quad	4599334068265325595
	.quad	4606725880811681941
	.quad	4604902462236720503
	.quad	4604164697334284302
	.quad	-4626910342264394637
	.quad	4606995921507994139
	.quad	4606223427922670420
	.quad	4601760125423535908
	.quad	4588507678082739546
	.quad	4607167298831457857
	.quad	4603123046078642863
	.quad	4605701749357236351
	.quad	-4621611911431239903
	.quad	4606223427922670421
	.quad	4607175132953064692
	.quad	4585956202742929365
	.quad	4602044164852818385
	.quad	4606150478866629207
	.quad	4605788267509933274
	.quad	4602988860485608459
	.quad	-4637415834111846432
	.quad	4607175132953064692
	.quad	4606774721142759041
	.quad	4599030056514339798
	.quad	4597085939051340751
	.quad	4606962215537689700
	.quad	4604282997239472762
	.quad	4604795241452557709
	.quad	-4624341980340436010
	.quad	4606774721142759041
	.quad	4607050859377068982
	.quad	4595303368353560270
	.quad	4599890576107878901
	.quad	4606628667622327926
	.quad	4605094830606571714
	.quad	4603941381282082490
	.quad	-4628068668501215541
	.quad	4607050859377068982
	.quad	4606351443051883894
	.quad	4601229134743456973
	.quad	4591189315375975924
	.quad	4607145415515405740
	.quad	4603366658102630213
	.quad	4605535831212782521
	.quad	-4622142902111318833
	.quad	4606351443051883894
	.quad	4607132173691442086
	.quad	4592264887335541502
	.quad	4600983024759347818
	.quad	4606407198543411778
	.quad	4605457140209364707
	.quad	4603476471270721136
	.quad	-4631107149519234307
	.quad	4607132173691442086
	.quad	4606581079689135032
	.quad	4600143452318855712
	.quad	4594770198041737147
	.quad	4607072866070754541
	.quad	4603836949870279646
	.quad	4605180535251334602
	.quad	-4623228584535920093
	.quad	4606581079689135032
	.quad	4606931538210323125
	.quad	4597612210578075187
	.quad	4598771496931253000
	.quad	4606813937738781179
	.quad	4604702890166896239
	.quad	4604381599703649585
	.quad	-4625759826276700627
	.quad	4606931538210323125
	.quad	4606086794570340794
	.quad	4602282454729324442
	.quad	4582927194697776791
	.quad	4607179553203783305
	.quad	4602874135798074045
	.quad	4605859607905048518
	.quad	-4621089582125451366
	.quad	4606086794570340794
	.quad	4607179854610852487
	.quad	4582534299887998136
	.quad	4602304022191786334
	.quad	4606080916615116794
	.quad	4605866007912630101
	.quad	4602863653473912280
	.quad	-4640837736966777678
	.quad	4607179854610852487
	.quad	4606817406646262673
	.quad	4598747933748296408
	.quad	4597659961023107029
	.quad	4606928651576586329
	.quad	4604390494661391084
	.quad	4604694421463119771
	.quad	-4624624103106479405
	.quad	4606817406646262674
	.quad	4607074767494977696
	.quad	4594721663715278402
	.quad	4600166369722913284
	.quad	4606576659580008312
	.quad	4605188248723822568
	.quad	4603827392592474013
	.quad	-4628650373139497404
	.quad	4607074767494977696
	.quad	4606412175580182840
	.quad	4600960568729257339
	.quad	4592362585452731763
	.quad	4607130869924198776
	.quad	4603486395518523066
	.quad	4605449904981486987
	.quad	-4622411468125518465
	.quad	4606412175580182840
	.quad	4607146519294327306
	.quad	4591091459681741946
	.quad	4601251424901656437
	.quad	4606346282971580509
	.quad	4605542903094258383
	.quad	4603356616802452049
	.quad	-4632280577173033870
	.quad	4607146519294327306
	.quad	4606632899655562215
	.quad	4599867517130314363
	.quad	4595351771740741223
	.quad	4607048759680968401
	.quad	4603950811074764180
	.quad	4605086961793010765
	.quad	-4623504519724461444
	.quad	4606632899655562215
	.quad	4606964906465024007
	.quad	4597038006076977272
	.quad	4599053503028412964
	.quad	4606771059932394853
	.quad	4604803563485784391
	.quad	4604273964909770485
	.quad	-4626334030777798536
	.quad	4606964906465024007
	.quad	4606156179594501500
	.quad	4602022407930370329
	.quad	4586152544946293207
	.quad	4607174630697610145
	.quad	4602999236691377940
	.quad	4605781696850095328
	.quad	-4621349628924405480
	.quad	4606156179594501501
	.quad	4607168001800831838
	.quad	4588311493646456792
	.quad	4601782065981115889
	.quad	4606217905948372533
	.quad	4605708488910206136
	.quad	4603112778769226854
	.quad	-4635060543208319025
	.quad	4607168001800831838
	.quad	4606729733344734277
	.quad	4599310744697334628
	.quad	4596509797261259990
	.quad	4606993427007488639
	.quad	4604173864617774285
	.quad	4604894289102053137
	.quad	-4624061292157441178
	.quad	4606729733344734276
	.quad	4607024575035756547
	.quad	4595883430410807572
	.quad	4599613117527892655
	.quad	4606678412472185529
	.quad	4604999559942117492
	.quad	4604053826230763179
	.quad	-4627488606443968235
	.quad	4607024575035756547
	.quad	4606288521550843979
	.quad	4601495677428190476
	.quad	4590014298427127762
	.quad	4607157559568244300
	.quad	4603245530813102021
	.quad	4605619786830348624
	.quad	-4621876359426585329
	.quad	4606288521550843978
	.quad	4607115430095344936
	.quad	4593436280160626917
	.quad	4600712667177166968
	.quad	4606465910215408778
	.quad	4605369427778226030
	.quad	4603594906465714411
	.quad	-4629935756694148900
	.quad	4607115430095344936
	.quad	4606527009270686273
	.quad	4600417654841368748
	.quad	4594187124504283499
	.quad	4607094590345412920
	.quad	4603721572883681507
	.quad	4605272233217249254
	.quad	-4622954382013407064
	.quad	4606527009270686274
	.quad	4606895825677380151
	.quad	4598179686955260809
	.quad	4598488125473697070
	.quad	4606854502751415327
	.quad	4604600469232737882
	.quad	4604487572899484576
	.quad	-4625192349899515000
	.quad	4606895825677380151
	.quad	4606015291426237061
	.quad	4602540196199582004
	.quad	4576262726601181989
	.quad	4607182065032103403
	.quad	4602747776891265361
	.quad	4605935461663422552
	.quad	-4620831840655193809
	.quad	4606015291426237062
	.quad	4607181311459088754
	.quad	4580176688089394166
	.quad	4602433088521888409
	.quad	4606045340598345674
	.quad	4605904107264565354
	.quad	4602800577157097508
	.quad	-4643195348765381661
	.quad	4607181311459088754
	.quad	4606837882442175227
	.quad	4598606357985645437
	.quad	4597946129028963935
	.quad	4606910990195346563
	.quad	4604443621161476805
	.quad	4604643355257568099
	.quad	-4624765678869130371
	.quad	4606837882442175227
	.quad	4607085828445012996
	.quad	4594430244079835070
	.quad	4600303619076676348
	.quad	4606549811189298456
	.quad	4605234255241973544
	.quad	4603769828865627782
	.quad	-4628941792774940737
	.quad	4607085828445012995
	.quad	4606441715875427622
	.quad	4600825549422228236
	.quad	4592948467233265189
	.quad	4607122697743558773
	.quad	4603545732991397616
	.quad	4605406210054165090
	.quad	-4622546487432547570
	.quad	4606441715875427621
	.quad	4607152791623000251
	.quad	4590504080948517271
	.quad	4601384868456483201
	.quad	4606315003796725624
	.quad	4605585046261056581
	.quad	4603296167353711610
	.quad	-4632867955906258531
	.quad	4607152791623000251
	.quad	4606657961360174228
	.quad	4599728922854491097
	.quad	4595641947477329362
	.quad	4607035815184868730
	.quad	4604007163716576141
	.quad	4605039479563475744
	.quad	-4623643114000284715
	.quad	4606657961360174229
	.quad	4606980708671735502
	.quad	4596750104076321471
	.quad	4599193970458308605
	.quad	4606748757294760886
	.quad	4604853236348314375
	.quad	4604219533401534160
	.quad	-4626621932778454339
	.quad	4606980708671735502
	.quad	4606190071984299703
	.quad	4601891541765536627
	.quad	4587330351450613418
	.quad	4607171265826961928
	.quad	4603061304903146573
	.quad	4605741976333373516
	.quad	-4621480495089239186
	.quad	4606190071984299704
	.quad	4607171868459543943
	.quad	4587134081562405846
	.quad	4601913391236766857
	.quad	4606184460445418388
	.quad	4605748631662505176
	.quad	4603050982800113475
	.quad	-4636237955292369977
	.quad	4607171868459543943
	.quad	4606752514292201134
	.quad	4599170584634644632
	.quad	4596798123505964812
	.quad	4606978115871044718
	.quad	4604228633512675362
	.quad	4604844988488343787
	.quad	-4624201452220131175
	.quad	4606752514292201134
	.quad	4607038013809417665
	.quad	4595593614421647860
	.quad	4599752050306071387
	.quad	4606653823792926802
	.quad	4605047425260148693
	.quad	4603997798615334932
	.quad	-4627778422433127957
	.quad	4607038013809417665
	.quad	4606320254883789346
	.quad	4601362663474922676
	.quad	4590602005609260079
	.quad	4607151787952404787
	.quad	4603306266173896409
	.quad	4605578056765527452
	.quad	-4622009373379853134
	.quad	4606320254883789347
	.quad	4607124101377412073
	.quad	4592850857716062813
	.quad	4600848086136468632
	.quad	4606436830863177043
	.quad	4605413526231564807
	.quad	4603535868268130717
	.quad	-4630521179138713009
	.quad	4607124101377412073
	.quad	4606554324895742416
	.quad	4600280774762634172
	.quad	4594478839005308099
	.quad	4607084026350948147
	.quad	4603779448928584021
	.quad	4605226620217049248
	.quad	-4623091262092141640
	.quad	4606554324895742417
	.quad	4606913974395743275
	.quad	4597898474645766772
	.quad	4598629977139267358
	.quad	4606834510037629118
	.quad	4604651896448821281
	.quad	4604434795785062555
	.quad	-4625473562209009039
	.quad	4606913974395743275
	.quad	4606051306580068190
	.quad	4602411617957949545
	.quad	4580569648657828590
	.quad	4607181110509834250
	.quad	4602811111489812438
	.quad	4605897793228524294
	.quad	-4620960418896826258
	.quad	4606051306580068189
	.quad	4607177795062894465
	.quad	4584777936026007081
	.quad	4602174378076309207
	.quad	4606115963486465633
	.quad	4605827393799577343
	.quad	4602926415983692821
	.quad	-4638594100828768724
	.quad	4607177795062894465
	.quad	4606796352410055405
	.quad	4598889169742271489
	.quad	4597373224633270169
	.quad	4606945727071667327
	.quad	4604336952159484543
	.quad	4604745051324371720
	.quad	-4624482867112504320
	.quad	4606796352410055406
	.quad	4607063110878928841
	.quad	4595012711633342579
	.quad	4600028685661483358
	.quad	4606602945644145864
	.quad	4605141772808444076
	.quad	4603884578007140123
	.quad	-4628359325221433233
	.quad	4607063110878928841
	.quad	4606382083967636004
	.quad	4601095100171160484
	.quad	4591776188417360922
	.quad	4607138442683768163
	.quad	4603426702557140881
	.quad	4605493112998361505
	.quad	-4622276936683615328
	.quad	4606382083967636005
	.quad	4607139646497137519
	.quad	4591678408239329295
	.quad	4601117474014070329
	.quad	4606377015239468305
	.quad	4605500266792447759
	.quad	4603416719449055315
	.quad	-4631693628615446517
	.quad	4607139646497137519
	.quad	4606607271860107870
	.quad	4600005696701321859
	.quad	4595061182112279476
	.quad	4607061110251813821
	.quad	4603894071860105852
	.quad	4605133981404671856
	.quad	-4623366340153453947
	.quad	4606607271860107870
	.quad	4606948515945535561
	.quad	4597325381322444311
	.quad	4598912675377427896
	.quad	4606792787231820015
	.quad	4604753446973842793
	.quad	4604327988215774574
	.quad	-4626046655532331495
	.quad	4606948515945535561
	.quad	4606121753021766846
	.quad	4602152715158881249
	.quad	4584974337402918366
	.quad	4607177393218184432
	.quad	4602936845597696767
	.quad	4605820908248821602
	.quad	-4621219321695894556
	.quad	4606121753021766846
	.quad	4607163533235732216
	.quad	4589328190239438755
	.quad	4601650197875749191
	.quad	4606250813136911712
	.quad	4605667841939877484
	.quad	4603174244256810581
	.quad	-4634043846615337070
	.quad	4607163533235732216
	.quad	4606706379825136607
	.quad	4599450527321193317
	.quad	4596220979615526110
	.quad	4607008147922213951
	.quad	4604118694220570253
	.quad	4604943139993888937
	.quad	-4623921509533582496
	.quad	4606706379825136608
	.quad	4607010543955571845
	.quad	4596172796923027744
	.quad	4599473787072414369
	.quad	4606702432014330563
	.quad	4604951237856207483
	.quad	4604109460378317621
	.quad	-4627199239931748062
	.quad	4607010543955571845
	.quad	4606256245177028476
	.quad	4601628167700348480
	.quad	4589426233166093175
	.quad	4607162729976617532
	.quad	4603184456085396252
	.quad	4605661018614162445
	.quad	-4621743869154427327
	.quad	4606256245177028476
	.quad	4607106160425628358
	.quad	4593846367701773983
	.quad	4600576776945326983
	.quad	4606494434653762977
	.quad	4605324847800953337
	.quad	4603653581911917826
	.quad	-4629525669153001828
	.quad	4607106160425628358
	.quad	4606499134642260531
	.quad	4600554083393379395
	.quad	4593895074063746519
	.quad	4607104557347077838
	.quad	4603663325609341101
	.quad	4605317371198957757
	.quad	-4622817953461396415
	.quad	4606499134642260532
	.quad	4606877093269966767
	.quad	4598322225080312358
	.quad	4598345951428981243
	.quad	4606873914541984184
	.quad	4604548611960780965
	.quad	4604539927514429107
	.quad	-4625049811774463451
	.quad	4606877093269966767
	.quad	4605978751519419632
	.quad	4602668180848201709
	.quad	4559427434119572799
	.quad	4607182416706702520
	.quad	4602684136241554627
	.quad	4605972610688513381
	.quad	-4620703856006574100
	.quad	4605978751519419633
	.align 32
	.type	fpr_gm3_square, @object
	.size	fpr_gm3_square, 16384
fpr_gm3_square:
	.quad	4607182418800017408
	.quad	0
	.quad	4602678819172646913
	.quad	4605975682916830378
	.quad	4605975682916830379
	.quad	4602678819172646911
	.quad	-4617396353937945429
	.quad	4602678819172646911
	.quad	4606875505927962389
	.quad	4598334089338226320
	.quad	-4625037947516549490
	.quad	4606875505927962389
	.quad	4598334089338226320
	.quad	4606875505927962389
	.quad	-4616496530926813420
	.quad	4598334089338226325
	.quad	4607105360961759387
	.quad	4593870721975689936
	.quad	-4629501314879085871
	.quad	4607105360961759387
	.quad	4603658455034958826
	.quad	4605321111160693906
	.quad	-4618050925694081903
	.quad	4603658455034958828
	.quad	4605321111160693906
	.quad	4603658455034958826
	.quad	-4619713581819816982
	.quad	4605321111160693906
	.quad	4593870721975689941
	.quad	4607105360961759387
	.quad	-4616266675893016421
	.quad	4593870721975689951
	.quad	4607163133695007814
	.quad	4589377212798040715
	.quad	-4633994824056735087
	.quad	4607163133695007814
	.quad	4604114078679662348
	.quad	4604947190498885672
	.quad	-4618424846355890137
	.quad	4604114078679662349
	.quad	4606253531034407157
	.quad	4601639184639747835
	.quad	-4621732852215027975
	.quad	4606253531034407157
	.quad	4599462158542551882
	.quad	4606704407901956522
	.quad	-4616667628952819286
	.quad	4599462158542551883
	.quad	4606704407901956523
	.quad	4599462158542551880
	.quad	-4623909878312223928
	.quad	4606704407901956523
	.quad	4601639184639747835
	.quad	4606253531034407157
	.quad	-4617118505820368653
	.quad	4601639184639747843
	.quad	4604947190498885672
	.quad	4604114078679662348
	.quad	-4619257958175113460
	.quad	4604947190498885672
	.quad	4589377212798040730
	.quad	4607163133695007814
	.quad	-4616208903159767994
	.quad	4589377212798040719
	.quad	4607177596232733550
	.quad	4584876137810324205
	.quad	-4638495899044451617
	.quad	4607177596232733550
	.quad	4604332471618603501
	.quad	4604749250676942587
	.quad	-4618622786177833224
	.quad	4604332471618603504
	.quad	4606379551510276960
	.quad	4601106288820466945
	.quad	-4622265748034308865
	.quad	4606379551510276961
	.quad	4600017192656143148
	.quad	4606605110711272677
	.quad	-4616766926143503130
	.quad	4600017192656143145
	.quad	4606947123547232624
	.quad	4597349304879225727
	.quad	-4626022731975550077
	.quad	4606947123547232624
	.quad	4602931631896107089
	.quad	4605824152801847042
	.quad	-4617547884052928767
	.quad	4602931631896107089
	.quad	4605496691596948699
	.quad	4603421712222407333
	.quad	-4619950324632368476
	.quad	4605496691596948699
	.quad	4595036948236777110
	.quad	4607062112630726507
	.quad	-4616309924224049301
	.quad	4595036948236777113
	.quad	4607062112630726507
	.quad	4595036948236777107
	.quad	-4628335088617998702
	.quad	4607062112630726507
	.quad	4603421712222407333
	.quad	4605496691596948699
	.quad	-4617875345257827110
	.quad	4603421712222407333
	.quad	4605824152801847042
	.quad	4602931631896107088
	.quad	-4620440404958668720
	.quad	4605824152801847042
	.quad	4597349304879225736
	.quad	4606947123547232624
	.quad	-4616424913307543184
	.quad	4597349304879225730
	.quad	4606605110711272678
	.quad	4600017192656143146
	.quad	-4623354844198632662
	.quad	4606605110711272678
	.quad	4601106288820466945
	.quad	4606379551510276960
	.quad	-4616992485344498847
	.quad	4601106288820466943
	.quad	4604749250676942587
	.quad	4604332471618603501
	.quad	-4619039565236172306
	.quad	4604749250676942586
	.quad	4584876137810324209
	.quad	4607177596232733550
	.quad	-4616194440622042258
	.quad	4584876137810324186
	.quad	4607181213077496175
	.quad	4580373169469619579
	.quad	-4642998867385156284
	.quad	4607181213077496175
	.quad	4604439209929050102
	.quad	4604647627357412288
	.quad	-4618724409497363519
	.quad	4604439209929050102
	.quad	4606439275289907221
	.quad	4600836819444574041
	.quad	-4622535217410201767
	.quad	4606439275289907221
	.quad	4600292198458308426
	.quad	4606552069989339336
	.quad	-4616819966865436472
	.quad	4600292198458308424
	.quad	4606979414317525815
	.quad	4596774115558834964
	.quad	-4626597921295940851
	.quad	4606979414317525815
	.quad	4603056144985979738
	.quad	4605745305757262496
	.quad	-4617626731097513313
	.quad	4603056144985979740
	.quad	4605581553234558321
	.quad	4603301217955109818
	.quad	-4620070818899665992
	.quad	4605581553234558322
	.quad	4595617782448443252
	.quad	4607036916556642689
	.quad	-4616335120298133119
	.quad	4595617782448443262
	.quad	4607123401640084449
	.quad	4592899664388572837
	.quad	-4630472372466202976
	.quad	4607123401640084449
	.quad	4603774640198437235
	.quad	4605230439369177210
	.quad	-4618141597485598600
	.quad	4603774640198437237
	.quad	4606048325418953258
	.quad	4602422355273630466
	.quad	-4620949681581145340
	.quad	4606048325418953257
	.quad	4598618168712057284
	.quad	4606836198252753799
	.quad	-4616535838602022009
	.quad	4598618168712057289
	.quad	4606750637786447988
	.quad	4599182278827179310
	.quad	-4624189758027596496
	.quad	4606750637786447987
	.quad	4601902468414039113
	.quad	4606187268076896289
	.quad	-4617184768777879519
	.quad	4601902468414039114
	.quad	4605043454008021768
	.quad	4604002482520238482
	.quad	-4619369554334537326
	.quad	4605043454008021768
	.quad	4590553044647432212
	.quad	4607152291874015770
	.quad	-4616219744980760038
	.quad	4590553044647432184
	.quad	4607152291874015770
	.quad	4590553044647432206
	.quad	-4632818992207343605
	.quad	4607152291874015770
	.quad	4604002482520238483
	.quad	4605043454008021767
	.quad	-4618328582846754041
	.quad	4604002482520238483
	.quad	4606187268076896290
	.quad	4601902468414039112
	.quad	-4621469568440736697
	.quad	4606187268076896290
	.quad	4599182278827179311
	.quad	4606750637786447988
	.quad	-4616621399068327820
	.quad	4599182278827179312
	.quad	4606836198252753799
	.quad	4598618168712057283
	.quad	-4624753868142718526
	.quad	4606836198252753800
	.quad	4602422355273630467
	.quad	4606048325418953257
	.quad	-4617323711435822552
	.quad	4602422355273630471
	.quad	4605230439369177211
	.quad	4603774640198437234
	.quad	-4619597396656338572
	.quad	4605230439369177209
	.quad	4592899664388572841
	.quad	4607123401640084449
	.quad	-4616248635214691359
	.quad	4592899664388572861
	.quad	4607036916556642689
	.quad	4595617782448443253
	.quad	-4627754254406332560
	.quad	4607036916556642690
	.quad	4603301217955109818
	.quad	4605581553234558321
	.quad	-4617790483620217487
	.quad	4603301217955109818
	.quad	4605745305757262496
	.quad	4603056144985979738
	.quad	-4620315891868796070
	.quad	4605745305757262496
	.quad	4596774115558834961
	.quad	4606979414317525815
	.quad	-4616392622537249993
	.quad	4596774115558834963
	.quad	4606552069989339337
	.quad	4600292198458308422
	.quad	-4623079838396467388
	.quad	4606552069989339337
	.quad	4600836819444574039
	.quad	4606439275289907222
	.quad	-4616932761564868586
	.quad	4600836819444574037
	.quad	4604647627357412289
	.quad	4604439209929050102
	.quad	-4618932826925725707
	.quad	4604647627357412290
	.quad	4580373169469619560
	.quad	4607181213077496175
	.quad	-4616190823777279633
	.quad	4580373169469619641
	.quad	4607182117364343164
	.quad	4575869727671838369
	.quad	-4647502309182937447
	.quad	4607182117364343164
	.quad	4604491951969715217
	.quad	4604596164171470461
	.quad	-4618775872683305348
	.quad	4604491951969715218
	.quad	4606468308473143938
	.quad	4600701360865931757
	.quad	-4622670675988844051
	.quad	4606468308473143938
	.quad	4600429041259328501
	.quad	4606524707710321525
	.quad	-4616847329144454284
	.quad	4600429041259328505
	.quad	4606994676307424051
	.quad	4596485747626494357
	.quad	-4626886289228281460
	.quad	4606994676307424051
	.quad	4603117913572639878
	.quad	4605705120883705243
	.quad	-4617666915971070565
	.quad	4603117913572639878
	.quad	4605623241882183728
	.quad	4603240454158158274
	.quad	-4620131582696617534
	.quad	4605623241882183728
	.quad	4595907561721681254
	.quad	4607023428389202032
	.quad	-4616348608465573777
	.quad	4595907561721681272
	.quad	4607131523889307106
	.quad	4592313738171873501
	.quad	-4631058298682902317
	.quad	4607131523889307106
	.quad	4603832172546078948
	.quad	4605184393616543152
	.quad	-4618187643238232657
	.quad	4603832172546078949
	.quad	4606083857430732925
	.quad	4602293240464259995
	.quad	-4621078796390515815
	.quad	4606083857430732925
	.quad	4598759716522271959
	.quad	4606815674200603668
	.quad	-4616556362654172140
	.quad	4598759716522271960
	.quad	4606772892535716032
	.quad	4599041781019426730
	.quad	-4624330255835349080
	.quad	4606772892535716032
	.quad	4602033288334884886
	.quad	4606153331084715483
	.quad	-4617218705770060326
	.quad	4602033288334884891
	.quad	4605090897807026947
	.quad	4603946097519602146
	.quad	-4619425939335173662
	.quad	4605090897807026947
	.quad	4591140389033904025
	.quad	4607145969489710422
	.quad	-4616226067365065386
	.quad	4591140389033904013
	.quad	4607167652406027957
	.quad	4588409587781649820
	.quad	-4634962449073125981
	.quad	4607167652406027957
	.quad	4604169282369077299
	.quad	4604898377231879853
	.quad	-4618473659622895955
	.quad	4604169282369077298
	.quad	4606285852564613998
	.quad	4601506738408455407
	.quad	-4621865298446320401
	.quad	4606285852564613998
	.quad	4599601521717216528
	.quad	4606680435860999367
	.quad	-4616691600993776441
	.quad	4599601521717216526
	.quad	4606894286920073036
	.quad	4598191576788657611
	.quad	-4625180460066118197
	.quad	4606894286920073036
	.quad	4602742485134627871
	.quad	4605938577288607119
	.quad	-4617433459566168690
	.quad	4602742485134627873
	.quad	4605365731130717216
	.quad	4603599809995646684
	.quad	-4619772226859129125
	.quad	4605365731130717217
	.quad	4594162799529131502
	.quad	4607095443740158643
	.quad	-4616276593114617164
	.quad	4594162799529131488
	.quad	4607073818850941875
	.quad	4594745932174840368
	.quad	-4628626104679935443
	.quad	4607073818850941875
	.quad	4603481434627811100
	.quad	4605453524286937630
	.quad	-4617918512567838177
	.quad	4603481434627811100
	.quad	4605862809695470921
	.quad	4602868895726825279
	.quad	-4620503141127950531
	.quad	4605862809695470922
	.quad	4597636087768609273
	.quad	4606930096928128841
	.quad	-4616441939926646967
	.quad	4597636087768609283
	.quad	4606630785604057845
	.quad	4599879048061731727
	.quad	-4623492988793044082
	.quad	4606630785604057845
	.quad	4601240281581548784
	.quad	4606348864911325300
	.quad	-4617023171943450509
	.quad	4601240281581548785
	.quad	4604799404008662247
	.quad	4604278482493048243
	.quad	-4619093554361727565
	.quad	4604799404008662247
	.quad	4586054375214300582
	.quad	4607174883916901165
	.quad	-4616197152937874643
	.quad	4586054375214300623
	.quad	4607174883916901165
	.quad	4586054375214300604
	.quad	-4637317661640475244
	.quad	4607174883916901165
	.quad	4604278482493048244
	.quad	4604799404008662247
	.quad	-4618572632846113562
	.quad	4604278482493048244
	.quad	4606348864911325300
	.quad	4601240281581548783
	.quad	-4622131755273227026
	.quad	4606348864911325300
	.quad	4599879048061731728
	.quad	4606630785604057845
	.quad	-4616741251250717965
	.quad	4599879048061731737
	.quad	4606930096928128841
	.quad	4597636087768609271
	.quad	-4625735949086166539
	.quad	4606930096928128842
	.quad	4602868895726825279
	.quad	4605862809695470920
	.quad	-4617509227159304887
	.quad	4602868895726825278
	.quad	4605453524286937630
	.quad	4603481434627811100
	.quad	-4619890602226964710
	.quad	4605453524286937632
	.quad	4594745932174840370
	.quad	4607073818850941875
	.quad	-4616298218003833933
	.quad	4594745932174840364
	.quad	4607095443740158644
	.quad	4594162799529131496
	.quad	-4629209237325644311
	.quad	4607095443740158643
	.quad	4603599809995646685
	.quad	4605365731130717216
	.quad	-4618006305724058592
	.quad	4603599809995646684
	.quad	4605938577288607119
	.quad	4602742485134627871
	.quad	-4620629551720147937
	.quad	4605938577288607119
	.quad	4598191576788657614
	.quad	4606894286920073036
	.quad	-4616477749934702772
	.quad	4598191576788657611
	.quad	4606680435860999367
	.quad	4599601521717216525
	.quad	-4623770515137559282
	.quad	4606680435860999367
	.quad	4601506738408455406
	.quad	4606285852564613998
	.quad	-4617086184290161811
	.quad	4601506738408455410
	.quad	4604898377231879853
	.quad	4604169282369077298
	.quad	-4619202754485698511
	.quad	4604898377231879854
	.quad	4588409587781649844
	.quad	4607167652406027957
	.quad	-4616204384448747851
	.quad	4588409587781649853
	.quad	4607145969489710422
	.quad	4591140389033904015
	.quad	-4632231647820871792
	.quad	4607145969489710422
	.quad	4603946097519602146
	.quad	4605090897807026947
	.quad	-4618281139047748862
	.quad	4603946097519602147
	.quad	4606153331084715483
	.quad	4602033288334884885
	.quad	-4621338748519890920
	.quad	4606153331084715482
	.quad	4599041781019426730
	.quad	4606772892535716031
	.quad	-4616599144319059776
	.quad	4599041781019426728
	.quad	4606815674200603668
	.quad	4598759716522271957
	.quad	-4624612320332503855
	.quad	4606815674200603669
	.quad	4602293240464259995
	.quad	4606083857430732925
	.quad	-4617288179424042884
	.quad	4602293240464259996
	.quad	4605184393616543152
	.quad	4603832172546078948
	.quad	-4619539864308696861
	.quad	4605184393616543152
	.quad	4592313738171873500
	.quad	4607131523889307106
	.quad	-4616240512965468702
	.quad	4592313738171873504
	.quad	4607023428389202032
	.quad	4595907561721681253
	.quad	-4627464475133094558
	.quad	4607023428389202032
	.quad	4603240454158158275
	.quad	4605623241882183727
	.quad	-4617748794972592081
	.quad	4603240454158158276
	.quad	4605705120883705243
	.quad	4603117913572639878
	.quad	-4620254123282135931
	.quad	4605705120883705244
	.quad	4596485747626494352
	.quad	4606994676307424051
	.quad	-4616377360547351757
	.quad	4596485747626494362
	.quad	4606524707710321525
	.quad	4600429041259328501
	.quad	-4622942995595447309
	.quad	4606524707710321526
	.quad	4600701360865931759
	.quad	4606468308473143937
	.quad	-4616903728381631872
	.quad	4600701360865931764
	.quad	4604596164171470462
	.quad	4604491951969715217
	.quad	-4618880084885060591
	.quad	4604596164171470461
	.quad	4575869727671838431
	.quad	4607182117364343164
	.quad	-4616189919490432644
	.quad	4575869727671838595
	.quad	4607182343440783598
	.quad	4571366167502360383
	.quad	-4652005869352415340
	.quad	4607182343440783598
	.quad	4604518164662362005
	.quad	4604570271199191868
	.quad	-4618801765655583940
	.quad	4604518164662362005
	.quad	4606482617031866609
	.quad	4600633454565296398
	.quad	-4622738582289479412
	.quad	4606482617031866609
	.quad	4600497293622796670
	.quad	4606510816886391054
	.quad	-4616861219968384753
	.quad	4600497293622796668
	.quad	4607002086000174094
	.quad	4596341378780959594
	.quad	-4627030658073816211
	.quad	4607002086000174094
	.quad	4603148674064047368
	.quad	4605684839280277881
	.quad	-4617687197574497928
	.quad	4603148674064047369
	.quad	4605643899436991646
	.quad	4603209944869432169
	.quad	-4620162091985343640
	.quad	4605643899436991647
	.quad	4596052283409820537
	.quad	4607016462161342036
	.quad	-4616355574693433772
	.quad	4596052283409820540
	.quad	4607135360247013283
	.quad	4592020580616553876
	.quad	-4631351456238221935
	.quad	4607135360247013283
	.quad	4603860796972543366
	.quad	4605161194619176925
	.quad	-4618210842235598882
	.quad	4603860796972543364
	.quad	4606101425080533738
	.quad	4602228466119039344
	.quad	-4621143570735736468
	.quad	4606101425080533739
	.quad	4598830363309631729
	.quad	4606805195215531113
	.quad	-4616566841639244695
	.quad	4598830363309631727
	.quad	4606783804204118207
	.quad	4598971396738173143
	.quad	-4624400640116602665
	.quad	4606783804204118207
	.quad	4602098488966890712
	.quad	4606136162198155045
	.quad	-4617235874656620764
	.quad	4602098488966890713
	.quad	4605114446323296604
	.quad	4603917759935888766
	.quad	-4619454276918887042
	.quad	4605114446323296604
	.quad	4591433901139082655
	.quad	4607142583107645406
	.quad	-4616229453747130402
	.quad	4591433901139082644
	.quad	4607169686072741884
	.quad	4587820967054830423
	.quad	-4635551069799945399
	.quad	4607169686072741884
	.quad	4604196733995318949
	.quad	4604873801644686384
	.quad	-4618498235210089424
	.quad	4604196733995318949
	.quad	4606301809890173225
	.quad	4601440318079332105
	.quad	-4621931718775443704
	.quad	4606301809890173225
	.quad	4599671055048573316
	.quad	4606668236261546033
	.quad	-4616703800593229775
	.quad	4599671055048573317
	.quad	4606903458648397587
	.quad	4598065193390664000
	.quad	-4625306843464111811
	.quad	4606903458648397587
	.quad	4602774203744788123
	.quad	4605919829461033849
	.quad	-4617452207393741961
	.quad	4602774203744788125
	.quad	4605387860822438849
	.quad	4603570351074866714
	.quad	-4619801685779909093
	.quad	4605387860822438848
	.quad	4594308714160059052
	.quad	4607090261192590624
	.quad	-4616281775662185185
	.quad	4594308714160059062
	.quad	4607079448657518563
	.quad	4594600282922339760
	.quad	-4628771753932436055
	.quad	4607079448657518563
	.quad	4603511162895747729
	.quad	4605431757767815292
	.quad	-4617940279086960516
	.quad	4603511162895747728
	.quad	4605881945347506206
	.quad	4602837409569701877
	.quad	-4620534627285073931
	.quad	4605881945347506206
	.quad	4597779267866737432
	.quad	4606921363802229955
	.quad	-4616450673052545853
	.quad	4597779267866737427
	.quad	4606643410925372716
	.quad	4599809819381810432
	.quad	-4623562217472965380
	.quad	4606643410925372716
	.quad	4601307088551206533
	.quad	4606333316327129234
	.quad	-4617038720527646574
	.quad	4601307088551206530
	.quad	4604824314619041628
	.quad	4604251334514122700
	.quad	-4619120702340653109
	.quad	4604824314619041629
	.quad	4586643350918564874
	.quad	4607173301858430160
	.quad	-4616198734996345648
	.quad	4586643350918564915
	.quad	4607178726444709447
	.quad	4583909370989214467
	.quad	-4639462665865561344
	.quad	4607178726444709447
	.quad	4604359311861827169
	.quad	4604724008794823589
	.quad	-4618648028059952220
	.quad	4604359311861827170
	.quad	4606394689011550279
	.quad	4601039105271158641
	.quad	-4622332931583617171
	.quad	4606394689011550280
	.quad	4600086106259044396
	.quad	4606592061569423220
	.quad	-4616779975285352588
	.quad	4600086106259044397
	.quad	4606955416755529208
	.quad	4597205706886740345
	.quad	-4626166329968035464
	.quad	4606955416755529208
	.quad	4602962880858494192
	.quad	4605804632207108552
	.quad	-4617567404647667257
	.quad	4602962880858494195
	.quad	4605518091665514027
	.quad	4603391719084281849
	.quad	-4619980317770493957
	.quad	4605518091665514025
	.quad	4595182310176609084
	.quad	4607056036412969313
	.quad	-4616316000441806494
	.quad	4595182310176609078
	.quad	4607110095469846138
	.quad	4593724563940542140
	.quad	-4629647472914233672
	.quad	4607110095469846138
	.quad	4603687640172177027
	.quad	4605298621629023153
	.quad	-4618073415225752655
	.quad	4603687640172177027
	.quad	4605994040096587761
	.quad	4602614926599664752
	.quad	-4620757110255111063
	.quad	4605994040096587762
	.quad	4598405229182429276
	.quad	4606865896978440723
	.quad	-4616506139876335086
	.quad	4598405229182429281
	.quad	4606716179942333515
	.quad	4599392331031223536
	.quad	-4623979705823552274
	.quad	4606716179942333516
	.quad	4601705208325679436
	.quad	4606237167370599303
	.quad	-4617134869484176505
	.quad	4601705208325679437
	.quad	4604971427361900194
	.quad	4604086327540218527
	.quad	-4619285709314557281
	.quad	4604971427361900194
	.quad	4589671301350669799
	.quad	4607160648726313693
	.quad	-4616211388128462115
	.quad	4589671301350669819
	.quad	4607155227770462942
	.quad	4590259222194238006
	.quad	-4633112814660537814
	.quad	4607155227770462942
	.quad	4604030528993664950
	.quad	4605019559519168613
	.quad	-4618352477335607196
	.quad	4604030528993664951
	.quad	4606204035614645190
	.quad	4601836851314223463
	.quad	-4621535185540552349
	.quad	4606204035614645191
	.quad	4599252390002712847
	.quad	4606739295077973317
	.quad	-4616632741776802492
	.quad	4599252390002712852
	.quad	4606846242976400127
	.quad	4598547270057737642
	.quad	-4624824766797038165
	.quad	4606846242976400127
	.quad	4602486693577287813
	.quad	4606030361651535510
	.quad	-4617341675203240297
	.quad	4602486693577287811
	.quad	4605253285353956337
	.quad	4603745733239955116
	.quad	-4619626303614820692
	.quad	4605253285353956337
	.quad	4593192423245583966
	.quad	4607119115884478470
	.quad	-4616252920970297338
	.quad	4593192423245583954
	.quad	4607043438270524345
	.quad	4595472729712253363
	.quad	-4627899307142522439
	.quad	4607043438270524344
	.quad	4603331471446567879
	.quad	4605560522839321614
	.quad	-4617811514015454194
	.quad	4603331471446567879
	.quad	4605765208354974426
	.quad	4603025137924307723
	.quad	-4620346898930468085
	.quad	4605765208354974427
	.quad	4596918109820348104
	.quad	4606971562275758197
	.quad	-4616400474579017610
	.quad	4596918109820348091
	.quad	4606565540986570617
	.quad	4600223610310562333
	.quad	-4623148426544213476
	.quad	4606565540986570617
	.quad	4600904369455937494
	.quad	4606424551151208662
	.quad	-4616947485703567147
	.quad	4600904369455937499
	.quad	4604673196709936303
	.quad	4604412681463570213
	.quad	-4618959355391205598
	.quad	4604673196709936306
	.quad	4581552008522278269
	.quad	4607180534882221152
	.quad	-4616191501972554656
	.quad	4581552008522278222
	.quad	4607180534882221152
	.quad	4581552008522278250
	.quad	-4641820028332497575
	.quad	4607180534882221152
	.quad	4604412681463570213
	.quad	4604673196709936303
	.quad	-4618698840144839503
	.quad	4604412681463570212
	.quad	4606424551151208663
	.quad	4600904369455937493
	.quad	-4622467667398838316
	.quad	4606424551151208663
	.quad	4600223610310562334
	.quad	4606565540986570617
	.quad	-4616806495868205192
	.quad	4600223610310562339
	.quad	4606971562275758197
	.quad	4596918109820348102
	.quad	-4626453927034427708
	.quad	4606971562275758197
	.quad	4603025137924307723
	.quad	4605765208354974426
	.quad	-4617606828499801382
	.quad	4603025137924307724
	.quad	4605560522839321615
	.quad	4603331471446567878
	.quad	-4620040565408207930
	.quad	4605560522839321615
	.quad	4595472729712253373
	.quad	4607043438270524344
	.quad	-4616328598584251464
	.quad	4595472729712253368
	.quad	4607119115884478470
	.quad	4593192423245583954
	.quad	-4630179613609191851
	.quad	4607119115884478470
	.quad	4603745733239955116
	.quad	4605253285353956337
	.quad	-4618118751500819472
	.quad	4603745733239955118
	.quad	4606030361651535511
	.quad	4602486693577287810
	.quad	-4620885343277488000
	.quad	4606030361651535512
	.quad	4598547270057737642
	.quad	4606846242976400127
	.quad	-4616525793878375681
	.quad	4598547270057737639
	.quad	4606739295077973316
	.quad	4599252390002712848
	.quad	-4624119646852062963
	.quad	4606739295077973317
	.quad	4601836851314223465
	.quad	4606204035614645190
	.quad	-4617168001240130618
	.quad	4601836851314223462
	.quad	4605019559519168613
	.quad	4604030528993664950
	.quad	-4619341507861110858
	.quad	4605019559519168613
	.quad	4590259222194238003
	.quad	4607155227770462942
	.quad	-4616216809084312866
	.quad	4590259222194238007
	.quad	4607160648726313693
	.quad	4589671301350669806
	.quad	-4633700735504106018
	.quad	4607160648726313693
	.quad	4604086327540218527
	.quad	4604971427361900193
	.quad	-4618400609492875615
	.quad	4604086327540218528
	.quad	4606237167370599303
	.quad	4601705208325679434
	.quad	-4621666828529096374
	.quad	4606237167370599304
	.quad	4599392331031223536
	.quad	4606716179942333515
	.quad	-4616655856912442294
	.quad	4599392331031223544
	.quad	4606865896978440723
	.quad	4598405229182429274
	.quad	-4624966807672346534
	.quad	4606865896978440723
	.quad	4602614926599664751
	.quad	4605994040096587761
	.quad	-4617377996758188046
	.quad	4602614926599664748
	.quad	4605298621629023153
	.quad	4603687640172177027
	.quad	-4619684396682598783
	.quad	4605298621629023154
	.quad	4593724563940542140
	.quad	4607110095469846138
	.quad	-4616261941384929670
	.quad	4593724563940542134
	.quad	4607056036412969314
	.quad	4595182310176609083
	.quad	-4628189726678166728
	.quad	4607056036412969314
	.quad	4603391719084281850
	.quad	4605518091665514026
	.quad	-4617853945189261784
	.quad	4603391719084281852
	.quad	4605804632207108552
	.quad	4602962880858494193
	.quad	-4620409155996281615
	.quad	4605804632207108551
	.quad	4597205706886740348
	.quad	4606955416755529208
	.quad	-4616416620099246600
	.quad	4597205706886740342
	.quad	4606592061569423220
	.quad	4600086106259044395
	.quad	-4623285930595731411
	.quad	4606592061569423219
	.quad	4601039105271158643
	.quad	4606394689011550278
	.quad	-4616977347843225530
	.quad	4601039105271158644
	.quad	4604724008794823589
	.quad	4604359311861827169
	.quad	-4619012724992948640
	.quad	4604724008794823589
	.quad	4583909370989214499
	.quad	4607178726444709447
	.quad	-4616193310410066361
	.quad	4583909370989214517
	.quad	4607173301858430160
	.quad	4586643350918564876
	.quad	-4636728685936210952
	.quad	4607173301858430160
	.quad	4604251334514122700
	.quad	4604824314619041627
	.quad	-4618547722235734180
	.quad	4604251334514122700
	.quad	4606333316327129234
	.quad	4601307088551206532
	.quad	-4622064948303569274
	.quad	4606333316327129233
	.quad	4599809819381810434
	.quad	4606643410925372715
	.quad	-4616728625929403092
	.quad	4599809819381810431
	.quad	4606921363802229955
	.quad	4597779267866737425
	.quad	-4625592768988038388
	.quad	4606921363802229956
	.quad	4602837409569701877
	.quad	4605881945347506206
	.quad	-4617490091507269603
	.quad	4602837409569701879
	.quad	4605431757767815292
	.quad	4603511162895747728
	.quad	-4619860873959028081
	.quad	4605431757767815293
	.quad	4594600282922339757
	.quad	4607079448657518563
	.quad	-4616292588197257245
	.quad	4594600282922339767
	.quad	4607090261192590624
	.quad	4594308714160059048
	.quad	-4629063322694716761
	.quad	4607090261192590624
	.quad	4603570351074866715
	.quad	4605387860822438848
	.quad	-4617984176032336961
	.quad	4603570351074866717
	.quad	4605919829461033849
	.quad	4602774203744788122
	.quad	-4620597833109987685
	.quad	4605919829461033848
	.quad	4598065193390664001
	.quad	4606903458648397587
	.quad	-4616468578206378222
	.quad	4598065193390664011
	.quad	4606668236261546033
	.quad	4599671055048573315
	.quad	-4623700981806202498
	.quad	4606668236261546034
	.quad	4601440318079332106
	.quad	4606301809890173225
	.quad	-4617070226964602584
	.quad	4601440318079332107
	.quad	4604873801644686384
	.quad	4604196733995318949
	.quad	-4619175302859456860
	.quad	4604873801644686385
	.quad	4587820967054830427
	.quad	4607169686072741884
	.quad	-4616202350782033925
	.quad	4587820967054830500
	.quad	4607142583107645406
	.quad	4591433901139082636
	.quad	-4631938135715693161
	.quad	4607142583107645406
	.quad	4603917759935888767
	.quad	4605114446323296603
	.quad	-4618257590531479205
	.quad	4603917759935888767
	.quad	4606136162198155045
	.quad	4602098488966890711
	.quad	-4621273547887885098
	.quad	4606136162198155045
	.quad	4598971396738173145
	.quad	4606783804204118207
	.quad	-4616588232650657601
	.quad	4598971396738173146
	.quad	4606805195215531113
	.quad	4598830363309631729
	.quad	-4624541673545144081
	.quad	4606805195215531113
	.quad	4602228466119039345
	.quad	4606101425080533737
	.quad	-4617270611774242070
	.quad	4602228466119039342
	.quad	4605161194619176925
	.quad	4603860796972543365
	.quad	-4619511239882232446
	.quad	4605161194619176927
	.quad	4592020580616553882
	.quad	4607135360247013283
	.quad	-4616236676607762526
	.quad	4592020580616553902
	.quad	4607016462161342037
	.quad	4596052283409820532
	.quad	-4627319753444955275
	.quad	4607016462161342037
	.quad	4603209944869432170
	.quad	4605643899436991646
	.quad	-4617728137417784162
	.quad	4603209944869432169
	.quad	4605684839280277882
	.quad	4603148674064047368
	.quad	-4620223362790728440
	.quad	4605684839280277881
	.quad	4596341378780959601
	.quad	4607002086000174093
	.quad	-4616369950854601714
	.quad	4596341378780959596
	.quad	4606510816886391055
	.quad	4600497293622796668
	.quad	-4622874743231979140
	.quad	4606510816886391055
	.quad	4600633454565296398
	.quad	4606482617031866609
	.quad	-4616889419822909200
	.quad	4600633454565296403
	.quad	4604570271199191868
	.quad	4604518164662362005
	.quad	-4618853872192413804
	.quad	4604570271199191870
	.quad	4571366167502360609
	.quad	4607182343440783598
	.quad	-4616189693413992210
	.quad	4571366167502360167
	.quad	4607182399960189253
	.quad	4566862577739493964
	.quad	-4656509459115282342
	.quad	4607182399960189253
	.quad	4604531231234577377
	.quad	4604557284557486510
	.quad	-4618814752297289299
	.quad	4604531231234577377
	.quad	4606489719197873769
	.quad	4600599457658951873
	.quad	-4622772579195823935
	.quad	4606489719197873769
	.quad	4600531377045301797
	.quad	4606503819154628041
	.quad	-4616868217700147768
	.quad	4600531377045301806
	.quad	4607005735466349744
	.quad	4596269149194902281
	.quad	-4627102887659873526
	.quad	4607005735466349744
	.quad	4603164023133853738
	.quad	4605674651335032539
	.quad	-4617697385519743268
	.quad	4603164023133853736
	.quad	4605654181370573603
	.quad	4603194658600624539
	.quad	-4620177378254151271
	.quad	4605654181370573604
	.quad	4596124601206990238
	.quad	4607012923561968632
	.quad	-4616359113292807176
	.quad	4596124601206990232
	.quad	4607137222205643665
	.quad	4591873955372931557
	.quad	-4631498081481844258
	.quad	4607137222205643665
	.quad	4603875073539124506
	.quad	4605149551259743449
	.quad	-4618222485595032361
	.quad	4603875073539124508
	.quad	4606110159187440325
	.quad	4602196025185095502
	.quad	-4621176011669680305
	.quad	4606110159187440325
	.quad	4598865654406453959
	.quad	4606799901559562511
	.quad	-4616572135295213296
	.quad	4598865654406453956
	.quad	4606789206031484853
	.quad	4598936171268220631
	.quad	-4624435865586555175
	.quad	4606789206031484852
	.quad	4602131036473088126
	.quad	4606127527782579846
	.quad	-4617244509072195962
	.quad	4602131036473088127
	.quad	4605126177062912858
	.quad	4603903555080370369
	.quad	-4619468481774405440
	.quad	4605126177062912858
	.quad	4591580615020633208
	.quad	4607140833643513559
	.quad	-4616231203211262249
	.quad	4591580615020633212
	.quad	4607170646468598772
	.quad	4587526608008965539
	.quad	-4635845428845810260
	.quad	4607170646468598772
	.quad	4604210422052581644
	.quad	4604861471792269747
	.quad	-4618510565062506062
	.quad	4604210422052581645
	.quad	4606309737575874718
	.quad	4601407059097287477
	.quad	-4621964977757488333
	.quad	4606309737575874718
	.quad	4599705784140949715
	.quad	4606662083155995116
	.quad	-4616709953698780691
	.quad	4599705784140949712
	.quad	4606907989753082767
	.quad	4597993767091577479
	.quad	-4625378269763198335
	.quad	4606907989753082767
	.quad	4602790034224747065
	.quad	4605910406930773221
	.quad	-4617461629924002586
	.quad	4602790034224747063
	.quad	4605398880432641044
	.quad	4603555587729607778
	.quad	-4619816449125168029
	.quad	4605398880432641044
	.quad	4594381639370641434
	.quad	4607087613972145036
	.quad	-4616284422882630772
	.quad	4594381639370641436
	.quad	4607082207693301011
	.quad	4594527424056711032
	.quad	-4628844612798064777
	.quad	4607082207693301011
	.quad	4603525993578147942
	.quad	4605420828951237689
	.quad	-4617951207903538119
	.quad	4603525993578147942
	.quad	4605891464834389333
	.quad	4602821637203306030
	.quad	-4620550399651469779
	.quad	4605891464834389333
	.quad	4597850804030586779
	.quad	4606916942348724568
	.quad	-4616455094506051240
	.quad	4597850804030586781
	.quad	4606649670461945556
	.quad	4599775166452691169
	.quad	-4623596870402084640
	.quad	4606649670461945556
	.quad	4601340444193890222
	.quad	4606325490827302870
	.quad	-4617046546027472939
	.quad	4601340444193890227
	.quad	4604836728227692713
	.quad	4604237722369085983
	.quad	-4619134314485689823
	.quad	4604836728227692711
	.quad	4586937798709255042
	.quad	4607172454365224381
	.quad	-4616199582489551427
	.quad	4586937798709255082
	.quad	4607179235055524786
	.quad	4583320075990952851
	.quad	-4640051960863822915
	.quad	4607179235055524786
	.quad	4604372693206777122
	.quad	4604711346734186659
	.quad	-4618660690120589149
	.quad	4604372693206777122
	.quad	4606402206201441658
	.quad	4601005467195804672
	.quad	-4622366569658971137
	.quad	4606402206201441658
	.quad	4600120522882128575
	.quad	4606585484169776453
	.quad	-4616786552684999355
	.quad	4600120522882128576
	.quad	4606959508273248265
	.quad	4597133857304417545
	.quad	-4626238179550358265
	.quad	4606959508273248265
	.quad	4602978475330140151
	.quad	4605794824015311573
	.quad	-4617577212839464234
	.quad	4602978475330140149
	.quad	4605528745646185892
	.quad	4603376689750694281
	.quad	-4619995347104081529
	.quad	4605528745646185893
	.quad	4595254953559313848
	.quad	4607052942571252535
	.quad	-4616319094283523273
	.quad	4595254953559313859
	.quad	4607112406663140763
	.quad	4593631292438356073
	.quad	-4629740744416419733
	.quad	4607112406663140763
	.quad	4603702198181267863
	.quad	4605287332140834841
	.quad	-4618084704713940966
	.quad	4603702198181267863
	.quad	4606003169643131349
	.quad	4602582924127750766
	.quad	-4620789112727025041
	.quad	4606003169643131349
	.quad	4598440769475874646
	.quad	4606861037960258297
	.quad	-4616510998894517511
	.quad	4598440769475874644
	.quad	4606722012380924717
	.quad	4599357381305483682
	.quad	-4624014655549292125
	.quad	4606722012380924717
	.quad	4601738169827508080
	.quad	4606228934933442367
	.quad	-4617143101921333443
	.quad	4601738169827508085
	.quad	4604983503173042407
	.quad	4604072414849698700
	.quad	-4619299622005077109
	.quad	4604983503173042408
	.quad	4589818314516734672
	.quad	4607159349856449560
	.quad	-4616212686998326248
	.quad	4589818314516734644
	.quad	4607156639372854826
	.quad	4590112275553379744
	.quad	-4633259761301396065
	.quad	4607156639372854826
	.quad	4604044515518066524
	.quad	4605007569302014320
	.quad	-4618364467552761489
	.quad	4604044515518066525
	.quad	4606212369020815366
	.quad	4601803991459455325
	.quad	-4621568045395320480
	.quad	4606212369020815365
	.quad	4599287410644874830
	.quad	4606733569972918952
	.quad	-4616638466881856857
	.quad	4599287410644874834
	.quad	4606851210938683397
	.quad	4598511790062078404
	.quad	-4624860246792697408
	.quad	4606851210938683398
	.quad	4602518807482453286
	.quad	4606021330458591132
	.quad	-4617350706396184676
	.quad	4602518807482453287
	.quad	4605264663955887727
	.quad	4603731244775911958
	.quad	-4619640792078863850
	.quad	4605264663955887726
	.quad	4593338749467663970
	.quad	4607116916879890684
	.quad	-4616255119974885125
	.quad	4593338749467664006
	.quad	4607046643486854627
	.quad	4595400163630863340
	.quad	-4627971873223912473
	.quad	4607046643486854627
	.quad	4603346565868828947
	.quad	4605549961277465171
	.quad	-4617822075577310637
	.quad	4603346565868828948
	.quad	4605775112048014150
	.quad	4603009603928156771
	.quad	-4620362432926619039
	.quad	4605775112048014151
	.quad	4596990058470445871
	.quad	4606967581050248111
	.quad	-4616404455804527697
	.quad	4596990058470445880
	.quad	4606572223850614323
	.quad	4600189275051692406
	.quad	-4623182761803083404
	.quad	4606572223850614324
	.quad	4600938099147284321
	.quad	4606417137302501354
	.quad	-4616954899552274453
	.quad	4600938099147284318
	.quad	4604685940638602583
	.quad	4604399378063463786
	.quad	-4618972658791312022
	.quad	4604685940638602583
	.quad	4582141392292101513
	.quad	4607180139276171944
	.quad	-4616191897578603864
	.quad	4582141392292101466
	.quad	4607181495663884907
	.quad	4579406617200606685
	.quad	-4643965419654169143
	.quad	4607181495663884907
	.quad	4604452434883447507
	.quad	4604634802040518370
	.quad	-4618737234814257438
	.quad	4604452434883447508
	.quad	4606446585518303245
	.quad	4600802999407138174
	.quad	-4622569037447637638
	.quad	4606446585518303246
	.quad	4600326451060261009
	.quad	4606545281912504745
	.quad	-4616826754942271063
	.quad	4600326451060261010
	.quad	4606983285100936040
	.quad	4596702070549788228
	.quad	-4626669966304987581
	.quad	4606983285100936040
	.quad	4603071617921789512
	.quad	4605735306935848472
	.quad	-4617636729918927337
	.quad	4603071617921789513
	.quad	4605592021979962507
	.quad	4603286059012471718
	.quad	-4620085977842304089
	.quad	4605592021979962506
	.quad	4595690268496446591
	.quad	4607033600086373486
	.quad	-4616338436768402323
	.quad	4595690268496446601
	.quad	4607125488373174117
	.quad	4592753232978334653
	.quad	-4630618803876441166
	.quad	4607125488373174117
	.quad	4603789058571950232
	.quad	4605218972081900674
	.quad	-4618153064772875134
	.quad	4603789058571950231
	.quad	4606057257918279117
	.quad	4602390131144283878
	.quad	-4620981905710491929
	.quad	4606057257918279116
	.quad	4598653587074128609
	.quad	4606831121533410656
	.quad	-4616540915321365152
	.quad	4598653587074128606
	.quad	4606756255342418545
	.quad	4599147188587102585
	.quad	-4624224848267673225
	.quad	4606756255342418545
	.quad	4601935225384591778
	.quad	4606178834015460908
	.quad	-4617193202839314901
	.quad	4601935225384591783
	.quad	4605055358179763239
	.quad	4603988422688539902
	.quad	-4619383614166235907
	.quad	4605055358179763240
	.quad	4590699919230625899
	.quad	4607150767592242166
	.quad	-4616221269262533642
	.quad	4590699919230625920
	.quad	4607164319783442478
	.quad	4589230138641731883
	.quad	-4634141898213043939
	.quad	4607164319783442478
	.quad	4604127917012495495
	.quad	4604935029548403001
	.quad	-4618437007306372808
	.quad	4604127917012495496
	.quad	4606261662192604249
	.quad	4601606122731840594
	.quad	-4621765914122935218
	.quad	4606261662192604250
	.quad	4599497036036032185
	.quad	4606698468349416499
	.quad	-4616673568505359309
	.quad	4599497036036032190
	.quad	4606880255819104681
	.quad	4598298490085066781
	.quad	-4625073546769709027
	.quad	4606880255819104681
	.quad	4602694764089540670
	.quad	4605966455360409847
	.quad	-4617405581494365960
	.quad	4602694764089540669
	.quad	4605332311110096290
	.quad	4603643828028921125
	.quad	-4619728208825854683
	.quad	4605332311110096290
	.quad	4593943771637006289
	.quad	4607102937666773044
	.quad	-4616269099188002763
	.quad	4593943771637006284
	.quad	4607065094981348389
	.quad	4594964230287739908
	.quad	-4628407806567035896
	.quad	4607065094981348389
	.quad	4603436675901475487
	.quad	4605485945598577762
	.quad	-4617886091256198047
	.quad	4603436675901475488
	.quad	4605833865123128398
	.quad	4602915977536089169
	.quad	-4620456059318686640
	.quad	4605833865123128398
	.quad	4597421052688677389
	.quad	4606942921891347927
	.quad	-4616429114963427881
	.quad	4597421052688677391
	.quad	4606611582398887126
	.quad	4599982695964611123
	.quad	-4623389340890164686
	.quad	4606611582398887126
	.quad	4601139834013373535
	.quad	4606371931262219460
	.quad	-4617000105592556347
	.quad	4601139834013373532
	.quad	4604761830392830739
	.quad	4604319012832610098
	.quad	-4619053024022165713
	.quad	4604761830392830741
	.quad	4585170729830362415
	.quad	4607176974636300988
	.quad	-4616195062218474820
	.quad	4585170729830362456
	.quad	4607175618475548194
	.quad	4585759849764578068
	.quad	-4637612187090197757
	.quad	4607175618475548194
	.quad	4604292018213369414
	.quad	4604786907111142063
	.quad	-4618585129743633745
	.quad	4604292018213369414
	.quad	4606356587930650888
	.quad	4601206830534047129
	.quad	-4622165206320728681
	.quad	4606356587930650888
	.quad	4599913623522930658
	.quad	4606624419872131096
	.quad	-4616747616982644713
	.quad	4599913623522930659
	.quad	4606934408563989210
	.quad	4597564444433293225
	.quad	-4625807592421482588
	.quad	4606934408563989210
	.quad	4602884609385837353
	.quad	4605853193610368595
	.quad	-4617518843244407215
	.quad	4602884609385837355
	.quad	4605464361898426873
	.quad	4603466537166636420
	.quad	-4619905499688139387
	.quad	4605464361898426873
	.quad	4594818721952420328
	.quad	4607070948103698704
	.quad	-4616301088751077104
	.quad	4594818721952420322
	.quad	4607097979045601017
	.quad	4594089810719188408
	.quad	-4629282226135587408
	.quad	4607097979045601017
	.quad	4603614505447932739
	.quad	4605354621141772524
	.quad	-4618017415713003284
	.quad	4603614505447932740
	.quad	4605947902507492309
	.quad	4602726597137114458
	.quad	-4620645439717661349
	.quad	4605947902507492308
	.quad	4598227233661239561
	.quad	4606889646334801594
	.quad	-4616482390519974216
	.quad	4598227233661239570
	.quad	4606686482303867416
	.quad	4599566717769113685
	.quad	-4623805319085662123
	.quad	4606686482303867416
	.quad	4601539899477679099
	.quad	4606277822991510261
	.quad	-4617094213863265548
	.quad	4601539899477679103
	.quad	4604910622863850068
	.quad	4604155518914936242
	.quad	-4619216517939839567
	.quad	4604910622863850069
	.quad	4588703847000237727
	.quad	4607166579143678320
	.quad	-4616205457711097488
	.quad	4588703847000237704
	.quad	4607147606393477399
	.quad	4590993592038119924
	.quad	-4632378444816655889
	.quad	4607147606393477399
	.quad	4603960230129253017
	.quad	4605079080128883633
	.quad	-4618292956725892174
	.quad	4603960230129253017
	.quad	4606161865483878426
	.quad	4602000635481829113
	.quad	-4621371401372946699
	.quad	4606161865483878427
	.quad	4599076939536290495
	.quad	4606767382740327089
	.quad	-4616604654114448720
	.quad	4599076939536290499
	.quad	4606820859485871070
	.quad	4598724361127269861
	.quad	-4624647675727505948
	.quad	4606820859485871070
	.quad	4602325573604567440
	.quad	4606075023961329136
	.quad	-4617297012893446672
	.quad	4602325573604567441
	.quad	4605195949157427950
	.quad	4603817824805939725
	.quad	-4619554212048836083
	.quad	4605195949157427951
	.quad	4592460269257210012
	.quad	4607129549506279878
	.quad	-4616242487348495930
	.quad	4592460269257210033
	.quad	4607026855988546925
	.quad	4595835158436123343
	.quad	-4627536878418652464
	.quad	4607026855988546925
	.quad	4603255677050447786
	.quad	4605612866347374146
	.quad	-4617759170507401663
	.quad	4603255677050447787
	.quad	4605715214457043592
	.quad	4603102502279718573
	.quad	-4620269534575057236
	.quad	4605715214457043593
	.quad	4596557886282036190
	.quad	4606990916111846494
	.quad	-4616381120742929314
	.quad	4596557886282036177
	.quad	4606531600744379746
	.quad	4600394872603884361
	.quad	-4622977164250891451
	.quad	4606531600744379746
	.quad	4600735269976151373
	.quad	4606461102140285166
	.quad	-4616910934714490642
	.quad	4600735269976151371
	.quad	4604609070393726087
	.quad	4604478805958938890
	.quad	-4618893230895836918
	.quad	4604609070393726087
	.quad	4577048717152922831
	.quad	4607181947808254125
	.quad	-4616190089046521683
	.quad	4577048717152922866
	.quad	4607181947808254125
	.quad	4577048717152922858
	.quad	-4646323319701853048
	.quad	4607181947808254125
	.quad	4604478805958938890
	.quad	4604609070393726087
	.quad	-4618762966461049722
	.quad	4604478805958938891
	.quad	4606461102140285167
	.quad	4600735269976151370
	.quad	-4622636766878624437
	.quad	4606461102140285166
	.quad	4600394872603884359
	.quad	4606531600744379746
	.quad	-4616840436110396063
	.quad	4600394872603884364
	.quad	4606990916111846494
	.quad	4596557886282036184
	.quad	-4626814150572739622
	.quad	4606990916111846494
	.quad	4603102502279718573
	.quad	4605715214457043592
	.quad	-4617656822397732216
	.quad	4603102502279718573
	.quad	4605612866347374146
	.quad	4603255677050447785
	.quad	-4620116359804328022
	.quad	4605612866347374146
	.quad	4595835158436123349
	.quad	4607026855988546925
	.quad	-4616345180866228883
	.quad	4595835158436123343
	.quad	4607129549506279878
	.quad	4592460269257210024
	.quad	-4630911767597565804
	.quad	4607129549506279878
	.quad	4603817824805939725
	.quad	4605195949157427950
	.quad	-4618176087697347858
	.quad	4603817824805939726
	.quad	4606075023961329136
	.quad	4602325573604567439
	.quad	-4621046463250208370
	.quad	4606075023961329136
	.quad	4598724361127269863
	.quad	4606820859485871070
	.quad	-4616551177368904739
	.quad	4598724361127269871
	.quad	4606767382740327089
	.quad	4599076939536290494
	.quad	-4624295097318485316
	.quad	4606767382740327089
	.quad	4602000635481829114
	.quad	4606161865483878426
	.quad	-4617210171370897381
	.quad	4602000635481829112
	.quad	4605079080128883634
	.quad	4603960230129253016
	.quad	-4619411806725522793
	.quad	4605079080128883635
	.quad	4590993592038119928
	.quad	4607147606393477399
	.quad	-4616224430461298409
	.quad	4590993592038119917
	.quad	4607166579143678320
	.quad	4588703847000237727
	.quad	-4634668189854538098
	.quad	4607166579143678320
	.quad	4604155518914936243
	.quad	4604910622863850068
	.quad	-4618461413990925740
	.quad	4604155518914936242
	.quad	4606277822991510261
	.quad	4601539899477679099
	.quad	-4621832137377096715
	.quad	4606277822991510262
	.quad	4599566717769113687
	.quad	4606686482303867416
	.quad	-4616685554550908393
	.quad	4599566717769113691
	.quad	4606889646334801594
	.quad	4598227233661239561
	.quad	-4625144803193536249
	.quad	4606889646334801594
	.quad	4602726597137114460
	.quad	4605947902507492308
	.quad	-4617424134347283500
	.quad	4602726597137114460
	.quad	4605354621141772524
	.quad	4603614505447932740
	.quad	-4619757531406843070
	.quad	4605354621141772525
	.quad	4594089810719188404
	.quad	4607097979045601017
	.quad	-4616274057809174791
	.quad	4594089810719188414
	.quad	4607070948103698704
	.quad	4594818721952420324
	.quad	-4628553314902355485
	.quad	4607070948103698704
	.quad	4603466537166636421
	.quad	4605464361898426873
	.quad	-4617907674956348936
	.quad	4603466537166636422
	.quad	4605853193610368595
	.quad	4602884609385837352
	.quad	-4620487427468938454
	.quad	4605853193610368594
	.quad	4597564444433293225
	.quad	4606934408563989210
	.quad	-4616437628290786597
	.quad	4597564444433293219
	.quad	4606624419872131096
	.quad	4599913623522930656
	.quad	-4623458413331845156
	.quad	4606624419872131097
	.quad	4601206830534047129
	.quad	4606356587930650888
	.quad	-4617015448924124921
	.quad	4601206830534047130
	.quad	4604786907111142064
	.quad	4604292018213369414
	.quad	-4619080018641406395
	.quad	4604786907111142064
	.quad	4585759849764578069
	.quad	4607175618475548194
	.quad	-4616196418379227614
	.quad	4585759849764578078
	.quad	4607176974636300988
	.quad	4585170729830362403
	.quad	-4638201307024413410
	.quad	4607176974636300988
	.quad	4604319012832610098
	.quad	4604761830392830738
	.quad	-4618610206461945068
	.quad	4604319012832610096
	.quad	4606371931262219461
	.quad	4601139834013373534
	.quad	-4622232202841402275
	.quad	4606371931262219461
	.quad	4599982695964611124
	.quad	4606611582398887126
	.quad	-4616760454455888682
	.quad	4599982695964611121
	.quad	4606942921891347927
	.quad	4597421052688677386
	.quad	-4625950984166098423
	.quad	4606942921891347927
	.quad	4602915977536089169
	.quad	4605833865123128397
	.quad	-4617538171731647411
	.quad	4602915977536089170
	.quad	4605485945598577762
	.quad	4603436675901475487
	.quad	-4619935360953300321
	.quad	4605485945598577762
	.quad	4594964230287739917
	.quad	4607065094981348389
	.quad	-4616306941873427419
	.quad	4594964230287739911
	.quad	4607102937666773045
	.quad	4593943771637006282
	.quad	-4629428265217769523
	.quad	4607102937666773045
	.quad	4603643828028921126
	.quad	4605332311110096290
	.quad	-4618039725744679519
	.quad	4603643828028921127
	.quad	4605966455360409848
	.quad	4602694764089540669
	.quad	-4620677272765235141
	.quad	4605966455360409848
	.quad	4598298490085066779
	.quad	4606880255819104682
	.quad	-4616491781035671127
	.quad	4598298490085066784
	.quad	4606698468349416499
	.quad	4599497036036032185
	.quad	-4623875000818743625
	.quad	4606698468349416500
	.quad	4601606122731840595
	.quad	4606261662192604248
	.quad	-4617110374662171559
	.quad	4601606122731840593
	.quad	4604935029548403002
	.quad	4604127917012495494
	.quad	-4619244119842280313
	.quad	4604935029548403002
	.quad	4589230138641731878
	.quad	4607164319783442478
	.quad	-4616207717071333330
	.quad	4589230138641731914
	.quad	4607150767592242166
	.quad	4590699919230625904
	.quad	-4632672117624149917
	.quad	4607150767592242166
	.quad	4603988422688539902
	.quad	4605055358179763239
	.quad	-4618316678675012569
	.quad	4603988422688539902
	.quad	4606178834015460907
	.quad	4601935225384591780
	.quad	-4621436811470184028
	.quad	4606178834015460907
	.quad	4599147188587102588
	.quad	4606756255342418544
	.quad	-4616615781512357263
	.quad	4599147188587102586
	.quad	4606831121533410656
	.quad	4598653587074128607
	.quad	-4624718449780647205
	.quad	4606831121533410657
	.quad	4602390131144283878
	.quad	4606057257918279117
	.quad	-4617314778936496692
	.quad	4602390131144283882
	.quad	4605218972081900674
	.quad	4603789058571950231
	.quad	-4619582978282825578
	.quad	4605218972081900675
	.quad	4592753232978334651
	.quad	4607125488373174117
	.quad	-4616246548481601691
	.quad	4592753232978334671
	.quad	4607033600086373486
	.quad	4595690268496446590
	.quad	-4627681768358329221
	.quad	4607033600086373486
	.quad	4603286059012471717
	.quad	4605592021979962507
	.quad	-4617780014874813303
	.quad	4603286059012471720
	.quad	4605735306935848473
	.quad	4603071617921789510
	.quad	-4620300418932986296
	.quad	4605735306935848472
	.quad	4596702070549788231
	.quad	4606983285100936040
	.quad	-4616388751753839769
	.quad	4596702070549788241
	.quad	4606545281912504745
	.quad	4600326451060261008
	.quad	-4623045585794514797
	.quad	4606545281912504745
	.quad	4600802999407138175
	.quad	4606446585518303245
	.quad	-4616925451336472564
	.quad	4600802999407138176
	.quad	4604634802040518371
	.quad	4604452434883447507
	.quad	-4618919601971328301
	.quad	4604634802040518371
	.quad	4579406617200606735
	.quad	4607181495663884907
	.quad	-4616190541190890901
	.quad	4579406617200606515
	.quad	4607180139276171944
	.quad	4582141392292101474
	.quad	-4641230644562674331
	.quad	4607180139276171944
	.quad	4604399378063463787
	.quad	4604685940638602583
	.quad	-4618686096216173226
	.quad	4604399378063463788
	.quad	4606417137302501354
	.quad	4600938099147284319
	.quad	-4622433937707491489
	.quad	4606417137302501354
	.quad	4600189275051692406
	.quad	4606572223850614323
	.quad	-4616799813004161484
	.quad	4600189275051692403
	.quad	4606967581050248111
	.quad	4596990058470445873
	.quad	-4626381978384329942
	.quad	4606967581050248112
	.quad	4603009603928156770
	.quad	4605775112048014150
	.quad	-4617596924806761658
	.quad	4603009603928156771
	.quad	4605549961277465172
	.quad	4603346565868828946
	.quad	-4620025470985946862
	.quad	4605549961277465172
	.quad	4595400163630863339
	.quad	4607046643486854627
	.quad	-4616325393367921181
	.quad	4595400163630863341
	.quad	4607116916879890684
	.quad	4593338749467663969
	.quad	-4630033287387111847
	.quad	4607116916879890684
	.quad	4603731244775911959
	.quad	4605264663955887726
	.quad	-4618107372898888083
	.quad	4603731244775911960
	.quad	4606021330458591132
	.quad	4602518807482453287
	.quad	-4620853229372322524
	.quad	4606021330458591133
	.quad	4598511790062078406
	.quad	4606851210938683397
	.quad	-4616520825916092411
	.quad	4598511790062078407
	.quad	4606733569972918952
	.quad	4599287410644874829
	.quad	-4624084626209900981
	.quad	4606733569972918953
	.quad	4601803991459455327
	.quad	4606212369020815366
	.quad	-4617159667833960444
	.quad	4601803991459455331
	.quad	4605007569302014321
	.quad	4604044515518066524
	.quad	-4619327521336709284
	.quad	4605007569302014320
	.quad	4590112275553379752
	.quad	4607156639372854826
	.quad	-4616215397481920982
	.quad	4590112275553379772
	.quad	4607159349856449560
	.quad	4589818314516734658
	.quad	-4633553722338041145
	.quad	4607159349856449560
	.quad	4604072414849698701
	.quad	4604983503173042407
	.quad	-4618388533681733401
	.quad	4604072414849698701
	.quad	4606228934933442367
	.quad	4601738169827508080
	.quad	-4621633867027267726
	.quad	4606228934933442366
	.quad	4599357381305483685
	.quad	4606722012380924717
	.quad	-4616650024473851091
	.quad	4599357381305483682
	.quad	4606861037960258298
	.quad	4598440769475874643
	.quad	-4624931267378901164
	.quad	4606861037960258297
	.quad	4602582924127750766
	.quad	4606003169643131350
	.quad	-4617368867211644460
	.quad	4602582924127750770
	.quad	4605287332140834842
	.quad	4603702198181267863
	.quad	-4619669838673507946
	.quad	4605287332140834843
	.quad	4593631292438356084
	.quad	4607112406663140763
	.quad	-4616259630191635045
	.quad	4593631292438356088
	.quad	4607052942571252535
	.quad	4595254953559313846
	.quad	-4628117083295461964
	.quad	4607052942571252535
	.quad	4603376689750694282
	.quad	4605528745646185891
	.quad	-4617843291208589916
	.quad	4603376689750694280
	.quad	4605794824015311574
	.quad	4602978475330140150
	.quad	-4620393561524635660
	.quad	4605794824015311575
	.quad	4597133857304417548
	.quad	4606959508273248265
	.quad	-4616412528581527543
	.quad	4597133857304417542
	.quad	4606585484169776453
	.quad	4600120522882128574
	.quad	-4623251513972647235
	.quad	4606585484169776453
	.quad	4601005467195804673
	.quad	4606402206201441658
	.quad	-4616969830653334152
	.quad	4601005467195804681
	.quad	4604711346734186659
	.quad	4604372693206777121
	.quad	-4618999343647998687
	.quad	4604711346734186660
	.quad	4583320075990952928
	.quad	4607179235055524786
	.quad	-4616192801799251022
	.quad	4583320075990952882
	.quad	4607172454365224381
	.quad	4586937798709255034
	.quad	-4636434238145520784
	.quad	4607172454365224381
	.quad	4604237722369085984
	.quad	4604836728227692712
	.quad	-4618535308627083098
	.quad	4604237722369085986
	.quad	4606325490827302871
	.quad	4601340444193890221
	.quad	-4622031592660885584
	.quad	4606325490827302870
	.quad	4599775166452691170
	.quad	4606649670461945556
	.quad	-4616722366392830253
	.quad	4599775166452691175
	.quad	4606916942348724568
	.quad	4597850804030586777
	.quad	-4625521232824189025
	.quad	4606916942348724568
	.quad	4602821637203306030
	.quad	4605891464834389332
	.quad	-4617480572020386476
	.quad	4602821637203306031
	.quad	4605420828951237689
	.quad	4603525993578147941
	.quad	-4619846043276627867
	.quad	4605420828951237690
	.quad	4594527424056711035
	.quad	4607082207693301011
	.quad	-4616289829161474797
	.quad	4594527424056711022
	.quad	4607087613972145036
	.quad	4594381639370641436
	.quad	-4628990397484134379
	.quad	4607087613972145036
	.quad	4603555587729607779
	.quad	4605398880432641044
	.quad	-4617973156422134765
	.quad	4603555587729607780
	.quad	4605910406930773222
	.quad	4602790034224747063
	.quad	-4620582002630028746
	.quad	4605910406930773223
	.quad	4597993767091577478
	.quad	4606907989753082767
	.quad	-4616464047101693042
	.quad	4597993767091577487
	.quad	4606662083155995116
	.quad	4599705784140949716
	.quad	-4623666252713826092
	.quad	4606662083155995116
	.quad	4601407059097287481
	.quad	4606309737575874717
	.quad	-4617062299278901090
	.quad	4601407059097287478
	.quad	4604861471792269747
	.quad	4604210422052581644
	.quad	-4619161614802194164
	.quad	4604861471792269747
	.quad	4587526608008965565
	.quad	4607170646468598772
	.quad	-4616201390386177036
	.quad	4587526608008965542
	.quad	4607140833643513559
	.quad	4591580615020633201
	.quad	-4631791421834142609
	.quad	4607140833643513559
	.quad	4603903555080370369
	.quad	4605126177062912857
	.quad	-4618245859791862951
	.quad	4603903555080370369
	.quad	4606127527782579846
	.quad	4602131036473088124
	.quad	-4621241000381687684
	.quad	4606127527782579846
	.quad	4598936171268220631
	.quad	4606789206031484853
	.quad	-4616582830823290956
	.quad	4598936171268220632
	.quad	4606799901559562512
	.quad	4598865654406453957
	.quad	-4624506382448321851
	.quad	4606799901559562512
	.quad	4602196025185095502
	.quad	4606110159187440325
	.quad	-4617261877667335484
	.quad	4602196025185095506
	.quad	4605149551259743449
	.quad	4603875073539124505
	.quad	-4619496963315651301
	.quad	4605149551259743448
	.quad	4591873955372931558
	.quad	4607137222205643665
	.quad	-4616234814649132143
	.quad	4591873955372931547
	.quad	4607012923561968632
	.quad	4596124601206990239
	.quad	-4627247435647785574
	.quad	4607012923561968632
	.quad	4603194658600624539
	.quad	4605654181370573603
	.quad	-4617717855484202205
	.quad	4603194658600624539
	.quad	4605674651335032539
	.quad	4603164023133853737
	.quad	-4620208013720922074
	.quad	4605674651335032541
	.quad	4596269149194902286
	.quad	4607005735466349744
	.quad	-4616366301388426065
	.quad	4596269149194902296
	.quad	4606503819154628041
	.quad	4600531377045301797
	.quad	-4622840659809474013
	.quad	4606503819154628042
	.quad	4600599457658951875
	.quad	4606489719197873769
	.quad	-4616882317656902039
	.quad	4600599457658951876
	.quad	4604557284557486510
	.quad	4604531231234577377
	.quad	-4618840805620198432
	.quad	4604557284557486511
	.quad	4566862577739493748
	.quad	4607182399960189253
	.quad	-4616189636894586555
	.quad	4566862577739494402
	.align 32
	.type	fpr_gm_tab, @object
	.size	fpr_gm_tab, 16384
fpr_gm_tab:
	.quad	0
	.quad	0
	.quad	-9223372036854775808
	.quad	4607182418800017408
	.quad	4604544271217802189
	.quad	4604544271217802189
	.quad	-4618827765636973619
	.quad	4604544271217802189
	.quad	4606496786581982534
	.quad	4600565431771507043
	.quad	-4622806605083268765
	.quad	4606496786581982534
	.quad	4600565431771507043
	.quad	4606496786581982534
	.quad	-4616875250272793274
	.quad	4600565431771507043
	.quad	4607009347991985328
	.quad	4596196889902818827
	.quad	-4627175146951956981
	.quad	4607009347991985328
	.quad	4603179351334086856
	.quad	4605664432017547683
	.quad	-4617707604837228125
	.quad	4603179351334086856
	.quad	4605664432017547683
	.quad	4603179351334086856
	.quad	-4620192685520688952
	.quad	4605664432017547683
	.quad	4596196889902818827
	.quad	4607009347991985328
	.quad	-4616362688862790480
	.quad	4596196889902818827
	.quad	4607139046673687846
	.quad	4591727299969791020
	.quad	-4631644736884984788
	.quad	4607139046673687846
	.quad	4603889326261607894
	.quad	4605137878724712257
	.quad	-4618234158130063551
	.quad	4603889326261607894
	.quad	4606118860100255153
	.quad	4602163548591158843
	.quad	-4621208488263616965
	.quad	4606118860100255153
	.quad	4598900923775164166
	.quad	4606794571824115162
	.quad	-4616577465030660646
	.quad	4598900923775164166
	.quad	4606794571824115162
	.quad	4598900923775164166
	.quad	-4624471113079611642
	.quad	4606794571824115162
	.quad	4602163548591158843
	.quad	4606118860100255153
	.quad	-4617253176754520655
	.quad	4602163548591158843
	.quad	4605137878724712257
	.quad	4603889326261607894
	.quad	-4619482710593167914
	.quad	4605137878724712257
	.quad	4591727299969791020
	.quad	4607139046673687846
	.quad	-4616232990181087962
	.quad	4591727299969791020
	.quad	4607171569234046334
	.quad	4587232218149935124
	.quad	-4636139818704840684
	.quad	4607171569234046334
	.quad	4604224084862889120
	.quad	4604849113969373103
	.quad	-4618522922885402705
	.quad	4604224084862889120
	.quad	4606317631232591731
	.quad	4601373767755717824
	.quad	-4621998269099057984
	.quad	4606317631232591731
	.quad	4599740487990714333
	.quad	4606655894547498725
	.quad	-4616716142307277083
	.quad	4599740487990714333
	.quad	4606912484326125783
	.quad	4597922303871901467
	.quad	-4625449732982874341
	.quad	4606912484326125783
	.quad	4602805845399633902
	.quad	4605900952042040894
	.quad	-4617471084812734914
	.quad	4602805845399633902
	.quad	4605409869824231233
	.quad	4603540801876750389
	.quad	-4619831234978025419
	.quad	4605409869824231233
	.quad	4594454542771183930
	.quad	4607084929468638487
	.quad	-4616287107386137321
	.quad	4594454542771183930
	.quad	4607084929468638487
	.quad	4594454542771183930
	.quad	-4628917494083591878
	.quad	4607084929468638487
	.quad	4603540801876750389
	.quad	4605409869824231233
	.quad	-4617962167030544575
	.quad	4603540801876750389
	.quad	4605900952042040894
	.quad	4602805845399633902
	.quad	-4620566191455141906
	.quad	4605900952042040894
	.quad	4597922303871901467
	.quad	4606912484326125783
	.quad	-4616459552528650025
	.quad	4597922303871901467
	.quad	4606655894547498725
	.quad	4599740487990714333
	.quad	-4623631548864061475
	.quad	4606655894547498725
	.quad	4601373767755717824
	.quad	4606317631232591731
	.quad	-4617054405622184077
	.quad	4601373767755717824
	.quad	4604849113969373103
	.quad	4604224084862889120
	.quad	-4619147951991886688
	.quad	4604849113969373103
	.quad	4587232218149935124
	.quad	4607171569234046334
	.quad	-4616200467620729474
	.quad	4587232218149935124
	.quad	4607179706000002317
	.quad	4582730748936808062
	.quad	-4640641287917967746
	.quad	4607179706000002317
	.quad	4604386048625945823
	.quad	4604698657331085206
	.quad	-4618673379523690602
	.quad	4604386048625945823
	.quad	4606409688975526202
	.quad	4600971798440897930
	.quad	-4622400238413877878
	.quad	4606409688975526202
	.quad	4600154912527631775
	.quad	4606578871587619388
	.quad	-4616793165267156420
	.quad	4600154912527631775
	.quad	4606963563043808649
	.quad	4597061974398750563
	.quad	-4626310062456025245
	.quad	4606963563043808649
	.quad	4602994049708411683
	.quad	4605784983948558848
	.quad	-4617587052906216960
	.quad	4602994049708411683
	.quad	4605539368864982914
	.quad	4603361638657888991
	.quad	-4620010398196886817
	.quad	4605539368864982914
	.quad	4595327571478659014
	.quad	4607049811591515049
	.quad	-4616322225263260759
	.quad	4595327571478659014
	.quad	4607114680469659603
	.quad	4593485039402578702
	.quad	-4629886997452197106
	.quad	4607114680469659603
	.quad	4603716733069447353
	.quad	4605276012900672507
	.quad	-4618096023954103301
	.quad	4603716733069447353
	.quad	4606012266443150634
	.quad	4602550884377336506
	.quad	-4620821152477439302
	.quad	4606012266443150634
	.quad	4598476289818621559
	.quad	4606856142606846307
	.quad	-4616515894247929501
	.quad	4598476289818621559
	.quad	4606727809065869586
	.quad	4599322407794599425
	.quad	-4624049629060176383
	.quad	4606727809065869586
	.quad	4601771097584682078
	.quad	4606220668805321205
	.quad	-4617151368049454603
	.quad	4601771097584682078
	.quad	4604995550503212910
	.quad	4604058477489546729
	.quad	-4619313559365229079
	.quad	4604995550503212910
	.quad	4589965306122607094
	.quad	4607158013403433018
	.quad	-4616214023451342790
	.quad	4589965306122607094
	.quad	4607158013403433018
	.quad	4589965306122607094
	.quad	-4633406730732168714
	.quad	4607158013403433018
	.quad	4604058477489546729
	.quad	4604995550503212910
	.quad	-4618376486351562898
	.quad	4604058477489546729
	.quad	4606220668805321205
	.quad	4601771097584682078
	.quad	-4621600939270093730
	.quad	4606220668805321205
	.quad	4599322407794599425
	.quad	4606727809065869586
	.quad	-4616644227788906222
	.quad	4599322407794599425
	.quad	4606856142606846307
	.quad	4598476289818621559
	.quad	-4624895747036154249
	.quad	4606856142606846307
	.quad	4602550884377336506
	.quad	4606012266443150634
	.quad	-4617359770411625174
	.quad	4602550884377336506
	.quad	4605276012900672507
	.quad	4603716733069447353
	.quad	-4619655303785328455
	.quad	4605276012900672507
	.quad	4593485039402578702
	.quad	4607114680469659603
	.quad	-4616257356385116205
	.quad	4593485039402578702
	.quad	4607049811591515049
	.quad	4595327571478659014
	.quad	-4628044465376116794
	.quad	4607049811591515049
	.quad	4603361638657888991
	.quad	4605539368864982914
	.quad	-4617832667989792894
	.quad	4603361638657888991
	.quad	4605784983948558848
	.quad	4602994049708411683
	.quad	-4620377987146364125
	.quad	4605784983948558848
	.quad	4597061974398750563
	.quad	4606963563043808649
	.quad	-4616408473810967159
	.quad	4597061974398750563
	.quad	4606578871587619388
	.quad	4600154912527631775
	.quad	-4623217124327144033
	.quad	4606578871587619388
	.quad	4600971798440897930
	.quad	4606409688975526202
	.quad	-4616962347879249606
	.quad	4600971798440897930
	.quad	4604698657331085206
	.quad	4604386048625945823
	.quad	-4618985988228829985
	.quad	4604698657331085206
	.quad	4582730748936808062
	.quad	4607179706000002317
	.quad	-4616192330854773491
	.quad	4582730748936808062
	.quad	4607181740574479067
	.quad	4578227681973159812
	.quad	-4645144354881615996
	.quad	4607181740574479067
	.quad	4604465633578481725
	.quad	4604621949701367983
	.quad	-4618750087153407825
	.quad	4604465633578481725
	.quad	4606453861145241227
	.quad	4600769149537129431
	.quad	-4622602887317646377
	.quad	4606453861145241227
	.quad	4600360675823176935
	.quad	4606538458821337243
	.quad	-4616833578033438565
	.quad	4600360675823176935
	.quad	4606987119037722413
	.quad	4596629994023683153
	.quad	-4626742042831092655
	.quad	4606987119037722413
	.quad	4603087070374583113
	.quad	4605725276488455441
	.quad	-4617646760366320367
	.quad	4603087070374583113
	.quad	4605602459698789090
	.quad	4603270878689749849
	.quad	-4620101158165025959
	.quad	4605602459698789090
	.quad	4595762727260045105
	.quad	4607030246558998647
	.quad	-4616341790295777161
	.quad	4595762727260045105
	.quad	4607127537664763515
	.quad	4592606767730311893
	.quad	-4630765269124463915
	.quad	4607127537664763515
	.quad	4603803453461190356
	.quad	4605207475328619533
	.quad	-4618164561526156275
	.quad	4603803453461190356
	.quad	4606066157444814153
	.quad	4602357870542944470
	.quad	-4621014166311831338
	.quad	4606066157444814153
	.quad	4598688984595225406
	.quad	4606826008603986804
	.quad	-4616546028250789004
	.quad	4598688984595225406
	.quad	4606761837001494797
	.quad	4599112075441176914
	.quad	-4624259961413598894
	.quad	4606761837001494797
	.quad	4601967947786150793
	.quad	4606170366472647579
	.quad	-4617201670382128229
	.quad	4601967947786150793
	.quad	4605067233569943231
	.quad	4603974338538572089
	.quad	-4619397698316203719
	.quad	4605067233569943231
	.quad	4590846768565625881
	.quad	4607149205763218185
	.quad	-4616222831091557623
	.quad	4590846768565625881
	.quad	4607165468267934125
	.quad	4588998070480937184
	.quad	-4634373966373838624
	.quad	4607165468267934125
	.quad	4604141730443515286
	.quad	4604922840319727473
	.quad	-4618449196535048335
	.quad	4604141730443515286
	.quad	4606269759522929756
	.quad	4601573027631668967
	.quad	-4621799009223106841
	.quad	4606269759522929756
	.quad	4599531889160152938
	.quad	4606692493141721470
	.quad	-4616679543713054338
	.quad	4599531889160152938
	.quad	4606884969294623682
	.quad	4598262871476403630
	.quad	-4625109165378372178
	.quad	4606884969294623682
	.quad	4602710690099904183
	.quad	4605957195211051218
	.quad	-4617414841643724590
	.quad	4602710690099904183
	.quad	4605343481119364930
	.quad	4603629178146150899
	.quad	-4619742858708624909
	.quad	4605343481119364930
	.quad	4594016801320007031
	.quad	4607100477024622401
	.quad	-4616271559830153407
	.quad	4594016801320007031
	.quad	4607068040143112603
	.quad	4594891488091520602
	.quad	-4628480548763255206
	.quad	4607068040143112603
	.quad	4603451617570386922
	.quad	4605475169017376660
	.quad	-4617896867837399148
	.quad	4603451617570386922
	.quad	4605843545406134034
	.quad	4602900303344142735
	.quad	-4620471733510633073
	.quad	4605843545406134034
	.quad	4597492765973365521
	.quad	4606938683557690074
	.quad	-4616433353297085734
	.quad	4597492765973365521
	.quad	4606618018794815019
	.quad	4599948172872067014
	.quad	-4623423863982708794
	.quad	4606618018794815019
	.quad	4601173347964633034
	.quad	4606364276725003740
	.quad	-4617007760129772068
	.quad	4601173347964633034
	.quad	4604774382555066977
	.quad	4604305528345395596
	.quad	-4619066508509380212
	.quad	4604774382555066977
	.quad	4585465300892538317
	.quad	4607176315382986589
	.quad	-4616195721471789219
	.quad	4585465300892538317
	.quad	4607176315382986589
	.quad	4585465300892538317
	.quad	-4637906735962237491
	.quad	4607176315382986589
	.quad	4604305528345395596
	.quad	4604774382555066977
	.quad	-4618597654299708831
	.quad	4604305528345395596
	.quad	4606364276725003740
	.quad	4601173347964633034
	.quad	-4622198688890142774
	.quad	4606364276725003740
	.quad	4599948172872067014
	.quad	4606618018794815019
	.quad	-4616754018059960789
	.quad	4599948172872067014
	.quad	4606938683557690074
	.quad	4597492765973365521
	.quad	-4625879270881410287
	.quad	4606938683557690074
	.quad	4602900303344142735
	.quad	4605843545406134034
	.quad	-4617528491448641774
	.quad	4602900303344142735
	.quad	4605475169017376660
	.quad	4603451617570386922
	.quad	-4619920419284388886
	.quad	4605475169017376660
	.quad	4594891488091520602
	.quad	4607068040143112603
	.quad	-4616303996711663205
	.quad	4594891488091520602
	.quad	4607100477024622401
	.quad	4594016801320007031
	.quad	-4629355235534768777
	.quad	4607100477024622401
	.quad	4603629178146150899
	.quad	4605343481119364930
	.quad	-4618028555735410878
	.quad	4603629178146150899
	.quad	4605957195211051218
	.quad	4602710690099904183
	.quad	-4620661346754871625
	.quad	4605957195211051218
	.quad	4598262871476403630
	.quad	4606884969294623682
	.quad	-4616487067560152126
	.quad	4598262871476403630
	.quad	4606692493141721470
	.quad	4599531889160152938
	.quad	-4623840147694622870
	.quad	4606692493141721470
	.quad	4601573027631668967
	.quad	4606269759522929756
	.quad	-4617102277331846052
	.quad	4601573027631668967
	.quad	4604922840319727473
	.quad	4604141730443515286
	.quad	-4619230306411260522
	.quad	4604922840319727473
	.quad	4588998070480937184
	.quad	4607165468267934125
	.quad	-4616206568586841683
	.quad	4588998070480937184
	.quad	4607149205763218185
	.quad	4590846768565625881
	.quad	-4632525268289149927
	.quad	4607149205763218185
	.quad	4603974338538572089
	.quad	4605067233569943231
	.quad	-4618304803284832577
	.quad	4603974338538572089
	.quad	4606170366472647579
	.quad	4601967947786150793
	.quad	-4621404089068625015
	.quad	4606170366472647579
	.quad	4599112075441176914
	.quad	4606761837001494797
	.quad	-4616610199853281011
	.quad	4599112075441176914
	.quad	4606826008603986804
	.quad	4598688984595225406
	.quad	-4624683052259550402
	.quad	4606826008603986804
	.quad	4602357870542944470
	.quad	4606066157444814153
	.quad	-4617305879409961655
	.quad	4602357870542944470
	.quad	4605207475328619533
	.quad	4603803453461190356
	.quad	-4619568583393585452
	.quad	4605207475328619533
	.quad	4592606767730311893
	.quad	4607127537664763515
	.quad	-4616244499190012293
	.quad	4592606767730311893
	.quad	4607030246558998647
	.quad	4595762727260045105
	.quad	-4627609309594730703
	.quad	4607030246558998647
	.quad	4603270878689749849
	.quad	4605602459698789090
	.quad	-4617769577155986718
	.quad	4603270878689749849
	.quad	4605725276488455441
	.quad	4603087070374583113
	.quad	-4620284966480192695
	.quad	4605725276488455441
	.quad	4596629994023683153
	.quad	4606987119037722413
	.quad	-4616384917817053395
	.quad	4596629994023683153
	.quad	4606538458821337243
	.quad	4600360675823176935
	.quad	-4623011361031598873
	.quad	4606538458821337243
	.quad	4600769149537129431
	.quad	4606453861145241227
	.quad	-4616918175709534581
	.quad	4600769149537129431
	.quad	4604621949701367983
	.quad	4604465633578481725
	.quad	-4618906403276294083
	.quad	4604621949701367983
	.quad	4578227681973159812
	.quad	4607181740574479067
	.quad	-4616190296280296741
	.quad	4578227681973159812
	.quad	4607182249242036882
	.quad	4573724215515480177
	.quad	-4649647821339295631
	.quad	4607182249242036882
	.quad	4604505071555817232
	.quad	4604583231088591477
	.quad	-4618788805766184331
	.quad	4604505071555817232
	.quad	4606475480113671417
	.quad	4600667422348321968
	.quad	-4622704614506453840
	.quad	4606475480113671417
	.quad	4600463181646572228
	.quad	4606517779747998088
	.quad	-4616854257106777720
	.quad	4600463181646572228
	.quad	4606998399608725124
	.quad	4596413578358834022
	.quad	-4626958458495941786
	.quad	4606998399608725124
	.quad	4603133304188877240
	.quad	4605694995810664660
	.quad	-4617677041044111148
	.quad	4603133304188877240
	.quad	4605633586259814045
	.quad	4603225210076562971
	.quad	-4620146826778212837
	.quad	4605633586259814045
	.quad	4595979936813835462
	.quad	4607019963775302583
	.quad	-4616352073079473225
	.quad	4595979936813835462
	.quad	4607133460805585796
	.quad	4592167175087283203
	.quad	-4631204861767492605
	.quad	4607133460805585796
	.quad	4603846496621587377
	.quad	4605172808754305228
	.quad	-4618199228100470580
	.quad	4603846496621587377
	.quad	4606092657816072624
	.quad	4602260871257280788
	.quad	-4621111165597495020
	.quad	4606092657816072624
	.quad	4598795050632330097
	.quad	4606810452769876110
	.quad	-4616561584084899698
	.quad	4598795050632330097
	.quad	4606778366364612594
	.quad	4599006600037663623
	.quad	-4624365436817112185
	.quad	4606778366364612594
	.quad	4602065906208722008
	.quad	4606144763310860551
	.quad	-4617227273543915257
	.quad	4602065906208722008
	.quad	4605102686554936490
	.quad	4603931940768740167
	.quad	-4619440096086035641
	.quad	4605102686554936490
	.quad	4591287158938884897
	.quad	4607144295058764886
	.quad	-4616227741796010922
	.quad	4591287158938884897
	.quad	4607168688050493276
	.quad	4588115294056142819
	.quad	-4635256742798632989
	.quad	4607168688050493276
	.quad	4604183020748362039
	.quad	4604886103475043762
	.quad	-4618485933379732046
	.quad	4604183020748362039
	.quad	4606293848208650998
	.quad	4601473544562720001
	.quad	-4621898492292055807
	.quad	4606293848208650998
	.quad	4599636300858866724
	.quad	4606674353838411301
	.quad	-4616697683016364507
	.quad	4599636300858866724
	.quad	4606898891031025132
	.quad	4598136582470364665
	.quad	-4625235454384411143
	.quad	4606898891031025132
	.quad	4602758354025980442
	.quad	4605929219593405673
	.quad	-4617442817261370135
	.quad	4602758354025980442
	.quad	4605376811039722786
	.quad	4603585091850767959
	.quad	-4619786945004007849
	.quad	4605376811039722786
	.quad	4594235767444503503
	.quad	4607092871118901179
	.quad	-4616279165735874629
	.quad	4594235767444503503
	.quad	4607076652372832968
	.quad	4594673119063280916
	.quad	-4628698917791494892
	.quad	4607076652372832968
	.quad	4603496309891590679
	.quad	4605442656228245717
	.quad	-4617929380626530091
	.quad	4603496309891590679
	.quad	4605872393621214213
	.quad	4602853162432841185
	.quad	-4620518874421934623
	.quad	4605872393621214213
	.quad	4597707695679609371
	.quad	4606925748668145757
	.quad	-4616446288186630051
	.quad	4597707695679609371
	.quad	4606637115963965612
	.quad	4599844446633109139
	.quad	-4623527590221666669
	.quad	4606637115963965612
	.quad	4601273700967202825
	.quad	4606341107699334546
	.quad	-4617030929155441262
	.quad	4601273700967202825
	.quad	4604811873195349477
	.quad	4604264921241055824
	.quad	-4619107115613719984
	.quad	4604811873195349477
	.quad	4586348876009622851
	.quad	4607174111710118367
	.quad	-4616197925144657441
	.quad	4586348876009622851
	.quad	4607178180169683960
	.quad	4584498631466405633
	.quad	-4638873405388370175
	.quad	4607178180169683960
	.quad	4604345904647073908
	.quad	4604736643460027021
	.quad	-4618635393394748787
	.quad	4604345904647073908
	.quad	4606387137437298591
	.quad	4601072712526242277
	.quad	-4622299324328533531
	.quad	4606387137437298591
	.quad	4600051662802353687
	.quad	4606598603759044570
	.quad	-4616773433095731238
	.quad	4600051662802353687
	.quad	4606951288507767453
	.quad	4597277522845151878
	.quad	-4626094514009623930
	.quad	4606951288507767453
	.quad	4602947266358709886
	.quad	4605814408482919348
	.quad	-4617557628371856460
	.quad	4602947266358709886
	.quad	4605507406967535927
	.quad	4603406726595779752
	.quad	-4619965310258996056
	.quad	4605507406967535927
	.quad	4595109641634432498
	.quad	4607059093103722971
	.quad	-4616312943751052837
	.quad	4595109641634432498
	.quad	4607107746899444102
	.quad	4593797652641645341
	.quad	-4629574384213130467
	.quad	4607107746899444102
	.quad	4603673059103075106
	.quad	4605309881318010327
	.quad	-4618062155536765481
	.quad	4603673059103075106
	.quad	4605984877841711338
	.quad	4602646891659203088
	.quad	-4620725145195572720
	.quad	4605984877841711338
	.quad	4598369669086960528
	.quad	4606870719641066940
	.quad	-4616501317213708868
	.quad	4598369669086960528
	.quad	4606710311774494716
	.quad	4599427256825614420
	.quad	-4623944780029161388
	.quad	4606710311774494716
	.quad	4601672213217083403
	.quad	4606245366082353408
	.quad	-4617126670772422400
	.quad	4601672213217083403
	.quad	4604959323120302796
	.quad	4604100215502905499
	.quad	-4619271821351870309
	.quad	4604959323120302796
	.quad	4589524267239410099
	.quad	4607161910007591876
	.quad	-4616210126847183932
	.quad	4589524267239410099
	.quad	4607153778602162496
	.quad	4590406145430462614
	.quad	-4632965891424313194
	.quad	4607153778602162496
	.quad	4604016517974851588
	.quad	4605031521104517324
	.quad	-4618340515750258484
	.quad	4604016517974851588
	.quad	4606195668621671667
	.quad	4601869677011524443
	.quad	-4621502359843251365
	.quad	4606195668621671667
	.quad	4599217346014614711
	.quad	4606744984357082948
	.quad	-4616627052497692860
	.quad	4599217346014614711
	.quad	4606841238740778884
	.quad	4598582729657176439
	.quad	-4624789307197599369
	.quad	4606841238740778884
	.quad	4602454542796181607
	.quad	4606039359984203741
	.quad	-4617332676870572067
	.quad	4602454542796181607
	.quad	4605241877142478242
	.quad	4603760198400967492
	.quad	-4619611838453808316
	.quad	4605241877142478242
	.quad	4593046061348462537
	.quad	4607121277474223905
	.quad	-4616250759380551903
	.quad	4593046061348462537
	.quad	4607040195955932526
	.quad	4595545269419264690
	.quad	-4627826767435511118
	.quad	4607040195955932526
	.quad	4603316355454250015
	.quad	4605571053506370248
	.quad	-4617800983348405560
	.quad	4603316355454250015
	.quad	4605755272910869620
	.quad	4603040651631881451
	.quad	-4620331385222894357
	.quad	4605755272910869620
	.quad	4596846128749438754
	.quad	4606975506703684317
	.quad	-4616396530151091491
	.quad	4596846128749438754
	.quad	4606558823023444576
	.quad	4600257918160607478
	.quad	-4623114118694168330
	.quad	4606558823023444576
	.quad	4600870609507958271
	.quad	4606431930490633905
	.quad	-4616940106364141903
	.quad	4600870609507958271
	.quad	4604660425598397818
	.quad	4604425958770613225
	.quad	-4618946078084162583
	.quad	4604660425598397818
	.quad	4580962600092897021
	.quad	4607180892816495009
	.quad	-4616191144038280799
	.quad	4580962600092897021
	.quad	4607180892816495009
	.quad	4580962600092897021
	.quad	-4642409436761878787
	.quad	4607180892816495009
	.quad	4604425958770613225
	.quad	4604660425598397818
	.quad	-4618711611256377990
	.quad	4604425958770613225
	.quad	4606431930490633905
	.quad	4600870609507958271
	.quad	-4622501427346817537
	.quad	4606431930490633905
	.quad	4600257918160607478
	.quad	4606558823023444576
	.quad	-4616813213831331232
	.quad	4600257918160607478
	.quad	4606975506703684317
	.quad	4596846128749438754
	.quad	-4626525908105337054
	.quad	4606975506703684317
	.quad	4603040651631881451
	.quad	4605755272910869620
	.quad	-4617616763943906188
	.quad	4603040651631881451
	.quad	4605571053506370248
	.quad	4603316355454250015
	.quad	-4620055681400525793
	.quad	4605571053506370248
	.quad	4595545269419264690
	.quad	4607040195955932526
	.quad	-4616331840898843282
	.quad	4595545269419264690
	.quad	4607121277474223905
	.quad	4593046061348462537
	.quad	-4630325975506313271
	.quad	4607121277474223905
	.quad	4603760198400967492
	.quad	4605241877142478242
	.quad	-4618130159712297566
	.quad	4603760198400967492
	.quad	4606039359984203741
	.quad	4602454542796181607
	.quad	-4620917494058594201
	.quad	4606039359984203741
	.quad	4598582729657176439
	.quad	4606841238740778884
	.quad	-4616530798113996924
	.quad	4598582729657176439
	.quad	4606744984357082948
	.quad	4599217346014614711
	.quad	-4624154690840161097
	.quad	4606744984357082948
	.quad	4601869677011524443
	.quad	4606195668621671667
	.quad	-4617176368233104141
	.quad	4601869677011524443
	.quad	4605031521104517324
	.quad	4604016517974851588
	.quad	-4619355518879924220
	.quad	4605031521104517324
	.quad	4590406145430462614
	.quad	4607153778602162496
	.quad	-4616218258252613312
	.quad	4590406145430462614
	.quad	4607161910007591876
	.quad	4589524267239410099
	.quad	-4633847769615365709
	.quad	4607161910007591876
	.quad	4604100215502905499
	.quad	4604959323120302796
	.quad	-4618412713734473012
	.quad	4604100215502905499
	.quad	4606245366082353408
	.quad	4601672213217083403
	.quad	-4621699823637692405
	.quad	4606245366082353408
	.quad	4599427256825614420
	.quad	4606710311774494716
	.quad	-4616661725080281092
	.quad	4599427256825614420
	.quad	4606870719641066940
	.quad	4598369669086960528
	.quad	-4625002367767815280
	.quad	4606870719641066940
	.quad	4602646891659203088
	.quad	4605984877841711338
	.quad	-4617387159013064470
	.quad	4602646891659203088
	.quad	4605309881318010327
	.quad	4603673059103075106
	.quad	-4619698977751700702
	.quad	4605309881318010327
	.quad	4593797652641645341
	.quad	4607107746899444102
	.quad	-4616264289955331706
	.quad	4593797652641645341
	.quad	4607059093103722971
	.quad	4595109641634432498
	.quad	-4628262395220343310
	.quad	4607059093103722971
	.quad	4603406726595779752
	.quad	4605507406967535927
	.quad	-4617864629887239881
	.quad	4603406726595779752
	.quad	4605814408482919348
	.quad	4602947266358709886
	.quad	-4620424770496065922
	.quad	4605814408482919348
	.quad	4597277522845151878
	.quad	4606951288507767453
	.quad	-4616420748347008355
	.quad	4597277522845151878
	.quad	4606598603759044570
	.quad	4600051662802353687
	.quad	-4623320374052422121
	.quad	4606598603759044570
	.quad	4601072712526242277
	.quad	4606387137437298591
	.quad	-4616984899417477217
	.quad	4601072712526242277
	.quad	4604736643460027021
	.quad	4604345904647073908
	.quad	-4619026132207701900
	.quad	4604736643460027021
	.quad	4584498631466405633
	.quad	4607178180169683960
	.quad	-4616193856685091848
	.quad	4584498631466405633
	.quad	4607174111710118367
	.quad	4586348876009622851
	.quad	-4637023160845152957
	.quad	4607174111710118367
	.quad	4604264921241055824
	.quad	4604811873195349477
	.quad	-4618560163659426331
	.quad	4604264921241055824
	.quad	4606341107699334546
	.quad	4601273700967202825
	.quad	-4622098335887572983
	.quad	4606341107699334546
	.quad	4599844446633109139
	.quad	4606637115963965612
	.quad	-4616734920890810196
	.quad	4599844446633109139
	.quad	4606925748668145757
	.quad	4597707695679609371
	.quad	-4625664341175166437
	.quad	4606925748668145757
	.quad	4602853162432841185
	.quad	4605872393621214213
	.quad	-4617499643233561595
	.quad	4602853162432841185
	.quad	4605442656228245717
	.quad	4603496309891590679
	.quad	-4619875726963185129
	.quad	4605442656228245717
	.quad	4594673119063280916
	.quad	4607076652372832968
	.quad	-4616295384481942840
	.quad	4594673119063280916
	.quad	4607092871118901179
	.quad	4594235767444503503
	.quad	-4629136269410272305
	.quad	4607092871118901179
	.quad	4603585091850767959
	.quad	4605376811039722786
	.quad	-4617995225815053022
	.quad	4603585091850767959
	.quad	4605929219593405673
	.quad	4602758354025980442
	.quad	-4620613682828795366
	.quad	4605929219593405673
	.quad	4598136582470364665
	.quad	4606898891031025132
	.quad	-4616473145823750676
	.quad	4598136582470364665
	.quad	4606674353838411301
	.quad	4599636300858866724
	.quad	-4623735735995909084
	.quad	4606674353838411301
	.quad	4601473544562720001
	.quad	4606293848208650998
	.quad	-4617078188646124810
	.quad	4601473544562720001
	.quad	4604886103475043762
	.quad	4604183020748362039
	.quad	-4619189016106413769
	.quad	4604886103475043762
	.quad	4588115294056142819
	.quad	4607168688050493276
	.quad	-4616203348804282532
	.quad	4588115294056142819
	.quad	4607144295058764886
	.quad	4591287158938884897
	.quad	-4632084877915890911
	.quad	4607144295058764886
	.quad	4603931940768740167
	.quad	4605102686554936490
	.quad	-4618269350299839318
	.quad	4603931940768740167
	.quad	4606144763310860551
	.quad	4602065906208722008
	.quad	-4621306130646053800
	.quad	4606144763310860551
	.quad	4599006600037663623
	.quad	4606778366364612594
	.quad	-4616593670490163214
	.quad	4599006600037663623
	.quad	4606810452769876110
	.quad	4598795050632330097
	.quad	-4624576986222445711
	.quad	4606810452769876110
	.quad	4602260871257280788
	.quad	4606092657816072624
	.quad	-4617279379038703184
	.quad	4602260871257280788
	.quad	4605172808754305228
	.quad	4603846496621587377
	.quad	-4619525540233188431
	.quad	4605172808754305228
	.quad	4592167175087283203
	.quad	4607133460805585796
	.quad	-4616238576049190012
	.quad	4592167175087283203
	.quad	4607019963775302583
	.quad	4595979936813835462
	.quad	-4627392100040940346
	.quad	4607019963775302583
	.quad	4603225210076562971
	.quad	4605633586259814045
	.quad	-4617738450594961763
	.quad	4603225210076562971
	.quad	4605694995810664660
	.quad	4603133304188877240
	.quad	-4620238732665898568
	.quad	4605694995810664660
	.quad	4596413578358834022
	.quad	4606998399608725124
	.quad	-4616373637246050684
	.quad	4596413578358834022
	.quad	4606517779747998088
	.quad	4600463181646572228
	.quad	-4622908855208203580
	.quad	4606517779747998088
	.quad	4600667422348321968
	.quad	4606475480113671417
	.quad	-4616896556741104391
	.quad	4600667422348321968
	.quad	4604583231088591477
	.quad	4604505071555817232
	.quad	-4618866965298958576
	.quad	4604583231088591477
	.quad	4573724215515480177
	.quad	4607182249242036882
	.quad	-4616189787612738926
	.quad	4573724215515480177
	.quad	4607182376410422530
	.quad	4569220649180767418
	.quad	-4654151387674008390
	.quad	4607182376410422530
	.quad	4604524701268679793
	.quad	4604563781218984604
	.quad	-4618808255635791204
	.quad	4604524701268679793
	.quad	4606486172460753999
	.quad	4600616459743653188
	.quad	-4622755577111122620
	.quad	4606486172460753999
	.quad	4600514338912178239
	.quad	4606507322377452870
	.quad	-4616864714477322938
	.quad	4600514338912178239
	.quad	4607003915349878877
	.quad	4596305267720071930
	.quad	-4627066769134703878
	.quad	4607003915349878877
	.quad	4603156351203636159
	.quad	4605679749231851918
	.quad	-4617692287622923890
	.quad	4603156351203636159
	.quad	4605649044311923410
	.quad	4603202304363743346
	.quad	-4620169732491032462
	.quad	4605649044311923410
	.quad	4596088445927168004
	.quad	4607014697483910382
	.quad	-4616357339370865426
	.quad	4596088445927168004
	.quad	4607136295912168606
	.quad	4591947271803021404
	.quad	-4631424765051754404
	.quad	4607136295912168606
	.quad	4603867938232615808
	.quad	4605155376589456981
	.quad	-4618216660265318827
	.quad	4603867938232615808
	.quad	4606105796280968177
	.quad	4602212250118051877
	.quad	-4621159786736723931
	.quad	4606105796280968177
	.quad	4598848011564831930
	.quad	4606802552898869248
	.quad	-4616569483955906560
	.quad	4598848011564831930
	.quad	4606786509620734768
	.quad	4598953786765296928
	.quad	-4624418250089478880
	.quad	4606786509620734768
	.quad	4602114767134999006
	.quad	4606131849150971908
	.quad	-4617240187703803900
	.quad	4602114767134999006
	.quad	4605120315324767624
	.quad	4603910660507251362
	.quad	-4619461376347524446
	.quad	4605120315324767624
	.quad	4591507261658050721
	.quad	4607141713064252300
	.quad	-4616230323790523508
	.quad	4591507261658050721
	.quad	4607170170974224083
	.quad	4587673791460508439
	.quad	-4635698245394267369
	.quad	4607170170974224083
	.quad	4604203581176243359
	.quad	4604867640218014515
	.quad	-4618504396636761293
	.quad	4604203581176243359
	.quad	4606305777984577632
	.quad	4601423692641949331
	.quad	-4621948344212826477
	.quad	4606305777984577632
	.quad	4599688422741010356
	.quad	4606665164148251002
	.quad	-4616706872706524806
	.quad	4599688422741010356
	.quad	4606905728766014348
	.quad	4598029484874872834
	.quad	-4625342551979902974
	.quad	4606905728766014348
	.quad	4602782121393764535
	.quad	4605915122243179241
	.quad	-4617456914611596567
	.quad	4602782121393764535
	.quad	4605393374401988274
	.quad	4603562972219549215
	.quad	-4619809064635226593
	.quad	4605393374401988274
	.quad	4594345179472540681
	.quad	4607088942243446236
	.quad	-4616283094611329572
	.quad	4594345179472540681
	.quad	4607080832832247697
	.quad	4594563856311064231
	.quad	-4628808180543711577
	.quad	4607080832832247697
	.quad	4603518581031047189
	.quad	4605426297151190466
	.quad	-4617945739703585342
	.quad	4603518581031047189
	.quad	4605886709123365959
	.quad	4602829525820289164
	.quad	-4620542511034486644
	.quad	4605886709123365959
	.quad	4597815040470278984
	.quad	4606919157647773535
	.quad	-4616452879207002273
	.quad	4597815040470278984
	.quad	4606646545123403481
	.quad	4599792496117920694
	.quad	-4623579540736855114
	.quad	4606646545123403481
	.quad	4601323770373937522
	.quad	4606329407841126011
	.quad	-4617042629013649797
	.quad	4601323770373937522
	.quad	4604830524903495634
	.quad	4604244531615310815
	.quad	-4619127505239464993
	.quad	4604830524903495634
	.quad	4586790578280679046
	.quad	4607172882816799076
	.quad	-4616199154037976732
	.quad	4586790578280679046
	.quad	4607178985458280057
	.quad	4583614727651146525
	.quad	-4639757309203629283
	.quad	4607178985458280057
	.quad	4604366005771528720
	.quad	4604717681185626434
	.quad	-4618654355669149374
	.quad	4604366005771528720
	.quad	4606398451906509788
	.quad	4601022290077223616
	.quad	-4622349746777552192
	.quad	4606398451906509788
	.quad	4600103317933788342
	.quad	4606588777269136769
	.quad	-4616783259585639039
	.quad	4600103317933788342
	.quad	4606957467106717424
	.quad	4597169786279785693
	.quad	-4626202250574990115
	.quad	4606957467106717424
	.quad	4602970680601913687
	.quad	4605799732098147061
	.quad	-4617572304756628747
	.quad	4602970680601913687
	.quad	4605523422498301790
	.quad	4603384207141321914
	.quad	-4619987829713453894
	.quad	4605523422498301790
	.quad	4595218635031890910
	.quad	4607054494135176056
	.quad	-4616317542719599752
	.quad	4595218635031890910
	.quad	4607111255739239816
	.quad	4593688012422887515
	.quad	-4629684024431888293
	.quad	4607111255739239816
	.quad	4603694922063032361
	.quad	4605292980606880364
	.quad	-4618079056247895444
	.quad	4603694922063032361
	.quad	4605998608960791335
	.quad	4602598930031891166
	.quad	-4620773106822884642
	.quad	4605998608960791335
	.quad	4598423001813699022
	.quad	4606863472012527185
	.quad	-4616508564842248623
	.quad	4598423001813699022
	.quad	4606719100629313491
	.quad	4599374859150636784
	.quad	-4623997177704139024
	.quad	4606719100629313491
	.quad	4601721693286060937
	.quad	4606233055365547081
	.quad	-4617138981489228727
	.quad	4601721693286060937
	.quad	4604977468824438271
	.quad	4604079374282302598
	.quad	-4619292662572473210
	.quad	4604977468824438271
	.quad	4589744810590291021
	.quad	4607160003989618959
	.quad	-4616212032865156849
	.quad	4589744810590291021
	.quad	4607155938267770208
	.quad	4590185751760970393
	.quad	-4633186285093805415
	.quad	4607155938267770208
	.quad	4604037525321326463
	.quad	4605013567986435066
	.quad	-4618358468868340742
	.quad	4604037525321326463
	.quad	4606208206518262803
	.quad	4601820425647934753
	.quad	-4621551611206841055
	.quad	4606208206518262803
	.quad	4599269903251194481
	.quad	4606736437002195879
	.quad	-4616635599852579929
	.quad	4599269903251194481
	.quad	4606848731493011465
	.quad	4598529532600161144
	.quad	-4624842504254614664
	.quad	4606848731493011465
	.quad	4602502755147763107
	.quad	4606025850160239809
	.quad	-4617346186694535999
	.quad	4602502755147763107
	.quad	4605258978359093269
	.quad	4603738491917026584
	.quad	-4619633544937749224
	.quad	4605258978359093269
	.quad	4593265590854265407
	.quad	4607118021058468598
	.quad	-4616254015796307210
	.quad	4593265590854265407
	.quad	4607045045516813836
	.quad	4595436449949385485
	.quad	-4627935586905390323
	.quad	4607045045516813836
	.quad	4603339021357904144
	.quad	4605555245917486022
	.quad	-4617816790937289786
	.quad	4603339021357904144
	.quad	4605770164172969910
	.quad	4603017373458244943
	.quad	-4620354663396530865
	.quad	4605770164172969910
	.quad	4596954088216812973
	.quad	4606969576261663845
	.quad	-4616402460593111963
	.quad	4596954088216812973
	.quad	4606568886807728474
	.quad	4600206446098256018
	.quad	-4623165590756519790
	.quad	4606568886807728474
	.quad	4600921238092511730
	.quad	4606420848538580260
	.quad	-4616951188316195548
	.quad	4600921238092511730
	.quad	4604679572075463103
	.quad	4604406033021674239
	.quad	-4618966003833101569
	.quad	4604679572075463103
	.quad	4581846703643734566
	.quad	4607180341788068727
	.quad	-4616191695066707081
	.quad	4581846703643734566
	.quad	4607181359080094673
	.quad	4579996072175835083
	.quad	-4643375964678940725
	.quad	4607181359080094673
	.quad	4604445825685214043
	.quad	4604641218080103285
	.quad	-4618730818774672523
	.quad	4604445825685214043
	.quad	4606442934727379583
	.quad	4600819913163773071
	.quad	-4622552123691002737
	.quad	4606442934727379583
	.quad	4600309328230211502
	.quad	4606548680329491866
	.quad	-4616823356525283942
	.quad	4600309328230211502
	.quad	4606981354314050484
	.quad	4596738097012783531
	.quad	-4626633939841992277
	.quad	4606981354314050484
	.quad	4603063884010218172
	.quad	4605740310302420207
	.quad	-4617631726552355601
	.quad	4603063884010218172
	.quad	4605586791482848547
	.quad	4603293641160266722
	.quad	-4620078395694509086
	.quad	4605586791482848547
	.quad	4595654028864046335
	.quad	4607035262954517034
	.quad	-4616336773900258774
	.quad	4595654028864046335
	.quad	4607124449686274900
	.quad	4592826452951465409
	.quad	-4630545583903310399
	.quad	4607124449686274900
	.quad	4603781852316960384
	.quad	4605224709411790590
	.quad	-4618147327442985218
	.quad	4603781852316960384
	.quad	4606052795787882823
	.quad	4602406247776385022
	.quad	-4620965789078390786
	.quad	4606052795787882823
	.quad	4598635880488956483
	.quad	4606833664420673202
	.quad	-4616538372434102606
	.quad	4598635880488956483
	.quad	4606753451050079834
	.quad	4599164736579548843
	.quad	-4624207300275226965
	.quad	4606753451050079834
	.quad	4601918851211878557
	.quad	4606183055233559255
	.quad	-4617188981621216553
	.quad	4601918851211878557
	.quad	4605049409688478101
	.quad	4603995455647851249
	.quad	-4619376581206924559
	.quad	4605049409688478101
	.quad	4590626485056654602
	.quad	4607151534426937478
	.quad	-4616220502427838330
	.quad	4590626485056654602
	.quad	4607163731439411601
	.quad	4589303678145802340
	.quad	-4634068358708973468
	.quad	4607163731439411601
	.quad	4604121000955189926
	.quad	4604941113561600762
	.quad	-4618430923293175046
	.quad	4604121000955189926
	.quad	4606257600839867033
	.quad	4601622657843474729
	.quad	-4621749379011301079
	.quad	4606257600839867033
	.quad	4599479600326345459
	.quad	4606701442584137310
	.quad	-4616670594270638498
	.quad	4599479600326345459
	.quad	4606877885424248132
	.quad	4598316292140394014
	.quad	-4625055744714381794
	.quad	4606877885424248132
	.quad	4602686793990243041
	.quad	4605971073215153165
	.quad	-4617400963639622643
	.quad	4602686793990243041
	.quad	4605326714874986465
	.quad	4603651144395358093
	.quad	-4619720892459417715
	.quad	4605326714874986465
	.quad	4593907249284540294
	.quad	4607104153983298999
	.quad	-4616267882871476809
	.quad	4593907249284540294
	.quad	4607063608453868552
	.quad	4595000592312171144
	.quad	-4628371444542604664
	.quad	4607063608453868552
	.quad	4603429196809300824
	.quad	4605491322423429598
	.quad	-4617880714431346210
	.quad	4603429196809300824
	.quad	4605829012964735987
	.quad	4602923807199184054
	.quad	-4620448229655591754
	.quad	4605829012964735987
	.quad	4597385183080791534
	.quad	4606945027305114062
	.quad	-4616427009549661746
	.quad	4597385183080791534
	.quad	4606608350964852124
	.quad	4599999947619525579
	.quad	-4623372089235250229
	.quad	4606608350964852124
	.quad	4601123065313358619
	.quad	4606375745674388705
	.quad	-4616996291180387103
	.quad	4601123065313358619
	.quad	4604755543975806820
	.quad	4604325745441780828
	.quad	-4619046291412994980
	.quad	4604755543975806820
	.quad	4585023436363055487
	.quad	4607177290141793710
	.quad	-4616194746712982098
	.quad	4585023436363055487
	.quad	4607175255902437396
	.quad	4585907115494236537
	.quad	-4637464921360539271
	.quad	4607175255902437396
	.quad	4604285253548209224
	.quad	4604793159020491611
	.quad	-4618578877834284197
	.quad	4604285253548209224
	.quad	4606352730697093817
	.quad	4601223560006786057
	.quad	-4622148476847989751
	.quad	4606352730697093817
	.quad	4599896339047301634
	.quad	4606627607157935956
	.quad	-4616744429696839852
	.quad	4599896339047301634
	.quad	4606932257325205256
	.quad	4597600270510262682
	.quad	-4625771766344513126
	.quad	4606932257325205256
	.quad	4602876755014813164
	.quad	4605858005670328613
	.quad	-4617514031184447195
	.quad	4602876755014813164
	.quad	4605458946901419122
	.quad	4603473988668005304
	.quad	-4619898048186770504
	.quad	4605458946901419122
	.quad	4594782329999411347
	.quad	4607072388129742377
	.quad	-4616299648725033431
	.quad	4594782329999411347
	.quad	4607096716058023245
	.quad	4594126307716900071
	.quad	-4629245729137875737
	.quad	4607096716058023245
	.quad	4603607160562208225
	.quad	4605360179893335444
	.quad	-4618011856961440364
	.quad	4603607160562208225
	.quad	4605943243960030558
	.quad	4602734543519989142
	.quad	-4620637493334786666
	.quad	4605943243960030558
	.quad	4598209407597805010
	.quad	4606891971185517504
	.quad	-4616480065669258304
	.quad	4598209407597805010
	.quad	4606683463531482757
	.quad	4599584122834874440
	.quad	-4623787914019901368
	.quad	4606683463531482757
	.quad	4601523323048804569
	.quad	4606281842017099424
	.quad	-4617090194837676384
	.quad	4601523323048804569
	.quad	4604904503566677638
	.quad	4604162403772767740
	.quad	-4619209633082008068
	.quad	4604904503566677638
	.quad	4588556721781247689
	.quad	4607167120476811757
	.quad	-4616204916377964051
	.quad	4588556721781247689
	.quad	4607146792632922887
	.quad	4591066993883984169
	.quad	-4632305042970791639
	.quad	4607146792632922887
	.quad	4603953166845776383
	.quad	4605084992581147553
	.quad	-4618287044273628255
	.quad	4603953166845776383
	.quad	4606157602458368090
	.quad	4602016966272225497
	.quad	-4621355070582550311
	.quad	4606157602458368090
	.quad	4599059363095165615
	.quad	4606770142132396069
	.quad	-4616601894722379739
	.quad	4599059363095165615
	.quad	4606818271362779153
	.quad	4598742041476147134
	.quad	-4624629995378628674
	.quad	4606818271362779153
	.quad	4602309411551204896
	.quad	4606079444829232727
	.quad	-4617292592025543081
	.quad	4602309411551204896
	.quad	4605190175055178825
	.quad	4603825001630339212
	.quad	-4619547035224436596
	.quad	4605190175055178825
	.quad	4592387007752762956
	.quad	4607130541380624519
	.quad	-4616241495474151289
	.quad	4592387007752762956
	.quad	4607025146816593591
	.quad	4595871363584150300
	.quad	-4627500673270625508
	.quad	4607025146816593591
	.quad	4603248068256948438
	.quad	4605618058006716661
	.quad	-4617753978848059147
	.quad	4603248068256948438
	.quad	4605710171610479304
	.quad	4603110210506737381
	.quad	-4620261826348038427
	.quad	4605710171610479304
	.quad	4596521820799644122
	.quad	4606992800820440327
	.quad	-4616379236034335481
	.quad	4596521820799644122
	.quad	4606528158595189433
	.quad	4600411960456200676
	.quad	-4622960076398575132
	.quad	4606528158595189433
	.quad	4600718319105833937
	.quad	4606464709641375231
	.quad	-4616907327213400577
	.quad	4600718319105833937
	.quad	4604602620643553229
	.quad	4604485382263976838
	.quad	-4618886654590798970
	.quad	4604602620643553229
	.quad	4576459225186735875
	.quad	4607182037296057423
	.quad	-4616189999558718385
	.quad	4576459225186735875
	.quad	4607182037296057423
	.quad	4576459225186735875
	.quad	-4646912811668039933
	.quad	4607182037296057423
	.quad	4604485382263976838
	.quad	4604602620643553229
	.quad	-4618769416211222579
	.quad	4604485382263976838
	.quad	4606464709641375231
	.quad	4600718319105833937
	.quad	-4622653717748941871
	.quad	4606464709641375231
	.quad	4600411960456200676
	.quad	4606528158595189433
	.quad	-4616843878259586375
	.quad	4600411960456200676
	.quad	4606992800820440327
	.quad	4596521820799644122
	.quad	-4626850216055131686
	.quad	4606992800820440327
	.quad	4603110210506737381
	.quad	4605710171610479304
	.quad	-4617661865244296504
	.quad	4603110210506737381
	.quad	4605618058006716661
	.quad	4603248068256948438
	.quad	-4620123968597827370
	.quad	4605618058006716661
	.quad	4595871363584150300
	.quad	4607025146816593591
	.quad	-4616346890038182217
	.quad	4595871363584150300
	.quad	4607130541380624519
	.quad	4592387007752762956
	.quad	-4630985029102012852
	.quad	4607130541380624519
	.quad	4603825001630339212
	.quad	4605190175055178825
	.quad	-4618181861799596983
	.quad	4603825001630339212
	.quad	4606079444829232727
	.quad	4602309411551204896
	.quad	-4621062625303570912
	.quad	4606079444829232727
	.quad	4598742041476147134
	.quad	4606818271362779153
	.quad	-4616553765491996655
	.quad	4598742041476147134
	.quad	4606770142132396069
	.quad	4599059363095165615
	.quad	-4624312673759610193
	.quad	4606770142132396069
	.quad	4602016966272225497
	.quad	4606157602458368090
	.quad	-4617214434396407718
	.quad	4602016966272225497
	.quad	4605084992581147553
	.quad	4603953166845776383
	.quad	-4619418870008999425
	.quad	4605084992581147553
	.quad	4591066993883984169
	.quad	4607146792632922887
	.quad	-4616225244221852921
	.quad	4591066993883984169
	.quad	4607167120476811757
	.quad	4588556721781247689
	.quad	-4634815315073528119
	.quad	4607167120476811757
	.quad	4604162403772767740
	.quad	4604904503566677638
	.quad	-4618467533288098170
	.quad	4604162403772767740
	.quad	4606281842017099424
	.quad	4601523323048804569
	.quad	-4621848713805971239
	.quad	4606281842017099424
	.quad	4599584122834874440
	.quad	4606683463531482757
	.quad	-4616688573323293051
	.quad	4599584122834874440
	.quad	4606891971185517504
	.quad	4598209407597805010
	.quad	-4625162629256970798
	.quad	4606891971185517504
	.quad	4602734543519989142
	.quad	4605943243960030558
	.quad	-4617428792894745250
	.quad	4602734543519989142
	.quad	4605360179893335444
	.quad	4603607160562208225
	.quad	-4619764876292567583
	.quad	4605360179893335444
	.quad	4594126307716900071
	.quad	4607096716058023245
	.quad	-4616275320796752563
	.quad	4594126307716900071
	.quad	4607072388129742377
	.quad	4594782329999411347
	.quad	-4628589706855364461
	.quad	4607072388129742377
	.quad	4603473988668005304
	.quad	4605458946901419122
	.quad	-4617913089953356686
	.quad	4603473988668005304
	.quad	4605858005670328613
	.quad	4602876755014813164
	.quad	-4620495281839962644
	.quad	4605858005670328613
	.quad	4597600270510262682
	.quad	4606932257325205256
	.quad	-4616439779529570552
	.quad	4597600270510262682
	.quad	4606627607157935956
	.quad	4599896339047301634
	.quad	-4623475697807474174
	.quad	4606627607157935956
	.quad	4601223560006786057
	.quad	4606352730697093817
	.quad	-4617019306157681991
	.quad	4601223560006786057
	.quad	4604793159020491611
	.quad	4604285253548209224
	.quad	-4619086783306566584
	.quad	4604793159020491611
	.quad	4585907115494236537
	.quad	4607175255902437396
	.quad	-4616196780952338412
	.quad	4585907115494236537
	.quad	4607177290141793710
	.quad	4585023436363055487
	.quad	-4638348600491720321
	.quad	4607177290141793710
	.quad	4604325745441780828
	.quad	4604755543975806820
	.quad	-4618616492878968988
	.quad	4604325745441780828
	.quad	4606375745674388705
	.quad	4601123065313358619
	.quad	-4622248971541417189
	.quad	4606375745674388705
	.quad	4599999947619525579
	.quad	4606608350964852124
	.quad	-4616763685889923684
	.quad	4599999947619525579
	.quad	4606945027305114062
	.quad	4597385183080791534
	.quad	-4625986853773984274
	.quad	4606945027305114062
	.quad	4602923807199184054
	.quad	4605829012964735987
	.quad	-4617543023890039821
	.quad	4602923807199184054
	.quad	4605491322423429598
	.quad	4603429196809300824
	.quad	-4619942840045474984
	.quad	4605491322423429598
	.quad	4595000592312171144
	.quad	4607063608453868552
	.quad	-4616308428400907256
	.quad	4595000592312171144
	.quad	4607104153983298999
	.quad	4593907249284540294
	.quad	-4629464787570235514
	.quad	4607104153983298999
	.quad	4603651144395358093
	.quad	4605326714874986465
	.quad	-4618045321979789343
	.quad	4603651144395358093
	.quad	4605971073215153165
	.quad	4602686793990243041
	.quad	-4620685242864532767
	.quad	4605971073215153165
	.quad	4598316292140394014
	.quad	4606877885424248132
	.quad	-4616494151430527676
	.quad	4598316292140394014
	.quad	4606701442584137310
	.quad	4599479600326345459
	.quad	-4623892436528430349
	.quad	4606701442584137310
	.quad	4601622657843474729
	.quad	4606257600839867033
	.quad	-4617114436014908775
	.quad	4601622657843474729
	.quad	4604941113561600762
	.quad	4604121000955189926
	.quad	-4619251035899585882
	.quad	4604941113561600762
	.quad	4589303678145802340
	.quad	4607163731439411601
	.quad	-4616208305415364207
	.quad	4589303678145802340
	.quad	4607151534426937478
	.quad	4590626485056654602
	.quad	-4632745551798121206
	.quad	4607151534426937478
	.quad	4603995455647851249
	.quad	4605049409688478101
	.quad	-4618322627166297707
	.quad	4603995455647851249
	.quad	4606183055233559255
	.quad	4601918851211878557
	.quad	-4621453185642897251
	.quad	4606183055233559255
	.quad	4599164736579548843
	.quad	4606753451050079834
	.quad	-4616618585804695974
	.quad	4599164736579548843
	.quad	4606833664420673202
	.quad	4598635880488956483
	.quad	-4624736156365819325
	.quad	4606833664420673202
	.quad	4602406247776385022
	.quad	4606052795787882823
	.quad	-4617319241066892985
	.quad	4602406247776385022
	.quad	4605224709411790590
	.quad	4603781852316960384
	.quad	-4619590184537815424
	.quad	4605224709411790590
	.quad	4592826452951465409
	.quad	4607124449686274900
	.quad	-4616247587168500908
	.quad	4592826452951465409
	.quad	4607035262954517034
	.quad	4595654028864046335
	.quad	-4627718007990729473
	.quad	4607035262954517034
	.quad	4603293641160266722
	.quad	4605586791482848547
	.quad	-4617785245371927261
	.quad	4603293641160266722
	.quad	4605740310302420207
	.quad	4603063884010218172
	.quad	-4620308152844557636
	.quad	4605740310302420207
	.quad	4596738097012783531
	.quad	4606981354314050484
	.quad	-4616390682540725324
	.quad	4596738097012783531
	.quad	4606548680329491866
	.quad	4600309328230211502
	.quad	-4623062708624564306
	.quad	4606548680329491866
	.quad	4600819913163773071
	.quad	4606442934727379583
	.quad	-4616929102127396225
	.quad	4600819913163773071
	.quad	4604641218080103285
	.quad	4604445825685214043
	.quad	-4618926211169561765
	.quad	4604641218080103285
	.quad	4579996072175835083
	.quad	4607181359080094673
	.quad	-4616190677774681135
	.quad	4579996072175835083
	.quad	4607180341788068727
	.quad	4581846703643734566
	.quad	-4641525333211041242
	.quad	4607180341788068727
	.quad	4604406033021674239
	.quad	4604679572075463103
	.quad	-4618692464779312705
	.quad	4604406033021674239
	.quad	4606420848538580260
	.quad	4600921238092511730
	.quad	-4622450798762264078
	.quad	4606420848538580260
	.quad	4600206446098256018
	.quad	4606568886807728474
	.quad	-4616803150047047334
	.quad	4600206446098256018
	.quad	4606969576261663845
	.quad	4596954088216812973
	.quad	-4626417948637962835
	.quad	4606969576261663845
	.quad	4603017373458244943
	.quad	4605770164172969910
	.quad	-4617601872681805898
	.quad	4603017373458244943
	.quad	4605555245917486022
	.quad	4603339021357904144
	.quad	-4620033015496871664
	.quad	4605555245917486022
	.quad	4595436449949385485
	.quad	4607045045516813836
	.quad	-4616326991337961972
	.quad	4595436449949385485
	.quad	4607118021058468598
	.quad	4593265590854265407
	.quad	-4630106446000510401
	.quad	4607118021058468598
	.quad	4603738491917026584
	.quad	4605258978359093269
	.quad	-4618113058495682539
	.quad	4603738491917026584
	.quad	4606025850160239809
	.quad	4602502755147763107
	.quad	-4620869281707012701
	.quad	4606025850160239809
	.quad	4598529532600161144
	.quad	4606848731493011465
	.quad	-4616523305361764343
	.quad	4598529532600161144
	.quad	4606736437002195879
	.quad	4599269903251194481
	.quad	-4624102133603581327
	.quad	4606736437002195879
	.quad	4601820425647934753
	.quad	4606208206518262803
	.quad	-4617163830336513005
	.quad	4601820425647934753
	.quad	4605013567986435066
	.quad	4604037525321326463
	.quad	-4619334511533449345
	.quad	4605013567986435066
	.quad	4590185751760970393
	.quad	4607155938267770208
	.quad	-4616216098587005600
	.quad	4590185751760970393
	.quad	4607160003989618959
	.quad	4589744810590291021
	.quad	-4633627226264484787
	.quad	4607160003989618959
	.quad	4604079374282302598
	.quad	4604977468824438271
	.quad	-4618394568030337537
	.quad	4604079374282302598
	.quad	4606233055365547081
	.quad	4601721693286060937
	.quad	-4621650343568714871
	.quad	4606233055365547081
	.quad	4599374859150636784
	.quad	4606719100629313491
	.quad	-4616652936225462317
	.quad	4599374859150636784
	.quad	4606863472012527185
	.quad	4598423001813699022
	.quad	-4624949035041076786
	.quad	4606863472012527185
	.quad	4602598930031891166
	.quad	4605998608960791335
	.quad	-4617373427893984473
	.quad	4602598930031891166
	.quad	4605292980606880364
	.quad	4603694922063032361
	.quad	-4619677114791743447
	.quad	4605292980606880364
	.quad	4593688012422887515
	.quad	4607111255739239816
	.quad	-4616260781115535992
	.quad	4593688012422887515
	.quad	4607054494135176056
	.quad	4595218635031890910
	.quad	-4628153401822884898
	.quad	4607054494135176056
	.quad	4603384207141321914
	.quad	4605523422498301790
	.quad	-4617848614356474018
	.quad	4603384207141321914
	.quad	4605799732098147061
	.quad	4602970680601913687
	.quad	-4620401356252862121
	.quad	4605799732098147061
	.quad	4597169786279785693
	.quad	4606957467106717424
	.quad	-4616414569748058384
	.quad	4597169786279785693
	.quad	4606588777269136769
	.quad	4600103317933788342
	.quad	-4623268718920987466
	.quad	4606588777269136769
	.quad	4601022290077223616
	.quad	4606398451906509788
	.quad	-4616973584948266020
	.quad	4601022290077223616
	.quad	4604717681185626434
	.quad	4604366005771528720
	.quad	-4619006031083247088
	.quad	4604717681185626434
	.quad	4583614727651146525
	.quad	4607178985458280057
	.quad	-4616193051396495751
	.quad	4583614727651146525
	.quad	4607172882816799076
	.quad	4586790578280679046
	.quad	-4636581458574096762
	.quad	4607172882816799076
	.quad	4604244531615310815
	.quad	4604830524903495634
	.quad	-4618541511951280174
	.quad	4604244531615310815
	.quad	4606329407841126011
	.quad	4601323770373937522
	.quad	-4622048266480838286
	.quad	4606329407841126011
	.quad	4599792496117920694
	.quad	4606646545123403481
	.quad	-4616725491731372327
	.quad	4599792496117920694
	.quad	4606919157647773535
	.quad	4597815040470278984
	.quad	-4625556996384496824
	.quad	4606919157647773535
	.quad	4602829525820289164
	.quad	4605886709123365959
	.quad	-4617485327731409849
	.quad	4602829525820289164
	.quad	4605426297151190466
	.quad	4603518581031047189
	.quad	-4619853455823728619
	.quad	4605426297151190466
	.quad	4594563856311064231
	.quad	4607080832832247697
	.quad	-4616291204022528111
	.quad	4594563856311064231
	.quad	4607088942243446236
	.quad	4594345179472540681
	.quad	-4629026857382235127
	.quad	4607088942243446236
	.quad	4603562972219549215
	.quad	4605393374401988274
	.quad	-4617978662452787534
	.quad	4603562972219549215
	.quad	4605915122243179241
	.quad	4602782121393764535
	.quad	-4620589915461011273
	.quad	4605915122243179241
	.quad	4598029484874872834
	.quad	4606905728766014348
	.quad	-4616466308088761460
	.quad	4598029484874872834
	.quad	4606665164148251002
	.quad	4599688422741010356
	.quad	-4623683614113765452
	.quad	4606665164148251002
	.quad	4601423692641949331
	.quad	4606305777984577632
	.quad	-4617066258870198176
	.quad	4601423692641949331
	.quad	4604867640218014515
	.quad	4604203581176243359
	.quad	-4619168455678532449
	.quad	4604867640218014515
	.quad	4587673791460508439
	.quad	4607170170974224083
	.quad	-4616201865880551725
	.quad	4587673791460508439
	.quad	4607141713064252300
	.quad	4591507261658050721
	.quad	-4631864775196725087
	.quad	4607141713064252300
	.quad	4603910660507251362
	.quad	4605120315324767624
	.quad	-4618251721530008184
	.quad	4603910660507251362
	.quad	4606131849150971908
	.quad	4602114767134999006
	.quad	-4621257269719776802
	.quad	4606131849150971908
	.quad	4598953786765296928
	.quad	4606786509620734768
	.quad	-4616585527234041040
	.quad	4598953786765296928
	.quad	4606802552898869248
	.quad	4598848011564831930
	.quad	-4624524025289943878
	.quad	4606802552898869248
	.quad	4602212250118051877
	.quad	4606105796280968177
	.quad	-4617266240573807631
	.quad	4602212250118051877
	.quad	4605155376589456981
	.quad	4603867938232615808
	.quad	-4619504098622160000
	.quad	4605155376589456981
	.quad	4591947271803021404
	.quad	4607136295912168606
	.quad	-4616235740942607202
	.quad	4591947271803021404
	.quad	4607014697483910382
	.quad	4596088445927168004
	.quad	-4627283590927607804
	.quad	4607014697483910382
	.quad	4603202304363743346
	.quad	4605649044311923410
	.quad	-4617722992542852398
	.quad	4603202304363743346
	.quad	4605679749231851918
	.quad	4603156351203636159
	.quad	-4620215685651139649
	.quad	4605679749231851918
	.quad	4596305267720071930
	.quad	4607003915349878877
	.quad	-4616368121504896931
	.quad	4596305267720071930
	.quad	4606507322377452870
	.quad	4600514338912178239
	.quad	-4622857697942597569
	.quad	4606507322377452870
	.quad	4600616459743653188
	.quad	4606486172460753999
	.quad	-4616885864394021809
	.quad	4600616459743653188
	.quad	4604563781218984604
	.quad	4604524701268679793
	.quad	-4618847335586096015
	.quad	4604563781218984604
	.quad	4569220649180767418
	.quad	4607182376410422530
	.quad	-4616189660444353278
	.quad	4569220649180767418
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
