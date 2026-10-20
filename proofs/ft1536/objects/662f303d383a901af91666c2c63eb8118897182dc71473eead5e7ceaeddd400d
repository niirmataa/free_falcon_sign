import Source3.KeygenPublicForwardMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Prefix control adapters. Pointer declarations/aliases preserve scalar
   locals and the heap, but not the array map; no table image is supplied. -/
namespace FT1536.Source3.KeygenPublicForwardControl
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open KeygenPublicExec (Stmt Exec)
open KeygenPublicRangeExpr (Locals)
open KeygenPublicTableControl (writes)

def checked (locals : List Name) : Stmt → Bool
  | .skip | .scalar (.declare _ _) | .declarePointer _ | .pointer _ _ _ => true
  | .scalar (.assign n _) | .scalar (.update n _ _) | .assign n _ => !locals.contains n
  | .seq a b => checked locals a && checked locals b
  | _ => false

theorem pure_result (program : KeygenPublicExec.Program) (signed names : List Name)
    (code : Stmt) (s : State) (out : Result) (shape : checked names code=true)
    (initial : Locals names s.locals) (source : Exec program signed code s out) :
    out.flow=.normal ∧ out.state.heap=s.heap ∧ Locals names out.state.locals ∧
      ∀ n, n∉writes code → out.state.locals n=s.locals n := by
  induction source with
  | skip | declarePointer | pointer => exact ⟨rfl,rfl,initial,fun _ _ => rfl⟩
  | scalar code before env executed =>
      cases code with
      | declare ty ns =>
          have equal := C99ScalarReference.Result.normal.inj
            (C99DeclarationCells.complete KeygenPublicScalar.Call _ ns before.locals (.normal env) executed)
          subst env
          exact ⟨rfl,rfl,KeygenPublicRangeExec.locals_declare names before.locals _ ns initial,
            KeygenPublicTableControl.declare_frame _ _ _⟩
      | assign name rhs =>
          cases executed
          have outside : name∉names := by simpa [checked] using shape
          refine ⟨rfl,rfl,KeygenPublicRangeExec.locals_set _ _ _ _ _ initial
            (fun member => (outside member).elim),?_⟩
          intro n hn
          simp only [writes,List.mem_singleton] at hn
          simp only [C99ScalarReference.set,hn,ite_false]
      | update name op rhs =>
          cases executed
          have outside : name∉names := by simpa [checked] using shape
          refine ⟨rfl,rfl,KeygenPublicRangeExec.locals_set _ _ _ _ _ initial
            (fun member => (outside member).elim),?_⟩
          intro n hn
          simp only [writes,List.mem_singleton] at hn
          simp only [C99ScalarReference.set,hn,ite_false]
      | ret => cases shape
  | assign name e before ty old v declared evaluated =>
      have outside : name∉names := by simpa [checked] using shape
      refine ⟨rfl,rfl,KeygenPublicRangeExec.locals_bound _ _ _ _ _ initial
        (fun member => (outside member).elim),?_⟩
      intro n hn
      simp only [writes,List.mem_singleton] at hn
      simp only [C99ArrayReference.bindValue,C99ScalarReference.set,hn,ite_false]
  | seqNormal a b before middle out first second ih1 ih2 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp shape
      obtain ⟨_,heap1,range1,frame1⟩ := ih1 ha initial
      obtain ⟨flow,heap2,range2,frame2⟩ := ih2 hb range1
      refine ⟨flow,heap2.trans heap1,range2,?_⟩
      intro n hn
      have outside : n∉writes a ∧ n∉writes b := by simpa only [writes,List.mem_append,not_or] using hn
      exact (frame2 n outside.2).trans (frame1 n outside.1)
  | seqExit _ _ _ _ first exit ih => exact (exit (ih (Bool.and_eq_true_iff.mp shape).1 initial).1).elim
  | store | call | scope | arrayScope | branchTrue | branchFalse | loopFalse | loopNormal | loopReturn | ret | retVoid => cases shape

theorem seq_inv (program : KeygenPublicExec.Program) (a b : Stmt) (s : State) (out : Result)
    (normal : KeygenPublicTableRows.noReturn a=true)
    (source : Exec program [] (.seq a b) s out) :
    ∃ middle, Exec program [] a s ⟨middle,.normal⟩ ∧ Exec program [] b middle out := by
  cases source with
  | seqNormal _ _ _ middle _ first second => exact ⟨middle,first,second⟩
  | seqExit _ _ _ _ first exit => exact (exit (KeygenPublicTableRows.normal _ _ _ _ _ first normal)).elim

end FT1536.Source3.KeygenPublicForwardControl
