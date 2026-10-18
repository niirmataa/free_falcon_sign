import Source3.ModpDivLoop178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModpDivLoopWord178
open C99ArrayReference (State)
open C99ModularReference (GenExec LeafCall)
open KeygenModpR2Exec (Slot)
open ModpDivControl178 (counter lower loop)
open ModpDivStep178 (Fixed)

def word (b p p0i e : BitVec 32) : Nat → BitVec 32 → BitVec 32
  | 0,z => z
  | n+1,z => word b p p0i e n (ModpDivStep178.word z b p p0i e n)

theorem source (n : Nat) (bound : n≤31) (s : State) (a b p p0i e z : BitVec 32)
    (params : Fixed s a b p p0i e) (hz : Slot s "z" z)
    (hi : s.locals "i".toList=some (.int32,some (.int32 (counter n)))) :
    ∃ out, GenExec LeafCall loop s ⟨out,.normal⟩ ∧ Fixed out a b p p0i e ∧
      Slot out "z" (word b p p0i e n z) ∧ out.locals "i".toList=some (.int32,some (.int32 (counter 0))) ∧ out.heap=s.heap := by
  induction n generalizing s z with
  | zero =>
    exact ⟨s,.loopFalse _ _ _ s (.int32 0)
      (.compare .ge _ _ _ _ _ (.variable _ _ _ hi) (.literal .int32 0) ModpDivControl178.negative_compare)
      rfl,params,hz,hi,rfl⟩
  | succ n ih =>
    have nBound : n<31 := by omega
    have start : s.locals "i".toList=some (.int32,some (.int32 (ModpDivSelect178.index n))) := by
      rw [ModpDivControl178.counter_succ] at hi
      exact hi
    let middle := ModpDivStep178.after s z b p p0i e n
    let next := lower middle n
    have middleI : middle.locals "i".toList=some (.int32,some (.int32 (ModpDivSelect178.index n))) := start
    have nextZ : Slot next "z" (ModpDivStep178.word z b p p0i e n) := ModpDivStep178.z_after s b p p0i e z n
    obtain ⟨out,rest,outFixed,outZ,outI,outHeap⟩ := ih (by omega) next (ModpDivStep178.word z b p p0i e n)
      (ModpDivControl178.fixed middle a b p p0i e n (ModpDivStep178.fixed_after s a b p p0i e z n params))
      nextZ (ModpDivControl178.lower_slot middle n)
    refine ⟨out,?_,outFixed,outZ,outI,outHeap⟩
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ (.int32 1)
      (.compare .ge _ _ _ _ _ (.variable _ _ _ start) (.literal .int32 0) (ModpDivControl178.positive_compare n nBound))
      (by decide) (ModpDivStep178.source s a b p p0i e z n nBound params hz start)
      (ModpDivControl178.decrement middle n nBound middleI) rest

end FT1536.Source3.ModpDivLoopWord178
