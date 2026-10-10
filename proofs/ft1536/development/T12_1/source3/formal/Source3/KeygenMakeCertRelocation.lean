import Source3.KeygenMakeWorkspaceAllocation
import Source3.KeygenMakeWorkspaceTables

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Transport of the certificate execution across the block relocation. The
   pinned certificate machine is block0-based: its `tmp` workspace view is the
   block0 pointer `CertificateAfterConversion.workspacePointer`, its automatic
   flag object is appended to block0 (`C99Automatic32`) and its layout
   resolution requires the block0 aliases. The C call passes the general
   `fk->tmp` scratch at block `b`, so the machine run against that scratch is
   exactly the conjugate of the pinned machine under the block transposition
   sigma=`swapBlock b` (module `KeygenMakeWorkspaceRelocation`): machine block0
   reads original block b, and the actual coefficient pointers read their own
   original blocks. This module defines that relativized execution `ExecAt`
   (hence `CertBindAt`, `CallAt`, `CertificateGateAt`) and proves: (i) the
   caller binding at block b transports to the canonical relocated world,
   where the workspace bridge is DERIVED from the allocation facts; (ii) every
   conclusion predicate (stored leaf words, caller frame, dead automatic flag)
   transports back to actual-world bytes of the scratch block. The
   accepted-package consumption therefore takes no bridge, no shape, no
   scratch-legality and no scratch-block input. No certificate outcome, no
   bridge equality and no scratch-block0 fact is a premise of any theorem
   below. The statement-machine extraction tying the C call site to `ExecAt`
   remains the named open obligation. -/
namespace FT1536.Source3.KeygenMakeCertRelocation
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open CertificateFunctionReference (Arguments)

/-! ## 1. Involutions of the relocation maps -/

theorem map_swapPtr (b : Nat) (o : Option ArrayPointer) :
    (o.map (KeygenMakeWorkspaceRelocation.swapPtr b)).map
      (KeygenMakeWorkspaceRelocation.swapPtr b)=o := by
  cases o with
  | none => rfl
  | some p => exact congrArg some (KeygenMakeWorkspaceRelocation.swapPtr_swapPtr b p)

theorem map_swapPtr_zero (o : Option ArrayPointer) :
    o.map (KeygenMakeWorkspaceRelocation.swapPtr 0)=o := by
  cases o with
  | none => rfl
  | some p => exact congrArg some (KeygenMakeWorkspaceRelocation.swapPtr_zero p)

theorem map_swapPtr_cancel (b : Nat) (o o' : Option ArrayPointer)
    (same : o.map (KeygenMakeWorkspaceRelocation.swapPtr b)=
      o'.map (KeygenMakeWorkspaceRelocation.swapPtr b)) : o=o' := by
  have left := congrArg (fun x => x.map (KeygenMakeWorkspaceRelocation.swapPtr b)) same
  rwa [map_swapPtr b o,map_swapPtr b o'] at left

theorem swapBlock_zero_id (i : Nat) : KeygenMakeWorkspaceRelocation.swapBlock 0 i=i := by
  by_cases hi : i=0 <;> simp [KeygenMakeWorkspaceRelocation.swapBlock,hi]

theorem state_ext (s t : State) (heap : s.heap=t.heap) (locals : s.locals=t.locals)
    (arrays : s.arrays=t.arrays) (globals : s.globals=t.globals) (tables : s.tables=t.tables) : s=t := by
  cases s
  cases t
  simp only [State.mk.injEq]
  exact ⟨heap,locals,arrays,globals,tables⟩

theorem context_ext (ctx ctx' : Context) (object : ctx.object=ctx'.object)
    (scratch : ctx.scratch=ctx'.scratch) (virtualBase : ctx.virtualBase=ctx'.virtualBase) : ctx=ctx' := by
  cases ctx
  cases ctx'
  simp only [Context.mk.injEq]
  exact ⟨object,scratch,virtualBase⟩

theorem args_ext (args args' : Arguments) (base : args.base=args'.base) (f : args.f=args'.f)
    (g : args.g=args'.g) (bigF : args.bigF=args'.bigF) (bigG : args.bigG=args'.bigG)
    (logn : args.logn=args'.logn) (ter : args.ter=args'.ter) : args=args' := by
  cases args
  cases args'
  simp only [Arguments.mk.injEq]
  exact ⟨base,f,g,bigF,bigG,logn,ter⟩

theorem swapState_swapState (b : Nat) (s : State) :
    KeygenMakeWorkspaceBridge.swapState b (KeygenMakeWorkspaceBridge.swapState b s)=s :=
  state_ext _ _ (KeygenMakeWorkspaceRelocation.swap_swap b s.heap) rfl
    (funext fun n => map_swapPtr b (s.arrays n)) rfl
    (funext fun n => map_swapPtr b (s.tables n))

theorem swapState_zero (s : State) : KeygenMakeWorkspaceBridge.swapState 0 s=s :=
  state_ext _ _ (KeygenMakeWorkspaceRelocation.swap_zero s.heap) rfl
    (funext fun n => map_swapPtr_zero (s.arrays n)) rfl
    (funext fun n => map_swapPtr_zero (s.tables n))

theorem relocateCtx_relocateCtx (b : Nat) (ctx : Context) :
    KeygenMakeWorkspaceBridge.relocateCtx b (KeygenMakeWorkspaceBridge.relocateCtx b ctx)=ctx :=
  context_ext _ _ (KeygenMakeWorkspaceRelocation.swapPtr_swapPtr b ctx.object)
    (KeygenMakeWorkspaceRelocation.swapPtr_swapPtr b ctx.scratch)
    (funext fun i => congrArg ctx.virtualBase (KeygenMakeWorkspaceRelocation.swapBlock_self b i))

theorem swapArgs_swapArgs (b : Nat) (args : Arguments) :
    KeygenMakeWorkspaceBridge.swapArgs b (KeygenMakeWorkspaceBridge.swapArgs b args)=args :=
  args_ext _ _ rfl (KeygenMakeWorkspaceRelocation.swapPtr_swapPtr b args.f)
    (KeygenMakeWorkspaceRelocation.swapPtr_swapPtr b args.g)
    (KeygenMakeWorkspaceRelocation.swapPtr_swapPtr b args.bigF)
    (KeygenMakeWorkspaceRelocation.swapPtr_swapPtr b args.bigG) rfl rfl

theorem swapArgs_zero (args : Arguments) : KeygenMakeWorkspaceBridge.swapArgs 0 args=args :=
  args_ext _ _ rfl (KeygenMakeWorkspaceRelocation.swapPtr_zero args.f)
    (KeygenMakeWorkspaceRelocation.swapPtr_zero args.g)
    (KeygenMakeWorkspaceRelocation.swapPtr_zero args.bigF)
    (KeygenMakeWorkspaceRelocation.swapPtr_zero args.bigG) rfl rfl

theorem swapState_heap (b : Nat) (s : State) (h : Memory) :
    KeygenMakeWorkspaceBridge.swapState b {s with heap := h}=
      {KeygenMakeWorkspaceBridge.swapState b s with heap := KeygenMakeWorkspaceRelocation.swap b h} :=
  rfl

def swapResult (b : Nat) (out : Result) : Result :=
  ⟨KeygenMakeWorkspaceBridge.swapState b out.state,out.flow⟩

theorem swapResult_flow (b : Nat) (out : Result) : (swapResult b out).flow=out.flow := rfl

theorem swapResult_zero (out : Result) : swapResult 0 out=out := by
  cases out with
  | mk state flow => simp only [swapResult,swapState_zero]

/-! ## 2. The M0 environment under relocation -/

theorem swapPtr_table (b : Nat) (table : FftTableParser.Table) (hb1 : b≠1) (hb2 : b≠2) :
    KeygenMakeWorkspaceRelocation.swapPtr b (FftGlobalMemory.pointer table)=
      FftGlobalMemory.pointer table := by
  cases table with
  | square =>
    have fixed : KeygenMakeWorkspaceRelocation.swapBlock b 1=1 :=
      KeygenMakeWorkspaceRelocation.swapBlock_fixed b 1 (by decide) (fun same => hb1 same.symm)
    simp [KeygenMakeWorkspaceRelocation.swapPtr,FftGlobalMemory.pointer,FftGlobalMemory.block,fixed]
  | cubic =>
    have fixed : KeygenMakeWorkspaceRelocation.swapBlock b 2=2 :=
      KeygenMakeWorkspaceRelocation.swapBlock_fixed b 2 (by decide) (fun same => hb2 same.symm)
    simp [KeygenMakeWorkspaceRelocation.swapPtr,FftGlobalMemory.pointer,FftGlobalMemory.block,fixed]

theorem swapPtr_withIndex (b : Nat) (p : ArrayPointer) (i : Nat) :
    KeygenMakeWorkspaceRelocation.swapPtr b {p with index := i}=
      {KeygenMakeWorkspaceRelocation.swapPtr b p with index := i} := rfl

theorem pinned_swap_forward (b : Nat) (before : Memory) (hb1 : b≠1) (hb2 : b≠2)
    (source : CertificateM0Environment.Pinned FftGlobalMemory.environment before) :
    CertificateM0Environment.Pinned FftGlobalMemory.environment
      (KeygenMakeWorkspaceRelocation.swap b before) := by
  refine ⟨rfl,?_⟩
  intro table i hi
  have load := source.2 table i hi
  have moved : Load64 (KeygenMakeWorkspaceRelocation.swap b before)
      {FftGlobalMemory.pointer table with index := i} ((FftTableSources.words table)[i]) := by
    have step := (KeygenMakeWorkspaceRelocation.load64_swap b before
      {FftGlobalMemory.pointer table with index := i} ((FftTableSources.words table)[i])).mp load.1
    rwa [swapPtr_withIndex,swapPtr_table b table hb1 hb2] at step
  have writable : (KeygenMakeWorkspaceRelocation.swap b before).writable
      (FftGlobalMemory.block table)=before.writable (FftGlobalMemory.block table) := by
    rw [KeygenMakeWorkspaceRelocation.swap_writable]
    rcases table with _|_
    · rw [show FftGlobalMemory.block .square=1 from rfl,
        show KeygenMakeWorkspaceRelocation.swapBlock b 1=1 from
          KeygenMakeWorkspaceRelocation.swapBlock_fixed b 1 (by decide) (fun same => hb1 same.symm)]
    · rw [show FftGlobalMemory.block .cubic=2 from rfl,
        show KeygenMakeWorkspaceRelocation.swapBlock b 2=2 from
          KeygenMakeWorkspaceRelocation.swapBlock_fixed b 2 (by decide) (fun same => hb2 same.symm)]
  exact ⟨moved,by rw [writable]; exact load.2⟩

/-- The pinned M0 environment realizes in the relocated world and back when
    the transposition leaves the static table blocks alone. -/
theorem pinned_swap (b : Nat) (before : Memory) (hb1 : b≠1) (hb2 : b≠2) :
    CertificateM0Environment.Pinned FftGlobalMemory.environment before ↔
      CertificateM0Environment.Pinned FftGlobalMemory.environment
        (KeygenMakeWorkspaceRelocation.swap b before) :=
  ⟨pinned_swap_forward b before hb1 hb2,fun source => by
    have back := pinned_swap_forward b (KeygenMakeWorkspaceRelocation.swap b before) hb1 hb2 source
    rwa [KeygenMakeWorkspaceRelocation.swap_swap] at back⟩

/-! ## 3. Relativized workspace view and caller binding -/

/-- The workspace view at scratch block `b`: the certificate model's block0
    pointer moved to the block the actual scratch lives in, i.e. the sigma
    image of the block0 view under the relocation. -/
def workspaceAt (b base slot : Nat) : ArrayPointer :=
  KeygenMakeWorkspaceRelocation.swapPtr b (CertificateAfterConversion.workspacePointer base slot)

theorem workspaceAt_swap (b base slot : Nat) :
    KeygenMakeWorkspaceRelocation.swapPtr b (workspaceAt b base slot)=
      CertificateAfterConversion.workspacePointer base slot :=
  KeygenMakeWorkspaceRelocation.swapPtr_swapPtr b
    (CertificateAfterConversion.workspacePointer base slot)

theorem workspaceAt_block (b base slot : Nat) : (workspaceAt b base slot).block=b := by
  simp only [workspaceAt,KeygenMakeWorkspaceRelocation.swapPtr_block,
    CertificateAfterConversion.workspacePointer,KeygenMakeWorkspaceRelocation.swapBlock_zero]

theorem workspaceAt_offset (b base slot : Nat) :
    ArrayPointer.offset (workspaceAt b base slot)=
      ArrayPointer.offset (CertificateAfterConversion.workspacePointer base slot) :=
  KeygenMakeWorkspaceRelocation.swapPtr_offset b
    (CertificateAfterConversion.workspacePointer base slot)

/-- The caller cells at scratch block `b`: the `CertBind` shape with the
    workspace bridge evaluated on the actual scratch block instead of the
    model's block0. -/
structure CertBindAt (b : Nat) (s : State) (ctx : Context) (args : Arguments) : Prop where
  context : s.arrays "fk".toList=some ctx.object
  fCell : s.arrays "f".toList=some args.f
  gCell : s.arrays "g".toList=some args.g
  bigFCell : s.arrays "F".toList=some args.bigF
  bigGCell : s.arrays "G".toList=some args.bigG
  lognCell : s.locals "logn".toList=some (.uint32,some (.uint32 args.logn))
  terCell : s.locals "ter".toList=some (.uint32,some (.uint32 args.ter))
  tmpRead : KeygenSearchContext.ReadTmp ctx s ctx.scratch
  workspace : workspaceAt b args.base 0=KeygenMakeCertCall.fprCast ctx.scratch

theorem cells_swap (b : Nat) (s : State) (ctx : Context) (args : Arguments) :
    KeygenMakeWorkspaceBridge.Cells s ctx args ↔
      KeygenMakeWorkspaceBridge.Cells (KeygenMakeWorkspaceBridge.swapState b s)
        (KeygenMakeWorkspaceBridge.relocateCtx b ctx) (KeygenMakeWorkspaceBridge.swapArgs b args) := by
  constructor
  · exact KeygenMakeWorkspaceBridge.cells_relocated b s ctx args
  · intro moved
    have twice := KeygenMakeWorkspaceBridge.cells_relocated b
      (KeygenMakeWorkspaceBridge.swapState b s) (KeygenMakeWorkspaceBridge.relocateCtx b ctx)
      (KeygenMakeWorkspaceBridge.swapArgs b args) moved
    rwa [swapState_swapState,relocateCtx_relocateCtx,swapArgs_swapArgs] at twice

theorem workspaceAt_iff (b : Nat) (ctx : Context) (args : Arguments) :
    workspaceAt b args.base 0=KeygenMakeCertCall.fprCast ctx.scratch ↔
      CertificateAfterConversion.workspacePointer args.base 0=
        KeygenMakeCertCall.fprCast (KeygenMakeWorkspaceRelocation.swapPtr b ctx.scratch) := by
  constructor
  · intro equal
    have moved := congrArg (KeygenMakeWorkspaceRelocation.swapPtr b) equal
    rwa [workspaceAt_swap,KeygenMakeWorkspaceRelocation.fprCast_swap] at moved
  · intro equal
    have moved := congrArg (KeygenMakeWorkspaceRelocation.swapPtr b) equal
    rwa [KeygenMakeWorkspaceRelocation.fprCast_swap,
      KeygenMakeWorkspaceRelocation.swapPtr_swapPtr] at moved

/-- The caller binding at scratch block `b` is exactly the canonical relocated
    binding: the cells transport under the transposition and the workspace
    bridge is the same equality read in the two worlds. -/
theorem certBindAt_iff (b : Nat) (s : State) (ctx : Context) (args : Arguments) :
    CertBindAt b s ctx args ↔
      KeygenMakeCertCall.CertBind (KeygenMakeWorkspaceBridge.swapState b s)
        (KeygenMakeWorkspaceBridge.relocateCtx b ctx) (KeygenMakeWorkspaceBridge.swapArgs b args) := by
  constructor
  · intro bind
    have cells := (cells_swap b s ctx args).mp ⟨bind.context,bind.fCell,bind.gCell,bind.bigFCell,
      bind.bigGCell,bind.lognCell,bind.terCell,bind.tmpRead⟩
    exact { context := cells.context
            fCell := cells.fCell
            gCell := cells.gCell
            bigFCell := cells.bigFCell
            bigGCell := cells.bigGCell
            lognCell := cells.lognCell
            terCell := cells.terCell
            tmpRead := cells.tmpRead
            workspace := (workspaceAt_iff b ctx args).mp bind.workspace }
  · intro bind
    have cells := (cells_swap b s ctx args).mpr ⟨bind.context,bind.fCell,bind.gCell,bind.bigFCell,
      bind.bigGCell,bind.lognCell,bind.terCell,bind.tmpRead⟩
    exact { context := cells.context
            fCell := cells.fCell
            gCell := cells.gCell
            bigFCell := cells.bigFCell
            bigGCell := cells.bigGCell
            lognCell := cells.lognCell
            terCell := cells.terCell
            tmpRead := cells.tmpRead
            workspace := (workspaceAt_iff b ctx args).mpr bind.workspace }

/-! ## 4. Relativized certificate execution, call and gate -/

/-- The certificate body executed against the actual scratch at block `b`:
    the sigma conjugate of the pinned block0 machine. Its workspace reads hit
    block b of the actual heap, its material pointers hit the actual
    coefficient blocks and its automatic flag object is appended to the
    scratch block. This IS the transport of `CertificateM0Environment.Exec`
    across the block relocation. -/
def ExecAt (b : Nat) (args : Arguments) (caller after : Memory) (gateTrace : List (BitVec 64))
    (events : List CertificateEffects.Event) (ret : Bool) : Prop :=
  CertificateM0Environment.Exec (KeygenMakeWorkspaceBridge.swapArgs b args)
    (KeygenMakeWorkspaceRelocation.swap b caller) (KeygenMakeWorkspaceRelocation.swap b after)
    gateTrace events ret

theorem execAt_zero (args : Arguments) (caller after : Memory) (gateTrace : List (BitVec 64))
    (events : List CertificateEffects.Event) (ret : Bool) :
    ExecAt 0 args caller after gateTrace events ret ↔
      CertificateM0Environment.Exec args caller after gateTrace events ret := by
  simp only [ExecAt,swapArgs_zero,KeygenMakeWorkspaceRelocation.swap_zero]

theorem execAt_swap (b : Nat) (args : Arguments) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool) :
    ExecAt b (KeygenMakeWorkspaceBridge.swapArgs b args)
      (KeygenMakeWorkspaceRelocation.swap b caller) (KeygenMakeWorkspaceRelocation.swap b after)
      gateTrace events ret ↔
      CertificateM0Environment.Exec args caller after gateTrace events ret := by
  simp only [ExecAt,swapArgs_swapArgs,KeygenMakeWorkspaceRelocation.swap_swap]

/-- The certificate call at scratch block `b`: the canonical relocated call,
    whose body is the relativized execution `ExecAt`. -/
def CallAt (b : Nat) (ctx : Context) (before after : State) (v : Value) (ret : Bool) : Prop :=
  KeygenMakeCertCall.Call (KeygenMakeWorkspaceBridge.relocateCtx b ctx)
    (KeygenMakeWorkspaceBridge.swapState b before) (KeygenMakeWorkspaceBridge.swapState b after)
    v ret

/-- The transported call constructor: an actual-world binding and relativized
    body give the actual-world call at scratch block `b`. -/
theorem callAt_run (b : Nat) (ctx : Context) (before : State) (args : Arguments)
    (bind : CertBindAt b before ctx args) (afterMem : Memory) (gateTrace : List (BitVec 64))
    (events : List CertificateEffects.Event) (ret : Bool)
    (body : ExecAt b args before.heap afterMem gateTrace events ret) (v : Value)
    (bit : (ret=true ↔ v.integer≠0)) :
    CallAt b ctx before {before with heap := afterMem} v ret := by
  simp only [CallAt]
  rw [swapState_heap]
  exact KeygenMakeCertCall.Call.run (KeygenMakeWorkspaceBridge.swapArgs b args)
    ((certBindAt_iff b before ctx args).mp bind) (KeygenMakeWorkspaceRelocation.swap b afterMem)
    gateTrace events ret body v bit

theorem callAt_bit (b : Nat) (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (source : CallAt b ctx before after v ret) : (ret=true ↔ v.integer≠0) :=
  KeygenMakeCertCall.call_bit (KeygenMakeWorkspaceBridge.relocateCtx b ctx)
    (KeygenMakeWorkspaceBridge.swapState b before) (KeygenMakeWorkspaceBridge.swapState b after)
    v ret source

theorem callAt_cells (b : Nat) (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (source : CallAt b ctx before after v ret) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
  have cells := KeygenMakeCertCall.call_cells (KeygenMakeWorkspaceBridge.relocateCtx b ctx)
    (KeygenMakeWorkspaceBridge.swapState b before) (KeygenMakeWorkspaceBridge.swapState b after)
    v ret source
  refine ⟨cells.1,?_,?_⟩
  · funext n
    exact map_swapPtr_cancel b (after.arrays n) (before.arrays n)
      (congrFun cells.2.1 n)
  · funext n
    exact map_swapPtr_cancel b (after.tables n) (before.tables n)
      (congrFun cells.2.2 n)

theorem profile_swapState (b : Nat) (s : State) :
    KeygenMakeCertCall.Profile (KeygenMakeWorkspaceBridge.swapState b s)↔
      KeygenMakeCertCall.Profile s :=
  Iff.rfl

/-- The sixth gate at scratch block `b`: the canonical relocated gate. -/
def CertificateGateAt (b : Nat) (ctx : Context) (before : State) : Result → Prop :=
  fun out => KeygenMakeCertCall.CertificateGate (KeygenMakeWorkspaceBridge.relocateCtx b ctx)
    (KeygenMakeWorkspaceBridge.swapState b before) (swapResult b out)

theorem gateAt_rejected (b : Nat) (ctx : Context) (before after : State) (v : Value)
    (call : CallAt b ctx before after v false) :
    CertificateGateAt b ctx before ⟨after,.continueLoop⟩ :=
  KeygenMakeCertCall.CertificateGate.rejected (KeygenMakeWorkspaceBridge.swapState b after) v call

theorem gateAt_accepted (b : Nat) (ctx : Context) (before after : State) (v : Value)
    (call : CallAt b ctx before after v true) :
    CertificateGateAt b ctx before ⟨after,.breakLoop⟩ :=
  KeygenMakeCertCall.CertificateGate.accepted (KeygenMakeWorkspaceBridge.swapState b after) v call

theorem gateAt_unprofiled (b : Nat) (ctx : Context) (before : State)
    (noProfile : ¬KeygenMakeCertCall.Profile before) :
    CertificateGateAt b ctx before ⟨before,.breakLoop⟩ :=
  KeygenMakeCertCall.CertificateGate.unprofiled (fun h => noProfile ((profile_swapState b before).mp h))

theorem gateAt_flow (b : Nat) (ctx : Context) (before : State) (out : Result)
    (source : CertificateGateAt b ctx before out) :
    out.flow=.continueLoop ∨ out.flow=.breakLoop :=
  KeygenMakeCertCall.gate_flow (KeygenMakeWorkspaceBridge.relocateCtx b ctx)
    (KeygenMakeWorkspaceBridge.swapState b before) (swapResult b out) source

theorem gateAt_no_normal (b : Nat) (ctx : Context) (before : State) (out : Result)
    (source : CertificateGateAt b ctx before out) : out.flow≠.normal :=
  KeygenMakeCertCall.gate_no_normal (KeygenMakeWorkspaceBridge.relocateCtx b ctx)
    (KeygenMakeWorkspaceBridge.swapState b before) (swapResult b out) source

theorem accepted_break_requires_callAt (b : Nat) (ctx : Context) (before : State) (out : Result)
    (source : CertificateGateAt b ctx before out) (profile : KeygenMakeCertCall.Profile before)
    (accepted : out.flow=.breakLoop) :
    ∃ after v, CallAt b ctx before after v true ∧ out=⟨after,.breakLoop⟩ := by
  cases out with
  | mk state flow =>
    have transported := KeygenMakeCertCall.accepted_break_requires_call
      (KeygenMakeWorkspaceBridge.relocateCtx b ctx) (KeygenMakeWorkspaceBridge.swapState b before)
      (swapResult b ⟨state,flow⟩) source ((profile_swapState b before).mp profile) accepted
    obtain ⟨after,v,call,shape⟩ := transported
    have state_eq : KeygenMakeWorkspaceBridge.swapState b state=after :=
      congrArg Result.state shape
    have flow_eq : flow=.breakLoop := congrArg Result.flow shape
    subst state_eq
    cases flow_eq
    exact ⟨state,v,call,rfl⟩

theorem retry_requires_callAt (b : Nat) (ctx : Context) (before : State) (out : Result)
    (source : CertificateGateAt b ctx before out) (profile : KeygenMakeCertCall.Profile before)
    (rejected : out.flow=.continueLoop) :
    ∃ after v, CallAt b ctx before after v false ∧ out=⟨after,.continueLoop⟩ := by
  cases out with
  | mk state flow =>
    have transported := KeygenMakeCertCall.retry_requires_call
      (KeygenMakeWorkspaceBridge.relocateCtx b ctx) (KeygenMakeWorkspaceBridge.swapState b before)
      (swapResult b ⟨state,flow⟩) source ((profile_swapState b before).mp profile) rejected
    obtain ⟨after,v,call,shape⟩ := transported
    have state_eq : KeygenMakeWorkspaceBridge.swapState b state=after :=
      congrArg Result.state shape
    have flow_eq : flow=.continueLoop := congrArg Result.flow shape
    subst state_eq
    cases flow_eq
    exact ⟨state,v,call,rfl⟩

/-! ## 5. Actual-world conclusion predicates -/

/-- The automatic flag object of the certificate call at scratch block `b`:
    appended to the scratch block, as the pinned machine appends it to its
    block0. -/
def pointerAt (b : Nat) (before : Memory) : ArrayPointer :=
  ⟨b,C99Automatic32.align4 (before.size b),1,4,0⟩

theorem align4_swap (b : Nat) (before : Memory) :
    C99Automatic32.align4 ((KeygenMakeWorkspaceRelocation.swap b before).size 0)=
      C99Automatic32.align4 (before.size b) := by
  rw [KeygenMakeWorkspaceRelocation.swap_size,KeygenMakeWorkspaceRelocation.swapBlock_zero]

theorem pointerAt_swap (b : Nat) (before : Memory) :
    KeygenMakeWorkspaceRelocation.swapPtr b (pointerAt b before)=
      C99Automatic32.pointer (KeygenMakeWorkspaceRelocation.swap b before) := by
  simp only [KeygenMakeWorkspaceRelocation.swapPtr,pointerAt,C99Automatic32.pointer,
    C99Automatic32.address,KeygenMakeWorkspaceRelocation.swapBlock_self_zero,align4_swap]

def SpaceAt (b : Nat) (before : Memory) : Prop :=
  C99Automatic32.align4 (before.size b)+4<2^64

theorem spaceAt_iff (b : Nat) (before : Memory) :
    SpaceAt b before↔
      C99Automatic32.Space (KeygenMakeWorkspaceRelocation.swap b before) := by
  simp only [SpaceAt,C99Automatic32.Space,C99Automatic32.address,align4_swap]

/-- The certificate frame legality at scratch block `b`: the workspace and the
    automatic object live in the actual scratch block. -/
def LegalAt (b base : Nat) (before : Memory) : Prop :=
  base%8=0 ∧ base+CertificateWorkspace.bytes≤before.size b ∧ before.writable b=true ∧ SpaceAt b before

theorem legalAt_iff (b base : Nat) (before : Memory) :
    LegalAt b base before↔
      CertificateFrameEntry.Legal base (KeygenMakeWorkspaceRelocation.swap b before) := by
  constructor
  · intro parts
    refine ⟨parts.1,?_,?_,(spaceAt_iff b before).mp parts.2.2.2⟩
    · rw [KeygenMakeWorkspaceRelocation.swap_size,
        KeygenMakeWorkspaceRelocation.swapBlock_zero]
      exact parts.2.1
    · rw [KeygenMakeWorkspaceRelocation.swap_writable,
        KeygenMakeWorkspaceRelocation.swapBlock_zero]
      exact parts.2.2.1
  · intro legal
    refine ⟨legal.aligned,?_,?_,(spaceAt_iff b before).mpr legal.localSpace⟩
    · have keep := legal.workspace
      rwa [KeygenMakeWorkspaceRelocation.swap_size,
        KeygenMakeWorkspaceRelocation.swapBlock_zero] at keep
    · have keep := legal.writable
      rwa [KeygenMakeWorkspaceRelocation.swap_writable,
        KeygenMakeWorkspaceRelocation.swapBlock_zero] at keep

/-- The certificate layout at scratch block `b`: the workspace slots at the
    actual base and the automatic flag appended to the actual scratch block. -/
def layoutAt (b : Nat) (args : Arguments) (before : Memory) : CertificateMemory.Layout :=
  CertificateWorkspace.layout args.base (C99Automatic32.align4 (before.size b))

theorem layoutAt_swap (b : Nat) (args : Arguments) (before : Memory) :
    CertificateFunctionWitness.layout (KeygenMakeWorkspaceBridge.swapArgs b args)
      (KeygenMakeWorkspaceRelocation.swap b before)=layoutAt b args before := by
  rw [CertificateFunctionWitness.layout,layoutAt,C99Automatic32.address]
  rw [KeygenMakeWorkspaceRelocation.swap_size,KeygenMakeWorkspaceRelocation.swapBlock_zero]
  rfl
/-- The stored leaf words at scratch block `b`: the 768 fpr words physically
    read from the actual scratch block at the certificate leaves slots. -/
def StoredBoundsAt (b : Nat) (args : Arguments) (caller after : Memory) : Prop :=
  ∀ i<1536, ∃ word,
    StableBinaryByteView.wordRead (C99MemoryBridge.encode (KeygenMakeWorkspaceRelocation.swap b after))
      (StableBinary.addr (CertificateMemory.leaves (layoutAt b args caller)) i)=some word ∧
    Run2.KeygenLeafGate.positive word=true ∧
    Run2.KeygenLeafGate.lowerBits.toNat≤word.toNat ∧
    word.toNat≤Run2.KeygenLeafGate.upperBits.toNat ∧
    (1024 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue word ∧
    Run2.KeygenLeafGate.positiveNormalValue word<(332054 : ℝ)

theorem storedBoundsAt_iff (b : Nat) (args : Arguments) (caller after : Memory) :
    StoredBoundsAt b args caller after↔
      CertificateFunctionOutcome.StoredBounds (KeygenMakeWorkspaceBridge.swapArgs b args)
        (KeygenMakeWorkspaceRelocation.swap b caller) (KeygenMakeWorkspaceRelocation.swap b after) := by
  simp only [StoredBoundsAt,CertificateFunctionOutcome.StoredBounds,layoutAt_swap]

/-- A physical 64-bit load from the actual scratch block is the encoded word
    read of the transported byte view. -/
theorem wordRead_at_load64 (b : Nat) (h : Memory) (x : Nat) (w : BitVec 64)
    (load : Load64 h ⟨b,x,1,8,0⟩ w) :
    StableBinaryByteView.wordRead (C99MemoryBridge.encode (KeygenMakeWorkspaceRelocation.swap b h)) x=
      some w := by
  have moved : Load64 (KeygenMakeWorkspaceRelocation.swap b h) ⟨0,x,1,8,0⟩ w := by
    simpa only [KeygenMakeWorkspaceRelocation.swapPtr,
      KeygenMakeWorkspaceRelocation.swapBlock_self_zero] using
      (KeygenMakeWorkspaceRelocation.load64_swap b h ⟨b,x,1,8,0⟩ w).mp load
  exact C99MemoryBridge.load64_source_to_interpreter
    (KeygenMakeWorkspaceRelocation.swap b h) ⟨0,x,1,8,0⟩ w rfl moved

/-- The caller frame at scratch block `b`: every live byte outside the
    transported certificate workspace footprint keeps its content. -/
def CallerFrameAt (b : Nat) (args : Arguments) (caller after : Memory) : Prop :=
  ∀ block offset, offset<caller.size block →
    CertificateRegionFrame.Outside args.base (KeygenMakeWorkspaceRelocation.swapBlock b block) offset →
    C99PointerFootprint.TablesOutside
      (CertificateFunctionReference.initial (KeygenMakeWorkspaceBridge.swapArgs b args)
        FftGlobalMemory.environment (KeygenMakeWorkspaceRelocation.swap b caller))
      (KeygenMakeWorkspaceRelocation.swapBlock b block) offset →
    after.bytes block offset=caller.bytes block offset

theorem callerFrameAt_iff (b : Nat) (args : Arguments) (caller after : Memory) :
    CallerFrameAt b args caller after↔
      CertificateFunctionOutcome.CallerFrame (KeygenMakeWorkspaceBridge.swapArgs b args)
        FftGlobalMemory.environment (KeygenMakeWorkspaceRelocation.swap b caller)
        (KeygenMakeWorkspaceRelocation.swap b after) := by
  constructor
  · intro frame block offset live outside tables
    rw [KeygenMakeWorkspaceRelocation.swap_size] at live
    rw [KeygenMakeWorkspaceRelocation.swap_bytes,KeygenMakeWorkspaceRelocation.swap_bytes]
    have hk : KeygenMakeWorkspaceRelocation.swapBlock b
        (KeygenMakeWorkspaceRelocation.swapBlock b block)=block :=
      KeygenMakeWorkspaceRelocation.swapBlock_self b block
    have outside' : CertificateRegionFrame.Outside args.base
        (KeygenMakeWorkspaceRelocation.swapBlock b
          (KeygenMakeWorkspaceRelocation.swapBlock b block)) offset := by rwa [hk]
    have tables' : C99PointerFootprint.TablesOutside
        (CertificateFunctionReference.initial (KeygenMakeWorkspaceBridge.swapArgs b args)
          FftGlobalMemory.environment (KeygenMakeWorkspaceRelocation.swap b caller))
        (KeygenMakeWorkspaceRelocation.swapBlock b
          (KeygenMakeWorkspaceRelocation.swapBlock b block)) offset := by rwa [hk]
    exact frame (KeygenMakeWorkspaceRelocation.swapBlock b block) offset live outside' tables'
  · intro frame block offset live outside tables
    have live' : offset<(KeygenMakeWorkspaceRelocation.swap b caller).size
        (KeygenMakeWorkspaceRelocation.swapBlock b block) := by
      rwa [KeygenMakeWorkspaceRelocation.swap_size,
        KeygenMakeWorkspaceRelocation.swapBlock_self]
    have keep := frame (KeygenMakeWorkspaceRelocation.swapBlock b block) offset live' outside tables
    rw [KeygenMakeWorkspaceRelocation.swap_bytes,
      KeygenMakeWorkspaceRelocation.swap_bytes] at keep
    rwa [KeygenMakeWorkspaceRelocation.swapBlock_self] at keep

theorem swapBlock_table_free (b block : Nat) (hb1 : b≠1) (hb2 : b≠2)
    (h1 : block≠1) (h2 : block≠2) :
    KeygenMakeWorkspaceRelocation.swapBlock b block≠1 ∧
      KeygenMakeWorkspaceRelocation.swapBlock b block≠2 := by
  by_cases h0 : block=0
  · rw [h0,KeygenMakeWorkspaceRelocation.swapBlock_zero]
    exact ⟨hb1,hb2⟩
  · by_cases hb : block=b
    · rw [hb,KeygenMakeWorkspaceRelocation.swapBlock_self_zero]
      exact ⟨by decide,by decide⟩
    · rw [KeygenMakeWorkspaceRelocation.swapBlock_fixed b block h0 hb]
      exact ⟨h1,h2⟩

/-- Any live byte of a foreign block outside the transported certificate
    footprint keeps its content through the call at scratch block `b`. -/
theorem foreign_block_retained_at (b : Nat) (args : Arguments) (caller after : Memory)
    (frame : CallerFrameAt b args caller after) (block offset : Nat)
    (live : offset<caller.size block)
    (outside : CertificateRegionFrame.Outside args.base
      (KeygenMakeWorkspaceRelocation.swapBlock b block) offset)
    (not1 : block≠1) (not2 : block≠2) (hb1 : b≠1) (hb2 : b≠2) :
    after.bytes block offset=caller.bytes block offset := by
  rcases swapBlock_table_free b block hb1 hb2 not1 not2 with ⟨free1,free2⟩
  exact frame block offset live outside
    (KeygenMakeWorkspaceTables.tablesOutside_nonTable
      (KeygenMakeWorkspaceBridge.swapArgs b args)
      (KeygenMakeWorkspaceRelocation.swap b caller)
      (KeygenMakeWorkspaceRelocation.swapBlock b block) offset free1 free2)

/-- The actual scratch block keeps its foreign bytes outside the certificate
    workspace extent through the call at scratch block `b`. -/
theorem workspace_block_retained_at (b : Nat) (args : Arguments) (caller after : Memory)
    (frame : CallerFrameAt b args caller after) (offset : Nat)
    (live : offset<caller.size b)
    (outside : CertificateRegionFrame.Outside args.base 0 offset) :
    after.bytes b offset=caller.bytes b offset :=
  frame b offset live
    (by rwa [KeygenMakeWorkspaceRelocation.swapBlock_self_zero])
    (by rw [KeygenMakeWorkspaceRelocation.swapBlock_self_zero]
        exact KeygenMakeWorkspaceTables.tablesOutside_zero
          (KeygenMakeWorkspaceBridge.swapArgs b args)
          (KeygenMakeWorkspaceRelocation.swap b caller) offset)

/-- The automatic flag object is dead after the call at scratch block `b`. -/
def DeadAt (b : Nat) (before after : Memory) : Prop :=
  ∀ w : BitVec 32, ¬Load32 after (pointerAt b before) w

theorem deadAt_iff (b : Nat) (before after : Memory) :
    DeadAt b before after↔
      (∀ w : BitVec 32, ¬Load32 (KeygenMakeWorkspaceRelocation.swap b after)
        (C99Automatic32.pointer (KeygenMakeWorkspaceRelocation.swap b before)) w) := by
  constructor
  · intro dead w load
    have swapped : Load32 (KeygenMakeWorkspaceRelocation.swap b after)
        (KeygenMakeWorkspaceRelocation.swapPtr b (pointerAt b before)) w := by
      rwa [pointerAt_swap b before]
    exact dead w ((KeygenMakeWorkspaceRelocation.load32_swap b after (pointerAt b before) w).mpr swapped)
  · intro dead w load
    have swapped : Load32 (KeygenMakeWorkspaceRelocation.swap b after)
        (KeygenMakeWorkspaceRelocation.swapPtr b (pointerAt b before)) w :=
      (KeygenMakeWorkspaceRelocation.load32_swap b after (pointerAt b before) w).mp load
    exact dead w (by rwa [pointerAt_swap b before] at swapped)

/-! ## 6. Accepted-package consumption at the scratch block -/

/-- The accepted certificate package read in the actual world at scratch
    block `b`: every conclusion predicate evaluated on actual-world bytes. -/
def AcceptedPackageAt (b : Nat) (ctx : Context) (before after : State) : Prop :=
  ∃ (args : Arguments) (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event),
    CertBindAt b before ctx args ∧
    CertificateFunctionSyntax.Bound ∧
    StoredBoundsAt b args before.heap after.heap ∧
    CallerFrameAt b args before.heap after.heap ∧
    DeadAt b before.heap after.heap ∧
    gateTrace.length=768 ∧
    (∀ event∈events, CertificateEffects.Good event)

theorem dimensions_swapState (b : Nat) (s : State) :
    KeygenMakeSearchPrefix.Dimensions (KeygenMakeWorkspaceBridge.swapState b s)↔
      KeygenMakeSearchPrefix.Dimensions s :=
  ⟨KeygenMakeCertChronology.dimensions_cells rfl,KeygenMakeCertChronology.dimensions_cells rfl⟩

/-- The accepted-package consumption at the actual scratch block: from the
    allocation execution and the transported certificate call, with NO
    bridge, shape, scratch-legality or scratch-block input. -/
theorem accepted_package_at (ctx : Context) (entered before after : State) (v : Value)
    (binding : KeygenMakeWorkspaceAllocation.Binding ctx entered.heap before.heap)
    (call : CallAt ctx.scratch.block ctx before after v true)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (space : SpaceAt ctx.scratch.block before.heap) :
    AcceptedPackageAt ctx.scratch.block ctx before after := by
  have package : KeygenMakeWorkspaceAllocation.AcceptedPackage
      (KeygenMakeWorkspaceBridge.relocateCtx ctx.scratch.block ctx)
      (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block before)
      (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block after) :=
    KeygenMakeWorkspaceAllocation.accepted_certificate_relocated_of_allocation
      ctx entered before after v binding call
      ((dimensions_swapState ctx.scratch.block before).mpr dimensions)
      ((spaceAt_iff ctx.scratch.block before.heap).mp space)
  obtain ⟨args,gateTrace,events,bind,bound,stored,frame,dead,count,good⟩ := package
  refine ⟨KeygenMakeWorkspaceBridge.swapArgs ctx.scratch.block args,gateTrace,events,?_,bound,
    ?_,?_,?_,count,good⟩
  · exact (certBindAt_iff ctx.scratch.block before ctx
      (KeygenMakeWorkspaceBridge.swapArgs ctx.scratch.block args)).mpr
      (by rw [swapArgs_swapArgs]; exact bind)
  · exact (storedBoundsAt_iff ctx.scratch.block
      (KeygenMakeWorkspaceBridge.swapArgs ctx.scratch.block args) before.heap after.heap).mpr
      (by rw [swapArgs_swapArgs]; exact stored)
  · exact (callerFrameAt_iff ctx.scratch.block
      (KeygenMakeWorkspaceBridge.swapArgs ctx.scratch.block args) before.heap after.heap).mpr
      (by rw [swapArgs_swapArgs]; exact frame)
  · exact (deadAt_iff ctx.scratch.block before.heap after.heap).mpr dead

end FT1536.Source3.KeygenMakeCertRelocation
