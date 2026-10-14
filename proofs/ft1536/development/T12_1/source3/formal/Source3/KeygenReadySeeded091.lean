import Source3.KeygenSeedFlags089
import Source3.C99ArrayDeterminism089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenReadySeeded091
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenRngProgram
open KeygenRngReference (Exec)
open KeygenSearchContext (Context)

theorem flag_test (ctx : Context) (s : State) (flag : KeygenReadyFast.Flag) (word : BitVec 32) (v : Value)
    (known : Load32 s.heap (KeygenReadyFast.field ctx flag) word)
    (source : KeygenRngReference.FlagTest ctx s flag true v) :
    v = C99ScalarReference.boolean (decide ((Value.int32 word).integer = 0)) := by
  cases source with
  | load actual v read evaluated =>
      cases read with
      | load bound legal bytes =>
          have equal := Gate00Memory.load32_deterministic _ _ _ _ bytes known
          subst actual
          exact KeygenReadyFast.not_test s word v evaluated

theorem seed_stage (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (known : Load32 before.heap (KeygenReadyFast.field ctx .seeded) 1)
    (source : Exec ctx seedStage before events out) : out = ⟨before, .normal⟩ ∧ events = [] := by
  cases source with
  | branchFlagTrue flag negated yes no before events out v guard nonzero body =>
      have value := flag_test ctx before .seeded 1 v known guard
      rw [value] at nonzero
      norm_num [C99ScalarReference.boolean, Value.integer] at nonzero
  | branchFlagFalse flag negated yes no before events out v guard zero body =>
      cases body
      exact ⟨rfl, rfl⟩

def flipCommands : List Stmt := [.flip, .storeFlag .flipped (num 1)]

theorem flip_branch (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (known : Load32 before.heap (KeygenReadyFast.field ctx .flipped) 0)
    (source : Exec ctx flipStage before events out) :
    Exec ctx (.scope (chain flipCommands)) before events out := by
  cases source with
  | branchFlagTrue flag negated yes no before events out v guard nonzero body => exact body
  | branchFlagFalse flag negated yes no before events out v guard zero body =>
      have value := flag_test ctx before .flipped 0 v known guard
      rw [value] at zero
      norm_num [C99ScalarReference.boolean, Value.integer] at zero

theorem normal_chain (ctx : Context) (codes : List Stmt) (before : State)
    (events : List KeygenEntropySource.Event) (out : Result)
    (heads : ∀ code ∈ codes, KeygenSeedReplace089.normalHead code = true)
    (source : Exec ctx (chain codes) before events out) : out.flow = .normal := by
  induction codes generalizing before events with
  | nil => cases source; rfl
  | cons code rest ih =>
      obtain ⟨middle, early, later, first, tail, split⟩ :=
        KeygenSeedReplace089.normal_first ctx code (chain rest) before events out (heads code (by simp)) source
      exact ih middle later (fun c member => heads c (by simp [member])) tail

theorem flip_normal (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (known : Load32 before.heap (KeygenReadyFast.field ctx .flipped) 0)
    (source : Exec ctx flipStage before events out) : out.flow = .normal := by
  have branch := flip_branch ctx before events out known source
  cases branch
  exact normal_chain ctx flipCommands before events out
    (List.all_eq_true.mp (by decide : flipCommands.all KeygenSeedReplace089.normalHead = true)) (by assumption)

theorem flip_unique (ctx : Context) (before : State) (events1 events2 : List KeygenEntropySource.Event) (a b : Result)
    (known : Load32 before.heap (KeygenReadyFast.field ctx .flipped) 0)
    (first : Exec ctx flipStage before events1 a) (second : Exec ctx flipStage before events2 b) :
    a = b ∧ events1 = events2 := by
  have firstBody := flip_branch ctx before events1 a known first
  have secondBody := flip_branch ctx before events2 b known second
  cases firstBody
  cases secondBody
  exact KeygenSeedFunction089.chain_unique ctx flipCommands
    (List.all_eq_true.mp (by decide : flipCommands.all KeygenSeedFunction089.resetAtom = true))
    before events1 events2 a b (by assumption) (by assumption)

theorem flip_silent (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (known : Load32 before.heap (KeygenReadyFast.field ctx .flipped) 0)
    (source : Exec ctx flipStage before events out) : events = [] := by
  have branch := flip_branch ctx before events out known source
  cases branch
  exact KeygenSeedClosure089.chain_silent ctx flipCommands
    (List.all_eq_true.mp (by decide : flipCommands.all KeygenSeedFunction089.resetAtom = true))
    before events out (by assumption)

theorem last_return (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx (chain [.ret (some 1)]) before events out) :
    out = ⟨before, .returned (some (.int32 1))⟩ ∧ events = [] := by
  cases source with
  | seqNormal a b before middle early later out first second => cases first
  | seqExit a b before events out first exit => cases first; exact ⟨rfl, rfl⟩

theorem ready_path (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (seeded : Load32 before.heap (KeygenReadyFast.field ctx .seeded) 1)
    (flipped : Load32 before.heap (KeygenReadyFast.field ctx .flipped) 0)
    (source : Exec ctx readyCode before events out) :
    ∃ finished, Exec ctx flipStage before [] ⟨finished, .normal⟩ ∧
      out = ⟨finished, .returned (some (.int32 1))⟩ ∧ events = [] := by
  cases source with
  | seqExit a b before events out first exit =>
      have done := (seed_stage ctx before events out seeded first).1
      exact (exit (congrArg Result.flow done)).elim
  | seqNormal a b before middle early later out first rest =>
      obtain ⟨same, empty⟩ := seed_stage ctx before early ⟨middle, .normal⟩ seeded first
      have states := congrArg Result.state same
      change middle = before at states
      subst middle
      subst early
      cases rest with
      | seqExit a b before events out first exit => exact (exit (flip_normal ctx before _ out flipped first)).elim
      | seqNormal a b before finished flipEvents returnEvents out first last =>
          obtain ⟨result, emptyReturn⟩ := last_return ctx finished returnEvents out last
          have emptyFlip := flip_silent ctx before flipEvents ⟨finished, .normal⟩ flipped first
          subst flipEvents
          subst returnEvents
          exact ⟨finished, first, result, rfl⟩

theorem ready_unique (ctx : Context) (before : State) (events1 events2 : List KeygenEntropySource.Event) (a b : Result)
    (seeded : Load32 before.heap (KeygenReadyFast.field ctx .seeded) 1)
    (flipped : Load32 before.heap (KeygenReadyFast.field ctx .flipped) 0)
    (first : Exec ctx readyCode before events1 a) (second : Exec ctx readyCode before events2 b) :
    a = b ∧ events1 = events2 := by
  obtain ⟨sa, fa, ra, ea⟩ := ready_path ctx before events1 a seeded flipped first
  obtain ⟨sb, fb, rb, eb⟩ := ready_path ctx before events2 b seeded flipped second
  have states := congrArg Result.state (flip_unique ctx before [] [] _ _ flipped fa fb).1
  change sa = sb at states
  subst sb
  exact ⟨ra.trans rb.symm, ea.trans eb.symm⟩

end FT1536.Source3.KeygenReadySeeded091
