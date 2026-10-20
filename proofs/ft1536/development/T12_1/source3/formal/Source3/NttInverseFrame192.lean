import Source3.KeygenMkgm3Control

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Locals/arrays frame for the inverse-call statements, extending the
   accepted KeygenMkgm3Control frame grammar with the pointer declarations
   and pointer binds used by the prologue and the passes. Executing a
   supported statement chain changes only the declared local write names
   and the bound pointer names; every other local cell and pointer slot is
   returned exactly as it was. No heap or value property is claimed here;
   the pointer frame is stated because bindPtr/declarePtr move pointer
   slots while leaving all locals untouched. -/
namespace FT1536.Source3.NttInverseFrame192
open C99ModularReference (Stmt Exec)
open C99ArrayReference (State Name bindPointer)
open C99ProcedureReference (Result)
open KeygenMkgm3Control (writes)

def ptrWrites : Stmt → List Name
  | .base (.bindPtr name _ _) => [name]
  | .base (.declarePtr name) => [name]
  | .seq a b | .branch _ a b | .loop _ a b => ptrWrites a++ptrWrites b
  | .scope _ body => ptrWrites body
  | _ => []

def supported : Stmt → Bool
  | .base .skip | .base (.scalar (.declare _ _)) | .base (.scalar (.assign _ _))
  | .base (.scalar (.update _ _ _)) | .assign _ _ | .store32 _ _ _
  | .base (.bindPtr _ _ _) | .base (.declarePtr _) => true
  | .seq a b | .branch _ a b | .loop _ a b => supported a && supported b
  | .scope _ body => supported body
  | _ => false

theorem bindPointer_arrays (s : State) (name : Name) (p : C99MemoryReference.ArrayPointer)
    (other : Name) (different : other≠name) :
    (bindPointer s name p).arrays other=s.arrays other := by
  simp only [bindPointer,different,ite_false]

theorem declarePtr_arrays (s : State) (name other : Name) (different : other≠name) :
    ({s with arrays := fun n => if n=name then none else s.arrays n}).arrays other=s.arrays other := by
  simp only [different,ite_false]

theorem frame (code : Stmt) (before : State) (out : Result) (hs : supported code=true)
    (source : Exec code before out) :
    (∀ n : Name, n∉writes code → out.state.locals n=before.locals n) ∧
    (∀ n : Name, n∉ptrWrites code → out.state.arrays n=before.arrays n) := by
  induction source with
  | base code before after body =>
      cases code with
      | skip =>
          cases body with
          | skip s => exact ⟨fun _ _ => rfl,fun _ _ => rfl⟩
      | scalar statement =>
          cases statement with
          | declare | assign | update =>
              have kept := KeygenMkgm3Control.atom _ _ _ rfl (.base _ _ _ body)
              exact ⟨kept.2.2,fun _ _ => by rw [kept.2.1]⟩
          | ret => cases hs
      | assign | store64 | store32 | copy | seq | scope | branch | «while» | call => cases hs
      | declarePtr name =>
          cases body with
          | declarePtr before name =>
              refine ⟨fun _ _ => rfl,fun n outside => ?_⟩
              exact declarePtr_arrays before name n (fun equal => outside (by simp [ptrWrites,equal]))
      | bindPtr name source index =>
          cases body with
          | bindPtr before name source index p value =>
              refine ⟨fun _ _ => rfl,fun n outside => ?_⟩
              exact bindPointer_arrays before name p n (fun equal => outside (by simp [ptrWrites,equal]))
  | assign name e before ty old v declared value =>
      have kept := KeygenMkgm3Control.atom _ _ _ rfl (.assign _ _ _ _ _ _ declared value)
      exact ⟨kept.2.2,fun _ _ => rfl⟩
  | store32 name index e before after p v address value write =>
      exact ⟨fun _ _ => rfl,fun _ _ => rfl⟩
  | storeRev name table base index e before after p q bv w v be ta tr address value write =>
      exact ⟨fun _ _ => rfl,fun _ _ => rfl⟩
  | seqNormal first second before middle result head tail ih1 ih2 =>
      have h := Bool.and_eq_true_iff.mp hs
      obtain ⟨hl1,ha1⟩ := ih1 h.1
      obtain ⟨hl2,ha2⟩ := ih2 h.2
      refine ⟨?_,?_⟩
      · intro n outside
        have split : n∉writes first ∧ n∉writes second := by
          simpa only [writes,List.mem_append,not_or] using outside
        exact (hl2 n split.2).trans (hl1 n split.1)
      · intro n outside
        have split : n∉ptrWrites first ∧ n∉ptrWrites second := by
          simpa only [ptrWrites,List.mem_append,not_or] using outside
        exact (ha2 n split.2).trans (ha1 n split.1)
  | seqExit first second before result head exit ih =>
      obtain ⟨hl,ha⟩ := ih (Bool.and_eq_true_iff.mp hs).1
      refine ⟨?_,?_⟩
      · intro n outside
        have split : n∉writes first ∧ n∉writes second := by
          simpa only [writes,List.mem_append,not_or] using outside
        exact hl n split.1
      · intro n outside
        have split : n∉ptrWrites first ∧ n∉ptrWrites second := by
          simpa only [ptrWrites,List.mem_append,not_or] using outside
        exact ha n split.1
  | scope names body before result inner ih =>
      obtain ⟨hl,ha⟩ := ih hs
      refine ⟨?_,ha⟩
      intro n outside
      change (if names.contains n then before.locals n else result.state.locals n)=before.locals n
      split_ifs
      · rfl
      · exact hl n outside
  | branchTrue condition yes no before result v guard nonzero body ih =>
      obtain ⟨hl,ha⟩ := ih (Bool.and_eq_true_iff.mp hs).1
      exact ⟨fun n outside => hl n (fun hit => outside (List.mem_append_left _ hit)),
        fun n outside => ha n (fun hit => outside (List.mem_append_left _ hit))⟩
  | branchFalse condition yes no before result v guard zero body ih =>
      obtain ⟨hl,ha⟩ := ih (Bool.and_eq_true_iff.mp hs).2
      exact ⟨fun n outside => hl n (fun hit => outside (List.mem_append_right _ hit)),
        fun n outside => ha n (fun hit => outside (List.mem_append_right _ hit))⟩
  | loopFalse => exact ⟨fun _ _ => rfl,fun _ _ => rfl⟩
  | loopNormal condition body increment before middle next result v guard nonzero iteration update
      rest ih1 ih2 ih3 =>
      have h := Bool.and_eq_true_iff.mp hs
      obtain ⟨hl1,ha1⟩ := ih1 h.1
      obtain ⟨hl2,ha2⟩ := ih2 h.2
      obtain ⟨hl3,ha3⟩ := ih3 hs
      refine ⟨?_,?_⟩
      · intro n outside
        have split : n∉writes body ∧ n∉writes increment := by
          simpa only [writes,List.mem_append,not_or] using outside
        exact (hl3 n outside).trans ((hl2 n split.2).trans (hl1 n split.1))
      · intro n outside
        have split : n∉ptrWrites body ∧ n∉ptrWrites increment := by
          simpa only [ptrWrites,List.mem_append,not_or] using outside
        exact (ha3 n outside).trans ((ha2 n split.2).trans (ha1 n split.1))
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
      obtain ⟨hl,ha⟩ := ih (Bool.and_eq_true_iff.mp hs).1
      refine ⟨?_,?_⟩
      · intro n outside
        have split : n∉writes body ∧ n∉writes increment := by
          simpa only [writes,List.mem_append,not_or] using outside
        exact hl n split.1
      · intro n outside
        have split : n∉ptrWrites body ∧ n∉ptrWrites increment := by
          simpa only [ptrWrites,List.mem_append,not_or] using outside
        exact ha n split.1
  | ret | retVoid => cases hs

theorem locals_keep (code : Stmt) (before : State) (out : Result) (hs : supported code=true)
    (source : Exec code before out) (n : Name) (outside : n∉writes code) :
    out.state.locals n=before.locals n :=
  (frame code before out hs source).1 n outside

theorem arrays_keep (code : Stmt) (before : State) (out : Result) (hs : supported code=true)
    (source : Exec code before out) (n : Name) (outside : n∉ptrWrites code) :
    out.state.arrays n=before.arrays n :=
  (frame code before out hs source).2 n outside

end FT1536.Source3.NttInverseFrame192
