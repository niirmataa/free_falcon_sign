/* Hex-word protocol; fixtures contain only public synthetic operands. */
#include <inttypes.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include "wrappers.c"

int main(void)
{
    char op[24];
    uint64_t x, y, z, r;
    int n, e;
    int64_t ix;
    while (scanf("%23s %" SCNx64 " %" SCNx64 " %d", op, &x, &y, &n) == 4) {
        z = 0;
        memcpy(&ix, &x, sizeof ix);
        if (!strcmp(op, "of") || !strcmp(op, "scaled") || !strcmp(op, "inverse_of")) {
            if (ix == INT64_MIN || n < -2100 || n > 1100 ||
                (!strcmp(op, "inverse_of") && ix == 0)) return 2;
        }
        if (!strcmp(op, "of")) r = fpr_of(ix);
        else if (!strcmp(op, "scaled")) r = fpr_scaled(ix, n);
        else if (!strcmp(op, "inverse_of")) r = fpr_inverse_of((long)ix);
        else if (!strcmp(op, "add")) r = fpr_add(x, y);
        else if (!strcmp(op, "sub")) r = fpr_sub(x, y);
        else if (!strcmp(op, "mul")) r = fpr_mul(x, y);
        else if (!strcmp(op, "sqr")) r = fpr_sqr(x);
        else if (!strcmp(op, "neg")) r = fpr_neg(x);
        else if (!strcmp(op, "div")) { if ((y << 1) == 0) return 2; r = fpr_div(x, y); }
        else if (!strcmp(op, "inv")) { if ((x << 1) == 0) return 2; r = fpr_inv(x); }
        else if (!strcmp(op, "sqrt")) { if ((x >> 63) && (x << 1)) return 2; r = fpr_sqrt(x); }
        else if (!strcmp(op, "half")) r = fpr_half(x);
        else if (!strcmp(op, "double")) r = fpr_double(x);
        else if (!strcmp(op, "floor")) r = (uint64_t)fpr_floor(x);
        else if (!strcmp(op, "rint")) r = (uint64_t)fpr_rint(x);
        else if (!strcmp(op, "trunc")) r = (uint64_t)fpr_trunc(x);
        else if (!strcmp(op, "lt")) r = (uint64_t)fpr_lt(x, y);
        else if (!strcmp(op, "max")) r = fpr_max(x, y);
        else if (!strcmp(op, "high")) r = fpr_mul_high_u64(x, y);
        else if (!strcmp(op, "expm")) r = fpr_expm_scaled(x);
        else if (!strcmp(op, "exp_small")) r = fpr_exp_small(x);
        else if (!strcmp(op, "log")) r = fpr_log_emu(x);
        else if (!strcmp(op, "sincos")) fpr_sincos_tick(&r, &z, (uint32_t)x);
        else if (!strcmp(op, "pack")) {
            if (n < -2100 || n > 1100 || y > 1 || (x != 0 && (x < (UINT64_C(1)<<54) || x >= (UINT64_C(1)<<55)))) return 2;
            r = FPR((int)y, n, x);
        } else if (!strcmp(op, "norm")) {
            e = 0; FPR_NORM64(x, e); r = x; z = (uint64_t)(int64_t)e;
        } else if (!strcmp(op, "ursh") || !strcmp(op, "irsh") || !strcmp(op, "ulsh")) {
            if (n < 0 || n > 63) return 2;
            if (!strcmp(op, "ursh")) r = fpr_ursh(x, n);
            else if (!strcmp(op, "irsh")) r = (uint64_t)fpr_irsh(ix, n);
            else r = fpr_ulsh(x, n);
        } else return 3;
        printf("%016" PRIx64 " %016" PRIx64 "\n", r, z);
    }
    return ferror(stdin) ? 4 : 0;
}
