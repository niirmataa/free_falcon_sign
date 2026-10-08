import Source3.KeygenRootValidation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete active M0 solve_NTRU composition, including rejection exits.
   The incoming small material is still an explicit local boundary; its
   arrival from the enclosing attempt is a separate source obligation. -/
namespace FT1536.Source3.KeygenRootSource
open C99ArrayReference (State Param Arg)
open C99MemoryReference
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenSearchContext (Context)

inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | searchRejected (out : Result) (search : KeygenRootSearch.Exec ctx before out)
      (rejected : out.flow=.returned (some (.int32 0))) : Exec ctx before out
  | outputRejected (searched : State) (out : Result)
      (search : KeygenRootSearch.Exec ctx before ⟨searched,.normal⟩)
      (gate : KeygenDepth0Call.MemberGate ctx searched out)
      (rejected : out.flow=.returned (some (.int32 0))) : Exec ctx before out
  | validated (searched passed : State) (out : Result)
      (search : KeygenRootSearch.Exec ctx before ⟨searched,.normal⟩)
      (gate : KeygenDepth0Call.MemberGate ctx searched ⟨passed,.normal⟩)
      (validation : KeygenRootValidationSource.Exec ctx passed out) : Exec ctx before out

structure Entry (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer) : Prop where
  profile : KeygenSearchContext.M0 s.heap ctx
  inputs : ∀ slot, s.arrays (KeygenResidueTrace.names slot).2.toList=some (input slot)
  table : s.arrays "PRIMES3".toList=some primes
  primeObject : KeygenStaticTables.PrimeObject s.heap primes .ternary
  revBinding : s.tables "REV10".toList=some rev
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  legal : KeygenMkgm3Layout.Legal s.heap ctx.scratch
  width : ∀ slot, (input slot).elementBytes=2
  separate : ∀ slot, KeygenMkgm3Layout.DisjointBytes (input slot) 3072 ctx.scratch (KeygenMkgm3Frame.objectBytes ctx.scratch)
  disjoint : ∀ a b : Fin 4, a≠b → KeygenMkgm3Layout.DisjointBytes (input a) 3072 (input b) 3072
  contextProtected : KeygenRootSearch.Protected ctx s ctx.object.block
  fProtected : KeygenRootSearch.Protected ctx s (input 0).block
  gProtected : KeygenRootSearch.Protected ctx s (input 1).block

theorem suffix_entry (ctx : Context) (before searched passed : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (entry : Entry ctx before input primes rev) (search : KeygenRootSearch.Exec ctx before ⟨searched,.normal⟩)
    (view : KeygenOutputGateSource.Context) (gate : KeygenOutputGateSource.Exec view searched ⟨passed,.normal⟩) :
    KeygenRootValidation.Entry ctx passed input primes rev := by
  have first := KeygenSearchStability.root ctx before _ search
  have last := KeygenRootObjects.gate view searched _ gate
  have stable := KeygenMemoryStability.trans _ _ _ first last
  obtain ⟨hl,ha,ht,_⟩ := KeygenRootSearch.frame ctx before _ search entry.profile ctx.object.block entry.contextProtected
  obtain ⟨gl,ga,gt⟩ := KeygenRootObjects.gate_slots view searched _ gate rfl
  change searched.locals=(KeygenRootSearch.ready before).locals at hl
  change searched.arrays=(KeygenRootSearch.ready before).arrays at ha
  change searched.tables=before.tables at ht
  change passed.locals=searched.locals at gl
  change passed.arrays=searched.arrays at ga
  change passed.tables=searched.tables at gt
  refine ⟨(congrFun (gl.trans hl) _).trans rfl,(congrFun (gl.trans hl) _).trans rfl,
    (congrFun (gl.trans hl) _).trans rfl,(congrFun (gl.trans hl) _).trans rfl,?_,
    (congrFun (ga.trans ha) _).trans entry.table,
    KeygenRootObjects.prime _ _ _ _ entry.primeObject stable,(congrFun (gt.trans ht) _).trans entry.revBinding,
    KeygenRootObjects.rev_table _ _ _ entry.revSource stable,KeygenRootObjects.scratch _ _ _ entry.legal stable,
    entry.width,entry.separate⟩
  intro slot
  rw [ga,ha]
  fin_cases slot <;> exact entry.inputs _

theorem success (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (entry : Entry ctx before input primes rev) (source : Exec ctx before out)
    (returned : out.flow=.returned (some (.int32 1)))
    (f g : Geometry.Vec) (fRepr : KeygenMaterial.Represents before.heap (input 0) f)
    (gRepr : KeygenMaterial.Represents before.heap (input 1) g)
    (fBound : KeygenIntegerLift.Bound f 1) (gBound : KeygenIntegerLift.Bound g 1) :
    ∃ F G : Geometry.Vec, KeygenSolverEquation.Bounds (KeygenOutputGateValidation.material f g F G) ∧
      KeygenSolverEquation.Equation (KeygenOutputGateValidation.material f g F G) ∧
      ∀ slot, KeygenMaterial.Represents out.state.heap (input slot) (KeygenOutputGateValidation.material f g F G slot) := by
  cases source with
  | searchRejected out search rejected | outputRejected searched out search gate rejected =>
    rw [rejected] at returned
    cases returned
  | validated searched passed out search gate validation =>
    obtain ⟨ternary,tmp,member,tmpMember,gate⟩ := gate
    have hp := KeygenRootObjects.search_profile ctx before _ search entry.profile entry.contextProtected
    have ht := KeygenSearchContext.ternary_m0 ctx searched ternary hp member
    have hs := KeygenSearchContext.tmp_value ctx searched tmp tmpMember
    subst ternary tmp
    let view : KeygenOutputGateSource.Context := ⟨1,ctx.scratch⟩
    have bound := suffix_entry ctx before searched passed input primes rev entry search view gate
    obtain ⟨v,heap,result⟩ := KeygenRootValidation.validation ctx passed out input primes rev bound validation returned
    have caller := KeygenRootSearch.output_caller ctx before _ search entry.profile (input 2) (input 3)
      (entry.inputs 2) (entry.inputs 3) ctx.object.block entry.contextProtected
    have fr := KeygenRootSearch.material ctx before _ search entry.profile (input 0) entry.fProtected f fRepr
    have gr := KeygenRootSearch.material ctx before _ search entry.profile (input 1) entry.gProtected g gRepr
    have conclusion := KeygenOutputGateValidation.gate_validated view searched ⟨passed,.normal⟩
      (KeygenRootValidation.arrays input ctx.scratch) rfl caller entry.disjoint f g fr gr fBound gBound gate rfl v heap
    rw [result] at conclusion
    exact conclusion

def params : List Param := ["fk","F","G","f","g"].map (fun n => .pointer n.toList)
def arguments : List Arg := ["fk","F","G","f","g"].map (fun n => .pointer n.toList C99ProcedureParser.zero)
inductive Call (ctx : Context) (before : State) : State → Value → Prop where
  | run (entry : State) (out : Result) (v : Value)
      (binding : C99ArrayReference.Bind before params arguments entry) (source : Exec ctx entry out)
      (returned : C99ProcedureReference.ReturnValue (some .int32) out.flow (some v)) :
      Call ctx before {before with heap := out.state.heap} v
theorem slots (ctx : Context) (before after : State) (v : Value) (source : Call ctx before after v) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
  cases source
  exact ⟨rfl,rfl,rfl⟩

end FT1536.Source3.KeygenRootSource
