import Source3.NttVLoop183
import Source3.NttReadFacts182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttMiddleAddress183
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Load32)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)

theorem times_one (n : Nat) (bound : n<2^64) :
    C99IntegerReference.ArithmeticExec .times (u64 n) (u64 1) (u64 n) := by
  have raw := C99IntegerReference.ArithmeticExec.step .times (u64 n) (u64 1) .uint64 rfl
    (u64 n) (u64 1) (C99CountedWords.convert_self _).symm rfl (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .times (u64 n) (u64 1)
    (C99IntegerReference.convert .uint64 ((u64 n).integer*1)) at raw
  rw [mul_one,KeygenNttLoopSupport.u64_integer n bound,KeygenNttLoopSupport.convert_u64_nat] at raw
  exact raw

theorem product (s : State) (name indexName : String) (a : ArrayPointer) (base n : Nat)
    (bound : n<2^64) (binding : s.arrays name.toList=some (element a base))
    (indexCell : USlot s indexName n) (stride : USlot s "stride" 1) (capacity : a.index+base+n≤a.count) :
    Pointer s name.toList (.bin .mul (.var indexName.toList) (.var "stride".toList)) (element a (base+n)) := by
  refine .add _ _ (element a base) _ (u64 n) binding
    (.arithmetic .times _ _ _ _ _ (.variable _ _ _ indexCell) (.variable _ _ _ stride) (times_one n bound)) ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer n bound]; omega
  · rw [KeygenNttLoopSupport.u64_toNat n bound]
    simpa only [element,Nat.add_assoc] using C99MemoryReference.PointerAdd.within (element a base) n capacity

theorem table (s : State) (gm : ArrayPointer) (m j : Nat) (bound : m+j<1024) (word : BitVec 32)
    (binding : s.arrays "gm".toList=some gm) (mc : USlot s "m" m) (jc : USlot s "u1" j)
    (read : Load32 s.heap (element gm (m+j)) word) :
    Pointer s "gm".toList (.bin .add (.var "m".toList) (.var "u1".toList)) (element gm (m+j)) := by
  refine .add _ _ gm _ (u64 (m+j)) binding
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ mc) (.variable _ _ _ jc) (C99NatWord141.add m j (by omega) (by omega))) ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer (m+j) (by omega)]; omega
  · rw [KeygenNttLoopSupport.u64_toNat (m+j) (by omega)]
    exact .within gm (m+j) (Nat.le_of_lt (NttReadFacts182.allocated _ _ _ read).2.2.1)

end FT1536.Source3.NttMiddleAddress183
