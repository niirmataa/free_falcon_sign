import Mathlib.Data.Fintype.Pigeonhole

/- A read-only audit of the exact two quantifiers in source3 commit18a3ffe3.
   No source3 module is changed, rebuilt or imported by this independent lemma. -/
namespace FT1536.S05.BoundedAddressObstruction017

theorem no_bounded_nat_injection (N : ℕ) (f : ℕ → ℕ)
    (bounded : ∀ n,f n<N) (distinct : ∀ a b,f a=f b → a=b) : False := by
  let g : ℕ → Fin N := fun n => ⟨f n,bounded n⟩
  apply not_injective_infinite_finite g
  intro a b h
  exact distinct a b (congrArg Fin.val h)

theorem no_global_virtual_legal (vb : ℕ → ℕ)
    (bounded : ∀ block,vb block<2^64)
    (distinct : ∀ b c : ℕ,vb b=vb c → b=c) : False :=
  no_bounded_nat_injection (2^64) vb bounded distinct

/-- The obstruction is the infinite global quantifier, not finite address maps. -/
theorem finite_map_control (N : ℕ) :
    ∃ f : Fin N → ℕ,(∀ i,f i<N) ∧ Function.Injective f :=
  ⟨Fin.val,(fun i => i.isLt),Fin.val_injective⟩

#print axioms no_bounded_nat_injection
#print axioms no_global_virtual_legal
#print axioms finite_map_control
end FT1536.S05.BoundedAddressObstruction017
