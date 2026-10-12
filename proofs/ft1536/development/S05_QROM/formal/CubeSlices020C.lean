import TapeIndex020C

namespace FT1536.S05.CubeSlices020C
open JointInterface019 StandaloneRuntime019 TapeIndex020C

def cubeBlock (t : Bits 24662538240) (p : Fin 1536) : Bits 20 := fun j =>
  t ⟨196*1536*80*1024+p.val*20+j.val,by have := p.isLt;have := j.isLt;omega⟩

theorem seed_left (t : Bits 24662538240) (p : Fin 768) :
    (seedEquiv t).2.1 p=split 10 10 (cubeBlock t ⟨p.val,by omega⟩) := by
  change split 10 10 (fun j => t ⟨196*(1536*80*1024)+(j.val+20*p.val),_⟩)=_
  apply congrArg (split 10 10)
  funext j
  apply congrArg t
  apply Fin.ext
  change 196*(1536*80*1024)+(j.val+20*p.val)=196*1536*80*1024+p.val*20+j.val
  omega

theorem seed_right (t : Bits 24662538240) (p : Fin 768) :
    (seedEquiv t).2.2 p=split 10 10 (cubeBlock t ⟨768+p.val,by omega⟩) := by
  change split 10 10 (fun j => t ⟨196*(1536*80*1024)+(768*20+(j.val+20*p.val)),_⟩)=_
  apply congrArg (split 10 10)
  funext j
  apply congrArg t
  apply Fin.ext
  change 196*(1536*80*1024)+(768*20+(j.val+20*p.val))=196*1536*80*1024+(768+p.val)*20+j.val
  omega

theorem cube_left (c : CubeSeed) (j : Fin 768) :
    (cube c).1[j.val]=(cubeCoord (c.1 j).1,cubeCoord (c.1 j).2) := by
  simp only [cube,Vector.getElem_ofFn]

theorem cube_right (c : CubeSeed) (j : Fin 768) :
    (cube c).2[j.val]=(cubeCoord (c.2 j).1,cubeCoord (c.2 j).2) := by
  simp only [cube,Vector.getElem_ofFn]

end FT1536.S05.CubeSlices020C
