/* Finite, exact-value checks for the pinned FT1536 FPEMU build. */
#include <stdio.h>
#include <stdint.h>
#include "internal.h"

typedef char assert_fpr_width[(sizeof(fpr) == 8) ? 1 : -1];

#define CHECK(expr) do { \
	if (!(expr)) { \
		fprintf(stderr, "FPEMU check failed at line %d: %s\n", __LINE__, #expr); \
		return 1; \
	} \
	count++; \
} while (0)

int
main(void)
{
	unsigned count = 0;
	/* The bitwise expression also requires the integer-emulated fpr type. */
	CHECK((fpr_one ^ UINT64_C(0x3ff0000000000000)) == 0);
	CHECK(fpr_of(0) == fpr_zero);
	CHECK(fpr_of(1) == fpr_one);
	CHECK(fpr_add(fpr_one, fpr_one) == fpr_two);
	CHECK(fpr_mul(fpr_two, fpr_onehalf) == fpr_one);
	CHECK(fpr_div(fpr_one, fpr_two) == fpr_onehalf);
	CHECK(fpr_sqrt(fpr_of(4)) == fpr_two);
	CHECK(fpr_floor(fpr_neg(fpr_onehalf)) == -1);
	CHECK(fpr_rint(fpr_onehalf) == 0);
	CHECK(fpr_rint(fpr_add(fpr_one, fpr_onehalf)) == 2);
	CHECK(fpr_mul_high_u64(UINT64_MAX, UINT64_MAX) == UINT64_MAX - 1);
	CHECK(fpr_expm_scaled(fpr_zero) == (UINT64_C(1) << 63));
	printf("{\"scope\":\"finite FT1536 FPEMU smoke\",\"checks\":%u,\"result\":\"PASS\"}\n", count);
	return 0;
}
