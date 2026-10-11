import Mathlib.Data.Fin.Basic
import Mathlib.Tactic
import Init.Data.BitVec.Lemmas

/-! Closed, structured512-bit word RAM. No host-function instruction.
    Unit RAM/word prices are a MODEL, not native Lean/C execution prices. -/
set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.WordRAM020
abbrev Word := BitVec 512
abbrev Reg := Fin 32

def word (x : Int) : Word := BitVec.ofInt 512 x

def tapeSize : Nat := 24662538240
def romSize : Nat := 30721 + 61441 + 1536
def ramSize : Nat := 3072 + 1536
def outputSize : Nat := 50689

structure Input where
  tape : Fin tapeSize → Bool
  rom : Fin romSize → Word

structure State where
  reg : Reg → Word
  ram : Fin ramSize → Word
  out : Fin outputSize → Bool
  fault : Bool

def initial : State := ⟨fun _ => 0, fun _ => 0, fun _ => false, false⟩

def put (s : State) (r : Reg) (w : Word) : State :=
  {s with reg := Function.update s.reg r w}

def fail (s : State) : State := {s with fault := true}

inductive Op where
  | add | sub | mul | div | mod | lt | eq
  deriving DecidableEq, Repr

def op (o : Op) (a b : Word) : Word :=
  word (match o with
    | .add => a.toInt + b.toInt
    | .sub => a.toInt - b.toInt
    | .mul => a.toInt * b.toInt
    | .div => a.toInt / b.toInt
    | .mod => a.toInt % b.toInt
    | .lt => if a.toInt < b.toInt then 1 else 0
    | .eq => if a = b then 1 else 0)

inductive Expr where
  | lit (w : Word)
  | reg (r : Reg)
  | bin (o : Op) (a b : Expr)
  deriving Repr

def eval (s : State) : Expr → Word
  | .lit w => w
  | .reg r => s.reg r
  | .bin o a b => op o (eval s a) (eval s b)

/-- Includes reading immediate/register and each fixed-width operation. -/
def exprCost : Expr → Nat
  | .lit _ | .reg _ => 1
  | .bin _ a b => exprCost a + exprCost b + 1

inductive Atom where
  | set (r : Reg) (e : Expr)
  | loadROM (r : Reg) (a : Expr)
  | loadRAM (r : Reg) (a : Expr)
  | loadBit (r : Reg) (a : Expr)
  | store (a v : Expr)
  | emit (a v : Expr)
  deriving Repr

/-- Address check includes signed lower and upper comparisons.
    Negative addresses fault; they do not silently become zero. -/
def address (n : Nat) (w : Word) : Option (Fin n) :=
  if h : 0 ≤ w.toInt ∧ w.toInt.toNat < n then some ⟨w.toInt.toNat,h.2⟩ else none

def atomRun (i : Input) (a : Atom) (s : State) : State :=
  match a with
  | .set r e => put s r (eval s e)
  | .loadROM r a => match address romSize (eval s a) with
    | none => fail s
    | some k => put s r (i.rom k)
  | .loadRAM r a => match address ramSize (eval s a) with
    | none => fail s
    | some k => put s r (s.ram k)
  | .loadBit r a => match address tapeSize (eval s a) with
    | none => fail s
    | some k => put s r (if i.tape k then 1 else 0)
  | .store a v => match address ramSize (eval s a) with
    | none => fail s
    | some k => {s with ram := Function.update s.ram k (eval s v)}
  | .emit a v => match address outputSize (eval s a) with
    | none => fail s
    | some k => {s with out := Function.update s.out k (eval s v != 0)}

/-- Fetch+dispatch2; expressions; address/check3; memory1; register write1.
    Store/output includes a Boolean test even when unnecessary for store.
    These conservative fixed prices also cover invalid-address branches. -/
def atomCost : Atom → Nat
  | .set _ e => 3 + exprCost e
  | .loadROM _ a | .loadRAM _ a | .loadBit _ a => 7 + exprCost a
  | .store a v | .emit a v => 7 + exprCost a + exprCost v

inductive Code where
  | atom (a : Atom)
  | seq (a b : Code)
  | branch (e : Expr) (yes no : Code)
  | loop (cap : Nat) (guard : Expr) (body : Code)
  deriving Repr

/-- Bounded loop stops at the first false guard. A cap-zero invocation
    still pays the guard/cap/dispatch price; it never executes the body. -/
def iterate (f : State → State × Nat) (guard : Expr) : Nat → State → State × Nat
  | 0,s => (s,4 + exprCost guard)
  | n+1,s =>
    if eval s guard = 0 then (s,4 + exprCost guard) else
      let a := f s
      let b := iterate f guard n a.1
      (b.1,4 + exprCost guard + a.2 + b.2)

def run (i : Input) : Code → State → State × Nat
  | .atom a,s => (atomRun i a s,atomCost a)
  | .seq a b,s =>
    let x := run i a s
    let y := run i b x.1
    (y.1,2 + x.2 + y.2)
  | .branch e a b,s =>
    let x := if eval s e = 0 then run i b s else run i a s
    (x.1,3 + exprCost e + x.2)
  | .loop cap guard body,s => iterate (run i body) guard cap s

/-- Worst-case price, computed from this program's closed syntax. -/
def bound : Code → Nat
  | .atom a => atomCost a
  | .seq a b => 2 + bound a + bound b
  | .branch e a b => 3 + exprCost e + max (bound a) (bound b)
  | .loop cap guard body => (cap+1)*(4+exprCost guard) + cap*bound body

theorem iterate_bound (f : State → State × Nat) (g : Expr) (b : Nat)
    (hf : ∀ s, (f s).2 ≤ b) (n : Nat) (s : State) :
    (iterate f g n s).2 ≤ (n+1)*(4+exprCost g)+n*b := by
  induction n generalizing s with
  | zero => simp [iterate]
  | succ n ih =>
    simp only [iterate]
    split
    · simp only
      nlinarith [Nat.zero_le (exprCost g)]
    · simp only
      have h := ih (f s).1
      have h' := hf s
      nlinarith

/-- Applies to the real interpreter, including every expression/memory/control
    instruction; no success/no-overflow premise is needed for a time bound. -/
theorem run_bound (i : Input) (p : Code) (s : State) : (run i p s).2 ≤ bound p := by
  induction p generalizing s with
  | atom a => exact le_refl _
  | seq a b ha hb =>
    simpa only [run,bound,Nat.add_assoc] using Nat.add_le_add_left (Nat.add_le_add (ha s) (hb (run i a s).1)) 2
  | branch e a b ha hb =>
    simp only [run,bound]
    split
    · exact Nat.add_le_add_left (le_trans (hb s) (le_max_right _ _)) _
    · exact Nat.add_le_add_left (le_trans (ha s) (le_max_left _ _)) _
  | loop cap guard body ih => exact iterate_bound (run i body) guard (bound body) ih cap s

/-- Conservative fixed-slot serialization: each syntax node reserves four
    words, plus its children. Immediate/cap/address widths are a separate
    well-formed-program obligation. No exponentially expanded loop tree. -/
def exprNodes : Expr → Nat
  | .lit _ | .reg _ => 1
  | .bin _ a b => 1 + exprNodes a + exprNodes b

def atomNodes : Atom → Nat
  | .set _ e | .loadROM _ e | .loadRAM _ e | .loadBit _ e => 1+exprNodes e
  | .store a v | .emit a v => 1+exprNodes a+exprNodes v

def nodes : Code → Nat
  | .atom a => atomNodes a
  | .seq a b => 1+nodes a+nodes b
  | .branch e a b => 1+exprNodes e+nodes a+nodes b
  | .loop _ g b => 1+exprNodes g+nodes b

def depth : Code → Nat
  | .atom _ => 1
  | .seq a b => 1+max (depth a) (depth b)
  | .branch _ a b => 1+max (depth a) (depth b)
  | .loop _ _ b => 1+depth b

/-- Data storage is actual finite banks. Code/control allocation is a
    proposed explicit-stack implementation bound, NOT yet a refinement proof. -/
def dataBits : Nat := tapeSize + 512*(romSize+ramSize+32) + outputSize

theorem put_same (s : State) (r : Reg) (w : Word) : (put s r w).reg r = w := by
  simp [put]

theorem put_other (s : State) (r k : Reg) (w : Word) (hk : k ≠ r) :
    (put s r w).reg k = s.reg k := by simp [put,Function.update, hk]

theorem put_memory (s : State) (r : Reg) (w : Word) :
    (put s r w).ram = s.ram ∧ (put s r w).out = s.out ∧ (put s r w).fault = s.fault := by
  exact ⟨rfl,rfl,rfl⟩

theorem word_exact (x : Int) (lo : -(2^511) ≤ x) (hi : x < 2^511) :
    (word x).toInt = x := by
  exact BitVec.toInt_ofInt_eq_self (by decide) lo hi

theorem address_exact (n k : Nat) (hk : k < n) (hw : (k : Int) < 2^511) :
    address n (word k) = some ⟨k,hk⟩ := by
  have h := word_exact (k : Int) (le_trans (neg_nonpos.mpr (pow_nonneg (by decide) _)) (Nat.cast_nonneg _)) hw
  simp [address,h,hk]

theorem initial_no_fault : initial.fault = false := rfl

end FT1536.S05.WordRAM020
