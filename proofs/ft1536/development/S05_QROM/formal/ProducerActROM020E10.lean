import ProducerActMemoryFacts020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActROM020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActFacts020E10 ProducerActSource020E10 ProducerActHelpers020E10 ProducerSnapshot020E6 NodeFrames020E2 ArenaTypes020E1
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isToken ProducerCoreCircuit020E6.isAgain

theorem correct (d : BoundaryPayload020E5.Data) (p : Ptr 877) (n : Node 877)
    (ht : top d=some (.run p)) (hn : actNode d=some n) (htg : n.cell.1.val=4) : Matches d (result d) := by
  have hok := ProducerActRegisterFacts020E10.ok d p n ht hn (by omega) (by omega)
  have hpending := pending_none d p n ht hn (by omega) (by omega) (by omega)
  rw [run_node d p n ht hn]
  simp only [SyntaxCells020E.decode,htg,SyntaxCells020E.regOf]
  by_cases hk : n.cell.2.toInt.toNat<32
  · simp only [dite_eq_left hk,Option.map_some,Option.bind_some,FixedAction020E5.dispatch,MemoryEdit020E5.atom]
    rw [ite_eq_left hk] at hok
    cases hv : ArrayValues020E4.lookup d.parser.arena d.core.values n.first with
    | none => rw [hv] at hok;exact rejected d hok
    | some v =>
      rw [hv] at hok
      have h38 : eval (env d) (w 38)=v := (first d n hn).2.trans (by rw [hv];rfl)
      have hvalid := ProducerAddress020E7.valid_eval (env d) romSize (by norm_num [romSize]) (w 38)
      rw [h38] at hvalid
      have hm : eval (env d) memFault=op .eq (WordCodec020E5.boolWord (WordRAM020.address romSize v).isSome) 0 := by
        simp only [memFault,or_eval,and_eval,not_eval,tag d n hn 4 (by decide),tag d n hn 5 (by decide),
          tag d n hn 6 (by decide),tag d n hn 7 (by decide),tag d n hn 8 (by decide),htg,hvalid]
        cases (WordRAM020.address romSize v).isSome <;> rfl
      have het := ProducerActMemoryFacts020E10.tag d p n ht hn (by omega) (by omega)
      have hval : eval (env d) editValue=eval (env d) (w 44) := by
        simp only [editValue,choose_eval,tag d n hn 4 (by decide),tag d n hn 5 (by decide),tag d n hn 6 (by decide),htg]
        rfl
      cases ha : WordRAM020.address romSize v with
      | none =>
        simp only [Option.map_some,ha]
        have hf : eval (env d) memFault=1 := hm.trans (by rw [ha];rfl)
        have he : eval (env d) editTag=1 := het.trans (by rw [hf];rfl)
        exact accepted d .none .fault hok ⟨he,True.intro⟩ hpending
      | some a =>
        simp only [Option.map_some,ha]
        have hf : eval (env d) memFault=0 := hm.trans (by rw [ha];rfl)
        have he : eval (env d) editTag=2 := het.trans (by rw [hf];rfl)
        apply accepted d _ _ hok _ hpending
        refine ⟨he,ProducerActRegisterFacts020E10.address d n hn he,?_⟩
        exact hval.trans ((ProducerActRegisterFacts020E10.memory_rom d n hn v hv).trans (by rw [ha];rfl))
  · simp only [dite_eq_right hk,Option.map_none,Option.bind_none]
    rw [ite_eq_right hk] at hok
    exact rejected d hok

end FT1536.S05.ProducerActROM020E10
