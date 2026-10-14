import ProducerNonact020E9

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerNonactConsumer020E9
open WordRAM020 ArrayBank020E4 ProducerSlotLayout020E7 ProducerDataLayout020E9 ProducerCoreRead020E6

theorem pack_injective {A : Type} {n : Nat} (c : WordCodec020E5.Codec A n) :
    Function.Injective (VerifiedPatch020E5.pack c) := by
  intro a b h
  apply c.injective
  have hr := congrArg (@read Word n) h
  simpa only [VerifiedPatch020E5.pack,read_load] using hr

/-- Every buffer with the actual output encoding is the constructed canonical
    buffer. This is semantic uniqueness, not an executable decoder. -/
theorem unique (d : Data) (fresh : Bool) (ha : d.core.phase≠CoreState020E5.Phase.act)
    (b : ScriptBuffer020E5.Buffer 143922 32)
    (hb : VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32) b=
      ProducerStored020E6.run d fresh) : b=canonical d :=
  pack_injective _ (hb.trans (ProducerNonact020E9.executed d fresh ha))

/-- An arbitrary correctly decoded actual output has the old-step effect. The
    encoding premise identifies the input buffer; correctness is proved above. -/
theorem execute (d : Data) (fresh : Bool) (ha : d.core.phase≠CoreState020E5.Phase.act)
    (b : ScriptBuffer020E5.Buffer 143922 32)
    (hb : VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32) b=
      ProducerStored020E6.run d fresh) :
    ScriptBuffer020E5.execute b (CoreFieldPatch020E5.image hc hf hl d.core)=
      CoreFieldPatch020E5.image hc hf hl (CoreStep020E5.step d.parser.arena (input d) d.core) := by
  rw [unique d fresh ha b hb]
  exact effect d ha

end FT1536.S05.ProducerNonactConsumer020E9
