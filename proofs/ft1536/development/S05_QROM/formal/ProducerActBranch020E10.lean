import ProducerActTests020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActBranch020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerActSource020E10 ProducerActHelpers020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isToken ProducerCoreCircuit020E6.isAgain

theorem correct (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n) (htg : n.cell.1.val=10) : Matches d (result d) := by
  have hok : eval (env d) actionOK=present (ArrayValues020E4.lookup d.parser.arena d.core.values n.third) := by
    simp only [actionOK,ordinaryOK,and_eval,choose_eval,literal,(observed d n hn).2.2,
      ProducerActFacts020E10.run d p ht,tag d n hn 7 (by decide),tag d n hn 8 (by decide),tag d n hn 9 (by decide),tag d n hn 10 (by decide),htg]
    exact (third d n hn).1
  rw [run_node d p n ht hn]
  simp only [SyntaxCells020E.decode,htg,Option.bind_some,FixedAction020E5.dispatch]
  cases hg : ArrayValues020E4.lookup d.parser.arena d.core.values n.third with
  | none =>
    rw [hg] at hok
    exact rejected d hok
  | some v =>
    rw [hg] at hok
    apply accepted d _ .keep hok (keep d p n ht hn (by omega))
    intro j
    have h42 : eval (env d) (w 42)=v := (third d n hn).2.trans (by rw [hg];rfl)
    by_cases hz : v=0
    all_goals fin_cases j
    all_goals simp only [actionPending,choose_eval,and_eval,or_eval,not_eval,literal,ProducerActTests020E10.eq_zero,
      ProducerActFacts020E10.run d p ht,tag d n hn 9 (by decide),tag d n hn 10 (by decide),tag d n hn 11 (by decide),htg,
      node_first d n hn,node_second d n hn,h42,ProducerMetaWords020E8.pending,hz]
    all_goals rfl

end FT1536.S05.ProducerActBranch020E10
