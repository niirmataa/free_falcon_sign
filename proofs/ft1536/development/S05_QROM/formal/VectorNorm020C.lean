import VectorValues020C
import Mathlib.Algebra.BigOperators.Fin

namespace FT1536.S05.VectorNorm020C
open VectorPrefix020C VectorValues020C PairArithmetic020B
open FT1536.Geometry FT1536.PublicSimulation

/-- The machine's sequential1536-block sum is precisely Q of the two768
    halves. This is an integer identity, before any strict norm test. -/
theorem total_eq_Q (v : Values) (z : StandaloneRuntime019.CachedBox)
    (left : ∀ j : Fin 768, v j.val=decoded z.1[j.val])
    (right : ∀ j : Fin 768, v (768+j.val)=decoded z.2[j.val]) :
    total v 1536=Q (decode (StandaloneRuntime019.view z)) := by
  unfold total
  change (∑ j ∈ Finset.range (768+768),q2 (v j).1 (v j).2)=_
  rw [Finset.sum_range_add,Finset.sum_range,Finset.sum_range]
  unfold Q Q0
  apply congrArg₂ (fun a b : Int => a+b)
  · apply Finset.sum_congr rfl
    intro j _
    rw [left j]
    simp only [q2,block,pow_two,decoded,decode,decodeVec,StandaloneRuntime019.view]
  · apply Finset.sum_congr rfl
    intro j _
    rw [right j]
    simp only [q2,block,pow_two,decoded,decode,decodeVec,StandaloneRuntime019.view]

end FT1536.S05.VectorNorm020C
