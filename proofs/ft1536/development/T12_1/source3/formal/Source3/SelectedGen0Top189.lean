import Source3.SelectedGen0Square189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGen0Top189
open C99ArrayReference (State)
open C99ModularReference (Exec chainOf)
open C99MemoryReference (Load32)
open KeygenSmallOutput (element)
open SelectedStepLayout187 (gm igm)
open SelectedTopInit178 (p p0i r2)
open StepGeneratorScalar188 (r)

noncomputable abbrev before := SelectedGen0Square189.after

theorem exists_word : ∃ w, Load32 before.heap (element gm 1) w :=
  Word32Initialized180.load before.heap (element gm 1) (SelectedGen0Square189.fixed.gAllocated 1 (by decide))
    SelectedGen0Square189.fixed.gWidth (SelectedGen0Square189.initialized 1 (by decide) (by decide)).1

noncomputable def w : BitVec 32 := Classical.choose exists_word
noncomputable def after := GeneratorTopSource181.after before gm igm w p p0i r r2

theorem source : Exec (chainOf KeygenMkgm3Program.topElements) before ⟨after,.normal⟩ :=
  GeneratorTopSource181.source before gm igm w p p0i r r2 SelectedGen0Square189.fixed SelectedGen0Square189.r_cell
    SelectedGen0Square189.r2_cell none SelectedGen0Square189.w_declared (Classical.choose_spec exists_word)

theorem remainder_source : Exec (chainOf StepGeneratorPrefix188.remaining) StepGeneratorInverseCall188.after ⟨after,.normal⟩ :=
  .seqNormal _ _ StepGeneratorInverseCall188.after SelectedGen0Row189.after _ SelectedGen0Row189.source
    (.seqNormal _ _ SelectedGen0Row189.after SelectedGen0Control189.after _ SelectedGen0Control189.k_source
      (.seqNormal _ _ SelectedGen0Control189.after SelectedGen0Control189.after _ SelectedGen0Control189.skip_cube
        (.seqNormal _ _ SelectedGen0Control189.after before _ SelectedGen0Square189.source source)))

theorem body_source : Exec KeygenMkgm3Program.code StepGeneratorEntry188.entry ⟨after,.normal⟩ :=
  StepGeneratorPrefix188.continue_generator ⟨after,.normal⟩ remainder_source

theorem initialized : GeneratorSquareDomains181.From after.heap gm igm 0 :=
  GeneratorSquareDomains181.from_transport _ _ gm igm 0
    (C99InitializationTrace.steps_preserve _ _ (KeygenMkgm3RevMemory.memory_steps _ _ _ remainder_source)) Gen0RawInitialized189.initialized

end FT1536.Source3.SelectedGen0Top189
