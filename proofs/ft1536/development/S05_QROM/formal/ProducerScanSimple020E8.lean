import ProducerScanFacts020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerScanSimple020E8
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7 ProducerScanFacts020E8
attribute [local irreducible] ProducerCoreCircuit020E6.w

theorem literal (d : BoundaryPayload020E5.Data) (n : ArenaTypes020E1.Node 877)
    (hn : ProducerSnapshot020E6.scanNode d=some n) (ht : n.cell.1.val=0) : Matches d (ProducerScanSpec020E8.result d) := by
  have h10 : (1 : Word)≠0 := by decide +kernel
  have hp : eval (env d) scanPresent=1 := by
    simp only [scanPresent,and_eval,or_eval,tag_test d n hn 0 (by decide),(observed d n hn).2.2,ht,ite_true,h10,ite_false]
  have hv : eval (env d) scanValue=n.cell.2 := by
    simp only [scanValue,choose_eval,hp,h10,ite_false,tag_test d n hn 0 (by decide),ht,ite_true]
    exact (observed d n hn).2.1
  have hr : ProducerScanSpec020E8.result d=some n.cell.2 := by
    simp only [ProducerScanSpec020E8.result,hn,Option.bind_some,ProducerScanSpec020E8.compute,SyntaxCells020E.decode,ht]
  rw [hr]
  exact ⟨hp,hv⟩

theorem other (d : BoundaryPayload020E5.Data) (n : ArenaTypes020E1.Node 877)
    (hn : ProducerSnapshot020E6.scanNode d=some n) (ht : 3≤n.cell.1.val) : Matches d (ProducerScanSpec020E8.result d) := by
  have h0 : n.cell.1.val≠0 := by omega
  have h1 : n.cell.1.val≠1 := by omega
  have h2 : n.cell.1.val≠2 := by omega
  have hp : eval (env d) scanPresent=0 := by
    simp only [scanPresent,and_eval,or_eval,tag_test d n hn 0 (by decide),tag_test d n hn 1 (by decide),tag_test d n hn 2 (by decide),
      (observed d n hn).2.2,h0,h1,h2,ite_false,ite_true]
    rfl
  have hr : ProducerScanSpec020E8.result d=none := by
    rw [ProducerScanSpec020E8.result,hn,Option.bind_some]
    exact compute_other n.cell.1 n.cell.2 _ _ _ ht
  rw [hr]
  exact zero_matches d hp

end FT1536.S05.ProducerScanSimple020E8
