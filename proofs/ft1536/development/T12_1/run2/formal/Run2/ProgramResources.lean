import Run2.ConcreteReduction

namespace FT1536.Run2.ProgramResources
open Games
open FT1536.Relation

structure Counters where
  explicitHash : ℕ := 0
  signQueries : ℕ := 0
  nonceBits : ℕ := 0
  samplerBits : ℕ := 0
  submittedBytes : ℕ := 0

def Counters.plus (a b : Counters) : Counters :=
  ⟨a.explicitHash+b.explicitHash,a.signQueries+b.signQueries,
    a.nonceBits+b.nonceBits,a.samplerBits+b.samplerBits,a.submittedBytes+b.submittedBytes⟩

/- Instrument the concrete calls, including stops. Counts are not lost when
the stopped game has no final forgery. No whole-reducer cost is assumed. -/
noncomputable def counted (S : Sampler) (h : Rq) (cs : List Rq) (st : State) :
    {s q : ℕ} → Program s q → Dist (Option Finished × Counters)
  | _,_,.done f => Dist.pure (some ⟨f,st⟩,{})
  | _,_,.hash x k =>
      let cost : Counters := ⟨1,0,0,0,x.length⟩
      match hashTargets cs x st with
      | none => Dist.pure (none,cost)
      | some co => (counted S h cs (recordedHash x co.1 co.2) (k co.1)).map
          (fun out => (out.1,cost.plus out.2))
  | _,_,.sign m k =>
      let st' := submitted m st
      (Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
        match ROM.lookup (some r,m) st'.table with
        | some _ => Dist.pure (none,⟨0,1,320,0,m.length⟩)
        | none => (sample S h st' m r).bind fun co =>
            match programmedReply st' m r co with
            | none => Dist.pure (none,⟨0,1,320,S.bits,m.length⟩)
            | some os => (counted S h cs os.2 (k os.1)).map
                (fun out => (out.1,(⟨0,1,320,S.bits,m.length⟩ : Counters).plus out.2))

def Fits (L : ℕ) : {s q : ℕ} → Program s q → Prop
  | _,_,.done f => f.message.length+f.nonce.length≤L
  | _,_,.hash x k => x.length≤L ∧ ∀ c,Fits L (k c)
  | _,_,.sign m k => m.length≤L ∧ ∀ o,Fits L (k o)

theorem projection_correct (S : Sampler) (h : Rq) (cs : List Rq)
    {s q : ℕ} (p : Program s q) : ∀ st,
    Dist.Same ((counted S h cs st p).map Prod.fst) (simulate S h cs st p) := by
  induction p with
  | done f =>
    intro st F
    simp only [counted,simulate,Dist.expect_map,Dist.expect_pure]
  | hash x k ih =>
    intro st F
    simp only [counted,simulate]
    cases hc : hashTargets cs x st with
    | none => simp only [Dist.expect_map,Dist.expect_pure]
    | some co =>
      have hh := ih co.1 (recordedHash x co.1 co.2) F
      simpa only [Dist.expect_map] using hh
  | sign m k ih =>
    intro st F
    simp only [counted,simulate,signSim,parse_frame,Dist.expect_map,Dist.expect_bind]
    apply Dist.expect_congr
    intro r
    cases hc : ROM.lookup (some r,m) (submitted m st).table with
    | some e => simp only [Dist.expect_pure]
    | none =>
      simp only [Dist.expect_map,Dist.expect_bind]
      apply Dist.expect_congr
      intro co
      simp only [programmedReply]
      have hh := ih (some (r,co.2))
        (recordedSign m (some (r,co.2))
          ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩) F
      simpa only [Dist.expect_map,submitted,ROM.submit] using hh

theorem counters_bound (S : Sampler) (h : Rq) (cs : List Rq) {s q : ℕ} (p : Program s q)
    (L : ℕ) (hfits : Fits L p) : ∀ st,
    Dist.All (counted S h cs st p) (fun out =>
      out.2.explicitHash≤q ∧ out.2.signQueries≤s ∧ out.2.nonceBits≤320*s ∧
      out.2.samplerBits≤S.bits*s ∧ out.2.submittedBytes≤L*(s+q)) := by
  induction p with
  | done f =>
    intro st
    apply Dist.all_pure
    dsimp
    exact ⟨Nat.zero_le _,Nat.zero_le _,Nat.zero_le _,Nat.zero_le _,Nat.zero_le _⟩
  | @hash s q x k ih =>
    intro st
    simp only [counted]
    split
    · apply Dist.all_pure
      have hlen := hfits.1
      dsimp
      constructor
      · omega
      constructor
      · omega
      constructor
      · omega
      constructor
      · omega
      · have hh : L≤L*(s+(q+1)) := by nlinarith
        omega
    next co hc =>
      have hh := ih co.1 (hfits.2 co.1) (recordedHash x co.1 co.2)
      intro sample
      have hb := hh sample
      let out := (counted S h cs (recordedHash x co.1 co.2) (k co.1)).out sample
      change 1+out.2.explicitHash≤q+1 ∧ 0+out.2.signQueries≤s ∧ 0+out.2.nonceBits≤320*s ∧
        0+out.2.samplerBits≤S.bits*s ∧ x.length+out.2.submittedBytes≤L*(s+(q+1))
      dsimp only [out]
      have hlen := hfits.1
      simp only [Nat.mul_add,Nat.mul_one] at *
      omega
  | @sign s q m k ih =>
    intro st
    simp only [counted]
    apply Dist.all_bind _ _ (fun _ => True)
    · intro x; trivial
    · intro r _
      split
      · apply Dist.all_pure
        have hlen := hfits.1
        dsimp
        simp only [Nat.mul_add,Nat.mul_one]
        have hh : L≤L*(s+1+q) := by nlinarith
        omega
      · apply Dist.all_bind _ _ (fun _ => True)
        · intro x; trivial
        · intro co _
          simp only [programmedReply]
          have hh := ih (some (r,co.2)) (hfits.2 (some (r,co.2)))
            (recordedSign m (some (r,co.2))
              ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩)
          intro sample
          have hb := hh sample
          let next : State := recordedSign m (some (r,co.2))
            ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩
          let out := (counted S h cs next (k (some (r,co.2)))).out sample
          change 0+out.2.explicitHash≤q ∧ 1+out.2.signQueries≤s+1 ∧ 320+out.2.nonceBits≤320*(s+1) ∧
            S.bits+out.2.samplerBits≤S.bits*(s+1) ∧ m.length+out.2.submittedBytes≤L*((s+1)+q)
          dsimp only [out,next]
          have hlen := hfits.1
          simp only [Nat.mul_add,Nat.mul_one] at *
          omega

end FT1536.Run2.ProgramResources
