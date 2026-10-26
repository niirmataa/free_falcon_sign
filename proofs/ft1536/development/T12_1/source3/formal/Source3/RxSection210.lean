import Source3.RxWhole210

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.RxSection210
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32)
open RxModel210 (resultWord)
open KeygenMakeFgSource (Exec)

theorem one_word (p pi r2 : BitVec 32) : resultWord 1 p pi r2=KeygenModpR.word p := rfl

theorem two_word (p pi r2 : BitVec 32) : resultWord 2 p pi r2=KeygenModpWord.montgomery (KeygenModpR.word p) r2 p pi := rfl

theorem source (s : State) (n : Nat) (p pi r2 : BitVec 32) (old : Option C99IntegerReference.Value)
    (positive : 0 < n) (bound : n ≤ 1024) (slen : Cell s "slen".toList n)
    (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (rc : Slot s "R2" r2)
    (declared : s.locals "Rx".toList=some (.uint32,old)) :
    Exec MakeFgAddPrimeShape194.rxSet s ⟨set32 s "Rx" (resultWord n p pi r2),.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint32 old (.uint32 (resultWord n p pi r2)) declared
    (.call4 _ _ _ _ _ _ _ _ _ _
      (.scalar _ _ (C99LoopScalar141.read s "slen".toList n slen))
      (.scalar _ _ (.variable _ _ _ pc)) (.scalar _ _ (.variable _ _ _ ic)) (.scalar _ _ (.variable _ _ _ rc))
      (RxWhole210.call64 s n p pi r2 positive bound))))

theorem source_two (s : State) (p pi r2 : BitVec 32) (old : Option C99IntegerReference.Value)
    (slen : Cell s "slen".toList 2) (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (rc : Slot s "R2" r2)
    (declared : s.locals "Rx".toList=some (.uint32,old)) :
    Exec MakeFgAddPrimeShape194.rxSet s ⟨set32 s "Rx" (KeygenModpWord.montgomery (KeygenModpR.word p) r2 p pi),.normal⟩ := by
  simpa only [two_word] using source s 2 p pi r2 old (by decide) (by decide) slen pc ic rc declared

end FT1536.Source3.RxSection210
