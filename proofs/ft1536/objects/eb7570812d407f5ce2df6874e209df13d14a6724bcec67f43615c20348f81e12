import Run2.StateResources

namespace FT1536.Run2.PeakExecution
open Games FT1536.Relation StateResources ProgramResources

/- Ghost peak instrumentation: every intermediate state, including the
submitted message before a stopped Sign, is measured. The peak annotation
is erased by projection; it is not a history stored by the real reducer. -/
noncomputable def run (S : Sampler) (h : Rq) (cs : List Rq) (st : State) :
    {s q : ℕ} → Program s q → Dist (Option Finished × ℕ)
  | _,_,.done f => Dist.pure (some ⟨f,st⟩,stateBits st)
  | _,_,.hash x k =>
      match hashTargets cs x st with
      | none => Dist.pure (none,stateBits st)
      | some co => (run S h cs (recordedHash x co.1 co.2) (k co.1)).map
          (fun out => (out.1,max (stateBits st) out.2))
  | _,_,.sign m k =>
      let st':=submitted m st
      let here:=max (stateBits st) (stateBits st')
      (Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
        match ROM.lookup (some r,m) st'.table with
        | some _ => Dist.pure (none,here)
        | none => (sample S h st' m r).bind fun co =>
            match programmedReply st' m r co with
            | none => Dist.pure (none,here)
            | some os => (run S h cs os.2 (k os.1)).map
                (fun out => (out.1,max here out.2))

theorem projection_correct (S : Sampler) (h : Rq) (cs : List Rq)
    {s q : ℕ} (p : Program s q) : ∀ st,
    Dist.Same ((run S h cs st p).map Prod.fst) (Games.simulate S h cs st p) := by
  induction p with
  | done f => intro st F; simp only [run,Games.simulate,Dist.expect_map,Dist.expect_pure]
  | hash x k ih =>
    intro st F
    simp only [run,Games.simulate]
    cases hc : hashTargets cs x st with
    | none => simp only [Dist.expect_map,Dist.expect_pure]
    | some co => simpa only [Dist.expect_map] using ih co.1 (recordedHash x co.1 co.2) F
  | sign m k ih =>
    intro st F
    simp only [run,Games.simulate,signSim,parse_frame,Dist.expect_map,Dist.expect_bind]
    apply Dist.expect_congr
    intro r
    cases hc : ROM.lookup (some r,m) (submitted m st).table with
    | some e => simp only [Dist.expect_pure]
    | none =>
      simp only [Dist.expect_map,Dist.expect_bind]
      apply Dist.expect_congr
      intro co
      simp only [programmedReply]
      simpa only [Dist.expect_map,submitted,ROM.submit] using
        ih (some (r,co.2))
          (recordedSign m (some (r,co.2))
            ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩) F

theorem peak_state_bound (S : Sampler) (h : Rq) (cs : List Rq)
    {s q : ℕ} (p : Program s q) (L : ℕ) (hfit : Fits L p) :
    ∀ st n, Shape L n st → Good cs st →
      Dist.All (run S h cs st p) (fun out => out.2≤stateBound L (n+s+q) cs.length) := by
  induction p with
  | @done s q f =>
    intro st n hs hg
    apply Dist.all_pure
    exact (stateBits_bound L n cs st hs hg).trans
      (stateBound_mono L cs.length (by omega))
  | @hash s q x k ih =>
    intro st n hs hg
    have hhere : stateBits st≤stateBound L (n+s+(q+1)) cs.length :=
      (stateBits_bound L n cs st hs hg).trans (stateBound_mono L cs.length (by omega))
    simp only [run]
    split
    · exact Dist.all_pure _ _ hhere
    next co hc =>
      have hnext:=hash_shape cs x st co L n hs hfit.1 hc
      have hgood:=(hashTargets_good cs x st co hg hc).1
      have hh:=ih co.1 (hfit.2 co.1) (recordedHash x co.1 co.2) (n+1) hnext hgood
      have he : n+1+s+q=n+s+(q+1) := by omega
      rw [he] at hh
      intro u
      exact max_le hhere (hh u)
  | @sign s q m k ih =>
    intro st n hs hg
    have hbase : stateBits st≤stateBound L (n+(s+1)+q) cs.length :=
      (stateBits_bound L n cs st hs hg).trans (stateBound_mono L cs.length (by omega))
    have hsub : stateBits (submitted m st)≤stateBound L (n+(s+1)+q) cs.length :=
      (stateBits_bound L (n+1) cs (submitted m st) (submitted_shape L n st m hs hfit.1)
        (submitted_good cs st m hg)).trans (stateBound_mono L cs.length (by omega))
    have hhere:=max_le hbase hsub
    simp only [run]
    apply Dist.all_bind _ _ (fun _ => True)
    · intro u; trivial
    · intro r _
      split
      · exact Dist.all_pure _ _ hhere
      next hm =>
        apply Dist.all_bind _ _ (fun _ => True)
        · intro u; trivial
        · intro co _
          simp only [programmedReply]
          have hnext:=programmed_shape L n st m r co hs hfit.1
          have hgood:=programmed_good cs st m r co hg hm
          have hh:=ih (some (r,co.2)) (hfit.2 (some (r,co.2)))
            (recordedSign m (some (r,co.2))
              ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩)
            (n+1) hnext hgood
          have he : n+1+s+q=n+(s+1)+q := by omega
          rw [he] at hh
          intro u
          exact max_le hhere (hh u)

/- The MT input is the complete vector of QH+1 targets, not a streamed
oracle. Add its entire 16-bit coefficient storage and the public key. -/
def publicInputBits (T : ℕ) : ℕ := 24576*T+24576

def publicDataBound (L queries T : ℕ) : ℕ := stateBound L queries T+publicInputBits T

theorem initial_public_data_bound (S : Sampler) (h : Rq)
    {s q : ℕ} (cs : List.Vector Rq (q+1)) (p : Program s q)
    (L : ℕ) (hfit : Fits L p) :
    Dist.All (run S h cs.val initial p) (fun out =>
      out.2+publicInputBits (q+1)≤publicDataBound L (s+q) (q+1)) := by
  have hh:=peak_state_bound S h cs.val p L hfit initial 0 (initial_shape L) (initial_good cs.val)
  intro u
  have hb:=hh u
  simp only [Nat.zero_add,cs.property] at hb
  exact Nat.add_le_add_right hb _

end FT1536.Run2.PeakExecution
