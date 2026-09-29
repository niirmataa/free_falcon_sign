# P01 — autorytatywny rachunek certyfikatu sqrt(2) — producer + self-check
# Uruchomienie: sage gen_sqrt2_certificate.sage  (preparser, ZZ/QQ, balls)
# Wyjście: CERTIFICATES/sqrt2_interval.json (cyfry dziesiętne pól) +
#          CERTIFICATES/sqrt2_interval.report.txt (ślad rachunku)

import json
import os

OUT = os.environ.get("FT1536_P01_OUT")
if not OUT:
    raise SystemExit("FT1536_P01_OUT not set (CERTIFICATES output dir of DEST)")
OUT = os.path.abspath(OUT)
os.makedirs(OUT, exist_ok=True)

checks = []
def check(name, cond, detail=""):
    checks.append((name, bool(cond), detail))
    if not cond:
        raise AssertionError("%s FAILED %s" % (name, detail))

# --- 0. Tryb rachunku: preparser Sage (ZZ/QQ/potęga) ---
assert parent(1) is ZZ, "preparser: literał całkowity musi być w ZZ"
assert parent(1 / 3) is QQ, "preparser: dzielenie musi dawać QQ"
assert 2^10 == 1024, "preparser: ^ musi być potęgą"
checks.append(("preparser_mode", True, "parent(1)=ZZ, parent(1/3)=QQ, 2^10=1024"))

# --- 1. Surowe pola certyfikatu (dziedzina ℤ; QQ redukuje ułamek przez GCD,
#     ale checker i transport pracują na surowych licznikach/mianownikach) ---
ld = ZZ(10)^15
ln = ZZ(1414213562373095)
ud = ZZ(10)^15
un = ZZ(1414213562373096)
lower = QQ(ln) / QQ(ld)   # 1.414213562373095
upper = QQ(un) / QQ(ud)   # 1.414213562373096

# --- 2. Dokładne warunki certyfikatu w ZZ (jak checkSqrt2 w Lean) ---

check("pos_lowerNum", 0 < ln, "%s" % ln)
check("pos_lowerDen", 0 < ld, "%s" % ld)
check("pos_upperNum", 0 < un, "%s" % un)
check("pos_upperDen", 0 < ud, "%s" % ud)
check("lower_sq_lt", ln * ln < 2 * ld * ld,
      "%s^2=%s < 2*%s^2=%s" % (ln, ln * ln, ld, 2 * ld * ld))
check("upper_sq_gt", 2 * ud * ud < un * un,
      "2*%s^2=%s < %s^2=%s" % (ud, 2 * ud * ud, un, un * un))
check("endpoints_ordered", ln * ud < un * ld,
      "%s*%s=%s < %s*%s=%s" % (ln, ud, ln * ud, un, ld, un * ld))

# --- 3. Rygorystyczne oszacowanie RealBallField z jawnym outward enclosure ---
B = RealBallField(256)
b = B(2).sqrt()
lo_b, hi_b = B(lower), B(upper)
# Pierścienie b zawierają sqrt(2) z jawnym promieniem/remainder:
check("ball_finite_radius", b.rad() >= 0 and b.rad() < 2^(-200),
      "rad=%s prec=256" % b.rad())
check("ball_brackets", lo_b < b and b < hi_b, "pierścienie ball: lower < sqrt(2) < upper")
# Pewne oszacowanie przez RIF (outward rounding):
R = RealIntervalField(256)
iv = R(2).sqrt()
check("rif_lower", R(lower) < iv, "RIF: lower < sqrt(2)")
check("rif_upper", iv < R(upper), "RIF: sqrt(2) < upper")
check("rif_strict_gap", R(lower) < iv < R(upper), "otwarty przedział RIF")

# --- 4. Testy negatywne: wadliwe certyfikaty MUSZĄ być odrzucone ---
def certifies(n_ln, n_ld, n_un, n_ud):
    """Decyzyjny checker warunków ZZ (zwierciadło checkSqrt2)."""
    if not (ZZ(n_ln) > 0 and ZZ(n_ld) > 0 and ZZ(n_un) > 0 and ZZ(n_ud) > 0):
        return False
    ln2, ld2 = ZZ(n_ln) * ZZ(n_ln), ZZ(n_ld) * ZZ(n_ld)
    un2, ud2 = ZZ(n_un) * ZZ(n_un), ZZ(n_ud) * ZZ(n_ud)
    return (ln2 < 2 * ld2) and (2 * ud2 < un2) and (ZZ(n_ln) * ZZ(n_ud) < ZZ(n_un) * ZZ(n_ld))

check("neg_false_inequality", not certifies(3, 2, 3, 2), "3/2 udaje dolną granicę")
check("neg_reversed_endpoints", not certifies(3, 2, 7, 5), "odwrócone endpointy")
check("neg_missing_denominator", not certifies(1, 0, 3, 2), "brakujący mianownik")
check("pos_witness_accepted", certifies(ln, ld, un, ud), "prawdziwy witness")

# --- 5. Cyfry dziesiętne transportu (muszą zgadzać się z CertificateTransport.lean) ---
def digits_of(n):
    return [int(c) for c in str(int(n))]

check("digits_lowerNum", digits_of(ln) == [1,4,1,4,2,1,3,5,6,2,3,7,3,0,9,5], str(digits_of(ln)))
check("digits_lowerDen", digits_of(ld) == [1] + [0] * 15, str(digits_of(ld)))
check("digits_upperNum", digits_of(un) == [1,4,1,4,2,1,3,5,6,2,3,7,3,0,9,6], str(digits_of(un)))
check("digits_upperDen", digits_of(ud) == [1] + [0] * 15, str(digits_of(ud)))

cert = {
    "schema": "FT1536_P01_SQRT2_CERT_V1",
    "field_semantics": "exact rational interval lower < sqrt(2) < upper",
    "lowerNum_digits": digits_of(ln),
    "lowerDen_digits": digits_of(ld),
    "upperNum_digits": digits_of(un),
    "upperDen_digits": digits_of(ud),
    "lower": [int(ln), int(ld)],
    "upper": [int(un), int(ud)],
    "ball_precision_bits": int(256),
    "ball_radius": str(b.rad()),
    "checks": ["%s:%s:%s" % (n, "PASS" if ok else "FAIL", d) for (n, ok, d) in checks],
}

with open(os.path.join(OUT, "sqrt2_interval.json"), "w") as f:
    json.dump(cert, f, indent=1)
    f.write("\n")

with open(os.path.join(OUT, "sqrt2_interval.report.txt"), "w") as f:
    for (n, ok, d) in checks:
        f.write("%s %s %s\n" % ("PASS" if ok else "FAIL", n, d))

print("SQRT2_CERT_OK checks=%d" % len(checks))
