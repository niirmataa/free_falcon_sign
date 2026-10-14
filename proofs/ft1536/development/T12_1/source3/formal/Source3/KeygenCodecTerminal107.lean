import Source3.KeygenCodecLeafAgreement107

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecTerminal107
open C99MemoryReference
open KeygenCodecSyntax
open KeygenCodecValues
open KeygenCodecExecution (CallArgs Exec Flow)
open KeygenCodecStateAgreement107 (Related)

def Physical (a b : Args) : Prop := a.out = b.out ∧ a.capacity = b.capacity ∧
  a.q = b.q ∧ a.x = b.x ∧ a.logn = b.logn

theorem arguments (args : Args) (before : State) (a b : Args)
    (first : CallArgs args before a) (second : CallArgs args before b) : Physical a b := by
  cases first
  cases second
  grind only [Physical]

theorem initial_related (a b : Args) (heap : Memory) (same : Physical a b) :
    Related (initial a heap) (initial b heap) := by
  refine ⟨rfl, ⟨same.2.2.2.1, ?_⟩, rfl⟩
  intro name different
  change name ≠ ['c','o','m','p'] at different
  simp [initial, initialLocals, different, same.2.1, same.2.2.1, same.2.2.2.2]
  rfl

/-- Actual terminal callees agree on bytes and returned length despite
    arbitrary unused comp metadata in their private activations. -/
theorem terminal (kind : Callee) (args : Args) (before : State) (calledA calledB : Args)
    (a b : State) (x y : BitVec 64)
    (bindA : CallArgs args before calledA) (bindB : CallArgs args before calledB)
    (first : Exec calledA (KeygenCodecExecution.body kind) (initial calledA before.heap) a (.returned x))
    (second : Exec calledB (KeygenCodecExecution.body kind) (initial calledB before.heap) b (.returned y)) :
    a.heap = b.heap ∧ x = y := by
  have physical := arguments args before calledA calledB bindA bindB
  have same := KeygenCodecLeafAgreement107.leaf kind calledA calledB
    (initial calledA before.heap) (initial calledB before.heap) a b (.returned x) (.returned y)
    first second (KeygenCodecAtoms106.initial_clean calledA) (initial_related calledA calledB before.heap physical) physical.1
  exact ⟨same.1.1, Flow.returned.inj same.2⟩

end FT1536.Source3.KeygenCodecTerminal107
