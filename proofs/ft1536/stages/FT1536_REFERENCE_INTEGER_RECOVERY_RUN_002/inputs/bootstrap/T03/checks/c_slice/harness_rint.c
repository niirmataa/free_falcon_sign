/* FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- fpr_rint source slice control.
 *
 * Exercises the PUBLISHED fpr_rint (fpr-emulated.h 99-115) on boundary/tie
 * neighbourhoods and deterministic fixture words, with domain preflight
 * (encoded exponent ex <= 1072 guarded BEFORE the native call).
 * The fixture generator is a local xorshift for word coverage only; it is not
 * the scheme PRNG and no scheme seed/key material is used.
 *
 * Output (stdout): one line per case "HEXWORD RESULT", then "SUMMARY n skip".
 */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "fpr-emulated.h"

static uint64_t xs;
static uint64_t next_raw(void) {
    xs ^= xs << 13;
    xs ^= xs >> 7;
    xs ^= xs << 17;
    return xs;
}

/* IEEE754-binary64-shaped word decode (fpr-emulated semantics). */
static int encoded_exp_ok(fpr x) {
    uint64_t u = (uint64_t)x;
    uint64_t ex = (u >> 52) & 0x7FF;
    return ex <= 1072;
}

int main(void) {
    long n = 0, skipped = 0;
    /* boundary/tie neighbourhoods: v + s/2 and v + s/4 for extreme and small v */
    static const int64_t vs[] = {
        0, 1, -1, 2, -2, 3, -3, 4, -4, 5, -5,
        32766, 32767, 32768, -32766, -32767, -32768,
        4572094, 4572095, -4572094, -4572095,
        16777215, -16777215, 1048576, -1048576
    };
    fpr one = fpr_one;
    fpr half = fpr_half(one);
    fpr quart = fpr_half(half);
    fpr nzero = fpr_sub(fpr_zero, one); /* -1, for negatives of halves */
    fpr nhalf = fpr_mul(half, nzero);
    fpr nquart = fpr_mul(quart, nzero);
    size_t i, j;
    fpr offs[6];
    offs[0] = fpr_zero;
    offs[1] = half;
    offs[2] = nhalf;
    offs[3] = quart;
    offs[4] = nquart;
    offs[5] = one; /* v+1 with its own tie neighbourhood covered by shifting v */

    for (i = 0; i < sizeof vs / sizeof vs[0]; i++) {
        for (j = 0; j < 5; j++) {
            fpr t = fpr_add(fpr_of(vs[i]), offs[j]);
            if (!encoded_exp_ok(t)) { skipped++; continue; }
            printf("%016llx %lld\n", (unsigned long long)(uint64_t)t,
                   (long long)fpr_rint(t));
            n++;
        }
    }
    /* signed zeros */
    {
        fpr pz = fpr_zero;
        fpr mz = fpr_sub(fpr_zero, fpr_zero); /* deterministic +0 path */
        uint64_t negzero = 0x8000000000000000ULL;
        fpr s0 = (fpr)negzero;
        printf("%016llx %lld\n", (unsigned long long)(uint64_t)pz, (long long)fpr_rint(pz));
        printf("%016llx %lld\n", (unsigned long long)(uint64_t)mz, (long long)fpr_rint(mz));
        printf("%016llx %lld\n", (unsigned long long)(uint64_t)s0, (long long)fpr_rint(s0));
        n += 3;
    }
    /* deterministic fixture words with preflight on the encoded exponent */
    xs = 0x9E3779B97F4A7C15ULL;
    for (i = 0; i < 20000; i++) {
        uint64_t raw = next_raw();
        /* force exponent field into the proved domain 0..1072 */
        uint64_t ex = (raw >> 52) & 0x7FF;
        if (ex > 1072) {
            ex = ex % 1073;
            raw = (raw & ~(0x7FFULL << 52)) | (ex << 52);
        }
        {
            fpr t = (fpr)raw;
            if (!encoded_exp_ok(t)) { skipped++; continue; }
            printf("%016llx %lld\n", (unsigned long long)raw, (long long)fpr_rint(t));
            n++;
        }
    }
    printf("SUMMARY %ld %ld\n", n, skipped);
    return 0;
}
