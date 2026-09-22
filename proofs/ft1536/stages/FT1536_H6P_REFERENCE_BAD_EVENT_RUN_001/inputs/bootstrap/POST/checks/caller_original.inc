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
