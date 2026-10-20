import Run2.StoppedComparison

namespace FT1536.Run2
open Games ReaderBinding
open FT1536.Relation

def Origins (st : State) : Prop :=
  ∀ e∈st.table.table,e.target=none → e.name.2∈st.table.seen

theorem origins_initial : Origins initial := by
  intro e he
  simp [initial,ROM.empty] at he

theorem origins_insert (x : Bytes) (c : Rq) (st : State) (ho : Origins st) :
    Origins (insertTarget x c st) := by
  intro e he ht
  rcases List.mem_cons.mp he with he | he
  · subst e; contradiction
  · exact ho e he ht

theorem origins_hash (x : Bytes) (st : State) (ho : Origins st) :
    Dist.All (hashHonest x st) (fun co => Origins co.2) := by
  unfold hashHonest
  split
  · exact Dist.all_pure _ _ ho
  · exact Dist.all_map _ _ _ (fun c => origins_insert x c st ho)

theorem origins_sign (S : Sampler) (h : Rq) (st : State) (m : Bytes) (ho : Origins st) :
    Dist.All (signSim S h st m) (fun o => match o with | none => True | some os => Origins os.2) := by
  unfold signSim
  apply Dist.all_bind _ _ (fun _ => True)
  · intro x; trivial
  · intro r _
    split
    · exact Dist.all_pure _ _ trivial
    · apply Dist.all_map
      intro co e he ht
      rcases List.mem_cons.mp he with he | he
      · subst e; exact List.mem_cons_self
      · exact List.mem_cons_of_mem m (ho e he ht)

theorem finishAt_event (h : Rq) (st : State) (f : Forgery) (c : Rq)
    (ho : Origins st) (hf : f.message∉st.table.seen) (hn : f.nonce.length=40)
    (entry : ROM.Entry (Option Nonce) Bytes Rq)
    (hl : ROM.lookup (parse (f.nonce++f.message)) st.table=some entry) :
    (finishAt h f c st).isSome=accepted h c f := by
  let r : Nonce := ⟨f.nonce,hn⟩
  obtain ⟨hm,he⟩ := ROM.lookup_mem _ _ _ hl
  have hname : entry.name.2=f.message := by
    rw [he]
    change (parse (frame r f.message)).2=f.message
    rw [parse_frame]
  have ht : entry.target≠none := by
    intro hh
    exact hf (hname ▸ ho entry hm hh)
  cases hj : entry.target with
  | none => exact False.elim (ht hj)
  | some j => cases ha : accepted h c f <;> simp [finishAt,hl,hj,ha]

theorem done_event_binding (h : Rq) (st : State) (f : Forgery) (q : ℕ) (ho : Origins st) :
    Dist.Same ((Reader.lazy (doneReader h st f q)).map Option.isSome)
      (finishHonest h (some ⟨f,st⟩)) := by
  classical
  intro F
  simp only [doneReader,finishHonest]
  split
  · simp only [Reader.lazy,Dist.expect_map,Dist.expect_pure,Option.isSome_none]
  next hlegal =>
    have hf : f.message∉st.table.seen := fun hh => hlegal (Or.inl hh)
    have hn : f.nonce.length=40 := by by_contra hh; exact hlegal (Or.inr hh)
    cases hl : ROM.lookup (parse (f.nonce++f.message)) st.table with
    | some e =>
      have he := finishAt_event h st f e.value ho hf hn e hl
      simp only [Reader.lazy,Dist.expect_map,Dist.expect_pure,hashHonest,hl,he]
    | none =>
      simp only [Reader.lazy,Dist.expect_map,Dist.expect_bind,hashHonest,hl]
      apply Dist.expect_congr
      intro c
      simp only [Dist.expect_pure]
      have hnew := origins_insert (f.nonce++f.message) c st ho
      have hlookup : ROM.lookup (parse (f.nonce++f.message))
          (insertTarget (f.nonce++f.message) c st).table =
          some ⟨parse (f.nonce++f.message),c,some st.table.used⟩ := by
        simp [insertTarget,ROM.lookup]
      have he := finishAt_event h (insertTarget (f.nonce++f.message) c st) f c hnew hf hn _ hlookup
      rw [he]

theorem compiled_event_binding (S : Sampler) (h : Rq) {s q : ℕ} (p : Program s q) :
    ∀ st, Origins st →
    Dist.Same ((Reader.lazy (compileSolver S h st p)).map Option.isSome)
      ((simulateLazy S h st p).bind (finishHonest h)) := by
  induction p with
  | @done s q f =>
    intro st ho F
    have hh := done_event_binding h st f q ho F
    simpa only [compileSolver,simulateLazy,Dist.expect_bind,Dist.expect_pure] using hh
  | hash x k ih =>
    intro st ho F
    simp only [compileSolver,simulateLazy,Dist.expect_bind,Dist.expect_map]
    cases hl : ROM.lookup (parse x) st.table with
    | some e =>
      simp only [Reader.lazy,hashHonest,hl,Dist.expect_pure]
      have hh := ih e.value (recordedHash x e.value st) ho F
      simpa only [Dist.expect_bind,Dist.expect_map] using hh
    | none =>
      simp only [Reader.lazy,hashHonest,hl,Dist.expect_bind,Dist.expect_map]
      apply Dist.expect_congr
      intro c
      have hh := ih c (recordedHash x c (insertTarget x c st)) (origins_insert x c st ho) F
      simpa only [Dist.expect_bind,Dist.expect_map,insertTarget] using hh
  | sign m k ih =>
    intro st ho F
    simp only [compileSolver,simulateLazy,Reader.lazy,Dist.expect_bind,Dist.expect_map]
    unfold Dist.expect
    apply Finset.sum_congr rfl
    intro sample _
    have hgood := origins_sign S h st m ho sample
    cases hr : (signSim S h st m).out sample with
    | none =>
      change (signSim S h st m).law.mass sample*(Dist.pure (none : Option Witness)).expect (fun w => F w.isSome) =
        (signSim S h st m).law.mass sample*(Dist.pure (none : Option Finished)).expect
          (fun f => (finishHonest h f).expect F)
      rw [Dist.expect_pure,Dist.expect_pure]
      simp only [finishHonest,Dist.expect_pure,Option.isSome_none]
    | some os =>
      rw [hr] at hgood
      have hh := ih os.1 os.2 hgood F
      simp only [Dist.expect_bind,Dist.expect_map] at hh
      exact congrArg (fun t => (signSim S h st m).law.mass sample*t) hh

theorem concrete_lazy_game_binding (beta : Budget) (muH : Law Rq)
    (A : ClassicalAdversary beta) (S : Sampler) :
    Dist.Same (runMT (beta.qh+1) muH (Reduction.build beta A S)) (lazyGame beta muH A S) := by
  apply Dist.same_trans (runMT_lazy_binding beta muH A S)
  intro F
  simp only [lazyBuilt,lazyGame,Dist.expect_bind]
  apply Dist.expect_congr
  intro h
  apply Dist.expect_congr
  intro coins
  simpa only [Dist.expect_bind] using compiled_event_binding S h (A.code h coins) initial origins_initial F

theorem stopped_euf_to_concrete_mt {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK×Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (e : ℝ) (cert : LocalJointCertificate S e) :
    (runEUF beta muKey A true).event (fun b => b=true) ≤
      EventTransfer.phi ((1+e)^beta.qs-1)
        (AdvMT (beta.qh+1) (SigmaMath.muH muKey) (Reduction.build beta A S)) := by
  have hh := stopped_game_event_bound beta muKey A S e cert
  have he := Dist.same_event _ _ (concrete_lazy_game_binding beta (SigmaMath.muH muKey) A S) (fun b => b=true)
  change AdvMT _ _ _ = _ at he
  rwa [←he] at hh

end FT1536.Run2
