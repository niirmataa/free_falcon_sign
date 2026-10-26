import Source3.MkgmParams198

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmControl199
open C99IntegerReference
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open MkgmParams198 (Level logn lognWord shiftWord half)

def word (n : Nat) : BitVec 32 := BitVec.ofNat 32 n

theorem integer (n : Nat) (bound : n<2^32) : (Value.uint32 (word n)).integer=(n : Int) :=
  congrArg (fun k : Nat => (k : Int)) (show (word n).toNat=n from Nat.mod_eq_of_lt bound)

theorem add_one (n : Nat) (bound : n<2^32) :
    ArithmeticExec .plus (.uint32 (word n)) (.int32 1) (.uint32 (word (n+1))) := by
  have raw := ArithmeticExec.step .plus (.uint32 (word n)) (.int32 1) .uint32 rfl
    (.uint32 (word n)) (.uint32 1) (C99CountedWords.convert_self (.uint32 (word n))).symm rfl
    (by intro impossible; cases impossible)
  change ArithmeticExec .plus (.uint32 (word n)) (.int32 1)
    (.uint32 (BitVec.ofInt 32 ((Value.uint32 (word n)).integer+(Value.uint32 1).integer))) at raw
  rw [integer n bound] at raw
  have sum : (n : Int)+(Value.uint32 1).integer=((n+1 : Nat):Int) := by change (n:Int)+1=_; omega
  rw [sum,BitVec.ofInt_natCast] at raw
  exact raw

theorem increment (s : State) (n : Nat) (bound : n<2^32) (slot : Slot s "k" (word n)) :
    Exec (KeygenMkgm3Program.inc "k") s ⟨ModularAtoms178.set s "k" (word (n+1)),.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint32 (some (.uint32 (word n))) (.uint32 (word (n+1))) slot
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ slot) (.literal .int32 1) (add_one n bound))))

theorem comparison (n : Nat) (bound : n<2^32) :
    CompareExec .lt (.uint32 (word n)) (.int32 11) (C99ScalarReference.boolean (decide (n<11))) := by
  have raw := CompareExec.step .lt (.uint32 (word n)) (.int32 11) .uint32 rfl
    (.uint32 (word n)) (.uint32 11) (C99CountedWords.convert_self (.uint32 (word n))).symm rfl
  change CompareExec .lt (.uint32 (word n)) (.int32 11)
    (C99ScalarReference.boolean (decide ((Value.uint32 (word n)).integer<(Value.uint32 11).integer))) at raw
  have eleven : (Value.uint32 11).integer=(11:Int) := by decide
  rw [integer n bound,eleven] at raw
  have same : ((n:Int)<11)↔n<11 := by omega
  simpa only [same] using raw

theorem guard (s : State) (n : Nat) (bound : n<2^32) (slot : Slot s "k" (word n)) :
    C99ArrayReference.scalar s (.cmp .lt (KeygenMkgm3Program.var "k") (KeygenMkgm3Program.num 11))
      (C99ScalarReference.boolean (decide (n<11))) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ slot) (.literal .int32 11) (comparison n bound)

theorem row_shift (l : Level) :
    ArithmeticExec .minus (.int32 11) (.uint32 (lognWord l)) (.uint32 (shiftWord l)) := by
  fin_cases l
  all_goals exact .step .minus _ _ .uint32 rfl _ _ rfl rfl (by intro impossible; cases impossible)

theorem lower_power (l : Level) :
    ArithmeticExec .minus (.uint32 (lognWord l)) (.int32 1) (.uint32 (word l.val)) := by
  fin_cases l
  all_goals exact .step .minus _ _ .uint32 rfl _ _ rfl rfl (by intro impossible; cases impossible)

theorem half_shift (l : Level) :
    ShiftExec .left (.uint64 1) (.uint32 (word l.val)) (KeygenNttLoopSupport.u64 (half l)) := by
  have raw := ShiftExec.unsignedLeft (.uint64 1) (.uint32 (word l.val)) l.val rfl
    (integer l.val (by have h:=l.isLt; omega)) (by have h:=l.isLt; change l.val<64; omega)
  change ShiftExec .left (.uint64 1) (.uint32 (word l.val))
    (.uint64 (BitVec.ofInt 64 ((1:Int)*2^l.val))) at raw
  have power : (1:Int)*2^l.val=((half l:Nat):Int) := by simp [half]
  rw [power,BitVec.ofInt_natCast] at raw
  exact raw

end FT1536.Source3.MkgmControl199
