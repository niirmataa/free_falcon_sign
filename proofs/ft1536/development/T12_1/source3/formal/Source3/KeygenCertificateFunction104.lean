import Source3.KeygenCertificatePrefix104

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCertificateFunction104
open C99MemoryReference
open C99ArrayReference (State)
open CertificateFunctionReference

theorem suffix_domain (args : Arguments) (environment : Environment) (caller : Memory)
    (prologueState zeroed declared aliased converted prefixState : State)
    (actualLayout : CertificateMemory.Layout) (gate : Memory) (gateTrace : List (BitVec 64))
    (profile : Profile args) (legal : CertificateFrameEntry.Legal args.base caller)
    (prologue : C99ProcedureReference.Exec FftProcedurePrograms.program CertificatePrologue.code
      (initial args environment caller) ⟨prologueState,.normal⟩)
    (zeroAssignment : CertificateBadAssignment.Exec (C99Automatic32.pointer caller) prologueState zeroed)
    (declarations : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateDeclarations.code zeroed ⟨declared,.normal⟩)
    (aliases : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateAliases.code declared ⟨aliased,.normal⟩)
    (conversions : CertificateConversions.Sequence CertificateConversions.calls aliased converted)
    (prefixExec : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateAfterConversion.code converted ⟨prefixState,.normal⟩)
    (operands : resolveLayout caller prefixState=some actualLayout)
    (gateExec : Gate00Memory.Loop actualLayout 0 prefixState.heap gate gateTrace) :
    CertificateMemory.WellFormed actualLayout ∧ CertificateMemory.Legal actualLayout (C99MemoryBridge.encode gate) := by
  have entry := CertificateFunctionEntry.derived args environment caller prologueState zeroed declared aliased converted
    profile legal prologue zeroAssignment declarations aliases conversions
  have pointers := CertificatePrefixMetadata.source_pointers args.base converted ⟨prefixState,.normal⟩
    entry.n entry.gxx entry.g00 entry.treeSize prefixExec
  have resolved := CertificateFunctionWitness.resolved_layout args caller prefixState pointers.2.1 pointers.2.2
  have hl : actualLayout=CertificateFunctionWitness.layout args caller := Option.some.inj (operands.symm.trans resolved)
  subst actualLayout
  exact CertificatePrefixToSuffix.suffix_entry args.base (C99Automatic32.address caller)
    converted ⟨prefixState,.normal⟩ gate gateTrace entry.workspace entry.flag entry.n entry.g00 entry.tg prefixExec gateExec

/-- This local frame/profile interface is discharged at the actual caller.
    The suffix domain is derived from source execution, not supplied. -/
theorem execution (args : Arguments) (environment : Environment) (caller a b : Memory)
    (gx gy : List (BitVec 64)) (ex ey : List CertificateEffects.Event) (r s : Bool)
    (profile : Profile args) (legal : CertificateFrameEntry.Legal args.base caller)
    (first : Exec args environment caller a gx ex r) (second : Exec args environment caller b gy ey s) :
    a = b ∧ gx = gy ∧ ex = ey ∧ r = s := by
  cases first <;> cases second
  all_goals grind (ematch := 16) only [C99ProcedureDeterminism094.execution, KeygenCertificatePrefix104.bad,
    KeygenCertificatePrefix104.conversions, → KeygenCertificatePrefix104.gate_loop,
    → suffix_domain, → KeygenCertificatePrefix104.suffix]

end FT1536.Source3.KeygenCertificateFunction104
