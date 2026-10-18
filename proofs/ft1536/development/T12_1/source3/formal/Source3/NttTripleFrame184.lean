import Source3.NttTripleBody184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleFrame184
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open NttTripleStates184

theorem initialized (s : State) (a : ArrayPointer) (i : Nat) (z : Words) :
    C99InitializationTrace.Preserves s.heap (after s a i z).heap :=
  C99InitializationTrace.preserves_trans _ _ _ (Word32Initialized180.write_preserves s.heap _ (firstWord z))
    (C99InitializationTrace.preserves_trans _ _ _ (Word32Initialized180.write_preserves (first s a i z).heap _ (secondWord z))
      (Word32Initialized180.write_preserves (second s a i z).heap _ (thirdWord z)))

theorem frame (s : State) (a : ArrayPointer) (i : Nat) (z : Words) (bound : i+2<1536) (width : a.elementBytes=4) :
    NttWriteFrame182.Frame a 1536 s.heap (after s a i z).heap :=
  NttWriteFrame182.trans a 1536 _ _ _ (NttWriteFrame182.write s.heap a 1536 ⟨i,by omega⟩ (firstWord z) width)
    (NttWriteFrame182.trans a 1536 _ _ _ (NttWriteFrame182.write (first s a i z).heap a 1536 ⟨i+1,by omega⟩ (secondWord z) width)
      (NttWriteFrame182.write (second s a i z).heap a 1536 ⟨i+2,bound⟩ (thirdWord z) width))

theorem locals (s : State) (out : C99ProcedureReference.Result)
    (run : C99ModularReference.Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody) s out) :
    out.state.locals=s.locals := by
  have frame := KeygenNttControl.frame _ _ _ (by decide) run
  have empty : KeygenNttControl.localsWritten (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody)=[] := by decide
  funext name
  apply frame.2.1 name
  rw [empty]
  exact List.not_mem_nil

theorem arrays (s : State) (out : C99ProcedureReference.Result)
    (run : C99ModularReference.Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody) s out) :
    out.state.arrays=s.arrays := by
  have frame := KeygenNttControl.frame _ _ _ (by decide) run
  have empty : KeygenNttControl.pointersWritten (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody)=[] := by decide
  funext name
  apply frame.2.2 name
  rw [empty]
  exact List.not_mem_nil

theorem fixed (s : State) (a gm : ArrayPointer) (i : Nat) (z : Words)
    (h : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w)
    (run : C99ModularReference.Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody) s ⟨after s a i z,.normal⟩) :
    NttFirstFixed182.Fixed (after s a i z) a gm z.p z.p0i z.w := by
  have hl := locals s _ run
  have ha := arrays s _ run
  have hm := initialized s a i z
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

end FT1536.Source3.NttTripleFrame184
