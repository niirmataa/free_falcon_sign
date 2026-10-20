import Source3.StableBinaryRecursionRefinement

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryFinalBridge
open FT1536.Source3

/- Every defined execution of the complete, pinned, byte-addressed helper
   interpreter reaches the pre-existing typed model with the same values,
   scratch, bad and actual check inputs. The premises concern object legality
   only, including an initially UNINITIALIZED but writable scratch array. -/
theorem byte_interpreter_to_model (l : StableBinary.Layout) (k : Nat)
    (before : B20.C.Byte.Memory) (final : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : StableBinaryByteView.Legal l before)
    (hs : StableBinaryCExec.run l k before=some final) :
    ∃ typed : StableBinary.State l (StableBinaryByteView.view l before),
      StableBinary.run l StableBinaryFpr.boundOps k (StableBinaryByteView.view l before)=some typed ∧
      typed.memory=StableBinaryByteView.view l final.heap ∧
      typed.checks=final.checks := by
  let m := StableBinaryByteView.view l before
  have hm : m.initialized l := StableBinaryByteView.view_initialized l before legal
  obtain ⟨bad,hbad⟩ := Option.isSome_iff_exists.mp legal.badReadable
  have hb : m.flags l.bad=some bad := by simpa [m,StableBinaryByteView.view] using hbad
  let initial : StableBinary.State l m := {firstBad := bad,badInitially := hb}
  have rel0 := StableBinaryRelation.initial l before bad hb
  have hlen : l.length=2^k := hl.1
  have hsrc : StableBinaryCExec.execute l StableBinarySourceSyntax.expected k
      (StableBinary.addr l.values 0) {heap := before}=some final := by
    simpa [StableBinaryCExec.run,hl,StableBinarySourceSyntax.pinned_source,
      StableBinary.addr] using hs
  obtain ⟨typed,ht,rel⟩ :=
    StableBinaryRecursionRefinement.execute_refines l k m hl k 0
      {heap := before} final initial (by simp [hlen]) rel0 hsrc
  have hmodel : StableBinary.run l StableBinaryFpr.boundOps k m=some typed := by
    rw [← StableBinarySourceTyped.source_run_model]
    rw [StableBinarySourceTyped.source_run_reduces l k m bad hl hm hb]
    simpa [StableBinary.addr] using ht
  have hmemory : typed.memory=StableBinaryByteView.view l final.heap := by
    cases htmem : typed.memory with
    | mk words flags =>
        cases hv : StableBinaryByteView.view l final.heap with
        | mk wmap fmap =>
            have hwords : words=wmap := by
              funext a
              simpa [htmem,hv] using rel.words a
            have hflags : flags=fmap := by
              funext a
              simpa [htmem,hv] using rel.flags a
            subst wmap
            subst fmap
            rfl
  exact ⟨typed,hmodel,hmemory,rel.checks⟩

theorem byte_source_final_clear (l : StableBinary.Layout) (k : Nat)
    (before : B20.C.Byte.Memory) (final : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : StableBinaryByteView.Legal l before)
    (hs : StableBinaryCExec.run l k before=some final)
    (hfinal : StableBinaryByteView.flagRead final.heap l.bad=some 0#32) :
    StableBinaryByteView.flagRead before l.bad=some 0#32 ∧
    (∀ w∈final.checks,
      Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w) := by
  let m := StableBinaryByteView.view l before
  obtain ⟨typed,hmodel,hmem,hchecks⟩ := byte_interpreter_to_model l k before final hl legal hs
  have hm : m.initialized l := StableBinaryByteView.view_initialized l before legal
  have hclear : typed.memory.flags l.bad=some 0#32 := by
    rw [hmem]
    simpa [StableBinaryByteView.view] using hfinal
  obtain ⟨hinitial,hpositive,_,_,_⟩ :=
    StableBinaryFpr.bound_model_outcome l k m typed hl hm hmodel hclear
  refine ⟨?_,?_⟩
  · simpa [m,StableBinaryByteView.view] using hinitial
  · simpa [hchecks] using hpositive

theorem byte_source_preserves_any_bad (l : StableBinary.Layout) (k : Nat)
    (before : B20.C.Byte.Memory) (final : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : StableBinaryByteView.Legal l before)
    (hs : StableBinaryCExec.run l k before=some final)
    (initial : BitVec 32)
    (hbad : StableBinaryByteView.flagRead before l.bad=some initial)
    (hn : initial≠0#32) :
    StableBinaryByteView.flagRead final.heap l.bad≠some 0#32 := by
  let m := StableBinaryByteView.view l before
  obtain ⟨typed,hmodel,hmem,_⟩ := byte_interpreter_to_model l k before final hl legal hs
  have hprior : m.flags l.bad=some initial := by
    simpa [m,StableBinaryByteView.view] using hbad
  have hpreserve := StableBinaryFpr.bound_model_any_prior_bad l k m typed initial hmodel hprior hn
  rw [hmem] at hpreserve
  simpa [StableBinaryByteView.view] using hpreserve

end FT1536.Source3.StableBinaryFinalBridge

#check @FT1536.Source3.StableBinaryFinalBridge.byte_interpreter_to_model
#print FT1536.Source3.StableBinaryFinalBridge.byte_interpreter_to_model
#print axioms FT1536.Source3.StableBinaryFinalBridge.byte_interpreter_to_model
#print axioms FT1536.Source3.StableBinaryFinalBridge.byte_source_final_clear
#print axioms FT1536.Source3.StableBinaryFinalBridge.byte_source_preserves_any_bad
