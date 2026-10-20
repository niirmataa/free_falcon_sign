import Source3.KeygenPublicRangeMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- A checked expression-range adapter for the actual public forward body.
   C integer promotion and parameter conversion remain explicit. The checker
   admits only unsigned16 reads, selected residue locals and the actual
   q18433 add/sub/Montgomery/square source calls with their exact constants. -/
namespace FT1536.Source3.KeygenPublicRangeExpr
open C99ArrayReference (State Name)
open C99IntegerReference (Value Ty convert)
open KeygenPublicWord (Eval)
open KeygenWordExpr (Expr)
open KeygenPublicAlgebra (Canonical)
open KeygenPublicMontgomery (modulus inverse)
open KeygenPublicArguments (U32)

def Ranged (v : Value) : Prop := 0≤v.integer ∧ v.integer<18433
def word (v : Value) : BitVec 32 := BitVec.ofNat 32 v.integer.toNat
def Locals (names : List Name) (env : C99ScalarReference.Env) : Prop :=
  ∀ n∈names, ∀ ty v, env n=some (ty,some v) → Ranged v
def Arrays (names : List Name) (s : State) : Prop :=
  ∀ n∈names, ∀ p, s.arrays n=some p → KeygenPublicRangeMemory.Domain s.heap p

theorem word_nat (v : Value) (range : Ranged v) : (word v).toNat=v.integer.toNat := by
  unfold word
  rw [BitVec.toNat_ofNat]
  exact Nat.mod_eq_of_lt (by unfold Ranged at range; omega)
theorem word_range (v : Value) (range : Ranged v) : Canonical (word v) := by
  unfold Canonical
  rw [word_nat v range]
  unfold Ranged at range
  omega
theorem word_argument (v : Value) (range : Ranged v) : U32 v (word v) := by
  have cast : (v.integer.toNat : Int)=v.integer := Int.toNat_of_nonneg range.1
  calc
    convert .uint32 v.integer = convert .uint32 (v.integer.toNat : Int) := congrArg (convert .uint32) cast.symm
    _ = .uint32 (word v) := by rw [convert,BitVec.ofInt_natCast]; rfl

theorem uint32_range (w : BitVec 32) (range : Canonical w) : Ranged (.uint32 w) := by
  change 0≤(w.toNat : Int) ∧ (w.toNat : Int)<18433
  exact ⟨Int.natCast_nonneg _,by exact_mod_cast range⟩

theorem converted_nat (ty : Ty) (n : Nat) (small : n<18433) :
    (convert ty n).integer=(n : Int) := by
  cases ty with
  | uint64 =>
      change ((BitVec.ofInt 64 (n : Int)).toNat : Int)=(n : Int)
      rw [BitVec.ofInt_natCast,BitVec.toNat_ofNat]
      rw [Nat.mod_eq_of_lt (by omega)]
  | uint32 =>
      change ((BitVec.ofInt 32 (n : Int)).toNat : Int)=(n : Int)
      rw [BitVec.ofInt_natCast,BitVec.toNat_ofNat]
      rw [Nat.mod_eq_of_lt (by omega)]
  | int64 =>
      change (BitVec.ofInt 64 (n : Int)).toInt=(n : Int)
      rw [BitVec.ofInt_natCast]
      rw [BitVec.toInt_eq_toNat_of_lt (by simp only [BitVec.toNat_ofNat]; omega)]
      rw [BitVec.toNat_ofNat,Nat.mod_eq_of_lt (show n<2^64 from by omega)]
  | int32 =>
      change (BitVec.ofInt 32 (n : Int)).toInt=(n : Int)
      rw [BitVec.ofInt_natCast]
      rw [BitVec.toInt_eq_toNat_of_lt (by simp only [BitVec.toNat_ofNat]; omega)]
      rw [BitVec.toNat_ofNat,Nat.mod_eq_of_lt (show n<2^32 from by omega)]
theorem converted_integer (ty : Ty) (v : Value) (range : Ranged v) :
    (convert ty v.integer).integer=v.integer := by
  have cast : (v.integer.toNat : Int)=v.integer := Int.toNat_of_nonneg range.1
  have small : v.integer.toNat<18433 := by unfold Ranged at range; omega
  calc
    (convert ty v.integer).integer = (convert ty (v.integer.toNat : Int)).integer := congrArg (fun z => (convert ty z).integer) cast.symm
    _ = (v.integer.toNat : Int) := converted_nat ty _ small
    _ = v.integer := cast
theorem converted_range (ty : Ty) (v : Value) (range : Ranged v) : Ranged (convert ty v.integer) := by
  unfold Ranged
  rw [converted_integer ty v range]
  exact range

theorem narrowed_range (v : Value) (range : Ranged v) : (KeygenPublicWord.narrow v).toNat<18433 := by
  have cast : (v.integer.toNat : Int)=v.integer := Int.toNat_of_nonneg range.1
  have small : v.integer.toNat<18433 := by unfold Ranged at range; omega
  change (BitVec.ofInt 16 v.integer).toNat<18433
  rw [← cast,BitVec.ofInt_natCast,BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega)]
  exact small

theorem add_range (a b q v : Value) (left : Ranged a) (right : Ranged b)
    (qm : U32 q modulus)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .add) [a,b,q] v) : Ranged v := by
  have normalized := KeygenPublicArguments.call_leaf_conversion .add (by decide) [a,b,q]
    [.uint32 (word a),.uint32 (word b),.uint32 modulus] v
    (.cons _ _ _ _ _ _ _ ((word_argument a left).trans (KeygenPublicArguments.u32_self _).symm)
      (.cons _ _ _ _ _ _ _ ((word_argument b right).trans (KeygenPublicArguments.u32_self _).symm)
        (.cons _ _ _ _ _ _ _ (qm.trans (KeygenPublicArguments.u32_self _).symm) .nil))) source
  have equal := KeygenPublicLeafWords.source_add _ (word a) (word b) modulus v
    (KeygenPublicAlgebra.call_leaf .add (by decide) _ _ normalized)
  rw [equal] at normalized ⊢
  exact uint32_range _ (KeygenPublicAlgebra.source_add _ _ _ (word_range a left)
    (word_range b right) normalized).1

theorem sub_range (a b q v : Value) (left : Ranged a) (right : Ranged b)
    (qm : U32 q modulus)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .sub) [a,b,q] v) : Ranged v := by
  have normalized := KeygenPublicArguments.call_leaf_conversion .sub (by decide) [a,b,q]
    [.uint32 (word a),.uint32 (word b),.uint32 modulus] v
    (.cons _ _ _ _ _ _ _ ((word_argument a left).trans (KeygenPublicArguments.u32_self _).symm)
      (.cons _ _ _ _ _ _ _ ((word_argument b right).trans (KeygenPublicArguments.u32_self _).symm)
        (.cons _ _ _ _ _ _ _ (qm.trans (KeygenPublicArguments.u32_self _).symm) .nil))) source
  have equal := KeygenPublicLeafWords.source_sub _ (word a) (word b) modulus v
    (KeygenPublicAlgebra.call_leaf .sub (by decide) _ _ normalized)
  rw [equal] at normalized ⊢
  exact uint32_range _ (KeygenPublicAlgebra.source_sub _ _ _ (word_range a left)
    (word_range b right) normalized).1

theorem mul_range (a b q qi v : Value) (left : Ranged a) (right : Ranged b)
    (qm : U32 q modulus) (im : U32 qi inverse)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .mul) [a,b,q,qi] v) : Ranged v := by
  have equal := KeygenPublicArguments.source_mul_exact (word a) (word b) a b q qi v
    (word_argument a left) (word_argument b right) qm im source
  rw [equal]
  exact uint32_range _ (KeygenPublicMontgomery.word_contract _ _
    (word_range a left) (word_range b right)).1

theorem square_call (args : List Value) (v : Value)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .square) args v) :
    KeygenPublicScalar.Square (KeygenPublicScalar.name .square) args v := by
  cases source with
  | square _ _ _ execution => exact execution
theorem square_range (a q qi v : Value) (range : Ranged a) (qm : U32 q modulus) (im : U32 qi inverse)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .square) [a,q,qi] v) : Ranged v := by
  have equal := KeygenPublicSquare.source_square_arguments (word a) a q qi v
    (word_argument a range) qm im (square_call _ _ source)
  rw [equal]
  exact uint32_range _ (KeygenPublicMontgomery.word_contract _ _ (word_range a range) (word_range a range)).1

def checked (locals arrays : List Name) : Expr → Bool
  | .scalar (.var n) => locals.contains n
  | .load16 n _ => arrays.contains n
  | .call3 n a b c =>
      if n=KeygenPublicScalar.name .add then checked locals arrays a && checked locals arrays b && decide (c=KeygenPublicTableAtoms.literal 18433)
      else if n=KeygenPublicScalar.name .sub then checked locals arrays a && checked locals arrays b && decide (c=KeygenPublicTableAtoms.literal 18433)
      else if n=KeygenPublicScalar.name .square then checked locals arrays a && decide (b=KeygenPublicTableAtoms.literal 18433) && decide (c=KeygenPublicTableAtoms.literal 18431)
      else false
  | .call4 n a b c d => decide (n=KeygenPublicScalar.name .mul) && checked locals arrays a && checked locals arrays b &&
      decide (c=KeygenPublicTableAtoms.literal 18433) && decide (d=KeygenPublicTableAtoms.literal 18431)
  | _ => false

theorem expression (locals arrays : List Name) (s : State) (e : Expr) (v : Value)
    (localRange : Locals locals s.locals) (arrayRange : Arrays arrays s)
    (shape : checked locals arrays e=true) (source : Eval [] s e v) : Ranged v := by
  induction source with
  | scalar e v evaluated =>
      cases e <;> simp only [checked] at shape <;> try cases shape
      case var n =>
        cases evaluated with
        | «variable» _ ty v binding => exact localRange n (by simpa using shape) ty v binding
  | load16 n index p w address read =>
      cases address with
      | add root _ value binding evaluated nonnegative within =>
          cases within
          have range := arrayRange n (by simpa only [checked,List.contains_iff_mem] using shape)
            root binding value.integer.toNat w read
          change Ranged (C99NarrowReads.unsignedPromotion w)
          unfold Ranged
          rw [C99NarrowReads.unsigned_promotion_exact]
          exact ⟨Int.natCast_nonneg _,by exact_mod_cast range⟩
  | call3 n a b c av bv cv v first second third invoked ih1 ih2 ih3 =>
      simp only [checked] at shape
      split_ifs at shape with addName subName squareName
      · obtain ⟨both,last⟩ := Bool.and_eq_true_iff.mp shape
        obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp both
        have hc := of_decide_eq_true last
        subst c
        rw [addName] at invoked
        exact add_range av bv cv v (ih1 ha) (ih2 hb)
          (KeygenPublicTableAtoms.literal_argument [] s 18433 cv third) invoked
      · obtain ⟨both,last⟩ := Bool.and_eq_true_iff.mp shape
        obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp both
        have hc := of_decide_eq_true last
        subst c
        rw [subName] at invoked
        exact sub_range av bv cv v (ih1 ha) (ih2 hb)
          (KeygenPublicTableAtoms.literal_argument [] s 18433 cv third) invoked
      · obtain ⟨both,last⟩ := Bool.and_eq_true_iff.mp shape
        obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp both
        have hc := of_decide_eq_true last
        have hb' := of_decide_eq_true hb
        subst b; subst c
        rw [squareName] at invoked
        exact square_range av bv cv v (ih1 ha)
          (KeygenPublicTableAtoms.literal_argument [] s 18433 bv second)
          (KeygenPublicTableAtoms.literal_argument [] s 18431 cv third) invoked
  | call4 n a b c d av bv cv dv v first second third fourth invoked ih1 ih2 ih3 ih4 =>
      obtain ⟨triple,hd⟩ := Bool.and_eq_true_iff.mp shape
      obtain ⟨both,hc⟩ := Bool.and_eq_true_iff.mp triple
      obtain ⟨left,hb⟩ := Bool.and_eq_true_iff.mp both
      obtain ⟨hn,ha⟩ := Bool.and_eq_true_iff.mp left
      have ne := of_decide_eq_true hn
      have ce := of_decide_eq_true hc
      have de := of_decide_eq_true hd
      subst c; subst d
      rw [ne] at invoked
      exact mul_range av bv cv dv v (ih1 ha) (ih2 hb)
        (KeygenPublicTableAtoms.literal_argument [] s 18433 cv third)
        (KeygenPublicTableAtoms.literal_argument [] s 18431 dv fourth) invoked
  | cast | neg | bitNot | lnot | bin | cmp | andFalse | andTrue | orTrue | orFalse | call1 | call2 => cases shape

end FT1536.Source3.KeygenPublicRangeExpr
