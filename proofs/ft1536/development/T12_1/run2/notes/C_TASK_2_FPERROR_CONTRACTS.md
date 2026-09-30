# CONTRACTS — C_TASK_2_FPERROR (interfejsy dla BINBIND/REFINE/Sola)

## Dostarczone (2026-09-29)

### SelectBitPreserve (build/SelectBitPreserve.olean) — ZAMKNIĘTE, czyste 0/0/0

Namespace `FT1536.FPError.SelectBitPreserve`:
- `select_bits_equiv (a b m : BitVec 64) :
    a ^^^ (a ^^^ b) &&& m = (a &&& ~~~m) ||| (b &&& m)` — dla każdej maski (bv_decide);
- `select_old_eq_new` — postać kodu;
- `mask_extend_eq (s : BitVec 32) (hs : s = 0#32 ∨ s = 1#32) :
    -s.zeroExtend 64 = -s.signExtend 64`;
- `select_code_variants_equiv` — dwa warianty kodu (pin M0 vs kandydat floor-ct)
  dają identyczne słowo.

Audyt: `#print axioms` w logu = wyłącznie standardowe (sprawdzone w logs_select.log).

**WNIOSEK KONTRAKTU**: select z pinu M0 (`242a7027…`) i z kandydata dudect
(`6b897d6c…`, commit `fe6f92a`) są semantycznie tożsame bitowo.
Modelem dowodu = pin M0; wyniki przenoszą się na binaria kampanii floor-ct
bez zastrzeżeń wersyjnych. Delta = wyłącznie timing (bit-preserving repair;
dudect floor-ct 10h: NO_LEAKAGE_EVIDENCE_YET, 12 celów × 3 rundy,
max|t|=3.57 — to pomiar, NIE dowód CT).

## Fakty piny (wspólne dla wszystkich warstw)

M0 logn = 10; N = 1536 (MKN(10,1)); q = 18433; PRIMES3 = 2147355649
(NIE mylić z PRIMES2); finalny leaf scan = 1536 słów (nie 768);
poly_big_to_small: ±2047. Pin źródeł M0 = source17; nowszy fpr-emulated.h
z P02 NIE jest utożsamiony z kontraktem M0.

## W przygotowaniu (kolejność)

1. `RoundModel.lean` — `flRound : ℝ → ℝ` (RN binary64): |flRound x − x| ≤ u·|x|,
   u = 2⁻⁵³; algebra błędu dla +, ×, ÷ jako (x∘y)(1+δ). Kontrakt dla Solowego
   `FprCalls : Word → Option Word` — deklaracja poziomu błędu, nie założenie
   o kodzie (własność wykazuje FprRefinement).
2. `FprRefinement.lean` — wykonanie przypiętych `fpr_add/mul/div`
   (+fpr_half/double: link do Source3 Sola, bez dublowania) ⇒ wynik z kontraktem
   flRound. Start po domknięciu StableBinary przez Sola (interfejs się rusza!).
3. `LeafError.lean` — propagacja na ścieżce leaf: |leaf_c − leaf_exact| ≤ E_leaf;
   `source value ≥ 1024 → leaf_exact > 991`.

Sygnatury docelowe dla C_TASK_3_REFINE/SourceLeafBridge:
`leaf_error_bound : ∀ input, |leaf_computed − leaf_exact| ≤ E_leaf` (nazwy
dostosować obustronnie w CONTRACTS, nie zmieniać logiki!).
