import PublicMaterialize020E12

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicStartupSpec020E12
open WordRAM020 ArrayBank020E4 ProducerCoreRead020E6 ProducerSlotLayout020E7
open ProducerReferenceSlots020E8 ProducerReferenceData020E8

abbrev Root := ArenaTypes020E1.Ptr 877
def initialMeta : CoreEncoding020E5.Meta 877 28941 1106642201817 :=
  (.check,(0,(⟨1106642201817,by decide⟩,(⟨1,by decide⟩,(.none,false)))))
def data (root : Root) := ProducerDataSpec020E9.frameWrites (cap:=877) (capacity:=28941) (0 : Fin 28941) (.run root)
def controls := ControlStore020E5.code hc hf hl initialMeta
def reference (root : Root) : ScriptBuffer020E5.Buffer 143922 32 := layout (data root) controls
def encoded (root : Root) : Bank Word 96 :=
  VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32) (reference root)

theorem program_code (root : Root) :
    (CoreStartup020E5.program hc hf hl (by decide) root).code=data root++controls := by
  simp only [CoreStartup020E5.program,VerifiedPatch020E5.thenDo]
  rw [ProducerDataList020E8.frames_code,ControlStore020E5.control_code]
  rfl

theorem effect (root : Root) :
    ScriptBuffer020E5.execute (reference root) (zero 143922 (0 : Word))=
      ProducerRawCore020E11.image (CoreStartup020E5.ready (cap:=877) (capacity:=28941) (limit:=1106642201817) (by decide) root) := by
  have hx : (data root).length≤3 := by simp [data,ProducerDataSpec020E9.frameWrites]
  have hy : controls.length≤16 := by rw [controls,ControlStore020E5.length]
  apply (layout_effect (data root) controls hx hy _).trans
  have h := (CoreStartup020E5.program hc hf hl (by decide) root).correct
  rw [program_code] at h
  have hz : CoreFieldPatch020E5.image hc hf hl (CoreStartup020E5.blank 877 28941 1106642201817)=zero 143922 (0 : Word) := StartupImage020E5.core_zero _ _ _ hc hf hl
  rw [hz] at h
  exact h

theorem data_word (root : Root) (j : Fin 3) (f : Fin 3) :
    read (encoded root) (finProdFinEquiv (dataSlot j,f))=
      (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode
        (some (ProducerDataList020E8.framePointer (cap:=877) (capacity:=28941) 0 j,BankStorage020E3.frameWords (.run root) j)) f := by
  have hd : read (reference root) (dataSlot j)=some (ProducerDataList020E8.framePointer (cap:=877) (capacity:=28941) 0 j,BankStorage020E3.frameWords (.run root) j) := by
    unfold reference layout dataSlot
    rw [join_left]
    fin_cases j <;> rfl
  apply (ProducerWordLaws020E6.read_encoded_cell (ScriptStore020E5.writeCodec 143922 (by norm_num)) (reference root) (dataSlot j) f).trans
  rw [hd]
  rfl

theorem control_word (root : Root) (j : Fin 16) (f : Fin 3) :
    read (encoded root) (finProdFinEquiv (controlSlot j,f))=
      (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode
        (some (metaPtr j,(CoreEncoding020E5.metaCodec 877 28941 1106642201817 hc hf hl).encode initialMeta j)) f := by
  unfold encoded
  rw [ProducerWordLaws020E6.read_encoded_cell]
  unfold reference layout controlSlot
  rw [join_right,join_left]
  simp only [ScriptBuffer020E5.buffer,read_load,controls,ProducerReferenceSlots020E8.control_list,List.getElem?_ofFn,dite_eq_left j.isLt]

theorem padding_word (root : Root) (j : Fin 13) (f : Fin 3) :
    read (encoded root) (finProdFinEquiv (paddingSlot j,f))=0 := by
  unfold encoded
  rw [ProducerWordLaws020E6.read_encoded_cell]
  unfold reference layout paddingSlot
  rw [join_right,join_right]
  simp only [ScriptBuffer020E5.buffer,read_load,List.getElem?_nil]
  fin_cases f <;> rfl

theorem control_value (j : Fin 16) :
    (CoreEncoding020E5.metaCodec 877 28941 1106642201817 hc hf hl).encode initialMeta j=
      word (if j.val=2 then 1106642201817 else if j.val=3 then 1 else 0) := by
  fin_cases j <;> rfl

end FT1536.S05.PublicStartupSpec020E12
