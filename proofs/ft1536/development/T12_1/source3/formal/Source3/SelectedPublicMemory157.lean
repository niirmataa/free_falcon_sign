import Source3.SelectedPublicBinding157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPublicMemory157
open C99CompactState115 (reference)

def old := reference SelectedBound135.before
def temporary : Nat := 32

theorem absent : C99FiniteMap114.lookup SelectedBound135.before.heap.blocks temporary=none := by decide +kernel

theorem old_fresh : KeygenRngSource.Fresh old.heap temporary := by
  simp [KeygenRngSource.Fresh,old,reference,C99FiniteMemory114.memory,absent]

theorem stable : KeygenMemoryStability.Stable old.heap SelectedPublicBinding157.before.heap :=
  KeygenAttemptNorm133.stable KeygenFullData127.env.ctx old ⟨SelectedGsNorm155.after,.normal⟩ SelectedGsGate156.norm_prefix

/-- The selected automatic public buffer uses a genuinely fresh block after both norm gates. -/
theorem fresh : KeygenRngSource.Fresh SelectedPublicBinding157.before.heap temporary :=
  ⟨(congrFun stable.size temporary).trans old_fresh.1,(congrFun stable.writable temporary).trans old_fresh.2.1,
    fun offset => (stable.readonly temporary offset old_fresh.2.1).trans (old_fresh.2.2 offset)⟩

end FT1536.Source3.SelectedPublicMemory157
