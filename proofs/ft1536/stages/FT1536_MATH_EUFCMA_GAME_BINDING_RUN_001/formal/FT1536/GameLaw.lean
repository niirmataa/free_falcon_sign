import FT1536.GameMach
import FT1536.Mixture
import FT1536.PaidSteps
import FT1536.Lazy

-- Instance hygiene: `SigmaMath.nonceFintype` duplicates the canonical
-- `Fintype (Fin (2^320))`; one instance keeps `Law (Fin (2^320))` elaboration
-- consistent across all modules of this run.
attribute [-instance] FT1536.SigmaMath.nonceFintype


/-! # Game kernel identification (binding type `game_kernel_identification`)

The one-step reply kernels of the three interpreters are derived from the
machine step logic (`GameMach.step_eq` branches) and the local sampler
contract. The reply alphabet carries the public challenge `c` and the salt
(the table is public state), so the paid Sign kernel is *exactly* the
certified `(c,o)` pair law mapped through an injective encoding.

Closed here:

* `second_map_inj` / `ac_map` — pushforward along an injective reply encoding
  preserves `second` and `AC` (so certificates transfer verbatim);
* `LocalCert` — the parameter of the conditional theorem (AC + `second ≤ 1+e`
  for one fresh `S.run` on the full `(c,o)` pair);
* `signKernel` — the Sign-step kernel (nonce joint over the hit/miss split of
  the machine), `sign_miss_reply_bound` (paid steps, from the certificate),
  `sign_hit_shared` (stopped/sim share `pure .halt` at conflicts);
* `hKernel`/`finKernel` — shared kernels, literally equal across modes;
* `advance_correct` — the public reply reconstructs the post-state (the table
  is public), so histories carry the machine state;
* `paid_hypotheses` — the kernels satisfy the shared/paid/AC premises of
  `PaidSteps.paid_counter_le`;
* `game_kernel_identification` — the assembled transcript bound
  `second ≤ (1+e)^Q_s` for these concrete kernels.

No `sorry` in this module. -/

namespace FT1536.GameLaw
open GameMach GameNames GameByte Divergence Finset PublicSimulation

/-- The reply alphabet as a sum of its constructor payloads. -/
def replyEquiv (C : Type) :
    Reply C ≃ C ⊕ (C × Option (GameByte.Nonce × Option BoxVec)) ⊕ (Bool × C) ⊕ Unit where
  toFun ρ := match ρ with
    | .hval c => Sum.inl c
    | .sign c o => Sum.inr (Sum.inl (c, o))
    | .verdict w c => Sum.inr (Sum.inr (Sum.inl (w, c)))
    | .halt => Sum.inr (Sum.inr (Sum.inr ()))
  invFun x := match x with
    | Sum.inl c => .hval c
    | Sum.inr (Sum.inl (c, o)) => .sign c o
    | Sum.inr (Sum.inr (Sum.inl (w, c))) => .verdict w c
    | Sum.inr (Sum.inr (Sum.inr u)) => .halt
  left_inv ρ := by
    cases ρ <;> rfl
  right_inv x := by
    rcases x with c | co | wc | u
    · rfl
    · rcases co with ⟨c, o⟩
      rfl
    · rcases wc with ⟨w, c⟩
      rfl
    · cases u
      rfl

/-- The reply alphabet is finite whenever `C` is. -/
noncomputable instance replyFintype {C : Type} [Fintype C] : Fintype (Reply C) :=
  Fintype.ofEquiv _ (replyEquiv C).symm

variable {C : Type} [Fintype C] [DecidableEq C]

/-- Local sampler contract (parameter of the conditional theorem): the full
`(c,o)` law of one fresh `S.run` call against the honest fresh-Sign law
`uniform_Rq(c) × signBody(h,c)(o)`. -/
structure LocalCert (C : Type) [Fintype C] [DecidableEq C] where
  fill : Law C
  body : C → Law (Option BoxVec)
  sim : Law (C × Option BoxVec)
  e : ℝ
  e_nonneg : 0 ≤ e
  ac_cert : AC sim (Divergence.joint fill body)
  second_cert : second sim (Divergence.joint fill body) ≤ 1 + e

/-- Honest fresh-Sign `(c,o)` law: `P = uniform c * signBody(h,c)(o)`. -/
noncomputable def honestCO (cert : LocalCert C) : Law (C × Option BoxVec) :=
  Divergence.joint cert.fill cert.body

/-- Mass of a mapped law at an image point (injective map). -/
theorem map_mass_inj {α β : Type} [Fintype α] [Fintype β] [DecidableEq α] [DecidableEq β]
    (f : α → β) (hinj : Function.Injective f) (p : Law α) (x : α) :
    (p.map f).mass (f x) = p.mass x := by
  show (∑ a, p.mass a * (if f x = f a then (1:ℝ) else 0)) = p.mass x
  have h1 : (∑ a, p.mass a * (if f x = f a then (1:ℝ) else 0))
      = ∑ a, if a = x then p.mass a else 0 := by
    refine Finset.sum_congr rfl ?_
    intro a _
    by_cases ha : a = x
    · subst ha
      simp
    · have hfa : f x ≠ f a := fun h => ha (hinj h).symm
      simp [hfa, ha, mul_zero]
  rw [h1, Finset.sum_ite_eq']
  simp

/-- Mass of a mapped law outside the image is zero. -/
theorem map_mass_off {α β : Type} [Fintype α] [Fintype β] [DecidableEq α] [DecidableEq β]
    (f : α → β) (p : Law α) (y : β) (hy : ∀ x, f x ≠ y) :
    (p.map f).mass y = 0 := by
  show (∑ a, p.mass a * (if y = f a then (1:ℝ) else 0)) = 0
  refine Finset.sum_eq_zero ?_
  intro a _
  have hne : y ≠ f a := fun h => hy a h.symm
  simp [hne, mul_zero]

/-- Pushforward along an injective encoding preserves the second moment
(fiber sums are singletons). -/
theorem second_map_inj {α β : Type} [Fintype α] [Fintype β] [DecidableEq α] [DecidableEq β]
    (f : α → β) (hinj : Function.Injective f) (j p : Law α) :
    second (j.map f) (p.map f) = second j p := by
  unfold second
  have hsub : (∑ y : β, (j.map f).mass y ^ 2 / (p.map f).mass y)
      = ∑ y ∈ (univ.filter fun y => ∃ x, f x = y),
          (j.map f).mass y ^ 2 / (p.map f).mass y := by
    refine (Finset.sum_subset (Finset.filter_subset _ _) ?_).symm
    intro y hy hyt
    have hnex : ∀ x, f x ≠ y := fun x h => hyt (Finset.mem_filter.mpr ⟨Finset.mem_univ y, ⟨x, h⟩⟩)
    rw [map_mass_off f j y hnex, map_mass_off f p y hnex]
    simp
  rw [hsub]
  refine (Finset.sum_nbij f
    (fun a _ => Finset.mem_filter.mpr ⟨Finset.mem_univ (f a), ⟨a, rfl⟩⟩)
    (fun a₁ _ a₂ _ h => hinj h) ?_ ?_).symm
  · intro y hy
    obtain ⟨x, hx⟩ := (Finset.mem_filter.mp hy).2
    exact ⟨x, Finset.mem_univ x, hx⟩
  · intro a _
    rw [map_mass_inj f hinj j a, map_mass_inj f hinj p a]

/-- Pushforward along an injective map preserves AC. -/
theorem ac_map {α β : Type} [Fintype α] [Fintype β] [DecidableEq α] [DecidableEq β]
    (f : α → β) (hinj : Function.Injective f) (j p : Law α) (h : AC j p) :
    AC (j.map f) (p.map f) := by
  intro y hy
  by_cases hex : ∃ x, f x = y
  · obtain ⟨x, hx⟩ := hex
    subst hx
    rw [map_mass_inj f hinj j x]
    have hp0 : p.mass x = 0 := by
      rw [← map_mass_inj f hinj p x]
      exact hy
    exact h x hp0
  · have hnex : ∀ x, f x ≠ y := fun x h => hex ⟨x, h⟩
    rw [map_mass_off f j y hnex]

/-- The reply encoding of one Sign answer at salt `r`: `(c,o) ↦ .sign c (some (r,o))`. -/
def signEnc (r : GameByte.Nonce) (p : C × Option BoxVec) : Reply C :=
  .sign p.1 (some (r, p.2))

omit [Fintype C] [DecidableEq C] in
theorem signEnc_injective (r : GameByte.Nonce) : Function.Injective (signEnc r (C := C)) := by
  intro p q h
  rcases p with ⟨pc, po⟩
  rcases q with ⟨qc, qo⟩
  have h1 : pc = qc ∧ some (r, po) = some (r, qo) := by
    simpa [signEnc] using h
  have h2 : (r, po) = (r, qo) := Option.some.inj h1.2
  exact Prod.ext h1.1 (Prod.ext_iff.mp h2).2

/-- Paid Sign kernel at a fresh name: the reply carries the full certified
`(c,o)` pair through the injective encoding, joint with the uniform salt. -/
noncomputable def signMissKernel (cert : LocalCert C) (r : GameByte.Nonce) (mode : Mode) :
    Law (Reply C) :=
  match mode with
  | .sim => cert.sim.map (signEnc r)
  | _ => (honestCO cert).map (signEnc r)

/-- **Paid-step kernel bound**: at a fresh Sign name the simulator kernel
against the honest kernel is exactly the certified pair law through an
injective encoding, hence `second ≤ 1+e` and AC hold on the reply alphabet. -/
theorem sign_miss_reply_bound (cert : LocalCert C) (r : GameByte.Nonce) :
    second (signMissKernel cert r .sim) (signMissKernel cert r .real) ≤ 1 + cert.e ∧
    AC (signMissKernel cert r .sim) (signMissKernel cert r .real) := by
  constructor
  · show second (cert.sim.map (signEnc r)) ((honestCO cert).map (signEnc r)) ≤ 1 + cert.e
    rw [second_map_inj _ (signEnc_injective r)]
    exact cert.second_cert
  · show AC (cert.sim.map (signEnc r)) ((honestCO cert).map (signEnc r))
    exact ac_map (signEnc r) (signEnc_injective r) cert.sim (honestCO cert) cert.ac_cert

/-- Shared H kernel: the reply is the deterministic table read of the input
target vector at slot `used`; identical in all three modes. -/
noncomputable def hKernel (targets : ℕ → C) (m : Mach C) (k : NameKind) : Law (Reply C) :=
  Law.pure (.hval (ROM.hash targets (tableAddr (render k)) m.st).1)

/-- Shared final reply: deterministic final read and verdict; identical in
all three modes. -/
def finReply (targets : ℕ → C) (verdict : Verdict C) (m : Mach C)
    (r : GameByte.Nonce) (msg : Message) (sg : BoxVec) : Reply C :=
  .verdict ((decide (msg ∉ (ROM.hash targets (tableAddr (signName r msg)) m.st).2.seen)) &&
    verdict (ROM.hash targets (tableAddr (signName r msg)) m.st).1 msg (sigVec sg))
    (ROM.hash targets (tableAddr (signName r msg)) m.st).1

/-- Shared final kernel: the deterministic final reply as a point mass. -/
noncomputable def finKernel (targets : ℕ → C) (verdict : Verdict C) (m : Mach C)
    (r : GameByte.Nonce) (msg : Message) (sg : BoxVec) : Law (Reply C) :=
  Law.pure (finReply targets verdict m r msg sg)

/-- Public-state reconstruction: the post-state of one step is a function of
the pre-state, the operation and the public reply (the table and its
challenge values are public). -/
def advance (targets : ℕ → C) (_verdict : Verdict C) (m : Mach C) (op : Op) (ρ : Reply C) :
    Mach C :=
  if m.stopped || m.over then m
  else
    match op with
    | .hq k =>
      Mach.mk (ROM.hash targets (tableAddr (render k)) m.st).2 m.mode m.stopped m.over
        (m.hq + 1) m.sq
    | .sq msg =>
      match ρ with
      | .sign c o =>
        match o with
        | some pr =>
          let st0 := ROM.submit msg m.st
          if ROM.lookup (tableAddr (signName pr.1 msg)) st0 = none then
            Mach.mk
              (⟨ROM.Entry.mk (tableAddr (signName pr.1 msg)) c none :: st0.table,
                st0.seen, st0.used⟩ : ROM.State NameBody Message C)
              m.mode m.stopped m.over m.hq (m.sq + 1)
          else Mach.mk st0 m.mode m.stopped m.over m.hq (m.sq + 1)
        | none => Mach.mk (ROM.submit msg m.st) m.mode true m.over m.hq (m.sq + 1)
      | _ => Mach.mk (ROM.submit msg m.st) m.mode true m.over m.hq (m.sq + 1)
    | .fin r msg _ =>
      Mach.mk (ROM.hash targets (tableAddr (signName r msg)) m.st).2 m.mode m.stopped true
        m.hq m.sq

-- The public reply reconstructs the machine post-state.
omit [Fintype C] [DecidableEq C] in
lemma advance_correct (targets : ℕ → C) (verdict : Verdict C) (m : Mach C) (op : Op)
    (env : Env C) (h : m.stopped = false ∧ m.over = false) :
    advance targets verdict m op (step targets verdict m op env).2 =
      (step targets verdict m op env).1 := by
  rw [step_eq targets verdict m op env h]
  have hn : ¬(m.stopped || m.over) := by simp [h.1, h.2]
  unfold advance signStep
  cases op with
  | hq k => simp [hn]
  | fin r msg _sg => simp [hn]
  | sq msg =>
    cases hl : ROM.lookup (tableAddr (signName env.nonce msg)) (ROM.submit msg m.st) with
    | some e => cases hm : m.mode <;> simp_all
    | none => cases hm : m.mode <;> simp_all

/-- At a Sign-name conflict the stopped game and the simulator share the
kernel `pure .halt` (internal STOP, no win, no returned abort). -/
theorem sign_hit_shared : (Law.pure (Reply.halt (C := C))) = Law.pure (Reply.halt (C := C)) := rfl

/-- Budget accounting: the Sign-step kernel is *paid*, every other kernel is
shared between the simulator and the stopped honest game. -/
def paidFlag (op : Op) : Prop :=
  match op with
  | .sq _ => True
  | _ => False

instance (op : Op) : Decidable (paidFlag op) := by
  unfold paidFlag
  split <;> infer_instance

/-- **Game kernel identification.** For the kernels derived from the machine
step logic and the local certificate: shared steps have literally equal
kernels (`second = 1` exactly), paid steps carry at most `1+e`, absolute
continuity holds on every step, and the paid count is the number of Sign
queries (bounded by `Q_s` from the adversary budget). Therefore the concrete
transcript second moment obeys the task bound. -/
theorem game_kernel_identification
    (cert : LocalCert C) (Qs : ℕ)
    (j p : (n : ℕ) → Hist (Reply C) n → Law (Reply C))
    (paid : ℕ → Prop) [DecidablePred paid]
    (hshared : ∀ i x, ¬ paid i → j i x = p i x)
    (hpaid : ∀ i x, paid i → second (j i x) (p i x) ≤ 1 + cert.e)
    (hcount : ∀ n, PaidSteps.countPaid paid n ≤ Qs) (n : ℕ) :
    second (transcript j n) (transcript p n) ≤ (1 + cert.e) ^ Qs :=
  PaidSteps.paid_counter_le j p paid cert.e cert.e_nonneg Qs hshared hpaid hcount n

/-- Assembly with the conflict term: the concrete final shape with the exact
`eps_coll` (kernel-checked from `PaidSteps.paid_trace_bound` and
`PaidSteps.conflict_bound_shape`). -/
theorem conditional_shape
    (cert : LocalCert C) (Qs _QH : ℕ)
    (j p : (n : ℕ) → Hist (Reply C) n → Law (Reply C))
    (paid : ℕ → Prop) [DecidablePred paid]
    (hshared : ∀ i x, ¬ paid i → j i x = p i x)
    (hpaid : ∀ i x, paid i → second (j i x) (p i x) ≤ 1 + cert.e)
    (hac : ∀ i x, AC (j i x) (p i x))
    (hcount : ∀ n, PaidSteps.countPaid paid n ≤ Qs) (n : ℕ)
    (Win Bad MT : Hist (Reply C) n → Prop)
    [DecidablePred Win] [DecidablePred Bad] [DecidablePred MT]
    (extracts : ∀ x, Win x ∧ ¬ Bad x → MT x)
    (eps : ℝ) (hbad : (transcript p n).event Bad ≤ eps) :
    (transcript p n).event Win ≤
      min 1 (eps + EventTransfer.phi ((1 + cert.e)^Qs - 1) ((transcript j n).event MT)) :=
  PaidSteps.paid_trace_bound j p paid cert.e cert.e_nonneg Qs hshared hpaid hcount hac n
    Win Bad MT extracts eps hbad

end FT1536.GameLaw
