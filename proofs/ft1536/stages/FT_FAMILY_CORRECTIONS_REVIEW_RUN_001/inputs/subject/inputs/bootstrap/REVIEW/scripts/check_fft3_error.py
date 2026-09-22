#!/usr/bin/env python3
"""FT family: evaluation-error check of source-order FFT3 (validation).

The analytic statement under test is the PROPOSED forward-error bound
(see CORRECTIONS.md item 5 and the paper; status: proposed / to be proved,
not a completed derivation):

    |fl_a(z_j) - a(zeta_j)|  <=  gamma_{c*ell} * (1 + eps_tw)^(ell+1) * ||a||_1,
    gamma_k = k*u/(1-k*u),  u = 2^-53,  ell = logn,

with the per-level constant c NOT pinned (this check uses the crude 8*ell),
operation domains and the twiddle-error budget NOT derived.

Reference oracle: 256-bit MPFR (sage.all.RealField(256); correctly rounded
cos/sum) applied to the exact input coefficients -- a high-precision oracle,
not binary64 `math.cos`/`math.fsum` as in the withdrawn draft of this check.
The transform port mirrors falcon-fft.c `falcon_FFT3(., logn, 1)` (first pass
with fpr_W1R/W1I, doubling with fpr_gm3_square, tripling with fpr_gm3_cubic
and fpr_W2/W4) and reads the twiddle tables as the exact IEEE-754 bit
patterns from Extra/c/fpr-emulated.h. The port is NOT proven bit-identical to
the FPEMU FPC macros (operation order of FPC_SQR may differ in the last
ulp); that binding remains OPEN.

Run with (Sage 10.9 CLI of this environment; `sage -python` of the older
Sage 9.5 campaign does not exist here):

  sage scripts/check_fft3_error.py
  # equivalent: /home/footfalcon/miniforge3/envs/sage/bin/python \
  #             scripts/check_fft3_error.py

`sage plik.py` runs plain Python with `sage.all` importable and WITHOUT the
Sage preparser (only `plik.sage`, `-c` and the REPL are pre-parsed).

Checks per N and input class:
  V1  outputs are compared against the source slot map
      r_j = 1 + 6*rev_{logn-2}(j/3) + N*(j mod 3), verified on monomials;
  V2  max_j |error_j| <= 8*ell*u * ||a||_1 (crude constant), with the
      empirical constant c_emp = max|err|/(ell*u*||a||_1) recorded,
  V3  the withdrawn counterexample: |a(zeta)| = sqrt(3)/(2 sin(pi/(3N)))
      for a = 1 + X + ... + X^(N-1), versus the withdrawn sqrt(N) bound.

Output: results/fft3_error.json.
"""
import cmath
import json
import math
import os
import random
import struct

try:
    from sage.all import RealField
except ImportError:
    raise SystemExit(
        "this check needs the Sage MPFR oracle; run:\n"
        "  sage -python scripts/check_fft3_error.py")

RR = RealField(256)

U = 2.0 ** -53
NS_LOGN = [(768, 9), (1536, 10), (3072, 11)]

HERE = os.path.dirname(os.path.abspath(__file__))
FPR_HEADER = os.path.normpath(os.path.join(
    HERE, "..", "..", "..", "..", "..", "Extra", "c", "fpr-emulated.h"))
OUT = os.path.join(HERE, "..", "results")
os.makedirs(OUT, exist_ok=True)


def load_fpr_table(name):
    """Extract the FPC(0xlo, 0xhi) -> ... table `name` as float pairs."""
    with open(FPR_HEADER) as f:
        text = f.read()
    start = text.index(f"static const fpr {name}[]")
    start = text.index("{", start)
    depth = 0
    end = start
    for i in range(start, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                end = i
                break
    body = text[start:end]
    vals = []
    for chunk in body.split("FPC(")[1:]:
        hexes = chunk.split(")")[0].split(",")
        words = [int(h.strip().rstrip("ULL").strip(), 16) for h in hexes[:2]]
        vals.extend(struct.unpack("<d", struct.pack("<Q", w))[0] for w in words)
    return vals


def fft3_full(a, logn, gm3_square, gm3_cubic, w1r, w1i, w2, w4):
    """Port of falcon_FFT3(a, logn, 1): packed (re[u], re[u+hn]) layout."""
    n = 3 << (logn - 1)
    hn = n >> 1
    a = list(a)
    for u in range(hn):
        a0, a1 = a[u], a[u + hn]
        a[u] = a0 + a1 * w1r
        a[u + hn] = a1 * w1i
    t = hn
    tmin = 3
    m = 2
    while t > tmin:
        ht = t >> 1
        hm = m >> 1
        v1 = 0
        for u1 in range(hm):
            sr = gm3_square[((m + u1) << 1) + 0]
            si = gm3_square[((m + u1) << 1) + 1]
            v2 = v1 + ht
            for v in range(v1, v2):
                z0 = complex(a[v], a[v + hn])
                z1 = complex(a[v + ht], a[v + ht + hn]) * complex(sr, si)
                s = z0 + z1
                d = z0 - z1
                a[v], a[v + hn] = s.real, s.imag
                a[v + ht], a[v + ht + hn] = d.real, d.imag
            v1 += t
        t = ht
        m <<= 1
    # final tripling step (full)
    v = 1 << logn
    u = 0
    while u < hn:
        fA = complex(a[u], a[u + hn])
        fB = complex(a[u + 1], a[u + 1 + hn])
        fC = complex(a[u + 2], a[u + 2 + hn])
        x = complex(gm3_cubic[v + 0], gm3_cubic[v + 1])
        fB0 = fB * x
        fB1 = fB0 * w2
        fB2 = fB0 * w4
        fC0 = fC * (x * x)
        fC1 = fC0 * w2
        fC2 = fC0 * w4
        tB0 = fB0 + fC0
        tB1 = fB1 + fC2
        tB2 = fB2 + fC1
        r0, r1, r2 = fA + tB0, fA + tB1, fA + tB2
        a[u], a[u + hn] = r0.real, r0.imag
        a[u + 1], a[u + 1 + hn] = r1.real, r1.imag
        a[u + 2], a[u + 2 + hn] = r2.real, r2.imag
        u += 3
        v += 2
    return [complex(a[u], a[u + hn]) for u in range(hn)]


def slot_roots(logn, N):
    """Slot -> primitive root exponent map of falcon_FFT3(full=1):
    r_j = 1 + 6*rev_{logn-2}(j/3) + N*(j mod 3), verified on monomials and
    matching the documented rev8 formula for N=1536 (POSTPROCESSING_MAP)."""
    bits = logn - 2

    def rev(x):
        r = 0
        for _ in range(bits):
            r = (r << 1) | (x & 1)
            x >>= 1
        return r

    return [1 + 6 * rev(j // 3) + N * (j % 3) for j in range(N // 2)]


def exact_eval_ref(a, m, r):
    """a(zeta^r) with the 256-bit MPFR oracle: cos/sin correctly rounded at
    256 bits, accumulation at 256 bits; exact integer input coefficients."""
    two_pi = RR.pi() * 2
    acc_re = RR(0)
    acc_im = RR(0)
    for i, c in enumerate(a):
        ang = two_pi * RR((r * i) % m) / RR(m)
        acc_re += RR(c) * ang.cos()
        acc_im += RR(c) * ang.sin()
    return acc_re, acc_im


def main():
    rep = {"source_header": FPR_HEADER,
           "source_header_exists": os.path.exists(FPR_HEADER)}
    out = []

    def log(s):
        print(s)
        out.append(s)

    log("=== check_fft3_error.py (source-pinned twiddles) ===")
    gm3_square = load_fpr_table("fpr_gm3_square")
    gm3_cubic = load_fpr_table("fpr_gm3_cubic")
    w1r = struct.unpack("<d", struct.pack("<Q", 0x3FE0000000000000))[0]
    w1i = struct.unpack("<d", struct.pack("<Q", 0x3FEBB67AE8584CAA))[0]
    w2 = complex(struct.unpack("<d", struct.pack("<Q", 0xBFE0000000000000))[0],
                 struct.unpack("<d", struct.pack("<Q", 0x3FEBB67AE8584CAA))[0])
    w4 = complex(struct.unpack("<d", struct.pack("<Q", 0xBFE0000000000000))[0],
                 struct.unpack("<d", struct.pack("<Q", 0xBFEBB67AE8584CAA))[0])
    log(f"tables: gm3_square {len(gm3_square) // 2} complex,"
        f" gm3_cubic {len(gm3_cubic) // 2} complex")
    rep["table_sizes"] = {"gm3_square": len(gm3_square) // 2,
                          "gm3_cubic": len(gm3_cubic) // 2}

    rng = random.Random(20260921)
    for N, logn in NS_LOGN:
        m = 3 * N
        section = {}
        cases = {
            "ternary": [rng.randint(-1, 1) for _ in range(N)],
            "gaussian": [rng.gauss(0, 3) for _ in range(N)],
            "all_ones": [1.0] * N,
            "alternating": [1.0 if i % 2 == 0 else -1.0 for i in range(N)],
        }
        for name, a in cases.items():
            af = [float(x) for x in a]
            got = fft3_full(af, logn, gm3_square, gm3_cubic, w1r, w1i, w2, w4)
            roots = slot_roots(logn, N)
            l1 = sum(abs(x) for x in af)
            errs = []
            for g, r in zip(got, roots):
                ref_re, ref_im = exact_eval_ref(af, m, r)
                dre = RR(g.real) - ref_re
                dim = RR(g.imag) - ref_im
                errs.append(float((dre * dre + dim * dim).sqrt()))
            maxerr = max(errs)
            bound = 8 * logn * U * l1
            rec = {
                "l1": l1, "max_error": maxerr,
                "bound_8ell_u_l1": bound,
                "bound_holds": maxerr <= bound,
                "slots": len(got),
                "distinct_roots": len(set(roots)),
                "empirical_const_maxerr_over_ell_u_l1": maxerr / (logn * U * l1),
            }
            section[name] = rec
            log(f"N={N} {name:10s} l1={l1:9.3f} max|err|={maxerr:.3e}"
                f" bound(8*ell*u*l1)={bound:.3e}"
                f" holds={rec['bound_holds']}"
                f" c_emp={rec['empirical_const_maxerr_over_ell_u_l1']:.2f}")

        val = math.sqrt(3) / (2 * math.sin(math.pi / m))
        section["all_ones_counterexample"] = {
            "abs_eval_exact": val,
            "asymptotic_3sqrt3_over_2pi_N":
                3 * math.sqrt(3) / (2 * math.pi) * N,
            "withdrawn_bound_sqrtN": math.sqrt(N),
            "violation_factor": val / math.sqrt(N),
        }
        log(f"N={N} all-ones |a(zeta)| = {val:.6f} vs withdrawn"
            f" sqrt(N) = {math.sqrt(N):.6f} (factor"
            f" {val / math.sqrt(N):.3f})")
        rep[f"N{N}"] = section

    rep["model_note"] = (
        "reference oracle: sage.all.RealField(256) MPFR (correctly rounded "
        "cos/sum), exact integer inputs; transform port uses the pinned "
        "fpr_gm3/fpr_W bit patterns with binary64 ops but is NOT proven "
        "bit-identical to the FPEMU FPC macros (binding OPEN). The bound "
        "itself is PROPOSED (constant c, operation domains and twiddle "
        "budget not derived); this run is a non-refutation check only.")
    with open(os.path.join(OUT, "fft3_error.json"), "w") as f:
        json.dump(rep, f, indent=2, sort_keys=True)
    log("Wrote fft3_error.json")


if __name__ == "__main__":
    main()
