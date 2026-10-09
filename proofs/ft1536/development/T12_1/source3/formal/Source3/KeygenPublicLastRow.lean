import Source3.KeygenPublicLastEntry

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Both physical last-row images are consequences of the SAME complete
   generator execution. The upward suffix remains an actual execution. -/
namespace FT1536.Source3.KeygenPublicLastRow
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer Memory)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicTableStore (Pointers Separate LastFrame)
open KeygenPublicTableCells (Cell)
open KeygenPublicRoots (root)
open KeygenMkgm3Indices (tableExponent lastIndex)

def Images (heap : Memory) (gm igm : ArrayPointer) : Prop :=
  ∀ i, 512 ≤ i → i<1024 → Cell heap gm i (root^tableExponent i) ∧ Cell heap igm i ((root⁻¹)^tableExponent i)
theorem physical_images (heap : Memory) (gm igm : ArrayPointer)
    (processed : KeygenPublicLastLoop.Processed gm igm 256 heap) : Images heap gm igm := by
  intro i lower upper
  obtain ⟨u,hu,equal⟩ := KeygenMkgm3Table.last_covers i lower upper
  have pair := processed u (by omega)
  have powers := ((KeygenMkgm3IndexCert.all_indices u (by omega)).1 hu).2.2
  rw [← powers,equal] at pair
  exact pair

theorem source_last_row (s : State) (out : Result) (gm igm : ArrayPointer)
    (profile : Slot s "logn" 10) (pointers : Pointers s gm igm)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate) s out) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicTableRows.afterRows after out ∧
      Images after.heap gm igm ∧ LastFrame gm igm s.heap after.heap ∧
      Pointers after gm igm ∧ Slot after "logn" 10 ∧ KeygenNttLoopSupport.USlot after "u" 512 := by
  obtain ⟨after,inner,executed,restored,normal,tail⟩ := KeygenPublicTableRows.source_last_row_entry s out profile source
  have result := KeygenPublicLastEntry.remaining_result s inner gm igm profile pointers gw iw separate executed
  have images := physical_images inner.state.heap gm igm result.2.cells
  have afterHeap : after.heap=inner.state.heap := by rw [restored]; rfl
  have afterPointers : after.arrays=inner.state.arrays := by rw [restored]; rfl
  have afterU : after.locals "u".toList=inner.state.locals "u".toList := by rw [restored]; rfl
  have profileInner : Slot inner.state "logn" 10 := by
    have cell := (KeygenPublicTableControl.frame _ _ KeygenPublicTableRows.remaining
      (KeygenPublicLastEntry.start s) inner (by decide) executed).2.2 "logn".toList (by decide)
    exact cell.trans (KeygenPublicLastEntry.start_profile s profile)
  have afterLogn : after.locals "logn".toList=inner.state.locals "logn".toList := by rw [restored]; rfl
  refine ⟨after,tail,?_,?_,?_,afterLogn.trans profileInner,afterU.trans result.2.counter⟩
  · simpa only [afterHeap] using images
  · simpa only [afterHeap] using result.2.bytes
  · simpa only [Pointers,afterPointers] using result.2.fixed.pointers

end FT1536.Source3.KeygenPublicLastRow
