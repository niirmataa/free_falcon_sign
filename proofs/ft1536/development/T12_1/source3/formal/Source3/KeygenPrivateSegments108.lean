import Source3.KeygenPrivateSite108

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPrivateSegments108
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env SmallSite assign)
open KeygenCanonicalAddresses108 (canonical)
open KeygenPrivateSite108 (Words)

def advance (before : State) (i : Nat) (after : Memory) (ret skoff : BitVec 64) : State :=
  assign (assign {before with heap := after} "skoff".toList .uint64 (.uint64 (skoff + ret)))
    "i".toList .int32 (.int32 (BitVec.ofNat 32 (i+1)))

/-- Only proof-carrying call-list metadata is erased; all evaluated cells,
    fixed body calls, cursor updates, partial writes and exit tests remain. -/
inductive Run (env : Env) : Nat → State → Result → Prop where
  | done (i : Nat) (before : State) (bound : 4 ≤ i)
      (counter : before.locals "i".toList = some (.int32,some (.int32 (BitVec.ofNat 32 i)))) :
      Run env i before ⟨before,.normal⟩
  | capacity (i : Nat) (before : State) (after : Memory) (ret : BitVec 64) (bound : i < 4)
      (site : SmallSite (canonical env) before ⟨i,bound⟩ after ret)
      (execution : KeygenCodecExecution.Call (KeygenCodecTypedSegments.arguments (canonical env) before ⟨i,bound⟩ after ret site) before.heap after ret)
      (counter : before.locals "i".toList = some (.int32,some (.int32 (BitVec.ofNat 32 i)))) (zero : ret = 0) :
      Run env i before ⟨{before with heap := after},.returned (some (.int32 0))⟩
  | next (i : Nat) (before : State) (after : Memory) (ret : BitVec 64) (out : Result) (bound : i < 4)
      (site : SmallSite (canonical env) before ⟨i,bound⟩ after ret)
      (execution : KeygenCodecExecution.Call (KeygenCodecTypedSegments.arguments (canonical env) before ⟨i,bound⟩ after ret site) before.heap after ret)
      (counter : before.locals "i".toList = some (.int32,some (.int32 (BitVec.ofNat 32 i))))
      (nonzero : ret ≠ 0) (skoff : BitVec 64)
      (cursor : before.locals "skoff".toList = some (.uint64,some (.uint64 skoff)))
      (rest : Run env (i+1) (advance before i after ret skoff) out) : Run env i before out

theorem erase (env : Env) (i : Nat) (before : State) (out : Result)
    (calls : List (KeygenCodecTypedSegments.Site (canonical env)))
    (source : KeygenCodecTypedSegments.Segments (canonical env) i before out calls) : Run env i before out := by
  induction source with
  | done i before bound counter => exact .done i before bound counter
  | capacity c counter zero => exact .capacity c.index.val c.before c.after c.ret c.index.isLt c.site c.execution counter zero
  | next c counter nonzero skoff cursor rest ih =>
      exact .next c.index.val c.before c.after c.ret _ c.index.isLt c.site c.execution counter nonzero skoff cursor ih

theorem restore (env : Env) (i : Nat) (before : State) (out : Result) (source : Run env i before out) :
    ∃ calls, KeygenCodecTypedSegments.Segments (canonical env) i before out calls := by
  induction source with
  | done i before bound counter => exact ⟨[], .done i before bound counter⟩
  | capacity i before after ret bound site execution counter zero =>
      let c : KeygenCodecTypedSegments.Site (canonical env) := ⟨⟨i,bound⟩,before,after,ret,site,execution⟩
      exact ⟨[c], .capacity c counter zero⟩
  | next i before after ret out bound site execution counter nonzero skoff cursor rest ih =>
      let c : KeygenCodecTypedSegments.Site (canonical env) := ⟨⟨i,bound⟩,before,after,ret,site,execution⟩
      obtain ⟨calls, tail⟩ := ih
      exact ⟨c :: calls, .next c counter nonzero skoff cursor tail⟩

theorem source_iff (env : Env) (i : Nat) (before : State) (out : Result) :
    Run env i before out ↔ ∃ calls, KeygenCodecTypedSegments.Segments (canonical env) i before out calls :=
  ⟨restore env i before out, fun ⟨calls, source⟩ => erase env i before out calls source⟩

theorem unique (env : Env) (i : Nat) (before : State) (a b : Result)
    (separate : (canonical env).args.privkey.block ≠ (canonical env).blocks 5)
    (first : Run env i before a) (second : Run env i before b) (words : Words env before) : a = b := by
  revert words
  induction first generalizing b with
  | done i before bound counter =>
      intro words
      cases second <;> grind
  | capacity i before after ret bound site execution counter zero =>
      intro words
      have word := words ⟨i,bound⟩
      have calls := KeygenPrivateSite108.call_unique env before ⟨i,bound⟩
      cases second <;> grind
  | next i before after ret out bound site execution counter nonzero skoff cursor rest ih =>
      intro words
      have word := words ⟨i,bound⟩
      have calls := KeygenPrivateSite108.call_unique env before ⟨i,bound⟩
      have nextWords : Words env (advance before i after ret skoff) :=
        KeygenPrivateSite108.words_after env before ⟨i,bound⟩ after ret site execution separate words
      have later : ∀ result, Run env (i+1) (advance before i after ret skoff) result → out = result :=
        fun result proof => ih result proof nextWords
      cases second <;> grind

theorem segments (env : Env) (i : Nat) (before : State) (a b : Result)
    (xs ys : List (KeygenCodecTypedSegments.Site (canonical env)))
    (separate : (canonical env).args.privkey.block ≠ (canonical env).blocks 5) (words : Words env before)
    (first : KeygenCodecTypedSegments.Segments (canonical env) i before a xs)
    (second : KeygenCodecTypedSegments.Segments (canonical env) i before b ys) : a = b :=
  unique env i before a b separate (erase env i before a xs first) (erase env i before b ys second) words

end FT1536.Source3.KeygenPrivateSegments108
