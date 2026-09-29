# P01 — FAILED_ROUTES (zachowane nieudane trasy)

Każda trasa zachowana ze źródłem/logiem/błędem. Logi poprzedniego wykonawcy:
`run/logs/build_*.log`, `run/logs/build_certificate_*.log`,
`run/logs/build_source_binding_*.log`, `run/logs/acquire_mathlib.log`,
`checkout.failed-local-clone-001/`, `logs/cleanup_overlap_001.log`
(częściowo skopiowane do `failed_attempts/`). Błędy tej sesji — transkrypcja
komunikatów poniżej (dokładne ciągi diagnostyki Lean/Sage).

## Trasy poprzedniego wykonawcy (logi plikowe)

1. `build_001..build_010` (run/logs): kolejne błędy `decide`/`mod_cast` na
   `String`-owych wariantach checkera; wersje odrzucone zachowane.
2. `build_certificate_001/003/004`: `Decidable i.Certifies` bez instancji,
   `div_lt_iff` (bez subscript), `decide` nie redukował `instDecidableEqBool`;
   `sqrt2Witness_checked` nie przechodził — rozwiązane instancją
   `decidableCertifies` i redukcją przez ℤ.
3. `build_certificate_005`: `elan` self-update przez sieć — **sieć musi być
   wyłączona**; od tej pory build wyłącznie przez bezpośrednią ścieżkę
   toolchainu (`…/leanprover--lean4---v4.34.0/bin/lake`).
4. `checkout.failed-local-clone-001`: nieudany lokalny clone — zachowany.
5. Incydent overlapu dwóch wykonawców — `logs/cleanup_overlap_001.log`
   (zakończono obce joby, zweryfikowano 0 pozostałych procesów lake/lean).

## Trasy tej sesji (transkrypcje diagnostyk)

6. `Core.lean:29:27` — `Invalid field projection … m has type Memory`:
   `Region.legal` przed definicją `Memory` (kolejność po edycji). Naprawa:
   pełny przepis kolejności (Memory przed Region). **Nie** wyciszono.
7. `CExec.evalStmt_sound` (pierwszy kształt) — `Type mismatch … CExec
   (p.seq ?m) s (Outcome.fault r)` vs `evalStmt (p.seq q) s`: `rw [← hex]`
   nie przenosił hipotezy przez `match`. Naprawa: wersja przez
   `evalStmt_sound_gen` (równość na wynik) + `simp only [evalStmt, hex]`.
8. `decide` na `String.startsWith/endsWith/trim/drop/toNat?` — **nie
   redukują kernelowo** w tym Lean (a `String.trim/dropRight` zwracają tu
   `String.Slice`): „Tactic `decide` failed … reduction got stuck at
   match "goto 0;".startsWith "return "". Test redukcji: `run/tests/RedTest.lean`.
   Naprawa: `translateStmt` na `List Char` (redukowalne prymitywy).
9. `checker_sound` — `Invalid projection: … h has type checkSource src p =
   true which has no fields` (pozostałość `h.1` po edycji). Naprawa:
   `Bool.and_eq_true` + `of_decide_eq_true`.
10. `source17ReturnZero_translation` — `failed to synthesize Decidable
    (SourceTranslation …)`: `decide` nie widzi Decidable przez definicję.
    Naprawa: `unfold SourceTranslation translateStmt; decide`.
11. `Probability.lean:56:4` — `failed to compile definition … depends on
    'PMF.pure', which is 'noncomputable'`. Naprawa: `noncomputable def`.
12. `Probability.directedChi2` — `if_neg` deprecated („Use `ite_eq_right`
    instead") oraz `open … in` po docstringu: „unexpected token 'open';
    expected 'lemma'". Naprawa: `open Classical` na poziomie namespace +
    `ite_eq_right`.
13. Suma `∑` z koercją `WithTop ℝ` pod znakiem — cel `∑ a, ↑(…) = 0` nie
    domykał `simp`; naprawa: jawne `((∑ … : ℝ) : WithTop ℝ)`.
14. `gen_sqrt2_certificate.sage` — `AttributeError: 'RealBall' object has no
    attribute 'is_nonnegative'` (API). Naprawa: porównania ball/RIF.
15. `digits_lowerNum FAILED [2,8,2,8,4,2,7,1,2,4,7,4,6,1,9]` — **QQ redukuje
    ułamek przez GCD=5**, a checker/transport pracują na surowych ℤ
    (1414213562373095/10^15). Naprawa: surowe literały ℤ zamiast
    `QQ.numerator()`. Znalezisko istotne dla wierności transportu.
16. `TypeError: Object of type Integer is not JSON serializable` — preparser
    Sage zamienia literały w `Integer`; naprawa: `int(256)`.
17. **Certyfikaty lądowały w `tmp/output/`** — `__file__` w preparsowanym
    `.sage` wskazuje `W/tmp/sage_*/…sage.py`, więc `W` liczone z `__file__`
    było przesunięte o dwa poziomy; oba skrypty miały ten sam błąd i wzajemnie
    się akceptowały (mylący PASS). Naprawa: stała ścieżka W z TASK; replay
    po naprawie regeneruje certyfikaty w `output/CERTIFICATES/` (21/21 i 9/9).

## Luźne boundy / brakujące typy (jawne)

- `ball_finite_radius` sprawdza `rad < 2^-200`, obserwowany promień ≈ 2^-255
  przy precyzji 256 bitów — bound świadomy luźny, nie zacieśniany.
- Brakujący typ (nie pominięty): translacja fragmentów source17 bogatych w
  operatory (np. `fpr_ursh`) — obowiązek dalszych zadań (NEXT_INTERFACE.md).

## Uwagi recenzenta do v1 (naprawione w v2)

18. v1 `REPLAY.md` kierował na `replay_driver.py`, który **kasował i
    odtwarzał produkty w W autora** zamiast odtwarzać pakiet w nowym DEST
    recenzenta; sterownik, `lakefile.toml`, `lake-manifest.json`,
    `lean-toolchain` i `REPLAY_RESULT.json` były poza frozen manifestami;
    snapshot obejmował `Debug.lean`/`RedTest.lean` nieobecne w output.
    Naprawy v2: `tools/restore_replay.py` odtwarza do wymaganego świeżego
    DEST (nic nie kasuje w W autora; brama czystości `find -newer` = 0
    zapisów, replay B potwierdza); configi/receipt/logi replayu w pakiecie
    i w OUTPUTS.sha256; `Debug.lean`/`RedTest.lean` przeniesione do `aux/`
    z opisanymi rolami (aux/README.md) i obecne w pakiecie/snapshocie.
