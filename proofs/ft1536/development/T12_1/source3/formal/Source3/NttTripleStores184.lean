import Source3.NttTripleScales184
import Source3.ModularSum184
import Source3.NttTripleStoreCells184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleStores184
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open NttTripleStates184
open KeygenNttButterflyPrograms (tripleBody declaration assign read zero scalar write)

theorem w0 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (i : Nat)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w)
    (bound : i+2<1536)
    (r1 : s.arrays "r1".toList=some (element a i)) :
    Exec (write "r1" zero
      (KeygenNttButterflyPrograms.add (scalar "fA") (KeygenNttButterflyPrograms.add (scalar "fB0") (scalar "fC0"))))
      (state11 s z) ⟨first s a i z,.normal⟩ :=
    ModularStore184.source (state11 s z) "r1" zero _ (element a i) (firstWord z) (RootBinding175.zero (state11 s z) "r1" (element a i) r1 (Nat.le_of_lt (fixed.allocated i (by omega)).2.2.1))
      (ModularSum184.source (state11 s z) "fA" "fB0" "fC0" z.a (b0 z) (c0 z) z.p
        (NttTripleCells184.fA_cell s z) (NttTripleCells184.fB0_cell s z) (NttTripleCells184.fC0_cell s z) fixed.pCell)
      (fixed.allocated i (by omega)) fixed.width fixed.writable

theorem w1 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (i : Nat)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w)
    (bound : i+2<1536)
    (r1 : s.arrays "r1".toList=some (element a i)) :
    Exec (write "r1" KeygenNttButterflyPrograms.stride
      (KeygenNttButterflyPrograms.add (scalar "fA") (KeygenNttButterflyPrograms.add (scalar "fB1") (scalar "fC2"))))
      (first s a i z) ⟨second s a i z,.normal⟩ :=
    ModularStore184.source (first s a i z) "r1" KeygenNttButterflyPrograms.stride _ (element a (i+1)) (secondWord z) (NttFirstControl182.address (first s a i z) "r1" a i r1 fixed.stride (by have := fixed.capacity; omega))
      (ModularSum184.source (first s a i z) "fA" "fB1" "fC2" z.a (b1 z) (c2 z) z.p
        (NttTripleStoreCells184.first_slot s a i z "fA" (z.a) (NttTripleCells184.fA_cell s z)) (NttTripleStoreCells184.first_slot s a i z "fB1" (b1 z) (NttTripleCells184.fB1_cell s z)) (NttTripleStoreCells184.first_slot s a i z "fC2" (c2 z) (NttTripleCells184.fC2_cell s z)) (NttTripleStoreCells184.first_slot s a i z "p" z.p fixed.pCell))
      (fixed.allocated (i+1) (by omega)) fixed.width fixed.writable

theorem w2 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (i : Nat)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w)
    (bound : i+2<1536)
    (r1 : s.arrays "r1".toList=some (element a i)) :
    Exec (write "r1" KeygenNttButterflyPrograms.twiceStride
      (KeygenNttButterflyPrograms.add (scalar "fA") (KeygenNttButterflyPrograms.add (scalar "fB2") (scalar "fC1"))))
      (second s a i z) ⟨third s a i z,.normal⟩ :=
    ModularStore184.source (second s a i z) "r1" KeygenNttButterflyPrograms.twiceStride _ (element a (i+2)) (thirdWord z) (NttTripleAddress184.offset (second s a i z) a i 2 _ r1 (NttTripleAddress184.small_product (second s a i z) fixed.stride 2 (by decide)) (by decide) (by have := fixed.capacity; omega))
      (ModularSum184.source (second s a i z) "fA" "fB2" "fC1" z.a (b2 z) (c1 z) z.p
        (NttTripleStoreCells184.second_slot s a i z "fA" (z.a) (NttTripleCells184.fA_cell s z)) (NttTripleStoreCells184.second_slot s a i z "fB2" (b2 z) (NttTripleCells184.fB2_cell s z)) (NttTripleStoreCells184.second_slot s a i z "fC1" (c1 z) (NttTripleCells184.fC1_cell s z)) (NttTripleStoreCells184.second_slot s a i z "p" z.p fixed.pCell))
      (fixed.allocated (i+2) (by omega)) fixed.width fixed.writable

end FT1536.Source3.NttTripleStores184
