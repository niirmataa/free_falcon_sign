import Source3.KeygenZintCall

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source-bound extraction helpers. Static storage is checked against the
   literal initializer and the returned value call executes the fixed body.
   These are operational/frame bindings, not bigint arithmetic contracts. -/
namespace FT1536.Source3.KeygenZintExtract
open KeygenZintCall

def lines := KeygenLevelNtt.region
def vv : List (BitVec 32) := [0,31,4,5,6,10,7,15,11,20,8,18,16,25,12,27,
  21,30,3,9,14,19,17,24,26,29,2,13,23,28,1,22]

theorem bitlength_header : lines 4206 3 =
    ["unsigned\n","bitlength(uint32_t x)\n","{\n"] := by decide
theorem bitlength_close : Pinned.keygenLines[4236]?=some "}\n" := by decide
theorem bitlength_partition : lines 4209 28 =
    lines 4209 21 ++ lines 4230 6 ++ lines 4236 1 := by decide
theorem vv_length : vv.length=32 := by decide
theorem vv_declaration : extractParsed .bitlength 0=some (.seq (.static32 vv) skip) := by decide

theorem signed_header : lines 4244 3 = ["static uint32_t\n",
    "zint_signed_bit_length(const uint32_t *x, size_t xlen)\n","{\n"] := by decide
theorem signed_close : Pinned.keygenLines[4262]?=some "}\n" := by decide
theorem signed_partition : lines 4247 16 = lines 4247 2 ++ lines 4249 3 ++
    lines 4252 7 ++ lines 4259 3 ++ lines 4262 1 := by decide

def audit (kind : Callee) (index : Nat) : Option Bool :=
  (extractParsed kind index).map (only (writable kind))
theorem bitlength_audit0 : audit .bitlength 0=some true := by decide
theorem bitlength_audit1 : audit .bitlength 1=some true := by decide
theorem bitlength_audit2 : audit .bitlength 2=some true := by decide
theorem signed_audit0 : audit .signedBitLength 0=some true := by decide
theorem signed_audit1 : audit .signedBitLength 1=some true := by decide
theorem signed_audit2 : audit .signedBitLength 2=some true := by decide
theorem signed_audit3 : audit .signedBitLength 3=some true := by decide
theorem signed_audit4 : audit .signedBitLength 4=some true := by decide

theorem parsed_part (kind : Callee) (index : Nat) (h : audit kind index=some true) :
    extractParsed kind index=some (extractPart kind index) := by
  cases hp : extractParsed kind index with
  | none => simp only [audit,hp,Option.map_none] at h; cases h
  | some code => simp only [extractPart,hp,Option.getD_some]
theorem part_checked (kind : Callee) (index : Nat) (h : audit kind index=some true) :
    only (writable kind) (extractPart kind index)=true := by
  have parsed := parsed_part kind index h
  simp only [audit,parsed,Option.map_some,Option.some.injEq] at h
  exact h

theorem only_seq (names : List C99ArrayReference.Name) (a b : Stmt) :
    only names (.seq a b)=(only names a && only names b) := rfl
theorem only_skip (names : List C99ArrayReference.Name) : only names skip=true := rfl
theorem bitlength_checked : only (writable .bitlength) bitlengthCode=true := by
  show only (writable .bitlength) (.seq (extractPart .bitlength 0)
    (.seq (extractPart .bitlength 1) (.seq (extractPart .bitlength 2) skip)))=true
  rw [only_seq,only_seq,only_seq,only_skip,
    part_checked .bitlength 0 bitlength_audit0,
    part_checked .bitlength 1 bitlength_audit1,
    part_checked .bitlength 2 bitlength_audit2]
  decide
theorem signed_checked : only (writable .signedBitLength) signedBitLengthCode=true := by
  show only (writable .signedBitLength) (.seq (extractPart .signedBitLength 0)
    (.seq (extractPart .signedBitLength 1) (.seq (extractPart .signedBitLength 2)
    (.seq (extractPart .signedBitLength 3) (.seq (extractPart .signedBitLength 4) skip)))))=true
  rw [only_seq,only_seq,only_seq,only_seq,only_seq,only_skip,
    part_checked .signedBitLength 0 signed_audit0,
    part_checked .signedBitLength 1 signed_audit1,
    part_checked .signedBitLength 2 signed_audit2,
    part_checked .signedBitLength 3 signed_audit3,
    part_checked .signedBitLength 4 signed_audit4]
  decide
theorem bitlength_audit : (calleeParsed .bitlength).map (only (writable .bitlength))=some true :=
  congrArg some bitlength_checked
theorem signed_audit : (calleeParsed .signedBitLength).map (only (writable .signedBitLength))=some true :=
  congrArg some signed_checked

/- Exact return trees prevent the word grammar's closed ModCall fallback
   from masquerading as the expression-position bitlength call. -/
def signedLeft : KeygenWordExpr.Expr := .bin .mul
  (.cast .uint32 (.bin .sub (.scalar (.var "xlen".toList)) (.scalar (.literal .i32 1))))
  (.scalar (.literal .i32 31))
def signedArgument : KeygenWordExpr.Expr := .bin .xor
  (.load32 "x".toList (.bin .sub (.var "xlen".toList) (.literal .i32 1)))
  (.scalar (.var "sign".toList))
def bitlengthIndex : CLogic.Expr := .bin .shr
  (.bin .mul (.var "x".toList) (.literal .u32 0xF04653AE)) (.literal .i32 27)
theorem bitlength_return : extractParsed .bitlength 2=
    some (.seq (.word (.ret (.load32 vvName bitlengthIndex))) skip) := by decide
theorem signed_return : extractParsed .signedBitLength 4=
    some (.seq (.retSum signedLeft signedArgument) skip) := by decide
theorem signed_value_call : (extractParsed .signedBitLength 4).map callShape=some (1,0,0,0) := by decide

theorem static_object (before : C99ArrayReference.State) (out : C99ProcedureReference.Result)
    (source : Exec (.static32 vv) before out) :
    ∃ p, before.tables vvObject=some p ∧ Static32 before.heap p vv ∧
      out.state=C99ArrayReference.bindPointer before vvName p ∧ out.flow=.normal := by
  cases source with
  | static32 values before p binding initialized => exact ⟨p,binding,initialized,rfl,rfl⟩

theorem return_value_call (before : C99ArrayReference.State) (out : C99ProcedureReference.Result)
    (source : Exec (.retSum signedLeft signedArgument) before out) :
    ∃ a x v z inner, KeygenWordExpr.Eval before signedLeft a ∧
      KeygenWordExpr.Eval before signedArgument x ∧
      Exec (calleeBody .bitlength) (valueEntry before x) inner ∧
      C99ProcedureReference.ReturnValue (result .bitlength) inner.flow (some v) ∧
      C99OperatorBridge.Binary .add a v z ∧
      out=⟨{before with heap := inner.state.heap},.returned (some z)⟩ := by
  cases source with
  | retSum left argument before a x v z inner hv hx hs hr ha =>
    exact ⟨a,x,v,z,inner,hv,hx,hs,hr,ha,rfl⟩

end FT1536.Source3.KeygenZintExtract
