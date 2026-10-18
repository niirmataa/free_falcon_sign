import Source3.MakeFgSequence187

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedStepLayout187
open C99ArrayReference (State bindPointer)
open KeygenMakeFgSource (Exec)
open KeygenSmallOutput (element)
open StepPrefixProgram187 (bind product)
open FirstStepEntry187 (var)
open MakeFgDeclarations176 (array_source)

def fd := SelectedMakeFgSetup176.ft
def gd := element fd 512
def fs := element gd 512
def gs := element fs 512
def gm := element gs 512
def igm := element gm 512
def t1 := element igm 512
noncomputable abbrev before := SelectedStepLengths187.after
noncomputable def withFd := bindPointer before "fd".toList fd
noncomputable def withGd := bindPointer withFd "gd".toList gd
noncomputable def withFs := bindPointer withGd "fs".toList fs
noncomputable def withGs := bindPointer withFs "gs".toList gs
noncomputable def withGm := bindPointer withGs "gm".toList gm
noncomputable def withIgm := bindPointer withGm "igm".toList igm
noncomputable def after := bindPointer withIgm "t1".toList t1

theorem output_stride (s : State) (hc : KeygenNttLoopSupport.USlot s "hn" 256) (tc : KeygenNttLoopSupport.USlot s "tlen" 2) :
    C99ArrayReference.scalar s (product "hn" "tlen") (.uint64 512) :=
  .arithmetic .times _ _ _ _ _ (.variable _ _ _ hc) (.variable _ _ _ tc)
    (.step .times (.uint64 256) (.uint64 2) .uint64 rfl (.uint64 256) (.uint64 2) rfl rfl (by intro impossible; cases impossible))

theorem input_stride (s : State) (nc : KeygenNttLoopSupport.USlot s "n" 512) (sc : KeygenNttLoopSupport.USlot s "slen" 1) :
    C99ArrayReference.scalar s (product "n" "slen") (.uint64 512) :=
  .arithmetic .times _ _ _ _ _ (.variable _ _ _ nc) (.variable _ _ _ sc)
    (.step .times (.uint64 512) (.uint64 1) .uint64 rfl (.uint64 512) (.uint64 1) rfl rfl (by intro impossible; cases impossible))

theorem pointers : MakeFgSequence187.Run StepPrefixProgram187.pointers before after := by
  have f : Exec (bind "fd" "data" C99ProcedureParser.zero) before ⟨withFd,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ fd (RootBinding175.zero before "data" fd rfl (by decide)))
  have g : Exec (bind "gd" "fd" (product "hn" "tlen")) withFd ⟨withGd,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gd (.add _ _ fd gd (.uint64 512) rfl
      (output_stride withFd rfl rfl) (by decide) (.within fd 512 (by decide))))
  have fsrc : Exec (bind "fs" "gd" (product "hn" "tlen")) withGd ⟨withFs,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ fs (.add _ _ gd fs (.uint64 512) rfl
      (output_stride withGd rfl rfl) (by decide) (.within gd 512 (by decide))))
  have gsrc : Exec (bind "gs" "fs" (product "n" "slen")) withFs ⟨withGs,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gs (.add _ _ fs gs (.uint64 512) rfl
      (input_stride withFs rfl rfl) (by decide) (.within fs 512 (by decide))))
  have forward : Exec (bind "gm" "gs" (product "n" "slen")) withGs ⟨withGm,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gm (.add _ _ gs gm (.uint64 512) rfl
      (input_stride withGs rfl rfl) (by decide) (.within gs 512 (by decide))))
  have inverse : Exec (bind "igm" "gm" (var "n")) withGm ⟨withIgm,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ igm (.add _ _ gm igm (.uint64 512) rfl
      (.variable _ _ _ rfl) (by decide) (.within gm 512 (by decide))))
  have work : Exec (bind "t1" "igm" (var "n")) withIgm ⟨after,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ t1 (.add _ _ igm t1 (.uint64 512) rfl
      (.variable _ _ _ rfl) (by decide) (.within igm 512 (by decide))))
  exact .cons _ _ _ _ _ f (.cons _ _ _ _ _ g (.cons _ _ _ _ _ fsrc (.cons _ _ _ _ _ gsrc
    (.cons _ _ _ _ _ forward (.cons _ _ _ _ _ inverse (.cons _ _ _ _ _ work (.nil after)))))))

theorem heap : after.heap=FirstStepEntry187.entry.heap := by
  dsimp only [after,withIgm,withGm,withGs,withFs,withGd,withFd,bindPointer]
  exact SelectedStepLengths187.heap
theorem fd_shape : fd=⟨31,0,71680,4,670⟩ := rfl
theorem gd_shape : gd=⟨31,0,71680,4,1182⟩ := rfl
theorem fs_shape : fs=⟨31,0,71680,4,1694⟩ := rfl
theorem gs_shape : gs=⟨31,0,71680,4,2206⟩ := rfl
theorem gm_shape : gm=⟨31,0,71680,4,2718⟩ := rfl
theorem igm_shape : igm=⟨31,0,71680,4,3230⟩ := rfl
theorem t1_shape : t1=⟨31,0,71680,4,3742⟩ := rfl

end FT1536.Source3.SelectedStepLayout187
