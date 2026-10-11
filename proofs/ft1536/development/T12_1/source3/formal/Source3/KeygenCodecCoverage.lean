import Source3.KeygenCodecExecution

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Syntactic coverage of the reference interpreter, separately from the
   coarser memory-effect checker. This is not a definedness theorem: a
   shift/read/overflow with no C99 derivation still has no execution. -/
namespace FT1536.Source3.KeygenCodecCoverage
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

def scalarType (ty : Ty) : Bool := (scalarTy ty).isSome
def castType (ty : Ty) : Bool := scalarType ty || ty==.byte || ty==.i16 || ty==.u16

def expression : Expr → Bool
  | .number ty _ => castType ty
  | .variable _ => true
  | .preInc (.variable name) | .postInc (.variable name)
  | .preDec (.variable name) | .postDec (.variable name) =>
      name != "buf".toList && name != "out".toList
  | .cast ty e => castType ty && expression e
  | .unary .address _ => false
  | .unary _ e => expression e
  | .binary .div _ _ | .binary .rem _ _ => false
  | .binary _ a b => expression a && expression b
  | .conditional t a b => expression t && expression a && expression b
  | _ => false

def effect : Expr → Bool
  | .preInc _ | .postInc _ | .preDec _ | .postDec _ => true
  | .cast _ e | .unary _ e => effect e
  | .binary _ a b => effect a || effect b
  | .conditional t a b => effect t || effect a || effect b
  | _ => false
def constant : Expr → Bool
  | .number _ _ => true
  | .cast _ e | .unary _ e => constant e
  | .binary _ a b => constant a && constant b
  | _ => false
/-- For every unsequenced binary pair containing an increment/decrement,
    the other operand is constant in these actual bodies (ne-- >=0,
    ++acc_len ==8). This records the limit of the ordered reference model;
    a general C evaluation-order correspondence is a separate theorem. -/
def sequencing : Expr → Bool
  | .cast _ e | .unary _ e => sequencing e
  | .binary _ a b => sequencing a && sequencing b &&
      (!effect a || constant b) && (!effect b || constant a)
  | .conditional t a b => sequencing t && sequencing a && sequencing b
  | _ => true

def testsSequenced : Stmt → Bool
  | .write lhs _ rhs => sequencing lhs && sequencing rhs
  | .evaluate e | .ret e => sequencing e
  | .seq a b => testsSequenced a && testsSequenced b
  | .scope a => testsSequenced a
  | .branch t a b => sequencing t && testsSequenced a && testsSequenced b
  | .whileLoop t a => sequencing t && testsSequenced a
  | .loop a t b c => testsSequenced a && t.all sequencing && testsSequenced b && testsSequenced c
  | .switch t a b c => sequencing t && testsSequenced a && testsSequenced b && testsSequenced c
  | _ => true

def object (o : Object) : Bool := !o.count.isSome &&
  (if o.name=="buf".toList then o.type==.pointer .byte else scalarType o.type)

def statement : Stmt → Bool
  | .skip => true
  | .declare objects => objects.all object
  | .write (.variable name) op rhs =>
      if name=="buf".toList then op==.set && rhs==.variable "out".toList
      else name != "out".toList && expression rhs
  | .write (.index (.variable name) index) .set rhs =>
      name=="buf".toList && expression index && expression rhs
  | .increment (.variable name) => name != "buf".toList && name != "out".toList
  | .evaluate e => expression e
  | .seq a b => statement a && statement b
  | .scope a => statement a
  | .branch t a b => expression t && statement a && statement b
  | .whileLoop t a => expression t && statement a
  | .loop initial test increment loopBody =>
      statement initial && test.all expression && statement increment && statement loopBody
  | .switch t a b c => expression t && statement a && statement b && statement c
  | .ret (.call _ args) => args==KeygenCodecValues.calleeArgs
  | .ret e => expression e
  | _ => false

/-- buf is declared only in the outermost function scope; inner scopes
    never shadow it. Its outer binding is absent in a fresh activation. -/
def innerScopes : Stmt → Bool
  | .scope a => !hasBuf (scopeObjects a) && innerScopes a
  | .seq a b | .branch _ a b => innerScopes a && innerScopes b
  | .whileLoop _ a => innerScopes a
  | .loop a _ b c | .switch _ a b c => innerScopes a && innerScopes b && innerScopes c
  | _ => true
def functionScope : Stmt → Bool
  | .scope a => innerScopes a
  | _ => false

theorem none_covered : statement KeygenCodecNoneBinding.code=true := by decide +kernel
theorem static_covered : statement KeygenCodecStaticBinding.code=true := by decide +kernel
theorem dispatch_covered : statement KeygenCodecDispatchBinding.code=true := by decide +kernel
theorem none_scopes : functionScope KeygenCodecNoneBinding.code=true := by decide +kernel
theorem static_scopes : functionScope KeygenCodecStaticBinding.code=true := by decide +kernel
theorem dispatch_scopes : functionScope KeygenCodecDispatchBinding.code=true := by decide +kernel
theorem none_sequencing : testsSequenced KeygenCodecNoneBinding.code=true := by decide +kernel
theorem static_sequencing : testsSequenced KeygenCodecStaticBinding.code=true := by decide +kernel
theorem dispatch_sequencing : testsSequenced KeygenCodecDispatchBinding.code=true := by decide +kernel

/-- A concrete execution of the bound default arm for every heap and
    argument set with comp outside0/1. This is an inhabitation check, not
    a successful encoding, length theorem or codec correctness premise. -/
theorem default_call (args : Args) (heap : Memory)
    (zero : args.comp.toInt≠0) (one : args.comp.toInt≠1) : Call args heap heap 0 := by
  let s := initial args heap
  let after := withLocals s s.locals
  have returned : Exec args (.ret (.number .i32 0)) s after (.returned 0) :=
    .ret args s (.number .i32 0) (.int32 0) s.locals (.number .i32 0 (.int32 0) s.locals (by decide +kernel))
  have selected : Exec args KeygenCodecDispatchBinding.node000 s after (.returned 0) :=
    .switchOther args (.variable "comp".toList) _ _ _ s after (.returned 0) (.int32 args.comp) s.locals
      (.scalar "comp".toList s.locals .int32 (.int32 args.comp) (by simp [s,initial,initialLocals]))
      zero one returned
  have sequence : Exec args KeygenCodecDispatchBinding.node002 s after (.returned 0) :=
    .seqReturn args _ _ s after 0 selected
  refine ⟨scopeExit KeygenCodecDispatchBinding.node002 s after,?_,rfl⟩
  exact .scope args _ s after (.returned 0) (by intro _; rfl) sequence

end FT1536.Source3.KeygenCodecCoverage
