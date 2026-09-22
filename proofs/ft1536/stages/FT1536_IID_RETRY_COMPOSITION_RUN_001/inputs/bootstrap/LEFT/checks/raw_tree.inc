static void
LDL_dim2_fft3(fpr *restrict d11, fpr *restrict l10,
	const fpr *restrict g00, const fpr *restrict g10,
	const fpr *restrict g11, unsigned logn, unsigned full)
{
	size_t n;

	n = MKN(logn, full);

	/*
	 * Set l10 = g10/g00.
	 * Since g00 = adj(g00), FFT representation of g00 contains only
	 * real numbers.
	 */
	memcpy(l10, g10, n * sizeof *g10);
	falcon_poly_div_autoadj_fft3(l10, g00, logn, full);

	/*
	 * Set d11 = g11 - g10*adj(g10/g00).
	 * TODO: g11 = adj(g11), so it should be half-sized (only real
	 * numbers in FFT representation).
	 */
	memcpy(d11, g10, n * sizeof *g10);
	falcon_poly_muladj_fft3(d11, l10, logn, full);
	falcon_poly_neg_fft3(d11, logn, full);
	falcon_poly_add_fft3(d11, g11, logn, full);
}

/*
 * Perform LDL decomposition of a Gram 3x3 matrix.
 *
 * Input: matrix G = [[g00, g01, g02], [g10, g11, g12], [g20, g21, g22]]
 * such that G* = G.
 *
 * Output: L = [[1, 0, 0], [l10, 1, 0], [l20, l21, 1]], and
 * D = [[d00, 0, 0], [0, d11, 0], [0, 0, d22]] such that G = L·D·L*.
 *
 * We have d00 = g00, thus that value is omitted from the outputs.
 *
 * All inputs and outputs are in FFT3 representation.
 * Overlap allowed only between the constant inputs (g00, g10, g11).
 * tmp[] must have room for one polynomial.
 */
static void
LDL_dim3_fft3(fpr *restrict d11, fpr *restrict d22,
	fpr *restrict l10, fpr *restrict l20, fpr *restrict l21,
	const fpr *restrict g00, const fpr *restrict g10,
	const fpr *restrict g11, const fpr *restrict g20,
	const fpr *restrict g21, const fpr *restrict g22,
	unsigned logn, unsigned full, fpr *restrict tmp)
{
	size_t n;

	n = MKN(logn, full);

	/*
	 * l10 = g10/g00
	 * d11 = g11 - g10*adj(g10/g00)
	 * These are the same formulas as the LDL decomposition of a 2x2
	 * matrix.
	 */
	LDL_dim2_fft3(d11, l10, g00, g10, g11, logn, full);

	/*
	 * l20 = g20/g00
	 */
	memcpy(l20, g20, n * sizeof *g20);
	falcon_poly_div_autoadj_fft3(l20, g00, logn, full);

	/*
	 * l21 = (g21 - g20*adj(g10)/g00) / d11
	 * Note that d11 = adj(d11)
	 */
	memcpy(l21, g20, n * sizeof *g20);
	falcon_poly_muladj_fft3(l21, g10, logn, full);
	falcon_poly_div_autoadj_fft3(l21, g00, logn, full);
	falcon_poly_neg_fft3(l21, logn, full);
	falcon_poly_add_fft3(l21, g21, logn, full);
	falcon_poly_div_autoadj_fft3(l21, d11, logn, full);

	/*
	 * d22 = g22 - l20*adj(g20) - l21*adj(l21)*d11
	 */
	memcpy(d22, l20, n * sizeof *l20);
	falcon_poly_muladj_fft3(d22, g20, logn, full);
	falcon_poly_neg_fft3(d22, logn, full);
	falcon_poly_add_fft3(d22, g22, logn, full);
	memcpy(tmp, l21, n * sizeof *l21);
	falcon_poly_mulselfadj_fft3(tmp, logn, full);
	falcon_poly_mul_autoadj_fft3(tmp, d11, logn, full);
	falcon_poly_sub_fft3(d22, tmp, logn, full);
}

static size_t
ffLDL_inner_fft3(fpr *restrict tree, const fpr *restrict g00,
	const fpr *restrict g10, const fpr *restrict g11,
	unsigned logn, fpr *restrict tmp)
{
	size_t n, hn, s;
	fpr *t0, *t1, *t2;

	n = (size_t)1 << logn;
	hn = n >> 1;

	if (logn == 1) {
		/*
		 * When N = 2, diagonal elements (of D in the LDL
		 * decomposition) are real numbers (since they are
		 * auto-adjoint), and there is no need for further
		 * recursion.
		 *
		 * LDL_dim2_fft3() returns d11 (in tmp) and l10
		 * (two slots, in tree). It will be followed by two
		 * leaves, corresponding to d00 (which is g00) and d11.
		 * The two leaves are real numbers (one slot each).
		 */
		LDL_dim2_fft3(tmp, tree, g00, g10, g11, logn, 0);

		tree[2] = g00[0];
		tree[3] = tmp[0];
		return 4;
	}

	/*
	 * Do the LDL, split diagonal elements, and recurse.
	 * Since d00 = g00, we can do the first recursion
	 * before the LDL.
	 */
	s = n;
	t0 = tmp;
	t1 = tmp + hn;
	t2 = t1 + hn;

	falcon_poly_split_deep_fft3(t0, t1, g00, logn);
	falcon_poly_adj_fft3(t1, logn - 1, 0);
	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);

	LDL_dim2_fft3(t2, tree, g00, g10, g11, logn, 0);

	falcon_poly_split_deep_fft3(t0, t1, t2, logn);
	falcon_poly_adj_fft3(t1, logn - 1, 0);
	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);

	return s;
}

static size_t
ffLDL_depth1_fft3(fpr *restrict tree, const fpr *restrict g00,
	const fpr *restrict g10, const fpr *restrict g11,
	const fpr *restrict g20, const fpr *restrict g21,
	const fpr *restrict g22, unsigned logn, fpr *restrict tmp)
{
	/*
	 * At depth 1, we perform a bisection on the elements of the
	 * input 3x3 matrix.
	 */

	size_t n, hn, s;
	fpr *l10, *l20, *l21, *d11, *d22;
	fpr *t0, *t1, *t2;

	n = (size_t)1 << logn;
	hn = n >> 1;
	l10 = tree;
	l20 = l10 + n;
	l21 = l20 + n;
	d11 = tmp;
	d22 = d11 + n;
	t0 = d22 + n;
	t1 = t0 + hn;
	t2 = t1 + hn;
	s = 3 * n;

	/*
	 * LDL decomposition.
	 */
	LDL_dim3_fft3(d11, d22, l10, l20, l21,
		g00, g10, g11, g20, g21, g22, logn, 0, t2);

	/*
	 * Splits and recursive invocations.
	 *
	 * TODO: for N = 6, this would need special code. Right now,
	 * we simply refuse to handle it, because N = 6 is way too weak
	 * to have any value anyway.
	 */
	falcon_poly_split_deep_fft3(t0, t1, g00, logn);
	falcon_poly_adj_fft3(t1, logn - 1, 0);
	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);

	falcon_poly_split_deep_fft3(t0, t1, d11, logn);
	falcon_poly_adj_fft3(t1, logn - 1, 0);
	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);

	falcon_poly_split_deep_fft3(t0, t1, d22, logn);
	falcon_poly_adj_fft3(t1, logn - 1, 0);
	s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);

	return s;
}

static size_t
ffLDL_fft3(fpr *restrict tree, const fpr *restrict g00,
	const fpr *restrict g10, const fpr *restrict g11,
	unsigned logn, fpr *restrict tmp)
{
	size_t n, tn, s;
	fpr *l10, *d11, *t0, *t1, *t2, *t3;

	n = (size_t)3 << (logn - 1);
	tn = (size_t)1 << (logn - 1);
	l10 = tree;
	s = n;
	t0 = tmp;
	t1 = t0 + tn;
	t2 = t1 + tn;
	t3 = t2 + tn;

	/*
	 * Formally, we perform the LDL decomposition, _then_ do
	 * the recursion on split versions of the diagonal elements.
	 * However, d00 = g00, so we can perform the first recursion
	 * _before_ computing the LDL; this saves RAM.
	 */

	/*
	 * Trisection of d00 for first recursion.
	 */
	falcon_poly_split_top_fft3(t0, t1, t2, g00, logn);
	falcon_poly_adj_fft3(t1, logn - 1, 0);
	falcon_poly_adj_fft3(t2, logn - 1, 0);
	s += ffLDL_depth1_fft3(tree + s, t0, t1, t0, t2, t1, t0, logn - 1, t3);

	/*
	 * Compute LDL decomposition of the top matrix.
	 */
	d11 = t3;
	LDL_dim2_fft3(d11, l10, g00, g10, g11, logn, 1);

	/*
	 * Trisection of d11 for second recursion.
	 */
	falcon_poly_split_top_fft3(t0, t1, t2, d11, logn);
	falcon_poly_adj_fft3(t1, logn - 1, 0);
	falcon_poly_adj_fft3(t2, logn - 1, 0);
	s += ffLDL_depth1_fft3(tree + s, t0, t1, t0, t2, t1, t0, logn - 1, t3);

	return s;
}
