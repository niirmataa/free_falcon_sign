import CostControl020E4
import ArrayArena020E4

namespace FT1536.S05.CostParserRead020E4
open SyntaxTape020E ArenaTypes020E1 CostRun020E4 CostFlow020E4

def peek {cap : Nat} (a : ArrayArena020E4.Arena cap) (j : Nat) : Run (Ptr cap) := overhead 4
  (if h : j<a.sp.val then CostBank020E4.read 1 a.stack ⟨a.sp.val-1-j,by have := a.sp.isLt;omega⟩
   else CostRun020E4.pure 0)

/-- Token encoding, constructors and three guarded parser-stack reads. -/
def fresh {cap : Nat} (a : ArrayArena020E4.Arena cap) (t : Token) : Run (Node cap) := overhead 32
  (CostRun020E4.bind (peek a 0) (fun p => CostRun020E4.bind (peek a 1) (fun q =>
    CostRun020E4.bind (peek a 2) (fun r => charge 8 8 ⟨SyntaxCells020E.encode t,p,q,r⟩))))

def kind {cap : Nat} (a : ArrayArena020E4.Arena cap) (p : Ptr cap) : Run (Option Kind) := overhead 16
  (CostRun020E4.map (Option.map (fun nt => resultKind nt.2)) (CostControl020E4.inspect a p))

def kinds {cap : Nat} (a : ArrayArena020E4.Arena cap) : List (Ptr cap) → Run (List (Option Kind))
  | [] => charge 2 2 []
  | p::ps => overhead 3 (CostRun020E4.bind (kind a p)
      (fun k => CostRun020E4.map (List.cons k) (kinds a ps)))

theorem peek_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (j : Nat) :
    (peek a j).value=ArenaStack020E1.peek (ArrayArena020E4.model a) j := by
  unfold peek ArenaStack020E1.peek
  by_cases h : j<a.sp.val
  · have h' : j<(ArrayArena020E4.model a).sp.val := h
    simp only [dite_eq_left h,dite_eq_left h',overhead_value,CostBank020E4.read_value]
    rfl
  · have h' : ¬j<(ArrayArena020E4.model a).sp.val := h
    simp only [dite_eq_right h,dite_eq_right h']
    rfl

theorem peek_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (j : Nat) : Bounded (peek a j) 7 7 := by
  unfold peek
  split
  · exact ⟨le_rfl,le_rfl⟩
  · exact ⟨by change 4≤7;omega,by change 4≤7;omega⟩

theorem fresh_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (t : Token) :
    (fresh a t).value=ArenaStackRead020E1.freshNode (ArrayArena020E4.model a) t := by
  simp only [fresh,overhead_value,CostRun020E4.bind_value,peek_value,charge,ArenaStackRead020E1.freshNode]

theorem fresh_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (t : Token) : Bounded (fresh a t) 61 61 := by
  apply overhead_bound 32 29 29
  apply bind_bound _ _ 7 7 22 22 (peek_bound a 0)
  intro p
  apply bind_bound _ _ 7 7 15 15 (peek_bound a 1)
  intro q
  apply bind_bound _ _ 7 7 8 8 (peek_bound a 2)
  intro r
  exact ⟨le_rfl,le_rfl⟩

theorem kind_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (p : Ptr cap) :
    (kind a p).value=ArenaStep020E1.checkedKind (ArrayArena020E4.model a) p := by
  simp only [kind,overhead_value,CostRun020E4.map,CostControl020E4.inspect_value,
    NodeRead020E2.inspect,NodeRead020E2.read,ArenaStep020E1.checkedKind]
  split
  · simp only [Option.bind_some,Option.map_map,nodeKind]
    rfl
  · rfl

theorem kind_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (p : Ptr cap) : Bounded (kind a p) 59 59 :=
  overhead_bound 16 43 43 _ (CostControl020E4.inspect_bound a p)

theorem kinds_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (ps : List (Ptr cap)) :
    (kinds a ps).value=ps.map (ArenaStep020E1.checkedKind (ArrayArena020E4.model a)) := by
  induction ps with
  | nil => rfl
  | cons p ps ih => simp only [kinds,overhead_value,CostRun020E4.bind_value,CostRun020E4.map,kind_value,ih,List.map_cons]

theorem kinds_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (ps : List (Ptr cap)) :
    Bounded (kinds a ps) (2+ps.length*62) (2+ps.length*62) := by
  induction ps with
  | nil => exact ⟨le_rfl,le_rfl⟩
  | cons p ps ih =>
    have h := bind_bound (kind a p) _ 59 59 (2+ps.length*62) (2+ps.length*62) (kind_bound a p) (fun _ => ih)
    exact CostBounds020E4.weaken (overhead_bound 3 _ _ _ h)
      (by simp only [List.length_cons,Nat.add_mul,Nat.one_mul];omega)
      (by simp only [List.length_cons,Nat.add_mul,Nat.one_mul];omega)

end FT1536.S05.CostParserRead020E4
