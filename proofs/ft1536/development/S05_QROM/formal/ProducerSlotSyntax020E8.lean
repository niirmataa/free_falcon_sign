import ProducerReferenceSlots020E8

set_option maxRecDepth 8192
namespace FT1536.S05.ProducerSlotSyntax020E8
open WordRAM020 ProducerCoreCircuit020E6 ProducerReferenceSlots020E8 ProducerScalar020E6

theorem control_expression (j : Fin 16) (f : Fin 3) :
    ProducerCoreSlots020E6.cells (finProdFinEquiv (controlSlot j,f))=
      match f.val with | 0 => lit 1 | 1 => lit (143906+j.val) | _ => nextMeta j.val := by
  have hd : (finProdFinEquiv (controlSlot j,f)).val/3=3+j.val := by
    change (f.val+3*(3+j.val))/3=3+j.val
    have := f.isLt;omega
  have hm : (finProdFinEquiv (controlSlot j,f)).val%3=f.val := by
    change (f.val+3*(3+j.val))%3=f.val
    have := f.isLt;omega
  have ha : ¬3+j.val<3 := by omega
  have hb : 3+j.val<19 := by have := j.isLt;omega
  simp only [ProducerCoreSlots020E6.cells,hd,hm,ha,ite_false,hb,ite_true,Nat.add_sub_cancel_left]
  rfl

theorem padding_expression (j : Fin 13) (f : Fin 3) :
    ProducerCoreSlots020E6.cells (finProdFinEquiv (paddingSlot j,f))=lit 0 := by
  have hd : (finProdFinEquiv (paddingSlot j,f)).val/3=19+j.val := by
    change (f.val+3*(3+(16+j.val)))/3=19+j.val
    have := f.isLt;omega
  have ha : ¬19+j.val<3 := by omega
  have hb : ¬19+j.val<19 := by omega
  simp only [ProducerCoreSlots020E6.cells,hd,ha,ite_false,hb]

end FT1536.S05.ProducerSlotSyntax020E8
