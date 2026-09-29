/* Niirmata / FT1536 public diagnostics, RUN_002.
 * Original slices: Falcon Project / Thomas Pornin; original license below.
 * No key material, KeyGen, loader, Sign or PRNG is executed.
 */
/*
 * Falcon signature generation.
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2017  Falcon Project
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ===========================(LICENSE END)=============================
 *
 * @author   Thomas Pornin <thomas.pornin@nccgroup.trust>
 */

#include <assert.h>
#include <inttypes.h>
#include <stdio.h>
#include "internal.h"
#include "public_cases.h"
typedef int (*samplerZ)(void *ctx, fpr mu, fpr sigma);
typedef struct { int n; int y[2]; fpr mu[2]; } public_callback;
static int callback(void *ctx, fpr mu, fpr sigma)
{
    public_callback *c = ctx;
    assert(c->n < 2 && sigma != fpr_zero);
    c->mu[c->n] = mu;
    return c->y[c->n++];
}
static void terminal(samplerZ samp, void *samp_ctx, fpr *z0, fpr *z1,
    const fpr *tree, const fpr *t0, const fpr *t1, unsigned logn)
{
    assert(logn == 0);
	if (logn == 0) {
		fpr r0, r1, rx;
		fpr sigma;

		sigma = tree[0];
		r1 = *t1;
		r0 = *t0;
		r1 = fpr_sub(r1, fpr_of(
			samp(samp_ctx, r1, fpr_mul(fpr_IW1I, sigma))));
		rx = fpr_half(r1);
		r0 = fpr_add(r0, rx);
		r0 = fpr_sub(r0, fpr_of(
			samp(samp_ctx, r0, sigma)));
		r0 = fpr_sub(r0, rx);
		*z0 = r0;
		*z1 = r1;
		return;
	}

}
static void suffix(fpr *tx, fpr *ty, fpr *t0, fpr *t1,
    const fpr *b00, const fpr *b01, const fpr *b10, const fpr *b11)
{
    size_t n = 1536;
    unsigned logn = 10;
		memcpy(t0, tx, n * sizeof *tx);
		memcpy(t1, ty, n * sizeof *ty);
		falcon_poly_mul_fft3(tx, b00, logn, 1);
		falcon_poly_mul_fft3(ty, b10, logn, 1);
		falcon_poly_add_fft3(tx, ty, logn, 1);
		memcpy(ty, t0, n * sizeof *t0);
		falcon_poly_mul_fft3(ty, b01, logn, 1);

		memcpy(t0, tx, n * sizeof *tx);
		falcon_poly_mul_fft3(t1, b11, logn, 1);
		falcon_poly_add_fft3(t1, ty, logn, 1);

}
int main(void)
{
    for (size_t i = 0; i < sizeof term_cases / sizeof term_cases[0]; i++) {
        fpr z0, z1, sigma = fpr_one;
        public_callback c = { 0, {term_cases[i].y1, term_cases[i].y0}, {0, 0} };
        terminal(callback, &c, &z0, &z1, &sigma, &term_cases[i].t0, &term_cases[i].t1, 0);
        assert(c.n == 2);
        /* Pure primitives, recomputed from identical read-time words:
         * z1 is the unchanged terminal r1, mu[1] is the callback's actual mu0.
         * These are diagnostics; no kernel determinism theorem is claimed. */
        fpr rx = fpr_half(z1);
        fpr sub0 = fpr_sub(c.mu[1], fpr_of(term_cases[i].y0));
        assert(fpr_sub(sub0, rx) == z0);
        printf("{\"case\":\"terminal\",\"i\":%zu,\"mu1\":\"%016" PRIx64
               "\",\"mu0\":\"%016" PRIx64 "\",\"z0\":\"%016" PRIx64
               "\",\"z1\":\"%016" PRIx64 "\",\"rx_recomputed\":\"%016" PRIx64
               "\",\"sub0_recomputed\":\"%016" PRIx64 "\"}\n", i,c.mu[0],c.mu[1],z0,z1,rx,sub0);
    }
    for (size_t i = 0; i < sizeof rint_cases / sizeof rint_cases[0]; i++) {
        printf("{\"case\":\"rint\",\"i\":%zu,\"word\":\"%016" PRIx64
               "\",\"result\":%" PRId64 "}\n",i,rint_cases[i],fpr_rint(rint_cases[i]));
    }
    static fpr x[1536], y[1536], sx[1536], sy[1536], t0[1536], t1[1536];
    static fpr b00[1536], b01[1536], b10[1536], b11[1536];
    for (size_t i = 0; i < 1536; i++) {
        x[i] = sx[i] = fpr_of((int)(i % 7) - 3);
        y[i] = sy[i] = fpr_of((int)(i % 5) - 2);
        b00[i] = fpr_of((int)(i % 3) - 1);
        b01[i] = fpr_of((int)(i % 11) - 5);
        b10[i] = fpr_of((int)(i % 13) - 6);
        b11[i] = fpr_of((int)(i % 17) - 8);
    }
    suffix(x,y,t0,t1,b00,b01,b10,b11);
    for (size_t i = 0; i < 1536; i++) {
        printf("{\"case\":\"suffix\",\"i\":%zu,\"x\":\"%016" PRIx64
          "\",\"y\":\"%016" PRIx64 "\",\"b00\":\"%016" PRIx64
          "\",\"b01\":\"%016" PRIx64 "\",\"b10\":\"%016" PRIx64
          "\",\"b11\":\"%016" PRIx64 "\",\"out0\":\"%016" PRIx64
          "\",\"out1\":\"%016" PRIx64 "\"}\n",
          i,sx[i],sy[i],b00[i],b01[i],b10[i],b11[i],t0[i],t1[i]);
    }
    return 0;
}
