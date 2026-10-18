import Source3.SelectedTopLayout177
import Source3.MemmoveWord177

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTopMove177
open C99ArrayReference (State)
open C99MemoryReference
open KeygenLevelExec (Exec)
open SelectedTopLayout177 (fd fs gs)
noncomputable def before := SelectedTopLayout177.after
noncomputable def after : State := {before with heap:=MemmoveWord177.snapshot before.heap fs fd 12288}

theorem extent : 4*71680≤before.heap.size 31 := by
  rw [before,SelectedTopLayout177.heap]
  change 4*71680≤SelectedMakeFgConvert176.after.heap.size 31
  rw [SelectedMakeFgConvert176.frame.sizes]
  exact SelectedMakeFgDomains176.extent

theorem size_bound : before.heap.size 31<2^64 := by
  rw [before,SelectedTopLayout177.heap]
  change SelectedMakeFgConvert176.after.heap.size 31<2^64
  rw [SelectedMakeFgConvert176.frame.sizes]
  exact SelectedMakeFgDomains176.size_bound

theorem writable : before.heap.writable 31=true := by
  rw [before,SelectedTopLayout177.heap]
  exact SelectedMakeFgTopEntry176.writable

theorem initialized : ∀ i<12288, (before.heap.bytes fd.block (fd.offset+i)).isSome := by
  apply MemmoveWord177.initialized_bytes before.heap fd 3072 (by decide)
  intro j hj
  rw [before,SelectedTopLayout177.heap]
  exact SelectedMakeFgTopEntry176.initialized j hj

theorem copy : KeygenSearchMemory.Memmove before.heap fs fd 12288 after.heap :=
  MemmoveWord177.source before.heap fs fd 12288 (by decide) (by decide)
    extent extent size_bound size_bound writable initialized

theorem count_source : C99ArrayReference.scalar before MakeFgTopShape177.countExpr (.uint64 12288) :=
  .arithmetic .times _ _ _ _ _
    (.arithmetic .times _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 2)
      (.step .times (.uint64 1536) (.int32 2) .uint64 rfl (.uint64 1536) (.uint64 2) rfl rfl
        (by intro impossible; cases impossible)))
    (.literal .uint64 4)
    (.step .times (.uint64 3072) (.uint64 4) .uint64 rfl (.uint64 3072) (.uint64 4) rfl rfl
      (by intro impossible; cases impossible))

theorem source : Exec MakeFgTopShape177.move before ⟨after,.normal⟩ :=
  .move _ _ _ _ _ before after.heap fs fd 12288
    (RootBinding175.zero before "fs" fs rfl (by decide))
    (RootBinding175.zero before "data" fd rfl (by decide)) count_source copy

theorem allocated (index : Nat) (inside : index<71680) :
    Allocated after.heap {KeygenFullData127.env.ctx.scratch with index:=index} := by
  change 0<4 ∧ 0%4=0 ∧ index<71680 ∧ 0+4*71680≤before.heap.size 31 ∧ before.heap.size 31<2^64
  exact ⟨by decide,by decide,inside,extent,size_bound⟩

theorem f_image : Word32Memory176.Represents after.heap fs SelectedMakeFgConvert176.fImage := by
  intro i
  apply MemmoveWord177.load_word before.heap after.heap fs fd 3072 i.val _ copy (by have h:=i.isLt; omega)
    (by decide) (by decide)
  · exact allocated (1694+i.val) (by have h:=i.isLt; omega)
  · rw [before,SelectedTopLayout177.heap]
    exact SelectedMakeFgConvert176.f_image i

theorem g_image : Word32Memory176.Represents after.heap gs SelectedMakeFgConvert176.gImage := by
  intro i
  have read : Load32 before.heap (KeygenSmallOutput.element fd (1536+i.val)) (SelectedMakeFgConvert176.gImage i) := by
    rw [before,SelectedTopLayout177.heap]
    have equal : KeygenSmallOutput.element fd (1536+i.val)=Word32Memory176.element SelectedMakeFgSetup176.gt i := by
      unfold KeygenSmallOutput.element Word32Memory176.element SelectedMakeFgSetup176.gt fd
      congr 1
      change SelectedMakeFgSetup176.ft.index+(1536+i.val)=SelectedMakeFgSetup176.ft.index+1536+i.val
      omega
    rw [equal]
    exact SelectedMakeFgConvert176.g_image i
  have result := MemmoveWord177.load_word before.heap after.heap fs fd 3072 (1536+i.val) _ copy
    (by have h:=i.isLt; omega) (by decide) (by decide)
    (allocated (1694+(1536+i.val)) (by have h:=i.isLt; omega)) read
  have equal : KeygenSmallOutput.element fs (1536+i.val)=Word32Memory176.element gs i := by
    unfold gs KeygenSmallOutput.element Word32Memory176.element
    congr 1
    change fs.index+(1536+i.val)=fs.index+1536+i.val
    omega
  rw [equal] at result
  exact result

theorem outside (block offset : Nat) (separate : block≠31 ∨ offset<6776 ∨ 19064≤offset) :
    after.heap.bytes block offset=before.heap.bytes block offset :=
  copy.2.2.2.2.2.2.2.2.2.2.2 block offset separate

theorem continue_body (out : C99ProcedureReference.Result)
    (rest : Exec MakeFgTopShape177.remaining after out) :
    Exec KeygenMakeFgTop.code SelectedMakeFgTopEntry176.entry out :=
  SelectedTopLayout177.continue_body out (.seqNormal _ _ before after out source rest)

end FT1536.Source3.SelectedTopMove177
