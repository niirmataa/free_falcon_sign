import ActualNormTrial020C

namespace FT1536.S05.NormSource020C
open WordRAM020 JointInterface019
attribute [local irreducible] StandaloneRuntime019.first StandaloneRuntime019.normTrial StandaloneRuntime019.vector

/-- Total specification extension. Only indices below196 are consumed. -/
noncomputable def source (t : Bits tapeSize) (n : Nat) : Option StandaloneRuntime019.CachedBox :=
  StandaloneRuntime019.normTrial StandaloneRuntime019.tables
    ((StandaloneRuntime019.seedEquiv t).1 ⟨min n 195,by omega⟩)

theorem source_at (t : Bits tapeSize) (n : Fin 196) :
    source t n.val=StandaloneRuntime019.normTrial StandaloneRuntime019.tables
      ((StandaloneRuntime019.seedEquiv t).1 n) := by
  unfold source
  apply congrArg (StandaloneRuntime019.normTrial StandaloneRuntime019.tables)
  apply congrArg (StandaloneRuntime019.seedEquiv t).1
  apply Fin.ext
  exact Nat.min_eq_left (show n.val≤195 by omega)

theorem source_first (t : Bits tapeSize) :
    CapCore020B.firstFrom (source t) 196 0=
      StandaloneRuntime019.first (StandaloneRuntime019.normTrial StandaloneRuntime019.tables)
        196 (StandaloneRuntime019.seedEquiv t).1 := by
  change CapCore020B.firstFrom
    (fun j => StandaloneRuntime019.normTrial StandaloneRuntime019.tables
      ((StandaloneRuntime019.seedEquiv t).1 ⟨min j 195,by omega⟩)) 196 0=_
  rw [CapDraw020B.firstFrom_eq_first]
  apply congrArg (StandaloneRuntime019.first (StandaloneRuntime019.normTrial StandaloneRuntime019.tables) 196)
  funext j
  apply congrArg (StandaloneRuntime019.seedEquiv t).1
  apply Fin.ext
  change min (0+j.val) 195=j.val
  rw [Nat.zero_add,Nat.min_eq_left (show j.val≤195 by omega)]

end FT1536.S05.NormSource020C
