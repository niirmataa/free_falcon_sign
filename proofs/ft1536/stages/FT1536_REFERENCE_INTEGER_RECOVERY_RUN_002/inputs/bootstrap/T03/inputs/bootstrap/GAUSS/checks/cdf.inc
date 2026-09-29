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

/*
 * Interpret one uniform 128-bit value through all proposal tables. All
 * table entries are read on every call; the appropriate sample is selected
 * arithmetically afterwards.
 */
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
