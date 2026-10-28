import Source3.SixthStepLayout217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SixthStepMove217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory Allocated Load32)
open KeygenMakeFgSource (Exec)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open ZintNormWalkFlat208 (Data)
open SixthStepLayout217 (fd gd fs gs gm igm t1)

noncomputable abbrev before (s : State) := SixthStepLayout217.after s
noncomputable def after (s : State) : State :=
  {before s with heap:=MemmoveWord177.snapshot (before s).heap fs fd 2816}

noncomputable def inputWords (Wf Wg : Nat → BitVec 32) (j : Nat) : BitVec 32 :=
  if j<352 then Wf j else Wg (j-352)

theorem element_elem (root : ArrayPointer) (i : Nat) : element root i=elem root i := rfl

theorem load_elem {h : Memory} {root : ArrayPointer} {i : Nat} {w : BitVec 32}
    (read : Load32 h (element root i) w) : Load32 h (elem root i) w := by
  rw [← element_elem]
  exact read

theorem load_element {h : Memory} {root : ArrayPointer} {i : Nat} {w : BitVec 32}
    (read : Load32 h (elem root i) w) : Load32 h (element root i) w := by
  rw [element_elem]
  exact read

theorem before_heap (s : State) : (before s).heap=s.heap := SixthStepLengths217.heap s

theorem data_keep {x y : State} {root : ArrayPointer} {n : Nat} {W : Nat → BitVec 32}
    (image : Data x root n W) (heap : y.heap=x.heap) : Data y root n W := by
  intro i bound
  rw [heap]
  exact image i bound

theorem input_reads (s : State) (Wf Wg : Nat → BitVec 32)
    (fImage : Data s fd 352 Wf) (gImage : Data s FifthStepLayout217.gd 352 Wg)
    (j : Nat) (bound : j<704) : Load32 (before s).heap (element fd j) (inputWords Wf Wg j) := by
  rw [before_heap]
  by_cases low : j<352
  · have read : Load32 s.heap (element fd j) (Wf j) := load_element (fImage j low)
    simpa only [inputWords,low,ite_true] using read
  · have upper : j-352<352 := by omega
    have address : element fd j=element FifthStepLayout217.gd (j-352) := by
      change (⟨31,0,71680,4,670+j⟩ : ArrayPointer)=⟨31,0,71680,4,1022+(j-352)⟩
      apply congrArg (fun k : Nat => (⟨31,0,71680,4,k⟩ : ArrayPointer))
      omega
    have read : Load32 s.heap (element fd j) (Wg (j-352)) := by
      rw [address]
      exact load_element (gImage (j-352) upper)
    simpa only [inputWords,low,ite_false] using read

theorem memory_domains (s : State)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap) :
    4*71680≤(before s).heap.size 31 ∧ (before s).heap.size 31<2^64 ∧
      (before s).heap.writable 31=true := by
  rw [before_heap,stable.size,stable.writable]
  rw [← SelectedStepLayout187.heap]
  exact ⟨SelectedStepMove187.extent,SelectedStepMove187.size_bound,SelectedStepMove187.writable⟩

theorem initialized (s : State) (Wf Wg : Nat → BitVec 32)
    (fImage : Data s fd 352 Wf) (gImage : Data s FifthStepLayout217.gd 352 Wg) :
    ∀ i<2816, ((before s).heap.bytes fd.block (fd.offset+i)).isSome :=
  MemmoveWord177.initialized_bytes _ fd 704 rfl
    (fun j bound => ⟨inputWords Wf Wg j,input_reads s Wf Wg fImage gImage j bound⟩)

theorem copy (s : State) (Wf Wg : Nat → BitVec 32)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 352 Wf) (gImage : Data s FifthStepLayout217.gd 352 Wg) :
    KeygenSearchMemory.Memmove (before s).heap fs fd 2816 (after s).heap :=
  MemmoveWord177.source _ fs fd 2816 (by decide) (by decide)
    (memory_domains s stable).1 (memory_domains s stable).1
    (memory_domains s stable).2.1 (memory_domains s stable).2.1
    (memory_domains s stable).2.2 (initialized s Wf Wg fImage gImage)

theorem count_source (s : State) :
    C99ArrayReference.scalar (before s) StepPrefixProgram187.count (.uint64 2816) :=
  .arithmetic .times _ _ _ _ _
    (.arithmetic .times _ _ _ _ _
      (.arithmetic .times _ _ _ _ _ (.literal .int32 2) (.variable _ _ _ rfl)
        (.step .times (.int32 2) (.uint64 16) .uint64 rfl (.uint64 2) (.uint64 16) rfl rfl
          (by intro impossible; cases impossible)))
      (.variable _ _ _ rfl)
      (.step .times (.uint64 32) (.uint64 22) .uint64 rfl (.uint64 32) (.uint64 22) rfl rfl
        (by intro impossible; cases impossible)))
    (.literal .uint64 4)
    (.step .times (.uint64 704) (.uint64 4) .uint64 rfl (.uint64 704) (.uint64 4) rfl rfl
      (by intro impossible; cases impossible))

theorem move_source (s : State) (Wf Wg : Nat → BitVec 32)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 352 Wf) (gImage : Data s FifthStepLayout217.gd 352 Wg) :
    Exec StepPrefixProgram187.move (before s) ⟨after s,.normal⟩ :=
  .level _ _ _ (.move _ _ _ _ _ _ _ fs fd 2816
    (RootBinding175.zero _ "fs" fs rfl (by decide))
    (RootBinding175.zero _ "data" fd rfl (by decide)) (count_source s)
    (copy s Wf Wg stable fImage gImage))

theorem snapshot_size (h : Memory) : (MemmoveWord177.snapshot h fs fd 2816).size=h.size := rfl

theorem allocated (s : State)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (j : Nat) (bound : j<704) : Allocated (after s).heap (element fs j) := by
  change 0<4 ∧ 0%4=0 ∧ 1342+j<71680 ∧
    0+4*71680≤(after s).heap.size 31 ∧ (after s).heap.size 31<2^64
  have size : (after s).heap.size=(before s).heap.size := snapshot_size _
  rw [size]
  exact ⟨by decide,by decide,by omega,(memory_domains s stable).1,(memory_domains s stable).2.1⟩

theorem moved_word (s : State) (Wf Wg : Nat → BitVec 32)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 352 Wf) (gImage : Data s FifthStepLayout217.gd 352 Wg)
    (j : Nat) (bound : j<704) : Load32 (after s).heap (element fs j) (inputWords Wf Wg j) :=
  MemmoveWord177.load_word _ _ fs fd 704 j (inputWords Wf Wg j) (copy s Wf Wg stable fImage gImage)
    bound rfl rfl (allocated s stable j bound) (input_reads s Wf Wg fImage gImage j bound)

theorem f_image (s : State) (Wf Wg : Nat → BitVec 32)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 352 Wf) (gImage : Data s FifthStepLayout217.gd 352 Wg) :
    Data (after s) fs 352 Wf := by
  intro i bound
  have read : Load32 (after s).heap (element fs i) (Wf i) := by
    simpa only [inputWords,bound,ite_true] using moved_word s Wf Wg stable fImage gImage i (by omega)
  exact load_elem read

theorem g_image (s : State) (Wf Wg : Nat → BitVec 32)
    (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap s.heap)
    (fImage : Data s fd 352 Wf) (gImage : Data s FifthStepLayout217.gd 352 Wg) :
    Data (after s) gs 352 Wg := by
  intro i bound
  have read := moved_word s Wf Wg stable fImage gImage (352+i) (by omega)
  have address : element fs (352+i)=element gs i := by
    dsimp only [SixthStepLayout217.gs,element]
    rw [Nat.add_assoc]
  rw [address] at read
  have final : Load32 (after s).heap (element gs i) (Wg i) := by
    simpa [inputWords,show ¬352+i<352 from by omega] using read
  exact load_elem final

end FT1536.Source3.SixthStepMove217
