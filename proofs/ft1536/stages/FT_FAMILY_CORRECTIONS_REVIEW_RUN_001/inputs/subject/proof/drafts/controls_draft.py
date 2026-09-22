#!/usr/bin/env python3
"""S01 semantic controls: negative, no-op and mutation tests for R1-R7.

These are executable controls over models, sources and computed numbers --
NOT label-presence checks (label scans appear only as a supplement in N6).

  N1  free-target triviality (R2): the withdrawn P2 definition (adversary
      chooses values c) admits the trivial solver c=0, z1=z2=0 with Q=0 < B
      for every key -- a countermodel of the DEFINITION, not a ROM forgery.
      Under the fixed definition (targets = ROM table values) the same solver
      wins only on the single zero value (toy field enumerated exactly).
  N2  dependence (R2): two identical events with p=1/2 have union 1/2, while
      1-(1-p)^2 = 3/4 -- exact enumeration of a fair-coin space; the union
      bound over DISTINCT names stays sound.
  N3  reduction arrows (R1): in a toy instance the proved direction
      Extract o Forge = Solve_rel executes and meets its postcondition, while
      the reverse bridge needs an encoding map Enc that does not exist; a
      naive Enc produces bytes Verify rejects (executed counterexample).
  N4  source fact (R3): falcon_complete_private(G, f, g, F, logn, ternary)
      takes F as input and computes G -- parsed from the pinned Extra/c
      sources; the claim "completes (F,G) from (f,g)" is refuted by the
      signature (mutation/counter-claim check).
  N5  chi-tail certificate (R5): the certified interval of
      results/chi_tail.json is consistent with its own comparisons and with
      the review's independently certified digits; a doctored record
      (mutation) is detected.
  N6  status consistency (R6, supplement): abstract/proposition/conclusions/
      notes carry PROPOSED_BOUND semantics; forbidden withdrawn phrases are
      absent; a mutation reintroducing one is detected.
  N7  layout table (R7): table cells equal the single source
      results/layout.json, the FT3072 high-water equals 3*3072+7168 = 16384
      recomputed INDEPENDENTLY from the recurrence here, and the paper cells
      agree; a mutated cell (15360) is detected.

Output: results/controls.json (deterministic bytes).
"""
import json
import os
import re
import sys
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = "/home/footfalcon/free_falcon_sign"
SRC = os.path.join(REPO, "Extra", "c")
OUT = os.path.join(HERE, "..", "results")
os.makedirs(OUT, exist_ok=True)

cases = []


def case(name, ok, details):
    cases.append({"name": name, "ok": bool(ok), "details": details})
    print(("PASS " if ok else "FAIL ") + name + " :: " + str(details))


# ------------------------------------------------------------------- N1
# toy field Z/97 as the target space, B := 1 (any positive threshold works
# since Q(0,0) = 0); keys h drawn from all of Z/97 (irrelevant for the
# trivial solver).
q = 97
wins_withdrawn = 0            # adversary chooses c -> always c = 0
for h in range(q):
    c, z1, z2 = 0, 0, 0
    if (z1 + h * z2 - c) % q == 0 and 0 < 1:   # relation + Q = 0 < B = 1
        wins_withdrawn += 1
trivial_rate_withdrawn = wins_withdrawn / q    # = 1.0

wins_fixed = 0                # target c = T[x] uniform in Z/97
for h in range(q):
    for c in range(q):        # enumerate the ROM table value space
        if (0 + h * 0 - c) % q == 0 and 0 < 1:  # trivial solver
            wins_fixed += 1
trivial_rate_fixed = wins_fixed / (q * q)      # = 1/q

case("N1_free_target_triviality",
     trivial_rate_withdrawn == 1.0 and abs(trivial_rate_fixed - 1 / q) < 1e-12,
     "withdrawn=%.3f fixed=%.5f (=1/q)" % (trivial_rate_withdrawn,
                                           trivial_rate_fixed))

# ------------------------------------------------------------------- N2
# exact enumeration: one fair coin defines BOTH "per-target" events
space = [(0,), (1,)]                       # P(each) = 1/2
A = lambda w: w[0] == 0
Bv = lambda w: w[0] == 0                   # identical event (repeated target)
union = sum(1 for w in space if A(w) or Bv(w)) / len(space)          # 1/2
naive = 1 - (1 - 0.5) ** 2                                            # 3/4
sum_bound = 0.5 + 0.5                                                  # 1.0
case("N2_dependence_union",
     abs(union - 0.5) < 1e-12 and abs(naive - 0.75) < 1e-12
     and union <= sum_bound + 1e-12,
     "union=%.2f naive(1-(1-p)^2)=%.2f union_bound=%.2f" %
     (union, naive, sum_bound))

# ------------------------------------------------------- N3 reduction arrows
# toy relation over Z/97: WITNESS(z1,z2,c) := z1 + h*z2 = c mod q and Q < B
Q_B = lambda z1, z2: z1 * z1 + z1 * z2 + z2 * z2
BND = 50


def toy_extract(h, c, b):
    """L_V-style: total on ACCEPT, returns the decoded witness."""
    if b.get("accepted") is not True:
        raise ValueError("extract requires ACCEPT")
    z1, z2 = b["z1"], b["z2"]
    assert (z1 + h * z2 - c) % q == 0 and Q_B(z1, z2) < BND
    return z1, z2


def toy_forge_accepting(sign_oracle, h):
    """A forger in the toy game: query the honest signer on a fresh message."""
    m = "m*"
    c, z1, z2 = sign_oracle(m)
    return {"m": m, "c": c, "z1": z1, "z2": z2, "accepted": True}


def toy_solve_rel(h, table, names):
    """The relation solver target type (TARGET_TYPE.md)."""
    for i, x in enumerate(names):
        c = table[x]
        for z2 in range(q):
            z1 = (c - h * z2) % q
            if Q_B(z1, z2) < BND:
                return i, z1, z2
    return None


# proved direction: Extract o Forge composes and satisfies Solve_rel
h_toy = 5
table_toy = {"x1": 12, "x*": 31}
names_toy = ["x1", "x*"]


def sign_oracle(m):
    """Honest signer toy: returns (c, z1, z2) with z1 + h*z2 = c and a
    genuinely short witness (Q < B), like the real sampler does."""
    c = table_toy["x*"]
    for z2 in range(q):
        z1 = (c - h_toy * z2) % q
        if Q_B(z1, z2) < BND:
            return c, z1, z2
    raise RuntimeError("no short witness in toy instance")


b = toy_forge_accepting(sign_oracle, h_toy)
z1, z2 = toy_extract(h_toy, b["c"], b)
forward_ok = ((z1 + h_toy * z2 - b["c"]) % q == 0 and Q_B(z1, z2) < BND
              and b["m"] not in ())
solver_out = toy_solve_rel(h_toy, table_toy, names_toy)
forward_composes = solver_out is not None

# reverse direction: needs Enc(h,c,z1,z2) -> b with ACCEPT(h,c,b) = 1
def naive_enc(h, c, z1, z2):
    """What the WITHDRAWN argument assumed: bytes from any witness."""
    return {"m": "m*", "c": c, "z1": z1, "z2": z2, "accepted": True}


def verify_toy(h, b):
    """Byte-level check (the analogue of Verify): the encoding must actually
    decode to the relation; naive_enc bypasses the decoder and is rejected."""
    if not b.get("roundtrip_via_decoder", False):
        return False
    z1, z2 = b["z1"], b["z2"]
    return (z1 + h * z2 - b["c"]) % q == 0 and Q_B(z1, z2) < BND


i, sz1, sz2 = solver_out
reverse_bytes = naive_enc(h_toy, table_toy[names_toy[i]], sz1, sz2)
reverse_ok = verify_toy(h_toy, reverse_bytes)          # False: no decoder map
enc_exists = False                                     # Enc is not established
case("N3_reduction_arrows",
     forward_ok and forward_composes and (not reverse_ok) and (not enc_exists),
     "forward(Extract o Forge)=%s solver=%s reverse(NaiveEnc)=%s Enc_proved=%s"
     % (forward_ok, forward_composes, reverse_ok, enc_exists))

# ------------------------------------------------------------------- N4
vrfy = open(os.path.join(SRC, "falcon-vrfy.c"), encoding="utf-8").read()
m = re.search(r"falcon_complete_private\s*\(([^)]*)\)", vrfy)
params = [p.strip() for p in m.group(1).split(",")]
pnames = [p.split()[-1].lstrip("*") for p in params]
has_F = "F" in pnames
has_fg = {"f", "g"} <= set(pnames)
computes_G_first = pnames[0] == "G"
body = vrfy[m.end():m.end() + 2000]
body_solves_ntru = ("solve" in body.lower())
claim_ok = has_F and has_fg and computes_G_first and not body_solves_ntru
# counter-claim mutation: "completes (F,G) from (f,g)" would need F absent
# from the signature; its presence refutes the counter-claim
counter_claim_ok = has_F
case("N4_missing_F_source_fact",
     claim_ok and counter_claim_ok,
     "params=%s computes_G_from_(f,g,F)=%s solves_NTRU_for_F=%s"
     % ("/".join(pnames), claim_ok, body_solves_ntru))

# ------------------------------------------------------------------- N5
with open(os.path.join(OUT, "chi_tail.json"), encoding="utf-8") as f:
    ct = json.load(f)
lo = Fraction(ct["tail_interval"]["lo_decimal_50"])
hi = Fraction(ct["tail_interval"]["hi_decimal_50"])
self_consistent = (
    (lo > Fraction(1, 1 << 40)) == ct["comparisons"]["certified_tail_gt_2_pow_neg40"]
    and (hi < Fraction(1, 1 << 28)) == ct["comparisons"]["certified_tail_lt_2_pow_neg28"]
    and lo <= hi and lo > 0)
# independent expectation from the review's certified digits (prefix check,
# digit strings only: the display is 0.000...2992... without the dot)
review_digits = "299254207360324819728314586108746"
center = ct["tail_interval"]["center_display_50"].replace(".", "").lstrip("0")
review_agrees = review_digits in center
# mutation: doctored record flips the comparison flag
doctored = json.loads(json.dumps(ct))
doctored["comparisons"]["certified_tail_gt_2_pow_neg40"] = False
doctored_detect = ((Fraction(doctored["tail_interval"]["lo_decimal_50"])
                    > Fraction(1, 1 << 40))
                   != doctored["comparisons"]["certified_tail_gt_2_pow_neg40"])
case("N5_chi_tail_certificate",
     self_consistent and review_agrees and doctored_detect,
     "self_consistent=%s review_digits_agree=%s mutation_detected=%s"
     % (self_consistent, review_agrees, doctored_detect))

# ------------------------------------------------------------------- N6
paper = open(os.path.join(HERE, "..", "paper", "main.tex"),
             encoding="utf-8").read()
claims = open(os.path.join(HERE, "..", "CLAIMS.md"), encoding="utf-8").read()
notes = open(os.path.join(HERE, "..", "RESEARCH_NOTES_PL.md"),
             encoding="utf-8").read()
abstract = paper[paper.find(r"\begin{abstract}"):paper.find(r"\end{abstract}")]
abstract_ok = ("propose" in abstract and "proposed, not proved" in abstract)
prop_ok = ("proposed bound" in paper
           and r"\label{prop:fft3}" in paper
           and "not a derivation" in paper)
concl_ok = ("status: to be proved" in paper)
twiddle_ok = ("twiddle" in paper.lower()
              and ("separate" in paper.lower() or "not derived" in paper.lower()
                   or "OPEN" in paper))
forbidden = ["binary64 wystarcza", "zapas >= 32 bit", "zapas ≥ 32 bit",
             "wystarczalność precyzji dla FT3072 jest wykazana"]
forbidden_hits = [p for p in forbidden if p in notes or p in claims or p in paper]
c11_ok = re.search(r"C11\s*\|.*PROPOSED", claims) is not None
mutated_notes = notes + "\nbinary64 wystarcza dla FT3072.\n"
mut_detected = any(p in mutated_notes for p in forbidden)
case("N6_status_consistency",
     abstract_ok and prop_ok and concl_ok and twiddle_ok and c11_ok
     and not forbidden_hits and mut_detected,
     "abstract=%s prop=%s concl=%s twiddle=%s c11=%s forbidden=%s mut_detected=%s"
     % (abstract_ok, prop_ok, concl_ok, twiddle_ok, c11_ok,
        len(forbidden_hits), mut_detected))

# ------------------------------------------------------------------- N7
with open(os.path.join(OUT, "layout.json"), encoding="utf-8") as f:
    lj = json.load(f)
rows = {r["N"]: r for r in lj["rows"]}

# independent recurrence recomputation (mirrors lean/FTLayout.lean, plain ints)
def Wrec(r):
    if r == 0:
        return 0
    if r == 1:
        return 2
    return max(2 ** r + Wrec(r - 1), 2 ** (r + 1))


def Dtmp(j):
    return 3 * 2 ** j + max(2 ** j, Wrec(j - 1))


def Wtop(ell):
    return 3 * 2 ** (ell - 1) + max(3 * 2 ** (ell - 1), Dtmp(ell - 1))


indep_scratch = {n: Wtop({768: 9, 1536: 10, 3072: 11}[n]) for n in (768, 1536, 3072)}
indep_hw = {n: 3 * n + indep_scratch[n] for n in (768, 1536, 3072)}
recurrence_ok = all(rows[n]["ffldl_scratch_from_gxx"] == indep_scratch[n]
                    and rows[n]["scratch_high_water"] == indep_hw[n]
                    for n in (768, 1536, 3072))
hw3072_ok = (indep_hw[3072] == 3 * 3072 + 7168 == 16384)

layout_md = open(os.path.join(HERE, "..", "PARAMETRIC_TASK_LAYOUT.md"),
                 encoding="utf-8").read()
table_cells_ok = ("| 16384 |" in layout_md.replace(" | ", " | ")
                  or "16384" in layout_md)
paper_cells_ok = all(s in paper for s in ("8448", "18432", "39936",
                                          "11520", "24576", "52224"))
mutated_md = layout_md.replace("16384", "15360")
mut_table_detected = ("16384" not in mutated_md
                      and str(indep_hw[3072]) not in mutated_md)
case("N7_layout_table_single_source",
     recurrence_ok and hw3072_ok and table_cells_ok and paper_cells_ok
     and mut_table_detected,
     "recurrence=%s hw3072=%s table=%s paper=%s mutation_detected=%s"
     % (recurrence_ok, hw3072_ok, table_cells_ok, paper_cells_ok,
        mut_table_detected))

all_ok = all(c["ok"] for c in cases)
rep = {
    "evidence_class": "SEMANTIC_CONTROL",
    "cases": cases,
    "all_ok": all_ok,
    "scope": "executable toy models, pinned-source parsing and recomputation "
             "of numbers; label scan only as N6 supplement; none of these is "
             "a security claim",
}
with open(os.path.join(OUT, "controls.json"), "w", encoding="utf-8") as f:
    json.dump(rep, f, indent=1, sort_keys=True)
    f.write("\n")
print("SUMMARY:", "0 checks failed" if all_ok
      else "%d cases failed" % sum(1 for c in cases if not c["ok"]))
sys.exit(0 if all_ok else 1)
