import Source3.BezoutUpperZero217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original mlen = alen < blen ? blen : alen branch. -/
namespace FT1536.Source3.BezoutMlen217
open C99ArrayReference (State bindValue)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenZintCall (Exec Stmt)

def var (s : String) : CLogic.Expr := .var s.toList
def condition : KeygenWordExpr.Expr := .cmp .lt (.scalar (var "alen")) (.scalar (var "blen"))
def set (src : String) : Stmt := .word (.assign "mlen".toList (.scalar (var src)))
def select : Stmt := .branch condition (set "blen") (set "alen")
def tail : Stmt := match BezoutUpperZero217.tail with | .seq _ rest => rest | _ => KeygenZintCall.skip
def after (s : State) (a b : Nat) := bindValue s "mlen".toList .uint64 (.uint64 (word (max a b)))

theorem shape : BezoutUpperZero217.tail=.seq select tail := by decide

theorem source (s : State) (a b : Nat) (aBound : a≤335) (bBound : b≤335)
    (ac : Cell s "alen".toList a) (bc : Cell s "blen".toList b)
    (declared : s.locals "mlen".toList=some (.uint64,none)) :
    Exec select s ⟨after s a b,.normal⟩ ∧ Cell (after s a b) "mlen".toList (max a b) := by
  have cmp : KeygenWordExpr.Eval s condition (C99ScalarReference.boolean (decide (a<b))) :=
    .cmp .lt _ _ _ _ _ (.scalar _ _ (.variable _ _ _ ac)) (.scalar _ _ (.variable _ _ _ bc))
      (C99NatWord141.less a b (by omega) (by omega))
  have bound : max a b<2^64 := by omega
  refine ⟨?_,KeygenMkgm3RowInit.set64_slot s "mlen" (max a b) bound⟩
  by_cases h : a<b
  · have selected : KeygenWordExpr.Eval s condition (.int32 1) := by simpa [h,C99ScalarReference.boolean] using cmp
    have run : Exec (set "blen") s ⟨bindValue s "mlen".toList .uint64 (.uint64 (word b)),.normal⟩ :=
      .word _ _ _ (.assign _ _ _ .uint64 none (.uint64 (word b)) declared (.scalar _ _ (.variable _ _ _ bc)))
    have same : max a b=b := Nat.max_eq_right (by omega)
    simpa only [after,same,select] using (Exec.branchTrue condition (set "blen") (set "alen") s _ (.int32 1) selected (by decide) run)
  · have selected : KeygenWordExpr.Eval s condition (.int32 0) := by simpa [h,C99ScalarReference.boolean] using cmp
    have run : Exec (set "alen") s ⟨bindValue s "mlen".toList .uint64 (.uint64 (word a)),.normal⟩ :=
      .word _ _ _ (.assign _ _ _ .uint64 none (.uint64 (word a)) declared (.scalar _ _ (.variable _ _ _ ac)))
    have same : max a b=a := Nat.max_eq_left (by omega)
    simpa only [after,same,select] using (Exec.branchFalse condition (set "blen") (set "alen") s _ (.int32 0) selected rfl run)

end FT1536.Source3.BezoutMlen217
