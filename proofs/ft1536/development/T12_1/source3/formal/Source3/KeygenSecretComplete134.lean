import Source3.KeygenSecretComplete081
import Source3.KeygenOutputMemory081
import Source3.KeygenMakeAssembly134
import Source3.KeygenOutputMemory134
import Source3.KeygenSecretInvocation134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenSecretComplete134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env inputOf publicOf)
open KeygenInt16FourMaterial076 (Vectors Represented)
open KeygenSecretLocal081 (Laws packet)


open KeygenSecretComplete081
def SameCertificate (env : Env) (caller : State) (out : Result)
    (frontier : KeygenMakeAssembly134.Frontier env caller out) (v : Vectors) (h : Relation.Rq) : Prop :=
  ∃ (raw : State) (value : C99IntegerReference.Value),
    KeygenMakeCertRelocation.CallAt env.ctx.scratch.block env.ctx raw frontier.loopOut.state value true ∧
    KeygenCertificateOccurrence080.Package env.ctx raw frontier.loopOut.state ∧
    KeygenCapWords.Count raw frontier.attempts.length ∧
    (∀ slot, raw.arrays (KeygenResidueTrace.names slot).2.toList=some (inputOf env slot)) ∧
    raw.arrays "h".toList=some (publicOf env) ∧ Represented raw.heap (inputOf env) v ∧
    KeygenPublicNormalizePolynomial.Represents raw.heap (publicOf env) h

theorem certificate_material (env : Env) (caller : State) (out : Result)
    (frontier : KeygenMakeAssembly134.Frontier env caller out) (v : Vectors) (h fInv : Relation.Rq)
    (laws : Laws env frontier.loopOut.state v h fInv) : SameCertificate env caller out frontier v h := by
  obtain ⟨raw,value,call,package,count,cells,hCell,witness,frames,hFrame⟩ := frontier.joined
  refine ⟨raw,value,call,package,count,cells,hCell,?_,?_⟩
  · intro slot
    exact KeygenMakeCertMaterial.represents_same frontier.loopOut.state.heap raw.heap (inputOf env slot) (v slot)
      (same_symm _ _ _ (frames slot)) (laws.1 slot)
  · exact KeygenMakeCertMaterial.public_represents_same frontier.loopOut.state.heap raw.heap (publicOf env) h
      (same_symm _ _ _ hFrame) laws.2.2.2.1

structure Output (env : Env) (caller : State) (out : Result) where
  frontier : KeygenSecretInvocation134.Frontier env caller out
  vectors : Vectors
  h : Relation.Rq
  fInv : Relation.Rq
  laws : Laws env frontier.base.loopOut.state vectors h fInv
  observed : KeygenSecretObserved081.ObservedSecret env.args.privkey env.args.privkeyLen out.state.heap (packet vectors)
  decoded : KeygenSecretPacket081.DecodeSecret (packet vectors)=some (vectors 0,vectors 1,vectors 2,vectors 3)
  publicAtSuffix : KeygenPublicNormalizePolynomial.Represents frontier.tail.suffixState.heap (publicOf env) h
  publicProfile : KeygenCodecProfile.Profile env frontier.tail.suffixState
  certificate : SameCertificate env caller out frontier.base vectors h

theorem observed_secret (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (legal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (source : KeygenSecretInvocation134.PinnedExec env caller out)
    (success : out.flow=.returned (some (.int32 1))) : Nonempty (Output env caller out) := by
  obtain ⟨frontier⟩ := KeygenSecretInvocation134.successful_frontier env caller out primes rev legal source success
  have separate := KeygenOutputMemory134.separation env caller out frontier.base buffers
  have inputs := KeygenOutputMemory134.material_legal env caller out primes rev frontier.base legal
  obtain ⟨v,h,fInv,laws,privateObserved,decoded,hSuffix⟩ := KeygenSecretLocal081.private_output env
    frontier.base.loopOut.state frontier.base.tailOut frontier.tail frontier.base.cells comp separate frontier.addresses
    inputs frontier.base.material
  have tailObserved := KeygenSecretLocal081.through_public env frontier.base.loopOut.state frontier.base.tailOut frontier.tail
    separate (packet v) privateObserved
  have actualObserved := KeygenOutputMemory134.after_return env caller out frontier.base buffers (packet v) tailObserved
  have profile := KeygenCodecProfile.encoding_profile env _ frontier.base.loopOut.state ⟨frontier.tail.suffixState,.normal⟩
    frontier.tail.privateRun ⟨frontier.base.cells.logn,frontier.base.cells.ter,frontier.base.cells.comp⟩
  exact ⟨⟨frontier,v,h,fInv,laws,actualObserved,decoded,hSuffix,profile,
    certificate_material env caller out frontier.base v h fInv laws⟩⟩

theorem length_bounds (env : Env) (caller : State) (out : Result) (result : Output env caller out) :
    7681≤(packet result.vectors).length ∧ (packet result.vectors).length≤10369 := by
  have bounds := result.laws.2.1
  have fLength := KeygenInt16Bounds076.fg_length (result.vectors 0) bounds.1
  have gLength := KeygenInt16Bounds076.fg_length (result.vectors 1) bounds.2.1
  have bigFLength := KeygenInt16Bounds076.big_length (result.vectors 2) bounds.2.2.1
  have bigGLength := KeygenInt16Bounds076.big_length (result.vectors 3) bounds.2.2.2
  have bigFLower := (KeygenCodecStaticLength.profile_bounds _ (KeygenInt16Representation076.wordList_length (result.vectors 2))).1
  have bigGLower := (KeygenCodecStaticLength.profile_bounds _ (KeygenInt16Representation076.wordList_length (result.vectors 3))).1
  rw [packet,KeygenSecretPacket081.packet_length,fLength,gLength]
  omega

end FT1536.Source3.KeygenSecretComplete134
