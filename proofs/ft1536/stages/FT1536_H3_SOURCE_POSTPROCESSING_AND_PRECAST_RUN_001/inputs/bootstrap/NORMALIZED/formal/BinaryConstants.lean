import BinaryMargin
import BinaryFrame
namespace Node2
open Node3 (QBound Pos Nonneg leQ)
structure Constants where
  s0lo : QBound
  dlo : QBound
  s0hi : QBound
  dhi : QBound
  imag0 : QBound
  imagD : QBound
  Lhi : QBound
  Lerr : QBound
  Derr : QBound
def c00 : Constants := ⟨(1,16),(1,32),(67108864,1),(134217728,1),(1,8192),(1,8192),(2,1),(1,16),(1,128)⟩
def c01 : Constants := ⟨(1,16),(1,32),(67108864,1),(134217728,1),(1,8192),(1,8192),(2,1),(1,2),(1,16)⟩
def c02 : Constants := ⟨(1,16),(1,32),(67108864,1),(134217728,1),(1,8192),(1,8192),(2,1),(3,1),(1,1)⟩
def c10 : Constants := ⟨(4,1),(2,1),(34359738368,1),(68719476736,1),(9,8),(9,8),(2,1),(3,1),(33554432,1)⟩
def c11 : Constants := ⟨(4,1),(2,1),(34359738368,1),(68719476736,1),(9,8),(9,8),(2,1),(3,1),(268435456,1)⟩
def c12 : Constants := ⟨(4,1),(2,1),(34359738368,1),(68719476736,1),(9,8),(9,8),(2,1),(3,1),(4294967296,1)⟩
def c2 (b : Fin 2) (k : Fin 3) : Constants :=
  match b.val,k.val with
  | 0,0 => c00
  | 0,1 => c01
  | 0,_ => c02
  | _,0 => c10
  | _,1 => c11
  | _,_ => c12
def Valid (c : Constants) : Prop :=
  Pos c.s0lo ∧ Pos c.dlo ∧ Nonneg c.s0hi ∧ Nonneg c.dhi ∧
  leQ c.s0lo c.s0hi ∧ leQ c.dlo c.dhi ∧
  Nonneg c.imag0 ∧ Nonneg c.imagD ∧ Nonneg c.Lhi ∧ Nonneg c.Lerr ∧ Nonneg c.Derr
theorem valid_c2 (b : Fin 2) (k : Fin 3) : Valid (c2 b k) := by
  have hb : b.val=0 ∨ b.val=1 := by omega
  have hk : k.val=0 ∨ k.val=1 ∨ k.val=2 := by omega
  rcases hb with hb|hb <;> rcases hk with hk|hk|hk <;> unfold c2 <;> rw [hb,hk]
  all_goals unfold Valid Pos Nonneg leQ
  all_goals decide
theorem first_div_domain (b : Fin 2) (k : Fin 3) :
    leQ (1,16) (c2 b k).s0lo ∧ leQ (c2 b k).s0hi (34359738368,1) := by
  have hb : b.val=0 ∨ b.val=1 := by omega
  have hk : k.val=0 ∨ k.val=1 ∨ k.val=2 := by omega
  rcases hb with hb|hb <;> rcases hk with hk|hk|hk <;> unfold c2 <;> rw [hb,hk]
  all_goals unfold leQ
  all_goals decide
end Node2
