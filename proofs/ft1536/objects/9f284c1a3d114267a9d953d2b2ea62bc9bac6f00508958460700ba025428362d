import Source3.StableBinarySourceProof

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryTotality
open FT1536.Source3
open FT1536.Source3.StableBinaryByteView

/- No callee-domain filter at a leaf: the actual parsed RMW/fallback helper
   terminates on every 64-bit input and every initialized bad flag. -/
theorem positive_total (l : StableBinary.Layout)
    (source : StableBinaryCExec.State) (w : BitVec 64) (old : BitVec 32)
    (hb : flagRead source.heap l.bad=some old)
    (legal : FlagWritable source.heap l.bad) :
    StableBinaryCExec.positive l source w =
      some (Run2.KeygenLeafGate.stableWord w,
        {heap := flagStored source.heap l.bad (Run2.KeygenLeafGate.stableBad w old),
         checks := w::source.checks}) := by
  let flags : CRefWord.Heap := fun a => if a=l.bad then some old else none
  have hp : flags l.bad=some old := by simp [flags]
  have hsrc := StablePositive.source_refines w old flags l.bad hp
  unfold StableBinaryCExec.positive
  rw [hb]
  change ((CRefWord.parse (KeygenHelpers.slice 7477 12)).bind
      (fun f => CRefWord.execute StablePositive.pureCalls StablePositive.globals
        f flags [.word (.u64 w),.ref32 l.bad])).bind
      (fun pair => do
        let newFlag ← pair.2 l.bad
        let heap ← flagWrite source.heap l.bad newFlag
        match pair.1 with
        | .u64 z => pure (z,({heap,checks := w::source.checks} : StableBinaryCExec.State))
        | _ => none) = _
  rw [hsrc]
  simp [CRefWord.store_read,flagWrite,legal]

theorem base_total (l : StableBinary.Layout) (before : B20.C.Byte.Memory)
    (hl : l.wellFormed 0) (legal : Legal l before) :
    (StableBinaryCExec.run l 0 before).isSome := by
  have hzero : 0<l.length := by rw [hl.1]; decide
  have hreadLegal : B20.C.Byte.ReadRegion before (ptr l.values) := by
    simpa [StableBinary.addr] using legal.valuesReadable 0 hzero
  let word := B20.Word.LE.join (B20.Word.LE.bufferBytes before (ptr l.values))
  have hread : StableBinaryCExec.load {heap := before} l.values=some word := by
    simp [StableBinaryCExec.load,wordRead,hreadLegal,word]
  obtain ⟨old,hbad⟩ := Option.isSome_iff_exists.mp legal.badReadable
  let initial : StableBinaryCExec.State := {heap := before}
  let afterPositive : StableBinaryCExec.State :=
    {heap := flagStored before l.bad (Run2.KeygenLeafGate.stableBad word old),
      checks := [word]}
  have hpos : StableBinaryCExec.positive l initial word=
      some (Run2.KeygenLeafGate.stableWord word,afterPositive) := by
    simpa [initial,afterPositive] using
      positive_total l initial word old hbad legal.badWritable
  have hw : OwnedWriteRegion afterPositive.heap (ptr l.values) := by
    have hv := legal.valuesWritable 0 hzero
    simpa [afterPositive,OwnedWriteRegion,
      (flag_write_preserves_shape before l.bad (Run2.KeygenLeafGate.stableBad word old)).1,
      (flag_write_preserves_shape before l.bad (Run2.KeygenLeafGate.stableBad word old)).2,
      StableBinary.addr] using hv
  have hstore : (StableBinaryCExec.store afterPositive l.values
      (Run2.KeygenLeafGate.stableWord word)).isSome := by
    simp [StableBinaryCExec.store,wordWrite,hw]
  simp [StableBinaryCExec.run,hl,StableBinarySourceSyntax.pinned_source,
    StableBinaryCExec.execute,StableBinarySourceSyntax.expected,hread,hpos,hstore,
    initial]

end FT1536.Source3.StableBinaryTotality

#print axioms FT1536.Source3.StableBinaryTotality.positive_total
#print axioms FT1536.Source3.StableBinaryTotality.base_total
