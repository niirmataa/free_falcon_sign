import Source3.KeygenPublicTripleExpr

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Straight-line value bookkeeping for the actual triple assignments.
   Every extension consumes an Exec assignment and an independently proved
   expression value; this is not an assumed symbolic execution result. -/
namespace FT1536.Source3.KeygenPublicValueLists
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R)
open KeygenPublicValueExpr (Local Evaluates)

def Typed (s : State) (names : List String) : Prop :=
  ∀ name∈names, ∃ old, s.locals name.toList=some (.uint32,old)
def Known (s : State) (values : List (String×R)) : Prop :=
  ∀ entry∈values, Local s entry.1 entry.2

theorem keep (s : State) (out : Result) (code : Stmt) (values : List (String×R))
    (ok : KeygenPublicTableControl.supported code=true)
    (outside : ∀ entry∈values, entry.1.toList∉KeygenPublicTableControl.writes code)
    (known : Known s values) (source : Exec KeygenPublicSource.program [] code s out) : Known out.state values := by
  intro entry member
  exact KeygenPublicValueExpr.local_after code s out entry.1 entry.2 ok (outside entry member) (known entry member) source

theorem assignment (s : State) (out : Result) (names : List String) (values : List (String×R))
    (name : String) (e : KeygenWordExpr.Expr) (z : R) (typed : Typed s names) (member : name∈names)
    (outside : ∀ entry∈values, entry.1.toList≠name.toList)
    (known : Known s values) (value : Evaluates s e z)
    (source : Exec KeygenPublicSource.program [] (.assign name.toList e) s out) :
    Typed out.state names ∧ Known out.state ((name,z)::values) ∧ out.state.heap=s.heap := by
  have result := KeygenPublicValueExpr.assign_value s out name e z (typed name member) value source
  have f := KeygenPublicTableControl.frame _ [] (.assign name.toList e) s out rfl source
  refine ⟨?_,?_,KeygenPublicTableControl.assign_heap _ _ _ _ source⟩
  · intro other hm
    by_cases eq : other.toList=name.toList
    · obtain ⟨w,slot,_,_⟩ := result
      exact ⟨some (.uint32 w),by rw [eq]; exact slot⟩
    · rw [f.2.2 _ (by simpa only [KeygenPublicTableControl.writes,List.mem_singleton] using eq)]
      exact typed other hm
  · intro entry he
    rcases List.mem_cons.mp he with eq | rest
    · subst entry; exact result
    · exact KeygenPublicValueExpr.local_after _ s out entry.1 entry.2 rfl
        (by simpa only [KeygenPublicTableControl.writes,List.mem_singleton] using outside entry rest)
        (known entry rest) source

end FT1536.Source3.KeygenPublicValueLists
