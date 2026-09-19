	.file	"falcon-keygen.c"
# GNU C99 (Debian 14.2.0-19) version 14.2.0 (x86_64-linux-gnu)
#	compiled by GNU C version 14.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.27-GMP

# warning: MPFR header version 4.2.1 differs from library version 4.2.2.
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O -std=c99 -fasynchronous-unwind-tables
	.text
	.type	modp_ninv31, @function
modp_ninv31:
.LFB39:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:2505: 	y = 2 - p;
	movl	$2, %edx	#, tmp114
	movl	%edx, %eax	# tmp114, y
	subl	%edi, %eax	# p, y
# inputs/bootstrap/source/falcon-keygen.c:2506: 	y *= 2 - p * y;
	movl	%edi, %esi	# p, _1
	imull	%eax, %esi	# y, _1
# inputs/bootstrap/source/falcon-keygen.c:2506: 	y *= 2 - p * y;
	movl	%edx, %ecx	# tmp114, _2
	subl	%esi, %ecx	# _1, _2
# inputs/bootstrap/source/falcon-keygen.c:2506: 	y *= 2 - p * y;
	imull	%eax, %ecx	# y, y
# inputs/bootstrap/source/falcon-keygen.c:2507: 	y *= 2 - p * y;
	movl	%edi, %esi	# p, _3
	imull	%ecx, %esi	# y, _3
# inputs/bootstrap/source/falcon-keygen.c:2507: 	y *= 2 - p * y;
	movl	%edx, %eax	# tmp114, _4
	subl	%esi, %eax	# _3, _4
# inputs/bootstrap/source/falcon-keygen.c:2507: 	y *= 2 - p * y;
	imull	%ecx, %eax	# y, y
# inputs/bootstrap/source/falcon-keygen.c:2508: 	y *= 2 - p * y;
	movl	%edi, %esi	# p, _5
	imull	%eax, %esi	# y, _5
# inputs/bootstrap/source/falcon-keygen.c:2508: 	y *= 2 - p * y;
	movl	%edx, %ecx	# tmp114, _6
	subl	%esi, %ecx	# _5, _6
# inputs/bootstrap/source/falcon-keygen.c:2508: 	y *= 2 - p * y;
	imull	%eax, %ecx	# y, y
# inputs/bootstrap/source/falcon-keygen.c:2509: 	y *= 2 - p * y;
	movl	%edi, %eax	# p, p
	imull	%ecx, %eax	# y, p
# inputs/bootstrap/source/falcon-keygen.c:2509: 	y *= 2 - p * y;
	subl	%edx, %eax	# tmp114, y_15
# inputs/bootstrap/source/falcon-keygen.c:2510: 	return (uint32_t)0x7FFFFFFF & -y;
	imull	%ecx, %eax	# y, _9
# inputs/bootstrap/source/falcon-keygen.c:2510: 	return (uint32_t)0x7FFFFFFF & -y;
	andl	$2147483647, %eax	#, _16
# inputs/bootstrap/source/falcon-keygen.c:2511: }
	ret	
	.cfi_endproc
.LFE39:
	.size	modp_ninv31, .-modp_ninv31
	.type	modp_R2, @function
modp_R2:
.LFB44:
	.cfi_startproc
	movl	%edi, %ecx	# tmp228, p
	movl	%esi, %edx	# p0i, tmp229
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	leal	(%rdi,%rdi), %eax	#, _87
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	negl	%eax	# _80
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%edi, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%eax, %esi	# d, _83
	sarl	$31, %esi	#, _83
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%edi, %esi	# p, _85
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%rsi), %edi	#, _64
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %rdi	# _64, powmult_93
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%edx, %edx	# tmp229, _66
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ecx, %esi	# p, _69
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rax	# _66, _67
	imulq	%rdi, %rax	# powmult_93, _67
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _68
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _69, w_70
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# powmult_93, _71
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _72
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ecx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %edi	# d, _76
	sarl	$31, %edi	#, _76
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ecx, %edi	# p, _78
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%rdi), %edi	#, _50
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %rdi	# _50, powmult_92
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rax	# _66, _52
	imulq	%rdi, %rax	# powmult_92, _52
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _53
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _69, w_54
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# powmult_92, _55
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _56
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ecx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %edi	# d, _60
	sarl	$31, %edi	#, _60
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ecx, %edi	# p, _62
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%rdi), %edi	#, _36
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %rdi	# _36, powmult_91
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rax	# _66, _38
	imulq	%rdi, %rax	# powmult_91, _38
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _39
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _69, w_40
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# powmult_91, _41
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _42
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ecx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %edi	# d, _46
	sarl	$31, %edi	#, _46
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ecx, %edi	# p, _48
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%rdi), %edi	#, _22
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %rdi	# _22, powmult_90
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rax	# _66, _24
	imulq	%rdi, %rax	# powmult_90, _24
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _25
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _69, w_26
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# powmult_90, _27
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _28
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ecx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %edi	# d, _32
	sarl	$31, %edi	#, _32
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ecx, %edi	# p, _34
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%rdi), %eax	#, _10
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %rax	# _10, powmult_89
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rdx	# powmult_89, _8
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _6
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rdx	# _69, w_12
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rax, %rdx	# powmult_89, _13
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _14
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ecx, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edx, %eax	# d, _18
	sarl	$31, %eax	#, _18
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ecx, %eax	# p, _20
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %edx	# _20, d
# inputs/bootstrap/source/falcon-keygen.c:2597: 	z = (z + (p & -(z & 1))) >> 1;
	movl	%edx, %eax	# d, tmp225
	andl	$1, %eax	#, tmp225
	negl	%eax	# tmp225
	andl	%ecx, %eax	# p, _2
# inputs/bootstrap/source/falcon-keygen.c:2597: 	z = (z + (p & -(z & 1))) >> 1;
	addl	%edx, %eax	# d, _3
# inputs/bootstrap/source/falcon-keygen.c:2597: 	z = (z + (p & -(z & 1))) >> 1;
	shrl	%eax	# z_11
# inputs/bootstrap/source/falcon-keygen.c:2599: }
	ret	
	.cfi_endproc
.LFE44:
	.size	modp_R2, .-modp_R2
	.type	modp_div, @function
modp_div:
.LFB46:
	.cfi_startproc
	movl	%esi, %r10d	# b, tmp202
# inputs/bootstrap/source/falcon-keygen.c:2645: 	e = p - 2;
	leal	-2(%rdx), %r9d	#, e
# inputs/bootstrap/source/falcon-keygen.c:2647: 	for (i = 30; i >= 0; i --) {
	movl	$30, %eax	#, i
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ecx, %ecx	# tmp204, _31
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%edx, %esi	# p, _34
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r10d, %r10d	# tmp202, _11
	jmp	.L5	#
	.p2align 6
.L4:
# inputs/bootstrap/source/falcon-keygen.c:2647: 	for (i = 30; i >= 0; i --) {
	subl	$1, %eax	#, i
# inputs/bootstrap/source/falcon-keygen.c:2647: 	for (i = 30; i >= 0; i --) {
	cmpl	$-1, %eax	#, i
	je	.L7	#,
.L5:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r8d, %r8d	# R, _29
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r8, %r8	# _29, powmult_78
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %r11	# _31, _32
	imulq	%r8, %r11	# powmult_78, _32
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %r11d	#, _33
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %r11	# _34, w_35
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %r11	# powmult_78, _36
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %r11	#, _37
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%edx, %r11d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r11d, %r8d	# d, _41
	sarl	$31, %r8d	#, _41
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%edx, %r8d	# p, _43
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r11d, %r8d	# d, R
# inputs/bootstrap/source/falcon-keygen.c:2652: 		z ^= (z ^ z2) & -(uint32_t)((e >> i) & 1);
	btl	%eax, %r9d	# i, e
	jnc	.L4	#,
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r8d, %r8d	# R, _13
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r10, %r8	# _11, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r8, %r11	# z, _17
	imulq	%rcx, %r11	# _31, _17
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %r11d	#, _18
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %r11	# _34, w_19
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %r11	# z, _20
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %r11	#, _21
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%edx, %r11d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r11d, %r8d	# d, _25
	sarl	$31, %r8d	#, _25
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%edx, %r8d	# p, _27
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r11d, %r8d	# d, R
	jmp	.L4	#
.L7:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r8d, %r8d	# R, _60
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# _31, _62
	imulq	%r8, %rax	# _60, _62
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _63
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _34, w_65
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rax	# _60, _66
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _67
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%edx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r8d	# d, _71
	sarl	$31, %r8d	#, _71
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%edx, %r8d	# p, _73
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r8), %eax	#, _46
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%edi, %edi	# a, _45
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %rdi	# _46, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# _31, _31
	imulq	%rdi, %rax	# z, _31
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _49
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _34, w_50
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# z, _51
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _52
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%edx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ecx	# d, _56
	sarl	$31, %ecx	#, _56
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ecx, %edx	# _56, _58
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edx, %eax	# _58, d_59
# inputs/bootstrap/source/falcon-keygen.c:2668: }
	ret	
	.cfi_endproc
.LFE46:
	.size	modp_div, .-modp_div
	.type	modp_mkgm2, @function
modp_mkgm2:
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
	subq	$24, %rsp	#,
	.cfi_def_cfa_offset 80
	movq	%rdi, 8(%rsp)	# tmp212, %sfp
	movq	%rsi, %r15	# tmp213, igm
	movl	%edx, %ebp	# tmp214, logn
	movl	%edx, 16(%rsp)	# logn, %sfp
	movl	%ecx, %ebx	# tmp215, g
	movl	%r8d, %r12d	# tmp216, p
	movl	%r9d, %r14d	# tmp217, p0i
	movl	%r9d, 20(%rsp)	# p0i, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2783: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp176
	movl	%edx, %ecx	# logn, tmp222
	salq	%cl, %rax	# tmp222, tmp176
	movq	%rax, (%rsp)	# tmp176, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2789: 	R2 = modp_R2(p, p0i);
	movl	%r9d, %esi	# p0i,
	movl	%r8d, %edi	# p,
	call	modp_R2	#
	movl	%eax, %edi	# tmp218, R2
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %eax	# R2, _31
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ebx	# g, _32
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbx, %rax	# _32, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %r14d	# p0i, _22
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r12d, %r13d	# p, _20
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r14, %rbx	# _22, _21
	imulq	%rax, %rbx	# z, _21
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ebx	#, _34
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r13, %rbx	# _20, w_17
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rax, %rbx	# z, _36
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rbx	#, _37
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r12d, %ebx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ebx, %eax	# d, _41
	sarl	$31, %eax	#, _41
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r12d, %eax	# p, _43
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %ebx	# _43, d
# inputs/bootstrap/source/falcon-keygen.c:2791: 	for (k = logn; k < 10; k ++) {
	cmpl	$9, %ebp	#, logn
	ja	.L9	#,
# inputs/bootstrap/source/falcon-keygen.c:2791: 	for (k = logn; k < 10; k ++) {
	movl	%ebp, %edx	# logn, k
	.p2align 6
.L10:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ebx	# d, _45
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbx, %rbx	# _45, powmult_103
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r14, %rax	# _22, _47
	imulq	%rbx, %rax	# powmult_103, _47
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _48
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r13, %rax	# _20, w_49
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rbx, %rax	# powmult_103, _50
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _51
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r12d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ebx	# d, _55
	sarl	$31, %ebx	#, _55
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r12d, %ebx	# p, _57
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %ebx	# d, d
# inputs/bootstrap/source/falcon-keygen.c:2791: 	for (k = logn; k < 10; k ++) {
	addl	$1, %edx	#, k
# inputs/bootstrap/source/falcon-keygen.c:2791: 	for (k = logn; k < 10; k ++) {
	cmpl	$10, %edx	#, k
	jne	.L10	#,
.L9:
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	movl	$-2147483648, %ebp	#, tmp191
	subl	%r12d, %ebp	# p, x1
# inputs/bootstrap/source/falcon-keygen.c:2795: 	ig = modp_div(R2, g, p, p0i, modp_R(p));
	movl	%ebp, %r8d	# x1,
	movl	20(%rsp), %ecx	# %sfp,
	movl	%r12d, %edx	# p,
	movl	%ebx, %esi	# d,
	call	modp_div	#
# inputs/bootstrap/source/falcon-keygen.c:2796: 	k = 10 - logn;
	movl	$10, %ecx	#, tmp192
	movl	16(%rsp), %esi	# %sfp, logn
	subl	%esi, %ecx	# logn, k
# inputs/bootstrap/source/falcon-keygen.c:2797: 	x1 = x2 = modp_R(p);
	movl	%ebp, %r8d	# x1, x2
# inputs/bootstrap/source/falcon-keygen.c:2798: 	for (u = 0; u < n; u ++) {
	movl	$0, %edx	#, u
# inputs/bootstrap/source/falcon-keygen.c:2801: 		v = REV10[u << k];
	leaq	REV10(%rip), %rdi	#, tmp193
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ebx	# d, _76
	movl	%eax, %esi	# tmp219, _61
.L11:
# inputs/bootstrap/source/falcon-keygen.c:2801: 		v = REV10[u << k];
	movq	%rdx, %rax	# u, _1
	salq	%cl, %rax	# k, _1
# inputs/bootstrap/source/falcon-keygen.c:2801: 		v = REV10[u << k];
	movzwl	(%rdi,%rax,2), %eax	# REV10[_1], v_26
# inputs/bootstrap/source/falcon-keygen.c:2802: 		gm[v] = x1;
	movq	8(%rsp), %r10	# %sfp, gm
	movl	%ebp, (%r10,%rax,4)	# x1, *_4
# inputs/bootstrap/source/falcon-keygen.c:2803: 		igm[v] = x2;
	movl	%r8d, (%r15,%rax,4)	# x2, *_5
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebp, %ebp	# x1, _75
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbx, %rbp	# _76, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r14, %rax	# _22, _78
	imulq	%rbp, %rax	# z, _78
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _79
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r13, %rax	# _20, w_80
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rbp, %rax	# z, _81
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _82
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r12d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ebp	# d, _86
	sarl	$31, %ebp	#, _86
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r12d, %ebp	# p, _88
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %ebp	# d, x1
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r8d, %r8d	# x2, _60
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rsi, %r8	# _61, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r14, %rax	# _22, _63
	imulq	%r8, %rax	# z, _63
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _64
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r13, %rax	# _20, w_65
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rax	# z, _66
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _67
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r12d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r8d	# d, _71
	sarl	$31, %r8d	#, _71
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r12d, %r8d	# p, _73
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %r8d	# d, x2
# inputs/bootstrap/source/falcon-keygen.c:2798: 	for (u = 0; u < n; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:2798: 	for (u = 0; u < n; u ++) {
	cmpq	%rdx, (%rsp)	# u, %sfp
	jne	.L11	#,
# inputs/bootstrap/source/falcon-keygen.c:2807: }
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
.LFE47:
	.size	modp_mkgm2, .-modp_mkgm2
	.type	modp_NTT2_ext, @function
modp_NTT2_ext:
.LFB48:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:2819: 	if (logn == 0) {
	testl	%ecx, %ecx	# logn
	je	.L26	#,
# inputs/bootstrap/source/falcon-keygen.c:2816: {
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
# inputs/bootstrap/source/falcon-keygen.c:2822: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp157
	salq	%cl, %rax	# logn, tmp157
	movq	%rax, %rcx	# tmp157, n
# inputs/bootstrap/source/falcon-keygen.c:2836: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	leaq	0(,%rsi,4), %r13	#, _9
# inputs/bootstrap/source/falcon-keygen.c:2824: 	for (m = 1; m < n; m <<= 1) {
	movl	$1, %r11d	#, m
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r9d, %r14d	# p0i, _58
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r8d, %r15d	# p, _61
	movq	%rax, -24(%rsp)	# n, %sfp
	movq	%r11, %rax	# m, m
	movq	%rcx, %r9	# t, t
	movq	%rdi, -16(%rsp)	# a, %sfp
	movq	%rsi, -8(%rsp)	# stride, %sfp
	jmp	.L21	#
.L17:
# inputs/bootstrap/source/falcon-keygen.c:2824: 	for (m = 1; m < n; m <<= 1) {
	addq	%rax, %rax	# m
.L22:
# inputs/bootstrap/source/falcon-keygen.c:2816: {
	movq	%rbx, %r9	# ht, t
.L21:
# inputs/bootstrap/source/falcon-keygen.c:2827: 		ht = t >> 1;
	movq	%r9, %rbx	# t, ht
	shrq	%rbx	# ht
# inputs/bootstrap/source/falcon-keygen.c:2828: 		for (u = 0, v1 = 0; u < m; u ++, v1 += t) {
	testq	%rax, %rax	# m
	je	.L17	#,
# inputs/bootstrap/source/falcon-keygen.c:2835: 			r2 = r1 + ht * stride;
	movq	-8(%rsp), %rcx	# %sfp, _4
	imulq	%rbx, %rcx	# ht, _4
	salq	$2, %rcx	#, _7
	leaq	(%rdx,%rax,4), %r12	#, ivtmp.244
	imulq	%r13, %r9	# _9, _77
	movq	-16(%rsp), %rbp	# %sfp, ivtmp.245
	leaq	(%rdx,%rax,8), %rdi	#, _75
	movq	%rdi, -48(%rsp)	# _75, %sfp
	movq	%rcx, -40(%rsp)	# _7, %sfp
	movq	%rax, -32(%rsp)	# m, %sfp
	movq	%rdx, %rax	# gm, gm
.L20:
# inputs/bootstrap/source/falcon-keygen.c:2833: 			s = gm[m + u];
	movl	(%r12), %r11d	# MEM[(const uint32_t *)_78], s
# inputs/bootstrap/source/falcon-keygen.c:2834: 			r1 = a + v1 * stride;
	movq	%rbp, %rsi	# ivtmp.245, r1
# inputs/bootstrap/source/falcon-keygen.c:2835: 			r2 = r1 + ht * stride;
	movq	-40(%rsp), %rdi	# %sfp, _7
	addq	%rbp, %rdi	# ivtmp.245, r2
# inputs/bootstrap/source/falcon-keygen.c:2836: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	testq	%rbx, %rbx	# ht
	je	.L18	#,
# inputs/bootstrap/source/falcon-keygen.c:2836: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	movl	$0, %r10d	#, v
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r11d, %r11d	# s, _56
	movq	%r12, -64(%rsp)	# ivtmp.244, %sfp
	movq	%rbp, -56(%rsp)	# ivtmp.245, %sfp
.L19:
# inputs/bootstrap/source/falcon-keygen.c:2839: 				x = *r1;
	movl	(%rsi), %ecx	# MEM[(uint32_t *)r1_87], x
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdi), %ebp	# MEM[(uint32_t *)r2_88], _55
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r11, %rbp	# _56, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r14, %rdx	# _58, _59
	imulq	%rbp, %rdx	# z, _59
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _60
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r15, %rdx	# _61, w_62
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rbp, %rdx	# z, _63
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _64
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r8d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edx, %ebp	# d, _68
	sarl	$31, %ebp	#, _68
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r8d, %ebp	# p, _70
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ebp, %edx	# _70, d
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	movl	%ecx, %ebp	# x, _11
	subl	%r8d, %ebp	# p, _11
	addl	%edx, %ebp	# d, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%ebp, %r12d	# d, _51
	sarl	$31, %r12d	#, _51
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r8d, %r12d	# p, _53
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%r12d, %ebp	# _53, tmp173
	movl	%ebp, (%rsi)	# tmp173, MEM[(uint32_t *)r1_87]
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%edx, %ecx	# d, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%ecx, %edx	# d, _37
	sarl	$31, %edx	#, _37
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%r8d, %edx	# p, _46
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	addl	%edx, %ecx	# _46, tmp175
	movl	%ecx, (%rdi)	# tmp175, MEM[(uint32_t *)r2_88]
# inputs/bootstrap/source/falcon-keygen.c:2836: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	addq	$1, %r10	#, v
# inputs/bootstrap/source/falcon-keygen.c:2836: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	addq	%r13, %rsi	# _9, r1
# inputs/bootstrap/source/falcon-keygen.c:2836: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	addq	%r13, %rdi	# _9, r2
# inputs/bootstrap/source/falcon-keygen.c:2836: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	cmpq	%r10, %rbx	# v, ht
	jne	.L19	#,
	movq	-64(%rsp), %r12	# %sfp, ivtmp.244
	movq	-56(%rsp), %rbp	# %sfp, ivtmp.245
.L18:
# inputs/bootstrap/source/falcon-keygen.c:2828: 		for (u = 0, v1 = 0; u < m; u ++, v1 += t) {
	addq	$4, %r12	#, ivtmp.244
	addq	%r9, %rbp	# _77, ivtmp.245
	movq	-48(%rsp), %rsi	# %sfp, _75
	cmpq	%rsi, %r12	# _75, ivtmp.244
	jne	.L20	#,
# inputs/bootstrap/source/falcon-keygen.c:2824: 	for (m = 1; m < n; m <<= 1) {
	movq	%rax, %rdx	# gm, gm
	movq	-32(%rsp), %rax	# %sfp, m
	addq	%rax, %rax	# m
# inputs/bootstrap/source/falcon-keygen.c:2824: 	for (m = 1; m < n; m <<= 1) {
	movq	-24(%rsp), %rsi	# %sfp, n
	cmpq	%rsi, %rax	# n, m
	jb	.L22	#,
# inputs/bootstrap/source/falcon-keygen.c:2847: }
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
.L26:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	ret	
	.cfi_endproc
.LFE48:
	.size	modp_NTT2_ext, .-modp_NTT2_ext
	.type	modp_iNTT2_ext, @function
modp_iNTT2_ext:
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
	movq	%rdi, -32(%rsp)	# tmp213, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2860: 	if (logn == 0) {
	testl	%ecx, %ecx	# logn
	je	.L29	#,
	movq	%rsi, %r10	# tmp214, stride
	movq	%rdx, %rsi	# tmp215, igm
# inputs/bootstrap/source/falcon-keygen.c:2863: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp177
	salq	%cl, %rax	# logn, tmp177
# inputs/bootstrap/source/falcon-keygen.c:2878: 			for (v = 0; v < t; v ++, r1 += stride, r2 += stride) {
	leaq	0(,%r10,4), %r14	#, _8
# inputs/bootstrap/source/falcon-keygen.c:2864: 	t = 1;
	movl	$1, %edi	#, dt
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r9d, %r13d	# p0i, _47
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r8d, %r15d	# p, _57
	movq	%rax, -16(%rsp)	# n, %sfp
	movq	%rax, %rdx	# m, m
	movq	%r10, -24(%rsp)	# stride, %sfp
	movl	%ecx, -4(%rsp)	# logn, %sfp
	movq	%rdi, %rcx	# dt, dt
.L34:
# inputs/bootstrap/source/falcon-keygen.c:2868: 		hm = m >> 1;
	shrq	%rdx	# m
	movq	%rcx, %rbx	# dt, t
# inputs/bootstrap/source/falcon-keygen.c:2869: 		dt = t << 1;
	addq	%rcx, %rcx	# dt
# inputs/bootstrap/source/falcon-keygen.c:2877: 			r2 = r1 + t * stride;
	movq	-24(%rsp), %rax	# %sfp, _4
	imulq	%rbx, %rax	# t, _4
	salq	$2, %rax	#, _7
	movq	%rax, -72(%rsp)	# _7, %sfp
	leaq	(%rsi,%rdx,4), %r12	#, ivtmp.272
	movq	%r14, %rdi	# _8, _20
	imulq	%rcx, %rdi	# dt, _20
	movq	-32(%rsp), %rbp	# %sfp, ivtmp.273
	leaq	(%rsi,%rdx,8), %rax	#, _106
	movq	%rdi, -64(%rsp)	# _20, %sfp
	movq	%rdx, -56(%rsp)	# m, %sfp
	movq	%rcx, -48(%rsp)	# dt, %sfp
	movq	%rax, %rdi	# _106, _106
	movq	%rsi, -40(%rsp)	# igm, %sfp
	movl	%r9d, %eax	# p0i, p0i
.L33:
# inputs/bootstrap/source/falcon-keygen.c:2875: 			s = igm[hm + u];
	movl	(%r12), %r11d	# MEM[(const uint32_t *)_18], s
# inputs/bootstrap/source/falcon-keygen.c:2876: 			r1 = a + v1 * stride;
	movq	%rbp, %rcx	# ivtmp.273, r1
# inputs/bootstrap/source/falcon-keygen.c:2877: 			r2 = r1 + t * stride;
	movq	-72(%rsp), %rsi	# %sfp, _7
	addq	%rbp, %rsi	# ivtmp.273, r2
# inputs/bootstrap/source/falcon-keygen.c:2878: 			for (v = 0; v < t; v ++, r1 += stride, r2 += stride) {
	testq	%rbx, %rbx	# t
	je	.L31	#,
# inputs/bootstrap/source/falcon-keygen.c:2878: 			for (v = 0; v < t; v ++, r1 += stride, r2 += stride) {
	movl	$0, %r9d	#, v
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r11d, %r11d	# s, _50
	movq	%r12, -88(%rsp)	# ivtmp.272, %sfp
	movq	%rbp, -80(%rsp)	# ivtmp.273, %sfp
.L32:
# inputs/bootstrap/source/falcon-keygen.c:2881: 				x = *r1;
	movl	(%rcx), %r10d	# MEM[(uint32_t *)r1_118], x
# inputs/bootstrap/source/falcon-keygen.c:2882: 				y = *r2;
	movl	(%rsi), %r12d	# MEM[(uint32_t *)r2_119], y
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	leal	(%r10,%r12), %edx	#, _74
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%r8d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%edx, %ebp	# d, _77
	sarl	$31, %ebp	#, _77
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r8d, %ebp	# p, _79
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%ebp, %edx	# _79, tmp183
	movl	%edx, (%rcx)	# tmp183, MEM[(uint32_t *)r1_118]
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%r12d, %r10d	# y, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%r10d, %edx	# d, _70
	sarl	$31, %edx	#, _70
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%r8d, %edx	# p, _72
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%r10,%rdx), %r10d	#, _32
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r11, %r10	# _50, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rdx	# _47, _55
	imulq	%r10, %rdx	# z, _55
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _56
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r15, %rdx	# _57, w_58
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rdx	# z, _59
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _60
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r8d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edx, %r10d	# d, _64
	sarl	$31, %r10d	#, _64
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r8d, %r10d	# p, _66
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r10d, %edx	# _66, tmp196
	movl	%edx, (%rsi)	# tmp196, MEM[(uint32_t *)r2_119]
# inputs/bootstrap/source/falcon-keygen.c:2878: 			for (v = 0; v < t; v ++, r1 += stride, r2 += stride) {
	addq	$1, %r9	#, v
# inputs/bootstrap/source/falcon-keygen.c:2878: 			for (v = 0; v < t; v ++, r1 += stride, r2 += stride) {
	addq	%r14, %rcx	# _8, r1
# inputs/bootstrap/source/falcon-keygen.c:2878: 			for (v = 0; v < t; v ++, r1 += stride, r2 += stride) {
	addq	%r14, %rsi	# _8, r2
# inputs/bootstrap/source/falcon-keygen.c:2878: 			for (v = 0; v < t; v ++, r1 += stride, r2 += stride) {
	cmpq	%rbx, %r9	# t, v
	jne	.L32	#,
	movq	-88(%rsp), %r12	# %sfp, ivtmp.272
	movq	-80(%rsp), %rbp	# %sfp, ivtmp.273
.L31:
# inputs/bootstrap/source/falcon-keygen.c:2870: 		for (u = 0, v1 = 0; u < hm; u ++, v1 += dt) {
	addq	$4, %r12	#, ivtmp.272
	movq	-64(%rsp), %rcx	# %sfp, _20
	addq	%rcx, %rbp	# _20, ivtmp.273
	cmpq	%rdi, %r12	# _106, ivtmp.272
	jne	.L33	#,
# inputs/bootstrap/source/falcon-keygen.c:2865: 	for (m = n; m > 1; m >>= 1) {
	movq	-56(%rsp), %rdx	# %sfp, m
	movq	-48(%rsp), %rcx	# %sfp, dt
	movq	-40(%rsp), %rsi	# %sfp, igm
	movl	%eax, %r9d	# p0i, p0i
	cmpq	$1, %rdx	#, m
	ja	.L34	#,
# inputs/bootstrap/source/falcon-keygen.c:2898: 	for (k = 0, r = a; k < n; k ++, r += stride) {
	movl	-4(%rsp), %ecx	# %sfp, logn
	movl	%eax, %r11d	# p0i, p0i
	movq	-16(%rsp), %r9	# %sfp, n
	movl	$0, %edx	#, k
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	$-2147483648, %eax	#, tmp197
	movl	%eax, %edi	# tmp197, _82
	shrl	%cl, %edi	# logn, _82
	movq	%rdi, %rcx	# _82, _82
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r11d, %r10d	# p0i, _84
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r8d, %esi	# p, _87
	movq	-32(%rsp), %rdi	# %sfp, a
	.p2align 6
.L35:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdi), %r11d	# MEM[(uint32_t *)r_114], _81
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %r11	# _82, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r10, %rax	# _84, _85
	imulq	%r11, %rax	# z, _85
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _86
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _87, w_88
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r11, %rax	# z, _89
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _90
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r8d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r11d	# d, _94
	sarl	$31, %r11d	#, _94
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r8d, %r11d	# p, _96
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r11d, %eax	# _96, tmp208
	movl	%eax, (%rdi)	# tmp208, MEM[(uint32_t *)r_114]
# inputs/bootstrap/source/falcon-keygen.c:2898: 	for (k = 0, r = a; k < n; k ++, r += stride) {
	addq	$1, %rdx	#, k
# inputs/bootstrap/source/falcon-keygen.c:2898: 	for (k = 0, r = a; k < n; k ++, r += stride) {
	addq	%r14, %rdi	# _8, a
# inputs/bootstrap/source/falcon-keygen.c:2898: 	for (k = 0, r = a; k < n; k ++, r += stride) {
	cmpq	%rdx, %r9	# k, n
	jne	.L35	#,
.L29:
# inputs/bootstrap/source/falcon-keygen.c:2901: }
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
	.size	modp_iNTT2_ext, .-modp_iNTT2_ext
	.type	modp_mkgm3, @function
modp_mkgm3:
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
	subq	$40, %rsp	#,
	.cfi_def_cfa_offset 96
	movq	%rdi, %r14	# tmp560, gm
	movq	%rsi, %r15	# tmp561, igm
	movl	%edx, 8(%rsp)	# tmp562, %sfp
	movl	%ecx, 20(%rsp)	# tmp563, %sfp
	movl	%r8d, %ebx	# tmp564, g
	movl	%r9d, %ebp	# tmp565, p
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	movl	$-2147483648, %eax	#, tmp407
	subl	%r9d, %eax	# p, tmp407
	movl	%eax, 16(%rsp)	# tmp407, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2950: 	R2 = modp_R2(p, p0i);
	movl	96(%rsp), %esi	# p0i,
	movl	%r9d, %edi	# p,
	call	modp_R2	#
	movl	%eax, 12(%rsp)	# R2, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %eax	# R2, _96
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ebx	# g, _97
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %rbx	# _96, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	96(%rsp), %r13d	# p0i, _102
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebp, %r12d	# p, _88
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# z, _100
	imulq	%r13, %rax	# _102, _100
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _89
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rax	# _88, w_87
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rbx, %rax	# z, _86
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _77
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ebx	# d, _65
	sarl	$31, %ebx	#, _65
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %ebx	# p, _63
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %ebx	# d, x
# inputs/bootstrap/source/falcon-keygen.c:2958: 	k = logn;
	movl	8(%rsp), %esi	# %sfp, logn
	movl	%esi, %eax	# logn, k
# inputs/bootstrap/source/falcon-keygen.c:2959: 	if (!full) {
	cmpl	$0, 20(%rsp)	#, %sfp
	jne	.L42	#,
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ebx	# x, _118
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	%rbx, %rdx	# _118, powmult_365
	imulq	%rbx, %rdx	# _118, powmult_365
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rax	# _102, _120
	imulq	%rdx, %rax	# powmult_365, _120
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _121
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rax	# _88, w_122
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %rax	# powmult_365, _123
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _124
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %edx	# p, _130
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%rdx), %eax	#, _105
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbx, %rax	# _118, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rax, %rbx	# z, _54
	imulq	%r13, %rbx	# _102, _54
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ebx	#, _51
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rbx	# _88, w_108
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rax, %rbx	# z, _109
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rbx	#, _110
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %ebx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ebx, %eax	# d, _114
	sarl	$31, %eax	#, _114
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %eax	# p, _116
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %ebx	# _116, x
# inputs/bootstrap/source/falcon-keygen.c:2961: 		k ++;
	leal	1(%rsi), %eax	#, k
.L42:
# inputs/bootstrap/source/falcon-keygen.c:2963: 	while (k ++ < 11) {
	leal	1(%rax), %edx	#, k
# inputs/bootstrap/source/falcon-keygen.c:2963: 	while (k ++ < 11) {
	cmpl	$10, %eax	#, k
	ja	.L43	#,
	.p2align 6
.L44:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ebx	# x, _132
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbx, %rbx	# _132, powmult_364
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rax	# _102, _134
	imulq	%rbx, %rax	# powmult_364, _134
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _135
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rax	# _88, w_136
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rbx, %rax	# powmult_364, _137
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _138
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ebx	# d, _142
	sarl	$31, %ebx	#, _142
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %ebx	# p, _144
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %ebx	# d, x
# inputs/bootstrap/source/falcon-keygen.c:2963: 	while (k ++ < 11) {
	addl	$1, %edx	#, k
# inputs/bootstrap/source/falcon-keygen.c:2963: 	while (k ++ < 11) {
	cmpl	$12, %edx	#, k
	jne	.L44	#,
.L43:
# inputs/bootstrap/source/falcon-keygen.c:2966: 	ig = modp_div(R2, g, p, p0i, modp_R(p));
	movl	16(%rsp), %r8d	# %sfp,
	movl	96(%rsp), %ecx	# p0i,
	movl	%ebp, %edx	# p,
	movl	%ebx, %esi	# x,
	movl	12(%rsp), %edi	# %sfp,
	call	modp_div	#
# inputs/bootstrap/source/falcon-keygen.c:2971: 	if (logn == 1) {
	cmpl	$1, 8(%rsp)	#, %sfp
	je	.L61	#,
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ecx	# x, _188
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rcx	# _188, powmult_363
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rdx	# _102, _190
	imulq	%rcx, %rdx	# powmult_363, _190
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _191
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rdx	# _88, w_192
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rdx	# powmult_363, _193
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _194
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edx, %ecx	# d, _198
	sarl	$31, %ecx	#, _198
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %ecx	# p, _200
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rdx,%rcx), %ecx	#, _174
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	%rcx, 24(%rsp)	# _174, %sfp
	imulq	%rcx, %rcx	# _174, powmult_368
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rdx	# _102, _176
	imulq	%rcx, %rdx	# powmult_368, _176
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _177
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rdx	# _88, w_178
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rdx	# powmult_368, _179
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _180
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	movl	%edx, %r10d	# _180, d
	subl	%ebp, %r10d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r10d, %edx	# d, _184
	sarl	$31, %edx	#, _184
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %edx	# p, _184
	movl	%edx, 32(%rsp)	# _184, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %ecx	# ix, _160
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rcx	# _160, powmult_367
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rdx	# _102, _162
	imulq	%rcx, %rdx	# powmult_367, _162
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _163
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rdx	# _88, w_164
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rdx	# powmult_367, _165
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _166
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edx, %ecx	# d, _170
	sarl	$31, %ecx	#, _170
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %ecx	# p, _172
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rdx,%rcx), %ecx	#, _146
	movq	%rcx, (%rsp)	# _146, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rcx	# _146, powmult_35
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rdx	# powmult_35, _148
	imulq	%r13, %rdx	# _102, _148
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _149
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rdx	# _88, w_150
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rdx	# powmult_35, _151
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _152
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	movl	%edx, %edi	# _152, d
	subl	%ebp, %edi	# p, d
	movl	%edi, %r11d	# d, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edi, %r9d	# d, _156
	sarl	$31, %r9d	#, _156
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %r9d	# p, _158
# inputs/bootstrap/source/falcon-keygen.c:2984: 		k = 11 - logn;
	movl	$11, %edi	#, tmp463
	movl	8(%rsp), %r8d	# %sfp, logn
	subl	%r8d, %edi	# logn, k
# inputs/bootstrap/source/falcon-keygen.c:2985: 		b = (size_t)1 << (logn - 1);
	subl	$1, %r8d	#, _1
	movl	%r8d, 36(%rsp)	# _1, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2985: 		b = (size_t)1 << (logn - 1);
	movl	$1, %esi	#, tmp464
	movl	%r8d, %ecx	# _1, tmp640
	salq	%cl, %rsi	# tmp640, b
# inputs/bootstrap/source/falcon-keygen.c:2986: 		for (u = 0; u < b; u += 2) {
	movl	$0, %edx	#, u
# inputs/bootstrap/source/falcon-keygen.c:2987: 			gm[b + REV10[u << k]] = x;
	leaq	REV10(%rip), %r8	#, tmp465
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	32(%rsp), %ecx	# %sfp, _186
	leal	(%r10,%rcx), %r10d	#, _246
	leal	(%r11,%r9), %r9d	#, _231
	movl	%edi, %ecx	# k, k
	movq	24(%rsp), %r11	# %sfp, _174
.L48:
# inputs/bootstrap/source/falcon-keygen.c:2987: 			gm[b + REV10[u << k]] = x;
	movq	%rdx, %rdi	# u, _2
	salq	%cl, %rdi	# k, _2
# inputs/bootstrap/source/falcon-keygen.c:2987: 			gm[b + REV10[u << k]] = x;
	movzwl	(%r8,%rdi,2), %edi	# REV10[_2], _4
# inputs/bootstrap/source/falcon-keygen.c:2987: 			gm[b + REV10[u << k]] = x;
	addq	%rsi, %rdi	# b, _5
# inputs/bootstrap/source/falcon-keygen.c:2987: 			gm[b + REV10[u << k]] = x;
	movl	%ebx, (%r14,%rdi,4)	# x, *_7
# inputs/bootstrap/source/falcon-keygen.c:2988: 			igm[b + REV10[u << k]] = ix;
	movl	%eax, (%r15,%rdi,4)	# ix, *_8
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ebx	# x, _245
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r10, %rbx	# _246, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rdi	# _102, _248
	imulq	%rbx, %rdi	# z, _248
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edi	#, _249
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rdi	# _88, w_250
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rbx	# w_250, _251
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rbx	#, _252
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %ebx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ebx, %edi	# d, _256
	sarl	$31, %edi	#, _256
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %edi	# p, _258
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edi, %ebx	# _258, d
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %eax	# ix, _230
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r9, %rax	# _231, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rdi	# _102, _233
	imulq	%rax, %rdi	# z, _233
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edi	#, _234
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rdi	# _88, w_235
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# w_235, _236
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _237
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %edi	# d, _241
	sarl	$31, %edi	#, _241
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %edi	# p, _243
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edi, %eax	# _243, d
# inputs/bootstrap/source/falcon-keygen.c:2991: 			gm[b + REV10[(u + 1) << k]] = x;
	leaq	1(%rdx), %rdi	#, _9
# inputs/bootstrap/source/falcon-keygen.c:2991: 			gm[b + REV10[(u + 1) << k]] = x;
	salq	%cl, %rdi	# k, _10
# inputs/bootstrap/source/falcon-keygen.c:2991: 			gm[b + REV10[(u + 1) << k]] = x;
	movzwl	(%r8,%rdi,2), %edi	# REV10[_10], _12
# inputs/bootstrap/source/falcon-keygen.c:2991: 			gm[b + REV10[(u + 1) << k]] = x;
	addq	%rsi, %rdi	# b, _13
# inputs/bootstrap/source/falcon-keygen.c:2991: 			gm[b + REV10[(u + 1) << k]] = x;
	movl	%ebx, (%r14,%rdi,4)	# d, *_15
# inputs/bootstrap/source/falcon-keygen.c:2992: 			igm[b + REV10[(u + 1) << k]] = ix;
	movl	%eax, (%r15,%rdi,4)	# d, *_16
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ebx	# d, _216
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r11, %rbx	# _174, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rdi	# _102, _218
	imulq	%rbx, %rdi	# z, _218
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edi	#, _219
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rdi	# _88, w_220
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rbx	# w_220, _221
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rbx	#, _222
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %ebx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ebx, %edi	# d, _226
	sarl	$31, %edi	#, _226
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %edi	# p, _228
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edi, %ebx	# _228, x
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %eax	# d, _202
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	(%rsp), %rdi	# %sfp, _146
	imulq	%rdi, %rax	# _146, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rdi	# _102, _204
	imulq	%rax, %rdi	# z, _204
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edi	#, _205
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rdi	# _88, w_206
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# w_206, _207
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _208
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %edi	# d, _212
	sarl	$31, %edi	#, _212
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %edi	# p, _214
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edi, %eax	# _214, ix
# inputs/bootstrap/source/falcon-keygen.c:2986: 		for (u = 0; u < b; u += 2) {
	addq	$2, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:2986: 		for (u = 0; u < b; u += 2) {
	cmpq	%rsi, %rdx	# b, u
	jb	.L48	#,
# inputs/bootstrap/source/falcon-keygen.c:3003: 	if (full) {
	cmpl	$0, 20(%rsp)	#, %sfp
	jne	.L62	#,
# inputs/bootstrap/source/falcon-keygen.c:3022: 	for (u = ((size_t)1 << k) - 1; u > 0; u --) {
	movl	$1, %edx	#, tmp559
	movzbl	36(%rsp), %ecx	# %sfp, tmp674
	salq	%cl, %rdx	# tmp674, _303
# inputs/bootstrap/source/falcon-keygen.c:3022: 	for (u = ((size_t)1 << k) - 1; u > 0; u --) {
	subq	$1, %rdx	#, u
	jmp	.L52	#
.L61:
# inputs/bootstrap/source/falcon-keygen.c:2972: 		gm[1] = g;
	movl	%ebx, 4(%r14)	# x, MEM[(uint32_t *)gm_68(D) + 4B]
# inputs/bootstrap/source/falcon-keygen.c:2973: 		igm[1] = ig;
	movl	%eax, 4(%r15)	# ix, MEM[(uint32_t *)igm_70(D) + 4B]
# inputs/bootstrap/source/falcon-keygen.c:3003: 	if (full) {
	cmpl	$0, 20(%rsp)	#, %sfp
	je	.L46	#,
# inputs/bootstrap/source/falcon-keygen.c:3004: 		k --;
	movl	8(%rsp), %esi	# %sfp, logn
	subl	$2, %esi	#, logn
# inputs/bootstrap/source/falcon-keygen.c:3005: 		for (u = (size_t)1 << k; u < ((size_t)1 << (k + 1)); u ++) {
	movl	$1, %edx	#, tmp436
	movl	%esi, %ecx	# k, tmp619
	salq	%cl, %rdx	# tmp619, u
# inputs/bootstrap/source/falcon-keygen.c:3005: 		for (u = (size_t)1 << k; u < ((size_t)1 << (k + 1)); u ++) {
	movl	$1, %edi	#, _29
.L51:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r14,%rdx,8), %ecx	# MEM[(uint32_t *)gm_68(D) + u_373 * 8], _302
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	%rcx, %r8	# _302, powmult_39
	imulq	%rcx, %r8	# _302, powmult_39
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r8, %rax	# powmult_39, _304
	imulq	%r13, %rax	# _102, _304
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _305
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rax	# _88, w_306
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rax	# powmult_39, _307
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _308
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r8d	# d, _312
	sarl	$31, %r8d	#, _312
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %r8d	# p, _314
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r8), %eax	#, _288
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rax	# _302, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rcx	# _102, _290
	imulq	%rax, %rcx	# z, _290
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _291
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rcx	# _88, w_292
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rax, %rcx	# z, _293
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _294
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %r8d	# d, _298
	sarl	$31, %r8d	#, _298
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %r8d	# p, _300
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r15,%rdx,8), %r9d	# MEM[(uint32_t *)igm_70(D) + u_373 * 8], _274
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	%r9, %r10	# _274, powmult_366
	imulq	%r9, %r10	# _274, powmult_366
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rax	# _102, _276
	imulq	%r10, %rax	# powmult_366, _276
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _277
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rax	# _88, w_278
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rax	# powmult_366, _279
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _280
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _284
	sarl	$31, %r10d	#, _284
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %r10d	# p, _286
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r10), %eax	#, _260
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r9	# _260, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rax	# _102, _262
	imulq	%r9, %rax	# z, _262
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _263
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rax	# _88, w_264
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _265
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _266
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _270
	sarl	$31, %r9d	#, _270
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %r9d	# p, _272
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r8d, %ecx	# _300, tmp534
	movl	%ecx, (%r14,%rdx,4)	# tmp534, MEM[(uint32_t *)gm_68(D) + u_373 * 4]
	addl	%r9d, %eax	# _272, tmp535
	movl	%eax, (%r15,%rdx,4)	# tmp535, MEM[(uint32_t *)igm_70(D) + u_373 * 4]
# inputs/bootstrap/source/falcon-keygen.c:3005: 		for (u = (size_t)1 << k; u < ((size_t)1 << (k + 1)); u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3005: 		for (u = (size_t)1 << k; u < ((size_t)1 << (k + 1)); u ++) {
	cmpq	%rdx, %rdi	# u, _29
	jne	.L51	#,
.L50:
# inputs/bootstrap/source/falcon-keygen.c:3022: 	for (u = ((size_t)1 << k) - 1; u > 0; u --) {
	movl	$1, %edx	#, tmp537
	movl	%esi, %ecx	# k, tmp667
	salq	%cl, %rdx	# tmp667, _24
# inputs/bootstrap/source/falcon-keygen.c:3022: 	for (u = ((size_t)1 << k) - 1; u > 0; u --) {
	subq	$1, %rdx	#, u
	je	.L46	#,
.L52:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r14,%rdx,8), %ecx	# MEM[(uint32_t *)gm_68(D) + u_374 * 8], _330
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rcx	# _330, powmult_36
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# powmult_36, _332
	imulq	%r13, %rax	# _102, _332
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _333
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rax	# _88, w_334
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rax	# powmult_36, _335
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _336
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ecx	# d, _340
	sarl	$31, %ecx	#, _340
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %ecx	# p, _342
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ecx, %eax	# _342, tmp544
	movl	%eax, (%r14,%rdx,4)	# tmp544, MEM[(uint32_t *)gm_68(D) + u_374 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r15,%rdx,8), %ecx	# MEM[(uint32_t *)igm_70(D) + u_374 * 8], _316
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rcx	# _316, powmult_41
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# powmult_41, _318
	imulq	%r13, %rax	# _102, _318
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _319
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r12, %rax	# _88, w_320
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rax	# powmult_41, _321
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _322
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebp, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ecx	# d, _326
	sarl	$31, %ecx	#, _326
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebp, %ecx	# p, _328
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ecx, %eax	# _328, tmp551
	movl	%eax, (%r15,%rdx,4)	# tmp551, MEM[(uint32_t *)igm_70(D) + u_374 * 4]
# inputs/bootstrap/source/falcon-keygen.c:3022: 	for (u = ((size_t)1 << k) - 1; u > 0; u --) {
	subq	$1, %rdx	#, u
	jne	.L52	#,
.L46:
# inputs/bootstrap/source/falcon-keygen.c:3033: 	gm[0] = gm[1];
	movl	4(%r14), %edx	# MEM[(uint32_t *)gm_68(D) + 4B], _33
	movl	%edx, (%r14)	# _33, *gm_68(D)
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%edx, %edx	# _350
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	movl	%edx, %eax	# _350, d_351
	subl	%ebp, %eax	# p, d_351
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	sarl	$31, %eax	#, _353
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%ebp, %eax	# p, _355
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	leal	-2147483648(%rdx,%rax), %esi	#, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%esi, %eax	# d, _346
	sarl	$31, %eax	#, _346
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%ebp, %eax	# p, _348
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	addl	%eax, %esi	# _348, d_349
# inputs/bootstrap/source/falcon-keygen.c:3035: 	igm[0] = modp_div(R2, modp_sub(modp_add(w, w, p), R, p), p, p0i, R);
	movl	16(%rsp), %r8d	# %sfp,
	movl	96(%rsp), %ecx	# p0i,
	movl	%ebp, %edx	# p,
	movl	12(%rsp), %edi	# %sfp,
	call	modp_div	#
# inputs/bootstrap/source/falcon-keygen.c:3035: 	igm[0] = modp_div(R2, modp_sub(modp_add(w, w, p), R, p), p, p0i, R);
	movl	%eax, (%r15)	# tmp568, *igm_70(D)
# inputs/bootstrap/source/falcon-keygen.c:3036: }
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
.L62:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:3004: 		k --;
	movl	8(%rsp), %esi	# %sfp, logn
	subl	$2, %esi	#, logn
# inputs/bootstrap/source/falcon-keygen.c:3005: 		for (u = (size_t)1 << k; u < ((size_t)1 << (k + 1)); u ++) {
	movl	$1, %edi	#, tmp504
	movq	%rdi, %rdx	# tmp504, u
	movl	%esi, %ecx	# k, tmp655
	salq	%cl, %rdx	# tmp655, u
# inputs/bootstrap/source/falcon-keygen.c:3005: 		for (u = (size_t)1 << k; u < ((size_t)1 << (k + 1)); u ++) {
	movzbl	36(%rsp), %ecx	# %sfp, tmp656
	salq	%cl, %rdi	# tmp656, _29
# inputs/bootstrap/source/falcon-keygen.c:3005: 		for (u = (size_t)1 << k; u < ((size_t)1 << (k + 1)); u ++) {
	cmpq	%rdi, %rdx	# _29, u
	jb	.L51	#,
	jmp	.L50	#
	.cfi_endproc
.LFE50:
	.size	modp_mkgm3, .-modp_mkgm3
	.type	modp_NTT3_ext, @function
modp_NTT3_ext:
.LFB51:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:3050: 	if (logn == 0) {
	testl	%ecx, %ecx	# logn
	je	.L79	#,
# inputs/bootstrap/source/falcon-keygen.c:3045: {
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
	movl	%ecx, %r12d	# tmp496, logn
	movl	%r8d, %ebx	# tmp497, full
# inputs/bootstrap/source/falcon-keygen.c:3053: 	n = MKN(logn, full);
	leal	1(%r8,%r8), %eax	#, _3
	movq	%rax, -24(%rsp)	# _3, %sfp
	subl	%r8d, %ecx	# full, _4
# inputs/bootstrap/source/falcon-keygen.c:3053: 	n = MKN(logn, full);
	salq	%cl, %rax	# _4, n
	movq	%rax, -16(%rsp)	# n, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3054: 	hn = n >> 1;
	shrq	%rax	# hn
	movq	%rax, %r15	# hn, hn
# inputs/bootstrap/source/falcon-keygen.c:3066: 	w = gm[1];
	movl	4(%rdx), %eax	# MEM[(const uint32_t *)gm_48(D) + 4B], w
	leaq	0(,%rsi,4), %r11	#, _10
# inputs/bootstrap/source/falcon-keygen.c:3067: 	for (u = 0, r1 = a, r2 = a + hn * stride;
	movq	%r11, %r8	# _10, _6
	imulq	%r15, %r8	# hn, _6
# inputs/bootstrap/source/falcon-keygen.c:3067: 	for (u = 0, r1 = a, r2 = a + hn * stride;
	addq	%rdi, %r8	# a, r2
# inputs/bootstrap/source/falcon-keygen.c:3068: 		u < hn; u ++, r1 += stride, r2 += stride)
	testq	%r15, %r15	# hn
	je	.L65	#,
# inputs/bootstrap/source/falcon-keygen.c:3067: 	for (u = 0, r1 = a, r2 = a + hn * stride;
	movq	%rdi, %r10	# a, r1
# inputs/bootstrap/source/falcon-keygen.c:3067: 	for (u = 0, r1 = a, r2 = a + hn * stride;
	movl	$0, %ebp	#, u
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %eax	# w, _109
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	56(%rsp), %r14d	# p0i, _111
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r9d, %r13d	# p, _114
	movq	%rdi, -80(%rsp)	# a, %sfp
	movq	%rsi, -72(%rsp)	# stride, %sfp
	movq	%rdx, -64(%rsp)	# gm, %sfp
	movl	%r12d, -56(%rsp)	# logn, %sfp
	movq	%rax, %r12	# _109, _109
.L66:
# inputs/bootstrap/source/falcon-keygen.c:3072: 		a0 = *r1;
	movl	(%r10), %edx	# MEM[(uint32_t *)r1_336], a0
# inputs/bootstrap/source/falcon-keygen.c:3073: 		a1 = *r2;
	movl	(%r8), %edi	# MEM[(uint32_t *)r2_339], a1
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%edi, %ecx	# a1, _100
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r12, %rcx	# _109, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# z, _112
	imulq	%r14, %rax	# _111, _112
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _113
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r13, %rax	# _114, w_115
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rax	# z, _116
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _117
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ecx	# d, _121
	sarl	$31, %ecx	#, _121
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %ecx	# p, _123
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ecx, %eax	# _123, d
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	movl	%edx, %ecx	# a0, _324
	subl	%r9d, %ecx	# p, _324
	addl	%eax, %ecx	# d, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%ecx, %esi	# d, _90
	sarl	$31, %esi	#, _90
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r9d, %esi	# p, _103
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%esi, %ecx	# _103, tmp386
	movl	%ecx, (%r10)	# tmp386, MEM[(uint32_t *)r1_336]
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%edi, %edx	# a1, _68
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%r9d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%edx, %ecx	# d, _65
	sarl	$31, %ecx	#, _65
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r9d, %ecx	# p, _63
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%edx, %ecx	# d, d_59
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%eax, %ecx	# d, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%ecx, %eax	# d, _73
	sarl	$31, %eax	#, _73
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%r9d, %eax	# p, _70
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	addl	%ecx, %eax	# d, tmp391
	movl	%eax, (%r8)	# tmp391, MEM[(uint32_t *)r2_339]
# inputs/bootstrap/source/falcon-keygen.c:3068: 		u < hn; u ++, r1 += stride, r2 += stride)
	addq	$1, %rbp	#, u
# inputs/bootstrap/source/falcon-keygen.c:3068: 		u < hn; u ++, r1 += stride, r2 += stride)
	addq	%r11, %r10	# _10, r1
# inputs/bootstrap/source/falcon-keygen.c:3068: 		u < hn; u ++, r1 += stride, r2 += stride)
	addq	%r11, %r8	# _10, r2
# inputs/bootstrap/source/falcon-keygen.c:3068: 		u < hn; u ++, r1 += stride, r2 += stride)
	cmpq	%rbp, %r15	# u, hn
	jne	.L66	#,
# inputs/bootstrap/source/falcon-keygen.c:3083: 	for (m = 2; t > (1 + (full << 1)); m <<= 1) {
	movq	-80(%rsp), %rdi	# %sfp, a
	movq	-72(%rsp), %rsi	# %sfp, stride
	movq	-64(%rsp), %rdx	# %sfp, gm
	movl	-56(%rsp), %r12d	# %sfp, logn
	cmpq	%r15, -24(%rsp)	# hn, %sfp
	jnb	.L65	#,
# inputs/bootstrap/source/falcon-keygen.c:3083: 	for (m = 2; t > (1 + (full << 1)); m <<= 1) {
	movl	$2, %r8d	#, m
	movq	%r8, -40(%rsp)	# m, %sfp
	movq	%rdi, -32(%rsp)	# a, %sfp
	movl	%r12d, -8(%rsp)	# logn, %sfp
	movl	%ebx, -4(%rsp)	# full, %sfp
	jmp	.L71	#
	.p2align 5
.L67:
# inputs/bootstrap/source/falcon-keygen.c:3083: 	for (m = 2; t > (1 + (full << 1)); m <<= 1) {
	salq	-40(%rsp)	# %sfp
# inputs/bootstrap/source/falcon-keygen.c:3083: 	for (m = 2; t > (1 + (full << 1)); m <<= 1) {
	cmpq	%r15, -24(%rsp)	# hn, %sfp
	jnb	.L82	#,
.L71:
	movq	%r15, %r8	# hn, t
# inputs/bootstrap/source/falcon-keygen.c:3086: 		ht = t >> 1;
	shrq	%r15	# hn
# inputs/bootstrap/source/falcon-keygen.c:3087: 		for (u1 = 0, v1 = 0; u1 < m; u1 ++, v1 += t) {
	movq	-40(%rsp), %rax	# %sfp, m
	testq	%rax, %rax	# m
	je	.L67	#,
# inputs/bootstrap/source/falcon-keygen.c:3093: 			r2 = r1 + ht * stride;
	movq	%rsi, %rcx	# stride, _27
	imulq	%r15, %rcx	# hn, _27
	salq	$2, %rcx	#, _14
	leaq	(%rdx,%rax,4), %r12	#, ivtmp.354
	imulq	%r11, %r8	# _10, _269
	movq	-32(%rsp), %rbp	# %sfp, ivtmp.355
	leaq	(%rdx,%rax,8), %rax	#, _192
	movq	%rax, -56(%rsp)	# _192, %sfp
	movq	%rcx, -64(%rsp)	# _14, %sfp
	movq	%r8, -48(%rsp)	# _269, %sfp
	movq	%rsi, %rax	# stride, stride
	movq	%rdx, %rcx	# gm, gm
.L70:
# inputs/bootstrap/source/falcon-keygen.c:3091: 			s = gm[m + u1];
	movl	(%r12), %ebx	# MEM[(const uint32_t *)_206], s
# inputs/bootstrap/source/falcon-keygen.c:3092: 			r1 = a + v1 * stride;
	movq	%rbp, %rsi	# ivtmp.355, r1
# inputs/bootstrap/source/falcon-keygen.c:3093: 			r2 = r1 + ht * stride;
	movq	-64(%rsp), %rdi	# %sfp, _14
	addq	%rbp, %rdi	# ivtmp.355, r2
# inputs/bootstrap/source/falcon-keygen.c:3094: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	testq	%r15, %r15	# hn
	je	.L68	#,
# inputs/bootstrap/source/falcon-keygen.c:3094: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	movl	$0, %r10d	#, v
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ebx	# s, _139
	movq	%rbp, -80(%rsp)	# ivtmp.355, %sfp
	movq	%r12, -72(%rsp)	# ivtmp.354, %sfp
.L69:
# inputs/bootstrap/source/falcon-keygen.c:3097: 				x = *r1;
	movl	(%rsi), %r8d	# MEM[(uint32_t *)r1_337], x
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdi), %ebp	# MEM[(uint32_t *)r2_340], _138
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbx, %rbp	# _139, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r14, %rdx	# _111, _142
	imulq	%rbp, %rdx	# z, _142
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _143
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r13, %rdx	# _114, w_145
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rbp, %rdx	# z, _146
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _147
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edx, %ebp	# d, _151
	sarl	$31, %ebp	#, _151
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %ebp	# p, _153
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ebp, %edx	# _153, d
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	movl	%r8d, %ebp	# x, _328
	subl	%r9d, %ebp	# p, _328
	addl	%edx, %ebp	# d, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%ebp, %r12d	# d, _134
	sarl	$31, %r12d	#, _134
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r9d, %r12d	# p, _136
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%r12d, %ebp	# _136, tmp405
	movl	%ebp, (%rsi)	# tmp405, MEM[(uint32_t *)r1_337]
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%edx, %r8d	# d, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%r8d, %edx	# d, _127
	sarl	$31, %edx	#, _127
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%r9d, %edx	# p, _129
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	addl	%edx, %r8d	# _129, tmp407
	movl	%r8d, (%rdi)	# tmp407, MEM[(uint32_t *)r2_340]
# inputs/bootstrap/source/falcon-keygen.c:3094: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	addq	$1, %r10	#, v
# inputs/bootstrap/source/falcon-keygen.c:3094: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	addq	%r11, %rsi	# _10, r1
# inputs/bootstrap/source/falcon-keygen.c:3094: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	addq	%r11, %rdi	# _10, r2
# inputs/bootstrap/source/falcon-keygen.c:3094: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	cmpq	%r10, %r15	# v, hn
	jne	.L69	#,
# inputs/bootstrap/source/falcon-keygen.c:3087: 		for (u1 = 0, v1 = 0; u1 < m; u1 ++, v1 += t) {
	movq	-80(%rsp), %rbp	# %sfp, ivtmp.355
	movq	-72(%rsp), %r12	# %sfp, ivtmp.354
	addq	$4, %r12	#, ivtmp.354
	movq	-48(%rsp), %rbx	# %sfp, _269
	addq	%rbx, %rbp	# _269, ivtmp.355
	movq	-56(%rsp), %rbx	# %sfp, _192
	cmpq	%rbx, %r12	# _192, ivtmp.354
	jne	.L70	#,
	movq	%rax, %rsi	# stride, stride
	movq	%rcx, %rdx	# gm, gm
	jmp	.L67	#
.L82:
	movq	-32(%rsp), %rdi	# %sfp, a
	movl	-8(%rsp), %r12d	# %sfp, logn
	movl	-4(%rsp), %ebx	# %sfp, full
	jmp	.L65	#
.L68:
	addq	$4, %r12	#, ivtmp.354
	movq	-48(%rsp), %rbx	# %sfp, _269
	addq	%rbx, %rbp	# _269, ivtmp.355
	movq	-56(%rsp), %rbx	# %sfp, _192
	cmpq	%rbx, %r12	# _192, ivtmp.354
	jne	.L70	#,
	movq	-32(%rsp), %rdi	# %sfp, a
	movq	%rax, %rsi	# stride, stride
	movq	%rcx, %rdx	# gm, gm
	movl	-8(%rsp), %r12d	# %sfp, logn
	movl	-4(%rsp), %ebx	# %sfp, full
.L65:
# inputs/bootstrap/source/falcon-keygen.c:3110: 	if (full) {
	testl	%ebx, %ebx	# full
	je	.L63	#,
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%rdx), %ecx	# MEM[(const uint32_t *)gm_48(D) + 4B], _155
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rcx	# _155, powmult_327
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	56(%rsp), %r11d	# p0i, _157
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r9d, %ebx	# p, _160
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# _157, _158
	imulq	%rcx, %rax	# powmult_327, _158
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _159
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rbx, %rax	# _160, w_161
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rax	# powmult_327, _162
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _163
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ecx	# d, _167
	sarl	$31, %ecx	#, _167
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %ecx	# p, _169
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ecx, %eax	# _169, d
# inputs/bootstrap/source/falcon-keygen.c:3112: 		for (u = 0, r = (size_t)1 << (logn - 1), r1 = a;
	leal	-1(%r12), %ecx	#, _17
# inputs/bootstrap/source/falcon-keygen.c:3113: 			u < n; u += 3, r ++, r1 += 3 * stride)
	cmpq	$0, -16(%rsp)	#, %sfp
	je	.L63	#,
# inputs/bootstrap/source/falcon-keygen.c:3113: 			u < n; u += 3, r ++, r1 += 3 * stride)
	leaq	(%rsi,%rsi,2), %r8	#, _24
	leaq	0(,%r8,4), %r14	#, tmp417
	movq	%r14, -80(%rsp)	# tmp417, %sfp
	movl	$4, %r8d	#, tmp419
	salq	%cl, %r8	# _17, _41
	leaq	(%rdx,%r8), %r12	#, ivtmp.338
# inputs/bootstrap/source/falcon-keygen.c:3112: 		for (u = 0, r = (size_t)1 << (logn - 1), r1 = a;
	movl	$0, %r13d	#, u
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %ebp	# d, _271
.L72:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r12), %ecx	# MEM[(const uint32_t *)_28], _299
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	%rcx, %rdx	# _299, powmult_330
	imulq	%rcx, %rdx	# _299, powmult_330
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# _157, _301
	imulq	%rdx, %rax	# powmult_330, _301
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _302
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rbx, %rax	# _160, w_303
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %rax	# powmult_330, _304
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _305
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r8d	# d, _309
	sarl	$31, %r8d	#, _309
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %r8d	# p, _311
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdi,%rsi,4), %edx	# MEM[(uint32_t *)r1_338 + stride_52(D) * 4], _285
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rdx	# _299, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %r14	# _157, _287
	imulq	%rdx, %r14	# z, _287
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %r14d	#, _288
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rbx, %r14	# _160, w_289
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %r14	# z, _290
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %r14	#, _291
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %r14d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r14d, %edx	# d, _295
	sarl	$31, %edx	#, _295
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %edx	# p, _297
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edx, %r14d	# _297, d
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r14d, %edx	# d, _270
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbp, %rdx	# _271, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rcx	# _157, _273
	imulq	%rdx, %rcx	# z, _273
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _274
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rbx, %rcx	# _160, w_275
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %rcx	# z, _276
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _277
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %edx	# d, _281
	sarl	$31, %edx	#, _281
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %edx	# p, _283
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edx, %ecx	# _283, d
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ecx, %r10d	# d, _256
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbp, %r10	# _271, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rdx	# _157, _258
	imulq	%r10, %rdx	# z, _258
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _259
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rbx, %rdx	# _160, w_260
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %r10	# w_260, _261
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %r10	#, _262
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %r10d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdi,%rsi,8), %edx	# MEM[(uint32_t *)r1_338 + stride_52(D) * 8], _241
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r8), %eax	#, _242
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %rdx	# _242, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# _157, _244
	imulq	%rdx, %rax	# z, _244
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _245
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rbx, %rax	# _160, w_246
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %rax	# z, _247
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _248
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %edx	# p, _254
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edx, %eax	# _254, d
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %r8d	# d, _227
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbp, %r8	# _271, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rdx	# _157, _229
	imulq	%r8, %rdx	# z, _229
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _230
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rbx, %rdx	# _160, w_231
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %r8	# w_231, _232
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %r8	#, _233
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %r8d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r8d, %edx	# d, _237
	sarl	$31, %edx	#, _237
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %edx	# p, _239
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edx, %r8d	# _239, d
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r8d, %r15d	# d, _213
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbp, %r15	# _271, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rdx	# _157, _215
	imulq	%r15, %rdx	# z, _215
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _216
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rbx, %rdx	# _160, w_217
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r15, %rdx	# z, _218
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _219
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%r9d, %r14d	# p, _25
	addl	%r14d, %eax	# _25, d
	movl	(%rdi), %r14d	# MEM[(uint32_t *)r1_338], _33
	subl	%r9d, %r14d	# p, _33
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%eax, %r15d	# d, _209
	sarl	$31, %r15d	#, _209
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r9d, %r15d	# p, _211
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%r14d, %eax	# _33, _30
	addl	%r15d, %eax	# _211, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%eax, %r15d	# d, _202
	sarl	$31, %r15d	#, _202
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r9d, %r15d	# p, _204
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%r15d, %eax	# _204, tmp474
	movl	%eax, (%rdi)	# tmp474, MEM[(uint32_t *)r1_338]
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%r9d, %ecx	# p, _322
	addl	%edx, %ecx	# d, _38
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	sarl	$31, %edx	#, _223
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %edx	# p, _225
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	leal	(%rcx,%rdx), %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r9d, %edx	# p, _197
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%r14d, %eax	# _33, _326
	addl	%edx, %eax	# _197, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r9d, %edx	# p, _190
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%edx, %eax	# _190, tmp483
	movl	%eax, (%rdi,%rsi,4)	# tmp483, MEM[(uint32_t *)r1_338 + stride_52(D) * 4]
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r10d, %edx	# d, _266
	sarl	$31, %edx	#, _266
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %edx	# p, _268
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%r9d, %r10d	# p, _37
	addl	%r10d, %edx	# _37, _34
	addl	%r8d, %edx	# d, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%edx, %eax	# d, _181
	sarl	$31, %eax	#, _181
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r9d, %eax	# p, _183
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%edx, %r14d	# d, _39
	addl	%r14d, %eax	# _39, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r9d, %edx	# p, _176
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%edx, %eax	# _176, tmp492
	movl	%eax, (%rdi,%rsi,8)	# tmp492, MEM[(uint32_t *)r1_338 + stride_52(D) * 8]
# inputs/bootstrap/source/falcon-keygen.c:3113: 			u < n; u += 3, r ++, r1 += 3 * stride)
	addq	$3, %r13	#, u
# inputs/bootstrap/source/falcon-keygen.c:3113: 			u < n; u += 3, r ++, r1 += 3 * stride)
	movq	-80(%rsp), %rax	# %sfp, tmp417
	addq	%rax, %rdi	# tmp417, a
# inputs/bootstrap/source/falcon-keygen.c:3113: 			u < n; u += 3, r ++, r1 += 3 * stride)
	addq	$4, %r12	#, ivtmp.338
	movq	-16(%rsp), %rax	# %sfp, n
	cmpq	%rax, %r13	# n, u
	jb	.L72	#,
.L63:
# inputs/bootstrap/source/falcon-keygen.c:3137: }
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
.L79:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	ret	
	.cfi_endproc
.LFE51:
	.size	modp_NTT3_ext, .-modp_NTT3_ext
	.type	modp_iNTT3_ext, @function
modp_iNTT3_ext:
.LFB52:
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
	movq	%rdi, 56(%rsp)	# a, %sfp
	movq	%rsi, 64(%rsp)	# stride, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3150: 	if (logn == 0) {
	testl	%ecx, %ecx	# logn
	je	.L83	#,
	movq	%rdi, %r12	# tmp571, a
	movq	%rsi, %r13	# tmp572, stride
	movq	%rdx, %rsi	# tmp573, igm
	movl	%ecx, %edx	# tmp574, logn
	movl	%r8d, %ebp	# tmp575, full
	movl	%r9d, %r15d	# tmp576, p
# inputs/bootstrap/source/falcon-keygen.c:3153: 	n = MKN(logn, full);
	movl	%ecx, %ebx	# logn, _4
	subl	%r8d, %ebx	# full, _4
	leal	1(%r8,%r8), %eax	#, _3
# inputs/bootstrap/source/falcon-keygen.c:3153: 	n = MKN(logn, full);
	movl	%ebx, %ecx	# _4, tmp645
	salq	%cl, %rax	# tmp645, _3
	movq	%rax, %r14	# _3, n
	movq	%rax, 32(%rsp)	# n, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3154: 	hn = n >> 1;
	movq	%rax, %r8	# n, hn
	shrq	%r8	# hn
# inputs/bootstrap/source/falcon-keygen.c:3165: 	if (full) {
	testl	%ebp, %ebp	# full
	je	.L85	#,
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%rsi), %eax	# MEM[(const uint32_t *)igm_59(D) + 4B], _93
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %rax	# _93, powmult_373
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	144(%rsp), %r11d	# p0i, _104
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r9d, %r10d	# p, _100
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rcx	# _104, _102
	imulq	%rax, %rcx	# powmult_373, _102
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _101
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r10, %rcx	# _100, w_99
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rax, %rcx	# powmult_373, _122
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _121
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r9d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %eax	# d, _80
	sarl	$31, %eax	#, _80
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r9d, %eax	# p, _77
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ecx, %eax	# d, d
# inputs/bootstrap/source/falcon-keygen.c:3167: 		for (u = 0, r = (size_t)1 << (logn - 1), r1 = a;
	subl	$1, %edx	#, _6
# inputs/bootstrap/source/falcon-keygen.c:3168: 			u < n; u += 3, r ++, r1 += 3 * stride)
	testq	%r14, %r14	# n
	je	.L86	#,
# inputs/bootstrap/source/falcon-keygen.c:3168: 			u < n; u += 3, r ++, r1 += 3 * stride)
	leaq	0(%r13,%r13,2), %rcx	#, _13
	leaq	0(,%rcx,4), %rdi	#, tmp425
	movq	%rdi, 24(%rsp)	# tmp425, %sfp
	movl	$4, %r9d	#, tmp427
	movl	%edx, %ecx	# _6, tmp652
	salq	%cl, %r9	# tmp652, _149
	leaq	(%rsi,%r9), %rdi	#, ivtmp.413
# inputs/bootstrap/source/falcon-keygen.c:3167: 		for (u = 0, r = (size_t)1 << (logn - 1), r1 = a;
	movq	%r12, %r9	# a, r1
# inputs/bootstrap/source/falcon-keygen.c:3167: 		for (u = 0, r = (size_t)1 << (logn - 1), r1 = a;
	movq	$0, (%rsp)	#, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %r14d	# d, _235
	movl	%ebx, 40(%rsp)	# _4, %sfp
	movq	%r8, 48(%rsp)	# hn, %sfp
	movq	%rsi, 72(%rsp)	# igm, %sfp
	movl	%ebp, 84(%rsp)	# full, %sfp
	movq	%r13, %rbp	# stride, stride
.L87:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdi), %r12d	# MEM[(const uint32_t *)_20], _249
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	%r12, %rdx	# _249, powmult_372
	imulq	%r12, %rdx	# _249, powmult_372
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# _104, _251
	imulq	%rdx, %rax	# powmult_372, _251
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _252
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r10, %rax	# _100, w_253
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	leaq	(%rax,%rdx), %rsi	#, _254
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rsi	#, _255
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %esi	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%esi, %eax	# d, _259
	sarl	$31, %eax	#, _259
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %eax	# p, _259
	movl	%eax, 16(%rsp)	# _259, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3176: 			f1 = *(r1 + stride);
	movl	(%r9,%rbp,4), %ebx	# MEM[(uint32_t *)r1_381 + stride_67(D) * 4], f1
# inputs/bootstrap/source/falcon-keygen.c:3177: 			f2 = *(r1 + 2 * stride);
	movl	(%r9,%rbp,8), %r13d	# MEM[(uint32_t *)r1_381 + stride_67(D) * 8], f2
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %edx	# f1, _234
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r14, %rdx	# _235, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# _104, _237
	imulq	%rdx, %rax	# z, _237
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _238
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r10, %rax	# _100, w_239
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rax, %rdx	# w_239, _240
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _241
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edx, %eax	# d, _245
	sarl	$31, %eax	#, _245
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %eax	# p, _247
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %edx	# _247, d
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%edx, %ecx	# d, _220
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r14, %rcx	# _235, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# _104, _222
	imulq	%rcx, %rax	# z, _222
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _223
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r10, %rax	# _100, w_224
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	leaq	(%rax,%rcx), %r8	#, _225
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %r8	#, _226
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %r8d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r13d, %ecx	# f2, _206
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r14, %rcx	# _235, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# _104, _208
	imulq	%rcx, %rax	# z, _208
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _209
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r10, %rax	# _100, w_210
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rax	# z, _211
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _212
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ecx	# d, _216
	sarl	$31, %ecx	#, _216
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %ecx	# p, _218
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ecx, %eax	# _218, d
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, 8(%rsp)	# d, %sfp
	movl	%eax, %ecx	#, _192
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r14, %rcx	# _235, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# _104, _194
	imulq	%rcx, %rax	# z, _194
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _195
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r10, %rax	# _100, w_196
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rax	# z, _197
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _198
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	leal	(%rbx,%r13), %ecx	#, _185
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%r15d, %ecx	# p, d
	movl	(%r9), %ebx	# MEM[(uint32_t *)r1_381], _374
	subl	%r15d, %ebx	# p, _374
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%ecx, %r13d	# d, _188
	sarl	$31, %r13d	#, _188
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r15d, %r13d	# p, _190
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%ebx, %ecx	# _374, _371
	addl	%r13d, %ecx	# _190, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%ecx, %r13d	# d, _181
	sarl	$31, %r13d	#, _181
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r15d, %r13d	# p, _183
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%r13d, %ecx	# _183, tmp466
	movl	%ecx, (%r9)	# tmp466, MEM[(uint32_t *)r1_381]
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%r15d, %edx	# p, _34
	addl	%eax, %edx	# d, _31
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	sarl	$31, %eax	#, _202
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %eax	# p, _204
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%edx, %eax	# _31, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r15d, %edx	# p, _176
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%ebx, %eax	# _374, _37
	addl	%edx, %eax	# _176, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r15d, %edx	# p, _169
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%rdx), %edx	#, _150
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r12, %rdx	# _249, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rcx	# _104, _152
	imulq	%rdx, %rcx	# z, _152
	movq	%rcx, %rax	# _152, _152
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _153
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r10, %rax	# _100, w_154
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %rax	# z, _155
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _156
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %edx	# p, _162
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edx, %eax	# _162, tmp483
	movl	%eax, (%r9,%rbp,4)	# tmp483, MEM[(uint32_t *)r1_381 + stride_67(D) * 4]
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r8d, %ecx	# d, _230
	sarl	$31, %ecx	#, _230
	movl	%ecx, %eax	# _230, _230
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %eax	# p, _232
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	movl	8(%rsp), %edx	# %sfp, d
	subl	%r15d, %edx	# p, d
	addl	%r8d, %edx	# d, _363
	addl	%edx, %eax	# _363, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r15d, %edx	# p, _148
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%ebx, %eax	# _374, _370
	addl	%edx, %eax	# _148, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r15d, %edx	# p, _141
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%rdx), %eax	#, _73
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	16(%rsp), %ebx	# %sfp, _261
	leal	(%rsi,%rbx), %edx	#, _74
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %rdx	# _73, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rax	# z, _71
	imulq	%r11, %rax	# _104, _71
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _70
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r10, %rax	# _100, w_62
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %rax	# z, _127
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _128
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %edx	# p, _134
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edx, %eax	# _134, tmp502
	movl	%eax, (%r9,%rbp,8)	# tmp502, MEM[(uint32_t *)r1_381 + stride_67(D) * 8]
# inputs/bootstrap/source/falcon-keygen.c:3168: 			u < n; u += 3, r ++, r1 += 3 * stride)
	addq	$3, (%rsp)	#, %sfp
	movq	(%rsp), %rax	# %sfp, u
# inputs/bootstrap/source/falcon-keygen.c:3168: 			u < n; u += 3, r ++, r1 += 3 * stride)
	movq	24(%rsp), %rbx	# %sfp, tmp425
	addq	%rbx, %r9	# tmp425, r1
# inputs/bootstrap/source/falcon-keygen.c:3168: 			u < n; u += 3, r ++, r1 += 3 * stride)
	addq	$4, %rdi	#, ivtmp.413
	movq	32(%rsp), %rbx	# %sfp, n
	cmpq	%rbx, %rax	# n, u
	jb	.L87	#,
	movl	40(%rsp), %ebx	# %sfp, _4
	movq	48(%rsp), %r8	# %sfp, hn
	movq	72(%rsp), %rsi	# %sfp, igm
	movl	84(%rsp), %ebp	# %sfp, full
.L85:
# inputs/bootstrap/source/falcon-keygen.c:3195: 	t = 2 + (full << 2);
	leal	2(,%rbp,4), %eax	#, _15
# inputs/bootstrap/source/falcon-keygen.c:3195: 	t = 2 + (full << 2);
	movl	%eax, %edx	# _15, t
# inputs/bootstrap/source/falcon-keygen.c:3196: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	leal	-1(%rbx), %ecx	#, _16
# inputs/bootstrap/source/falcon-keygen.c:3196: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	movl	$1, %eax	#, tmp506
	salq	%cl, %rax	# _16, m
# inputs/bootstrap/source/falcon-keygen.c:3196: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	movq	32(%rsp), %rdi	# %sfp, n
	cmpq	%rdi, %rdx	# n, t
	jnb	.L88	#,
# inputs/bootstrap/source/falcon-keygen.c:3207: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	movq	64(%rsp), %rdi	# %sfp, stride
	leaq	0(,%rdi,4), %r10	#, _24
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	144(%rsp), %r13d	# p0i, _266
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r15d, %edi	# p, _269
	movq	%r8, 72(%rsp)	# hn, %sfp
	movq	%rdx, %rcx	# t, t
	movq	%rax, %rdx	# m, m
.L93:
# inputs/bootstrap/source/falcon-keygen.c:3199: 		ht = t >> 1;
	movq	%rcx, %rbp	# t, ht
	shrq	%rbp	# ht
# inputs/bootstrap/source/falcon-keygen.c:3200: 		for (u1 = 0, v1 = 0; u1 < m; u1 ++, v1 += t) {
	testq	%rdx, %rdx	# m
	je	.L89	#,
# inputs/bootstrap/source/falcon-keygen.c:3206: 			r2 = r1 + ht * stride;
	movq	64(%rsp), %rax	# %sfp, _32
	imulq	%rbp, %rax	# ht, _32
	salq	$2, %rax	#, _23
	leaq	(%rsi,%rdx,4), %r14	#, ivtmp.400
	movq	%r10, %r8	# _24, _51
	imulq	%rcx, %r8	# t, _51
	movq	56(%rsp), %r12	# %sfp, ivtmp.401
	leaq	(%rsi,%rdx,8), %r11	#, _191
	movq	%rax, 16(%rsp)	# _23, %sfp
	movq	%r8, 24(%rsp)	# _51, %sfp
	movq	%rcx, 40(%rsp)	# t, %sfp
	movq	%rdx, 48(%rsp)	# m, %sfp
	movq	%rsi, %rax	# igm, igm
.L92:
# inputs/bootstrap/source/falcon-keygen.c:3204: 			s = igm[m + u1];
	movl	(%r14), %ebx	# MEM[(const uint32_t *)_360], s
# inputs/bootstrap/source/falcon-keygen.c:3205: 			r1 = a + v1 * stride;
	movq	%r12, %rcx	# ivtmp.401, r1
# inputs/bootstrap/source/falcon-keygen.c:3206: 			r2 = r1 + ht * stride;
	movq	16(%rsp), %rsi	# %sfp, _23
	addq	%r12, %rsi	# ivtmp.401, r2
# inputs/bootstrap/source/falcon-keygen.c:3207: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	testq	%rbp, %rbp	# ht
	je	.L90	#,
# inputs/bootstrap/source/falcon-keygen.c:3207: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	movl	$0, %r9d	#, v
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %ebx	# s, _264
	movq	%r12, (%rsp)	# ivtmp.401, %sfp
	movq	%r14, 8(%rsp)	# ivtmp.400, %sfp
.L91:
# inputs/bootstrap/source/falcon-keygen.c:3210: 				x = *r1;
	movl	(%rcx), %r8d	# MEM[(uint32_t *)r1_382], x
# inputs/bootstrap/source/falcon-keygen.c:3211: 				y = *r2;
	movl	(%rsi), %r14d	# MEM[(uint32_t *)r2_385], y
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	leal	(%r8,%r14), %edx	#, _286
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%r15d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%edx, %r12d	# d, _289
	sarl	$31, %r12d	#, _289
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r15d, %r12d	# p, _291
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%r12d, %edx	# _291, tmp512
	movl	%edx, (%rcx)	# tmp512, MEM[(uint32_t *)r1_382]
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%r14d, %r8d	# y, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%r8d, %edx	# d, _282
	sarl	$31, %edx	#, _282
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%r15d, %edx	# p, _284
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%r8,%rdx), %r8d	#, _263
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbx, %r8	# _264, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r13, %rdx	# _266, _267
	imulq	%r8, %rdx	# z, _267
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _268
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rdi, %rdx	# _269, w_270
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rdx	# z, _271
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _272
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edx, %r8d	# d, _276
	sarl	$31, %r8d	#, _276
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %r8d	# p, _278
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r8d, %edx	# _278, tmp525
	movl	%edx, (%rsi)	# tmp525, MEM[(uint32_t *)r2_385]
# inputs/bootstrap/source/falcon-keygen.c:3207: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	addq	$1, %r9	#, v
# inputs/bootstrap/source/falcon-keygen.c:3207: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	addq	%r10, %rcx	# _24, r1
# inputs/bootstrap/source/falcon-keygen.c:3207: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	addq	%r10, %rsi	# _24, r2
# inputs/bootstrap/source/falcon-keygen.c:3207: 			for (v = 0; v < ht; v ++, r1 += stride, r2 += stride) {
	cmpq	%r9, %rbp	# v, ht
	jne	.L91	#,
	movq	(%rsp), %r12	# %sfp, ivtmp.401
	movq	8(%rsp), %r14	# %sfp, ivtmp.400
.L90:
# inputs/bootstrap/source/falcon-keygen.c:3200: 		for (u1 = 0, v1 = 0; u1 < m; u1 ++, v1 += t) {
	addq	$4, %r14	#, ivtmp.400
	movq	24(%rsp), %rbx	# %sfp, _51
	addq	%rbx, %r12	# _51, ivtmp.401
	cmpq	%r11, %r14	# _191, ivtmp.400
	jne	.L92	#,
	movq	40(%rsp), %rcx	# %sfp, t
	movq	48(%rsp), %rdx	# %sfp, m
	movq	%rax, %rsi	# igm, igm
.L89:
# inputs/bootstrap/source/falcon-keygen.c:3217: 		t <<= 1;
	addq	%rcx, %rcx	# t
# inputs/bootstrap/source/falcon-keygen.c:3196: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	shrq	%rdx	# m
# inputs/bootstrap/source/falcon-keygen.c:3196: 	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
	movq	32(%rsp), %rax	# %sfp, n
	cmpq	%rax, %rcx	# n, t
	jb	.L93	#,
	movq	72(%rsp), %r8	# %sfp, hn
# inputs/bootstrap/source/falcon-keygen.c:3223: 	w = igm[0];
	movl	(%rsi), %r11d	# *igm_59(D), w
	movq	64(%rsp), %rbx	# %sfp, stride
	salq	$2, %rbx	#, stride
# inputs/bootstrap/source/falcon-keygen.c:3224: 	for (u = 0, r1 = a, r2 = a + hn * stride;
	movq	%r8, %rsi	# hn, _369
	imulq	%rbx, %rsi	# _357, _369
# inputs/bootstrap/source/falcon-keygen.c:3224: 	for (u = 0, r1 = a, r2 = a + hn * stride;
	movq	56(%rsp), %rax	# %sfp, a
	addq	%rax, %rsi	# a, r2
# inputs/bootstrap/source/falcon-keygen.c:3225: 		u < hn; u ++, r1 += stride, r2 += stride)
	testq	%r8, %r8	# hn
	je	.L113	#,
.L100:
# inputs/bootstrap/source/falcon-keygen.c:3224: 	for (u = 0, r1 = a, r2 = a + hn * stride;
	movq	56(%rsp), %rdi	# %sfp, r1
# inputs/bootstrap/source/falcon-keygen.c:3224: 	for (u = 0, r1 = a, r2 = a + hn * stride;
	movl	$0, %r10d	#, u
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r11d, %r11d	# w, _306
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	144(%rsp), %r12d	# p0i, _309
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r15d, %ebp	# p, _312
.L96:
# inputs/bootstrap/source/falcon-keygen.c:3229: 		a0 = *r1;
	movl	(%rdi), %eax	# MEM[(uint32_t *)r1_383], a0
# inputs/bootstrap/source/falcon-keygen.c:3230: 		a1 = *r2;
	movl	(%rsi), %r9d	# MEM[(uint32_t *)r2_386], a1
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	leal	(%rax,%r9), %edx	#, _329
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%r15d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%edx, %ecx	# d, _332
	sarl	$31, %ecx	#, _332
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r15d, %ecx	# p, _334
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%r9d, %eax	# a1, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _325
	sarl	$31, %r9d	#, _325
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%r15d, %r9d	# p, _327
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r9), %r9d	#, _307
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r11, %r9	# _306, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r12, %rax	# _309, _310
	imulq	%r9, %rax	# z, _310
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _311
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rbp, %rax	# _312, w_313
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _314
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _315
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _319
	sarl	$31, %r9d	#, _319
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %r9d	# p, _321
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r9d, %eax	# _321, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%ecx, %edx	# _334, d_335
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%eax, %edx	# d, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%edx, %ecx	# d, _302
	sarl	$31, %ecx	#, _302
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%r15d, %ecx	# p, _304
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	addl	%ecx, %edx	# _304, tmp543
	movl	%edx, (%rdi)	# tmp543, MEM[(uint32_t *)r1_383]
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%eax, %eax	# _293
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%r15d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%r15d, %edx	# p, _298
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%edx, %eax	# _298, tmp546
	movl	%eax, (%rsi)	# tmp546, MEM[(uint32_t *)r2_386]
# inputs/bootstrap/source/falcon-keygen.c:3225: 		u < hn; u ++, r1 += stride, r2 += stride)
	addq	$1, %r10	#, u
# inputs/bootstrap/source/falcon-keygen.c:3225: 		u < hn; u ++, r1 += stride, r2 += stride)
	addq	%rbx, %rdi	# _357, r1
# inputs/bootstrap/source/falcon-keygen.c:3225: 		u < hn; u ++, r1 += stride, r2 += stride)
	addq	%rbx, %rsi	# _357, r2
# inputs/bootstrap/source/falcon-keygen.c:3225: 		u < hn; u ++, r1 += stride, r2 += stride)
	cmpq	%r10, %r8	# u, hn
	jne	.L96	#,
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	movl	$-2147483648, %edi	#, tmp560
	subl	%r15d, %edi	# p, _50
# inputs/bootstrap/source/falcon-keygen.c:3241: 	ni = modp_div(R, (uint32_t)n, p, p0i, R);
	movl	%edi, %r8d	# _50,
	movl	144(%rsp), %ecx	# p0i,
	movl	%r15d, %edx	# p,
	movl	32(%rsp), %esi	# %sfp, n
	call	modp_div	#
	movl	%eax, %ecx	# tmp578, ni
.L99:
# inputs/bootstrap/source/falcon-keygen.c:3242: 	for (u = 0, r1 = a; u < n; u ++, r1 += stride) {
	movl	$0, %edx	#, u
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ecx, %ecx	# ni, _338
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	144(%rsp), %edi	# p0i, _340
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r15d, %esi	# p, _343
	movq	32(%rsp), %r9	# %sfp, n
	movq	56(%rsp), %r8	# %sfp, a
	.p2align 6
.L98:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r8), %r10d	# MEM[(uint32_t *)r1_384], _337
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %r10	# _338, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdi, %rax	# _340, _341
	imulq	%r10, %rax	# z, _341
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _342
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _343, w_344
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rax	# z, _345
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _346
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _350
	sarl	$31, %r10d	#, _350
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %r10d	# p, _352
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r10d, %eax	# _352, tmp559
	movl	%eax, (%r8)	# tmp559, MEM[(uint32_t *)r1_384]
# inputs/bootstrap/source/falcon-keygen.c:3242: 	for (u = 0, r1 = a; u < n; u ++, r1 += stride) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3242: 	for (u = 0, r1 = a; u < n; u ++, r1 += stride) {
	addq	%rbx, %r8	# _357, a
# inputs/bootstrap/source/falcon-keygen.c:3242: 	for (u = 0, r1 = a; u < n; u ++, r1 += stride) {
	cmpq	%rdx, %r9	# u, n
	jne	.L98	#,
.L83:
# inputs/bootstrap/source/falcon-keygen.c:3245: }
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
.L88:
	.cfi_restore_state
	movq	64(%rsp), %rbx	# %sfp, stride
	salq	$2, %rbx	#, stride
# inputs/bootstrap/source/falcon-keygen.c:3225: 		u < hn; u ++, r1 += stride, r2 += stride)
	testq	%r8, %r8	# hn
	jne	.L114	#,
.L95:
# inputs/bootstrap/source/falcon-keygen.c:3242: 	for (u = 0, r1 = a; u < n; u ++, r1 += stride) {
	cmpq	$0, 32(%rsp)	#, %sfp
	je	.L83	#,
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	movl	$-2147483648, %edi	#, tmp547
	subl	%r15d, %edi	# p, _336
# inputs/bootstrap/source/falcon-keygen.c:3241: 	ni = modp_div(R, (uint32_t)n, p, p0i, R);
	movl	%edi, %r8d	# _336,
	movl	144(%rsp), %ecx	# p0i,
	movl	%r15d, %edx	# p,
	movl	32(%rsp), %esi	# %sfp, n
	call	modp_div	#
	movl	%eax, %ecx	# tmp577, ni
	jmp	.L99	#
.L114:
# inputs/bootstrap/source/falcon-keygen.c:3223: 	w = igm[0];
	movl	(%rsi), %r11d	# *igm_59(D), w
# inputs/bootstrap/source/falcon-keygen.c:3224: 	for (u = 0, r1 = a, r2 = a + hn * stride;
	movq	%r8, %rsi	# hn, _26
	imulq	%rbx, %rsi	# _357, _26
# inputs/bootstrap/source/falcon-keygen.c:3224: 	for (u = 0, r1 = a, r2 = a + hn * stride;
	movq	56(%rsp), %rax	# %sfp, a
	addq	%rax, %rsi	# a, r2
	jmp	.L100	#
.L86:
	movq	64(%rsp), %rbx	# %sfp, stride
	salq	$2, %rbx	#, stride
	jmp	.L95	#
.L113:
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	movl	$-2147483648, %edi	#, tmp562
	subl	%r15d, %edi	# p, _115
# inputs/bootstrap/source/falcon-keygen.c:3241: 	ni = modp_div(R, (uint32_t)n, p, p0i, R);
	movl	%edi, %r8d	# _115,
	movl	144(%rsp), %ecx	# p0i,
	movl	%r15d, %edx	# p,
	movl	32(%rsp), %esi	# %sfp, n
	call	modp_div	#
	movl	%eax, %ecx	# tmp579, ni
	jmp	.L99	#
	.cfi_endproc
.LFE52:
	.size	modp_iNTT3_ext, .-modp_iNTT3_ext
	.type	modp_poly_rec_res, @function
modp_poly_rec_res:
.LFB53:
	.cfi_startproc
	movq	%rdi, %r9	# tmp160, f
	movl	%edx, %edi	# tmp162, p
	movl	%ecx, %eax	# p0i, tmp163
# inputs/bootstrap/source/falcon-keygen.c:3276: 	hn = (size_t)1 << (logn - 1);
	leal	-1(%rsi), %ecx	#, _1
# inputs/bootstrap/source/falcon-keygen.c:3276: 	hn = (size_t)1 << (logn - 1);
	movl	$1, %r10d	#, tmp141
	salq	%cl, %r10	# _1, hn
# inputs/bootstrap/source/falcon-keygen.c:3277: 	for (u = 0; u < hn; u ++) {
	movl	$0, %edx	#, u
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%eax, %ecx	# tmp163, _39
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%edi, %esi	# p, _42
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r8d, %r8d	# tmp164, _18
.L116:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r9,%rdx,8), %r11d	# MEM[(uint32_t *)f_13(D) + u_55 * 8], _36
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%r9,%rdx,8), %eax	# MEM[(uint32_t *)f_13(D) + 4B + u_55 * 8], _37
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r11	# _37, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# z, _40
	imulq	%rcx, %rax	# _39, _40
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _41
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _42, w_43
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r11, %rax	# z, _44
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _45
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%edi, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r11d	# d, _49
	sarl	$31, %r11d	#, _49
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%edi, %r11d	# p, _51
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r11), %r11d	#, _20
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r8, %r11	# _18, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# z, _24
	imulq	%rcx, %rax	# _39, _24
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _25
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _42, w_26
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r11, %rax	# z, _27
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _28
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%edi, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r11d	# d, _32
	sarl	$31, %r11d	#, _32
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%edi, %r11d	# p, _34
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r11d, %eax	# _34, tmp159
	movl	%eax, (%r9,%rdx,4)	# tmp159, MEM[(uint32_t *)f_13(D) + u_55 * 4]
# inputs/bootstrap/source/falcon-keygen.c:3277: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3277: 	for (u = 0; u < hn; u ++) {
	cmpq	%rdx, %r10	# u, hn
	jne	.L116	#,
# inputs/bootstrap/source/falcon-keygen.c:3284: }
	ret	
	.cfi_endproc
.LFE53:
	.size	modp_poly_rec_res, .-modp_poly_rec_res
	.type	zint_add, @function
zint_add:
.LFB54:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:3330: 	for (u = 0; u < len; u ++) {
	testq	%rdx, %rdx	# len
	je	.L121	#,
# inputs/bootstrap/source/falcon-keygen.c:3329: 	cc = 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3330: 	for (u = 0; u < len; u ++) {
	movl	$0, %ecx	#, u
	.p2align 6
.L120:
# inputs/bootstrap/source/falcon-keygen.c:3333: 		w = a[u] + b[u] + cc;
	movl	(%rsi,%rcx,4), %r8d	# MEM[(const uint32_t *)b_14(D) + u_22 * 4], MEM[(const uint32_t *)b_14(D) + u_22 * 4]
	addl	(%rdi,%rcx,4), %r8d	# MEM[(uint32_t *)a_13(D) + u_22 * 4], _6
# inputs/bootstrap/source/falcon-keygen.c:3333: 		w = a[u] + b[u] + cc;
	addl	%r8d, %eax	# _6, w
# inputs/bootstrap/source/falcon-keygen.c:3334: 		a[u] = w & 0x7FFFFFFF;
	movl	%eax, %r8d	# w, tmp111
	andl	$2147483647, %r8d	#, tmp111
	movl	%r8d, (%rdi,%rcx,4)	# tmp111, MEM[(uint32_t *)a_13(D) + u_22 * 4]
# inputs/bootstrap/source/falcon-keygen.c:3335: 		cc = w >> 31;
	shrl	$31, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3330: 	for (u = 0; u < len; u ++) {
	addq	$1, %rcx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3330: 	for (u = 0; u < len; u ++) {
	cmpq	%rcx, %rdx	# u, len
	jne	.L120	#,
	ret	
.L121:
# inputs/bootstrap/source/falcon-keygen.c:3329: 	cc = 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3338: }
	ret	
	.cfi_endproc
.LFE54:
	.size	zint_add, .-zint_add
	.type	zint_sub, @function
zint_sub:
.LFB55:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:3352: 	for (u = 0; u < len; u ++) {
	testq	%rdx, %rdx	# len
	je	.L126	#,
# inputs/bootstrap/source/falcon-keygen.c:3351: 	cc = 0;
	movl	$0, %r8d	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3352: 	for (u = 0; u < len; u ++) {
	movl	$0, %ecx	#, u
	.p2align 6
.L125:
# inputs/bootstrap/source/falcon-keygen.c:3355: 		w = a[u] - b[u] - cc;
	movl	(%rdi,%rcx,4), %eax	# MEM[(uint32_t *)a_13(D) + u_22 * 4], MEM[(uint32_t *)a_13(D) + u_22 * 4]
	subl	(%rsi,%rcx,4), %eax	# MEM[(const uint32_t *)b_14(D) + u_22 * 4], _1
	subl	%r8d, %eax	# <retval>, w
# inputs/bootstrap/source/falcon-keygen.c:3356: 		a[u] = w & 0x7FFFFFFF;
	movl	%eax, %r8d	# w, tmp110
	andl	$2147483647, %r8d	#, tmp110
	movl	%r8d, (%rdi,%rcx,4)	# tmp110, MEM[(uint32_t *)a_13(D) + u_22 * 4]
# inputs/bootstrap/source/falcon-keygen.c:3357: 		cc = w >> 31;
	shrl	$31, %eax	#, w
	movl	%eax, %r8d	# w, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3352: 	for (u = 0; u < len; u ++) {
	addq	$1, %rcx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3352: 	for (u = 0; u < len; u ++) {
	cmpq	%rcx, %rdx	# u, len
	jne	.L125	#,
.L123:
# inputs/bootstrap/source/falcon-keygen.c:3360: }
	movl	%r8d, %eax	# <retval>,
	ret	
.L126:
# inputs/bootstrap/source/falcon-keygen.c:3351: 	cc = 0;
	movl	$0, %r8d	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3359: 	return cc;
	jmp	.L123	#
	.cfi_endproc
.LFE55:
	.size	zint_sub, .-zint_sub
	.type	zint_mul_small, @function
zint_mul_small:
.LFB56:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:3373: 	for (u = 0; u < mlen; u ++) {
	testq	%rsi, %rsi	# mlen
	je	.L131	#,
	movq	%rdi, %rcx	# m, ivtmp.446
	leaq	(%rdi,%rsi,4), %rdi	#, _33
# inputs/bootstrap/source/falcon-keygen.c:3372: 	cc = 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3376: 		z = (uint64_t)m[u] * (uint64_t)x + cc;
	movl	%edx, %edx	# x, _5
	.p2align 6
.L130:
# inputs/bootstrap/source/falcon-keygen.c:3376: 		z = (uint64_t)m[u] * (uint64_t)x + cc;
	movl	(%rcx), %esi	# MEM[(uint32_t *)_23], _4
# inputs/bootstrap/source/falcon-keygen.c:3376: 		z = (uint64_t)m[u] * (uint64_t)x + cc;
	imulq	%rdx, %rsi	# _5, _6
# inputs/bootstrap/source/falcon-keygen.c:3376: 		z = (uint64_t)m[u] * (uint64_t)x + cc;
	movl	%eax, %eax	# <retval>, _7
# inputs/bootstrap/source/falcon-keygen.c:3376: 		z = (uint64_t)m[u] * (uint64_t)x + cc;
	addq	%rsi, %rax	# _6, z
# inputs/bootstrap/source/falcon-keygen.c:3377: 		m[u] = (uint32_t)z & 0x7FFFFFFF;
	movl	%eax, %esi	# z, tmp120
	andl	$2147483647, %esi	#, tmp120
	movl	%esi, (%rcx)	# tmp120, MEM[(uint32_t *)_23]
# inputs/bootstrap/source/falcon-keygen.c:3378: 		cc = (uint32_t)(z >> 31);
	shrq	$31, %rax	#, _10
# inputs/bootstrap/source/falcon-keygen.c:3373: 	for (u = 0; u < mlen; u ++) {
	addq	$4, %rcx	#, ivtmp.446
	cmpq	%rdi, %rcx	# _33, ivtmp.446
	jne	.L130	#,
	ret	
.L131:
# inputs/bootstrap/source/falcon-keygen.c:3372: 	cc = 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3381: }
	ret	
	.cfi_endproc
.LFE56:
	.size	zint_mul_small, .-zint_mul_small
	.type	zint_mod_small_unsigned, @function
zint_mod_small_unsigned:
.LFB57:
	.cfi_startproc
	movq	%rdi, %r9	# tmp154, d
	movl	%edx, %edi	# tmp156, p
# inputs/bootstrap/source/falcon-keygen.c:3407: 	while (u -- > 0) {
	leaq	-1(%rsi), %r10	#, u
# inputs/bootstrap/source/falcon-keygen.c:3407: 	while (u -- > 0) {
	testq	%rsi, %rsi	# dlen
	je	.L136	#,
# inputs/bootstrap/source/falcon-keygen.c:3405: 	x = 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r8d, %esi	# R2, _27
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ecx, %ecx	# p0i, _29
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%edx, %r8d	# p, _32
.L135:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %eax	# <retval>, _26
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rsi, %rax	# _27, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rdx	# _29, _30
	imulq	%rax, %rdx	# z, _30
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _31
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r8, %rdx	# _32, w_33
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rax, %rdx	# z, _34
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _35
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%edi, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:3411: 		w = d[u] - p;
	movl	(%r9,%r10,4), %r11d	# MEM[(const uint32_t *)d_17(D) + u_48 * 4], w
	subl	%edi, %r11d	# p, w
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edx, %eax	# d, _39
	sarl	$31, %eax	#, _39
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%edi, %eax	# p, _41
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	subl	%edi, %edx	# p, _1
	addl	%edx, %eax	# _1, _2
	addl	%r11d, %eax	# w, _19
# inputs/bootstrap/source/falcon-keygen.c:3412: 		w += p & -(w >> 31);
	sarl	$31, %r11d	#, _5
# inputs/bootstrap/source/falcon-keygen.c:3412: 		w += p & -(w >> 31);
	andl	%edi, %r11d	# p, _7
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%r11d, %eax	# _7, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	%edi, %edx	# p, _24
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%edx, %eax	# _24, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3407: 	while (u -- > 0) {
	subq	$1, %r10	#, u
# inputs/bootstrap/source/falcon-keygen.c:3407: 	while (u -- > 0) {
	cmpq	$-1, %r10	#, u
	jne	.L135	#,
	ret	
.L136:
# inputs/bootstrap/source/falcon-keygen.c:3405: 	x = 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3416: }
	ret	
	.cfi_endproc
.LFE57:
	.size	zint_mod_small_unsigned, .-zint_mod_small_unsigned
	.type	zint_mod_small_signed, @function
zint_mod_small_signed:
.LFB58:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:3429: 		return 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3428: 	if (dlen == 0) {
	testq	%rsi, %rsi	# dlen
	je	.L142	#,
# inputs/bootstrap/source/falcon-keygen.c:3425: {
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
	movq	%rdi, %r13	# tmp124, d
	movq	%rsi, %rbx	# tmp125, dlen
	movl	%edx, %ebp	# tmp126, p
	movl	%r9d, %r12d	# tmp129, Rx
# inputs/bootstrap/source/falcon-keygen.c:3431: 	z = zint_mod_small_unsigned(d, dlen, p, p0i, R2);
	call	zint_mod_small_unsigned	#
# inputs/bootstrap/source/falcon-keygen.c:3432: 	z = modp_sub(z, Rx & -(d[dlen - 1] >> 30), p);
	movl	-4(%r13,%rbx,4), %r9d	# *_3, *_3
	shrl	$30, %r9d	#, _5
# inputs/bootstrap/source/falcon-keygen.c:3432: 	z = modp_sub(z, Rx & -(d[dlen - 1] >> 30), p);
	negl	%r9d	# _6
# inputs/bootstrap/source/falcon-keygen.c:3432: 	z = modp_sub(z, Rx & -(d[dlen - 1] >> 30), p);
	andl	%r12d, %r9d	# Rx, _7
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%r9d, %eax	# _7, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%ebp, %edx	# p, _21
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	addl	%edx, %eax	# _21, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3434: }
	popq	%rbx	#
	.cfi_def_cfa_offset 32
	popq	%rbp	#
	.cfi_def_cfa_offset 24
	popq	%r12	#
	.cfi_def_cfa_offset 16
	popq	%r13	#
	.cfi_def_cfa_offset 8
	ret	
.L142:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	ret	
	.cfi_endproc
.LFE58:
	.size	zint_mod_small_signed, .-zint_mod_small_signed
	.type	zint_rshift1, @function
zint_rshift1:
.LFB60:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:3473: 	while (k -- > 0) {
	leaq	-1(%rsi), %rax	#, k
# inputs/bootstrap/source/falcon-keygen.c:3473: 	while (k -- > 0) {
	testq	%rsi, %rsi	# len
	je	.L148	#,
	leaq	(%rdi,%rax,4), %rdx	#, ivtmp.465
# inputs/bootstrap/source/falcon-keygen.c:3471: 	cc = 0;
	movl	$0, %eax	#, <retval>
	.p2align 5
.L147:
	movq	%rdx, %r8	# ivtmp.465, _27
# inputs/bootstrap/source/falcon-keygen.c:3476: 		w = d[k];
	movl	(%rdx), %esi	# MEM[(uint32_t *)_27], w
# inputs/bootstrap/source/falcon-keygen.c:3477: 		d[k] = (w >> 1) | (cc << 30);
	movl	%esi, %ecx	# w, _3
	shrl	%ecx	# _3
# inputs/bootstrap/source/falcon-keygen.c:3477: 		d[k] = (w >> 1) | (cc << 30);
	sall	$30, %eax	#, _4
# inputs/bootstrap/source/falcon-keygen.c:3477: 		d[k] = (w >> 1) | (cc << 30);
	orl	%eax, %ecx	# _4, tmp115
	movl	%ecx, (%rdx)	# tmp115, MEM[(uint32_t *)_27]
# inputs/bootstrap/source/falcon-keygen.c:3478: 		cc = w & 1;
	movl	%esi, %eax	# w, w
	andl	$1, %eax	#, w
# inputs/bootstrap/source/falcon-keygen.c:3473: 	while (k -- > 0) {
	subq	$4, %rdx	#, ivtmp.465
	cmpq	%rdi, %r8	# d, _27
	jne	.L147	#,
	ret	
.L148:
# inputs/bootstrap/source/falcon-keygen.c:3471: 	cc = 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3481: }
	ret	
	.cfi_endproc
.LFE60:
	.size	zint_rshift1, .-zint_rshift1
	.type	zint_rshift1_mod, @function
zint_rshift1_mod:
.LFB61:
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
	movq	%rdi, %rbp	# tmp113, x
	movq	%rdx, %r12	# tmp115, len
# inputs/bootstrap/source/falcon-keygen.c:3491: 	if ((x[0] & 1) != 0) {
	movl	(%rdi), %ebx	# *x_12(D), hi
	andl	$1, %ebx	#, hi
	jne	.L153	#,
.L151:
# inputs/bootstrap/source/falcon-keygen.c:3496: 	zint_rshift1(x, len);
	movq	%r12, %rsi	# len,
	movq	%rbp, %rdi	# x,
	call	zint_rshift1	#
# inputs/bootstrap/source/falcon-keygen.c:3497: 	x[len - 1] |= hi << 30;
	sall	$30, %ebx	#, _7
# inputs/bootstrap/source/falcon-keygen.c:3497: 	x[len - 1] |= hi << 30;
	orl	%ebx, -4(%rbp,%r12,4)	# _7, *_5
# inputs/bootstrap/source/falcon-keygen.c:3498: }
	popq	%rbx	#
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp	#
	.cfi_def_cfa_offset 16
	popq	%r12	#
	.cfi_def_cfa_offset 8
	ret	
.L153:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:3492: 		hi = zint_add(x, p, len);
	call	zint_add	#
	movl	%eax, %ebx	# tmp116, hi
	jmp	.L151	#
	.cfi_endproc
.LFE61:
	.size	zint_rshift1_mod, .-zint_rshift1_mod
	.type	zint_sub_mod, @function
zint_sub_mod:
.LFB62:
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
	movq	%rdi, %rbx	# tmp103, x
	movq	%rdx, %r12	# tmp105, p
	movq	%rcx, %rbp	# tmp106, len
# inputs/bootstrap/source/falcon-keygen.c:3507: 	if (zint_sub(x, y, len)) {
	movq	%rcx, %rdx	# len,
	call	zint_sub	#
# inputs/bootstrap/source/falcon-keygen.c:3507: 	if (zint_sub(x, y, len)) {
	testl	%eax, %eax	# tmp107
	jne	.L157	#,
.L154:
# inputs/bootstrap/source/falcon-keygen.c:3510: }
	popq	%rbx	#
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp	#
	.cfi_def_cfa_offset 16
	popq	%r12	#
	.cfi_def_cfa_offset 8
	ret	
.L157:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:3508: 		zint_add(x, p, len);
	movq	%rbp, %rdx	# len,
	movq	%r12, %rsi	# p,
	movq	%rbx, %rdi	# x,
	call	zint_add	#
# inputs/bootstrap/source/falcon-keygen.c:3510: }
	jmp	.L154	#
	.cfi_endproc
.LFE62:
	.size	zint_sub_mod, .-zint_sub_mod
	.type	zint_ucmp, @function
zint_ucmp:
.LFB63:
	.cfi_startproc
	subq	$1, %rdx	#, ivtmp.475
.L159:
# inputs/bootstrap/source/falcon-keygen.c:3519: 	while (len -- > 0) {
	cmpq	$-1, %rdx	#, ivtmp.475
	je	.L164	#,
# inputs/bootstrap/source/falcon-keygen.c:3522: 		wa = a[len];
	movl	(%rdi,%rdx,4), %eax	# MEM[(const uint32_t *)a_8(D) + ivtmp.475_13 * 4], wa
# inputs/bootstrap/source/falcon-keygen.c:3523: 		wb = b[len];
	movl	(%rsi,%rdx,4), %ecx	# MEM[(const uint32_t *)b_11(D) + ivtmp.475_13 * 4], wb
# inputs/bootstrap/source/falcon-keygen.c:3524: 		if (wa < wb) {
	cmpl	%ecx, %eax	# wb, wa
	jb	.L162	#,
# inputs/bootstrap/source/falcon-keygen.c:3527: 		if (wa > wb) {
	subq	$1, %rdx	#, ivtmp.475
	cmpl	%eax, %ecx	# wa, wb
	jnb	.L159	#,
# inputs/bootstrap/source/falcon-keygen.c:3528: 			return 1;
	movl	$1, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3532: }
	ret	
.L164:
# inputs/bootstrap/source/falcon-keygen.c:3531: 	return 0;
	movl	$0, %eax	#, <retval>
	ret	
.L162:
# inputs/bootstrap/source/falcon-keygen.c:3525: 			return -1;
	movl	$-1, %eax	#, <retval>
	ret	
	.cfi_endproc
.LFE63:
	.size	zint_ucmp, .-zint_ucmp
	.type	zint_rebuild_CRT, @function
zint_rebuild_CRT:
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
	subq	$88, %rsp	#,
	.cfi_def_cfa_offset 144
	movq	%rdi, 64(%rsp)	# tmp192, %sfp
	movq	%rsi, 56(%rsp)	# xlen, %sfp
	movq	%rdx, %r13	# tmp194, xstride
	movq	%rcx, 8(%rsp)	# tmp195, %sfp
	movl	%r9d, %ebx	# tmp197, normalize_signed
	movq	144(%rsp), %rbp	# tmp, tmp
# inputs/bootstrap/source/falcon-keygen.c:3584: 	tmp[0] = primes[0].p;
	movl	(%r8), %edx	# *primes_21(D).p, *primes_21(D).p
	movl	%edx, 0(%rbp)	# *primes_21(D).p, *tmp_22(D)
# inputs/bootstrap/source/falcon-keygen.c:3585: 	for (u = 1; u < xlen; u ++) {
	cmpq	$1, %rsi	#, xlen
	jbe	.L166	#,
	movq	%r8, %rax	# tmp196, primes
# inputs/bootstrap/source/falcon-keygen.c:3603: 		for (v = 0, x = xx; v < num; v ++, x += xstride) {
	leaq	0(,%r13,4), %rdi	#, _6
	movq	%rdi, 40(%rsp)	# _6, %sfp
	addq	$12, %rax	#, ivtmp.523
	movq	%rax, 48(%rsp)	# ivtmp.523, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3585: 	for (u = 1; u < xlen; u ++) {
	movl	$1, %r14d	#, u
# inputs/bootstrap/source/falcon-keygen.c:3447: 	cc = 0;
	movq	%r13, 72(%rsp)	# xstride, %sfp
	movl	%r9d, 84(%rsp)	# normalize_signed, %sfp
.L170:
# inputs/bootstrap/source/falcon-keygen.c:3598: 		p = primes[u].p;
	movq	48(%rsp), %rax	# %sfp, ivtmp.523
	movl	(%rax), %r13d	# MEM[(unsigned int *)_78], p
# inputs/bootstrap/source/falcon-keygen.c:3599: 		s = primes[u].s;
	movl	8(%rax), %r12d	# MEM[(unsigned int *)_78 + 8B], s
# inputs/bootstrap/source/falcon-keygen.c:3600: 		p0i = modp_ninv31(p);
	movl	%r13d, %edi	# p,
	call	modp_ninv31	#
# inputs/bootstrap/source/falcon-keygen.c:3601: 		R2 = modp_R2(p, p0i);
	movl	%eax, 4(%rsp)	# p0i, %sfp
	movl	%eax, %esi	# p0i,
	movl	%r13d, %edi	# p,
	call	modp_R2	#
	movl	%eax, 80(%rsp)	# tmp199, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3603: 		for (v = 0, x = xx; v < num; v ++, x += xstride) {
	cmpq	$0, 8(%rsp)	#, %sfp
	je	.L167	#,
# inputs/bootstrap/source/falcon-keygen.c:3603: 		for (v = 0, x = xx; v < num; v ++, x += xstride) {
	movq	64(%rsp), %rbx	# %sfp, x
# inputs/bootstrap/source/falcon-keygen.c:3603: 		for (v = 0, x = xx; v < num; v ++, x += xstride) {
	movl	$0, %r15d	#, v
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r12d, %edi	# s, _45
	movq	%rdi, 16(%rsp)	# _45, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	4(%rsp), %eax	# %sfp, _36
	movq	%rax, 24(%rsp)	# _36, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r13d, %eax	# p, _50
	movq	%rax, 32(%rsp)	# _50, %sfp
.L169:
# inputs/bootstrap/source/falcon-keygen.c:3610: 			xp = x[u];
	movl	(%rbx,%r14,4), %r12d	# MEM[(uint32_t *)x_114 + u_112 * 4], xp
# inputs/bootstrap/source/falcon-keygen.c:3611: 			xq = zint_mod_small_unsigned(x, u, p, p0i, R2);
	movl	80(%rsp), %r8d	# %sfp,
	movl	4(%rsp), %ecx	# %sfp,
	movl	%r13d, %edx	# p,
	movq	%r14, %rsi	# u,
	movq	%rbx, %rdi	# x,
	call	zint_mod_small_unsigned	#
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%eax, %r12d	# tmp200, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%r12d, %eax	# d, _63
	sarl	$31, %eax	#, _63
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%r13d, %eax	# p, _65
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%r12,%rax), %edx	#, _44
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	16(%rsp), %rax	# %sfp, _45
	imulq	%rax, %rdx	# _45, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	24(%rsp), %rax	# %sfp, _34
	imulq	%rdx, %rax	# z, _34
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _49
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	32(%rsp), %rdi	# %sfp, _50
	imulq	%rdi, %rax	# _50, w_51
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %rax	# z, _52
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _53
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r13d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %esi	# d, _57
	sarl	$31, %esi	#, _57
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r13d, %esi	# p, _59
# inputs/bootstrap/source/falcon-keygen.c:3447: 	cc = 0;
	movl	$0, %ecx	#, cc
# inputs/bootstrap/source/falcon-keygen.c:3448: 	for (u = 0; u < len; u ++) {
	movl	$0, %edx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3454: 		z = (uint64_t)yw * (uint64_t)s + (uint64_t)xw + (uint64_t)cc;
	leal	(%rax,%rsi), %esi	#, _74
	.p2align 6
.L168:
# inputs/bootstrap/source/falcon-keygen.c:3454: 		z = (uint64_t)yw * (uint64_t)s + (uint64_t)xw + (uint64_t)cc;
	movl	0(%rbp,%rdx,4), %eax	# MEM[(const uint32_t *)tmp_22(D) + u_122 * 4], _73
# inputs/bootstrap/source/falcon-keygen.c:3454: 		z = (uint64_t)yw * (uint64_t)s + (uint64_t)xw + (uint64_t)cc;
	imulq	%rsi, %rax	# _74, _75
# inputs/bootstrap/source/falcon-keygen.c:3454: 		z = (uint64_t)yw * (uint64_t)s + (uint64_t)xw + (uint64_t)cc;
	movl	(%rbx,%rdx,4), %edi	# MEM[(uint32_t *)x_114 + u_122 * 4], _76
# inputs/bootstrap/source/falcon-keygen.c:3454: 		z = (uint64_t)yw * (uint64_t)s + (uint64_t)xw + (uint64_t)cc;
	addq	%rdi, %rax	# _76, _14
# inputs/bootstrap/source/falcon-keygen.c:3454: 		z = (uint64_t)yw * (uint64_t)s + (uint64_t)xw + (uint64_t)cc;
	movl	%ecx, %ecx	# cc, _79
# inputs/bootstrap/source/falcon-keygen.c:3454: 		z = (uint64_t)yw * (uint64_t)s + (uint64_t)xw + (uint64_t)cc;
	addq	%rcx, %rax	# _79, z
# inputs/bootstrap/source/falcon-keygen.c:3455: 		x[u] = (uint32_t)z & 0x7FFFFFFF;
	movl	%eax, %ecx	# z, tmp185
	andl	$2147483647, %ecx	#, tmp185
	movl	%ecx, (%rbx,%rdx,4)	# tmp185, MEM[(uint32_t *)x_114 + u_122 * 4]
# inputs/bootstrap/source/falcon-keygen.c:3456: 		cc = (uint32_t)(z >> 31);
	shrq	$31, %rax	#, _83
# inputs/bootstrap/source/falcon-keygen.c:3456: 		cc = (uint32_t)(z >> 31);
	movl	%eax, %ecx	# _83, cc
# inputs/bootstrap/source/falcon-keygen.c:3448: 	for (u = 0; u < len; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3448: 	for (u = 0; u < len; u ++) {
	cmpq	%r14, %rdx	# u, u
	jb	.L168	#,
# inputs/bootstrap/source/falcon-keygen.c:3458: 	x[len] = cc;
	movl	%eax, (%rbx,%r14,4)	# _83, MEM[(uint32_t *)x_114 + u_112 * 4]
# inputs/bootstrap/source/falcon-keygen.c:3603: 		for (v = 0, x = xx; v < num; v ++, x += xstride) {
	addq	$1, %r15	#, v
# inputs/bootstrap/source/falcon-keygen.c:3603: 		for (v = 0, x = xx; v < num; v ++, x += xstride) {
	movq	40(%rsp), %rax	# %sfp, _6
	addq	%rax, %rbx	# _6, x
# inputs/bootstrap/source/falcon-keygen.c:3603: 		for (v = 0, x = xx; v < num; v ++, x += xstride) {
	cmpq	%r15, 8(%rsp)	# v, %sfp
	jne	.L169	#,
.L167:
# inputs/bootstrap/source/falcon-keygen.c:3623: 		tmp[u] = zint_mul_small(tmp, u, p);
	movl	%r13d, %edx	# p,
	movq	%r14, %rsi	# u,
	movq	%rbp, %rdi	# tmp,
	call	zint_mul_small	#
# inputs/bootstrap/source/falcon-keygen.c:3623: 		tmp[u] = zint_mul_small(tmp, u, p);
	movl	%eax, 0(%rbp,%r14,4)	# tmp201, MEM[(uint32_t *)tmp_22(D) + u_112 * 4]
# inputs/bootstrap/source/falcon-keygen.c:3585: 	for (u = 1; u < xlen; u ++) {
	addq	$1, %r14	#, u
# inputs/bootstrap/source/falcon-keygen.c:3585: 	for (u = 1; u < xlen; u ++) {
	addq	$12, 48(%rsp)	#, %sfp
	cmpq	%r14, 56(%rsp)	# u, %sfp
	jne	.L170	#,
	movq	72(%rsp), %r13	# %sfp, xstride
	movl	84(%rsp), %ebx	# %sfp, normalize_signed
.L166:
# inputs/bootstrap/source/falcon-keygen.c:3629: 	if (normalize_signed) {
	testl	%ebx, %ebx	# normalize_signed
	je	.L165	#,
# inputs/bootstrap/source/falcon-keygen.c:3630: 		for (u = 0, x = xx; u < num; u ++, x += xstride) {
	salq	$2, %r13	#, _10
# inputs/bootstrap/source/falcon-keygen.c:3630: 		for (u = 0, x = xx; u < num; u ++, x += xstride) {
	movl	$0, %ebx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3545: 	cc = 0;
	movl	$0, %r12d	#, cc
# inputs/bootstrap/source/falcon-keygen.c:3630: 		for (u = 0, x = xx; u < num; u ++, x += xstride) {
	cmpq	$0, 8(%rsp)	#, %sfp
	je	.L165	#,
	movq	64(%rsp), %r14	# %sfp, xx
	movq	56(%rsp), %r15	# %sfp, xlen
	jmp	.L176	#
.L173:
# inputs/bootstrap/source/falcon-keygen.c:3630: 		for (u = 0, x = xx; u < num; u ++, x += xstride) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3630: 		for (u = 0, x = xx; u < num; u ++, x += xstride) {
	addq	%r13, %r14	# _10, xx
# inputs/bootstrap/source/falcon-keygen.c:3630: 		for (u = 0, x = xx; u < num; u ++, x += xstride) {
	cmpq	%rbx, 8(%rsp)	# u, %sfp
	je	.L165	#,
.L176:
	leaq	-1(%r15), %rax	#, ivtmp.490
# inputs/bootstrap/source/falcon-keygen.c:3545: 	cc = 0;
	movl	%r12d, %ecx	# cc, cc
.L174:
# inputs/bootstrap/source/falcon-keygen.c:3547: 	while (u -- > 0) {
	cmpq	$-1, %rax	#, ivtmp.490
	je	.L173	#,
# inputs/bootstrap/source/falcon-keygen.c:3550: 		w = (p[u] >> 1) | (cc << 30);
	movl	0(%rbp,%rax,4), %esi	# MEM[(const uint32_t *)tmp_22(D) + ivtmp.490_12 * 4], _91
# inputs/bootstrap/source/falcon-keygen.c:3550: 		w = (p[u] >> 1) | (cc << 30);
	movl	%esi, %edx	# _91, _92
	shrl	%edx	# _92
# inputs/bootstrap/source/falcon-keygen.c:3550: 		w = (p[u] >> 1) | (cc << 30);
	sall	$30, %ecx	#, _94
# inputs/bootstrap/source/falcon-keygen.c:3550: 		w = (p[u] >> 1) | (cc << 30);
	orl	%ecx, %edx	# _94, w
# inputs/bootstrap/source/falcon-keygen.c:3551: 		cc = p[u] & 1;
	andl	$1, %esi	#, _91
	movl	%esi, %ecx	# _91, cc
# inputs/bootstrap/source/falcon-keygen.c:3552: 		if (x[u] < w) {
	movl	(%r14,%rax,4), %esi	# MEM[(uint32_t *)x_115 + ivtmp.490_12 * 4], _98
# inputs/bootstrap/source/falcon-keygen.c:3552: 		if (x[u] < w) {
	cmpl	%edx, %esi	# w, _98
	jb	.L173	#,
# inputs/bootstrap/source/falcon-keygen.c:3555: 		if (x[u] > w) {
	subq	$1, %rax	#, ivtmp.490
	cmpl	%esi, %edx	# _98, w
	jnb	.L174	#,
# inputs/bootstrap/source/falcon-keygen.c:3556: 			zint_sub(x, p, len);
	movq	%r15, %rdx	# xlen,
	movq	%rbp, %rsi	# tmp,
	movq	%r14, %rdi	# xx,
	call	zint_sub	#
# inputs/bootstrap/source/falcon-keygen.c:3557: 			return;
	jmp	.L173	#
.L165:
# inputs/bootstrap/source/falcon-keygen.c:3634: }
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
.LFE65:
	.size	zint_rebuild_CRT, .-zint_rebuild_CRT
	.type	zint_exact_length, @function
zint_exact_length:
.LFB66:
	.cfi_startproc
	movq	%rsi, %rax	# tmp104, xlen
# inputs/bootstrap/source/falcon-keygen.c:3643: 	while (xlen > 0) {
	testq	%rsi, %rsi	# xlen
	je	.L185	#,
	.p2align 4
.L187:
# inputs/bootstrap/source/falcon-keygen.c:3644: 		if (x[xlen - 1] != 0) {
	cmpl	$0, -4(%rdi,%rax,4)	#, MEM[(const uint32_t *)x_7(D) + -4B + xlen_11 * 4]
	jne	.L185	#,
# inputs/bootstrap/source/falcon-keygen.c:3643: 	while (xlen > 0) {
	subq	$1, %rax	#, xlen
	jne	.L187	#,
.L185:
# inputs/bootstrap/source/falcon-keygen.c:3650: }
	ret	
	.cfi_endproc
.LFE66:
	.size	zint_exact_length, .-zint_exact_length
	.type	zint_co_reduce_mod, @function
zint_co_reduce_mod:
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
	movq	%rdi, %rbp	# tmp208, a
	movq	%rsi, %rbx	# tmp209, b
	movq	%rdx, %r14	# tmp210, m
	movq	%rcx, %r13	# tmp211, len
	movl	80(%rsp), %r11d	# xb, xb
	movl	88(%rsp), %r10d	# ya, ya
	movl	96(%rsp), %edi	# yb, yb
# inputs/bootstrap/source/falcon-keygen.c:3742: 	fx = ((a[0] * (uint32_t)xa + b[0] * (uint32_t)xb) * m0i) & 0x7FFFFFFF;
	movl	0(%rbp), %eax	# *a_70(D), _1
# inputs/bootstrap/source/falcon-keygen.c:3742: 	fx = ((a[0] * (uint32_t)xa + b[0] * (uint32_t)xb) * m0i) & 0x7FFFFFFF;
	movl	(%rsi), %edx	# *b_72(D), _4
# inputs/bootstrap/source/falcon-keygen.c:3742: 	fx = ((a[0] * (uint32_t)xa + b[0] * (uint32_t)xb) * m0i) & 0x7FFFFFFF;
	movl	%r9d, %ecx	# xa, _3
	imull	%eax, %ecx	# _1, _3
# inputs/bootstrap/source/falcon-keygen.c:3742: 	fx = ((a[0] * (uint32_t)xa + b[0] * (uint32_t)xb) * m0i) & 0x7FFFFFFF;
	movl	%r11d, %esi	# xb, _6
	imull	%edx, %esi	# _4, _6
# inputs/bootstrap/source/falcon-keygen.c:3742: 	fx = ((a[0] * (uint32_t)xa + b[0] * (uint32_t)xb) * m0i) & 0x7FFFFFFF;
	addl	%esi, %ecx	# _6, _7
# inputs/bootstrap/source/falcon-keygen.c:3742: 	fx = ((a[0] * (uint32_t)xa + b[0] * (uint32_t)xb) * m0i) & 0x7FFFFFFF;
	imull	%r8d, %ecx	# m0i, _8
# inputs/bootstrap/source/falcon-keygen.c:3742: 	fx = ((a[0] * (uint32_t)xa + b[0] * (uint32_t)xb) * m0i) & 0x7FFFFFFF;
	andl	$2147483647, %ecx	#, fx
# inputs/bootstrap/source/falcon-keygen.c:3743: 	fy = ((a[0] * (uint32_t)ya + b[0] * (uint32_t)yb) * m0i) & 0x7FFFFFFF;
	imull	%r10d, %eax	# ya, _10
# inputs/bootstrap/source/falcon-keygen.c:3743: 	fy = ((a[0] * (uint32_t)ya + b[0] * (uint32_t)yb) * m0i) & 0x7FFFFFFF;
	imull	%edi, %edx	# yb, _12
# inputs/bootstrap/source/falcon-keygen.c:3743: 	fy = ((a[0] * (uint32_t)ya + b[0] * (uint32_t)yb) * m0i) & 0x7FFFFFFF;
	addl	%edx, %eax	# _12, _13
# inputs/bootstrap/source/falcon-keygen.c:3743: 	fy = ((a[0] * (uint32_t)ya + b[0] * (uint32_t)yb) * m0i) & 0x7FFFFFFF;
	imull	%r8d, %eax	# m0i, _14
# inputs/bootstrap/source/falcon-keygen.c:3743: 	fy = ((a[0] * (uint32_t)ya + b[0] * (uint32_t)yb) * m0i) & 0x7FFFFFFF;
	andl	$2147483647, %eax	#, fy
# inputs/bootstrap/source/falcon-keygen.c:3746: 	for (u = 0; u < len; u ++) {
	testq	%r13, %r13	# len
	je	.L192	#,
# inputs/bootstrap/source/falcon-keygen.c:3745: 	ccb = 0;
	movl	$0, %r12d	#, ccb
# inputs/bootstrap/source/falcon-keygen.c:3744: 	cca = 0;
	movl	$0, %edx	#, cca
# inputs/bootstrap/source/falcon-keygen.c:3746: 	for (u = 0; u < len; u ++) {
	movl	$0, %esi	#, u
# inputs/bootstrap/source/falcon-keygen.c:3753: 		za = (int64_t)wa * (int64_t)xa + (int64_t)wb * (int64_t)xb;
	movslq	%r9d, %r9	# xa, _19
# inputs/bootstrap/source/falcon-keygen.c:3753: 		za = (int64_t)wa * (int64_t)xa + (int64_t)wb * (int64_t)xb;
	movslq	%r11d, %r11	# xb, _22
# inputs/bootstrap/source/falcon-keygen.c:3754: 		zb = (int64_t)wa * (int64_t)ya + (int64_t)wb * (int64_t)yb;
	movslq	%r10d, %r10	# ya, _24
# inputs/bootstrap/source/falcon-keygen.c:3754: 		zb = (int64_t)wa * (int64_t)ya + (int64_t)wb * (int64_t)yb;
	movslq	%edi, %rdi	# yb, _26
	movq	%rdi, (%rsp)	# _26, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3757: 		za += (uint64_t)m[u] * (uint64_t)fx;
	movl	%ecx, %edi	# fx, _31
	movq	%rdi, 8(%rsp)	# _31, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3758: 		zb += (uint64_t)m[u] * (uint64_t)fy;
	movl	%eax, %eax	# fy, _35
	movq	%rax, 16(%rsp)	# _35, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3774: 		tta = (tta ^ M) - M;
	movabsq	$4294967296, %r8	#, tmp199
	jmp	.L194	#
.L193:
# inputs/bootstrap/source/falcon-keygen.c:3772: 		tta = (uint64_t)za >> 31;
	shrq	$31, %rcx	#, _46
# inputs/bootstrap/source/falcon-keygen.c:3774: 		tta = (tta ^ M) - M;
	xorq	%r8, %rcx	# tmp199, _48
# inputs/bootstrap/source/falcon-keygen.c:3774: 		tta = (tta ^ M) - M;
	subq	%r8, %rcx	# tmp199, _49
# inputs/bootstrap/source/falcon-keygen.c:3773: 		ttb = (uint64_t)zb >> 31;
	shrq	$31, %rax	#, _47
# inputs/bootstrap/source/falcon-keygen.c:3775: 		ttb = (ttb ^ M) - M;
	xorq	%r8, %rax	# tmp199, _50
# inputs/bootstrap/source/falcon-keygen.c:3775: 		ttb = (ttb ^ M) - M;
	subq	%r8, %rax	# tmp199, _51
# inputs/bootstrap/source/falcon-keygen.c:3776: 		cca = *(int64_t *)&tta;
	movq	%rcx, %rdx	# _49, cca
# inputs/bootstrap/source/falcon-keygen.c:3777: 		ccb = *(int64_t *)&ttb;
	movq	%rax, %r12	# _51, ccb
# inputs/bootstrap/source/falcon-keygen.c:3746: 	for (u = 0; u < len; u ++) {
	addq	$1, %rsi	#, u
# inputs/bootstrap/source/falcon-keygen.c:3746: 	for (u = 0; u < len; u ++) {
	cmpq	%rsi, %r13	# u, len
	je	.L203	#,
.L194:
# inputs/bootstrap/source/falcon-keygen.c:3753: 		za = (int64_t)wa * (int64_t)xa + (int64_t)wb * (int64_t)xb;
	movl	0(%rbp,%rsi,4), %eax	# MEM[(uint32_t *)a_70(D) + u_102 * 4], _18
# inputs/bootstrap/source/falcon-keygen.c:3753: 		za = (int64_t)wa * (int64_t)xa + (int64_t)wb * (int64_t)xb;
	movl	(%rbx,%rsi,4), %edi	# MEM[(uint32_t *)b_72(D) + u_102 * 4], _21
# inputs/bootstrap/source/falcon-keygen.c:3753: 		za = (int64_t)wa * (int64_t)xa + (int64_t)wb * (int64_t)xb;
	movq	%r9, %rcx	# _19, _20
	imulq	%rax, %rcx	# _18, _20
# inputs/bootstrap/source/falcon-keygen.c:3753: 		za = (int64_t)wa * (int64_t)xa + (int64_t)wb * (int64_t)xb;
	movq	%r11, %r15	# _22, _23
	imulq	%rdi, %r15	# _21, _23
# inputs/bootstrap/source/falcon-keygen.c:3753: 		za = (int64_t)wa * (int64_t)xa + (int64_t)wb * (int64_t)xb;
	addq	%r15, %rcx	# _23, za
# inputs/bootstrap/source/falcon-keygen.c:3754: 		zb = (int64_t)wa * (int64_t)ya + (int64_t)wb * (int64_t)yb;
	imulq	%r10, %rax	# _24, _25
# inputs/bootstrap/source/falcon-keygen.c:3754: 		zb = (int64_t)wa * (int64_t)ya + (int64_t)wb * (int64_t)yb;
	movq	(%rsp), %r15	# %sfp, _26
	imulq	%r15, %rdi	# _26, _27
# inputs/bootstrap/source/falcon-keygen.c:3754: 		zb = (int64_t)wa * (int64_t)ya + (int64_t)wb * (int64_t)yb;
	addq	%rdi, %rax	# _27, zb
# inputs/bootstrap/source/falcon-keygen.c:3757: 		za += (uint64_t)m[u] * (uint64_t)fx;
	movl	(%r14,%rsi,4), %edi	# MEM[(const uint32_t *)m_82(D) + u_102 * 4], _30
# inputs/bootstrap/source/falcon-keygen.c:3757: 		za += (uint64_t)m[u] * (uint64_t)fx;
	movq	8(%rsp), %r15	# %sfp, _32
	imulq	%rdi, %r15	# _30, _32
# inputs/bootstrap/source/falcon-keygen.c:3755: 		za += cca;
	addq	%rdx, %rcx	# cca, za_91
# inputs/bootstrap/source/falcon-keygen.c:3757: 		za += (uint64_t)m[u] * (uint64_t)fx;
	addq	%r15, %rcx	# _32, _34
# inputs/bootstrap/source/falcon-keygen.c:3758: 		zb += (uint64_t)m[u] * (uint64_t)fy;
	movq	16(%rsp), %rdx	# %sfp, _35
	imulq	%rdx, %rdi	# _35, _36
# inputs/bootstrap/source/falcon-keygen.c:3756: 		zb += ccb;
	addq	%r12, %rax	# ccb, zb_92
# inputs/bootstrap/source/falcon-keygen.c:3758: 		zb += (uint64_t)m[u] * (uint64_t)fy;
	addq	%rdi, %rax	# _36, _38
# inputs/bootstrap/source/falcon-keygen.c:3759: 		if (u > 0) {
	testq	%rsi, %rsi	# u
	je	.L193	#,
# inputs/bootstrap/source/falcon-keygen.c:3760: 			a[u - 1] = (uint32_t)za & 0x7FFFFFFF;
	movl	%ecx, %edx	# _34, tmp195
	andl	$2147483647, %edx	#, tmp195
	movl	%edx, -4(%rbp,%rsi,4)	# tmp195, MEM[(uint32_t *)a_70(D) + -4B + u_102 * 4]
# inputs/bootstrap/source/falcon-keygen.c:3761: 			b[u - 1] = (uint32_t)zb & 0x7FFFFFFF;
	movl	%eax, %edx	# _38, tmp196
	andl	$2147483647, %edx	#, tmp196
	movl	%edx, -4(%rbx,%rsi,4)	# tmp196, MEM[(uint32_t *)b_72(D) + -4B + u_102 * 4]
	jmp	.L193	#
.L203:
# inputs/bootstrap/source/falcon-keygen.c:3780: 	a[len - 1] = (uint32_t)cca & 0x7FFFFFFF;
	leaq	0(,%rsi,4), %rdx	#, _53
# inputs/bootstrap/source/falcon-keygen.c:3780: 	a[len - 1] = (uint32_t)cca & 0x7FFFFFFF;
	movl	%ecx, %edi	# _49, tmp206
	andl	$2147483647, %edi	#, tmp206
	movl	%edi, -4(%rbp,%rdx)	# tmp206, *_55
# inputs/bootstrap/source/falcon-keygen.c:3781: 	b[len - 1] = (uint32_t)ccb & 0x7FFFFFFF;
	andl	$2147483647, %eax	#, tmp207
	movl	%eax, -4(%rbx,%rdx)	# tmp207, *_58
# inputs/bootstrap/source/falcon-keygen.c:3788: 	if (cca < 0) {
	testq	%rcx, %rcx	# _49
	js	.L204	#,
# inputs/bootstrap/source/falcon-keygen.c:3791: 		if (zint_ucmp(a, m, len) >= 0) {
	movq	%r13, %rdx	# len,
	movq	%r14, %rsi	# m,
	movq	%rbp, %rdi	# a,
	call	zint_ucmp	#
# inputs/bootstrap/source/falcon-keygen.c:3791: 		if (zint_ucmp(a, m, len) >= 0) {
	testl	%eax, %eax	# tmp214
	jns	.L199	#,
.L196:
# inputs/bootstrap/source/falcon-keygen.c:3795: 	if (ccb < 0) {
	testq	%r12, %r12	# ccb
	js	.L205	#,
.L197:
# inputs/bootstrap/source/falcon-keygen.c:3798: 		if (zint_ucmp(b, m, len) >= 0) {
	movq	%r13, %rdx	# len,
	movq	%r14, %rsi	# m,
	movq	%rbx, %rdi	# b,
	call	zint_ucmp	#
# inputs/bootstrap/source/falcon-keygen.c:3798: 		if (zint_ucmp(b, m, len) >= 0) {
	testl	%eax, %eax	# tmp215
	jns	.L206	#,
.L191:
# inputs/bootstrap/source/falcon-keygen.c:3802: }
	addq	$24, %rsp	#,
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
.L204:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:3789: 		zint_add(a, m, len);
	movq	%rsi, %rdx	# u,
	movq	%r14, %rsi	# m,
	movq	%rbp, %rdi	# a,
	call	zint_add	#
	jmp	.L196	#
.L205:
# inputs/bootstrap/source/falcon-keygen.c:3796: 		zint_add(b, m, len);
	movq	%r13, %rdx	# len,
	movq	%r14, %rsi	# m,
	movq	%rbx, %rdi	# b,
	call	zint_add	#
	jmp	.L191	#
.L206:
# inputs/bootstrap/source/falcon-keygen.c:3799: 			zint_sub(b, m, len);
	movq	%r13, %rdx	# len,
	movq	%r14, %rsi	# m,
	movq	%rbx, %rdi	# b,
	call	zint_sub	#
# inputs/bootstrap/source/falcon-keygen.c:3802: }
	jmp	.L191	#
.L192:
# inputs/bootstrap/source/falcon-keygen.c:3780: 	a[len - 1] = (uint32_t)cca & 0x7FFFFFFF;
	movl	$0, -4(%rbp)	#, MEM[(uint32_t *)a_70(D) + -4B]
# inputs/bootstrap/source/falcon-keygen.c:3781: 	b[len - 1] = (uint32_t)ccb & 0x7FFFFFFF;
	movl	$0, -4(%rbx)	#, MEM[(uint32_t *)b_72(D) + -4B]
# inputs/bootstrap/source/falcon-keygen.c:3791: 		if (zint_ucmp(a, m, len) >= 0) {
	movq	%r13, %rdx	# len,
	movq	%r14, %rsi	# m,
	movq	%rbp, %rdi	# a,
	call	zint_ucmp	#
# inputs/bootstrap/source/falcon-keygen.c:3791: 		if (zint_ucmp(a, m, len) >= 0) {
	testl	%eax, %eax	# tmp216
	js	.L197	#,
# inputs/bootstrap/source/falcon-keygen.c:3745: 	ccb = 0;
	movl	$0, %r12d	#, ccb
.L199:
# inputs/bootstrap/source/falcon-keygen.c:3792: 			zint_sub(a, m, len);
	movq	%r13, %rdx	# len,
	movq	%r14, %rsi	# m,
	movq	%rbp, %rdi	# a,
	call	zint_sub	#
	jmp	.L196	#
	.cfi_endproc
.LFE68:
	.size	zint_co_reduce_mod, .-zint_co_reduce_mod
	.type	zint_reduce, @function
zint_reduce:
.LFB69:
	.cfi_startproc
	movq	%rsi, %r9	# tmp149, b
	movq	%rdx, %r10	# tmp150, len
# inputs/bootstrap/source/falcon-keygen.c:3815: 	for (u = 0; u < len; u ++) {
	testq	%rdx, %rdx	# len
	je	.L208	#,
# inputs/bootstrap/source/falcon-keygen.c:3814: 	cc = 0;
	movl	$0, %esi	#, cc
# inputs/bootstrap/source/falcon-keygen.c:3815: 	for (u = 0; u < len; u ++) {
	movl	$0, %edx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3822: 		z = (int64_t)wb * k + (int64_t)wa + cc;
	movslq	%ecx, %rcx	# k, _7
	jmp	.L210	#
	.p2align 6
.L209:
# inputs/bootstrap/source/falcon-keygen.c:3826: 		tt = (uint32_t)((uint64_t)z >> 31);
	shrq	$31, %rax	#, _17
# inputs/bootstrap/source/falcon-keygen.c:3827: 		cc = *(int32_t *)&tt;
	movl	%eax, %esi	# _17, cc
# inputs/bootstrap/source/falcon-keygen.c:3815: 	for (u = 0; u < len; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3815: 	for (u = 0; u < len; u ++) {
	cmpq	%rdx, %r10	# u, len
	je	.L216	#,
.L210:
# inputs/bootstrap/source/falcon-keygen.c:3822: 		z = (int64_t)wb * k + (int64_t)wa + cc;
	movslq	(%r9,%rdx,4), %rax	# MEM[(const uint32_t *)b_45(D) + u_59 * 4], _6
# inputs/bootstrap/source/falcon-keygen.c:3822: 		z = (int64_t)wb * k + (int64_t)wa + cc;
	imulq	%rcx, %rax	# _7, _8
# inputs/bootstrap/source/falcon-keygen.c:3822: 		z = (int64_t)wb * k + (int64_t)wa + cc;
	movslq	(%rdi,%rdx,4), %r8	# MEM[(uint32_t *)a_38(D) + u_59 * 4], _9
# inputs/bootstrap/source/falcon-keygen.c:3822: 		z = (int64_t)wb * k + (int64_t)wa + cc;
	addq	%r8, %rax	# _9, _10
# inputs/bootstrap/source/falcon-keygen.c:3822: 		z = (int64_t)wb * k + (int64_t)wa + cc;
	movslq	%esi, %rsi	# cc, _11
# inputs/bootstrap/source/falcon-keygen.c:3822: 		z = (int64_t)wb * k + (int64_t)wa + cc;
	addq	%rsi, %rax	# _11, z
# inputs/bootstrap/source/falcon-keygen.c:3823: 		if (u > 0) {
	testq	%rdx, %rdx	# u
	je	.L209	#,
# inputs/bootstrap/source/falcon-keygen.c:3824: 			a[u - 1] = (uint32_t)z & 0x7FFFFFFF;
	movl	%eax, %esi	# z, tmp141
	andl	$2147483647, %esi	#, tmp141
	movl	%esi, -4(%rdi,%rdx,4)	# tmp141, MEM[(uint32_t *)a_38(D) + -4B + u_59 * 4]
	jmp	.L209	#
.L216:
# inputs/bootstrap/source/falcon-keygen.c:3829: 	a[len - 1] = (uint32_t)cc;
	salq	$2, %rdx	#, _18
# inputs/bootstrap/source/falcon-keygen.c:3829: 	a[len - 1] = (uint32_t)cc;
	movl	%eax, -4(%rdi,%rdx)	# _17, *_20
# inputs/bootstrap/source/falcon-keygen.c:3843: 		return 0;
	movl	$0, %ecx	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3830: 	if (cc < 0) {
	testl	%eax, %eax	# _17
	js	.L217	#,
.L207:
# inputs/bootstrap/source/falcon-keygen.c:3845: }
	movl	%ecx, %eax	# <retval>,
	ret	
.L217:
	movq	%rdi, %rcx	# a, ivtmp.558
	addq	%rdi, %rdx	# a, _68
# inputs/bootstrap/source/falcon-keygen.c:3833: 		c = 1;
	movl	$1, %edi	#, c
	.p2align 5
.L212:
# inputs/bootstrap/source/falcon-keygen.c:3837: 			w = c + ~a[u];
	movl	(%rcx), %esi	# MEM[(uint32_t *)_57], _24
# inputs/bootstrap/source/falcon-keygen.c:3837: 			w = c + ~a[u];
	leal	-1(%rdi), %eax	#, _34
	subl	%esi, %eax	# _24, w_40
# inputs/bootstrap/source/falcon-keygen.c:3838: 			a[u] = w & 0x7FFFFFFF;
	andl	$2147483647, %eax	#, tmp144
	movl	%eax, (%rcx)	# tmp144, MEM[(uint32_t *)_57]
	subl	%edi, %esi	# c, _51
# inputs/bootstrap/source/falcon-keygen.c:3839: 			c = (~w) >> 31;
	movl	%esi, %edi	# _51, _51
	shrl	$31, %edi	#, _51
# inputs/bootstrap/source/falcon-keygen.c:3834: 		for (u = 0; u < len; u ++) {
	addq	$4, %rcx	#, ivtmp.558
	cmpq	%rdx, %rcx	# _68, ivtmp.558
	jne	.L212	#,
# inputs/bootstrap/source/falcon-keygen.c:3841: 		return 1;
	movl	$1, %ecx	#, <retval>
	jmp	.L207	#
.L208:
# inputs/bootstrap/source/falcon-keygen.c:3829: 	a[len - 1] = (uint32_t)cc;
	movl	$0, -4(%rdi)	#, MEM[(uint32_t *)a_38(D) + -4B]
# inputs/bootstrap/source/falcon-keygen.c:3843: 		return 0;
	movl	$0, %ecx	#, <retval>
	jmp	.L207	#
	.cfi_endproc
.LFE69:
	.size	zint_reduce, .-zint_reduce
	.type	zint_reduce_mod, @function
zint_reduce_mod:
.LFB70:
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
	movq	%rdi, %rbx	# tmp155, a
	movq	%rdx, %r12	# tmp157, m
	movq	%rcx, %rbp	# tmp158, len
# inputs/bootstrap/source/falcon-keygen.c:3859: 	f = ((a[0] + b[0] * (uint32_t)k) * m0i) & 0x7FFFFFFF;
	movl	%r9d, %eax	# k, _4
	imull	(%rsi), %eax	# *b_40(D), _4
# inputs/bootstrap/source/falcon-keygen.c:3859: 	f = ((a[0] + b[0] * (uint32_t)k) * m0i) & 0x7FFFFFFF;
	addl	(%rdi), %eax	# *a_39(D), _5
# inputs/bootstrap/source/falcon-keygen.c:3859: 	f = ((a[0] + b[0] * (uint32_t)k) * m0i) & 0x7FFFFFFF;
	imull	%r8d, %eax	# tmp159, _6
# inputs/bootstrap/source/falcon-keygen.c:3859: 	f = ((a[0] + b[0] * (uint32_t)k) * m0i) & 0x7FFFFFFF;
	andl	$2147483647, %eax	#, f
# inputs/bootstrap/source/falcon-keygen.c:3861: 	for (u = 0; u < len; u ++) {
	testq	%rcx, %rcx	# len
	je	.L219	#,
# inputs/bootstrap/source/falcon-keygen.c:3860: 	cc = 0;
	movl	$0, %ecx	#, cc
# inputs/bootstrap/source/falcon-keygen.c:3861: 	for (u = 0; u < len; u ++) {
	movl	$0, %edx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3868: 		z = (int64_t)wa + (int64_t)wb * (int64_t)k + cc;
	movslq	%r9d, %rdi	# k, _12
# inputs/bootstrap/source/falcon-keygen.c:3869: 		z += (uint64_t)m[u] * (uint64_t)f;
	movl	%eax, %r8d	# f, _19
	jmp	.L221	#
	.p2align 6
.L220:
# inputs/bootstrap/source/falcon-keygen.c:3873: 		tt = (uint32_t)((uint64_t)z >> 31);
	shrq	$31, %rax	#, _27
# inputs/bootstrap/source/falcon-keygen.c:3874: 		cc = *(int32_t *)&tt;
	movl	%eax, %ecx	# _27, cc
# inputs/bootstrap/source/falcon-keygen.c:3861: 	for (u = 0; u < len; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3861: 	for (u = 0; u < len; u ++) {
	cmpq	%rdx, %rbp	# u, len
	je	.L226	#,
.L221:
# inputs/bootstrap/source/falcon-keygen.c:3868: 		z = (int64_t)wa + (int64_t)wb * (int64_t)k + cc;
	movl	(%rsi,%rdx,4), %eax	# MEM[(const uint32_t *)b_40(D) + u_59 * 4], _11
# inputs/bootstrap/source/falcon-keygen.c:3868: 		z = (int64_t)wa + (int64_t)wb * (int64_t)k + cc;
	imulq	%rdi, %rax	# _12, _13
# inputs/bootstrap/source/falcon-keygen.c:3868: 		z = (int64_t)wa + (int64_t)wb * (int64_t)k + cc;
	movl	(%rbx,%rdx,4), %r9d	# MEM[(uint32_t *)a_39(D) + u_59 * 4], _10
# inputs/bootstrap/source/falcon-keygen.c:3868: 		z = (int64_t)wa + (int64_t)wb * (int64_t)k + cc;
	addq	%r9, %rax	# _10, _14
# inputs/bootstrap/source/falcon-keygen.c:3868: 		z = (int64_t)wa + (int64_t)wb * (int64_t)k + cc;
	movslq	%ecx, %rcx	# cc, _15
# inputs/bootstrap/source/falcon-keygen.c:3868: 		z = (int64_t)wa + (int64_t)wb * (int64_t)k + cc;
	addq	%rcx, %rax	# _15, z_51
# inputs/bootstrap/source/falcon-keygen.c:3869: 		z += (uint64_t)m[u] * (uint64_t)f;
	movl	(%r12,%rdx,4), %ecx	# MEM[(const uint32_t *)m_46(D) + u_59 * 4], _18
# inputs/bootstrap/source/falcon-keygen.c:3869: 		z += (uint64_t)m[u] * (uint64_t)f;
	imulq	%r8, %rcx	# _19, _20
# inputs/bootstrap/source/falcon-keygen.c:3869: 		z += (uint64_t)m[u] * (uint64_t)f;
	addq	%rcx, %rax	# _20, _22
# inputs/bootstrap/source/falcon-keygen.c:3870: 		if (u > 0) {
	testq	%rdx, %rdx	# u
	je	.L220	#,
# inputs/bootstrap/source/falcon-keygen.c:3871: 			a[u - 1] = (uint32_t)z & 0x7FFFFFFF;
	movl	%eax, %ecx	# _22, tmp151
	andl	$2147483647, %ecx	#, tmp151
	movl	%ecx, -4(%rbx,%rdx,4)	# tmp151, MEM[(uint32_t *)a_39(D) + -4B + u_59 * 4]
	jmp	.L220	#
.L226:
# inputs/bootstrap/source/falcon-keygen.c:3876: 	a[len - 1] = (uint32_t)cc & 0x7FFFFFFF;
	andl	$2147483647, %ecx	#, tmp153
	movl	%ecx, -4(%rbx,%rdx,4)	# tmp153, *_30
# inputs/bootstrap/source/falcon-keygen.c:3882: 	if (cc < 0) {
	testl	%eax, %eax	# _27
	js	.L227	#,
.L222:
# inputs/bootstrap/source/falcon-keygen.c:3885: 		if (zint_ucmp(a, m, len) >= 0) {
	movq	%rbp, %rdx	# len,
	movq	%r12, %rsi	# m,
	movq	%rbx, %rdi	# a,
	call	zint_ucmp	#
# inputs/bootstrap/source/falcon-keygen.c:3885: 		if (zint_ucmp(a, m, len) >= 0) {
	testl	%eax, %eax	# tmp161
	jns	.L228	#,
.L218:
# inputs/bootstrap/source/falcon-keygen.c:3889: }
	popq	%rbx	#
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp	#
	.cfi_def_cfa_offset 16
	popq	%r12	#
	.cfi_def_cfa_offset 8
	ret	
.L227:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:3883: 		zint_add(a, m, len);
	movq	%r12, %rsi	# m,
	movq	%rbx, %rdi	# a,
	call	zint_add	#
	jmp	.L218	#
.L228:
# inputs/bootstrap/source/falcon-keygen.c:3886: 			zint_sub(a, m, len);
	movq	%rbp, %rdx	# len,
	movq	%r12, %rsi	# m,
	movq	%rbx, %rdi	# a,
	call	zint_sub	#
# inputs/bootstrap/source/falcon-keygen.c:3889: }
	jmp	.L218	#
.L219:
# inputs/bootstrap/source/falcon-keygen.c:3876: 	a[len - 1] = (uint32_t)cc & 0x7FFFFFFF;
	movl	$0, -4(%rdi)	#, MEM[(uint32_t *)a_39(D) + -4B]
	jmp	.L222	#
	.cfi_endproc
.LFE70:
	.size	zint_reduce_mod, .-zint_reduce_mod
	.type	zint_add_scaled_mul_small, @function
zint_add_scaled_mul_small:
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
	movl	56(%rsp), %r13d	# scl, scl
# inputs/bootstrap/source/falcon-keygen.c:4342: 	if (ylen == 0) {
	testq	%rcx, %rcx	# ylen
	je	.L229	#,
	movq	%rsi, %r10	# tmp154, xlen
	movq	%rdx, %rbp	# tmp155, y
	movq	%rcx, %r11	# tmp156, ylen
# inputs/bootstrap/source/falcon-keygen.c:4346: 	ysign = -(y[ylen - 1] >> 30) >> 1;
	movl	-4(%rdx,%rcx,4), %ebx	# *_3, _5
	shrl	$30, %ebx	#, _5
# inputs/bootstrap/source/falcon-keygen.c:4346: 	ysign = -(y[ylen - 1] >> 30) >> 1;
	negl	%ebx	# _6
# inputs/bootstrap/source/falcon-keygen.c:4346: 	ysign = -(y[ylen - 1] >> 30) >> 1;
	shrl	%ebx	# ysign
# inputs/bootstrap/source/falcon-keygen.c:4349: 	for (u = sch; u < xlen; u ++) {
	movl	%r9d, %r9d	# sch, u
# inputs/bootstrap/source/falcon-keygen.c:4349: 	for (u = sch; u < xlen; u ++) {
	cmpq	%rsi, %r9	# xlen, u
	jnb	.L229	#,
	subq	%r9, %r10	# u, _60
	leaq	(%rdi,%r9,4), %r9	#, _50
	movl	$0, %esi	#, ivtmp.579
# inputs/bootstrap/source/falcon-keygen.c:4348: 	cc = 0;
	movl	$0, %r14d	#, cc
# inputs/bootstrap/source/falcon-keygen.c:4347: 	tw = 0;
	movl	$0, %edi	#, tw
# inputs/bootstrap/source/falcon-keygen.c:4360: 		tw = wy >> (31 - scl);
	movl	$31, %r12d	#, tmp143
	subl	%r13d, %r12d	# scl, _11
# inputs/bootstrap/source/falcon-keygen.c:4365: 		z = (int64_t)wys * (int64_t)k + (int64_t)x[u] + cc;
	movslq	%r8d, %r8	# k, _13
	jmp	.L232	#
.L231:
# inputs/bootstrap/source/falcon-keygen.c:4359: 		wys = ((wy << scl) & 0x7FFFFFFF) | tw;
	movl	%r15d, %edx	# iftmp.99_28, _9
	movl	%r13d, %ecx	# scl, tmp162
	sall	%cl, %edx	# tmp162, _9
# inputs/bootstrap/source/falcon-keygen.c:4359: 		wys = ((wy << scl) & 0x7FFFFFFF) | tw;
	andl	$2147483647, %edx	#, _10
# inputs/bootstrap/source/falcon-keygen.c:4359: 		wys = ((wy << scl) & 0x7FFFFFFF) | tw;
	orl	%edi, %edx	# tw, wys
# inputs/bootstrap/source/falcon-keygen.c:4360: 		tw = wy >> (31 - scl);
	movl	%r15d, %edi	# iftmp.99_28, iftmp.99_28
	movl	%r12d, %ecx	# _11, tmp164
	shrl	%cl, %edi	# tmp164, iftmp.99_28
# inputs/bootstrap/source/falcon-keygen.c:4365: 		z = (int64_t)wys * (int64_t)k + (int64_t)x[u] + cc;
	movl	%edx, %eax	# wys, _12
# inputs/bootstrap/source/falcon-keygen.c:4365: 		z = (int64_t)wys * (int64_t)k + (int64_t)x[u] + cc;
	imulq	%r8, %rax	# _13, _14
# inputs/bootstrap/source/falcon-keygen.c:4365: 		z = (int64_t)wys * (int64_t)k + (int64_t)x[u] + cc;
	movl	(%r9,%rsi,4), %edx	# MEM[(uint32_t *)_50 + ivtmp.579_27 * 4], _18
# inputs/bootstrap/source/falcon-keygen.c:4365: 		z = (int64_t)wys * (int64_t)k + (int64_t)x[u] + cc;
	addq	%rdx, %rax	# _18, _19
# inputs/bootstrap/source/falcon-keygen.c:4365: 		z = (int64_t)wys * (int64_t)k + (int64_t)x[u] + cc;
	movslq	%r14d, %r14	# cc, _20
	addq	%r14, %rax	# _20, _21
# inputs/bootstrap/source/falcon-keygen.c:4366: 		x[u] = (uint32_t)z & 0x7FFFFFFF;
	movl	%eax, %edx	# _21, tmp150
	andl	$2147483647, %edx	#, tmp150
	movl	%edx, (%r9,%rsi,4)	# tmp150, MEM[(uint32_t *)_50 + ivtmp.579_27 * 4]
# inputs/bootstrap/source/falcon-keygen.c:4378: 		ccu = (uint32_t)((uint64_t)z >> 31);
	shrq	$31, %rax	#, _24
# inputs/bootstrap/source/falcon-keygen.c:4379: 		cc = *(int32_t *)&ccu;
	movl	%eax, %r14d	# _24, cc
# inputs/bootstrap/source/falcon-keygen.c:4349: 	for (u = sch; u < xlen; u ++) {
	addq	$1, %rsi	#, ivtmp.579
	cmpq	%r10, %rsi	# _60, ivtmp.579
	je	.L229	#,
.L232:
# inputs/bootstrap/source/falcon-keygen.c:4358: 		wy = v < ylen ? y[v] : ysign;
	movl	%ebx, %r15d	# ysign, iftmp.99_28
# inputs/bootstrap/source/falcon-keygen.c:4358: 		wy = v < ylen ? y[v] : ysign;
	cmpq	%r11, %rsi	# ylen, ivtmp.579
	jnb	.L231	#,
# inputs/bootstrap/source/falcon-keygen.c:4358: 		wy = v < ylen ? y[v] : ysign;
	movl	0(%rbp,%rsi,4), %r15d	# MEM[(const uint32_t *)y_32(D) + ivtmp.579_27 * 4], iftmp.99_28
	jmp	.L231	#
.L229:
# inputs/bootstrap/source/falcon-keygen.c:4381: }
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
	.size	zint_add_scaled_mul_small, .-zint_add_scaled_mul_small
	.type	poly_big_to_small, @function
poly_big_to_small:
.LFB80:
	.cfi_startproc
	movq	%rdi, %r8	# tmp123, d
	movq	%rsi, %rdi	# tmp124, s
# inputs/bootstrap/source/falcon-keygen.c:4497: 	n = MKN(logn, ter);
	leal	1(%rcx,%rcx), %esi	#, _3
	subl	%ecx, %edx	# ter, _4
# inputs/bootstrap/source/falcon-keygen.c:4497: 	n = MKN(logn, ter);
	movl	%edx, %ecx	# _4, tmp128
	salq	%cl, %rsi	# tmp128, n
# inputs/bootstrap/source/falcon-keygen.c:4498: 	for (u = 0; u < n; u ++) {
	testq	%rsi, %rsi	# n
	je	.L239	#,
# inputs/bootstrap/source/falcon-keygen.c:4498: 	for (u = 0; u < n; u ++) {
	movl	$0, %edx	#, u
	.p2align 6
.L238:
# inputs/bootstrap/source/falcon-keygen.c:4435: 	w = x[0];
	movl	(%rdi,%rdx,4), %ecx	# MEM[(const uint32_t *)s_18(D) + u_28 * 4], _19
# inputs/bootstrap/source/falcon-keygen.c:4436: 	w |= (w & 0x40000000) << 1;
	leal	(%rcx,%rcx), %eax	#, _23
	andl	$-2147483648, %eax	#, _24
# inputs/bootstrap/source/falcon-keygen.c:4436: 	w |= (w & 0x40000000) << 1;
	orl	%ecx, %eax	# _19, _25
# inputs/bootstrap/source/falcon-keygen.c:4502: 		if (z < -2047 || z > 2047) {
	leal	2047(%rax), %ecx	#, _7
# inputs/bootstrap/source/falcon-keygen.c:4502: 		if (z < -2047 || z > 2047) {
	cmpl	$4094, %ecx	#, _7
	ja	.L240	#,
# inputs/bootstrap/source/falcon-keygen.c:4505: 		d[u] = (int16_t)z;
	movw	%ax, (%r8,%rdx,2)	# _25, MEM[(int16_t *)d_20(D) + u_28 * 2]
# inputs/bootstrap/source/falcon-keygen.c:4498: 	for (u = 0; u < n; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:4498: 	for (u = 0; u < n; u ++) {
	cmpq	%rdx, %rsi	# u, n
	jne	.L238	#,
# inputs/bootstrap/source/falcon-keygen.c:4507: 	return 1;
	movl	$1, %eax	#, <retval>
	ret	
.L239:
	movl	$1, %eax	#, <retval>
	ret	
.L240:
# inputs/bootstrap/source/falcon-keygen.c:4503: 			return 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:4508: }
	ret	
	.cfi_endproc
.LFE80:
	.size	poly_big_to_small, .-poly_big_to_small
	.type	poly_sub_scaled, @function
poly_sub_scaled:
.LFB81:
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
	movq	%rdi, 64(%rsp)	# tmp200, %sfp
	movq	%rsi, %r14	# tmp201, Flen
	movq	%rdx, %rsi	# tmp202, Fstride
	movq	%rcx, 96(%rsp)	# tmp203, %sfp
	movq	%r8, (%rsp)	# tmp204, %sfp
	movl	200(%rsp), %edi	# sc, sc
	movl	216(%rsp), %eax	# full, full
# inputs/bootstrap/source/falcon-keygen.c:4528: 	n = MKN(logn, full);
	leal	1(%rax,%rax), %edx	#, _3
	movl	208(%rsp), %ecx	# logn, _4
	subl	%eax, %ecx	# full, _4
# inputs/bootstrap/source/falcon-keygen.c:4528: 	n = MKN(logn, full);
	salq	%cl, %rdx	# _4, _3
	movq	%rdx, %rcx	# _3, n
# inputs/bootstrap/source/falcon-keygen.c:4530: 	sch = sc / 31;
	movl	%edi, %edx	# sc, sc
	imulq	$138547333, %rdx, %rdx	#, sc, tmp163
	shrq	$32, %rdx	#, tmp164
	movl	%edi, %eax	# sc, tmp165
	subl	%edx, %eax	# tmp164, tmp165
	shrl	%eax	# tmp166
	addl	%edx, %eax	# tmp164, tmp167
	shrl	$4, %eax	#, sch
# inputs/bootstrap/source/falcon-keygen.c:4531: 	scl = sc % 31;
	movl	%eax, %edx	# sch, tmp175
	sall	$5, %edx	#, tmp175
	subl	%eax, %edx	# sch, tmp176
	subl	%edx, %edi	# tmp176, sc
	movl	%edi, %r13d	# sc, scl
# inputs/bootstrap/source/falcon-keygen.c:4532: 	if (ternary) {
	cmpl	$0, 224(%rsp)	#, ternary
	jne	.L243	#,
# inputs/bootstrap/source/falcon-keygen.c:4566: 		for (u = 0; u < n; u ++) {
	testq	%rcx, %rcx	# n
	je	.L242	#,
# inputs/bootstrap/source/falcon-keygen.c:4582: 					x += Fstride;
	leaq	0(,%rsi,4), %rbx	#, _29
# inputs/bootstrap/source/falcon-keygen.c:4584: 				y += fstride;
	leaq	0(,%r9,4), %rsi	#, _30
	movq	%rsi, 8(%rsp)	# _30, %sfp
	movq	64(%rsp), %rsi	# %sfp, ivtmp.631
	leaq	(%rcx,%rcx), %rdx	#, _126
	movq	%rdx, 72(%rsp)	# _126, %sfp
	movq	%rcx, %rdx	# n, _124
	negq	%rdx	# _124
	movq	192(%rsp), %rdi	# k, tmp275
	leaq	(%rdi,%rdx,4), %rdi	#, _125
	movq	%rcx, %r15	# n, ivtmp.630
# inputs/bootstrap/source/falcon-keygen.c:4578: 				if (u + v == n - 1) {
	leaq	-1(%rcx), %rdx	#, _28
	movq	%rdx, 16(%rsp)	# _28, %sfp
	movq	%rcx, 80(%rsp)	# n, %sfp
	movl	%eax, 24(%rsp)	# sch, %sfp
	movl	%r13d, 32(%rsp)	# scl, %sfp
	movq	%r14, 40(%rsp)	# Flen, %sfp
	movq	%rbx, %r14	# _29, _29
	jmp	.L254	#
.L243:
# inputs/bootstrap/source/falcon-keygen.c:4529: 	hn = n >> 1;
	movq	%rcx, %rdi	# n, hn
	shrq	%rdi	# hn
# inputs/bootstrap/source/falcon-keygen.c:4535: 		off1 = hn * Fstride;
	movq	%rdi, %r8	# hn, off1
	imulq	%rsi, %r8	# Fstride, off1
# inputs/bootstrap/source/falcon-keygen.c:4536: 		off2 = n * Fstride;
	movq	%rcx, %rdx	# n, off2
	imulq	%rsi, %rdx	# Fstride, off2
	leaq	(%r8,%rdx), %r10	#, _41
# inputs/bootstrap/source/falcon-keygen.c:4538: 		for (u = 0; u < n; u ++) {
	testq	%rcx, %rcx	# n
	je	.L242	#,
# inputs/bootstrap/source/falcon-keygen.c:4546: 			for (v = 0; v < n; v ++, j += Fstride, y += fstride) {
	leaq	0(,%r9,4), %rbx	#, _21
	movq	%rbx, 24(%rsp)	# _21, %sfp
	leaq	(%rcx,%rcx), %rbx	#, _88
	movq	%rbx, 120(%rsp)	# _88, %sfp
	movq	%rcx, %r9	# n, _91
	negq	%r9	# _91
	movq	192(%rsp), %rbx	# k, tmp250
	leaq	(%rbx,%r9,4), %rbx	#, _87
	movq	%rbx, 112(%rsp)	# _87, %sfp
	leaq	0(,%rsi,4), %rbx	#, _38
	movq	%rbx, 32(%rsp)	# _38, %sfp
	negq	%r10	# _90
	leaq	0(,%r10,4), %rbx	#, tmp182
	movq	%rbx, 72(%rsp)	# tmp182, %sfp
	negq	%r8	# _43
	leaq	0(,%r8,4), %rbx	#, tmp185
	movq	%rbx, 80(%rsp)	# tmp185, %sfp
	negq	%rdx	# _34
	salq	$2, %rdx	#, tmp188
	movq	%rdx, 88(%rsp)	# tmp188, %sfp
	movl	$0, %r9d	#, ivtmp.617
# inputs/bootstrap/source/falcon-keygen.c:4551: 				} else if (u + v < (n + hn)) {
	leaq	(%rcx,%rdi), %rdx	#, _11
	movq	%rdx, 56(%rsp)	# _11, %sfp
	movq	%rcx, 16(%rsp)	# n, %sfp
	movl	%eax, 8(%rsp)	# sch, %sfp
	movq	%r14, %rax	# Flen, Flen
	movl	%r13d, %r14d	# scl, scl
	movq	%rcx, %r13	# ivtmp.616, ivtmp.616
	movq	%rsi, 128(%rsp)	# Fstride, %sfp
	movq	%rax, %r15	# Flen, Flen
	jmp	.L250	#
.L261:
# inputs/bootstrap/source/falcon-keygen.c:4548: 					zint_add_scaled_mul_small(
	pushq	%r14	# scl
	.cfi_def_cfa_offset 200
	movl	16(%rsp), %r9d	# %sfp,
	movl	56(%rsp), %r8d	# %sfp,
	movq	8(%rsp), %rcx	# %sfp,
	movq	%rbp, %rdx	# y,
	movq	%r15, %rsi	# Flen,
	movq	%r12, %rdi	# ivtmp.607,
	call	zint_add_scaled_mul_small	#
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 192
	jmp	.L247	#
.L248:
# inputs/bootstrap/source/falcon-keygen.c:4559: 					zint_add_scaled_mul_small(
	movq	72(%rsp), %rax	# %sfp, tmp182
	leaq	(%r12,%rax), %rdi	#, _86
	pushq	%r14	# scl
	.cfi_def_cfa_offset 200
	movl	16(%rsp), %r9d	# %sfp,
	movl	48(%rsp), %r8d	# %sfp,
	movq	8(%rsp), %rcx	# %sfp,
	movq	%rbp, %rdx	# y,
	movq	%r15, %rsi	# Flen,
	call	zint_add_scaled_mul_small	#
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 192
.L247:
# inputs/bootstrap/source/falcon-keygen.c:4546: 			for (v = 0; v < n; v ++, j += Fstride, y += fstride) {
	movq	24(%rsp), %rax	# %sfp, _21
	addq	%rax, %rbp	# _21, y
# inputs/bootstrap/source/falcon-keygen.c:4546: 			for (v = 0; v < n; v ++, j += Fstride, y += fstride) {
	addq	$1, %rbx	#, ivtmp.606
	movq	32(%rsp), %rax	# %sfp, _38
	addq	%rax, %r12	# _38, ivtmp.607
	cmpq	%r13, %rbx	# ivtmp.616, ivtmp.606
	je	.L260	#,
.L249:
# inputs/bootstrap/source/falcon-keygen.c:4547: 				if (u + v < n) {
	movq	16(%rsp), %rax	# %sfp, n
	cmpq	%rax, %rbx	# n, ivtmp.606
	jb	.L261	#,
# inputs/bootstrap/source/falcon-keygen.c:4551: 				} else if (u + v < (n + hn)) {
	movq	56(%rsp), %rax	# %sfp, _11
	cmpq	%rax, %rbx	# _11, ivtmp.606
	jnb	.L248	#,
# inputs/bootstrap/source/falcon-keygen.c:4552: 					zint_add_scaled_mul_small(
	movq	80(%rsp), %rax	# %sfp, tmp185
	leaq	(%r12,%rax), %rdi	#, _35
	pushq	%r14	# scl
	.cfi_def_cfa_offset 200
	movl	16(%rsp), %r9d	# %sfp,
	movl	56(%rsp), %r8d	# %sfp,
	movq	8(%rsp), %rcx	# %sfp,
	movq	%rbp, %rdx	# y,
	movq	%r15, %rsi	# Flen,
	call	zint_add_scaled_mul_small	#
# inputs/bootstrap/source/falcon-keygen.c:4555: 					zint_add_scaled_mul_small(
	movq	96(%rsp), %rax	# %sfp, tmp188
	leaq	(%r12,%rax), %rdi	#, _33
	pushq	%r14	# scl
	.cfi_def_cfa_offset 208
	movl	24(%rsp), %r9d	# %sfp,
	movl	56(%rsp), %r8d	# %sfp,
	movq	16(%rsp), %rcx	# %sfp,
	movq	%rbp, %rdx	# y,
	movq	%r15, %rsi	# Flen,
	call	zint_add_scaled_mul_small	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 192
	jmp	.L247	#
.L260:
# inputs/bootstrap/source/falcon-keygen.c:4538: 		for (u = 0; u < n; u ++) {
	movq	104(%rsp), %r9	# %sfp, ivtmp.617
	addq	$1, %r13	#, ivtmp.616
	movq	128(%rsp), %rax	# %sfp, Fstride
	addq	%rax, %r9	# Fstride, ivtmp.617
	cmpq	%r13, 120(%rsp)	# ivtmp.616, %sfp
	je	.L242	#,
.L250:
	movq	%r13, %rbx	# ivtmp.616, ivtmp.606
	movq	16(%rsp), %rax	# %sfp, n
	subq	%rax, %rbx	# n, ivtmp.606
# inputs/bootstrap/source/falcon-keygen.c:4543: 			kf = -k[u];
	movq	112(%rsp), %rax	# %sfp, _87
	movl	(%rax,%r13,4), %edx	# MEM[(const int32_t *)_87 + ivtmp.616_93 * 4], _7
# inputs/bootstrap/source/falcon-keygen.c:4543: 			kf = -k[u];
	movl	%edx, %eax	# _7, kf
	negl	%eax	# kf
	movl	%eax, 48(%rsp)	# kf, %sfp
	movq	64(%rsp), %rax	# %sfp, F
	leaq	(%rax,%r9,4), %r12	#, ivtmp.607
# inputs/bootstrap/source/falcon-keygen.c:4545: 			y = f;
	movq	96(%rsp), %rbp	# %sfp, y
	movl	%edx, 40(%rsp)	# _7, %sfp
	movq	%r9, 104(%rsp)	# ivtmp.617, %sfp
	jmp	.L249	#
.L252:
# inputs/bootstrap/source/falcon-keygen.c:4584: 				y += fstride;
	movq	8(%rsp), %rax	# %sfp, _30
	addq	%rax, %r12	# _30, y
# inputs/bootstrap/source/falcon-keygen.c:4575: 			for (v = 0; v < n; v ++) {
	addq	$1, %rbx	#, ivtmp.625
	cmpq	%r15, %rbx	# ivtmp.630, ivtmp.625
	je	.L262	#,
.L253:
# inputs/bootstrap/source/falcon-keygen.c:4576: 				zint_add_scaled_mul_small(
	movl	32(%rsp), %eax	# %sfp, scl
	pushq	%rax	# scl
	.cfi_def_cfa_offset 200
	movl	32(%rsp), %r9d	# %sfp,
	movl	%r13d, %r8d	# kf,
	movq	8(%rsp), %rcx	# %sfp,
	movq	%r12, %rdx	# y,
	movq	48(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# x,
	call	zint_add_scaled_mul_small	#
# inputs/bootstrap/source/falcon-keygen.c:4578: 				if (u + v == n - 1) {
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 192
# inputs/bootstrap/source/falcon-keygen.c:4582: 					x += Fstride;
	addq	%r14, %rbp	# _29, x
# inputs/bootstrap/source/falcon-keygen.c:4578: 				if (u + v == n - 1) {
	cmpq	%rbx, 16(%rsp)	# ivtmp.625, %sfp
	jne	.L252	#,
# inputs/bootstrap/source/falcon-keygen.c:4580: 					kf = -kf;
	negl	%r13d	# kf
# inputs/bootstrap/source/falcon-keygen.c:4579: 					x = F;
	movq	64(%rsp), %rbp	# %sfp, x
	jmp	.L252	#
.L262:
# inputs/bootstrap/source/falcon-keygen.c:4566: 		for (u = 0; u < n; u ++) {
	movq	48(%rsp), %rsi	# %sfp, ivtmp.631
	movq	56(%rsp), %rdi	# %sfp, _125
	addq	$1, %r15	#, ivtmp.630
	addq	%r14, %rsi	# _29, ivtmp.631
	movq	72(%rsp), %rax	# %sfp, _126
	cmpq	%rax, %r15	# _126, ivtmp.630
	je	.L242	#,
.L254:
	movq	%r15, %rbx	# ivtmp.630, ivtmp.625
	movq	80(%rsp), %rax	# %sfp, n
	subq	%rax, %rbx	# n, ivtmp.625
# inputs/bootstrap/source/falcon-keygen.c:4572: 			kf = -k[u];
	movl	(%rdi,%r15,4), %r13d	# MEM[(const int32_t *)_125 + ivtmp.630_118 * 4], kf
	negl	%r13d	# kf
# inputs/bootstrap/source/falcon-keygen.c:4573: 			x = F + u * Fstride;
	movq	%rsi, %rbp	# ivtmp.631, x
# inputs/bootstrap/source/falcon-keygen.c:4574: 			y = f;
	movq	96(%rsp), %r12	# %sfp, y
	movq	%rsi, 48(%rsp)	# ivtmp.631, %sfp
	movq	%rdi, 56(%rsp)	# _125, %sfp
	jmp	.L253	#
.L242:
# inputs/bootstrap/source/falcon-keygen.c:4588: }
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
.LFE81:
	.size	poly_sub_scaled, .-poly_sub_scaled
	.type	poly_small_sqnorm, @function
poly_small_sqnorm:
.LFB93:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:5299: 	n = MKN(logn, ter);
	leal	1(%rdx,%rdx), %eax	#, _3
	subl	%edx, %esi	# ter, tmp129
	movl	%esi, %ecx	# tmp129, _4
# inputs/bootstrap/source/falcon-keygen.c:5299: 	n = MKN(logn, ter);
	salq	%cl, %rax	# _4, n
# inputs/bootstrap/source/falcon-keygen.c:5302: 	for (u = 0; u < n; u ++) {
	testq	%rax, %rax	# n
	je	.L266	#,
	movq	%rdi, %rcx	# f, ivtmp.637
	leaq	(%rdi,%rax,2), %rdi	#, _36
# inputs/bootstrap/source/falcon-keygen.c:5301: 	ng = 0;
	movl	$0, %eax	#, ng
# inputs/bootstrap/source/falcon-keygen.c:5300: 	s = 0;
	movl	$0, %esi	#, s
	.p2align 5
.L265:
# inputs/bootstrap/source/falcon-keygen.c:5305: 		z = f[u];
	movswl	(%rcx), %edx	# MEM[(const int16_t *)_28], z
# inputs/bootstrap/source/falcon-keygen.c:5306: 		s += (uint32_t)(z * z);
	imull	%edx, %edx	# z, _8
# inputs/bootstrap/source/falcon-keygen.c:5306: 		s += (uint32_t)(z * z);
	addl	%edx, %esi	# _8, s
# inputs/bootstrap/source/falcon-keygen.c:5307: 		ng |= s;
	orl	%esi, %eax	# s, ng
# inputs/bootstrap/source/falcon-keygen.c:5302: 	for (u = 0; u < n; u ++) {
	addq	$2, %rcx	#, ivtmp.637
	cmpq	%rdi, %rcx	# _36, ivtmp.637
	jne	.L265	#,
.L264:
# inputs/bootstrap/source/falcon-keygen.c:5309: 	return s | -(ng >> 31);
	sarl	$31, %eax	#, _11
# inputs/bootstrap/source/falcon-keygen.c:5309: 	return s | -(ng >> 31);
	orl	%esi, %eax	# s, _19
# inputs/bootstrap/source/falcon-keygen.c:5310: }
	ret	
.L266:
# inputs/bootstrap/source/falcon-keygen.c:5301: 	ng = 0;
	movl	$0, %eax	#, ng
# inputs/bootstrap/source/falcon-keygen.c:5300: 	s = 0;
	movl	$0, %esi	#, s
	jmp	.L264	#
	.cfi_endproc
.LFE93:
	.size	poly_small_sqnorm, .-poly_small_sqnorm
	.type	align_fpr, @function
align_fpr:
.LFB94:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:5324: 	k = (size_t)(cd - cb);
	subq	%rdi, %rsi	# base, _1
# inputs/bootstrap/source/falcon-keygen.c:5325: 	km = k % sizeof(fpr);
	movq	%rsi, %rdx	# _1, km
	andl	$7, %edx	#, km
# inputs/bootstrap/source/falcon-keygen.c:5327: 		k += (sizeof(fpr)) - km;
	leaq	8(%rsi), %rax	#, _13
	subq	%rdx, %rax	# km, tmp108
	testq	%rdx, %rdx	# km
	cmovne	%rax, %rsi	# tmp108,, k
# inputs/bootstrap/source/falcon-keygen.c:5329: 	return (fpr *)(cb + k);
	leaq	(%rdi,%rsi), %rax	#, _10
# inputs/bootstrap/source/falcon-keygen.c:5330: }
	ret	
	.cfi_endproc
.LFE94:
	.size	align_fpr, .-align_fpr
	.type	ft_stable_positive_keygen, @function
ft_stable_positive_keygen:
.LFB111:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:7475: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	movq	%rdi, %rdx	# x, tmp139
	notq	%rdx	# tmp139
	movabsq	$9218868437227405312, %rax	#, tmp119
	testq	%rax, %rdx	# tmp119, tmp139
	je	.L272	#,
	testq	%rdi, %rdi	# x
	js	.L272	#,
# inputs/bootstrap/source/falcon-keygen.c:7475: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	movq	%rdi, %rax	# x, tmp140
	addq	%rax, %rax	# tmp140
	setne	%dl	#, iftmp.109_20
	movzbl	%dl, %edx	# iftmp.109_20, iftmp.109_20
.L271:
# inputs/bootstrap/source/falcon-keygen.c:7484: 	*bad |= valid ^ 1U;
	movl	%edx, %eax	# iftmp.109_20, _22
	xorl	$1, %eax	#, _22
# inputs/bootstrap/source/falcon-keygen.c:7484: 	*bad |= valid ^ 1U;
	orl	%eax, (%rsi)	# _22, *bad_12(D)
# inputs/bootstrap/source/falcon-keygen.c:7485: 	mask = (uint64_t)0 - (uint64_t)valid;
	movl	%edx, %edx	# iftmp.109_20, _4
# inputs/bootstrap/source/falcon-keygen.c:7488: 		(xb & mask) | (ft_fpr_bits_keygen(fpr_one) & ~mask));
	leaq	-1(%rdx), %rax	#, _21
	movabsq	$4607182418800017408, %rcx	#, tmp134
	andq	%rcx, %rax	# tmp134, _6
# inputs/bootstrap/source/falcon-keygen.c:7488: 		(xb & mask) | (ft_fpr_bits_keygen(fpr_one) & ~mask));
	negq	%rdx	# tmp135
	andq	%rdi, %rdx	# x, _5
# inputs/bootstrap/source/falcon-keygen.c:7487: 	return ft_fpr_from_bits_keygen(
	orq	%rdx, %rax	# _5, _7
# inputs/bootstrap/source/falcon-keygen.c:7489: }
	ret	
.L272:
# inputs/bootstrap/source/falcon-keygen.c:7475: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	movl	$0, %edx	#, iftmp.109_20
	jmp	.L271	#
	.cfi_endproc
.LFE111:
	.size	ft_stable_positive_keygen, .-ft_stable_positive_keygen
	.type	sample_true_ternary_secret, @function
sample_true_ternary_secret:
.LFB84:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:4765: 	for (u = 0; u < n; u ++) {
	testq	%rdx, %rdx	# n
	je	.L281	#,
# inputs/bootstrap/source/falcon-keygen.c:4755: {
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
	subq	$16, %rsp	#,
	.cfi_def_cfa_offset 64
	movq	%rdi, %rbp	# tmp114, fk
	movq	%rsi, %r14	# tmp115, v
	movq	%rdx, %r13	# tmp116, n
# inputs/bootstrap/source/falcon-keygen.c:4764: 	rbits = 0;
	movl	$0, %edx	#, rbits
# inputs/bootstrap/source/falcon-keygen.c:4763: 	rb = 0;
	movl	$0, %eax	#, rb
# inputs/bootstrap/source/falcon-keygen.c:4765: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
# inputs/bootstrap/source/falcon-keygen.c:4720: 	shake_extract(rng, &r, sizeof r);
	leaq	8(%rsp), %r12	#, tmp113
	jmp	.L276	#
	.p2align 5
.L275:
# inputs/bootstrap/source/falcon-keygen.c:4773: 			x = (uint32_t)rb & 3U;
	movl	%eax, %ecx	# rb, x
	andl	$3, %ecx	#, x
# inputs/bootstrap/source/falcon-keygen.c:4774: 			rb >>= 2;
	shrq	$2, %rax	#, rb
# inputs/bootstrap/source/falcon-keygen.c:4775: 			rbits -= 2;
	subl	$2, %edx	#, rbits
# inputs/bootstrap/source/falcon-keygen.c:4776: 			if (x < 3U) {
	cmpl	$2, %ecx	#, x
	jbe	.L284	#,
.L276:
# inputs/bootstrap/source/falcon-keygen.c:4769: 			if (rbits < 2) {
	cmpl	$1, %edx	#, rbits
	ja	.L275	#,
# inputs/bootstrap/source/falcon-keygen.c:4770: 				rb = get_rng_u64(&fk->rng);
	leaq	8(%rbp), %rdi	#, _1
# inputs/bootstrap/source/falcon-keygen.c:4720: 	shake_extract(rng, &r, sizeof r);
	movl	$8, %edx	#,
	movq	%r12, %rsi	# tmp113,
	call	shake_extract@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:4721: 	return r;
	movq	8(%rsp), %rax	# r, rb
# inputs/bootstrap/source/falcon-keygen.c:4771: 				rbits = 64;
	movl	$64, %edx	#, rbits
	jmp	.L275	#
.L284:
# inputs/bootstrap/source/falcon-keygen.c:4777: 				v[u] = (int16_t)((int)x - 1);
	subl	$1, %ecx	#, tmp112
	movw	%cx, (%r14,%rbx,2)	# tmp112, MEM[(int16_t *)v_24(D) + u_34 * 2]
# inputs/bootstrap/source/falcon-keygen.c:4765: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-keygen.c:4765: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r13	# u, n
	jne	.L276	#,
# inputs/bootstrap/source/falcon-keygen.c:4813: }
	addq	$16, %rsp	#,
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
.L281:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	ret	
	.cfi_endproc
.LFE84:
	.size	sample_true_ternary_secret, .-sample_true_ternary_secret
	.type	poly_small_mkgauss, @function
poly_small_mkgauss:
.LFB106:
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
	movq	%rdi, %r15	# tmp153, fk
	movl	%edx, %eax	# tmp155, logn
# inputs/bootstrap/source/falcon-keygen.c:7411: 	n = MKN(logn, 0);
	movl	$1, %edx	#, tmp128
	movl	%eax, %ecx	# logn, tmp173
	salq	%cl, %rdx	# tmp173, tmp128
# inputs/bootstrap/source/falcon-keygen.c:4854: 	g = 1U << (10 - logn);
	movl	$10, %ecx	#, tmp130
	subl	%eax, %ecx	# logn, _24
# inputs/bootstrap/source/falcon-keygen.c:4854: 	g = 1U << (10 - logn);
	movl	$1, %eax	#, tmp131
	sall	%cl, %eax	# _24, tmp131
	movl	%eax, 12(%rsp)	# tmp131, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7412: 	mod2 = 0;
	movl	$0, 36(%rsp)	#, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7413: 	for (u = 0; u < n; u ++) {
	movl	$0, %eax	#, u
# inputs/bootstrap/source/falcon-keygen.c:4869: 		while (gauss_1024_12289[k] > r) {
	movq	%rdx, 24(%rsp)	# n, %sfp
	movq	%rsi, 40(%rsp)	# f, %sfp
	jmp	.L293	#
.L294:
# inputs/bootstrap/source/falcon-keygen.c:4868: 		k = 1;
	movl	$1, %edx	#, k
.L288:
# inputs/bootstrap/source/falcon-keygen.c:4861: 		neg = (int)(r >> 63);
	shrq	$63, %rbx	#, _28
# inputs/bootstrap/source/falcon-keygen.c:4872: 		k *= (int)(1 - (neg << 1));
	addl	%ebx, %ebx	# _36
# inputs/bootstrap/source/falcon-keygen.c:4872: 		k *= (int)(1 - (neg << 1));
	movl	$1, %eax	#, tmp143
	subl	%ebx, %eax	# _36, _37
# inputs/bootstrap/source/falcon-keygen.c:4872: 		k *= (int)(1 - (neg << 1));
	imull	%edx, %eax	# k, k_38
# inputs/bootstrap/source/falcon-keygen.c:4873: 		val += k;
	addl	%eax, 32(%rsp)	# k_38, %sfp
.L287:
# inputs/bootstrap/source/falcon-keygen.c:4856: 	for (u = 0; u < g; u ++) {
	addl	$1, %ebp	#, u
# inputs/bootstrap/source/falcon-keygen.c:4856: 	for (u = 0; u < g; u ++) {
	cmpl	%ebp, 12(%rsp)	# u, %sfp
	je	.L300	#,
.L290:
# inputs/bootstrap/source/falcon-keygen.c:4860: 		r = get_rng_u64(&fk->rng);
	leaq	8(%r15), %r13	#, _26
# inputs/bootstrap/source/falcon-keygen.c:4720: 	shake_extract(rng, &r, sizeof r);
	leaq	56(%rsp), %rsi	#, tmp132
	movl	$8, %edx	#,
	movq	%r13, %rdi	# _26,
	call	shake_extract@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:4721: 	return r;
	movq	56(%rsp), %rbx	# MEM[(long unsigned int *)_41], _27
# inputs/bootstrap/source/falcon-keygen.c:4862: 		r &= ~((uint64_t)1 << 63);
	movabsq	$9223372036854775807, %rax	#, r_30
	andq	%rbx, %rax	# _27, r_30
# inputs/bootstrap/source/falcon-keygen.c:4863: 		if (r < gauss_1024_12289[0]) {
	cmpq	%rax, %r14	# r_30, tmp135
	jnb	.L287	#,
# inputs/bootstrap/source/falcon-keygen.c:4720: 	shake_extract(rng, &r, sizeof r);
	leaq	56(%rsp), %rsi	#, tmp136
	movl	$8, %edx	#,
	movq	%r13, %rdi	# _26,
	call	shake_extract@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:4867: 		r &= ~((uint64_t)1 << 63);
	movabsq	$9223372036854775807, %rcx	#, r
	andq	56(%rsp), %rcx	# MEM[(long unsigned int *)_41], r
# inputs/bootstrap/source/falcon-keygen.c:4869: 		while (gauss_1024_12289[k] > r) {
	movabsq	$6416574995475331443, %rax	#, tmp177
	cmpq	%rcx, %rax	# r, tmp177
	jb	.L294	#,
	movl	$2, %eax	#, ivtmp.652
	.p2align 4
.L289:
	movq	%rax, %rdx	# ivtmp.652, ivtmp.652
	addq	$1, %rax	#, ivtmp.652
	cmpq	(%r12,%rax,8), %rcx	# MEM[(long unsigned int *)&gauss_1024_12289 + -8B + ivtmp.652_18 * 8], r
	jb	.L289	#,
	jmp	.L288	#
.L300:
# inputs/bootstrap/source/falcon-keygen.c:7418: 		if (u == n - 1) {
	movq	24(%rsp), %rax	# %sfp, n
	subq	$1, %rax	#, _1
# inputs/bootstrap/source/falcon-keygen.c:7418: 		if (u == n - 1) {
	movq	16(%rsp), %rdi	# %sfp, u
	cmpq	%rdi, %rax	# u, _1
	jne	.L291	#,
# inputs/bootstrap/source/falcon-keygen.c:7419: 			if ((mod2 ^ (unsigned)(s & 1)) == 0) {
	movl	32(%rsp), %eax	# %sfp, _14
	andl	$1, %eax	#, _14
# inputs/bootstrap/source/falcon-keygen.c:7419: 			if ((mod2 ^ (unsigned)(s & 1)) == 0) {
	movl	36(%rsp), %edi	# %sfp, mod2
	cmpl	%edi, %eax	# mod2, _14
	jne	.L301	#,
.L286:
# inputs/bootstrap/source/falcon-keygen.c:4856: 	for (u = 0; u < g; u ++) {
	movl	$0, %ebp	#, u
# inputs/bootstrap/source/falcon-keygen.c:4855: 	val = 0;
	movl	$0, 32(%rsp)	#, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4869: 		while (gauss_1024_12289[k] > r) {
	leaq	-8+gauss_1024_12289(%rip), %r12	#, tmp149
	jmp	.L290	#
.L301:
	movq	16(%rsp), %rax	# %sfp, u
	movl	32(%rsp), %edi	# %sfp, val
	jmp	.L292	#
.L291:
# inputs/bootstrap/source/falcon-keygen.c:7423: 			mod2 ^= (unsigned)(s & 1);
	movq	16(%rsp), %rax	# %sfp, u
	movl	32(%rsp), %edi	# %sfp, val
	movl	%edi, %edx	# val, _15
	andl	$1, %edx	#, _15
# inputs/bootstrap/source/falcon-keygen.c:7423: 			mod2 ^= (unsigned)(s & 1);
	xorl	%edx, 36(%rsp)	# _15, %sfp
.L292:
# inputs/bootstrap/source/falcon-keygen.c:7425: 		f[u] = s;
	movq	40(%rsp), %rsi	# %sfp, f
	movw	%di, (%rsi,%rax,2)	# val, MEM[(int16_t *)f_21(D) + u_56 * 2]
# inputs/bootstrap/source/falcon-keygen.c:7413: 	for (u = 0; u < n; u ++) {
	addq	$1, %rax	#, u
# inputs/bootstrap/source/falcon-keygen.c:7413: 	for (u = 0; u < n; u ++) {
	cmpq	%rax, 24(%rsp)	# u, %sfp
	je	.L302	#,
.L293:
# inputs/bootstrap/source/falcon-keygen.c:4863: 		if (r < gauss_1024_12289[0]) {
	movabsq	$1283868770400643927, %r14	#, tmp135
	movq	%rax, 16(%rsp)	# u, %sfp
	jmp	.L286	#
.L302:
# inputs/bootstrap/source/falcon-keygen.c:7427: }
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
.LFE106:
	.size	poly_small_mkgauss, .-poly_small_mkgauss
	.type	mod2_res_ternary, @function
mod2_res_ternary:
.LFB36:
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
	subq	$272, %rsp	#,
	.cfi_def_cfa_offset 328
	movq	%rdi, %r9	# tmp721, f
# inputs/bootstrap/source/falcon-keygen.c:566: 	n = MKN(logn, 1);
	leal	-1(%rsi), %ecx	#, _1
# inputs/bootstrap/source/falcon-keygen.c:566: 	n = MKN(logn, 1);
	movl	$3, %r8d	#, tmp507
	salq	%cl, %r8	# _1, n
# inputs/bootstrap/source/falcon-keygen.c:567: 	memset(b, 0, sizeof b);
	leaq	-120(%rsp), %rdx	#, tmp508
	movl	$48, %ecx	#, tmp511
	movl	$0, %eax	#, tmp510
	movq	%rdx, %rdi	# tmp508, tmp508
	rep stosq
# inputs/bootstrap/source/falcon-keygen.c:568: 	for (u = 0; u < n; u ++) {
	testq	%r8, %r8	# n
	je	.L304	#,
	.p2align 5
.L305:
# inputs/bootstrap/source/falcon-keygen.c:572: 		b[u >> 5] |= bit << (u & 31);
	movq	%rax, %rdi	# u, _5
	shrq	$5, %rdi	#, _5
# inputs/bootstrap/source/falcon-keygen.c:571: 		bit = (uint32_t)f[u] & 1;
	movzwl	(%r9,%rax,2), %edx	# MEM[(const int16_t *)f_520(D) + u_529 * 2], MEM[(const int16_t *)f_520(D) + u_529 * 2]
	andl	$1, %edx	#, bit_521
# inputs/bootstrap/source/falcon-keygen.c:572: 		b[u >> 5] |= bit << (u & 31);
	movl	%eax, %ecx	# u, tmp724
	sall	%cl, %edx	# tmp724, _9
# inputs/bootstrap/source/falcon-keygen.c:572: 		b[u >> 5] |= bit << (u & 31);
	orl	%edx, -120(%rsp,%rdi,4)	# _9, b[_5]
# inputs/bootstrap/source/falcon-keygen.c:568: 	for (u = 0; u < n; u ++) {
	addq	$1, %rax	#, u
# inputs/bootstrap/source/falcon-keygen.c:568: 	for (u = 0; u < n; u ++) {
	cmpq	%rax, %r8	# u, n
	jne	.L305	#,
.L304:
# inputs/bootstrap/source/falcon-keygen.c:581: 	switch (logn) {
	subl	$3, %esi	#, tmp517
	cmpl	$8, %esi	#, tmp517
	ja	.L306	#,
	movl	%esi, %esi	# tmp517, tmp518
	leaq	.L308(%rip), %rdx	#, tmp519
	movslq	(%rdx,%rsi,4), %rax	#, tmp521
	addq	%rdx, %rax	# tmp519, tmp522
	jmp	*%rax	# tmp522
	.section	.rodata
	.align 4
	.align 4
.L308:
	.long	.L316-.L308
	.long	.L315-.L308
	.long	.L314-.L308
	.long	.L313-.L308
	.long	.L312-.L308
	.long	.L311-.L308
	.long	.L310-.L308
	.long	.L309-.L308
	.long	.L307-.L308
	.text
.L307:
# inputs/bootstrap/source/falcon-keygen.c:589: 		b[0] ^= b[48] ^ b[72];
	movl	72(%rsp), %r15d	# b[48], _12
# inputs/bootstrap/source/falcon-keygen.c:589: 		b[0] ^= b[48] ^ b[72];
	movl	%r15d, %eax	# _12, _576
	xorl	-120(%rsp), %eax	# b[0], _576
	xorl	168(%rsp), %eax	# b[72], _15
	movl	%eax, -120(%rsp)	# _15, b[0]
# inputs/bootstrap/source/falcon-keygen.c:590: 		b[1] ^= b[49] ^ b[73];
	movl	76(%rsp), %r14d	# b[49], _17
# inputs/bootstrap/source/falcon-keygen.c:590: 		b[1] ^= b[49] ^ b[73];
	movl	%r14d, %eax	# _17, _575
	xorl	-116(%rsp), %eax	# b[1], _575
	xorl	172(%rsp), %eax	# b[73], _20
	movl	%eax, -116(%rsp)	# _20, b[1]
# inputs/bootstrap/source/falcon-keygen.c:591: 		b[2] ^= b[50] ^ b[74];
	movl	80(%rsp), %r13d	# b[50], _22
# inputs/bootstrap/source/falcon-keygen.c:591: 		b[2] ^= b[50] ^ b[74];
	movl	%r13d, %eax	# _22, _574
	xorl	-112(%rsp), %eax	# b[2], _574
	xorl	176(%rsp), %eax	# b[74], _25
	movl	%eax, -112(%rsp)	# _25, b[2]
# inputs/bootstrap/source/falcon-keygen.c:592: 		b[3] ^= b[51] ^ b[75];
	movl	84(%rsp), %r12d	# b[51], _27
# inputs/bootstrap/source/falcon-keygen.c:592: 		b[3] ^= b[51] ^ b[75];
	movl	%r12d, %eax	# _27, _573
	xorl	-108(%rsp), %eax	# b[3], _573
	xorl	180(%rsp), %eax	# b[75], _30
	movl	%eax, -108(%rsp)	# _30, b[3]
# inputs/bootstrap/source/falcon-keygen.c:593: 		b[4] ^= b[52] ^ b[76];
	movl	88(%rsp), %ebp	# b[52], _32
# inputs/bootstrap/source/falcon-keygen.c:593: 		b[4] ^= b[52] ^ b[76];
	movl	%ebp, %eax	# _32, _572
	xorl	-104(%rsp), %eax	# b[4], _572
	xorl	184(%rsp), %eax	# b[76], _35
	movl	%eax, -104(%rsp)	# _35, b[4]
# inputs/bootstrap/source/falcon-keygen.c:594: 		b[5] ^= b[53] ^ b[77];
	movl	92(%rsp), %ebx	# b[53], _37
# inputs/bootstrap/source/falcon-keygen.c:594: 		b[5] ^= b[53] ^ b[77];
	movl	%ebx, %eax	# _37, _571
	xorl	-100(%rsp), %eax	# b[5], _571
	xorl	188(%rsp), %eax	# b[77], _40
	movl	%eax, -100(%rsp)	# _40, b[5]
# inputs/bootstrap/source/falcon-keygen.c:595: 		b[6] ^= b[54] ^ b[78];
	movl	96(%rsp), %r11d	# b[54], _42
# inputs/bootstrap/source/falcon-keygen.c:595: 		b[6] ^= b[54] ^ b[78];
	movl	%r11d, %eax	# _42, _570
	xorl	-96(%rsp), %eax	# b[6], _570
	xorl	192(%rsp), %eax	# b[78], _45
	movl	%eax, -96(%rsp)	# _45, b[6]
# inputs/bootstrap/source/falcon-keygen.c:596: 		b[7] ^= b[55] ^ b[79];
	movl	100(%rsp), %r10d	# b[55], _47
# inputs/bootstrap/source/falcon-keygen.c:596: 		b[7] ^= b[55] ^ b[79];
	movl	%r10d, %eax	# _47, _569
	xorl	-92(%rsp), %eax	# b[7], _569
	xorl	196(%rsp), %eax	# b[79], _50
	movl	%eax, -92(%rsp)	# _50, b[7]
# inputs/bootstrap/source/falcon-keygen.c:597: 		b[8] ^= b[56] ^ b[80];
	movl	104(%rsp), %eax	# b[56], _568
	xorl	-88(%rsp), %eax	# b[8], _568
	xorl	200(%rsp), %eax	# b[80], _55
	movl	%eax, -88(%rsp)	# _55, b[8]
# inputs/bootstrap/source/falcon-keygen.c:598: 		b[9] ^= b[57] ^ b[81];
	movl	108(%rsp), %eax	# b[57], _567
	xorl	-84(%rsp), %eax	# b[9], _567
	xorl	204(%rsp), %eax	# b[81], _60
	movl	%eax, -84(%rsp)	# _60, b[9]
# inputs/bootstrap/source/falcon-keygen.c:599: 		b[10] ^= b[58] ^ b[82];
	movl	112(%rsp), %eax	# b[58], _566
	xorl	-80(%rsp), %eax	# b[10], _566
	xorl	208(%rsp), %eax	# b[82], _65
	movl	%eax, -80(%rsp)	# _65, b[10]
# inputs/bootstrap/source/falcon-keygen.c:600: 		b[11] ^= b[59] ^ b[83];
	movl	116(%rsp), %eax	# b[59], _565
	xorl	-76(%rsp), %eax	# b[11], _565
	xorl	212(%rsp), %eax	# b[83], _70
	movl	%eax, -76(%rsp)	# _70, b[11]
# inputs/bootstrap/source/falcon-keygen.c:601: 		b[12] ^= b[60] ^ b[84];
	movl	120(%rsp), %eax	# b[60], _564
	xorl	-72(%rsp), %eax	# b[12], _564
	xorl	216(%rsp), %eax	# b[84], _75
	movl	%eax, -72(%rsp)	# _75, b[12]
# inputs/bootstrap/source/falcon-keygen.c:602: 		b[13] ^= b[61] ^ b[85];
	movl	124(%rsp), %eax	# b[61], _563
	xorl	-68(%rsp), %eax	# b[13], _563
	xorl	220(%rsp), %eax	# b[85], _80
	movl	%eax, -68(%rsp)	# _80, b[13]
# inputs/bootstrap/source/falcon-keygen.c:603: 		b[14] ^= b[62] ^ b[86];
	movl	128(%rsp), %eax	# b[62], _562
	xorl	-64(%rsp), %eax	# b[14], _562
	xorl	224(%rsp), %eax	# b[86], _85
	movl	%eax, -64(%rsp)	# _85, b[14]
# inputs/bootstrap/source/falcon-keygen.c:604: 		b[15] ^= b[63] ^ b[87];
	movl	132(%rsp), %eax	# b[63], _561
	xorl	-60(%rsp), %eax	# b[15], _561
	xorl	228(%rsp), %eax	# b[87], _90
	movl	%eax, -60(%rsp)	# _90, b[15]
# inputs/bootstrap/source/falcon-keygen.c:605: 		b[16] ^= b[64] ^ b[88];
	movl	136(%rsp), %eax	# b[64], _560
	xorl	-56(%rsp), %eax	# b[16], _560
	xorl	232(%rsp), %eax	# b[88], _95
	movl	%eax, -56(%rsp)	# _95, b[16]
# inputs/bootstrap/source/falcon-keygen.c:606: 		b[17] ^= b[65] ^ b[89];
	movl	140(%rsp), %eax	# b[65], _559
	xorl	-52(%rsp), %eax	# b[17], _559
	xorl	236(%rsp), %eax	# b[89], _100
	movl	%eax, -52(%rsp)	# _100, b[17]
# inputs/bootstrap/source/falcon-keygen.c:607: 		b[18] ^= b[66] ^ b[90];
	movl	144(%rsp), %r9d	# b[66], _102
# inputs/bootstrap/source/falcon-keygen.c:607: 		b[18] ^= b[66] ^ b[90];
	movl	%r9d, %eax	# _102, _558
	xorl	-48(%rsp), %eax	# b[18], _558
	xorl	240(%rsp), %eax	# b[90], _105
	movl	%eax, -48(%rsp)	# _105, b[18]
# inputs/bootstrap/source/falcon-keygen.c:608: 		b[19] ^= b[67] ^ b[91];
	movl	148(%rsp), %r8d	# b[67], _107
# inputs/bootstrap/source/falcon-keygen.c:608: 		b[19] ^= b[67] ^ b[91];
	movl	%r8d, %eax	# _107, _557
	xorl	-44(%rsp), %eax	# b[19], _557
	xorl	244(%rsp), %eax	# b[91], _110
	movl	%eax, -44(%rsp)	# _110, b[19]
# inputs/bootstrap/source/falcon-keygen.c:609: 		b[20] ^= b[68] ^ b[92];
	movl	152(%rsp), %edi	# b[68], _112
# inputs/bootstrap/source/falcon-keygen.c:609: 		b[20] ^= b[68] ^ b[92];
	movl	%edi, %eax	# _112, _556
	xorl	-40(%rsp), %eax	# b[20], _556
	xorl	248(%rsp), %eax	# b[92], _115
	movl	%eax, -40(%rsp)	# _115, b[20]
# inputs/bootstrap/source/falcon-keygen.c:610: 		b[21] ^= b[69] ^ b[93];
	movl	156(%rsp), %esi	# b[69], _117
# inputs/bootstrap/source/falcon-keygen.c:610: 		b[21] ^= b[69] ^ b[93];
	movl	%esi, %eax	# _117, _555
	xorl	-36(%rsp), %eax	# b[21], _555
	xorl	252(%rsp), %eax	# b[93], _120
	movl	%eax, -36(%rsp)	# _120, b[21]
# inputs/bootstrap/source/falcon-keygen.c:611: 		b[22] ^= b[70] ^ b[94];
	movl	160(%rsp), %ecx	# b[70], _122
# inputs/bootstrap/source/falcon-keygen.c:611: 		b[22] ^= b[70] ^ b[94];
	movl	%ecx, %eax	# _122, _554
	xorl	-32(%rsp), %eax	# b[22], _554
	xorl	256(%rsp), %eax	# b[94], _125
	movl	%eax, -32(%rsp)	# _125, b[22]
# inputs/bootstrap/source/falcon-keygen.c:612: 		b[23] ^= b[71] ^ b[95];
	movl	164(%rsp), %edx	# b[71], _127
# inputs/bootstrap/source/falcon-keygen.c:612: 		b[23] ^= b[71] ^ b[95];
	movl	%edx, %eax	# _127, _553
	xorl	-28(%rsp), %eax	# b[23], _553
	xorl	260(%rsp), %eax	# b[95], _130
	movl	%eax, -28(%rsp)	# _130, b[23]
# inputs/bootstrap/source/falcon-keygen.c:613: 		b[24] ^= b[48];
	xorl	%r15d, -24(%rsp)	# _12, b[24]
# inputs/bootstrap/source/falcon-keygen.c:614: 		b[25] ^= b[49];
	xorl	%r14d, -20(%rsp)	# _17, b[25]
# inputs/bootstrap/source/falcon-keygen.c:615: 		b[26] ^= b[50];
	xorl	%r13d, -16(%rsp)	# _22, b[26]
# inputs/bootstrap/source/falcon-keygen.c:616: 		b[27] ^= b[51];
	xorl	%r12d, -12(%rsp)	# _27, b[27]
# inputs/bootstrap/source/falcon-keygen.c:617: 		b[28] ^= b[52];
	xorl	%ebp, -8(%rsp)	# _32, b[28]
# inputs/bootstrap/source/falcon-keygen.c:618: 		b[29] ^= b[53];
	xorl	%ebx, -4(%rsp)	# _37, b[29]
# inputs/bootstrap/source/falcon-keygen.c:619: 		b[30] ^= b[54];
	xorl	%r11d, (%rsp)	# _42, b[30]
# inputs/bootstrap/source/falcon-keygen.c:620: 		b[31] ^= b[55];
	xorl	%r10d, 4(%rsp)	# _47, b[31]
# inputs/bootstrap/source/falcon-keygen.c:621: 		b[32] ^= b[56];
	movl	104(%rsp), %eax	# b[56], tmp756
	xorl	%eax, 8(%rsp)	# tmp756, b[32]
# inputs/bootstrap/source/falcon-keygen.c:622: 		b[33] ^= b[57];
	movl	108(%rsp), %eax	# b[57], tmp757
	xorl	%eax, 12(%rsp)	# tmp757, b[33]
# inputs/bootstrap/source/falcon-keygen.c:623: 		b[34] ^= b[58];
	movl	112(%rsp), %eax	# b[58], tmp758
	xorl	%eax, 16(%rsp)	# tmp758, b[34]
# inputs/bootstrap/source/falcon-keygen.c:624: 		b[35] ^= b[59];
	movl	116(%rsp), %eax	# b[59], tmp759
	xorl	%eax, 20(%rsp)	# tmp759, b[35]
# inputs/bootstrap/source/falcon-keygen.c:625: 		b[36] ^= b[60];
	movl	120(%rsp), %eax	# b[60], tmp760
	xorl	%eax, 24(%rsp)	# tmp760, b[36]
# inputs/bootstrap/source/falcon-keygen.c:626: 		b[37] ^= b[61];
	movl	124(%rsp), %eax	# b[61], tmp761
	xorl	%eax, 28(%rsp)	# tmp761, b[37]
# inputs/bootstrap/source/falcon-keygen.c:627: 		b[38] ^= b[62];
	movl	128(%rsp), %eax	# b[62], tmp762
	xorl	%eax, 32(%rsp)	# tmp762, b[38]
# inputs/bootstrap/source/falcon-keygen.c:628: 		b[39] ^= b[63];
	movl	132(%rsp), %eax	# b[63], tmp763
	xorl	%eax, 36(%rsp)	# tmp763, b[39]
# inputs/bootstrap/source/falcon-keygen.c:629: 		b[40] ^= b[64];
	movl	136(%rsp), %eax	# b[64], tmp764
	xorl	%eax, 40(%rsp)	# tmp764, b[40]
# inputs/bootstrap/source/falcon-keygen.c:630: 		b[41] ^= b[65];
	movl	140(%rsp), %eax	# b[65], tmp765
	xorl	%eax, 44(%rsp)	# tmp765, b[41]
# inputs/bootstrap/source/falcon-keygen.c:631: 		b[42] ^= b[66];
	xorl	%r9d, 48(%rsp)	# _102, b[42]
# inputs/bootstrap/source/falcon-keygen.c:632: 		b[43] ^= b[67];
	xorl	%r8d, 52(%rsp)	# _107, b[43]
# inputs/bootstrap/source/falcon-keygen.c:633: 		b[44] ^= b[68];
	xorl	%edi, 56(%rsp)	# _112, b[44]
# inputs/bootstrap/source/falcon-keygen.c:634: 		b[45] ^= b[69];
	xorl	%esi, 60(%rsp)	# _117, b[45]
# inputs/bootstrap/source/falcon-keygen.c:635: 		b[46] ^= b[70];
	xorl	%ecx, 64(%rsp)	# _122, b[46]
# inputs/bootstrap/source/falcon-keygen.c:636: 		b[47] ^= b[71];
	xorl	%edx, 68(%rsp)	# _127, b[47]
.L309:
# inputs/bootstrap/source/falcon-keygen.c:645: 		b[0] ^= b[24] ^ b[36];
	movl	-24(%rsp), %ebp	# b[24], _180
# inputs/bootstrap/source/falcon-keygen.c:645: 		b[0] ^= b[24] ^ b[36];
	movl	%ebp, %eax	# _180, _552
	xorl	-120(%rsp), %eax	# b[0], _552
	xorl	24(%rsp), %eax	# b[36], _183
	movl	%eax, -120(%rsp)	# _183, b[0]
# inputs/bootstrap/source/falcon-keygen.c:646: 		b[1] ^= b[25] ^ b[37];
	movl	-20(%rsp), %ebx	# b[25], _185
# inputs/bootstrap/source/falcon-keygen.c:646: 		b[1] ^= b[25] ^ b[37];
	movl	%ebx, %eax	# _185, _551
	xorl	-116(%rsp), %eax	# b[1], _551
	xorl	28(%rsp), %eax	# b[37], _188
	movl	%eax, -116(%rsp)	# _188, b[1]
# inputs/bootstrap/source/falcon-keygen.c:647: 		b[2] ^= b[26] ^ b[38];
	movl	-16(%rsp), %r11d	# b[26], _190
# inputs/bootstrap/source/falcon-keygen.c:647: 		b[2] ^= b[26] ^ b[38];
	movl	%r11d, %eax	# _190, _550
	xorl	-112(%rsp), %eax	# b[2], _550
	xorl	32(%rsp), %eax	# b[38], _193
	movl	%eax, -112(%rsp)	# _193, b[2]
# inputs/bootstrap/source/falcon-keygen.c:648: 		b[3] ^= b[27] ^ b[39];
	movl	-12(%rsp), %r10d	# b[27], _195
# inputs/bootstrap/source/falcon-keygen.c:648: 		b[3] ^= b[27] ^ b[39];
	movl	%r10d, %eax	# _195, _549
	xorl	-108(%rsp), %eax	# b[3], _549
	xorl	36(%rsp), %eax	# b[39], _198
	movl	%eax, -108(%rsp)	# _198, b[3]
# inputs/bootstrap/source/falcon-keygen.c:649: 		b[4] ^= b[28] ^ b[40];
	movl	-8(%rsp), %r9d	# b[28], _200
# inputs/bootstrap/source/falcon-keygen.c:649: 		b[4] ^= b[28] ^ b[40];
	movl	%r9d, %eax	# _200, _548
	xorl	-104(%rsp), %eax	# b[4], _548
	xorl	40(%rsp), %eax	# b[40], _203
	movl	%eax, -104(%rsp)	# _203, b[4]
# inputs/bootstrap/source/falcon-keygen.c:650: 		b[5] ^= b[29] ^ b[41];
	movl	-4(%rsp), %r8d	# b[29], _205
# inputs/bootstrap/source/falcon-keygen.c:650: 		b[5] ^= b[29] ^ b[41];
	movl	%r8d, %eax	# _205, _547
	xorl	-100(%rsp), %eax	# b[5], _547
	xorl	44(%rsp), %eax	# b[41], _208
	movl	%eax, -100(%rsp)	# _208, b[5]
# inputs/bootstrap/source/falcon-keygen.c:651: 		b[6] ^= b[30] ^ b[42];
	movl	(%rsp), %edi	# b[30], _210
# inputs/bootstrap/source/falcon-keygen.c:651: 		b[6] ^= b[30] ^ b[42];
	movl	%edi, %eax	# _210, _546
	xorl	-96(%rsp), %eax	# b[6], _546
	xorl	48(%rsp), %eax	# b[42], _213
	movl	%eax, -96(%rsp)	# _213, b[6]
# inputs/bootstrap/source/falcon-keygen.c:652: 		b[7] ^= b[31] ^ b[43];
	movl	4(%rsp), %esi	# b[31], _215
# inputs/bootstrap/source/falcon-keygen.c:652: 		b[7] ^= b[31] ^ b[43];
	movl	%esi, %eax	# _215, _545
	xorl	-92(%rsp), %eax	# b[7], _545
	xorl	52(%rsp), %eax	# b[43], _218
	movl	%eax, -92(%rsp)	# _218, b[7]
# inputs/bootstrap/source/falcon-keygen.c:653: 		b[8] ^= b[32] ^ b[44];
	movl	8(%rsp), %ecx	# b[32], _220
# inputs/bootstrap/source/falcon-keygen.c:653: 		b[8] ^= b[32] ^ b[44];
	movl	%ecx, %eax	# _220, _544
	xorl	-88(%rsp), %eax	# b[8], _544
	xorl	56(%rsp), %eax	# b[44], _223
	movl	%eax, -88(%rsp)	# _223, b[8]
# inputs/bootstrap/source/falcon-keygen.c:654: 		b[9] ^= b[33] ^ b[45];
	movl	12(%rsp), %edx	# b[33], _225
# inputs/bootstrap/source/falcon-keygen.c:654: 		b[9] ^= b[33] ^ b[45];
	movl	%edx, %eax	# _225, _543
	xorl	-84(%rsp), %eax	# b[9], _543
	xorl	60(%rsp), %eax	# b[45], _228
	movl	%eax, -84(%rsp)	# _228, b[9]
# inputs/bootstrap/source/falcon-keygen.c:655: 		b[10] ^= b[34] ^ b[46];
	movl	16(%rsp), %r12d	# b[34], _230
# inputs/bootstrap/source/falcon-keygen.c:655: 		b[10] ^= b[34] ^ b[46];
	movl	%r12d, %eax	# _230, _542
	xorl	-80(%rsp), %eax	# b[10], _542
	xorl	64(%rsp), %eax	# b[46], _233
	movl	%eax, -80(%rsp)	# _233, b[10]
# inputs/bootstrap/source/falcon-keygen.c:656: 		b[11] ^= b[35] ^ b[47];
	movl	20(%rsp), %r13d	# b[35], _235
# inputs/bootstrap/source/falcon-keygen.c:656: 		b[11] ^= b[35] ^ b[47];
	movl	%r13d, %eax	# _235, _541
	xorl	-76(%rsp), %eax	# b[11], _541
	xorl	68(%rsp), %eax	# b[47], _238
	movl	%eax, -76(%rsp)	# _238, b[11]
# inputs/bootstrap/source/falcon-keygen.c:657: 		b[12] ^= b[24];
	xorl	%ebp, -72(%rsp)	# _180, b[12]
# inputs/bootstrap/source/falcon-keygen.c:658: 		b[13] ^= b[25];
	xorl	%ebx, -68(%rsp)	# _185, b[13]
# inputs/bootstrap/source/falcon-keygen.c:659: 		b[14] ^= b[26];
	xorl	%r11d, -64(%rsp)	# _190, b[14]
# inputs/bootstrap/source/falcon-keygen.c:660: 		b[15] ^= b[27];
	xorl	%r10d, -60(%rsp)	# _195, b[15]
# inputs/bootstrap/source/falcon-keygen.c:661: 		b[16] ^= b[28];
	xorl	%r9d, -56(%rsp)	# _200, b[16]
# inputs/bootstrap/source/falcon-keygen.c:662: 		b[17] ^= b[29];
	xorl	%r8d, -52(%rsp)	# _205, b[17]
# inputs/bootstrap/source/falcon-keygen.c:663: 		b[18] ^= b[30];
	xorl	%edi, -48(%rsp)	# _210, b[18]
# inputs/bootstrap/source/falcon-keygen.c:664: 		b[19] ^= b[31];
	xorl	%esi, -44(%rsp)	# _215, b[19]
# inputs/bootstrap/source/falcon-keygen.c:665: 		b[20] ^= b[32];
	xorl	%ecx, -40(%rsp)	# _220, b[20]
# inputs/bootstrap/source/falcon-keygen.c:666: 		b[21] ^= b[33];
	xorl	%edx, -36(%rsp)	# _225, b[21]
# inputs/bootstrap/source/falcon-keygen.c:667: 		b[22] ^= b[34];
	xorl	%r12d, -32(%rsp)	# _230, b[22]
# inputs/bootstrap/source/falcon-keygen.c:668: 		b[23] ^= b[35];
	xorl	%r13d, -28(%rsp)	# _235, b[23]
.L310:
# inputs/bootstrap/source/falcon-keygen.c:678: 		b[0] ^= b[12] ^ b[18];
	movl	-72(%rsp), %esi	# b[12], _264
# inputs/bootstrap/source/falcon-keygen.c:678: 		b[0] ^= b[12] ^ b[18];
	movl	%esi, %eax	# _264, _540
	xorl	-120(%rsp), %eax	# b[0], _540
	xorl	-48(%rsp), %eax	# b[18], _267
	movl	%eax, -120(%rsp)	# _267, b[0]
# inputs/bootstrap/source/falcon-keygen.c:679: 		b[1] ^= b[13] ^ b[19];
	movl	-68(%rsp), %r8d	# b[13], _269
# inputs/bootstrap/source/falcon-keygen.c:679: 		b[1] ^= b[13] ^ b[19];
	movl	%r8d, %eax	# _269, _539
	xorl	-116(%rsp), %eax	# b[1], _539
	xorl	-44(%rsp), %eax	# b[19], _272
	movl	%eax, -116(%rsp)	# _272, b[1]
# inputs/bootstrap/source/falcon-keygen.c:680: 		b[2] ^= b[14] ^ b[20];
	movl	-64(%rsp), %r9d	# b[14], _274
# inputs/bootstrap/source/falcon-keygen.c:680: 		b[2] ^= b[14] ^ b[20];
	movl	%r9d, %eax	# _274, _538
	xorl	-112(%rsp), %eax	# b[2], _538
	xorl	-40(%rsp), %eax	# b[20], _277
	movl	%eax, -112(%rsp)	# _277, b[2]
# inputs/bootstrap/source/falcon-keygen.c:681: 		b[3] ^= b[15] ^ b[21];
	movl	-60(%rsp), %edi	# b[15], _279
# inputs/bootstrap/source/falcon-keygen.c:681: 		b[3] ^= b[15] ^ b[21];
	movl	%edi, %eax	# _279, _537
	xorl	-108(%rsp), %eax	# b[3], _537
	xorl	-36(%rsp), %eax	# b[21], _282
	movl	%eax, -108(%rsp)	# _282, b[3]
# inputs/bootstrap/source/falcon-keygen.c:682: 		b[4] ^= b[16] ^ b[22];
	movl	-56(%rsp), %ecx	# b[16], _284
# inputs/bootstrap/source/falcon-keygen.c:682: 		b[4] ^= b[16] ^ b[22];
	movl	%ecx, %eax	# _284, _536
	xorl	-104(%rsp), %eax	# b[4], _536
	xorl	-32(%rsp), %eax	# b[22], _287
	movl	%eax, -104(%rsp)	# _287, b[4]
# inputs/bootstrap/source/falcon-keygen.c:683: 		b[5] ^= b[17] ^ b[23];
	movl	-52(%rsp), %edx	# b[17], _289
# inputs/bootstrap/source/falcon-keygen.c:683: 		b[5] ^= b[17] ^ b[23];
	movl	%edx, %eax	# _289, _535
	xorl	-100(%rsp), %eax	# b[5], _535
	xorl	-28(%rsp), %eax	# b[23], _292
	movl	%eax, -100(%rsp)	# _292, b[5]
# inputs/bootstrap/source/falcon-keygen.c:684: 		b[6] ^= b[12];
	xorl	%esi, -96(%rsp)	# _264, b[6]
# inputs/bootstrap/source/falcon-keygen.c:685: 		b[7] ^= b[13];
	xorl	%r8d, -92(%rsp)	# _269, b[7]
# inputs/bootstrap/source/falcon-keygen.c:686: 		b[8] ^= b[14];
	xorl	%r9d, -88(%rsp)	# _274, b[8]
# inputs/bootstrap/source/falcon-keygen.c:687: 		b[9] ^= b[15];
	xorl	%edi, -84(%rsp)	# _279, b[9]
# inputs/bootstrap/source/falcon-keygen.c:688: 		b[10] ^= b[16];
	xorl	%ecx, -80(%rsp)	# _284, b[10]
# inputs/bootstrap/source/falcon-keygen.c:689: 		b[11] ^= b[17];
	xorl	%edx, -76(%rsp)	# _289, b[11]
.L311:
# inputs/bootstrap/source/falcon-keygen.c:698: 		b[0] ^= b[6] ^ b[9];
	movl	-96(%rsp), %esi	# b[6], _306
# inputs/bootstrap/source/falcon-keygen.c:698: 		b[0] ^= b[6] ^ b[9];
	movl	%esi, %eax	# _306, _534
	xorl	-120(%rsp), %eax	# b[0], _534
	xorl	-84(%rsp), %eax	# b[9], _309
	movl	%eax, -120(%rsp)	# _309, b[0]
# inputs/bootstrap/source/falcon-keygen.c:699: 		b[1] ^= b[7] ^ b[10];
	movl	-92(%rsp), %ecx	# b[7], _311
# inputs/bootstrap/source/falcon-keygen.c:699: 		b[1] ^= b[7] ^ b[10];
	movl	%ecx, %eax	# _311, _533
	xorl	-116(%rsp), %eax	# b[1], _533
	xorl	-80(%rsp), %eax	# b[10], _314
	movl	%eax, -116(%rsp)	# _314, b[1]
# inputs/bootstrap/source/falcon-keygen.c:700: 		b[2] ^= b[8] ^ b[11];
	movl	-88(%rsp), %edx	# b[8], _316
# inputs/bootstrap/source/falcon-keygen.c:700: 		b[2] ^= b[8] ^ b[11];
	movl	%edx, %eax	# _316, _532
	xorl	-112(%rsp), %eax	# b[2], _532
	xorl	-76(%rsp), %eax	# b[11], _319
	movl	%eax, -112(%rsp)	# _319, b[2]
# inputs/bootstrap/source/falcon-keygen.c:701: 		b[3] ^= b[6];
	xorl	%esi, -108(%rsp)	# _306, b[3]
# inputs/bootstrap/source/falcon-keygen.c:702: 		b[4] ^= b[7];
	xorl	%ecx, -104(%rsp)	# _311, b[4]
# inputs/bootstrap/source/falcon-keygen.c:703: 		b[5] ^= b[8];
	xorl	%edx, -100(%rsp)	# _316, b[5]
.L312:
# inputs/bootstrap/source/falcon-keygen.c:712: 		b[0] ^= b[3] ^ (b[4] >> 16) ^ (b[5] << 16);
	movl	-108(%rsp), %esi	# b[3], _327
# inputs/bootstrap/source/falcon-keygen.c:712: 		b[0] ^= b[3] ^ (b[4] >> 16) ^ (b[5] << 16);
	movl	-104(%rsp), %eax	# b[4], _328
# inputs/bootstrap/source/falcon-keygen.c:712: 		b[0] ^= b[3] ^ (b[4] >> 16) ^ (b[5] << 16);
	movl	-100(%rsp), %ecx	# b[5], _331
# inputs/bootstrap/source/falcon-keygen.c:712: 		b[0] ^= b[3] ^ (b[4] >> 16) ^ (b[5] << 16);
	movl	%esi, %edx	# _327, _525
	xorl	-120(%rsp), %edx	# b[0], _525
# inputs/bootstrap/source/falcon-keygen.c:712: 		b[0] ^= b[3] ^ (b[4] >> 16) ^ (b[5] << 16);
	movl	%eax, %edi	# _328, _329
	shrl	$16, %edi	#, _329
# inputs/bootstrap/source/falcon-keygen.c:712: 		b[0] ^= b[3] ^ (b[4] >> 16) ^ (b[5] << 16);
	xorl	%edi, %edx	# _329, _524
# inputs/bootstrap/source/falcon-keygen.c:712: 		b[0] ^= b[3] ^ (b[4] >> 16) ^ (b[5] << 16);
	movl	%ecx, %edi	# _331, _332
	sall	$16, %edi	#, _332
# inputs/bootstrap/source/falcon-keygen.c:712: 		b[0] ^= b[3] ^ (b[4] >> 16) ^ (b[5] << 16);
	xorl	%edi, %edx	# _332, tmp663
	movl	%edx, -120(%rsp)	# tmp663, b[0]
# inputs/bootstrap/source/falcon-keygen.c:713: 		b[1] ^= (b[4] & 0xFFFF) ^ (b[5] >> 16);
	movzwl	%ax, %edx	# _328, _336
# inputs/bootstrap/source/falcon-keygen.c:713: 		b[1] ^= (b[4] & 0xFFFF) ^ (b[5] >> 16);
	shrl	$16, %ecx	#, _337
# inputs/bootstrap/source/falcon-keygen.c:713: 		b[1] ^= (b[4] & 0xFFFF) ^ (b[5] >> 16);
	xorl	%ecx, %edx	# _337, _338
# inputs/bootstrap/source/falcon-keygen.c:714: 		b[1] ^= (b[3] << 16);
	movl	%esi, %ecx	# _327, _340
	sall	$16, %ecx	#, _340
# inputs/bootstrap/source/falcon-keygen.c:714: 		b[1] ^= (b[3] << 16);
	orl	%ecx, %edx	# _340, tmp669
	xorl	%edx, -116(%rsp)	# tmp669, b[1]
# inputs/bootstrap/source/falcon-keygen.c:715: 		b[2] ^= (b[3] >> 16) ^ (b[4] << 16);
	shldl	$16, %esi, %eax	#, _327, tmp723
# inputs/bootstrap/source/falcon-keygen.c:715: 		b[2] ^= (b[3] >> 16) ^ (b[4] << 16);
	xorl	%eax, -112(%rsp)	# _345, b[2]
.L313:
# inputs/bootstrap/source/falcon-keygen.c:724: 		b[0] ^= (b[1] >> 16) ^ ((b[2] & 0xFF) << 16) ^ (b[2] >> 8);
	movl	-116(%rsp), %ecx	# b[1], _348
# inputs/bootstrap/source/falcon-keygen.c:724: 		b[0] ^= (b[1] >> 16) ^ ((b[2] & 0xFF) << 16) ^ (b[2] >> 8);
	movl	-112(%rsp), %eax	# b[2], _350
# inputs/bootstrap/source/falcon-keygen.c:724: 		b[0] ^= (b[1] >> 16) ^ ((b[2] & 0xFF) << 16) ^ (b[2] >> 8);
	movl	%ecx, %edx	# _348, _349
	shrl	$16, %edx	#, _349
# inputs/bootstrap/source/falcon-keygen.c:724: 		b[0] ^= (b[1] >> 16) ^ ((b[2] & 0xFF) << 16) ^ (b[2] >> 8);
	movl	%eax, %esi	# _350, _354
	shrl	$8, %esi	#, _354
# inputs/bootstrap/source/falcon-keygen.c:724: 		b[0] ^= (b[1] >> 16) ^ ((b[2] & 0xFF) << 16) ^ (b[2] >> 8);
	xorl	%esi, %edx	# _354, _531
	xorl	-120(%rsp), %edx	# b[0], _526
# inputs/bootstrap/source/falcon-keygen.c:724: 		b[0] ^= (b[1] >> 16) ^ ((b[2] & 0xFF) << 16) ^ (b[2] >> 8);
	movl	%eax, %esi	# _350, _351
	sall	$16, %esi	#, _351
	andl	$16711680, %esi	#, _352
# inputs/bootstrap/source/falcon-keygen.c:724: 		b[0] ^= (b[1] >> 16) ^ ((b[2] & 0xFF) << 16) ^ (b[2] >> 8);
	xorl	%esi, %edx	# _352, _356
# inputs/bootstrap/source/falcon-keygen.c:725: 		b[0] ^= ((b[1] << 8) & 0xFF000000);
	movl	%ecx, %esi	# _348, _357
	sall	$8, %esi	#, _357
# inputs/bootstrap/source/falcon-keygen.c:725: 		b[0] ^= ((b[1] << 8) & 0xFF000000);
	andl	$-16777216, %esi	#, _358
# inputs/bootstrap/source/falcon-keygen.c:725: 		b[0] ^= ((b[1] << 8) & 0xFF000000);
	xorl	%esi, %edx	# _358, tmp682
	movl	%edx, -120(%rsp)	# tmp682, b[0]
# inputs/bootstrap/source/falcon-keygen.c:726: 		b[1] ^= (b[1] >> 24) ^ ((b[2] & 0xFF) << 8);
	sall	$8, %eax	#, _361
	movzwl	%ax, %eax	# _361, _362
# inputs/bootstrap/source/falcon-keygen.c:726: 		b[1] ^= (b[1] >> 24) ^ ((b[2] & 0xFF) << 8);
	movl	%ecx, %edx	# _348, _360
	shrl	$24, %edx	#, _360
# inputs/bootstrap/source/falcon-keygen.c:726: 		b[1] ^= (b[1] >> 24) ^ ((b[2] & 0xFF) << 8);
	xorl	%ecx, %edx	# _348, _530
	xorl	%edx, %eax	# _530, _364
# inputs/bootstrap/source/falcon-keygen.c:727: 		b[1] &= 0xFFFF;
	andl	$65535, %eax	#, tmp688
	movl	%eax, -116(%rsp)	# tmp688, b[1]
.L314:
# inputs/bootstrap/source/falcon-keygen.c:736: 		b[0] ^= (b[0] >> 24) ^ ((b[1] & 0x0F) << 8) ^ (b[1] >> 4);
	movl	-120(%rsp), %eax	# b[0], _366
# inputs/bootstrap/source/falcon-keygen.c:736: 		b[0] ^= (b[0] >> 24) ^ ((b[1] & 0x0F) << 8) ^ (b[1] >> 4);
	movl	-116(%rsp), %ecx	# b[1], _368
# inputs/bootstrap/source/falcon-keygen.c:736: 		b[0] ^= (b[0] >> 24) ^ ((b[1] & 0x0F) << 8) ^ (b[1] >> 4);
	movl	%eax, %edx	# _366, _367
	shrl	$24, %edx	#, _367
# inputs/bootstrap/source/falcon-keygen.c:736: 		b[0] ^= (b[0] >> 24) ^ ((b[1] & 0x0F) << 8) ^ (b[1] >> 4);
	movl	%ecx, %esi	# _368, _372
	shrl	$4, %esi	#, _372
# inputs/bootstrap/source/falcon-keygen.c:736: 		b[0] ^= (b[0] >> 24) ^ ((b[1] & 0x0F) << 8) ^ (b[1] >> 4);
	xorl	%esi, %edx	# _372, _405
	xorl	%eax, %edx	# _366, _404
# inputs/bootstrap/source/falcon-keygen.c:736: 		b[0] ^= (b[0] >> 24) ^ ((b[1] & 0x0F) << 8) ^ (b[1] >> 4);
	movl	%ecx, %eax	# _368, _369
	sall	$8, %eax	#, _369
	andl	$3840, %eax	#, _370
# inputs/bootstrap/source/falcon-keygen.c:736: 		b[0] ^= (b[0] >> 24) ^ ((b[1] & 0x0F) << 8) ^ (b[1] >> 4);
	xorl	%eax, %edx	# _370, _374
# inputs/bootstrap/source/falcon-keygen.c:737: 		b[0] ^= ((b[0] >> 12) & 0xFF000) ^ ((b[1] & 0x0F) << 20);
	movl	%edx, %eax	# _374, _375
	shrl	$12, %eax	#, _375
# inputs/bootstrap/source/falcon-keygen.c:737: 		b[0] ^= ((b[0] >> 12) & 0xFF000) ^ ((b[1] & 0x0F) << 20);
	andl	$1044480, %eax	#, _376
# inputs/bootstrap/source/falcon-keygen.c:737: 		b[0] ^= ((b[0] >> 12) & 0xFF000) ^ ((b[1] & 0x0F) << 20);
	sall	$20, %ecx	#, _377
	andl	$15728640, %ecx	#, _378
# inputs/bootstrap/source/falcon-keygen.c:737: 		b[0] ^= ((b[0] >> 12) & 0xFF000) ^ ((b[1] & 0x0F) << 20);
	orl	%ecx, %eax	# _378, _379
# inputs/bootstrap/source/falcon-keygen.c:737: 		b[0] ^= ((b[0] >> 12) & 0xFF000) ^ ((b[1] & 0x0F) << 20);
	xorl	%edx, %eax	# _374, _380
# inputs/bootstrap/source/falcon-keygen.c:738: 		b[0] &= 0xFFFFFF;
	andl	$16777215, %eax	#, tmp701
	movl	%eax, -120(%rsp)	# tmp701, b[0]
.L315:
# inputs/bootstrap/source/falcon-keygen.c:747: 		b[0] ^= ((b[0] >> 12) & 0x3F) ^ ((b[0] >> 18) & 0x3F);
	movl	-120(%rsp), %edx	# b[0], _382
# inputs/bootstrap/source/falcon-keygen.c:747: 		b[0] ^= ((b[0] >> 12) & 0x3F) ^ ((b[0] >> 18) & 0x3F);
	movl	%edx, %eax	# _382, _383
	shrl	$12, %eax	#, _383
# inputs/bootstrap/source/falcon-keygen.c:747: 		b[0] ^= ((b[0] >> 12) & 0x3F) ^ ((b[0] >> 18) & 0x3F);
	movl	%edx, %ecx	# _382, _384
	shrl	$18, %ecx	#, _384
# inputs/bootstrap/source/falcon-keygen.c:747: 		b[0] ^= ((b[0] >> 12) & 0x3F) ^ ((b[0] >> 18) & 0x3F);
	xorl	%ecx, %eax	# _384, _385
	andl	$63, %eax	#, _386
# inputs/bootstrap/source/falcon-keygen.c:747: 		b[0] ^= ((b[0] >> 12) & 0x3F) ^ ((b[0] >> 18) & 0x3F);
	xorl	%edx, %eax	# _382, _387
# inputs/bootstrap/source/falcon-keygen.c:748: 		b[0] ^= ((b[0] >> 6) & 0xFC0);
	movl	%eax, %edx	# _387, _388
	shrl	$6, %edx	#, _388
# inputs/bootstrap/source/falcon-keygen.c:748: 		b[0] ^= ((b[0] >> 6) & 0xFC0);
	andl	$4032, %edx	#, _389
# inputs/bootstrap/source/falcon-keygen.c:748: 		b[0] ^= ((b[0] >> 6) & 0xFC0);
	xorl	%edx, %eax	# _389, _390
# inputs/bootstrap/source/falcon-keygen.c:749: 		b[0] &= 0xFFF;
	andl	$4095, %eax	#, tmp709
	movl	%eax, -120(%rsp)	# tmp709, b[0]
.L316:
# inputs/bootstrap/source/falcon-keygen.c:758: 		b[0] ^= ((b[0] >> 6) & 0x7) ^ ((b[0] >> 9) & 0x7);
	movl	-120(%rsp), %edx	# b[0], _392
# inputs/bootstrap/source/falcon-keygen.c:758: 		b[0] ^= ((b[0] >> 6) & 0x7) ^ ((b[0] >> 9) & 0x7);
	movl	%edx, %eax	# _392, _393
	shrl	$6, %eax	#, _393
# inputs/bootstrap/source/falcon-keygen.c:758: 		b[0] ^= ((b[0] >> 6) & 0x7) ^ ((b[0] >> 9) & 0x7);
	movl	%edx, %ecx	# _392, _394
	shrl	$9, %ecx	#, _394
# inputs/bootstrap/source/falcon-keygen.c:758: 		b[0] ^= ((b[0] >> 6) & 0x7) ^ ((b[0] >> 9) & 0x7);
	xorl	%ecx, %eax	# _394, _395
	andl	$7, %eax	#, _396
# inputs/bootstrap/source/falcon-keygen.c:758: 		b[0] ^= ((b[0] >> 6) & 0x7) ^ ((b[0] >> 9) & 0x7);
	xorl	%edx, %eax	# _392, _397
# inputs/bootstrap/source/falcon-keygen.c:759: 		b[0] ^= ((b[0] >> 3) & 0x38);
	movl	%eax, %edx	# _397, _398
	shrl	$3, %edx	#, _398
# inputs/bootstrap/source/falcon-keygen.c:759: 		b[0] ^= ((b[0] >> 3) & 0x38);
	andl	$56, %edx	#, _399
# inputs/bootstrap/source/falcon-keygen.c:759: 		b[0] ^= ((b[0] >> 3) & 0x38);
	xorl	%edx, %eax	# _399, _400
# inputs/bootstrap/source/falcon-keygen.c:760: 		b[0] &= 0x3F;
	andl	$63, %eax	#, tmp717
	movl	%eax, -120(%rsp)	# tmp717, b[0]
.L306:
# inputs/bootstrap/source/falcon-keygen.c:771: 	return b[0] != 0;
	cmpl	$0, -120(%rsp)	#, b[0]
	setne	%al	#, _403
	movzbl	%al, %eax	# _403, _403
# inputs/bootstrap/source/falcon-keygen.c:772: }
	addq	$272, %rsp	#,
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
.LFE36:
	.size	mod2_res_ternary, .-mod2_res_ternary
	.type	poly_small_to_fp, @function
poly_small_to_fp:
.LFB96:
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
# inputs/bootstrap/source/falcon-keygen.c:5360: 	n = MKN(logn, ter);
	leal	1(%rcx,%rcx), %ebp	#, _3
	subl	%ecx, %edx	# ter, _4
# inputs/bootstrap/source/falcon-keygen.c:5360: 	n = MKN(logn, ter);
	movl	%edx, %ecx	# _4, tmp122
	salq	%cl, %rbp	# tmp122, n
# inputs/bootstrap/source/falcon-keygen.c:5361: 	for (u = 0; u < n; u ++) {
	testq	%rbp, %rbp	# n
	je	.L319	#,
	movq	%rdi, %r12	# tmp116, x
	movq	%rsi, %r13	# tmp117, f
# inputs/bootstrap/source/falcon-keygen.c:5361: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L321:
# inputs/bootstrap/source/falcon-keygen.c:5362: 		x[u] = fpr_of(f[u]);
	movswq	0(%r13,%rbx,2), %rdi	# MEM[(const int16_t *)f_17(D) + u_25 * 2], _8
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5362: 		x[u] = fpr_of(f[u]);
	movq	%rax, (%r12,%rbx,8)	# tmp120, MEM[(fpr *)x_18(D) + u_25 * 8]
# inputs/bootstrap/source/falcon-keygen.c:5361: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-keygen.c:5361: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %rbp	# u, n
	jne	.L321	#,
.L319:
# inputs/bootstrap/source/falcon-keygen.c:5364: }
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
.LFE96:
	.size	poly_small_to_fp, .-poly_small_to_fp
	.type	smallints_to_fpr_keygen, @function
smallints_to_fpr_keygen:
.LFB107:
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
# inputs/bootstrap/source/falcon-keygen.c:7433: 	n = MKN(logn, ter);
	leal	1(%rcx,%rcx), %ebp	#, _3
	subl	%ecx, %edx	# ter, _4
# inputs/bootstrap/source/falcon-keygen.c:7433: 	n = MKN(logn, ter);
	movl	%edx, %ecx	# _4, tmp122
	salq	%cl, %rbp	# tmp122, n
# inputs/bootstrap/source/falcon-keygen.c:7434: 	for (u = 0; u < n; u ++) {
	testq	%rbp, %rbp	# n
	je	.L324	#,
	movq	%rdi, %r12	# tmp116, r
	movq	%rsi, %r13	# tmp117, t
# inputs/bootstrap/source/falcon-keygen.c:7434: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L326:
# inputs/bootstrap/source/falcon-keygen.c:7435: 		r[u] = fpr_of(t[u]);
	movswq	0(%r13,%rbx,2), %rdi	# MEM[(const int16_t *)t_17(D) + u_25 * 2], _8
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7435: 		r[u] = fpr_of(t[u]);
	movq	%rax, (%r12,%rbx,8)	# tmp120, MEM[(fpr *)r_18(D) + u_25 * 8]
# inputs/bootstrap/source/falcon-keygen.c:7434: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-keygen.c:7434: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %rbp	# u, n
	jne	.L326	#,
.L324:
# inputs/bootstrap/source/falcon-keygen.c:7437: }
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
.LFE107:
	.size	smallints_to_fpr_keygen, .-smallints_to_fpr_keygen
	.type	poly_big_to_fp, @function
poly_big_to_fp:
.LFB79:
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
	movq	%rdi, 8(%rsp)	# tmp190, %sfp
	movq	%rdx, %r12	# tmp192, flen
	movq	%rcx, %r15	# tmp193, fstride
	movl	112(%rsp), %r14d	# maxbl, maxbl
# inputs/bootstrap/source/falcon-keygen.c:4478: 	n = MKN(logn, ter);
	leal	1(%r9,%r9), %edx	#, _3
	movl	%r8d, %ecx	# tmp194, tmp194
	subl	%r9d, %ecx	# ter, tmp194
# inputs/bootstrap/source/falcon-keygen.c:4478: 	n = MKN(logn, ter);
	salq	%cl, %rdx	# _4, n
# inputs/bootstrap/source/falcon-keygen.c:4479: 	off = maxbl < 63 ? 0 : maxbl - 63;
	movl	$63, %ecx	#, tmp197
	cmpl	%ecx, %r14d	# tmp197, maxbl
	cmovb	%ecx, %r14d	# maxbl,, tmp197, _5
# inputs/bootstrap/source/falcon-keygen.c:4479: 	off = maxbl < 63 ? 0 : maxbl - 63;
	subl	$63, %r14d	#, off
# inputs/bootstrap/source/falcon-keygen.c:4480: 	for (u = 0; u < n; u ++, f += fstride) {
	testq	%rdx, %rdx	# n
	je	.L329	#,
	movq	%rsi, %rax	# tmp191, f
# inputs/bootstrap/source/falcon-keygen.c:4285: 	k = sc / 31;
	movl	%r14d, %ecx	# off, off
	imulq	$138547333, %rcx, %rcx	#, off, tmp157
	shrq	$32, %rcx	#, tmp158
	movl	%r14d, %r13d	# off, tmp159
	subl	%ecx, %r13d	# tmp158, tmp159
	shrl	%r13d	# tmp160
	addl	%ecx, %r13d	# tmp158, tmp161
	shrl	$4, %r13d	#, k
	movl	%r13d, %esi	# k, tmp169
	sall	$5, %esi	#, tmp169
	subl	%r13d, %esi	# k, tmp170
	movl	%r14d, %ecx	# off, _38
	subl	%esi, %ecx	# tmp170, _38
# inputs/bootstrap/source/falcon-keygen.c:4291: 	if ((k + 2) < xlen) {
	leal	2(%r13), %esi	#, _39
	movl	%esi, %ebx	# _39, _40
	movq	%rbx, 16(%rsp)	# _40, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4295: 	} else if ((k + 1) < xlen) {
	leal	1(%r13), %esi	#, _55
	movl	%esi, %ebx	# _55, _56
	movq	%rbx, 40(%rsp)	# _56, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4299: 	} else if (k < xlen) {
	movl	%r13d, %r13d	# k, _64
# inputs/bootstrap/source/falcon-keygen.c:4309: 		| ((uint64_t)w1 << (31 - off))
	movl	$31, %esi	#, tmp173
	subl	%ecx, %esi	# _38, tmp173
	movl	%esi, 28(%rsp)	# tmp173, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4310: 		| ((uint64_t)w2 << (62 - off));
	movl	$62, %esi	#, tmp174
	subl	%ecx, %esi	# _38, tmp174
	movl	%esi, 32(%rsp)	# tmp174, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4480: 	for (u = 0; u < n; u ++, f += fstride) {
	salq	$2, %r15	#, _12
	leaq	(%rax,%r13,4), %rbx	#, ivtmp.694
# inputs/bootstrap/source/falcon-keygen.c:4480: 	for (u = 0; u < n; u ++, f += fstride) {
	movl	$0, %ebp	#, u
# inputs/bootstrap/source/falcon-keygen.c:4482: 			(int)(off - scale));
	subl	120(%rsp), %r14d	# scale, _7
	movl	%r14d, 24(%rsp)	# _7, %sfp
	movq	%rdx, %r14	# n, n
	movl	%ecx, 36(%rsp)	# _38, %sfp
	jmp	.L335	#
.L332:
# inputs/bootstrap/source/falcon-keygen.c:4295: 	} else if ((k + 1) < xlen) {
	movq	40(%rsp), %rsi	# %sfp, _56
	cmpq	%r12, %rsi	# flen, _56
	jnb	.L334	#,
# inputs/bootstrap/source/falcon-keygen.c:4296: 		w0 = x[k + 0];
	movl	(%rbx), %edi	# MEM[(const uint32_t *)_108], w0
# inputs/bootstrap/source/falcon-keygen.c:4297: 		w1 = x[k + 1];
	movq	%rsi, %rcx	# _56, _102
	subq	%r13, %rcx	# _64, _102
	movl	(%rbx,%rcx,4), %edx	# MEM[(const uint32_t *)_108 + _102 * 4], w1
.L333:
# inputs/bootstrap/source/falcon-keygen.c:4308: 	z = ((uint64_t)w0 >> off)
	movl	%edi, %edi	# w0, _69
# inputs/bootstrap/source/falcon-keygen.c:4308: 	z = ((uint64_t)w0 >> off)
	movzbl	36(%rsp), %ecx	# %sfp, tmp221
	shrq	%cl, %rdi	# tmp221, _70
# inputs/bootstrap/source/falcon-keygen.c:4309: 		| ((uint64_t)w1 << (31 - off))
	movl	%edx, %edx	# w1, _72
# inputs/bootstrap/source/falcon-keygen.c:4309: 		| ((uint64_t)w1 << (31 - off))
	movzbl	28(%rsp), %ecx	# %sfp, tmp222
	salq	%cl, %rdx	# tmp222, _74
# inputs/bootstrap/source/falcon-keygen.c:4309: 		| ((uint64_t)w1 << (31 - off))
	orq	%rdx, %rdi	# _74, _75
# inputs/bootstrap/source/falcon-keygen.c:4310: 		| ((uint64_t)w2 << (62 - off));
	movl	%eax, %eax	# w2, _77
# inputs/bootstrap/source/falcon-keygen.c:4310: 		| ((uint64_t)w2 << (62 - off));
	movzbl	32(%rsp), %ecx	# %sfp, tmp223
	salq	%cl, %rax	# tmp223, _79
# inputs/bootstrap/source/falcon-keygen.c:4310: 		| ((uint64_t)w2 << (62 - off));
	orq	%rax, %rdi	# _79, _81
.L331:
# inputs/bootstrap/source/falcon-keygen.c:4481: 		d[u] = fpr_scaled(zint_get_top(f, flen, off),
	movl	24(%rsp), %esi	# %sfp,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:4481: 		d[u] = fpr_scaled(zint_get_top(f, flen, off),
	movq	8(%rsp), %rsi	# %sfp, d
	movq	%rax, (%rsi,%rbp,8)	# tmp196, MEM[(fpr *)d_25(D) + u_86 * 8]
# inputs/bootstrap/source/falcon-keygen.c:4480: 	for (u = 0; u < n; u ++, f += fstride) {
	addq	$1, %rbp	#, u
# inputs/bootstrap/source/falcon-keygen.c:4480: 	for (u = 0; u < n; u ++, f += fstride) {
	addq	%r15, %rbx	# _12, ivtmp.694
	cmpq	%rbp, %r14	# u, n
	je	.L329	#,
.L335:
# inputs/bootstrap/source/falcon-keygen.c:4277: 		return 0;
	movl	$0, %edi	#, _81
# inputs/bootstrap/source/falcon-keygen.c:4276: 	if (xlen == 0) {
	testq	%r12, %r12	# flen
	je	.L331	#,
# inputs/bootstrap/source/falcon-keygen.c:4283: 	sign = -(x[xlen - 1] >> 30);
	movq	%r12, %rax	# flen, _110
	subq	%r13, %rax	# _64, _110
# inputs/bootstrap/source/falcon-keygen.c:4283: 	sign = -(x[xlen - 1] >> 30);
	movl	-4(%rbx,%rax,4), %eax	# MEM[(const uint32_t *)_108 + -4B + _110 * 4], MEM[(const uint32_t *)_108 + -4B + _110 * 4]
	shrl	$30, %eax	#, _35
# inputs/bootstrap/source/falcon-keygen.c:4283: 	sign = -(x[xlen - 1] >> 30);
	negl	%eax	# w2
# inputs/bootstrap/source/falcon-keygen.c:4291: 	if ((k + 2) < xlen) {
	movq	16(%rsp), %rsi	# %sfp, _40
	cmpq	%r12, %rsi	# flen, _40
	jnb	.L332	#,
# inputs/bootstrap/source/falcon-keygen.c:4292: 		w0 = x[k + 0];
	movl	(%rbx), %edi	# MEM[(const uint32_t *)_108], w0
# inputs/bootstrap/source/falcon-keygen.c:4293: 		w1 = x[k + 1];
	movq	40(%rsp), %rdx	# %sfp, _97
	subq	%r13, %rdx	# _64, _97
	movl	(%rbx,%rdx,4), %edx	# MEM[(const uint32_t *)_108 + _97 * 4], w1
# inputs/bootstrap/source/falcon-keygen.c:4294: 		w2 = x[k + 2] | (sign << 31);
	movq	%rsi, %rcx	# _40, _107
	subq	%r13, %rcx	# _64, _107
# inputs/bootstrap/source/falcon-keygen.c:4294: 		w2 = x[k + 2] | (sign << 31);
	sall	$31, %eax	#, _53
# inputs/bootstrap/source/falcon-keygen.c:4294: 		w2 = x[k + 2] | (sign << 31);
	orl	(%rbx,%rcx,4), %eax	# MEM[(const uint32_t *)_108 + _107 * 4], w2
	jmp	.L333	#
.L334:
# inputs/bootstrap/source/falcon-keygen.c:4299: 	} else if (k < xlen) {
	cmpq	%r12, %r13	# flen, _64
	jnb	.L337	#,
# inputs/bootstrap/source/falcon-keygen.c:4300: 		w0 = x[k + 0];
	movl	(%rbx), %edi	# MEM[(const uint32_t *)_108], w0
# inputs/bootstrap/source/falcon-keygen.c:4301: 		w1 = sign;
	movl	%eax, %edx	# w2, w1
	jmp	.L333	#
.L337:
# inputs/bootstrap/source/falcon-keygen.c:4305: 		w1 = sign;
	movl	%eax, %edx	# w2, w1
# inputs/bootstrap/source/falcon-keygen.c:4304: 		w0 = sign;
	movl	%eax, %edi	# w2, w0
	jmp	.L333	#
.L329:
# inputs/bootstrap/source/falcon-keygen.c:4484: }
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
.LFE79:
	.size	poly_big_to_fp, .-poly_big_to_fp
	.type	zint_bezout, @function
zint_bezout:
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
	subq	$152, %rsp	#,
	.cfi_def_cfa_offset 208
	movq	%rdi, 32(%rsp)	# tmp393, %sfp
	movq	%rsi, 48(%rsp)	# tmp394, %sfp
	movq	%rdx, %r15	# tmp395, x
	movq	%rcx, %r13	# tmp396, y
	movq	%r8, %rbx	# tmp397, len
	movq	%r9, 56(%rsp)	# tmp398, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3950: 	xlen = zint_exact_length(x, len);
	movq	%r8, %rsi	# len,
	movq	%rdx, %rdi	# x,
	call	zint_exact_length	#
	movq	%rax, %r14	# tmp399, xlen
# inputs/bootstrap/source/falcon-keygen.c:3951: 	ylen = zint_exact_length(y, len);
	movq	%rbx, %rsi	# len,
	movq	%r13, %rdi	# y,
	call	zint_exact_length	#
# inputs/bootstrap/source/falcon-keygen.c:3958: 	if (xlen == 0 || ylen == 0 || (x[0] & y[0] & 1) == 0) {
	testq	%r14, %r14	# xlen
	je	.L374	#,
	movq	%rax, %rbp	# tmp400, ylen
	movq	%r14, %rcx	# xlen, xlen
	testq	%rax, %rax	# ylen
	je	.L374	#,
# inputs/bootstrap/source/falcon-keygen.c:3958: 	if (xlen == 0 || ylen == 0 || (x[0] & y[0] & 1) == 0) {
	movq	%r15, %r10	# x, x
	movl	(%r15), %r12d	# *x_105(D), _5
# inputs/bootstrap/source/falcon-keygen.c:3958: 	if (xlen == 0 || ylen == 0 || (x[0] & y[0] & 1) == 0) {
	movq	%r13, 40(%rsp)	# y, %sfp
	movl	0(%r13), %r15d	# *y_107(D), _6
# inputs/bootstrap/source/falcon-keygen.c:3958: 	if (xlen == 0 || ylen == 0 || (x[0] & y[0] & 1) == 0) {
	movl	%r12d, %edx	# _5, _7
	andl	%r15d, %edx	# _6, _7
# inputs/bootstrap/source/falcon-keygen.c:3959: 		return 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:3958: 	if (xlen == 0 || ylen == 0 || (x[0] & y[0] & 1) == 0) {
	andl	$1, %edx	#, _7
	movl	%edx, 92(%rsp)	# _7, %sfp
	je	.L340	#,
# inputs/bootstrap/source/falcon-keygen.c:3943: 	v1 = u1 + len;
	leaq	0(,%rbx,4), %rax	#, _1
# inputs/bootstrap/source/falcon-keygen.c:3943: 	v1 = u1 + len;
	movq	56(%rsp), %rdx	# %sfp, tmp
	leaq	(%rdx,%rax), %r14	#, v1
# inputs/bootstrap/source/falcon-keygen.c:3944: 	a = v1 + len;
	movq	%r14, 64(%rsp)	# v1, %sfp
	addq	%rax, %r14	# _1, a
# inputs/bootstrap/source/falcon-keygen.c:3945: 	b = a + len;
	addq	%r14, %rax	# a, b
	movq	%rax, 80(%rsp)	# b, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3968: 	memcpy(a, x, xlen * sizeof *x);
	movq	%rcx, 24(%rsp)	# xlen, %sfp
	leaq	0(,%rcx,4), %r13	#, _9
	movq	%r13, %rdx	# _9,
	movq	%r10, 72(%rsp)	# x, %sfp
	movq	%r10, %rsi	# x,
	movq	%r14, %rdi	# a,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:3969: 	memcpy(b, y, ylen * sizeof *y);
	movq	%rbp, 16(%rsp)	# ylen, %sfp
	salq	$2, %rbp	#, _10
	movq	%rbp, %rdx	# _10,
	movq	40(%rsp), %rsi	# %sfp,
	movq	80(%rsp), %rdi	# %sfp,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:3972: 	u0[0] = 1;
	movq	32(%rsp), %r9	# %sfp, u
	movl	$1, (%r9)	#, *u_97(D)
# inputs/bootstrap/source/falcon-keygen.c:3973: 	memset(u0 + 1, 0, (ylen - 1) * sizeof *u0);
	movq	16(%rsp), %rax	# %sfp, ylen
	leaq	-4(,%rax,4), %rdx	#, _12
# inputs/bootstrap/source/falcon-keygen.c:3973: 	memset(u0 + 1, 0, (ylen - 1) * sizeof *u0);
	leaq	4(%r9), %rdi	#, _13
# inputs/bootstrap/source/falcon-keygen.c:3973: 	memset(u0 + 1, 0, (ylen - 1) * sizeof *u0);
	movl	$0, %esi	#,
	call	memset@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:3974: 	memset(v0, 0, xlen * sizeof *v0);
	movq	%r13, %rdx	# _9,
	movl	$0, %esi	#,
	movq	48(%rsp), %rdi	# %sfp,
	call	memset@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:3975: 	memcpy(u1, y, ylen * sizeof *u1);
	movq	%rbp, %rdx	# _10,
	movq	40(%rsp), %rsi	# %sfp,
	movq	56(%rsp), %rdi	# %sfp,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:3976: 	memcpy(v1, x, xlen * sizeof *v1);
	movq	%r13, %rdx	# _9,
	movq	72(%rsp), %rsi	# %sfp,
	movq	64(%rsp), %rdi	# %sfp,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:3977: 	v1[0] &= ~(uint32_t)1;
	movq	64(%rsp), %rsi	# %sfp, v1
	andl	$-2, (%rsi)	#, *v1_101
# inputs/bootstrap/source/falcon-keygen.c:3983: 	memset(u + ylen, 0, (len - ylen) * sizeof *u);
	movq	%rbx, %rdx	# len, _16
	movq	16(%rsp), %rax	# %sfp, ylen
	subq	%rax, %rdx	# ylen, _16
# inputs/bootstrap/source/falcon-keygen.c:3983: 	memset(u + ylen, 0, (len - ylen) * sizeof *u);
	salq	$2, %rdx	#, _17
	movq	32(%rsp), %r9	# %sfp, u
	leaq	(%r9,%rbp), %rdi	#, _18
	movl	$0, %esi	#,
	call	memset@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:3984: 	memset(v + xlen, 0, (len - xlen) * sizeof *v);
	movq	24(%rsp), %rcx	# %sfp, xlen
	subq	%rcx, %rbx	# xlen, _19
# inputs/bootstrap/source/falcon-keygen.c:3984: 	memset(v + xlen, 0, (len - xlen) * sizeof *v);
	leaq	0(,%rbx,4), %rdx	#, _20
	movq	48(%rsp), %rbx	# %sfp, v
	leaq	(%rbx,%r13), %rdi	#, _21
	movl	$0, %esi	#,
	call	memset@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:3990: 	mlen = alen < blen ? blen : alen;
	movq	24(%rsp), %rcx	# %sfp, xlen
	movq	16(%rsp), %rax	# %sfp, ylen
	cmpq	%rax, %rcx	# ylen, xlen
	movq	%rax, %rbx	# ylen, mlen
	cmovnb	%rcx, %rbx	# xlen,, mlen
# inputs/bootstrap/source/falcon-keygen.c:3991: 	memset(a + alen, 0, (mlen - alen) * sizeof *a);
	movq	%rbx, %rdx	# mlen, _22
	subq	%rcx, %rdx	# xlen, _22
# inputs/bootstrap/source/falcon-keygen.c:3991: 	memset(a + alen, 0, (mlen - alen) * sizeof *a);
	salq	$2, %rdx	#, _23
# inputs/bootstrap/source/falcon-keygen.c:3991: 	memset(a + alen, 0, (mlen - alen) * sizeof *a);
	leaq	(%r14,%r13), %rdi	#, _24
# inputs/bootstrap/source/falcon-keygen.c:3991: 	memset(a + alen, 0, (mlen - alen) * sizeof *a);
	movl	$0, %esi	#,
	call	memset@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:3992: 	memset(b + blen, 0, (mlen - blen) * sizeof *b);
	movq	16(%rsp), %rax	# %sfp, ylen
	subq	%rax, %rbx	# ylen, _25
# inputs/bootstrap/source/falcon-keygen.c:3992: 	memset(b + blen, 0, (mlen - blen) * sizeof *b);
	leaq	0(,%rbx,4), %rdx	#, _26
# inputs/bootstrap/source/falcon-keygen.c:3992: 	memset(b + blen, 0, (mlen - blen) * sizeof *b);
	movq	80(%rsp), %rax	# %sfp, b
	leaq	(%rax,%rbp), %rdi	#, _27
# inputs/bootstrap/source/falcon-keygen.c:3992: 	memset(b + blen, 0, (mlen - blen) * sizeof *b);
	movl	$0, %esi	#,
	call	memset@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:4000: 	if (xlen == 1 && x[0] == 1) {
	cmpl	$1, %r12d	#, _5
	jne	.L380	#,
	cmpq	$1, 24(%rsp)	#, %sfp
	je	.L376	#,
.L380:
# inputs/bootstrap/source/falcon-keygen.c:4003: 	if (ylen == 1 && y[0] == 1) {
	cmpq	$1, 16(%rsp)	#, %sfp
	jne	.L343	#,
	cmpl	$1, %r15d	#, _6
	je	.L387	#,
.L343:
# inputs/bootstrap/source/falcon-keygen.c:4009: 	x0i = modp_ninv31(x[0]);
	movl	%r12d, %edi	# _5,
	call	modp_ninv31	#
	movl	%eax, 112(%rsp)	# tmp401, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4010: 	y0i = modp_ninv31(y[0]);
	movl	%r15d, %edi	# _6,
	call	modp_ninv31	#
	movl	%eax, 116(%rsp)	# tmp402, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3971: 	blen = ylen;
	movq	16(%rsp), %rbx	# %sfp, blen
# inputs/bootstrap/source/falcon-keygen.c:3970: 	alen = xlen;
	movq	24(%rsp), %rax	# %sfp, xlen
	movq	%rax, 8(%rsp)	# xlen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4045: 				m = (uint32_t)1 << i;
	movl	$1, %r15d	#, tmp392
	movq	80(%rsp), %r13	# %sfp, b
	jmp	.L344	#
.L387:
# inputs/bootstrap/source/falcon-keygen.c:4004: 		memcpy(u, u1, ylen * sizeof *u);
	movq	56(%rsp), %rax	# %sfp, tmp
	movl	(%rax), %eax	# MEM <unsigned int> [(char * {ref-all})tmp_99(D)], MEM <unsigned int> [(char * {ref-all})tmp_99(D)]
	movq	32(%rsp), %rbx	# %sfp, u
	movl	%eax, (%rbx)	# MEM <unsigned int> [(char * {ref-all})tmp_99(D)], MEM <unsigned int> [(char * {ref-all})u_97(D)]
# inputs/bootstrap/source/falcon-keygen.c:4005: 		memcpy(v, v1, xlen * sizeof *v);
	movq	%r13, %rdx	# _9,
	movq	64(%rsp), %rsi	# %sfp,
	movq	48(%rsp), %rdi	# %sfp,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:4006: 		return 1;
	movl	$1, %eax	#, <retval>
	jmp	.L340	#
.L381:
# inputs/bootstrap/source/falcon-keygen.c:4029: 			len = alen < blen ? blen : alen;
	movq	8(%rsp), %rax	# %sfp, alen
	cmpq	%rbx, %rax	# blen, alen
	cmovb	%rbx, %rax	# len,, blen, len
	movq	%rax, 80(%rsp)	# len, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4034: 			a_hi = ((uint64_t)a[len - 1] << 31) | a[len - 2];
	leaq	0(,%rax,4), %r9	#, _31
	leaq	-4(%r9), %rax	#, _32
	leaq	(%r14,%rax), %rdi	#, _33
	movq	%rdi, 96(%rsp)	# _33, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4034: 			a_hi = ((uint64_t)a[len - 1] << 31) | a[len - 2];
	movl	(%rdi), %esi	# *_33, _35
# inputs/bootstrap/source/falcon-keygen.c:4034: 			a_hi = ((uint64_t)a[len - 1] << 31) | a[len - 2];
	salq	$31, %rsi	#, _36
# inputs/bootstrap/source/falcon-keygen.c:4034: 			a_hi = ((uint64_t)a[len - 1] << 31) | a[len - 2];
	movl	-8(%r14,%r9), %edx	# *_38, _40
# inputs/bootstrap/source/falcon-keygen.c:4034: 			a_hi = ((uint64_t)a[len - 1] << 31) | a[len - 2];
	orq	%rdx, %rsi	# _40, a_hi
# inputs/bootstrap/source/falcon-keygen.c:4035: 			b_hi = ((uint64_t)b[len - 1] << 31) | b[len - 2];
	addq	%r13, %rax	# b, _41
	movq	%rax, 104(%rsp)	# _41, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4035: 			b_hi = ((uint64_t)b[len - 1] << 31) | b[len - 2];
	movl	(%rax), %r8d	# *_41, _43
# inputs/bootstrap/source/falcon-keygen.c:4035: 			b_hi = ((uint64_t)b[len - 1] << 31) | b[len - 2];
	salq	$31, %r8	#, _44
# inputs/bootstrap/source/falcon-keygen.c:4035: 			b_hi = ((uint64_t)b[len - 1] << 31) | b[len - 2];
	movl	-8(%r13,%r9), %eax	# *_45, _47
# inputs/bootstrap/source/falcon-keygen.c:4035: 			b_hi = ((uint64_t)b[len - 1] << 31) | b[len - 2];
	orq	%rax, %r8	# _47, b_hi
# inputs/bootstrap/source/falcon-keygen.c:4036: 			a_lo = a[0];
	movl	(%r14), %edx	# *a_102, a_lo
# inputs/bootstrap/source/falcon-keygen.c:4037: 			b_lo = b[0];
	movl	0(%r13), %eax	# *b_103, b_lo
# inputs/bootstrap/source/falcon-keygen.c:4038: 			uxa = 1;
	movl	92(%rsp), %edi	# %sfp, _8
	movl	%edi, %r10d	# _8, uxa
# inputs/bootstrap/source/falcon-keygen.c:4039: 			uxb = 0;
	movl	$0, %r12d	#, uxb
# inputs/bootstrap/source/falcon-keygen.c:4040: 			uya = 0;
	movl	$0, %ebp	#, uya
# inputs/bootstrap/source/falcon-keygen.c:4042: 			for (i = 0; i < 31; i ++) {
	movl	$0, %ecx	#, i
	jmp	.L351	#
.L347:
# inputs/bootstrap/source/falcon-keygen.c:4051: 				} else if ((b_lo & m) == 0) {
	testl	%eax, %r11d	# b_lo, m
	jne	.L349	#,
# inputs/bootstrap/source/falcon-keygen.c:4052: 					b_hi >>= 1;
	shrq	%r8	# b_hi
# inputs/bootstrap/source/falcon-keygen.c:4053: 					a_lo <<= 1;
	addl	%edx, %edx	# a_lo
# inputs/bootstrap/source/falcon-keygen.c:4054: 					uxa <<= 1;
	addl	%r10d, %r10d	# uxa
# inputs/bootstrap/source/falcon-keygen.c:4055: 					uxb <<= 1;
	addl	%r12d, %r12d	# uxb
.L348:
# inputs/bootstrap/source/falcon-keygen.c:4042: 			for (i = 0; i < 31; i ++) {
	addl	$1, %ecx	#, i
# inputs/bootstrap/source/falcon-keygen.c:4042: 			for (i = 0; i < 31; i ++) {
	cmpl	$31, %ecx	#, i
	je	.L388	#,
.L351:
# inputs/bootstrap/source/falcon-keygen.c:4045: 				m = (uint32_t)1 << i;
	movl	%r15d, %r11d	# tmp392, m
	sall	%cl, %r11d	# i, m
# inputs/bootstrap/source/falcon-keygen.c:4046: 				if ((a_lo & m) == 0) {
	testl	%edx, %r11d	# a_lo, m
	jne	.L347	#,
# inputs/bootstrap/source/falcon-keygen.c:4047: 					a_hi >>= 1;
	shrq	%rsi	# a_hi
# inputs/bootstrap/source/falcon-keygen.c:4048: 					b_lo <<= 1;
	addl	%eax, %eax	# b_lo
# inputs/bootstrap/source/falcon-keygen.c:4049: 					uya <<= 1;
	addl	%ebp, %ebp	# uya
# inputs/bootstrap/source/falcon-keygen.c:4050: 					uyb <<= 1;
	addl	%edi, %edi	# uyb
	jmp	.L348	#
.L349:
# inputs/bootstrap/source/falcon-keygen.c:4056: 				} else if (a_hi > b_hi) {
	cmpq	%rsi, %r8	# a_hi, b_hi
	jnb	.L350	#,
# inputs/bootstrap/source/falcon-keygen.c:4057: 					a_hi -= b_hi;
	subq	%r8, %rsi	# b_hi, a_hi
# inputs/bootstrap/source/falcon-keygen.c:4058: 					a_lo -= b_lo;
	subl	%eax, %edx	# b_lo, a_lo
# inputs/bootstrap/source/falcon-keygen.c:4059: 					uxa -= uya;
	subl	%ebp, %r10d	# uya, uxa
# inputs/bootstrap/source/falcon-keygen.c:4060: 					uxb -= uyb;
	subl	%edi, %r12d	# uyb, uxb
# inputs/bootstrap/source/falcon-keygen.c:4061: 					a_hi >>= 1;
	shrq	%rsi	# a_hi
# inputs/bootstrap/source/falcon-keygen.c:4062: 					b_lo <<= 1;
	addl	%eax, %eax	# b_lo
# inputs/bootstrap/source/falcon-keygen.c:4063: 					uya <<= 1;
	addl	%ebp, %ebp	# uya
# inputs/bootstrap/source/falcon-keygen.c:4064: 					uyb <<= 1;
	addl	%edi, %edi	# uyb
	jmp	.L348	#
.L350:
# inputs/bootstrap/source/falcon-keygen.c:4066: 					b_hi -= a_hi;
	subq	%rsi, %r8	# a_hi, b_hi
# inputs/bootstrap/source/falcon-keygen.c:4067: 					b_lo -= a_lo;
	subl	%edx, %eax	# a_lo, b_lo
# inputs/bootstrap/source/falcon-keygen.c:4068: 					uya -= uxa;
	subl	%r10d, %ebp	# uxa, uya
# inputs/bootstrap/source/falcon-keygen.c:4069: 					uyb -= uxb;
	subl	%r12d, %edi	# uxb, uyb
# inputs/bootstrap/source/falcon-keygen.c:4070: 					b_hi >>= 1;
	shrq	%r8	# b_hi
# inputs/bootstrap/source/falcon-keygen.c:4071: 					a_lo <<= 1;
	addl	%edx, %edx	# a_lo
# inputs/bootstrap/source/falcon-keygen.c:4072: 					uxa <<= 1;
	addl	%r10d, %r10d	# uxa
# inputs/bootstrap/source/falcon-keygen.c:4073: 					uxb <<= 1;
	addl	%r12d, %r12d	# uxb
	jmp	.L348	#
.L388:
# inputs/bootstrap/source/falcon-keygen.c:4083: 			if (uxa == 0x80000000) {
	cmpl	$-2147483648, %r10d	#, uxa
	je	.L389	#,
# inputs/bootstrap/source/falcon-keygen.c:4095: 			} else if (uyb == 0x80000000) {
	cmpl	$-2147483648, %edi	#, uyb
	jne	.L355	#,
# inputs/bootstrap/source/falcon-keygen.c:4098: 				if (uya != 0 || uxa != 1) {
	testl	%ebp, %ebp	# uya
	jne	.L378	#,
	cmpl	$1, %r10d	#, uxa
	je	.L390	#,
.L378:
	movl	$0, %eax	#, <retval>
	jmp	.L340	#
.L389:
# inputs/bootstrap/source/falcon-keygen.c:4086: 				if (uxb != 0 || uyb != 1) {
	testl	%r12d, %r12d	# uxb
	jne	.L377	#,
	cmpl	$1, %edi	#, uyb
	je	.L391	#,
.L377:
	movl	$0, %eax	#, <retval>
	jmp	.L340	#
.L391:
# inputs/bootstrap/source/falcon-keygen.c:4090: 				if (zint_reduce(b, a, len, ya)) {
	movl	%ebp, %ecx	# uya,
	movq	80(%rsp), %rdx	# %sfp,
	movq	%r14, %rsi	# a,
	movq	%r13, %rdi	# b,
	call	zint_reduce	#
	movl	%eax, %edx	#, tmp403
# inputs/bootstrap/source/falcon-keygen.c:4091: 					ya = -ya;
	movl	%ebp, %eax	# uya, tmp388
	negl	%eax	# tmp388
	testl	%edx, %edx	# tmp403
	cmovne	%eax, %ebp	# tmp388,, ya
# inputs/bootstrap/source/falcon-keygen.c:4093: 				zint_reduce_mod(u1, u0, y, ylen, y0i, ya);
	movl	%ebp, %r9d	# ya,
	movl	116(%rsp), %r8d	# %sfp,
	movq	16(%rsp), %rcx	# %sfp,
	movq	40(%rsp), %rdx	# %sfp,
	movq	32(%rsp), %rsi	# %sfp,
	movq	56(%rsp), %rdi	# %sfp,
	call	zint_reduce_mod	#
# inputs/bootstrap/source/falcon-keygen.c:4094: 				zint_reduce_mod(v1, v0, x, xlen, x0i, ya);
	movl	%ebp, %r9d	# ya,
	movl	112(%rsp), %r8d	# %sfp,
	movq	24(%rsp), %rcx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	48(%rsp), %rsi	# %sfp,
	movq	64(%rsp), %rdi	# %sfp,
	call	zint_reduce_mod	#
	jmp	.L354	#
.L390:
# inputs/bootstrap/source/falcon-keygen.c:4102: 				if (zint_reduce(a, b, len, xb)) {
	movl	%r12d, %ecx	# uxb,
	movq	80(%rsp), %rdx	# %sfp,
	movq	%r13, %rsi	# b,
	movq	%r14, %rdi	# a,
	call	zint_reduce	#
# inputs/bootstrap/source/falcon-keygen.c:4103: 					xb = -xb;
	movl	%r12d, %ebp	# uxb, tmp390
	negl	%ebp	# tmp390
	testl	%eax, %eax	# tmp404
	cmove	%r12d, %ebp	# tmp390,, uxb, xb
# inputs/bootstrap/source/falcon-keygen.c:4105: 				zint_reduce_mod(u0, u1, y, ylen, y0i, xb);
	movl	%ebp, %r9d	# xb,
	movl	116(%rsp), %r8d	# %sfp,
	movq	16(%rsp), %rcx	# %sfp,
	movq	40(%rsp), %rdx	# %sfp,
	movq	56(%rsp), %rsi	# %sfp,
	movq	32(%rsp), %rdi	# %sfp,
	call	zint_reduce_mod	#
# inputs/bootstrap/source/falcon-keygen.c:4106: 				zint_reduce_mod(v0, v1, x, xlen, x0i, xb);
	movl	%ebp, %r9d	# xb,
	movl	112(%rsp), %r8d	# %sfp,
	movq	24(%rsp), %rcx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	64(%rsp), %rsi	# %sfp,
	movq	48(%rsp), %rdi	# %sfp,
	call	zint_reduce_mod	#
	jmp	.L354	#
.L355:
# inputs/bootstrap/source/falcon-keygen.c:4110: 				xa = *(int32_t *)&uxa;
	movl	%r10d, 120(%rsp)	# xa, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4111: 				xb = *(int32_t *)&uxb;
	movl	%r12d, 124(%rsp)	# xb, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4112: 				ya = *(int32_t *)&uya;
	movl	%ebp, 128(%rsp)	# ya, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4113: 				yb = *(int32_t *)&uyb;
	movl	%edi, 132(%rsp)	# yb, %sfp
# inputs/bootstrap/source/falcon-keygen.c:3676: 	for (u = 0; u < len; u ++) {
	movq	80(%rsp), %rsi	# %sfp, len
	testq	%rsi, %rsi	# len
	je	.L357	#,
# inputs/bootstrap/source/falcon-keygen.c:3675: 	ccb = 0;
	movl	$0, %edx	#, ccb
# inputs/bootstrap/source/falcon-keygen.c:3674: 	cca = 0;
	movl	$0, %eax	#, cca
# inputs/bootstrap/source/falcon-keygen.c:3676: 	for (u = 0; u < len; u ++) {
	movl	$0, %ecx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3683: 		za = (int64_t)wa * xa + (int64_t)wb * xb + cca;
	movslq	%r10d, %r8	# xa, _208
# inputs/bootstrap/source/falcon-keygen.c:3683: 		za = (int64_t)wa * xa + (int64_t)wb * xb + cca;
	movslq	%r12d, %r12	# xb, _211
# inputs/bootstrap/source/falcon-keygen.c:3684: 		zb = (int64_t)wa * ya + (int64_t)wb * yb + ccb;
	movslq	%ebp, %rbp	# ya, _217
# inputs/bootstrap/source/falcon-keygen.c:3684: 		zb = (int64_t)wa * ya + (int64_t)wb * yb + ccb;
	movslq	%edi, %r11	# yb, _219
	movq	%r9, 80(%rsp)	# _31, %sfp
	movq	%rbx, 136(%rsp)	# blen, %sfp
	movq	%rsi, %r10	# len, len
	movq	%r8, %rbx	# _208, _208
	jmp	.L359	#
.L358:
# inputs/bootstrap/source/falcon-keygen.c:3689: 		tta = (uint32_t)((uint64_t)za >> 31);
	shrq	$31, %rax	#, za
	movq	%rax, %rdi	# za, _233
# inputs/bootstrap/source/falcon-keygen.c:3690: 		ttb = (uint32_t)((uint64_t)zb >> 31);
	shrq	$31, %rsi	#, _235
# inputs/bootstrap/source/falcon-keygen.c:3692: 		ccb = *(int32_t *)&ttb;
	movl	%esi, %edx	# _235, ccb
# inputs/bootstrap/source/falcon-keygen.c:3676: 	for (u = 0; u < len; u ++) {
	addq	$1, %rcx	#, u
# inputs/bootstrap/source/falcon-keygen.c:3676: 	for (u = 0; u < len; u ++) {
	cmpq	%rcx, %r10	# u, len
	je	.L392	#,
.L359:
# inputs/bootstrap/source/falcon-keygen.c:3683: 		za = (int64_t)wa * xa + (int64_t)wb * xb + cca;
	movslq	(%r14,%rcx,4), %rsi	# MEM[(uint32_t *)a_102 + u_320 * 4], _207
# inputs/bootstrap/source/falcon-keygen.c:3683: 		za = (int64_t)wa * xa + (int64_t)wb * xb + cca;
	movslq	0(%r13,%rcx,4), %r8	# MEM[(uint32_t *)b_103 + u_320 * 4], _210
# inputs/bootstrap/source/falcon-keygen.c:3683: 		za = (int64_t)wa * xa + (int64_t)wb * xb + cca;
	movq	%rbx, %r9	# _208, _209
	imulq	%rsi, %r9	# _207, _209
# inputs/bootstrap/source/falcon-keygen.c:3683: 		za = (int64_t)wa * xa + (int64_t)wb * xb + cca;
	movq	%r12, %rdi	# _211, _212
	imulq	%r8, %rdi	# _210, _212
# inputs/bootstrap/source/falcon-keygen.c:3683: 		za = (int64_t)wa * xa + (int64_t)wb * xb + cca;
	addq	%r9, %rdi	# _209, _213
# inputs/bootstrap/source/falcon-keygen.c:3683: 		za = (int64_t)wa * xa + (int64_t)wb * xb + cca;
	cltq
# inputs/bootstrap/source/falcon-keygen.c:3683: 		za = (int64_t)wa * xa + (int64_t)wb * xb + cca;
	addq	%rdi, %rax	# _213, za
# inputs/bootstrap/source/falcon-keygen.c:3684: 		zb = (int64_t)wa * ya + (int64_t)wb * yb + ccb;
	imulq	%rbp, %rsi	# _217, _218
# inputs/bootstrap/source/falcon-keygen.c:3684: 		zb = (int64_t)wa * ya + (int64_t)wb * yb + ccb;
	imulq	%r11, %r8	# _219, _220
# inputs/bootstrap/source/falcon-keygen.c:3684: 		zb = (int64_t)wa * ya + (int64_t)wb * yb + ccb;
	addq	%r8, %rsi	# _220, _221
# inputs/bootstrap/source/falcon-keygen.c:3684: 		zb = (int64_t)wa * ya + (int64_t)wb * yb + ccb;
	movslq	%edx, %rdx	# ccb, _223
# inputs/bootstrap/source/falcon-keygen.c:3684: 		zb = (int64_t)wa * ya + (int64_t)wb * yb + ccb;
	addq	%rdx, %rsi	# _223, zb
# inputs/bootstrap/source/falcon-keygen.c:3685: 		if (u > 0) {
	testq	%rcx, %rcx	# u
	je	.L358	#,
# inputs/bootstrap/source/falcon-keygen.c:3686: 			a[u - 1] = (uint32_t)za & 0x7FFFFFFF;
	movl	%eax, %edx	# za, tmp371
	andl	$2147483647, %edx	#, tmp371
	movl	%edx, -4(%r14,%rcx,4)	# tmp371, MEM[(uint32_t *)a_102 + -4B + u_320 * 4]
# inputs/bootstrap/source/falcon-keygen.c:3687: 			b[u - 1] = (uint32_t)zb & 0x7FFFFFFF;
	movl	%esi, %edx	# zb, tmp372
	andl	$2147483647, %edx	#, tmp372
	movl	%edx, -4(%r13,%rcx,4)	# tmp372, MEM[(uint32_t *)b_103 + -4B + u_320 * 4]
	jmp	.L358	#
.L392:
# inputs/bootstrap/source/falcon-keygen.c:3694: 	a[len - 1] = (uint32_t)cca;
	movq	80(%rsp), %r9	# %sfp, _31
	movq	136(%rsp), %rbx	# %sfp, blen
	movq	96(%rsp), %rax	# %sfp, _33
	movl	%edi, (%rax)	# _233, *_33
# inputs/bootstrap/source/falcon-keygen.c:3695: 	b[len - 1] = (uint32_t)ccb;
	movq	104(%rsp), %rax	# %sfp, _41
	movl	%esi, (%rax)	# _235, *_41
# inputs/bootstrap/source/falcon-keygen.c:3696: 	r = 0;
	movl	$0, %r8d	#, r
# inputs/bootstrap/source/falcon-keygen.c:3697: 	if (cca < 0) {
	testl	%edi, %edi	# _233
	js	.L393	#,
.L360:
# inputs/bootstrap/source/falcon-keygen.c:3710: 	if (ccb < 0) {
	testl	%esi, %esi	# _235
	js	.L394	#,
.L372:
# inputs/bootstrap/source/falcon-keygen.c:4116: 				if ((r & 1) != 0) {
	testl	%r8d, %r8d	# r
	je	.L371	#,
# inputs/bootstrap/source/falcon-keygen.c:4117: 					xa = -xa;
	negl	120(%rsp)	# %sfp
# inputs/bootstrap/source/falcon-keygen.c:4118: 					xb = -xb;
	negl	124(%rsp)	# %sfp
	jmp	.L371	#
.L393:
	movq	%r14, %rdx	# a, ivtmp.711
	leaq	(%r9,%r14), %r8	#, _288
# inputs/bootstrap/source/falcon-keygen.c:3700: 		c = 1;
	movl	92(%rsp), %edi	# %sfp, c
	.p2align 5
.L361:
# inputs/bootstrap/source/falcon-keygen.c:3704: 			w = c + ~a[u];
	movl	(%rdx), %ecx	# MEM[(uint32_t *)_290], _248
# inputs/bootstrap/source/falcon-keygen.c:3704: 			w = c + ~a[u];
	leal	-1(%rdi), %eax	#, _298
	subl	%ecx, %eax	# _248, w_251
# inputs/bootstrap/source/falcon-keygen.c:3705: 			a[u] = w & 0x7FFFFFFF;
	andl	$2147483647, %eax	#, tmp375
	movl	%eax, (%rdx)	# tmp375, MEM[(uint32_t *)_290]
	subl	%edi, %ecx	# c, _253
# inputs/bootstrap/source/falcon-keygen.c:3706: 			c = (~w) >> 31;
	movl	%ecx, %edi	# _253, _253
	shrl	$31, %edi	#, _253
# inputs/bootstrap/source/falcon-keygen.c:3701: 		for (u = 0; u < len; u ++) {
	addq	$4, %rdx	#, ivtmp.711
	cmpq	%r8, %rdx	# _288, ivtmp.711
	jne	.L361	#,
# inputs/bootstrap/source/falcon-keygen.c:3708: 		r |= 1;
	movl	$1, %r8d	#, r
	jmp	.L360	#
.L394:
	movq	%r13, %rdx	# b, ivtmp.707
	addq	%r13, %r9	# b, _249
# inputs/bootstrap/source/falcon-keygen.c:3713: 		c = 1;
	movl	92(%rsp), %esi	# %sfp, c
	.p2align 5
.L362:
# inputs/bootstrap/source/falcon-keygen.c:3717: 			w = c + ~b[u];
	movl	(%rdx), %ecx	# MEM[(uint32_t *)_78], _259
# inputs/bootstrap/source/falcon-keygen.c:3717: 			w = c + ~b[u];
	leal	-1(%rsi), %eax	#, _82
	subl	%ecx, %eax	# _259, w_262
# inputs/bootstrap/source/falcon-keygen.c:3718: 			b[u] = w & 0x7FFFFFFF;
	andl	$2147483647, %eax	#, tmp378
	movl	%eax, (%rdx)	# tmp378, MEM[(uint32_t *)_78]
	subl	%esi, %ecx	# c, _264
# inputs/bootstrap/source/falcon-keygen.c:3719: 			c = (~w) >> 31;
	movl	%ecx, %esi	# _264, _264
	shrl	$31, %esi	#, _264
# inputs/bootstrap/source/falcon-keygen.c:3714: 		for (u = 0; u < len; u ++) {
	addq	$4, %rdx	#, ivtmp.707
	cmpq	%r9, %rdx	# _249, ivtmp.707
	jne	.L362	#,
# inputs/bootstrap/source/falcon-keygen.c:4116: 				if ((r & 1) != 0) {
	testl	%r8d, %r8d	# r
	jne	.L395	#,
.L363:
# inputs/bootstrap/source/falcon-keygen.c:4121: 					ya = -ya;
	negl	128(%rsp)	# %sfp
# inputs/bootstrap/source/falcon-keygen.c:4122: 					yb = -yb;
	negl	132(%rsp)	# %sfp
.L371:
# inputs/bootstrap/source/falcon-keygen.c:4124: 				zint_co_reduce_mod(u0, u1, y, ylen, y0i,
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 216
	movl	140(%rsp), %ebp	# %sfp, yb
	pushq	%rbp	# yb
	.cfi_def_cfa_offset 224
	movl	144(%rsp), %r12d	# %sfp, ya
	pushq	%r12	# ya
	.cfi_def_cfa_offset 232
	movl	148(%rsp), %eax	# %sfp, xb
	pushq	%rax	# xb
	.cfi_def_cfa_offset 240
	movl	152(%rsp), %r9d	# %sfp,
	movl	148(%rsp), %r8d	# %sfp,
	movq	48(%rsp), %rcx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	88(%rsp), %rsi	# %sfp,
	movq	64(%rsp), %rdi	# %sfp,
	call	zint_co_reduce_mod	#
# inputs/bootstrap/source/falcon-keygen.c:4126: 				zint_co_reduce_mod(v0, v1, x, xlen, x0i,
	addq	$24, %rsp	#,
	.cfi_def_cfa_offset 216
	pushq	%rbp	# yb
	.cfi_def_cfa_offset 224
	pushq	%r12	# ya
	.cfi_def_cfa_offset 232
	movl	148(%rsp), %eax	# %sfp, xb
	pushq	%rax	# xb
	.cfi_def_cfa_offset 240
	movl	152(%rsp), %r9d	# %sfp,
	movl	144(%rsp), %r8d	# %sfp,
	movq	56(%rsp), %rcx	# %sfp,
	movq	104(%rsp), %rdx	# %sfp,
	movq	96(%rsp), %rsi	# %sfp,
	movq	80(%rsp), %rdi	# %sfp,
	call	zint_co_reduce_mod	#
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 208
.L354:
# inputs/bootstrap/source/falcon-keygen.c:4129: 			alen = zint_exact_length(a, alen);
	movq	8(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# a,
	call	zint_exact_length	#
	movq	%rax, 8(%rsp)	# tmp405, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4130: 			blen = zint_exact_length(b, blen);
	movq	%rbx, %rsi	# blen,
	movq	%r13, %rdi	# b,
	call	zint_exact_length	#
	movq	%rax, %rbx	# tmp406, blen
	jmp	.L344	#
.L395:
# inputs/bootstrap/source/falcon-keygen.c:4117: 					xa = -xa;
	negl	120(%rsp)	# %sfp
# inputs/bootstrap/source/falcon-keygen.c:4118: 					xb = -xb;
	negl	124(%rsp)	# %sfp
	jmp	.L363	#
.L396:
# inputs/bootstrap/source/falcon-keygen.c:4139: 			zint_rshift1(a, alen);
	movq	8(%rsp), %rbp	# %sfp, alen
	movq	%rbp, %rsi	# alen,
	movq	%r14, %rdi	# a,
	call	zint_rshift1	#
# inputs/bootstrap/source/falcon-keygen.c:4140: 			alen = zint_exact_length(a, alen);
	movq	%rbp, %rsi	# alen,
	movq	%r14, %rdi	# a,
	call	zint_exact_length	#
	movq	%rax, 8(%rsp)	# tmp407, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4141: 			zint_rshift1_mod(u0, y, ylen);
	movq	16(%rsp), %rdx	# %sfp,
	movq	40(%rsp), %rsi	# %sfp,
	movq	32(%rsp), %rdi	# %sfp,
	call	zint_rshift1_mod	#
# inputs/bootstrap/source/falcon-keygen.c:4142: 			zint_rshift1_mod(v0, x, xlen);
	movq	24(%rsp), %rdx	# %sfp,
	movq	72(%rsp), %rsi	# %sfp,
	movq	48(%rsp), %rdi	# %sfp,
	call	zint_rshift1_mod	#
# inputs/bootstrap/source/falcon-keygen.c:4143: 			continue;
	jmp	.L344	#
.L397:
# inputs/bootstrap/source/falcon-keygen.c:4150: 			zint_rshift1(b, blen);
	movq	%rbx, %rsi	# blen,
	movq	%r13, %rdi	# b,
	call	zint_rshift1	#
# inputs/bootstrap/source/falcon-keygen.c:4151: 			blen = zint_exact_length(b, blen);
	movq	%rbx, %rsi	# blen,
	movq	%r13, %rdi	# b,
	call	zint_exact_length	#
	movq	%rax, %rbx	# tmp408, blen
# inputs/bootstrap/source/falcon-keygen.c:4152: 			zint_rshift1_mod(u1, y, ylen);
	movq	16(%rsp), %rdx	# %sfp,
	movq	40(%rsp), %rsi	# %sfp,
	movq	56(%rsp), %rdi	# %sfp,
	call	zint_rshift1_mod	#
# inputs/bootstrap/source/falcon-keygen.c:4153: 			zint_rshift1_mod(v1, x, xlen);
	movq	24(%rsp), %rdx	# %sfp,
	movq	72(%rsp), %rsi	# %sfp,
	movq	64(%rsp), %rdi	# %sfp,
	call	zint_rshift1_mod	#
# inputs/bootstrap/source/falcon-keygen.c:4154: 			continue;
	jmp	.L344	#
.L398:
# inputs/bootstrap/source/falcon-keygen.c:4175: 				return alen == 1 && a[0] == 1;
	cmpl	$1, %ebp	#, _69
	sete	%dl	#, _239
# inputs/bootstrap/source/falcon-keygen.c:4175: 				return alen == 1 && a[0] == 1;
	cmpq	$1, 8(%rsp)	#, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4175: 				return alen == 1 && a[0] == 1;
	sete	%al	#, _241
	movzbl	%al, %eax	# _241, _241
	andl	%edx, %eax	# _239, <retval>
	jmp	.L340	#
.L367:
# inputs/bootstrap/source/falcon-keygen.c:4194: 			zint_sub(b, a, blen);
	movq	%rbx, %rdx	# blen,
	movq	%r14, %rsi	# a,
	movq	%r13, %rdi	# b,
	call	zint_sub	#
# inputs/bootstrap/source/falcon-keygen.c:4195: 			blen = zint_exact_length(b, blen);
	movq	%rbx, %rsi	# blen,
	movq	%r13, %rdi	# b,
	call	zint_exact_length	#
	movq	%rax, %rbx	# tmp411, blen
# inputs/bootstrap/source/falcon-keygen.c:4196: 			zint_sub_mod(u1, u0, y, ylen);
	movq	16(%rsp), %rcx	# %sfp,
	movq	40(%rsp), %rdx	# %sfp,
	movq	32(%rsp), %rsi	# %sfp,
	movq	56(%rsp), %rdi	# %sfp,
	call	zint_sub_mod	#
# inputs/bootstrap/source/falcon-keygen.c:4197: 			zint_sub_mod(v1, v0, x, xlen);
	movq	24(%rsp), %rcx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	48(%rsp), %rsi	# %sfp,
	movq	64(%rsp), %rdi	# %sfp,
	call	zint_sub_mod	#
.L344:
# inputs/bootstrap/source/falcon-keygen.c:4022: 		if (alen >= 3 || blen >= 3) {
	cmpq	$2, 8(%rsp)	#, %sfp
	ja	.L381	#,
	cmpq	$2, %rbx	#, blen
	ja	.L381	#,
# inputs/bootstrap/source/falcon-keygen.c:4138: 		if ((a[0] & 1) == 0) {
	movl	(%r14), %ebp	# *a_102, _69
# inputs/bootstrap/source/falcon-keygen.c:4138: 		if ((a[0] & 1) == 0) {
	testb	$1, %bpl	#, _69
	je	.L396	#,
# inputs/bootstrap/source/falcon-keygen.c:4149: 		if ((b[0] & 1) == 0) {
	testb	$1, 0(%r13)	#, *b_103
	je	.L397	#,
# inputs/bootstrap/source/falcon-keygen.c:4161: 		if (alen < blen) {
	movq	8(%rsp), %rax	# %sfp, alen
	cmpq	%rbx, %rax	# blen, alen
	jb	.L367	#,
# inputs/bootstrap/source/falcon-keygen.c:4163: 		} else if (alen > blen) {
	cmpq	%rax, %rbx	# alen, blen
	jb	.L368	#,
# inputs/bootstrap/source/falcon-keygen.c:4166: 			r = zint_ucmp(a, b, alen);
	movq	%rax, %rdx	# alen,
	movq	%r13, %rsi	# b,
	movq	%r14, %rdi	# a,
	call	zint_ucmp	#
# inputs/bootstrap/source/falcon-keygen.c:4167: 			if (r == 0) {
	testl	%eax, %eax	# r
	je	.L398	#,
# inputs/bootstrap/source/falcon-keygen.c:4188: 		if (r > 0) {
	jle	.L367	#,
.L368:
# inputs/bootstrap/source/falcon-keygen.c:4189: 			zint_sub(a, b, alen);
	movq	8(%rsp), %rbp	# %sfp, alen
	movq	%rbp, %rdx	# alen,
	movq	%r13, %rsi	# b,
	movq	%r14, %rdi	# a,
	call	zint_sub	#
# inputs/bootstrap/source/falcon-keygen.c:4190: 			alen = zint_exact_length(a, alen);
	movq	%rbp, %rsi	# alen,
	movq	%r14, %rdi	# a,
	call	zint_exact_length	#
	movq	%rax, 8(%rsp)	# tmp410, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4191: 			zint_sub_mod(u0, u1, y, ylen);
	movq	16(%rsp), %rcx	# %sfp,
	movq	40(%rsp), %rdx	# %sfp,
	movq	56(%rsp), %rsi	# %sfp,
	movq	32(%rsp), %rdi	# %sfp,
	call	zint_sub_mod	#
# inputs/bootstrap/source/falcon-keygen.c:4192: 			zint_sub_mod(v0, v1, x, xlen);
	movq	24(%rsp), %rcx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	64(%rsp), %rsi	# %sfp,
	movq	48(%rsp), %rdi	# %sfp,
	call	zint_sub_mod	#
	jmp	.L344	#
.L374:
# inputs/bootstrap/source/falcon-keygen.c:3959: 		return 0;
	movl	$0, %eax	#, <retval>
.L340:
# inputs/bootstrap/source/falcon-keygen.c:4200: }
	addq	$152, %rsp	#,
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
.L376:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:4001: 		return 1;
	movl	$1, %eax	#, <retval>
	jmp	.L340	#
.L357:
# inputs/bootstrap/source/falcon-keygen.c:3694: 	a[len - 1] = (uint32_t)cca;
	movq	96(%rsp), %rax	# %sfp, _33
	movl	$0, (%rax)	#, *_33
# inputs/bootstrap/source/falcon-keygen.c:3695: 	b[len - 1] = (uint32_t)ccb;
	movq	104(%rsp), %rax	# %sfp, _41
	movl	$0, (%rax)	#, *_41
# inputs/bootstrap/source/falcon-keygen.c:3696: 	r = 0;
	movl	$0, %r8d	#, r
	jmp	.L372	#
	.cfi_endproc
.LFE71:
	.size	zint_bezout, .-zint_bezout
	.type	ft_stable_binary_inplace_keygen, @function
ft_stable_binary_inplace_keygen:
.LFB112:
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
# inputs/bootstrap/source/falcon-keygen.c:7496: 	if (n == 1) {
	cmpq	$1, %rsi	#, n
	je	.L406	#,
# inputs/bootstrap/source/falcon-keygen.c:7501: 	for (u = 0; u < hn; u ++) {
	movq	40(%rsp), %rax	# %sfp, hn
	shrq	%rax	# hn
	movq	%rax, 16(%rsp)	# hn, %sfp
	je	.L402	#,
	movq	32(%rsp), %r15	# %sfp, ivtmp.732
	movq	8(%rsp), %rcx	# %sfp, scratch
	leaq	(%rcx,%rax,8), %rax	#, _76
	movq	%rax, 24(%rsp)	# _76, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7501: 	for (u = 0; u < hn; u ++) {
	movl	$0, %ebp	#, u
.L403:
# inputs/bootstrap/source/falcon-keygen.c:7503: 		a = ft_stable_positive_keygen(values[(u << 1) + 0], bad);
	movq	(%r15), %rdi	# MEM[(fpr *)_74], MEM[(fpr *)_74]
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r13	# tmp172, a
# inputs/bootstrap/source/falcon-keygen.c:7504: 		b = ft_stable_positive_keygen(values[(u << 1) + 1], bad);
	movq	8(%r15), %rdi	# MEM[(fpr *)_74 + 8B], MEM[(fpr *)_74 + 8B]
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r14	# tmp173, b
# inputs/bootstrap/source/falcon-keygen.c:7505: 		sum = ft_stable_positive_keygen(fpr_add(a, b), bad);
	movq	%rax, %rsi	# b,
	movq	%r13, %rdi	# a,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp174, _9
# inputs/bootstrap/source/falcon-keygen.c:7505: 		sum = ft_stable_positive_keygen(fpr_add(a, b), bad);
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r12	# tmp175, sum
# inputs/bootstrap/source/falcon-keygen.c:7506: 		product = ft_stable_positive_keygen(fpr_mul(a, b), bad);
	movq	%r14, %rsi	# b,
	movq	%r13, %rdi	# a,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp176, _10
# inputs/bootstrap/source/falcon-keygen.c:7506: 		product = ft_stable_positive_keygen(fpr_mul(a, b), bad);
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r13	# tmp177, product
# inputs/bootstrap/source/fpr-emulated.h:170: 	x -= (uint64_t)1 << 52;
	movabsq	$-4503599627370496, %rax	#, tmp189
	leaq	(%r12,%rax), %rdi	#, x
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	movq	%rdi, %rax	# x, _61
	shrq	$52, %rax	#, _61
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	andl	$2047, %eax	#, _63
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	addl	$1, %eax	#, _64
# inputs/bootstrap/source/fpr-emulated.h:171: 	t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;
	shrl	$11, %eax	#, t_65
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	movl	%eax, %eax	# t_65, _66
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	subq	$1, %rax	#, _67
# inputs/bootstrap/source/fpr-emulated.h:172: 	x &= (uint64_t)t - 1;
	andq	%rax, %rdi	# _67, x_68
# inputs/bootstrap/source/falcon-keygen.c:7507: 		scratch[u] = ft_stable_positive_keygen(fpr_half(sum), bad);
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7507: 		scratch[u] = ft_stable_positive_keygen(fpr_half(sum), bad);
	movq	8(%rsp), %rcx	# %sfp, scratch
	movq	%rax, (%rcx,%rbp,8)	# tmp178, MEM[(fpr *)scratch_29(D) + u_71 * 8]
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	movq	%r13, %rdi	# product, _47
	shrq	$52, %rdi	#, _47
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	andl	$2047, %edi	#, _54
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addl	$2047, %edi	#, _55
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrl	$11, %edi	#, _56
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	salq	$52, %rdi	#, _58
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addq	%r13, %rdi	# product, x_59
# inputs/bootstrap/source/falcon-keygen.c:7508: 		scratch[u + hn] = ft_stable_positive_keygen(
	movq	%r12, %rsi	# sum,
	call	fpr_div@PLT	#
	movq	%rax, %rdi	# tmp179, _14
# inputs/bootstrap/source/falcon-keygen.c:7508: 		scratch[u + hn] = ft_stable_positive_keygen(
	movq	%rbx, %rsi	# bad,
	call	ft_stable_positive_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7508: 		scratch[u + hn] = ft_stable_positive_keygen(
	movq	24(%rsp), %rdx	# %sfp, _76
	movq	%rax, (%rdx,%rbp,8)	# tmp180, MEM[(fpr *)_76 + u_71 * 8]
# inputs/bootstrap/source/falcon-keygen.c:7501: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rbp	#, u
# inputs/bootstrap/source/falcon-keygen.c:7501: 	for (u = 0; u < hn; u ++) {
	addq	$16, %r15	#, ivtmp.732
	cmpq	%rbp, 16(%rsp)	# u, %sfp
	jne	.L403	#,
.L402:
# inputs/bootstrap/source/falcon-keygen.c:7511: 	memcpy(values, scratch, n * sizeof *values);
	movq	40(%rsp), %rdx	# %sfp, n
	salq	$3, %rdx	#, n
	movq	8(%rsp), %rbp	# %sfp, scratch
	movq	%rbp, %rsi	# scratch,
	movq	32(%rsp), %r14	# %sfp, values
	movq	%r14, %rdi	# values,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7512: 	ft_stable_binary_inplace_keygen(values, hn, scratch, bad);
	movq	%rbx, %rcx	# bad,
	movq	%rbp, %rdx	# scratch,
	movq	16(%rsp), %r15	# %sfp, hn
	movq	%r15, %rsi	# hn,
	movq	%r14, %rdi	# values,
	call	ft_stable_binary_inplace_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7513: 	ft_stable_binary_inplace_keygen(values + hn, hn, scratch, bad);
	movq	%r15, %rsi	# hn, hn
	leaq	(%r14,%r15,8), %rdi	#, _21
	movq	%rbx, %rcx	# bad,
	movq	%rbp, %rdx	# scratch,
	call	ft_stable_binary_inplace_keygen	#
.L399:
# inputs/bootstrap/source/falcon-keygen.c:7514: }
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
.L406:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:7497: 		values[0] = ft_stable_positive_keygen(values[0], bad);
	movq	%rdi, %r15	# tmp167, values
	movq	(%rdi), %rdi	# *values_28(D), *values_28(D)
	movq	%rcx, %rsi	# bad,
	call	ft_stable_positive_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7497: 		values[0] = ft_stable_positive_keygen(values[0], bad);
	movq	%rax, (%r15)	# tmp171, *values_28(D)
# inputs/bootstrap/source/falcon-keygen.c:7498: 		return;
	jmp	.L399	#
	.cfi_endproc
.LFE112:
	.size	ft_stable_binary_inplace_keygen, .-ft_stable_binary_inplace_keygen
	.type	LDL_dim2_fft3_keygen, @function
LDL_dim2_fft3_keygen:
.LFB114:
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
# inputs/bootstrap/source/falcon-keygen.c:7555: 	n = MKN(logn, full);
	leal	1(%r12,%r12), %r13d	#, _3
	movl	%r9d, %ecx	# logn, _4
	subl	%r12d, %ecx	# full, _4
# inputs/bootstrap/source/falcon-keygen.c:7555: 	n = MKN(logn, full);
	salq	%cl, %r13	# _4, n_8
# inputs/bootstrap/source/falcon-keygen.c:7556: 	memcpy(l10, g10, n * sizeof *g10);
	salq	$3, %r13	#, _5
	movq	%r13, %rdx	# _5,
	movq	%r15, %rsi	# g10,
	movq	%r14, %rdi	# l10,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7557: 	falcon_poly_div_autoadj_fft3(l10, g00, logn, full);
	movl	%r12d, %ecx	# full,
	movl	%ebx, %edx	# logn,
	movq	(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# l10,
	call	falcon_poly_div_autoadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7558: 	memcpy(d11, g10, n * sizeof *g10);
	movq	%r13, %rdx	# _5,
	movq	%r15, %rsi	# g10,
	movq	%rbp, %rdi	# d11,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7559: 	falcon_poly_muladj_fft3(d11, l10, logn, full);
	movl	%r12d, %ecx	# full,
	movl	%ebx, %edx	# logn,
	movq	%r14, %rsi	# l10,
	movq	%rbp, %rdi	# d11,
	call	falcon_poly_muladj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7560: 	falcon_poly_neg_fft3(d11, logn, full);
	movl	%r12d, %edx	# full,
	movl	%ebx, %esi	# logn,
	movq	%rbp, %rdi	# d11,
	call	falcon_poly_neg3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7561: 	falcon_poly_add_fft3(d11, g11, logn, full);
	movl	%r12d, %ecx	# full,
	movl	%ebx, %edx	# logn,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# d11,
	call	falcon_poly_add3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7562: }
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
.LFE114:
	.size	LDL_dim2_fft3_keygen, .-LDL_dim2_fft3_keygen
	.type	ffLDL_inner_fft3_keygen, @function
ffLDL_inner_fft3_keygen:
.LFB116:
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
# inputs/bootstrap/source/falcon-keygen.c:7600: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp120
	movl	%r8d, %ecx	# logn, tmp139
	salq	%cl, %rax	# tmp139, tmp120
# inputs/bootstrap/source/falcon-keygen.c:7601: 	hn = n >> 1;
	movq	%rax, %r12	# n, hn
	shrq	%r12	# hn
# inputs/bootstrap/source/falcon-keygen.c:7602: 	if (logn == 1) {
	cmpl	$1, %r8d	#, logn
	je	.L413	#,
	movl	%r8d, %ebp	# tmp133, logn
	movq	%rax, %r14	# tmp120, n
# inputs/bootstrap/source/falcon-keygen.c:7610: 	t1 = tmp + hn;
	salq	$3, %r12	#, _3
# inputs/bootstrap/source/falcon-keygen.c:7610: 	t1 = tmp + hn;
	leaq	(%r9,%r12), %r13	#, t1
# inputs/bootstrap/source/falcon-keygen.c:7611: 	t2 = t1 + hn;
	addq	%r13, %r12	# t1, t2
# inputs/bootstrap/source/falcon-keygen.c:7612: 	falcon_poly_split_deep_fft3(t0, t1, g00, logn);
	movl	%r8d, %ecx	# logn,
	movq	8(%rsp), %rdx	# %sfp,
	movq	%r13, %rsi	# t1,
	movq	%r9, %rdi	# tmp,
	call	falcon_poly_split_deep_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7613: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	leal	-1(%rbp), %r15d	#, _4
	movl	$0, %edx	#,
	movl	%r15d, %esi	# _4,
	movq	%r13, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7614: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	movl	$8, %edi	#, tmp124
	movl	%ebp, %ecx	# logn, tmp144
	salq	%cl, %rdi	# tmp144, _5
# inputs/bootstrap/source/falcon-keygen.c:7614: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	movq	(%rsp), %rax	# %sfp, tree
	addq	%rax, %rdi	# tree, _6
	movq	%r12, %r9	# t2,
	movl	%r15d, %r8d	# _4,
	movq	%rbx, %rcx	# tmp,
	movq	%r13, %rdx	# t1,
	movq	%rbx, %rsi	# tmp,
	call	ffLDL_inner_fft3_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7614: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	addq	%rax, %r14	# tmp135, s
# inputs/bootstrap/source/falcon-keygen.c:7615: 	LDL_dim2_fft3_keygen(t2, tree, g00, g10, g11, logn, 0);
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
	call	LDL_dim2_fft3_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7616: 	falcon_poly_split_deep_fft3(t0, t1, t2, logn);
	movl	%ebp, %ecx	# logn,
	movq	%r12, %rdx	# t2,
	movq	%r13, %rsi	# t1,
	movq	%rbx, %rdi	# tmp,
	call	falcon_poly_split_deep_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7617: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	movl	$0, %edx	#,
	movl	%r15d, %esi	# _4,
	movq	%r13, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7618: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	movq	16(%rsp), %rax	# %sfp, tree
	leaq	(%rax,%r14,8), %rdi	#, _8
	movq	%r12, %r9	# t2,
	movl	%r15d, %r8d	# _4,
	movq	%rbx, %rcx	# tmp,
	movq	%r13, %rdx	# t1,
	movq	%rbx, %rsi	# tmp,
	call	ffLDL_inner_fft3_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7618: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	addq	%r14, %rax	# s, <retval>
# inputs/bootstrap/source/falcon-keygen.c:7619: 	return s;
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 96
.L409:
# inputs/bootstrap/source/falcon-keygen.c:7620: }
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
.L413:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:7603: 		LDL_dim2_fft3_keygen(tmp, tree, g00, g10, g11, logn, 0);
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
	call	LDL_dim2_fft3_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7604: 		tree[2] = g00[0];
	movq	(%r14), %rax	# *g00_18(D), *g00_18(D)
	movq	%rax, 16(%r15)	# *g00_18(D), MEM[(fpr *)tree_21(D) + 16B]
# inputs/bootstrap/source/falcon-keygen.c:7605: 		tree[3] = tmp[0];
	movq	(%rbx), %rax	# *tmp_14(D), *tmp_14(D)
	movq	%rax, 24(%r15)	# *tmp_14(D), MEM[(fpr *)tree_21(D) + 24B]
# inputs/bootstrap/source/falcon-keygen.c:7606: 		return 4;
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 96
	movl	$4, %eax	#, <retval>
	jmp	.L409	#
	.cfi_endproc
.LFE116:
	.size	ffLDL_inner_fft3_keygen, .-ffLDL_inner_fft3_keygen
	.type	ffLDL_depth1_fft3_keygen, @function
ffLDL_depth1_fft3_keygen:
.LFB117:
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
# inputs/bootstrap/source/falcon-keygen.c:7634: 	l20 = l10 + n;
	movl	$8, %r14d	#, tmp131
	movl	%ebx, %ecx	# logn, tmp173
	salq	%cl, %r14	# tmp173, _1
# inputs/bootstrap/source/falcon-keygen.c:7634: 	l20 = l10 + n;
	leaq	(%rdi,%r14), %rcx	#, l20
# inputs/bootstrap/source/falcon-keygen.c:7635: 	l21 = l20 + n;
	movq	%rcx, 16(%rsp)	# l20, %sfp
	leaq	(%rcx,%r14), %r15	#, l21
# inputs/bootstrap/source/falcon-keygen.c:7637: 	d22 = d11 + n;
	movq	%r14, %rcx	# _1, d22
	addq	152(%rsp), %rcx	# tmp, d22
# inputs/bootstrap/source/falcon-keygen.c:7638: 	t0 = d22 + n;
	movq	%rcx, 8(%rsp)	# d22, %sfp
	leaq	(%rcx,%r14), %r12	#, t0
# inputs/bootstrap/source/falcon-keygen.c:7631: 	n = (size_t)1 << logn;
	movl	$1, %ebp	#, tmp133
	movl	%ebx, %ecx	# logn, tmp179
	salq	%cl, %rbp	# tmp179, n_11
# inputs/bootstrap/source/falcon-keygen.c:7632: 	hn = n >> 1;
	shrq	%rbp	# hn_12
# inputs/bootstrap/source/falcon-keygen.c:7639: 	t1 = t0 + hn;
	salq	$3, %rbp	#, _2
# inputs/bootstrap/source/falcon-keygen.c:7639: 	t1 = t0 + hn;
	leaq	(%r12,%rbp), %r13	#, t1
# inputs/bootstrap/source/falcon-keygen.c:7640: 	t2 = t1 + hn;
	addq	%r13, %rbp	# t1, t2
# inputs/bootstrap/source/falcon-keygen.c:7641: 	s = 3 * n;
	movl	$3, %edx	#, tmp135
	salq	%cl, %rdx	# tmp181, tmp135
	movq	%rdx, 56(%rsp)	# tmp135, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7574: 	LDL_dim2_fft3_keygen(d11, l10, g00, g10, g11, logn, full);
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
	call	LDL_dim2_fft3_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7575: 	memcpy(l20, g20, n * sizeof *g20);
	movq	%r14, %rdx	# _1,
	movq	48(%rsp), %rsi	# %sfp,
	movq	24(%rsp), %rdi	# %sfp,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7576: 	falcon_poly_div_autoadj_fft3(l20, g00, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	40(%rsp), %rsi	# %sfp,
	movq	24(%rsp), %rdi	# %sfp,
	call	falcon_poly_div_autoadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7577: 	memcpy(l21, g20, n * sizeof *g20);
	movq	%r14, %rdx	# _1,
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# l21,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7578: 	falcon_poly_muladj_fft3(l21, g10, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	56(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# l21,
	call	falcon_poly_muladj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7579: 	falcon_poly_div_autoadj_fft3(l21, g00, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	40(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# l21,
	call	falcon_poly_div_autoadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7580: 	falcon_poly_neg_fft3(l21, logn, full);
	movl	$0, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%r15, %rdi	# l21,
	call	falcon_poly_neg3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7581: 	falcon_poly_add_fft3(l21, g21, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	72(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# l21,
	call	falcon_poly_add3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7582: 	falcon_poly_div_autoadj_fft3(l21, d11, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	160(%rsp), %rsi	# tmp,
	movq	%r15, %rdi	# l21,
	call	falcon_poly_div_autoadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7583: 	memcpy(d22, l20, n * sizeof *l20);
	movq	%r14, %rdx	# _1,
	movq	24(%rsp), %rsi	# %sfp,
	movq	16(%rsp), %rdi	# %sfp,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7584: 	falcon_poly_muladj_fft3(d22, g20, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	48(%rsp), %rsi	# %sfp,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_muladj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7585: 	falcon_poly_neg_fft3(d22, logn, full);
	movl	$0, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_neg3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7586: 	falcon_poly_add_fft3(d22, g22, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	144(%rsp), %rsi	# g22,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_add3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7587: 	memcpy(tmp, l21, n * sizeof *l21);
	movq	%r14, %rdx	# _1,
	movq	%r15, %rsi	# l21,
	movq	%rbp, %rdi	# t2,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7588: 	falcon_poly_mulselfadj_fft3(tmp, logn, full);
	movl	$0, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%rbp, %rdi	# t2,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7589: 	falcon_poly_mul_autoadj_fft3(tmp, d11, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	160(%rsp), %rsi	# tmp,
	movq	%rbp, %rdi	# t2,
	call	falcon_poly_mul_autoadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7590: 	falcon_poly_sub_fft3(d22, tmp, logn, full);
	movl	$0, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%rbp, %rsi	# t2,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_sub3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7644: 	falcon_poly_split_deep_fft3(t0, t1, g00, logn);
	movl	%ebx, %ecx	# logn,
	movq	40(%rsp), %rdx	# %sfp,
	movq	%r13, %rsi	# t1,
	movq	%r12, %rdi	# t0,
	call	falcon_poly_split_deep_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7645: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	leal	-1(%rbx), %r15d	#, _3
	movl	$0, %edx	#,
	movl	%r15d, %esi	# _3,
	movq	%r13, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7646: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	movq	32(%rsp), %rax	# %sfp, tree
	movq	64(%rsp), %r14	# %sfp, s
	leaq	(%rax,%r14,8), %rdi	#, _5
	movq	%rbp, %r9	# t2,
	movl	%r15d, %r8d	# _3,
	movq	%r12, %rcx	# t0,
	movq	%r13, %rdx	# t1,
	movq	%r12, %rsi	# t0,
	call	ffLDL_inner_fft3_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7646: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	addq	%rax, %r14	# tmp169, s
# inputs/bootstrap/source/falcon-keygen.c:7647: 	falcon_poly_split_deep_fft3(t0, t1, d11, logn);
	movl	%ebx, %ecx	# logn,
	movq	160(%rsp), %rdx	# tmp,
	movq	%r13, %rsi	# t1,
	movq	%r12, %rdi	# t0,
	call	falcon_poly_split_deep_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7648: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	movl	$0, %edx	#,
	movl	%r15d, %esi	# _3,
	movq	%r13, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7649: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	movq	32(%rsp), %rax	# %sfp, tree
	leaq	(%rax,%r14,8), %rdi	#, _7
	movq	%rbp, %r9	# t2,
	movl	%r15d, %r8d	# _3,
	movq	%r12, %rcx	# t0,
	movq	%r13, %rdx	# t1,
	movq	%r12, %rsi	# t0,
	call	ffLDL_inner_fft3_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7649: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	addq	%rax, %r14	# tmp170, s
# inputs/bootstrap/source/falcon-keygen.c:7650: 	falcon_poly_split_deep_fft3(t0, t1, d22, logn);
	movl	%ebx, %ecx	# logn,
	movq	16(%rsp), %rdx	# %sfp,
	movq	%r13, %rsi	# t1,
	movq	%r12, %rdi	# t0,
	call	falcon_poly_split_deep_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7651: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	movl	$0, %edx	#,
	movl	%r15d, %esi	# _3,
	movq	%r13, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7652: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	movq	32(%rsp), %rax	# %sfp, tree
	leaq	(%rax,%r14,8), %rdi	#, _9
	movq	%rbp, %r9	# t2,
	movl	%r15d, %r8d	# _3,
	movq	%r12, %rcx	# t0,
	movq	%r13, %rdx	# t1,
	movq	%r12, %rsi	# t0,
	call	ffLDL_inner_fft3_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7652: 	s += ffLDL_inner_fft3_keygen(tree + s, t0, t1, t0, logn - 1, t2);
	addq	%r14, %rax	# s, s_44
# inputs/bootstrap/source/falcon-keygen.c:7654: }
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
.LFE117:
	.size	ffLDL_depth1_fft3_keygen, .-ffLDL_depth1_fft3_keygen
	.type	poly_sub_scaled_ntt, @function
poly_sub_scaled_ntt:
.LFB82:
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
	subq	$160, %rsp	#,
	.cfi_def_cfa_offset 216
	movq	%rdi, %r13	# tmp344, F
	movq	%rsi, 120(%rsp)	# tmp345, %sfp
	movq	%rdx, %r15	# tmp346, Fstride
	movq	%rcx, 104(%rsp)	# tmp347, %sfp
	movq	%r8, 24(%rsp)	# flen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4607: 	n = MKN(logn, full);
	movl	240(%rsp), %eax	# full, tmp420
	leal	1(%rax,%rax), %eax	#, _3
	movl	232(%rsp), %ecx	# logn, _4
	subl	240(%rsp), %ecx	# full, _4
# inputs/bootstrap/source/falcon-keygen.c:4607: 	n = MKN(logn, full);
	salq	%cl, %rax	# _4, _3
	movq	%rax, %r14	# _3, n
# inputs/bootstrap/source/falcon-keygen.c:4608: 	tlen = flen + 1;
	leaq	1(%r8), %rdi	#, tlen
	movq	%rdi, 56(%rsp)	# tlen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4610: 	igm = gm + MKN(logn, 0);
	movl	$4, %eax	#, tmp256
	movzbl	232(%rsp), %ecx	# logn, tmp425
	salq	%cl, %rax	# tmp425, _5
# inputs/bootstrap/source/falcon-keygen.c:4610: 	igm = gm + MKN(logn, 0);
	movq	%rax, %r11	# _5, igm
	addq	256(%rsp), %r11	# tmp, igm
# inputs/bootstrap/source/falcon-keygen.c:4611: 	fk = igm + MKN(logn, 0);
	leaq	(%r11,%rax), %rcx	#, fk
	movq	%rcx, 128(%rsp)	# fk, %sfp
	leaq	0(,%rdi,4), %rbp	#, _208
# inputs/bootstrap/source/falcon-keygen.c:4612: 	t1 = fk + n * tlen;
	movq	%r14, %r10	# n, _8
	imulq	%rbp, %r10	# _208, _8
# inputs/bootstrap/source/falcon-keygen.c:4612: 	t1 = fk + n * tlen;
	addq	%rcx, %r10	# fk, t1
# inputs/bootstrap/source/falcon-keygen.c:4614: 	primes = ternary ? PRIMES3 : PRIMES2;
	cmpl	$0, 248(%rsp)	#, ternary
	leaq	PRIMES2(%rip), %rdx	#, tmp331
	leaq	PRIMES3(%rip), %rax	#, tmp332
	cmove	%rdx, %rax	# tmp331,, tmp332
	movq	%rax, %rbx	# tmp332, iftmp.97_40
# inputs/bootstrap/source/falcon-keygen.c:4619: 	for (u = 0; u < tlen; u ++) {
	testq	%rdi, %rdi	# tlen
	je	.L418	#,
# inputs/bootstrap/source/falcon-keygen.c:4642: 			v < n; v ++, y += fstride, x += tlen)
	leaq	0(,%r9,4), %rax	#, _21
	movq	%rax, 32(%rsp)	# _21, %sfp
	movq	%rcx, 72(%rsp)	# fk, %sfp
	leaq	4(%rbx), %rax	#, ivtmp.798
	movq	%rax, 64(%rsp)	# ivtmp.798, %sfp
	leaq	(%r10,%r14,4), %rax	#, _217
	movq	%rax, 112(%rsp)	# _217, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4619: 	for (u = 0; u < tlen; u ++) {
	movq	$0, 88(%rsp)	#, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2617: 	x --;
	movl	%r8d, %eax	# flen, tmp438
	subl	$1, %eax	#, x
	movl	%eax, 100(%rsp)	# x, %sfp
	movq	%rbx, 136(%rsp)	# iftmp.97_40, %sfp
	movq	%r11, 80(%rsp)	# igm, %sfp
	movq	%r10, 48(%rsp)	# t1, %sfp
	movq	%r13, 144(%rsp)	# F, %sfp
	movq	%r15, 152(%rsp)	# Fstride, %sfp
	jmp	.L436	#
.L420:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %r10d	# r, _160
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r10, %r10	# _160, powmult_46
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rsi, %rax	# _146, _163
	imulq	%r10, %rax	# powmult_46, _163
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _164
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rdx, %rax	# _149, w_166
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rax	# powmult_46, _167
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _168
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _172
	sarl	$31, %r10d	#, _172
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r10d	# p, _174
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r10d, %eax	# _174, r
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	addl	$1, %ecx	#, i
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	%edi, %r10d	# tmp281, _177
	sall	%cl, %r10d	# i, _177
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	cmpl	%r10d, %r9d	# _177, x
	jb	.L459	#,
.L421:
# inputs/bootstrap/source/falcon-keygen.c:2621: 		if ((x & (1U << i)) != 0) {
	btl	%ecx, %r9d	# i, x
	jnc	.L420	#,
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r8d, %r8d	# z, _142
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %r10d	# r, _144
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r10, %r8	# _144, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rsi, %r10	# _146, _147
	imulq	%r8, %r10	# z, _147
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %r10d	#, _148
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rdx, %r10	# _149, w_150
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %r10	# z, _151
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %r10	#, _152
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %r10d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r10d, %r8d	# d, _156
	sarl	$31, %r8d	#, _156
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r8d	# p, _158
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r10d, %r8d	# d, z
	jmp	.L420	#
.L459:
	movl	%r8d, 16(%rsp)	# z, %sfp
.L419:
# inputs/bootstrap/source/falcon-keygen.c:4627: 		if (ternary) {
	cmpl	$0, 248(%rsp)	#, ternary
	je	.L422	#,
# inputs/bootstrap/source/falcon-keygen.c:4628: 			modp_mkgm3(gm, igm, logn, full, primes[u].g, p, p0i);
	movl	(%r12), %r8d	# MEM[(unsigned int *)_261], MEM[(unsigned int *)_261]
	movl	(%rsp), %eax	# %sfp, p0i
	pushq	%rax	# p0i
	.cfi_def_cfa_offset 224
	movl	%ebx, %r9d	# p,
	movl	248(%rsp), %ecx	# full,
	movl	240(%rsp), %edx	# logn,
	movq	88(%rsp), %rsi	# %sfp,
	movq	264(%rsp), %rdi	# tmp,
	call	modp_mkgm3	#
# inputs/bootstrap/source/falcon-keygen.c:4633: 		for (v = 0; v < n; v ++) {
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 216
	testq	%r14, %r14	# n
	je	.L460	#,
.L423:
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	$0, %edx	#, v
	movq	48(%rsp), %rsi	# %sfp, t1
	movq	216(%rsp), %rdi	# k, k
	.p2align 5
.L426:
# inputs/bootstrap/source/falcon-keygen.c:4634: 			t1[v] = modp_set(k[v], p);
	movl	(%rdi,%rdx,4), %ecx	# MEM[(const int32_t *)k_102(D) + v_239 * 4], _17
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%ecx, %eax	# _17, _91
	sarl	$31, %eax	#, _91
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	%ebx, %eax	# p, _103
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%ecx, %eax	# _17, tmp286
	movl	%eax, (%rsi,%rdx,4)	# tmp286, MEM[(uint32_t *)t1_58 + v_239 * 4]
# inputs/bootstrap/source/falcon-keygen.c:4633: 		for (v = 0; v < n; v ++) {
	addq	$1, %rdx	#, v
# inputs/bootstrap/source/falcon-keygen.c:4633: 		for (v = 0; v < n; v ++) {
	cmpq	%r14, %rdx	# n, v
	jb	.L426	#,
# inputs/bootstrap/source/falcon-keygen.c:4636: 		if (ternary) {
	cmpl	$0, 248(%rsp)	#, ternary
	jne	.L427	#,
# inputs/bootstrap/source/falcon-keygen.c:4639: 			modp_NTT2(t1, gm, logn, p, p0i);
	movl	(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	232(%rsp), %ecx	# logn,
	movq	256(%rsp), %rdx	# tmp,
	movl	$1, %esi	#,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:4641: 		for (v = 0, y = f, x = fk + u;
	movq	72(%rsp), %rax	# %sfp, ivtmp.797
	movq	%rax, 40(%rsp)	# ivtmp.797, %sfp
	jmp	.L443	#
.L422:
# inputs/bootstrap/source/falcon-keygen.c:4630: 			modp_mkgm2(gm, igm, logn, primes[u].g, p, p0i);
	movl	(%r12), %ecx	# MEM[(unsigned int *)_261], MEM[(unsigned int *)_261]
	movl	(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	232(%rsp), %edx	# logn,
	movq	80(%rsp), %rsi	# %sfp,
	movq	256(%rsp), %rdi	# tmp,
	call	modp_mkgm2	#
# inputs/bootstrap/source/falcon-keygen.c:4633: 		for (v = 0; v < n; v ++) {
	testq	%r14, %r14	# n
	jne	.L423	#,
# inputs/bootstrap/source/falcon-keygen.c:4639: 			modp_NTT2(t1, gm, logn, p, p0i);
	movl	(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	232(%rsp), %ecx	# logn,
	movq	256(%rsp), %rdx	# tmp,
	movl	$1, %esi	#,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:4641: 		for (v = 0, y = f, x = fk + u;
	movq	72(%rsp), %rax	# %sfp, ivtmp.797
	movq	%rax, 40(%rsp)	# ivtmp.797, %sfp
.L430:
# inputs/bootstrap/source/falcon-keygen.c:4649: 			modp_NTT2_ext(fk + u, tlen, gm, logn, p, p0i);
	movl	(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	232(%rsp), %ecx	# logn,
	movq	256(%rsp), %rdx	# tmp,
	movq	56(%rsp), %rsi	# %sfp,
	movq	40(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
	jmp	.L433	#
.L434:
# inputs/bootstrap/source/falcon-keygen.c:4658: 			modp_iNTT2_ext(fk + u, tlen, igm, logn, p, p0i);
	movl	(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	232(%rsp), %ecx	# logn,
	movq	80(%rsp), %rdx	# %sfp,
	movq	56(%rsp), %rsi	# %sfp,
	movq	40(%rsp), %rdi	# %sfp,
	call	modp_iNTT2_ext	#
	jmp	.L435	#
.L462:
	movq	136(%rsp), %rbx	# %sfp, iftmp.97_40
	movq	48(%rsp), %r10	# %sfp, t1
	movq	144(%rsp), %r13	# %sfp, F
	movq	152(%rsp), %r15	# %sfp, Fstride
.L418:
# inputs/bootstrap/source/falcon-keygen.c:4665: 	zint_rebuild_CRT(fk, tlen, tlen, n, primes, 1, t1);
	pushq	%r10	# t1
	.cfi_def_cfa_offset 224
	movl	$1, %r9d	#,
	movq	%rbx, %r8	# iftmp.97_40,
	movq	%r14, %rcx	# n,
	movq	64(%rsp), %rax	# %sfp, tlen
	movq	%rax, %rdx	# tlen,
	movq	%rax, %rsi	# tmp1,
	movq	136(%rsp), %rdi	# %sfp,
	call	zint_rebuild_CRT	#
# inputs/bootstrap/source/falcon-keygen.c:4670: 	sch = sc / 31;
	movl	232(%rsp), %edx	# sc, sc
	imulq	$138547333, %rdx, %rdx	#, sc, tmp306
	shrq	$32, %rdx	#, tmp307
	movl	232(%rsp), %eax	# sc, tmp308
	subl	%edx, %eax	# tmp307, tmp308
	shrl	%eax	# tmp309
	addl	%edx, %eax	# tmp307, tmp310
	shrl	$4, %eax	#, sch
# inputs/bootstrap/source/falcon-keygen.c:4671: 	scl = sc % 31;
	movl	%eax, %ebx	# sch, tmp318
	sall	$5, %ebx	#, tmp318
	movl	%ebx, %edx	# tmp318, tmp318
	subl	%eax, %edx	# sch, tmp319
	movl	232(%rsp), %ebx	# sc, scl
	subl	%edx, %ebx	# tmp319, scl
# inputs/bootstrap/source/falcon-keygen.c:4672: 	for (u = 0, x = F, y = fk; u < n; u ++, x += Fstride, y += tlen) {
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 216
	testq	%r14, %r14	# n
	je	.L416	#,
# inputs/bootstrap/source/falcon-keygen.c:4672: 	for (u = 0, x = F, y = fk; u < n; u ++, x += Fstride, y += tlen) {
	leaq	0(,%r15,4), %r12	#, _28
	movl	%eax, %esi	# sch, _138
	leaq	0(%r13,%rsi,4), %r8	#, ivtmp.766
# inputs/bootstrap/source/falcon-keygen.c:4672: 	for (u = 0, x = F, y = fk; u < n; u ++, x += Fstride, y += tlen) {
	movl	$0, %r13d	#, u
	movq	120(%rsp), %rax	# %sfp, _19
	subq	%rsi, %rax	# _138, _19
# inputs/bootstrap/source/falcon-keygen.c:4408: 	cc = 0;
	movl	$0, %r15d	#, cc
# inputs/bootstrap/source/falcon-keygen.c:4419: 		tw = wy >> (31 - scl);
	movl	$31, %r11d	#, tmp340
	subl	%ebx, %r11d	# scl, _197
	movq	%r12, 8(%rsp)	# _28, %sfp
	movq	%r14, 16(%rsp)	# n, %sfp
	movq	56(%rsp), %r12	# %sfp, tlen
	movq	%r13, %rcx	# u, u
	movq	%rsi, 40(%rsp)	# _138, %sfp
	movq	%rbp, 32(%rsp)	# _208, %sfp
	movq	128(%rsp), %rbp	# %sfp, fk
	movq	24(%rsp), %rdi	# %sfp, flen
	movq	%rax, %r14	# _19, _19
	jmp	.L441	#
.L439:
# inputs/bootstrap/source/falcon-keygen.c:4418: 		wys = ((wy << scl) & 0x7FFFFFFF) | tw;
	movl	%r13d, %esi	# iftmp.98_191, _193
	movl	%ebx, %ecx	# scl, tmp472
	sall	%cl, %esi	# tmp472, _193
# inputs/bootstrap/source/falcon-keygen.c:4418: 		wys = ((wy << scl) & 0x7FFFFFFF) | tw;
	andl	$2147483647, %esi	#, _194
# inputs/bootstrap/source/falcon-keygen.c:4418: 		wys = ((wy << scl) & 0x7FFFFFFF) | tw;
	orl	%r9d, %esi	# tw, wys
# inputs/bootstrap/source/falcon-keygen.c:4419: 		tw = wy >> (31 - scl);
	movl	%r13d, %r9d	# iftmp.98_191, iftmp.98_191
	movl	%r11d, %ecx	# _197, tmp474
	shrl	%cl, %r9d	# tmp474, iftmp.98_191
# inputs/bootstrap/source/falcon-keygen.c:4421: 		w = x[u] - wys - cc;
	movl	(%r8,%rdx,4), %ecx	# MEM[(uint32_t *)_48 + ivtmp.750_243 * 4], _203
	subl	%eax, %ecx	# cc, _203
	movl	%ecx, %eax	# _203, _203
	subl	%esi, %eax	# wys, _203
# inputs/bootstrap/source/falcon-keygen.c:4422: 		x[u] = w & 0x7FFFFFFF;
	movl	%eax, %ecx	# w, tmp330
	andl	$2147483647, %ecx	#, tmp330
	movl	%ecx, (%r8,%rdx,4)	# tmp330, MEM[(uint32_t *)_48 + ivtmp.750_243 * 4]
# inputs/bootstrap/source/falcon-keygen.c:4423: 		cc = w >> 31;
	shrl	$31, %eax	#, cc
# inputs/bootstrap/source/falcon-keygen.c:4409: 	for (u = sch; u < xlen; u ++) {
	addq	$1, %rdx	#, ivtmp.750
	cmpq	%rdx, %r14	# ivtmp.750, _19
	je	.L461	#,
.L440:
# inputs/bootstrap/source/falcon-keygen.c:4417: 		wy = v < ylen ? y[v] : ysign;
	movl	%r10d, %r13d	# ysign, iftmp.98_191
# inputs/bootstrap/source/falcon-keygen.c:4417: 		wy = v < ylen ? y[v] : ysign;
	cmpq	%r12, %rdx	# tlen, ivtmp.750
	jnb	.L439	#,
# inputs/bootstrap/source/falcon-keygen.c:4417: 		wy = v < ylen ? y[v] : ysign;
	movl	0(%rbp,%rdx,4), %r13d	# MEM[(const uint32_t *)y_236 + ivtmp.750_243 * 4], iftmp.98_191
	jmp	.L439	#
.L461:
	movq	(%rsp), %rcx	# %sfp, u
.L438:
# inputs/bootstrap/source/falcon-keygen.c:4672: 	for (u = 0, x = F, y = fk; u < n; u ++, x += Fstride, y += tlen) {
	addq	$1, %rcx	#, u
# inputs/bootstrap/source/falcon-keygen.c:4672: 	for (u = 0, x = F, y = fk; u < n; u ++, x += Fstride, y += tlen) {
	movq	32(%rsp), %rax	# %sfp, _208
	addq	%rax, %rbp	# _208, fk
# inputs/bootstrap/source/falcon-keygen.c:4672: 	for (u = 0, x = F, y = fk; u < n; u ++, x += Fstride, y += tlen) {
	movq	8(%rsp), %rax	# %sfp, _28
	addq	%rax, %r8	# _28, ivtmp.766
	cmpq	%rcx, 16(%rsp)	# u, %sfp
	je	.L416	#,
.L441:
# inputs/bootstrap/source/falcon-keygen.c:4402: 	if (ylen == 0) {
	testq	%r12, %r12	# tlen
	je	.L438	#,
# inputs/bootstrap/source/falcon-keygen.c:4406: 	ysign = -(y[ylen - 1] >> 30) >> 1;
	movl	0(%rbp,%rdi,4), %r10d	# MEM[(const uint32_t *)y_236 + flen_53(D) * 4], _183
	shrl	$30, %r10d	#, _183
# inputs/bootstrap/source/falcon-keygen.c:4406: 	ysign = -(y[ylen - 1] >> 30) >> 1;
	negl	%r10d	# _184
# inputs/bootstrap/source/falcon-keygen.c:4406: 	ysign = -(y[ylen - 1] >> 30) >> 1;
	shrl	%r10d	# ysign
# inputs/bootstrap/source/falcon-keygen.c:4409: 	for (u = sch; u < xlen; u ++) {
	movq	120(%rsp), %rsi	# %sfp, Flen
	cmpq	%rsi, 40(%rsp)	# Flen, %sfp
	jnb	.L438	#,
	movl	$0, %edx	#, ivtmp.750
# inputs/bootstrap/source/falcon-keygen.c:4408: 	cc = 0;
	movl	%r15d, %eax	# cc, cc
# inputs/bootstrap/source/falcon-keygen.c:4407: 	tw = 0;
	movl	%r15d, %r9d	# cc, tw
	movq	%rcx, (%rsp)	# u, %sfp
	jmp	.L440	#
.L460:
# inputs/bootstrap/source/falcon-keygen.c:4637: 			modp_NTT3(t1, gm, logn, full, p, p0i);
	movl	(%rsp), %eax	# %sfp, p0i
	pushq	%rax	# p0i
	.cfi_def_cfa_offset 224
	movl	%ebx, %r9d	# p,
	movl	248(%rsp), %r8d	# full,
	movl	240(%rsp), %ecx	# logn,
	movq	264(%rsp), %rdx	# tmp,
	movl	$1, %esi	#,
	movq	56(%rsp), %rdi	# %sfp,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:4641: 		for (v = 0, y = f, x = fk + u;
	movq	80(%rsp), %rax	# %sfp, ivtmp.797
	movq	%rax, 48(%rsp)	# ivtmp.797, %sfp
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 216
	jmp	.L442	#
.L427:
# inputs/bootstrap/source/falcon-keygen.c:4637: 			modp_NTT3(t1, gm, logn, full, p, p0i);
	movl	(%rsp), %eax	# %sfp, p0i
	pushq	%rax	# p0i
	.cfi_def_cfa_offset 224
	movl	%ebx, %r9d	# p,
	movl	248(%rsp), %r8d	# full,
	movl	240(%rsp), %ecx	# logn,
	movq	264(%rsp), %rdx	# tmp,
	movl	$1, %esi	#,
	movq	56(%rsp), %rdi	# %sfp,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:4641: 		for (v = 0, y = f, x = fk + u;
	movq	80(%rsp), %rax	# %sfp, ivtmp.797
	movq	%rax, 48(%rsp)	# ivtmp.797, %sfp
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 216
.L443:
# inputs/bootstrap/source/falcon-keygen.c:4641: 		for (v = 0, y = f, x = fk + u;
	movq	104(%rsp), %r15	# %sfp, y
# inputs/bootstrap/source/falcon-keygen.c:4641: 		for (v = 0, y = f, x = fk + u;
	movq	40(%rsp), %r13	# %sfp, x
# inputs/bootstrap/source/falcon-keygen.c:4641: 		for (v = 0, y = f, x = fk + u;
	movl	$0, %r12d	#, v
.L429:
# inputs/bootstrap/source/falcon-keygen.c:4644: 			*x = zint_mod_small_signed(y, flen, p, p0i, R2, Rx);
	movl	16(%rsp), %r9d	# %sfp,
	movl	8(%rsp), %r8d	# %sfp,
	movl	(%rsp), %ecx	# %sfp,
	movl	%ebx, %edx	# p,
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# y,
	call	zint_mod_small_signed	#
# inputs/bootstrap/source/falcon-keygen.c:4644: 			*x = zint_mod_small_signed(y, flen, p, p0i, R2, Rx);
	movl	%eax, 0(%r13)	# tmp352, MEM[(uint32_t *)x_232]
# inputs/bootstrap/source/falcon-keygen.c:4642: 			v < n; v ++, y += fstride, x += tlen)
	addq	$1, %r12	#, v
# inputs/bootstrap/source/falcon-keygen.c:4642: 			v < n; v ++, y += fstride, x += tlen)
	movq	32(%rsp), %rax	# %sfp, _21
	addq	%rax, %r15	# _21, y
# inputs/bootstrap/source/falcon-keygen.c:4642: 			v < n; v ++, y += fstride, x += tlen)
	addq	%rbp, %r13	# _208, x
# inputs/bootstrap/source/falcon-keygen.c:4642: 			v < n; v ++, y += fstride, x += tlen)
	cmpq	%r14, %r12	# n, v
	jb	.L429	#,
# inputs/bootstrap/source/falcon-keygen.c:4646: 		if (ternary) {
	cmpl	$0, 248(%rsp)	#, ternary
	je	.L430	#,
.L442:
# inputs/bootstrap/source/falcon-keygen.c:4647: 			modp_NTT3_ext(fk + u, tlen, gm, logn, full, p, p0i);
	movl	(%rsp), %eax	# %sfp, p0i
	pushq	%rax	# p0i
	.cfi_def_cfa_offset 224
	movl	%ebx, %r9d	# p,
	movl	248(%rsp), %r8d	# full,
	movl	240(%rsp), %ecx	# logn,
	movq	264(%rsp), %rdx	# tmp,
	movq	64(%rsp), %rsi	# %sfp,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_NTT3_ext	#
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 216
.L433:
# inputs/bootstrap/source/falcon-keygen.c:4651: 		for (v = 0, x = fk + u; v < n; v ++, x += tlen) {
	movq	48(%rsp), %rcx	# %sfp, ivtmp.774
	movq	40(%rsp), %rdx	# %sfp, x
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	(%rsp), %edi	# %sfp, _122
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebx, %esi	# p, _125
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	8(%rsp), %r8d	# %sfp, _74
	movq	112(%rsp), %r9	# %sfp, _217
# inputs/bootstrap/source/falcon-keygen.c:4651: 		for (v = 0, x = fk + u; v < n; v ++, x += tlen) {
	testq	%r14, %r14	# n
	je	.L432	#,
.L431:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rcx), %r10d	# MEM[(uint32_t *)_224], _119
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdx), %eax	# MEM[(uint32_t *)x_233], _120
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r10	# _120, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r10, %rax	# z, _123
	imulq	%rdi, %rax	# _122, _123
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _124
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _125, w_126
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rax	# z, _127
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _128
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _132
	sarl	$31, %r10d	#, _132
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r10d	# p, _134
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r10), %r10d	#, _76
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r8, %r10	# _74, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r10, %rax	# z, _107
	imulq	%rdi, %rax	# _122, _107
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _108
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _125, w_109
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rax	# z, _110
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _111
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _115
	sarl	$31, %r10d	#, _115
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r10d	# p, _117
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r10d, %eax	# _117, tmp304
	movl	%eax, (%rdx)	# tmp304, MEM[(uint32_t *)x_233]
# inputs/bootstrap/source/falcon-keygen.c:4651: 		for (v = 0, x = fk + u; v < n; v ++, x += tlen) {
	addq	%rbp, %rdx	# _208, x
# inputs/bootstrap/source/falcon-keygen.c:4651: 		for (v = 0, x = fk + u; v < n; v ++, x += tlen) {
	addq	$4, %rcx	#, ivtmp.774
	cmpq	%rcx, %r9	# ivtmp.774, _217
	jne	.L431	#,
.L432:
# inputs/bootstrap/source/falcon-keygen.c:4655: 		if (ternary) {
	cmpl	$0, 248(%rsp)	#, ternary
	je	.L434	#,
# inputs/bootstrap/source/falcon-keygen.c:4656: 			modp_iNTT3_ext(fk + u, tlen, igm, logn, full, p, p0i);
	movl	(%rsp), %eax	# %sfp, p0i
	pushq	%rax	# p0i
	.cfi_def_cfa_offset 224
	movl	%ebx, %r9d	# p,
	movl	248(%rsp), %r8d	# full,
	movl	240(%rsp), %ecx	# logn,
	movq	88(%rsp), %rdx	# %sfp,
	movq	64(%rsp), %rsi	# %sfp,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_iNTT3_ext	#
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 216
.L435:
# inputs/bootstrap/source/falcon-keygen.c:4619: 	for (u = 0; u < tlen; u ++) {
	movq	88(%rsp), %rdi	# %sfp, u
	leaq	1(%rdi), %rax	#, u
# inputs/bootstrap/source/falcon-keygen.c:4619: 	for (u = 0; u < tlen; u ++) {
	addq	$4, 72(%rsp)	#, %sfp
	addq	$12, 64(%rsp)	#, %sfp
	cmpq	%rdi, 24(%rsp)	# u, %sfp
	je	.L462	#,
	movq	%rax, 88(%rsp)	# u, %sfp
.L436:
	movq	64(%rsp), %rax	# %sfp, ivtmp.798
	movq	%rax, %r12	# ivtmp.798, _261
# inputs/bootstrap/source/falcon-keygen.c:4623: 		p = primes[u].p;
	movl	-4(%rax), %ebx	# MEM[(unsigned int *)_261 + -4B], p
# inputs/bootstrap/source/falcon-keygen.c:4624: 		p0i = modp_ninv31(p);
	movl	%ebx, %edi	# p,
	call	modp_ninv31	#
	movl	%eax, %r15d	# tmp350, p0i
	movl	%eax, (%rsp)	# p0i, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4625: 		R2 = modp_R2(p, p0i);
	movl	%eax, %esi	# p0i,
	movl	%ebx, %edi	# p,
	call	modp_R2	#
	movl	%eax, %edi	# tmp351, R2
	movl	%eax, 8(%rsp)	# R2, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	movl	$-2147483648, %eax	#, tmp259
	movl	%eax, %r8d	# tmp259, tmp259
	subl	%ebx, %r8d	# p, tmp259
	movl	%r8d, 16(%rsp)	# z, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	100(%rsp), %r9d	# %sfp, x
	testl	%r9d, %r9d	# x
	je	.L419	#,
# inputs/bootstrap/source/falcon-keygen.c:2618: 	r = R2;
	movl	%edi, %eax	# R2, r
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	$0, %ecx	#, i
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r15d, %esi	# p0i, _146
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebx, %edx	# p, _149
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	$1, %edi	#, tmp281
	jmp	.L421	#
.L416:
# inputs/bootstrap/source/falcon-keygen.c:4675: }
	addq	$160, %rsp	#,
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
.LFE82:
	.size	poly_sub_scaled_ntt, .-poly_sub_scaled_ntt
	.type	make_fg_step, @function
make_fg_step:
.LFB97:
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
	subq	$216, %rsp	#,
	.cfi_def_cfa_offset 272
	movq	%rdi, 176(%rsp)	# tmp508, %sfp
	movl	%esi, 44(%rsp)	# logn, %sfp
	movl	%edx, %eax	# tmp510, depth
	movl	%ecx, %ebx	# tmp511, ter
	movl	%ecx, 40(%rsp)	# ter, %sfp
	movl	%r8d, 16(%rsp)	# tmp512, %sfp
	movl	%r9d, 168(%rsp)	# tmp513, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5385: 	n = (size_t)1 << logn;
	movl	$1, %edx	#, tmp378
	movl	%esi, %ecx	# logn, tmp611
	salq	%cl, %rdx	# tmp611, tmp378
	movq	%rdx, %rbp	# tmp378, n
# inputs/bootstrap/source/falcon-keygen.c:5386: 	hn = n >> 1;
	movq	%rdx, %rdi	# n, hn
	shrq	%rdi	# hn
	movq	%rdi, 64(%rsp)	# hn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5387: 	if (ter) {
	testl	%ebx, %ebx	# ter
	je	.L464	#,
# inputs/bootstrap/source/falcon-keygen.c:5388: 		slen = MAX_BL_SMALL3[depth];
	leaq	MAX_BL_SMALL3(%rip), %rdx	#, tmp379
	movl	%eax, %ecx	# depth, depth
	movq	(%rdx,%rcx,8), %rsi	# MAX_BL_SMALL3[depth_108(D)], slen
	movq	%rsi, 8(%rsp)	# slen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5389: 		tlen = MAX_BL_SMALL3[depth + 1];
	leal	1(%rax), %eax	#, _1
	movq	(%rdx,%rax,8), %rax	# MAX_BL_SMALL3[_1], tlen
	movq	%rax, 80(%rsp)	# tlen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5390: 		primes = PRIMES3;
	leaq	PRIMES3(%rip), %rbx	#, primes
.L465:
# inputs/bootstrap/source/falcon-keygen.c:5401: 	gd = fd + hn * tlen;
	movq	80(%rsp), %rax	# %sfp, _128
	movq	64(%rsp), %rdi	# %sfp, hn
	imulq	%rdi, %rax	# hn, _128
	salq	$2, %rax	#, _4
# inputs/bootstrap/source/falcon-keygen.c:5401: 	gd = fd + hn * tlen;
	movq	176(%rsp), %rsi	# %sfp, data
	leaq	(%rsi,%rax), %rdi	#, gd
# inputs/bootstrap/source/falcon-keygen.c:5402: 	fs = gd + hn * tlen;
	movq	%rdi, 184(%rsp)	# gd, %sfp
	addq	%rax, %rdi	# _4, fs
	movq	%rdi, 160(%rsp)	# fs, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5403: 	gs = fs + n * slen;
	movq	8(%rsp), %r15	# %sfp, slen
	movq	%r15, %rax	# slen, _7
	movl	44(%rsp), %r13d	# %sfp, logn
	movl	%r13d, %ecx	# logn, tmp625
	salq	%cl, %rax	# tmp625, _7
# inputs/bootstrap/source/falcon-keygen.c:5403: 	gs = fs + n * slen;
	leaq	0(,%rax,4), %rdx	#, _8
# inputs/bootstrap/source/falcon-keygen.c:5403: 	gs = fs + n * slen;
	leaq	(%rdi,%rdx), %rcx	#, gs
# inputs/bootstrap/source/falcon-keygen.c:5404: 	gm = gs + n * slen;
	movq	%rcx, 152(%rsp)	# gs, %sfp
	leaq	(%rcx,%rdx), %r14	#, gm
	movq	%r14, 48(%rsp)	# gm, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5405: 	igm = gm + n;
	movl	$4, %edx	#, tmp390
	movl	%r13d, %ecx	# logn, tmp630
	salq	%cl, %rdx	# tmp630, _9
# inputs/bootstrap/source/falcon-keygen.c:5405: 	igm = gm + n;
	addq	%rdx, %r14	# _9, igm
	movq	%r14, 56(%rsp)	# igm, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5406: 	t1 = igm + n;
	addq	%r14, %rdx	# igm, t1
	movq	%rdx, 32(%rsp)	# t1, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5407: 	memmove(fs, data, 2 * n * slen * sizeof *data);
	leaq	0(,%rax,8), %rdx	#, _10
	movq	%rdi, %r14	# fs, fs
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5413: 	for (u = 0; u < slen; u ++) {
	testq	%r15, %r15	# slen
	je	.L466	#,
# inputs/bootstrap/source/falcon-keygen.c:5427: 		for (v = 0, x = fs + u; v < n; v ++, x += slen) {
	leaq	0(,%r15,4), %r12	#, _19
# inputs/bootstrap/source/falcon-keygen.c:5437: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	movq	80(%rsp), %rax	# %sfp, tlen
	leaq	0(,%rax,4), %r15	#, _24
	movq	176(%rsp), %rsi	# %sfp, data
	movq	%rsi, 112(%rsp)	# data, %sfp
	movq	184(%rsp), %rdi	# %sfp, gd
	movq	%rdi, 120(%rsp)	# gd, %sfp
	movq	152(%rsp), %rcx	# %sfp, gs
	movq	%rcx, 128(%rsp)	# gs, %sfp
	movq	%r14, 136(%rsp)	# fs, %sfp
	leaq	4(%rbx), %rax	#, ivtmp.901
	movq	%rax, 72(%rsp)	# ivtmp.901, %sfp
	movl	$4, %eax	#, tmp394
	movl	%r13d, %esi	# logn, logn
	movl	%r13d, %ecx	# logn, tmp643
	salq	%cl, %rax	# tmp643, _457
	movq	32(%rsp), %rdi	# %sfp, t1
	leaq	(%rax,%rdi), %r14	#, _459
	movq	%rdi, %rax	# t1, t1
	movq	64(%rsp), %rdi	# %sfp, hn
	leaq	(%rax,%rdi,8), %r13	#, _451
# inputs/bootstrap/source/falcon-keygen.c:5413: 	for (u = 0; u < slen; u ++) {
	movq	$0, 24(%rsp)	#, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5490: 				modp_iNTT2_ext(fd + u, tlen, igm,
	leal	-1(%rsi), %eax	#, _35
	movl	%eax, 172(%rsp)	# _35, %sfp
	movq	%rbx, 192(%rsp)	# primes, %sfp
	movq	%rbp, 200(%rsp)	# n, %sfp
	jmp	.L486	#
.L464:
# inputs/bootstrap/source/falcon-keygen.c:5392: 		slen = MAX_BL_SMALL2[depth];
	leaq	MAX_BL_SMALL2(%rip), %rdx	#, tmp384
	movl	%eax, %ecx	# depth, depth
	movq	(%rdx,%rcx,8), %rsi	# MAX_BL_SMALL2[depth_108(D)], slen
	movq	%rsi, 8(%rsp)	# slen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5393: 		tlen = MAX_BL_SMALL2[depth + 1];
	leal	1(%rax), %eax	#, _2
	movq	(%rdx,%rax,8), %rax	# MAX_BL_SMALL2[_2], tlen
	movq	%rax, 80(%rsp)	# tlen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5394: 		primes = PRIMES2;
	leaq	PRIMES2(%rip), %rbx	#, primes
	jmp	.L465	#
.L467:
# inputs/bootstrap/source/falcon-keygen.c:5424: 			modp_mkgm2(gm, igm, logn, primes[u].g, p, p0i);
	movq	72(%rsp), %rax	# %sfp, ivtmp.901
	movl	(%rax), %ecx	# MEM[(unsigned int *)_476], MEM[(unsigned int *)_476]
	movl	%ebp, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	44(%rsp), %edx	# %sfp,
	movq	56(%rsp), %rsi	# %sfp,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_mkgm2	#
	jmp	.L468	#
.L471:
# inputs/bootstrap/source/falcon-keygen.c:5434: 				modp_NTT2(t1, gm, logn, p, p0i);
	movl	%ebp, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	44(%rsp), %ecx	# %sfp,
	movq	48(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	32(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
	jmp	.L472	#
.L475:
# inputs/bootstrap/source/falcon-keygen.c:5450: 				modp_iNTT2_ext(fs + u, slen, igm,
	movl	%ebp, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	44(%rsp), %ecx	# %sfp,
	movq	56(%rsp), %rdx	# %sfp,
	movq	8(%rsp), %rsi	# %sfp,
	movq	104(%rsp), %rdi	# %sfp,
	call	modp_iNTT2_ext	#
	jmp	.L474	#
.L478:
# inputs/bootstrap/source/falcon-keygen.c:5462: 				modp_NTT2(t1, gm, logn, p, p0i);
	movl	%ebp, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	44(%rsp), %ecx	# %sfp,
	movq	48(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	32(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
	jmp	.L479	#
.L482:
# inputs/bootstrap/source/falcon-keygen.c:5478: 				modp_iNTT2_ext(gs + u, slen, igm,
	movl	%ebp, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	44(%rsp), %ecx	# %sfp,
	movq	56(%rsp), %rdx	# %sfp,
	movq	8(%rsp), %rsi	# %sfp,
	movq	144(%rsp), %rdi	# %sfp,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5483: 		if (!out_ntt) {
	cmpl	$0, 168(%rsp)	#, %sfp
	jne	.L484	#,
.L485:
# inputs/bootstrap/source/falcon-keygen.c:5490: 				modp_iNTT2_ext(fd + u, tlen, igm,
	movl	%ebp, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	172(%rsp), %ecx	# %sfp,
	movq	56(%rsp), %rdx	# %sfp,
	movq	80(%rsp), %rsi	# %sfp,
	movq	96(%rsp), %rdi	# %sfp,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5492: 				modp_iNTT2_ext(gd + u, tlen, igm,
	movl	%ebp, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	172(%rsp), %ecx	# %sfp,
	movq	56(%rsp), %rdx	# %sfp,
	movq	80(%rsp), %rsi	# %sfp,
	movq	104(%rsp), %rdi	# %sfp,
	call	modp_iNTT2_ext	#
	jmp	.L484	#
.L481:
# inputs/bootstrap/source/falcon-keygen.c:5483: 		if (!out_ntt) {
	cmpl	$0, 168(%rsp)	#, %sfp
	jne	.L484	#,
# inputs/bootstrap/source/falcon-keygen.c:5484: 			if (ter) {
	cmpl	$0, 40(%rsp)	#, %sfp
	je	.L485	#,
.L483:
# inputs/bootstrap/source/falcon-keygen.c:5485: 				modp_iNTT3_ext(fd + u, tlen, igm,
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	pushq	%rbp	# p0i
	.cfi_def_cfa_offset 288
	movl	%ebx, %r9d	# p,
	movl	$0, %r8d	#,
	movl	188(%rsp), %ecx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	96(%rsp), %rsi	# %sfp,
	movq	112(%rsp), %rdi	# %sfp,
	call	modp_iNTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5487: 				modp_iNTT3_ext(gd + u, tlen, igm,
	movl	%ebp, (%rsp)	# p0i,
	movl	%ebx, %r9d	# p,
	movl	$0, %r8d	#,
	movl	188(%rsp), %ecx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	96(%rsp), %rsi	# %sfp,
	movq	120(%rsp), %rdi	# %sfp,
	call	modp_iNTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
.L484:
# inputs/bootstrap/source/falcon-keygen.c:5413: 	for (u = 0; u < slen; u ++) {
	addq	$1, 24(%rsp)	#, %sfp
	movq	24(%rsp), %rax	# %sfp, u
# inputs/bootstrap/source/falcon-keygen.c:5413: 	for (u = 0; u < slen; u ++) {
	addq	$4, 112(%rsp)	#, %sfp
	addq	$4, 120(%rsp)	#, %sfp
	addq	$4, 128(%rsp)	#, %sfp
	addq	$4, 136(%rsp)	#, %sfp
	addq	$12, 72(%rsp)	#, %sfp
	cmpq	%rax, 8(%rsp)	# u, %sfp
	je	.L522	#,
.L486:
# inputs/bootstrap/source/falcon-keygen.c:5418: 		p = primes[u].p;
	movq	72(%rsp), %rax	# %sfp, ivtmp.901
	movl	-4(%rax), %ebx	# MEM[(unsigned int *)_476 + -4B], p
# inputs/bootstrap/source/falcon-keygen.c:5419: 		p0i = modp_ninv31(p);
	movl	%ebx, %edi	# p,
	call	modp_ninv31	#
	movl	%eax, %ebp	# tmp514, p0i
# inputs/bootstrap/source/falcon-keygen.c:5420: 		R2 = modp_R2(p, p0i);
	movl	%eax, %esi	# p0i,
	movl	%ebx, %edi	# p,
	call	modp_R2	#
	movl	%eax, 88(%rsp)	# tmp515, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5421: 		if (ter) {
	cmpl	$0, 40(%rsp)	#, %sfp
	je	.L467	#,
# inputs/bootstrap/source/falcon-keygen.c:5422: 			modp_mkgm3(gm, igm, logn, 0, primes[u].g, p, p0i);
	movq	72(%rsp), %rax	# %sfp, ivtmp.901
	movl	(%rax), %r8d	# MEM[(unsigned int *)_476], MEM[(unsigned int *)_476]
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	pushq	%rbp	# p0i
	.cfi_def_cfa_offset 288
	movl	%ebx, %r9d	# p,
	movl	$0, %ecx	#,
	movl	60(%rsp), %edx	# %sfp,
	movq	72(%rsp), %rsi	# %sfp,
	movq	64(%rsp), %rdi	# %sfp,
	call	modp_mkgm3	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
.L468:
# inputs/bootstrap/source/falcon-keygen.c:5427: 		for (v = 0, x = fs + u; v < n; v ++, x += slen) {
	movq	136(%rsp), %rdx	# %sfp, ivtmp.900
	movq	%rdx, 104(%rsp)	# ivtmp.900, %sfp
	movq	32(%rsp), %rax	# %sfp, ivtmp.892
	.p2align 4
.L469:
# inputs/bootstrap/source/falcon-keygen.c:5428: 			t1[v] = *x;
	movl	(%rdx), %ecx	# MEM[(uint32_t *)x_404], _18
# inputs/bootstrap/source/falcon-keygen.c:5428: 			t1[v] = *x;
	movl	%ecx, (%rax)	# _18, MEM[(uint32_t *)_456]
# inputs/bootstrap/source/falcon-keygen.c:5427: 		for (v = 0, x = fs + u; v < n; v ++, x += slen) {
	addq	%r12, %rdx	# _19, x
# inputs/bootstrap/source/falcon-keygen.c:5427: 		for (v = 0, x = fs + u; v < n; v ++, x += slen) {
	addq	$4, %rax	#, ivtmp.892
	cmpq	%r14, %rax	# _459, ivtmp.892
	jne	.L469	#,
# inputs/bootstrap/source/falcon-keygen.c:5430: 		if (!in_ntt) {
	cmpl	$0, 16(%rsp)	#, %sfp
	jne	.L470	#,
# inputs/bootstrap/source/falcon-keygen.c:5431: 			if (ter) {
	cmpl	$0, 40(%rsp)	#, %sfp
	je	.L471	#,
# inputs/bootstrap/source/falcon-keygen.c:5432: 				modp_NTT3(t1, gm, logn, 0, p, p0i);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	pushq	%rbp	# p0i
	.cfi_def_cfa_offset 288
	movl	%ebx, %r9d	# p,
	movl	$0, %r8d	#,
	movl	60(%rsp), %ecx	# %sfp,
	movq	64(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_NTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
.L472:
# inputs/bootstrap/source/falcon-keygen.c:5437: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	movq	112(%rsp), %rax	# %sfp, ivtmp.897
	movq	%rax, 96(%rsp)	# ivtmp.897, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5437: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	cmpq	$0, 64(%rsp)	#, %sfp
	je	.L474	#,
.L508:
# inputs/bootstrap/source/falcon-keygen.c:5427: 		for (v = 0, x = fs + u; v < n; v ++, x += slen) {
	movq	32(%rsp), %rdx	# %sfp, ivtmp.883
# inputs/bootstrap/source/falcon-keygen.c:5437: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	movq	96(%rsp), %rcx	# %sfp, x
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebp, %edi	# p0i, _214
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebx, %esi	# p, _217
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	88(%rsp), %r8d	# %sfp, _145
.L473:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdx), %r9d	# MEM[(uint32_t *)_448], _211
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%rdx), %eax	# MEM[(uint32_t *)_448 + 4B], _212
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r9	# _212, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r9, %rax	# z, _215
	imulq	%rdi, %rax	# _214, _215
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _216
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _217, w_218
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _219
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _220
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _224
	sarl	$31, %r9d	#, _224
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r9d	# p, _226
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r9), %r9d	#, _146
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r8, %r9	# _145, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r9, %rax	# z, _156
	imulq	%rdi, %rax	# _214, _156
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _160
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _217, w_126
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _124
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _192
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _167
	sarl	$31, %r9d	#, _167
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r9d	# p, _209
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r9d, %eax	# _209, tmp415
	movl	%eax, (%rcx)	# tmp415, MEM[(uint32_t *)x_405]
# inputs/bootstrap/source/falcon-keygen.c:5437: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	addq	%r15, %rcx	# _24, x
# inputs/bootstrap/source/falcon-keygen.c:5437: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	addq	$8, %rdx	#, ivtmp.883
	cmpq	%r13, %rdx	# _451, ivtmp.883
	jne	.L473	#,
# inputs/bootstrap/source/falcon-keygen.c:5445: 		if (in_ntt) {
	cmpl	$0, 16(%rsp)	#, %sfp
	je	.L474	#,
.L509:
# inputs/bootstrap/source/falcon-keygen.c:5446: 			if (ter) {
	cmpl	$0, 40(%rsp)	#, %sfp
	je	.L475	#,
# inputs/bootstrap/source/falcon-keygen.c:5447: 				modp_iNTT3_ext(fs + u, slen, igm,
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	pushq	%rbp	# p0i
	.cfi_def_cfa_offset 288
	movl	%ebx, %r9d	# p,
	movl	$0, %r8d	#,
	movl	60(%rsp), %ecx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	24(%rsp), %rsi	# %sfp,
	movq	120(%rsp), %rdi	# %sfp,
	call	modp_iNTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
.L474:
# inputs/bootstrap/source/falcon-keygen.c:5455: 		for (v = 0, x = gs + u; v < n; v ++, x += slen) {
	movq	128(%rsp), %rdx	# %sfp, ivtmp.899
	movq	%rdx, 144(%rsp)	# ivtmp.899, %sfp
	movq	32(%rsp), %rax	# %sfp, ivtmp.876
	.p2align 4
.L476:
# inputs/bootstrap/source/falcon-keygen.c:5456: 			t1[v] = *x;
	movl	(%rdx), %ecx	# MEM[(uint32_t *)x_406], _27
# inputs/bootstrap/source/falcon-keygen.c:5456: 			t1[v] = *x;
	movl	%ecx, (%rax)	# _27, MEM[(uint32_t *)_441]
# inputs/bootstrap/source/falcon-keygen.c:5455: 		for (v = 0, x = gs + u; v < n; v ++, x += slen) {
	addq	%r12, %rdx	# _19, x
# inputs/bootstrap/source/falcon-keygen.c:5455: 		for (v = 0, x = gs + u; v < n; v ++, x += slen) {
	addq	$4, %rax	#, ivtmp.876
	cmpq	%r14, %rax	# _459, ivtmp.876
	jne	.L476	#,
# inputs/bootstrap/source/falcon-keygen.c:5458: 		if (!in_ntt) {
	cmpl	$0, 16(%rsp)	#, %sfp
	jne	.L477	#,
# inputs/bootstrap/source/falcon-keygen.c:5459: 			if (ter) {
	cmpl	$0, 40(%rsp)	#, %sfp
	je	.L478	#,
# inputs/bootstrap/source/falcon-keygen.c:5460: 				modp_NTT3(t1, gm, logn, 0, p, p0i);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	pushq	%rbp	# p0i
	.cfi_def_cfa_offset 288
	movl	%ebx, %r9d	# p,
	movl	$0, %r8d	#,
	movl	60(%rsp), %ecx	# %sfp,
	movq	64(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_NTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
.L479:
# inputs/bootstrap/source/falcon-keygen.c:5465: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	movq	120(%rsp), %rax	# %sfp, ivtmp.898
	movq	%rax, 104(%rsp)	# ivtmp.898, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5465: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	cmpq	$0, 64(%rsp)	#, %sfp
	je	.L481	#,
.L506:
# inputs/bootstrap/source/falcon-keygen.c:5455: 		for (v = 0, x = gs + u; v < n; v ++, x += slen) {
	movq	32(%rsp), %rdx	# %sfp, ivtmp.867
# inputs/bootstrap/source/falcon-keygen.c:5465: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	movq	104(%rsp), %rcx	# %sfp, x
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebp, %edi	# p0i, _246
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebx, %esi	# p, _249
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	88(%rsp), %r8d	# %sfp, _229
.L480:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdx), %r9d	# MEM[(uint32_t *)_374], _243
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%rdx), %eax	# MEM[(uint32_t *)_374 + 4B], _244
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r9	# _244, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r9, %rax	# z, _247
	imulq	%rdi, %rax	# _246, _247
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _248
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _249, w_250
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _251
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _252
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _256
	sarl	$31, %r9d	#, _256
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r9d	# p, _258
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r9), %r9d	#, _228
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r8, %r9	# _229, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r9, %rax	# z, _231
	imulq	%rdi, %rax	# _246, _231
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _232
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _249, w_233
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _234
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _235
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _239
	sarl	$31, %r9d	#, _239
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r9d	# p, _241
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r9d, %eax	# _241, tmp433
	movl	%eax, (%rcx)	# tmp433, MEM[(uint32_t *)x_407]
# inputs/bootstrap/source/falcon-keygen.c:5465: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	addq	%r15, %rcx	# _24, x
# inputs/bootstrap/source/falcon-keygen.c:5465: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	addq	$8, %rdx	#, ivtmp.867
	cmpq	%r13, %rdx	# _451, ivtmp.867
	jne	.L480	#,
# inputs/bootstrap/source/falcon-keygen.c:5473: 		if (in_ntt) {
	cmpl	$0, 16(%rsp)	#, %sfp
	je	.L481	#,
.L507:
# inputs/bootstrap/source/falcon-keygen.c:5474: 			if (ter) {
	cmpl	$0, 40(%rsp)	#, %sfp
	je	.L482	#,
# inputs/bootstrap/source/falcon-keygen.c:5475: 				modp_iNTT3_ext(gs + u, slen, igm,
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	pushq	%rbp	# p0i
	.cfi_def_cfa_offset 288
	movl	%ebx, %r9d	# p,
	movl	$0, %r8d	#,
	movl	60(%rsp), %ecx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movq	24(%rsp), %rsi	# %sfp,
	movq	160(%rsp), %rdi	# %sfp,
	call	modp_iNTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5483: 		if (!out_ntt) {
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
	cmpl	$0, 168(%rsp)	#, %sfp
	je	.L483	#,
	jmp	.L484	#
.L522:
	movq	192(%rsp), %rbx	# %sfp, primes
	movq	200(%rsp), %rbp	# %sfp, n
.L466:
# inputs/bootstrap/source/falcon-keygen.c:5502: 	zint_rebuild_CRT(fs, slen, slen, n, primes, 1, gm);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	movq	56(%rsp), %r14	# %sfp, gm
	pushq	%r14	# gm
	.cfi_def_cfa_offset 288
	movl	$1, %r9d	#,
	movq	%rbx, %r8	# primes,
	movq	%rbp, %rcx	# n,
	movq	24(%rsp), %r15	# %sfp, slen
	movq	%r15, %rdx	# slen,
	movq	%r15, %rsi	# slen,
	movq	176(%rsp), %rdi	# %sfp,
	call	zint_rebuild_CRT	#
# inputs/bootstrap/source/falcon-keygen.c:5503: 	zint_rebuild_CRT(gs, slen, slen, n, primes, 1, gm);
	movq	%r14, (%rsp)	# gm,
	movl	$1, %r9d	#,
	movq	%rbx, %r8	# primes,
	movq	%rbp, %rcx	# n,
	movq	%r15, %rdx	# slen,
	movq	%r15, %rsi	# slen,
	movq	168(%rsp), %rdi	# %sfp,
	call	zint_rebuild_CRT	#
# inputs/bootstrap/source/falcon-keygen.c:5508: 	for (u = slen; u < tlen; u ++) {
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
	movq	80(%rsp), %rdi	# %sfp, tlen
	cmpq	%rdi, %r15	# tlen, slen
	jnb	.L463	#,
# inputs/bootstrap/source/falcon-keygen.c:5522: 		for (v = 0, x = fs; v < n; v ++, x += slen) {
	leaq	0(,%r15,4), %rsi	#, _44
	movq	%rsi, 16(%rsp)	# _44, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5530: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	salq	$2, %rdi	#, _50
	movq	%rdi, 112(%rsp)	# _50, %sfp
	movq	176(%rsp), %rdi	# %sfp, data
	addq	%rsi, %rdi	# _44, data
	movq	%rdi, 88(%rsp)	# data, %sfp
	movq	184(%rsp), %rdi	# %sfp, gd
	addq	%rsi, %rdi	# _44, gd
	movq	%rdi, 96(%rsp)	# gd, %sfp
	leaq	(%r15,%r15,2), %rax	#, _386
	leaq	4(%rbx,%rax,4), %rax	#, ivtmp.855
	movq	%rax, 104(%rsp)	# ivtmp.855, %sfp
	movl	$4, %eax	#, tmp440
	movzbl	44(%rsp), %ecx	# %sfp, tmp697
	salq	%cl, %rax	# tmp697, _391
	movq	32(%rsp), %rdi	# %sfp, t1
	addq	%rdi, %rax	# t1, _72
	movq	%rax, 24(%rsp)	# _72, %sfp
	movq	64(%rsp), %rax	# %sfp, hn
	leaq	(%rdi,%rax,8), %rax	#, _74
	movq	%rax, 120(%rsp)	# _74, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5508: 	for (u = slen; u < tlen; u ++) {
	movq	%r15, 72(%rsp)	# slen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2617: 	x --;
	movl	%r15d, %eax	# slen, tmp705
	subl	$1, %eax	#, x
	movl	%eax, 136(%rsp)	# x, %sfp
	jmp	.L505	#
.L489:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %r9d	# r, _348
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r9, %r9	# _348, powmult_367
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rsi, %rax	# _334, _351
	imulq	%r9, %rax	# powmult_367, _351
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _352
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rdx, %rax	# _337, w_354
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# powmult_367, _355
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _356
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _360
	sarl	$31, %r9d	#, _360
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r9d	# p, _362
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r9d, %eax	# _362, r
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	addl	$1, %ecx	#, i
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	%edi, %r9d	# tmp464, _365
	sall	%cl, %r9d	# i, _365
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	cmpl	%r9d, %r8d	# _365, x
	jb	.L488	#,
.L490:
# inputs/bootstrap/source/falcon-keygen.c:2621: 		if ((x & (1U << i)) != 0) {
	btl	%ecx, %r8d	# i, x
	jnc	.L489	#,
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebp, %ebp	# z, _330
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %r9d	# r, _332
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r9, %rbp	# _332, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rsi, %r9	# _334, _335
	imulq	%rbp, %r9	# z, _335
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %r9d	#, _336
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rdx, %r9	# _337, w_338
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rbp, %r9	# z, _339
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %r9	#, _340
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %r9d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r9d, %ebp	# d, _344
	sarl	$31, %ebp	#, _344
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %ebp	# p, _346
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r9d, %ebp	# d, z
	jmp	.L489	#
.L488:
# inputs/bootstrap/source/falcon-keygen.c:5517: 		if (ter) {
	cmpl	$0, 40(%rsp)	#, %sfp
	je	.L491	#,
# inputs/bootstrap/source/falcon-keygen.c:5518: 			modp_mkgm3(gm, igm, logn, 0, primes[u].g, p, p0i);
	movl	(%r12), %r8d	# MEM[(unsigned int *)_380], MEM[(unsigned int *)_380]
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	pushq	%r14	# p0i
	.cfi_def_cfa_offset 288
	movl	%ebx, %r9d	# p,
	movl	$0, %ecx	#,
	movl	60(%rsp), %edx	# %sfp,
	movq	72(%rsp), %rsi	# %sfp,
	movq	64(%rsp), %rdi	# %sfp,
	call	modp_mkgm3	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
.L493:
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movq	32(%rsp), %r12	# %sfp, ivtmp.844
	movq	160(%rsp), %r15	# %sfp, x
.L492:
# inputs/bootstrap/source/falcon-keygen.c:5523: 			t1[v] = zint_mod_small_signed(x, slen, p, p0i, R2, Rx);
	movl	%ebp, %r9d	# z,
	movl	%r13d, %r8d	# R2,
	movl	%r14d, %ecx	# p0i,
	movl	%ebx, %edx	# p,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# x,
	call	zint_mod_small_signed	#
# inputs/bootstrap/source/falcon-keygen.c:5523: 			t1[v] = zint_mod_small_signed(x, slen, p, p0i, R2, Rx);
	movl	%eax, (%r12)	# tmp518, MEM[(uint32_t *)_69]
# inputs/bootstrap/source/falcon-keygen.c:5522: 		for (v = 0, x = fs; v < n; v ++, x += slen) {
	movq	16(%rsp), %rax	# %sfp, _44
	addq	%rax, %r15	# _44, x
# inputs/bootstrap/source/falcon-keygen.c:5522: 		for (v = 0, x = fs; v < n; v ++, x += slen) {
	addq	$4, %r12	#, ivtmp.844
	cmpq	%r12, 24(%rsp)	# ivtmp.844, %sfp
	jne	.L492	#,
# inputs/bootstrap/source/falcon-keygen.c:5525: 		if (ter) {
	cmpl	$0, 40(%rsp)	#, %sfp
	je	.L494	#,
# inputs/bootstrap/source/falcon-keygen.c:5526: 			modp_NTT3(t1, gm, logn, 0, p, p0i);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	pushq	%r14	# p0i
	.cfi_def_cfa_offset 288
	movl	%ebx, %r9d	# p,
	movl	$0, %r8d	#,
	movl	60(%rsp), %ecx	# %sfp,
	movq	64(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_NTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
.L495:
# inputs/bootstrap/source/falcon-keygen.c:5530: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	movq	88(%rsp), %rcx	# %sfp, ivtmp.853
	movq	%rcx, 128(%rsp)	# ivtmp.853, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5530: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	cmpq	$0, 64(%rsp)	#, %sfp
	je	.L496	#,
	movq	32(%rsp), %rdx	# %sfp, ivtmp.835
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %edi	# p0i, _278
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebx, %esi	# p, _281
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r13d, %r8d	# R2, _261
	movq	112(%rsp), %r9	# %sfp, _50
	movq	120(%rsp), %r10	# %sfp, _74
.L497:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdx), %r11d	# MEM[(uint32_t *)_93], _275
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%rdx), %eax	# MEM[(uint32_t *)_93 + 4B], _276
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r11	# _276, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# z, _279
	imulq	%rdi, %rax	# _278, _279
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _280
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _281, w_282
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r11, %rax	# z, _283
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _284
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r11d	# d, _288
	sarl	$31, %r11d	#, _288
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r11d	# p, _290
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r11), %r11d	#, _260
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r8, %r11	# _261, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r11, %rax	# z, _263
	imulq	%rdi, %rax	# _278, _263
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _264
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _281, w_265
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r11, %rax	# z, _266
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _267
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r11d	# d, _271
	sarl	$31, %r11d	#, _271
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r11d	# p, _273
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r11d, %eax	# _273, tmp484
	movl	%eax, (%rcx)	# tmp484, MEM[(uint32_t *)x_413]
# inputs/bootstrap/source/falcon-keygen.c:5530: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	addq	%r9, %rcx	# _50, x
# inputs/bootstrap/source/falcon-keygen.c:5530: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	addq	$8, %rdx	#, ivtmp.835
	cmpq	%rdx, %r10	# ivtmp.835, _74
	jne	.L497	#,
.L496:
# inputs/bootstrap/source/falcon-keygen.c:5530: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	movq	32(%rsp), %r12	# %sfp, ivtmp.828
# inputs/bootstrap/source/falcon-keygen.c:5538: 		for (v = 0, x = gs; v < n; v ++, x += slen) {
	movq	152(%rsp), %r15	# %sfp, x
.L498:
# inputs/bootstrap/source/falcon-keygen.c:5539: 			t1[v] = zint_mod_small_signed(x, slen, p, p0i, R2, Rx);
	movl	%ebp, %r9d	# z,
	movl	%r13d, %r8d	# R2,
	movl	%r14d, %ecx	# p0i,
	movl	%ebx, %edx	# p,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# x,
	call	zint_mod_small_signed	#
# inputs/bootstrap/source/falcon-keygen.c:5539: 			t1[v] = zint_mod_small_signed(x, slen, p, p0i, R2, Rx);
	movl	%eax, (%r12)	# tmp519, MEM[(uint32_t *)_95]
# inputs/bootstrap/source/falcon-keygen.c:5538: 		for (v = 0, x = gs; v < n; v ++, x += slen) {
	movq	16(%rsp), %rax	# %sfp, _44
	addq	%rax, %r15	# _44, x
# inputs/bootstrap/source/falcon-keygen.c:5538: 		for (v = 0, x = gs; v < n; v ++, x += slen) {
	addq	$4, %r12	#, ivtmp.828
	cmpq	%r12, 24(%rsp)	# ivtmp.828, %sfp
	jne	.L498	#,
# inputs/bootstrap/source/falcon-keygen.c:5541: 		if (ter) {
	cmpl	$0, 40(%rsp)	#, %sfp
	je	.L499	#,
# inputs/bootstrap/source/falcon-keygen.c:5542: 			modp_NTT3(t1, gm, logn, 0, p, p0i);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	pushq	%r14	# p0i
	.cfi_def_cfa_offset 288
	movl	%ebx, %r9d	# p,
	movl	$0, %r8d	#,
	movl	60(%rsp), %ecx	# %sfp,
	movq	64(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_NTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
.L500:
# inputs/bootstrap/source/falcon-keygen.c:5546: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	movq	96(%rsp), %rcx	# %sfp, ivtmp.854
	movq	%rcx, %r12	# ivtmp.854, x
# inputs/bootstrap/source/falcon-keygen.c:5546: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	cmpq	$0, 64(%rsp)	#, %sfp
	je	.L501	#,
	movq	32(%rsp), %rdx	# %sfp, ivtmp.819
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %edi	# p0i, _310
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebx, %esi	# p, _313
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r13d, %r13d	# R2, _293
	movq	112(%rsp), %r8	# %sfp, _50
	movq	120(%rsp), %r9	# %sfp, _74
.L502:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rdx), %r10d	# MEM[(uint32_t *)_98], _307
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%rdx), %eax	# MEM[(uint32_t *)_98 + 4B], _308
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r10	# _308, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r10, %rax	# z, _311
	imulq	%rdi, %rax	# _310, _311
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _312
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _313, w_314
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rax	# z, _315
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _316
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _320
	sarl	$31, %r10d	#, _320
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r10d	# p, _322
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r10), %r10d	#, _292
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r13, %r10	# _293, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r10, %rax	# z, _295
	imulq	%rdi, %rax	# _310, _295
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _296
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _313, w_297
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rax	# z, _298
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _299
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _303
	sarl	$31, %r10d	#, _303
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r10d	# p, _305
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r10d, %eax	# _305, tmp502
	movl	%eax, (%rcx)	# tmp502, MEM[(uint32_t *)x_415]
# inputs/bootstrap/source/falcon-keygen.c:5546: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	addq	%r8, %rcx	# _50, x
# inputs/bootstrap/source/falcon-keygen.c:5546: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	addq	$8, %rdx	#, ivtmp.819
	cmpq	%rdx, %r9	# ivtmp.819, _74
	jne	.L502	#,
.L501:
# inputs/bootstrap/source/falcon-keygen.c:5555: 		if (!out_ntt) {
	cmpl	$0, 168(%rsp)	#, %sfp
	jne	.L503	#,
# inputs/bootstrap/source/falcon-keygen.c:5556: 			if (ter) {
	cmpl	$0, 40(%rsp)	#, %sfp
	je	.L504	#,
# inputs/bootstrap/source/falcon-keygen.c:5557: 				modp_iNTT3_ext(fd + u, tlen, igm,
	movl	44(%rsp), %eax	# %sfp, logn
	leal	-1(%rax), %ebp	#, _60
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 280
	pushq	%r14	# p0i
	.cfi_def_cfa_offset 288
	movl	%ebx, %r9d	# p,
	movl	$0, %r8d	#,
	movl	%ebp, %ecx	# _60,
	movq	72(%rsp), %r13	# %sfp, igm
	movq	%r13, %rdx	# igm,
	movq	96(%rsp), %r15	# %sfp, tlen
	movq	%r15, %rsi	# tlen,
	movq	144(%rsp), %rdi	# %sfp,
	call	modp_iNTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5559: 				modp_iNTT3_ext(gd + u, tlen, igm,
	movl	%r14d, (%rsp)	# p0i,
	movl	%ebx, %r9d	# p,
	movl	$0, %r8d	#,
	movl	%ebp, %ecx	# _60,
	movq	%r13, %rdx	# igm,
	movq	%r15, %rsi	# tlen,
	movq	%r12, %rdi	# x,
	call	modp_iNTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 272
.L503:
# inputs/bootstrap/source/falcon-keygen.c:5508: 	for (u = slen; u < tlen; u ++) {
	addq	$1, 72(%rsp)	#, %sfp
	movq	72(%rsp), %rax	# %sfp, u
# inputs/bootstrap/source/falcon-keygen.c:5508: 	for (u = slen; u < tlen; u ++) {
	addq	$4, 88(%rsp)	#, %sfp
	addq	$4, 96(%rsp)	#, %sfp
	addq	$12, 104(%rsp)	#, %sfp
	cmpq	%rax, 80(%rsp)	# u, %sfp
	je	.L463	#,
.L505:
	movq	104(%rsp), %rax	# %sfp, ivtmp.855
	movq	%rax, %r12	# ivtmp.855, _380
# inputs/bootstrap/source/falcon-keygen.c:5513: 		p = primes[u].p;
	movl	-4(%rax), %ebx	# MEM[(unsigned int *)_380 + -4B], p
# inputs/bootstrap/source/falcon-keygen.c:5514: 		p0i = modp_ninv31(p);
	movl	%ebx, %edi	# p,
	call	modp_ninv31	#
	movl	%eax, %r14d	# tmp516, p0i
# inputs/bootstrap/source/falcon-keygen.c:5515: 		R2 = modp_R2(p, p0i);
	movl	%eax, %esi	# p0i,
	movl	%ebx, %edi	# p,
	call	modp_R2	#
	movl	%eax, %r13d	# tmp517, R2
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	movl	$-2147483648, %ebp	#, tmp442
	subl	%ebx, %ebp	# p, z
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	136(%rsp), %r8d	# %sfp, x
	testl	%r8d, %r8d	# x
	je	.L488	#,
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	$0, %ecx	#, i
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %esi	# p0i, _334
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebx, %edx	# p, _337
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	$1, %edi	#, tmp464
	jmp	.L490	#
.L491:
# inputs/bootstrap/source/falcon-keygen.c:5520: 			modp_mkgm2(gm, igm, logn, primes[u].g, p, p0i);
	movl	(%r12), %ecx	# MEM[(unsigned int *)_380], MEM[(unsigned int *)_380]
	movl	%r14d, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	44(%rsp), %edx	# %sfp,
	movq	56(%rsp), %rsi	# %sfp,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_mkgm2	#
	jmp	.L493	#
.L494:
# inputs/bootstrap/source/falcon-keygen.c:5528: 			modp_NTT2(t1, gm, logn, p, p0i);
	movl	%r14d, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	44(%rsp), %ecx	# %sfp,
	movq	48(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	32(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
	jmp	.L495	#
.L499:
# inputs/bootstrap/source/falcon-keygen.c:5544: 			modp_NTT2(t1, gm, logn, p, p0i);
	movl	%r14d, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	44(%rsp), %ecx	# %sfp,
	movq	48(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	32(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
	jmp	.L500	#
.L504:
# inputs/bootstrap/source/falcon-keygen.c:5562: 				modp_iNTT2_ext(fd + u, tlen, igm,
	movl	44(%rsp), %eax	# %sfp, logn
	leal	-1(%rax), %ebp	#, _61
	movl	%r14d, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	%ebp, %ecx	# _61,
	movq	56(%rsp), %r13	# %sfp, igm
	movq	%r13, %rdx	# igm,
	movq	80(%rsp), %r15	# %sfp, tlen
	movq	%r15, %rsi	# tlen,
	movq	128(%rsp), %rdi	# %sfp,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5564: 				modp_iNTT2_ext(gd + u, tlen, igm,
	movl	%r14d, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	%ebp, %ecx	# _61,
	movq	%r13, %rdx	# igm,
	movq	%r15, %rsi	# tlen,
	movq	%r12, %rdi	# x,
	call	modp_iNTT2_ext	#
	jmp	.L503	#
.L477:
# inputs/bootstrap/source/falcon-keygen.c:5465: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	movq	120(%rsp), %rax	# %sfp, ivtmp.898
	movq	%rax, 104(%rsp)	# ivtmp.898, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5465: 		for (v = 0, x = gd + u; v < hn; v ++, x += tlen) {
	cmpq	$0, 64(%rsp)	#, %sfp
	jne	.L506	#,
	jmp	.L507	#
.L470:
# inputs/bootstrap/source/falcon-keygen.c:5437: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	movq	112(%rsp), %rax	# %sfp, ivtmp.897
	movq	%rax, 96(%rsp)	# ivtmp.897, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5437: 		for (v = 0, x = fd + u; v < hn; v ++, x += tlen) {
	cmpq	$0, 64(%rsp)	#, %sfp
	jne	.L508	#,
	jmp	.L509	#
.L463:
# inputs/bootstrap/source/falcon-keygen.c:5569: }
	addq	$216, %rsp	#,
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
.LFE97:
	.size	make_fg_step, .-make_fg_step
	.type	make_fg, @function
make_fg:
.LFB99:
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
	movq	%rdi, %r15	# tmp378, data
	movq	%rdx, %rdi	# tmp380, g
	movl	%ecx, %r12d	# tmp381, logn
	movl	%r8d, %ebx	# tmp382, ter
	movl	%r9d, %r14d	# tmp383, depth
# inputs/bootstrap/source/falcon-keygen.c:5690: 	n = MKN(logn, ter);
	leal	1(%r8,%r8), %r8d	#, _3
	subl	%ebx, %ecx	# ter, _4
# inputs/bootstrap/source/falcon-keygen.c:5690: 	n = MKN(logn, ter);
	salq	%cl, %r8	# _4, n
# inputs/bootstrap/source/falcon-keygen.c:5692: 	gt = ft + n;
	leaq	0(,%r8,4), %r13	#, _5
# inputs/bootstrap/source/falcon-keygen.c:5692: 	gt = ft + n;
	leaq	(%r15,%r13), %rbp	#, gt
# inputs/bootstrap/source/falcon-keygen.c:5693: 	primes = ter ? PRIMES3 : PRIMES2;
	testl	%ebx, %ebx	# ter
	leaq	PRIMES2(%rip), %rdx	#, tmp376
	leaq	PRIMES3(%rip), %rax	#, tmp377
	cmove	%rdx, %rax	# tmp376,, tmp377
	movq	%rax, (%rsp)	# iftmp.27_34, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5694: 	p0 = primes[0].p;
	movl	(%rax), %ecx	# iftmp.27_34->p, p0
# inputs/bootstrap/source/falcon-keygen.c:5695: 	for (u = 0; u < n; u ++) {
	testq	%r8, %r8	# n
	je	.L525	#,
# inputs/bootstrap/source/falcon-keygen.c:5695: 	for (u = 0; u < n; u ++) {
	movl	$0, %eax	#, u
	.p2align 6
.L526:
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	(%rsi,%rax,2), %r9d	# MEM[(const int16_t *)f_65(D) + u_243 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%r9d, %edx	# w, _75
	sarl	$31, %edx	#, _75
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	%ecx, %edx	# p0, _77
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%r9d, %edx	# w, tmp286
	movl	%edx, (%r15,%rax,4)	# tmp286, MEM[(uint32_t *)data_45(D) + u_243 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	(%rdi,%rax,2), %r9d	# MEM[(const int16_t *)g_68(D) + u_243 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%r9d, %edx	# w, _69
	sarl	$31, %edx	#, _69
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	%ecx, %edx	# p0, _72
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%r9d, %edx	# w, tmp290
	movl	%edx, 0(%rbp,%rax,4)	# tmp290, MEM[(uint32_t *)gt_46 + u_243 * 4]
# inputs/bootstrap/source/falcon-keygen.c:5695: 	for (u = 0; u < n; u ++) {
	addq	$1, %rax	#, u
# inputs/bootstrap/source/falcon-keygen.c:5695: 	for (u = 0; u < n; u ++) {
	cmpq	%rax, %r8	# u, n
	jne	.L526	#,
.L525:
# inputs/bootstrap/source/falcon-keygen.c:5700: 	if (depth == 0 && out_ntt) {
	cmpl	$0, 112(%rsp)	#, out_ntt
	setne	38(%rsp)	#, %sfp
	movzbl	38(%rsp), %eax	# %sfp, _17
# inputs/bootstrap/source/falcon-keygen.c:5700: 	if (depth == 0 && out_ntt) {
	testl	%r14d, %r14d	# depth
	jne	.L527	#,
	testb	%al, %al	# _17
	je	.L527	#,
# inputs/bootstrap/source/falcon-keygen.c:5704: 		p = primes[0].p;
	movq	(%rsp), %rax	# %sfp, iftmp.27_34
	movl	(%rax), %r14d	# iftmp.27_34->p, p
# inputs/bootstrap/source/falcon-keygen.c:5705: 		p0i = modp_ninv31(p);
	movl	%r14d, %edi	# p,
	call	modp_ninv31	#
	movl	%eax, %edx	# p0i, p0i
# inputs/bootstrap/source/falcon-keygen.c:5706: 		gm = gt + n;
	addq	%rbp, %r13	# gt, gm
# inputs/bootstrap/source/falcon-keygen.c:5707: 		igm = gm + MKN(logn, 0);
	movl	$4, %esi	#, tmp295
	movl	%r12d, %ecx	# logn, tmp428
	salq	%cl, %rsi	# tmp428, _19
# inputs/bootstrap/source/falcon-keygen.c:5707: 		igm = gm + MKN(logn, 0);
	addq	%r13, %rsi	# gm, igm
# inputs/bootstrap/source/falcon-keygen.c:5708: 		if (ter) {
	testl	%ebx, %ebx	# ter
	je	.L528	#,
# inputs/bootstrap/source/falcon-keygen.c:5709: 			modp_mkgm3(gm, igm, logn, 1, primes[0].g, p, p0i);
	movq	(%rsp), %rdi	# %sfp, iftmp.27_34
	movl	4(%rdi), %r8d	# iftmp.27_34->g, iftmp.27_34->g
	movl	%eax, %ebx	# p0i, p0i
	pushq	%rax	# p0i
	.cfi_def_cfa_offset 120
	movl	%r14d, %r9d	# p,
	movl	$1, %ecx	#,
	movl	%r12d, %edx	# logn,
	movq	%r13, %rdi	# gm,
	call	modp_mkgm3	#
# inputs/bootstrap/source/falcon-keygen.c:5710: 			modp_NTT3(ft, gm, logn, 1, p, p0i);
	pushq	%rbx	# p0i
	.cfi_def_cfa_offset 128
	movl	%r14d, %r9d	# p,
	movl	$1, %r8d	#,
	movl	%r12d, %ecx	# logn,
	movq	%r13, %rdx	# gm,
	movl	$1, %esi	#,
	movq	%r15, %rdi	# data,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5711: 			modp_NTT3(gt, gm, logn, 1, p, p0i);
	pushq	%rbx	# p0i
	.cfi_def_cfa_offset 136
	movl	%r14d, %r9d	# p,
	movl	$1, %r8d	#,
	movl	%r12d, %ecx	# logn,
	movq	%r13, %rdx	# gm,
	movl	$1, %esi	#,
	movq	%rbp, %rdi	# gt,
	call	modp_NTT3_ext	#
	addq	$24, %rsp	#,
	.cfi_def_cfa_offset 112
	jmp	.L523	#
.L528:
# inputs/bootstrap/source/falcon-keygen.c:5713: 			modp_mkgm2(gm, igm, logn, primes[0].g, p, p0i);
	movq	(%rsp), %rax	# %sfp, iftmp.27_34
	movl	4(%rax), %ecx	# iftmp.27_34->g, iftmp.27_34->g
	movl	%edx, %ebx	# p0i, p0i
	movl	%edx, %r9d	# p0i,
	movl	%r14d, %r8d	# p,
	movl	%r12d, %edx	# logn,
	movq	%r13, %rdi	# gm,
	call	modp_mkgm2	#
# inputs/bootstrap/source/falcon-keygen.c:5714: 			modp_NTT2(ft, gm, logn, p, p0i);
	movl	%ebx, %r9d	# p0i,
	movl	%r14d, %r8d	# p,
	movl	%r12d, %ecx	# logn,
	movq	%r13, %rdx	# gm,
	movl	$1, %esi	#,
	movq	%r15, %rdi	# data,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5715: 			modp_NTT2(gt, gm, logn, p, p0i);
	movl	%ebx, %r9d	# p0i,
	movl	%r14d, %r8d	# p,
	movl	%r12d, %ecx	# logn,
	movq	%r13, %rdx	# gm,
	movl	$1, %esi	#,
	movq	%rbp, %rdi	# gt,
	call	modp_NTT2_ext	#
	jmp	.L523	#
.L527:
# inputs/bootstrap/source/falcon-keygen.c:5720: 	if (ter) {
	testl	%ebx, %ebx	# ter
	jne	.L530	#,
	movzbl	38(%rsp), %ebp	# %sfp, _17
# inputs/bootstrap/source/falcon-keygen.c:5727: 		for (d = 0; d < depth; d ++) {
	testl	%r14d, %r14d	# depth
	je	.L523	#,
.L531:
	movl	%ebx, %edx	# ter, d
# inputs/bootstrap/source/falcon-keygen.c:5729: 				d != 0, (d + 1) < depth || out_ntt);
	addl	$1, %ebx	#, ter
# inputs/bootstrap/source/falcon-keygen.c:5728: 			make_fg_step(data, logn - d, d, 0,
	cmpl	%r14d, %ebx	# depth, ter
	setb	%r9b	#, _231
# inputs/bootstrap/source/falcon-keygen.c:5728: 			make_fg_step(data, logn - d, d, 0,
	orl	%ebp, %r9d	# _17, _232
# inputs/bootstrap/source/falcon-keygen.c:5728: 			make_fg_step(data, logn - d, d, 0,
	testl	%edx, %edx	# d
	setne	%r8b	#, _28
	movzbl	%r8b, %r8d	# _28, _28
	movl	%r12d, %esi	# logn, _30
	subl	%edx, %esi	# d, _30
	andl	$1, %r9d	#,
	movl	$0, %ecx	#,
	movq	%r15, %rdi	# data,
	call	make_fg_step	#
# inputs/bootstrap/source/falcon-keygen.c:5727: 		for (d = 0; d < depth; d ++) {
	cmpl	%r14d, %ebx	# depth, ter
	jne	.L531	#,
.L523:
# inputs/bootstrap/source/falcon-keygen.c:5732: }
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
.L530:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:5721: 		make_fg_ternary_top(data, logn, depth > 1 || out_ntt);
	cmpl	$1, %r14d	#, depth
	seta	%al	#, _22
# inputs/bootstrap/source/falcon-keygen.c:5721: 		make_fg_ternary_top(data, logn, depth > 1 || out_ntt);
	orb	38(%rsp), %al	# %sfp, _22
	movb	%al, 39(%rsp)	# _22, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5635: 	n = MKN(logn, 1);
	leal	-1(%r12), %edi	#, _79
	movl	%edi, 44(%rsp)	# _79, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5635: 	n = MKN(logn, 1);
	movl	$3, %eax	#, tmp300
	movl	%edi, %ecx	# _79, tmp437
	salq	%cl, %rax	# tmp437, tmp300
	movq	%rax, %r13	# tmp300, n
# inputs/bootstrap/source/falcon-keygen.c:5639: 	gd = fd + tn;
	movl	$4, %eax	#, tmp301
	movq	%rax, %rbx	# tmp301, _81
	salq	%cl, %rbx	# tmp439, _81
# inputs/bootstrap/source/falcon-keygen.c:5639: 	gd = fd + tn;
	leaq	(%r15,%rbx), %rdi	#, gd
# inputs/bootstrap/source/falcon-keygen.c:5640: 	fs = gd + tn;
	movq	%rdi, 16(%rsp)	# gd, %sfp
	addq	%rdi, %rbx	# gd, fs
# inputs/bootstrap/source/falcon-keygen.c:5641: 	gs = fs + n;
	leaq	0(,%r13,4), %rdx	#, _84
# inputs/bootstrap/source/falcon-keygen.c:5641: 	gs = fs + n;
	leaq	(%rbx,%rdx), %rbp	#, gs
# inputs/bootstrap/source/falcon-keygen.c:5642: 	gm = gs + n;
	leaq	0(%rbp,%rdx), %rdi	#, gm
# inputs/bootstrap/source/falcon-keygen.c:5643: 	igm = gm + dn;
	movl	%r12d, %ecx	# logn, tmp443
	salq	%cl, %rax	# tmp443, _87
# inputs/bootstrap/source/falcon-keygen.c:5643: 	igm = gm + dn;
	movq	%rdi, 8(%rsp)	# gm, %sfp
	addq	%rdi, %rax	# gm, igm
	movq	%rax, 24(%rsp)	# igm, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5644: 	memmove(fs, data, n * 2 * sizeof *data);
	leaq	0(,%r13,8), %rdx	#, _89
	movq	%r15, %rsi	# data,
	movq	%rbx, %rdi	# fs,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5647: 	p0i = modp_ninv31(p);
	movl	$2147355649, %edi	#,
	call	modp_ninv31	#
# inputs/bootstrap/source/falcon-keygen.c:5648: 	R2 = modp_R2(p, p0i);
	movl	%eax, (%rsp)	# p0i, %sfp
	movl	%eax, %esi	# p0i,
	movl	$2147355649, %edi	#,
	call	modp_R2	#
	movl	%eax, 40(%rsp)	# tmp386, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5650: 	modp_mkgm3(gm, igm, logn, 1, PRIMES3[0].g, p, p0i);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 120
	movl	8(%rsp), %edi	# %sfp, p0i
	pushq	%rdi	# p0i
	.cfi_def_cfa_offset 128
	movl	$2147355649, %r9d	#,
	movl	$1907584673, %r8d	#,
	movl	$1, %ecx	#,
	movl	%r12d, %edx	# logn,
	movq	40(%rsp), %rsi	# %sfp,
	movq	24(%rsp), %rdi	# %sfp,
	call	modp_mkgm3	#
# inputs/bootstrap/source/falcon-keygen.c:5651: 	modp_NTT3(fs, gm, logn, 1, p, p0i);
	movl	16(%rsp), %ecx	# %sfp, p0i
	movl	%ecx, (%rsp)	# p0i,
	movl	$2147355649, %r9d	#,
	movl	$1, %r8d	#,
	movl	%r12d, %ecx	# logn,
	movq	24(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%rbx, %rdi	# fs,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5652: 	modp_NTT3(gs, gm, logn, 1, p, p0i);
	movl	16(%rsp), %ecx	# %sfp, p0i
	movl	%ecx, (%rsp)	# p0i,
	movl	$2147355649, %r9d	#,
	movl	$1, %r8d	#,
	movl	%r12d, %ecx	# logn,
	movq	24(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%rbp, %rdi	# gs,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	56(%rsp), %eax	# %sfp, _92
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %rax	# _92, powmult_234
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	16(%rsp), %ecx	# %sfp, _94
	movq	%rcx, %rsi	# _94, _95
	imulq	%rax, %rsi	# powmult_234, _95
	movq	%rsi, %rdi	# _95, _95
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edi	#, _96
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147355649, %rdi, %rdi	#, _96, w_97
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rax, %rdi	# powmult_234, _98
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdi	#, _99
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147355649, %edi	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edi, %eax	# d, _103
	sarl	$31, %eax	#, _103
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147355649, %eax	#, _105
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %edi	# _105, d
# inputs/bootstrap/source/falcon-keygen.c:5656: 	for (u = 0, v = 0; u < n; u += 3, v ++) {
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 112
	testq	%r13, %r13	# n
	je	.L532	#,
# inputs/bootstrap/source/falcon-keygen.c:5656: 	for (u = 0, v = 0; u < n; u += 3, v ++) {
	movl	$0, %esi	#, v
# inputs/bootstrap/source/falcon-keygen.c:5656: 	for (u = 0, v = 0; u < n; u += 3, v ++) {
	movl	$0, %edx	#, u
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%edi, %edi	# d, _152
	movq	16(%rsp), %r8	# %sfp, gd
.L533:
	movl	4(%rbx,%rdx,4), %r9d	# MEM[(uint32_t *)fs_83 + 4B + u_250 * 4], _116
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	8(%rbx,%rdx,4), %eax	# MEM[(uint32_t *)fs_83 + 8B + u_250 * 4], _117
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r9	# _117, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# _94, _119
	imulq	%r9, %rax	# z, _119
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _120
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147355649, %rax, %rax	#, _120, w_121
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _122
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _123
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147355649, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _127
	sarl	$31, %r10d	#, _127
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147355649, %r10d	#, _129
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rbx,%rdx,4), %r9d	# MEM[(uint32_t *)fs_83 + u_250 * 4], _134
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r10), %eax	#, _135
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r9	# _135, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# _94, _137
	imulq	%r9, %rax	# z, _137
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _138
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147355649, %rax, %rax	#, _138, w_139
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _140
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _141
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147355649, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _145
	sarl	$31, %r9d	#, _145
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147355649, %r9d	#, _147
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r9), %r9d	#, _153
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %r9	# _152, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# _94, _155
	imulq	%r9, %rax	# z, _155
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _156
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147355649, %rax, %rax	#, _156, w_157
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _158
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _159
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147355649, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _163
	sarl	$31, %r9d	#, _163
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147355649, %r9d	#, _165
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r9d, %eax	# _165, tmp337
	movl	%eax, (%r15,%rsi,4)	# tmp337, MEM[(uint32_t *)data_45(D) + v_251 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%rbp,%rdx,4), %r9d	# MEM[(uint32_t *)gs_85 + 4B + u_250 * 4], _171
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	8(%rbp,%rdx,4), %eax	# MEM[(uint32_t *)gs_85 + 8B + u_250 * 4], _172
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r9	# _172, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# _94, _174
	imulq	%r9, %rax	# z, _174
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _175
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147355649, %rax, %rax	#, _175, w_176
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _177
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _178
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147355649, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _182
	sarl	$31, %r10d	#, _182
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147355649, %r10d	#, _184
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	0(%rbp,%rdx,4), %r9d	# MEM[(uint32_t *)gs_85 + u_250 * 4], _188
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r10), %eax	#, _189
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r9	# _189, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# _94, _191
	imulq	%r9, %rax	# z, _191
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _192
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147355649, %rax, %rax	#, _192, w_193
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _194
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _195
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147355649, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _199
	sarl	$31, %r9d	#, _199
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147355649, %r9d	#, _201
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r9), %r9d	#, _204
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %r9	# _152, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# _94, _206
	imulq	%r9, %rax	# z, _206
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _207
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147355649, %rax, %rax	#, _207, w_208
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _209
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _210
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147355649, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r9d	# d, _214
	sarl	$31, %r9d	#, _214
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147355649, %r9d	#, _216
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r9d, %eax	# _216, tmp363
	movl	%eax, (%r8,%rsi,4)	# tmp363, MEM[(uint32_t *)gd_82 + v_251 * 4]
# inputs/bootstrap/source/falcon-keygen.c:5656: 	for (u = 0, v = 0; u < n; u += 3, v ++) {
	addq	$3, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:5656: 	for (u = 0, v = 0; u < n; u += 3, v ++) {
	addq	$1, %rsi	#, v
# inputs/bootstrap/source/falcon-keygen.c:5656: 	for (u = 0, v = 0; u < n; u += 3, v ++) {
	cmpq	%r13, %rdx	# n, u
	jb	.L533	#,
.L532:
# inputs/bootstrap/source/falcon-keygen.c:5664: 	if (!out_ntt) {
	cmpb	$0, 39(%rsp)	#, %sfp
	je	.L545	#,
# inputs/bootstrap/source/falcon-keygen.c:5722: 		for (d = 1; d < depth; d ++) {
	cmpl	$1, %r14d	#, depth
	jbe	.L523	#,
	movl	$1, %ebx	#, _25
	movzbl	38(%rsp), %ebp	# %sfp, _17
.L535:
	movl	%ebx, %edx	# _25, d
# inputs/bootstrap/source/falcon-keygen.c:5724: 				1, (d + 1) < depth || out_ntt);
	addl	$1, %ebx	#, _25
# inputs/bootstrap/source/falcon-keygen.c:5723: 			make_fg_step(data, logn - d, d, 1,
	cmpl	%r14d, %ebx	# depth, _25
	setb	%r9b	#, _24
# inputs/bootstrap/source/falcon-keygen.c:5723: 			make_fg_step(data, logn - d, d, 1,
	orl	%ebp, %r9d	# _17, _52
# inputs/bootstrap/source/falcon-keygen.c:5723: 			make_fg_step(data, logn - d, d, 1,
	movl	%r12d, %esi	# logn, _26
	subl	%edx, %esi	# d, _26
	andl	$1, %r9d	#,
	movl	$1, %r8d	#,
	movl	$1, %ecx	#,
	movq	%r15, %rdi	# data,
	call	make_fg_step	#
# inputs/bootstrap/source/falcon-keygen.c:5722: 		for (d = 1; d < depth; d ++) {
	cmpl	%r14d, %ebx	# depth, _25
	jne	.L535	#,
	jmp	.L523	#
.L545:
# inputs/bootstrap/source/falcon-keygen.c:5665: 		modp_iNTT3(fd, igm, logn - 1, 0, p, p0i);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 120
	movl	8(%rsp), %ebx	# %sfp, p0i
	pushq	%rbx	# p0i
	.cfi_def_cfa_offset 128
	movl	$2147355649, %r9d	#,
	movl	$0, %r8d	#,
	movl	60(%rsp), %ebp	# %sfp, _79
	movl	%ebp, %ecx	# _79,
	movq	40(%rsp), %r14	# %sfp, igm
	movq	%r14, %rdx	# igm,
	movl	$1, %esi	#,
	movq	%r15, %rdi	# data,
	call	modp_iNTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5666: 		modp_iNTT3(gd, igm, logn - 1, 0, p, p0i);
	movl	%ebx, (%rsp)	# p0i,
	movl	$2147355649, %r9d	#,
	movl	$0, %r8d	#,
	movl	%ebp, %ecx	# _79,
	movq	%r14, %rdx	# igm,
	movl	$1, %esi	#,
	movq	32(%rsp), %rdi	# %sfp,
	call	modp_iNTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 112
	jmp	.L523	#
	.cfi_endproc
.LFE99:
	.size	make_fg, .-make_fg
	.globl	bitlength
	.type	bitlength, @function
bitlength:
.LFB72:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:4231: 	x |= x >> 1;
	movl	%edi, %eax	# tmp119, _1
	shrl	%eax	# _1
# inputs/bootstrap/source/falcon-keygen.c:4231: 	x |= x >> 1;
	orl	%edi, %eax	# tmp119, x
# inputs/bootstrap/source/falcon-keygen.c:4232: 	x |= x >> 2;
	movl	%eax, %edx	# x, _2
	shrl	$2, %edx	#, _2
# inputs/bootstrap/source/falcon-keygen.c:4232: 	x |= x >> 2;
	orl	%eax, %edx	# x, x
# inputs/bootstrap/source/falcon-keygen.c:4233: 	x |= x >> 4;
	movl	%edx, %eax	# x, _3
	shrl	$4, %eax	#, _3
# inputs/bootstrap/source/falcon-keygen.c:4233: 	x |= x >> 4;
	orl	%edx, %eax	# x, x
# inputs/bootstrap/source/falcon-keygen.c:4234: 	x |= x >> 8;
	movl	%eax, %edx	# x, _4
	shrl	$8, %edx	#, _4
# inputs/bootstrap/source/falcon-keygen.c:4234: 	x |= x >> 8;
	orl	%eax, %edx	# x, x
# inputs/bootstrap/source/falcon-keygen.c:4235: 	x |= x >> 16;
	movl	%edx, %eax	# x, _5
	shrl	$16, %eax	#, _5
# inputs/bootstrap/source/falcon-keygen.c:4235: 	x |= x >> 16;
	orl	%edx, %eax	# x, x_13
# inputs/bootstrap/source/falcon-keygen.c:4236: 	return vv[(x * 0xF04653AE) >> 27];
	imull	$-263826514, %eax, %eax	#, x_13, _6
# inputs/bootstrap/source/falcon-keygen.c:4236: 	return vv[(x * 0xF04653AE) >> 27];
	shrl	$27, %eax	#, _7
# inputs/bootstrap/source/falcon-keygen.c:4236: 	return vv[(x * 0xF04653AE) >> 27];
	movl	%eax, %eax	# _7, _7
# inputs/bootstrap/source/falcon-keygen.c:4236: 	return vv[(x * 0xF04653AE) >> 27];
	leaq	vv.0(%rip), %rdx	#, tmp113
	movl	(%rdx,%rax,4), %eax	# vv[_7], vv[_7]
# inputs/bootstrap/source/falcon-keygen.c:4237: }
	ret	
	.cfi_endproc
.LFE72:
	.size	bitlength, .-bitlength
	.type	poly_max_bitlength, @function
poly_max_bitlength:
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
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 64
# inputs/bootstrap/source/falcon-keygen.c:4452: 	n = MKN(logn, ter);
	leal	1(%r8,%r8), %eax	#, _3
	subl	%r8d, %ecx	# ter, _4
# inputs/bootstrap/source/falcon-keygen.c:4452: 	n = MKN(logn, ter);
	salq	%cl, %rax	# _4, _3
	movq	%rax, (%rsp)	# n, %sfp
# inputs/bootstrap/source/falcon-keygen.c:4454: 	for (u = 0; u < n; u ++, f += fstride) {
	testq	%rax, %rax	# n
	je	.L553	#,
	movq	%rdi, %rbp	# tmp142, f
	movq	%rsi, %r14	# tmp143, flen
# inputs/bootstrap/source/falcon-keygen.c:4454: 	for (u = 0; u < n; u ++, f += fstride) {
	leaq	0(,%rdx,4), %r15	#, _5
# inputs/bootstrap/source/falcon-keygen.c:4453: 	maxbl = 0;
	movl	$0, %r12d	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:4454: 	for (u = 0; u < n; u ++, f += fstride) {
	movl	$0, %r13d	#, u
	jmp	.L552	#
.L553:
# inputs/bootstrap/source/falcon-keygen.c:4453: 	maxbl = 0;
	movl	$0, %r12d	#, <retval>
.L547:
# inputs/bootstrap/source/falcon-keygen.c:4463: }
	movl	%r12d, %eax	# <retval>,
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
.L550:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:4262: 	return (uint32_t)(xlen - 1) * 31 + bitlength(x[xlen - 1] ^ sign);
	xorl	-4(%rbp,%rbx,4), %edi	# *_37, _39
	call	bitlength	#
	movl	%eax, %edx	#, tmp147
# inputs/bootstrap/source/falcon-keygen.c:4262: 	return (uint32_t)(xlen - 1) * 31 + bitlength(x[xlen - 1] ^ sign);
	movl	%ebx, %eax	# xlen, tmp138
	sall	$5, %eax	#, tmp138
	subl	%ebx, %eax	# xlen, _34
# inputs/bootstrap/source/falcon-keygen.c:4262: 	return (uint32_t)(xlen - 1) * 31 + bitlength(x[xlen - 1] ^ sign);
	leal	-31(%rax,%rdx), %eax	#, _42
.L549:
# inputs/bootstrap/source/falcon-keygen.c:4458: 		if (bl > maxbl) {
	cmpl	%eax, %r12d	# _42, <retval>
	cmovb	%eax, %r12d	# <retval>,, _42, <retval>
# inputs/bootstrap/source/falcon-keygen.c:4454: 	for (u = 0; u < n; u ++, f += fstride) {
	addq	$1, %r13	#, u
# inputs/bootstrap/source/falcon-keygen.c:4454: 	for (u = 0; u < n; u ++, f += fstride) {
	addq	%r15, %rbp	# _5, f
# inputs/bootstrap/source/falcon-keygen.c:4454: 	for (u = 0; u < n; u ++, f += fstride) {
	cmpq	%r13, (%rsp)	# u, %sfp
	je	.L547	#,
.L552:
# inputs/bootstrap/source/falcon-keygen.c:4250: 		return 0;
	movl	$0, %eax	#, _42
# inputs/bootstrap/source/falcon-keygen.c:4249: 	if (xlen == 0) {
	testq	%r14, %r14	# flen
	je	.L549	#,
# inputs/bootstrap/source/falcon-keygen.c:4252: 	sign = (-(x[xlen - 1] >> 30)) >> 1;
	movl	-4(%rbp,%r14,4), %edi	# MEM[(const uint32_t *)f_47 + -4B + flen_14(D) * 4], _24
	shrl	$30, %edi	#, _24
# inputs/bootstrap/source/falcon-keygen.c:4252: 	sign = (-(x[xlen - 1] >> 30)) >> 1;
	negl	%edi	# _25
# inputs/bootstrap/source/falcon-keygen.c:4252: 	sign = (-(x[xlen - 1] >> 30)) >> 1;
	shrl	%edi	# sign
	movq	%r14, %rbx	# flen, xlen
	.p2align 4
.L551:
# inputs/bootstrap/source/falcon-keygen.c:4254: 		if (x[xlen - 1] != sign) {
	cmpl	-4(%rbp,%rbx,4), %edi	# MEM[(const uint32_t *)f_47 + -4B + xlen_51 * 4], sign
	jne	.L550	#,
# inputs/bootstrap/source/falcon-keygen.c:4253: 	while (xlen > 0) {
	subq	$1, %rbx	#, xlen
	jne	.L551	#,
# inputs/bootstrap/source/falcon-keygen.c:4260: 		return 0;
	movl	$0, %eax	#, _42
	jmp	.L549	#
	.cfi_endproc
.LFE78:
	.size	poly_max_bitlength, .-poly_max_bitlength
	.type	solve_NTRU_binary_depth1, @function
solve_NTRU_binary_depth1:
.LFB102:
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
	subq	$232, %rsp	#,
	.cfi_def_cfa_offset 288
	movq	%rdi, %rbx	# tmp692, fk
	movq	%rdi, 120(%rsp)	# fk, %sfp
	movq	%rsi, 192(%rsp)	# tmp693, %sfp
	movq	%rdx, 200(%rsp)	# tmp694, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6418: 	logn_top = fk->logn;
	movl	(%rdi), %esi	# fk_111(D)->logn, logn_top
	movl	%esi, 136(%rsp)	# logn_top, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6419: 	n_top = (size_t)1 << logn_top;
	movl	$1, %eax	#, tmp482
	movq	%rax, %rdi	# tmp482, n_top
	movl	%esi, %ecx	# logn_top, tmp778
	salq	%cl, %rdi	# tmp778, n_top
	movq	%rdi, 184(%rsp)	# n_top, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6420: 	logn = logn_top - depth;
	leal	-1(%rsi), %edi	#, logn
	movl	%edi, 68(%rsp)	# logn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6421: 	n = (size_t)1 << logn;
	movl	%edi, %ecx	# logn, tmp782
	salq	%cl, %rax	# tmp782, tmp482
	movq	%rax, 104(%rsp)	# n, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6422: 	hn = n >> 1;
	shrq	%rax	# hn
	movq	%rax, 16(%rsp)	# hn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6457: 	Fd = fk->tmp;
	movq	432(%rbx), %rsi	# fk_111(D)->tmp, Fd
# inputs/bootstrap/source/falcon-keygen.c:6458: 	Gd = Fd + dlen * hn;
	leaq	0(,%rax,8), %r15	#, _1
# inputs/bootstrap/source/falcon-keygen.c:6458: 	Gd = Fd + dlen * hn;
	leaq	(%rsi,%r15), %rdx	#, Gd
# inputs/bootstrap/source/falcon-keygen.c:6459: 	Ft = Gd + dlen * hn;
	addq	%rdx, %r15	# Gd, Ft
# inputs/bootstrap/source/falcon-keygen.c:6460: 	Gt = Ft + llen * n;
	movl	$2, %eax	#, tmp484
	salq	%cl, %rax	# tmp787, tmp484
	movq	%rax, %rbp	# tmp484, _2
# inputs/bootstrap/source/falcon-keygen.c:6460: 	Gt = Ft + llen * n;
	leaq	0(,%rax,4), %r12	#, _3
# inputs/bootstrap/source/falcon-keygen.c:6460: 	Gt = Ft + llen * n;
	leaq	(%r15,%r12), %r13	#, Gt
	leaq	PRIMES2(%rip), %rax	#, ivtmp.1039
	movq	%rax, 152(%rsp)	# ivtmp.1039, %sfp
	movq	%r15, 48(%rsp)	# Ft, %sfp
	movq	%r13, 56(%rsp)	# Gt, %sfp
	movq	%rax, 40(%rsp)	# ivtmp.1039, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	movq	%rbp, 88(%rsp)	# _2, %sfp
	movq	%r12, 96(%rsp)	# _3, %sfp
	movq	%rsi, 72(%rsp)	# Fd, %sfp
	movq	%rdx, 80(%rsp)	# Gd, %sfp
	movq	%r15, 112(%rsp)	# Ft, %sfp
	movq	%r13, 128(%rsp)	# Gt, %sfp
.L561:
# inputs/bootstrap/source/falcon-keygen.c:6471: 		p = PRIMES2[u].p;
	movq	40(%rsp), %rax	# %sfp, ivtmp.1063
	movl	(%rax), %r15d	# MEM[(unsigned int *)_598], p
# inputs/bootstrap/source/falcon-keygen.c:6472: 		p0i = modp_ninv31(p);
	movl	%r15d, %edi	# p,
	call	modp_ninv31	#
	movl	%eax, %r14d	# tmp695, p0i
# inputs/bootstrap/source/falcon-keygen.c:6473: 		R2 = modp_R2(p, p0i);
	movl	%eax, %esi	# p0i,
	movl	%r15d, %edi	# p,
	call	modp_R2	#
	movl	%eax, %ebx	# tmp696, R2
	movl	%eax, 8(%rsp)	# R2, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	$-2147483648, %eax	#, _354
	subl	%r15d, %eax	# p, _354
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%ebx, %edx	# R2, _356
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdx, %rax	# _356, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rax, %rbp	# z, _359
	imulq	%r14, %rbp	# p0i, _359
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ebp	#, _360
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r15d, %edx	# p, _361
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rdx, %rbp	# _361, w_362
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rax, %rbp	# z, _363
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rbp	#, _364
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r15d, %ebp	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ebp, %eax	# d, _368
	sarl	$31, %eax	#, _368
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r15d, %eax	# p, _370
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %ebp	# _370, d
# inputs/bootstrap/source/falcon-keygen.c:6475: 		for (v = 0, xs = Fd, ys = Gd, xd = Ft + u, yd = Gt + u;
	movq	48(%rsp), %rax	# %sfp, ivtmp.1064
	movq	%rax, 24(%rsp)	# ivtmp.1064, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6475: 		for (v = 0, xs = Fd, ys = Gd, xd = Ft + u, yd = Gt + u;
	movq	56(%rsp), %rax	# %sfp, ivtmp.1065
	movq	%rax, 32(%rsp)	# ivtmp.1065, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6476: 			v < hn;
	cmpq	$0, 16(%rsp)	#, %sfp
	je	.L559	#,
# inputs/bootstrap/source/falcon-keygen.c:6475: 		for (v = 0, xs = Fd, ys = Gd, xd = Ft + u, yd = Gt + u;
	movq	80(%rsp), %r13	# %sfp, ys
# inputs/bootstrap/source/falcon-keygen.c:6475: 		for (v = 0, xs = Fd, ys = Gd, xd = Ft + u, yd = Gt + u;
	movq	72(%rsp), %r12	# %sfp, xs
# inputs/bootstrap/source/falcon-keygen.c:6475: 		for (v = 0, xs = Fd, ys = Gd, xd = Ft + u, yd = Gt + u;
	movl	$0, %ebx	#, v
.L560:
# inputs/bootstrap/source/falcon-keygen.c:6479: 			*xd = zint_mod_small_signed(xs, dlen, p, p0i, R2, Rx);
	movl	%ebp, %r9d	# d,
	movl	8(%rsp), %r8d	# %sfp,
	movl	%r14d, %ecx	# p0i,
	movl	%r15d, %edx	# p,
	movl	$2, %esi	#,
	movq	%r12, %rdi	# xs,
	call	zint_mod_small_signed	#
# inputs/bootstrap/source/falcon-keygen.c:6479: 			*xd = zint_mod_small_signed(xs, dlen, p, p0i, R2, Rx);
	movq	24(%rsp), %rsi	# %sfp, xd
	movl	%eax, (%rsi,%rbx,8)	# tmp697, MEM[(uint32_t *)xd_257 + v_572 * 8]
# inputs/bootstrap/source/falcon-keygen.c:6480: 			*yd = zint_mod_small_signed(ys, dlen, p, p0i, R2, Rx);
	movl	%ebp, %r9d	# d,
	movl	8(%rsp), %r8d	# %sfp,
	movl	%r14d, %ecx	# p0i,
	movl	%r15d, %edx	# p,
	movl	$2, %esi	#,
	movq	%r13, %rdi	# ys,
	call	zint_mod_small_signed	#
# inputs/bootstrap/source/falcon-keygen.c:6480: 			*yd = zint_mod_small_signed(ys, dlen, p, p0i, R2, Rx);
	movq	32(%rsp), %rsi	# %sfp, yd
	movl	%eax, (%rsi,%rbx,8)	# tmp698, MEM[(uint32_t *)yd_258 + v_572 * 8]
# inputs/bootstrap/source/falcon-keygen.c:6477: 			v ++, xs += dlen, ys += dlen, xd += llen, yd += llen)
	addq	$1, %rbx	#, v
# inputs/bootstrap/source/falcon-keygen.c:6477: 			v ++, xs += dlen, ys += dlen, xd += llen, yd += llen)
	addq	$8, %r12	#, xs
# inputs/bootstrap/source/falcon-keygen.c:6477: 			v ++, xs += dlen, ys += dlen, xd += llen, yd += llen)
	addq	$8, %r13	#, ys
# inputs/bootstrap/source/falcon-keygen.c:6476: 			v < hn;
	cmpq	%rbx, 16(%rsp)	# v, %sfp
	jne	.L560	#,
.L559:
# inputs/bootstrap/source/falcon-keygen.c:6466: 	for (u = 0; u < llen; u ++) {
	addq	$12, 40(%rsp)	#, %sfp
	movq	40(%rsp), %rax	# %sfp, ivtmp.1063
	addq	$4, 48(%rsp)	#, %sfp
	addq	$4, 56(%rsp)	#, %sfp
	leaq	24+PRIMES2(%rip), %rbx	#, tmp805
	cmpq	%rbx, %rax	# tmp805, ivtmp.1063
	jne	.L561	#,
# inputs/bootstrap/source/falcon-keygen.c:6487: 	memmove(fk->tmp, Ft, llen * n * sizeof(uint32_t));
	movq	88(%rsp), %rbp	# %sfp, _2
	movq	96(%rsp), %r12	# %sfp, _3
	movq	112(%rsp), %r15	# %sfp, Ft
	movq	128(%rsp), %r13	# %sfp, Gt
	movq	120(%rsp), %rbx	# %sfp, fk
	movq	432(%rbx), %rdi	# fk_111(D)->tmp, fk_111(D)->tmp
	movq	%r12, %rdx	# _3,
	movq	%r15, %rsi	# Ft,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6488: 	Ft = fk->tmp;
	movq	432(%rbx), %rax	# fk_111(D)->tmp, Ft
	movq	%rax, 88(%rsp)	# Ft, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6489: 	memmove(Ft + llen * n, Gt, llen * n * sizeof(uint32_t));
	addq	%r12, %rax	# _3, _8
	movq	%rax, %rbx	# _8, _8
	movq	%rax, 144(%rsp)	# _8, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6489: 	memmove(Ft + llen * n, Gt, llen * n * sizeof(uint32_t));
	movq	%r12, %rdx	# _3,
	movq	%r13, %rsi	# Gt,
	movq	%rax, %rdi	# _8,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6491: 	ft = Gt + llen * n;
	leaq	(%rbx,%r12), %rsi	#, ft
	movq	%rsi, 128(%rsp)	# ft, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6492: 	gt = ft + slen * n;
	movl	$4, %eax	#, tmp499
	movq	%rax, %rbx	# tmp499, _9
	movzbl	68(%rsp), %ecx	# %sfp, tmp814
	salq	%cl, %rbx	# tmp814, _9
	movq	%rbx, 160(%rsp)	# _9, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6492: 	gt = ft + slen * n;
	addq	%rbx, %rsi	# _9, gt
	movq	%rsi, 208(%rsp)	# gt, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6494: 	t1 = gt + slen * n;
	leaq	(%rsi,%rbx), %rdi	#, t1
	movq	%rdi, 72(%rsp)	# t1, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6521: 		igm = gm + n_top;
	movl	136(%rsp), %edx	# %sfp, logn_top
	movl	%edx, %ecx	# logn_top, tmp821
	salq	%cl, %rax	# tmp821, _10
# inputs/bootstrap/source/falcon-keygen.c:6521: 		igm = gm + n_top;
	leaq	(%rdi,%rax), %rsi	#, igm
# inputs/bootstrap/source/falcon-keygen.c:6522: 		fx = igm + n;
	leaq	(%rsi,%rbx), %r15	#, fx
# inputs/bootstrap/source/falcon-keygen.c:6523: 		gx = fx + n_top;
	leaq	(%r15,%rax), %rcx	#, gx
# inputs/bootstrap/source/falcon-keygen.c:6549: 			memmove(gm + n, igm, n * sizeof *igm);
	addq	%rbx, %rdi	# _9, _22
# inputs/bootstrap/source/falcon-keygen.c:6551: 			memmove(igm + n, fx, n * sizeof *ft);
	leaq	(%rdi,%rbx), %r13	#, _23
# inputs/bootstrap/source/falcon-keygen.c:6553: 			memmove(fx + n, gx, n * sizeof *gt);
	leaq	0(%r13,%rbx), %r14	#, _24
# inputs/bootstrap/source/falcon-keygen.c:6562: 		Fp = gx + n;
	leaq	(%r14,%rbx), %rax	#, Fp
	movq	%rax, 24(%rsp)	# Fp, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6563: 		Gp = Fp + hn;
	movq	16(%rsp), %rbx	# %sfp, hn
	salq	$2, %rbx	#, _25
	movq	%rbx, 48(%rsp)	# _25, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6563: 		Gp = Fp + hn;
	addq	%rbx, %rax	# _25, Gp
	movq	%rax, 32(%rsp)	# Gp, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6499: 	for (u = 0; u < llen; u ++) {
	movq	$0, 96(%rsp)	#, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6570: 		modp_NTT2(Fp, gm, logn - 1, p, p0i);
	leal	-2(%rdx), %eax	#, _32
	movl	%eax, 140(%rsp)	# _32, %sfp
	movq	%rbp, 216(%rsp)	# _2, %sfp
	movq	%rdi, 80(%rsp)	# _22, %sfp
	movq	%r14, 40(%rsp)	# _24, %sfp
	movq	%r13, %r14	# _23, _23
	movq	%rsi, 112(%rsp)	# igm, %sfp
	movq	%rcx, %r13	# gx, gx
	jmp	.L569	#
.L585:
# inputs/bootstrap/source/falcon-keygen.c:6634: 			modp_iNTT2(fx, igm, logn, p, p0i);
	movl	56(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	68(%rsp), %r12d	# %sfp, logn
	movl	%r12d, %ecx	# logn,
	movq	80(%rsp), %rbp	# %sfp, _22
	movq	%rbp, %rdx	# _22,
	movl	$1, %esi	#,
	movq	%r14, %rdi	# _23,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6635: 			modp_iNTT2(gx, igm, logn, p, p0i);
	movl	56(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	%r12d, %ecx	# logn,
	movq	%rbp, %rdx	# _22,
	movl	$1, %esi	#,
	movq	40(%rsp), %rbx	# %sfp, _24
	movq	%rbx, %rdi	# _24,
	call	modp_iNTT2_ext	#
	movq	%rbx, %rcx	# _24, _24
	movq	104(%rsp), %rsi	# %sfp, n
	movq	128(%rsp), %rdi	# %sfp, ft
	movq	208(%rsp), %r8	# %sfp, gt
	movq	96(%rsp), %rax	# %sfp, v
	.p2align 5
.L568:
# inputs/bootstrap/source/falcon-keygen.c:6639: 				*x = fx[v];
	movl	(%r14,%rax,4), %edx	# MEM[(uint32_t *)_23 + v_581 * 4], _46
# inputs/bootstrap/source/falcon-keygen.c:6639: 				*x = fx[v];
	movl	%edx, (%rdi,%rax,4)	# _46, MEM[(uint32_t *)ft_124 + v_581 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6640: 				*y = gx[v];
	movl	(%rcx,%rax,4), %edx	# MEM[(uint32_t *)_24 + v_581 * 4], _48
# inputs/bootstrap/source/falcon-keygen.c:6640: 				*y = gx[v];
	movl	%edx, (%r8,%rax,4)	# _48, MEM[(uint32_t *)gt_125 + v_581 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6637: 				v < n; v ++, x += slen, y += slen)
	addq	$1, %rax	#, v
# inputs/bootstrap/source/falcon-keygen.c:6637: 				v < n; v ++, x += slen, y += slen)
	cmpq	%rax, %rsi	# v, n
	jne	.L568	#,
# inputs/bootstrap/source/falcon-keygen.c:6499: 	for (u = 0; u < llen; u ++) {
	addq	$12, 152(%rsp)	#, %sfp
	movq	$1, 96(%rsp)	#, %sfp
.L569:
# inputs/bootstrap/source/falcon-keygen.c:6508: 		p = PRIMES2[u].p;
	movq	152(%rsp), %r12	# %sfp, ivtmp.1039
	movl	(%r12), %ebx	# MEM[(unsigned int *)_384], p
# inputs/bootstrap/source/falcon-keygen.c:6509: 		p0i = modp_ninv31(p);
	movl	%ebx, %edi	# p,
	call	modp_ninv31	#
	movl	%eax, %ebp	# tmp699, p0i
	movl	%eax, 56(%rsp)	# p0i, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6510: 		R2 = modp_R2(p, p0i);
	movl	%eax, %esi	# p0i,
	movl	%ebx, %edi	# p,
	call	modp_R2	#
	movl	%eax, 8(%rsp)	# tmp700, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6524: 		modp_mkgm2(gm, igm, logn_top, PRIMES2[u].g, p, p0i);
	movl	4(%r12), %ecx	# MEM[(unsigned int *)_384 + 4B], MEM[(unsigned int *)_384 + 4B]
	movl	%ebp, %r9d	# p0i,
	movl	%ebx, %r8d	# p,
	movl	136(%rsp), %edx	# %sfp,
	movq	112(%rsp), %rsi	# %sfp,
	movq	72(%rsp), %rdi	# %sfp,
	call	modp_mkgm2	#
# inputs/bootstrap/source/falcon-keygen.c:6529: 		for (v = 0; v < n_top; v ++) {
	movl	$0, %eax	#, v
	movq	184(%rsp), %rsi	# %sfp, n_top
	movq	192(%rsp), %rdi	# %sfp, f
	movq	200(%rsp), %r8	# %sfp, g
	.p2align 6
.L562:
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	(%rdi,%rax,2), %ecx	# MEM[(const int16_t *)f_244(D) + v_578 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%ecx, %edx	# w, _136
	sarl	$31, %edx	#, _136
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	%ebx, %edx	# p, _131
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%ecx, %edx	# w, tmp505
	movl	%edx, (%r15,%rax,4)	# tmp505, MEM[(uint32_t *)fx_195 + v_578 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	(%r8,%rax,2), %ecx	# MEM[(const int16_t *)g_247(D) + v_578 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%ecx, %edx	# w, _181
	sarl	$31, %edx	#, _181
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	%ebx, %edx	# p, _186
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%ecx, %edx	# w, tmp509
	movl	%edx, 0(%r13,%rax,4)	# tmp509, MEM[(uint32_t *)gx_196 + v_578 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6529: 		for (v = 0; v < n_top; v ++) {
	addq	$1, %rax	#, v
# inputs/bootstrap/source/falcon-keygen.c:6529: 		for (v = 0; v < n_top; v ++) {
	cmpq	%rax, %rsi	# v, n_top
	jne	.L562	#,
# inputs/bootstrap/source/falcon-keygen.c:6537: 		modp_NTT2(fx, gm, logn_top, p, p0i);
	movl	56(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	136(%rsp), %ebp	# %sfp, logn_top
	movl	%ebp, %ecx	# logn_top,
	movq	72(%rsp), %r12	# %sfp, t1
	movq	%r12, %rdx	# t1,
	movl	$1, %esi	#,
	movq	%r15, %rdi	# fx,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6538: 		modp_NTT2(gx, gm, logn_top, p, p0i);
	movl	56(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	%ebp, %ecx	# logn_top,
	movq	%r12, %rdx	# t1,
	movl	$1, %esi	#,
	movq	%r13, %rdi	# gx,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6539: 		for (e = logn_top; e > logn; e --) {
	cmpl	%ebp, 68(%rsp)	# logn_top, %sfp
	jb	.L563	#,
.L574:
# inputs/bootstrap/source/falcon-keygen.c:6549: 			memmove(gm + n, igm, n * sizeof *igm);
	movq	160(%rsp), %rbp	# %sfp, _9
	movq	%rbp, %rdx	# _9,
	movq	112(%rsp), %rsi	# %sfp,
	movq	80(%rsp), %rdi	# %sfp,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6551: 			memmove(igm + n, fx, n * sizeof *ft);
	movq	%rbp, %rdx	# _9,
	movq	%r15, %rsi	# fx,
	movq	%r14, %rdi	# _23,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6553: 			memmove(fx + n, gx, n * sizeof *gt);
	movq	%rbp, %rdx	# _9,
	movq	%r13, %rsi	# gx,
	movq	40(%rsp), %rdi	# %sfp,
	call	memmove@PLT	#
	movq	96(%rsp), %rax	# %sfp, v
	leaq	0(,%rax,4), %rbp	#, _386
# inputs/bootstrap/source/falcon-keygen.c:6564: 		for (v = 0, x = Ft + u, y = Gt + u;
	movq	88(%rsp), %rax	# %sfp, Ft
	leaq	(%rax,%rbp), %r12	#, x
# inputs/bootstrap/source/falcon-keygen.c:6564: 		for (v = 0, x = Ft + u, y = Gt + u;
	movq	144(%rsp), %rax	# %sfp, _8
	addq	%rax, %rbp	# _8, y
# inputs/bootstrap/source/falcon-keygen.c:6565: 			v < hn; v ++, x += llen, y += llen)
	movq	16(%rsp), %rcx	# %sfp, hn
	testq	%rcx, %rcx	# hn
	je	.L564	#,
# inputs/bootstrap/source/falcon-keygen.c:6564: 		for (v = 0, x = Ft + u, y = Gt + u;
	movl	$0, %eax	#, v
	movq	24(%rsp), %rsi	# %sfp, Fp
	movq	32(%rsp), %rdi	# %sfp, Gp
	.p2align 5
.L565:
# inputs/bootstrap/source/falcon-keygen.c:6567: 			Fp[v] = *x;
	movl	(%r12,%rax,8), %edx	# MEM[(uint32_t *)x_205 + v_579 * 8], _29
# inputs/bootstrap/source/falcon-keygen.c:6567: 			Fp[v] = *x;
	movl	%edx, (%rsi,%rax,4)	# _29, MEM[(uint32_t *)Fp_203 + v_579 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6568: 			Gp[v] = *y;
	movl	0(%rbp,%rax,8), %edx	# MEM[(uint32_t *)y_206 + v_579 * 8], _31
# inputs/bootstrap/source/falcon-keygen.c:6568: 			Gp[v] = *y;
	movl	%edx, (%rdi,%rax,4)	# _31, MEM[(uint32_t *)Gp_204 + v_579 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6565: 			v < hn; v ++, x += llen, y += llen)
	addq	$1, %rax	#, v
# inputs/bootstrap/source/falcon-keygen.c:6565: 			v < hn; v ++, x += llen, y += llen)
	cmpq	%rax, %rcx	# v, hn
	jne	.L565	#,
# inputs/bootstrap/source/falcon-keygen.c:6570: 		modp_NTT2(Fp, gm, logn - 1, p, p0i);
	movl	56(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	140(%rsp), %ecx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	24(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6571: 		modp_NTT2(Gp, gm, logn - 1, p, p0i);
	movl	56(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	140(%rsp), %ecx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	32(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
	movl	$0, %edx	#, ivtmp.1010
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	8(%rsp), %esi	# %sfp, _330
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	56(%rsp), %r10d	# %sfp, _332
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebx, %r9d	# p, _335
	movq	%r15, 168(%rsp)	# fx, %sfp
	movq	%r13, 176(%rsp)	# gx, %sfp
	movq	%rsi, %r13	# _330, _330
.L566:
# inputs/bootstrap/source/falcon-keygen.c:6616: 			ftA = fx[(v << 1) + 0];
	movl	(%r14,%rdx,2), %eax	# MEM[(uint32_t *)_23 + ivtmp.1010_378 * 2], ftA
	movl	%eax, 8(%rsp)	# ftA, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6617: 			ftB = fx[(v << 1) + 1];
	movl	4(%r14,%rdx,2), %esi	# MEM[(uint32_t *)_23 + 4B + ivtmp.1010_378 * 2], ftB
# inputs/bootstrap/source/falcon-keygen.c:6618: 			gtA = gx[(v << 1) + 0];
	movq	40(%rsp), %r15	# %sfp, _24
	movl	(%r15,%rdx,2), %edi	# MEM[(uint32_t *)_24 + ivtmp.1010_378 * 2], gtA
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	24(%rsp), %rcx	# %sfp, Fp
	movl	(%rcx,%rdx), %ecx	# MEM[(uint32_t *)Fp_203 + ivtmp.1010_378 * 1], _329
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r13, %rcx	# _330, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# z, _333
	imulq	%r10, %rax	# _332, _333
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _334
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rax	# _335, w_336
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rax	# z, _337
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _338
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r11d	# d, _342
	sarl	$31, %r11d	#, _342
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r11d	# p, _344
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	32(%rsp), %rcx	# %sfp, Gp
	movl	(%rcx,%rdx), %r8d	# MEM[(uint32_t *)Gp_204 + ivtmp.1010_378 * 1], _315
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r13, %r8	# _330, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r8, %rcx	# z, _317
	imulq	%r10, %rcx	# _332, _317
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _318
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rcx	# _335, w_319
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rcx	# z, _320
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _321
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %r8d	# d, _325
	sarl	$31, %r8d	#, _325
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r8d	# p, _327
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r11), %r11d	#, _301
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%r15,%rdx,2), %r15d	# MEM[(uint32_t *)_24 + 4B + ivtmp.1010_378 * 2], _300
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r11, %r15	# _301, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r15, %rax	# z, _303
	imulq	%r10, %rax	# _332, _303
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _304
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rax	# _335, w_305
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r15, %rax	# z, _306
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _307
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r15d	# d, _311
	sarl	$31, %r15d	#, _311
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r15d	# p, _313
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r15d, %eax	# _313, tmp532
	movl	%eax, (%r12,%rdx,4)	# tmp532, MEM[(uint32_t *)x_205 + ivtmp.1010_378 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%edi, %edi	# gtA, _286
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r11, %rdi	# _301, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdi, %rax	# z, _288
	imulq	%r10, %rax	# _332, _288
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _289
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rax	# _335, w_290
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# z, _291
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _292
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %edi	# d, _296
	sarl	$31, %edi	#, _296
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %edi	# p, _298
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edi, %eax	# _298, tmp540
	movl	%eax, 8(%r12,%rdx,4)	# tmp540, MEM[(uint32_t *)x_205 + 8B + ivtmp.1010_378 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rcx,%r8), %ecx	#, _272
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%esi, %esi	# ftB, _271
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rsi	# _272, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rsi, %rax	# z, _274
	imulq	%r10, %rax	# _332, _274
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _275
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rax	# _335, w_276
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rsi, %rax	# z, _277
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _278
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %esi	# d, _282
	sarl	$31, %esi	#, _282
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %esi	# p, _284
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%esi, %eax	# _284, tmp549
	movl	%eax, 0(%rbp,%rdx,4)	# tmp549, MEM[(uint32_t *)y_206 + ivtmp.1010_378 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	8(%rsp), %eax	# %sfp, _231
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %rcx	# _231, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rcx, %rax	# z, _226
	imulq	%r10, %rax	# _332, _226
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _225
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rax	# _335, w_245
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rax	# z, _192
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _190
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ecx	# d, _253
	sarl	$31, %ecx	#, _253
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %ecx	# p, _269
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ecx, %eax	# _269, tmp557
	movl	%eax, 8(%rbp,%rdx,4)	# tmp557, MEM[(uint32_t *)y_206 + 8B + ivtmp.1010_378 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6611: 			v < hn; v ++, x += (llen << 1), y += (llen << 1))
	addq	$4, %rdx	#, ivtmp.1010
	cmpq	%rdx, 48(%rsp)	# ivtmp.1010, %sfp
	jne	.L566	#,
	movq	168(%rsp), %r15	# %sfp, fx
	movq	176(%rsp), %r13	# %sfp, gx
.L573:
# inputs/bootstrap/source/falcon-keygen.c:6627: 		modp_iNTT2_ext(Ft + u, llen, igm, logn, p, p0i);
	movl	56(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	68(%rsp), %ecx	# %sfp,
	movq	80(%rsp), %rdx	# %sfp,
	movl	$2, %esi	#,
	movq	%r12, %rdi	# x,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6628: 		modp_iNTT2_ext(Gt + u, llen, igm, logn, p, p0i);
	movl	56(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	68(%rsp), %ecx	# %sfp,
	movq	80(%rsp), %rdx	# %sfp,
	movl	$2, %esi	#,
	movq	%rbp, %rdi	# y,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6633: 		if (u < slen) {
	cmpq	$0, 96(%rsp)	#, %sfp
	je	.L585	#,
# inputs/bootstrap/source/falcon-keygen.c:6650: 	zint_rebuild_CRT(Ft, llen, llen, n << 1, PRIMES2, 1, t1);
	movq	216(%rsp), %rbp	# %sfp, _2
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 296
	movq	80(%rsp), %r13	# %sfp, t1
	pushq	%r13	# t1
	.cfi_def_cfa_offset 304
	movl	$1, %r9d	#,
	leaq	PRIMES2(%rip), %r8	#,
	movq	%rbp, %rcx	# _2,
	movl	$2, %edx	#,
	movl	$2, %esi	#,
	movq	104(%rsp), %r14	# %sfp, Ft
	movq	%r14, %rdi	# Ft,
	call	zint_rebuild_CRT	#
# inputs/bootstrap/source/falcon-keygen.c:6651: 	zint_rebuild_CRT(ft, slen, slen, n << 1, PRIMES2, 1, t1);
	movq	%r13, (%rsp)	# t1,
	movl	$1, %r9d	#,
	leaq	PRIMES2(%rip), %r8	#,
	movq	%rbp, %rcx	# _2,
	movl	$1, %edx	#,
	movl	$1, %esi	#,
	movq	144(%rsp), %rbx	# %sfp, ft
	movq	%rbx, %rdi	# ft,
	call	zint_rebuild_CRT	#
# inputs/bootstrap/source/falcon-keygen.c:6664: 	maxbl_f = poly_max_bitlength(ft, slen, slen, logn, 0);
	movl	$0, %r8d	#,
	movl	84(%rsp), %r15d	# %sfp, logn
	movl	%r15d, %ecx	# logn,
	movl	$1, %edx	#,
	movl	$1, %esi	#,
	movq	%rbx, 144(%rsp)	# ft, %sfp
	movq	%rbx, %rdi	# ft,
	call	poly_max_bitlength	#
	movl	%eax, %ebx	# tmp701, maxbl_f
# inputs/bootstrap/source/falcon-keygen.c:6665: 	maxbl_g = poly_max_bitlength(gt, slen, slen, logn, 0);
	movl	$0, %r8d	#,
	movl	%r15d, %ecx	# logn,
	movl	$1, %edx	#,
	movl	$1, %esi	#,
	movq	224(%rsp), %rdi	# %sfp,
	call	poly_max_bitlength	#
# inputs/bootstrap/source/falcon-keygen.c:6666: 	maxbl_fg = maxbl_f < maxbl_g ? maxbl_g : maxbl_f;
	cmpl	%eax, %ebx	# tmp702, maxbl_f
	cmovb	%eax, %ebx	# maxbl_f,, tmp702, maxbl_fg
# inputs/bootstrap/source/falcon-keygen.c:6668: 	maxbl_F = poly_max_bitlength(Ft, llen, llen, logn, 0);
	movl	$0, %r8d	#,
	movl	%r15d, %ecx	# logn,
	movl	$2, %edx	#,
	movl	$2, %esi	#,
	movq	%r14, 104(%rsp)	# Ft, %sfp
	movq	%r14, %rdi	# Ft,
	call	poly_max_bitlength	#
	movl	%eax, %ebp	# tmp703, maxbl_F
# inputs/bootstrap/source/falcon-keygen.c:6669: 	maxbl_G = poly_max_bitlength(Gt, llen, llen, logn, 0);
	movl	$0, %r8d	#,
	movl	%r15d, %ecx	# logn,
	movl	$2, %edx	#,
	movl	$2, %esi	#,
	movq	160(%rsp), %rdi	# %sfp,
	call	poly_max_bitlength	#
# inputs/bootstrap/source/falcon-keygen.c:6670: 	maxbl_FG = maxbl_F < maxbl_G ? maxbl_G : maxbl_F;
	cmpl	%eax, %ebp	# tmp704, maxbl_F
	cmovb	%eax, %ebp	# maxbl_F,, tmp704, maxbl_FG
# inputs/bootstrap/source/falcon-keygen.c:6672: 	if (maxbl_fg > 53 || maxbl_FG > 53) {
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 288
# inputs/bootstrap/source/falcon-keygen.c:6672: 	if (maxbl_fg > 53 || maxbl_FG > 53) {
	cmpl	$53, %ebx	#, maxbl_fg
	ja	.L575	#,
	cmpl	$53, %ebp	#, maxbl_FG
	ja	.L575	#,
# inputs/bootstrap/source/falcon-keygen.c:6679: 	rt1 = align_fpr(fk->tmp, gt + slen * n);
	movq	120(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %rdi	# fk_111(D)->tmp, fk_111(D)->tmp
	movq	%r13, %rsi	# t1,
	call	align_fpr	#
	movq	%rax, %r12	# tmp705, rt1
# inputs/bootstrap/source/falcon-keygen.c:6680: 	rt2 = rt1 + n;
	movl	$8, %eax	#, tmp563
	movl	%r15d, %ecx	# logn, tmp874
	salq	%cl, %rax	# tmp874, tmp563
	movq	%rax, %r14	# tmp563, _53
# inputs/bootstrap/source/falcon-keygen.c:6680: 	rt2 = rt1 + n;
	leaq	(%r12,%rax), %r13	#, rt2
# inputs/bootstrap/source/falcon-keygen.c:6681: 	poly_big_to_fp(rt1, Ft, llen, llen, logn, 0, maxbl_FG, 0);
	pushq	$0	#
	.cfi_def_cfa_offset 296
	pushq	%rbp	# maxbl_FG
	.cfi_def_cfa_offset 304
	movl	$0, %r9d	#,
	movl	%r15d, %r8d	# logn,
	movl	$2, %ecx	#,
	movl	$2, %edx	#,
	movq	104(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# rt1,
	call	poly_big_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:6682: 	poly_big_to_fp(rt2, Gt, llen, llen, logn, 0, maxbl_FG, 0);
	pushq	$0	#
	.cfi_def_cfa_offset 312
	pushq	%rbp	# maxbl_FG
	.cfi_def_cfa_offset 320
	movl	$0, %r9d	#,
	movl	%r15d, 100(%rsp)	# logn, %sfp
	movl	%r15d, %r8d	# logn,
	movl	$2, %ecx	#,
	movl	$2, %edx	#,
	movq	176(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# rt2,
	call	poly_big_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:6688: 	memmove(fk->tmp, ft, 2 * slen * n * sizeof *ft);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 288
	movq	120(%rsp), %rbp	# %sfp, fk
	movq	432(%rbp), %rdi	# fk_111(D)->tmp, fk_111(D)->tmp
	movq	%r14, %rdx	# _53,
	movq	128(%rsp), %rsi	# %sfp,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6689: 	ft = fk->tmp;
	movq	%rbp, 120(%rsp)	# fk, %sfp
	movq	432(%rbp), %rbp	# fk_111(D)->tmp, ft
# inputs/bootstrap/source/falcon-keygen.c:6690: 	gt = ft + slen * n;
	movq	160(%rsp), %rax	# %sfp, _9
	leaq	0(%rbp,%rax), %r15	#, gt
# inputs/bootstrap/source/falcon-keygen.c:6691: 	rt3 = align_fpr(fk->tmp, gt + slen * n);
	leaq	(%r15,%rax), %rsi	#, _55
# inputs/bootstrap/source/falcon-keygen.c:6691: 	rt3 = align_fpr(fk->tmp, gt + slen * n);
	movq	%rbp, %rdi	# ft,
	call	align_fpr	#
	movq	%rax, %r13	# tmp706, rt3
# inputs/bootstrap/source/falcon-keygen.c:6692: 	memmove(rt3, rt1, 2 * n * sizeof *rt1);
	movl	$16, %eax	#, tmp567
	movzbl	68(%rsp), %ecx	# %sfp, tmp880
	salq	%cl, %rax	# tmp880, tmp567
	movq	%rax, 24(%rsp)	# _56, %sfp
	movq	%rax, %rdx	# _56,
	movq	%r12, %rsi	# rt1,
	movq	%r13, %rdi	# rt3,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6695: 	rt3 = rt2 + n;
	movq	24(%rsp), %rax	# %sfp, _56
	leaq	0(%r13,%rax), %rdi	#, rt3
# inputs/bootstrap/source/falcon-keygen.c:6696: 	rt4 = rt3 + n;
	leaq	(%rdi,%r14), %r12	#, rt4
# inputs/bootstrap/source/falcon-keygen.c:6701: 	poly_big_to_fp(rt3, ft, slen, slen, logn, 0, maxbl_fg, 0);
	pushq	$0	#
	.cfi_def_cfa_offset 296
	pushq	%rbx	# maxbl_fg
	.cfi_def_cfa_offset 304
	movl	$0, %r9d	#,
	movl	84(%rsp), %r8d	# %sfp,
	movl	$1, %ecx	#,
	movl	$1, %edx	#,
	movq	%rbp, %rsi	# ft,
	call	poly_big_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:6702: 	poly_big_to_fp(rt4, gt, slen, slen, logn, 0, maxbl_fg, 0);
	pushq	$0	#
	.cfi_def_cfa_offset 312
	pushq	%rbx	# maxbl_fg
	.cfi_def_cfa_offset 320
	movl	$0, %r9d	#,
	movl	100(%rsp), %ebx	# %sfp, logn
	movl	%ebx, %r8d	# logn,
	movl	$1, %ecx	#,
	movl	$1, %edx	#,
	movq	%r15, %rsi	# gt,
	movq	%r12, %rdi	# rt4,
	call	poly_big_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:6707: 	memmove(fk->tmp, rt1, 4 * n * sizeof *rt1);
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 288
	movl	$32, %edx	#, tmp572
	movl	%ebx, %ecx	# logn, tmp882
	salq	%cl, %rdx	# tmp882, _57
	movq	120(%rsp), %r15	# %sfp, fk
	movq	432(%r15), %rdi	# fk_111(D)->tmp, fk_111(D)->tmp
	movq	%r13, %rsi	# rt3,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6708: 	rt1 = (fpr *)fk->tmp;
	movq	432(%r15), %rax	# fk_111(D)->tmp, rt1
# inputs/bootstrap/source/falcon-keygen.c:6709: 	rt2 = rt1 + n;
	leaq	(%rax,%r14), %r13	#, rt2
# inputs/bootstrap/source/falcon-keygen.c:6710: 	rt3 = rt2 + n;
	leaq	0(%r13,%r14), %rbp	#, rt3
	movq	%rbp, 32(%rsp)	# rt3, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6711: 	rt4 = rt3 + n;
	leaq	0(%rbp,%r14), %r12	#, rt4
	movq	%r12, 40(%rsp)	# rt4, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6721: 	falcon_FFT(rt1, logn);
	movl	%ebx, %esi	# logn,
	movq	%rax, 8(%rsp)	# rt1, %sfp
	movq	%rax, %rdi	# rt1,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6722: 	falcon_FFT(rt2, logn);
	movl	%ebx, %r15d	# logn, logn
	movl	%ebx, %esi	# logn,
	movq	%r13, 16(%rsp)	# rt2, %sfp
	movq	%r13, %rdi	# rt2,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6723: 	falcon_FFT(rt3, logn);
	movl	%ebx, %esi	# logn,
	movq	%rbp, %r13	# rt3, rt3
	movq	%rbp, %rdi	# rt3,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6724: 	falcon_FFT(rt4, logn);
	movl	%ebx, %esi	# logn,
	movq	%r12, %rdi	# rt4,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6732: 	rt5 = rt4 + n;
	leaq	(%r12,%r14), %rbp	#, rt5
# inputs/bootstrap/source/falcon-keygen.c:6733: 	rt6 = rt5 + n;
	leaq	0(%rbp,%r14), %rbx	#, rt6
# inputs/bootstrap/source/falcon-keygen.c:6734: 	falcon_poly_add_muladj_fft(rt5, rt1, rt2, rt3, rt4, logn);
	movl	%r15d, %r9d	# logn,
	movq	%r12, %r8	# rt4,
	movq	%r13, %rcx	# rt3,
	movq	16(%rsp), %rdx	# %sfp,
	movq	8(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# rt5,
	call	falcon_poly_add_muladj_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6735: 	falcon_poly_invnorm2_fft(rt6, rt3, rt4, logn);
	movl	%r15d, %ecx	# logn,
	movq	%r12, %rdx	# rt4,
	movq	%r13, %rsi	# rt3,
	movq	%rbx, %rdi	# rt6,
	call	falcon_poly_invnorm2_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6741: 	falcon_poly_mul_autoadj_fft(rt5, rt6, logn);
	movl	%r15d, %edx	# logn,
	movq	%rbx, %rsi	# rt6,
	movq	%rbp, %rdi	# rt5,
	call	falcon_poly_mul_autoadj_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6746: 	falcon_iFFT(rt5, logn);
	movl	%r15d, %esi	# logn,
	movq	%rbp, %rdi	# rt5,
	call	falcon_iFFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6747: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387904, %r15	#, tmp577
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	$1085, %r13d	#, tmp579
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	$1021, %r12d	#, tmp581
	movq	%r14, 48(%rsp)	# _53, %sfp
	movq	104(%rsp), %r14	# %sfp, n
.L571:
# inputs/bootstrap/source/falcon-keygen.c:6748: 		rt5[u] = fpr_of(fpr_rint(rt5[u]));
	movq	0(%rbp,%rbx,8), %rdx	# MEM[(fpr *)rt5_163 + u_564 * 8], _61
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdx, %rcx	# _61, _391
	salq	$10, %rcx	#, _391
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp894
	andq	%rax, %rcx	# tmp894, _392
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r15, %rcx	# tmp577, m
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rdx, %rsi	# _61, _394
	shrq	$52, %rsi	#, _394
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %esi	#, _396
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%r13d, %r8d	# tmp579, e
	subl	%esi, %r8d	# _396, e
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r12d, %eax	# tmp581, _398
	subl	%esi, %eax	# _396, _398
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _400
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _400, _401
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp584
	andq	%rcx, %rax	# m, m
# inputs/bootstrap/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r8d, %r10d	# e, e
	andl	$63, %r10d	#, e
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	$63, %ecx	#, tmp585
	subl	%r10d, %ecx	# e, _404
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdi	# m, _405
	salq	$32, %rdi	#, _405
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _404
	cmove	%rax, %rdi	# _405,, m, x_411
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _412
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdi	# _412, _413
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdi, %r9	# _413, _415
	shrq	$32, %r9	#, _415
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r9d	#, _417
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edi, %r9d	# _413, dd
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rsi	# m, _425
	shrq	$32, %rsi	#, _425
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r10d	#, tmp709
	cmove	%rax, %rsi	# _425,, m, x_431
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r8d, %ecx	# e, e
	andl	$31, %ecx	#, e
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rsi	# _432, _433
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r9d, %ecx	# dd, _421
	negl	%ecx	# _421
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r9d, %ecx	# dd, _422
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _423
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdi	#, _419
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edi, %ecx	# _419, f_424
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %eax	#, tmp604
	shrl	%cl, %eax	# f_424, tmp604
	movl	%eax, %edi	# tmp604, _434
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %edi	#, _436
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%rsi, %rdi	# _433, m_437
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rdx, %rax	# _61, _440
	sarq	$63, %rax	#, _440
	xorq	%rax, %rdi	# _440, _442
# inputs/bootstrap/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rdx	#, _438
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rdx, %rdi	# _438, _444
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6748: 		rt5[u] = fpr_of(fpr_rint(rt5[u]));
	movq	%rax, 0(%rbp,%rbx,8)	# tmp707, MEM[(fpr *)rt5_163 + u_564 * 8]
# inputs/bootstrap/source/falcon-keygen.c:6747: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-keygen.c:6747: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r14	# u, n
	jne	.L571	#,
# inputs/bootstrap/source/falcon-keygen.c:6750: 	falcon_FFT(rt5, logn);
	movq	48(%rsp), %r14	# %sfp, _53
	movl	68(%rsp), %ebx	# %sfp, logn
	movl	%ebx, %esi	# logn,
	movq	%rbp, %rdi	# rt5,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6755: 	falcon_poly_mul_fft(rt3, rt5, logn);
	movl	%ebx, %edx	# logn,
	movq	%rbp, %rsi	# rt5,
	movq	32(%rsp), %r15	# %sfp, rt3
	movq	%r15, %rdi	# rt3,
	call	falcon_poly_mul_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6756: 	falcon_poly_mul_fft(rt4, rt5, logn);
	movl	%ebx, %edx	# logn,
	movq	%rbp, %rsi	# rt5,
	movq	40(%rsp), %rbp	# %sfp, rt4
	movq	%rbp, %rdi	# rt4,
	call	falcon_poly_mul_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6757: 	falcon_poly_sub_fft(rt1, rt3, logn);
	movl	%ebx, %edx	# logn,
	movq	%r15, %rsi	# rt3,
	movq	8(%rsp), %r15	# %sfp, rt1
	movq	%r15, %rdi	# rt1,
	call	falcon_poly_sub@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6758: 	falcon_poly_sub_fft(rt2, rt4, logn);
	movl	%ebx, %edx	# logn,
	movq	%rbp, %rsi	# rt4,
	movq	16(%rsp), %rbp	# %sfp, rt2
	movq	%rbp, %rdi	# rt2,
	call	falcon_poly_sub@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6759: 	falcon_iFFT(rt1, logn);
	movl	%ebx, %esi	# logn,
	movq	%r15, %rdi	# rt1,
	call	falcon_iFFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6760: 	falcon_iFFT(rt2, logn);
	movl	%ebx, %esi	# logn,
	movq	%rbp, %rdi	# rt2,
	call	falcon_iFFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6765: 	Ft = fk->tmp;
	movq	120(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %rax	# fk_111(D)->tmp, Ft
	movq	%rax, 8(%rsp)	# Ft, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6766: 	Gt = Ft + n;
	movq	160(%rsp), %rdi	# %sfp, _9
	leaq	(%rax,%rdi), %rbx	#, Gt
	movq	%rbx, 16(%rsp)	# Gt, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6767: 	rt3 = align_fpr(fk->tmp, Gt + n);
	leaq	(%rbx,%rdi), %rsi	#, _63
# inputs/bootstrap/source/falcon-keygen.c:6767: 	rt3 = align_fpr(fk->tmp, Gt + n);
	movq	%rax, %rdi	# Ft,
	call	align_fpr	#
	movq	%rax, %rbx	# tmp708, rt3
# inputs/bootstrap/source/falcon-keygen.c:6768: 	memmove(rt3, rt1, 2 * n * sizeof *rt1);
	movq	24(%rsp), %rdx	# %sfp,
	movq	%r15, %rsi	# rt1,
	movq	%rax, %rdi	# rt3,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6771: 	for (u = 0; u < n; u ++) {
	movl	$0, %esi	#, u
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387904, %r12	#, tmp616
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	$1085, %ebp	#, tmp618
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	$1021, %r11d	#, tmp620
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	$63, %r10d	#, tmp624
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %r9d	#, tmp643
# inputs/bootstrap/source/falcon-keygen.c:6773: 		Gt[u] = (uint32_t)fpr_rint(rt2[u]);
	leaq	(%rbx,%r14), %r13	#, _376
.L572:
# inputs/bootstrap/source/falcon-keygen.c:6772: 		Ft[u] = (uint32_t)fpr_rint(rt1[u]);
	movq	(%rbx,%rsi,8), %rdi	# MEM[(fpr *)rt3_179 + u_565 * 8], _66
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdi, %rdx	# _66, _499
	salq	$10, %rdx	#, _499
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp914
	andq	%rax, %rdx	# tmp914, _500
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r12, %rdx	# tmp616, m
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rdi, %rcx	# _66, _502
	shrq	$52, %rcx	#, _502
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %ecx	#, _504
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%ebp, %r14d	# tmp618, e
	subl	%ecx, %r14d	# _504, e
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r11d, %r8d	# tmp620, _506
	subl	%ecx, %r8d	# _504, _506
	movl	%r8d, %eax	# _506, _506
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _508
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _508, _509
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp623
	andq	%rdx, %rax	# m, m
# inputs/bootstrap/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r14d, %r15d	# e, e
	andl	$63, %r15d	#, e
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	%r10d, %ecx	# tmp624, _512
	subl	%r15d, %ecx	# e, _512
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdx	# m, _513
	salq	$32, %rdx	#, _513
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _512
	cmove	%rax, %rdx	# _513,, m, x_519
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _520
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdx	# _520, _521
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdx, %r8	# _521, _523
	shrq	$32, %r8	#, _523
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r8d	#, _525
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edx, %r8d	# _521, dd
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _533
	shrq	$32, %rcx	#, _533
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r15d	#, tmp710
	cmovne	%rcx, %rax	# _533,, x_539
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r14d, %ecx	# e, e
	andl	$31, %ecx	#, e
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rax	# _540, _541
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r8d, %ecx	# dd, _529
	negl	%ecx	# _529
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r8d, %ecx	# dd, _530
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _531
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdx	#, _527
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edx, %ecx	# _527, f_532
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	%r9d, %edx	# tmp643, _542
	shrl	%cl, %edx	# f_532, _542
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %edx	#, _544
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%rdx, %rax	# _544, m_545
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rdi, %rdx	# _66, _548
	sarq	$63, %rdx	#, _548
	xorq	%rdx, %rax	# _548, _550
# inputs/bootstrap/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rdi	#, _546
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rax, %rdi	# _550, _552
# inputs/bootstrap/source/falcon-keygen.c:6772: 		Ft[u] = (uint32_t)fpr_rint(rt1[u]);
	movq	8(%rsp), %rdx	# %sfp, Ft
	movl	%edi, (%rdx,%rsi,4)	# _552, MEM[(uint32_t *)Ft_176 + u_565 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6773: 		Gt[u] = (uint32_t)fpr_rint(rt2[u]);
	movq	0(%r13,%rsi,8), %rdi	# MEM[(fpr *)_376 + u_565 * 8], _72
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdi, %rdx	# _72, _445
	salq	$10, %rdx	#, _445
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp929
	andq	%rax, %rdx	# tmp929, _446
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r12, %rdx	# tmp616, m
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rdi, %rcx	# _72, _448
	shrq	$52, %rcx	#, _448
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %ecx	#, _450
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%ebp, %r14d	# tmp618, e
	subl	%ecx, %r14d	# _450, e
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r11d, %eax	# tmp620, _452
	subl	%ecx, %eax	# _450, _452
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _454
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _454, _455
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp662
	andq	%rdx, %rax	# m, m
# inputs/bootstrap/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r14d, %r15d	# e, e
	andl	$63, %r15d	#, e
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	%r10d, %ecx	# tmp624, _458
	subl	%r15d, %ecx	# e, _458
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdx	# m, _459
	salq	$32, %rdx	#, _459
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _458
	cmove	%rax, %rdx	# _459,, m, x_465
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _466
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdx	# _466, _467
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdx, %r8	# _467, _469
	shrq	$32, %r8	#, _469
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r8d	#, _471
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edx, %r8d	# _467, dd
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _479
	shrq	$32, %rcx	#, _479
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r15d	#, tmp711
	cmovne	%rcx, %rax	# _479,, x_485
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r14d, %ecx	# e, e
	andl	$31, %ecx	#, e
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rax	# _486, _487
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r8d, %ecx	# dd, _475
	negl	%ecx	# _475
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r8d, %ecx	# dd, _476
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _477
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdx	#, _473
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edx, %ecx	# _473, f_478
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	%r9d, %edx	# tmp643, _488
	shrl	%cl, %edx	# f_478, _488
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %edx	#, _490
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%rdx, %rax	# _490, m_491
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rdi, %rdx	# _72, _494
	sarq	$63, %rdx	#, _494
	xorq	%rdx, %rax	# _494, _496
# inputs/bootstrap/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rdi	#, _492
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rax, %rdi	# _496, _498
# inputs/bootstrap/source/falcon-keygen.c:6773: 		Gt[u] = (uint32_t)fpr_rint(rt2[u]);
	movq	16(%rsp), %rax	# %sfp, Gt
	movl	%edi, (%rax,%rsi,4)	# _498, MEM[(uint32_t *)Gt_177 + u_565 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6771: 	for (u = 0; u < n; u ++) {
	addq	$1, %rsi	#, u
# inputs/bootstrap/source/falcon-keygen.c:6771: 	for (u = 0; u < n; u ++) {
	cmpq	%rsi, 104(%rsp)	# u, %sfp
	jne	.L572	#,
# inputs/bootstrap/source/falcon-keygen.c:6776: 	return 1;
	movl	$1, %eax	#, <retval>
	jmp	.L558	#
.L575:
# inputs/bootstrap/source/falcon-keygen.c:6673: 		return 0;
	movl	$0, %eax	#, <retval>
.L558:
# inputs/bootstrap/source/falcon-keygen.c:6777: }
	addq	$232, %rsp	#,
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
.L564:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:6570: 		modp_NTT2(Fp, gm, logn - 1, p, p0i);
	movl	136(%rsp), %eax	# %sfp, logn_top
	subl	$2, %eax	#, _107
	movl	56(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	%eax, 8(%rsp)	# _107, %sfp
	movl	%eax, %ecx	# _107,
	movq	72(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	24(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6571: 		modp_NTT2(Gp, gm, logn - 1, p, p0i);
	movl	56(%rsp), %r9d	# %sfp,
	movl	%ebx, %r8d	# p,
	movl	8(%rsp), %ecx	# %sfp,
	movq	72(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	32(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
	jmp	.L573	#
.L563:
# inputs/bootstrap/source/falcon-keygen.c:6540: 			modp_poly_rec_res(fx, e, p, p0i, R2);
	movl	8(%rsp), %r8d	# %sfp,
	movl	56(%rsp), %r12d	# %sfp, p0i
	movl	%r12d, %ecx	# p0i,
	movl	%ebx, %edx	# p,
	movl	136(%rsp), %ebp	# %sfp, logn_top
	movl	%ebp, %esi	# logn_top,
	movq	%r15, %rdi	# fx,
	call	modp_poly_rec_res	#
# inputs/bootstrap/source/falcon-keygen.c:6541: 			modp_poly_rec_res(gx, e, p, p0i, R2);
	movl	8(%rsp), %r8d	# %sfp,
	movl	%r12d, %ecx	# p0i,
	movl	%ebx, %edx	# p,
	movl	%ebp, %esi	# logn_top,
	movq	%r13, %rdi	# gx,
	call	modp_poly_rec_res	#
	jmp	.L574	#
	.cfi_endproc
.LFE102:
	.size	solve_NTRU_binary_depth1, .-solve_NTRU_binary_depth1
	.type	solve_NTRU_intermediate, @function
solve_NTRU_intermediate:
.LFB101:
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
	subq	$312, %rsp	#,
	.cfi_def_cfa_offset 368
	movq	%rdi, %rbx	# tmp1181, fk
	movq	%rdi, 72(%rsp)	# fk, %sfp
	movl	%ecx, %edi	# tmp1184, depth
	movl	%ecx, 228(%rsp)	# depth, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5821: 	logn_top = fk->logn;
	movl	(%rbx), %eax	# fk_222(D)->logn, logn_top
# inputs/bootstrap/source/falcon-keygen.c:5822: 	logn = logn_top - depth;
	movl	%eax, %ecx	# logn_top, logn
	subl	%edi, %ecx	# depth, logn
	movl	%ecx, 60(%rsp)	# logn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5828: 	if (fk->ternary && depth == 0) {
	movl	4(%rbx), %r8d	# fk_222(D)->ternary, _1
# inputs/bootstrap/source/falcon-keygen.c:5828: 	if (fk->ternary && depth == 0) {
	testl	%r8d, %r8d	# _1
	je	.L587	#,
	testl	%edi, %edi	# depth
	je	.L686	#,
.L587:
# inputs/bootstrap/source/falcon-keygen.c:5834: 		n = (size_t)1 << logn;
	movl	$1, %edi	#, tmp809
	movzbl	60(%rsp), %ecx	# %sfp, tmp1331
	salq	%cl, %rdi	# tmp1331, tmp809
	movq	%rdi, 64(%rsp)	# n, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5835: 		hn = n >> 1;
	shrq	%rdi	# hn
	movq	%rdi, 40(%rsp)	# hn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5850: 	if (fk->ternary) {
	testl	%r8d, %r8d	# _1
	jne	.L687	#,
# inputs/bootstrap/source/falcon-keygen.c:5856: 		slen = MAX_BL_SMALL2[depth];
	leaq	MAX_BL_SMALL2(%rip), %rdi	#, tmp817
	movl	228(%rsp), %ebx	# %sfp, depth
	movl	%ebx, %ecx	# depth, depth
	movq	(%rdi,%rcx,8), %r11	# MAX_BL_SMALL2[depth_224(D)], slen
	movq	%r11, 48(%rsp)	# slen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5857: 		dlen = MAX_BL_SMALL2[depth + 1];
	leal	1(%rbx), %r9d	#, _4
	movq	(%rdi,%r9,8), %rbx	# MAX_BL_SMALL2[_4], dlen
	movq	%rbx, 32(%rsp)	# dlen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5858: 		llen = MAX_BL_LARGE2[depth];
	leaq	MAX_BL_LARGE2(%rip), %rdi	#, tmp822
	movq	(%rdi,%rcx,8), %rbx	# MAX_BL_LARGE2[depth_224(D)], llen
	movq	%rbx, (%rsp)	# llen, %sfp
	movl	%r8d, 224(%rsp)	# _1, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5859: 		primes = PRIMES2;
	leaq	PRIMES2(%rip), %rbx	#, primes
	movq	%rbx, 296(%rsp)	# primes, %sfp
	jmp	.L590	#
.L686:
# inputs/bootstrap/source/falcon-keygen.c:5830: 		n = (size_t)3 << (logn - 1);
	subl	$1, %ecx	#, _2
# inputs/bootstrap/source/falcon-keygen.c:5830: 		n = (size_t)3 << (logn - 1);
	movl	$3, %edi	#, tmp807
	salq	%cl, %rdi	# _2, tmp807
	movq	%rdi, 64(%rsp)	# tmp807, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5831: 		hn = (size_t)1 << (logn - 1);
	movl	$1, %edi	#, tmp808
	salq	%cl, %rdi	# _2, tmp808
	movq	%rdi, 40(%rsp)	# tmp808, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5829: 		full = 1;
	movl	$1, 224(%rsp)	#, %sfp
.L588:
# inputs/bootstrap/source/falcon-keygen.c:5851: 		slen = MAX_BL_SMALL3[depth];
	leaq	MAX_BL_SMALL3(%rip), %rdi	#, tmp810
	movl	228(%rsp), %ebx	# %sfp, depth
	movl	%ebx, %ecx	# depth, depth
	movq	(%rdi,%rcx,8), %r11	# MAX_BL_SMALL3[depth_224(D)], slen
	movq	%r11, 48(%rsp)	# slen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5852: 		dlen = MAX_BL_SMALL3[depth + 1];
	leal	1(%rbx), %r9d	#, _3
	movq	(%rdi,%r9,8), %rbx	# MAX_BL_SMALL3[_3], dlen
	movq	%rbx, 32(%rsp)	# dlen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5853: 		llen = MAX_BL_LARGE3[depth];
	leaq	MAX_BL_LARGE3(%rip), %rdi	#, tmp815
	movq	(%rdi,%rcx,8), %rbx	# MAX_BL_LARGE3[depth_224(D)], llen
	movq	%rbx, (%rsp)	# llen, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5854: 		primes = PRIMES3;
	leaq	PRIMES3(%rip), %rbx	#, primes
	movq	%rbx, 296(%rsp)	# primes, %sfp
.L590:
# inputs/bootstrap/source/falcon-keygen.c:5865: 	Fd = fk->tmp;
	movq	72(%rsp), %r15	# %sfp, fk
	movq	432(%r15), %r14	# fk_222(D)->tmp, Fd
	movq	32(%rsp), %r13	# %sfp, _719
	movq	40(%rsp), %rdi	# %sfp, hn
	imulq	%rdi, %r13	# hn, _719
	leaq	0(,%r13,8), %rbp	#, _717
# inputs/bootstrap/source/falcon-keygen.c:5872: 	ft = Gd + dlen * hn;
	leaq	(%r14,%rbp), %r12	#, ft
# inputs/bootstrap/source/falcon-keygen.c:5873: 	make_fg(ft, f, g, logn_top, fk->ternary, depth, 1);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 376
	pushq	$1	#
	.cfi_def_cfa_offset 384
	movl	244(%rsp), %r9d	# %sfp,
	movl	%eax, %ecx	# logn_top,
	movq	%r12, %rdi	# ft,
	call	make_fg	#
# inputs/bootstrap/source/falcon-keygen.c:5879: 	Ft = fk->tmp;
	movq	432(%r15), %r15	# fk_222(D)->tmp, Ft
	movq	%r15, 152(%rsp)	# Ft, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5880: 	Gt = Ft + n * llen;
	movq	16(%rsp), %rax	# %sfp, _8
	movq	80(%rsp), %rdx	# %sfp, n
	imulq	%rdx, %rax	# n, _8
# inputs/bootstrap/source/falcon-keygen.c:5880: 	Gt = Ft + n * llen;
	salq	$2, %rax	#, _9
# inputs/bootstrap/source/falcon-keygen.c:5880: 	Gt = Ft + n * llen;
	leaq	(%r15,%rax), %rsi	#, Gt
# inputs/bootstrap/source/falcon-keygen.c:5881: 	t1 = Gt + n * llen;
	movq	%rsi, 136(%rsp)	# Gt, %sfp
	leaq	(%rsi,%rax), %rdi	#, t1
	movq	%rdi, 184(%rsp)	# t1, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5882: 	memmove(t1, ft, 2 * n * slen * sizeof *ft);
	movq	64(%rsp), %rbx	# %sfp, _10
	imulq	%rdx, %rbx	# n, _10
# inputs/bootstrap/source/falcon-keygen.c:5882: 	memmove(t1, ft, 2 * n * slen * sizeof *ft);
	leaq	0(,%rbx,8), %rdx	#, _11
	movq	%r12, %rsi	# ft,
	movq	%rdi, %r12	# t1, t1
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5884: 	gt = ft + slen * n;
	salq	$2, %rbx	#, _12
# inputs/bootstrap/source/falcon-keygen.c:5884: 	gt = ft + slen * n;
	leaq	(%r12,%rbx), %rdi	#, gt
	movq	%rdi, 192(%rsp)	# gt, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5885: 	t1 = gt + slen * n;
	addq	%rbx, %rdi	# _12, t1
	movq	%rdi, 144(%rsp)	# t1, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5890: 	memmove(t1, Fd, 2 * hn * dlen * sizeof *Fd);
	movq	%rbp, %rdx	# _717,
	movq	%r14, %rsi	# Fd,
	movq	%rdi, %r14	# t1, t1
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5892: 	Gd = Fd + hn * dlen;
	leaq	(%r14,%r13,4), %rdi	#, Gd
# inputs/bootstrap/source/falcon-keygen.c:5898: 	for (u = 0; u < llen; u ++) {
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 368
	movq	(%rsp), %rax	# %sfp, llen
	testq	%rax, %rax	# llen
	je	.L591	#,
# inputs/bootstrap/source/falcon-keygen.c:5909: 			v ++, xs += dlen, ys += dlen, xd += llen, yd += llen)
	movq	32(%rsp), %rbx	# %sfp, dlen
	leaq	0(,%rbx,4), %rdx	#, _20
	movq	%rdx, 80(%rsp)	# _20, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5909: 			v ++, xs += dlen, ys += dlen, xd += llen, yd += llen)
	leaq	0(,%rax,4), %rdx	#, _21
	movq	%rdx, 216(%rsp)	# _21, %sfp
	movq	296(%rsp), %rcx	# %sfp, primes
	movq	%rcx, 96(%rsp)	# primes, %sfp
	movq	%r15, 208(%rsp)	# Ft, %sfp
	movq	120(%rsp), %rax	# %sfp, Gt
	movq	%rax, 200(%rsp)	# Gt, %sfp
	leaq	(%rdx,%r15), %rsi	#, _1037
	movq	%rsi, 144(%rsp)	# _1037, %sfp
	movq	%rax, 104(%rsp)	# Gt, %sfp
	movq	%r15, 88(%rsp)	# Ft, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2617: 	x --;
	movl	%ebx, %eax	# dlen, tmp1377
	subl	$1, %eax	#, x
	movl	%eax, 112(%rsp)	# x, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movq	%rdi, 152(%rsp)	# Gd, %sfp
	jmp	.L597	#
.L687:
	movl	$0, 224(%rsp)	#, %sfp
	jmp	.L588	#
	.p2align 6
.L593:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %edi	# r, _745
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %rdi	# _745, powmult_908
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rsi, %rax	# _731, _748
	imulq	%rdi, %rax	# powmult_908, _748
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _749
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rdx, %rax	# _734, w_751
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# powmult_908, _752
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _753
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %edi	# d, _757
	sarl	$31, %edi	#, _757
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %edi	# p, _759
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edi, %eax	# _759, r
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	addl	$1, %ecx	#, i
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	$1, %edi	#, _762
	sall	%cl, %edi	# i, _762
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	cmpl	%edi, %r8d	# _762, x
	jb	.L592	#,
.L594:
# inputs/bootstrap/source/falcon-keygen.c:2621: 		if ((x & (1U << i)) != 0) {
	btl	%ecx, %r8d	# i, x
	jnc	.L593	#,
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r9d, %r9d	# z, _727
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %edi	# r, _729
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %r9	# _729, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rsi, %rdi	# _731, _732
	imulq	%r9, %rdi	# z, _732
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edi	#, _733
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rdx, %rdi	# _734, w_735
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rdi	# z, _736
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdi	#, _737
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%ebx, %edi	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edi, %r9d	# d, _741
	sarl	$31, %r9d	#, _741
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%ebx, %r9d	# p, _743
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edi, %r9d	# d, z
	jmp	.L593	#
.L592:
# inputs/bootstrap/source/falcon-keygen.c:5907: 		for (v = 0, xs = Fd, ys = Gd, xd = Ft + u, yd = Gt + u;
	movq	88(%rsp), %rbp	# %sfp, xd
# inputs/bootstrap/source/falcon-keygen.c:5907: 		for (v = 0, xs = Fd, ys = Gd, xd = Ft + u, yd = Gt + u;
	movq	104(%rsp), %r12	# %sfp, yd
# inputs/bootstrap/source/falcon-keygen.c:5908: 			v < hn;
	cmpq	$0, 40(%rsp)	#, %sfp
	je	.L595	#,
# inputs/bootstrap/source/falcon-keygen.c:5907: 		for (v = 0, xs = Fd, ys = Gd, xd = Ft + u, yd = Gt + u;
	movq	152(%rsp), %r15	# %sfp, ys
# inputs/bootstrap/source/falcon-keygen.c:5907: 		for (v = 0, xs = Fd, ys = Gd, xd = Ft + u, yd = Gt + u;
	movq	128(%rsp), %r14	# %sfp, xs
# inputs/bootstrap/source/falcon-keygen.c:5907: 		for (v = 0, xs = Fd, ys = Gd, xd = Ft + u, yd = Gt + u;
	movl	$0, %r13d	#, v
	movl	%ebx, 16(%rsp)	# p, %sfp
	movq	216(%rsp), %rbx	# %sfp, _21
	movl	%r9d, 24(%rsp)	# z, %sfp
.L596:
# inputs/bootstrap/source/falcon-keygen.c:5911: 			*xd = zint_mod_small_signed(xs, dlen, p, p0i, R2, Rx);
	movl	24(%rsp), %r9d	# %sfp,
	movl	56(%rsp), %r8d	# %sfp,
	movl	12(%rsp), %ecx	# %sfp,
	movl	16(%rsp), %edx	# %sfp,
	movq	32(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# xs,
	call	zint_mod_small_signed	#
# inputs/bootstrap/source/falcon-keygen.c:5911: 			*xd = zint_mod_small_signed(xs, dlen, p, p0i, R2, Rx);
	movl	%eax, 0(%rbp)	# tmp1187, MEM[(uint32_t *)xd_993]
# inputs/bootstrap/source/falcon-keygen.c:5912: 			*yd = zint_mod_small_signed(ys, dlen, p, p0i, R2, Rx);
	movl	24(%rsp), %r9d	# %sfp,
	movl	56(%rsp), %r8d	# %sfp,
	movl	12(%rsp), %ecx	# %sfp,
	movl	16(%rsp), %edx	# %sfp,
	movq	32(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# ys,
	call	zint_mod_small_signed	#
# inputs/bootstrap/source/falcon-keygen.c:5912: 			*yd = zint_mod_small_signed(ys, dlen, p, p0i, R2, Rx);
	movl	%eax, (%r12)	# tmp1188, MEM[(uint32_t *)yd_994]
# inputs/bootstrap/source/falcon-keygen.c:5909: 			v ++, xs += dlen, ys += dlen, xd += llen, yd += llen)
	addq	$1, %r13	#, v
# inputs/bootstrap/source/falcon-keygen.c:5909: 			v ++, xs += dlen, ys += dlen, xd += llen, yd += llen)
	movq	80(%rsp), %rax	# %sfp, _20
	addq	%rax, %r14	# _20, xs
# inputs/bootstrap/source/falcon-keygen.c:5909: 			v ++, xs += dlen, ys += dlen, xd += llen, yd += llen)
	addq	%rax, %r15	# _20, ys
# inputs/bootstrap/source/falcon-keygen.c:5909: 			v ++, xs += dlen, ys += dlen, xd += llen, yd += llen)
	addq	%rbx, %rbp	# _21, xd
# inputs/bootstrap/source/falcon-keygen.c:5909: 			v ++, xs += dlen, ys += dlen, xd += llen, yd += llen)
	addq	%rbx, %r12	# _21, yd
# inputs/bootstrap/source/falcon-keygen.c:5908: 			v < hn;
	movq	40(%rsp), %rax	# %sfp, hn
	cmpq	%rax, %r13	# hn, v
	jne	.L596	#,
.L595:
# inputs/bootstrap/source/falcon-keygen.c:5898: 	for (u = 0; u < llen; u ++) {
	addq	$12, 96(%rsp)	#, %sfp
	addq	$4, 88(%rsp)	#, %sfp
	movq	88(%rsp), %rax	# %sfp, ivtmp.1234
	addq	$4, 104(%rsp)	#, %sfp
	movq	144(%rsp), %rbx	# %sfp, _1037
	cmpq	%rbx, %rax	# _1037, ivtmp.1234
	je	.L688	#,
.L597:
# inputs/bootstrap/source/falcon-keygen.c:5903: 		p = primes[u].p;
	movq	96(%rsp), %rax	# %sfp, ivtmp.1233
	movl	(%rax), %ebx	# MEM[(unsigned int *)_1034], p
# inputs/bootstrap/source/falcon-keygen.c:5904: 		p0i = modp_ninv31(p);
	movl	%ebx, %edi	# p,
	call	modp_ninv31	#
	movl	%eax, %r15d	# tmp1185, p0i
	movl	%eax, 12(%rsp)	# p0i, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5905: 		R2 = modp_R2(p, p0i);
	movl	%eax, %esi	# p0i,
	movl	%ebx, %edi	# p,
	call	modp_R2	#
	movl	%eax, 56(%rsp)	# R2, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	movl	$-2147483648, %r9d	#, z
	subl	%ebx, %r9d	# p, z
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	112(%rsp), %r8d	# %sfp, x
	testl	%r8d, %r8d	# x
	je	.L592	#,
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	$0, %ecx	#, i
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r15d, %esi	# p0i, _731
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%ebx, %edx	# p, _734
	jmp	.L594	#
.L688:
# inputs/bootstrap/source/falcon-keygen.c:5950: 			igm = gm + n;
	movq	64(%rsp), %rax	# %sfp, n
	leaq	0(,%rax,4), %r11	#, _25
# inputs/bootstrap/source/falcon-keygen.c:5950: 			igm = gm + n;
	movq	128(%rsp), %rbx	# %sfp, t1
	leaq	(%rbx,%r11), %rax	#, igm
	movq	%rax, 264(%rsp)	# igm, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5951: 			fx = igm + n;
	addq	%r11, %rax	# _25, fx
	movq	%rax, 272(%rsp)	# fx, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5987: 				v < n; v ++, x += slen, y += slen)
	movq	48(%rsp), %rax	# %sfp, slen
	salq	$2, %rax	#, _44
	movq	%rax, 240(%rsp)	# _44, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6009: 		Gp = Fp + hn;
	movq	40(%rsp), %rax	# %sfp, hn
	salq	$2, %rax	#, _46
	movq	%rax, 232(%rsp)	# _46, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6094: 				v ++, x += (llen << 1), y += (llen << 1))
	movq	(%rsp), %rax	# %sfp, llen
	leaq	0(,%rax,8), %rsi	#, _94
	movq	%rsi, 144(%rsp)	# _94, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6060: 				v += 3, v2 ++, x += 3 * llen, y += 3 * llen)
	leaq	(%rax,%rax,2), %rax	#, _79
	salq	$2, %rax	#, tmp854
	movq	%rax, 152(%rsp)	# tmp854, %sfp
	movq	296(%rsp), %rax	# %sfp, primes
	addq	$4, %rax	#, ivtmp.1211
	movq	%rax, 192(%rsp)	# ivtmp.1211, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5923: 	for (u = 0; u < llen; u ++) {
	movq	$0, 104(%rsp)	#, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5946: 			igm = gm + ((size_t)1 << logn);
	movl	$4, %eax	#, tmp1174
	movzbl	60(%rsp), %ecx	# %sfp, tmp1411
	salq	%cl, %rax	# tmp1411, _24
# inputs/bootstrap/source/falcon-keygen.c:5946: 			igm = gm + ((size_t)1 << logn);
	addq	%rax, %rbx	# _24, igm
	movq	%rbx, 280(%rsp)	# igm, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5947: 			fx = igm + ((size_t)1 << logn);
	addq	%rbx, %rax	# igm, fx
	movq	%rax, 288(%rsp)	# fx, %sfp
	movq	%r11, 184(%rsp)	# _25, %sfp
	jmp	.L623	#
.L689:
# inputs/bootstrap/source/falcon-keygen.c:5940: 			zint_rebuild_CRT(ft, slen, slen, n, primes, 1, t1);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 376
	movq	136(%rsp), %r13	# %sfp, t1
	pushq	%r13	# t1
	.cfi_def_cfa_offset 384
	movl	$1, %r9d	#,
	movq	312(%rsp), %r12	# %sfp, primes
	movq	%r12, %r8	# primes,
	movq	80(%rsp), %rbp	# %sfp, n
	movq	%rbp, %rcx	# n,
	movq	64(%rsp), %r15	# %sfp, slen
	movq	%r15, %rdx	# slen,
	movq	%r15, %rsi	# slen,
	movq	184(%rsp), %rdi	# %sfp,
	call	zint_rebuild_CRT	#
# inputs/bootstrap/source/falcon-keygen.c:5941: 			zint_rebuild_CRT(gt, slen, slen, n, primes, 1, t1);
	movq	%r13, (%rsp)	# t1,
	movl	$1, %r9d	#,
	movq	%r12, %r8	# primes,
	movq	%rbp, %rcx	# n,
	movq	%r15, %rdx	# slen,
	movq	%r15, %rsi	# slen,
	movq	192(%rsp), %rdi	# %sfp,
	call	zint_rebuild_CRT	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 368
	jmp	.L598	#
.L651:
# inputs/bootstrap/source/falcon-keygen.c:5951: 			fx = igm + n;
	movq	272(%rsp), %rax	# %sfp, fx
	movq	%rax, 32(%rsp)	# fx, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5950: 			igm = gm + n;
	movq	264(%rsp), %rax	# %sfp, igm
	movq	%rax, 160(%rsp)	# igm, %sfp
	jmp	.L599	#
.L600:
# inputs/bootstrap/source/falcon-keygen.c:5958: 			modp_mkgm2(gm, igm, logn, primes[u].g, p, p0i);
	movl	(%rbx), %ecx	# MEM[(unsigned int *)_937], MEM[(unsigned int *)_937]
	movl	12(%rsp), %r9d	# %sfp,
	movl	%r14d, %r8d	# p,
	movl	60(%rsp), %edx	# %sfp,
	movq	160(%rsp), %rsi	# %sfp,
	movq	128(%rsp), %rdi	# %sfp,
	call	modp_mkgm2	#
	jmp	.L601	#
.L605:
# inputs/bootstrap/source/falcon-keygen.c:5976: 				modp_iNTT2_ext(ft + u, slen, igm,
	movl	12(%rsp), %r9d	# %sfp,
	movl	%r14d, %r8d	# p,
	movl	60(%rsp), %r13d	# %sfp, logn
	movl	%r13d, %ecx	# logn,
	movq	160(%rsp), %r12	# %sfp, igm
	movq	%r12, %rdx	# igm,
	movq	48(%rsp), %rbp	# %sfp, slen
	movq	%rbp, %rsi	# slen,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5978: 				modp_iNTT2_ext(gt + u, slen, igm,
	movl	12(%rsp), %r9d	# %sfp,
	movl	%r14d, %r8d	# p,
	movl	%r13d, %ecx	# logn,
	movq	%r12, %rdx	# igm,
	movq	%rbp, %rsi	# slen,
	movq	%rbx, %rdi	# y,
	call	modp_iNTT2_ext	#
	jmp	.L606	#
.L602:
# inputs/bootstrap/source/falcon-keygen.c:2523: 	return ((uint32_t)1 << 31) - p;
	movl	$-2147483648, %r9d	#, tmp858
	subl	%r14d, %r9d	# p, z
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	48(%rsp), %edx	# %sfp, x
	subl	$1, %edx	#, x
	je	.L607	#,
# inputs/bootstrap/source/falcon-keygen.c:2618: 	r = R2;
	movl	56(%rsp), %eax	# %sfp, r
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	$0, %ecx	#, i
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	12(%rsp), %edi	# %sfp, _774
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %esi	# p, _777
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	$1, %r8d	#, tmp880
	jmp	.L609	#
.L608:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %r10d	# r, _788
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r10, %r10	# _788, powmult_924
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdi, %rax	# _774, _791
	imulq	%r10, %rax	# powmult_924, _791
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _792
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %rax	# _777, w_794
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rax	# powmult_924, _795
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _796
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _800
	sarl	$31, %r10d	#, _800
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r10d	# p, _802
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r10d, %eax	# _802, r
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	addl	$1, %ecx	#, i
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	movl	%r8d, %r10d	# tmp880, _805
	sall	%cl, %r10d	# i, _805
# inputs/bootstrap/source/falcon-keygen.c:2620: 	for (i = 0; (1U << i) <= x; i ++) {
	cmpl	%r10d, %edx	# _805, x
	jb	.L607	#,
.L609:
# inputs/bootstrap/source/falcon-keygen.c:2621: 		if ((x & (1U << i)) != 0) {
	btl	%ecx, %edx	# i, x
	jnc	.L608	#,
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r9d, %r9d	# z, _770
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%eax, %r10d	# r, _772
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r10, %r9	# _772, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdi, %r10	# _774, _775
	imulq	%r9, %r10	# z, _775
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %r10d	#, _776
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rsi, %r10	# _777, w_778
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %r10	# z, _779
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %r10	#, _780
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %r10d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r10d, %r9d	# d, _784
	sarl	$31, %r9d	#, _784
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r9d	# p, _786
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r10d, %r9d	# d, z
	jmp	.L608	#
.L607:
# inputs/bootstrap/source/falcon-keygen.c:5987: 				v < n; v ++, x += slen, y += slen)
	cmpq	$0, 64(%rsp)	#, %sfp
	je	.L610	#,
	movq	32(%rsp), %rax	# %sfp, fx
	movq	%rax, %rbx	# fx, ivtmp.1197
	movq	%r15, %r13	# gx, ivtmp.1198
	movq	184(%rsp), %rsi	# %sfp, _25
	addq	%rsi, %rax	# _25, _955
	movq	%rax, 24(%rsp)	# _955, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5986: 			for (v = 0, x = ft, y = gt;
	movq	176(%rsp), %r12	# %sfp, y
# inputs/bootstrap/source/falcon-keygen.c:5986: 			for (v = 0, x = ft, y = gt;
	movq	168(%rsp), %rbp	# %sfp, x
	movq	%r15, 80(%rsp)	# gx, %sfp
	movq	240(%rsp), %r15	# %sfp, _44
	movl	%r9d, 16(%rsp)	# z, %sfp
.L611:
# inputs/bootstrap/source/falcon-keygen.c:5989: 				fx[v] = zint_mod_small_signed(x, slen,
	movl	16(%rsp), %r9d	# %sfp,
	movl	56(%rsp), %r8d	# %sfp,
	movl	12(%rsp), %ecx	# %sfp,
	movl	%r14d, %edx	# p,
	movq	48(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# x,
	call	zint_mod_small_signed	#
# inputs/bootstrap/source/falcon-keygen.c:5989: 				fx[v] = zint_mod_small_signed(x, slen,
	movl	%eax, (%rbx)	# tmp1191, MEM[(uint32_t *)_956]
# inputs/bootstrap/source/falcon-keygen.c:5991: 				gx[v] = zint_mod_small_signed(y, slen,
	movl	16(%rsp), %r9d	# %sfp,
	movl	56(%rsp), %r8d	# %sfp,
	movl	12(%rsp), %ecx	# %sfp,
	movl	%r14d, %edx	# p,
	movq	48(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# y,
	call	zint_mod_small_signed	#
# inputs/bootstrap/source/falcon-keygen.c:5991: 				gx[v] = zint_mod_small_signed(y, slen,
	movl	%eax, 0(%r13)	# tmp1192, MEM[(uint32_t *)_952]
# inputs/bootstrap/source/falcon-keygen.c:5987: 				v < n; v ++, x += slen, y += slen)
	addq	%r15, %rbp	# _44, x
# inputs/bootstrap/source/falcon-keygen.c:5987: 				v < n; v ++, x += slen, y += slen)
	addq	%r15, %r12	# _44, y
# inputs/bootstrap/source/falcon-keygen.c:5987: 				v < n; v ++, x += slen, y += slen)
	addq	$4, %rbx	#, ivtmp.1197
	addq	$4, %r13	#, ivtmp.1198
	cmpq	%rbx, 24(%rsp)	# ivtmp.1197, %sfp
	jne	.L611	#,
	movq	80(%rsp), %r15	# %sfp, gx
.L610:
# inputs/bootstrap/source/falcon-keygen.c:5994: 			if (fk->ternary) {
	movq	72(%rsp), %rax	# %sfp, fk
	cmpl	$0, 4(%rax)	#, fk_222(D)->ternary
	je	.L612	#,
# inputs/bootstrap/source/falcon-keygen.c:5995: 				modp_NTT3(fx, gm, logn, full, p, p0i);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 376
	movl	20(%rsp), %ebx	# %sfp, p0i
	pushq	%rbx	# p0i
	.cfi_def_cfa_offset 384
	movl	%r14d, %r9d	# p,
	movl	240(%rsp), %r13d	# %sfp, full
	movl	%r13d, %r8d	# full,
	movl	76(%rsp), %r12d	# %sfp, logn
	movl	%r12d, %ecx	# logn,
	movq	144(%rsp), %rbp	# %sfp, t1
	movq	%rbp, %rdx	# t1,
	movl	$1, %esi	#,
	movq	48(%rsp), %rdi	# %sfp,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5996: 				modp_NTT3(gx, gm, logn, full, p, p0i);
	movl	%ebx, (%rsp)	# p0i,
	movl	%r14d, %r9d	# p,
	movl	%r13d, %r8d	# full,
	movl	%r12d, %ecx	# logn,
	movq	%rbp, %rdx	# t1,
	movl	$1, %esi	#,
	movq	%r15, %rdi	# gx,
	call	modp_NTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 368
	jmp	.L606	#
.L612:
# inputs/bootstrap/source/falcon-keygen.c:5998: 				modp_NTT2(fx, gm, logn, p, p0i);
	movl	12(%rsp), %r12d	# %sfp, p0i
	movl	%r12d, %r9d	# p0i,
	movl	%r14d, %r8d	# p,
	movl	60(%rsp), %ebp	# %sfp, logn
	movl	%ebp, %ecx	# logn,
	movq	128(%rsp), %rbx	# %sfp, t1
	movq	%rbx, %rdx	# t1,
	movl	$1, %esi	#,
	movq	32(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5999: 				modp_NTT2(gx, gm, logn, p, p0i);
	movl	%r12d, %r9d	# p0i,
	movl	%r14d, %r8d	# p,
	movl	%ebp, %ecx	# logn,
	movq	%rbx, %rdx	# t1,
	movl	$1, %esi	#,
	movq	%r15, %rdi	# gx,
	call	modp_NTT2_ext	#
	jmp	.L606	#
.L615:
# inputs/bootstrap/source/falcon-keygen.c:6020: 			modp_NTT2(Fp, gm, logn - 1, p, p0i);
	movl	60(%rsp), %eax	# %sfp, logn
	leal	-1(%rax), %ebx	#, _56
	movl	12(%rsp), %r9d	# %sfp,
	movl	%r14d, %r8d	# p,
	movl	%ebx, %ecx	# _56,
	movq	128(%rsp), %r13	# %sfp, t1
	movq	%r13, %rdx	# t1,
	movl	$1, %esi	#,
	movq	16(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6021: 			modp_NTT2(Gp, gm, logn - 1, p, p0i);
	movl	12(%rsp), %r9d	# %sfp,
	movl	%r14d, %r8d	# p,
	movl	%ebx, %ecx	# _56,
	movq	%r13, %rdx	# t1,
	movl	$1, %esi	#,
	movq	24(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
	jmp	.L616	#
.L617:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	56(%rsp), %ecx	# %sfp, _307
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rcx	# _307, powmult_930
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	12(%rsp), %edx	# %sfp, _280
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %eax	# p, _261
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rsi	# _280, _278
	imulq	%rcx, %rsi	# powmult_930, _278
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %esi	#, _263
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rsi	# _261, w_259
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rsi, %rcx	# w_259, _257
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _252
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %esi	# d, _380
	sarl	$31, %esi	#, _380
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %esi	# p, _378
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ecx, %esi	# d, d
# inputs/bootstrap/source/falcon-keygen.c:6059: 			for (v = 0, v2 = 0, x = Ft + u, y = Gt + u; v < n;
	cmpq	$0, 64(%rsp)	#, %sfp
	je	.L619	#,
	movq	32(%rsp), %r10	# %sfp, fx
# inputs/bootstrap/source/falcon-keygen.c:6059: 			for (v = 0, v2 = 0, x = Ft + u, y = Gt + u; v < n;
	movq	%rbp, %rbx	# x, x
# inputs/bootstrap/source/falcon-keygen.c:6059: 			for (v = 0, v2 = 0, x = Ft + u, y = Gt + u; v < n;
	movl	$0, %r11d	#, v2
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%esi, %esi	# d, _614
	movq	%rsi, 112(%rsp)	# _614, %sfp
	movq	%r15, %r9	# ivtmp.1136, ivtmp.1136
	movq	%rbp, 248(%rsp)	# x, %sfp
	movq	%r12, 256(%rsp)	# y, %sfp
	movq	%r12, %rbp	# y, y
.L620:
# inputs/bootstrap/source/falcon-keygen.c:6065: 				ftA = fx[v + 0];
	movl	(%r10), %edi	# MEM[(uint32_t *)_179], ftA
	movl	%edi, 32(%rsp)	# ftA, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6066: 				ftB = fx[v + 1];
	movl	4(%r10), %esi	# MEM[(uint32_t *)_179 + 4B], ftB
	movl	%esi, 80(%rsp)	# ftB, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6067: 				ftC = fx[v + 2];
	movl	8(%r10), %r15d	# MEM[(uint32_t *)_179 + 8B], ftC
	movl	%r15d, 88(%rsp)	# ftC, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6068: 				gtA = gx[v + 0];
	movl	(%r9), %edi	# MEM[(uint32_t *)_963], gtA
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	16(%rsp), %r8	# %sfp, Fp
	movl	(%r8,%r11,4), %ecx	# MEM[(uint32_t *)Fp_366 + v2_1000 * 4], _613
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	112(%rsp), %r15	# %sfp, _614
	imulq	%r15, %rcx	# _614, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rsi	# _280, _616
	imulq	%rcx, %rsi	# z, _616
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %esi	#, _617
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rsi	# _261, w_618
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rcx, %rsi	# z, _619
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rsi	#, _620
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %esi	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%esi, %r13d	# d, _624
	sarl	$31, %r13d	#, _624
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r13d	# p, _626
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	24(%rsp), %r8	# %sfp, Gp
	movl	(%r8,%r11,4), %r8d	# MEM[(uint32_t *)Gp_367 + v2_1000 * 4], _599
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r15, %r8	# _614, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _601
	imulq	%r8, %rcx	# z, _601
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _602
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_603
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rcx	# z, _604
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _605
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	movl	%ecx, %r15d	# _605, d
	subl	%r14d, %r15d	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r15d, 56(%rsp)	# d, %sfp
	movl	%r15d, %r12d	# d, _609
	sarl	$31, %r12d	#, _609
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%r12d, %ecx	# _609, _609
	andl	%r14d, %ecx	# p, _609
	movl	%ecx, 96(%rsp)	# _609, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%r9), %r12d	# MEM[(uint32_t *)_963 + 4B], _584
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	8(%r9), %r8d	# MEM[(uint32_t *)_963 + 8B], _585
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	%r12, %rcx	# _584, z
	imulq	%r8, %rcx	# _585, z
	movq	%rcx, %r15	# z, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _587
	imulq	%r15, %rcx	# z, _587
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _588
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_589
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r15, %rcx	# z, _590
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _591
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %r15d	# d, _595
	sarl	$31, %r15d	#, _595
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r15d	# p, _597
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rsi,%r13), %esi	#, _569
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rcx,%r15), %r13d	#, _570
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rsi, %r13	# _569, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _572
	imulq	%r13, %rcx	# z, _572
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _573
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_574
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r13, %rcx	# z, _575
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _576
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %r13d	# d, _580
	sarl	$31, %r13d	#, _580
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r13d	# p, _582
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r13d, %ecx	# _582, tmp916
	movl	%ecx, (%rbx)	# tmp916, MEM[(uint32_t *)x_980]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%edi, %edi	# gtA, _555
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %r8	# _555, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _557
	imulq	%r8, %rcx	# z, _557
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _558
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_559
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rcx	# z, _560
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _561
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %r8d	# d, _565
	sarl	$31, %r8d	#, _565
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r8d	# p, _567
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rcx,%r8), %r8d	#, _541
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rsi, %r8	# _569, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _543
	imulq	%r8, %rcx	# z, _543
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _544
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_545
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rcx	# z, _546
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _547
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %r8d	# d, _551
	sarl	$31, %r8d	#, _551
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r8d	# p, _553
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r8d, %ecx	# _553, tmp931
	movq	(%rsp), %r13	# %sfp, llen
	movl	%ecx, (%rbx,%r13,4)	# tmp931, MEM[(uint32_t *)x_980 + llen_153 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r12, %rdi	# _584, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _529
	imulq	%rdi, %rcx	# z, _529
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _530
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_531
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rcx	# z, _532
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _533
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %edi	# d, _537
	sarl	$31, %edi	#, _537
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %edi	# p, _539
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rcx,%rdi), %ecx	#, _514
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rsi	# _514, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rdi	# _280, _516
	imulq	%rsi, %rdi	# z, _516
	movq	%rdi, %rcx	# _516, _516
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _517
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_518
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rsi, %rcx	# z, _519
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _520
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %esi	# d, _524
	sarl	$31, %esi	#, _524
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %esi	# p, _526
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%esi, %ecx	# _526, tmp946
	movl	%ecx, (%rbx,%r13,8)	# tmp946, MEM[(uint32_t *)x_980 + llen_153 * 8]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	80(%rsp), %edi	# %sfp, _499
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	88(%rsp), %esi	# %sfp, _500
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	%rdi, %r8	# _499, z
	imulq	%rsi, %r8	# _500, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _502
	imulq	%r8, %rcx	# z, _502
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _503
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_504
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rcx	# z, _505
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _506
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %r8d	# d, _510
	sarl	$31, %r8d	#, _510
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r8d	# p, _512
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	56(%rsp), %r15d	# %sfp, d
	movl	96(%rsp), %r12d	# %sfp, _611
	leal	(%r15,%r12), %r12d	#, _484
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rcx,%r8), %r8d	#, _485
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r12, %r8	# _484, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _487
	imulq	%r8, %rcx	# z, _487
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _488
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_489
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rcx	# z, _490
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _491
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %r8d	# d, _495
	sarl	$31, %r8d	#, _495
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r8d	# p, _497
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r8d, %ecx	# _497, tmp962
	movl	%ecx, 0(%rbp)	# tmp962, MEM[(uint32_t *)y_987]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	32(%rsp), %r8d	# %sfp, _470
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r8, %rsi	# _470, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _472
	imulq	%rsi, %rcx	# z, _472
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _473
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_474
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rsi, %rcx	# z, _475
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _476
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %esi	# d, _480
	sarl	$31, %esi	#, _480
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %esi	# p, _482
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rcx,%rsi), %esi	#, _456
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r12, %rsi	# _484, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _458
	imulq	%rsi, %rcx	# z, _458
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _459
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_460
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rsi, %rcx	# z, _461
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _462
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %esi	# d, _466
	sarl	$31, %esi	#, _466
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %esi	# p, _468
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%esi, %ecx	# _468, tmp977
	movl	%ecx, 0(%rbp,%r13,4)	# tmp977, MEM[(uint32_t *)y_987 + llen_153 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %r8	# _499, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _433
	imulq	%r8, %rcx	# z, _433
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _431
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_446
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rcx	# z, _447
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _448
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %esi	# d, _452
	sarl	$31, %esi	#, _452
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %esi	# p, _454
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rcx,%rsi), %esi	#, _411
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r12, %rsi	# _484, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rcx	# _280, _408
	imulq	%rsi, %rcx	# z, _408
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _406
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rcx	# _261, w_404
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rsi, %rcx	# z, _403
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _401
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %ecx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %esi	# d, _391
	sarl	$31, %esi	#, _391
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %esi	# p, _348
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ecx, %esi	# d, tmp992
	movl	%esi, 0(%rbp,%r13,8)	# tmp992, MEM[(uint32_t *)y_987 + llen_153 * 8]
# inputs/bootstrap/source/falcon-keygen.c:6060: 				v += 3, v2 ++, x += 3 * llen, y += 3 * llen)
	addq	$1, %r11	#, v2
# inputs/bootstrap/source/falcon-keygen.c:6060: 				v += 3, v2 ++, x += 3 * llen, y += 3 * llen)
	movq	152(%rsp), %rdi	# %sfp, tmp854
	addq	%rdi, %rbx	# tmp854, x
# inputs/bootstrap/source/falcon-keygen.c:6060: 				v += 3, v2 ++, x += 3 * llen, y += 3 * llen)
	addq	%rdi, %rbp	# tmp854, y
# inputs/bootstrap/source/falcon-keygen.c:6059: 			for (v = 0, v2 = 0, x = Ft + u, y = Gt + u; v < n;
	addq	$12, %r10	#, ivtmp.1135
	addq	$12, %r9	#, ivtmp.1136
	leaq	(%r11,%r11,2), %rcx	#, v_723
	movq	64(%rsp), %rdi	# %sfp, n
	cmpq	%rdi, %rcx	# n, v_723
	jb	.L620	#,
	movq	248(%rsp), %rbp	# %sfp, x
	movq	256(%rsp), %r12	# %sfp, y
.L619:
# inputs/bootstrap/source/falcon-keygen.c:6111: 		if (fk->ternary) {
	movq	72(%rsp), %rax	# %sfp, fk
	cmpl	$0, 4(%rax)	#, fk_222(D)->ternary
	je	.L621	#,
# inputs/bootstrap/source/falcon-keygen.c:6112: 			modp_iNTT3_ext(Ft + u, llen, igm, logn, full, p, p0i);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 376
	movl	20(%rsp), %ebx	# %sfp, p0i
	pushq	%rbx	# p0i
	.cfi_def_cfa_offset 384
	movl	%r14d, %r9d	# p,
	movl	240(%rsp), %r8d	# %sfp,
	movl	76(%rsp), %ecx	# %sfp,
	movq	176(%rsp), %r13	# %sfp, igm
	movq	%r13, %rdx	# igm,
	movq	16(%rsp), %r15	# %sfp, llen
	movq	%r15, %rsi	# llen,
	movq	%rbp, %rdi	# x,
	call	modp_iNTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6113: 			modp_iNTT3_ext(Gt + u, llen, igm, logn, full, p, p0i);
	movl	%ebx, (%rsp)	# p0i,
	movl	%r14d, %r9d	# p,
	movl	240(%rsp), %r8d	# %sfp,
	movl	76(%rsp), %ecx	# %sfp,
	movq	%r13, %rdx	# igm,
	movq	%r15, %rsi	# llen,
	movq	%r12, %rdi	# y,
	call	modp_iNTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 368
.L622:
# inputs/bootstrap/source/falcon-keygen.c:5923: 	for (u = 0; u < llen; u ++) {
	addq	$1, 104(%rsp)	#, %sfp
	movq	104(%rsp), %rax	# %sfp, u
# inputs/bootstrap/source/falcon-keygen.c:5923: 	for (u = 0; u < llen; u ++) {
	addq	$4, 208(%rsp)	#, %sfp
	addq	$4, 200(%rsp)	#, %sfp
	addq	$12, 192(%rsp)	#, %sfp
	cmpq	%rax, (%rsp)	# u, %sfp
	je	.L591	#,
.L623:
	movq	192(%rsp), %rax	# %sfp, ivtmp.1211
	movq	%rax, %rbx	# ivtmp.1211, _937
# inputs/bootstrap/source/falcon-keygen.c:5931: 		p = primes[u].p;
	movl	-4(%rax), %r14d	# MEM[(unsigned int *)_937 + -4B], p
# inputs/bootstrap/source/falcon-keygen.c:5932: 		p0i = modp_ninv31(p);
	movl	%r14d, %edi	# p,
	call	modp_ninv31	#
	movl	%eax, 12(%rsp)	# p0i, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5933: 		R2 = modp_R2(p, p0i);
	movl	%eax, %esi	# p0i,
	movl	%r14d, %edi	# p,
	call	modp_R2	#
	movl	%eax, 56(%rsp)	# tmp1190, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5939: 		if (u == slen) {
	movq	104(%rsp), %rsi	# %sfp, u
	cmpq	%rsi, 48(%rsp)	# u, %sfp
	je	.L689	#,
.L598:
# inputs/bootstrap/source/falcon-keygen.c:5945: 		if (full) {
	cmpl	$0, 224(%rsp)	#, %sfp
	je	.L651	#,
# inputs/bootstrap/source/falcon-keygen.c:5946: 			igm = gm + ((size_t)1 << logn);
	movq	280(%rsp), %rax	# %sfp, igm
	movq	%rax, 160(%rsp)	# igm, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5947: 			fx = igm + ((size_t)1 << logn);
	movq	288(%rsp), %rax	# %sfp, fx
	movq	%rax, 32(%rsp)	# fx, %sfp
.L599:
# inputs/bootstrap/source/falcon-keygen.c:5953: 		gx = fx + n;
	movq	32(%rsp), %rax	# %sfp, fx
	movq	184(%rsp), %rsi	# %sfp, _25
	leaq	(%rax,%rsi), %r15	#, gx
# inputs/bootstrap/source/falcon-keygen.c:5955: 		if (fk->ternary) {
	movq	72(%rsp), %rax	# %sfp, fk
	cmpl	$0, 4(%rax)	#, fk_222(D)->ternary
	je	.L600	#,
# inputs/bootstrap/source/falcon-keygen.c:5956: 			modp_mkgm3(gm, igm, logn, full, primes[u].g, p, p0i);
	movl	(%rbx), %r8d	# MEM[(unsigned int *)_937], MEM[(unsigned int *)_937]
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 376
	movl	20(%rsp), %eax	# %sfp, p0i
	pushq	%rax	# p0i
	.cfi_def_cfa_offset 384
	movl	%r14d, %r9d	# p,
	movl	240(%rsp), %ecx	# %sfp,
	movl	76(%rsp), %edx	# %sfp,
	movq	176(%rsp), %rsi	# %sfp,
	movq	144(%rsp), %rdi	# %sfp,
	call	modp_mkgm3	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 368
.L601:
# inputs/bootstrap/source/falcon-keygen.c:5961: 		if (u < slen) {
	movq	104(%rsp), %rax	# %sfp, u
	movq	48(%rsp), %rbx	# %sfp, slen
	cmpq	%rbx, %rax	# slen, u
	jnb	.L602	#,
	leaq	0(,%rax,4), %rbx	#, _931
# inputs/bootstrap/source/falcon-keygen.c:5964: 			for (v = 0, x = ft + u, y = gt + u;
	movq	168(%rsp), %rax	# %sfp, t1
	leaq	(%rax,%rbx), %rdi	#, x
# inputs/bootstrap/source/falcon-keygen.c:5964: 			for (v = 0, x = ft + u, y = gt + u;
	movq	176(%rsp), %rax	# %sfp, gt
	addq	%rax, %rbx	# gt, y
# inputs/bootstrap/source/falcon-keygen.c:5965: 				v < n; v ++, x += slen, y += slen)
	movq	64(%rsp), %r8	# %sfp, n
	testq	%r8, %r8	# n
	je	.L603	#,
	movl	$0, %edx	#, ivtmp.1182
# inputs/bootstrap/source/falcon-keygen.c:5964: 			for (v = 0, x = ft + u, y = gt + u;
	movl	$0, %eax	#, v
	movq	240(%rsp), %rsi	# %sfp, _44
	movq	32(%rsp), %r9	# %sfp, fx
	.p2align 5
.L604:
# inputs/bootstrap/source/falcon-keygen.c:5967: 				fx[v] = *x;
	movl	(%rdi,%rdx), %ecx	# MEM[(uint32_t *)x_355 + ivtmp.1182_965 * 1], _33
# inputs/bootstrap/source/falcon-keygen.c:5967: 				fx[v] = *x;
	movl	%ecx, (%r9,%rax,4)	# _33, MEM[(uint32_t *)fx_183 + v_998 * 4]
# inputs/bootstrap/source/falcon-keygen.c:5968: 				gx[v] = *y;
	movl	(%rbx,%rdx), %ecx	# MEM[(uint32_t *)y_356 + ivtmp.1182_965 * 1], _35
# inputs/bootstrap/source/falcon-keygen.c:5968: 				gx[v] = *y;
	movl	%ecx, (%r15,%rax,4)	# _35, MEM[(uint32_t *)gx_339 + v_998 * 4]
# inputs/bootstrap/source/falcon-keygen.c:5965: 				v < n; v ++, x += slen, y += slen)
	addq	$1, %rax	#, v
# inputs/bootstrap/source/falcon-keygen.c:5965: 				v < n; v ++, x += slen, y += slen)
	addq	%rsi, %rdx	# _44, ivtmp.1182
	cmpq	%rax, %r8	# v, n
	jne	.L604	#,
.L603:
# inputs/bootstrap/source/falcon-keygen.c:5970: 			if (fk->ternary) {
	movq	72(%rsp), %rax	# %sfp, fk
	cmpl	$0, 4(%rax)	#, fk_222(D)->ternary
	je	.L605	#,
# inputs/bootstrap/source/falcon-keygen.c:5971: 				modp_iNTT3_ext(ft + u, slen, igm,
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 376
	movl	20(%rsp), %ebp	# %sfp, p0i
	pushq	%rbp	# p0i
	.cfi_def_cfa_offset 384
	movl	%r14d, %r9d	# p,
	movl	240(%rsp), %r8d	# %sfp,
	movl	76(%rsp), %ecx	# %sfp,
	movq	176(%rsp), %r13	# %sfp, igm
	movq	%r13, %rdx	# igm,
	movq	64(%rsp), %r12	# %sfp, slen
	movq	%r12, %rsi	# slen,
	call	modp_iNTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:5973: 				modp_iNTT3_ext(gt + u, slen, igm,
	movl	%ebp, (%rsp)	# p0i,
	movl	%r14d, %r9d	# p,
	movl	240(%rsp), %r8d	# %sfp,
	movl	76(%rsp), %ecx	# %sfp,
	movq	%r13, %rdx	# igm,
	movq	%r12, %rsi	# slen,
	movq	%rbx, %rdi	# y,
	call	modp_iNTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 368
.L606:
# inputs/bootstrap/source/falcon-keygen.c:6008: 		Fp = gx + n;
	movq	184(%rsp), %rax	# %sfp, _25
	leaq	(%r15,%rax), %r8	#, Fp
	movq	%r8, 16(%rsp)	# Fp, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6009: 		Gp = Fp + hn;
	movq	232(%rsp), %rax	# %sfp, _46
	leaq	(%r8,%rax), %r9	#, Gp
	movq	%r9, 24(%rsp)	# Gp, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6010: 		for (v = 0, x = Ft + u, y = Gt + u;
	movq	208(%rsp), %rbp	# %sfp, x
# inputs/bootstrap/source/falcon-keygen.c:6010: 		for (v = 0, x = Ft + u, y = Gt + u;
	movq	200(%rsp), %r12	# %sfp, y
# inputs/bootstrap/source/falcon-keygen.c:6011: 			v < hn; v ++, x += llen, y += llen)
	movq	40(%rsp), %rdi	# %sfp, hn
	testq	%rdi, %rdi	# hn
	je	.L613	#,
	movl	$0, %edx	#, ivtmp.1171
# inputs/bootstrap/source/falcon-keygen.c:6010: 		for (v = 0, x = Ft + u, y = Gt + u;
	movl	$0, %eax	#, v
	movq	216(%rsp), %rsi	# %sfp, _21
	.p2align 5
.L614:
# inputs/bootstrap/source/falcon-keygen.c:6013: 			Fp[v] = *x;
	movl	0(%rbp,%rdx), %ecx	# MEM[(uint32_t *)x_368 + ivtmp.1171_957 * 1], _50
# inputs/bootstrap/source/falcon-keygen.c:6013: 			Fp[v] = *x;
	movl	%ecx, (%r8,%rax,4)	# _50, MEM[(uint32_t *)Fp_366 + v_995 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6014: 			Gp[v] = *y;
	movl	(%r12,%rdx), %ecx	# MEM[(uint32_t *)y_369 + ivtmp.1171_957 * 1], _52
# inputs/bootstrap/source/falcon-keygen.c:6014: 			Gp[v] = *y;
	movl	%ecx, (%r9,%rax,4)	# _52, MEM[(uint32_t *)Gp_367 + v_995 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6011: 			v < hn; v ++, x += llen, y += llen)
	addq	$1, %rax	#, v
# inputs/bootstrap/source/falcon-keygen.c:6011: 			v < hn; v ++, x += llen, y += llen)
	addq	%rsi, %rdx	# _21, ivtmp.1171
	cmpq	%rdi, %rax	# hn, v
	jne	.L614	#,
.L613:
# inputs/bootstrap/source/falcon-keygen.c:6016: 		if (fk->ternary) {
	movq	72(%rsp), %rax	# %sfp, fk
	cmpl	$0, 4(%rax)	#, fk_222(D)->ternary
	je	.L615	#,
# inputs/bootstrap/source/falcon-keygen.c:6017: 			modp_NTT3(Fp, gm, logn - 1, 0, p, p0i);
	movl	60(%rsp), %eax	# %sfp, logn
	leal	-1(%rax), %ebx	#, _55
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 376
	movl	20(%rsp), %r13d	# %sfp, p0i
	pushq	%r13	# p0i
	.cfi_def_cfa_offset 384
	movl	%r14d, %r9d	# p,
	movl	$0, %r8d	#,
	movl	%ebx, %ecx	# _55,
	movq	144(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	32(%rsp), %rdi	# %sfp,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6018: 			modp_NTT3(Gp, gm, logn - 1, 0, p, p0i);
	movl	%r13d, (%rsp)	# p0i,
	movl	%r14d, %r9d	# p,
	movl	$0, %r8d	#,
	movl	%ebx, %ecx	# _55,
	movq	144(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	40(%rsp), %rdi	# %sfp,
	call	modp_NTT3_ext	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 368
.L616:
# inputs/bootstrap/source/falcon-keygen.c:6054: 		if (full) {
	cmpl	$0, 224(%rsp)	#, %sfp
	jne	.L617	#,
# inputs/bootstrap/source/falcon-keygen.c:6093: 			for (v = 0, x = Ft + u, y = Gt + u; v < hn;
	movq	%r12, %rbx	# y, y
# inputs/bootstrap/source/falcon-keygen.c:6093: 			for (v = 0, x = Ft + u, y = Gt + u; v < hn;
	movq	%rbp, %r11	# x, x
# inputs/bootstrap/source/falcon-keygen.c:6093: 			for (v = 0, x = Ft + u, y = Gt + u; v < hn;
	movl	$0, %ecx	#, v
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	56(%rsp), %r13d	# %sfp, _701
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	12(%rsp), %r10d	# %sfp, _703
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %r9d	# p, _706
# inputs/bootstrap/source/falcon-keygen.c:6093: 			for (v = 0, x = Ft + u, y = Gt + u; v < hn;
	cmpq	$0, 40(%rsp)	#, %sfp
	je	.L619	#,
	movq	%rbp, 80(%rsp)	# x, %sfp
	movq	%r12, 88(%rsp)	# y, %sfp
.L618:
# inputs/bootstrap/source/falcon-keygen.c:6099: 				ftA = fx[(v << 1) + 0];
	movq	32(%rsp), %rax	# %sfp, fx
	movl	(%rax,%rcx,8), %edi	# MEM[(uint32_t *)fx_183 + v_997 * 8], ftA
	movl	%edi, 56(%rsp)	# ftA, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6100: 				ftB = fx[(v << 1) + 1];
	movl	4(%rax,%rcx,8), %esi	# MEM[(uint32_t *)fx_183 + 4B + v_997 * 8], ftB
# inputs/bootstrap/source/falcon-keygen.c:6101: 				gtA = gx[(v << 1) + 0];
	movl	(%r15,%rcx,8), %edi	# MEM[(uint32_t *)gx_339 + v_997 * 8], gtA
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	16(%rsp), %rdx	# %sfp, Fp
	movl	(%rdx,%rcx,4), %edx	# MEM[(uint32_t *)Fp_366 + v_997 * 4], _700
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r13, %rdx	# _701, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rax	# z, _704
	imulq	%r10, %rax	# _703, _704
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _705
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rax	# _706, w_707
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %rax	# z, _708
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _709
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ebp	# d, _713
	sarl	$31, %ebp	#, _713
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %ebp	# p, _715
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	24(%rsp), %rdx	# %sfp, Gp
	movl	(%rdx,%rcx,4), %r8d	# MEM[(uint32_t *)Gp_367 + v_997 * 4], _686
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r13, %r8	# _701, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r8, %rdx	# z, _688
	imulq	%r10, %rdx	# _703, _688
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %edx	#, _689
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rdx	# _706, w_690
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rdx	# z, _691
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rdx	#, _692
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %edx	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%edx, %r8d	# d, _696
	sarl	$31, %r8d	#, _696
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r8d	# p, _698
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%rbp), %ebp	#, _672
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%r15,%rcx,8), %r12d	# MEM[(uint32_t *)gx_339 + 4B + v_997 * 8], _671
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbp, %r12	# _672, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r12, %rax	# z, _674
	imulq	%r10, %rax	# _703, _674
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _675
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rax	# _706, w_676
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r12, %rax	# z, _677
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _678
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r12d	# d, _682
	sarl	$31, %r12d	#, _682
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %r12d	# p, _684
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r12d, %eax	# _684, tmp1018
	movl	%eax, (%r11)	# tmp1018, MEM[(uint32_t *)x_981]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%edi, %edi	# gtA, _657
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rbp, %rdi	# _672, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdi, %rax	# z, _659
	imulq	%r10, %rax	# _703, _659
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _660
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rax	# _706, w_661
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# z, _662
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _663
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %edi	# d, _667
	sarl	$31, %edi	#, _667
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %edi	# p, _669
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edi, %eax	# _669, tmp1026
	movq	(%rsp), %rdi	# %sfp, llen
	movl	%eax, (%r11,%rdi,4)	# tmp1026, MEM[(uint32_t *)x_981 + llen_153 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rdx,%r8), %edx	#, _643
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%esi, %esi	# ftB, _642
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdx, %rsi	# _643, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rsi, %rax	# z, _645
	imulq	%r10, %rax	# _703, _645
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _646
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rax	# _706, w_647
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rsi, %rax	# z, _648
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _649
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %esi	# d, _653
	sarl	$31, %esi	#, _653
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %esi	# p, _655
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%esi, %eax	# _655, tmp1035
	movl	%eax, (%rbx)	# tmp1035, MEM[(uint32_t *)y_988]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	56(%rsp), %eax	# %sfp, _628
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %rdx	# _628, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rax	# z, _630
	imulq	%r10, %rax	# _703, _630
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _631
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%r9, %rax	# _706, w_632
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %rax	# z, _633
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _634
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r14d, %eax	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r14d, %edx	# p, _640
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edx, %eax	# _640, tmp1043
	movl	%eax, (%rbx,%rdi,4)	# tmp1043, MEM[(uint32_t *)y_988 + llen_153 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6094: 				v ++, x += (llen << 1), y += (llen << 1))
	addq	$1, %rcx	#, v
# inputs/bootstrap/source/falcon-keygen.c:6094: 				v ++, x += (llen << 1), y += (llen << 1))
	movq	144(%rsp), %rax	# %sfp, _94
	addq	%rax, %r11	# _94, x
# inputs/bootstrap/source/falcon-keygen.c:6094: 				v ++, x += (llen << 1), y += (llen << 1))
	addq	%rax, %rbx	# _94, y
# inputs/bootstrap/source/falcon-keygen.c:6093: 			for (v = 0, x = Ft + u, y = Gt + u; v < hn;
	movq	40(%rsp), %rax	# %sfp, hn
	cmpq	%rax, %rcx	# hn, v
	jne	.L618	#,
	movq	80(%rsp), %rbp	# %sfp, x
	movq	88(%rsp), %r12	# %sfp, y
	jmp	.L619	#
.L621:
# inputs/bootstrap/source/falcon-keygen.c:6115: 			modp_iNTT2_ext(Ft + u, llen, igm, logn, p, p0i);
	movl	12(%rsp), %r9d	# %sfp,
	movl	%r14d, %r8d	# p,
	movl	60(%rsp), %r13d	# %sfp, logn
	movl	%r13d, %ecx	# logn,
	movq	160(%rsp), %r15	# %sfp, igm
	movq	%r15, %rdx	# igm,
	movq	(%rsp), %rbx	# %sfp, llen
	movq	%rbx, %rsi	# llen,
	movq	%rbp, %rdi	# x,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6116: 			modp_iNTT2_ext(Gt + u, llen, igm, logn, p, p0i);
	movl	12(%rsp), %r9d	# %sfp,
	movl	%r14d, %r8d	# p,
	movl	%r13d, %ecx	# logn,
	movq	%r15, %rdx	# igm,
	movq	%rbx, %rsi	# llen,
	movq	%r12, %rdi	# y,
	call	modp_iNTT2_ext	#
	jmp	.L622	#
.L591:
# inputs/bootstrap/source/falcon-keygen.c:6123: 	zint_rebuild_CRT(Ft, llen, llen, n, primes, 1, t1);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 376
	movq	136(%rsp), %r14	# %sfp, t1
	pushq	%r14	# t1
	.cfi_def_cfa_offset 384
	movl	$1, %r9d	#,
	movq	312(%rsp), %rbp	# %sfp, primes
	movq	%rbp, %r8	# primes,
	movq	80(%rsp), %r15	# %sfp, n
	movq	%r15, %rcx	# n,
	movq	16(%rsp), %rbx	# %sfp, llen
	movq	%rbx, %rdx	# llen,
	movq	%rbx, %rsi	# llen,
	movq	152(%rsp), %rdi	# %sfp,
	call	zint_rebuild_CRT	#
# inputs/bootstrap/source/falcon-keygen.c:6124: 	zint_rebuild_CRT(Gt, llen, llen, n, primes, 1, t1);
	movq	%r14, (%rsp)	# t1,
	movl	$1, %r9d	#,
	movq	%rbp, %r8	# primes,
	movq	%r15, %rcx	# n,
	movq	%rbx, %rdx	# llen,
	movq	%rbx, %rsi	# llen,
	movq	136(%rsp), %rdi	# %sfp,
	call	zint_rebuild_CRT	#
# inputs/bootstrap/source/falcon-keygen.c:6176: 	rt3 = align_fpr(fk->tmp, t1);
	movq	88(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %rbx	# fk_222(D)->tmp, _96
# inputs/bootstrap/source/falcon-keygen.c:6176: 	rt3 = align_fpr(fk->tmp, t1);
	movq	%r14, %rsi	# t1,
	movq	%rbx, %rdi	# _96,
	call	align_fpr	#
# inputs/bootstrap/source/falcon-keygen.c:6177: 	rt4 = rt3 + n;
	leaq	0(,%r15,8), %rbp	#, _97
# inputs/bootstrap/source/falcon-keygen.c:6177: 	rt4 = rt3 + n;
	movq	%rax, 96(%rsp)	# rt3, %sfp
	addq	%rbp, %rax	# _97, rt4
# inputs/bootstrap/source/falcon-keygen.c:6178: 	rt5 = rt4 + n;
	movq	%rax, 104(%rsp)	# rt4, %sfp
	leaq	(%rax,%rbp), %rdi	#, rt5
# inputs/bootstrap/source/falcon-keygen.c:6179: 	rt1 = rt5 + (n >> 1);
	movq	%r15, %rax	# n, _98
	shrq	%rax	# _98
# inputs/bootstrap/source/falcon-keygen.c:6179: 	rt1 = rt5 + (n >> 1);
	movq	%rdi, 112(%rsp)	# rt5, %sfp
	leaq	(%rdi,%rax,8), %r14	#, rt1
	movq	%r14, 32(%rsp)	# rt1, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5344: 	k = (size_t)(cd - cb);
	movq	%r14, %rdx	# rt1, _807
	subq	%rbx, %rdx	# _96, _807
# inputs/bootstrap/source/falcon-keygen.c:5345: 	km = k % sizeof(uint32_t);
	movq	%rdx, %rcx	# _807, km
	andl	$3, %ecx	#, km
# inputs/bootstrap/source/falcon-keygen.c:5346: 	if (km) {
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 368
# inputs/bootstrap/source/falcon-keygen.c:5347: 		k += (sizeof(uint32_t)) - km;
	leaq	4(%rdx), %rax	#, _968
	subq	%rcx, %rax	# km, tmp1159
	testq	%rcx, %rcx	# km
	cmove	%rdx, %rax	# tmp1159,, _807, k
# inputs/bootstrap/source/falcon-keygen.c:5349: 	return (uint32_t *)(cb + k);
	leaq	(%rbx,%rax), %rdx	#, _814
	movq	%rdx, 32(%rsp)	# _814, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6181: 	rt2 = align_fpr(fk->tmp, k + n);
	leaq	(%rdx,%r15,4), %rsi	#, _101
	movq	%rsi, 104(%rsp)	# _101, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6181: 	rt2 = align_fpr(fk->tmp, k + n);
	movq	%rbx, %rdi	# _96,
	call	align_fpr	#
	movq	%rax, %r12	#, tmp1194
# inputs/bootstrap/source/falcon-keygen.c:6182: 	if (rt2 < (rt1 + n)) {
	leaq	(%r14,%rbp), %rax	#, _102
# inputs/bootstrap/source/falcon-keygen.c:6182: 	if (rt2 < (rt1 + n)) {
	cmpq	%rax, %r12	# _102, tmp1194
	cmovb	%rax, %r12	# tmp1194,, _102, _210
# inputs/bootstrap/source/falcon-keygen.c:6191: 	maxbl_f = poly_max_bitlength(ft, slen, slen, logn, full);
	movl	224(%rsp), %r13d	# %sfp, full
	movl	%r13d, %r8d	# full,
	movl	60(%rsp), %r14d	# %sfp, logn
	movl	%r14d, %ecx	# logn,
	movq	48(%rsp), %r15	# %sfp, slen
	movq	%r15, %rdx	# slen,
	movq	%r15, %rsi	# slen,
	movq	168(%rsp), %rdi	# %sfp,
	call	poly_max_bitlength	#
	movl	%eax, %ebx	# tmp1195, maxbl_f
# inputs/bootstrap/source/falcon-keygen.c:6192: 	maxbl_g = poly_max_bitlength(gt, slen, slen, logn, full);
	movl	%r13d, %r8d	# full,
	movl	%r14d, %ecx	# logn,
	movq	%r15, %rdx	# slen,
	movq	%r15, %rsi	# slen,
	movq	176(%rsp), %rdi	# %sfp,
	call	poly_max_bitlength	#
# inputs/bootstrap/source/falcon-keygen.c:6193: 	maxbl_fg = maxbl_f < maxbl_g ? maxbl_g : maxbl_f;
	cmpl	%eax, %ebx	# tmp1196, maxbl_f
	cmovnb	%ebx, %eax	# maxbl_f,, tmp1196
	movl	%eax, %ebx	# tmp1196, maxbl_fg
	movl	%eax, 56(%rsp)	# maxbl_fg, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6199: 	poly_big_to_fp(rt3, ft, slen, slen, logn, full, maxbl_fg, maxbl_fg);
	pushq	%rax	# maxbl_fg
	.cfi_def_cfa_offset 376
	pushq	%rax	# maxbl_fg
	.cfi_def_cfa_offset 384
	movl	%r13d, %r9d	# full,
	movl	%r14d, %r8d	# logn,
	movq	%r15, %rcx	# slen,
	movq	%r15, %rdx	# slen,
	movq	184(%rsp), %rsi	# %sfp,
	movq	96(%rsp), %rdi	# %sfp,
	call	poly_big_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:6200: 	poly_big_to_fp(rt4, gt, slen, slen, logn, full, maxbl_fg, maxbl_fg);
	pushq	%rbx	# maxbl_fg
	.cfi_def_cfa_offset 392
	pushq	%rbx	# maxbl_fg
	.cfi_def_cfa_offset 400
	movl	%r13d, %r9d	# full,
	movl	%r14d, %r8d	# logn,
	movq	%r15, %rcx	# slen,
	movq	%r15, %rdx	# slen,
	movq	208(%rsp), %rsi	# %sfp,
	movq	120(%rsp), %rbx	# %sfp, rt4
	movq	%rbx, %rdi	# rt4,
	call	poly_big_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:6202: 	if (fk->ternary) {
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 368
	movq	72(%rsp), %rax	# %sfp, fk
	cmpl	$0, 4(%rax)	#, fk_222(D)->ternary
	je	.L625	#,
# inputs/bootstrap/source/falcon-keygen.c:6203: 		falcon_FFT3(rt3, logn, full);
	movl	%r13d, %edx	# full,
	movl	%r14d, %esi	# logn,
	movq	80(%rsp), %r15	# %sfp, rt3
	movq	%r15, %rdi	# rt3,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6204: 		falcon_FFT3(rt4, logn, full);
	movl	%r13d, %edx	# full,
	movl	%r14d, %esi	# logn,
	movq	%rbx, %rdi	# rt4,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6205: 		falcon_poly_invnorm2_fft3(rt5, rt3, rt4, logn, full);
	movl	%r13d, %r8d	# full,
	movl	%r14d, %ecx	# logn,
	movq	%rbx, %rdx	# rt4,
	movq	%r15, %rsi	# rt3,
	movq	96(%rsp), %rdi	# %sfp,
	call	falcon_poly_invnorm2_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6206: 		falcon_poly_adj_fft3(rt3, logn, full);
	movl	%r13d, %edx	# full,
	movl	%r14d, %esi	# logn,
	movq	%r15, %rdi	# rt3,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6207: 		falcon_poly_adj_fft3(rt4, logn, full);
	movl	%r13d, %edx	# full,
	movl	%r14d, %esi	# logn,
	movq	%rbx, %rdi	# rt4,
	call	falcon_poly_adj_fft3@PLT	#
.L626:
	leaq	0(%rbp,%r12), %rax	#, _200
	movq	%rax, 112(%rsp)	# _200, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6093: 			for (v = 0, x = Ft + u, y = Gt + u; v < hn;
	movq	(%rsp), %rbx	# %sfp, FGlen
	movl	$-1, %r14d	#, prev_maxbl_FG
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387904, %rbp	#, tmp1169
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	$1021, %r15d	#, tmp1171
	jmp	.L627	#
.L625:
# inputs/bootstrap/source/falcon-keygen.c:6209: 		falcon_FFT(rt3, logn);
	movl	60(%rsp), %ebx	# %sfp, logn
	movl	%ebx, %esi	# logn,
	movq	80(%rsp), %r15	# %sfp, rt3
	movq	%r15, %rdi	# rt3,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6210: 		falcon_FFT(rt4, logn);
	movl	%ebx, %esi	# logn,
	movq	88(%rsp), %r14	# %sfp, rt4
	movq	%r14, %rdi	# rt4,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6211: 		falcon_poly_invnorm2_fft(rt5, rt3, rt4, logn);
	movl	%ebx, %ecx	# logn,
	movq	%r14, %rdx	# rt4,
	movq	%r15, %rsi	# rt3,
	movq	96(%rsp), %rdi	# %sfp,
	call	falcon_poly_invnorm2_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6212: 		falcon_poly_adj_fft(rt3, logn);
	movl	%ebx, %esi	# logn,
	movq	%r15, %rdi	# rt3,
	call	falcon_poly_adj_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6213: 		falcon_poly_adj_fft(rt4, logn);
	movl	%ebx, %esi	# logn,
	movq	%r14, %rdi	# rt4,
	call	falcon_poly_adj_fft@PLT	#
	jmp	.L626	#
.L631:
# inputs/bootstrap/source/falcon-keygen.c:6266: 			falcon_FFT(rt1, logn);
	movl	60(%rsp), %r14d	# %sfp, logn
	movl	%r14d, %esi	# logn,
	movq	16(%rsp), %r13	# %sfp, rt1
	movq	%r13, %rdi	# rt1,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6267: 			falcon_FFT(rt2, logn);
	movl	%r14d, %esi	# logn,
	movq	%r12, %rdi	# _210,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6268: 			falcon_poly_mul_fft(rt1, rt3, logn);
	movl	%r14d, %edx	# logn,
	movq	80(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# rt1,
	call	falcon_poly_mul_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6269: 			falcon_poly_mul_fft(rt2, rt4, logn);
	movl	%r14d, %edx	# logn,
	movq	88(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# _210,
	call	falcon_poly_mul_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6270: 			falcon_poly_add_fft(rt2, rt1, logn);
	movl	%r14d, %edx	# logn,
	movq	%r13, %rsi	# rt1,
	movq	%r12, %rdi	# _210,
	call	falcon_poly_add@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6271: 			falcon_poly_mul_autoadj_fft(rt2, rt5, logn);
	movl	%r14d, %edx	# logn,
	movq	96(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# _210,
	call	falcon_poly_mul_autoadj_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6272: 			falcon_iFFT(rt2, logn);
	movl	%r14d, %esi	# logn,
	movq	%r12, %rdi	# _210,
	call	falcon_iFFT@PLT	#
	jmp	.L632	#
.L639:
# inputs/bootstrap/source/falcon-keygen.c:6324: 					ukx = (uint64_t)0 - ukx;
	negq	%rsi	# ukx_310
# inputs/bootstrap/source/falcon-keygen.c:6326: 				ks = (int32_t)(ukx >> scale_k);
	movl	%r13d, %ecx	# scale_k, tmp1629
	shrq	%cl, %rsi	# tmp1629, _121
# inputs/bootstrap/source/falcon-keygen.c:6326: 				ks = (int32_t)(ukx >> scale_k);
	movslq	%esi, %rcx	# _121, ks
# inputs/bootstrap/source/falcon-keygen.c:6328: 					ks = -ks;
	negq	%rcx	# ks
.L640:
# inputs/bootstrap/source/falcon-keygen.c:6331: 			k[u] = ks;
	movl	%ecx, (%r11,%r9,4)	# ks, MEM[(int32_t *)_814 + u_974 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6315: 		for (u = 0; u < n; u ++) {
	addq	$1, %r9	#, u
# inputs/bootstrap/source/falcon-keygen.c:6315: 		for (u = 0; u < n; u ++) {
	cmpq	%r9, %rbx	# u, n
	je	.L690	#,
.L641:
# inputs/bootstrap/source/falcon-keygen.c:6318: 			kx = fpr_rint(rt2[u]);
	movq	(%r12,%r9,8), %rsi	# MEM[(fpr *)_210 + u_974 * 8], _120
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rsi, %rdx	# _120, _869
	salq	$10, %rdx	#, _869
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp1614
	andq	%rax, %rdx	# tmp1614, _870
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%rbp, %rdx	# tmp1169, m
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rsi, %rcx	# _120, _872
	shrq	$52, %rcx	#, _872
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %ecx	#, _874
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	$1085, %r8d	#, e
	subl	%ecx, %r8d	# _874, e
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r15d, %eax	# tmp1171, _876
	subl	%ecx, %eax	# _874, _876
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _878
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _878, _879
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp1107
	andq	%rdx, %rax	# m, m
# inputs/bootstrap/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r8d, %r10d	# e, e
	andl	$63, %r10d	#, e
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	%r14d, %ecx	# tmp1108, _882
	subl	%r10d, %ecx	# e, _882
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdx	# m, _883
	salq	$32, %rdx	#, _883
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _882
	cmove	%rax, %rdx	# _883,, m, x_889
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _890
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdx	# _890, _891
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdx, %rdi	# _891, _893
	shrq	$32, %rdi	#, _893
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %edi	#, _895
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edx, %edi	# _891, dd
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _903
	shrq	$32, %rcx	#, _903
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r10d	#, tmp1216
	cmovne	%rcx, %rax	# _903,, x_909
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r8d, %ecx	# e, e
	andl	$31, %ecx	#, e
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rax	# _910, _911
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%edi, %ecx	# dd, _899
	negl	%ecx	# _899
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edi, %ecx	# dd, _900
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _901
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdx	#, _897
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edx, %ecx	# _897, f_902
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %edi	#, _912
	shrl	%cl, %edi	# f_902, _912
	movl	%edi, %ecx	# _912, _912
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %ecx	#, _914
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%rax, %rcx	# _911, m_915
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rsi, %rax	# _120, _918
	sarq	$63, %rax	#, _918
	xorq	%rax, %rcx	# _918, _920
# inputs/bootstrap/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rsi	#, _916
# inputs/bootstrap/source/falcon-keygen.c:6323: 				if (kx < 0) {
	addq	%rcx, %rsi	# _920, _922
	js	.L639	#,
# inputs/bootstrap/source/falcon-keygen.c:6326: 				ks = (int32_t)(ukx >> scale_k);
	movl	%r13d, %ecx	# scale_k, tmp1628
	shrq	%cl, %rsi	# tmp1628, _922
# inputs/bootstrap/source/falcon-keygen.c:6326: 				ks = (int32_t)(ukx >> scale_k);
	movslq	%esi, %rcx	# _5, ks
	jmp	.L640	#
.L690:
	movl	12(%rsp), %edi	# %sfp, scale_FG
	movq	40(%rsp), %rbx	# %sfp, FGlen
.L638:
# inputs/bootstrap/source/falcon-keygen.c:6338: 		if (depth <= DEPTH_INT_FG) {
	cmpl	$4, 228(%rsp)	#, %sfp
	ja	.L642	#,
# inputs/bootstrap/source/falcon-keygen.c:6339: 			poly_sub_scaled_ntt(Ft, FGlen, llen, ft, slen, slen,
	movl	56(%rsp), %eax	# %sfp, maxbl_fg
	subl	%eax, %edi	# maxbl_fg, scale_FG
	movl	%edi, %r13d	# scale_FG, _128
	pushq	104(%rsp)	# %sfp
	.cfi_def_cfa_offset 376
	movq	80(%rsp), %rax	# %sfp, fk
	movl	4(%rax), %eax	# fk_222(D)->ternary, fk_222(D)->ternary
	pushq	%rax	# fk_222(D)->ternary
	.cfi_def_cfa_offset 384
	movl	240(%rsp), %esi	# %sfp, full
	pushq	%rsi	# full
	.cfi_def_cfa_offset 392
	movl	84(%rsp), %edi	# %sfp, logn
	pushq	%rdi	# logn
	.cfi_def_cfa_offset 400
	pushq	%r13	# _128
	.cfi_def_cfa_offset 408
	pushq	72(%rsp)	# %sfp
	.cfi_def_cfa_offset 416
	movq	96(%rsp), %r14	# %sfp, slen
	movq	%r14, %r9	# slen,
	movq	%r14, %r8	# slen,
	movq	216(%rsp), %rcx	# %sfp,
	movq	48(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# FGlen,
	movq	184(%rsp), %rdi	# %sfp,
	call	poly_sub_scaled_ntt	#
# inputs/bootstrap/source/falcon-keygen.c:6342: 			poly_sub_scaled_ntt(Gt, FGlen, llen, gt, slen, slen,
	addq	$48, %rsp	#,
	.cfi_def_cfa_offset 368
	pushq	104(%rsp)	# %sfp
	.cfi_def_cfa_offset 376
	movq	80(%rsp), %rax	# %sfp, fk
	movl	4(%rax), %eax	# fk_222(D)->ternary, fk_222(D)->ternary
	pushq	%rax	# fk_222(D)->ternary
	.cfi_def_cfa_offset 384
	movl	240(%rsp), %esi	# %sfp, full
	pushq	%rsi	# full
	.cfi_def_cfa_offset 392
	movl	84(%rsp), %edi	# %sfp, logn
	pushq	%rdi	# logn
	.cfi_def_cfa_offset 400
	pushq	%r13	# _128
	.cfi_def_cfa_offset 408
	pushq	72(%rsp)	# %sfp
	.cfi_def_cfa_offset 416
	movq	%r14, %r9	# slen,
	movq	%r14, %r8	# slen,
	movq	224(%rsp), %rcx	# %sfp,
	movq	48(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# FGlen,
	movq	168(%rsp), %rdi	# %sfp,
	call	poly_sub_scaled_ntt	#
	addq	$48, %rsp	#,
	.cfi_def_cfa_offset 368
.L643:
# inputs/bootstrap/source/falcon-keygen.c:6093: 			for (v = 0, x = Ft + u, y = Gt + u; v < hn;
	movl	24(%rsp), %r14d	# %sfp, prev_maxbl_FG
.L627:
# inputs/bootstrap/source/falcon-keygen.c:6230: 		maxbl_F = poly_max_bitlength(Ft, FGlen, llen, logn, full);
	movl	224(%rsp), %r8d	# %sfp,
	movl	60(%rsp), %ecx	# %sfp,
	movq	(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# FGlen,
	movq	136(%rsp), %rdi	# %sfp,
	call	poly_max_bitlength	#
	movl	%eax, %r13d	# tmp1197, maxbl_F
# inputs/bootstrap/source/falcon-keygen.c:6231: 		maxbl_G = poly_max_bitlength(Gt, FGlen, llen, logn, full);
	movl	224(%rsp), %r8d	# %sfp,
	movl	60(%rsp), %ecx	# %sfp,
	movq	(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# FGlen,
	movq	120(%rsp), %rdi	# %sfp,
	call	poly_max_bitlength	#
# inputs/bootstrap/source/falcon-keygen.c:6232: 		maxbl_FG = maxbl_F < maxbl_G ? maxbl_G : maxbl_F;
	cmpl	%eax, %r13d	# tmp1198, maxbl_F
	cmovnb	%r13d, %eax	# maxbl_F,, tmp1198
	movl	%eax, %edi	# tmp1198, maxbl_FG
	movl	%eax, 24(%rsp)	# maxbl_FG, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6233: 		while ((FGlen * 31) >= (maxbl_FG + 43)) {
	movq	%rbx, %rcx	# FGlen, tmp1049
	salq	$5, %rcx	#, tmp1049
	subq	%rbx, %rcx	# FGlen, _258
	movq	%rcx, %rax	# _258, ivtmp.1124
# inputs/bootstrap/source/falcon-keygen.c:6233: 		while ((FGlen * 31) >= (maxbl_FG + 43)) {
	leal	43(%rdi), %edx	#, _928
# inputs/bootstrap/source/falcon-keygen.c:6233: 		while ((FGlen * 31) >= (maxbl_FG + 43)) {
	cmpq	%rdx, %rcx	# _928, _258
	jb	.L628	#,
	.p2align 4
.L629:
# inputs/bootstrap/source/falcon-keygen.c:6234: 			FGlen --;
	subq	$1, %rbx	#, FGlen
# inputs/bootstrap/source/falcon-keygen.c:6233: 		while ((FGlen * 31) >= (maxbl_FG + 43)) {
	subq	$31, %rax	#, ivtmp.1124
	cmpq	%rdx, %rax	# _928, ivtmp.1124
	jnb	.L629	#,
.L628:
# inputs/bootstrap/source/falcon-keygen.c:6242: 		if (maxbl_FG <= maxbl_fg || maxbl_FG >= prev_maxbl_FG) {
	movl	24(%rsp), %edi	# %sfp, maxbl_FG
	cmpl	%edi, 56(%rsp)	# maxbl_FG, %sfp
	jnb	.L630	#,
	cmpl	%r14d, %edi	# prev_maxbl_FG, maxbl_FG
	jnb	.L630	#,
# inputs/bootstrap/source/falcon-keygen.c:6251: 		scale_FG = maxbl_FG < 30 ? 0 : maxbl_FG - 30;
	movl	$30, %eax	#, tmp1214
	movl	%edi, %r14d	# maxbl_FG, maxbl_FG
	cmpl	%eax, %edi	# tmp1214, maxbl_FG
	cmovnb	%edi, %eax	# maxbl_FG,, _110
# inputs/bootstrap/source/falcon-keygen.c:6251: 		scale_FG = maxbl_FG < 30 ? 0 : maxbl_FG - 30;
	subl	$30, %eax	#, scale_FG
# inputs/bootstrap/source/falcon-keygen.c:6252: 		poly_big_to_fp(rt1, Ft, FGlen, llen,
	movl	%eax, 12(%rsp)	# scale_FG, %sfp
	pushq	%rax	# scale_FG
	.cfi_def_cfa_offset 376
	pushq	%rdi	# maxbl_FG
	.cfi_def_cfa_offset 384
	movl	240(%rsp), %r9d	# %sfp,
	movl	76(%rsp), %r13d	# %sfp, logn
	movl	%r13d, %r8d	# logn,
	movq	16(%rsp), %rcx	# %sfp,
	movq	%rbx, %rdx	# FGlen,
	movq	152(%rsp), %rsi	# %sfp,
	movq	32(%rsp), %rdi	# %sfp,
	call	poly_big_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:6254: 		poly_big_to_fp(rt2, Gt, FGlen, llen,
	movl	28(%rsp), %eax	# %sfp, scale_FG
	pushq	%rax	# scale_FG
	.cfi_def_cfa_offset 392
	pushq	%r14	# maxbl_FG
	.cfi_def_cfa_offset 400
	movl	256(%rsp), %r14d	# %sfp, full
	movl	%r14d, %r9d	# full,
	movl	%r13d, %r8d	# logn,
	movq	32(%rsp), %rcx	# %sfp,
	movq	%rbx, %rdx	# FGlen,
	movq	152(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# _210,
	call	poly_big_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:6257: 		if (fk->ternary) {
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 368
	movq	72(%rsp), %rax	# %sfp, fk
	cmpl	$0, 4(%rax)	#, fk_222(D)->ternary
	je	.L631	#,
# inputs/bootstrap/source/falcon-keygen.c:6258: 			falcon_FFT3(rt1, logn, full);
	movl	%r14d, %edx	# full,
	movl	%r13d, %esi	# logn,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6259: 			falcon_FFT3(rt2, logn, full);
	movl	%r14d, %edx	# full,
	movl	%r13d, %esi	# logn,
	movq	%r12, %rdi	# _210,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6260: 			falcon_poly_mul_fft3(rt1, rt3, logn, full);
	movl	%r14d, %ecx	# full,
	movl	%r13d, %edx	# logn,
	movq	80(%rsp), %rsi	# %sfp,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_mul_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6261: 			falcon_poly_mul_fft3(rt2, rt4, logn, full);
	movl	%r14d, %ecx	# full,
	movl	%r13d, %edx	# logn,
	movq	88(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# _210,
	call	falcon_poly_mul_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6262: 			falcon_poly_add_fft3(rt2, rt1, logn, full);
	movl	%r14d, %ecx	# full,
	movl	%r13d, %edx	# logn,
	movq	16(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# _210,
	call	falcon_poly_add3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6263: 			falcon_poly_mul_autoadj_fft3(rt2, rt5, logn, full);
	movl	%r14d, %ecx	# full,
	movl	%r13d, %edx	# logn,
	movq	96(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# _210,
	call	falcon_poly_mul_autoadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6264: 			falcon_iFFT3(rt2, logn, full);
	movl	%r14d, %edx	# full,
	movl	%r13d, %esi	# logn,
	movq	%r12, %rdi	# _210,
	call	falcon_iFFT3@PLT	#
.L632:
# inputs/bootstrap/source/falcon-keygen.c:6280: 		for (u = 0; u < n; u ++) {
	movq	%r12, %r10	# _210, ivtmp.1117
	movl	$0, %edi	#, max_kx
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	$63, %r14d	#, tmp1068
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %r13d	#, tmp1087
# inputs/bootstrap/source/falcon-keygen.c:6280: 		for (u = 0; u < n; u ++) {
	cmpq	$0, 64(%rsp)	#, %sfp
	je	.L691	#,
	movq	%r12, 40(%rsp)	# _210, %sfp
	movq	112(%rsp), %r12	# %sfp, _200
.L633:
# inputs/bootstrap/source/falcon-keygen.c:6284: 				kx = fpr_rint(rt2[u]);
	movq	(%r10), %rsi	# MEM[(fpr *)_769], _114
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rsi, %rdx	# _114, _815
	salq	$10, %rdx	#, _815
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp1594
	andq	%rax, %rdx	# tmp1594, _816
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%rbp, %rdx	# tmp1169, m
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rsi, %rcx	# _114, _818
	shrq	$52, %rcx	#, _818
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %ecx	#, _820
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	$1085, %r9d	#, e
	subl	%ecx, %r9d	# _820, e
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r15d, %eax	# tmp1171, _822
	subl	%ecx, %eax	# _820, _822
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _824
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _824, _825
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp1067
	andq	%rdx, %rax	# m, m
# inputs/bootstrap/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r9d, %r11d	# e, e
	andl	$63, %r11d	#, e
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	%r14d, %ecx	# tmp1068, _828
	subl	%r11d, %ecx	# e, _828
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdx	# m, _829
	salq	$32, %rdx	#, _829
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _828
	cmove	%rax, %rdx	# _829,, m, x_835
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _836
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdx	# _836, _837
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdx, %r8	# _837, _839
	shrq	$32, %r8	#, _839
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r8d	#, _841
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edx, %r8d	# _837, dd
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _849
	shrq	$32, %rcx	#, _849
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r11d	#, tmp1215
	cmovne	%rcx, %rax	# _849,, x_855
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r9d, %ecx	# e, e
	andl	$31, %ecx	#, e
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rax	# _856, _857
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r8d, %ecx	# dd, _845
	negl	%ecx	# _845
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r8d, %ecx	# dd, _846
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _847
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdx	#, _843
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edx, %ecx	# _843, f_848
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	%r13d, %edx	# tmp1087, _858
	shrl	%cl, %edx	# f_848, _858
	movl	%edx, %ecx	# _858, _858
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %ecx	#, _860
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%rax, %rcx	# _857, m_861
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rsi, %rax	# _114, _864
	sarq	$63, %rax	#, _864
	xorq	%rax, %rcx	# _864, _866
# inputs/bootstrap/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rsi	#, _862
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rcx, %rsi	# _866, _868
# inputs/bootstrap/source/falcon-keygen.c:6286: 				if (kx < 0) {
	movq	%rsi, %rax	# _868, tmp1213
	negq	%rax	# tmp1213
	cmovs	%rsi, %rax	# tmp1213,, _868, _718
# inputs/bootstrap/source/falcon-keygen.c:6289: 				if (ukx > max_kx) {
	cmpq	%rax, %rdi	# _718, max_kx
	cmovb	%rax, %rdi	# max_kx,, _718, max_kx
# inputs/bootstrap/source/falcon-keygen.c:6280: 		for (u = 0; u < n; u ++) {
	addq	$8, %r10	#, ivtmp.1117
	cmpq	%r12, %r10	# _200, ivtmp.1117
	jne	.L633	#,
	movq	40(%rsp), %r12	# %sfp, _210
# inputs/bootstrap/source/falcon-keygen.c:6293: 		if (max_kx >= ((uint64_t)1 << 62)) {
	movabsq	$4611686018427387903, %rax	#, tmp1609
	cmpq	%rdi, %rax	# max_kx, tmp1609
	jb	.L692	#,
# inputs/bootstrap/source/falcon-keygen.c:6296: 		scale_k = bitlength((uint32_t)(max_kx >> 31));
	shrq	$31, %rdi	#, _105
# inputs/bootstrap/source/falcon-keygen.c:6296: 		scale_k = bitlength((uint32_t)(max_kx >> 31));
	call	bitlength	#
	movl	%eax, %r13d	# tmp1199, scale_k
# inputs/bootstrap/source/falcon-keygen.c:6303: 		if (scale_k + scale_FG < maxbl_fg) {
	movl	12(%rsp), %eax	# %sfp, scale_FG
	addl	%r13d, %eax	# scale_k, _148
# inputs/bootstrap/source/falcon-keygen.c:6303: 		if (scale_k + scale_FG < maxbl_fg) {
	movl	56(%rsp), %esi	# %sfp, maxbl_fg
	cmpl	%esi, %eax	# maxbl_fg, _148
	jnb	.L693	#,
.L648:
# inputs/bootstrap/source/falcon-keygen.c:6304: 			scale_k = maxbl_fg - scale_FG;
	movl	56(%rsp), %edi	# %sfp, maxbl_fg
	movl	%edi, %r13d	# maxbl_fg, scale_k
	movl	12(%rsp), %eax	# %sfp, scale_FG
	subl	%eax, %r13d	# scale_FG, scale_k
# inputs/bootstrap/source/falcon-keygen.c:6305: 			if (scale_k > 62) {
	cmpl	$62, %r13d	#, scale_k
	ja	.L630	#,
# inputs/bootstrap/source/falcon-keygen.c:6315: 		for (u = 0; u < n; u ++) {
	cmpq	$0, 64(%rsp)	#, %sfp
	jne	.L647	#,
	movl	56(%rsp), %edi	# %sfp, scale_FG
	jmp	.L638	#
.L642:
# inputs/bootstrap/source/falcon-keygen.c:6346: 			poly_sub_scaled(Ft, FGlen, llen, ft, slen, slen,
	movl	56(%rsp), %eax	# %sfp, maxbl_fg
	subl	%eax, %edi	# maxbl_fg, scale_FG
	movl	%edi, %r13d	# scale_FG, _132
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 376
	movq	80(%rsp), %rax	# %sfp, fk
	movl	4(%rax), %eax	# fk_222(D)->ternary, fk_222(D)->ternary
	pushq	%rax	# fk_222(D)->ternary
	.cfi_def_cfa_offset 384
	movl	240(%rsp), %esi	# %sfp, full
	pushq	%rsi	# full
	.cfi_def_cfa_offset 392
	movl	84(%rsp), %edi	# %sfp, logn
	pushq	%rdi	# logn
	.cfi_def_cfa_offset 400
	pushq	%r13	# _132
	.cfi_def_cfa_offset 408
	pushq	72(%rsp)	# %sfp
	.cfi_def_cfa_offset 416
	movq	96(%rsp), %r14	# %sfp, slen
	movq	%r14, %r9	# slen,
	movq	%r14, %r8	# slen,
	movq	216(%rsp), %rcx	# %sfp,
	movq	48(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# FGlen,
	movq	184(%rsp), %rdi	# %sfp,
	call	poly_sub_scaled	#
# inputs/bootstrap/source/falcon-keygen.c:6349: 			poly_sub_scaled(Gt, FGlen, llen, gt, slen, slen,
	addq	$40, %rsp	#,
	.cfi_def_cfa_offset 376
	movq	80(%rsp), %rax	# %sfp, fk
	movl	4(%rax), %eax	# fk_222(D)->ternary, fk_222(D)->ternary
	pushq	%rax	# fk_222(D)->ternary
	.cfi_def_cfa_offset 384
	movl	240(%rsp), %esi	# %sfp, full
	pushq	%rsi	# full
	.cfi_def_cfa_offset 392
	movl	84(%rsp), %edi	# %sfp, logn
	pushq	%rdi	# logn
	.cfi_def_cfa_offset 400
	pushq	%r13	# _132
	.cfi_def_cfa_offset 408
	pushq	72(%rsp)	# %sfp
	.cfi_def_cfa_offset 416
	movq	%r14, %r9	# slen,
	movq	%r14, %r8	# slen,
	movq	224(%rsp), %rcx	# %sfp,
	movq	48(%rsp), %rdx	# %sfp,
	movq	%rbx, %rsi	# FGlen,
	movq	168(%rsp), %rdi	# %sfp,
	call	poly_sub_scaled	#
	addq	$48, %rsp	#,
	.cfi_def_cfa_offset 368
	jmp	.L643	#
.L630:
# inputs/bootstrap/source/falcon-keygen.c:6359: 	if (maxbl_FG > (slen * 31)) {
	movl	24(%rsp), %eax	# %sfp, _134
# inputs/bootstrap/source/falcon-keygen.c:6359: 	if (maxbl_FG > (slen * 31)) {
	movq	48(%rsp), %rsi	# %sfp, slen
	movq	%rsi, %rcx	# slen, tmp1143
	salq	$5, %rcx	#, tmp1143
	subq	%rsi, %rcx	# slen, _135
# inputs/bootstrap/source/falcon-keygen.c:6360: 		return 0;
	movl	$0, %edx	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:6359: 	if (maxbl_FG > (slen * 31)) {
	cmpq	%rax, %rcx	# _134, _135
	jb	.L586	#,
# inputs/bootstrap/source/falcon-keygen.c:6367: 	for (u = 0, x = fk->tmp, y = fk->tmp;
	movq	72(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %r12	# fk_222(D)->tmp, x
# inputs/bootstrap/source/falcon-keygen.c:6368: 		u < (n << 1); u ++, x += slen, y += llen)
	movq	64(%rsp), %rbp	# %sfp, n
	addq	%rbp, %rbp	# n
	je	.L657	#,
# inputs/bootstrap/source/falcon-keygen.c:6370: 		memmove(x, y, slen * sizeof *y);
	leaq	0(,%rsi,4), %r13	#, _136
# inputs/bootstrap/source/falcon-keygen.c:6368: 		u < (n << 1); u ++, x += slen, y += llen)
	movq	(%rsp), %rax	# %sfp, llen
	salq	$2, %rax	#, llen
# inputs/bootstrap/source/falcon-keygen.c:6367: 	for (u = 0, x = fk->tmp, y = fk->tmp;
	movq	%r12, %r15	# x, y
# inputs/bootstrap/source/falcon-keygen.c:6367: 	for (u = 0, x = fk->tmp, y = fk->tmp;
	movl	$0, %r14d	#, u
	movq	%rbx, (%rsp)	# FGlen, %sfp
	movq	%rax, %rbx	# _137, _137
.L644:
# inputs/bootstrap/source/falcon-keygen.c:6370: 		memmove(x, y, slen * sizeof *y);
	movq	%r13, %rdx	# _136,
	movq	%r15, %rsi	# y,
	movq	%r12, %rdi	# x,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6368: 		u < (n << 1); u ++, x += slen, y += llen)
	addq	$1, %r14	#, u
# inputs/bootstrap/source/falcon-keygen.c:6368: 		u < (n << 1); u ++, x += slen, y += llen)
	addq	%r13, %r12	# _136, x
# inputs/bootstrap/source/falcon-keygen.c:6368: 		u < (n << 1); u ++, x += slen, y += llen)
	addq	%rbx, %r15	# _137, y
# inputs/bootstrap/source/falcon-keygen.c:6368: 		u < (n << 1); u ++, x += slen, y += llen)
	cmpq	%rbp, %r14	# _830, u
	jne	.L644	#,
# inputs/bootstrap/source/falcon-keygen.c:6389: 	return 1;
	movq	(%rsp), %rbx	# %sfp, FGlen
	movl	$1, %edx	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:6377: 	if (FGlen < slen) {
	movq	48(%rsp), %rax	# %sfp, slen
	cmpq	%rax, %rbx	# slen, FGlen
	jnb	.L586	#,
	movq	72(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %rcx	# fk_222(D)->tmp, _173
	leaq	(%rcx,%rbx,4), %rsi	#, ivtmp.1096
	addq	%r13, %rcx	# _136, ivtmp.1098
# inputs/bootstrap/source/falcon-keygen.c:6378: 		for (u = 0, x = fk->tmp; u < (n << 1); u ++, x += slen) {
	movl	$0, %r8d	#, u
.L646:
# inputs/bootstrap/source/falcon-keygen.c:6382: 			sign = -(x[FGlen - 1] >> 30) >> 1;
	movl	-4(%rsi), %edx	# MEM[(uint32_t *)_165 + -4B], _143
	shrl	$30, %edx	#, _143
# inputs/bootstrap/source/falcon-keygen.c:6382: 			sign = -(x[FGlen - 1] >> 30) >> 1;
	negl	%edx	# _144
# inputs/bootstrap/source/falcon-keygen.c:6382: 			sign = -(x[FGlen - 1] >> 30) >> 1;
	shrl	%edx	# sign
	movq	%rsi, %rax	# ivtmp.1096, ivtmp.1088
	.p2align 4
.L645:
# inputs/bootstrap/source/falcon-keygen.c:6384: 				x[v] = sign;
	movl	%edx, (%rax)	# sign, MEM[(uint32_t *)_157]
# inputs/bootstrap/source/falcon-keygen.c:6383: 			for (v = FGlen; v < slen; v ++) {
	addq	$4, %rax	#, ivtmp.1088
	cmpq	%rax, %rcx	# ivtmp.1088, ivtmp.1098
	jne	.L645	#,
# inputs/bootstrap/source/falcon-keygen.c:6378: 		for (u = 0, x = fk->tmp; u < (n << 1); u ++, x += slen) {
	addq	$1, %r8	#, u
# inputs/bootstrap/source/falcon-keygen.c:6378: 		for (u = 0, x = fk->tmp; u < (n << 1); u ++, x += slen) {
	addq	%r13, %rsi	# _136, ivtmp.1096
	addq	%r13, %rcx	# _136, ivtmp.1098
	cmpq	%rbp, %r8	# _830, u
	jne	.L646	#,
# inputs/bootstrap/source/falcon-keygen.c:6389: 	return 1;
	movl	$1, %edx	#, <retval>
	jmp	.L586	#
.L692:
# inputs/bootstrap/source/falcon-keygen.c:6294: 			return 0;
	movl	$0, %edx	#, <retval>
.L586:
# inputs/bootstrap/source/falcon-keygen.c:6390: }
	movl	%edx, %eax	# <retval>,
	addq	$312, %rsp	#,
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
.L657:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:6389: 	return 1;
	movl	$1, %edx	#, <retval>
	jmp	.L586	#
.L693:
# inputs/bootstrap/source/falcon-keygen.c:6310: 		scale_FG += scale_k;
	movl	12(%rsp), %edi	# %sfp, scale_FG
	addl	%r13d, %edi	# scale_k, scale_FG
.L647:
# inputs/bootstrap/source/falcon-keygen.c:6315: 		for (u = 0; u < n; u ++) {
	movl	$0, %r9d	#, u
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	$63, %r14d	#, tmp1108
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	%edi, 12(%rsp)	# scale_FG, %sfp
	movq	%rbx, 40(%rsp)	# FGlen, %sfp
	movq	64(%rsp), %rbx	# %sfp, n
	movq	32(%rsp), %r11	# %sfp, _814
	jmp	.L641	#
.L691:
# inputs/bootstrap/source/falcon-keygen.c:6296: 		scale_k = bitlength((uint32_t)(max_kx >> 31));
	movl	$0, %edi	#,
	call	bitlength	#
# inputs/bootstrap/source/falcon-keygen.c:6303: 		if (scale_k + scale_FG < maxbl_fg) {
	movl	12(%rsp), %esi	# %sfp, scale_FG
	leal	(%rsi,%rax), %edx	#, _1007
# inputs/bootstrap/source/falcon-keygen.c:6303: 		if (scale_k + scale_FG < maxbl_fg) {
	movl	56(%rsp), %esi	# %sfp, maxbl_fg
	cmpl	%esi, %edx	# maxbl_fg, _1007
	jb	.L648	#,
# inputs/bootstrap/source/falcon-keygen.c:6310: 		scale_FG += scale_k;
	movl	12(%rsp), %edi	# %sfp, scale_FG
	addl	%eax, %edi	# scale_k, scale_FG
	jmp	.L638	#
	.cfi_endproc
.LFE101:
	.size	solve_NTRU_intermediate, .-solve_NTRU_intermediate
	.globl	falcon_keygen_new
	.type	falcon_keygen_new, @function
falcon_keygen_new:
.LFB87:
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
	movl	%esi, 16(%rsp)	# ternary, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5153: 		return NULL;
	movl	$0, %r12d	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:5152: 	if (ternary != 0 && ternary != 1) {
	cmpl	$1, %esi	#, ternary
	ja	.L694	#,
	movl	%edi, %ebp	# tmp433, logn
# inputs/bootstrap/source/falcon-keygen.c:5155: 	if (ternary) {
	testl	%esi, %esi	# ternary
	je	.L696	#,
# inputs/bootstrap/source/falcon-keygen.c:5156: 		if (logn != 10) {
	cmpl	$10, %edi	#, logn
	jne	.L694	#,
# inputs/bootstrap/source/falcon-keygen.c:5164: 	fk = malloc(sizeof *fk);
	movl	$448, %edi	#,
	call	malloc@PLT	#
	movq	%rax, %r12	# tmp436, <retval>
# inputs/bootstrap/source/falcon-keygen.c:5165: 	if (fk == NULL) {
	testq	%rax, %rax	# <retval>
	je	.L694	#,
# inputs/bootstrap/source/falcon-keygen.c:5168: 	fk->logn = logn;
	movl	$10, (%r12)	#, fk_233->logn
# inputs/bootstrap/source/falcon-keygen.c:5169: 	fk->ternary = ternary;
	movl	$1, 4(%r12)	#, fk_233->ternary
# inputs/bootstrap/source/falcon-keygen.c:5170: 	shake_init(&fk->rng, 512);
	leaq	8(%r12), %rdi	#, _217
	movl	$512, %esi	#,
	call	shake_init@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5171: 	fk->seeded = 0;
	movl	$0, 424(%r12)	#, fk_233->seeded
# inputs/bootstrap/source/falcon-keygen.c:5172: 	fk->flipped = 0;
	movl	$0, 428(%r12)	#, fk_233->flipped
# inputs/bootstrap/source/falcon-keygen.c:4980: 	if (ternary && logn == 10) {
	movl	$1, %edi	#, _247
# inputs/bootstrap/source/falcon-keygen.c:4985: 		gmax = cur > gmax ? cur : gmax;
	movl	$286720, %ebx	#, gmax
.L718:
# inputs/bootstrap/source/falcon-keygen.c:4976: 	gmax = 0;
	movl	$0, %eax	#, ivtmp.1250
# inputs/bootstrap/source/falcon-keygen.c:5008: 				: MAX_BL_SMALL2[depth];
	leaq	MAX_BL_SMALL2(%rip), %r11	#, tmp423
# inputs/bootstrap/source/falcon-keygen.c:5011: 				: MAX_BL_SMALL2[depth + 1];
	leaq	8(%r11), %r10	#, tmp424
# inputs/bootstrap/source/falcon-keygen.c:5008: 				: MAX_BL_SMALL2[depth];
	leaq	MAX_BL_SMALL3(%rip), %r9	#, tmp425
# inputs/bootstrap/source/falcon-keygen.c:4997: 			n = (size_t)3 << (logn - 1);
	leal	-1(%rbp), %ecx	#, _37
# inputs/bootstrap/source/falcon-keygen.c:5000: 			cur = (2 * tn + 2 * n + 2 * dn) * sizeof(uint32_t);
	movl	$4, %r8d	#, tmp427
	salq	%cl, %r8	# _37, _41
# inputs/bootstrap/source/falcon-keygen.c:4998: 			dn = (size_t)1 << logn;
	movl	$1, %edx	#, tmp429
	movl	%ebp, %ecx	# logn, tmp462
	salq	%cl, %rdx	# tmp462, dn_39
# inputs/bootstrap/source/falcon-keygen.c:5000: 			cur = (2 * tn + 2 * n + 2 * dn) * sizeof(uint32_t);
	addq	%rdx, %r8	# dn_39, _42
# inputs/bootstrap/source/falcon-keygen.c:5000: 			cur = (2 * tn + 2 * n + 2 * dn) * sizeof(uint32_t);
	salq	$3, %r8	#, cur_43
	jmp	.L703	#
.L696:
# inputs/bootstrap/source/falcon-keygen.c:5160: 		if (logn < 1 || logn > 10) {
	leal	-1(%rdi), %eax	#, _2
# inputs/bootstrap/source/falcon-keygen.c:5160: 		if (logn < 1 || logn > 10) {
	cmpl	$9, %eax	#, _2
	ja	.L733	#,
# inputs/bootstrap/source/falcon-keygen.c:5164: 	fk = malloc(sizeof *fk);
	movl	$448, %edi	#,
	call	malloc@PLT	#
	movq	%rax, %r12	# tmp437, <retval>
# inputs/bootstrap/source/falcon-keygen.c:5165: 	if (fk == NULL) {
	testq	%rax, %rax	# <retval>
	je	.L694	#,
# inputs/bootstrap/source/falcon-keygen.c:5168: 	fk->logn = logn;
	movl	%ebp, (%r12)	# logn, fk_244->logn
# inputs/bootstrap/source/falcon-keygen.c:5169: 	fk->ternary = ternary;
	movl	$0, 4(%r12)	#, fk_244->ternary
# inputs/bootstrap/source/falcon-keygen.c:5170: 	shake_init(&fk->rng, 512);
	leaq	8(%r12), %rdi	#, _236
	movl	$512, %esi	#,
	call	shake_init@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5171: 	fk->seeded = 0;
	movl	$0, 424(%r12)	#, fk_244->seeded
# inputs/bootstrap/source/falcon-keygen.c:5172: 	fk->flipped = 0;
	movl	$0, 428(%r12)	#, fk_244->flipped
# inputs/bootstrap/source/falcon-keygen.c:4980: 	if (ternary && logn == 10) {
	movl	$0, %edi	#, _247
# inputs/bootstrap/source/falcon-keygen.c:4976: 	gmax = 0;
	movl	$0, %ebx	#, gmax
	jmp	.L718	#
.L735:
# inputs/bootstrap/source/falcon-keygen.c:5001: 			gmax = cur > gmax ? cur : gmax;
	cmpq	%r8, %rbx	# cur_43, gmax
	cmovb	%r8, %rbx	# gmax,, cur_43, gmax
.L700:
# inputs/bootstrap/source/falcon-keygen.c:4991: 	for (depth = 0; depth < logn; depth ++) {
	addq	$1, %rax	#, ivtmp.1250
	cmpl	%ebp, %eax	# logn, ivtmp.1250
	jnb	.L734	#,
.L703:
	movl	%eax, %edx	# ivtmp.1250, depth
# inputs/bootstrap/source/falcon-keygen.c:4994: 		if (depth == 0 && ternary) {
	testl	%eax, %eax	# ivtmp.1250
	jne	.L699	#,
	testb	%dil, %dil	# _247
	jne	.L735	#,
.L699:
# inputs/bootstrap/source/falcon-keygen.c:5005: 			n = (size_t)1 << (logn - depth);
	movl	%ebp, %ecx	# logn, _46
	subl	%edx, %ecx	# depth, _46
# inputs/bootstrap/source/falcon-keygen.c:5008: 				: MAX_BL_SMALL2[depth];
	testb	%dil, %dil	# _247
	je	.L701	#,
# inputs/bootstrap/source/falcon-keygen.c:5008: 				: MAX_BL_SMALL2[depth];
	movq	(%r9,%rax,8), %rsi	# MEM[(long unsigned int *)&MAX_BL_SMALL3 + ivtmp.1250_151 * 8], iftmp.2_47
# inputs/bootstrap/source/falcon-keygen.c:5011: 				: MAX_BL_SMALL2[depth + 1];
	leaq	8+MAX_BL_SMALL3(%rip), %rdx	#, tmp264
	movq	(%rdx,%rax,8), %rdx	# MEM[(long unsigned int *)&MAX_BL_SMALL3 + 8B + ivtmp.1250_151 * 8], iftmp.3_49
.L702:
# inputs/bootstrap/source/falcon-keygen.c:5012: 			cur = (n * tlen + 2 * n * slen + 3 * n)
	movq	%rsi, %r13	# iftmp.2_47, _56
	salq	%cl, %r13	# _46, _56
# inputs/bootstrap/source/falcon-keygen.c:5012: 			cur = (n * tlen + 2 * n * slen + 3 * n)
	salq	%cl, %rdx	# _46, _54
# inputs/bootstrap/source/falcon-keygen.c:5012: 			cur = (n * tlen + 2 * n * slen + 3 * n)
	leaq	(%rdx,%r13,2), %r13	#, _58
# inputs/bootstrap/source/falcon-keygen.c:5012: 			cur = (n * tlen + 2 * n * slen + 3 * n)
	movl	$3, %edx	#, tmp272
	salq	%cl, %rdx	# _46, _59
# inputs/bootstrap/source/falcon-keygen.c:5012: 			cur = (n * tlen + 2 * n * slen + 3 * n)
	addq	%r13, %rdx	# _58, _60
# inputs/bootstrap/source/falcon-keygen.c:5012: 			cur = (n * tlen + 2 * n * slen + 3 * n)
	salq	$2, %rdx	#, cur_61
# inputs/bootstrap/source/falcon-keygen.c:5015: 			cur = (n * tlen + 2 * n * slen + slen)
	addq	%r13, %rsi	# _58, _63
# inputs/bootstrap/source/falcon-keygen.c:5015: 			cur = (n * tlen + 2 * n * slen + slen)
	salq	$2, %rsi	#, cur_64
# inputs/bootstrap/source/falcon-keygen.c:5017: 			gmax = cur > gmax ? cur : gmax;
	cmpq	%rsi, %rdx	# cur_64, cur_61
	cmovb	%rsi, %rdx	# cur_61,, cur_64, _33
	cmpq	%rdx, %rbx	# _33, gmax
	cmovb	%rdx, %rbx	# gmax,, _33, gmax
	jmp	.L700	#
.L701:
# inputs/bootstrap/source/falcon-keygen.c:5008: 				: MAX_BL_SMALL2[depth];
	movq	(%r11,%rax,8), %rsi	# MEM[(long unsigned int *)&MAX_BL_SMALL2 + ivtmp.1250_151 * 8], iftmp.2_47
# inputs/bootstrap/source/falcon-keygen.c:5011: 				: MAX_BL_SMALL2[depth + 1];
	movq	(%r10,%rax,8), %rdx	# MEM[(long unsigned int *)&MAX_BL_SMALL2 + 8B + ivtmp.1250_151 * 8], iftmp.3_49
	jmp	.L702	#
.L734:
# inputs/bootstrap/source/falcon-keygen.c:5036: 		} else if (ternary && depth == 0 && logn > 2) {
	cmpl	$2, %ebp	#, logn
	seta	%r10b	#, _40
# inputs/bootstrap/source/falcon-keygen.c:5063: 		} else if (!ternary && depth == 1 && logn > 2) {
	cmpl	$0, 16(%rsp)	#, %sfp
	sete	%al	#, _112
	andl	%r10d, %eax	# _40, _112
	movb	%al, 22(%rsp)	# _112, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5094: 			if (ternary && depth == 0 && logn == 2) {
	cmpl	$2, %ebp	#, logn
	sete	23(%rsp)	#, %sfp
	movl	%ebp, %eax	# logn, _62
	movq	%rax, (%rsp)	# _62, %sfp
	movl	$0, %edx	#, ivtmp.1241
# inputs/bootstrap/source/falcon-keygen.c:5057: 			cur = ALIGN_FP(4 * n * sizeof(uint32_t))
	movl	$16, %eax	#, tmp413
	movl	%ebp, %ecx	# logn, tmp469
	salq	%cl, %rax	# tmp469, _99
	addq	$7, %rax	#, _100
	andq	$-8, %rax	#, _101
# inputs/bootstrap/source/falcon-keygen.c:5058: 				+ n * sizeof(fpr);
	movl	$8, %esi	#, _102
	salq	%cl, %rsi	# tmp471, _102
# inputs/bootstrap/source/falcon-keygen.c:5057: 			cur = ALIGN_FP(4 * n * sizeof(uint32_t))
	addq	%rsi, %rax	# _102, cur_103
# inputs/bootstrap/source/falcon-keygen.c:5055: 			cur = 7 * n * sizeof(uint32_t);
	movl	$28, %esi	#, tmp420
	salq	%cl, %rsi	# tmp473, tmp420
	movq	%rsi, %rcx	# tmp420, cur_98
# inputs/bootstrap/source/falcon-keygen.c:5059: 			max = cur > max ? cur : max;
	cmpq	%rsi, %rax	# cur_98, cur_103
	cmovnb	%rax, %rcx	# cur_103,, cur_98
	movq	%rcx, 24(%rsp)	# cur_98, %sfp
	movq	%r12, 8(%rsp)	# <retval>, %sfp
	jmp	.L716	#
.L738:
# inputs/bootstrap/source/falcon-keygen.c:5033: 				: MAX_BL_SMALL2[depth];
	movq	8(%rsp), %r12	# %sfp, <retval>
	testb	%dil, %dil	# _247
	je	.L705	#,
# inputs/bootstrap/source/falcon-keygen.c:5033: 				: MAX_BL_SMALL2[depth];
	movl	%edx, %esi	# _34, _34
	leaq	MAX_BL_SMALL3(%rip), %rax	#, tmp281
	movq	(%rax,%rsi,8), %rax	# MAX_BL_SMALL3[_34], iftmp.4_68
.L706:
# inputs/bootstrap/source/falcon-keygen.c:5034: 			cur = 8 * slen * sizeof(uint32_t);
	salq	$5, %rax	#, cur_71
# inputs/bootstrap/source/falcon-keygen.c:5133: 		gmax = max > gmax ? max : gmax;
	cmpq	%rax, %rbx	# cur_71, gmax
	cmovb	%rax, %rbx	# gmax,, cur_71, gmax
.L707:
# inputs/bootstrap/source/falcon-keygen.c:5174: 	fk->tmp_len = temp_size(logn, ternary);
	movq	%rbx, 440(%r12)	# gmax, fk_245->tmp_len
# inputs/bootstrap/source/falcon-keygen.c:5176: 	fk->tmp = malloc(fk->tmp_len + sizeof MEMCHECK_MARK);
	leaq	9(%rbx), %rdi	#, _5
	call	malloc@PLT	#
	movq	%rax, %rbp	# tmp435, _6
# inputs/bootstrap/source/falcon-keygen.c:5176: 	fk->tmp = malloc(fk->tmp_len + sizeof MEMCHECK_MARK);
	movq	%rax, 432(%r12)	# _6, fk_245->tmp
# inputs/bootstrap/source/falcon-keygen.c:5180: 	if (fk->tmp == NULL) {
	testq	%rax, %rax	# _6
	je	.L736	#,
# inputs/bootstrap/source/falcon-keygen.c:5185: 	memcpy((unsigned char *)fk->tmp + fk->tmp_len,
	movq	MEMCHECK_MARK(%rip), %rax	# MEM <unsigned char[9]> [(char * {ref-all})&MEMCHECK_MARK], MEM <unsigned char[9]> [(char * {ref-all})&MEMCHECK_MARK]
	movq	%rax, 0(%rbp,%rbx)	# MEM <unsigned char[9]> [(char * {ref-all})&MEMCHECK_MARK], MEM <unsigned char[9]> [(char * {ref-all})_7]
	movzbl	8+MEMCHECK_MARK(%rip), %eax	# MEM <unsigned char[9]> [(char * {ref-all})&MEMCHECK_MARK], MEM <unsigned char[9]> [(char * {ref-all})&MEMCHECK_MARK]
	movb	%al, 8(%rbp,%rbx)	# MEM <unsigned char[9]> [(char * {ref-all})&MEMCHECK_MARK], MEM <unsigned char[9]> [(char * {ref-all})_7]
.L694:
# inputs/bootstrap/source/falcon-keygen.c:5190: }
	movq	%r12, %rax	# <retval>,
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
.L705:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:5033: 				: MAX_BL_SMALL2[depth];
	movl	%edx, %esi	# _34, _34
	leaq	MAX_BL_SMALL2(%rip), %rax	#, tmp283
	movq	(%rax,%rsi,8), %rax	# MAX_BL_SMALL2[_34], iftmp.4_68
	jmp	.L706	#
.L739:
# inputs/bootstrap/source/falcon-keygen.c:5039: 			n = (size_t)3 << (logn - 1);
	leal	-1(%rbp), %ecx	#, _74
# inputs/bootstrap/source/falcon-keygen.c:5039: 			n = (size_t)3 << (logn - 1);
	movl	$3, %eax	#, tmp288
	salq	%cl, %rax	# _74, n
# inputs/bootstrap/source/falcon-keygen.c:5043: 				+ (2 * n + hn) * sizeof(fpr);
	leaq	(%rax,%rax), %rsi	#, _80
# inputs/bootstrap/source/falcon-keygen.c:5041: 			hn = n >> 1;
	movq	%rax, %r8	# n, hn_76
	shrq	%r8	# hn_76
# inputs/bootstrap/source/falcon-keygen.c:5043: 				+ (2 * n + hn) * sizeof(fpr);
	addq	%rsi, %r8	# _80, _81
# inputs/bootstrap/source/falcon-keygen.c:5042: 			cur = ALIGN_FP(2 * tn * sizeof(uint32_t))
	movl	$8, %r15d	#, _77
	salq	%cl, %r15	# _74, _77
	movq	%r15, %rcx	# _77, _77
	addq	$7, %rcx	#, _78
	andq	$-8, %rcx	#, _79
# inputs/bootstrap/source/falcon-keygen.c:5042: 			cur = ALIGN_FP(2 * tn * sizeof(uint32_t))
	leaq	(%rcx,%r8,8), %rcx	#, cur_83
# inputs/bootstrap/source/falcon-keygen.c:5048: 				+ 2 * n * sizeof(fpr);
	movq	%rax, %r9	# n, _91
	salq	$4, %r9	#, _91
# inputs/bootstrap/source/falcon-keygen.c:5047: 			cur = ALIGN_FP(2 * n * sizeof(uint32_t))
	leaq	(%r9,%rax,8), %rax	#, cur_92
# inputs/bootstrap/source/falcon-keygen.c:5049: 			max = cur > max ? cur : max;
	cmpq	%rax, %rcx	# cur_92, cur_83
	cmovnb	%rcx, %rax	# cur_83,, _44
# inputs/bootstrap/source/falcon-keygen.c:5045: 			cur = (hn + 4 * n) * sizeof(fpr);
	addq	%r8, %rsi	# _81, _85
# inputs/bootstrap/source/falcon-keygen.c:5045: 			cur = (hn + 4 * n) * sizeof(fpr);
	salq	$3, %rsi	#, cur_86
# inputs/bootstrap/source/falcon-keygen.c:5049: 			max = cur > max ? cur : max;
	cmpq	%rsi, %rax	# cur_86, _44
	cmovb	%rsi, %rax	# _44,, cur_86, max
# inputs/bootstrap/source/falcon-keygen.c:5036: 		} else if (ternary && depth == 0 && logn > 2) {
	jmp	.L709	#
.L740:
# inputs/bootstrap/source/falcon-keygen.c:5053: 			n = (size_t)1 << logn;
	movl	$1, %esi	#, tmp307
	movl	%ebp, %ecx	# logn, tmp480
	salq	%cl, %rsi	# tmp480, n
# inputs/bootstrap/source/falcon-keygen.c:5060: 			cur = ALIGN_FP(3 * n * sizeof(uint32_t))
	movl	$12, %eax	#, tmp318
	salq	%cl, %rax	# tmp481, _105
	addq	$7, %rax	#, _106
	andq	$-8, %rax	#, _107
# inputs/bootstrap/source/falcon-keygen.c:5054: 			hn = n >> 1;
	movq	%rsi, %rcx	# n, hn_97
	shrq	%rcx	# hn_97
# inputs/bootstrap/source/falcon-keygen.c:5061: 				+ (n + hn) * sizeof(fpr);
	addq	%rsi, %rcx	# n, _108
# inputs/bootstrap/source/falcon-keygen.c:5060: 			cur = ALIGN_FP(3 * n * sizeof(uint32_t))
	leaq	(%rax,%rcx,8), %rax	#, cur_110
# inputs/bootstrap/source/falcon-keygen.c:5062: 			max = cur > max ? cur : max;
	movq	24(%rsp), %rcx	# %sfp, max
	cmpq	%rcx, %rax	# max, cur_110
	cmovb	%rcx, %rax	# cur_110,, max, max
# inputs/bootstrap/source/falcon-keygen.c:5050: 		} else if (!ternary && depth == 0 && logn > 2) {
	jmp	.L709	#
.L741:
# inputs/bootstrap/source/falcon-keygen.c:5066: 			n = (size_t)1 << (logn - 1);
	leal	-1(%rbp), %ecx	#, _115
# inputs/bootstrap/source/falcon-keygen.c:5066: 			n = (size_t)1 << (logn - 1);
	movl	$1, %r9d	#, tmp328
	salq	%cl, %r9	# _115, n_116
# inputs/bootstrap/source/falcon-keygen.c:5067: 			hn = n >> 1;
	shrq	%r9	# hn
# inputs/bootstrap/source/falcon-keygen.c:5073: 			cur = (2 * n * llen + 2 * n * slen + 7 * n)
	movl	$24, %esi	#, _127
# inputs/bootstrap/source/falcon-keygen.c:5074: 				* sizeof(uint32_t);
	salq	%cl, %rsi	# _115, _128
# inputs/bootstrap/source/falcon-keygen.c:5081: 				+ 2 * n * sizeof(fpr);
	movl	$16, %r11d	#, tmp331
	salq	%cl, %r11	# _115, _138
# inputs/bootstrap/source/falcon-keygen.c:5083: 			cur = ALIGN_FP(2 * n * slen * sizeof(uint32_t))
	movl	$8, %r8d	#, tmp333
	salq	%cl, %r8	# _115, _142
	addq	$7, %r8	#, _143
	andq	$-8, %r8	#, _144
# inputs/bootstrap/source/falcon-keygen.c:5074: 				* sizeof(uint32_t);
	movl	$28, %eax	#, tmp341
	salq	%cl, %rax	# _115, _129
# inputs/bootstrap/source/falcon-keygen.c:5073: 			cur = (2 * n * llen + 2 * n * slen + 7 * n)
	addq	%rsi, %rax	# _128, cur_130
# inputs/bootstrap/source/falcon-keygen.c:5076: 			cur = (2 * n * llen + 2 * n * slen + llen)
	leaq	8(%rsi), %r12	#, cur_134
# inputs/bootstrap/source/falcon-keygen.c:5090: 			max = cur > max ? cur : max;
	cmpq	%r12, %rax	# cur_134, cur_130
	cmovb	%r12, %rax	# cur_130,, cur_134, _210
# inputs/bootstrap/source/falcon-keygen.c:5084: 				+ 4 * n * sizeof(fpr);
	movl	$32, %r12d	#, tmp345
	salq	%cl, %r12	# _115, _145
# inputs/bootstrap/source/falcon-keygen.c:5083: 			cur = ALIGN_FP(2 * n * slen * sizeof(uint32_t))
	addq	%r8, %r12	# _144, cur_146
# inputs/bootstrap/source/falcon-keygen.c:5090: 			max = cur > max ? cur : max;
	cmpq	%r12, %rax	# cur_146, _210
	cmovnb	%rax, %r12	# _210,, _215
# inputs/bootstrap/source/falcon-keygen.c:5086: 			cur = (5 * n + hn) * sizeof(fpr);
	movl	$5, %eax	#, tmp348
	salq	%cl, %rax	# _115, _148
# inputs/bootstrap/source/falcon-keygen.c:5086: 			cur = (5 * n + hn) * sizeof(fpr);
	addq	%r9, %rax	# hn, _149
# inputs/bootstrap/source/falcon-keygen.c:5086: 			cur = (5 * n + hn) * sizeof(fpr);
	salq	$3, %rax	#, cur_150
# inputs/bootstrap/source/falcon-keygen.c:5090: 			max = cur > max ? cur : max;
	cmpq	%rax, %r12	# cur_150, _215
	cmovnb	%r12, %rax	# _215,, _220
# inputs/bootstrap/source/falcon-keygen.c:5088: 			cur = ALIGN_FP(2 * n * sizeof(uint32_t))
	addq	%r11, %r8	# _138, cur_155
# inputs/bootstrap/source/falcon-keygen.c:5090: 			max = cur > max ? cur : max;
	cmpq	%r8, %rax	# cur_155, _220
	cmovb	%r8, %rax	# _220,, cur_155, _48
# inputs/bootstrap/source/falcon-keygen.c:5071: 			cur = (2 * hn * dlen + 2 * n * llen) * sizeof(uint32_t);
	movl	$2, %r8d	#, tmp354
	salq	%cl, %r8	# _115, _123
# inputs/bootstrap/source/falcon-keygen.c:5071: 			cur = (2 * hn * dlen + 2 * n * llen) * sizeof(uint32_t);
	leaq	(%r8,%r9,2), %rcx	#, _124
# inputs/bootstrap/source/falcon-keygen.c:5071: 			cur = (2 * hn * dlen + 2 * n * llen) * sizeof(uint32_t);
	salq	$3, %rcx	#, cur_125
# inputs/bootstrap/source/falcon-keygen.c:5090: 			max = cur > max ? cur : max;
	cmpq	%rcx, %rax	# cur_125, _48
	cmovb	%rcx, %rax	# _48,, cur_125, _51
# inputs/bootstrap/source/falcon-keygen.c:5079: 			cur = ALIGN_FP((2 * n * llen + 2 * n * slen)
	addq	$7, %rsi	#, _136
	andq	$-8, %rsi	#, _137
# inputs/bootstrap/source/falcon-keygen.c:5079: 			cur = ALIGN_FP((2 * n * llen + 2 * n * slen)
	addq	%r11, %rsi	# _138, cur_139
# inputs/bootstrap/source/falcon-keygen.c:5090: 			max = cur > max ? cur : max;
	cmpq	%rsi, %rax	# cur_139, _51
	cmovb	%rsi, %rax	# _51,, cur_139, max
# inputs/bootstrap/source/falcon-keygen.c:5063: 		} else if (!ternary && depth == 1 && logn > 2) {
	jmp	.L709	#
.L724:
# inputs/bootstrap/source/falcon-keygen.c:5096: 				hn = 2;
	movl	$2, %r9d	#, hn
# inputs/bootstrap/source/falcon-keygen.c:5095: 				n = 6;
	movl	$6, %esi	#, n
.L712:
# inputs/bootstrap/source/falcon-keygen.c:5102: 				slen = MAX_BL_SMALL3[depth];
	leaq	MAX_BL_SMALL3(%rip), %rax	#, tmp362
	movq	(%rax,%rdx,8), %rcx	# MEM[(long unsigned int *)&MAX_BL_SMALL3 + ivtmp.1241_231 * 8], slen
# inputs/bootstrap/source/falcon-keygen.c:5103: 				llen = MAX_BL_LARGE3[depth];
	leaq	MAX_BL_LARGE3(%rip), %rax	#, tmp363
	movq	(%rax,%rdx,8), %r15	# MEM[(long unsigned int *)&MAX_BL_LARGE3 + ivtmp.1241_231 * 8], llen
.L715:
# inputs/bootstrap/source/falcon-keygen.c:5108: 			cur = (2 * n * llen + 2 * n * slen + 4 * n)
	leaq	(%rcx,%r15), %rax	#, _166
	leaq	0(,%rsi,8), %r8	#, _133
# inputs/bootstrap/source/falcon-keygen.c:5111: 			cur = (2 * n * llen + 2 * n * slen + llen)
	movq	%rax, %r13	# _166, _171
	imulq	%rsi, %r13	# n, _171
# inputs/bootstrap/source/falcon-keygen.c:5114: 			tmp1 = ALIGN_UW(
	leaq	0(,%r13,8), %r14	#, _178
	leaq	(%r9,%rsi,2), %r9	#, _181
	leaq	(%r14,%r9,8), %r11	#, _185
# inputs/bootstrap/source/falcon-keygen.c:5118: 				+ n * sizeof(uint32_t);
	leaq	0(,%rsi,4), %r12	#, _186
# inputs/bootstrap/source/falcon-keygen.c:5121: 				+ (3 * n + hn) * sizeof(fpr);
	addq	%rsi, %r9	# n, _189
# inputs/bootstrap/source/falcon-keygen.c:5119: 			tmp2 = ALIGN_FP((2 * n * llen + 2 * n * slen)
	leaq	(%r14,%r9,8), %rsi	#, tmp2_191
# inputs/bootstrap/source/falcon-keygen.c:5114: 			tmp1 = ALIGN_UW(
	leaq	(%r11,%r12), %r9	#, tmp1_187
# inputs/bootstrap/source/falcon-keygen.c:5122: 			cur = tmp1 > tmp2 ? tmp1 : tmp2;
	cmpq	%r9, %rsi	# tmp1_187, tmp2_191
	cmovb	%r9, %rsi	# tmp2_191,, tmp1_187, cur_192
# inputs/bootstrap/source/falcon-keygen.c:5123: 			cur = ALIGN_FP(cur) + n * sizeof(fpr);
	addq	$7, %rsi	#, _193
	andq	$-8, %rsi	#, _194
# inputs/bootstrap/source/falcon-keygen.c:5111: 			cur = (2 * n * llen + 2 * n * slen + llen)
	leaq	(%r15,%r13,2), %r9	#, _173
# inputs/bootstrap/source/falcon-keygen.c:5111: 			cur = (2 * n * llen + 2 * n * slen + llen)
	salq	$2, %r9	#, cur_174
# inputs/bootstrap/source/falcon-keygen.c:5108: 			cur = (2 * n * llen + 2 * n * slen + 4 * n)
	addq	$2, %rax	#, _167
# inputs/bootstrap/source/falcon-keygen.c:5108: 			cur = (2 * n * llen + 2 * n * slen + 4 * n)
	imulq	%r8, %rax	# _133, cur_170
# inputs/bootstrap/source/falcon-keygen.c:5130: 			max = cur > max ? cur : max;
	cmpq	%rax, %r9	# cur_170, cur_174
	cmovnb	%r9, %rax	# cur_174,, _222
# inputs/bootstrap/source/falcon-keygen.c:5129: 				+ (5 * n + n * slen) * sizeof(uint32_t);
	addq	$5, %rcx	#, _198
# inputs/bootstrap/source/falcon-keygen.c:5129: 				+ (5 * n + n * slen) * sizeof(uint32_t);
	imulq	%r12, %rcx	# _186, _200
# inputs/bootstrap/source/falcon-keygen.c:5125: 			cur = ALIGN_UW(
	addq	%r11, %rcx	# _185, cur_201
# inputs/bootstrap/source/falcon-keygen.c:5130: 			max = cur > max ? cur : max;
	cmpq	%rcx, %rax	# cur_201, _222
	cmovb	%rcx, %rax	# _222,, cur_201, _218
# inputs/bootstrap/source/falcon-keygen.c:5123: 			cur = ALIGN_FP(cur) + n * sizeof(fpr);
	addq	%rsi, %r8	# _194, cur_196
# inputs/bootstrap/source/falcon-keygen.c:5130: 			max = cur > max ? cur : max;
	cmpq	%r8, %rax	# cur_196, _218
	cmovb	%r8, %rax	# _218,, cur_196, max
.L709:
# inputs/bootstrap/source/falcon-keygen.c:5133: 		gmax = max > gmax ? max : gmax;
	cmpq	%rax, %rbx	# max, gmax
	cmovb	%rax, %rbx	# gmax,, max, gmax
# inputs/bootstrap/source/falcon-keygen.c:5024: 	for (depth = 0; depth <= logn; depth ++) {
	addq	$1, %rdx	#, ivtmp.1241
	cmpl	%edx, %ebp	# ivtmp.1241, logn
	jb	.L737	#,
.L716:
	movl	%edx, %esi	# ivtmp.1241, _34
# inputs/bootstrap/source/falcon-keygen.c:5028: 		if (depth == logn) {
	cmpq	%rdx, (%rsp)	# ivtmp.1241, %sfp
	je	.L738	#,
# inputs/bootstrap/source/falcon-keygen.c:5036: 		} else if (ternary && depth == 0 && logn > 2) {
	testl	%edx, %edx	# ivtmp.1241
	sete	%al	#, _72
# inputs/bootstrap/source/falcon-keygen.c:5036: 		} else if (ternary && depth == 0 && logn > 2) {
	andl	%edi, %eax	# _247, _73
# inputs/bootstrap/source/falcon-keygen.c:5036: 		} else if (ternary && depth == 0 && logn > 2) {
	testb	%r10b, %r10b	# _40
	je	.L708	#,
	testb	%al, %al	# _73
	jne	.L739	#,
.L708:
# inputs/bootstrap/source/falcon-keygen.c:5050: 		} else if (!ternary && depth == 0 && logn > 2) {
	movl	16(%rsp), %ecx	# %sfp, tmp445
	orl	%edx, %ecx	# ivtmp.1241, tmp445
	jne	.L710	#,
	testb	%r10b, %r10b	# _40
	jne	.L740	#,
.L710:
# inputs/bootstrap/source/falcon-keygen.c:5063: 		} else if (!ternary && depth == 1 && logn > 2) {
	cmpl	$1, %esi	#, _34
	jne	.L711	#,
	cmpb	$0, 22(%rsp)	#, %sfp
	jne	.L741	#,
.L711:
# inputs/bootstrap/source/falcon-keygen.c:5094: 			if (ternary && depth == 0 && logn == 2) {
	testb	%al, %al	# _73
	je	.L725	#,
	cmpb	$0, 23(%rsp)	#, %sfp
	jne	.L724	#,
.L725:
# inputs/bootstrap/source/falcon-keygen.c:5098: 				n = (size_t)1 << (logn - depth);
	movl	%ebp, %ecx	# logn, _157
	subl	%esi, %ecx	# _34, _157
# inputs/bootstrap/source/falcon-keygen.c:5098: 				n = (size_t)1 << (logn - depth);
	movl	$1, %esi	#, tmp361
	salq	%cl, %rsi	# _157, n
# inputs/bootstrap/source/falcon-keygen.c:5099: 				hn = n >> 1;
	movq	%rsi, %r9	# n, hn
	shrq	%r9	# hn
# inputs/bootstrap/source/falcon-keygen.c:5101: 			if (ternary) {
	testb	%dil, %dil	# _247
	jne	.L712	#,
# inputs/bootstrap/source/falcon-keygen.c:5105: 				slen = MAX_BL_SMALL2[depth];
	leaq	MAX_BL_SMALL2(%rip), %rax	#, tmp364
	movq	(%rax,%rdx,8), %rcx	# MEM[(long unsigned int *)&MAX_BL_SMALL2 + ivtmp.1241_231 * 8], slen
# inputs/bootstrap/source/falcon-keygen.c:5106: 				llen = MAX_BL_LARGE2[depth];
	leaq	MAX_BL_LARGE2(%rip), %rax	#, tmp365
	movq	(%rax,%rdx,8), %r15	# MEM[(long unsigned int *)&MAX_BL_LARGE2 + ivtmp.1241_231 * 8], llen
	jmp	.L715	#
.L737:
	movq	8(%rsp), %r12	# %sfp, <retval>
	jmp	.L707	#
.L736:
# inputs/bootstrap/source/falcon-keygen.c:5181: 		free(fk);
	movq	%r12, %rdi	# <retval>,
	call	free@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5182: 		return NULL;
	movq	%rbp, %r12	# _6, <retval>
	jmp	.L694	#
.L733:
# inputs/bootstrap/source/falcon-keygen.c:5161: 			return NULL;
	movl	$0, %r12d	#, <retval>
	jmp	.L694	#
	.cfi_endproc
.LFE87:
	.size	falcon_keygen_new, .-falcon_keygen_new
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"buffer overflow! temp_size() is wrong\n"
	.text
	.globl	falcon_keygen_free
	.type	falcon_keygen_free, @function
falcon_keygen_free:
.LFB88:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:5196: 	if (fk != NULL) {
	testq	%rdi, %rdi	# fk
	je	.L749	#,
# inputs/bootstrap/source/falcon-keygen.c:5195: {
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx	#
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbx	# tmp118, fk
# inputs/bootstrap/source/falcon-keygen.c:5198: 		cleanse(fk->tmp, fk->tmp_len);
	movq	440(%rdi), %rcx	# fk_9(D)->tmp_len, _1
# inputs/bootstrap/source/falcon-keygen.c:5198: 		cleanse(fk->tmp, fk->tmp_len);
	movq	432(%rdi), %rax	# fk_9(D)->tmp, p
# inputs/bootstrap/source/falcon-keygen.c:530: 	while (len -- > 0) {
	testq	%rcx, %rcx	# _1
	je	.L744	#,
	addq	%rax, %rcx	# p, _16
	.p2align 4
.L745:
	movq	%rax, %rdx	# p, p
# inputs/bootstrap/source/falcon-keygen.c:531: 		*p ++ = 0;
	addq	$1, %rax	#, p
# inputs/bootstrap/source/falcon-keygen.c:531: 		*p ++ = 0;
	movb	$0, (%rdx)	#, *p_24
# inputs/bootstrap/source/falcon-keygen.c:530: 	while (len -- > 0) {
	cmpq	%rax, %rcx	# p, _16
	jne	.L745	#,
.L744:
# inputs/bootstrap/source/falcon-keygen.c:5201: 		if (memcmp((unsigned char *)fk->tmp + fk->tmp_len,
	movq	432(%rbx), %rbp	# fk_9(D)->tmp, _3
# inputs/bootstrap/source/falcon-keygen.c:5201: 		if (memcmp((unsigned char *)fk->tmp + fk->tmp_len,
	movq	%rbp, %rdi	# _3, _5
	addq	440(%rbx), %rdi	# fk_9(D)->tmp_len, _5
	movl	$9, %edx	#,
	leaq	MEMCHECK_MARK(%rip), %rsi	#, tmp113
	call	memcmp@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5201: 		if (memcmp((unsigned char *)fk->tmp + fk->tmp_len,
	testl	%eax, %eax	# tmp119
	jne	.L752	#,
# inputs/bootstrap/source/falcon-keygen.c:5209: 		free(fk->tmp);
	movq	%rbp, %rdi	# _3,
	call	free@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5210: 		free(fk);
	movq	%rbx, %rdi	# fk,
	call	free@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5212: }
	addq	$8, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx	#
	.cfi_def_cfa_offset 16
	popq	%rbp	#
	.cfi_def_cfa_offset 8
	ret	
.L752:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:5204: 			fprintf(stderr,
	movq	stderr(%rip), %rcx	# stderr,
	movl	$38, %edx	#,
	movl	$1, %esi	#,
	leaq	.LC0(%rip), %rdi	#, tmp117
	call	fwrite@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5206: 			abort();
	call	abort@PLT	#
.L749:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	ret	
	.cfi_endproc
.LFE88:
	.size	falcon_keygen_free, .-falcon_keygen_free
	.globl	falcon_keygen_max_privkey_size
	.type	falcon_keygen_max_privkey_size, @function
falcon_keygen_max_privkey_size:
.LFB89:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:5225: 	logn = fk->logn;
	movl	(%rdi), %ecx	# fk_6(D)->logn, logn
# inputs/bootstrap/source/falcon-keygen.c:5226: 	n = fk->ternary ? ((size_t)3 << (logn - 1)) : ((size_t)1 << logn);
	cmpl	$0, 4(%rdi)	#, fk_6(D)->ternary
	je	.L754	#,
# inputs/bootstrap/source/falcon-keygen.c:5226: 	n = fk->ternary ? ((size_t)3 << (logn - 1)) : ((size_t)1 << logn);
	subl	$1, %ecx	#, _2
# inputs/bootstrap/source/falcon-keygen.c:5226: 	n = fk->ternary ? ((size_t)3 << (logn - 1)) : ((size_t)1 << logn);
	movl	$3, %eax	#, tmp106
	salq	%cl, %rax	# _2, iftmp.8_4
.L755:
# inputs/bootstrap/source/falcon-keygen.c:5227: 	return 1 + (n << 3);
	leaq	1(,%rax,8), %rax	#, _10
# inputs/bootstrap/source/falcon-keygen.c:5228: }
	ret	
.L754:
# inputs/bootstrap/source/falcon-keygen.c:5226: 	n = fk->ternary ? ((size_t)3 << (logn - 1)) : ((size_t)1 << logn);
	movl	$1, %eax	#, tmp107
	salq	%cl, %rax	# logn, iftmp.8_4
	jmp	.L755	#
	.cfi_endproc
.LFE89:
	.size	falcon_keygen_max_privkey_size, .-falcon_keygen_max_privkey_size
	.globl	falcon_keygen_max_pubkey_size
	.type	falcon_keygen_max_pubkey_size, @function
falcon_keygen_max_pubkey_size:
.LFB90:
	.cfi_startproc
# inputs/bootstrap/source/falcon-keygen.c:5242: 	logn = fk->logn;
	movl	(%rdi), %ecx	# fk_8(D)->logn, logn
# inputs/bootstrap/source/falcon-keygen.c:5243: 	z = fk->ternary ? (45U << (logn - 1)) : (14U << logn);
	cmpl	$0, 4(%rdi)	#, fk_8(D)->ternary
	je	.L757	#,
# inputs/bootstrap/source/falcon-keygen.c:5243: 	z = fk->ternary ? (45U << (logn - 1)) : (14U << logn);
	subl	$1, %ecx	#, _2
# inputs/bootstrap/source/falcon-keygen.c:5243: 	z = fk->ternary ? (45U << (logn - 1)) : (14U << logn);
	movl	$45, %eax	#, tmp108
	sall	%cl, %eax	# _2, iftmp.9_6
.L758:
# inputs/bootstrap/source/falcon-keygen.c:5244: 	return 1 + ((z + 7) >> 3);
	addl	$7, %eax	#, _3
# inputs/bootstrap/source/falcon-keygen.c:5244: 	return 1 + ((z + 7) >> 3);
	shrl	$3, %eax	#, _4
# inputs/bootstrap/source/falcon-keygen.c:5244: 	return 1 + ((z + 7) >> 3);
	addl	$1, %eax	#, _5
	movl	%eax, %eax	# _5, _12
# inputs/bootstrap/source/falcon-keygen.c:5245: }
	ret	
.L757:
# inputs/bootstrap/source/falcon-keygen.c:5243: 	z = fk->ternary ? (45U << (logn - 1)) : (14U << logn);
	movl	$14, %eax	#, tmp109
	sall	%cl, %eax	# logn, iftmp.9_6
	jmp	.L758	#
	.cfi_endproc
.LFE90:
	.size	falcon_keygen_max_pubkey_size, .-falcon_keygen_max_pubkey_size
	.globl	falcon_keygen_set_seed
	.type	falcon_keygen_set_seed, @function
falcon_keygen_set_seed:
.LFB91:
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
	movq	%rdi, %rbx	# tmp109, fk
	movq	%rsi, %r12	# tmp110, seed
	movq	%rdx, %rbp	# tmp111, len
# inputs/bootstrap/source/falcon-keygen.c:5252: 	if (replace) {
	testl	%ecx, %ecx	# tmp112
	jne	.L764	#,
# inputs/bootstrap/source/falcon-keygen.c:5259: 	if (fk->flipped) {
	cmpl	$0, 428(%rdi)	#, fk_9(D)->flipped
	jne	.L765	#,
.L762:
# inputs/bootstrap/source/falcon-keygen.c:5267: 	shake_inject(&fk->rng, seed, len);
	leaq	8(%rbx), %rdi	#, _4
	movq	%rbp, %rdx	# len,
	movq	%r12, %rsi	# seed,
	call	shake_inject@PLT	#
.L759:
# inputs/bootstrap/source/falcon-keygen.c:5268: }
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
.L764:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:5253: 		shake_init(&fk->rng, 512);
	leaq	8(%rdi), %r13	#, _1
	movl	$512, %esi	#,
	movq	%r13, %rdi	# _1,
	call	shake_init@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5254: 		shake_inject(&fk->rng, seed, len);
	movq	%rbp, %rdx	# len,
	movq	%r12, %rsi	# seed,
	movq	%r13, %rdi	# _1,
	call	shake_inject@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5255: 		fk->seeded = 1;
	movl	$1, 424(%rbx)	#, fk_9(D)->seeded
# inputs/bootstrap/source/falcon-keygen.c:5256: 		fk->flipped = 0;
	movl	$0, 428(%rbx)	#, fk_9(D)->flipped
# inputs/bootstrap/source/falcon-keygen.c:5257: 		return;
	jmp	.L759	#
.L765:
# inputs/bootstrap/source/falcon-keygen.c:5262: 		shake_extract(&fk->rng, tmp, sizeof tmp);
	leaq	8(%rdi), %r13	#, _3
	movl	$32, %edx	#,
	movq	%rsp, %rsi	#,
	movq	%r13, %rdi	# _3,
	call	shake_extract@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5263: 		shake_init(&fk->rng, 512);
	movl	$512, %esi	#,
	movq	%r13, %rdi	# _3,
	call	shake_init@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5264: 		shake_inject(&fk->rng, tmp, sizeof tmp);
	movl	$32, %edx	#,
	movq	%rsp, %rsi	#,
	movq	%r13, %rdi	# _3,
	call	shake_inject@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5265: 		fk->flipped = 0;
	movl	$0, 428(%rbx)	#, fk_9(D)->flipped
	jmp	.L762	#
	.cfi_endproc
.LFE91:
	.size	falcon_keygen_set_seed, .-falcon_keygen_set_seed
	.globl	falcon_keygen_make
	.type	falcon_keygen_make, @function
falcon_keygen_make:
.LFB120:
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
	subq	$31112, %rsp	#,
	.cfi_def_cfa_offset 31168
	movq	%rdi, 48(%rsp)	# fk, %sfp
	movl	%esi, 212(%rsp)	# tmp2016, %sfp
	movq	%rdx, 248(%rsp)	# tmp2017, %sfp
	movq	%rcx, 232(%rsp)	# tmp2018, %sfp
	movq	%r8, 256(%rsp)	# tmp2019, %sfp
	movq	%r9, 240(%rsp)	# tmp2020, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7824: 	logn = fk->logn;
	movl	(%rdi), %ecx	# fk_82(D)->logn, logn
	movl	%ecx, 44(%rsp)	# logn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7825: 	ter = fk->ternary;
	movl	4(%rdi), %ebx	# fk_82(D)->ternary, ter
	movl	%ebx, 208(%rsp)	# ter, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7826: 	n = MKN(logn, ter);
	leal	1(%rbx,%rbx), %eax	#, _3
	subl	%ebx, %ecx	# ter, _4
# inputs/bootstrap/source/falcon-keygen.c:7826: 	n = MKN(logn, ter);
	salq	%cl, %rax	# _4, _3
	movq	%rax, 72(%rsp)	# _3, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5273: 	if (!fk->seeded) {
	cmpl	$0, 424(%rdi)	#, fk_82(D)->seeded
	je	.L880	#,
.L767:
# inputs/bootstrap/source/falcon-keygen.c:5282: 	if (!fk->flipped) {
	movq	48(%rsp), %rax	# %sfp, fk
	cmpl	$0, 428(%rax)	#, fk_82(D)->flipped
	je	.L881	#,
.L770:
# inputs/bootstrap/source/falcon-keygen.c:8052: 			rt2 = rt1 + n;
	movq	72(%rsp), %rax	# %sfp, n
	leaq	0(,%rax,8), %rcx	#, _28
	movq	%rcx, 80(%rsp)	# _28, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7958: 			bound = fpr_div(fpr_of(73732L * (long)n),
	imulq	$73732, %rax, %rax	#, n, _11
	movq	%rax, 176(%rsp)	# _11, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7818: 	local_attempts = 0;
	movq	$0, 8(%rsp)	#, %sfp
# inputs/bootstrap/source/falcon-keygen.c:8083: 		if (!falcon_compute_public(h, f, g, logn, ter)) {
	leaq	18816(%rsp), %rax	#, tmp2014
	movq	%rax, 56(%rsp)	# tmp2014, %sfp
	jmp	.L771	#
.L880:
# inputs/bootstrap/source/falcon-keygen.c:5276: 		if (!falcon_get_seed(tmp, sizeof tmp)) {
	leaq	320(%rsp), %rdi	#, tmp1296
	movl	$32, %esi	#,
	call	falcon_get_seed@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5276: 		if (!falcon_get_seed(tmp, sizeof tmp)) {
	testl	%eax, %eax	# <retval>
	je	.L766	#,
# inputs/bootstrap/source/falcon-keygen.c:5279: 		falcon_keygen_set_seed(fk, tmp, sizeof tmp, 0);
	leaq	320(%rsp), %rsi	#, tmp1297
	movl	$0, %ecx	#,
	movl	$32, %edx	#,
	movq	48(%rsp), %rbx	# %sfp, fk
	movq	%rbx, %rdi	# fk,
	call	falcon_keygen_set_seed	#
# inputs/bootstrap/source/falcon-keygen.c:5280: 		fk->seeded = 1;
	movl	$1, 424(%rbx)	#, fk_82(D)->seeded
	jmp	.L767	#
.L881:
# inputs/bootstrap/source/falcon-keygen.c:5283: 		shake_flip(&fk->rng);
	movq	%rax, %rbx	# fk, fk
	leaq	8(%rax), %rdi	#, _269
	call	shake_flip@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:5284: 		fk->flipped = 1;
	movl	$1, 428(%rbx)	#, fk_82(D)->flipped
	jmp	.L770	#
.L772:
# inputs/bootstrap/source/falcon-keygen.c:8031: 			poly_small_mkgauss(fk, f, logn);
	leaq	24960(%rsp), %rbx	#, tmp1331
	movl	44(%rsp), %r15d	# %sfp, logn
	movl	%r15d, %edx	# logn,
	movq	%rbx, %rsi	# tmp1331,
	movq	48(%rsp), %rbp	# %sfp, fk
	movq	%rbp, %rdi	# fk,
	call	poly_small_mkgauss	#
# inputs/bootstrap/source/falcon-keygen.c:8032: 			poly_small_mkgauss(fk, g, logn);
	movl	%r15d, %edx	# logn,
	movq	56(%rsp), %r14	# %sfp, tmp2014
	movq	%r14, %rsi	# tmp2014,
	movq	%rbp, %rdi	# fk,
	call	poly_small_mkgauss	#
# inputs/bootstrap/source/falcon-keygen.c:8041: 			normf = poly_small_sqnorm(f, logn, ter);
	movl	$0, %edx	#,
	movl	%r15d, %esi	# logn,
	movq	%rbx, %rdi	# tmp1331,
	call	poly_small_sqnorm	#
	movl	%eax, %ebx	# tmp2044, normf
# inputs/bootstrap/source/falcon-keygen.c:8042: 			normg = poly_small_sqnorm(g, logn, ter);
	movl	$0, %edx	#,
	movl	%r15d, %esi	# logn,
	movq	%r14, %rdi	# tmp2014,
	call	poly_small_sqnorm	#
# inputs/bootstrap/source/falcon-keygen.c:8043: 			norm = (normf + normg) | -((normf | normg) >> 31);
	movl	%ebx, %edx	# normf, _24
	orl	%eax, %edx	# normg, _24
# inputs/bootstrap/source/falcon-keygen.c:8043: 			norm = (normf + normg) | -((normf | normg) >> 31);
	sarl	$31, %edx	#, _26
# inputs/bootstrap/source/falcon-keygen.c:8043: 			norm = (normf + normg) | -((normf | normg) >> 31);
	addl	%eax, %ebx	# normg, _23
# inputs/bootstrap/source/falcon-keygen.c:8043: 			norm = (normf + normg) | -((normf | normg) >> 31);
	orl	%edx, %ebx	# _26, norm_93
# inputs/bootstrap/source/falcon-keygen.c:8044: 			if (norm >= 16823) {
	cmpl	$16822, %ebx	#, norm_93
	jbe	.L882	#,
.L771:
# inputs/bootstrap/source/falcon-keygen.c:7866: 		if (ter) {
	cmpl	$0, 208(%rsp)	#, %sfp
	je	.L772	#,
# inputs/bootstrap/source/falcon-keygen.c:7867: 			local_attempts ++;
	addq	$1, 8(%rsp)	#, %sfp
	movq	8(%rsp), %rax	# %sfp, local_attempts
# inputs/bootstrap/source/falcon-keygen.c:7869: 			if (local_attempts > TERNARY_KEYGEN_MAX_ATTEMPTS) {
	cmpq	$3000000, %rax	#, local_attempts
	ja	.L837	#,
# inputs/bootstrap/source/falcon-keygen.c:7879: 			rt1 = (fpr *)fk->tmp;
	movq	48(%rsp), %r15	# %sfp, fk
	movq	432(%r15), %r12	# fk_82(D)->tmp, rt1
# inputs/bootstrap/source/falcon-keygen.c:7888: 			sample_true_ternary_secret(fk, f, n);
	leaq	24960(%rsp), %rbx	#, tmp1299
	movq	72(%rsp), %r14	# %sfp, n
	movq	%r14, %rdx	# n,
	movq	%rbx, %rsi	# tmp1299,
	movq	%r15, %rdi	# fk,
	call	sample_true_ternary_secret	#
# inputs/bootstrap/source/falcon-keygen.c:7889: 			sample_true_ternary_secret(fk, g, n);
	movq	%r14, %rdx	# n,
	movq	56(%rsp), %r14	# %sfp, tmp2014
	movq	%r14, %rsi	# tmp2014,
	movq	%r15, %rdi	# fk,
	call	sample_true_ternary_secret	#
# inputs/bootstrap/source/falcon-keygen.c:7931: 			if (mod2_res_ternary(f, logn) == 0) {
	movl	44(%rsp), %r15d	# %sfp, logn
	movl	%r15d, %esi	# logn,
	movq	%rbx, %rdi	# tmp1299,
	call	mod2_res_ternary	#
# inputs/bootstrap/source/falcon-keygen.c:7931: 			if (mod2_res_ternary(f, logn) == 0) {
	testl	%eax, %eax	# tmp2022
	je	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:7940: 			if (mod2_res_ternary(g, logn) == 0) {
	movl	%r15d, %esi	# logn,
	movq	%r14, %rdi	# tmp2014,
	call	mod2_res_ternary	#
# inputs/bootstrap/source/falcon-keygen.c:7940: 			if (mod2_res_ternary(g, logn) == 0) {
	testl	%eax, %eax	# tmp2023
	je	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:7880: 			rt2 = rt1 + n;
	movq	80(%rsp), %rax	# %sfp, _28
	leaq	(%r12,%rax), %r13	#, rt2
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$8, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp2024, _144
# inputs/bootstrap/source/falcon-keygen.c:7958: 			bound = fpr_div(fpr_of(73732L * (long)n),
	call	fpr_sqrt@PLT	#
	movq	%rax, %rbx	# tmp2025, _9
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movq	176(%rsp), %rdi	# %sfp,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp2026, _145
# inputs/bootstrap/source/falcon-keygen.c:7958: 			bound = fpr_div(fpr_of(73732L * (long)n),
	movq	%rbx, %rsi	# _9,
	call	fpr_div@PLT	#
	movq	%rax, %rbp	# tmp2027, bound
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$100, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rbx	# tmp2028, _89
	movl	$0, %esi	#,
	movl	$1250, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp2029, _91
# inputs/bootstrap/source/falcon-keygen.c:7961: 			bound = fpr_div(fpr_mul(bound,
	movq	%rbp, %rdi	# bound,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2030, _12
# inputs/bootstrap/source/falcon-keygen.c:7961: 			bound = fpr_div(fpr_mul(bound,
	movq	%rbx, %rsi	# _89,
	call	fpr_div@PLT	#
	movq	%rax, %r14	# tmp2031, bound
# inputs/bootstrap/source/falcon-keygen.c:7969: 			poly_small_to_fp(rt1, f, logn, 1);
	leaq	24960(%rsp), %rsi	#, tmp1303
	movl	$1, %ecx	#,
	movl	44(%rsp), %ebx	# %sfp, logn
	movl	%ebx, %edx	# logn,
	movq	%r12, %rdi	# rt1,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:7970: 			poly_small_to_fp(rt2, g, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	56(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# rt2,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:7971: 			falcon_FFT3(rt1, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%r12, %rdi	# rt1,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7972: 			falcon_FFT3(rt2, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%r13, %rdi	# rt2,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$0, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rbp	# tmp2032, norm
# inputs/bootstrap/source/falcon-keygen.c:7974: 			for (u = 0; u < n; u ++) {
	movq	72(%rsp), %r15	# %sfp, n
	testq	%r15, %r15	# n
	je	.L774	#,
# inputs/bootstrap/source/falcon-keygen.c:7974: 			for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L775:
# inputs/bootstrap/source/falcon-keygen.c:7975: 				norm = fpr_add(norm, fpr_sqr(rt1[u]));
	movq	(%r12,%rbx,8), %rdi	# MEM[(fpr *)rt1_118 + u_1901 * 8], _15
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# _15,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp2033, _135
# inputs/bootstrap/source/falcon-keygen.c:7975: 				norm = fpr_add(norm, fpr_sqr(rt1[u]));
	movq	%rbp, %rdi	# norm,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp2034, norm
# inputs/bootstrap/source/falcon-keygen.c:7976: 				norm = fpr_add(norm, fpr_sqr(rt2[u]));
	movq	0(%r13,%rbx,8), %rdi	# MEM[(fpr *)rt2_119 + u_1901 * 8], _17
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# _17,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp2035, _136
# inputs/bootstrap/source/falcon-keygen.c:7976: 				norm = fpr_add(norm, fpr_sqr(rt2[u]));
	movq	%rbp, %rdi	# norm,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp2036, norm
# inputs/bootstrap/source/falcon-keygen.c:7974: 			for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-keygen.c:7974: 			for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r15	# u, n
	jne	.L775	#,
.L774:
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	movq	%rbp, %rax	# norm, _198
	shrq	$52, %rax	#, _198
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	andl	$2047, %eax	#, _200
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addl	$2047, %eax	#, _201
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrl	$11, %eax	#, _202
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	salq	$52, %rax	#, _204
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addq	%rbp, %rax	# norm, x
# inputs/bootstrap/source/fpr-emulated.h:203: 	cc0 = sx < sy;
	cmpq	%r14, %rax	# bound, x
	setl	%cl	#, _190
	movzbl	%cl, %ecx	# _190, _190
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	movq	%r14, %rdx	# bound, _194
	andq	%rax, %rdx	# x, _194
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	shrq	$63, %rdx	#, _195
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	cmpq	%r14, %rax	# bound, x
	setne	%al	#, _192
	movzbl	%al, %eax	# _192, _192
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	andl	%edx, %eax	# _195, _197
# inputs/bootstrap/source/falcon-keygen.c:7983: 			if (!fpr_lt(norm, bound)) {
	cmpl	%eax, %ecx	# _197, _190
	je	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:7881: 			rt3 = rt2 + n;
	movq	80(%rsp), %rax	# %sfp, _28
	leaq	0(%r13,%rax), %rbx	#, rt3
# inputs/bootstrap/source/falcon-keygen.c:7995: 			falcon_poly_invnorm2_fft3(rt3, rt1, rt2, logn, 1);
	movl	$1, %r8d	#,
	movl	44(%rsp), %r15d	# %sfp, logn
	movl	%r15d, %ecx	# logn,
	movq	%r13, %rdx	# rt2,
	movq	%r12, %rsi	# rt1,
	movq	%rbx, %rdi	# rt3,
	call	falcon_poly_invnorm2_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7996: 			falcon_poly_adj_fft3(rt1, logn, 1);
	movl	$1, %edx	#,
	movl	%r15d, %esi	# logn,
	movq	%r12, %rdi	# rt1,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7997: 			falcon_poly_adj_fft3(rt2, logn, 1);
	movl	$1, %edx	#,
	movl	%r15d, %esi	# logn,
	movq	%r13, %rdi	# rt2,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$18433, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp2037, _208
# inputs/bootstrap/source/falcon-keygen.c:7998: 			falcon_poly_mulconst_fft3(rt1, fpr_of(18433), logn, 1);
	movl	$1, %ecx	#,
	movl	%r15d, %edx	# logn,
	movq	%r12, %rdi	# rt1,
	call	falcon_poly_mulconst3@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$18433, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp2038, _207
# inputs/bootstrap/source/falcon-keygen.c:7999: 			falcon_poly_mulconst_fft3(rt2, fpr_of(18433), logn, 1);
	movl	$1, %ecx	#,
	movl	%r15d, %edx	# logn,
	movq	%r13, %rdi	# rt2,
	call	falcon_poly_mulconst3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8000: 			falcon_poly_mul_autoadj_fft3(rt1, rt3, logn, 1);
	movl	$1, %ecx	#,
	movl	%r15d, %edx	# logn,
	movq	%rbx, %rsi	# rt3,
	movq	%r12, %rdi	# rt1,
	call	falcon_poly_mul_autoadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8001: 			falcon_poly_mul_autoadj_fft3(rt2, rt3, logn, 1);
	movl	$1, %ecx	#,
	movl	%r15d, %edx	# logn,
	movq	%rbx, %rsi	# rt3,
	movq	%r13, %rdi	# rt2,
	call	falcon_poly_mul_autoadj_fft3@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$0, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rbp	# tmp2039, norm
# inputs/bootstrap/source/falcon-keygen.c:8003: 			for (u = 0; u < n; u ++) {
	movq	72(%rsp), %r15	# %sfp, n
	testq	%r15, %r15	# n
	je	.L776	#,
# inputs/bootstrap/source/falcon-keygen.c:8003: 			for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L777:
# inputs/bootstrap/source/falcon-keygen.c:8004: 				norm = fpr_add(norm, fpr_sqr(rt1[u]));
	movq	(%r12,%rbx,8), %rdi	# MEM[(fpr *)rt1_118 + u_1902 * 8], _20
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# _20,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp2040, _210
# inputs/bootstrap/source/falcon-keygen.c:8004: 				norm = fpr_add(norm, fpr_sqr(rt1[u]));
	movq	%rbp, %rdi	# norm,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp2041, norm
# inputs/bootstrap/source/falcon-keygen.c:8005: 				norm = fpr_add(norm, fpr_sqr(rt2[u]));
	movq	0(%r13,%rbx,8), %rdi	# MEM[(fpr *)rt2_119 + u_1902 * 8], _22
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# _22,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp2042, _209
# inputs/bootstrap/source/falcon-keygen.c:8005: 				norm = fpr_add(norm, fpr_sqr(rt2[u]));
	movq	%rbp, %rdi	# norm,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp2043, norm
# inputs/bootstrap/source/falcon-keygen.c:8003: 			for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-keygen.c:8003: 			for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r15	# u, n
	jne	.L777	#,
.L776:
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	movq	%rbp, %rax	# norm, _220
	shrq	$52, %rax	#, _220
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	andl	$2047, %eax	#, _222
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addl	$2047, %eax	#, _223
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	shrl	$11, %eax	#, _224
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	salq	$52, %rax	#, _226
# inputs/bootstrap/source/fpr-emulated.h:179: 	x += (uint64_t)((((unsigned)(x >> 52) & 0x7FFU) + 0x7FFU) >> 11) << 52;
	addq	%rbp, %rax	# norm, x
# inputs/bootstrap/source/fpr-emulated.h:203: 	cc0 = sx < sy;
	cmpq	%rax, %r14	# x, bound
	setg	%cl	#, _212
	movzbl	%cl, %ecx	# _212, _212
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	movq	%r14, %rdx	# bound, _216
	andq	%rax, %rdx	# x, _216
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	shrq	$63, %rdx	#, _217
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	cmpq	%rax, %r14	# x, bound
	setne	%al	#, _214
	movzbl	%al, %eax	# _214, _214
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	andl	%edx, %eax	# _217, _219
# inputs/bootstrap/source/falcon-keygen.c:8012: 			if (!fpr_lt(norm, bound)) {
	cmpl	%eax, %ecx	# _219, _212
	jne	.L778	#,
	jmp	.L771	#
.L882:
# inputs/bootstrap/source/falcon-keygen.c:8051: 			rt1 = (fpr *)fk->tmp;
	movq	48(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %r12	# fk_82(D)->tmp, rt1
# inputs/bootstrap/source/falcon-keygen.c:8052: 			rt2 = rt1 + n;
	movq	80(%rsp), %rax	# %sfp, _28
	leaq	(%r12,%rax), %r13	#, rt2
# inputs/bootstrap/source/falcon-keygen.c:8053: 			rt3 = rt2 + n;
	leaq	0(%r13,%rax), %rbx	#, rt3
# inputs/bootstrap/source/falcon-keygen.c:8054: 			poly_small_to_fp(rt1, f, logn, 0);
	leaq	24960(%rsp), %rsi	#, tmp1339
	movl	$0, %ecx	#,
	movl	44(%rsp), %r15d	# %sfp, logn
	movl	%r15d, %edx	# logn,
	movq	%r12, %rdi	# rt1,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:8055: 			poly_small_to_fp(rt2, g, logn, 0);
	movl	$0, %ecx	#,
	movl	%r15d, %edx	# logn,
	movq	56(%rsp), %rsi	# %sfp,
	movq	%r13, %rdi	# rt2,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:8056: 			falcon_FFT(rt1, logn);
	movl	%r15d, %esi	# logn,
	movq	%r12, %rdi	# rt1,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8057: 			falcon_FFT(rt2, logn);
	movl	%r15d, %esi	# logn,
	movq	%r13, %rdi	# rt2,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8058: 			falcon_poly_invnorm2_fft(rt3, rt1, rt2, logn);
	movl	%r15d, %ecx	# logn,
	movq	%r13, %rdx	# rt2,
	movq	%r12, %rsi	# rt1,
	movq	%rbx, %rdi	# rt3,
	call	falcon_poly_invnorm2_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8059: 			falcon_poly_adj_fft(rt1, logn);
	movl	%r15d, %esi	# logn,
	movq	%r12, %rdi	# rt1,
	call	falcon_poly_adj_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8060: 			falcon_poly_adj_fft(rt2, logn);
	movl	%r15d, %esi	# logn,
	movq	%r13, %rdi	# rt2,
	call	falcon_poly_adj_fft@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$12289, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp2046, _230
# inputs/bootstrap/source/falcon-keygen.c:8061: 			falcon_poly_mulconst_fft(rt1, fpr_of(12289), logn);
	movl	%r15d, %edx	# logn,
	movq	%r12, %rdi	# rt1,
	call	falcon_poly_mulconst@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$12289, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rsi	# tmp2047, _229
# inputs/bootstrap/source/falcon-keygen.c:8062: 			falcon_poly_mulconst_fft(rt2, fpr_of(12289), logn);
	movl	%r15d, %edx	# logn,
	movq	%r13, %rdi	# rt2,
	call	falcon_poly_mulconst@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8063: 			falcon_poly_mul_autoadj_fft(rt1, rt3, logn);
	movl	%r15d, %edx	# logn,
	movq	%rbx, %rsi	# rt3,
	movq	%r12, %rdi	# rt1,
	call	falcon_poly_mul_autoadj_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8064: 			falcon_poly_mul_autoadj_fft(rt2, rt3, logn);
	movl	%r15d, %edx	# logn,
	movq	%rbx, %rsi	# rt3,
	movq	%r13, %rdi	# rt2,
	call	falcon_poly_mul_autoadj_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8065: 			falcon_iFFT(rt1, logn);
	movl	%r15d, %esi	# logn,
	movq	%r12, %rdi	# rt1,
	call	falcon_iFFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8066: 			falcon_iFFT(rt2, logn);
	movl	%r15d, %esi	# logn,
	movq	%r13, %rdi	# rt2,
	call	falcon_iFFT@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$0, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rbp	# tmp2048, bnorm
# inputs/bootstrap/source/falcon-keygen.c:8068: 			for (u = 0; u < n; u ++) {
	movq	72(%rsp), %r14	# %sfp, n
	testq	%r14, %r14	# n
	je	.L779	#,
# inputs/bootstrap/source/falcon-keygen.c:8068: 			for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
.L780:
# inputs/bootstrap/source/falcon-keygen.c:8069: 				bnorm = fpr_add(bnorm, fpr_sqr(rt1[u]));
	movq	(%r12,%rbx,8), %rdi	# MEM[(fpr *)rt1_94 + u_1903 * 8], _31
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# _31,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp2049, _232
# inputs/bootstrap/source/falcon-keygen.c:8069: 				bnorm = fpr_add(bnorm, fpr_sqr(rt1[u]));
	movq	%rbp, %rdi	# bnorm,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp2050, bnorm
# inputs/bootstrap/source/falcon-keygen.c:8070: 				bnorm = fpr_add(bnorm, fpr_sqr(rt2[u]));
	movq	0(%r13,%rbx,8), %rdi	# MEM[(fpr *)rt2_95 + u_1903 * 8], _33
# inputs/bootstrap/source/fpr-emulated.h:186: 	return fpr_mul(x, x);
	movq	%rdi, %rsi	# _33,
	call	fpr_mul@PLT	#
	movq	%rax, %rsi	# tmp2051, _231
# inputs/bootstrap/source/falcon-keygen.c:8070: 				bnorm = fpr_add(bnorm, fpr_sqr(rt2[u]));
	movq	%rbp, %rdi	# bnorm,
	call	fpr_add@PLT	#
	movq	%rax, %rbp	# tmp2052, bnorm
# inputs/bootstrap/source/falcon-keygen.c:8068: 			for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-keygen.c:8068: 			for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r14	# u, n
	jne	.L780	#,
.L779:
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$10000, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rbx	# tmp2053, _244
	movl	$0, %esi	#,
	movl	$168224121, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rdi	# tmp2054, _243
# inputs/bootstrap/source/falcon-keygen.c:8072: 			if (!fpr_lt(bnorm, fpr_div(
	movq	%rbx, %rsi	# _244,
	call	fpr_div@PLT	#
# inputs/bootstrap/source/fpr-emulated.h:203: 	cc0 = sx < sy;
	cmpq	%rax, %rbp	# _34, bnorm
	setl	%cl	#, _235
	movzbl	%cl, %ecx	# _235, _235
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	movq	%rax, %rdx	# _34, _239
	andq	%rbp, %rdx	# bnorm, _239
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	shrq	$63, %rdx	#, _240
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	cmpq	%rax, %rbp	# _34, bnorm
	setne	%al	#, _237
	movzbl	%al, %eax	# _237, _237
# inputs/bootstrap/source/fpr-emulated.h:205: 	return cc0 ^ ((cc0 ^ cc1) & (int)((x & y) >> 63));
	andl	%edx, %eax	# _240, _242
# inputs/bootstrap/source/falcon-keygen.c:8072: 			if (!fpr_lt(bnorm, fpr_div(
	cmpl	%eax, %ecx	# _242, _235
	je	.L771	#,
.L778:
# inputs/bootstrap/source/falcon-keygen.c:8083: 		if (!falcon_compute_public(h, f, g, logn, ter)) {
	leaq	24960(%rsp), %rsi	#, tmp1349
	leaq	384(%rsp), %rdi	#, tmp1350
	movl	208(%rsp), %r8d	# %sfp,
	movl	44(%rsp), %ecx	# %sfp,
	movq	56(%rsp), %rdx	# %sfp,
	call	falcon_compute_public@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8083: 		if (!falcon_compute_public(h, f, g, logn, ter)) {
	testl	%eax, %eax	# tmp2056
	je	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:7288: 	logn = fk->logn;
	movq	48(%rsp), %rax	# %sfp, fk
	movl	(%rax), %ecx	# fk_82(D)->logn, logn
	movl	%ecx, 96(%rsp)	# logn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7289: 	n = MKN(logn, fk->ternary);
	movl	4(%rax), %eax	# fk_82(D)->ternary, _272
	movl	%eax, 296(%rsp)	# _272, %sfp
# inputs/bootstrap/source/falcon-keygen.c:5750: 	if (fk->ternary) {
	testl	%eax, %eax	# _272
	je	.L781	#,
# inputs/bootstrap/source/falcon-keygen.c:5751: 		len = MAX_BL_SMALL3[logn];
	movl	%ecx, %eax	# logn, logn
	leaq	MAX_BL_SMALL3(%rip), %rdx	#, tmp1351
	movq	(%rdx,%rax,8), %rbp	# MAX_BL_SMALL3[logn_271], len
# inputs/bootstrap/source/falcon-keygen.c:5752: 		primes = PRIMES3;
	leaq	PRIMES3(%rip), %r14	#, primes
.L782:
# inputs/bootstrap/source/falcon-keygen.c:5758: 	Fp = fk->tmp;
	movq	48(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %r13	# fk_82(D)->tmp, Fp
# inputs/bootstrap/source/falcon-keygen.c:5759: 	Gp = Fp + len;
	leaq	0(,%rbp,4), %rbx	#, _438
# inputs/bootstrap/source/falcon-keygen.c:5759: 	Gp = Fp + len;
	leaq	0(%r13,%rbx), %rax	#, Gp
# inputs/bootstrap/source/falcon-keygen.c:5760: 	fp = Gp + len;
	movq	%rax, 16(%rsp)	# Gp, %sfp
	leaq	(%rax,%rbx), %r12	#, fp
# inputs/bootstrap/source/falcon-keygen.c:5761: 	gp = fp + len;
	leaq	(%r12,%rbx), %r15	#, gp
# inputs/bootstrap/source/falcon-keygen.c:5762: 	t1 = gp + len;
	addq	%r15, %rbx	# gp, t1
# inputs/bootstrap/source/falcon-keygen.c:5764: 	make_fg(fp, f, g, logn, fk->ternary, logn, 0);
	leaq	18816(%rsp), %rdx	#, tmp1355
	leaq	24960(%rsp), %rsi	#, tmp1356
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 31176
	pushq	$0	#
	.cfi_def_cfa_offset 31184
	movl	112(%rsp), %ecx	# %sfp, logn
	movl	%ecx, %r9d	# logn,
	movl	312(%rsp), %r8d	# %sfp,
	movq	%r12, %rdi	# fp,
	call	make_fg	#
# inputs/bootstrap/source/falcon-keygen.c:5770: 	zint_rebuild_CRT(fp, len, len, 2, primes, 0, t1);
	movq	%rbx, (%rsp)	# t1,
	movl	$0, %r9d	#,
	movq	%r14, %r8	# primes,
	movl	$2, %ecx	#,
	movq	%rbp, %rdx	# len,
	movq	%rbp, %rsi	# len,
	movq	%r12, %rdi	# fp,
	call	zint_rebuild_CRT	#
# inputs/bootstrap/source/falcon-keygen.c:5776: 	if (!zint_bezout(Gp, Fp, fp, gp, len, t1)) {
	movq	%rbx, %r9	# t1,
	movq	%rbp, %r8	# len,
	movq	%r15, %rcx	# gp,
	movq	%r12, %rdx	# fp,
	movq	%r13, %rsi	# Fp,
	movq	32(%rsp), %rdi	# %sfp,
	call	zint_bezout	#
# inputs/bootstrap/source/falcon-keygen.c:5776: 	if (!zint_bezout(Gp, Fp, fp, gp, len, t1)) {
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 31168
	testl	%eax, %eax	# tmp2057
	je	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:5784: 	q = fk->ternary ? 18433 : 12289;
	movl	$12289, %ebx	#, iftmp.26_446
# inputs/bootstrap/source/falcon-keygen.c:5784: 	q = fk->ternary ? 18433 : 12289;
	movq	48(%rsp), %rax	# %sfp, fk
	cmpl	$0, 4(%rax)	#, fk_82(D)->ternary
	je	.L784	#,
# inputs/bootstrap/source/falcon-keygen.c:5784: 	q = fk->ternary ? 18433 : 12289;
	movl	$18433, %ebx	#, iftmp.26_446
.L784:
# inputs/bootstrap/source/falcon-keygen.c:5785: 	if (zint_mul_small(Fp, len, q) != 0
	movl	%ebx, %edx	# iftmp.26_446,
	movq	%rbp, %rsi	# len,
	movq	%r13, %rdi	# Fp,
	call	zint_mul_small	#
# inputs/bootstrap/source/falcon-keygen.c:5785: 	if (zint_mul_small(Fp, len, q) != 0
	testl	%eax, %eax	# tmp2058
	jne	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:5786: 		|| zint_mul_small(Gp, len, q) != 0)
	movl	%ebx, %edx	# iftmp.26_446,
	movq	%rbp, %rsi	# len,
	movq	16(%rsp), %rdi	# %sfp,
	call	zint_mul_small	#
# inputs/bootstrap/source/falcon-keygen.c:7291: 	if (!solve_NTRU_deepest(fk, f, g)) {
	testl	%eax, %eax	# tmp2059
	jne	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:7301: 	if (logn <= 2) {
	cmpl	$2, 96(%rsp)	#, %sfp
	jbe	.L839	#,
# inputs/bootstrap/source/falcon-keygen.c:7314: 		if (fk->ternary) {
	movq	48(%rsp), %r12	# %sfp, fk
	cmpl	$0, 4(%r12)	#, fk_82(D)->ternary
	jne	.L840	#,
# inputs/bootstrap/source/falcon-keygen.c:7313: 		depth = logn;
	movl	96(%rsp), %ebx	# %sfp, depth
# inputs/bootstrap/source/falcon-keygen.c:7325: 				if (!solve_NTRU_intermediate(fk, f, g, depth)) {
	leaq	18816(%rsp), %rbp	#, tmp2013
.L792:
# inputs/bootstrap/source/falcon-keygen.c:7324: 			while (depth -- > 2) {
	subl	$1, %ebx	#, depth
# inputs/bootstrap/source/falcon-keygen.c:7324: 			while (depth -- > 2) {
	cmpl	$1, %ebx	#, depth
	je	.L883	#,
# inputs/bootstrap/source/falcon-keygen.c:7325: 				if (!solve_NTRU_intermediate(fk, f, g, depth)) {
	leaq	24960(%rsp), %rsi	#, tmp1532
	movl	%ebx, %ecx	# depth,
	movq	%rbp, %rdx	# tmp2013,
	movq	%r12, %rdi	# fk,
	call	solve_NTRU_intermediate	#
# inputs/bootstrap/source/falcon-keygen.c:7325: 				if (!solve_NTRU_intermediate(fk, f, g, depth)) {
	testl	%eax, %eax	# tmp2139
	jne	.L792	#,
	jmp	.L771	#
.L781:
# inputs/bootstrap/source/falcon-keygen.c:5754: 		len = MAX_BL_SMALL2[logn];
	movl	96(%rsp), %eax	# %sfp, logn
	leaq	MAX_BL_SMALL2(%rip), %rdx	#, tmp1353
	movq	(%rdx,%rax,8), %rbp	# MAX_BL_SMALL2[logn_271], len
# inputs/bootstrap/source/falcon-keygen.c:5755: 		primes = PRIMES2;
	leaq	PRIMES2(%rip), %r14	#, primes
	jmp	.L782	#
.L839:
# inputs/bootstrap/source/falcon-keygen.c:7304: 		depth = logn;
	movl	96(%rsp), %ebx	# %sfp, depth
# inputs/bootstrap/source/falcon-keygen.c:7306: 			if (!solve_NTRU_intermediate(fk, f, g, depth)) {
	leaq	18816(%rsp), %rbp	#, tmp2011
	movq	48(%rsp), %r12	# %sfp, fk
.L786:
# inputs/bootstrap/source/falcon-keygen.c:7305: 		while (depth -- > 0) {
	subl	$1, %ebx	#, depth
# inputs/bootstrap/source/falcon-keygen.c:7305: 		while (depth -- > 0) {
	cmpl	$-1, %ebx	#, depth
	je	.L790	#,
# inputs/bootstrap/source/falcon-keygen.c:7306: 			if (!solve_NTRU_intermediate(fk, f, g, depth)) {
	leaq	24960(%rsp), %rsi	#, tmp1358
	movl	%ebx, %ecx	# depth,
	movq	%rbp, %rdx	# tmp2011,
	movq	%r12, %rdi	# fk,
	call	solve_NTRU_intermediate	#
# inputs/bootstrap/source/falcon-keygen.c:7306: 			if (!solve_NTRU_intermediate(fk, f, g, depth)) {
	testl	%eax, %eax	# tmp2060
	jne	.L786	#,
	jmp	.L771	#
.L840:
# inputs/bootstrap/source/falcon-keygen.c:7313: 		depth = logn;
	movl	96(%rsp), %ebx	# %sfp, depth
# inputs/bootstrap/source/falcon-keygen.c:7316: 				if (!solve_NTRU_intermediate(fk, f, g, depth)) {
	leaq	18816(%rsp), %rbp	#, tmp2012
	movq	48(%rsp), %r12	# %sfp, fk
.L791:
# inputs/bootstrap/source/falcon-keygen.c:7315: 			while (depth -- > 1) {
	subl	$1, %ebx	#, depth
	je	.L884	#,
# inputs/bootstrap/source/falcon-keygen.c:7316: 				if (!solve_NTRU_intermediate(fk, f, g, depth)) {
	leaq	24960(%rsp), %rsi	#, tmp1360
	movl	%ebx, %ecx	# depth,
	movq	%rbp, %rdx	# tmp2012,
	movq	%r12, %rdi	# fk,
	call	solve_NTRU_intermediate	#
# inputs/bootstrap/source/falcon-keygen.c:7316: 				if (!solve_NTRU_intermediate(fk, f, g, depth)) {
	testl	%eax, %eax	# tmp2061
	jne	.L791	#,
	jmp	.L771	#
.L884:
# inputs/bootstrap/source/falcon-keygen.c:7060: 	logn = fk->logn;
	movq	48(%rsp), %rsi	# %sfp, fk
	movl	(%rsi), %r13d	# fk_82(D)->logn, logn
	movl	%r13d, 300(%rsp)	# logn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7061: 	n = (size_t)3 << (logn - 1);
	leal	-1(%r13), %edx	#, _451
# inputs/bootstrap/source/falcon-keygen.c:7061: 	n = (size_t)3 << (logn - 1);
	movl	$3, %eax	#, tmp1361
	movq	%rax, %rbx	# tmp1361, tmp1361
	movl	%edx, %ecx	# _451, tmp2445
	salq	%cl, %rbx	# tmp2445, tmp1361
	movq	%rbx, 272(%rsp)	# n, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7062: 	tn = (size_t)1 << (logn - 1);
	movl	$1, %ebp	#, tmp1362
	movq	%rbp, %r15	# tmp1362, tmp1362
	salq	%cl, %r15	# tmp2447, tmp1362
# inputs/bootstrap/source/falcon-keygen.c:7063: 	hn = n >> 1;
	movq	%rbx, %rax	# n, hn
	shrq	%rax	# hn
	movq	%rax, 280(%rsp)	# hn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7064: 	sn = tn >> 1;
	movq	%r15, %rcx	# tn, sn
	shrq	%rcx	# sn
	movq	%rcx, 88(%rsp)	# sn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7071: 	Fp = fk->tmp;
	movq	432(%rsi), %r12	# fk_82(D)->tmp, Fp
# inputs/bootstrap/source/falcon-keygen.c:7072: 	Gp = Fp + tn;
	movl	$4, %eax	#, tmp1363
	movl	%edx, 24(%rsp)	# _451, %sfp
	movzbl	24(%rsp), %ecx	# %sfp, tmp2451
	salq	%cl, %rax	# tmp2451, _457
# inputs/bootstrap/source/falcon-keygen.c:7072: 	Gp = Fp + tn;
	leaq	(%r12,%rax), %rbp	#, Gp
# inputs/bootstrap/source/falcon-keygen.c:7073: 	t1 = Gp + tn;
	leaq	0(%rbp,%rax), %rsi	#, t1_459
# inputs/bootstrap/source/falcon-keygen.c:7079: 	rt1 = align_fpr(fk->tmp, t1);
	movq	%r12, %rdi	# Fp,
	call	align_fpr	#
# inputs/bootstrap/source/falcon-keygen.c:7080: 	rt2 = rt1 + n;
	leaq	0(,%rbx,8), %rcx	#, _461
	movq	%rcx, 304(%rsp)	# _461, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7080: 	rt2 = rt1 + n;
	leaq	(%rax,%rcx), %rbx	#, rt2
# inputs/bootstrap/source/falcon-keygen.c:7081: 	rt3 = rt2 + n;
	leaq	(%rbx,%rcx), %r14	#, rt3
# inputs/bootstrap/source/falcon-keygen.c:7082: 	poly_small_to_fp(rt1, f, logn, 1);
	leaq	24960(%rsp), %rsi	#, tmp1365
	movl	$1, %ecx	#,
	movl	%r13d, %edx	# logn,
	movq	%rax, 16(%rsp)	# rt1, %sfp
	movq	%rax, %rdi	# rt1,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:7083: 	poly_small_to_fp(rt2, g, logn, 1);
	leaq	18816(%rsp), %rsi	#, tmp1366
	movl	$1, %ecx	#,
	movl	%r13d, %edx	# logn,
	movq	%rbx, %rdi	# rt2,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:7084: 	falcon_FFT3(rt1, logn, 1);
	movl	$1, %edx	#,
	movl	%r13d, %esi	# logn,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7085: 	falcon_FFT3(rt2, logn, 1);
	movl	$1, %edx	#,
	movl	%r13d, %esi	# logn,
	movq	%rbx, %rdi	# rt2,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7086: 	falcon_poly_invnorm2_fft3(rt3, rt1, rt2, logn, 1);
	movl	$1, %r8d	#,
	movl	%r13d, %ecx	# logn,
	movq	%rbx, %rdx	# rt2,
	movq	16(%rsp), %rbx	# %sfp, rt1
	movq	%rbx, %rsi	# rt1,
	movq	%r14, %rdi	# rt3,
	call	falcon_poly_invnorm2_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7091: 	memmove(rt1, rt3, hn * sizeof *rt3);
	movq	280(%rsp), %rax	# %sfp, hn
	leaq	0(,%rax,8), %r13	#, ivtmp.1408
	movq	%r13, %rdx	# ivtmp.1408,
	movq	%r14, %rsi	# rt3,
	movq	%rbx, %rdi	# rt1,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7097: 	rt1 = rt5 + hn;
	leaq	(%rbx,%r13), %r8	#, rt1
# inputs/bootstrap/source/falcon-keygen.c:7098: 	rt2 = rt1 + tn;
	movl	$8, %edx	#, tmp1367
	movq	%rdx, %rax	# tmp1367, tmp1367
	movzbl	24(%rsp), %ecx	# %sfp, tmp2460
	salq	%cl, %rax	# tmp2460, tmp1367
	movq	%rax, 32(%rsp)	# _466, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7098: 	rt2 = rt1 + tn;
	leaq	(%r8,%rax), %r14	#, rt2
# inputs/bootstrap/source/falcon-keygen.c:7099: 	for (u = 0; u < tn; u ++) {
	movl	$0, %ebx	#, u
	movq	%r13, 64(%rsp)	# ivtmp.1408, %sfp
	movq	%r8, %r13	# rt1, rt1
.L794:
# inputs/bootstrap/source/falcon-keygen.c:4435: 	w = x[0];
	movl	(%r12,%rbx,4), %eax	# MEM[(const uint32_t *)Fp_456 + u_1923 * 4], _471
# inputs/bootstrap/source/falcon-keygen.c:4436: 	w |= (w & 0x40000000) << 1;
	leal	(%rax,%rax), %edi	#, _472
	andl	$-2147483648, %edi	#, _473
# inputs/bootstrap/source/falcon-keygen.c:4436: 	w |= (w & 0x40000000) << 1;
	orl	%eax, %edi	# _471, _474
# inputs/bootstrap/source/falcon-keygen.c:7100: 		rt1[u] = fpr_of(zint_one_to_plain(Fp + u));
	movslq	%edi, %rdi	# _474, _476
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7100: 		rt1[u] = fpr_of(zint_one_to_plain(Fp + u));
	movq	%rax, 0(%r13,%rbx,8)	# tmp2063, MEM[(fpr *)rt1_465 + u_1923 * 8]
# inputs/bootstrap/source/falcon-keygen.c:4435: 	w = x[0];
	movl	0(%rbp,%rbx,4), %eax	# MEM[(const uint32_t *)Gp_458 + u_1923 * 4], _481
# inputs/bootstrap/source/falcon-keygen.c:4436: 	w |= (w & 0x40000000) << 1;
	leal	(%rax,%rax), %edi	#, _482
	andl	$-2147483648, %edi	#, _483
# inputs/bootstrap/source/falcon-keygen.c:4436: 	w |= (w & 0x40000000) << 1;
	orl	%eax, %edi	# _481, _484
# inputs/bootstrap/source/falcon-keygen.c:7101: 		rt2[u] = fpr_of(zint_one_to_plain(Gp + u));
	movslq	%edi, %rdi	# _484, _486
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7101: 		rt2[u] = fpr_of(zint_one_to_plain(Gp + u));
	movq	%rax, (%r14,%rbx,8)	# tmp2064, MEM[(fpr *)rt2_467 + u_1923 * 8]
# inputs/bootstrap/source/falcon-keygen.c:7099: 	for (u = 0; u < tn; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-keygen.c:7099: 	for (u = 0; u < tn; u ++) {
	cmpq	%rbx, %r15	# u, tn
	jne	.L794	#,
# inputs/bootstrap/source/falcon-keygen.c:7103: 	falcon_FFT3(rt1, logn - 1, 0);
	movq	%r13, %r8	# rt1, rt1
	movq	64(%rsp), %r13	# %sfp, ivtmp.1408
	movl	$0, %edx	#,
	movl	24(%rsp), %ebx	# %sfp, _451
	movl	%ebx, %esi	# _451,
	movq	%r8, %rdi	# rt1,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7104: 	falcon_FFT3(rt2, logn - 1, 0);
	movl	$0, %edx	#,
	movl	%ebx, %esi	# _451,
	movq	%r14, %rdi	# rt2,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7109: 	memmove(fk->tmp, rt5, (hn + tn * 2) * sizeof(*rt1));
	movl	$2, %eax	#, tmp1382
	movl	%ebx, %ecx	# _451, tmp2462
	salq	%cl, %rax	# tmp2462, _490
# inputs/bootstrap/source/falcon-keygen.c:7109: 	memmove(fk->tmp, rt5, (hn + tn * 2) * sizeof(*rt1));
	movq	280(%rsp), %r12	# %sfp, hn
	leaq	(%rax,%r12), %rdx	#, _491
# inputs/bootstrap/source/falcon-keygen.c:7109: 	memmove(fk->tmp, rt5, (hn + tn * 2) * sizeof(*rt1));
	salq	$3, %rdx	#, _492
	movq	48(%rsp), %rbx	# %sfp, fk
	movq	432(%rbx), %rdi	# fk_82(D)->tmp, fk_82(D)->tmp
	movq	16(%rsp), %rsi	# %sfp,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7110: 	rt5 = (fpr *)fk->tmp;
	movq	432(%rbx), %r14	# fk_82(D)->tmp, rt5
# inputs/bootstrap/source/falcon-keygen.c:7111: 	rt1 = rt5 + hn;
	leaq	(%r14,%r13), %rax	#, rt1
	movq	%rax, 264(%rsp)	# rt1, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7112: 	rt2 = rt1 + tn;
	movq	32(%rsp), %rcx	# %sfp, _466
	addq	%rcx, %rax	# _466, rt2
	movq	%rax, 288(%rsp)	# rt2, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7120: 	rt3 = rt2 + tn;
	leaq	(%rax,%rcx), %r15	#, rt3
	movq	%r15, 16(%rsp)	# rt3, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7121: 	rt4 = rt3 + n;
	movq	304(%rsp), %rax	# %sfp, _461
	leaq	(%r15,%rax), %rbx	#, rt4
# inputs/bootstrap/source/falcon-keygen.c:7122: 	poly_small_to_fp(rt3, f, logn, 1);
	leaq	24960(%rsp), %rsi	#, tmp1386
	movl	$1, %ecx	#,
	movl	300(%rsp), %ebp	# %sfp, logn
	movl	%ebp, %edx	# logn,
	movq	%r15, %rdi	# rt3,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:7123: 	poly_small_to_fp(rt4, g, logn, 1);
	leaq	18816(%rsp), %rsi	#, tmp1387
	movl	$1, %ecx	#,
	movl	%ebp, %edx	# logn,
	movq	%rbx, %rdi	# rt4,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:7124: 	falcon_FFT3(rt3, logn, 1);
	movl	$1, %edx	#,
	movl	%ebp, %esi	# logn,
	movq	%r15, %rdi	# rt3,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7125: 	falcon_FFT3(rt4, logn, 1);
	movl	$1, %edx	#,
	movl	%ebp, %esi	# logn,
	movq	%rbx, %rdi	# rt4,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7130: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	testq	%r12, %r12	# hn
	je	.L795	#,
	movq	88(%rsp), %rax	# %sfp, sn
	salq	$3, %rax	#, sn
	movq	%rax, 192(%rsp)	# sn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7130: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	movl	$0, %ebp	#, u
# inputs/bootstrap/source/falcon-keygen.c:7130: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	movq	$0, 184(%rsp)	#, %sfp
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movq	%r14, 312(%rsp)	# rt5, %sfp
.L796:
# inputs/bootstrap/source/falcon-keygen.c:7166: 		Fre = rt1[v];
	movq	264(%rsp), %rcx	# %sfp, rt1
	movq	184(%rsp), %rdx	# %sfp, v
	movq	(%rcx,%rdx,8), %rax	# MEM[(fpr *)rt1_495 + v_1924 * 8], Fre
	movq	%rax, 24(%rsp)	# Fre, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7167: 		Fim = rt1[v + sn];
	movq	192(%rsp), %rsi	# %sfp, ivtmp.1407
	movq	(%rcx,%rsi), %rcx	# MEM[(fpr *)rt1_495 + ivtmp.1407_1007 * 1], Fim
	movq	%rcx, 32(%rsp)	# Fim, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7168: 		Gre = rt2[v];
	movq	288(%rsp), %rdi	# %sfp, rt2
	movq	(%rdi,%rdx,8), %rdx	# MEM[(fpr *)rt2_496 + v_1924 * 8], Gre
	movq	%rdx, 64(%rsp)	# Gre, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7169: 		Gim = rt2[v + sn];
	movq	(%rdi,%rsi), %rsi	# MEM[(fpr *)rt2_496 + ivtmp.1407_1007 * 1], Gim
	movq	%rsi, 88(%rsp)	# Gim, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7170: 		f1re = rt3[u + 0];
	movq	16(%rsp), %rax	# %sfp, rt3
	movq	(%rax,%rbp,8), %r15	# MEM[(fpr *)rt3_497 + u_1925 * 8], f1re
	movq	%r15, 200(%rsp)	# f1re, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7171: 		f1im = rt3[u + 0 + hn];
	movq	(%rax,%r13), %rdi	# MEM[(fpr *)rt3_497 + ivtmp.1408_886 * 1], f1im
	movq	%rdi, 112(%rsp)	# f1im, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7172: 		f2re = rt3[u + 1];
	movq	8(%rax,%rbp,8), %r11	# MEM[(fpr *)rt3_497 + 8B + u_1925 * 8], f2re
	movq	%r11, 120(%rsp)	# f2re, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7173: 		f2im = rt3[u + 1 + hn];
	movq	8(%rax,%r13), %r9	# MEM[(fpr *)rt3_497 + 8B + ivtmp.1408_886 * 1], f2im
# inputs/bootstrap/source/falcon-keygen.c:7174: 		f3re = rt3[u + 2];
	movq	16(%rax,%rbp,8), %r15	# MEM[(fpr *)rt3_497 + 16B + u_1925 * 8], f3re
# inputs/bootstrap/source/falcon-keygen.c:7175: 		f3im = rt3[u + 2 + hn];
	movq	16(%rax,%r13), %r14	# MEM[(fpr *)rt3_497 + 16B + ivtmp.1408_886 * 1], f3im
# inputs/bootstrap/source/falcon-keygen.c:7176: 		g1re = rt4[u + 0];
	movq	(%rbx,%rbp,8), %r10	# MEM[(fpr *)rt4_498 + u_1925 * 8], g1re
	movq	%r10, 136(%rsp)	# g1re, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7177: 		g1im = rt4[u + 0 + hn];
	movq	(%rbx,%r13), %r8	# MEM[(fpr *)rt4_498 + ivtmp.1408_886 * 1], g1im
	movq	%r8, 144(%rsp)	# g1im, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7178: 		g2re = rt4[u + 1];
	movq	8(%rbx,%rbp,8), %r12	# MEM[(fpr *)rt4_498 + 8B + u_1925 * 8], g2re
	movq	%r12, 104(%rsp)	# g2re, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7179: 		g2im = rt4[u + 1 + hn];
	movq	8(%rbx,%r13), %rdi	# MEM[(fpr *)rt4_498 + 8B + ivtmp.1408_886 * 1], g2im
	movq	%rdi, 152(%rsp)	# g2im, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7180: 		g3re = rt4[u + 2];
	movq	16(%rbx,%rbp,8), %r11	# MEM[(fpr *)rt4_498 + 16B + u_1925 * 8], g3re
	movq	%r11, 160(%rsp)	# g3re, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7181: 		g3im = rt4[u + 2 + hn];
	movq	16(%rbx,%r13), %r10	# MEM[(fpr *)rt4_498 + 16B + ivtmp.1408_886 * 1], g3im
	movq	%r10, 168(%rsp)	# g3im, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7183: 		FPC_MUL(re, im, f2re, f2im, f3re, f3im);
	movq	%r14, %rsi	# f3im,
	movq	%r9, 128(%rsp)	# f2im, %sfp
	movq	%r9, %rdi	# f2im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2065, _547
# inputs/bootstrap/source/falcon-keygen.c:7183: 		FPC_MUL(re, im, f2re, f2im, f3re, f3im);
	movq	%r15, %rsi	# f3re,
	movq	120(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2066, _548
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r9	#, y_549
	xorq	%r12, %r9	# _547, y_549
	movq	%r9, %rsi	# y_549, y_549
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, 216(%rsp)	# tmp2067, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7183: 		FPC_MUL(re, im, f2re, f2im, f3re, f3im);
	movq	%r15, %rsi	# f3re,
	movq	128(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2068, _551
# inputs/bootstrap/source/falcon-keygen.c:7183: 		FPC_MUL(re, im, f2re, f2im, f3re, f3im);
	movq	%r14, %rsi	# f3im,
	movq	120(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2069, _552
# inputs/bootstrap/source/falcon-keygen.c:7183: 		FPC_MUL(re, im, f2re, f2im, f3re, f3im);
	movq	%r12, %rsi	# _551,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7184: 		FPC_MUL(rt4[u + 0], rt4[u + 0 + hn], re, im, Gre, Gim);
	movq	88(%rsp), %rsi	# %sfp,
	movq	%rax, 224(%rsp)	# fpct_d_im, %sfp
	movq	%rax, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2071, _554
# inputs/bootstrap/source/falcon-keygen.c:7184: 		FPC_MUL(rt4[u + 0], rt4[u + 0 + hn], re, im, Gre, Gim);
	movq	64(%rsp), %rsi	# %sfp,
	movq	216(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2072, _555
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r9	#, y_556
	xorq	%r12, %r9	# _554, y_556
	movq	%r9, %rsi	# y_556, y_556
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp2073, _557
# inputs/bootstrap/source/falcon-keygen.c:7184: 		FPC_MUL(rt4[u + 0], rt4[u + 0 + hn], re, im, Gre, Gim);
	movq	64(%rsp), %rsi	# %sfp,
	movq	224(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, 224(%rsp)	# tmp2074, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7184: 		FPC_MUL(rt4[u + 0], rt4[u + 0 + hn], re, im, Gre, Gim);
	movq	88(%rsp), %rsi	# %sfp,
	movq	216(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2075, _559
# inputs/bootstrap/source/falcon-keygen.c:7184: 		FPC_MUL(rt4[u + 0], rt4[u + 0 + hn], re, im, Gre, Gim);
	movq	224(%rsp), %rsi	# %sfp,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7184: 		FPC_MUL(rt4[u + 0], rt4[u + 0 + hn], re, im, Gre, Gim);
	movq	%r12, (%rbx,%rbp,8)	# _557, MEM[(fpr *)rt4_498 + u_1925 * 8]
	movq	%rax, (%rbx,%r13)	# tmp2076, MEM[(fpr *)rt4_498 + ivtmp.1408_886 * 1]
# inputs/bootstrap/source/falcon-keygen.c:7185: 		FPC_MUL(re, im, f3re, f3im, f1re, f1im);
	movq	112(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# f3im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2077, _561
# inputs/bootstrap/source/falcon-keygen.c:7185: 		FPC_MUL(re, im, f3re, f3im, f1re, f1im);
	movq	200(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# f3re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2078, _562
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r9	#, y_563
	xorq	%r12, %r9	# _561, y_563
	movq	%r9, %rsi	# y_563, y_563
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp2079, _564
# inputs/bootstrap/source/falcon-keygen.c:7185: 		FPC_MUL(re, im, f3re, f3im, f1re, f1im);
	movq	200(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# f3im,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp2080, _565
# inputs/bootstrap/source/falcon-keygen.c:7185: 		FPC_MUL(re, im, f3re, f3im, f1re, f1im);
	movq	112(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# f3re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2081, _566
# inputs/bootstrap/source/falcon-keygen.c:7185: 		FPC_MUL(re, im, f3re, f3im, f1re, f1im);
	movq	%r14, %rsi	# _565,
	call	fpr_add@PLT	#
	movq	%rax, %r15	# tmp2082, fpct_d_im
# inputs/bootstrap/source/falcon-keygen.c:7186: 		FPC_MUL(rt4[u + 1], rt4[u + 1 + hn], re, im, Gre, Gim);
	movq	88(%rsp), %rsi	# %sfp,
	movq	%rax, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r14	# tmp2083, _568
# inputs/bootstrap/source/falcon-keygen.c:7186: 		FPC_MUL(rt4[u + 1], rt4[u + 1 + hn], re, im, Gre, Gim);
	movq	64(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# _564,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2084, _569
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r9	#, y_570
	xorq	%r14, %r9	# _568, y_570
	movq	%r9, %rsi	# y_570, y_570
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp2085, _571
# inputs/bootstrap/source/falcon-keygen.c:7186: 		FPC_MUL(rt4[u + 1], rt4[u + 1 + hn], re, im, Gre, Gim);
	movq	64(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r15	# tmp2086, _572
# inputs/bootstrap/source/falcon-keygen.c:7186: 		FPC_MUL(rt4[u + 1], rt4[u + 1 + hn], re, im, Gre, Gim);
	movq	88(%rsp), %rsi	# %sfp,
	movq	%r12, %rdi	# _564,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2087, _573
# inputs/bootstrap/source/falcon-keygen.c:7186: 		FPC_MUL(rt4[u + 1], rt4[u + 1 + hn], re, im, Gre, Gim);
	movq	%r15, %rsi	# _572,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7186: 		FPC_MUL(rt4[u + 1], rt4[u + 1 + hn], re, im, Gre, Gim);
	movq	%r14, 8(%rbx,%rbp,8)	# _571, MEM[(fpr *)rt4_498 + 8B + u_1925 * 8]
	movq	%rax, 8(%rbx,%r13)	# tmp2088, MEM[(fpr *)rt4_498 + 8B + ivtmp.1408_886 * 1]
# inputs/bootstrap/source/falcon-keygen.c:7187: 		FPC_MUL(re, im, f1re, f1im, f2re, f2im);
	movq	128(%rsp), %rsi	# %sfp,
	movq	112(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2089, _575
# inputs/bootstrap/source/falcon-keygen.c:7187: 		FPC_MUL(re, im, f1re, f1im, f2re, f2im);
	movq	120(%rsp), %rsi	# %sfp,
	movq	200(%rsp), %r15	# %sfp, f1re
	movq	%r15, %rdi	# f1re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2090, _576
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r14	#, y_577
	xorq	%r12, %r14	# _575, y_577
	movq	%r14, %rsi	# y_577, y_577
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp2091, _578
# inputs/bootstrap/source/falcon-keygen.c:7187: 		FPC_MUL(re, im, f1re, f1im, f2re, f2im);
	movq	120(%rsp), %rsi	# %sfp,
	movq	112(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2092, _579
# inputs/bootstrap/source/falcon-keygen.c:7187: 		FPC_MUL(re, im, f1re, f1im, f2re, f2im);
	movq	128(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# f1re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2093, _580
# inputs/bootstrap/source/falcon-keygen.c:7187: 		FPC_MUL(re, im, f1re, f1im, f2re, f2im);
	movq	%r12, %rsi	# _579,
	call	fpr_add@PLT	#
	movq	%rax, %r15	# tmp2094, fpct_d_im
# inputs/bootstrap/source/falcon-keygen.c:7188: 		FPC_MUL(rt4[u + 2], rt4[u + 2 + hn], re, im, Gre, Gim);
	movq	88(%rsp), %rsi	# %sfp,
	movq	%rax, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2095, _582
# inputs/bootstrap/source/falcon-keygen.c:7188: 		FPC_MUL(rt4[u + 2], rt4[u + 2 + hn], re, im, Gre, Gim);
	movq	64(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# _578,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2096, _583
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r9	#, y_584
	xorq	%r12, %r9	# _582, y_584
	movq	%r9, %rsi	# y_584, y_584
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp2097, _585
# inputs/bootstrap/source/falcon-keygen.c:7188: 		FPC_MUL(rt4[u + 2], rt4[u + 2 + hn], re, im, Gre, Gim);
	movq	64(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r15	# tmp2098, _586
# inputs/bootstrap/source/falcon-keygen.c:7188: 		FPC_MUL(rt4[u + 2], rt4[u + 2 + hn], re, im, Gre, Gim);
	movq	88(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# _578,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2099, _587
# inputs/bootstrap/source/falcon-keygen.c:7188: 		FPC_MUL(rt4[u + 2], rt4[u + 2 + hn], re, im, Gre, Gim);
	movq	%r15, %rsi	# _586,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7188: 		FPC_MUL(rt4[u + 2], rt4[u + 2 + hn], re, im, Gre, Gim);
	movq	%r12, 16(%rbx,%rbp,8)	# _585, MEM[(fpr *)rt4_498 + 16B + u_1925 * 8]
	movq	%rax, 16(%rbx,%r13)	# tmp2100, MEM[(fpr *)rt4_498 + 16B + ivtmp.1408_886 * 1]
# inputs/bootstrap/source/falcon-keygen.c:7189: 		FPC_MUL(re, im, g2re, g2im, g3re, g3im);
	movq	168(%rsp), %rsi	# %sfp,
	movq	152(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2101, _589
# inputs/bootstrap/source/falcon-keygen.c:7189: 		FPC_MUL(re, im, g2re, g2im, g3re, g3im);
	movq	160(%rsp), %rsi	# %sfp,
	movq	104(%rsp), %r15	# %sfp, g2re
	movq	%r15, %rdi	# g2re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2102, _590
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r9	#, y_591
	xorq	%r12, %r9	# _589, y_591
	movq	%r9, %rsi	# y_591, y_591
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp2103, _592
# inputs/bootstrap/source/falcon-keygen.c:7189: 		FPC_MUL(re, im, g2re, g2im, g3re, g3im);
	movq	160(%rsp), %rsi	# %sfp,
	movq	152(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2104, _593
# inputs/bootstrap/source/falcon-keygen.c:7189: 		FPC_MUL(re, im, g2re, g2im, g3re, g3im);
	movq	168(%rsp), %rsi	# %sfp,
	movq	%r15, 104(%rsp)	# g2re, %sfp
	movq	%r15, %rdi	# g2re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2105, _594
# inputs/bootstrap/source/falcon-keygen.c:7189: 		FPC_MUL(re, im, g2re, g2im, g3re, g3im);
	movq	%r12, %rsi	# _593,
	call	fpr_add@PLT	#
	movq	%rax, %r15	# tmp2106, fpct_d_im
# inputs/bootstrap/source/falcon-keygen.c:7190: 		FPC_MUL(rt3[u + 0], rt3[u + 0 + hn], re, im, Fre, Fim);
	movq	32(%rsp), %rsi	# %sfp,
	movq	%rax, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2107, _596
# inputs/bootstrap/source/falcon-keygen.c:7190: 		FPC_MUL(rt3[u + 0], rt3[u + 0 + hn], re, im, Fre, Fim);
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# _592,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2108, _597
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r9	#, y_598
	xorq	%r12, %r9	# _596, y_598
	movq	%r9, %rsi	# y_598, y_598
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp2109, _599
# inputs/bootstrap/source/falcon-keygen.c:7190: 		FPC_MUL(rt3[u + 0], rt3[u + 0 + hn], re, im, Fre, Fim);
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r15	# tmp2110, _600
# inputs/bootstrap/source/falcon-keygen.c:7190: 		FPC_MUL(rt3[u + 0], rt3[u + 0 + hn], re, im, Fre, Fim);
	movq	32(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# _592,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2111, _601
# inputs/bootstrap/source/falcon-keygen.c:7190: 		FPC_MUL(rt3[u + 0], rt3[u + 0 + hn], re, im, Fre, Fim);
	movq	%r15, %rsi	# _600,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7190: 		FPC_MUL(rt3[u + 0], rt3[u + 0 + hn], re, im, Fre, Fim);
	movq	16(%rsp), %rcx	# %sfp, rt3
	movq	%r12, (%rcx,%rbp,8)	# _599, MEM[(fpr *)rt3_497 + u_1925 * 8]
	movq	%rax, (%rcx,%r13)	# tmp2112, MEM[(fpr *)rt3_497 + ivtmp.1408_886 * 1]
# inputs/bootstrap/source/falcon-keygen.c:7191: 		FPC_MUL(re, im, g3re, g3im, g1re, g1im);
	movq	144(%rsp), %rsi	# %sfp,
	movq	168(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2113, _603
# inputs/bootstrap/source/falcon-keygen.c:7191: 		FPC_MUL(re, im, g3re, g3im, g1re, g1im);
	movq	136(%rsp), %r15	# %sfp, g1re
	movq	%r15, %rsi	# g1re,
	movq	160(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2114, _604
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r9	#, y_605
	xorq	%r12, %r9	# _603, y_605
	movq	%r9, %rsi	# y_605, y_605
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp2115, _606
# inputs/bootstrap/source/falcon-keygen.c:7191: 		FPC_MUL(re, im, g3re, g3im, g1re, g1im);
	movq	%r15, 136(%rsp)	# g1re, %sfp
	movq	%r15, %rsi	# g1re,
	movq	168(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2116, _607
# inputs/bootstrap/source/falcon-keygen.c:7191: 		FPC_MUL(re, im, g3re, g3im, g1re, g1im);
	movq	144(%rsp), %rsi	# %sfp,
	movq	160(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2117, _608
# inputs/bootstrap/source/falcon-keygen.c:7191: 		FPC_MUL(re, im, g3re, g3im, g1re, g1im);
	movq	%r12, %rsi	# _607,
	call	fpr_add@PLT	#
	movq	%rax, %r15	# tmp2118, fpct_d_im
# inputs/bootstrap/source/falcon-keygen.c:7192: 		FPC_MUL(rt3[u + 1], rt3[u + 1 + hn], re, im, Fre, Fim);
	movq	32(%rsp), %rsi	# %sfp,
	movq	%rax, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2119, _610
# inputs/bootstrap/source/falcon-keygen.c:7192: 		FPC_MUL(rt3[u + 1], rt3[u + 1 + hn], re, im, Fre, Fim);
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# _606,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2120, _611
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r11	#, y_612
	xorq	%r12, %r11	# _610, y_612
	movq	%r11, %rsi	# y_612, y_612
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp2121, _613
# inputs/bootstrap/source/falcon-keygen.c:7192: 		FPC_MUL(rt3[u + 1], rt3[u + 1 + hn], re, im, Fre, Fim);
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r15	# tmp2122, _614
# inputs/bootstrap/source/falcon-keygen.c:7192: 		FPC_MUL(rt3[u + 1], rt3[u + 1 + hn], re, im, Fre, Fim);
	movq	32(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# _606,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2123, _615
# inputs/bootstrap/source/falcon-keygen.c:7192: 		FPC_MUL(rt3[u + 1], rt3[u + 1 + hn], re, im, Fre, Fim);
	movq	%r15, %rsi	# _614,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7192: 		FPC_MUL(rt3[u + 1], rt3[u + 1 + hn], re, im, Fre, Fim);
	movq	16(%rsp), %rcx	# %sfp, rt3
	movq	%r12, 8(%rcx,%rbp,8)	# _613, MEM[(fpr *)rt3_497 + 8B + u_1925 * 8]
	movq	%rax, 8(%rcx,%r13)	# tmp2124, MEM[(fpr *)rt3_497 + 8B + ivtmp.1408_886 * 1]
# inputs/bootstrap/source/falcon-keygen.c:7193: 		FPC_MUL(re, im, g1re, g1im, g2re, g2im);
	movq	152(%rsp), %rsi	# %sfp,
	movq	144(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2125, _617
# inputs/bootstrap/source/falcon-keygen.c:7193: 		FPC_MUL(re, im, g1re, g1im, g2re, g2im);
	movq	104(%rsp), %rsi	# %sfp,
	movq	136(%rsp), %r15	# %sfp, g1re
	movq	%r15, %rdi	# g1re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2126, _618
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r11	#, y_619
	xorq	%r12, %r11	# _617, y_619
	movq	%r11, %rsi	# y_619, y_619
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r14	# tmp2127, _620
# inputs/bootstrap/source/falcon-keygen.c:7193: 		FPC_MUL(re, im, g1re, g1im, g2re, g2im);
	movq	104(%rsp), %rsi	# %sfp,
	movq	144(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2128, _621
# inputs/bootstrap/source/falcon-keygen.c:7193: 		FPC_MUL(re, im, g1re, g1im, g2re, g2im);
	movq	152(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# g1re,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2129, _622
# inputs/bootstrap/source/falcon-keygen.c:7193: 		FPC_MUL(re, im, g1re, g1im, g2re, g2im);
	movq	%r12, %rsi	# _621,
	call	fpr_add@PLT	#
	movq	%rax, %r15	# tmp2130, fpct_d_im
# inputs/bootstrap/source/falcon-keygen.c:7194: 		FPC_MUL(rt3[u + 2], rt3[u + 2 + hn], re, im, Fre, Fim);
	movq	32(%rsp), %rsi	# %sfp,
	movq	%rax, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r12	# tmp2131, _624
# inputs/bootstrap/source/falcon-keygen.c:7194: 		FPC_MUL(rt3[u + 2], rt3[u + 2 + hn], re, im, Fre, Fim);
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# _620,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2132, _625
# inputs/bootstrap/source/fpr-emulated.h:154: 	y ^= (uint64_t)1 << 63;
	movabsq	$-9223372036854775808, %r11	#, y_626
	xorq	%r12, %r11	# _624, y_626
	movq	%r11, %rsi	# y_626, y_626
# inputs/bootstrap/source/fpr-emulated.h:155: 	return fpr_add(x, y);
	call	fpr_add@PLT	#
	movq	%rax, %r12	# tmp2133, _627
# inputs/bootstrap/source/falcon-keygen.c:7194: 		FPC_MUL(rt3[u + 2], rt3[u + 2 + hn], re, im, Fre, Fim);
	movq	24(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# fpct_d_im,
	call	fpr_mul@PLT	#
	movq	%rax, %r15	# tmp2134, _628
# inputs/bootstrap/source/falcon-keygen.c:7194: 		FPC_MUL(rt3[u + 2], rt3[u + 2 + hn], re, im, Fre, Fim);
	movq	32(%rsp), %rsi	# %sfp,
	movq	%r14, %rdi	# _620,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2135, _629
# inputs/bootstrap/source/falcon-keygen.c:7194: 		FPC_MUL(rt3[u + 2], rt3[u + 2 + hn], re, im, Fre, Fim);
	movq	%r15, %rsi	# _628,
	call	fpr_add@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7194: 		FPC_MUL(rt3[u + 2], rt3[u + 2 + hn], re, im, Fre, Fim);
	movq	16(%rsp), %rcx	# %sfp, rt3
	movq	%r12, 16(%rcx,%rbp,8)	# _627, MEM[(fpr *)rt3_497 + 16B + u_1925 * 8]
	movq	%rax, 16(%rcx,%r13)	# tmp2136, MEM[(fpr *)rt3_497 + 16B + ivtmp.1408_886 * 1]
# inputs/bootstrap/source/falcon-keygen.c:7130: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	addq	$3, %rbp	#, u
# inputs/bootstrap/source/falcon-keygen.c:7130: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	addq	$1, 184(%rsp)	#, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7130: 	for (u = 0, v = 0; u < hn; u += 3, v ++) {
	addq	$8, 192(%rsp)	#, %sfp
	addq	$24, %r13	#, ivtmp.1408
	movq	280(%rsp), %rax	# %sfp, hn
	cmpq	%rax, %rbp	# hn, u
	jb	.L796	#,
	movq	312(%rsp), %r14	# %sfp, rt5
.L795:
# inputs/bootstrap/source/falcon-keygen.c:7203: 	memmove(rt1, rt3, 2 * n * sizeof *rt3);
	movq	272(%rsp), %r15	# %sfp, n
	movq	%r15, %rax	# n, _633
	salq	$4, %rax	#, _633
	movq	%rax, 32(%rsp)	# _633, %sfp
	movq	%rax, %rdx	# _633,
	movq	16(%rsp), %rsi	# %sfp,
	movq	264(%rsp), %rbx	# %sfp, rt1
	movq	%rbx, %rdi	# rt1,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7204: 	rt2 = rt1 + n;
	movq	%rbx, 264(%rsp)	# rt1, %sfp
	movq	304(%rsp), %rcx	# %sfp, _461
	leaq	(%rbx,%rcx), %r13	#, rt2
	movq	%r13, 16(%rsp)	# rt2, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7205: 	rt3 = rt2 + n;
	leaq	0(%r13,%rcx), %rbp	#, rt3
# inputs/bootstrap/source/falcon-keygen.c:7206: 	rt4 = rt3 + n;
	leaq	0(%rbp,%rcx), %r12	#, rt4
# inputs/bootstrap/source/falcon-keygen.c:7218: 	poly_small_to_fp(rt3, f, logn, 1);
	leaq	24960(%rsp), %rsi	#, tmp1412
	movl	$1, %ecx	#,
	movl	300(%rsp), %ebx	# %sfp, logn
	movl	%ebx, %edx	# logn,
	movq	%rbp, %rdi	# rt3,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:7219: 	poly_small_to_fp(rt4, g, logn, 1);
	leaq	18816(%rsp), %rsi	#, tmp1413
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%r12, %rdi	# rt4,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:7220: 	falcon_FFT3(rt3, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%rbp, %rdi	# rt3,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7221: 	falcon_FFT3(rt4, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%r12, %rdi	# rt4,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7226: 	falcon_poly_adj_fft3(rt3, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%rbp, %rdi	# rt3,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7227: 	falcon_poly_adj_fft3(rt4, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%r12, %rdi	# rt4,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7228: 	falcon_poly_mul_fft3(rt3, rt1, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	264(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# rt3,
	call	falcon_poly_mul_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7229: 	falcon_poly_mul_fft3(rt4, rt2, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%r13, %rsi	# rt2,
	movq	%r12, %rdi	# rt4,
	call	falcon_poly_mul_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7230: 	falcon_poly_add_fft3(rt3, rt4, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%r12, %rsi	# rt4,
	movq	%rbp, %rdi	# rt3,
	call	falcon_poly_add3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7231: 	falcon_poly_mul_autoadj_fft3(rt3, rt5, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%r14, %rsi	# rt5,
	movq	%rbp, %rdi	# rt3,
	call	falcon_poly_mul_autoadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7236: 	falcon_iFFT3(rt3, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%rbp, %rdi	# rt3,
	call	falcon_iFFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7237: 	for (u = 0; u < n; u ++) {
	movq	%r15, %rax	# n, n
	testq	%r15, %r15	# n
	je	.L797	#,
# inputs/bootstrap/source/falcon-keygen.c:7237: 	for (u = 0; u < n; u ++) {
	movl	$0, %ebx	#, u
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387904, %r15	#, tmp1417
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	$1085, %r14d	#, tmp1419
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	$1021, %r13d	#, tmp1421
	movq	%r12, 24(%rsp)	# rt4, %sfp
	movq	%rax, %r12	# n, n
.L798:
# inputs/bootstrap/source/falcon-keygen.c:7238: 		rt3[u] = fpr_of(fpr_rint(rt3[u]));
	movq	0(%rbp,%rbx,8), %rdx	# MEM[(fpr *)rt3_635 + u_1926 * 8], _640
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdx, %rcx	# _640, _665
	salq	$10, %rcx	#, _665
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp2535
	andq	%rax, %rcx	# tmp2535, _666
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r15, %rcx	# tmp1417, m
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rdx, %rsi	# _640, _668
	shrq	$52, %rsi	#, _668
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %esi	#, _670
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%r14d, %r8d	# tmp1419, e
	subl	%esi, %r8d	# _670, e
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r13d, %eax	# tmp1421, _672
	subl	%esi, %eax	# _670, _672
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _674
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _674, _675
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp1424
	andq	%rcx, %rax	# m, m
# inputs/bootstrap/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r8d, %r10d	# e, e
	andl	$63, %r10d	#, e
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	$63, %ecx	#, tmp1425
	subl	%r10d, %ecx	# e, _678
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdi	# m, _679
	salq	$32, %rdi	#, _679
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _678
	cmove	%rax, %rdi	# _679,, m, x_685
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _686
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdi	# _686, _687
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdi, %r9	# _687, _689
	shrq	$32, %r9	#, _689
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r9d	#, _691
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edi, %r9d	# _687, dd
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rsi	# m, _699
	shrq	$32, %rsi	#, _699
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r10d	#, tmp2191
	cmove	%rax, %rsi	# _699,, m, x_705
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r8d, %ecx	# e, e
	andl	$31, %ecx	#, e
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rsi	# _706, _707
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r9d, %ecx	# dd, _695
	negl	%ecx	# _695
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r9d, %ecx	# dd, _696
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _697
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdi	#, _693
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edi, %ecx	# _693, f_698
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %eax	#, tmp1444
	shrl	%cl, %eax	# f_698, tmp1444
	movl	%eax, %edi	# tmp1444, _708
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %edi	#, _710
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%rsi, %rdi	# _707, m_711
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rdx, %rax	# _640, _714
	sarq	$63, %rax	#, _714
	xorq	%rax, %rdi	# _714, _716
# inputs/bootstrap/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rdx	#, _712
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rdx, %rdi	# _712, _718
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7238: 		rt3[u] = fpr_of(fpr_rint(rt3[u]));
	movq	%rax, 0(%rbp,%rbx,8)	# tmp2137, MEM[(fpr *)rt3_635 + u_1926 * 8]
# inputs/bootstrap/source/falcon-keygen.c:7237: 	for (u = 0; u < n; u ++) {
	addq	$1, %rbx	#, u
# inputs/bootstrap/source/falcon-keygen.c:7237: 	for (u = 0; u < n; u ++) {
	cmpq	%rbx, %r12	# u, n
	jne	.L798	#,
	movq	24(%rsp), %r12	# %sfp, rt4
.L797:
# inputs/bootstrap/source/falcon-keygen.c:7240: 	falcon_FFT3(rt3, logn, 1);
	movl	$1, %edx	#,
	movl	300(%rsp), %ebx	# %sfp, logn
	movl	%ebx, %esi	# logn,
	movq	%rbp, %rdi	# rt3,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7245: 	poly_small_to_fp(rt4, f, logn, 1);
	leaq	24960(%rsp), %rsi	#, tmp1452
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%r12, %rdi	# rt4,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:7246: 	falcon_FFT3(rt4, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%r12, %rdi	# rt4,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7247: 	falcon_poly_mul_fft3(rt4, rt3, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%rbp, %rsi	# rt3,
	movq	%r12, %rdi	# rt4,
	call	falcon_poly_mul_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7248: 	falcon_poly_sub_fft3(rt1, rt4, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%r12, %rsi	# rt4,
	movq	264(%rsp), %r14	# %sfp, rt1
	movq	%r14, %rdi	# rt1,
	call	falcon_poly_sub3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7249: 	poly_small_to_fp(rt4, g, logn, 1);
	leaq	18816(%rsp), %rsi	#, tmp1453
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%r12, %rdi	# rt4,
	call	poly_small_to_fp	#
# inputs/bootstrap/source/falcon-keygen.c:7250: 	falcon_FFT3(rt4, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%r12, %rdi	# rt4,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7251: 	falcon_poly_mul_fft3(rt4, rt3, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%rbp, %rsi	# rt3,
	movq	%r12, %rdi	# rt4,
	call	falcon_poly_mul_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7252: 	falcon_poly_sub_fft3(rt2, rt4, logn, 1);
	movl	$1, %ecx	#,
	movl	%ebx, %edx	# logn,
	movq	%r12, %rsi	# rt4,
	movq	16(%rsp), %r15	# %sfp, rt2
	movq	%r15, %rdi	# rt2,
	call	falcon_poly_sub3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7257: 	falcon_iFFT3(rt1, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%r14, %rdi	# rt1,
	call	falcon_iFFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7258: 	falcon_iFFT3(rt2, logn, 1);
	movl	$1, %edx	#,
	movl	%ebx, %esi	# logn,
	movq	%r15, %rdi	# rt2,
	call	falcon_iFFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7260: 	Fp = fk->tmp;
	movq	48(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %rcx	# fk_82(D)->tmp, Fp
	movq	%rcx, 16(%rsp)	# Fp, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7261: 	Gp = Fp + n;
	movq	272(%rsp), %r15	# %sfp, n
	leaq	0(,%r15,4), %rax	#, _645
# inputs/bootstrap/source/falcon-keygen.c:7261: 	Gp = Fp + n;
	leaq	(%rcx,%rax), %rdx	#, Gp
	movq	%rdx, 24(%rsp)	# Gp, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7262: 	t1 = Gp + n;
	leaq	(%rdx,%rax), %rsi	#, t1_647
# inputs/bootstrap/source/falcon-keygen.c:7263: 	rt5 = align_fpr(fk->tmp, t1);
	movq	%rcx, %rdi	# Fp,
	call	align_fpr	#
	movq	%rax, %rbx	# tmp2138, rt5
# inputs/bootstrap/source/falcon-keygen.c:7264: 	memmove(rt5, rt1, 2 * n * sizeof *rt1);
	movq	32(%rsp), %rdx	# %sfp,
	movq	%r14, %rsi	# rt1,
	movq	%rax, %rdi	# rt5,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7267: 	for (u = 0; u < n; u ++) {
	testq	%r15, %r15	# n
	je	.L790	#,
	movq	304(%rsp), %r13	# %sfp, _461
	addq	%rbx, %r13	# rt5, _461
# inputs/bootstrap/source/falcon-keygen.c:7267: 	for (u = 0; u < n; u ++) {
	movl	$0, %esi	#, u
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387904, %r12	#, tmp1458
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	$1085, %ebp	#, tmp1460
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	$1021, %r11d	#, tmp1462
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	$63, %r10d	#, tmp1466
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %r9d	#, tmp1485
.L799:
# inputs/bootstrap/source/falcon-keygen.c:7268: 		Fp[u] = (uint32_t)fpr_rint(rt1[u]);
	movq	(%rbx,%rsi,8), %rdi	# MEM[(fpr *)rt5_648 + u_1927 * 8], _652
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdi, %rdx	# _652, _773
	salq	$10, %rdx	#, _773
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp2556
	andq	%rax, %rdx	# tmp2556, _774
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r12, %rdx	# tmp1458, m
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rdi, %rcx	# _652, _776
	shrq	$52, %rcx	#, _776
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %ecx	#, _778
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%ebp, %r14d	# tmp1460, e
	subl	%ecx, %r14d	# _778, e
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r11d, %r8d	# tmp1462, _780
	subl	%ecx, %r8d	# _778, _780
	movl	%r8d, %eax	# _780, _780
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _782
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _782, _783
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp1465
	andq	%rdx, %rax	# m, m
# inputs/bootstrap/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r14d, %r15d	# e, e
	andl	$63, %r15d	#, e
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	%r10d, %ecx	# tmp1466, _786
	subl	%r15d, %ecx	# e, _786
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdx	# m, _787
	salq	$32, %rdx	#, _787
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _786
	cmove	%rax, %rdx	# _787,, m, x_793
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _794
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdx	# _794, _795
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdx, %r8	# _795, _797
	shrq	$32, %r8	#, _797
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r8d	#, _799
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edx, %r8d	# _795, dd
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _807
	shrq	$32, %rcx	#, _807
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r15d	#, tmp2192
	cmovne	%rcx, %rax	# _807,, x_813
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r14d, %ecx	# e, e
	andl	$31, %ecx	#, e
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rax	# _814, _815
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r8d, %ecx	# dd, _803
	negl	%ecx	# _803
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r8d, %ecx	# dd, _804
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _805
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdx	#, _801
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edx, %ecx	# _801, f_806
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	%r9d, %edx	# tmp1485, _816
	shrl	%cl, %edx	# f_806, _816
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %edx	#, _818
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%rdx, %rax	# _818, m_819
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rdi, %rdx	# _652, _822
	sarq	$63, %rdx	#, _822
	xorq	%rdx, %rax	# _822, _824
# inputs/bootstrap/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rdi	#, _820
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rax, %rdi	# _824, _826
# inputs/bootstrap/source/falcon-keygen.c:7268: 		Fp[u] = (uint32_t)fpr_rint(rt1[u]);
	movq	16(%rsp), %rcx	# %sfp, Fp
	movl	%edi, (%rcx,%rsi,4)	# _826, MEM[(uint32_t *)Fp_644 + u_1927 * 4]
# inputs/bootstrap/source/falcon-keygen.c:7269: 		Gp[u] = (uint32_t)fpr_rint(rt2[u]);
	movq	0(%r13,%rsi,8), %rdi	# MEM[(fpr *)_1576 + u_1927 * 8], _660
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rdi, %rdx	# _660, _719
	salq	$10, %rdx	#, _719
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp2571
	andq	%rax, %rdx	# tmp2571, _720
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r12, %rdx	# tmp1458, m
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rdi, %rcx	# _660, _722
	shrq	$52, %rcx	#, _722
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %ecx	#, _724
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%ebp, %r14d	# tmp1460, e
	subl	%ecx, %r14d	# _724, e
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r11d, %eax	# tmp1462, _726
	subl	%ecx, %eax	# _724, _726
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _728
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _728, _729
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp1503
	andq	%rdx, %rax	# m, m
# inputs/bootstrap/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r14d, %r15d	# e, e
	andl	$63, %r15d	#, e
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	%r10d, %ecx	# tmp1466, _732
	subl	%r15d, %ecx	# e, _732
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdx	# m, _733
	salq	$32, %rdx	#, _733
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _732
	cmove	%rax, %rdx	# _733,, m, x_739
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _740
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdx	# _740, _741
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdx, %r8	# _741, _743
	shrq	$32, %r8	#, _743
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %r8d	#, _745
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edx, %r8d	# _741, dd
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _753
	shrq	$32, %rcx	#, _753
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r15d	#, tmp2193
	cmovne	%rcx, %rax	# _753,, x_759
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r14d, %ecx	# e, e
	andl	$31, %ecx	#, e
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rax	# _760, _761
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%r8d, %ecx	# dd, _749
	negl	%ecx	# _749
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%r8d, %ecx	# dd, _750
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _751
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdx	#, _747
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edx, %ecx	# _747, f_752
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	%r9d, %edx	# tmp1485, _762
	shrl	%cl, %edx	# f_752, _762
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %edx	#, _764
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%rdx, %rax	# _764, m_765
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rdi, %rdx	# _660, _768
	sarq	$63, %rdx	#, _768
	xorq	%rdx, %rax	# _768, _770
# inputs/bootstrap/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rdi	#, _766
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rax, %rdi	# _770, _772
# inputs/bootstrap/source/falcon-keygen.c:7269: 		Gp[u] = (uint32_t)fpr_rint(rt2[u]);
	movq	24(%rsp), %rax	# %sfp, Gp
	movl	%edi, (%rax,%rsi,4)	# _772, MEM[(uint32_t *)Gp_646 + u_1927 * 4]
# inputs/bootstrap/source/falcon-keygen.c:7267: 	for (u = 0; u < n; u ++) {
	addq	$1, %rsi	#, u
# inputs/bootstrap/source/falcon-keygen.c:7267: 	for (u = 0; u < n; u ++) {
	cmpq	%rsi, 272(%rsp)	# u, %sfp
	jne	.L799	#,
.L790:
# inputs/bootstrap/source/falcon-keygen.c:7342: 	if (!poly_big_to_small(F, fk->tmp, logn, fk->ternary)
	movq	48(%rsp), %rax	# %sfp, fk
	movl	4(%rax), %r12d	# fk_82(D)->ternary, _292
# inputs/bootstrap/source/falcon-keygen.c:7342: 	if (!poly_big_to_small(F, fk->tmp, logn, fk->ternary)
	movq	432(%rax), %rbx	# fk_82(D)->tmp, _293
# inputs/bootstrap/source/falcon-keygen.c:7342: 	if (!poly_big_to_small(F, fk->tmp, logn, fk->ternary)
	leaq	12672(%rsp), %rdi	#, tmp1812
	movl	%r12d, %ecx	# _292,
	movl	96(%rsp), %r14d	# %sfp, logn
	movl	%r14d, %edx	# logn,
	movq	%rbx, %rsi	# _293,
	call	poly_big_to_small	#
# inputs/bootstrap/source/falcon-keygen.c:7342: 	if (!poly_big_to_small(F, fk->tmp, logn, fk->ternary)
	testl	%eax, %eax	# tmp2147
	je	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:7289: 	n = MKN(logn, fk->ternary);
	movl	296(%rsp), %esi	# %sfp, _272
	leal	1(%rsi,%rsi), %eax	#, _275
	movl	%r14d, %edx	# logn, logn
	movl	%r14d, %ecx	# logn, _276
	subl	%esi, %ecx	# _272, _276
# inputs/bootstrap/source/falcon-keygen.c:7289: 	n = MKN(logn, fk->ternary);
	salq	%cl, %rax	# _276, _275
	movq	%rax, 24(%rsp)	# n, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7343: 		|| !poly_big_to_small(G, fk->tmp + n, logn, fk->ternary))
	leaq	0(,%rax,4), %r14	#, _297
	leaq	(%rbx,%r14), %rbp	#, _298
# inputs/bootstrap/source/falcon-keygen.c:7343: 		|| !poly_big_to_small(G, fk->tmp + n, logn, fk->ternary))
	leaq	6528(%rsp), %rdi	#, tmp1817
	movl	%r12d, %ecx	# _292,
	movq	%rbp, %rsi	# _298,
	call	poly_big_to_small	#
# inputs/bootstrap/source/falcon-keygen.c:7343: 		|| !poly_big_to_small(G, fk->tmp + n, logn, fk->ternary))
	testl	%eax, %eax	# tmp2148
	je	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:7355: 	Ft = gt + n;
	leaq	0(%rbp,%r14), %r15	#, Ft
# inputs/bootstrap/source/falcon-keygen.c:7356: 	Gt = Ft + n;
	leaq	(%r15,%r14), %r13	#, Gt
# inputs/bootstrap/source/falcon-keygen.c:7357: 	gm = Gt + n;
	leaq	0(%r13,%r14), %rax	#, gm
	movq	%rax, 16(%rsp)	# gm, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7359: 	primes = fk->ternary ? PRIMES3 : PRIMES2;
	testl	%r12d, %r12d	# _292
	jne	.L818	#,
# inputs/bootstrap/source/falcon-keygen.c:7361: 	p0i = modp_ninv31(p);
	movl	$2147473409, %edi	#,
	call	modp_ninv31	#
	movl	%eax, %r14d	# tmp2183, p0i
# inputs/bootstrap/source/falcon-keygen.c:7365: 		modp_mkgm2(gm, ft, logn, primes[0].g, p, p0i);
	movl	%eax, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	$383167813, %ecx	#,
	movl	96(%rsp), %edx	# %sfp,
	movq	%rbx, %rsi	# _293,
	movq	16(%rsp), %rdi	# %sfp,
	call	modp_mkgm2	#
# inputs/bootstrap/source/falcon-keygen.c:7360: 	p = primes[0].p;
	movl	$2147473409, %r12d	#, p
	jmp	.L836	#
.L883:
# inputs/bootstrap/source/falcon-keygen.c:7329: 			if (!solve_NTRU_binary_depth1(fk, f, g)) {
	leaq	18816(%rsp), %rdx	#, tmp1533
	leaq	24960(%rsp), %rsi	#, tmp1534
	movq	48(%rsp), %rbx	# %sfp, fk
	movq	%rbx, %rdi	# fk,
	call	solve_NTRU_binary_depth1	#
# inputs/bootstrap/source/falcon-keygen.c:7329: 			if (!solve_NTRU_binary_depth1(fk, f, g)) {
	testl	%eax, %eax	# tmp2140
	je	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:6796: 	logn = fk->logn;
	movl	(%rbx), %r12d	# fk_82(D)->logn, logn
	movl	%r12d, 64(%rsp)	# logn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6797: 	n = (size_t)1 << logn;
	movl	$1, %eax	#, tmp1535
	movl	%r12d, %ecx	# logn, tmp2589
	salq	%cl, %rax	# tmp2589, tmp1535
	movq	%rax, %r14	# tmp1535, n
	movq	%rax, 32(%rsp)	# n, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6798: 	hn = n >> 1;
	shrq	%r14	# hn
	movq	%r14, 136(%rsp)	# hn, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6816: 	p0i = modp_ninv31(p);
	movl	$2147473409, %edi	#,
	call	modp_ninv31	#
# inputs/bootstrap/source/falcon-keygen.c:6817: 	R2 = modp_R2(p, p0i);
	movl	%eax, 24(%rsp)	# p0i, %sfp
	movl	%eax, %esi	# p0i,
	movl	$2147473409, %edi	#,
	call	modp_R2	#
	movl	%eax, 104(%rsp)	# tmp2142, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6819: 	Fp = fk->tmp;
	movq	432(%rbx), %rax	# fk_82(D)->tmp, Fp
# inputs/bootstrap/source/falcon-keygen.c:6820: 	Gp = Fp + hn;
	leaq	0(,%r14,4), %rbp	#, _833
# inputs/bootstrap/source/falcon-keygen.c:6820: 	Gp = Fp + hn;
	movq	%rax, 16(%rsp)	# Fp, %sfp
	leaq	(%rax,%rbp), %r13	#, Gp
# inputs/bootstrap/source/falcon-keygen.c:6821: 	ft = Gp + hn;
	addq	%r13, %rbp	# Gp, ft
# inputs/bootstrap/source/falcon-keygen.c:6822: 	gt = ft + n;
	movl	$4, %eax	#, tmp1536
	movq	%rax, %r15	# tmp1536, tmp1536
	movl	%r12d, %edx	# logn, logn
	movl	%r12d, %ecx	# logn, tmp2596
	salq	%cl, %r15	# tmp2596, tmp1536
# inputs/bootstrap/source/falcon-keygen.c:6822: 	gt = ft + n;
	leaq	0(%rbp,%r15), %r12	#, gt
# inputs/bootstrap/source/falcon-keygen.c:6823: 	gm = gt + n;
	leaq	(%r12,%r15), %rbx	#, gm
# inputs/bootstrap/source/falcon-keygen.c:6824: 	igm = gm + n;
	leaq	(%rbx,%r15), %rdi	#, igm
	movq	%rdi, 88(%rsp)	# igm, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6826: 	modp_mkgm2(gm, igm, logn, PRIMES2[0].g, p, p0i);
	movl	24(%rsp), %r9d	# %sfp,
	movl	$2147473409, %r8d	#,
	movl	$383167813, %ecx	#,
	movq	%rdi, %rsi	# igm,
	movq	%rbx, %rdi	# gm,
	call	modp_mkgm2	#
# inputs/bootstrap/source/falcon-keygen.c:6831: 	for (u = 0; u < hn; u ++) {
	testq	%r14, %r14	# hn
	je	.L801	#,
# inputs/bootstrap/source/falcon-keygen.c:6831: 	for (u = 0; u < hn; u ++) {
	movl	$0, %eax	#, u
	movq	%r14, %rsi	# hn, hn
	movq	16(%rsp), %rcx	# %sfp, Fp
.L802:
# inputs/bootstrap/source/falcon-keygen.c:4435: 	w = x[0];
	movl	(%rcx,%rax,4), %edi	# MEM[(const uint32_t *)Fp_832 + u_1928 * 4], _843
# inputs/bootstrap/source/falcon-keygen.c:4436: 	w |= (w & 0x40000000) << 1;
	leal	(%rdi,%rdi), %edx	#, _844
	andl	$-2147483648, %edx	#, _845
# inputs/bootstrap/source/falcon-keygen.c:4436: 	w |= (w & 0x40000000) << 1;
	orl	%edi, %edx	# _843, _846
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%edx, %edi	# _846, _848
	sarl	$31, %edi	#, _848
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %edi	#, _849
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%edi, %edx	# _849, tmp1541
	movl	%edx, (%rcx,%rax,4)	# tmp1541, MEM[(uint32_t *)Fp_832 + u_1928 * 4]
# inputs/bootstrap/source/falcon-keygen.c:4435: 	w = x[0];
	movl	0(%r13,%rax,4), %edi	# MEM[(const uint32_t *)Gp_834 + u_1928 * 4], _853
# inputs/bootstrap/source/falcon-keygen.c:4436: 	w |= (w & 0x40000000) << 1;
	leal	(%rdi,%rdi), %edx	#, _854
	andl	$-2147483648, %edx	#, _855
# inputs/bootstrap/source/falcon-keygen.c:4436: 	w |= (w & 0x40000000) << 1;
	orl	%edi, %edx	# _853, _856
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%edx, %edi	# _856, _858
	sarl	$31, %edi	#, _858
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %edi	#, _859
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%edi, %edx	# _859, tmp1546
	movl	%edx, 0(%r13,%rax,4)	# tmp1546, MEM[(uint32_t *)Gp_834 + u_1928 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6831: 	for (u = 0; u < hn; u ++) {
	addq	$1, %rax	#, u
# inputs/bootstrap/source/falcon-keygen.c:6831: 	for (u = 0; u < hn; u ++) {
	cmpq	%rax, %rsi	# u, hn
	jne	.L802	#,
.L801:
# inputs/bootstrap/source/falcon-keygen.c:6835: 	modp_NTT2(Fp, gm, logn - 1, p, p0i);
	movl	64(%rsp), %eax	# %sfp, logn
	leal	-1(%rax), %r14d	#, _863
	movl	24(%rsp), %r9d	# %sfp,
	movl	$2147473409, %r8d	#,
	movl	%r14d, %ecx	# _863,
	movq	%rbx, %rdx	# gm,
	movl	$1, %esi	#,
	movq	16(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6836: 	modp_NTT2(Gp, gm, logn - 1, p, p0i);
	movl	24(%rsp), %r9d	# %sfp,
	movl	$2147473409, %r8d	#,
	movl	%r14d, %ecx	# _863,
	movq	%rbx, %rdx	# gm,
	movl	$1, %esi	#,
	movq	%r13, %rdi	# Gp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6841: 	for (u = 0; u < n; u ++) {
	movl	$0, %eax	#, u
	movq	32(%rsp), %rsi	# %sfp, n
	.p2align 6
.L803:
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	24960(%rsp,%rax,2), %ecx	# MEM[(const int16_t *)&f + u_1929 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%ecx, %edx	# w, _872
	sarl	$31, %edx	#, _872
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %edx	#, _873
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%ecx, %edx	# w, tmp1551
	movl	%edx, 0(%rbp,%rax,4)	# tmp1551, MEM[(uint32_t *)ft_835 + u_1929 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	18816(%rsp,%rax,2), %ecx	# MEM[(const int16_t *)&g + u_1929 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%ecx, %edx	# w, _881
	sarl	$31, %edx	#, _881
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %edx	#, _882
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%ecx, %edx	# w, tmp1556
	movl	%edx, (%r12,%rax,4)	# tmp1556, MEM[(uint32_t *)gt_837 + u_1929 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6841: 	for (u = 0; u < n; u ++) {
	addq	$1, %rax	#, u
# inputs/bootstrap/source/falcon-keygen.c:6841: 	for (u = 0; u < n; u ++) {
	cmpq	%rax, %rsi	# u, n
	jne	.L803	#,
# inputs/bootstrap/source/falcon-keygen.c:6845: 	modp_NTT2(ft, gm, logn, p, p0i);
	movl	24(%rsp), %r14d	# %sfp, p0i
	movl	%r14d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	64(%rsp), %ecx	# %sfp,
	movq	%rbx, %rdx	# gm,
	movl	$1, %esi	#,
	movq	%rbp, %rdi	# ft,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6846: 	modp_NTT2(gt, gm, logn, p, p0i);
	movl	%r14d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	64(%rsp), %ecx	# %sfp,
	movq	%rbx, %rdx	# gm,
	movl	$1, %esi	#,
	movq	%r12, %rdi	# gt,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6851: 	for (u = 0; u < n; u += 2) {
	movl	$0, %edx	#, u
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	104(%rsp), %r11d	# %sfp, _903
	movq	%r11, 128(%rsp)	# _903, %sfp
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %ebx	# p0i, _905
	movq	%r15, 104(%rsp)	# _836, %sfp
	movq	32(%rsp), %r15	# %sfp, n
.L804:
# inputs/bootstrap/source/falcon-keygen.c:6855: 		ftA = ft[u + 0];
	movl	0(%rbp,%rdx,4), %esi	# MEM[(uint32_t *)ft_835 + u_1930 * 4], ftA
# inputs/bootstrap/source/falcon-keygen.c:6856: 		ftB = ft[u + 1];
	movl	4(%rbp,%rdx,4), %edi	# MEM[(uint32_t *)ft_835 + 4B + u_1930 * 4], ftB
# inputs/bootstrap/source/falcon-keygen.c:6857: 		gtA = gt[u + 0];
	movl	(%r12,%rdx,4), %r8d	# MEM[(uint32_t *)gt_837 + u_1930 * 4], gtA
# inputs/bootstrap/source/falcon-keygen.c:6859: 		mFp = modp_montymul(Fp[u >> 1], R2, p, p0i);
	movq	%rdx, %rcx	# u, _898
	shrq	%rcx	# _898
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movq	16(%rsp), %rax	# %sfp, Fp
	movl	(%rax,%rcx,4), %r9d	# *_900, _902
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r11, %r9	# _903, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r9, %rax	# z, _906
	imulq	%rbx, %rax	# _905, _906
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _907
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _907, w_908
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rax	# z, _909
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _910
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _914
	sarl	$31, %r10d	#, _914
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r10d	#, _916
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	0(%r13,%rcx,4), %r9d	# *_918, _920
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r11, %r9	# _903, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rcx	# _905, _922
	imulq	%r9, %rcx	# z, _922
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %ecx	#, _923
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rcx, %rcx	#, _923, w_924
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r9, %rcx	# z, _925
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rcx	#, _926
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %ecx	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%ecx, %r9d	# d, _930
	sarl	$31, %r9d	#, _930
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r9d	#, _932
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r10), %r10d	#, _935
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	4(%r12,%rdx,4), %r14d	# MEM[(uint32_t *)gt_837 + 4B + u_1930 * 4], _934
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r10, %r14	# _935, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _937
	imulq	%r14, %rax	# z, _937
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _938
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _938, w_939
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r14, %rax	# z, _940
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _941
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r14d	# d, _945
	sarl	$31, %r14d	#, _945
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r14d	#, _947
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r14d, %eax	# _947, tmp1580
	movl	%eax, 0(%rbp,%rdx,4)	# tmp1580, MEM[(uint32_t *)ft_835 + u_1930 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%r8d, %r8d	# gtA, _949
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r10, %r8	# _935, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _951
	imulq	%r8, %rax	# z, _951
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _952
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _952, w_953
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r8, %rax	# z, _954
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _955
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r8d	# d, _959
	sarl	$31, %r8d	#, _959
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r8d	#, _961
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r8d, %eax	# _961, tmp1588
	movl	%eax, 4(%rbp,%rdx,4)	# tmp1588, MEM[(uint32_t *)ft_835 + 4B + u_1930 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rcx,%r9), %ecx	#, _964
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%edi, %edi	# ftB, _963
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rdi	# _964, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _966
	imulq	%rdi, %rax	# z, _966
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _967
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _967, w_968
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdi, %rax	# z, _969
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _970
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %edi	# d, _974
	sarl	$31, %edi	#, _974
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %edi	#, _976
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%edi, %eax	# _976, tmp1597
	movl	%eax, (%r12,%rdx,4)	# tmp1597, MEM[(uint32_t *)gt_837 + u_1930 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	%esi, %esi	# ftA, _978
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rcx, %rsi	# _964, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _980
	imulq	%rsi, %rax	# z, _980
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _981
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _981, w_982
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rsi, %rax	# z, _983
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _984
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %ecx	# d, _988
	sarl	$31, %ecx	#, _988
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %ecx	#, _990
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%ecx, %eax	# _990, tmp1605
	movl	%eax, 4(%r12,%rdx,4)	# tmp1605, MEM[(uint32_t *)gt_837 + 4B + u_1930 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6851: 	for (u = 0; u < n; u += 2) {
	addq	$2, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:6851: 	for (u = 0; u < n; u += 2) {
	cmpq	%r15, %rdx	# n, u
	jb	.L804	#,
# inputs/bootstrap/source/falcon-keygen.c:6866: 	modp_iNTT2(ft, igm, logn, p, p0i);
	movq	104(%rsp), %r15	# %sfp, _836
	movl	24(%rsp), %r13d	# %sfp, p0i
	movl	%r13d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	64(%rsp), %r14d	# %sfp, logn
	movl	%r14d, %ecx	# logn,
	movq	88(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%rbp, %rdi	# ft,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6867: 	modp_iNTT2(gt, igm, logn, p, p0i);
	movl	%r13d, 24(%rsp)	# p0i, %sfp
	movl	%r13d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	%r14d, %ecx	# logn,
	movq	88(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%r12, %rdi	# gt,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6869: 	Gp = Fp + n;
	movq	16(%rsp), %rax	# %sfp, Fp
	leaq	(%rax,%r15), %r13	#, Gp
# inputs/bootstrap/source/falcon-keygen.c:6870: 	t1 = Gp + n;
	leaq	0(%r13,%r15), %r12	#, t1
	movq	%r12, 88(%rsp)	# t1, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6871: 	memmove(Fp, ft, 2 * n * sizeof *ft);
	movl	$8, %edx	#, tmp1609
	movl	%r14d, %ecx	# logn, tmp2623
	salq	%cl, %rdx	# tmp2623, _995
	movq	%rbp, %rsi	# ft,
	movq	%rax, %rdi	# Fp,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6881: 	t2 = t1 + n;
	movq	%r12, %rax	# t1, t1
	leaq	(%r12,%r15), %rbp	#, t2
# inputs/bootstrap/source/falcon-keygen.c:6882: 	t3 = t2 + n;
	leaq	0(%rbp,%r15), %rcx	#, t3
	movq	%rcx, 112(%rsp)	# t3, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6883: 	t4 = t3 + n;
	addq	%r15, %rcx	# _836, t4
# inputs/bootstrap/source/falcon-keygen.c:6884: 	t5 = t4 + n;
	movq	%rcx, 104(%rsp)	# t4, %sfp
	leaq	(%rcx,%r15), %rsi	#, t5
	movq	%rsi, 120(%rsp)	# t5, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6890: 	modp_mkgm2(t1, t2, logn, PRIMES2[0].g, p, p0i);
	movl	24(%rsp), %r12d	# %sfp, p0i
	movl	%r12d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	$383167813, %ecx	#,
	movl	%r14d, %edx	# logn,
	movq	%rbp, %rsi	# t2,
	movq	%rax, %r15	# t1, t1
	movq	%rax, %rdi	# t1,
	call	modp_mkgm2	#
# inputs/bootstrap/source/falcon-keygen.c:6895: 	modp_NTT2(Fp, t1, logn, p, p0i);
	movl	%r12d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	%r14d, %ecx	# logn,
	movq	%r15, %rdx	# t1,
	movl	$1, %esi	#,
	movq	16(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6896: 	modp_NTT2(Gp, t1, logn, p, p0i);
	movl	%r12d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	%r14d, %ecx	# logn,
	movq	%r15, %rdx	# t1,
	movl	$1, %esi	#,
	movq	%r13, %rdi	# Gp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	24960(%rsp), %edx	# MEM[(const int16_t *)&f], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%edx, %eax	# w, _1003
	sarl	$31, %eax	#, _1003
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %eax	#, _1004
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%edx, %eax	# w, w
# inputs/bootstrap/source/falcon-keygen.c:6902: 	t4[0] = t5[0] = modp_set(f[0], p);
	movq	120(%rsp), %rsi	# %sfp, t5
	movl	%eax, (%rsi)	# w, *t5_999
# inputs/bootstrap/source/falcon-keygen.c:6902: 	t4[0] = t5[0] = modp_set(f[0], p);
	movq	104(%rsp), %rcx	# %sfp, t4
	movl	%eax, (%rcx)	# w, *t4_998
# inputs/bootstrap/source/falcon-keygen.c:6903: 	for (u = 1; u < n; u ++) {
	movq	32(%rsp), %rax	# %sfp, n
	cmpq	$1, %rax	#, n
	jbe	.L805	#,
	leaq	24962(%rsp), %rdx	#, ivtmp.1503
	leaq	4(%rcx), %rdi	#, ivtmp.1505
	leaq	-4(%rsi,%rax,4), %rsi	#, ivtmp.1507
	movl	$2, %eax	#, tmp1617
	movl	%r14d, %ecx	# logn, tmp2637
	salq	%cl, %rax	# tmp2637, _700
	leaq	24960(%rsp,%rax), %r9	#, _737
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	$2147473409, %r8d	#, tmp1624
	movl	$0, %ecx	#, tmp1625
	.p2align 6
.L806:
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	(%rdx), %r10d	# MEM[(const int16_t *)_653], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%r10d, %eax	# w, _1015
	sarl	$31, %eax	#, _1015
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %eax	#, _1016
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%r10d, %eax	# w, tmp1622
	movl	%eax, (%rdi)	# tmp1622, MEM[(uint32_t *)_683]
# inputs/bootstrap/source/falcon-keygen.c:6905: 		t5[n - u] = modp_set(-f[u], p);
	movzwl	(%rdx), %eax	# MEM[(const int16_t *)_653], _1019
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	testw	%ax, %ax	# _1019
	movl	%ecx, %r10d	# tmp1625, _1027
	cmovg	%r8d, %r10d	# tmp1624,, _1027
# inputs/bootstrap/source/falcon-keygen.c:6905: 		t5[n - u] = modp_set(-f[u], p);
	cwtl
	subl	%eax, %r10d	# _1028, tmp1627
	movl	%r10d, (%rsi)	# tmp1627, MEM[(uint32_t *)_680]
# inputs/bootstrap/source/falcon-keygen.c:6903: 	for (u = 1; u < n; u ++) {
	addq	$2, %rdx	#, ivtmp.1503
	addq	$4, %rdi	#, ivtmp.1505
	subq	$4, %rsi	#, ivtmp.1507
	cmpq	%r9, %rdx	# _737, ivtmp.1503
	jne	.L806	#,
.L805:
# inputs/bootstrap/source/falcon-keygen.c:6907: 	modp_NTT2(t4, t1, logn, p, p0i);
	movl	24(%rsp), %r9d	# %sfp,
	movl	$2147473409, %r8d	#,
	movl	64(%rsp), %r12d	# %sfp, logn
	movl	%r12d, %ecx	# logn,
	movq	88(%rsp), %r14	# %sfp, t1
	movq	%r14, %rdx	# t1,
	movl	$1, %esi	#,
	movq	104(%rsp), %r15	# %sfp, t4
	movq	%r15, %rdi	# t4,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6908: 	modp_NTT2(t5, t1, logn, p, p0i);
	movl	24(%rsp), %r9d	# %sfp,
	movl	$2147473409, %r8d	#,
	movl	%r12d, %ecx	# logn,
	movq	%r14, %rdx	# t1,
	movl	$1, %esi	#,
	movq	120(%rsp), %r14	# %sfp, t5
	movq	%r14, %rdi	# t5,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6913: 	for (u = 0; u < n; u ++) {
	movl	$0, %edx	#, u
	movq	32(%rsp), %rcx	# %sfp, n
	movq	16(%rsp), %rsi	# %sfp, Fp
	movq	128(%rsp), %rdi	# %sfp, _903
	movq	112(%rsp), %r8	# %sfp, t3
	movq	%r15, %r9	# t4, t4
	movq	%r14, %r10	# t5, t5
.L807:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r10,%rdx,4), %r11d	# MEM[(uint32_t *)t5_999 + u_1932 * 4], _1035
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %r11	# _903, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _1039
	imulq	%r11, %rax	# z, _1039
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _1040
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _1040, w_1041
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r11, %rax	# z, _1042
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _1043
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r11d	# d, _1047
	sarl	$31, %r11d	#, _1047
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r11d	#, _1049
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r11), %r11d	#, _1054
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rsi,%rdx,4), %r12d	# MEM[(uint32_t *)Fp_832 + u_1932 * 4], _1055
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r11, %r12	# _1054, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _1057
	imulq	%r12, %rax	# z, _1057
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _1058
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _1058, w_1059
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r12, %rax	# z, _1060
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _1061
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r12d	# d, _1065
	sarl	$31, %r12d	#, _1065
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r12d	#, _1067
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r12d, %eax	# _1067, tmp1643
	movl	%eax, 0(%rbp,%rdx,4)	# tmp1643, MEM[(uint32_t *)t2_996 + u_1932 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r9,%rdx,4), %eax	# MEM[(uint32_t *)t4_998 + u_1932 * 4], _1072
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r11	# _1072, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _1074
	imulq	%r11, %rax	# z, _1074
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _1075
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _1075, w_1076
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r11, %rax	# z, _1077
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _1078
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r11d	# d, _1082
	sarl	$31, %r11d	#, _1082
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r11d	#, _1084
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%r11d, %eax	# _1084, tmp1651
	movl	%eax, (%r8,%rdx,4)	# tmp1651, MEM[(uint32_t *)t3_997 + u_1932 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6913: 	for (u = 0; u < n; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:6913: 	for (u = 0; u < n; u ++) {
	cmpq	%rdx, %rcx	# u, n
	jne	.L807	#,
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	18816(%rsp), %edx	# MEM[(const int16_t *)&g], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%edx, %eax	# w, _1090
	sarl	$31, %eax	#, _1090
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %eax	#, _1091
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%edx, %eax	# w, w
# inputs/bootstrap/source/falcon-keygen.c:6925: 	t4[0] = t5[0] = modp_set(g[0], p);
	movq	120(%rsp), %rcx	# %sfp, t5
	movl	%eax, (%rcx)	# w, *t5_999
# inputs/bootstrap/source/falcon-keygen.c:6925: 	t4[0] = t5[0] = modp_set(g[0], p);
	movq	104(%rsp), %rsi	# %sfp, t4
	movl	%eax, (%rsi)	# w, *t4_998
# inputs/bootstrap/source/falcon-keygen.c:6926: 	for (u = 1; u < n; u ++) {
	movq	32(%rsp), %rax	# %sfp, n
	cmpq	$1, %rax	#, n
	jbe	.L808	#,
	leaq	18818(%rsp), %rdx	#, ivtmp.1482
	leaq	4(%rsi), %rdi	#, ivtmp.1484
	leaq	-4(%rcx,%rax,4), %rsi	#, ivtmp.1486
	movl	$2, %eax	#, tmp1659
	movzbl	64(%rsp), %ecx	# %sfp, tmp2653
	salq	%cl, %rax	# tmp2653, _69
	leaq	18816(%rsp,%rax), %r9	#, _61
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	$2147473409, %r8d	#, tmp1666
	movl	$0, %ecx	#, tmp1667
	.p2align 6
.L809:
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	(%rdx), %r10d	# MEM[(const int16_t *)_300], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%r10d, %eax	# w, _1102
	sarl	$31, %eax	#, _1102
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %eax	#, _1103
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%r10d, %eax	# w, tmp1664
	movl	%eax, (%rdi)	# tmp1664, MEM[(uint32_t *)_468]
# inputs/bootstrap/source/falcon-keygen.c:6928: 		t5[n - u] = modp_set(-g[u], p);
	movzwl	(%rdx), %eax	# MEM[(const int16_t *)_300], _1106
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	testw	%ax, %ax	# _1106
	movl	%ecx, %r10d	# tmp1667, _1114
	cmovg	%r8d, %r10d	# tmp1666,, _1114
# inputs/bootstrap/source/falcon-keygen.c:6928: 		t5[n - u] = modp_set(-g[u], p);
	cwtl
	subl	%eax, %r10d	# _1115, tmp1669
	movl	%r10d, (%rsi)	# tmp1669, MEM[(uint32_t *)_305]
# inputs/bootstrap/source/falcon-keygen.c:6926: 	for (u = 1; u < n; u ++) {
	addq	$2, %rdx	#, ivtmp.1482
	addq	$4, %rdi	#, ivtmp.1484
	subq	$4, %rsi	#, ivtmp.1486
	cmpq	%rdx, %r9	# ivtmp.1482, _61
	jne	.L809	#,
.L808:
# inputs/bootstrap/source/falcon-keygen.c:6930: 	modp_NTT2(t4, t1, logn, p, p0i);
	movl	24(%rsp), %r9d	# %sfp,
	movl	$2147473409, %r8d	#,
	movl	64(%rsp), %r12d	# %sfp, logn
	movl	%r12d, %ecx	# logn,
	movq	88(%rsp), %r14	# %sfp, t1
	movq	%r14, %rdx	# t1,
	movl	$1, %esi	#,
	movq	104(%rsp), %r15	# %sfp, t4
	movq	%r15, %rdi	# t4,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6931: 	modp_NTT2(t5, t1, logn, p, p0i);
	movl	24(%rsp), %r9d	# %sfp,
	movl	$2147473409, %r8d	#,
	movl	%r12d, %ecx	# logn,
	movq	%r14, %rdx	# t1,
	movl	$1, %esi	#,
	movq	120(%rsp), %r14	# %sfp, t5
	movq	%r14, %rdi	# t5,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6936: 	for (u = 0; u < n; u ++) {
	movl	$0, %edx	#, u
	movq	32(%rsp), %rsi	# %sfp, n
	movq	128(%rsp), %rdi	# %sfp, _903
	movq	112(%rsp), %rcx	# %sfp, t3
	movq	%r15, %r8	# t4, t4
	movq	%r14, %r9	# t5, t5
.L810:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r9,%rdx,4), %r10d	# MEM[(uint32_t *)t5_999 + u_1934 * 4], _1122
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %r10	# _903, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _1126
	imulq	%r10, %rax	# z, _1126
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _1127
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _1127, w_1128
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rax	# z, _1129
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _1130
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _1134
	sarl	$31, %r10d	#, _1134
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r10d	#, _1136
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r10), %r10d	#, _1140
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	0(%r13,%rdx,4), %r11d	# MEM[(uint32_t *)Gp_993 + u_1934 * 4], _1141
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r10, %r11	# _1140, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _1143
	imulq	%r11, %rax	# z, _1143
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _1144
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _1144, w_1145
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r11, %rax	# z, _1146
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _1147
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	leal	-2147473409(%rax), %r11d	#, d
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	movl	0(%rbp,%rdx,4), %r12d	# MEM[(uint32_t *)t2_996 + u_1934 * 4], MEM[(uint32_t *)t2_996 + u_1934 * 4]
	leal	20478(%r12,%rax), %eax	#, _1123
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	sarl	$31, %r11d	#, _1151
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r11d	#, _1152
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%r11d, %eax	# _1152, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%eax, %r11d	# d, _1160
	sarl	$31, %r11d	#, _1160
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	$2147473409, %r11d	#, _1162
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%r11d, %eax	# _1162, tmp1690
	movl	%eax, 0(%rbp,%rdx,4)	# tmp1690, MEM[(uint32_t *)t2_996 + u_1934 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r8,%rdx,4), %eax	# MEM[(uint32_t *)t4_998 + u_1934 * 4], _1166
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r10	# _1166, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _1168
	imulq	%r10, %rax	# z, _1168
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _1169
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _1169, w_1170
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r10, %rax	# z, _1171
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _1172
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	leal	-2147473409(%rax), %r10d	#, d
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	movl	(%rcx,%rdx,4), %r11d	# MEM[(uint32_t *)t3_997 + u_1934 * 4], MEM[(uint32_t *)t3_997 + u_1934 * 4]
	leal	20478(%r11,%rax), %eax	#, _1273
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	sarl	$31, %r10d	#, _1176
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r10d	#, _1177
# inputs/bootstrap/source/falcon-keygen.c:2534: 	d = a + b - p;
	addl	%r10d, %eax	# _1177, d
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	movl	%eax, %r10d	# d, _1185
	sarl	$31, %r10d	#, _1185
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	andl	$2147473409, %r10d	#, _1187
# inputs/bootstrap/source/falcon-keygen.c:2535: 	d += p & -(d >> 31);
	addl	%r10d, %eax	# _1187, tmp1703
	movl	%eax, (%rcx,%rdx,4)	# tmp1703, MEM[(uint32_t *)t3_997 + u_1934 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6936: 	for (u = 0; u < n; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:6936: 	for (u = 0; u < n; u ++) {
	cmpq	%rdx, %rsi	# u, n
	jne	.L810	#,
# inputs/bootstrap/source/falcon-keygen.c:6952: 	modp_mkgm2(t1, t4, logn, PRIMES2[0].g, p, p0i);
	movl	24(%rsp), %r12d	# %sfp, p0i
	movl	%r12d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	$383167813, %ecx	#,
	movl	64(%rsp), %r15d	# %sfp, logn
	movl	%r15d, %edx	# logn,
	movq	104(%rsp), %r14	# %sfp, t4
	movq	%r14, %rsi	# t4,
	movq	88(%rsp), %rdi	# %sfp,
	call	modp_mkgm2	#
# inputs/bootstrap/source/falcon-keygen.c:6953: 	modp_iNTT2(t2, t4, logn, p, p0i);
	movl	%r12d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	%r15d, %ecx	# logn,
	movq	%r14, %rdx	# t4,
	movl	$1, %esi	#,
	movq	%rbp, %rdi	# t2,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6954: 	modp_iNTT2(t3, t4, logn, p, p0i);
	movl	%r12d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	%r15d, %ecx	# logn,
	movq	%r14, %rdx	# t4,
	movl	$1, %esi	#,
	movq	112(%rsp), %r14	# %sfp, t3
	movq	%r14, %rdi	# t3,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:6955: 	for (u = 0; u < n; u ++) {
	movl	$0, %edx	#, u
	movq	32(%rsp), %rcx	# %sfp, n
	movq	88(%rsp), %rsi	# %sfp, t1
	movq	%r14, %rdi	# t3, t3
.L811:
# inputs/bootstrap/source/falcon-keygen.c:6956: 		t1[u] = (uint32_t)modp_norm(t2[u], p);
	movl	0(%rbp,%rdx,4), %r8d	# MEM[(uint32_t *)t2_996 + u_1935 * 4], _1193
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	leal	-1073736705(%r8), %eax	#, _1194
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	shrl	$31, %eax	#, _1195
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	subl	$1, %eax	#, _1196
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	andl	$2147473409, %eax	#, _1197
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	subl	%eax, %r8d	# _1197, tmp1708
	movl	%r8d, (%rsi,%rdx,4)	# tmp1708, MEM[(uint32_t *)t1_994 + u_1935 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6957: 		t2[u] = (uint32_t)modp_norm(t3[u], p);
	movl	(%rdi,%rdx,4), %r8d	# MEM[(uint32_t *)t3_997 + u_1935 * 4], _1201
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	leal	-1073736705(%r8), %eax	#, _1202
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	shrl	$31, %eax	#, _1203
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	subl	$1, %eax	#, _1204
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	andl	$2147473409, %eax	#, _1205
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	subl	%eax, %r8d	# _1205, tmp1713
	movl	%r8d, 0(%rbp,%rdx,4)	# tmp1713, MEM[(uint32_t *)t2_996 + u_1935 * 4]
# inputs/bootstrap/source/falcon-keygen.c:6955: 	for (u = 0; u < n; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:6955: 	for (u = 0; u < n; u ++) {
	cmpq	%rdx, %rcx	# u, n
	jne	.L811	#,
# inputs/bootstrap/source/falcon-keygen.c:6978: 	rt3 = align_fpr(fk->tmp, t3);
	movq	48(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %rdi	# fk_82(D)->tmp, fk_82(D)->tmp
	movq	112(%rsp), %rsi	# %sfp,
	call	align_fpr	#
	movq	%rax, %r14	# tmp2143, rt3
# inputs/bootstrap/source/falcon-keygen.c:6979: 	for (u = 0; u < n; u ++) {
	movl	$0, %r12d	#, u
	movq	32(%rsp), %r15	# %sfp, n
.L812:
# inputs/bootstrap/source/falcon-keygen.c:6980: 		rt3[u] = fpr_of(((int32_t *)t2)[u]);
	movslq	0(%rbp,%r12,4), %rdi	# MEM[(int32_t *)t2_996 + u_1936 * 4], _1214
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6980: 		rt3[u] = fpr_of(((int32_t *)t2)[u]);
	movq	%rax, (%r14,%r12,8)	# tmp2144, MEM[(fpr *)rt3_1209 + u_1936 * 8]
# inputs/bootstrap/source/falcon-keygen.c:6979: 	for (u = 0; u < n; u ++) {
	addq	$1, %r12	#, u
# inputs/bootstrap/source/falcon-keygen.c:6979: 	for (u = 0; u < n; u ++) {
	cmpq	%r12, %r15	# u, n
	jne	.L812	#,
# inputs/bootstrap/source/falcon-keygen.c:6982: 	falcon_FFT(rt3, logn);
	movl	64(%rsp), %esi	# %sfp,
	movq	%r14, %rdi	# rt3,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6983: 	rt2 = align_fpr(fk->tmp, t2);
	movq	48(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %rdi	# fk_82(D)->tmp, fk_82(D)->tmp
	movq	%rbp, %rsi	# t2,
	call	align_fpr	#
	movq	%rax, 144(%rsp)	# rt2, %sfp
# inputs/bootstrap/source/falcon-keygen.c:6984: 	memmove(rt2, rt3, hn * sizeof *rt3);
	movq	136(%rsp), %r12	# %sfp, hn
	salq	$3, %r12	#, hn
	movq	%r12, %rdx	# _1221,
	movq	%r14, %rsi	# rt3,
	movq	%rax, %r14	# rt2, rt2
	movq	%rax, %rdi	# rt2,
	call	memmove@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6989: 	rt3 = rt2 + hn;
	leaq	(%r14,%r12), %r15	#, rt3
# inputs/bootstrap/source/falcon-keygen.c:6990: 	for (u = 0; u < n; u ++) {
	movl	$0, %r12d	#, u
	movq	%rbx, 136(%rsp)	# _905, %sfp
	movq	32(%rsp), %rbx	# %sfp, n
	movq	88(%rsp), %r14	# %sfp, t1
.L813:
# inputs/bootstrap/source/falcon-keygen.c:6991: 		rt3[u] = fpr_of(((int32_t *)t1)[u]);
	movslq	(%r14,%r12,4), %rdi	# MEM[(int32_t *)t1_994 + u_1937 * 4], _1227
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	call	fpr_scaled@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6991: 		rt3[u] = fpr_of(((int32_t *)t1)[u]);
	movq	%rax, (%r15,%r12,8)	# tmp2146, MEM[(fpr *)rt3_1222 + u_1937 * 8]
# inputs/bootstrap/source/falcon-keygen.c:6990: 	for (u = 0; u < n; u ++) {
	addq	$1, %r12	#, u
# inputs/bootstrap/source/falcon-keygen.c:6990: 	for (u = 0; u < n; u ++) {
	cmpq	%r12, %rbx	# u, n
	jne	.L813	#,
# inputs/bootstrap/source/falcon-keygen.c:6993: 	falcon_FFT(rt3, logn);
	movq	136(%rsp), %rbx	# %sfp, _905
	movl	64(%rsp), %r14d	# %sfp, logn
	movl	%r14d, %esi	# logn,
	movq	%r15, %rdi	# rt3,
	call	falcon_FFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:6999: 	falcon_poly_div_autoadj_fft(rt3, rt2, logn);
	movl	%r14d, %edx	# logn,
	movq	144(%rsp), %rsi	# %sfp,
	movq	%r15, %rdi	# rt3,
	call	falcon_poly_div_autoadj_fft@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7000: 	falcon_iFFT(rt3, logn);
	movl	%r14d, %esi	# logn,
	movq	%r15, %rdi	# rt3,
	call	falcon_iFFT@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7001: 	for (u = 0; u < n; u ++) {
	movl	$0, %r8d	#, u
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387904, %r11	#, tmp1723
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	$1085, %r12d	#, tmp1725
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	$1021, %r14d	#, tmp1727
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movq	%rbx, 136(%rsp)	# _905, %sfp
	movq	88(%rsp), %rbx	# %sfp, t1
	movq	%rbp, 144(%rsp)	# t2, %sfp
	movq	32(%rsp), %rbp	# %sfp, n
.L814:
# inputs/bootstrap/source/falcon-keygen.c:7002: 		t1[u] = modp_set((int32_t)fpr_rint(rt3[u]), p);
	movq	(%r15,%r8,8), %rsi	# MEM[(fpr *)rt3_1222 + u_1938 * 8], _1235
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movq	%rsi, %rdx	# _1235, _1355
	salq	$10, %rdx	#, _1355
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	movabsq	$4611686018427387903, %rax	#, tmp2667
	andq	%rax, %rdx	# tmp2667, _1356
# inputs/bootstrap/source/fpr-emulated.h:105: 	m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);
	orq	%r11, %rdx	# tmp1723, m
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movq	%rsi, %rcx	# _1235, _1358
	shrq	$52, %rcx	#, _1358
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	andl	$2047, %ecx	#, _1360
# inputs/bootstrap/source/fpr-emulated.h:106: 	e = 1085 - ((int)(x >> 52) & 0x7FF);
	movl	%r12d, %r9d	# tmp1725, e
	subl	%ecx, %r9d	# _1360, e
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%r14d, %eax	# tmp1727, _1362
	subl	%ecx, %eax	# _1360, _1362
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	shrl	$31, %eax	#, _1364
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	movl	%eax, %eax	# _1364, _1365
# inputs/bootstrap/source/fpr-emulated.h:107: 	m &= -(uint64_t)((uint32_t)(e - 64) >> 31);
	negq	%rax	# tmp1730
	andq	%rdx, %rax	# m, m
# inputs/bootstrap/source/fpr-emulated.h:108: 	e &= 63;
	movl	%r9d, %r10d	# e, e
	andl	$63, %r10d	#, e
# inputs/bootstrap/source/fpr-emulated.h:109: 	d = fpr_ulsh(m, 63 - e);
	movl	$63, %ecx	#, _1368
	subl	%r10d, %ecx	# e, _1368
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rdx	# m, _1369
	salq	$32, %rdx	#, _1369
# inputs/bootstrap/source/fpr-emulated.h:35: 	x ^= (x ^ (x << 32)) & -(uint64_t)(n >> 5);
	testb	$32, %cl	#, _1368
	cmove	%rax, %rdx	# _1369,, m, x_1375
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	andl	$31, %ecx	#, _1376
# inputs/bootstrap/source/fpr-emulated.h:36: 	return x << (n & 31);
	salq	%cl, %rdx	# _1376, _1377
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	movq	%rdx, %rdi	# _1377, _1379
	shrq	$32, %rdi	#, _1379
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	andl	$536870911, %edi	#, _1381
# inputs/bootstrap/source/fpr-emulated.h:110: 	dd = (uint32_t)d | ((uint32_t)(d >> 32) & 0x1FFFFFFF);
	orl	%edx, %edi	# _1377, dd
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	movq	%rax, %rcx	# m, _1389
	shrq	$32, %rcx	#, _1389
# inputs/bootstrap/source/fpr-emulated.h:21: 	x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);
	shrl	$5, %r10d	#, tmp2194
	cmovne	%rcx, %rax	# _1389,, x_1395
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	movl	%r9d, %ecx	# e, e
	andl	$31, %ecx	#, e
# inputs/bootstrap/source/fpr-emulated.h:22: 	return x >> (n & 31);
	shrq	%cl, %rax	# _1396, x_1395
	movq	%rax, %r9	# x_1395, _1397
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	movl	%edi, %ecx	# dd, _1385
	negl	%ecx	# _1385
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edi, %ecx	# dd, _1386
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrl	$31, %ecx	#, _1387
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	shrq	$61, %rdx	#, _1383
# inputs/bootstrap/source/fpr-emulated.h:111: 	f = (uint32_t)(d >> 61) | ((dd | -dd) >> 31);
	orl	%edx, %ecx	# _1383, f_1388
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	movl	$200, %eax	#, _1398
	shrl	%cl, %eax	# f_1388, _1398
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	andl	$1, %eax	#, _1400
# inputs/bootstrap/source/fpr-emulated.h:112: 	m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);
	addq	%r9, %rax	# _1397, m_1401
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	movq	%rsi, %rdx	# _1235, _1404
	sarq	$63, %rdx	#, _1404
	xorq	%rdx, %rax	# _1404, _1406
# inputs/bootstrap/source/fpr-emulated.h:113: 	s = (uint32_t)(x >> 63);
	shrq	$63, %rsi	#, _1402
# inputs/bootstrap/source/fpr-emulated.h:114: 	return ((int64_t)m ^ -(int64_t)s) + (int64_t)s;
	addq	%rsi, %rax	# _1402, _1408
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	cltd
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %edx	#, _1242
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%edx, %eax	# _1242, tmp1759
	movl	%eax, (%rbx,%r8,4)	# tmp1759, MEM[(uint32_t *)t1_994 + u_1938 * 4]
# inputs/bootstrap/source/falcon-keygen.c:7001: 	for (u = 0; u < n; u ++) {
	addq	$1, %r8	#, u
# inputs/bootstrap/source/falcon-keygen.c:7001: 	for (u = 0; u < n; u ++) {
	cmpq	%r8, %rbp	# u, n
	jne	.L814	#,
# inputs/bootstrap/source/falcon-keygen.c:7018: 	modp_mkgm2(t2, t3, logn, PRIMES2[0].g, p, p0i);
	movq	136(%rsp), %rbx	# %sfp, _905
	movq	144(%rsp), %rbp	# %sfp, t2
	movl	24(%rsp), %r9d	# %sfp,
	movl	$2147473409, %r8d	#,
	movl	$383167813, %ecx	#,
	movl	64(%rsp), %edx	# %sfp,
	movq	112(%rsp), %rsi	# %sfp,
	movq	%rbp, %rdi	# t2,
	call	modp_mkgm2	#
# inputs/bootstrap/source/falcon-keygen.c:7019: 	for (u = 0; u < n; u ++) {
	movl	$0, %eax	#, u
	movq	32(%rsp), %rsi	# %sfp, n
	movq	104(%rsp), %rdi	# %sfp, t4
	movq	120(%rsp), %r8	# %sfp, t5
	.p2align 6
.L815:
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	24960(%rsp,%rax,2), %ecx	# MEM[(const int16_t *)&f + u_1939 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%ecx, %edx	# w, _1254
	sarl	$31, %edx	#, _1254
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %edx	#, _1255
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%ecx, %edx	# w, tmp1764
	movl	%edx, (%rdi,%rax,4)	# tmp1764, MEM[(uint32_t *)t4_998 + u_1939 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	18816(%rsp,%rax,2), %ecx	# MEM[(const int16_t *)&g + u_1939 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%ecx, %edx	# w, _1263
	sarl	$31, %edx	#, _1263
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	$2147473409, %edx	#, _1264
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%ecx, %edx	# w, tmp1769
	movl	%edx, (%r8,%rax,4)	# tmp1769, MEM[(uint32_t *)t5_999 + u_1939 * 4]
# inputs/bootstrap/source/falcon-keygen.c:7019: 	for (u = 0; u < n; u ++) {
	addq	$1, %rax	#, u
# inputs/bootstrap/source/falcon-keygen.c:7019: 	for (u = 0; u < n; u ++) {
	cmpq	%rax, %rsi	# u, n
	jne	.L815	#,
# inputs/bootstrap/source/falcon-keygen.c:7023: 	modp_NTT2(t1, t2, logn, p, p0i);
	movl	24(%rsp), %r15d	# %sfp, p0i
	movl	%r15d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	64(%rsp), %r14d	# %sfp, logn
	movl	%r14d, %ecx	# logn,
	movq	%rbp, %rdx	# t2,
	movl	$1, %esi	#,
	movq	88(%rsp), %rdi	# %sfp,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7024: 	modp_NTT2(t4, t2, logn, p, p0i);
	movl	%r15d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	%r14d, %ecx	# logn,
	movq	%rbp, %rdx	# t2,
	movl	$1, %esi	#,
	movq	104(%rsp), %r12	# %sfp, t4
	movq	%r12, %rdi	# t4,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7025: 	modp_NTT2(t5, t2, logn, p, p0i);
	movl	%r15d, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	%r14d, %ecx	# logn,
	movq	%rbp, %rdx	# t2,
	movl	$1, %esi	#,
	movq	120(%rsp), %r14	# %sfp, t5
	movq	%r14, %rdi	# t5,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7026: 	for (u = 0; u < n; u ++) {
	movl	$0, %edx	#, u
	movq	32(%rsp), %rsi	# %sfp, n
	movq	16(%rsp), %rcx	# %sfp, Fp
	movq	128(%rsp), %rdi	# %sfp, _903
	movq	88(%rsp), %r8	# %sfp, t1
	movq	%r12, %r9	# t4, t4
	movq	%r14, %r10	# t5, t5
.L816:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r8,%rdx,4), %r11d	# MEM[(uint32_t *)t1_994 + u_1940 * 4], _1272
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rdi, %r11	# _903, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _1276
	imulq	%r11, %rax	# z, _1276
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _1277
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _1277, w_1278
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r11, %rax	# z, _1279
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _1280
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%eax, %r11d	# d, _1284
	sarl	$31, %r11d	#, _1284
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %r11d	#, _1286
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	leal	(%rax,%r11), %r11d	#, _1290
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r9,%rdx,4), %ebp	# MEM[(uint32_t *)t4_998 + u_1940 * 4], _1291
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r11, %rbp	# _1290, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _1293
	imulq	%rbp, %rax	# z, _1293
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _1294
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _1294, w_1295
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rbp, %rax	# z, _1296
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _1297
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	movl	(%rcx,%rdx,4), %ebp	# MEM[(uint32_t *)Fp_832 + u_1940 * 4], _1372
	subl	%eax, %ebp	# d, _1372
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	sarl	$31, %eax	#, _1301
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %eax	#, _1302
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%eax, %ebp	# _1302, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%ebp, %eax	# d, _1309
	sarl	$31, %eax	#, _1309
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	$2147473409, %eax	#, _1311
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	addl	%eax, %ebp	# _1311, tmp1789
	movl	%ebp, (%rcx,%rdx,4)	# tmp1789, MEM[(uint32_t *)Fp_832 + u_1940 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r10,%rdx,4), %eax	# MEM[(uint32_t *)t5_999 + u_1940 * 4], _1315
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %r11	# _1315, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rbx, %rax	# _905, _1317
	imulq	%r11, %rax	# z, _1317
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _1318
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	$2147473409, %rax, %rax	#, _1318, w_1319
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%r11, %rax	# z, _1320
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _1321
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	$2147473409, %eax	#, d
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	movl	0(%r13,%rdx,4), %r11d	# MEM[(uint32_t *)Gp_993 + u_1940 * 4], _1393
	subl	%eax, %r11d	# d, _1393
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	sarl	$31, %eax	#, _1325
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	$2147473409, %eax	#, _1326
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%eax, %r11d	# _1326, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%r11d, %eax	# d, _1333
	sarl	$31, %eax	#, _1333
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	$2147473409, %eax	#, _1335
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	addl	%eax, %r11d	# _1335, tmp1801
	movl	%r11d, 0(%r13,%rdx,4)	# tmp1801, MEM[(uint32_t *)Gp_993 + u_1940 * 4]
# inputs/bootstrap/source/falcon-keygen.c:7026: 	for (u = 0; u < n; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:7026: 	for (u = 0; u < n; u ++) {
	cmpq	%rdx, %rsi	# u, n
	jne	.L816	#,
# inputs/bootstrap/source/falcon-keygen.c:7035: 	modp_iNTT2(Fp, t3, logn, p, p0i);
	movl	24(%rsp), %ebp	# %sfp, p0i
	movl	%ebp, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	64(%rsp), %r15d	# %sfp, logn
	movl	%r15d, %ecx	# logn,
	movq	112(%rsp), %r14	# %sfp, t3
	movq	%r14, %rdx	# t3,
	movl	$1, %esi	#,
	movq	16(%rsp), %rbx	# %sfp, Fp
	movq	%rbx, %rdi	# Fp,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7036: 	modp_iNTT2(Gp, t3, logn, p, p0i);
	movl	%ebp, %r9d	# p0i,
	movl	$2147473409, %r8d	#,
	movl	%r15d, %ecx	# logn,
	movq	%r14, %rdx	# t3,
	movl	$1, %esi	#,
	movq	%r13, %rdi	# Gp,
	call	modp_iNTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7037: 	for (u = 0; u < n; u ++) {
	movl	$0, %edx	#, u
	movq	32(%rsp), %rdi	# %sfp, n
	movq	%rbx, %rsi	# Fp, Fp
	.p2align 6
.L817:
# inputs/bootstrap/source/falcon-keygen.c:7038: 		Fp[u] = (uint32_t)modp_norm(Fp[u], p);
	movl	(%rsi,%rdx,4), %ecx	# MEM[(uint32_t *)Fp_832 + u_1941 * 4], _1341
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	leal	-1073736705(%rcx), %eax	#, _1342
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	shrl	$31, %eax	#, _1343
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	subl	$1, %eax	#, _1344
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	andl	$2147473409, %eax	#, _1345
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	subl	%eax, %ecx	# _1345, tmp1806
	movl	%ecx, (%rsi,%rdx,4)	# tmp1806, MEM[(uint32_t *)Fp_832 + u_1941 * 4]
# inputs/bootstrap/source/falcon-keygen.c:7039: 		Gp[u] = (uint32_t)modp_norm(Gp[u], p);
	movl	0(%r13,%rdx,4), %ecx	# MEM[(uint32_t *)Gp_993 + u_1941 * 4], _1348
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	leal	-1073736705(%rcx), %eax	#, _1349
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	shrl	$31, %eax	#, _1350
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	subl	$1, %eax	#, _1351
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	andl	$2147473409, %eax	#, _1352
# inputs/bootstrap/source/falcon-keygen.c:2493: 	return x - (p & (((x - ((p + 1) >> 1)) >> 31) - 1));
	subl	%eax, %ecx	# _1352, tmp1811
	movl	%ecx, 0(%r13,%rdx,4)	# tmp1811, MEM[(uint32_t *)Gp_993 + u_1941 * 4]
# inputs/bootstrap/source/falcon-keygen.c:7037: 	for (u = 0; u < n; u ++) {
	addq	$1, %rdx	#, u
# inputs/bootstrap/source/falcon-keygen.c:7037: 	for (u = 0; u < n; u ++) {
	cmpq	%rdx, %rdi	# u, n
	jne	.L817	#,
	jmp	.L790	#
.L822:
# inputs/bootstrap/source/falcon-keygen.c:7380: 		modp_NTT2(ft, gm, logn, p, p0i);
	movl	%r14d, %r9d	# p0i,
	movl	%r12d, %r8d	# p,
	movl	96(%rsp), %ecx	# %sfp,
	movq	16(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%rbx, %rdi	# _293,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7381: 		modp_NTT2(gt, gm, logn, p, p0i);
	movl	%r14d, %r9d	# p0i,
	movl	%r12d, %r8d	# p,
	movl	96(%rsp), %ecx	# %sfp,
	movq	16(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%rbp, %rdi	# _298,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7382: 		modp_NTT2(Ft, gm, logn, p, p0i);
	movl	%r14d, %r9d	# p0i,
	movl	%r12d, %r8d	# p,
	movl	96(%rsp), %ecx	# %sfp,
	movq	16(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%r15, %rdi	# Ft,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7383: 		modp_NTT2(Gt, gm, logn, p, p0i);
	movl	%r14d, %r9d	# p0i,
	movl	%r12d, %r8d	# p,
	movl	96(%rsp), %ecx	# %sfp,
	movq	16(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%r13, %rdi	# Gt,
	call	modp_NTT2_ext	#
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %eax	# p0i, _366
	leaq	(%rax,%rax,2), %rsi	#, tmp1853
	salq	$12, %rsi	#, tmp1854
	addq	%rax, %rsi	# _366, _367
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %esi	#, _368
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r12d, %eax	# p, _369
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rsi	# _369, w_370
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	$12289, %rsi	#, _371
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rsi	#, _372
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r12d, %esi	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%esi, %eax	# d, _376
	sarl	$31, %eax	#, _376
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r12d, %eax	# p, _378
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %esi	# _378, r
	jmp	.L823	#
.L886:
# inputs/bootstrap/source/falcon-keygen.c:7475: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	movq	%rdx, %rax	# _1435, tmp2195
	addq	%rax, %rax	# tmp2195
	setne	%cl	#, iftmp.109_1442
	movzbl	%cl, %ecx	# iftmp.109_1442, iftmp.109_1442
.L828:
# inputs/bootstrap/source/falcon-keygen.c:7750: 			valid &= (uint32_t)(1 ^ fpr_lt(g00[u], fpr_onehalf));
	cmpq	%r10, %rdx	# tmp1943, _1435
	setg	%al	#, _1444
	movzbl	%al, %eax	# _1444, _1444
# inputs/bootstrap/source/falcon-keygen.c:7750: 			valid &= (uint32_t)(1 ^ fpr_lt(g00[u], fpr_onehalf));
	andl	%ecx, %eax	# iftmp.109_1442, valid
# inputs/bootstrap/source/falcon-keygen.c:7751: 			bad |= valid ^ 1U;
	movl	%eax, %ecx	# valid, _1447
	xorl	$1, %ecx	#, _1447
# inputs/bootstrap/source/falcon-keygen.c:7751: 			bad |= valid ^ 1U;
	orl	%ecx, %edi	# _1447, bad_lsm.1301
# inputs/bootstrap/source/falcon-keygen.c:7752: 			mask = (uint64_t)0 - (uint64_t)valid;
	movl	%eax, %eax	# valid, _1450
# inputs/bootstrap/source/falcon-keygen.c:7755: 				(xb & mask) | (ft_fpr_bits_keygen(fpr_one) & ~mask));
	leaq	-1(%rax), %rcx	#, _1453
	andq	%r9, %rcx	# tmp1948, _1454
# inputs/bootstrap/source/falcon-keygen.c:7755: 				(xb & mask) | (ft_fpr_bits_keygen(fpr_one) & ~mask));
	negq	%rax	# tmp1949
	andq	%rax, %rdx	# tmp1949, _1452
# inputs/bootstrap/source/falcon-keygen.c:7754: 			g00[u] = ft_fpr_from_bits_keygen(
	orq	%rdx, %rcx	# _1452, _1455
# inputs/bootstrap/source/falcon-keygen.c:7754: 			g00[u] = ft_fpr_from_bits_keygen(
	movq	%rcx, (%r8)	# _1455, MEM[(fpr *)_1094]
# inputs/bootstrap/source/falcon-keygen.c:7746: 		for (u = 0; u < hn; u ++) {
	addq	$8, %rsi	#, ivtmp.1350
	cmpq	%rsi, %r12	# ivtmp.1350, _1031
	je	.L885	#,
.L829:
	movq	%rsi, %r8	# ivtmp.1350, _1094
# inputs/bootstrap/source/falcon-keygen.c:7749: 			valid = (uint32_t)ft_fpr_is_positive_finite_keygen(g00[u]);
	movq	(%rsi), %rdx	# MEM[(fpr *)_1094], _1435
# inputs/bootstrap/source/falcon-keygen.c:7475: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	movq	%rdx, %rax	# _1435, tmp2190
	notq	%rax	# tmp2190
	testq	%r11, %rax	# tmp1931, tmp2190
	je	.L842	#,
	testq	%rdx, %rdx	# _1435
	jns	.L886	#,
.L842:
# inputs/bootstrap/source/falcon-keygen.c:7475: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	movl	%ebx, %ecx	# iftmp.109_1442, iftmp.109_1442
	jmp	.L828	#
.L885:
	movl	%edi, 320(%rsp)	# bad_lsm.1301, MEM[(unsigned int *)_1494]
	movq	96(%rsp), %rax	# %sfp, _41
	movq	%rcx, 55288(%rax)	# _1455, MEM[(fpr *)_41 + 55288B]
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$3, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, 16(%rsp)	# tmp2150, %sfp
	movq	%r15, 112(%rsp)	# t3, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7525: 		a = ft_stable_positive_keygen(roots[u + 0], bad);
	leaq	320(%rsp), %rbx	#, tmp1951
	movq	%r15, 120(%rsp)	# t3, %sfp
	movq	%r14, 128(%rsp)	# t1, %sfp
.L830:
	movq	0(%rbp), %rdi	# MEM[(const fpr *)_1223], MEM[(const fpr *)_1223]
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r14	# tmp2151, a
# inputs/bootstrap/source/falcon-keygen.c:7526: 		b = ft_stable_positive_keygen(roots[u + 1], bad);
	movq	8(%rbp), %rdi	# MEM[(const fpr *)_1223 + 8B], MEM[(const fpr *)_1223 + 8B]
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r13	# tmp2152, b
# inputs/bootstrap/source/falcon-keygen.c:7527: 		c = ft_stable_positive_keygen(roots[u + 2], bad);
	movq	16(%rbp), %rdi	# MEM[(const fpr *)_1223 + 16B], MEM[(const fpr *)_1223 + 16B]
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r12	# tmp2153, c
# inputs/bootstrap/source/falcon-keygen.c:7528: 		e1 = ft_stable_positive_keygen(fpr_add(fpr_add(a, b), c), bad);
	movq	%r13, %rsi	# b,
	movq	%r14, %rdi	# a,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp2154, _1522
# inputs/bootstrap/source/falcon-keygen.c:7528: 		e1 = ft_stable_positive_keygen(fpr_add(fpr_add(a, b), c), bad);
	movq	%r12, %rsi	# c,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp2155, _1523
# inputs/bootstrap/source/falcon-keygen.c:7528: 		e1 = ft_stable_positive_keygen(fpr_add(fpr_add(a, b), c), bad);
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
	movq	%rax, 24(%rsp)	# tmp2156, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7529: 		ab = ft_stable_positive_keygen(fpr_mul(a, b), bad);
	movq	%r13, %rsi	# b,
	movq	%r14, %rdi	# a,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2157, _1525
# inputs/bootstrap/source/falcon-keygen.c:7529: 		ab = ft_stable_positive_keygen(fpr_mul(a, b), bad);
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
	movq	%rax, 32(%rsp)	# tmp2158, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7530: 		ac = ft_stable_positive_keygen(fpr_mul(a, c), bad);
	movq	%r12, %rsi	# c,
	movq	%r14, %rdi	# a,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2159, _1527
# inputs/bootstrap/source/falcon-keygen.c:7530: 		ac = ft_stable_positive_keygen(fpr_mul(a, c), bad);
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r14	# tmp2160, ac
# inputs/bootstrap/source/falcon-keygen.c:7531: 		bc = ft_stable_positive_keygen(fpr_mul(b, c), bad);
	movq	%r12, %rsi	# c,
	movq	%r13, %rdi	# b,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2161, _1529
# inputs/bootstrap/source/falcon-keygen.c:7531: 		bc = ft_stable_positive_keygen(fpr_mul(b, c), bad);
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r13	# tmp2162, bc
# inputs/bootstrap/source/falcon-keygen.c:7532: 		e2 = ft_stable_positive_keygen(fpr_add(fpr_add(ab, ac), bc), bad);
	movq	%r14, %rsi	# ac,
	movq	32(%rsp), %r14	# %sfp, ab
	movq	%r14, %rdi	# ab,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp2163, _1531
# inputs/bootstrap/source/falcon-keygen.c:7532: 		e2 = ft_stable_positive_keygen(fpr_add(fpr_add(ab, ac), bc), bad);
	movq	%r13, %rsi	# bc,
	call	fpr_add@PLT	#
	movq	%rax, %rdi	# tmp2164, _1532
# inputs/bootstrap/source/falcon-keygen.c:7532: 		e2 = ft_stable_positive_keygen(fpr_add(fpr_add(ab, ac), bc), bad);
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r13	# tmp2165, e2
# inputs/bootstrap/source/falcon-keygen.c:7533: 		abc = ft_stable_positive_keygen(fpr_mul(ab, c), bad);
	movq	%r12, %rsi	# c,
	movq	%r14, %rdi	# ab,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2166, _1534
# inputs/bootstrap/source/falcon-keygen.c:7533: 		abc = ft_stable_positive_keygen(fpr_mul(ab, c), bad);
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
	movq	%rax, %r12	# tmp2167, abc
# inputs/bootstrap/source/falcon-keygen.c:7534: 		leaves[v] = ft_stable_positive_keygen(fpr_div(e1, three), bad);
	movq	16(%rsp), %rsi	# %sfp,
	movq	24(%rsp), %r14	# %sfp, e1
	movq	%r14, %rdi	# e1,
	call	fpr_div@PLT	#
	movq	%rax, %rdi	# tmp2168, _1536
# inputs/bootstrap/source/falcon-keygen.c:7534: 		leaves[v] = ft_stable_positive_keygen(fpr_div(e1, three), bad);
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7534: 		leaves[v] = ft_stable_positive_keygen(fpr_div(e1, three), bad);
	movq	%rax, (%r15)	# tmp2169, MEM[(fpr *)_1210]
# inputs/bootstrap/source/falcon-keygen.c:7535: 		leaves[256 + v] = ft_stable_positive_keygen(fpr_div(e2, e1), bad);
	movq	%r14, %rsi	# e1,
	movq	%r13, %rdi	# e2,
	call	fpr_div@PLT	#
	movq	%rax, %rdi	# tmp2170, _1541
# inputs/bootstrap/source/falcon-keygen.c:7535: 		leaves[256 + v] = ft_stable_positive_keygen(fpr_div(e2, e1), bad);
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7535: 		leaves[256 + v] = ft_stable_positive_keygen(fpr_div(e2, e1), bad);
	movq	%rax, 2048(%r15)	# tmp2171, MEM[(fpr *)_1210 + 2048B]
# inputs/bootstrap/source/falcon-keygen.c:7536: 		leaves[512 + v] = ft_stable_positive_keygen(
	movq	%r12, %rsi	# abc,
	movq	16(%rsp), %rdi	# %sfp,
	call	fpr_mul@PLT	#
	movq	%rax, %rdi	# tmp2172, _1546
# inputs/bootstrap/source/falcon-keygen.c:7536: 		leaves[512 + v] = ft_stable_positive_keygen(
	movq	%r13, %rsi	# e2,
	call	fpr_div@PLT	#
	movq	%rax, %rdi	# tmp2173, _1547
# inputs/bootstrap/source/falcon-keygen.c:7536: 		leaves[512 + v] = ft_stable_positive_keygen(
	movq	%rbx, %rsi	# tmp1951,
	call	ft_stable_positive_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7536: 		leaves[512 + v] = ft_stable_positive_keygen(
	movq	%rax, 4096(%r15)	# tmp2174, MEM[(fpr *)_1210 + 4096B]
# inputs/bootstrap/source/falcon-keygen.c:7523: 	for (u = 0, v = 0; u < 768; u += 3, v ++) {
	addq	$24, %rbp	#, ivtmp.1338
	addq	$8, %r15	#, ivtmp.1340
	cmpq	%rbp, 64(%rsp)	# ivtmp.1338, %sfp
	jne	.L830	#,
# inputs/bootstrap/source/falcon-keygen.c:7539: 	ft_stable_binary_inplace_keygen(leaves + 0, 256, scratch, bad);
	movq	120(%rsp), %r15	# %sfp, t3
	movq	128(%rsp), %r14	# %sfp, t1
	leaq	320(%rsp), %rbx	#, tmp1966
	movq	%rbx, %rcx	# tmp1966,
	movq	104(%rsp), %rbp	# %sfp, t3
	movq	%rbp, %rdx	# t3,
	movl	$256, %esi	#,
	movq	%r15, %rdi	# t3,
	call	ft_stable_binary_inplace_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7540: 	ft_stable_binary_inplace_keygen(leaves + 256, 256, scratch, bad);
	movq	96(%rsp), %r13	# %sfp, _41
	leaq	247808(%r13), %rdi	#, _1554
	movq	%rbx, %rcx	# tmp1966,
	movq	%rbp, %rdx	# t3,
	movl	$256, %esi	#,
	call	ft_stable_binary_inplace_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7541: 	ft_stable_binary_inplace_keygen(leaves + 512, 256, scratch, bad);
	movq	%rbx, %rcx	# tmp1966,
	movq	%rbp, %rdx	# t3,
	movl	$256, %esi	#,
	movq	%r14, %rdi	# t1,
	call	ft_stable_binary_inplace_keygen	#
# inputs/bootstrap/source/fpr-emulated.h:89: 	return fpr_scaled(i, 0);
	movl	$0, %esi	#,
	movl	$339775489, %edi	#,
	call	fpr_scaled@PLT	#
	movq	%rax, %rbp	# tmp2175, _1458
	movl	$0, %ebx	#, ivtmp.1328
# inputs/bootstrap/source/falcon-keygen.c:7762: 			leaves[n - 1 - u] = ft_stable_positive_keygen(
	leaq	320(%rsp), %r12	#, tmp1971
.L831:
# inputs/bootstrap/source/falcon-keygen.c:7762: 			leaves[n - 1 - u] = ft_stable_positive_keygen(
	movq	245760(%r13,%rbx), %rsi	# MEM[(fpr *)_41 + 245760B + ivtmp.1328_1410 * 1], MEM[(fpr *)_41 + 245760B + ivtmp.1328_1410 * 1]
	movq	%rbp, %rdi	# _1458,
	call	fpr_div@PLT	#
	movq	%rax, %rdi	# tmp2176, _1463
# inputs/bootstrap/source/falcon-keygen.c:7762: 			leaves[n - 1 - u] = ft_stable_positive_keygen(
	movq	%r12, %rsi	# tmp1971,
	call	ft_stable_positive_keygen	#
	movq	%rax, %rdx	#, tmp2177
# inputs/bootstrap/source/falcon-keygen.c:7762: 			leaves[n - 1 - u] = ft_stable_positive_keygen(
	movq	%rbx, %rax	# ivtmp.1328, _1268
	negq	%rax	# _1268
	movq	%rdx, 258040(%r13,%rax)	# tmp2177, MEM[(fpr *)_41 + 258040B + _1268 * 1]
# inputs/bootstrap/source/falcon-keygen.c:7761: 		for (u = 0; u < hn; u ++) {
	addq	$8, %rbx	#, ivtmp.1328
	cmpq	$6144, %rbx	#, ivtmp.1328
	jne	.L831	#,
	movq	96(%rsp), %rbp	# %sfp, _41
	addq	$258048, %rbp	#, _41
# inputs/bootstrap/source/falcon-keygen.c:7768: 			leaves[u] = ft_stable_positive_keygen(leaves[u], &bad);
	leaq	320(%rsp), %r12	#, tmp1973
# inputs/bootstrap/source/falcon-keygen.c:7771: 				- FT1536_LEAF_MIN_BITS) >> 63));
	movabsq	$-4652218416473572215, %r13	#, tmp1976
# inputs/bootstrap/source/falcon-keygen.c:7773: 				- bits) >> 63));
	movabsq	$4689448209939135824, %rbx	#, tmp1979
	movq	112(%rsp), %r14	# %sfp, ivtmp.1315
.L832:
# inputs/bootstrap/source/falcon-keygen.c:7768: 			leaves[u] = ft_stable_positive_keygen(leaves[u], &bad);
	movq	(%r14), %rdi	# MEM[(fpr *)_1959], MEM[(fpr *)_1959]
	movq	%r12, %rsi	# tmp1973,
	call	ft_stable_positive_keygen	#
	movq	%rax, %rcx	# tmp2178, _1474
# inputs/bootstrap/source/falcon-keygen.c:7768: 			leaves[u] = ft_stable_positive_keygen(leaves[u], &bad);
	movq	%rax, (%r14)	# _1474, MEM[(fpr *)_1959]
# inputs/bootstrap/source/falcon-keygen.c:7771: 				- FT1536_LEAF_MIN_BITS) >> 63));
	leaq	(%rax,%r13), %rdx	#, _1475
# inputs/bootstrap/source/falcon-keygen.c:7771: 				- FT1536_LEAF_MIN_BITS) >> 63));
	shrq	$63, %rdx	#, _1476
# inputs/bootstrap/source/falcon-keygen.c:7770: 			valid = (uint32_t)(1 ^ (uint32_t)((bits
	xorl	$1, %edx	#, valid
# inputs/bootstrap/source/falcon-keygen.c:7773: 				- bits) >> 63));
	movq	%rbx, %rax	# tmp1979, _1479
	subq	%rcx, %rax	# _1474, _1479
# inputs/bootstrap/source/falcon-keygen.c:7773: 				- bits) >> 63));
	shrq	$63, %rax	#, _1480
# inputs/bootstrap/source/falcon-keygen.c:7772: 			valid &= (uint32_t)(1 ^ (uint32_t)((FT1536_LEAF_MAX_BITS
	xorl	$1, %eax	#, _1482
# inputs/bootstrap/source/falcon-keygen.c:7772: 			valid &= (uint32_t)(1 ^ (uint32_t)((FT1536_LEAF_MAX_BITS
	andl	%edx, %eax	# valid, valid_1483
# inputs/bootstrap/source/falcon-keygen.c:7774: 			bad |= valid ^ 1U;
	xorl	$1, %eax	#, _1484
# inputs/bootstrap/source/falcon-keygen.c:7774: 			bad |= valid ^ 1U;
	orl	320(%rsp), %eax	# MEM[(unsigned int *)_1494], _1486
	movl	%eax, 320(%rsp)	# _1486, MEM[(unsigned int *)_1494]
# inputs/bootstrap/source/falcon-keygen.c:7765: 		for (u = 0; u < n; u ++) {
	addq	$8, %r14	#, ivtmp.1315
	cmpq	%r14, %rbp	# ivtmp.1315, _1338
	jne	.L832	#,
# inputs/bootstrap/source/falcon-keygen.c:8110: 			if (!ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,
	testl	%eax, %eax	# _1486
	jne	.L771	#,
.L826:
# inputs/bootstrap/source/falcon-keygen.c:8140: 	klen = *privkey_len;
	movq	232(%rsp), %rax	# %sfp, privkey_len
	movq	(%rax), %r13	# *privkey_len_159(D), klen
# inputs/bootstrap/source/falcon-keygen.c:8143: 		return 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:8142: 	if (klen < 1) {
	testq	%r13, %r13	# klen
	je	.L766	#,
# inputs/bootstrap/source/falcon-keygen.c:8145: 	skbuf[0] = (ter << 7) + (comp << 5) + logn;
	movzbl	208(%rsp), %r14d	# %sfp, _44
	sall	$7, %r14d	#, _44
# inputs/bootstrap/source/falcon-keygen.c:8145: 	skbuf[0] = (ter << 7) + (comp << 5) + logn;
	movzbl	212(%rsp), %eax	# %sfp, _46
	sall	$5, %eax	#, _46
# inputs/bootstrap/source/falcon-keygen.c:8145: 	skbuf[0] = (ter << 7) + (comp << 5) + logn;
	addb	44(%rsp), %al	# %sfp, _1421
	addl	%r14d, %eax	# _44, tmp1986
	movq	248(%rsp), %rcx	# %sfp, privkey
	movb	%al, (%rcx)	# tmp1986, MEM[(unsigned char *)privkey_161(D)]
# inputs/bootstrap/source/falcon-keygen.c:8147: 	ske[0] = f;
	leaq	24960(%rsp), %rax	#, tmp1987
	movq	%rax, 352(%rsp)	# tmp1987, ske[0]
# inputs/bootstrap/source/falcon-keygen.c:8148: 	ske[1] = g;
	leaq	18816(%rsp), %rax	#, tmp1988
	movq	%rax, 360(%rsp)	# tmp1988, ske[1]
# inputs/bootstrap/source/falcon-keygen.c:8149: 	ske[2] = F;
	leaq	12672(%rsp), %rax	#, tmp1989
	movq	%rax, 368(%rsp)	# tmp1989, ske[2]
# inputs/bootstrap/source/falcon-keygen.c:8150: 	ske[3] = G;
	leaq	6528(%rsp), %rax	#, tmp1990
	movq	%rax, 376(%rsp)	# tmp1990, ske[3]
	cmpb	$1, 88(%rsp)	#, %sfp
	sbbl	%r12d, %r12d	# iftmp.12_71
	andl	$-6144, %r12d	#, iftmp.12_71
	addl	$18433, %r12d	#, iftmp.12_71
	leaq	352(%rsp), %rbp	#, ivtmp.1308
	leaq	384(%rsp), %r15	#, _1973
# inputs/bootstrap/source/falcon-keygen.c:8146: 	skoff = 1;
	movl	$1, %ebx	#, skoff
	movb	%r14b, 8(%rsp)	# _44, %sfp
	movq	%rcx, %r14	# privkey, privkey
.L833:
# inputs/bootstrap/source/falcon-keygen.c:8154: 		elen = falcon_encode_small(skbuf + skoff, klen - skoff,
	movq	%r13, %rsi	# klen, _51
	subq	%rbx, %rsi	# skoff, _51
# inputs/bootstrap/source/falcon-keygen.c:8154: 		elen = falcon_encode_small(skbuf + skoff, klen - skoff,
	leaq	(%r14,%rbx), %rdi	#, _52
# inputs/bootstrap/source/falcon-keygen.c:8154: 		elen = falcon_encode_small(skbuf + skoff, klen - skoff,
	movl	44(%rsp), %r9d	# %sfp,
	movq	0(%rbp), %r8	# MEM[(int16_t * *)_1977],
	movl	%r12d, %ecx	# iftmp.12_71,
	movl	212(%rsp), %edx	# %sfp,
	call	falcon_encode_small@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:8156: 		if (elen == 0) {
	testq	%rax, %rax	# elen
	je	.L844	#,
# inputs/bootstrap/source/falcon-keygen.c:8159: 		skoff += elen;
	addq	%rax, %rbx	# elen, skoff
# inputs/bootstrap/source/falcon-keygen.c:8151: 	for (i = 0; i < 4; i ++) {
	addq	$8, %rbp	#, ivtmp.1308
	cmpq	%r15, %rbp	# _1973, ivtmp.1308
	jne	.L833	#,
# inputs/bootstrap/source/falcon-keygen.c:8161: 	*privkey_len = skoff;
	movzbl	8(%rsp), %r14d	# %sfp, _44
	movq	232(%rsp), %rax	# %sfp, privkey_len
	movq	%rbx, (%rax)	# skoff, *privkey_len_159(D)
# inputs/bootstrap/source/falcon-keygen.c:8166: 	klen = *pubkey_len;
	movq	240(%rsp), %rax	# %sfp, pubkey_len
	movq	(%rax), %rdx	# *pubkey_len_169(D), klen
# inputs/bootstrap/source/falcon-keygen.c:8168: 		return 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:8167: 	if (klen < 1) {
	testq	%rdx, %rdx	# klen
	je	.L766	#,
# inputs/bootstrap/source/falcon-keygen.c:8170: 	((unsigned char *)pubkey)[0] = (ter << 7) + logn;
	movl	44(%rsp), %ecx	# %sfp, logn
	movl	%ecx, %eax	# logn, tmp2755
	addl	%r14d, %eax	# _44, tmp1995
	movq	256(%rsp), %rbx	# %sfp, pubkey
	movb	%al, (%rbx)	# tmp1995, MEM[(unsigned char *)pubkey_171(D)]
# inputs/bootstrap/source/falcon-keygen.c:8171: 	if (ter) {
	cmpl	$0, 208(%rsp)	#, %sfp
	je	.L834	#,
# inputs/bootstrap/source/falcon-keygen.c:8172: 		klen = falcon_encode_18433(
	leaq	-1(%rdx), %rsi	#, _54
	leaq	384(%rsp), %rdx	#, tmp1996
	addq	$1, %rbx	#, pubkey
	movq	%rbx, %rdi	# pubkey, _55
	call	falcon_encode_18433@PLT	#
	movq	%rax, %rdx	# tmp2180, klen
.L835:
# inputs/bootstrap/source/falcon-keygen.c:8179: 		return 0;
	movl	$0, %eax	#, <retval>
# inputs/bootstrap/source/falcon-keygen.c:8178: 	if (klen == 0) {
	testq	%rdx, %rdx	# klen
	je	.L766	#,
# inputs/bootstrap/source/falcon-keygen.c:8181: 	*pubkey_len = klen + 1;
	addq	$1, %rdx	#, tmp2000
	movq	240(%rsp), %rax	# %sfp, pubkey_len
	movq	%rdx, (%rax)	# tmp2000, *pubkey_len_169(D)
# inputs/bootstrap/source/falcon-keygen.c:8186: 	return 1;
	movl	$1, %eax	#, <retval>
	jmp	.L766	#
.L834:
# inputs/bootstrap/source/falcon-keygen.c:8175: 		klen = falcon_encode_12289(
	leaq	-1(%rdx), %rsi	#, _56
	leaq	384(%rsp), %rdx	#, tmp1998
	movq	256(%rsp), %rdi	# %sfp, pubkey
	addq	$1, %rdi	#, pubkey
	movl	44(%rsp), %ecx	# %sfp,
	call	falcon_encode_12289@PLT	#
	movq	%rax, %rdx	# tmp2181, klen
	jmp	.L835	#
.L837:
# inputs/bootstrap/source/falcon-keygen.c:7873: 				return 0;
	movl	$0, %eax	#, <retval>
.L766:
# inputs/bootstrap/source/falcon-keygen.c:8187: }
	addq	$31112, %rsp	#,
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
.L844:
	.cfi_restore_state
# inputs/bootstrap/source/falcon-keygen.c:8157: 			return 0;
	movl	$0, %eax	#, <retval>
	jmp	.L766	#
.L818:
# inputs/bootstrap/source/falcon-keygen.c:7361: 	p0i = modp_ninv31(p);
	movl	$2147355649, %edi	#,
	call	modp_ninv31	#
	movl	%eax, %r14d	# tmp2182, p0i
# inputs/bootstrap/source/falcon-keygen.c:7363: 		modp_mkgm3(gm, ft, logn, 1, primes[0].g, p, p0i);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 31176
	pushq	%rax	# p0i
	.cfi_def_cfa_offset 31184
	movl	$2147355649, %r9d	#,
	movl	$1907584673, %r8d	#,
	movl	$1, %ecx	#,
	movl	112(%rsp), %edx	# %sfp,
	movq	%rbx, %rsi	# _293,
	movq	32(%rsp), %rdi	# %sfp,
	call	modp_mkgm3	#
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 31168
# inputs/bootstrap/source/falcon-keygen.c:7360: 	p = primes[0].p;
	movl	$2147355649, %r12d	#, p
.L836:
# inputs/bootstrap/source/falcon-keygen.c:7367: 	for (u = 0; u < n; u ++) {
	movl	$0, %eax	#, u
	movq	24(%rsp), %rcx	# %sfp, n
	cmpq	$0, 24(%rsp)	#, %sfp
	je	.L821	#,
.L820:
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	24960(%rsp,%rax,2), %esi	# MEM[(const int16_t *)&f + u_1921 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%esi, %edx	# w, _319
	sarl	$31, %edx	#, _319
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	%r12d, %edx	# p, _321
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%esi, %edx	# w, tmp1822
	movl	%edx, (%rbx,%rax,4)	# tmp1822, MEM[(uint32_t *)_293 + u_1921 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	18816(%rsp,%rax,2), %esi	# MEM[(const int16_t *)&g + u_1921 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%esi, %edx	# w, _328
	sarl	$31, %edx	#, _328
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	%r12d, %edx	# p, _330
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%esi, %edx	# w, tmp1827
	movl	%edx, 0(%rbp,%rax,4)	# tmp1827, MEM[(uint32_t *)_298 + u_1921 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	12672(%rsp,%rax,2), %esi	# MEM[(int16_t *)&F + u_1921 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%esi, %edx	# w, _337
	sarl	$31, %edx	#, _337
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	%r12d, %edx	# p, _339
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%esi, %edx	# w, tmp1832
	movl	%edx, (%r15,%rax,4)	# tmp1832, MEM[(uint32_t *)Ft_302 + u_1921 * 4]
# inputs/bootstrap/source/falcon-keygen.c:2482: 	w = (uint32_t)x;
	movswl	6528(%rsp,%rax,2), %esi	# MEM[(int16_t *)&G + u_1921 * 2], w
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	movl	%esi, %edx	# w, _346
	sarl	$31, %edx	#, _346
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	andl	%r12d, %edx	# p, _348
# inputs/bootstrap/source/falcon-keygen.c:2483: 	w += p & -(w >> 31);
	addl	%esi, %edx	# w, tmp1837
	movl	%edx, 0(%r13,%rax,4)	# tmp1837, MEM[(uint32_t *)Gt_303 + u_1921 * 4]
# inputs/bootstrap/source/falcon-keygen.c:7367: 	for (u = 0; u < n; u ++) {
	addq	$1, %rax	#, u
# inputs/bootstrap/source/falcon-keygen.c:7367: 	for (u = 0; u < n; u ++) {
	cmpq	%rax, %rcx	# u, n
	jne	.L820	#,
.L821:
# inputs/bootstrap/source/falcon-keygen.c:7373: 	if (fk->ternary) {
	movq	48(%rsp), %rax	# %sfp, fk
	cmpl	$0, 4(%rax)	#, fk_82(D)->ternary
	je	.L822	#,
# inputs/bootstrap/source/falcon-keygen.c:7374: 		modp_NTT3(ft, gm, logn, 1, p, p0i);
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 31176
	pushq	%r14	# p0i
	.cfi_def_cfa_offset 31184
	movl	%r12d, %r9d	# p,
	movl	$1, %r8d	#,
	movl	112(%rsp), %ecx	# %sfp,
	movq	32(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%rbx, %rdi	# _293,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7375: 		modp_NTT3(gt, gm, logn, 1, p, p0i);
	movl	%r14d, (%rsp)	# p0i,
	movl	%r12d, %r9d	# p,
	movl	$1, %r8d	#,
	movl	112(%rsp), %ecx	# %sfp,
	movq	32(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%rbp, %rdi	# _298,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7376: 		modp_NTT3(Ft, gm, logn, 1, p, p0i);
	movl	%r14d, (%rsp)	# p0i,
	movl	%r12d, %r9d	# p,
	movl	$1, %r8d	#,
	movl	112(%rsp), %ecx	# %sfp,
	movq	32(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%r15, %rdi	# Ft,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:7377: 		modp_NTT3(Gt, gm, logn, 1, p, p0i);
	movl	%r14d, (%rsp)	# p0i,
	movl	%r12d, %r9d	# p,
	movl	$1, %r8d	#,
	movl	112(%rsp), %ecx	# %sfp,
	movq	32(%rsp), %rdx	# %sfp,
	movl	$1, %esi	#,
	movq	%r13, %rdi	# Gt,
	call	modp_NTT3_ext	#
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %eax	# p0i, _352
	leaq	(%rax,%rax,8), %rsi	#, tmp1841
	salq	$11, %rsi	#, tmp1842
	addq	%rax, %rsi	# _352, _353
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %esi	#, _354
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r12d, %eax	# p, _355
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rax, %rsi	# _355, w_356
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	$18433, %rsi	#, _357
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rsi	#, _358
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r12d, %esi	# p, d
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	movl	%esi, %eax	# d, _362
	sarl	$31, %eax	#, _362
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r12d, %eax	# p, _364
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	addl	%eax, %esi	# _364, r
	addq	$16, %rsp	#,
	.cfi_def_cfa_offset 31168
.L823:
# inputs/bootstrap/source/falcon-keygen.c:7386: 	for (u = 0; u < n; u ++) {
	movq	24(%rsp), %r9	# %sfp, n
	testq	%r9, %r9	# n
	je	.L824	#,
# inputs/bootstrap/source/falcon-keygen.c:7386: 	for (u = 0; u < n; u ++) {
	movl	$0, %ecx	#, u
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r14d, %r8d	# p0i, _389
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movl	%r12d, %edi	# p, _392
.L825:
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	0(%rbp,%rcx,4), %edx	# MEM[(uint32_t *)_298 + u_1922 * 4], _386
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%r15,%rcx,4), %eax	# MEM[(uint32_t *)Ft_302 + u_1922 * 4], _387
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%rax, %rdx	# _387, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%rdx, %rax	# z, _390
	imulq	%r8, %rax	# _389, _390
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %eax	#, _391
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rdi, %rax	# _392, w_393
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %rax	# z, _394
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %rax	#, _395
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	(%rbx,%rcx,4), %edx	# MEM[(uint32_t *)_293 + u_1922 * 4], _407
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	movl	0(%r13,%rcx,4), %r10d	# MEM[(uint32_t *)Gt_303 + u_1922 * 4], _408
# inputs/bootstrap/source/falcon-keygen.c:2562: 	z = (uint64_t)a * (uint64_t)b;
	imulq	%r10, %rdx	# _408, z
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	movq	%r8, %r10	# _389, _410
	imulq	%rdx, %r10	# z, _410
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	andl	$2147483647, %r10d	#, _411
# inputs/bootstrap/source/falcon-keygen.c:2563: 	w = ((z * p0i) & (uint64_t)0x7FFFFFFF) * p;
	imulq	%rdi, %r10	# _392, w_412
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	addq	%rdx, %r10	# z, _413
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	shrq	$31, %r10	#, _414
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	movl	%r10d, %edx	# _414, d_416
	subl	%r12d, %edx	# p, d_416
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	sarl	$31, %edx	#, _418
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r12d, %edx	# p, _420
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%eax, %r10d	# _395, _1418
	addl	%r10d, %edx	# _1418, _1414
# inputs/bootstrap/source/falcon-keygen.c:2564: 	d = (uint32_t)((z + w) >> 31) - p;
	subl	%r12d, %eax	# p, d_397
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	sarl	$31, %eax	#, _399
# inputs/bootstrap/source/falcon-keygen.c:2565: 	d += p & -(d >> 31);
	andl	%r12d, %eax	# p, _401
# inputs/bootstrap/source/falcon-keygen.c:2547: 	d = a - b;
	subl	%eax, %edx	# _401, d
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	movl	%edx, %eax	# d, _424
	sarl	$31, %eax	#, _424
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	andl	%r12d, %eax	# p, _426
# inputs/bootstrap/source/falcon-keygen.c:2548: 	d += p & -(d >> 31);
	addl	%eax, %edx	# _426, d_427
# inputs/bootstrap/source/falcon-keygen.c:7391: 		if (z != r) {
	cmpl	%esi, %edx	# r, d_427
	jne	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:7386: 	for (u = 0; u < n; u ++) {
	addq	$1, %rcx	#, u
# inputs/bootstrap/source/falcon-keygen.c:7386: 	for (u = 0; u < n; u ++) {
	cmpq	%rcx, %r9	# u, n
	jne	.L825	#,
.L824:
# inputs/bootstrap/source/falcon-keygen.c:8109: 		if (ter && logn == 10 && n == 1536) {
	movl	208(%rsp), %edx	# %sfp, ter
	testl	%edx, %edx	# ter
	setne	88(%rsp)	#, %sfp
	movzbl	88(%rsp), %ecx	# %sfp, _38
# inputs/bootstrap/source/falcon-keygen.c:8109: 		if (ter && logn == 10 && n == 1536) {
	cmpl	$10, 44(%rsp)	#, %sfp
	sete	%al	#, _39
# inputs/bootstrap/source/falcon-keygen.c:8109: 		if (ter && logn == 10 && n == 1536) {
	testb	%al, %cl	# _39, _38
	je	.L826	#,
	cmpq	$1536, 72(%rsp)	#, %sfp
	jne	.L826	#,
# inputs/bootstrap/source/falcon-keygen.c:7700: 	if (logn != 10 || n != 1536 || hn != 768 || ter != 1) {
	cmpl	$1, %edx	#, ter
	jne	.L771	#,
# inputs/bootstrap/source/falcon-keygen.c:8110: 			if (!ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,
	movq	48(%rsp), %rax	# %sfp, fk
	movq	432(%rax), %r15	# fk_82(D)->tmp, _41
# inputs/bootstrap/source/falcon-keygen.c:7703: 	bad = 0;
	movl	$0, 320(%rsp)	#, MEM[(unsigned int *)_1494]
# inputs/bootstrap/source/falcon-keygen.c:7710: 		tg = tf + n;
	leaq	12288(%r15), %r14	#, tg
# inputs/bootstrap/source/falcon-keygen.c:7711: 		tF = tg + n;
	leaq	24576(%r15), %rbp	#, tF
# inputs/bootstrap/source/falcon-keygen.c:7712: 		tG = tF + n;
	leaq	36864(%r15), %r12	#, tG
# inputs/bootstrap/source/falcon-keygen.c:7713: 		g00 = tG + n;
	leaq	49152(%r15), %r13	#, g00
# inputs/bootstrap/source/falcon-keygen.c:7714: 		g10 = g00 + n;
	leaq	61440(%r15), %rax	#, g10
	movq	%rax, 16(%rsp)	# g10, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7715: 		g11 = g10 + n;
	leaq	73728(%r15), %rcx	#, g11
	movq	%rcx, 24(%rsp)	# g11, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7716: 		gxx = g11 + n;
	leaq	86016(%r15), %rbx	#, gxx
# inputs/bootstrap/source/falcon-keygen.c:7717: 		smallints_to_fpr_keygen(tf, f, logn, 1);
	leaq	24960(%rsp), %rsi	#, tmp1892
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%r15, %rdi	# _41,
	call	smallints_to_fpr_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7718: 		smallints_to_fpr_keygen(tg, g, logn, 1);
	leaq	18816(%rsp), %rsi	#, tmp1893
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%r14, %rdi	# tg,
	call	smallints_to_fpr_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7719: 		smallints_to_fpr_keygen(tF, F, logn, 1);
	leaq	12672(%rsp), %rsi	#, tmp1894
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%rbp, %rdi	# tF,
	call	smallints_to_fpr_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7720: 		smallints_to_fpr_keygen(tG, G, logn, 1);
	leaq	6528(%rsp), %rsi	#, tmp1895
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%r12, %rdi	# tG,
	call	smallints_to_fpr_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7721: 		falcon_FFT3(tf, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%r15, %rdi	# _41,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7722: 		falcon_FFT3(tg, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%r14, %rdi	# tg,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7723: 		falcon_FFT3(tF, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%rbp, %rdi	# tF,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7724: 		falcon_FFT3(tG, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%r12, %rdi	# tG,
	call	falcon_FFT3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7725: 		falcon_poly_neg_fft3(tf, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%r15, %rdi	# _41,
	call	falcon_poly_neg3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7726: 		falcon_poly_neg_fft3(tF, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%rbp, %rdi	# tF,
	call	falcon_poly_neg3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7727: 		memcpy(g00, tg, n * sizeof *tg);
	movl	$12288, %edx	#,
	movq	%r14, %rsi	# tg,
	movq	%r13, %rdi	# g00,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7728: 		falcon_poly_mulselfadj_fft3(g00, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%r13, %rdi	# g00,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7729: 		memcpy(gxx, tf, n * sizeof *tf);
	movl	$12288, %edx	#,
	movq	%r15, %rsi	# _41,
	movq	%rbx, %rdi	# gxx,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7730: 		falcon_poly_mulselfadj_fft3(gxx, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7731: 		falcon_poly_add_fft3(g00, gxx, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%rbx, %rsi	# gxx,
	movq	%r13, %rdi	# g00,
	call	falcon_poly_add3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7732: 		memcpy(g10, tG, n * sizeof *tG);
	movl	$12288, %edx	#,
	movq	%r12, %rsi	# tG,
	movq	16(%rsp), %rdi	# %sfp,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7733: 		falcon_poly_muladj_fft3(g10, tg, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%r14, %rsi	# tg,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_muladj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7734: 		memcpy(gxx, tF, n * sizeof *tF);
	movl	$12288, %edx	#,
	movq	%rbp, %rsi	# tF,
	movq	%rbx, %rdi	# gxx,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7735: 		falcon_poly_muladj_fft3(gxx, tf, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%r15, %r14	# _41, _41
	movq	%r15, %rsi	# _41,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_muladj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7736: 		falcon_poly_add_fft3(g10, gxx, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%rbx, %rsi	# gxx,
	movq	16(%rsp), %rdi	# %sfp,
	call	falcon_poly_add3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7737: 		memcpy(g11, tG, n * sizeof *tG);
	movl	$12288, %edx	#,
	movq	%r12, %rsi	# tG,
	movq	24(%rsp), %r15	# %sfp, g11
	movq	%r15, %rdi	# g11,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7738: 		falcon_poly_mulselfadj_fft3(g11, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%r15, %rdi	# g11,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7739: 		memcpy(gxx, tF, n * sizeof *tF);
	movl	$12288, %edx	#,
	movq	%rbp, %rsi	# tF,
	movq	%rbx, %rdi	# gxx,
	call	memcpy@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7740: 		falcon_poly_mulselfadj_fft3(gxx, logn, 1);
	movl	$1, %edx	#,
	movl	$10, %esi	#,
	movq	%rbx, %rdi	# gxx,
	call	falcon_poly_mulselfadj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7741: 		falcon_poly_add_fft3(g11, gxx, logn, 1);
	movl	$1, %ecx	#,
	movl	$10, %edx	#,
	movq	%rbx, %rsi	# gxx,
	movq	%r15, 24(%rsp)	# g11, %sfp
	movq	%r15, %rdi	# g11,
	call	falcon_poly_add3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7742: 		tree = gxx + n;
	movq	%r14, %rbp	# _41, _41
	leaq	98304(%r14), %r12	#, tree
# inputs/bootstrap/source/falcon-keygen.c:7744: 		t3 = tree + treesize;
	leaq	245760(%r14), %r15	#, t3
# inputs/bootstrap/source/falcon-keygen.c:7668: 	t1 = t0 + tn;
	leaq	249856(%r14), %r14	#, t1
# inputs/bootstrap/source/falcon-keygen.c:7669: 	t2 = t1 + tn;
	leaq	253952(%rbp), %rbx	#, t2
# inputs/bootstrap/source/falcon-keygen.c:7670: 	t3 = t2 + tn;
	leaq	258048(%rbp), %rax	#, t3
	movq	%rax, 104(%rsp)	# t3, %sfp
# inputs/bootstrap/source/falcon-keygen.c:7671: 	falcon_poly_split_top_fft3(t0, t1, t2, g00, logn);
	movl	$10, %r8d	#,
	movq	%r13, %rcx	# g00,
	movq	%rbx, %rdx	# t2,
	movq	%r14, %rsi	# t1,
	movq	%r15, %rdi	# t3,
	call	falcon_poly_split_top_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7672: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	movl	$0, %edx	#,
	movl	$9, %esi	#,
	movq	%r14, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7673: 	falcon_poly_adj_fft3(t2, logn - 1, 0);
	movl	$0, %edx	#,
	movl	$9, %esi	#,
	movq	%rbx, %rdi	# t2,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7674: 	s += ffLDL_depth1_fft3_keygen(tree + s, t0, t1, t0, t2, t1, t0, logn - 1, t3);
	movq	%rbp, 96(%rsp)	# _41, %sfp
	leaq	110592(%rbp), %rdi	#, _1499
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 31176
	pushq	112(%rsp)	# %sfp
	.cfi_def_cfa_offset 31184
	pushq	$9	#
	.cfi_def_cfa_offset 31192
	pushq	%r15	# t3
	.cfi_def_cfa_offset 31200
	movq	%r14, %r9	# t1,
	movq	%rbx, %r8	# t2,
	movq	%r15, %rcx	# t3,
	movq	%r14, %rdx	# t1,
	movq	%r15, %rsi	# t3,
	call	ffLDL_depth1_fft3_keygen	#
	movq	%rax, %rbp	# tmp2149, _1500
# inputs/bootstrap/source/falcon-keygen.c:7676: 	LDL_dim2_fft3_keygen(d11, l10, g00, g10, g11, logn, 1);
	addq	$24, %rsp	#,
	.cfi_def_cfa_offset 31176
	pushq	$1	#
	.cfi_def_cfa_offset 31184
	movl	$10, %r9d	#,
	movq	40(%rsp), %r8	# %sfp,
	movq	32(%rsp), %rcx	# %sfp,
	movq	%r13, %rdx	# g00,
	movq	%r12, %rsi	# tree,
	movq	120(%rsp), %rdi	# %sfp,
	call	LDL_dim2_fft3_keygen	#
# inputs/bootstrap/source/falcon-keygen.c:7677: 	falcon_poly_split_top_fft3(t0, t1, t2, d11, logn);
	movl	$10, %r8d	#,
	movq	120(%rsp), %rcx	# %sfp,
	movq	%rbx, %rdx	# t2,
	movq	%r14, %rsi	# t1,
	movq	%r15, %rdi	# t3,
	call	falcon_poly_split_top_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7678: 	falcon_poly_adj_fft3(t1, logn - 1, 0);
	movl	$0, %edx	#,
	movl	$9, %esi	#,
	movq	%r14, %rdi	# t1,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7679: 	falcon_poly_adj_fft3(t2, logn - 1, 0);
	movl	$0, %edx	#,
	movl	$9, %esi	#,
	movq	%rbx, %rdi	# t2,
	call	falcon_poly_adj_fft3@PLT	#
# inputs/bootstrap/source/falcon-keygen.c:7680: 	s += ffLDL_depth1_fft3_keygen(tree + s, t0, t1, t0, t2, t1, t0, logn - 1, t3);
	leaq	12288(%r12,%rbp,8), %rdi	#, _1503
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 31176
	pushq	112(%rsp)	# %sfp
	.cfi_def_cfa_offset 31184
	pushq	$9	#
	.cfi_def_cfa_offset 31192
	pushq	%r15	# t3
	.cfi_def_cfa_offset 31200
	movq	%r14, %r9	# t1,
	movq	%rbx, %r8	# t2,
	movq	%r15, %rcx	# t3,
	movq	%r14, %rdx	# t1,
	movq	%r15, %rsi	# t3,
	call	ffLDL_depth1_fft3_keygen	#
	movl	352(%rsp), %edi	# MEM[(unsigned int *)_1494], bad_lsm.1301
	movq	%r13, %rbp	# g00, ivtmp.1338
	movq	128(%rsp), %rax	# %sfp, _41
	leaq	55296(%rax), %r12	#, _1031
	movq	%r12, 96(%rsp)	# _1031, %sfp
	addq	$32, %rsp	#,
	.cfi_def_cfa_offset 31168
	movq	%r13, %rsi	# g00, ivtmp.1350
# inputs/bootstrap/source/falcon-keygen.c:7475: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	movabsq	$9218868437227405312, %r11	#, tmp1931
# inputs/bootstrap/source/falcon-keygen.c:7475: 	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
	movl	$0, %ebx	#, iftmp.109_1442
# inputs/bootstrap/source/falcon-keygen.c:7750: 			valid &= (uint32_t)(1 ^ fpr_lt(g00[u], fpr_onehalf));
	movabsq	$4602678819172646911, %r10	#, tmp1943
# inputs/bootstrap/source/falcon-keygen.c:7755: 				(xb & mask) | (ft_fpr_bits_keygen(fpr_one) & ~mask));
	movabsq	$4607182418800017408, %r9	#, tmp1948
	jmp	.L829	#
	.cfi_endproc
.LFE120:
	.size	falcon_keygen_make, .-falcon_keygen_make
	.section	.rodata
	.align 32
	.type	vv.0, @object
	.size	vv.0, 128
vv.0:
	.long	0
	.long	31
	.long	4
	.long	5
	.long	6
	.long	10
	.long	7
	.long	15
	.long	11
	.long	20
	.long	8
	.long	18
	.long	16
	.long	25
	.long	12
	.long	27
	.long	21
	.long	30
	.long	3
	.long	9
	.long	14
	.long	19
	.long	17
	.long	24
	.long	26
	.long	29
	.long	2
	.long	13
	.long	23
	.long	28
	.long	1
	.long	22
	.align 8
	.type	MEMCHECK_MARK, @object
	.size	MEMCHECK_MARK, 9
MEMCHECK_MARK:
	.string	"memcheck"
	.align 32
	.type	MAX_BL_LARGE3, @object
	.size	MAX_BL_LARGE3, 88
MAX_BL_LARGE3:
	.quad	2
	.quad	3
	.quad	5
	.quad	9
	.quad	16
	.quad	32
	.quad	62
	.quad	123
	.quad	245
	.quad	490
	.quad	1000
	.align 32
	.type	MAX_BL_SMALL3, @object
	.size	MAX_BL_SMALL3, 96
MAX_BL_SMALL3:
	.quad	1
	.quad	1
	.quad	2
	.quad	3
	.quad	6
	.quad	12
	.quad	22
	.quad	42
	.quad	82
	.quad	166
	.quad	335
	.quad	700
	.align 32
	.type	MAX_BL_LARGE2, @object
	.size	MAX_BL_LARGE2, 80
MAX_BL_LARGE2:
	.quad	2
	.quad	2
	.quad	5
	.quad	7
	.quad	12
	.quad	22
	.quad	42
	.quad	80
	.quad	157
	.quad	310
	.align 32
	.type	MAX_BL_SMALL2, @object
	.size	MAX_BL_SMALL2, 88
MAX_BL_SMALL2:
	.quad	1
	.quad	1
	.quad	2
	.quad	2
	.quad	4
	.quad	7
	.quad	14
	.quad	27
	.quad	53
	.quad	106
	.quad	212
	.align 32
	.type	gauss_1024_12289, @object
	.size	gauss_1024_12289, 216
gauss_1024_12289:
	.quad	1283868770400643928
	.quad	6416574995475331444
	.quad	4078260278032692663
	.quad	2353523259288686585
	.quad	1227179971273316331
	.quad	575931623374121527
	.quad	242543240509105209
	.quad	91437049221049666
	.quad	30799446349977173
	.quad	9255276791179340
	.quad	2478152334826140
	.quad	590642893610164
	.quad	125206034929641
	.quad	23590435911403
	.quad	3948334035941
	.quad	586753615614
	.quad	77391054539
	.quad	9056793210
	.quad	940121950
	.quad	86539696
	.quad	7062824
	.quad	510971
	.quad	32764
	.quad	1862
	.quad	94
	.quad	4
	.quad	0
	.align 32
	.type	REV10, @object
	.size	REV10, 2048
REV10:
	.value	0
	.value	512
	.value	256
	.value	768
	.value	128
	.value	640
	.value	384
	.value	896
	.value	64
	.value	576
	.value	320
	.value	832
	.value	192
	.value	704
	.value	448
	.value	960
	.value	32
	.value	544
	.value	288
	.value	800
	.value	160
	.value	672
	.value	416
	.value	928
	.value	96
	.value	608
	.value	352
	.value	864
	.value	224
	.value	736
	.value	480
	.value	992
	.value	16
	.value	528
	.value	272
	.value	784
	.value	144
	.value	656
	.value	400
	.value	912
	.value	80
	.value	592
	.value	336
	.value	848
	.value	208
	.value	720
	.value	464
	.value	976
	.value	48
	.value	560
	.value	304
	.value	816
	.value	176
	.value	688
	.value	432
	.value	944
	.value	112
	.value	624
	.value	368
	.value	880
	.value	240
	.value	752
	.value	496
	.value	1008
	.value	8
	.value	520
	.value	264
	.value	776
	.value	136
	.value	648
	.value	392
	.value	904
	.value	72
	.value	584
	.value	328
	.value	840
	.value	200
	.value	712
	.value	456
	.value	968
	.value	40
	.value	552
	.value	296
	.value	808
	.value	168
	.value	680
	.value	424
	.value	936
	.value	104
	.value	616
	.value	360
	.value	872
	.value	232
	.value	744
	.value	488
	.value	1000
	.value	24
	.value	536
	.value	280
	.value	792
	.value	152
	.value	664
	.value	408
	.value	920
	.value	88
	.value	600
	.value	344
	.value	856
	.value	216
	.value	728
	.value	472
	.value	984
	.value	56
	.value	568
	.value	312
	.value	824
	.value	184
	.value	696
	.value	440
	.value	952
	.value	120
	.value	632
	.value	376
	.value	888
	.value	248
	.value	760
	.value	504
	.value	1016
	.value	4
	.value	516
	.value	260
	.value	772
	.value	132
	.value	644
	.value	388
	.value	900
	.value	68
	.value	580
	.value	324
	.value	836
	.value	196
	.value	708
	.value	452
	.value	964
	.value	36
	.value	548
	.value	292
	.value	804
	.value	164
	.value	676
	.value	420
	.value	932
	.value	100
	.value	612
	.value	356
	.value	868
	.value	228
	.value	740
	.value	484
	.value	996
	.value	20
	.value	532
	.value	276
	.value	788
	.value	148
	.value	660
	.value	404
	.value	916
	.value	84
	.value	596
	.value	340
	.value	852
	.value	212
	.value	724
	.value	468
	.value	980
	.value	52
	.value	564
	.value	308
	.value	820
	.value	180
	.value	692
	.value	436
	.value	948
	.value	116
	.value	628
	.value	372
	.value	884
	.value	244
	.value	756
	.value	500
	.value	1012
	.value	12
	.value	524
	.value	268
	.value	780
	.value	140
	.value	652
	.value	396
	.value	908
	.value	76
	.value	588
	.value	332
	.value	844
	.value	204
	.value	716
	.value	460
	.value	972
	.value	44
	.value	556
	.value	300
	.value	812
	.value	172
	.value	684
	.value	428
	.value	940
	.value	108
	.value	620
	.value	364
	.value	876
	.value	236
	.value	748
	.value	492
	.value	1004
	.value	28
	.value	540
	.value	284
	.value	796
	.value	156
	.value	668
	.value	412
	.value	924
	.value	92
	.value	604
	.value	348
	.value	860
	.value	220
	.value	732
	.value	476
	.value	988
	.value	60
	.value	572
	.value	316
	.value	828
	.value	188
	.value	700
	.value	444
	.value	956
	.value	124
	.value	636
	.value	380
	.value	892
	.value	252
	.value	764
	.value	508
	.value	1020
	.value	2
	.value	514
	.value	258
	.value	770
	.value	130
	.value	642
	.value	386
	.value	898
	.value	66
	.value	578
	.value	322
	.value	834
	.value	194
	.value	706
	.value	450
	.value	962
	.value	34
	.value	546
	.value	290
	.value	802
	.value	162
	.value	674
	.value	418
	.value	930
	.value	98
	.value	610
	.value	354
	.value	866
	.value	226
	.value	738
	.value	482
	.value	994
	.value	18
	.value	530
	.value	274
	.value	786
	.value	146
	.value	658
	.value	402
	.value	914
	.value	82
	.value	594
	.value	338
	.value	850
	.value	210
	.value	722
	.value	466
	.value	978
	.value	50
	.value	562
	.value	306
	.value	818
	.value	178
	.value	690
	.value	434
	.value	946
	.value	114
	.value	626
	.value	370
	.value	882
	.value	242
	.value	754
	.value	498
	.value	1010
	.value	10
	.value	522
	.value	266
	.value	778
	.value	138
	.value	650
	.value	394
	.value	906
	.value	74
	.value	586
	.value	330
	.value	842
	.value	202
	.value	714
	.value	458
	.value	970
	.value	42
	.value	554
	.value	298
	.value	810
	.value	170
	.value	682
	.value	426
	.value	938
	.value	106
	.value	618
	.value	362
	.value	874
	.value	234
	.value	746
	.value	490
	.value	1002
	.value	26
	.value	538
	.value	282
	.value	794
	.value	154
	.value	666
	.value	410
	.value	922
	.value	90
	.value	602
	.value	346
	.value	858
	.value	218
	.value	730
	.value	474
	.value	986
	.value	58
	.value	570
	.value	314
	.value	826
	.value	186
	.value	698
	.value	442
	.value	954
	.value	122
	.value	634
	.value	378
	.value	890
	.value	250
	.value	762
	.value	506
	.value	1018
	.value	6
	.value	518
	.value	262
	.value	774
	.value	134
	.value	646
	.value	390
	.value	902
	.value	70
	.value	582
	.value	326
	.value	838
	.value	198
	.value	710
	.value	454
	.value	966
	.value	38
	.value	550
	.value	294
	.value	806
	.value	166
	.value	678
	.value	422
	.value	934
	.value	102
	.value	614
	.value	358
	.value	870
	.value	230
	.value	742
	.value	486
	.value	998
	.value	22
	.value	534
	.value	278
	.value	790
	.value	150
	.value	662
	.value	406
	.value	918
	.value	86
	.value	598
	.value	342
	.value	854
	.value	214
	.value	726
	.value	470
	.value	982
	.value	54
	.value	566
	.value	310
	.value	822
	.value	182
	.value	694
	.value	438
	.value	950
	.value	118
	.value	630
	.value	374
	.value	886
	.value	246
	.value	758
	.value	502
	.value	1014
	.value	14
	.value	526
	.value	270
	.value	782
	.value	142
	.value	654
	.value	398
	.value	910
	.value	78
	.value	590
	.value	334
	.value	846
	.value	206
	.value	718
	.value	462
	.value	974
	.value	46
	.value	558
	.value	302
	.value	814
	.value	174
	.value	686
	.value	430
	.value	942
	.value	110
	.value	622
	.value	366
	.value	878
	.value	238
	.value	750
	.value	494
	.value	1006
	.value	30
	.value	542
	.value	286
	.value	798
	.value	158
	.value	670
	.value	414
	.value	926
	.value	94
	.value	606
	.value	350
	.value	862
	.value	222
	.value	734
	.value	478
	.value	990
	.value	62
	.value	574
	.value	318
	.value	830
	.value	190
	.value	702
	.value	446
	.value	958
	.value	126
	.value	638
	.value	382
	.value	894
	.value	254
	.value	766
	.value	510
	.value	1022
	.value	1
	.value	513
	.value	257
	.value	769
	.value	129
	.value	641
	.value	385
	.value	897
	.value	65
	.value	577
	.value	321
	.value	833
	.value	193
	.value	705
	.value	449
	.value	961
	.value	33
	.value	545
	.value	289
	.value	801
	.value	161
	.value	673
	.value	417
	.value	929
	.value	97
	.value	609
	.value	353
	.value	865
	.value	225
	.value	737
	.value	481
	.value	993
	.value	17
	.value	529
	.value	273
	.value	785
	.value	145
	.value	657
	.value	401
	.value	913
	.value	81
	.value	593
	.value	337
	.value	849
	.value	209
	.value	721
	.value	465
	.value	977
	.value	49
	.value	561
	.value	305
	.value	817
	.value	177
	.value	689
	.value	433
	.value	945
	.value	113
	.value	625
	.value	369
	.value	881
	.value	241
	.value	753
	.value	497
	.value	1009
	.value	9
	.value	521
	.value	265
	.value	777
	.value	137
	.value	649
	.value	393
	.value	905
	.value	73
	.value	585
	.value	329
	.value	841
	.value	201
	.value	713
	.value	457
	.value	969
	.value	41
	.value	553
	.value	297
	.value	809
	.value	169
	.value	681
	.value	425
	.value	937
	.value	105
	.value	617
	.value	361
	.value	873
	.value	233
	.value	745
	.value	489
	.value	1001
	.value	25
	.value	537
	.value	281
	.value	793
	.value	153
	.value	665
	.value	409
	.value	921
	.value	89
	.value	601
	.value	345
	.value	857
	.value	217
	.value	729
	.value	473
	.value	985
	.value	57
	.value	569
	.value	313
	.value	825
	.value	185
	.value	697
	.value	441
	.value	953
	.value	121
	.value	633
	.value	377
	.value	889
	.value	249
	.value	761
	.value	505
	.value	1017
	.value	5
	.value	517
	.value	261
	.value	773
	.value	133
	.value	645
	.value	389
	.value	901
	.value	69
	.value	581
	.value	325
	.value	837
	.value	197
	.value	709
	.value	453
	.value	965
	.value	37
	.value	549
	.value	293
	.value	805
	.value	165
	.value	677
	.value	421
	.value	933
	.value	101
	.value	613
	.value	357
	.value	869
	.value	229
	.value	741
	.value	485
	.value	997
	.value	21
	.value	533
	.value	277
	.value	789
	.value	149
	.value	661
	.value	405
	.value	917
	.value	85
	.value	597
	.value	341
	.value	853
	.value	213
	.value	725
	.value	469
	.value	981
	.value	53
	.value	565
	.value	309
	.value	821
	.value	181
	.value	693
	.value	437
	.value	949
	.value	117
	.value	629
	.value	373
	.value	885
	.value	245
	.value	757
	.value	501
	.value	1013
	.value	13
	.value	525
	.value	269
	.value	781
	.value	141
	.value	653
	.value	397
	.value	909
	.value	77
	.value	589
	.value	333
	.value	845
	.value	205
	.value	717
	.value	461
	.value	973
	.value	45
	.value	557
	.value	301
	.value	813
	.value	173
	.value	685
	.value	429
	.value	941
	.value	109
	.value	621
	.value	365
	.value	877
	.value	237
	.value	749
	.value	493
	.value	1005
	.value	29
	.value	541
	.value	285
	.value	797
	.value	157
	.value	669
	.value	413
	.value	925
	.value	93
	.value	605
	.value	349
	.value	861
	.value	221
	.value	733
	.value	477
	.value	989
	.value	61
	.value	573
	.value	317
	.value	829
	.value	189
	.value	701
	.value	445
	.value	957
	.value	125
	.value	637
	.value	381
	.value	893
	.value	253
	.value	765
	.value	509
	.value	1021
	.value	3
	.value	515
	.value	259
	.value	771
	.value	131
	.value	643
	.value	387
	.value	899
	.value	67
	.value	579
	.value	323
	.value	835
	.value	195
	.value	707
	.value	451
	.value	963
	.value	35
	.value	547
	.value	291
	.value	803
	.value	163
	.value	675
	.value	419
	.value	931
	.value	99
	.value	611
	.value	355
	.value	867
	.value	227
	.value	739
	.value	483
	.value	995
	.value	19
	.value	531
	.value	275
	.value	787
	.value	147
	.value	659
	.value	403
	.value	915
	.value	83
	.value	595
	.value	339
	.value	851
	.value	211
	.value	723
	.value	467
	.value	979
	.value	51
	.value	563
	.value	307
	.value	819
	.value	179
	.value	691
	.value	435
	.value	947
	.value	115
	.value	627
	.value	371
	.value	883
	.value	243
	.value	755
	.value	499
	.value	1011
	.value	11
	.value	523
	.value	267
	.value	779
	.value	139
	.value	651
	.value	395
	.value	907
	.value	75
	.value	587
	.value	331
	.value	843
	.value	203
	.value	715
	.value	459
	.value	971
	.value	43
	.value	555
	.value	299
	.value	811
	.value	171
	.value	683
	.value	427
	.value	939
	.value	107
	.value	619
	.value	363
	.value	875
	.value	235
	.value	747
	.value	491
	.value	1003
	.value	27
	.value	539
	.value	283
	.value	795
	.value	155
	.value	667
	.value	411
	.value	923
	.value	91
	.value	603
	.value	347
	.value	859
	.value	219
	.value	731
	.value	475
	.value	987
	.value	59
	.value	571
	.value	315
	.value	827
	.value	187
	.value	699
	.value	443
	.value	955
	.value	123
	.value	635
	.value	379
	.value	891
	.value	251
	.value	763
	.value	507
	.value	1019
	.value	7
	.value	519
	.value	263
	.value	775
	.value	135
	.value	647
	.value	391
	.value	903
	.value	71
	.value	583
	.value	327
	.value	839
	.value	199
	.value	711
	.value	455
	.value	967
	.value	39
	.value	551
	.value	295
	.value	807
	.value	167
	.value	679
	.value	423
	.value	935
	.value	103
	.value	615
	.value	359
	.value	871
	.value	231
	.value	743
	.value	487
	.value	999
	.value	23
	.value	535
	.value	279
	.value	791
	.value	151
	.value	663
	.value	407
	.value	919
	.value	87
	.value	599
	.value	343
	.value	855
	.value	215
	.value	727
	.value	471
	.value	983
	.value	55
	.value	567
	.value	311
	.value	823
	.value	183
	.value	695
	.value	439
	.value	951
	.value	119
	.value	631
	.value	375
	.value	887
	.value	247
	.value	759
	.value	503
	.value	1015
	.value	15
	.value	527
	.value	271
	.value	783
	.value	143
	.value	655
	.value	399
	.value	911
	.value	79
	.value	591
	.value	335
	.value	847
	.value	207
	.value	719
	.value	463
	.value	975
	.value	47
	.value	559
	.value	303
	.value	815
	.value	175
	.value	687
	.value	431
	.value	943
	.value	111
	.value	623
	.value	367
	.value	879
	.value	239
	.value	751
	.value	495
	.value	1007
	.value	31
	.value	543
	.value	287
	.value	799
	.value	159
	.value	671
	.value	415
	.value	927
	.value	95
	.value	607
	.value	351
	.value	863
	.value	223
	.value	735
	.value	479
	.value	991
	.value	63
	.value	575
	.value	319
	.value	831
	.value	191
	.value	703
	.value	447
	.value	959
	.value	127
	.value	639
	.value	383
	.value	895
	.value	255
	.value	767
	.value	511
	.value	1023
	.align 32
	.type	PRIMES3, @object
	.size	PRIMES3, 13212
PRIMES3:
# p:
	.long	2147355649
# g:
	.long	1907584673
# s:
	.long	127999
# p:
	.long	2147346433
# g:
	.long	1119654270
# s:
	.long	238827065
# p:
	.long	2147309569
# g:
	.long	686923925
# s:
	.long	434763914
# p:
	.long	2147281921
# g:
	.long	658779219
# s:
	.long	742235228
# p:
	.long	2147235841
# g:
	.long	1567830083
# s:
	.long	1964117354
# p:
	.long	2147217409
# g:
	.long	273379403
# s:
	.long	890663385
# p:
	.long	2147079169
# g:
	.long	884642355
# s:
	.long	1325537405
# p:
	.long	2147051521
# g:
	.long	2049970231
# s:
	.long	846062571
# p:
	.long	2146959361
# g:
	.long	565744180
# s:
	.long	131144629
# p:
	.long	2146885633
# g:
	.long	328643105
# s:
	.long	798140427
# p:
	.long	2146775041
# g:
	.long	797860046
# s:
	.long	68264718
# p:
	.long	2146756609
# g:
	.long	1681396397
# s:
	.long	459938921
# p:
	.long	2146738177
# g:
	.long	1162041962
# s:
	.long	196967660
# p:
	.long	2146646017
# g:
	.long	726398168
# s:
	.long	672200588
# p:
	.long	2146599937
# g:
	.long	1057553451
# s:
	.long	1817004162
# p:
	.long	2146572289
# g:
	.long	637715109
# s:
	.long	269732777
# p:
	.long	2146544641
# g:
	.long	444752022
# s:
	.long	1328058681
# p:
	.long	2146507777
# g:
	.long	490896612
# s:
	.long	838252098
# p:
	.long	2146406401
# g:
	.long	1004568183
# s:
	.long	869184085
# p:
	.long	2146378753
# g:
	.long	2116137511
# s:
	.long	721799116
# p:
	.long	2146203649
# g:
	.long	1543684282
# s:
	.long	978176226
# p:
	.long	2146093057
# g:
	.long	523004126
# s:
	.long	855356548
# p:
	.long	2146019329
# g:
	.long	1312595682
# s:
	.long	1137142260
# p:
	.long	2145964033
# g:
	.long	1055750942
# s:
	.long	1278992850
# p:
	.long	2145954817
# g:
	.long	980703732
# s:
	.long	927625814
# p:
	.long	2145871873
# g:
	.long	477241546
# s:
	.long	1603369271
# p:
	.long	2145862657
# g:
	.long	1765281746
# s:
	.long	679564124
# p:
	.long	2145825793
# g:
	.long	387786552
# s:
	.long	1729122170
# p:
	.long	2145816577
# g:
	.long	615239004
# s:
	.long	743619127
# p:
	.long	2145807361
# g:
	.long	2102013968
# s:
	.long	37313814
# p:
	.long	2145742849
# g:
	.long	1629506207
# s:
	.long	568956216
# p:
	.long	2145733633
# g:
	.long	563501879
# s:
	.long	111479038
# p:
	.long	2145687553
# g:
	.long	892398826
# s:
	.long	250505739
# p:
	.long	2145623041
# g:
	.long	1996279291
# s:
	.long	2110452644
# p:
	.long	2145595393
# g:
	.long	838028303
# s:
	.long	1131121608
# p:
	.long	2145549313
# g:
	.long	272838886
# s:
	.long	1679720531
# p:
	.long	2145466369
# g:
	.long	1300958526
# s:
	.long	2042057674
# p:
	.long	2145401857
# g:
	.long	1855241957
# s:
	.long	1327706585
# p:
	.long	2145355777
# g:
	.long	606247509
# s:
	.long	344551658
# p:
	.long	2145318913
# g:
	.long	1261900593
# s:
	.long	2039291600
# p:
	.long	2145300481
# g:
	.long	524012313
# s:
	.long	1585881571
# p:
	.long	2145282049
# g:
	.long	2052569355
# s:
	.long	1731203241
# p:
	.long	2145235969
# g:
	.long	750612415
# s:
	.long	291051819
# p:
	.long	2145180673
# g:
	.long	1045304879
# s:
	.long	1926120629
# p:
	.long	2145079297
# g:
	.long	746612925
# s:
	.long	1814267874
# p:
	.long	2145033217
# g:
	.long	219858114
# s:
	.long	1271760214
# p:
	.long	2144894977
# g:
	.long	2063940505
# s:
	.long	1427422832
# p:
	.long	2144793601
# g:
	.long	621444430
# s:
	.long	1745703946
# p:
	.long	2144775169
# g:
	.long	368284644
# s:
	.long	636136287
# p:
	.long	2144729089
# g:
	.long	1812203446
# s:
	.long	1758638194
# p:
	.long	2144535553
# g:
	.long	1961223696
# s:
	.long	306682124
# p:
	.long	2144388097
# g:
	.long	1037120764
# s:
	.long	2013410729
# p:
	.long	2144120833
# g:
	.long	1830027094
# s:
	.long	191570151
# p:
	.long	2144065537
# g:
	.long	1150224848
# s:
	.long	1982054047
# p:
	.long	2144028673
# g:
	.long	526645070
# s:
	.long	1328582209
# p:
	.long	2144010241
# g:
	.long	547647546
# s:
	.long	364140489
# p:
	.long	2143918081
# g:
	.long	1991270404
# s:
	.long	1287353762
# p:
	.long	2143899649
# g:
	.long	1506542299
# s:
	.long	1133531206
# p:
	.long	2143742977
# g:
	.long	1100659112
# s:
	.long	128559048
# p:
	.long	2143641601
# g:
	.long	303982083
# s:
	.long	1015351675
# p:
	.long	2143567873
# g:
	.long	956078567
# s:
	.long	622811492
# p:
	.long	2143531009
# g:
	.long	2131729286
# s:
	.long	1037132561
# p:
	.long	2143383553
# g:
	.long	1703554875
# s:
	.long	696962587
# p:
	.long	2143097857
# g:
	.long	1742678335
# s:
	.long	1434386276
# p:
	.long	2143051777
# g:
	.long	736013558
# s:
	.long	842493115
# p:
	.long	2142996481
# g:
	.long	170463805
# s:
	.long	1342212204
# p:
	.long	2142885889
# g:
	.long	1593802719
# s:
	.long	827529846
# p:
	.long	2142830593
# g:
	.long	2052409064
# s:
	.long	1579779913
# p:
	.long	2142498817
# g:
	.long	1230323290
# s:
	.long	116496463
# p:
	.long	2142471169
# g:
	.long	1564962005
# s:
	.long	726962536
# p:
	.long	2142379009
# g:
	.long	1340386447
# s:
	.long	664338695
# p:
	.long	2142351361
# g:
	.long	1730274428
# s:
	.long	1674269670
# p:
	.long	2142323713
# g:
	.long	575396590
# s:
	.long	169223629
# p:
	.long	2142314497
# g:
	.long	137874423
# s:
	.long	2007195587
# p:
	.long	2142277633
# g:
	.long	338504619
# s:
	.long	1206857572
# p:
	.long	2142074881
# g:
	.long	375696650
# s:
	.long	521693513
# p:
	.long	2142010369
# g:
	.long	345508754
# s:
	.long	1086992100
# p:
	.long	2141918209
# g:
	.long	1672240502
# s:
	.long	1303567172
# p:
	.long	2141890561
# g:
	.long	1925832177
# s:
	.long	270534719
# p:
	.long	2141733889
# g:
	.long	1787869362
# s:
	.long	1011129521
# p:
	.long	2141669377
# g:
	.long	1611042844
# s:
	.long	260695342
# p:
	.long	2141660161
# g:
	.long	37349518
# s:
	.long	1618304444
# p:
	.long	2141475841
# g:
	.long	1862580814
# s:
	.long	419375204
# p:
	.long	2141291521
# g:
	.long	1629968367
# s:
	.long	783386302
# p:
	.long	2141273089
# g:
	.long	717657965
# s:
	.long	1631330745
# p:
	.long	2141254657
# g:
	.long	607578270
# s:
	.long	156612440
# p:
	.long	2141088769
# g:
	.long	120011567
# s:
	.long	2128674942
# p:
	.long	2140766209
# g:
	.long	805715602
# s:
	.long	1316927701
# p:
	.long	2140701697
# g:
	.long	2073407710
# s:
	.long	97928786
# p:
	.long	2140664833
# g:
	.long	896106101
# s:
	.long	1872069897
# p:
	.long	2140627969
# g:
	.long	853269810
# s:
	.long	278518586
# p:
	.long	2140535809
# g:
	.long	1704476745
# s:
	.long	1793725263
# p:
	.long	2140480513
# g:
	.long	1958290120
# s:
	.long	2035402415
# p:
	.long	2140351489
# g:
	.long	1832338900
# s:
	.long	255551052
# p:
	.long	2140323841
# g:
	.long	284841
# s:
	.long	449941435
# p:
	.long	2140250113
# g:
	.long	1689077802
# s:
	.long	1170560655
# p:
	.long	2140185601
# g:
	.long	1500630554
# s:
	.long	1530494340
# p:
	.long	2140047361
# g:
	.long	2001630759
# s:
	.long	716043965
# p:
	.long	2139964417
# g:
	.long	487209668
# s:
	.long	725418232
# p:
	.long	2139927553
# g:
	.long	1779503780
# s:
	.long	981791996
# p:
	.long	2139872257
# g:
	.long	619928202
# s:
	.long	1747637532
# p:
	.long	2139826177
# g:
	.long	9730271
# s:
	.long	766984898
# p:
	.long	2139789313
# g:
	.long	2051051563
# s:
	.long	1550509132
# p:
	.long	2139770881
# g:
	.long	86669459
# s:
	.long	129570768
# p:
	.long	2139641857
# g:
	.long	1008036735
# s:
	.long	1251171423
# p:
	.long	2139614209
# g:
	.long	161221279
# s:
	.long	482289085
# p:
	.long	2139568129
# g:
	.long	1925375555
# s:
	.long	583773381
# p:
	.long	2139549697
# g:
	.long	1356689273
# s:
	.long	1036653104
# p:
	.long	2139475969
# g:
	.long	1523451362
# s:
	.long	2109704897
# p:
	.long	2139466753
# g:
	.long	1156508181
# s:
	.long	547438814
# p:
	.long	2139383809
# g:
	.long	1063000644
# s:
	.long	1817587509
# p:
	.long	2139356161
# g:
	.long	715623372
# s:
	.long	860535110
# p:
	.long	2139310081
# g:
	.long	1532332665
# s:
	.long	508486789
# p:
	.long	2139144193
# g:
	.long	2052943984
# s:
	.long	1865377749
# p:
	.long	2139033601
# g:
	.long	593737051
# s:
	.long	1629672479
# p:
	.long	2138969089
# g:
	.long	1889797232
# s:
	.long	2093323866
# p:
	.long	2138950657
# g:
	.long	1183692055
# s:
	.long	847318567
# p:
	.long	2138913793
# g:
	.long	34200790
# s:
	.long	677604160
# p:
	.long	2138904577
# g:
	.long	1921535945
# s:
	.long	655034452
# p:
	.long	2138775553
# g:
	.long	740680156
# s:
	.long	129574017
# p:
	.long	2138757121
# g:
	.long	1704697393
# s:
	.long	899844774
# p:
	.long	2138738689
# g:
	.long	1150723238
# s:
	.long	1675923365
# p:
	.long	2138729473
# g:
	.long	928942702
# s:
	.long	2116217870
# p:
	.long	2138600449
# g:
	.long	1436894261
# s:
	.long	552821155
# p:
	.long	2138591233
# g:
	.long	1847080957
# s:
	.long	70514295
# p:
	.long	2138572801
# g:
	.long	215800816
# s:
	.long	1208937888
# p:
	.long	2138545153
# g:
	.long	2089704751
# s:
	.long	771490099
# p:
	.long	2138526721
# g:
	.long	108149434
# s:
	.long	1149716044
# p:
	.long	2138351617
# g:
	.long	234459296
# s:
	.long	549823968
# p:
	.long	2138268673
# g:
	.long	1314810865
# s:
	.long	1068328972
# p:
	.long	2138250241
# g:
	.long	288759988
# s:
	.long	1091918221
# p:
	.long	2138047489
# g:
	.long	744206681
# s:
	.long	772620203
# p:
	.long	2138029057
# g:
	.long	1994412079
# s:
	.long	1145999991
# p:
	.long	2137936897
# g:
	.long	272309876
# s:
	.long	1975847036
# p:
	.long	2137881601
# g:
	.long	517202569
# s:
	.long	166472690
# p:
	.long	2137853953
# g:
	.long	326905402
# s:
	.long	1550172032
# p:
	.long	2137817089
# g:
	.long	1370024640
# s:
	.long	1718646636
# p:
	.long	2137724929
# g:
	.long	1757440855
# s:
	.long	260919526
# p:
	.long	2137697281
# g:
	.long	66157743
# s:
	.long	1961453816
# p:
	.long	2137476097
# g:
	.long	1503144994
# s:
	.long	1069579313
# p:
	.long	2137439233
# g:
	.long	204995582
# s:
	.long	616433474
# p:
	.long	2137374721
# g:
	.long	109691435
# s:
	.long	1731802121
# p:
	.long	2137291777
# g:
	.long	1304560260
# s:
	.long	1368857709
# p:
	.long	2137218049
# g:
	.long	1835540823
# s:
	.long	781730487
# p:
	.long	2137171969
# g:
	.long	688131371
# s:
	.long	1830121465
# p:
	.long	2137116673
# g:
	.long	483700571
# s:
	.long	402752235
# p:
	.long	2137098241
# g:
	.long	1148142201
# s:
	.long	1237673888
# p:
	.long	2137052161
# g:
	.long	700037444
# s:
	.long	1899372504
# p:
	.long	2136987649
# g:
	.long	1892544381
# s:
	.long	1891069147
# p:
	.long	2136969217
# g:
	.long	1514825022
# s:
	.long	215171708
# p:
	.long	2136895489
# g:
	.long	2060695429
# s:
	.long	803173156
# p:
	.long	2136701953
# g:
	.long	353300507
# s:
	.long	122007417
# p:
	.long	2136572929
# g:
	.long	448696706
# s:
	.long	1467687155
# p:
	.long	2136563713
# g:
	.long	1650042973
# s:
	.long	287240546
# p:
	.long	2136526849
# g:
	.long	2108841258
# s:
	.long	1757336405
# p:
	.long	2136508417
# g:
	.long	979485959
# s:
	.long	614016571
# p:
	.long	2136471553
# g:
	.long	1935757354
# s:
	.long	967646595
# p:
	.long	2136388609
# g:
	.long	524776394
# s:
	.long	2043074090
# p:
	.long	2136278017
# g:
	.long	1378816565
# s:
	.long	711865033
# p:
	.long	2136241153
# g:
	.long	1726812175
# s:
	.long	2010754874
# p:
	.long	2136204289
# g:
	.long	1910346112
# s:
	.long	210602632
# p:
	.long	2136176641
# g:
	.long	1552920156
# s:
	.long	975521921
# p:
	.long	2136158209
# g:
	.long	1764928154
# s:
	.long	1532477095
# p:
	.long	2136130561
# g:
	.long	872401851
# s:
	.long	1878748851
# p:
	.long	2136112129
# g:
	.long	921927469
# s:
	.long	217887869
# p:
	.long	2136056833
# g:
	.long	1788139322
# s:
	.long	1138889272
# p:
	.long	2135964673
# g:
	.long	1293040418
# s:
	.long	267847252
# p:
	.long	2135955457
# g:
	.long	1916171409
# s:
	.long	125572921
# p:
	.long	2135854081
# g:
	.long	424380193
# s:
	.long	1631813888
# p:
	.long	2135725057
# g:
	.long	1732856191
# s:
	.long	1403713142
# p:
	.long	2135697409
# g:
	.long	2035341665
# s:
	.long	832575410
# p:
	.long	2135688193
# g:
	.long	807195619
# s:
	.long	1195661116
# p:
	.long	2135632897
# g:
	.long	1868899285
# s:
	.long	1227232653
# p:
	.long	2135605249
# g:
	.long	1213724936
# s:
	.long	1068956556
# p:
	.long	2135531521
# g:
	.long	716205449
# s:
	.long	1593070178
# p:
	.long	2135494657
# g:
	.long	1050440283
# s:
	.long	450935982
# p:
	.long	2135411713
# g:
	.long	2080596947
# s:
	.long	674432031
# p:
	.long	2135301121
# g:
	.long	1721640287
# s:
	.long	44999948
# p:
	.long	2135190529
# g:
	.long	1940988200
# s:
	.long	376151947
# p:
	.long	2135162881
# g:
	.long	888820988
# s:
	.long	595428850
# p:
	.long	2135144449
# g:
	.long	385014974
# s:
	.long	320196842
# p:
	.long	2135126017
# g:
	.long	1634206201
# s:
	.long	1926181209
# p:
	.long	2135116801
# g:
	.long	1819468874
# s:
	.long	1988454776
# p:
	.long	2134960129
# g:
	.long	611397038
# s:
	.long	1340009145
# p:
	.long	2134914049
# g:
	.long	857397212
# s:
	.long	2116330065
# p:
	.long	2134904833
# g:
	.long	165089945
# s:
	.long	1631323784
# p:
	.long	2134794241
# g:
	.long	163628146
# s:
	.long	9474792
# p:
	.long	2134711297
# g:
	.long	929773057
# s:
	.long	149381621
# p:
	.long	2134674433
# g:
	.long	515141169
# s:
	.long	1000290164
# p:
	.long	2134536193
# g:
	.long	121684729
# s:
	.long	1805387247
# p:
	.long	2134517761
# g:
	.long	661564842
# s:
	.long	1217793394
# p:
	.long	2134499329
# g:
	.long	1417886623
# s:
	.long	949935639
# p:
	.long	2134480897
# g:
	.long	830814907
# s:
	.long	128368771
# p:
	.long	2134453249
# g:
	.long	1927952828
# s:
	.long	649634650
# p:
	.long	2134444033
# g:
	.long	1948267663
# s:
	.long	1327484672
# p:
	.long	2134407169
# g:
	.long	237456857
# s:
	.long	956816735
# p:
	.long	2134315009
# g:
	.long	882873992
# s:
	.long	1912006404
# p:
	.long	2134305793
# g:
	.long	1333192039
# s:
	.long	972748334
# p:
	.long	2134287361
# g:
	.long	226944743
# s:
	.long	1000012341
# p:
	.long	2134250497
# g:
	.long	534913939
# s:
	.long	741716282
# p:
	.long	2134241281
# g:
	.long	1374655302
# s:
	.long	367574877
# p:
	.long	2134213633
# g:
	.long	1652299837
# s:
	.long	2121033677
# p:
	.long	2134204417
# g:
	.long	107911934
# s:
	.long	269871386
# p:
	.long	2134176769
# g:
	.long	603238808
# s:
	.long	2054029050
# p:
	.long	2133992449
# g:
	.long	489450148
# s:
	.long	643076938
# p:
	.long	2133964801
# g:
	.long	1256310671
# s:
	.long	2074294754
# p:
	.long	2133900289
# g:
	.long	1793967703
# s:
	.long	442259187
# p:
	.long	2133835777
# g:
	.long	2042547815
# s:
	.long	1852529997
# p:
	.long	2133752833
# g:
	.long	596460567
# s:
	.long	695196571
# p:
	.long	2133688321
# g:
	.long	210710179
# s:
	.long	1479575872
# p:
	.long	2133660673
# g:
	.long	1658242914
# s:
	.long	1744196998
# p:
	.long	2133577729
# g:
	.long	1461036854
# s:
	.long	1601558479
# p:
	.long	2133559297
# g:
	.long	690520517
# s:
	.long	1580659654
# p:
	.long	2133504001
# g:
	.long	1286814238
# s:
	.long	136008142
# p:
	.long	2133439489
# g:
	.long	1479334858
# s:
	.long	263212761
# p:
	.long	2133374977
# g:
	.long	2028146004
# s:
	.long	1332709859
# p:
	.long	2133365761
# g:
	.long	1595872653
# s:
	.long	1282045838
# p:
	.long	2133255169
# g:
	.long	1563288297
# s:
	.long	547054648
# p:
	.long	2133052417
# g:
	.long	1130313455
# s:
	.long	1315904536
# p:
	.long	2133043201
# g:
	.long	17794380
# s:
	.long	799584852
# p:
	.long	2132997121
# g:
	.long	983827892
# s:
	.long	1395685919
# p:
	.long	2132969473
# g:
	.long	654615808
# s:
	.long	1695573709
# p:
	.long	2132886529
# g:
	.long	1700716093
# s:
	.long	415207928
# p:
	.long	2132822017
# g:
	.long	1389120570
# s:
	.long	1340462675
# p:
	.long	2132794369
# g:
	.long	1856852777
# s:
	.long	232467820
# p:
	.long	2132785153
# g:
	.long	1310029530
# s:
	.long	510709259
# p:
	.long	2132766721
# g:
	.long	1269394360
# s:
	.long	903700882
# p:
	.long	2132739073
# g:
	.long	2042057984
# s:
	.long	978026259
# p:
	.long	2132720641
# g:
	.long	661077235
# s:
	.long	688687639
# p:
	.long	2132563969
# g:
	.long	3901313
# s:
	.long	552672747
# p:
	.long	2132324353
# g:
	.long	294149229
# s:
	.long	347751416
# p:
	.long	2132315137
# g:
	.long	859533289
# s:
	.long	1115265685
# p:
	.long	2132176897
# g:
	.long	646284164
# s:
	.long	275644120
# p:
	.long	2132140033
# g:
	.long	1450837094
# s:
	.long	2047926326
# p:
	.long	2132075521
# g:
	.long	310697528
# s:
	.long	451970349
# p:
	.long	2132047873
# g:
	.long	1878891574
# s:
	.long	2095437072
# p:
	.long	2131983361
# g:
	.long	171412078
# s:
	.long	1562284026
# p:
	.long	2131946497
# g:
	.long	1571574972
# s:
	.long	384891649
# p:
	.long	2131918849
# g:
	.long	477116202
# s:
	.long	1593574771
# p:
	.long	2131900417
# g:
	.long	1842095959
# s:
	.long	240622872
# p:
	.long	2131568641
# g:
	.long	1569047303
# s:
	.long	1367453540
# p:
	.long	2131550209
# g:
	.long	2085849459
# s:
	.long	1458239233
# p:
	.long	2131540993
# g:
	.long	990400618
# s:
	.long	1239129380
# p:
	.long	2131448833
# g:
	.long	1370843430
# s:
	.long	1425757940
# p:
	.long	2131411969
# g:
	.long	423719575
# s:
	.long	1572171440
# p:
	.long	2131347457
# g:
	.long	588685468
# s:
	.long	1221943275
# p:
	.long	2131292161
# g:
	.long	348295861
# s:
	.long	877480103
# p:
	.long	2131163137
# g:
	.long	1871016570
# s:
	.long	2122747526
# p:
	.long	2131117057
# g:
	.long	2028584533
# s:
	.long	2065792624
# p:
	.long	2131107841
# g:
	.long	238643344
# s:
	.long	1448167417
# p:
	.long	2131043329
# g:
	.long	1643249055
# s:
	.long	1518017167
# p:
	.long	2131015681
# g:
	.long	1003051629
# s:
	.long	1541618242
# p:
	.long	2130951169
# g:
	.long	1230336370
# s:
	.long	73611200
# p:
	.long	2130932737
# g:
	.long	1511412998
# s:
	.long	1909573845
# p:
	.long	2130849793
# g:
	.long	658134188
# s:
	.long	1406985963
# p:
	.long	2130665473
# g:
	.long	1977528636
# s:
	.long	2048939567
# p:
	.long	2130610177
# g:
	.long	1821604524
# s:
	.long	1261328017
# p:
	.long	2130600961
# g:
	.long	1216473417
# s:
	.long	767655885
# p:
	.long	2130508801
# g:
	.long	1462050216
# s:
	.long	931908709
# p:
	.long	2130444289
# g:
	.long	755349933
# s:
	.long	1991265260
# p:
	.long	2130416641
# g:
	.long	1528414056
# s:
	.long	970812565
# p:
	.long	2130388993
# g:
	.long	1022199250
# s:
	.long	1012276299
# p:
	.long	2130352129
# g:
	.long	1521132510
# s:
	.long	1400182332
# p:
	.long	2130324481
# g:
	.long	135966643
# s:
	.long	838305637
# p:
	.long	2130250753
# g:
	.long	941329364
# s:
	.long	1514591211
# p:
	.long	2130241537
# g:
	.long	589905453
# s:
	.long	179053323
# p:
	.long	2130213889
# g:
	.long	1854495452
# s:
	.long	956180300
# p:
	.long	2130094081
# g:
	.long	1750651466
# s:
	.long	2094666665
# p:
	.long	2130001921
# g:
	.long	1098497016
# s:
	.long	1654955321
# p:
	.long	2129918977
# g:
	.long	206718212
# s:
	.long	97483314
# p:
	.long	2129771521
# g:
	.long	26961201
# s:
	.long	433714500
# p:
	.long	2129725441
# g:
	.long	1413406895
# s:
	.long	2109024360
# p:
	.long	2129688577
# g:
	.long	1932573320
# s:
	.long	714829474
# p:
	.long	2129614849
# g:
	.long	1999323482
# s:
	.long	712368041
# p:
	.long	2129568769
# g:
	.long	72538732
# s:
	.long	393765733
# p:
	.long	2129541121
# g:
	.long	1742940308
# s:
	.long	173410485
# p:
	.long	2129495041
# g:
	.long	153078202
# s:
	.long	1405770765
# p:
	.long	2129375233
# g:
	.long	1732777594
# s:
	.long	1032530779
# p:
	.long	2129218561
# g:
	.long	935719199
# s:
	.long	105867132
# p:
	.long	2129172481
# g:
	.long	1238333105
# s:
	.long	647735776
# p:
	.long	2129034241
# g:
	.long	1765327809
# s:
	.long	404653711
# p:
	.long	2129015809
# g:
	.long	222810172
# s:
	.long	1332430862
# p:
	.long	2128988161
# g:
	.long	976739856
# s:
	.long	25247131
# p:
	.long	2128914433
# g:
	.long	933870240
# s:
	.long	559620551
# p:
	.long	2128896001
# g:
	.long	275493829
# s:
	.long	1528658681
# p:
	.long	2128868353
# g:
	.long	722377097
# s:
	.long	1437791192
# p:
	.long	2128766977
# g:
	.long	1720465302
# s:
	.long	2112749490
# p:
	.long	2128720897
# g:
	.long	13746971
# s:
	.long	478127071
# p:
	.long	2128453633
# g:
	.long	838096637
# s:
	.long	360272158
# p:
	.long	2128416769
# g:
	.long	931445424
# s:
	.long	1357692739
# p:
	.long	2128260097
# g:
	.long	1662649598
# s:
	.long	158793698
# p:
	.long	2128186369
# g:
	.long	1686384587
# s:
	.long	1546482664
# p:
	.long	2128066561
# g:
	.long	1128711440
# s:
	.long	1951812268
# p:
	.long	2127983617
# g:
	.long	786667149
# s:
	.long	1749830005
# p:
	.long	2127955969
# g:
	.long	657684064
# s:
	.long	281120976
# p:
	.long	2127891457
# g:
	.long	470752303
# s:
	.long	1941003532
# p:
	.long	2127753217
# g:
	.long	1661057493
# s:
	.long	2090293351
# p:
	.long	2127661057
# g:
	.long	1244946947
# s:
	.long	442154840
# p:
	.long	2127495169
# g:
	.long	367174286
# s:
	.long	1899824820
# p:
	.long	2127449089
# g:
	.long	257882843
# s:
	.long	607291576
# p:
	.long	2127375361
# g:
	.long	676338950
# s:
	.long	1298525230
# p:
	.long	2127356929
# g:
	.long	637606045
# s:
	.long	445460533
# p:
	.long	2127347713
# g:
	.long	1290893211
# s:
	.long	949440208
# p:
	.long	2127310849
# g:
	.long	357552868
# s:
	.long	1596467545
# p:
	.long	2127292417
# g:
	.long	2007647852
# s:
	.long	854505385
# p:
	.long	2127283201
# g:
	.long	229595655
# s:
	.long	1409593307
# p:
	.long	2127144961
# g:
	.long	273325853
# s:
	.long	731172237
# p:
	.long	2127015937
# g:
	.long	1377237985
# s:
	.long	299898562
# p:
	.long	2126988289
# g:
	.long	748283558
# s:
	.long	1593860958
# p:
	.long	2126914561
# g:
	.long	151281579
# s:
	.long	1855468975
# p:
	.long	2126638081
# g:
	.long	636779183
# s:
	.long	602726442
# p:
	.long	2126499841
# g:
	.long	670945998
# s:
	.long	2014619820
# p:
	.long	2126407681
# g:
	.long	1319083782
# s:
	.long	1629953178
# p:
	.long	2126333953
# g:
	.long	169494661
# s:
	.long	1731613229
# p:
	.long	2126186497
# g:
	.long	1702079063
# s:
	.long	156524010
# p:
	.long	2126158849
# g:
	.long	2030878693
# s:
	.long	403292948
# p:
	.long	2126149633
# g:
	.long	916551862
# s:
	.long	903121548
# p:
	.long	2125873153
# g:
	.long	482945063
# s:
	.long	1205699132
# p:
	.long	2125827073
# g:
	.long	288625174
# s:
	.long	1118059614
# p:
	.long	2125790209
# g:
	.long	1456637447
# s:
	.long	305926396
# p:
	.long	2125725697
# g:
	.long	1973950906
# s:
	.long	356489483
# p:
	.long	2125670401
# g:
	.long	1393422316
# s:
	.long	744757640
# p:
	.long	2125633537
# g:
	.long	1168921785
# s:
	.long	466700071
# p:
	.long	2125624321
# g:
	.long	1391187139
# s:
	.long	87622116
# p:
	.long	2125532161
# g:
	.long	1514365376
# s:
	.long	749366762
# p:
	.long	2125440001
# g:
	.long	127455195
# s:
	.long	1761663344
# p:
	.long	2125375489
# g:
	.long	1399056054
# s:
	.long	850243839
# p:
	.long	2125255681
# g:
	.long	1207803895
# s:
	.long	1358502729
# p:
	.long	2125218817
# g:
	.long	1740685459
# s:
	.long	772541971
# p:
	.long	2125209601
# g:
	.long	158422970
# s:
	.long	1393803695
# p:
	.long	2125145089
# g:
	.long	774945061
# s:
	.long	422447238
# p:
	.long	2125034497
# g:
	.long	817229098
# s:
	.long	572262541
# p:
	.long	2124960769
# g:
	.long	1698825902
# s:
	.long	1982659953
# p:
	.long	2124850177
# g:
	.long	653751473
# s:
	.long	1381808527
# p:
	.long	2124840961
# g:
	.long	955893738
# s:
	.long	2069933595
# p:
	.long	2124776449
# g:
	.long	463369993
# s:
	.long	633601306
# p:
	.long	2124730369
# g:
	.long	1157837776
# s:
	.long	1313982800
# p:
	.long	2124721153
# g:
	.long	1790010632
# s:
	.long	2054959067
# p:
	.long	2124675073
# g:
	.long	2095909752
# s:
	.long	938708783
# p:
	.long	2124628993
# g:
	.long	551553431
# s:
	.long	1551153403
# p:
	.long	2124518401
# g:
	.long	1003150709
# s:
	.long	363961378
# p:
	.long	2124472321
# g:
	.long	458570411
# s:
	.long	1846831772
# p:
	.long	2124407809
# g:
	.long	723744843
# s:
	.long	599474824
# p:
	.long	2124269569
# g:
	.long	756315765
# s:
	.long	1296627617
# p:
	.long	2124241921
# g:
	.long	240271797
# s:
	.long	824395288
# p:
	.long	2124029953
# g:
	.long	987773788
# s:
	.long	630934944
# p:
	.long	2123900929
# g:
	.long	1674691848
# s:
	.long	463866389
# p:
	.long	2123744257
# g:
	.long	1808349155
# s:
	.long	1174932680
# p:
	.long	2123707393
# g:
	.long	971989455
# s:
	.long	667730824
# p:
	.long	2123430913
# g:
	.long	58106012
# s:
	.long	2077947323
# p:
	.long	2123384833
# g:
	.long	303651156
# s:
	.long	278324568
# p:
	.long	2123347969
# g:
	.long	14601707
# s:
	.long	1955701082
# p:
	.long	2123255809
# g:
	.long	1003411912
# s:
	.long	1156288516
# p:
	.long	2123209729
# g:
	.long	1134887418
# s:
	.long	1648156134
# p:
	.long	2123145217
# g:
	.long	549051395
# s:
	.long	909737254
# p:
	.long	2123108353
# g:
	.long	1124043040
# s:
	.long	1455878235
# p:
	.long	2123062273
# g:
	.long	714518702
# s:
	.long	562237660
# p:
	.long	2123016193
# g:
	.long	477140727
# s:
	.long	1222750510
# p:
	.long	2122905601
# g:
	.long	871772364
# s:
	.long	458276114
# p:
	.long	2122841089
# g:
	.long	998796878
# s:
	.long	1034066124
# p:
	.long	2122795009
# g:
	.long	1246163817
# s:
	.long	1837916539
# p:
	.long	2122702849
# g:
	.long	649939419
# s:
	.long	1933115292
# p:
	.long	2122693633
# g:
	.long	1464004623
# s:
	.long	1659343984
# p:
	.long	2122675201
# g:
	.long	1351707837
# s:
	.long	1950694436
# p:
	.long	2122638337
# g:
	.long	1856349674
# s:
	.long	1340787503
# p:
	.long	2122610689
# g:
	.long	2113728301
# s:
	.long	555032812
# p:
	.long	2122380289
# g:
	.long	1240633077
# s:
	.long	383470026
# p:
	.long	2122306561
# g:
	.long	863692179
# s:
	.long	232892234
# p:
	.long	2122278913
# g:
	.long	1716367688
# s:
	.long	126767839
# p:
	.long	2122242049
# g:
	.long	500738737
# s:
	.long	1035407344
# p:
	.long	2122223617
# g:
	.long	346966153
# s:
	.long	1050431097
# p:
	.long	2122177537
# g:
	.long	1995072540
# s:
	.long	1844003134
# p:
	.long	2122140673
# g:
	.long	1084816984
# s:
	.long	1981013210
# p:
	.long	2122030081
# g:
	.long	213384350
# s:
	.long	1804789339
# p:
	.long	2122011649
# g:
	.long	774829339
# s:
	.long	1637937570
# p:
	.long	2122002433
# g:
	.long	365764485
# s:
	.long	1025775292
# p:
	.long	2121864193
# g:
	.long	1157584746
# s:
	.long	1107803651
# p:
	.long	2121818113
# g:
	.long	1492821203
# s:
	.long	5480873
# p:
	.long	2121670657
# g:
	.long	581624218
# s:
	.long	80732810
# p:
	.long	2121661441
# g:
	.long	117196539
# s:
	.long	1540055564
# p:
	.long	2121624577
# g:
	.long	313986478
# s:
	.long	1447859993
# p:
	.long	2121615361
# g:
	.long	2096069568
# s:
	.long	474498006
# p:
	.long	2121541633
# g:
	.long	1435575916
# s:
	.long	1504696751
# p:
	.long	2121532417
# g:
	.long	332013221
# s:
	.long	1506095154
# p:
	.long	2121431041
# g:
	.long	1765687750
# s:
	.long	549516218
# p:
	.long	2121302017
# g:
	.long	1030773468
# s:
	.long	1771875662
# p:
	.long	2121163777
# g:
	.long	1160063364
# s:
	.long	1228530083
# p:
	.long	2121016321
# g:
	.long	451484541
# s:
	.long	2001691958
# p:
	.long	2120997889
# g:
	.long	1193753623
# s:
	.long	1405393548
# p:
	.long	2120905729
# g:
	.long	1148813923
# s:
	.long	127197231
# p:
	.long	2120804353
# g:
	.long	105741521
# s:
	.long	489296998
# p:
	.long	2120767489
# g:
	.long	238843522
# s:
	.long	405203095
# p:
	.long	2120702977
# g:
	.long	181335438
# s:
	.long	145309480
# p:
	.long	2120509441
# g:
	.long	452681497
# s:
	.long	416341537
# p:
	.long	2120389633
# g:
	.long	38577349
# s:
	.long	429830493
# p:
	.long	2120380417
# g:
	.long	1585007861
# s:
	.long	170165231
# p:
	.long	2120343553
# g:
	.long	1358849854
# s:
	.long	586900104
# p:
	.long	2120260609
# g:
	.long	700414411
# s:
	.long	1531079827
# p:
	.long	2120242177
# g:
	.long	1403722621
# s:
	.long	1110108837
# p:
	.long	2120048641
# g:
	.long	1651801506
# s:
	.long	1301165160
# p:
	.long	2119965697
# g:
	.long	1193729370
# s:
	.long	1910811398
# p:
	.long	2119836673
# g:
	.long	94731702
# s:
	.long	1017121445
# p:
	.long	2119680001
# g:
	.long	1976457115
# s:
	.long	1737536207
# p:
	.long	2119661569
# g:
	.long	1629205671
# s:
	.long	403852471
# p:
	.long	2119615489
# g:
	.long	246218100
# s:
	.long	982466819
# p:
	.long	2119606273
# g:
	.long	479839608
# s:
	.long	1954131325
# p:
	.long	2119597057
# g:
	.long	1649911687
# s:
	.long	808245350
# p:
	.long	2119495681
# g:
	.long	677468044
# s:
	.long	1545497491
# p:
	.long	2119127041
# g:
	.long	265852470
# s:
	.long	963370239
# p:
	.long	2119108609
# g:
	.long	1889427753
# s:
	.long	437040411
# p:
	.long	2118804481
# g:
	.long	1414598229
# s:
	.long	730942333
# p:
	.long	2118776833
# g:
	.long	519499421
# s:
	.long	2014324182
# p:
	.long	2118767617
# g:
	.long	1638204903
# s:
	.long	748970097
# p:
	.long	2118758401
# g:
	.long	1814485541
# s:
	.long	1394854997
# p:
	.long	2118739969
# g:
	.long	408050787
# s:
	.long	1974429813
# p:
	.long	2118721537
# g:
	.long	1056716778
# s:
	.long	1039536373
# p:
	.long	2118537217
# g:
	.long	1546983822
# s:
	.long	775277588
# p:
	.long	2118528001
# g:
	.long	1204794661
# s:
	.long	2117510248
# p:
	.long	2118417409
# g:
	.long	1007191079
# s:
	.long	708141224
# p:
	.long	2118343681
# g:
	.long	1621893891
# s:
	.long	1394899900
# p:
	.long	2118325249
# g:
	.long	790149014
# s:
	.long	1960510159
# p:
	.long	2118269953
# g:
	.long	1384770073
# s:
	.long	1608995421
# p:
	.long	2118251521
# g:
	.long	603411241
# s:
	.long	33673391
# p:
	.long	2118159361
# g:
	.long	1650961201
# s:
	.long	27178777
# p:
	.long	2118067201
# g:
	.long	1841024981
# s:
	.long	944226067
# p:
	.long	2118030337
# g:
	.long	1566476976
# s:
	.long	939086390
# p:
	.long	2118021121
# g:
	.long	1775224402
# s:
	.long	2081146368
# p:
	.long	2117892097
# g:
	.long	1691343134
# s:
	.long	1334491380
# p:
	.long	2117818369
# g:
	.long	1171222484
# s:
	.long	1968249430
# p:
	.long	2117753857
# g:
	.long	1573323258
# s:
	.long	522881728
# p:
	.long	2117726209
# g:
	.long	1277401244
# s:
	.long	638111917
# p:
	.long	2117486593
# g:
	.long	1723346537
# s:
	.long	691480002
# p:
	.long	2117468161
# g:
	.long	55763921
# s:
	.long	502981959
# p:
	.long	2117403649
# g:
	.long	1166105140
# s:
	.long	693324800
# p:
	.long	2117302273
# g:
	.long	475928414
# s:
	.long	183083846
# p:
	.long	2117283841
# g:
	.long	405617427
# s:
	.long	1251046503
# p:
	.long	2117246977
# g:
	.long	1697393574
# s:
	.long	1602946023
# p:
	.long	2117154817
# g:
	.long	2065498412
# s:
	.long	239373751
# p:
	.long	2117127169
# g:
	.long	430610228
# s:
	.long	1268696569
# p:
	.long	2117117953
# g:
	.long	1093343929
# s:
	.long	1724711688
# p:
	.long	2117081089
# g:
	.long	1192645535
# s:
	.long	529674556
# p:
	.long	2117053441
# g:
	.long	505102329
# s:
	.long	340237027
# p:
	.long	2116979713
# g:
	.long	1804622475
# s:
	.long	2053613440
# p:
	.long	2116961281
# g:
	.long	65888302
# s:
	.long	2107574506
# p:
	.long	2116915201
# g:
	.long	610308461
# s:
	.long	765883989
# p:
	.long	2116850689
# g:
	.long	1398598016
# s:
	.long	816156948
# p:
	.long	2116832257
# g:
	.long	765454171
# s:
	.long	2043386233
# p:
	.long	2116546561
# g:
	.long	717024057
# s:
	.long	908872647
# p:
	.long	2116500481
# g:
	.long	4150213
# s:
	.long	1791660104
# p:
	.long	2116463617
# g:
	.long	852983945
# s:
	.long	1644414801
# p:
	.long	2116454401
# g:
	.long	216264809
# s:
	.long	145255817
# p:
	.long	2116408321
# g:
	.long	475976424
# s:
	.long	1359934449
# p:
	.long	2116325377
# g:
	.long	1625562543
# s:
	.long	1515684589
# p:
	.long	2116251649
# g:
	.long	2058802384
# s:
	.long	1822424401
# p:
	.long	2116196353
# g:
	.long	1321633318
# s:
	.long	107796720
# p:
	.long	2116187137
# g:
	.long	605175264
# s:
	.long	878408602
# p:
	.long	2116150273
# g:
	.long	2035056670
# s:
	.long	752365190
# p:
	.long	2116002817
# g:
	.long	1521328676
# s:
	.long	1922412326
# p:
	.long	2115827713
# g:
	.long	1757335227
# s:
	.long	1058894443
# p:
	.long	2115735553
# g:
	.long	92961281
# s:
	.long	280579127
# p:
	.long	2115643393
# g:
	.long	1247556729
# s:
	.long	1218186175
# p:
	.long	2115634177
# g:
	.long	85949000
# s:
	.long	2022049401
# p:
	.long	2115505153
# g:
	.long	594820966
# s:
	.long	1632620883
# p:
	.long	2115486721
# g:
	.long	209298008
# s:
	.long	1279424564
# p:
	.long	2115449857
# g:
	.long	1402132124
# s:
	.long	1024129509
# p:
	.long	2115311617
# g:
	.long	1945407724
# s:
	.long	1012558423
# p:
	.long	2115274753
# g:
	.long	872985195
# s:
	.long	614339987
# p:
	.long	2115256321
# g:
	.long	204180003
# s:
	.long	1438240334
# p:
	.long	2115127297
# g:
	.long	50782273
# s:
	.long	284566722
# p:
	.long	2114915329
# g:
	.long	819417843
# s:
	.long	262561066
# p:
	.long	2114841601
# g:
	.long	2081783434
# s:
	.long	1016047939
# p:
	.long	2114804737
# g:
	.long	17411722
# s:
	.long	1293342377
# p:
	.long	2114795521
# g:
	.long	16941624
# s:
	.long	960131138
# p:
	.long	2114629633
# g:
	.long	1789204129
# s:
	.long	1457521477
# p:
	.long	2114611201
# g:
	.long	298873313
# s:
	.long	73623697
# p:
	.long	2114592769
# g:
	.long	1704509716
# s:
	.long	88880999
# p:
	.long	2114565121
# g:
	.long	726257921
# s:
	.long	259747825
# p:
	.long	2114528257
# g:
	.long	584191684
# s:
	.long	842044213
# p:
	.long	2114482177
# g:
	.long	720385692
# s:
	.long	477653968
# p:
	.long	2114445313
# g:
	.long	1238383449
# s:
	.long	1430552047
# p:
	.long	2114390017
# g:
	.long	98614528
# s:
	.long	1910577492
# p:
	.long	2114307073
# g:
	.long	373551360
# s:
	.long	427233204
# p:
	.long	2114288641
# g:
	.long	1615089535
# s:
	.long	2110837127
# p:
	.long	2114242561
# g:
	.long	217156792
# s:
	.long	297252338
# p:
	.long	2114214913
# g:
	.long	1432348674
# s:
	.long	1566451545
# p:
	.long	2114122753
# g:
	.long	2101469537
# s:
	.long	785458914
# p:
	.long	2113993729
# g:
	.long	805095866
# s:
	.long	235362830
# p:
	.long	2113929217
# g:
	.long	1996941803
# s:
	.long	1886332797
# p:
	.long	2113763329
# g:
	.long	1045961841
# s:
	.long	1369867551
# p:
	.long	2113754113
# g:
	.long	1214231913
# s:
	.long	1237233461
# p:
	.long	2113708033
# g:
	.long	1537995485
# s:
	.long	13776316
# p:
	.long	2113606657
# g:
	.long	700816500
# s:
	.long	658494367
# p:
	.long	2113560577
# g:
	.long	1424896092
# s:
	.long	1869549877
# p:
	.long	2113505281
# g:
	.long	234620725
# s:
	.long	941446553
# p:
	.long	2113284097
# g:
	.long	323440815
# s:
	.long	786455037
# p:
	.long	2113210369
# g:
	.long	608305882
# s:
	.long	1080882489
# p:
	.long	2113191937
# g:
	.long	1148437116
# s:
	.long	1719312011
# p:
	.long	2113118209
# g:
	.long	1051044863
# s:
	.long	794443301
# p:
	.long	2113099777
# g:
	.long	980463293
# s:
	.long	1719087175
# p:
	.long	2113053697
# g:
	.long	699347832
# s:
	.long	156091436
# p:
	.long	2113016833
# g:
	.long	1430079216
# s:
	.long	359758036
# p:
	.long	2112979969
# g:
	.long	1310280658
# s:
	.long	1565698405
# p:
	.long	2112924673
# g:
	.long	1077952720
# s:
	.long	826136782
# p:
	.long	2112906241
# g:
	.long	2059779110
# s:
	.long	1491126664
# p:
	.long	2112860161
# g:
	.long	713414867
# s:
	.long	586556795
# p:
	.long	2112841729
# g:
	.long	1701812916
# s:
	.long	454235784
# p:
	.long	2112740353
# g:
	.long	891691575
# s:
	.long	2103484779
# p:
	.long	2112694273
# g:
	.long	1579564755
# s:
	.long	374566683
# p:
	.long	2112592897
# g:
	.long	573565742
# s:
	.long	1413654470
# p:
	.long	2112380929
# g:
	.long	1715525588
# s:
	.long	426852355
# p:
	.long	2112279553
# g:
	.long	361151680
# s:
	.long	74301313
# p:
	.long	2112196609
# g:
	.long	1084802433
# s:
	.long	1809577103
# p:
	.long	2112178177
# g:
	.long	1171466206
# s:
	.long	1357386994
# p:
	.long	2112049153
# g:
	.long	838332559
# s:
	.long	143479796
# p:
	.long	2112003073
# g:
	.long	376095902
# s:
	.long	208470491
# p:
	.long	2111827969
# g:
	.long	1785473938
# s:
	.long	1585619014
# p:
	.long	2111809537
# g:
	.long	854552605
# s:
	.long	1643647738
# p:
	.long	2111772673
# g:
	.long	1149900274
# s:
	.long	862411882
# p:
	.long	2111735809
# g:
	.long	1614068446
# s:
	.long	1732474813
# p:
	.long	2111689729
# g:
	.long	883065790
# s:
	.long	1228783274
# p:
	.long	2111680513
# g:
	.long	88573989
# s:
	.long	855503629
# p:
	.long	2111671297
# g:
	.long	163686346
# s:
	.long	120230111
# p:
	.long	2111579137
# g:
	.long	1856366475
# s:
	.long	1824040801
# p:
	.long	2111551489
# g:
	.long	1740132893
# s:
	.long	1220423335
# p:
	.long	2111477761
# g:
	.long	1761175933
# s:
	.long	1482065169
# p:
	.long	2111440897
# g:
	.long	873082344
# s:
	.long	1126710467
# p:
	.long	2111404033
# g:
	.long	1234679104
# s:
	.long	429061622
# p:
	.long	2111302657
# g:
	.long	1285910809
# s:
	.long	247718129
# p:
	.long	2111173633
# g:
	.long	1072006977
# s:
	.long	378677534
# p:
	.long	2111118337
# g:
	.long	2042358703
# s:
	.long	667913400
# p:
	.long	2110970881
# g:
	.long	116629121
# s:
	.long	1263574844
# p:
	.long	2110934017
# g:
	.long	529074111
# s:
	.long	944666895
# p:
	.long	2110924801
# g:
	.long	1820783217
# s:
	.long	2074740605
# p:
	.long	2110887937
# g:
	.long	159343018
# s:
	.long	1129369080
# p:
	.long	2110860289
# g:
	.long	625828424
# s:
	.long	360340853
# p:
	.long	2110832641
# g:
	.long	1591537619
# s:
	.long	1407943167
# p:
	.long	2110795777
# g:
	.long	1350153696
# s:
	.long	1006631480
# p:
	.long	2110648321
# g:
	.long	1622425679
# s:
	.long	1771829802
# p:
	.long	2110473217
# g:
	.long	276619341
# s:
	.long	299898537
# p:
	.long	2110464001
# g:
	.long	584292801
# s:
	.long	1797135079
# p:
	.long	2110436353
# g:
	.long	1553893068
# s:
	.long	1183260440
# p:
	.long	2110334977
# g:
	.long	1773301242
# s:
	.long	1983346418
# p:
	.long	2110215169
# g:
	.long	151311136
# s:
	.long	1662765192
# p:
	.long	2110113793
# g:
	.long	1237790218
# s:
	.long	2092306923
# p:
	.long	2110076929
# g:
	.long	1968119378
# s:
	.long	1972029191
# p:
	.long	2110003201
# g:
	.long	500128670
# s:
	.long	78880956
# p:
	.long	2109984769
# g:
	.long	866052988
# s:
	.long	534461060
# p:
	.long	2109745153
# g:
	.long	1868270307
# s:
	.long	1359221496
# p:
	.long	2109735937
# g:
	.long	1733188861
# s:
	.long	188473109
# p:
	.long	2109699073
# g:
	.long	1960782843
# s:
	.long	9443274
# p:
	.long	2109616129
# g:
	.long	202816650
# s:
	.long	2102446329
# p:
	.long	2109606913
# g:
	.long	61368812
# s:
	.long	260949868
# p:
	.long	2109450241
# g:
	.long	542910423
# s:
	.long	713198468
# p:
	.long	2109404161
# g:
	.long	20367061
# s:
	.long	1310143682
# p:
	.long	2109376513
# g:
	.long	1233858021
# s:
	.long	629449410
# p:
	.long	2109367297
# g:
	.long	304780954
# s:
	.long	1109603597
# p:
	.long	2109321217
# g:
	.long	1423489147
# s:
	.long	306040011
# p:
	.long	2109275137
# g:
	.long	1231666872
# s:
	.long	805223297
# p:
	.long	2109155329
# g:
	.long	1724006908
# s:
	.long	488451587
# p:
	.long	2109100033
# g:
	.long	1891395075
# s:
	.long	123331414
# p:
	.long	2109090817
# g:
	.long	747871669
# s:
	.long	167752135
# p:
	.long	2108998657
# g:
	.long	535205605
# s:
	.long	1866748045
# p:
	.long	2108952577
# g:
	.long	1563332723
# s:
	.long	1961847492
# p:
	.long	2108924929
# g:
	.long	673452897
# s:
	.long	857675085
# p:
	.long	2108786689
# g:
	.long	398277042
# s:
	.long	582804820
# p:
	.long	2108740609
# g:
	.long	1019040835
# s:
	.long	477405249
# p:
	.long	2108666881
# g:
	.long	989234965
# s:
	.long	1332801322
# p:
	.long	2108500993
# g:
	.long	1487897482
# s:
	.long	1888448641
# p:
	.long	2108454913
# g:
	.long	1061720500
# s:
	.long	1048563700
# p:
	.long	2108344321
# g:
	.long	1297529814
# s:
	.long	876602033
# p:
	.long	2108316673
# g:
	.long	110530206
# s:
	.long	1096501547
# p:
	.long	2108261377
# g:
	.long	991889565
# s:
	.long	538700275
# p:
	.long	2108206081
# g:
	.long	1132489007
# s:
	.long	1922594064
# p:
	.long	2108141569
# g:
	.long	1890975027
# s:
	.long	725643017
# p:
	.long	2108077057
# g:
	.long	1874277571
# s:
	.long	1326841475
# p:
	.long	2108021761
# g:
	.long	679188317
# s:
	.long	1334863041
# p:
	.long	2107994113
# g:
	.long	2042898862
# s:
	.long	1213614298
# p:
	.long	2107984897
# g:
	.long	553930555
# s:
	.long	855461510
# p:
	.long	2107948033
# g:
	.long	588654395
# s:
	.long	817925600
# p:
	.long	2107855873
# g:
	.long	955510197
# s:
	.long	1387472603
# p:
	.long	2107772929
# g:
	.long	1710750259
# s:
	.long	1123501013
# p:
	.long	2107754497
# g:
	.long	635478204
# s:
	.long	1385962529
# p:
	.long	2107533313
# g:
	.long	678856625
# s:
	.long	1669657796
# p:
	.long	2107496449
# g:
	.long	1538994818
# s:
	.long	1742580684
# p:
	.long	2107385857
# g:
	.long	219571624
# s:
	.long	908447744
# p:
	.long	2107081729
# g:
	.long	37125220
# s:
	.long	225140665
# p:
	.long	2106823681
# g:
	.long	1861430627
# s:
	.long	1595579024
# p:
	.long	2106786817
# g:
	.long	1478483229
# s:
	.long	1834883513
# p:
	.long	2106777601
# g:
	.long	18358925
# s:
	.long	1226850857
# p:
	.long	2106731521
# g:
	.long	70736804
# s:
	.long	1593056790
# p:
	.long	2106602497
# g:
	.long	1787857779
# s:
	.long	1157994066
# p:
	.long	2106510337
# g:
	.long	1053283187
# s:
	.long	431197947
# p:
	.long	2106408961
# g:
	.long	503723589
# s:
	.long	924325515
# p:
	.long	2106381313
# g:
	.long	422062926
# s:
	.long	1818864419
# p:
	.long	2106326017
# g:
	.long	988329413
# s:
	.long	788786586
# p:
	.long	2106196993
# g:
	.long	5144393
# s:
	.long	1067946516
# p:
	.long	2106160129
# g:
	.long	232789957
# s:
	.long	716160267
# p:
	.long	2106132481
# g:
	.long	271126160
# s:
	.long	588564885
# p:
	.long	2106049537
# g:
	.long	219156131
# s:
	.long	2103120897
# p:
	.long	2105948161
# g:
	.long	310664150
# s:
	.long	2102860169
# p:
	.long	2105856001
# g:
	.long	1820055956
# s:
	.long	278910924
# p:
	.long	2105809921
# g:
	.long	1701662140
# s:
	.long	84443796
# p:
	.long	2105763841
# g:
	.long	372711392
# s:
	.long	1208096656
# p:
	.long	2105644033
# g:
	.long	852176863
# s:
	.long	2074648697
# p:
	.long	2105579521
# g:
	.long	1933278403
# s:
	.long	1874218731
# p:
	.long	2105496577
# g:
	.long	2038484879
# s:
	.long	259408028
# p:
	.long	2105404417
# g:
	.long	1055508287
# s:
	.long	445005691
# p:
	.long	2105349121
# g:
	.long	1909094644
# s:
	.long	1540449359
# p:
	.long	2105256961
# g:
	.long	1032137837
# s:
	.long	346714550
# p:
	.long	2105220097
# g:
	.long	779743185
# s:
	.long	1546162600
# p:
	.long	2105192449
# g:
	.long	1388701228
# s:
	.long	1806324320
# p:
	.long	2105183233
# g:
	.long	690304491
# s:
	.long	1259032344
# p:
	.long	2105174017
# g:
	.long	1735948214
# s:
	.long	725484090
# p:
	.long	2105044993
# g:
	.long	793461585
# s:
	.long	41023060
# p:
	.long	2104980481
# g:
	.long	2008871922
# s:
	.long	799963161
# p:
	.long	2104888321
# g:
	.long	690132118
# s:
	.long	1148573451
# p:
	.long	2104842241
# g:
	.long	269838763
# s:
	.long	569948871
# p:
	.long	2104768513
# g:
	.long	528801830
# s:
	.long	770281982
# p:
	.long	2104704001
# g:
	.long	1516142741
# s:
	.long	588647472
# p:
	.long	2104667137
# g:
	.long	246319617
# s:
	.long	2073701013
# p:
	.long	2104584193
# g:
	.long	1165086960
# s:
	.long	1040401640
# p:
	.long	2104538113
# g:
	.long	1499544177
# s:
	.long	881562709
# p:
	.long	2104501249
# g:
	.long	961119635
# s:
	.long	1719133603
# p:
	.long	2104473601
# g:
	.long	1868205140
# s:
	.long	1584317969
# p:
	.long	2104307713
# g:
	.long	12930097
# s:
	.long	938274123
# p:
	.long	2104289281
# g:
	.long	338626191
# s:
	.long	1702354574
# p:
	.long	2104206337
# g:
	.long	1221749494
# s:
	.long	1669711230
# p:
	.long	2103966721
# g:
	.long	1549982223
# s:
	.long	387442321
# p:
	.long	2103892993
# g:
	.long	1655287848
# s:
	.long	1470176433
# p:
	.long	2103883777
# g:
	.long	483708092
# s:
	.long	1448617508
# p:
	.long	2103856129
# g:
	.long	2101722548
# s:
	.long	2007976283
# p:
	.long	2103763969
# g:
	.long	543940570
# s:
	.long	1777925299
# p:
	.long	2103671809
# g:
	.long	1195257390
# s:
	.long	1888353073
# p:
	.long	2103561217
# g:
	.long	1030993167
# s:
	.long	715919123
# p:
	.long	2103422977
# g:
	.long	708358290
# s:
	.long	1587476471
# p:
	.long	2103376897
# g:
	.long	1313065158
# s:
	.long	1449493403
# p:
	.long	2103247873
# g:
	.long	1317442397
# s:
	.long	1328378784
# p:
	.long	2103183361
# g:
	.long	1077688694
# s:
	.long	101784545
# p:
	.long	2103091201
# g:
	.long	602673005
# s:
	.long	875523189
# p:
	.long	2103054337
# g:
	.long	190418775
# s:
	.long	1909126830
# p:
	.long	2103045121
# g:
	.long	1388315484
# s:
	.long	1381194261
# p:
	.long	2102980609
# g:
	.long	945244326
# s:
	.long	801780354
# p:
	.long	2102934529
# g:
	.long	34666273
# s:
	.long	957656055
# p:
	.long	2102860801
# g:
	.long	1755440685
# s:
	.long	756305790
# p:
	.long	2102823937
# g:
	.long	1850460956
# s:
	.long	317314316
# p:
	.long	2102704129
# g:
	.long	325514382
# s:
	.long	1599848698
# p:
	.long	2102676481
# g:
	.long	779224002
# s:
	.long	1961254268
# p:
	.long	2102584321
# g:
	.long	523381573
# s:
	.long	1615556185
# p:
	.long	2102501377
# g:
	.long	2042917151
# s:
	.long	620509694
# p:
	.long	2102473729
# g:
	.long	943339397
# s:
	.long	1891565713
# p:
	.long	2102446081
# g:
	.long	423919472
# s:
	.long	1645067812
# p:
	.long	2102418433
# g:
	.long	143260945
# s:
	.long	423614459
# p:
	.long	2102261761
# g:
	.long	841954787
# s:
	.long	177205853
# p:
	.long	2102215681
# g:
	.long	560672475
# s:
	.long	1169215993
# p:
	.long	2102132737
# g:
	.long	1156510649
# s:
	.long	117139879
# p:
	.long	2102123521
# g:
	.long	500225868
# s:
	.long	1239531872
# p:
	.long	2102095873
# g:
	.long	241508989
# s:
	.long	703169285
# p:
	.long	2102012929
# g:
	.long	99814587
# s:
	.long	1026035272
# p:
	.long	2101994497
# g:
	.long	938653320
# s:
	.long	1243519736
# p:
	.long	2101957633
# g:
	.long	128968698
# s:
	.long	1320062766
# p:
	.long	2101902337
# g:
	.long	1456384664
# s:
	.long	1217932413
# p:
	.long	2101865473
# g:
	.long	2030834104
# s:
	.long	1228958072
# p:
	.long	2101856257
# g:
	.long	94760290
# s:
	.long	1332226039
# p:
	.long	2101727233
# g:
	.long	536766749
# s:
	.long	1178609993
# p:
	.long	2101625857
# g:
	.long	796609456
# s:
	.long	164780878
# p:
	.long	2101598209
# g:
	.long	396348525
# s:
	.long	1234299781
# p:
	.long	2101506049
# g:
	.long	273578255
# s:
	.long	495370977
# p:
	.long	2101496833
# g:
	.long	20439829
# s:
	.long	700527864
# p:
	.long	2101340161
# g:
	.long	1209835320
# s:
	.long	867167765
# p:
	.long	2101257217
# g:
	.long	1492225688
# s:
	.long	593444144
# p:
	.long	2101165057
# g:
	.long	1556797129
# s:
	.long	963837170
# p:
	.long	2101155841
# g:
	.long	1926574643
# s:
	.long	177173630
# p:
	.long	2101017601
# g:
	.long	1282759593
# s:
	.long	1260338979
# p:
	.long	2100953089
# g:
	.long	993418630
# s:
	.long	1369441028
# p:
	.long	2100925441
# g:
	.long	1603880924
# s:
	.long	1931748509
# p:
	.long	2100860929
# g:
	.long	638435649
# s:
	.long	1518256697
# p:
	.long	2100833281
# g:
	.long	1359963770
# s:
	.long	382477015
# p:
	.long	2100805633
# g:
	.long	778634907
# s:
	.long	1573266059
# p:
	.long	2100787201
# g:
	.long	1307753743
# s:
	.long	822117154
# p:
	.long	2100759553
# g:
	.long	1075797626
# s:
	.long	1174495883
# p:
	.long	2100612097
# g:
	.long	131673507
# s:
	.long	139555850
# p:
	.long	2100529153
# g:
	.long	400818453
# s:
	.long	2023785961
# p:
	.long	2100390913
# g:
	.long	476457132
# s:
	.long	1392827321
# p:
	.long	2100344833
# g:
	.long	1481029753
# s:
	.long	522209734
# p:
	.long	2100335617
# g:
	.long	1793949236
# s:
	.long	1064691562
# p:
	.long	2100307969
# g:
	.long	179121373
# s:
	.long	21860175
# p:
	.long	2100289537
# g:
	.long	1762852499
# s:
	.long	1208318242
# p:
	.long	2100197377
# g:
	.long	1323210843
# s:
	.long	443820460
# p:
	.long	2100151297
# g:
	.long	577840546
# s:
	.long	383151836
# p:
	.long	2100068353
# g:
	.long	1238671839
# s:
	.long	1419754956
# p:
	.long	2100049921
# g:
	.long	1656088980
# s:
	.long	924483992
# p:
	.long	2099985409
# g:
	.long	59451203
# s:
	.long	1638850328
# p:
	.long	2099736577
# g:
	.long	57863534
# s:
	.long	869688103
# p:
	.long	2099699713
# g:
	.long	1314675048
# s:
	.long	528509009
# p:
	.long	2099690497
# g:
	.long	317089865
# s:
	.long	1208904550
# p:
	.long	2099543041
# g:
	.long	1037600388
# s:
	.long	1414899397
# p:
	.long	2099414017
# g:
	.long	611171215
# s:
	.long	698552176
# p:
	.long	2099340289
# g:
	.long	336330143
# s:
	.long	563224399
# p:
	.long	2099294209
# g:
	.long	591651779
# s:
	.long	1602747301
# p:
	.long	2099238913
# g:
	.long	691977686
# s:
	.long	65322698
# p:
	.long	2099192833
# g:
	.long	1958220926
# s:
	.long	205614888
# p:
	.long	2099183617
# g:
	.long	1067696404
# s:
	.long	2031611211
# p:
	.long	2099155969
# g:
	.long	1860182149
# s:
	.long	1727886644
# p:
	.long	2099082241
# g:
	.long	1134330653
# s:
	.long	737807940
# p:
	.long	2098971649
# g:
	.long	1880736657
# s:
	.long	603157880
# p:
	.long	2098861057
# g:
	.long	1154298233
# s:
	.long	2046344571
# p:
	.long	2098722817
# g:
	.long	997498292
# s:
	.long	2007285809
# p:
	.long	2098593793
# g:
	.long	760974185
# s:
	.long	1001876445
# p:
	.long	2098501633
# g:
	.long	1352334495
# s:
	.long	140654508
# p:
	.long	2098483201
# g:
	.long	1575003218
# s:
	.long	1387359597
# p:
	.long	2098391041
# g:
	.long	832525558
# s:
	.long	758805084
# p:
	.long	2098317313
# g:
	.long	1412351661
# s:
	.long	904616875
# p:
	.long	2098280449
# g:
	.long	391830844
# s:
	.long	395696768
# p:
	.long	2098271233
# g:
	.long	962364437
# s:
	.long	1618807971
# p:
	.long	2098179073
# g:
	.long	1685236361
# s:
	.long	1265310761
# p:
	.long	2098123777
# g:
	.long	894788033
# s:
	.long	2092345409
# p:
	.long	2098114561
# g:
	.long	1550851121
# s:
	.long	192081785
# p:
	.long	2098003969
# g:
	.long	339558786
# s:
	.long	485924500
# p:
	.long	2097957889
# g:
	.long	251535064
# s:
	.long	1184293227
# p:
	.long	2097856513
# g:
	.long	1795948729
# s:
	.long	346360723
# p:
	.long	2097745921
# g:
	.long	992694984
# s:
	.long	1506373046
# p:
	.long	2097699841
# g:
	.long	351189364
# s:
	.long	1974257782
# p:
	.long	2097681409
# g:
	.long	594739599
# s:
	.long	769720343
# p:
	.long	2097635329
# g:
	.long	1272368953
# s:
	.long	1234756385
# p:
	.long	2097497089
# g:
	.long	841942322
# s:
	.long	220916806
# p:
	.long	2097358849
# g:
	.long	1157521048
# s:
	.long	1970691021
# p:
	.long	2097349633
# g:
	.long	1704134020
# s:
	.long	810682368
# p:
	.long	2097340417
# g:
	.long	787904347
# s:
	.long	566393488
# p:
	.long	2097294337
# g:
	.long	101776044
# s:
	.long	1317779873
# p:
	.long	2097257473
# g:
	.long	175812260
# s:
	.long	273905458
# p:
	.long	2097239041
# g:
	.long	1563332875
# s:
	.long	346759854
# p:
	.long	2097156097
# g:
	.long	1785398848
# s:
	.long	771407085
# p:
	.long	2096980993
# g:
	.long	1758772669
# s:
	.long	369989240
# p:
	.long	2096962561
# g:
	.long	1868308634
# s:
	.long	1056095419
# p:
	.long	2096925697
# g:
	.long	1513794444
# s:
	.long	102577661
# p:
	.long	2096796673
# g:
	.long	191396724
# s:
	.long	1798924415
# p:
	.long	2096759809
# g:
	.long	816145533
# s:
	.long	2002876677
# p:
	.long	2096704513
# g:
	.long	1390588056
# s:
	.long	1748051098
# p:
	.long	2096695297
# g:
	.long	1619295388
# s:
	.long	1697535445
# p:
	.long	2096566273
# g:
	.long	153026731
# s:
	.long	1090624645
# p:
	.long	2096547841
# g:
	.long	1565655571
# s:
	.long	615245178
# p:
	.long	2096326657
# g:
	.long	1611716099
# s:
	.long	787979910
# p:
	.long	2096252929
# g:
	.long	63838391
# s:
	.long	1829193720
# p:
	.long	2096142337
# g:
	.long	782701547
# s:
	.long	1178943280
# p:
	.long	2096096257
# g:
	.long	1156106164
# s:
	.long	200521033
# p:
	.long	2096068609
# g:
	.long	1730349429
# s:
	.long	1171196230
# p:
	.long	2095921153
# g:
	.long	1533897666
# s:
	.long	1420930595
# p:
	.long	2095865857
# g:
	.long	505462397
# s:
	.long	1004003705
# p:
	.long	2095856641
# g:
	.long	927501860
# s:
	.long	1286801708
# p:
	.long	2095828993
# g:
	.long	1653175899
# s:
	.long	349860519
# p:
	.long	2095552513
# g:
	.long	1695002953
# s:
	.long	300622479
# p:
	.long	2095469569
# g:
	.long	1699634630
# s:
	.long	1966652127
# p:
	.long	2095423489
# g:
	.long	359416515
# s:
	.long	61368561
# p:
	.long	2095377409
# g:
	.long	1933416645
# s:
	.long	1994305037
# p:
	.long	2095368193
# g:
	.long	1183530237
# s:
	.long	385944103
# p:
	.long	2095349761
# g:
	.long	257470750
# s:
	.long	732122048
# p:
	.long	2095239169
# g:
	.long	1424181709
# s:
	.long	1985304968
# p:
	.long	2095220737
# g:
	.long	998236393
# s:
	.long	1285696587
# p:
	.long	2095082497
# g:
	.long	609633743
# s:
	.long	962096834
# p:
	.long	2095054849
# g:
	.long	248187075
# s:
	.long	236922304
# p:
	.long	2095027201
# g:
	.long	1522560863
# s:
	.long	434721942
# p:
	.long	2094962689
# g:
	.long	1218845609
# s:
	.long	1912261064
# p:
	.long	2094842881
# g:
	.long	898353911
# s:
	.long	524086191
# p:
	.long	2094723073
# g:
	.long	1835870939
# s:
	.long	1793076188
# p:
	.long	2094713857
# g:
	.long	1647447163
# s:
	.long	499911576
# p:
	.long	2094704641
# g:
	.long	141579485
# s:
	.long	713954494
# p:
	.long	2094640129
# g:
	.long	109254316
# s:
	.long	654981265
# p:
	.long	2094630913
# g:
	.long	1799848447
# s:
	.long	1671319633
# p:
	.long	2094474241
# g:
	.long	327802612
# s:
	.long	1807896567
# p:
	.long	2094400513
# g:
	.long	270429950
# s:
	.long	156347457
# p:
	.long	2094271489
# g:
	.long	1182179282
# s:
	.long	385801896
# p:
	.long	2094262273
# g:
	.long	1640267873
# s:
	.long	1369622634
# p:
	.long	2094068737
# g:
	.long	1115473460
# s:
	.long	1610887210
# p:
	.long	2093985793
# g:
	.long	1096220066
# s:
	.long	1651062916
# p:
	.long	2093930497
# g:
	.long	356759964
# s:
	.long	1358566013
# p:
	.long	2093810689
# g:
	.long	396228996
# s:
	.long	1711543002
# p:
	.long	2093736961
# g:
	.long	909470239
# s:
	.long	282428387
# p:
	.long	2093644801
# g:
	.long	2034386788
# s:
	.long	1015508708
# p:
	.long	2093607937
# g:
	.long	1766553607
# s:
	.long	308326393
# p:
	.long	2093598721
# g:
	.long	1982921218
# s:
	.long	591331138
# p:
	.long	2093432833
# g:
	.long	778349941
# s:
	.long	977876268
# p:
	.long	2093423617
# g:
	.long	1865972268
# s:
	.long	1803038234
# p:
	.long	2093377537
# g:
	.long	1696981241
# s:
	.long	413217010
# p:
	.long	2093340673
# g:
	.long	1615901863
# s:
	.long	1499970541
# p:
	.long	2093248513
# g:
	.long	555707471
# s:
	.long	428233473
# p:
	.long	2093101057
# g:
	.long	523648184
# s:
	.long	1652401191
# p:
	.long	2092999681
# g:
	.long	937681353
# s:
	.long	1199770751
# p:
	.long	2092925953
# g:
	.long	1540241461
# s:
	.long	1444054527
# p:
	.long	2092889089
# g:
	.long	1093558491
# s:
	.long	1491093571
# p:
	.long	2092796929
# g:
	.long	1390602230
# s:
	.long	958177057
# p:
	.long	2092704769
# g:
	.long	1535489452
# s:
	.long	1469350975
# p:
	.long	2092677121
# g:
	.long	842810205
# s:
	.long	2080347951
# p:
	.long	2092631041
# g:
	.long	1798728396
# s:
	.long	976024690
# p:
	.long	2092566529
# g:
	.long	417726325
# s:
	.long	1274076858
# p:
	.long	2092538881
# g:
	.long	1472434244
# s:
	.long	405807317
# p:
	.long	2092474369
# g:
	.long	26923610
# s:
	.long	1837498459
# p:
	.long	2092465153
# g:
	.long	141416583
# s:
	.long	397081855
# p:
	.long	2092419073
# g:
	.long	870209457
# s:
	.long	237334612
# p:
	.long	2092409857
# g:
	.long	1178167545
# s:
	.long	1545376318
# p:
	.long	2092400641
# g:
	.long	402357474
# s:
	.long	821042942
# p:
	.long	2092179457
# g:
	.long	940658187
# s:
	.long	147556151
# p:
	.long	2092124161
# g:
	.long	225818744
# s:
	.long	148868454
# p:
	.long	2091902977
# g:
	.long	364182900
# s:
	.long	1406989332
# p:
	.long	2091829249
# g:
	.long	1980430729
# s:
	.long	338597755
# p:
	.long	2091810817
# g:
	.long	1654282043
# s:
	.long	556711539
# p:
	.long	2091764737
# g:
	.long	334220809
# s:
	.long	2038752183
# p:
	.long	2091691009
# g:
	.long	860941585
# s:
	.long	1231707574
# p:
	.long	2091598849
# g:
	.long	1801695248
# s:
	.long	720351668
# p:
	.long	2091479041
# g:
	.long	912747645
# s:
	.long	1472579610
# p:
	.long	2091303937
# g:
	.long	1433873490
# s:
	.long	1216409264
# p:
	.long	2091294721
# g:
	.long	356680218
# s:
	.long	897424734
# p:
	.long	2091220993
# g:
	.long	2070624758
# s:
	.long	711551469
# p:
	.long	2091091969
# g:
	.long	1961057542
# s:
	.long	1000327653
# p:
	.long	2090990593
# g:
	.long	2080851342
# s:
	.long	2009659004
# p:
	.long	2090953729
# g:
	.long	267292093
# s:
	.long	1824626331
# p:
	.long	2090769409
# g:
	.long	557205733
# s:
	.long	1572273043
# p:
	.long	2090760193
# g:
	.long	1576935252
# s:
	.long	754618460
# p:
	.long	2090741761
# g:
	.long	2072951174
# s:
	.long	779491740
# p:
	.long	2090677249
# g:
	.long	1732055348
# s:
	.long	743336190
# p:
	.long	2090668033
# g:
	.long	2010266439
# s:
	.long	948792993
# p:
	.long	2090612737
# g:
	.long	817545650
# s:
	.long	1713980097
# p:
	.long	2090603521
# g:
	.long	1010856028
# s:
	.long	688758551
# p:
	.long	2090575873
# g:
	.long	506524854
# s:
	.long	346370729
# p:
	.long	2090336257
# g:
	.long	1309784215
# s:
	.long	1415734459
# p:
	.long	2090253313
# g:
	.long	642202948
# s:
	.long	982738317
# p:
	.long	2090244097
# g:
	.long	833023539
# s:
	.long	1178112798
# p:
	.long	2090198017
# g:
	.long	386976689
# s:
	.long	1613217611
# p:
	.long	2090161153
# g:
	.long	1232108876
# s:
	.long	446062285
# p:
	.long	2090004481
# g:
	.long	1747793805
# s:
	.long	1154628213
# p:
	.long	2089967617
# g:
	.long	1746899221
# s:
	.long	686200800
# p:
	.long	2089866241
# g:
	.long	101438532
# s:
	.long	326984857
# p:
	.long	2089774081
# g:
	.long	1698055307
# s:
	.long	1937512394
# p:
	.long	2089755649
# g:
	.long	1780481319
# s:
	.long	665817834
# p:
	.long	2089737217
# g:
	.long	30516493
# s:
	.long	1979006260
# p:
	.long	2089635841
# g:
	.long	1160470937
# s:
	.long	487476597
# p:
	.long	2089571329
# g:
	.long	1252170733
# s:
	.long	1995673421
# p:
	.long	2089479169
# g:
	.long	1461700277
# s:
	.long	432070583
# p:
	.long	2089433089
# g:
	.long	1361293741
# s:
	.long	169759228
# p:
	.long	2089405441
# g:
	.long	249764357
# s:
	.long	365619591
# p:
	.long	2089377793
# g:
	.long	1302472967
# s:
	.long	1442923902
# p:
	.long	2089128961
# g:
	.long	1375799560
# s:
	.long	1340463648
# p:
	.long	2089055233
# g:
	.long	547139880
# s:
	.long	438048082
# p:
	.long	2089046017
# g:
	.long	1622293266
# s:
	.long	1926791106
# p:
	.long	2088999937
# g:
	.long	722846386
# s:
	.long	1883137657
# p:
	.long	2088990721
# g:
	.long	1128649669
# s:
	.long	1078781272
# p:
	.long	2088953857
# g:
	.long	1498095085
# s:
	.long	132098265
# p:
	.long	2088870913
# g:
	.long	2063819215
# s:
	.long	1640839160
# p:
	.long	2088852481
# g:
	.long	1807307634
# s:
	.long	1389015627
# p:
	.long	2088778753
# g:
	.long	1347419191
# s:
	.long	770687093
# p:
	.long	2088732673
# g:
	.long	160435415
# s:
	.long	2017352971
# p:
	.long	2088695809
# g:
	.long	1166734380
# s:
	.long	1073904435
# p:
	.long	2088677377
# g:
	.long	4890225
# s:
	.long	371962047
# p:
	.long	2088649729
# g:
	.long	1749318940
# s:
	.long	883183350
# p:
	.long	2088483841
# g:
	.long	1490801526
# s:
	.long	1736430048
# p:
	.long	2088437761
# g:
	.long	36037696
# s:
	.long	1436470320
# p:
	.long	2088419329
# g:
	.long	1148195085
# s:
	.long	1135213176
# p:
	.long	2088410113
# g:
	.long	1072892811
# s:
	.long	1032237284
# p:
	.long	2088253441
# g:
	.long	1008098853
# s:
	.long	526016768
# p:
	.long	2088225793
# g:
	.long	1903976301
# s:
	.long	1619497673
# p:
	.long	2088216577
# g:
	.long	2083699307
# s:
	.long	428783873
# p:
	.long	2088207361
# g:
	.long	1611566880
# s:
	.long	1595125584
# p:
	.long	2088161281
# g:
	.long	1363344267
# s:
	.long	202466722
# p:
	.long	2088050689
# g:
	.long	456024764
# s:
	.long	1420693702
# p:
	.long	2087986177
# g:
	.long	226816211
# s:
	.long	1196247369
# p:
	.long	2087838721
# g:
	.long	1340602815
# s:
	.long	1119474650
# p:
	.long	2087820289
# g:
	.long	397038104
# s:
	.long	1890284608
# p:
	.long	2087562241
# g:
	.long	1553792586
# s:
	.long	1274654316
# p:
	.long	2087451649
# g:
	.long	164364382
# s:
	.long	993418731
# p:
	.long	2087442433
# g:
	.long	1652478158
# s:
	.long	1481330207
# p:
	.long	2087350273
# g:
	.long	81443119
# s:
	.long	377581277
# p:
	.long	2087313409
# g:
	.long	600524856
# s:
	.long	502433482
# p:
	.long	2087212033
# g:
	.long	1396205816
# s:
	.long	1583898309
# p:
	.long	2087156737
# g:
	.long	1644266887
# s:
	.long	1231823686
# p:
	.long	2087036929
# g:
	.long	1860987298
# s:
	.long	1484230994
# p:
	.long	2086972417
# g:
	.long	16638931
# s:
	.long	475733693
# p:
	.long	2086898689
# g:
	.long	1193959519
# s:
	.long	234160361
# p:
	.long	2086742017
# g:
	.long	911227639
# s:
	.long	663665582
# p:
	.long	2086714369
# g:
	.long	599806920
# s:
	.long	498851505
# p:
	.long	2086668289
# g:
	.long	645806793
# s:
	.long	743146378
# p:
	.long	2086566913
# g:
	.long	804249578
# s:
	.long	1276276140
# p:
	.long	2086520833
# g:
	.long	345465080
# s:
	.long	801006492
# p:
	.long	2086456321
# g:
	.long	1860837284
# s:
	.long	1646232841
# p:
	.long	2086410241
# g:
	.long	1608938247
# s:
	.long	170075505
# p:
	.long	2086391809
# g:
	.long	216348089
# s:
	.long	1991626874
# p:
	.long	2086336513
# g:
	.long	562852999
# s:
	.long	308743130
# p:
	.long	2086189057
# g:
	.long	1214298440
# s:
	.long	93779757
# p:
	.long	2086152193
# g:
	.long	1811321328
# s:
	.long	1694565636
# p:
	.long	2086115329
# g:
	.long	39747031
# s:
	.long	1597052480
# p:
	.long	2086096897
# g:
	.long	1277934628
# s:
	.long	1340097046
# p:
	.long	2085608449
# g:
	.long	1187997728
# s:
	.long	1778936945
# p:
	.long	2085451777
# g:
	.long	1968912629
# s:
	.long	834262605
# p:
	.long	2085424129
# g:
	.long	1691450278
# s:
	.long	1170341838
# p:
	.long	2085368833
# g:
	.long	1793504052
# s:
	.long	1422343854
# p:
	.long	2085285889
# g:
	.long	1078394485
# s:
	.long	1130487317
# p:
	.long	2085166081
# g:
	.long	101298685
# s:
	.long	514138591
# p:
	.long	2085046273
# g:
	.long	1800810132
# s:
	.long	281966237
# p:
	.long	2085000193
# g:
	.long	1243932501
# s:
	.long	753196611
# p:
	.long	2084981761
# g:
	.long	219102144
# s:
	.long	1553240681
# p:
	.long	2084861953
# g:
	.long	1269421035
# s:
	.long	517897005
# p:
	.long	2084843521
# g:
	.long	1492889204
# s:
	.long	1492114181
# p:
	.long	2084806657
# g:
	.long	94377032
# s:
	.long	827534948
# p:
	.long	2084732929
# g:
	.long	652996097
# s:
	.long	1548370033
# p:
	.long	2084640769
# g:
	.long	2082004664
# s:
	.long	169327057
# p:
	.long	2084613121
# g:
	.long	248040549
# s:
	.long	895872058
# p:
	.long	2084576257
# g:
	.long	1199869366
# s:
	.long	664677815
# p:
	.long	2084567041
# g:
	.long	1411747708
# s:
	.long	428760784
# p:
	.long	2084484097
# g:
	.long	333518588
# s:
	.long	1407990472
# p:
	.long	2084456449
# g:
	.long	1848294145
# s:
	.long	1440236289
# p:
	.long	2084226049
# g:
	.long	598089467
# s:
	.long	1411261613
# p:
	.long	2084115457
# g:
	.long	1700697298
# s:
	.long	254264563
# p:
	.long	2084032513
# g:
	.long	823813275
# s:
	.long	1217513398
# p:
	.long	2083986433
# g:
	.long	820037229
# s:
	.long	580219274
# p:
	.long	2083931137
# g:
	.long	655979691
# s:
	.long	1831216739
# p:
	.long	2083885057
# g:
	.long	959691762
# s:
	.long	712606234
# p:
	.long	2083875841
# g:
	.long	1275221417
# s:
	.long	1957218286
# p:
	.long	2083857409
# g:
	.long	223297654
# s:
	.long	1753181007
# p:
	.long	2083746817
# g:
	.long	1866095354
# s:
	.long	730006452
# p:
	.long	2083691521
# g:
	.long	515378753
# s:
	.long	527434380
# p:
	.long	2083673089
# g:
	.long	1245911208
# s:
	.long	1195970538
# p:
	.long	2083608577
# g:
	.long	1061575438
# s:
	.long	26184845
# p:
	.long	2083488769
# g:
	.long	642839045
# s:
	.long	216787326
# p:
	.long	2083424257
# g:
	.long	1827239152
# s:
	.long	2029910117
# p:
	.long	2083304449
# g:
	.long	10507186
# s:
	.long	960682433
# p:
	.long	2083156993
# g:
	.long	49607996
# s:
	.long	1101628495
# p:
	.long	2083147777
# g:
	.long	1941288262
# s:
	.long	1817672306
# p:
	.long	2082779137
# g:
	.long	2050973748
# s:
	.long	1335096265
# p:
	.long	2082742273
# g:
	.long	185212156
# s:
	.long	1917238555
# p:
	.long	2082733057
# g:
	.long	1703372682
# s:
	.long	1814479114
# p:
	.long	2082696193
# g:
	.long	1000306219
# s:
	.long	2020896125
# p:
	.long	2082604033
# g:
	.long	1099703936
# s:
	.long	1043572432
# p:
	.long	2082447361
# g:
	.long	241454129
# s:
	.long	1214489009
# p:
	.long	2082226177
# g:
	.long	88949028
# s:
	.long	2063733860
# p:
	.long	2082198529
# g:
	.long	1925675666
# s:
	.long	590962618
# p:
	.long	2082143233
# g:
	.long	2047846969
# s:
	.long	25528947
# p:
	.long	2082078721
# g:
	.long	1637226588
# s:
	.long	1553112919
# p:
	.long	2081995777
# g:
	.long	538309598
# s:
	.long	1349293326
# p:
	.long	2081968129
# g:
	.long	1182336690
# s:
	.long	1007817075
# p:
	.long	2081940481
# g:
	.long	959404265
# s:
	.long	57735380
# p:
	.long	2081857537
# g:
	.long	1402372835
# s:
	.long	1071874249
# p:
	.long	2081664001
# g:
	.long	1699123108
# s:
	.long	1595009869
# p:
	.long	2081534977
# g:
	.long	1516531378
# s:
	.long	212513114
# p:
	.long	2081387521
# g:
	.long	574843571
# s:
	.long	890030302
# p:
	.long	2081369089
# g:
	.long	818492967
# s:
	.long	1033649000
# p:
	.long	2081350657
# g:
	.long	273717406
# s:
	.long	1197364362
# p:
	.long	2081295361
# g:
	.long	133307624
# s:
	.long	110371312
# p:
	.long	2081258497
# g:
	.long	682708178
# s:
	.long	920771712
# p:
	.long	2081221633
# g:
	.long	1295004023
# s:
	.long	1110404781
# p:
	.long	2081175553
# g:
	.long	1014655386
# s:
	.long	1062578317
# p:
	.long	2081166337
# g:
	.long	423531999
# s:
	.long	1938939086
# p:
	.long	2081083393
# g:
	.long	1726879882
# s:
	.long	1303706289
# p:
	.long	2081064961
# g:
	.long	287609814
# s:
	.long	2057426466
# p:
	.long	2081046529
# g:
	.long	672786902
# s:
	.long	1248896339
# p:
	.long	2081037313
# g:
	.long	1154476547
# s:
	.long	1594718313
# p:
	.long	2080972801
# g:
	.long	1120639111
# s:
	.long	1745874140
# p:
	.long	2080852993
# g:
	.long	36378637
# s:
	.long	837483871
# p:
	.long	2080806913
# g:
	.long	1780293764
# s:
	.long	1805230383
# p:
	.long	2080788481
# g:
	.long	1923949223
# s:
	.long	2058756800
# p:
	.long	2080760833
# g:
	.long	1080289220
# s:
	.long	1881861705
# p:
	.long	2080668673
# g:
	.long	403122662
# s:
	.long	1677322791
# p:
	.long	2080631809
# g:
	.long	1331938270
# s:
	.long	400271400
# p:
	.long	2080604161
# g:
	.long	1830826514
# s:
	.long	160562603
# p:
	.long	2080530433
# g:
	.long	1809737415
# s:
	.long	1019682328
# p:
	.long	2080465921
# g:
	.long	129584718
# s:
	.long	1988856147
# p:
	.long	2080447489
# g:
	.long	1494748001
# s:
	.long	1525709403
# p:
	.long	2080438273
# g:
	.long	806681232
# s:
	.long	1688828161
# p:
	.long	2080419841
# g:
	.long	559025665
# s:
	.long	487989029
# p:
	.long	2080336897
# g:
	.long	119504773
# s:
	.long	1595647469
# p:
	.long	2080309249
# g:
	.long	533543609
# s:
	.long	1544055890
# p:
	.long	2080281601
# g:
	.long	249543051
# s:
	.long	640453528
# p:
	.long	2080263169
# g:
	.long	1552070469
# s:
	.long	558573537
# p:
	.long	2080152577
# g:
	.long	1676215904
# s:
	.long	541447718
# p:
	.long	2080124929
# g:
	.long	155573011
# s:
	.long	163169861
# p:
	.long	2079959041
# g:
	.long	1025588203
# s:
	.long	1464790063
# p:
	.long	2079866881
# g:
	.long	1628100725
# s:
	.long	1285284058
# p:
	.long	2079691777
# g:
	.long	1180794717
# s:
	.long	1590445772
# p:
	.long	2079664129
# g:
	.long	1906604290
# s:
	.long	1274483203
# p:
	.long	2079618049
# g:
	.long	1290081127
# s:
	.long	2001746963
# p:
	.long	2079507457
# g:
	.long	713492846
# s:
	.long	1827208617
# p:
	.long	2079470593
# g:
	.long	1631476681
# s:
	.long	2029661647
# p:
	.long	2079387649
# g:
	.long	61713505
# s:
	.long	865553435
# p:
	.long	2079369217
# g:
	.long	1382129602
# s:
	.long	409178670
# p:
	.long	2079295489
# g:
	.long	641929319
# s:
	.long	676205706
# p:
	.long	2079148033
# g:
	.long	51725626
# s:
	.long	1961790831
# p:
	.long	2079065089
# g:
	.long	1424616373
# s:
	.long	540142226
# p:
	.long	2078991361
# g:
	.long	2056340932
# s:
	.long	111662571
# p:
	.long	2078899201
# g:
	.long	1775153153
# s:
	.long	187613491
# p:
	.long	2078834689
# g:
	.long	1308531894
# s:
	.long	1400707840
# p:
	.long	2078788609
# g:
	.long	74171936
# s:
	.long	2023572496
# p:
	.long	2078714881
# g:
	.long	710870815
# s:
	.long	1031349525
# p:
	.long	2078631937
# g:
	.long	883395201
# s:
	.long	412913589
# p:
	.long	2078419969
# g:
	.long	1166166092
# s:
	.long	1454010080
# p:
	.long	2078281729
# g:
	.long	1115002367
# s:
	.long	1345413198
# p:
	.long	2078254081
# g:
	.long	1444393534
# s:
	.long	186893596
# p:
	.long	2077996033
# g:
	.long	1912574351
# s:
	.long	1845058822
# p:
	.long	2077931521
# g:
	.long	1474837382
# s:
	.long	1247353077
# p:
	.long	2077903873
# g:
	.long	1114781230
# s:
	.long	635920054
# p:
	.long	2077885441
# g:
	.long	1036114530
# s:
	.long	636717063
# p:
	.long	2077820929
# g:
	.long	1278430876
# s:
	.long	563747105
# p:
	.long	2077793281
# g:
	.long	203294611
# s:
	.long	420247729
# p:
	.long	2077728769
# g:
	.long	142216248
# s:
	.long	1108465544
# p:
	.long	2077664257
# g:
	.long	254454125
# s:
	.long	598344859
# p:
	.long	2077562881
# g:
	.long	81592048
# s:
	.long	1669632763
# p:
	.long	2077258753
# g:
	.long	1260990282
# s:
	.long	345459579
# p:
	.long	2077194241
# g:
	.long	2013275868
# s:
	.long	772481873
# p:
	.long	2077157377
# g:
	.long	1004261248
# s:
	.long	1377021309
# p:
	.long	2077129729
# g:
	.long	933116108
# s:
	.long	1625433195
# p:
	.long	2077111297
# g:
	.long	1233003293
# s:
	.long	221315789
# p:
	.long	2077083649
# g:
	.long	1885054701
# s:
	.long	630085941
# p:
	.long	2077037569
# g:
	.long	584763138
# s:
	.long	1381467240
# p:
	.long	2076926977
# g:
	.long	1214954884
# s:
	.long	444605445
# p:
	.long	2076797953
# g:
	.long	1880423951
# s:
	.long	1443373264
# p:
	.long	2076733441
# g:
	.long	771236114
# s:
	.long	966328111
# p:
	.long	2076705793
# g:
	.long	1077442011
# s:
	.long	2038110365
# p:
	.long	2076650497
# g:
	.long	461765025
# s:
	.long	1292291721
# p:
	.long	2076595201
# g:
	.long	103100591
# s:
	.long	182569749
# p:
	.long	2076503041
# g:
	.long	423874271
# s:
	.long	1104653112
# p:
	.long	2076484609
# g:
	.long	595509290
# s:
	.long	1708728563
# p:
	.long	2076456961
# g:
	.long	1591582196
# s:
	.long	1671872181
# p:
	.long	2076392449
# g:
	.long	813965347
# s:
	.long	184615220
# p:
	.long	2076272641
# g:
	.long	1155217820
# s:
	.long	856694213
# p:
	.long	2076254209
# g:
	.long	1055001331
# s:
	.long	302551962
# p:
	.long	2076244993
# g:
	.long	205139967
# s:
	.long	674798443
# p:
	.long	2076189697
# g:
	.long	1749674831
# s:
	.long	2009095920
# p:
	.long	2076143617
# g:
	.long	125553221
# s:
	.long	1108246091
# p:
	.long	2076115969
# g:
	.long	1795035411
# s:
	.long	804272132
# p:
	.long	2076097537
# g:
	.long	1763350900
# s:
	.long	1361842947
# p:
	.long	2075996161
# g:
	.long	2010143262
# s:
	.long	607884403
# p:
	.long	2075765761
# g:
	.long	342910912
# s:
	.long	1475683707
# p:
	.long	2075636737
# g:
	.long	1324077027
# s:
	.long	2031911375
# p:
	.long	2075609089
# g:
	.long	624588897
# s:
	.long	1864298641
# p:
	.long	2075544577
# g:
	.long	1120710235
# s:
	.long	667734928
# p:
	.long	2075535361
# g:
	.long	220428777
# s:
	.long	669572672
# p:
	.long	2075489281
# g:
	.long	1977959538
# s:
	.long	1560246812
# p:
	.long	2075415553
# g:
	.long	13757254
# s:
	.long	1647168942
# p:
	.long	2075406337
# g:
	.long	1190802639
# s:
	.long	58854762
# p:
	.long	2075378689
# g:
	.long	827414403
# s:
	.long	912680236
# p:
	.long	2075369473
# g:
	.long	1738167802
# s:
	.long	314377531
# p:
	.long	2075240449
# g:
	.long	657349636
# s:
	.long	1956325524
# p:
	.long	2075185153
# g:
	.long	1948189610
# s:
	.long	1782960894
# p:
	.long	2075166721
# g:
	.long	1875826290
# s:
	.long	1414486482
# p:
	.long	2074954753
# g:
	.long	1903405986
# s:
	.long	1488161743
# p:
	.long	2074936321
# g:
	.long	219585054
# s:
	.long	955340273
# p:
	.long	2074871809
# g:
	.long	1697632238
# s:
	.long	1240742690
# p:
	.long	2074807297
# g:
	.long	671965209
# s:
	.long	1072909740
# p:
	.long	2074678273
# g:
	.long	503652766
# s:
	.long	1287426009
# p:
	.long	2074576897
# g:
	.long	368918986
# s:
	.long	1266234693
# p:
	.long	2074457089
# g:
	.long	1592455638
# s:
	.long	573348021
# p:
	.long	2074392577
# g:
	.long	1915276250
# s:
	.long	387264228
# p:
	.long	2074383361
# g:
	.long	1835264967
# s:
	.long	1211583139
# p:
	.long	2074152961
# g:
	.long	1527986733
# s:
	.long	1159290669
# p:
	.long	2074134529
# g:
	.long	1684642686
# s:
	.long	293628678
# p:
	.long	2074060801
# g:
	.long	600425178
# s:
	.long	41398837
# p:
	.long	2073950209
# g:
	.long	1621787062
# s:
	.long	127367350
# p:
	.long	2073931777
# g:
	.long	149980305
# s:
	.long	1566213032
# p:
	.long	2073858049
# g:
	.long	1814351981
# s:
	.long	1320463568
# p:
	.long	2073756673
# g:
	.long	1964640535
# s:
	.long	1576228894
# p:
	.long	2073738241
# g:
	.long	1664370947
# s:
	.long	498121883
# p:
	.long	2073618433
# g:
	.long	1792483280
# s:
	.long	403789290
# p:
	.long	2073609217
# g:
	.long	33559216
# s:
	.long	553628744
# p:
	.long	2073535489
# g:
	.long	588431716
# s:
	.long	1124500400
# p:
	.long	2073443329
# g:
	.long	608339915
# s:
	.long	783524392
# p:
	.long	2073434113
# g:
	.long	1391998139
# s:
	.long	889196389
# p:
	.long	2073424897
# g:
	.long	1632856579
# s:
	.long	1892180580
# p:
	.long	2073378817
# g:
	.long	1768174921
# s:
	.long	2014756922
# p:
	.long	2073305089
# g:
	.long	862397296
# s:
	.long	838046676
# p:
	.long	2073240577
# g:
	.long	1654167082
# s:
	.long	1866221587
# p:
	.long	2073185281
# g:
	.long	507971900
# s:
	.long	1623488831
# p:
	.long	2073111553
# g:
	.long	1137776885
# s:
	.long	309642139
# p:
	.long	2073102337
# g:
	.long	1737832792
# s:
	.long	1989483169
# p:
	.long	2073028609
# g:
	.long	116975045
# s:
	.long	1956049060
# p:
	.long	2073019393
# g:
	.long	59741958
# s:
	.long	543311911
# p:
	.long	2072973313
# g:
	.long	338014095
# s:
	.long	2057710457
# p:
	.long	2072862721
# g:
	.long	15834870
# s:
	.long	1612914839
# p:
	.long	2072825857
# g:
	.long	1557552800
# s:
	.long	1248908871
# p:
	.long	2072798209
# g:
	.long	1733777098
# s:
	.long	390705335
# p:
	.long	2072632321
# g:
	.long	1670587583
# s:
	.long	846715667
# p:
	.long	2072604673
# g:
	.long	1605267431
# s:
	.long	237660
# p:
	.long	2072540161
# g:
	.long	175399208
# s:
	.long	1770247709
# p:
	.long	2072475649
# g:
	.long	655429763
# s:
	.long	963265886
# p:
	.long	2072355841
# g:
	.long	1604244395
# s:
	.long	440473803
# p:
	.long	2072272897
# g:
	.long	1954247082
# s:
	.long	801306376
# p:
	.long	2072014849
# g:
	.long	1829768725
# s:
	.long	115945552
# p:
	.long	2071959553
# g:
	.long	853541630
# s:
	.long	1291600290
# p:
	.long	2071950337
# g:
	.long	194283619
# s:
	.long	125023092
# p:
	.long	2071941121
# g:
	.long	9358535
# s:
	.long	1981563973
# p:
	.long	2071756801
# g:
	.long	597925765
# s:
	.long	227071015
# p:
	.long	2071738369
# g:
	.long	1118833694
# s:
	.long	770359736
# p:
	.long	2071710721
# g:
	.long	653593440
# s:
	.long	695376499
# p:
	.long	2071683073
# g:
	.long	632900693
# s:
	.long	1133477175
# p:
	.long	2071544833
# g:
	.long	486261671
# s:
	.long	1516246386
# p:
	.long	2071507969
# g:
	.long	1628878225
# s:
	.long	478089136
# p:
	.long	2071480321
# g:
	.long	677405993
# s:
	.long	1543879685
# p:
	.long	2071415809
# g:
	.long	1478365957
# s:
	.long	718104578
# p:
	.long	2071360513
# g:
	.long	1384425492
# s:
	.long	486605923
# p:
	.long	2071093249
# g:
	.long	1441945139
# s:
	.long	339115618
# p:
	.long	2071037953
# g:
	.long	1771674733
# s:
	.long	74636550
# p:
	.long	2070936577
# g:
	.long	1031779139
# s:
	.long	1593018160
# p:
	.long	2070844417
# g:
	.long	297350337
# s:
	.long	700889695
# p:
	.long	2070743041
# g:
	.long	1269467398
# s:
	.long	1188672983
# p:
	.long	2070715393
# g:
	.long	1305821865
# s:
	.long	634606382
# p:
	.long	0
# g:
	.long	0
# s:
	.long	0
	.align 32
	.type	PRIMES2, @object
	.size	PRIMES2, 6264
PRIMES2:
# p:
	.long	2147473409
# g:
	.long	383167813
# s:
	.long	10239
# p:
	.long	2147389441
# g:
	.long	211808905
# s:
	.long	471403745
# p:
	.long	2147387393
# g:
	.long	37672282
# s:
	.long	1329335065
# p:
	.long	2147377153
# g:
	.long	1977035326
# s:
	.long	968223422
# p:
	.long	2147358721
# g:
	.long	1067163706
# s:
	.long	132460015
# p:
	.long	2147352577
# g:
	.long	1606082042
# s:
	.long	598693809
# p:
	.long	2147346433
# g:
	.long	2033915641
# s:
	.long	1056257184
# p:
	.long	2147338241
# g:
	.long	1653770625
# s:
	.long	421286710
# p:
	.long	2147309569
# g:
	.long	631200819
# s:
	.long	1111201074
# p:
	.long	2147297281
# g:
	.long	2038364663
# s:
	.long	1042003613
# p:
	.long	2147295233
# g:
	.long	1962540515
# s:
	.long	19440033
# p:
	.long	2147239937
# g:
	.long	2100082663
# s:
	.long	353296760
# p:
	.long	2147235841
# g:
	.long	1991153006
# s:
	.long	1703918027
# p:
	.long	2147217409
# g:
	.long	516405114
# s:
	.long	1258919613
# p:
	.long	2147205121
# g:
	.long	409347988
# s:
	.long	1089726929
# p:
	.long	2147196929
# g:
	.long	927788991
# s:
	.long	1946238668
# p:
	.long	2147178497
# g:
	.long	1136922411
# s:
	.long	1347028164
# p:
	.long	2147100673
# g:
	.long	868626236
# s:
	.long	701164723
# p:
	.long	2147082241
# g:
	.long	1897279176
# s:
	.long	617820870
# p:
	.long	2147074049
# g:
	.long	1888819123
# s:
	.long	158382189
# p:
	.long	2147051521
# g:
	.long	25006327
# s:
	.long	522758543
# p:
	.long	2147043329
# g:
	.long	327546255
# s:
	.long	37227845
# p:
	.long	2147039233
# g:
	.long	766324424
# s:
	.long	1133356428
# p:
	.long	2146988033
# g:
	.long	1862817362
# s:
	.long	73861329
# p:
	.long	2146963457
# g:
	.long	404622040
# s:
	.long	653019435
# p:
	.long	2146959361
# g:
	.long	1936581214
# s:
	.long	995143093
# p:
	.long	2146938881
# g:
	.long	1559770096
# s:
	.long	634921513
# p:
	.long	2146908161
# g:
	.long	422623708
# s:
	.long	1985060172
# p:
	.long	2146885633
# g:
	.long	1751189170
# s:
	.long	298238186
# p:
	.long	2146871297
# g:
	.long	578919515
# s:
	.long	291810829
# p:
	.long	2146846721
# g:
	.long	1114060353
# s:
	.long	915902322
# p:
	.long	2146834433
# g:
	.long	2069565474
# s:
	.long	47859524
# p:
	.long	2146818049
# g:
	.long	1552824584
# s:
	.long	646281055
# p:
	.long	2146775041
# g:
	.long	1906267847
# s:
	.long	1597832891
# p:
	.long	2146756609
# g:
	.long	1847414714
# s:
	.long	1228090888
# p:
	.long	2146744321
# g:
	.long	1818792070
# s:
	.long	1176377637
# p:
	.long	2146738177
# g:
	.long	1118066398
# s:
	.long	1054971214
# p:
	.long	2146736129
# g:
	.long	52057278
# s:
	.long	933422153
# p:
	.long	2146713601
# g:
	.long	592259376
# s:
	.long	1406621510
# p:
	.long	2146695169
# g:
	.long	263161877
# s:
	.long	1514178701
# p:
	.long	2146656257
# g:
	.long	685363115
# s:
	.long	384505091
# p:
	.long	2146650113
# g:
	.long	927727032
# s:
	.long	537575289
# p:
	.long	2146646017
# g:
	.long	52575506
# s:
	.long	1799464037
# p:
	.long	2146643969
# g:
	.long	1276803876
# s:
	.long	1348954416
# p:
	.long	2146603009
# g:
	.long	814028633
# s:
	.long	1521547704
# p:
	.long	2146572289
# g:
	.long	1846678872
# s:
	.long	1310832121
# p:
	.long	2146547713
# g:
	.long	919368090
# s:
	.long	1019041349
# p:
	.long	2146508801
# g:
	.long	671847612
# s:
	.long	38582496
# p:
	.long	2146492417
# g:
	.long	283911680
# s:
	.long	532424562
# p:
	.long	2146490369
# g:
	.long	1780044827
# s:
	.long	896447978
# p:
	.long	2146459649
# g:
	.long	327980850
# s:
	.long	1327906900
# p:
	.long	2146447361
# g:
	.long	1310561493
# s:
	.long	958645253
# p:
	.long	2146441217
# g:
	.long	412148926
# s:
	.long	287271128
# p:
	.long	2146437121
# g:
	.long	293186449
# s:
	.long	2009822534
# p:
	.long	2146430977
# g:
	.long	179034356
# s:
	.long	1359155584
# p:
	.long	2146418689
# g:
	.long	1517345488
# s:
	.long	1790248672
# p:
	.long	2146406401
# g:
	.long	1615820390
# s:
	.long	1584833571
# p:
	.long	2146404353
# g:
	.long	826651445
# s:
	.long	607120498
# p:
	.long	2146379777
# g:
	.long	3816988
# s:
	.long	1897049071
# p:
	.long	2146363393
# g:
	.long	1221409784
# s:
	.long	1986921567
# p:
	.long	2146355201
# g:
	.long	1388081168
# s:
	.long	849968120
# p:
	.long	2146336769
# g:
	.long	1803473237
# s:
	.long	1655544036
# p:
	.long	2146312193
# g:
	.long	1023484977
# s:
	.long	273671831
# p:
	.long	2146293761
# g:
	.long	1074591448
# s:
	.long	467406983
# p:
	.long	2146283521
# g:
	.long	831604668
# s:
	.long	1523950494
# p:
	.long	2146203649
# g:
	.long	712865423
# s:
	.long	1170834574
# p:
	.long	2146154497
# g:
	.long	1764991362
# s:
	.long	1064856763
# p:
	.long	2146142209
# g:
	.long	627386213
# s:
	.long	1406840151
# p:
	.long	2146127873
# g:
	.long	1638674429
# s:
	.long	2088393537
# p:
	.long	2146099201
# g:
	.long	1516001018
# s:
	.long	690673370
# p:
	.long	2146093057
# g:
	.long	1294931393
# s:
	.long	315136610
# p:
	.long	2146091009
# g:
	.long	1942399533
# s:
	.long	973539425
# p:
	.long	2146078721
# g:
	.long	1843461814
# s:
	.long	2132275436
# p:
	.long	2146060289
# g:
	.long	1098740778
# s:
	.long	360423481
# p:
	.long	2146048001
# g:
	.long	1617213232
# s:
	.long	1951981294
# p:
	.long	2146041857
# g:
	.long	1805783169
# s:
	.long	2075683489
# p:
	.long	2146019329
# g:
	.long	272027909
# s:
	.long	1753219918
# p:
	.long	2145986561
# g:
	.long	1206530344
# s:
	.long	2034028118
# p:
	.long	2145976321
# g:
	.long	1243769360
# s:
	.long	1173377644
# p:
	.long	2145964033
# g:
	.long	887200839
# s:
	.long	1281344586
# p:
	.long	2145906689
# g:
	.long	1651026455
# s:
	.long	906178216
# p:
	.long	2145875969
# g:
	.long	1673238256
# s:
	.long	1043521212
# p:
	.long	2145871873
# g:
	.long	1226591210
# s:
	.long	1399796492
# p:
	.long	2145841153
# g:
	.long	1465353397
# s:
	.long	1324527802
# p:
	.long	2145832961
# g:
	.long	1150638905
# s:
	.long	554084759
# p:
	.long	2145816577
# g:
	.long	221601706
# s:
	.long	427340863
# p:
	.long	2145785857
# g:
	.long	608896761
# s:
	.long	316590738
# p:
	.long	2145755137
# g:
	.long	1712054942
# s:
	.long	1684294304
# p:
	.long	2145742849
# g:
	.long	1302302867
# s:
	.long	724873116
# p:
	.long	2145728513
# g:
	.long	516717693
# s:
	.long	431671476
# p:
	.long	2145699841
# g:
	.long	524575579
# s:
	.long	1619722537
# p:
	.long	2145691649
# g:
	.long	1925625239
# s:
	.long	982974435
# p:
	.long	2145687553
# g:
	.long	463795662
# s:
	.long	1293154300
# p:
	.long	2145673217
# g:
	.long	771716636
# s:
	.long	881778029
# p:
	.long	2145630209
# g:
	.long	1509556977
# s:
	.long	837364988
# p:
	.long	2145595393
# g:
	.long	229091856
# s:
	.long	851648427
# p:
	.long	2145587201
# g:
	.long	1796903241
# s:
	.long	635342424
# p:
	.long	2145525761
# g:
	.long	715310882
# s:
	.long	1677228081
# p:
	.long	2145495041
# g:
	.long	1040930522
# s:
	.long	200685896
# p:
	.long	2145466369
# g:
	.long	949804237
# s:
	.long	1809146322
# p:
	.long	2145445889
# g:
	.long	1673903706
# s:
	.long	95316881
# p:
	.long	2145390593
# g:
	.long	806941852
# s:
	.long	1428671135
# p:
	.long	2145372161
# g:
	.long	1402525292
# s:
	.long	159350694
# p:
	.long	2145361921
# g:
	.long	2124760298
# s:
	.long	1589134749
# p:
	.long	2145359873
# g:
	.long	1217503067
# s:
	.long	1561543010
# p:
	.long	2145355777
# g:
	.long	338341402
# s:
	.long	83865711
# p:
	.long	2145343489
# g:
	.long	1381532164
# s:
	.long	641430002
# p:
	.long	2145325057
# g:
	.long	1883895478
# s:
	.long	1528469895
# p:
	.long	2145318913
# g:
	.long	1335370424
# s:
	.long	65809740
# p:
	.long	2145312769
# g:
	.long	2000008042
# s:
	.long	1919775760
# p:
	.long	2145300481
# g:
	.long	961450962
# s:
	.long	1229540578
# p:
	.long	2145282049
# g:
	.long	910466767
# s:
	.long	1964062701
# p:
	.long	2145232897
# g:
	.long	816527501
# s:
	.long	450152063
# p:
	.long	2145218561
# g:
	.long	1435128058
# s:
	.long	1794509700
# p:
	.long	2145187841
# g:
	.long	33505311
# s:
	.long	1272467582
# p:
	.long	2145181697
# g:
	.long	269767433
# s:
	.long	1380363849
# p:
	.long	2145175553
# g:
	.long	56386299
# s:
	.long	1316870546
# p:
	.long	2145079297
# g:
	.long	2106880293
# s:
	.long	1391797340
# p:
	.long	2145021953
# g:
	.long	1347906152
# s:
	.long	720510798
# p:
	.long	2145015809
# g:
	.long	206769262
# s:
	.long	1651459955
# p:
	.long	2145003521
# g:
	.long	1885513236
# s:
	.long	1393381284
# p:
	.long	2144960513
# g:
	.long	1810381315
# s:
	.long	31937275
# p:
	.long	2144944129
# g:
	.long	1306487838
# s:
	.long	2019419520
# p:
	.long	2144935937
# g:
	.long	37304730
# s:
	.long	1841489054
# p:
	.long	2144894977
# g:
	.long	1601434616
# s:
	.long	157985831
# p:
	.long	2144888833
# g:
	.long	98749330
# s:
	.long	2128592228
# p:
	.long	2144880641
# g:
	.long	1772327002
# s:
	.long	2076128344
# p:
	.long	2144864257
# g:
	.long	1404514762
# s:
	.long	2029969964
# p:
	.long	2144827393
# g:
	.long	801236594
# s:
	.long	406627220
# p:
	.long	2144806913
# g:
	.long	349217443
# s:
	.long	1501080290
# p:
	.long	2144796673
# g:
	.long	1542656776
# s:
	.long	2084736519
# p:
	.long	2144778241
# g:
	.long	1210734884
# s:
	.long	1746416203
# p:
	.long	2144759809
# g:
	.long	1146598851
# s:
	.long	716464489
# p:
	.long	2144757761
# g:
	.long	286328400
# s:
	.long	1823728177
# p:
	.long	2144729089
# g:
	.long	1347555695
# s:
	.long	1836644881
# p:
	.long	2144727041
# g:
	.long	1795703790
# s:
	.long	520296412
# p:
	.long	2144696321
# g:
	.long	1302475157
# s:
	.long	852964281
# p:
	.long	2144667649
# g:
	.long	1075877614
# s:
	.long	504992927
# p:
	.long	2144573441
# g:
	.long	198765808
# s:
	.long	1617144982
# p:
	.long	2144555009
# g:
	.long	321528767
# s:
	.long	155821259
# p:
	.long	2144550913
# g:
	.long	814139516
# s:
	.long	1819937644
# p:
	.long	2144536577
# g:
	.long	571143206
# s:
	.long	962942255
# p:
	.long	2144524289
# g:
	.long	1746733766
# s:
	.long	2471321
# p:
	.long	2144512001
# g:
	.long	1821415077
# s:
	.long	124190939
# p:
	.long	2144468993
# g:
	.long	917871546
# s:
	.long	1260072806
# p:
	.long	2144458753
# g:
	.long	378417981
# s:
	.long	1569240563
# p:
	.long	2144421889
# g:
	.long	175229668
# s:
	.long	1825620763
# p:
	.long	2144409601
# g:
	.long	1699216963
# s:
	.long	351648117
# p:
	.long	2144370689
# g:
	.long	1071885991
# s:
	.long	958186029
# p:
	.long	2144348161
# g:
	.long	1763151227
# s:
	.long	540353574
# p:
	.long	2144335873
# g:
	.long	1060214804
# s:
	.long	919598847
# p:
	.long	2144329729
# g:
	.long	663515846
# s:
	.long	1448552668
# p:
	.long	2144327681
# g:
	.long	1057776305
# s:
	.long	590222840
# p:
	.long	2144309249
# g:
	.long	1705149168
# s:
	.long	1459294624
# p:
	.long	2144296961
# g:
	.long	325823721
# s:
	.long	1649016934
# p:
	.long	2144290817
# g:
	.long	738775789
# s:
	.long	447427206
# p:
	.long	2144243713
# g:
	.long	962347618
# s:
	.long	893050215
# p:
	.long	2144237569
# g:
	.long	1655257077
# s:
	.long	900860862
# p:
	.long	2144161793
# g:
	.long	242206694
# s:
	.long	1567868672
# p:
	.long	2144155649
# g:
	.long	769415308
# s:
	.long	1247993134
# p:
	.long	2144137217
# g:
	.long	320492023
# s:
	.long	515841070
# p:
	.long	2144120833
# g:
	.long	1639388522
# s:
	.long	770877302
# p:
	.long	2144071681
# g:
	.long	1761785233
# s:
	.long	964296120
# p:
	.long	2144065537
# g:
	.long	419817825
# s:
	.long	204564472
# p:
	.long	2144028673
# g:
	.long	666050597
# s:
	.long	2091019760
# p:
	.long	2144010241
# g:
	.long	1413657615
# s:
	.long	1518702610
# p:
	.long	2143952897
# g:
	.long	1238327946
# s:
	.long	475672271
# p:
	.long	2143940609
# g:
	.long	307063413
# s:
	.long	1176750846
# p:
	.long	2143918081
# g:
	.long	2062905559
# s:
	.long	786785803
# p:
	.long	2143899649
# g:
	.long	1338112849
# s:
	.long	1562292083
# p:
	.long	2143891457
# g:
	.long	68149545
# s:
	.long	87166451
# p:
	.long	2143885313
# g:
	.long	921750778
# s:
	.long	394460854
# p:
	.long	2143854593
# g:
	.long	719766593
# s:
	.long	133877196
# p:
	.long	2143836161
# g:
	.long	1149399850
# s:
	.long	1861591875
# p:
	.long	2143762433
# g:
	.long	1848739366
# s:
	.long	1335934145
# p:
	.long	2143756289
# g:
	.long	1326674710
# s:
	.long	102999236
# p:
	.long	2143713281
# g:
	.long	808061791
# s:
	.long	1156900308
# p:
	.long	2143690753
# g:
	.long	388399459
# s:
	.long	1926468019
# p:
	.long	2143670273
# g:
	.long	1427891374
# s:
	.long	1756689401
# p:
	.long	2143666177
# g:
	.long	1912173949
# s:
	.long	986629565
# p:
	.long	2143645697
# g:
	.long	2041160111
# s:
	.long	371842865
# p:
	.long	2143641601
# g:
	.long	1279906897
# s:
	.long	2023974350
# p:
	.long	2143635457
# g:
	.long	720473174
# s:
	.long	1389027526
# p:
	.long	2143621121
# g:
	.long	1298309455
# s:
	.long	1732632006
# p:
	.long	2143598593
# g:
	.long	1548762216
# s:
	.long	1825417506
# p:
	.long	2143567873
# g:
	.long	620475784
# s:
	.long	1073787233
# p:
	.long	2143561729
# g:
	.long	1932954575
# s:
	.long	949167309
# p:
	.long	2143553537
# g:
	.long	354315656
# s:
	.long	1652037534
# p:
	.long	2143541249
# g:
	.long	577424288
# s:
	.long	1097027618
# p:
	.long	2143531009
# g:
	.long	357862822
# s:
	.long	478640055
# p:
	.long	2143522817
# g:
	.long	2017706025
# s:
	.long	1550531668
# p:
	.long	2143506433
# g:
	.long	2078127419
# s:
	.long	1824320165
# p:
	.long	2143488001
# g:
	.long	613475285
# s:
	.long	1604011510
# p:
	.long	2143469569
# g:
	.long	1466594987
# s:
	.long	502095196
# p:
	.long	2143426561
# g:
	.long	1115430331
# s:
	.long	1044637111
# p:
	.long	2143383553
# g:
	.long	9778045
# s:
	.long	1902463734
# p:
	.long	2143377409
# g:
	.long	1557401276
# s:
	.long	2056861771
# p:
	.long	2143363073
# g:
	.long	652036455
# s:
	.long	1965915971
# p:
	.long	2143260673
# g:
	.long	1464581171
# s:
	.long	1523257541
# p:
	.long	2143246337
# g:
	.long	1876119649
# s:
	.long	764541916
# p:
	.long	2143209473
# g:
	.long	1614992673
# s:
	.long	1920672844
# p:
	.long	2143203329
# g:
	.long	981052047
# s:
	.long	2049774209
# p:
	.long	2143160321
# g:
	.long	1847355533
# s:
	.long	728535665
# p:
	.long	2143129601
# g:
	.long	965558457
# s:
	.long	603052992
# p:
	.long	2143123457
# g:
	.long	2140817191
# s:
	.long	8348679
# p:
	.long	2143100929
# g:
	.long	1547263683
# s:
	.long	694209023
# p:
	.long	2143092737
# g:
	.long	643459066
# s:
	.long	1979934533
# p:
	.long	2143082497
# g:
	.long	188603778
# s:
	.long	2026175670
# p:
	.long	2143062017
# g:
	.long	1657329695
# s:
	.long	377451099
# p:
	.long	2143051777
# g:
	.long	114967950
# s:
	.long	979255473
# p:
	.long	2143025153
# g:
	.long	1698431342
# s:
	.long	1449196896
# p:
	.long	2143006721
# g:
	.long	1862741675
# s:
	.long	1739650365
# p:
	.long	2142996481
# g:
	.long	756660457
# s:
	.long	996160050
# p:
	.long	2142976001
# g:
	.long	927864010
# s:
	.long	1166847574
# p:
	.long	2142965761
# g:
	.long	905070557
# s:
	.long	661974566
# p:
	.long	2142916609
# g:
	.long	40932754
# s:
	.long	1787161127
# p:
	.long	2142892033
# g:
	.long	1987985648
# s:
	.long	675335382
# p:
	.long	2142885889
# g:
	.long	797497211
# s:
	.long	1323096997
# p:
	.long	2142871553
# g:
	.long	2068025830
# s:
	.long	1411877159
# p:
	.long	2142861313
# g:
	.long	1217177090
# s:
	.long	1438410687
# p:
	.long	2142830593
# g:
	.long	409906375
# s:
	.long	1767860634
# p:
	.long	2142803969
# g:
	.long	1197788993
# s:
	.long	359782919
# p:
	.long	2142785537
# g:
	.long	643817365
# s:
	.long	513932862
# p:
	.long	2142779393
# g:
	.long	1717046338
# s:
	.long	218943121
# p:
	.long	2142724097
# g:
	.long	89336830
# s:
	.long	416687049
# p:
	.long	2142707713
# g:
	.long	5944581
# s:
	.long	1356813523
# p:
	.long	2142658561
# g:
	.long	887942135
# s:
	.long	2074011722
# p:
	.long	2142638081
# g:
	.long	151851972
# s:
	.long	1647339939
# p:
	.long	2142564353
# g:
	.long	1691505537
# s:
	.long	1483107336
# p:
	.long	2142533633
# g:
	.long	1989920200
# s:
	.long	1135938817
# p:
	.long	2142529537
# g:
	.long	959263126
# s:
	.long	1531961857
# p:
	.long	2142527489
# g:
	.long	453251129
# s:
	.long	1725566162
# p:
	.long	2142502913
# g:
	.long	1536028102
# s:
	.long	182053257
# p:
	.long	2142498817
# g:
	.long	570138730
# s:
	.long	701443447
# p:
	.long	2142416897
# g:
	.long	326965800
# s:
	.long	411931819
# p:
	.long	2142363649
# g:
	.long	1675665410
# s:
	.long	1517191733
# p:
	.long	2142351361
# g:
	.long	968529566
# s:
	.long	1575712703
# p:
	.long	2142330881
# g:
	.long	1384953238
# s:
	.long	1769087884
# p:
	.long	2142314497
# g:
	.long	1977173242
# s:
	.long	1833745524
# p:
	.long	2142289921
# g:
	.long	95082313
# s:
	.long	1714775493
# p:
	.long	2142283777
# g:
	.long	109377615
# s:
	.long	1070584533
# p:
	.long	2142277633
# g:
	.long	16960510
# s:
	.long	702157145
# p:
	.long	2142263297
# g:
	.long	553850819
# s:
	.long	431364395
# p:
	.long	2142208001
# g:
	.long	241466367
# s:
	.long	2053967982
# p:
	.long	2142164993
# g:
	.long	1795661326
# s:
	.long	1031836848
# p:
	.long	2142097409
# g:
	.long	1212530046
# s:
	.long	712772031
# p:
	.long	2142087169
# g:
	.long	1763869720
# s:
	.long	822276067
# p:
	.long	2142078977
# g:
	.long	644065713
# s:
	.long	1765268066
# p:
	.long	2142074881
# g:
	.long	112671944
# s:
	.long	643204925
# p:
	.long	2142044161
# g:
	.long	1387785471
# s:
	.long	1297890174
# p:
	.long	2142025729
# g:
	.long	783885537
# s:
	.long	1000425730
# p:
	.long	2142011393
# g:
	.long	905662232
# s:
	.long	1679401033
# p:
	.long	2141974529
# g:
	.long	799788433
# s:
	.long	468119557
# p:
	.long	2141943809
# g:
	.long	1932544124
# s:
	.long	449305555
# p:
	.long	2141933569
# g:
	.long	1527403256
# s:
	.long	841867925
# p:
	.long	2141931521
# g:
	.long	1247076451
# s:
	.long	743823916
# p:
	.long	2141902849
# g:
	.long	1199660531
# s:
	.long	401687910
# p:
	.long	2141890561
# g:
	.long	150132350
# s:
	.long	1720336972
# p:
	.long	2141857793
# g:
	.long	1287438162
# s:
	.long	663880489
# p:
	.long	2141833217
# g:
	.long	618017731
# s:
	.long	1819208266
# p:
	.long	2141820929
# g:
	.long	999578638
# s:
	.long	1403090096
# p:
	.long	2141786113
# g:
	.long	81834325
# s:
	.long	1523542501
# p:
	.long	2141771777
# g:
	.long	120001928
# s:
	.long	463556492
# p:
	.long	2141759489
# g:
	.long	122455485
# s:
	.long	2124928282
# p:
	.long	2141749249
# g:
	.long	141986041
# s:
	.long	940339153
# p:
	.long	2141685761
# g:
	.long	889088734
# s:
	.long	477141499
# p:
	.long	2141673473
# g:
	.long	324212681
# s:
	.long	1122558298
# p:
	.long	2141669377
# g:
	.long	1175806187
# s:
	.long	1373818177
# p:
	.long	2141655041
# g:
	.long	1113654822
# s:
	.long	296887082
# p:
	.long	2141587457
# g:
	.long	991103258
# s:
	.long	1585913875
# p:
	.long	2141583361
# g:
	.long	1401451409
# s:
	.long	1802457360
# p:
	.long	2141575169
# g:
	.long	1571977166
# s:
	.long	712760980
# p:
	.long	2141546497
# g:
	.long	1107849376
# s:
	.long	1250270109
# p:
	.long	2141515777
# g:
	.long	196544219
# s:
	.long	356001130
# p:
	.long	2141495297
# g:
	.long	1733571506
# s:
	.long	1060744866
# p:
	.long	2141483009
# g:
	.long	321552363
# s:
	.long	1168297026
# p:
	.long	2141458433
# g:
	.long	505818251
# s:
	.long	733225819
# p:
	.long	2141360129
# g:
	.long	1026840098
# s:
	.long	948342276
# p:
	.long	2141325313
# g:
	.long	945133744
# s:
	.long	2129965998
# p:
	.long	2141317121
# g:
	.long	1871100260
# s:
	.long	1843844634
# p:
	.long	2141286401
# g:
	.long	1790639498
# s:
	.long	1750465696
# p:
	.long	2141267969
# g:
	.long	1376858592
# s:
	.long	186160720
# p:
	.long	2141255681
# g:
	.long	2129698296
# s:
	.long	1876677959
# p:
	.long	2141243393
# g:
	.long	2138900688
# s:
	.long	1340009628
# p:
	.long	2141214721
# g:
	.long	1933049835
# s:
	.long	1087819477
# p:
	.long	2141212673
# g:
	.long	1898664939
# s:
	.long	1786328049
# p:
	.long	2141202433
# g:
	.long	990234828
# s:
	.long	940682169
# p:
	.long	2141175809
# g:
	.long	1406392421
# s:
	.long	993089586
# p:
	.long	2141165569
# g:
	.long	1263518371
# s:
	.long	289019479
# p:
	.long	2141073409
# g:
	.long	1485624211
# s:
	.long	507864514
# p:
	.long	2141052929
# g:
	.long	1885134788
# s:
	.long	311252465
# p:
	.long	2141040641
# g:
	.long	1285021247
# s:
	.long	280941862
# p:
	.long	2141028353
# g:
	.long	1527610374
# s:
	.long	375035110
# p:
	.long	2141011969
# g:
	.long	1400626168
# s:
	.long	164696620
# p:
	.long	2140999681
# g:
	.long	632959608
# s:
	.long	966175067
# p:
	.long	2140997633
# g:
	.long	2045628978
# s:
	.long	1290889438
# p:
	.long	2140993537
# g:
	.long	1412755491
# s:
	.long	375366253
# p:
	.long	2140942337
# g:
	.long	719477232
# s:
	.long	785367828
# p:
	.long	2140925953
# g:
	.long	45224252
# s:
	.long	836552317
# p:
	.long	2140917761
# g:
	.long	1157376588
# s:
	.long	1001839569
# p:
	.long	2140887041
# g:
	.long	278480752
# s:
	.long	2098732796
# p:
	.long	2140837889
# g:
	.long	1663139953
# s:
	.long	924094810
# p:
	.long	2140788737
# g:
	.long	802501511
# s:
	.long	2045368990
# p:
	.long	2140766209
# g:
	.long	1820083885
# s:
	.long	1800295504
# p:
	.long	2140764161
# g:
	.long	1169561905
# s:
	.long	2106792035
# p:
	.long	2140696577
# g:
	.long	127781498
# s:
	.long	1885987531
# p:
	.long	2140684289
# g:
	.long	16014477
# s:
	.long	1098116827
# p:
	.long	2140653569
# g:
	.long	665960598
# s:
	.long	1796728247
# p:
	.long	2140594177
# g:
	.long	1043085491
# s:
	.long	377310938
# p:
	.long	2140579841
# g:
	.long	1732838211
# s:
	.long	1504505945
# p:
	.long	2140569601
# g:
	.long	302071939
# s:
	.long	358291016
# p:
	.long	2140567553
# g:
	.long	192393733
# s:
	.long	1909137143
# p:
	.long	2140557313
# g:
	.long	406595731
# s:
	.long	1175330270
# p:
	.long	2140549121
# g:
	.long	1748850918
# s:
	.long	525007007
# p:
	.long	2140477441
# g:
	.long	499436566
# s:
	.long	1031159814
# p:
	.long	2140469249
# g:
	.long	1886004401
# s:
	.long	1029951320
# p:
	.long	2140426241
# g:
	.long	1483168100
# s:
	.long	1676273461
# p:
	.long	2140420097
# g:
	.long	1779917297
# s:
	.long	846024476
# p:
	.long	2140413953
# g:
	.long	522948893
# s:
	.long	1816354149
# p:
	.long	2140383233
# g:
	.long	1931364473
# s:
	.long	1296921241
# p:
	.long	2140366849
# g:
	.long	1917356555
# s:
	.long	147196204
# p:
	.long	2140354561
# g:
	.long	16466177
# s:
	.long	1349052107
# p:
	.long	2140348417
# g:
	.long	1875366972
# s:
	.long	1860485634
# p:
	.long	2140323841
# g:
	.long	456498717
# s:
	.long	1790256483
# p:
	.long	2140321793
# g:
	.long	1629493973
# s:
	.long	150031888
# p:
	.long	2140315649
# g:
	.long	1904063898
# s:
	.long	395510935
# p:
	.long	2140280833
# g:
	.long	1784104328
# s:
	.long	831417909
# p:
	.long	2140250113
# g:
	.long	256087139
# s:
	.long	697349101
# p:
	.long	2140229633
# g:
	.long	388553070
# s:
	.long	243875754
# p:
	.long	2140223489
# g:
	.long	747459608
# s:
	.long	1396270850
# p:
	.long	2140200961
# g:
	.long	507423743
# s:
	.long	1895572209
# p:
	.long	2140162049
# g:
	.long	580106016
# s:
	.long	2045297469
# p:
	.long	2140149761
# g:
	.long	712426444
# s:
	.long	785217995
# p:
	.long	2140137473
# g:
	.long	1441607584
# s:
	.long	536866543
# p:
	.long	2140119041
# g:
	.long	346538902
# s:
	.long	1740434653
# p:
	.long	2140090369
# g:
	.long	282642885
# s:
	.long	21051094
# p:
	.long	2140076033
# g:
	.long	1407456228
# s:
	.long	319910029
# p:
	.long	2140047361
# g:
	.long	1619330500
# s:
	.long	1488632070
# p:
	.long	2140041217
# g:
	.long	2089408064
# s:
	.long	2012026134
# p:
	.long	2140008449
# g:
	.long	1705524800
# s:
	.long	1613440760
# p:
	.long	2139924481
# g:
	.long	1846208233
# s:
	.long	1280649481
# p:
	.long	2139906049
# g:
	.long	989438755
# s:
	.long	1185646076
# p:
	.long	2139867137
# g:
	.long	1522314850
# s:
	.long	372783595
# p:
	.long	2139842561
# g:
	.long	1681587377
# s:
	.long	216848235
# p:
	.long	2139826177
# g:
	.long	2066284988
# s:
	.long	1784999464
# p:
	.long	2139824129
# g:
	.long	480888214
# s:
	.long	1513323027
# p:
	.long	2139789313
# g:
	.long	847937200
# s:
	.long	858192859
# p:
	.long	2139783169
# g:
	.long	1642000434
# s:
	.long	1583261448
# p:
	.long	2139770881
# g:
	.long	940699589
# s:
	.long	179702100
# p:
	.long	2139768833
# g:
	.long	315623242
# s:
	.long	964612676
# p:
	.long	2139666433
# g:
	.long	331649203
# s:
	.long	764666914
# p:
	.long	2139641857
# g:
	.long	2118730799
# s:
	.long	1313764644
# p:
	.long	2139635713
# g:
	.long	519149027
# s:
	.long	519212449
# p:
	.long	2139598849
# g:
	.long	1526413634
# s:
	.long	1769667104
# p:
	.long	2139574273
# g:
	.long	551148610
# s:
	.long	820739925
# p:
	.long	2139568129
# g:
	.long	1386800242
# s:
	.long	472447405
# p:
	.long	2139549697
# g:
	.long	813760130
# s:
	.long	1412328531
# p:
	.long	2139537409
# g:
	.long	1615286260
# s:
	.long	1609362979
# p:
	.long	2139475969
# g:
	.long	1352559299
# s:
	.long	1696720421
# p:
	.long	2139455489
# g:
	.long	1048691649
# s:
	.long	1584935400
# p:
	.long	2139432961
# g:
	.long	836025845
# s:
	.long	950121150
# p:
	.long	2139424769
# g:
	.long	1558281165
# s:
	.long	1635486858
# p:
	.long	2139406337
# g:
	.long	1728402143
# s:
	.long	1674423301
# p:
	.long	2139396097
# g:
	.long	1727715782
# s:
	.long	1483470544
# p:
	.long	2139383809
# g:
	.long	1092853491
# s:
	.long	1741699084
# p:
	.long	2139369473
# g:
	.long	690776899
# s:
	.long	1242798709
# p:
	.long	2139351041
# g:
	.long	1768782380
# s:
	.long	2120712049
# p:
	.long	2139334657
# g:
	.long	1739968247
# s:
	.long	1427249225
# p:
	.long	2139332609
# g:
	.long	1547189119
# s:
	.long	623011170
# p:
	.long	2139310081
# g:
	.long	1346827917
# s:
	.long	1605466350
# p:
	.long	2139303937
# g:
	.long	369317948
# s:
	.long	828392831
# p:
	.long	2139301889
# g:
	.long	1560417239
# s:
	.long	1788073219
# p:
	.long	2139283457
# g:
	.long	1303121623
# s:
	.long	595079358
# p:
	.long	2139248641
# g:
	.long	1354555286
# s:
	.long	573424177
# p:
	.long	2139240449
# g:
	.long	60974056
# s:
	.long	885781403
# p:
	.long	2139222017
# g:
	.long	355573421
# s:
	.long	1221054839
# p:
	.long	2139215873
# g:
	.long	566477826
# s:
	.long	1724006500
# p:
	.long	2139150337
# g:
	.long	871437673
# s:
	.long	1609133294
# p:
	.long	2139144193
# g:
	.long	1478130914
# s:
	.long	1137491905
# p:
	.long	2139117569
# g:
	.long	1854880922
# s:
	.long	964728507
# p:
	.long	2139076609
# g:
	.long	202405335
# s:
	.long	756508944
# p:
	.long	2139062273
# g:
	.long	1399715741
# s:
	.long	884826059
# p:
	.long	2139045889
# g:
	.long	1051045798
# s:
	.long	1202295476
# p:
	.long	2139033601
# g:
	.long	1707715206
# s:
	.long	632234634
# p:
	.long	2139006977
# g:
	.long	2035853139
# s:
	.long	231626690
# p:
	.long	2138951681
# g:
	.long	183867876
# s:
	.long	838350879
# p:
	.long	2138945537
# g:
	.long	1403254661
# s:
	.long	404460202
# p:
	.long	2138920961
# g:
	.long	310865011
# s:
	.long	1282911681
# p:
	.long	2138910721
# g:
	.long	1328496553
# s:
	.long	103472415
# p:
	.long	2138904577
# g:
	.long	78831681
# s:
	.long	993513549
# p:
	.long	2138902529
# g:
	.long	1319697451
# s:
	.long	1055904361
# p:
	.long	2138816513
# g:
	.long	384338872
# s:
	.long	1706202469
# p:
	.long	2138810369
# g:
	.long	1084868275
# s:
	.long	405677177
# p:
	.long	2138787841
# g:
	.long	401181788
# s:
	.long	1964773901
# p:
	.long	2138775553
# g:
	.long	1850532988
# s:
	.long	1247087473
# p:
	.long	2138767361
# g:
	.long	874261901
# s:
	.long	1576073565
# p:
	.long	2138757121
# g:
	.long	1187474742
# s:
	.long	993541415
# p:
	.long	2138748929
# g:
	.long	1782458888
# s:
	.long	1043206483
# p:
	.long	2138744833
# g:
	.long	1221500487
# s:
	.long	800141243
# p:
	.long	2138738689
# g:
	.long	413465368
# s:
	.long	1450660558
# p:
	.long	2138695681
# g:
	.long	739045140
# s:
	.long	342611472
# p:
	.long	2138658817
# g:
	.long	1355845756
# s:
	.long	672674190
# p:
	.long	2138644481
# g:
	.long	608379162
# s:
	.long	1538874380
# p:
	.long	2138632193
# g:
	.long	1444914034
# s:
	.long	686911254
# p:
	.long	2138607617
# g:
	.long	484707818
# s:
	.long	1435142134
# p:
	.long	2138591233
# g:
	.long	539460669
# s:
	.long	1290458549
# p:
	.long	2138572801
# g:
	.long	2093538990
# s:
	.long	2011138646
# p:
	.long	2138552321
# g:
	.long	1149786988
# s:
	.long	1076414907
# p:
	.long	2138546177
# g:
	.long	840688206
# s:
	.long	2108985273
# p:
	.long	2138533889
# g:
	.long	209669619
# s:
	.long	198172413
# p:
	.long	2138523649
# g:
	.long	1975879426
# s:
	.long	1277003968
# p:
	.long	2138490881
# g:
	.long	1351891144
# s:
	.long	1976858109
# p:
	.long	2138460161
# g:
	.long	1817321013
# s:
	.long	1979278293
# p:
	.long	2138429441
# g:
	.long	1950077177
# s:
	.long	203441928
# p:
	.long	2138400769
# g:
	.long	908970113
# s:
	.long	628395069
# p:
	.long	2138398721
# g:
	.long	219890864
# s:
	.long	758486760
# p:
	.long	2138376193
# g:
	.long	1306654379
# s:
	.long	977554090
# p:
	.long	2138351617
# g:
	.long	298822498
# s:
	.long	2004708503
# p:
	.long	2138337281
# g:
	.long	441457816
# s:
	.long	1049002108
# p:
	.long	2138320897
# g:
	.long	1517731724
# s:
	.long	1442269609
# p:
	.long	2138290177
# g:
	.long	1355911197
# s:
	.long	1647139103
# p:
	.long	2138234881
# g:
	.long	531313247
# s:
	.long	1746591962
# p:
	.long	2138214401
# g:
	.long	1899410930
# s:
	.long	781416444
# p:
	.long	2138202113
# g:
	.long	1813477173
# s:
	.long	1622508515
# p:
	.long	2138191873
# g:
	.long	1086458299
# s:
	.long	1025408615
# p:
	.long	2138183681
# g:
	.long	1998800427
# s:
	.long	827063290
# p:
	.long	2138173441
# g:
	.long	1921308898
# s:
	.long	749670117
# p:
	.long	2138103809
# g:
	.long	1620902804
# s:
	.long	2126787647
# p:
	.long	2138099713
# g:
	.long	828647069
# s:
	.long	1892961817
# p:
	.long	2138085377
# g:
	.long	179405355
# s:
	.long	1525506535
# p:
	.long	2138060801
# g:
	.long	615683235
# s:
	.long	1259580138
# p:
	.long	2138044417
# g:
	.long	2030277840
# s:
	.long	1731266562
# p:
	.long	2138042369
# g:
	.long	2087222316
# s:
	.long	1627902259
# p:
	.long	2138032129
# g:
	.long	126388712
# s:
	.long	1108640984
# p:
	.long	2138011649
# g:
	.long	715026550
# s:
	.long	1017980050
# p:
	.long	2137993217
# g:
	.long	1693714349
# s:
	.long	1351778704
# p:
	.long	2137888769
# g:
	.long	1289762259
# s:
	.long	1053090405
# p:
	.long	2137853953
# g:
	.long	199991890
# s:
	.long	1254192789
# p:
	.long	2137833473
# g:
	.long	941421685
# s:
	.long	896995556
# p:
	.long	2137817089
# g:
	.long	750416446
# s:
	.long	1251031181
# p:
	.long	2137792513
# g:
	.long	798075119
# s:
	.long	368077456
# p:
	.long	2137786369
# g:
	.long	878543495
# s:
	.long	1035375025
# p:
	.long	2137767937
# g:
	.long	9351178
# s:
	.long	1156563902
# p:
	.long	2137755649
# g:
	.long	1382297614
# s:
	.long	1686559583
# p:
	.long	2137724929
# g:
	.long	1345472850
# s:
	.long	1681096331
# p:
	.long	2137704449
# g:
	.long	834666929
# s:
	.long	630551727
# p:
	.long	2137673729
# g:
	.long	1646165729
# s:
	.long	1892091571
# p:
	.long	2137620481
# g:
	.long	778943821
# s:
	.long	48456461
# p:
	.long	2137618433
# g:
	.long	1730837875
# s:
	.long	1713336725
# p:
	.long	2137581569
# g:
	.long	805610339
# s:
	.long	1378891359
# p:
	.long	2137538561
# g:
	.long	204342388
# s:
	.long	1950165220
# p:
	.long	2137526273
# g:
	.long	1947629754
# s:
	.long	1500789441
# p:
	.long	2137516033
# g:
	.long	719902645
# s:
	.long	1499525372
# p:
	.long	2137491457
# g:
	.long	230451261
# s:
	.long	556382829
# p:
	.long	2137440257
# g:
	.long	979573541
# s:
	.long	412760291
# p:
	.long	2137374721
# g:
	.long	927841248
# s:
	.long	1954137185
# p:
	.long	2137362433
# g:
	.long	1243778559
# s:
	.long	861024672
# p:
	.long	2137313281
# g:
	.long	1341338501
# s:
	.long	980638386
# p:
	.long	2137311233
# g:
	.long	937415182
# s:
	.long	1793212117
# p:
	.long	2137255937
# g:
	.long	795331324
# s:
	.long	1410253405
# p:
	.long	2137243649
# g:
	.long	150756339
# s:
	.long	1966999887
# p:
	.long	2137182209
# g:
	.long	163346914
# s:
	.long	1939301431
# p:
	.long	2137171969
# g:
	.long	1952552395
# s:
	.long	758913141
# p:
	.long	2137159681
# g:
	.long	570788721
# s:
	.long	218668666
# p:
	.long	2137147393
# g:
	.long	1896656810
# s:
	.long	2045670345
# p:
	.long	2137141249
# g:
	.long	358493842
# s:
	.long	518199643
# p:
	.long	2137139201
# g:
	.long	1505023029
# s:
	.long	674695848
# p:
	.long	2137133057
# g:
	.long	27911103
# s:
	.long	830956306
# p:
	.long	2137122817
# g:
	.long	439771337
# s:
	.long	1555268614
# p:
	.long	2137116673
# g:
	.long	790988579
# s:
	.long	1871449599
# p:
	.long	2137110529
# g:
	.long	432109234
# s:
	.long	811805080
# p:
	.long	2137102337
# g:
	.long	1357900653
# s:
	.long	1184997641
# p:
	.long	2137098241
# g:
	.long	515119035
# s:
	.long	1715693095
# p:
	.long	2137090049
# g:
	.long	408575203
# s:
	.long	2085660657
# p:
	.long	2137085953
# g:
	.long	2097793407
# s:
	.long	1349626963
# p:
	.long	2137055233
# g:
	.long	1556739954
# s:
	.long	1449960883
# p:
	.long	2137030657
# g:
	.long	1545758650
# s:
	.long	1369303716
# p:
	.long	2136987649
# g:
	.long	332602570
# s:
	.long	103875114
# p:
	.long	2136969217
# g:
	.long	1499989506
# s:
	.long	1662964115
# p:
	.long	2136924161
# g:
	.long	857040753
# s:
	.long	4738842
# p:
	.long	2136895489
# g:
	.long	1948872712
# s:
	.long	570436091
# p:
	.long	2136893441
# g:
	.long	58969960
# s:
	.long	1568349634
# p:
	.long	2136887297
# g:
	.long	2127193379
# s:
	.long	273612548
# p:
	.long	2136850433
# g:
	.long	111208983
# s:
	.long	1181257116
# p:
	.long	2136809473
# g:
	.long	1627275942
# s:
	.long	1680317971
# p:
	.long	2136764417
# g:
	.long	1574888217
# s:
	.long	14011331
# p:
	.long	2136741889
# g:
	.long	14011055
# s:
	.long	1129154251
# p:
	.long	2136727553
# g:
	.long	35862563
# s:
	.long	1838555253
# p:
	.long	2136721409
# g:
	.long	310235666
# s:
	.long	1363928244
# p:
	.long	2136698881
# g:
	.long	1612429202
# s:
	.long	1560383828
# p:
	.long	2136649729
# g:
	.long	1138540131
# s:
	.long	800014364
# p:
	.long	2136606721
# g:
	.long	602323503
# s:
	.long	1433096652
# p:
	.long	2136563713
# g:
	.long	182209265
# s:
	.long	1919611038
# p:
	.long	2136555521
# g:
	.long	324156477
# s:
	.long	165591039
# p:
	.long	2136549377
# g:
	.long	195513113
# s:
	.long	217165345
# p:
	.long	2136526849
# g:
	.long	1050768046
# s:
	.long	939647887
# p:
	.long	2136508417
# g:
	.long	1886286237
# s:
	.long	1619926572
# p:
	.long	2136477697
# g:
	.long	609647664
# s:
	.long	35065157
# p:
	.long	2136471553
# g:
	.long	679352216
# s:
	.long	1452259468
# p:
	.long	2136457217
# g:
	.long	128630031
# s:
	.long	824816521
# p:
	.long	2136422401
# g:
	.long	19787464
# s:
	.long	1526049830
# p:
	.long	2136420353
# g:
	.long	698316836
# s:
	.long	1530623527
# p:
	.long	2136371201
# g:
	.long	1651862373
# s:
	.long	1804812805
# p:
	.long	2136334337
# g:
	.long	326596005
# s:
	.long	336977082
# p:
	.long	2136322049
# g:
	.long	63253370
# s:
	.long	1904972151
# p:
	.long	2136297473
# g:
	.long	312176076
# s:
	.long	172182411
# p:
	.long	2136248321
# g:
	.long	381261841
# s:
	.long	369032670
# p:
	.long	2136242177
# g:
	.long	358688773
# s:
	.long	1640007994
# p:
	.long	2136229889
# g:
	.long	512677188
# s:
	.long	75585225
# p:
	.long	2136219649
# g:
	.long	2095003250
# s:
	.long	1970086149
# p:
	.long	2136207361
# g:
	.long	1909650722
# s:
	.long	537760675
# p:
	.long	2136176641
# g:
	.long	1334616195
# s:
	.long	1533487619
# p:
	.long	2136158209
# g:
	.long	2096285632
# s:
	.long	1793285210
# p:
	.long	2136143873
# g:
	.long	1897347517
# s:
	.long	293843959
# p:
	.long	2136133633
# g:
	.long	923586222
# s:
	.long	1022655978
# p:
	.long	2136096769
# g:
	.long	1464868191
# s:
	.long	1515074410
# p:
	.long	2136094721
# g:
	.long	2020679520
# s:
	.long	2061636104
# p:
	.long	2136076289
# g:
	.long	290798503
# s:
	.long	1814726809
# p:
	.long	2136041473
# g:
	.long	156415894
# s:
	.long	1250757633
# p:
	.long	2135996417
# g:
	.long	297459940
# s:
	.long	1132158924
# p:
	.long	2135955457
# g:
	.long	538755304
# s:
	.long	1688831340
# p:
	.long	0
# g:
	.long	0
# s:
	.long	0
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
