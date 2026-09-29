static int keygen_stable_slice(const fpr *roots, fpr *output)
{
 size_t n=1536,hn=768,u;
 uint32_t bad=0;
 fpr q_squared, g00buf[1536];
 fpr *g00=g00buf,*t3=output,*leaves,*scratch;
 memcpy(g00,roots,sizeof g00buf);
		for (u = 0; u < hn; u ++) {
			uint32_t valid;
			uint64_t mask, xb;
			valid = (uint32_t)ft_fpr_is_positive_finite_keygen(g00[u]);
			valid &= (uint32_t)(1 ^ fpr_lt(g00[u], fpr_onehalf));
			bad |= valid ^ 1U;
			mask = (uint64_t)0 - (uint64_t)valid;
			xb = ft_fpr_bits_keygen(g00[u]);
			g00[u] = ft_fpr_from_bits_keygen(
				(xb & mask) | (ft_fpr_bits_keygen(fpr_one) & ~mask));
		}
		leaves = t3;
		scratch = leaves + n;
		ft_stable_top_branch_keygen(g00, leaves, scratch, &bad);
		q_squared = fpr_of(FT1536_KEYGEN_Q_SQUARED);
		for (u = 0; u < hn; u ++) {
			leaves[n - 1 - u] = ft_stable_positive_keygen(
				fpr_div(q_squared, leaves[u]), &bad);
		}
		for (u = 0; u < n; u ++) {
			uint64_t bits;
			uint32_t valid;
			leaves[u] = ft_stable_positive_keygen(leaves[u], &bad);
			bits = ft_fpr_bits_keygen(leaves[u]);
			valid = (uint32_t)(1 ^ (uint32_t)((bits
				- FT1536_LEAF_MIN_BITS) >> 63));
			valid &= (uint32_t)(1 ^ (uint32_t)((FT1536_LEAF_MAX_BITS
				- bits) >> 63));
			bad |= valid ^ 1U;
		}
		return bad == 0;
}
