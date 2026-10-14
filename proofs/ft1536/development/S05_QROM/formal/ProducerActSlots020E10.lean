import ProducerActWriteFields020E10
import ProducerWholeLayout020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActSlots020E10
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerReference020E7 ProducerReferenceData020E8
open ProducerCoreSlots020E6 ProducerActSource020E10 ProducerWholeLayout020E10

theorem none_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 3) (f : Fin 3)
    (hw : (writes d)[j.val]?=none) (hp : eval (env d) (dataPresent j.val)=0) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  have hc := congrArg (fun o : Option (WordPatch020E5.Write 143922) =>
    (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode o f) hw
  have hz : (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode none f=0 := by fin_cases f <;> rfl
  exact (ProducerDataSlots020E9.inactive d fresh j f hp).trans ((data_word d j f).trans (hc.trans hz)).symm

theorem some_word (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 3) (f : Fin 3)
    (p : WordPatch020E5.Write 143922) (hw : (writes d)[j.val]?=some p)
    (hp : eval (env d) (dataPresent j.val)=1)
    (ha : eval (env d) (dataAddress j.val)=word p.1.val) (hv : eval (env d) (dataValue j.val)=p.2) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  have hc := congrArg (fun o : Option (WordPatch020E5.Write 143922) =>
    (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode o f) hw
  exact (ProducerDataSlots020E9.active d fresh j f p hp ha hv).trans ((data_word d j f).trans hc).symm

theorem rejected (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.act)
    (hr : result d=none) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  apply none_word d fresh j f
  · simp only [writes,hp,ite_true,hr,List.getElem?_nil]
  · exact ProducerActStoreFields020E10.flag_zero d hp (ProducerActStoreFields020E10.rejected d hp hr) j.val

theorem accepted (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.act)
    (p : FixedAction020E5.Pending 877) (e : MemoryEdit020E5.Edit) (hr : result d=some (p,e)) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  have hl : writes d=(ProducerActWriteFields020E10.record e).toList := by
    simp only [writes,hp,ite_true,hr]
    exact ProducerActWriteFields020E10.list_record e
  have hc := ProducerActWriteFields020E10.correct d hp p e hr
  cases he : ProducerActWriteFields020E10.record e with
  | none =>
    rw [he] at hc
    apply none_word d fresh j f
    · rw [hl,he];rfl
    · exact ProducerActStoreFields020E10.flag_zero d hp hc j.val
  | some w =>
    rw [he] at hc
    fin_cases j
    · apply some_word d fresh 0 f w
      · rw [hl,he];rfl
      · exact (ProducerActStoreFields020E10.flag_one d hp hc.1 0).trans (by rfl)
      · exact hc.2.1
      · exact hc.2.2
    · apply none_word d fresh 1 f
      · rw [hl,he];rfl
      · exact (ProducerActStoreFields020E10.flag_one d hp hc.1 1).trans (by rfl)
    · apply none_word d fresh 2 f
      · rw [hl,he];rfl
      · exact (ProducerActStoreFields020E10.flag_one d hp hc.1 2).trans (by rfl)

theorem correct (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.act) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  cases hr : result d with
  | none => exact rejected d fresh hp hr j f
  | some r => exact accepted d fresh hp r.1 r.2 hr j f

end FT1536.S05.ProducerActSlots020E10
