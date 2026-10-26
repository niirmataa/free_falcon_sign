import Source3.SelectedStepCrtRun194
import Source3.StepMemoryInit195
import Source3.Gen0RawInitialized189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Extended CRT handoff and immutable table bindings for section assembly. -/
namespace FT1536.Source3.StepAddEntry195
open C99ArrayReference (State Name Pointer bindValue bindPointer Arg Param)
open C99MemoryReference (ArrayPointer Allocated Load32 Memory)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec skip)
open ZintNormWord194 (normWord)
open ZintNormWalk194 (elem walkImage walkState xlenName tmpName)
open ZintRebuildCrt194 (xxName primesName normSignedName body_run alloc_same_block separate_symm
  zero_pointer word_one word_zero)
open KeygenFullData127 (primes)
open SelectedStepLayout187 (fs gs gm t1)
open NttInverseWholeBridges192 (scaledWord)
open C99NatWord141 (word)

open SelectedStepCrtRun194
theorem crt_locals (next : State) : (midGs next).locals=next.locals := by
  funext name
  rw [midGs_of,proj_locals (midFs next) (gsHeapOf next) name]
  exact midFs_locals next name

theorem crt_arrays (next : State) : (midGs next).arrays=next.arrays := by
  funext name
  rw [midGs_of,proj_arrays (midFs next) (gsHeapOf next) name]
  exact midFs_arrays next name

theorem proj_tables (s : State) (H : Memory) : ({s with heap:=H}).tables=s.tables := rfl

theorem crt_tables (next : State) : (midGs next).tables=next.tables := by
  rw [midGs_of,proj_tables (midFs next) (gsHeapOf next),midFs_of,proj_tables next (fsHeapOf next)]

theorem crt_source : ∃ (next final : State),
    Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after ⟨next,.normal⟩ ∧
    Exec (KeygenMakeFgSource.part .step 3) next ⟨final,.normal⟩ ∧
    (∀ i < 512, Load32 final.heap (elem fs i)
      (normWord SelectedTopInit178.p (fsWords i))) ∧
    (∀ i < 512, Load32 final.heap (elem gs i)
      (normWord SelectedTopInit178.p (gsWords i))) ∧
    (∀ (q : ArrayPointer) (w : BitVec 32),
      Separate q gm →
      (∀ i, i < 512 → Separate (elem fs i) q) →
      (∀ i, i < 512 → Separate (elem gs i) q) →
      Load32 next.heap q w → Load32 final.heap q w) ∧
    final.locals=next.locals ∧ final.arrays=next.arrays ∧ final.tables=next.tables := by
  obtain ⟨_,next,_,_,part2Run,_,nExit,_,slenExit,_,_,_,_,_,_,arraysExit,_,fsLoads,_,gsLoads,_,
      writableT1⟩ := SelectedStepFsFd194.source
  have fsBind : next.arrays "fs".toList=some fs := by
    rw [arraysExit "fs".toList (by decide)]
    exact SelectedGen0Ready189.fs_binding
  have gsBind : next.arrays "gs".toList=some gs := by
    rw [arraysExit "gs".toList (by decide)]
    exact SelectedGen0Ready189.gs_binding
  have gmBind : next.arrays gmName=some gm := by
    rw [arraysExit gmName (by decide)]
    exact SelectedGen0Ready189.gm_binding
  have primesBind : next.arrays primesName=some primes := by
    rw [arraysExit primesName (by decide)]
    exact SelectedStepReady187.prime_binding
  have nCell : next.locals nName=some (.uint64,some (.uint64 (word 512))) := nExit
  have slenCell : next.locals slenName=some (.uint64,some (.uint64 (word 1))) := slenExit
  have fsWordsAt : ∀ j, j < 512 → Load32 next.heap (elem fs j) (fsWords j) := by
    intro j bound
    exact fsLoads ⟨j,bound⟩
  have gsWordsAt : ∀ j, j < 512 → Load32 next.heap (elem gs j) (gsWords j) := by
    intro j bound
    exact gsLoads ⟨j,bound⟩
  have tableLoad : Load32 next.heap (KeygenLevelCalls.fieldPointer primes .p) p0 :=
    SelectedStepCrtWord194.keep next part2Run
  have widthFs : fs.elementBytes=4 := by decide
  have widthGs : gs.elementBytes=4 := by decide
  have widthGm : gm.elementBytes=4 := by decide
  have fsBlock : fs.block=t1.block := by
    rw [SelectedStepCrtWord194.fs_block,SelectedStepCrtWord194.t1_block]
  have gsBlock : gs.block=t1.block := by
    rw [SelectedStepCrtWord194.gs_block,SelectedStepCrtWord194.t1_block]
  have writableFs : next.heap.writable fs.block=true := by
    rw [fsBlock]; exact writableT1
  have writableGs : next.heap.writable gs.block=true := by
    rw [gsBlock]; exact writableT1
  have gmWritable : next.heap.writable gm.block=true := by
    have : gm.block=t1.block := rfl
    rw [this]; exact writableT1
  have fsAlloc : Allocated next.heap (elem fs 0) :=
    ZintNormWalk194.load_alloc (fsWordsAt 0 (by omega))
  have gmAlloc : Allocated next.heap gm :=
    alloc_same_block fsAlloc rfl rfl rfl rfl (by decide) (by decide)
  have tableSepFs : ∀ i, i < 512 →
      Separate (elem fs i) (KeygenLevelCalls.fieldPointer primes .p) := by
    intro i _
    unfold Separate
    have b1 : (elem fs i).block=31 := rfl
    have b2 : (KeygenLevelCalls.fieldPointer primes .p).block=21 := rfl
    rw [b1,b2]
    exact Or.inl (by decide)
  have primeGm : Separate (KeygenLevelCalls.fieldPointer primes .p) gm := by
    unfold Separate
    exact Or.inl (by decide)
  have call1 := call_run next "fs" fs gm p0 fsWords fsBind primesBind gmBind slenCell nCell
    tableLoad fsWordsAt widthFs widthGm writableFs gmWritable gmAlloc
    (fun i bound => fs_gm_separate i bound)
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  obtain ⟨call1Run,call1Image⟩ := call1
  have make1 : Exec MakeFgCrtShape194.first3 next ⟨midFs next,.normal⟩ := by
    rw [MakeFgCrtShape194.first3_shape,midFs_of next,fsHeapOf_of next]
    exact Exec.zint _ _ _ call1Run
  have fsImgMid : ∀ i, i < 512 → Load32 (midFs next).heap (elem fs i) (normWord p0 (fsWords i)) := by
    intro i bound
    rw [midFs_heap next]
    exact call1Image i bound
  have tableAtFs : Load32 (midFs next).heap (KeygenLevelCalls.fieldPointer primes .p) p0 := by
    rw [midFs_heap next]
    exact keep_through next.heap fs gm p0 fsWords
      (KeygenLevelCalls.fieldPointer primes .p) p0 primeGm tableSepFs tableLoad
  have gsLoadsMid : ∀ j, j < 512 → Load32 (midFs next).heap (elem gs j) (gsWords j) := by
    intro j bound
    rw [midFs_heap next]
    exact keep_through next.heap fs gm p0 fsWords (elem gs j) (gsWords j)
      (gs_gm_separate j bound)
      (fun i ibound => separate_symm (SelectedStepFsFd194.gs_fs_separate j i bound ibound))
      (gsWordsAt j bound)
  have writableGsMid : (midFs next).heap.writable gs.block=true := by
    rw [midFs_heap next,ZintNormWalk194.walkImage_writable,ZintNormWalk194.write_writable]
    exact writableGs
  have writableGmMid : (midFs next).heap.writable gm.block=true := by
    rw [midFs_heap next,ZintNormWalk194.walkImage_writable,ZintNormWalk194.write_writable]
    exact gmWritable
  have gsAllocMid : Allocated (midFs next).heap (elem gs 0) :=
    ZintNormWalk194.load_alloc (gsLoadsMid 0 (by omega))
  have gmAllocMid : Allocated (midFs next).heap gm :=
    alloc_same_block gsAllocMid rfl rfl rfl rfl (by decide) (by decide)
  have gsBindF : (midFs next).arrays "gs".toList=some gs :=
    Eq.trans (midFs_arrays next "gs".toList) gsBind
  have primesBindF : (midFs next).arrays primesName=some primes :=
    Eq.trans (midFs_arrays next primesName) primesBind
  have gmBindF : (midFs next).arrays gmName=some gm :=
    Eq.trans (midFs_arrays next gmName) gmBind
  have slenCellF : (midFs next).locals slenName=some (.uint64,some (.uint64 (word 1))) :=
    Eq.trans (midFs_locals next slenName) slenCell
  have nCellF : (midFs next).locals nName=some (.uint64,some (.uint64 (word 512))) :=
    Eq.trans (midFs_locals next nName) nCell
  have call2 := call_run (midFs next) "gs" gs gm p0 gsWords gsBindF primesBindF gmBindF slenCellF
    nCellF tableAtFs gsLoadsMid widthGs widthGm writableGsMid writableGmMid gmAllocMid
    (fun i bound => gs_gm_separate i bound)
    (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  obtain ⟨call2Run,call2Image⟩ := call2
  have make2 : Exec MakeFgCrtShape194.second3 (midFs next) ⟨midGs next,.normal⟩ := by
    rw [MakeFgCrtShape194.second3_shape,midGs_of next,gsHeapOf_of next]
    exact Exec.zint _ _ _ call2Run
  have tailRun : Exec MakeFgCrtShape194.tail3 (midGs next) ⟨midGs next,.normal⟩ := by
    rw [MakeFgCrtShape194.tail3_skip]
    exact SelectedStepLoopTail194.skip_run (midGs next)
  have part3Run : Exec (KeygenMakeFgSource.part .step 3) next ⟨midGs next,.normal⟩ := by
    show Exec MakeFgCrtShape194.part3 next ⟨midGs next,.normal⟩
    rw [MakeFgCrtShape194.part3_split,MakeFgCrtShape194.rest3_split]
    exact KeygenMakeFgSource.Exec.seqNormal MakeFgCrtShape194.first3
      (.seq MakeFgCrtShape194.second3 MakeFgCrtShape194.tail3) next (midFs next)
      ⟨midGs next,.normal⟩ make1
      (KeygenMakeFgSource.Exec.seqNormal MakeFgCrtShape194.second3 MakeFgCrtShape194.tail3
        (midFs next) (midGs next) ⟨midGs next,.normal⟩ make2 tailRun)
  refine ⟨next,midGs next,part2Run,part3Run,?_,?_,?_,?_,?_,?_⟩
  · intro i bound
    rw [midGs_heap next]
    exact keep_through (midFs next).heap gs gm p0 gsWords (elem fs i) (normWord p0 (fsWords i))
      (fs_gm_separate i bound)
      (fun j jbound => SelectedStepFsFd194.gs_fs_separate j i jbound bound)
      (fsImgMid i bound)
  · intro i bound
    rw [midGs_heap next]
    exact call2Image i bound
  · intro q w gsep fsep ssep load
    rw [midGs_heap next]
    have kept1 : Load32 (midFs next).heap q w := by
      rw [midFs_heap next]
      exact keep_through next.heap fs gm p0 fsWords q w gsep fsep load
    exact keep_through (midFs next).heap gs gm p0 gsWords q w gsep ssep kept1

  · exact crt_locals next
  · exact crt_arrays next
  · exact crt_tables next

theorem tables_zero (s : State)
    (tables : s.tables=(C99CompactState115.reference KeygenFullData127.base).tables) :
    C99PointerFootprint.TablesOutside s 0 0 := by
  intro name p binding
  rw [tables] at binding
  have blocks := KeygenFullFacts127.table_blocks name p binding
  simp only [List.mem_cons,List.not_mem_nil,or_false] at blocks
  left
  omega

theorem prepared_tables : SelectedAttemptPrefix156.prepared.tables=
    (C99CompactState115.reference KeygenFullData127.base).tables := by
  rw [SelectedRootEntry175.prepared_eq]
  change C99NameMap115.lookup SelectedFullStart127.ready.tables=
    C99NameMap115.lookup KeygenFullData127.base.tables
  have same : SelectedFullStart127.ready.tables=KeygenFullData127.base.tables := by decide +kernel
  exact congrArg C99NameMap115.lookup same

theorem initial_outside : C99ArrayFrame.Outside SelectedStepMove187.after
    KeygenMakeFgSource.writable 0 0 := by
  intro name member p binding
  simp only [KeygenMakeFgSource.writable,List.map_cons,List.map_nil,List.mem_cons,
    List.not_mem_nil,or_false] at member
  rcases member with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  all_goals
    have same := congrArg (Option.map ArrayPointer.block) binding
    first
    | change some 31=some p.block at same
      exact Or.inl (by have h:=Option.some.inj same; omega)
    | change some 21=some p.block at same
      exact Or.inl (by have h:=Option.some.inj same; omega)
    | change Option.map ArrayPointer.block (SelectedMakeFgConvert176.after.tables _) = _ at same
      rw [SelectedMakeFgConvert176.frame.tables] at same
      change Option.map ArrayPointer.block (SelectedPublicBinding157.before.tables _) = _ at same
      rw [SelectedRootWords175.table_frame,prepared_tables] at same
      first
      | change none=some p.block at same
        cases same
      | change some 21=some p.block at same
        exact Or.inl (by have h:=Option.some.inj same; omega)
      | change some 23=some p.block at same
        exact Or.inl (by have h:=Option.some.inj same; omega)

theorem initial_tables : SelectedStepMove187.after.tables=
    (C99CompactState115.reference KeygenFullData127.base).tables := by
  change SelectedMakeFgConvert176.after.tables=_
  rw [SelectedMakeFgConvert176.frame.tables]
  change SelectedPublicBinding157.before.tables=_
  rw [SelectedRootWords175.table_frame,prepared_tables]

end FT1536.Source3.StepAddEntry195
