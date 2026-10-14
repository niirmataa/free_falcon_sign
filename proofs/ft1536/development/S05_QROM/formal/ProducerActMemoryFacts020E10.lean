import ProducerActRegisterFacts020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActMemoryFacts020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerSnapshot020E6 ArenaTypes020E1 NodeFrames020E2
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isToken ProducerCoreCircuit020E6.isAgain

theorem tag (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n) (hl : 3≤n.cell.1.val) (hu : n.cell.1.val<7) :
    eval (env d) editTag=if eval (env d) memFault=0 then (2 : Word) else 1 := by
  have h3 : ¬n.cell.1.val<3 := by omega
  simp only [editTag,choose_eval,and_eval,not_eval,literal,ProducerActFacts020E10.run d p ht,
    tag_lt d n hn 3 (by decide),tag_lt d n hn 7 (by decide),h3,hu]
  rfl

end FT1536.S05.ProducerActMemoryFacts020E10
