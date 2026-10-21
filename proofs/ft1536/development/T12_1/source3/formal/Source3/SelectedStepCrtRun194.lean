import Source3.ZintRebuildCrt194
import Source3.SelectedStepCrtWord194
import Source3.SelectedStepLoopTail194

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Both zint_rebuild_CRT call statements of the make_fg_step part 3
   composed at the loop exit state (the closing half of obligation (c)
   of the CRT route): the exact Bind chain of
   MakeFgCrtShape194.crtArgs "fs"/"gs" over the named arguments, the
   ZintRebuildCrt194 body runs at xlen = 1 and the make-level
   composition of first3/second3/tail3 at the exit state of
   SelectedStepFsFd194.source. The second call keeps the first call's
   fs image and the normalized words through the Word32Memory176
   separation keeps of the twin walks (512-word separation) and the gm
   scratch cell. Values stay executed words: no transform property,
   table law, root law, positivity or Z>0 claim is made here.

   Bridge discipline (retained failures 543-549 and the probe
   CrtBridgeProbe194): definitional equality between two syntactically
   different concrete Memory terms is pathological (the unifier unfolds
   the walkImage/write closures and explodes), so this module never
   lets the unifier compare concrete memory terms. Every crossing is
   either (a) an instantiation of an abstract bridge lemma (proj_heap /
   proj_arrays / proj_locals applied at the concrete memory), (b) a
   rewrite along a bridging equation with a closed pattern, or (c) a
   single delta step of a plain top-level definition into its own body.
   The intermediate states midFs/midGs are the literal result states of
   the two calls, so the whole make-level composition is syntactic.
   Structural-instance values stay on one line: a field value placed on
   the next line parses as a new elided field (job 549 parse trap). -/
namespace FT1536.Source3.SelectedStepCrtRun194
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

noncomputable def fsWords : Nat -> BitVec 32 :=
  fun j => scaledWord SelectedStepProduct191.fvs SelectedStepChain193.tws
    SelectedTopInit178.p SelectedTopInit178.p0i j
noncomputable def gsWords : Nat -> BitVec 32 :=
  fun j => scaledWord SelectedStepChainKeep194.gvs SelectedStepChain193.tws
    SelectedTopInit178.p SelectedTopInit178.p0i j

def slenName : Name := "slen".toList
def nName : Name := "n".toList
def gmName : Name := "gm".toList

/- The Bind-chain entry state of one zint_rebuild_CRT call (the first
   parameter binds outermost, exactly as the Bind constructors nest). -/
def entryOf (before : State) (px pgm : ArrayPointer) : State :=
  bindPointer
    (bindValue
      (bindValue
        (bindValue
          (bindPointer
            (bindValue
              (bindPointer
                ⟨before.heap,before.globals,before.tables,before.globals,before.tables⟩
                tmpName pgm)
              normSignedName .int32 (.int32 1#32))
            primesName primes)
          "num".toList .uint64 (.uint64 (word 512)))
        "xstride".toList .uint64 (.uint64 (word 1)))
      xlenName .uint64 (.uint64 (word 1)))
    xxName px

/- The record-update heap projection over an ABSTRACT memory: with a
   concrete Memory term the unifier dives into the nested write closures
   and explodes (see the retained failures 543-548); with abstract H the
   projection is a single iota step. -/
theorem proj_heap (s : State) (H : Memory) : ({s with heap := H}).heap = H := rfl

/- Field projections of a heap-only record update, abstract in the
   memory: same discipline as proj_heap. -/
theorem proj_arrays (s : State) (H : Memory) (name : Name) :
    ({s with heap := H}).arrays name = s.arrays name := rfl
theorem proj_locals (s : State) (H : Memory) (name : Name) :
    ({s with heap := H}).locals name = s.locals name := rfl

theorem entryOf_heap (before : State) (px pgm : ArrayPointer) :
    (entryOf before px pgm).heap=before.heap := rfl

theorem entryOf_xx (before : State) (px pgm : ArrayPointer) :
    (entryOf before px pgm).arrays xxName=some px := rfl

theorem entryOf_primes (before : State) (px pgm : ArrayPointer) :
    (entryOf before px pgm).arrays primesName=some primes := rfl

theorem entryOf_tmp (before : State) (px pgm : ArrayPointer) :
    (entryOf before px pgm).arrays tmpName=some pgm := rfl

theorem entryOf_xlen (before : State) (px pgm : ArrayPointer) :
    (entryOf before px pgm).locals xlenName=some (.uint64,some (.uint64 (word 1))) := rfl

theorem entryOf_xstride (before : State) (px pgm : ArrayPointer) :
    (entryOf before px pgm).locals "xstride".toList=some (.uint64,some (.uint64 (word 1))) := rfl

theorem entryOf_num (before : State) (px pgm : ArrayPointer) :
    (entryOf before px pgm).locals "num".toList=some (.uint64,some (.uint64 (word 512))) := rfl

theorem convert_i32_self :
    C99IntegerReference.convert .int32 (Value.int32 1#32).integer=.int32 1#32 := by decide

theorem entryOf_sign (before : State) (px pgm : ArrayPointer) :
    (entryOf before px pgm).locals normSignedName=some (.int32,some (.int32 1#32)) := rfl

/- The exact Bind of the named part-3 arguments. -/
theorem bind_crt (before : State) (src : String) (px pgm : ArrayPointer)
    (pxBind : before.arrays src.toList=some px)
    (primesBind : before.arrays primesName=some primes)
    (gmBind : before.arrays gmName=some pgm)
    (slenCell : before.locals slenName=some (.uint64,some (.uint64 (word 1))))
    (nCell : before.locals nName=some (.uint64,some (.uint64 (word 512))))
    (xCap : px.index+0≤px.count) (primeCap : primes.index+0≤primes.count)
    (gmCap : pgm.index+0≤pgm.count) :
    C99ArrayReference.Bind before (KeygenZintCall.params .rebuildCrt)
      (MakeFgCrtShape194.crtArgs src) (entryOf before px pgm) := by
  have slenEval : C99ArrayReference.scalar before (MakeFgCrtShape194.var "slen") (.uint64 (word 1)) :=
    C99ScalarReference.Eval.variable slenName .uint64 (.uint64 (word 1)) slenCell
  have nEval : C99ArrayReference.scalar before (MakeFgCrtShape194.var "n") (.uint64 (word 512)) :=
    C99ScalarReference.Eval.variable nName .uint64 (.uint64 (word 512)) nCell
  have signEval : C99ArrayReference.scalar before (MakeFgCrtShape194.num 1) (.int32 1#32) :=
    C99ScalarReference.Eval.literal .int32 1
  refine C99ArrayReference.Bind.pointer xxName src.toList C99ProcedureParser.zero px
    [C99ArrayReference.Param.scalar .uint64 xlenName,
     C99ArrayReference.Param.scalar .uint64 "xstride".toList,
     C99ArrayReference.Param.scalar .uint64 "num".toList,
     C99ArrayReference.Param.pointer primesName,
     C99ArrayReference.Param.scalar .int32 normSignedName,
     C99ArrayReference.Param.pointer tmpName]
    [Arg.scalar (MakeFgCrtShape194.var "slen"), Arg.scalar (MakeFgCrtShape194.var "slen"),
     Arg.scalar (MakeFgCrtShape194.var "n"), Arg.pointer primesName C99ProcedureParser.zero,
     Arg.scalar (MakeFgCrtShape194.num 1), Arg.pointer gmName C99ProcedureParser.zero]
    _ (zero_pointer before src.toList px pxBind xCap) ?_
  refine C99ArrayReference.Bind.scalar .uint64 xlenName (MakeFgCrtShape194.var "slen")
    [C99ArrayReference.Param.scalar .uint64 "xstride".toList,
     C99ArrayReference.Param.scalar .uint64 "num".toList,
     C99ArrayReference.Param.pointer primesName,
     C99ArrayReference.Param.scalar .int32 normSignedName,
     C99ArrayReference.Param.pointer tmpName]
    [Arg.scalar (MakeFgCrtShape194.var "slen"), Arg.scalar (MakeFgCrtShape194.var "n"),
     Arg.pointer primesName C99ProcedureParser.zero, Arg.scalar (MakeFgCrtShape194.num 1),
     Arg.pointer gmName C99ProcedureParser.zero]
    _ (.uint64 (word 1)) slenEval ?_
  refine C99ArrayReference.Bind.scalar .uint64 "xstride".toList (MakeFgCrtShape194.var "slen")
    [C99ArrayReference.Param.scalar .uint64 "num".toList,
     C99ArrayReference.Param.pointer primesName,
     C99ArrayReference.Param.scalar .int32 normSignedName,
     C99ArrayReference.Param.pointer tmpName]
    [Arg.scalar (MakeFgCrtShape194.var "n"), Arg.pointer primesName C99ProcedureParser.zero,
     Arg.scalar (MakeFgCrtShape194.num 1), Arg.pointer gmName C99ProcedureParser.zero]
    _ (.uint64 (word 1)) slenEval ?_
  refine C99ArrayReference.Bind.scalar .uint64 "num".toList (MakeFgCrtShape194.var "n")
    [C99ArrayReference.Param.pointer primesName,
     C99ArrayReference.Param.scalar .int32 normSignedName,
     C99ArrayReference.Param.pointer tmpName]
    [Arg.pointer primesName C99ProcedureParser.zero, Arg.scalar (MakeFgCrtShape194.num 1),
     Arg.pointer gmName C99ProcedureParser.zero]
    _ (.uint64 (word 512)) nEval ?_
  refine C99ArrayReference.Bind.pointer primesName primesName C99ProcedureParser.zero primes
    [C99ArrayReference.Param.scalar .int32 normSignedName,
     C99ArrayReference.Param.pointer tmpName]
    [Arg.scalar (MakeFgCrtShape194.num 1), Arg.pointer gmName C99ProcedureParser.zero]
    _ (zero_pointer before primesName primes primesBind primeCap) ?_
  refine C99ArrayReference.Bind.scalar .int32 normSignedName (MakeFgCrtShape194.num 1)
    [C99ArrayReference.Param.pointer tmpName] [Arg.pointer gmName C99ProcedureParser.zero]
    _ (.int32 1#32) signEval ?_
  refine C99ArrayReference.Bind.pointer tmpName gmName C99ProcedureParser.zero pgm [] []
    _ (zero_pointer before gmName pgm gmBind gmCap) ?_
  exact C99ArrayReference.Bind.nil

/- One zint_rebuild_CRT call executed over the named arguments. The
   result state is the literal walkImage write of the caller state, so
   the make-level composition below stays syntactic. -/
theorem call_run (before : State) (src : String) (px pgm : ArrayPointer) (p0 : BitVec 32)
    (words : Nat -> BitVec 32)
    (pxBind : before.arrays src.toList=some px)
    (primesBind : before.arrays primesName=some primes)
    (gmBind : before.arrays gmName=some pgm)
    (slenCell : before.locals slenName=some (.uint64,some (.uint64 (word 1))))
    (nCell : before.locals nName=some (.uint64,some (.uint64 (word 512))))
    (tableLoad : Load32 before.heap (KeygenLevelCalls.fieldPointer primes .p) p0)
    (loads : ∀ j, j < 512 → Load32 before.heap (elem px j) (words j))
    (widthX : px.elementBytes=4) (widthP : pgm.elementBytes=4)
    (writable : before.heap.writable px.block=true)
    (writableP : before.heap.writable pgm.block=true)
    (ppAlloc : Allocated before.heap pgm)
    (tsep : ∀ i, i < 512 → Separate (elem px i) pgm)
    (xCap : px.index+0≤px.count) (primeCap : primes.index+0≤primes.count)
    (gmCap : pgm.index+0≤pgm.count) (primeWidth : primes.elementBytes=12)
    (primeExtent : primes.index<primes.count)
    (xcap : px.index+512≤px.count) (pcap : pgm.index+0≤pgm.count) :
    KeygenZintCall.Exec (.call .rebuildCrt (MakeFgCrtShape194.crtArgs src) .discard) before
      ⟨{before with heap := walkImage (Word32Memory176.write before.heap pgm p0) px p0 words 512},
        .normal⟩ ∧
    (∀ i < 512, Load32 (walkImage (Word32Memory176.write before.heap pgm p0) px p0 words 512)
      (elem px i) (normWord p0 (words i))) := by
  have binding : C99ArrayReference.Bind before (KeygenZintCall.params .rebuildCrt)
      (MakeFgCrtShape194.crtArgs src) (entryOf before px pgm) :=
    bind_crt before src px pgm pxBind primesBind gmBind slenCell nCell xCap primeCap gmCap
  have body := body_run (entryOf before px pgm) px pgm p0 words
    (entryOf_xx before px pgm) (entryOf_primes before px pgm) (entryOf_tmp before px pgm)
    (entryOf_xlen before px pgm) (entryOf_xstride before px pgm) (entryOf_num before px pgm)
    (entryOf_sign before px pgm)
    (by rw [entryOf_heap]; exact tableLoad)
    (fun j bound => by rw [entryOf_heap]; exact loads j bound)
    primeWidth primeExtent widthX widthP
    (by rw [entryOf_heap]; exact writable) (by rw [entryOf_heap]; exact writableP)
    (by rw [entryOf_heap]; exact ppAlloc)
    tsep xcap pcap primeCap
  obtain ⟨bodyExec,heapEq,imageExport⟩ := body
  have returned : C99ProcedureReference.ReturnValue (KeygenZintCall.result .rebuildCrt) .normal none :=
    ZintNormWord194.void_flow .normal (Or.inr rfl)
  have step : KeygenZintCall.Exec (.call .rebuildCrt (MakeFgCrtShape194.crtArgs src) .discard) before
      ⟨{before with heap :=
        (walkState (ZintRebuildCrt194.s0 (entryOf before px pgm) pgm p0 px) px p0 words 512).heap},
        .normal⟩ :=
    KeygenZintCall.Exec.call before .rebuildCrt (MakeFgCrtShape194.crtArgs src) .discard
      (entryOf before px pgm)
      ⟨walkState (ZintRebuildCrt194.s0 (entryOf before px pgm) pgm p0 px) px p0 words 512,.normal⟩
      none
      ({before with heap :=
        (walkState (ZintRebuildCrt194.s0 (entryOf before px pgm) pgm p0 px) px p0 words 512).heap})
      binding bodyExec returned (KeygenZintCall.ReceiveC.discard _ _)
  rw [heapEq,entryOf_heap] at step
  refine ⟨step,?_⟩
  intro i bound
  have eq1 : (walkState (ZintRebuildCrt194.s0 (entryOf before px pgm) pgm p0 px) px p0 words 512).heap
      =walkImage (Word32Memory176.write before.heap pgm p0) px p0 words 512 := by
    rw [ZintNormWalk194.walkState_heap,ZintRebuildCrt194.d8_heap,entryOf_heap]
  rw [← eq1]
  exact imageExport i bound

theorem keep_through (h : Memory) (px pgm : ArrayPointer) (p0 : BitVec 32)
    (words : Nat -> BitVec 32) (q : ArrayPointer) (w : BitVec 32)
    (gsep : Separate q pgm) (wsep : ∀ i, i < 512 → Separate (elem px i) q)
    (load : Load32 h q w) :
    Load32 (walkImage (Word32Memory176.write h pgm p0) px p0 words 512) q w :=
  ZintNormWalk194.walkImage_keep px p0 words 512 q w wsep
    (Word32Memory176.outside h pgm q p0 w (separate_symm gsep) load)

/- Layout separations of the gm scratch cell against the twin walks. -/
theorem gm_offset0 : C99MemoryReference.ArrayPointer.offset gm=0+4*2718 := rfl
theorem fs_offset (j : Nat) :
    C99MemoryReference.ArrayPointer.offset (elem fs j)=0+4*(1694+j) := rfl
theorem gs_offset (j : Nat) :
    C99MemoryReference.ArrayPointer.offset (elem gs j)=0+4*(2206+j) := rfl

theorem fs_gm_separate (i : Nat) (bound : i<512) : Separate (elem fs i) gm := by
  unfold Separate
  rw [fs_offset i,gm_offset0]
  have blocks : (elem fs i).block=gm.block := rfl
  rw [blocks]
  exact Or.inr (Or.inl (by omega))

theorem gs_gm_separate (i : Nat) (bound : i<512) : Separate (elem gs i) gm := by
  unfold Separate
  rw [gs_offset i,gm_offset0]
  have blocks : (elem gs i).block=gm.block := rfl
  rw [blocks]
  exact Or.inr (Or.inl (by omega))

/- The part-3 intermediate heaps/states as plain top-level
   definitions: the literal result states of the two zint_rebuild_CRT
   calls. Their bridges are the abstract projections and single delta
   steps into their own bodies; no concrete-Memory defeq remains. -/
abbrev p0 : BitVec 32 := SelectedTopInit178.p

noncomputable def fsHeapOf (next : State) : Memory :=
  walkImage (Word32Memory176.write next.heap gm p0) fs p0 fsWords 512

noncomputable def midFs (next : State) : State := {next with heap := fsHeapOf next}

noncomputable def gsHeapOf (next : State) : Memory :=
  walkImage (Word32Memory176.write (midFs next).heap gm p0) gs p0 gsWords 512

noncomputable def midGs (next : State) : State := {midFs next with heap := gsHeapOf next}

theorem fsHeapOf_of (next : State) :
    fsHeapOf next = walkImage (Word32Memory176.write next.heap gm p0) fs p0 fsWords 512 := rfl

theorem gsHeapOf_of (next : State) :
    gsHeapOf next = walkImage (Word32Memory176.write (midFs next).heap gm p0) gs p0 gsWords 512 := rfl

theorem midFs_of (next : State) : midFs next = {next with heap := fsHeapOf next} := rfl
theorem midGs_of (next : State) : midGs next = {midFs next with heap := gsHeapOf next} := rfl

theorem midFs_heap (next : State) :
    (midFs next).heap = walkImage (Word32Memory176.write next.heap gm p0) fs p0 fsWords 512 := by
  rw [midFs_of next,proj_heap next (fsHeapOf next)]
  exact fsHeapOf_of next

theorem midGs_heap (next : State) :
    (midGs next).heap = walkImage (Word32Memory176.write (midFs next).heap gm p0) gs p0 gsWords 512 := by
  rw [midGs_of next,proj_heap (midFs next) (gsHeapOf next)]
  exact gsHeapOf_of next

theorem midFs_arrays (next : State) (name : Name) :
    (midFs next).arrays name = next.arrays name := by
  rw [midFs_of next,proj_arrays next (fsHeapOf next) name]

theorem midFs_locals (next : State) (name : Name) :
    (midFs next).locals name = next.locals name := by
  rw [midFs_of next,proj_locals next (fsHeapOf next) name]

/- The part-3 composition and the exit-state export. -/
theorem source : ∃ (next final : State),
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
      Load32 next.heap q w → Load32 final.heap q w) := by
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
  refine ⟨next,midGs next,part2Run,part3Run,?_,?_,?_⟩
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

end FT1536.Source3.SelectedStepCrtRun194
