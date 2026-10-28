import Source3.SelectedBezoutUnitY217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original nonunit path computes both ninv words using actual callee source. -/
namespace FT1536.Source3.BezoutNormalNinv217
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenWordExpr (Expr Eval)
open KeygenZintCall (Stmt Exec)
open StepCopyBody190 (elem)
open BezoutUnitGuard217 (num unit)

def assign (dst src : String) : Stmt := .word (.assign dst.toList
  (.call1 "modp_ninv31".toList (.load32 src.toList (num 0))))
def afterX (s : State) (x : BitVec 32) := bindValue s "x0i".toList .uint32 (.uint32 (KeygenNinv31.word x))
def after (s : State) (x y : BitVec 32) := bindValue (afterX s x) "y0i".toList .uint32 (.uint32 (KeygenNinv31.word y))

theorem shape : BezoutUnitY217.tail=.seq (assign "x0i" "x") (.seq (assign "y0i" "y") ZintNormWord194.wskip) := by decide

theorem source_one (s : State) (dst src : String) (root : ArrayPointer) (w : BitVec 32)
    (declared : s.locals dst.toList=some (.uint32,none)) (binding : s.arrays src.toList=some root)
    (capacity : root.index+1≤root.count) (read : Load32 s.heap (elem root 0) w) :
    Exec (assign dst src) s ⟨bindValue s dst.toList .uint32 (.uint32 (KeygenNinv31.word w)),.normal⟩ := by
  have eq : elem root 0=root := by cases root; simp [elem]
  have ptr : C99ArrayReference.Pointer s src.toList (num 0) root :=
    .add _ _ root root (.int32 0) binding (.literal .int32 0) (by decide) (.within root 0 (by omega))
  have load : Eval s (.load32 src.toList (num 0)) (.uint32 w) :=
    .load32 _ _ _ _ ptr (by simpa only [eq] using read)
  have call : Eval s (.call1 "modp_ninv31".toList (.load32 src.toList (num 0))) (.uint32 (KeygenNinv31.word w)) :=
    .call1 _ _ _ _ load (.inverse _ _ (KeygenNinv31.source_exists w))
  exact .word _ _ _ (.assign _ _ _ .uint32 none _ declared call)

theorem source (s : State) (xr yr : ArrayPointer) (nx ny : Nat) (x y : BitVec 32)
    (xb : nx<2^64) (yb : ny<2^64) (xc : Cell s "xlen".toList nx) (yc : Cell s "ylen".toList ny)
    (xp : s.arrays "x".toList=some xr) (yp : s.arrays "y".toList=some yr)
    (xcap : xr.index+1≤xr.count) (ycap : yr.index+1≤yr.count)
    (xread : Load32 s.heap (elem xr 0) x) (yread : Load32 s.heap (elem yr 0) y)
    (dx : s.locals "x0i".toList=some (.uint32,none)) (dy : s.locals "y0i".toList=some (.uint32,none))
    (xno : unit nx x=false) (yno : unit ny y=false) :
    Exec (KeygenZintCall.bezoutPart 6) s ⟨after s x y,.normal⟩ := by
  have xrun := BezoutUnitGuard217.x_source s xr nx x xb xc xp xcap xread
  rw [xno] at xrun
  have yg := BezoutUnitGuard217.guard s "y" "ylen" yr ny y yb yc yp ycap yread
  have yrun : Exec BezoutUnitY217.branch s ⟨s,.normal⟩ :=
    .branchFalse _ _ _ _ _ (.int32 0) (by simpa [yno,C99ScalarReference.boolean] using yg) rfl (ZintNormWord194.word_skip s)
  have first := source_one s "x0i" "x" xr x dx xp xcap xread
  have dy' : (afterX s x).locals "y0i".toList=some (.uint32,none) :=
    (SelectedStepAddPrime195.locals_keep s "x0i".toList .uint32 (.uint32 (KeygenNinv31.word x)) "y0i".toList (by decide)).trans dy
  have second := source_one (afterX s x) "y0i" "y" yr y dy' yp ycap yread
  rw [BezoutUnitGuard217.shape,BezoutUnitY217.shape,shape]
  exact .seqNormal _ _ _ _ _ xrun (.seqNormal _ _ _ _ _ yrun
    (.seqNormal _ _ _ _ _ first (.seqNormal _ _ _ _ _ second (ZintNormWord194.word_skip _))))

end FT1536.Source3.BezoutNormalNinv217
