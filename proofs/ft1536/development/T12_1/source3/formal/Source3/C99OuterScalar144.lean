import Source3.C99ControlShift142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99OuterScalar144
open C99IntegerReference
open C99ArrayReference (State Name scalar)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)

theorem half_word (n : Nat) (bound : n<2^64) :
    ShiftExec .right (.uint64 (word n)) (.int32 1) (.uint64 (word (n/2))) := by
  have raw := ShiftExec.right (.uint64 (word n)) (.int32 1) 1 rfl (by change (1 : Nat)<64; decide)
  change ShiftExec .right (.uint64 (word n)) (.int32 1)
    (.uint64 (BitVec.ofInt 64 ((Value.uint64 (word n)).integer/2))) at raw
  rw [C99NatWord141.integer n bound] at raw
  change ShiftExec .right (.uint64 (word n)) (.int32 1)
    (.uint64 (BitVec.ofInt 64 ((n/2 : Nat) : Int))) at raw
  rw [BitVec.ofInt_natCast] at raw
  exact raw

theorem half_eval (s : State) (name : Name) (n : Nat) (bound : n<2^64) (cell : Cell s name n) :
    scalar s (.bin .shr (.var name) (.literal .i32 1)) (.uint64 (word (n/2))) :=
  .shift .right _ _ _ _ _ (C99LoopScalar141.read s name n cell) (.literal .int32 1) (half_word n bound)

theorem assign_half (program : C99ProcedureReference.Program) (s : State) (target origin : Name)
    (old : Option Value) (n : Nat) (bound : n<2^64)
    (declared : s.locals target=some (.uint64,old)) (cell : Cell s origin n) :
    C99ProcedureReference.Exec program (.base (.assign target (.scalar (.bin .shr (.var origin) (.literal .i32 1))))) s
      ⟨FftLocalCells140.put s target (word (n/2)),.normal⟩ :=
  .base _ _ _ (FftLocalCells140.assign _ s target _ old (word (n/2)) declared
    (.scalar _ _ (half_eval s origin n bound cell)))

theorem clear (program : C99ProcedureReference.Program) (s : State) (name : Name)
    (old : Option Value) (declared : s.locals name=some (.uint64,old)) :
    C99ProcedureReference.Exec program (.base (.scalar (.assign name (.literal .i32 0)))) s
      ⟨FftLocalCells140.put s name (word 0),.normal⟩ := by
  rw [FftLocalCells140.put_bind]
  exact .base _ _ _ (.scalar s _ _ (.assign s.locals name _ .uint64 old (.int32 0) declared (.literal .int32 0)))

theorem greater_word (a b : Nat) (boundA : a<2^64) (boundB : b<2^64) :
    CompareExec .gt (.uint64 (word a)) (.uint64 (word b))
      (C99ScalarReference.boolean (decide (b<a))) := by
  have raw := CompareExec.step .gt (.uint64 (word a)) (.uint64 (word b)) .uint64 rfl
    (.uint64 (word a)) (.uint64 (word b))
    (C99CountedWords.convert_self (.uint64 (word a))).symm
    (C99CountedWords.convert_self (.uint64 (word b))).symm
  change CompareExec .gt (.uint64 (word a)) (.uint64 (word b))
    (C99ScalarReference.boolean (decide ((Value.uint64 (word b)).integer<(Value.uint64 (word a)).integer))) at raw
  rw [C99NatWord141.integer a boundA,C99NatWord141.integer b boundB] at raw
  have same : ((b : Int)<(a : Int))↔b<a := by omega
  simpa only [same] using raw

theorem greater (s : State) (left right : CLogic.Expr) (a b : Nat)
    (boundA : a<2^64) (boundB : b<2^64)
    (first : scalar s left (.uint64 (word a))) (second : scalar s right (.uint64 (word b))) :
    scalar s (.cmp .gt left right) (C99ScalarReference.boolean (decide (b<a))) :=
  .compare .gt _ _ _ _ _ first second (greater_word a b boundA boundB)

end FT1536.Source3.C99OuterScalar144
