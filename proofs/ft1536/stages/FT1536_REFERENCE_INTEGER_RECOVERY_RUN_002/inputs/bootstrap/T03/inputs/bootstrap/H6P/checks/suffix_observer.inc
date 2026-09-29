		memcpy(t0, tx, n * sizeof *tx);
snapshot("copy_t0_tx",0,t0,1536);
		memcpy(t1, ty, n * sizeof *ty);
snapshot("copy_t1_ty",0,t1,1536);
		falcon_poly_mul_fft3(tx, b00, logn, 1);
snapshot("mul_tx_b00",0,tx,1536);
		falcon_poly_mul_fft3(ty, b10, logn, 1);
snapshot("mul_ty_b10",0,ty,1536);
		falcon_poly_add_fft3(tx, ty, logn, 1);
snapshot("add_tx_ty",0,tx,1536);
		memcpy(ty, t0, n * sizeof *t0);
snapshot("copy_ty_t0",0,ty,1536);
		falcon_poly_mul_fft3(ty, b01, logn, 1);
snapshot("mul_ty_b01",0,ty,1536);

		memcpy(t0, tx, n * sizeof *tx);
snapshot("copy_t0_tx",0,t0,1536);
		falcon_poly_mul_fft3(t1, b11, logn, 1);
snapshot("mul_t1_b11",0,t1,1536);
		falcon_poly_add_fft3(t1, ty, logn, 1);
snapshot("add_t1_ty",0,t1,1536);

		observed_iFFT3(t0, logn, 1);
		observed_iFFT3(t1, logn, 1);

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
