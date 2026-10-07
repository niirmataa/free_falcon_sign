import Source3.KeygenSmallBounds
import Source3.KeygenSolverNttCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenSmallCalls
open C99ArrayReference (State Arg Param Bind)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenMkgm3Layout (DisjointBytes)

def params : List Param := [.pointer "d".toList,.pointer "s".toList,
  .scalar .uint32 "logn".toList,.scalar .uint32 "ter".toList]

/- A fixed function boundary, not a callee relation supplied by a client.
   The caller restores its own locals after the executed function returns. -/
inductive Call (args : List Arg) (before : State) : State → Value → Prop where
  | run (entry : State) (out : Result) (v : Value)
      (binding : Bind before params args entry)
      (body : KeygenSmallSource.Exec KeygenSmallSource.code entry out)
      (returned : out.flow=.returned (some v)) :
      Call args before {before with heap := out.state.heap} (C99IntegerReference.convert .int32 v.integer)

theorem call_frame (args : List Arg) (before after : State) (v : Value) (source : Call args before after v) :
    after.locals=before.locals ∧ after.arrays=before.arrays := by cases source; exact ⟨rfl,rfl⟩

theorem return_one (s : State) (out : Result) (dst : ArrayPointer) (profile : KeygenSmallBounds.Profile s)
    (binding : s.arrays "d".toList=some dst) (source : KeygenSmallSource.Exec KeygenSmallSource.code s out)
    (v : Value) (returned : out.flow=.returned (some v))
    (nonzero : (C99IntegerReference.convert .int32 v.integer).integer≠0) : v=.int32 1 := by
  have body := KeygenSmallBounds.initialized s out profile source
  have unique : ∀ r, KeygenSmallSource.Exec KeygenSmallSource.counter (KeygenSmallBounds.sized s) r →
      r=⟨KeygenCheckLoopBridge.ready (KeygenSmallBounds.sized s),.normal⟩ := by
    intro r h
    cases h with
    | modular _ _ _ h => exact KeygenCheckLoopBridge.initial_result _ none r rfl h
  cases body with
  | seqNormal _ _ _ middle _ head tail =>
    have he : out.flow=.returned (some (.int32 1)) := by
      cases tail with
      | seqNormal _ _ _ last _ head _ => cases congrArg Result.flow (KeygenSmallStep.ret_result 1 middle ⟨last,.normal⟩ head)
      | seqExit _ _ _ _ head _ => exact congrArg Result.flow (KeygenSmallStep.ret_result 1 middle out head)
    exact Option.some.inj (C99ProcedureReference.Flow.returned.inj (returned.symm.trans he))
  | seqExit _ _ _ _ head exit =>
    have hl := KeygenSmallBounds.continuation _ _ _ _ out unique head
    rcases KeygenSmallBounds.loop_result _ out dst hl 0 (by decide)
      (KeygenCheckLoopBridge.ready_counter _) rfl binding with ⟨normal,_⟩ | aborted
    · exact (exit normal).elim
    · have hv : v=.int32 0 := Option.some.inj (C99ProcedureReference.Flow.returned.inj (returned.symm.trans aborted))
      subst v
      exact (nonzero rfl).elim

theorem writes_frame (dst : ArrayPointer) (before after : Memory) (i : Nat)
    (source : KeygenSmallBounds.Writes dst i before after) (width : dst.elementBytes=2)
    (block offset : Nat) (outside : block≠dst.block ∨ offset<dst.offset ∨ dst.offset+3072≤offset) :
    after.bytes block offset=before.bytes block offset := by
  induction source with
  | done => rfl
  | next i before middle after z inside bound store rest ih =>
    have hf := store.2.2.2.2.2.2 block offset (by
      dsimp [KeygenSmallOutput.element,ArrayPointer.offset] at *
      rw [width] at *
      omega)
    exact ih.trans hf

theorem preserves (dst other : ArrayPointer) (before after : Memory)
    (source : KeygenSmallBounds.Writes dst 0 before after) (width : dst.elementBytes=2)
    (otherWidth : other.elementBytes=2) (separate : DisjointBytes dst 3072 other 3072)
    (material : Geometry.Vec) (repr : KeygenMaterial.Represents before other material) :
    KeygenMaterial.Represents after other material := by
  have hf : ∀ j, j<1536 → ∀ b : Fin 2,
      after.bytes other.block ((KeygenSmallOutput.element other j).offset+b.val)=
      before.bytes other.block ((KeygenSmallOutput.element other j).offset+b.val) := by
    intro j hj b
    apply writes_frame dst before after 0 source width
    have hb := b.isLt
    dsimp [DisjointBytes,KeygenSmallOutput.element,ArrayPointer.offset] at *
    rw [width,otherWidth] at *
    omega
  intro j
  constructor
  · intro b
    exact (hf j.val (by have := j.isLt; omega) b).trans ((repr j).1 b)
  · intro b
    exact (hf (j.val+768) (by have := j.isLt; omega) b).trans ((repr j).2 b)

/- The actual argument-expression/caller-struct bridge is still an outer
   obligation. This theorem consumes the same executed Bind and body; the
   source-derived bound is not a property assumed of the callee's output. -/
theorem bound_call (args : List Arg) (before entry : State) (out : Result) (dst : ArrayPointer)
    (binding : Bind before params args entry) (profile : KeygenSmallBounds.Profile entry)
    (destination : entry.arrays "d".toList=some dst) (width : dst.elementBytes=2)
    (body : KeygenSmallSource.Exec KeygenSmallSource.code entry out) (v : Value)
    (returned : out.flow=.returned (some v))
    (nonzero : (C99IntegerReference.convert .int32 v.integer).integer≠0) :
    KeygenSmallBounds.Writes dst 0 before.heap out.state.heap ∧
    ∃ material : Geometry.Vec, KeygenMaterial.Represents out.state.heap dst material ∧
      KeygenIntegerLift.Bound material 2047 := by
  have hv := return_one entry out dst profile destination body v returned nonzero
  subst v
  have writes := KeygenSmallBounds.source_writes entry out dst profile destination body returned
  have heap := C99ArrayReference.bind_heap before params args entry binding
  rw [heap] at writes
  exact ⟨writes,KeygenSmallBounds.material dst before.heap out.state.heap writes width⟩

theorem two_outputs (first second : ArrayPointer) (before middle after : Memory)
    (firstWidth : first.elementBytes=2) (secondWidth : second.elementBytes=2)
    (separate : DisjointBytes second 3072 first 3072)
    (firstSource : KeygenSmallBounds.Writes first 0 before middle)
    (secondSource : KeygenSmallBounds.Writes second 0 middle after) :
    ∃ bigF bigG : Geometry.Vec,
      KeygenMaterial.Represents after first bigF ∧ KeygenIntegerLift.Bound bigF 2047 ∧
      KeygenMaterial.Represents after second bigG ∧ KeygenIntegerLift.Bound bigG 2047 := by
  obtain ⟨bigF,reprF,boundF⟩ := KeygenSmallBounds.material first before middle firstSource firstWidth
  obtain ⟨bigG,reprG,boundG⟩ := KeygenSmallBounds.material second middle after secondSource secondWidth
  exact ⟨bigF,bigG,preserves second first middle after secondSource secondWidth firstWidth separate bigF reprF,
    boundF,reprG,boundG⟩

end FT1536.Source3.KeygenSmallCalls
