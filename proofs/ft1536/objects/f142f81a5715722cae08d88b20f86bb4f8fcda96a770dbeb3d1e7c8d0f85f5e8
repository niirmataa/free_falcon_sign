import Source3.KeygenCallerInit

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The specialized initialization constructor executes the checked parser
   result in the inherited operational language, including declarations.
   It does not obtain its heap or alias effects from an assumed frame. -/
namespace FT1536.Source3.KeygenCallerInitExecution
open C99ArrayReference (State Name bindPointer)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenSearchExec (Stmt Exec chain)

def declare (s : State) (name : Name) : State :=
  {s with arrays := fun n => if n=name then none else s.arrays n}
def cleared (s : State) : State := declare (declare (declare s "rt1".toList) "rt2".toList) "rt3".toList
def declarationCode : Stmt := chain (KeygenCallerInit.rtNames.map (fun name => .procedure (.base (.declarePtr name))))
theorem cleared_exact (s : State) : cleared s={s with arrays := fun name => if KeygenCallerInit.rtNames.contains name then none else s.arrays name} := by
  cases s
  unfold cleared declare
  congr 1
  funext name
  by_cases a : name="rt1".toList
  · subst name; rfl
  by_cases b : name="rt2".toList
  · subst name; rfl
  by_cases c : name="rt3".toList
  · subst name; rfl
  have outside : name∉KeygenCallerInit.rtNames := by
    intro member
    simp only [KeygenCallerInit.rtNames,List.mem_cons,List.not_mem_nil,or_false] at member
    rcases member with h | h | h
    · exact a h
    · exact b h
    · exact c h
  have absent : KeygenCallerInit.rtNames.contains name=false := by
    cases h : KeygenCallerInit.rtNames.contains name with
    | false => rfl
    | true => exact (outside (List.contains_iff_mem.mp h)).elim
  simp only [a,b,c,absent,Bool.false_eq_true,ite_false]
theorem skip_execution (ctx : Context) (s : State) : Exec ctx KeygenSearchExec.skip s ⟨s,.normal⟩ :=
  .procedure _ _ _ (.base _ _ _ (.skip _))
theorem declare_execution (ctx : Context) (s : State) (name : Name) :
    Exec ctx (.procedure (.base (.declarePtr name))) s ⟨declare s name,.normal⟩ :=
  .procedure _ _ _ (.base _ _ _ (.declarePtr _ _))
theorem declarations_execution (ctx : Context) (s : State) : Exec ctx declarationCode s ⟨cleared s,.normal⟩ := by
  exact .seqNormal _ _ _ _ _ (declare_execution ctx s "rt1".toList)
    (.seqNormal _ _ _ _ _ (declare_execution ctx _ "rt2".toList)
      (.seqNormal _ _ _ _ _ (declare_execution ctx _ "rt3".toList) (skip_execution ctx _)))
theorem scalars_execution (ctx : Context) (s : State) :
    Exec ctx (.procedure (.base (.scalar (.declare .u64 ["norm".toList,"bound".toList])))) s
      ⟨C99DeclarationStatements.effect .u64 ["norm".toList,"bound".toList] s,.normal⟩ :=
  .procedure _ _ _ (.base _ _ _ (C99DeclarationStatements.source_exists _ _ _ s))
theorem setup_execution (ctx : Context) (before after : State) (source : KeygenCallerInit.Setup ctx before after) :
    Exec ctx KeygenCallerInit.setupCode before ⟨after,.normal⟩ := by
  cases source with
  | run p q r first second third =>
    have declaration : Exec ctx declarationCode before
        ⟨{before with arrays := fun name => if KeygenCallerInit.rtNames.contains name then none else before.arrays name},.normal⟩ := by
      rw [← cleared_exact]; exact declarations_execution ctx before
    exact .seqNormal _ _ _ _ _ declaration
      (.seqNormal _ _ _ _ _ (scalars_execution ctx _)
        (.seqNormal _ _ _ _ _ (.pointer _ _ _ _ first)
          (.seqNormal _ _ _ _ _ (.pointer _ _ _ _ (.named _ _ _ second))
            (.seqNormal _ _ _ _ _ (.pointer _ _ _ _ (.named _ _ _ third)) (skip_execution ctx _)))))

end FT1536.Source3.KeygenCallerInitExecution
