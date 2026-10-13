import ProducerScanFacts020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerScanRegister020E8
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7 ProducerScanFacts020E8
attribute [local irreducible] ProducerCoreCircuit020E6.w

theorem correct (d : BoundaryPayload020E5.Data) (n : ArenaTypes020E1.Node 877)
    (hn : ProducerSnapshot020E6.scanNode d=some n) (ht : n.cell.1.val=1) : Matches d (ProducerScanSpec020E8.result d) := by
  have h10 : (1 : Word)≠0 := by decide +kernel
  by_cases hk : n.cell.2.toInt.toNat<32
  · have hp : eval (env d) scanPresent=1 := by
      simp only [scanPresent,and_eval,or_eval,tag_test d n hn 0 (by decide),tag_test d n hn 1 (by decide),
        payload_lt d n hn 32 (by norm_num),(observed d n hn).2.2,ht,hk]
      rfl
    have hv : eval (env d) scanValue=ProducerSnapshot020E6.regValue d := by
      simp only [scanValue,choose_eval,hp,h10,ite_false,tag_test d n hn 0 (by decide),tag_test d n hn 1 (by decide),ht]
      simpa using ProducerScanRows020E8.row30 d
    have hr : ProducerScanSpec020E8.result d=some (ProducerSnapshot020E6.regValue d) := by
      simp only [ProducerScanSpec020E8.result,hn,Option.bind_some,ProducerScanSpec020E8.compute,SyntaxCells020E.decode,ht,SyntaxCells020E.regOf,dite_eq_left hk,Option.map_some]
    rw [hr]
    exact ⟨hp,hv⟩
  · have hp : eval (env d) scanPresent=0 := by
      simp only [scanPresent,and_eval,or_eval,tag_test d n hn 0 (by decide),tag_test d n hn 1 (by decide),tag_test d n hn 2 (by decide),
        payload_lt d n hn 32 (by norm_num),(observed d n hn).2.2,ht,hk]
      rfl
    have hr : ProducerScanSpec020E8.result d=none := by
      simp only [ProducerScanSpec020E8.result,hn,Option.bind_some,ProducerScanSpec020E8.compute,SyntaxCells020E.decode,ht,SyntaxCells020E.regOf,dite_eq_right hk,Option.map_none,Option.bind_none]
    rw [hr]
    exact zero_matches d hp

end FT1536.S05.ProducerScanRegister020E8
