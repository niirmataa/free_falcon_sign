import Source3.KeygenPublicObserved077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicCallerComplete077
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env publicOf)
open KeygenCodecExecution (byteOff)
open KeygenPublicCallerSite077 (Site)
open KeygenPublicCallerExecution077 (Encoding code)
open KeygenPublicObserved077 (ObservedPublic)

/-- Actual M0 caller cells and legal input capacity/memory only. -/
structure Legal (env : Env) (s : State) (capacity : BitVec 64) : Prop where
  profile : KeygenCodecProfile.Profile env s
  capacityRead : Load64 s.heap env.args.pubkeyLen capacity
  capacityBound : 2881≤capacity.toNat
  payloadLegal : KeygenPublicEncodeReady077.WritableBytes s.heap (byteOff env.args.pubkey 1) 2880
  materialSeparate : (publicOf env).block≠env.args.pubkey.block
  lengthSeparate : env.args.pubkey.block≠env.args.pubkeyLen.block

theorem observed_output (env : Env) (s : State) (out : Result) (calls : List (Site env))
    (capacity : BitVec 64) (h : Relation.Rq) (legal : Legal env s capacity)
    (represented : KeygenPublicNormalizePolynomial.Represents s.heap (publicOf env) h)
    (source : Encoding env code s out calls) (success : out.flow=.returned (some (.int32 1))) :
    ∃ packet, ObservedPublic env.args.pubkey env.args.pubkeyLen out.state.heap packet ∧ packet.length=2881 ∧
      KeygenPublicPacket077.DecodePublic packet=some h ∧ ∃ c : Site env, calls=[c] ∧ c.ret=2880 := by
  obtain ⟨c,actualCapacity,called,load,capacityEq,logn,header,lengthStore⟩ :=
    KeygenPublicCallerTrace077.trace env s out calls legal.profile source success
  have sameCapacity := load64_deterministic s.heap env.args.pubkeyLen actualCapacity capacity load legal.capacityRead
  have enough : 2881≤c.site.klen.toNat := by rw [capacityEq,sameCapacity]; exact legal.capacityBound
  have sameH := KeygenPublicObserved077.material_after_header s.heap c.before.heap env.args.pubkey (publicOf env) h
    legal.materialSeparate represented header
  have payloadLegal := KeygenPublicEncodeReady077.writable_preserved s.heap c.before.heap (byteOff env.args.pubkey 1)
    (byteOff env.args.pubkey 0) 2880 138 legal.payloadLegal header
  obtain ⟨returned,inputs,count,canonical,realizes,trace⟩ := KeygenPublicCallerSite077.source_output env c h
    logn enough sameH payloadLegal legal.materialSeparate
  have payloadLength := (KeygenPublicBits077.source_profile_lengths inputs count).1
  have exactStore : Store64 c.after env.args.pubkeyLen
      (BitVec.ofNat 64 ((KeygenPublicBits077.encoded inputs).length+1)) out.state.heap := by
    rw [returned,KeygenPublicCallerSite077.length_value] at lengthStore
    rw [payloadLength]
    exact lengthStore
  have observed := KeygenPublicObserved077.packet_observed s.heap c.before.heap c.after out.state.heap env.args.pubkey env.args.pubkeyLen
    (KeygenPublicBits077.encoded inputs) (by rw [payloadLength]; decide +kernel) legal.lengthSeparate header trace exactStore
  refine ⟨138::KeygenPublicBits077.encoded inputs,observed,?_,?_,c,called,returned⟩
  · rw [List.length_cons,payloadLength]
  · simpa only [List.append_nil] using KeygenPublicPacket077.decode_honest inputs h [] count canonical realizes

/-- DecodePublic is applied to independently OBSERVED final bytes. Their
    agreement with the source-produced packet is a conclusion. -/
theorem actual_observed_decode (env : Env) (s : State) (out : Result) (calls : List (Site env))
    (capacity : BitVec 64) (h : Relation.Rq) (legal : Legal env s capacity)
    (represented : KeygenPublicNormalizePolynomial.Represents s.heap (publicOf env) h)
    (source : Encoding env code s out calls) (success : out.flow=.returned (some (.int32 1)))
    (packet : List (BitVec 8)) (observed : ObservedPublic env.args.pubkey env.args.pubkeyLen out.state.heap packet) :
    packet.length=2881 ∧ KeygenPublicPacket077.DecodePublic packet=some h ∧
      ∃ c : Site env, calls=[c] ∧ c.ret=2880 := by
  obtain ⟨actual,actualObserved,length,decoded,call⟩ := observed_output env s out calls capacity h legal represented source success
  have same := KeygenPublicObserved077.observed_unique env.args.pubkey env.args.pubkeyLen out.state.heap packet actual observed actualObserved
  subst packet
  exact ⟨length,decoded,call⟩

/-- SAME local source material witness and SAME public/inverse equations.
    The root accepted-attempt to this suffix entry remains the explicit
    B1.07 assembly obligation; it is not silently supplied here. -/
theorem from_witness (env : Env) (s : State) (out : Result) (calls : List (Site env)) (input : Fin 4 → ArrayPointer)
    (capacity : BitVec 64) (legal : Legal env s capacity)
    (witness : KeygenMakeMaterialWitness.Witness s.heap input (publicOf env))
    (source : Encoding env code s out calls) (success : out.flow=.returned (some (.int32 1)))
    (packet : List (BitVec 8)) (observed : ObservedPublic env.args.pubkey env.args.pubkeyLen out.state.heap packet) :
    packet.length=2881 ∧ ∃ (fv gv F G : Geometry.Vec) (h fInv : Relation.Rq),
      KeygenMaterial.Represents s.heap (input 0) fv ∧ KeygenMaterial.Represents s.heap (input 1) gv ∧
      KeygenMaterial.Represents s.heap (input 2) F ∧ KeygenMaterial.Represents s.heap (input 3) G ∧
      KeygenPublicNormalizePolynomial.Represents s.heap (publicOf env) h ∧ KeygenPublicPacket077.DecodePublic packet=some h ∧
      KeygenSolverEquation.Bounds (KeygenOutputGateValidation.material fv gv F G) ∧
      KeygenSolverEquation.Equation (KeygenOutputGateValidation.material fv gv F G) ∧
      Relation.mulRq h (Relation.reduceVec fv)=Relation.reduceVec gv ∧
      Relation.mulRq fInv (Relation.reduceVec fv)=FT1536.Run2.CoefficientQuotient.constantCoeffs (1 : KeygenPublicAlgebra.R) := by
  obtain ⟨fv,gv,F,G,h,fInv,fRep,gRep,FRep,GRep,hRep,bounds,ntru,publicEq,inverse⟩ := witness
  have result := actual_observed_decode env s out calls capacity h legal hRep source success packet observed
  exact ⟨result.1,fv,gv,F,G,h,fInv,fRep,gRep,FRep,GRep,hRep,result.2.1,bounds,ntru,publicEq,inverse⟩

end FT1536.Source3.KeygenPublicCallerComplete077
