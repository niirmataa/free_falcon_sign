import Source3.CertificateBadAssignment
import Source3.CertificateEntryDeclarations
import Source3.CertificateConversions
import Source3.CertificatePrefixMetadata
import Source3.CertificateFrameEntry
import Source3.CertificateSuffix001Outcome
import Source3.Gate00Memory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source-function composition in the author-defined C99/LP64 fragment.
   Every callee relation below executes its fixed source body. The source
   operations, including local allocation/zeroing and teardown, determine
   the return; no NTRU fact or certificate acceptance is a constructor input.
   Binding the static global environment to M0 is a separate program-entry
   obligation; this function-level relation retains that environment. -/
namespace FT1536.Source3.CertificateFunctionReference
open C99MemoryReference
open C99ArrayReference (Name State bindPointer)

structure Arguments where
  base : Nat
  f : ArrayPointer
  g : ArrayPointer
  bigF : ArrayPointer
  bigG : ArrayPointer
  logn : BitVec 32
  ter : BitVec 32

structure Environment where
  globals : C99ScalarReference.Env
  tables : Name → Option ArrayPointer

def Profile (args : Arguments) : Prop := args.logn=10 ∧ args.ter=1

def initial (args : Arguments) (environment : Environment) (caller : Memory) : State :=
  let locals := C99ScalarReference.set
    (C99ScalarReference.set environment.globals "ter".toList (.uint32,some (.uint32 args.ter)))
    "logn".toList (.uint32,some (.uint32 args.logn))
  let state : State := ⟨C99Automatic32.enter caller,locals,environment.tables,environment.globals,environment.tables⟩
  let state := bindPointer state "tmp".toList (CertificateAfterConversion.workspacePointer args.base 0)
  let state := bindPointer state "f".toList args.f
  let state := bindPointer state "g".toList args.g
  let state := bindPointer state "F".toList args.bigF
  bindPointer state "G".toList args.bigG

theorem source_header : (Pinned.keygenLines.drop 7688).take 6 =
    ["static int\n","ft_keygen_leaf_certificate(fpr *tmp,\n",
     "\tconst int16_t *f, const int16_t *g,\n","\tconst int16_t *F, const int16_t *G,\n",
     "\tunsigned logn, unsigned ter)\n","{\n"] := by decide
theorem source_inner_open : Pinned.keygenLines[7703]?=some "\t{\n" := by decide
theorem source_function_close : (Pinned.keygenLines.drop 7776).take 2=["\t}\n","}\n"] := by decide

def resolveLayout (caller : Memory) (s : State) : Option CertificateMemory.Layout := do
  let roots ← s.arrays "g00".toList
  let buffer ← s.arrays "t3".toList
  if roots.block=0 ∧ buffer.block=0 ∧ roots.elementBytes=8 ∧ buffer.elementBytes=8 then
    pure ⟨roots.offset,buffer.offset,C99Automatic32.address caller⟩ else none

inductive Exec (args : Arguments) (environment : Environment) (caller : Memory) :
    Memory → List (BitVec 64) → List CertificateEffects.Event → Bool → Prop where
  | guardReturn (state : State)
      (space : C99Automatic32.Space caller)
      (prologue : C99ProcedureReference.Exec FftProcedurePrograms.program CertificatePrologue.code
        (initial args environment caller) ⟨state,.returned (some (.int32 0))⟩) :
      Exec args environment caller (C99Automatic32.leave caller state.heap) [] [] false
  | bodyReturn (prologueState zeroed declared aliased converted prefixState : State)
      (layout : CertificateMemory.Layout) (gate edge : Memory)
      (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
      (space : C99Automatic32.Space caller)
      (prologue : C99ProcedureReference.Exec FftProcedurePrograms.program CertificatePrologue.code
        (initial args environment caller) ⟨prologueState,.normal⟩)
      (zeroAssignment : CertificateBadAssignment.Exec (C99Automatic32.pointer caller) prologueState zeroed)
      (declarations : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateDeclarations.code zeroed ⟨declared,.normal⟩)
      (aliases : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateAliases.code declared ⟨aliased,.normal⟩)
      (conversions : CertificateConversions.Sequence CertificateConversions.calls aliased converted)
      (prefixExec : C99ProcedureReference.Exec FftProcedurePrograms.program CertificateAfterConversion.code converted ⟨prefixState,.normal⟩)
      (operands : resolveLayout caller prefixState=some layout)
      (gateExec : Gate00Memory.Loop layout 0 prefixState.heap gate gateTrace)
      (suffix : CertificateExec.PinnedExec layout gate edge events ret) :
      Exec args environment caller (C99Automatic32.leave caller edge) gateTrace events ret

theorem initial_profile (args : Arguments) (environment : Environment) (caller : Memory) (profile : Profile args) :
    MknReference.Profile (initial args environment caller) := by
  obtain ⟨hl,ht⟩ := profile
  simp [MknReference.Profile,initial,bindPointer,C99ScalarReference.set,hl,ht]
theorem initial_tmp (args : Arguments) (environment : Environment) (caller : Memory) :
    (initial args environment caller).arrays "tmp".toList=some (CertificateAfterConversion.workspacePointer args.base 0) := by
  simp [initial,bindPointer]

theorem bad_dead_after_return (args : Arguments) (environment : Environment) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
    (source : Exec args environment caller after gateTrace events ret) :
    ∀ w : BitVec 32, ¬Load32 after (C99Automatic32.pointer caller) w := by
  cases source
  all_goals exact C99Automatic32.dead_read_impossible caller _

end FT1536.Source3.CertificateFunctionReference
