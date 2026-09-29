# P02 — REPORT: słowa maszynowe i kontrakty FPEMU powiązane z C

TASK_ID=B20_001_P02_WORD_FPEMU_REFINEMENT, ROADMAP_ID=F03–F06, para V02.
W=proofs/ft1536/work/B20_001/P02, CHECKOUT=/home/footfalcon/free_falcon_sign,
BRANCH=main, SOURCE_BASE=ef62824a10a69962dc8347410ee3f424bfa2b12e.
Status: **PARTIAL_PROOF (cały TASK) / PROVED w zadeklarowanych zakresach** —
dokładny podział w CLAIM.md i GOAL_SPEC.json.

## 1. Stack i wykonanie

Lean4.34.0 + Mathlib4@5ed2965… (shared bootstrap P01), SageMath10.9
(preparser, ZZ), gcc C99 (normal/UBSan/ASan). Wszystko W-only, network-off
(bwrap), jeden ciężki job naraz, wall 1800s/krok. Świeży replay
`run/replay_001`: 42/42 kroków exit 0, źródła unchanged.

## 2. Wyniki formalne (kernel-checked; pełne typy w FORMAL_EXPORTS.json)

**A. B20.Word.load_store_le_refines + load_le_refines** — pinned
dec64le/enc64le (shake.c:56–90): legalna pamięć LP64 → wykonanie CExec ↔
BitVec LE64, round-trip, rama poza 8 bajtami, obie strony iff.
Razem z WORD_HELPERS_001: 3 shift helpers end-to-end (parse→C→BitVec),
konwers CExec P01, abstrakcyjny memory round-trip.

**B. Wykonania skalarnych prymitywów FPEMU** (7 funkcji sparsowanych
z przypiętego fpr-emulated.h; wynik = literal-BitVec spec):
- neg, double, half — bezwarunkowo;
- pack — pod `packDomain` (bezprzepełnienie e+1076);
- **rint** — pod `rintDomain` (mantysa ≤ 1072): pełne wykonanie z maskami
  (`rint_mask_all/zero`), call-sites fpr_ulsh/ursh przez proved interfejsy
  Fin-64, mostki signed (`cond_neg_add64`), rozstrzygnięcie obu przypadków
  e<64 / e≥64. `rint_m2_small/big` jako osobne granice.
- **floor** — pod `floorDomain` (mantysa ≤ 1072 ∧ x ≠ raw −0): call-site
  fpr_irsh, selekcja maską (cc≤63→0 / cc≥64→allOnes), jawny wyjątek raw −0
  (impl zwraca −1 — obserwacja, nie kontrakt).
- sub — warunkowo na `AddCallObligation` (interfejs MS2).

**C. B20.Fpr.reachable_domain_interfaces** (Domain.lean): `PrimObligation`,
`ShiftCountDomain`, udowodnione instancje dla 3 shift call-sites z bieżących
przesłanek callerów; `Add/Mul/Div/SqrtObligation` jako jawne unresolved types
(bez instancji); rejestr `parsedCallSites`.

**D. Wiązanie źródłowe**: slice/lex/parse certyfikaty shake.c i 7 funkcji
skalarnych; parser skalarny niemutualny (po OOM mutuala); transpilacja
operatorów rozliczona (cast signExtend, signedSafe overflow, split shifts).

Aksjomaty: 183 teorematy przeskanowane; zbiory tylko z {propext,
Classical.choice, Quot.sound} (11 bezaksjomatowych); brak sorry/admit/
native_decide/wyciszonych ostrzeżeń (AXIOMS.json).

## 3. Kontrole (diagnostyka wspierająca, nie premises)

- word: 12288 cases normal/UBSan + 4 mutanty + ASan (word_asan_002);
- LE: 3072 cases + 3 mutanty + ASan (le_asan_002);
- scalar (MS3): Sage oracle ZZ — 19721 in + 21352 obs + 2 preflight-rejecty;
  gcc normal/UBSan/ASan; **5 mutantów odrzuconych** (shift/rounding_rint/
  sign_neg/floor_mask/rounding_pack); empty-producer reject.
- Wiersze obs (y>1072, NaN/Inf, raw −0, extreme pack) — zgodność
  diagnostyczna z totalnym spec, jawnie poza kontraktem.

## 4. Otwarte i granice (uczciwie)

1. fpr_add/mul/div/sqrt: brak kontraktów arytmetycznych i błędów
   rzeczywistych — exact obligation types istnieją, instancji brak.
2. nearest-ties-even dla rint na rzeczywistych — jawny missing type
   (spec jest słowny).
3. Raw −0 floor → −1: wymaga decyzji właściciela (akceptacja vs poprawka).
4. Kompilator w TCB (semantyka C, nie maszynowa).
Pełna lista w NEXT_INTERFACE.md. Nieudane trasy (parser mutual OOM, maski
rint, floor masks matching, sage `^^`, FPR_IMPL, ciche exity) — FAILED_ROUTES.md.

## 5. Werdykt

PARTIAL_PROOF dla TASK; PROVED dla: LE refinement, literalnych wykonanie
neg/double/half/pack/rint/floor z domenami, sub warunkowo, interfejsów
domen shift. owner_accepted=false.
