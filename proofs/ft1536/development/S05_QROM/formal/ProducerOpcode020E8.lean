import ProducerFlags020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerOpcode020E8
open WordRAM020 ProducerExpr020E6 ProducerScalar020E6 ProducerEval020E7 ProducerCoreCircuit020E6

theorem invalid (n : Nat) (hn : 7≤n) : SyntaxCells020E.opOf n=Option.none := by
  obtain ⟨k,rfl⟩ := Nat.exists_eq_add_of_le hn
  rw [Nat.add_comm]
  rfl

theorem none_bound (n : Nat) (h : SyntaxCells020E.opOf n=Option.none) : 7≤n := by
  by_contra hn
  have hb : n<7 := by omega
  interval_cases n <;> simp [SyntaxCells020E.opOf] at h

theorem some_index (n : Nat) (o : Op) (h : SyntaxCells020E.opOf n=Option.some o) : SyntaxCells020E.opIndex o=n ∧ n<7 := by
  by_cases hn : n<7
  · interval_cases n <;> simp only [SyntaxCells020E.opOf,Option.some.injEq] at h <;> subst o <;> constructor <;> decide
  · rw [invalid n (by omega)] at h
    cases h

/-- The circuit's seven selected operators are precisely the old ALU. -/
theorem selected {extent : Fin 1 → Nat} (s : ProducerMachine020E6.Sources extent)
    (e x y : Expr 1) (o : Op) (he : eval s e=word (SyntaxCells020E.opIndex o)) :
    eval s (binaryResult e x y)=op o (eval s x) (eval s y) := by
  simp only [binaryResult,choose_eval,eq_eval,literal,he]
  cases o <;> rfl

end FT1536.S05.ProducerOpcode020E8
