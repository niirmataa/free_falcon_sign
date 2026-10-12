import NormSource020C

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.NormCap020C
open WordRAM020 PairProgram020 ReadSemantics020A JointInterface019 CdfPrefix020A
open BoxImage020C NormResponse020C ActualNormTrial020C NormSource020C CapCore020B
open FT1536.Relation
attribute [local irreducible] exec loopState source StandaloneRuntime019.first StandaloneRuntime019.normTrial

theorem actual_step (h : Rq) (tape : Bits tapeSize) (n : Nat) (s : State)
    (hn : n<196) (h0 : s.reg 0=nw n) (empty : answer s=none) :
    let i := InputLayout020.encode h tape
    answer (exec i PairProgram020.normTrial s)=(source tape n).map image ∧
      (exec i PairProgram020.normTrial s).reg 0=nw (n+1) ∧ Preserves s (exec i PairProgram020.normTrial s) := by
  have step := norm_correct h tape ⟨n,hn⟩ s h0 ((FlagCore020C.observe_none 20 readVec s).mp empty)
  refine ⟨step.1.trans ?_,step.2⟩
  exact congrArg (Option.map image) (source_at tape ⟨n,hn⟩).symm

theorem loop_correct (h : Rq) (tape : Bits tapeSize) (count n : Nat) (s : State)
    (budget : n+count≤196) (h0 : s.reg 0=nw n) (empty : answer s=none) :
    let i := InputLayout020.encode h tape
    let t := loopState (exec i PairProgram020.normTrial) (FlagCore020C.guard 20) count s
    answer t=(firstFrom (source tape) count n).map image ∧ Preserves s t := by
  have result := first_success (exec (InputLayout020.encode h tape) PairProgram020.normTrial)
    (FlagCore020C.guard 20) answer (fun j => (source tape j).map image)
    (fun j q => q.reg 0=nw j) Preserves 196 preserves_refl
    (fun a b => preserves_trans a b) (FlagCore020C.guard_iff 20 readVec)
    (fun j q hj hq he => actual_step h tape j q hj hq he) count n s budget h0 empty
  rw [firstFrom_map] at result
  exact result

def reset (s : State) : State := put (put s 0 (word 0)) 20 (word 0)
def capped (count : Nat) : Code := seqs [set 0 (lit 0),set 20 (lit 0),
  .loop count (FlagCore020C.guard 20) PairProgram020.normTrial]

theorem reset_counter (s : State) : (reset s).reg 0=nw 0 := by
  unfold reset
  rw [put_other _ 20 0 _ (by decide),put_same]
  rfl

theorem reset_empty (s : State) : answer (reset s)=none := by
  apply (FlagCore020C.observe_none 20 readVec (reset s)).mpr
  exact put_same _ _ _

theorem reset_preserves (s : State) : Preserves s (reset s) := ⟨rfl,rfl,fun _ _ => rfl⟩

theorem capped_shape (i : Input) (s : State) (count : Nat) :
    exec i (capped count) s=loopState (exec i PairProgram020.normTrial) (FlagCore020C.guard 20) count (reset s) := by
  simp only [capped,exec_seqs_cons,exec_seqs_nil,exec_set,exec_loop,lit,eval_lit]
  rfl

theorem capped_correct (h : Rq) (tape : Bits tapeSize) (count : Nat) (s : State) (hc : count≤196) :
    let i := InputLayout020.encode h tape
    answer (exec i (capped count) s)=(firstFrom (source tape) count 0).map image ∧
      Preserves s (exec i (capped count) s) := by
  have post := loop_correct h tape count 0 (reset s) (by omega) (reset_counter s) (reset_empty s)
  dsimp only
  rw [capped_shape]
  exact ⟨post.1,preserves_trans (reset_preserves s) post.2⟩

/-- All196 original norm attempts, including exhaustion. Fresh cube is separate. -/
theorem cap196_correct (h : Rq) (tape : Bits tapeSize) (s : State) :
    let i := InputLayout020.encode h tape
    answer (exec i (capped 196) s)=
      (StandaloneRuntime019.first (StandaloneRuntime019.normTrial StandaloneRuntime019.tables)
        196 (StandaloneRuntime019.seedEquiv tape).1).map image ∧
      Preserves s (exec i (capped 196) s) := by
  have post := capped_correct h tape 196 s (by decide)
  rw [source_first] at post
  exact post

end FT1536.S05.NormCap020C
