#include "../source/ft1536-adaptive-cdf-tables.h"
static uint64_t
ft_fpr_bits(fpr x)
{
	uint64_t w;

	memcpy(&w, &x, sizeof w);
	return w;
}
static fpr
ft_fpr_from_bits(uint64_t w)
{
	fpr x;

	memcpy(&x, &w, sizeof x);
	return x;
}
static int
ft_fpr_is_positive_finite(fpr x)
{
	uint64_t w, e;

	w = ft_fpr_bits(x);
	e = (w >> 52) & 0x7FF;
	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
}
static int
ft_fpr_is_finite(fpr x)
{
	uint64_t w;

	w = ft_fpr_bits(x);
	return (int)(((w >> 52) & 0x7FF) != 0x7FF);
}
static int
ft_fpr_is_nonnegative_finite(fpr x)
{
	uint64_t w, e;

	w = ft_fpr_bits(x);
	e = (w >> 52) & 0x7FF;
	return (int)(e != 0x7FF && ((w >> 63) == 0 || (w << 1) == 0));
}
static uint64_t
ft_ct_lt_u64(uint64_t x, uint64_t y)
{
	return (x ^ ((x ^ y) | ((x - y) ^ y))) >> 63;
}
static uint64_t
ft_ct_eq_u64(uint64_t x, uint64_t y)
{
	uint64_t q;

	q = x ^ y;
	return 1 ^ ((q | (0 - q)) >> 63);
}
static uint64_t
ft_ct_lt_u128(uint64_t x_hi, uint64_t x_lo,
	uint64_t y_hi, uint64_t y_lo)
{
	uint64_t hi_lt, hi_eq, lo_lt;

	hi_lt = ft_ct_lt_u64(x_hi, y_hi);
	hi_eq = ft_ct_eq_u64(x_hi, y_hi);
	lo_lt = ft_ct_lt_u64(x_lo, y_lo);
	return hi_lt | (hi_eq & lo_lt);
}
static void
ft_adaptive_cdf_samples(uint64_t hi, uint64_t lo,
	int samples[FT_ADAPTIVE_CDF_LEVELS])
{
	unsigned level, u;

	for (level = 0; level < FT_ADAPTIVE_CDF_LEVELS; level ++) {
		uint64_t z;

		z = 0;
		for (u = 0; u < FT_ADAPTIVE_CDF_TABLE_LEN; u ++) {
			z += ft_ct_lt_u128(hi, lo,
				ft_adaptive_cdf[level][u][0],
				ft_adaptive_cdf[level][u][1]);
		}
		samples[level] = (int)z;
	}
}
static void
ft_berexp_cutoff_state(uint32_t sw, uint32_t *safe_s, uint32_t *over)
{
	*over = (63U - sw) >> 31;
	*safe_s = sw ^ ((sw ^ 63U) & (0U - *over));
}
