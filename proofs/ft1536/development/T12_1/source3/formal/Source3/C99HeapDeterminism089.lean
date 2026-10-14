import Source3.ShakeSeedMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99HeapDeterminism089
open C99MemoryReference

structure ByteWrite (before : Memory) (p : ArrayPointer) (count : Nat)
    (data : Fin count → Byte) (after : Memory) : Prop where
  sizes : after.size = before.size
  writable : after.writable = before.writable
  bytes : ∀ i : Fin count, after.bytes p.block (p.offset + i.val) = some (data i)
  frame : ∀ b o, b ≠ p.block ∨ o < p.offset ∨ p.offset + count ≤ o →
    after.bytes b o = before.bytes b o

theorem write_unique (before : Memory) (p : ArrayPointer) (count : Nat)
    (data : Fin count → Byte) (a b : Memory)
    (first : ByteWrite before p count data a) (second : ByteWrite before p count data b) : a = b := by
  have bytes : a.bytes = b.bytes := by
    funext block offset
    by_cases inside : block = p.block ∧ p.offset ≤ offset ∧ offset < p.offset + count
    · obtain ⟨rfl, lower, upper⟩ := inside
      let i : Fin count := ⟨offset - p.offset, by omega⟩
      have positionEq : p.offset + i.val = offset := by dsimp [i]; omega
      have one := first.bytes i
      have two := second.bytes i
      rw [positionEq] at one two
      exact one.trans two.symm
    · have outside : block ≠ p.block ∨ offset < p.offset ∨ p.offset + count ≤ offset := by omega
      exact (first.frame block offset outside).trans (second.frame block offset outside).symm
  have sizes := first.sizes.trans second.sizes.symm
  have writable := first.writable.trans second.writable.symm
  cases a
  cases b
  simp_all

theorem store64 (before : Memory) (p : ArrayPointer) (word : BitVec 64) (a b : Memory)
    (first : Store64 before p word a) (second : Store64 before p word b) : a = b := by
  obtain ⟨_, _, _, sa, wa, ba, fa⟩ := first
  obtain ⟨_, _, _, sb, wb, bb, fb⟩ := second
  exact write_unique before p 8 (byte64 word) a b ⟨sa, wa, ba, fa⟩ ⟨sb, wb, bb, fb⟩

theorem store32 (before : Memory) (p : ArrayPointer) (word : BitVec 32) (a b : Memory)
    (first : Store32 before p word a) (second : Store32 before p word b) : a = b := by
  obtain ⟨_, _, _, sa, wa, ba, fa⟩ := first
  obtain ⟨_, _, _, sb, wb, bb, fb⟩ := second
  exact write_unique before p 4 (byte32 word) a b ⟨sa, wa, ba, fa⟩ ⟨sb, wb, bb, fb⟩

theorem store8_footprint (before : Memory) (p : ArrayPointer) (word : Byte) (after : Memory)
    (source : ShakeEncode.Store8 before p word after) : ByteWrite before p 1 (fun _ => word) after := by
  obtain ⟨_, _, _, sizes, writable, bytes, frame⟩ := source
  refine ⟨sizes, writable, ?_, ?_⟩
  · intro i
    have zero : i.val = 0 := by have := i.isLt; omega
    simpa only [zero, Nat.add_zero] using bytes
  · intro b o outside
    apply frame b o
    omega

theorem store8 (before : Memory) (p : ArrayPointer) (word : Byte) (a b : Memory)
    (first : ShakeEncode.Store8 before p word a) (second : ShakeEncode.Store8 before p word b) : a = b :=
  write_unique before p 1 (fun _ => word) a b
    (store8_footprint before p word a first) (store8_footprint before p word b second)

theorem fill (before : Memory) (p : ArrayPointer) (count : Nat) (word : Byte) (a b : Memory)
    (first : ShakeSeedMemory.Fill before p count word a)
    (second : ShakeSeedMemory.Fill before p count word b) : a = b := by
  obtain ⟨_, _, _, _, sa, wa, ba, fa⟩ := first
  obtain ⟨_, _, _, _, sb, wb, bb, fb⟩ := second
  exact write_unique before p count (fun _ => word) a b
    ⟨sa, wa, fun i => ba i.val i.isLt, fa⟩ ⟨sb, wb, fun i => bb i.val i.isLt, fb⟩

theorem pointer_add (p : ArrayPointer) (n : Nat) (a b : ArrayPointer)
    (first : PointerAdd p n a) (second : PointerAdd p n b) : a = b := by
  cases first
  cases second
  rfl

end FT1536.Source3.C99HeapDeterminism089
