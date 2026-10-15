import ConsumerCount020E13

namespace FT1536.S05.ConsumerCountBoundary020E13
open CommandConsumer020E11 ConsumerCount020E13

theorem bad (fuel : Nat) {n capacity : Nat} (q : State n capacity) (hb : q.bad=true) :
    ConsumerCount020E13.run fuel q=⟨q,fuel,0,0⟩ := by
  induction fuel with
  | zero => rfl
  | succ fuel ih =>
    simp only [ConsumerCount020E13.run,ConsumerCount020E13.step,hb,ite_true,ih]
    congr 1
    omega

theorem completed (fuel : Nat) {n capacity : Nat} (q : State n capacity) (hc : q.cursor.val=capacity) :
    ConsumerCount020E13.run fuel q=⟨q,fuel,0,0⟩ := by
  have hn : ¬q.cursor.val<capacity := by omega
  induction fuel with
  | zero => rfl
  | succ fuel ih =>
    simp only [ConsumerCount020E13.run,ConsumerCount020E13.step,dite_eq_right hn]
    split <;> simp only [ih]
    all_goals congr 1;omega

theorem malformed (fuel : Nat) {n capacity : Nat} (q : State n capacity)
    (hb : q.bad=false) (hc : q.cursor.val<capacity)
    (hd : CommandDecode020E11.decode n (slot q.encoded ⟨q.cursor.val,hc⟩)=none) :
    ConsumerCount020E13.run (fuel+1) q=⟨{q with bad:=true},fuel+1,1,0⟩ := by
  simp only [ConsumerCount020E13.run,ConsumerCount020E13.step,hb,Bool.false_eq_true,ite_false,
    dite_eq_left hc,hd,bad fuel {q with bad:=true} rfl]
  congr 1
  omega

/-- Zero recorded writes implies that the actual target bank is unchanged.
    Thus writes is not just a freely attached resource counter. -/
theorem step_no_write {n capacity : Nat} (q : State n capacity)
    (hw : (ConsumerCount020E13.step q).writes=0) :
    (ConsumerCount020E13.step q).value.target=q.target := by
  unfold ConsumerCount020E13.step at hw ⊢
  split
  · rfl
  · split
    · split
      · rfl
      · rename_i w he
        cases w with
        | none => rfl
        | some w => simp_all
    · rfl

theorem run_no_write {n capacity : Nat} (fuel : Nat) (q : State n capacity)
    (hw : (ConsumerCount020E13.run fuel q).writes=0) :
    (ConsumerCount020E13.run fuel q).value.target=q.target := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih =>
    simp only [ConsumerCount020E13.run] at hw ⊢
    have ha : (ConsumerCount020E13.step q).writes=0 := by omega
    have hb : (ConsumerCount020E13.run fuel (ConsumerCount020E13.step q).value).writes=0 := by omega
    exact (ih _ hb).trans (step_no_write q ha)

end FT1536.S05.ConsumerCountBoundary020E13
