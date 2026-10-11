import ReadWordLoop020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ReadWordCorrect020A
open WordRAM020 PairProgram020 ReadSemantics020A BitValue020A ReadWordStep020A ReadWordLoop020A

theorem program_shape (dst : Reg) (base : Expr) (width : Nat) :
    readWord dst base width=seqs [set 5 (lit 0),set 4 (lit width),
      .loop width (nz 4) (body base),set dst (r 5)] := rfl

/-- Public input is arbitrary; this proves the actual020 reader for every
    tape, including both all-zero and all-one segments and width zero. -/
theorem readWord_correct (i : Input) (s : State) (dst : Reg) (base : Expr) (b width : Nat)
    (hw : width≤384) (ha : b+width≤tapeSize)
    (hb4 : (4 : Reg) ∉ reads base) (hb5 : (5 : Reg) ∉ reads base) (hb6 : (6 : Reg) ∉ reads base)
    (hb : eval s base=word b) :
    let t := exec i (readWord dst base width) s
    t.reg dst=word (value (tapeBits i) width b) ∧ Frame s t ∧
      ∀ k : Reg, k≠4 → k≠5 → k≠6 → k≠dst → t.reg k=s.reg k := by
  let s0 := put (put s 5 (word 0)) 4 (word width)
  have hs0b : eval s0 base=word b := by
    dsimp [s0]
    rw [eval_put _ _ 4 _ hb4,eval_put _ _ 5 _ hb5,hb]
  have h4 : s0.reg 4=word width := put_same _ _ _
  have h5 : s0.reg 5=word 0 := by
    dsimp [s0]
    rw [put_other _ 4 5 _ (by decide),put_same]
  have lp := loop_correct i base b width width 0 s0 hw (le_refl _) (by simp) ha hb4 hb5 hb6 hs0b h4 h5
  let st := loopState (exec i (body base)) (nz 4) width s0
  have hst : st.reg 5=word (value (tapeBits i) width b) := by
    simpa only [Nat.mul_zero,Nat.zero_add] using lp.2.1
  have hex : exec i (readWord dst base width) s=put st dst (st.reg 5) := by
    rw [program_shape]
    simp only [exec_seqs_cons,exec_seqs_nil,exec_set,exec_loop,lit,r,eval_lit,eval_reg]
    rfl
  dsimp only
  rw [hex]
  refine ⟨?_,?_,?_⟩
  · rw [put_same,hst]
  · exact frame_trans (frame_trans (frame_put s 5 (word 0)) (frame_put _ 4 (word width)))
      (frame_trans lp.2.2.1 (frame_put st dst (st.reg 5)))
  · intro k hk4 hk5 hk6 hkd
    rw [put_other _ dst k _ hkd,lp.2.2.2 k hk4 hk5 hk6]
    dsimp [s0]
    rw [put_other _ 4 k _ hk4,put_other _ 5 k _ hk5]

/-- Source019's little-endian value, not a second distribution or sampler. -/
theorem readWord_reference (i : Input) (s : State) (dst : Reg) (base : Expr) (b width : Nat)
    (hw : width≤384) (ha : b+width≤tapeSize)
    (hb4 : (4 : Reg) ∉ reads base) (hb5 : (5 : Reg) ∉ reads base) (hb6 : (6 : Reg) ∉ reads base)
    (hb : eval s base=word b) :
    (exec i (readWord dst base width) s).reg dst =
      word (StandaloneRuntime019.value width (fun j => tapeBits i (b+j.val))) := by
  rw [reference_value]
  exact (readWord_correct i s dst base b width hw ha hb4 hb5 hb6 hb).1

theorem readWord_no_new_fault (i : Input) (s : State) (dst : Reg) (base : Expr) (b width : Nat)
    (hw : width≤384) (ha : b+width≤tapeSize)
    (hb4 : (4 : Reg) ∉ reads base) (hb5 : (5 : Reg) ∉ reads base) (hb6 : (6 : Reg) ∉ reads base)
    (hb : eval s base=word b) :
    (exec i (readWord dst base width) s).fault=s.fault :=
  (readWord_correct i s dst base b width hw ha hb4 hb5 hb6 hb).2.1.2.2.symm

end FT1536.S05.ReadWordCorrect020A
