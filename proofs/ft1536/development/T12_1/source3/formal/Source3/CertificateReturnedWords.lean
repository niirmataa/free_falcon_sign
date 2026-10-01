import Source3.CertificateFunctionWitness
import Source3.C99AutomaticReadback

namespace FT1536.Source3.CertificateReturnedWords
open C99MemoryReference C99InitializationTrace
open CertificateFunctionReference
open CertificateFunctionWitness

theorem edge_workspace (args : Arguments) (caller after : Memory) (gateTrace : List (BitVec 64))
    (events : List CertificateEffects.Event) (ret : Bool) (w : Witness args caller after gateTrace events ret) :
    CertificateWorkspace.Legal args.base (C99Automatic32.address caller) w.edge := by
  have steps := steps_trans w.converted.heap w.prefixState.heap w.gate
    (C99ProcedureReference.memory_steps _ _ _ _ w.prefixExec)
    (Gate00Initialization.loop_memory_steps _ _ _ _ _ w.gateExec)
  have gateLegal := CertificateWorkspace.legal_preserved args.base (C99Automatic32.address caller)
    w.converted.heap w.gate w.entry.workspace (steps_preserve _ _ steps)
  have suffix := CertificateSuffix001Outcome.source_outcome (layout args caller) w.gate w.edge events ret
    w.wellFormed w.suffixLegal w.suffix
  refine ⟨gateLegal.baseAligned,gateLegal.badAligned,?_,?_,?_,?_,gateLegal.separateBad⟩
  · rw [suffix.1]; exact gateLegal.workspaceExtent
  · rw [suffix.1]; exact gateLegal.badExtent
  · rw [suffix.1]; exact gateLegal.addressBound
  · rw [suffix.2.1]; exact gateLegal.writable

theorem leaf_allocated (args : Arguments) (caller h : Memory) (i : Nat) (hi : i<1536)
    (aligned : args.base%8=0) (extent : args.base+CertificateWorkspace.bytes≤h.size 0) (small : h.size 0<2^64) :
    Allocated h (CertificateMemory.leafPtr (layout args caller) i) := by
  refine ⟨by change 0<8; decide,?_,hi,?_,small⟩
  · change (args.base+12288*20)%8=0
    simpa [Nat.add_mod] using aligned
  · change args.base+12288*20+8*1536≤h.size 0
    dsimp [CertificateWorkspace.bytes] at extent
    omega

theorem readback (args : Arguments) (caller after : Memory) (gateTrace : List (BitVec 64))
    (events : List CertificateEffects.Event) (ret : Bool) (w : Witness args caller after gateTrace events ret)
    (legal : CertificateFrameEntry.Legal args.base caller) (i : Nat) (hi : i<1536) (word : BitVec 64)
    (read : StableBinaryByteView.wordRead (C99MemoryBridge.encode w.edge)
      (StableBinary.addr (CertificateMemory.leaves (layout args caller)) i)=some word) :
    StableBinaryByteView.wordRead (C99MemoryBridge.encode after)
      (StableBinary.addr (CertificateMemory.leaves (layout args caller)) i)=some word := by
  have edgeLegal := edge_workspace args caller after gateTrace events ret w
  have atEdge := leaf_allocated args caller w.edge i hi edgeLegal.baseAligned edgeLegal.workspaceExtent edgeLegal.addressBound
  have asRead : Load64 w.edge (CertificateMemory.leafPtr (layout args caller) i) word :=
    (C99MemoryAccess.load64_iff w.edge _ word rfl atEdge rfl).mpr read
  have callerSmall : caller.size 0<2^64 := by
    have ha := (C99Automatic32.alignment (caller.size 0)).1
    have hs := legal.localSpace
    dsimp [C99Automatic32.Space,C99Automatic32.address] at hs
    omega
  have atCaller := leaf_allocated args caller caller i hi legal.aligned legal.workspace callerSmall
  have restored := C99AutomaticReadback.load64_after_leave caller w.edge _ word atCaller asRead
  rw [w.returned]
  exact C99MemoryBridge.load64_source_to_interpreter _ _ word rfl restored

theorem accepted_stored_words (args : Arguments) (environment : Environment) (caller after : Memory)
    (gateTrace : List (BitVec 64)) (events : List CertificateEffects.Event)
    (profile : Profile args) (legal : CertificateFrameEntry.Legal args.base caller)
    (source : CertificateFunctionReference.Exec args environment caller after gateTrace events true) :
    ∀ i<1536, ∃ word, StableBinaryByteView.wordRead (C99MemoryBridge.encode after)
        (StableBinary.addr (CertificateMemory.leaves (layout args caller)) i)=some word ∧
      Run2.KeygenLeafGate.positive word=true ∧ Run2.KeygenLeafGate.lowerBits.toNat≤word.toNat ∧
      word.toNat≤Run2.KeygenLeafGate.upperBits.toNat ∧
      (1024 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue word ∧
      Run2.KeygenLeafGate.positiveNormalValue word<(332054 : ℝ) := by
  obtain ⟨w,_,_,_,_,leaves⟩ := CertificateFunctionWitness.accepted args environment caller after gateTrace events profile legal source
  intro i hi
  obtain ⟨word,read,bounds⟩ := leaves i hi
  exact ⟨word,readback args caller after gateTrace events true w legal i hi word read,bounds⟩

end FT1536.Source3.CertificateReturnedWords
