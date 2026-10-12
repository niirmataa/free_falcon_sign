import CountedLoop020C
import VectorPrefix020C

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.VectorLoopCore020C
open WordRAM020 PairProgram020 ReadSemantics020A
open VectorPrefix020C CountedLoop020C
attribute [local irreducible] exec loopState

def reset (s : State) : State := put (put s 1 (word 0)) 16 (word 0)
def vectorN (count : Nat) : Code := seqs [set 1 (lit 0),set 16 (lit 0),.loop count (lit 1) PairProgram020.pair]
def vectorCode : Code := vectorN 1536

theorem reset_good (v : Values) (outer : Word) (s : State) (h0 : s.reg 0=outer) :
    Good v outer 0 (reset s) := by
  refine ⟨?_,?_,?_,prefix_zero v (reset s)⟩
  · unfold reset; rw [put_other _ 16 0 _ (by decide),put_other _ 1 0 _ (by decide),h0]
  · unfold reset; rw [put_other _ 16 1 _ (by decide),put_same]; rfl
  · rw [total_zero]; exact put_same _ _ _

theorem reset_stable (s : State) : Stable s (reset s) := by
  refine ⟨rfl,rfl,?_,fun _ _ => rfl⟩
  intro rr hr _
  have h1 : rr≠1 := by intro he;subst rr;norm_num at hr
  have h16 : rr≠16 := by intro he;subst rr;norm_num at hr
  unfold reset
  rw [put_other _ 16 rr _ h16,put_other _ 1 rr _ h1]

theorem guard_true (s : State) : eval s (lit 1)≠0 := by
  change word 1≠0
  decide

theorem loop_correct (i : Input) (v : Values) (outer : Word)
    (step : ∀ k q, k<1536 → Good v outer k q →
      Good v outer (k+1) (exec i PairProgram020.pair q) ∧ Stable q (exec i PairProgram020.pair q))
    (count k : Nat) (s : State) (budget : k+count≤1536) (good : Good v outer k s) :
    let t := loopState (exec i PairProgram020.pair) (lit 1) count s
    Good v outer (k+count) t ∧ Stable s t :=
  counted (exec i PairProgram020.pair) (lit 1) (Good v outer) Stable 1536
    stable_refl (fun a b => stable_trans a b)
    (fun j q hj hq => ⟨guard_true q,step j q hj hq⟩) count k s budget good

theorem vector_shape (i : Input) (s : State) (count : Nat) :
    exec i (vectorN count) s=loopState (exec i PairProgram020.pair) (lit 1) count (reset s) := by
  simp only [vectorN,exec_seqs_cons,exec_seqs_nil,exec_set,exec_loop,lit,eval_lit]
  rfl

/-- Keep count symbolic while composing reset with loop induction. -/
theorem vectorN_from_steps (i : Input) (v : Values) (outer : Word) (s : State)
    (count : Nat) (hc : count≤1536) (h0 : s.reg 0=outer)
    (step : ∀ k q, k<1536 → Good v outer k q →
      Good v outer (k+1) (exec i PairProgram020.pair q) ∧ Stable q (exec i PairProgram020.pair q)) :
    Good v outer count (exec i (vectorN count) s) ∧ Stable s (exec i (vectorN count) s) := by
  have post := loop_correct i v outer step count 0 (reset s) (by omega) (reset_good v outer s h0)
  change Good v outer (0+count) (loopState (exec i PairProgram020.pair) (lit 1) count (reset s)) ∧
    Stable (reset s) (loopState (exec i PairProgram020.pair) (lit 1) count (reset s)) at post
  rw [Nat.zero_add] at post
  rw [vector_shape]
  exact ⟨post.1,stable_trans (reset_stable s) post.2⟩

/-- The original vector code is the1536 instance, with no expanded loop term. -/
theorem vector_from_steps (i : Input) (v : Values) (outer : Word) (s : State)
    (h0 : s.reg 0=outer)
    (step : ∀ k q, k<1536 → Good v outer k q →
      Good v outer (k+1) (exec i PairProgram020.pair q) ∧ Stable q (exec i PairProgram020.pair q)) :
    Good v outer 1536 (exec i vectorCode s) ∧ Stable s (exec i vectorCode s) :=
  vectorN_from_steps i v outer s 1536 (by decide) h0 step

end FT1536.S05.VectorLoopCore020C
