import Source3.KeygenMakeDeclare125

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenMakeFresh125
open C99CompactState115 (State reference)
open C99FiniteAllocation115 (fresh fresh_iff)
open KeygenMakeDeclare125

theorem reference_a1 (s : State) (blocks : Fin 6 → Nat) :
    reference (a1 s blocks)=KeygenMakePrologue.a1 (reference s) blocks := by
  unfold a1
  rw [reference_enter,reference_a0]
  rfl

theorem reference_a2 (s : State) (blocks : Fin 6 → Nat) :
    reference (a2 s blocks)=KeygenMakePrologue.a2 (reference s) blocks := by
  unfold a2
  rw [reference_enter,reference_a1]
  rfl

theorem reference_a3 (s : State) (blocks : Fin 6 → Nat) :
    reference (a3 s blocks)=KeygenMakePrologue.a3 (reference s) blocks := by
  unfold a3
  rw [reference_enter,reference_a2]
  rfl

theorem reference_a4 (s : State) (blocks : Fin 6 → Nat) :
    reference (a4 s blocks)=KeygenMakePrologue.a4 (reference s) blocks := by
  unfold a4
  rw [reference_enter,reference_a3]
  rfl

theorem reference_a5 (s : State) (blocks : Fin 6 → Nat) :
    reference (a5 s blocks)=KeygenMakePrologue.a5 (reference s) blocks := by
  unfold a5
  rw [reference_enter,reference_a4]
  rfl

def Guard (before : State) (blocks : Fin 6 → Nat) : Prop :=
  fresh (a0 before).heap (blocks 0)=true ∧
  fresh (a1 before blocks).heap (blocks 1)=true ∧
  fresh (a2 before blocks).heap (blocks 2)=true ∧
  fresh (a3 before blocks).heap (blocks 3)=true ∧
  fresh (a4 before blocks).heap (blocks 4)=true ∧
  fresh (middle (a5 before blocks)).heap (blocks 5)=true

instance guardDecidable (before : State) (blocks : Fin 6 → Nat) : Decidable (Guard before blocks) := by
  unfold Guard
  infer_instance

def run (before : State) (blocks : Fin 6 → Nat) : Option State :=
  if Guard before blocks then some (declared before blocks) else none

theorem run_sound (before after : State) (blocks : Fin 6 → Nat)
    (computed : run before blocks=some after) :
    KeygenMakePrologue.Declarations (reference before) blocks (reference after) := by
  unfold run at computed
  split at computed
  next checked =>
    have same := Option.some.inj computed
    subst after
    rw [reference_declared]
    refine .run ?_ ?_ ?_ ?_ ?_ ?_
    · have h := (fresh_iff (a0 before).heap (blocks 0)).mp checked.1
      change KeygenRngSource.Fresh (reference (a0 before)).heap (blocks 0) at h
      simpa only [reference_a0] using h
    · have h := (fresh_iff (a1 before blocks).heap (blocks 1)).mp checked.2.1
      change KeygenRngSource.Fresh (reference (a1 before blocks)).heap (blocks 1) at h
      simpa only [reference_a1] using h
    · have h := (fresh_iff (a2 before blocks).heap (blocks 2)).mp checked.2.2.1
      change KeygenRngSource.Fresh (reference (a2 before blocks)).heap (blocks 2) at h
      simpa only [reference_a2] using h
    · have h := (fresh_iff (a3 before blocks).heap (blocks 3)).mp checked.2.2.2.1
      change KeygenRngSource.Fresh (reference (a3 before blocks)).heap (blocks 3) at h
      simpa only [reference_a3] using h
    · have h := (fresh_iff (a4 before blocks).heap (blocks 4)).mp checked.2.2.2.2.1
      change KeygenRngSource.Fresh (reference (a4 before blocks)).heap (blocks 4) at h
      simpa only [reference_a4] using h
    · have h := (fresh_iff (middle (a5 before blocks)).heap (blocks 5)).mp checked.2.2.2.2.2
      change KeygenRngSource.Fresh (reference (middle (a5 before blocks))).heap (blocks 5) at h
      simpa only [reference_middle,reference_a5] using h
  next rejected => cases computed

end FT1536.Source3.KeygenMakeFresh125
