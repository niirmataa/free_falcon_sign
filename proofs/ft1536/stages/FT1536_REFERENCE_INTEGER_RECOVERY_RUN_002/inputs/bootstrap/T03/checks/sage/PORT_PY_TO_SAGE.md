# PORT_PY_TO_SAGE — przeniesienie własnego rachunku (diff, wykonanie, zgodność)

Zgodnie z FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md (kopia w
inputs/supplement/, SHA w INPUTS.sha256): autorytatywny rachunek przeniesiony
z `.py`/`fractions` do **`.sage` uruchamianych `sage lemma.sage`** (preparser
standardowy, real bounds przez RealIntervalField(256) z outward endpointem
i exact asercją bound² ≥ p w QQ; preflight preparsera w każdym pliku).

## Diff i wykonanie

- Nowe authoritative: checks/sage/{exact_ring_checks,skeleton_cancellation,
  gap_composition,rint_oracle}.sage (runy: logs/1x_sage_*.log; argv/SHA/exit:
  TOOLCHAIN.txt + COMMANDS.log + SAGE_RUNS w replay receipt).
- Semantyka literałów/dzielenia/^ rozliczona: `QQ(a,b)` (konstruktor ułamka
  z `Fraction`) nie działa w Sage (Z_to_Q._call_with_args) → `a / b` w ZZ/QQ;
  Sage Integer nie jest JSON-serializable → jawne `int()`; `^` → potęga przez
  preparser (preflight `2^10 == 1024`); Word/XOR/shift/modulo w slocie rint
  zachowane jawnie na ZZ (semantyka trymowanej reszty jak w modelu).
- Wersje `.py` zachowane w scripts/py_crosscheck/ + ich deterministycznie
  odtworzone certyfikaty w checks/py_crosscheck/py_*.json (silnik v3,
  OUTPUTS v3 sha daf45e8a… — manifest w checks/py_crosscheck/
  OUTPUTS_v3_superseded.sha256).

## Zgodność certyfikatów (checks/sage/PORT_PY_TO_SAGE.json)

- ring: all_core_pass zgodne; wszystkie mutacje identyczne ✓
- skeleton: wszystkie checks + mutacje identyczne; tabela z_map_full **bajtowo
  identyczna** ✓ (3072 wierszy)
- gap: werdykt zgodny (TOTAL ≈ 6086.4008, gap_met=false); wszystkie składniki
  zgodne w float (≤1e-9 rel.); 12/16 stringów exact różni się REPREZENTACją
  enclosure sqrt (py: skalowane isqrt; sage: RIF upper) — oba certified
  outward, oba zapisane w rekordzie
- rint ties: wspólne wartości identyczne (880 strict / 198 tie_even_ok / 0 fail
  / 0 recovery_fail / boundary ok); jedyna różnica to usunięty klucz
  zawsze-zerowy `tie_odd_case` (schema-only, zachowany w mismatches_kept)

## Zachowane mismatch/deviations

1. schema-only `tie_odd_case` (wyżej).
2. Różnice instancji losowych ring/skeleton (python MT vs sage LCG) — werdykty
   zgodne; nie jest to porównanie bajtowe instancji.
3. Deviation proceduralna: korekta nakazana przez właściciela regenerowała
   5 plików checks/*.json w miejscu (w tym 3 należące do freeze v3). Numery
   hashowe v3 odtwarzalne z OUTPUTS_v3_superseded.sha256 + py_crosscheck/py_*.
4. Zamrożone artifacts/fresh_replay.json (receipt v3) **nietknięte**; nowy
   receipt siedzi w artifacts/fresh_replay_sage.json (osobny suplement).
