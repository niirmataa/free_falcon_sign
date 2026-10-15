import Source3.KeygenSearchExtended133
import Source3.KeygenSearchFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSearchFrame133
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ArrayFrame (Outside)
open C99PointerFootprint (PointOutside TablesOutside)
open C99ProcedureReference (Result)
open KeygenSearchExec (Stmt)
open KeygenSearchExtended133 (Exec)
open KeygenSearchFrame (only pointer_outside)
open KeygenSearchContext (Context)

theorem body_frame (ctx : Context) (code : Stmt) (before : State) (out : Result)
    (source : Exec ctx code before out) (names : List Name) (checked : only names code=true)
    (block offset : Nat) (outside : Outside before names block offset)
    (tables : TablesOutside before block offset) (scratch : PointOutside ctx.scratch block offset) :
    Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | procedure code before out source =>
    exact KeygenSearchFft.body_frame code before out source names checked block offset outside tables
  | logn | assign | loopFalse => exact ⟨outside,rfl,rfl⟩
  | pointer dst e before p source =>
    have hp := pointer_outside ctx before e p source names checked block offset outside scratch
    refine ⟨?_,rfl,rfl⟩
    intro name member q binding
    by_cases eq : name=dst
    · have he : p=q := Option.some.inj (by simpa [C99ArrayReference.bindPointer,eq] using binding)
      simpa only [← he,PointOutside] using hp
    · exact outside name member q (by simpa [C99ArrayReference.bindPointer,eq] using binding)
  | store32 dst index e before after p v address value write =>
    exact ⟨outside,rfl,write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame before names dst index p 4 address
        (List.contains_iff_mem.mp checked) write.1 write.2.1 block offset outside)⟩
  | store64 dst index e before after p v address value write =>
    exact ⟨outside,rfl,write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame before names dst index p 8 address
        (List.contains_iff_mem.mp checked) write.1 write.2.1 block offset outside)⟩
  | move dst src count before after p q word destination source length copy =>
    exact ⟨outside,rfl,KeygenSearchMemory.memmove_frame before.heap after p q word.toNat block offset copy
      (pointer_outside ctx before dst p destination names checked block offset outside scratch)⟩
  | small args before after source =>
    have keep := KeygenSearchLeaves.small_frame before after args source names block offset checked outside tables
    cases source
    exact ⟨outside,rfl,keep⟩
  | seqNormal a b before middle out head tail ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa (by simpa only [TablesOutside,ta] using tables)
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | scope locals pointers body before out inner ih =>
    obtain ⟨ho,ht,hf⟩ := ih checked outside tables
    exact ⟨C99PointerFootprint.restore_outside before out.state locals pointers names block offset outside ho,ht,hf⟩
  | branchTrue condition yes no before out v guard nonzero body ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables
  | branchFalse condition yes no before out v guard zero body ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).2 outside tables
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside tables
    change middle.tables=before.tables at ta
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa (by simpa only [TablesOutside,ta] using tables)
    change next.tables=middle.tables at tb
    obtain ⟨oc,tc,fc⟩ := ih3 checked ob (by simpa only [TablesOutside,tb,ta] using tables)
    exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside tables

end FT1536.Source3.KeygenSearchFrame133
