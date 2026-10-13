import ProducerPassiveSlots020E8
import ProducerSlotExt020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerPassive020E8
open WordRAM020 ArrayBank020E4 ProducerPassiveSlots020E8 ProducerSlotLayout020E7 ProducerCoreRead020E6

theorem executed (d : Data) (fresh : Bool) (h : Passive d) :
    ProducerStored020E6.run d fresh=encodedReference d := by
  have hn : d.core.phase≠CoreState020E5.Phase.act := by rcases h with hp|hp|hp <;> rw [hp] <;> decide
  exact ProducerSlotExt020E8.slots _ _ (data d fresh h) (ProducerOutputSlots020E8.control d fresh hn)
    (ProducerOutputSlots020E8.padding d fresh)

/-- The exact E7 equality is discharged for check/done/bad, not for the
    whole machine. These are genuine cases of the original universal goal. -/
theorem reference_equality (d : Data) (h : Passive d) : RemainingEquality d :=
  (ProducerReference020E7.stored_output d false).symm.trans (executed d false h)

/-- A concrete witness, with the output of the actual installed code as its
    word image and the old CoreStep as its effect. The witness is proof-only;
    no extra runtime decoder/allocation or full resource claim is introduced. -/
theorem script (d : Data) (fresh : Bool) (h : Passive d) :
    ∃ b : ScriptBuffer020E5.Buffer 143922 32,
      VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by decide)) 32) b=
        ProducerStored020E6.run d fresh ∧
      ScriptBuffer020E5.execute b (CoreFieldPatch020E5.image hc hf hl d.core)=
        CoreFieldPatch020E5.image hc hf hl (CoreStep020E5.step d.parser.arena (input d) d.core) := by
  exact ⟨reference d,(executed d fresh h).symm,reference_effect d⟩

end FT1536.S05.ProducerPassive020E8
