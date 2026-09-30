import Run2.LazyEventBinding

set_option exponentiation.threshold 1024

namespace FT1536.Run2
open Finset Games
open FT1536.Relation

namespace Dist
theorem expect_mono {α : Type} (p : Dist α) (f g : α → ℝ) (h : ∀ x,f x≤g x) :
    p.expect f≤p.expect g := by
  apply sum_le_sum
  intro x _
  exact mul_le_mul_of_nonneg_left (h _) (p.law.nonneg x)
theorem expect_nonneg {α : Type} (p : Dist α) (f : α → ℝ) (h : ∀ x,0≤f x) : 0≤p.expect f := by
  exact sum_nonneg (fun x _ => mul_nonneg (p.law.nonneg x) (h _))
theorem expect_le {α : Type} (p : Dist α) (f : α → ℝ) (b : ℝ) (h : ∀ x,f x≤b) : p.expect f≤b := by
  have hh := expect_mono p f (fun _ => b) h
  rwa [expect_const] at hh
theorem expect_add {α : Type} (p : Dist α) (f g : α → ℝ) :
    p.expect (fun x => f x+g x)=p.expect f+p.expect g := by
  unfold expect
  simp_rw [mul_add,sum_add_distrib]
theorem expect_add_const {α : Type} (p : Dist α) (f : α → ℝ) (b : ℝ) :
    p.expect (fun x => f x+b)=p.expect f+b := by rw [expect_add,expect_const]
theorem event_expect {α : Type} (p : Dist α) (E : α → Prop) [DecidablePred E] :
    p.event E=p.expect (fun x => if E x then 1 else 0) := by
  classical
  unfold event expect Law.event
  apply sum_congr rfl
  intro x _
  by_cases hx : E (p.out x) <;> simp [hx]
end Dist

namespace StoppingLoss
noncomputable def loss (s q m : ℕ) : ℝ :=
  ∑ i∈range s, ((m+q+i : ℕ) : ℝ)/(2^320 : ℝ)

theorem loss_nonnegative (s q m : ℕ) : 0≤loss s q m := by
  unfold loss
  exact sum_nonneg (fun _ _ => by positivity)

theorem loss_hash (s q m m' : ℕ) (hm : m'≤m+1) : loss s q m'≤loss s (q+1) m := by
  unfold loss
  apply sum_le_sum
  intro i _
  apply div_le_div_of_nonneg_right _ (by positivity)
  exact_mod_cast (show m'+q+i≤m+(q+1)+i by omega)

theorem loss_sign (s q m : ℕ) :
    (m : ℝ)/(2^320 : ℝ)+loss s q (m+1)≤loss (s+1) q m := by
  unfold loss
  rw [sum_range_succ']
  have he : (∑ i∈range s,((m+q+(i+1) : ℕ) : ℝ)/(2^320 : ℝ)) =
      ∑ i∈range s,((m+1+q+i : ℕ) : ℝ)/(2^320 : ℝ) := by
    apply sum_congr rfl
    intro i _
    congr 2
    omega
  rw [he]
  have hh : (m : ℝ)/(2^320 : ℝ)≤((m+q+0 : ℕ) : ℝ)/(2^320 : ℝ) := by
    apply div_le_div_of_nonneg_right _ (by positivity)
    exact_mod_cast (Nat.le_add_right m q)
  linarith

theorem lookup_collision_iff (st : State) (m : Bytes) (r : Nonce) :
    (ROM.lookup (some r,m) (submitted m st).table).isSome=true ↔
      (some r,m)∈(st.table.table.map ROM.Entry.name).toFinset := by
  simp [ROM.lookup,submitted,ROM.submit,List.find?_isSome,List.mem_map]

noncomputable def conflictProbability (st : State) (m : Bytes) : ℝ :=
  (Law.uniform : Law Nonce).event (fun r => (ROM.lookup (some r,m) (submitted m st).table).isSome=true)

theorem conflict_bound (st : State) (m : Bytes) :
    conflictProbability st m≤(st.table.table.length : ℝ)/(2^320 : ℝ) := by
  unfold conflictProbability
  have he : (Law.uniform : Law Nonce).event
      (fun r => (ROM.lookup (some r,m) (submitted m st).table).isSome=true) =
      (Law.uniform : Law Nonce).event (fun r => (some r,m)∈(st.table.table.map ROM.Entry.name).toFinset) := by
    unfold Law.event
    apply sum_congr rfl
    intro r _
    simp only [lookup_collision_iff]
  rw [he]
  exact nonce_conflict_bound st m

theorem sign_loss (h : Rq) (st : State) (m : Bytes)
    (f g : Option (Reply×State) → ℝ) (D : ℝ) (hD : 0≤D)
    (hf : ∀ o,f o≤1) (hg : g none=0)
    (fresh : ∀ r co,f (programmedReply (submitted m st) m r co) ≤
      g (programmedReply (submitted m st) m r co)+D) :
    (signHonest h st m false).expect f ≤ (signHonest h st m true).expect g+
      conflictProbability st m+D := by
  classical
  let left := fun r : Nonce => match ROM.lookup (some r,m) (submitted m st).table with
    | some entry => ((Dist.draw (PublicSimulation.signBody (SigmaMath.syndrome h) entry.value)).map
        (fun o => some (some (r,o),recordedSign m (some (r,o)) (submitted m st)))).expect f
    | none => ((Dist.draw (SigmaMath.freshHonest h)).map (programmedReply (submitted m st) m r)).expect f
  let right := fun r : Nonce => match ROM.lookup (some r,m) (submitted m st).table with
    | some _ => (Dist.pure (none : Option (Reply×State))).expect g
    | none => ((Dist.draw (SigmaMath.freshHonest h)).map (programmedReply (submitted m st) m r)).expect g
  let bad := fun r : Nonce => if (ROM.lookup (some r,m) (submitted m st).table).isSome then (1 : ℝ) else 0
  have hleft : (signHonest h st m false).expect f=(Dist.draw (Law.uniform : Law Nonce)).expect left := by
    simp only [signHonest,parse_frame,Dist.expect_bind]
    apply Dist.expect_congr
    intro r
    cases hc : ROM.lookup (some r,m) (submitted m st).table <;> simp [hc,left]
  have hright : (signHonest h st m true).expect g=(Dist.draw (Law.uniform : Law Nonce)).expect right := by
    simp only [signHonest,parse_frame,Dist.expect_bind]
    apply Dist.expect_congr
    intro r
    cases hc : ROM.lookup (some r,m) (submitted m st).table <;> simp [hc,right]
  have hi (r : Nonce) : left r≤right r+bad r+D := by
    dsimp only [left,right,bad]
    cases hc : ROM.lookup (some r,m) (submitted m st).table with
    | some entry =>
      simp only [Dist.expect_pure,hg,Option.isSome_some,ite_true,zero_add]
      have hh := Dist.expect_le ((Dist.draw (PublicSimulation.signBody (SigmaMath.syndrome h) entry.value)).map
        (fun o => some (some (r,o),recordedSign m (some (r,o)) (submitted m st)))) f 1 hf
      linarith
    | none =>
      simp only [Dist.expect_map,Option.isSome_none,Bool.false_eq_true,ite_false,add_zero]
      have hh := Dist.expect_mono (Dist.draw (SigmaMath.freshHonest h))
        (fun co => f (programmedReply (submitted m st) m r co))
        (fun co => g (programmedReply (submitted m st) m r co)+D) (fresh r)
      rwa [Dist.expect_add_const] at hh
  have hh := Dist.expect_mono (Dist.draw (Law.uniform : Law Nonce)) left
    (fun r => right r+bad r+D) hi
  rw [Dist.expect_add_const,Dist.expect_add] at hh
  have he : (Dist.draw (Law.uniform : Law Nonce)).expect bad=conflictProbability st m := by
    change (∑ r : Nonce,(Law.uniform : Law Nonce).mass r*
      (if (ROM.lookup (some r,m) (submitted m st).table).isSome=true then 1 else 0)) =
      ∑ r : Nonce,if (ROM.lookup (some r,m) (submitted m st).table).isSome=true then (Law.uniform : Law Nonce).mass r else 0
    apply sum_congr rfl
    intro r _
    split_ifs <;> ring
  rw [he] at hh
  rwa [hleft,hright]

theorem hash_size (x : Bytes) (st : State) :
    Dist.All (hashHonest x st) (fun co => co.2.table.table.length≤st.table.table.length+1) := by
  unfold hashHonest
  split
  · exact Dist.all_pure _ _ (Nat.le_succ _)
  · exact Dist.all_map _ _ _ (fun _ => Nat.le_refl _)

theorem execution_stopping_loss (h : Rq) {s q : ℕ} (p : Program s q) :
    ∀ st score, (∀ o,score o≤1) → score none=0 →
    (honest h st false p).expect score ≤ (honest h st true p).expect score+
      loss s q st.table.table.length := by
  induction p with
  | @done s q f =>
    intro st score hu hz
    simp only [honest,Dist.expect_pure]
    linarith [loss_nonnegative s q st.table.table.length]
  | @hash s q x k ih =>
    intro st score hu hz
    simp only [honest,Dist.expect_bind]
    calc
      _ ≤ (hashHonest x st).expect (fun co =>
          (honest h (recordedHash x co.1 co.2) true (k co.1)).expect score+
          loss s (q+1) st.table.table.length) := by
        unfold Dist.expect
        apply sum_le_sum
        intro sample _
        let co := (hashHonest x st).out sample
        have hsize := hash_size x st sample
        have hh := ih co.1 (recordedHash x co.1 co.2) score hu hz
        change (honest h (recordedHash x co.1 co.2) false (k co.1)).expect score ≤
          (honest h (recordedHash x co.1 co.2) true (k co.1)).expect score+loss s q co.2.table.table.length at hh
        have hb := loss_hash s q st.table.table.length co.2.table.table.length hsize
        apply mul_le_mul_of_nonneg_left _ ((hashHonest x st).law.nonneg sample)
        change (honest h (recordedHash x co.1 co.2) false (k co.1)).expect score ≤
          (honest h (recordedHash x co.1 co.2) true (k co.1)).expect score+loss s (q+1) st.table.table.length
        linarith
      _ = _ := Dist.expect_add_const _ _ _
  | @sign s q m k ih =>
    intro st score hu hz
    let f := fun o : Option (Reply×State) => match o with
      | none => score none
      | some os => (honest h os.2 false (k os.1)).expect score
    let g := fun o : Option (Reply×State) => match o with
      | none => score none
      | some os => (honest h os.2 true (k os.1)).expect score
    have hf (o : Option (Reply×State)) : f o≤1 := by
      cases o with
      | none => exact hu none
      | some os => exact Dist.expect_le _ _ 1 hu
    have hg : g none=0 := hz
    have hF (r : Nonce) (co : Rq×Option PublicSimulation.BoxVec) :
        f (programmedReply (submitted m st) m r co) ≤
        g (programmedReply (submitted m st) m r co)+loss s q (st.table.table.length+1) := by
      let reply : Reply := some (r,co.2)
      let next : State := recordedSign m reply
        ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩
      have hh := ih reply next score hu hz
      exact hh
    have hs := sign_loss h st m f g (loss s q (st.table.table.length+1))
      (loss_nonnegative _ _ _) hf hg hF
    have hc := conflict_bound st m
    have hl := loss_sign s q st.table.table.length
    have hp : (honest h st false (.sign m k)).expect score = (signHonest h st m false).expect f := by
      simp only [honest,Dist.expect_bind]
      apply Dist.expect_congr
      intro o
      cases o <;> simp only [f,Dist.expect_pure]
    have hj : (honest h st true (.sign m k)).expect score = (signHonest h st m true).expect g := by
      simp only [honest,Dist.expect_bind]
      apply Dist.expect_congr
      intro o
      cases o <;> simp only [g,Dist.expect_pure]
    rw [hp,hj]
    linarith

noncomputable def finalScore (h : Rq) (o : Option Finished) : ℝ :=
  (finishHonest h o).event (fun b => b=true)

theorem finalScore_bounds (h : Rq) (o : Option Finished) : finalScore h o≤1 :=
  Dist.event_le_one _ _
theorem finalScore_none (h : Rq) : finalScore h none=0 := by
  rw [finalScore,Dist.event_expect]
  simp only [finishHonest,Dist.expect_pure,Bool.false_eq_true,ite_false]

theorem event_bind {α β : Type} (p : Dist α) (f : α → Dist β) (E : β → Prop)
    [DecidablePred E] : (p.bind f).event E=p.expect (fun x => (f x).event E) := by
  rw [Dist.event_expect,Dist.expect_bind]
  simp_rw [Dist.event_expect]

theorem fixed_key_stopping_loss (h : Rq) {s q : ℕ} (p : Program s q) :
    ((honest h initial false p).bind (finishHonest h)).event (fun b => b=true) ≤
      ((honest h initial true p).bind (finishHonest h)).event (fun b => b=true)+loss s q 0 := by
  rw [event_bind,event_bind]
  exact execution_stopping_loss h p initial (finalScore h) (finalScore_bounds h) (finalScore_none h)

theorem game_stopping_loss {SK : Type} [Fintype SK] (beta : Budget)
    (muKey : Law (SK×Rq)) (A : ClassicalAdversary beta) :
    AdvEUF beta muKey A ≤ (runEUF beta muKey A true).event (fun b => b=true)+loss beta.qs beta.qh 0 := by
  unfold AdvEUF runEUF
  simp only [event_bind]
  calc
    _ ≤ (Dist.draw muKey).expect (fun key =>
      (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).expect
        (fun coins => ((honest key.2 initial true (A.code key.2 coins)).bind (finishHonest key.2)).event (fun b => b=true))+
      loss beta.qs beta.qh 0) := by
        apply Dist.expect_mono
        intro key
        have hh := Dist.expect_mono (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool)))
          _ _ (fun coins => fixed_key_stopping_loss key.2 (A.code key.2 coins))
        simpa only [Dist.expect_add_const,event_bind] using hh
    _ = _ := by rw [Dist.expect_add_const]; simp only [event_bind]

theorem loss_exact (qs qh : ℕ) : loss qs qh 0 =
    ((qs : ℝ)*qh+(qs : ℝ)*((qs-1 : ℕ) : ℝ)/2)/(2^320 : ℝ) := by
  unfold loss
  simp only [Nat.zero_add]
  rw [←sum_div,ROM.collision_sum]

noncomputable def epsColl (beta : Budget) : ℝ := min 1 (loss beta.qs beta.qh 0)

theorem clipped_game_stopping_loss {SK : Type} [Fintype SK] (beta : Budget)
    (muKey : Law (SK×Rq)) (A : ClassicalAdversary beta) :
    AdvEUF beta muKey A ≤ (runEUF beta muKey A true).event (fun b => b=true)+epsColl beta := by
  unfold epsColl
  by_cases hb : loss beta.qs beta.qh 0≤1
  · rw [min_eq_right hb]
    exact game_stopping_loss beta muKey A
  · rw [min_eq_left (le_of_not_ge hb)]
    have h0 := Dist.event_nonneg (runEUF beta muKey A true) (fun b => b=true)
    have h1 := Dist.event_le_one (runEUF beta muKey A false) (fun b => b=true)
    exact h1.trans (by linarith)

end StoppingLoss
end FT1536.Run2
