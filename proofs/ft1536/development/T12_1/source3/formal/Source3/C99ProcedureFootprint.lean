import Source3.C99ProcedureReference
import Source3.C99PointerFootprint

/- Recursive procedure frames follow from a checked closed program table.
   The recursive proof follows the finite execution derivation, including
   early return, break and continue. No callee frame is an axiom. -/
namespace FT1536.Source3.C99ProcedureFootprint
open C99ArrayReference (State Name)
open C99ProcedureReference
open C99ArrayFrame (Outside)
open C99PointerFootprint (TablesOutside)

abbrev Signatures := Name → Option (List C99ArrayReference.Param)
abbrev Permissions := Name → List Name

def only (signatures : Signatures) (permissions : Permissions) (names : List Name) : Stmt → Bool
  | .base code => C99PointerFootprint.only names code
  | .seq a b | .branch _ a b | .loop _ a b =>
      only signatures permissions names a && only signatures permissions names b
  | .scope _ _ b => only signatures permissions names b
  | .ret _ | .breakLoop | .continueLoop => true
  | .call name args _ => match signatures name with
      | none => false
      | some ps => C99PointerFootprint.arguments names (permissions name) ps args

def Aligned (program : Program) (signatures : Signatures) : Prop :=
  ∀ name f, program name=some f → signatures name=some f.params
def Closed (program : Program) (signatures : Signatures) (permissions : Permissions) : Prop :=
  ∀ name f, program name=some f → only signatures permissions (permissions name) f.body=true

theorem receive_arrays (dst : Destination) (before after : State) (v : Option Value)
    (h : Receive dst before v after) : after.arrays=before.arrays ∧ after.tables=before.tables := by
  cases h <;> exact ⟨rfl,rfl⟩

theorem body_frame (program : Program) (signatures : Signatures) (permissions : Permissions)
    (aligned : Aligned program signatures) (closed : Closed program signatures permissions)
    (code : Stmt) (before : State) (result : Result) (h : Exec program code before result)
    (names : List Name) (checked : only signatures permissions names code=true)
    (block offset : Nat) (outside : Outside before names block offset)
    (tables : TablesOutside before block offset) :
    Outside result.state names block offset ∧ result.state.tables=before.tables ∧
      result.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction h generalizing names with
  | base code before after execution =>
      exact C99PointerFootprint.body_frame _ _ _ _ execution names checked block offset outside
  | seqNormal a b before middle result first second ih1 ih2 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
      obtain ⟨oa,ta,fa⟩ := ih1 names ha outside tables
      change middle.tables=before.tables at ta
      have tm : TablesOutside middle block offset := by simpa only [TablesOutside,ta] using tables
      obtain ⟨ob,tb,fb⟩ := ih2 names hb oa tm
      exact ⟨ob,tb.trans ta,fb.trans fa⟩
  | seqExit a b before result first exit ih =>
      exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables
  | scope locals pointers body before result inner ih =>
      obtain ⟨ho,ht,hf⟩ := ih names checked outside tables
      exact ⟨C99PointerFootprint.restore_outside before result.state locals pointers names block offset outside ho,ht,hf⟩
  | branchTrue condition yes no before result v guard nonzero body ih =>
      exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables
  | branchFalse condition yes no before result v guard zero body ih =>
      exact ih names (Bool.and_eq_true_iff.mp checked).2 outside tables
  | loopFalse | returnVoid | returnValue | breakLoop | continueLoop => exact ⟨outside,rfl,rfl⟩
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
      obtain ⟨oa,ta,fa⟩ := ih1 names ha outside tables
      change middle.tables=before.tables at ta
      have tm : TablesOutside middle block offset := by simpa only [TablesOutside,ta] using tables
      obtain ⟨ob,tb,fb⟩ := ih2 names hb oa tm
      change next.tables=middle.tables at tb
      have tn : TablesOutside next block offset := by simpa only [TablesOutside,tb,ta] using tables
      obtain ⟨oc,tc,fc⟩ := ih3 names checked ob tn
      exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopContinue condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
      obtain ⟨oa,ta,fa⟩ := ih1 names ha outside tables
      change middle.tables=before.tables at ta
      have tm : TablesOutside middle block offset := by simpa only [TablesOutside,ta] using tables
      obtain ⟨ob,tb,fb⟩ := ih2 names hb oa tm
      change next.tables=middle.tables at tb
      have tn : TablesOutside next block offset := by simpa only [TablesOutside,tb,ta] using tables
      obtain ⟨oc,tc,fc⟩ := ih3 names checked ob tn
      exact ⟨oc,tc.trans (tb.trans ta),fc.trans (fb.trans fa)⟩
  | loopBreak condition body increment before after v guard nonzero iteration ih =>
      exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
      exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables
  | call name args destination f before entry after result returned source parameters body conversion receive ih =>
      have hc : C99PointerFootprint.arguments names (permissions name) f.params args=true := by
        simpa only [only,aligned name f source] using checked
      obtain ⟨he,ht⟩ := C99PointerFootprint.bind_outside before f.params args entry parameters
        names (permissions name) hc block offset outside tables
      have te : TablesOutside entry block offset := by simpa only [TablesOutside,ht] using tables
      obtain ⟨_,_,hf⟩ := ih (permissions name) (closed name f source) he te
      obtain ⟨ha,ht'⟩ := receive_arrays destination {before with heap := result.state.heap} after returned receive
      have hh := receive_heap destination {before with heap := result.state.heap} after returned receive
      refine ⟨?_,ht',?_⟩
      · simpa only [Outside,ha] using outside
      · rw [hh]
        rw [C99ArrayReference.bind_heap before f.params args entry parameters] at hf
        exact hf

end FT1536.Source3.C99ProcedureFootprint
