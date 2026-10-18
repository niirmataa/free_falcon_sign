import Source3.PublicQuotientLoop171
import Source3.KeygenPublicStability

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedQuotient171
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99MemoryReference (Memory)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed)
open SelectedPublicStart157 (t)
open SelectedPublicBinding157 (h)

noncomputable def before := SelectedForwardT168.output

theorem forward_stable : KeygenMemoryStability.Stable SelectedPublicConvert158.after.heap before.heap :=
  KeygenPublicStability.body _ _ _ _ _ SelectedForwardT168.both

theorem data : PublicForwardMemory167.Data before.heap h := by
  refine ⟨(congrFun forward_stable.writable h.block).trans SelectedForwardInputs168.h_data.writable,?_⟩
  intro j hj
  obtain ⟨w,read,_,_⟩ := SelectedEvaluation169.source.2.1 ⟨j,hj⟩
  exact ⟨w,read⟩

theorem fixed : PublicQuotientBody171.Fixed before t h := by
  refine ⟨SelectedPublicNttEntry158.h_binding,SelectedPublicNttEntry158.t_binding,
    SelectedPublicNttEntry158.n,SelectedPublicNttEntry158.logn,SelectedPublicNttEntry158.ternary,
    by decide,data,?_⟩
  intro j hj
  obtain ⟨w,read,_,nz⟩ := SelectedTreeNonzero170.t_nonzero ⟨j,hj⟩
  exact ⟨w,read,nz⟩

theorem exists_pass : ∃ after, Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.pass before ⟨after,.normal⟩ ∧
    PublicQuotientBody171.Fixed after t h ∧ C99LoopScalar141.Cell after "u".toList 1536 ∧
    PublicMiddleWrites161.MemoryFrame before after h :=
  PublicQuotientLoop171.source before t h fixed _ SelectedPublicNttEntry158.counter

noncomputable def after : State := Classical.choose exists_pass
theorem source : Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.pass before ⟨after,.normal⟩ :=
  (Classical.choose_spec exists_pass).1
theorem output_fixed : PublicQuotientBody171.Fixed after t h := (Classical.choose_spec exists_pass).2.1

theorem fresh_stable (a b : Memory) (block : Nat) (stable : KeygenMemoryStability.Stable a b)
    (fresh : KeygenRngSource.Fresh a block) : KeygenRngSource.Fresh b block :=
  ⟨(congrFun stable.size block).trans fresh.1,(congrFun stable.writable block).trans fresh.2.1,
    fun offset => (stable.readonly block offset fresh.2.1).trans (fresh.2.2 offset)⟩

theorem stable : KeygenMemoryStability.Stable SelectedPublicConvert158.after.heap after.heap :=
  KeygenMemoryStability.trans _ _ _ forward_stable (KeygenPublicStability.body _ _ _ _ _ source)

theorem g_fresh : KeygenRngSource.Fresh after.heap 33 := fresh_stable _ _ 33 stable SelectedForwardInputs168.g_fresh
theorem i_fresh : KeygenRngSource.Fresh after.heap 34 := fresh_stable _ _ 34 stable SelectedForwardInputs168.i_fresh

def remaining := KeygenPublicExec.chain [KeygenPublicSuffixProgram.inverse,KeygenPublicSuffixProgram.success]

theorem continue_suffix (out : Result) (tail : Exec KeygenPublicSource.program signed remaining after out) :
    Exec KeygenPublicSource.program signed KeygenPublicInputProgram.suffix before out := by
  rw [KeygenPublicSuffixProgram.source_complete]
  exact .seqNormal _ _ _ after _ source tail

theorem continue_public (out : Result) (tail : Exec KeygenPublicSource.program signed remaining after out) :
    Exec KeygenPublicSource.program signed SelectedPublicStart157.remaining SelectedPublicStart157.ready out :=
  SelectedPublicConvert158.continue_body out (SelectedForwardT168.continue_suffix out (continue_suffix out tail))

end FT1536.Source3.SelectedQuotient171
