import Source3.KeygenSeedFunction089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSeedClosure089
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenRngProgram (Stmt chain replacing setSeedCode)
open KeygenRngReference (Exec)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env)
open KeygenSeedEntry089 (Seed Seeded caller entry)
open KeygenSeedFunction089 (resetAtom resetAtoms)

def Silent (ctx : Context) (code : Stmt) : Prop :=
  ∀ before events out, Exec ctx code before events out → events = []

theorem atom_silent (ctx : Context) (code : Stmt) (allowed : resetAtom code = true) : Silent ctx code := by
  cases code <;> simp only [resetAtom, Bool.false_eq_true] at allowed
  all_goals intro before events out source
  all_goals (cases source; rfl)

theorem seq_silent (ctx : Context) (left right : Stmt)
    (hl : Silent ctx left) (hr : Silent ctx right) : Silent ctx (.seq left right) := by
  intro before events out source
  cases source with
  | seqNormal a b before middle early later out first second =>
      rw [hl _ _ _ first, hr _ _ _ second]
      rfl
  | seqExit a b before events out first exit => exact hl _ _ _ first

theorem chain_silent (ctx : Context) (codes : List Stmt)
    (atoms : ∀ code ∈ codes, resetAtom code = true) : Silent ctx (chain codes) := by
  induction codes with
  | nil => exact atom_silent ctx .skip rfl
  | cons code rest ih =>
      exact seq_silent ctx code (chain rest) (atom_silent ctx code (atoms code (by simp)))
        (ih (fun c member => atoms c (by simp [member])))

theorem replacing_silent (ctx : Context) : Silent ctx replacing := by
  intro before events out source
  change Exec ctx (.scope (chain resetAtoms)) before events out at source
  cases source
  exact chain_silent ctx resetAtoms (List.all_eq_true.mp KeygenSeedFunction089.reset_atoms_checked)
    before events out (by assumption)

/-- Empty entropy history and the void return follow from the actual
    replace=1 branch. They are not restrictions assumed about its result. -/
theorem completed (env : Env) (base : State) (block : Nat) (seed : Seed)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec env.ctx setSeedCode (entry env base block seed) events out) :
    events = [] ∧ out.flow = .returned none := by
  have actual := KeygenSeedReplace089.set_seed_replacing env base block seed events out source
  exact ⟨replacing_silent env.ctx _ _ _ actual,
    KeygenSeedReplace089.replacing_returns env.ctx _ _ _ actual⟩

theorem seeded_iff_execution (env : Env) (base : State) (block : Nat) (seed : Seed) (after : State) :
    Seeded env base block seed after ↔
      ∃ events out, Exec env.ctx setSeedCode (entry env base block seed) events out ∧
        after = {caller base block seed with heap := out.state.heap} := by
  constructor
  · intro source
    obtain ⟨out, body, returned, equal⟩ := KeygenSeedEntry089.seeded_body env base block seed after source
    exact ⟨[], out, body, equal⟩
  · rintro ⟨events, out, body, rfl⟩
    obtain ⟨empty, returned⟩ := completed env base block seed events out body
    subst events
    exact .run (entry env base block seed) out (KeygenSeedEntry089.binding env base block seed) body returned

theorem partial_source_spec (env : Env) (base : State) (block : Nat) (seed : Seed) (after : State) :
    after ∈ KeygenSeedFunction089.seedPart env base block seed ↔
      ∃ events out, Exec env.ctx setSeedCode (entry env base block seed) events out ∧
        after = {caller base block seed with heap := out.state.heap} := by
  rw [KeygenSeedFunction089.seedPart_spec, seeded_iff_execution]

theorem context_only : KeygenRngFrame.contextOnly replacing = true := by decide

theorem seeded_frame (env : Env) (base : State) (block : Nat) (seed : Seed) (after : State)
    (source : Seeded env base block seed after) (b o : Nat)
    (outside : KeygenRngFrame.Outside env.ctx b o) :
    ShakePointFrame.Same (caller base block seed).heap after.heap b o := by
  obtain ⟨out, body, returned, equal⟩ := KeygenSeedReplace089.seeded_replacing env base block seed after source
  rw [equal]
  exact KeygenRngFrame.source_frame env.ctx replacing (entry env base block seed) [] out body b o outside
    (Or.inl context_only)

theorem seeded_metadata (env : Env) (base : State) (block : Nat) (seed : Seed) (after : State)
    (source : Seeded env base block seed after) :
    after.heap.size = (caller base block seed).heap.size ∧
      after.heap.writable = (caller base block seed).heap.writable := by
  obtain ⟨out, body, returned, equal⟩ := KeygenSeedReplace089.seeded_replacing env base block seed after source
  rw [equal]
  exact KeygenRngFrame.sizes env.ctx replacing (entry env base block seed) [] out body

end FT1536.Source3.KeygenSeedClosure089
