import NodeInverse
import NodeDataflow
namespace Node3
-- Exact rational pairs; positivity of every denominator is part of Valid.
abbrev QBound := Int × Nat
def Pos (q : QBound) : Prop := 0<q.2 ∧ 0<q.1
def Nonneg (q : QBound) : Prop := 0<q.2 ∧ 0≤q.1
def leQ (a b : QBound) : Prop := a.1*(b.2:Int)≤b.1*(a.2:Int)
def ltQ (a b : QBound) : Prop := a.1*(b.2:Int)<b.1*(a.2:Int)
structure BranchConstants where
  t0lo : QBound
  dlo : QBound
  t0hi : QBound
  dhi : QBound
  imag0 : QBound
  imag1 : QBound
  imag2 : QBound
  errL10 : QBound
  errL21 : QBound
  errD11 : QBound
  errD22 : QBound
def branch0 : BranchConstants := ⟨(1,4),(1,8),(16777216,1),(33554432,1),(0,1),(1,256),(1,256),(1,64),(1,16),(1,128),(1,8)⟩
def branch1 : BranchConstants := ⟨(16,1),(8,1),(8589934592,1),(17179869184,1),(32,1),(33,1),(34,1),(3,1),(5,1),(33554432,1),(536870912,1)⟩
def c3 (b : Fin 2) : BranchConstants := if b.val=0 then branch0 else branch1
def Valid (c : BranchConstants) : Prop :=
  Pos c.t0lo ∧ Pos c.dlo ∧ Nonneg c.t0hi ∧ Nonneg c.dhi ∧ leQ c.t0lo c.t0hi ∧ leQ c.dlo c.dhi ∧
  Nonneg c.imag0 ∧ Nonneg c.imag1 ∧ Nonneg c.imag2 ∧
  Nonneg c.errL10 ∧ Nonneg c.errL21 ∧ Nonneg c.errD11 ∧ Nonneg c.errD22
theorem valid_c3 (b : Fin 2) : Valid (c3 b) := by
  unfold c3
  split <;> unfold Valid Pos Nonneg leQ <;> decide
theorem branch0_round_margin : (64-1:Int)>32 := by decide
theorem branch1_round_margin : (16-2:Int)>8 := by decide
theorem quotient_domain (b : Fin 2) :
    leQ (1,16) (c3 b).dlo ∧ ltQ (c3 b).dhi (34359738368,1) := by
  unfold c3
  split <;> unfold leQ ltQ <;> decide
theorem safe_order (d ideal err m : Int)
    (he : -err≤d-ideal ∧ d-ideal≤err) (hi : m+err≤ideal) (hm : 0<m) : 0<d := by omega
end Node3
