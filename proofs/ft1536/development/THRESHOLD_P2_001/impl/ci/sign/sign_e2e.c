/*
 * WP-031 — harness silnika dla e2e sign 2-z-3 (TEST-ORACLE).
 *
 * Ten plik NIE jest implementacją protokołu. Daje dwa tryby na prawdziwym
 * silniku FT1536 (`Extra/c`):
 *
 *   sign_e2e keygen <testkey.bin>
 *       Deterministyczny keygen z syntetycznego seeda `0x42`
 *       (`falcon_keygen_set_seed(..., replace=1)`) → zapisuje bufor `sk`,
 *       `pk` i wielomian `h` (z `pk` przez `falcon_decode_18433`) do
 *       roboczego pliku dla testkitu. Klucz jest SYNTETYCZNY i publiczny
 *       (jak KAT WP-024); bufor `sk` jest czyszczony po zapisie.
 *
 *   sign_e2e verify_one <case.txt>
 *       Sprawdza jeden wektor przez `falcon_vrfy` (pełna ścieżka
 *       weryfikatora silnika: równanie + forma kwadratowa normy).
 *       Plik przypadku: linie `nazwa = hex` (`pkey`, `msg`, `nonce`, `sig`).
 *       Kod 0 = PASS, 1 = FAIL, 2 = błąd wejścia.
 *
 * Determinizm: brak systemowego RNG (seed zastąpiony, nonce jawny w
 * wektorach). Wszystkie artefakty trafiają do `impl/.build/sign/`.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "falcon.h"
#include "internal.h"
#include "shake.h"

#define FT_N     1536
#define FT_LOGN  10

/* Syntetyczny, publiczny seed keygena (jak WP-024, inny bajt wiodący). */
static const uint8_t KSEED[32] = {
	0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42,
	0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42,
	0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42,
	0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42
};

static void
die(const char *msg)
{
	fprintf(stderr, "sign_e2e: %s\n", msg);
	exit(3);
}

static void
wipe(void *p, size_t len)
{
	volatile uint8_t *v = p;

	while (len -- > 0) {
		*v ++ = 0;
	}
}

static int
hex_val(int c)
{
	if (c >= '0' && c <= '9') {
		return c - '0';
	}
	if (c >= 'a' && c <= 'f') {
		return c - 'a' + 10;
	}
	if (c >= 'A' && c <= 'F') {
		return c - 'A' + 10;
	}
	return -1;
}

/* Zwraca długość zdekodowanego bufora (buf ma >= len/2 B). */
static size_t
unhex(const char *s, uint8_t *buf, size_t max)
{
	size_t n = 0;

	while (s[0] != 0 && s[1] != 0) {
		int hi = hex_val(s[0]);
		int lo = hex_val(s[1]);

		if (hi < 0 || lo < 0) {
			return (size_t)-1;
		}
		if (n >= max) {
			return (size_t)-1;
		}
		buf[n ++] = (uint8_t)((hi << 4) | lo);
		s += 2;
	}
	return s[0] == 0 ? n : (size_t)-1;
}

static int
put_u32_le(FILE *f, uint32_t v)
{
	unsigned char b[4];

	b[0] = (unsigned char)(v);
	b[1] = (unsigned char)(v >> 8);
	b[2] = (unsigned char)(v >> 16);
	b[3] = (unsigned char)(v >> 24);
	return fwrite(b, 1, 4, f) == 4 ? 0 : -1;
}

static int
do_keygen(const char *out_path)
{
	unsigned char pkey[3000];
	unsigned char skey[25000];
	uint16_t h[FT_N];
	uint16_t h_le[FT_N];
	size_t pkey_len, skey_len;
	falcon_keygen *fk;
	FILE *f;
	size_t i;

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

	if (pkey[0] != (unsigned char)(0x80 | FT_LOGN)) {
		die("unexpected pkey header byte");
	}
	if (skey[0] != (unsigned char)(0x80 | (FALCON_COMP_STATIC << 5) | FT_LOGN)) {
		die("unexpected skey header byte");
	}

	/* h = zdekodowany klucz publiczny (bez bajtu nagłówka). */
	if (falcon_decode_18433(h, FT_LOGN, pkey + 1, pkey_len - 1)
		!= pkey_len - 1)
	{
		die("falcon_decode_18433 failed");
	}
	for (i = 0; i < FT_N; i ++) {
		h_le[i] = h[i];
	}

	f = fopen(out_path, "wb");
	if (f == NULL) {
		die("cannot open testkey.bin");
	}
	if (put_u32_le(f, (uint32_t)skey_len)
		|| fwrite(skey, 1, skey_len, f) != skey_len
		|| put_u32_le(f, (uint32_t)pkey_len)
		|| fwrite(pkey, 1, pkey_len, f) != pkey_len
		|| fwrite(h_le, 2, FT_N, f) != FT_N)
	{
		die("write testkey.bin failed");
	}
	if (fclose(f) != 0) {
		die("close failed");
	}

	wipe(skey, sizeof skey);
	wipe(pkey, sizeof pkey);
	printf("KEYGEN OK skey_len=%lu pkey_len=%lu\n",
		(unsigned long)skey_len, (unsigned long)pkey_len);
	return 0;
}

static int
do_verify_one(const char *case_path)
{
	static uint8_t pkey[3000];
	static uint8_t msg[1 << 20];
	static uint8_t nonce[40];
	static uint8_t sig[8192];
	size_t pkey_len = 0, msg_len = 0, nonce_len = 0, sig_len = 0;
	char line[1 << 21];
	FILE *f;
	falcon_vrfy *fv;
	int ok;

	f = fopen(case_path, "r");
	if (f == NULL) {
		fprintf(stderr, "sign_e2e: cannot open %s\n", case_path);
		return 2;
	}
	while (fgets(line, sizeof line, f) != NULL) {
		char *eq = strchr(line, '=');
		char *val;
		size_t n, klen;

		if (eq == NULL) {
			continue;
		}
		*eq = 0;
		/* Klucz pola: obetnij spacje/taby przed `=`. */
		klen = strlen(line);
		while (klen > 0 && (line[klen - 1] == ' ' || line[klen - 1] == '\t')) {
			line[-- klen] = 0;
		}
		val = eq + 1;
		while (*val == ' ' || *val == '\t') {
			val ++;
		}
		n = strlen(val);
		while (n > 0 && (val[n - 1] == '\n' || val[n - 1] == '\r')) {
			val[-- n] = 0;
		}
		if (strcmp(line, "pkey") == 0) {
			pkey_len = unhex(val, pkey, sizeof pkey);
		} else if (strcmp(line, "msg") == 0) {
			msg_len = unhex(val, msg, sizeof msg);
		} else if (strcmp(line, "nonce") == 0) {
			nonce_len = unhex(val, nonce, sizeof nonce);
		} else if (strcmp(line, "sig") == 0) {
			sig_len = unhex(val, sig, sizeof sig);
		}
	}
	fclose(f);

	if (pkey_len == (size_t)-1 || msg_len == (size_t)-1
		|| nonce_len != 40 || sig_len == (size_t)-1
		|| pkey_len < 2 || sig_len < 1)
	{
		fprintf(stderr, "sign_e2e: bad case file\n");
		return 2;
	}

	fv = falcon_vrfy_new();
	if (fv == NULL) {
		die("falcon_vrfy_new failed");
	}
	ok = falcon_vrfy_set_public_key(fv, pkey, pkey_len);
	if (ok) {
		falcon_vrfy_start(fv, nonce, nonce_len);
		falcon_vrfy_update(fv, msg, msg_len);
		ok = falcon_vrfy_verify(fv, sig, sig_len) == 1;
	}
	falcon_vrfy_free(fv);

	printf("ENGINE VERIFY %s\n", ok ? "PASS" : "FAIL");
	return ok ? 0 : 1;
}

int
main(int argc, char **argv)
{
	if (argc == 3 && strcmp(argv[1], "keygen") == 0) {
		return do_keygen(argv[2]);
	}
	if (argc == 3 && strcmp(argv[1], "verify_one") == 0) {
		return do_verify_one(argv[2]);
	}
	fprintf(stderr,
		"usage: %s keygen <testkey.bin> | verify_one <case.txt>\n",
		argv[0]);
	return 2;
}
