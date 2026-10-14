import Source3.KeygenSeedEntry089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSeedReplace089
open C99ArrayReference (State)
open C99ProcedureReference (Result Flow)
open C99IntegerReference (Value)
open KeygenRngProgram
open KeygenRngReference (Exec)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env)

def normalHead : Stmt → Bool
  | .skip | .init _ | .inject _ _ | .extractTmp | .flip | .setSeed _ _ _ | .storeFlag _ _ => true
  | _ => false

theorem normal_head_flow (ctx : Context) (code : Stmt) (before : State)
    (events : List KeygenEntropySource.Event) (out : Result)
    (normal : normalHead code = true) (source : Exec ctx code before events out) : out.flow = .normal := by
  cases code <;> simp only [normalHead, Bool.false_eq_true] at normal
  all_goals (cases source; rfl)

theorem normal_first (ctx : Context) (first rest : Stmt) (before : State)
    (events : List KeygenEntropySource.Event) (out : Result)
    (normal : normalHead first = true) (source : Exec ctx (.seq first rest) before events out) :
    ∃ middle early later,
      Exec ctx first before early ⟨middle, .normal⟩ ∧
      Exec ctx rest middle later out ∧ events = early ++ later := by
  cases source with
  | seqNormal a b before middle events1 events2 out first second =>
      exact ⟨middle, events1, events2, first, second, rfl⟩
  | seqExit a b before events out first exit =>
      exact (exit (normal_head_flow ctx _ _ _ _ normal first)).elim

def returnFlow (value : Option Nat) : Flow :=
  .returned (value.map (fun n => C99IntegerReference.convert .int32 n))

theorem chain_returns (ctx : Context) (leading : List Stmt) (value : Option Nat)
    (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (heads : ∀ code ∈ leading, normalHead code = true)
    (source : Exec ctx (chain (leading ++ [.ret value])) before events out) :
    out.flow = returnFlow value := by
  induction leading generalizing before events with
  | nil =>
      change Exec ctx (.seq (.ret value) .skip) before events out at source
      cases source with
      | seqNormal a b before middle events1 events2 out first second => cases first
      | seqExit a b before events out first exit => cases first; rfl
  | cons head tail ih =>
      change Exec ctx (.seq head (chain (tail ++ [.ret value]))) before events out at source
      obtain ⟨middle, early, later, first, rest, equal⟩ := normal_first ctx _ _ before events out
        (heads head (by simp)) source
      exact ih middle later (fun code member => heads code (by simp [member])) rest

def resetPrefix : List Stmt :=
  [.init (num 512), .inject "seed".toList len, .storeFlag .seeded (num 1), .storeFlag .flipped (num 0)]

theorem replacing_returns (ctx : Context) (before : State)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx replacing before events out) : out.flow = .returned none := by
  change Exec ctx (.scope (chain (resetPrefix ++ [.ret none]))) before events out at source
  cases source with
  | scope code before events out source =>
      exact chain_returns ctx resetPrefix none before events out
        (by intro code member; simp only [resetPrefix, List.mem_cons, List.not_mem_nil, or_false] at member
            rcases member with rfl | rfl | rfl | rfl <;> rfl) source

theorem scalar_variable (s : State) (name : List Char) (ty : C99IntegerReference.Ty) (v w : Value)
    (cell : s.locals name = some (ty, some v))
    (source : C99ArrayReference.scalar s (.var name) w) : w = v := by
  cases source with
  | «variable» name ty' w bound =>
      have equal := bound.symm.trans cell
      simp only [Option.some.injEq, Prod.mk.injEq] at equal
      exact equal.2

theorem replace_guard (env : Env) (base : State) (block : Nat) (seed : KeygenSeedEntry089.Seed)
    (v : Value) (source : C99ArrayReference.scalar (KeygenSeedEntry089.entry env base block seed)
      (.var "replace".toList) v) : v = .int32 1 :=
  scalar_variable _ _ .int32 (.int32 1) v rfl source

theorem selected_branch (env : Env) (base : State) (block : Nat) (seed : KeygenSeedEntry089.Seed)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec env.ctx (.branchScalar (.var "replace".toList) replacing .skip)
      (KeygenSeedEntry089.entry env base block seed) events out) :
    Exec env.ctx replacing (KeygenSeedEntry089.entry env base block seed) events out := by
  cases source with
  | branchScalarTrue condition yes no before events out v guard nonzero source => exact source
  | branchScalarFalse condition yes no before events out v guard zero source =>
      rw [replace_guard env base block seed v guard] at zero
      norm_num [Value.integer] at zero

/-- replace=1 selects the actual reset/inject/flag/void-return branch;
    the remix and later injection statements are not executed. -/
theorem set_seed_replacing (env : Env) (base : State) (block : Nat) (seed : KeygenSeedEntry089.Seed)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec env.ctx setSeedCode (KeygenSeedEntry089.entry env base block seed) events out) :
    Exec env.ctx replacing (KeygenSeedEntry089.entry env base block seed) events out := by
  change Exec env.ctx (.seq (.branchScalar (.var "replace".toList) replacing .skip)
    (chain [.branchFlag .flipped false remix .skip, .inject "seed".toList len]))
    (KeygenSeedEntry089.entry env base block seed) events out at source
  cases source with
  | seqNormal a b before middle early later out first rest =>
      have branch := selected_branch env base block seed early ⟨middle, .normal⟩ first
      have impossible := replacing_returns env.ctx (KeygenSeedEntry089.entry env base block seed) early ⟨middle, .normal⟩ branch
      cases impossible
  | seqExit a b before events out first exit =>
      exact selected_branch env base block seed events out first

theorem seeded_replacing (env : Env) (base : State) (block : Nat) (seed : KeygenSeedEntry089.Seed)
    (after : State) (source : KeygenSeedEntry089.Seeded env base block seed after) :
    ∃ out : Result, Exec env.ctx replacing (KeygenSeedEntry089.entry env base block seed) [] out ∧
      out.flow = .returned none ∧
      after = {KeygenSeedEntry089.caller base block seed with heap := out.state.heap} := by
  obtain ⟨out, body, returned, equal⟩ := KeygenSeedEntry089.seeded_body env base block seed after source
  exact ⟨out, set_seed_replacing env base block seed [] out body, returned, equal⟩

end FT1536.Source3.KeygenSeedReplace089
