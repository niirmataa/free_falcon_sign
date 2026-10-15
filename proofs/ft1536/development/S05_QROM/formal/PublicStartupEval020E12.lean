import PublicStartupProducer020E12

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicStartupEval020E12
open WordRAM020 ArrayBank020E4 ProducerScalar020E6 ProducerExpr020E6 ProducerEval020E7
open ProducerReferenceSlots020E8 ProducerReferenceData020E8 PublicStartupSpec020E12 PublicStartupProducer020E12
attribute [local irreducible] ProducerStored020E6.invoke ProducerProgram020E6.code PublicMaterialize020E12.materialize VerifiedPatch020E5.pack

theorem output_aux {extent : Fin 1 → Nat} (s : ProducerMachine020E6.Sources extent) :
    (ProducerStored020E6.invoke s code).vm.output=load (fun j => eval s (cells j)) :=
  ProducerStored020E6.expression_output s cells workspace

theorem output_function : PublicStartupProducer020E12.run=
    (fun root : Root => ArrayBank020E4.load (fun j => eval (source root) (cells j))) :=
  (funext (fun root : Root => output_aux (source root)) :
    (fun root : Root => (ProducerStored020E6.invoke (source root) code).vm.output)=
      (fun root : Root => ArrayBank020E4.load (fun j => eval (source root) (cells j))))

theorem output (root : Root) : PublicStartupProducer020E12.run root=ArrayBank020E4.load (fun j => eval (source root) (cells j)) :=
  congrFun output_function root

theorem root_read (root : Root) : eval (source root) (cell 0 0)=word root.val := by
  change ProducerExpr020E6.readWord (source root) 0 (word 0)=_
  have h := ProducerWordLaws020E6.load_nat (source root) 0 (by norm_num) (0 : Fin 1)
  apply h.trans
  change read (PublicMaterialize020E12.materialize (WordCodec020E5.finCodec 878 (by norm_num)) root) 0=_
  rw [PublicMaterialize020E12.materialize_eq,VerifiedPatch020E5.pack_read]
  rfl


theorem produced (root : Root) (j : Fin 96) : read (PublicStartupProducer020E12.run root) j=eval (source root) (cells j) :=
  (congrArg (fun a : Bank Word 96 => read a j) (output root)).trans (congrFun (read_load _) j)

theorem data_expression (j : Fin 3) (f : Fin 3) :
    cells (finProdFinEquiv (dataSlot j,f))=match f.val with | 0 => lit 1 | 1 => lit (55329+j.val) | _ => dataValue j.val := by
  have hd : (finProdFinEquiv (dataSlot j,f)).val/3=j.val := by
    change (f.val+3*j.val)/3=j.val;have := f.isLt;omega
  have hm : (finProdFinEquiv (dataSlot j,f)).val%3=f.val := by
    change (f.val+3*j.val)%3=f.val;have := f.isLt;omega
  simp only [cells,hd,hm,ite_eq_left j.isLt]
  rfl

theorem control_expression (j : Fin 16) (f : Fin 3) :
    cells (finProdFinEquiv (controlSlot j,f))=match f.val with | 0 => lit 1 | 1 => lit (143906+j.val) | _ => controlValue j.val := by
  have hd : (finProdFinEquiv (controlSlot j,f)).val/3=3+j.val := by
    change (f.val+3*(3+j.val))/3=3+j.val;have := f.isLt;omega
  have hm : (finProdFinEquiv (controlSlot j,f)).val%3=f.val := by
    change (f.val+3*(3+j.val))%3=f.val;have := f.isLt;omega
  have h0 : ¬3+j.val<3 := by omega
  have h1 : 3+j.val<19 := by have := j.isLt;omega
  simp only [cells,hd,hm,h0,h1,ite_true,ite_false,Nat.add_sub_cancel_left]
  rfl

theorem padding_expression (j : Fin 13) (f : Fin 3) : cells (finProdFinEquiv (paddingSlot j,f))=lit 0 := by
  have hd : (finProdFinEquiv (paddingSlot j,f)).val/3=19+j.val := by
    change (f.val+3*(3+(16+j.val)))/3=19+j.val;have := f.isLt;omega
  have h0 : ¬19+j.val<3 := by omega
  have h1 : ¬19+j.val<19 := by omega
  simp only [cells,hd,h0,h1,ite_false]

end FT1536.S05.PublicStartupEval020E12
