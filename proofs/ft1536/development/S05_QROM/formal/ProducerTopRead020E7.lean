import ProducerReads020E7
import ProducerWindow020E6
import ProducerSnapshot020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerTopRead020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreView020E6
open ProducerWordLaws020E6 ProducerEval020E7

theorem sp_eval (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) sp=word d.core.frames.sp.val := ProducerCoreSource020E6.control_eval d fresh 3

theorem cursor_eval (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) cursor=word d.core.cursor.val := ProducerCoreSource020E6.control_eval d fresh 1

theorem frame_eval (d : BoundaryPayload020E5.Data) (fresh : Bool) (p : E 7)
    (j : Fin 28941) (h : eval (sources d fresh) p=word j.val) (f : Fin 3) :
    eval (sources d fresh) (frameAt p f.val)=BankStorage020E3.frameWords (read d.core.frames.bank j) f := by
  have hj : j.val<2^511 := lt_trans j.isLt (by norm_num)
  have hf : f.val<3 := f.isLt
  simp only [frameAt,load_eval,add_eval,mul_eval,literal,h,frameBase,
    mul_nat (a:=3) (b:=j.val) (by norm_num) hj,
    add_nat (a:=55329+f.val) (b:=3*j.val) (by omega) (by omega)]
  have he : 55329+f.val+3*j.val=55329+3*j.val+f.val := by omega
  rw [he]
  exact ProducerCoreSource020E6.frame_word d fresh j f

theorem top_present (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) ProducerWindow020E6.topPresent=ProducerSnapshot020E6.present (ProducerSnapshot020E6.top d) := by
  have hn : d.core.frames.sp.val<2^511 := lt_trans d.core.frames.sp.isLt (by norm_num)
  simp only [ProducerWindow020E6.topPresent,not_eval,eq_eval,sp_eval,literal,
    eq_nat (a:=d.core.frames.sp.val) (b:=0) hn (by norm_num)]
  by_cases h : d.core.frames.sp.val=0
  · simp only [h,ite_true,ProducerSnapshot020E6.top,ArrayFrames020E4.top]
    rfl
  · have hz : 0<d.core.frames.sp.val := by omega
    simp only [h,ite_false,ProducerSnapshot020E6.top,ArrayFrames020E4.top,dite_eq_left hz]
    rfl

theorem top_field (d : BoundaryPayload020E5.Data) (fresh : Bool) (f : Fin 3) :
    eval (sources d fresh) (choose ProducerWindow020E6.topPresent (frameAt ProducerWindow020E6.top f.val) (lit 0))=
      ((ProducerSnapshot020E6.top d).map (fun fr => BankStorage020E3.frameWords fr f)).getD 0 := by
  rw [choose_eval,top_present]
  by_cases h : 0<d.core.frames.sp.val
  · have hn : d.core.frames.sp.val<2^511 := lt_trans d.core.frames.sp.isLt (by norm_num)
    have hb : d.core.frames.sp.val-1<28941 := by have := d.core.frames.sp.isLt;omega
    have hp := pred_nat (sources d fresh) sp d.core.frames.sp.val hn (sp_eval d fresh)
    have hh := frame_eval d fresh ProducerWindow020E6.top ⟨d.core.frames.sp.val-1,hb⟩ hp f
    simp only [ProducerSnapshot020E6.top,ArrayFrames020E4.top,dite_eq_left h,ProducerSnapshot020E6.present,
      Option.isSome_some,WordCodec020E5.boolWord,ite_true,Option.map_some,Option.getD_some]
    exact hh
  · simp only [ProducerSnapshot020E6.top,ArrayFrames020E4.top,dite_eq_right h,ProducerSnapshot020E6.present,
      Option.isSome_none,WordCodec020E5.boolWord,Bool.false_eq_true,ite_false,ite_true,Option.map_none,Option.getD_none,literal]
    rfl

end FT1536.S05.ProducerTopRead020E7
