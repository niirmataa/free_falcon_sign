import PairProgram020
import WordArithmetic020
import MemoryFrames020

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ReadSemantics020A
open WordRAM020 PairProgram020

def exec (i : Input) (c : Code) (s : State) : State := (run i c s).1

@[simp] theorem eval_lit (s : State) (w : Word) : eval s (.lit w)=w := rfl
@[simp] theorem eval_reg (s : State) (r : Reg) : eval s (.reg r)=s.reg r := rfl
@[simp] theorem eval_bin (s : State) (o : Op) (a b : Expr) :
    eval s (.bin o a b)=op o (eval s a) (eval s b) := rfl

@[simp] theorem exec_set (i : Input) (s : State) (r : Reg) (e : Expr) :
    exec i (set r e) s=put s r (eval s e) := rfl
@[simp] theorem exec_seq (i : Input) (a b : Code) (s : State) :
    exec i (.seq a b) s=exec i b (exec i a s) := rfl

theorem put_self (s : State) (r : Reg) : put s r (s.reg r)=s := by
  simp [put,Function.update_eq_self]

@[simp] theorem exec_skip (i : Input) (s : State) : exec i skip s=s := by
  change put s 31 (s.reg 31)=s
  exact put_self s 31
@[simp] theorem exec_seqs_nil (i : Input) (s : State) : exec i (seqs []) s=s := exec_skip i s
@[simp] theorem exec_seqs_cons (i : Input) (s : State) (a : Code) (as : List Code) :
    exec i (seqs (a::as)) s=exec i (seqs as) (exec i a s) := rfl

@[simp] theorem exec_bit (i : Input) (s : State) (r : Reg) (a : Expr) :
    exec i (.atom (.loadBit r a)) s=(match address tapeSize (eval s a) with
    | none => fail s | some k => put s r (if i.tape k then 1 else 0)) := rfl

/-- The state component of the original costed loop, not a new machine. -/
def loopState (f : State → State) (g : Expr) : Nat → State → State
  | 0,s => s
  | n+1,s => if eval s g=0 then s else loopState f g n (f s)

theorem iterate_erasure (f : State → State × Nat) (g : Expr) (n : Nat) (s : State) :
    (iterate f g n s).1=loopState (fun s => (f s).1) g n s := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => simp only [iterate,loopState]; split <;> simp only [ih]

@[simp] theorem exec_loop (i : Input) (body : Code) (g : Expr) (n : Nat) (s : State) :
    exec i (.loop n g body) s=loopState (exec i body) g n s :=
  iterate_erasure (run i body) g n s

/-- Syntactic read sets, so base-expression stability is discharged from syntax. -/
def reads : Expr → Finset Reg
  | .lit _ => ∅
  | .reg r => {r}
  | .bin _ a b => reads a ∪ reads b

theorem eval_of_agree (s t : State) (e : Expr)
    (h : ∀ r ∈ reads e, s.reg r=t.reg r) : eval s e=eval t e := by
  induction e with
  | lit w => rfl
  | reg r => exact h r (by simp [reads])
  | bin o a b ha hb =>
    rw [eval_bin,eval_bin,ha (fun r hr => h r (by simp [reads,hr])),
      hb (fun r hr => h r (by simp [reads,hr]))]

theorem eval_put (s : State) (e : Expr) (r : Reg) (w : Word) (h : r ∉ reads e) :
    eval (put s r w) e=eval s e := by
  apply eval_of_agree
  intro k hk
  exact put_other s r k w (by intro he; subst k; exact h hk)

def Frame (s t : State) : Prop := s.ram=t.ram ∧ s.out=t.out ∧ s.fault=t.fault

theorem frame_refl (s : State) : Frame s s := ⟨rfl,rfl,rfl⟩
theorem frame_trans {s t u : State} (h : Frame s t) (h' : Frame t u) : Frame s u :=
  ⟨h.1.trans h'.1,h.2.1.trans h'.2.1,h.2.2.trans h'.2.2⟩
theorem frame_put (s : State) (r : Reg) (w : Word) : Frame s (put s r w) := ⟨rfl,rfl,rfl⟩

end FT1536.S05.ReadSemantics020A
