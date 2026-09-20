/* Public fixtures, unmodified official dudect engine, and lossless receipts.
 * FT1536 harness, Niirmata. No KeyGen, secret loader, or Sign entry point.
 */
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <inttypes.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#define DUDECT_IMPLEMENTATION
#include "dudect.h"

typedef uint64_t (*target_fn)(uint64_t, uint64_t);
extern target_fn select_target(unsigned);
static target_fn target;
static unsigned case_id;
static uint64_t public_order;
static volatile uint64_t sink;
static volatile sig_atomic_t stopped;
static const size_t batch_size = 100000;

static void stop_handler(int sig) { (void)sig; stopped = 1; }
static double now(void)
{
    struct timespec ts;
    if (clock_gettime(CLOCK_MONOTONIC, &ts)) { perror("clock_gettime"); exit(2); }
    return (double)ts.tv_sec + (double)ts.tv_nsec * 1e-9;
}

/* SplitMix64 is only a reproducible public ordering/fixture generator. */
static uint64_t next_word(void)
{
    uint64_t z = (public_order += UINT64_C(0x9e3779b97f4a7c15));
    z = (z ^ (z >> 30)) * UINT64_C(0xbf58476d1ce4e5b9);
    z = (z ^ (z >> 27)) * UINT64_C(0x94d049bb133111eb);
    return z ^ (z >> 31);
}
static uint64_t below(uint64_t n)
{
    uint64_t x, threshold = -n % n;
    do { x = next_word(); } while (x < threshold);
    return x % n;
}
static void fixture(unsigned c, unsigned cls, uint64_t *x, uint64_t *y)
{
    uint64_t r = next_word(), frac = r & UINT64_C(0x000fffffffffffff);
    *y = 0;
    switch (c) {
    case 0: *x = UINT64_C(0x3fd0000000000000) | frac; break;
    case 1: *x = cls; *y = 1; break;
    case 2: *x = cls ? UINT64_C(0x3fe8000000000000) : UINT64_C(0x3fd0000000000000); break;
    case 3: *x = (cls ? UINT64_C(0x3fe8000000000000) : UINT64_C(0x3fd0000000000000)) | (UINT64_C(1)<<63); break;
    case 4: *x = ((uint64_t)(1021 + cls)<<52) | frac | (r & (UINT64_C(1)<<63)); break;
    case 5:
        *x = UINT64_C(0x3ff0000000000000) | frac;
        *y = *x ^ ((uint64_t)cls<<63); break;
    case 6:
        *x = UINT64_C(0x3ff0000000000000) | (frac & UINT64_C(0x0001ffffffffffff))
            | (cls ? UINT64_C(0x000c000000000000) : 0);
        *y = *x; break;
    case 7:
        *x = UINT64_C(0x3ff0000000000000) | frac;
        *y = (uint64_t)(cls ? 1058 : 1019)<<52; break;
    case 8: *x = ((uint64_t)(1023 + cls)<<52) | frac; break;
    case 9: {
        double d = (double)((int)(r & 2047) - 1024) + (cls ? 0.25 : 0.5);
        memcpy(x, &d, sizeof d); break;
    }
    case 10: *x = cls ? UINT64_C(0x3fe62e42fefa39ee) : 0; break;
    case 11: *x = ((uint64_t)(1 + cls)<<52) | 1; break;
    case 12: *x = cls ? 0 : UINT64_C(0x8000000000000000); break;
    case 13: *x = cls ? (uint64_t)(int64_t)((int32_t)(r & UINT64_C(0x7fffffff)) + (int64_t)1) : 0; break;
    default: abort();
    }
}

void prepare_inputs(dudect_config_t *c, uint8_t *data, uint8_t *classes)
{
    for (size_t i = 0; i < c->number_measurements; i++) classes[i] = (uint8_t)(i & 1);
    for (size_t i = c->number_measurements; i > 1; i--) {
        size_t j = (size_t)below(i);
        uint8_t tmp = classes[i-1]; classes[i-1] = classes[j]; classes[j] = tmp;
    }
    memset(data, 0, c->number_measurements * c->chunk_size);
    for (size_t i = 0; i < c->number_measurements; i++) {
        uint64_t x, y;
        fixture(case_id, classes[i], &x, &y);
        memcpy(data + i*c->chunk_size, &x, 8);
        memcpy(data + i*c->chunk_size + 8, &y, 8);
    }
}

uint8_t do_one_computation(uint8_t *data)
{
    uint64_t x, y;
    memcpy(&x, data, 8); memcpy(&y, data+8, 8);
    sink = target(x, y);
    return (uint8_t)sink;
}

static void number(double x)
{
    if (isfinite(x)) printf("%.17g", x); else printf("null");
}
static void statistics(dudect_ctx_t *c, uint64_t batch, dudect_state_t state)
{
    ttest_ctx_t *best = max_test(c);
    size_t best_index = 0;
    for (size_t i = 0; i < DUDECT_TESTS; i++) if (best == c->ttest_ctxs[i]) best_index = i;
    printf("FT1536_BATCH {\"batch\":%" PRIu64 ",\"state\":%d,\"max_index\":%zu,\"max_t\":", batch, state, best_index);
    number(fabs(t_compute(best)));
    printf(",\"n\":[%.0f,%.0f],\"percentiles\":[", c->ttest_ctxs[0]->n[0], c->ttest_ctxs[0]->n[1]);
    for (size_t i = 0; i < DUDECT_NUMBER_PERCENTILES; i++) printf("%s%" PRId64, i ? "," : "", c->percentiles[i]);
    printf("],\"tests\":[");
    for (size_t i = 0; i < DUDECT_TESTS; i++) {
        ttest_ctx_t *t = c->ttest_ctxs[i];
        printf("%s[%.0f,%.0f,%.17g,%.17g,%.17g,%.17g,", i ? "," : "",
               t->n[0], t->n[1], t->mean[0], t->mean[1], t->m2[0], t->m2[1]);
        number(t_compute(t)); printf("]");
    }
    printf("]}\n");
    if (fflush(stdout)) { perror("stdout"); exit(2); }
}
static void write_all(FILE *f, const void *p, size_t n)
{
    if (fwrite(p, 1, n, f) != n) { perror("raw write"); exit(2); }
}

/* Recalculate the official engine's statistics from decompressed receipts. */
static int replay(void)
{
    char magic[8];
    if (fread(magic, 1, 8, stdin) != 8 || memcmp(magic, "FTDUD01\n", 8)) return 2;
    dudect_ctx_t c;
    dudect_config_t cfg = {64, batch_size};
    dudect_init(&c, &cfg);
    uint64_t h[3], last = 0;
    size_t got;
    while ((got = fread(h, 1, sizeof h, stdin)) == sizeof h) {
        if (h[0] != batch_size || h[1] != last+1) return 2;
        if (fread(c.classes, 1, batch_size, stdin) != batch_size
            || fread(c.exec_times, 8, batch_size, stdin) != batch_size) return 2;
        dudect_state_t state = DUDECT_NO_LEAKAGE_EVIDENCE_YET;
        if (last == 0) prepare_percentiles(&c);
        else { update_statistics(&c); state = report(&c); }
        statistics(&c, h[1], state); last = h[1];
    }
    if (got || !feof(stdin) || !last) return 2;
    dudect_free(&c);
    return 0;
}

int main(int argc, char **argv)
{
    if (argc == 2 && !strcmp(argv[1], "--replay")) return replay();
    if (argc < 4) return 2;
    case_id = (unsigned)strtoul(argv[2], NULL, 10);
    target = select_target(case_id);
    public_order = strtoull(argv[3], NULL, 16);
    if (!target) return 2;
    if (!strcmp(argv[1], "--fixtures")) {
        for (unsigned i = 0; i < 2048; i++) {
            uint64_t x, y; fixture(case_id, i & 1, &x, &y);
            printf("%u %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\n", i & 1, x, y, target(x,y));
        }
        return 0;
    }
    if (argc != 7 || strcmp(argv[1], "--run")) return 2;
    double budget = strtod(argv[4], NULL);
    unsigned long batch_limit = strtoul(argv[6], NULL, 10);
    if (!(budget > 0 && budget <= 28800) || sizeof(long) != 8) return 2;
    FILE *raw = fdopen(atoi(argv[5]), "wb");
    if (!raw) { perror("fdopen"); return 2; }
    signal(SIGTERM, stop_handler); signal(SIGINT, stop_handler);
    signal(SIGPIPE, SIG_IGN);
    setvbuf(stdout, NULL, _IOLBF, 0);
    double start = now();
    uint64_t initial_order = public_order;
    for (unsigned i = 0; i < 10000; i++) {
        uint64_t x, y; fixture(case_id, i & 1, &x, &y); sink = target(x, y);
    }
    public_order = initial_order;
    dudect_ctx_t c;
    dudect_config_t cfg = {64, batch_size};
    dudect_init(&c, &cfg);
    int64_t *deltas = calloc(batch_size, sizeof *deltas);
    if (!deltas) return 2;
    write_all(raw, "FTDUD01\n", 8);
    dudect_state_t state = DUDECT_NO_LEAKAGE_EVIDENCE_YET;
    uint64_t batch = 0;
    while (!stopped && now()-start < budget && (!batch_limit || batch < batch_limit)) {
        uint64_t before = public_order;
        state = dudect_main(&c);
        batch++;
        statistics(&c, batch, state);
        for (size_t i = 0; i+1 < batch_size; i++) deltas[i] = c.ticks[i+1] - c.ticks[i];
        deltas[batch_size-1] = 0; /* not a measurement, upstream discards this slot */
        uint64_t h[3] = {batch_size, batch, before};
        write_all(raw, h, sizeof h); write_all(raw, c.classes, batch_size);
        write_all(raw, deltas, batch_size * sizeof *deltas);
        if (fflush(raw) || fgetc(stdin) != 'A') { stopped = 1; break; }
        /* Parent acknowledges only after compression/monitoring: no overlap. */
        if (state == DUDECT_LEAKAGE_FOUND) break;
    }
    printf("FT1536_RESULT {\"case\":%u,\"batches\":%" PRIu64 ",\"elapsed_seconds\":%.9f,"
           "\"state\":%d,\"stopped\":%s,\"n\":[%.0f,%.0f],\"sink\":\"%016" PRIx64 "\"}\n",
           case_id, batch, now()-start, state, stopped ? "true" : "false",
           c.ttest_ctxs[0]->n[0], c.ttest_ctxs[0]->n[1], sink);
    free(deltas); dudect_free(&c);
    if (fclose(raw) || fflush(stdout)) return 2;
    return stopped ? 130 : (state == DUDECT_LEAKAGE_FOUND ? 10 : 0);
}
