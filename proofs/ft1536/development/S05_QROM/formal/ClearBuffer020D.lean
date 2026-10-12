import BufferField020D
import ScalarExpr020D
import CountedLoop020C
import VectorLoopCore020C

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ClearBuffer020D
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020
open MachineAtoms020D Residue020D BufferField020D BufferUpdate020D ScalarExpr020D
attribute [local irreducible] exec loopState

def body : Code := seqs [store (add (lit 3072) (r 21)) (lit 0),inc 21]
def code (count : Nat) : Code := seqs [set 21 (lit 0),.loop count (lit 1) body]
def ZeroPrefix (k : Nat) (s : State) : Prop := ∀ r : Fin 1536, r.val<k → s.ram (slot r)=fw 0
def Good (k : Nat) (s : State) : Prop := s.reg 21=word (k:Int) ∧ ZeroPrefix k s

theorem body_run (i : Input) (s : State) (p : Fin 1536) (h21 : s.reg 21=word (p.val:Int)) :
    exec i body s=put (ramPut s (slot p) (word 0)) 21 (word ((p.val+1:Nat):Int)) := by
  have addr : eval s (add (lit 3072) (r 21))=word ((slot p).val:Int) := by
    change op .add (word 3072) (s.reg 21)=_
    rw [h21,add_word (3072:Int) (p.val:Int) (small_nat 3072 (by decide))
      (small_nat p.val (by have := p.isLt;omega))]
    rfl
  have st : exec i (store (add (lit 3072) (r 21)) (lit 0)) s=ramPut s (slot p) (word 0) := by
    rw [store_at i s _ _ (slot p) addr]
    rfl
  have incE : eval (ramPut s (slot p) (word 0)) (add (r 21) (lit 1))=word ((p.val+1:Nat):Int) :=
    inc_eval _ 21 p.val (by have := p.isLt;omega) h21
  simp only [body,exec_seqs_cons,exec_seqs_nil,st,inc,exec_set,incE]

theorem step (i : Input) (k : Nat) (s : State) (hk : k<1536) (hs : Good k s) :
    Good (k+1) (exec i body s) ∧ BufferField020D.Frame s (exec i body s) := by
  rw [body_run i s ⟨k,hk⟩ hs.1]
  refine ⟨⟨put_same _ _ _,?_⟩,rfl,rfl,?_⟩
  · intro r hr
    by_cases he : r=(⟨k,hk⟩:Fin 1536)
    · subst r
      exact ramPut_same _ _ _
    · have hv : r.val≠k := fun h => he (Fin.ext h)
      exact (ramPut_other _ _ _ _ (fun h => he (slot_injective h))).trans (hs.2 r (by omega))
  · intro j hj
    apply ramPut_other
    intro h
    have hv := congrArg Fin.val h
    change j.val=3072+k at hv
    omega

theorem loop_correct (i : Input) (count k : Nat) (s : State) (hb : k+count≤1536) (hs : Good k s) :
    let t := loopState (exec i body) (lit 1) count s
    Good (k+count) t ∧ BufferField020D.Frame s t :=
  CountedLoop020C.counted (exec i body) (lit 1) Good BufferField020D.Frame 1536
    BufferField020D.frame_refl (fun a b => BufferField020D.frame_trans a b)
    (fun j q hj hq => ⟨VectorLoopCore020C.guard_true q,step i j q hj hq⟩) count k s hb hs

theorem code_shape (i : Input) (count : Nat) (s : State) :
    exec i (code count) s=loopState (exec i body) (lit 1) count (put s 21 (word 0)) := by
  simp only [code,exec_seqs_cons,exec_seqs_nil,exec_set,exec_loop]
  rfl

theorem code_correct (i : Input) (count : Nat) (s : State) (hc : count≤1536) :
    Good count (exec i (code count) s) ∧ BufferField020D.Frame s (exec i (code count) s) := by
  have g0 : Good 0 (put s 21 (word 0)) := ⟨put_same _ _ _,fun r hr => by omega⟩
  have post := loop_correct i count 0 (put s 21 (word 0)) (by omega) g0
  change Good (0+count) (loopState (exec i body) (lit 1) count (put s 21 (word 0))) ∧
    BufferField020D.Frame (put s 21 (word 0)) (loopState (exec i body) (lit 1) count (put s 21 (word 0))) at post
  rw [Nat.zero_add] at post
  rw [code_shape]
  exact ⟨post.1,BufferField020D.frame_trans ⟨rfl,rfl,fun _ _ => rfl⟩ post.2⟩

theorem clear_correct (i : Input) (s : State) :
    Holds (exec i (code 1536) s) (fun _ => 0) ∧ BufferField020D.Frame s (exec i (code 1536) s) :=
  ⟨fun r => (code_correct i 1536 s (by decide)).1.2 r r.isLt,(code_correct i 1536 s (by decide)).2⟩

end FT1536.S05.ClearBuffer020D
