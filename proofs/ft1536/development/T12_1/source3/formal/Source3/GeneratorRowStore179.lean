import Source3.GeneratorRowIndex179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorRowStore179
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open C99ModularReference (Exec Eval)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open KeygenMkgm3Indices (reverse9 lastIndex)

def after (s : State) (dst : ArrayPointer) (u : Nat) (value : BitVec 32) : State :=
  {s with heap:=Word32Memory176.write s.heap (element dst (lastIndex u)) value}

theorem source (s : State) (name : String) (dst rev : ArrayPointer) (index : CLogic.Expr)
    (expr : C99ModularReference.Expr) (u : Nat) (word : BitVec 32) (bound : u<512)
    (binding : s.arrays name.toList=some dst) (table : KeygenMkgm3RevMemory.Rev s rev)
    (base : USlot s "b" 512) (value : C99ArrayReference.scalar s index (u64 (2*u)))
    (evaluated : Eval s expr (.uint32 word))
    (allocated : Allocated s.heap (element dst (lastIndex u)))
    (width : dst.elementBytes=4) (writable : s.heap.writable dst.block=true) :
    Exec (KeygenMkgm3Program.storeRev name index expr) s ⟨after s dst u word,.normal⟩ := by
  apply C99ModularReference.GenExec.storeRev name.toList "REV10".toList (.var "b".toList) index expr
    s (after s dst u word).heap (element dst (lastIndex u)) (element rev (2*u))
    (u64 512) (BitVec.ofNat 16 (reverse9 u)) (.uint32 word)
  · exact .variable _ _ _ base
  · exact GeneratorRowIndex179.rev_pointer s rev index u bound table value
  · exact table.2.2 u bound
  · rw [GeneratorRowIndex179.destination_index u bound]
    exact GeneratorRowIndex179.destination s name dst u bound binding allocated
  · exact evaluated
  · simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,after] using
      Word32Memory176.source s.heap (element dst (lastIndex u)) word allocated width writable

end FT1536.Source3.GeneratorRowStore179
