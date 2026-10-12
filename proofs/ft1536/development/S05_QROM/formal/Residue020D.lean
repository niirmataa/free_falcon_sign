import PairArithmetic020B
import Mathlib.Data.ZMod.Basic

namespace FT1536.S05.Residue020D
open WordRAM020 WordArithmetic020 PairArithmetic020B
abbrev F := ZMod 18433
def fw (a : F) : Word := word (a.val:Int)

theorem field_bounds (a : F) : 0≤(a.val:Int) ∧ (a.val:Int)<18433 := by
  have h := ZMod.val_lt a
  omega
theorem field_fits (a : F) : Fits (a.val:Int) :=
  bounded_fits _ (by have := field_bounds a;omega) (by have := field_bounds a;omega)
theorem decode_fw (a : F) : (fw a).toInt=(a.val:Int) := decode_word _ (field_fits a)

theorem modular_word (x : Int) : word (x%18433)=fw (x : F) := by
  apply congrArg word
  exact (ZMod.val_intCast x).symm

theorem value_cast (a : F) : ((a.val:Int):F)=a := by simp

theorem add_modular_word (a : F) (d : Int) :
    word (((a.val:Int)+d)%18433)=fw (a+(d:F)) := by
  rw [modular_word]
  congr 1
  rw [Int.cast_add,value_cast]

theorem product_modular_word (a b : F) :
    word (((a.val:Int)*(b.val:Int))%18433)=fw (a*b) := by
  simpa only [Int.cast_mul,value_cast] using modular_word ((a.val:Int)*(b.val:Int))

theorem neg_value_cast (a : F) : ((-((a.val:Int)) : Int):F)= -a := by
  rw [Int.cast_neg,value_cast]

end FT1536.S05.Residue020D
