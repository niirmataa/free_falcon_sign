import Source3.StableBinarySourceSyntax

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinarySourceTyped
open FT1536.Source3
open FT1536.Source3.StableBinarySourceSyntax

def callBinary {l : StableBinary.Layout} {m : StableBinary.Memory}
    (s : StableBinary.State l m) (name : B20.C.Name) (a b : BitVec 64) :
    Option (BitVec 64 × StableBinary.State l m) :=
  if name="fpr_add".toList then StableBinary.call2 s "fpr_add" FprPrimitives.add a b
  else if name="fpr_mul".toList then StableBinary.call2 s "fpr_mul" FprPrimitives.mul a b
  else if name="fpr_div".toList then StableBinary.call2 s "fpr_div" FprPrimitives.div a b
  else none

def callUnary {l : StableBinary.Layout} {m : StableBinary.Memory}
    (s : StableBinary.State l m) (name : B20.C.Name) (a : BitVec 64) :
    Option (BitVec 64 × StableBinary.State l m) :=
  if name="fpr_half".toList then StableBinary.call1 s "fpr_half" StableBinary.half a
  else if name="fpr_double".toList then StableBinary.call1 s "fpr_double" StableBinary.double a
  else none

/- The independently parsed C statements drive this instruction-ordered
   typed-object execution. No result predicate or expected key is tested. -/
def sourcePrefix (l : StableBinary.Layout) (code : Code) {m : StableBinary.Memory}
    (s : StableBinary.State l m) (v u : Nat) :
    Option ((BitVec 64 × BitVec 64) × StableBinary.State l m) := do
  let (x,s) ← StableBinary.load s (StableBinary.addr v (2^code.first.shift*u+code.first.offset))
  let (a,s) ← StableBinary.stable s x
  let (y,s) ← StableBinary.load s (StableBinary.addr v (2^code.second.shift*u+code.second.offset))
  let (b,s) ← StableBinary.stable s y
  let (r,s) ← callBinary s code.sum.callee a b
  let (sum,s) ← StableBinary.stable s r
  let (r,s) ← callBinary s code.product.callee a b
  let (product,s) ← StableBinary.stable s r
  let (r,s) ← callUnary s code.firstStore.half sum
  let (out,s) ← StableBinary.stable s r
  let s ← StableBinary.store s (StableBinary.addr l.scratch u) out
  pure ((product,sum),s)

/- Smaller typed instruction groups for a kernel-sized source/byte
   simulation. The original, already proved sourcePrefix is retained above. -/
def sourcePair (l : StableBinary.Layout) (code : Code) {m : StableBinary.Memory}
    (s : StableBinary.State l m) (v u : Nat) :
    Option ((BitVec 64 × BitVec 64) × StableBinary.State l m) := do
  let (x,s) ← StableBinary.load s (StableBinary.addr v (2^code.first.shift*u+code.first.offset))
  let (a,s) ← StableBinary.stable s x
  let (y,s) ← StableBinary.load s (StableBinary.addr v (2^code.second.shift*u+code.second.offset))
  let (b,s) ← StableBinary.stable s y
  pure ((a,b),s)

def sourceGram (l : StableBinary.Layout) (code : Code) {m : StableBinary.Memory}
    (s : StableBinary.State l m) (a b : BitVec 64) :
    Option ((BitVec 64 × BitVec 64) × StableBinary.State l m) := do
  let (sum,s) ← (do
    let (r,s) ← callBinary s code.sum.callee a b
    StableBinary.stable s r)
  let (product,s) ← (do
    let (r,s) ← callBinary s code.product.callee a b
    StableBinary.stable s r)
  pure ((sum,product),s)

def sourceHalfStore (l : StableBinary.Layout) (code : Code) {m : StableBinary.Memory}
    (s : StableBinary.State l m) (u : Nat) (sum : BitVec 64) :
    Option (StableBinary.State l m) := do
  let (r,s) ← callUnary s code.firstStore.half sum
  let (out,s) ← StableBinary.stable s r
  StableBinary.store s (StableBinary.addr l.scratch u) out

def sourceSuffix (l : StableBinary.Layout) (code : Code) {m : StableBinary.Memory}
    (s : StableBinary.State l m) (u hn : Nat) (product sum : BitVec 64) :
    Option (StableBinary.State l m) := do
  let (r,s) ← callUnary s code.secondStore.double product
  let (r,s) ← callBinary s code.secondStore.div r sum
  let (out,s) ← StableBinary.stable s r
  StableBinary.store s (StableBinary.addr l.scratch (u+hn)) out

def step (l : StableBinary.Layout) (code : Code) {m : StableBinary.Memory}
    (s : StableBinary.State l m) (v u hn : Nat) :
    Option (StableBinary.State l m) := do
  let ((product,sum),s) ← sourcePrefix l code s v u
  sourceSuffix l code s u hn product sum

def loop (l : StableBinary.Layout) (code : Code) {m : StableBinary.Memory}
    (v hn : Nat) : Nat → StableBinary.State l m → Option (StableBinary.State l m)
  | 0,s => some s
  | u+1,s => do
      let s ← loop l code v hn u s
      step l code s v u hn

def execute (l : StableBinary.Layout) (code : Code) (m : StableBinary.Memory) :
    Nat → Nat → StableBinary.State l m → Option (StableBinary.State l m)
  | 0,v,s => do
      if code.baseSize != 1 then none else do
      let s : StableBinary.State l m := {s with events := .enter v 1::s.events}
      let (x,s) ← StableBinary.load s v
      let (y,s) ← StableBinary.stable s x
      let s ← StableBinary.store s v y
      pure {s with events := .leave v 1::s.events}
  | k+1,v,s => do
      let hn := 2^k
      let s : StableBinary.State l m := {s with events := .enter v (2*hn)::s.events}
      let s ← loop l code v hn hn s
      let s ← StableBinary.copy l s v l.scratch (2*hn)
      let s ← execute l code m k v s
      let s ← execute l code m k (v+8*hn) s
      pure {s with events := .leave v (2*hn)::s.events}

def sourceRun (l : StableBinary.Layout) (k : Nat) (m : StableBinary.Memory) :
    Option (StableBinary.State l m) := do
  if ¬l.wellFormed k ∨ ¬m.initialized l then none else do
    let bad ← m.flags l.bad
    let code ← StableBinarySourceSyntax.source
    if hb : m.flags l.bad=some bad then
      execute l code m k l.values {firstBad := bad, badInitially := hb}
    else none

theorem step_expected (l : StableBinary.Layout) {m : StableBinary.Memory}
    (s : StableBinary.State l m) (v u hn : Nat) :
    step l expected s v u hn =
      StableBinary.loopStep l StableBinaryFpr.boundOps StableBinary.program
        s v l.scratch u hn := by
  simp [step,sourcePrefix,sourceSuffix,expected,callBinary,callUnary,StableBinary.loopStep,
    StableBinaryFpr.boundOps,StableBinary.program]
  simp only [Option.bind_assoc,Option.bind_some]

theorem loop_expected (l : StableBinary.Layout) {m : StableBinary.Memory}
    (v hn u : Nat) (s : StableBinary.State l m) :
    loop l expected v hn u s =
      StableBinary.loop l StableBinaryFpr.boundOps StableBinary.program
        v l.scratch hn u s := by
  induction u with
  | zero => rfl
  | succ u ih =>
      simp only [loop,StableBinary.loop,ih,step_expected]

theorem execute_expected (l : StableBinary.Layout) (m : StableBinary.Memory)
    (k v : Nat) (s : StableBinary.State l m) :
    execute l expected m k v s =
      StableBinary.execute l StableBinaryFpr.boundOps StableBinary.program m
        k v l.scratch s := by
  induction k generalizing v s with
  | zero => rfl
  | succ k ih =>
      simp only [execute,StableBinary.execute,loop_expected]
      simp [StableBinary.addr,StableBinary.program,ih]

theorem source_run_reduces (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (b : StableBinary.Flag)
    (hl : l.wellFormed k) (hm : m.initialized l)
    (hb : m.flags l.bad=some b) :
    sourceRun l k m = execute l expected m k l.values
      {firstBad := b, badInitially := hb} := by
  simp [sourceRun,hl,hm,hb,StableBinarySourceSyntax.pinned_source]

theorem source_run_model (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) :
    sourceRun l k m = StableBinary.run l StableBinaryFpr.boundOps k m := by
  by_cases hl : l.wellFormed k
  · by_cases hm : m.initialized l
    · obtain ⟨b,hb⟩ := Option.isSome_iff_exists.mp hm.2
      rw [source_run_reduces l k m b hl hm hb,
        StableBinary.run_reduces l StableBinaryFpr.boundOps k m hl hm hb,
        execute_expected]
    · simp [sourceRun,StableBinary.run,hl,hm]
  · simp [sourceRun,StableBinary.run,hl]

/- Explicit C99 size_t64 obligations for each source loop index. These
   depend only on the legal object layout, never on word/key values. -/
theorem pair_byte_bounds (l : StableBinary.Layout) (k u : Nat)
    (hl : l.wellFormed (k+1)) (hu : u<2^k) :
    2*u+1<l.length ∧
    l.values+8*(2*u+1)+8≤l.values+8*l.length ∧
    l.values+8*(2*u+1)+8<2^64 ∧
    l.scratch+8*l.length<2^64 := by
  obtain ⟨hlen,_,_,_,_,hv,hs,_,_,_,_,_,_⟩ := hl
  have hp : 2^(k+1)=2*(2^k) := by simp [pow_succ,Nat.mul_comm]
  constructor
  · rw [hlen,hp]
    omega
  constructor
  · rw [hlen,hp]
    omega
  constructor
  · rw [hlen,hp] at hv
    omega
  · exact hs

end FT1536.Source3.StableBinarySourceTyped

#check @FT1536.Source3.StableBinarySourceTyped.source_run_model
#print axioms FT1536.Source3.StableBinarySourceTyped.source_run_model
#print axioms FT1536.Source3.StableBinarySourceTyped.pair_byte_bounds
