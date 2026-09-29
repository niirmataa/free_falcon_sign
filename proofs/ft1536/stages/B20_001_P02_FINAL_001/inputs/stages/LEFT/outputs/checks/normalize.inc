static size_t
ffLDL_ternary_normalize_inner(fpr *tree, fpr sigma, unsigned logn,
	const fpr *leaves, size_t *leaf_index)
{
	size_t s;

	if (logn == 1) {
		/*
		 * At logn = 1, tree consists in three polynomials,
		 * one parent node and two leaves. We normalize the
		 * leaves.
		 */
#if FT_SAMPLER_ADAPTIVE_PROBE
		{
			fpr raw0, raw1;

			raw0 = leaves[(*leaf_index) ++];
			raw1 = leaves[(*leaf_index) ++];
			tree[2] = fpr_div(sigma, fpr_sqrt(raw0));
			tree[3] = fpr_div(sigma, fpr_sqrt(raw1));
			ft_ffldl_probe_record_leaf(raw0, tree[2]);
			ft_ffldl_probe_record_leaf(raw1, tree[3]);
		}
#else
		tree[2] = fpr_div(sigma,
			fpr_sqrt(leaves[(*leaf_index) ++]));
		tree[3] = fpr_div(sigma,
			fpr_sqrt(leaves[(*leaf_index) ++]));
#endif
		return 4;
	}

	s = (size_t)1 << logn;
	s += ffLDL_ternary_normalize_inner(
		tree + s, sigma, logn - 1, leaves, leaf_index);
	s += ffLDL_ternary_normalize_inner(
		tree + s, sigma, logn - 1, leaves, leaf_index);
	return s;
}

static size_t
ffLDL_ternary_normalize_depth1(fpr *tree, fpr sigma, unsigned logn,
	const fpr *leaves, size_t *leaf_index)
{
	size_t s;

	s = (size_t)3 << logn;
	s += ffLDL_ternary_normalize_inner(
		tree + s, sigma, logn - 1, leaves, leaf_index);
	s += ffLDL_ternary_normalize_inner(
		tree + s, sigma, logn - 1, leaves, leaf_index);
	s += ffLDL_ternary_normalize_inner(
		tree + s, sigma, logn - 1, leaves, leaf_index);
	return s;
}

static size_t
ffLDL_ternary_normalize(fpr *tree, fpr sigma, unsigned logn,
	const fpr *leaves, size_t *leaf_count)
{
	size_t leaf_index, s;

#if FT_SAMPLER_ADAPTIVE_PROBE
	ft_ffldl_probe_reset(logn, sigma);
#endif
	leaf_index = 0;
	s = (size_t)3 << (logn - 1);
	s += ffLDL_ternary_normalize_depth1(
		tree + s, sigma, logn - 1, leaves, &leaf_index);
	s += ffLDL_ternary_normalize_depth1(
		tree + s, sigma, logn - 1, leaves, &leaf_index);
#if FT_SAMPLER_ADAPTIVE_PROBE
	ft_ffldl_probe_tree_words = s;
	ft_ffldl_probe_ready = 1;
#endif
	*leaf_count = leaf_index;
	return s;
}
