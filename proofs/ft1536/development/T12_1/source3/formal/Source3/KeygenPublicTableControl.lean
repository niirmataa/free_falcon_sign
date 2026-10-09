import Source3.KeygenPublicTableRows

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Structural frames for the actual public-table language. The permitted
   statements cannot change pointer bindings; store values remain unrestricted. -/
namespace FT1536.Source3.KeygenPublicTableControl
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open KeygenPublicExec (Stmt Exec)

def writes : Stmt → List Name
  | .scalar (.declare _ ns) => ns
  | .scalar (.assign n _) | .scalar (.update n _ _) | .assign n _ => [n]
  | .seq a b | .branch _ a b | .loop _ a b => writes a++writes b
  | .scope _ _ b => writes b
  | _ => []
def supported : Stmt → Bool
  | .skip | .scalar (.declare _ _) | .scalar (.assign _ _) | .scalar (.update _ _ _)
  | .assign _ _ | .store _ _ _ _ => true
  | .seq a b | .branch _ a b | .loop _ a b => supported a && supported b
  | .scope _ [] b => supported b
  | _ => false
def Frame (code : Stmt) (before : State) (out : Result) : Prop :=
  out.flow=.normal ∧ out.state.arrays=before.arrays ∧
    ∀ n, n∉writes code → out.state.locals n=before.locals n

theorem declare_frame (ty : C99IntegerReference.Ty) (ns : List Name)
    (env : C99ScalarReference.Env) (n : Name) (outside : n∉ns) :
    C99DeclarationCells.declareCells ty ns env n=env n := by
  induction ns generalizing env with
  | nil => rfl
  | cons name rest ih =>
      have distinct : n≠name := fun h => outside (by simp [h])
      rw [C99DeclarationCells.declareCells,ih _ (fun h => outside (by simp [h]))]
      simp only [C99ScalarReference.set,distinct,ite_false]

theorem frame (program : KeygenPublicExec.Program) (signed : List Name)
    (code : Stmt) (s : State) (out : Result) (ok : supported code=true)
    (source : Exec program signed code s out) : Frame code s out := by
  induction source with
  | skip => exact ⟨rfl,rfl,fun _ _ => rfl⟩
  | scalar code before env execution =>
      cases code with
      | declare ty ns =>
          have equal := C99ScalarReference.Result.normal.inj
            (C99DeclarationCells.complete _ _ ns before.locals (.normal env) execution)
          subst env
          exact ⟨rfl,rfl,declare_frame _ _ _⟩
      | assign name rhs =>
          cases execution
          refine ⟨rfl,rfl,?_⟩
          intro n hn
          simp only [writes,List.mem_singleton] at hn
          simp only [C99ScalarReference.set,hn,ite_false]
      | update name op rhs =>
          cases execution
          refine ⟨rfl,rfl,?_⟩
          intro n hn
          simp only [writes,List.mem_singleton] at hn
          simp only [C99ScalarReference.set,hn,ite_false]
      | ret => cases ok
  | assign name e before ty old v declared evaluated =>
      refine ⟨rfl,rfl,?_⟩
      intro n hn
      simp only [writes,List.mem_singleton] at hn
      simp only [C99ArrayReference.bindValue,C99ScalarReference.set,hn,ite_false]
  | store => exact ⟨rfl,rfl,fun _ _ => rfl⟩
  | seqNormal a b before middle result first second ih1 ih2 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp ok
      obtain ⟨_,pa,la⟩ := ih1 ha
      obtain ⟨flow,pb,lb⟩ := ih2 hb
      refine ⟨flow,pb.trans pa,?_⟩
      intro n hn
      have keep : n∉writes a ∧ n∉writes b := by simpa only [writes,List.mem_append,not_or] using hn
      exact (lb n keep.2).trans (la n keep.1)
  | seqExit _ _ _ _ first exit ih => exact (exit (ih (Bool.and_eq_true_iff.mp ok).1).1).elim
  | scope names pointers body before result inner ih =>
      cases pointers with
      | nil =>
          obtain ⟨flow,arrays,locals⟩ := ih ok
          refine ⟨flow,arrays,?_⟩
          intro n hn
          change (if names.contains n then before.locals n else result.state.locals n)=before.locals n
          split_ifs
          · rfl
          · exact locals n hn
      | cons => cases ok
  | branchTrue _ _ _ _ _ _ _ _ _ ih =>
      obtain ⟨flow,arrays,locals⟩ := ih (Bool.and_eq_true_iff.mp ok).1
      exact ⟨flow,arrays,fun n hn => locals n (fun h => hn (List.mem_append_left _ h))⟩
  | branchFalse _ _ _ _ _ _ _ _ _ ih =>
      obtain ⟨flow,arrays,locals⟩ := ih (Bool.and_eq_true_iff.mp ok).2
      exact ⟨flow,arrays,fun n hn => locals n (fun h => hn (List.mem_append_right _ h))⟩
  | loopFalse => exact ⟨rfl,rfl,fun _ _ => rfl⟩
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      obtain ⟨hb,hi⟩ := Bool.and_eq_true_iff.mp ok
      obtain ⟨_,pa,la⟩ := ih1 hb
      obtain ⟨_,pb,lb⟩ := ih2 hi
      obtain ⟨flow,pc,lc⟩ := ih3 ok
      refine ⟨flow,pc.trans (pb.trans pa),?_⟩
      intro n hn
      have keep : n∉writes body ∧ n∉writes increment := by simpa only [writes,List.mem_append,not_or] using hn
      exact (lc n hn).trans ((lb n keep.2).trans (la n keep.1))
  | loopReturn _ _ _ _ _ _ _ _ _ _ ih =>
      have impossible := (ih (Bool.and_eq_true_iff.mp ok).1).1
      cases impossible
  | declarePointer | pointer | call | arrayScope | ret | retVoid => cases ok

theorem seq_inv (a b : Stmt) (s : State) (out : Result) (ok : supported a=true)
    (source : Exec KeygenPublicSource.program [] (.seq a b) s out) :
    ∃ middle, Exec KeygenPublicSource.program [] a s ⟨middle,.normal⟩ ∧
      Exec KeygenPublicSource.program [] b middle out := by
  cases source with
  | seqNormal _ _ _ middle _ first second => exact ⟨middle,first,second⟩
  | seqExit _ _ _ _ first exit => exact (exit (frame _ _ a s out ok first).1).elim

theorem assign_heap (name : Name) (e : KeygenWordExpr.Expr) (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program [] (.assign name e) s out) : out.state.heap=s.heap := by
  cases source
  rfl

end FT1536.Source3.KeygenPublicTableControl
