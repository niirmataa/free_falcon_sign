import StandaloneRuntime019
import Run2.WordEncoding
import WordRAM020

set_option maxRecDepth 4096
namespace FT1536.S05.PairEncoding020
open FT1536.Relation FT1536.PublicSimulation FT1536.Run2.BitArithmetic

def keyCell (c : Rq) (i : Fin 768) : List Bool :=
  encodeNat (c i).1.val 16 ++ encodeNat (c i).2.val 16

def replyCell (z : BoxVec) (i : Fin 768) : List Bool :=
  encodeNat (z i).1.val 17 ++ encodeNat (z i).2.val 17

def keyBits (c : Rq) : List Bool := (List.ofFn (keyCell c)).flatten

def replyBits (z : BoxVec) : List Bool := (List.ofFn (replyCell z)).flatten

/-- Fixed-width encoding of the entire observation, including none.
    Public code019 emits some; the reference law may emit none. -/
def encode (a : Rq × Option BoxVec) : List Bool :=
  keyBits a.1 ++ match a.2 with
    | none => false :: List.replicate 26112 false
    | some z => true :: replyBits z

theorem keyCell_length (c : Rq) (i : Fin 768) : (keyCell c i).length = 32 := by
  simp [keyCell,encodeNat_length]

theorem replyCell_length (z : BoxVec) (i : Fin 768) : (replyCell z i).length = 34 := by
  simp [replyCell,encodeNat_length]

theorem flatten_fixed_length {A : Type} (f : A → List Bool) (xs : List A) (n : Nat)
    (h : ∀ a, (f a).length=n) : (xs.map f).flatten.length=xs.length*n := by
  induction xs with
  | nil => simp
  | cons a xs ih => simp [h,ih,Nat.add_mul,Nat.add_comm]

theorem keyBits_length (c : Rq) : (keyBits c).length = 24576 := by
  have h := flatten_fixed_length (keyCell c) (List.finRange 768) 32 (keyCell_length c)
  simpa only [keyBits,List.ofFn_eq_map,List.length_finRange] using h

theorem replyBits_length (z : BoxVec) : (replyBits z).length = 26112 := by
  have h := flatten_fixed_length (replyCell z) (List.finRange 768) 34 (replyCell_length z)
  simpa only [replyBits,List.ofFn_eq_map,List.length_finRange] using h

theorem full_pair_length (a : Rq × Option BoxVec) : (encode a).length = 50689 := by
  unfold encode
  cases a.2 <;> simp only [List.length_append,keyBits_length,List.length_cons,List.length_replicate,replyBits_length]

theorem no_failure_erasure (c d : Rq) (z : BoxVec) : encode (c,none) ≠ encode (d,some z) := by
  intro h
  have he := congrArg (fun xs : List Bool => xs.drop 24576) h
  have dropKey (k : Rq) (xs : List Bool) : (keyBits k ++ xs).drop 24576=xs := by
    rw [←keyBits_length k, List.drop_left]
  change (keyBits c ++ false :: List.replicate 26112 false).drop 24576 =
    (keyBits d ++ true :: replyBits z).drop 24576 at he
  rw [dropKey,dropKey] at he
  cases he

/-- Each field value fits the16-bit branch; no silent low-bit truncation. -/
theorem field_word_exact (a : ZMod 18433) : value (encodeNat a.val 16)=a.val := by
  apply encodeNat_value
  have := ZMod.val_lt a
  omega

theorem box_word_exact (a : Fin 131071) : value (encodeNat a.val 17)=a.val := by
  apply encodeNat_value
  have := a.isLt
  omega

end FT1536.S05.PairEncoding020
