import ProducerNonact020E9

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerDataBoundary020E9
open WordRAM020 ArrayBank020E4 ProducerReferenceData020E8 ProducerDataList020E8

/-- Clearing one cache entry emits two active zero stores, not absent slots. -/
theorem clear_zero (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.clear)
    (h : d.core.cursor.val<877) (j : Fin 2) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot (j.castLE (by decide)),f))=
      (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode
        (some (valuePointer (cap:=877) (capacity:=28941) ⟨d.core.cursor.val,h⟩ j,0)) f := by
  apply ProducerDataSlots020E9.active d fresh (j.castLE (by decide)) f
  · have hf := ProducerDataFlags020E9.sweep_present d (Or.inl hp) j.val
    change ProducerExpr020E6.eval (ProducerReference020E7.env d) (ProducerCoreSlots020E6.dataPresent j.val)=1
    simpa only [h,j.isLt,and_self,ite_true] using hf
  · exact ProducerDataAddress020E9.sweep_address d (Or.inl hp) h j
  · have hv := ProducerDataValue020E9.clear d hp h j
    exact hv.trans (by fin_cases j <;> rfl)

/-- An absent scan value still emits both active stores, clearing stale cache. -/
theorem scan_absent (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.scan)
    (h : d.core.cursor.val<877)
    (he : ArrayValues020E4.entry d.parser.arena d.core.state d.core.values ⟨d.core.cursor.val,h⟩=none)
    (j : Fin 2) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot (j.castLE (by decide)),f))=
      (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode
        (some (valuePointer (cap:=877) (capacity:=28941) ⟨d.core.cursor.val,h⟩ j,0)) f := by
  apply ProducerDataSlots020E9.active d fresh (j.castLE (by decide)) f
  · have hf := ProducerDataFlags020E9.sweep_present d (Or.inr hp) j.val
    change ProducerExpr020E6.eval (ProducerReference020E7.env d) (ProducerCoreSlots020E6.dataPresent j.val)=1
    simpa only [h,j.isLt,and_self,ite_true] using hf
  · exact ProducerDataAddress020E9.sweep_address d (Or.inr hp) h j
  · have hv := ProducerDataValue020E9.scan d hp h j
    rw [he] at hv
    exact hv.trans (by fin_cases j <;> rfl)

/-- The terminal cursor emits no data writes, for both sweep phases. -/
theorem sweep_terminal (d : BoundaryPayload020E5.Data) (fresh : Bool)
    (hp : d.core.phase=.clear ∨ d.core.phase=.scan) (h : d.core.cursor.val=877) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=0 := by
  apply ProducerDataSlots020E9.inactive
  rw [ProducerDataFlags020E9.sweep_present d hp,h]
  simp

/-- A full stack emits no data writes, for every pending value. -/
theorem push_full (d : BoundaryPayload020E5.Data) (fresh : Bool)
    (hp : d.core.phase=.push) (h : d.core.frames.sp.val=28941) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=0 := by
  apply ProducerDataSlots020E9.inactive
  rw [ProducerDataFlags020E9.push_present d hp,ProducerDataFlags020E9.push_flag d hp,h]
  simp

/-- No pending frame emits no data writes, including a full stack. -/
theorem push_empty (d : BoundaryPayload020E5.Data) (fresh : Bool)
    (hp : d.core.phase=.push) (h : d.core.pending=.none) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=0 := by
  apply ProducerDataSlots020E9.inactive
  rw [ProducerDataFlags020E9.push_present d hp,ProducerDataFlags020E9.push_flag d hp,h]
  rfl

end FT1536.S05.ProducerDataBoundary020E9
