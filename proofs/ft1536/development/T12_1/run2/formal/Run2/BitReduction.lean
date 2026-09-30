import Run2.BitFinish
import Run2.NonceBits

namespace FT1536.Run2.BitReduction
open Games FT1536.Relation

noncomputable def sign (S : Sampler) (h : Rq) (st : State) (m : Bytes) :
    Dist (Option (Reply × State)) :=
  let st':=submitted m st
  ((Dist.draw (Law.uniform : Law (Fin 320 → Bool))).map NonceBits.nonceEquiv).bind fun r =>
    match (TableMachine.lookup (some r,m) st'.table.table).1 with
    | some _ => Dist.pure none
    | none => (sample S h st' m r).map (programmedReply st' m r)

theorem sign_binding (S : Sampler) (h : Rq) (st : State) (m : Bytes) :
    Dist.Same (sign S h st m) (signSim S h st m) := by
  unfold sign signSim
  simp only [TableMachine.lookup_correct,parse_frame]
  exact Dist.same_bind NonceBits.nonce_draw_binding (fun _ => Dist.same_refl _)

/- The only oracle subroutine is the supplied local S.code on its declared
fair bits. All public arithmetic, byte comparisons and finite target reads
below have concrete reference implementations and proved refinements. -/
noncomputable def simulate (S : Sampler) (h : Rq) (cs : List Rq) (st : State) :
    {s q : ℕ} → Program s q → Dist (Option Finished)
  | _,_,.done f => Dist.pure (some ⟨f,st⟩)
  | _,_,.hash x k =>
      match (TableMachine.hash cs x st).1 with
      | none => Dist.pure none
      | some co => simulate S h cs (recordedHash x co.1 co.2) (k co.1)
  | _,_,.sign m k => (sign S h st m).bind fun o => match o with
      | none => Dist.pure none
      | some os => simulate S h cs os.2 (k os.1)

theorem simulate_binding (S : Sampler) (h : Rq) (cs : List Rq)
    {s q : ℕ} (p : Program s q) : ∀ st,
    Dist.Same (simulate S h cs st p) (Games.simulate S h cs st p) := by
  induction p with
  | done f => intro st; exact Dist.same_refl _
  | hash x k ih =>
    intro st
    simp only [simulate,Games.simulate,TableMachine.hash_correct]
    cases hc : hashTargets cs x st with
    | none => exact Dist.same_refl _
    | some co => exact ih co.1 (recordedHash x co.1 co.2)
  | sign m k ih =>
    intro st
    simp only [simulate,Games.simulate]
    apply Dist.same_bind (sign_binding S h st m)
    intro o
    cases o with
    | none => exact Dist.same_refl _
    | some os => exact ih os.1 os.2

noncomputable def build (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler) :
    MTAdversary (beta.qh+1) where
  code h cs := (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
    (simulate S h cs.val initial (A.code h coins)).map (BitFinish.finish h cs.val)

theorem build_binding (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (h : Rq) (cs : List.Vector Rq (beta.qh+1)) :
    Dist.Same ((build beta A S).code h cs) ((Reduction.build beta A S).code h cs) := by
  simp only [build,Reduction.build]
  apply Dist.same_bind (Dist.same_refl _)
  intro coins
  have hf : BitFinish.finish h cs.val=finishSim h cs.val := funext (BitFinish.finish_correct h cs.val)
  rw [hf]
  exact Dist.same_map (simulate_binding S h cs.val (A.code h coins) initial) _

end FT1536.Run2.BitReduction
