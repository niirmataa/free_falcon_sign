import Source3.StableBinaryCExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryBytePositive
open FT1536.Source3
open FT1536.Source3.StableBinaryByteView

theorem defined_positive_has_memory (l : StableBinary.Layout)
    (before after : StableBinaryCExec.State) (w z : BitVec 64)
    (h : StableBinaryCExec.positive l before w=some (z,after)) :
    ∃ old, flagRead before.heap l.bad=some old ∧
      FlagWritable before.heap l.bad := by
  cases hb : flagRead before.heap l.bad with
  | none => simp [StableBinaryCExec.positive,hb] at h
  | some old =>
      refine ⟨old,rfl,?_⟩
      by_contra hn
      simp [StableBinaryCExec.positive,hb,flagWrite,hn] at h

/- Bridge the actually parsed side-effecting positive C callee to four
   caller-owned bad bytes. No positive-word hypothesis is used: the callee
   itself performs the positive test and sticky OR. -/
theorem source_positive_bad_update (l : StableBinary.Layout)
    (before after : StableBinaryCExec.State) (w z : BitVec 64)
    (old : BitVec 32)
    (hb : flagRead before.heap l.bad=some old)
    (legal : FlagWritable before.heap l.bad)
    (hrun : StableBinaryCExec.positive l before w=some (z,after)) :
    z=Run2.KeygenLeafGate.stableWord w ∧
    after.checks=w::before.checks ∧
    after.heap=flagStored before.heap l.bad (Run2.KeygenLeafGate.stableBad w old) ∧
    flagRead after.heap l.bad=some (Run2.KeygenLeafGate.stableBad w old) := by
  let flags : CRefWord.Heap := fun a => if a=l.bad then some old else none
  have hp : flags l.bad=some old := by simp [flags]
  have hsrc := StablePositive.source_refines w old flags l.bad hp
  unfold StableBinaryCExec.positive at hrun
  rw [hb] at hrun
  change ((CRefWord.parse (KeygenHelpers.slice 7477 12)).bind
      (fun f => CRefWord.execute StablePositive.pureCalls StablePositive.globals
        f flags [.word (.u64 w),.ref32 l.bad])).bind
      (fun pair => do
        let newFlag ← pair.2 l.bad
        let heap ← flagWrite before.heap l.bad newFlag
        match pair.1 with
        | .u64 z => pure (z,{heap,checks := w::before.checks})
        | _ => none) = some (z,after) at hrun
  rw [hsrc] at hrun
  simp only [Option.bind_some,CRefWord.store_read] at hrun
  have hw : flagWrite before.heap l.bad (Run2.KeygenLeafGate.stableBad w old)=
      some (flagStored before.heap l.bad (Run2.KeygenLeafGate.stableBad w old)) := by
    simp [flagWrite,legal]
  have hpair :
      (Run2.KeygenLeafGate.stableWord w,
        ({heap := flagStored before.heap l.bad (Run2.KeygenLeafGate.stableBad w old),
          checks := w::before.checks} : StableBinaryCExec.State)) = (z,after) := by
    simpa [hw] using hrun
  have hz := congrArg Prod.fst hpair
  have hs := congrArg Prod.snd hpair
  refine ⟨hz.symm,?_,?_,?_⟩
  · exact (congrArg StableBinaryCExec.State.checks hs).symm
  · exact (congrArg StableBinaryCExec.State.heap hs).symm
  · rw [← congrArg StableBinaryCExec.State.heap hs]
    exact flag_stored_read before.heap l.bad _ legal

end FT1536.Source3.StableBinaryBytePositive

#check @FT1536.Source3.StableBinaryBytePositive.source_positive_bad_update
#print axioms FT1536.Source3.StableBinaryBytePositive.source_positive_bad_update
