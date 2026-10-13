import ProducerFetchStore020E6

namespace FT1536.S05.ProducerFetchTrace020E6
open ArrayBank020E4 RegionRam020E5 ProducerFetch020E6

/-- Every fetch/execute state has all of its registers, output, pc, flag,
    fetched instruction and phase in the single186-word payload. -/
theorem step_trace {regions codeSize : Nat} {extent : Fin regions → Nat} (hr : regions≤2^511) (hc : codeSize<2^511)
    (sources : ProducerMachine020E6.Sources extent) (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize)
    (q : ProducerFetch020E6.State regions codeSize) (context : Heap) :
    ∃ hist,Steps (RegionFrame020E5.heap context (ProducerFetchStore020E6.image hr hc q)) hist
      (RegionFrame020E5.heap context (ProducerFetchStore020E6.image hr hc (ProducerFetch020E6.step sources code q))) := by
  let p := ProducerFetchStore020E6.program hr hc sources code q
  obtain ⟨hist,ht,_⟩ := RegionFrame020E5.complete_store_peak context (ProducerFetchStore020E6.image hr hc q) p.code
  rw [p.correct] at ht
  exact ⟨hist,ht⟩

theorem cycle_trace {regions codeSize : Nat} {extent : Fin regions → Nat} (hr : regions≤2^511) (hc : codeSize<2^511)
    (sources : ProducerMachine020E6.Sources extent) (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize)
    (q : ProducerFetch020E6.State regions codeSize) (context : Heap) :
    ∃ hist,Steps (RegionFrame020E5.heap context (ProducerFetchStore020E6.image hr hc q)) hist
      (RegionFrame020E5.heap context (ProducerFetchStore020E6.image hr hc (cycle sources code q))) := by
  obtain ⟨a,ha⟩ := step_trace hr hc sources code q context
  obtain ⟨b,hb⟩ := step_trace hr hc sources code (ProducerFetch020E6.step sources code q) context
  exact ⟨a++b,RegionTrace020E5.append ha hb⟩

theorem run_trace {regions codeSize : Nat} {extent : Fin regions → Nat} (hr : regions≤2^511) (hc : codeSize<2^511)
    (sources : ProducerMachine020E6.Sources extent) (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize)
    (fuel : Nat) (q : ProducerFetch020E6.State regions codeSize) (context : Heap) :
    ∃ hist,Steps (RegionFrame020E5.heap context (ProducerFetchStore020E6.image hr hc q)) hist
      (RegionFrame020E5.heap context (ProducerFetchStore020E6.image hr hc (ProducerFetch020E6.run sources code fuel q))) := by
  induction fuel generalizing q with
  | zero => exact ⟨[],.nil _⟩
  | succ fuel ih =>
    unfold ProducerFetch020E6.run
    split
    · exact ⟨[],.nil _⟩
    · obtain ⟨a,ha⟩ := cycle_trace hr hc sources code q context
      obtain ⟨b,hb⟩ := ih (cycle sources code q)
      exact ⟨a++b,RegionTrace020E5.append ha hb⟩

theorem run_peak {regions codeSize : Nat} {extent : Fin regions → Nat} (hr : regions≤2^511) (hc : codeSize<2^511)
    (sources : ProducerMachine020E6.Sources extent) (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize)
    (fuel : Nat) (q : ProducerFetch020E6.State regions codeSize) (context : Heap) :
    ∃ hist,Steps (RegionFrame020E5.heap context (ProducerFetchStore020E6.image hr hc q)) hist
      (RegionFrame020E5.heap context (ProducerFetchStore020E6.image hr hc (ProducerFetch020E6.run sources code fuel q))) ∧
      ∀ heap∈RegionFrame020E5.heap context (ProducerFetchStore020E6.image hr hc q)::hist,live heap=188+live context := by
  obtain ⟨hist,ht⟩ := run_trace hr hc sources code fuel q context
  refine ⟨hist,ht,?_⟩
  intro heap hmem
  exact (RegionTrace020E5.peak ht heap hmem).trans (RegionFrame020E5.live_exact context _)

end FT1536.S05.ProducerFetchTrace020E6
