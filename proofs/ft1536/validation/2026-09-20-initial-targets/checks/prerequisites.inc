#define MKN(logn, ter)   ((size_t)(1 + ((ter) << 1)) << ((logn) - (ter)))
typedef int (*samplerZ)(void *ctx, fpr mu, fpr sigma);
static inline size_t
skoff_b00(unsigned logn, unsigned ter)
{
	(void)logn;
	(void)ter;
	return 0;
}

static inline size_t
skoff_b01(unsigned logn, unsigned ter)
{
	return MKN(logn, ter);
}

static inline size_t
skoff_b10(unsigned logn, unsigned ter)
{
	return 2 * MKN(logn, ter);
}

static inline size_t
skoff_b11(unsigned logn, unsigned ter)
{
	return 3 * MKN(logn, ter);
}

static inline size_t
skoff_tree(unsigned logn, unsigned ter)
{
	return 4 * MKN(logn, ter);
}
