# P01 — SOURCE_MODEL_BINDING (wiązanie źródło ↔ model; TCB)

## Przypięte źródło

- source17 closure: manifest `CANDIDATE.sha256` = `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`
  (17 plików, weryfikacja w inputs/source17 oraz BOUND_INPUTS.json).
- Użyty fragment (realny): `return 0;` — tool.c:753 (`main` return),
  plik tool.c SHA `920ac2d8a96408c505670eb2f044cde763ca11945d90ec24d8c6f2a048377890`.
- W modelu: `source17ReturnZeroFragment` (tekst + fileSha256 + tokens) oraz
  `source17ReturnZeroProgram = .ret (.const (BitVec.ofNat 64 0))`.

## Wiązanie — trzy warstwy (nie tylko checksum)

1. **Checksum**: `fileSha256` przypięty w `PinnedSource` i w BOUND_INPUTS.
2. **Translacja tekstu**: `translateStmt "return 0;" = some program`
   (`source17ReturnZero_translation`, kernel-checked). Poprawność translacji
   **używanego fragmentu**, nie samego odcisku pliku.
3. **Tokeny/AST ↔ semantyka**: `checkSource` (encodeStmt/decodeStmt) +
   `checker_sound`: akceptacja checkera ⇒ `SourceBinding`, czyli
   `CExec p s o ↔ SpecExec (compile p) s o` dla każdego stanu i wyniku.

Kontrole mutacji (`return 1;`, `goto 0;`) zrywają wiązanie na obu warstwach
2 i 3 — patrz CLAIM.md i AXIOMS.json.

Synthetic/extended witness `syntheticShapeFragment` jest **osobno oznaczony**
w kodzie i w CLAIM.md: testuje shape ścieżki `decodeStmt` i nie jest
przedstawiany jako dowód dla realnego fragmentu arytmetycznego.

## Elementy pozostał w TCB (kompletna lista)

1. Lean4.34.0 kernel i poprawność definicji Mathlib4@5ed2965 (PMF, ENNReal,
   Real.sqrt, ℤ/ℝ cast).
2. Zgodność realnego kompilatora C/hardware z modelem `CExec` i `ABI`
   (poza zakresem P01 — A2 w ASSUMPTIONS.json).
3. Ręczny wybór reprezentacji: tekst C → `PinnedSource.fragment` (dla
   używanego fragmentu poprawność translacji jest dowiedziona; dla innych
   fragmentów source17 — obowiązek jawny w NEXT_INTERFACE.md).
4. SageMath10.9 wyłącznie jako **producent liczb**; każda liczba w tezie
   jest ponownie sprawdzona kernelowo (`sqrt2Witness_checked`, `*_transport`,
   `certificate_checker_discriminates`), więc Sage NIE jest w TCB twierdzeń.
5. Semantyka `>>`/`&`/`^` modelowana przez `BitVec` (wrap mod 2^64);
   zgodność z C unsigned to A1/A2.
