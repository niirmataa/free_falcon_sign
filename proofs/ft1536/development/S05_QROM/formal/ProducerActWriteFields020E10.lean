import ProducerActStoreFields020E10
import ProducerEditWrites020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActWriteFields020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreSlots020E6 ProducerReference020E7 ProducerBankRead020E6
open ProducerActSource020E10 ProducerWordLaws020E6

def record : MemoryEdit020E5.Edit → Option (WordPatch020E5.Write 143922)
  | .keep | .fault => none
  | .reg r v => some (regPtr (cap:=877) (capacity:=28941) r,v)
  | .ram a v => some (ramPtr (cap:=877) (capacity:=28941) a,v)
  | .out a v => some (outPtr (cap:=877) (capacity:=28941) a,WordCodec020E5.boolWord v)

theorem list_record (e : MemoryEdit020E5.Edit) :
    ProducerEditWrites020E10.writes (cap:=877) (capacity:=28941) e=(record e).toList := by
  cases e <;> rfl

theorem correct (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act)
    (p : FixedAction020E5.Pending 877) (e : MemoryEdit020E5.Edit) (hr : result d=some (p,e)) :
    match record e with
    | none => eval (env d) actStore=0
    | some w => eval (env d) actStore=1 ∧ eval (env d) (dataAddress 0)=word w.1.val ∧ eval (env d) (dataValue 0)=w.2 := by
  have hs := ProducerActStoreFields020E10.accepted d hp p e hr
  have he := ((ProducerActDecision020E10.correct d).2 p e hr).1
  cases e with
  | keep => exact hs
  | fault => exact hs
  | reg r v =>
    change eval (env d) actStore=1 at hs
    refine ⟨hs,?_,(ProducerActStoreFields020E10.value d hp hs).trans he.2.2⟩
    have ha := ProducerActStoreFields020E10.address d hp hs
    rw [he.1,he.2.1] at ha
    change eval (env d) (dataAddress 0)=op .add (word r.val) (word 0) at ha
    apply (ha.trans (add_nat (lt_trans r.isLt (by norm_num)) (by norm_num))).trans
    apply congrArg (fun k : Nat => word k)
    change r.val+0=0+1*r.val
    omega
  | ram a v =>
    change eval (env d) actStore=1 at hs
    refine ⟨hs,?_,(ProducerActStoreFields020E10.value d hp hs).trans he.2.2⟩
    have ha := ProducerActStoreFields020E10.address d hp hs
    rw [he.1,he.2.1] at ha
    change eval (env d) (dataAddress 0)=op .add (word a.val) (word 32) at ha
    apply (ha.trans (add_nat (lt_trans a.isLt (by norm_num [ramSize])) (by norm_num))).trans
    apply congrArg (fun k : Nat => word k)
    change a.val+32=32+(0+1*a.val)
    omega
  | out a v =>
    change eval (env d) actStore=1 at hs
    refine ⟨hs,?_,(ProducerActStoreFields020E10.value d hp hs).trans he.2.2⟩
    have ha := ProducerActStoreFields020E10.address d hp hs
    rw [he.1,he.2.1] at ha
    change eval (env d) (dataAddress 0)=op .add (word a.val) (word 4640) at ha
    apply (ha.trans (add_nat (lt_trans a.isLt (by norm_num [outputSize])) (by norm_num))).trans
    apply congrArg (fun k : Nat => word k)
    change a.val+4640=32+(4608+(0+1*a.val))
    omega

end FT1536.S05.ProducerActWriteFields020E10
