import ProducerDataSlots020E9
import ProducerDataAddress020E9
import ProducerDataValue020E9

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerPushSlots020E9
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerReference020E7 ProducerReferenceData020E8
open ProducerCoreSlots020E6 ProducerDataSpec020E9 ProducerDataList020E8 ProducerDataSlots020E9

theorem none (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.push)
    (hv : d.core.pending=.none) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (ProducerDataLayout020E9.encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  apply none_word d fresh j f
  · simp only [writes,hp,hv,List.getElem?_nil]
  · rw [ProducerDataFlags020E9.push_present d hp,ProducerDataFlags020E9.push_flag d hp,hv]
    rfl

theorem one (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.push)
    (v : NodeFrames020E2.Frame 877) (hv : d.core.pending=.one v) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (ProducerDataLayout020E9.encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  have ht : ProducerFlags020E8.present d.core.pending=1 := by rw [hv];rfl
  have ho : (1 : Word)≠0 := by decide
  have hf := ProducerDataFlags020E9.push_flag d hp
  by_cases h : d.core.frames.sp.val<28941
  · let p : WordPatch020E5.Write 143922 := (framePointer (cap:=877) (capacity:=28941) ⟨d.core.frames.sp.val,h⟩ j,BankStorage020E3.frameWords v j)
    apply some_word d fresh j f p
    · simp only [writes,hp,hv,pushWrites,dite_eq_left h,frameWrites,List.getElem?_ofFn,dite_eq_left j.isLt]
      rfl
    · rw [ProducerDataFlags020E9.push_present d hp,hf,ht,ite_eq_right ho,ite_eq_left h]
    · exact ProducerDataAddress020E9.push_address d hp h j
    · exact ProducerDataValue020E9.push_one d hp v hv j
  · apply none_word d fresh j f
    · simp only [writes,hp,hv,pushWrites,dite_eq_right h,List.getElem?_nil]
    · rw [ProducerDataFlags020E9.push_present d hp,hf,ht,ite_eq_right ho,ite_eq_right h]

theorem two (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.push)
    (u v : NodeFrames020E2.Frame 877) (hv : d.core.pending=.two u v) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (ProducerDataLayout020E9.encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  have ht : ProducerFlags020E8.present d.core.pending=1 := by rw [hv];rfl
  have ho : (1 : Word)≠0 := by decide
  have hf := ProducerDataFlags020E9.push_flag d hp
  by_cases h : d.core.frames.sp.val<28941
  · let p : WordPatch020E5.Write 143922 := (framePointer (cap:=877) (capacity:=28941) ⟨d.core.frames.sp.val,h⟩ j,BankStorage020E3.frameWords v j)
    apply some_word d fresh j f p
    · simp only [writes,hp,hv,pushWrites,dite_eq_left h,frameWrites,List.getElem?_ofFn,dite_eq_left j.isLt]
      rfl
    · rw [ProducerDataFlags020E9.push_present d hp,hf,ht,ite_eq_right ho,ite_eq_left h]
    · exact ProducerDataAddress020E9.push_address d hp h j
    · exact ProducerDataValue020E9.push_two d hp u v hv j
  · apply none_word d fresh j f
    · simp only [writes,hp,hv,pushWrites,dite_eq_right h,List.getElem?_nil]
    · rw [ProducerDataFlags020E9.push_present d hp,hf,ht,ite_eq_right ho,ite_eq_right h]

theorem data (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.push) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (ProducerDataLayout020E9.encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  cases hv : d.core.pending with
  | none => exact none d fresh hp hv j f
  | one v => exact one d fresh hp v hv j f
  | two u v => exact two d fresh hp u v hv j f

end FT1536.S05.ProducerPushSlots020E9
