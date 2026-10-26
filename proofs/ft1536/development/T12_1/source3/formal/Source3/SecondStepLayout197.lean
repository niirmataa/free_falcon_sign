import Source3.SecondStepLengths197

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepLayout197
open C99ArrayReference (State bindPointer)
open KeygenMakeFgSource (Exec)
open KeygenSmallOutput (element)
open StepPrefixProgram187 (bind product)
open FirstStepEntry187 (var)
open MakeFgDeclarations176 (array_source)

def fd := SelectedMakeFgSetup176.ft
def gd := element fd 384
def fs := element gd 384
def gs := element fs 512
def gm := element gs 512
def igm := element gm 256
def t1 := element igm 256
noncomputable abbrev before (callee : State) := SecondStepLengths197.after callee
noncomputable def withFd (callee : State) := bindPointer (before callee) "fd".toList fd
noncomputable def withGd (callee : State) := bindPointer (withFd callee) "gd".toList gd
noncomputable def withFs (callee : State) := bindPointer (withGd callee) "fs".toList fs
noncomputable def withGs (callee : State) := bindPointer (withFs callee) "gs".toList gs
noncomputable def withGm (callee : State) := bindPointer (withGs callee) "gm".toList gm
noncomputable def withIgm (callee : State) := bindPointer (withGm callee) "igm".toList igm
noncomputable def after (callee : State) := bindPointer (withIgm callee) "t1".toList t1

theorem output_stride (s : State) (hc : KeygenNttLoopSupport.USlot s "hn" 128)
    (tc : KeygenNttLoopSupport.USlot s "tlen" 3) :
    C99ArrayReference.scalar s (product "hn" "tlen") (.uint64 384) :=
  .arithmetic .times _ _ _ _ _ (.variable _ _ _ hc) (.variable _ _ _ tc)
    (.step .times (.uint64 128) (.uint64 3) .uint64 rfl (.uint64 128) (.uint64 3) rfl rfl
      (by intro impossible; cases impossible))

theorem input_stride (s : State) (nc : KeygenNttLoopSupport.USlot s "n" 256)
    (sc : KeygenNttLoopSupport.USlot s "slen" 2) :
    C99ArrayReference.scalar s (product "n" "slen") (.uint64 512) :=
  .arithmetic .times _ _ _ _ _ (.variable _ _ _ nc) (.variable _ _ _ sc)
    (.step .times (.uint64 256) (.uint64 2) .uint64 rfl (.uint64 256) (.uint64 2) rfl rfl
      (by intro impossible; cases impossible))

theorem pointers (callee : State) : MakeFgSequence187.Run StepPrefixProgram187.pointers
    (before callee) (after callee) := by
  have f : Exec (bind "fd" "data" C99ProcedureParser.zero) (before callee) ⟨withFd callee,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ fd (RootBinding175.zero _ "data" fd rfl (by decide)))
  have g : Exec (bind "gd" "fd" (product "hn" "tlen")) (withFd callee) ⟨withGd callee,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gd (.add _ _ fd gd (.uint64 384) rfl
      (output_stride _ rfl rfl) (by decide) (.within fd 384 (by decide))))
  have fsrc : Exec (bind "fs" "gd" (product "hn" "tlen")) (withGd callee) ⟨withFs callee,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ fs (.add _ _ gd fs (.uint64 384) rfl
      (output_stride _ rfl rfl) (by decide) (.within gd 384 (by decide))))
  have gsrc : Exec (bind "gs" "fs" (product "n" "slen")) (withFs callee) ⟨withGs callee,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gs (.add _ _ fs gs (.uint64 512) rfl
      (input_stride _ rfl rfl) (by decide) (.within fs 512 (by decide))))
  have forward : Exec (bind "gm" "gs" (product "n" "slen")) (withGs callee) ⟨withGm callee,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gm (.add _ _ gs gm (.uint64 512) rfl
      (input_stride _ rfl rfl) (by decide) (.within gs 512 (by decide))))
  have inverse : Exec (bind "igm" "gm" (var "n")) (withGm callee) ⟨withIgm callee,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ igm (.add _ _ gm igm (.uint64 256) rfl
      (.variable _ _ _ rfl) (by decide) (.within gm 256 (by decide))))
  have work : Exec (bind "t1" "igm" (var "n")) (withIgm callee) ⟨after callee,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ t1 (.add _ _ igm t1 (.uint64 256) rfl
      (.variable _ _ _ rfl) (by decide) (.within igm 256 (by decide))))
  exact .cons _ _ _ _ _ f (.cons _ _ _ _ _ g (.cons _ _ _ _ _ fsrc (.cons _ _ _ _ _ gsrc
    (.cons _ _ _ _ _ forward (.cons _ _ _ _ _ inverse (.cons _ _ _ _ _ work (.nil _)))))))

theorem heap (callee : State) : (after callee).heap=callee.heap := by
  dsimp only [after,withIgm,withGm,withGs,withFs,withGd,withFd,bindPointer]
  exact SecondStepLengths197.heap callee
theorem fd_shape : fd=⟨31,0,71680,4,670⟩ := rfl
theorem gd_shape : gd=⟨31,0,71680,4,1054⟩ := rfl
theorem fs_shape : fs=⟨31,0,71680,4,1438⟩ := rfl
theorem gs_shape : gs=⟨31,0,71680,4,1950⟩ := rfl
theorem gm_shape : gm=⟨31,0,71680,4,2462⟩ := rfl
theorem igm_shape : igm=⟨31,0,71680,4,2718⟩ := rfl
theorem t1_shape : t1=⟨31,0,71680,4,2974⟩ := rfl
end FT1536.Source3.SecondStepLayout197
