import MachineCoins020C
import VectorNorm020C
import ReferenceVector020C
import VectorLoop020C

namespace FT1536.S05.ActualVector020C
open WordRAM020 ReadSemantics020A JointInterface019 CdfPrefix020A
open VectorPrefix020C VectorValues020C VectorLoopCore020C VectorLoop020C
open VectorNorm020C ReferenceVector020C MachineCoins020C
open FT1536.Relation FT1536.Geometry FT1536.PublicSimulation
attribute [local irreducible] exec loopState StandaloneRuntime019.pair StandaloneRuntime019.vector

theorem source_left (h : Rq) (t : Bits tapeSize) (n : Fin 196) (j : Fin 768) :
    values (InputLayout020.encode h t) n.val j.val=
      decoded (StandaloneRuntime019.vector StandaloneRuntime019.tables
        ((StandaloneRuntime019.seedEquiv t).1 n)).1[j.val] := by
  rw [vector_left,left_coins h t n j]
  rfl

theorem source_right (h : Rq) (t : Bits tapeSize) (n : Fin 196) (j : Fin 768) :
    values (InputLayout020.encode h t) n.val (768+j.val)=
      decoded (StandaloneRuntime019.vector StandaloneRuntime019.tables
        ((StandaloneRuntime019.seedEquiv t).1 n)).2[j.val] := by
  rw [vector_right,right_coins h t n j]
  rfl

theorem norm_identity (h : Rq) (t : Bits tapeSize) (n : Fin 196) :
    total (values (InputLayout020.encode h t) n.val) 1536=
      Q (decode (StandaloneRuntime019.view
        (StandaloneRuntime019.vector StandaloneRuntime019.tables ((StandaloneRuntime019.seedEquiv t).1 n)))) :=
  total_eq_Q (values (InputLayout020.encode h t) n.val)
    (StandaloneRuntime019.vector StandaloneRuntime019.tables ((StandaloneRuntime019.seedEquiv t).1 n))
    (source_left h t n) (source_right h t n)

/-- The actual vector accumulator equals the ORIGINAL019 norm on its own
    seedEquiv tape, with no extra distributional or source-layout assumption. -/
theorem exact_norm (h : Rq) (t : Bits tapeSize) (n : Fin 196) (s : State)
    (h0 : s.reg 0=nw n.val) :
    (exec (InputLayout020.encode h t) vectorCode s).reg 16=
      word (Q (decode (StandaloneRuntime019.view
        (StandaloneRuntime019.vector StandaloneRuntime019.tables ((StandaloneRuntime019.seedEquiv t).1 n))))) := by
  have post := vector_correct h t n.val s n.isLt h0
  exact post.1.2.2.1.trans (congrArg word (norm_identity h t n))

end FT1536.S05.ActualVector020C
