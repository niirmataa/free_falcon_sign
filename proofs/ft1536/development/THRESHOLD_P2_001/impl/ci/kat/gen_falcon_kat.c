/*
 * WP-024 — generator KAT z rzeczywistego silnika FT1536 (ternary, logn=10).
 *
 * Ten plik NIE jest implementacją protokołu. Używa publicznego API
 * silnika (falcon_keygen/falcon_sign/falcon_vrfy) z deterministycznymi,
 * SYNTEETYCZNYMI i publicznymi seedami, żeby wytworzyć przypięte wektory
 * KAT: klucz publiczny, podpis i punkt c0. Klucz prywatny NIE jest
 * zapisywany do pliku — tylko jego SHAKE256 (integrowalność bez sekretu;
 * klucz jest syntetyczny, ale higiena sekretów obowiązuje).
 *
 * Determinizm: `falcon_keygen_set_seed(..., replace=1)` oraz
 * `falcon_sign_set_seed(..., replace=1)` w pełni zastępują RNG silnika,
 * a nonce jest podawany jawnie (`falcon_sign_start_external_nonce`),
 * więc systemowe RNG nie jest używane w ogóle. Wyjście jest bitowe
 * identyczne przy każdym uruchomieniu (brak znaczników czasu).
 *
 * Format wyjścia: tekstowy, pola `nazwa = hex`, opisany w
 * `impl/KAT/README.md`. Regeneracja: `impl/ci/kat/run_falcon_kat.sh`.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "falcon.h"
#include "internal.h"
#include "shake.h"

#define FT_N        1536
#define FT_Q        18433
#define FT_LOGN     10

/* Syntetyczne, publiczne dane testowe — NIE są sekretami. */
static const uint8_t KSEED[32] = {
	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
};
static const uint8_t SSEED[32] = {
	0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
	0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f,
	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
	0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f
};
static const uint8_t NONCE[40] = {
	0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
	0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f, 0x50, 0x51, 0x52, 0x53,
	0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5d,
	0x5e, 0x5f, 0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67
};
static const uint8_t MSG[32] = {
	0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f,
	0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77,
	0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f,
	0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87
};

static void
die(const char *msg)
{
	fprintf(stderr, "gen_falcon_kat: %s\n", msg);
	exit(3);
}

static void
put_hex(FILE *f, const char *key, const void *data, size_t len)
{
	const unsigned char *b = data;
	size_t i;

	fprintf(f, "%s = ", key);
	for (i = 0; i < len; i ++) {
		fprintf(f, "%02x", b[i]);
	}
	fputc('\n', f);
}

static void
shake256_hex(FILE *f, const char *key, const void *data, size_t len)
{
	shake_context sc;
	unsigned char d[32];

	shake_init(&sc, 512);
	shake_inject(&sc, data, len);
	shake_flip(&sc);
	shake_extract(&sc, d, sizeof d);
	put_hex(f, key, d, sizeof d);
}

/* c0 jako bajty u16 little-endian (ta sama konwencja co harness WP-023). */
static void
c0_to_le(const uint16_t *c0, unsigned char out[FT_N * 2])
{
	size_t i;

	for (i = 0; i < FT_N; i ++) {
		out[2 * i] = (unsigned char)(c0[i] & 0xFF);
		out[2 * i + 1] = (unsigned char)(c0[i] >> 8);
	}
}

int
main(int argc, char **argv)
{
	unsigned char pkey[3000];
	unsigned char skey[25000];
	unsigned char sig[8192];
	unsigned char c0_le[FT_N * 2];
	uint16_t c0[FT_N];
	size_t pkey_len, skey_len, sig_len;
	falcon_keygen *fk;
	falcon_sign *fs;
	falcon_vrfy *fv;
	shake_context sc;
	FILE *f;
	size_t i;

	if (argc != 2) {
		fprintf(stderr, "usage: %s OUT.txt\n", argv[0]);
		return 2;
	}

	/* --- keygen (deterministyczny seed, replace=1) --- */
	fk = falcon_keygen_new(FT_LOGN, 1);
	if (fk == NULL) {
		die("falcon_keygen_new(10, ternary) == NULL");
	}
	falcon_keygen_set_seed(fk, KSEED, sizeof KSEED, 1);
	pkey_len = sizeof pkey;
	skey_len = sizeof skey;
	if (!falcon_keygen_make(fk, FALCON_COMP_STATIC,
		skey, &skey_len, pkey, &pkey_len))
	{
		die("falcon_keygen_make failed");
	}
	falcon_keygen_free(fk);

	/* Pierwszy bajt pk: ternary(0x80) | rezerwa=0 | logn=10 -> 0x8A. */
	if (pkey[0] != (unsigned char)(0x80 | FT_LOGN)) {
		die("unexpected pkey header byte");
	}

	/* --- sign (zewnętrzny nonce, deterministyczny seed) --- */
	fs = falcon_sign_new();
	if (fs == NULL) {
		die("falcon_sign_new failed");
	}
	if (!falcon_sign_set_private_key(fs, skey, skey_len)) {
		die("falcon_sign_set_private_key failed");
	}
	falcon_sign_set_seed(fs, SSEED, sizeof SSEED, 1);
	falcon_sign_start_external_nonce(fs, NONCE, sizeof NONCE);
	falcon_sign_update(fs, MSG, sizeof MSG);
	sig_len = falcon_sign_generate(fs, sig, sizeof sig, FALCON_COMP_STATIC);
	if (sig_len == 0) {
		die("falcon_sign_generate failed");
	}
	falcon_sign_free(fs);

	/*
	 * Pierwszy bajt podpisu: ternary(0x80) | comp(static=1 -> 0x20) |
	 * rezerwa=0 | logn=10 -> 0xAA (dekoduje to falcon_vrfy_verify:
	 * comp = (fb >> 5) & 3, bit 4 zarezerwowany = 0).
	 */
	if (sig[0] != (unsigned char)(0x80 | (FALCON_COMP_STATIC << 5) | FT_LOGN)) {
		die("unexpected sig header byte");
	}

	/* --- verify w silniku: samo-weryfikacja wektora --- */
	fv = falcon_vrfy_new();
	if (fv == NULL) {
		die("falcon_vrfy_new failed");
	}
	if (!falcon_vrfy_set_public_key(fv, pkey, pkey_len)) {
		die("falcon_vrfy_set_public_key failed");
	}
	falcon_vrfy_start(fv, NONCE, sizeof NONCE);
	falcon_vrfy_update(fv, MSG, sizeof MSG);
	if (falcon_vrfy_verify(fv, sig, sig_len) != 1) {
		die("engine did not verify its own KAT signature");
	}
	falcon_vrfy_free(fv);

	/* --- c0: dokładnie ścieżka weryfikatora (SHAKE256, nonce||msg) --- */
	shake_init(&sc, 512);
	shake_inject(&sc, NONCE, sizeof NONCE);
	shake_inject(&sc, MSG, sizeof MSG);
	shake_flip(&sc);
	falcon_hash_to_point(&sc, FT_Q, c0, FT_LOGN);
	c0_to_le(c0, c0_le);

	/* --- zapis --- */
	f = fopen(argv[1], "wb");
	if (f == NULL) {
		die("cannot open output file");
	}
	fprintf(f, "# WP-024 KAT — silnik FT1536 (Extra/c), ternary logn=%d, q=%d\n", FT_LOGN, FT_Q);
	fprintf(f, "# Wejścia syntetyczne i publiczne; klucz prywatny tylko jako shake256.\n");
	fprintf(f, "format = FT-KAT-01\n");
	fprintf(f, "profile = ternary logn=%d q=%d comp=static\n", FT_LOGN, FT_Q);
	put_hex(f, "keygen_seed", KSEED, sizeof KSEED);
	put_hex(f, "sign_seed", SSEED, sizeof SSEED);
	put_hex(f, "nonce", NONCE, sizeof NONCE);
	put_hex(f, "msg", MSG, sizeof MSG);
	fprintf(f, "pkey_len = %lu\n", (unsigned long)pkey_len);
	put_hex(f, "pkey", pkey, pkey_len);
	shake256_hex(f, "pkey_shake256", pkey, pkey_len);
	shake256_hex(f, "skey_shake256", skey, skey_len);
	fprintf(f, "sig_len = %lu\n", (unsigned long)sig_len);
	put_hex(f, "sig", sig, sig_len);
	shake256_hex(f, "sig_shake256", sig, sig_len);
	put_hex(f, "c0", c0_le, sizeof c0_le);
	shake256_hex(f, "c0_shake256", c0_le, sizeof c0_le);
	fprintf(f, "engine_vrfy = PASS\n");

	for (i = 0; i < sizeof pkey; i ++) {
		pkey[i] = 0;
	}
	for (i = 0; i < sizeof skey; i ++) {
		skey[i] = 0;
	}
	for (i = 0; i < sizeof sig; i ++) {
		sig[i] = 0;
	}
	for (i = 0; i < sizeof c0_le; i ++) {
		c0_le[i] = 0;
	}
	if (fclose(f) != 0) {
		die("close failed");
	}
	return 0;
}
