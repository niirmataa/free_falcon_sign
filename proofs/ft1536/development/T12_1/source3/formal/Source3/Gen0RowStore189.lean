import Source3.Gen0RowIndex189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.Gen0RowStore189
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open C99ModularReference (Exec Eval)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open Gen0RowIndex189 (reverse8 lastIndex)

def after (s : State) (dst : ArrayPointer) (u : Nat) (value : BitVec 32) : State :=
  {s with heap:=Word32Memory176.write s.heap (element dst (lastIndex u)) value}

theorem source (s : State) (name : String) (dst rev : ArrayPointer) (index : CLogic.Expr)
    (expr : C99ModularReference.Expr) (u : Nat) (word : BitVec 32) (bound : u<256)
    (binding : s.arrays name.toList=some dst) (table : KeygenMkgm3RevMemory.Rev s rev)
    (base : USlot s "b" 256) (value : C99ArrayReference.scalar s index (u64 (4*u)))
    (evaluated : Eval s expr (.uint32 word))
    (allocated : Allocated s.heap (element dst (lastIndex u)))
    (width : dst.elementBytes=4) (writable : s.heap.writable dst.block=true) :
    Exec (KeygenMkgm3Program.storeRev name index expr) s ⟨after s dst u word,.normal⟩ := by
  apply C99ModularReference.GenExec.storeRev name.toList "REV10".toList (.var "b".toList) index expr
    s (after s dst u word).heap (element dst (lastIndex u)) (element rev (4*u))
    (u64 256) (BitVec.ofNat 16 (reverse8 u)) (.uint32 word)
  · exact .variable _ _ _ base
  · exact Gen0RowIndex189.rev_pointer s rev index u bound table value
  · exact Gen0RowIndex189.rev_read s rev u bound table
  · rw [Gen0RowIndex189.destination_index u bound]
    exact Gen0RowIndex189.destination s name dst u bound binding allocated
  · exact evaluated
  · simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,after] using
      Word32Memory176.source s.heap (element dst (lastIndex u)) word allocated width writable

end FT1536.Source3.Gen0RowStore189
