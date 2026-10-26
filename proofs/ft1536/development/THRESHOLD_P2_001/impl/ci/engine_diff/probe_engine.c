/*
 * WP-023 — differential probe po stronie SILNIKA (FT1536, ternary logn=10).
 *
 * Ten plik NIE jest implementacją protokołu. To harness pomiarowy:
 * kompiluje funkcje silnika z `Extra/c/falcon-vrfy.c` (poprzez #include,
 * żeby mieć dostęp do `static`) oraz `falcon_hash_to_point` z
 * `Extra/c/falcon-enc.c`, a następnie zapisuje strumień przypadków
 * testowych w formacie binarnym opisanym w README.md.
 *
 * Każdy przypadek jest reprezentowany przez 32-bajtowy SHAKE256 z
 * kanonicznej serializacji wyniku (u16 little-endian). Drugi program
 * (`ft-threshold-core --example engine_diff_probe`) liczy to samo swoim
 * kodem; `run.py` porównuje pliki bajt po bajcie.
 *
 * Deterministyczny generator: xorshift64 o stałym ziarnie, identyczny
 * w C i Rust. Kategorie mają niezależne ziarna (kind 0..3).
 *
 * Kompilacja (patrz run.py):
 *   cc -std=c99 -O2 -DFPR_IMPL='"fpr-emulated.h"' \
 *      -DFT1536_CANDIDATE_PROFILE=1 -DCLEANSE=1 \
 *      -DTRUE_TERNARY_SECRET=1 -DTRUE_TERNARY_SECRET_MODE=1 \
 *      -I<repo>/Extra/c -ffunction-sections -fdata-sections \
 *      probe_engine.c <repo>/Extra/c/shake.c <repo>/Extra/c/falcon-enc.c \
 *      -Wl,--gc-sections -o probe_engine
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "internal.h"
#include "shake.h"

/* Statyczne funkcje NTT/montgomery z silnika (ten sam plik, ta sama semantyka). */
#include "falcon-vrfy.c"

#define FT_N 1536
#define FT_Q 18433
#define FT_LOGN 10
#define FT_KINDS 4
#define FT_DEFAULT_CASES 2500
#define FT_SEED UINT64_C(0x9e3779b97f4a7c15)
#define FT_KIND_SALT UINT64_C(0xd1b54a32d192ed03)

static uint64_t rng_state;

static uint64_t
rng_next(void)
{
	uint64_t x = rng_state;
	x ^= x << 13;
	x ^= x >> 7;
	x ^= x << 17;
	rng_state = x;
	return x;
}

static void
rng_start(unsigned kind)
{
	rng_state = FT_SEED ^ (FT_KIND_SALT * (uint64_t)kind);
}

static uint16_t
rng_coeff(void)
{
	return (uint16_t)(rng_next() % (uint64_t)FT_Q);
}

static void
digest_coeffs(const uint16_t *a, uint8_t out[32])
{
	uint8_t buf[FT_N * 2];
	size_t i;
	shake_context sc;
	size_t u;

	for (i = 0; i < FT_N; i ++) {
		buf[2 * i] = (uint8_t)(a[i] & 0xFF);
		buf[2 * i + 1] = (uint8_t)(a[i] >> 8);
	}
	shake_init(&sc, 512);
	shake_inject(&sc, buf, sizeof buf);
	shake_flip(&sc);
	shake_extract(&sc, out, 32);
	/* Nie zostawiamy śladu w buforze pomocniczym. */
	for (u = 0; u < sizeof buf; u ++) {
		buf[u] = 0;
	}
}

static void
put_u32le(FILE *f, uint32_t v)
{
	uint8_t b[4];
	b[0] = (uint8_t)(v & 0xFF);
	b[1] = (uint8_t)((v >> 8) & 0xFF);
	b[2] = (uint8_t)((v >> 16) & 0xFF);
	b[3] = (uint8_t)((v >> 24) & 0xFF);
	if (fwrite(b, 1, sizeof b, f) != sizeof b) {
		fprintf(stderr, "probe_engine: write header failed\n");
		exit(2);
	}
}

static void
put_u64le(FILE *f, uint64_t v)
{
	uint8_t b[8];
	unsigned i;
	for (i = 0; i < 8; i ++) {
		b[i] = (uint8_t)((v >> (8 * i)) & 0xFF);
	}
	if (fwrite(b, 1, sizeof b, f) != sizeof b) {
		fprintf(stderr, "probe_engine: write header failed\n");
		exit(2);
	}
}

static void
fill_from_words(uint8_t *out, size_t len)
{
	size_t i;
	for (i = 0; i < len; i += 8) {
		uint64_t w = rng_next();
		size_t j;
		for (j = 0; j < 8 && i + j < len; j ++) {
			out[i + j] = (uint8_t)((w >> (8 * j)) & 0xFF);
		}
	}
}

int
main(int argc, char **argv)
{
	const char *out_path;
	uint32_t cases = FT_DEFAULT_CASES;
	FILE *f;
	uint32_t kind;
	uint32_t i;

	if (argc < 2 || argc > 3) {
		fprintf(stderr, "usage: %s OUT.bin [CASES]\n", argv[0]);
		return 2;
	}
	out_path = argv[1];
	if (argc == 3) {
		unsigned long v = strtoul(argv[2], NULL, 10);
		if (v == 0 || v > 100000UL) {
			fprintf(stderr, "probe_engine: CASES out of range\n");
			return 2;
		}
		cases = (uint32_t)v;
	}
	f = fopen(out_path, "wb");
	if (f == NULL) {
		fprintf(stderr, "probe_engine: cannot open %s\n", out_path);
		return 2;
	}

	if (fwrite("FTDIF01\0", 1, 8, f) != 8) {
		fprintf(stderr, "probe_engine: write magic failed\n");
		return 2;
	}
	put_u32le(f, 1);            /* version */
	put_u32le(f, FT_N);         /* n */
	put_u32le(f, FT_Q);         /* q */
	put_u32le(f, cases);        /* cases per kind */
	put_u32le(f, FT_KINDS);     /* kinds */
	put_u64le(f, FT_SEED);      /* seed */

	for (kind = 0; kind < FT_KINDS; kind ++) {
		rng_start(kind);
		for (i = 0; i < cases; i ++) {
			uint16_t a[FT_N];
			uint16_t b[FT_N];
			uint8_t digest[32];
			size_t u;

			switch (kind) {
			case 0: {
				/* hash_to_point: nonce 16 B || msg 32 B, SHAKE256. */
				uint8_t nonce[16];
				uint8_t msg[32];
				shake_context sc;

				fill_from_words(nonce, sizeof nonce);
				fill_from_words(msg, sizeof msg);
				shake_init(&sc, 512);
				shake_inject(&sc, nonce, sizeof nonce);
				shake_inject(&sc, msg, sizeof msg);
				shake_flip(&sc);
				falcon_hash_to_point(&sc, FT_Q, a, FT_LOGN);
				digest_coeffs(a, digest);
				break;
			}
			case 1:
				/* NTT ternarna: dowolne współczynniki 0..q-1. */
				for (u = 0; u < FT_N; u ++) {
					a[u] = rng_coeff();
				}
				mq_NTT_ternary(a, FT_LOGN);
				digest_coeffs(a, digest);
				break;
			case 2:
				/* iNTT ternarna: dowolny wektor w dziedzinie NTT. */
				for (u = 0; u < FT_N; u ++) {
					a[u] = rng_coeff();
				}
				mq_iNTT_ternary(a, FT_LOGN);
				digest_coeffs(a, digest);
				break;
			default:
				/*
				 * Mnożenie w R_q ścieżką silnika:
				 * NTT(a), NTT(b), montymul, ×R2, iNTT.
				 * To odpowiada `ntt::mul` w Rust.
				 */
				for (u = 0; u < FT_N; u ++) {
					a[u] = rng_coeff();
				}
				for (u = 0; u < FT_N; u ++) {
					b[u] = rng_coeff();
				}
				mq_NTT_ternary(a, FT_LOGN);
				mq_NTT_ternary(b, FT_LOGN);
				mq_poly_montymul_ntt(a, b, FT_LOGN, 1);
				mq_poly_tomonty(a, FT_LOGN, 1);
				mq_iNTT_ternary(a, FT_LOGN);
				digest_coeffs(a, digest);
				break;
			}
			if (fwrite(digest, 1, sizeof digest, f) != sizeof digest) {
				fprintf(stderr, "probe_engine: write digest failed\n");
				return 2;
			}
			for (u = 0; u < FT_N; u ++) {
				a[u] = 0;
				b[u] = 0;
			}
		}
	}

	if (fclose(f) != 0) {
		fprintf(stderr, "probe_engine: close failed\n");
		return 2;
	}
	return 0;
}
