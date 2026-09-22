		n = (size_t)3 << (logn - 1);
		hn = n >> 1;
		s = 0;
		for (u = 0; u < n; u ++) {
			int32_t z;

			z = s1[u];
			s += z * z;
			z = s2[u];
			s += z * z;
		}
		for (u = 0; u < hn; u ++) {
			s += (int32_t)s1[u] * (int32_t)s1[u + hn];
			s += (int32_t)s2[u] * (int32_t)s2[u + hn];
		}
