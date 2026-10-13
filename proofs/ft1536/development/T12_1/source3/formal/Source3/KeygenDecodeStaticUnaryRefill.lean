import Source3.KeygenDecodeStaticScalarTests

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete actual conditional unary refill. A needed bit and the physical
   unread wire derive byte availability; no successful codec is assumed. -/
namespace FT1536.Source3.KeygenDecodeStaticUnaryRefill
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire
open KeygenCodecStaticBitBuffer KeygenCodecStaticBits

def afterSingle (s : State) (v : Nat) (byte : BitVec 8) : State :=
  withLocals s (localSet (KeygenDecodeStaticRead.next v s.locals) "db".toList .uint32 (some (.uint32 (byte.setWidth 32))))
def filled (s : State) (v : Nat) (byte : BitVec 8) : State :=
  withLocals (afterSingle s v byte) (localSet (afterSingle s v byte).locals "db_len".toList .uint32 (some (.uint32 8)))

theorem conditional (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (small : p≤8)
    (wire : Wire args src dst v p db bytes s) (needed : 1≤(remaining p db bytes).length) :
    ∃ v' p' db' bytes' t,
      Checked args KeygenDecodeStaticBinding.node055 s t .normal ∧
      Wire args src dst v' p' db' bytes' t ∧ 1≤p' ∧ p'≤8 ∧
      remaining p' db' bytes'=remaining p db bytes ∧ v'+bytes'.length=v+bytes.length ∧ t.heap=s.heap := by
  have test := KeygenDecodeStaticScalarTests.zero_calculation args s p (by omega) wire.ready.pending
  have same : withLocals s s.locals=s := by cases s; rfl
  by_cases empty : p=0
  · subst p
    cases bytes with
    | nil =>
      simp only [remaining,buffer,digits,bytesBits,List.flatMap_nil,List.length_nil,List.nil_append] at needed
      omega
    | cons byte rest =>
      have available : v<args.len.toNat := by
        have extent:=wire.extent
        simp only [List.length_cons] at extent
        omega
      obtain ⟨atByte,advance,load⟩ := head s.heap src v byte rest wire.reads
      let s1 := afterSingle s v byte
      let s2 := filled s v byte
      have gate := KeygenDecodeStaticInputGate.unary args s v available wire.ready.cursor wire.ready.context.length
      have read : Checked args KeygenDecodeStaticBinding.node048 s s1 .normal :=
        KeygenDecodeStaticRead.source_single args s v (by have bound:=args.len.isLt; omega)
          src atByte byte (some (.uint32 db)) wire.ready.cursor wire.ready.accumulator wire.ready.context.buffer advance load
      have oldPending := (KeygenDecodeStaticCellFrame.exec_frame "db_len".toList args _ s s1 .normal read.run (by decide +kernel)).trans wire.ready.pending
      have count : Checked args KeygenDecodeStaticBinding.node049 s1 s2 .normal := by
        have source := assign args s1 "db_len".toList .uint32 (some (.uint32 (BitVec.ofNat 32 0)))
          (.number .i32 8) (.int32 8) s1.locals (by decide +kernel) (by decide +kernel) oldPending
          (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
        have cast : C99IntegerReference.convert .uint32 (C99IntegerReference.Value.int32 8).integer=.uint32 8 := by decide +kernel
        simpa only [cast,KeygenDecodeStaticBinding.node049,filled,s2,s1] using source
      have inside : Checked args KeygenDecodeStaticBinding.node053 s s2 .normal :=
        seq args _ _ s s s2 .normal gate (seq args _ _ s s1 s2 .normal read
          (seq args _ _ s1 s2 s2 .normal count (skip args s2)))
      have wrapped : Checked args KeygenDecodeStaticBinding.node054 s s2 .normal := by
        have source := scope args KeygenDecodeStaticBinding.node053 s s2 .normal (by intro impossible; cases impossible) inside
        rw [empty_scope _ _ _ rfl] at source
        exact source
      have full : Checked args KeygenDecodeStaticBinding.node055 s s2 .normal := by
        have source := branch_true args KeygenDecodeStaticBinding.guard055 KeygenDecodeStaticBinding.node054 .skip s s2 .normal
          _ s.locals (.pure _ _ _ test) (by decide +kernel) (by rw [same]; exact wrapped)
        exact source
      have context := context_frame args src dst s s2 _ .normal full.run (by unfold KeygenDecodeStaticReady.Checks; decide +kernel) wire.ready.context
      have nextReady : Ready args src dst (v+1) 8 (byte.setWidth 32) s2 := by
        refine ⟨context,?_,?_,?_⟩
        · simp only [KeygenDecodeStaticRead.cursor,s2,filled,afterSingle,withLocals,KeygenDecodeStaticRead.next,localSet,C99ScalarReference.set]
          rfl
        · simp only [Cell,s2,filled,withLocals,localSet,C99ScalarReference.set,ite_true]
          rfl
        · simp only [Cell,s2,filled,afterSingle,withLocals,localSet,C99ScalarReference.set]
          rfl
      have nextWire : Wire args src dst (v+1) 8 (byte.setWidth 32) rest s2 := by
        refine ⟨nextReady,tail s.heap src v byte rest wire.reads,?_⟩
        have extent:=wire.extent
        simp only [List.length_cons] at extent
        omega
      have bitBuffer : buffer 8 (byte.setWidth 32)=digits 8 byte.toNat := by
        unfold buffer
        rw [BitVec.toNat_setWidth,Nat.mod_eq_of_lt (show byte.toNat<2^32 by have bound:=byte.isLt; omega)]
      refine ⟨v+1,8,byte.setWidth 32,rest,s2,full,nextWire,by decide +kernel,by decide +kernel,?_,by simp only [List.length_cons]; omega,rfl⟩
      unfold remaining
      rw [bitBuffer]
      rfl
  · have falseTest : truth (.integer (C99ScalarReference.boolean (decide (p=0))))=false := by
      rw [KeygenDecodeStaticCounterOps.boolean_truth]
      simp only [empty,decide_false]
    have source := branch_false args KeygenDecodeStaticBinding.guard055 KeygenDecodeStaticBinding.node054 .skip
      s s .normal _ s.locals (.pure _ _ _ test) falseTest (by rw [same]; exact skip args s)
    exact ⟨v,p,db,bytes,s,source,wire,by omega,small,rfl,rfl,rfl⟩

end FT1536.Source3.KeygenDecodeStaticUnaryRefill
