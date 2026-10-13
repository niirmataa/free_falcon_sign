import ArrayState020E4
import NodeAtom020E2

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ArrayAtom020E4
open WordRAM020 SyntaxTape020E ArenaTypes020E1

def withEval {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input) (s : ArrayState020E4.State) (n : Node cap) : Token → Option ArrayState020E4.State
  | .setter r => (f n.first).bind (fun v => some (ArrayState020E4.put s r v))
  | .rom r => (f n.first).bind (fun v => some (match address romSize v with
      | none => ArrayState020E4.fail s | some k => ArrayState020E4.put s r (ArrayBank020E4.read i.rom k)))
  | .ram r => (f n.first).bind (fun v => some (match address ramSize v with
      | none => ArrayState020E4.fail s | some k => ArrayState020E4.put s r (ArrayBank020E4.read s.ram k)))
  | .bit r => (f n.first).bind (fun v => some (match address tapeSize v with
      | none => ArrayState020E4.fail s | some k => ArrayState020E4.put s r (if ArrayBank020E4.read i.tape k then 1 else 0)))
  | .store => (f n.second).bind (fun v => match address ramSize v with
      | none => some (ArrayState020E4.fail s)
      | some k => (f n.first).bind (fun w => some (ArrayState020E4.store s k w)))
  | .emit => (f n.second).bind (fun v => match address outputSize v with
      | none => some (ArrayState020E4.fail s)
      | some k => (f n.first).bind (fun w => some (ArrayState020E4.emit s k (w != 0))))
  | _ => none

theorem correct {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (n : Node cap) (t : Token) :
    (withEval f i s n t).map ArrayState020E4.model=
      NodeAtom020E2.withEval f (ArrayState020E4.input i) (ArrayState020E4.model s) n t := by
  cases t <;> simp only [withEval,NodeAtom020E2.withEval]
  all_goals cases h1 : f n.first <;> cases h2 : f n.second <;>
    simp only [Option.bind_none,Option.bind_some,Option.map_none,Option.map_some]
  all_goals first
    | rfl
    | exact congrArg some (ArrayState020E4.put_eq _ _ _)
    | (split <;> simp_all [ArrayState020E4.model,ArrayState020E4.input,
        ArrayState020E4.put,ArrayState020E4.store,ArrayState020E4.emit,ArrayState020E4.fail,
        ArrayBank020E4.read_write,WordRAM020.put,WordRAM020.fail])

  all_goals rfl

end FT1536.S05.ArrayAtom020E4
