import Source3.KeygenPublicFirstCalls
import Source3.SelectedPublicNttEntry158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Constructive caller-side executions of the two actual forward invocations
   on the converted public-input state. Parameter binding, the original
   ternary dispatch and the void return are constructed here; each
   mq_NTT_ternary body execution is an explicit premise. No generated table,
   NTT evaluation or success value enters this layer. -/
namespace FT1536.Source3.PublicForwardEntry159
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer PointerAdd)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicForwardWrapper (Ternary)

def clean (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩

def outer (s : State) (a : ArrayPointer) : State :=
  C99ArrayReference.bindPointer
    (C99ArrayReference.bindValue
      (C99ArrayReference.bindValue (clean s) "ternary".toList .int32 (.int32 1))
      "logn".toList .uint32 (.uint32 10)) "a".toList a

def entryT (s : State) (a : ArrayPointer) : State :=
  C99ArrayReference.bindPointer
    (C99ArrayReference.bindValue (clean (outer s a)) "logn".toList .uint32 (.uint32 10))
    "a".toList a

theorem zero_scalar (s : State) :
    KeygenPublicWord.scalar s C99ProcedureParser.zero (C99IntegerReference.convert .uint64 0) :=
  .literal .uint64 0

theorem zero_address (s : State) (name : String) (p : ArrayPointer)
    (binding : s.arrays name.toList=some p) (capacity : p.index≤p.count) :
    KeygenPublicWord.Address s name.toList C99ProcedureParser.zero p :=
  .add name.toList C99ProcedureParser.zero p p (C99IntegerReference.convert .uint64 0)
    binding (zero_scalar s) (by decide) (PointerAdd.within p 0 (by simpa using capacity))

theorem logn_slot (s : State) (a : ArrayPointer) : Slot (outer s a) "logn" 10 := rfl
theorem ternary_slot (s : State) (a : ArrayPointer) : Ternary (outer s a) := rfl
theorem outer_arrays (s : State) (a : ArrayPointer) : (outer s a).arrays "a".toList=some a := rfl
theorem outer_heap (s : State) (a : ArrayPointer) : (outer s a).heap=s.heap := rfl
theorem outer_globals (s : State) (a : ArrayPointer) : (outer s a).globals=s.globals := rfl

theorem forward_bind (s : State) (name : String) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays name.toList=some a)
    (capacity : a.index≤a.count) :
    KeygenPublicWord.Bind s (KeygenPublicSource.params .forward)
      [.pointer name.toList C99ProcedureParser.zero,.scalar (.var "logn".toList),.scalar (.var "ternary".toList)]
      (outer s a) :=
  .pointer "a".toList name.toList C99ProcedureParser.zero a
    [.scalar .uint32 "logn".toList,.scalar .int32 "ternary".toList]
    [.scalar (.var "logn".toList),.scalar (.var "ternary".toList)]
    (C99ArrayReference.bindValue (C99ArrayReference.bindValue (clean s) "ternary".toList .int32 (.int32 1))
      "logn".toList .uint32 (.uint32 10))
    (zero_address s name a input capacity)
    (.scalar .uint32 "logn".toList (.var "logn".toList)
      [.scalar .int32 "ternary".toList] [.scalar (.var "ternary".toList)]
      (C99ArrayReference.bindValue (clean s) "ternary".toList .int32 (.int32 1))
      (.uint32 10) (.variable "logn".toList .uint32 (.uint32 10) profile)
      (.scalar .int32 "ternary".toList (.var "ternary".toList) [] []
        (clean s) (.int32 1) (.variable "ternary".toList .int32 (.int32 1) ternary)
        .nil))

theorem forwardT_bind (s : State) (a : ArrayPointer) (capacity : a.index≤a.count) :
    KeygenPublicWord.Bind (outer s a) (KeygenPublicSource.params .forwardT)
      KeygenPublicForwardWrapper.arguments (entryT s a) :=
  .pointer "a".toList "a".toList C99ProcedureParser.zero a
    [.scalar .uint32 "logn".toList] [.scalar (.var "logn".toList)]
    (C99ArrayReference.bindValue (clean (outer s a)) "logn".toList .uint32 (.uint32 10))
    (zero_address (outer s a) "a" a (outer_arrays s a) capacity)
    (.scalar .uint32 "logn".toList (.var "logn".toList) [] [] (clean (outer s a)) (.uint32 10)
      (.variable "logn".toList .uint32 (.uint32 10) (logn_slot s a)) .nil)

theorem forward_lookup : KeygenPublicSource.program (KeygenPublicSource.name .forward)=
    some (KeygenPublicSource.function .forward) := by decide

/- The wrapper body: ternary dispatch selects the original ternary call and
   the void return ends in normal flow. -/
theorem wrapper_body (s : State) (a : ArrayPointer) (bodyState : State) (capacity : a.index≤a.count)
    (inner : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT) (entryT s a)
      ⟨bodyState,.normal⟩) :
    Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forward) (outer s a)
      ⟨{outer s a with heap := bodyState.heap},.normal⟩ := by
  rw [KeygenPublicForwardWrapper.source_complete]
  exact .seqNormal _ _ _ ({outer s a with heap := bodyState.heap}) _
    (.branchTrue _ _ _ _ _ (.int32 1)
      (.scalar _ _ (.variable "ternary".toList .int32 (.int32 1) (ternary_slot s a))) (by decide)
      (.scope _ _ _ _ _
        (.seqNormal _ _ _ ({outer s a with heap := bodyState.heap}) _
          (.call (KeygenPublicSource.name .forwardT) KeygenPublicForwardWrapper.arguments
            (KeygenPublicSource.function .forwardT) (outer s a) (entryT s a) ⟨bodyState,.normal⟩
            KeygenPublicForwardWrapper.forward_lookup (forwardT_bind s a capacity) inner .voidEnd)
          (.skip _))))
    (.skip _)

theorem source_call (s : State) (name : String) (a : ArrayPointer) (bodyState : State)
    (profile : Slot s "logn" 10) (ternary : Ternary s) (input : s.arrays name.toList=some a)
    (capacity : a.index≤a.count)
    (inner : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT) (entryT s a)
      ⟨bodyState,.normal⟩) :
    Exec KeygenPublicSource.program KeygenPublicInputProgram.signed (KeygenPublicFirstCalls.call name) s
      ⟨{s with heap := bodyState.heap},.normal⟩ :=
  .call (KeygenPublicSource.name .forward)
    [.pointer name.toList C99ProcedureParser.zero,.scalar (.var "logn".toList),.scalar (.var "ternary".toList)]
    (KeygenPublicSource.function .forward) s (outer s a) ⟨{outer s a with heap := bodyState.heap},.normal⟩
    forward_lookup (forward_bind s name a profile ternary input capacity)
    (wrapper_body s a bodyState capacity inner) .voidEnd

/- Concrete executions on the converted entry state. -/
open SelectedPublicConvert158 (after)
open SelectedPublicBinding157 (h)
open SelectedPublicStart157 (t)

theorem h_capacity : h.index≤h.count := by decide
theorem t_capacity : t.index≤t.count := by decide

theorem h_exec (bodyState : State)
    (inner : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT) (entryT after h)
      ⟨bodyState,.normal⟩) :
    Exec KeygenPublicSource.program KeygenPublicInputProgram.signed KeygenPublicInputProgram.hForward after
      ⟨{after with heap := bodyState.heap},.normal⟩ :=
  source_call after "h" h bodyState SelectedPublicNttEntry158.logn
    SelectedPublicNttEntry158.ternary SelectedPublicNttEntry158.h_binding h_capacity inner

theorem t_exec (bodyStateH bodyStateT : State)
    (tInner : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT)
      (entryT {after with heap := bodyStateH.heap} t) ⟨bodyStateT,.normal⟩) :
    Exec KeygenPublicSource.program KeygenPublicInputProgram.signed KeygenPublicInputProgram.tForward
      {after with heap := bodyStateH.heap} ⟨{after with heap := bodyStateT.heap},.normal⟩ :=
  source_call {after with heap := bodyStateH.heap} "t" t bodyStateT
    SelectedPublicNttEntry158.logn SelectedPublicNttEntry158.ternary
    SelectedPublicNttEntry158.t_binding t_capacity tInner

end FT1536.Source3.PublicForwardEntry159
