import Source3.PublicReverseLoop173

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The real group prologue: declarations, generated twiddle load and end
   index. Its output supplies the already proved inner-loop domain. -/
namespace FT1536.Source3.PublicReverseGroupHead173
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer Allocated)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt chain)
open KeygenSmallOutput (element)
open KeygenPublicTableAtoms (Slot var)
open KeygenNttLoopSupport (USlot u64)
open PublicGenerateTable159 (Written)
open PublicTailShape159 (cvar cadd load)

def head : Stmt := chain [
  .scalar (.declare .u64 ["v2".toList]),
  .scalar (.declare .u32 ["s".toList]),
  .assign "s".toList (load "igm_square" (cadd (cvar "m") (cvar "u1"))),
  .assign "v2".toList (.bin .add (var "v1") (var "ht"))]
def suffix : Stmt := .seq
  (.seq (.assign "v".toList (var "v1")) KeygenPublicReverseProgram.loop) .skip

theorem shape : KeygenPublicReverseProgram.rowBody =
    .scope ["v2".toList,"s".toList] [] (KeygenPublicInputProgram.append head suffix) := by decide

structure Entry (s : State) (a gm : ArrayPointer) (ht m u start : Nat) : Prop where
  tableBound : m+u < 1024
  limit : start+ht+ht ≤ 1536
  capacity : a.index+1536 ≤ a.count
  tableCapacity : gm.index+1024 ≤ gm.count
  binding : s.arrays "a".toList=some a
  tableBinding : s.arrays "igm_square".toList=some gm
  half : USlot s "ht" ht
  groups : USlot s "m" m
  groupCounter : USlot s "u1" u
  startSlot : USlot s "v1" start
  vCell : ∃ old, s.locals "v".toList=some (.uint64,old)
  twiddle : Written s.heap (element gm (m+u))
  width : a.elementBytes=2
  writable : s.heap.writable a.block=true
  allocated : ∀ j, j < 1536 → Allocated s.heap (element a j)
  written : ∀ j, j < 1536 → Written s.heap (element a j)

theorem source (s : State) (a gm : ArrayPointer) (ht m u start : Nat)
    (entry : Entry s a gm ht m u start) :
    ∃ after, Exec KeygenPublicSource.program [] head s ⟨after,.normal⟩ ∧
      PublicMiddleLoop161.Fixed after a ht (start+ht) ∧ USlot after "v1" start ∧
      (∃ old, after.locals "v".toList=some (.uint64,old)) ∧ after.heap=s.heap := by
  let d0 : State := {s with locals := C99DeclarationCells.declareCells .uint64 ["v2".toList] s.locals}
  let d1 : State := {d0 with locals := C99DeclarationCells.declareCells .uint32 ["s".toList] d0.locals}
  have declare0 : Exec KeygenPublicSource.program [] (.scalar (.declare .u64 ["v2".toList])) s ⟨d0,.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint64 ["v2".toList] s.locals)
  have declare1 : Exec KeygenPublicSource.program [] (.scalar (.declare .u32 ["s".toList])) d0 ⟨d1,.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32 ["s".toList] d0.locals)
  have limit := entry.limit
  have tableBound := entry.tableBound
  have tableCapacity := entry.tableCapacity
  have mSlot : USlot d1 "m" m := entry.groups
  have uSlot : USlot d1 "u1" u := entry.groupCounter
  obtain ⟨w,readRun,factor⟩ := PublicWordSteps161.load_assign d1 "s" "igm_square"
    (cadd (cvar "m") (cvar "u1")) (element gm (m+u)) none (by rfl)
    (PublicWordSteps161.address_sum d1 "igm_square" "m" "u1" gm m u (by omega)
      entry.tableBinding mSlot uSlot (by omega)) entry.twiddle
  let middle := bindValue d1 "s".toList .uint32 (C99NarrowReads.unsignedPromotion w)
  have startSlot : USlot middle "v1" start := entry.startSlot
  have half : USlot middle "ht" ht := entry.half
  have stopEval : KeygenPublicWord.Eval [] middle (.bin .add (var "v1") (var "ht")) (u64 (start+ht)) :=
    .bin .add _ _ _ _ _
      (.scalar _ _ (PublicGenerateIndex159.var_u64 middle "v1" start startSlot))
      (.scalar _ _ (PublicGenerateIndex159.var_u64 middle "ht" ht half))
      (C99NatWord141.add start ht (by omega) (by omega))
  let after := bindValue middle "v2".toList .uint64 (u64 (start+ht))
  have stopRun : Exec KeygenPublicSource.program []
      (.assign "v2".toList (.bin .add (var "v1") (var "ht"))) middle ⟨after,.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 (start+ht)) (by rfl) stopEval
  have fixed : PublicMiddleLoop161.Fixed after a ht (start+ht) :=
    ⟨entry.limit,entry.capacity,entry.binding,
      PublicGenerateRow159.keep_u64 middle "ht" "v2" .uint64 _ ht (by decide) half,
      PublicGenerateRow159.u64_slot_after middle "v2" (start+ht) (by omega),
      ⟨_,PublicGenerateRow159.keep_slot middle "s" "v2" .uint64 _ _ (by decide) factor⟩,
      entry.width,entry.writable,entry.allocated,entry.written⟩
  refine ⟨after,PublicGenerateRow159.chain_step _ _ s d0 ⟨after,.normal⟩ declare0
    (PublicGenerateRow159.chain_step _ _ d0 d1 ⟨after,.normal⟩ declare1
      (PublicGenerateRow159.chain_step _ _ d1 middle ⟨after,.normal⟩ readRun
        (PublicGenerateRow159.chain_step _ _ middle after ⟨after,.normal⟩ stopRun (.skip after)))),
    fixed,PublicGenerateRow159.keep_u64 middle "v1" "v2" .uint64 _ start (by decide) startSlot,?_,rfl⟩
  obtain ⟨old,cell⟩ := entry.vCell
  exact ⟨old,cell⟩

end FT1536.Source3.PublicReverseGroupHead173
