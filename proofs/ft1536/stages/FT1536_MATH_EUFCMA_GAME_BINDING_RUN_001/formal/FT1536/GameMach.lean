import FT1536.GameNames
import FT1536.Model
import FT1536.PublicCode
import FT1536.Relation
import FT1536.Collision

/-! # Game machine and the three interpreters (task Etap A)

One parameterized step function with mode-dependent branches realises the
three experiments of the task:

* `real` — EUF_real: a Sign-name hit reuses the existing entry (ordinary
  honest game at a conflict; the body answer is sampled at the cached `c`);
* `stopped` — EUF_stopped: a Sign-name hit stops the game without a win
  (internal absorbing STOP, never a returned PRE/POST_ABORT);
* `sim` — SIM_targets: Sign answers are programmed through the public
  sampler S output `(c,o)`, fresh H answers are the input target vector.

Sign queries are atomic: the operation carries the fully fixed message and
the machine draws the salt afterwards (no reentrancy, no half-open nonce).
`ROM.submit` records the message before any branch, so SeenSign covers
aborted Sign calls. H answers, SeenSign and table bookkeeping are shared code
across all modes (shared steps have literally the same kernel in the law
layer).

H steps and the final read delegate to `ROM.hash` over one fixed per-run
target function; Sign programming consumes no target. The reply alphabet
`Reply` is finite whenever `C` is; adversary operations are deterministic
functions of the reply history and are not part of the random alphabet.
No `sorry` in this module. -/

namespace FT1536.GameMach
open GameByte GameNames PublicSimulation

/-- Budget of a bounded classical adversary (Etap A: finite alphabets follow
from explicit budgets). -/
structure Budget where
  QH : ℕ
  Qs : ℕ
  maxSteps : ℕ
  maxName : ℕ
  maxMsg : ℕ

/-- Experiment mode. -/
inductive Mode where
  | real
  | stopped
  | sim
  deriving DecidableEq

/-- Observable reply of one machine step. The verdict is a derived output of
the program (all three programs compute it identically on shared steps). -/
inductive Reply (C : Type) where
  | hval (c : C)
  | sign (c : C) (o : MathSign.Observation GameByte.Nonce BoxVec)
  | verdict (win : Bool) (c : C)
  | halt
  deriving DecidableEq

/-- Adversary operation after the byte front-end. Sign queries carry the
fully fixed message before any salt. -/
inductive Op where
  | hq (k : NameKind)
  | sq (m : Message)
  | fin (r : GameByte.Nonce) (m : Message) (sig : BoxVec)

/-- Per-step environment randomness: the uniform challenge fill for the
honest Sign kernel at a fresh name, the fresh salt, the honest signer body
answers indexed by challenge `c`, and the public sampler output `(c,o)`. -/
structure Env (C : Type) where
  freshC : C
  nonce : GameByte.Nonce
  body : C → Option BoxVec
  simOut : C × Option BoxVec

/-- Physical machine state. -/
structure Mach (C : Type) where
  st : ROM.State NameBody Message C
  mode : Mode
  stopped : Bool
  over : Bool
  hq : ℕ
  sq : ℕ

variable {C : Type}

def init (mode : Mode) : Mach C :=
  ⟨ROM.empty, mode, false, false, 0, 0⟩

/-- Decode a signature for verification: `BoxVec -> Vec` is the enclosing-box
decoder. Winning signatures are always in signed16 (Verify includes signed16),
hence inside this box: the restriction to `BoxVec` is win-neutral. -/
def sigVec (s : BoxVec) : Geometry.Vec := decodeVec s

/-- Final verdict function: validity of the forgery against public `h` and the
challenge value `c` of the forged name. -/
abbrev Verdict (C : Type) := C → Message → Geometry.Vec → Bool

/-- One Sign query. The message has already been recorded by `submit`, and
the salt is read only here: the query is atomic. -/
def signStep (mode : Mode) (st : ROM.State NameBody Message C)
    (r : GameByte.Nonce) (m : Message) (env : Env C) :
    ROM.State NameBody Message C × Reply C × Bool :=
  match ROM.lookup (tableAddr (signName r m)) st with
  | some e =>
    match mode with
    | .real => (st, .sign e.value (some (r, env.body e.value)), false)
    | .stopped => (st, .halt, true)
    | .sim => (st, .halt, true)
  | none =>
    match mode with
    | .real =>
      (⟨⟨tableAddr (signName r m), env.freshC, none⟩ :: st.table, st.seen, st.used⟩,
        .sign env.freshC (some (r, env.body env.freshC)), false)
    | .stopped =>
      (⟨⟨tableAddr (signName r m), env.freshC, none⟩ :: st.table, st.seen, st.used⟩,
        .sign env.freshC (some (r, env.body env.freshC)), false)
    | .sim =>
      (⟨⟨tableAddr (signName r m), env.simOut.1, none⟩ :: st.table, st.seen, st.used⟩,
        .sign env.simOut.1 (some (r, env.simOut.2)), false)

/-- One machine step given the run-wide target function (the input vector of
Etap B, read lazily) and the final verdict function. -/
def step (targets : ℕ → C) (verdict : Verdict C) (m : Mach C) (op : Op) (env : Env C) :
    Mach C × Reply C :=
  if m.stopped || m.over then (m, .halt)
  else
    match op with
    | .hq k =>
      ({m with st := (ROM.hash targets (tableAddr (render k)) m.st).2, hq := m.hq + 1},
        .hval (ROM.hash targets (tableAddr (render k)) m.st).1)
    | .sq msg =>
      let ss := signStep m.mode (ROM.submit msg m.st) env.nonce msg env
      ({m with st := ss.1, stopped := ss.2.2, sq := m.sq + 1}, ss.2.1)
    | .fin r msg sg =>
      ({m with st := (ROM.hash targets (tableAddr (signName r msg)) m.st).2, over := true},
        .verdict ((decide (msg ∉ (ROM.hash targets (tableAddr (signName r msg)) m.st).2.seen)) &&
          verdict (ROM.hash targets (tableAddr (signName r msg)) m.st).1 msg (sigVec sg))
          (ROM.hash targets (tableAddr (signName r msg)) m.st).1)

/-- Open form of `step` for a machine that has not stopped. -/
theorem step_eq (targets : ℕ → C) (verdict : Verdict C) (m : Mach C) (op : Op) (env : Env C)
    (h : m.stopped = false ∧ m.over = false) :
    step targets verdict m op env =
      match op with
      | .hq k =>
        ({m with st := (ROM.hash targets (tableAddr (render k)) m.st).2, hq := m.hq + 1},
          .hval (ROM.hash targets (tableAddr (render k)) m.st).1)
      | .sq msg =>
        let ss := signStep m.mode (ROM.submit msg m.st) env.nonce msg env
        ({m with st := ss.1, stopped := ss.2.2, sq := m.sq + 1}, ss.2.1)
      | .fin r msg sg =>
        ({m with st := (ROM.hash targets (tableAddr (signName r msg)) m.st).2, over := true},
          .verdict ((decide (msg ∉ (ROM.hash targets (tableAddr (signName r msg)) m.st).2.seen)) &&
            verdict (ROM.hash targets (tableAddr (signName r msg)) m.st).1 msg (sigVec sg))
            (ROM.hash targets (tableAddr (signName r msg)) m.st).1) := by
  unfold step
  simp [h.1, h.2]

/-- Budget-checked wrapper: exceeding the budget ends the bounded game with
`halt`; it never changes the game for an adversary that respects budgets. -/
def stepBounded (b : Budget) (targets : ℕ → C) (verdict : Verdict C)
    (m : Mach C) (op : Op) (env : Env C) : Mach C × Reply C :=
  if b.QH < m.hq ∨ b.Qs < m.sq ∨ b.maxSteps ≤ m.hq + m.sq then (m, .halt)
  else step targets verdict m op env

theorem stepBounded_eq_step_of_within (b : Budget) (targets : ℕ → C) (verdict : Verdict C)
    (m : Mach C) (op : Op) (env : Env C)
    (h : m.hq ≤ b.QH ∧ m.sq ≤ b.Qs ∧ m.hq + m.sq < b.maxSteps) :
    stepBounded b targets verdict m op env = step targets verdict m op env := by
  unfold stepBounded
  have hnc : ¬(b.QH < m.hq ∨ b.Qs < m.sq ∨ b.maxSteps ≤ m.hq + m.sq) := by omega
  simp [hnc]

/-- SeenSign is preserved by Sign bookkeeping on every branch. -/
theorem signStep_seen (mode : Mode) (st : ROM.State NameBody Message C)
    (r : GameByte.Nonce) (m : Message) (env : Env C) :
    (signStep mode st r m env).1.seen = st.seen := by
  unfold signStep
  cases ROM.lookup (tableAddr (signName r m)) st with
  | some e => cases mode <;> rfl
  | none => cases mode <;> rfl

/-- Sign programming never consumes a target: `used` is unchanged. -/
theorem signStep_used (mode : Mode) (st : ROM.State NameBody Message C)
    (r : GameByte.Nonce) (m : Message) (env : Env C) :
    (signStep mode st r m env).1.used = st.used := by
  unfold signStep
  cases ROM.lookup (tableAddr (signName r m)) st with
  | some e => cases mode <;> rfl
  | none => cases mode <;> rfl

/-- Every submitted message is in SeenSign after the Sign step, including
PRE/POST_ABORT branches and the internal STOP (ordinary freshness). -/
theorem step_sq_seen (targets : ℕ → C) (verdict : Verdict C) (m : Mach C)
    (msg : Message) (env : Env C)
    (h : m.stopped = false ∧ m.over = false) :
    msg ∈ (step targets verdict m (.sq msg) env).1.st.seen := by
  rw [step_eq targets verdict m (.sq msg) env h]
  show msg ∈ (signStep m.mode (ROM.submit msg m.st) env.nonce msg env).1.seen
  rw [signStep_seen]
  exact ROM.submitted_even_on_abort msg m.st

/-- STOP is internal and absorbing: no reply and no win are produced after it. -/
theorem stopped_absorbing (targets : ℕ → C) (verdict : Verdict C) (m : Mach C)
    (op : Op) (env : Env C) (h : m.stopped = true ∨ m.over = true) :
    step targets verdict m op env = (m, .halt) := by
  unfold step
  rcases h with h | h <;> simp [h]

/-- Sign queries are atomic: the message of the operation is fixed before the
salt is read; the salt enters only through `signStep`. -/
theorem sign_atomic (targets : ℕ → C) (verdict : Verdict C) (m : Mach C)
    (msg : Message) (env : Env C)
    (h : m.stopped = false ∧ m.over = false) :
    (step targets verdict m (.sq msg) env).2 =
      (signStep m.mode (ROM.submit msg m.st) env.nonce msg env).2.1 ∧
    (step targets verdict m (.sq msg) env).1.st =
      (signStep m.mode (ROM.submit msg m.st) env.nonce msg env).1 := by
  rw [step_eq targets verdict m (.sq msg) env h]
  exact ⟨rfl, rfl⟩

/-- Target counter grows by at most one on H steps and the final read; Sign
programming never consumes a target. -/
theorem used_le_of_step (targets : ℕ → C) (verdict : Verdict C) (m : Mach C)
    (op : Op) (env : Env C) :
    (step targets verdict m op env).1.st.used ≤ m.st.used + 1 := by
  by_cases hs : m.stopped = true ∨ m.over = true
  · rw [stopped_absorbing targets verdict m op env hs]
    exact Nat.le_succ _
  · have h : m.stopped = false ∧ m.over = false := by
      cases hst : m.stopped <;> cases hov : m.over <;> simp_all
    rw [step_eq targets verdict m op env h]
    cases op with
    | hq k => exact ROM.hash_used_le targets (tableAddr (render k)) m.st
    | sq msg =>
      show (signStep m.mode (ROM.submit msg m.st) env.nonce msg env).1.used ≤ _
      rw [signStep_used]
      exact Nat.le_succ _
    | fin r msg sg => exact ROM.hash_used_le targets (tableAddr (signName r msg)) m.st

/-- One Sign step: the table gains at most one entry. -/
theorem signStep_table (mode : Mode) (st : ROM.State NameBody Message C)
    (r : GameByte.Nonce) (m : Message) (env : Env C) :
    (signStep mode st r m env).1.table.length ≤ st.table.length + 1 := by
  unfold signStep
  cases ROM.lookup (tableAddr (signName r m)) st with
  | some e => cases mode <;> exact Nat.le_succ _
  | none => cases mode <;> exact le_rfl

/-- Fresh message plus accepted verdict: the forged message is not in
SeenSign. Together with `Reduction.indexed_extraction` this gives the
machine-level extraction event (Win -> MT witness at the exact index). -/
theorem verdict_fresh (targets : ℕ → C) (verdict : Verdict C) (m : Mach C)
    (r : GameByte.Nonce) (msg : Message) (sg : BoxVec) (env : Env C)
    (h : m.stopped = false ∧ m.over = false)
    (cv : C)
    (hv : (step targets verdict m (.fin r msg sg) env).2 = .verdict true cv) :
    msg ∉ (ROM.hash targets (tableAddr (signName r msg)) m.st).2.seen := by
  have hv2 : (msg ∉ (ROM.hash targets (tableAddr (signName r msg)) m.st).2.seen) ∧
      (verdict (ROM.hash targets (tableAddr (signName r msg)) m.st).1 msg (sigVec sg)) = true := by
    rw [step_eq targets verdict m (.fin r msg sg) env h] at hv
    have hv' := by simpa using hv
    exact hv'.1
  exact hv2.1

end FT1536.GameMach
