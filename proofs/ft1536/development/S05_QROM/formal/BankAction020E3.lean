import NodeAction020E2
import ValueRefinement020E3

namespace FT1536.S05.BankAction020E3
open WordRAM020 SyntaxTape020E ArenaTypes020E1 NodeFrames020E2 NodeRead020E2

abbrev Action (cap : Nat) := List (Frame cap) × State

def loopAction {cap : Nat} (f : Ptr cap → Option Word) (s : State) (pc body guard : Ptr cap) (remaining : Nat) : Option (Action cap) :=
  if remaining=0 then some ([],s) else
    (f guard).bind (fun v =>
      if v=0 then some ([],s) else
        (count (remaining-1)).map (fun k => ([.run body,.again pc k],s)))

def dispatch {cap : Nat} (f : Ptr cap → Option Word) (i : Input) (s : State) (pc : Ptr cap) (n : Node cap) : Token → Option (Action cap)
  | .seq => some ([.run n.second,.run n.first],s)
  | .branch => (f n.third).map (fun v =>
      ([.run (if v=0 then n.first else n.second)],s))
  | .loop k => loopAction f s pc n.first n.second k
  | t => (NodeAtom020E2.withEval f i s n t).map (fun q => ([],q))

def start {cap : Nat} (f : Ptr cap → Option Word) (a : Arena cap) (i : Input) (s : State) (pc : Ptr cap) : Option (Action cap) :=
  (inspect a pc).bind (fun (n,t) => dispatch f i s pc n t)

def resume {cap : Nat} (f : Ptr cap → Option Word) (a : Arena cap) (s : State) (pc : Ptr cap) (remaining : Count) : Option (Action cap) :=
  (inspect a pc).bind (fun (n,t) => match t with
    | .loop limit => if remaining.val≤limit then loopAction f s pc n.first n.second remaining.val else none
    | _ => none)

def withEvaluator {cap : Nat} (f : Ptr cap → Option Word) (a : Arena cap) (i : Input) (s : State) : Frame cap → Option (Action cap)
  | .run pc => start f a i s pc
  | .again pc n => resume f a s pc n

theorem original {cap : Nat} (a : Arena cap) (i : Input) (s : State) (f : Frame cap) :
    withEvaluator (NodeExpr020E2.evaluate a.used.val a s) a i s f=NodeAction020E2.action a i s f := by
  cases f <;> rfl

/-- Fresh values for this precise State; no cache is retained across a write. -/
def action {cap : Nat} (a : Arena cap) (i : Input) (s : State) (f : Frame cap) : Option (Action cap) :=
  withEvaluator (ValueBank020E3.lookup a (ValueBank020E3.build a s)) a i s f

theorem correct {cap : Nat} (a : Arena cap) (i : Input) (s : State) (mu : ArenaHeap020E1.Meaning)
    (hh : ArenaHeap020E1.HeapValid a mu) (f : Frame cap) : action a i s f=NodeAction020E2.action a i s f := by
  have hv := funext (ValueRefinement020E3.evaluator_eq a s mu hh)
  rw [action,hv,original]

end FT1536.S05.BankAction020E3
