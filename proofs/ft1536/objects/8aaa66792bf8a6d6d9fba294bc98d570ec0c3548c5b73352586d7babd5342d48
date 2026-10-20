import Source3.StablePositive
import Source3.LeafScan
import Source3.StableBinaryPin

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinary
open FT1536.Source3 B20.C
abbrev Word := BitVec 64
abbrev Flag := BitVec 32

/- This parser recognizes the entire *one* selected function, including its
   control flow. It deliberately rejects any extra or changed tokens. Its
   program is an operational AST, not a predicate that the output is good. -/
structure Program where
  baseCase : Nat
  firstStride : Nat
  secondDelta : Nat
  leftOffset : Nat
  rightStride : Nat
  deriving DecidableEq

def program : Program := ⟨1, 2, 1, 0, 1⟩

def sourceChars : List Char := StableBinaryPin.lines.flatMap String.toList

def sourceTokens : Option (List Token) :=
  LeafScan.tokenize (sourceChars.length+1) sourceChars

def parse (chars : List Char) : Option Program := do
  let tokens ← LeafScan.tokenize (chars.length+1) chars
  let expected ← sourceTokens
  if tokens=expected then some program else none

theorem source_matches : KeygenHelpers.slice 7490 24=sourceChars := by
  exact congrArg (List.flatMap String.toList) StableBinaryPin.pinned
theorem source_tokens_nonempty : sourceTokens.isSome := by decide
theorem source_parses : parse (KeygenHelpers.slice 7490 24)=some program := by
  rw [source_matches]
  change (sourceTokens.bind fun tokens => sourceTokens.bind fun expected =>
    if tokens=expected then some program else none)=some program
  cases he : sourceTokens with
  | none => have hh:=source_tokens_nonempty; simp [he] at hh
  | some ts => simp

/- Object-addressed C memory. Addresses are *byte* offsets; each `words`
   cell denotes an eight-byte fpr object and each `flags` cell a four-byte
   uint32_t object. The layout predicate below forbids partial byte overlap.
   `none` means unallocated or uninitialized and a read of it is undefined. -/
structure Memory where
  words : Nat → Option Word
  flags : Nat → Option Flag

def addr (base i : Nat) : Nat := base+8*i
def inBytes (base count a : Nat) : Prop := base ≤ a ∧ a < base+8*count

structure Layout where
  values : Nat
  scratch : Nat
  bad : Nat
  length : Nat

def Layout.allowed (l : Layout) (a : Nat) : Prop :=
  ((List.range l.length).any (fun i => a==addr l.values i) ||
    (List.range l.length).any (fun i => a==addr l.scratch i))=true

instance Layout.decidableAllowed (l : Layout) (a : Nat) : Decidable (l.allowed a) := by
  unfold Layout.allowed
  infer_instance

def Layout.wellFormed (l : Layout) (k : Nat) : Prop :=
  l.length=2^k ∧ k≤8 ∧ l.values%8=0 ∧ l.scratch%8=0 ∧ l.bad%4=0 ∧
  l.values+8*l.length<2^64 ∧ l.scratch+8*l.length<2^64 ∧ l.bad+4<2^64 ∧
  (l.values+8*l.length≤l.scratch ∨ l.scratch+8*l.length≤l.values) ∧
  ¬inBytes l.values l.length l.bad ∧ ¬inBytes l.scratch l.length l.bad ∧
  ¬inBytes l.values l.length (l.bad+3) ∧
  ¬inBytes l.scratch l.length (l.bad+3)

def Memory.initialized (m : Memory) (l : Layout) : Prop :=
  ((List.range l.length).all (fun i => (m.words (addr l.values i)).isSome))=true ∧
  (m.flags l.bad).isSome

/- Scratch is allocated by Layout, but its initial bytes need not hold fpr
   values: each non-base call writes both scratch halves before memcpy reads
   them. The old predicate unnecessarily rejected defined C executions with
   fresh, uninitialized scratch. -/

instance Layout.decidableWellFormed (l : Layout) (k : Nat) : Decidable (l.wellFormed k) := by
  unfold Layout.wellFormed inBytes
  infer_instance

instance Memory.decidableInitialized (m : Memory) (l : Layout) : Decidable (m.initialized l) := by
  unfold Memory.initialized
  infer_instance

structure Write (l : Layout) where
  address : Nat
  word : Word
  inRegion : l.allowed address

inductive Event where
  | enter (values size : Nat)
  | load (address : Nat) (word : Word)
  | stable (input output : Word)
  | fpr (name : String) (args : List Word) (output : Word)
  | store (address : Nat) (word : Word)
  | copy (dst src count : Nat)
  | leave (values size : Nat)
  deriving DecidableEq, Repr

/- Newest item first: both the overlay and the trace are chronologically
   reversed. This makes the most recent store the one seen by a read. -/
structure State (l : Layout) (m : Memory) where
  firstBad : Flag
  badInitially : m.flags l.bad=some firstBad
  writes : List (Write l) := []
  checks : List Word := []
  events : List Event := []

def State.bad {l : Layout} {m : Memory} (s : State l m) : Flag :=
  s.checks.foldr Run2.KeygenLeafGate.stableBad s.firstBad

def lookup {l : Layout} (writes : List (Write l)) (m : Memory) (a : Nat) : Option Word :=
  match writes with
  | [] => m.words a
  | w::ws => if w.address=a then some w.word else lookup ws m a

def State.memory {l : Layout} {m : Memory} (s : State l m) : Memory :=
  ⟨lookup s.writes m, CRefWord.store m.flags l.bad s.bad⟩

def State.chronology {l : Layout} {m : Memory} (s : State l m) : List Event := s.events.reverse

theorem lookup_frame {l : Layout} (ws : List (Write l)) (m : Memory) (a : Nat)
    (ha : ¬l.allowed a) : lookup ws m a=m.words a := by
  induction ws with
  | nil => rfl
  | cons w ws ih =>
      have h : w.address≠a := by
        intro eq
        apply ha
        rw [← eq]
        exact w.inRegion
      simp only [lookup,h,ite_false,ih]

theorem memory_frame {l : Layout} {m : Memory} (s : State l m) (a : Nat)
    (ha : ¬l.allowed a) (hp : a≠l.bad) :
    s.memory.words a=m.words a ∧ s.memory.flags a=m.flags a := by
  exact ⟨lookup_frame s.writes m a ha,
    CRefWord.store_frame m.flags l.bad a s.bad hp⟩

def load {l : Layout} {m : Memory} (s : State l m) (a : Nat) : Option (Word × State l m) := do
  if ¬l.allowed a then none else do
    let w ← s.memory.words a
    pure (w,{s with events := .load a w::s.events})

def store {l : Layout} {m : Memory} (s : State l m) (a : Nat) (w : Word) : Option (State l m) := do
  if h : l.allowed a then
    pure {s with writes := ⟨a,w,h⟩::s.writes, events := .store a w::s.events}
  else none

/- This executes the *parsed* predecessor in the live bad cell. The extra
   comparison checks the returned heap update; a wrong/cancelled update makes
   execution undefined, rather than being silently ignored. -/
def recordCheck {l : Layout} {m : Memory} (s : State l m) (w z : Word) : State l m :=
  {s with checks := w::s.checks, events := (Event.stable w z)::s.events}

def stable {l : Layout} {m : Memory} (s : State l m) (w : Word) : Option (Word × State l m) := do
  let heap := CRefWord.store m.flags l.bad s.bad
  let (result,m) ← (CRefWord.parse (KeygenHelpers.slice 7477 12)).bind
    (fun f => CRefWord.execute StablePositive.pureCalls StablePositive.globals
      f heap [.word (.u64 w),.ref32 l.bad])
  match result with
  | .u64 z =>
      if m l.bad=some (Run2.KeygenLeafGate.stableBad w s.bad) then
        some (z,recordCheck s w z)
      else none
  | _ => none

theorem stable_source {l : Layout} {m : Memory} (s : State l m) (w : Word) :
    stable s w=some (Run2.KeygenLeafGate.stableWord w,
      recordCheck s w (Run2.KeygenLeafGate.stableWord w)) := by
  have hp : CRefWord.store m.flags l.bad s.bad l.bad=some s.bad :=
    CRefWord.store_read _ _ _
  simp [stable,StablePositive.source_refines w s.bad _ l.bad hp,
    CRefWord.store_read]

theorem stable_bad_update {l : Layout} {m : Memory} (s : State l m) (w : Word) :
    (stable s w).map (fun v => v.2.bad)=
      some (Run2.KeygenLeafGate.stableBad w s.bad) := by
  rw [stable_source]
  rfl

theorem fold_clear (bad : Flag) (xs : List Word) :
    (xs.foldr Run2.KeygenLeafGate.stableBad bad)=0#32 ↔
      bad=0#32 ∧ ∀ w∈xs, Run2.KeygenLeafGate.positive w=true := by
  induction xs with
  | nil => simp
  | cons w rest ih =>
      simp only [List.foldr_cons,Run2.KeygenLeafGate.stableBad_clear,ih,
        List.mem_cons,forall_eq_or_imp]
      tauto

theorem bad_clear_iff {l : Layout} {m : Memory} (s : State l m) :
    s.bad=0#32 ↔ s.firstBad=0#32 ∧
      ∀ w∈s.checks, Run2.KeygenLeafGate.positive w=true := by
  exact fold_clear s.firstBad s.checks

theorem no_fallback {l : Layout} {m : Memory} (s : State l m) (hc : s.bad=0#32) :
    s.firstBad=0#32 ∧ ∀ w∈s.checks, Run2.KeygenLeafGate.stableWord w=w := by
  obtain ⟨hfirst,hpos⟩ := bad_clear_iff s |>.mp hc
  refine ⟨hfirst,?_⟩
  intro w hm
  rw [Run2.KeygenLeafGate.stableWord_cases,hpos w hm]
  rfl

theorem never_clears_bad {l : Layout} {m : Memory} (s : State l m)
    (h : s.firstBad≠0#32) : s.bad≠0#32 := by
  intro hc
  exact h (no_fallback s hc).1

/- These are execution interfaces, not positivity or accuracy hypotheses.
   A callee may be undefined (`none`); every defined returned 64-bit word is
   still checked by the source stable-positive function. The add/mul/div
   implementation-level binding remains a separate P02 obligation. -/
structure FprCalls where
  add : Word → Word → Option Word
  mul : Word → Word → Option Word
  div : Word → Word → Option Word

def call2 {l : Layout} {m : Memory} (s : State l m) (name : String)
    (f : Word → Word → Option Word) (a b : Word) : Option (Word × State l m) := do
  let r ← f a b
  pure (r,{s with events := .fpr name [a,b] r::s.events})

def call1 {l : Layout} {m : Memory} (s : State l m) (name : String)
    (f : Word → Option Word) (a : Word) : Option (Word × State l m) := do
  let r ← f a
  pure (r,{s with events := .fpr name [a] r::s.events})

theorem call2_no_caller_write {l : Layout} {m : Memory} (s t : State l m)
    (name : String) (f : Word → Word → Option Word) (a b r : Word)
    (h : call2 s name f a b=some (r,t)) :
    t.memory=s.memory ∧ t.bad=s.bad := by
  cases hf : f a b with
  | none => simp [call2,hf] at h
  | some z =>
      simp only [call2,hf] at h
      have ht := (Prod.mk.inj (Option.some.inj h)).2.symm
      subst t
      exact ⟨rfl,rfl⟩

theorem call1_no_caller_write {l : Layout} {m : Memory} (s t : State l m)
    (name : String) (f : Word → Option Word) (a r : Word)
    (h : call1 s name f a=some (r,t)) :
    t.memory=s.memory ∧ t.bad=s.bad := by
  cases hf : f a with
  | none => simp [call1,hf] at h
  | some z =>
      simp only [call1,hf] at h
      have ht := (Prod.mk.inj (Option.some.inj h)).2.symm
      subst t
      exact ⟨rfl,rfl⟩

/- The two inline functions are parsed and evaluated from the *M0* header.
   Unlike add/mul/div their bodies are scalar C, and require no external
   FPEMU callback. -/
def halfProgram : CLogic.Function where
  name := "fpr_half".toList
  result := .u64
  params := [(.u64,"x".toList)]
  body := [
    .declare .u32 ["t".toList],
    .update "x".toList .sub (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 52)),
    .assign "t".toList (.bin .shr (.bin .add
      (.bin .band (.cast .u32 (.bin .shr (.var "x".toList) (.literal .i32 52)))
        (.literal .i32 2047)) (.literal .i32 1)) (.literal .i32 11)),
    .update "x".toList .band (.bin .sub (.cast .u64 (.var "t".toList)) (.literal .i32 1)),
    .ret (.var "x".toList)]

def doubleProgram : CLogic.Function where
  name := "fpr_double".toList
  result := .u64
  params := [(.u64,"x".toList)]
  body := [
    .update "x".toList .add (.bin .shl (.cast .u64 (.bin .shr
      (.bin .add (.bin .band (.cast .u32 (.bin .shr (.var "x".toList) (.literal .i32 52)))
        (.literal .u32 2047)) (.literal .u32 2047)) (.literal .i32 11))) (.literal .i32 52)),
    .ret (.var "x".toList)]

theorem half_parses : CLogicParser.parseFunction
    (List.flatMap String.toList ((Pinned.fprLines.drop 164).take 10))=some halfProgram := by decide
theorem double_parses : CLogicParser.parseFunction
    (List.flatMap String.toList ((Pinned.fprLines.drop 175).take 6))=some doubleProgram := by decide

theorem half_exec_from_header (w : Word) :
    (CLogicParser.parseFunction
      (List.flatMap String.toList ((Pinned.fprLines.drop 164).take 10))).bind
      (fun f => CLogic.execute (fun _ _ => none) f [.u64 w]) =
    CLogic.execute (fun _ _ => none) halfProgram [.u64 w] := by
  rw [half_parses]
  rfl

theorem double_exec_from_header (w : Word) :
    (CLogicParser.parseFunction
      (List.flatMap String.toList ((Pinned.fprLines.drop 175).take 6))).bind
      (fun f => CLogic.execute (fun _ _ => none) f [.u64 w]) =
    CLogic.execute (fun _ _ => none) doubleProgram [.u64 w] := by
  rw [double_parses]
  simp only [Option.bind_some]

def half (w : Word) : Option Word := do
  match ← CLogic.execute (fun _ _ => none) halfProgram [.u64 w] with
  | .u64 z => some z
  | _ => none

def double (w : Word) : Option Word := do
  match ← CLogic.execute (fun _ _ => none) doubleProgram [.u64 w] with
  | .u64 z => some z
  | _ => none

/- One literal loop iteration: six independent checks, and source-ordered
   add, mul, half, double, div. In particular the second write is u+hn. -/
def loopStep (l : Layout) (ops : FprCalls) (code : Program) {m : Memory} (s : State l m)
    (v scratch u hn : Nat) : Option (State l m) := do
  let (x,s) ← load s (addr v (code.firstStride*u))
  let (a,s) ← stable s x
  let (y,s) ← load s (addr v (code.firstStride*u+code.secondDelta))
  let (b,s) ← stable s y
  let (r,s) ← call2 s "fpr_add" ops.add a b
  let (sum,s) ← stable s r
  let (r,s) ← call2 s "fpr_mul" ops.mul a b
  let (product,s) ← stable s r
  let (r,s) ← call1 s "fpr_half" half sum
  let (out,s) ← stable s r
  let s ← store s (addr scratch u) out
  let (r,s) ← call1 s "fpr_double" double product
  let (r,s) ← call2 s "fpr_div" ops.div r sum
  let (out,s) ← stable s r
  store s (addr scratch (u+hn)) out

theorem source_loop_order (l : Layout) (ops : FprCalls) {m : Memory}
    (s : State l m) (v scratch u hn : Nat) :
    loopStep l ops program s v scratch u hn = (do
      let (x,s) ← load s (addr v (2*u))
      let (a,s) ← stable s x
      let (y,s) ← load s (addr v (2*u+1))
      let (b,s) ← stable s y
      let (r,s) ← call2 s "fpr_add" ops.add a b
      let (sum,s) ← stable s r
      let (r,s) ← call2 s "fpr_mul" ops.mul a b
      let (product,s) ← stable s r
      let (r,s) ← call1 s "fpr_half" half sum
      let (out,s) ← stable s r
      let s ← store s (addr scratch u) out
      let (r,s) ← call1 s "fpr_double" double product
      let (r,s) ← call2 s "fpr_div" ops.div r sum
      let (out,s) ← stable s r
      store s (addr scratch (u+hn)) out) := by rfl

def loop (l : Layout) (ops : FprCalls) (code : Program) {m : Memory} (v scratch hn : Nat) :
    Nat → State l m → Option (State l m)
  | 0,s => some s
  | u+1,s => do
      let s ← loop l ops code v scratch hn u s
      loopStep l ops code s v scratch u hn

/- Read all source objects before writing any destination object, exactly
   the nonoverlapping memcpy contract. The event records byte count 8*n. -/
def collect (l : Layout) {m : Memory} (scratch : Nat) : Nat → State l m → Option (List Word × State l m)
  | 0,s => some ([],s)
  | u+1,s => do
      let (xs,s) ← collect l scratch u s
      let (w,s) ← load s (addr scratch u)
      pure (xs++[w],s)

def place (l : Layout) {m : Memory} (v : Nat) : Nat → List Word → State l m → Option (State l m)
  | _,[],s => some s
  | i,w::ws,s => do place l v (i+1) ws (← store s (addr v i) w)

def copy (l : Layout) {m : Memory} (s : State l m) (v scratch n : Nat) : Option (State l m) := do
  let (xs,s) ← collect l scratch n s
  let s ← place l v 0 xs s
  pure {s with events := .copy v scratch (8*n)::s.events}

/- n=2^k, 0<=k<=8, is the source recursion measure. The two recursive
   calls share scratch and bad; the second starts at values+8*hn bytes. -/
def execute (l : Layout) (ops : FprCalls) (code : Program) (m : Memory) :
    Nat → Nat → Nat → State l m → Option (State l m)
  | 0,v,_scratch,s => do
      if code.baseCase≠1 then none else do
      let s : State l m := {s with events := .enter v 1::s.events}
      let (w,s) ← load (m := m) s v
      let (z,s) ← stable (m := m) s w
      let s ← store (m := m) s v z
      pure {s with events := .leave v 1::s.events}
  | k+1,v,scratch,s => do
      let hn:=2^k
      let n:=2*hn
      let s : State l m := {s with events := .enter v n::s.events}
      let s ← loop l ops code v scratch hn hn s
      let s ← copy l s v scratch n
      let s ← execute l ops code m k (addr v code.leftOffset) scratch s
      let s ← execute l ops code m k (addr v (code.rightStride*hn)) scratch s
      pure {s with events := .leave v n::s.events}

def run (l : Layout) (ops : FprCalls) (k : Nat) (m : Memory) : Option (State l m) := do
  if ¬l.wellFormed k ∨ ¬m.initialized l then none else do
    let b ← m.flags l.bad
    let code ← parse (KeygenHelpers.slice 7490 24)
    if hb : m.flags l.bad=some b then
      if code≠program then none else
        execute l ops code m k l.values l.scratch {firstBad := b, badInitially := hb}
    else none

theorem run_reduces (l : Layout) (ops : FprCalls) (k : Nat) (m : Memory)
    (hl : l.wellFormed k) (hm : m.initialized l) (hb : m.flags l.bad=some b) :
    run l ops k m=execute l ops program m k l.values l.scratch
      {firstBad := b, badInitially := hb} := by
  simp [run,hl,hm,hb,source_parses]

theorem source_recursion (l : Layout) (ops : FprCalls) {m : Memory} (k v scratch : Nat) (s : State l m) :
    execute l ops program m (k+1) v scratch s = (do
      let hn:=2^k
      let n:=2*hn
      let s:={s with events := .enter v n::s.events}
      let s ← loop l ops program v scratch hn hn s
      let s ← copy l s v scratch n
      let s ← execute l ops program m k (addr v program.leftOffset) scratch s
      let s ← execute l ops program m k (addr v (program.rightStride*hn)) scratch s
      pure {s with events := .leave v n::s.events}) := by rfl

theorem left_call_address (v : Nat) : addr v program.leftOffset=v := by
  simp [addr,program]

theorem right_call_address (v hn : Nat) :
    addr v (program.rightStride*hn)=v+8*hn := by
  simp [addr,program]

theorem first_pair_address (v u : Nat) :
    addr v (program.firstStride*u)=v+16*u := by
  simp [addr,program]; omega

theorem second_pair_address (v u : Nat) :
    addr v (program.firstStride*u+program.secondDelta)=v+16*u+8 := by
  simp [addr,program]; omega

/- The recursive call ledger is preorder, just like `source_recursion`:
   current call, entire left subtree, entire right subtree. Induction on k
   proves both subtrees stay within the original value-array region. -/
def callSchedule : Nat → Nat → List (Nat × Nat)
  | 0,v => [(v,1)]
  | k+1,v => (v,2^(k+1)) ::
      (callSchedule k v ++ callSchedule k (addr v (2^k)))

theorem call_schedule_bounds : ∀ (k v a n : Nat),
    (a,n)∈callSchedule k v → v≤a ∧ a+8*n≤v+8*(2^k) := by
  intro k
  induction k with
  | zero =>
      intro v a n h
      simp only [callSchedule,List.mem_singleton,Prod.mk.injEq] at h
      rcases h with ⟨rfl,rfl⟩
      simp
  | succ k ih =>
      intro v a n h
      simp only [callSchedule,List.mem_cons,List.mem_append] at h
      rcases h with hroot | hleft | hright
      · rcases hroot with ⟨rfl,rfl⟩
        simp
      · obtain ⟨hlo,hhi⟩:=ih v a n hleft
        constructor
        · exact hlo
        · simp only [pow_succ]
          omega
      · obtain ⟨hlo,hhi⟩:=ih (addr v (2^k)) a n hright
        simp only [addr] at hlo hhi
        constructor
        · omega
        · simp only [pow_succ]
          omega

theorem source_recursion_memory_and_sticky (l : Layout) (ops : FprCalls)
    (k : Nat) (m : Memory) (s : State l m)
    (hl : l.wellFormed k) (hm : m.initialized l)
    (hexec : run l ops k m=some s)
    (hclear : s.memory.flags l.bad=some 0#32) :
    m.flags l.bad=some 0#32 ∧
    (∀ w∈s.checks,
      Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w) ∧
    (∀ a, ¬l.allowed a → s.memory.words a=m.words a) ∧
    (∀ a, a≠l.bad → s.memory.flags a=m.flags a) ∧
    execute l ops program m k l.values l.scratch
      {firstBad := s.firstBad, badInitially := s.badInitially}=some s := by
  have hb : s.bad=0#32 := by
    have h : some s.bad=some 0#32 := by
      simpa only [State.memory,CRefWord.store_read] using hclear
    exact Option.some.inj h
  obtain ⟨hfirst,hwords⟩ := no_fallback s hb
  have hcall := run_reduces l ops k m hl hm s.badInitially
  refine ⟨?_,?_,?_,?_,?_⟩
  · simpa only [hfirst] using s.badInitially
  · intro w hw
    exact ⟨(bad_clear_iff s |>.mp hb).2 w hw,hwords w hw⟩
  · intro a ha
    exact lookup_frame s.writes m a ha
  · intro a hp
    exact CRefWord.store_frame m.flags l.bad a s.bad hp
  · exact hcall.symm.trans hexec

theorem source_preserves_prior_bad (l : Layout) (ops : FprCalls)
    (k : Nat) (m : Memory) (s : State l m)
    (_hexec : run l ops k m=some s)
    (hflag : m.flags l.bad=some 1#32) :
    s.memory.flags l.bad≠some 0#32 := by
  have hb : s.firstBad=1#32 :=
    Option.some.inj (s.badInitially.symm.trans hflag)
  intro hc
  have hzero : s.bad=0#32 := Option.some.inj (by
    simpa only [State.memory,CRefWord.store_read] using hc)
  exact (never_clears_bad s (by rw [hb]; decide)) hzero

theorem source_preserves_any_nonzero_bad (l : Layout) (ops : FprCalls)
    (k : Nat) (m : Memory) (s : State l m) (initial : Flag)
    (_hexec : run l ops k m=some s)
    (hflag : m.flags l.bad=some initial) (hprior : initial≠0#32) :
    s.memory.flags l.bad≠some 0#32 := by
  have hfirst : s.firstBad=initial :=
    Option.some.inj (s.badInitially.symm.trans hflag)
  intro hc
  have hzero : s.bad=0#32 := Option.some.inj (by
    simpa only [State.memory,CRefWord.store_read] using hc)
  exact (never_clears_bad s (by rw [hfirst]; exact hprior)) hzero

end FT1536.Source3.StableBinary

#check @FT1536.Source3.StableBinary.source_recursion_memory_and_sticky
#print FT1536.Source3.StableBinary.source_recursion_memory_and_sticky
#print axioms FT1536.Source3.StableBinary.source_parses
#print axioms FT1536.Source3.StableBinary.stable_source
#print axioms FT1536.Source3.StableBinary.half_exec_from_header
#print axioms FT1536.Source3.StableBinary.double_exec_from_header
#print axioms FT1536.Source3.StableBinary.call1_no_caller_write
#print axioms FT1536.Source3.StableBinary.call2_no_caller_write
#print axioms FT1536.Source3.StableBinary.source_loop_order
#print axioms FT1536.Source3.StableBinary.source_recursion
#print axioms FT1536.Source3.StableBinary.call_schedule_bounds
#print axioms FT1536.Source3.StableBinary.source_recursion_memory_and_sticky
#print axioms FT1536.Source3.StableBinary.source_preserves_prior_bad
#print axioms FT1536.Source3.StableBinary.source_preserves_any_nonzero_bad
