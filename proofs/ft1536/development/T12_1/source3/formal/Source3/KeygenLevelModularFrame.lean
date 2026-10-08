import Source3.KeygenNttMemoryFrame
import Source3.C99PointerFootprint

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Operational byte frames for the modular routines at every search depth.
   No transform values, prime range, logn, or polynomial invariant is needed.
   The checker follows actual pointer assignments and Store32 destinations. -/
namespace FT1536.Source3.KeygenLevelModularFrame
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ArrayFrame (Outside)
open C99ModularReference (Stmt Exec)
open C99ProcedureReference (Result)

def only (names : List Name) : Stmt → Bool
  | .base code => C99PointerFootprint.only names code
  | .assign _ _ | .ret _ | .retVoid => true
  | .store32 name _ _ | .storeRev name _ _ _ _ => names.contains name
  | .seq a b | .branch _ a b | .loop _ a b => only names a && only names b
  | .scope _ body => only names body

theorem body_frame (code : Stmt) (before : State) (out : Result)
    (source : Exec code before out) (names : List Name) (checked : only names code=true)
    (block offset : Nat) (outside : Outside before names block offset) :
    Outside out.state names block offset ∧ out.state.tables=before.tables ∧
      out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | base code before after source =>
    exact C99PointerFootprint.body_frame _ code before after source names checked block offset outside
  | assign | ret | retVoid | loopFalse => exact ⟨outside,rfl,rfl⟩
  | store32 name index e before after p v address value write =>
    exact ⟨outside,rfl,write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame before names name index p 4 address
        (List.contains_iff_mem.mp checked) write.1 write.2.1 block offset outside)⟩
  | storeRev name table base index e before after p q bv w v baseValue tableAddress tableRead address value write =>
    exact ⟨outside,rfl,write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame before names name _ p 4 address
        (List.contains_iff_mem.mp checked) write.1 write.2.1 block offset outside)⟩
  | seqNormal a b before middle out head tail ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa
    exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | scope locals body before out inner ih => exact ih checked outside
  | branchTrue condition yes no before out v guard nonzero body ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | branchFalse condition yes no before out v guard zero body ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).2 outside
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oa,ta,fa⟩ := ih1 ha outside
    obtain ⟨ob,tb,fb⟩ := ih2 hb oa
    obtain ⟨oc,tc,fc⟩ := ih3 checked ob
    exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside

theorem sequence_checked (names : List Name) (a b : Stmt)
    (ha : only names a=true) (hb : only names b=true) : only names (.seq a b)=true :=
  Bool.and_eq_true_iff.mpr ⟨ha,hb⟩

end FT1536.Source3.KeygenLevelModularFrame
