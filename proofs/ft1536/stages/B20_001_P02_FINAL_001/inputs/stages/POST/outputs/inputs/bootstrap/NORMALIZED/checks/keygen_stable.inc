#define FT1536_LEAF_MIN_BITS       UINT64_C(0x4090000053700377)
#define FT1536_LEAF_MAX_BITS       UINT64_C(0x4114444d1a037d50)
#define FT1536_KEYGEN_Q_SQUARED    ((int64_t)339775489)

/*
 * ====================================================================
 * FPR BITCAST HELPERS — DUPLICATED FROM falcon-sign.c
 * ====================================================================
 */
static inline uint64_t
ft_fpr_bits_keygen(fpr x)
{
	uint64_t w;
	memcpy(&w, &x, sizeof w);
	return w;
}

static inline fpr
ft_fpr_from_bits_keygen(uint64_t w)
{
	fpr x;
	memcpy(&x, &w, sizeof x);
	return x;
}

static inline int
ft_fpr_is_positive_finite_keygen(fpr x)
{
	uint64_t w, e;
	w = ft_fpr_bits_keygen(x);
	e = (w >> 52) & 0x7FF;
	return (int)((w >> 63) == 0 && e != 0x7FF && (w << 1) != 0);
}

static fpr
ft_stable_positive_keygen(fpr x, uint32_t *bad)
{
	uint64_t mask, xb;
	uint32_t valid;
	valid = (uint32_t)ft_fpr_is_positive_finite_keygen(x);
	*bad |= valid ^ 1U;
	mask = (uint64_t)0 - (uint64_t)valid;
	xb = ft_fpr_bits_keygen(x);
	return ft_fpr_from_bits_keygen(
		(xb & mask) | (ft_fpr_bits_keygen(fpr_one) & ~mask));
}

static void
ft_stable_binary_inplace_keygen(fpr *values, size_t n,
	fpr *scratch, uint32_t *bad)
{
	size_t hn, u;
	if (n == 1) {
		values[0] = ft_stable_positive_keygen(values[0], bad);
		return;
	}
	hn = n >> 1;
	for (u = 0; u < hn; u ++) {
		fpr a, b, product, sum;
		a = ft_stable_positive_keygen(values[(u << 1) + 0], bad);
		b = ft_stable_positive_keygen(values[(u << 1) + 1], bad);
		sum = ft_stable_positive_keygen(fpr_add(a, b), bad);
		product = ft_stable_positive_keygen(fpr_mul(a, b), bad);
		scratch[u] = ft_stable_positive_keygen(fpr_half(sum), bad);
		scratch[u + hn] = ft_stable_positive_keygen(
			fpr_div(fpr_double(product), sum), bad);
	}
	memcpy(values, scratch, n * sizeof *values);
	ft_stable_binary_inplace_keygen(values, hn, scratch, bad);
	ft_stable_binary_inplace_keygen(values + hn, hn, scratch, bad);
}

static void
ft_stable_top_branch_keygen(const fpr *roots, fpr *leaves,
	fpr *scratch, uint32_t *bad)
{
	fpr three;
	size_t u, v;
	three = fpr_of(3);
	for (u = 0, v = 0; u < 768; u += 3, v ++) {
		fpr a, ab, abc, ac, b, bc, c, e1, e2;
		a = ft_stable_positive_keygen(roots[u + 0], bad);
		b = ft_stable_positive_keygen(roots[u + 1], bad);
		c = ft_stable_positive_keygen(roots[u + 2], bad);
		e1 = ft_stable_positive_keygen(fpr_add(fpr_add(a, b), c), bad);
		ab = ft_stable_positive_keygen(fpr_mul(a, b), bad);
		ac = ft_stable_positive_keygen(fpr_mul(a, c), bad);
		bc = ft_stable_positive_keygen(fpr_mul(b, c), bad);
		e2 = ft_stable_positive_keygen(fpr_add(fpr_add(ab, ac), bc), bad);
		abc = ft_stable_positive_keygen(fpr_mul(ab, c), bad);
		leaves[v] = ft_stable_positive_keygen(fpr_div(e1, three), bad);
		leaves[256 + v] = ft_stable_positive_keygen(fpr_div(e2, e1), bad);
		leaves[512 + v] = ft_stable_positive_keygen(
			fpr_div(fpr_mul(three, abc), e2), bad);
	}
	ft_stable_binary_inplace_keygen(leaves + 0, 256, scratch, bad);
	ft_stable_binary_inplace_keygen(leaves + 256, 256, scratch, bad);
	ft_stable_binary_inplace_keygen(leaves + 512, 256, scratch, bad);
}
