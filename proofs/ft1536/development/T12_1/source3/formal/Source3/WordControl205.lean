import Source3.CrtState205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.WordControl205
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open KeygenWordExec (Stmt Exec)

def writes : Stmt → List Name
  | .modular code => KeygenMkgm3Control.writes code
  | .assign name _ => [name]
  | .store _ _ _ | .ret _ => []
  | .seq a b | .branch _ a b | .loop _ a b => writes a++writes b
  | .scope names body => names++writes body

def supported : Stmt → Bool
  | .modular code => KeygenMkgm3Control.supported code
  | .assign _ _ | .store _ _ _ | .ret _ => true
  | .seq a b | .branch _ a b | .loop _ a b => supported a && supported b
  | .scope _ body => supported body

theorem left_out (name : Name) (a b : List Name) (absent : name∉a++b) : name∉a :=
  fun member => absent (List.mem_append_left _ member)
theorem right_out (name : Name) (a b : List Name) (absent : name∉a++b) : name∉b :=
  fun member => absent (List.mem_append_right _ member)

theorem restored (before out : State) (names : List Name) (name : Name) (absent : name∉names) :
    (C99ArrayReference.restoreScope before out names []).locals name=out.locals name := by
  simp only [C99ArrayReference.restoreScope,C99ScalarReference.restore,List.contains_iff_mem,absent,ite_false]

theorem frame (code : Stmt) (before : State) (out : Result) (checked : supported code=true)
    (source : Exec code before out) : out.state.arrays=before.arrays ∧
      ∀ name, name∉writes code → out.state.locals name=before.locals name := by
  induction source with
  | modular code before out source =>
    have keep:=KeygenMkgm3Control.frame _ _ _ checked source
    exact ⟨keep.2.1,keep.2.2⟩
  | assign name e before ty old value declared source =>
    refine ⟨rfl,?_⟩
    intro other absent
    have different : other≠name := by simpa only [writes,List.mem_singleton] using absent
    exact SelectedStepAddPrime195.locals_keep before name ty value other different
  | store | ret | loopFalse => exact ⟨rfl,fun _ _ => rfl⟩
  | seqNormal a b before middle out head tail ih1 ih2 =>
    obtain ⟨c1,c2⟩:=Bool.and_eq_true_iff.mp checked
    have f1:=ih1 c1; have f2:=ih2 c2
    exact ⟨f2.1.trans f1.1,fun name absent =>
      (f2.2 name (right_out _ _ _ absent)).trans (f1.2 name (left_out _ _ _ absent))⟩
  | seqExit a b before out head exit ih =>
    have f:=ih (Bool.and_eq_true_iff.mp checked).1
    exact ⟨f.1,fun name absent => f.2 name (left_out _ _ _ absent)⟩
  | scope names body before out inner ih =>
    have f:=ih checked
    exact ⟨f.1,fun name absent =>
      (restored before out.state names name (left_out _ _ _ absent)).trans (f.2 name (right_out _ _ _ absent))⟩
  | branchTrue condition yes no before out value guard nonzero body ih =>
    have f:=ih (Bool.and_eq_true_iff.mp checked).1
    exact ⟨f.1,fun name absent => f.2 name (left_out _ _ _ absent)⟩
  | branchFalse condition yes no before out value guard zero body ih =>
    have f:=ih (Bool.and_eq_true_iff.mp checked).2
    exact ⟨f.1,fun name absent => f.2 name (right_out _ _ _ absent)⟩
  | loopNormal condition body increment before middle next out value guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨c1,c2⟩:=Bool.and_eq_true_iff.mp checked
    have f1:=ih1 c1; have f2:=ih2 c2; have f3:=ih3 checked
    exact ⟨f3.1.trans (f2.1.trans f1.1),fun name absent =>
      (f3.2 name absent).trans ((f2.2 name (right_out _ _ _ absent)).trans (f1.2 name (left_out _ _ _ absent)))⟩
  | loopReturn condition body increment before after value returned guard nonzero iteration ih =>
    have f:=ih (Bool.and_eq_true_iff.mp checked).1
    exact ⟨f.1,fun name absent => f.2 name (left_out _ _ _ absent)⟩

end FT1536.Source3.WordControl205
