import ProducerActHelpers020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActLoopFields020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerActSource020E10 ProducerActHelpers020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1
open ProducerWordLaws020E6
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isToken ProducerCoreCircuit020E6.isAgain ProducerCoreCircuit020E6.remaining

theorem keep (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n) (htg : n.cell.1.val=11) : EditFields d .keep := by
  refine ⟨?_,True.intro⟩
  have hm := no_memfault d n hn (by omega) (by omega) (by omega) (by omega) (by omega)
  simp only [editTag,choose_eval,and_eval,not_eval,literal,hm,
    tag_lt d n hn 3 (by decide),tag_lt d n hn 7 (by decide),tag d n hn 7 (by decide),tag d n hn 8 (by decide),htg]
  split <;> rfl

theorem stop (d : BoundaryPayload020E5.Data) (n : Node 877) (hn : actNode d=some n)
    (htg : n.cell.1.val=11) (hc : eval (env d) loopContinues=0) : PendingFields d .none := by
  intro j
  fin_cases j <;> simp only [actionPending,choose_eval,and_eval,or_eval,literal,
    tag d n hn 9 (by decide),tag d n hn 10 (by decide),tag d n hn 11 (by decide),htg,hc,
    ProducerMetaWords020E8.pending]
  all_goals simp [word_zero]

theorem go (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877) (k : Nat) (hk : k<2^511)
    (hn : actNode d=some n) (htg : n.cell.1.val=11)
    (hc : eval (env d) loopContinues=1) (hr : eval (env d) remaining=word k) (hp : eval (env d) (w 19)=word p.val) :
    PendingFields d (.two (.run n.first) (.again p ⟨k-1,by omega⟩)) := by
  intro j
  have hpred := pred_nat (env d) remaining k hk hr
  fin_cases j <;> simp only [actionPending,choose_eval,and_eval,or_eval,literal,
    tag d n hn 9 (by decide),tag d n hn 10 (by decide),tag d n hn 11 (by decide),htg,hc,
    ProducerMetaWords020E8.pending,
    node_first d n hn,hp,hpred]
  all_goals simp [word_zero]
  all_goals rfl

end FT1536.S05.ProducerActLoopFields020E10
