import Source3.ZintNormFixed207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormState207
open C99ArrayReference (State restoreScope)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open KeygenModpR2Exec (Slot)
open C99NatWord141 (word)
open ZintNormFixed207 (Fixed)
open KeygenZintCall (Exec)

def lower (s : State) (i : Nat) := set64 s "u" (word i)
 def prepared (s : State) (i : Nat) (p cc : BitVec 32) := ZintNormPrepare207.after (lower s i) p cc
 def tied (s : State) (i : Nat) (p cc : BitVec 32) := restoreScope (lower s i) (prepared s i p cc) [ZintNormWord194.wName] []

theorem decrement (s : State) (i : Nat) (bound : i+1 < 2^64) (uc : Cell s ZintNormWord194.uName (i+1)) :
    Exec ZintNormWord194.normHeadDec s ⟨lower s i,.normal⟩ := by
  refine ZintNormWord194.word_update s ZintNormWord194.uName .sub (.literal .i32 1) .uint64
    (.uint64 (word (i+1))) (.int32 1) (.uint64 (word i)) uc (.literal .int32 1) ?_
  change C99IntegerReference.ArithmeticExec .minus (KeygenNttLoopSupport.u64 (i+1)) (.int32 1) (KeygenNttLoopSupport.u64 i)
  have raw:=PublicGenerateIndex159.sub_one (i+1) (by omega) bound
  rw [Nat.add_sub_cancel,show C99IntegerReference.convert .int32 1=(.int32 1) by decide] at raw
  exact raw

theorem guard_pos (s : State) (i : Nat) (bound : i+1 < 2^64) (uc : Cell s ZintNormWord194.uName (i+1)) :
    KeygenWordExpr.Eval s ZintNormWord194.normGuard (.int32 1) := by
  have raw:=C99IntegerReference.CompareExec.step .gt (.uint64 (word (i+1))) (.int32 0) .uint64 rfl
    (.uint64 (word (i+1))) (.uint64 0) (CrtWordOps205.self64 _).symm rfl
  have same : (if C99IntegerReference.compare .gt (C99IntegerReference.Value.uint64 (word (i+1))).integer
      (C99IntegerReference.Value.uint64 0).integer then 1#32 else 0#32)=1#32 := by
    rw [C99NatWord141.integer (i+1) bound]
    simp [C99IntegerReference.compare,C99IntegerReference.Value.integer]
  rw [same] at raw
  exact .cmp _ _ _ _ _ _ (.scalar _ _ (C99LoopScalar141.read s ZintNormWord194.uName (i+1) uc))
    (WordAtoms205.literal _ 0) raw

theorem prepared_fixed (s : State) (px pp : ArrayPointer) (n i : Nat) (xv pv : Nat → BitVec 32) (cc : BitVec 32)
    (fixed : Fixed s px pp n xv pv) : Fixed (prepared s i (pv i) cc) px pp n xv pv := by
  apply ZintNormFixed207.transport s (prepared s i (pv i) cc) px pp n xv pv fixed rfl rfl
  exact (ZintNormPrepare207.outside (lower s i) (pv i) cc ZintNormWord194.lenName (by decide) (by decide)).trans
    (CrtState205.keep64 s "u" "len" (word i) (by decide))

theorem tied_fixed (s : State) (px pp : ArrayPointer) (n i : Nat) (xv pv : Nat → BitVec 32) (cc : BitVec 32)
    (fixed : Fixed s px pp n xv pv) : Fixed (tied s i (pv i) cc) px pp n xv pv := by
  apply ZintNormFixed207.transport (prepared s i (pv i) cc) (tied s i (pv i) cc) px pp n xv pv
    (prepared_fixed s px pp n i xv pv cc fixed) rfl rfl
  exact WordControl205.restored (lower s i) (prepared s i (pv i) cc) [ZintNormWord194.wName] ZintNormWord194.lenName (by decide)

theorem tied_u (s : State) (i : Nat) (p cc : BitVec 32) : Cell (tied s i p cc) ZintNormWord194.uName i := by
  exact (WordControl205.restored (lower s i) (prepared s i p cc) [ZintNormWord194.wName] ZintNormWord194.uName (by decide)).trans
    ((ZintNormPrepare207.outside (lower s i) p cc ZintNormWord194.uName (by decide) (by decide)).trans
      (CrtState205.cell64 s "u" (word i)))

theorem tied_cc (s : State) (i : Nat) (p cc : BitVec 32) : Slot (tied s i p cc) "cc" (p &&& 1) :=
  (WordControl205.restored (lower s i) (prepared s i p cc) [ZintNormWord194.wName] "cc".toList (by decide)).trans
    (ZintNormPrepare207.ccCell (lower s i) p cc)

theorem iterate (s : State) (px pp : ArrayPointer) (n i : Nat) (xv pv : Nat → BitVec 32) (cc : BitVec 32)
    (fixed : Fixed s px pp n xv pv) (slot : i < n) (uc : Cell s ZintNormWord194.uName (i+1)) (cc0 : Slot s "cc" cc)
    (out : C99ProcedureReference.Result)
    (rest : Exec (.seq ZintNormWord194.normBranch1 (.seq ZintNormWord194.normBranch2 ZintNormWord194.wskip))
      (prepared s i (pv i) cc) out) :
    Exec ZintNormWord194.normIter s ⟨restoreScope (lower s i) out.state [ZintNormWord194.wName] [],out.flow⟩ := by
  have bound : i+1 < 2^64 := by have h:=fixed.nBound; omega
  have loweredU : Cell (lower s i) ZintNormWord194.uName i := CrtState205.cell64 _ _ _
  have loweredCC : Slot (lower s i) "cc" cc := (CrtState205.keep64 s "u" "cc" (word i) (by decide)).trans cc0
  have inner:=ZintNormPrepare207.append_source (lower s i) pp i (pv i) cc fixed.pBinding loweredU
    (by omega) loweredCC (fixed.pRead i slot) out rest
  exact .seqNormal _ _ _ _ _ (decrement s i bound uc) (.scope _ _ _ _ _ inner)

end FT1536.Source3.ZintNormState207
