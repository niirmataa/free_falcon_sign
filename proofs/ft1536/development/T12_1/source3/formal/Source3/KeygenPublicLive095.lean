import Source3.KeygenPublicRename095
import Source3.KeygenPublicTail095

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicLive095
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenPublicExec

def Live (s : State) : Prop := KeygenResultantRename093.ArraysLive s ∧ RngTemporarySwap090.TablesLive s

theorem same_live (before after : State) (sizes : after.heap.size = before.heap.size)
    (arrays : after.arrays = before.arrays) (tables : after.tables = before.tables) (live : Live before) : Live after := by
  constructor
  · intro name p binding
    rw [arrays] at binding
    rw [sizes]
    exact live.1 name p binding
  · intro name p binding
    rw [tables] at binding
    rw [sizes]
    exact live.2 name p binding

theorem address_live (before : State) (name : Name) (index : CLogic.Expr) (p : ArrayPointer)
    (live : Live before) (source : KeygenPublicWord.Address before name index p) : 0 < before.heap.size p.block := by
  cases source with
  | add root p v binding value nonnegative within =>
      cases within
      exact live.1 name root binding

theorem binding_live (before after : State) (params : List C99ArrayReference.Param) (args : List C99ArrayReference.Arg)
    (live : Live before) (source : KeygenPublicWord.Bind before params args after) : Live after := by
  induction source with
  | nil => exact ⟨live.2, live.2⟩
  | scalar ty name e ps args out v value rest ih => exact ih
  | pointer name src index p ps args out value rest ih =>
      refine ⟨?_, ih.2⟩
      intro key q binding
      change (if key = name then some p else out.arrays key) = some q at binding
      by_cases equal : key = name
      · rw [ite_eq_left equal] at binding
        cases Option.some.inj binding
        change 0 < out.heap.size p.block
        rw [KeygenPublicWord.bind_heap before ps args out rest]
        exact address_live before src index p live value
      · rw [ite_eq_right equal] at binding
        exact ih.1 key q binding

theorem tables (program : Program) (signed : List Name) (code : Stmt) (before : State) (out : Result)
    (source : Exec program signed code before out) : out.state.tables = before.tables := by
  induction source with
  | seqNormal a b before middle out head tail ih1 ih2 => exact ih2.trans ih1
  | loopNormal c body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact ih3.trans (ih2.trans ih1)
  | seqExit | scope | arrayScope | branchTrue | branchFalse | loopReturn => assumption
  | skip | scalar | assign | declarePointer | pointer | store | call | loopFalse | ret | retVoid => rfl

theorem globals (program : Program) (signed : List Name) (code : Stmt) (before : State) (out : Result)
    (source : Exec program signed code before out) : out.state.globals = before.globals := by
  induction source with
  | seqNormal a b before middle out head tail ih1 ih2 => exact ih2.trans ih1
  | loopNormal c body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact ih3.trans (ih2.trans ih1)
  | seqExit | scope | arrayScope | branchTrue | branchFalse | loopReturn => assumption
  | skip | scalar | assign | declarePointer | pointer | store | call | loopFalse | ret | retVoid => rfl

theorem no_arrays_live (program : Program) (signed : List Name) (code : Stmt) (before : State) (out : Result)
    (checked : KeygenPublicTail095.noArrays code = true) (live : Live before)
    (source : Exec program signed code before out) : Live out.state := by
  revert checked live
  induction source with
  | skip | scalar | assign | loopFalse | ret | retVoid => intro _ live; exact live
  | declarePointer name before =>
      intro _ live
      refine ⟨?_, live.2⟩
      intro key p binding
      change (if key = name then none else before.arrays key) = some p at binding
      by_cases equal : key = name
      · rw [ite_eq_left equal] at binding
        cases binding
      · rw [ite_eq_right equal] at binding
        exact live.1 key p binding
  | pointer dst src index before p source =>
      intro _ live
      refine ⟨?_, live.2⟩
      intro key q binding
      change (if key = dst then some p else before.arrays key) = some q at binding
      by_cases equal : key = dst
      · rw [ite_eq_left equal] at binding
        cases Option.some.inj binding
        exact address_live before src index p live source
      · rw [ite_eq_right equal] at binding
        exact live.1 key q binding
  | store name index cast e before after p v address value write =>
      intro _ live
      exact same_live before _ write.2.2.2.1 rfl rfl live
  | call name args f before entry out lookup binding source returned ih =>
      intro _ live
      have size := (KeygenPublicStability.body program f.signed f.body entry out source).size
      rw [KeygenPublicWord.bind_heap before f.params args entry binding] at size
      exact same_live before _ size rfl rfl live
  | seqNormal a b before middle out head tail ih1 ih2 =>
      intro checked live
      obtain ⟨ha, hb⟩ := Bool.and_eq_true_iff.mp checked
      exact ih2 hb (ih1 ha live)
  | seqExit a b before out head exit ih => intro checked live; exact ih (Bool.and_eq_true_iff.mp checked).1 live
  | scope locals pointers body before out source ih =>
      intro checked live
      have afterLive := ih checked live
      have sizes := (KeygenPublicStability.body program _ body before out source).size
      refine ⟨?_, afterLive.2⟩
      intro name p binding
      change (if pointers.contains name then before.arrays name else out.state.arrays name) = some p at binding
      by_cases member : pointers.contains name = true
      · rw [ite_eq_left member] at binding
        change 0 < out.state.heap.size p.block
        rw [sizes]
        exact live.1 name p binding
      · rw [ite_eq_right member] at binding
        exact afterLive.1 name p binding
  | arrayScope => intro checked; cases checked
  | branchTrue c yes no before out v guard nonzero body ih => intro checked live; exact ih (Bool.and_eq_true_iff.mp checked).1 live
  | branchFalse c yes no before out v guard zero body ih => intro checked live; exact ih (Bool.and_eq_true_iff.mp checked).2 live
  | loopNormal c body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      intro checked live
      obtain ⟨ha, hb⟩ := Bool.and_eq_true_iff.mp checked
      exact ih3 (Bool.and_eq_true_iff.mpr ⟨ha, hb⟩) (ih2 hb (ih1 ha live))
  | loopReturn c body increment before after v ret guard nonzero iteration ih =>
      intro checked live
      exact ih (Bool.and_eq_true_iff.mp checked).1 live

end FT1536.Source3.KeygenPublicLive095
