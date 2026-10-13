import NodeExpr020E2
import MemoryFrames020

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.NodeAtom020E2
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1 ArenaToken020E1 NodeRead020E2

def withEval {cap : Nat} (f : Ptr cap → Option Word) (i : Input) (s : State) (n : Node cap) : Token → Option State
  | .setter r => (f n.first).bind (fun v => some (put s r v))
  | .rom r => (f n.first).bind (fun v => some (match address romSize v with
      | none => fail s | some k => put s r (i.rom k)))
  | .ram r => (f n.first).bind (fun v => some (match address ramSize v with
      | none => fail s | some k => put s r (s.ram k)))
  | .bit r => (f n.first).bind (fun v => some (match address tapeSize v with
      | none => fail s | some k => put s r (if i.tape k then 1 else 0)))
  | .store => (f n.second).bind (fun v => match address ramSize v with
      | none => some (fail s)
      | some k => (f n.first).bind (fun w => some {s with ram := Function.update s.ram k w}))
  | .emit => (f n.second).bind (fun v => match address outputSize v with
      | none => some (fail s)
      | some k => (f n.first).bind (fun w => some {s with out := Function.update s.out k (w != 0)}))
  | _ => none

theorem from_shape {cap : Nat} (f : Ptr cap → Option Word) (i : Input) (s : State)
    (n : Node cap) (t : Token) (mu : Meaning) (a : Atom)
    (hs : assemble t ((children t n).map (fun p => mu p.val))=some (.code (.atom a)))
    (hf : ∀ p∈children t n,∀ e,mu p.val=.expr e → f p=some (eval s e)) :
    withEval f i s n t=some (atomRun i a s) := by
  have hk := assemble_kind t _ (.code (.atom a)) hs
  cases t
  case setter r =>
    change assemble (.setter r) [mu n.first.val]=some (.code (.atom a)) at hs
    cases he : mu n.first.val <;> simp [assemble,push,he] at hs
    case expr e =>
      subst a
      rw [withEval,hf n.first (by simp [children,arity,needs]) e he]
      rfl
  case rom r =>
    change assemble (.rom r) [mu n.first.val]=some (.code (.atom a)) at hs
    cases he : mu n.first.val <;> simp [assemble,push,he] at hs
    case expr e =>
      subst a
      rw [withEval,hf n.first (by simp [children,arity,needs]) e he]
      simp only [Option.bind_some,MemoryFrames020.rom_step]
      rfl
  case ram r =>
    change assemble (.ram r) [mu n.first.val]=some (.code (.atom a)) at hs
    cases he : mu n.first.val <;> simp [assemble,push,he] at hs
    case expr e =>
      subst a
      rw [withEval,hf n.first (by simp [children,arity,needs]) e he]
      simp only [Option.bind_some,MemoryFrames020.ram_step]
      rfl
  case bit r =>
    change assemble (.bit r) [mu n.first.val]=some (.code (.atom a)) at hs
    cases he : mu n.first.val <;> simp [assemble,push,he] at hs
    case expr e =>
      subst a
      rw [withEval,hf n.first (by simp [children,arity,needs]) e he]
      simp only [Option.bind_some,MemoryFrames020.bit_step]
      rfl
  case store =>
    change assemble .store [mu n.first.val,mu n.second.val]=some (.code (.atom a)) at hs
    cases hv : mu n.first.val <;> cases ha : mu n.second.val <;> simp [assemble,push,hv,ha] at hs
    case expr.expr v e =>
      subst a
      rw [withEval,hf n.second (by simp [children,arity,needs]) e ha]
      simp only [Option.bind_some,MemoryFrames020.store_step]
      cases haddr : address ramSize (eval s e)
      · rfl
      · rw [hf n.first (by simp [children,arity,needs]) v hv]
        rfl
  case emit =>
    change assemble .emit [mu n.first.val,mu n.second.val]=some (.code (.atom a)) at hs
    cases hv : mu n.first.val <;> cases ha : mu n.second.val <;> simp [assemble,push,hv,ha] at hs
    case expr.expr v e =>
      subst a
      rw [withEval,hf n.second (by simp [children,arity,needs]) e ha]
      simp only [Option.bind_some,MemoryFrames020.emit_step]
      cases haddr : address outputSize (eval s e)
      · rfl
      · rw [hf n.first (by simp [children,arity,needs]) v hv]
        rfl
  case seq =>
    change assemble .seq [mu n.first.val,mu n.second.val]=some (.code (.atom a)) at hs
    cases h1 : mu n.first.val <;> cases h2 : mu n.second.val <;> simp [assemble,push,h1,h2] at hs
  case branch =>
    change assemble .branch [mu n.first.val,mu n.second.val,mu n.third.val]=some (.code (.atom a)) at hs
    cases h1 : mu n.first.val <;> cases h2 : mu n.second.val <;> cases h3 : mu n.third.val <;>
      simp [assemble,push,h1,h2,h3] at hs
  case loop count =>
    change assemble (.loop count) [mu n.first.val,mu n.second.val]=some (.code (.atom a)) at hs
    cases h1 : mu n.first.val <;> cases h2 : mu n.second.val <;> simp [assemble,push,h1,h2] at hs
  all_goals cases hk

def execute {cap : Nat} (a : Arena cap) (i : Input) (s : State) (p : Ptr cap) : Option State :=
  (inspect a p).bind (fun (n,t) => withEval (NodeExpr020E2.evaluate a.used.val a s) i s n t)

theorem correct {cap : Nat} (a : Arena cap) (i : Input) (s : State) (mu : Meaning)
    (hh : HeapValid a mu) (p : Ptr cap) (bodyAtom : Atom)
    (hp : p.val<a.used.val) (hm : mu p.val=.code (.atom bodyAtom)) :
    execute a i s p=some (atomRun i bodyAtom s) := by
  obtain ⟨n,t,ht,hkids,hs⟩ := inspect_exists a mu hh p hp
  rw [hm] at hs
  rw [execute,ht]
  simp only [Option.bind_some]
  apply from_shape _ i s n t mu bodyAtom hs
  intro q hq e he
  have hv : q.val<a.used.val := (hkids q hq).trans hp
  exact NodeExpr020E2.correct a.used.val a mu s hh q e hv hv he

end FT1536.S05.NodeAtom020E2
