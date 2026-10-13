import CoreStore020E5
import CoreRun020E5
import RegionTrace020E5

namespace FT1536.S05.CoreHeap020E5
open WordRAM020 CoreState020E5 CoreEncoding020E5 CoreFieldPatch020E5 RegionRam020E5

/-- The context must separately realize the read-only arguments and machine
    workspace when this generic frame rule is instantiated for a full call. -/
theorem step_trace {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) (q : Core cap capacity limit) (context : Heap) :
    ∃ hist,Steps (RegionFrame020E5.heap context (image hc hf hl q)) hist
      (RegionFrame020E5.heap context (image hc hf hl (CoreStep020E5.step a i q))) ∧
      ∀ h∈RegionFrame020E5.heap context (image hc hf hl q)::hist,
        live h=payloadWords cap capacity+2+live context := by
  obtain ⟨hist,hs,hp⟩ := RegionFrame020E5.complete_store_peak context (image hc hf hl q) (CoreStore020E5.code hc hf hl a i q)
  rw [CoreStore020E5.realizes] at hs
  exact ⟨hist,hs,hp⟩

theorem run_trace {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) (fuel : Nat) (q : Core cap capacity limit) (context : Heap) :
    ∃ hist,Steps (RegionFrame020E5.heap context (image hc hf hl q)) hist
      (RegionFrame020E5.heap context (image hc hf hl (CoreRun020E5.run a i fuel q))) := by
  induction fuel generalizing q with
  | zero => exact ⟨[],.nil _⟩
  | succ fuel ih =>
    unfold CoreRun020E5.run
    split
    · exact ⟨[],.nil _⟩
    · obtain ⟨front,hfront,_⟩ := step_trace hc hf hl a i q context
      obtain ⟨tail,ht⟩ := ih (CoreStep020E5.step a i q)
      exact ⟨front++tail,RegionTrace020E5.append hfront ht⟩

theorem run_peak {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) (fuel : Nat) (q : Core cap capacity limit) (context : Heap) :
    ∃ hist,Steps (RegionFrame020E5.heap context (image hc hf hl q)) hist
      (RegionFrame020E5.heap context (image hc hf hl (CoreRun020E5.run a i fuel q))) ∧
      ∀ h∈RegionFrame020E5.heap context (image hc hf hl q)::hist,
        live h=payloadWords cap capacity+2+live context := by
  obtain ⟨hist,ht⟩ := run_trace hc hf hl a i fuel q context
  refine ⟨hist,ht,?_⟩
  intro h hh
  exact (RegionTrace020E5.peak ht h hh).trans (RegionFrame020E5.live_exact context _)

end FT1536.S05.CoreHeap020E5
