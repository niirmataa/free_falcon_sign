# C_TASK_2_FPERROR — FPEMU: refinement fpr_* + analiza błędu (Warstwa 2)

W: `FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/C_TASK_2_FPERROR` (zapisy tylko tu
+ `build/`; pozostałe C_TASK_*/CENTERING_CLOSURE = równoległe sesje, NIE DOTYKAĆ;
RUN_002/RUN_003 Sola tylko-do-odczytu; repo tylko-do-odczytu; bez Git).

## Kontekst (ustalony 2026-09-29, nie odkrywać na nowo!)

- Sol (RUN_003, `..._RUN_002/continuations/..._RUN_003`) robi source-bound
  semantykę keygena (StableBinary, bramki, leaf_scan). Jego jawna luka
  = wykonanie przypiętych `fpr_add/mul/div` + caller-memory frame oraz
  kontrakt `FprCalls : Word → Option Word` — TO JEST MOJE ZADANIE.
- Pin M0 `fpr-emulated.h` = `242a7027…` (17.09, zgodny ze frozen stages).
  Kandydat dudect = `6b897d6c…` (21.09, commit `fe6f92a`) — diff to
  „bit-preserving floor timing repair": select `xi ^= (xi ^ -t) & mask`
  → mux na unsignedach. Zbadany: walidacja + niezależny replay (`6ed89ca`),
  kampania floor-ct 10h = NO_LEAKAGE_EVIDENCE_YET wszystkie 12 celów × 3 rundy
  (max|t|=3.57, ~1.07e9 próbek/klasa); ich nota: to NIE jest dowód CT.
- Kluczowe fakty: M0 logn=10, N=1536 (MKN(10,1)), q=18433, PRIMES3=2147355649
  (NIE mylić z PRIMES2!), finalny leaf scan = 1536 słów (nie 768),
  poly_big_to_small: ±2047. P02 ma NOWSZY fpr-emulated.h niż M0 — nie utożsamiać.

## Kolejność prac

1. `SelectBitPreserve.lean` — LEmat bit-preservation: stary select ≡ nowy
   (dla WSZYSTKICH masek; per-bit dla m∈{0,1}) + pochodne maski
   (s∈{0,1} → mask 0/⊤). Zamyka widelec M0↔kandydat — modelujemy M0,
   wyniki przenoszą się na binaria dudect.
2. `RoundModel.lean` — kontrakt `flRound : ℝ → ℝ` (RN binary64):
   `|flRound x − x| ≤ u*|x|`, u=2⁻⁵³ (round-to-nearest, bez underflow
   w zakresach z modelu), własności: mnożenie/dodawanie/dzielenie jako
   `flRound(x∘y) = (x∘y)(1+δ)`, |δ|≤u. TO jest kontrakt dla Solowego
   `FprCalls` — nie założenie o kodzie!
3. `FprRefinement.lean` — refinement `FprCalls` → przypięte implementacje
   `fpr_add/mul/div` (+ `fpr_half/double` — Sol parsuje, linkować nie dublować):
   wykonanie source/Word ⇒ wynik z kontraktem flRound. STARTOWAĆ po domknięciu
   StableBinary przez Sola (jego interfejs może się ruszać!).
4. `LeafError.lean` — propagacja błędu: bound złożenia na ścieżce leaf;
   teza końcowa: `|leaf_computed − leaf_exact| ≤ E_leaf` oraz
   `source value ≥ 1024 → leaf_exact > 991`.
5. Kontrakty zapisywać w `CONTRACTS.md` po każdym etapie (sygnatury dla
   C_TASK_1_BINBIND/FFT i C_TASK_3_REFINE/SourceLeafBridge).

## Zasady (identyczne w projekcie)

ZERO sorry/admit/native_decide (grep przed każdą kompilacją); logi 0 err/0 warn;
kompilacja SERIALIZNIE z zapisem pliku (wyścig = awaria); `pgrep lean|sage`
przed kompilacją; python-patche z `assert old in s`; kompilacja:

    LEAN=/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
    B20=/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P01
    UPSTREAM="$B20/bootstrap/mathlib4/.lake/build/lib/lean" + pakiety
      (plausible importGraph LeanSearchClient batteries aesop proofwidgets Qq)
    LEAN_PATH="$PWD/build:$PWD/../run/check_lib:$UPSTREAM" HOME/TMPDIR pod W
    timeout 300 "$LEAN" -o build/<Mod>.olean formal/<Mod>.lean

Odbiór: `#print axioms` ≤ {propext, Classical.choice, Quot.sound}.
