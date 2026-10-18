import Source3.NttWriteFrame182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttFirstBodyFrame182
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open NttFirstBody182

theorem locals (s : State) (r1 r2 : ArrayPointer) (a0 a1 w p p0i : BitVec 32) :
    (after s r1 r2 a0 a1 w p p0i).locals=s.locals := by
  funext name
  by_cases h0 : name="a0".toList
  · subst name; rfl
  by_cases h1 : name="a1".toList
  · subst name; rfl
  by_cases hb : name="b".toList
  · subst name; rfl
  change name≠['a','0'] at h0
  change name≠['a','1'] at h1
  change name≠['b'] at hb
  simp [after,last,first,withB,withA1,withA0,declared,names,ModularAtoms178.set,
    C99ArrayReference.bindValue,C99ArrayReference.restoreScope,C99ScalarReference.restore,
    C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set,h0,h1,hb]

theorem arrays (s : State) (r1 r2 : ArrayPointer) (a0 a1 w p p0i : BitVec 32) :
    (after s r1 r2 a0 a1 w p p0i).arrays=s.arrays := rfl

theorem initialized (s : State) (r1 r2 : ArrayPointer) (a0 a1 w p p0i : BitVec 32) :
    C99InitializationTrace.Preserves s.heap (after s r1 r2 a0 a1 w p p0i).heap :=
  C99InitializationTrace.preserves_trans _ _ _
    (Word32Initialized180.write_preserves s.heap r1 (leftWord a0 a1 w p p0i))
    (Word32Initialized180.write_preserves (NttFirstBody182.first s r1 a0 a1 w p p0i).heap r2 (rightWord a0 a1 w p p0i))

end FT1536.Source3.NttFirstBodyFrame182
