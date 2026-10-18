import Source3.SelectedStepLayout187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedStepMove187
open C99ArrayReference (State)
open C99MemoryReference
open KeygenMakeFgSource (Exec)
open KeygenSmallOutput (element)
open SelectedStepLayout187 (fd gd fs gs)

noncomputable abbrev before := SelectedStepLayout187.after
noncomputable def after : State := {before with heap:=MemmoveWord177.snapshot before.heap fs fd 4096}

theorem before_heap : before.heap=SelectedTopCall186.after.heap := SelectedStepLayout187.heap.trans FirstStepEntry187.entry_heap

theorem extent : 4*71680≤before.heap.size 31 := by
  rw [before_heap]
  exact (SelectedTopProducts186.fixed.fdAllocated 0 (by decide)).2.2.2.1

theorem size_bound : before.heap.size 31<2^64 := by
  rw [before_heap]
  exact (SelectedTopProducts186.fixed.fdAllocated 0 (by decide)).2.2.2.2

theorem writable : before.heap.writable 31=true := by
  rw [before_heap]
  exact SelectedTopProducts186.fixed.writable

theorem input_read (j : Nat) (bound : j<1024) : ∃ word, Load32 before.heap (element fd j) word := by
  rw [before_heap]
  by_cases low : j<512
  · exact SelectedTopOutput186.fd_read j low
  · obtain ⟨word,read⟩ := SelectedTopOutput186.gd_read (j-512) (by omega)
    rw [TopProductMemory186.gd_element] at read
    have equal : 512+(j-512)=j := by omega
    rw [equal] at read
    exact ⟨word,read⟩

theorem initialized : ∀ i<4096, (before.heap.bytes fd.block (fd.offset+i)).isSome := by
  apply MemmoveWord177.initialized_bytes before.heap fd 1024 (by decide)
  exact input_read

theorem copy : KeygenSearchMemory.Memmove before.heap fs fd 4096 after.heap :=
  MemmoveWord177.source before.heap fs fd 4096 (by decide) (by decide)
    extent extent size_bound size_bound writable initialized

theorem count_source : C99ArrayReference.scalar before StepPrefixProgram187.count (.uint64 4096) :=
  .arithmetic .times _ _ _ _ _
    (.arithmetic .times _ _ _ _ _
      (.arithmetic .times _ _ _ _ _ (.literal .int32 2) (.variable _ _ _ rfl)
        (.step .times (.int32 2) (.uint64 512) .uint64 rfl (.uint64 2) (.uint64 512) rfl rfl
          (by intro impossible; cases impossible)))
      (.variable _ _ _ rfl)
      (.step .times (.uint64 1024) (.uint64 1) .uint64 rfl (.uint64 1024) (.uint64 1) rfl rfl
        (by intro impossible; cases impossible)))
    (.literal .uint64 4)
    (.step .times (.uint64 1024) (.uint64 4) .uint64 rfl (.uint64 1024) (.uint64 4) rfl rfl
      (by intro impossible; cases impossible))

theorem source : Exec StepPrefixProgram187.move before ⟨after,.normal⟩ :=
  .level _ _ _ (.move _ _ _ _ _ before after.heap fs fd 4096
    (RootBinding175.zero before "fs" fs rfl (by decide))
    (RootBinding175.zero before "data" fd rfl (by decide)) count_source copy)

theorem allocated (index : Nat) (inside : index<71680) : Allocated after.heap {KeygenFullData127.env.ctx.scratch with index:=index} := by
  change 0<4 ∧ 0%4=0 ∧ index<71680 ∧ 0+4*71680≤before.heap.size 31 ∧ before.heap.size 31<2^64
  exact ⟨by decide,by decide,inside,extent,size_bound⟩

theorem word_transfer (j : Nat) (bound : j<1024) (word : BitVec 32) (read : Load32 before.heap (element fd j) word) :
    Load32 after.heap (element fs j) word :=
  MemmoveWord177.load_word before.heap after.heap fs fd 1024 j word copy bound (by decide) (by decide)
    (allocated (1694+j) (by omega)) read

theorem f_read (j : Nat) (bound : j<512) : ∃ word, Load32 after.heap (element fs j) word := by
  obtain ⟨word,read⟩ := input_read j (by omega)
  exact ⟨word,word_transfer j (by omega) word read⟩

theorem g_read (j : Nat) (bound : j<512) : ∃ word, Load32 after.heap (element gs j) word := by
  obtain ⟨word,read⟩ := input_read (512+j) (by omega)
  have moved := word_transfer (512+j) (by omega) word read
  have equal : element fs (512+j)=element gs j := by
    dsimp only [SelectedStepLayout187.gs,element]
    rw [Nat.add_assoc]
  rw [equal] at moved
  exact ⟨word,moved⟩

theorem outside (block offset : Nat) (separate : block≠31 ∨ offset<6776 ∨ 10872≤offset) :
    after.heap.bytes block offset=before.heap.bytes block offset :=
  copy.2.2.2.2.2.2.2.2.2.2.2 block offset separate

end FT1536.Source3.SelectedStepMove187
