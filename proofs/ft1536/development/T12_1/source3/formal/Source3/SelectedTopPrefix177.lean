import Source3.SelectedTopMove177

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTopPrefix177
open KeygenLevelExec (Exec)
open LevelSequence177 (append)
open MakeFgTopShape177 (declarationSteps sizeSteps pointerSteps move)
open SelectedTopLayout177 (before sized)
open SelectedTopMove177 (after)
open SelectedMakeFgTopEntry176 (entry)

def code := append declarationSteps (append sizeSteps (append pointerSteps (.seq move KeygenLevelExec.skip)))

theorem source : Exec code entry ⟨after,.normal⟩ :=
  LevelSequence177.source declarationSteps entry before (MakeFgTopDeclarations177.source entry) _ _
    (LevelSequence177.source sizeSteps before sized SelectedTopLayout177.sizes _ _
      (LevelSequence177.source pointerSteps sized SelectedTopLayout177.after SelectedTopLayout177.pointers _ _
        (.seqNormal _ _ SelectedTopMove177.before after ⟨after,.normal⟩ SelectedTopMove177.source
          (.modular _ _ _ (.base _ _ _ (.skip after))))))

theorem overlap : SelectedTopLayout177.fs.block=SelectedTopLayout177.fd.block ∧
    SelectedTopLayout177.fd.offset<SelectedTopLayout177.fs.offset ∧
    SelectedTopLayout177.fs.offset<SelectedTopLayout177.fd.offset+12288 := by decide

theorem output_cell : after.locals "out_ntt".toList=some (.int32,some (.int32 1)) := rfl
theorem logn_cell : after.locals "logn".toList=some (.uint32,some (.uint32 10)) := rfl
theorem n_cell : after.locals "n".toList=some (.uint64,some (.uint64 1536)) := rfl
theorem dn_cell : after.locals "dn".toList=some (.uint64,some (.uint64 1024)) := rfl
theorem tn_cell : after.locals "tn".toList=some (.uint64,some (.uint64 512)) := rfl

end FT1536.Source3.SelectedTopPrefix177
