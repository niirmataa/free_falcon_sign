import Source3.CertificateFunctionFrame
import Source3.CertificateReturnedWords
import Source3.CertificateFunctionSyntax

namespace FT1536.Source3.CertificateFunctionOutcome
open C99MemoryReference
open CertificateFunctionReference
open CertificateFunctionWitness (Witness layout)

def StoredBounds (args : Arguments) (caller after : Memory) : Prop :=
  ∀ i<1536, ∃ word, StableBinaryByteView.wordRead (C99MemoryBridge.encode after)
      (StableBinary.addr (CertificateMemory.leaves (layout args caller)) i)=some word ∧
    Run2.KeygenLeafGate.positive word=true ∧ Run2.KeygenLeafGate.lowerBits.toNat≤word.toNat ∧
    word.toNat≤Run2.KeygenLeafGate.upperBits.toNat ∧
    (1024 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue word ∧
    Run2.KeygenLeafGate.positiveNormalValue word<(332054 : ℝ)

def CallerFrame (args : Arguments) (environment : Environment) (caller after : Memory) : Prop :=
  ∀ block offset, offset<caller.size block → CertificateRegionFrame.Outside args.base block offset →
    C99PointerFootprint.TablesOutside (initial args environment caller) block offset →
      after.bytes block offset=caller.bytes block offset

theorem accepted (args : Arguments) (environment : Environment) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event)
    (profile : Profile args) (legal : CertificateFrameEntry.Legal args.base caller)
    (source : Exec args environment caller after gateTrace events true) :
    CertificateFunctionSyntax.Bound ∧
    StoredBounds args caller after ∧ CallerFrame args environment caller after ∧
    (∀ value, ¬Load32 after (C99Automatic32.pointer caller) value) ∧
    gateTrace.length=768 ∧
    (∀ word∈gateTrace, Run2.KeygenLeafGate.positive word=true ∧
      (1/2 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue word) ∧
    (∀ event∈events, CertificateEffects.Good event) ∧
    ∃ snapshot : Witness args caller after gateTrace events true,
      StableBinaryByteView.flagRead (C99MemoryBridge.encode snapshot.edge) (layout args caller).bad=some 0 := by
  obtain ⟨snapshot,count,gate,checks,clear,_⟩ := CertificateFunctionWitness.accepted
    args environment caller after gateTrace events profile legal source
  refine ⟨CertificateFunctionSyntax.bound,
    CertificateReturnedWords.accepted_stored_words args environment caller after gateTrace events profile legal source,
    ?_,CertificateFunctionReference.bad_dead_after_return args environment caller after gateTrace events true source,
    count,gate,checks,snapshot,clear⟩
  exact CertificateFunctionFrame.source_frame args environment caller after gateTrace events true profile legal source

theorem reverse_source (args : Arguments) (environment : Environment) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event)
    (profile : Profile args) (legal : CertificateFrameEntry.Legal args.base caller)
    (source : Exec args environment caller after gateTrace events true) :
    ∃ snapshot : Witness args caller after gateTrace events true,
      ∃ (topState reverseState : CertificateEffects.State) (words : Fin 768 → BitVec 64),
        CertificateReverse.Snapshot (layout args caller) words topState ∧
        CertificateReverse.Snapshot (layout args caller) words reverseState ∧
        (∀ i : Fin 768, CertificateAtoms.read (layout args caller)
            (CertificateEffects.encode ⟨snapshot.edge,events⟩) i.val=some (words i) ∧
          ∃ raw, C99Frontend.primitiveCall "fpr_div".toList
            [.uint64 CertificateQSquared.word,.uint64 (words i)] (.uint64 raw) ∧
            CertificateAtoms.read (layout args caller) (CertificateEffects.encode ⟨snapshot.edge,events⟩)
              (1535-i.val)=some raw ∧ Run2.KeygenLeafGate.positive raw=true) := by
  obtain ⟨snapshot⟩ := CertificateFunctionWitness.from_source args environment caller after gateTrace events true profile legal source
  obtain ⟨topState,reverseState,words,_,_,_,first,second,_,division⟩ :=
    CertificateSuffix001Outcome.reverse_order (layout args caller) snapshot.gate snapshot.edge events
      snapshot.wellFormed snapshot.suffixLegal snapshot.suffix
  exact ⟨snapshot,topState,reverseState,words,first,second,division⟩

end FT1536.Source3.CertificateFunctionOutcome
