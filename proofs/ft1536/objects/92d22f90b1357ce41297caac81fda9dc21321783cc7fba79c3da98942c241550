import Run2.LocalMachineCode
import Run2.PeakExecution

namespace FT1536.Run2.MachineExecution
open Games FT1536.Relation PublicSimulation StateResources LocalMachineCode

def afterSign (st : State) (m : Bytes) (r : Nonce) (co : Rq × Option BoxVec) : State :=
  recordedSign m (some (r,co.2))
    ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩

/- This executor has no Program continuation or S.code call. Each request
comes from executing the supplied finite local code. Its fuel is explicit;
the proof below shows that it does not truncate an admissible adversary.
The typed fields denote their canonical finite files (LocalMachineCode's
erasure theorem); public table and final arithmetic use the existing code. -/
noncomputable def run (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (h : Rq) (cs : List Rq) (coins : Fin beta.coinBits → Bool) :
    ℕ → State → Dist (Option Finished)
  | 0,_ => Dist.pure none
  | fuel+1,st =>
      match resume beta A ac h coins st.events with
      | .done f => Dist.pure (some ⟨f,st⟩)
      | .hash x =>
          match (TableMachine.hash cs x st).1 with
          | none => Dist.pure none
          | some co => run beta A S ac sc h cs coins fuel (recordedHash x co.1 co.2)
      | .sign m =>
          ((Dist.draw (Law.uniform : Law (Fin 320 → Bool))).map NonceBits.nonceEquiv).bind fun r =>
            match (TableMachine.lookup (some r,m) (submitted m st).table.table).1 with
            | some _ => Dist.pure none
            | none => (Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun bits =>
                let co:=LocalMachineCode.sample beta S sc h (submitted m st) m r bits
                run beta A S ac sc h cs coins fuel (afterSign st m r co)

theorem hash_events (cs : List Rq) (x : Bytes) (st : State) (co : Rq × State)
    (hc : hashTargets cs x st=some co) : co.2.events=st.events := by
  unfold hashTargets at hc
  split at hc
  · cases hc; rfl
  · split at hc
    · contradiction
    · cases hc; rfl

theorem submitted_cap (beta : Budget) (cs : List.Vector Rq (beta.qh+1))
    (st : State) (m : Bytes) (n s q : ℕ)
    (hb : n+(s+1)+q≤beta.qs+beta.qh)
    (hs : Shape beta.bytes n st) (hg : Good cs.val st) (hm : m.length≤beta.bytes) :
    stateBits (submitted m st)≤SamplerMachine.stateCap beta := by
  have hh:=stateBits_bound beta.bytes (n+1) cs.val (submitted m st)
    (submitted_shape beta.bytes n st m hs hm) (submitted_good cs.val st m hg)
  rw [cs.property] at hh
  exact hh.trans (stateBound_mono beta.bytes (beta.qh+1) (by omega))

theorem run_binding (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (h : Rq) (cs : List.Vector Rq (beta.qh+1)) (coins : Fin beta.coinBits → Bool)
    {s q : ℕ} (p : Program s q) :
    ∀ (st : State) (n fuel : ℕ), Shape beta.bytes n st → Good cs.val st →
      n+s+q≤beta.qs+beta.qh → s+q<fuel →
      AdversaryMachine.At beta A h coins st.events p →
      Dist.Same (run beta A S ac sc h cs.val coins fuel st) (Games.simulate S h cs.val st p) := by
  induction p with
  | done f =>
    intro st n fuel hs hg hb hf hat
    cases fuel with
    | zero => omega
    | succ fuel =>
      rw [run,resume_correct beta A ac h coins st.events (.done f) hat]
      exact Dist.same_refl _
  | @hash s q x k ih =>
    intro st n fuel hs hg hb hf hat
    have fits:=(AdversaryMachine.at_budget_and_fits beta A h coins (ac.fits h coins) hat).2.2
    cases fuel with
    | zero => omega
    | succ fuel =>
      rw [run,resume_correct beta A ac h coins st.events (.hash x k) hat]
      simp only [head,TableMachine.hash_correct,Games.simulate]
      cases hc : hashTargets cs.val x st with
      | none => exact Dist.same_refl _
      | some co =>
        have hn:=hash_shape cs.val x st co beta.bytes n hs fits.1 hc
        have hgood:=(hashTargets_good cs.val x st co hg hc).1
        have ha : AdversaryMachine.At beta A h coins (recordedHash x co.1 co.2).events (k co.1) := by
          simpa only [recordedHash,hash_events cs.val x st co hc] using
            AdversaryMachine.At.hash_step hat co.1
        exact ih co.1 _ (n+1) fuel hn hgood (by omega) (by omega) ha
  | @sign s q m k ih =>
    intro st n fuel hs hg hb hf hat
    have fits:=(AdversaryMachine.at_budget_and_fits beta A h coins (ac.fits h coins) hat).2.2
    have hcap:=submitted_cap beta cs st m n s q hb hs hg fits.1
    cases fuel with
    | zero => omega
    | succ fuel =>
      rw [run,resume_correct beta A ac h coins st.events (.sign m k) hat]
      simp only [head,TableMachine.lookup_correct,Games.simulate,signSim,parse_frame]
      apply Dist.same_trans (Dist.same_bind NonceBits.nonce_draw_binding (fun _ => Dist.same_refl _))
      intro F
      simp only [Dist.expect_bind]
      apply Dist.expect_congr
      intro r
      cases hm : ROM.lookup (some r,m) (submitted m st).table with
      | some e => simp only [Dist.expect_pure]
      | none =>
        simp only [FT1536.Run2.sample,Dist.expect_bind,Dist.expect_map]
        apply Dist.expect_congr
        intro bits
        rw [sample_correct beta S sc h (submitted m st) m r bits hcap fits.1]
        let co:=S.code h (submitted m st) m r bits
        have hn:=programmed_shape beta.bytes n st m r co hs fits.1
        have hgood:=programmed_good cs.val st m r co hg hm
        have ha : AdversaryMachine.At beta A h coins (afterSign st m r co).events
            (k (some (r,co.2))) := AdversaryMachine.At.sign_step hat (some (r,co.2))
        have he:=ih (some (r,co.2)) (afterSign st m r co) (n+1) fuel hn hgood
          (by omega) (by omega) ha F
        simpa only [programmedReply,afterSign,submitted,ROM.submit,co] using he

noncomputable def build (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S) : MTAdversary (beta.qh+1) where
  code h cs := (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
    (run beta A S ac sc h cs.val coins (beta.qs+beta.qh+1) initial).map (BitFinish.finish h cs.val)

theorem build_binding (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (h : Rq) (cs : List.Vector Rq (beta.qh+1)) :
    Dist.Same ((build beta A S ac sc).code h cs) ((Reduction.build beta A S).code h cs) := by
  simp only [build,Reduction.build]
  apply Dist.same_bind (Dist.same_refl _)
  intro coins
  have hf : BitFinish.finish h cs.val=finishSim h cs.val := funext (BitFinish.finish_correct h cs.val)
  rw [hf]
  apply Dist.same_map
  exact run_binding beta A S ac sc h cs coins (A.code h coins) initial 0 (beta.qs+beta.qh+1)
    (initial_shape beta.bytes) (initial_good cs.val) (by omega) (by omega) .initial

end FT1536.Run2.MachineExecution

#print FT1536.Run2.MachineExecution.run_binding
#print FT1536.Run2.MachineExecution.build_binding
#print axioms FT1536.Run2.MachineExecution.run_binding
#print axioms FT1536.Run2.MachineExecution.build_binding
