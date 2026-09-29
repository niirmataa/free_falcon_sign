static int signer_roots_slice(fpr *tmp, fpr **leaves_out, const fpr *roots)
{
 size_t n=1536,hn=768,u;
 uint32_t bad=0;
 fpr q_squared,*f=tmp,*leaves,*scratch;
 memcpy(f,roots,1536*sizeof(fpr));
	for (u = 0; u < hn; u ++) {
		uint32_t valid;
		uint64_t mask, xb;

		valid = (uint32_t)ft_fpr_is_positive_finite(f[u]);
		valid &= (uint32_t)(1 ^ fpr_lt(f[u], fpr_onehalf));
		bad |= valid ^ 1U;
		mask = (uint64_t)0 - (uint64_t)valid;
		xb = ft_fpr_bits(f[u]);
		f[u] = ft_fpr_from_bits(
			(xb & mask) | (ft_fpr_bits(fpr_one) & ~mask));
	}

	leaves = f + hn;
	scratch = leaves + n;
	ft_stable_top_branch(f, leaves, scratch, &bad);
	q_squared = fpr_of(FT1536_Q_SQUARED);
	for (u = 0; u < hn; u ++) {
		leaves[n - 1 - u] = ft_stable_positive(
			fpr_div(q_squared, leaves[u]), &bad);
	}

	/* Full aggregate scan: no key-dependent early exit. */
	for (u = 0; u < n; u ++) {
		uint64_t bits;
		uint32_t valid;

		leaves[u] = ft_stable_positive(leaves[u], &bad);
		bits = ft_fpr_bits(leaves[u]);
		valid = (uint32_t)(1 ^ (uint32_t)((bits - FT1536_LEAF_MIN_BITS) >> 63));
		valid &= (uint32_t)(1 ^ (uint32_t)((FT1536_LEAF_MAX_BITS - bits) >> 63));
		bad |= valid ^ 1U;
	}
	*leaves_out = leaves;
	return bad == 0;
}
