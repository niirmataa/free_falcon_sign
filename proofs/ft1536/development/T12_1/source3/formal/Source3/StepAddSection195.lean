import Source3.StepAddConcrete195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete additional-prime section at its actual CRT entry. -/
namespace FT1536.Source3.StepAddSection195
open C99ArrayReference (State restoreScope)
open C99LoopScalar141 (Cell)
open SelectedStepLayout187 (fd gd)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open StepAddReady195 (Entry prefixState)
open StepAddBasic195 (Basic)
open StepAddBody195 (resultWords)

def bodyOut (s final : State) : State := restoreScope (SelectedStepAddPrime195.u1 s) final
  MakeFgAddPrimeShape194.localNames MakeFgAddPrimeShape194.pointerNames

def next (s final : State) : State :=
  FftLocalCells140.put (bodyOut s final) "u".toList (C99NatWord141.word 2)

theorem body_u (s final : State) (b : Basic final) : Cell (bodyOut s final) "u".toList 1 := by
  simpa [bodyOut,restoreScope,MakeFgAddPrimeShape194.localNames,C99ScalarReference.restore,Cell] using b.uCell

theorem body_tlen (s final : State) (b : Basic final) : Cell (bodyOut s final) "tlen".toList 2 := by
  simpa [bodyOut,restoreScope,MakeFgAddPrimeShape194.localNames,C99ScalarReference.restore,Cell] using b.tlenCell

theorem inc_run (s final : State) (b : Basic final) :
    KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.aInc (bodyOut s final) ⟨next s final,.normal⟩ := by
  rw [MakeFgAddPrimeShape194.inc_shape]
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (MakeFgAddPrimeShape194.num 1))) (bodyOut s final)
      (FftLocalCells140.put (bodyOut s final) "u".toList (C99NatWord141.word 2)) := by
    cases C99LoopScalar141.increment (fun _ => none) (bodyOut s final) "u".toList 1
      (by decide) (body_u s final b) with
    | base _ _ _ source => exact source
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem exit_u (s final : State) : Cell (next s final) "u".toList 2 :=
  FftLocalCells140.cell_at (bodyOut s final) "u".toList (C99NatWord141.word 2)

theorem exit_guard (s final : State) (b : Basic final) :
    C99ArrayReference.scalar (next s final)
      (.cmp .lt MakeFgAddPrimeShape194.varU MakeFgAddPrimeShape194.varTlen) (.int32 0) := by
  have tlen : Cell (next s final) "tlen".toList 2 :=
    (FftLocalCells140.outside (bodyOut s final) "u".toList "tlen".toList
      (C99NatWord141.word 2) (by decide)).trans (body_tlen s final b)
  simpa [C99ScalarReference.boolean] using
    C99LoopScalar141.less (next s final) MakeFgAddPrimeShape194.varU MakeFgAddPrimeShape194.varTlen
      2 2 (by decide) (by decide) (C99LoopScalar141.read _ _ _ (exit_u s final))
      (C99LoopScalar141.read _ _ _ tlen)

theorem part4_run (s : State) (F G : Fin 512 → BitVec 32) (e : Entry s F G) :
    ∃ (out : State) (gvs : Fin 512 → BitVec 32),
      KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 4) s ⟨out,.normal⟩ ∧
      Cell out "u".toList 2 ∧
      StepProductFixed191.Image out fd 1 2 256 p1 p0i1 r21 (resultWords F gvs) 256 ∧
      StepProductFixed191.Image out gd 1 2 256 p1 p0i1 r21 (resultWords G gvs) 256 := by
  have b := StepAddReady195.basic s F G e
  have input := StepAddReady195.generator_input s F G e
  have fs : ∀ i : Fin 512, C99MemoryReference.Load32 (prefixState s).heap
      (StepCopyBody190.elem SelectedStepLayout187.fs i.val) (F i) := by
    intro i; rw [StepAddReady195.prefix_heap]; exact e.fLoads i
  have gs : ∀ i : Fin 512, C99MemoryReference.Load32 (prefixState s).heap
      (StepCopyBody190.elem SelectedStepLayout187.gs i.val) (G i) := by
    intro i; rw [StepAddReady195.prefix_heap]; exact e.gLoads i
  obtain ⟨final,gvs,remaining,bFinal,fdImage,gdImage⟩ := StepAddBody195.remaining (prefixState s) b input F G fs gs
  have entry := SelectedStepAddPrime195.body_entry s (some (.uint64 (C99NatWord141.word 1)))
    e.uCell e.slenCell e.tlenCell e.primesBinding (SelectedStepAddPrime195.object_word s e.prime)
  have inner : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.aInner
      (SelectedStepAddPrime195.u1 s) ⟨final,.normal⟩ := entry.2.2.2.1 _ remaining
  have body : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.aBody
      (SelectedStepAddPrime195.u1 s) ⟨bodyOut s final,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.body_shape]
    exact .scope _ _ _ (SelectedStepAddPrime195.u1 s) ⟨final,.normal⟩ inner
  have loop : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.aLoop
      (SelectedStepAddPrime195.u1 s) ⟨next s final,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.loop_shape]
    exact .loopNormal _ _ _ (SelectedStepAddPrime195.u1 s) (bodyOut s final) (next s final)
      ⟨next s final,.normal⟩ (.int32 1) entry.2.1 (by decide) body (inc_run s final bFinal)
      (.loopFalse _ _ _ (next s final) (.int32 0) (exit_guard s final bFinal) (by decide))
  have forRun : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.aFor s ⟨next s final,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.aFor_split,MakeFgAddPrimeShape194.init_shape]
    exact .seqNormal _ _ s (SelectedStepAddPrime195.u1 s) _ entry.1 loop
  refine ⟨next s final,gvs,?_,exit_u s final,?_,?_⟩
  · change KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.part4 s ⟨next s final,.normal⟩
    rw [MakeFgAddPrimeShape194.part4_split,MakeFgAddPrimeShape194.aTail_skip]
    exact .seqNormal _ _ s (next s final) _ forRun (SelectedStepAddPrime195.skip_run _)
  · exact fdImage
  · exact gdImage

/-- Parts 2, 3 and 4 at the same actual states, with both final product images. -/
theorem source : ∃ (after2 after3 out : State) (gvs : Fin 512 → BitVec 32),
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after ⟨after2,.normal⟩ ∧
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 3) after2 ⟨after3,.normal⟩ ∧
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.part .step 4) after3 ⟨out,.normal⟩ ∧
    Cell out "u".toList 2 ∧
    StepProductFixed191.Image out fd 1 2 256 p1 p0i1 r21
      (resultWords StepAddConcrete195.inputF gvs) 256 ∧
    StepProductFixed191.Image out gd 1 2 256 p1 p0i1 r21
      (resultWords StepAddConcrete195.inputG gvs) 256 := by
  obtain ⟨after2,after3,part2,part3,ready⟩ := StepAddConcrete195.entry
  obtain ⟨out,gvs,part4,uCell,fdImage,gdImage⟩ :=
    part4_run after3 StepAddConcrete195.inputF StepAddConcrete195.inputG ready
  exact ⟨after2,after3,out,gvs,part2,part3,part4,uCell,fdImage,gdImage⟩

end FT1536.Source3.StepAddSection195
