import Source3.ZintReduceStep209

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintReduceLoop209
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (elem)
open ZintModSignedWord194 (uName xName dName dlenName pName p0iName r2Name)
open ZintReduceStep209 (after stepWord)
open KeygenWordExec (Exec)

def fold (W : Nat → BitVec 32) (p pi r2 : BitVec 32) : Nat → BitVec 32 → BitVec 32
  | 0,acc => acc
  | i+1,acc => fold W p pi r2 i (stepWord acc (W i) p pi r2)

structure Fixed (s : State) (pd : ArrayPointer) (n : Nat) (W : Nat → BitVec 32) (p pi r2 : BitVec 32) : Prop where
  nBound : n < 2^64
  dBinding : s.arrays dName=some pd
  lenCell : Cell s dlenName n
  pCell : Slot s "p" p
  iCell : Slot s "p0i" pi
  rCell : Slot s "R2" r2
  capacity : pd.index+n ≤ pd.count
  data : ∀ i, i < n → Load32 s.heap (elem pd i) (W i)

theorem after_fixed (s : State) (pd : ArrayPointer) (n i : Nat) (W : Nat → BitVec 32) (p pi r2 acc a : BitVec 32)
    (fixed : Fixed s pd n W p pi r2) : Fixed (after s i acc a p pi r2) pd n W p pi r2 := by
  have hl:=ZintReduceStep209.locals s i acc a p pi r2
  exact ⟨fixed.nBound,fixed.dBinding,(hl dlenName (by decide) (by decide)).trans fixed.lenCell,
    (hl pName (by decide) (by decide)).trans fixed.pCell,(hl p0iName (by decide) (by decide)).trans fixed.iCell,
    (hl r2Name (by decide) (by decide)).trans fixed.rCell,fixed.capacity,fixed.data⟩

theorem source (k : Nat) (s : State) (pd : ArrayPointer) (n : Nat) (W : Nat → BitVec 32) (p pi r2 acc : BitVec 32)
    (fixed : Fixed s pd n W p pi r2) (within : k ≤ n) (uc : Cell s uName k) (xc : Slot s "x" acc) :
    ∃ out, Exec ZintModSignedWord194.leafLoop s ⟨out,.normal⟩ ∧ Fixed out pd n W p pi r2 ∧ Cell out uName 0 ∧
      Slot out "x" (fold W p pi r2 k acc) ∧ out.heap=s.heap ∧ out.arrays=s.arrays ∧
      (∀ name : Name, name≠uName → name≠xName → out.locals name=s.locals name) := by
  induction k generalizing s acc with
  | zero =>
    have test : KeygenWordExpr.Eval s ZintModSignedWord194.leafGuard (.int32 0) :=
      .cmp _ _ _ _ _ _ (.scalar _ _ (C99LoopScalar141.read s uName 0 uc))
        (WordAtoms205.literal _ 0) ZintNormWord194.gt_zero_false
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) test (by decide),fixed,uc,xc,rfl,rfl,fun _ _ _ => rfl⟩
  | succ k ih =>
    have slot : k < n := by omega
    have bound : k+1 < 2^64 := by have h:=fixed.nBound; omega
    have body:=ZintReduceStep209.source s pd k acc (W k) p pi r2 bound uc fixed.dBinding xc fixed.pCell fixed.iCell fixed.rCell (fixed.data k slot)
    have afterFixed:=after_fixed s pd n k W p pi r2 acc (W k) fixed
    obtain ⟨out,rest,finalFixed,finalU,finalX,heap,arrays,locals⟩:=ih (after s k acc (W k) p pi r2) (stepWord acc (W k) p pi r2)
      afterFixed (by omega) (ZintReduceStep209.uCell s k acc (W k) p pi r2) (ZintReduceStep209.xCell s k acc (W k) p pi r2)
    refine ⟨out,?_,finalFixed,finalU,finalX,heap,arrays,?_⟩
    · exact .loopNormal _ _ _ s (after s k acc (W k) p pi r2) (after s k acc (W k) p pi r2) ⟨out,.normal⟩ (.int32 1)
        (ZintNormState207.guard_pos s k bound uc) (by decide) body (ZintSubWord194.skip_run _) rest
    · intro name nu nx
      exact (locals name nu nx).trans (ZintReduceStep209.locals s k acc (W k) p pi r2 name nu nx)

end FT1536.Source3.ZintReduceLoop209
