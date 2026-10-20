import Source3.KeygenPublicAlgebra

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source constants are signed int literals before conversion at mq's
   uint32 parameters. Preserve that distinction: normalize actual arguments
   by a proved parameter-binding equality, not by pretending every caller
   expression already has type uint32. -/
namespace FT1536.Source3.KeygenPublicArguments
open C99ArrayReference (State Name)
open C99IntegerReference (Value Ty convert)
open KeygenPublicScalar (Kind name Body Call params)
open KeygenPublicAlgebra (Canonical value R)
open KeygenPublicMontgomery (modulus inverse)

inductive Conversion : List (Ty×Name) → List Value → List Value → Prop where
  | nil : Conversion [] [] []
  | cons (ty : Ty) (n : Name) (x y : Value) (ps : List (Ty×Name)) (xs ys : List Value)
      (equal : convert ty x.integer=convert ty y.integer) (rest : Conversion ps xs ys) :
      Conversion ((ty,n)::ps) (x::xs) (y::ys)
theorem lengths (ps : List (Ty×Name)) (xs ys : List Value) (source : Conversion ps xs ys) :
    xs.length=ps.length ∧ ys.length=ps.length := by
  induction source <;> simp_all
theorem bind_equal (ps : List (Ty×Name)) (xs ys : List Value) (source : Conversion ps xs ys) (s : State) :
    C99ModularReference.bindParams s ps xs=C99ModularReference.bindParams s ps ys := by
  induction source generalizing s with
  | nil => rfl
  | cons ty n x y ps xs ys equal rest ih =>
      have bind : C99ArrayReference.bindValue s n ty x=C99ArrayReference.bindValue s n ty y := by
        unfold C99ArrayReference.bindValue
        rw [equal]
      simp only [C99ModularReference.bindParams,bind]
      exact ih _
theorem body_conversion (calls : C99ModularReference.CallRelation) (kind : Kind)
    (xs ys : List Value) (v : Value) (conversion : Conversion (params kind) xs ys)
    (source : Body calls kind xs v) : Body calls kind ys v := by
  refine ⟨(lengths _ _ _ conversion).2,?_⟩
  rw [← bind_equal _ _ _ conversion KeygenPublicScalar.empty]
  exact source.2
theorem call_leaf_conversion (kind : Kind) (supported : KeygenPublicLeafWords.Supported kind)
    (xs ys : List Value) (v : Value) (conversion : Conversion (params kind) xs ys)
    (source : Call (name kind) xs v) : Call (name kind) ys v := by
  have body := body_conversion _ kind xs ys v conversion (KeygenPublicAlgebra.call_leaf kind supported xs v source)
  apply Call.square
  apply KeygenPublicScalar.Square.leaf
  apply KeygenPublicScalar.Leaf.run kind ys v _ body
  cases kind <;> simp_all [KeygenPublicScalar.IsLeaf,KeygenPublicLeafWords.Supported]

def U32 (v : Value) (w : BitVec 32) : Prop := convert .uint32 v.integer=.uint32 w
theorem u32_self (w : BitVec 32) : U32 (.uint32 w) w := C99CountedWords.convert_self (.uint32 w)
theorem u32_literal (n : Nat) : U32 (convert .int32 n) (BitVec.ofNat 32 n) := by
  change Value.uint32 (BitVec.ofInt 32 (BitVec.ofInt 32 (n : Int)).toInt)=Value.uint32 (BitVec.ofNat 32 n)
  rw [BitVec.ofInt_natCast,BitVec.ofInt_toInt]

theorem source_add (x y out : BitVec 32) (a b q : Value)
    (hx : Canonical x) (hy : Canonical y) (ax : U32 a x) (by_ : U32 b y) (qm : U32 q modulus)
    (source : Call (name .add) [a,b,q] (.uint32 out)) :
    Canonical out ∧ value out=value x+value y := by
  apply KeygenPublicAlgebra.source_add x y out hx hy
  apply call_leaf_conversion .add (by decide) [a,b,q] _ _ _ source
  exact .cons _ _ _ _ _ _ _ (ax.trans (u32_self x).symm)
    (.cons _ _ _ _ _ _ _ (by_.trans (u32_self y).symm)
      (.cons _ _ _ _ _ _ _ (qm.trans (u32_self modulus).symm) .nil))
theorem source_sub (x y out : BitVec 32) (a b q : Value)
    (hx : Canonical x) (hy : Canonical y) (ax : U32 a x) (by_ : U32 b y) (qm : U32 q modulus)
    (source : Call (name .sub) [a,b,q] (.uint32 out)) :
    Canonical out ∧ value out=value x-value y := by
  apply KeygenPublicAlgebra.source_sub x y out hx hy
  apply call_leaf_conversion .sub (by decide) [a,b,q] _ _ _ source
  exact .cons _ _ _ _ _ _ _ (ax.trans (u32_self x).symm)
    (.cons _ _ _ _ _ _ _ (by_.trans (u32_self y).symm)
      (.cons _ _ _ _ _ _ _ (qm.trans (u32_self modulus).symm) .nil))
theorem source_mul (x y out : BitVec 32) (a b q q0i : Value)
    (hx : Canonical x) (hy : Canonical y) (ax : U32 a x) (by_ : U32 b y)
    (qm : U32 q modulus) (qi : U32 q0i inverse)
    (source : Call (name .mul) [a,b,q,q0i] (.uint32 out)) :
    Canonical out ∧ value out*KeygenPublicAlgebra.radix=value x*value y := by
  apply KeygenPublicAlgebra.source_mul x y out hx hy
  apply call_leaf_conversion .mul (by decide) [a,b,q,q0i] _ _ _ source
  exact .cons _ _ _ _ _ _ _ (ax.trans (u32_self x).symm)
    (.cons _ _ _ _ _ _ _ (by_.trans (u32_self y).symm)
      (.cons _ _ _ _ _ _ _ (qm.trans (u32_self modulus).symm)
        (.cons _ _ _ _ _ _ _ (qi.trans (u32_self inverse).symm) .nil)))

theorem source_mul_exact (x y : BitVec 32) (a b q q0i v : Value)
    (ax : U32 a x) (by_ : U32 b y) (qm : U32 q modulus) (qi : U32 q0i inverse)
    (source : Call (name .mul) [a,b,q,q0i] v) :
    v=.uint32 (KeygenPublicLeafWords.montgomery x y modulus inverse) := by
  have conversion : Conversion (params .mul) [a,b,q,q0i] [.uint32 x,.uint32 y,.uint32 modulus,.uint32 inverse] :=
    .cons _ _ _ _ _ _ _ (ax.trans (u32_self x).symm)
      (.cons _ _ _ _ _ _ _ (by_.trans (u32_self y).symm)
        (.cons _ _ _ _ _ _ _ (qm.trans (u32_self modulus).symm)
          (.cons _ _ _ _ _ _ _ (qi.trans (u32_self inverse).symm) .nil)))
  have normalized := call_leaf_conversion .mul (by decide) _ _ v conversion source
  exact KeygenPublicLeafWords.source_mul _ x y modulus inverse v
    (KeygenPublicAlgebra.call_leaf .mul (by decide) _ _ normalized)

end FT1536.Source3.KeygenPublicArguments
