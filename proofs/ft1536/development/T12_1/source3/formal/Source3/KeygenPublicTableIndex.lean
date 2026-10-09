import Source3.KeygenPublicLastProgram
import Source3.KeygenNttLoopSupport

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source size_t arithmetic, explicit unsigned cast, actual rev10 call and
   pointer addition for every reached last-row address. -/
namespace FT1536.Source3.KeygenPublicTableIndex
open C99ArrayReference (State)
open C99IntegerReference (Value Ty)
open KeygenPublicWord (scalar Eval Address)
open KeygenPublicTableAtoms (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicLastProgram (scalarVar shifted index u nextU)
open KeygenMkgm3Indices (lastIndex reverse9)

theorem variable_value (s : State) (name : String) (ty : Ty) (w v : Value)
    (slot : s.locals name.toList=some (ty,some w)) (source : scalar s (scalarVar name) v) : v=w := by
  cases source with
  | «variable» _ _ _ bound =>
      exact Option.some.inj (congrArg Prod.snd (Option.some.inj (bound.symm.trans slot)))
theorem variable64 (s : State) (name : String) (n : Nat) (v : Value)
    (slot : USlot s name n) (source : scalar s (scalarVar name) v) : v=u64 n :=
  variable_value s name .uint64 (u64 n) v slot source
theorem word64 (s : State) (name : String) (n : Nat) (v : Value)
    (slot : USlot s name n) (source : Eval [] s (KeygenPublicTableAtoms.var name) v) : v=u64 n := by
  cases source
  exact variable64 s name n v slot ‹_›
theorem literal (s : State) (n : Nat) (v : Value) (source : scalar s (.literal .i32 n) v) :
    v=C99IntegerReference.convert .int32 n := by cases source; rfl
theorem plus_literal (i d : Nat) (hi : i<2^64) (hd : d<2^31) (v : Value)
    (op : C99IntegerReference.ArithmeticExec .plus (u64 i) (C99IntegerReference.convert .int32 d) v) :
    v=u64 (i+d) := by
  have intLiteral : (C99IntegerReference.convert .int32 d).integer=(d : Int) := by
    exact BitVec.toInt_ofInt_eq_self (by decide) (by omega) (by norm_num; omega)
  have equal := ((C99IntegerReference.arithmetic_iff _ _ _ _).mp op).2
  change v=C99IntegerReference.convert .uint64
    ((C99IntegerReference.convert .uint64 (u64 i).integer).integer+
      (C99IntegerReference.convert .uint64 (C99IntegerReference.convert .int32 d).integer).integer) at equal
  rw [KeygenNttLoopSupport.convert_u64_self i hi,intLiteral,
    KeygenNttLoopSupport.convert_u64_nat,KeygenNttLoopSupport.u64_integer i hi,
    KeygenNttLoopSupport.u64_integer d (by omega),← Int.natCast_add,
    KeygenNttLoopSupport.convert_u64_nat] at equal
  exact equal
theorem next_value (s : State) (i : Nat) (hi : i<512) (v : Value)
    (slot : USlot s "u" i) (source : scalar s nextU v) : v=u64 (i+1) := by
  cases source with
  | arithmetic _ _ _ a b _ left right op =>
      have av := variable64 s "u" i a slot left
      have bv := literal s 1 b right
      subst a; subst b
      exact plus_literal i 1 (by omega) (by decide) v op
theorem shifted_value (s : State) (e : CLogic.Expr) (i : Nat) (hi : i<512) (v : Value)
    (k : Slot s "k" 1) (input : ∀ z, scalar s e z → z=u64 i)
    (source : scalar s (shifted e) v) : v=.uint32 (BitVec.ofNat 32 (2*i)) := by
  cases source with
  | cast _ _ a value =>
      cases value with
      | shift _ _ _ x y _ left right op =>
          have xv := input x left
          have yv := variable_value s "k" .uint32 (.uint32 1) y k right
          subst x; subst y
          obtain ⟨n,hn,_,equal⟩ := KeygenNttForwardExec.shift_left_value _ _ a op
          have one : n=1 := by change (1 : Int)=(n : Int) at hn; omega
          subst n
          change a=C99IntegerReference.convert .uint64 ((u64 i).integer*2^1) at equal
          rw [pow_one,KeygenNttLoopSupport.convert_mul_two i (by omega)] at equal
          rw [equal,KeygenNttLoopSupport.u64_integer (i*2) (by omega)]
          simp only [C99ValueBridge.type,C99IntegerReference.convert,BitVec.ofInt_natCast,Nat.mul_comm]
theorem plus_reverse (r : Nat) (hr : r<512) (v : Value)
    (op : C99IntegerReference.ArithmeticExec .plus (u64 512) (.uint32 (BitVec.ofNat 32 r)) v) :
    v=u64 (512+r) := by
  have rn : (BitVec.ofNat 32 r).toNat=r := Nat.mod_eq_of_lt (by omega)
  have equal := ((C99IntegerReference.arithmetic_iff _ _ _ _).mp op).2
  change v=C99IntegerReference.convert .uint64
    (512+(C99IntegerReference.convert .uint64 ((BitVec.ofNat 32 r).toNat : Int)).integer) at equal
  rw [rn,KeygenNttLoopSupport.convert_u64_nat,KeygenNttLoopSupport.u64_integer r (by omega)] at equal
  rw [show 512+(r : Int)=((512+r : Nat) : Int) by omega,
    KeygenNttLoopSupport.convert_u64_nat] at equal
  exact equal
theorem index_value (s : State) (e : CLogic.Expr) (i : Nat) (hi : i<512) (v : Value)
    (k : Slot s "k" 1) (b : USlot s "b" 512)
    (input : ∀ z, scalar s e z → z=u64 i) (source : scalar s (index e) v) :
    v=u64 (lastIndex i) := by
  cases source with
  | arithmetic _ _ _ x y _ left right op =>
      have xv := variable64 s "b" 512 x b left
      subst x
      cases right with
      | call1 _ _ arg _ evaluated called =>
          have av := shifted_value s e i hi arg k input evaluated
          subst arg
          obtain ⟨result,bound⟩ := KeygenPublicRevCert.source_last_index i hi y called
          subst y
          exact plus_reverse (reverse9 i) bound v op
theorem address (s : State) (name : String) (e : CLogic.Expr)
    (p actual : C99MemoryReference.ArrayPointer) (i : Nat)
    (binding : s.arrays name.toList=some p)
    (value : ∀ v, scalar s e v → v.integer.toNat=i) (source : Address s name.toList e actual) :
    actual=KeygenSmallOutput.element p i := by
  cases source with
  | add original _ v bound evaluated nonnegative within =>
      have equal := Option.some.inj (bound.symm.trans binding)
      subst original
      cases within
      rw [value v evaluated]
      rfl
theorem index_address (s : State) (name : String) (e : CLogic.Expr)
    (p actual : C99MemoryReference.ArrayPointer) (i : Nat) (hi : i<512)
    (binding : s.arrays name.toList=some p) (k : Slot s "k" 1) (b : USlot s "b" 512)
    (input : ∀ z, scalar s e z → z=u64 i) (source : Address s name.toList (index e) actual) :
    actual=KeygenSmallOutput.element p (lastIndex i) := by
  apply address s name (index e) p actual (lastIndex i) binding _ source
  intro v evaluated
  rw [index_value s e i hi v k b input evaluated]
  exact KeygenNttLoopSupport.u64_toNat _ (by
    have bound := ((KeygenMkgm3IndexCert.all_indices i (by omega)).1 hi).1
    unfold lastIndex
    omega)

end FT1536.Source3.KeygenPublicTableIndex
