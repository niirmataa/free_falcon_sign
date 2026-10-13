import ProducerControlNonact020E8
import ProducerControlList020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerReferenceSlots020E8
open WordRAM020 ArrayBank020E4 ProducerSlotLayout020E7 ProducerCoreRead020E6 CoreEncoding020E5

theorem join_left {A : Type} {n m : Nat} (a : Bank A n) (b : Bank A m) (j : Fin n) :
    read (join a b) (Fin.castAdd m j)=read a j := by
  rw [join,read_load]
  exact Fin.addCases_left j

theorem join_right {A : Type} {n m : Nat} (a : Bank A n) (b : Bank A m) (j : Fin m) :
    read (join a b) (Fin.natAdd n j)=read b j := by
  rw [join,read_load]
  exact Fin.addCases_right j

def controlSlot (j : Fin 16) : Fin 32 := Fin.natAdd 3 (Fin.castAdd 13 j)
def paddingSlot (j : Fin 13) : Fin 32 := Fin.natAdd 3 (Fin.natAdd 16 j)

theorem control_list (m : Meta 877 28941 1106642201817) :
    ControlStore020E5.code hc hf hl m=List.ofFn (fun j : Fin 16 => (metaPtr j,(metaCodec 877 28941 1106642201817 hc hf hl).encode m j)) := by
  exact ProducerControlList020E8.code hc hf hl m

theorem control_read (d : Data) (j : Fin 16) :
    read (reference d) (controlSlot j)=some (metaPtr j,
      (metaCodec 877 28941 1106642201817 hc hf hl).encode (CoreControl020E5.next d.parser.arena (input d) d.core) j) := by
  unfold reference layout controlSlot
  rw [join_right,join_left]
  simp only [ScriptBuffer020E5.buffer,read_load,control_list,List.getElem?_ofFn,dite_eq_left j.isLt]

theorem padding_read (d : Data) (j : Fin 13) : read (reference d) (paddingSlot j)=none := by
  unfold reference layout paddingSlot
  rw [join_right,join_right]
  simp [ScriptBuffer020E5.buffer,read_load]

theorem control_word (d : Data) (j : Fin 16) (f : Fin 3) :
    read (encodedReference d) (finProdFinEquiv (controlSlot j,f))=
      (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode
        (some (metaPtr j,(metaCodec 877 28941 1106642201817 hc hf hl).encode
          (CoreControl020E5.next d.parser.arena (input d) d.core) j)) f := by
  unfold encodedReference
  rw [ProducerWordLaws020E6.read_encoded_cell,control_read]

theorem padding_word (d : Data) (j : Fin 13) (f : Fin 3) :
    read (encodedReference d) (finProdFinEquiv (paddingSlot j,f))=0 := by
  unfold encodedReference
  rw [ProducerWordLaws020E6.read_encoded_cell,padding_read]
  fin_cases f <;> rfl

end FT1536.S05.ProducerReferenceSlots020E8
