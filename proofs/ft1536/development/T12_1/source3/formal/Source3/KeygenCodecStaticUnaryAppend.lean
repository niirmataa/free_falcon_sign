import Source3.KeygenCodecStaticUnaryBit

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticUnaryAppend
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

abbrev IV := C99IntegerReference.Value

theorem shift_word (a : BitVec 32) :
    C99IntegerReference.convert .uint32 ((C99IntegerReference.Value.uint32 a).integer*2^1)=.uint32 (a <<< 1) := by
  change C99IntegerReference.Value.uint32 (BitVec.ofInt 32 ((a.toNat : Int)*2))=_
  rw [show (a.toNat : Int)*2=((a.toNat*2 : Nat) : Int) from (Int.natCast_mul _ _).symm,BitVec.ofInt_natCast]
  congr 1
  change BitVec.ofNat 32 (a.toNat*2)=BitVec.ofNat 32 (a.toNat <<< 1)
  rw [Nat.shiftLeft_eq]

theorem add_word (a b : BitVec 32) (z : IV)
    (source : BinaryOp .add (.integer (.uint32 a)) (.integer (.uint32 b)) (.integer z)) : z=.uint32 (a+b) := by
  cases source with
  | add x y z operation =>
    have same := (C99IntegerReference.arithmetic_iff _ _ _ _).mp operation |>.2
    change z=.uint32 (BitVec.ofInt 32
      ((C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 a).integer).integer+
       (C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 b).integer).integer)) at same
    rw [KeygenCodecStaticAppend.convert_word,KeygenCodecStaticAppend.convert_word] at same
    change z=.uint32 (BitVec.ofInt 32 ((a.toNat : Int)+b.toNat)) at same
    rw [←Int.natCast_add,BitVec.ofInt_natCast] at same
    exact same

theorem shift_step (args : Args) (s t : State) (flow : Flow) (acc : BitVec 32)
    (cell : s.locals.scalars "acc".toList=some (.uint32,some (.uint32 acc)))
    (source : Exec args KeygenCodecStaticBinding.node061 s t flow) :
    t.locals.scalars "acc".toList=some (.uint32,some (.uint32 (acc <<< 1))) := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.uint32 ∧ old=some (.uint32 acc) := by
      simpa only [Option.some.injEq,Prod.mk.injEq] using declared.symm.trans cell
    obtain ⟨rfl,rfl⟩ := equal
    obtain ⟨same,last⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 1 (.int32 1) s.locals locals (.integer value) (by decide +kernel) evaluated
    cases same
    cases assigned with
    | compound op binary old rhs z operator operation =>
      have same : binary=.shl := Option.some.inj operator.symm
      subst binary
      cases operation with
      | shl x y z shifted =>
        have canonical := C99IntegerReference.ShiftExec.unsignedLeft (.uint32 acc) (.int32 1) 1 rfl rfl (by change (1 : Nat)<32; decide +kernel)
        have result := (C99IntegerReference.shift_deterministic _ _ _ _ _ shifted canonical).trans (shift_word acc)
        simp only [withLocals,localSet,C99ScalarReference.set,ite_true,result,KeygenCodecStaticAppend.convert_word]

theorem bit_step (args : Args) (s t : State) (flow : Flow) (acc : BitVec 32) (n : Int)
    (lower : -1≤n) (upper : n≤127)
    (cell : s.locals.scalars "acc".toList=some (.uint32,some (.uint32 acc)))
    (counter : KeygenCodecStaticCountdown.Cell n s.locals)
    (source : Exec args KeygenCodecStaticBinding.node062 s t flow) :
    t.locals.scalars "acc".toList=some (.uint32,some (.uint32 (acc+KeygenCodecStaticUnaryBit.bit n))) := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.uint32 ∧ old=some (.uint32 acc) := by
      simpa only [Option.some.injEq,Prod.mk.injEq] using declared.symm.trans cell
    obtain ⟨rfl,rfl⟩ := equal
    obtain ⟨same,last⟩ := KeygenCodecStaticUnaryBit.rhs_eval args s locals (.integer value) n lower upper counter evaluated
    cases same
    cases assigned with
    | compound op binary old rhs z operator operation =>
      have same : binary=.add := Option.some.inj operator.symm
      subst binary
      have resultEq := add_word acc (KeygenCodecStaticUnaryBit.bit n) _ operation
      simp only [withLocals,localSet,C99ScalarReference.set,ite_true,resultEq,KeygenCodecStaticAppend.convert_word]

theorem bit_bound (n : Int) : (KeygenCodecStaticUnaryBit.bit n).toNat<2 := by
  unfold KeygenCodecStaticUnaryBit.bit
  split <;> decide +kernel

theorem low_append (acc newBit : BitVec 32) (count : Nat)
    (width : count+1≤32) (small : newBit.toNat<2) :
    KeygenCodecStaticSuffix.low ((acc <<< 1)+newBit) (count+1)=
      KeygenCodecStaticSuffix.low acc count*2+newBit.toNat := by
  have shifted := KeygenCodecStaticSuffix.low_shl acc count 1 width
  have lowBound := KeygenCodecStaticSuffix.low_bound acc count
  have total : KeygenCodecStaticSuffix.low acc count*2+newBit.toNat<2^(count+1) := by
    rw [Nat.pow_succ]
    omega
  have bitWidth : newBit.toNat<2^(count+1) := by
    have positive := Nat.two_pow_pos count
    rw [Nat.pow_succ]
    omega
  unfold KeygenCodecStaticSuffix.low
  rw [BitVec.toNat_add,Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 width),Nat.add_mod]
  change ((KeygenCodecStaticSuffix.low (acc <<< 1) (count+1)+newBit.toNat%2^(count+1))%2^(count+1))=_
  rw [shifted,Nat.pow_one,Nat.mod_eq_of_lt bitWidth,Nat.mod_eq_of_lt total]
  rfl

/-- Both actual accumulator writes, including the evaluated unary bit.
    pending is a local interpretation length; the full acc_len fold must
    derive and transport it. No whole-word accumulator bound is used. -/
theorem source_append (args : Args) (s m t : State) (flow : Flow) (acc : BitVec 32) (n : Int) (pending : Nat)
    (lower : -1≤n) (upper : n≤127) (width : pending+1≤32)
    (cell : s.locals.scalars "acc".toList=some (.uint32,some (.uint32 acc)))
    (counter : KeygenCodecStaticCountdown.Cell n s.locals)
    (shift : Exec args KeygenCodecStaticBinding.node061 s m .normal)
    (append : Exec args KeygenCodecStaticBinding.node062 m t flow) :
    ∃ word : BitVec 32, t.locals.scalars "acc".toList=some (.uint32,some (.uint32 word)) ∧
      KeygenCodecStaticSuffix.low word (pending+1)=
        KeygenCodecStaticSuffix.low acc pending*2+(KeygenCodecStaticUnaryBit.bit n).toNat := by
  have kept := (KeygenCodecCellFrame.exec_frame "ne".toList args _ s m .normal shift (by decide +kernel)).trans counter
  exact ⟨_,bit_step args m t flow (acc <<< 1) n lower upper (shift_step args s m .normal acc cell shift) kept append,
    low_append acc (KeygenCodecStaticUnaryBit.bit n) pending width (bit_bound n)⟩

end FT1536.Source3.KeygenCodecStaticUnaryAppend
