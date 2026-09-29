		b = falcon_prng_get_u8(p) & 1;
		z = b ? (1 + k) : -k;
		delta = b ? fpr_sub(fpr_of(1), r) : r;

		/*
		 * Manifestly non-negative correction:
		 *
		 * x = k^2 * (1/(2*sigma^2) - 1/(2*sigma0^2))
		 *     + (2*k*delta + delta^2)/(2*sigma^2).
		 */
		gap = fpr_sub(dss, inv_2sigma0_sq);
		if (!ft_fpr_is_nonnegative_finite(gap)) {
			tsc->fault = FT_SAMPLER_FAULT_PROPOSAL_RANGE;
#if FT_SAMPLER_ADAPTIVE_PROBE
			ft_sampler_probe_proposal_range ++;
#endif
			return 0;
		}
		kk = (int64_t)k * (int64_t)k;
		x = fpr_mul(fpr_of(kk), gap);
		tail_term = fpr_add(
			fpr_mul(fpr_of((int64_t)2 * k), delta),
			fpr_sqr(delta));
		x = fpr_add(x, fpr_mul(tail_term, dss));
