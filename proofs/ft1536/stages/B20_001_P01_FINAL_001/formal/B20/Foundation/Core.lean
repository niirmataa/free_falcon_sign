namespace B20.Foundation

abbrev Word8 := BitVec 8
abbrev Word32 := BitVec 32
abbrev Word64 := BitVec 64

structure ABI where
  charBits : Nat := 8
  shortBits : Nat := 16
  intBits : Nat := 32
  longBits : Nat := 64
  pointerBits : Nat := 64
  sizeBits : Nat := 64
  littleEndian : Bool := true
  deriving DecidableEq, Repr

def defaultABI : ABI := {}

/-- Byte-addressed partial memory: allocated bytes are `some`, the rest `none`. -/
structure Memory where
  bytes : Nat -> Option Word8

namespace Memory

def byteAt (m : Memory) (a : Nat) : Nat :=
  match m.bytes a with
  | some b => b.toNat
  | none => 0

def readU64 (m : Memory) (base : Nat) : Option Word64 :=
  some (BitVec.ofNat 64 ((List.range 8).foldl
    (fun acc i => acc + m.byteAt (base + i) * 2^(8*i)) 0))

def writeU64 (m : Memory) (base : Nat) (v : Word64) : Memory :=
  { bytes := fun a =>
      if _h : a >= base then
        let i := a - base
        if i < 8 then some (BitVec.ofNat 8 ((v.toNat >>> (8*i)) % 256)) else m.bytes a
      else m.bytes a }

def legalU64 (m : Memory) (base : Nat) : Prop :=
  forall i, i < 8 -> (m.bytes (base + i)).isSome

end Memory

structure Region where
  base : Nat
  size : Nat
  deriving DecidableEq, Repr

namespace Region

def contains (r : Region) (a : Nat) : Prop := r.base <= a ∧ a < r.base + r.size

def legal (r : Region) (m : Memory) : Prop :=
  forall i, i < r.size -> (m.bytes (r.base + i)).isSome

end Region

/-- Unsigned modular 64-bit arithmetic (wraps modulo 2^64). -/
def u64Add (x y : Word64) : Word64 := x + y

theorem u64Add_toNat (x y : Word64) :
    (u64Add x y).toNat = (x.toNat + y.toNat) % 2^64 := by
  simp [u64Add]

def u64Xor (x y : Word64) : Word64 := x ^^^ y
def u64And (x y : Word64) : Word64 := x &&& y
def u64ShiftRight (x : Word64) (n : Nat) : Word64 := x >>> n
def u64Neg (x : Word64) : Word64 := -x

structure State where
  mem : Memory
  locals : String -> Option Word64

def State.loadLocal (s : State) (x : String) : Option Word64 := s.locals x

/-- Empty initial state: no allocated bytes, no bound locals. -/
def initState : State := { mem := ⟨fun _ => none⟩, locals := fun _ => none }

end B20.Foundation
