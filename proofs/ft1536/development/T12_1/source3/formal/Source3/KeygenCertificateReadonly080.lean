import Source3.KeygenMemoryStability
import Source3.KeygenMakeStatementMachine

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCertificateReadonly080
open C99MemoryReference
open C99ArrayReference (State)
open CertificateFunctionReference
open CertificateFunctionWitness (layout resolved_layout)
open KeygenMemoryStability (Stable)

theorem prefix_stable (args : Arguments) (environment : Environment) (caller : Memory)
    (prologueState zeroed declared aliased converted prefixState : State)
    (prologue : C99ProcedureReference.Exec FftProcedurePrograms.program CertificatePrologue.code
      (initial args environment caller) ⟨prologueState,.normal⟩)
    (zeroAssignment : CertificateBadAssignment.Exec (C99Automatic32.pointer caller) prologueState zeroed)
    (declarations : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateDeclarations.code
      zeroed ⟨declared,.normal⟩)
    (aliases : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateAliases.code
      declared ⟨aliased,.normal⟩)
    (conversions : CertificateConversions.Sequence CertificateConversions.calls aliased converted)
    (prefixExec : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateAfterConversion.code
      converted ⟨prefixState,.normal⟩) :
    Stable (initial args environment caller).heap prefixState.heap := by
  have first := KeygenMemoryStability.procedure _ _ _ _ prologue
  have zero := KeygenMemoryStability.store32 _ _ _ _
    (CertificateBadAssignment.source_write _ _ _ zeroAssignment).1
  have declaredStable := KeygenMemoryStability.procedure _ _ _ _ declarations
  have aliasesStable := KeygenMemoryStability.procedure _ _ _ _ aliases
  have convertedStable := KeygenMemoryStability.steps _ _
    (CertificateConversions.memory_steps _ _ _ conversions)
  have prefixStable := KeygenMemoryStability.procedure _ _ _ _ prefixExec
  exact KeygenMemoryStability.trans _ _ _ first
    (KeygenMemoryStability.trans _ _ _ zero
      (KeygenMemoryStability.trans _ _ _ declaredStable
        (KeygenMemoryStability.trans _ _ _ aliasesStable
          (KeygenMemoryStability.trans _ _ _ convertedStable prefixStable))))

/-- Every immutable caller block survives the full source certificate,
    including the two FFT tables and both return values. -/
theorem source_readonly (args : Arguments) (environment : Environment) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
    (profile : Profile args) (legal : CertificateFrameEntry.Legal args.base caller)
    (source : Exec args environment caller after gateTrace events ret)
    (block offset : Nat) (readonly : caller.writable block=false) :
    after.bytes block offset=caller.bytes block offset := by
  have not0 : block≠0 := by
    intro equal
    subst block
    rw [legal.writable] at readonly
    cases readonly
  by_cases live : offset<caller.size block
  · cases source with
    | guardReturn state space prologue =>
      have he := CertificateEntryPrologue.source_result (initial args environment caller)
        ⟨state,.returned (some (.int32 0))⟩ (initial_profile args environment caller profile) prologue
      have hf := congrArg C99ProcedureReference.Result.flow he
      cases hf
    | bodyReturn prologueState zeroed declared aliased converted prefixState actualLayout gate edge gateTrace events ret
        space prologue zeroAssignment declarations aliases conversions prefixExec operands gateExec suffix =>
      have entry := CertificateFunctionEntry.derived args environment caller prologueState zeroed declared aliased converted
        profile legal prologue zeroAssignment declarations aliases conversions
      have pointers := CertificatePrefixMetadata.source_pointers args.base converted ⟨prefixState,.normal⟩
        entry.n entry.gxx entry.g00 entry.treeSize prefixExec
      have hl : actualLayout=layout args caller := Option.some.inj
        (operands.symm.trans (resolved_layout args caller prefixState pointers.2.1 pointers.2.2))
      subst actualLayout
      have suffixEntry := CertificatePrefixToSuffix.suffix_entry args.base (C99Automatic32.address caller)
        converted ⟨prefixState,.normal⟩ gate gateTrace entry.workspace entry.flag entry.n entry.g00 entry.tg prefixExec gateExec
      have stable := prefix_stable args environment caller prologueState zeroed declared aliased converted
        prefixState prologue zeroAssignment declarations aliases conversions prefixExec
      have initialReadonly : (initial args environment caller).heap.writable block=false := by
        simpa only [initial,C99ArrayReference.bindPointer,C99Automatic32.enter,ite_eq_right not0] using readonly
      have hp := (stable.readonly block offset initialReadonly).trans
        (C99Automatic32.enter_preserves_caller caller block offset live)
      have hg := CertificateRegionFrame.gate_frame args caller prefixState.heap gate 0 gateTrace gateExec
        block offset live (Or.inl not0)
      have hs := CertificateRegionFrame.suffix_frame args caller gate edge events ret suffixEntry.1 suffixEntry.2 suffix
        block offset live (Or.inl not0)
      exact (C99Automatic32.leave_preserves_caller caller edge block offset live).trans (hs.trans (hg.trans hp))
  · exact KeygenMakeCertMaterial.leave_bytes args environment caller after gateTrace events ret source block offset live

/-- Canonical FFT table read-only facts remove the old not1/not2 side
    conditions. Only separation from the actual workspace remains. -/
theorem call_same_block (ctx : KeygenSearchContext.Context) (before after : State)
    (v : C99IntegerReference.Value) (ret : Bool)
    (call : KeygenMakeCertCall.Call ctx before after v ret)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (workspace : KeygenMakeCertMaterial.LegalWorkspace before ctx)
    (block : Nat) (not0 : block≠0) : ShakeExtractFrame.SameBlock before.heap after.heap block := by
  by_cases not1 : block≠1
  · by_cases not2 : block≠2
    · exact KeygenMakeStatementMachine.call_same_block ctx before after v ret call dimensions workspace block not0 not1 not2
    · have two : block=2 := by omega
      cases call with
      | run args bind afterMem gateTrace events ret body v bit =>
        have profile := KeygenMakeCertCall.bind_callee_profile before ctx args bind dimensions
        have shape := KeygenMakeCertMaterial.leave_shape args FftGlobalMemory.environment before.heap afterMem gateTrace events ret body.2
        have readonly : before.heap.writable block=false := by
          rw [two]
          exact (body.1.2 .cubic 0 (by rw [FftTableSources.words_length]; decide +kernel)).2
        exact ⟨shape.1,shape.2,fun offset => source_readonly args FftGlobalMemory.environment before.heap afterMem
          gateTrace events ret profile (workspace args bind) body.2 block offset readonly⟩
  · have one : block=1 := by omega
    cases call with
    | run args bind afterMem gateTrace events ret body v bit =>
      have profile := KeygenMakeCertCall.bind_callee_profile before ctx args bind dimensions
      have shape := KeygenMakeCertMaterial.leave_shape args FftGlobalMemory.environment before.heap afterMem gateTrace events ret body.2
      have readonly : before.heap.writable block=false := by
        rw [one]
        exact (body.1.2 .square 0 (by rw [FftTableSources.words_length]; decide +kernel)).2
      exact ⟨shape.1,shape.2,fun offset => source_readonly args FftGlobalMemory.environment before.heap afterMem
        gateTrace events ret profile (workspace args bind) body.2 block offset readonly⟩

end FT1536.Source3.KeygenCertificateReadonly080
