import PublicCallCount020E13

namespace FT1536.S05.ExecutionCountNumbers020E13
open WordRAM020 JointInterface019

theorem budget_value : ProducerCoreExecution020E11.budget=1949903559601555 := by
  norm_num [ProducerCoreExecution020E11.budget,CoreRank020E5.cycle]

theorem public_bounds (d : PublicData020E5.Data) (coins : Bits tapeSize) :
    (PublicCallCount020E13.run d coins).counts.cycles≤28727929143609709815 ∧
    (PublicCallCount020E13.run d coins).counts.slots≤62396913907249760 ∧
    (PublicCallCount020E13.run d coins).counts.writes≤62396913907249760 ∧
    (PublicCallCount020E13.run d coins).counts.tests≤1949903559601555 := by
  have h := PublicCallCount020E13.core_bound d coins
  exact ⟨h.1.trans_eq (by rw [budget_value]),h.2.1.trans_eq (by rw [budget_value]),
    h.2.2.1.trans_eq (by rw [budget_value]),h.2.2.2.trans_eq budget_value⟩

end FT1536.S05.ExecutionCountNumbers020E13
