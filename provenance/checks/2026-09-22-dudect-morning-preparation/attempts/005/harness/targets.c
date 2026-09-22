/* Public scalar timing entry points; production sources are unchanged.
 * FT1536 harness, Niirmata. See the licenses in the Falcon source inputs.
 */
#include "internal.h"

typedef uint64_t (*target_fn)(uint64_t, uint64_t);

#define UNARY(name, expr) \
    static uint64_t name(uint64_t x, uint64_t y) { (void)y; return (uint64_t)(expr); }
UNARY(target_floor, fpr_floor(x))
UNARY(target_sqrt, fpr_sqrt(x))
UNARY(target_rint, fpr_rint(x))
UNARY(target_expm, fpr_expm_scaled(x))
UNARY(target_half, fpr_half(x))
UNARY(target_scaled, fpr_scaled((int64_t)x, 0))

static uint64_t target_add(uint64_t x, uint64_t y) { return fpr_add(x, y); }
static uint64_t target_mul(uint64_t x, uint64_t y) { return fpr_mul(x, y); }
static uint64_t target_div(uint64_t x, uint64_t y) { return fpr_div(x, y); }
static uint64_t target_lt(uint64_t x, uint64_t y) { return (uint64_t)fpr_lt(x, y); }

/* Intentionally variable work, separate from every production target. */
static uint64_t positive_loop(uint64_t x, uint64_t y)
{
    volatile uint64_t v = y;
    unsigned n = (x & 1) ? 256 : 8;
    for (unsigned i = 0; i < n; i++) v = v * UINT64_C(6364136223846793005) + 1;
    return v;
}

target_fn select_target(unsigned c)
{
    static target_fn const targets[] = {
        target_floor, positive_loop, target_floor, target_floor, target_floor,
        target_add, target_mul, target_div, target_sqrt, target_rint,
        target_expm, target_half, target_lt, target_scaled
    };
    return c < sizeof targets / sizeof *targets ? targets[c] : NULL;
}
