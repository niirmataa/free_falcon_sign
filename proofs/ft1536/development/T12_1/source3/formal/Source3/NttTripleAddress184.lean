import Source3.NttMiddleAddress183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleAddress184
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Load32)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)

theorem small_product (s : State) (stride : USlot s "stride" 1) (d : Nat) (bound : d<4) :
    C99ArrayReference.scalar s (.bin .mul (.literal .i32 d) (.var "stride".toList)) (u64 d) := by
  interval_cases d <;>
    exact .arithmetic .times _ _ _ _ _ (.literal .int32 _) (.variable _ _ _ stride)
      (.step .times _ _ .uint64 rfl _ _ rfl rfl (by intro impossible; cases impossible))

theorem offset (s : State) (a : ArrayPointer) (l d : Nat) (e : CLogic.Expr)
    (binding : s.arrays "r1".toList=some (element a l)) (value : C99ArrayReference.scalar s e (u64 d))
    (bound : d<2^64) (capacity : a.index+l+d≤a.count) :
    Pointer s "r1".toList e (element a (l+d)) := by
  refine .add _ _ (element a l) _ (u64 d) binding value ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer d bound]; omega
  · rw [KeygenNttLoopSupport.u64_toNat d bound]
    simpa only [element,Nat.add_assoc] using C99MemoryReference.PointerAdd.within (element a l) d capacity

theorem table (s : State) (gm : ArrayPointer) (r : Nat) (bound : r<1024) (word : BitVec 32)
    (binding : s.arrays "gm".toList=some gm) (rc : USlot s "r" r) (read : Load32 s.heap (element gm r) word) :
    Pointer s "gm".toList (.var "r".toList) (element gm r) := by
  refine .add _ _ gm _ (u64 r) binding (.variable _ _ _ rc) ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer r (by omega)]; omega
  · rw [KeygenNttLoopSupport.u64_toNat r (by omega)]
    exact .within gm r (Nat.le_of_lt (NttReadFacts182.allocated _ _ _ read).2.2.1)

end FT1536.Source3.NttTripleAddress184
