	s = fpr_floor(mu);
	r = fpr_sub(mu, fpr_of(s));
	dss = fpr_inv(fpr_mul(fpr_sqr(sigma), fpr_of(2)));
