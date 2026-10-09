import Source3.KeygenPublicArguments

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicSquare
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open C99ModularReference (Expr Stmt GenEval GenExec)
open C99ProcedureReference (Result)
open KeygenPublicScalar (Kind name Body Call Square)
open KeygenPublicAlgebra (Canonical value radix R)
open KeygenPublicMontgomery (modulus inverse)

def read (n : String) : Expr := .scalar (.var n.toList)
def code : Stmt := .seq (.ret (.call4 (name .mul) (read "x") (read "x") (read "q") (read "q0i"))) (.base .skip)
theorem source_code : KeygenPublicScalar.code .square=code := by decide
def Slot (s : State) (n : String) (w : BitVec 32) : Prop :=
  s.locals n.toList=some (.uint32,some (.uint32 w))
theorem variable_value (calls : C99ModularReference.CallRelation) (s : State) (n : String)
    (w : BitVec 32) (v : Value) (slot : Slot s n w) (source : GenEval calls s (read n) v) : v=.uint32 w := by
  cases source
  exact C99CountedWords.variable_exact s n.toList .uint32 (.uint32 w) v slot ‹_›
theorem converted_word (w : BitVec 32) :
    C99IntegerReference.convert .uint32 (Value.uint32 w).integer=.uint32 w :=
  C99CountedWords.convert_self (.uint32 w)
theorem ret_expression (calls : C99ModularReference.CallRelation) (e : Expr) (s : State) (out : Result)
    (source : GenExec calls (.seq (.ret e) (.base .skip)) s out) :
    ∃ v, out.flow=.returned (some v) ∧ GenEval calls s e v := by
  cases source with
  | seqNormal _ _ _ _ _ first rest => cases first
  | seqExit _ _ _ _ first exit =>
      cases first
      exact ⟨_,rfl,‹_›⟩
theorem square_body (args : List Value) (v : Value) (source : Square (name .square) args v) :
    Body KeygenPublicScalar.Leaf .square args v := by
  generalize hn : name Kind.square=n at source
  cases source with
  | leaf _ _ _ leaf =>
      cases leaf with
      | run kind _ _ allowed execution =>
          have equal := KeygenPublicAlgebra.name_injective hn
          subst kind
          simp [KeygenPublicScalar.IsLeaf] at allowed
  | square _ _ execution => exact execution

theorem source_square_exact (x q q0i : BitVec 32) (v : Value)
    (source : Square (name .square) [.uint32 x,.uint32 q,.uint32 q0i] v) :
    v=.uint32 (KeygenPublicLeafWords.montgomery x x q q0i) := by
  obtain ⟨out,execution,returned⟩ := (square_body _ v source).2
  rw [source_code] at execution
  obtain ⟨raw,flow,evaluated⟩ := ret_expression _ _ _ out execution
  have sx : Slot (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params .square)
      [.uint32 x,.uint32 q,.uint32 q0i]) "x" x := by
    simp [Slot,KeygenPublicScalar.params,C99ModularReference.bindParams,C99ArrayReference.bindValue,
      C99ScalarReference.set,KeygenPublicScalar.empty,converted_word]
  have sq : Slot (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params .square)
      [.uint32 x,.uint32 q,.uint32 q0i]) "q" q := by
    simp [Slot,KeygenPublicScalar.params,C99ModularReference.bindParams,C99ArrayReference.bindValue,
      C99ScalarReference.set,KeygenPublicScalar.empty,converted_word]
  have si : Slot (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params .square)
      [.uint32 x,.uint32 q,.uint32 q0i]) "q0i" q0i := by
    simp [Slot,KeygenPublicScalar.params,C99ModularReference.bindParams,C99ArrayReference.bindValue,
      C99ScalarReference.set,KeygenPublicScalar.empty,converted_word]
  have rawExact : raw=.uint32 (KeygenPublicLeafWords.montgomery x x q q0i) := by
    cases evaluated with
    | call4 _ _ _ _ _ a b c d _ first second third fourth invoked =>
        have ax := variable_value _ _ "x" x a sx first
        have bx := variable_value _ _ "x" x b sx second
        have cq := variable_value _ _ "q" q c sq third
        have di := variable_value _ _ "q0i" q0i d si fourth
        subst a; subst b; subst c; subst d
        exact KeygenPublicLeafWords.source_mul _ x x q q0i raw (KeygenPublicAlgebra.leaf_body .mul _ _ invoked)
  obtain ⟨actual,actualFlow,equal⟩ := KeygenPublicLinear.return_value out.flow v returned
  have actualEqual : actual=raw := Option.some.inj (C99ProcedureReference.Flow.returned.inj (actualFlow.symm.trans flow))
  rw [actualEqual,rawExact,converted_word] at equal
  exact equal

theorem source_square_arguments (x : BitVec 32) (a q q0i v : Value)
    (ax : KeygenPublicArguments.U32 a x) (qm : KeygenPublicArguments.U32 q modulus)
    (qi : KeygenPublicArguments.U32 q0i inverse)
    (source : Square (name .square) [a,q,q0i] v) :
    v=.uint32 (KeygenPublicLeafWords.montgomery x x modulus inverse) := by
  have conversion : KeygenPublicArguments.Conversion (KeygenPublicScalar.params .square)
      [a,q,q0i] [.uint32 x,.uint32 modulus,.uint32 inverse] :=
    .cons _ _ _ _ _ _ _ (ax.trans (KeygenPublicArguments.u32_self x).symm)
      (.cons _ _ _ _ _ _ _ (qm.trans (KeygenPublicArguments.u32_self modulus).symm)
        (.cons _ _ _ _ _ _ _ (qi.trans (KeygenPublicArguments.u32_self inverse).symm) .nil))
  have normalized := KeygenPublicArguments.body_conversion _ .square _ _ v conversion (square_body _ v source)
  exact source_square_exact x modulus inverse v (.square _ _ normalized)

theorem source_square (x out : BitVec 32) (hx : Canonical x)
    (source : Square (name .square) [.uint32 x,.uint32 modulus,.uint32 inverse] (.uint32 out)) :
    Canonical out ∧ value out*radix=value x^2 := by
  have equal := Value.uint32.inj (source_square_exact x modulus inverse (.uint32 out) source)
  subst out
  have contract := KeygenPublicMontgomery.word_contract x x hx hx
  refine ⟨contract.1,?_⟩
  have hf := (ZMod.natCast_eq_natCast_iff' _ _ 18433).mpr contract.2
  simpa only [value,radix,KeygenPublicMontgomery.radix,Nat.cast_mul,pow_two] using hf

end FT1536.Source3.KeygenPublicSquare
