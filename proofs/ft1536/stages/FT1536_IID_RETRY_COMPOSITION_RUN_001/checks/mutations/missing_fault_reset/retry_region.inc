#if SIGN_MAX_ATTEMPTS != 0
	uint32_t sign_loop_attempts = 0;
#endif
	for (;;) {
#if SIGN_MAX_ATTEMPTS != 0
		if (++ sign_loop_attempts > SIGN_MAX_ATTEMPTS) {
			return 0;
		}
#endif
		/*
		 * Signature produces short vectors s1 and s2. The
		 * signature is acceptable only if the aggregate vector
		 * s1,s2 is short; we must use the same bound as the
		 * verifier.
		 *
		 * If the signature is acceptable, then we return only s2
		 * (the verifier recomputes s1 from s2, the hashed message,
		 * and the public key).
		 */
		prng p;
		ternary_sampler_context tsc;
		tsc.fault = FT_SAMPLER_FAULT_INVALID_SIGMA;
		samplerZ samp;
		void *samp_ctx;

		/*
		 * Normal sampling. We use a fast PRNG seeded from our
		 * SHAKE context ('rng').
		 */
		if (fs->ternary) {
			falcon_prng_init(&tsc.p, &fs->rng, 0);
			/* omitted fault reset */
			samp = sampler_large;
			samp_ctx = &tsc;
		} else {
			falcon_prng_init(&p, &fs->rng, 0);
			samp = sampler;
			samp_ctx = &p;
		}

		/*
		 * Do the actual signature.
		 */
	#if FT_SAMPLER_ADAPTIVE_PROBE
		ft_sampler_probe_sign_attempts ++;
	#endif
		do_sign(samp, samp_ctx, s1, s2,
			fs->q, fs->sk, hm, fs->logn, fs->ternary, fs->tmp);
		if (fs->ternary && tsc.fault != FT_SAMPLER_FAULT_NONE) {
			return 0;
		}

		/*
		 * Check that the norm is correct. With our chosen
		 * acceptance bound, this should almost always be true.
		 * With a tighter bound, it may happen sometimes that we
		 * end up with an invalidly large signature, in which
		 * case we just loop.
		 */
		{
			int short_ok;

			short_ok = falcon_is_short(s1, s2, fs->logn, fs->ternary);
#ifdef SIGN_NORM_PROBE
			sign_norm_probe_attempts ++;
			sign_norm_probe_last_norm2 = sign_norm_probe_compute(
				s1, s2, fs->logn, fs->ternary);
			sign_norm_probe_last_bound2 = sign_norm_probe_bound(
				fs->logn, fs->ternary);
			if (short_ok) {
				sign_norm_probe_accepted ++;
				sign_norm_probe_signatures ++;
			} else {
				sign_norm_probe_rejected ++;
			}
#endif
			if (short_ok) {
				break;
			}
	#if FT_SAMPLER_ADAPTIVE_PROBE
			ft_sampler_probe_norm_rejects ++;
	#endif
		}
	}

	sig_buf = sig;
	sig_len = falcon_encode_small(sig_buf + 1, sig_max_len - 1,
		comp, fs->q, s2, fs->logn);
	if (sig_len == 0) {
	#if FT_SAMPLER_ADAPTIVE_PROBE
		ft_sampler_probe_encode_failures ++;
	#endif
		return 0;
	}
	sig_buf[0] = (fs->ternary << 7) | (comp << 5) | fs->logn;
	return sig_len + 1;
