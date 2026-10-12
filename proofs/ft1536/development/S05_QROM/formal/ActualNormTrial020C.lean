import NormResponse020C

namespace FT1536.S05.ActualNormTrial020C
open WordRAM020 PairProgram020 ReadSemantics020A JointInterface019 CdfPrefix020A
open VectorPrefix020C VectorValues020C VectorLoopCore020C VectorLoop020C
open ActualVector020C BoxImage020C NormResponse020C
open FT1536.Relation
attribute [local irreducible] exec loopState values StandaloneRuntime019.vector StandaloneRuntime019.pair

/-- Whole actual normTrial: the original019 norm gate, both responses,
    index advance and frame. Its vector correctness premises are filled. -/
theorem norm_correct (h : Rq) (tape : Bits tapeSize) (n : Fin 196) (s : State)
    (h0 : s.reg 0=nw n.val) (h20 : s.reg 20=0) :
    let i := InputLayout020.encode h tape
    let t := exec i PairProgram020.normTrial s
    answer t=(StandaloneRuntime019.normTrial StandaloneRuntime019.tables
      ((StandaloneRuntime019.seedEquiv tape).1 n)).map image ∧
      t.reg 0=nw (n.val+1) ∧ Preserves s t := by
  let i := InputLayout020.encode h tape
  let v := values i n.val
  let q := exec i vectorCode s
  let z := StandaloneRuntime019.vector StandaloneRuntime019.tables ((StandaloneRuntime019.seedEquiv tape).1 n)
  have post := vector_correct h tape n.val s n.isLt h0
  have q20 : q.reg 20=0 := (post.2.2.2.1 20 (by decide) (by decide)).trans h20
  have gen := norm_from_vector i s q n.val (total v 1536) z n.isLt rfl
    (total_bound v (values_bounded i n.val) 1536 (by decide))
    post.1.1 post.1.2.2.1 q20 (vector_image h tape n s h0)
    (norm_identity h tape n) (from_vector post.2)
  exact ⟨gen.1.trans (reference_answer StandaloneRuntime019.tables
    ((StandaloneRuntime019.seedEquiv tape).1 n)).symm,gen.2⟩

end FT1536.S05.ActualNormTrial020C
