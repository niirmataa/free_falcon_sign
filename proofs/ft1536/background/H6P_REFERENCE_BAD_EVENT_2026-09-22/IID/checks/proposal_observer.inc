static int
observed_proposal(prng *p, fpr dss, int *k,
	fpr *inv_2sigma0_sq, unsigned *proposal_level)
{
	uint64_t coefficient_bits;
	unsigned found, level, selected_level;
	int selected_sample;
	int samples[FT_ADAPTIVE_CDF_LEVELS];
	uint64_t hi, lo;

	hi = observed_u64(p);
	lo = observed_u64(p);
	ft_adaptive_cdf_samples(hi, lo, samples);

	found = 0;
	selected_level = 0;
	selected_sample = 0;
	coefficient_bits = 0;
	for (level = 0; level < FT_ADAPTIVE_CDF_LEVELS; level ++) {
		fpr coefficient;
		uint64_t mask;
		unsigned ge, take;

		coefficient = ft_fpr_from_bits(
			ft_adaptive_cdf_inv_2sigma0_sq_bits[level]);
		ge = (unsigned)(1 ^ fpr_lt(dss, coefficient));
		take = (1U ^ found) & ge;
		mask = (uint64_t)0 - (uint64_t)take;
		selected_sample += samples[level] * (int)take;
		selected_level += level * take;
		coefficient_bits |=
			ft_adaptive_cdf_inv_2sigma0_sq_bits[level] & mask;
		found |= ge;
	}

	*k = selected_sample;
	*inv_2sigma0_sq = ft_fpr_from_bits(coefficient_bits);
	*proposal_level = selected_level;
	return (int)found;
}
