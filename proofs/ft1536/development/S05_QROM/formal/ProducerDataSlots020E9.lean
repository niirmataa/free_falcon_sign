import ProducerDataLayout020E9
import ProducerOutputSlots020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerDataSlots020E9
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerReference020E7 ProducerReferenceData020E8
open ProducerCoreSlots020E6 ProducerScalar020E6 ProducerEval020E7

theorem expression (j : Fin 3) (f : Fin 3) :
    cells (finProdFinEquiv (dataSlot j,f))=
      choose (dataPresent j.val) (match f.val with | 0 => lit 1 | 1 => dataAddress j.val | _ => dataValue j.val) (lit 0) := by
  have hd : (finProdFinEquiv (dataSlot j,f)).val/3=j.val := by
    change (f.val+3*j.val)/3=j.val
    have := f.isLt;omega
  have hm : (finProdFinEquiv (dataSlot j,f)).val%3=f.val := by
    change (f.val+3*j.val)%3=f.val
    have := f.isLt;omega
  simp only [cells,hd,hm,ite_eq_left j.isLt]
  rfl

theorem inactive (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 3) (f : Fin 3)
    (hp : eval (env d) (dataPresent j.val)=0) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=0 := by
  rw [ProducerOutputSlots020E8.produced,expression,choose_eval,hp]
  rfl

theorem active (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 3) (f : Fin 3)
    (p : WordPatch020E5.Write 143922) (hp : eval (env d) (dataPresent j.val)=1)
    (ha : eval (env d) (dataAddress j.val)=word p.1.val)
    (hv : eval (env d) (dataValue j.val)=p.2) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode (some p) f := by
  apply (ProducerOutputSlots020E8.produced d fresh _).trans
  rw [expression]
  have ho : (1 : Word)≠0 := by decide
  simp only [choose_eval,hp,ho,ite_false]
  fin_cases f
  · rfl
  · exact ha
  · exact hv

theorem none_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 3) (f : Fin 3)
    (hw : (ProducerDataSpec020E9.writes d.parser.arena d.core)[j.val]?=Option.none)
    (hp : eval (env d) (dataPresent j.val)=0) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (ProducerDataLayout020E9.encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  have hc := congrArg (fun o : Option (WordPatch020E5.Write 143922) =>
    (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode o f) hw
  have hz : (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode Option.none f=0 := by fin_cases f <;> rfl
  exact (inactive d fresh j f hp).trans ((ProducerDataLayout020E9.data_word d j f).trans (hc.trans hz)).symm

theorem some_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 3) (f : Fin 3)
    (p : WordPatch020E5.Write 143922) (hw : (ProducerDataSpec020E9.writes d.parser.arena d.core)[j.val]?=some p)
    (hp : eval (env d) (dataPresent j.val)=1)
    (ha : eval (env d) (dataAddress j.val)=word p.1.val)
    (hv : eval (env d) (dataValue j.val)=p.2) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (ProducerDataLayout020E9.encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  have hc := congrArg (fun o : Option (WordPatch020E5.Write 143922) =>
    (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode o f) hw
  exact (active d fresh j f p hp ha hv).trans ((ProducerDataLayout020E9.data_word d j f).trans hc).symm

end FT1536.S05.ProducerDataSlots020E9
