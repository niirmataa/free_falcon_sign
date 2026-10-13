import ProducerActRead020E7

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActValue020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreView020E6
open ProducerWordLaws020E6 ProducerEval020E7 ProducerActRead020E7

theorem child_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) (k : Nat) (e : E 7)
    (he : ∀ n, ProducerSnapshot020E6.actNode d=Option.some n →
      eval (sources d fresh) e=word (ProducerSnapshot020E6.child n k).val) :
    eval (sources d fresh) (ProducerWindow020E6.actGuarded e).present=
      ProducerSnapshot020E6.present (ProducerSnapshot020E6.actValue d k) ∧
    eval (sources d fresh) (ProducerWindow020E6.actGuarded e).value=
      ProducerSnapshot020E6.value (ProducerSnapshot020E6.actValue d k) := by
  cases hn : ProducerSnapshot020E6.actNode d with
  | none =>
    simp [ProducerWindow020E6.actGuarded,guarded,and_eval,choose_eval,act_present,hn,
      ProducerSnapshot020E6.actValue,ProducerSnapshot020E6.present,ProducerSnapshot020E6.value,
      WordCodec020E5.boolWord,word_zero]
  | some n =>
    have hv := ProducerValueRead020E7.valueAt_correct d fresh e (ProducerSnapshot020E6.child n k) (he n hn)
    simp only [ProducerWindow020E6.actGuarded,guarded,and_eval,choose_eval,act_present,hn,hv.1,hv.2,
      ProducerSnapshot020E6.actValue,Option.bind_some]
    cases ArrayValues020E4.lookup d.parser.arena d.core.values (ProducerSnapshot020E6.child n k) <;>
      simp [ProducerSnapshot020E6.present,ProducerSnapshot020E6.value,WordCodec020E5.boolWord,word_zero]

theorem first_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).present=ProducerSnapshot020E6.present (ProducerSnapshot020E6.actValue d 0) ∧
    eval (sources d fresh) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value=ProducerSnapshot020E6.value (ProducerSnapshot020E6.actValue d 0) :=
  child_correct d fresh 0 ProducerWindow020E6.actFirst (fun n hn => node_some d fresh n hn 2)

theorem second_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actSecond).present=ProducerSnapshot020E6.present (ProducerSnapshot020E6.actValue d 1) ∧
    eval (sources d fresh) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actSecond).value=ProducerSnapshot020E6.value (ProducerSnapshot020E6.actValue d 1) :=
  child_correct d fresh 1 ProducerWindow020E6.actSecond (fun n hn => node_some d fresh n hn 3)

theorem third_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actThird).present=ProducerSnapshot020E6.present (ProducerSnapshot020E6.actValue d 2) ∧
    eval (sources d fresh) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actThird).value=ProducerSnapshot020E6.value (ProducerSnapshot020E6.actValue d 2) :=
  child_correct d fresh 2 ProducerWindow020E6.actThird (fun n hn => node_some d fresh n hn 4)

end FT1536.S05.ProducerActValue020E7
