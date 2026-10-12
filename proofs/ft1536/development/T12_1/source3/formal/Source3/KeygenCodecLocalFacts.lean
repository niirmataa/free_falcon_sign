import Source3.KeygenCodecGuardedWrite

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Reachable activation facts used by the whole STATIC window fold. All
   expression effects are checked; the capacity parameter is read-only.
   The u cell may be absent/uninitialized until its source declaration
   and assignment. No cursor bound or encoded result is assumed. -/
namespace FT1536.Source3.KeygenCodecLocalFacts
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
abbrev IntegerValue := C99IntegerReference.Value
abbrev IntegerTy := C99IntegerReference.Ty

structure Valid (args : Args) (l : Locals) : Prop where
  capacity : l.scalars "max_out_len".toList=some (.uint64,some (.uint64 args.capacity))
  typed : ∀ name ty v, l.scalars name=some (ty,some v) → v.type=ty
  cursor : ∀ ty old, l.scalars "u".toList=some (ty,old) → ty=.uint64

theorem convert_type (ty : IntegerTy) (v : Int) : (C99IntegerReference.convert ty v).type=ty := by
  cases ty <;> rfl

theorem set_valid (args : Args) (l : Locals) (name : List Char) (ty : IntegerTy)
    (value : Option IntegerValue) (valid : Valid args l)
    (notCapacity : name≠"max_out_len".toList)
    (cursor : name="u".toList → ty=.uint64)
    (typed : ∀ v, value=some v → v.type=ty) : Valid args (localSet l name ty value) := by
  refine ⟨?_,?_,?_⟩
  · change (if "max_out_len".toList=name then some (ty,value) else l.scalars "max_out_len".toList)=_
    split
    · rename_i same; exact (notCapacity same.symm).elim
    · exact valid.capacity
  · intro other otherTy v held
    by_cases same : other=name
    · subst other
      simp only [localSet,C99ScalarReference.set,ite_true,Option.some.injEq,Prod.mk.injEq] at held
      exact (typed v held.2).trans held.1
    · simp only [localSet,C99ScalarReference.set,same,ite_false] at held
      exact valid.typed other otherTy v held
  · intro otherTy old held
    by_cases same : "u".toList=name
    · simp only [localSet,C99ScalarReference.set,same,ite_true,Option.some.injEq,Prod.mk.injEq] at held
      exact held.1.symm.trans (cursor same.symm)
    · simp only [localSet,C99ScalarReference.set,same,ite_false] at held
      exact valid.cursor otherTy old held

def expression : Expr → Bool
  | .preInc (.variable n) | .postInc (.variable n) | .preDec (.variable n) | .postDec (.variable n) =>
      n != "max_out_len".toList
  | .preInc _ | .postInc _ | .preDec _ | .postDec _ => false
  | .number _ _ | .variable _ | .argsNil => true
  | .unary _ e | .cast _ e | .member e _ => expression e
  | .binary _ a b | .index a b | .argsCons a b => expression a && expression b
  | .conditional t a b => expression t && expression a && expression b
  | .call _ _ => false

theorem update_valid (args : Args) (name : List Char) (delta : Int) (l t : Locals)
    (old value : Value) (source : Update name delta l old value t)
    (valid : Valid args l) (safe : name≠"max_out_len".toList) : Valid args t := by
  cases source with
  | scalar name delta l ty v z bound operation =>
    exact set_valid args l name ty _ valid safe
      (fun same => valid.cursor ty (some v) (by simpa only [same] using bound))
      (fun value same => by cases same; exact convert_type ty z.integer)
  | pointer => exact ⟨valid.capacity,valid.typed,valid.cursor⟩

theorem and_parts {a b : Bool} (held : (a && b)=true) : a=true ∧ b=true := by
  simpa only [Bool.and_eq_true] using held

theorem eval_valid (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (e : Expr) (l t : Locals) (value : Value) (source : Eval args heap buf e l value t)
    (safe : expression e=true) (valid : Valid args l) : Valid args t := by
  induction source with
  | number => exact valid
  | scalar => exact valid
  | out => exact valid
  | null => exact valid
  | input => exact valid
  | buffer => exact valid
  | preInc name l t old value operation => exact update_valid args name 1 l t old value operation valid (by simpa [expression] using safe)
  | postInc name l t old value operation => exact update_valid args name 1 l t old value operation valid (by simpa [expression] using safe)
  | preDec name l t old value operation => exact update_valid args name (-1) l t old value operation valid (by simpa [expression] using safe)
  | postDec name l t old value operation => exact update_valid args name (-1) l t old value operation valid (by simpa [expression] using safe)
  | cast ty e l t v z evaluated cast ih => exact ih safe valid
  | unary op e l t v z evaluated operation ih => exact ih safe valid
  | dereference e l t p w evaluated load ih => exact ih safe valid
  | binary op a b l m t x y z first second operation ih1 ih2 =>
    simp only [expression,Bool.and_eq_true] at safe
    exact ih2 safe.2 (ih1 safe.1 valid)
  | andFalse a b l t v first zero ih => exact ih (and_parts safe).1 valid
  | andTrue a b l m t x y first nonzero second ih1 ih2 =>
    exact ih2 (and_parts safe).2 (ih1 (and_parts safe).1 valid)
  | orTrue a b l t v first nonzero ih => exact ih (and_parts safe).1 valid
  | orFalse a b l m t x y first zero second ih1 ih2 =>
    exact ih2 (and_parts safe).2 (ih1 (and_parts safe).1 valid)
  | conditionalTrue test a b l m t v z condition nonzero selected ih1 ih2 =>
    have parts := and_parts safe
    exact ih2 (and_parts parts.1).2 (ih1 (and_parts parts.1).1 valid)
  | conditionalFalse test a b l m t v z condition zero selected ih1 ih2 =>
    have parts := and_parts safe
    exact ih2 parts.2 (ih1 (and_parts parts.1).1 valid)

def objectsSafe (objects : List Object) : Bool := objects.all fun o =>
  o.name != "max_out_len".toList && (o.name != "u".toList || scalarTy o.type == some .uint64)

theorem declare_valid (args : Args) (objects : List Object) (l t : Locals)
    (source : declareLocals objects l=some t) (safe : objectsSafe objects=true)
    (valid : Valid args l) : Valid args t := by
  induction objects generalizing l with
  | nil => simp only [declareLocals,Option.some.injEq] at source; subst t; exact valid
  | cons o rest ih =>
    have parts : (o.name≠"max_out_len".toList ∧ (o.name≠"u".toList ∨ scalarTy o.type=some .uint64)) ∧ objectsSafe rest=true := by
      simpa [objectsSafe,Bool.and_eq_true,Bool.or_eq_true] using safe
    simp only [declareLocals] at source
    split at source
    · cases source
    · split at source
      · split at source
        · exact ih l source parts.2 valid
        · cases source
      · cases typeEq : scalarTy o.type with
        | none => simp [typeEq] at source
        | some ty =>
          simp only [typeEq] at source
          apply ih _ source parts.2
          exact set_valid args l o.name ty none valid parts.1.1 (fun same => by
            rcases parts.1.2 with different | width
            · exact (different same).elim
            · exact Option.some.inj (typeEq.symm.trans width)) (fun _ h => by cases h)

theorem initial_valid (args : Args) : Valid args (initialLocals args) := by
  refine ⟨by simp [initialLocals],?_,?_⟩
  · intro name ty v held
    simp only [initialLocals] at held
    split at held
    · cases held; rfl
    · split at held
      · cases held; rfl
      · split at held
        · cases held; rfl
        · split at held
          · cases held; rfl
          · cases held
  · intro ty old held
    simp [initialLocals] at held

end FT1536.Source3.KeygenCodecLocalFacts
