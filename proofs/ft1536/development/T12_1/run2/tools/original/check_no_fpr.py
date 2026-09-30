#!/usr/bin/env python3
"""check_no_fpr.py — maszynowa kontrola braku `fpr_` w regionie NTT.

Sprawdza w przypiętym wejściu M0 (inputs/m0_source/falcon-keygen.c):
  (1) CAŁY region modp (linie 2472–3317) nie zawiera podciągu `fpr_`;
  (2) kawałki kernelowe (2477+88, 2561+88, ..., 3233+83, z 4-liniowym
      nachodzeniem) pokrywają cały region bez luk — globalność tez
      chunk*_fpr_free z FftBind/NttSemantics.lean;
  (3) linie graniczne regionu (zgodność z pinami NttSemantics).
Awaria = exit 1 (stop-and-report).
"""
import hashlib, pathlib, sys

T = pathlib.Path("/home/footfalcon/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/C_TASK_1_BINBIND")
SRC = T / "inputs/m0_source/falcon-keygen.c"
KEYGEN_SHA = "0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf"

CHUNKS = [(2477, 88), (2561, 88), (2645, 88), (2729, 88), (2813, 88),
          (2897, 88), (2981, 88), (3065, 88), (3149, 88), (3233, 83)]
REGION = (2472, 3317)

def main() -> int:
    failures = []
    data = SRC.read_bytes()
    if hashlib.sha256(data).hexdigest() != KEYGEN_SHA:
        failures.append("SHA256 falcon-keygen.c != pin M0")
    lines = data.decode("utf-8").splitlines(keepends=True)
    # (1) cały region bez fpr_
    region = "".join(lines[REGION[0] - 1:REGION[1]])
    if "fpr_" in region:
        for i, ln in enumerate(lines[REGION[0] - 1:REGION[1]], REGION[0]):
            if "fpr_" in ln:
                failures.append(f"fpr_ w linii {i}: {ln!r}")
    # (3) linie graniczne
    if lines[3323].strip() != "zint_add(uint32_t *restrict a, const uint32_t *restrict b, size_t len)":
        failures.append(f"linia 3324 != glowa zint_add: {lines[3323]!r}")
    # (2) pokrycie kawałków bez luk (2477–3315); frędzle 2472–2476 i 3316–3317
    # to komentarze/puste linie sprawdzone tekstowo w (1) — jawny zakres hybrydy
    for (a, n), (b, _) in zip(CHUNKS, CHUNKS[1:]):
        end = a + n - 1
        if not (b <= end - 2):  # >=3-liniowe nachodzenie
            failures.append(f"luka/nachodzenie kawalkow {a}+{n} -> {b}")
    covered = set()
    for a, n in CHUNKS:
        covered.update(range(a, a + n))
    missing = [i for i in range(2477, 3316) if i not in covered]
    if missing:
        failures.append(f"linie 2477-3315 poza kawalkami: {missing[:10]} ...")
    fringe = [i for i in range(REGION[0], 2477)] + [i for i in range(3316, REGION[1] + 1)]
    for i in fringe:
        s = lines[i - 1].strip()
        if s and not (s.startswith("*") or s.startswith("/*") or s.startswith("*/")
                      or s.startswith("//")):
            failures.append(f"frędzel {i} nie jest komentarzem: {lines[i-1]!r}")
    if failures:
        print("CHECK_NO_FPR_FAIL")
        for f in failures:
            print(" -", f)
        return 1
    print(f"CHECK_NO_FPR_OK region={REGION[0]}-{REGION[1]} "
          f"chunks={len(CHUNKS)} bytes={len(region)} fpr_count=0")
    return 0

if __name__ == "__main__":
    sys.exit(main())
