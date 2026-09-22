/*
 * T02.1 harness — original C slice for the pinned Falcon frng.c.
 *
 * Built only against the pinned source/frng.c + source/internal.h (no source
 * edits); the SHAKE-extract boundary is an explicit public-fixture stub,
 * tagged in the emitted JSON as ORIGINAL_C_SLICE.
 *
 * Falcon Project / Thomas Pornin attribution and licenses preserved.
 */
#include <inttypes.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "internal.h"

#define T021_POISON 0xA5u
#define T021_HEAD   0x5Au
#define T021_TAIL   0xC3u
#define T021_FIXLEN 56u

/*
 * Pinned x86_64 LP64 layout model of `prng` (internal.h 767-778):
 * buf union d[4096]/u64 at 0; size_t ptr; state union d[256]/u64;
 * int type.  These checks fail the build if the model is not the
 * pinned one; the same numbers are re-verified by the Sage checker.
 */
typedef char t021_sizeof_prng [sizeof(prng) == 4368 ? 1 : -1];
typedef char t021_off_buf     [offsetof(prng, buf) == 0 ? 1 : -1];
typedef char t021_off_ptr     [offsetof(prng, ptr) == 4096 ? 1 : -1];
typedef char t021_off_state   [offsetof(prng, state) == 4104 ? 1 : -1];
typedef char t021_off_type    [offsetof(prng, type) == 4360 ? 1 : -1];
typedef char t021_align_prng  [__alignof__(prng) == 8 ? 1 : -1];

typedef struct {
	unsigned char head[32];
	prng p;
	unsigned char tail[32];
} guarded;

/* ---- SHAKE-extract boundary stub: public fixture bytes only ---- */
static const unsigned char *g_fixture;
static size_t g_fixture_len;
static unsigned long g_stub_calls;
static size_t g_stub_last_len;
static int g_stub_bad_len;

void
shake_extract(shake_context *sc, void *out, size_t len)
{
	(void)sc;
	g_stub_calls ++;
	g_stub_last_len = len;
	if (len != g_fixture_len) {
		g_stub_bad_len = 1;
		return;
	}
	memcpy(out, g_fixture, len);
}

static int
guarded_ok(const guarded *g)
{
	size_t i;

	for (i = 0; i < sizeof g->head; i ++) {
		if (g->head[i] != T021_HEAD) {
			return 0;
		}
		if (g->tail[i] != T021_TAIL) {
			return 0;
		}
	}
	return 1;
}

static int
poison_ok(const unsigned char *p, size_t n)
{
	size_t i;

	for (i = 0; i < n; i ++) {
		if (p[i] != T021_POISON) {
			return 0;
		}
	}
	return 1;
}

static void
print_hex(const unsigned char *p, size_t n)
{
	static const char hx[] = "0123456789abcdef";
	size_t i;

	putchar('"');
	for (i = 0; i < n; i ++) {
		putchar(hx[p[i] >> 4]);
		putchar(hx[p[i] & 15]);
	}
	putchar('"');
}

/* Read the live 64-bit counter exactly as refill_chacha20 does (frng.c:214). */
static uint64_t
read_counter(const prng *p)
{
	uint64_t cc;

	memcpy(&cc, p->state.d + 48, sizeof cc);
	return cc;
}

static void
setup_guarded(guarded *g)
{
	memset(g, T021_POISON, sizeof *g);
	memset(g->head, T021_HEAD, sizeof g->head);
	memset(g->tail, T021_TAIL, sizeof g->tail);
}

static void
begin_extract(const unsigned char *fx)
{
	g_fixture = fx;
	g_fixture_len = T021_FIXLEN;
	g_stub_calls = 0;
	g_stub_last_len = 0;
	g_stub_bad_len = 0;
}

static void
die(const char *msg)
{
	fprintf(stderr, "harness error: %s\n", msg);
	exit(2);
}

static void
dump_stage_fields(const char *stage, const guarded *g)
{
	printf("\"stage\":\"%s\",", stage);
	printf("\"state_hex\":");
	print_hex(g->p.state.d, sizeof g->p.state.d);
	printf(",");
	printf("\"buf_hex\":");
	print_hex(g->p.buf.d, sizeof g->p.buf.d);
	printf(",");
	printf("\"ptr\":%llu,", (unsigned long long)g->p.ptr);
	printf("\"type\":%d,", g->p.type);
	printf("\"cc_after\":\"%" PRIu64 "\",", read_counter(&g->p));
	printf("\"canary_ok\":%s,", guarded_ok(g) ? "true" : "false");
	printf("\"state_poison_ok\":%s,",
		poison_ok(g->p.state.d + 56, sizeof g->p.state.d - 56)
		? "true" : "false");
	printf("\"stub_calls\":%lu,", g_stub_calls);
	printf("\"stub_last_len\":%llu",
		(unsigned long long)g_stub_last_len);
}

int
main(int argc, char **argv)
{
	FILE *f;
	char ids[8][64];
	unsigned char *fx;
	size_t count, i;
	shake_context sc;
	guarded g;
	int ret;
	static const int bad_types[] = { 2, 3, -1, 99, 1 << 20 };
	size_t bi;

	if (argc != 4) {
		die("usage: prng-harness <fixtures.bin> <fixtures_ids.txt> <count>");
	}
	count = (size_t)strtoul(argv[3], NULL, 10);
	if (count != 7 || count > sizeof ids / sizeof ids[0]) {
		die("expected exactly 7 public fixtures");
	}
	f = fopen(argv[1], "rb");
	if (f == NULL) {
		die("cannot open fixtures.bin");
	}
	fx = malloc(count * T021_FIXLEN);
	if (fx == NULL) {
		die("out of memory");
	}
	if (fread(fx, T021_FIXLEN, count, f) != count) {
		die("short fixtures.bin");
	}
	if (fclose(f) != 0) {
		die("fixtures.bin close failed");
	}
	f = fopen(argv[2], "r");
	if (f == NULL) {
		die("cannot open fixtures_ids.txt");
	}
	for (i = 0; i < count; i ++) {
		if (fgets(ids[i], sizeof ids[i], f) == NULL) {
			die("short fixtures_ids.txt");
		}
		ids[i][strcspn(ids[i], "\r\n")] = 0;
	}
	if (fclose(f) != 0) {
		die("fixtures_ids.txt close failed");
	}

	printf("{\n");
	printf("\"schema\":\"PRNG_T021_HARNESS_DUMP_V1\",\n");
	printf("\"tag\":\"ORIGINAL_C_SLICE\",\n");
	printf("\"producer\":\"harness/prng_harness.c + pinned source/frng.c\",\n");
	printf("\"falcon_le_u\":%d,\n", FALCON_LE_U);
	printf("\"layout\":{\"sizeof_prng\":%llu,\"alignof_prng\":%llu,"
		"\"offsetof_buf\":%llu,\"offsetof_ptr\":%llu,"
		"\"offsetof_state\":%llu,\"offsetof_type\":%llu,"
		"\"sizeof_buf\":%llu,\"sizeof_state\":%llu},\n",
		(unsigned long long)sizeof(prng),
		(unsigned long long)__alignof__(prng),
		(unsigned long long)offsetof(prng, buf),
		(unsigned long long)offsetof(prng, ptr),
		(unsigned long long)offsetof(prng, state),
		(unsigned long long)offsetof(prng, type),
		(unsigned long long)sizeof g.p.buf.d,
		(unsigned long long)sizeof g.p.state.d);
	printf("\"fixtures\":[\n");
	for (i = 0; i < count; i ++) {
		const unsigned char *base = fx + i * T021_FIXLEN;
		uint64_t cc0;

		memcpy(&cc0, base + 48, sizeof cc0);
		printf("%s{\"id\":\"%s\",\"index\":%zu,\"init56_hex\":",
			(i == 0 ? "" : ","), ids[i], i);
		print_hex(base, T021_FIXLEN);
		printf(",\"cc0_readback\":\"%" PRIu64 "\",\"type_requested\":0,",
			cc0);
		setup_guarded(&g);
		memset(&sc, T021_POISON, sizeof sc);
		begin_extract(base);
		ret = falcon_prng_init(&g.p, &sc, 0);
		printf("\"type_returned\":%d,\"extract_len_bad\":%s,"
			"\"stages\":[\n", ret, g_stub_bad_len ? "true" : "false");
		printf("{");
		dump_stage_fields("after_init", &g);
		printf("},\n");
		falcon_prng_refill(&g.p);
		printf("{");
		dump_stage_fields("after_refill1", &g);
		printf("},\n");
		falcon_prng_refill(&g.p);
		printf("{");
		dump_stage_fields("after_refill2", &g);
		printf("}\n");
		printf("]}\n");
	}
	printf("],\n");

	/* identical init56 -> identical buffers, fresh independent instance */
	setup_guarded(&g);
	memset(&sc, T021_POISON, sizeof sc);
	begin_extract(fx);
	ret = falcon_prng_init(&g.p, &sc, 0);
	printf("\"determinism\":{\"fixture\":\"%s\",\"type_returned\":%d,",
		ids[0], ret);
	printf("\"state_hex\":");
	print_hex(g.p.state.d, sizeof g.p.state.d);
	printf(",\"buf_hex\":");
	print_hex(g.p.buf.d, sizeof g.p.buf.d);
	printf(",\"ptr\":%llu,\"type\":%d,\"cc_after\":\"%" PRIu64 "\","
		"\"extract_calls\":%lu}\n",
		(unsigned long long)g.p.ptr, g.p.type, read_counter(&g.p),
		g_stub_calls);

	/* type 1 is the same PRNG_CHACHA20 branch as type 0 */
	setup_guarded(&g);
	memset(&sc, T021_POISON, sizeof sc);
	begin_extract(fx);
	ret = falcon_prng_init(&g.p, &sc, 1);
	printf(",\"type_equivalence\":{\"fixture\":\"%s\",\"type_requested\":1,"
		"\"type_returned\":%d,\"state_hex\":", ids[0], ret);
	print_hex(g.p.state.d, sizeof g.p.state.d);
	printf(",\"buf_hex\":");
	print_hex(g.p.buf.d, sizeof g.p.buf.d);
	printf(",\"cc_after\":\"%" PRIu64 "\",\"extract_calls\":%lu}\n",
		read_counter(&g.p), g_stub_calls);

	/* unsupported types: return 0, no state write, no SHAKE consumption */
	printf(",\"unsupported\":[\n");
	for (bi = 0; bi < sizeof bad_types / sizeof bad_types[0]; bi ++) {
		setup_guarded(&g);
		memset(&sc, T021_POISON, sizeof sc);
		begin_extract(fx + 2 * T021_FIXLEN);
		ret = falcon_prng_init(&g.p, &sc, bad_types[bi]);
		printf("%s{\"type\":%d,\"returned\":%d,\"extract_calls\":%lu,"
			"\"all_poison\":%s,\"canary_ok\":%s}\n",
			(bi == 0 ? "" : ","), bad_types[bi], ret, g_stub_calls,
			poison_ok((const unsigned char *)&g.p, sizeof g.p)
			? "true" : "false",
			guarded_ok(&g) ? "true" : "false");
	}
	printf("]\n}\n");

	free(fx);
	return 0;
}

