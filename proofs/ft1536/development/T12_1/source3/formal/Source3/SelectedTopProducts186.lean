import Source3.SelectedTopR3_186
import Source3.LevelInitialization186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTopProducts186
open C99ArrayReference (State)
open KeygenLevelExec (Exec)
open SelectedTopInit178 (p p0i)
open SelectedTopR3_186 (r3)

noncomputable abbrev before := SelectedTopR3_186.after

theorem exists_execution : ∃ out, Exec TopProductShape185.loop before ⟨out,.normal⟩ ∧
    TopProductFixed186.Fixed out p p0i r3 ∧ KeygenNttLoopSupport.USlot out "u" 1536 ∧
    KeygenNttLoopSupport.USlot out "v" 512 ∧ TopProductMemory186.Frame before.heap out.heap :=
  TopProductLoop186.full before p p0i r3 SelectedTopR3_186.fixed none none
    SelectedTopR3_186.u_declared SelectedTopR3_186.v_declared

noncomputable def after : State := Classical.choose exists_execution

theorem loop_source : Exec TopProductShape185.loop before ⟨after,.normal⟩ := (Classical.choose_spec exists_execution).1
theorem fixed : TopProductFixed186.Fixed after p p0i r3 := (Classical.choose_spec exists_execution).2.1
theorem u_cell : KeygenNttLoopSupport.USlot after "u" 1536 := (Classical.choose_spec exists_execution).2.2.1
theorem v_cell : KeygenNttLoopSupport.USlot after "v" 512 := (Classical.choose_spec exists_execution).2.2.2.1
theorem frame : TopProductMemory186.Frame before.heap after.heap := (Classical.choose_spec exists_execution).2.2.2.2

theorem tail_source : Exec TopProductShape185.tail after ⟨after,.normal⟩ := TopProductLoop186.tail after p p0i r3 fixed

theorem body_source : Exec KeygenMakeFgTop.code SelectedMakeFgTopEntry176.entry ⟨after,.normal⟩ := by
  apply SelectedSecondCall185.continue_top ⟨after,.normal⟩
  rw [TopProductShape185.shape]
  exact .seqNormal _ _ SelectedTopR3_186.before before _ SelectedTopR3_186.source
    (.seqNormal _ _ before after _ loop_source tail_source)

theorem initialization : C99InitializationTrace.Preserves SelectedMakeFgTopEntry176.entry.heap after.heap :=
  LevelInitialization186.source _ _ _ body_source

end FT1536.Source3.SelectedTopProducts186
