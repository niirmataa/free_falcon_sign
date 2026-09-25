import FT1536.GameLaw
import FT1536.PathCounter

-- Instance hygiene: `SigmaMath.nonceFintype` duplicates the canonical
-- `Fintype (Fin (2^320))`; one instance keeps `Law (Fin (2^320))` elaboration
-- consistent across all modules of this run.
attribute [-instance] FT1536.SigmaMath.nonceFintype


/-! # Adversary fold and paid-flag binding (binding type `adversary_fold_paid_flag_binding`)

For a bounded classical adversary `A` (next operation as a function of the
reply history; private coins are absorbed as shared kernel factors) this
module closes the last binding of the reduction:

* `stateAt` — the machine state after `k` replies, folded with
  `GameLaw.advance` (public-state reconstruction is `advance_correct`);
* `signKernel` — the full Sign-step kernel (uniform salt joint with the
  machine hit/miss split);
* `bind_eq_map_snd`, `second_map_le`, `ac_map_any` — data processing for
  coarse-grainings (needed because `.halt` replies collapse salt values);
* `signKernel_bound` — the composite Sign kernel obeys `second ≤ 1+e` and AC
  between the simulator and the stopped honest game (per-salt: hits share
  `pure .halt`, misses are `sign_miss_reply_bound`);
* `adversary_fold_paid_flag_binding` — the paid flag is exactly A's Sign
  queries, the per-run count is A's budget, and `PathCounter` yields
  `second ≤ (1+e)^Q_s` for the concrete kernels of `kernelOf`.

No `sorry` in this module. -/

namespace FT1536.AdversaryFold
open GameMach GameNames GameByte GameLaw PaidSteps PathCounter Divergence Finset

variable {C : Type} [Fintype C] [DecidableEq C]

/-- Bounded classical adversary: next operation as a function of the reply
history (private coins act as shared kernel factors). -/
def Adv (C : Type) := (k : ℕ) → Hist (Reply C) k → Op

/-- Machine state after the first `k` replies of the run. The fold is
mode-blind: the public state is shared by all games (the experiment mode
lives only in the Sign kernels), which is the fold-level form of
`GameLaw.advance_correct`. -/
noncomputable def stateAt (A : Adv C) (targets : ℕ → C) (verdict : Verdict C) :
    (k : ℕ) → Hist (Reply C) k → Mach C
  | 0, _ => init .real
  | k+1, x => advance targets verdict (stateAt A targets verdict k x.1) (A k x.1) x.2

/-- The paid flag: exactly the Sign queries of the adversary. -/
def paidAt (A : Adv C) : (k : ℕ) → Hist (Reply C) k → Bool
  | k, x => match A k x with
    | .sq _ => true
    | _ => false

/-- The simulator's per-salt Sign reply at this table state. -/
noncomputable def signReplySim (cert : LocalCert C) (st : ROM.State NameBody Message C) (msg : Message)
    (r : GameByte.Nonce) : Law (Reply C) :=
  match ROM.lookup (tableAddr (signName r msg)) st with
  | some _ => Law.pure (Reply.halt (C := C))
  | none => signMissKernel cert r .sim

/-- The stopped honest game's per-salt Sign reply at this table state. -/
noncomputable def signReplyStp (cert : LocalCert C) (st : ROM.State NameBody Message C) (msg : Message)
    (r : GameByte.Nonce) : Law (Reply C) :=
  match ROM.lookup (tableAddr (signName r msg)) st with
  | some _ => Law.pure (Reply.halt (C := C))
  | none => signMissKernel cert r .stopped

/-- Full Sign-step kernel: the uniform salt joint with the machine hit/miss
split. -/
noncomputable def signKernel (cert : LocalCert C) (nonce : Law GameByte.Nonce)
    (st : ROM.State NameBody Message C) (mode : Mode) (msg : Message) : Law (Reply C) :=
  match mode with
  | .real => nonce.bind fun r =>
      match ROM.lookup (tableAddr (signName r msg)) st with
      | some e => (cert.body e.value).map (fun o => .sign e.value (some (r, o)))
      | none => signMissKernel cert r .real
  | .stopped => nonce.bind (signReplyStp cert st msg)
  | .sim => nonce.bind (signReplySim cert st msg)

/-- One-step reply kernel of the machine at a given reply history. The
public state is shared; only the Sign kernel depends on the experiment mode. -/
noncomputable def kernelOf (cert : LocalCert C) (A : Adv C) (nonce : Law GameByte.Nonce)
    (targets : ℕ → C) (verdict : Verdict C) (mode : Mode) :
    (k : ℕ) → Hist (Reply C) k → Law (Reply C) :=
  fun k x =>
    match (stateAt A targets verdict k x).stopped || (stateAt A targets verdict k x).over with
    | true => Law.pure (Reply.halt (C := C))
    | false =>
      match A k x with
      | .hq kk => hKernel targets (stateAt A targets verdict k x) kk
      | .sq msg => signKernel cert nonce
          (ROM.submit msg (stateAt A targets verdict k x).st) mode msg
      | .fin r msg sg => finKernel targets verdict (stateAt A targets verdict k x) r msg sg

/-- `bind` is a pushforward of the joint law along `Prod.snd`. -/
theorem bind_eq_map_snd {α β : Type} [Fintype α] [Fintype β] [DecidableEq β]
    (p : Law α) (k : α → Law β) : p.bind k = (Divergence.joint p k).map Prod.snd := by
  apply Mixture.law_ext
  intro y
  show (∑ a, p.mass a * (k a).mass y)
      = (∑ z : α × β, p.mass z.1 * (k z.1).mass z.2 * (if y = z.2 then (1:ℝ) else 0))
  rw [Fintype.sum_prod_type]
  refine Finset.sum_congr rfl ?_
  intro a _
  show p.mass a * (k a).mass y
      = ∑ b : β, p.mass a * (k a).mass b * (if y = b then (1:ℝ) else 0)
  have hconv : (∑ b : β, p.mass a * (k a).mass b * (if y = b then (1:ℝ) else 0))
      = ∑ b : β, if y = b then p.mass a * (k a).mass b else 0 := by
    refine Finset.sum_congr rfl ?_
    intro b _
    by_cases hby : b = y <;> simp [hby]
  rw [hconv, Finset.sum_ite_eq]
  simp

/-- Mass of a mapped law is the fiber sum. -/
theorem map_mass_fiber {α β : Type} [Fintype α] [Fintype β] [DecidableEq β]
    (f : α → β) (q : Law α) (y : β) :
    (q.map f).mass y = ∑ x, if f x = y then q.mass x else 0 := by
  show (∑ x, q.mass x * (if y = f x then (1:ℝ) else 0)) = _
  refine Finset.sum_congr rfl ?_
  intro x _
  by_cases hxy : f x = y
  · simp [hxy]
  · have hyx : ¬(y = f x) := fun h => hxy h.symm
    simp [hxy, hyx]

/-- A zero fiber sum forces every fiber point to have zero mass. -/
theorem fiber_zero {α β : Type} [Fintype α] [Fintype β] [DecidableEq β]
    (f : α → β) (q : Law α) (y : β) (x : α) (hz : (q.map f).mass y = 0) (hxy : f x = y) :
    q.mass x = 0 := by
  have hterm : (if f x = y then (q.mass x : ℝ) else 0)
      ≤ ∑ x' : α, if f x' = y then q.mass x' else 0 := by
    refine Finset.single_le_sum
      (f := fun x' : α => if f x' = y then q.mass x' else 0) (s := univ) (fun x' _ => ?_)
      (Finset.mem_univ x)
    by_cases hxy2 : f x' = y <;> simp [hxy2, q.nonneg x']
  rw [map_mass_fiber f q y] at hz
  simp [hxy] at hterm
  rw [hz] at hterm
  exact le_antisymm hterm (q.nonneg x)

/-- Data processing for the second moment under coarse-grainings. -/
theorem second_map_le {α β : Type} [Fintype α] [Fintype β] [DecidableEq β]
    (f : α → β) (j p : Law α) (hac : AC j p) :
    second (j.map f) (p.map f) ≤ second j p := by
  unfold second
  have hkey : ∀ y : β,
      ((j.map f).mass y) ^ 2 / (p.map f).mass y
        ≤ ∑ x, if f x = y then j.mass x ^ 2 / p.mass x else 0 := by
    intro y
    have hcs := weighted_cauchy p
      (fun x => if f x = y then j.mass x / p.mass x else 0)
      (fun x => if f x = y then (1:ℝ) else 0)
    have hleft : (∑ x, p.mass x * (if f x = y then j.mass x / p.mass x else 0)
        * (if f x = y then (1:ℝ) else 0)) = (j.map f).mass y := by
      rw [map_mass_fiber f j y]
      refine Finset.sum_congr rfl ?_
      intro x _
      by_cases hxy : f x = y
      · have hjx : j.mass x = p.mass x * (j.mass x / p.mass x) := by
          by_cases hp0 : p.mass x = 0
          · rw [hac x hp0, hp0]
            simp
          · field_simp
        have h1 : (p.mass x * (j.mass x / p.mass x)) * (1:ℝ) = j.mass x := by
          rw [← hjx]
          ring
        simp [hxy, h1]
      · simp [hxy]
    have hright : (∑ x, p.mass x * (if f x = y then j.mass x / p.mass x else 0) ^ 2)
        = ∑ x, if f x = y then j.mass x ^ 2 / p.mass x else 0 := by
      refine Finset.sum_congr rfl ?_
      intro x _
      by_cases hxy : f x = y
      · by_cases hp0 : p.mass x = 0
        · rw [hac x hp0, hp0]
          simp
        · have h1 : p.mass x * (j.mass x / p.mass x) ^ 2 = j.mass x ^ 2 / p.mass x := by
            field_simp
          simp [hxy, h1]
      · simp [hxy]
    have hpp : (∑ x, p.mass x * (if f x = y then (1:ℝ) else 0) ^ 2) = (p.map f).mass y := by
      rw [map_mass_fiber f p y]
      refine Finset.sum_congr rfl ?_
      intro x _
      by_cases hxy : f x = y <;> simp [hxy]
    rw [hleft, hright, hpp] at hcs
    rcases eq_or_ne ((p.map f).mass y) 0 with hp | hp
    · have hj0 : (j.map f).mass y = 0 := by
        rw [map_mass_fiber f j y]
        refine Finset.sum_eq_zero ?_
        intro x _
        by_cases hxy : f x = y
        · rw [hac x (fiber_zero f p y x hp hxy)]
          simp
        · simp [hxy]
      have hz : ((j.map f).mass y) ^ 2 / (p.map f).mass y = 0 := by
        rw [hj0, hp]
        simp
      rw [hz]
      refine Finset.sum_nonneg ?_
      intro x _
      by_cases hxy : f x = y
      · simp [hxy]
        exact div_nonneg (sq_nonneg _) (p.nonneg _)
      · simp [hxy]
    · have hdiv := div_le_div_of_nonneg_right hcs
        (lt_of_le_of_ne ((p.map f).nonneg y) (Ne.symm hp)).le
      have hfin : (((∑ x : α, if f x = y then j.mass x ^ 2 / p.mass x else 0)
          * (p.map f).mass y) / (p.map f).mass y)
          = (∑ x : α, if f x = y then j.mass x ^ 2 / p.mass x else 0) := by
        field_simp [hp]
      rw [hfin] at hdiv
      exact hdiv
  calc (∑ y : β, (j.map f).mass y ^ 2 / (p.map f).mass y)
      ≤ ∑ y : β, ∑ x, if f x = y then j.mass x ^ 2 / p.mass x else 0 :=
        Finset.sum_le_sum fun y _ => hkey y
    _ = ∑ x : α, j.mass x ^ 2 / p.mass x := by
        rw [Finset.sum_comm]
        refine Finset.sum_congr rfl ?_
        intro x _
        rw [Finset.sum_ite_eq]
        simp

/-- AC is preserved by arbitrary pushforwards. -/
theorem ac_map_any {α β : Type} [Fintype α] [Fintype β] [DecidableEq β]
    (f : α → β) (j p : Law α) (h : AC j p) : AC (j.map f) (p.map f) := by
  intro y hy
  rw [map_mass_fiber f j y]
  refine Finset.sum_eq_zero ?_
  intro x _
  by_cases hxy : f x = y
  · rw [h x (fiber_zero f p y x hy hxy)]
    simp
  · simp [hxy]

/-- Per-salt Sign replies: hits share `pure .halt`, misses are the certified
pair laws. -/
theorem signReply_bound (cert : LocalCert C) (st : ROM.State NameBody Message C)
    (msg : Message) (r : GameByte.Nonce) :
    second (signReplySim cert st msg r) (signReplyStp cert st msg r) ≤ 1 + cert.e ∧
    AC (signReplySim cert st msg r) (signReplyStp cert st msg r) := by
  unfold signReplySim signReplyStp
  cases hl : ROM.lookup (tableAddr (signName r msg)) st with
  | some e =>
    constructor
    · exact le_trans (le_of_eq (PaidSteps.second_self _))
        (by linarith [cert.e_nonneg])
    · intro z hz
      exact hz
  | none => exact sign_miss_reply_bound cert r

/-- The composite Sign kernel obeys `second ≤ 1+e` and AC between the
simulator and the stopped honest game. -/
theorem signKernel_bound (cert : LocalCert C) (nonce : Law GameByte.Nonce)
    (st : ROM.State NameBody Message C) (msg : Message) :
    second (signKernel cert nonce st .sim msg) (signKernel cert nonce st .stopped msg)
      ≤ 1 + cert.e ∧
    AC (signKernel cert nonce st .sim msg) (signKernel cert nonce st .stopped msg) := by
  have hks : signKernel cert nonce st .sim msg
      = nonce.bind (signReplySim cert st msg) := rfl
  have hkh : signKernel cert nonce st .stopped msg
      = nonce.bind (signReplyStp cert st msg) := rfl
  have hper : ∀ r, second (signReplySim cert st msg r) (signReplyStp cert st msg r) ≤ 1 + cert.e ∧
      AC (signReplySim cert st msg r) (signReplyStp cert st msg r) :=
    fun r => signReply_bound cert st msg r
  have hjac : AC (Divergence.joint nonce (signReplySim cert st msg))
      (Divergence.joint nonce (signReplyStp cert st msg)) :=
    joint_ac nonce nonce _ _ (fun z hz => hz) (fun r _ => (hper r).2)
  have hbound : second (Divergence.joint nonce (signReplySim cert st msg))
      (Divergence.joint nonce (signReplyStp cert st msg)) ≤ second nonce nonce * (1 + cert.e) :=
    joint_bound nonce nonce _ _ (1 + cert.e) (fun r _ => (hper r).1)
  rw [hks, hkh, bind_eq_map_snd, bind_eq_map_snd]
  constructor
  · exact le_trans (second_map_le Prod.snd _ _ hjac)
      (by rw [PaidSteps.second_self] at hbound; simpa [one_mul] using hbound)
  · exact ac_map_any Prod.snd _ _ hjac

/-- **Adversary fold paid-flag binding.** The paid flag of the fold is exactly
A's Sign queries; with A's per-run budget the pathwise counter lemma gives
`second ≤ (1+e)^Q_s` for the concrete kernels of `kernelOf`. -/
theorem adversary_fold_paid_flag_binding
    (cert : LocalCert C) (A : Adv C) (nonce : Law GameByte.Nonce)
    (targets : ℕ → C) (verdict : Verdict C) (Qs : ℕ) {n : ℕ}
    (hcount : ∀ x : Hist (Reply C) n, countPath (paidAt A) n x ≤ Qs) :
    second (transcript (kernelOf cert A nonce targets verdict .sim) n)
      (transcript (kernelOf cert A nonce targets verdict .stopped) n) ≤ (1 + cert.e) ^ Qs := by
  have hshared : ∀ k x, paidAt A k x = false →
      kernelOf cert A nonce targets verdict .sim k x
        = kernelOf cert A nonce targets verdict .stopped k x := by
    intro k x hnp
    unfold kernelOf
    cases hm : (stateAt A targets verdict k x).stopped
        || (stateAt A targets verdict k x).over with
    | true => rfl
    | false =>
      cases hop : A k x with
      | hq kk => rfl
      | fin r msg sg => rfl
      | sq msg =>
        simp only [paidAt, hop] at hnp
        exact Bool.noConfusion hnp
  have hpaid : ∀ k x, paidAt A k x = true →
      second (kernelOf cert A nonce targets verdict .sim k x)
        (kernelOf cert A nonce targets verdict .stopped k x) ≤ 1 + cert.e := by
    intro k x hp
    unfold kernelOf
    cases hm : (stateAt A targets verdict k x).stopped
        || (stateAt A targets verdict k x).over with
    | true =>
      exact le_trans (le_of_eq (PaidSteps.second_self _)) (by linarith [cert.e_nonneg])
    | false =>
      cases hop : A k x with
      | hq kk =>
        simp only [paidAt, hop] at hp
        exact Bool.noConfusion hp
      | fin r msg sg =>
        simp only [paidAt, hop] at hp
        exact Bool.noConfusion hp
      | sq msg =>
        show second
            (signKernel cert nonce (ROM.submit msg (stateAt A targets verdict k x).st) .sim msg)
            (signKernel cert nonce (ROM.submit msg (stateAt A targets verdict k x).st) .stopped msg)
            ≤ 1 + cert.e
        exact (signKernel_bound cert nonce
          (ROM.submit msg (stateAt A targets verdict k x).st) msg).1
  exact PathCounter.paid_counter_pathwise
    (kernelOf cert A nonce targets verdict .sim)
    (kernelOf cert A nonce targets verdict .stopped)
    (paidAt A) cert.e cert.e_nonneg hshared hpaid Qs hcount

end FT1536.AdversaryFold
