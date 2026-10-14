import ProducerDataFlags020E9
import ProducerDataList020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerDataAddress020E9
open WordRAM020 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreSlots020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerDataFlags020E9 ProducerMetaWords020E8 ProducerWordLaws020E6 ProducerDataList020E8
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isPhase

theorem affine {r : Nat} {extent : Fin r → Nat} (s : ProducerMachine020E6.Sources extent) (e : Expr r)
    (a b n : Nat) (ha : a<2^511) (hb : b<2^511) (hn : n<2^511) (hm : b*n<2^511)
    (he : eval s e=word n) : eval s (add (lit a) (mul (lit b) e))=word (a+b*n : Nat) := by
  simp only [add_eval,mul_eval,literal,he,mul_nat hb hn,add_nat ha hm]

theorem value_pointer (j : Fin 877) (f : Fin 2) :
    (valuePointer (cap:=877) (capacity:=28941) j f).val=142152+f.val+2*j.val := by
  change 32+(4608+(50689+(28941*3+(f.val+2*j.val))))=142152+f.val+2*j.val
  omega

theorem frame_pointer (j : Fin 28941) (f : Fin 3) :
    (framePointer (cap:=877) (capacity:=28941) j f).val=55329+f.val+3*j.val := by
  change 32+(4608+(50689+(f.val+3*j.val)))=55329+f.val+3*j.val
  omega

theorem sweep_address (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.clear ∨ d.core.phase=.scan)
    (h : d.core.cursor.val<877) (j : Fin 2) :
    eval (env d) (dataAddress j.val)=word (valuePointer (cap:=877) (capacity:=28941) ⟨d.core.cursor.val,h⟩ j).val := by
  have hv : eval (env d) valueStep=1 := by rw [sweep d hp,ite_eq_left h]
  simp only [dataAddress,choose_eval,hv]
  change eval (env d) (add (lit (142152+j.val)) (mul (lit 2) (w 1)))=_
  rw [value_pointer]
  apply affine
  · have := j.isLt;omega
  · norm_num
  · have := d.core.cursor.isLt;omega
  · omega
  · exact read_control d 1 (by decide)

theorem push_address (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.push)
    (h : d.core.frames.sp.val<28941) (j : Fin 3) :
    eval (env d) (dataAddress j.val)=word (framePointer (cap:=877) (capacity:=28941) ⟨d.core.frames.sp.val,h⟩ j).val := by
  simp only [dataAddress,choose_eval,push_value d hp,no_act d (by simp [hp])]
  change eval (env d) (add (lit (55329+j.val)) (mul (lit 3) (w 3)))=_
  rw [frame_pointer]
  apply affine
  · have := j.isLt;omega
  · norm_num
  · have := d.core.frames.sp.isLt;omega
  · omega
  · exact read_control d 3 (by decide)

end FT1536.S05.ProducerDataAddress020E9
