import Source3.NttTripleControl184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleEntry184
open C99ArrayReference (State bindValue bindPointer)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot u64)
open NttFirstFixed182 (Fixed)

def withU (s : State) := bindValue s "u".toList .uint64 (u64 0)
def withR (s : State) := bindValue (withU s) "r".toList .uint64 (u64 512)
def after (s : State) (a : ArrayPointer) := bindPointer (withR s) "r1".toList a

theorem r_value (s : State) (logn : Slot s "logn" 10) :
    C99ArrayReference.scalar s (.bin .shl (.cast .u64 (.literal .i32 1)) (.bin .sub (.var "logn".toList) (.literal .i32 1))) (u64 512) :=
  .shift .left _ _ _ _ _ (.cast .uint64 _ _ (.literal .int32 1))
    (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ logn) (.literal .int32 1)
      (.step .minus (.uint32 10) (.int32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible)))
    (.unsignedLeft (.uint64 1) (.uint32 9) 9 rfl rfl (by decide))

theorem source (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (fixed : Fixed s a gm p p0i w)
    (logn : Slot s "logn" 10) (oldU oldR : Option C99IntegerReference.Value)
    (du : s.locals "u".toList=some (.uint64,oldU)) (dr : s.locals "r".toList=some (.uint64,oldR)) :
    Exec KeygenNttForwardPrograms.tripleInit s ⟨after s a,.normal⟩ := by
  have u : Exec (.assign "u".toList (.scalar (KeygenNttForwardPrograms.num 0))) s ⟨withU s,.normal⟩ :=
    .assign _ _ _ .uint64 oldU (.int32 0) du (.scalar _ _ (.literal .int32 0))
  have r : Exec KeygenNttForwardPrograms.rInit (withU s) ⟨withR s,.normal⟩ :=
    .assign _ _ _ .uint64 oldR (u64 512) dr (.scalar _ _ (r_value (withU s) logn))
  have ptr : Exec (KeygenNttForwardPrograms.bind "r1" "a" KeygenNttButterflyPrograms.zero) (withR s) ⟨after s a,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ a (RootBinding175.zero (withR s) "a" a fixed.aBinding (by have := fixed.capacity; omega)))
  exact .seqNormal _ _ s (withU s) _ u (.seqNormal _ _ (withU s) (withR s) _ r ptr)

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (f : Fixed s a gm p p0i w) :
    Fixed (after s a) a gm p p0i w :=
  ⟨f.pCell,f.iCell,f.wCell,f.nCell,f.hnCell,f.stride,f.aBinding,f.gmBinding,f.width,f.capacity,f.allocated,f.writable,f.initialized⟩

end FT1536.Source3.NttTripleEntry184
