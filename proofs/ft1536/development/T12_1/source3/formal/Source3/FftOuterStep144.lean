import Source3.FftOuterInvariant144
import Source3.FftGroupsInduction143
import Source3.FftPinned139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftOuterStep144
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open FftOuterInvariant144 (Context Valid)
open FftMiddleShape139

def values (n hn t m : Nat) (length : 2*hn≤n) (input : Fin n → BitVec 64) :=
  FftGroupsInduction143.values n hn (t/2) m t length (m/2) 0 input

theorem source (s : State) (base : ArrayPointer) (n hn t m : Nat) (input : Fin n → BitVec 64)
    (context : Context s base n hn) (valid : Valid hn t m)
    (tCell : Cell s "t".toList t) (mCell : Cell s "m".toList m) (represented : Represents s.heap base input) :
    ∃ middle after, C99ProcedureReference.Exec KeygenSearchFft.program outerBody s ⟨middle,.normal⟩ ∧
      C99ProcedureReference.Exec KeygenSearchFft.program outerIncrement middle ⟨after,.normal⟩ ∧
      Context after base n hn ∧ Cell after "t".toList (t/2) ∧ Cell after "m".toList (m*2) ∧
      Represents after.heap base (values n hn t m context.length input) ∧ FftOuterFrame144.Frame base n s after := by
  have fixed := FftOuterInvariant144.groups s base n hn t m context valid tCell mCell
  obtain ⟨tail,loop,tailFixed,_,_,image,frame⟩ := FftGroupsInduction143.source
    (FftOuterStates144.initial s t m) base n hn m t (t/2) (m/2) 0 input fixed
    (FftOuterStates144.u1 s t m) (by simpa only [Nat.zero_mul] using FftOuterStates144.v1 s t m) represented (Nat.zero_le _)
  have update : C99ProcedureReference.Exec KeygenSearchFft.program setTNext tail ⟨FftOuterFrame144.assigned tail t,.normal⟩ := by
    rw [FftControlShape142.next_t]
    exact C99ControlCells142.array_copy _ tail "t".toList "ht".toList t (t/2) tailFixed.tCell tailFixed.htCell
  have body : C99ProcedureReference.Exec KeygenSearchFft.program outerBody s ⟨FftOuterFrame144.closed s tail t,.normal⟩ := by
    have raw := FftReferenceCompose141.outer _ _ _ _ _
      (FftOuterSetup144.prologue s t m valid.tBound valid.mBound tCell mCell)
      (FftOuterSetup144.initialization s t m) loop update
    simpa only [FftOuterShape144.locals,FftOuterShape144.pointers,FftOuterFrame144.closed] using raw
  have closedM : Cell (FftOuterFrame144.closed s tail t) "m".toList m :=
    (FftOuterFrame144.body_local s tail t m base n frame "m".toList (by decide)).trans mCell
  have increment : C99ProcedureReference.Exec KeygenSearchFft.program outerIncrement
      (FftOuterFrame144.closed s tail t) ⟨FftOuterFrame144.next s tail t m,.normal⟩ := by
    rw [FftControlShape142.outer_increment]
    exact C99ControlShift142.double _ _ "m".toList m valid.mBound closedM
  have completeFrame := FftOuterFrame144.complete s tail t m base n frame
  refine ⟨FftOuterFrame144.closed s tail t,FftOuterFrame144.next s tail t m,body,increment,?_,
    FftOuterFrame144.next_t s tail t m,FftOuterFrame144.next_m s tail t m,?_,completeFrame⟩
  · exact FftOuterInvariant144.transfer s _ base n hn context completeFrame
      (FftPinned139.procedure _ _ _ _ increment (FftPinned139.procedure _ _ _ _ body context.pinned))
  · change Represents tail.heap base (FftGroupsInduction143.values n hn (t/2) m t context.length (m/2) 0 input)
    simpa only [Nat.sub_zero] using image

end FT1536.Source3.FftOuterStep144
