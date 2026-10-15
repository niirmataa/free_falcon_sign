import Source3.C99WordBuffer140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99FourWordBuffer140
open C99MemoryReference
open C99WordBuffer140 (element Represents updated)

def values {n : Nat} (before : Fin n → BitVec 64) (slots : Fin 4 → Fin n) (words : Fin 4 → BitVec 64) : Fin n → BitVec 64 :=
  updated (updated (updated (updated before (slots 0) (words 0)) (slots 1) (words 1)) (slots 2) (words 2)) (slots 3) (words 3)

def heap {n : Nat} (before : Memory) (base : ArrayPointer) (slots : Fin 4 → Fin n) (words : Fin 4 → BitVec 64) : Memory :=
  C99WordStore140.write
    (C99WordStore140.write
      (C99WordStore140.write
        (C99WordStore140.write before (element base (slots 0)) (words 0))
        (element base (slots 1)) (words 1))
      (element base (slots 2)) (words 2))
    (element base (slots 3)) (words 3)

/-- Four ordered writes preserve the symbolic buffer, including aliases. -/
theorem preserves {n : Nat} (before : Memory) (base : ArrayPointer) (v : Fin n → BitVec 64)
    (represented : Represents before base v) (width : base.elementBytes=8)
    (writable : before.writable base.block=true) (slots : Fin 4 → Fin n) (words : Fin 4 → BitVec 64) :
    Represents (heap before base slots words) base (values v slots words) := by
  have first := C99WordBuffer140.write_preserves before base v represented width writable (slots 0) (words 0)
  have second := C99WordBuffer140.write_preserves _ base _ first width writable (slots 1) (words 1)
  have third := C99WordBuffer140.write_preserves _ base _ second width writable (slots 2) (words 2)
  exact C99WordBuffer140.write_preserves _ base _ third width writable (slots 3) (words 3)

end FT1536.Source3.C99FourWordBuffer140
