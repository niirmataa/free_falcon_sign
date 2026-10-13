import Source3.KeygenPublicEncodePure077
import Source3.KeygenCodecStaticMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Calculations with activation side effects, needed by actual unsigned *x++
   and scalar counter expressions. The heap remains the actual source heap. -/
namespace FT1536.Source3.KeygenPublicEncodeDynamic077
open KeygenCodecSyntax KeygenPublicEncodeValues077 C99MemoryReference
open KeygenPublicEncodePure077
abbrev IV := C99IntegerReference.Value

/-- A scalar update calculation retains the declared type and the exact
    promoted C operation, including its definedness. -/
inductive ScalarUpdate (name : Name) (delta : Int) (l : Locals) (old next : IV) (t : Locals) : Prop where
  | scalar (ordinary : Ordinary name) (ty : C99IntegerReference.Ty)
      (cell : l.scalars name=some (ty,some old)) (result : IV)
      (operation : C99IntegerReference.ArithmeticExec .plus old (.int32 (BitVec.ofInt 32 delta)) result)
      (converted : next=C99IntegerReference.convert ty result.integer)
      (locals : t=localSet l name ty (some next)) : ScalarUpdate name delta l old next t

theorem update_exists (name : Name) (delta : Int) (l t : Locals) (old next : IV)
    (calculation : ScalarUpdate name delta l old next t) :
    Update name delta l (.integer old) (.integer next) t := by
  obtain ⟨_,ty,cell,result,operation,converted,last⟩ := calculation
  subst next; subst t
  exact .scalar name delta l ty old result cell operation

theorem update_value (name : Name) (delta : Int) (l t actualLocals : Locals)
    (old next : IV) (actualOld actualNext : Value)
    (calculation : ScalarUpdate name delta l old next t)
    (source : Update name delta l actualOld actualNext actualLocals) :
    actualOld=.integer old ∧ actualNext=.integer next ∧ actualLocals=t := by
  obtain ⟨ordinary,expectedTy,cell,result,expectedOperation,converted,last⟩ := calculation
  cases source with
  | scalar name delta l ty v z bound operation =>
    have equal := Option.some.inj (bound.symm.trans cell)
    cases equal
    have same := C99IntegerReference.arithmetic_deterministic _ _ _ _ _ operation expectedOperation
    subst z
    exact ⟨rfl,congrArg KeygenCodecValues.Value.integer converted.symm,
      (congrArg (fun value => localSet l name expectedTy (some value)) converted).symm.trans last.symm⟩
  | pointer => exact (ordinary.2.2.1 rfl).elim

inductive Computes (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer)) :
    Expr → Locals → IV → Locals → Prop where
  | pure (l : Locals) (e : Expr) (v : IV)
      (calculation : KeygenPublicEncodePure077.Computes l e v) : Computes args heap buf e l v l
  | postInc (name : Name) (l t : Locals) (old next : IV)
      (calculation : ScalarUpdate name 1 l old next t) : Computes args heap buf (.postInc (.variable name)) l old t
  | preInc (name : Name) (l t : Locals) (old next : IV)
      (calculation : ScalarUpdate name 1 l old next t) : Computes args heap buf (.preInc (.variable name)) l next t
  | postDec (name : Name) (l t : Locals) (old next : IV)
      (calculation : ScalarUpdate name (-1) l old next t) : Computes args heap buf (.postDec (.variable name)) l old t
  | cast (ty : Ty) (e : Expr) (l t : Locals) (v z : IV)
      (inner : Computes args heap buf e l v t) (converted : castInteger ty v=some z) :
      Computes args heap buf (.cast ty e) l z t
  | unary (op : Unary) (e : Expr) (l t : Locals) (v z : IV)
      (inner : Computes args heap buf e l v t) (operation : UnaryOp op (.integer v) (.integer z)) :
      Computes args heap buf (.unary op e) l z t
  | binary (op : Op) (a b : Expr) (l m t : Locals) (x y z : IV)
      (left : Computes args heap buf a l x m) (right : Computes args heap buf b m y t)
      (operation : BinaryOp op (.integer x) (.integer y) (.integer z)) :
      Computes args heap buf (.binary op a b) l z t
  | outTest (l : Locals) (noOut : l.scalars "out".toList=none) (noNull : l.scalars "NULL".toList=none) :
      Computes args heap buf (.binary .ne (.variable "out".toList) (.variable "NULL".toList)) l
        (C99ScalarReference.boolean (decide (args.out≠none))) l
  | read (l : Locals) (ptr next : ArrayPointer) (word : BitVec 16)
      (held : l.x=some ptr) (advance : PointerAdd ptr 1 next) (load : Load16 heap ptr word) :
      Computes args heap buf (.unary .dereference (.postInc (.variable "x".toList))) l
        (.int32 (BitVec.ofNat 32 word.toNat)) {l with x := some next}

theorem computes_exists (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (e : Expr) (l t : Locals) (v : IV) (calculation : Computes args heap buf e l v t) :
    Eval args heap buf e l (.integer v) t := by
  induction calculation with
  | pure l e v calculation => exact KeygenPublicEncodePure077.exists_eval _ _ _ _ _ _ calculation
  | postInc name l t old next calculation => exact .postInc _ _ _ _ _ (update_exists _ _ _ _ _ _ calculation)
  | preInc name l t old next calculation => exact .preInc _ _ _ _ _ (update_exists _ _ _ _ _ _ calculation)
  | postDec name l t old next calculation => exact .postDec _ _ _ _ _ (update_exists _ _ _ _ _ _ calculation)
  | cast ty e l t v z inner converted ih => exact .cast _ _ _ _ _ _ ih converted
  | unary op e l t v z inner operation ih => exact .unary _ _ _ _ _ _ ih operation
  | binary op a b l m t x y z left right operation ih1 ih2 => exact .binary _ _ _ _ _ _ _ _ _ ih1 ih2 operation
  | outTest l noOut noNull =>
    exact .binary _ _ _ l l l _ _ _ (.out l) (.null l) (.pointerNe args.out none)
  | read l ptr next word held advance load =>
    exact .dereference _ l {l with x := some next} ptr word
      (.postInc _ _ _ _ _ (.pointer l ptr next held advance)) load

theorem computes_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (e : Expr) (l t actualLocals : Locals) (v : IV) (result : Value)
    (calculation : Computes args heap buf e l v t)
    (source : Eval args heap buf e l result actualLocals) : result=.integer v ∧ actualLocals=t := by
  induction calculation generalizing actualLocals result with
  | pure l e v calculation => exact KeygenPublicEncodePure077.value_eval _ _ _ _ _ _ calculation _ _ source
  | postInc name l t old next calculation =>
    cases source with
    | postInc name l actualLocals actualOld actualNext updated =>
      have same := update_value _ _ _ _ _ _ _ _ _ calculation updated
      exact ⟨same.1,same.2.2⟩
  | preInc name l t old next calculation =>
    cases source with
    | preInc name l actualLocals actualOld actualNext updated =>
      have same := update_value _ _ _ _ _ _ _ _ _ calculation updated
      exact ⟨same.2.1,same.2.2⟩
  | postDec name l t old next calculation =>
    cases source with
    | postDec name l actualLocals actualOld actualNext updated =>
      have same := update_value _ _ _ _ _ _ _ _ _ calculation updated
      exact ⟨same.1,same.2.2⟩
  | cast ty e l t v z inner converted ih =>
    cases source with
    | cast ty e l actualLocals actualValue actualResult evaluated actualCast =>
      obtain ⟨same,last⟩ := ih _ _ evaluated
      cases same
      exact ⟨congrArg KeygenCodecValues.Value.integer (Option.some.inj (actualCast.symm.trans converted)),last⟩
  | unary op e l t v z inner operation ih =>
    cases source with
    | unary op e l actualLocals actualValue actualResult evaluated actualOperation =>
      obtain ⟨same,last⟩ := ih _ _ evaluated
      subst actualValue
      exact ⟨KeygenCodecScalarCalculation.unary_unique _ _ _ _ actualOperation operation,last⟩
    | dereference => cases operation
  | binary op a b l m t x y z left right operation ih1 ih2 =>
    cases source with
    | binary op a b l middle actualLocals actualX actualY actualZ first second actualOperation =>
      obtain ⟨same,last⟩ := ih1 _ _ first
      subst actualX; subst middle
      obtain ⟨same,last⟩ := ih2 _ _ second
      subst actualY
      exact ⟨KeygenCodecScalarCalculation.binary_unique _ _ _ _ _ actualOperation operation,last⟩
    | andFalse => cases operation
    | andTrue => cases operation
    | orTrue => cases operation
    | orFalse => cases operation
  | outTest l noOut noNull =>
    cases source with
    | binary op a b l middle actualLocals actualX actualY actualZ first second operation =>
      cases first with
      | scalar name l ty value bound => rw [noOut] at bound; cases bound
      | out =>
        cases second with
        | scalar name l ty value bound => rw [noNull] at bound; cases bound
        | null => cases operation; exact ⟨rfl,rfl⟩
  | read l ptr next word held advance load =>
    cases source with
    | unary op e l actualLocals actualValue actualResult evaluated actualOperation => cases actualOperation
    | dereference e l actualLocals actualPtr actualWord evaluated actualLoad =>
      cases evaluated with
      | postInc name l actualLocals actualValue actualNext updated =>
        cases updated with
        | pointer l actualPtr actualNext actualHeld actualAdvance =>
          have samePtr := Option.some.inj (actualHeld.symm.trans held)
          subst actualPtr
          have sameNext := KeygenCodecStaticMaterial.add_unique ptr actualNext next actualAdvance advance
          subst actualNext
          have sameWord := KeygenCodecStaticMaterial.load_unique heap ptr actualWord word actualLoad load
          subst actualWord
          exact ⟨rfl,rfl⟩

end FT1536.Source3.KeygenPublicEncodeDynamic077
