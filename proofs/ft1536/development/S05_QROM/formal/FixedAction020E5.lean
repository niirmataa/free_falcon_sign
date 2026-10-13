import MemoryEdit020E5
import ArrayAction020E4

set_option exponentiation.threshold 512
namespace FT1536.S05.FixedAction020E5
open WordRAM020 SyntaxTape020E ArenaTypes020E1 NodeFrames020E2

/-- Fixed pending registers. Lists occur only in the comparison map. -/
inductive Pending (cap : Nat) where
  | none
  | one (f : Frame cap)
  | two (f g : Frame cap)

def pendingList {cap : Nat} : Pending cap → List (Frame cap)
  | .none => [] | .one f => [f] | .two f g => [f,g]

abbrev Result (cap : Nat) := Pending cap × MemoryEdit020E5.Edit

def observe {cap : Nat} (s : ArrayState020E4.State) (r : Result cap) : ArrayAction020E4.Action cap :=
  (pendingList r.1,MemoryEdit020E5.apply s r.2)

def loopAction {cap : Nat} (f : Ptr cap → Option Word) (pc body guard : Ptr cap)
    (remaining : Nat) : Option (Result cap) :=
  if remaining=0 then some (.none,.keep) else (f guard).bind (fun v =>
    if v=0 then some (.none,.keep) else
      (count (remaining-1)).map (fun k => (.two (.run body) (.again pc k),.keep)))

def dispatch {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (pc : Ptr cap) (n : Node cap) : Token → Option (Result cap)
  | .seq => some (.two (.run n.second) (.run n.first),.keep)
  | .branch => (f n.third).map (fun v => (.one (.run (if v=0 then n.first else n.second)),.keep))
  | .loop k => loopAction f pc n.first n.second k
  | t => (MemoryEdit020E5.atom f i s n t).map (fun e => (.none,e))

def action {cap : Nat} (f : Ptr cap → Option Word) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (s : ArrayState020E4.State) : Frame cap → Option (Result cap)
  | .run pc => (NodeRead020E2.inspect (ArrayArena020E4.model a) pc).bind (fun nt => dispatch f i s pc nt.1 nt.2)
  | .again pc n => (NodeRead020E2.inspect (ArrayArena020E4.model a) pc).bind (fun nt => match nt.2 with
      | .loop limit => if n.val≤limit then loopAction f pc nt.1.first nt.1.second n.val else none
      | _ => none)

theorem loop_refines {cap : Nat} (f : Ptr cap → Option Word) (s : ArrayState020E4.State)
    (pc body guard : Ptr cap) (remaining : Nat) :
    (loopAction f pc body guard remaining).map (observe s)=ArrayAction020E4.loopAction f s pc body guard remaining := by
  unfold loopAction ArrayAction020E4.loopAction
  split
  · rfl
  · cases hf : f guard with
    | none => rfl
    | some w =>
      simp only [Option.bind_some]
      split
      · rfl
      · cases count (remaining-1) <;> rfl

theorem atom_observe {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (n : Node cap) (t : Token) :
    ((MemoryEdit020E5.atom f i s n t).map (fun e => ((Pending.none : Pending cap),e))).map (observe s)=
      (ArrayAtom020E4.withEval f i s n t).map (fun q => ([],q)) := by
  rw [←MemoryEdit020E5.atom_refines,Option.map_map,Option.map_map]
  rfl

theorem dispatch_refines {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (pc : Ptr cap) (n : Node cap) (t : Token) :
    (dispatch f i s pc n t).map (observe s)=ArrayAction020E4.dispatch f i s pc n t := by
  cases t
  case seq => rfl
  case branch =>
    simp only [dispatch,ArrayAction020E4.dispatch]
    cases f n.third <;> rfl
  case loop k => exact loop_refines f s pc n.first n.second k
  case literal w => rfl
  case register r => rfl
  case binary o => rfl
  all_goals exact atom_observe f i s n _

theorem action_refines {cap : Nat} (f : Ptr cap → Option Word) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (s : ArrayState020E4.State) (fr : Frame cap) :
    (action f a i s fr).map (observe s)=ArrayAction020E4.withEvaluator f a i s fr := by
  cases fr with
  | run pc =>
    simp only [action,ArrayAction020E4.withEvaluator,ArrayAction020E4.start]
    cases NodeRead020E2.inspect (ArrayArena020E4.model a) pc with
    | none => rfl
    | some nt => exact dispatch_refines f i s pc nt.1 nt.2
  | again pc n =>
    simp only [action,ArrayAction020E4.withEvaluator,ArrayAction020E4.resume]
    cases NodeRead020E2.inspect (ArrayArena020E4.model a) pc with
    | none => rfl
    | some nt =>
      rcases nt with ⟨node,t⟩
      simp only [Option.bind_some]
      cases t <;> try rfl
      dsimp only
      split
      · exact loop_refines f s pc node.first node.second n.val
      · rfl

theorem pending_bound {cap : Nat} (p : Pending cap) : (pendingList p).length≤2 := by
  cases p <;> simp [pendingList]

end FT1536.S05.FixedAction020E5
