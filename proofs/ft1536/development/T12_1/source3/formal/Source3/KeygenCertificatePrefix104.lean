import Source3.KeygenRootCall103

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCertificatePrefix104
open C99MemoryReference
open C99ArrayReference (State Name)
open CertificateMemory (Layout)

theorem bad (p : ArrayPointer) (before a b : State)
    (first : CertificateBadAssignment.Exec p before a) (second : CertificateBadAssignment.Exec p before b) : a = b := by
  cases first
  cases second
  grind only [C99ScalarCallsDeterminism089.array_scalar, C99HeapDeterminism089.store32]

theorem conversion (destination source : Name) (before a b : State)
    (first : SmallintsInvocation.Call destination source before a)
    (second : SmallintsInvocation.Call destination source before b) : a = b := by
  obtain ⟨entry1, out1, bind1, run1, ret1, state1⟩ := first
  obtain ⟨entry2, out2, bind2, run2, ret2, state2⟩ := second
  grind only [C99ArrayDeterminism089.parameters, C99ProcedureDeterminism094.execution]

theorem conversions (names : List (Name × Name)) (before a b : State)
    (first : CertificateConversions.Sequence names before a)
    (second : CertificateConversions.Sequence names before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [conversion]

theorem scalar (word : BitVec 64) (old : BitVec 32) (a b : BitVec 64) (x y : BitVec 32)
    (first : Gate00Scalar.Exec word old a x) (second : Gate00Scalar.Exec word old b y) : a = b ∧ x = y :=
  Prod.mk.inj ((Gate00Scalar.exact_result word old a x first).trans (Gate00Scalar.exact_result word old b y second).symm)

theorem gate_step (l : Layout) (i : Nat) (before a b : Memory) (x y : BitVec 64)
    (first : Gate00Memory.Step l i before a x) (second : Gate00Memory.Step l i before b y) : a = b ∧ x = y := by
  cases first
  cases second
  grind only [load64_deterministic, Gate00Memory.load32_deterministic,
    → scalar, C99HeapDeterminism089.store32, C99HeapDeterminism089.store64]

theorem gate_loop (l : Layout) (i : Nat) (before a b : Memory) (x y : List (BitVec 64))
    (first : Gate00Memory.Loop l i before a x) (second : Gate00Memory.Loop l i before b y) : a = b ∧ x = y := by
  induction first generalizing b y <;> cases second
  all_goals grind only [→ gate_step]

theorem suffix (l : Layout) (before a b : Memory) (x y : List CertificateEffects.Event) (r s : Bool)
    (wellFormed : CertificateMemory.WellFormed l)
    (legal : CertificateMemory.Legal l (C99MemoryBridge.encode before))
    (first : CertificateExec.PinnedExec l before a x r)
    (second : CertificateExec.PinnedExec l before b y s) : a = b ∧ x = y ∧ r = s := by
  have equal := Option.some.inj ((CertificateSuffix001Outcome.complete l before a x r wellFormed legal first).symm.trans
    (CertificateSuffix001Outcome.complete l before b y s wellFormed legal second))
  have heaps := congrArg (fun out : CertificateExec.Result => C99MemoryBridge.decode out.state.heap) equal
  have traces := congrArg (fun out : CertificateExec.Result => out.state.trace) equal
  have returns := congrArg CertificateExec.Result.returned equal
  exact ⟨by simpa only [C99MemoryBridge.decode_encode] using heaps, traces, returns⟩

end FT1536.Source3.KeygenCertificatePrefix104
