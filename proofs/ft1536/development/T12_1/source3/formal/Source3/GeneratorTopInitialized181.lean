import Source3.GeneratorTopSource181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorTopInitialized181
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenSmallOutput (element)
open C99InitializationTrace (Preserves preserves_trans)
open Word32Initialized180 (write_preserves write_initializes transported)
open GeneratorSquareDomains181 (From)
open GeneratorTopSource181 (gWritten withW after inverseWord)

theorem preserves (s : State) (gm igm : ArrayPointer) (w p p0i r r2 : BitVec 32) :
    Preserves s.heap (after s gm igm w p p0i r r2).heap :=
  preserves_trans _ _ _ (write_preserves s.heap (element gm 0) w)
    (write_preserves (withW s gm w).heap (element igm 0) (inverseWord w p p0i r r2))

theorem initialized (s : State) (gm igm : ArrayPointer) (w p p0i r r2 : BitVec 32)
    (old : From s.heap gm igm 1) : From (after s gm igm w p p0i r r2).heap gm igm 0 := by
  intro j lo hi
  by_cases zero : j=0
  · rw [zero]
    exact ⟨transported _ _ _ (write_preserves (withW s gm w).heap (element igm 0) (inverseWord w p p0i r r2))
        (write_initializes s.heap (element gm 0) w),
      write_initializes (withW s gm w).heap (element igm 0) (inverseWord w p p0i r r2)⟩
  · exact GeneratorSquareDomains181.from_transport _ _ gm igm 1 (preserves s gm igm w p p0i r r2) old j (by omega) hi

end FT1536.Source3.GeneratorTopInitialized181
