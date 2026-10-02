import ONoneGeometry
import Run2.ConcreteReduction

/-! # Assembly — B5: the end-to-end assembled theorem skeleton

Window B5 of the run2 lane (`notes/PROMPT_B5_ASSEMBLY.md`; scope
`development/T12_1/END_TO_END_SCOPE.md` §1): the FINAL theorem declaration of
the project — the Section-1 bound stated and PROVED in the shape

    AdvEUF beta muKey A
      <= min 1 (epsColl beta + EventTransfer.phi ((1+e)^beta.qs - 1)
                  (AdvMT (beta.qh+1) (SigmaMath.muH muKey)
                     (Reduction.build beta A S)))
        + AdvPRG

— complete except its named premises. Deliverables of THIS module
(kernel-checked, zero unfinished-proof markers, standard axioms only):

1. **`end_to_end_assembled_theorem_statement`** — the assembled bound with the
   additive PRG term carried as `deltaPRG` (the outer bound carries the
   explicit PRG budget of D2 route (b); `hprg : AdvPRG tau ≤ deltaPRG` is the
   named seam premise). The certificate constant is
   `e = k^32 - 1 = SignLayerSupport.e2 k` — the SIGN sampler's chi-square
   constant of `FT1536.Run2.LocalJointCertificate` (`second ≤ 1 + e`,
   `notes/S3_E_PROVENANCE.md`), NOT a key-law constant.
2. **`end_to_end_assembled_theorem_statement_prgTerm`** — the display-literal
   variant whose additive term is `AdvPRG tau` itself (same arguments minus
   `deltaPRG`/`hprg`).
3. **`end_to_end_assembled_theorem_attemptFactor`** — the candidate-factor
   export through `ONoneGeometry.localJointCertificate_of_attemptFactor`
   (`e = SignLayerSupport.e2 SignLayerSupport.attemptFactor < 2^-32`, three
   B4 arguments since O-NONE is discharged unconditionally).
4. **`exists_assembled_reducer`** (the `exists_concrete_reducer`-style export;
   the reducer is `Reduction.build beta A S`) and
   **`assembled_hardness_substitution`** (the
   `concrete_hardness_substitution`-style corollary plugging an `AdvMT` bound
   `epsilon`).
5. **The named hybrid lemma of D2 route (b)** at the tape law, law-level over
   `Dist`/`Law` comparisons — "AdvEUF(real stream) ≤ AdvEUF(uniform tape) +
   deltaPRG": `tape_game_hop`, `tape_game_hop_delta` (the delta form),
   `tape_game_hop_abs` (two-sided) and `tape_game_hop_map_abs` (the
   `Law.uniform.map` seam of `Games.Sampler.code` at `S.code`).

## THE FINAL ARGUMENT LIST (binder order of
`end_to_end_assembled_theorem_statement`) — objects first, then EXACTLY the
named assumptions; this list IS the closing checklist of the whole project

* objects (witnesses/data, not assumptions): `SK`, `beta`, `muKey`, `A`,
  `S`, `jatt`, `k`, `tau`, `deltaPRG`, `keyIdent`;
* `hk : 1 ≤ k` — arithmetic side condition of the per-attempt factor (house
  style of `HacGlue.localJointCertificate_of_named_premises`; PROVED at the
  candidate factor `SignLayerSupport.attemptFactor_one_le`);
* `huc : UniformChallengeAt S` — NAMED PREMISE 1 (B3/X DELIVERED; the single
  ROM/RED assumption at the hash boundary, scope A2 named predicate
  `FT1536.VerifyBind.UniformChallenge`);
* `hshape : ReplyShapeAt S jatt` — NAMED PREMISE 2 (owner B1/source3; source
  binding of the attempt law, `SIGN_MAX_ATTEMPTS = 16`, emission
  `Extra/c/falcon-sign.c:3412-3418`);
* `hattempt : AttemptPointwiseAt jatt k` — NAMED PREMISE 3 (owner B4/3a: the
  two named analytic bounds `AttemptShape` + `AttemptWeights`; yields
  `e = k^32 - 1` through `HacGlue.localJointCertificate_of_named_premises_e`,
  or `ONoneGeometry.localJointCertificate_of_attemptFactor` at
  `k := SignLayerSupport.attemptFactor`);
* `hkey : keyIdent` — NAMED PREMISE 4 (owner B1.10): the emitted-key law
  identification. `keyIdent : Prop` is THE EXACT-TYPE SLOT of B1.10's
  `FT1536.Source3.KeygenSourceToFiber001.emitted_to_actual_fiber` (exact type
  transcribed in `source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_PLAN.md` §1;
  its carrier types `KeygenM0.Arguments`/`ProfileM0`/`LegalEntry`/
  `PinnedExec`/`ObservedEncoding`/`FullCertificateWitness` are source3's
  in-progress interface, so per the task the PREMISE TYPE ITSELF is taken as a
  named parameter and B1 delivers the content by instantiating `keyIdent`
  with that exact type). Its bite: it identifies `muKey` — and hence
  `SigmaMath.muH muKey`, the exact law the MT-ISIS hardness is assumed for —
  with the D1 CONDITIONAL emitted-key law `Law(attempt | Accept)` of the real
  C KeyGen (per-attempt conditioning; the `1/p_accept` accounting is resolved
  in `notes/S1_P_ACCEPT_FACTS.md`, cited, not redone);
* `hprg : AdvPRG tau ≤ deltaPRG` — NAMED PREMISE 5 (owner B2: the
  `Adv_PRG(ChaCha20)` accounting of `Extra/c/frng.c`, SHAKE-256 seeding, at
  the fair-tape vs real-stream seam of `Games.Sampler.code`). `tau` is the
  real-generator tape law on the consumed `S.bits` bits (object, not
  assumption); `AdvPRG tau = TV tau Law.uniform` is the explicit seam term.

Operational assumptions (item 6 of the task list) stay explicit WHERE THEY
BITE, with their `END_TO_END_SCOPE.md` §3 scope names:

* **A2 (seed uniformity)** bites at the hash boundary = `huc` (above).
* **A1 (no timing/attempt-count leakage from KeyGen; D1 refinement (ii),
  theorem-hypothesis rank)** bites at the key law = `hkey`. At MODEL scope it
  is discharged by construction and pinned by `a1_no_retry_interface`: the
  whole key material enters the game through the single atom
  `Dist.draw muKey`, and `Games.ClassicalAdversary.code` receives only
  `(Rq, coins)` — no retry trace exists in the interface. The deployment-side
  claim (a real adversary observing restarts) is OUT OF SCOPE here — recorded,
  not smoothed over.
* **A5 (machine model scope: LP64 word semantics with wrapping as modeled)**
  bites at the source execution premise INSIDE the exact type of
  `emitted_to_actual_fiber` (`ProfileM0`/`LegalEntry`/`PinnedExec` of PLAN
  §1) = inside `hkey`.
* **A3 (`verdict = Relation.Verify`) and A4 (serialization round-trip)** bite
  at the BYTE BRIDGE — which is explicitly NOT a theorem argument (established
  B4 boundary, `notes/B4_SYNTHESIS.md`: open, recorded). Their content is
  owed by rung B3.

Not theorem arguments (open, recorded, never assumed): the byte bridge (any
real-sampler mass outside the `emit` image makes chi² infinite —
`SignLayerSupport.chi2_top_of_out_of_support`) and the additive-error mass
floor (`Adv_PRG`-shaped terms do not fit the multiplicative
`AttemptPointwise` shape without a mass floor `mu ≤ (trial A c).mass (some
z)`; the PRG term therefore stays ADDITIVE in the outer bound and never
enters `e`).

Consumption chain of the proof (nothing else): the named B4 certificate
`HacGlue.localJointCertificate_of_named_premises_e` (O-NONE discharged
unconditionally by `ONoneGeometry.hone`) at `e = SignLayerSupport.e2 k`, then
the assembled conditional reduction `Run2.ConcreteReduction`
(`concrete_euf_cma_to_mt_isis` over `Reduction.build`), then the carried PRG
budget `deltaPRG` (`hprg` pins it above the seam `AdvPRG tau`, in particular
`0 ≤ deltaPRG`). Standard axioms only.
-/

namespace FT1536.Assembly
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry FT1536.Relation
open FT1536.Run2

/-! ## 0. Named interfaces (defs first) -/

/-- Statistical distance of two laws (the seam quantity of the D2 route (b)
game hop). -/
noncomputable def TV {ξ : Type} [Fintype ξ] (p q : Law ξ) : ℝ :=
  (∑ x, |p.mass x - q.mass x|) / 2

/-- THE explicit `AdvPRG` additive term of the Section-1 bound: the seam
advantage of the tape law `tau` against the FAIR uniform tape `Law.uniform`
of `Games.Sampler.code`. At the real system `tau` is the ChaCha20 stream of
`Extra/c/frng.c` (SHAKE-256 seeding) projected to the consumed bits; the task
notation `AdvPRG S` is this quantity at `tau : Law (Fin S.bits → Bool)` (the
tie to the sampler is in the tape width). Identification of `tau` with the C
generator's output law is the open byte/PRNG bridge (B2) — the QUANTITY is
defined here at the law level and bounded by the named premise `hprg`. -/
noncomputable def AdvPRG {ξ : Type} [Fintype ξ] [Nonempty ξ] (tau : Law ξ) : ℝ :=
  TV tau (Law.uniform)

/-- The sampler's per-call law under tape law `tau` — the D2 route-(b) seam at
one fresh signing point: `tau.map (S.code h st m r)`. At the fair tape
`tau = Law.uniform` this is `FT1536.Run2.samplerLaw S h st m r`
(`Law.uniform.map`) definitionally. -/
noncomputable def samplerLawAt (S : Sampler) (tau : Law (Fin S.bits → Bool))
    (h : FT1536.Relation.Rq) (st : FT1536.Run2.State) (m : FT1536.Run2.Bytes)
    (r : FT1536.Run2.Nonce) : Law (Rq × Option BoxVec) :=
  tau.map (S.code h st m r)

theorem samplerLawAt_uniform {S : Sampler} (h : FT1536.Relation.Rq)
    (st : FT1536.Run2.State) (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce) :
    samplerLawAt S (Law.uniform : Law (Fin S.bits → Bool)) h st m r
      = FT1536.Run2.samplerLaw S h st m r := rfl

/-! ## 1. The D2 route-(b) seam: the named law-level hybrid lemma -/

theorem advPRG_nonneg {ξ : Type} [Fintype ξ] [Nonempty ξ] (tau : Law ξ) :
    0 ≤ AdvPRG tau := by
  unfold AdvPRG TV
  exact div_nonneg (sum_nonneg fun x _ => abs_nonneg _) (by norm_num)

/-- Expectation of a straight draw (definitionally the law sum). -/
theorem expect_draw {ξ : Type} [Fintype ξ] (p : Law ξ) (f : ξ → ℝ) :
    (Dist.draw p).expect f = ∑ x, p.mass x * f x := rfl

/-- Event probability of a one-draw `Dist` computation as a law sum — the
`Dist`/`Law` comparison shape of the game hop. -/
theorem bind_draw_event {ξ α : Type} [Fintype ξ] [Fintype α]
    (p : Law ξ) (F : ξ → FT1536.Run2.Dist α) (E : α → Prop) :
    ((Dist.draw p).bind F).event E = ∑ x, p.mass x * (F x).event E := by
  classical
  rw [StoppingLoss.event_bind]
  exact expect_draw p (fun x => (F x).event E)

/-- `Dist.map` is `Dist.bind` of point masses (expectation-level). -/
theorem map_eq_bind_pure {α β : Type} (q : FT1536.Run2.Dist α) (g : α → β) :
    Dist.Same (q.map g) (q.bind fun x => Dist.pure (g x)) := by
  intro f
  rw [Dist.expect_map, Dist.expect_bind]
  exact Dist.expect_congr q (fun x => f (g x)) (fun x => (Dist.pure (g x)).expect f)
    (fun x => (Dist.expect_pure (g x) f).symm)

/-- THE hybrid lemma in its two-sided law-level form — the standard game-hop
shape at the tape law, over `Dist`/`Law` comparisons: replacing the tape law
`tau` of the single tape draw by the fair `Law.uniform` moves the win event of
ANY downstream `Dist` computation by at most `AdvPRG tau`. -/
theorem tape_game_hop_abs {ξ α : Type} [Fintype ξ] [Nonempty ξ] [Fintype α]
    (tau : Law ξ) (F : ξ → FT1536.Run2.Dist α) (E : α → Prop) :
    |((Dist.draw tau).bind F).event E - ((Dist.draw (Law.uniform : Law ξ)).bind F).event E|
      ≤ AdvPRG tau := by
  classical
  have hw : ∀ x : ξ, |(F x).event E - 1 / 2| ≤ 1 / 2 := by
    intro x
    have h0 : 0 ≤ (F x).event E := Dist.event_nonneg (F x) E
    have h1 : (F x).event E ≤ 1 := Dist.event_le_one (F x) E
    exact abs_le.mpr ⟨by linarith, by linarith⟩
  have hz : (∑ x, (tau.mass x - (Law.uniform : Law ξ).mass x) * ((F x).event E - 1 / 2))
      = ∑ x, (tau.mass x - (Law.uniform : Law ξ).mass x) * (F x).event E := by
    simp_rw [mul_sub]
    rw [Finset.sum_sub_distrib, ← Finset.sum_mul]
    have hsum : (∑ x, (tau.mass x - (Law.uniform : Law ξ).mass x)) = 0 := by
      rw [Finset.sum_sub_distrib, tau.total, (Law.uniform : Law ξ).total]
      ring
    rw [hsum]
    ring
  have hle : |∑ x, (tau.mass x - (Law.uniform : Law ξ).mass x) * ((F x).event E - 1 / 2)|
      ≤ AdvPRG tau :=
    calc |∑ x, (tau.mass x - (Law.uniform : Law ξ).mass x) * ((F x).event E - 1 / 2)|
        ≤ ∑ x, |(tau.mass x - (Law.uniform : Law ξ).mass x) * ((F x).event E - 1 / 2)| :=
        Finset.abs_sum_le_sum_abs _ _
      _ = ∑ x, |tau.mass x - (Law.uniform : Law ξ).mass x| * |(F x).event E - 1 / 2| := by
        simp_rw [abs_mul]
      _ ≤ ∑ x, |tau.mass x - (Law.uniform : Law ξ).mass x| * (1 / 2) :=
        Finset.sum_le_sum fun x _ =>
          mul_le_mul_of_nonneg_left (hw x) (abs_nonneg (tau.mass x - (Law.uniform : Law ξ).mass x))
      _ = ∑ x, |tau.mass x - (Law.uniform : Law ξ).mass x| / 2 := by
        simp_rw [mul_one_div]
      _ = (∑ x, |tau.mass x - (Law.uniform : Law ξ).mass x|) / 2 := by
        rw [← Finset.sum_div]
      _ = AdvPRG tau := rfl
  rw [hz] at hle
  rw [bind_draw_event, bind_draw_event]
  have heq : (∑ x, (tau.mass x - (Law.uniform : Law ξ).mass x) * (F x).event E)
      = ∑ x, tau.mass x * (F x).event E
        - ∑ x, (Law.uniform : Law ξ).mass x * (F x).event E := by
    simp_rw [sub_mul]
    rw [Finset.sum_sub_distrib]
  rw [← heq]
  exact hle

/-- THE hybrid lemma, game form ("AdvEUF(real stream) ≤ AdvEUF(uniform tape)
+ AdvPRG"): the tape-driven side of any one-tape-draw `Dist` computation is at
most `AdvPRG tau` above the fair-tape side. -/
theorem tape_game_hop {ξ α : Type} [Fintype ξ] [Nonempty ξ] [Fintype α]
    (tau : Law ξ) (F : ξ → FT1536.Run2.Dist α) (E : α → Prop) :
    ((Dist.draw tau).bind F).event E
      ≤ ((Dist.draw (Law.uniform : Law ξ)).bind F).event E + AdvPRG tau := by
  have h := tape_game_hop_abs tau F E
  have hl : ((Dist.draw tau).bind F).event E
      - ((Dist.draw (Law.uniform : Law ξ)).bind F).event E
      ≤ |((Dist.draw tau).bind F).event E
        - ((Dist.draw (Law.uniform : Law ξ)).bind F).event E| := le_abs_self _
  linarith

/-- THE named hybrid lemma of D2 route (b) in its delta form —
`AdvEUF(real stream) ≤ AdvEUF(uniform tape) + deltaPRG` at the tape law: under
the named seam premise `hprg : AdvPRG tau ≤ deltaPRG` the outer bound carries
`deltaPRG`. -/
theorem tape_game_hop_delta {ξ α : Type} [Fintype ξ] [Nonempty ξ] [Fintype α]
    (tau : Law ξ) (F : ξ → FT1536.Run2.Dist α) (E : α → Prop) {deltaPRG : ℝ}
    (hdelta : AdvPRG tau ≤ deltaPRG) :
    ((Dist.draw tau).bind F).event E
      ≤ ((Dist.draw (Law.uniform : Law ξ)).bind F).event E + deltaPRG := by
  have h := tape_game_hop tau F E
  linarith

/-- The `Law.uniform.map` seam at `Games.Sampler.code`: for `g = S.code h st m
r` the mapped-tape computation on the real tape law `tau` (`samplerLawAt`) is
within `AdvPRG tau` of the same computation on the fair uniform tape
(`samplerLaw` = `Law.uniform.map` of `Run2/LawBinding.lean`). -/
theorem tape_game_hop_map_abs {ξ α : Type} [Fintype ξ] [Nonempty ξ] [Fintype α]
    [DecidableEq α] (tau : Law ξ) (g : ξ → α) (E : α → Prop) :
    |((Dist.draw tau).map g).event E
      - ((Dist.draw (Law.uniform : Law ξ)).map g).event E| ≤ AdvPRG tau := by
  have hL : ((Dist.draw tau).map g).event E
      = ((Dist.draw tau).bind fun x => Dist.pure (g x)).event E :=
    Dist.same_event _ _ (map_eq_bind_pure (Dist.draw tau) g) E
  have hR : ((Dist.draw (Law.uniform : Law ξ)).map g).event E
      = ((Dist.draw (Law.uniform : Law ξ)).bind fun x => Dist.pure (g x)).event E :=
    Dist.same_event _ _ (map_eq_bind_pure (Dist.draw (Law.uniform : Law ξ)) g) E
  rw [hL, hR]
  exact tape_game_hop_abs tau (fun x => Dist.pure (g x)) E

/-! ## 2. The exact shape of `e` and the A1 model-scope pin -/

/-- `e = k^32 - 1` (display identity of the task): the certificate constant is
the SIGN sampler's chi-square constant `SignLayerSupport.e2 k` of
`FT1536.Run2.LocalJointCertificate` (`second ≤ 1 + e`), NOT a key-law
constant (S3 correction, `notes/S3_E_PROVENANCE.md`). -/
theorem e2_eq (k : ℝ) : SignLayerSupport.e2 k = k ^ 32 - 1 := by
  show (k ^ 16) ^ 2 - 1 = k ^ 32 - 1
  have h : (k ^ 16) ^ 2 = k ^ 32 := by
    rw [← pow_mul, show (16 * 2 : ℕ) = 32 by norm_num]
  rw [h]

/-- THE numeric form of `e` at the candidate factor: `e = attemptFactor^32 - 1`
and `e < 2^-32` (`SignLayerSupport.e2_attemptFactor_lt`). -/
theorem e_at_attemptFactor :
    SignLayerSupport.e2 SignLayerSupport.attemptFactor
        = SignLayerSupport.attemptFactor ^ 32 - 1 ∧
      SignLayerSupport.e2 SignLayerSupport.attemptFactor < 1 / 4294967296 :=
  ⟨e2_eq SignLayerSupport.attemptFactor, SignLayerSupport.e2_attemptFactor_lt⟩

/-- A1 (scope name "no timing/attempt-count leakage from KeyGen",
`END_TO_END_SCOPE.md` §3; D1 refinement (ii)) AT MODEL SCOPE: the entire key
material enters `Games.runEUF` through the single atom `Dist.draw muKey`, and
the adversary's code receives only the emitted public key and its own coins —
the game interface exposes no KeyGen attempt/retry trace. This pins the model
scope of A1 exactly; the DEPLOYMENT-side claim (a real adversary observing
restarts would see secret-dependent leakage) is out of scope and stays
recorded. -/
theorem a1_no_retry_interface {SK : Type} [Fintype SK] (beta : Budget)
    (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta) :
    Dist.Same (Games.runEUF beta muKey A)
      ((Dist.draw muKey).bind fun key =>
        (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
          Dist.bind (Games.honest key.2 initial false (A.code key.2 coins))
            (Games.finishHonest key.2)) := by
  intro f
  rfl

/-! ## 3. The assembled theorem and its exports -/

/-- THE end-to-end assembled theorem skeleton (the declaration the 2026-09-30
audit found missing): the Section-1 bound of
`development/T12_1/END_TO_END_SCOPE.md`,

    AdvEUF beta muKey A
      <= min 1 (epsColl beta + EventTransfer.phi ((1+e)^beta.qs - 1)
                  (AdvMT (beta.qh+1) (SigmaMath.muH muKey)
                     (Reduction.build beta A S)))
        + AdvPRG

with `e = k^32 - 1` (the SIGN sampler's chi-square constant, NOT a key-law
constant) and the additive PRG seam carried as `deltaPRG` per
`hprg : AdvPRG tau ≤ deltaPRG`.

THE EXACT ARGUMENT LIST, in binder order (objects first, then the named
assumptions; see the module docstring for owners): objects `SK`, `beta`,
`muKey`, `A`, `S`, `jatt`, `k`, `tau`, `deltaPRG`, `keyIdent`; `hk : 1 ≤ k`
(arithmetic side condition, proved at the candidate factor); `huc :
UniformChallengeAt S`; `hshape : ReplyShapeAt S jatt`; `hattempt :
AttemptPointwiseAt jatt k`; `hkey : keyIdent` (the emitted-key law
identification, exact type = B1.10 `emitted_to_actual_fiber`, PLAN §1); `hprg :
AdvPRG tau ≤ deltaPRG`. NOTHING ELSE is assumed. A1/A5 bite inside `hkey`
(cited scope names), A2 is `huc`, A3/A4 bite at the byte bridge which is an
open recorded seam and NOT an argument. -/
theorem end_to_end_assembled_theorem_statement {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (jatt : HacGlue.AttemptFamily) (k : ℝ)
    (tau : Law (Fin S.bits → Bool)) (deltaPRG : ℝ) (keyIdent : Prop)
    (hk : 1 ≤ k)
    (huc : HacGlue.UniformChallengeAt S)
    (hshape : HacGlue.ReplyShapeAt S jatt)
    (hattempt : HacGlue.AttemptPointwiseAt jatt k)
    (hkey : keyIdent)
    (hprg : AdvPRG tau ≤ deltaPRG) :
    Games.AdvEUF beta muKey A ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1)
          (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
            (Reduction.build beta A S)))
      + deltaPRG := by
  have gate : keyIdent → Games.AdvEUF beta muKey A ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1)
          (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
            (Reduction.build beta A S)))
      + deltaPRG := by
    intro _hkey
    have hcert : LocalJointCertificate S (SignLayerSupport.e2 k) :=
      HacGlue.localJointCertificate_of_named_premises_e S k hk jatt huc hshape hattempt
        ONoneGeometry.hone
    have hbase := concrete_euf_cma_to_mt_isis beta muKey A S (SignLayerSupport.e2 k) hcert
    rw [e2_eq] at hbase
    have hseam : 0 ≤ deltaPRG := (advPRG_nonneg tau).trans hprg
    exact hbase.trans (le_add_of_nonneg_right hseam)
  exact gate hkey

/-- Display-literal variant: the additive term carried as `AdvPRG tau` itself
("Model `AdvPRG` as an explicit additive term"). Same argument list as
`end_to_end_assembled_theorem_statement` MINUS `deltaPRG`/`hprg` — nothing is
assumed beyond the other named premises. -/
theorem end_to_end_assembled_theorem_statement_prgTerm {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (jatt : HacGlue.AttemptFamily) (k : ℝ)
    (tau : Law (Fin S.bits → Bool)) (keyIdent : Prop)
    (hk : 1 ≤ k)
    (huc : HacGlue.UniformChallengeAt S)
    (hshape : HacGlue.ReplyShapeAt S jatt)
    (hattempt : HacGlue.AttemptPointwiseAt jatt k)
    (hkey : keyIdent) :
    Games.AdvEUF beta muKey A ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1)
          (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
            (Reduction.build beta A S)))
      + AdvPRG tau :=
  end_to_end_assembled_theorem_statement beta muKey A S jatt k tau (AdvPRG tau) keyIdent hk
    huc hshape hattempt hkey (le_refl (AdvPRG tau))

/-- THE candidate-factor export through
`ONoneGeometry.localJointCertificate_of_attemptFactor`: at
`k = SignLayerSupport.attemptFactor` the argument list drops the arithmetic
side condition (`SignLayerSupport.attemptFactor_one_le`, proved) and the error
is `e = attemptFactor^32 - 1 = SignLayerSupport.e2 SignLayerSupport.attemptFactor < 2^-32`
(`e_at_attemptFactor`). The remaining named inputs are EXACTLY `huc`, `hshape`,
`hattempt`, `hkey`, `hprg`. -/
theorem end_to_end_assembled_theorem_attemptFactor {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (jatt : HacGlue.AttemptFamily)
    (tau : Law (Fin S.bits → Bool)) (deltaPRG : ℝ) (keyIdent : Prop)
    (huc : HacGlue.UniformChallengeAt S)
    (hshape : HacGlue.ReplyShapeAt S jatt)
    (hattempt : HacGlue.AttemptPointwiseAt jatt SignLayerSupport.attemptFactor)
    (hkey : keyIdent)
    (hprg : AdvPRG tau ≤ deltaPRG) :
    Games.AdvEUF beta muKey A ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi
          ((1 + (SignLayerSupport.attemptFactor ^ 32 - 1)) ^ beta.qs - 1)
          (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
            (Reduction.build beta A S)))
      + deltaPRG :=
  end_to_end_assembled_theorem_statement beta muKey A S jatt SignLayerSupport.attemptFactor tau
    deltaPRG keyIdent SignLayerSupport.attemptFactor_one_le huc hshape hattempt hkey hprg

/-- The `exists_concrete_reducer`-style export of the assembled bound: the
MT-ISIS adversary is EXACTLY `Reduction.build beta A S` (existence with the
defining equation, nothing existential about the reducer). Same argument list
as `end_to_end_assembled_theorem_statement`. -/
theorem exists_assembled_reducer {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (jatt : HacGlue.AttemptFamily) (k : ℝ)
    (tau : Law (Fin S.bits → Bool)) (deltaPRG : ℝ) (keyIdent : Prop)
    (hk : 1 ≤ k)
    (huc : HacGlue.UniformChallengeAt S)
    (hshape : HacGlue.ReplyShapeAt S jatt)
    (hattempt : HacGlue.AttemptPointwiseAt jatt k)
    (hkey : keyIdent)
    (hprg : AdvPRG tau ≤ deltaPRG) :
    ∃ B : Games.MTAdversary (beta.qh + 1),
      B = Reduction.build beta A S ∧
      Games.AdvEUF beta muKey A ≤
        min 1 (StoppingLoss.epsColl beta +
          EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1)
            (Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey) B))
        + deltaPRG :=
  ⟨Reduction.build beta A S, rfl,
    end_to_end_assembled_theorem_statement beta muKey A S jatt k tau deltaPRG keyIdent hk
      huc hshape hattempt hkey hprg⟩

/-- The `concrete_hardness_substitution`-style corollary: plug an `AdvMT` bound
`epsilon ≤ 1` for the concrete reducer. Same argument list as
`end_to_end_assembled_theorem_statement` plus the hardness plug. -/
theorem assembled_hardness_substitution {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (jatt : HacGlue.AttemptFamily) (k : ℝ)
    (tau : Law (Fin S.bits → Bool)) (deltaPRG : ℝ) (keyIdent : Prop) (epsilon : ℝ)
    (hk : 1 ≤ k)
    (huc : HacGlue.UniformChallengeAt S)
    (hshape : HacGlue.ReplyShapeAt S jatt)
    (hattempt : HacGlue.AttemptPointwiseAt jatt k)
    (hkey : keyIdent)
    (hprg : AdvPRG tau ≤ deltaPRG)
    (hepsilon : epsilon ≤ 1)
    (hardness : Games.AdvMT (beta.qh + 1) (SigmaMath.muH muKey)
      (Reduction.build beta A S) ≤ epsilon) :
    Games.AdvEUF beta muKey A ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1) epsilon)
      + deltaPRG := by
  have gate : keyIdent → Games.AdvEUF beta muKey A ≤
      min 1 (StoppingLoss.epsColl beta +
        EventTransfer.phi ((1 + (k ^ 32 - 1)) ^ beta.qs - 1) epsilon)
      + deltaPRG := by
    intro _hkey
    have hcert : LocalJointCertificate S (SignLayerSupport.e2 k) :=
      HacGlue.localJointCertificate_of_named_premises_e S k hk jatt huc hshape hattempt
        ONoneGeometry.hone
    have hbase := concrete_hardness_substitution beta muKey A S (SignLayerSupport.e2 k) epsilon
      hcert hepsilon hardness
    rw [e2_eq] at hbase
    have hseam : 0 ≤ deltaPRG := (advPRG_nonneg tau).trans hprg
    exact hbase.trans (le_add_of_nonneg_right hseam)
  exact gate hkey

end FT1536.Assembly
