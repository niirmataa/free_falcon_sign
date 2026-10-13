import CostAtom020E4
import CostBounds020E4
import ArrayAction020E4

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CostControl020E4
open WordRAM020 SyntaxTape020E ArenaTypes020E1 NodeFrames020E2 CostRun020E4 CostFlow020E4

/-- Guarded node fetch and token decode use the actual dense bank. -/
def inspect {cap : Nat} (a : ArrayArena020E4.Arena cap) (p : Ptr cap) : Run (Option (Node cap × Token)) :=
  overhead 4 (if hp : p.val<a.used.val then
    CostRun020E4.bind (CostBank020E4.read 5 a.bank ⟨p.val,by have := a.used.isLt;omega⟩)
      (fun n => CostRun020E4.map (Option.map (fun t => (n,t))) (CostScalar020E4.decode n.cell))
    else CostRun020E4.pure none)

def loopAction {cap : Nat} (f : Ptr cap → Run (Option Word)) (s : ArrayState020E4.State)
    (pc body guard : Ptr cap) (remaining : Nat) : Run (Option (ArrayAction020E4.Action cap)) := overhead 8
  (if remaining=0 then charge 4 4 (some ([],s)) else optBind (f guard)
    (fun v => if v=0 then charge 4 4 (some ([],s)) else
      charge 10 10 ((count (remaining-1)).map (fun k => ([.run body,.again pc k],s)))))

def dispatch {cap : Nat} (f : Ptr cap → Run (Option Word)) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (pc : Ptr cap) (n : Node cap) (t : Token) : Run (Option (ArrayAction020E4.Action cap)) := overhead 16 (match t with
  | .seq => charge 8 8 (some ([.run n.second,.run n.first],s))
  | .branch => CostRun020E4.bind (f n.third) (fun v => charge 8 8
      (v.map (fun w => ([.run (if w=0 then n.first else n.second)],s))))
  | .loop k => loopAction f s pc n.first n.second k
  | t => overhead 2 (CostRun020E4.map (Option.map (fun q => (([] : List (Frame cap)),q))) (CostAtom020E4.withEval f i s n t)))

theorem inspect_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (p : Ptr cap) :
    (inspect a p).value=NodeRead020E2.inspect (ArrayArena020E4.model a) p := by
  unfold inspect NodeRead020E2.inspect NodeRead020E2.read
  by_cases hp : p.val<a.used.val
  · have hp' : p.val<(ArrayArena020E4.model a).used.val := hp
    simp only [dite_eq_left hp,dite_eq_left hp']
    simp only [Option.bind_some,overhead_value,CostRun020E4.bind,CostBank020E4.read,charge,
      CostRun020E4.map,CostScalar020E4.decode_value]
    rfl
  · have hp' : ¬p.val<(ArrayArena020E4.model a).used.val := hp
    simp only [dite_eq_right hp,dite_eq_right hp']
    rfl

theorem inspect_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (p : Ptr cap) :
    Bounded (inspect a p) 43 43 := by
  unfold inspect
  split
  · apply overhead_bound 4 39 39
    apply bind_bound _ _ 7 7 32 32 ⟨le_rfl,le_rfl⟩
    intro n
    exact CostScalar020E4.decode_bound n.cell
  · exact ⟨by change 4≤43;omega,by change 4≤43;omega⟩

theorem loop_value {cap : Nat} (f : Ptr cap → Run (Option Word)) (s : ArrayState020E4.State)
    (pc body guard : Ptr cap) (remaining : Nat) :
    (loopAction f s pc body guard remaining).value=
      ArrayAction020E4.loopAction (fun p => (f p).value) s pc body guard remaining := by
  unfold loopAction ArrayAction020E4.loopAction
  split
  · rfl
  · rw [overhead_value,optBind_value]
    apply congrArg ((f guard).value.bind)
    funext v
    split <;> rfl

theorem loop_bound {cap : Nat} (f : Ptr cap → Run (Option Word)) (s : ArrayState020E4.State)
    (pc body guard : Ptr cap) (remaining u v : Nat) (hf : ∀ p,Bounded (f p) u v) :
    Bounded (loopAction f s pc body guard remaining) (19+u) (19+v) := by
  unfold loopAction
  split
  · constructor <;> dsimp [overhead,charge] <;> omega
  · apply CostBounds020E4.weaken (overhead_bound 8 (u+1+10) (v+1+10) _ ?_) (by omega) (by omega)
    apply optBind_bound _ _ u v 10 10 (hf guard)
    intro w
    split
    · exact ⟨by change 4≤10;omega,by change 4≤10;omega⟩
    · exact ⟨le_rfl,le_rfl⟩

theorem dispatch_value {cap : Nat} (f : Ptr cap → Run (Option Word)) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (pc : Ptr cap) (n : Node cap) (t : Token) :
    (dispatch f i s pc n t).value=ArrayAction020E4.dispatch (fun p => (f p).value) i s pc n t := by
  cases t <;> simp only [dispatch,overhead_value,ArrayAction020E4.dispatch,CostRun020E4.map,
    CostAtom020E4.value,loop_value,CostRun020E4.bind,charge]

theorem dispatch_bound {cap : Nat} (f : Ptr cap → Run (Option Word)) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (pc : Ptr cap) (n : Node cap) (t : Token)
    (u v : Nat) (hf : ∀ p,Bounded (f p) u v) :
    Bounded (dispatch f i s pc n t) (50+2*u+CostAtom020E4.writeBound) (50+2*v+CostAtom020E4.writeBound) := by
  have ha : ∀ t,Bounded (overhead 16 (overhead 2 (CostRun020E4.map (Option.map (fun q => (([] : List (Frame cap)),q)))
      (CostAtom020E4.withEval f i s n t)))) (50+2*u+CostAtom020E4.writeBound) (50+2*v+CostAtom020E4.writeBound) := by
    intro t
    have h := CostBounds020E4.map_bound (Option.map (fun q => (([] : List (Frame cap)),q))) _ _ _
      (CostAtom020E4.bound f i s n t u v hf)
    exact CostBounds020E4.weaken (overhead_bound 16 _ _ _ (overhead_bound 2 _ _ _ h)) (by omega) (by omega)
  cases t
  case seq => constructor <;> dsimp [dispatch,overhead,charge] <;> omega
  case branch =>
    rcases hf n.third with ⟨ht,hm⟩
    constructor <;> dsimp [dispatch,overhead,CostRun020E4.bind,charge] <;> omega
  case loop k =>
    have h := overhead_bound 16 _ _ _ (loop_bound f s pc n.first n.second k u v hf)
    exact CostBounds020E4.weaken h (by omega) (by omega)
  all_goals exact ha _

end FT1536.S05.CostControl020E4
