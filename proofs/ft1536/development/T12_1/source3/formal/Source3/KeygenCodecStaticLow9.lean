import Source3.KeygenCodecStaticCoefficient

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticLow9
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticProfile KeygenCodecScalarCalculation KeygenCodecStaticCoefficient

def magnitudeBits (n : Int) : BitVec 32 := BitVec.ofInt 32 n &&& 255
def packed (n : Int) : BitVec 32 := signWord n ||| magnitudeBits (magnitude n)

theorem and_word (a b : BitVec 32) :
    C99IntegerReference.convert .uint32 ((a.toNat &&& b.toNat : Nat) : Int)=.uint32 (a &&& b) := by
  change C99IntegerReference.Value.uint32 (BitVec.ofNat 32 (a &&& b).toNat)=_
  rw [BitVec.ofNat_toNat,BitVec.setWidth_eq]

theorem band_calculation (l : Locals) (n : Int) (lower : 0≤n) (upper : n≤32768)
    (cell : W n l) (mask : Cell "mask".toList .uint32 (.uint32 255) l) :
    Computes l (.binary .band (.variable "w".toList) (.variable "mask".toList))
      (.uint32 (magnitudeBits n)) := by
  apply Computes.binary _ _ _ (.int32 (BitVec.ofInt 32 n)) (.uint32 255) _
  · exact .scalar _ _ _ (by unfold Ordinary; decide +kernel) cell
  · exact .scalar _ _ _ (by unfold Ordinary; decide +kernel) mask
  · apply BinaryOp.band
    apply (C99IntegerReference.bitwise_iff _ _ _ _).mpr
    simp only [C99IntegerReference.Value.type,C99IntegerReference.promote,C99IntegerReference.usual,
      C99IntegerReference.signed,C99IntegerReference.width,ite_true,
      C99IntegerReference.Value.integer,KeygenCodecStaticCountdown.signed_exact n (by omega) (by omega)]
    exact (and_word (BitVec.ofInt 32 n) 255).symm

theorem or_value (a b : BitVec 32) (z : C99IntegerReference.Value)
    (source : BinaryOp .bor (.integer (.uint32 a)) (.integer (.uint32 b)) (.integer z)) :
    z=.uint32 (a ||| b) := by
  cases source with
  | bor x y z operation =>
    have same := (C99IntegerReference.bitwise_iff _ _ _ _).mp operation
    change z=C99IntegerReference.convert .uint32
      (((C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 a).integer).bits |||
        (C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 b).integer).bits : Nat) : Int) at same
    rw [KeygenCodecStaticAppend.convert_word,KeygenCodecStaticAppend.convert_word] at same
    exact same.trans (KeygenCodecStaticAppend.or_word a b)

/-- Execute the real mixed signed/unsigned mask and compound OR. -/
theorem low9_step (args : Args) (s t : State) (flow : Flow) (n : Int)
    (lower : -32768≤n) (upper : n≤32767)
    (cell : W (magnitude n) s.locals)
    (lo : Cell "lo".toList .uint32 (.uint32 (signWord n)) s.locals)
    (mask : Cell "mask".toList .uint32 (.uint32 255) s.locals)
    (source : Exec args KeygenCodecStaticBinding.node038 s t flow) :
    Cell "lo".toList .uint32 (.uint32 (packed n)) t.locals := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.uint32 ∧ old=some (.uint32 (signWord n)) := by
      simpa only [Cell,Option.some.injEq,Prod.mk.injEq] using declared.symm.trans lo
    obtain ⟨rfl,rfl⟩ := equal
    have bounds := magnitude_bounds n lower upper
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals _ (.uint32 (magnitudeBits (magnitude n)))
      (band_calculation s.locals (magnitude n) bounds.1 bounds.2 cell mask) locals (.integer value) evaluated
    cases same
    cases assigned with
    | compound op binary old rhs z operator operation =>
      have same : binary=.bor := Option.some.inj operator.symm
      subst binary
      have resultEq := or_value (signWord n) (magnitudeBits (magnitude n)) _ operation
      simp only [Cell,packed,withLocals,localSet,C99ScalarReference.set,ite_true,resultEq,
        KeygenCodecStaticAppend.convert_word]

theorem magnitude_bits_value (n : Int) : (magnitudeBits n).toNat=(BitVec.ofInt 32 n).toNat%256 := by
  unfold magnitudeBits
  rw [BitVec.toNat_and]
  change (BitVec.ofInt 32 n).toNat &&& (2^8-1)=(BitVec.ofInt 32 n).toNat%2^8
  exact Nat.and_two_pow_sub_one_eq_mod _ _

theorem packed_value (n : Int) :
    (packed n).toNat=(if n<0 then 256 else 0)+(BitVec.ofInt 32 (magnitude n)).toNat%256 := by
  have small : (magnitudeBits (magnitude n)).toNat<256 := by
    rw [magnitude_bits_value]
    exact Nat.mod_lt _ (by decide +kernel)
  unfold packed signWord
  by_cases negative : n<0
  · simp only [negative,ite_true]
    rw [BitVec.toNat_or]
    change 256 ||| (magnitudeBits (magnitude n)).toNat=_
    rw [show 256=(1 : Nat)<<<8 by decide +kernel,←Nat.shiftLeft_add_eq_or_of_lt small,magnitude_bits_value]
    rfl
  · simp only [negative,ite_false,Nat.zero_add,BitVec.toNat_or]
    change 0 ||| (magnitudeBits (magnitude n)).toNat=_
    rw [Nat.zero_or,magnitude_bits_value]

theorem packed_bound (n : Int) : (packed n).toNat<512 := by
  rw [packed_value]
  have bound := Nat.mod_lt (BitVec.ofInt 32 (magnitude n)).toNat (by decide +kernel : 0<256)
  split <;> omega

end FT1536.Source3.KeygenCodecStaticLow9
