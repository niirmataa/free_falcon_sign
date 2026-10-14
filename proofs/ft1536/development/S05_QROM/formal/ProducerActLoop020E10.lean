import ProducerActLoopCore020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActLoop020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerActSource020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isToken ProducerCoreCircuit020E6.isAgain

theorem run (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n) (htg : n.cell.1.val=11) : Matches d (result d) := by
  have hr : eval (env d) remaining=word n.cell.2.toInt.toNat := by
    simp only [remaining,choose_eval,ProducerActFacts020E10.run d p ht]
    exact payload d n hn
  have hpc : eval (env d) (w 19)=word p.val := (ProducerActRows020E10.row19 d).trans (by rw [ht];rfl)
  have hc := ProducerActLoopCore020E10.correct d p n n.cell.2.toInt.toNat (ProducerRegisterRead020E7.clamp_bound _) hn htg hr hpc
  have hok : eval (env d) actionOK=eval (env d) loopOK := by
    simp only [actionOK,ordinaryOK,and_eval,choose_eval,(observed d n hn).2.2,
      ProducerActFacts020E10.run d p ht,tag d n hn 7 (by decide),tag d n hn 8 (by decide),tag d n hn 9 (by decide),
      tag d n hn 10 (by decide),tag d n hn 11 (by decide),htg]
    rfl
  have hs : result d=FixedAction020E5.loopAction (ArrayValues020E4.lookup d.parser.arena d.core.values) p n.first n.second n.cell.2.toInt.toNat := by
    rw [run_node d p n ht hn]
    simp only [SyntaxCells020E.decode,htg,Option.bind_some,FixedAction020E5.dispatch]
  rw [hs]
  exact ⟨hok.trans hc.1,hc.2⟩

theorem again (d : BoundaryPayload020E5.Data) (p : Ptr 877) (c : Count) (n : Node 877)
    (ht : top d=some (.again p c)) (hn : actNode d=some n) (htg : n.cell.1.val=11) : Matches d (result d) := by
  have h20 : eval (env d) (w 20)=word c.val := (ProducerActRows020E10.row20 d).trans (by rw [ht];rfl)
  have hr : eval (env d) remaining=word c.val := by
    simp only [remaining,choose_eval,ProducerActFacts020E10.again d p c ht]
    exact h20
  have hpc : eval (env d) (w 19)=word p.val := (ProducerActRows020E10.row19 d).trans (by rw [ht];rfl)
  have hcmp : eval (env d) (ProducerScalar020E6.lt payloadNat (w 20))=if n.cell.2.toInt.toNat<c.val then (1 : Word) else 0 := by
    simp only [lt_eval,payload d n hn,h20]
    exact ProducerWordLaws020E6.lt_nat (ProducerRegisterRead020E7.clamp_bound _) c.isLt
  have hs : result d=if c.val≤n.cell.2.toInt.toNat then FixedAction020E5.loopAction (ArrayValues020E4.lookup d.parser.arena d.core.values) p n.first n.second c.val else none := by
    rw [again_node d p c n ht hn]
    simp only [SyntaxCells020E.decode,htg,Option.bind_some]
  rw [hs]
  by_cases hl : c.val≤n.cell.2.toInt.toNat
  · rw [ite_eq_left hl]
    have hbad : ¬n.cell.2.toInt.toNat<c.val := by omega
    have hok : eval (env d) actionOK=eval (env d) loopOK := by
      simp only [actionOK,and_eval,choose_eval,not_eval,(observed d n hn).2.2,
        ProducerActFacts020E10.again d p c ht,tag d n hn 11 (by decide),htg,hcmp,hbad]
      rfl
    have hc := ProducerActLoopCore020E10.correct d p n c.val c.isLt hn htg hr hpc
    exact ⟨hok.trans hc.1,hc.2⟩
  · rw [ite_eq_right hl]
    have hbad : n.cell.2.toInt.toNat<c.val := by omega
    apply rejected
    simp only [actionOK,and_eval,choose_eval,not_eval,(observed d n hn).2.2,
      ProducerActFacts020E10.again d p c ht,tag d n hn 11 (by decide),htg,hcmp,hbad]
    rfl

end FT1536.S05.ProducerActLoop020E10
