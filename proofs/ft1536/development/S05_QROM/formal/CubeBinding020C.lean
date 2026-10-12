import CubeSlices020C
import CubeLoop020C

namespace FT1536.S05.CubeBinding020C
open WordRAM020 ReadSemantics020A JointInterface019 BitValue020A
open CubeRead020C CubeSlices020C VectorValues020C BoxImage020C
open FT1536.Relation
attribute [local irreducible] exec loopState StandaloneRuntime019.cube

theorem cube_bit (h : Rq) (t : Bits tapeSize) (p : Fin 1536) (j : Fin 20) :
    tapeBits (InputLayout020.encode h t) (base p.val+j.val)=cubeBlock t p j := by
  have hb := window p.val p.isLt
  exact tapeBits_at (InputLayout020.encode h t) ⟨base p.val+j.val,by omega⟩

theorem left_bits (h : Rq) (t : Bits tapeSize) (p : Fin 1536) :
    (StandaloneRuntime019.split 10 10 (cubeBlock t p)).1=
      (fun j => tapeBits (InputLayout020.encode h t) (base p.val+j.val)) := by
  funext j
  rw [TapeIndex020C.split_left]
  exact (cube_bit h t p ⟨j.val,by omega⟩).symm

theorem right_bits (h : Rq) (t : Bits tapeSize) (p : Fin 1536) :
    (StandaloneRuntime019.split 10 10 (cubeBlock t p)).2=
      (fun j => tapeBits (InputLayout020.encode h t) (base p.val+10+j.val)) := by
  funext j
  rw [TapeIndex020C.split_right]
  have hb := cube_bit h t p ⟨10+j.val,by omega⟩
  simpa only [Nat.add_assoc] using hb.symm

theorem decoded_cube (x y : Bits 10) :
    decoded (StandaloneRuntime019.cubeCoord x,StandaloneRuntime019.cubeCoord y)=
      ((StandaloneRuntime019.value 10 x:Int)-512,(StandaloneRuntime019.value 10 y:Int)-512) := by
  apply Prod.ext
  · change (((StandaloneRuntime019.value 10 x+65023:Nat):Int)-65535)=_
    push_cast
    ring
  · change (((StandaloneRuntime019.value 10 y+65023:Nat):Int)-65535)=_
    push_cast
    ring

theorem source_pair (h : Rq) (t : Bits tapeSize) (p : Fin 1536) :
    decoded (StandaloneRuntime019.cubeCoord ((StandaloneRuntime019.split 10 10 (cubeBlock t p)).1),
      StandaloneRuntime019.cubeCoord ((StandaloneRuntime019.split 10 10 (cubeBlock t p)).2))=
        vals (InputLayout020.encode h t) p.val := by
  rw [decoded_cube,left_bits h t p,right_bits h t p,reference_value,reference_value]
  rfl

theorem source_left (h : Rq) (t : Bits tapeSize) (j : Fin 768) :
    vals (InputLayout020.encode h t) j.val=
      decoded (StandaloneRuntime019.cube (StandaloneRuntime019.seedEquiv t).2).1[j.val] := by
  rw [cube_left,seed_left t j]
  exact (source_pair h t ⟨j.val,by omega⟩).symm

theorem source_right (h : Rq) (t : Bits tapeSize) (j : Fin 768) :
    vals (InputLayout020.encode h t) (768+j.val)=
      decoded (StandaloneRuntime019.cube (StandaloneRuntime019.seedEquiv t).2).2[j.val] := by
  rw [cube_right,seed_right t j]
  exact (source_pair h t ⟨768+j.val,by omega⟩).symm

/-- Every starting state and every full tape; cube reads the actual fresh
    suffix of the SAME seedEquiv used by the196 norm attempts. -/
theorem cube_image (h : Rq) (t : Bits tapeSize) (s : State) :
    readVec (exec (InputLayout020.encode h t) PairProgram020.cube s)=
      image (StandaloneRuntime019.cube (StandaloneRuntime019.seedEquiv t).2) :=
  prefix_image (vals (InputLayout020.encode h t))
    (StandaloneRuntime019.cube (StandaloneRuntime019.seedEquiv t).2)
    (exec (InputLayout020.encode h t) PairProgram020.cube s)
    (CubeLoop020C.cube_correct _ s).1.2 (source_left h t) (source_right h t)

end FT1536.S05.CubeBinding020C
