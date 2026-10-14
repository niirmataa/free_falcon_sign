import ProducerDataSpec020E9
import ProducerSlotExt020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerDataLayout020E9
open WordRAM020 ArrayBank020E4 ProducerSlotLayout020E7 ProducerReferenceSlots020E8 ProducerReferenceData020E8 ProducerCoreRead020E6

def canonical (d : Data) : ScriptBuffer020E5.Buffer 143922 32 :=
  layout (ProducerDataSpec020E9.writes d.parser.arena d.core)
    (ControlStore020E5.code hc hf hl (CoreControl020E5.next d.parser.arena (input d) d.core))
def encoded (d : Data) : Bank Word 96 :=
  VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32) (canonical d)

theorem effect (d : Data) (ha : d.core.phase≠CoreState020E5.Phase.act) :
    ScriptBuffer020E5.execute (canonical d) (CoreFieldPatch020E5.image hc hf hl d.core)=
      CoreFieldPatch020E5.image hc hf hl (CoreStep020E5.step d.parser.arena (input d) d.core) := by
  let xs := ProducerDataSpec020E9.writes d.parser.arena d.core
  let ys := ControlStore020E5.code hc hf hl (CoreControl020E5.next d.parser.arena (input d) d.core)
  have hx : xs.length≤3 := ProducerDataSpec020E9.length_bound _ _
  have hy : ys.length≤16 := by unfold ys;rw [ControlStore020E5.length]
  apply (layout_effect xs ys hx hy (CoreFieldPatch020E5.image hc hf hl d.core)).trans
  rw [VerifiedPatch020E5.append_apply]
  have hd := ProducerDataSpec020E9.effect hc hf hl d.parser.arena (input d) d.core ha
  change WordPatch020E5.apply xs _=_ at hd
  rw [hd]
  have hc' := ControlStore020E5.control_code hc hf hl (CoreData020E5.next d.parser.arena (input d) d.core)
    (CoreControl020E5.next d.parser.arena (input d) d.core)
  change _=ys at hc'
  rw [←hc',(CoreFieldPatch020E5.control hc hf hl _ _).correct,CoreControl020E5.reconstruct]

theorem data_word (d : Data) (j : Fin 3) (f : Fin 3) :
    read (encoded d) (finProdFinEquiv (dataSlot j,f))=
      (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode
        ((ProducerDataSpec020E9.writes d.parser.arena d.core)[j.val]?) f := by
  unfold encoded
  rw [ProducerWordLaws020E6.read_encoded_cell]
  unfold canonical layout dataSlot
  rw [join_left]
  simp only [ScriptBuffer020E5.buffer,read_load]
  rfl

theorem control_word (d : Data) (j : Fin 16) (f : Fin 3) :
    read (encoded d) (finProdFinEquiv (controlSlot j,f))=
      read (encodedReference d) (finProdFinEquiv (controlSlot j,f)) := by
  unfold encoded encodedReference
  rw [ProducerWordLaws020E6.read_encoded_cell,ProducerWordLaws020E6.read_encoded_cell]
  unfold canonical reference layout controlSlot
  simp only [join_right]

theorem padding_word (d : Data) (j : Fin 13) (f : Fin 3) :
    read (encoded d) (finProdFinEquiv (paddingSlot j,f))=
      read (encodedReference d) (finProdFinEquiv (paddingSlot j,f)) := by
  unfold encoded encodedReference
  rw [ProducerWordLaws020E6.read_encoded_cell,ProducerWordLaws020E6.read_encoded_cell]
  unfold canonical reference layout paddingSlot
  simp only [join_right]

end FT1536.S05.ProducerDataLayout020E9
