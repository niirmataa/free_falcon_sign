# P01 — niezależny checker certyfikatu (konsument JSON z producenta)
# Uruchomienie: sage check_certificate.sage  (preparser, ZZ/QQ, balls)
# Wymagane: akceptacja prawdziwego witnessa i ODRZUCENIE trzech wadliwych.

import json
import os

OUT = os.environ.get("FT1536_P01_OUT")
if not OUT:
    raise SystemExit("FT1536_P01_OUT not set (CERTIFICATES output dir of DEST)")
OUT = os.path.abspath(OUT)

assert parent(1) is ZZ
assert parent(1 / 3) is QQ
assert 2^10 == 1024

with open(os.path.join(OUT, "sqrt2_interval.json")) as f:
    cert = json.load(f)

ln = ZZ(cert["lower"][0]); ld = ZZ(cert["lower"][1])
un = ZZ(cert["upper"][0]); ud = ZZ(cert["upper"][1])

results = []
def check(name, cond, detail=""):
    results.append((name, bool(cond), detail))
    if not cond:
        raise AssertionError("%s FAILED %s" % (name, detail))

def certifies(n_ln, n_ld, n_un, n_ud):
    if not (ZZ(n_ln) > 0 and ZZ(n_ld) > 0 and ZZ(n_un) > 0 and ZZ(n_ud) > 0):
        return False
    ln2, ld2 = ZZ(n_ln) * ZZ(n_ln), ZZ(n_ld) * ZZ(n_ld)
    un2, ud2 = ZZ(n_un) * ZZ(n_un), ZZ(n_ud) * ZZ(n_ud)
    return (ln2 < 2 * ld2) and (2 * ud2 < un2) and (ZZ(n_ln) * ZZ(n_ud) < ZZ(n_un) * ZZ(n_ld))

# świadomy witness: akceptacja
check("accept_witness", certifies(ln, ld, un, ud), "%s/%s , %s/%s" % (ln, ld, un, ud))

# testy negatywne: odrzucenie (wymóg TASK §5)
check("reject_false_inequality", not certifies(3, 2, 3, 2), "3/2 < sqrt(2) jest fałszem")
check("reject_reversed_endpoints", not certifies(3, 2, 7, 5), "3/2 > 7/5 — odwrócone")
check("reject_missing_denominator", not certifies(1, 0, 3, 2), "mianownik 0")

# cyfry transportu zgodne z deklaracją pól
def digits_of(n):
    return [int(c) for c in str(int(n))]
check("digits_lowerNum", digits_of(ln) == cert["lowerNum_digits"])
check("digits_lowerDen", digits_of(ld) == cert["lowerDen_digits"])
check("digits_upperNum", digits_of(un) == cert["upperNum_digits"])
check("digits_upperDen", digits_of(ud) == cert["upperDen_digits"])

# rygorystyczne potwierdzenie przedziału (RIF, outward rounding)
R = RealIntervalField(256)
iv = R(2).sqrt()
check("rif_brackets_sqrt2", R(lower_q := QQ(ln) / QQ(ld)) < iv < R(QQ(un) / QQ(ud)),
      "RIF(256) potwierdza otwarty przedział")

with open(os.path.join(OUT, "check_certificate.report.txt"), "w") as f:
    for (n, ok, d) in results:
        f.write("%s %s %s\n" % ("PASS" if ok else "FAIL", n, d))

print("CERT_CHECK_OK checks=%d" % len(results))
