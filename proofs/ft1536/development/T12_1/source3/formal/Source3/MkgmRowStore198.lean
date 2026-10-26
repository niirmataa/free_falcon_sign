import Source3.MkgmRowFixed198

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmRowStore198
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open C99ModularReference (Exec Eval)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open MkgmParams198 (Level half scale reverse lastIndex)

def after (l : Level) (s : State) (dst : ArrayPointer) (u : Nat) (value : BitVec 32) : State :=
  {s with heap:=Word32Memory176.write s.heap (element dst (lastIndex l u)) value}

theorem source (l : Level) (s : State) (name : String) (dst rev : ArrayPointer) (index : CLogic.Expr)
    (expr : C99ModularReference.Expr) (u : Nat) (word : BitVec 32) (bound : u<half l)
    (binding : s.arrays name.toList=some dst) (table : KeygenMkgm3RevMemory.Rev s rev)
    (base : USlot s "b" (half l)) (value : C99ArrayReference.scalar s index (u64 (scale l*u)))
    (evaluated : Eval s expr (.uint32 word))
    (allocated : Allocated s.heap (element dst (lastIndex l u)))
    (width : dst.elementBytes=4) (writable : s.heap.writable dst.block=true) :
    Exec (KeygenMkgm3Program.storeRev name index expr) s ⟨after l s dst u word,.normal⟩ := by
  apply C99ModularReference.GenExec.storeRev name.toList "REV10".toList (.var "b".toList) index expr
    s (after l s dst u word).heap (element dst (lastIndex l u)) (element rev (scale l*u))
    (u64 (half l)) (BitVec.ofNat 16 (reverse l u)) (.uint32 word)
  · exact .variable _ _ _ base
  · exact MkgmRowIndex198.rev_pointer l s rev index u bound table value
  · exact MkgmRowIndex198.rev_read l s rev u bound table
  · rw [MkgmRowIndex198.destination_index l u bound]
    exact MkgmRowIndex198.destination l s name dst u bound binding allocated
  · exact evaluated
  · simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq,after] using
      Word32Memory176.source s.heap (element dst (lastIndex l u)) word allocated width writable

end FT1536.Source3.MkgmRowStore198
