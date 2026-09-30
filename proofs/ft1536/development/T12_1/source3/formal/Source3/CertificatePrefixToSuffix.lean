import Source3.CertificateAfterConversion
import Source3.Gate00Initialization
import Source3.CertificateSuffix001Outcome

/- The root-copy/FFT/LDL segment and byte Gate00 supply suffix-entry Legal.
   No g00 snapshot or root values are input assumptions. The entry is still
   after the four smallint conversions; enclosing allocation, profile and
   conversion execution are required for the full certificate theorem. -/
namespace FT1536.Source3.CertificatePrefixToSuffix
open C99MemoryReference C99InitializationTrace
open CertificateAfterConversion

theorem suffix_entry (base bad : Nat) (before : C99ArrayReference.State)
    (bodyResult : C99ProcedureReference.Result) (gate : Memory) (trace : List (BitVec 64))
    (legal : CertificateWorkspace.Legal base bad before.heap)
    (flag : Initialized before.heap 0 bad 4)
    (hn : before.locals "n".toList=some (.uint64,some (.uint64 1536)))
    (hg : before.arrays "g00".toList=some (workspacePointer base 4))
    (ht : before.arrays "tg".toList=some (workspacePointer base 1))
    (source : C99ProcedureReference.Exec FftProcedurePrograms.program code before bodyResult)
    (gateSource : Gate00Memory.Loop (CertificateWorkspace.layout base bad) 0 bodyResult.state.heap gate trace) :
    CertificateMemory.WellFormed (CertificateWorkspace.layout base bad) ∧
      CertificateMemory.Legal (CertificateWorkspace.layout base bad) (C99MemoryBridge.encode gate) := by
  obtain ⟨entry,copied,hs,hcopy,hrest⟩ := root_copy_witness base before bodyResult hn hg ht source
  have hp := steps_preserve before.heap entry hs
  exact CertificateWorkspace.after_root_copy base bad entry copied gate
    (CertificateWorkspace.legal_preserved base bad before.heap entry legal hp)
    (region_preserved before.heap entry hp 0 bad 4 flag) hcopy
    (steps_trans copied bodyResult.state.heap gate hrest
      (Gate00Initialization.loop_memory_steps _ _ _ _ _ gateSource))

theorem accepted_gate (base bad : Nat) (before : C99ArrayReference.State)
    (bodyResult : C99ProcedureReference.Result) (gate after : Memory) (trace : List (BitVec 64))
    (events : List CertificateEffects.Event)
    (legal : CertificateWorkspace.Legal base bad before.heap)
    (flag : Initialized before.heap 0 bad 4)
    (hn : before.locals "n".toList=some (.uint64,some (.uint64 1536)))
    (hg : before.arrays "g00".toList=some (workspacePointer base 4))
    (ht : before.arrays "tg".toList=some (workspacePointer base 1))
    (source : C99ProcedureReference.Exec FftProcedurePrograms.program code before bodyResult)
    (gateSource : Gate00Memory.Loop (CertificateWorkspace.layout base bad) 0 bodyResult.state.heap gate trace)
    (suffix : CertificateExec.PinnedExec (CertificateWorkspace.layout base bad) gate after events true) :
    trace.length=768 ∧ Load32 bodyResult.state.heap (CertificateMemory.badPtr (CertificateWorkspace.layout base bad)) 0 ∧
      (∀ w∈trace, Run2.KeygenLeafGate.positive w=true ∧
        (1/2 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue w) ∧
      (∀ event∈events, CertificateEffects.Good event) := by
  let l := CertificateWorkspace.layout base bad
  have hs := suffix_entry base bad before bodyResult gate trace legal flag hn hg ht source gateSource
  have ho := CertificateSuffix001Outcome.source_outcome l gate after events true hs.1 hs.2 suffix
  have clear := (ho.2.2.2.2.2.2 rfl).1
  have hp := steps_preserve before.heap gate (steps_trans before.heap bodyResult.state.heap gate
    (C99ProcedureReference.memory_steps _ _ _ _ source)
    (Gate00Initialization.loop_memory_steps l 0 bodyResult.state.heap gate trace gateSource))
  have hl := CertificateWorkspace.legal_preserved base bad before.heap gate legal hp
  have alloc : Allocated gate (CertificateMemory.badPtr l) := by
    refine ⟨by change 0<4; decide,hl.badAligned,by change 0<1; decide,?_,hl.addressBound⟩
    simpa [l,CertificateWorkspace.layout,CertificateMemory.badPtr,ArrayPointer.offset] using hl.badExtent
  have read : Load32 gate (CertificateMemory.badPtr l) 0 :=
    (C99MemoryAccess.load32_iff gate (CertificateMemory.badPtr l) 0 rfl alloc rfl).mpr clear
  have checks := Gate00Memory.source_checks_768 l hs.1 bodyResult.state.heap gate trace gateSource read
  exact ⟨checks.1,checks.2.1,checks.2.2,(ho.2.2.2.2.2.2 rfl).2.1⟩

end FT1536.Source3.CertificatePrefixToSuffix
