import Source3.ZintSignedCall209
import Source3.KeygenModpRxExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.RxControl210
open C99ArrayReference (State Name bindValue)
open C99IntegerReference
open C99ModularReference (GenExec LeafCall)
open KeygenModpR2Exec (Slot)

abbrev word (n : Nat) : BitVec 32 := MkgmControl199.word n
 def bit (i : Nat) : BitVec 32 := 1#32 <<< i
 def setI (s : State) (i : Nat) := bindValue s "i".toList .int32 (.int32 (word i))
 def ISlot (s : State) (i : Nat) := s.locals "i".toList=some (.int32,some (.int32 (word i)))

theorem self_i32 (w : BitVec 32) : convert .int32 (Value.int32 w).integer=.int32 w :=
  C99CountedWords.convert_self (.int32 w)

theorem i_cell (s : State) (i : Nat) : ISlot (setI s i) i := by
  simp only [ISlot,setI,bindValue,C99ScalarReference.set,ite_true,self_i32]

theorem i_outside (s : State) (i : Nat) (name : Name) (different : name≠"i".toList) :
    (setI s i).locals name=s.locals name :=
  SelectedStepAddPrime195.locals_keep s "i".toList .int32 (.int32 (word i)) name different

theorem integer_i (i : Nat) (bound : i < 2^31) : (Value.int32 (word i)).integer=(i : Int) :=
  KeygenCodecNoneCursor.signed_nat32 i bound

theorem add_one_i (i : Nat) (bound : i < 10) :
    ArithmeticExec .plus (.int32 (word i)) (.int32 1) (.int32 (word (i+1))) := by
  have safe : fits .int32 ((Value.int32 (word i)).integer+1) := by
    change -(2^31 : Int) ≤ (Value.int32 (word i)).integer+1 ∧ (Value.int32 (word i)).integer+1 < 2^31
    rw [integer_i i (by omega)]
    omega
  have raw:=ArithmeticExec.step .plus (.int32 (word i)) (.int32 1) .int32 rfl
    (.int32 (word i)) (.int32 1) (self_i32 _).symm (self_i32 _).symm (fun _ => safe)
  have same : convert .int32 ((Value.int32 (word i)).integer+1)=.int32 (word (i+1)) := by
    rw [integer_i i (by omega)]
    change Value.int32 (BitVec.ofInt 32 ((i : Int)+1))=_
    rw [show (i : Int)+1=((i+1 : Nat) : Int) by omega,BitVec.ofInt_natCast]
    rfl
  exact same ▸ raw

theorem sub_one_x (n : Nat) (positive : 0 < n) (bound : n < 2^32) :
    ArithmeticExec .minus (.uint32 (word n)) (.int32 1) (.uint32 (word (n-1))) := by
  have raw:=ArithmeticExec.step .minus (.uint32 (word n)) (.int32 1) .uint32 rfl
    (.uint32 (word n)) (.uint32 1) (KeygenDecodeWordOps.self32 _).symm rfl (by intro h; cases h)
  change ArithmeticExec .minus (.uint32 (word n)) (.int32 1)
    (.uint32 (BitVec.ofInt 32 ((Value.uint32 (word n)).integer-1))) at raw
  rw [MkgmControl199.integer n bound,show (n : Int)-1=((n-1 : Nat) : Int) by omega,BitVec.ofInt_natCast] at raw
  exact raw

theorem increment (s : State) (i : Nat) (bound : i < 10) (ic : ISlot s i) :
    GenExec LeafCall C99ModularReference.rxLoopStep s ⟨setI s (i+1),.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .int32 (some (.int32 (word i))) (.int32 (word (i+1))) ic
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ ic) (.literal .int32 1) (add_one_i i bound))))

theorem shift_eval (s : State) (i : Nat) (bound : i ≤ 10) (ic : ISlot s i) :
    C99ArrayReference.scalar s C99ModularReference.rxShiftI (.uint32 (bit i)) :=
  .shift .left _ _ _ _ _ (.literal .uint32 1) (.variable _ _ _ ic) (KeygenDecodeWordOps.left32 1 i (by omega))

theorem le_word (a b : BitVec 32) : CompareExec .le (.uint32 a) (.uint32 b)
    (C99ScalarReference.boolean (decide (a.toNat ≤ b.toNat))) := by
  have raw:=CompareExec.step .le (.uint32 a) (.uint32 b) .uint32 rfl
    (.uint32 a) (.uint32 b) (KeygenDecodeWordOps.self32 _).symm (KeygenDecodeWordOps.self32 _).symm
  change CompareExec .le (.uint32 a) (.uint32 b)
    (C99ScalarReference.boolean (decide ((a.toNat : Int) ≤ (b.toNat : Int)))) at raw
  have same : ((a.toNat : Int) ≤ (b.toNat : Int))↔a.toNat ≤ b.toNat := by omega
  simpa only [same] using raw

theorem ne_zero (a : BitVec 32) : CompareExec .ne (.uint32 a) (.int32 0)
    (C99ScalarReference.boolean (decide (a.toNat≠0))) := by
  have raw:=CompareExec.step .ne (.uint32 a) (.int32 0) .uint32 rfl
    (.uint32 a) (.uint32 0) (KeygenDecodeWordOps.self32 _).symm rfl
  change CompareExec .ne (.uint32 a) (.int32 0)
    (C99ScalarReference.boolean (decide ((a.toNat : Int)≠0))) at raw
  have same : ((a.toNat : Int)≠0)↔a.toNat≠0 := by omega
  simpa only [same] using raw

theorem guard (s : State) (i : Nat) (x : BitVec 32) (bound : i ≤ 10) (ic : ISlot s i) (xc : Slot s "x" x) :
    C99ArrayReference.scalar s C99ModularReference.rxLoopGuard
      (C99ScalarReference.boolean (decide ((bit i).toNat ≤ x.toNat))) :=
  .compare .le _ _ _ _ _ (shift_eval s i bound ic) (.variable _ _ _ xc) (le_word _ _)

theorem branch_guard (s : State) (i : Nat) (x : BitVec 32) (bound : i ≤ 10) (ic : ISlot s i) (xc : Slot s "x" x) :
    C99ArrayReference.scalar s C99ModularReference.rxBranchGuard
      (C99ScalarReference.boolean (decide ((x &&& bit i).toNat≠0))) :=
  .compare .ne _ _ _ _ _ (.bitwise .and _ _ _ _ _ (.variable _ _ _ xc) (shift_eval s i bound ic)
    (KeygenDecodeWordOps.and32 _ _)) (.literal .int32 0) (ne_zero _)

end FT1536.Source3.RxControl210
