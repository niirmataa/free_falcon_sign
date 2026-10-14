import ProducerNonactConsumer020E9
import ProducerDataBoundary020E9

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActSource020E10
open WordRAM020 NodeFrames020E2 ArenaTypes020E1 FixedAction020E5 ProducerSnapshot020E6

/-- Exactly the old optional action, before its control/data projections. -/
def result (d : BoundaryPayload020E5.Data) : Option (Result 877) :=
  (top d).bind (action (ArrayValues020E4.lookup d.parser.arena d.core.values)
    d.parser.arena (ProducerSlotLayout020E7.input d) d.core.state)

theorem no_top (d : BoundaryPayload020E5.Data) (h : top d=none) : result d=none := by
  rw [result,h];rfl

theorem no_node (d : BoundaryPayload020E5.Data) (hn : actNode d=none) : result d=none := by
  cases ht : top d with
  | none => exact no_top d ht
  | some fr =>
    simp only [actNode,ht,Option.bind_some] at hn
    cases fr <;> simp only [result,ht,Option.bind_some,action,NodeRead020E2.inspect,pc] at hn ⊢
    all_goals rw [hn];rfl

theorem run_node (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n) :
    result d=(SyntaxCells020E.decode n.cell).bind (dispatch (ArrayValues020E4.lookup d.parser.arena d.core.values)
      (ProducerSlotLayout020E7.input d) d.core.state p n) := by
  simp only [actNode,ht,Option.bind_some,pc] at hn
  simp only [result,ht,Option.bind_some,action,NodeRead020E2.inspect,hn,Option.bind_some]
  cases SyntaxCells020E.decode n.cell <;> rfl

theorem again_node (d : BoundaryPayload020E5.Data) (p : Ptr 877) (c : Count) (n : Node 877)
    (ht : top d=some (.again p c)) (hn : actNode d=some n) :
    result d=(SyntaxCells020E.decode n.cell).bind (fun t => match t with
      | .loop k => if c.val≤k then loopAction (ArrayValues020E4.lookup d.parser.arena d.core.values) p n.first n.second c.val else none
      | _ => none) := by
  simp only [actNode,ht,Option.bind_some,pc] at hn
  simp only [result,ht,Option.bind_some,action,NodeRead020E2.inspect,hn,Option.bind_some]
  cases SyntaxCells020E.decode n.cell <;> rfl

/-- Only these edit fields are semantically live; keep/fault carry no store. -/
def EditFields (d : BoundaryPayload020E5.Data) (e : MemoryEdit020E5.Edit) : Prop :=
  ProducerExpr020E6.eval (ProducerReference020E7.env d) ProducerCoreCircuit020E6.editTag=MemoryEdit020E5.words e 0 ∧
  match e with
  | .keep | .fault => True
  | .reg r v => ProducerExpr020E6.eval (ProducerReference020E7.env d) ProducerCoreCircuit020E6.editAddress=word r.val ∧
      ProducerExpr020E6.eval (ProducerReference020E7.env d) ProducerCoreCircuit020E6.editValue=v
  | .ram a v => ProducerExpr020E6.eval (ProducerReference020E7.env d) ProducerCoreCircuit020E6.editAddress=word a.val ∧
      ProducerExpr020E6.eval (ProducerReference020E7.env d) ProducerCoreCircuit020E6.editValue=v
  | .out a v => ProducerExpr020E6.eval (ProducerReference020E7.env d) ProducerCoreCircuit020E6.editAddress=word a.val ∧
      ProducerExpr020E6.eval (ProducerReference020E7.env d) ProducerCoreCircuit020E6.editValue=WordCodec020E5.boolWord v

def PendingFields (d : BoundaryPayload020E5.Data) (p : Pending 877) : Prop :=
  ∀ j : Fin 11,ProducerExpr020E6.eval (ProducerReference020E7.env d) (ProducerCoreCircuit020E6.actionPending j.val)=ProducerMetaWords020E8.pending p j.val

def Matches (d : BoundaryPayload020E5.Data) (r : Option (Result 877)) : Prop :=
  ProducerExpr020E6.eval (ProducerReference020E7.env d) ProducerCoreCircuit020E6.actionOK=present r ∧
  ∀ p e,r=some (p,e) → EditFields d e ∧ PendingFields d p

theorem rejected (d : BoundaryPayload020E5.Data)
    (h : ProducerExpr020E6.eval (ProducerReference020E7.env d) ProducerCoreCircuit020E6.actionOK=0) : Matches d none :=
  ⟨h,by intro p e h;cases h⟩

end FT1536.S05.ProducerActSource020E10
