import Source3.CertificateFunctionBindings
import Source3.CertificateRegionFrame
import Source3.C99AliasHeap

namespace FT1536.Source3.CertificateFunctionFrame
open C99MemoryReference
open C99ArrayReference (State)
open CertificateFunctionReference
open CertificateFunctionWitness (layout resolved_layout)

theorem conversion_destinations (name : C99ArrayReference.Name)
    (member : name∈CertificateConversions.calls.map Prod.fst) : name∈CertificateAfterConversion.context := by
  simp [CertificateConversions.calls] at member
  rcases member with rfl | rfl | rfl | rfl <;> simp [CertificateAfterConversion.context]

theorem before_prefix (args : Arguments) (environment : Environment) (caller : Memory)
    (prologueState zeroed declared aliased converted : State) (profile : Profile args)
    (prologue : C99ProcedureReference.Exec FftProcedurePrograms.program CertificatePrologue.code
      (initial args environment caller) ⟨prologueState,.normal⟩)
    (zeroAssignment : CertificateBadAssignment.Exec (C99Automatic32.pointer caller) prologueState zeroed)
    (declarations : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateDeclarations.code zeroed ⟨declared,.normal⟩)
    (aliases : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateAliases.code declared ⟨aliased,.normal⟩)
    (conversions : CertificateConversions.Sequence CertificateConversions.calls aliased converted)
    (block offset : Nat) (live : offset<caller.size block) (outside : CertificateRegionFrame.Outside args.base block offset)
    (tables : C99PointerFootprint.TablesOutside (initial args environment caller) block offset) :
    converted.heap.bytes block offset=caller.bytes block offset := by
  have shape := CertificateFunctionBindings.converted args environment caller prologueState zeroed declared aliased converted
    profile prologue zeroAssignment declarations aliases conversions
  have hb := CertificateConversions.bindings CertificateConversions.calls aliased converted conversions
  have ho : C99ArrayFrame.Outside aliased (CertificateConversions.calls.map Prod.fst) block offset := by
    intro name member p binding
    have hp : converted.arrays name=some p := by rw [hb.2.1]; exact binding
    exact CertificateWorkspaceViews.point_outside args.base p
      (shape.1 name (conversion_destinations name member) p hp) block offset outside
  have ht : C99PointerFootprint.TablesOutside aliased block offset := by
    have he := hb.2.2.symm.trans shape.2
    simpa only [C99PointerFootprint.TablesOutside,he,initial,C99ArrayReference.bindPointer] using tables
  have frame := CertificateConversions.source_frame CertificateConversions.calls aliased converted conversions block offset ho ht
  have ah := C99AliasHeap.unchanged FftProcedurePrograms.program CertificateAliases.aliases declared ⟨aliased,.normal⟩ aliases
  change aliased.heap=declared.heap at ah
  have dh := congrArg (fun r : C99ProcedureReference.Result => r.state.heap)
    (CertificateEntryDeclarations.source_result zeroed ⟨declared,.normal⟩ declarations)
  change declared.heap=(CertificateEntryDeclarations.ready zeroed).heap at dh
  rw [CertificateEntryDeclarations.heap_preserved] at dh
  rw [ah,dh] at frame
  have ph := congrArg (fun r : C99ProcedureReference.Result => r.state.heap)
    (CertificateEntryPrologue.source_result (initial args environment caller) ⟨prologueState,.normal⟩
      (initial_profile args environment caller profile) prologue)
  change prologueState.heap=C99Automatic32.enter caller at ph
  have write := (CertificateBadAssignment.source_write _ _ _ zeroAssignment).1
  rw [ph] at write
  exact frame.trans (CertificateFrameEntry.init_caller_frame caller zeroed.heap write block offset live)

theorem source_frame (args : Arguments) (environment : Environment) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
    (profile : Profile args) (legal : CertificateFrameEntry.Legal args.base caller)
    (source : Exec args environment caller after gateTrace events ret)
    (block offset : Nat) (live : offset<caller.size block) (outside : CertificateRegionFrame.Outside args.base block offset)
    (tables : C99PointerFootprint.TablesOutside (initial args environment caller) block offset) :
    after.bytes block offset=caller.bytes block offset := by
  cases source with
  | guardReturn state space prologue =>
      have he := CertificateEntryPrologue.source_result (initial args environment caller) ⟨state,.returned (some (.int32 0))⟩
        (initial_profile args environment caller profile) prologue
      have hf := congrArg C99ProcedureReference.Result.flow he
      cases hf
  | bodyReturn prologueState zeroed declared aliased converted prefixState actualLayout gate edge gateTrace events ret
      space prologue zeroAssignment declarations aliases conversions prefixExec operands gateExec suffix =>
      have entry := CertificateFunctionEntry.derived args environment caller prologueState zeroed declared aliased converted
        profile legal prologue zeroAssignment declarations aliases conversions
      have shape := CertificateFunctionBindings.converted args environment caller prologueState zeroed declared aliased converted
        profile prologue zeroAssignment declarations aliases conversions
      have pointers := CertificatePrefixMetadata.source_pointers args.base converted ⟨prefixState,.normal⟩
        entry.n entry.gxx entry.g00 entry.treeSize prefixExec
      have hl : actualLayout=layout args caller := Option.some.inj
        (operands.symm.trans (resolved_layout args caller prefixState pointers.2.1 pointers.2.2))
      subst actualLayout
      have suffixEntry := CertificatePrefixToSuffix.suffix_entry args.base (C99Automatic32.address caller)
        converted ⟨prefixState,.normal⟩ gate gateTrace entry.workspace entry.flag entry.n entry.g00 entry.tg prefixExec gateExec
      have hc := before_prefix args environment caller prologueState zeroed declared aliased converted profile
        prologue zeroAssignment declarations aliases conversions block offset live outside tables
      have ht : C99PointerFootprint.TablesOutside converted block offset := by
        simpa only [C99PointerFootprint.TablesOutside,shape.2,initial,C99ArrayReference.bindPointer] using tables
      have hp := CertificatePrefixFrame.source_frame args.base converted ⟨prefixState,.normal⟩ shape.1 prefixExec block offset outside ht
      have hg := CertificateRegionFrame.gate_frame args caller prefixState.heap gate 0 gateTrace gateExec block offset live outside
      have hs := CertificateRegionFrame.suffix_frame args caller gate edge events ret suffixEntry.1 suffixEntry.2 suffix block offset live outside
      exact (C99Automatic32.leave_preserves_caller caller edge block offset live).trans (hs.trans (hg.trans (hp.trans hc)))

end FT1536.Source3.CertificateFunctionFrame
