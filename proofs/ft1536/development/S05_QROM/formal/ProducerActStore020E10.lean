import ProducerActRegisterFacts020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActStore020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerActSource020E10 ProducerActHelpers020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isToken ProducerCoreCircuit020E6.isAgain

theorem correct (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n) (htg : n.cell.1.val=7) : Matches d (result d) := by
  have hpending := pending_none d p n ht hn (by omega) (by omega) (by omega)
  have hok : eval (env d) actionOK=if eval (env d) (w 39)=0 then 0 else
      if op .eq (eval (env d) (ProducerScalar020E6.validAddress ramSize (w 40))) 0=0 then eval (env d) (w 37) else 1 := by
    simp only [actionOK,and_eval,or_eval,not_eval,choose_eval,(observed d n hn).2.2,
      ProducerActFacts020E10.run d p ht,tag d n hn 7 (by decide),tag d n hn 8 (by decide),htg]
    rfl
  have het : eval (env d) editTag=if eval (env d) memFault=0 then (3 : Word) else 1 := by
    simp only [editTag,choose_eval,and_eval,not_eval,literal,ProducerActFacts020E10.run d p ht,
      tag_lt d n hn 3 (by decide),tag_lt d n hn 7 (by decide),tag d n hn 7 (by decide),tag d n hn 8 (by decide),htg]
    rfl
  rw [run_node d p n ht hn]
  simp only [SyntaxCells020E.decode,htg,Option.bind_some,FixedAction020E5.dispatch,MemoryEdit020E5.atom]
  cases hv : ArrayValues020E4.lookup d.parser.arena d.core.values n.second with
  | none =>
    have h39 : eval (env d) (w 39)=0 := (second d n hn).1.trans (by rw [hv];rfl)
    exact rejected d (hok.trans (by rw [h39];rfl))
  | some v =>
    have h39 : eval (env d) (w 39)=1 := (second d n hn).1.trans (by rw [hv];rfl)
    have h40 : eval (env d) (w 40)=v := (second d n hn).2.trans (by rw [hv];rfl)
    have hvalid := ProducerAddress020E7.valid_eval (env d) ramSize (by norm_num [ramSize]) (w 40)
    rw [h40] at hvalid
    have hm : eval (env d) memFault=op .eq (WordCodec020E5.boolWord (WordRAM020.address ramSize v).isSome) 0 := by
      simp only [memFault,or_eval,and_eval,not_eval,tag d n hn 4 (by decide),tag d n hn 5 (by decide),
        tag d n hn 6 (by decide),tag d n hn 7 (by decide),tag d n hn 8 (by decide),htg,hvalid]
      cases (WordRAM020.address ramSize v).isSome <;> rfl
    simp only [Option.bind_some]
    cases ha : WordRAM020.address ramSize v with
    | none =>
      have hvalid0 : eval (env d) (ProducerScalar020E6.validAddress ramSize (w 40))=0 := hvalid.trans (by rw [ha];rfl)
      have hp : eval (env d) actionOK=1 := hok.trans (by rw [h39,hvalid0];rfl)
      have hf : eval (env d) memFault=1 := hm.trans (by rw [ha];rfl)
      have he : eval (env d) editTag=1 := het.trans (by rw [hf];rfl)
      exact accepted d .none .fault hp ⟨he,True.intro⟩ hpending
    | some a =>
      have hvalid1 : eval (env d) (ProducerScalar020E6.validAddress ramSize (w 40))=1 := hvalid.trans (by rw [ha];rfl)
      have hp : eval (env d) actionOK=present (ArrayValues020E4.lookup d.parser.arena d.core.values n.first) :=
        (hok.trans (by rw [h39,hvalid1];rfl)).trans (first d n hn).1
      cases hx : ArrayValues020E4.lookup d.parser.arena d.core.values n.first with
      | none => rw [hx] at hp;exact rejected d hp
      | some x =>
        rw [hx] at hp
        have h38 : eval (env d) (w 38)=x := (first d n hn).2.trans (by rw [hx];rfl)
        have hf : eval (env d) memFault=0 := hm.trans (by rw [ha];rfl)
        have he : eval (env d) editTag=3 := het.trans (by rw [hf];rfl)
        apply accepted d _ _ hp _ hpending
        refine ⟨he,?_,?_⟩
        · have had : eval (env d) editAddress=v := by
            simp only [editAddress,choose_eval,eq_eval,literal,he]
            exact h40
          exact had.trans (ProducerAddress020E7.some_word v a ha)
        ·
          simp only [editValue,choose_eval,tag d n hn 4 (by decide),tag d n hn 5 (by decide),tag d n hn 6 (by decide),tag d n hn 8 (by decide),htg]
          exact h38

end FT1536.S05.ProducerActStore020E10
