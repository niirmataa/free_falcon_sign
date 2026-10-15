import Source3.FftLoopInvariant141
import Source3.FftLoopFrame141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftLoopStep141
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open C99WordBuffer140 (Represents)
open FftLoopInvariant141 (Fixed)

/-- Total word-vector step; the fallback is outside the source loop domain. -/
def advance (n hn ht v : Nat) (length : 2*hn≤n) (sr si : BitVec 64) (values : Fin n → BitVec 64) : Fin n → BitVec 64 :=
  if inside : v+ht<hn then
    FftButterflyBuffer140.nextValues values (FftLoopIndices141.slots n hn ht v inside length) sr si
  else values

/-- One symbolic source iteration discharges the butterfly entry from the
    caller invariant, then executes the original counter increment. -/
theorem source (s : State) (base : ArrayPointer) (n hn ht stop v : Nat) (sr si : BitVec 64)
    (values : Fin n → BitVec 64) (fixed : Fixed s base n hn ht stop sr si)
    (counter : Cell s "v".toList v) (represented : Represents s.heap base values) (remaining : v<stop) :
    ∃ middle after,
      C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.butterflyBody s ⟨middle,.normal⟩ ∧
      C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.butterflyIncrement middle ⟨after,.normal⟩ ∧
      Fixed after base n hn ht stop sr si ∧ Cell after "v".toList (v+1) ∧
      Represents after.heap base (advance n hn ht v fixed.length sr si values) ∧ FftLoopFrame141.Frame base n s after := by
  have endBound := fixed.stopBound
  have length := fixed.length
  have wordBound := fixed.wordBound
  have inside : v+ht<hn := by omega
  let slots := FftLoopIndices141.slots n hn ht v inside fixed.length
  let middle := FftButterflyBuffer140.nextState s base values slots sr si
  let after := FftLocalCells140.put middle "v".toList (C99NatWord141.word (v+1))
  have addresses := FftLoopIndices141.addresses s base n hn ht v inside fixed.length fixed.wordBound
    fixed.capacity fixed.binding counter fixed.hnCell fixed.htCell
  have body := FftButterflyBuffer140.source_and_invariant s base values slots sr si represented
    fixed.width fixed.writable addresses fixed.realCell fixed.imagCell
  have kept : Fixed middle base n hn ht stop sr si :=
    FftLoopInvariant141.transfer s middle base n hn ht stop sr si fixed rfl rfl rfl
  have updated : C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.butterflyIncrement
      middle ⟨after,.normal⟩ := by
    rw [FftLoopShape141.increment]
    exact C99LoopScalar141.increment KeygenSearchFft.program middle "v".toList v (by omega) counter
  refine ⟨middle,after,body.1,updated,
    FftLoopInvariant141.counter_update middle base n hn ht stop sr si kept _,
    FftLocalCells140.cell_at middle "v".toList (C99NatWord141.word (v+1)),?_,
    FftLoopFrame141.trans base n s middle after (FftLoopFrame141.body s base values slots sr si fixed.width)
      (FftLoopFrame141.counter base n middle _)⟩
  change Represents middle.heap base (advance n hn ht v fixed.length sr si values)
  unfold advance
  rw [dite_eq_left inside]
  exact body.2

end FT1536.Source3.FftLoopStep141
