import Source3.SelectedGen0Control189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGen0Square189
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open SelectedStepLayout187 (gm igm)
open SelectedTopInit178 (p p0i r2)
open StepGeneratorScalar188 (r)

noncomputable abbrev before := SelectedGen0Control189.after

theorem input_initialized : GeneratorSquareDomains181.From before.heap gm igm 256 :=
  fun j _ hi => SelectedGen0Control189.initialized j (Nat.zero_le j) hi

theorem exists_execution : ∃ out, Exec KeygenMkgm3Program.squareLoop before ⟨out,.normal⟩ ∧
    GeneratorCubeFixed180.Fixed out gm igm p p0i ∧ KeygenNttLoopSupport.USlot out "u" 0 ∧
    GeneratorSquareDomains181.From out.heap gm igm 1 :=
  GeneratorSquareLoop181.full before gm igm p p0i SelectedGen0Control189.fixed input_initialized
    (some (.uint64 256)) SelectedGen0Control189.u_cell

noncomputable def after : State := Classical.choose exists_execution

theorem source : Exec KeygenMkgm3Program.squareLoop before ⟨after,.normal⟩ := (Classical.choose_spec exists_execution).1
theorem fixed : GeneratorCubeFixed180.Fixed after gm igm p p0i := (Classical.choose_spec exists_execution).2.1
theorem u_cell : KeygenNttLoopSupport.USlot after "u" 0 := (Classical.choose_spec exists_execution).2.2.1
theorem initialized : GeneratorSquareDomains181.From after.heap gm igm 1 := (Classical.choose_spec exists_execution).2.2.2

theorem r_before : Slot before "R" r :=
  (ModularAtoms178.outside SelectedGen0Control189.before "k" "R" 8 (by decide)).trans
    (KeygenNttControl.keep_u32 SelectedGen0Row189.source (by decide) "R" r (by decide) StepGeneratorReady188.r_cell)

theorem r2_before : Slot before "R2" r2 :=
  (ModularAtoms178.outside SelectedGen0Control189.before "k" "R2" 8 (by decide)).trans
    (KeygenNttControl.keep_u32 SelectedGen0Row189.source (by decide) "R2" r2 (by decide) StepGeneratorReady188.r2_cell)

theorem w_before : before.locals "w".toList=some (.uint32,none) :=
  (ModularAtoms178.outside SelectedGen0Control189.before "k" "w" 8 (by decide)).trans
    (((KeygenNttControl.frame _ _ _ (by decide) SelectedGen0Row189.source).2.1 "w".toList (by decide)).trans StepGeneratorReady188.w_declared)

theorem r_cell : Slot after "R" r := KeygenNttControl.keep_u32 source (by decide) "R" r (by decide) r_before
theorem r2_cell : Slot after "R2" r2 := KeygenNttControl.keep_u32 source (by decide) "R2" r2 (by decide) r2_before
theorem w_declared : after.locals "w".toList=some (.uint32,none) :=
  ((KeygenNttControl.frame _ _ _ (by decide) source).2.1 "w".toList (by decide)).trans w_before

end FT1536.Source3.SelectedGen0Square189
