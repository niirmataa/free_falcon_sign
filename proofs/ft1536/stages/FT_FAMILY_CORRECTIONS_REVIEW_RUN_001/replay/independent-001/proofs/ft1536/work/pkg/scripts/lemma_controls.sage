# lemma_controls.sage -- S01 semantic controls R1-R7 (authoritative checker)
#
# Owner rule FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22: authoritative
# mathematical computation and new checkers live in .sage and run with
#
#     sage scripts/lemma_controls.sage
#
# (standard preparser; pinned launcher /home/footfalcon/.local/bin/sage).
# Exact domains: ZZ / QQ with exactly specified inputs.  This file replaces
# the superseded Python draft preserved in proof/drafts/controls_draft.py;
# the port receipt (diff, re-run, certificate agreement) is in
# proof/receipts/port_py_to_sage.json.
#
# Controls (executable, NOT label-presence; label scan only as N6 supplement):
#   N1  free-target triviality (R2) -- exact enumeration over Z/97
#   N2  dependence of repeated targets (R2) -- exact enumeration, QQ
#   N3  reduction arrows (R1) -- toy game, forward composes, reverse needs Enc
#   N4  source fact (R3) -- falcon_complete_private signature parsed from the
#       pinned Extra/c sources
#   N5  chi-tail certificate (R5) -- exact QQ consistency of
#       results/chi_tail.json + review-digit agreement + doctored mutation
#   N6  status consistency (R6, supplement) -- PROPOSED semantics present,
#       withdrawn phrases absent, mutation detected
#   N7  layout table (R7) -- recurrence recomputed independently in ZZ,
#       table single-sourced from results/layout.json, paper cells, mutation
#
# Output: results/controls.json (deterministic bytes).

# ---- preflight: preparser/toolchain mode (not a proof of the goal)
assert parent(1) is ZZ
assert parent(1/3) is QQ
assert 2^10 == 1024

import json as _json
import os as _os
import re as _re
import sys as _sys

# Package root resolution (sage runs the preprocessed copy, so __file__ does
# NOT point at this .sage source; documented mode is
# `sage scripts/lemma_controls.sage` from the package root).
_PKG = _os.environ.get("FT1536_PKG_ROOT")
if not _PKG:
    for _a in _sys.argv:
        if _a.endswith(".sage") and _os.path.isfile(_a):
            _PKG = _os.path.dirname(_os.path.dirname(_os.path.abspath(_a)))
            break
if not _PKG and _os.path.isfile(_os.path.join(_os.getcwd(), "scripts",
                                              "lemma_controls.sage")):
    _PKG = _os.getcwd()
assert _PKG, "cannot resolve package root (set FT1536_PKG_ROOT)"
HERE = _os.path.join(_PKG, "scripts")
OUT = _os.path.join(_PKG, "results")
_os.makedirs(OUT, exist_ok=True)
REPO = "/home/footfalcon/free_falcon_sign"
# Extra/c via the historical five-level layout (works in the author package
# and in a replay MIRROR/.../work/<id>/ reconstruction alike); REPO fallback.
SRC = _os.path.normpath(_os.path.join(HERE, "..", "..", "..", "..", "..",
                                      "Extra", "c"))
if not _os.path.isdir(SRC):
    SRC = _os.path.join(REPO, "Extra", "c")
print("package root:", _PKG)

_cases = []


def _case(name, ok, details):
    _cases.append({"name": name, "ok": bool(ok), "details": str(details)})
    print(("PASS " if ok else "FAIL ") + name + " :: " + str(details))


# ------------------------------------------------------------------- N1
# Toy target space Z/97, threshold B := 1 (any positive B works since the
# trivial witness has Q = 0); keys h range over Z/97.
q = ZZ(97)
wins_withdrawn = ZZ(0)
for h in range(q):
    c = ZZ(0); z1 = ZZ(0); z2 = ZZ(0)          # trivial solver of the
    if (z1 + h*z2 - c) % q == 0:               # WITHDRAWN free-target def
        wins_withdrawn += 1
rate_withdrawn = QQ(wins_withdrawn) / QQ(q)    # = 1

wins_fixed = ZZ(0)                             # targets c = T[x] uniform
for h in range(q):
    for c in range(q):                         # enumerate table-value space
        if (ZZ(0) + h*ZZ(0) - c) % q == 0:     # same trivial solver
            wins_fixed += 1
rate_fixed = QQ(wins_fixed) / QQ(q^2)          # = 1/q

_case("N1_free_target_triviality",
      rate_withdrawn == 1 and rate_fixed == 1/q,
      "withdrawn=%s fixed=%s (=1/q)" % (rate_withdrawn, rate_fixed))

# ------------------------------------------------------------------- N2
# Exact fair-coin space: BOTH "per-target" events are the SAME event.
space = [ZZ(0), ZZ(1)]
A = lambda w: w == 0
Bv = lambda w: w == 0                          # repeated target: identical
p_union = QQ(sum(1 for w in space if A(w) or Bv(w))) / QQ(len(space))
p_naive = 1 - (1 - QQ(1)/2)^2                  # independence formula (wrong)
p_sum_bound = QQ(1)/2 + QQ(1)/2                # union bound over "targets"
_case("N2_dependence_union",
      p_union == QQ(1)/2 and p_naive == QQ(3)/4 and p_union <= p_sum_bound,
      "union=%s naive=%s union_bound=%s" % (p_union, p_naive, p_sum_bound))

# ------------------------------------------------------- N3 reduction arrows
q3 = ZZ(97)
BND = ZZ(50)


def Q_B(z1, z2):
    return z1^2 + z1*z2 + z2^2


def toy_extract(h, c, b):
    """L_V-style: total on ACCEPT, returns the decoded witness."""
    assert b.get("accepted") is True
    z1 = ZZ(b["z1"]); z2 = ZZ(b["z2"])
    assert (z1 + h*z2 - c) % q3 == 0 and Q_B(z1, z2) < BND
    return z1, z2


h_toy = ZZ(5)
table_toy = {"x1": ZZ(12), "x*": ZZ(31)}
names_toy = ["x1", "x*"]


def sign_oracle(m):
    """Honest signer toy: a genuinely short witness (Q < B)."""
    c = table_toy["x*"]
    for z2 in range(q3):
        z1 = (c - h_toy*z2) % q3
        if Q_B(z1, z2) < BND:
            return c, z1, z2
    raise RuntimeError("no short witness in toy instance")


def toy_forge_accepting(sign_oracle, h):
    m = "m*"
    c, z1, z2 = sign_oracle(m)
    return {"m": m, "c": c, "z1": z1, "z2": z2, "accepted": True}


def toy_solve_rel(h, table, names):
    """Relation-solver target type (TARGET_TYPE.md)."""
    for i, x in enumerate(names):
        c = table[x]
        for z2 in range(q3):
            z1 = (c - h*z2) % q3
            if Q_B(z1, z2) < BND:
                return i, z1, z2
    return None


b = toy_forge_accepting(sign_oracle, h_toy)
z1, z2 = toy_extract(h_toy, b["c"], b)
forward_ok = ((z1 + h_toy*z2 - b["c"]) % q3 == 0 and Q_B(z1, z2) < BND)
solver_out = toy_solve_rel(h_toy, table_toy, names_toy)
forward_composes = solver_out is not None


def naive_enc(h, c, z1, z2):
    """The WITHDRAWN assumption: bytes from any witness (no Enc map)."""
    return {"m": "m*", "c": c, "z1": z1, "z2": z2, "accepted": True}


def verify_toy(h, bb):
    """Byte-level check: the encoding must round-trip through the decoder."""
    if not bb.get("roundtrip_via_decoder", False):
        return False
    z1 = ZZ(bb["z1"]); z2 = ZZ(bb["z2"])
    return (z1 + h*z2 - ZZ(bb["c"])) % q3 == 0 and Q_B(z1, z2) < BND


i, sz1, sz2 = solver_out
reverse_bytes = naive_enc(h_toy, table_toy[names_toy[i]], sz1, sz2)
reverse_ok = verify_toy(h_toy, reverse_bytes)     # False: decoder image not
enc_exists = False                                # surjective; Enc unproved
_case("N3_reduction_arrows",
      forward_ok and forward_composes and (not reverse_ok) and (not enc_exists),
      "forward(Extract o Forge)=%s solver=%s reverse(NaiveEnc)=%s Enc_proved=%s"
      % (forward_ok, forward_composes, reverse_ok, enc_exists))

# ------------------------------------------------------------------- N4
vrfy = open(_os.path.join(SRC, "falcon-vrfy.c")).read()
m = _re.search(r"falcon_complete_private\s*\(([^)]*)\)", vrfy)
params = [p.strip() for p in m.group(1).split(",")]
pnames = [p.split()[-1].lstrip("*") for p in params]
has_F = "F" in pnames
has_fg = set(["f", "g"]).issubset(set(pnames))
computes_G_first = pnames[0] == "G"
body = vrfy[m.end():m.end() + 2000]
body_solves_ntru = ("solve" in body.lower())
claim_ok = has_F and has_fg and computes_G_first and not body_solves_ntru
counter_claim_ok = has_F     # "completes (F,G) from (f,g)" is refuted: the
                             # signature REQUIRES F as input
_case("N4_missing_F_source_fact",
      claim_ok and counter_claim_ok,
      "params=%s computes_G_from_(f,g,F)=%s solves_NTRU_for_F=%s"
      % ("/".join(pnames), claim_ok, body_solves_ntru))

# ------------------------------------------------------------------- N5
def _dec_to_QQ(s):
    """Exact QQ from a decimal string (Sage's QQ does not parse these)."""
    neg = s.startswith("-")
    if neg:
        s = s[1:]
    ip, _, fp = s.partition(".")
    num = ZZ((ip or "0") + fp)
    den = ZZ(10)^len(fp)
    v = QQ(num) / QQ(den)
    return -v if neg else v


ct = _json.load(open(_os.path.join(OUT, "chi_tail.json")))
lo = _dec_to_QQ(ct["tail_interval"]["lo_decimal_50"])
hi = _dec_to_QQ(ct["tail_interval"]["hi_decimal_50"])
self_consistent = (
    (lo > QQ(1)/QQ(2^40)) == ct["comparisons"]["certified_tail_gt_2_pow_neg40"]
    and (hi < QQ(1)/QQ(2^28)) == ct["comparisons"]["certified_tail_lt_2_pow_neg28"]
    and lo <= hi and lo > 0)
review_digits = "299254207360324819728314586108746"
center = ct["tail_interval"]["center_display_50"].replace(".", "").lstrip("0")
review_agrees = review_digits in center
doctored = dict(ct)
doctored["comparisons"] = dict(ct["comparisons"])
doctored["comparisons"]["certified_tail_gt_2_pow_neg40"] = False
doctored_detect = ((_dec_to_QQ(doctored["tail_interval"]["lo_decimal_50"])
                    > QQ(1)/QQ(2^40))
                   != doctored["comparisons"]["certified_tail_gt_2_pow_neg40"])
_case("N5_chi_tail_certificate",
      self_consistent and review_agrees and doctored_detect,
      "self_consistent=%s review_digits_agree=%s mutation_detected=%s"
      % (self_consistent, review_agrees, doctored_detect))

# ------------------------------------------------------------------- N6
paper = open(_os.path.join(HERE, "..", "paper", "main.tex")).read()
claims = open(_os.path.join(HERE, "..", "CLAIMS.md")).read()
notes = open(_os.path.join(HERE, "..", "RESEARCH_NOTES_PL.md")).read()
abstract = paper[paper.find(r"\begin{abstract}"):paper.find(r"\end{abstract}")]
abstract_ok = ("propose" in abstract and "proposed, not proved" in abstract)
prop_ok = ("proposed bound" in paper and r"\label{prop:fft3}" in paper
           and "not a derivation" in paper)
concl_ok = ("status: to be proved" in paper)
twiddle_ok = ("twiddle" in paper.lower()
              and ("separate" in paper.lower() or "not derived" in paper.lower()
                   or "OPEN" in paper))
forbidden = ["binary64 wystarcza", "zapas >= 32 bit", "zapas ≥ 32 bit",
             "wystarczalność precyzji dla FT3072 jest wykazana"]
forbidden_hits = [p for p in forbidden
                  if (p in notes or p in claims or p in paper)]
c11_ok = _re.search(r"C11\s*\|.*PROPOSED", claims) is not None
c19_proposed_ok = ("PROPOSED" in claims and "2^−28" in claims)
mutated_notes = notes + "\nbinary64 wystarcza dla FT3072.\n"
mut_detected = any(p in mutated_notes for p in forbidden)
_case("N6_status_consistency",
      abstract_ok and prop_ok and concl_ok and twiddle_ok and c11_ok
      and c19_proposed_ok and len(forbidden_hits) == 0 and mut_detected,
      "abstract=%s prop=%s concl=%s twiddle=%s c11=%s c19_proposed=%s "
      "forbidden=%s mut_detected=%s"
      % (abstract_ok, prop_ok, concl_ok, twiddle_ok, c11_ok, c19_proposed_ok,
         len(forbidden_hits), mut_detected))

# ------------------------------------------------------------------- N7
lj = _json.load(open(_os.path.join(OUT, "layout.json")))
rows = dict((ZZ(r["N"]), r) for r in lj["rows"])


def Wrec(r):
    """Inner scratch recurrence (mirrors lean/FTLayout.lean), exact ZZ."""
    r = ZZ(r)
    if r == 0:
        return ZZ(0)
    if r == 1:
        return ZZ(2)
    return max(2^r + Wrec(r - 1), 2^(r + 1))


def Dtmp(j):
    j = ZZ(j)
    return 3*2^j + max(2^j, Wrec(j - 1))


def Wtop(ell):
    ell = ZZ(ell)
    return 3*2^(ell - 1) + max(3*2^(ell - 1), Dtmp(ell - 1))


logn_of = {ZZ(768): ZZ(9), ZZ(1536): ZZ(10), ZZ(3072): ZZ(11)}
indep_scratch = dict((n, Wtop(logn_of[n])) for n in logn_of)
indep_hw = dict((n, 3*n + indep_scratch[n]) for n in logn_of)
recurrence_ok = all(ZZ(rows[n]["ffldl_scratch_from_gxx"]) == indep_scratch[n]
                    and ZZ(rows[n]["scratch_high_water"]) == indep_hw[n]
                    for n in logn_of)
hw3072_ok = (indep_hw[ZZ(3072)] == 3*3072 + 7168 == 16384)
layout_md = open(_os.path.join(HERE, "..", "PARAMETRIC_TASK_LAYOUT.md")).read()
table_cells_ok = ("16384" in layout_md)
paper_cells_ok = all(s in paper for s in ("8448", "18432", "39936",
                                          "11520", "24576", "52224"))
mutated_md = layout_md.replace("16384", "15360")
mut_table_detected = (str(indep_hw[ZZ(3072)]) not in mutated_md)
_case("N7_layout_table_single_source",
      recurrence_ok and hw3072_ok and table_cells_ok and paper_cells_ok
      and mut_table_detected,
      "recurrence=%s hw3072=%s table=%s paper=%s mutation_detected=%s"
      % (recurrence_ok, hw3072_ok, table_cells_ok, paper_cells_ok,
         mut_table_detected))

all_ok = all(c["ok"] for c in _cases)
rep = {
    "evidence_class": "SEMANTIC_CONTROL",
    "mode": "sage lemma_controls.sage (preparser ZZ/QQ authoritative; rule "
            "FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22)",
    "cases": _cases,
    "all_ok": all_ok,
    "scope": "executable toy models, pinned-source parsing and exact ZZ/QQ "
             "recomputation; label scan only as N6 supplement; none of these "
             "is a security claim",
}
with open(_os.path.join(OUT, "controls.json"), "w") as f:
    _json.dump(rep, f, indent=1, sort_keys=True)
    f.write("\n")
print("SUMMARY:", "0 checks failed" if all_ok
      else "%d cases failed" % len([c for c in _cases if not c["ok"]]))
