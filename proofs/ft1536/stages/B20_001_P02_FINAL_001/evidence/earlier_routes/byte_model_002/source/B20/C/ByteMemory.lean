import B20.C.Parser
import Lean.Elab.Tactic.Omega

namespace B20.C.Byte

abbrev U8 := BitVec 8
abbrev U64 := BitVec 64

/-- Object identity and byte offset. No integer-to-pointer conversions or
allocation/lifetime operations are admitted by this fragment. -/
structure Pointer where
  block : Nat
  offset : Nat
  deriving DecidableEq, Repr

def Pointer.add (p : Pointer) (i : Nat) : Pointer := ⟨p.block, p.offset + i⟩

structure Memory where
  contents : Pointer → Option U8
  length : Nat → Nat
  writable : Nat → Bool

def inBounds (m : Memory) (p : Pointer) : Prop :=
  p.offset < m.length p.block ∧ m.length p.block < 2^64

instance (m : Memory) (p : Pointer) : Decidable (inBounds m p) := inferInstanceAs (Decidable (_ ∧ _))

def readByte (m : Memory) (p : Pointer) : Option U8 :=
  if inBounds m p then m.contents p else none

def putByte (m : Memory) (p : Pointer) (b : U8) : Memory :=
  { m with contents := fun q => if q = p then some b else m.contents q }

def writeByte (m : Memory) (p : Pointer) (b : U8) : Option Memory :=
  if inBounds m p ∧ m.writable p.block = true ∧ (m.contents p).isSome then
    some (putByte m p b)
  else none

/-- Explicit read permission and initialized bytes for the eight C accesses. -/
def ReadRegion (m : Memory) (p : Pointer) : Prop :=
  p.offset + 8 ≤ m.length p.block ∧ m.length p.block < 2^64 ∧
    ∀ i : Fin 8, (m.contents (p.add i.val)).isSome

def WriteRegion (m : Memory) (p : Pointer) : Prop :=
  ReadRegion m p ∧ m.writable p.block = true

def RegionBytes (m : Memory) (p : Pointer) (bytes : Fin 8 → U8) : Prop :=
  ∀ i : Fin 8, m.contents (p.add i.val) = some (bytes i)

theorem access_inBounds (m : Memory) (p : Pointer) (h : ReadRegion m p) (i : Fin 8) :
    inBounds m (p.add i.val) := by
  obtain ⟨hl, hm, _⟩ := h
  exact ⟨by have hi := i.isLt; dsimp [Pointer.add]; omega, hm⟩

theorem read_region_byte (m : Memory) (p : Pointer) (bytes : Fin 8 → U8)
    (hr : ReadRegion m p) (hb : RegionBytes m p bytes) (i : Fin 8) :
    readByte m (p.add i.val) = some (bytes i) := by
  rw [readByte, if_pos (access_inBounds m p hr i), hb i]

theorem put_preserves_read (m : Memory) (p q : Pointer) (b : U8) (h : ReadRegion m p) :
    ReadRegion (putByte m q b) p := by
  refine ⟨h.1, h.2.1, ?_⟩
  intro i
  by_cases e : p.add i.val = q
  · simp [putByte, e]
  · simpa [putByte, e] using h.2.2 i

theorem put_preserves_write (m : Memory) (p q : Pointer) (b : U8) (h : WriteRegion m p) :
    WriteRegion (putByte m q b) p :=
  ⟨put_preserves_read m p q b h.1, h.2⟩

theorem write_region_byte (m : Memory) (p : Pointer) (b : U8)
    (h : WriteRegion m p) (i : Fin 8) :
    writeByte m (p.add i.val) b = some (putByte m (p.add i.val) b) := by
  apply if_pos
  exact ⟨access_inBounds m p h.1 i, h.2, h.1.2.2 i⟩

theorem put_frame (m : Memory) (p q : Pointer) (b : U8) (h : q ≠ p) :
    (putByte m p b).contents q = m.contents q := by simp [putByte, h]

inductive Value where
  | byte (b : U8)
  | word (w : U64)
  deriving DecidableEq, Repr

def Value.toWord : Value → U64
  | .byte b => b.setWidth 64
  | .word w => w

inductive Expr where
  | wordVar (name : Name)
  | read (ptr : Name) (index : Nat)
  | toWord (arg : Expr)
  | toByte (arg : Expr)
  | shr (arg : Expr) (count : Nat)
  | shl (arg : Expr) (count : Nat)
  | bor (left right : Expr)
  deriving DecidableEq, Repr

inductive Statement where
  | declarePointer (name : Name) (isConst : Bool)
  | assignPointer (dst src : Name)
  | store (ptr : Name) (index : Nat) (value : Expr)
  | ret (value : Expr)
  deriving DecidableEq, Repr

inductive Param where
  | pointer (isConst : Bool) (name : Name)
  | word (name : Name)
  deriving DecidableEq, Repr

structure Function where
  returnsWord : Bool
  name : Name
  params : List Param
  body : List Statement
  deriving DecidableEq, Repr

structure State where
  memory : Memory
  pointers : Name → Option (Bool × Option Pointer)
  words : Name → Option U64

def evalExpr (s : State) : Expr → Option Value
  | .wordVar name => (s.words name).map Value.word
  | .read name index => do
    let (_, ptr) ← s.pointers name
    let p ← ptr
    let byte ← readByte s.memory (p.add index)
    pure (.byte byte)
  | .toWord arg => (evalExpr s arg).map (fun v => .word v.toWord)
  | .toByte arg => (evalExpr s arg).map (fun v => .byte (v.toWord.setWidth 8))
  | .shr arg n => do
    match ← evalExpr s arg with
    | .word x => if n < 64 then pure (.word (x >>> n)) else none
    | .byte _ => none
  | .shl arg n => do
    match ← evalExpr s arg with
    | .word x => if n < 64 then pure (.word (x <<< n)) else none
    | .byte _ => none
  | .bor a b => do
    match ← evalExpr s a, ← evalExpr s b with
    | .word x, .word y => pure (.word (x ||| y))
    | _, _ => none

def updatePointer (s : State) (name : Name) (v : Bool × Option Pointer) : State :=
  { s with pointers := fun other => if other = name then some v else s.pointers other }

def step (s : State) : Statement → Option State
  | .declarePointer name c =>
    if (s.pointers name).isSome then none else some (updatePointer s name (c, none))
  | .assignPointer dst src => do
    let (dstConst, _) ← s.pointers dst
    let (srcConst, ptr) ← s.pointers src
    let p ← ptr
    if srcConst && !dstConst then none else pure (updatePointer s dst (dstConst, some p))
  | .store name index expr => do
    let (isConst, ptr) ← s.pointers name
    let p ← ptr
    if isConst then none else do
      let v ← evalExpr s expr
      let m ← writeByte s.memory (p.add index) (v.toWord.setWidth 8)
      pure { s with memory := m }
  | .ret _ => none

def evalBody (returnsWord : Bool) : List Statement → State → Option (Option U64 × Memory)
  | [], s => if returnsWord then none else some (none, s.memory)
  | .ret e :: _, s =>
    if returnsWord then do
      let v ← evalExpr s e
      pure (some v.toWord, s.memory)
    else none
  | stmt :: rest, s => do evalBody returnsWord rest (← step s stmt)

inductive Arg where
  | pointer (ptr : Pointer)
  | word (w : U64)

def bindArgs (memory : Memory) : List Param → List Arg → Option State
  | [], [] => some ⟨memory, fun _ => none, fun _ => none⟩
  | .pointer c name :: ps, .pointer ptr :: vs => do
    let s ← bindArgs memory ps vs
    if (s.pointers name).isSome then none else pure (updatePointer s name (c, some ptr))
  | .word name :: ps, .word w :: vs => do
    let s ← bindArgs memory ps vs
    if (s.words name).isSome then none else pure { s with words := fun x => if x = name then some w else s.words x }
  | _, _ => none

def execute (f : Function) (memory : Memory) (args : List Arg) : Option (Option U64 × Memory) := do
  evalBody f.returnsWord f.body (← bindArgs memory f.params args)

def CExec (f : Function) (memory : Memory) (args : List Arg) (result : Option U64) (final : Memory) : Prop :=
  execute f memory args = some (result, final)

end B20.C.Byte
