import ProducerActHelpers020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActSeq020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerActSource020E10 ProducerActHelpers020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isToken ProducerCoreCircuit020E6.isAgain

theorem correct (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n) (htg : n.cell.1.val=9) : Matches d (result d) := by
  rw [run_node d p n ht hn]
  simp only [SyntaxCells020E.decode,htg,Option.bind_some,FixedAction020E5.dispatch]
  apply accepted
  · simp only [actionOK,ordinaryOK,and_eval,choose_eval,literal,(observed d n hn).2.2,
      ProducerActFacts020E10.run d p ht,tag d n hn 7 (by decide),tag d n hn 8 (by decide),tag d n hn 9 (by decide),htg]
    rfl
  · exact keep d p n ht hn (by omega)
  · intro j
    fin_cases j <;> simp only [actionPending,choose_eval,and_eval,or_eval,not_eval,eq_eval,literal,
      ProducerActFacts020E10.run d p ht,tag d n hn 9 (by decide),tag d n hn 10 (by decide),tag d n hn 11 (by decide),htg,
      node_first d n hn,node_second d n hn,ProducerMetaWords020E8.pending]
    all_goals rfl

end FT1536.S05.ProducerActSeq020E10
