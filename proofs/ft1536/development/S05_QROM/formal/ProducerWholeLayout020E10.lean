import ProducerEditWrites020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerWholeLayout020E10
open WordRAM020 ArrayBank020E4 ProducerSlotLayout020E7 ProducerReferenceSlots020E8 ProducerReferenceData020E8 ProducerCoreRead020E6

def writes (d : Data) : List (WordPatch020E5.Write (CoreEncoding020E5.payloadWords 877 28941)) :=
  if d.core.phase=.act then match ProducerActSource020E10.result d with
    | none => [] | some r => ProducerEditWrites020E10.writes (cap:=877) (capacity:=28941) r.2
  else ProducerDataSpec020E9.writes d.parser.arena d.core

theorem length_bound (d : Data) : (writes d).length≤3 := by
  unfold writes
  split
  · split
    · simp
    · exact le_trans (ProducerEditWrites020E10.length_bound (cap:=877) (capacity:=28941) _) (by decide)
  · exact ProducerDataSpec020E9.length_bound _ _

theorem data_effect (d : Data) :
    WordPatch020E5.apply (writes d) (CoreFieldPatch020E5.image hc hf hl d.core)=
      CoreFieldPatch020E5.image hc hf hl (CoreData020E5.next d.parser.arena (input d) d.core) := by
  by_cases hp : d.core.phase=.act
  · rw [writes,ite_eq_left hp,ProducerActOutcome020E10.data_eq d hp]
    cases hr : ProducerActSource020E10.result d with
    | none => rfl
    | some r => exact ProducerEditWrites020E10.effect hc hf hl d.core r.2
  · rw [writes,ite_eq_right hp]
    exact ProducerDataSpec020E9.effect hc hf hl _ _ _ hp

def canonical (d : Data) : ScriptBuffer020E5.Buffer 143922 32 :=
  layout (writes d) (ControlStore020E5.code hc hf hl (CoreControl020E5.next d.parser.arena (input d) d.core))
def encoded (d : Data) : Bank Word 96 :=
  VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32) (canonical d)

theorem effect (d : Data) :
    ScriptBuffer020E5.execute (canonical d) (CoreFieldPatch020E5.image hc hf hl d.core)=
      CoreFieldPatch020E5.image hc hf hl (CoreStep020E5.step d.parser.arena (input d) d.core) := by
  let ys := ControlStore020E5.code hc hf hl (CoreControl020E5.next d.parser.arena (input d) d.core)
  have hy : ys.length≤16 := by unfold ys;rw [ControlStore020E5.length]
  apply (layout_effect (writes d) ys (length_bound d) hy (CoreFieldPatch020E5.image hc hf hl d.core)).trans
  rw [VerifiedPatch020E5.append_apply,data_effect]
  have hcontrol := ControlStore020E5.control_code hc hf hl (CoreData020E5.next d.parser.arena (input d) d.core)
    (CoreControl020E5.next d.parser.arena (input d) d.core)
  change _=ys at hcontrol
  rw [←hcontrol,(CoreFieldPatch020E5.control hc hf hl _ _).correct,CoreControl020E5.reconstruct]

theorem nonact (d : Data) (hp : d.core.phase≠CoreState020E5.Phase.act) : canonical d=ProducerDataLayout020E9.canonical d := by
  have hw : writes d=ProducerDataSpec020E9.writes d.parser.arena d.core := by rw [writes,ite_eq_right hp]
  exact congrArg (fun xs => layout xs (ControlStore020E5.code hc hf hl (CoreControl020E5.next d.parser.arena (input d) d.core))) hw

theorem data_word (d : Data) (j : Fin 3) (f : Fin 3) :
    read (encoded d) (finProdFinEquiv (dataSlot j,f))=
      (ScriptStore020E5.writeCodec 143922 (by norm_num)).encode ((writes d)[j.val]?) f := by
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

end FT1536.S05.ProducerWholeLayout020E10
