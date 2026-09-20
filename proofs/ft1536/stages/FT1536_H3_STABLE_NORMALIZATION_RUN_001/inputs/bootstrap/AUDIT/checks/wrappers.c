/* Public scalar-only audit entry points; unchanged portable source is included. */
#include "fpr-emulated.c"
#define WRAP1(name, type) type audit_##name(fpr x) { return fpr_##name(x); }
WRAP1(rint, int64_t)
WRAP1(floor, long)
WRAP1(trunc, int64_t)
WRAP1(half, fpr)
WRAP1(double, fpr)
WRAP1(expm_scaled, uint64_t)
WRAP1(exp_small, fpr)
WRAP1(log_emu, fpr)
fpr audit_max(fpr x, fpr y) { return fpr_max(x, y); }
int audit_lt(fpr x, fpr y) { return fpr_lt(x, y); }
uint64_t audit_high(uint64_t x, uint64_t y) { return fpr_mul_high_u64(x, y); }
void audit_sincos(fpr *c, fpr *s, uint32_t b) { fpr_sincos_tick(c, s, b); }
