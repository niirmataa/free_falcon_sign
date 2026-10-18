import Source3.NttBinaryBody183
import Source3.NttFirstFixed182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttBinaryFrame183
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open NttBinaryBody183

theorem locals (s : State) (r1 r2 : ArrayPointer) (x y w p p0i : BitVec 32) :
    (after s r1 r2 x y w p p0i).locals=s.locals := by
  funext name
  by_cases h0 : name="x".toList
  · subst name; rfl
  by_cases h1 : name="y".toList
  · subst name; rfl
  change name≠['x'] at h0
  change name≠['y'] at h1
  simp [after,last,first,withTwiddle,withY,withX,declared,names,ModularAtoms178.set,
    C99ArrayReference.bindValue,C99ArrayReference.restoreScope,C99ScalarReference.restore,
    C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set,h0,h1]

theorem arrays (s : State) (r1 r2 : ArrayPointer) (x y w p p0i : BitVec 32) :
    (after s r1 r2 x y w p p0i).arrays=s.arrays := rfl

theorem initialized (s : State) (r1 r2 : ArrayPointer) (x y w p p0i : BitVec 32) :
    C99InitializationTrace.Preserves s.heap (after s r1 r2 x y w p p0i).heap :=
  C99InitializationTrace.preserves_trans _ _ _
    (Word32Initialized180.write_preserves s.heap r1 (leftWord x y w p p0i))
    (Word32Initialized180.write_preserves (NttBinaryBody183.first s r1 x y w p p0i).heap r2 (rightWord x y w p p0i))

theorem frame (s : State) (a : ArrayPointer) (i j : Fin 1536)
    (x y tw p p0i : BitVec 32) (width : a.elementBytes=4) :
    NttWriteFrame182.Frame a 1536 s.heap
      (after s (KeygenSmallOutput.element a i.val) (KeygenSmallOutput.element a j.val) x y tw p p0i).heap :=
  NttWriteFrame182.trans a 1536 _ _ _
    (NttWriteFrame182.write s.heap a 1536 i (leftWord x y tw p p0i) width)
    (NttWriteFrame182.write _ a 1536 j (rightWord x y tw p p0i) width)

theorem fixed (s : State) (a gm r1 r2 : ArrayPointer) (p p0i w x y tw : BitVec 32)
    (h : NttFirstFixed182.Fixed s a gm p p0i w) :
    NttFirstFixed182.Fixed (after s r1 r2 x y tw p p0i) a gm p p0i w := by
  have hl := locals s r1 r2 x y tw p p0i
  have ha := arrays s r1 r2 x y tw p p0i
  have hm := initialized s r1 r2 x y tw p p0i
  refine ⟨?_,?_,?_,?_,?_,?_,?_,?_,h.width,h.capacity,?_,?_,?_⟩
  · exact (congrFun hl _).trans h.pCell
  · exact (congrFun hl _).trans h.iCell
  · exact (congrFun hl _).trans h.wCell
  · exact (congrFun hl _).trans h.nCell
  · exact (congrFun hl _).trans h.hnCell
  · exact (congrFun hl _).trans h.stride
  · exact (congrFun ha _).trans h.aBinding
  · exact (congrFun ha _).trans h.gmBinding
  · intro j hj; simpa only [C99MemoryReference.Allocated,hm.size] using h.allocated j hj
  · rw [hm.writable]; exact h.writable
  · intro j hj; exact Word32Initialized180.transported _ _ _ hm (h.initialized j hj)

end FT1536.Source3.NttBinaryFrame183
