import Source3.C99ShiftBridge

namespace FT1536.Source3.C99ShiftLeftBridge
open B20.C C99ValueBridge

theorem left_unsigned_iff (x y z : C99IntegerReference.Value)
    (hx : C99IntegerReference.signed x.type=false) :
    C99IntegerReference.ShiftExec .left x y z ↔ ∃ n : Nat,
      y.integer=(n : Int) ∧ n<C99IntegerReference.width x.type ∧
      z=C99IntegerReference.convert x.type (x.integer*2^n) := by
  constructor
  · intro h
    cases h
    · refine ⟨_,?_,?_,rfl⟩ <;> assumption
    · refine ⟨_,?_,?_,rfl⟩ <;> assumption
  · rintro ⟨n,hc,hb,rfl⟩
    exact C99IntegerReference.ShiftExec.unsignedLeft x y n hx hc hb

theorem unsigned_left (x : BitVec w) (n : Nat) :
    BitVec.ofInt w ((x.toNat : Int)*2^n)=x <<< n := by
  change BitVec.ofInt w ((x.toNat*2^n : Nat) : Int)=x <<< n
  rw [BitVec.ofInt_natCast]
  apply BitVec.eq_of_toNat_eq
  simp [BitVec.toNat_ofNat,BitVec.toNat_shiftLeft,Nat.shiftLeft_eq]

theorem shift_left_value (x : Val) (n : Nat)
    (unsignedType : x.ty=.u64 ∨ x.ty=.u32)
    (hn : n<C99IntegerReference.width (value x).type) :
    B20.C.shift .shl x (BitVec.ofNat 32 n)=
      some (encode (C99IntegerReference.convert (value x).type ((value x).integer*2^n))) := by
  have hb : n<64 := by
    cases x <;> simp only [value,C99IntegerReference.Value.type,C99IntegerReference.width] at hn <;> omega
  have hmod : n%4294967296=n := by omega
  cases x <;> simp only [value,C99IntegerReference.Value.type,C99IntegerReference.width] at hn ⊢
  all_goals simp only [Val.ty] at unsignedType
  all_goals first | contradiction | simp [shift,encode,C99IntegerReference.convert,
    C99IntegerReference.Value.integer,unsigned_left,hmod,hn]

theorem source_to_interpreter (x y z : Val)
    (leftType : x.ty=.u64 ∨ x.ty=.u32) (countType : y.ty=.i32 ∨ y.ty=.u32)
    (hs : C99IntegerReference.ShiftExec .left (value x) (value y) (value z)) :
    B20.C.bin .shl x y=some z := by
  have hx : C99IntegerReference.signed (value x).type=false := by
    cases x <;> simp_all [Val.ty,value,C99IntegerReference.Value.type,C99IntegerReference.signed]
  obtain ⟨n,hcount,hbound,hresult⟩ := left_unsigned_iff _ _ _ hx |>.mp hs
  have hencoded : z=encode (C99IntegerReference.convert (value x).type ((value x).integer*2^n)) :=
    (encode_value z).symm.trans (congrArg encode hresult)
  rw [hencoded]
  cases y with
  | u64 _ | i64 _ => simp [Val.ty] at countType
  | i32 bits =>
      have hc : bits.toNat=n := C99ShiftBridge.nonnegative_count bits n hcount
      have heq : bits=BitVec.ofNat 32 n := by apply BitVec.eq_of_toNat_eq; simp [← hc]
      subst bits
      exact shift_left_value x n leftType hbound
  | u32 bits =>
      have hc : bits.toNat=n := by change (bits.toNat : Int)=(n : Int) at hcount; omega
      have heq : bits=BitVec.ofNat 32 n := by apply BitVec.eq_of_toNat_eq; simp [← hc]
      subst bits
      exact shift_left_value x n leftType hbound

end FT1536.Source3.C99ShiftLeftBridge

#print axioms FT1536.Source3.C99ShiftLeftBridge.source_to_interpreter
