import Source3.KeygenResidueStore

namespace FT1536.Source3.KeygenResidueTrace
open C99MemoryReference
open C99ArrayReference (State)
open C99ModularReference (Stmt Exec)
open C99ProcedureReference (Result)
open KeygenSmallOutput (element)

structure Arrays where
  input : Fin 4 → ArrayPointer
  output : Fin 4 → ArrayPointer

def names (slot : Fin 4) : String×String :=
  if slot.val=0 then ("ft","f") else if slot.val=1 then ("gt","g")
  else if slot.val=2 then ("Ft","F") else ("Gt","G")
def slots : List (Fin 4) := [0,1,2,3]
def code (indices : List (Fin 4)) : Stmt := KeygenResidueProgram.chain (indices.map names)
theorem fixed_names : slots.map names=KeygenResidueProgram.stores := by decide

structure Inputs (arrays : Arrays) (s : State) : Prop where
  input : ∀ slot, s.arrays (names slot).2.toList=some (arrays.input slot)
  output : ∀ slot, s.arrays (names slot).1.toList=some (arrays.output slot)
  prime : s.locals "p".toList=some (.uint32,some (.uint32 KeygenNinv31.prime))
  size : C99CountedWords.Limit s

/- A derived observation of writes, not a definition of successful KeyGen.
   Input words come from the corresponding pre-store memory snapshot. -/
structure Cell (arrays : Arrays) (slot : Fin 4) (i : Nat) (before after : Memory) where
  input : BitVec 16
  output : BitVec 32
  read : C99NarrowReads.Load16 before (element (arrays.input slot) i) input
  write : Store32 before (element (arrays.output slot) i) output after
  range : output.toNat<KeygenNinv31.prime.toNat
  residue : (output.toNat : Int)%(KeygenNinv31.prime.toNat : Int)=input.toInt%(KeygenNinv31.prime.toNat : Int)

inductive Writes (arrays : Arrays) (i : Nat) : List (Fin 4) → Memory → Memory → Prop where
  | done (heap : Memory) : Writes arrays i [] heap heap
  | next (slot : Fin 4) (rest : List (Fin 4)) (before middle after : Memory)
      (cell : Cell arrays slot i before middle) (tail : Writes arrays i rest middle after) :
      Writes arrays i (slot::rest) before after

theorem source_store (arrays : Arrays) (before : State) (result : Result) (slot : Fin 4) (i : Nat)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i) (inputs : Inputs arrays before)
    (source : Exec (KeygenResidueProgram.store (names slot).1 (names slot).2) before result) :
    result.flow=.normal ∧ result.state.locals=before.locals ∧ result.state.arrays=before.arrays ∧
      Nonempty (Cell arrays slot i before.heap result.state.heap) := by
  obtain ⟨input,out,he,read,write,range,residue⟩ := KeygenResidueStore.source_result before result
    (names slot).1 (names slot).2 (arrays.output slot) (arrays.input slot) i hi counter
    (inputs.output slot) (inputs.input slot) inputs.prime source
  have hs := congrArg Result.state he
  have hl := congrArg State.locals hs
  have ha := congrArg State.arrays hs
  exact ⟨congrArg Result.flow he,hl,ha,⟨⟨input,out,read,write,range,residue⟩⟩⟩

theorem inputs_transport (arrays : Arrays) (before after : State)
    (locals : after.locals=before.locals) (pointers : after.arrays=before.arrays)
    (inputs : Inputs arrays before) : Inputs arrays after := by
  refine ⟨?_,?_,?_,?_⟩
  · intro slot; rw [pointers]; exact inputs.input slot
  · intro slot; rw [pointers]; exact inputs.output slot
  · rw [locals]; exact inputs.prime
  · simpa only [C99CountedWords.Limit,locals] using inputs.size

theorem source_chain (arrays : Arrays) (indices : List (Fin 4)) (before : State) (result : Result) (i : Nat)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i) (inputs : Inputs arrays before)
    (source : Exec (code indices) before result) :
    result.flow=.normal ∧ result.state.locals=before.locals ∧ result.state.arrays=before.arrays ∧
      Writes arrays i indices before.heap result.state.heap := by
  induction indices generalizing before with
  | nil =>
      have he := C99ModularReference.skip_result before result source
      rw [he]
      exact ⟨rfl,rfl,rfl,.done before.heap⟩
  | cons slot rest ih =>
      cases source with
      | seqNormal first second before middle result head tail =>
          obtain ⟨_,hl,ha,⟨cell⟩⟩ := source_store arrays before ⟨middle,.normal⟩ slot i hi counter inputs head
          change middle.locals=before.locals at hl
          change middle.arrays=before.arrays at ha
          have hr := ih middle (by simpa only [C99CountedWords.Counter,hl] using counter)
            (inputs_transport arrays before middle hl ha inputs) tail
          exact ⟨hr.1,hr.2.1.trans hl,hr.2.2.1.trans ha,.next slot rest _ _ _ cell hr.2.2.2⟩
      | seqExit first second before result head exit =>
          exact False.elim (exit (source_store arrays before result slot i hi counter inputs head).1)

theorem source_iteration (arrays : Arrays) (before : State) (result : Result) (i : Nat)
    (hi : i≤1536) (counter : C99CountedWords.Counter before i) (inputs : Inputs arrays before)
    (source : Exec KeygenResidueProgram.iteration before result) :
    result.flow=.normal ∧ result.state.locals=before.locals ∧ result.state.arrays=before.arrays ∧
      Writes arrays i slots before.heap result.state.heap := by
  cases source with
  | scope locals body before inner execution =>
      have he : code slots=KeygenResidueProgram.chain KeygenResidueProgram.stores := by rw [code,fixed_names]
      rw [← he] at execution
      exact source_chain arrays slots before inner i hi counter inputs execution

end FT1536.Source3.KeygenResidueTrace
