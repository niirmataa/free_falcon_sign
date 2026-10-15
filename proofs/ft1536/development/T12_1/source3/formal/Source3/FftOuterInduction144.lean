import Source3.FftOuterSchedule144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftOuterInduction144
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open FftOuterInvariant144 (Context)
open FftOuterSchedule144 (Plan finalT finalM values)
open FftMiddleShape139

theorem guard (s : State) (t stop : Nat) (tBound : t<2^64) (stopBound : stop<2^64)
    (tCell : Cell s "t".toList t) (stopCell : Cell s "tmin".toList stop) :
    C99ArrayReference.scalar s outerCondition (C99ScalarReference.boolean (decide (stop<t))) := by
  rw [FftOuterShape144.condition]
  exact C99OuterScalar144.greater s _ _ t stop tBound stopBound
    (C99LoopScalar141.read s _ t tCell) (C99LoopScalar141.read s _ stop stopCell)

/-- Original outer loop, from a checked finite schedule and source invariants. -/
theorem source (s : State) (base : ArrayPointer) (n hn stop count t m : Nat) (input : Fin n → BitVec 64)
    (context : Context s base n hn) (plan : Plan hn stop count t m) (stopBound : stop<2^64)
    (stopCell : Cell s "tmin".toList stop) (tCell : Cell s "t".toList t) (mCell : Cell s "m".toList m)
    (represented : Represents s.heap base input) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program outerLoop s ⟨after,.normal⟩ ∧
      Context after base n hn ∧ Cell after "t".toList (finalT count t) ∧ Cell after "m".toList (finalM count m) ∧
      Represents after.heap base (values n hn context.length count t m input) ∧ FftOuterFrame144.Frame base n s after := by
  induction count generalizing s t m input with
  | zero =>
    have zeroGuard : C99ArrayReference.scalar s outerCondition (.int32 0) := by
      have evaluated := guard s t stop plan.2 stopBound tCell stopCell
      have finished : ¬stop<t := by have limit := plan.1; omega
      simpa [finished,C99ScalarReference.boolean] using evaluated
    refine ⟨s,?_,context,tCell,mCell,represented,FftOuterFrame144.refl base n s⟩
    rw [outer_shape]
    exact .loopFalse _ _ _ s (.int32 0) zeroGuard (by decide)
  | succ count ih =>
    obtain ⟨positive,ready,tailPlan⟩ := plan
    have valid := FftOuterSchedule144.valid hn t m ready
    obtain ⟨middle,next,body,increment,nextContext,nextT,nextM,nextImage,stepFrame⟩ :=
      FftOuterStep144.source s base n hn t m input context valid tCell mCell represented
    have nextStop : Cell next "tmin".toList stop :=
      (stepFrame.locals "tmin".toList (by decide) (by decide)).trans stopCell
    obtain ⟨after,tail,lastContext,lastT,lastM,lastImage,tailFrame⟩ :=
      ih next (t/2) (m*2) _ nextContext tailPlan nextStop nextT nextM nextImage
    have positiveGuard : C99ArrayReference.scalar s outerCondition (.int32 1) := by
      have evaluated := guard s t stop valid.tBound stopBound tCell stopCell
      simpa [positive,C99ScalarReference.boolean] using evaluated
    refine ⟨after,?_,lastContext,lastT,lastM,lastImage,FftOuterFrame144.trans base n s next after stepFrame tailFrame⟩
    rw [outer_shape]
    rw [outer_shape] at tail
    exact .loopNormal _ _ _ s middle next _ (.int32 1) positiveGuard (by decide) body increment tail

end FT1536.Source3.FftOuterInduction144
