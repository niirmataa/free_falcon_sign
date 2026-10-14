import Source3.KeygenSeedReplace089
import Source3.ShakeSeedDeterminism089
import Mathlib.Data.Part

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSeedFunction089
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenRngProgram (Stmt chain replacing)
open KeygenRngReference (Exec)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env)
open KeygenSeedEntry089 (Seed Seeded)

def Unique (ctx : Context) (code : Stmt) : Prop :=
  ∀ before events1 events2 a b,
    Exec ctx code before events1 a → Exec ctx code before events2 b →
      a = b ∧ events1 = events2

def resetAtom : Stmt → Bool
  | .skip | .init _ | .inject _ _ | .flip | .storeFlag _ _ | .ret _ => true
  | _ => false

theorem atom_unique (ctx : Context) (code : Stmt) (allowed : resetAtom code = true) : Unique ctx code := by
  cases code <;> simp only [resetAtom, Bool.false_eq_true] at allowed
  all_goals intro before events1 events2 a b first second
  all_goals (cases first; cases second)
  all_goals grind only [C99ScalarCallsDeterminism089.array_scalar,
    C99ScalarCallsDeterminism089.array_pointer, ShakeSeedDeterminism089.init,
    ShakeSeedDeterminism089.inject, ShakeSeedDeterminism089.flip, C99HeapDeterminism089.store32]

theorem seq_unique (ctx : Context) (left right : Stmt)
    (hl : Unique ctx left) (hr : Unique ctx right) : Unique ctx (.seq left right) := by
  unfold Unique at hl hr ⊢
  intro before events1 events2 a b first second
  cases first <;> cases second
  all_goals grind only

theorem chain_unique (ctx : Context) (codes : List Stmt)
    (atoms : ∀ code ∈ codes, resetAtom code = true) : Unique ctx (chain codes) := by
  induction codes with
  | nil => exact atom_unique ctx .skip rfl
  | cons code rest ih =>
      exact seq_unique ctx code (chain rest) (atom_unique ctx code (atoms code (by simp)))
        (ih (fun c member => atoms c (by simp [member])))

def resetAtoms : List Stmt := KeygenSeedReplace089.resetPrefix ++ [.ret none]
theorem reset_atoms_checked : resetAtoms.all resetAtom = true := by decide

theorem replacing_unique (ctx : Context) : Unique ctx replacing := by
  intro before events1 events2 a b first second
  change Exec ctx (.scope (chain resetAtoms)) before events1 a at first
  change Exec ctx (.scope (chain resetAtoms)) before events2 b at second
  cases first
  cases second
  exact chain_unique ctx resetAtoms (List.all_eq_true.mp reset_atoms_checked) before events1 events2 a b
    (by assumption) (by assumption)

/-- No source execution is selected until its resulting state is proved
    unique. The actual reset/inject source bodies discharge that obligation. -/
theorem seeded_unique (env : Env) (base : State) (block : Nat) (seed : Seed) (a b : State)
    (first : Seeded env base block seed a) (second : Seeded env base block seed b) : a = b := by
  obtain ⟨out1, body1, returned1, equal1⟩ := KeygenSeedReplace089.seeded_replacing env base block seed a first
  obtain ⟨out2, body2, returned2, equal2⟩ := KeygenSeedReplace089.seeded_replacing env base block seed b second
  have states := (replacing_unique env.ctx (KeygenSeedEntry089.entry env base block seed) [] []
    out1 out2 body1 body2).1
  cases states
  exact equal1.trans equal2.symm

/-- Exact partial denotation of source set_seed for this input boundary.
    Its domain is actual finite defined source execution, not a success,
    ideal-SHAKE or termination assumption. -/
noncomputable def seedPart (env : Env) (base : State) (block : Nat) (seed : Seed) : Part State where
  Dom := ∃ after, Seeded env base block seed after
  get h := Classical.choose h

theorem seedPart_spec (env : Env) (base : State) (block : Nat) (seed : Seed) (after : State) :
    after ∈ seedPart env base block seed ↔ Seeded env base block seed after := by
  constructor
  · rintro ⟨domainWitness, equal⟩
    have source := Classical.choose_spec domainWitness
    rw [← equal]
    exact source
  · intro source
    let domainWitness : ∃ after, Seeded env base block seed after := ⟨after, source⟩
    exact ⟨domainWitness, seeded_unique env base block seed _ after (Classical.choose_spec domainWitness) source⟩

theorem seedPart_domain (env : Env) (base : State) (block : Nat) (seed : Seed) :
    (seedPart env base block seed).Dom ↔ ∃ after, Seeded env base block seed after := Iff.rfl

end FT1536.Source3.KeygenSeedFunction089
