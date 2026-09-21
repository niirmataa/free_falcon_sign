static void
ffSampling_inner_fft3(samplerZ samp, void *samp_ctx,
	fpr *restrict z0, fpr *restrict z1,
	const fpr *restrict tree,
	const fpr *restrict t0, const fpr *restrict t1,
	unsigned logn, fpr *restrict tmp)
{
	size_t n, hn;
	fpr *x0, *x1, *y0, *y1;
	const fpr *tree0, *tree1;

	/*
	 * For tree construction, recursion stopped at n = 2, but it
	 * produced a tree which also covers n = 1. For sampling, we use
	 * the fact that the split() and merge() function
	 * implementations actually supports logn = 1.
	 */
	if (logn == 0) {
		fpr r0, r1, rx;
		fpr sigma;

		sigma = tree[0];
		r1 = *t1;
		r0 = *t0;
		r1 = fpr_sub(r1, fpr_of(
			samp(samp_ctx, r1, fpr_mul(fpr_IW1I, sigma))));
		rx = fpr_half(r1);
		r0 = fpr_add(r0, rx);
		r0 = fpr_sub(r0, fpr_of(
			samp(samp_ctx, r0, sigma)));
		r0 = fpr_sub(r0, rx);
		*z0 = r0;
		*z1 = r1;
		return;
	}

	n = (size_t)1 << logn;
	hn = n >> 1;
	y0 = tmp;
	y1 = y0 + hn;

	tree0 = tree + n;
	tree1 = tree + n + (logn << (logn - 1));

	/*
	 * Split t1, recurse, merge into z1.
	 */
	x0 = z1;
	x1 = x0 + hn;
	falcon_poly_split_deep_fft3(x0, x1, t1, logn);
	ffSampling_inner_fft3(samp, samp_ctx,
		y0, y1, tree1, x0, x1, logn - 1, tmp + n);
	falcon_poly_merge_deep_fft3(z1, y0, y1, logn);

	/*
	 * Compute t0b = t0 + z1 * l10 (into tmp[]).
	 * FIXME: save z1 * l10 instead of recomputing it later on.
	 */
	memcpy(tmp, z1, n * sizeof *t1);
	falcon_poly_mul_fft3(tmp, tree, logn, 0);
	falcon_poly_add_fft3(tmp, t0, logn, 0);

	/*
	 * Split t0b, recurse, merge into z0.
	 */
	x0 = z0;
	x1 = x0 + hn;
	falcon_poly_split_deep_fft3(x0, x1, tmp, logn);
	ffSampling_inner_fft3(samp, samp_ctx,
		y0, y1, tree0, x0, x1, logn - 1, tmp + n);
	falcon_poly_merge_deep_fft3(z0, y0, y1, logn);

	/*
	 * Subtract z1 * l10 from z0.
	 */
	memcpy(tmp, z1, n * sizeof *z1);
	falcon_poly_mul_fft3(tmp, tree, logn, 0);
	falcon_poly_sub_fft3(z0, tmp, logn, 0);
}

static void
ffSampling_depth1_fft3(samplerZ samp, void *samp_ctx,
	fpr *restrict z0, fpr *restrict z1, fpr *restrict z2,
	const fpr *restrict tree,
	const fpr *restrict t0, const fpr *restrict t1, const fpr *restrict t2,
	unsigned logn, fpr *restrict tmp)
{
	size_t n, hn;
	fpr *x0, *x1, *y0, *y1;
	const fpr *tree0, *tree1, *tree2;

	n = (size_t)1 << logn;
	hn = n >> 1;

	tree0 = tree + 3 * n;
	tree1 = tree0 + (logn << (logn - 1));
	tree2 = tree1 + (logn << (logn - 1));
	y0 = tmp;
	y1 = y0 + hn;

	/*
	 * Split t2, recurse, merge into z2.
	 */
	x0 = z2;
	x1 = x0 + hn;
	falcon_poly_split_deep_fft3(x0, x1, t2, logn);
	ffSampling_inner_fft3(samp, samp_ctx,
		y0, y1, tree2, x0, x1, logn - 1, tmp + n);
	falcon_poly_merge_deep_fft3(z2, y0, y1, logn);

	/*
	 * Compute t1b = t1 + z2 * l21 (into tmp[]).
	 * FIXME: save z2 * l21 instead of recomputing it later on.
	 */
	memcpy(tmp, z2, n * sizeof *z2);
	falcon_poly_mul_fft3(tmp, tree + 2 * n, logn, 0);
	falcon_poly_add_fft3(tmp, t1, logn, 0);

	/*
	 * Split t1b, recurse, merge into z1, and subtract z2 * l21.
	 */
	x0 = z1;
	x1 = x0 + hn;
	falcon_poly_split_deep_fft3(x0, x1, tmp, logn);
	ffSampling_inner_fft3(samp, samp_ctx,
		y0, y1, tree1, x0, x1, logn - 1, tmp + n);
	falcon_poly_merge_deep_fft3(z1, y0, y1, logn);
	memcpy(tmp, z2, n * sizeof *z2);
	falcon_poly_mul_fft3(tmp, tree + 2 * n, logn, 0);
	falcon_poly_sub_fft3(z1, tmp, logn, 0);

	/*
	 * Compute t0b = t0 + z1 * l10 + z2 * l20 (into z0).
	 * We use z0 as extra temporary.
	 * FIXME: save z1 * l10 + z2 * l20 instead of recomputing it later on.
	 */
	memcpy(z0, t0, n * sizeof *t0);
	memcpy(tmp, z1, n * sizeof *z1);
	falcon_poly_mul_fft3(tmp, tree, logn, 0);
	falcon_poly_add_fft3(z0, tmp, logn, 0);
	memcpy(tmp, z2, n * sizeof *z1);
	falcon_poly_mul_fft3(tmp, tree + n, logn, 0);
	falcon_poly_add_fft3(z0, tmp, logn, 0);

	/*
	 * Split t0b, recurse, merge into z0.
	 */
	x0 = z0;
	x1 = x0 + hn;
	memcpy(tmp, z0, n * sizeof *z0);
	falcon_poly_split_deep_fft3(x0, x1, tmp, logn);
	ffSampling_inner_fft3(samp, samp_ctx,
		y0, y1, tree0, x0, x1, logn - 1, tmp + n);
	falcon_poly_merge_deep_fft3(z0, y0, y1, logn);

	/*
	 * Subtract z1 * l10 and z2 * l20 from z0.
	 */
	memcpy(tmp, z1, n * sizeof *z1);
	falcon_poly_mul_fft3(tmp, tree, logn, 0);
	falcon_poly_sub_fft3(z0, tmp, logn, 0);
	memcpy(tmp, z2, n * sizeof *z1);
	falcon_poly_mul_fft3(tmp, tree + n, logn, 0);
	falcon_poly_sub_fft3(z0, tmp, logn, 0);
}

static void
ffSampling_fft3(samplerZ samp, void *samp_ctx,
	fpr *restrict z0, fpr *restrict z1,
	const fpr *restrict tree,
	const fpr *restrict t0, const fpr *restrict t1, unsigned logn,
	fpr *restrict tmp)
{
	size_t n, tn;
	fpr *x0, *x1, *x2, *y0, *y1, *y2;
	const fpr *tree0, *tree1;

	n = (size_t)3 << (logn - 1);
	tn = (size_t)1 << (logn - 1);

	tree0 = tree + n;
	tree1 = tree0 + 3 * ((logn + 1) << (logn - 2));
	y0 = tmp;
	y1 = y0 + tn;
	y2 = y1 + tn;

	/*
	 * We split t1 three ways for recursive invocation. We use
	 * z0 and z1 as temporary storage areas; final merge yields z1.
	 */
	x0 = z1;
	x1 = x0 + tn;
	x2 = x1 + tn;
	falcon_poly_split_top_fft3(x0, x1, x2, t1, logn);
	ffSampling_depth1_fft3(samp, samp_ctx,
		y0, y1, y2, tree1, x0, x1, x2, logn - 1, tmp + n);
	falcon_poly_merge_top_fft3(z1, y0, y1, y2, logn);

	/*
	 * Compute t0b = t0 + z1 * L (in tmp[]).
	 * FIXME: save z1 * L instead of recomputing it later on.
	 */
	memcpy(tmp, z1, n * sizeof *z1);
	falcon_poly_mul_fft3(tmp, tree, logn, 1);
	falcon_poly_add_fft3(tmp, t0, logn, 1);

	/*
	 * Split t0b, recurse, and merge into z0.
	 */
	x0 = z0;
	x1 = x0 + tn;
	x2 = x1 + tn;
	falcon_poly_split_top_fft3(x0, x1, x2, tmp, logn);
	ffSampling_depth1_fft3(samp, samp_ctx,
		y0, y1, y2, tree0, x0, x1, x2, logn - 1, tmp + n);
	falcon_poly_merge_top_fft3(z0, y0, y1, y2, logn);

	/*
	 * Subtract z1 * L from z0.
	 */
	memcpy(tmp, z1, n * sizeof *z1);
	falcon_poly_mul_fft3(tmp, tree, logn, 1);
	falcon_poly_sub_fft3(z0, tmp, logn, 1);
}
