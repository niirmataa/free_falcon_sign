	.file	"targets.c"
# GNU C99 (Debian 14.2.0-19) version 14.2.0 (x86_64-linux-gnu)
#	compiled by GNU C version 14.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.27-GMP

# warning: MPFR header version 4.2.1 differs from library version 4.2.2.
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O -std=c99 -fasynchronous-unwind-tables
	.text
	.type	target_floor, @function
target_floor:
.LFB32:
	.cfi_startproc
# baseline/source/fpr-emulated.h:124: 	e = (int)(x >> 52) & 0x7FF;
	movq	%rdi, %rdx	# x, _5
	shrq	$52, %rdx	#, _5
# baseline/source/fpr-emulated.h:124: 	e = (int)(x >> 52) & 0x7FF;
	andl	$2047, %edx	#, e
	movq	%rdi, %rax	# x, _14
	sarq	$63, %rax	#, _14
# baseline/source/fpr-emulated.h:131: 	xi ^= (xi ^ -(int64_t)t) & -(int64_t)((uint32_t)(63 - cc) >> 31);
	movl	%edx, %esi	# e, tmp142
	subl	$1022, %esi	#, tmp142
	js	.L2	#,
# baseline/source/fpr-emulated.h:126: 	xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
	movq	%rdi, %rcx	# x, _9
	salq	$10, %rcx	#, _9
# baseline/source/fpr-emulated.h:126: 	xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
	btrq	$63, %rcx	#, _10
	btsq	$62, %rcx	#, _11
# baseline/source/fpr-emulated.h:128: 	xi = (xi ^ -(int64_t)t) + (int64_t)t;
	xorq	%rax, %rcx	# _14, _15
# baseline/source/fpr-emulated.h:125: 	t = x >> 63;
	shrq	$63, %rdi	#, t_8
# baseline/source/fpr-emulated.h:128: 	xi = (xi ^ -(int64_t)t) + (int64_t)t;
	addq	%rcx, %rdi	# _15, xi
# baseline/source/fpr-emulated.h:129: 	cc = 1085 - e;
	movl	$1085, %ecx	#, tmp134
	subl	%edx, %ecx	# e, cc
# baseline/source/fpr-emulated.h:28: 	x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
	movq	%rdi, %rax	# xi, _20
	sarq	$32, %rax	#, _20
# baseline/source/fpr-emulated.h:28: 	x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
	testb	$32, %cl	#, cc
	cmove	%rdi, %rax	# _20,, xi, x_26
# baseline/source/fpr-emulated.h:29: 	return x >> (n & 31);
	andl	$31, %ecx	#, _27
# baseline/source/fpr-emulated.h:29: 	return x >> (n & 31);
	sarq	%cl, %rax	# _27, _14
.L2:
# harness/targets.c:10: UNARY(target_floor, fpr_floor(x))
	ret	
	.cfi_endproc
.LFE32:
	.size	target_floor, .-target_floor
	.type	target_rint, @function
target_rint:
.LFB34:
	.cfi_startproc
	movq	%rdi, %rsi	# tmp187, x
# baseline/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdi, %rdx	# x, _5
	salq	$10, %rdx	#, _5
# baseline/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp151
	andq	%rax, %rdx	# tmp151, _6
# baseline/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	btsq	$62, %rdx	#, m
# baseline/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	shrq	$52, %rdi	#, _8
# baseline/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %edi	#, _10
# baseline/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	$1085, %r8d	#, tmp154
	subl	%edi, %r8d	# _10, e
# baseline/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	$1021, %eax	#, tmp156
	subl	%edi, %eax	# _10, _12
# baseline/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _14
# baseline/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _14, _15
# baseline/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp159
	andq	%rdx, %rax	# m, m
# baseline/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r8d, %r9d	# e, e
	andl	$63, %r9d	#, e
# baseline/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	$63, %ecx	#, tmp160
	subl	%r9d, %ecx	# e, _18
# baseline/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdx	# m, _19
	salq	$32, %rdx	#, _19
# baseline/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _18
	cmove	%rax, %rdx	# _19,, m, x_25
# baseline/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _26
# baseline/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdx	# _26, _27
# baseline/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdx, %rdi	# _27, _29
	shrq	$32, %rdi	#, _29
# baseline/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %edi	#, _31
# baseline/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edx, %edi	# _27, dd
# baseline/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _39
	shrq	$32, %rcx	#, _39
# baseline/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r9d	#, tmp188
	cmovne	%rcx, %rax	# _39,, x_45
# baseline/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r8d, %ecx	# e, e
	andl	$31, %ecx	#, e
# baseline/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rax	# _46, x_45
	movq	%rax, %r8	# x_45, _47
# baseline/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%edi, %ecx	# dd, _35
	negl	%ecx	# _35
# baseline/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edi, %ecx	# dd, _36
# baseline/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _37
# baseline/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdx	#, _33
# baseline/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edx, %ecx	# _33, f_38
# baseline/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %edx	#, tmp180
	movl	%edx, %eax	# tmp180, tmp180
	shrl	%cl, %eax	# f_38, tmp180
# baseline/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %eax	#, _50
# baseline/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%r8, %rax	# _47, m_51
# baseline/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rsi, %rdx	# x, _54
	sarq	$63, %rdx	#, _54
	xorq	%rdx, %rax	# _54, _56
# baseline/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rsi	#, _52
# baseline/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rsi, %rax	# _52, _58
# harness/targets.c:12: UNARY(target_rint, fpr_rint(x))
	ret	
	.cfi_endproc
.LFE34:
	.size	target_rint, .-target_rint
	.type	target_half, @function
target_half:
.LFB36:
	.cfi_startproc
# baseline/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	movabsq	$-4503599627370496, %rax	#, tmp109
	addq	%rdi, %rax	# tmp116, x
# baseline/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rax, %rdx	# x, _4
	shrq	$52, %rdx	#, _4
# baseline/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %edx	#, _6
# baseline/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %edx	#, _7
# baseline/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %edx	#, t_8
# baseline/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%edx, %edx	# t_8, _9
# baseline/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rdx	#, _10
# baseline/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rdx, %rax	# _10, x_11
# harness/targets.c:14: UNARY(target_half, fpr_half(x))
	ret	
	.cfi_endproc
.LFE36:
	.size	target_half, .-target_half
	.type	target_lt, @function
target_lt:
.LFB41:
	.cfi_startproc
# baseline/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	movq	%rdi, %rdx	# x, _11
	andq	%rsi, %rdx	# y, _11
# baseline/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	shrq	$63, %rdx	#, _12
# baseline/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	cmpq	%rsi, %rdi	# y, x
	setne	%al	#, _9
	movzbl	%al, %eax	# _9, _9
# baseline/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	andl	%edx, %eax	# _12, _14
# baseline/source/fpr-emulated.h:203: 	cc0 = sx < sy;
	cmpq	%rsi, %rdi	# y, x
	setl	%dl	#, _7
	movzbl	%dl, %edx	# _7, _7
# baseline/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	xorl	%edx, %eax	# _7, _15
# harness/targets.c:20: static uint64_t target_lt(uint64_t x, uint64_t y) { return (uint64_t)fpr_lt(x, y); }
	cltq
# harness/targets.c:20: static uint64_t target_lt(uint64_t x, uint64_t y) { return (uint64_t)fpr_lt(x, y); }
	ret	
	.cfi_endproc
.LFE41:
	.size	target_lt, .-target_lt
	.type	positive_loop, @function
positive_loop:
.LFB42:
	.cfi_startproc
# harness/targets.c:25:     volatile uint64_t v = y;
	movq	%rsi, -8(%rsp)	# y, v
# harness/targets.c:26:     unsigned n = (x & 1) ? 256 : 8;
	andl	$1, %edi	#, _1
# harness/targets.c:26:     unsigned n = (x & 1) ? 256 : 8;
	cmpq	$1, %rdi	#, _1
	sbbl	%ecx, %ecx	# iftmp.9_6
	andb	$8, %cl	#, iftmp.9_6
	addl	$256, %ecx	#, iftmp.9_6
# harness/targets.c:27:     for (unsigned i = 0; i < n; i++) v = v * UINT64_C(6364136223846793005) + 1;
	movl	$0, %edx	#, i
# harness/targets.c:27:     for (unsigned i = 0; i < n; i++) v = v * UINT64_C(6364136223846793005) + 1;
	movabsq	$6364136223846793005, %rsi	#, tmp109
	.p2align 5
.L8:
	movq	-8(%rsp), %rax	# v, v.10_2
	imulq	%rsi, %rax	# tmp109, _3
# harness/targets.c:27:     for (unsigned i = 0; i < n; i++) v = v * UINT64_C(6364136223846793005) + 1;
	addq	$1, %rax	#, _4
# harness/targets.c:27:     for (unsigned i = 0; i < n; i++) v = v * UINT64_C(6364136223846793005) + 1;
	movq	%rax, -8(%rsp)	# _4, v
# harness/targets.c:27:     for (unsigned i = 0; i < n; i++) v = v * UINT64_C(6364136223846793005) + 1;
	addl	$1, %edx	#, i
# harness/targets.c:27:     for (unsigned i = 0; i < n; i++) v = v * UINT64_C(6364136223846793005) + 1;
	cmpl	%edx, %ecx	# i, iftmp.9_6
	jne	.L8	#,
# harness/targets.c:28:     return v;
	movq	-8(%rsp), %rax	# v, <retval>
# harness/targets.c:29: }
	ret	
	.cfi_endproc
.LFE42:
	.size	positive_loop, .-positive_loop
	.type	target_scaled, @function
target_scaled:
.LFB37:
	.cfi_startproc
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
# harness/targets.c:15: UNARY(target_scaled, fpr_scaled((int64_t)x, 0))
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE37:
	.size	target_scaled, .-target_scaled
	.type	target_expm, @function
target_expm:
.LFB35:
	.cfi_startproc
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
# baseline/source/fpr-emulated.h:277: 	z = (uint64_t)fpr_trunc(fpr_mul(r, fpr_p63)) << 1;
	movabsq	$4890909195324358656, %rsi	#, tmp151
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp189, _5
# baseline/source/fpr-emulated.h:141: 	e = (int)(x >> 52) & 0x7FF;
	movq	%rax, %rsi	# _5, _15
	shrq	$52, %rsi	#, _15
# baseline/source/fpr-emulated.h:141: 	e = (int)(x >> 52) & 0x7FF;
	andl	$2047, %esi	#, e
# baseline/source/fpr-emulated.h:142: 	xu = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	salq	$10, %rax	#, _18
# baseline/source/fpr-emulated.h:142: 	xu = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rdx	#, tmp155
	andq	%rdx, %rax	# tmp155, _19
# baseline/source/fpr-emulated.h:142: 	xu = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	btsq	$62, %rax	#, xu
# baseline/source/fpr-emulated.h:143: 	cc = 1085 - e;
	movl	$1085, %ecx	#, tmp157
	subl	%esi, %ecx	# e, cc
# baseline/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdx	# xu, _23
	shrq	$32, %rdx	#, _23
# baseline/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, cc
	cmovne	%rdx, %rax	# _23,, x_29
# baseline/source/fpr-emulated.h:22: 	return x >> (n & 31);
	andl	$31, %ecx	#, _30
# baseline/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rax	# _30, x_29
	movq	%rax, %rdx	# x_29, _31
# baseline/source/fpr-emulated.h:145: 	xu &= -(uint64_t)((uint32_t)(cc - 64) >> 31);
	movl	$1021, %eax	#, tmp164
	subl	%esi, %eax	# e, _32
# baseline/source/fpr-emulated.h:145: 	xu &= -(uint64_t)((uint32_t)(cc - 64) >> 31);
	shrl	$31, %eax	#, _34
# baseline/source/fpr-emulated.h:145: 	xu &= -(uint64_t)((uint32_t)(cc - 64) >> 31);
	movl	%eax, %eax	# _34, _35
# baseline/source/fpr-emulated.h:145: 	xu &= -(uint64_t)((uint32_t)(cc - 64) >> 31);
	negq	%rax	# tmp167
	andq	%rdx, %rax	# _31, xu_36
# baseline/source/fpr-emulated.h:147: 	xu = (xu ^ -t) + t;
	movq	%rdi, %rdx	# _5, _39
	sarq	$63, %rdx	#, _39
# baseline/source/fpr-emulated.h:147: 	xu = (xu ^ -t) + t;
	xorq	%rdx, %rax	# _39, _41
# baseline/source/fpr-emulated.h:146: 	t = x >> 63;
	shrq	$63, %rdi	#, t_37
# baseline/source/fpr-emulated.h:147: 	xu = (xu ^ -t) + t;
	addq	%rax, %rdi	# _41, xu_42
# baseline/source/fpr-emulated.h:277: 	z = (uint64_t)fpr_trunc(fpr_mul(r, fpr_p63)) << 1;
	addq	%rdi, %rdi	# z
# baseline/source/fpr-emulated.h:258: 	x1 = (uint32_t)(x >> 32);
	movq	%rdi, %r8	# z, _44
	shrq	$32, %r8	#, _44
	leaq	8+fpr_expm_p63_coefficients(%rip), %rsi	#, ivtmp.57
	leaq	96(%rsi), %r9	#, _62
# baseline/source/fpr-emulated.h:276: 	y = fpr_expm_p63_coefficients[0];
	movabsq	$19127174051, %rax	#, <retval>
	movl	%edi, %edi	# z, _46
.L14:
# baseline/source/fpr-emulated.h:260: 	y1 = (uint32_t)(y >> 32);
	movq	%rax, %r10	# <retval>, _45
	shrq	$32, %r10	#, _45
	movl	%eax, %ecx	# <retval>, _48
# baseline/source/fpr-emulated.h:262: 		+ (((uint64_t)x0 * (uint64_t)y0) >> 32);
	movq	%rdi, %rdx	# _46, _49
	imulq	%rcx, %rdx	# _48, _49
# baseline/source/fpr-emulated.h:262: 		+ (((uint64_t)x0 * (uint64_t)y0) >> 32);
	shrq	$32, %rdx	#, _50
# baseline/source/fpr-emulated.h:261: 	a = (uint64_t)x0 * (uint64_t)y1
	movq	%r10, %rax	# _45, _47
	imulq	%rdi, %rax	# _46, _47
# baseline/source/fpr-emulated.h:261: 	a = (uint64_t)x0 * (uint64_t)y1
	addq	%rax, %rdx	# _47, a
# baseline/source/fpr-emulated.h:263: 	b = (uint64_t)x1 * (uint64_t)y0;
	imulq	%r8, %rcx	# _44, b
# baseline/source/fpr-emulated.h:266: 	c += (uint64_t)x1 * (uint64_t)y1;
	imulq	%r8, %r10	# _44, _61
# baseline/source/fpr-emulated.h:279: 		y = fpr_expm_p63_coefficients[u] - fpr_mul_high_u64(z, y);
	movq	(%rsi), %rax	# MEM[(long unsigned int *)_60], _64
	subq	%r10, %rax	# _61, _64
# baseline/source/fpr-emulated.h:264: 	c = (a >> 32) + (b >> 32);
	movq	%rcx, %r10	# b, _54
	shrq	$32, %r10	#, _54
# baseline/source/fpr-emulated.h:279: 		y = fpr_expm_p63_coefficients[u] - fpr_mul_high_u64(z, y);
	subq	%r10, %rax	# _54, _12
# baseline/source/fpr-emulated.h:264: 	c = (a >> 32) + (b >> 32);
	movq	%rdx, %r10	# a, _53
	shrq	$32, %r10	#, _53
# baseline/source/fpr-emulated.h:279: 		y = fpr_expm_p63_coefficients[u] - fpr_mul_high_u64(z, y);
	subq	%r10, %rax	# _53, _6
# baseline/source/fpr-emulated.h:265: 	c += ((uint64_t)(uint32_t)a + (uint64_t)(uint32_t)b) >> 32;
	movl	%edx, %edx	# a, _56
	movl	%ecx, %ecx	# b, _57
	addq	%rcx, %rdx	# _57, _58
# baseline/source/fpr-emulated.h:265: 	c += ((uint64_t)(uint32_t)a + (uint64_t)(uint32_t)b) >> 32;
	shrq	$32, %rdx	#, _59
# baseline/source/fpr-emulated.h:279: 		y = fpr_expm_p63_coefficients[u] - fpr_mul_high_u64(z, y);
	subq	%rdx, %rax	# _59, <retval>
# baseline/source/fpr-emulated.h:278: 	for (u = 1; u < 13; u ++) {
	addq	$8, %rsi	#, ivtmp.57
	cmpq	%r9, %rsi	# _62, ivtmp.57
	jne	.L14	#,
# harness/targets.c:13: UNARY(target_expm, fpr_expm_scaled(x))
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE35:
	.size	target_expm, .-target_expm
	.type	target_mul, @function
target_mul:
.LFB39:
	.cfi_startproc
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
# harness/targets.c:18: static uint64_t target_mul(uint64_t x, uint64_t y) { return fpr_mul(x, y); }
	call	fpr_mul@PLT	#
# harness/targets.c:18: static uint64_t target_mul(uint64_t x, uint64_t y) { return fpr_mul(x, y); }
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE39:
	.size	target_mul, .-target_mul
	.type	target_sqrt, @function
target_sqrt:
.LFB33:
	.cfi_startproc
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
# harness/targets.c:11: UNARY(target_sqrt, fpr_sqrt(x))
	call	fpr_sqrt@PLT	#
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE33:
	.size	target_sqrt, .-target_sqrt
	.type	target_div, @function
target_div:
.LFB40:
	.cfi_startproc
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
# harness/targets.c:19: static uint64_t target_div(uint64_t x, uint64_t y) { return fpr_div(x, y); }
	call	fpr_div@PLT	#
# harness/targets.c:19: static uint64_t target_div(uint64_t x, uint64_t y) { return fpr_div(x, y); }
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE40:
	.size	target_div, .-target_div
	.type	target_add, @function
target_add:
.LFB38:
	.cfi_startproc
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
# harness/targets.c:17: static uint64_t target_add(uint64_t x, uint64_t y) { return fpr_add(x, y); }
	call	fpr_add@PLT	#
# harness/targets.c:17: static uint64_t target_add(uint64_t x, uint64_t y) { return fpr_add(x, y); }
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE38:
	.size	target_add, .-target_add
	.globl	select_target
	.type	select_target, @function
select_target:
.LFB43:
	.cfi_startproc
# harness/targets.c:38:     return c < sizeof targets / sizeof *targets ? targets[c] : NULL;
	movl	$0, %eax	#, <retval>
# harness/targets.c:38:     return c < sizeof targets / sizeof *targets ? targets[c] : NULL;
	cmpl	$13, %edi	#, c
	ja	.L25	#,
# harness/targets.c:38:     return c < sizeof targets / sizeof *targets ? targets[c] : NULL;
	movl	%edi, %edi	# c, c
	leaq	targets.0(%rip), %rax	#, tmp100
	movq	(%rax,%rdi,8), %rax	# targets[c_2(D)], <retval>
.L25:
# harness/targets.c:39: }
	ret	
	.cfi_endproc
.LFE43:
	.size	select_target, .-select_target
	.section	.data.rel.ro.local,"aw"
	.align 32
	.type	targets.0, @object
	.size	targets.0, 112
targets.0:
	.quad	target_floor
	.quad	positive_loop
	.quad	target_floor
	.quad	target_floor
	.quad	target_floor
	.quad	target_add
	.quad	target_mul
	.quad	target_div
	.quad	target_sqrt
	.quad	target_rint
	.quad	target_expm
	.quad	target_half
	.quad	target_lt
	.quad	target_scaled
	.section	.rodata
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
