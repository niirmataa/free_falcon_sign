import Source3.KeygenSmallOutput

/- Little-endian 16-bit objects and their C integer promotions. Object
   extents are byte extents; promotion does not read four bytes. -/
namespace FT1536.Source3.C99NarrowReads
open C99MemoryReference

def le16 (bytes : Fin 2 → Byte) : BitVec 16 := bytes 1 ++ bytes 0

inductive Load16 : Memory → ArrayPointer → BitVec 16 → Prop where
  | load (h : Memory) (p : ArrayPointer) (b : Fin 2 → Byte)
      (allocated : Allocated h p) (typeSize : p.elementBytes=2)
      (initialized : ∀ i : Fin 2, h.bytes p.block (p.offset+i.val)=some (b i)) :
      Load16 h p (le16 b)

def signedPromotion (w : BitVec 16) : C99IntegerReference.Value := .int32 (BitVec.ofInt 32 w.toInt)
def unsignedPromotion (w : BitVec 16) : C99IntegerReference.Value := .int32 (BitVec.ofNat 32 w.toNat)

theorem signed_promotion_exact (w : BitVec 16) : (signedPromotion w).integer=w.toInt := by
  have hlo := w.le_toInt
  have hhi := w.toInt_lt
  change (BitVec.ofInt 32 w.toInt).toInt=w.toInt
  exact BitVec.toInt_ofInt_eq_self (by decide) (by norm_num at *; omega) (by norm_num at *; omega)

theorem unsigned_promotion_exact (w : BitVec 16) : (unsignedPromotion w).integer=(w.toNat : Int) := by
  have hn := w.isLt
  change (BitVec.ofNat 32 w.toNat).toInt=(w.toNat : Int)
  rw [BitVec.toInt_eq_toNat_of_lt (by simp only [BitVec.toNat_ofNat]; omega)]
  simp only [BitVec.toNat_ofNat]
  congr 1
  omega

theorem load16_deterministic (h : Memory) (p : ArrayPointer) (x y : BitVec 16)
    (hx : Load16 h p x) (hy : Load16 h p y) : x=y := by
  cases hx with
  | load a ha hs hb =>
      cases hy with
      | load b hc ht hd =>
          have he : a=b := by
            funext i
            exact Option.some.inj ((hb i).symm.trans (hd i))
          rw [he]

theorem load16_transport (before after : Memory) (p : ArrayPointer) (w : BitVec 16)
    (h : Load16 before p w) (sizes : after.size=before.size)
    (bytes : ∀ i : Fin 2, after.bytes p.block (p.offset+i.val)=before.bytes p.block (p.offset+i.val)) :
    Load16 after p w := by
  cases h with
  | load b ha hs hb =>
      exact Load16.load after p b (by simpa only [Allocated,sizes] using ha) hs
        (fun i => (bytes i).trans (hb i))

end FT1536.Source3.C99NarrowReads
