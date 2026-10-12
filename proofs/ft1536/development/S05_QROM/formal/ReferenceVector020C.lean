import StandaloneRuntime019

namespace FT1536.S05.ReferenceVector020C
open StandaloneRuntime019
attribute [local irreducible] pair

theorem vector_left (t : Tables) (c : VectorSeed) (j : Fin 768) :
    (vector t c).1[j.val]=pair t (c.1 j) := by
  simp only [vector,Vector.getElem_ofFn]

theorem vector_right (t : Tables) (c : VectorSeed) (j : Fin 768) :
    (vector t c).2[j.val]=pair t (c.2 j) := by
  simp only [vector,Vector.getElem_ofFn]

end FT1536.S05.ReferenceVector020C
