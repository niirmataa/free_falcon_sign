import Source3.C99ScalarReference

/- Reference object-representation rules, C99 6.2.6.1/6.2.6.2, 6.3.2.3,
   6.5.6, and 7.21.2.1. The profile chooses 8-bit bytes and little endian.
   These relations are pointwise byte predicates, with no call to the old
   memory evaluator or typed object overlay. Subobject/array extent and
   alignment are carried by array descriptors, not inferred from a desired
   result. Binding these descriptors to the declarations/lifetimes of the
   pointer-taking source function is a separate, not-yet-proved obligation. -/
namespace FT1536.Source3.C99MemoryReference

abbrev Byte := BitVec 8
structure Memory where
  bytes : Nat → Nat → Option Byte
  size : Nat → Nat
  writable : Nat → Bool

structure ArrayPointer where
  block : Nat
  base : Nat
  count : Nat
  elementBytes : Nat
  index : Nat
  deriving DecidableEq, Repr

def ArrayPointer.offset (p : ArrayPointer) : Nat := p.base+p.elementBytes*p.index
def Allocated (h : Memory) (p : ArrayPointer) : Prop :=
  0<p.elementBytes ∧ p.base%p.elementBytes=0 ∧ p.index<p.count ∧
  p.base+p.elementBytes*p.count≤h.size p.block ∧ h.size p.block<2^64

/- Pointer arithmetic within an array, including its one-past pointer.
   Access rules below require strictly in-bounds (`Allocated`) separately. -/
inductive PointerAdd : ArrayPointer → Nat → ArrayPointer → Prop where
  | within (p : ArrayPointer) (i : Nat) (bound : p.index+i≤p.count) :
      PointerAdd p i {p with index := p.index+i}

def le64 (b : Fin 8 → Byte) : BitVec 64 :=
  b 7 ++ (b 6 ++ (b 5 ++ (b 4 ++ (b 3 ++ (b 2 ++ (b 1 ++ b 0))))))
def le32 (b : Fin 4 → Byte) : BitVec 32 := b 3 ++ (b 2 ++ (b 1 ++ b 0))
def byte64 (w : BitVec 64) (i : Fin 8) : Byte := (w >>> (8*i.val)).setWidth 8
def byte32 (w : BitVec 32) (i : Fin 4) : Byte := (w >>> (8*i.val)).setWidth 8

inductive Load64 : Memory → ArrayPointer → BitVec 64 → Prop where
  | load (h : Memory) (p : ArrayPointer) (b : Fin 8 → Byte)
      (allocated : Allocated h p) (typeSize : p.elementBytes=8)
      (initialized : ∀ i : Fin 8, h.bytes p.block (p.offset+i.val)=some (b i)) :
      Load64 h p (le64 b)

inductive Load32 : Memory → ArrayPointer → BitVec 32 → Prop where
  | load (h : Memory) (p : ArrayPointer) (b : Fin 4 → Byte)
      (allocated : Allocated h p) (typeSize : p.elementBytes=4)
      (initialized : ∀ i : Fin 4, h.bytes p.block (p.offset+i.val)=some (b i)) :
      Load32 h p (le32 b)

def Store64 (before : Memory) (p : ArrayPointer) (w : BitVec 64) (after : Memory) : Prop :=
  Allocated before p ∧ p.elementBytes=8 ∧ before.writable p.block=true ∧
  after.size=before.size ∧ after.writable=before.writable ∧
  (∀ i : Fin 8, after.bytes p.block (p.offset+i.val)=some (byte64 w i)) ∧
  (∀ block offset, block≠p.block ∨ offset<p.offset ∨ p.offset+8≤offset →
    after.bytes block offset=before.bytes block offset)

def Store32 (before : Memory) (p : ArrayPointer) (w : BitVec 32) (after : Memory) : Prop :=
  Allocated before p ∧ p.elementBytes=4 ∧ before.writable p.block=true ∧
  after.size=before.size ∧ after.writable=before.writable ∧
  (∀ i : Fin 4, after.bytes p.block (p.offset+i.val)=some (byte32 w i)) ∧
  (∀ block offset, block≠p.block ∨ offset<p.offset ∨ p.offset+4≤offset →
    after.bytes block offset=before.bytes block offset)

/- The number of BYTES is explicit; the disjointness is of physical byte
   extents, and copying always refers to the pre-call snapshot. -/
def Memcpy (before : Memory) (dst src : ArrayPointer) (bytes : Nat) (after : Memory) : Prop :=
  dst.offset+bytes≤before.size dst.block ∧ src.offset+bytes≤before.size src.block ∧
  before.size dst.block<2^64 ∧ before.size src.block<2^64 ∧
  before.writable dst.block=true ∧
  (dst.block≠src.block ∨ dst.offset+bytes≤src.offset ∨ src.offset+bytes≤dst.offset) ∧
  (∀ i<bytes, (before.bytes src.block (src.offset+i)).isSome) ∧
  after.size=before.size ∧ after.writable=before.writable ∧
  (∀ i<bytes, after.bytes dst.block (dst.offset+i)=before.bytes src.block (src.offset+i)) ∧
  (∀ block offset, block≠dst.block ∨ offset<dst.offset ∨ dst.offset+bytes≤offset →
    after.bytes block offset=before.bytes block offset)

theorem load64_deterministic (h : Memory) (p : ArrayPointer) (x y : BitVec 64)
    (hx : Load64 h p x) (hy : Load64 h p y) : x=y := by
  cases hx with
  | load b alloc size initialized =>
      cases hy with
      | load b' alloc' size' initialized' =>
          have hb : b=b' := by
            funext i
            exact Option.some.inj ((initialized i).symm.trans (initialized' i))
          rw [hb]

theorem memcpy_deterministic (before : Memory) (dst src : ArrayPointer)
    (n : Nat) (a b : Memory) (ha : Memcpy before dst src n a) (hb : Memcpy before dst src n b) :
    a=b := by
  obtain ⟨_,_,_,_,_,_,_,has,haw,hac,haf⟩ := ha
  obtain ⟨_,_,_,_,_,_,_,hbs,hbw,hbc,hbf⟩ := hb
  have heq : a.bytes=b.bytes := by
    funext block offset
    by_cases hi : block=dst.block ∧ dst.offset≤offset ∧ offset<dst.offset+n
    · obtain ⟨rfl,hlo,hhi⟩ := hi
      have hn : offset-dst.offset<n := by omega
      have ha' := hac (offset-dst.offset) hn
      have hb' := hbc (offset-dst.offset) hn
      have hp : dst.offset+(offset-dst.offset)=offset := by omega
      rw [hp] at ha' hb'
      exact ha'.trans hb'.symm
    · have hout : block≠dst.block ∨ offset<dst.offset ∨ dst.offset+n≤offset := by omega
      exact (haf block offset hout).trans (hbf block offset hout).symm
  cases a; cases b
  simp_all

end FT1536.Source3.C99MemoryReference

#print axioms FT1536.Source3.C99MemoryReference.load64_deterministic
#print axioms FT1536.Source3.C99MemoryReference.memcpy_deterministic
