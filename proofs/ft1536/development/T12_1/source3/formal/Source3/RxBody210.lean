import Source3.RxModel210

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.RxBody210
open C99ArrayReference (State Name)
open C99ModularReference (GenExec GenEval LeafCall rxCell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32)
open RxControl210 (ISlot bit)
open RxModel210 (mont chosen)

abbrev Run := GenExec LeafCall
abbrev Eval := GenEval LeafCall

def withZ (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32) :=
  if (x &&& bit i).toNat=0 then s else set32 s "z" (mont z r p pi)
 def after (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32) := set32 (withZ s x i z r p pi) "r" (mont r r p pi)

theorem cell (s : State) (name : String) (w : BitVec 32) (h : Slot s name w) : Eval s (rxCell name) (.uint32 w) :=
  .scalar _ _ (.variable _ _ _ h)

theorem assign (s : State) (name : String) (old : Option C99IntegerReference.Value) (e : C99ModularReference.Expr) (w : BitVec 32)
    (declared : s.locals name.toList=some (.uint32,old)) (value : Eval s e (.uint32 w)) :
    Run (.assign name.toList e) s ⟨set32 s name w,.normal⟩ := .assign _ _ _ _ _ _ declared value

theorem withZ_locals (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32) (name : Name) (nz : name≠"z".toList) :
    (withZ s x i z r p pi).locals name=s.locals name := by
  by_cases empty : (x &&& bit i).toNat=0
  · rw [withZ,ite_eq_left empty]
  · rw [withZ,ite_eq_right empty]
    exact SelectedStepAddPrime195.locals_keep s "z".toList .uint32 (.uint32 (mont z r p pi)) name nz

theorem zChosen (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32) (zc : Slot s "z" z) :
    Slot (withZ s x i z r p pi) "z" (chosen x i z r p pi) := by
  by_cases empty : (x &&& bit i).toNat=0
  · simp only [withZ,chosen,ite_eq_left empty]
    exact zc
  · simp only [withZ,chosen,ite_eq_right empty]
    exact CrtState205.cell32 _ _ _

theorem if_source (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32)
    (ib : i < 10) (ic : ISlot s i) (xc : Slot s "x" x) (zc : Slot s "z" z) (rc : Slot s "r" r)
    (pc : Slot s "p" p) (pic : Slot s "p0i" pi) :
    Run C99ModularReference.rxIfStep s ⟨withZ s x i z r p pi,.normal⟩ := by
  have guard:=RxControl210.branch_guard s i x (by omega) ic xc
  by_cases empty : (x &&& bit i).toNat=0
  · have test : C99ArrayReference.scalar s C99ModularReference.rxBranchGuard (.int32 0) := by
      rw [decide_eq_false (fun different => different empty)] at guard
      exact guard
    rw [withZ,ite_eq_left empty]
    exact .branchFalse _ _ _ _ _ (.int32 0) test (by decide) (.base _ _ _ (.skip s))
  · have test : C99ArrayReference.scalar s C99ModularReference.rxBranchGuard (.int32 1) := by
      rw [decide_eq_true empty] at guard
      exact guard
    have value : Eval s C99ModularReference.rxZMont (.uint32 (mont z r p pi)) :=
      .call4 _ _ _ _ _ _ _ _ _ _ (cell s "z" z zc) (cell s "r" r rc) (cell s "p" p pc) (cell s "p0i" pi pic)
        (.montgomery _ _ (KeygenModpWord.source_exists z r p pi))
    have update : Run C99ModularReference.rxZAssign s ⟨set32 s "z" (mont z r p pi),.normal⟩ := assign s "z" _ _ _ zc value
    have inner : Run C99ModularReference.rxIfBody s ⟨set32 s "z" (mont z r p pi),.normal⟩ :=
      .scope _ _ _ _ (.seqNormal _ _ _ _ _ update (.base _ _ _ (.skip _)))
    rw [withZ,ite_eq_right empty]
    exact .branchTrue _ _ _ _ _ (.int32 1) test (by decide) inner

theorem source (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32)
    (ib : i < 10) (ic : ISlot s i) (xc : Slot s "x" x) (zc : Slot s "z" z) (rc : Slot s "r" r)
    (pc : Slot s "p" p) (pic : Slot s "p0i" pi) :
    Run C99ModularReference.rxLoopBody s ⟨after s x i z r p pi,.normal⟩ := by
  have rr : Slot (withZ s x i z r p pi) "r" r := (withZ_locals s x i z r p pi "r".toList (by decide)).trans rc
  have pp : Slot (withZ s x i z r p pi) "p" p := (withZ_locals s x i z r p pi "p".toList (by decide)).trans pc
  have ii : Slot (withZ s x i z r p pi) "p0i" pi := (withZ_locals s x i z r p pi "p0i".toList (by decide)).trans pic
  have value : Eval (withZ s x i z r p pi) C99ModularReference.rxRMont (.uint32 (mont r r p pi)) :=
    .call4 _ _ _ _ _ _ _ _ _ _ (cell _ "r" r rr) (cell _ "r" r rr) (cell _ "p" p pp) (cell _ "p0i" pi ii)
      (.montgomery _ _ (KeygenModpWord.source_exists r r p pi))
  have update : Run C99ModularReference.rxRAssign (withZ s x i z r p pi) ⟨after s x i z r p pi,.normal⟩ := assign _ "r" _ _ _ rr value
  exact .scope _ _ _ _ (.seqNormal _ _ _ _ _ (if_source s x i z r p pi ib ic xc zc rc pc pic)
    (.seqNormal _ _ _ _ _ update (.base _ _ _ (.skip _))))

theorem locals (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32) (name : Name)
    (nz : name≠"z".toList) (nr : name≠"r".toList) : (after s x i z r p pi).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (withZ s x i z r p pi) "r".toList .uint32 (.uint32 (mont r r p pi)) name nr).trans
    (withZ_locals s x i z r p pi name nz)

theorem rCell (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32) : Slot (after s x i z r p pi) "r" (mont r r p pi) := CrtState205.cell32 _ _ _

theorem zCell (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32) (zc : Slot s "z" z) :
    Slot (after s x i z r p pi) "z" (chosen x i z r p pi) :=
  (CrtState205.keep32 (withZ s x i z r p pi) "r" "z" (mont r r p pi) (by decide)).trans (zChosen s x i z r p pi zc)

theorem heap (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32) : (after s x i z r p pi).heap=s.heap := by
  by_cases empty : (x &&& bit i).toNat=0
  · simp only [after,withZ,ite_eq_left empty]; rfl
  · simp only [after,withZ,ite_eq_right empty]; rfl

theorem arrays (s : State) (x : BitVec 32) (i : Nat) (z r p pi : BitVec 32) : (after s x i z r p pi).arrays=s.arrays := by
  by_cases empty : (x &&& bit i).toNat=0
  · simp only [after,withZ,ite_eq_left empty]; rfl
  · simp only [after,withZ,ite_eq_right empty]; rfl

end FT1536.Source3.RxBody210
