import Source3.KeygenWholeBytes088

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- A fixed 32-byte input object at the public set_seed boundary. The seed
   is supplied once; later calls retain the resulting SHAKE state. This
   module binds the input and the source relation, not yet an executable
   seed-to-final-outcome function. -/
namespace FT1536.Source3.KeygenSeedEntry089
open C99ArrayReference (State bindValue bindPointer)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)

abbrev Seed := Fin 32 → BitVec 8
noncomputable instance seedFintype : Fintype Seed := Fintype.ofFinite Seed

def pointer (block : Nat) : ArrayPointer := ⟨block, 0, 32, 1, 0⟩

/-- The external caller supplies this initialized object. Bytes outside
    the seed object are unchanged, so no additional input randomness is
    introduced by this representation. -/
def seedHeap (heap : Memory) (block : Nat) (seed : Seed) : Memory where
  bytes b offset := if b = block then
    if bound : offset < 32 then some (seed ⟨offset, bound⟩) else none
    else heap.bytes b offset
  size b := if b = block then 32 else heap.size b
  writable b := if b = block then true else heap.writable b

def caller (base : State) (block : Nat) (seed : Seed) : State :=
  {base with heap := seedHeap base.heap block seed}

theorem seed_bytes (base : State) (block : Nat) (seed : Seed) (i : Fin 32) :
    (caller base block seed).heap.bytes block i.val = some (seed i) := by
  simp [caller, seedHeap, i.isLt]

theorem seed_load (base : State) (block : Nat) (seed : Seed) (i : Fin 32) :
    KeygenDecodeValues.LoadByte (caller base block seed).heap
      (KeygenCodecExecution.byteOff (pointer block) i.val) (seed i) := by
  refine .load _ _ _ ?_ rfl ?_
  · have small := i.isLt
    norm_num [Allocated, caller, seedHeap, pointer, KeygenCodecExecution.byteOff,
      ArrayPointer.offset, small]
  · simpa only [pointer, KeygenCodecExecution.byteOff, ArrayPointer.offset,
      Nat.zero_add, Nat.one_mul, Nat.mul_one, Nat.add_zero, Nat.sub_zero] using
      seed_bytes base block seed i

theorem outside_seed (base : State) (block : Nat) (seed : Seed) (b : Nat) (different : b ≠ block) :
    KeygenMakeObjects.Block base.heap (caller base block seed).heap b := by
  exact ⟨by simp [caller, seedHeap, different], by simp [caller, seedHeap, different],
    fun offset => by simp [caller, seedHeap, different]⟩

theorem seed_input_injective (base : State) (block : Nat) : Function.Injective (caller base block) := by
  intro a b equal
  funext i
  have bytes := congrArg (fun state : State => state.heap.bytes block i.val) equal
  rw [seed_bytes, seed_bytes] at bytes
  exact Option.some.inj bytes

def arguments (env : Env) (block : Nat) : List KeygenMakeArguments.Argument :=
  [.pointer env.args.fk, .pointer (pointer block), .scalar (.uint64 32), .scalar (.int32 1)]

def entry (env : Env) (base : State) (block : Nat) (seed : Seed) : State :=
  bindPointer (bindPointer
    (bindValue (bindValue (KeygenMakeArguments.base (caller base block seed))
      "replace".toList .int32 (.int32 1)) "len".toList .uint64 (.uint64 32))
    "seed".toList (pointer block)) "fk".toList env.args.fk

theorem binding (env : Env) (base : State) (block : Nat) (seed : Seed) :
    KeygenMakeArguments.Bind (caller base block seed) KeygenRngReference.params
      (arguments env block) (entry env base block seed) :=
  .pointer _ _ _ _ _ (.pointer _ _ _ _ _ (.scalar _ _ _ _ _ _ (.scalar _ _ _ _ _ _ .nil)))

theorem bound_exact (env : Env) (base : State) (block : Nat) (seed : Seed) (bound : State)
    (source : KeygenMakeArguments.Bind (caller base block seed) KeygenRngReference.params
      (arguments env block) bound) : bound = entry env base block seed := by
  cases source
  cases ‹KeygenMakeArguments.Bind _ _ _ _›
  cases ‹KeygenMakeArguments.Bind _ _ _ _›
  cases ‹KeygenMakeArguments.Bind _ _ _ _›
  cases ‹KeygenMakeArguments.Bind _ _ _ _›
  rfl

theorem header_source : (Pinned.keygenLines.drop 5247).take 4 =
    ["void\n", "falcon_keygen_set_seed(falcon_keygen *fk,\n",
     "\tconst void *seed, size_t len, int replace)\n", "{\n"] := by decide

theorem body_source : KeygenRngProgram.parsed 5252 17 = some KeygenRngProgram.setSeedCode :=
  KeygenRngProgram.set_seed_source

/-- Actual fixed-body public set_seed execution, with replace=1 and the
    same supplied input bytes. There is no desired SHAKE state in this
    relation and no claim yet that it has a result for every input. -/
inductive Seeded (env : Env) (base : State) (block : Nat) (seed : Seed) : State → Prop where
  | run (bound : State) (out : Result)
      (bind : KeygenMakeArguments.Bind (caller base block seed) KeygenRngReference.params
        (arguments env block) bound)
      (body : KeygenRngReference.Exec env.ctx KeygenRngProgram.setSeedCode bound [] out)
      (returned : out.flow = .returned none) :
      Seeded env base block seed {caller base block seed with heap := out.state.heap}

theorem seeded_body (env : Env) (base : State) (block : Nat) (seed : Seed) (after : State)
    (source : Seeded env base block seed after) :
    ∃ out : Result,
      KeygenRngReference.Exec env.ctx KeygenRngProgram.setSeedCode (entry env base block seed) [] out ∧
      out.flow = .returned none ∧ after = {caller base block seed with heap := out.state.heap} := by
  cases source with
  | run bound out bind body returned =>
      rw [bound_exact env base block seed bound bind] at body
      exact ⟨out, body, returned, rfl⟩

/-- The whole KeyGen starts at exactly the state returned by source
    seeding. It does not reseed or replace the state at an attempt boundary. -/
structure SeededTrace (env : Env) (base : State) (block : Nat) (seed : Seed) where
  afterSeed : State
  seeding : Seeded env base block seed afterSeed
  call : KeygenWholeCall088.Trace env afterSeed

theorem seeded_trace_source (t : SeededTrace env base block seed) :
    KeygenSourceToFiber001.PinnedExec env t.afterSeed t.call.out := t.call.source

end FT1536.Source3.KeygenSeedEntry089
