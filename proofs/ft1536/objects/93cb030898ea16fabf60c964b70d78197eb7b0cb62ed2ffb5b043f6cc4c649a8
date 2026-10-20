import Source3.C99UnarySound

namespace FT1536.Source3.C99ShiftSound
open B20.C C99ValueBridge

theorem shift_bound (op : BinOp) (x z : Val) (n : BitVec 32)
    (hs : B20.C.shift op x n=some z) :
    n.toNat<C99IntegerReference.width (value x).type := by
  by_contra hn
  cases x <;>
    simp only [value,C99IntegerReference.Value.type,C99IntegerReference.width] at hn <;>
    simp [B20.C.shift,hn] at hs

theorem count_source (op : BinOp) (x y z : Val) (ho : op=.shr ∨ op=.shl)
    (hs : B20.C.bin op x y=some z) :
    ∃ n : Nat, (value y).integer=(n : Int) ∧ n<C99IntegerReference.width (value x).type ∧
      (y.ty=.i32 ∨ y.ty=.u32) := by
  cases y with
  | u64 _ | i64 _ => simp [B20.C.bin,ho] at hs
  | i32 bits =>
      have hshift : B20.C.shift op x bits=some z := by simpa [B20.C.bin,ho] using hs
      have hb := shift_bound op x z bits hshift
      have h64 : bits.toNat<64 := by
        cases x <;> simp only [value,C99IntegerReference.Value.type,C99IntegerReference.width] at hb <;> omega
      have hc := BitVec.toInt_eq_toNat_of_lt (x:=bits) (by omega)
      exact ⟨bits.toNat,hc,hb,Or.inl rfl⟩
  | u32 bits =>
      have hshift : B20.C.shift op x bits=some z := by simpa [B20.C.bin,ho] using hs
      exact ⟨bits.toNat,rfl,shift_bound op x z bits hshift,Or.inr rfl⟩

theorem right_sound (x y z : Val) (hs : B20.C.bin .shr x y=some z) :
    C99IntegerReference.ShiftExec .right (value x) (value y) (value z) := by
  obtain ⟨n,hc,hb,ht⟩ := count_source .shr x y z (Or.inl rfl) hs
  let r := C99IntegerReference.convert (value x).type ((value x).integer/2^n)
  have hr : C99IntegerReference.ShiftExec .right (value x) (value y) r :=
    C99IntegerReference.ShiftExec.right _ _ n hc hb
  have hi := C99ShiftBridge.right_source_to_interpreter x y (encode r) ht
    (by simpa only [value_encode] using hr)
  have heq : z=encode r := Option.some.inj (hs.symm.trans hi)
  rw [heq,value_encode]
  exact hr

theorem left_sound (x y z : Val) (hs : B20.C.bin .shl x y=some z) :
    C99IntegerReference.ShiftExec .left (value x) (value y) (value z) := by
  obtain ⟨n,hc,hb,ht⟩ := count_source .shl x y z (Or.inr rfl) hs
  have hleft : x.ty=.u64 ∨ x.ty=.u32 := by
    cases x <;> cases y <;> simp_all [Val.ty,B20.C.bin,B20.C.shift]
  have hunsigned : C99IntegerReference.signed (value x).type=false := by
    cases x <;> simp_all [Val.ty,value,C99IntegerReference.Value.type,C99IntegerReference.signed]
  let r := C99IntegerReference.convert (value x).type ((value x).integer*2^n)
  have hr : C99IntegerReference.ShiftExec .left (value x) (value y) r :=
    C99IntegerReference.ShiftExec.unsignedLeft _ _ n hunsigned hc hb
  have hi := C99ShiftLeftBridge.source_to_interpreter x y (encode r) hleft ht
    (by simpa only [value_encode] using hr)
  have heq : z=encode r := Option.some.inj (hs.symm.trans hi)
  rw [heq,value_encode]
  exact hr

end FT1536.Source3.C99ShiftSound

#print axioms FT1536.Source3.C99ShiftSound.right_sound
#print axioms FT1536.Source3.C99ShiftSound.left_sound
