import Source3.KeygenNttTransform
import Source3.C99ProcedureParser

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The four source call statements use the existing argument-binding and
   procedure AST. This closed call stratum executes the complete modular NTT
   body after the pinned macro inserts stride=1. There is no callee oracle
   and no mathematical postcondition in an execution constructor. -/
namespace FT1536.Source3.KeygenSolverNttCalls
open C99MemoryReference
open C99ArrayReference (State Param Arg Bind bindValue bindPointer)
open C99ProcedureReference (Stmt Result)
open C99IntegerReference (Value)

def macroParams : List Param := [.pointer "a".toList,.pointer "gm".toList,
  .scalar .uint32 "logn".toList,.scalar .uint32 "full".toList,
  .scalar .uint32 "p".toList,.scalar .uint32 "p0i".toList]
def params : List Param := [.pointer "a".toList,.scalar .uint64 "stride".toList,.pointer "gm".toList,
  .scalar .uint32 "logn".toList,.scalar .uint32 "full".toList,
  .scalar .uint32 "p".toList,.scalar .uint32 "p0i".toList]
def signatures : C99ProcedureParser.Signatures := fun name =>
  if name="modp_NTT3".toList then some (macroParams,none) else none
def arguments (name : String) : List Arg := [
  .pointer name.toList C99ProcedureParser.zero,.pointer "gm".toList C99ProcedureParser.zero,
  .scalar (.var "logn".toList),.scalar (.literal .i32 1),
  .scalar (.var "p".toList),.scalar (.var "p0i".toList)]
def expandArgs : List Arg → List Arg
  | a::rest => a::.scalar (.literal .i32 1)::rest
  | [] => []
def call (name : String) : Stmt := .call "modp_NTT3".toList (arguments name) .discard
def code : Stmt := C99ProcedureParser.chain [call "ft",call "gt",call "Ft",call "Gt"]
def parsed : Option Stmt := do
  let text := ((Pinned.keygenLines.drop 7373).take 4).flatMap String.toList++['}']
  let tokens ← C99ProcedureParser.tokens text
  let (body,_,tail) ← C99ProcedureParser.body signatures [] 256 tokens
  if tail.isEmpty then pure body else none

theorem source_bound : parsed=some code := by decide
theorem signature_source : (Pinned.keygenLines.drop 3041).take 4 =
    ["static void\n","modp_NTT3_ext(uint32_t *a, size_t stride, const uint32_t *gm,\n",
     "\tunsigned logn, unsigned full, uint32_t p, uint32_t p0i)\n","{\n"] := by decide

inductive Exec : Stmt → State → State → Prop where
  | skip (s : State) : Exec (.base .skip) s s
  | seq (first second : Stmt) (before middle after : State)
      (head : Exec first before middle) (tail : Exec second middle after) :
      Exec (.seq first second) before after
  | call (args : List Arg) (before entry : State) (out : Result)
      (parameters : Bind before params (expandArgs args) entry)
      (body : C99ModularReference.Exec KeygenNttForwardPrograms.forwardBody entry out)
      (returned : C99ProcedureReference.ReturnValue none out.flow none) :
      Exec (.call "modp_NTT3".toList args .discard) before {before with heap := out.state.heap}

structure Caller (s : State) (p0i : BitVec 32) (gm : ArrayPointer) : Prop where
  logn : KeygenNttForwardExec.lognAt s
  prime : KeygenNttButterflyCalls.U32Slot s "p" KeygenNinv31.prime
  inverse : KeygenNttButterflyCalls.U32Slot s "p0i" p0i
  table : s.arrays "gm".toList=some gm

theorem pointer_zero (s : State) (name : String) (p actual : ArrayPointer)
    (binding : s.arrays name.toList=some p)
    (source : C99ArrayReference.Pointer s name.toList C99ProcedureParser.zero actual) : actual=p := by
  obtain ⟨v,ev,equal⟩ := KeygenNttLoopSupport.pointer_root s name.toList _ p actual binding source
  have hv := KeygenNttForwardExec.literal_value s .u64 0 v ev
  subst v
  change actual={p with index := p.index+0} at equal
  simpa only [Nat.add_zero] using equal

theorem binding_entry (before entry : State) (name : String) (p gm : ArrayPointer) (p0i : BitVec 32)
    (caller : Caller before p0i gm) (array : before.arrays name.toList=some p)
    (parameters : Bind before params (expandArgs (arguments name)) entry) :
    KeygenNttFirstComposition.Entry entry p gm p0i := by
  cases parameters with
  | pointer _ _ _ ap _ _ _ av tail =>
    cases tail with
    | scalar _ _ _ _ _ _ stride sv tail =>
      cases tail with
      | pointer _ _ _ gp _ _ _ gv tail =>
        cases tail with
        | scalar _ _ _ _ _ _ logn lv tail =>
          cases tail with
          | scalar _ _ _ _ _ _ full fv tail =>
            cases tail with
            | scalar _ _ _ _ _ _ prime pv tail =>
              cases tail with
              | scalar _ _ _ _ _ _ inverse iv tail =>
                cases tail
                have ha := pointer_zero before name p ap array av
                have hg := pointer_zero before "gm" gm gp caller.table gv
                have hs := KeygenNttLoopSupport.literal_i32 before 1 stride sv
                have hl := C99CountedWords.variable_exact before "logn".toList .uint32 (.uint32 10) logn caller.logn lv
                have hf := KeygenNttLoopSupport.literal_i32 before 1 full fv
                have hp := C99CountedWords.variable_exact before "p".toList .uint32 (.uint32 KeygenNinv31.prime)
                  prime caller.prime pv
                have hi := C99CountedWords.variable_exact before "p0i".toList .uint32 (.uint32 p0i) inverse caller.inverse iv
                subst ap gp stride logn full prime inverse
                constructor
                · rfl
                · rfl
                · rfl
                · change some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.convert .uint32 (Value.uint32 p0i).integer))=
                    some (C99IntegerReference.Ty.uint32,some (Value.uint32 p0i))
                  exact congrArg (fun x : Value => some (C99IntegerReference.Ty.uint32,some x))
                    (C99CountedWords.convert_self (.uint32 p0i))
                · rfl
                · rfl
                · rfl

theorem frame (statement : Stmt) (before after : State) (source : Exec statement before after) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧
    after.globals=before.globals ∧ after.tables=before.tables := by
  induction source with
  | skip | call => exact ⟨rfl,rfl,rfl,rfl⟩
  | seq _ _ _ _ _ _ _ ih1 ih2 =>
      exact ⟨ih2.1.trans ih1.1,ih2.2.1.trans ih1.2.1,ih2.2.2.1.trans ih1.2.2.1,ih2.2.2.2.trans ih1.2.2.2⟩

theorem caller_preserved (statement : Stmt) (before after : State) (p0i : BitVec 32) (gm : ArrayPointer)
    (source : Exec statement before after) (caller : Caller before p0i gm) : Caller after p0i gm := by
  obtain ⟨hl,ha,_,_⟩ := frame statement before after source
  exact ⟨(congrFun hl _).trans caller.logn,(congrFun hl _).trans caller.prime,
    (congrFun hl _).trans caller.inverse,(congrFun ha _).trans caller.table⟩

theorem call_contract (name : String) (before after : State) (p gm : ArrayPointer)
    (v : Geometry.Vec) (p0i : BitVec 32) (caller : Caller before p0i gm)
    (array : before.arrays name.toList=some p) (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (input : KeygenResidueVectors.Represents before.heap p v) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (call name) before after) : KeygenNttTransform.Contract before.heap after.heap p gm v := by
  cases source with
  | call args before entry out parameters body returned =>
      have entryArgs := binding_entry before entry name p gm p0i caller array parameters
      have heap := C99ArrayReference.bind_heap before params (expandArgs (arguments name)) entry parameters
      have result := KeygenNttTransform.source_transform entry out p gm v p0i entryArgs pw gw separate
        (by rw [heap]; exact input) (by rw [heap]; exact table) initialization body
      rw [heap] at result
      exact result.2

end FT1536.Source3.KeygenSolverNttCalls
