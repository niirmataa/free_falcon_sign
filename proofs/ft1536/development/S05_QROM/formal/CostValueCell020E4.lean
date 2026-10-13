import CostBank020E4
import CostScalar020E4
import ArrayValues020E4

namespace FT1536.S05.CostValueCell020E4
open WordRAM020 SyntaxTape020E ArenaTypes020E1 CostRun020E4 CostFlow020E4

/-- Two words per cached Option Word, including the validity flag. -/
def lookup {cap : Nat} (a : ArrayArena020E4.Arena cap) (v : ArrayValues020E4.Values cap)
    (p : Ptr cap) : Run (Option Word) := overhead 2
  (if h : p.val<a.used.val then CostBank020E4.read 2 v ⟨p.val,by have := a.used.isLt;omega⟩
   else CostRun020E4.pure none)

def compute {cap : Nat} (f : Ptr cap → Run (Option Word)) (s : ArrayState020E4.State)
    (n : Node cap) (t : Token) : Run (Option Word) := overhead 16 (match t with
  | .literal w => charge 1 1 (some w)
  | .register r => CostRun020E4.map some (CostBank020E4.read 1 s.reg r)
  | .binary o => optBind (f n.second) (fun x => optBind (f n.first)
      (fun y => CostRun020E4.map some (CostScalar020E4.operate o x y)))
  | _ => charge 1 1 none)

def entry {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : ArrayValues020E4.Values cap) (k : Fin cap) : Run (Option Word) := overhead 2
  (if k.val<a.used.val then CostRun020E4.bind (CostBank020E4.read 5 a.bank k) (fun n =>
    optBind (CostScalar020E4.decode n.cell) (fun t =>
      compute (fun p => overhead 2 (if p.val<k.val then lookup a v p else CostRun020E4.pure none)) s n t))
   else CostRun020E4.pure none)

theorem lookup_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (v : ArrayValues020E4.Values cap)
    (p : Ptr cap) : (lookup a v p).value=ArrayValues020E4.lookup a v p := by
  unfold lookup ArrayValues020E4.lookup
  split <;> rfl

theorem lookup_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (v : ArrayValues020E4.Values cap)
    (p : Ptr cap) : Bounded (lookup a v p) 6 6 := by
  unfold lookup
  split <;> norm_num [Bounded,overhead,CostBank020E4.read,charge,CostRun020E4.pure]

theorem compute_value {cap : Nat} (f : Ptr cap → Run (Option Word)) (s : ArrayState020E4.State)
    (n : Node cap) (t : Token) :
    (compute f s n t).value=ValueSlot020E3.compute (fun p => (f p).value) (ArrayState020E4.model s) n t := by
  cases t
  case binary o =>
    simp only [compute,overhead,ValueSlot020E3.compute]
    rw [optBind_value]
    apply congrArg ((f n.second).value.bind)
    funext x
    rw [optBind_value]
    cases h : (f n.first).value <;> rfl
  all_goals rfl

theorem compute_bound {cap : Nat} (f : Ptr cap → Run (Option Word)) (s : ArrayState020E4.State)
    (n : Node cap) (t : Token) (u v : Nat) (hf : ∀ p,Bounded (f p) u v) :
    Bounded (compute f s n t) (19+2*u) (19+2*v) := by
  cases t
  case binary o =>
    have hi : ∀ x,Bounded (optBind (f n.first)
        (fun y => CostRun020E4.map some (CostScalar020E4.operate o x y))) (u+1+1) (v+1+1) := by
      intro x
      apply optBind_bound _ _ u v 1 1 (hf _)
      intro y
      exact ⟨le_rfl,le_rfl⟩
    have ho := optBind_bound (f n.second) _ u v (u+1+1) (v+1+1) (hf _) hi
    have hh := overhead_bound 16 _ _ _ ho
    simpa only [compute] using (show Bounded (overhead 16 _) (19+2*u) (19+2*v) from by
      rcases hh with ⟨ht,hm⟩;constructor <;> omega)
  all_goals simp only [compute,Bounded,overhead,CostRun020E4.map,CostBank020E4.read,charge]
  all_goals constructor <;> omega

theorem entry_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : ArrayValues020E4.Values cap) (k : Fin cap) : (entry a s v k).value=ArrayValues020E4.entry a s v k := by
  unfold entry ArrayValues020E4.entry
  split
  · simp only [overhead,CostRun020E4.bind,CostBank020E4.read,charge,optBind_value,CostScalar020E4.decode_value,compute_value]
    apply congrArg ((SyntaxCells020E.decode (ArrayBank020E4.read a.bank k).cell).bind)
    funext t
    apply congrArg (fun f => ValueSlot020E3.compute f (ArrayState020E4.model s) (ArrayBank020E4.read a.bank k) t)
    funext p
    by_cases hp : p.val<k.val
    · simp only [ite_eq_left hp,lookup_value]
    · simp only [ite_eq_right hp,CostRun020E4.pure]
  · rfl

theorem entry_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : ArrayValues020E4.Values cap) (k : Fin cap) : Bounded (entry a s v k) 77 77 := by
  have hlookup : ∀ p,Bounded (overhead 2
      (if p.val<k.val then lookup a v p else CostRun020E4.pure none)) 8 8 := by
    intro p
    split
    · exact overhead_bound 2 6 6 _ (lookup_bound a v p)
    · exact ⟨by decide,by decide⟩
  unfold entry
  split
  · apply overhead_bound 2 75 75
    apply bind_bound _ _ 7 7 68 68 ⟨le_rfl,le_rfl⟩
    intro n
    apply optBind_bound _ _ 32 32 35 35 (CostScalar020E4.decode_bound n.cell)
    intro t
    exact compute_bound _ s n t 8 8 hlookup
  · exact ⟨by decide,by decide⟩

end FT1536.S05.CostValueCell020E4
