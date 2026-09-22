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
