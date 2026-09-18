/* Observation only: copy the actual norm arguments, then call unchanged S17.
 * The inherited harness is preserved. No NTT or decoder replacement here. */
#define falcon_is_short lv_capture_short
#include "../scripts/harness.c"
#undef falcon_is_short

extern int falcon_is_short(const int16_t *, const int16_t *, unsigned, unsigned);
static int16_t actual_first[1536], actual_second[1536];
static int norm_calls;

int lv_capture_short(const int16_t *a, const int16_t *b,
                     unsigned logn, unsigned ternary)
{
    if (logn != 10 || ternary != 1) abort();
    memcpy(actual_first, a, sizeof actual_first);
    memcpy(actual_second, b, sizeof actual_second);
    norm_calls++;
    return falcon_is_short(a, b, logn, ternary);
}

void lv_observed(int16_t *a, int16_t *b)
{
    memcpy(a, actual_first, sizeof actual_first);
    memcpy(b, actual_second, sizeof actual_second);
}

void lv_observed_reset(void) { norm_calls = 0; }
int lv_observed_calls(void) { return norm_calls; }
