import ProducerActOutput020E10
import ProducerActSlots020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerWholeStep020E10
open WordRAM020 ArrayBank020E4 ProducerSlotLayout020E7 ProducerCoreRead020E6

/-- Complete output of the installed core command producer, every typed state
    and both fresh values. No phase, reachability or success restriction. -/
theorem executed (d : Data) (fresh : Bool) : ProducerStored020E6.run d fresh=ProducerWholeLayout020E10.encoded d := by
  by_cases hp : d.core.phase=CoreState020E5.Phase.act
  · apply ProducerSlotExt020E8.slots
    · exact ProducerActSlots020E10.correct d fresh hp
    · intro j f
      exact (ProducerActOutput020E10.control d fresh hp j f).trans (ProducerWholeLayout020E10.control_word d j f).symm
    · intro j f
      exact (ProducerOutputSlots020E8.padding d fresh j f).trans (ProducerWholeLayout020E10.padding_word d j f).symm
  · have hc := ProducerWholeLayout020E10.nonact d hp
    have he : ProducerWholeLayout020E10.encoded d=ProducerDataLayout020E9.encoded d :=
      congrArg (VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32)) hc
    exact (ProducerNonact020E9.executed d fresh hp).trans he.symm

/-- The actual output encodes a constructed buffer whose execution is exactly
    the previous CoreStep. No assumed equality is supplied to this theorem. -/
theorem script (d : Data) (fresh : Bool) :
    ∃ b : ScriptBuffer020E5.Buffer 143922 32,
      VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32) b=ProducerStored020E6.run d fresh ∧
      ScriptBuffer020E5.execute b (CoreFieldPatch020E5.image hc hf hl d.core)=
        CoreFieldPatch020E5.image hc hf hl (CoreStep020E5.step d.parser.arena (input d) d.core) :=
  ⟨ProducerWholeLayout020E10.canonical d,(executed d fresh).symm,ProducerWholeLayout020E10.effect d⟩

theorem unique (d : Data) (fresh : Bool) (b : ScriptBuffer020E5.Buffer 143922 32)
    (hb : VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32) b=
      ProducerStored020E6.run d fresh) : b=ProducerWholeLayout020E10.canonical d :=
  ProducerNonactConsumer020E9.pack_injective _ (hb.trans (executed d fresh))

/-- Any buffer carrying the actual output has the old step's effect. -/
theorem execute (d : Data) (fresh : Bool) (b : ScriptBuffer020E5.Buffer 143922 32)
    (hb : VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32) b=
      ProducerStored020E6.run d fresh) :
    ScriptBuffer020E5.execute b (CoreFieldPatch020E5.image hc hf hl d.core)=
      CoreFieldPatch020E5.image hc hf hl (CoreStep020E5.step d.parser.arena (input d) d.core) := by
  rw [unique d fresh b hb]
  exact ProducerWholeLayout020E10.effect d

/-- Same effect as the original reference on the encoded state; not a claim
    that the original and canonical raw lists/banks are equal. -/
theorem reference_effect (d : Data) :
    ScriptBuffer020E5.execute (ProducerWholeLayout020E10.canonical d) (CoreFieldPatch020E5.image hc hf hl d.core)=
      ScriptBuffer020E5.execute (reference d) (CoreFieldPatch020E5.image hc hf hl d.core) :=
  (ProducerWholeLayout020E10.effect d).trans (ProducerSlotLayout020E7.reference_effect d).symm

end FT1536.S05.ProducerWholeStep020E10
