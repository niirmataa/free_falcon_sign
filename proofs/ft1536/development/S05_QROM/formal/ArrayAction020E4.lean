import ArrayAtom020E4
import ArrayValues020E4
import BankAction020E3

namespace FT1536.S05.ArrayAction020E4
open WordRAM020 SyntaxTape020E ArenaTypes020E1 NodeFrames020E2
abbrev Action (cap : Nat) := List (Frame cap) × ArrayState020E4.State

def model {cap : Nat} (q : Action cap) : BankAction020E3.Action cap := (q.1,ArrayState020E4.model q.2)

def loopAction {cap : Nat} (f : Ptr cap → Option Word) (s : ArrayState020E4.State)
    (pc body guard : Ptr cap) (remaining : Nat) : Option (Action cap) :=
  if remaining=0 then some ([],s) else
    (f guard).bind (fun v => if v=0 then some ([],s) else
      (count (remaining-1)).map (fun k => ([.run body,.again pc k],s)))

def dispatch {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (pc : Ptr cap) (n : Node cap) : Token → Option (Action cap)
  | .seq => some ([.run n.second,.run n.first],s)
  | .branch => (f n.third).map (fun v => ([.run (if v=0 then n.first else n.second)],s))
  | .loop k => loopAction f s pc n.first n.second k
  | t => (ArrayAtom020E4.withEval f i s n t).map (fun q => ([],q))

def start {cap : Nat} (f : Ptr cap → Option Word) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (s : ArrayState020E4.State) (pc : Ptr cap) : Option (Action cap) :=
  (NodeRead020E2.inspect (ArrayArena020E4.model a) pc).bind (fun (n,t) => dispatch f i s pc n t)

def resume {cap : Nat} (f : Ptr cap → Option Word) (a : ArrayArena020E4.Arena cap)
    (s : ArrayState020E4.State) (pc : Ptr cap) (remaining : Count) : Option (Action cap) :=
  (NodeRead020E2.inspect (ArrayArena020E4.model a) pc).bind (fun (n,t) => match t with
    | .loop limit => if remaining.val≤limit then loopAction f s pc n.first n.second remaining.val else none
    | _ => none)

def withEvaluator {cap : Nat} (f : Ptr cap → Option Word) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (s : ArrayState020E4.State) : Frame cap → Option (Action cap)
  | .run pc => start f a i s pc
  | .again pc n => resume f a s pc n

def action {cap : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (f : Frame cap) : Option (Action cap) :=
  withEvaluator (ArrayValues020E4.lookup a (ArrayValues020E4.build a s)) a i s f

theorem loop_eq {cap : Nat} (f : Ptr cap → Option Word) (s : ArrayState020E4.State)
    (pc body guard : Ptr cap) (remaining : Nat) :
    (loopAction f s pc body guard remaining).map model=
      BankAction020E3.loopAction f (ArrayState020E4.model s) pc body guard remaining := by
  unfold loopAction BankAction020E3.loopAction
  split
  · rfl
  · cases hg : f guard with
    | none => rfl
    | some w =>
      simp only [Option.bind_some]
      split
      · rfl
      · cases hc : count (remaining-1) <;> rfl

theorem dispatch_eq {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (pc : Ptr cap) (n : Node cap) (t : Token) :
    (dispatch f i s pc n t).map model=
      BankAction020E3.dispatch f (ArrayState020E4.input i) (ArrayState020E4.model s) pc n t := by
  cases t
  case seq => rfl
  case branch =>
    simp only [dispatch,BankAction020E3.dispatch]
    cases h : f n.third <;> rfl
  case loop k => exact loop_eq f s pc n.first n.second k
  all_goals first | rfl | skip
  all_goals
    change ((ArrayAtom020E4.withEval f i s n _).map (fun q => ([],q))).map model=
      (NodeAtom020E2.withEval f (ArrayState020E4.input i) (ArrayState020E4.model s) n _).map (fun q => ([],q))
    rw [←ArrayAtom020E4.correct f i s n _,Option.map_map,Option.map_map]
    rfl

theorem withEvaluator_eq {cap : Nat} (f : Ptr cap → Option Word) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (s : ArrayState020E4.State) (fr : Frame cap) :
    (withEvaluator f a i s fr).map model=
      BankAction020E3.withEvaluator f (ArrayArena020E4.model a) (ArrayState020E4.input i) (ArrayState020E4.model s) fr := by
  cases fr with
  | run pc =>
    simp only [withEvaluator,start,BankAction020E3.withEvaluator,BankAction020E3.start]
    cases h : NodeRead020E2.inspect (ArrayArena020E4.model a) pc with
    | none => rfl
    | some q => exact dispatch_eq f i s pc q.1 q.2
  | again pc n =>
    simp only [withEvaluator,resume,BankAction020E3.withEvaluator,BankAction020E3.resume]
    cases h : NodeRead020E2.inspect (ArrayArena020E4.model a) pc with
    | none => rfl
    | some q =>
      rcases q with ⟨node,t⟩
      simp only [Option.bind_some]
      cases t <;> try rfl
      dsimp only
      conv_lhs => simp only [apply_ite,loop_eq,Option.map_none]

theorem action_eq {cap : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (f : Frame cap) :
    (action a i s f).map model=BankAction020E3.action (ArrayArena020E4.model a)
      (ArrayState020E4.input i) (ArrayState020E4.model s) f := by
  rw [action,withEvaluator_eq]
  have he : ArrayValues020E4.lookup a (ArrayValues020E4.build a s)=
      ValueBank020E3.lookup (ArrayArena020E4.model a)
        (ValueBank020E3.build (ArrayArena020E4.model a) (ArrayState020E4.model s)) := by
    funext p
    rw [ArrayValues020E4.lookup_eq,ArrayValues020E4.build_eq]
  rw [he];rfl

end FT1536.S05.ArrayAction020E4
