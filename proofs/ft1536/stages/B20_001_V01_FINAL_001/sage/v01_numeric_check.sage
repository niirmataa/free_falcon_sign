# V01 — niezależna kontrola numeryczna P01 v2 (recenzent)
# Uruchomienie: sage v01_numeric_check.sage  (preparser, ZZ/QQ, balls/intervals)
# Zakres: witness sqrt2 z CertificateInput.lean vs JSON producenta,
# warunki ZZ jak checkSqrt2, RIF/balls, transport cyfr, kontrole negatywne
# oraz celowy kontrtest błędnej przesłanki.

import json
import os

W = "/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/V01"
PKG = os.path.join(W, "inputs/producer_v2")
JSON_PATH = os.path.join(PKG, "CERTIFICATES/sqrt2_interval.json")
OUT_DIR = os.path.join(W, "output")
os.makedirs(OUT_DIR, exist_ok=True)

checks = []
def check(name, cond, detail=""):
    checks.append((name, bool(cond), str(detail)))
    if not cond:
        raise AssertionError("%s FAILED %s" % (name, detail))

# 0. Tryb preparsera (wymóg protokołu)
assert parent(1) is ZZ, "preparser ZZ"
assert parent(1/3) is QQ, "preparser QQ"
assert 2^10 == 1024, "preparser ^"
checks.append(("preparser_mode", True, "ZZ/QQ/^ OK"))

# 1. Literały Lean (CertificateInput.lean) — twarde oczekiwanie recenzenta
lean_ln = ZZ(1414213562373095)
lean_ld = ZZ(10)^15
lean_un = ZZ(1414213562373096)
lean_ud = ZZ(10)^15

cert = json.load(open(JSON_PATH))
j_ln, j_ld = ZZ(cert["lower"][0]), ZZ(cert["lower"][1])
j_un, j_ud = ZZ(cert["upper"][0]), ZZ(cert["upper"][1])
check("json_matches_lean_literals", (j_ln, j_ld, j_un, j_ud) == (lean_ln, lean_ld, lean_un, lean_ud),
      "%s vs lean" % (str(cert["lower"]) + "/" + str(cert["upper"])))

# 2. Dokładne warunki ZZ (zwierciadło RationalInterval.Certifies / checkSqrt2)
def certifies(a_ln, a_ld, a_un, a_ud):
    if not (ZZ(a_ln) > 0 and ZZ(a_ld) > 0 and ZZ(a_un) > 0 and ZZ(a_ud) > 0):
        return False
    return (ZZ(a_ln)*ZZ(a_ln) < 2*ZZ(a_ld)*ZZ(a_ld)) and \
           (2*ZZ(a_ud)*ZZ(a_ud) < ZZ(a_un)*ZZ(a_un)) and \
           (ZZ(a_ln)*ZZ(a_ud) < ZZ(a_un)*ZZ(a_ld))

check("witness_pos", 0 < lean_ln and 0 < lean_ld and 0 < lean_un and 0 < lean_ud, "dodatnie")
check("witness_lower_sq", lean_ln*lean_ln < 2*lean_ld*lean_ld,
      "%s < %s" % (lean_ln*lean_ln, 2*lean_ld*lean_ld))
check("witness_upper_sq", 2*lean_ud*lean_ud < lean_un*lean_un,
      "%s < %s" % (2*lean_ud*lean_ud, lean_un*lean_un))
check("witness_ordered", lean_ln*lean_ud < lean_un*lean_ld, "lower<upper")
check("witness_accepted", certifies(lean_ln, lean_ld, lean_un, lean_ud), "checker akceptuje")

# 3. Rygorystyczne potwierdzenie (balls + intervals, outward)
B = RealBallField(256)
b = B(2).sqrt()
check("ball_radius_bound", b.rad() >= 0 and b.rad() < 2^(-200), "rad=%s" % b.rad())
lo_b, hi_b = B(QQ(lean_ln)/QQ(lean_ld)), B(QQ(lean_un)/QQ(lean_ud))
check("ball_brackets", lo_b < b and b < hi_b, "ball lower<sqrt2<upper")
R = RealIntervalField(256)
iv = R(2).sqrt()
check("rif_brackets", R(QQ(lean_ln)/QQ(lean_ld)) < iv < R(QQ(lean_un)/QQ(lean_ud)), "RIF potwierdza")

# 4. Transport cyfr (jak CertificateTransport.lean)
def digits_of(n):
    return [int(c) for c in str(int(n))]
check("digits_lowerNum", digits_of(lean_ln) == [1,4,1,4,2,1,3,5,6,2,3,7,3,0,9,5], str(digits_of(lean_ln)))
check("digits_lowerDen", digits_of(lean_ld) == [1]+[0]*15, str(digits_of(lean_ld)))
check("digits_upperNum", digits_of(lean_un) == [1,4,1,4,2,1,3,5,6,2,3,7,3,0,9,6], str(digits_of(lean_un)))
check("digits_upperDen", digits_of(lean_ud) == [1]+[0]*15, str(digits_of(lean_ud)))
check("digits_match_json", cert["lowerNum_digits"] == digits_of(lean_ln) and cert["upperNum_digits"] == digits_of(lean_un), "JSON cyfry zgodne")

# 5. Kontrole negatywne producenta (muszą być odrzucone)
check("neg_false_inequality", not certifies(3, 2, 3, 2), "3/2 jako dolna odrzucona")
check("neg_reversed", not certifies(3, 2, 7, 5), "odwrócone endpointy odrzucone")
check("neg_missing_den", not certifies(1, 0, 3, 2), "mianownik 0 odrzucony")

# 6. Celowy kontrtest recenzenta: błędna przesłanka nie może przejść
# 6a. Zdegenerowany przedział [witness_lower, witness_lower] (brak szerokości)
check("counter_degenerate_rejected", not certifies(lean_ln, lean_ld, lean_ln, lean_ld),
      "zdegenerowany przedział odrzucony")
# 6b. Dolna granica zawyżona o 2 ulp (1414213562373097/1e15 > sqrt2 => lower²<2d² zawodzi lub wymaga sprawdzenia)
# Nie zakładamy wyniku — sprawdzamy, że checker rozstrzyga zgodnie z arytmetyką ZZ:
up2 = ZZ(1414213562373097)
cond_up2 = (up2*up2 < 2*lean_ld*lean_ld)
check("counter_plus2ulp_decided", certifies(up2, lean_ld, lean_un+10, lean_ud) == (cond_up2 and True),
      "plus2ulp lower²<2d²=%s" % cond_up2)
# 6c. Fałszywy szeroki certyfikat [2/1, 3/1] (dolna powyżej sqrt2)
check("counter_wide_false_rejected", not certifies(2, 1, 3, 1), "[2,3] odrzucone")
# 6d. Ujemny licznik
check("counter_negative_rejected", not certifies(-1, 1, 3, 2), "ujemny licznik odrzucony")

print("V01_NUMERIC_OK checks=%d" % len(checks))
for (n, ok, d) in checks:
    print("%s %s %s" % ("PASS" if ok else "FAIL", n, d))

with open(os.path.join(OUT_DIR, "v01_numeric_report.txt"), "w") as f:
    for (n, ok, d) in checks:
        f.write("%s %s %s\n" % ("PASS" if ok else "FAIL", n, d))
