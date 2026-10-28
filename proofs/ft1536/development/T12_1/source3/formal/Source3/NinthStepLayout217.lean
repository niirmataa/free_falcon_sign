import Source3.NinthStepLengths217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NinthStepLayout217
open C99ArrayReference (State bindPointer)
open KeygenMakeFgSource (Exec)
open KeygenSmallOutput (element)
open StepPrefixProgram187 (bind product)
open FirstStepEntry187 (var)
open MakeFgDeclarations176 (array_source)

def fd := SelectedMakeFgSetup176.ft
def gd := element fd 335
def fs := element gd 335
def gs := element fs 332
def gm := element gs 332
def igm := element gm 2
def t1 := element igm 2
noncomputable abbrev before (s : State) := NinthStepLengths217.after s
noncomputable def withFd (s : State) := bindPointer (before s) "fd".toList fd
noncomputable def withGd (s : State) := bindPointer (withFd s) "gd".toList gd
noncomputable def withFs (s : State) := bindPointer (withGd s) "fs".toList fs
noncomputable def withGs (s : State) := bindPointer (withFs s) "gs".toList gs
noncomputable def withGm (s : State) := bindPointer (withGs s) "gm".toList gm
noncomputable def withIgm (s : State) := bindPointer (withGm s) "igm".toList igm
noncomputable def after (s : State) := bindPointer (withIgm s) "t1".toList t1

theorem output_stride (s : State) (hc : KeygenNttLoopSupport.USlot s "hn" 1) (tc : KeygenNttLoopSupport.USlot s "tlen" 335) :
    C99ArrayReference.scalar s (product "hn" "tlen") (.uint64 335) :=
  .arithmetic .times _ _ _ _ _ (.variable _ _ _ hc) (.variable _ _ _ tc)
    (.step .times (.uint64 1) (.uint64 335) .uint64 rfl (.uint64 1) (.uint64 335) rfl rfl
      (by intro impossible; cases impossible))

theorem input_stride (s : State) (nc : KeygenNttLoopSupport.USlot s "n" 2) (sc : KeygenNttLoopSupport.USlot s "slen" 166) :
    C99ArrayReference.scalar s (product "n" "slen") (.uint64 332) :=
  .arithmetic .times _ _ _ _ _ (.variable _ _ _ nc) (.variable _ _ _ sc)
    (.step .times (.uint64 2) (.uint64 166) .uint64 rfl (.uint64 2) (.uint64 166) rfl rfl
      (by intro impossible; cases impossible))

theorem pointers (s : State) : MakeFgSequence187.Run StepPrefixProgram187.pointers
    (before s) (after s) := by
  have f : Exec (bind "fd" "data" C99ProcedureParser.zero) (before s) ⟨withFd s,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ fd (RootBinding175.zero _ "data" fd rfl (by decide)))
  have g : Exec (bind "gd" "fd" (product "hn" "tlen")) (withFd s) ⟨withGd s,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gd (.add _ _ fd gd (.uint64 335) rfl
      (output_stride _ rfl rfl) (by decide) (.within fd 335 (by decide))))
  have fsrc : Exec (bind "fs" "gd" (product "hn" "tlen")) (withGd s) ⟨withFs s,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ fs (.add _ _ gd fs (.uint64 335) rfl
      (output_stride _ rfl rfl) (by decide) (.within gd 335 (by decide))))
  have gsrc : Exec (bind "gs" "fs" (product "n" "slen")) (withFs s) ⟨withGs s,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gs (.add _ _ fs gs (.uint64 332) rfl
      (input_stride _ rfl rfl) (by decide) (.within fs 332 (by decide))))
  have forward : Exec (bind "gm" "gs" (product "n" "slen")) (withGs s) ⟨withGm s,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gm (.add _ _ gs gm (.uint64 332) rfl
      (input_stride _ rfl rfl) (by decide) (.within gs 332 (by decide))))
  have inverse : Exec (bind "igm" "gm" (var "n")) (withGm s) ⟨withIgm s,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ igm (.add _ _ gm igm (.uint64 2) rfl
      (.variable _ _ _ rfl) (by decide) (.within gm 2 (by decide))))
  have work : Exec (bind "t1" "igm" (var "n")) (withIgm s) ⟨after s,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ t1 (.add _ _ igm t1 (.uint64 2) rfl
      (.variable _ _ _ rfl) (by decide) (.within igm 2 (by decide))))
  exact .cons _ _ _ _ _ f (.cons _ _ _ _ _ g (.cons _ _ _ _ _ fsrc (.cons _ _ _ _ _ gsrc
    (.cons _ _ _ _ _ forward (.cons _ _ _ _ _ inverse (.cons _ _ _ _ _ work (.nil _)))))))

theorem heap (s : State) : (after s).heap=s.heap := by
  dsimp only [after,withIgm,withGm,withGs,withFs,withGd,withFd,bindPointer]
  exact NinthStepLengths217.heap s

theorem fd_shape : fd=⟨31,0,71680,4,670⟩ := rfl
theorem gd_shape : gd=⟨31,0,71680,4,1005⟩ := rfl
theorem fs_shape : fs=⟨31,0,71680,4,1340⟩ := rfl
theorem gs_shape : gs=⟨31,0,71680,4,1672⟩ := rfl
theorem gm_shape : gm=⟨31,0,71680,4,2004⟩ := rfl
theorem igm_shape : igm=⟨31,0,71680,4,2006⟩ := rfl
theorem t1_shape : t1=⟨31,0,71680,4,2008⟩ := rfl

end FT1536.Source3.NinthStepLayout217
