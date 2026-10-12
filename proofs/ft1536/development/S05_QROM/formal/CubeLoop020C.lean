import CubeStep020C
import CountedLoop020C

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CubeLoop020C
open WordRAM020 PairProgram020 ReadSemantics020A CdfPrefix020A
open VectorPrefix020C NormResponse020C CubeStep020C CountedLoop020C
attribute [local irreducible] exec loopState

def Good (i : Input) (k : Nat) (s : State) : Prop :=
  s.reg 1=nw k ∧ Prefix (CubeRead020C.vals i) k s
def cubeN (count : Nat) : Code := seqs [set 1 (lit 0),.loop count (lit 1) body]

theorem step (i : Input) (k : Nat) (s : State) (hk : k<1536) (good : Good i k s) :
    Good i (k+1) (exec i body s) ∧ Preserves s (exec i body s) := by
  have post := body_correct i s ⟨k,hk⟩ good.1
  exact ⟨⟨post.2.2.2.1,prefix_step _ ⟨k,hk⟩ _ _ good.2 post.1 post.2.1 post.2.2.1⟩,
    post.2.2.2.2⟩

theorem loop_correct (i : Input) (count k : Nat) (s : State) (budget : k+count≤1536)
    (good : Good i k s) :
    let t := loopState (exec i body) (lit 1) count s
    Good i (k+count) t ∧ Preserves s t :=
  counted (exec i body) (lit 1) (Good i) Preserves 1536 preserves_refl
    (fun a b => preserves_trans a b)
    (fun j q hj hq => ⟨VectorLoopCore020C.guard_true q,step i j q hj hq⟩)
    count k s budget good

theorem reset_good (i : Input) (s : State) : Good i 0 (put s 1 (word 0)) :=
  ⟨put_same _ _ _,prefix_zero _ _⟩

theorem shape (i : Input) (count : Nat) (s : State) :
    exec i (cubeN count) s=loopState (exec i body) (lit 1) count (put s 1 (word 0)) := by
  simp only [cubeN,exec_seqs_cons,exec_seqs_nil,exec_set,exec_loop,lit,eval_lit]

theorem cubeN_correct (i : Input) (count : Nat) (s : State) (hc : count≤1536) :
    Good i count (exec i (cubeN count) s) ∧ Preserves s (exec i (cubeN count) s) := by
  have post := loop_correct i count 0 (put s 1 (word 0)) (by omega) (reset_good i s)
  change Good i (0+count) (loopState (exec i body) (lit 1) count (put s 1 (word 0))) ∧
    Preserves (put s 1 (word 0)) (loopState (exec i body) (lit 1) count (put s 1 (word 0))) at post
  rw [Nat.zero_add] at post
  rw [shape]
  exact ⟨post.1,preserves_trans ⟨rfl,rfl,fun _ _ => rfl⟩ post.2⟩

theorem original_code : PairProgram020.cube=cubeN 1536 := rfl

/-- The original fresh-cube code, on every input and starting state. -/
theorem cube_correct (i : Input) (s : State) :
    Good i 1536 (exec i PairProgram020.cube s) ∧ Preserves s (exec i PairProgram020.cube s) := by
  rw [original_code]
  exact cubeN_correct i 1536 s (by decide)

end FT1536.S05.CubeLoop020C
