import ProducerActFacts020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActHelpers020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerActSource020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1
open ProducerWordLaws020E6
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isToken ProducerCoreCircuit020E6.isAgain

theorem accepted (d : BoundaryPayload020E5.Data) (p : FixedAction020E5.Pending 877) (e : MemoryEdit020E5.Edit)
    (hp : eval (env d) actionOK=1) (he : EditFields d e) (hf : PendingFields d p) : Matches d (some (p,e)) := by
  refine ⟨hp,?_⟩
  intro q a h
  have h' := Option.some.inj h
  cases h'
  exact ⟨he,hf⟩

theorem node_first (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) : eval (env d) (w 34)=word n.first.val :=
  (ProducerActRows020E10.row34 d).trans (by rw [hn];rfl)
theorem node_second (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) : eval (env d) (w 35)=word n.second.val :=
  (ProducerActRows020E10.row35 d).trans (by rw [hn];rfl)

theorem pending_none (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n)
    (h9 : n.cell.1.val≠9) (h10 : n.cell.1.val≠10) (h11 : n.cell.1.val≠11) :
    PendingFields d .none := by
  intro j
  fin_cases j <;> simp only [actionPending,choose_eval,and_eval,or_eval,not_eval,eq_eval,literal,
    ProducerActFacts020E10.run d p ht,tag d n hn 9 (by decide),tag d n hn 10 (by decide),tag d n hn 11 (by decide),h9,h10,h11]
  all_goals rfl

theorem no_memfault (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n)
    (h4 : n.cell.1.val≠4) (h5 : n.cell.1.val≠5) (h6 : n.cell.1.val≠6)
    (h7 : n.cell.1.val≠7) (h8 : n.cell.1.val≠8) : eval (env d) memFault=0 := by
  simp only [memFault,or_eval,and_eval,tag d n hn 4 (by decide),tag d n hn 5 (by decide),tag d n hn 6 (by decide),
    tag d n hn 7 (by decide),tag d n hn 8 (by decide),h4,h5,h6,h7,h8]
  rfl

theorem keep (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n) (hg : 9≤n.cell.1.val) : EditFields d .keep := by
  refine ⟨?_,True.intro⟩
  have hm := no_memfault d n hn (by omega) (by omega) (by omega) (by omega) (by omega)
  simp only [editTag,choose_eval,and_eval,not_eval,literal,ProducerActFacts020E10.run d p ht,hm,
    tag_lt d n hn 3 (by decide),tag_lt d n hn 7 (by decide),tag d n hn 7 (by decide),tag d n hn 8 (by decide)]
  have h3 : ¬n.cell.1.val<3 := by omega
  have h7 : ¬n.cell.1.val<7 := by omega
  have he7 : n.cell.1.val≠7 := by omega
  have he8 : n.cell.1.val≠8 := by omega
  simp only [h3,h7,he7,he8,ite_false]
  rfl

end FT1536.S05.ProducerActHelpers020E10
