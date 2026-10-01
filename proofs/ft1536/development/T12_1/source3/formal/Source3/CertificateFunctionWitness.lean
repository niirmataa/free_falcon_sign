import Source3.CertificateFunctionEntry
import Source3.CertificatePrefixToSuffix
import Source3.CertificateReturnLifetime

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateFunctionWitness
open C99MemoryReference
open C99ArrayReference (State)
open CertificateFunctionReference
open CertificateAfterConversion (workspacePointer)

def layout (args : Arguments) (caller : Memory) : CertificateMemory.Layout :=
  CertificateWorkspace.layout args.base (C99Automatic32.address caller)

theorem workspace_offset (base slot : Nat) :
    (workspacePointer base slot).offset=CertificateWorkspace.slot base slot := by
  simp only [workspacePointer,ArrayPointer.offset,CertificateWorkspace.slot,← Nat.mul_assoc]

theorem resolved_layout (args : Arguments) (caller : Memory) (s : State)
    (roots : s.arrays "g00".toList=some (workspacePointer args.base 4))
    (buffer : s.arrays "t3".toList=some (workspacePointer args.base 20)) :
    resolveLayout caller s=some (layout args caller) := by
  unfold resolveLayout
  rw [roots,buffer]
  change (if (0 : Nat)=0 ∧ (0 : Nat)=0 ∧ (8 : Nat)=8 ∧ (8 : Nat)=8 then
    some (⟨(workspacePointer args.base 4).offset,(workspacePointer args.base 20).offset,
      C99Automatic32.address caller⟩ : CertificateMemory.Layout) else none)=some (layout args caller)
  rw [ite_eq_left (by decide),workspace_offset,workspace_offset]
  rfl

structure Witness (args : Arguments) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool) where
  converted : State
  prefixState : State
  gate : Memory
  edge : Memory
  entry : CertificateFunctionEntry.Facts args.base (C99Automatic32.address caller) converted
  prefixExec : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateAfterConversion.code converted ⟨prefixState,.normal⟩
  gateExec : Gate00Memory.Loop (layout args caller) 0 prefixState.heap gate gateTrace
  suffix : CertificateExec.PinnedExec (layout args caller) gate edge events ret
  wellFormed : CertificateMemory.WellFormed (layout args caller)
  suffixLegal : CertificateMemory.Legal (layout args caller) (C99MemoryBridge.encode gate)
  returned : after=C99Automatic32.leave caller edge

theorem from_source (args : Arguments) (environment : Environment) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
    (profile : Profile args) (legal : CertificateFrameEntry.Legal args.base caller)
    (source : Exec args environment caller after gateTrace events ret) :
    Nonempty (Witness args caller after gateTrace events ret) := by
  cases source with
  | guardReturn state space prologue =>
      have h := CertificateEntryPrologue.source_result (initial args environment caller) ⟨state,.returned (some (.int32 0))⟩
        (initial_profile args environment caller profile) prologue
      have hf := congrArg C99ProcedureReference.Result.flow h
      cases hf
  | bodyReturn prologueState zeroed declared aliased converted prefixState actualLayout gate edge gateTrace events ret
      space prologue zeroAssignment declarations aliases conversions prefixExec operands gateExec suffix =>
      have entry := CertificateFunctionEntry.derived args environment caller prologueState zeroed declared aliased converted
        profile legal prologue zeroAssignment declarations aliases conversions
      have pointers := CertificatePrefixMetadata.source_pointers args.base converted ⟨prefixState,.normal⟩
        entry.n entry.gxx entry.g00 entry.treeSize prefixExec
      have resolved := resolved_layout args caller prefixState pointers.2.1 pointers.2.2
      have hl : actualLayout=layout args caller := Option.some.inj (operands.symm.trans resolved)
      subst actualLayout
      have ready := CertificatePrefixToSuffix.suffix_entry args.base (C99Automatic32.address caller)
        converted ⟨prefixState,.normal⟩ gate gateTrace entry.workspace entry.flag entry.n entry.g00 entry.tg prefixExec gateExec
      exact ⟨⟨converted,prefixState,gate,edge,entry,prefixExec,gateExec,suffix,ready.1,ready.2,rfl⟩⟩

theorem accepted (args : Arguments) (environment : Environment) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event)
    (profile : Profile args) (legal : CertificateFrameEntry.Legal args.base caller)
    (source : Exec args environment caller after gateTrace events true) :
    ∃ witness : Witness args caller after gateTrace events true,
      gateTrace.length=768 ∧
      (∀ w∈gateTrace, Run2.KeygenLeafGate.positive w=true ∧ (1/2 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue w) ∧
      (∀ e∈events, CertificateEffects.Good e) ∧
      StableBinaryByteView.flagRead (C99MemoryBridge.encode witness.edge) (layout args caller).bad=some 0 ∧
      (∀ i<1536, ∃ w, StableBinaryByteView.wordRead (C99MemoryBridge.encode witness.edge)
          (StableBinary.addr (CertificateMemory.leaves (layout args caller)) i)=some w ∧
        Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.lowerBits.toNat≤w.toNat ∧
        w.toNat≤Run2.KeygenLeafGate.upperBits.toNat ∧
        (1024 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue w ∧
        Run2.KeygenLeafGate.positiveNormalValue w<(332054 : ℝ)) := by
  obtain ⟨witness⟩ := from_source args environment caller after gateTrace events true profile legal source
  have hg := CertificatePrefixToSuffix.accepted_gate args.base (C99Automatic32.address caller)
    witness.converted ⟨witness.prefixState,.normal⟩ witness.gate witness.edge gateTrace events
    witness.entry.workspace witness.entry.flag witness.entry.n witness.entry.g00 witness.entry.tg
    witness.prefixExec witness.gateExec witness.suffix
  have hs := CertificateSuffix001Outcome.source_outcome (layout args caller) witness.gate witness.edge events true
    witness.wellFormed witness.suffixLegal witness.suffix
  refine ⟨witness,hg.1,hg.2.2.1,hg.2.2.2,
    CertificateReturnLifetime.source_return_observation (layout args caller) witness.gate witness.edge events witness.suffix,?_⟩
  intro i hi
  obtain ⟨word,read⟩ := Option.isSome_iff_exists.mp (hs.2.2.2.2.1 i hi)
  exact ⟨word,read,(hs.2.2.2.2.2.2 rfl).2.2 i hi word read⟩

end FT1536.Source3.CertificateFunctionWitness
