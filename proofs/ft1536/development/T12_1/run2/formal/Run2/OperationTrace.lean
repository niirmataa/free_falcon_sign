import Run2.ProgramResources
import Run2.MiMoIntegration

namespace FT1536.Run2.OperationTrace
open Games FT1536.Relation FT1536.BitCost

/- These are cost labels for our interpreter, not the stronger MiMo reply
alphabet. Even an invalid final nonce has one final-validation label; its
dummy label nonce is never passed to the game or to the adversary. -/
def finalTag (f : Forgery) : GameMach.Op :=
  .fin (if hn : f.nonce.length=40 then MiMoIntegration.nonceToMiMo ⟨f.nonce,hn⟩ else 0)
    f.message f.signature

theorem finalTag_kind (f : Forgery) : kindOf (finalTag f)=.fin := rfl

noncomputable def traced (S : Sampler) (h : Rq) (cs : List Rq) (st : State) :
    {s q : ℕ} → Program s q → Dist (Option Finished × List GameMach.Op)
  | _,_,.done f => Dist.pure (some ⟨f,st⟩,[finalTag f])
  | _,_,.hash x k =>
      let tag:=GameMach.Op.hq (GameNames.decodeName x)
      match hashTargets cs x st with
      | none => Dist.pure (none,[tag])
      | some co => (traced S h cs (recordedHash x co.1 co.2) (k co.1)).map
          (fun out => (out.1,tag::out.2))
  | _,_,.sign m k =>
      let st':=submitted m st
      (Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
        match ROM.lookup (some r,m) st'.table with
        | some _ => Dist.pure (none,[.sq m])
        | none => (sample S h st' m r).bind fun co =>
            match programmedReply st' m r co with
            | none => Dist.pure (none,[.sq m])
            | some os => (traced S h cs os.2 (k os.1)).map
                (fun out => (out.1,GameMach.Op.sq m::out.2))

theorem projection_correct (S : Sampler) (h : Rq) (cs : List Rq)
    {s q : ℕ} (p : Program s q) : ∀ st,
    Dist.Same ((traced S h cs st p).map Prod.fst) (simulate S h cs st p) := by
  induction p with
  | done f => intro st F; simp only [traced,simulate,Dist.expect_map,Dist.expect_pure]
  | hash x k ih =>
    intro st F
    simp only [traced,simulate]
    cases hc : hashTargets cs x st with
    | none => simp only [Dist.expect_map,Dist.expect_pure]
    | some co => simpa only [Dist.expect_map] using ih co.1 (recordedHash x co.1 co.2) F
  | sign m k ih =>
    intro st F
    simp only [traced,simulate,signSim,parse_frame,Dist.expect_map,Dist.expect_bind]
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

theorem query_counts (S : Sampler) (h : Rq) (cs : List Rq)
    {s q : ℕ} (p : Program s q) : ∀ st,
    Dist.All (traced S h cs st p) (fun out =>
      cnt out.2 .hq≤q ∧ cnt out.2 .sq≤s ∧ cnt out.2 .fin≤1) := by
  induction p with
  | done f =>
    intro st
    apply Dist.all_pure
    simp only [cnt,finalTag_kind,reduceCtorEq,ite_false,ite_true,
      Nat.add_zero,Nat.le_refl,Nat.zero_le,and_self]
  | @hash s q x k ih =>
    intro st
    simp only [traced]
    split
    · apply Dist.all_pure; simp [cnt,kindOf]
    next co hc =>
      intro u
      have hh:=ih co.1 (recordedHash x co.1 co.2) u
      let out:=(traced S h cs (recordedHash x co.1 co.2) (k co.1)).out u
      change cnt (GameMach.Op.hq (GameNames.decodeName x)::out.2) .hq≤q+1 ∧
        cnt (GameMach.Op.hq (GameNames.decodeName x)::out.2) .sq≤s ∧
        cnt (GameMach.Op.hq (GameNames.decodeName x)::out.2) .fin≤1
      simp only [cnt,kindOf,ite_true,ite_false,reduceCtorEq,Nat.zero_add]
      dsimp only [out]
      omega
  | @sign s q m k ih =>
    intro st
    simp only [traced]
    apply Dist.all_bind _ _ (fun _ => True)
    · intro u; trivial
    · intro r _
      split
      · apply Dist.all_pure; simp [cnt,kindOf]
      · apply Dist.all_bind _ _ (fun _ => True)
        · intro u; trivial
        · intro co _
          simp only [programmedReply]
          intro u
          have hh:=ih (some (r,co.2))
            (recordedSign m (some (r,co.2))
              ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩) u
          let out:=(traced S h cs
            (recordedSign m (some (r,co.2))
              ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩)
            (k (some (r,co.2)))).out u
          change cnt (GameMach.Op.sq m::out.2) .hq≤q ∧
            cnt (GameMach.Op.sq m::out.2) .sq≤s+1 ∧ cnt (GameMach.Op.sq m::out.2) .fin≤1
          simp only [cnt,kindOf,ite_true,ite_false,reduceCtorEq,Nat.zero_add]
          dsimp only [out]
          omega

/- MiMo's composition is now instantiated on paths of our actual simulator.
This bounds its declared price envelope; primitive calibration and concrete
peak-memory refinement are the next layer, not assumptions smuggled into S. -/
theorem mimo_envelope_on_actual_paths (S : Sampler) (h : Rq) (cs : List Rq)
    {s q : ℕ} (p : Program s q) (st : State)
    (costS simA : Cost) (maxName maxMsg : ℕ) :
    Dist.All (traced S h cs st p) (fun out =>
      (out.2.map (costOp costS maxName maxMsg (q+s+1))).sum.t+simA.t≤
        (derivedResourceBound q s maxName maxMsg costS simA).t ∧
      (out.2.map (costOp costS maxName maxMsg (q+s+1))).sum.L+simA.L≤
        (derivedResourceBound q s maxName maxMsg costS simA).L) := by
  intro u
  have hh:=query_counts S h cs p st u
  have bound:=reducer_bit_cost_bound costS maxName maxMsg q s _ simA hh.1 hh.2.1 hh.2.2
  exact ⟨bound.1,bound.2.1⟩

end FT1536.Run2.OperationTrace
