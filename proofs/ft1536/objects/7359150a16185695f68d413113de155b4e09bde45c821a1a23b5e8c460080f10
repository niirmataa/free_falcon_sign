import Source3.KeygenLevelModularFrame
import Source3.KeygenMkgm3Program

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete inverse ternary NTT, including the logn0 return, both full
   branches and the corrective factor. Split only at statement boundaries.
   Forward and table generation are reused as operational bodies; numerical
   transform correctness is not a premise of these search-call frames. -/
namespace FT1536.Source3.KeygenLevelNtt
open C99ModularReference (Stmt Exec)
open C99ArrayReference (State Name Param Arg)
open C99ProcedureReference (Result)

def region (start count : Nat) : List String := (Pinned.keygenLines.drop (start-1)).take count

/- The inverse function's mixed declaration is not accepted by the older
   modular parser. This rejecting declarator grammar retains each pointer. -/
def declarators (ty : B20.C.Ty) : Nat → List B20.C.Token → Option (List Stmt)
  | 0,_ => none
  | fuel+1,['*']::name::[',']::rest => do
    pure (.base (.declarePtr name)::(← declarators ty fuel rest))
  | _+1,['*']::name::[[';']] => some [.base (.declarePtr name)]
  | fuel+1,name::[',']::rest => do
    if name.isEmpty || !name.all B20.C.wordChar then none else
      pure (.base (.scalar (.declare ty [name]))::(← declarators ty fuel rest))
  | _+1,[name,[';']] =>
    if name.isEmpty || !name.all B20.C.wordChar then none else
      some [.base (.scalar (.declare ty [name]))]
  | _,_ => none
def mixed : Option Stmt := do
  let tokens ← C99ProcedureParser.tokens ((region 3148 1).flatMap String.toList)
  match tokens with
  | ty::rest => pure (C99ModularParser.chain (← declarators (← B20.C.Scalar.typeToken ty) 16 rest))
  | _ => none
def mixedCode : Stmt := C99ModularParser.chain [
  .base (.scalar (.declare .u32 ["w".toList])),
  .base (.scalar (.declare .u32 ["ni".toList])),
  .base (.scalar (.declare .u32 ["R".toList])),
  .base (.declarePtr "r1".toList),.base (.declarePtr "r2".toList)]
def ranges : Fin 5 → Nat×Nat
  | 0 => (3149,16)
  | 1 => (3165,30)
  | 2 => (3195,28)
  | 3 => (3223,17)
  | 4 => (3240,5)
def parsed (i : Fin 5) : Option Stmt :=
  C99ModularParser.regionContext ["a".toList,"r1".toList,"r2".toList] (ranges i).1 (ranges i).2
def part (i : Fin 5) : Stmt := (parsed i).getD (.base .skip)
def sizeCode : Stmt := .seq (.base (.scalar (.declare .u64
  ["n".toList,"hn".toList,"u".toList,"r".toList,"m".toList,"t".toList]))) (.base .skip)
def inverse : Stmt := C99ModularParser.chain [sizeCode,mixedCode,part 0,part 1,part 2,part 3,part 4]
def writable : List Name := ["a".toList,"r1".toList,"r2".toList]
def audit (i : Fin 5) : Option Bool := (parsed i).map (KeygenLevelModularFrame.only writable)

theorem signature_source : region 3143 4 = ["static void\n",
  "modp_iNTT3_ext(uint32_t *a, size_t stride, const uint32_t *igm,\n",
  "\tunsigned logn, unsigned full, uint32_t p, uint32_t p0i)\n","{\n"] := by decide
theorem size_source : C99ModularParser.region 3147 1=some sizeCode := by decide
theorem mixed_source : mixed=some mixedCode := by decide
theorem partition_source : region 3147 98 = region 3147 1 ++ region 3148 1 ++
    region 3149 16 ++ region 3165 30 ++ region 3195 28 ++ region 3223 17 ++ region 3240 5 := by decide
theorem closing_source : Pinned.keygenLines[3244]?=some "}\n" := by decide
theorem wrapper_source : region 3253 2 = [
  "#define modp_iNTT3(a, igm, logn, full, p, p0i) \\\n",
  "\tmodp_iNTT3_ext(a, 1, igm, logn, full, p, p0i)\n"] := by decide
theorem audit0 : audit 0=some true := by decide
theorem audit1 : audit 1=some true := by decide
theorem audit2 : audit 2=some true := by decide
theorem audit3 : audit 3=some true := by decide
theorem audit4 : audit 4=some true := by decide
theorem audit_all (i : Fin 5) : audit i=some true := by
  fin_cases i
  · exact audit0
  · exact audit1
  · exact audit2
  · exact audit3
  · exact audit4
theorem parsed_part (i : Fin 5) : parsed i=some (part i) := by
  have h := audit_all i
  unfold audit at h
  cases hp : parsed i with
  | none => simp only [hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]
theorem part_checked (i : Fin 5) : KeygenLevelModularFrame.only writable (part i)=true := by
  have h := audit_all i
  rw [audit,parsed_part] at h
  exact Option.some.inj h
theorem inverse_checked : KeygenLevelModularFrame.only writable inverse=true :=
  KeygenLevelModularFrame.sequence_checked _ _ _ (by decide)
    (KeygenLevelModularFrame.sequence_checked _ _ _ (by decide)
      (KeygenLevelModularFrame.sequence_checked _ _ _ (part_checked 0)
        (KeygenLevelModularFrame.sequence_checked _ _ _ (part_checked 1)
          (KeygenLevelModularFrame.sequence_checked _ _ _ (part_checked 2)
            (KeygenLevelModularFrame.sequence_checked _ _ _ (part_checked 3)
              (KeygenLevelModularFrame.sequence_checked _ _ _ (part_checked 4) rfl))))))
theorem forward_checked : KeygenLevelModularFrame.only writable KeygenNttForwardPrograms.forwardBody=true := by decide

inductive Kind where
  | forward | inverse
  deriving DecidableEq, Repr
def body : Kind → Stmt
  | .forward => KeygenNttForwardPrograms.forwardBody
  | .inverse => inverse
def params (kind : Kind) : List Param := [.pointer "a".toList,.scalar .uint64 "stride".toList,
  .pointer (if kind=.forward then "gm".toList else "igm".toList),
  .scalar .uint32 "logn".toList,.scalar .uint32 "full".toList,
  .scalar .uint32 "p".toList,.scalar .uint32 "p0i".toList]
inductive Call (kind : Kind) (before : State) (args : List Arg) : State → Prop where
  | run (entry : State) (out : Result) (binding : C99ArrayReference.Bind before (params kind) args entry)
      (source : Exec (body kind) entry out)
      (returned : C99ProcedureReference.ReturnValue none out.flow none) :
      Call kind before args {before with heap := out.state.heap}

theorem checked (kind : Kind) : KeygenLevelModularFrame.only writable (body kind)=true := by
  cases kind
  · exact forward_checked
  · exact inverse_checked
theorem call_frame (kind : Kind) (before after : State) (args : List Arg)
    (source : Call kind before args after) (names : List Name) (block offset : Nat)
    (allowed : C99PointerFootprint.arguments names writable (params kind) args=true)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out binding execution returned =>
    obtain ⟨ho,_⟩ := C99PointerFootprint.bind_outside before (params kind) args entry
      binding names writable allowed block offset outside tables
    have keep := (KeygenLevelModularFrame.body_frame (body kind) entry out execution
      writable (checked kind) block offset ho).2.2
    rw [C99ArrayReference.bind_heap before (params kind) args entry binding] at keep
    exact keep

end FT1536.Source3.KeygenLevelNtt
