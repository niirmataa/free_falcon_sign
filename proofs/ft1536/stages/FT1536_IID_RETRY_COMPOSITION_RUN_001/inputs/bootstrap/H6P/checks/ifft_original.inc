void
falcon_iFFT3(fpr *a, unsigned logn, unsigned full)
{
	size_t n, hn, u, t, m;
	fpr ni;

	n = MKN(logn, full);
	hn = n >> 1;

	/*
	 * First step: divide degree by 3.
	 */
	if (full) {
		size_t v;

		for (u = 0, v = (size_t)1 << logn; u < hn; u += 3, v += 2) {
			fpr f0r, f0i, f1r, f1i, f2r, f2i, xr, xi;
			fpr f11r, f11i, f12r, f12i, f21r, f21i, f22r, f22i;

			f0r = a[u];
			f0i = a[u + hn];
			f1r = a[u + 1];
			f1i = a[u + 1 + hn];
			f2r = a[u + 2];
			f2i = a[u + 2 + hn];

			xr = fpr_gm3_cubic[v + 0];
			xi = fpr_neg(fpr_gm3_cubic[v + 1]);
			FPC_MUL(f11r, f11i, f1r, f1i, fpr_W4R, fpr_W4I);
			FPC_MUL(f12r, f12i, f1r, f1i, fpr_W2R, fpr_W2I);
			FPC_MUL(f21r, f21i, f2r, f2i, fpr_W4R, fpr_W4I);
			FPC_MUL(f22r, f22i, f2r, f2i, fpr_W2R, fpr_W2I);

			FPC_ADD(f1r, f1i, f1r, f1i, f2r, f2i);
			FPC_ADD(a[u], a[u + hn], f0r, f0i, f1r, f1i);

			FPC_ADD(f11r, f11i, f11r, f11i, f22r, f22i);
			FPC_ADD(f11r, f11i, f11r, f11i, f0r, f0i);
			FPC_MUL(a[u + 1], a[u + 1 + hn], xr, xi, f11r, f11i);

			FPC_SQR(xr, xi, xr, xi);
			FPC_ADD(f12r, f12i, f12r, f12i, f21r, f21i);
			FPC_ADD(f12r, f12i, f12r, f12i, f0r, f0i);
			FPC_MUL(a[u + 2], a[u + 2 + hn], xr, xi, f12r, f12i);
		}
	}

	/*
	 * Intermediate steps for halving the degree.
	 */
	t = 2 + (full << 2);
	for (m = (size_t)1 << (logn - 1 - full); t < n; m >>= 1) {
		size_t ht, hm, u1, v1;

		ht = t >> 1;
		hm = m >> 1;
		for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t) {
			size_t v, v2;
			fpr sr, si;

			sr = fpr_gm3_square[((m + u1) << 1) + 0];
			si = fpr_neg(fpr_gm3_square[((m + u1) << 1) + 1]);
			v2 = v1 + ht;
			for (v = v1; v < v2; v ++) {
				fpr a0r, a0i, a1r, a1i;

				a0r = a[v];
				a0i = a[v + hn];
				a1r = a[v + ht];
				a1i = a[v + ht + hn];
				FPC_ADD(a[v], a[v + hn],
					a0r, a0i, a1r, a1i);
				FPC_SUB(a0r, a0i, a0r, a0i, a1r, a1i);
				FPC_MUL(a[v + ht], a[v + ht + hn],
					a0r, a0i, sr, si);
			}
		}
		t <<= 1;
	}

	/*
	 * Last step: modulo X^2-X+1.
	 *
	 * For w = exp(i*pi/3), roots of X^2-X+1 are w and w^5. Since
	 * w^3 = -1, we have w^5 = -w^2 = -w + 1.
	 *
	 * The FFT computed a(w) = a0 + a1*w. Since a0 and a1 are
	 * real, we can recompute a0 and a1:
	 *
	 *   a1 = Im(a(w)) / Im(w)
	 *   a0 = Re(a(w)) - Re(w) * a1
	 *
	 * Note that Re(w) = 1/2.
	 */
	for (u = 0; u < hn; u ++) {
		fpr xr, xi, a0, a1;

		xr = a[u];
		xi = a[u + hn];
		a1 = fpr_mul(xi, fpr_IW1I);
		a0 = fpr_sub(xr, fpr_half(a1));
		a[u] = a0;
		a[u + hn] = a1;
	}

	/*
	 * We have an accumulated N/2 multiplier to remove.
	 */
	ni = fpr_inverse_of(n >> 1);
	for (u = 0; u < n; u ++) {
		a[u] = fpr_mul(ni, a[u]);
	}
}
