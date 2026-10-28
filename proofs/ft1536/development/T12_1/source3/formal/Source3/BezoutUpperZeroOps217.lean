import Source3.SelectedBezoutInitMoreCells217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutUpperZeroOps217
open C99IntegerReference (Value ArithmeticExec)
open C99NatWord141 (word)

theorem sub (a b : Nat) (ab : b≤a) (bound : a<2^64) :
    ArithmeticExec .minus (.uint64 (word a)) (.uint64 (word b)) (.uint64 (word (a-b))) := by
  have bb : b<2^64 := by omega
  have raw := ArithmeticExec.step .minus (.uint64 (word a)) (.uint64 (word b)) .uint64 rfl
    (.uint64 (word a)) (.uint64 (word b))
    (C99CountedWords.convert_self (.uint64 (word a))).symm (C99CountedWords.convert_self (.uint64 (word b))).symm
    (by intro impossible; cases impossible)
  change ArithmeticExec .minus (.uint64 (word a)) (.uint64 (word b))
    (.uint64 (BitVec.ofInt 64 ((Value.uint64 (word a)).integer-(Value.uint64 (word b)).integer))) at raw
  rw [C99NatWord141.integer a bound,C99NatWord141.integer b bb] at raw
  have eq : (a : Int)-(b : Int)=((a-b : Nat) : Int) := by omega
  rw [eq,BitVec.ofInt_natCast] at raw
  exact raw

end FT1536.Source3.BezoutUpperZeroOps217
