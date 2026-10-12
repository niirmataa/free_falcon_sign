import ScatterTerm020D

namespace FT1536.S05.ActualScatter020D
open WordRAM020 PairProgram020 ReadSemantics020A Residue020D Interleaved020D IndexReference020D
open BufferField020D ScatterBranches020D ScatterAlgebra020D DataWords020D
open FT1536.Relation FT1536.PublicSimulation FT1536.Run2.PolynomialReference
attribute [local irreducible] exec loopState

def noise (z : StandaloneRuntime019.CachedBox) : Rq := reduceVec (decode (StandaloneRuntime019.view z)).2
def contribution (a b : Rq) (p j : Fin 1536) (r : Fin 1536) : Residue020D.F :=
  coefficient a (term p)*coefficient b (term j)*coefficientOfTerms (remainderTerms (productExponent (term p) (term j))) r

theorem exponent_pair (p j : Fin 1536) :
    ScatterTerm020D.sumExp ⟨exponentN p.val,exponent_bound p.val p.isLt⟩ j=productExponent (term p) (term j) := by
  apply Fin.ext
  change exponentN p.val+exponentN j.val=exponent (term p)+exponent (term j)
  rw [exponent_eq,exponent_eq]

/-- Actual input words and coefficient semantics are filled from the selected
    RAM image. Only loop counters/key coefficient and incoming buffer remain. -/
theorem term_correct (i : Input) (s : State) (z : StandaloneRuntime019.CachedBox)
    (h : Rq) (p j : Fin 1536) (v : Coeffs)
    (hz : BoxImage020C.readVec s=BoxImage020C.image z) (hv : Holds s v)
    (h22 : s.reg 22=word (j.val:Int)) (h23 : s.reg 23=word (exponentN p.val:Int))
    (h18 : s.reg 18=fw (coefficient h (term p))) :
    let t := exec i scatterTerm s
    Holds t (fun r => v r+contribution h (noise z) p j r) ∧ BufferField020D.Frame s t ∧
      t.reg 22=word ((j.val+1:Nat):Int) ∧ t.reg 18=fw (coefficient h (term p)) ∧
      t.reg 23=word (exponentN p.val:Int) ∧ t.reg 21=s.reg 21 := by
  have post := ScatterTerm020D.term_correct i s v ⟨exponentN p.val,exponent_bound p.val p.isLt⟩ j
    (coefficient h (term p)) (signed z true j) hv (signed_bounds z true j) h22 h23 h18 (data_word s z true j hz)
  have eqv : reduced v (ScatterTerm020D.sumExp ⟨exponentN p.val,exponent_bound p.val p.isLt⟩ j)
      (coefficient h (term p)*(signed z true j:Residue020D.F))=
      (fun r => v r+contribution h (noise z) p j r) := by
    funext r
    rw [reduced_at,exponent_pair,←coefficient_signed z true j]
    rfl
  rw [eqv] at post
  exact post

theorem frame_image {s t : State} (fr : BufferField020D.Frame s t) :
    BoxImage020C.readVec t=BoxImage020C.readVec s := by
  funext p
  apply Prod.ext
  · exact fr.2.2 (PairStores020B.slot0 p) (by have := p.isLt;change 2*p.val<3072;omega)
  · exact fr.2.2 (PairStores020B.slot1 p) (by have := p.isLt;change 2*p.val+1<3072;omega)

end FT1536.S05.ActualScatter020D
