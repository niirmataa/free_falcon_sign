import Source3.ZintNormWalk194
import Source3.SelectedStepFsFd194
import Source3.SelectedStepCrtWord194
import Source3.SelectedStepLoopTail194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The zint_rebuild_CRT body run at xlen = 1 (the engine half of the
   second part of obligation (c) of the CRT route): the u/x
   declarations, the `tmp[0] = primes[0].p` storePrime (the
   KeygenLevelCalls.PrimeRead of the block-21 table word), the u = 1
   init, the EMPTY co-reduction loop at xlen = 1 (one false guard), the
   normalize branch (the closed 512-step walk of ZintNormWalk194) and
   the fall-through end flow. The body spine is decide-bound against
   the pinned parse record through MakeFgCrtShape194.crt_split1..4 and
   the ZintNormWalk194 projections; the co-reduction loop body is never
   unfolded (its guard is false at xlen = 1). Values stay executed
   words: no transform property, table law, root law, positivity or
   Z>0 claim is made here. -/
namespace FT1536.Source3.ZintRebuildCrt194
open C99ArrayReference (State Name Pointer bindValue bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32 Memory)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open ZintNormWord194 (normWord normImage consumerArgs)
open ZintNormWalk194 (elem uName numName xlenName xstrideName xName tmpName wskip wordScalar
  wordArray walkState walkImage walk_run walkState_heap)
open KeygenFullData127 (primes)
open C99NatWord141 (word)

def xxName : Name := "xx".toList
def primesName : Name := "primes".toList
def normSignedName : Name := "normalize_signed".toList

theorem convert_i32_one_u64 :
    C99IntegerReference.convert .uint64 (Value.int32 1#32).integer=.uint64 1#64 := by decide

theorem word_zero : (word 0)=0#64 := by decide
theorem word_one : (word 1)=1#64 := by decide

/- Finer spine projections of the pinned rebuildCrt body. -/
def coreHead : KeygenZintCall.Stmt :=
  match MakeFgCrtShape194.crtCore with | .seq a _ => a | _ => wskip
def coLoop : KeygenZintCall.Stmt :=
  match MakeFgCrtShape194.crtCore with | .seq _ b => b | _ => wskip
theorem core_split : MakeFgCrtShape194.crtCore=.seq coreHead coLoop := by decide
theorem core_head : coreHead=.word (.assign uName (.scalar (.literal .i32 1))) := by decide

def coGuard : KeygenWordExpr.Expr :=
  match coLoop with | .loop c _ _ => c | _ => .scalar (.literal .i32 0)
def coBody : KeygenZintCall.Stmt := match coLoop with | .loop _ b _ => b | _ => wskip
def coInc : KeygenZintCall.Stmt := match coLoop with | .loop _ _ c => c | _ => wskip
theorem co_split : coLoop=.loop coGuard coBody coInc := by decide
theorem co_guard :
    coGuard=.cmp .lt (.scalar (.var uName)) (.scalar (.var xlenName)) := by decide

def declXPtr : KeygenZintCall.Stmt :=
  match MakeFgCrtShape194.crtDeclX with | .seq a _ => a | _ => wskip
def declXTail : KeygenZintCall.Stmt :=
  match MakeFgCrtShape194.crtDeclX with | .seq _ b => b | _ => wskip
theorem declx_split : MakeFgCrtShape194.crtDeclX=.seq declXPtr declXTail := by decide
theorem declx_ptr : declXPtr=wordArray (.declarePtr xName) := by decide
theorem declx_tail : declXTail=wskip := by decide

theorem declu_shape :
    MakeFgCrtShape194.crtDeclU=wordScalar (.declare .u64 [uName]) := by decide
theorem store_shape : MakeFgCrtShape194.crtStore=
    KeygenZintCall.Stmt.storePrime tmpName (.literal .i32 0) primesName (.literal .i32 0) .p :=
  by decide
theorem norm_test : ZintNormWalk194.normTest=.scalar (.var normSignedName) := by decide
theorem norm_tail : ZintNormWalk194.normTail=wskip := by decide

/- Generic statement steps. -/
theorem declarePtr_run (before : State) (name : Name) :
    KeygenZintCall.Exec (wordArray (.declarePtr name)) before
      ⟨{before with arrays := fun n => if n = name then none else before.arrays n},.normal⟩ :=
  ZintNormWord194.word_run _ _ _
    (KeygenWordExec.Exec.modular _ _ _ (C99ModularReference.GenExec.base _ _ _
      (C99ArrayReference.Exec.declarePtr before name)))

theorem assign_i32_run (before : State) (name : Name) (e : CLogic.Expr)
    (ty : C99IntegerReference.Ty) (old : Option Value) (v : Value)
    (declared : before.locals name=some (ty,old))
    (value : KeygenWordExpr.Eval before (.scalar e) v) :
    KeygenZintCall.Exec (.word (.assign name (.scalar e))) before
      ⟨bindValue before name ty v,.normal⟩ :=
  ZintNormWord194.word_run _ _ _
    (KeygenWordExec.Exec.assign name (.scalar e) before ty old v declared value)

theorem zero_pointer (s : State) (name : Name) (q : ArrayPointer)
    (binding : s.arrays name=some q) (bound : q.index+0≤q.count) :
    Pointer s name C99ProcedureParser.zero q :=
  Pointer.add name C99ProcedureParser.zero q q (.uint64 0#64) binding
    (C99ScalarReference.Eval.literal .uint64 0) (by decide)
    (C99MemoryReference.PointerAdd.within q 0 bound)

theorem i32zero_pointer (s : State) (name : Name) (q : ArrayPointer)
    (binding : s.arrays name=some q) (bound : q.index+0≤q.count) :
    Pointer s name (.literal .i32 0) q :=
  Pointer.add name (.literal .i32 0) q q (.int32 0#32) binding
    (C99ScalarReference.Eval.literal .int32 0) (by decide)
    (C99MemoryReference.PointerAdd.within q 0 bound)

/- Allocated transport: cells of the same object share the size
   conjuncts. -/
theorem alloc_same_block {h : Memory} {p q : ArrayPointer}
    (allocated : Allocated h p) (sameBlock : q.block=p.block)
    (sameBase : q.base=p.base) (sameCount : q.count=p.count)
    (width : q.elementBytes=p.elementBytes) (aligned : q.base%q.elementBytes=0)
    (bound : q.index<q.count) : Allocated h q := by
  obtain ⟨positive,_,_,fit,finite⟩ := allocated
  refine ⟨by rw [width]; exact positive,aligned,bound,?_,?_⟩
  · rw [sameBase,sameCount,width,sameBlock]
    exact fit
  · rw [sameBlock]
    exact finite

theorem separate_symm {p q : ArrayPointer} (source : Word32Memory176.Separate p q) :
    Word32Memory176.Separate q p := by
  rcases source with h | h | h
  · exact Or.inl (Ne.symm h)
  · exact Or.inr (Or.inr h)
  · exact Or.inr (Or.inl h)

/- The body prefix states. -/
def d1 (entry : State) : State := C99DeclarationStatements.effect .u64 [uName] entry
def d2 (entry : State) : State :=
  {d1 entry with arrays := fun n => if n = xName then none else (d1 entry).arrays n}
def d3 (entry : State) : State := d2 entry
def d4 (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) : State :=
  {d3 entry with heap := Word32Memory176.write (d3 entry).heap pp p0}
def d5 (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) : State :=
  bindValue (d4 entry pp p0) uName .uint64 (.int32 1#32)
def d7 (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) : State :=
  bindValue (d5 entry pp p0) uName .uint64 (.int32 0#32)
def s0 (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) (px : ArrayPointer) : State :=
  bindPointer (d7 entry pp p0) xName (elem px 0)

theorem d3_heap (entry : State) : (d3 entry).heap=entry.heap := rfl
theorem d8_heap (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) (px : ArrayPointer) :
    (s0 entry pp p0 px).heap=Word32Memory176.write entry.heap pp p0 := rfl

/- Cell keeps through the prefix. -/
theorem d2_arrays (entry : State) (name : Name) (different : name≠xName) :
    (d2 entry).arrays name=(d1 entry).arrays name := by
  simp [d2,different]

theorem d1_arrays (entry : State) (name : Name) :
    (d1 entry).arrays name=entry.arrays name := rfl

theorem d1_locals (entry : State) (name : Name) (different : name≠uName) :
    (d1 entry).locals name=entry.locals name :=
  ZintSubWord194.effect_one_other .u64 uName name entry different

theorem s0_arrays_x (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) (px : ArrayPointer) :
    (s0 entry pp p0 px).arrays xName=some (elem px 0) := by
  simp [s0,bindPointer]

theorem arrays_keep (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) (px : ArrayPointer)
    (name : Name) (different : name≠xName) :
    (s0 entry pp p0 px).arrays name=entry.arrays name := by
  have step1 : (s0 entry pp p0 px).arrays name=(d7 entry pp p0).arrays name := by
    simp [s0,bindPointer,different]
  rw [step1]
  show (d2 entry).arrays name=_
  rw [d2_arrays entry name different,d1_arrays]

theorem locals_keep (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) (px : ArrayPointer)
    (name : Name) (different : name≠uName) :
    (s0 entry pp p0 px).locals name=entry.locals name := by
  change (bindValue (d5 entry pp p0) uName C99IntegerReference.Ty.uint64
    (Value.int32 0#32)).locals name=entry.locals name
  rw [ZintSubWord194.bind_other (d5 entry pp p0) uName name .uint64 (.int32 0#32) different]
  change (bindValue (d4 entry pp p0) uName C99IntegerReference.Ty.uint64
    (Value.int32 1#32)).locals name=entry.locals name
  rw [ZintSubWord194.bind_other (d4 entry pp p0) uName name .uint64 (.int32 1#32) different]
  show (d1 entry).locals name=_
  exact d1_locals entry name different

theorem u_at_s0 (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) (px : ArrayPointer) :
    (s0 entry pp p0 px).locals uName=some (.uint64,some (.uint64 (word 0))) := by
  change (bindValue (d5 entry pp p0) uName C99IntegerReference.Ty.uint64
    (Value.int32 0#32)).locals uName=some (C99IntegerReference.Ty.uint64,
      some (Value.uint64 (word 0)))
  rw [ZintSubWord194.bind_cell,ZintSubWord194.convert_i32_zero_u64,word_zero]

theorem d5_u_one (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) :
    (d5 entry pp p0).locals uName=some (.uint64,some (.uint64 (word 1))) := by
  change (bindValue (d4 entry pp p0) uName C99IntegerReference.Ty.uint64
    (Value.int32 1#32)).locals uName=some (C99IntegerReference.Ty.uint64,
      some (Value.uint64 (word 1)))
  rw [ZintSubWord194.bind_cell,convert_i32_one_u64,word_one]

theorem d4_u_decl (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) :
    (d4 entry pp p0).locals uName=some (.uint64,none) := by
  show (d3 entry).locals uName=_
  show (d2 entry).locals uName=_
  show (d1 entry).locals uName=_
  exact ZintSubWord194.effect_one_cell .u64 uName entry

theorem d7_arrays (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) (name : Name)
    (different : name≠xName) : (d7 entry pp p0).arrays name=entry.arrays name := by
  show (d2 entry).arrays name=_
  rw [d2_arrays entry name different,d1_arrays]

theorem d5_locals (entry : State) (pp : ArrayPointer) (p0 : BitVec 32) (name : Name)
    (different : name≠uName) : (d5 entry pp p0).locals name=entry.locals name := by
  change (bindValue (d4 entry pp p0) uName C99IntegerReference.Ty.uint64
    (Value.int32 1#32)).locals name=entry.locals name
  rw [ZintSubWord194.bind_other (d4 entry pp p0) uName name .uint64 (.int32 1#32) different]
  show (d1 entry).locals name=_
  exact d1_locals entry name different

/- One full zint_rebuild_CRT body run at the selected instance
   xlen = slen = 1, num = 512, over an abstract entry state. -/
theorem body_run (entry : State) (px pp : ArrayPointer) (p0 : BitVec 32) (words : Nat -> BitVec 32)
    (xxBind : entry.arrays xxName=some px)
    (primeBind : entry.arrays primesName=some primes)
    (tmpBind : entry.arrays tmpName=some pp)
    (lenCell : entry.locals xlenName=some (.uint64,some (.uint64 (word 1))))
    (strideCell : entry.locals xstrideName=some (.uint64,some (.uint64 (word 1))))
    (numCell : entry.locals numName=some (.uint64,some (.uint64 (word 512))))
    (signCell : entry.locals normSignedName=some (.int32,some (.int32 1#32)))
    (tableLoad : Load32 entry.heap (KeygenLevelCalls.fieldPointer primes .p) p0)
    (loads : ∀ j, j < 512 → Load32 entry.heap (elem px j) (words j))
    (primeWidth : primes.elementBytes=12)
    (primeExtent : primes.index<primes.count)
    (widthX : px.elementBytes=4)
    (widthP : pp.elementBytes=4)
    (writable : entry.heap.writable px.block=true)
    (writableP : entry.heap.writable pp.block=true)
    (ppAlloc : Allocated entry.heap pp)
    (tsep : ∀ i, i < 512 → Word32Memory176.Separate (elem px i) pp)
    (xcap : px.index+512≤px.count) (pcap : pp.index+0≤pp.count)
    (primeCap : primes.index+0≤primes.count) :
    KeygenZintCall.Exec (KeygenZintCall.calleeBody .rebuildCrt) entry
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ ∧
    (walkState (s0 entry pp p0 px) px p0 words 512).heap
      =walkImage (Word32Memory176.write entry.heap pp p0) px p0 words 512 ∧
    (∀ i, i < 512 → Load32 (walkState (s0 entry pp p0 px) px p0 words 512).heap
      (elem px i) (normWord p0 (words i))) := by
  have p1 : KeygenZintCall.Exec MakeFgCrtShape194.crtDeclU entry ⟨d1 entry,.normal⟩ := by
    rw [declu_shape]
    exact ZintNormWord194.word_declare .u64 [uName] entry
  have p2 : KeygenZintCall.Exec MakeFgCrtShape194.crtDeclX (d1 entry) ⟨d3 entry,.normal⟩ := by
    rw [declx_split,declx_ptr,declx_tail]
    exact KeygenZintCall.Exec.seqNormal _ _ (d1 entry) (d2 entry) ⟨d3 entry,.normal⟩
      (declarePtr_run (d1 entry) xName) (ZintNormWord194.word_skip (d3 entry))
  have d3Primes : (d3 entry).arrays primesName=some primes := by
    show (d2 entry).arrays primesName=_
    rw [d2_arrays entry primesName (by decide),d1_arrays]
    exact primeBind
  have d3Tmp : (d3 entry).arrays tmpName=some pp := by
    show (d2 entry).arrays tmpName=_
    rw [d2_arrays entry tmpName (by decide),d1_arrays]
    exact tmpBind
  have primeRead : KeygenLevelCalls.PrimeRead (d3 entry) primesName (.literal .i32 0) .p
      (.uint32 p0) :=
    KeygenLevelCalls.PrimeRead.read primes p0
      (i32zero_pointer (d3 entry) primesName primes d3Primes primeCap)
      primeWidth primeExtent (by rw [d3_heap]; exact tableLoad)
  have storeRun : KeygenZintCall.Exec MakeFgCrtShape194.crtStore (d3 entry)
      ⟨d4 entry pp p0,.normal⟩ := by
    rw [store_shape]
    refine KeygenZintCall.Exec.storePrime tmpName (.literal .i32 0) primesName (.literal .i32 0)
      .p (d3 entry) (Word32Memory176.write entry.heap pp p0) pp p0 primeRead
      (i32zero_pointer (d3 entry) tmpName pp d3Tmp pcap) ?_
    rw [d3_heap]
    exact Word32Memory176.source entry.heap pp p0 ppAlloc widthP writableP
  have assignRun : KeygenZintCall.Exec coreHead (d4 entry pp p0) ⟨d5 entry pp p0,.normal⟩ := by
    rw [core_head]
    refine assign_i32_run (d4 entry pp p0) uName (.literal .i32 1) .uint64
      none (.int32 1#32) (d4_u_decl entry pp p0) ?_
    exact KeygenWordExpr.Eval.scalar (.literal .i32 1) (.int32 1#32)
      (C99ScalarReference.Eval.literal .int32 1)
  have signAt5 : (d5 entry pp p0).locals normSignedName=some (.int32,some (.int32 1#32)) := by
    rw [d5_locals entry pp p0 normSignedName (by decide)]
    exact signCell
  have lenAt5 : (d5 entry pp p0).locals xlenName=some (.uint64,some (.uint64 (word 1))) := by
    rw [d5_locals entry pp p0 xlenName (by decide)]
    exact lenCell
  have coFalse : KeygenZintCall.Exec coLoop (d5 entry pp p0) ⟨d5 entry pp p0,.normal⟩ := by
    rw [co_split,co_guard]
    refine KeygenZintCall.Exec.loopFalse _ _ _ (d5 entry pp p0)
      (C99ScalarReference.boolean (decide (1<1))) ?_ (by decide)
    exact KeygenWordExpr.Eval.cmp .lt (.scalar (.var uName)) (.scalar (.var xlenName))
      (.uint64 (word 1)) (.uint64 (word 1)) (C99ScalarReference.boolean (decide (1<1)))
      (KeygenWordExpr.Eval.scalar (.var uName) (.uint64 (word 1))
        (C99ScalarReference.Eval.variable uName .uint64 (.uint64 (word 1))
          (d5_u_one entry pp p0)))
      (KeygenWordExpr.Eval.scalar (.var xlenName) (.uint64 (word 1))
        (C99ScalarReference.Eval.variable xlenName .uint64 (.uint64 (word 1)) lenAt5))
      (C99NatWord141.less 1 1 (by decide) (by decide))
  have coreRun : KeygenZintCall.Exec MakeFgCrtShape194.crtCore (d4 entry pp p0)
      ⟨d5 entry pp p0,.normal⟩ := by
    rw [core_split]
    exact KeygenZintCall.Exec.seqNormal _ _ (d4 entry pp p0) (d5 entry pp p0)
      ⟨d5 entry pp p0,.normal⟩ assignRun coFalse
  have u0Run : KeygenZintCall.Exec ZintNormWalk194.normUZero (d5 entry pp p0)
      ⟨d7 entry pp p0,.normal⟩ := by
    rw [ZintNormWalk194.norm_uzero]
    refine assign_i32_run (d5 entry pp p0) uName (.literal .i32 0) .uint64
      (some (.uint64 (word 1))) (.int32 0#32) (d5_u_one entry pp p0) ?_
    exact KeygenWordExpr.Eval.scalar (.literal .i32 0) (.int32 0#32)
      (C99ScalarReference.Eval.literal .int32 0)
  have d7Xx : (d7 entry pp p0).arrays xxName=some px := by
    rw [d7_arrays entry pp p0 xxName (by decide)]
    exact xxBind
  have xinitRun : KeygenZintCall.Exec ZintNormWalk194.normXInit (d7 entry pp p0)
      ⟨s0 entry pp p0 px,.normal⟩ := by
    rw [ZintNormWalk194.norm_xinit]
    refine ZintNormWord194.word_run _ _ _
      (KeygenWordExec.Exec.modular _ _ _ (C99ModularReference.GenExec.base _ _ _
        (C99ArrayReference.Exec.bindPtr (d7 entry pp p0) xName xxName
          C99ProcedureParser.zero (elem px 0) ?_)))
    refine zero_pointer (d7 entry pp p0) xxName px d7Xx ?_
    show px.index+0≤px.count
    omega
  have s0Tmp : (s0 entry pp p0 px).arrays tmpName=some pp := by
    rw [arrays_keep entry pp p0 px tmpName (by decide)]
    exact tmpBind
  have s0Len : (s0 entry pp p0 px).locals xlenName=some (.uint64,some (.uint64 (word 1))) := by
    rw [locals_keep entry pp p0 px xlenName (by decide)]
    exact lenCell
  have s0Stride : (s0 entry pp p0 px).locals xstrideName=
      some (.uint64,some (.uint64 (word 1))) := by
    rw [locals_keep entry pp p0 px xstrideName (by decide)]
    exact strideCell
  have s0Num : (s0 entry pp p0 px).locals numName=some (.uint64,some (.uint64 (word 512))) := by
    rw [locals_keep entry pp p0 px numName (by decide)]
    exact numCell
  have s0Loads : ∀ j, j < 512 → Load32 (s0 entry pp p0 px).heap (elem px j) (words j) := by
    intro j bound
    rw [d8_heap]
    exact Word32Memory176.outside entry.heap pp (elem px j) p0 (words j)
      (separate_symm (tsep j bound)) (loads j bound)
  have s0TmpLoad : Load32 (s0 entry pp p0 px).heap pp p0 := by
    rw [d8_heap]
    exact Word32Memory176.here entry.heap pp p0 ppAlloc widthP writableP
  have s0Writable : (s0 entry pp p0 px).heap.writable px.block=true := by
    rw [d8_heap,ZintNormWalk194.write_writable]
    exact writable
  have walkExport := walk_run (s0 entry pp p0 px) px pp p0 words widthX
    (u_at_s0 entry pp p0 px) (s0_arrays_x entry pp p0 px) s0Tmp s0Len s0Stride s0Num
    s0Loads s0TmpLoad s0Writable tsep xcap pcap
  obtain ⟨walkRun,walkImageExport,_,_,_⟩ := walkExport
  have loopPart : KeygenZintCall.Exec ZintNormWalk194.normLoopPart (s0 entry pp p0 px)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    rw [ZintNormWalk194.norm_loop]
    exact walkRun
  have initPart : KeygenZintCall.Exec ZintNormWalk194.normInit (d5 entry pp p0)
      ⟨s0 entry pp p0 px,.normal⟩ := by
    rw [ZintNormWalk194.norm_init_split]
    exact KeygenZintCall.Exec.seqNormal _ _ (d5 entry pp p0) (d7 entry pp p0)
      ⟨s0 entry pp p0 px,.normal⟩ u0Run xinitRun
  have p1Part : KeygenZintCall.Exec ZintNormWalk194.normP1 (d5 entry pp p0)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    rw [ZintNormWalk194.norm_p1_split]
    exact KeygenZintCall.Exec.seqNormal _ _ (d5 entry pp p0) (s0 entry pp p0 px)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ initPart loopPart
  have p2Part : KeygenZintCall.Exec ZintNormWalk194.normP2
      (walkState (s0 entry pp p0 px) px p0 words 512)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    rw [ZintNormWalk194.norm_p2_skip]
    exact ZintNormWord194.word_skip _
  have walkPart : KeygenZintCall.Exec ZintNormWalk194.normWalk (d5 entry pp p0)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    rw [ZintNormWalk194.norm_walk_split]
    exact KeygenZintCall.Exec.seqNormal _ _ (d5 entry pp p0)
      (walkState (s0 entry pp p0 px) px p0 words 512)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ p1Part p2Part
  have yesPart : KeygenZintCall.Exec ZintNormWalk194.normYes (d5 entry pp p0)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    rw [ZintNormWalk194.norm_scope]
    exact KeygenZintCall.Exec.scope [] [] ZintNormWalk194.normWalk (d5 entry pp p0)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ walkPart
  have signValue : (Value.int32 1#32).integer≠0 := by decide
  have branchRun : KeygenZintCall.Exec ZintNormWalk194.normBranch (d5 entry pp p0)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    rw [ZintNormWalk194.norm_branch,norm_test]
    exact KeygenZintCall.Exec.branchTrue (.scalar (.var normSignedName))
      ZintNormWalk194.normYes ZintNormWalk194.normNo (d5 entry pp p0)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ (.int32 1#32)
      (KeygenWordExpr.Eval.scalar (.var normSignedName) (.int32 1#32)
        (C99ScalarReference.Eval.variable normSignedName .int32 (.int32 1#32) signAt5))
      signValue yesPart
  have normalizeRun : KeygenZintCall.Exec MakeFgCrtShape194.crtNormalize (d5 entry pp p0)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    show KeygenZintCall.Exec ZintNormWalk194.normWrap (d5 entry pp p0) _
    rw [ZintNormWalk194.norm_split,norm_tail]
    exact KeygenZintCall.Exec.seqNormal _ _ (d5 entry pp p0)
      (walkState (s0 entry pp p0 px) px p0 words 512)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ branchRun
      (ZintNormWord194.word_skip _)
  have rest3Run : KeygenZintCall.Exec MakeFgCrtShape194.crtRest3 (d4 entry pp p0)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    rw [MakeFgCrtShape194.crt_split4]
    exact KeygenZintCall.Exec.seqNormal _ _ (d4 entry pp p0) (d5 entry pp p0)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ coreRun normalizeRun
  have rest2Run : KeygenZintCall.Exec MakeFgCrtShape194.crtRest2 (d3 entry)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    rw [MakeFgCrtShape194.crt_split3]
    exact KeygenZintCall.Exec.seqNormal _ _ (d3 entry) (d4 entry pp p0)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ storeRun rest3Run
  have rest1Run : KeygenZintCall.Exec MakeFgCrtShape194.crtRest1 (d1 entry)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    rw [MakeFgCrtShape194.crt_split2]
    exact KeygenZintCall.Exec.seqNormal _ _ (d1 entry) (d3 entry)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ p2 rest2Run
  have bodyExec : KeygenZintCall.Exec MakeFgCrtShape194.crtBody entry
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ := by
    rw [MakeFgCrtShape194.crt_split1]
    exact KeygenZintCall.Exec.seqNormal _ _ entry (d1 entry)
      ⟨walkState (s0 entry pp p0 px) px p0 words 512,.normal⟩ p1 rest1Run
  refine ⟨?_,?_,?_⟩
  · exact bodyExec
  · rw [walkState_heap,d8_heap]
  · exact walkImageExport

end FT1536.Source3.ZintRebuildCrt194
