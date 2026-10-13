import NodeFrames020E2
import NodeAtom020E2

namespace FT1536.S05.NodeAction020E2
open WordRAM020 SyntaxTape020E ArenaTypes020E1 NodeFrames020E2 NodeRead020E2

abbrev Action (cap : Nat) := List (Frame cap) × State

def loopAction {cap : Nat} (a : Arena cap) (s : State) (pc body guard : Ptr cap) (remaining : Nat) : Option (Action cap) :=
  if remaining=0 then some ([],s) else
    (NodeExpr020E2.evaluate a.used.val a s guard).bind (fun v =>
      if v=0 then some ([],s) else
        (count (remaining-1)).map (fun k => ([.run body,.again pc k],s)))

def dispatch {cap : Nat} (a : Arena cap) (i : Input) (s : State) (pc : Ptr cap) (n : Node cap) : Token → Option (Action cap)
  | .seq => some ([.run n.second,.run n.first],s)
  | .branch => (NodeExpr020E2.evaluate a.used.val a s n.third).map (fun v =>
      ([.run (if v=0 then n.first else n.second)],s))
  | .loop k => loopAction a s pc n.first n.second k
  | t => (NodeAtom020E2.withEval (NodeExpr020E2.evaluate a.used.val a s) i s n t).map (fun q => ([],q))

def start {cap : Nat} (a : Arena cap) (i : Input) (s : State) (pc : Ptr cap) : Option (Action cap) :=
  (inspect a pc).bind (fun (n,t) => dispatch a i s pc n t)

def resume {cap : Nat} (a : Arena cap) (s : State) (pc : Ptr cap) (remaining : Count) : Option (Action cap) :=
  (inspect a pc).bind (fun (n,t) => match t with
    | .loop limit => if remaining.val≤limit then loopAction a s pc n.first n.second remaining.val else none
    | _ => none)

def action {cap : Nat} (a : Arena cap) (i : Input) (s : State) : Frame cap → Option (Action cap)
  | .run pc => start a i s pc
  | .again pc n => resume a s pc n

end FT1536.S05.NodeAction020E2
