import StandaloneRuntime019

namespace FT1536.S05.TapeIndex020C
open JointInterface019 StandaloneRuntime019

theorem split_left (a b : Nat) (t : Bits (a+b)) (j : Fin a) :
    (split a b t).1 j=t ⟨j.val,by omega⟩ := rfl

theorem split_right (a b : Nat) (t : Bits (a+b)) (j : Fin b) :
    (split a b t).2 j=t ⟨a+j.val,by omega⟩ := rfl

theorem chunks_at (a b : Nat) (t : Bits (a*b)) (p : Fin a) (j : Fin b) :
    (chunks a b t) p j=t (finProdFinEquiv (p,j)) := rfl

theorem chunk_index (a b : Nat) (p : Fin a) (j : Fin b) :
    (finProdFinEquiv (p,j)).val=p.val*b+j.val := by
  change j.val+b*p.val=p.val*b+j.val
  ac_rfl

theorem pair_first (t : Bits 1024) (j : Fin 384) :
    (pairEquiv t).1 j=t ⟨j.val,by omega⟩ := rfl

theorem pair_second (t : Bits 1024) (j : Fin 384) :
    (pairEquiv t).2.1 j=t ⟨384+j.val,by omega⟩ := rfl

theorem pair_acceptance (t : Bits 1024) (j : Fin 256) :
    (pairEquiv t).2.2 j=t ⟨768+j.val,by omega⟩ := by
  change t ⟨384+(384+j.val),_⟩=t ⟨768+j.val,_⟩
  apply congrArg t
  apply Fin.ext
  change 384+(384+j.val)=768+j.val
  omega

end FT1536.S05.TapeIndex020C
