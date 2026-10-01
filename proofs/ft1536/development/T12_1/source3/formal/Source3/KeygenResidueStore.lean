import Source3.KeygenResidueProgram
import Source3.C99CountedWords
import Source3.Gate00Memory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenResidueStore
open C99MemoryReference
open C99ArrayReference (State)
open C99ModularReference (Eval Exec)
open C99ProcedureReference (Result)
open KeygenSmallOutput (element)

theorem signed_word_contract (w : BitVec 16) (value : C99IntegerReference.Value)
    (source : KeygenModpSet.SourceExec (BitVec.ofInt 32 w.toInt) KeygenNinv31.prime value) :
    ∃ out, value=.uint32 out ∧ out.toNat<KeygenNinv31.prime.toNat ∧
      (out.toNat : Int)%(KeygenNinv31.prime.toNat : Int)=w.toInt%(KeygenNinv31.prime.toNat : Int) := by
  have promoted := C99NarrowReads.signed_promotion_exact w
  change (BitVec.ofInt 32 w.toInt).toInt=w.toInt at promoted
  have lower : -(KeygenNinv31.prime.toNat : Int)<(BitVec.ofInt 32 w.toInt).toInt := by
    rw [promoted]
    have hw := w.le_toInt
    change -(2147355649 : Int)<w.toInt
    norm_num at hw
    omega
  have upper : (BitVec.ofInt 32 w.toInt).toInt<(KeygenNinv31.prime.toNat : Int) := by
    rw [promoted]
    have hw := w.toInt_lt
    change w.toInt<(2147355649 : Int)
    norm_num at hw
    omega
  obtain ⟨out,he,range,congruence⟩ := KeygenModpSet.source_contract _ KeygenNinv31.prime value
    (by decide) lower upper source
  rw [promoted] at congruence
  exact ⟨out,he,range,congruence⟩

theorem expression_result (before : State) (sourceName : String) (src : ArrayPointer) (i : Nat)
    (value : C99IntegerReference.Value) (hi : i≤1536) (counter : C99CountedWords.Counter before i)
    (binding : before.arrays sourceName.toList=some src)
    (prime : before.locals "p".toList=some (.uint32,some (.uint32 KeygenNinv31.prime)))
    (source : Eval before (KeygenResidueProgram.conversion sourceName) value) :
    ∃ (input : BitVec 16) (out : BitVec 32), value=.uint32 out ∧
      C99NarrowReads.Load16 before.heap (element src i) input ∧ out.toNat<KeygenNinv31.prime.toNat ∧
      (out.toNat : Int)%(KeygenNinv31.prime.toNat : Int)=input.toInt%(KeygenNinv31.prime.toNat : Int) := by
  cases source with
  | call2 name a b x y out first second call =>
      have hp : y=.uint32 KeygenNinv31.prime := by
        cases second with
        | scalar _ _ hs => exact C99CountedWords.variable_exact before "p".toList .uint32 (.uint32 KeygenNinv31.prime) y prime hs
      subst y
      cases first with
      | load16 _ _ ptr word address read =>
          have hptr := C99CountedWords.pointer_exact before sourceName.toList src ptr i hi counter binding address
          rw [hptr] at read
          cases call with
          | set args value body =>
              obtain ⟨out,he,range,congruence⟩ := signed_word_contract word value body
              exact ⟨word,out,he,read,range,congruence⟩

theorem source_result (before : State) (result : Result) (destination sourceName : String)
    (dst src : ArrayPointer) (i : Nat) (hi : i≤1536) (counter : C99CountedWords.Counter before i)
    (hd : before.arrays destination.toList=some dst) (hs : before.arrays sourceName.toList=some src)
    (prime : before.locals "p".toList=some (.uint32,some (.uint32 KeygenNinv31.prime)))
    (source : Exec (KeygenResidueProgram.store destination sourceName) before result) :
    ∃ (input : BitVec 16) (out : BitVec 32),
      result=⟨{before with heap := result.state.heap},.normal⟩ ∧
      C99NarrowReads.Load16 before.heap (element src i) input ∧
      Store32 before.heap (element dst i) out result.state.heap ∧
      out.toNat<KeygenNinv31.prime.toNat ∧
      (out.toNat : Int)%(KeygenNinv31.prime.toNat : Int)=input.toInt%(KeygenNinv31.prime.toNat : Int) := by
  cases source with
  | store32 name index e before after ptr value address evaluated write =>
      have hp := C99CountedWords.pointer_exact before destination.toList dst ptr i hi counter hd address
      rw [hp] at write
      obtain ⟨input,out,hv,read,range,congruence⟩ := expression_result before sourceName src i value hi counter hs prime evaluated
      subst value
      refine ⟨input,out,rfl,read,?_,range,congruence⟩
      simpa [C99IntegerReference.Value.integer,element] using write

theorem written_word (before after : Memory) (p : ArrayPointer) (word : BitVec 32)
    (write : Store32 before p word after) : Load32 after p word := by
  have allocated : Allocated after p := by simpa only [Allocated,write.2.2.2.1] using write.1
  have join : le32 (byte32 word)=word := StableBinaryByteView.flag_join_bytes word
  rw [← join]
  exact Load32.load after p (byte32 word) allocated write.2.1 write.2.2.2.2.2.1

end FT1536.Source3.KeygenResidueStore
