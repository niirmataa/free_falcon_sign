	.file	"floor_wrapper.c"
# GNU C99 (Debian 14.2.0-19) version 14.2.0 (x86_64-linux-gnu)
#	compiled by GNU C version 14.2.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.27-GMP

# warning: MPFR header version 4.2.1 differs from library version 4.2.2.
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O -std=c99 -fasynchronous-unwind-tables
	.text
	.globl	floor_wrapper
	.type	floor_wrapper, @function
floor_wrapper:
.LFB32:
	.cfi_startproc
# baseline/source/fpr-emulated.h:124: 	e = (int)(x >> 52) & 0x7FF;
	movq	%rdi, %rdx	# x, _4
	shrq	$52, %rdx	#, _4
# baseline/source/fpr-emulated.h:124: 	e = (int)(x >> 52) & 0x7FF;
	andl	$2047, %edx	#, e
	movq	%rdi, %rax	# x, <retval>
	sarq	$63, %rax	#, <retval>
# baseline/source/fpr-emulated.h:131: 	xi ^= (xi ^ -(int64_t)t) & -(int64_t)((uint32_t)(63 - cc) >> 31);
	movl	%edx, %esi	# e, tmp140
	subl	$1022, %esi	#, tmp140
	js	.L1	#,
# baseline/source/fpr-emulated.h:126: 	xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
	movq	%rdi, %rcx	# x, _8
	salq	$10, %rcx	#, _8
# baseline/source/fpr-emulated.h:126: 	xi = (int64_t)(((x << 10) | ((uint64_t)1 << 62))
	btrq	$63, %rcx	#, _9
	btsq	$62, %rcx	#, _10
# baseline/source/fpr-emulated.h:128: 	xi = (xi ^ -(int64_t)t) + (int64_t)t;
	xorq	%rax, %rcx	# <retval>, _14
# baseline/source/fpr-emulated.h:125: 	t = x >> 63;
	shrq	$63, %rdi	#, t_7
# baseline/source/fpr-emulated.h:128: 	xi = (xi ^ -(int64_t)t) + (int64_t)t;
	addq	%rcx, %rdi	# _14, xi
# baseline/source/fpr-emulated.h:129: 	cc = 1085 - e;
	movl	$1085, %ecx	#, tmp132
	subl	%edx, %ecx	# e, cc
# baseline/source/fpr-emulated.h:28: 	x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
	movq	%rdi, %rax	# xi, _19
	sarq	$32, %rax	#, _19
# baseline/source/fpr-emulated.h:28: 	x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);
	testb	$32, %cl	#, cc
	cmove	%rdi, %rax	# _19,, xi, x_25
# baseline/source/fpr-emulated.h:29: 	return x >> (n & 31);
	andl	$31, %ecx	#, _26
# baseline/source/fpr-emulated.h:29: 	return x >> (n & 31);
	sarq	%cl, %rax	# _26, <retval>
.L1:
# checks/floor_wrapper.c:2: long floor_wrapper(uint64_t x) { return fpr_floor(x); }
	ret	
	.cfi_endproc
.LFE32:
	.size	floor_wrapper, .-floor_wrapper
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
