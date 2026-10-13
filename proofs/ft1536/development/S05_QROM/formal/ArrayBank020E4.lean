import BoundedStack020E3
import Init.Data.Array.OfFn

namespace FT1536.S05.ArrayBank020E4

/-- Dense backend. The length equality is erased proof data. -/
structure Bank (A : Type) (n : Nat) where
  cells : Array A
  size_eq : cells.size=n

def read {A : Type} {n : Nat} (a : Bank A n) (k : Fin n) : A :=
  a.cells[k.val]'(by rw [a.size_eq];exact k.isLt)

def write {A : Type} {n : Nat} (a : Bank A n) (k : Fin n) (v : A) : Bank A n :=
  ⟨a.cells.set k.val v (by rw [a.size_eq];exact k.isLt),by simp only [Array.size_set,a.size_eq]⟩

def load {A : Type} {n : Nat} (f : Fin n → A) : Bank A n :=
  ⟨Array.ofFn f,Array.size_ofFn⟩

def zero {A : Type} (n : Nat) (v : A) : Bank A n := load (fun _ => v)

theorem read_load {A : Type} {n : Nat} (f : Fin n → A) : read (load f)=f := by
  funext k
  simp only [read,load,Array.getElem_ofFn]

theorem read_write {A : Type} {n : Nat} (a : Bank A n) (k : Fin n) (v : A) :
    read (write a k v)=Function.update (read a) k v := by
  funext j
  by_cases he : j=k
  · subst j
    simp only [read,write,Array.getElem_set_self,Function.update_self]
  · have hv : k.val≠j.val := fun h => he (Fin.ext h.symm)
    simp only [read,write,Function.update_of_ne he]
    exact Array.getElem_set_ne (xs:=a.cells) (i:=k.val) (by rw [a.size_eq];exact k.isLt)
      (v:=v) (j:=j.val) (by rw [a.size_eq];exact j.isLt) hv

theorem ext {A : Type} {n : Nat} (a b : Bank A n) (h : read a=read b) : a=b := by
  have he : a.cells=b.cells := by
    apply Array.ext
    · rw [a.size_eq,b.size_eq]
    · intro j hja hjb
      exact congrFun h ⟨j,by rw [a.size_eq] at hja;exact hja⟩
  cases a;cases b;simp_all

theorem load_read {A : Type} {n : Nat} (a : Bank A n) : load (read a)=a :=
  ext _ _ (read_load _)

theorem fixed_size {A : Type} {n : Nat} (a : Bank A n) : a.cells.size=n := a.size_eq

theorem write_size {A : Type} {n : Nat} (a : Bank A n) (k : Fin n) (v : A) :
    (write a k v).cells.size=a.cells.size := by rw [fixed_size,fixed_size]

end FT1536.S05.ArrayBank020E4
