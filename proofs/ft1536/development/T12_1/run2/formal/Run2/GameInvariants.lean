import Run2.Games
import FT1536.Collision

namespace FT1536.Run2
open Games PublicSimulation
open FT1536.Relation

namespace Dist
def All {α : Type} (p : Dist α) (P : α → Prop) : Prop := ∀ x, P (p.out x)
theorem all_pure {α : Type} (x : α) (P : α → Prop) (h : P x) : All (pure x) P := by
  intro u
  exact h
theorem all_map {α β : Type} (p : Dist α) (f : α → β) (P : β → Prop)
    (h : ∀ x, P (f x)) : All (p.map f) P := by
  intro x
  exact h _
theorem all_bind {α β : Type} (p : Dist α) (f : α → Dist β) (P : α → Prop) (Q : β → Prop)
    (hp : All p P) (hf : ∀ x, P x → All (f x) Q) : All (p.bind f) Q := by
  intro xy
  exact hf _ (hp xy.1) xy.2
end Dist

def targets (cs : List Rq) (j : ℕ) : Rq := cs[j]?.getD 0
def Good (cs : List Rq) (st : State) : Prop :=
  ROM.Good (targets cs) st.table ∧ ROM.Unique st.table ∧ st.table.used ≤ cs.length

theorem hashTargets_legacy (cs : List Rq) (x : Bytes) (st : State) (co : Rq × State)
    (h : hashTargets cs x st = some co) :
    ROM.hash (targets cs) (parse x) st.table = (co.1,co.2.table) := by
  unfold hashTargets at h
  split at h
  next e he => cases h; simp [ROM.hash,he]
  next he =>
    split at h
    · contradiction
    next c hc => cases h; simp [ROM.hash,he,targets,hc]

theorem hashTargets_good (cs : List Rq) (x : Bytes) (st : State) (co : Rq × State)
    (hg : Good cs st) (hh : hashTargets cs x st = some co) :
    Good cs co.2 ∧ co.2.table.used ≤ st.table.used+1 := by
  have hl := hashTargets_legacy cs x st co hh
  have hi := ROM.hash_good (targets cs) (parse x) st.table hg.1
  have hu := ROM.hash_unique (targets cs) (parse x) st.table hg.2.1
  have hc := ROM.hash_used_le (targets cs) (parse x) st.table
  rw [hl] at hi hu hc
  refine ⟨⟨hi,hu,?_⟩,hc⟩
  unfold hashTargets at hh
  split at hh
  · cases hh; exact hg.2.2
  · split at hh
    · contradiction
    next c he =>
      have hn : st.table.used < cs.length := (List.getElem?_eq_some_iff.mp he).1
      cases hh
      exact hn

theorem signSim_good (S : Sampler) (h : Rq) (cs : List Rq) (st : State) (m : Bytes)
    (hg : Good cs st) : Dist.All (signSim S h st m) (fun o => match o with
      | none => True
      | some os => Good cs os.2 ∧ os.2.table.used = st.table.used ∧ m ∈ os.2.table.seen) := by
  unfold signSim
  apply Dist.all_bind _ _ (fun _ => True)
  · intro x; trivial
  · intro r _
    split
    · exact Dist.all_pure _ _ trivial
    next hm =>
      apply Dist.all_map
      intro co
      have hsub := ROM.submit_good (targets cs) m st.table hg.1
      have hprogram : ROM.program (some r,m) co.1 (ROM.submit m st.table) =
          some ⟨⟨(some r,m),co.1,none⟩ :: st.table.table,m::st.table.seen,st.table.used⟩ := by
        simp only [parse_frame, submitted] at hm
        rw [ROM.program,hm]
        rfl
      obtain ⟨good,_⟩ := ROM.program_good (targets cs) (some r,m) co.1 _ _ hsub
        (by simp [ROM.submit]) hprogram
      have unique := ROM.program_unique (some r,m) co.1 (ROM.submit m st.table) _
        (show ROM.Unique (ROM.submit m st.table) from hg.2.1) hprogram
      exact ⟨⟨good,unique,hg.2.2⟩,rfl,by simp [recordedSign,submitted,ROM.submit]⟩

theorem simulate_invariants (S : Sampler) (h : Rq) (cs : List Rq)
    {s q : ℕ} (p : Program s q) : ∀ st, Good cs st →
    Dist.All (simulate S h cs st p) (fun o => match o with
      | none => True
      | some f => Good cs f.state ∧ f.state.table.used ≤ st.table.used+q) := by
  induction p with
  | done f =>
    intro st hg
    apply Dist.all_pure
    exact ⟨hg,Nat.le_add_right _ _⟩
  | @hash s q x k ih =>
    intro st hg
    simp only [simulate]
    split
    · exact Dist.all_pure _ _ trivial
    next co hc =>
      obtain ⟨hgood,hcount⟩ := hashTargets_good cs x st co hg hc
      have hi := ih co.1 (recordedHash x co.1 co.2) hgood
      intro u
      have hh := hi u
      cases ho : (simulate S h cs (recordedHash x co.1 co.2) (k co.1)).out u with
      | none => trivial
      | some f =>
        rw [ho] at hh
        refine ⟨hh.1,?_⟩
        dsimp [recordedHash] at hh
        omega
  | @sign s q m k ih =>
    intro st hg
    simp only [simulate]
    refine Dist.all_bind (signSim S h st m)
      (fun o => match o with | none => Dist.pure none | some os => simulate S h cs os.2 (k os.1))
      _ (fun o => match o with | none => True | some f => Good cs f.state ∧ f.state.table.used ≤ st.table.used+q)
      (signSim_good S h cs st m hg) ?_
    intro o ho
    cases o with
    | none => exact Dist.all_pure _ _ trivial
    | some os =>
      have hi := ih os.1 os.2 ho.1
      intro u
      have hh := hi u
      cases hr : (simulate S h cs os.2 (k os.1)).out u with
      | none => trivial
      | some f =>
        rw [hr] at hh
        exact ⟨hh.1,by simpa only [ho.2.1] using hh.2⟩

theorem fresh_finish_index (cs : List Rq) (st : State) (f : Forgery) (co : Rq × State)
    (hg : Good cs st) (hf : f.message ∉ st.table.seen) (hlen : f.nonce.length = 40)
    (hh : hashTargets cs (f.nonce++f.message) st = some co) :
    ∃ j, j < cs.length ∧ co.1 = targets cs j := by
  let r : Nonce := ⟨f.nonce,hlen⟩
  have hl := hashTargets_legacy cs (frame r f.message) st co hh
  have hx := ROM.final_hash_index (targets cs) st.table (parse (frame r f.message)) hg.1
    (by simpa [parse_frame] using hf)
  rw [hl] at hx
  obtain ⟨j,hj,hc⟩ := hx
  exact ⟨j,hj.trans_le (hashTargets_good cs _ st co hg hh).1.2.2,hc⟩

theorem hashTargets_lookup (cs : List Rq) (x : Bytes) (st : State) (co : Rq × State)
    (hh : hashTargets cs x st = some co) :
    ∃ e, ROM.lookup (parse x) co.2.table = some e ∧ e.value = co.1 := by
  unfold hashTargets at hh
  split at hh
  next e he => cases hh; exact ⟨e,he,rfl⟩
  next hm =>
    split at hh
    · contradiction
    next c hc =>
      cases hh
      exact ⟨⟨parse x,c,some st.table.used⟩,by simp [ROM.lookup],rfl⟩

theorem hashTargets_total (cs : List Rq) (x : Bytes) (st : State)
    (hn : st.table.used < cs.length) : ∃ co, hashTargets cs x st = some co := by
  unfold hashTargets
  split
  · exact ⟨_,rfl⟩
  · rw [List.getElem?_eq_getElem hn]
    exact ⟨_,rfl⟩

theorem hashTargets_seen (cs : List Rq) (x : Bytes) (st : State) (co : Rq × State)
    (hh : hashTargets cs x st = some co) : co.2.table.seen = st.table.seen := by
  unfold hashTargets at hh
  split at hh
  · cases hh; rfl
  · split at hh
    · contradiction
    · cases hh; rfl

theorem finishSim_complete (h : Rq) (cs : List Rq) (f : Finished) (co : Rq × State)
    (hg : Good cs f.state) (hf : f.forgery.message ∉ f.state.table.seen)
    (hn : f.forgery.nonce.length=40)
    (hh : hashTargets cs (f.forgery.nonce++f.forgery.message) f.state=some co)
    (hv : Verify h co.1 (decodeVec f.forgery.signature)) :
    ∃ j, finishSim h cs (some f) = some (j,extract h co.1 (decodeVec f.forgery.signature)) := by
  classical
  let r : Nonce := ⟨f.forgery.nonce,hn⟩
  obtain ⟨e,he,_⟩ := hashTargets_lookup cs _ _ co hh
  have hgood := (hashTargets_good cs _ _ co hg hh).1
  have hf' : (parse (f.forgery.nonce++f.forgery.message)).2 ∉ co.2.table.seen := by
    rw [hashTargets_seen cs _ _ co hh]
    change (parse (frame r f.forgery.message)).2 ∉ f.state.table.seen
    simpa only [parse_frame] using hf
  obtain ⟨j,hj,_,_⟩ := ROM.indexed_entry (targets cs) co.2.table _ e hgood.1 hf' he
  refine ⟨j,?_⟩
  simp [finishSim,hf,hn,hh,accepted,hv,he,hj]

theorem finishSim_sound (h : Rq) (cs : List Rq) (f : Finished)
    (hg : Good cs f.state) (j : ℕ) (z : Geometry.Vec × Geometry.Vec)
    (hw : finishSim h cs (some f) = some (j,z)) :
    ∃ c, cs[j]? = some c ∧ ShortPreimage h c z := by
  classical
  simp only [finishSim] at hw
  split at hw
  · contradiction
  next _hlegal =>
    split at hw
    · contradiction
    next co hco =>
      split at hw
      next hv =>
        split at hw
        · contradiction
        next entry he =>
          cases hj : entry.target with
          | none => simp [hj] at hw
          | some idx =>
            simp only [hj,Option.map_some,Option.some.injEq,Prod.mk.injEq] at hw
            obtain ⟨rfl,rfl⟩ := hw
            obtain ⟨e,he',hev⟩ := hashTargets_lookup cs _ _ co hco
            have heq : e=entry := Option.some.inj (he'.symm.trans he)
            subst e
            have hgood := (hashTargets_good cs _ _ co hg hco).1
            have hgentry := hgood.1 entry (ROM.lookup_mem _ _ _ he).1
            rw [hj] at hgentry
            have hi := hgentry.1.trans_le hgood.2.2
            have hget := List.getElem?_eq_getElem hi
            refine ⟨cs[idx],hget,?_⟩
            have hc : co.1 = cs[idx] := by
              rw [← hev,hgentry.2]
              simp [targets,hget]
            have hverify : Verify h co.1 (decodeVec f.forgery.signature) := by
              simpa only [accepted,decide_eq_true_eq] using hv
            rw [← hc]
            exact accepted_extracts h co.1 _ hverify
      next => contradiction

theorem initial_good (cs : List Rq) : Good cs initial :=
  ⟨ROM.empty_good _, List.nodup_nil, Nat.zero_le _⟩

theorem build_output_sound (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler)
    (h : Rq) (cs : List.Vector Rq (beta.qh+1)) :
    Dist.All ((Reduction.build beta A S).code h cs) (fun w => match w with
      | none => True
      | some (j,z) => ∃ c, cs.val[j]?=some c ∧ ShortPreimage h c z) := by
  unfold Reduction.build
  dsimp only
  apply Dist.all_bind _ _ (fun _ => True)
  · intro x; trivial
  · intro coins _
    have hi := simulate_invariants S h cs.val (A.code h coins) initial (initial_good _)
    intro x
    have hx := hi x
    change (match finishSim h cs.val ((simulate S h cs.val initial (A.code h coins)).out x) with
      | none => True | some (j,z) => ∃ c,cs.val[j]?=some c ∧ ShortPreimage h c z)
    cases ho : (simulate S h cs.val initial (A.code h coins)).out x with
    | none => trivial
    | some f =>
      rw [ho] at hx
      cases hw : finishSim h cs.val (some f) with
      | none => trivial
      | some w => exact finishSim_sound h cs.val f hx.1 w.1 w.2 hw

/- Actual per-query table bound: no artificial independence of chosen message
and previous history; only the new nonce is averaged uniformly. -/
theorem nonce_conflict_bound (st : State) (m : Bytes) :
    (Law.uniform : Law Nonce).event (fun r => (some r,m) ∈ (st.table.table.map ROM.Entry.name).toFinset) ≤
      (st.table.table.length : ℝ)/(2^320 : ℝ) := by
  classical
  have h := ROM.fresh_nonce_conflict (fun r : Nonce => (some r,m))
    (by intro r s hh; simpa using hh) (st.table.table.map ROM.Entry.name).toFinset
  rw [nonce_card] at h
  simp only [Nat.cast_pow, Nat.cast_ofNat] at h
  have hc := List.toFinset_card_le (st.table.table.map ROM.Entry.name)
  simp only [List.length_map] at hc
  apply h.trans
  apply div_le_div_of_nonneg_right _ (by positivity)
  exact_mod_cast hc

end FT1536.Run2
