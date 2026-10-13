import ProducerScanFacts020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerScanBinary020E8
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7 ProducerScanFacts020E8
open ProducerScanRows020E8
attribute [local irreducible] ProducerCoreCircuit020E6.w

theorem result (d : BoundaryPayload020E5.Data) (n : ArenaTypes020E1.Node 877)
    (hn : ProducerSnapshot020E6.scanNode d=some n) (ht : n.cell.1.val=2) :
    ProducerScanSpec020E8.result d=(SyntaxCells020E.opOf n.cell.2.toInt.toNat).bind (fun o =>
      (ProducerSnapshot020E6.scanValue d 1).bind (fun x => (ProducerSnapshot020E6.scanValue d 0).map (fun y => op o x y))) := by
  simp only [ProducerScanSpec020E8.result,hn,Option.bind_some,ProducerScanSpec020E8.compute,SyntaxCells020E.decode,ht]
  cases SyntaxCells020E.opOf n.cell.2.toInt.toNat <;> rfl

theorem correct (d : BoundaryPayload020E5.Data) (n : ArenaTypes020E1.Node 877)
    (hn : ProducerSnapshot020E6.scanNode d=some n) (ht : n.cell.1.val=2) : Matches d (ProducerScanSpec020E8.result d) := by
  have h10 : (1 : Word)≠0 := by decide +kernel
  cases ho : SyntaxCells020E.opOf n.cell.2.toInt.toNat with
  | none =>
    have hk : ¬n.cell.2.toInt.toNat<7 := by have := ProducerOpcode020E8.none_bound _ ho;omega
    have hp : eval (env d) scanPresent=0 := by
      simp only [scanPresent,and_eval,or_eval,tag_test d n hn 0 (by decide),tag_test d n hn 1 (by decide),tag_test d n hn 2 (by decide),
        payload_lt d n hn 7 (by norm_num),(observed d n hn).2.2,ht,hk]
      rfl
    have hr : ProducerScanSpec020E8.result d=none := by rw [result d n hn ht,ho];rfl
    rw [hr]
    exact zero_matches d hp
  | some o =>
    obtain ⟨hi,hk⟩ := ProducerOpcode020E8.some_index _ o ho
    have hp : eval (env d) scanPresent=
        if ProducerSnapshot020E6.present (ProducerSnapshot020E6.scanValue d 0)=0 then 0
        else ProducerSnapshot020E6.present (ProducerSnapshot020E6.scanValue d 1) := by
      simp only [scanPresent,and_eval,or_eval,tag_test d n hn 0 (by decide),tag_test d n hn 1 (by decide),tag_test d n hn 2 (by decide),
        payload_lt d n hn 7 (by norm_num),(observed d n hn).2.2,ht,hk,row26,row28]
      rfl
    have he : eval (env d) (ProducerScalar020E6.natClamp (w 22))=word (SyntaxCells020E.opIndex o) := by
      simp only [clamp_eval,(observed d n hn).2.1,hi]
    cases hf : ProducerSnapshot020E6.scanValue d 0 <;> cases hb : ProducerSnapshot020E6.scanValue d 1
    case some.some a b =>
      have hpres : eval (env d) scanPresent=1 := by
        simpa only [hf,hb,ProducerSnapshot020E6.present,Option.isSome_some,WordCodec020E5.boolWord,ite_true,h10,ite_false] using hp
      have hbin : eval (env d) (binaryResult (ProducerScalar020E6.natClamp (w 22)) (w 29) (w 27))=op o b a := by
        simpa only [row29,row27,hf,hb,ProducerSnapshot020E6.value,Option.getD_some] using
          (ProducerOpcode020E8.selected (env d) _ (w 29) (w 27) o he)
      have hv : eval (env d) scanValue=op o b a := by
        simp only [scanValue,choose_eval,hpres,h10,ite_false,tag_test d n hn 0 (by decide),tag_test d n hn 1 (by decide),ht]
        exact hbin
      have hr : ProducerScanSpec020E8.result d=some (op o b a) := by rw [result d n hn ht,ho];simp [hf,hb]
      rw [hr]
      exact ⟨hpres,hv⟩
    all_goals
      have hpres : eval (env d) scanPresent=0 := by
        simpa only [hf,hb,ProducerSnapshot020E6.present,Option.isSome_none,Option.isSome_some,
          WordCodec020E5.boolWord,Bool.false_eq_true,ite_true,ite_false,h10] using hp
      have hr : ProducerScanSpec020E8.result d=none := by rw [result d n hn ht,ho];simp [hf,hb]
      rw [hr]
      exact zero_matches d hpres

end FT1536.S05.ProducerScanBinary020E8
