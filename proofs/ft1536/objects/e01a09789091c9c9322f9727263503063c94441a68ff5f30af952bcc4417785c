# REPORT — FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 (ROADMAP T03, one root)

Autor projektu: **Niirmata**. Falcon Project / Thomas Pornin attribution i
licencje zachowane. Data: 2026-09-22. Wykonawca: MiMo 2.6 Pro (jeden ręcznie
uruchomiony worker; bez subagentów/relay). Source pin 56974571…a0985,
BASE 1aed8ad, TASK SHA bbd1f59e…6169 — wszystkie piny zweryfikowane
(logs/01: exact set 1275/1275, 0 mismatch, brak symlinków/escapes).

## Rzeczywisty status

**PARTIAL_PROOF.** Niezależna exact-integer referencja v_ref = [c,0] − Z(Y)B,
jej mapping/integrality/congruence są wykazane dla całej required domeny;
uniform source error do tej referencji NIE osiąga 1/2 (bound ≈ 6086, dominanta
przez immutable stored basis words i δ-rekonstrukcję drzewa); lemma
rounding-gap (z tie/parity) wykazany w kernelu, jego zastosowanie warunkowe.
Statusu REFERENCE_INTEGER_RECOVERY_PROVED_FOR_EMITTED_PINNED_MODEL **nie ma** —
bez nowego gate'u, bez Safety premise, bez referencji zdefiniowanej source
outputem.

## A — algebra i source order: PROVED

- Niezależna definicja: v_ref = [c,0] − Z(Y)B, B=[[g,−f],[G,−F]], det = q;
  Z(Y) = signed permutation 3072 integer returns z literalnej kolejności
  (root prawy→lewy, cubic 2→1→0, binary prawy→lewy, terminal mu1→mu0')
  i konwencji merge (EXACT_SKELETON.md; tabela checks/z_map_full.json).
- Tożsamość anulowania: w exact skeleton (actual L jako fixed constants;
  recomputed products bitowo równe) residua = t − Z(Y) dokładnie — indukcja po
  drzewie, kernel per-slot (formal/SkeletonCancel.lean, 9 twierdzeń) + exact
  rationalne instancje pełnego kształtu (E1/E1/E2/E2 w checks).
- Integrality (Z[X]/Phi, oba wektory, wszystkie 1536+1536) i kongruencja
  v1 + h·v2 = c mod (q, Phi) z h tego samego klucza — CONGRUENCE.md; exact QQ/ring
  checks niezależne od FFT portu (C1–C5), mutacje relacji wykryte.

## B — błąd actual source do TEJ referencji: OPEN

Uniform outward composition (SOURCE_ERROR.md/.json, exact rationals):
**6086.4 per coefficient ≥ 1/2**. Dominanty: Z(Y)·(B'words−B) = 4489.9
(słowa sk błędy 2^-26/2^-15 × operandy do 2.02e10), δ-rekonstrukcja 1078.7
(skorelowana trasa trójkątna, crosscheck z pinned do 4 cyfr), εdet×|Ĉ/q| 332.5.
Zachowane trasy luźne: 887.0 / 1165.4 / 160471 / (cyt.) 3.681e9.
**Minimalny missing type + progi**: residualy stored words ≲ 3.3e-13/6.8e-10
(~2^-52 rel.), (δ, eroot) ≲ 3.3e-6/3.7e-5, ηt ≲ 3.2e-8 (z korelacyjnym
transportem 3072 defektów terminalnych — box splotowy wymaga więcej niż ciasny
Er). Brak witnessa przeciwnego: równość nieobalona, nieudowodniona.

## C — nearest-even recovery: lemma PROVED, zastosowanie WARUNKOWE

|t−v|<1/2 ⟹ w=v; equality 1/2 rozliczone parzystością (v parzyste ⟹ v;
nieparzyste ⟹ v+1), oba znaki i −0 (formal/RintGap.lean, 6 twierdzeń, czysty
log, tylko propext/Quot.sound). Kontrole: 1078 cases model-bitowy vs oryginał
Fraction + 3×20128 cases realnego fpr_rint (normal/ASan/UBSan, byte-identic,
preflight domeny ex≤1072) vs niezależny oryginał QQ — 0 mismatch. Oba vectory
objęte parową formą lemma; equality wide-rint = v_ref pozostaje otwarta tylko
z powodu B. Safe16/narrow16/stored norm rozdzielone; Safe16 nie wykazane
(brak = missing proof, nie atak).

## D — Verify consumer (warunkowy, bez nieuprawnionej kompozycji)

`recovery AND joint Safe16 ⟹ stored pair = v_ref ⟹ congruence dla stored pair`.
Pozostały typ do Sign→Verify: center/norm compatibility dla formy A2 z cross
terms — congruence i Q(s1,s2)<B **nie** pociągają Q(center_q(s1),s2)<B
(jawny lokalny kontrprzykład w COUNTERMODELS.md; monotonicity nie postulowana),
oraz B, Safe16, bytes. One-root recovery certificate eksportowany bez zmiany
statusów T01/T05/T06 (NEXT_INTERFACE/VERIFY_NEXT_INTERFACE). Brak whole-Sign,
real-PRNG, retry composition, security, M0 eta_pre (flagi w certyfikacie).

## Formalizacja

Lean 4.34.0 (toolchain pinned w TOOLCHAIN.txt), 2 moduły / **15 named theorems**:
formal/SkeletonCancel.lean (9: anulowania intercall/terminal/node/root) — granica
kernel: per-slot Int; formal/RintGap.lean (6: strict gap, tie parity ×2, nie-tie
dla nieparzystych, uniqość, para). Czyste stdout/stderr, bez sorry/admit/
native_decide/Lean.ofReduceBool/aksjomatu celu/supresji; aksjomaty tylko
[propext, Quot.sound]. Mixed boundary jawny (EXACT_SKELETON §6): placement/merge
i pierścienie — exact machine checks (checks/), nie kernel.

## Silnik rachunku (uzupełnienie zasady 2026-09-22)

Autorytatywny rachunek i checkery: **`.sage` uruchamiane `sage lemma.sage`**
(SageMath 10.9, preparser; exact ZZ/QQ; real bounds RealIntervalField(256)
z outward endpointem + exact asercją bound² ≥ p) wg
FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md (kopia + SHA w INPUTS).
Port z własnego `.py`/fractions: diff/wykonanie/zgodność certyfikatów w
checks/sage/PORT_PY_TO_SAGE.md/.json — pełne zgodności werdyktów, mutacji,
tabeli Z i kontroli tie; 12 stringów exact różni się wyłącznie reprezentacją
enclosure sqrt; każdy mismatch/odstępstwo zachowany (w tym regeneracja 5 plików
checks wobec freeze v3 i fakt, że receipt v3 pozostał nietknięty).

## Kontrole

- Exact ring/det/target/congruence (QQ/Z, niezależne od FFT portu): PASS;
  2 rodziny kluczy syntetycznych z niejedynkowym f (hf−g=q·k≠0).
- Recursion/split/merge mapping, paired order i signs: exact rational E1/E1b
  (K=3) + pełny kształt E2 (K=9, 3072 calls); bijekcja; mutacje: swapped order,
  wrong sign/basis, dropped cancellation, swapped terminal pair, wrong target
  sign, source output as reference (równoważna w exact skeleton — wykazana;
  wykryta z jitter rounding) — wszystkie wykryte; NOOP nietrafiony.
- Source slice fpr_rint (publiczny kod): normal (-O literalne), ASan, UBSan —
  byte-identic, czyste stderr, domain preflight przed native call; 60384 cases
  vs niezależny dokładny oryginał Fraction/QQ: 0 mismatch. Zakres fixtures:
  granice/tie ±(v+1/2), 32767.5, −32768.5, signed zero, 20000 deterministycznych
  słów o wykładniku 0..1072; brak kluczy/Emitted w fixtures (synthetic scope).
- Sampling/post/iFFT: nie przeliczane od nowa — zakotwiczone pinami
  (JOINT tapes 3147/6219 proposals, POST 32224-case rint suite, H6P/LEFT
  recurrences); mój odtworzony rint/rounding-gap coverage powyżej.
- Błędy/limity zachowane: FAILED_ROUTES.md, ERROR_LEDGER.md.

## Replay

Standard `python3 -B scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA`.
Semantic plan (SEMANTIC_FILES.json) ustalony przed rehearsal; 11 plików
przeliczanych od zera (checks JSON ×5, logi Lean ×2, out_*.txt ×3, oracle ×1).
Fresh (rehearsal, sealed): artifacts/fresh_replay.json — patrz REPLAY.md.
Replay po freeze: osobny DEST pod W/tmp, receipt tamże (REPLAY.md).

## Znaczenie i następny krok

Udało się: pierwszy niezależny, od source output oddzielony opis exactly tej
całkowitej pary, którą sampler „ma na myśli" — z maszynowo sprawdzonym mappingiem
wszystkich 3072 calls, dowiedzioną kongruencją (Verify-po-recovery staje się
formalnie dostępny) i kompletnym rounding-gap lemma z tie/parity.
Nie wyszło: uniformny bound zaokrągleń do < 1/2 — boxy na pinned constants dają
6086; to lużność oszacowań (fixture ~1e-12), nie błąd kodu i nie kontrprzykład.
Następny krok: T03-B fix — certyfikat residualów immutable sk FFT words ~2^-52
(rel.) + (δ, eroot) ≲ 4e-5 + transport ηt ≲ 3.2e-8 (SOURCE_ERROR §3); wtedy
C domyka się bez nowych pomysłów, a D czeka na Safe16 i center/norm lemma.

## Flaga/statusy

source_changed=false; production_source_changed=false;
new_source_patch_integrated=false; owner_accepted=false; new_M0_eta_pre=null.
Własne obliczenia zakończone; brak aktywnych jobów.
Nie uruchamiano Astry, dudect, relay ani publikacji. Publikacja GitHub nadal
wstrzymana do Family/S01 i osobnego polecenia — ten wynik tego nie zmienia.
