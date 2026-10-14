import ProducerActLoopFields020E10
import ProducerActTests020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActLoopCore020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerActSource020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1 FixedAction020E5
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.remaining

theorem normalized (f : Ptr 877 → Option Word) (p body guard : Ptr 877) (k : Nat) (hk : k<2^511) :
    loopAction f p body guard k=if k=0 then some (.none,.keep) else
      (f guard).bind (fun v => if v=0 then some (.none,.keep) else some (.two (.run body) (.again p ⟨k-1,by omega⟩),.keep)) := by
  unfold loopAction
  rw [count_eq (k-1) (by omega)]
  rfl

theorem fields_some (d : BoundaryPayload020E5.Data) (p : Pending 877) (e : MemoryEdit020E5.Edit)
    (he : EditFields d e) (hp : PendingFields d p) :
    ∀ q a,(some (p,e) : Option (Result 877))=some (q,a) → EditFields d a ∧ PendingFields d q := by
  intro q a h
  cases Option.some.inj h
  exact ⟨he,hp⟩

theorem correct (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877) (k : Nat) (hk : k<2^511)
    (hn : actNode d=some n) (htg : n.cell.1.val=11)
    (hr : eval (env d) remaining=word k) (hpc : eval (env d) (w 19)=word p.val) :
    eval (env d) loopOK=present (loopAction (ArrayValues020E4.lookup d.parser.arena d.core.values) p n.first n.second k) ∧
    ∀ q e,loopAction (ArrayValues020E4.lookup d.parser.arena d.core.values) p n.first n.second k=some (q,e) → EditFields d e ∧ PendingFields d q := by
  have hzero : eval (env d) (ProducerScalar020E6.eq remaining (ProducerScalar020E6.lit 0))=if k=0 then (1 : Word) else 0 := by
    simp only [eq_eval,literal,hr]
    exact ProducerWordLaws020E6.eq_nat hk (by norm_num)
  have hkeep := ProducerActLoopFields020E10.keep d n hn htg
  rw [normalized _ _ _ _ k hk]
  by_cases hz : k=0
  · simp only [hz,ite_true]
    have hok : eval (env d) loopOK=1 := by simp only [loopOK,or_eval,hzero,hz];rfl
    have hc : eval (env d) loopContinues=0 := by simp only [loopContinues,and_eval,not_eval,hzero,hz];rfl
    exact ⟨hok,fields_some d .none .keep hkeep (ProducerActLoopFields020E10.stop d n hn htg hc)⟩
  · simp only [hz,ite_false]
    cases hg : ArrayValues020E4.lookup d.parser.arena d.core.values n.second with
    | none =>
      have h39 : eval (env d) (w 39)=0 := (second d n hn).1.trans (by rw [hg];rfl)
      have hok : eval (env d) loopOK=0 := by simp only [loopOK,or_eval,hzero,hz,h39];rfl
      exact ⟨hok,by intro q e h;cases h⟩
    | some v =>
      have h39 : eval (env d) (w 39)=1 := (second d n hn).1.trans (by rw [hg];rfl)
      have h40 : eval (env d) (w 40)=v := (second d n hn).2.trans (by rw [hg];rfl)
      have hok : eval (env d) loopOK=1 := by simp only [loopOK,or_eval,hzero,hz,h39];rfl
      simp only [Option.bind_some]
      by_cases hv : v=0
      · simp only [hv,ite_true]
        have hc : eval (env d) loopContinues=0 := by
          simp only [loopContinues,and_eval,not_eval,hzero,hz,ProducerActTests020E10.eq_zero,h40,hv];rfl
        exact ⟨hok,fields_some d .none .keep hkeep (ProducerActLoopFields020E10.stop d n hn htg hc)⟩
      · simp only [hv,ite_false]
        have hc : eval (env d) loopContinues=1 := by
          simp only [loopContinues,and_eval,not_eval,hzero,hz,ProducerActTests020E10.eq_zero,h40,hv];rfl
        exact ⟨hok,fields_some d _ .keep hkeep (ProducerActLoopFields020E10.go d p n k hk hn htg hc hr hpc)⟩

end FT1536.S05.ProducerActLoopCore020E10
