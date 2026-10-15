import Source3.FftFirstFrame149
import Source3.C99ProcedureSegments136
import Source3.DisjointVectorPass152

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99VectorLoop155
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Program Stmt Exec)
open C99LoopScalar141 (Cell)
open FftFirstFrame149 (Frame)

def condition (boundName : Name) : CLogic.Expr := .cmp .lt (.var "u".toList) (.var boundName)
def increment : Stmt := .base (.scalar (.update "u".toList .add (.literal .i32 1)))

/-- A source body rule and invariant supply the full counted loop; no execution oracle is added. -/
structure Rule (program : Program) (body : Stmt) (boundName : Name) (limit : Nat)
    (base : ArrayPointer) (n : Nat) (step : Nat → (Fin n → BitVec 64) → (Fin n → BitVec 64))
    (Invariant : State → (Fin n → BitVec 64) → Prop) : Prop where
  wordBound : limit<2^64
  boundCell : ∀ s v, Invariant s v → Cell s boundName limit
  source : ∀ s u v, Invariant s v → Cell s "u".toList u → u<limit →
    ∃ middle after, Exec program body s ⟨middle,.normal⟩ ∧
      Exec program increment middle ⟨after,.normal⟩ ∧ Invariant after (step u v) ∧
      Cell after "u".toList (u+1) ∧ Frame base n s after

theorem prefix_source (program : Program) (body : Stmt) (boundName : Name) (limit : Nat)
    (base : ArrayPointer) (n : Nat) (step : Nat → (Fin n → BitVec 64) → (Fin n → BitVec 64))
    (Invariant : State → (Fin n → BitVec 64) → Prop) (rule : Rule program body boundName limit base n step Invariant)
    (count start : Nat) (s : State) (input : Fin n → BitVec 64)
    (inv : Invariant s input) (counter : Cell s "u".toList start) (range : start+count ≤ limit) :
    ∃ after, C99ProcedureSegments136.Prefix program (condition boundName) body increment count s after ∧
      Invariant after (DisjointVectorPass152.run step count start input) ∧
      Cell after "u".toList (start+count) ∧ Frame base n s after := by
  induction count generalizing start s input with
  | zero => exact ⟨s,.done _,inv,counter,FftFirstFrame149.refl base n s⟩
  | succ count ih =>
    have inside : start<limit := by omega
    obtain ⟨middle,next,head,update,nextInv,nextU,nextFrame⟩ := rule.source s start input inv counter inside
    obtain ⟨after,tail,lastInv,lastU,lastFrame⟩ := ih (start+1) next (step start input) nextInv nextU (by omega)
    have evaluated : C99ArrayReference.scalar s (condition boundName)
        (C99ScalarReference.boolean (decide (start<limit))) :=
      C99LoopScalar141.less s _ _ start limit (by have h:=rule.wordBound; omega) rule.wordBound
        (C99LoopScalar141.read s "u".toList start counter) (C99LoopScalar141.read s boundName limit (rule.boundCell s input inv))
    have guard : C99ArrayReference.scalar s (condition boundName) (.int32 1) := by
      simpa [inside,C99ScalarReference.boolean] using evaluated
    refine ⟨after,.next count s middle next after (.int32 1) guard (by decide) head update tail,lastInv,?_,
      FftFirstFrame149.trans base n s next after nextFrame lastFrame⟩
    simpa only [Nat.add_assoc,Nat.add_comm 1] using lastU

theorem source (program : Program) (body : Stmt) (boundName : Name) (limit : Nat)
    (base : ArrayPointer) (n : Nat) (step : Nat → (Fin n → BitVec 64) → (Fin n → BitVec 64))
    (Invariant : State → (Fin n → BitVec 64) → Prop) (rule : Rule program body boundName limit base n step Invariant)
    (start : Nat) (s : State) (input : Fin n → BitVec 64)
    (inv : Invariant s input) (counter : Cell s "u".toList start) (range : start ≤ limit) :
    ∃ after, Exec program (.loop (condition boundName) body increment) s ⟨after,.normal⟩ ∧
      Invariant after (DisjointVectorPass152.run step (limit-start) start input) ∧
      Cell after "u".toList limit ∧ Frame base n s after := by
  obtain ⟨after,head,lastInv,lastU,frame⟩ := prefix_source program body boundName limit base n step Invariant rule
    (limit-start) start s input inv counter (by omega)
  have endU : Cell after "u".toList limit := by simpa only [Nat.add_sub_of_le range] using lastU
  have evaluated : C99ArrayReference.scalar after (condition boundName)
      (C99ScalarReference.boolean (decide (limit<limit))) :=
    C99LoopScalar141.less after _ _ limit limit rule.wordBound rule.wordBound
      (C99LoopScalar141.read after "u".toList limit endU)
      (C99LoopScalar141.read after boundName limit (rule.boundCell after _ lastInv))
  have guard : C99ArrayReference.scalar after (condition boundName) (.int32 0) := by
    simpa [C99ScalarReference.boolean] using evaluated
  exact ⟨after,C99ProcedureSegments136.finish _ _ _ _ (limit-start) s after _ head
    (.loopFalse _ _ _ after (.int32 0) guard (by decide)),lastInv,endU,frame⟩

end FT1536.Source3.C99VectorLoop155
