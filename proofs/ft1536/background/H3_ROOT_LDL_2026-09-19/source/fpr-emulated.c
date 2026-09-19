/*
 * Integer-emulated fpr arithmetic for the FREE Falcon ternary FFT3 port.
 * Arithmetic routines are adapted from the Falcon Round3 FALCON_FPEMU backend;
 * FFT3 constants stay in fpr-emulated.h and are generated from this build's
 * fpr-double.h so the ternary Phi_4608 path is preserved.
 */

#ifndef FALCON_ASM_CORTEXM4
#define FALCON_ASM_CORTEXM4 0
#endif

#include "internal.h"

/*
 * Normalize a provided unsigned integer to the 2^63..2^64-1 range by
 * left-shifting it if necessary. The exponent e is adjusted accordingly
 * (i.e. if the value was left-shifted by n bits, then n is subtracted
 * from e). If source m is 0, then it remains 0, but e is altered.
 * Both m and e must be simple variables (no expressions allowed).
 */
#define FPR_NORM64(m, e)   do { \
		uint32_t nt; \
 \
		(e) -= 63; \
 \
		nt = (uint32_t)((m) >> 32); \
		nt = (nt | -nt) >> 31; \
		(m) ^= ((m) ^ ((m) << 32)) & ((uint64_t)nt - 1); \
		(e) += (int)(nt << 5); \
 \
		nt = (uint32_t)((m) >> 48); \
		nt = (nt | -nt) >> 31; \
		(m) ^= ((m) ^ ((m) << 16)) & ((uint64_t)nt - 1); \
		(e) += (int)(nt << 4); \
 \
		nt = (uint32_t)((m) >> 56); \
		nt = (nt | -nt) >> 31; \
		(m) ^= ((m) ^ ((m) <<  8)) & ((uint64_t)nt - 1); \
		(e) += (int)(nt << 3); \
 \
		nt = (uint32_t)((m) >> 60); \
		nt = (nt | -nt) >> 31; \
		(m) ^= ((m) ^ ((m) <<  4)) & ((uint64_t)nt - 1); \
		(e) += (int)(nt << 2); \
 \
		nt = (uint32_t)((m) >> 62); \
		nt = (nt | -nt) >> 31; \
		(m) ^= ((m) ^ ((m) <<  2)) & ((uint64_t)nt - 1); \
		(e) += (int)(nt << 1); \
 \
		nt = (uint32_t)((m) >> 63); \
		(m) ^= ((m) ^ ((m) <<  1)) & ((uint64_t)nt - 1); \
		(e) += (int)(nt); \
	} while (0)

#if FALCON_ASM_CORTEXM4 // yyyASM_CORTEXM4+1

__attribute__((naked))
fpr
fpr_scaled(int64_t i , int sc )
{
	__asm__ (
	"push	{ r4, r5, r6, lr }\n\t"
	"\n\t"
	"@ Input i is in r0:r1, and sc in r2.\n\t"
	"@ Extract the sign bit, and compute the absolute value.\n\t"
	"@ -> sign bit in r3, with value 0 or -1\n\t"
	"asrs	r3, r1, #31\n\t"
	"eors	r0, r3\n\t"
	"eors	r1, r3\n\t"
	"subs	r0, r3\n\t"
	"sbcs	r1, r3\n\t"
	"\n\t"
	"@ Scale exponent to account for the encoding; if the source is\n\t"
	"@ zero or if the scaled exponent is negative, it is set to 32.\n\t"
	"addw	r2, r2, #1022\n\t"
	"orrs	r4, r0, r1\n\t"
	"bics	r4, r4, r2, asr #31\n\t"
	"rsbs	r5, r4, #0\n\t"
	"orrs	r4, r5\n\t"
	"ands	r2, r2, r4, asr #31\n\t"
	"adds	r2, #32\n\t"
	"\n\t"
	"@ Normalize value to a full 64-bit width, by shifting it left.\n\t"
	"@ The shift count is subtracted from the exponent (in r2).\n\t"
	"@ If the mantissa is 0, the exponent is set to 0.\n\t"
	"\n\t"
	"@ If top word is 0, replace with low word; otherwise, add 32 to\n\t"
	"@ the exponent.\n\t"
	"rsbs	r4, r1, #0\n\t"
	"orrs	r4, r1\n\t"
	"eors	r5, r0, r1\n\t"
	"bics	r5, r5, r4, asr #31\n\t"
	"eors	r1, r5\n\t"
	"ands	r0, r0, r4, asr #31\n\t"
	"lsrs	r4, r4, #31\n\t"
	"adds	r2, r2, r4, lsl #5\n\t"
	"\n\t"
	"@ Count leading zeros of r1 to finish the shift.\n\t"
	"clz	r4, r1\n\t"
	"subs	r2, r4\n\t"
	"rsbs	r5, r4, #32\n\t"
	"lsls	r1, r4\n\t"
	"lsrs	r5, r0, r5\n\t"
	"lsls	r0, r4\n\t"
	"orrs	r1, r5\n\t"
	"\n\t"
	"@ Clear the top bit; we know it's a 1 (unless the whole mantissa\n\t"
	"@ was zero, but then it's still OK to clear it)\n\t"
	"bfc	r1, #31, #1\n\t"
	"\n\t"
	"@ Now shift right the value by 11 bits; this puts the value in\n\t"
	"@ the 2^52..2^53-1 range. We also keep a copy of the pre-shift\n\t"
	"@ low bits in r5.\n\t"
	"movs	r5, r0\n\t"
	"lsrs	r0, #11\n\t"
	"orrs	r0, r0, r1, lsl #21\n\t"
	"lsrs	r1, #11\n\t"
	"\n\t"
	"@ Also plug the exponent at the right place. This must be done\n\t"
	"@ now so that, in case the rounding creates a carry, that carry\n\t"
	"@ adds to the exponent, which would be exactly what we want at\n\t"
	"@ that point.\n\t"
	"orrs	r1, r1, r2, lsl #20\n\t"
	"\n\t"
	"@ Rounding: we must add 1 to the mantissa in the following cases:\n\t"
	"@  - bits 11 to 9 of r5 are '011', '110' or '111'\n\t"
	"@  - bits 11 to 9 of r5 are '010' and one of the\n\t"
	"@    bits 0 to 8 is non-zero\n\t"
	"ubfx	r6, r5, #0, #9\n\t"
	"addw	r6, r6, #511\n\t"
	"orrs	r5, r6\n\t"
	"\n\t"
	"ubfx	r5, r5, #9, #3\n\t"
	"movs	r6, #0xC8\n\t"
	"lsrs	r6, r5\n\t"
	"ands	r6, #1\n\t"
	"adds	r0, r6\n\t"
	"adcs	r1, #0\n\t"
	"\n\t"
	"@ Put back the sign.\n\t"
	"orrs	r1, r1, r3, lsl #31\n\t"
	"\n\t"
	"pop	{ r4, r5, r6, pc}\n\t"
	);
}

#else // yyyASM_CORTEXM4+0

fpr
fpr_scaled(int64_t i, int sc)
{
	/*
	 * To convert from int to float, we have to do the following:
	 *  1. Get the absolute value of the input, and its sign
	 *  2. Shift right or left the value as appropriate
	 *  3. Pack the result
	 *
	 * We can assume that the source integer is not -2^63.
	 */
	int s, e;
	uint32_t t;
	uint64_t m;

	/*
	 * Extract sign bit.
	 * We have: -i = 1 + ~i
	 */
	s = (int)((uint64_t)i >> 63);
	i ^= -(int64_t)s;
	i += s;

	/*
	 * For now we suppose that i != 0.
	 * Otherwise, we set m to i and left-shift it as much as needed
	 * to get a 1 in the top bit. We can do that in a logarithmic
	 * number of conditional shifts.
	 */
	m = (uint64_t)i;
	e = 9 + sc;
	FPR_NORM64(m, e);

	/*
	 * Now m is in the 2^63..2^64-1 range. We must divide it by 512;
	 * if one of the dropped bits is a 1, this should go into the
	 * "sticky bit".
	 */
	m |= ((uint32_t)m & 0x1FF) + 0x1FF;
	m >>= 9;

	/*
	 * Corrective action: if i = 0 then all of the above was
	 * incorrect, and we clamp e and m down to zero.
	 */
	t = (uint32_t)((uint64_t)(i | -i) >> 63);
	m &= -(uint64_t)t;
	e &= -(int)t;

	/*
	 * Assemble back everything. The FPR() function will handle cases
	 * where e is too low.
	 */
	return FPR(s, e, m);
}

#endif // yyyASM_CORTEXM4-

#if FALCON_ASM_CORTEXM4 // yyyASM_CORTEXM4+1

// yyyPQCLEAN+0
#if 0
/* Debug code -- To get a printout of registers from a specific point
   in ARM Cortex M4 assembly code, uncomment this code and add a
   "bl DEBUG" call where wished for. */

void
print_regs(uint32_t *rr, uint32_t flags)
{
	int i;
	extern int printf(const char *fmt, ...);

	printf("\nRegs:\n");
	for (i = 0; i < 7; i ++) {
		int j;

		j = i + 7;
		printf("  %2d = %08X    %2d = %08X\n", i, rr[i], j, rr[j]);
	}
	printf("  flags = %08X  ", flags);
	if ((flags >> 31) & 1) {
		printf("N");
	}
	if ((flags >> 30) & 1) {
		printf("Z");
	}
	if ((flags >> 29) & 1) {
		printf("C");
	}
	if ((flags >> 28) & 1) {
		printf("V");
	}
	if ((flags >> 27) & 1) {
		printf("Q");
	}
	printf("\n");
}

__attribute__((naked))
void
DEBUG(void)
{
	__asm__ (
	"push	{ r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, lr }\n\t"
	"mov	r0, sp\n\t"
	"mrs	r1, apsr\n\t"
	"bl	print_regs\n\t"
	"pop	{ r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, pc }\n\t"
	);
}
#endif
// yyyPQCLEAN-

__attribute__((naked))
fpr
fpr_add(fpr x , fpr y )
{
	__asm__ (
	"push	{ r4, r5, r6, r7, r8, r10, r11, lr }\n\t"
	"\n\t"
	"@ Make sure that the first operand (x) has the larger absolute\n\t"
	"@ value. This guarantees that the exponent of y is less than\n\t"
	"@ or equal to the exponent of x, and, if they are equal, then\n\t"
	"@ the mantissa of y will not be greater than the mantissa of x.\n\t"
	"@ However, if absolute values are equal and the sign of x is 1,\n\t"
	"@ then we want to also swap the values.\n\t"
	"ubfx	r4, r1, #0, #31  @ top word without sign bit\n\t"
	"ubfx	r5, r3, #0, #31  @ top word without sign bit\n\t"
	"subs	r7, r0, r2       @ difference in r7:r4\n\t"
	"sbcs	r4, r5\n\t"
	"orrs	r7, r4\n\t"
	"rsbs	r5, r7, #0\n\t"
	"orrs	r7, r5      @ bit 31 of r7 is 0 iff difference is zero\n\t"
	"bics	r6, r1, r7\n\t"
	"orrs	r6, r4      @ bit 31 of r6 is 1 iff the swap must be done\n\t"
	"\n\t"
	"@ Conditional swap\n\t"
	"eors	r4, r0, r2\n\t"
	"eors	r5, r1, r3\n\t"
	"ands	r4, r4, r6, asr #31\n\t"
	"ands	r5, r5, r6, asr #31\n\t"
	"eors	r0, r4\n\t"
	"eors	r1, r5\n\t"
	"eors	r2, r4\n\t"
	"eors	r3, r5\n\t"
	"\n\t"
	"@ Extract mantissa of x into r0:r1, exponent in r4, sign in r5\n\t"
	"ubfx	r4, r1, #20, #11   @ Exponent in r4 (without sign)\n\t"
	"addw	r5, r4, #2047 @ Get a carry to test r4 for zero\n\t"
	"lsrs	r5, #11       @ r5 is the mantissa implicit high bit\n\t"
	"bfc	r1, #20, #11  @ Clear exponent bits (not the sign)\n\t"
	"orrs	r1, r1, r5, lsl #20  @ Set mantissa high bit\n\t"
	"asrs	r5, r1, #31   @ Get sign bit (sign-extended)\n\t"
	"bfc	r1, #31, #1   @ Clear the sign bit\n\t"
	"\n\t"
	"@ Extract mantissa of y into r2:r3, exponent in r6, sign in r7\n\t"
	"ubfx	r6, r3, #20, #11   @ Exponent in r6 (without sign)\n\t"
	"addw	r7, r6, #2047 @ Get a carry to test r6 for zero\n\t"
	"lsrs	r7, #11       @ r7 is the mantissa implicit high bit\n\t"
	"bfc	r3, #20, #11  @ Clear exponent bits (not the sign)\n\t"
	"orrs	r3, r3, r7, lsl #20  @ Set mantissa high bit\n\t"
	"asrs	r7, r3, #31   @ Get sign bit (sign-extended)\n\t"
	"bfc	r3, #31, #1   @ Clear the sign bit\n\t"
	"\n\t"
	"@ Scale mantissas up by three bits.\n\t"
	"lsls	r1, #3\n\t"
	"orrs	r1, r1, r0, lsr #29\n\t"
	"lsls	r0, #3\n\t"
	"lsls	r3, #3\n\t"
	"orrs	r3, r3, r2, lsr #29\n\t"
	"lsls	r2, #3\n\t"
	"\n\t"
	"@ x: exponent=r4, sign=r5, mantissa=r0:r1 (scaled up 3 bits)\n\t"
	"@ y: exponent=r6, sign=r7, mantissa=r2:r3 (scaled up 3 bits)\n\t"
	"\n\t"
	"@ At that point, the exponent of x (in r4) is larger than that\n\t"
	"@ of y (in r6). The difference is the amount of shifting that\n\t"
	"@ should be done on y. If that amount is larger than 59 then\n\t"
	"@ we clamp y to 0. We won't need y's exponent beyond that point,\n\t"
	"@ so we store that shift count in r6.\n\t"
	"subs	r6, r4, r6\n\t"
	"subs	r8, r6, #60\n\t"
	"ands	r2, r2, r8, asr #31\n\t"
	"ands	r3, r3, r8, asr #31\n\t"
	"\n\t"
	"@ Shift right r2:r3 by r6 bits. The shift count is in the 0..59\n\t"
	"@ range. r11 will be non-zero if and only if some non-zero bits\n\t"
	"@ were dropped.\n\t"
	"subs	r8, r6, #32\n\t"
	"bics	r11, r2, r8, asr #31\n\t"
	"ands	r2, r2, r8, asr #31\n\t"
	"bics	r10, r3, r8, asr #31\n\t"
	"orrs	r2, r2, r10\n\t"
	"ands	r3, r3, r8, asr #31\n\t"
	"ands	r6, r6, #31\n\t"
	"rsbs	r8, r6, #32\n\t"
	"lsls	r10, r2, r8\n\t"
	"orrs	r11, r11, r10\n\t"
	"lsrs	r2, r2, r6\n\t"
	"lsls	r10, r3, r8\n\t"
	"orrs	r2, r2, r10\n\t"
	"lsrs	r3, r3, r6\n\t"
	"\n\t"
	"@ If r11 is non-zero then some non-zero bit was dropped and the\n\t"
	"@ low bit of r2 must be forced to 1 ('sticky bit').\n\t"
	"rsbs	r6, r11, #0\n\t"
	"orrs	r6, r6, r11\n\t"
	"orrs	r2, r2, r6, lsr #31\n\t"
	"\n\t"
	"@ x: exponent=r4, sign=r5, mantissa=r0:r1 (scaled up 3 bits)\n\t"
	"@ y: sign=r7, value=r2:r3 (scaled to same exponent as x)\n\t"
	"\n\t"
	"@ If x and y don't have the same sign, then we should negate r2:r3\n\t"
	"@ (i.e. subtract the mantissa instead of adding it). Signs of x\n\t"
	"@ and y are in r5 and r7, as full-width words. We won't need r7\n\t"
	"@ afterwards.\n\t"
	"eors	r7, r5    @ r7 = -1 if y must be negated, 0 otherwise\n\t"
	"eors	r2, r7\n\t"
	"eors	r3, r7\n\t"
	"subs	r2, r7\n\t"
	"sbcs	r3, r7\n\t"
	"\n\t"
	"@ r2:r3 has been shifted, we can add to r0:r1.\n\t"
	"adds	r0, r2\n\t"
	"adcs	r1, r3\n\t"
	"\n\t"
	"@ result: exponent=r4, sign=r5, mantissa=r0:r1 (scaled up 3 bits)\n\t"
	"\n\t"
	"@ Normalize the result with some left-shifting to full 64-bit\n\t"
	"@ width. Shift count goes to r2, and exponent (r4) is adjusted.\n\t"
	"clz	r2, r0\n\t"
	"clz	r3, r1\n\t"
	"sbfx	r6, r3, #5, #1\n\t"
	"ands	r2, r6\n\t"
	"adds	r2, r2, r3\n\t"
	"subs	r4, r4, r2\n\t"
	"\n\t"
	"@ Shift r0:r1 to the left by r2 bits.\n\t"
	"subs	r7, r2, #32\n\t"
	"lsls	r7, r0, r7\n\t"
	"lsls	r1, r1, r2\n\t"
	"rsbs	r6, r2, #32\n\t"
	"orrs	r1, r1, r7\n\t"
	"lsrs	r6, r0, r6\n\t"
	"orrs	r1, r1, r6\n\t"
	"lsls	r0, r0, r2\n\t"
	"\n\t"
	"@ The exponent of x was in r4. The left-shift operation has\n\t"
	"@ subtracted some value from it, 8 in case the result has the\n\t"
	"@ same exponent as x. However, the high bit of the mantissa will\n\t"
	"@ add 1 to the exponent, so we only add back 7 (the exponent is\n\t"
	"@ added in because rounding might have produced a carry, which\n\t"
	"@ should then spill into the exponent).\n\t"
	"adds	r4, #7\n\t"
	"\n\t"
	"@ If the mantissa new mantissa is non-zero, then its bit 63 is\n\t"
	"@ non-zero (thanks to the normalizing shift). Otherwise, that bit\n\t"
	"@ is zero, and we should then set the exponent to zero as well.\n\t"
	"ands	r4, r4, r1, asr #31\n\t"
	"\n\t"
	"@ Shrink back the value to a 52-bit mantissa. This requires\n\t"
	"@ right-shifting by 11 bits; we keep a copy of the pre-shift\n\t"
	"@ low word in r3.\n\t"
	"movs	r3, r0\n\t"
	"lsrs	r0, #11\n\t"
	"orrs	r0, r0, r1, lsl #21\n\t"
	"lsrs	r1, #11\n\t"
	"\n\t"
	"@ Apply rounding.\n\t"
	"ubfx	r6, r3, #0, #9\n\t"
	"addw	r6, r6, #511\n\t"
	"orrs	r3, r6\n\t"
	"ubfx	r3, r3, #9, #3\n\t"
	"movs	r6, #0xC8\n\t"
	"lsrs	r6, r3\n\t"
	"ands	r6, #1\n\t"
	"adds	r0, r6\n\t"
	"adcs	r1, #0\n\t"
	"\n\t"
	"@Plug in the exponent with an addition.\n\t"
	"adds	r1, r1, r4, lsl #20\n\t"
	"\n\t"
	"@ If the new exponent is negative or zero, then it underflowed\n\t"
	"@ and we must clear the whole mantissa and exponent.\n\t"
	"rsbs	r4, r4, #0\n\t"
	"ands	r0, r0, r4, asr #31\n\t"
	"ands	r1, r1, r4, asr #31\n\t"
	"\n\t"
	"@ Put back the sign. This is the sign of x: thanks to the\n\t"
	"@ conditional swap at the start, this is always correct.\n\t"
	"bfi	r1, r5, #31, #1\n\t"
	"\n\t"
	"pop	{ r4, r5, r6, r7, r8, r10, r11, pc }\n\t"
	);
}

#else // yyyASM_CORTEXM4+0

fpr
fpr_add(fpr x, fpr y)
{
	uint64_t m, xu, yu, za;
	uint32_t cs;
	int ex, ey, sx, sy, cc;

	/*
	 * Make sure that the first operand (x) has the larger absolute
	 * value. This guarantees that the exponent of y is less than
	 * or equal to the exponent of x, and, if they are equal, then
	 * the mantissa of y will not be greater than the mantissa of x.
	 *
	 * After this swap, the result will have the sign x, except in
	 * the following edge case: abs(x) = abs(y), and x and y have
	 * opposite sign bits; in that case, the result shall be +0
	 * even if the sign bit of x is 1. To handle this case properly,
	 * we do the swap is abs(x) = abs(y) AND the sign of x is 1.
	 */
	m = ((uint64_t)1 << 63) - 1;
	za = (x & m) - (y & m);
	cs = (uint32_t)(za >> 63)
		| ((1U - (uint32_t)(-za >> 63)) & (uint32_t)(x >> 63));
	m = (x ^ y) & -(uint64_t)cs;
	x ^= m;
	y ^= m;

	/*
	 * Extract sign bits, exponents and mantissas. The mantissas are
	 * scaled up to 2^55..2^56-1, and the exponent is unbiased. If
	 * an operand is zero, its mantissa is set to 0 at this step, and
	 * its exponent will be -1078.
	 */
	ex = (int)(x >> 52);
	sx = ex >> 11;
	ex &= 0x7FF;
	m = (uint64_t)(uint32_t)((ex + 0x7FF) >> 11) << 52;
	xu = ((x & (((uint64_t)1 << 52) - 1)) | m) << 3;
	ex -= 1078;
	ey = (int)(y >> 52);
	sy = ey >> 11;
	ey &= 0x7FF;
	m = (uint64_t)(uint32_t)((ey + 0x7FF) >> 11) << 52;
	yu = ((y & (((uint64_t)1 << 52) - 1)) | m) << 3;
	ey -= 1078;

	/*
	 * x has the larger exponent; hence, we only need to right-shift y.
	 * If the shift count is larger than 59 bits then we clamp the
	 * value to zero.
	 */
	cc = ex - ey;
	yu &= -(uint64_t)((uint32_t)(cc - 60) >> 31);
	cc &= 63;

	/*
	 * The lowest bit of yu is "sticky".
	 */
	m = fpr_ulsh(1, cc) - 1;
	yu |= (yu & m) + m;
	yu = fpr_ursh(yu, cc);

	/*
	 * If the operands have the same sign, then we add the mantissas;
	 * otherwise, we subtract the mantissas.
	 */
	xu += yu - ((yu << 1) & -(uint64_t)(sx ^ sy));

	/*
	 * The result may be smaller, or slightly larger. We normalize
	 * it to the 2^63..2^64-1 range (if xu is zero, then it stays
	 * at zero).
	 */
	FPR_NORM64(xu, ex);

	/*
	 * Scale down the value to 2^54..s^55-1, handling the last bit
	 * as sticky.
	 */
	xu |= ((uint32_t)xu & 0x1FF) + 0x1FF;
	xu >>= 9;
	ex += 9;

	/*
	 * In general, the result has the sign of x. However, if the
	 * result is exactly zero, then the following situations may
	 * be encountered:
	 *   x > 0, y = -x   -> result should be +0
	 *   x < 0, y = -x   -> result should be +0
	 *   x = +0, y = +0  -> result should be +0
	 *   x = -0, y = +0  -> result should be +0
	 *   x = +0, y = -0  -> result should be +0
	 *   x = -0, y = -0  -> result should be -0
	 *
	 * But at the conditional swap step at the start of the
	 * function, we ensured that if abs(x) = abs(y) and the
	 * sign of x was 1, then x and y were swapped. Thus, the
	 * two following cases cannot actually happen:
	 *   x < 0, y = -x
	 *   x = -0, y = +0
	 * In all other cases, the sign bit of x is conserved, which
	 * is what the FPR() function does. The FPR() function also
	 * properly clamps values to zero when the exponent is too
	 * low, but does not alter the sign in that case.
	 */
	return FPR(sx, ex, xu);
}

#endif // yyyASM_CORTEXM4-

#if FALCON_ASM_CORTEXM4 // yyyASM_CORTEXM4+1

__attribute__((naked))
fpr
fpr_mul(fpr x , fpr y )
{
	__asm__ (
	"push	{ r4, r5, r6, r7, r8, r10, r11, lr }\n\t"
	"\n\t"
	"@ Extract mantissas: x.m = r4:r5, y.m = r6:r7\n\t"
	"@ r4 and r6 contain only 25 bits each.\n\t"
	"bics	r4, r0, #0xFE000000\n\t"
	"lsls	r5, r1, #7\n\t"
	"orrs	r5, r5, r0, lsr #25\n\t"
	"orrs	r5, r5, #0x08000000\n\t"
	"bics	r5, r5, #0xF0000000\n\t"
	"bics	r6, r2, #0xFE000000\n\t"
	"lsls	r7, r3, #7\n\t"
	"orrs	r7, r7, r2, lsr #25\n\t"
	"orrs	r7, r7, #0x08000000\n\t"
	"bics	r7, r7, #0xF0000000\n\t"
	"\n\t"
	"@ Perform product. Values are in the 2^52..2^53-1 range, so\n\t"
	"@ the product is at most 106-bit long. Of the low 50 bits,\n\t"
	"@ we only want to know if they are all zeros or not. Here,\n\t"
	"@ we get the top 56 bits in r10:r11, and r8 will be non-zero\n\t"
	"@ if and only if at least one of the low 50 bits is non-zero.\n\t"
	"umull	r8, r10, r4, r6      @ x0*y0\n\t"
	"lsls	r10, #7\n\t"
	"orrs	r10, r10, r8, lsr #25\n\t"
	"eors	r11, r11\n\t"
	"umlal	r10, r11, r4, r7     @ x0*y1\n\t"
	"umlal	r10, r11, r5, r6     @ x1*y0\n\t"
	"orrs	r8, r8, r10, lsl #7\n\t"
	"lsrs	r10, #25\n\t"
	"orrs	r10, r10, r11, lsl #7\n\t"
	"eors	r11, r11\n\t"
	"umlal	r10, r11, r5, r7     @ x1*y1\n\t"
	"\n\t"
	"@ Now r0, r2, r4, r5, r6 and r7 are free.\n\t"
	"@ If any of the low 50 bits was non-zero, then we force the\n\t"
	"@ low bit of r10 to 1.\n\t"
	"rsbs	r4, r8, #0\n\t"
	"orrs	r8, r8, r4\n\t"
	"orrs	r10, r10, r8, lsr #31\n\t"
	"\n\t"
	"@ r8 is free.\n\t"
	"@ r10:r11 contains the product in the 2^54..2^56-1 range. We\n\t"
	"@ normalize it to 2^54..2^55-1 (into r6:r7) with a conditional\n\t"
	"@ shift (low bit is sticky). r5 contains -1 if the shift was done,\n\t"
	"@ 0 otherwise.\n\t"
	"ands	r6, r10, #1\n\t"
	"lsrs	r5, r11, #23\n\t"
	"rsbs	r5, r5, #0\n\t"
	"orrs	r6, r6, r10, lsr #1\n\t"
	"orrs	r6, r6, r11, lsl #31\n\t"
	"lsrs	r7, r11, #1\n\t"
	"eors	r10, r10, r6\n\t"
	"eors	r11, r11, r7\n\t"
	"bics	r10, r10, r5\n\t"
	"bics	r11, r11, r5\n\t"
	"eors	r6, r6, r10\n\t"
	"eors	r7, r7, r11\n\t"
	"\n\t"
	"@ Compute aggregate exponent: ex + ey - 1023 + w\n\t"
	"@ (where w = 1 if the conditional shift was done, 0 otherwise)\n\t"
	"@ But we subtract 1 because the injection of the mantissa high\n\t"
	"@ bit will increment the exponent by 1.\n\t"
	"lsls	r0, r1, #1\n\t"
	"lsls	r2, r3, #1\n\t"
	"lsrs	r0, #21\n\t"
	"addw	r4, r0, #0x7FF   @ save ex + 2047 in r4\n\t"
	"lsrs	r2, #21\n\t"
	"addw	r8, r2, #0x7FF   @ save ey + 2047 in r8\n\t"
	"adds	r2, r0\n\t"
	"subw	r2, r2, #1024\n\t"
	"subs	r2, r5\n\t"
	"\n\t"
	"@ r5 is free.\n\t"
	"@ Also, if either of the source exponents is 0, or the result\n\t"
	"@ exponent is 0 or negative, then the result is zero and the\n\t"
	"@ mantissa and the exponent shall be clamped to zero. Since\n\t"
	"@ r2 contains the result exponent minus 1, we test on r2\n\t"
	"@ being strictly negative.\n\t"
	"ands	r4, r8    @ if bit 11 = 0 then one of the exponents was 0\n\t"
	"mvns	r5, r2\n\t"
	"ands	r5, r5, r4, lsl #20\n\t"
	"ands	r2, r2, r5, asr #31\n\t"
	"ands	r6, r6, r5, asr #31\n\t"
	"ands	r7, r7, r5, asr #31\n\t"
	"\n\t"
	"@ Sign is the XOR of the sign of the operands. This is true in\n\t"
	"@ all cases, including very small results (exponent underflow)\n\t"
	"@ and zeros.\n\t"
	"eors	r1, r3\n\t"
	"bfc	r1, #0, #31\n\t"
	"\n\t"
	"@ Plug in the exponent.\n\t"
	"bfi	r1, r2, #20, #11\n\t"
	"\n\t"
	"@ r2 and r3 are free.\n\t"
	"@ Shift back to the normal 53-bit mantissa, with rounding.\n\t"
	"@ Mantissa goes into r0:r1. For r1, we must use an addition\n\t"
	"@ because the rounding may have triggered a carry, that should\n\t"
	"@ be added to the exponent.\n\t"
	"movs	r4, r6\n\t"
	"lsrs	r0, r6, #2\n\t"
	"orrs	r0, r0, r7, lsl #30\n\t"
	"adds	r1, r1, r7, lsr #2\n\t"
	"ands	r4, #0x7\n\t"
	"movs	r3, #0xC8\n\t"
	"lsrs	r3, r4\n\t"
	"ands	r3, #1\n\t"
	"adds	r0, r3\n\t"
	"adcs	r1, #0\n\t"
	"\n\t"
	"pop	{ r4, r5, r6, r7, r8, r10, r11, pc }\n\t"
	);
}

#else // yyyASM_CORTEXM4+0

fpr
fpr_mul(fpr x, fpr y)
{
	uint64_t xu, yu, w, zu, zv;
	uint32_t x0, x1, y0, y1, z0, z1, z2;
	int ex, ey, d, e, s;

	/*
	 * Extract absolute values as scaled unsigned integers. We
	 * don't extract exponents yet.
	 */
	xu = (x & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	yu = (y & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);

	/*
	 * We have two 53-bit integers to multiply; we need to split
	 * each into a lower half and a upper half. Moreover, we
	 * prefer to have lower halves to be of 25 bits each, for
	 * reasons explained later on.
	 */
	x0 = (uint32_t)xu & 0x01FFFFFF;
	x1 = (uint32_t)(xu >> 25);
	y0 = (uint32_t)yu & 0x01FFFFFF;
	y1 = (uint32_t)(yu >> 25);
	w = (uint64_t)x0 * (uint64_t)y0;
	z0 = (uint32_t)w & 0x01FFFFFF;
	z1 = (uint32_t)(w >> 25);
	w = (uint64_t)x0 * (uint64_t)y1;
	z1 += (uint32_t)w & 0x01FFFFFF;
	z2 = (uint32_t)(w >> 25);
	w = (uint64_t)x1 * (uint64_t)y0;
	z1 += (uint32_t)w & 0x01FFFFFF;
	z2 += (uint32_t)(w >> 25);
	zu = (uint64_t)x1 * (uint64_t)y1;
	z2 += (z1 >> 25);
	z1 &= 0x01FFFFFF;
	zu += z2;

	/*
	 * Since xu and yu are both in the 2^52..2^53-1 range, the
	 * product is in the 2^104..2^106-1 range. We first reassemble
	 * it and round it into the 2^54..2^56-1 range; the bottom bit
	 * is made "sticky". Since the low limbs z0 and z1 are 25 bits
	 * each, we just take the upper part (zu), and consider z0 and
	 * z1 only for purposes of stickiness.
	 * (This is the reason why we chose 25-bit limbs above.)
	 */
	zu |= ((z0 | z1) + 0x01FFFFFF) >> 25;

	/*
	 * We normalize zu to the 2^54..s^55-1 range: it could be one
	 * bit too large at this point. This is done with a conditional
	 * right-shift that takes into account the sticky bit.
	 */
	zv = (zu >> 1) | (zu & 1);
	w = zu >> 55;
	zu ^= (zu ^ zv) & -w;

	/*
	 * Get the aggregate scaling factor:
	 *
	 *   - Each exponent is biased by 1023.
	 *
	 *   - Integral mantissas are scaled by 2^52, hence an
	 *     extra 52 bias for each exponent.
	 *
	 *   - However, we right-shifted z by 50 bits, and then
	 *     by 0 or 1 extra bit (depending on the value of w).
	 *
	 * In total, we must add the exponents, then subtract
	 * 2 * (1023 + 52), then add 50 + w.
	 */
	ex = (int)((x >> 52) & 0x7FF);
	ey = (int)((y >> 52) & 0x7FF);
	e = ex + ey - 2100 + (int)w;

	/*
	 * Sign bit is the XOR of the operand sign bits.
	 */
	s = (int)((x ^ y) >> 63);

	/*
	 * Corrective actions for zeros: if either of the operands is
	 * zero, then the computations above were wrong. Test for zero
	 * is whether ex or ey is zero. We just have to set the mantissa
	 * (zu) to zero, the FPR() function will normalize e.
	 */
	d = ((ex + 0x7FF) & (ey + 0x7FF)) >> 11;
	zu &= -(uint64_t)d;

	/*
	 * FPR() packs the result and applies proper rounding.
	 */
	return FPR(s, e, zu);
}

#endif // yyyASM_CORTEXM4-

#if FALCON_ASM_CORTEXM4 // yyyASM_CORTEXM4+1

__attribute__((naked))
fpr
fpr_div(fpr x , fpr y )
{
	__asm__ (
	"push	{ r4, r5, r6, r7, r8, r10, r11, lr }\n\t"

	"@ Extract mantissas of x and y, in r0:r4 and r2:r5, respectively.\n\t"
	"@ We don't touch r1 and r3 as they contain the exponents and\n\t"
	"@ signs, which we'll need later on.\n\t"
	"ubfx	r4, r1, #0, #20\n\t"
	"ubfx	r5, r3, #0, #20\n\t"
	"orrs	r4, r4, #0x00100000\n\t"
	"orrs	r5, r5, #0x00100000\n\t"
	"\n\t"
	"@ Perform bit-by-bit division. We want a 56-bit result in r8:r10\n\t"
	"@ (low bit is 0). Bits come from the carry flag and are\n\t"
	"@ injected with rrx, i.e. in position 31; we thus get bits in\n\t"
	"@ the reverse order. Bits accumulate in r8; after the first 24\n\t"
	"@ bits, we move the quotient bits to r10.\n\t"
	"eors	r8, r8\n\t"
	"\n\t"

#define DIVSTEP \
	"subs	r6, r0, r2\n\t" \
	"sbcs	r7, r4, r5\n\t" \
	"rrx	r8, r8\n\t" \
	"ands	r6, r2, r8, asr #31\n\t" \
	"ands	r7, r5, r8, asr #31\n\t" \
	"subs	r0, r6\n\t" \
	"sbcs	r4, r7\n\t" \
	"adds	r0, r0, r0\n\t" \
	"adcs	r4, r4, r4\n\t"

#define DIVSTEP4   DIVSTEP DIVSTEP DIVSTEP DIVSTEP
#define DIVSTEP8   DIVSTEP4 DIVSTEP4

	DIVSTEP8
	DIVSTEP8
	DIVSTEP8

	"\n\t"
	"@ We have the first 24 bits of the quotient, move them to r10.\n\t"
	"rbit	r10, r8\n\t"
	"\n\t"

	DIVSTEP8
	DIVSTEP8
	DIVSTEP8
	DIVSTEP4 DIVSTEP DIVSTEP DIVSTEP

#undef DIVSTEP
#undef DIVSTEP4
#undef DIVSTEP8

	"\n\t"
	"@ Lowest bit will be set if remainder is non-zero at this point\n\t"
	"@ (this is the 'sticky' bit).\n\t"
	"subs	r0, #1\n\t"
	"sbcs	r4, #0\n\t"
	"rrx	r8, r8\n\t"
	"\n\t"
	"@ We now have the next (low) 32 bits of the quotient.\n\t"
	"rbit	r8, r8\n\t"
	"\n\t"
	"@ Since both operands had their top bit set, we know that the\n\t"
	"@ result at this point is in 2^54..2^56-1. We scale it down\n\t"
	"@ to 2^54..2^55-1 with a conditional shift. We also write the\n\t"
	"@ result in r4:r5. If the shift is done, r6 will contain -1.\n\t"
	"ands	r4, r8, #1\n\t"
	"lsrs	r6, r10, #23\n\t"
	"rsbs	r6, r6, #0\n\t"
	"orrs	r4, r4, r8, lsr #1\n\t"
	"orrs	r4, r4, r10, lsl #31\n\t"
	"lsrs	r5, r10, #1\n\t"
	"eors	r8, r8, r4\n\t"
	"eors	r10, r10, r5\n\t"
	"bics	r8, r8, r6\n\t"
	"bics	r10, r10, r6\n\t"
	"eors	r4, r4, r8\n\t"
	"eors	r5, r5, r10\n\t"
	"\n\t"
	"@ Compute aggregate exponent: ex - ey + 1022 + w\n\t"
	"@ (where w = 1 if the conditional shift was done, 0 otherwise)\n\t"
	"@ But we subtract 1 because the injection of the mantissa high\n\t"
	"@ bit will increment the exponent by 1.\n\t"
	"lsls	r0, r1, #1\n\t"
	"lsls	r2, r3, #1\n\t"
	"lsrs	r0, r0, #21\n\t"
	"addw	r7, r0, #0x7FF  @ save ex + 2047 in r7\n\t"
	"subs	r0, r0, r2, lsr #21\n\t"
	"addw	r0, r0, #1021\n\t"
	"subs	r0, r6\n\t"
	"\n\t"
	"@ If the x operand was zero, then the computation was wrong and\n\t"
	"@ the result is zero. Also, if the result exponent is zero or\n\t"
	"@ negative, then the mantissa shall be clamped to zero. Since r0\n\t"
	"@ contains the result exponent minus 1, we test on r0 being\n\t"
	"@ strictly negative.\n\t"
	"mvns	r2, r0\n\t"
	"ands	r2, r2, r7, lsl #20\n\t"
	"ands	r0, r0, r2, asr #31\n\t"
	"ands	r4, r4, r2, asr #31\n\t"
	"ands	r5, r5, r2, asr #31\n\t"
	"\n\t"
	"@ Sign is the XOR of the sign of the operands. This is true in\n\t"
	"@ all cases, including very small results (exponent underflow)\n\t"
	"@ and zeros.\n\t"
	"eors	r1, r3\n\t"
	"bfc	r1, #0, #31\n\t"
	"\n\t"
	"@ Plug in the exponent.\n\t"
	"bfi	r1, r0, #20, #11\n\t"
	"\n\t"
	"@ Shift back to the normal 53-bit mantissa, with rounding.\n\t"
	"@ Mantissa goes into r0:r1. For r1, we must use an addition\n\t"
	"@ because the rounding may have triggered a carry, that should\n\t"
	"@ be added to the exponent.\n\t"
	"movs	r6, r4\n\t"
	"lsrs	r0, r4, #2\n\t"
	"orrs	r0, r0, r5, lsl #30\n\t"
	"adds	r1, r1, r5, lsr #2\n\t"
	"ands	r6, #0x7\n\t"
	"movs	r3, #0xC8\n\t"
	"lsrs	r3, r6\n\t"
	"ands	r3, #1\n\t"
	"adds	r0, r3\n\t"
	"adcs	r1, #0\n\t"
	"\n\t"
	"pop	{ r4, r5, r6, r7, r8, r10, r11, pc }\n\t"
	);
}

#else // yyyASM_CORTEXM4+0

fpr
fpr_div(fpr x, fpr y)
{
	uint64_t xu, yu, q, q2, w;
	int i, ex, ey, e, d, s;

	/*
	 * Extract mantissas of x and y (unsigned).
	 */
	xu = (x & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	yu = (y & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);

	/*
	 * Perform bit-by-bit division of xu by yu. We run it for 55 bits.
	 */
	q = 0;
	for (i = 0; i < 55; i ++) {
		/*
		 * If yu is less than or equal xu, then subtract it and
		 * push a 1 in the quotient; otherwise, leave xu unchanged
		 * and push a 0.
		 */
		uint64_t b;

		b = ((xu - yu) >> 63) - 1;
		xu -= b & yu;
		q |= b & 1;
		xu <<= 1;
		q <<= 1;
	}

	/*
	 * We got 55 bits in the quotient, followed by an extra zero. We
	 * want that 56th bit to be "sticky": it should be a 1 if and
	 * only if the remainder (xu) is non-zero.
	 */
	q |= (xu | -xu) >> 63;

	/*
	 * Quotient is at most 2^56-1. Its top bit may be zero, but in
	 * that case the next-to-top bit will be a one, since the
	 * initial xu and yu were both in the 2^52..2^53-1 range.
	 * We perform a conditional shift to normalize q to the
	 * 2^54..2^55-1 range (with the bottom bit being sticky).
	 */
	q2 = (q >> 1) | (q & 1);
	w = q >> 55;
	q ^= (q ^ q2) & -w;

	/*
	 * Extract exponents to compute the scaling factor:
	 *
	 *   - Each exponent is biased and we scaled them up by
	 *     52 bits; but these biases will cancel out.
	 *
	 *   - The division loop produced a 55-bit shifted result,
	 *     so we must scale it down by 55 bits.
	 *
	 *   - If w = 1, we right-shifted the integer by 1 bit,
	 *     hence we must add 1 to the scaling.
	 */
	ex = (int)((x >> 52) & 0x7FF);
	ey = (int)((y >> 52) & 0x7FF);
	e = ex - ey - 55 + (int)w;

	/*
	 * Sign is the XOR of the signs of the operands.
	 */
	s = (int)((x ^ y) >> 63);

	/*
	 * Corrective actions for zeros: if x = 0, then the computation
	 * is wrong, and we must clamp e and q to 0. We do not care
	 * about the case y = 0 (as per assumptions in this module,
	 * the caller does not perform divisions by zero).
	 */
	d = (ex + 0x7FF) >> 11;
	s &= d;
	e &= -d;
	q &= -(uint64_t)d;

	/*
	 * FPR() packs the result and applies proper rounding.
	 */
	return FPR(s, e, q);
}

#endif // yyyASM_CORTEXM4-

#if FALCON_ASM_CORTEXM4 // yyyASM_CORTEXM4+1

__attribute__((naked))
fpr
fpr_sqrt(fpr x )
{
	__asm__ (
	"push	{ r4, r5, r6, r7, r8, r10, r11, lr }\n\t"
	"\n\t"
	"@ Extract mantissa (r0:r1) and exponent (r2). We assume that the\n\t"
	"@ sign is positive. If the source is zero, then the mantissa is\n\t"
	"@ set to 0.\n\t"
	"lsrs	r2, r1, #20\n\t"
	"bfc	r1, #20, #12\n\t"
	"addw	r3, r2, #0x7FF\n\t"
	"subw	r2, r2, #1023\n\t"
	"lsrs	r3, r3, #11\n\t"
	"orrs	r1, r1, r3, lsl #20\n\t"
	"\n\t"
	"@ If the exponent is odd, then multiply mantissa by 2 and subtract\n\t"
	"@ 1 from the exponent.\n\t"
	"ands	r3, r2, #1\n\t"
	"subs	r2, r2, r3\n\t"
	"rsbs	r3, r3, #0\n\t"
	"ands	r4, r1, r3\n\t"
	"ands	r3, r0\n\t"
	"adds	r0, r3\n\t"
	"adcs	r1, r4\n\t"
	"\n\t"
	"@ Left-shift the mantissa by 9 bits to put it in the\n\t"
	"@ 2^61..2^63-1 range (unless it is exactly 0).\n\t"
	"lsls	r1, r1, #9\n\t"
	"orrs	r1, r1, r0, lsr #23\n\t"
	"lsls	r0, r0, #9\n\t"
	"\n\t"
	"@ Compute the square root bit-by-bit.\n\t"
	"@ There are 54 iterations; first 30 can work on top word only.\n\t"
	"@   q = r3 (bit-reversed)\n\t"
	"@   s = r5\n\t"
	"eors	r3, r3\n\t"
	"eors	r5, r5\n\t"

#define SQRT_STEP_HI(bit) \
	"orrs	r6, r5, #(1 << (" #bit "))\n\t" \
	"subs	r7, r1, r6\n\t" \
	"rrx	r3, r3\n\t" \
	"ands	r6, r6, r3, asr #31\n\t" \
	"subs	r1, r1, r6\n\t" \
	"lsrs	r6, r3, #31\n\t" \
	"orrs	r5, r5, r6, lsl #((" #bit ") + 1)\n\t" \
	"adds	r0, r0\n\t" \
	"adcs	r1, r1\n\t"

#define SQRT_STEP_HIx5(b)  \
		SQRT_STEP_HI((b)+4) \
		SQRT_STEP_HI((b)+3) \
		SQRT_STEP_HI((b)+2) \
		SQRT_STEP_HI((b)+1) \
		SQRT_STEP_HI(b)

	SQRT_STEP_HIx5(25)
	SQRT_STEP_HIx5(20)
	SQRT_STEP_HIx5(15)
	SQRT_STEP_HIx5(10)
	SQRT_STEP_HIx5(5)
	SQRT_STEP_HIx5(0)

#undef SQRT_STEP_HI
#undef SQRT_STEP_HIx5

	"@ Top 30 bits of the result must be reversed: they were\n\t"
	"@ accumulated with rrx (hence from the top bit).\n\t"
	"rbit	r3, r3\n\t"
	"\n\t"
	"@ For the next 24 iterations, we must use two-word operations.\n\t"
	"@   bits of q now accumulate in r4\n\t"
	"@   s is in r6:r5\n\t"
	"eors	r4, r4\n\t"
	"eors	r6, r6\n\t"
	"\n\t"
	"@ First iteration is special because the potential bit goes into\n\t"
	"@ r5, not r6.\n\t"
	"orrs	r7, r6, #(1 << 31)\n\t"
	"subs	r8, r0, r7\n\t"
	"sbcs	r10, r1, r5\n\t"
	"rrx	r4, r4\n\t"
	"ands	r7, r7, r4, asr #31\n\t"
	"ands	r8, r5, r4, asr #31\n\t"
	"subs	r0, r0, r7\n\t"
	"sbcs	r1, r1, r8\n\t"
	"lsrs	r7, r4, #31\n\t"
	"orrs	r5, r5, r4, lsr #31\n\t"
	"adds	r0, r0\n\t"
	"adcs	r1, r1\n\t"

#define SQRT_STEP_LO(bit) \
	"orrs	r7, r6, #(1 << (" #bit "))\n\t" \
	"subs	r8, r0, r7\n\t" \
	"sbcs	r10, r1, r5\n\t" \
	"rrx	r4, r4\n\t" \
	"ands	r7, r7, r4, asr #31\n\t" \
	"ands	r8, r5, r4, asr #31\n\t" \
	"subs	r0, r0, r7\n\t" \
	"sbcs	r1, r1, r8\n\t" \
	"lsrs	r7, r4, #31\n\t" \
	"orrs	r6, r6, r7, lsl #((" #bit ") + 1)\n\t" \
	"adds	r0, r0\n\t" \
	"adcs	r1, r1\n\t"

#define SQRT_STEP_LOx4(b) \
		SQRT_STEP_LO((b)+3) \
		SQRT_STEP_LO((b)+2) \
		SQRT_STEP_LO((b)+1) \
		SQRT_STEP_LO(b)

	SQRT_STEP_LO(30)
	SQRT_STEP_LO(29)
	SQRT_STEP_LO(28)
	SQRT_STEP_LOx4(24)
	SQRT_STEP_LOx4(20)
	SQRT_STEP_LOx4(16)
	SQRT_STEP_LOx4(12)
	SQRT_STEP_LOx4(8)

#undef SQRT_STEP_LO
#undef SQRT_STEP_LOx4

	"@ Put low 24 bits in the right order.\n\t"
	"rbit	r4, r4\n\t"
	"\n\t"
	"@ We have a 54-bit result; compute the 55-th bit as the 'sticky'\n\t"
	"@ bit: it is non-zero if and only if r0:r1 is non-zero. We put the\n\t"
	"@ three low bits (including the sticky bit) in r5.\n\t"
	"orrs	r0, r1\n\t"
	"rsbs	r1, r0, #0\n\t"
	"orrs	r0, r1\n\t"
	"lsls	r5, r4, #1\n\t"
	"orrs	r5, r5, r0, lsr #31\n\t"
	"ands	r5, #0x7\n\t"
	"\n\t"
	"@ Compute the rounding: r6 is set to 0 or 1, and will be added\n\t"
	"@ to the mantissa.\n\t"
	"movs	r6, #0xC8\n\t"
	"lsrs	r6, r5\n\t"
	"ands	r6, #1\n\t"
	"\n\t"
	"@ Put the mantissa (53 bits, in the 2^52..2^53-1 range) in r0:r1\n\t"
	"@ (rounding not applied yet).\n\t"
	"lsrs	r0, r4, #1\n\t"
	"orrs	r0, r0, r3, lsl #23\n\t"
	"lsrs	r1, r3, #9\n\t"
	"\n\t"
	"@ Compute new exponent. This is half the old one (then reencoded\n\t"
	"@ by adding 1023). Exception: if the mantissa is zero, then the\n\t"
	"@ encoded exponent is set to 0. At that point, if the mantissa\n\t"
	"@ is non-zero, then its high bit (bit 52, i.e. bit 20 of r1) is\n\t"
	"@ non-zero. Note that the exponent cannot go out of range.\n\t"
	"lsrs	r2, r2, #1\n\t"
	"addw	r2, r2, #1023\n\t"
	"lsrs	r5, r1, #20\n\t"
	"rsbs	r5, r5, #0\n\t"
	"ands	r2, r5\n\t"
	"\n\t"
	"@ Place exponent. This overwrites the high bit of the mantissa.\n\t"
	"bfi	r1, r2, #20, #11\n\t"
	"\n\t"
	"@ Apply rounding. This may create a carry that will spill into\n\t"
	"@ the exponent, which is exactly what should be done in that case\n\t"
	"@ (i.e. increment the exponent).\n\t"
	"adds	r0, r0, r6\n\t"
	"adcs	r1, r1, #0\n\t"
	"\n\t"
	"pop	{ r4, r5, r6, r7, r8, r10, r11, pc }\n\t"
	);
}

#else // yyyASM_CORTEXM4+0

fpr
fpr_sqrt(fpr x)
{
	uint64_t xu, q, s, r;
	int ex, e;

	/*
	 * Extract the mantissa and the exponent. We don't care about
	 * the sign: by assumption, the operand is nonnegative.
	 * We want the "true" exponent corresponding to a mantissa
	 * in the 1..2 range.
	 */
	xu = (x & (((uint64_t)1 << 52) - 1)) | ((uint64_t)1 << 52);
	ex = (int)((x >> 52) & 0x7FF);
	e = ex - 1023;

	/*
	 * If the exponent is odd, double the mantissa and decrement
	 * the exponent. The exponent is then halved to account for
	 * the square root.
	 */
	xu += xu & -(uint64_t)(e & 1);
	e >>= 1;

	/*
	 * Double the mantissa.
	 */
	xu <<= 1;

	/*
	 * We now have a mantissa in the 2^53..2^55-1 range. It
	 * represents a value between 1 (inclusive) and 4 (exclusive)
	 * in fixed point notation (with 53 fractional bits). We
	 * compute the square root bit by bit.
	 */
	q = 0;
	s = 0;
	r = (uint64_t)1 << 53;
	for (int i = 0; i < 54; i ++) {
		uint64_t t, b;

		t = s + r;
		b = ((xu - t) >> 63) - 1;
		s += (r << 1) & b;
		xu -= t & b;
		q += r & b;
		xu <<= 1;
		r >>= 1;
	}

	/*
	 * Now, q is a rounded-low 54-bit value, with a leading 1,
	 * 52 fractional digits, and an additional guard bit. We add
	 * an extra sticky bit to account for what remains of the operand.
	 */
	q <<= 1;
	q |= (xu | -xu) >> 63;

	/*
	 * Result q is in the 2^54..2^55-1 range; we bias the exponent
	 * by 54 bits (the value e at that point contains the "true"
	 * exponent, but q is now considered an integer, i.e. scaled
	 * up.
	 */
	e -= 54;

	/*
	 * Corrective action for an operand of value zero.
	 */
	q &= -(uint64_t)((ex + 0x7FF) >> 11);

	/*
	 * Apply rounding and back result.
	 */
	return FPR(0, e, q);
}

#endif // yyyASM_CORTEXM4-
