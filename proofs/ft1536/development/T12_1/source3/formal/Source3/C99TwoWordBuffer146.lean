import Source3.C99WordBuffer140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99TwoWordBuffer146
open C99MemoryReference (Memory ArrayPointer)
open C99WordBuffer140 (Represents element updated)

def values {n : Nat} (input : Fin n → BitVec 64) (r q : Fin n) (real imag : BitVec 64) := updated (updated input r real) q imag

def heap {n : Nat} (before : Memory) (base : ArrayPointer) (r q : Fin n) (real imag : BitVec 64) :=
  C99WordStore140.write (C99WordStore140.write before (element base r) real) (element base q) imag

theorem preserves {n : Nat} (before : Memory) (base : ArrayPointer) (input : Fin n → BitVec 64)
    (represented : Represents before base input) (width : base.elementBytes=8)
    (writable : before.writable base.block=true) (r q : Fin n) (real imag : BitVec 64) :
    Represents (heap before base r q real imag) base (values input r q real imag) :=
  C99WordBuffer140.write_preserves _ base (updated input r real)
    (C99WordBuffer140.write_preserves before base input represented width writable r real) width writable q imag

end FT1536.Source3.C99TwoWordBuffer146
