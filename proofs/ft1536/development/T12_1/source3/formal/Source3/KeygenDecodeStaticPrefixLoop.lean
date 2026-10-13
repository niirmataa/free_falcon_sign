import Source3.KeygenDecodeStaticRefill
import Source3.KeygenDecodeStaticWire
import Source3.KeygenDecodeStaticCertifiedLoop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete honest prefix-refill while loop: availability follows from
   the real unread byte extent and the bits still needed by the decoder. -/
namespace FT1536.Source3.KeygenDecodeStaticPrefixLoop
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenDecodeStaticCertified KeygenDecodeStaticReady
open KeygenDecodeStaticWire KeygenCodecStaticBitBuffer

theorem test_calculation (args : Args) (s : State) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (limit : p≤16) (ready : Ready args src dst v p db s) :
    KeygenDecodeCalculation.Computes args s.heap s.buf s.locals KeygenDecodeStaticBinding.guard038
      (C99ScalarReference.boolean (decide (p≤8))) := by
  apply KeygenDecodeCalculation.Computes.binary _ _ _ _ _ _
    (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) ready.pending)
    (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) ready.context.j)
  apply BinaryOp.le
  simpa only [C99IntegerReference.compare,Int.ofNat_le,show (8#32 : BitVec 32)=8 by decide +kernel] using
    KeygenDecodeStaticCounterOps.compare32 .le p 8 (by omega) (by decide +kernel)

theorem loop (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (limit : p≤16)
    (wire : Wire args src dst v p db bytes s) (needed : 9≤(remaining p db bytes).length) :
    ∃ k p' db' bytes' t,
      Checked args KeygenDecodeStaticBinding.node038 s t .normal ∧
      Wire args src dst (v+k) p' db' bytes' t ∧ p'=p+8*k ∧ 9≤p' ∧ p'≤16 ∧
      remaining p' db' bytes'=remaining p db bytes ∧ t.heap=s.heap := by
  generalize depthEq : 9-p=depth
  induction depth using Nat.strong_induction_on generalizing v p db bytes s with
  | h depth ih =>
    have test := test_calculation args s src dst v p db limit wire.ready
    by_cases enough : 8<p
    · have falseTest : truth (.integer (C99ScalarReference.boolean (decide (p≤8))))=false := by
        rw [KeygenDecodeStaticCounterOps.boolean_truth]
        simp only [show ¬p≤8 by omega,decide_false]
      have source := KeygenDecodeStaticCertifiedLoop.done args KeygenDecodeStaticBinding.guard038
        KeygenDecodeStaticBinding.node037 s _ s.locals (.pure _ _ _ test) falseTest
      have same : withLocals s s.locals=s := by cases s; rfl
      rw [same] at source
      exact ⟨0,p,db,bytes,s,source,by simpa only [Nat.add_zero] using wire,by omega,by omega,limit,rfl,rfl⟩
    · have small : p≤8 := by omega
      have trueTest : truth (.integer (C99ScalarReference.boolean (decide (p≤8))))=true := by
        rw [KeygenDecodeStaticCounterOps.boolean_truth]
        simp only [small,decide_true]
      cases bytes with
      | nil =>
        simp only [remaining,bytesBits,List.flatMap_nil,List.append_nil,buffer_length] at needed
        omega
      | cons byte rest =>
        have available : v<args.len.toNat := by
          have extent:=wire.extent
          simp only [List.length_cons] at extent
          omega
        obtain ⟨atByte,advance,load⟩ := head s.heap src v byte rest wire.reads
        obtain ⟨body,nextReady,heap⟩ := KeygenDecodeStaticRefill.body args s src dst atByte v p db byte
          available wire.ready advance load
        let next := KeygenDecodeStaticRefill.afterRefill s v p db byte
        let nextDb := (db <<< 8)+byte.setWidth 32
        have nextWire : Wire args src dst (v+1) (p+8) nextDb rest next := by
          refine ⟨nextReady,?_,?_⟩
          · rw [heap]
            exact tail s.heap src v byte rest wire.reads
          · have extent:=wire.extent
            simp only [List.length_cons] at extent
            omega
        have sameBits : remaining (p+8) nextDb rest=remaining p db (byte::rest) :=
          refill_remaining p db byte rest (by omega)
        have nextNeeded : 9≤(remaining (p+8) nextDb rest).length := by rw [sameBits]; exact needed
        obtain ⟨k,p',db',bytes',t,restSource,lastWire,pending,lower,upper,bits,lastHeap⟩ :=
          ih (9-(p+8)) (by omega) (v+1) (p+8) nextDb rest next (by omega) nextWire nextNeeded rfl
        have same : withLocals s s.locals=s := by cases s; rfl
        have body' : Checked args KeygenDecodeStaticBinding.node037 (withLocals s s.locals) next .normal := by rw [same]; exact body
        have source := KeygenDecodeStaticCertifiedLoop.next args KeygenDecodeStaticBinding.guard038
          KeygenDecodeStaticBinding.node037 s next t .normal _ s.locals (.pure _ _ _ test) trueTest body' restSource
        refine ⟨k+1,p',db',bytes',t,source,?_,?_,lower,upper,bits.trans sameBits,lastHeap.trans heap⟩
        · simpa only [show v+(k+1)=v+1+k by omega] using lastWire
        · omega

end FT1536.Source3.KeygenDecodeStaticPrefixLoop
