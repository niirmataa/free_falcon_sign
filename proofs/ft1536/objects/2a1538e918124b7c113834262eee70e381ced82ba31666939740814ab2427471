import Source3.CertificateFunctionEntry
import Source3.CertificateWorkspaceViews
import Source3.C99TableFrame

namespace FT1536.Source3.CertificateFunctionBindings
open C99MemoryReference
open C99ArrayReference (State)
open CertificateFunctionReference
open CertificateAfterConversion (workspacePointer)

theorem converted (args : Arguments) (environment : Environment) (caller : Memory)
    (prologueState zeroed declared aliased after : State) (profile : Profile args)
    (prologue : C99ProcedureReference.Exec FftProcedurePrograms.program CertificatePrologue.code
      (initial args environment caller) ⟨prologueState,.normal⟩)
    (zeroAssignment : CertificateBadAssignment.Exec (C99Automatic32.pointer caller) prologueState zeroed)
    (declarations : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateDeclarations.code zeroed ⟨declared,.normal⟩)
    (aliases : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateAliases.code declared ⟨aliased,.normal⟩)
    (conversions : CertificateConversions.Sequence CertificateConversions.calls aliased after) :
    CertificatePrefixFrame.Within args.base after ∧ after.tables=environment.tables := by
  have hp := initial_profile args environment caller profile
  have he := congrArg C99ProcedureReference.Result.state
    (CertificateEntryPrologue.source_result (initial args environment caller) ⟨prologueState,.normal⟩ hp prologue)
  change prologueState=CertificateEntryPrologue.ready (initial args environment caller) at he
  subst prologueState
  have hz := (CertificateBadAssignment.source_write _ _ _ zeroAssignment).2
  have hzl := congrArg State.locals hz
  have hza := congrArg State.arrays hz
  have hzt := congrArg State.tables hz
  change zeroed.locals=(CertificateEntryPrologue.ready (initial args environment caller)).locals at hzl
  change zeroed.arrays=(CertificateEntryPrologue.ready (initial args environment caller)).arrays at hza
  change zeroed.tables=environment.tables at hzt
  have hd := congrArg C99ProcedureReference.Result.state
    (CertificateEntryDeclarations.source_result zeroed ⟨declared,.normal⟩ declarations)
  change declared=CertificateEntryDeclarations.ready zeroed at hd
  subst declared
  have hn : C99AliasSequence.HasN (CertificateEntryDeclarations.ready zeroed) := by
    change (CertificateEntryDeclarations.ready zeroed).locals "n".toList=_
    rw [CertificateEntryDeclarations.n_preserved,hzl]
    exact CertificateEntryPrologue.ready_n (initial args environment caller)
  have tmp : zeroed.arrays "tmp".toList=some (workspacePointer args.base 0) := by
    rw [hza,CertificateEntryPrologue.ready_arrays]
    exact initial_tmp args environment caller
  have htmp : (CertificateEntryDeclarations.ready zeroed).arrays "tmp".toList=some (workspacePointer args.base 0) :=
    (CertificateEntryDeclarations.tmp_preserved zeroed).trans tmp
  have ha := congrArg C99ProcedureReference.Result.state
    (CertificateAliases.source_result FftProcedurePrograms.program args.base (CertificateEntryDeclarations.ready zeroed)
      ⟨aliased,.normal⟩ hn htmp aliases)
  change aliased=CertificateAliases.installed args.base (CertificateEntryDeclarations.ready zeroed) at ha
  subst aliased
  have hb := CertificateConversions.bindings CertificateConversions.calls _ after conversions
  refine ⟨?_,?_⟩
  · simpa only [CertificatePrefixFrame.Within,hb.2.1] using CertificateWorkspaceViews.aliases_inside args.base zeroed tmp
  · have ht := C99TableFrame.procedure_execution FftProcedurePrograms.program CertificateDeclarations.code
      zeroed ⟨CertificateEntryDeclarations.ready zeroed,.normal⟩ declarations
    change (CertificateEntryDeclarations.ready zeroed).tables=zeroed.tables at ht
    exact hb.2.2.trans (ht.trans hzt)

end FT1536.Source3.CertificateFunctionBindings
