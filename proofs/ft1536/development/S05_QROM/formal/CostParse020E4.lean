import CostParserStep020E4

namespace FT1536.S05.CostParse020E4
open SyntaxTape020E ArenaTypes020E1 CostRun020E4 CostFlow020E4

def parse {cap : Nat} : List SyntaxCells020E.Cell → ArrayArena020E4.Arena cap → Run (Option (ArrayArena020E4.Arena cap))
  | [],a => charge 4 4 (some a)
  | c::cs,a => overhead 6 (optBind (CostScalar020E4.decode c) (fun t =>
      optBind (CostParserStep020E4.step t a) (parse cs)))

def empty (cap : Nat) : Run (ArrayArena020E4.Arena cap) := overhead 4
  (CostRun020E4.bind (CostBank020E4.zero cap 5 (emptyNode cap)) (fun bank =>
    CostRun020E4.map (fun stack => ⟨bank,stack,0,0⟩) (CostBank020E4.zero cap 1 (0 : Ptr cap))))

/-- Explicit copy from embedded public cells. Six words cover read + copy. -/
def copyImage : List SyntaxCells020E.Cell → Run (List SyntaxCells020E.Cell)
  | [] => charge 4 4 []
  | c::cs => overhead 6 (CostRun020E4.map (List.cons c) (copyImage cs))

def parsePrice (cap n : Nat) : Nat := 4+n*(40+CostParserStep020E4.price cap)
def emptyPrice (cap : Nat) : Nat := 4+((4+cap*9)+(4+cap*5))

theorem value {cap : Nat} (cs : List SyntaxCells020E.Cell) (a : ArrayArena020E4.Arena cap) :
    (parse cs a).value=ArrayArena020E4.parse cs a := by
  induction cs generalizing a with
  | nil => rfl
  | cons c cs ih =>
    simp only [parse,overhead_value,optBind_value,CostScalar020E4.decode_value,CostParserStep020E4.value,ih,
      ArrayArena020E4.parse,ArrayArena020E4.stepCell,Option.bind_assoc]

theorem bound {cap : Nat} (cs : List SyntaxCells020E.Cell) (a : ArrayArena020E4.Arena cap) :
    Bounded (parse cs a) (parsePrice cap cs.length) (parsePrice cap cs.length) := by
  induction cs generalizing a with
  | nil => simp only [parsePrice,List.length_nil,Nat.zero_mul,Nat.add_zero,parse,Bounded,charge,le_refl,and_self]
  | cons c cs ih =>
    have h := optBind_bound (CostScalar020E4.decode c) _ 32 32
      (CostParserStep020E4.price cap+1+parsePrice cap cs.length)
      (CostParserStep020E4.price cap+1+parsePrice cap cs.length) (CostScalar020E4.decode_bound c)
      (fun t => optBind_bound (CostParserStep020E4.step t a) _ _ _ _ _ (CostParserStep020E4.bound t a) ih)
    exact CostBounds020E4.weaken (overhead_bound 6 _ _ _ h)
      (by simp only [parsePrice,List.length_cons,Nat.add_mul,Nat.one_mul];omega)
      (by simp only [parsePrice,List.length_cons,Nat.add_mul,Nat.one_mul];omega)

theorem empty_value (cap : Nat) : (empty cap).value=ArrayArena020E4.empty cap := by
  simp only [empty,overhead_value,CostRun020E4.bind_value,CostRun020E4.map,CostBank020E4.zero_value,ArrayArena020E4.empty]

theorem empty_bound (cap : Nat) : Bounded (empty cap) (emptyPrice cap) (emptyPrice cap) := by
  apply overhead_bound 4 _ _
  apply bind_bound _ _ (4+cap*9) (4+cap*9) (4+cap*5) (4+cap*5)
  · exact ⟨(CostBank020E4.zero_budget cap 5 (emptyNode cap)).1.le,(CostBank020E4.zero_budget cap 5 (emptyNode cap)).2.le⟩
  · intro b
    exact ⟨(CostBank020E4.zero_budget cap 1 (0 : Ptr cap)).1.le,(CostBank020E4.zero_budget cap 1 (0 : Ptr cap)).2.le⟩

theorem copy_value (cs : List SyntaxCells020E.Cell) : (copyImage cs).value=cs := by
  induction cs with
  | nil => rfl
  | cons c cs ih => simp only [copyImage,overhead_value,CostRun020E4.map,ih]

theorem copy_budget (cs : List SyntaxCells020E.Cell) :
    (copyImage cs).ticks=4+6*cs.length ∧ (copyImage cs).allocated=4+6*cs.length := by
  induction cs with
  | nil => exact ⟨rfl,rfl⟩
  | cons c cs ih =>
    simp only [copyImage,overhead,CostRun020E4.map,List.length_cons,ih.1,ih.2]
    constructor <;> omega

def load (cap : Nat) (cells : List SyntaxCells020E.Cell) : Run (Option (ArrayArena020E4.Arena cap)) :=
  CostRun020E4.bind (copyImage cells) (fun cs => CostRun020E4.bind (empty cap) (parse cs))

def loadPrice (cap n : Nat) : Nat := (4+6*n)+(emptyPrice cap+parsePrice cap n)

theorem load_value (cap : Nat) (cells : List SyntaxCells020E.Cell) :
    (load cap cells).value=ArrayArena020E4.parse cells (ArrayArena020E4.empty cap) := by
  simp only [load,CostRun020E4.bind_value,copy_value,empty_value,value]

theorem load_bound (cap : Nat) (cells : List SyntaxCells020E.Cell) :
    Bounded (load cap cells) (loadPrice cap cells.length) (loadPrice cap cells.length) := by
  constructor
  · simp only [load,CostRun020E4.bind_ticks,copy_value,empty_value,loadPrice]
    rw [(copy_budget cells).1]
    exact Nat.add_le_add_left (Nat.add_le_add (empty_bound cap).1 (bound cells (ArrayArena020E4.empty cap)).1) _
  · simp only [load,CostRun020E4.bind_allocated,copy_value,empty_value,loadPrice]
    rw [(copy_budget cells).2]
    exact Nat.add_le_add_left (Nat.add_le_add (empty_bound cap).2 (bound cells (ArrayArena020E4.empty cap)).2) _

end FT1536.S05.CostParse020E4
