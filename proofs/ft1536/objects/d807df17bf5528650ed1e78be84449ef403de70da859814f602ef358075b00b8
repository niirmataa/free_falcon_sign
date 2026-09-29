import B20.C.ByteMemory
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.FinCases

namespace B20.Word.LE
open B20.C.Byte

/-- Independent specification by concatenation, most significant byte first. -/
def join (b : Fin 8 → U8) : U64 :=
  b 7 ++ (b 6 ++ (b 5 ++ (b 4 ++ (b 3 ++ (b 2 ++ (b 1 ++ b 0))))))

def orWord (b : Fin 8 → U8) : U64 :=
  (b 0).setWidth 64 ||| ((b 1).setWidth 64 <<< 8) |||
    ((b 2).setWidth 64 <<< 16) ||| ((b 3).setWidth 64 <<< 24) |||
    ((b 4).setWidth 64 <<< 32) ||| ((b 5).setWidth 64 <<< 40) |||
    ((b 6).setWidth 64 <<< 48) ||| ((b 7).setWidth 64 <<< 56)

theorem or_left_comm (x y z : U64) : x ||| (y ||| z) = y ||| (x ||| z) := by
  rw [← BitVec.or_assoc, BitVec.or_comm x y, BitVec.or_assoc]

theorem orWord_eq_join (b : Fin 8 → U8) : orWord b = join b := by
  change orWord b = (join b).setWidth 64
  simp only [join, BitVec.setWidth_append_eq_shiftLeft_setWidth_or]
  simp only [orWord, BitVec.or_assoc, BitVec.or_comm, or_left_comm]

def byteOf (w : U64) (i : Fin 8) : U8 := (w >>> (8 * i.val)).setWidth 8

theorem join_byteOf (w : U64) : join (byteOf w) = w := by
  have bits (i : Fin 64) : (join (byteOf w)).getLsbD i.val = w.getLsbD i.val := by
    fin_cases i <;> simp [join, byteOf, BitVec.getElem_append]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  exact bits ⟨i, hi⟩

def indices : List (Fin 8) := [0, 1, 2, 3, 4, 5, 6, 7]

def storeBytes (p : Pointer) (w : U64) : List (Fin 8) → Memory → Memory
  | [], m => m
  | i :: rest, m => storeBytes p w rest (putByte m (p.add i.val) (byteOf w i))

def stored (m : Memory) (p : Pointer) (w : U64) := storeBytes p w indices m

theorem storeBytes_preserves_write (p : Pointer) (w : U64) (is : List (Fin 8))
    (m : Memory) (h : WriteRegion m p) : WriteRegion (storeBytes p w is m) p := by
  induction is generalizing m with
  | nil => exact h
  | cons i is ih => exact ih _ (put_preserves_write m p (p.add i.val) (byteOf w i) h)

theorem storeBytes_frame (p q : Pointer) (w : U64) (is : List (Fin 8))
    (m : Memory) (h : ∀ i : Fin 8, q ≠ p.add i.val) :
    (storeBytes p w is m).contents q = m.contents q := by
  induction is generalizing m with
  | nil => rfl
  | cons i is ih =>
    change (storeBytes p w is (putByte m (p.add i.val) (byteOf w i))).contents q = _
    rw [ih, put_frame m (p.add i.val) q (byteOf w i) (h i)]

theorem stored_bytes (m : Memory) (p : Pointer) (w : U64) :
    RegionBytes (stored m p w) p (byteOf w) := by
  intro i
  fin_cases i <;> simp [stored, storeBytes, indices, putByte, Pointer.add]

def bufferBytes (m : Memory) (p : Pointer) (i : Fin 8) : U8 :=
  (m.contents (p.add i.val)).getD 0

theorem bufferBytes_spec (m : Memory) (p : Pointer) (h : ReadRegion m p) :
    RegionBytes m p (bufferBytes m p) := by
  intro i
  cases hc : m.contents (p.add i.val) with
  | none =>
    have hi := h.2.2 i
    simp [hc] at hi
  | some b => simp [bufferBytes, hc]

end B20.Word.LE
