import B20.Foundation.CExec

namespace B20.Foundation

inductive SourceToken where
  | name (s : String)
  | num (n : Nat)
  deriving DecidableEq, Repr

structure PinnedSource where
  name : String
  fileSha256 : String
  fragment : String
  tokens : List SourceToken
  deriving DecidableEq, Repr

def encodeExpr : CExpr -> List SourceToken
  | .const w => [.name "const", .num w.toNat]
  | .local x => [.name "local", .name x]
  | .loadU64 base => [.name "loadU64", .num base]

def encodeStmt : CStmt -> List SourceToken
  | .skip => [.name "skip"]
  | .assign x e => [.name "assign", .name x] ++ encodeExpr e
  | .storeU64 base e => [.name "storeU64", .num base] ++ encodeExpr e
  | .seq p q => [.name "seq"] ++ encodeStmt p ++ encodeStmt q
  | .ret e => [.name "ret"] ++ encodeExpr e
  | .assumeFalse tag => [.name "assumeFalse", .name tag]
  | .unimplemented tag => [.name "unimplemented", .name tag]

def decodeExpr : List SourceToken -> Option CExpr
  | [.name "const", .num n] => some (.const (BitVec.ofNat 64 n))
  | [.name "local", .name x] => some (.local x)
  | [.name "loadU64", .num n] => some (.loadU64 n)
  | _ => none

def decodeStmt : List SourceToken -> Option CStmt :=
  fun ts =>
    match ts with
    | [.name "skip"] => some .skip
    | [.name "ret", .name "const", .num n] =>
      some (.ret (.const (BitVec.ofNat 64 n)))
    | [.name "seq", .name "assign", .name x, .name "const", .num n,
        .name "seq", .name "storeU64", .num b, .name "const", .num m,
        .name "ret", .name "const", .num r] =>
      some (.seq (.assign x (.const (BitVec.ofNat 64 n)))
        (.seq (.storeU64 b (.const (BitVec.ofNat 64 m)))
          (.ret (.const (BitVec.ofNat 64 r)))))
    | _ => none

def checkSource (src : PinnedSource) (p : CStmt) : Bool :=
  decide (src.tokens = encodeStmt p) && decide (decodeStmt src.tokens = some p)

def SourceBinding (src : PinnedSource) (p : CStmt) : Prop :=
  src.tokens = encodeStmt p ∧
    decodeStmt src.tokens = some p ∧
    forall s o, CExec p s o <-> SpecExec (compile p) s o

theorem checker_sound (src : PinnedSource) (p : CStmt) :
    checkSource src p = true -> SourceBinding src p := by
  intro h
  simp only [checkSource, Bool.and_eq_true] at h
  obtain ⟨h1, h2⟩ := h
  exact ⟨of_decide_eq_true h1, of_decide_eq_true h2,
    fun _ _ => compile_refines _ _ _⟩

theorem SourceBinding.checker_sound (src : PinnedSource) (p : CStmt) :
    checkSource src p = true -> SourceBinding src p := B20.Foundation.checker_sound src p

/-! ## Text → model translation for the used fragment grammar

`translateStmt` is the (kernel-checked) translation of the used C fragment
grammar — currently the statement `return <decimal-constant>;` — into the model
program. This covers translation *correctness of the used fragment*, not only
the file checksum; the general C front end remains outside this export (see
ASSUMPTIONS.json / SOURCE_MODEL_BINDING.md TCB list). -/

def isDigitChar (c : Char) : Bool := 48 ≤ c.toNat && c.toNat ≤ 57

def valueOfDigits (ds : List Char) : Nat :=
  ds.foldl (fun acc c => acc * 10 + (c.toNat - 48)) 0

/-- Translation of the used fragment grammar `return <decimal>;` over
character lists (kernel-reducible primitives only). -/
def translateChars : List Char -> Option CStmt
  | 'r' :: 'e' :: 't' :: 'u' :: 'r' :: 'n' :: ' ' :: rest =>
    match rest.reverse with
    | ';' :: digitsRev =>
      let ds := digitsRev.reverse
      match ds with
      | [] => none
      | _ :: _ =>
        if ds.all isDigitChar then
          some (.ret (.const (BitVec.ofNat 64 (valueOfDigits ds))))
        else none
    | _ => none
  | _ => none

def translateStmt (text : String) : Option CStmt := translateChars text.toList

def SourceTranslation (src : PinnedSource) (p : CStmt) : Prop :=
  translateStmt src.fragment = some p

/-! ## Real pinned fragment

`return 0;` — literal return of `main` at tool.c:753 in the hash-pinned
source17 closure (tool.c SHA-256
`920ac2d8a96408c505670eb2f044cde763ca11945d90ec24d8c6f2a048377890`). -/

def source17ReturnZeroFragment : PinnedSource := {
  name := "source17/tool.c:753#main-return"
  fileSha256 := "920ac2d8a96408c505670eb2f044cde763ca11945d90ec24d8c6f2a048377890"
  fragment := "return 0;"
  tokens := [.name "ret", .name "const", .num 0]
}

def source17ReturnZeroProgram : CStmt :=
  .ret (.const (BitVec.ofNat 64 0))

/-- Translation correctness for the used fragment: pinned text → model. -/
theorem source17ReturnZero_translation :
    SourceTranslation source17ReturnZeroFragment source17ReturnZeroProgram := by
  unfold SourceTranslation translateStmt
  decide

theorem source17ReturnZero_binding :
    SourceBinding source17ReturnZeroFragment source17ReturnZeroProgram := by
  apply checker_sound
  decide

/-- Constant mutation (`return 0;` → `return 1;`) breaks the binding. -/
def mutatedReturnOne : PinnedSource :=
  { source17ReturnZeroFragment with
    name := "mutation:return-one"
    fragment := "return 1;"
    tokens := [.name "ret", .name "const", .num 1] }

theorem mutated_constant_rejected :
    ¬ SourceBinding mutatedReturnOne source17ReturnZeroProgram := by
  intro h
  simp [SourceBinding, mutatedReturnOne, source17ReturnZeroFragment,
    source17ReturnZeroProgram, encodeStmt, encodeExpr] at h

theorem mutated_constant_translation_rejected :
    translateStmt "return 1;" ≠ some source17ReturnZeroProgram := by
  decide

/-- Operator/keyword mutation (`return` → `goto`) breaks the binding. -/
def mutatedReturnGoto : PinnedSource :=
  { source17ReturnZeroFragment with
    name := "mutation:return-goto"
    fragment := "goto 0;"
    tokens := [.name "goto", .name "const", .num 0] }

theorem mutated_operator_rejected :
    ¬ SourceBinding mutatedReturnGoto source17ReturnZeroProgram := by
  intro h
  simp [SourceBinding, mutatedReturnGoto, source17ReturnZeroFragment,
    source17ReturnZeroProgram, encodeStmt, encodeExpr] at h

theorem mutated_operator_translation_rejected :
    translateStmt "goto 0;" ≠ some source17ReturnZeroProgram := by
  decide

/-! ## SYNTHETIC shape witness (labelled separately per TASK §5)

Shape-only, synthetic/extended witness exercising the `seq/assign/store/ret`
token grammar. It is NOT a faithful translation of any pinned C arithmetic
(e.g. `fpr_ursh`); it is kept to test the shape path of `decodeStmt` and must
not be cited as source evidence for real fragment semantics. -/

def syntheticShapeFragment : PinnedSource := {
  name := "synthetic/shape-seq-assign-store-ret"
  fileSha256 := "6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f"
  fragment := "/* SYNTHETIC shape witness */ x = 0; *(uint64_t *)0 = 0; return 0;"
  tokens := [.name "seq", .name "assign", .name "x", .name "const", .num 0,
    .name "seq", .name "storeU64", .num 0, .name "const", .num 0,
    .name "ret", .name "const", .num 0]
}

def syntheticShapeProgram : CStmt :=
  .seq (.assign "x" (.const (BitVec.ofNat 64 0)))
    (.seq (.storeU64 0 (.const (BitVec.ofNat 64 0))) (.ret (.const (BitVec.ofNat 64 0))))

theorem syntheticShape_binding :
    SourceBinding syntheticShapeFragment syntheticShapeProgram := by
  apply checker_sound
  decide

end B20.Foundation
