import Expressions
set_option maxRecDepth 16384
set_option maxHeartbeats 50000000
namespace FT1536Global
open LExpr

def slot (k : Bool) : Fin 3 := if k then 1 else 0
def pairInput (v : Bool → Int) : Fin 3 → Int := fun j => if j=0 then v false else if j=1 then v true else 0
def rootFExpr (r : Int) (k : Fin 3) : LExpr :=
  let a:=var 0;let b:=var 1;let z:=mr b r
  if k=0 then add a z else if k=1 then sub (add a b) z else var 2
def rootIExpr (r : Int) (k : Fin 3) : LExpr :=
  let a:=var 0;let b:=var 1;let z:=ml r (sub a b)
  if k=0 then sub (add a b) z else if k=1 then add z z else add (var 2) (var 2)
def binFExpr (r : Int) (k : Fin 3) : LExpr :=
  let a:=var 0;let z:=mr (var 1) r
  if k=0 then add a z else if k=1 then sub a z else var 2
def binIExpr (r : Int) (k : Fin 3) : LExpr :=
  let a:=var 0;let b:=var 1
  if k=0 then add a b else if k=1 then mr (sub a b) r else add (var 2) (var 2)
def cubeFExpr (x w : Int) (k : Fin 3) : LExpr :=
  let a:=var 0;let b:=var 1;let c:=var 2;let x2:=mmQ x x
  let b0:=mr b x;let b1:=mr b0 w;let b2:=mr b1 w
  let c0:=mr c x2;let c1:=mr c0 w;let c2:=mr c1 w
  if k=0 then add a (add b0 c0) else if k=1 then add a (add b1 c2) else add a (add b2 c1)
def cubeIExpr (x w : Int) (k : Fin 3) : LExpr :=
  let a:=var 0;let b:=var 1;let c:=var 2;let x2:=mmQ x x
  let b1:=mr b w;let b2:=mr b1 w;let c1:=mr c w;let c2:=mr c1 w
  if k=0 then add a (add b c) else if k=1 then ml x (add a (add b1 c2)) else ml x2 (add a (add b2 c1))
def fW : Int := mmQ (gmAt 1) (gmAt 1)
def iW : Int := mmQ (igmAt 1) (igmAt 1)

theorem rootF_bind (b : Nat) (v : Fin 3 → Int) (k : Bool) :
    (rootFExpr (gmAt 1) (slot k)).eval v=forwardRootOp b (fun j => v (slot j)) k := by cases k <;> rfl
theorem rootI_bind (b : Nat) (v : Fin 3 → Int) (k : Bool) :
    (rootIExpr (igmAt 0) (slot k)).eval v=inverseRootOp b (fun j => v (slot j)) k := by cases k <;> rfl
theorem binF_bind (m ht b : Nat) (v : Fin 3 → Int) (k : Bool) :
    (binFExpr (gmAt (m+b/ht)) (slot k)).eval v=forwardBinaryOp m ht b (fun j => v (slot j)) k := by cases k <;> rfl
theorem binI_bind (m ht b : Nat) (v : Fin 3 → Int) (k : Bool) :
    (binIExpr (igmAt (m+b/ht)) (slot k)).eval v=inverseBinaryOp m ht b (fun j => v (slot j)) k := by cases k <;> rfl
theorem cubeF_bind (b : Nat) (v : Fin 3 → Int) (k : Fin 3) :
    (cubeFExpr (gmAt (512+b)) fW k).eval v=forwardCubicOp b v k := by
  rcases fin3_cases k with rfl|rfl|rfl <;> rfl
theorem cubeI_bind (b : Nat) (v : Fin 3 → Int) (k : Fin 3) :
    (cubeIExpr (igmAt (512+b)) iW k).eval v=inverseCubicOp b v k := by
  rcases fin3_cases k with rfl|rfl|rfl <;> rfl

def blockCheck (f g : Fin 3 → LExpr) (scale : Int) : Bool :=
  ([0,1,2] : List (Fin 3)).all (fun k => ([0,1,2] : List (Fin 3)).all
    (fun j => decide ((g k |>.subst f).eval (basis j) = if j=k then scale%18433 else 0)))
theorem fin3_mem (k : Fin 3) : k∈([0,1,2] : List (Fin 3)) := by
  rcases fin3_cases k with rfl|rfl|rfl <;> decide
theorem blockCheck_sound (f g : Fin 3 → LExpr) (scale : Int) (h : blockCheck f g scale=true)
    (v : Fin 3 → Int) (hv : ∀ j, CanonVal (v j)) (k : Fin 3) :
    (g k).eval (fun j => (f j).eval v)=(scale*v k)%18433 := by
  rw [←eval_subst]
  apply eval_diagonal _ k scale _ v hv
  intro j
  exact of_decide_eq_true (List.all_eq_true.mp (List.all_eq_true.mp h k (fin3_mem k)) j (fin3_mem j))

theorem row_ids : unitRows.map rowID=(List.range 1024).map (fun i : Nat => (i : Int)) := by decide
theorem unitRow_id (i : Fin 1024) : rowID (unitRow i)=(i.val : Int) := by
  change rowID (unitRows[i.val]'_)=(i.val : Int)
  have hi : i.val<(unitRows.map rowID).length := by simpa only [List.length_map,unitRows_length] using i.isLt
  rw [←List.getElem_map (h:=hi)]
  simp only [row_ids,List.getElem_map,List.getElem_range]

-- Checking source expressions binds the previously checked words to every
-- variable input, by blockCheck_sound. The unused third pair coordinate is
-- an algebraic embedding only; pairStep never accesses it.
def localCheck (r : List Int) : Bool :=
  if rowID r=0 then true else
    blockCheck (binFExpr (rowGM r)) (binIExpr (rowIG r)) 2 &&
    blockCheck (cubeFExpr (rowGM r) fW) (cubeIExpr (rowIG r) iW) 3

theorem root_checked : blockCheck (rootFExpr (gmAt 1)) (rootIExpr (igmAt 0)) 2=true := by decide

#check @blockCheck_sound
#print axioms rootF_bind
#print axioms rootI_bind
#print axioms binF_bind
#print axioms binI_bind
#print axioms cubeF_bind
#print axioms cubeI_bind
#print axioms blockCheck_sound
#print axioms row_ids
#print axioms unitRow_id
#print axioms root_checked
end FT1536Global
