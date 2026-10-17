import Source3.PublicGenerateRemaining159
import Source3.PublicTailShape159

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Region 2 first pass (fragment 1001 61): r = gm_square[1] and the
   768-iteration X^2-X+1 loop on a[u], a[u+hn]. Value-free: constructive
   executions of the pinned statements only; no NTT evaluation, twiddle
   property or semantic premise enters. -/
namespace FT1536.Source3.PublicTailFirst159
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer Memory)
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicWord (Eval Address)
open KeygenPublicTableAtoms (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open PublicTailShape159
open PublicGenerateTable159 (Written WrittenRange)
open PublicGenerateIndex159 (lit_i32 var_u64 pointer_within)
open PublicGenerateHead159 (eval_lit eval_var mul_call u32_arg)
open PublicGenerateRow159 (keep_slot keep_u64 u32_slot_after u64_slot_after)

theorem lit_integer (i : Nat) (hi : i<2^31) :
    (C99IntegerReference.convert .int32 i).integer=(i:Int) := by
  show (BitVec.ofInt 32 (i:Int)).toInt=(i:Int)
  exact BitVec.toInt_ofInt_eq_self (by decide) (by omega) (by omega)

theorem address_lit (s : State) (name : String) (p : ArrayPointer) (i : Nat)
    (hi : i<2^31) (binding : s.arrays name.toList=some p)
    (capacity : p.index+i ≤ p.count) :
    Address s name.toList (clit i) (element p i) :=
  .add name.toList (clit i) p (element p i)
    (C99IntegerReference.convert .int32 i) binding (lit_i32 s i)
    (by rw [lit_integer i hi]; omega)
    (by rw [lit_integer i hi]; exact pointer_within p i capacity)

/- Written cells can be read as unsigned 16-bit loads. -/
theorem written_load16 (heap : Memory) (p : ArrayPointer) (w : BitVec 16)
    (read : C99NarrowReads.Load16 heap p w) :
    Written heap p := ⟨w,read⟩

/- Entry of the tail: a[0..1536) image, gm_square[1] readable, dims bound. -/
structure TailEntry (s : State) (a gm : ArrayPointer) : Prop where
  aBinding : s.arrays "a".toList=some a
  squareBinding : s.arrays "gm_square".toList=some gm
  nSlot : USlot s "n" 1536
  hnSlot : USlot s "hn" 768
  lognSlot : Slot s "logn" 10
  aImage : ∀ i, i<1536 → Written s.heap (element a i)
  gmImage : Written s.heap (element gm 1)
  rCell : ∃ old, s.locals "r".toList=some (.uint32,old)
  wCell : ∃ old, s.locals "w".toList=some (.uint32,old)
  aWidth : a.elementBytes=2
  aWritable : s.heap.writable a.block=true
  aAllocated : ∀ i, i<1536 → C99MemoryReference.Allocated s.heap (element a i)
  aCount : a.index+1536 ≤ a.count
  gmWidth : gm.elementBytes=2
  gmWritable : s.heap.writable gm.block=true
  gmAllocated : C99MemoryReference.Allocated s.heap (element gm 1)
  gmCount : gm.index+1 ≤ gm.count

/- r = gm_square[1]. -/
theorem rSet_exec (s : State) (a gm : ArrayPointer) (e : TailEntry s a gm) :
    ∃ w, C99NarrowReads.Load16 s.heap (element gm 1) w ∧
      Exec KeygenPublicSource.program [] PublicTailShape159.rSet s
        ⟨bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w),.normal⟩ ∧
      Slot (bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w)) "r"
        (BitVec.ofNat 32 w.toNat) := by
  obtain ⟨w,read⟩ := e.gmImage
  obtain ⟨oldR,rEq⟩ := e.rCell
  have address : Address s "gm_square".toList (clit 1) (element gm 1) :=
    address_lit s "gm_square" gm 1 (by decide) e.squareBinding e.gmCount
  have loadEval : Eval [] s (load "gm_square" (clit 1))
      (C99NarrowReads.unsignedPromotion w) :=
    .load16 "gm_square".toList (clit 1) (element gm 1) w address read
  have exec : Exec KeygenPublicSource.program [] PublicTailShape159.rSet s
      ⟨bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w),.normal⟩ :=
    .assign "r".toList _ s .uint32 oldR
      (C99NarrowReads.unsignedPromotion w) rEq loadEval
  have slot : Slot (bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w)) "r"
      (BitVec.ofNat 32 w.toNat) :=
    PublicGenerateUpper159.load_slot s "r" w
  exact ⟨w,read,exec,slot⟩

end FT1536.Source3.PublicTailFirst159
