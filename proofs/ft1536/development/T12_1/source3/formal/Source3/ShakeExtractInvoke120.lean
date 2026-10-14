import Source3.ShakeExtractRun120

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractInvoke120
open C99CompactState115 (State reference)
open C99MemoryReference (ArrayPointer)
open ShakeExtractSource (Layout)
open B20.C (Val)

def entry (before : State) (out : ArrayPointer) (length : Val) : State :=
  {before with
    locals := [("len".toList,C99CompactCells115.Cell.converted .u64 length)]
    arrays := [("out".toList,out)]}

theorem entry_bound (before : State) (out : ArrayPointer) (length : Val) :
    reference (entry before out length)=ShakeExtractFrame.entry (reference before) out (C99ValueBridge.value length) := by
  simp only [entry,reference,ShakeExtractFrame.entry,ShakeEncodeCompute117.singleton_environment]
  rfl

def invoke (ctx : Layout) (fuel : Nat) (before : State) (out : ArrayPointer) (length : Val) : Option State :=
  (ShakeExtractRun120.run ctx fuel ShakeExtractSource.code (entry before out length)).map (fun after => {before with heap := after.heap})

theorem invoke_sound (ctx : Layout) (fuel : Nat) (before after : State) (out : ArrayPointer) (length : Val)
    (computed : invoke ctx fuel before out length=some after) :
    ShakeExtractFrame.Call ctx (reference before) out (C99ValueBridge.value length) (reference after) := by
  obtain ⟨middle,body,result⟩ := Option.map_eq_some_iff.mp computed
  subst after
  rw [C99CompactState115.reference_heap]
  have source := ShakeExtractRun120.run_sound ctx fuel ShakeExtractSource.code (entry before out length) middle body
  rw [entry_bound] at source
  exact .run (reference middle) source

end FT1536.Source3.ShakeExtractInvoke120
