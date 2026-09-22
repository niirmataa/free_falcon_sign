		falcon_FFT3(t0, logn, 1);
		ni = fpr_inverse_of(q);
		memcpy(t1, t0, n * sizeof *t0);
		falcon_poly_mul_fft3(t1, b01, logn, 1);
		falcon_poly_mulconst_fft3(t1, fpr_neg(ni), logn, 1);
		falcon_poly_mul_fft3(t0, b11, logn, 1);
		falcon_poly_mulconst_fft3(t0, ni, logn, 1);
