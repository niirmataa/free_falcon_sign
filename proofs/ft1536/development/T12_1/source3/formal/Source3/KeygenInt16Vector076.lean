import Source3.KeygenPublicInputMaterial
import Source3.KeygenCodecStaticMemoryIdentity

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- EXACT existing Geometry.Vec layout: first768 first coordinates, then768
   second coordinates, matching the source Material representation. -/
namespace FT1536.Source3.KeygenInt16Vector076
open FT1536.Geometry

abbrev Words := Fin 1536 → BitVec 16

def lowIndex (i : Fin 768) : Fin 1536 := ⟨i.val,by have bound:=i.isLt; omega⟩
def highIndex (i : Fin 768) : Fin 1536 := ⟨i.val+768,by have bound:=i.isLt; omega⟩
def coefficient (v : Vec) (i : Fin 1536) : Int := KeygenPublicInputMaterial.coefficient v i.val
def words (v : Vec) : Words := fun i => BitVec.ofInt 16 (coefficient v i)
def vector (w : Words) : Vec := fun i => ((w (lowIndex i)).toInt,(w (highIndex i)).toInt)
def Signed16 (v : Vec) : Prop := ∀ i,
  (-32768≤(v i).1 ∧ (v i).1≤32767) ∧ (-32768≤(v i).2 ∧ (v i).2≤32767)

theorem coefficient_low (v : Vec) (i : Fin 768) : coefficient v (lowIndex i)=(v i).1 := by
  unfold coefficient KeygenPublicInputMaterial.coefficient lowIndex
  dsimp only
  rw [dite_eq_left i.isLt]

theorem coefficient_high (v : Vec) (i : Fin 768) : coefficient v (highIndex i)=(v i).2 := by
  unfold coefficient KeygenPublicInputMaterial.coefficient highIndex
  dsimp only
  rw [dite_eq_right (by omega),dite_eq_left (by have bound:=i.isLt; omega)]
  have same : (⟨i.val+768-768,by have bound:=i.isLt; omega⟩ : Fin 768)=i := by
    apply Fin.ext
    change i.val+768-768=i.val
    omega
  rw [same]

theorem coefficient_bounds (v : Vec) (signed : Signed16 v) (i : Fin 1536) :
    -32768≤coefficient v i ∧ coefficient v i≤32767 := by
  by_cases low : i.val<768
  · let j : Fin 768 := ⟨i.val,low⟩
    have same : lowIndex j=i := by apply Fin.ext; rfl
    rw [←same,coefficient_low]
    exact (signed j).1
  · let j : Fin 768 := ⟨i.val-768,by have bound:=i.isLt; omega⟩
    have same : highIndex j=i := by apply Fin.ext; dsimp [highIndex,j]; omega
    rw [←same,coefficient_high]
    exact (signed j).2

theorem word_integer (v : Vec) (signed : Signed16 v) (i : Fin 1536) : (words v i).toInt=coefficient v i := by
  have bounds:=coefficient_bounds v signed i
  exact BitVec.toInt_ofInt_eq_self (by decide +kernel) (by omega) (by omega)

theorem vector_signed (w : Words) : Signed16 (vector w) := by
  intro i
  have lowLower := (w (lowIndex i)).le_toInt
  have lowUpper := (w (lowIndex i)).toInt_lt
  have highLower := (w (highIndex i)).le_toInt
  have highUpper := (w (highIndex i)).toInt_lt
  unfold vector
  constructor <;> constructor <;> omega

theorem vector_words (v : Vec) (signed : Signed16 v) : vector (words v)=v := by
  funext i
  apply Prod.ext
  · change (words v (lowIndex i)).toInt=(v i).1
    rw [word_integer v signed,coefficient_low]
  · change (words v (highIndex i)).toInt=(v i).2
    rw [word_integer v signed,coefficient_high]

theorem words_vector (w : Words) : words (vector w)=w := by
  funext i
  by_cases low : i.val<768
  · let j : Fin 768 := ⟨i.val,low⟩
    have same : lowIndex j=i := by apply Fin.ext; rfl
    rw [←same]
    change BitVec.ofInt 16 (coefficient (vector w) (lowIndex j))=w (lowIndex j)
    rw [coefficient_low]
    change BitVec.ofInt 16 (w (lowIndex j)).toInt=w (lowIndex j)
    exact BitVec.ofInt_toInt
  · let j : Fin 768 := ⟨i.val-768,by have bound:=i.isLt; omega⟩
    have same : highIndex j=i := by apply Fin.ext; dsimp [highIndex,j]; omega
    rw [←same]
    change BitVec.ofInt 16 (coefficient (vector w) (highIndex j))=w (highIndex j)
    rw [coefficient_high]
    change BitVec.ofInt 16 (w (highIndex j)).toInt=w (highIndex j)
    exact BitVec.ofInt_toInt

def signedEquiv : Words ≃ {v : Vec // Signed16 v} where
  toFun w := ⟨vector w,vector_signed w⟩
  invFun v := words v.val
  left_inv := words_vector
  right_inv v := Subtype.ext (vector_words v.val v.property)

theorem bound_signed (v : Vec) (B : Int) (nonnegative : 0≤B) (small : B≤32767)
    (bound : KeygenIntegerLift.Bound v B) : Signed16 v := by
  intro i
  have low:=abs_le.mp (bound i).1
  have high:=abs_le.mp (bound i).2
  constructor <;> constructor <;> omega

theorem unbounded_integer_transport_false :
    BitVec.ofInt 16 (65536 : Int)=BitVec.ofInt 16 (0 : Int) ∧ (65536 : Int)≠0 := by decide +kernel

theorem halves_are_not_interleaved : lowIndex (⟨1,by decide +kernel⟩ : Fin 768)≠highIndex 0 := by decide +kernel

end FT1536.Source3.KeygenInt16Vector076
