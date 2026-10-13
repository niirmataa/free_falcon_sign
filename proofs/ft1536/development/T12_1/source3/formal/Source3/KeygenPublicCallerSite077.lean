import Source3.KeygenPublicMath077
import Source3.KeygenCodecInvocation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicCallerSite077
open C99MemoryReference
open C99ArrayReference (State)
open KeygenMakeInvocation (Env PublicSite publicOf byteOff assign)

/-- Exactly the four source call arguments. The shared reference record's
    q/comp cells are unused metadata, not extra public C parameters. -/
def arguments (env : Env) (s : State) (after : Memory) (ret : BitVec 64)
    (site : PublicSite env .encodeT s after ret) : KeygenCodecValues.Args :=
  { out := some (byteOff env.args.pubkey 1), capacity := site.klen-1,
    comp := 0, q := 0, x := some (publicOf env), logn := site.logn }
structure Site (env : Env) where
  before : State
  after : Memory
  ret : BitVec 64
  site : PublicSite env .encodeT before after ret
  execution : KeygenPublicEncodeExecution077.Call (arguments env before after ret site) before.heap after ret
def nextState (c : Site env) : State := assign {c.before with heap := c.after} "klen".toList .uint64 (.uint64 c.ret)

theorem call_source : KeygenMakeBinding.node253=
    .write (.variable "klen".toList) .set (KeygenMakeProgram.publicCall .encodeT) := rfl
theorem header_source : KeygenMakeBinding.node252=KeygenMakeInvocation.pkHeader := rfl
theorem length_source : KeygenMakeBinding.node267=KeygenMakeInvocation.pubkeyLenWrite := rfl
theorem header_value : BitVec.setWidth 8 (((1 : BitVec 32) <<< 7)+10)=(138 : BitVec 8) := by decide +kernel
theorem length_value : (2880 : BitVec 64)+1=2881 := by decide +kernel

theorem capacity (klen : BitVec 64) (enough : 2881≤klen.toNat) : 2880≤(klen-1).toNat := by
  have representation : klen=BitVec.ofNat 64 klen.toNat := by rw [BitVec.ofNat_toNat,BitVec.setWidth_eq]
  have eq : klen-1=BitVec.ofNat 64 (klen.toNat-1) := by
    conv_lhs => rw [representation,show (1 : BitVec 64)=BitVec.ofNat 64 1 by decide +kernel]
    exact BitVec.ofNat_sub_ofNat_of_le klen.toNat 1 (by decide +kernel) (by omega)
  rw [eq,BitVec.toNat_ofNat,Nat.mod_eq_of_lt (show klen.toNat-1<2^64 by have bound:=klen.isLt; omega)]
  omega

theorem source_output (env : Env) (c : Site env) (h : Relation.Rq)
    (lognM0 : c.site.logn=10) (enough : 2881≤c.site.klen.toNat)
    (represented : KeygenPublicNormalizePolynomial.Represents c.before.heap (publicOf env) h)
    (legal : KeygenPublicEncodeReady077.WritableBytes c.before.heap (byteOff env.args.pubkey 1) 2880)
    (separate : (publicOf env).block≠env.args.pubkey.block) :
    c.ret=2880 ∧ ∃ inputs, inputs.length=1536 ∧ KeygenPublicBits077.Canonical inputs ∧
      KeygenPublicMaterial077.Realizes inputs h ∧ KeygenCodecByteHistory.Trace c.before.heap c.after
        (KeygenCodecStaticHistory.positions (some (byteOff env.args.pubkey 1)) 0 (KeygenPublicBits077.encoded inputs)) := by
  obtain ⟨inputs,count,canonical,words,realizes⟩ := KeygenPublicMaterial077.represented_words c.before.heap (publicOf env) h represented
  obtain ⟨returned,trace⟩ := KeygenPublicEncodeComplete077.source_outcome (arguments env c.before c.after c.ret c.site)
    c.before.heap c.after c.ret (byteOff env.args.pubkey 1) (publicOf env) inputs lognM0 rfl rfl count
    (capacity c.site.klen enough) words legal separate c.execution
  exact ⟨returned,inputs,count,canonical,realizes,trace⟩

end FT1536.Source3.KeygenPublicCallerSite077
