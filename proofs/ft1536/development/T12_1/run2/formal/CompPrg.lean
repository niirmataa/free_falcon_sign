import AdvPrg

/-! # CompPrg — window B2/B5: the computational seam, honestly quantified

Window B2/B5 of the run2 lane (`notes/PROMPT_B2B5_COMPUTATIONAL.md`). This
module closes the two verified gaps of the independent review (2026-10-06)
against `formal/AdvPrg.lean` + `formal/Assembly.lean`:

1. **Statistical quantifier in a computational claim.** `AdvPrg.ChaCha20PRFBound`
   quantifies over ALL events (its point TV distance), so — by
   `AdvPrg.chacha20PRFBound_delta_ge` combined with `AdvPrg.route_a_closed` —
   every valid `delta` on the real tape is `>= 1 - 2^448/2^n` (~1 at real `n`).
   The computational reading is here made an actual QUANTIFIER: the named
   predicate `CompPRGBound C tau delta` ranges over an ADMITTED CLASS of tests
   `C` (a PARAMETER — no Turing machines, no cost model invented beyond the
   seam's accounting line), and the class shape supports exactly what the hop
   needs: **membership of the game's winning event for a composed adversary**
   (`CompWinCert` — the named premise, with its resource accounting
   `cost <= T(A) + q * cost of one ChaCha20 block` recorded as the accounting
   SHAPE only).
2. **The PRG term appended, not hopped.** `Assembly.end_to_end_assembled_…`
   adds `0 <= deltaPRG` to the RHS of the ideal-game bound (`le_add_of_nonneg_right`)
   and the LHS experiment never changes tape. Here the real game is ON the LHS
   (`AdvEUFStream`: the EUF game whose signing oracle runs the real
   `Games.Sampler.code` on the real stream) and `deltaPRG` arrives **via the
   hop** (`stream_game_hop*` — the `Assembly.tape_game_hop_abs` family applied
   to the WINNING EVENT of `A`, at winning-probability level, for the admitted
   class only). The old export stays the abstract honest-game shape;
   `formal/Assembly.lean` is untouched.

## Design choices (recorded — goal 4 of the task)

* **Tape scope.** `n = beta.qs * S.bits` (`tapeWidth`): `beta.qs` is the
  record FIELD `Budget.qs` (the query budget), so `n` is a PRODUCT of the
  budget's query count and the per-call width `S.bits` — not a double
  multiplier. The per-call width `S.bits` vs the whole-run horizon is joined
  in ONE game definition by the **whole-run tape law with per-call
  projection** (`windowOf` — call `i` reads window `i` of one whole-run tape;
  the run's generator usage is one stream, `AdvPrg.frngTapeLaw seed n` at
  total width `n`). This is the ONE-STREAM reading recorded in
  `notes/B2_ADVPRG_WORK_STATE.md` §5; a per-call reading would instead
  compose with a `beta.qs`-fold factor.
* **Test shape.** A composed adversary is randomized beyond the tape (key,
  coins, nonces and the ROM draws stay in the one-draw continuation), so its
  tape-level winning event is its win FUNCTION `x ↦ (F x).event E : [0,1]`.
  The class therefore carries `CompTest` — [0,1]-valued tests (randomized
  tests; deterministic tests are the `{0,1}`-valued ones, `CompTest.ofEvent`,
  whose advantage IS `AdvPrg.distinguishingAdv` of the corresponding event —
  `compTestAdv_ofEvent`). The task's e.g. predicate on Prop-events is kept
  verbatim as `CompPRGBoundEvent`, and
  `compPRGBoundEvent_of_compPRGBound` shows it is the deterministic special
  case of `CompPRGBound`.
* **What is NOT done here (kept, recorded):** all TV lemmas and
  `AdvPrg.route_a_closed` stay as the recorded death of the statistical route
  (`formal/AdvPrg.lean` §4 — READ-ONLY here); no small TV is derived from the
  computational assumption (impossible); the seed/SHAKE boundary (A2) and the
  byte bridge (A3/A4) stay outside; `keyIdent` stays the exact-type slot
  (B1.10 owns it) and the new exports USE `hkey` structurally (the `gate`
  pattern — the final identification is the only free point of the slot).

## Honest ledger of THIS window (`notes/B2B5_COMPUTATIONAL_WORK_STATE.md`)

* The computational claim is CONDITIONAL on `CompPRGBound C tau deltaPRG` at
  the whole-run width together with the named membership premise for the
  composed winning event. Route (a) stays closed BY THEOREM (`route_a_closed`):
  the class-free/unbounded reading of `deltaPRG` is ~1 and vacuous, so only
  the admitted-class reading is operative.
* The hop is at winning-probability level FOR THE ADMITTED CLASS ONLY (task
  honesty rule 1) — the exact statement is `comp_game_hop_abs`.
* `formal/AssemblyComp.lean` re-exports the assembled bound with the
  real-stream game on the LHS and derives the exact `Phi` inversion
  `Adv_MT(B) >= max 0 (a - sqrt(D * a * (1 - a)))` with
  `a = epsilon_real - deltaPRG - epsColl beta` (the review's shape is CHECKED
  and confirmed to be the exact inverse of `FT1536.EventTransfer.phi`).
-/

namespace FT1536.CompPrg
open Finset FT1536 FT1536.Run2
open FT1536.AdvPrg

/-! ## 0. The tape scope: per-call width vs the whole-run horizon -/

/-- Per-call tape width: `S.bits` (`Games.Sampler.code` consumes one tape
`Fin S.bits -> Bool` per sampler call, `Run2.sample`). -/
def callWidth (S : Sampler) : ℕ := S.bits

theorem callWidth_eq (S : Sampler) : callWidth S = S.bits := rfl

/-- THE whole-run (horizon) tape width `n = beta.qs * S.bits`. Here `beta.qs`
is the record FIELD `Budget.qs` (the signing-query budget of one game run), so
`n` is the PRODUCT of the budget's query count and the per-call width — the
notation `beta.qs * S.bits` is not a product of two multipliers. At most
`beta.qs` sampler calls run per game (one per executed `Program.sign` token),
each consuming `S.bits` bits, so this is the exact one-stream consumption
(`AdvPrg.tapeBitsTotal`). -/
def tapeWidth (beta : Budget) (S : Sampler) : ℕ := beta.qs * S.bits

theorem tapeWidth_eq (beta : Budget) (S : Sampler) :
    tapeWidth beta S = beta.qs * S.bits := rfl

theorem tapeWidth_eq_tapeBitsTotal (beta : Budget) (S : Sampler) :
    tapeWidth beta S = AdvPrg.tapeBitsTotal beta S := rfl

/-- Per-call projection of the whole-run tape: the window of call `i`
(`0 <= i < k`), the bits `[i*m, (i+1)*m)` of one stream of `k*m` bits. -/
def windowOf {k m : ℕ} (x : Fin (k * m) → Bool) (i : Fin k) : Fin m → Bool := fun t =>
  x ⟨i * m + t, by
    have ht := t.isLt
    have hstep : i * m + t < i * m + m :=
      Nat.add_lt_add_left ht (i * m)
    have hle : i * m + m ≤ k * m := by
      have h := Nat.mul_le_mul_right m (show i + 1 ≤ k by omega)
      simpa [Nat.add_mul, Nat.one_mul] using h
    omega⟩

/-- The per-call window table of a whole-run tape (the "per-call projection"
of the one-stream reading). -/
def windowsOf {k m : ℕ} (x : Fin (k * m) → Bool) : Fin k → (Fin m → Bool) :=
  fun i => windowOf x i

/-- Flattening a per-call window table back into one whole-run tape. -/
def flattenWindows {k m : ℕ} (w : Fin k → (Fin m → Bool)) : Fin (k * m) → Bool := fun t =>
  w ⟨t / m, by
    have ht' : t.val < m * k := lt_of_lt_of_eq t.isLt (Nat.mul_comm k m)
    exact Nat.div_lt_of_lt_mul ht'⟩
    ⟨t % m, by
      have ht := t.isLt
      rcases Nat.eq_zero_or_pos m with hm | hm
      · subst hm
        simp at ht
      · exact Nat.mod_lt _ hm⟩

theorem windowOf_eq {k m : ℕ} (x : Fin (k * m) → Bool) (i : Fin k) (t : Fin m) :
    windowOf x i t = x ⟨i * m + t, by
      have ht := t.isLt
      have hstep : i * m + t < i * m + m := Nat.add_lt_add_left ht (i * m)
      have hle : i * m + m ≤ k * m := by
        have h := Nat.mul_le_mul_right m (show i + 1 ≤ k by omega)
        simpa [Nat.add_mul, Nat.one_mul] using h
      omega⟩ := rfl

/-- Windows of a flattened table: window `i` reads exactly the `i`-th table
entry. -/
theorem windowsOf_flattenWindows {k m : ℕ} (w : Fin k → (Fin m → Bool)) :
    windowsOf (flattenWindows w) = w := by
  funext i t
  rcases Nat.eq_zero_or_pos m with hm | hm
  · subst hm
    exact absurd t.isLt (by omega)
  have hi1 : (i * m + t) / m = i := by
    rw [Nat.add_comm, Nat.mul_comm i m, Nat.add_mul_div_left t i hm,
      Nat.div_eq_of_lt t.isLt, Nat.zero_add]
  have hi2 : (i * m + t) % m = t := by
    rw [Nat.mul_comm i m, Nat.mul_add_mod_self_left m i t, Nat.mod_eq_of_lt t.isLt]
  simp only [windowsOf, windowOf, flattenWindows]
  congr 2

/-- Flattening the window table of a tape is the identity. -/
theorem flattenWindows_windowsOf {k m : ℕ} (x : Fin (k * m) → Bool) :
    flattenWindows (windowsOf x) = x := by
  funext t
  rcases Nat.eq_zero_or_pos m with hm | hm
  · subst hm
    exact absurd t.isLt (by omega)
  have h1 : (t / m) * m + t % m = t := by
    rw [Nat.mul_comm]
    exact Nat.div_add_mod t m
  simp only [windowsOf, windowOf, flattenWindows]
  congr 1
  exact Fin.ext h1

/-- The one-stream reading: the whole-run tape and its per-call window table
are the same object up to relabeling. -/
def windowsEquiv {k m : ℕ} : (Fin (k * m) → Bool) ≃ (Fin k → (Fin m → Bool)) where
  toFun := windowsOf
  invFun := flattenWindows
  left_inv := flattenWindows_windowsOf
  right_inv := windowsOf_flattenWindows

/-- Counting: exactly one whole-run tape has a prescribed window table. -/
theorem sum_windowsOf_ite {k m : ℕ} (w : Fin k → (Fin m → Bool)) :
    ∑ x : Fin (k * m) → Bool, (if w = windowsOf x then (1 : ℝ) else 0) = 1 := by
  classical
  have h : (∑ x : Fin (k * m) → Bool, (if w = windowsOf x then (1 : ℝ) else 0))
      = (∑ y : Fin k → (Fin m → Bool), (if w = y then (1 : ℝ) else 0)) :=
    (windowsEquiv (k := k) (m := m)).sum_comp
      (fun y : Fin k → (Fin m → Bool) => if w = y then (1 : ℝ) else 0)
  rw [h]
  simp

/-- The per-call projection of the FAIR whole-run tape is the fair per-call
tape table (uniformity factorizes through the window relabeling). -/
theorem uniform_windowsOf_mass {k m : ℕ} (w : Fin k → (Fin m → Bool)) :
    ((Law.uniform : Law (Fin (k * m) → Bool)).map (windowsOf : (Fin (k * m) → Bool) →
        (Fin k → (Fin m → Bool)))).mass w
      = (Law.uniform : Law (Fin k → (Fin m → Bool))).mass w := by
  classical
  rw [mass_map]
  have hcard : Fintype.card (Fin (k * m) → Bool) = Fintype.card (Fin k → (Fin m → Bool)) :=
    Fintype.card_congr windowsEquiv
  show (∑ x : Fin (k * m) → Bool,
      ((1 : ℝ) / Fintype.card (Fin (k * m) → Bool)) * (if w = windowsOf x then (1 : ℝ) else 0))
    = (1 : ℝ) / Fintype.card (Fin k → (Fin m → Bool))
  rw [← Finset.mul_sum, sum_windowsOf_ite, mul_one, hcard]

/-- The one-stream hop seam at the window table: reading the per-call windows
of one fair whole-run tape is the same computation as reading one fair
per-call tape table. -/
theorem draw_uniform_windowsOf {k m : ℕ} {α : Type} [Fintype α]
    (G : (Fin k → (Fin m → Bool)) → FT1536.Run2.Dist α) :
    FT1536.Run2.Dist.Same
      ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin (k * m) → Bool))).bind
        fun x => G (windowsOf x))
      ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin k → (Fin m → Bool)))).bind G) := by
  intro f
  rw [Dist.expect_bind, Dist.expect_bind]
  have hcard : Fintype.card (Fin (k * m) → Bool) = Fintype.card (Fin k → (Fin m → Bool)) :=
    Fintype.card_congr windowsEquiv
  show (∑ x : Fin (k * m) → Bool,
      (Law.uniform : Law (Fin (k * m) → Bool)).mass x * (G (windowsOf x)).expect f)
    = (∑ y : Fin k → (Fin m → Bool),
      (Law.uniform : Law (Fin k → (Fin m → Bool))).mass y * (G y).expect f)
  have h1 : ∀ x : Fin (k * m) → Bool,
      (Law.uniform : Law (Fin (k * m) → Bool)).mass x * (G (windowsOf x)).expect f
        = ((1 : ℝ) / Fintype.card (Fin k → (Fin m → Bool))) * (G (windowsOf x)).expect f := by
    intro x
    show ((1 : ℝ) / Fintype.card (Fin (k * m) → Bool)) * _ = _
    rw [hcard]
  simp_rw [h1]
  exact (windowsEquiv (k := k) (m := m)).sum_comp
    (fun y : Fin k → (Fin m → Bool) =>
      ((1 : ℝ) / Fintype.card (Fin k → (Fin m → Bool))) * (G y).expect f)

/-! ## 1. The computational quantifier: an ADMITTED CLASS of tests -/

/-- A test on the tape: a [0,1]-valued (possibly randomized) win function.
Deterministic tests are the `{0,1}`-valued ones; a composed adversary is
randomized beyond the tape (the key, the coins, the nonces and the ROM draws
all live in the one-draw continuation), so the tape-level winning event of
"game + `A`" IS this win-function object. The class shape supports exactly
what the hop needs: its MEMBERSHIP (`CompWinCert.mem`). -/
structure CompTest (ξ : Type) where
  /-- The win function of the test. -/
  run : ξ → ℝ
  /-- Tests are nonnegative. -/
  nonneg : ∀ x, 0 ≤ run x
  /-- Tests are bounded by one. -/
  le_one : ∀ x, run x ≤ 1

/-- The distinguishing advantage of `tau` against the fair tape on ONE test —
the [0,1]-generalization of `AdvPrg.distinguishingAdv` (which is the
indicator special case). -/
noncomputable def compTestAdv {ξ : Type} [Fintype ξ] [Nonempty ξ] (tau : Law ξ)
    (t : CompTest ξ) : ℝ :=
  |∑ x, (tau.mass x - (Law.uniform : Law ξ).mass x) * t.run x|

/-- THE computational shape (the `UniformChallenge` pattern of
`VerifyBind/HashTo.lean`, computational reading): `CompPRGBound C tau delta`
quantifies over an ADMITTED CLASS of tests `C` — a PARAMETER, no Turing
machines, no cost model invented beyond the seam's accounting line. This is
the operative named assumption of the assembled claim; its unbounded variant
(`C` = all tests) is exactly `AdvPrg.ChaCha20PRFBound` and is vacuous on the
real tape (`AdvPrg.chacha20PRFBound_delta_ge`) — do NOT weaken to it. -/
def CompPRGBound {ξ : Type} [Fintype ξ] [Nonempty ξ] (C : Set (CompTest ξ))
    (tau : Law ξ) (delta : ℝ) : Prop :=
  ∀ t ∈ C, compTestAdv tau t ≤ delta

/-- The task's e.g. predicate, verbatim shape: the deterministic (Prop-event)
tests only, over `AdvPrg.distinguishingAdv`. Kept as the canonical
event-form; `compPRGBoundEvent_of_compPRGBound` records it as the
indicator special case of `CompPRGBound`. -/
def CompPRGBoundEvent {ξ : Type} [Fintype ξ] [Nonempty ξ] (C : Set (ξ → Prop))
    (tau : Law ξ) (delta : ℝ) : Prop :=
  ∀ E ∈ C, distinguishingAdv tau E ≤ delta

/-- THE named membership premise (goal 2 of the task), with its resource
accounting SHAPE: the composed winning event of the game for the composed
adversary is ADMITTED by the class, and the cost of the composed test obeys
the seam's accounting line `cost <= T(A) + q * cost of one ChaCha20 block`
(`q` ChaCha20 blocks generate the `tapeWidth beta S`-bit stream;
`AdvPrg.chachaBlocksTotal` is its exact block count). No cost model is
invented beyond this line — the seam needs no more. -/
structure CompWinCert {ξ : Type} (C : Set (CompTest ξ)) (cost : CompTest ξ → ℝ)
    (t : CompTest ξ) (TA blockCost : ℝ) (q : ℕ) : Prop where
  /-- MEMBERSHIP of the game's winning event for the composed adversary. -/
  mem : t ∈ C
  /-- The recorded resource accounting shape. -/
  costLine : cost t ≤ TA + q * blockCost

/-- The winning event of the one-draw game with continuation `F` and output
event `E`, as a tape test (the win function `x ↦ (F x).event E`). -/
noncomputable def winFun {ξ α : Type} [Fintype ξ] [Fintype α]
    (F : ξ → FT1536.Run2.Dist α) (E : α → Prop) : CompTest ξ where
  run x := (F x).event E
  nonneg x := Dist.event_nonneg (F x) E
  le_one x := Dist.event_le_one (F x) E

/-- THE hop at winning-probability level, FOR THE ADMITTED CLASS ONLY (the
task's honesty rule 1 — `Assembly.tape_game_hop_abs` applied to the WINNING
EVENT of the composed adversary): replacing the whole-run tape law `tau` by
the fair tape moves the win event of ANY continuation by at most `delta`,
provided the composed win test is admitted. -/
theorem comp_game_hop_abs {ξ α : Type} [Fintype ξ] [Nonempty ξ] [Fintype α]
    (C : Set (CompTest ξ)) (tau : Law ξ) (delta : ℝ) (hcomp : CompPRGBound C tau delta)
    (F : ξ → FT1536.Run2.Dist α) (E : α → Prop) (hwin : winFun F E ∈ C) :
    |((FT1536.Run2.Dist.draw tau).bind F).event E
      - ((FT1536.Run2.Dist.draw (Law.uniform : Law ξ)).bind F).event E| ≤ delta := by
  rw [Assembly.bind_draw_event, Assembly.bind_draw_event]
  have hsum : (∑ x, tau.mass x * (F x).event E)
      - (∑ x, (Law.uniform : Law ξ).mass x * (F x).event E)
      = ∑ x, (tau.mass x - (Law.uniform : Law ξ).mass x) * (F x).event E := by
    rw [← Finset.sum_sub_distrib]
    simp_rw [sub_mul]
  rw [hsum]
  show compTestAdv tau (winFun F E) ≤ delta
  exact hcomp (winFun F E) hwin

/-- The hop, one-sided delta form. -/
theorem comp_game_hop {ξ α : Type} [Fintype ξ] [Nonempty ξ] [Fintype α]
    (C : Set (CompTest ξ)) (tau : Law ξ) (delta : ℝ) (hcomp : CompPRGBound C tau delta)
    (F : ξ → FT1536.Run2.Dist α) (E : α → Prop) (hwin : winFun F E ∈ C) :
    ((FT1536.Run2.Dist.draw tau).bind F).event E
      ≤ ((FT1536.Run2.Dist.draw (Law.uniform : Law ξ)).bind F).event E + delta := by
  have h := comp_game_hop_abs C tau delta hcomp F E hwin
  have hl : ((FT1536.Run2.Dist.draw tau).bind F).event E
      - ((FT1536.Run2.Dist.draw (Law.uniform : Law ξ)).bind F).event E
      ≤ |((FT1536.Run2.Dist.draw tau).bind F).event E
        - ((FT1536.Run2.Dist.draw (Law.uniform : Law ξ)).bind F).event E| := le_abs_self _
  linarith

/-- The hop, fair-side form (the direction the `Phi` inversion consumes). -/
theorem comp_game_hop_symm {ξ α : Type} [Fintype ξ] [Nonempty ξ] [Fintype α]
    (C : Set (CompTest ξ)) (tau : Law ξ) (delta : ℝ) (hcomp : CompPRGBound C tau delta)
    (F : ξ → FT1536.Run2.Dist α) (E : α → Prop) (hwin : winFun F E ∈ C) :
    ((FT1536.Run2.Dist.draw (Law.uniform : Law ξ)).bind F).event E
      ≤ ((FT1536.Run2.Dist.draw tau).bind F).event E + delta := by
  have h := comp_game_hop_abs C tau delta hcomp F E hwin
  have hl : ((FT1536.Run2.Dist.draw (Law.uniform : Law ξ)).bind F).event E
      - ((FT1536.Run2.Dist.draw tau).bind F).event E
      ≤ |((FT1536.Run2.Dist.draw tau).bind F).event E
        - ((FT1536.Run2.Dist.draw (Law.uniform : Law ξ)).bind F).event E| := by
    have := neg_le_abs (((FT1536.Run2.Dist.draw tau).bind F).event E
      - ((FT1536.Run2.Dist.draw (Law.uniform : Law ξ)).bind F).event E)
    linarith
  linarith

/-! ## 2. Small `Dist` transport lemmas -/

/-- `Same` transports through `bind` at equal continuations. -/
theorem same_bind_congr {α β : Type} (p : FT1536.Run2.Dist α)
    (f g : α → FT1536.Run2.Dist β) (h : ∀ x, (f x).Same (g x)) :
    (p.bind f).Same (p.bind g) := by
  intro F
  simp only [Dist.expect_bind]
  exact Dist.expect_congr p _ _ (fun x => h x F)

/-- Binding a constant computation is that computation. -/
theorem bind_const_same {α β : Type} (p : FT1536.Run2.Dist α) (q : FT1536.Run2.Dist β) :
    (p.bind fun _ => q).Same q := by
  intro F
  simp only [Dist.expect_bind]
  exact Dist.expect_const p (q.expect F)

/-- `Same` transports through `map`. -/
theorem same_map {α β : Type} (f : α → β) (p q : FT1536.Run2.Dist α) (h : p.Same q) :
    (p.map f).Same (q.map f) := by
  intro F
  simp only [Dist.expect_map]
  exact h (fun x => F (f x))

/-- `Same` is transitive. -/
theorem same_trans' {α : Type} (p q r : FT1536.Run2.Dist α) (hpq : p.Same q)
    (hqr : q.Same r) : p.Same r := by
  intro F
  exact (hpq F).trans (hqr F)

/-- `Same` is symmetric. -/
theorem same_symm' {α : Type} (p q : FT1536.Run2.Dist α) (h : p.Same q) : q.Same p := by
  intro F
  exact (h F).symm

/-- `map` after `bind` is the bind of the mapped continuations. -/
theorem same_map_bind {α β γ : Type} (p : FT1536.Run2.Dist α) (k : α → FT1536.Run2.Dist β)
    (f : β → γ) : ((p.bind k).map f).Same (p.bind fun x => (k x).map f) := by
  intro F
  simp only [Dist.expect_map, Dist.expect_bind]

/-- `Same` at the constant continuation is congruent in the constant. -/
theorem bind_same_const_congr {α β : Type} (p : FT1536.Run2.Dist α)
    (q q' : FT1536.Run2.Dist β) (h : q.Same q') : (p.bind fun _ => q).Same (p.bind fun _ => q') :=
  same_bind_congr p (fun _ => q) (fun _ => q') (fun _ => h)

/-! ## 3. The real-stream EUF game (one whole-run tape, per-call projection) -/

/-- The window read of a per-call tape table at call index `i` (total: the
constant `false` window out of range — never read when `i < k`). -/
def winRead {k m : ℕ} (w : Fin k → (Fin m → Bool)) (i : ℕ) : Fin m → Bool := fun u =>
  if hmem : i < k then w ⟨i, hmem⟩ u else false

theorem winRead_apply {k m : ℕ} (w : Fin k → (Fin m → Bool)) {i : ℕ} (hi : i < k) :
    winRead w i = w ⟨i, hi⟩ := by
  funext u
  simp [winRead, hi]

theorem winRead_update_same {k m : ℕ} (w : Fin k → (Fin m → Bool)) (j : Fin k)
    (t : Fin m → Bool) : winRead (Function.update w j t) j = t := by
  funext u
  simp [winRead, Function.update, j.isLt]

theorem winRead_update_ne {k m : ℕ} (w : Fin k → (Fin m → Bool)) (j : Fin k)
    (t : Fin m → Bool) {i : ℕ} (hij : i ≠ j) :
    winRead (Function.update w j t) i = winRead w i := by
  funext u
  by_cases hi : i < k
  · have hne : (⟨i, hi⟩ : Fin k) ≠ j := fun h => hij (congrArg Fin.val h)
    simp [winRead, Function.update, hi, hne]
  · simp [winRead, hi]

/-- `Same` transports along an equation of computations. -/
theorem same_of_eq {α : Type} (p q : FT1536.Run2.Dist α) (h : p = q) : p.Same q := by
  rw [h]
  exact Dist.same_refl q

/-- `Same` is preserved by a shared continuation on the left. -/
theorem same_bind_same_left {α β : Type} (p q : FT1536.Run2.Dist α)
    (k : α → FT1536.Run2.Dist β) (h : p.Same q) : (p.bind k).Same (q.bind k) := by
  intro F
  simp only [Dist.expect_bind]
  exact h (fun x => (k x).expect F)

/-- The sampler call of the real signer driven by the tape window `w` —
`Run2.sample` (`(Dist.draw Law.uniform).map (S.code h st m r)`) with the FAIR
tape draw replaced by the given window: the `Games.Sampler.code` seam at the
tape law `tau` (`Assembly.samplerLawAt`). The nonce draw and the ROM lookup
are unchanged (`Games.signSim`). -/
noncomputable def signSimAt (S : Sampler) (w : Fin S.bits → Bool) (h : FT1536.Relation.Rq)
    (st : State) (m : Bytes) : FT1536.Run2.Dist (Option (Reply × State)) :=
  (FT1536.Run2.Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
    match ROM.lookup (parse (frame r m)) (Games.submitted m st).table with
    | some _ => FT1536.Run2.Dist.pure none
    | none => (FT1536.Run2.Dist.pure (S.code h (Games.submitted m st) m r w)).map
        (Games.programmedReply (Games.submitted m st) m r)

/-- The tape-driven execution of `A`'s program: call `i` reads window `i` of
the tape table `win`. Mirrors `Run2.simulateLazy` with `Games.signSim`
replaced by `signSimAt`; the hash queries and the finish test stay honest
(`Games.hashHonest` / `Games.finishHonest`). At most `s` sign tokens execute
in `Program s q` (the `Program` indices are structural), so windows
`0 .. beta.qs-1` of the whole-run tape suffice. -/
noncomputable def simulateStream (S : Sampler) (h : FT1536.Relation.Rq)
    (win : ℕ → (Fin S.bits → Bool)) (st : State) :
    (i : ℕ) → {s q : ℕ} → Program s q → FT1536.Run2.Dist (Option Games.Finished)
  | _, _, _, .done f => FT1536.Run2.Dist.pure (some ⟨f, st⟩)
  | i, _, _, .hash x c => (Games.hashHonest x st).bind fun co =>
      simulateStream S h win (Games.recordedHash x co.1 co.2) i (c co.1)
  | i, _, _, .sign m c => (signSimAt S (win i) h st m).bind fun o => match o with
      | none => FT1536.Run2.Dist.pure none
      | some os => simulateStream S h win os.2 (i + 1) (c os.1)

/-- The one-draw continuation of the stream game after the whole-run tape:
the key, the adversary's coins, the nonces and the ROM draws all live here. -/
noncomputable def streamCont (beta : Budget) (muH : Law FT1536.Relation.Rq)
    (A : ClassicalAdversary beta) (S : Sampler) (x : Fin (tapeWidth beta S) → Bool) :
    FT1536.Run2.Dist Bool :=
  (FT1536.Run2.Dist.draw muH).bind fun hk =>
    (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
      (simulateStream S hk (winRead (windowsOf x)) initial 0 (A.code hk coins)).bind
        (Games.finishHonest hk)

/-- THE tape-parametrized EUF game (`Games.AdvEUF` with the sampler law mapped
through `tau`): the `simulateLazy`/`lazyGame` execution of `A`'s program whose
signing oracle runs the real `Games.Sampler.code` on the per-call windows of
ONE whole-run tape drawn from `tau` (the one-stream reading at total width
`tapeWidth beta S = beta.qs * S.bits`). At `tau = Law.uniform` this IS
`lazyGame` in law (`streamGame_uniform`), whose win event is
`Games.AdvMT (beta.qh+1) muH (Reduction.build beta A S)`
(`streamGame_uniform_eq_advMT`). -/
noncomputable def streamGame (beta : Budget) (muH : Law FT1536.Relation.Rq)
    (A : ClassicalAdversary beta) (S : Sampler)
    (tau : Law (Fin (tapeWidth beta S) → Bool)) : FT1536.Run2.Dist Bool :=
  (FT1536.Run2.Dist.draw tau).bind (streamCont beta muH A S)

/-- THE real-stream EUF advantage of `A`: the win probability of the
tape-parametrized game at the real stream law `tau`
(`AdvPrg.frngTapeLaw seed (tapeWidth beta S)`). -/
noncomputable def AdvEUFStream (beta : Budget) (muH : Law FT1536.Relation.Rq)
    (A : ClassicalAdversary beta) (S : Sampler)
    (tau : Law (Fin (tapeWidth beta S) → Bool)) : ℝ :=
  (streamGame beta muH A S tau).event (fun b => b = true)

/-- THE composed winning event of the stream game at the tape — the named
membership object of `CompWinCert`. -/
noncomputable def streamWinTest (beta : Budget) (muH : Law FT1536.Relation.Rq)
    (A : ClassicalAdversary beta) (S : Sampler) :
    CompTest (Fin (tapeWidth beta S) → Bool) :=
  winFun (streamCont beta muH A S) (fun b => b = true)

/-! ## 4. The window-table split and the fair-tape identification -/

/-- The measure-preserving relabeling behind the window-table split:
`(t, w) ↦ (update w j t, w j)` — inserting an independent uniform window at
position `j` leaves the uniform table uniform. -/
def updateEquiv {k m : ℕ} (j : Fin k) :
    ((Fin m → Bool) × (Fin k → (Fin m → Bool))) ≃
      ((Fin k → (Fin m → Bool)) × (Fin m → Bool)) where
  toFun z := (Function.update z.2 j z.1, z.2 j)
  invFun z := (z.1 j, Function.update z.1 j z.2)
  left_inv z := by
    obtain ⟨t, w⟩ := z
    apply Prod.ext
    · simp [Function.update]
    · funext i
      by_cases h : i = j
      · simp [Function.update, h]
      · simp [Function.update, h]
  right_inv z := by
    obtain ⟨w, t⟩ := z
    apply Prod.ext
    · funext i
      by_cases h : i = j
      · simp [Function.update, h]
      · simp [Function.update, h]
    · simp [Function.update]

/-- Fiber counting at a fixed window position: inserting an independent
window and averaging costs exactly the window space. -/
theorem sum_update_fiberwise {k m : ℕ} (j : Fin k) (f : (Fin k → (Fin m → Bool)) → ℝ) :
    (∑ t : Fin m → Bool, ∑ w : Fin k → (Fin m → Bool), f (Function.update w j t))
      = (Fintype.card (Fin m → Bool) : ℝ) * ∑ w : Fin k → (Fin m → Bool), f w := by
  classical
  have h1 : (∑ t : Fin m → Bool, ∑ w : Fin k → (Fin m → Bool), f (Function.update w j t))
      = ∑ z : (Fin m → Bool) × (Fin k → (Fin m → Bool)), f (Function.update z.2 j z.1) := by
    have hp := Finset.sum_product (s := (Finset.univ : Finset (Fin m → Bool)))
      (t := (Finset.univ : Finset (Fin k → (Fin m → Bool))))
      (fun z => f (Function.update z.2 j z.1))
    have hpu : (Finset.univ : Finset (Fin m → Bool)) ×ˢ Finset.univ
        = (Finset.univ : Finset ((Fin m → Bool) × (Fin k → (Fin m → Bool)))) :=
      Finset.univ_product_univ
    rw [hpu] at hp
    exact hp.symm
  have h2 : (∑ z : (Fin m → Bool) × (Fin k → (Fin m → Bool)), f (Function.update z.2 j z.1))
      = ∑ z' : (Fin k → (Fin m → Bool)) × (Fin m → Bool), f z'.1 := by
    apply Finset.sum_bij (fun z _ => updateEquiv (k := k) (m := m) j z)
    · intro z _; exact Finset.mem_univ _
    · intro z₁ _ z₂ _ he; exact (updateEquiv (k := k) (m := m) j).injective he
    · intro z' _
      exact ⟨(updateEquiv (k := k) (m := m) j).symm z', Finset.mem_univ _,
        (updateEquiv (k := k) (m := m) j).right_inv z'⟩
    · intro z _; rfl
  have h3 : (∑ z' : (Fin k → (Fin m → Bool)) × (Fin m → Bool), f z'.1)
      = (∑ w : Fin k → (Fin m → Bool), ∑ _t : Fin m → Bool, f w) := by
    have hp := Finset.sum_product (s := (Finset.univ : Finset (Fin k → (Fin m → Bool))))
      (t := (Finset.univ : Finset (Fin m → Bool)))
      (fun z => f z.1)
    have hpu : (Finset.univ : Finset (Fin k → (Fin m → Bool))) ×ˢ Finset.univ
        = (Finset.univ : Finset ((Fin k → (Fin m → Bool)) × (Fin m → Bool))) :=
      Finset.univ_product_univ
    rw [hpu] at hp
    exact hp
  have h4 : (∑ w : Fin k → (Fin m → Bool), ∑ _t : Fin m → Bool, f w)
      = ∑ w : Fin k → (Fin m → Bool), (Fintype.card (Fin m → Bool) : ℝ) * f w := by
    apply Finset.sum_congr rfl
    intro w _
    rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
  rw [h1, h2, h3, h4, ← Finset.mul_sum]

/-- THE window-table split (the one-stream factorization): the uniform table
draw can be peeled into a fresh uniform window at position `j` plus an
independent uniform table with that window overwritten. -/
theorem uniform_table_split {k m : ℕ} (j : Fin k) {α : Type}
    (H : (Fin m → Bool) → (Fin k → (Fin m → Bool)) → FT1536.Run2.Dist α) :
    ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin k → (Fin m → Bool)))).bind fun w =>
      H (winRead w j) w).Same
    ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin m → Bool))).bind fun t =>
      (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin k → (Fin m → Bool)))).bind fun w =>
        H t (Function.update w j t)) := by
  intro F
  simp only [Dist.expect_bind]
  set g : (Fin k → (Fin m → Bool)) → ℝ := fun w => (H (winRead w j) w).expect F with hg
  have hrew : ∀ (t : Fin m → Bool) (w : Fin k → (Fin m → Bool)),
      (H t (Function.update w j t)).expect F = g (Function.update w j t) := by
    intro t w
    show (H t (Function.update w j t)).expect F
      = (H (winRead (Function.update w j t) j) (Function.update w j t)).expect F
    rw [winRead_update_same]
  simp_rw [hrew]
  show (∑ w : Fin k → (Fin m → Bool),
      ((1 : ℝ) / Fintype.card (Fin k → (Fin m → Bool))) * g w)
    = (∑ t : Fin m → Bool,
      ((1 : ℝ) / Fintype.card (Fin m → Bool))
        * (∑ w : Fin k → (Fin m → Bool),
          ((1 : ℝ) / Fintype.card (Fin k → (Fin m → Bool)))
            * g (Function.update w j t)))
  simp_rw [← Finset.mul_sum]
  rw [sum_update_fiberwise j g]
  have hcm : (Fintype.card (Fin m → Bool) : ℝ) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  have key : ((1 : ℝ) / Fintype.card (Fin m → Bool))
      * (((1 : ℝ) / Fintype.card (Fin k → (Fin m → Bool)))
        * ((Fintype.card (Fin m → Bool) : ℝ) * ∑ w : Fin k → (Fin m → Bool), g w))
      = ((1 : ℝ) / Fintype.card (Fin k → (Fin m → Bool)))
        * ∑ w : Fin k → (Fin m → Bool), g w := by
    calc ((1 : ℝ) / Fintype.card (Fin m → Bool))
          * (((1 : ℝ) / Fintype.card (Fin k → (Fin m → Bool)))
            * ((Fintype.card (Fin m → Bool) : ℝ) * ∑ w : Fin k → (Fin m → Bool), g w))
        = (((1 : ℝ) / Fintype.card (Fin m → Bool)) * (Fintype.card (Fin m → Bool) : ℝ))
          * (((1 : ℝ) / Fintype.card (Fin k → (Fin m → Bool)))
            * ∑ w : Fin k → (Fin m → Bool), g w) := by ring
      _ = ((1 : ℝ) / Fintype.card (Fin k → (Fin m → Bool)))
          * ∑ w : Fin k → (Fin m → Bool), g w := by
        rw [div_mul_cancel₀ _ hcm, one_mul]
  exact key.symm

/-- The window read of one fair per-call tape is the fair sampler tape: the
`Games.signSim` head at one call. -/
theorem signSimAt_uniform (S : Sampler) (h : FT1536.Relation.Rq) (st : State) (m : Bytes) :
    ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
      signSimAt S t h st m).Same (Games.signSim S h st m) := by
  have haux : ∀ r : Nonce,
      ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
        (match ROM.lookup (parse (frame r m)) (Games.submitted m st).table with
          | some _ => FT1536.Run2.Dist.pure none
          | none => (FT1536.Run2.Dist.pure (S.code h (Games.submitted m st) m r t)).map
              (Games.programmedReply (Games.submitted m st) m r) :
          FT1536.Run2.Dist (Option (Reply × State)))).Same
      (match ROM.lookup (parse (frame r m)) (Games.submitted m st).table with
        | some _ => FT1536.Run2.Dist.pure none
        | none => ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).map
            (S.code h (Games.submitted m st) m r)).map
            (Games.programmedReply (Games.submitted m st) m r)) := by
    intro r
    cases ROM.lookup (parse (frame r m)) (Games.submitted m st).table with
    | some e => exact bind_const_same _ _
    | none =>
      have hmap : ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
          (FT1536.Run2.Dist.pure (S.code h (Games.submitted m st) m r t)).map
            (Games.programmedReply (Games.submitted m st) m r)).Same
          (((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
            FT1536.Run2.Dist.pure (S.code h (Games.submitted m st) m r t)).map
            (Games.programmedReply (Games.submitted m st) m r)) :=
        same_symm' _ _ (same_map_bind _ _ _)
      have hpure : ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
          FT1536.Run2.Dist.pure (S.code h (Games.submitted m st) m r t)).Same
          ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).map
            (S.code h (Games.submitted m st) m r)) :=
        same_symm' _ _ (Assembly.map_eq_bind_pure
          (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool)))
          (S.code h (Games.submitted m st) m r))
      exact same_trans' _ _ _ hmap
        (same_map _ _ _ hpure)
  have hswap : ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
      (FT1536.Run2.Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
        (match ROM.lookup (parse (frame r m)) (Games.submitted m st).table with
          | some _ => FT1536.Run2.Dist.pure none
          | none => (FT1536.Run2.Dist.pure (S.code h (Games.submitted m st) m r t)).map
              (Games.programmedReply (Games.submitted m st) m r) :
          FT1536.Run2.Dist (Option (Reply × State)))).Same
      ((FT1536.Run2.Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
        (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
          (match ROM.lookup (parse (frame r m)) (Games.submitted m st).table with
            | some _ => FT1536.Run2.Dist.pure none
            | none => (FT1536.Run2.Dist.pure (S.code h (Games.submitted m st) m r t)).map
                (Games.programmedReply (Games.submitted m st) m r) :
            FT1536.Run2.Dist (Option (Reply × State)))) :=
    Dist.bind_comm _ _ _
  have hcong : ((FT1536.Run2.Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
      (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
        (match ROM.lookup (parse (frame r m)) (Games.submitted m st).table with
          | some _ => FT1536.Run2.Dist.pure none
          | none => (FT1536.Run2.Dist.pure (S.code h (Games.submitted m st) m r t)).map
              (Games.programmedReply (Games.submitted m st) m r) :
          FT1536.Run2.Dist (Option (Reply × State)))).Same
      ((FT1536.Run2.Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
        match ROM.lookup (parse (frame r m)) (Games.submitted m st).table with
        | some _ => FT1536.Run2.Dist.pure none
        | none => ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).map
            (S.code h (Games.submitted m st) m r)).map
            (Games.programmedReply (Games.submitted m st) m r)) :=
    same_bind_congr _ _ _ haux
  have hleft : ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
      signSimAt S t h st m)
      = ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
        (FT1536.Run2.Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
          (match ROM.lookup (parse (frame r m)) (Games.submitted m st).table with
            | some _ => FT1536.Run2.Dist.pure none
            | none => (FT1536.Run2.Dist.pure (S.code h (Games.submitted m st) m r t)).map
                (Games.programmedReply (Games.submitted m st) m r) :
            FT1536.Run2.Dist (Option (Reply × State)))) := rfl
  have hright : ((FT1536.Run2.Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
      match ROM.lookup (parse (frame r m)) (Games.submitted m st).table with
      | some _ => FT1536.Run2.Dist.pure none
      | none => ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).map
          (S.code h (Games.submitted m st) m r)).map
          (Games.programmedReply (Games.submitted m st) m r))
      = Games.signSim S h st m := rfl
  rw [hleft, ← hright]
  exact same_trans' _ _ _ hswap hcong

/-- The tape reads of `simulateStream` past call `i` do not depend on the
windows `0 .. i-1`. -/
theorem simulateStream_congr (S : Sampler) (h : FT1536.Relation.Rq)
    (win' win : ℕ → (Fin S.bits → Bool)) (st : State) (i : ℕ) {s q : ℕ} (p : Program s q)
    (hwin : ∀ j, i ≤ j → win' j = win j) :
    simulateStream S h win' st i p = simulateStream S h win st i p := by
  induction p generalizing st i with
  | done f => rfl
  | hash x c ih =>
    simp only [simulateStream]
    congr 1
    funext co
    exact ih co.1 (Games.recordedHash x co.1 co.2) i (fun j hj => hwin j hj)
  | sign m c ih =>
    simp only [simulateStream]
    have hhead : win' i = win i := hwin i le_rfl
    rw [hhead]
    congr 1
    funext o
    cases o with
    | none => rfl
    | some os =>
      exact ih os.1 os.2 (i + 1) (fun j hj => hwin j (Nat.le_trans (Nat.le_succ i) hj))

/-- THE fair-tape identification (kernelized): running the stream game on one
FAIR whole-run tape is `Run2.simulateLazy` — each executed call reads an
independent fair window (the `uniform_table_split` factorization), so the
one-stream game at `tau = Law.uniform` is the per-call fair game. -/
theorem simulateStream_uniform (S : Sampler) (k : ℕ) (h : FT1536.Relation.Rq) :
    ∀ {s q : ℕ} (p : Program s q) (st : State) (i : ℕ), i + s ≤ k →
      ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind fun w =>
        simulateStream S h (winRead w) st i p).Same (simulateLazy S h st p) := by
  intro s q p
  induction p with
  | done f =>
    intro st i hbound
    exact bind_const_same _ _
  | hash x c ih =>
    intro st i hbound
    have hswap : ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind
        fun w => (Games.hashHonest x st).bind fun co =>
          simulateStream S h (winRead w) (Games.recordedHash x co.1 co.2) i (c co.1))
        |>.Same
        ((Games.hashHonest x st).bind fun co =>
          (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind fun w =>
            simulateStream S h (winRead w) (Games.recordedHash x co.1 co.2) i (c co.1)) :=
      Dist.bind_comm _ _ _
    have hcong : ((Games.hashHonest x st).bind fun co =>
        (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind fun w =>
          simulateStream S h (winRead w) (Games.recordedHash x co.1 co.2) i (c co.1))
        |>.Same
        ((Games.hashHonest x st).bind fun co =>
          simulateLazy S h (Games.recordedHash x co.1 co.2) (c co.1)) :=
      same_bind_congr _ _ _ (fun co => ih co.1 (Games.recordedHash x co.1 co.2) i hbound)
    have hleft : ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind
        fun w => simulateStream S h (winRead w) st i (Program.hash x c))
        = ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind
          fun w => (Games.hashHonest x st).bind fun co =>
            simulateStream S h (winRead w) (Games.recordedHash x co.1 co.2) i (c co.1)) := rfl
    have hright : (simulateLazy S h st (Program.hash x c))
        = ((Games.hashHonest x st).bind fun co =>
          simulateLazy S h (Games.recordedHash x co.1 co.2) (c co.1)) := rfl
    rw [hleft, hright]
    exact same_trans' _ _ _ hswap hcong
  | sign m c ih =>
    intro st i hbound
    have hi : i < k := by omega
    have hjv : ((⟨i, hi⟩ : Fin k) : ℕ) = i := rfl
    -- unfolding equations for the executors at one sign token
    have hstream : ∀ (win : ℕ → (Fin S.bits → Bool)) (st' : State),
        simulateStream S h win st' i (Program.sign m c)
        = ((signSimAt S (win i) h st' m).bind fun o => match o with
          | none => FT1536.Run2.Dist.pure none
          | some os => simulateStream S h win os.2 (i + 1) (c os.1)) := by
      intro win st'
      simp only [simulateStream]
    have hlazy : (simulateLazy S h st (Program.sign m c))
        = ((Games.signSim S h st m).bind fun o => match o with
          | none => FT1536.Run2.Dist.pure none
          | some os => simulateLazy S h os.2 (c os.1)) := by
      simp only [simulateLazy]
      rfl
    -- (a) peel window `i` off the uniform table draw
    let H : (Fin S.bits → Bool) → (Fin k → (Fin S.bits → Bool))
        → FT1536.Run2.Dist (Option Games.Finished) := fun t w =>
      (signSimAt S t h st m).bind fun o => match o with
        | none => FT1536.Run2.Dist.pure none
        | some os => simulateStream S h (winRead w) os.2 (i + 1) (c os.1)
    have hsplit : ((FT1536.Run2.Dist.draw
        (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind fun w =>
        H (winRead w i) w).Same
        ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
          (FT1536.Run2.Dist.draw
            (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind fun w =>
            H t (Function.update w ⟨i, hi⟩ t)) :=
      uniform_table_split (k := k) (m := S.bits) ⟨i, hi⟩ H
    -- (b) the overwritten table drives the same continuation
    have htail : ∀ (t : Fin S.bits → Bool) (w : Fin k → (Fin S.bits → Bool)),
        H t (Function.update w ⟨i, hi⟩ t) = H t w := by
      intro t w
      show (signSimAt S t h st m).bind _
        = (signSimAt S t h st m).bind _
      congr 1
      funext o
      cases o with
      | none => rfl
      | some os =>
        refine simulateStream_congr S h (winRead (Function.update w ⟨i, hi⟩ t)) (winRead w)
          os.2 (i + 1) (c os.1) ?_
        intro j' hj'
        exact winRead_update_ne w ⟨i, hi⟩ t (by omega)
    -- (c) peel the table draw past the window draw
    have hsplit' : ((FT1536.Run2.Dist.draw
        (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind fun w =>
        H (winRead w i) w).Same
        ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
          (signSimAt S t h st m).bind fun o =>
            (FT1536.Run2.Dist.draw
              (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind fun w =>
              match o with
                | none => FT1536.Run2.Dist.pure none
                | some os => simulateStream S h (winRead w) os.2 (i + 1) (c os.1)) := by
      refine same_trans' _ _ _ hsplit ?_
      refine same_bind_congr _ _ _ (fun t => ?_)
      refine same_trans' _ _ _
        (same_bind_congr _ _ _ (fun w => same_of_eq _ _ (htail t w))) ?_
      exact Dist.bind_comm _ _ _
    -- (d) the fair-window head is `Games.signSim`
    have hhead2 : ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
        (signSimAt S t h st m).bind fun o =>
          (FT1536.Run2.Dist.draw
            (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind fun w =>
            match o with
              | none => FT1536.Run2.Dist.pure none
              | some os => simulateStream S h (winRead w) os.2 (i + 1) (c os.1))
        |>.Same
        ((FT1536.Run2.Dist.draw (Law.uniform : Law (Fin S.bits → Bool))).bind fun t =>
          (Games.signSim S h st m).bind fun o =>
            (FT1536.Run2.Dist.draw
              (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind fun w =>
              match o with
                | none => FT1536.Run2.Dist.pure none
                | some os => simulateStream S h (winRead w) os.2 (i + 1) (c os.1)) := by
      refine same_trans' _ _ _
        (same_symm' _ _ (Dist.bind_assoc _ _ _)) ?_
      refine same_trans' _ _ _
        (same_bind_same_left _ _ _ (signSimAt_uniform S h st m)) ?_
      exact same_symm' _ _ (bind_const_same _ _)
    -- (e) the tails are `simulateLazy` by the induction hypothesis
    have htail2 : ((Games.signSim S h st m).bind fun o =>
        (FT1536.Run2.Dist.draw
          (Law.uniform : Law (Fin k → (Fin S.bits → Bool)))).bind fun w =>
          match o with
            | none => FT1536.Run2.Dist.pure none
            | some os => simulateStream S h (winRead w) os.2 (i + 1) (c os.1))
        |>.Same
        ((Games.signSim S h st m).bind fun o => match o with
          | none => FT1536.Run2.Dist.pure none
          | some os => simulateLazy S h os.2 (c os.1)) := by
      refine same_bind_congr _ _ _ (fun o => ?_)
      cases o with
      | none => exact bind_const_same _ _
      | some os => exact ih os.1 os.2 (i + 1) (by omega)
    -- (f) assemble
    simp_rw [hstream]
    rw [hlazy]
    refine same_trans' _ _ _ hsplit' ?_
    refine same_trans' _ _ _ hhead2 ?_
    exact same_trans' _ _ _ (bind_const_same _ _) htail2

/-- THE real-stream game on the fair tape IS `Run2.lazyGame` (the
tape-parametrized game at `tau = Law.uniform`): one fair whole-run tape
split into per-call windows is a sequence of independent fair per-call
tapes. -/
theorem streamGame_uniform (beta : Budget) (muH : Law FT1536.Relation.Rq)
    (A : ClassicalAdversary beta) (S : Sampler) :
    (streamGame beta muH A S (Law.uniform : Law (Fin (tapeWidth beta S) → Bool)))
      |>.Same (lazyGame beta muH A S) := by
  -- (1) the flat fair tape becomes the fair window table
  have hflat : (streamGame beta muH A S (Law.uniform : Law (Fin (tapeWidth beta S) → Bool)))
      |>.Same
      ((FT1536.Run2.Dist.draw
          (Law.uniform : Law (Fin beta.qs → (Fin S.bits → Bool)))).bind fun w =>
        (FT1536.Run2.Dist.draw muH).bind fun hk =>
          (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
            (simulateStream S hk (winRead w) initial 0 (A.code hk coins)).bind
              (Games.finishHonest hk)) :=
    draw_uniform_windowsOf (k := beta.qs) (m := S.bits)
      (fun w => (FT1536.Run2.Dist.draw muH).bind fun hk =>
        (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
          (simulateStream S hk (winRead w) initial 0 (A.code hk coins)).bind
            (Games.finishHonest hk))
  -- (2) reorder the table draw past the key and coin draws
  have hswap : ((FT1536.Run2.Dist.draw
      (Law.uniform : Law (Fin beta.qs → (Fin S.bits → Bool)))).bind fun w =>
      (FT1536.Run2.Dist.draw muH).bind fun hk =>
        (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
          (simulateStream S hk (winRead w) initial 0 (A.code hk coins)).bind
            (Games.finishHonest hk))
      |>.Same
      ((FT1536.Run2.Dist.draw muH).bind fun hk =>
        (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
          (FT1536.Run2.Dist.draw
            (Law.uniform : Law (Fin beta.qs → (Fin S.bits → Bool)))).bind fun w =>
            (simulateStream S hk (winRead w) initial 0 (A.code hk coins)).bind
              (Games.finishHonest hk)) := by
    refine same_trans' _ _ _ (Dist.bind_comm _ _ _) ?_
    refine same_bind_congr _ _ _ (fun hk => ?_)
    exact Dist.bind_comm _ _ _
  -- (3) each run is `simulateLazy` under one table draw
  have hcore : ((FT1536.Run2.Dist.draw muH).bind fun hk =>
      (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
        (FT1536.Run2.Dist.draw
          (Law.uniform : Law (Fin beta.qs → (Fin S.bits → Bool)))).bind fun w =>
          (simulateStream S hk (winRead w) initial 0 (A.code hk coins)).bind
            (Games.finishHonest hk))
      |>.Same
      ((FT1536.Run2.Dist.draw muH).bind fun hk =>
        (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
          (simulateLazy S hk initial (A.code hk coins)).bind (Games.finishHonest hk)) := by
    refine same_bind_congr _ _ _ (fun hk => ?_)
    refine same_bind_congr _ _ _ (fun coins => ?_)
    have hiw : (0 : ℕ) + beta.qs ≤ beta.qs := by omega
    have hih := simulateStream_uniform S beta.qs hk (A.code hk coins) initial 0 hiw
    exact same_trans' _ _ _ (same_symm' _ _ (Dist.bind_assoc _ _ (Games.finishHonest hk)))
      (same_bind_same_left _ _ (Games.finishHonest hk) hih)
  have hfin : ((FT1536.Run2.Dist.draw muH).bind fun hk =>
      (FT1536.Run2.Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
        (simulateLazy S hk initial (A.code hk coins)).bind (Games.finishHonest hk))
      = lazyGame beta muH A S := rfl
  have hall := same_trans' _ _ _ hflat (same_trans' _ _ _ hswap hcore)
  rw [hfin] at hall
  exact hall

/-- THE fair-tape identification at the win event: the fair-tape side of the
real-stream game is exactly `Games.AdvMT (beta.qh+1) muH (Reduction.build
beta A S)` (via `Run2.concrete_lazy_game_binding` — the reducer's success
game IS the sampler-oracle EUF game). -/
theorem streamGame_uniform_eq_advMT (beta : Budget) (muH : Law FT1536.Relation.Rq)
    (A : ClassicalAdversary beta) (S : Sampler) :
    (streamGame beta muH A S (Law.uniform : Law (Fin (tapeWidth beta S) → Bool))).event
        (fun b => b = true)
      = Games.AdvMT (beta.qh + 1) muH (Reduction.build beta A S) := by
  have h1 := Dist.same_event _ _ (streamGame_uniform beta muH A S) (fun b => b = true)
  have h2 := (Dist.same_event _ _ (concrete_lazy_game_binding beta muH A S)
    (fun b => b = true)).symm
  exact h1.trans h2

/-! ## 5. The chained hop for the real-stream game -/

/-- THE chained hop (goal 2 of the task), two-sided form: under the named
computational assumption `CompPRGBound C tau delta` and the MEMBERSHIP of the
composed winning event (`CompWinCert.mem` with its resource accounting line),
the real-stream EUF advantage and the fair-tape game move by at most `delta`.
This is `Assembly.tape_game_hop_abs` applied to the WINNING EVENT of `A` —
at winning-probability level, FOR THE ADMITTED CLASS ONLY. -/
theorem stream_game_hop_abs (beta : Budget) (muH : Law FT1536.Relation.Rq)
    (A : ClassicalAdversary beta) (S : Sampler)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool)))
    (tau : Law (Fin (tapeWidth beta S) → Bool)) (delta : ℝ)
    (hcomp : CompPRGBound C tau delta) (hwin : streamWinTest beta muH A S ∈ C) :
    |AdvEUFStream beta muH A S tau
      - AdvEUFStream beta muH A S (Law.uniform : Law (Fin (tapeWidth beta S) → Bool))| ≤ delta :=
  comp_game_hop_abs C tau delta hcomp (streamCont beta muH A S) (fun b => b = true) hwin

/-- The chained hop, real-stream side. -/
theorem stream_game_hop (beta : Budget) (muH : Law FT1536.Relation.Rq)
    (A : ClassicalAdversary beta) (S : Sampler)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool)))
    (tau : Law (Fin (tapeWidth beta S) → Bool)) (delta : ℝ)
    (hcomp : CompPRGBound C tau delta) (hwin : streamWinTest beta muH A S ∈ C) :
    AdvEUFStream beta muH A S tau ≤
      AdvEUFStream beta muH A S (Law.uniform : Law (Fin (tapeWidth beta S) → Bool)) + delta :=
  comp_game_hop C tau delta hcomp (streamCont beta muH A S) (fun b => b = true) hwin

/-- The chained hop, fair-tape side (the direction the `Phi` inversion
consumes). -/
theorem stream_game_hop_symm (beta : Budget) (muH : Law FT1536.Relation.Rq)
    (A : ClassicalAdversary beta) (S : Sampler)
    (C : Set (CompTest (Fin (tapeWidth beta S) → Bool)))
    (tau : Law (Fin (tapeWidth beta S) → Bool)) (delta : ℝ)
    (hcomp : CompPRGBound C tau delta) (hwin : streamWinTest beta muH A S ∈ C) :
    AdvEUFStream beta muH A S (Law.uniform : Law (Fin (tapeWidth beta S) → Bool)) ≤
      AdvEUFStream beta muH A S tau + delta :=
  comp_game_hop_symm C tau delta hcomp (streamCont beta muH A S) (fun b => b = true) hwin

end FT1536.CompPrg

