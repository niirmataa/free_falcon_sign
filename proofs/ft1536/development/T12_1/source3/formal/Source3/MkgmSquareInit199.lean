import Source3.MkgmSquareBody199

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmSquareInit199
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99InitializationTrace (Preserves preserves_trans)
open KeygenSmallOutput (element)
open Word32Initialized180 (At write_preserves write_initializes transported)
open MkgmSquare199 (From)
open MkgmParams198 (Level)
open MkgmSquareBody199 (square gWritten after)

theorem first_preserves (s : State) (gm : ArrayPointer) (p p0i y : BitVec 32) (u : Nat) :
    Preserves s.heap (gWritten s gm p p0i y u).heap := write_preserves s.heap (element gm u) (square y p p0i)

theorem preserves (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat) :
    Preserves s.heap (after s gm igm p p0i y z u).heap :=
  preserves_trans _ _ _ (first_preserves s gm p p0i y u)
    (write_preserves (gWritten s gm p p0i y u).heap (element igm u) (square z p p0i))

theorem pair (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat) :
    At (after s gm igm p p0i y z u).heap (element gm u) ∧ At (after s gm igm p p0i y z u).heap (element igm u) :=
  ⟨transported _ _ _ (write_preserves (gWritten s gm p p0i y u).heap (element igm u) (square z p p0i))
      (write_initializes s.heap (element gm u) (square y p p0i)),
    write_initializes (gWritten s gm p p0i y u).heap (element igm u) (square z p p0i)⟩

theorem grows (l : Level) (s : State) (gm igm : ArrayPointer) (p p0i y z : BitVec 32) (u : Nat)
    (old : From l s.heap gm igm (u+1)) : From l (after s gm igm p p0i y z u).heap gm igm u := by
  intro i lo hi
  by_cases same : i=u
  · rw [same]
    exact pair s gm igm p p0i y z u
  · exact MkgmSquare199.from_transport l _ _ gm igm (u+1)
      (preserves s gm igm p p0i y z u) old i (by omega) hi

end FT1536.Source3.MkgmSquareInit199
