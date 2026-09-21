static int normalization_suffix_slice(fpr *sk, fpr *tmp,
 const int16_t *f_src,const int16_t *g_src,unsigned logn)
{
 size_t n=MKN(logn,1),leaf_count,tree_words;
 fpr *tree=sk+skoff_tree(logn,1),*stable_leaves,sigma;
 int stable_ok;
		stable_ok = ft_build_stable_certified_leaves(tmp,
			&stable_leaves, f_src, g_src, logn);
		sigma = fpr_of(FT1536_SIGNING_SIGMA);
		tree_words = ffLDL_ternary_normalize(tree, sigma, logn,
			stable_leaves, &leaf_count);
		return stable_ok
			&& leaf_count == n
			&& tree_words == (size_t)12 * n;
}
