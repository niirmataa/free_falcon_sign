import Source3.C99ProcedureSegments136
import Source3.C99Metadata091
import Source3.KeygenAttemptSlots

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ProcedureFrame136
open C99ArrayReference (State Name)
open C99ProcedureReference (Stmt Exec Program Result)
open C99ArrayFrame (Outside)
open C99ProcedureSegments136 (Prefix)

/- This footprint admits only the supported scalar/store fragment. No
   procedure or memory-call footprint is assumed, even for readonly tables. -/
def arrayOnly (names : List Name) : C99ArrayReference.Stmt → Bool
  | .skip | .scalar _ | .assign _ _ => true
  | .store64 name _ _ => names.contains name
  | _ => false

def only (names : List Name) : Stmt → Bool
  | .base code => arrayOnly names code
  | .seq first second | .branch _ first second | .loop _ first second => only names first && only names second
  | .scope _ _ body => only names body
  | _ => false

theorem array_frame (program : C99ArrayReference.Program) (code : C99ArrayReference.Stmt)
    (before after : State) (source : C99ArrayReference.Exec program code before after)
    (names : List Name) (checked : arrayOnly names code=true) (block offset : Nat)
    (outside : Outside before names block offset) :
    Outside after names block offset ∧ after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source <;> try (solve | cases checked)
  case skip | scalar | assign => exact ⟨outside,rfl⟩
  case store64 after name index expr pointer value address evaluated write =>
    exact ⟨outside,write.2.2.2.2.2.2 block offset
      (C99ArrayFrame.pointer_store_frame before names name index pointer 8 address
        (List.contains_iff_mem.mp checked) write.1 write.2.1 block offset outside)⟩

theorem frame (program : Program) (code : Stmt) (before : State) (out : Result)
    (source : Exec program code before out) (names : List Name) (checked : only names code=true)
    (block offset : Nat) (outside : Outside before names block offset) :
    Outside out.state names block offset ∧ out.state.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | base code before after source => exact array_frame _ _ _ _ source names checked block offset outside
  | seqNormal first second before middle out head tail ihFirst ihSecond =>
    obtain ⟨a,b⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨firstOutside,firstBytes⟩ := ihFirst a outside
    obtain ⟨lastOutside,lastBytes⟩ := ihSecond b firstOutside
    exact ⟨lastOutside,lastBytes.trans firstBytes⟩
  | seqExit first second before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | scope locals pointers body before out source ih =>
    obtain ⟨lastOutside,lastBytes⟩ := ih checked outside
    exact ⟨C99PointerFootprint.restore_outside before out.state locals pointers names block offset outside lastOutside,lastBytes⟩
  | branchTrue condition yes no before out value guard nonzero source ih => exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | branchFalse condition yes no before out value guard zero source ih => exact ih (Bool.and_eq_true_iff.mp checked).2 outside
  | loopFalse => exact ⟨outside,rfl⟩
  | loopNormal condition body increment before middle next out value guard nonzero iteration update rest ihBody ihUpdate ihRest
  | loopContinue condition body increment before middle next out value guard nonzero iteration update rest ihBody ihUpdate ihRest =>
    obtain ⟨a,b⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨oneOutside,oneBytes⟩ := ihBody a outside
    obtain ⟨twoOutside,twoBytes⟩ := ihUpdate b oneOutside
    obtain ⟨lastOutside,lastBytes⟩ := ihRest checked twoOutside
    exact ⟨lastOutside,lastBytes.trans (twoBytes.trans oneBytes)⟩
  | loopBreak condition body increment before after value guard nonzero iteration ih
  | loopReturn condition body increment before after value returned guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | returnVoid | returnValue | breakLoop | continueLoop | call => cases checked

theorem metadata (program : Program) (code : Stmt) (before : State) (out : Result)
    (source : Exec program code before out) : C99Metadata091.Stable before out.state := by
  induction source with
  | base code before after source => exact C99Metadata091.array _ _ _ _ source
  | seqNormal first second before middle out head tail ihFirst ihSecond => exact C99Metadata091.trans _ _ _ ihFirst ihSecond
  | seqExit first second before out head exit ih => exact ih
  | scope locals pointers body before out source ih => exact ⟨ih.sizes,ih.writable,ih.tables,ih.globals⟩
  | branchTrue condition yes no before out value guard nonzero source ih => exact ih
  | branchFalse condition yes no before out value guard zero source ih => exact ih
  | loopFalse | returnVoid | returnValue | breakLoop | continueLoop => exact C99Metadata091.refl _
  | loopNormal condition body increment before middle next out value guard nonzero iteration update rest ihBody ihUpdate ihRest
  | loopContinue condition body increment before middle next out value guard nonzero iteration update rest ihBody ihUpdate ihRest =>
    exact C99Metadata091.trans _ _ _ ihBody (C99Metadata091.trans _ _ _ ihUpdate ihRest)
  | loopBreak condition body increment before after value guard nonzero iteration ih
  | loopReturn condition body increment before after value returned guard nonzero iteration ih => exact ih
  | call name args destination function before entry after out returned found binding body conversion receive ih =>
    have heap := C99ArrayReference.bind_heap _ _ _ _ binding
    cases receive <;> exact ⟨ih.sizes.trans (congrArg C99MemoryReference.Memory.size heap),
      ih.writable.trans (congrArg C99MemoryReference.Memory.writable heap),rfl,rfl⟩

theorem prefix_metadata (program : Program) (condition : CLogic.Expr) (body increment : Stmt) (count : Nat)
    (before after : State) (source : Prefix program condition body increment count before after) :
    C99Metadata091.Stable before after := by
  induction source with
  | done => exact C99Metadata091.refl _
  | next count before middle updated after value guard nonzero iteration update rest ih =>
    exact C99Metadata091.trans _ _ _ (metadata _ _ _ _ iteration)
      (C99Metadata091.trans _ _ _ (metadata _ _ _ _ update) ih)

theorem prefix_arrays (program : Program) (condition : CLogic.Expr) (body increment : Stmt) (count : Nat)
    (before after : State) (source : Prefix program condition body increment count before after)
    (bodyChecked : KeygenAttemptSlots.procedureOnly body=true) (incrementChecked : KeygenAttemptSlots.procedureOnly increment=true) :
    after.arrays=before.arrays := by
  induction source with
  | done => rfl
  | next count before middle updated after value guard nonzero iteration update rest ih =>
    exact ih.trans ((KeygenAttemptSlots.procedure _ _ _ _ update incrementChecked).1.trans
      (KeygenAttemptSlots.procedure _ _ _ _ iteration bodyChecked).1)

theorem prefix_outside (program : Program) (condition : CLogic.Expr) (body increment : Stmt) (count : Nat)
    (before after : State) (source : Prefix program condition body increment count before after)
    (names : List Name) (bodyChecked : only names body=true) (incrementChecked : only names increment=true)
    (block offset : Nat) (outside : Outside before names block offset) :
    Outside after names block offset ∧ after.heap.bytes block offset=before.heap.bytes block offset := by
  induction source with
  | done => exact ⟨outside,rfl⟩
  | next count before middle updated after value guard nonzero iteration update rest ih =>
    obtain ⟨first,one⟩ := frame program body before _ iteration names bodyChecked block offset outside
    obtain ⟨second,two⟩ := frame program increment middle _ update names incrementChecked block offset first
    obtain ⟨last,three⟩ := ih second
    exact ⟨last,three.trans (two.trans one)⟩

end FT1536.Source3.C99ProcedureFrame136
