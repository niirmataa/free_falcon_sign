int
falcon_prng_init(prng *p, shake_context *src, int type)
{
	if (type == 0) {
		type = PRNG_CHACHA20;
	}
	switch (type) {
	case PRNG_CHACHA20:
#if FALCON_LE_U
		shake_extract(src, p->state.d, 56);
#else
		{
			/*
			 * To ensure reproducibility for a given seed, we
			 * must enforce little-endian interpretation of
			 * the state words.
			 */
			unsigned char tmp[56];
			uint64_t th, tl;
			int i;

			shake_extract(src, tmp, 56);
			for (i = 0; i < 14; i ++) {
				uint32_t w;

				w = (uint32_t)tmp[(i << 2) + 0]
					| ((uint32_t)tmp[(i << 2) + 1] << 8)
					| ((uint32_t)tmp[(i << 2) + 2] << 16)
					| ((uint32_t)tmp[(i << 2) + 3] << 24);
				*(uint32_t *)(p->state.d + (i << 2)) = w;
			}
			tl = *(uint32_t *)(p->state.d + 48);
			th = *(uint32_t *)(p->state.d + 52);
			*(uint64_t *)(p->state.d + 48) = tl + (th << 32);
		}
#endif
		break;
	default:
		return 0;
	}
	p->type = type;
	falcon_prng_refill(p);
	return type;
}
