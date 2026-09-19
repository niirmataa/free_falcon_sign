import NodeInverse
import NodeDataflow
namespace Node3
structure BranchConstants where
  t0lo : Rat
  dlo : Rat
  t0hi : Rat
  dhi : Rat
  imag0 : Rat
  imag1 : Rat
  imag2 : Rat
  errL10 : Rat
  errL21 : Rat
  errD11 : Rat
  errD22 : Rat
def branch0 : BranchConstants := ⟨1/4,1/8,16777216,33554432,0,1/256,1/256,1/64,1/16,1/128,1/8⟩
def branch1 : BranchConstants := ⟨16,8,8589934592,17179869184,32,33,34,3,5,33554432,536870912⟩
def c3 (b : Fin 2) : BranchConstants := if b.val=0 then branch0 else branch1
def Valid (c : BranchConstants) : Prop :=
  0<c.t0lo ∧ 0<c.dlo ∧ c.t0lo≤c.t0hi ∧ c.dlo≤c.dhi ∧
  0≤c.imag0 ∧ 0≤c.imag1 ∧ 0≤c.imag2 ∧
  0≤c.errL10 ∧ 0≤c.errL21 ∧ 0≤c.errD11 ∧ 0≤c.errD22
theorem valid_c3 (b : Fin 2) : Valid (c3 b) := by
  unfold c3
  split <;> unfold Valid <;> decide +kernel
theorem branch0_round_margin : (1:Rat)/4-1/256>1/8 := by decide +kernel
theorem branch1_round_margin : (16:Rat)-2>8 := by decide +kernel
theorem quotient_domain (b : Fin 2) :
    (1:Rat)/16≤(c3 b).dlo ∧ (c3 b).dhi<(34359738368:Rat) := by
  unfold c3
  split <;> decide +kernel
theorem safe_order (d ideal err m : Int)
    (he : -err≤d-ideal ∧ d-ideal≤err) (hi : m+err≤ideal) (hm : 0<m) : 0<d := by omega
end Node3
