import ProducerActHelpers020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActReject020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerActSource020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isToken ProducerCoreCircuit020E6.isAgain

theorem run_decode (n : Node 877) (f : Ptr 877 → Option Word) (i : ArrayState020E4.Input) (s : ArrayState020E4.State)
    (p : Ptr 877) (h : n.cell.1.val<3 ∨ 12≤n.cell.1.val) :
    (SyntaxCells020E.decode n.cell).bind (FixedAction020E5.dispatch f i s p n)=none := by
  rcases n with ⟨⟨tag,x⟩,a,b,c⟩
  fin_cases tag <;> norm_num at h
  all_goals simp only [SyntaxCells020E.decode,FixedAction020E5.dispatch,MemoryEdit020E5.atom]
  all_goals first | rfl | (cases SyntaxCells020E.regOf x <;> rfl) | (cases SyntaxCells020E.opOf x.toInt.toNat <;> rfl)

theorem run (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n) (h : n.cell.1.val<3 ∨ 12≤n.cell.1.val) : Matches d (result d) := by
  rw [run_node d p n ht hn,run_decode n _ _ _ p h]
  apply rejected
  have h7 : n.cell.1.val≠7 := by omega
  have h8 : n.cell.1.val≠8 := by omega
  have h9 : n.cell.1.val≠9 := by omega
  have h10 : n.cell.1.val≠10 := by omega
  have h11 : n.cell.1.val≠11 := by omega
  simp only [actionOK,ordinaryOK,and_eval,choose_eval,not_eval,literal,(observed d n hn).2.2,
    ProducerActFacts020E10.run d p ht,tag d n hn 7 (by decide),tag d n hn 8 (by decide),tag d n hn 9 (by decide),
    tag d n hn 10 (by decide),tag d n hn 11 (by decide),tag_lt d n hn 3 (by decide),tag_lt d n hn 7 (by decide),
    h7,h8,h9,h10,h11]
  have ho : (1 : Word)≠0 := by decide
  rcases h with h|h
  · have h3 : n.cell.1.val<3 := h
    simp only [h3,ite_true,ite_false,show op .eq (1 : Word) 0=0 by rfl,ho,ite_self]
  · have h3 : ¬n.cell.1.val<3 := by omega
    have h7 : ¬n.cell.1.val<7 := by omega
    simp only [h3,h7,ite_false,ite_true,show op .eq (0 : Word) 0=1 by rfl,ho,ite_self]

theorem again_decode (n : Node 877) (f : Ptr 877 → Option Word) (p : Ptr 877) (c : Count)
    (h : n.cell.1.val≠11) :
    (SyntaxCells020E.decode n.cell).bind (fun t => match t with
      | .loop k => if c.val≤k then FixedAction020E5.loopAction f p n.first n.second c.val else none
      | _ => none)=none := by
  rcases n with ⟨⟨tag,x⟩,a,b,c'⟩
  fin_cases tag <;> norm_num at h
  all_goals simp only [SyntaxCells020E.decode]
  all_goals first | rfl | (cases SyntaxCells020E.regOf x <;> rfl) | (cases SyntaxCells020E.opOf x.toInt.toNat <;> rfl)

theorem again (d : BoundaryPayload020E5.Data) (p : Ptr 877) (c : Count) (n : Node 877)
    (ht : top d=some (.again p c)) (hn : actNode d=some n) (h : n.cell.1.val≠11) : Matches d (result d) := by
  have he := (again_node d p c n ht hn).trans (again_decode n (ArrayValues020E4.lookup d.parser.arena d.core.values) p c h)
  rw [he]
  apply rejected
  simp only [actionOK,and_eval,choose_eval,(observed d n hn).2.2,
    ProducerActFacts020E10.again d p c ht,tag d n hn 11 (by decide),h]
  rfl

end FT1536.S05.ProducerActReject020E10
