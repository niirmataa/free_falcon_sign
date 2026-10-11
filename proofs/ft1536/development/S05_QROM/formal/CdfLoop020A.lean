import CdfStep020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CdfLoop020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A SearchBounds020A CdfPrefix020A CdfStep020A

theorem next_bound (cdf : Nat → Nat) (u lo len : Nat) (hp : 0<len) (h : lo+len≤30721) :
    (next cdf u lo len).1+(next cdf u lo len).2≤30721 := by
  have hh := interval_step lo len hp h
  unfold next
  split <;> simp only <;> omega

theorem reference_step (cdf : Nat → Nat) (u fuel lo len : Nat) (hp : 0<len) :
    (StandaloneRuntime019.search cdf u (fuel+1) lo len).1 =
      (StandaloneRuntime019.search cdf u fuel (next cdf u lo len).1 (next cdf u lo len).2).1 := by
  simp only [StandaloneRuntime019.search,ite_eq_right (Nat.ne_of_gt hp),next]
  split_ifs <;> rfl

theorem guard_nonzero (s : State) (len : Nat) (hp : 0<len) (hl : len≤30721) (h9 : s.reg 9=nw len) :
    eval s (nz 9)≠0 := by
  change op .lt (word 0) (s.reg 9)≠0
  rw [h9,lt_word _ _ (by norm_num [Fits]) (tiny_fits (by omega))]
  have hp' : (0 : Int)<(len : Int) := by exact_mod_cast hp
  rw [ite_eq_left hp']
  decide

/-- Full bounded binary-search LOOP of020 agrees with019, including early
    empty intervals and arbitrary fuel. No monotonicity is needed for erasure. -/
theorem loop_correct (i : Input) (cdf : Nat → Nat) (u fuel lo len : Nat) (s : State)
    (image : Image i cdf) (cdfWidth : ∀ k<30721, cdf k<2^400) (huWidth : u<2^384)
    (h7 : s.reg 7=nw u) (h8 : s.reg 8=nw lo) (h9 : s.reg 9=nw len) (hbound : lo+len≤30721) :
    let t := loopState (exec i CdfStep020A.body) (nz 9) fuel s
    t.reg 8=nw (StandaloneRuntime019.search cdf u fuel lo len).1 ∧ Frame s t ∧ RegFrame s t := by
  induction fuel generalizing lo len s with
  | zero =>
    simp only [loopState,StandaloneRuntime019.search]
    exact ⟨h8,frame_refl s,fun _ _ _ _ _ _ _ => rfl⟩
  | succ fuel ih =>
    by_cases hz : len=0
    · subst len
      have hg : eval s (nz 9)=0 := by
        change op .lt (word 0) (s.reg 9)=0
        rw [h9]
        rfl
      rw [loopState,ite_eq_left hg]
      simp only [StandaloneRuntime019.search,ite_true]
      exact ⟨h8,frame_refl s,fun _ _ _ _ _ _ _ => rfl⟩
    · have hp : 0<len := by omega
      let s' := exec i CdfStep020A.body s
      have step := body_correct i cdf s u lo len image cdfWidth huWidth h7 h8 h9 hp hbound
      have h7' : s'.reg 7=nw u :=
        (step.2.2.2 7 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)).trans h7
      have post := ih (next cdf u lo len).1 (next cdf u lo len).2 s' h7' step.1 step.2.1
        (next_bound cdf u lo len hp hbound)
      rw [loopState,ite_eq_right (guard_nonzero s len hp (by omega) h9)]
      rw [reference_step cdf u fuel lo len hp]
      refine ⟨post.1,frame_trans step.2.2.1 post.2.1,?_⟩
      intro k h8 h9 h10 h11 h12 h30
      exact (post.2.2 k h8 h9 h10 h11 h12 h30).trans (step.2.2.2 k h8 h9 h10 h11 h12 h30)

end FT1536.S05.CdfLoop020A
