import Source3.SelectedBezoutInitComplete217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact source short-circuit unit tests for x and y. -/
namespace FT1536.Source3.BezoutUnitGuard217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenWordExpr (Expr Eval)
open KeygenZintCall (Stmt Exec)
open StepCopyBody190 (elem)

def var (n : String) : CLogic.Expr := .var n.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def condition (src len : String) : Expr := .land (.cmp .eq (.scalar (var len)) (.scalar (num 1)))
  (.cmp .eq (.load32 src.toList (num 0)) (.scalar (num 1)))
def unit (n : Nat) (w : BitVec 32) : Bool := decide (n=1) && decide ((C99IntegerReference.Value.uint32 w).integer=1)
def xYes : Stmt := .scope [] [] (.seq (.word (.ret (.scalar (num 1)))) ZintNormWord194.wskip)
def xBranch : Stmt := .branch (condition "x" "xlen") xYes ZintNormWord194.wskip
def tail : Stmt := match KeygenZintCall.bezoutPart 6 with | .seq _ rest => rest | _ => KeygenZintCall.skip

theorem shape : KeygenZintCall.bezoutPart 6=.seq xBranch tail := by decide

theorem eq_one64 (n : Nat) (bound : n<2^64) :
    C99IntegerReference.CompareExec .eq (.uint64 (word n)) (.int32 1) (C99ScalarReference.boolean (decide (n=1))) := by
  have raw := C99IntegerReference.CompareExec.step .eq (.uint64 (word n)) (.int32 1) .uint64 rfl (.uint64 (word n)) (.uint64 1)
    (C99CountedWords.convert_self (.uint64 (word n))).symm rfl
  change C99IntegerReference.CompareExec .eq (.uint64 (word n)) (.int32 1)
    (C99ScalarReference.boolean (decide ((C99IntegerReference.Value.uint64 (word n)).integer=1))) at raw
  rw [C99NatWord141.integer n bound] at raw
  have eq : ((n : Int)=1) ↔ n=1 := by omega
  simpa only [eq] using raw

theorem eq_one32 (w : BitVec 32) :
    C99IntegerReference.CompareExec .eq (.uint32 w) (.int32 1)
      (C99ScalarReference.boolean (decide ((C99IntegerReference.Value.uint32 w).integer=1))) := by
  have raw := C99IntegerReference.CompareExec.step .eq (.uint32 w) (.int32 1) .uint32 rfl (.uint32 w) (.uint32 1)
    (C99CountedWords.convert_self (.uint32 w)).symm rfl
  change C99IntegerReference.CompareExec .eq (.uint32 w) (.int32 1)
    (C99ScalarReference.boolean (decide ((C99IntegerReference.Value.uint32 w).integer=1))) at raw
  exact raw

theorem and_eval (s : State) (a b : Expr) (p q : Bool)
    (left : Eval s a (C99ScalarReference.boolean p)) (right : Eval s b (C99ScalarReference.boolean q)) :
    Eval s (.land a b) (C99ScalarReference.boolean (p && q)) := by
  cases p <;> cases q
  · exact .andFalse _ _ (.int32 0) left rfl
  · exact .andFalse _ _ (.int32 0) left rfl
  · exact .andTrue _ _ (.int32 1) (.int32 0) left (by decide) right
  · exact .andTrue _ _ (.int32 1) (.int32 1) left (by decide) right

theorem guard (s : State) (src len : String) (root : ArrayPointer) (n : Nat) (w : BitVec 32)
    (bound : n<2^64) (cell : Cell s len.toList n) (binding : s.arrays src.toList=some root)
    (capacity : root.index+1≤root.count) (read : Load32 s.heap (elem root 0) w) :
    Eval s (condition src len) (C99ScalarReference.boolean (unit n w)) := by
  have first : Eval s (.cmp .eq (.scalar (var len)) (.scalar (num 1))) (C99ScalarReference.boolean (decide (n=1))) :=
    .cmp .eq _ _ _ _ _ (.scalar _ _ (.variable _ _ _ cell)) (.scalar _ _ (.literal .int32 1)) (eq_one64 n bound)
  have eq : elem root 0=root := by cases root; simp [elem]
  have ptr : C99ArrayReference.Pointer s src.toList (num 0) root :=
    .add _ _ root root (.int32 0) binding (.literal .int32 0) (by decide) (.within root 0 (by omega))
  have second : Eval s (.cmp .eq (.load32 src.toList (num 0)) (.scalar (num 1)))
      (C99ScalarReference.boolean (decide ((C99IntegerReference.Value.uint32 w).integer=1))) :=
    .cmp .eq _ _ _ _ _ (.load32 _ _ _ _ ptr (by simpa only [eq] using read)) (.scalar _ _ (.literal .int32 1)) (eq_one32 w)
  exact and_eval s _ _ _ _ first second

theorem x_source (s : State) (root : ArrayPointer) (n : Nat) (w : BitVec 32)
    (bound : n<2^64) (cell : Cell s "xlen".toList n) (binding : s.arrays "x".toList=some root)
    (capacity : root.index+1≤root.count) (read : Load32 s.heap (elem root 0) w) :
    Exec xBranch s ⟨s,if unit n w then .returned (some (.int32 1)) else .normal⟩ := by
  have g := guard s "x" "xlen" root n w bound cell binding capacity read
  cases h : unit n w
  · exact .branchFalse _ _ _ _ _ (.int32 0) (by simpa [h,C99ScalarReference.boolean] using g) rfl (ZintNormWord194.word_skip s)
  · have ret : Exec (.word (.ret (.scalar (num 1)))) s ⟨s,.returned (some (.int32 1))⟩ :=
      .word _ _ _ (.ret _ _ _ (.scalar _ _ (.literal .int32 1)))
    have yesRun : Exec xYes s ⟨s,.returned (some (.int32 1))⟩ := by
      simpa only [xYes,ZintNormWord194.restore_empty] using
        (Exec.scope [] [] _ s _ (.seqExit _ _ _ _ ret (by intro impossible; cases impossible)))
    exact .branchTrue _ _ _ _ _ (.int32 1) (by simpa [h,C99ScalarReference.boolean] using g) (by decide) yesRun

end FT1536.Source3.BezoutUnitGuard217
