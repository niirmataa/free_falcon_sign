# P01 — GOAL_SPEC (cele i drukowane typy)

TASK: B20_001_P01_FORMAL_FOUNDATIONS. Pełny zapis `#check` wszystkich43 nazw:
[formal_printed_types.txt](formal_printed_types.txt) (produkt replayu
`lean_printed_types`, RECEIPT w EXECUTION_RECEIPTS.json).

## Definicje domen (skrót)

- `Word8/32/64 = BitVec 8/32/64`; `ABI` (char/short/int/long/pointer/size
  bity, little-endian) — fixed ABI zadeklarowany, nie dowodzony z hardware.
- `Memory.bytes : Nat → Option Word8`; `readU64/writeU64/legalU64`;
  `Region.{base,size}`, `contains`, `legal`.
- `u64Add` arytmetyka modularna unsigned — `u64Add_toNat` (wrap mod 2^64).
- `State = {mem, locals}`; `initState` (pusty).
- `Outcome = returned (Option Word64) State | stuck | abort | nonreturn |
  fault (String)` —4 wyniki nienormalne parami rozłączne.
- `CExec : Program → State → Outcome → Prop` (typ drukowany wyżej) z
  konstruktorami dla wszystkich używanych składników C i wszystkich
  error/nonreturn outcomes; jawnie STUCK/abort/nonreturn/fault rozróżnione.
- `PinnedSource` (tekst + tokens + fileSha256), `translateStmt : String →
  Option CStmt` — poprawność translacji **używanego fragmentu** (`return
  <stała>;`) dowiedziona dla przypiętego `return 0;` tool.c:753.
- `RationalInterval` + `Certifies` (exact ℤ) + `checkSqrt2`;
  `certificate_sound/CertificateSound : checkSqrt2 i = true →
  (i.lower:ℝ) < √2 < (i.upper:ℝ)`.
- `Transport.decodeNat/encodeNat/decodeInt` — transport indeksów/rozmiarów
  i liczb certyfikatu; `decodeNat_encodeNat` (dźwięczność transportu).
- `ObservedKernel/History/conditionalHistory/totalVariation/directedChi2`
  na Mathlib `PMF` + konkretna instancja pinned modelu (`pinnedKernel`).

## Świadoma granica semantyki

Tezy dotyczą **semantyki C abstrakcyjnej** modelowanego fragmentu
(decyzja wymagana przez TASK §4), nie kodu maszynowego — patrz
SOURCE_MODEL_BINDING.md i ASSUMPTIONS.json (TCB).
