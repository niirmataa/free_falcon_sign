import Source3.C99CountedWords

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99NatWord141
open C99IntegerReference

def word (n : Nat) : BitVec 64 := BitVec.ofNat 64 n

theorem to_nat (n : Nat) (bound : n<2^64) : (word n).toNat=n := Nat.mod_eq_of_lt bound

theorem integer (n : Nat) (bound : n<2^64) : (Value.uint64 (word n)).integer=(n : Int) :=
  congrArg (fun k : Nat => (k : Int)) (to_nat n bound)

/-- Original unsigned C addition; output reduction remains modulo2^64. -/
theorem add (a b : Nat) (boundA : a<2^64) (boundB : b<2^64) :
    ArithmeticExec .plus (.uint64 (word a)) (.uint64 (word b)) (.uint64 (word (a+b))) := by
  have raw := ArithmeticExec.step .plus (.uint64 (word a)) (.uint64 (word b)) .uint64 rfl
    (.uint64 (word a)) (.uint64 (word b))
    (C99CountedWords.convert_self (.uint64 (word a))).symm
    (C99CountedWords.convert_self (.uint64 (word b))).symm (by intro impossible; cases impossible)
  change ArithmeticExec .plus (.uint64 (word a)) (.uint64 (word b))
    (.uint64 (BitVec.ofInt 64 ((Value.uint64 (word a)).integer+(Value.uint64 (word b)).integer))) at raw
  rw [integer a boundA,integer b boundB] at raw
  have sum : (a : Int)+(b : Int)=((a+b : Nat) : Int) := by omega
  rw [sum,BitVec.ofInt_natCast] at raw
  exact raw

theorem add_one (a : Nat) (bound : a<2^64) :
    ArithmeticExec .plus (.uint64 (word a)) (.int32 1) (.uint64 (word (a+1))) := by
  have raw := ArithmeticExec.step .plus (.uint64 (word a)) (.int32 1) .uint64 rfl
    (.uint64 (word a)) (.uint64 1)
    (C99CountedWords.convert_self (.uint64 (word a))).symm rfl (by intro impossible; cases impossible)
  change ArithmeticExec .plus (.uint64 (word a)) (.int32 1)
    (.uint64 (BitVec.ofInt 64 ((Value.uint64 (word a)).integer+1))) at raw
  rw [integer a bound] at raw
  have sum : (a : Int)+1=((a+1 : Nat) : Int) := by omega
  rw [sum,BitVec.ofInt_natCast] at raw
  exact raw

theorem less (a b : Nat) (boundA : a<2^64) (boundB : b<2^64) :
    CompareExec .lt (.uint64 (word a)) (.uint64 (word b))
      (C99ScalarReference.boolean (decide (a<b))) := by
  have raw := CompareExec.step .lt (.uint64 (word a)) (.uint64 (word b)) .uint64 rfl
    (.uint64 (word a)) (.uint64 (word b))
    (C99CountedWords.convert_self (.uint64 (word a))).symm
    (C99CountedWords.convert_self (.uint64 (word b))).symm
  change CompareExec .lt (.uint64 (word a)) (.uint64 (word b))
    (C99ScalarReference.boolean (decide ((Value.uint64 (word a)).integer<(Value.uint64 (word b)).integer))) at raw
  rw [integer a boundA,integer b boundB] at raw
  have same : ((a : Int)<(b : Int))↔a<b := by omega
  simpa only [same] using raw

end FT1536.Source3.C99NatWord141
