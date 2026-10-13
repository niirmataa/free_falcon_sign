import ArenaReject020E1

namespace FT1536.S05.ArenaGuard020E1
open SyntaxTape020E ArenaTypes020E1 ArenaStackRead020E1 ArenaStep020E1

/-- Complete acceptance condition of this parser step, including incompatible
    child kinds. Legal-token assumptions for semantic refinement are separate. -/
def Allowed {cap : Nat} (s : Arena cap) (t : Token) : Prop :=
  s.used.val<cap ∧ arity t≤s.sp.val ∧ s.sp.val-arity t<cap ∧
    (children t (freshNode s t)).map (checkedKind s)=(needs t).map some

instance {cap : Nat} (s : Arena cap) (t : Token) : Decidable (Allowed s t) := by unfold Allowed;infer_instance

theorem step_isSome {cap : Nat} (s : Arena cap) (t : Token) :
    (step t s).isSome=decide (Allowed s t) := by
  unfold step Allowed
  split_ifs <;> simp_all
  have hn : ¬s.used.val<cap := by omega
  simp [hn]

theorem rejects_iff {cap : Nat} (s : Arena cap) (t : Token) : step t s=none ↔ ¬Allowed s t := by
  have h := step_isSome s t
  cases hs : step t s <;> simp_all

end FT1536.S05.ArenaGuard020E1
