import ProducerDataCases020E8
import ProducerReferenceSlots020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerReferenceData020E8
open WordRAM020 ArrayBank020E4 ProducerCoreRead020E6 ProducerSlotLayout020E7 ProducerReferenceSlots020E8

def dataSlot (j : Fin 3) : Fin 32 := Fin.castAdd 29 j

theorem data_read (d : Data) (j : Fin 3) :
    read (reference d) (dataSlot j)=(ProducerDataCases020E8.code hc hf hl d.parser.arena (input d) d.core)[j.val]? := by
  unfold reference layout dataSlot
  rw [join_left]
  simp only [ScriptBuffer020E5.buffer,read_load]
  rfl

theorem empty_word (d : Data)
    (he : ProducerDataCases020E8.code hc hf hl d.parser.arena (input d) d.core=[])
    (j : Fin 3) (f : Fin 3) :
    read (encodedReference d) (finProdFinEquiv (dataSlot j,f))=0 := by
  unfold encodedReference
  rw [ProducerWordLaws020E6.read_encoded_cell,data_read,he,List.getElem?_nil]
  fin_cases f <;> rfl

end FT1536.S05.ProducerReferenceData020E8
