import Source3.CertificateEntryPrologue
import Source3.C99Automatic32

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateBadAssignment
open C99ArrayReference (State)
open C99MemoryReference

/- The address-taken local is represented by its allocated uint32 object.
   This assignment is the actual source bad=0, after the profile guard. -/
def value : CLogic.Expr := .literal .i32 0
theorem source_bound : Pinned.keygenLines[7702]?=some "\tbad = 0;\n" := by decide

inductive Exec (bad : ArrayPointer) (before : State) : State → Prop where
  | write (after : Memory) (v : C99IntegerReference.Value)
      (evaluated : C99ArrayReference.scalar before value v)
      (store : Store32 before.heap bad (BitVec.ofInt 32 v.integer) after) :
      Exec bad before {before with heap := after}

theorem source_write (bad : ArrayPointer) (before after : State) (source : Exec bad before after) :
    Store32 before.heap bad 0 after.heap ∧ after={before with heap := after.heap} := by
  cases source with
  | write after v evaluated store =>
      change C99ScalarReference.Eval _ _ (.literal .int32 0) v at evaluated
      cases evaluated
      exact ⟨store,rfl⟩

theorem source_exists (caller : Memory) (before : State) (heap : before.heap=C99Automatic32.enter caller)
    (space : C99Automatic32.Space caller) : ∃ after, Exec (C99Automatic32.pointer caller) before after := by
  obtain ⟨initialized,store,_⟩ := C99Automatic32.zero_initialization_exists caller space
  rw [← heap] at store
  exact ⟨{before with heap := initialized},.write initialized (.int32 0) (.literal .int32 0) store⟩

end FT1536.Source3.CertificateBadAssignment
