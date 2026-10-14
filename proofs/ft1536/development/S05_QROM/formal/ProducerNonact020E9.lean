import ProducerSweepSlots020E9
import ProducerPushSlots020E9
import ProducerPassiveSlots020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerNonact020E9
open WordRAM020 ArrayBank020E4 ProducerReferenceData020E8 ProducerReferenceSlots020E8 ProducerCoreRead020E6
open ProducerSlotLayout020E7 ProducerDataLayout020E9

theorem passive_data (d : Data) (fresh : Bool) (hp : ProducerPassiveSlots020E8.Passive d) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  apply ProducerDataSlots020E9.none_word d fresh j f
  · rcases hp with hp|hp|hp <;> simp only [ProducerDataSpec020E9.writes,hp,List.getElem?_nil]
  · exact ProducerPassiveSlots020E8.flag d hp j.val

/-- All data slots in every non-dispatch phase, without reachability premises. -/
theorem data (d : Data) (fresh : Bool) (ha : d.core.phase≠CoreState020E5.Phase.act) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=
      read (encoded d) (finProdFinEquiv (dataSlot j,f)) := by
  cases hp : d.core.phase with
  | check => exact passive_data d fresh (Or.inl hp) j f
  | clear => exact ProducerSweepSlots020E9.clear d fresh hp j f
  | scan => exact ProducerSweepSlots020E9.scan d fresh hp j f
  | act => exact (ha hp).elim
  | push => exact ProducerPushSlots020E9.data d fresh hp j f
  | done => exact passive_data d fresh (Or.inr (Or.inl hp)) j f
  | bad => exact passive_data d fresh (Or.inr (Or.inr hp)) j f

/-- The installed producer emits the complete encoding of the canonical buffer. -/
theorem executed (d : Data) (fresh : Bool) (ha : d.core.phase≠CoreState020E5.Phase.act) :
    ProducerStored020E6.run d fresh=encoded d := by
  apply ProducerSlotExt020E8.slots
  · exact data d fresh ha
  · intro j f
    exact (ProducerOutputSlots020E8.control d fresh ha j f).trans (ProducerDataLayout020E9.control_word d j f).symm
  · intro j f
    exact (ProducerOutputSlots020E8.padding d fresh j f).trans (ProducerDataLayout020E9.padding_word d j f).symm

/-- A constructed witness, not an assumed equality and not a replacement runtime. -/
theorem script (d : Data) (fresh : Bool) (ha : d.core.phase≠CoreState020E5.Phase.act) :
    ∃ b : ScriptBuffer020E5.Buffer 143922 32,
      VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32) b=ProducerStored020E6.run d fresh ∧
      ScriptBuffer020E5.execute b (CoreFieldPatch020E5.image hc hf hl d.core)=
        CoreFieldPatch020E5.image hc hf hl (CoreStep020E5.step d.parser.arena (input d) d.core) :=
  ⟨canonical d,(executed d fresh ha).symm,effect d ha⟩

/-- Equality of effects with the original proof-generated reference. No raw
    equality of the two lists or their encoded banks is asserted. -/
theorem reference_effect (d : Data) (ha : d.core.phase≠CoreState020E5.Phase.act) :
    ScriptBuffer020E5.execute (canonical d) (CoreFieldPatch020E5.image hc hf hl d.core)=
      ScriptBuffer020E5.execute (reference d) (CoreFieldPatch020E5.image hc hf hl d.core) :=
  (effect d ha).trans (ProducerSlotLayout020E7.reference_effect d).symm

end FT1536.S05.ProducerNonact020E9
