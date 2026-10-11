import Source3.KeygenCodecNoneBinding
import Source3.KeygenCodecStaticBinding
import Source3.KeygenCodecDispatchBinding
import Source3.KeygenMakeSkeCells

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- A conservative memory-effect projection of the COMPLETE bound bodies.
   Scalar values, branch tests, cursor bounds and return values are erased;
   ALL branch/finite loop paths remain. This proves a destination-BLOCK
   frame without a success, length or frame premise. It is not the typed
   value interpreter or a capacity-window/round-trip theorem. The only heap
   operation in the projection is the actual buf[index] byte store; buf's
   block follows its executed buf=out binding. Fixed calls execute the
   projected source bodies. No callback or supplied callee frame occurs.
   Refinement of full scalar/value C execution to this projection remains
   a named source-adequacy obligation, not a premise of these exports. -/
namespace FT1536.Source3.KeygenCodecFootprint
open C99MemoryReference
open KeygenCodecSyntax
open KeygenMakeInvocation (StoreByte byteOff)

inductive Code where
  | idle | clear | bind | store | ret
  | seq (a b : Code)
  | either (a b : Code)
  | loop (body : Code)
  | call (destination : Callee)
  deriving DecidableEq, Repr

/-- Expressions cannot write heap bytes. Updates are restricted to local
    names and cannot alter the destination pointer bindings. Reads through
    x++, including its local pointer update, are retained as heap reads. -/
def readEffect : Expr → Bool
  | .variable _ | .number _ _ | .argsNil => true
  | .preInc (.variable n) | .postInc (.variable n)
  | .preDec (.variable n) | .postDec (.variable n) =>
      n != "buf".toList && n != "out".toList
  | .preInc _ | .postInc _ | .preDec _ | .postDec _ => false
  | .unary _ e | .cast _ e => readEffect e
  | .binary _ a b | .index a b | .argsCons a b => readEffect a && readEffect b
  | .conditional t a b => readEffect t && readEffect a && readEffect b
  | .member a _ => readEffect a
  | .call _ _ => false

def calleeArgs : Expr := argumentTree
  [.variable "out".toList,.variable "max_out_len".toList,
   .variable "q".toList,.variable "x".toList,.variable "logn".toList]

/-- Reject unsupported effects; never approximate an unknown write or call
    by idle. Switch has exactly the three returning arms of the source. -/
def project : Stmt → Option Code
  | .skip => some .idle
  | .declare objects => some (if objects.any (fun o => o.name=="buf".toList) then .clear else .idle)
  | .write (.variable n) op e =>
      if n="buf".toList then
        if op=.set && e=.variable "out".toList then some .bind else none
      else if n≠"out".toList && readEffect e then some .idle else none
  | .write (.index (.variable n) index) .set e =>
      if n="buf".toList && readEffect index && readEffect e then some .store else none
  | .write _ _ _ => none
  | .increment (.variable n) => if n≠"buf".toList && n≠"out".toList then some .idle else none
  | .increment _ => none
  | .evaluate e => if readEffect e then some .idle else none
  | .seq a b => return .seq (← project a) (← project b)
  | .scope a => project a
  | .branch test a b => if readEffect test then return .either (← project a) (← project b) else none
  | .whileLoop test a => if readEffect test then return .loop (← project a) else none
  | .loop initial test increment body =>
      if test.all readEffect then return .seq (← project initial) (.loop (.seq (← project body) (← project increment))) else none
  | .switch test a b c => if readEffect test then return .either (← project a) (.either (← project b) (← project c)) else none
  | .ret (.call destination args) => if args=calleeArgs then some (.call destination) else none
  | .ret e => if readEffect e then some .ret else none
  | .breakLoop | .continueLoop => none

def noneCode : Code := (project KeygenCodecNoneBinding.code).getD .idle
def staticCode : Code := (project KeygenCodecStaticBinding.code).getD .idle
def dispatchCode : Code := (project KeygenCodecDispatchBinding.code).getD .idle

theorem none_complete : project KeygenCodecNoneBinding.code=some noneCode := by decide +kernel
theorem static_complete : project KeygenCodecStaticBinding.code=some staticCode := by decide +kernel
theorem dispatch_complete : project KeygenCodecDispatchBinding.code=some dispatchCode := by decide +kernel

def body : Callee → Code | .none => noneCode | .static => staticCode

structure State where
  heap : Memory
  buf : Option ArrayPointer
inductive Flow where
  | normal | returned
  deriving DecidableEq

/-- Independent memory-effect execution; no desired frame in a constructor.
    Store permission/allocation and byte effect use the existing byte rule.
    Neither an encoded result nor an encoded length is an input. -/
inductive Exec (dst : ArrayPointer) : Code → State → State → Flow → Prop where
  | idle (s : State) : Exec dst .idle s s .normal
  | clear (s : State) : Exec dst .clear s {s with buf := none} .normal
  | bind (s : State) : Exec dst .bind s {s with buf := some dst} .normal
  | store (s : State) (p : ArrayPointer) (offset : Nat) (value : BitVec 8) (after : Memory)
      (held : s.buf=some p) (write : StoreByte s.heap (byteOff p offset) value after) :
      Exec dst .store s {s with heap := after} .normal
  | ret (s : State) : Exec dst .ret s s .returned
  | seq (a b : Code) (s m t : State) (flow : Flow)
      (first : Exec dst a s m .normal) (second : Exec dst b m t flow) :
      Exec dst (.seq a b) s t flow
  | seqReturn (a b : Code) (s t : State) (first : Exec dst a s t .returned) :
      Exec dst (.seq a b) s t .returned
  | left (a b : Code) (s t : State) (flow : Flow) (step : Exec dst a s t flow) :
      Exec dst (.either a b) s t flow
  | right (a b : Code) (s t : State) (flow : Flow) (step : Exec dst b s t flow) :
      Exec dst (.either a b) s t flow
  | loopDone (a : Code) (s : State) : Exec dst (.loop a) s s .normal
  | loopNext (a : Code) (s m t : State) (flow : Flow)
      (first : Exec dst a s m .normal) (rest : Exec dst (.loop a) m t flow) :
      Exec dst (.loop a) s t flow
  | loopReturn (a : Code) (s t : State) (first : Exec dst a s t .returned) :
      Exec dst (.loop a) s t .returned
  | call (destination : Callee) (s t : State) (flow : Flow)
      (source : Exec dst (body destination) s t flow) : Exec dst (.call destination) s t flow

/-- buf is absent or points into the actual destination block. It is an
    invariant derived from clear/bind, not a supplied heap frame. -/
def Bound (dst : ArrayPointer) (s : State) : Prop := ∀ p, s.buf=some p → p.block=dst.block
structure Frame (dst : ArrayPointer) (before after : Memory) : Prop where
  sizes : after.size=before.size
  writable : after.writable=before.writable
  bytes : ∀ block offset, block≠dst.block → after.bytes block offset=before.bytes block offset

theorem frame_refl (dst : ArrayPointer) (heap : Memory) : Frame dst heap heap :=
  ⟨rfl,rfl,fun _ _ _ => rfl⟩
theorem frame_trans (dst : ArrayPointer) (a b c : Memory)
    (first : Frame dst a b) (second : Frame dst b c) : Frame dst a c :=
  ⟨second.sizes.trans first.sizes,second.writable.trans first.writable,
    fun block offset different => (second.bytes block offset different).trans (first.bytes block offset different)⟩

theorem exec_frame (dst : ArrayPointer) (code : Code) (s t : State) (flow : Flow)
    (source : Exec dst code s t flow) (bound : Bound dst s) :
    Bound dst t ∧ Frame dst s.heap t.heap := by
  induction source with
  | idle | ret | loopDone => exact ⟨bound,frame_refl _ _⟩
  | clear s =>
    refine ⟨?_,frame_refl _ _⟩
    intro p held
    cases held
  | bind s =>
    refine ⟨?_,frame_refl _ _⟩
    intro p held
    have equal : dst=p := Option.some.inj held
    exact congrArg ArrayPointer.block equal.symm
  | store s p offset value after held write =>
    have same : p.block=dst.block := bound p held
    refine ⟨bound,write.2.2.2.1,write.2.2.2.2.1,?_⟩
    intro block index different
    exact write.2.2.2.2.2.2 block index (Or.inl (by simpa [byteOff,same] using different))
  | seq a b s m t flow first second ih1 ih2 =>
    obtain ⟨bm,fm⟩ := ih1 bound
    obtain ⟨bt,ft⟩ := ih2 bm
    exact ⟨bt,frame_trans dst _ _ _ fm ft⟩
  | loopNext a s m t flow first rest ih1 ih2 =>
    obtain ⟨bm,fm⟩ := ih1 bound
    obtain ⟨bt,ft⟩ := ih2 bm
    exact ⟨bt,frame_trans dst _ _ _ fm ft⟩
  | seqReturn a b s t first ih => exact ih bound
  | left a b s t flow step ih => exact ih bound
  | right a b s t flow step ih => exact ih bound
  | loopReturn a s t first ih => exact ih bound
  | call destination s t flow source ih => exact ih bound

/-- Complete dispatcher/body footprint run on heap states. Scalar outcomes
    and observed length are absent; every return edge has the same frame. -/
def Run (dst : ArrayPointer) (before after : Memory) : Prop :=
  ∃ out flow, Exec dst dispatchCode ⟨before,none⟩ out flow ∧ out.heap=after

theorem run_frame (dst : ArrayPointer) (before after : Memory) (source : Run dst before after) :
    Frame dst before after := by
  obtain ⟨out,flow,execution,rfl⟩ := source
  exact (exec_frame dst dispatchCode ⟨before,none⟩ out flow execution
    (by intro p held; cases held)).2

/-- A word in any other block survives, with its allocation and all bytes.
    This is unconditional on codec success and accommodates partial writes. -/
theorem load64_frame (dst p : ArrayPointer) (before after : Memory) (word : BitVec 64)
    (source : Run dst before after) (different : p.block≠dst.block)
    (load : Load64 before p word) : Load64 after p word := by
  have frame := run_frame dst before after source
  cases load with
  | load bytes allocated typeSize initialized =>
    apply Load64.load after p bytes
    · simpa only [Allocated,frame.sizes] using allocated
    · exact typeSize
    · intro i
      rw [frame.bytes p.block (p.offset+i.val) different]
      exact initialized i

end FT1536.Source3.KeygenCodecFootprint
