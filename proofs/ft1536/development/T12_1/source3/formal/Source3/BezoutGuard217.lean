import Source3.BezoutGuardOps217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutGuard217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenZintCall (Exec)
open KeygenWordExpr (Expr Eval)
open ZintNormWalkFlat208 (Data)
open StepCopyBody190 (elem)
open BezoutGuardOps217 (andWord)

def var (n : String) : CLogic.Expr := .var n.toList
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def xzero : Expr := .cmp .eq (.scalar (var "xlen")) (.scalar (num 0))
def yzero : Expr := .cmp .eq (.scalar (var "ylen")) (.scalar (num 0))
def low : Expr := .bin .band (.bin .band (.load32 "x".toList (num 0)) (.load32 "y".toList (num 0))) (.scalar (num 1))
def lowzero : Expr := .cmp .eq low (.scalar (num 0))
def condition : Expr := .lor (.lor xzero yzero) lowzero
def yes : KeygenZintCall.Stmt := .scope [] [] (.seq (.word (.ret (.scalar (num 0)))) ZintNormWord194.wskip)
def code : KeygenZintCall.Stmt := .seq (.branch condition yes ZintNormWord194.wskip) ZintNormWord194.wskip

def bad (lx ly : Nat) (x y : BitVec 32) : Bool :=
  decide (lx=0) || decide (ly=0) || decide ((C99IntegerReference.Value.uint32 (andWord (andWord x y) 1)).integer=0)

theorem shape : KeygenZintCall.bezoutPart 3=code := by decide

theorem band_one (x : BitVec 32) : C99OperatorBridge.Binary .band (.uint32 x) (.int32 1) (.uint32 (andWord x 1)) := by
  have raw := C99IntegerReference.BitwiseExec.step .and (.uint32 x) (.int32 1) .uint32 rfl (.uint32 x) (.uint32 1)
    (C99CountedWords.convert_self (.uint32 x)).symm rfl
  change C99IntegerReference.BitwiseExec .and (.uint32 x) (.int32 1)
    (.uint32 (BitVec.ofInt 32 ((x.toNat &&& (1 : Nat) : Nat) : Int))) at raw
  rw [BitVec.ofInt_natCast] at raw
  change C99IntegerReference.BitwiseExec .and (.uint32 x) (.int32 1)
    (.uint32 (BitVec.ofNat 32 (x.toNat &&& 1)))
  exact raw

theorem or_eval (s : State) (a b : Expr) (p q : Bool)
    (left : Eval s a (C99ScalarReference.boolean p)) (right : Eval s b (C99ScalarReference.boolean q)) :
    Eval s (.lor a b) (C99ScalarReference.boolean (p || q)) := by
  cases p <;> cases q
  · exact .orFalse _ _ (.int32 0) (.int32 0) left rfl right
  · exact .orFalse _ _ (.int32 0) (.int32 1) left rfl right
  · exact .orTrue _ _ (.int32 1) left (by decide)
  · exact .orTrue _ _ (.int32 1) left (by decide)

theorem guard (s : State) (rootX rootY : ArrayPointer) (lx ly : Nat) (x y : BitVec 32)
    (lxBound : lx<2^64) (lyBound : ly<2^64)
    (xc : Cell s "xlen".toList lx) (yc : Cell s "ylen".toList ly)
    (xb : s.arrays "x".toList=some rootX) (yb : s.arrays "y".toList=some rootY)
    (xcap : rootX.index+1≤rootX.count) (ycap : rootY.index+1≤rootY.count)
    (xr : Load32 s.heap (elem rootX 0) x) (yr : Load32 s.heap (elem rootY 0) y) :
    Eval s condition (C99ScalarReference.boolean (bad lx ly x y)) := by
  have cx : Eval s xzero (C99ScalarReference.boolean (decide (lx=0))) :=
    .cmp .eq _ _ _ _ _ (.scalar _ _ (.variable _ _ _ xc)) (.scalar _ _ (.literal .int32 0)) (BezoutGuardOps217.eq_zero64 lx lxBound)
  have cy : Eval s yzero (C99ScalarReference.boolean (decide (ly=0))) :=
    .cmp .eq _ _ _ _ _ (.scalar _ _ (.variable _ _ _ yc)) (.scalar _ _ (.literal .int32 0)) (BezoutGuardOps217.eq_zero64 ly lyBound)
  have xeq : elem rootX 0=rootX := by cases rootX; simp [elem]
  have yeq : elem rootY 0=rootY := by cases rootY; simp [elem]
  have xptr : C99ArrayReference.Pointer s "x".toList (num 0) rootX :=
    .add _ _ rootX rootX (.int32 0) xb (.literal .int32 0) (by decide) (.within rootX 0 (by omega))
  have yptr : C99ArrayReference.Pointer s "y".toList (num 0) rootY :=
    .add _ _ rootY rootY (.int32 0) yb (.literal .int32 0) (by decide) (.within rootY 0 (by omega))
  have readX : Eval s (.load32 "x".toList (num 0)) (.uint32 x) := .load32 _ _ _ _ xptr (by simpa only [xeq] using xr)
  have readY : Eval s (.load32 "y".toList (num 0)) (.uint32 y) := .load32 _ _ _ _ yptr (by simpa only [yeq] using yr)
  have both : Eval s (.bin .band (.load32 "x".toList (num 0)) (.load32 "y".toList (num 0))) (.uint32 (andWord x y)) :=
    .bin .band _ _ _ _ _ readX readY (BezoutGuardOps217.band x y)
  have masked : Eval s low (.uint32 (andWord (andWord x y) 1)) :=
    .bin .band _ _ _ _ _ both (.scalar _ _ (.literal .int32 1)) (band_one (andWord x y))
  have cz : Eval s lowzero (C99ScalarReference.boolean (decide ((C99IntegerReference.Value.uint32 (andWord (andWord x y) 1)).integer=0))) :=
    .cmp .eq _ _ _ _ _ masked (.scalar _ _ (.literal .int32 0)) (BezoutGuardOps217.eq_zero32 _)
  exact or_eval s _ _ _ _ (or_eval s _ _ _ _ cx cy) cz

theorem source (s : State) (rootX rootY : ArrayPointer) (lx ly : Nat) (x y : BitVec 32)
    (lxBound : lx<2^64) (lyBound : ly<2^64)
    (xc : Cell s "xlen".toList lx) (yc : Cell s "ylen".toList ly)
    (xb : s.arrays "x".toList=some rootX) (yb : s.arrays "y".toList=some rootY)
    (xcap : rootX.index+1≤rootX.count) (ycap : rootY.index+1≤rootY.count)
    (xr : Load32 s.heap (elem rootX 0) x) (yr : Load32 s.heap (elem rootY 0) y) :
    Exec (KeygenZintCall.bezoutPart 3) s
      ⟨s,if bad lx ly x y then .returned (some (.int32 0)) else .normal⟩ := by
  rw [shape]
  have g := guard s rootX rootY lx ly x y lxBound lyBound xc yc xb yb xcap ycap xr yr
  cases h : bad lx ly x y
  · have branch : Exec (.branch condition yes ZintNormWord194.wskip) s ⟨s,.normal⟩ :=
      .branchFalse _ _ _ s _ (.int32 0) (by simpa [h,C99ScalarReference.boolean] using g) rfl (ZintNormWord194.word_skip s)
    exact .seqNormal _ _ _ _ _ branch (ZintNormWord194.word_skip s)
  · have ret : Exec (.word (.ret (.scalar (num 0)))) s ⟨s,.returned (some (.int32 0))⟩ :=
      .word _ _ _ (.ret _ _ _ (.scalar _ _ (.literal .int32 0)))
    have yesRun : Exec yes s ⟨s,.returned (some (.int32 0))⟩ := by
      simpa only [yes,ZintNormWord194.restore_empty] using
        (Exec.scope [] [] _ s _ (.seqExit _ _ _ _ ret (by intro impossible; cases impossible)))
    have branch : Exec (.branch condition yes ZintNormWord194.wskip) s ⟨s,.returned (some (.int32 0))⟩ :=
      .branchTrue _ _ _ s _ (.int32 1) (by simpa [h,C99ScalarReference.boolean] using g) (by decide) yesRun
    exact .seqExit _ _ _ _ branch (by intro impossible; cases impossible)

end FT1536.Source3.BezoutGuard217
