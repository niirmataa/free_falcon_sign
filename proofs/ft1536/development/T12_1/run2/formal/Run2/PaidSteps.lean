import Run2.GameInvariants

namespace FT1536.Run2
open Games PublicSimulation
open FT1536.Relation

def paid : List Event → ℕ
  | [] => 0
  | .hash _ _ :: es => paid es
  | .sign _ _ :: es => paid es+1

theorem signSim_paid (S : Sampler) (h : Rq) (st : State) (m : Bytes) :
    Dist.All (signSim S h st m) (fun o => match o with
      | none => True
      | some os => paid os.2.events = paid st.events+1) := by
  unfold signSim
  apply Dist.all_bind _ _ (fun _ => True)
  · intro x; trivial
  · intro r _
    split
    · exact Dist.all_pure _ _ trivial
    · exact Dist.all_map _ _ _ (fun _ => rfl)

theorem hashTargets_events (cs : List Rq) (x : Bytes) (st : State) (co : Rq × State)
    (hh : hashTargets cs x st = some co) : co.2.events = st.events := by
  unfold hashTargets at hh
  split at hh
  · cases hh; rfl
  · split at hh
    · contradiction
    · cases hh; rfl

theorem paid_step_bound (S : Sampler) (h : Rq) (cs : List Rq)
    {s q : ℕ} (p : Program s q) : ∀ st,
    Dist.All (simulate S h cs st p) (fun o => match o with
      | none => True
      | some f => paid f.state.events ≤ paid st.events+s) := by
  induction p with
  | done f =>
    intro st
    exact Dist.all_pure _ _ (Nat.le_add_right _ _)
  | @hash s q x k ih =>
    intro st
    simp only [simulate]
    split
    · exact Dist.all_pure _ _ trivial
    next co hc =>
      have hi := ih co.1 (recordedHash x co.1 co.2)
      intro u
      have hh := hi u
      cases ho : (simulate S h cs (recordedHash x co.1 co.2) (k co.1)).out u with
      | none => trivial
      | some f =>
        rw [ho] at hh
        simpa only [recordedHash,paid,hashTargets_events cs x st co hc] using hh
  | @sign s q m k ih =>
    intro st
    simp only [simulate]
    refine Dist.all_bind (signSim S h st m)
      (fun o => match o with | none => Dist.pure none | some os => simulate S h cs os.2 (k os.1))
      _ (fun o => match o with | none => True | some f => paid f.state.events ≤ paid st.events+(s+1))
      (signSim_paid S h st m) ?_
    intro o ho
    cases o with
    | none => exact Dist.all_pure _ _ trivial
    | some os =>
      have hi := ih os.1 os.2
      intro u
      have hh := hi u
      cases hr : (simulate S h cs os.2 (k os.1)).out u with
      | none => trivial
      | some f =>
        rw [hr] at hh
        omega

/- This theorem counts the actual returned Sign transitions. It is not yet
the likelihood-potential theorem: assigning factor 1+e to these transitions
requires the remaining interpreter/law induction. -/
theorem initially_at_most_Qs (S : Sampler) (h : Rq) (cs : List Rq)
    {qs qh : ℕ} (p : Program qs qh) :
    Dist.All (simulate S h cs initial p) (fun o => match o with
      | none => True | some f => paid f.state.events ≤ qs) := by
  simpa only [initial,paid,Nat.zero_add] using paid_step_bound S h cs p initial

end FT1536.Run2
