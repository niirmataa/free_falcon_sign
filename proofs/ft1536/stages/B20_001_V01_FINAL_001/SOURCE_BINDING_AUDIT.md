# V01 — SOURCE_BINDING_AUDIT

## Przypięte źródło (zweryfikowane niezależnie)

- source17 manifest `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`
  (17 plików, INPUTS autora 7930).
- tool.c SHA `920ac2d8a96408c505670eb2f044cde763ca11945d90ec24d8c6f2a048377890`
  (sha256sum zgodny); `nl -ba` linia 753: `return 0;` (w `main`, po dispatch
  `keygen`, przed `}`).
- Model: `source17ReturnZeroFragment` (`fragment="return 0;"`,
  `fileSha256` jw., `tokens=[ret,const,0]`) oraz
  `source17ReturnZeroProgram = .ret (.const 0)`.

## Trzy warstwy (nie tylko checksum)

1. **Checksum**: `fileSha256` przechowywany w `PinnedSource` i BOUND_INPUTS.
   Nie jest dowodzony w Lean (łańcuch plik→string w TCB, A3).
2. **Translacja tekstu**: `translateChars : List Char → Option CStmt`
   dla gramatyki `return <decimal>;` (6 liter `return`, spacja, cyfry, `;`).
   `source17ReturnZero_translation` (`unfold …; decide`) — poprawność
   translacji używanego fragmentu, nie odcisku. Zakres: dokładnie ta gramatyka
   (pojedyncza spacja, brak leading/trailing whitespace/newline/tab).
   Mutacje `return 1;` / `goto 0;` odrzucone (`decide` → `≠ some …`).
3. **Tokeny/AST ↔ semantyka**: `encodeStmt/decodeStmt` + `checkSource`
   (oba `decide` muszą przejść) + `checker_sound` (generyczne, poprawne
   przez `Bool.and_eq_true` + `of_decide_eq_true` + `compile_refines`).
   Trzeci koniunkt `SourceBinding` trywialny (`compile=id`, `Iff.rfl`) —
   nie jest refinementem dowolnego C (ostrzeżenie FOCUS przestrzegane).

## TCB wiązania

- Lean kernel + Mathlib definicje; zgodność kompilator/HW z `CExec`/`ABI`
  poza zakresem (A2); ręczny wybór `fragment` (A3); Sage tylko producent
  liczb (A5); `BitVec` wrap jako model unsigned (A1/A2).

## Synthetic witness

- `syntheticShapeFragment` (`seq/assign/store/ret`, sha `6b897d…`, jawny
  komentarz `/* SYNTHETIC shape witness */`) + `syntheticShape_binding`
  — test ścieżki `decodeStmt`, NIE dowód arytmetyki `fpr_ursh`.
  Oznaczony w kodzie, CLAIM i SOURCE_MODEL_BINDING; nie cytować jako
  evidence dla realnych fragmentów.

## Werdykt cząstkowy

Wiązanie dla `return 0;` dźwięczne w zadeklarowanym zakresie; encode/decode
nie jest mylone z translacją operatorów; hash nie jest mylony z refinementem.
Nowe fragmenty (operatory, whitespace, pełny C) wymagają nowych lematów.
