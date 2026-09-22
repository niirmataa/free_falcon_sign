# PROVENANCE — piny kampanii

| element | pin | weryfikacja |
|---|---|---|
| build źródłowy | `Extra/c`, manifest 17 plików `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` | `extract_build_inputs.py` (17/17) + `build_binding.py` przy każdym starcie |
| stałe kampanii | `internal.h:163` B=2093922385; `falcon-sign.c:129` sigma=768; `falcon-sign.c:102` SIGN_MAX_ATTEMPTS=16; `falcon-keygen.c:93` TERNARY_KEYGEN_MAX_ATTEMPTS=3000000; `falcon-sign.c:148` MKN; `falcon-sign.c:1223` guard logn=10 | `inputs/family/build_inputs.json` (file:line + dosłowne linie + hashe plików) |
| estymator | lattice-estimator upstream `3e48ef421ec256afddb3e7d2249a77eab6e9ba12` (2026-06-27) | vendor `inputs/tools/vendor/lattice-estimator` = IMPORT_RECORD (63 pliki, tree `6704a6e6…`) + świeży clone `inputs/tools/upstream`, 25/25 plików `estimator/` bajtowo identycznych (`artifacts/vendor_verification.json`) |
| referencja Falcon | `falcon-specification.pdf`, `falcon-round3.zip`, `parameters.py` (dokładny członek ZIP) | piny skopiowane z S20-SEC-ESTIMATE-001-20260827-a1/inputs; skrypt modelu wymaga obecności literalnych współczynników w `parameters.py` i waliduje kotwice 936/952 |
| definicje problemów | `FT_FAMILY_SCALING_2026-09-22_RUN_002/ATTACK_PROBLEMS.md` (naprawa R1–R3), gry M0 `GAME.md` §3/§5, `TARGET_TYPE.md` | wymienione w nagłówkach artefaktów |
| poprzednia kampania (porównanie) | S20-SEC-ESTIMATE-001 (2026-08-27) na Sage 9.5 | cytowana w raporcie jako zewnętrzny punkt odniesienia; FT1536 1077/1082 odtworzone niezależnie |

Repo base przygotowania: lokalne `main` właściciela; kampania czyta wyłącznie
`Extra/c` i własne `inputs/`. Nic w repo poza katalogiem roboczym nie jest
modyfikowane.
