import ArrayAtom020E4

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.MemoryEdit020E5
open WordRAM020 SyntaxTape020E ArenaTypes020E1

/-- At most one mutable core location changes. No array or saved State is
    carried by an edit; the target is a statically allocated bank. -/
inductive Edit where
  | keep
  | fault
  | reg (r : Reg) (value : Word)
  | ram (a : Fin ramSize) (value : Word)
  | out (a : Fin outputSize) (value : Bool)

def apply (s : ArrayState020E4.State) : Edit → ArrayState020E4.State
  | .keep => s
  | .fault => ArrayState020E4.fail s
  | .reg r w => ArrayState020E4.put s r w
  | .ram a w => ArrayState020E4.store s a w
  | .out a b => ArrayState020E4.emit s a b

def atom {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (n : Node cap) : Token → Option Edit
  | .setter r => (f n.first).map (.reg r)
  | .rom r => (f n.first).map (fun w => match address romSize w with
      | none => .fault | some a => .reg r (ArrayBank020E4.read i.rom a))
  | .ram r => (f n.first).map (fun w => match address ramSize w with
      | none => .fault | some a => .reg r (ArrayBank020E4.read s.ram a))
  | .bit r => (f n.first).map (fun w => match address tapeSize w with
      | none => .fault | some a => .reg r (if ArrayBank020E4.read i.tape a then 1 else 0))
  | .store => (f n.second).bind (fun w => match address ramSize w with
      | none => some .fault | some a => (f n.first).map (.ram a))
  | .emit => (f n.second).bind (fun w => match address outputSize w with
      | none => some .fault | some a => (f n.first).map (fun v => .out a (v != 0)))
  | _ => none

theorem atom_refines {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (n : Node cap) (t : Token) :
    (atom f i s n t).map (apply s)=ArrayAtom020E4.withEval f i s n t := by
  cases t
  case literal w => rfl
  case register r => rfl
  case binary o => rfl
  case seq => rfl
  case branch => rfl
  case loop k => rfl
  case setter r =>
    simp only [atom,ArrayAtom020E4.withEval]
    cases f n.first <;> rfl
  case rom r =>
    cases hf : f n.first with
    | none => simp only [atom,ArrayAtom020E4.withEval,hf,Option.map_none,Option.bind_none]
    | some w =>
      simp only [atom,ArrayAtom020E4.withEval,hf,Option.map_some,Option.bind_some]
      cases ha : address romSize w <;> rfl
  case ram r =>
    cases hf : f n.first with
    | none => simp only [atom,ArrayAtom020E4.withEval,hf,Option.map_none,Option.bind_none]
    | some w =>
      simp only [atom,ArrayAtom020E4.withEval,hf,Option.map_some,Option.bind_some]
      cases ha : address ramSize w <;> rfl
  case bit r =>
    cases hf : f n.first with
    | none => simp only [atom,ArrayAtom020E4.withEval,hf,Option.map_none,Option.bind_none]
    | some w =>
      simp only [atom,ArrayAtom020E4.withEval,hf,Option.map_some,Option.bind_some]
      cases ha : address tapeSize w <;> rfl
  case store =>
    cases hf : f n.second with
    | none => simp only [atom,ArrayAtom020E4.withEval,hf,Option.map_none,Option.bind_none]
    | some w =>
      simp only [atom,ArrayAtom020E4.withEval,hf,Option.bind_some]
      cases ha : address ramSize w with
      | none => rfl
      | some k => cases f n.first <;> rfl
  case emit =>
    cases hf : f n.second with
    | none => simp only [atom,ArrayAtom020E4.withEval,hf,Option.map_none,Option.bind_none]
    | some w =>
      simp only [atom,ArrayAtom020E4.withEval,hf,Option.bind_some]
      cases ha : address outputSize w with
      | none => rfl
      | some k => cases f n.first <;> rfl

/-- Three padded words cover every edit: tag, address and payload. -/
def words : Edit → Fin 3 → Word
  | .keep,_ => 0
  | .fault,k => if k.val=0 then 1 else 0
  | .reg r w,k => match k.val with | 0 => 2 | 1 => word r.val | _ => w
  | .ram a w,k => match k.val with | 0 => 3 | 1 => word a.val | _ => w
  | .out a b,k => match k.val with | 0 => 4 | 1 => word a.val | _ => if b then 1 else 0

theorem unchanged_input {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (n : Node cap) (t : Token) (e : Edit)
    (h : atom f i s n t=some e) :
    ArrayAtom020E4.withEval f i s n t=some (apply s e) := by
  rw [←atom_refines,h]
  rfl

end FT1536.S05.MemoryEdit020E5
