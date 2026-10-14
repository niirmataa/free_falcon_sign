import Source3.KeygenPublicLive095

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicLocal095
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenPublicExec
open KeygenPublicLive095 (Live)
open C99BlockRename090 (heap state)

theorem enter_live (before : State) (name : Name) (block count : Nat) (positive : 0 < count)
    (fresh : KeygenRngSource.Fresh before.heap block) (live : Live before) : Live (localEntry before name block count) := by
  have outside : ∀ p : ArrayPointer, 0 < before.heap.size p.block → p.block ≠ block := by
    intro p positive equal
    rw [equal, fresh.1] at positive
    omega
  constructor
  · intro key p binding
    change (if key = name then some (localPointer block count) else before.arrays key) = some p at binding
    by_cases equal : key = name
    · rw [ite_eq_left equal] at binding
      cases Option.some.inj binding
      simpa only [localEntry, C99ArrayReference.bindPointer, allocated, localPointer, ite_true] using
        Nat.mul_pos (by decide : 0 < 2) positive
    · rw [ite_eq_right equal] at binding
      have old := live.1 key p binding
      simpa only [localEntry, C99ArrayReference.bindPointer, allocated, outside p old, ite_false] using old
  · intro key p binding
    have old := live.2 key p binding
    simpa only [localEntry, C99ArrayReference.bindPointer, allocated, outside p old, ite_false] using old

theorem keeps_fresh (program : Program) (signed : List Name) (code : Stmt) (before : State) (out : Result)
    (source : Exec program signed code before out) (block : Nat) (fresh : KeygenRngSource.Fresh before.heap block) :
    KeygenRngSource.Fresh out.state.heap block := by
  have stable := KeygenPublicStability.body program signed code before out source
  exact ⟨(congrFun stable.size block).trans fresh.1, (congrFun stable.writable block).trans fresh.2.1,
    fun offset => (stable.readonly block offset fresh.2.1).trans (fresh.2.2 offset)⟩

theorem other_fresh (before : State) (name : Name) (block count other : Nat) (different : other ≠ block)
    (fresh : KeygenRngSource.Fresh before.heap other) : KeygenRngSource.Fresh (localEntry before name block count).heap other := by
  simpa only [KeygenRngSource.Fresh, localEntry, C99ArrayReference.bindPointer, allocated, different, ite_false] using fresh

/-- Renaming a fresh workspace does not change the visible caller heap
    after its actual disposal, even if internal pointer aliases survive. -/
theorem disposal (program : Program) (signed : List Name) (code : Stmt) (before : State)
    (name : Name) (a b count : Nat) (out : Result)
    (fa : KeygenRngSource.Fresh before.heap a) (fb : KeygenRngSource.Fresh before.heap b)
    (source : Exec program signed code (localEntry before name b count) out) :
    KeygenRngSource.disposed before.heap (heap (Equiv.swap b a) out.state.heap) a =
      KeygenRngSource.disposed before.heap out.state.heap b := by
  by_cases equal : a = b
  · subst b
    have same : heap (Equiv.swap a a) out.state.heap = out.state.heap := by
      rw [Equiv.swap_self]
      rfl
    rw [same]
  · have stillFresh := keeps_fresh program signed code (localEntry before name b count) out source a
      (other_fresh before name b count a equal fa)
    exact RngTemporarySwap090.disposal_swap before.heap out.state.heap b a fb fa equal stillFresh

end FT1536.Source3.KeygenPublicLocal095
