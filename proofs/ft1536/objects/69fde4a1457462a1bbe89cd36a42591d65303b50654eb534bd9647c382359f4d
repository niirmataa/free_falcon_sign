import Source3.KeygenPublicNormalizeFold

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Consume the SAME retained normalization suffix and both actual table
   disposals. Final ordinary canonical cells are now conclusions. -/
namespace FT1536.Source3.KeygenPublicNormalizeEntry
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenPublicAlgebra (R)
open KeygenPublicInputCells (Cells)
open KeygenNttLoopSupport (USlot)
open KeygenPublicReverseEntry (Header)
open KeygenPublicRootInversePolynomial (rootImage)
open KeygenPublicNormalizeAtoms (inverseN)
open KeygenPublicNormalizeProgram
open KeygenPublicTableControl (frame seq_inv)

noncomputable def normalized (a : Nat → R) (j : Nat) : R := rootImage a j*inverseN

theorem source_remaining (a : Nat → R) (p igm : ArrayPointer) (s : State) (out : Result)
    (header : Header p igm s) (oldU : USlot s "u" 768) (cells : Cells s.heap p 1536 (rootImage a))
    (source : Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.remaining s out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (normalized a) := by
  rw [KeygenPublicNormalizeProgram.source_remaining] at source
  obtain ⟨s1,niExec,rest⟩ := seq_inv niSet _ s out (by decide) source
  obtain ⟨after,passExec,last⟩ := seq_inv pass .skip s1 out (by decide) rest
  cases last
  obtain ⟨entry,initExec,loopExec⟩ := seq_inv initU loop s1 ⟨after,.normal⟩ (by decide) passExec
  obtain ⟨ni,heap1⟩ := KeygenPublicNormalizeAtoms.source_ni s ⟨s1,.normal⟩ header.profile header.fixed.n header.niType niExec
  have f1 := frame _ [] niSet s ⟨s1,.normal⟩ (by decide) niExec
  have f2 := frame _ [] initU s1 ⟨entry,.normal⟩ (by decide) initExec
  have uType : KeygenPublicSizeOps.Declared s1 "u" := ⟨_,(f1.2.2 _ (by decide)).trans oldU⟩
  obtain ⟨u,heap2⟩ := KeygenPublicSizeOps.init s1 ⟨entry,.normal⟩ "u" 0 (by decide) uType initExec
  have pointer : entry.arrays "a".toList=some p := by rw [f2.2.1,f1.2.1]; exact header.fixed.pointer
  have n : USlot entry "n" 1536 := (f2.2.2 _ (by decide)).trans ((f1.2.2 _ (by decide)).trans header.fixed.n)
  have niEntry := KeygenPublicValueExpr.local_after initU s1 ⟨entry,.normal⟩ "ni" _ (by decide) (by decide) ni initExec
  have input : Cells entry.heap p 1536 (rootImage a) := by rw [heap2,heap1]; exact cells
  exact KeygenPublicNormalizeFold.source_loop (rootImage a) p inverseN entry ⟨after,.normal⟩
    header.fixed.width pointer n niEntry u input loopExec

theorem complete_output (a : Nat → R) (p : ArrayPointer) (out : Result)
    (run : KeygenPublicRootInverseEntry.Outcome a p out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (normalized a) := by
  obtain ⟨inner,⟨igm,s,header,u,_,cells,source⟩,flow,block⟩ := run
  obtain ⟨normal,final⟩ := source_remaining a p igm s inner header u cells source
  exact ⟨flow.trans normal,KeygenPublicFirstTables.cells_block _ _ p _ _ block final⟩

theorem source_inverse (a : Nat → R) (s : State) (out : Result) (p : ArrayPointer)
    (profile : KeygenPublicTableAtoms.Slot s "logn" 10) (input : s.arrays "a".toList=some p)
    (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverseT) s out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (normalized a) :=
  complete_output a p out (KeygenPublicRootInverseEntry.refine_outcome a p out
    (KeygenPublicReverseInvocation.source_reverse a s out p profile input cells source))

end FT1536.Source3.KeygenPublicNormalizeEntry
