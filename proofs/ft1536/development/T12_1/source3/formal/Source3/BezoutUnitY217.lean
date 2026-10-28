import Source3.SelectedBezoutUnitX217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Second unit case in the actual part6, including both source copies. -/
namespace FT1536.Source3.BezoutUnitY217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenZintCall (Exec Stmt)
open StepCopyBody190 (elem)
open BezoutUnitGuard217 (condition unit num)

def first : Stmt := BezoutCopySource217.copy "u" "u1" "ylen"
def second : Stmt := BezoutCopySource217.copy "v" "v1" "xlen"
def yes : Stmt := .scope [] [] (.seq first (.seq second (.seq (.word (.ret (.scalar (num 1)))) ZintNormWord194.wskip)))
def branch : Stmt := .branch (condition "y" "ylen") yes ZintNormWord194.wskip
def tail : Stmt := match BezoutUnitGuard217.tail with | .seq _ rest => rest | _ => KeygenZintCall.skip

theorem shape : BezoutUnitGuard217.tail=.seq branch tail := by decide

theorem source (s mid out : State) (xr yr : ArrayPointer) (nx ny : Nat) (x y : BitVec 32)
    (xb : nx<2^64) (yb : ny<2^64) (xc : Cell s "xlen".toList nx) (yc : Cell s "ylen".toList ny)
    (xp : s.arrays "x".toList=some xr) (yp : s.arrays "y".toList=some yr)
    (xcap : xr.index+1≤xr.count) (ycap : yr.index+1≤yr.count)
    (xread : Load32 s.heap (elem xr 0) x) (yread : Load32 s.heap (elem yr 0) y)
    (xno : unit nx x=false) (yyes : unit ny y=true)
    (copyU : Exec first s ⟨mid,.normal⟩) (copyV : Exec second mid ⟨out,.normal⟩) :
    Exec (KeygenZintCall.bezoutPart 6) s ⟨out,.returned (some (.int32 1))⟩ := by
  have xrun := BezoutUnitGuard217.x_source s xr nx x xb xc xp xcap xread
  rw [xno] at xrun
  have yguard := BezoutUnitGuard217.guard s "y" "ylen" yr ny y yb yc yp ycap yread
  have ret : Exec (.word (.ret (.scalar (num 1)))) out ⟨out,.returned (some (.int32 1))⟩ :=
    .word _ _ _ (.ret _ _ _ (.scalar _ _ (.literal .int32 1)))
  have yesRun : Exec yes s ⟨out,.returned (some (.int32 1))⟩ := by
    simpa only [yes,ZintNormWord194.restore_empty] using
      (Exec.scope [] [] _ s _ (.seqNormal _ _ _ _ _ copyU (.seqNormal _ _ _ _ _ copyV
        (.seqExit _ _ _ _ ret (by intro impossible; cases impossible)))))
  have yrun : Exec branch s ⟨out,.returned (some (.int32 1))⟩ :=
    .branchTrue _ _ _ _ _ (.int32 1) (by simpa [yyes,C99ScalarReference.boolean] using yguard) (by decide) yesRun
  rw [BezoutUnitGuard217.shape,shape]
  exact .seqNormal _ _ _ _ _ xrun (.seqExit _ _ _ _ yrun (by intro impossible; cases impossible))

end FT1536.Source3.BezoutUnitY217
