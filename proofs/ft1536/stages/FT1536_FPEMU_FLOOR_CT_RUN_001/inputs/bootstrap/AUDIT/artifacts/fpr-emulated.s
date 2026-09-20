	.file	"fpr-emulated.c"
# GNU C99 (Debian 14.2.0-19) version 14.2.0 (x86_64-linux-gnu)
#	compiled by GNU C version 14.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.27-GMP

# warning: MPFR header version 4.2.1 differs from library version 4.2.2.
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O -std=c99 -fasynchronous-unwind-tables
	.text
	.globl	fpr_scaled
	.type	fpr_scaled, @function
fpr_scaled:
.LFB32:
	.cfi_startproc
	movq	%rdi, %rax	# tmp293, i
	movl	%esi, %r8d	# sc, tmp294
# inputs/bootstrap/source/fpr-emulated.c:170: 	i ^= -(int64_t)s;
	movq	%rdi, %rsi	# i, _3
	shrq	$63, %rsi	#, _3
# inputs/bootstrap/source/fpr-emulated.c:170: 	i ^= -(int64_t)s;
	cqto
# inputs/bootstrap/source/fpr-emulated.c:170: 	i ^= -(int64_t)s;
	xorq	%rdi, %rdx	# i, i
# inputs/bootstrap/source/fpr-emulated.c:171: 	i += s;
	addq	%rdx, %rsi	# i, i
# inputs/bootstrap/source/fpr-emulated.c:181: 	FPR_NORM64(m, e);
	movq	%rsi, %rcx	# i, _5
	shrq	$32, %rcx	#, _5
	movl	%ecx, %edx	# _5, _6
	negl	%edx	# _6
	orl	%ecx, %edx	# _5, _7
	shrl	$31, %edx	#, nt
	movq	%rsi, %rcx	# i, _8
	salq	$32, %rcx	#, _8
	xorq	%rsi, %rcx	# i, _9
	movl	%edx, %edi	# nt, _10
	subq	$1, %rdi	#, _11
	andq	%rdi, %rcx	# _11, _12
	xorq	%rsi, %rcx	# i, m
	sall	$5, %edx	#, _14
	leal	-54(%rdx,%r8), %r9d	#, e
	movq	%rcx, %rdx	# m, _15
	shrq	$48, %rdx	#, _15
	negl	%edx	# _16
	shrl	$31, %edx	#, nt
	movq	%rcx, %rdi	# m, _18
	salq	$16, %rdi	#, _18
	xorq	%rcx, %rdi	# m, _19
	movl	%edx, %r8d	# nt, _20
	subq	$1, %r8	#, _21
	andq	%r8, %rdi	# _21, _22
	xorq	%rcx, %rdi	# m, m
	sall	$4, %edx	#, _24
	leal	(%rdx,%r9), %ecx	#, e
	movq	%rdi, %r8	# m, _25
	shrq	$56, %r8	#, _25
	negl	%r8d	# _26
	shrl	$31, %r8d	#, nt
	movq	%rdi, %rdx	# m, _28
	salq	$8, %rdx	#, _28
	xorq	%rdi, %rdx	# m, _29
	movl	%r8d, %r9d	# nt, _30
	subq	$1, %r9	#, _31
	andq	%r9, %rdx	# _31, _32
	xorq	%rdi, %rdx	# m, m
	leal	(%rcx,%r8,8), %r9d	#, e
	movq	%rdx, %rdi	# m, _35
	shrq	$60, %rdi	#, _35
	negl	%edi	# _36
	shrl	$31, %edi	#, nt
	movq	%rdx, %rcx	# m, _38
	salq	$4, %rcx	#, _38
	xorq	%rdx, %rcx	# m, _39
	movl	%edi, %r8d	# nt, _40
	subq	$1, %r8	#, _41
	andq	%r8, %rcx	# _41, _42
	xorq	%rdx, %rcx	# m, m
	leal	(%r9,%rdi,4), %r9d	#, e
	movq	%rcx, %rdi	# m, _45
	shrq	$62, %rdi	#, _45
	negl	%edi	# _46
	shrl	$31, %edi	#, nt
	leaq	0(,%rcx,4), %rdx	#, _48
	xorq	%rcx, %rdx	# m, _49
	movl	%edi, %r8d	# nt, _50
	subq	$1, %r8	#, _51
	andq	%r8, %rdx	# _51, _52
	xorq	%rcx, %rdx	# m, m
	leal	(%r9,%rdi,2), %r8d	#, e
	movq	%rdx, %rdi	# m, _55
	shrq	$63, %rdi	#, _55
	leaq	(%rdx,%rdx), %rcx	#, _56
	xorq	%rdx, %rcx	# m, _57
	leaq	-1(%rdi), %r9	#, _58
	andq	%r9, %rcx	# _58, _59
	xorq	%rcx, %rdx	# _59, m
	addl	%edi, %r8d	# _55, e
# inputs/bootstrap/source/fpr-emulated.c:188: 	m |= ((uint32_t)m & 0x1FF) + 0x1FF;
	movq	%rdx, %rcx	# m, _63
	andl	$511, %ecx	#, _63
	leaq	511(%rcx), %rcx	#, _64
# inputs/bootstrap/source/fpr-emulated.c:188: 	m |= ((uint32_t)m & 0x1FF) + 0x1FF;
	movq	%rcx, %rdi	# _64, _64
	orq	%rdx, %rdi	# m, _64
# inputs/bootstrap/source/fpr-emulated.c:195: 	t = (uint32_t)((uint64_t)(i | -i) >> 63);
	movq	%rsi, %rcx	# i, _65
	negq	%rcx	# _65
# inputs/bootstrap/source/fpr-emulated.c:195: 	t = (uint32_t)((uint64_t)(i | -i) >> 63);
	orq	%rsi, %rcx	# i, _66
# inputs/bootstrap/source/fpr-emulated.c:197: 	e &= -(int)t;
	movq	%rcx, %rsi	# _66, tmp311
	sarq	$63, %rsi	#, tmp311
	andl	%r8d, %esi	# e, e_104
# inputs/bootstrap/source/fpr-emulated.h:46: 	e += 1076;
	addl	$1076, %esi	#, e
# inputs/bootstrap/source/fpr-emulated.h:47: 	t = (uint32_t)e >> 31;
	movl	%esi, %edx	# e, t_110
	shrl	$31, %edx	#, t_110
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	movl	%edx, %edx	# t_110, _111
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	subq	$1, %rdx	#, _112
# inputs/bootstrap/source/fpr-emulated.c:196: 	m &= -(uint64_t)t;
	sarq	$63, %rcx	#, _106
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	andq	%rcx, %rdx	# _106, _134
# inputs/bootstrap/source/fpr-emulated.c:189: 	m >>= 9;
	shrq	$9, %rdi	#, m
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	andq	%rdi, %rdx	# m_102, m
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	movabsq	$-9223372036854775808, %rcx	#, tmp279
	andq	%rcx, %rax	# tmp279, _132
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	movq	%rdx, %rcx	# m, _120
	shrq	$2, %rcx	#, _120
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	orq	%rcx, %rax	# _120, _121
# inputs/bootstrap/source/fpr-emulated.h:52: 	f = (unsigned)m & 7U;
	movl	%edx, %ecx	# m, f_127
	andl	$7, %ecx	#, f_127
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	movl	$200, %edi	#, tmp284
	shrl	%cl, %edi	# f_127, _128
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	andl	$1, %edi	#, _130
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	addq	%rdi, %rax	# _130, _135
# inputs/bootstrap/source/fpr-emulated.h:49: 	t = (uint32_t)(m >> 54);
	shrq	$54, %rdx	#, _114
# inputs/bootstrap/source/fpr-emulated.h:50: 	e &= -(int)t;
	negl	%edx	# tmp289
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	andl	%esi, %edx	# e, _123
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	salq	$52, %rdx	#, _124
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	addq	%rdx, %rax	# _124, x_131
# inputs/bootstrap/source/fpr-emulated.c:204: }
	ret	
	.cfi_endproc
.LFE32:
	.size	fpr_scaled, .-fpr_scaled
	.globl	fpr_add
	.type	fpr_add, @function
fpr_add:
.LFB33:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rax	# tmp386, x
# inputs/bootstrap/source/fpr-emulated.c:468: 	za = (x & m) - (y & m);
	movabsq	$9223372036854775807, %rdi	#, tmp275
	movq	%rax, %rcx	# x, _1
	andq	%rdi, %rcx	# tmp275, _1
# inputs/bootstrap/source/fpr-emulated.c:468: 	za = (x & m) - (y & m);
	andq	%rsi, %rdi	# y, _2
# inputs/bootstrap/source/fpr-emulated.c:470: 		| ((1U - (uint32_t)(-za >> 63)) & (uint32_t)(x >> 63));
	movq	%rdi, %rdx	# _2, _5
	subq	%rcx, %rdx	# _1, _5
# inputs/bootstrap/source/fpr-emulated.c:470: 		| ((1U - (uint32_t)(-za >> 63)) & (uint32_t)(x >> 63));
	shrq	$63, %rdx	#, _6
# inputs/bootstrap/source/fpr-emulated.c:470: 		| ((1U - (uint32_t)(-za >> 63)) & (uint32_t)(x >> 63));
	xorl	$1, %edx	#, _8
# inputs/bootstrap/source/fpr-emulated.c:470: 		| ((1U - (uint32_t)(-za >> 63)) & (uint32_t)(x >> 63));
	movq	%rax, %r8	# x, _9
	shrq	$63, %r8	#, _9
# inputs/bootstrap/source/fpr-emulated.c:470: 		| ((1U - (uint32_t)(-za >> 63)) & (uint32_t)(x >> 63));
	andl	%r8d, %edx	# _9, _11
# inputs/bootstrap/source/fpr-emulated.c:468: 	za = (x & m) - (y & m);
	subq	%rdi, %rcx	# _2, za_103
# inputs/bootstrap/source/fpr-emulated.c:469: 	cs = (uint32_t)(za >> 63)
	shrq	$63, %rcx	#, _3
# inputs/bootstrap/source/fpr-emulated.c:472: 	x ^= m;
	orb	%cl, %dl	# _3, tmp388
	movq	%rax, %r8	# x, x_106
	cmovne	%rsi, %r8	# y,, x_106
# inputs/bootstrap/source/fpr-emulated.c:473: 	y ^= m;
	movq	%rsi, %rcx	# y, y
	cmovne	%rax, %rcx	# x,, y
# inputs/bootstrap/source/fpr-emulated.c:481: 	ex = (int)(x >> 52);
	movq	%r8, %rdi	# x_106, _15
	shrq	$52, %rdi	#, _15
# inputs/bootstrap/source/fpr-emulated.c:482: 	sx = ex >> 11;
	movl	%edi, %eax	# _15, sx
	sarl	$11, %eax	#, sx
# inputs/bootstrap/source/fpr-emulated.c:483: 	ex &= 0x7FF;
	andl	$2047, %edi	#, ex
# inputs/bootstrap/source/fpr-emulated.c:487: 	ey = (int)(y >> 52);
	movq	%rcx, %rdx	# y_107, _22
	shrq	$52, %rdx	#, _22
# inputs/bootstrap/source/fpr-emulated.c:489: 	ey &= 0x7FF;
	movl	%edx, %r10d	# _22, ey
	andl	$2047, %r10d	#, ey
# inputs/bootstrap/source/fpr-emulated.c:490: 	m = (uint64_t)(uint32_t)((ey + 0x7FF) >> 11) << 52;
	leal	2047(%r10), %esi	#, _23
# inputs/bootstrap/source/fpr-emulated.c:490: 	m = (uint64_t)(uint32_t)((ey + 0x7FF) >> 11) << 52;
	sarl	$11, %esi	#, _24
# inputs/bootstrap/source/fpr-emulated.c:490: 	m = (uint64_t)(uint32_t)((ey + 0x7FF) >> 11) << 52;
	salq	$52, %rsi	#, m_116
# inputs/bootstrap/source/fpr-emulated.c:491: 	yu = ((y & (((uint64_t)1 << 52) - 1)) | m) << 3;
	movabsq	$4503599627370495, %r9	#, tmp294
	andq	%r9, %rcx	# tmp294, _27
# inputs/bootstrap/source/fpr-emulated.c:491: 	yu = ((y & (((uint64_t)1 << 52) - 1)) | m) << 3;
	orq	%rcx, %rsi	# _27, _28
# inputs/bootstrap/source/fpr-emulated.c:491: 	yu = ((y & (((uint64_t)1 << 52) - 1)) | m) << 3;
	salq	$3, %rsi	#, yu
# inputs/bootstrap/source/fpr-emulated.c:499: 	cc = ex - ey;
	movl	%edi, %ecx	# ex, cc
	subl	%r10d, %ecx	# ey, cc
# inputs/bootstrap/source/fpr-emulated.c:500: 	yu &= -(uint64_t)((uint32_t)(cc - 60) >> 31);
	leal	-60(%rcx), %r10d	#, _29
# inputs/bootstrap/source/fpr-emulated.c:500: 	yu &= -(uint64_t)((uint32_t)(cc - 60) >> 31);
	shrl	$31, %r10d	#, _31
# inputs/bootstrap/source/fpr-emulated.c:500: 	yu &= -(uint64_t)((uint32_t)(cc - 60) >> 31);
	movl	%r10d, %r10d	# _31, _32
# inputs/bootstrap/source/fpr-emulated.c:500: 	yu &= -(uint64_t)((uint32_t)(cc - 60) >> 31);
	negq	%r10	# tmp299
	andq	%rsi, %r10	# yu, yu
	movl	%ecx, %r11d	# cc, _189
	sarl	$5, %r11d	#, _189
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _162
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movl	%r11d, %esi	# _189, _158
	andl	$1, %esi	#, _158
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	negq	%rsi	# tmp302
	movabsq	$4294967297, %rbx	#, tmp304
	andq	%rbx, %rsi	# tmp304, _160
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	xorq	$1, %rsi	#, x_161
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rsi	# _162, _163
# inputs/bootstrap/source/fpr-emulated.c:506: 	m = fpr_ulsh(1, cc) - 1;
	subq	$1, %rsi	#, m
# inputs/bootstrap/source/fpr-emulated.c:507: 	yu |= (yu & m) + m;
	movq	%r10, %rbx	# yu, _33
	andq	%rsi, %rbx	# m, _33
# inputs/bootstrap/source/fpr-emulated.c:507: 	yu |= (yu & m) + m;
	addq	%rbx, %rsi	# _33, _34
# inputs/bootstrap/source/fpr-emulated.c:507: 	yu |= (yu & m) + m;
	orq	%rsi, %r10	# _34, yu
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%r10, %rsi	# yu, _152
	shrq	$32, %rsi	#, _152
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	testb	$1, %r11b	#, _189
	cmove	%r10, %rsi	# _152,, yu, x_155
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rsi	# _162, x_155
	movq	%rsi, %rcx	# x_155, _156
# inputs/bootstrap/source/fpr-emulated.c:484: 	m = (uint64_t)(uint32_t)((ex + 0x7FF) >> 11) << 52;
	leal	2047(%rdi), %esi	#, _16
# inputs/bootstrap/source/fpr-emulated.c:484: 	m = (uint64_t)(uint32_t)((ex + 0x7FF) >> 11) << 52;
	sarl	$11, %esi	#, _17
# inputs/bootstrap/source/fpr-emulated.c:484: 	m = (uint64_t)(uint32_t)((ex + 0x7FF) >> 11) << 52;
	salq	$52, %rsi	#, m_111
# inputs/bootstrap/source/fpr-emulated.c:485: 	xu = ((x & (((uint64_t)1 << 52) - 1)) | m) << 3;
	andq	%r9, %r8	# tmp294, _20
# inputs/bootstrap/source/fpr-emulated.c:485: 	xu = ((x & (((uint64_t)1 << 52) - 1)) | m) << 3;
	orq	%rsi, %r8	# m_111, _21
	leaq	(%rcx,%r8,8), %rsi	#, _172
# inputs/bootstrap/source/fpr-emulated.c:488: 	sy = ey >> 11;
	sarl	$11, %edx	#, sy_114
# inputs/bootstrap/source/fpr-emulated.c:514: 	xu += yu - ((yu << 1) & -(uint64_t)(sx ^ sy));
	xorl	%eax, %edx	# sx, _36
# inputs/bootstrap/source/fpr-emulated.c:514: 	xu += yu - ((yu << 1) & -(uint64_t)(sx ^ sy));
	movslq	%edx, %rdx	# _36, _37
# inputs/bootstrap/source/fpr-emulated.c:514: 	xu += yu - ((yu << 1) & -(uint64_t)(sx ^ sy));
	addq	%rcx, %rcx	# _35
# inputs/bootstrap/source/fpr-emulated.c:514: 	xu += yu - ((yu << 1) & -(uint64_t)(sx ^ sy));
	negq	%rdx	# tmp323
	andq	%rcx, %rdx	# _35, _39
# inputs/bootstrap/source/fpr-emulated.c:514: 	xu += yu - ((yu << 1) & -(uint64_t)(sx ^ sy));
	subq	%rdx, %rsi	# _39, xu
# inputs/bootstrap/source/fpr-emulated.c:521: 	FPR_NORM64(xu, ex);
	movq	%rsi, %rcx	# xu, _41
	shrq	$32, %rcx	#, _41
	movl	%ecx, %edx	# _41, _42
	negl	%edx	# _42
	orl	%ecx, %edx	# _41, _43
	shrl	$31, %edx	#, nt
	movq	%rsi, %rcx	# xu, _44
	salq	$32, %rcx	#, _44
	xorq	%rsi, %rcx	# xu, _45
	movl	%edx, %r8d	# nt, _46
	subq	$1, %r8	#, _47
	andq	%r8, %rcx	# _47, _48
	xorq	%rsi, %rcx	# xu, xu
	sall	$5, %edx	#, _50
	leal	-1141(%rdi,%rdx), %r8d	#, ex
	movq	%rcx, %rdx	# xu, _51
	shrq	$48, %rdx	#, _51
	negl	%edx	# _52
	shrl	$31, %edx	#, nt
	movq	%rcx, %rsi	# xu, _54
	salq	$16, %rsi	#, _54
	xorq	%rcx, %rsi	# xu, _55
	movl	%edx, %edi	# nt, _56
	subq	$1, %rdi	#, _57
	andq	%rdi, %rsi	# _57, _58
	xorq	%rcx, %rsi	# xu, xu
	sall	$4, %edx	#, _60
	leal	(%rdx,%r8), %ecx	#, ex
	movq	%rsi, %rdi	# xu, _61
	shrq	$56, %rdi	#, _61
	negl	%edi	# _62
	shrl	$31, %edi	#, nt
	movq	%rsi, %rdx	# xu, _64
	salq	$8, %rdx	#, _64
	xorq	%rsi, %rdx	# xu, _65
	movl	%edi, %r8d	# nt, _66
	subq	$1, %r8	#, _67
	andq	%r8, %rdx	# _67, _68
	xorq	%rsi, %rdx	# xu, xu
	leal	(%rcx,%rdi,8), %r8d	#, ex
	movq	%rdx, %rsi	# xu, _71
	shrq	$60, %rsi	#, _71
	negl	%esi	# _72
	shrl	$31, %esi	#, nt
	movq	%rdx, %rcx	# xu, _74
	salq	$4, %rcx	#, _74
	xorq	%rdx, %rcx	# xu, _75
	movl	%esi, %edi	# nt, _76
	subq	$1, %rdi	#, _77
	andq	%rdi, %rcx	# _77, _78
	xorq	%rdx, %rcx	# xu, xu
	leal	(%r8,%rsi,4), %r8d	#, ex
	movq	%rcx, %rsi	# xu, _81
	shrq	$62, %rsi	#, _81
	negl	%esi	# _82
	shrl	$31, %esi	#, nt
	leaq	0(,%rcx,4), %rdx	#, _84
	xorq	%rcx, %rdx	# xu, _85
	movl	%esi, %edi	# nt, _86
	subq	$1, %rdi	#, _87
	andq	%rdi, %rdx	# _87, _88
	xorq	%rcx, %rdx	# xu, xu
	leal	(%r8,%rsi,2), %edi	#, ex
	movq	%rdx, %rsi	# xu, _91
	shrq	$63, %rsi	#, _91
	leaq	(%rdx,%rdx), %rcx	#, _92
	xorq	%rdx, %rcx	# xu, _93
	leaq	-1(%rsi), %r8	#, _94
	andq	%r8, %rcx	# _94, _95
	xorq	%rcx, %rdx	# _95, xu
# inputs/bootstrap/source/fpr-emulated.c:527: 	xu |= ((uint32_t)xu & 0x1FF) + 0x1FF;
	movq	%rdx, %rcx	# xu, _99
	andl	$511, %ecx	#, _99
	leaq	511(%rcx), %rcx	#, _100
# inputs/bootstrap/source/fpr-emulated.c:527: 	xu |= ((uint32_t)xu & 0x1FF) + 0x1FF;
	orq	%rdx, %rcx	# xu, xu
# inputs/bootstrap/source/fpr-emulated.h:46: 	e += 1076;
	leal	1085(%rdi,%rsi), %edi	#, e
# inputs/bootstrap/source/fpr-emulated.h:47: 	t = (uint32_t)e >> 31;
	movl	%edi, %edx	# e, t_166
	shrl	$31, %edx	#, t_166
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	movl	%edx, %edx	# t_166, _167
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	subq	$1, %rdx	#, _168
# inputs/bootstrap/source/fpr-emulated.c:528: 	xu >>= 9;
	shrq	$9, %rcx	#, xu_150
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	andq	%rcx, %rdx	# xu_150, m
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	salq	$63, %rax	#, _175
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	movq	%rdx, %rcx	# m, _176
	shrq	$2, %rcx	#, _176
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	orq	%rcx, %rax	# _176, _177
# inputs/bootstrap/source/fpr-emulated.h:52: 	f = (unsigned)m & 7U;
	movl	%edx, %ecx	# m, f_183
	andl	$7, %ecx	#, f_183
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	movl	$200, %esi	#, tmp377
	shrl	%cl, %esi	# f_183, _184
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	andl	$1, %esi	#, _186
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	addq	%rsi, %rax	# _186, _191
# inputs/bootstrap/source/fpr-emulated.h:49: 	t = (uint32_t)(m >> 54);
	shrq	$54, %rdx	#, _170
# inputs/bootstrap/source/fpr-emulated.h:50: 	e &= -(int)t;
	negl	%edx	# tmp382
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	andl	%edi, %edx	# e, _179
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	salq	$52, %rdx	#, _180
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	addq	%rdx, %rax	# _180, x_187
# inputs/bootstrap/source/fpr-emulated.c:554: }
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE33:
	.size	fpr_add, .-fpr_add
	.globl	fpr_mul
	.type	fpr_mul, @function
fpr_mul:
.LFB34:
	.cfi_startproc
	movq	%rdi, %rax	# tmp243, x
# inputs/bootstrap/source/fpr-emulated.c:691: 	xu = (x & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	movabsq	$4503599627370495, %rcx	#, tmp187
	movq	%rdi, %rdx	# x, _1
	andq	%rcx, %rdx	# tmp187, _1
# inputs/bootstrap/source/fpr-emulated.c:691: 	xu = (x & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	movabsq	$4503599627370496, %rdi	#, tmp188
	orq	%rdi, %rdx	# tmp188, xu
# inputs/bootstrap/source/fpr-emulated.c:692: 	yu = (y & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	andq	%rsi, %rcx	# y, _2
# inputs/bootstrap/source/fpr-emulated.c:692: 	yu = (y & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	orq	%rdi, %rcx	# tmp188, yu
# inputs/bootstrap/source/fpr-emulated.c:701: 	x1 = (uint32_t)(xu >> 25);
	movq	%rdx, %r8	# xu, _4
	shrq	$25, %r8	#, _4
# inputs/bootstrap/source/fpr-emulated.c:703: 	y1 = (uint32_t)(yu >> 25);
	movq	%rcx, %r9	# yu, _6
	shrq	$25, %r9	#, _6
# inputs/bootstrap/source/fpr-emulated.c:704: 	w = (uint64_t)x0 * (uint64_t)y0;
	andl	$33554431, %edx	#, _7
# inputs/bootstrap/source/fpr-emulated.c:704: 	w = (uint64_t)x0 * (uint64_t)y0;
	andl	$33554431, %ecx	#, _8
# inputs/bootstrap/source/fpr-emulated.c:704: 	w = (uint64_t)x0 * (uint64_t)y0;
	movq	%rdx, %r10	# _7, w
	imulq	%rcx, %r10	# _8, w
# inputs/bootstrap/source/fpr-emulated.c:706: 	z1 = (uint32_t)(w >> 25);
	movq	%r10, %rdi	# w, _10
	shrq	$25, %rdi	#, _10
# inputs/bootstrap/source/fpr-emulated.c:707: 	w = (uint64_t)x0 * (uint64_t)y1;
	imulq	%r9, %rdx	# _6, w
# inputs/bootstrap/source/fpr-emulated.c:708: 	z1 += (uint32_t)w & 0x01FFFFFF;
	movl	%edx, %r11d	# w, _12
	andl	$33554431, %r11d	#, _12
# inputs/bootstrap/source/fpr-emulated.c:708: 	z1 += (uint32_t)w & 0x01FFFFFF;
	addl	%edi, %r11d	# _10, z1
# inputs/bootstrap/source/fpr-emulated.c:709: 	z2 = (uint32_t)(w >> 25);
	movq	%rdx, %rdi	# w, w
	shrq	$25, %rdi	#, w
# inputs/bootstrap/source/fpr-emulated.c:710: 	w = (uint64_t)x1 * (uint64_t)y0;
	imulq	%r8, %rcx	# _4, w
# inputs/bootstrap/source/fpr-emulated.c:711: 	z1 += (uint32_t)w & 0x01FFFFFF;
	movl	%ecx, %edx	# w, _15
	andl	$33554431, %edx	#, _15
# inputs/bootstrap/source/fpr-emulated.c:711: 	z1 += (uint32_t)w & 0x01FFFFFF;
	addl	%r11d, %edx	# z1, z1
# inputs/bootstrap/source/fpr-emulated.c:712: 	z2 += (uint32_t)(w >> 25);
	shrq	$25, %rcx	#, _16
# inputs/bootstrap/source/fpr-emulated.c:712: 	z2 += (uint32_t)(w >> 25);
	addl	%edi, %ecx	# _13, z2
# inputs/bootstrap/source/fpr-emulated.c:713: 	zu = (uint64_t)x1 * (uint64_t)y1;
	imulq	%r9, %r8	# _6, zu
# inputs/bootstrap/source/fpr-emulated.c:714: 	z2 += (z1 >> 25);
	movl	%edx, %edi	# z1, _18
	shrl	$25, %edi	#, _18
# inputs/bootstrap/source/fpr-emulated.c:714: 	z2 += (z1 >> 25);
	addl	%edi, %ecx	# _18, z2_58
# inputs/bootstrap/source/fpr-emulated.c:716: 	zu += z2;
	movl	%ecx, %ecx	# z2_58, _19
	addq	%r8, %rcx	# zu, zu
# inputs/bootstrap/source/fpr-emulated.c:727: 	zu |= ((z0 | z1) + 0x01FFFFFF) >> 25;
	orl	%r10d, %edx	# w, _74
	andl	$33554431, %edx	#, _20
# inputs/bootstrap/source/fpr-emulated.c:727: 	zu |= ((z0 | z1) + 0x01FFFFFF) >> 25;
	addl	$33554431, %edx	#, _21
# inputs/bootstrap/source/fpr-emulated.c:727: 	zu |= ((z0 | z1) + 0x01FFFFFF) >> 25;
	shrl	$25, %edx	#, _22
	movl	%edx, %edx	# _22, _23
# inputs/bootstrap/source/fpr-emulated.c:727: 	zu |= ((z0 | z1) + 0x01FFFFFF) >> 25;
	orq	%rcx, %rdx	# zu, zu
# inputs/bootstrap/source/fpr-emulated.c:734: 	zv = (zu >> 1) | (zu & 1);
	shrq	%rcx	# _24
# inputs/bootstrap/source/fpr-emulated.c:734: 	zv = (zu >> 1) | (zu & 1);
	movq	%rdx, %rdi	# zu, _25
	andl	$1, %edi	#, _25
# inputs/bootstrap/source/fpr-emulated.c:734: 	zv = (zu >> 1) | (zu & 1);
	orq	%rdi, %rcx	# _25, zv
# inputs/bootstrap/source/fpr-emulated.c:735: 	w = zu >> 55;
	movq	%rdx, %rdi	# zu, w
	shrq	$55, %rdi	#, w
# inputs/bootstrap/source/fpr-emulated.c:736: 	zu ^= (zu ^ zv) & -w;
	testb	$1, %dil	#, w
	cmovne	%rcx, %rdx	# zv,, zu
	movq	%rdx, %r8	# zu, zu_63
# inputs/bootstrap/source/fpr-emulated.c:752: 	ex = (int)((x >> 52) & 0x7FF);
	movq	%rax, %rcx	# x, _29
	shrq	$52, %rcx	#, _29
# inputs/bootstrap/source/fpr-emulated.c:752: 	ex = (int)((x >> 52) & 0x7FF);
	andl	$2047, %ecx	#, ex
# inputs/bootstrap/source/fpr-emulated.c:753: 	ey = (int)((y >> 52) & 0x7FF);
	movq	%rsi, %r9	# y, _31
	shrq	$52, %r9	#, _31
# inputs/bootstrap/source/fpr-emulated.c:753: 	ey = (int)((y >> 52) & 0x7FF);
	andl	$2047, %r9d	#, ey
# inputs/bootstrap/source/fpr-emulated.c:754: 	e = ex + ey - 2100 + (int)w;
	leal	-2100(%rcx,%r9), %edx	#, _34
# inputs/bootstrap/source/fpr-emulated.h:46: 	e += 1076;
	leal	1076(%rdx,%rdi), %edi	#, e
# inputs/bootstrap/source/fpr-emulated.c:767: 	d = ((ex + 0x7FF) & (ey + 0x7FF)) >> 11;
	leal	2047(%rcx), %edx	#, _38
# inputs/bootstrap/source/fpr-emulated.c:767: 	d = ((ex + 0x7FF) & (ey + 0x7FF)) >> 11;
	addl	$2047, %r9d	#, _39
# inputs/bootstrap/source/fpr-emulated.c:767: 	d = ((ex + 0x7FF) & (ey + 0x7FF)) >> 11;
	andl	%r9d, %edx	# _39, _40
# inputs/bootstrap/source/fpr-emulated.c:767: 	d = ((ex + 0x7FF) & (ey + 0x7FF)) >> 11;
	sarl	$11, %edx	#, d_68
# inputs/bootstrap/source/fpr-emulated.c:768: 	zu &= -(uint64_t)d;
	movslq	%edx, %rdx	# d_68, _41
# inputs/bootstrap/source/fpr-emulated.c:768: 	zu &= -(uint64_t)d;
	negq	%rdx	# tmp221
	andq	%r8, %rdx	# zu_63, zu_69
# inputs/bootstrap/source/fpr-emulated.h:47: 	t = (uint32_t)e >> 31;
	movl	%edi, %ecx	# e, t_77
	shrl	$31, %ecx	#, t_77
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	movl	%ecx, %ecx	# t_77, _78
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	subq	$1, %rcx	#, _79
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	andq	%rcx, %rdx	# _79, m
# inputs/bootstrap/source/fpr-emulated.c:759: 	s = (int)((x ^ y) >> 63);
	xorq	%rsi, %rax	# y, _36
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	movabsq	$-9223372036854775808, %rcx	#, tmp229
	andq	%rcx, %rax	# tmp229, _86
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	movq	%rdx, %rcx	# m, _87
	shrq	$2, %rcx	#, _87
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	orq	%rcx, %rax	# _87, _88
# inputs/bootstrap/source/fpr-emulated.h:52: 	f = (unsigned)m & 7U;
	movl	%edx, %ecx	# m, f_94
	andl	$7, %ecx	#, f_94
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	movl	$200, %esi	#, tmp234
	shrl	%cl, %esi	# f_94, _95
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	andl	$1, %esi	#, _97
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	addq	%rsi, %rax	# _97, _37
# inputs/bootstrap/source/fpr-emulated.h:49: 	t = (uint32_t)(m >> 54);
	shrq	$54, %rdx	#, _81
# inputs/bootstrap/source/fpr-emulated.h:50: 	e &= -(int)t;
	negl	%edx	# _83
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	andl	%edi, %edx	# e, _90
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	salq	$52, %rdx	#, _91
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	addq	%rdx, %rax	# _91, x_98
# inputs/bootstrap/source/fpr-emulated.c:774: }
	ret	
	.cfi_endproc
.LFE34:
	.size	fpr_mul, .-fpr_mul
	.globl	fpr_div
	.type	fpr_div, @function
fpr_div:
.LFB35:
	.cfi_startproc
	movq	%rsi, %r8	# tmp220, y
# inputs/bootstrap/source/fpr-emulated.c:924: 	xu = (x & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	movabsq	$4503599627370495, %r9	#, tmp169
	movq	%rdi, %rdx	# x, _1
	andq	%r9, %rdx	# tmp169, _1
# inputs/bootstrap/source/fpr-emulated.c:924: 	xu = (x & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	movabsq	$4503599627370496, %rax	#, tmp170
	orq	%rax, %rdx	# tmp170, xu
# inputs/bootstrap/source/fpr-emulated.c:925: 	yu = (y & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	andq	%rsi, %r9	# y, _2
# inputs/bootstrap/source/fpr-emulated.c:925: 	yu = (y & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	orq	%rax, %r9	# tmp170, yu
	movl	$55, %ecx	#, ivtmp_29
# inputs/bootstrap/source/fpr-emulated.c:930: 	q = 0;
	movl	$0, %esi	#, q
	.p2align 6
.L6:
# inputs/bootstrap/source/fpr-emulated.c:939: 		b = ((xu - yu) >> 63) - 1;
	movq	%rdx, %rax	# xu, _3
	subq	%r9, %rax	# yu, _3
# inputs/bootstrap/source/fpr-emulated.c:939: 		b = ((xu - yu) >> 63) - 1;
	shrq	$63, %rax	#, _4
# inputs/bootstrap/source/fpr-emulated.c:939: 		b = ((xu - yu) >> 63) - 1;
	subq	$1, %rax	#, b
# inputs/bootstrap/source/fpr-emulated.c:940: 		xu -= b & yu;
	movq	%r9, %r10	# yu, _5
	andq	%rax, %r10	# b, _5
# inputs/bootstrap/source/fpr-emulated.c:940: 		xu -= b & yu;
	subq	%r10, %rdx	# _5, xu
# inputs/bootstrap/source/fpr-emulated.c:941: 		q |= b & 1;
	andl	$1, %eax	#, _6
# inputs/bootstrap/source/fpr-emulated.c:941: 		q |= b & 1;
	orq	%rsi, %rax	# q, q
# inputs/bootstrap/source/fpr-emulated.c:942: 		xu <<= 1;
	addq	%rdx, %rdx	# xu
# inputs/bootstrap/source/fpr-emulated.c:943: 		q <<= 1;
	leaq	(%rax,%rax), %rsi	#, q
# inputs/bootstrap/source/fpr-emulated.c:931: 	for (i = 0; i < 55; i ++) {
	subl	$1, %ecx	#, ivtmp_29
	jne	.L6	#,
# inputs/bootstrap/source/fpr-emulated.c:951: 	q |= (xu | -xu) >> 63;
	movq	%rdx, %rax	# xu, _7
	negq	%rax	# _7
# inputs/bootstrap/source/fpr-emulated.c:951: 	q |= (xu | -xu) >> 63;
	orq	%rax, %rdx	# _7, _8
# inputs/bootstrap/source/fpr-emulated.c:951: 	q |= (xu | -xu) >> 63;
	shrq	$63, %rdx	#, _9
# inputs/bootstrap/source/fpr-emulated.c:951: 	q |= (xu | -xu) >> 63;
	movq	%rdx, %rcx	# _9, q
	orq	%rsi, %rcx	# q, q
# inputs/bootstrap/source/fpr-emulated.c:961: 	w = q >> 55;
	movq	%rsi, %r9	# q, w
	shrq	$55, %r9	#, w
# inputs/bootstrap/source/fpr-emulated.c:960: 	q2 = (q >> 1) | (q & 1);
	movq	%rsi, %rax	# q, q
	shrq	%rax	# q
# inputs/bootstrap/source/fpr-emulated.c:960: 	q2 = (q >> 1) | (q & 1);
	orq	%rdx, %rax	# _9, q2_36
# inputs/bootstrap/source/fpr-emulated.c:962: 	q ^= (q ^ q2) & -w;
	xorq	%rcx, %rax	# q, _12
# inputs/bootstrap/source/fpr-emulated.c:962: 	q ^= (q ^ q2) & -w;
	movq	%r9, %rdx	# w, _13
	negq	%rdx	# _13
# inputs/bootstrap/source/fpr-emulated.c:962: 	q ^= (q ^ q2) & -w;
	andq	%rdx, %rax	# _13, _14
# inputs/bootstrap/source/fpr-emulated.c:962: 	q ^= (q ^ q2) & -w;
	xorq	%rcx, %rax	# q, q
# inputs/bootstrap/source/fpr-emulated.c:976: 	ex = (int)((x >> 52) & 0x7FF);
	movq	%rdi, %rcx	# x, _15
	shrq	$52, %rcx	#, _15
# inputs/bootstrap/source/fpr-emulated.c:976: 	ex = (int)((x >> 52) & 0x7FF);
	andl	$2047, %ecx	#, ex
# inputs/bootstrap/source/fpr-emulated.c:977: 	ey = (int)((y >> 52) & 0x7FF);
	movq	%r8, %rdx	# y, _17
	shrq	$52, %rdx	#, _17
# inputs/bootstrap/source/fpr-emulated.c:977: 	ey = (int)((y >> 52) & 0x7FF);
	andl	$2047, %edx	#, ey_40
# inputs/bootstrap/source/fpr-emulated.c:978: 	e = ex - ey - 55 + (int)w;
	movl	%ecx, %esi	# ex, _19
	subl	%edx, %esi	# ey_40, _19
# inputs/bootstrap/source/fpr-emulated.c:978: 	e = ex - ey - 55 + (int)w;
	leal	-55(%rsi,%r9), %esi	#, e
# inputs/bootstrap/source/fpr-emulated.c:983: 	s = (int)((x ^ y) >> 63);
	xorq	%r8, %rdi	# y, _22
# inputs/bootstrap/source/fpr-emulated.c:983: 	s = (int)((x ^ y) >> 63);
	shrq	$63, %rdi	#, _23
# inputs/bootstrap/source/fpr-emulated.c:991: 	d = (ex + 0x7FF) >> 11;
	addl	$2047, %ecx	#, _24
# inputs/bootstrap/source/fpr-emulated.c:991: 	d = (ex + 0x7FF) >> 11;
	sarl	$11, %ecx	#, d
# inputs/bootstrap/source/fpr-emulated.c:993: 	e &= -d;
	movl	%ecx, %edx	# d, tmp194
	negl	%edx	# tmp194
	andl	%edx, %esi	# tmp194, e_45
# inputs/bootstrap/source/fpr-emulated.h:46: 	e += 1076;
	addl	$1076, %esi	#, e
# inputs/bootstrap/source/fpr-emulated.h:47: 	t = (uint32_t)e >> 31;
	movl	%esi, %edx	# e, t_57
	shrl	$31, %edx	#, t_57
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	movl	%edx, %edx	# t_57, _58
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	subq	$1, %rdx	#, _59
# inputs/bootstrap/source/fpr-emulated.c:994: 	q &= -(uint64_t)d;
	movslq	%ecx, %r8	# d, _26
# inputs/bootstrap/source/fpr-emulated.c:994: 	q &= -(uint64_t)d;
	negq	%r8	# tmp200
	andq	%r8, %rax	# tmp200, q_46
# inputs/bootstrap/source/fpr-emulated.h:48: 	m &= (uint64_t)t - 1;
	andq	%rax, %rdx	# q_46, m
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	movq	%rdi, %rax	# _23, _23
	andq	%rcx, %rax	# d, _23
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	salq	$63, %rax	#, _66
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	movq	%rdx, %rcx	# m, _67
	shrq	$2, %rcx	#, _67
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	orq	%rcx, %rax	# _67, _68
# inputs/bootstrap/source/fpr-emulated.h:52: 	f = (unsigned)m & 7U;
	movl	%edx, %ecx	# m, f_74
	andl	$7, %ecx	#, f_74
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	movl	$200, %edi	#, tmp210
	shrl	%cl, %edi	# f_74, _75
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	andl	$1, %edi	#, _77
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	addq	%rdi, %rax	# _77, _82
# inputs/bootstrap/source/fpr-emulated.h:49: 	t = (uint32_t)(m >> 54);
	shrq	$54, %rdx	#, _61
# inputs/bootstrap/source/fpr-emulated.h:50: 	e &= -(int)t;
	negl	%edx	# _63
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	andl	%esi, %edx	# e, _70
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	salq	$52, %rdx	#, _71
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	addq	%rdx, %rax	# _71, x_78
# inputs/bootstrap/source/fpr-emulated.c:1000: }
	ret	
	.cfi_endproc
.LFE35:
	.size	fpr_div, .-fpr_div
	.globl	fpr_sqrt
	.type	fpr_sqrt, @function
fpr_sqrt:
.LFB36:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %r10	# tmp182, x
# inputs/bootstrap/source/fpr-emulated.c:1194: 	xu = (x & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	movabsq	$4503599627370495, %rax	#, tmp150
	andq	%rdi, %rax	# x, _1
# inputs/bootstrap/source/fpr-emulated.c:1194: 	xu = (x & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	btsq	$52, %rax	#, xu
# inputs/bootstrap/source/fpr-emulated.c:1195: 	ex = (int)((x >> 52) & 0x7FF);
	shrq	$52, %r10	#, _2
# inputs/bootstrap/source/fpr-emulated.c:1195: 	ex = (int)((x >> 52) & 0x7FF);
	andl	$2047, %r10d	#, ex
# inputs/bootstrap/source/fpr-emulated.c:1196: 	e = ex - 1023;
	leal	-1023(%r10), %r11d	#, e
# inputs/bootstrap/source/fpr-emulated.c:1203: 	xu += xu & -(uint64_t)(e & 1);
	movl	%r11d, %edx	# e, _70
	andl	$1, %edx	#, _70
	leaq	1(%rdx), %rdx	#, _5
	imulq	%rax, %rdx	# xu, xu
# inputs/bootstrap/source/fpr-emulated.c:1204: 	e >>= 1;
	sarl	%r11d	# e
# inputs/bootstrap/source/fpr-emulated.c:1209: 	xu <<= 1;
	addq	%rdx, %rdx	# xu
	movl	$54, %r9d	#, ivtmp_51
# inputs/bootstrap/source/fpr-emulated.c:1219: 	r = (uint64_t)1 << 53;
	movabsq	$9007199254740992, %rcx	#, r
# inputs/bootstrap/source/fpr-emulated.c:1218: 	s = 0;
	movl	$0, %r8d	#, s
# inputs/bootstrap/source/fpr-emulated.c:1217: 	q = 0;
	movl	$0, %ebx	#, q
	.p2align 6
.L9:
# inputs/bootstrap/source/fpr-emulated.c:1223: 		t = s + r;
	leaq	(%r8,%rcx), %rsi	#, t
# inputs/bootstrap/source/fpr-emulated.c:1224: 		b = ((xu - t) >> 63) - 1;
	movq	%rdx, %rax	# xu, _6
	subq	%rsi, %rax	# t, _6
# inputs/bootstrap/source/fpr-emulated.c:1224: 		b = ((xu - t) >> 63) - 1;
	shrq	$63, %rax	#, _7
# inputs/bootstrap/source/fpr-emulated.c:1224: 		b = ((xu - t) >> 63) - 1;
	subq	$1, %rax	#, b
# inputs/bootstrap/source/fpr-emulated.c:1225: 		s += (r << 1) & b;
	leaq	(%rcx,%rcx), %rdi	#, _8
# inputs/bootstrap/source/fpr-emulated.c:1225: 		s += (r << 1) & b;
	andq	%rax, %rdi	# b, _9
# inputs/bootstrap/source/fpr-emulated.c:1225: 		s += (r << 1) & b;
	addq	%rdi, %r8	# _9, s
# inputs/bootstrap/source/fpr-emulated.c:1226: 		xu -= t & b;
	andq	%rax, %rsi	# b, _10
# inputs/bootstrap/source/fpr-emulated.c:1226: 		xu -= t & b;
	subq	%rsi, %rdx	# _10, xu
# inputs/bootstrap/source/fpr-emulated.c:1227: 		q += r & b;
	andq	%rcx, %rax	# r, _11
# inputs/bootstrap/source/fpr-emulated.c:1227: 		q += r & b;
	addq	%rax, %rbx	# _11, q
# inputs/bootstrap/source/fpr-emulated.c:1228: 		xu <<= 1;
	addq	%rdx, %rdx	# xu
# inputs/bootstrap/source/fpr-emulated.c:1229: 		r >>= 1;
	shrq	%rcx	# r
# inputs/bootstrap/source/fpr-emulated.c:1220: 	for (int i = 0; i < 54; i ++) {
	subl	$1, %r9d	#, ivtmp_51
	jne	.L9	#,
# inputs/bootstrap/source/fpr-emulated.c:1238: 	q |= (xu | -xu) >> 63;
	movq	%rdx, %rax	# xu, _12
	negq	%rax	# _12
# inputs/bootstrap/source/fpr-emulated.c:1238: 	q |= (xu | -xu) >> 63;
	orq	%rdx, %rax	# xu, _13
# inputs/bootstrap/source/fpr-emulated.c:1238: 	q |= (xu | -xu) >> 63;
	shrdq	$63, %rbx, %rax	#, q, tmp183
# inputs/bootstrap/source/fpr-emulated.c:1251: 	q &= -(uint64_t)((ex + 0x7FF) >> 11);
	leal	2047(%r10), %edx	#, _15
# inputs/bootstrap/source/fpr-emulated.c:1251: 	q &= -(uint64_t)((ex + 0x7FF) >> 11);
	sarl	$11, %edx	#, _16
# inputs/bootstrap/source/fpr-emulated.c:1251: 	q &= -(uint64_t)((ex + 0x7FF) >> 11);
	movslq	%edx, %rdx	# _16, _17
# inputs/bootstrap/source/fpr-emulated.c:1251: 	q &= -(uint64_t)((ex + 0x7FF) >> 11);
	negq	%rdx	# tmp168
	andq	%rax, %rdx	# q, q
# inputs/bootstrap/source/fpr-emulated.h:46: 	e += 1076;
	addl	$1022, %r11d	#, e
# inputs/bootstrap/source/fpr-emulated.h:52: 	f = (unsigned)m & 7U;
	movl	%edx, %ecx	# q, f_65
	andl	$7, %ecx	#, f_65
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	movl	$200, %eax	#, tmp172
	shrl	%cl, %eax	# f_65, _66
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	andl	$1, %eax	#, _68
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	movq	%rdx, %rcx	# q, _58
	shrq	$2, %rcx	#, _58
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	addq	%rcx, %rax	# _58, _72
# inputs/bootstrap/source/fpr-emulated.h:49: 	t = (uint32_t)(m >> 54);
	shrq	$54, %rdx	#, _52
# inputs/bootstrap/source/fpr-emulated.h:50: 	e &= -(int)t;
	negl	%edx	# _54
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	andl	%r11d, %edx	# e, _61
# inputs/bootstrap/source/fpr-emulated.h:51: 	x = (((uint64_t)s << 63) | (m >> 2)) + ((uint64_t)(uint32_t)e << 52);
	salq	$52, %rdx	#, _62
# inputs/bootstrap/source/fpr-emulated.h:53: 	x += (0xC8U >> f) & 1;
	addq	%rdx, %rax	# _62, x_69
# inputs/bootstrap/source/fpr-emulated.c:1257: }
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE36:
	.size	fpr_sqrt, .-fpr_sqrt
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
