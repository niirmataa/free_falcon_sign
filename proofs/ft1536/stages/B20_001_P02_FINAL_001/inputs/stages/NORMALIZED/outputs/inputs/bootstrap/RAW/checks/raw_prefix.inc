static int
raw_prefix_slice(fpr *restrict sk, unsigned q,
	const int16_t *f_src, const int16_t *g_src,
	const int16_t *F_src, const int16_t *G_src,
	unsigned logn, unsigned ter, fpr *restrict tmp)
{
	size_t n;
	fpr *f, *g, *F, *G;
	fpr *b00, *b01, *b10, *b11;
	fpr *tree;

	n = MKN(logn, ter);
	b00 = sk + skoff_b00(logn, ter);
	b01 = sk + skoff_b01(logn, ter);
	b10 = sk + skoff_b10(logn, ter);
	b11 = sk + skoff_b11(logn, ter);
	tree = sk + skoff_tree(logn, ter);

	/*
	 * We load the private key elements directly into the B0 matrix,
	 * since B0 = [[g, -f], [G, -F]].
	 */
	f = b01;
	g = b00;
	F = b11;
	G = b10;

	smallints_to_fpr(f, f_src, logn, ter);
	smallints_to_fpr(g, g_src, logn, ter);
	smallints_to_fpr(F, F_src, logn, ter);
	smallints_to_fpr(G, G_src, logn, ter);

	/*
	 * Compute the FFT for the key elements, and negate f and F.
	 */
	if (ter) {
		falcon_FFT3(f, logn, 1);
		falcon_FFT3(g, logn, 1);
		falcon_FFT3(F, logn, 1);
		falcon_FFT3(G, logn, 1);
		falcon_poly_neg_fft3(f, logn, 1);
		falcon_poly_neg_fft3(F, logn, 1);
	} else {
		falcon_FFT(f, logn);
		falcon_FFT(g, logn);
		falcon_FFT(F, logn);
		falcon_FFT(G, logn);
		falcon_poly_neg_fft(f, logn);
		falcon_poly_neg_fft(F, logn);
	}

	/*
	 * The Gram matrix is G = B·B*. Formulas are:
	 *   g00 = b00*adj(b00) + b01*adj(b01)
	 *   g01 = b00*adj(b10) + b01*adj(b11)
	 *   g10 = b10*adj(b00) + b11*adj(b01)
	 *   g11 = b10*adj(b10) + b11*adj(b11)
	 */
	if (ter) {
		fpr *g00, *g10, *g11, *gxx;

		if (logn != 10 || n != 1536 || q != 18433) {
			return 0;
		}

		g00 = tmp;
		g10 = g00 + n;
		g11 = g10 + n;
		gxx = g11 + n;

		memcpy(g00, b00, n * sizeof *b00);
		falcon_poly_mulselfadj_fft3(g00, logn, 1);
		memcpy(gxx, b01, n * sizeof *b01);
		falcon_poly_mulselfadj_fft3(gxx, logn, 1);
		falcon_poly_add_fft3(g00, gxx, logn, 1);

		memcpy(g10, b10, n * sizeof *b10);
		falcon_poly_muladj_fft3(g10, b00, logn, 1);
		memcpy(gxx, b11, n * sizeof *b11);
		falcon_poly_muladj_fft3(gxx, b01, logn, 1);
		falcon_poly_add_fft3(g10, gxx, logn, 1);

		memcpy(g11, b10, n * sizeof *b10);
		falcon_poly_mulselfadj_fft3(g11, logn, 1);
		memcpy(gxx, b11, n * sizeof *b11);
		falcon_poly_mulselfadj_fft3(gxx, logn, 1);
		falcon_poly_add_fft3(g11, gxx, logn, 1);

		/*
		 * Compute the Falcon tree.
		 */
		ffLDL_fft3(tree, g00, g10, g11, logn, gxx);
		return 1; /* observation cut immediately after source1253 */
	}
	return 0;
}
