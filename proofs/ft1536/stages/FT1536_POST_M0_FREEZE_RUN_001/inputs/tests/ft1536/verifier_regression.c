/* Public explicit-c regression against the exact candidate source copy.
 * OBSERVE changes only the norm call name and delegates to the real predicate.
 * The plain build confirms the same full Verify/raw decisions independently
 * of that observer. This is not a HashToPoint preimage test. */
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

#ifndef OBSERVE
#define OBSERVE 0
#endif
#define falcon_hash_to_point explicit_point
#if OBSERVE
#define falcon_is_short capture_short
#endif
#include "falcon-vrfy.c"
#undef falcon_hash_to_point
#if OBSERVE
#undef falcon_is_short
extern int falcon_is_short(const int16_t *, const int16_t *, unsigned, unsigned);
static int64_t measured_norm;
static unsigned norm_calls;
int
capture_short(const int16_t *a, const int16_t *b, unsigned logn, unsigned ter)
{
	int64_t total = 0;
	if (logn != 10 || ter != 1) {
		abort();
	}
	for (size_t i = 0; i < 1536; i ++) {
		total += (int64_t)a[i] * a[i] + (int64_t)b[i] * b[i];
	}
	for (size_t i = 0; i < 768; i ++) {
		total += (int64_t)a[i] * a[i + 768] + (int64_t)b[i] * b[i + 768];
	}
	measured_norm = total;
	norm_calls ++;
	return falcon_is_short(a, b, logn, ter);
}
#endif

typedef char model_widths[(CHAR_BIT == 8 && sizeof(int) == 4
	&& sizeof(long) == 8 && sizeof(size_t) == 8 && sizeof(int16_t) == 2
	&& sizeof(uint16_t) == 2 && sizeof(int64_t) == 8) ? 1 : -1];
static uint16_t given_c[1536];
static unsigned point_calls;
void
explicit_point(shake_context *sc, unsigned q, uint16_t *out, unsigned logn)
{
	(void)sc;
	if (q != 18433 || logn != 10) {
		abort();
	}
	memcpy(out, given_c, sizeof given_c);
	point_calls ++;
}

static unsigned char *
read_bytes(const char *path, size_t *length)
{
	FILE *f = fopen(path, "rb");
	long n;
	unsigned char *data;
	if (f == NULL || fseek(f, 0, SEEK_END) != 0) {
		abort();
	}
	n = ftell(f);
	if (n < 0) {
		abort();
	}
	rewind(f);
	*length = (size_t)n;
	data = malloc(*length + 1);
	if (data == NULL || fread(data, 1, *length, f) != *length) {
		abort();
	}
	fclose(f);
	return data;
}

int
main(int argc, char **argv)
{
	size_t pk_len, sig_len, used;
	unsigned char *pk, *sig;
	int16_t s[1536], saved[1536];
	unsigned value;
	falcon_vrfy *ctx;
	FILE *f;
	int decision, raw, unchanged;
	if (argc != 4) {
		return 2;
	}
	pk = read_bytes(argv[1], &pk_len);
	sig = read_bytes(argv[3], &sig_len);
	f = fopen(argv[2], "r");
	if (f == NULL) {
		abort();
	}
	for (size_t i = 0; i < 1536; i ++) {
		if (fscanf(f, "%u", &value) != 1 || value >= 18433) {
			abort();
		}
		given_c[i] = (uint16_t)value;
	}
	if (fscanf(f, "%u", &value) == 1) {
		abort();
	}
	fclose(f);
	ctx = falcon_vrfy_new();
	if (ctx == NULL || falcon_vrfy_set_public_key(ctx, pk, pk_len) != 1 || sig_len <= 2) {
		return 3;
	}
	used = falcon_decode_small(s, 10, (sig[0] >> 5) & 3, 18433, sig + 1, sig_len - 1);
	if (used != sig_len - 1) {
		return 4;
	}
	memcpy(saved, s, sizeof s);
	falcon_vrfy_start(ctx, NULL, 0);
	decision = falcon_vrfy_verify(ctx, sig, sig_len);
	raw = falcon_vrfy_verify_raw(given_c, s, ctx->h, 10, 1);
	unchanged = memcmp(saved, s, sizeof s) == 0;
	printf("{\"loader\":1,\"verify\":%d,\"raw\":%d,\"point_calls\":%u,"
		"\"s0\":%d,\"normalized_s0\":%u,\"decoded_bytes\":%zu,"
		"\"signed_s_unchanged\":%s,\"observed\":%s,\"machine_norm\":",
		decision, raw, point_calls, s[0], (unsigned)ft1536_normalize_s2(s[0]),
		used, unchanged ? "true" : "false", OBSERVE ? "true" : "false");
#if OBSERVE
	printf("%" PRId64 ",\"norm_calls\":%u}\n", measured_norm, norm_calls);
#else
	printf("null}\n");
#endif
	free(pk);
	free(sig);
	falcon_vrfy_free(ctx);
	return decision == raw && point_calls == 1 && unchanged ? 0 : 5;
}
