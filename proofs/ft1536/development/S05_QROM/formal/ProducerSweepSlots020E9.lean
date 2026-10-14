import ProducerDataSlots020E9
import ProducerDataAddress020E9
import ProducerDataValue020E9

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerSweepSlots020E9
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerReference020E7 ProducerReferenceData020E8
open ProducerCoreSlots020E6 ProducerDataSpec020E9 ProducerDataList020E8 ProducerDataSlots020E9

theorem clear (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.clear) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (ProducerDataLayout020E9.encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  have hf := ProducerDataFlags020E9.sweep_present d (Or.inl hp) j.val
  by_cases h : d.core.cursor.val<877
  · by_cases hj : j.val<2
    · let k : Fin 2 := ⟨j.val,hj⟩
      let p : WordPatch020E5.Write 143922 := (valuePointer (cap:=877) (capacity:=28941) ⟨d.core.cursor.val,h⟩ k,BankStorage020E3.valueWords none k)
      apply some_word d fresh j f p
      · simp only [writes,hp,dite_eq_left h,valueWrites,List.getElem?_ofFn,dite_eq_left hj]
        rfl
      · simpa only [h,hj,and_self,ite_true] using hf
      · exact ProducerDataAddress020E9.sweep_address d (Or.inl hp) h k
      · exact ProducerDataValue020E9.clear d hp h k
    · apply none_word d fresh j f
      · simp only [writes,hp,dite_eq_left h,valueWrites,List.getElem?_ofFn,dite_eq_right hj]
      · simpa only [h,hj,and_false,ite_false] using hf
  · apply none_word d fresh j f
    · simp only [writes,hp,dite_eq_right h,List.getElem?_nil]
    · simpa only [h,false_and,ite_false] using hf

theorem scan (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.scan) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (ProducerDataLayout020E9.encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  have hf := ProducerDataFlags020E9.sweep_present d (Or.inr hp) j.val
  by_cases h : d.core.cursor.val<877
  · by_cases hj : j.val<2
    · let k : Fin 2 := ⟨j.val,hj⟩
      let v := ArrayValues020E4.entry d.parser.arena d.core.state d.core.values ⟨d.core.cursor.val,h⟩
      let p : WordPatch020E5.Write 143922 := (valuePointer (cap:=877) (capacity:=28941) ⟨d.core.cursor.val,h⟩ k,BankStorage020E3.valueWords v k)
      apply some_word d fresh j f p
      · simp only [writes,hp,dite_eq_left h,valueWrites,List.getElem?_ofFn,dite_eq_left hj]
        rfl
      · simpa only [h,hj,and_self,ite_true] using hf
      · exact ProducerDataAddress020E9.sweep_address d (Or.inr hp) h k
      · exact ProducerDataValue020E9.scan d hp h k
    · apply none_word d fresh j f
      · simp only [writes,hp,dite_eq_left h,valueWrites,List.getElem?_ofFn,dite_eq_right hj]
      · simpa only [h,hj,and_false,ite_false] using hf
  · apply none_word d fresh j f
    · simp only [writes,hp,dite_eq_right h,List.getElem?_nil]
    · simpa only [h,false_and,ite_false] using hf

end FT1536.S05.ProducerSweepSlots020E9
