import Source3.KeygenPublicInputCells

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicInputAtoms
open C99ArrayReference (State Name bindValue)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicInputProgram (signed index converted condition increment)
open KeygenPublicInputCells (Signed)
open KeygenPublicTableAtoms (Slot var)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicAlgebra (Canonical value R)

theorem seq_inv (sgn : List Name) (a b : Stmt) (s : State) (out : Result)
    (normal : KeygenPublicTableControl.supported a=true)
    (source : Exec KeygenPublicSource.program sgn (.seq a b) s out) :
    ∃ middle, Exec KeygenPublicSource.program sgn a s ⟨middle,.normal⟩ ∧
      Exec KeygenPublicSource.program sgn b middle out := by
  cases source with
  | seqNormal _ _ _ middle _ first second => exact ⟨middle,first,second⟩
  | seqExit _ _ _ _ first exit => exact (exit (KeygenPublicTableControl.frame _ _ _ _ _ normal first).1).elim

theorem word64 (sgn : List Name) (s : State) (name : String) (n : Nat) (v : Value)
    (slot : USlot s name n) (source : KeygenPublicWord.Eval sgn s (var name) v) : v=u64 n := by
  cases source
  exact KeygenPublicTableIndex.variable64 s name n v slot ‹_›

theorem index_address (s : State) (name : String) (p actual : ArrayPointer) (i : Nat) (hi : i<2^64)
    (binding : s.arrays name.toList=some p) (counter : USlot s "u" i)
    (source : KeygenPublicWord.Address s name.toList index actual) : actual=KeygenSmallOutput.element p i := by
  apply KeygenPublicTableIndex.address s name index p actual i binding _ source
  intro v evaluated
  rw [KeygenPublicTableIndex.variable64 s "u" i v counter evaluated]
  exact KeygenNttLoopSupport.u64_toNat i hi

theorem converted_value (s : State) (name : String) (p : ArrayPointer) (a : Nat → Int) (i : Nat)
    (hi : i<1536) (member : name.toList∈signed) (binding : s.arrays name.toList=some p)
    (counter : USlot s "u" i) (q : Slot s "q" 18433) (input : Signed s.heap p a)
    (v : Value) (source : KeygenPublicWord.Eval signed s (converted name) v) :
    ∃ w, v=.uint32 w ∧ Canonical w ∧ value w=(a i : R) := by
  cases source with
  | call2 _ _ _ av qv _ first second called =>
      have qe := KeygenPublicTableAtoms.variable_value signed s "q" 18433 qv q second
      subst qv
      cases first with
      | load16 _ _ actual inputWord address loaded =>
          rw [index_address s name p actual i (by omega) binding counter address] at loaded
          obtain ⟨old,read,eq,lower,upper⟩ := input i hi
          have we := C99NarrowReads.load16_deterministic _ _ _ _ loaded read
          subst inputWord
          have isSigned : signed.contains name.toList=true := List.contains_iff_mem.mpr member
          simp only [isSigned,ite_true] at called
          have exactInt : (BitVec.ofInt 32 old.toInt).toInt=old.toInt := C99NarrowReads.signed_promotion_exact old
          have normalized := KeygenPublicAlgebra.call_leaf .conv (by decide) _ _ called
          have returned := KeygenPublicLeafWords.source_conv _ (BitVec.ofInt 32 old.toInt) 18433 v normalized
          rw [returned] at called ⊢
          obtain ⟨range,law⟩ := KeygenPublicAlgebra.source_conv _ _
            (by rw [exactInt,eq]; exact lower) (by rw [exactInt,eq]; exact upper) called
          exact ⟨_,rfl,range,law.trans (by rw [exactInt,eq])⟩

theorem store (s : State) (out : Result) (dst src : String) (p input : ArrayPointer)
    (a : Nat → Int) (i : Nat) (hi : i<1536) (member : src.toList∈signed)
    (destination : s.arrays dst.toList=some p) (binding : s.arrays src.toList=some input)
    (counter : USlot s "u" i) (q : Slot s "q" 18433) (material : Signed s.heap input a)
    (source : Exec KeygenPublicSource.program signed (.store dst.toList index false (converted src)) s out) :
    ∃ w, Canonical w ∧ value w=(a i : R) ∧
      KeygenSmallOutput.Store16 s.heap (KeygenSmallOutput.element p i)
        (KeygenPublicWord.narrow (.uint32 w)) out.state.heap := by
  cases source with
  | store _ _ _ _ before heap actual v address evaluated write =>
      rw [index_address s dst p actual i (by omega) destination counter address] at write
      obtain ⟨w,eq,range,law⟩ := converted_value s src input a i hi member binding counter q material v evaluated
      subst v
      exact ⟨w,range,law,write⟩

theorem guard (s : State) (i : Nat) (hi : i≤1536) (v : Value)
    (u : USlot s "u" i) (n : USlot s "n" 1536)
    (source : KeygenPublicWord.Eval signed s condition v) : v=C99ScalarReference.boolean (decide (i<1536)) := by
  cases source with
  | cmp _ _ _ a b _ first second op =>
      have ae := word64 signed s "u" i a u first
      have be := word64 signed s "n" 1536 b n second
      subst a; subst b
      have equal := C99CountedWords.comparison_result _ _ _ v op
      change v=C99ScalarReference.boolean (C99IntegerReference.compare .lt
        (C99IntegerReference.convert .uint64 (u64 i).integer).integer
        (C99IntegerReference.convert .uint64 (u64 1536).integer).integer) at equal
      rw [KeygenNttLoopSupport.convert_u64_self i (by omega),
        KeygenNttLoopSupport.convert_u64_self 1536 (by decide),
        KeygenNttLoopSupport.u64_integer i (by omega),KeygenNttLoopSupport.u64_integer 1536 (by decide)] at equal
      have comparison : (((i : Nat) : Int)<((1536 : Nat) : Int)) ↔ i<1536 := by omega
      simpa only [C99IntegerReference.compare,comparison] using equal

theorem increment_result (s : State) (out : Result) (i : Nat) (hi : i<1536)
    (counter : USlot s "u" i) (source : Exec KeygenPublicSource.program signed increment s out) :
    out=⟨bindValue s "u".toList .uint64 (u64 (i+1)),.normal⟩ := by
  cases source with
  | scalar _ before env executed =>
      cases executed with
      | assign _ _ _ ty old v declared evaluated =>
          have slot := Option.some.inj (declared.symm.trans counter)
          have te := congrArg Prod.fst slot
          dsimp only at te
          subst ty
          cases evaluated with
          | arithmetic _ _ _ a b _ left right operation =>
              have ae := KeygenPublicTableIndex.variable64 s "u" i a counter left
              subst a
              cases right
              have equal := KeygenNttLoopSupport.add_one_literal i (by omega) v operation
              rw [equal]
              rfl

theorem increment_counter (s : State) (i : Nat) (hi : i<1536) :
    USlot (bindValue s "u".toList .uint64 (u64 (i+1))) "u" (i+1) := by
  simp only [USlot,bindValue,C99ScalarReference.set,ite_true,
    KeygenNttLoopSupport.convert_u64_self (i+1) (by omega)]

end FT1536.Source3.KeygenPublicInputAtoms
