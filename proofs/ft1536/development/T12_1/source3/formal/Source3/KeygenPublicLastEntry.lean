import Source3.KeygenPublicLastLoop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicLastEntry
open C99ArrayReference (State bindValue)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (Slot var literal)
open KeygenPublicTableSeed (take_step)
open KeygenPublicLastProgram (initK initB initU loop)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableStore (Separate Pointers Word)
open KeygenPublicLastBody (Fixed)
open KeygenPublicLastLoop (Invariant)

def start (s : State) : State := KeygenPublicTableRows.ready (KeygenPublicTableSeed.ready s)
def kReady (s : State) : State := bindValue (start s) "k".toList .uint32 (.uint32 1)
def bReady (s : State) : State := bindValue (kReady s) "b".toList .uint64 (u64 512)
def ready (s : State) : State := bindValue (bReady s) "u".toList .uint64 (u64 0)
theorem bind_heap (s : State) (name : C99ArrayReference.Name) (ty : C99IntegerReference.Ty) (v : Value) :
    (bindValue s name ty v).heap=s.heap := rfl
theorem rows_heap (s : State) : (KeygenPublicTableRows.ready s).heap=s.heap := by
  rw [KeygenPublicTableRows.ready,bind_heap,KeygenPublicTableRows.inverseTwoReady,bind_heap,
    KeygenPublicTableRows.fourReady,bind_heap,KeygenPublicTableRows.twoReady,bind_heap,
    KeygenPublicTableRows.ixReady,bind_heap,KeygenPublicTableRows.xReady,bind_heap]
  rfl
theorem ready_heap (s : State) : (ready s).heap=s.heap := by
  rw [ready,bind_heap,bReady,bind_heap,kReady,bind_heap,start,rows_heap]
  exact (KeygenPublicTableSeed.ready_memory s).1

theorem start_profile (s : State) (profile : Slot s "logn" 10) : Slot (start s) "logn" 10 := profile
theorem start_k (s : State) : (start s).locals "k".toList=some (.uint32,some (.uint32 12)) := rfl
theorem kReady_profile (s : State) (profile : Slot s "logn" 10) : Slot (kReady s) "logn" 10 :=
  KeygenPublicTableAtoms.slot_preserved _ _ _ _ _ _ (by decide) (start_profile s profile)
theorem kReady_b (s : State) : (kReady s).locals "b".toList=some (.uint64,none) := rfl
theorem bReady_u (s : State) : (bReady s).locals "u".toList=some (.uint64,none) := rfl
theorem k_value (s : State) (v : Value) (profile : Slot s "logn" 10)
    (source : KeygenPublicWord.Eval [] s (.bin .sub (literal 11) (var "logn")) v) : v=.uint32 1 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := KeygenPublicTableAtoms.literal_value [] s 11 a left
      have bv := KeygenPublicTableAtoms.variable_value [] s "logn" 10 b profile right
      subst a; subst b
      exact ((C99IntegerReference.arithmetic_iff _ _ _ _).mp op).2
theorem logn_minus_one (s : State) (v : Value) (profile : Slot s "logn" 10)
    (source : KeygenPublicWord.Eval [] s (.bin .sub (var "logn") (literal 1)) v) : v=.uint32 9 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := KeygenPublicTableAtoms.variable_value [] s "logn" 10 a profile left
      have bv := KeygenPublicTableAtoms.literal_value [] s 1 b right
      subst a; subst b
      exact ((C99IntegerReference.arithmetic_iff _ _ _ _).mp op).2
theorem size_one (s : State) (v : Value)
    (source : KeygenPublicWord.Eval [] s (.cast .uint64 (literal 1)) v) : v=u64 1 := by
  cases source with
  | cast _ _ value evaluated =>
      rw [KeygenPublicTableAtoms.literal_value [] s 1 value evaluated]
      rfl
theorem b_value (s : State) (v : Value) (profile : Slot s "logn" 10)
    (source : KeygenPublicWord.Eval [] s
      (.bin .shl (.cast .uint64 (literal 1)) (.bin .sub (var "logn") (literal 1))) v) : v=u64 512 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := size_one s a left
      have bv := logn_minus_one s b profile right
      subst a; subst b
      obtain ⟨n,hn,_,equal⟩ := KeygenNttForwardExec.shift_left_value _ _ v op
      have nine : n=9 := by change (9 : Int)=(n : Int) at hn; omega
      subst n
      exact equal
theorem assign64_result (s : State) (out : Result) (name : String) (e : KeygenWordExpr.Expr) (v : Value)
    (declared : ∃ old, s.locals name.toList=some (.uint64,old))
    (value : ∀ z, KeygenPublicWord.Eval [] s e z → z=v)
    (source : Exec KeygenPublicSource.program [] (.assign name.toList e) s out) :
    out=⟨bindValue s name.toList .uint64 v,.normal⟩ := by
  obtain ⟨old,bound⟩ := declared
  cases source with
  | assign _ _ _ ty previous z slot evaluated =>
      have te := congrArg Prod.fst (Option.some.inj (slot.symm.trans bound))
      dsimp only at te
      subst ty
      rw [value z evaluated]
theorem init_k (s : State) (out : Result) (profile : Slot s "logn" 10)
    (source : Exec KeygenPublicSource.program [] initK (start s) out) : out=⟨kReady s,.normal⟩ :=
  KeygenPublicTableAtoms.assign_result _ _ _ "k" _ 1 out ⟨some (.uint32 12),start_k s⟩
    (fun v hv => k_value _ v (start_profile s profile) hv) source
theorem init_b (s : State) (out : Result) (profile : Slot s "logn" 10)
    (source : Exec KeygenPublicSource.program [] initB (kReady s) out) : out=⟨bReady s,.normal⟩ :=
  assign64_result _ out "b" _ (u64 512) ⟨none,kReady_b s⟩
    (fun v hv => b_value _ v (kReady_profile s profile) hv) source
theorem init_u (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program [] initU (bReady s) out) : out=⟨ready s,.normal⟩ := by
  have result := assign64_result _ out "u" _ (C99IntegerReference.convert .int32 0) ⟨none,bReady_u s⟩
    (fun v hv => KeygenPublicTableAtoms.literal_value [] _ 0 v hv) source
  exact result

theorem ready_other (s : State) (name : String) (nk : name≠"k") (nb : name≠"b") (nu : name≠"u") :
    (ready s).locals name.toList=(start s).locals name.toList := by
  rw [ready,KeygenPublicTableSeed.unchanged_cell _ name "u" _ _ nu,
    bReady,KeygenPublicTableSeed.unchanged_cell _ name "b" _ _ nb,
    kReady,KeygenPublicTableSeed.unchanged_cell _ name "k" _ _ nk]
theorem ready_word (s : State) (name : String) (w : BitVec 32) (z : KeygenPublicAlgebra.R)
    (nk : name≠"k") (nb : name≠"b") (nu : name≠"u")
    (slot : Slot (start s) name w) (scaled : KeygenPublicDivisionAlgebra.Scaled w z) : Word (ready s) name z :=
  ⟨w,(ready_other s name nk nb nu).trans slot,scaled⟩
theorem ready_k (s : State) : Slot (ready s) "k" 1 := by
  exact KeygenPublicTableAtoms.slot_preserved _ _ _ _ _ _ (by decide)
    (KeygenPublicTableAtoms.slot_preserved _ _ _ _ _ _ (by decide) (KeygenPublicTableAtoms.slot_after _ _ _))
theorem ready_b (s : State) : USlot (ready s) "b" 512 := rfl
theorem ready_u (s : State) : USlot (ready s) "u" 0 := rfl
theorem ready_fixed (s : State) (gm igm : ArrayPointer) (pointers : Pointers s gm igm) : Fixed gm igm (ready s) := by
  have slots := KeygenPublicTableRows.slots (KeygenPublicTableSeed.ready s)
  have scales := KeygenPublicTableRows.scaled_seeds
  exact ⟨pointers,ready_k s,ready_b s,
    ready_word s "g2" _ _ (by decide) (by decide) (by decide) slots.2.2.1 scales.1,
    ready_word s "g4" _ _ (by decide) (by decide) (by decide) slots.2.2.2.1 scales.2.1,
    ready_word s "ig2" _ _ (by decide) (by decide) (by decide) slots.2.2.2.2.1 scales.2.2.1,
    ready_word s "ig4" _ _ (by decide) (by decide) (by decide) slots.2.2.2.2.2 scales.2.2.2⟩
theorem initial_invariant (s : State) (gm igm : ArrayPointer) (pointers : Pointers s gm igm) :
    Invariant gm igm s.heap 0 (ready s) := by
  have slots := KeygenPublicTableRows.slots (KeygenPublicTableSeed.ready s)
  refine ⟨by decide,ready_fixed s gm igm pointers,ready_u s,?_,?_,?_,?_,?_⟩
  · have word := ready_word s "x" _ _ (by decide) (by decide) (by decide) slots.1 KeygenPublicTableSeed.root_scaled
    simpa only [KeygenMkgm3Rows.exponent,Nat.mul_zero,Nat.zero_add,Nat.zero_mod,Nat.add_zero,pow_one] using word
  · have word := ready_word s "ix" _ _ (by decide) (by decide) (by decide) slots.2.1 KeygenPublicTableSeed.inverse_scaled
    simpa only [KeygenMkgm3Rows.exponent,Nat.mul_zero,Nat.zero_add,Nat.zero_mod,Nat.add_zero,pow_one] using word
  · intro i hi
    omega
  · rw [ready_heap]
    exact fun _ _ _ _ _ h => h
  · rw [ready_heap]
    exact KeygenPublicTableStore.frame_refl gm igm s.heap

theorem remaining_result (s : State) (out : Result) (gm igm : ArrayPointer)
    (profile : Slot s "logn" 10) (pointers : Pointers s gm igm)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] KeygenPublicTableRows.remaining (start s) out) :
    out.flow=.normal ∧ Invariant gm igm s.heap 256 out.state := by
  rw [KeygenPublicLastProgram.source_remaining] at source
  have rest1 := take_step initK _ (start s) (kReady s) out (fun r => init_k s r profile) source
  have rest2 := take_step initB _ (kReady s) (bReady s) out (fun r => init_b s r profile) rest1
  obtain ⟨after,executed,last⟩ := KeygenPublicTableControl.seq_inv _ _ (bReady s) out (by decide) rest2
  have loopExec := take_step initU loop (bReady s) (ready s) ⟨after,.normal⟩ (init_u s) executed
  have result := KeygenPublicLastLoop.source_loop (ready s) ⟨after,.normal⟩ gm igm s.heap 0
    (initial_invariant s gm igm pointers) gw iw separate loopExec
  cases last
  exact result

end FT1536.Source3.KeygenPublicLastEntry
