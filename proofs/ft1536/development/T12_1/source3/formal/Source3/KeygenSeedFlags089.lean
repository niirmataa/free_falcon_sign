import Source3.KeygenSeedClosure089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSeedFlags089
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenRngProgram
open KeygenRngReference (Exec)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env)

structure Steps (ctx : Context) (before : State) (out : Result) where
  initialized : State
  injected : State
  marked : State
  finished : State
  initEvents : List KeygenEntropySource.Event
  injectEvents : List KeygenEntropySource.Event
  markedEvents : List KeygenEntropySource.Event
  finishedEvents : List KeygenEntropySource.Event
  init : Exec ctx (.init (num 512)) before initEvents ⟨initialized, .normal⟩
  inject : Exec ctx (.inject "seed".toList len) initialized injectEvents ⟨injected, .normal⟩
  mark : Exec ctx (.storeFlag .seeded (num 1)) injected markedEvents ⟨marked, .normal⟩
  finish : Exec ctx (.storeFlag .flipped (num 0)) marked finishedEvents ⟨finished, .normal⟩
  result : out = ⟨finished, .returned none⟩

theorem last_return (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx (chain [.ret none]) before events out) : out = ⟨before, .returned none⟩ := by
  cases source with
  | seqNormal a b before middle early later out first second => cases first
  | seqExit a b before events out first exit => cases first; rfl

theorem steps (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx replacing before events out) : Nonempty (Steps ctx before out) := by
  cases source with
  | scope code before events out body =>
      obtain ⟨initialized, e0, rest0, init, tail0, split0⟩ :=
        KeygenSeedReplace089.normal_first ctx _ _ before events out rfl body
      obtain ⟨injected, e1, rest1, inject, tail1, split1⟩ :=
        KeygenSeedReplace089.normal_first ctx _ _ initialized rest0 out rfl tail0
      obtain ⟨marked, e2, rest2, mark, tail2, split2⟩ :=
        KeygenSeedReplace089.normal_first ctx _ _ injected rest1 out rfl tail1
      obtain ⟨finished, e3, rest3, finish, tail3, split3⟩ :=
        KeygenSeedReplace089.normal_first ctx _ _ marked rest2 out rfl tail2
      exact ⟨⟨initialized, injected, marked, finished, e0, e1, e2, e3,
        init, inject, mark, finish, last_return ctx finished rest3 out tail3⟩⟩

theorem stored_literal (ctx : Context) (before after : State) (flag : KeygenReadyFast.Flag) (n : Nat)
    (events : List KeygenEntropySource.Event)
    (source : Exec ctx (.storeFlag flag (num n)) before events ⟨after, .normal⟩) :
    Store32 before.heap (KeygenReadyFast.field ctx flag)
      (BitVec.ofInt 32 (C99IntegerReference.convert .int32 n).integer) after.heap := by
  cases source with
  | storeFlag before flag value v heap binding evaluated write =>
      cases evaluated
      exact write

theorem replacing_flags (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (source : Exec ctx replacing before events out) :
    Load32 out.state.heap (KeygenReadyFast.field ctx .seeded) 1 ∧
      Load32 out.state.heap (KeygenReadyFast.field ctx .flipped) 0 := by
  obtain ⟨run⟩ := steps ctx before events out source
  have mark : Store32 run.injected.heap (KeygenReadyFast.field ctx .seeded) 1 run.marked.heap :=
    stored_literal ctx run.injected run.marked .seeded 1 run.markedEvents run.mark
  have finish : Store32 run.marked.heap (KeygenReadyFast.field ctx .flipped) 0 run.finished.heap :=
    stored_literal ctx run.marked run.finished .flipped 0 run.finishedEvents run.finish
  have seeded := Gate00Memory.stored32_load run.injected.heap run.marked.heap _ _ mark
  have kept : Load32 run.finished.heap (KeygenReadyFast.field ctx .seeded) 1 := by
    apply Gate00Memory.load32_transport run.marked.heap run.finished.heap _ _ seeded finish.2.2.2.1
    intro i
    apply finish.2.2.2.2.2.2
    apply Or.inr ∘ Or.inl
    have bound := i.isLt
    dsimp [KeygenReadyFast.field, KeygenReadyFast.offset, KeygenSearchContext.field, ArrayPointer.offset]
    omega
  rw [run.result]
  exact ⟨kept, Gate00Memory.stored32_load run.marked.heap run.finished.heap _ _ finish⟩

theorem seeded_flags (env : Env) (base : State) (block : Nat) (seed : KeygenSeedEntry089.Seed) (after : State)
    (source : KeygenSeedEntry089.Seeded env base block seed after) :
    Load32 after.heap (KeygenReadyFast.field env.ctx .seeded) 1 ∧
      Load32 after.heap (KeygenReadyFast.field env.ctx .flipped) 0 := by
  obtain ⟨out, body, returned, equal⟩ := KeygenSeedReplace089.seeded_replacing env base block seed after source
  rw [equal]
  exact replacing_flags env.ctx _ [] out body

end FT1536.Source3.KeygenSeedFlags089
