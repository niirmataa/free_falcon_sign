import RegionRam020E5
import Mathlib.Logic.Equiv.Fin.Basic

namespace FT1536.S05.BankWordLayout020E5
open WordRAM020 ArrayBank020E4

def encode {A : Type} {n w : Nat} (e : A → Fin w → Word) (a : Bank A n) : Bank Word (n*w) :=
  load (fun k => let ij := (finProdFinEquiv : Fin n × Fin w ≃ Fin (n*w)).symm k
    e (read a ij.1) ij.2)

theorem at_cell {A : Type} {n w : Nat} (e : A → Fin w → Word) (a : Bank A n)
    (i : Fin n) (j : Fin w) : read (encode e a) (finProdFinEquiv (i,j))=e (read a i) j := by
  simp only [encode,read_load,Equiv.symm_apply_apply]

theorem extent {A : Type} {n w : Nat} (e : A → Fin w → Word) (a : Bank A n) :
    (encode e a).cells.size=n*w := (encode e a).size_eq

theorem injective {A : Type} {n w : Nat} (e : A → Fin w → Word) (he : Function.Injective e) :
    Function.Injective (@encode A n w e) := by
  intro a b h
  apply ArrayBank020E4.ext
  funext i
  apply he
  funext j
  have hh := congrArg (fun bank => read bank (finProdFinEquiv (i,j))) h
  simpa only [at_cell] using hh

/-- Complete effect of updating one structured cell, including all unchanged
    word positions. Only w word writes are needed in the allocated region. -/
theorem updated_at {A : Type} {n w : Nat} (e : A → Fin w → Word) (a : Bank A n)
    (i k : Fin n) (v : A) (j : Fin w) :
    read (encode e (write a i v)) (finProdFinEquiv (k,j))=
      if k=i then e v j else read (encode e a) (finProdFinEquiv (k,j)) := by
  rw [at_cell,read_write,at_cell]
  by_cases h : k=i <;> simp [h,Function.update]

end FT1536.S05.BankWordLayout020E5
