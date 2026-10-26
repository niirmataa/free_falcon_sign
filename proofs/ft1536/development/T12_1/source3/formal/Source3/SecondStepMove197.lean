import Source3.SecondStepLayout197

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepMove197
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory Allocated Load32)
open KeygenMakeFgSource (Exec)
open KeygenSmallOutput (element)
open SecondStepLayout197 (fd gd fs gs gm igm t1)

noncomputable abbrev before (callee : State) := SecondStepLayout197.after callee
noncomputable def after (callee : State) : State :=
  {before callee with heap:=MemmoveWord177.snapshot (before callee).heap fs fd 4096}

noncomputable def inputWords (gvs : Fin 512 → BitVec 32) (j : Nat) : BitVec 32 :=
  if j<512 then StepFirstImage196.fdWords gvs j else StepFirstImage196.gdWords gvs (j-512)

theorem before_heap (callee : State) : (before callee).heap=callee.heap := SecondStepLayout197.heap callee

theorem input_reads (callee : State) (gvs : Fin 512 → BitVec 32)
    (fImage : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords gvs))
    (gImage : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords gvs))
    (j : Nat) (bound : j<1024) : Load32 (before callee).heap (element fd j) (inputWords gvs j) := by
  rw [before_heap]
  by_cases low : j<512
  · simpa only [inputWords,low,ite_true,SecondStepLayout197.fd,SelectedStepLayout187.fd] using fImage j low
  · have upper : j-512<512 := by omega
    have address : element fd j=element SelectedStepLayout187.gd (j-512) := by
      change (⟨31,0,71680,4,670+j⟩ : ArrayPointer)=⟨31,0,71680,4,1182+(j-512)⟩
      apply congrArg (fun k : Nat => (⟨31,0,71680,4,k⟩ : ArrayPointer))
      omega
    rw [address]
    simpa only [inputWords,low,ite_false] using gImage (j-512) upper

theorem memory_domains (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    4*71680≤(before callee).heap.size 31 ∧ (before callee).heap.size 31<2^64 ∧
      (before callee).heap.writable 31=true := by
  have stable := KeygenHelperStability.make _ _ _ run
  rw [before_heap,stable.size,stable.writable]
  rw [← SelectedStepLayout187.heap]
  exact ⟨SelectedStepMove187.extent,SelectedStepMove187.size_bound,SelectedStepMove187.writable⟩

theorem initialized (callee : State) (gvs : Fin 512 → BitVec 32)
    (fImage : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords gvs))
    (gImage : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords gvs)) :
    ∀ i<4096, ((before callee).heap.bytes fd.block (fd.offset+i)).isSome :=
  MemmoveWord177.initialized_bytes _ fd 1024 rfl
    (fun j bound => ⟨inputWords gvs j,input_reads callee gvs fImage gImage j bound⟩)

theorem copy (callee : State) (gvs : Fin 512 → BitVec 32)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (fImage : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords gvs))
    (gImage : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords gvs)) :
    KeygenSearchMemory.Memmove (before callee).heap fs fd 4096 (after callee).heap :=
  MemmoveWord177.source _ fs fd 4096 (by decide) (by decide)
    (memory_domains callee run).1 (memory_domains callee run).1
    (memory_domains callee run).2.1 (memory_domains callee run).2.1
    (memory_domains callee run).2.2 (initialized callee gvs fImage gImage)

theorem count_source (callee : State) :
    C99ArrayReference.scalar (before callee) StepPrefixProgram187.count (.uint64 4096) :=
  .arithmetic .times _ _ _ _ _
    (.arithmetic .times _ _ _ _ _
      (.arithmetic .times _ _ _ _ _ (.literal .int32 2) (.variable _ _ _ rfl)
        (.step .times (.int32 2) (.uint64 256) .uint64 rfl (.uint64 2) (.uint64 256) rfl rfl
          (by intro impossible; cases impossible)))
      (.variable _ _ _ rfl)
      (.step .times (.uint64 512) (.uint64 2) .uint64 rfl (.uint64 512) (.uint64 2) rfl rfl
        (by intro impossible; cases impossible)))
    (.literal .uint64 4)
    (.step .times (.uint64 1024) (.uint64 4) .uint64 rfl (.uint64 1024) (.uint64 4) rfl rfl
      (by intro impossible; cases impossible))

theorem move_source (callee : State) (gvs : Fin 512 → BitVec 32)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (fImage : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords gvs))
    (gImage : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords gvs)) :
    Exec StepPrefixProgram187.move (before callee) ⟨after callee,.normal⟩ :=
  .level _ _ _ (.move _ _ _ _ _ _ _ fs fd 4096
    (RootBinding175.zero _ "fs" fs rfl (by decide))
    (RootBinding175.zero _ "data" fd rfl (by decide)) (count_source callee) (copy callee gvs run fImage gImage))

theorem snapshot_size (h : Memory) : (MemmoveWord177.snapshot h fs fd 4096).size=h.size := rfl

theorem allocated (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (j : Nat) (bound : j<1024) : Allocated (after callee).heap (element fs j) := by
  change 0<4 ∧ 0%4=0 ∧ 1438+j<71680 ∧
    0+4*71680≤(after callee).heap.size 31 ∧ (after callee).heap.size 31<2^64
  have size : (after callee).heap.size=(before callee).heap.size := snapshot_size _
  rw [size]
  exact ⟨by decide,by decide,by omega,(memory_domains callee run).1,(memory_domains callee run).2.1⟩

theorem moved_word (callee : State) (gvs : Fin 512 → BitVec 32)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (fImage : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords gvs))
    (gImage : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords gvs))
    (j : Nat) (bound : j<1024) : Load32 (after callee).heap (element fs j) (inputWords gvs j) :=
  MemmoveWord177.load_word _ _ fs fd 1024 j (inputWords gvs j) (copy callee gvs run fImage gImage)
    bound rfl rfl (allocated callee run j bound) (input_reads callee gvs fImage gImage j bound)

theorem f_image (callee : State) (gvs : Fin 512 → BitVec 32)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (fImage : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords gvs))
    (gImage : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords gvs)) :
    StepNttImage195.Image (after callee) fs (StepFirstImage196.fdWords gvs) := by
  intro j bound
  simpa only [inputWords,bound,ite_true] using moved_word callee gvs run fImage gImage j (by omega)

theorem g_image (callee : State) (gvs : Fin 512 → BitVec 32)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (fImage : StepNttImage195.Image callee SelectedStepLayout187.fd (StepFirstImage196.fdWords gvs))
    (gImage : StepNttImage195.Image callee SelectedStepLayout187.gd (StepFirstImage196.gdWords gvs)) :
    StepNttImage195.Image (after callee) gs (StepFirstImage196.gdWords gvs) := by
  intro j bound
  have read := moved_word callee gvs run fImage gImage (512+j) (by omega)
  have address : element fs (512+j)=element gs j := by
    dsimp only [SecondStepLayout197.gs,element]
    rw [Nat.add_assoc]
  rw [address] at read
  simpa [inputWords,show ¬512+j<512 from by omega] using read

end FT1536.Source3.SecondStepMove197
