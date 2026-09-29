		memcpy(t0, tx, n * sizeof *tx);
		memcpy(t1, ty, n * sizeof *ty);
		falcon_poly_mul_fft3(tx, b00, logn, 1);
		falcon_poly_mul_fft3(ty, b10, logn, 1);
		falcon_poly_add_fft3(tx, ty, logn, 1);
		memcpy(ty, t0, n * sizeof *t0);
		falcon_poly_mul_fft3(ty, b01, logn, 1);

		memcpy(t0, tx, n * sizeof *tx);
		falcon_poly_mul_fft3(t1, b11, logn, 1);
		falcon_poly_add_fft3(t1, ty, logn, 1);

		falcon_iFFT3(t0, logn, 1);
		falcon_iFFT3(t1, logn, 1);

		/*
		 * Compute the signature.
		 */
		for (u = 0; u < n; u ++) {
	#if FT_SAMPLER_ADAPTIVE_PROBE
			int64_t w1, w2;

			w1 = fpr_rint(t0[u]);
			w2 = fpr_rint(t1[u]);
			ft_sampler_probe_precast(w1, 1, q);
			ft_sampler_probe_precast(w2, 2, q);
			s1[u] = (int16_t)w1;
			s2[u] = (int16_t)w2;
	#else
			s1[u] = (int16_t)fpr_rint(t0[u]);
			s2[u] = (int16_t)fpr_rint(t1[u]);
	#endif
		}
