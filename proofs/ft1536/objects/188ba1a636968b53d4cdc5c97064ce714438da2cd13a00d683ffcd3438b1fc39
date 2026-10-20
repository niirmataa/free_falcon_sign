import Source3.KeygenPublicRangeExpr

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Structural range preservation for the fixed public statement language.
   Every accepted store has a source-derived residue value. This includes
   nested loops and scopes; it does not supply polynomial-evaluation facts,
   loop counts or a forward/inverse round-trip. -/
namespace FT1536.Source3.KeygenPublicRangeExec
open C99ArrayReference (State Name bindValue restoreScope)
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenPublicExec (Stmt Exec)
open KeygenPublicRangeExpr (Ranged Locals Arrays)
open KeygenPublicRangeMemory (Initialized)
open C99MemoryReference (ArrayPointer)

def checked (locals arrays : List Name) : Stmt → Bool
  | .skip | .scalar (.declare _ _) => true
  | .scalar (.assign n _) | .scalar (.update n _ _) => !locals.contains n
  | .assign n e => if locals.contains n then KeygenPublicRangeExpr.checked locals arrays e else true
  | .store _ _ _ e => KeygenPublicRangeExpr.checked locals arrays e
  | .seq a b | .branch _ a b | .loop _ a b => checked locals arrays a && checked locals arrays b
  | .scope _ [] b => checked locals arrays b
  | _ => false

structure Invariant (locals arrays : List Name) (root : ArrayPointer) (n : Nat) (s : State) : Prop where
  localRange : Locals locals s.locals
  arrayRange : Arrays arrays s
  initialized : Initialized s.heap root n

theorem locals_set (names : List Name) (env : C99ScalarReference.Env) (name : Name)
    (ty : Ty) (value : Option Value) (old : Locals names env)
    (new : name∈names → ∀ v, value=some v → Ranged v) :
    Locals names (C99ScalarReference.set env name (ty,value)) := by
  intro n member actual v binding
  by_cases equal : n=name
  · subst n
    have pair := Option.some.inj (by simpa only [C99ScalarReference.set,ite_true] using binding)
    exact new member v (congrArg Prod.snd pair)
  · exact old n member actual v (by simpa only [C99ScalarReference.set,equal,ite_false] using binding)

theorem locals_declare (names : List Name) (env : C99ScalarReference.Env) (ty : Ty)
    (declared : List Name) (old : Locals names env) :
    Locals names (C99DeclarationCells.declareCells ty declared env) := by
  induction declared generalizing env with
  | nil => exact old
  | cons name rest ih =>
      exact ih _ (locals_set names env name ty none old (fun _ _ equal => by cases equal))

theorem locals_bound (names : List Name) (s : State) (name : Name) (ty : Ty) (v : Value)
    (old : Locals names s.locals) (new : name∈names → Ranged v) :
    Locals names (bindValue s name ty v).locals := by
  apply locals_set names s.locals name ty (some (C99IntegerReference.convert ty v.integer)) old
  intro member value equal
  rw [← Option.some.inj equal]
  exact KeygenPublicRangeExpr.converted_range ty v (new member)

theorem arrays_store (names : List Name) (s : State) (after : C99MemoryReference.Memory)
    (p : ArrayPointer) (v : Value) (write : KeygenSmallOutput.Store16 s.heap p (KeygenPublicWord.narrow v) after)
    (range : Ranged v) (old : Arrays names s) : Arrays names {s with heap := after} := by
  intro name member root binding
  exact KeygenPublicRangeMemory.domain_store s.heap after p root _ write
    (KeygenPublicRangeExpr.narrowed_range v range) (old name member root binding)

theorem locals_scope (names scopeNames : List Name) (before after : State)
    (old : Locals names before.locals) (new : Locals names after.locals) :
    Locals names (restoreScope before after scopeNames []).locals := by
  intro n member ty v binding
  change (if scopeNames.contains n then before.locals n else after.locals n)=some (ty,some v) at binding
  split_ifs at binding
  · exact old n member ty v binding
  · exact new n member ty v binding

theorem body (program : KeygenPublicExec.Program) (signed locals arrays : List Name) (root : ArrayPointer) (n : Nat)
    (code : Stmt) (s : State) (out : Result) (shape : checked locals arrays code=true)
    (initial : Invariant locals arrays root n s) (source : Exec program signed code s out) (empty : signed=[]) :
    out.flow=.normal ∧ Invariant locals arrays root n out.state := by
  induction source with
  | skip => exact ⟨rfl,initial⟩
  | scalar code before env executed =>
      cases code with
      | declare ty ns =>
          have equal := C99ScalarReference.Result.normal.inj
            (C99DeclarationCells.complete KeygenPublicScalar.Call _ ns before.locals (.normal env) executed)
          subst env
          exact ⟨rfl,⟨locals_declare locals before.locals _ ns initial.localRange,
            initial.arrayRange,initial.initialized⟩⟩
      | assign name rhs =>
          cases executed
          have outside : name∉locals := by simpa [checked] using shape
          refine ⟨rfl,⟨?_,initial.arrayRange,initial.initialized⟩⟩
          exact locals_set _ _ _ _ _ initial.localRange (fun member => (outside member).elim)
      | update name op rhs =>
          cases executed
          have outside : name∉locals := by simpa [checked] using shape
          refine ⟨rfl,⟨?_,initial.arrayRange,initial.initialized⟩⟩
          exact locals_set _ _ _ _ _ initial.localRange (fun member => (outside member).elim)
      | ret => cases shape
  | assign name e before ty previous v declared evaluated =>
      rw [empty] at evaluated
      refine ⟨rfl,⟨locals_bound locals before name ty v initial.localRange ?_,initial.arrayRange,initial.initialized⟩⟩
      intro member
      have he : KeygenPublicRangeExpr.checked locals arrays e=true := by
        simpa only [checked,show locals.contains name=true from List.contains_iff_mem.mpr member,ite_true] using shape
      exact KeygenPublicRangeExpr.expression locals arrays before e v initial.localRange initial.arrayRange he evaluated
  | store name index cast e before heap p v address evaluated write =>
      rw [empty] at evaluated
      have range := KeygenPublicRangeExpr.expression locals arrays before e v initial.localRange initial.arrayRange shape evaluated
      exact ⟨rfl,⟨initial.localRange,arrays_store arrays before heap p v write range initial.arrayRange,
        KeygenPublicRangeMemory.initialized_store before.heap heap p root _ n write initial.initialized⟩⟩
  | seqNormal a b before middle out first second ih1 ih2 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp shape
      exact ih2 hb (ih1 ha initial empty).2 empty
  | seqExit a b before out first exit ih =>
      exact (exit (ih (Bool.and_eq_true_iff.mp shape).1 initial empty).1).elim
  | scope scopeNames pointers code before out execution ih =>
      cases pointers with
      | nil =>
          obtain ⟨flow,result⟩ := ih shape initial empty
          refine ⟨flow,⟨locals_scope locals scopeNames before out.state initial.localRange result.localRange,?_,result.initialized⟩⟩
          exact result.arrayRange
      | cons => cases shape
  | branchTrue condition a b before out v guard nonzero inner ih =>
      exact ih (Bool.and_eq_true_iff.mp shape).1 initial empty
  | branchFalse condition a b before out v guard zero inner ih =>
      exact ih (Bool.and_eq_true_iff.mp shape).2 initial empty
  | loopFalse => exact ⟨rfl,initial⟩
  | loopNormal condition b increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      obtain ⟨hb,hi⟩ := Bool.and_eq_true_iff.mp shape
      exact ih3 shape (ih2 hi (ih1 hb initial empty).2 empty).2 empty
  | loopReturn condition b increment before after v ret guard nonzero iteration ih =>
      have impossible := (ih (Bool.and_eq_true_iff.mp shape).1 initial empty).1
      cases impossible
  | declarePointer | pointer | call | arrayScope | ret | retVoid => cases shape

end FT1536.Source3.KeygenPublicRangeExec
