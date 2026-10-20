import Source3.C99ArithmeticBridge

namespace FT1536.Source3.C99ShiftBridge
open B20.C C99ValueBridge

theorem nonnegative_count (b : BitVec 32) (n : Nat) (h : b.toInt=(n : Int)) : b.toNat=n := by
  have hmsb : b.msb=false := by
    cases hb : b.msb with
    | false => rfl
    | true => have hn := BitVec.toInt_neg_of_msb_true hb; omega
  have hb := BitVec.toInt_eq_toNat_of_msb hmsb
  omega

theorem unsigned_right (x : BitVec w) (n : Nat) :
    BitVec.ofInt w ((x.toNat : Int) / 2^n)=x >>> n := by
  change BitVec.ofInt w ((x.toNat/2^n : Nat) : Int)=x >>> n
  rw [BitVec.ofInt_natCast]
  apply BitVec.eq_of_toNat_eq
  have hle := Nat.div_le_self x.toNat (2^n)
  have hlt := x.isLt
  have hbound : x.toNat/2^n<2^w := by omega
  simp only [BitVec.toNat_ofNat,BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow,
    Nat.mod_eq_of_lt hbound]

theorem signed_right (x : BitVec w) (n : Nat) :
    BitVec.ofInt w (x.toInt / 2^n)=x.sshiftRight n := by
  simp [BitVec.sshiftRight,Int.shiftRight_eq_div_pow]

theorem shift_right_value (x : Val) (n : Nat)
    (hn : n<C99IntegerReference.width (value x).type) :
    B20.C.shift .shr x (BitVec.ofNat 32 n)=
      some (encode (C99IntegerReference.convert (value x).type ((value x).integer/2^n))) := by
  have hb : n<64 := by
    cases x <;> simp only [value,C99IntegerReference.Value.type,C99IntegerReference.width] at hn <;> omega
  have hmod : n%4294967296=n := by omega
  cases x <;>
    simp only [value,C99IntegerReference.Value.type,C99IntegerReference.width] at hn ⊢ <;>
    simp [shift,encode,C99IntegerReference.convert,C99IntegerReference.Value.integer,
      unsigned_right,signed_right,hmod,hn]

theorem right_source_to_interpreter (x y z : Val)
    (countType : y.ty=.i32 ∨ y.ty=.u32)
    (hs : C99IntegerReference.ShiftExec .right (value x) (value y) (value z)) :
    B20.C.bin .shr x y=some z := by
  obtain ⟨n,hcount,hbound,hresult⟩ := C99IntegerReference.shift_right_iff _ _ _ |>.mp hs
  have hencoded : z=encode (C99IntegerReference.convert (value x).type ((value x).integer/2^n)) := by
    exact (encode_value z).symm.trans (congrArg encode hresult)
  rw [hencoded]
  cases y with
  | u64 _ | i64 _ => simp [Val.ty] at countType
  | i32 bits =>
      have hc : bits.toNat=n := nonnegative_count bits n hcount
      have heq : bits=BitVec.ofNat 32 n := by apply BitVec.eq_of_toNat_eq; simp [← hc]
      subst bits
      exact shift_right_value x n hbound
  | u32 bits =>
      have hc : bits.toNat=n := by
        change (bits.toNat : Int)=(n : Int) at hcount
        omega
      have heq : bits=BitVec.ofNat 32 n := by apply BitVec.eq_of_toNat_eq; simp [← hc]
      subst bits
      exact shift_right_value x n hbound

end FT1536.Source3.C99ShiftBridge

#print axioms FT1536.Source3.C99ShiftBridge.right_source_to_interpreter
