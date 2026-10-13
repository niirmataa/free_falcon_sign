import ProducerScanRead020E7

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerScanValue020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreView020E6
open ProducerWordLaws020E6 ProducerEval020E7 ProducerReads020E7 ProducerTopRead020E7 ProducerScanRead020E7

/-- Conditional source pointer identity is discharged by the node-read lemma. -/
theorem child_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) (k : Nat) (e : E 7)
    (he : ∀ n, ProducerSnapshot020E6.scanNode d=Option.some n →
      eval (sources d fresh) e=word (ProducerSnapshot020E6.child n k).val) :
    eval (sources d fresh) (ProducerWindow020E6.scanGuarded e).present=
      ProducerSnapshot020E6.present (ProducerSnapshot020E6.scanValue d k) ∧
    eval (sources d fresh) (ProducerWindow020E6.scanGuarded e).value=
      ProducerSnapshot020E6.value (ProducerSnapshot020E6.scanValue d k) := by
  cases hn : ProducerSnapshot020E6.scanNode d with
  | none =>
    simp [ProducerWindow020E6.scanGuarded,guarded,and_eval,choose_eval,scan_present,hn,
      ProducerSnapshot020E6.scanValue,ProducerSnapshot020E6.present,ProducerSnapshot020E6.value,
      WordCodec020E5.boolWord,word_zero]
  | some n =>
    have hp := he n hn
    have hv := ProducerValueRead020E7.valueAt_correct d fresh e (ProducerSnapshot020E6.child n k) hp
    have hc : d.core.cursor.val<2^511 := lt_trans d.core.cursor.isLt (by norm_num)
    have hb : (ProducerSnapshot020E6.child n k).val<2^511 := lt_trans (ProducerSnapshot020E6.child n k).isLt (by norm_num)
    simp only [ProducerWindow020E6.scanGuarded,ProducerWindow020E6.scanValue,guarded,
      and_eval,choose_eval,scan_present,hn,lt_eval,hp,cursor_eval,lt_nat hb hc,hv.1,hv.2,
      ProducerSnapshot020E6.scanValue,Option.bind_some]
    by_cases h : (ProducerSnapshot020E6.child n k).val<d.core.cursor.val
    · simp only [h,ite_true]
      cases ArrayValues020E4.lookup d.parser.arena d.core.values (ProducerSnapshot020E6.child n k) <;>
        simp [ProducerSnapshot020E6.present,ProducerSnapshot020E6.value,WordCodec020E5.boolWord,word_zero]
    · simp [h,ProducerSnapshot020E6.present,ProducerSnapshot020E6.value,WordCodec020E5.boolWord,word_zero]

theorem node_some (d : BoundaryPayload020E5.Data) (fresh : Bool) (n : ArenaTypes020E1.Node 877)
    (hn : ProducerSnapshot020E6.scanNode d=Option.some n) (f : Fin 5) :
    eval (sources d fresh) (nodeAt cursor f.val)=ArenaWords020E1.nodeWords n f := by
  have h := scan_field d fresh f
  simpa only [choose_eval,scan_present,hn,ProducerSnapshot020E6.present,ProducerSnapshot020E6.field,
    Option.isSome_some,WordCodec020E5.boolWord,ite_true,show (1 : Word)≠0 by decide,
    ite_false,Option.map_some,Option.getD_some] using h

theorem first_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) (ProducerWindow020E6.scanGuarded ProducerWindow020E6.scanFirst).present=ProducerSnapshot020E6.present (ProducerSnapshot020E6.scanValue d 0) ∧
    eval (sources d fresh) (ProducerWindow020E6.scanGuarded ProducerWindow020E6.scanFirst).value=ProducerSnapshot020E6.value (ProducerSnapshot020E6.scanValue d 0) :=
  child_correct d fresh 0 ProducerWindow020E6.scanFirst (fun n hn => node_some d fresh n hn 2)

theorem second_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) (ProducerWindow020E6.scanGuarded ProducerWindow020E6.scanSecond).present=ProducerSnapshot020E6.present (ProducerSnapshot020E6.scanValue d 1) ∧
    eval (sources d fresh) (ProducerWindow020E6.scanGuarded ProducerWindow020E6.scanSecond).value=ProducerSnapshot020E6.value (ProducerSnapshot020E6.scanValue d 1) :=
  child_correct d fresh 1 ProducerWindow020E6.scanSecond (fun n hn => node_some d fresh n hn 3)

end FT1536.S05.ProducerScanValue020E7
