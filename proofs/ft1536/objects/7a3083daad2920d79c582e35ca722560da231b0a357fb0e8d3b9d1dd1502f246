import Source3.CertificateFunctionReference

namespace FT1536.Source3.CertificateFunctionEntry
open C99MemoryReference C99InitializationTrace
open C99ArrayReference (State)
open CertificateFunctionReference
open CertificateAfterConversion (workspacePointer)

structure Facts (base bad : Nat) (s : State) : Prop where
  workspace : CertificateWorkspace.Legal base bad s.heap
  flag : Initialized s.heap 0 bad 4
  n : s.locals "n".toList=some (.uint64,some (.uint64 1536))
  hn : s.locals "hn".toList=some (.uint64,some (.uint64 768))
  logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))
  ter : s.locals "ter".toList=some (.uint32,some (.uint32 1))
  g00 : s.arrays "g00".toList=some (workspacePointer base 4)
  tg : s.arrays "tg".toList=some (workspacePointer base 1)
  gxx : s.arrays "gxx".toList=some (workspacePointer base 7)
  treeSize : s.locals "treesize".toList=some (.uint64,none)

theorem derived (args : Arguments) (environment : Environment) (caller : Memory)
    (prologueState zeroed declared aliased converted : State)
    (profile : Profile args) (legal : CertificateFrameEntry.Legal args.base caller)
    (prologue : C99ProcedureReference.Exec FftProcedurePrograms.program CertificatePrologue.code
      (initial args environment caller) ⟨prologueState,.normal⟩)
    (zeroAssignment : CertificateBadAssignment.Exec (C99Automatic32.pointer caller) prologueState zeroed)
    (declarations : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateDeclarations.code zeroed ⟨declared,.normal⟩)
    (aliases : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateAliases.code declared ⟨aliased,.normal⟩)
    (conversions : CertificateConversions.Sequence CertificateConversions.calls aliased converted) :
    Facts args.base (C99Automatic32.address caller) converted := by
  have hp := initial_profile args environment caller profile
  have hprologue := CertificateEntryPrologue.source_result (initial args environment caller) ⟨prologueState,.normal⟩ hp prologue
  have he := congrArg C99ProcedureReference.Result.state hprologue
  change prologueState=CertificateEntryPrologue.ready (initial args environment caller) at he
  subst prologueState
  obtain ⟨write,hzero⟩ := CertificateBadAssignment.source_write _ _ _ zeroAssignment
  have hzl := congrArg State.locals hzero
  have hza := congrArg State.arrays hzero
  change zeroed.locals=(CertificateEntryPrologue.ready (initial args environment caller)).locals at hzl
  change zeroed.arrays=(CertificateEntryPrologue.ready (initial args environment caller)).arrays at hza
  have hdecl := congrArg C99ProcedureReference.Result.state (CertificateEntryDeclarations.source_result zeroed ⟨declared,.normal⟩ declarations)
  change declared=CertificateEntryDeclarations.ready zeroed at hdecl
  subst declared
  have hn : C99AliasSequence.HasN (CertificateEntryDeclarations.ready zeroed) := by
    change (CertificateEntryDeclarations.ready zeroed).locals "n".toList=_
    rw [CertificateEntryDeclarations.n_preserved,hzl]
    exact CertificateEntryPrologue.ready_n (initial args environment caller)
  have htmp : (CertificateEntryDeclarations.ready zeroed).arrays "tmp".toList=some (workspacePointer args.base 0) := by
    rw [CertificateEntryDeclarations.tmp_preserved,hza,CertificateEntryPrologue.ready_arrays]
    exact initial_tmp args environment caller
  have halias := congrArg C99ProcedureReference.Result.state
    (CertificateAliases.source_result FftProcedurePrograms.program args.base (CertificateEntryDeclarations.ready zeroed)
      ⟨aliased,.normal⟩ hn htmp aliases)
  change aliased=CertificateAliases.installed args.base (CertificateEntryDeclarations.ready zeroed) at halias
  subst aliased
  have hb := CertificateConversions.bindings CertificateConversions.calls _ converted conversions
  have cells : ∀ name, name≠"treesize".toList →
      converted.locals name=(CertificateEntryPrologue.ready (initial args environment caller)).locals name := by
    intro name different
    rw [hb.1]
    change (CertificateEntryDeclarations.ready zeroed).locals name=_
    rw [CertificateEntryDeclarations.local_preserved zeroed name different,hzl]
  have beforeProfile := CertificateEntryPrologue.ready_profile (initial args environment caller) hp
  have hw : Store32 (C99Automatic32.enter caller) (C99Automatic32.pointer caller) 0 zeroed.heap := write
  have hz := CertificateFrameEntry.initialized_entry args.base caller zeroed.heap legal hw
  have steps := CertificateConversions.memory_steps CertificateConversions.calls _ converted conversions
  rw [CertificateAliases.installed_heap,CertificateEntryDeclarations.heap_preserved] at steps
  have preserves := steps_preserve zeroed.heap converted.heap steps
  refine ⟨CertificateWorkspace.legal_preserved args.base (C99Automatic32.address caller) zeroed.heap converted.heap hz.1 preserves,
    region_preserved zeroed.heap converted.heap preserves 0 (C99Automatic32.address caller) 4 hz.2,
    ?_,?_,?_,?_,?_,?_,?_,?_⟩
  · exact (cells "n".toList (by decide)).trans (CertificateEntryPrologue.ready_n (initial args environment caller))
  · exact (cells "hn".toList (by decide)).trans (CertificateEntryPrologue.ready_hn (initial args environment caller))
  · exact (cells "logn".toList (by decide)).trans beforeProfile.1
  · exact (cells "ter".toList (by decide)).trans beforeProfile.2
  · rw [hb.2.1]
    exact CertificateAliases.installed_g00 args.base _
  · rw [hb.2.1]
    exact CertificateAliases.installed_tg args.base _
  · rw [hb.2.1]
    simp [CertificateAliases.installed,CertificateAliases.bindings,C99ArrayReference.bindPointer]
  · rw [hb.1]
    change (CertificateEntryDeclarations.ready zeroed).locals "treesize".toList=_
    simp [CertificateEntryDeclarations.ready,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set,C99ValueBridge.type]

end FT1536.Source3.CertificateFunctionEntry
