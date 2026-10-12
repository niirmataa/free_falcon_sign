import TapeIndex020C

namespace FT1536.S05.SeedSlices020C
open JointInterface019 StandaloneRuntime019 TapeIndex020C

def normBlock (t : Bits 24662538240) (n : Fin 196) (p : Fin 1536) (k : Fin 80) : Bits 1024 :=
  fun j => t ⟨((n.val*1536+p.val)*80+k.val)*1024+j.val,by
    have := n.isLt;have := p.isLt;have := k.isLt;have := j.isLt;omega⟩

theorem norm_left (t : Bits 24662538240) (n : Fin 196) (p : Fin 768) (k : Fin 80) :
    ((seedEquiv t).1 n).1 p k=pairEquiv (normBlock t n ⟨p.val,by omega⟩ k) := by
  change pairEquiv (fun j => t ⟨((j.val+1024*k.val)+(80*1024)*p.val)+(1536*80*1024)*n.val,_⟩)=_
  apply congrArg pairEquiv
  funext j
  apply congrArg t
  apply Fin.ext
  change ((j.val+1024*k.val)+(80*1024)*p.val)+(1536*80*1024)*n.val=
    ((n.val*1536+p.val)*80+k.val)*1024+j.val
  ring

theorem norm_right (t : Bits 24662538240) (n : Fin 196) (p : Fin 768) (k : Fin 80) :
    ((seedEquiv t).1 n).2 p k=pairEquiv (normBlock t n ⟨768+p.val,by omega⟩ k) := by
  change pairEquiv (fun j => t ⟨(768*(80*1024)+((j.val+1024*k.val)+(80*1024)*p.val))+(1536*80*1024)*n.val,_⟩)=_
  apply congrArg pairEquiv
  funext j
  apply congrArg t
  apply Fin.ext
  change (768*(80*1024)+((j.val+1024*k.val)+(80*1024)*p.val))+(1536*80*1024)*n.val=
    ((n.val*1536+(768+p.val))*80+k.val)*1024+j.val
  ring

end FT1536.S05.SeedSlices020C
