import Source3.KeygenResultantRename093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenResultantCall093
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenResultantSource
open KeygenResultantBody093 (Body)
open RngTemporarySwap090 (TablesLive)
open KeygenResultantRename093 (ArraysLive)

theorem binding_live (before bound : State) (name : String) (p : ArrayPointer)
    (pointer : before.arrays name.toList = some p) (live : 0 < before.heap.size p.block)
    (tables : TablesLive before)
    (binding : C99ArrayReference.Bind before params (KeygenResultantGate.arguments name) bound) :
    ArraysLive bound ∧ TablesLive bound := by
  cases binding with
  | pointer _ _ _ actual _ _ _ address tail =>
      cases tail with
      | scalar _ _ _ _ _ _ value evaluated tail =>
          cases tail
          have same := KeygenSolverNttCalls.pointer_zero before name p actual pointer address
          subst actual
          refine ⟨?_, tables⟩
          intro key q binding
          change (if key = "f".toList then some p else before.tables key) = some q at binding
          by_cases equal : key = "f".toList
          · rw [ite_eq_left equal] at binding
            cases Option.some.inj binding
            exact live
          · rw [ite_eq_right equal] at binding
            exact tables key q binding

/-- The local resultant workspace is disposed and every caller byte and
    allocation property is restored; only the returned scalar is visible. -/
theorem call_state (before after : State) (args : List C99ArrayReference.Arg) (v : Value)
    (source : Call before args after v) : after = before := by
  have bytes := KeygenResultantSource.bytes before after args v source
  have memoryInfo := KeygenAttemptMaterial.resultant_stable before after args v source
  have same := RngTemporarySwap090.memory_ext after.heap before.heap bytes memoryInfo.size memoryInfo.writable
  apply C99StateRename090.ext
  · exact same
  all_goals cases source; rfl

theorem call_unique (before a b : State) (name : String) (p : ArrayPointer) (x y : Value)
    (pointer : before.arrays name.toList = some p) (live : 0 < before.heap.size p.block)
    (tables : TablesLive before)
    (first : Call before (KeygenResultantGate.arguments name) a x)
    (second : Call before (KeygenResultantGate.arguments name) b y) : a = b ∧ x = y := by
  refine ⟨(call_state before a _ x first).trans (call_state before b _ y second).symm, ?_⟩
  cases first with
  | run bound1 ready1 packed1 reduced1 out1 block1 word1 x binding1 fresh1 initial1 legal1 pack1 read1 fallthrough1 tail1 returned1 =>
      cases second with
      | run bound2 ready2 packed2 reduced2 out2 block2 word2 y binding2 fresh2 initial2 legal2 pack2 read2 fallthrough2 tail2 returned2 =>
          have same := C99ArrayDeterminism089.parameters before params _ bound1 bound2 binding1 binding2
          subst bound2
          have legality := binding_live before bound1 name p pointer live tables binding1
          exact KeygenResultantRename093.value_unique bound1 block1 block2 out1 out2 x y fresh1 fresh2 legality.1 legality.2
            (.run ready1 packed1 reduced1 out1 word1 x initial1 legal1 pack1 read1 fallthrough1 tail1 returned1)
            (.run ready2 packed2 reduced2 out2 word2 y initial2 legal2 pack2 read2 fallthrough2 tail2 returned2)

theorem gate_unique (before : State) (f g : ArrayPointer) (a b : Result)
    (fPointer : before.arrays "f".toList = some f) (gPointer : before.arrays "g".toList = some g)
    (fLive : 0 < before.heap.size f.block) (gLive : 0 < before.heap.size g.block) (tables : TablesLive before)
    (first : KeygenResultantGate.Exec before a) (second : KeygenResultantGate.Exec before b) : a = b := by
  have fUnique := fun a b x y => call_unique before a b "f" f x y fPointer fLive tables
  have gUnique := fun a b x y => call_unique before a b "g" g x y gPointer gLive tables
  cases first <;> cases second
  all_goals grind only [call_state]

end FT1536.Source3.KeygenResultantCall093
