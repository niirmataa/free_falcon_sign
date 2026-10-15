import PublicStartupEval020E12

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicStartup020E12
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerEval020E7 PublicStartupProducer020E12 PublicStartupEval020E12
open ProducerReferenceSlots020E8 ProducerReferenceData020E8 PublicStartupSpec020E12

theorem data_output (root : Root) (j : Fin 3) (f : Fin 3) :
    read (PublicStartupProducer020E12.run root) (finProdFinEquiv (dataSlot j,f))=
      read (encoded root) (finProdFinEquiv (dataSlot j,f)) := by
  apply (produced root _).trans
  rw [data_expression,PublicStartupSpec020E12.data_word]
  fin_cases f
  · rfl
  · change word ((55329+j.val : Nat) : Int)=word (ProducerDataList020E8.framePointer (cap:=877) (capacity:=28941) 0 j).val
    apply congrArg (fun k : Nat => word k)
    rw [ProducerDataAddress020E9.frame_pointer]
    rfl
  · change eval (source root) (dataValue j.val)=BankStorage020E3.frameWords (.run root) j
    fin_cases j
    · rfl
    · exact root_read root
    · rfl

theorem control_output (root : Root) (j : Fin 16) (f : Fin 3) :
    read (PublicStartupProducer020E12.run root) (finProdFinEquiv (controlSlot j,f))=
      read (encoded root) (finProdFinEquiv (controlSlot j,f)) := by
  apply (produced root _).trans
  rw [control_expression,PublicStartupSpec020E12.control_word]
  fin_cases f
  · rfl
  · change word ((143906+j.val : Nat) : Int)=word (ProducerCoreRead020E6.metaPtr j).val
    exact congrArg (fun k : Nat => word k) (ProducerCoreRead020E6.metaPtr_val j).symm
  · change word ((if j.val=2 then 1106642201817 else if j.val=3 then 1 else 0 : Nat) : Int)=_
    have h := (PublicStartupSpec020E12.control_value j).symm
    by_cases h2 : j.val=2 <;> by_cases h3 : j.val=3
    all_goals simp only [h2,h3,ite_true,ite_false] at h ⊢
    all_goals exact h

theorem padding_output (root : Root) (j : Fin 13) (f : Fin 3) :
    read (PublicStartupProducer020E12.run root) (finProdFinEquiv (paddingSlot j,f))=
      read (encoded root) (finProdFinEquiv (paddingSlot j,f)) := by
  rw [produced,padding_expression,PublicStartupSpec020E12.padding_word]
  rfl

theorem output (root : Root) : PublicStartupProducer020E12.run root=encoded root :=
  ProducerSlotExt020E8.slots _ _ (data_output root) (control_output root) (padding_output root)

/-- Public reset and actual startup command output, consumed without a supplied
    typed Core or an external list of stores. -/
def start (root : Root) : Option ProducerRawCore020E11.Memory :=
  CommandConsumer020E11.consume (capacity:=32) (PublicMaterialize020E12.zeroed 143922) (PublicStartupProducer020E12.run root)

theorem correct (root : Root) :
    start root=some (ProducerRawCore020E11.image (CoreStartup020E5.ready (cap:=877) (capacity:=28941) (limit:=1106642201817) (by decide) root)) := by
  have hc := CommandConsumerRefinement020E11.consumes (n:=143922) (capacity:=32) (by norm_num) (zero 143922 (0 : Word)) (reference root)
  have hs : start root=CommandConsumer020E11.consume (capacity:=32) (zero 143922 (0 : Word)) (encoded root) := by
    rw [start,PublicMaterialize020E12.zeroed_eq,output]
  exact hs.trans (hc.trans (congrArg some (PublicStartupSpec020E12.effect root)))

end FT1536.S05.PublicStartup020E12
