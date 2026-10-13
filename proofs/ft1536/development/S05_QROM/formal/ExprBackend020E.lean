import ExprStack020E
import MemoryFrames020

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ExprBackend020E
open WordRAM020 ExprStack020E

/-- Total interface; the compiled evaluator is proved to return a singleton,
    so the fallback is unreachable for every expression and state. -/
def value (s : State) (e : Expr) : Word :=
  match execute s (compile e) [] with
  | some (w::_) => w
  | _ => 0

theorem value_eq (s : State) (e : Expr) : value s e=eval s e := by
  unfold value
  rw [correct]

def atom (i : Input) (a : Atom) (s : State) : State :=
  match a with
  | .set r e => put s r (value s e)
  | .loadROM r a => match address romSize (value s a) with
    | none => fail s | some k => put s r (i.rom k)
  | .loadRAM r a => match address ramSize (value s a) with
    | none => fail s | some k => put s r (s.ram k)
  | .loadBit r a => match address tapeSize (value s a) with
    | none => fail s | some k => put s r (if i.tape k then 1 else 0)
  | .store a v => match address ramSize (value s a) with
    | none => fail s | some k => {s with ram := Function.update s.ram k (value s v)}
  | .emit a v => match address outputSize (value s a) with
    | none => fail s | some k => {s with out := Function.update s.out k (value s v != 0)}

theorem atom_eq (i : Input) (a : Atom) (s : State) : atom i a s=atomRun i a s := by
  cases a <;> simp only [atom,value_eq,MemoryFrames020.rom_step,MemoryFrames020.ram_step,
    MemoryFrames020.bit_step,MemoryFrames020.store_step,MemoryFrames020.emit_step]
  all_goals rfl

end FT1536.S05.ExprBackend020E
