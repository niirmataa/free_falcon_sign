import Source3.KeygenPublicDeterminism095

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicCall095
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenPublicLive095 (Live)

theorem closed (name : Name) (f : KeygenPublicExec.Function) (lookup : KeygenPublicSource.program name = some f) :
    KeygenPublicTail095.tailArrays f.body = true := by
  unfold KeygenPublicSource.program at lookup
  cases found : KeygenPublicSource.find name with
  | none => simp only [found, Option.map_none] at lookup; cases lookup
  | some kind =>
      have equal : KeygenPublicSource.function kind = f := Option.some.inj (by simpa only [found, Option.map_some] using lookup)
      subst f
      exact KeygenPublicTail095.all_checked kind

theorem bind_pointer_live (before : State) (name : Name) (p : ArrayPointer)
    (live : Live before) (positive : 0 < before.heap.size p.block) : Live (C99ArrayReference.bindPointer before name p) := by
  refine ⟨?_, live.2⟩
  intro key q binding
  change (if key = name then some p else before.arrays key) = some q at binding
  by_cases equal : key = name
  · rw [ite_eq_left equal] at binding
    cases Option.some.inj binding
    exact positive
  · rw [ite_eq_right equal] at binding
    exact live.1 key q binding

structure Input where
  before : State
  f : ArrayPointer
  g : ArrayPointer
  h : ArrayPointer
  arrays : before.arrays "f".toList = some f ∧ before.arrays "g".toList = some g ∧ before.arrays "h".toList = some h
  fLive : 0 < before.heap.size f.block
  gLive : 0 < before.heap.size g.block
  hLive : 0 < before.heap.size h.block
  tablesLive : RngTemporarySwap090.TablesLive before

theorem binding_live (input : Input) (entry : State)
    (binding : KeygenPublicWord.Bind input.before (KeygenPublicSource.params .compute) KeygenPublicSource.arguments entry) : Live entry := by
  cases binding with
  | pointer _ _ _ hp _ _ _ hRead rest =>
      cases rest with
      | pointer _ _ _ fp _ _ _ fRead rest =>
          cases rest with
          | pointer _ _ _ gp _ _ _ gRead rest =>
              cases rest with
              | scalar _ _ _ _ _ _ logn lognRead rest =>
                  cases rest with
                  | scalar _ _ _ _ _ _ ter terRead rest =>
                      cases rest
                      have hh := KeygenMakePublicCall.address_zero input.before _ input.h hp input.arrays.2.2 hRead
                      have hf := KeygenMakePublicCall.address_zero input.before _ input.f fp input.arrays.1 fRead
                      have hg := KeygenMakePublicCall.address_zero input.before _ input.g gp input.arrays.2.1 gRead
                      subst hp fp gp
                      exact bind_pointer_live _ _ input.h
                        (bind_pointer_live _ _ input.f
                          (bind_pointer_live _ _ input.g ⟨input.tablesLive, input.tablesLive⟩ input.gLive)
                          input.fLive) input.hLive

theorem call_unique (input : Input) (a b : State) (x y : Value)
    (first : KeygenPublicSource.Call input.before a x) (second : KeygenPublicSource.Call input.before b y) : a = b ∧ x = y := by
  cases first with
  | run e1 out1 x binding1 body1 returned1 =>
      cases second with
      | run e2 out2 y binding2 body2 returned2 =>
          have equal := KeygenPublicWord095.parameters input.before _ _ e1 e2 binding1 binding2
          subst e2
          have same := (KeygenPublicDeterminism095.execution KeygenPublicSource.program closed _ _ e1 out1 out2
            (KeygenPublicTail095.all_checked .compute) (binding_live input e1 binding1) body1 body2).1
          refine ⟨congrArg (fun heap => ({input.before with heap := heap} : State)) same.1, ?_⟩
          rw [same.2.2] at returned1
          exact Option.some.inj (C99ProcedureDeterminism094.returned _ _ _ _ returned1 returned2)

theorem gate_unique (input : Input) (a b : Result)
    (first : KeygenAttemptMaterial.PublicGate input.before a) (second : KeygenAttemptMaterial.PublicGate input.before b) : a = b := by
  cases first <;> cases second
  all_goals grind only [call_unique]

noncomputable def compute (input : Input) : Part (State × Value) where
  Dom := ∃ out : State × Value, KeygenPublicSource.Call input.before out.1 out.2
  get domain := Classical.choose domain

theorem compute_spec (input : Input) (out : State × Value) :
    out ∈ compute input ↔ KeygenPublicSource.Call input.before out.1 out.2 := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ result : State × Value, KeygenPublicSource.Call input.before result.1 result.2 := ⟨out, source⟩
    have same := call_unique input (Classical.choose domain).1 out.1 (Classical.choose domain).2 out.2
      (Classical.choose_spec domain) source
    exact ⟨domain, Prod.ext same.1 same.2⟩

def from_initial (ctx : KeygenSearchContext.Context) (before : State) (polynomials : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (initial : KeygenCallerEntry.Initial ctx before polynomials h primes rev)
    (hLive : 0 < before.heap.size h.block) : Input :=
  ⟨before, polynomials 0, polynomials 1, h, ⟨initial.inputs 0, initial.inputs 1, initial.publicPointer⟩,
    KeygenCallerEntry.allocated_live _ _ (initial.allocated 0),
    KeygenCallerEntry.allocated_live _ _ (initial.allocated 1), hLive, initial.staticLive⟩

end FT1536.Source3.KeygenPublicCall095
