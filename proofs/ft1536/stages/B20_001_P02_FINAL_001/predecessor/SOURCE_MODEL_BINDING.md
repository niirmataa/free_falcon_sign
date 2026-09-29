# P02 — SOURCE_MODEL_BINDING

## Przypięte źródła

SOURCE_BASE=ef62824a10a69962dc8347410ee3f424bfa2b12e; source17 manifest
56974571…a0985. Kluczowe pliki (SHA w INPUTS.sha256):
- `fpr-emulated.h` (16: typedef uint64_t fpr; 19–38 shift helpers;
  40–56 FPR; 99–152 fpr_rint; 118–136 fpr_floor; 154–159 fpr_sub;
  161–166 fpr_neg; 168–177 fpr_half; 179–185 fpr_double) — 7 funkcji
  skalarnych + sub sparsowanych do `B20/Fpr/ParsedPrograms.lean`
  (AST kernel-checked przez `decide`, certyfikaty slice/lex/parse w
  `SourceBinding.lean`).
- `shake.c` (56–90 dec64le/enc64le) — slice/lex/parse + wykonanie CExec ↔
  BitVec LE64 (`LERefinement.lean`).
- `fpr-emulated.c` — definicja fpr_add (link tylko dla kontroli C;
  formalnie AddCallObligation).

## Wiązanie bajty→AST→semantyka

1. Bajty wejścia transportowane exact (64-liniowe definicje `Pinned/Header`,
  `Pinned/Slices`, `Pinned/ScalarSlices`; regeneracja `embed_*.py` z tymi
  samymi hashami przed/po — `check_transport.py`).
2. `slice → chars → tokens → AST` — osobne kernel proofs per stopień +
  kompozycja; parser niemutualny (FAILED_ROUTES: mutual OOM).
3. Wykonanie: `B20.C.Scalar.execute` (evaluator) = spec; konwersja do modelu
  P01 `CExec` tylko dla fragmentu word (konwers CExec P01 w WORD_HELPERS_001).

## Translacja operatorów

C promotions/casts: `B20.C.cast` (i32→u64 signExtend — weryfikowane);
shifts: split unsigned/signed helpers (`ulsh/ursh/irsh`), count legality
<64 dowiedziona; overflow: signed add/sub/mul przez `signedSafe` (odrzucone
przy przepełnieniu — `signed_overflow_rejected`); memory: byte model
(`ByteMemory.lean`, radix 2^8).

## Granice wiązania

Equality do ręcznie przepisanej funkcji NIE zamyka source-refinement —
wszystkie powyższe ścieżki mają własne certyfikaty; fixture-tabele nie są
premisami. Żaden brakujący eksport nie został zastąpiony aksjomatem.
