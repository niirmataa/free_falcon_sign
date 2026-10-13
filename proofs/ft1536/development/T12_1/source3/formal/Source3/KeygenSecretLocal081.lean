import Source3.KeygenSecretTailSource081
import Source3.KeygenSecretObserved081
import Source3.KeygenPublicSuffixFrame081

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretLocal081
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env inputOf publicOf)
open KeygenInt16FourMaterial076 (Vectors Legal Represented)
open KeygenInt16Representation076 (wordList wordList_length)
open KeygenSecretTailSource081 (Source Addresses)
open KeygenSecretObserved081 (ObservedSecret)
open ShakeExtractFrame (SameBlock)

structure Separation (env : Env) : Prop where
  inputPrivate : ∀ slot, (inputOf env slot).block≠env.args.privkey.block
  inputSke : ∀ slot, (inputOf env slot).block≠env.blocks 5
  privateSke : env.args.privkey.block≠env.blocks 5
  privateLength : env.args.privkey.block≠env.args.privkeyLen.block
  privatePublic : env.args.privkey.block≠env.args.pubkey.block
  privatePublicLength : env.args.privkey.block≠env.args.pubkeyLen.block
  lengthPublic : env.args.privkeyLen.block≠env.args.pubkey.block
  lengthPublicLength : env.args.privkeyLen.block≠env.args.pubkeyLen.block
  hPrivate : (publicOf env).block≠env.args.privkey.block
  hSke : (publicOf env).block≠env.blocks 5
  hLength : (publicOf env).block≠env.args.privkeyLen.block

def packet (v : Vectors) : List (BitVec 8) := KeygenSecretPacket081.packet (v 0) (v 1) (v 2) (v 3)

def Laws (env : Env) (s : State) (v : Vectors) (h fInv : Relation.Rq) : Prop :=
  Represented s.heap (inputOf env) v ∧ KeygenSolverEquation.Bounds v ∧ KeygenSolverEquation.Equation v ∧
  KeygenPublicNormalizePolynomial.Represents s.heap (publicOf env) h ∧
  Relation.mulRq h (Relation.reduceVec (v 0))=Relation.reduceVec (v 1) ∧
  Relation.mulRq fInv (Relation.reduceVec (v 0))=
    FT1536.Run2.CoefficientQuotient.constantCoeffs (1 : KeygenPublicAlgebra.R)

theorem trace_foreign (before after : Memory) (ptr : ArrayPointer) (n : Nat) (bytes : List (BitVec 8))
    (trace : KeygenCodecByteHistory.Trace before after (KeygenCodecStaticHistory.positions (some ptr) n bytes))
    (block : Nat) (separate : block≠ptr.block) : SameBlock before after block := by
  have away : ∀ write∈KeygenCodecStaticHistory.positions (some ptr) n bytes, block≠write.1.block := by
    clear trace
    induction bytes generalizing n with
    | nil => intro write member; cases member
    | cons byte rest ih =>
      intro write member
      change write∈(KeygenCodecExecution.byteOff ptr n,byte)::KeygenCodecStaticHistory.positions (some ptr) (n+1) rest at member
      rcases List.mem_cons.mp member with equal | member
      · subst write; exact separate
      · exact ih (n+1) write member
  exact ⟨KeygenCodecStaticMaterial.trace_sizes _ _ _ trace,
    KeygenCodecStaticWire.trace_writable _ _ _ trace,
    fun offset => KeygenCodecByteHistory.outside _ _ _ trace block offset
      (fun write member => Or.inl (away write member))⟩

/-- The whole secret packet after the actual length store, with SAME
    original material and preserved h for the following public encoder. -/
theorem private_output (env : Env) (s : State) (out : Result) (source : Source env s out)
    (cells : KeygenMakeInvocation.TailCells env s) (comp : env.args.comp=1)
    (separate : Separation env) (addressed : Addresses env s out source)
    (legal : Legal s.heap (inputOf env))
    (witness : KeygenMakeMaterialWitness.Witness s.heap (inputOf env) (publicOf env)) :
    ∃ (v : Vectors) (h fInv : Relation.Rq), Laws env s v h fInv ∧
      ObservedSecret env.args.privkey env.args.privkeyLen source.suffixState.heap (packet v) ∧
      KeygenSecretPacket081.DecodeSecret (packet v)=some (v 0,v 1,v 2,v 3) ∧
      KeygenPublicNormalizePolynomial.Represents source.suffixState.heap (publicOf env) h := by
  obtain ⟨v,h,fInv,represented,physical,signed,carrier,bounds,equation,hRep,publicEq,inverseEq⟩ :=
    KeygenInt16FourMaterial076.from_witness s.heap (inputOf env) (publicOf env) legal witness
  have headLegal := KeygenSerializationEntry079.prefix_legal env s ⟨source.headState,.normal⟩ source.prelude rfl
    separate.inputPrivate separate.inputSke legal
  have headMaterial : Represented source.headState.heap (inputOf env) v := by
    intro slot
    exact KeygenMakeCertMaterial.represents_same s.heap source.headState.heap (inputOf env slot) (v slot)
      (KeygenSerializationEntry079.prefix_frame env _ s ⟨source.headState,.normal⟩ _ source.prelude
        (fun _ member => member) rfl (separate.inputPrivate slot) (separate.inputSke slot)) (represented slot)
  have calls := KeygenInt16Caller076.chain_transport env s ⟨source.headState,.normal⟩ ⟨source.segmentState,.normal⟩
    source.privateCalls cells source.prelude rfl source.segments rfl comp separate.inputPrivate separate.privateSke
    addressed v headLegal headMaterial
  have header := KeygenSecretPrelude081.prelude env s ⟨source.headState,.normal⟩ cells source.prelude rfl comp separate.privateSke
  let inputs : Fin 4 → List (BitVec 16) := fun slot => wordList (v slot)
  have lengthBound := KeygenSecretChain081.length_bound inputs (fun slot => wordList_length (v slot)) 0
  have trace := KeygenSecretChain081.source_trace env 0 (KeygenMakeInvocation.initCounter source.headState)
    ⟨source.segmentState,.normal⟩ source.privateCalls source.segments inputs 1 header.1 (by omega)
    (fun c member => ⟨(calls.2.2 c member).2.2.2.1,(calls.2.2 c member).2.2.2.2⟩) rfl
  obtain ⟨skoff,cell,store⟩ := KeygenSecretCallerTrace081.length_store env source.segmentState source.suffixState source.lengthHead
  have lengthEq : skoff=BitVec.ofNat 64 (1+(KeygenSecretChain081.bytes inputs 0).length) := by
    simpa using cell.symm.trans trace.2
  rw [lengthEq,Nat.add_comm 1] at store
  have observed := KeygenSecretObserved081.packet_observed source.headState.heap source.segmentState.heap source.suffixState.heap
    env.args.privkey env.args.privkeyLen (KeygenSecretChain081.bytes inputs 0) (by omega) separate.privateLength header.2 trace.1 store
  have packetEq : 170::KeygenSecretChain081.bytes inputs 0=packet v := by
    rw [KeygenSecretChain081.bytes_zero]
    rfl
  rw [packetEq] at observed
  have beforeH := KeygenSerializationEntry079.prefix_frame env _ s ⟨source.headState,.normal⟩ (publicOf env).block
    source.prelude (fun _ member => member) rfl separate.hPrivate separate.hSke
  have middleH := trace_foreign source.headState.heap source.segmentState.heap env.args.privkey 1
    (KeygenSecretChain081.bytes inputs 0) trace.1 (publicOf env).block separate.hPrivate
  have afterH : SameBlock source.segmentState.heap source.suffixState.heap (publicOf env).block :=
    ⟨store.2.2.2.1,store.2.2.2.2.1,fun offset => store.2.2.2.2.2.2 _ offset (Or.inl separate.hLength)⟩
  have hSuffix := KeygenMakeCertMaterial.public_represents_same s.heap source.suffixState.heap (publicOf env) h
    (KeygenPublicForeign081.same_trans _ _ _ _ beforeH (KeygenPublicForeign081.same_trans _ _ _ _ middleH afterH)) hRep
  exact ⟨v,h,fInv,⟨represented,bounds,equation,hRep,publicEq,inverseEq⟩,observed,
    KeygenSecretPacket081.decode_honest (v 0) (v 1) (v 2) (v 3) (signed 0) (signed 1) (signed 2) (signed 3),hSuffix⟩

theorem through_public (env : Env) (s : State) (out : Result) (source : Source env s out)
    (separate : Separation env) (bytes : List (BitVec 8))
    (observed : ObservedSecret env.args.privkey env.args.privkeyLen source.suffixState.heap bytes) :
    ObservedSecret env.args.privkey env.args.privkeyLen out.state.heap bytes := by
  have buffer := KeygenPublicSuffixFrame081.encoding_frame env _ source.suffixState out source.publicCalls source.publicRun
    (fun _ member => member) env.args.privkey.block separate.privatePublic separate.privatePublicLength
  have length := KeygenPublicSuffixFrame081.encoding_frame env _ source.suffixState out source.publicCalls source.publicRun
    (fun _ member => member) env.args.privkeyLen.block separate.lengthPublic separate.lengthPublicLength
  exact KeygenSecretObserved081.preserved _ _ _ _ bytes
    ⟨congrFun buffer.1 _,congrFun buffer.2.1 _,buffer.2.2⟩
    ⟨congrFun length.1 _,congrFun length.2.1 _,length.2.2⟩ observed

end FT1536.Source3.KeygenSecretLocal081
