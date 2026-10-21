import Source3.MakeFgAddPrimeShape194
import Source3.KeygenModpR2Exec
import Source3.ZintNormWord194
import Source3.C99CountedWords
import Source3.C99DeclarationStatements
import Source3.KeygenDecodeWordOps

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The zint_mod_small_signed engine at dlen = 1 (one march word of the
   make_fg_step additional-prime walks). The pinned callee spine
   `KeygenZintCall.calleeBody .modSigned` (as split by
   MakeFgAddPrimeShape194: z declaration, the dlen = 0 early-return
   branch, the zint_mod_small_unsigned leaf call into z, the modp_sub
   sign correction and the z return) is executed in full at the selected
   instance dlen = 1 together with its nested leaf
   `KeygenZintCall.calleeBody (.leaf .reduce)` (zint_mod_small_unsigned),
   one loop round over the single marched word. The engine is per march
   word: the marched limb `d[0] = d0` and the section words
   p/p0i/R2/Rx are arbitrary BitVec 32 values, so each of the 512 march
   positions instantiates it. Export: the executed-word image

     modSignedWord d0 p p0i R2 Rx =
       modp_sub(unsignedWord d0 p p0i R2, Rx & -(d0 >>> 30), p)

   with unsignedWord the single-round leaf word
   `modp_add(modp_montymul(0, R2, p, p0i), w2, p)` and
   `w2 = (d0 - p) + (p & -((d0 - p) >>> 31))` — all modular calls at
   their pinned leaf bodies (KeygenModpWord.montgomery,
   KeygenModpAddSub.result .add/.sub). The parse shapes are the pinned
   job-553 probe record as re-bound by decide here and in
   MakeFgAddPrimeShape194; no new parse recognition is performed.

   Values stay executed words: no residue range, normalization,
   positivity or correctness claim of the C algorithm is made here. -/
namespace FT1536.Source3.ZintModSignedWord194
open C99ArrayReference (State Name Pointer Arg bindValue bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenZintLeaves (Kind)
open KeygenWordExec (Stmt)

def dName : Name := "d".toList
def dlenName : Name := "dlen".toList
def pName : Name := "p".toList
def p0iName : Name := "p0i".toList
def r2Name : Name := "R2".toList
def rxName : Name := "Rx".toList
def zName : Name := "z".toList
def xName : Name := "x".toList
def uName : Name := "u".toList
def wName : Name := "w".toList

/- The exported executed-word images of one march word at dlen = 1. -/
def unsignedWord (d0 p p0i R2 : BitVec 32) : BitVec 32 :=
  KeygenModpAddSub.result .add (KeygenModpWord.montgomery 0#32 R2 p p0i)
    ((d0-p) + (p &&& (-((d0-p)>>>31)))) p

def signWord (Rx d0 : BitVec 32) : BitVec 32 := Rx &&& (-(d0>>>30))

def modSignedWord (d0 p p0i R2 Rx : BitVec 32) : BitVec 32 :=
  KeygenModpAddSub.result .sub (unsignedWord d0 p p0i R2) (signWord Rx d0) p

/- Value-conversion and word-operation bridges (the ZintSubWord194 /
   KeygenDecodeWordOps primitives). -/
theorem convert_self32 (w : BitVec 32) :
    C99IntegerReference.convert .uint32 (Value.uint32 w).integer=.uint32 w :=
  KeygenDecodeWordOps.self32 w

theorem convert_u64_one :
    C99IntegerReference.convert .uint64 (Value.uint64 1#64).integer=.uint64 1#64 :=
  ZintSubWord194.convert_u64_one

theorem convert_i32_zero_u32 :
    C99IntegerReference.convert .uint32 (Value.int32 0#32).integer=.uint32 0#32 :=
  ZintSubWord194.convert_i32_zero_u32

theorem shr_thirty (a : BitVec 32) :
    C99IntegerReference.ShiftExec .right (.uint32 a) (.int32 30#32) (.uint32 (a>>>30)) :=
  KeygenDecodeWordOps.right32 a 30 (by decide)

theorem shr_thirty_one (a : BitVec 32) :
    C99IntegerReference.ShiftExec .right (.uint32 a) (.int32 31#32) (.uint32 (a>>>31)) :=
  KeygenDecodeWordOps.right32 a 31 (by decide)

theorem minus_one64 (x : BitVec 64) :
    C99IntegerReference.ArithmeticExec .minus (.uint64 x) (.int32 1#32) (.uint64 (x-1#64)) :=
  ZintNormWord194.minus_one64 x

theorem dec_one : C99IntegerReference.ArithmeticExec .minus (.uint64 1#64) (.int32 1#32)
    (.uint64 0#64) := ZintNormWord194.dec_one

theorem dec_zero : C99IntegerReference.ArithmeticExec .minus (.uint64 0#64) (.int32 1#32)
    (.uint64 (0#64-1#64)) := ZintNormWord194.dec_zero

theorem gt_one_true : C99IntegerReference.CompareExec .gt (.uint64 1#64) (.int32 0#32)
    (C99ScalarReference.boolean true) := ZintNormWord194.gt_one_true

theorem gt_zero_false : C99IntegerReference.CompareExec .gt (.uint64 0#64) (.int32 0#32)
    (C99ScalarReference.boolean false) := ZintNormWord194.gt_zero_false

theorem eq_one_false : C99IntegerReference.CompareExec .eq (.uint64 1#64) (.int32 0#32)
    (C99ScalarReference.boolean false) := by
  have source := C99IntegerReference.CompareExec.step .eq (.uint64 1#64) (.int32 0#32) .uint64
    rfl (.uint64 1#64) (.uint64 0#64) rfl rfl
  have same : (if C99IntegerReference.compare .eq (Value.uint64 1#64).integer
      (Value.uint64 0#64).integer then 1#32 else 0#32)=0#32 := by decide
  rw [same] at source
  exact source

theorem boolean_false_zero : (C99ScalarReference.boolean false).integer=0 := rfl

/- Cell reads of the section words and the marched word. -/
theorem cell32 (s : State) (name : Name) (w : BitVec 32)
    (slot : s.locals name=some (.uint32,some (.uint32 w))) :
    KeygenWordExpr.Eval s (.scalar (CLogic.Expr.var name)) (.uint32 w) :=
  .scalar _ _ (C99ScalarReference.Eval.variable name .uint32 (.uint32 w) slot)

theorem cell64 (s : State) (name : Name) (w : BitVec 64)
    (slot : s.locals name=some (.uint64,some (.uint64 w))) :
    KeygenWordExpr.Eval s (.scalar (CLogic.Expr.var name)) (.uint64 w) :=
  .scalar _ _ (C99ScalarReference.Eval.variable name .uint64 (.uint64 w) slot)

theorem cell32_exact (s : State) (name : Name) (w : BitVec 32) (v : Value)
    (slot : s.locals name=some (.uint32,some (.uint32 w)))
    (source : KeygenWordExpr.Eval s (.scalar (CLogic.Expr.var name)) v) : v=.uint32 w := by
  cases source with
  | scalar _ _ source =>
    exact C99CountedWords.variable_exact s name .uint32 (.uint32 w) v slot source

/- Statement pieces of the pinned zint_mod_small_unsigned leaf body
   (source-bound by reduce_shape). -/
def montExpr : KeygenWordExpr.Expr := .call4 "modp_montymul".toList
  (.scalar (CLogic.Expr.var xName)) (.scalar (CLogic.Expr.var r2Name))
  (.scalar (CLogic.Expr.var pName)) (.scalar (CLogic.Expr.var p0iName))
def addExpr : KeygenWordExpr.Expr := .call3 "modp_add".toList
  (.scalar (CLogic.Expr.var xName)) (.scalar (CLogic.Expr.var wName))
  (.scalar (CLogic.Expr.var pName))
def wSubExpr : KeygenWordExpr.Expr := .bin .sub
  (.load32 dName (CLogic.Expr.var uName)) (.scalar (CLogic.Expr.var pName))
def wAddExpr : KeygenWordExpr.Expr := .bin .add (.scalar (CLogic.Expr.var wName))
  (.bin .band (.scalar (CLogic.Expr.var pName))
    (.neg (.bin .shr (.scalar (CLogic.Expr.var wName)) (.scalar (.literal .i32 31)))))

def wskip : Stmt := .modular (.base .skip)
def wordScalar (s : CLogic.Stmt) : Stmt := .modular (.base (.scalar s))
def leafDeclX : Stmt := wordScalar (.declare .u32 [xName])
def leafDeclU : Stmt := wordScalar (.declare .u64 [uName])
def leafDeclW : Stmt := wordScalar (.declare .u32 [wName])
def leafSetX0 : Stmt := .assign xName (.scalar (.literal .i32 0))
def leafSetU1 : Stmt := .assign uName (.scalar (CLogic.Expr.var dlenName))
def leafSetXMont : Stmt := .assign xName montExpr
def leafSetWSub : Stmt := .assign wName wSubExpr
def leafSetWAdd : Stmt := .assign wName wAddExpr
def leafSetXAdd : Stmt := .assign xName addExpr
def leafGuard : KeygenWordExpr.Expr :=
  .cmp .gt (.scalar (CLogic.Expr.var uName)) (.scalar (.literal .i32 0))
def leafDecU : Stmt := wordScalar (.update uName .sub (.literal .i32 1))
def leafLoopBody : Stmt := .seq leafDecU (.scope [wName]
  (.seq leafDeclW (.seq leafSetXMont (.seq leafSetWSub (.seq leafSetWAdd (.seq leafSetXAdd wskip))))))
def leafLoop : Stmt := .loop leafGuard leafLoopBody wskip
def leafRetX : Stmt := .ret (.scalar (CLogic.Expr.var xName))
def leafBody : Stmt := .seq leafDeclX (.seq leafDeclU (.seq leafSetX0 (.seq leafSetU1
  (.seq (.seq leafLoop leafDecU) (.seq leafRetX wskip)))))

theorem reduce_shape : KeygenZintLeaves.code .reduce = leafBody := by decide

/- The leaf entry state of one march word: fresh frame from the caller,
   then R2 := r2w, p0i := p0w, p := pw, dlen := 1 (binding order R2,
   p0i, p, dlen) and the marched pointer d := pd. -/
def leafFresh (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
def leafR2 (s : State) (r2w : BitVec 32) : State :=
  bindValue (leafFresh s) r2Name .uint32 (.uint32 r2w)
def leafP0i (s : State) (p0w r2w : BitVec 32) : State :=
  bindValue (leafR2 s r2w) p0iName .uint32 (.uint32 p0w)
def leafP (s : State) (pw p0w r2w : BitVec 32) : State :=
  bindValue (leafP0i s p0w r2w) pName .uint32 (.uint32 pw)
def leafDlen (s : State) (pw p0w r2w : BitVec 32) : State :=
  bindValue (leafP s pw p0w r2w) dlenName .uint64 (.uint64 1#64)
def leafEntry (s : State) (pd : ArrayPointer) (pw p0w r2w : BitVec 32) : State :=
  bindPointer (leafDlen s pw p0w r2w) dName pd

theorem leaf_entry_heap (s : State) (pd : ArrayPointer) (pw p0w r2w : BitVec 32) :
    (leafEntry s pd pw p0w r2w).heap=s.heap := rfl

theorem leaf_entry_arrays (s : State) (pd : ArrayPointer) (pw p0w r2w : BitVec 32) :
    (leafEntry s pd pw p0w r2w).arrays dName=some pd := by
  simp [leafEntry,bindPointer,dName]

theorem leaf_entry_p (s : State) (pd : ArrayPointer) (pw p0w r2w : BitVec 32) :
    (leafEntry s pd pw p0w r2w).locals pName=some (.uint32,some (.uint32 pw)) := by
  have hdlen : (leafDlen s pw p0w r2w).locals pName=some (.uint32,some (.uint32 pw)) := by
    show (bindValue (leafP s pw p0w r2w) dlenName .uint64 (.uint64 1#64)).locals pName=_
    rw [ZintSubWord194.bind_other (leafP s pw p0w r2w) dlenName pName .uint64 (.uint64 1#64)
      (by decide)]
    show (bindValue (leafP0i s p0w r2w) pName .uint32 (.uint32 pw)).locals pName=_
    rw [ZintSubWord194.bind_cell (leafP0i s p0w r2w) pName .uint32 (.uint32 pw)]
    rw [convert_self32]
  show (bindPointer (leafDlen s pw p0w r2w) dName pd).locals pName=_
  exact hdlen

theorem leaf_entry_p0i (s : State) (pd : ArrayPointer) (pw p0w r2w : BitVec 32) :
    (leafEntry s pd pw p0w r2w).locals p0iName=some (.uint32,some (.uint32 p0w)) := by
  have hdlen : (leafDlen s pw p0w r2w).locals p0iName=some (.uint32,some (.uint32 p0w)) := by
    show (bindValue (leafP s pw p0w r2w) dlenName .uint64 (.uint64 1#64)).locals p0iName=_
    rw [ZintSubWord194.bind_other (leafP s pw p0w r2w) dlenName p0iName .uint64 (.uint64 1#64)
      (by decide)]
    show (bindValue (leafP0i s p0w r2w) pName .uint32 (.uint32 pw)).locals p0iName=_
    rw [ZintSubWord194.bind_other (leafP0i s p0w r2w) pName p0iName .uint32 (.uint32 pw)
      (by decide)]
    show (bindValue (leafR2 s r2w) p0iName .uint32 (.uint32 p0w)).locals p0iName=_
    rw [ZintSubWord194.bind_cell (leafR2 s r2w) p0iName .uint32 (.uint32 p0w)]
    rw [convert_self32]
  show (bindPointer (leafDlen s pw p0w r2w) dName pd).locals p0iName=_
  exact hdlen

theorem leaf_entry_r2 (s : State) (pd : ArrayPointer) (pw p0w r2w : BitVec 32) :
    (leafEntry s pd pw p0w r2w).locals r2Name=some (.uint32,some (.uint32 r2w)) := by
  have hdlen : (leafDlen s pw p0w r2w).locals r2Name=some (.uint32,some (.uint32 r2w)) := by
    show (bindValue (leafP s pw p0w r2w) dlenName .uint64 (.uint64 1#64)).locals r2Name=_
    rw [ZintSubWord194.bind_other (leafP s pw p0w r2w) dlenName r2Name .uint64 (.uint64 1#64)
      (by decide)]
    show (bindValue (leafP0i s p0w r2w) pName .uint32 (.uint32 pw)).locals r2Name=_
    rw [ZintSubWord194.bind_other (leafP0i s p0w r2w) pName r2Name .uint32 (.uint32 pw)
      (by decide)]
    show (bindValue (leafR2 s r2w) p0iName .uint32 (.uint32 p0w)).locals r2Name=_
    rw [ZintSubWord194.bind_other (leafR2 s r2w) p0iName r2Name .uint32 (.uint32 p0w)
      (by decide)]
    show (bindValue (leafFresh s) r2Name .uint32 (.uint32 r2w)).locals r2Name=_
    rw [ZintSubWord194.bind_cell (leafFresh s) r2Name .uint32 (.uint32 r2w)]
    rw [convert_self32]
  show (bindPointer (leafDlen s pw p0w r2w) dName pd).locals r2Name=_
  exact hdlen

theorem leaf_entry_dlen (s : State) (pd : ArrayPointer) (pw p0w r2w : BitVec 32) :
    (leafEntry s pd pw p0w r2w).locals dlenName=some (.uint64,some (.uint64 1#64)) := by
  have hdlen : (leafDlen s pw p0w r2w).locals dlenName=some (.uint64,some (.uint64 1#64)) := by
    show (bindValue (leafP s pw p0w r2w) dlenName .uint64 (.uint64 1#64)).locals dlenName=_
    rw [ZintSubWord194.bind_cell (leafP s pw p0w r2w) dlenName .uint64 (.uint64 1#64)]
    rw [convert_u64_one]
  show (bindPointer (leafDlen s pw p0w r2w) dName pd).locals dlenName=_
  exact hdlen

/- Expression evaluations at the leaf states. -/
theorem mont_eval (s : State) (x0 p0 p0i0 r20 : BitVec 32)
    (hx : s.locals xName=some (.uint32,some (.uint32 x0)))
    (hp : s.locals pName=some (.uint32,some (.uint32 p0)))
    (hp0i : s.locals p0iName=some (.uint32,some (.uint32 p0i0)))
    (hr2 : s.locals r2Name=some (.uint32,some (.uint32 r20))) :
    KeygenWordExpr.Eval s montExpr (.uint32 (KeygenModpWord.montgomery x0 r20 p0 p0i0)) :=
  .call4 _ _ _ _ _ _ _ _ _ _
    (cell32 s xName x0 hx) (cell32 s r2Name r20 hr2)
    (cell32 s pName p0 hp) (cell32 s p0iName p0i0 hp0i)
    (.montgomery _ _ (KeygenModpWord.source_exists x0 r20 p0 p0i0))

theorem add_eval (s : State) (x0 w0 p0 : BitVec 32)
    (hx : s.locals xName=some (.uint32,some (.uint32 x0)))
    (hw : s.locals wName=some (.uint32,some (.uint32 w0)))
    (hp : s.locals pName=some (.uint32,some (.uint32 p0))) :
    KeygenWordExpr.Eval s addExpr (.uint32 (KeygenModpAddSub.result .add x0 w0 p0)) :=
  .call3 _ _ _ _ _ _ _ _
    (cell32 s xName x0 hx) (cell32 s wName w0 hw) (cell32 s pName p0 hp)
    (.add _ _ (KeygenModpAddSub.source_exists .add x0 w0 p0))

theorem wsub_eval (s : State) (pd : ArrayPointer) (d0 p0 : BitVec 32)
    (hb : s.arrays dName=some pd) (cap : pd.index≤pd.count)
    (hu : s.locals uName=some (.uint64,some (.uint64 0#64)))
    (hp : s.locals pName=some (.uint32,some (.uint32 p0)))
    (read : Load32 s.heap pd d0) :
    KeygenWordExpr.Eval s wSubExpr (.uint32 (d0-p0)) := by
  have zero : C99ArrayReference.scalar s (CLogic.Expr.var uName) (.uint64 0#64) :=
    C99ScalarReference.Eval.variable uName .uint64 (.uint64 0#64) hu
  have address : Pointer s dName (CLogic.Expr.var uName) pd :=
    .add dName (CLogic.Expr.var uName) pd pd (.uint64 0#64) hb zero (by decide)
      (C99MemoryReference.PointerAdd.within pd 0 cap)
  refine KeygenWordExpr.Eval.bin .sub (.load32 dName (CLogic.Expr.var uName))
    (.scalar (CLogic.Expr.var pName)) (.uint32 d0) (.uint32 p0) (.uint32 (d0-p0)) ?_ ?_
    (KeygenDecodeWordOps.sub32 d0 p0)
  · exact KeygenWordExpr.Eval.load32 dName (CLogic.Expr.var uName) pd d0 address read
  · exact cell32 s pName p0 hp

theorem wadd_eval (s : State) (w0 p0 : BitVec 32)
    (hw : s.locals wName=some (.uint32,some (.uint32 w0)))
    (hp : s.locals pName=some (.uint32,some (.uint32 p0))) :
    KeygenWordExpr.Eval s wAddExpr (.uint32 (w0 + (p0 &&& (-((w0>>>31)))))) := by
  refine KeygenWordExpr.Eval.bin .add (.scalar (CLogic.Expr.var wName))
    (.bin .band (.scalar (CLogic.Expr.var pName))
      (.neg (.bin .shr (.scalar (CLogic.Expr.var wName)) (.scalar (.literal .i32 31)))))
    (.uint32 w0) (.uint32 (p0 &&& (-((w0>>>31)))))
    (.uint32 (w0 + (p0 &&& (-((w0>>>31)))))) (cell32 s wName w0 hw) ?_
    (KeygenDecodeWordOps.add32 w0 (p0 &&& (-((w0>>>31)))))
  refine KeygenWordExpr.Eval.bin .band (.scalar (CLogic.Expr.var pName))
    (.neg (.bin .shr (.scalar (CLogic.Expr.var wName)) (.scalar (.literal .i32 31))))
    (.uint32 p0) (.uint32 (-((w0>>>31)))) (.uint32 (p0 &&& (-((w0>>>31)))))
    (cell32 s pName p0 hp) ?_ (KeygenDecodeWordOps.and32 p0 (-((w0>>>31))))
  refine KeygenWordExpr.Eval.neg (.bin .shr (.scalar (CLogic.Expr.var wName))
    (.scalar (.literal .i32 31))) (.uint32 (w0>>>31)) (.uint32 (-((w0>>>31)))) ?_
    (KeygenDecodeWordOps.neg32 (w0>>>31))
  refine KeygenWordExpr.Eval.bin .shr (.scalar (CLogic.Expr.var wName))
    (.scalar (.literal .i32 31)) (.uint32 w0) (.int32 31#32) (.uint32 (w0>>>31))
    (cell32 s wName w0 hw) ?_ (shr_thirty_one w0)
  exact KeygenWordExpr.Eval.scalar (.literal .i32 31) (.int32 31#32)
    (C99ScalarReference.Eval.literal .int32 31)

/- Word helpers for the value chain. -/
theorem convert_u64_zero :
    C99IntegerReference.convert .uint64 (Value.uint64 0#64).integer=.uint64 0#64 := by decide

theorem convert_self64 (w : BitVec 64) :
    C99IntegerReference.convert .uint64 (Value.uint64 w).integer=.uint64 w :=
  C99CountedWords.convert_self (.uint64 w)

theorem wrap_one : (1#64-1#64 : BitVec 64)=0#64 := by decide

theorem gt_wrap_false : C99IntegerReference.CompareExec .gt (.uint64 (1#64-1#64)) (.int32 0#32)
    (C99ScalarReference.boolean false) := by
  rw [wrap_one]
  exact gt_zero_false

theorem boolean_zero (b : Bool) (h : b=false) :
    (C99ScalarReference.boolean b).integer=0 := by
  rw [h]
  rfl

/- The executed run at dlen = 1: shared states of one march word. -/
def t1 (entry : State) : State := C99DeclarationStatements.effect .u32 [xName] entry
def t2 (entry : State) : State := C99DeclarationStatements.effect .u64 [uName] (t1 entry)
def t3 (entry : State) : State := bindValue (t2 entry) xName .uint32 (.int32 0#32)
def t4 (entry : State) : State := bindValue (t3 entry) uName .uint64 (.uint64 1#64)
def t5 (entry : State) : State := bindValue (t4 entry) uName .uint64 (.uint64 (1#64-1#64))
def t6 (entry : State) : State := C99DeclarationStatements.effect .u32 [wName] (t5 entry)
def t7 (entry : State) (pw p0w r2w : BitVec 32) : State :=
  bindValue (t6 entry) xName .uint32 (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w))
def t8 (entry : State) (d0 pw p0w r2w : BitVec 32) : State :=
  bindValue (t7 entry pw p0w r2w) wName .uint32 (.uint32 (d0-pw))
def t9 (entry : State) (d0 pw p0w r2w : BitVec 32) : State :=
  bindValue (t8 entry d0 pw p0w r2w) wName .uint32 (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31)))))
def t10 (entry : State) (d0 pw p0w r2w : BitVec 32) : State :=
  bindValue (t9 entry d0 pw p0w r2w) xName .uint32 (.uint32 (unsignedWord d0 pw p0w r2w))
def t11 (entry : State) (d0 pw p0w r2w : BitVec 32) : State :=
  restoreScope (t5 entry) (t10 entry d0 pw p0w r2w) [wName] []
def t12 (entry : State) (d0 pw p0w r2w : BitVec 32) : State :=
  bindValue (t11 entry d0 pw p0w r2w) uName .uint64 (.uint64 (0#64-1#64))

/- The executed run at dlen = 1: one march word through the whole leaf. -/
theorem leaf_run (entry : State) (pd : ArrayPointer) (d0 pw p0w r2w : BitVec 32)
    (hb : entry.arrays dName=some pd) (cap : pd.index≤pd.count)
    (hp : entry.locals pName=some (.uint32,some (.uint32 pw)))
    (hp0i : entry.locals p0iName=some (.uint32,some (.uint32 p0w)))
    (hr2 : entry.locals r2Name=some (.uint32,some (.uint32 r2w)))
    (hdlen : entry.locals dlenName=some (.uint64,some (.uint64 1#64)))
    (pread : Load32 entry.heap pd d0) :
    KeygenWordExec.Exec leafBody entry
      ⟨t12 entry d0 pw p0w r2w, .returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩
      ∧ (t12 entry d0 pw p0w r2w).heap=entry.heap := by
  have heapsT : (t1 entry).heap=entry.heap ∧ (t2 entry).heap=entry.heap ∧
      (t3 entry).heap=entry.heap ∧ (t4 entry).heap=entry.heap ∧
      (t5 entry).heap=entry.heap ∧ (t6 entry).heap=entry.heap ∧
      (t7 entry pw p0w r2w).heap=entry.heap ∧
      (t8 entry d0 pw p0w r2w).heap=entry.heap ∧
      (t9 entry d0 pw p0w r2w).heap=entry.heap ∧
      (t10 entry d0 pw p0w r2w).heap=entry.heap ∧
      (t11 entry d0 pw p0w r2w).heap=entry.heap ∧
      (t12 entry d0 pw p0w r2w).heap=entry.heap := ⟨rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl⟩
  -- slot facts through the chain
  have dlenAt3 : (t3 entry).locals dlenName=some (.uint64,some (.uint64 1#64)) := by
    show (bindValue (t2 entry) xName .uint32 (.int32 0#32)).locals dlenName=_
    rw [ZintSubWord194.bind_other (t2 entry) xName dlenName .uint32 (.int32 0#32) (by decide)]
    show (C99DeclarationStatements.effect .u64 [uName] (t1 entry)).locals dlenName=_
    rw [ZintSubWord194.effect_one_other .u64 uName dlenName (t1 entry) (by decide)]
    show (C99DeclarationStatements.effect .u32 [xName] entry).locals dlenName=_
    rw [ZintSubWord194.effect_one_other .u32 xName dlenName entry (by decide)]
    exact hdlen
  have uDecl3 : (t3 entry).locals uName=some (.uint64,none) := by
    show (bindValue (t2 entry) xName .uint32 (.int32 0#32)).locals uName=_
    rw [ZintSubWord194.bind_other (t2 entry) xName uName .uint32 (.int32 0#32) (by decide)]
    show (C99DeclarationStatements.effect .u64 [uName] (t1 entry)).locals uName=_
    exact ZintSubWord194.effect_one_cell .u64 uName (t1 entry)
  have uAt4 : (t4 entry).locals uName=some (.uint64,some (.uint64 1#64)) := by
    show (bindValue (t3 entry) uName .uint64 (.uint64 1#64)).locals uName=_
    rw [ZintSubWord194.bind_cell (t3 entry) uName .uint64 (.uint64 1#64)]
    rw [convert_u64_one]
  have uAt5 : (t5 entry).locals uName=some (.uint64,some (.uint64 (1#64-1#64))) := by
    show (bindValue (t4 entry) uName .uint64 (.uint64 (1#64-1#64))).locals uName=_
    rw [ZintSubWord194.bind_cell (t4 entry) uName .uint64 (.uint64 (1#64-1#64))]
    rw [convert_self64]
  have uAt5z : (t5 entry).locals uName=some (.uint64,some (.uint64 0#64)) := by
    rw [uAt5]
    rw [show (1#64-1#64 : BitVec 64)=0#64 by decide]
  have xAt3 : (t3 entry).locals xName=some (.uint32,some (.uint32 0#32)) := by
    show (bindValue (t2 entry) xName .uint32 (.int32 0#32)).locals xName=_
    rw [ZintSubWord194.bind_cell (t2 entry) xName .uint32 (.int32 0#32)]
    rw [convert_i32_zero_u32]
  have xAt6 : (t6 entry).locals xName=some (.uint32,some (.uint32 0#32)) := by
    show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals xName=_
    rw [ZintSubWord194.effect_one_other .u32 wName xName (t5 entry) (by decide)]
    show (bindValue (t4 entry) uName .uint64 (.uint64 (1#64-1#64))).locals xName=_
    rw [ZintSubWord194.bind_other (t4 entry) uName xName .uint64 (.uint64 (1#64-1#64))
      (by decide)]
    show (bindValue (t3 entry) uName .uint64 (.uint64 1#64)).locals xName=_
    rw [ZintSubWord194.bind_other (t3 entry) uName xName .uint64 (.uint64 1#64) (by decide)]
    exact xAt3
  have xAt7 (d0 pw p0w r2w : BitVec 32) :
      (t7 entry pw p0w r2w).locals xName=some (.uint32,some
        (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w))) := by
    show (bindValue (t6 entry) xName .uint32
      (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w))).locals xName=_
    rw [ZintSubWord194.bind_cell (t6 entry) xName .uint32
      (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w))]
    rw [convert_self32]
  have xAt9 : (t9 entry d0 pw p0w r2w).locals xName=some (.uint32,some
      (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w))) := by
    show (bindValue (t8 entry d0 pw p0w r2w) wName .uint32
      (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31)))))).locals xName=_
    rw [ZintSubWord194.bind_other (t8 entry d0 pw p0w r2w) wName xName .uint32
      (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31))))) (by decide)]
    show (bindValue (t7 entry pw p0w r2w) wName .uint32 (.uint32 (d0-pw))).locals xName=_
    rw [ZintSubWord194.bind_other (t7 entry pw p0w r2w) wName xName .uint32 (.uint32 (d0-pw))
      (by decide)]
    exact xAt7 d0 pw p0w r2w
  have xAt12 : (t12 entry d0 pw p0w r2w).locals xName=some (.uint32,some
      (.uint32 (unsignedWord d0 pw p0w r2w))) := by
    show (bindValue (t11 entry d0 pw p0w r2w) uName .uint64 (.uint64 (0#64-1#64))).locals xName=_
    rw [ZintSubWord194.bind_other (t11 entry d0 pw p0w r2w) uName xName .uint64
      (.uint64 (0#64-1#64)) (by decide)]
    show (restoreScope (t5 entry) (t10 entry d0 pw p0w r2w) [wName] []).locals xName=_
    rw [ZintSubWord194.restore_one_cell (t5 entry) (t10 entry d0 pw p0w r2w) wName xName
      (by decide)]
    show (bindValue (t9 entry d0 pw p0w r2w) xName .uint32
      (.uint32 (unsignedWord d0 pw p0w r2w))).locals xName=_
    rw [ZintSubWord194.bind_cell (t9 entry d0 pw p0w r2w) xName .uint32
      (.uint32 (unsignedWord d0 pw p0w r2w))]
    rw [convert_self32]
  have pAt6 : (t6 entry).locals pName=some (.uint32,some (.uint32 pw)) := by
    show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals pName=_
    rw [ZintSubWord194.effect_one_other .u32 wName pName (t5 entry) (by decide)]
    show (bindValue (t4 entry) uName .uint64 (.uint64 (1#64-1#64))).locals pName=_
    rw [ZintSubWord194.bind_other (t4 entry) uName pName .uint64 (.uint64 (1#64-1#64))
      (by decide)]
    show (bindValue (t3 entry) uName .uint64 (.uint64 1#64)).locals pName=_
    rw [ZintSubWord194.bind_other (t3 entry) uName pName .uint64 (.uint64 1#64) (by decide)]
    show (bindValue (t2 entry) xName .uint32 (.int32 0#32)).locals pName=_
    rw [ZintSubWord194.bind_other (t2 entry) xName pName .uint32 (.int32 0#32) (by decide)]
    show (C99DeclarationStatements.effect .u64 [uName] (t1 entry)).locals pName=_
    rw [ZintSubWord194.effect_one_other .u64 uName pName (t1 entry) (by decide)]
    show (C99DeclarationStatements.effect .u32 [xName] entry).locals pName=_
    rw [ZintSubWord194.effect_one_other .u32 xName pName entry (by decide)]
    exact hp
  have p0iAt6 : (t6 entry).locals p0iName=some (.uint32,some (.uint32 p0w)) := by
    show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals p0iName=_
    rw [ZintSubWord194.effect_one_other .u32 wName p0iName (t5 entry) (by decide)]
    show (bindValue (t4 entry) uName .uint64 (.uint64 (1#64-1#64))).locals p0iName=_
    rw [ZintSubWord194.bind_other (t4 entry) uName p0iName .uint64 (.uint64 (1#64-1#64))
      (by decide)]
    show (bindValue (t3 entry) uName .uint64 (.uint64 1#64)).locals p0iName=_
    rw [ZintSubWord194.bind_other (t3 entry) uName p0iName .uint64 (.uint64 1#64) (by decide)]
    show (bindValue (t2 entry) xName .uint32 (.int32 0#32)).locals p0iName=_
    rw [ZintSubWord194.bind_other (t2 entry) xName p0iName .uint32 (.int32 0#32) (by decide)]
    show (C99DeclarationStatements.effect .u64 [uName] (t1 entry)).locals p0iName=_
    rw [ZintSubWord194.effect_one_other .u64 uName p0iName (t1 entry) (by decide)]
    show (C99DeclarationStatements.effect .u32 [xName] entry).locals p0iName=_
    rw [ZintSubWord194.effect_one_other .u32 xName p0iName entry (by decide)]
    exact hp0i
  have r2At6 : (t6 entry).locals r2Name=some (.uint32,some (.uint32 r2w)) := by
    show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals r2Name=_
    rw [ZintSubWord194.effect_one_other .u32 wName r2Name (t5 entry) (by decide)]
    show (bindValue (t4 entry) uName .uint64 (.uint64 (1#64-1#64))).locals r2Name=_
    rw [ZintSubWord194.bind_other (t4 entry) uName r2Name .uint64 (.uint64 (1#64-1#64))
      (by decide)]
    show (bindValue (t3 entry) uName .uint64 (.uint64 1#64)).locals r2Name=_
    rw [ZintSubWord194.bind_other (t3 entry) uName r2Name .uint64 (.uint64 1#64) (by decide)]
    show (bindValue (t2 entry) xName .uint32 (.int32 0#32)).locals r2Name=_
    rw [ZintSubWord194.bind_other (t2 entry) xName r2Name .uint32 (.int32 0#32) (by decide)]
    show (C99DeclarationStatements.effect .u64 [uName] (t1 entry)).locals r2Name=_
    rw [ZintSubWord194.effect_one_other .u64 uName r2Name (t1 entry) (by decide)]
    show (C99DeclarationStatements.effect .u32 [xName] entry).locals r2Name=_
    rw [ZintSubWord194.effect_one_other .u32 xName r2Name entry (by decide)]
    exact hr2
  have pAt7 : (t7 entry pw p0w r2w).locals pName=some (.uint32,some (.uint32 pw)) := by
    show (bindValue (t6 entry) xName .uint32
      (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w))).locals pName=_
    rw [ZintSubWord194.bind_other (t6 entry) xName pName .uint32
      (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w)) (by decide)]
    exact pAt6
  have pAt8 : (t8 entry d0 pw p0w r2w).locals pName=some (.uint32,some (.uint32 pw)) := by
    show (bindValue (t7 entry pw p0w r2w) wName .uint32 (.uint32 (d0-pw))).locals pName=_
    rw [ZintSubWord194.bind_other (t7 entry pw p0w r2w) wName pName .uint32 (.uint32 (d0-pw))
      (by decide)]
    exact pAt7
  have pAt9 : (t9 entry d0 pw p0w r2w).locals pName=some (.uint32,some (.uint32 pw)) := by
    show (bindValue (t8 entry d0 pw p0w r2w) wName .uint32
      (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31)))))).locals pName=_
    rw [ZintSubWord194.bind_other (t8 entry d0 pw p0w r2w) wName pName .uint32
      (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31))))) (by decide)]
    exact pAt8
  have wAt8 : (t8 entry d0 pw p0w r2w).locals wName=some (.uint32,some (.uint32 (d0-pw))) := by
    show (bindValue (t7 entry pw p0w r2w) wName .uint32 (.uint32 (d0-pw))).locals wName=_
    rw [ZintSubWord194.bind_cell (t7 entry pw p0w r2w) wName .uint32 (.uint32 (d0-pw))]
    rw [convert_self32]
  have wAt9 : (t9 entry d0 pw p0w r2w).locals wName=some (.uint32,some
      (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31)))))) := by
    show (bindValue (t8 entry d0 pw p0w r2w) wName .uint32
      (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31)))))).locals wName=_
    rw [ZintSubWord194.bind_cell (t8 entry d0 pw p0w r2w) wName .uint32
      (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31)))))]
    rw [convert_self32]
  have wDecl7 : (t7 entry pw p0w r2w).locals wName=some (C99ValueBridge.type .u32,none) := by
    show (bindValue (t6 entry) xName .uint32
      (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w))).locals wName=_
    rw [ZintSubWord194.bind_other (t6 entry) xName wName .uint32
      (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w)) (by decide)]
    show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals wName=_
    exact ZintSubWord194.effect_one_cell .u32 wName (t5 entry)
  have uAt7 : (t7 entry pw p0w r2w).locals uName=some (.uint64,some (.uint64 0#64)) := by
    show (bindValue (t6 entry) xName .uint32
      (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w))).locals uName=_
    rw [ZintSubWord194.bind_other (t6 entry) xName uName .uint32
      (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w)) (by decide)]
    show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals uName=_
    rw [ZintSubWord194.effect_one_other .u32 wName uName (t5 entry) (by decide)]
    exact uAt5z
  have uAt11 : (t11 entry d0 pw p0w r2w).locals uName=some (.uint64,some (.uint64 0#64)) := by
    show (restoreScope (t5 entry) (t10 entry d0 pw p0w r2w) [wName] []).locals uName=_
    rw [ZintSubWord194.restore_one_cell (t5 entry) (t10 entry d0 pw p0w r2w) wName uName
      (by decide)]
    show (bindValue (t9 entry d0 pw p0w r2w) xName .uint32
      (.uint32 (unsignedWord d0 pw p0w r2w))).locals uName=_
    rw [ZintSubWord194.bind_other (t9 entry d0 pw p0w r2w) xName uName .uint32
      (.uint32 (unsignedWord d0 pw p0w r2w)) (by decide)]
    show (bindValue (t8 entry d0 pw p0w r2w) wName .uint32
      (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31)))))).locals uName=_
    rw [ZintSubWord194.bind_other (t8 entry d0 pw p0w r2w) wName uName .uint32
      (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31))))) (by decide)]
    show (bindValue (t7 entry pw p0w r2w) wName .uint32 (.uint32 (d0-pw))).locals uName=_
    rw [ZintSubWord194.bind_other (t7 entry pw p0w r2w) wName uName .uint32 (.uint32 (d0-pw))
      (by decide)]
    exact uAt7
  -- the executed steps
  have h0 : KeygenWordExec.Exec leafDeclX entry ⟨t1 entry,.normal⟩ :=
    ZintSubWord194.declare_run .u32 [xName] entry
  have h1 : KeygenWordExec.Exec leafDeclU (t1 entry) ⟨t2 entry,.normal⟩ :=
    ZintSubWord194.declare_run .u64 [uName] (t1 entry)
  have h2 : KeygenWordExec.Exec leafSetX0 (t2 entry) ⟨t3 entry,.normal⟩ :=
    KeygenWordExec.Exec.assign xName (.scalar (.literal .i32 0)) (t2 entry) .uint32 none
      (.int32 0#32) (ZintSubWord194.effect_one_cell .u32 xName (t1 entry))
      (KeygenWordExpr.Eval.scalar (.literal .i32 0) (.int32 0#32)
        (C99ScalarReference.Eval.literal .int32 0))
  have h3 : KeygenWordExec.Exec leafSetU1 (t3 entry) ⟨t4 entry,.normal⟩ :=
    KeygenWordExec.Exec.assign uName (.scalar (CLogic.Expr.var dlenName)) (t3 entry) .uint64
      none (.uint64 1#64) uDecl3 (cell64 (t3 entry) dlenName 1#64 dlenAt3)
  have it1 : KeygenWordExec.Exec leafDecU (t4 entry) ⟨t5 entry,.normal⟩ :=
    ZintSubWord194.update_run (t4 entry) uName .sub (.literal .i32 1) .uint64
      (.uint64 1#64) (.int32 1#32) (.uint64 (1#64-1#64)) uAt4
      (C99ScalarReference.Eval.literal .int32 1) (minus_one64 1#64)
  have in1 : KeygenWordExec.Exec leafDeclW (t5 entry) ⟨t6 entry,.normal⟩ :=
    ZintSubWord194.declare_run .u32 [wName] (t5 entry)
  have in2 : KeygenWordExec.Exec leafSetXMont (t6 entry) ⟨t7 entry pw p0w r2w,.normal⟩ :=
    KeygenWordExec.Exec.assign xName montExpr (t6 entry) .uint32 (some (.uint32 0#32))
      (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w)) xAt6
      (mont_eval (t6 entry) 0#32 pw p0w r2w xAt6 pAt6 p0iAt6 r2At6)
  have in3 : KeygenWordExec.Exec leafSetWSub (t7 entry pw p0w r2w)
      ⟨t8 entry d0 pw p0w r2w,.normal⟩ :=
    KeygenWordExec.Exec.assign wName wSubExpr (t7 entry pw p0w r2w) .uint32 none
      (.uint32 (d0-pw)) wDecl7
      (wsub_eval (t7 entry pw p0w r2w) pd d0 pw hb cap uAt7 pAt7
        (by rw [heapsT.2.2.2.2.2.2.1]; exact pread))
  have in4 : KeygenWordExec.Exec leafSetWAdd (t8 entry d0 pw p0w r2w)
      ⟨t9 entry d0 pw p0w r2w,.normal⟩ :=
    KeygenWordExec.Exec.assign wName wAddExpr (t8 entry d0 pw p0w r2w) .uint32
      (some (.uint32 (d0-pw)))
      (.uint32 ((d0-pw)+(pw &&& (-((d0-pw)>>>31))))) wAt8 (wadd_eval _ (d0-pw) pw wAt8 pAt8)
  have in5 : KeygenWordExec.Exec leafSetXAdd (t9 entry d0 pw p0w r2w)
      ⟨t10 entry d0 pw p0w r2w,.normal⟩ :=
    KeygenWordExec.Exec.assign xName addExpr (t9 entry d0 pw p0w r2w) .uint32
      (some (.uint32 (KeygenModpWord.montgomery 0#32 r2w pw p0w)))
      (.uint32 (unsignedWord d0 pw p0w r2w)) xAt9
      (add_eval _ (KeygenModpWord.montgomery 0#32 r2w pw p0w)
        ((d0-pw)+(pw &&& (-((d0-pw)>>>31)))) pw xAt9 wAt9 pAt9)
  have in6 : KeygenWordExec.Exec wskip (t10 entry d0 pw p0w r2w)
      ⟨t10 entry d0 pw p0w r2w,.normal⟩ :=
    ZintSubWord194.skip_run (t10 entry d0 pw p0w r2w)
  have innerRun : KeygenWordExec.Exec
      (.seq leafDeclW (.seq leafSetXMont (.seq leafSetWSub (.seq leafSetWAdd
        (.seq leafSetXAdd wskip))))) (t5 entry) ⟨t10 entry d0 pw p0w r2w,.normal⟩ :=
    KeygenWordExec.Exec.seqNormal _ _ (t5 entry) (t6 entry) ⟨t10 entry d0 pw p0w r2w,.normal⟩
      in1
      (KeygenWordExec.Exec.seqNormal _ _ (t6 entry) (t7 entry pw p0w r2w)
        ⟨t10 entry d0 pw p0w r2w,.normal⟩ in2
        (KeygenWordExec.Exec.seqNormal _ _ (t7 entry pw p0w r2w) (t8 entry d0 pw p0w r2w)
          ⟨t10 entry d0 pw p0w r2w,.normal⟩ in3
          (KeygenWordExec.Exec.seqNormal _ _ (t8 entry d0 pw p0w r2w)
            (t9 entry d0 pw p0w r2w) ⟨t10 entry d0 pw p0w r2w,.normal⟩ in4
            (KeygenWordExec.Exec.seqNormal _ _ (t9 entry d0 pw p0w r2w)
              (t10 entry d0 pw p0w r2w) ⟨t10 entry d0 pw p0w r2w,.normal⟩ in5 in6))))
  have scopeRun : KeygenWordExec.Exec (.scope [wName]
      (.seq leafDeclW (.seq leafSetXMont (.seq leafSetWSub (.seq leafSetWAdd
        (.seq leafSetXAdd wskip)))))) (t5 entry) ⟨t11 entry d0 pw p0w r2w,.normal⟩ :=
    KeygenWordExec.Exec.scope [wName] _ (t5 entry) ⟨t10 entry d0 pw p0w r2w,.normal⟩ innerRun
  have bodyRun : KeygenWordExec.Exec leafLoopBody (t4 entry)
      ⟨t11 entry d0 pw p0w r2w,.normal⟩ :=
    KeygenWordExec.Exec.seqNormal _ _ (t4 entry) (t5 entry)
      ⟨t11 entry d0 pw p0w r2w,.normal⟩ it1 scopeRun
  have guard4 : KeygenWordExpr.Eval (t4 entry) leafGuard
      (C99ScalarReference.boolean true) :=
    KeygenWordExpr.Eval.cmp .gt (.scalar (CLogic.Expr.var uName)) (.scalar (.literal .i32 0))
      (.uint64 1#64) (.int32 0#32) (C99ScalarReference.boolean true)
      (cell64 (t4 entry) uName 1#64 uAt4)
      (KeygenWordExpr.Eval.scalar (.literal .i32 0) (.int32 0#32)
        (C99ScalarReference.Eval.literal .int32 0)) gt_one_true
  have guard11 : KeygenWordExpr.Eval (t11 entry d0 pw p0w r2w) leafGuard
      (C99ScalarReference.boolean false) :=
    KeygenWordExpr.Eval.cmp .gt (.scalar (CLogic.Expr.var uName)) (.scalar (.literal .i32 0))
      (.uint64 0#64) (.int32 0#32) (C99ScalarReference.boolean false)
      (cell64 (t11 entry d0 pw p0w r2w) uName 0#64 uAt11)
      (KeygenWordExpr.Eval.scalar (.literal .i32 0) (.int32 0#32)
        (C99ScalarReference.Eval.literal .int32 0)) gt_zero_false
  have restRun : KeygenWordExec.Exec leafLoop (t11 entry d0 pw p0w r2w)
      ⟨t11 entry d0 pw p0w r2w,.normal⟩ :=
    KeygenWordExec.Exec.loopFalse leafGuard leafLoopBody wskip
      (t11 entry d0 pw p0w r2w) (C99ScalarReference.boolean false) guard11
      (boolean_zero _ rfl)
  have updateRun : KeygenWordExec.Exec wskip (t11 entry d0 pw p0w r2w)
      ⟨t11 entry d0 pw p0w r2w,.normal⟩ :=
    ZintSubWord194.skip_run (t11 entry d0 pw p0w r2w)
  have loopRun : KeygenWordExec.Exec leafLoop (t4 entry) ⟨t11 entry d0 pw p0w r2w,.normal⟩ :=
    KeygenWordExec.Exec.loopNormal leafGuard leafLoopBody wskip (t4 entry)
      (t11 entry d0 pw p0w r2w) (t11 entry d0 pw p0w r2w) ⟨t11 entry d0 pw p0w r2w,.normal⟩
      (C99ScalarReference.boolean true) guard4 (by decide) bodyRun updateRun restRun
  have it2 : KeygenWordExec.Exec leafDecU (t11 entry d0 pw p0w r2w)
      ⟨t12 entry d0 pw p0w r2w,.normal⟩ :=
    ZintSubWord194.update_run (t11 entry d0 pw p0w r2w) uName .sub (.literal .i32 1) .uint64
      (.uint64 0#64) (.int32 1#32) (.uint64 (0#64-1#64)) uAt11
      (C99ScalarReference.Eval.literal .int32 1) dec_zero
  have loopDecRun : KeygenWordExec.Exec (.seq leafLoop leafDecU) (t4 entry)
      ⟨t12 entry d0 pw p0w r2w,.normal⟩ :=
    KeygenWordExec.Exec.seqNormal _ _ (t4 entry) (t11 entry d0 pw p0w r2w)
      ⟨t12 entry d0 pw p0w r2w,.normal⟩ loopRun it2
  have retRun : KeygenWordExec.Exec leafRetX (t12 entry d0 pw p0w r2w)
      ⟨t12 entry d0 pw p0w r2w,.returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩ :=
    KeygenWordExec.Exec.ret (.scalar (CLogic.Expr.var xName)) (t12 entry d0 pw p0w r2w)
      (.uint32 (unsignedWord d0 pw p0w r2w)) (cell32 _ xName _ xAt12)
  have tailRun : KeygenWordExec.Exec (.seq leafRetX wskip) (t12 entry d0 pw p0w r2w)
      ⟨t12 entry d0 pw p0w r2w,.returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩ :=
    KeygenWordExec.Exec.seqExit _ _ (t12 entry d0 pw p0w r2w)
      ⟨t12 entry d0 pw p0w r2w,.returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩
      retRun (by intro h; cases h)
  refine ⟨?_,?_⟩
  · exact KeygenWordExec.Exec.seqNormal _ _ entry (t1 entry)
      ⟨t12 entry d0 pw p0w r2w,.returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩ h0
      (KeygenWordExec.Exec.seqNormal _ _ (t1 entry) (t2 entry)
        ⟨t12 entry d0 pw p0w r2w,.returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩ h1
        (KeygenWordExec.Exec.seqNormal _ _ (t2 entry) (t3 entry)
          ⟨t12 entry d0 pw p0w r2w,.returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩ h2
          (KeygenWordExec.Exec.seqNormal _ _ (t3 entry) (t4 entry)
            ⟨t12 entry d0 pw p0w r2w,.returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩
            h3
            (KeygenWordExec.Exec.seqNormal _ _ (t4 entry) (t12 entry d0 pw p0w r2w)
              ⟨t12 entry d0 pw p0w r2w,
                .returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩
              loopDecRun tailRun))))
  · exact heapsT.2.2.2.2.2.2.2.2.2.2.2

/- Spine statement pieces, bound to the MakeFgAddPrimeShape194 pinned
   projections by decide (pinned shapes; no new parse recognition). -/
def wskipZ : KeygenZintCall.Stmt := .word (.modular (.base .skip))
def zeroGuard : KeygenWordExpr.Expr :=
  .cmp .eq (.scalar (CLogic.Expr.var dlenName)) (.scalar (.literal .i32 0))
def zeroYes : KeygenZintCall.Stmt :=
  .scope [] [] (.seq (.word (.ret (.scalar (.literal .i32 0)))) wskipZ)
def zeroNo : KeygenZintCall.Stmt := wskipZ
def leafArgs : List Arg :=
  [ .pointer dName C99ProcedureParser.zero,
    .scalar (CLogic.Expr.var dlenName),
    .scalar (CLogic.Expr.var pName),
    .scalar (CLogic.Expr.var p0iName),
    .scalar (CLogic.Expr.var r2Name) ]
def subExpr : KeygenWordExpr.Expr := .call3 "modp_sub".toList
  (.scalar (CLogic.Expr.var zName))
  (.bin .band (.scalar (CLogic.Expr.var rxName))
    (.neg (.bin .shr (.load32 dName (CLogic.Expr.bin .sub (CLogic.Expr.var dlenName)
      (.literal .i32 1))) (.scalar (.literal .i32 30)))))
  (.scalar (CLogic.Expr.var pName))
def subAssign : KeygenZintCall.Stmt := .word (.assign zName subExpr)
def retZ : KeygenZintCall.Stmt := .word (.ret (.scalar (CLogic.Expr.var zName)))
def declZ : KeygenZintCall.Stmt := .word (.modular (.base (.scalar (.declare .u32 [zName]))))

theorem ms_decl_shape : MakeFgAddPrimeShape194.msDeclZ = declZ := by decide
theorem ms_zero_shape :
    MakeFgAddPrimeShape194.msZeroBranch = .branch zeroGuard zeroYes zeroNo := by decide
theorem ms_leaf_shape :
    MakeFgAddPrimeShape194.msReduceCall = .call (.leaf .reduce) leafArgs (.into zName) := by
  decide
theorem ms_sub_shape : MakeFgAddPrimeShape194.msSubAssign = subAssign := by decide
theorem ms_ret_shape : MakeFgAddPrimeShape194.msRetZ = retZ := by decide

/- The modSigned entry state of one march word: fresh frame, then Rx :=
   rxw, R2 := r2w, p0i := p0w, p := pw, dlen := 1 (binding order Rx, R2,
   p0i, p, dlen) and the walked pointer d := pd. -/
def msFresh (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
def msRx (s : State) (rxw : BitVec 32) : State :=
  bindValue (msFresh s) rxName .uint32 (.uint32 rxw)
def msR2 (s : State) (r2w rxw : BitVec 32) : State :=
  bindValue (msRx s rxw) r2Name .uint32 (.uint32 r2w)
def msP0i (s : State) (p0w r2w rxw : BitVec 32) : State :=
  bindValue (msR2 s r2w rxw) p0iName .uint32 (.uint32 p0w)
def msP (s : State) (pw p0w r2w rxw : BitVec 32) : State :=
  bindValue (msP0i s p0w r2w rxw) pName .uint32 (.uint32 pw)
def msDlen (s : State) (pw p0w r2w rxw : BitVec 32) : State :=
  bindValue (msP s pw p0w r2w rxw) dlenName .uint64 (.uint64 1#64)
def msEntry (s : State) (pd : ArrayPointer) (pw p0w r2w rxw : BitVec 32) : State :=
  bindPointer (msDlen s pw p0w r2w rxw) dName pd

theorem ms_entry_p (s : State) (pd : ArrayPointer) (pw p0w r2w rxw : BitVec 32) :
    (msEntry s pd pw p0w r2w rxw).locals pName=some (.uint32,some (.uint32 pw)) := by
  have hdlen : (msDlen s pw p0w r2w rxw).locals pName=some (.uint32,some (.uint32 pw)) := by
    show (bindValue (msP s pw p0w r2w rxw) dlenName .uint64 (.uint64 1#64)).locals pName=_
    rw [ZintSubWord194.bind_other (msP s pw p0w r2w rxw) dlenName pName .uint64 (.uint64 1#64)
      (by decide)]
    show (bindValue (msP0i s p0w r2w rxw) pName .uint32 (.uint32 pw)).locals pName=_
    rw [ZintSubWord194.bind_cell (msP0i s p0w r2w rxw) pName .uint32 (.uint32 pw)]
    rw [convert_self32]
  show (bindPointer (msDlen s pw p0w r2w rxw) dName pd).locals pName=_
  exact hdlen

theorem ms_entry_p0i (s : State) (pd : ArrayPointer) (pw p0w r2w rxw : BitVec 32) :
    (msEntry s pd pw p0w r2w rxw).locals p0iName=some (.uint32,some (.uint32 p0w)) := by
  have hdlen : (msDlen s pw p0w r2w rxw).locals p0iName=some (.uint32,some (.uint32 p0w)) := by
    show (bindValue (msP s pw p0w r2w rxw) dlenName .uint64 (.uint64 1#64)).locals p0iName=_
    rw [ZintSubWord194.bind_other (msP s pw p0w r2w rxw) dlenName p0iName .uint64
      (.uint64 1#64) (by decide)]
    show (bindValue (msP0i s p0w r2w rxw) pName .uint32 (.uint32 pw)).locals p0iName=_
    rw [ZintSubWord194.bind_other (msP0i s p0w r2w rxw) pName p0iName .uint32 (.uint32 pw)
      (by decide)]
    show (bindValue (msR2 s r2w rxw) p0iName .uint32 (.uint32 p0w)).locals p0iName=_
    rw [ZintSubWord194.bind_cell (msR2 s r2w rxw) p0iName .uint32 (.uint32 p0w)]
    rw [convert_self32]
  show (bindPointer (msDlen s pw p0w r2w rxw) dName pd).locals p0iName=_
  exact hdlen

theorem ms_entry_r2 (s : State) (pd : ArrayPointer) (pw p0w r2w rxw : BitVec 32) :
    (msEntry s pd pw p0w r2w rxw).locals r2Name=some (.uint32,some (.uint32 r2w)) := by
  have hdlen : (msDlen s pw p0w r2w rxw).locals r2Name=some (.uint32,some (.uint32 r2w)) := by
    show (bindValue (msP s pw p0w r2w rxw) dlenName .uint64 (.uint64 1#64)).locals r2Name=_
    rw [ZintSubWord194.bind_other (msP s pw p0w r2w rxw) dlenName r2Name .uint64 (.uint64 1#64)
      (by decide)]
    show (bindValue (msP0i s p0w r2w rxw) pName .uint32 (.uint32 pw)).locals r2Name=_
    rw [ZintSubWord194.bind_other (msP0i s p0w r2w rxw) pName r2Name .uint32 (.uint32 pw)
      (by decide)]
    show (bindValue (msR2 s r2w rxw) p0iName .uint32 (.uint32 p0w)).locals r2Name=_
    rw [ZintSubWord194.bind_other (msR2 s r2w rxw) p0iName r2Name .uint32 (.uint32 p0w)
      (by decide)]
    show (bindValue (msRx s rxw) r2Name .uint32 (.uint32 r2w)).locals r2Name=_
    rw [ZintSubWord194.bind_cell (msRx s rxw) r2Name .uint32 (.uint32 r2w)]
    rw [convert_self32]
  show (bindPointer (msDlen s pw p0w r2w rxw) dName pd).locals r2Name=_
  exact hdlen

theorem ms_entry_rx (s : State) (pd : ArrayPointer) (pw p0w r2w rxw : BitVec 32) :
    (msEntry s pd pw p0w r2w rxw).locals rxName=some (.uint32,some (.uint32 rxw)) := by
  have hdlen : (msDlen s pw p0w r2w rxw).locals rxName=some (.uint32,some (.uint32 rxw)) := by
    show (bindValue (msP s pw p0w r2w rxw) dlenName .uint64 (.uint64 1#64)).locals rxName=_
    rw [ZintSubWord194.bind_other (msP s pw p0w r2w rxw) dlenName rxName .uint64 (.uint64 1#64)
      (by decide)]
    show (bindValue (msP0i s p0w r2w rxw) pName .uint32 (.uint32 pw)).locals rxName=_
    rw [ZintSubWord194.bind_other (msP0i s p0w r2w rxw) pName rxName .uint32 (.uint32 pw)
      (by decide)]
    show (bindValue (msR2 s r2w rxw) p0iName .uint32 (.uint32 p0w)).locals rxName=_
    rw [ZintSubWord194.bind_other (msR2 s r2w rxw) p0iName rxName .uint32 (.uint32 p0w)
      (by decide)]
    show (bindValue (msRx s rxw) r2Name .uint32 (.uint32 r2w)).locals rxName=_
    rw [ZintSubWord194.bind_other (msRx s rxw) r2Name rxName .uint32 (.uint32 r2w)
      (by decide)]
    show (bindValue (msFresh s) rxName .uint32 (.uint32 rxw)).locals rxName=_
    rw [ZintSubWord194.bind_cell (msFresh s) rxName .uint32 (.uint32 rxw)]
    rw [convert_self32]
  show (bindPointer (msDlen s pw p0w r2w rxw) dName pd).locals rxName=_
  exact hdlen

theorem ms_entry_dlen (s : State) (pd : ArrayPointer) (pw p0w r2w rxw : BitVec 32) :
    (msEntry s pd pw p0w r2w rxw).locals dlenName=some (.uint64,some (.uint64 1#64)) := by
  have hdlen : (msDlen s pw p0w r2w rxw).locals dlenName=some (.uint64,some (.uint64 1#64)) := by
    show (bindValue (msP s pw p0w r2w rxw) dlenName .uint64 (.uint64 1#64)).locals dlenName=_
    rw [ZintSubWord194.bind_cell (msP s pw p0w r2w rxw) dlenName .uint64 (.uint64 1#64)]
    rw [convert_u64_one]
  show (bindPointer (msDlen s pw p0w r2w rxw) dName pd).locals dlenName=_
  exact hdlen

theorem ms_entry_arrays (s : State) (pd : ArrayPointer) (pw p0w r2w rxw : BitVec 32) :
    (msEntry s pd pw p0w r2w rxw).arrays dName=some pd := by
  simp [msEntry,bindPointer,dName]

theorem ms_entry_heap (s : State) (pd : ArrayPointer) (pw p0w r2w rxw : BitVec 32) :
    (msEntry s pd pw p0w r2w rxw).heap=s.heap := rfl

/- Binding of the modSigned call arguments at the walk shape
   (MakeFgAddPrimeShape194.modArgs). -/
theorem bind_ms (before : State) (pd : ArrayPointer) (pw p0w r2w rxw : BitVec 32)
    (xb : before.arrays "x".toList=some pd) (cap : pd.index≤pd.count)
    (hslen : before.locals "slen".toList=some (.uint64,some (.uint64 1#64)))
    (hp : before.locals "p".toList=some (.uint32,some (.uint32 pw)))
    (hp0i : before.locals "p0i".toList=some (.uint32,some (.uint32 p0w)))
    (hr2 : before.locals "R2".toList=some (.uint32,some (.uint32 r2w)))
    (hrx : before.locals "Rx".toList=some (.uint32,some (.uint32 rxw))) :
    C99ArrayReference.Bind before (KeygenZintCall.params .modSigned)
      MakeFgAddPrimeShape194.modArgs (msEntry before pd pw p0w r2w rxw) := by
  have zeroValue : C99ArrayReference.scalar before C99ProcedureParser.zero (.uint64 0#64) :=
    C99ScalarReference.Eval.literal .uint64 0
  have walked : Pointer before "x".toList C99ProcedureParser.zero pd :=
    .add "x".toList C99ProcedureParser.zero pd pd (.uint64 0#64) xb zeroValue (by decide)
      (C99MemoryReference.PointerAdd.within pd 0 cap)
  have s1 : C99ArrayReference.scalar before (CLogic.Expr.var "slen".toList) (.uint64 1#64) :=
    C99ScalarReference.Eval.variable "slen".toList .uint64 (.uint64 1#64) hslen
  have s2 : C99ArrayReference.scalar before (CLogic.Expr.var "p".toList) (.uint32 pw) :=
    C99ScalarReference.Eval.variable "p".toList .uint32 (.uint32 pw) hp
  have s3 : C99ArrayReference.scalar before (CLogic.Expr.var "p0i".toList) (.uint32 p0w) :=
    C99ScalarReference.Eval.variable "p0i".toList .uint32 (.uint32 p0w) hp0i
  have s4 : C99ArrayReference.scalar before (CLogic.Expr.var "R2".toList) (.uint32 r2w) :=
    C99ScalarReference.Eval.variable "R2".toList .uint32 (.uint32 r2w) hr2
  have s5 : C99ArrayReference.scalar before (CLogic.Expr.var "Rx".toList) (.uint32 rxw) :=
    C99ScalarReference.Eval.variable "Rx".toList .uint32 (.uint32 rxw) hrx
  refine C99ArrayReference.Bind.pointer dName "x".toList C99ProcedureParser.zero pd
    [C99ArrayReference.Param.scalar .uint64 dlenName,
      C99ArrayReference.Param.scalar .uint32 pName,
      C99ArrayReference.Param.scalar .uint32 p0iName,
      C99ArrayReference.Param.scalar .uint32 r2Name,
      C99ArrayReference.Param.scalar .uint32 rxName]
    [Arg.scalar (CLogic.Expr.var "slen".toList), Arg.scalar (CLogic.Expr.var "p".toList),
      Arg.scalar (CLogic.Expr.var "p0i".toList), Arg.scalar (CLogic.Expr.var "R2".toList),
      Arg.scalar (CLogic.Expr.var "Rx".toList)]
    _ walked ?_
  refine C99ArrayReference.Bind.scalar .uint64 dlenName (CLogic.Expr.var "slen".toList)
    [C99ArrayReference.Param.scalar .uint32 pName,
      C99ArrayReference.Param.scalar .uint32 p0iName,
      C99ArrayReference.Param.scalar .uint32 r2Name,
      C99ArrayReference.Param.scalar .uint32 rxName]
    [Arg.scalar (CLogic.Expr.var "p".toList), Arg.scalar (CLogic.Expr.var "p0i".toList),
      Arg.scalar (CLogic.Expr.var "R2".toList), Arg.scalar (CLogic.Expr.var "Rx".toList)]
    _ (.uint64 1#64) s1 ?_
  refine C99ArrayReference.Bind.scalar .uint32 pName (CLogic.Expr.var "p".toList)
    [C99ArrayReference.Param.scalar .uint32 p0iName,
      C99ArrayReference.Param.scalar .uint32 r2Name,
      C99ArrayReference.Param.scalar .uint32 rxName]
    [Arg.scalar (CLogic.Expr.var "p0i".toList), Arg.scalar (CLogic.Expr.var "R2".toList),
      Arg.scalar (CLogic.Expr.var "Rx".toList)]
    _ (.uint32 pw) s2 ?_
  refine C99ArrayReference.Bind.scalar .uint32 p0iName (CLogic.Expr.var "p0i".toList)
    [C99ArrayReference.Param.scalar .uint32 r2Name,
      C99ArrayReference.Param.scalar .uint32 rxName]
    [Arg.scalar (CLogic.Expr.var "R2".toList), Arg.scalar (CLogic.Expr.var "Rx".toList)]
    _ (.uint32 p0w) s3 ?_
  refine C99ArrayReference.Bind.scalar .uint32 r2Name (CLogic.Expr.var "R2".toList)
    [C99ArrayReference.Param.scalar .uint32 rxName]
    [Arg.scalar (CLogic.Expr.var "Rx".toList)]
    _ (.uint32 r2w) s4 ?_
  refine C99ArrayReference.Bind.scalar .uint32 rxName (CLogic.Expr.var "Rx".toList)
    [] [] _ (.uint32 rxw) s5 ?_
  exact C99ArrayReference.Bind.nil

/- The executed run of the whole spine at dlen = 1, per march word. -/
def msZ (entry : State) : State := C99DeclarationStatements.effect .u32 [zName] entry
def msU (entry : State) (d0 pw p0w r2w : BitVec 32) : State :=
  bindValue (msZ entry) zName .uint32 (.uint32 (unsignedWord d0 pw p0w r2w))
def msV (entry : State) (d0 pw p0w r2w rxw : BitVec 32) : State :=
  bindValue (msU entry d0 pw p0w r2w) zName .uint32 (.uint32 (modSignedWord d0 pw p0w r2w rxw))

theorem spine_run (entry : State) (pd : ArrayPointer) (d0 pw p0w r2w rxw : BitVec 32)
    (hb : entry.arrays dName=some pd) (cap : pd.index≤pd.count)
    (hp : entry.locals pName=some (.uint32,some (.uint32 pw)))
    (hp0i : entry.locals p0iName=some (.uint32,some (.uint32 p0w)))
    (hr2 : entry.locals r2Name=some (.uint32,some (.uint32 r2w)))
    (hrx : entry.locals rxName=some (.uint32,some (.uint32 rxw)))
    (hdlen : entry.locals dlenName=some (.uint64,some (.uint64 1#64)))
    (pread : Load32 entry.heap pd d0) :
    KeygenZintCall.Exec MakeFgAddPrimeShape194.msBody entry
      ⟨msV entry d0 pw p0w r2w rxw,
        .returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))⟩ := by
  -- slots kept through the z declaration
  have zDecl : (msZ entry).locals zName=some (.uint32,none) :=
    ZintSubWord194.effect_one_cell .u32 zName entry
  have dlenAtZ : (msZ entry).locals dlenName=some (.uint64,some (.uint64 1#64)) := by
    show (C99DeclarationStatements.effect .u32 [zName] entry).locals dlenName=_
    rw [ZintSubWord194.effect_one_other .u32 zName dlenName entry (by decide)]
    exact hdlen
  have pAtZ : (msZ entry).locals pName=some (.uint32,some (.uint32 pw)) := by
    show (C99DeclarationStatements.effect .u32 [zName] entry).locals pName=_
    rw [ZintSubWord194.effect_one_other .u32 zName pName entry (by decide)]
    exact hp
  have p0iAtZ : (msZ entry).locals p0iName=some (.uint32,some (.uint32 p0w)) := by
    show (C99DeclarationStatements.effect .u32 [zName] entry).locals p0iName=_
    rw [ZintSubWord194.effect_one_other .u32 zName p0iName entry (by decide)]
    exact hp0i
  have r2AtZ : (msZ entry).locals r2Name=some (.uint32,some (.uint32 r2w)) := by
    show (C99DeclarationStatements.effect .u32 [zName] entry).locals r2Name=_
    rw [ZintSubWord194.effect_one_other .u32 zName r2Name entry (by decide)]
    exact hr2
  have rxAtZ : (msZ entry).locals rxName=some (.uint32,some (.uint32 rxw)) := by
    show (C99DeclarationStatements.effect .u32 [zName] entry).locals rxName=_
    rw [ZintSubWord194.effect_one_other .u32 zName rxName entry (by decide)]
    exact hrx
  have arraysZ : (msZ entry).arrays dName=some pd := hb
  -- the leaf call binding at the spine state
  have bindLeaf : C99ArrayReference.Bind (msZ entry) (KeygenZintCall.params (.leaf .reduce))
      leafArgs (leafEntry (msZ entry) pd pw p0w r2w) := by
    have zeroValue : C99ArrayReference.scalar (msZ entry) C99ProcedureParser.zero (.uint64 0#64) :=
      C99ScalarReference.Eval.literal .uint64 0
    have walked : Pointer (msZ entry) dName C99ProcedureParser.zero pd :=
      .add dName C99ProcedureParser.zero pd pd (.uint64 0#64) arraysZ zeroValue (by decide)
        (C99MemoryReference.PointerAdd.within pd 0 cap)
    have a1 : C99ArrayReference.scalar (msZ entry) (CLogic.Expr.var dlenName) (.uint64 1#64) :=
      C99ScalarReference.Eval.variable dlenName .uint64 (.uint64 1#64) dlenAtZ
    have a2 : C99ArrayReference.scalar (msZ entry) (CLogic.Expr.var pName) (.uint32 pw) :=
      C99ScalarReference.Eval.variable pName .uint32 (.uint32 pw) pAtZ
    have a3 : C99ArrayReference.scalar (msZ entry) (CLogic.Expr.var p0iName) (.uint32 p0w) :=
      C99ScalarReference.Eval.variable p0iName .uint32 (.uint32 p0w) p0iAtZ
    have a4 : C99ArrayReference.scalar (msZ entry) (CLogic.Expr.var r2Name) (.uint32 r2w) :=
      C99ScalarReference.Eval.variable r2Name .uint32 (.uint32 r2w) r2AtZ
    refine C99ArrayReference.Bind.pointer dName dName C99ProcedureParser.zero pd
      [C99ArrayReference.Param.scalar .uint64 dlenName,
        C99ArrayReference.Param.scalar .uint32 pName,
        C99ArrayReference.Param.scalar .uint32 p0iName,
        C99ArrayReference.Param.scalar .uint32 r2Name]
      [Arg.scalar (CLogic.Expr.var dlenName), Arg.scalar (CLogic.Expr.var pName),
        Arg.scalar (CLogic.Expr.var p0iName), Arg.scalar (CLogic.Expr.var r2Name)]
      _ walked ?_
    refine C99ArrayReference.Bind.scalar .uint64 dlenName (CLogic.Expr.var dlenName)
      [C99ArrayReference.Param.scalar .uint32 pName,
        C99ArrayReference.Param.scalar .uint32 p0iName,
        C99ArrayReference.Param.scalar .uint32 r2Name]
      [Arg.scalar (CLogic.Expr.var pName), Arg.scalar (CLogic.Expr.var p0iName),
        Arg.scalar (CLogic.Expr.var r2Name)]
      _ (.uint64 1#64) a1 ?_
    refine C99ArrayReference.Bind.scalar .uint32 pName (CLogic.Expr.var pName)
      [C99ArrayReference.Param.scalar .uint32 p0iName,
        C99ArrayReference.Param.scalar .uint32 r2Name]
      [Arg.scalar (CLogic.Expr.var p0iName), Arg.scalar (CLogic.Expr.var r2Name)]
      _ (.uint32 pw) a2 ?_
    refine C99ArrayReference.Bind.scalar .uint32 p0iName (CLogic.Expr.var p0iName)
      [C99ArrayReference.Param.scalar .uint32 r2Name] [Arg.scalar (CLogic.Expr.var r2Name)]
      _ (.uint32 p0w) a3 ?_
    refine C99ArrayReference.Bind.scalar .uint32 r2Name (CLogic.Expr.var r2Name)
      [] [] _ (.uint32 r2w) a4 ?_
    exact C99ArrayReference.Bind.nil
  have leafRun : KeygenWordExec.Exec leafBody (leafEntry (msZ entry) pd pw p0w r2w)
        ⟨t12 (leafEntry (msZ entry) pd pw p0w r2w) d0 pw p0w r2w,
          .returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩ ∧
      (t12 (leafEntry (msZ entry) pd pw p0w r2w) d0 pw p0w r2w).heap=
        (leafEntry (msZ entry) pd pw p0w r2w).heap :=
    leaf_run (leafEntry (msZ entry) pd pw p0w r2w) pd d0 pw p0w r2w
      (leaf_entry_arrays (msZ entry) pd pw p0w r2w) cap
      (leaf_entry_p (msZ entry) pd pw p0w r2w)
      (leaf_entry_p0i (msZ entry) pd pw p0w r2w)
      (leaf_entry_r2 (msZ entry) pd pw p0w r2w)
      (leaf_entry_dlen (msZ entry) pd pw p0w r2w)
      (by rw [leaf_entry_heap]; exact pread)
  have callHeap : (t12 (leafEntry (msZ entry) pd pw p0w r2w) d0 pw p0w r2w).heap=
      (msZ entry).heap :=
    Eq.trans leafRun.2 (leaf_entry_heap (msZ entry) pd pw p0w r2w)
  have leafBodyRun : KeygenZintCall.Exec (KeygenZintCall.calleeBody (.leaf .reduce))
      (leafEntry (msZ entry) pd pw p0w r2w)
      ⟨t12 (leafEntry (msZ entry) pd pw p0w r2w) d0 pw p0w r2w,
        .returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩ :=
    KeygenZintCall.Exec.word (KeygenZintLeaves.code .reduce)
      (leafEntry (msZ entry) pd pw p0w r2w)
      ⟨t12 (leafEntry (msZ entry) pd pw p0w r2w) d0 pw p0w r2w,
        .returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩ leafRun.1
  have leafReturn : C99ProcedureReference.ReturnValue (some .uint32)
      (.returned (some (.uint32 (unsignedWord d0 pw p0w r2w))))
      (some (.uint32 (unsignedWord d0 pw p0w r2w))) := by
    have h := C99ProcedureReference.ReturnValue.value .uint32
      (.uint32 (unsignedWord d0 pw p0w r2w))
    rw [convert_self32] at h
    exact h
  have callRun : KeygenZintCall.Exec MakeFgAddPrimeShape194.msReduceCall (msZ entry)
      ⟨msU entry d0 pw p0w r2w,.normal⟩ := by
    rw [ms_leaf_shape]
    refine KeygenZintCall.Exec.call (msZ entry) (.leaf .reduce) leafArgs (.into zName)
      (leafEntry (msZ entry) pd pw p0w r2w)
      ⟨t12 (leafEntry (msZ entry) pd pw p0w r2w) d0 pw p0w r2w,
        .returned (some (.uint32 (unsignedWord d0 pw p0w r2w)))⟩
      (some (.uint32 (unsignedWord d0 pw p0w r2w))) (msU entry d0 pw p0w r2w)
      bindLeaf leafBodyRun leafReturn ?_
    rw [callHeap]
    exact KeygenZintCall.ReceiveC.into zName (msZ entry) .uint32 none
      (.uint32 (unsignedWord d0 pw p0w r2w)) zDecl
  -- slots at the post-call state
  have zAtU : (msU entry d0 pw p0w r2w).locals zName=some (.uint32,some
      (.uint32 (unsignedWord d0 pw p0w r2w))) := by
    show (bindValue (msZ entry) zName .uint32 (.uint32 (unsignedWord d0 pw p0w r2w))).locals
      zName=_
    rw [ZintSubWord194.bind_cell (msZ entry) zName .uint32 (.uint32 (unsignedWord d0 pw p0w r2w))]
    rw [convert_self32]
  have zAtV : (msV entry d0 pw p0w r2w rxw).locals zName=some (.uint32,some
      (.uint32 (modSignedWord d0 pw p0w r2w rxw))) := by
    show (bindValue (msU entry d0 pw p0w r2w) zName .uint32
      (.uint32 (modSignedWord d0 pw p0w r2w rxw))).locals zName=_
    rw [ZintSubWord194.bind_cell (msU entry d0 pw p0w r2w) zName .uint32
      (.uint32 (modSignedWord d0 pw p0w r2w rxw))]
    rw [convert_self32]
  have rxAtU : (msU entry d0 pw p0w r2w).locals rxName=some (.uint32,some (.uint32 rxw)) := by
    show (bindValue (msZ entry) zName .uint32 (.uint32 (unsignedWord d0 pw p0w r2w))).locals
      rxName=_
    rw [ZintSubWord194.bind_other (msZ entry) zName rxName .uint32
      (.uint32 (unsignedWord d0 pw p0w r2w)) (by decide)]
    exact rxAtZ
  have pAtU : (msU entry d0 pw p0w r2w).locals pName=some (.uint32,some (.uint32 pw)) := by
    show (bindValue (msZ entry) zName .uint32 (.uint32 (unsignedWord d0 pw p0w r2w))).locals
      pName=_
    rw [ZintSubWord194.bind_other (msZ entry) zName pName .uint32
      (.uint32 (unsignedWord d0 pw p0w r2w)) (by decide)]
    exact pAtZ
  have dlenAtU : (msU entry d0 pw p0w r2w).locals dlenName=some (.uint64,some (.uint64 1#64)) := by
    show (bindValue (msZ entry) zName .uint32 (.uint32 (unsignedWord d0 pw p0w r2w))).locals
      dlenName=_
    rw [ZintSubWord194.bind_other (msZ entry) zName dlenName .uint32
      (.uint32 (unsignedWord d0 pw p0w r2w)) (by decide)]
    exact dlenAtZ
  have arraysU : (msU entry d0 pw p0w r2w).arrays dName=some pd := hb
  -- the sign correction evaluation
  have idxEval : C99ArrayReference.scalar (msU entry d0 pw p0w r2w)
      (CLogic.Expr.bin .sub (CLogic.Expr.var dlenName) (.literal .i32 1)) (.uint64 0#64) :=
    C99ScalarReference.Eval.arithmetic .minus _ _
      (.uint64 1#64) (.int32 1#32) (.uint64 0#64)
      (C99ScalarReference.Eval.variable dlenName .uint64 (.uint64 1#64) dlenAtU)
      (C99ScalarReference.Eval.literal .int32 1) dec_one
  have idxPointer : Pointer (msU entry d0 pw p0w r2w)
      dName (CLogic.Expr.bin .sub (CLogic.Expr.var dlenName) (.literal .i32 1)) pd :=
    .add dName _ pd pd (.uint64 0#64) arraysU idxEval (by decide)
      (C99MemoryReference.PointerAdd.within pd 0 cap)
  have signEval : KeygenWordExpr.Eval (msU entry d0 pw p0w r2w)
      (.bin .band (.scalar (CLogic.Expr.var rxName))
        (.neg (.bin .shr (.load32 dName (CLogic.Expr.bin .sub (CLogic.Expr.var dlenName)
          (.literal .i32 1))) (.scalar (.literal .i32 30)))))
      (.uint32 (signWord rxw d0)) := by
    refine KeygenWordExpr.Eval.bin .band (.scalar (CLogic.Expr.var rxName))
      (.neg (.bin .shr (.load32 dName (CLogic.Expr.bin .sub (CLogic.Expr.var dlenName)
        (.literal .i32 1))) (.scalar (.literal .i32 30))))
      (.uint32 rxw) (.uint32 (-(d0>>>30))) (.uint32 (signWord rxw d0))
      (cell32 _ rxName rxw rxAtU) ?_ (KeygenDecodeWordOps.and32 rxw (-(d0>>>30)))
    refine KeygenWordExpr.Eval.neg (.bin .shr (.load32 dName
      (CLogic.Expr.bin .sub (CLogic.Expr.var dlenName) (.literal .i32 1)))
      (.scalar (.literal .i32 30))) (.uint32 (d0>>>30)) (.uint32 (-(d0>>>30))) ?_
      (KeygenDecodeWordOps.neg32 (d0>>>30))
    refine KeygenWordExpr.Eval.bin .shr (.load32 dName
      (CLogic.Expr.bin .sub (CLogic.Expr.var dlenName) (.literal .i32 1)))
      (.scalar (.literal .i32 30)) (.uint32 d0) (.int32 30#32) (.uint32 (d0>>>30)) ?_
      (KeygenWordExpr.Eval.scalar (.literal .i32 30) (.int32 30#32)
        (C99ScalarReference.Eval.literal .int32 30)) (shr_thirty d0)
    exact KeygenWordExpr.Eval.load32 dName
      (CLogic.Expr.bin .sub (CLogic.Expr.var dlenName) (.literal .i32 1)) pd d0 idxPointer
      (by rw [show (msU entry d0 pw p0w r2w).heap=entry.heap from rfl]; exact pread)
  have subEval : KeygenWordExpr.Eval (msU entry d0 pw p0w r2w) subExpr
      (.uint32 (modSignedWord d0 pw p0w r2w rxw)) := by
    refine KeygenWordExpr.Eval.call3 "modp_sub".toList
      (.scalar (CLogic.Expr.var zName))
      (.bin .band (.scalar (CLogic.Expr.var rxName))
        (.neg (.bin .shr (.load32 dName (CLogic.Expr.bin .sub (CLogic.Expr.var dlenName)
          (.literal .i32 1))) (.scalar (.literal .i32 30)))))
      (.scalar (CLogic.Expr.var pName))
      (.uint32 (unsignedWord d0 pw p0w r2w)) (.uint32 (signWord rxw d0)) (.uint32 pw)
      (.uint32 (modSignedWord d0 pw p0w r2w rxw))
      (cell32 _ zName _ zAtU) signEval (cell32 _ pName pw pAtU) ?_
    exact C99ModularReference.ModCall.sub _ _
      (KeygenModpAddSub.source_exists .sub (unsignedWord d0 pw p0w r2w) (signWord rxw d0) pw)
  have subRun : KeygenZintCall.Exec MakeFgAddPrimeShape194.msSubAssign (msU entry d0 pw p0w r2w)
      ⟨msV entry d0 pw p0w r2w rxw,.normal⟩ := by
    rw [ms_sub_shape]
    exact KeygenZintCall.Exec.word _ _ _
      (KeygenWordExec.Exec.assign zName subExpr (msU entry d0 pw p0w r2w) .uint32
        (some (.uint32 (unsignedWord d0 pw p0w r2w)))
        (.uint32 (modSignedWord d0 pw p0w r2w rxw)) zAtU subEval)
  have retRun : KeygenZintCall.Exec MakeFgAddPrimeShape194.msRetZ (msV entry d0 pw p0w r2w rxw)
      ⟨msV entry d0 pw p0w r2w rxw,
        .returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))⟩ := by
    rw [ms_ret_shape]
    exact KeygenZintCall.Exec.word _ _ _
      (KeygenWordExec.Exec.ret (.scalar (CLogic.Expr.var zName))
        (msV entry d0 pw p0w r2w rxw) (.uint32 (modSignedWord d0 pw p0w r2w rxw))
        (cell32 _ zName _ zAtV))
  have tailRun : KeygenZintCall.Exec (.seq retZ wskipZ) (msV entry d0 pw p0w r2w rxw)
      ⟨msV entry d0 pw p0w r2w rxw,
        .returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))⟩ :=
    KeygenZintCall.Exec.seqExit _ _ (msV entry d0 pw p0w r2w rxw)
      ⟨msV entry d0 pw p0w r2w rxw,
        .returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))⟩
      retRun (by intro h; cases h)
  have guardRun : KeygenWordExpr.Eval (msZ entry) zeroGuard
      (C99ScalarReference.boolean false) :=
    KeygenWordExpr.Eval.cmp .eq (.scalar (CLogic.Expr.var dlenName)) (.scalar (.literal .i32 0))
      (.uint64 1#64) (.int32 0#32) (C99ScalarReference.boolean false)
      (cell64 (msZ entry) dlenName 1#64 dlenAtZ)
      (KeygenWordExpr.Eval.scalar (.literal .i32 0) (.int32 0#32)
        (C99ScalarReference.Eval.literal .int32 0)) eq_one_false
  have skipZRun : KeygenZintCall.Exec wskipZ (msZ entry) ⟨msZ entry,.normal⟩ :=
    KeygenZintCall.Exec.word _ _ _ (ZintSubWord194.skip_run (msZ entry))
  have branchRun : KeygenZintCall.Exec (.branch zeroGuard zeroYes zeroNo) (msZ entry)
      ⟨msZ entry,.normal⟩ :=
    KeygenZintCall.Exec.branchFalse zeroGuard zeroYes zeroNo (msZ entry)
      ⟨msZ entry,.normal⟩ (C99ScalarReference.boolean false) guardRun (boolean_zero _ rfl)
      skipZRun
  have declRun : KeygenZintCall.Exec declZ entry ⟨msZ entry,.normal⟩ :=
    KeygenZintCall.Exec.word _ _ _ (ZintSubWord194.declare_run .u32 [zName] entry)
  have fullRun : KeygenZintCall.Exec
      (.seq declZ (.seq (.branch zeroGuard zeroYes zeroNo)
        (.seq (.call (.leaf .reduce) leafArgs (.into zName))
          (.seq subAssign (.seq retZ wskipZ))))) entry
      ⟨msV entry d0 pw p0w r2w rxw,
        .returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))⟩ :=
    KeygenZintCall.Exec.seqNormal _ _ entry (msZ entry)
      ⟨msV entry d0 pw p0w r2w rxw,
        .returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))⟩ declRun
      (KeygenZintCall.Exec.seqNormal _ _ (msZ entry) (msZ entry)
        ⟨msV entry d0 pw p0w r2w rxw,
          .returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))⟩ branchRun
        (KeygenZintCall.Exec.seqNormal _ _ (msZ entry) (msU entry d0 pw p0w r2w)
          ⟨msV entry d0 pw p0w r2w rxw,
            .returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))⟩ callRun
          (KeygenZintCall.Exec.seqNormal _ _ (msU entry d0 pw p0w r2w)
            (msV entry d0 pw p0w r2w rxw)
            ⟨msV entry d0 pw p0w r2w rxw,
              .returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))⟩ subRun tailRun)))
  rw [MakeFgAddPrimeShape194.ms_split1, MakeFgAddPrimeShape194.ms_split2,
    MakeFgAddPrimeShape194.ms_split3, MakeFgAddPrimeShape194.ms_split4,
    MakeFgAddPrimeShape194.ms_split5, ms_decl_shape, ms_zero_shape, ms_leaf_shape,
    ms_sub_shape, ms_ret_shape, MakeFgAddPrimeShape194.ms_tail]
  exact fullRun

theorem msZ_heap (entry : State) : (msZ entry).heap=entry.heap := rfl
theorem msU_heap (entry : State) (d0 pw p0w r2w : BitVec 32) :
    (msU entry d0 pw p0w r2w).heap=entry.heap := rfl
theorem msV_heap (entry : State) (d0 pw p0w r2w rxw : BitVec 32) :
    (msV entry d0 pw p0w r2w rxw).heap=entry.heap := rfl

/- Call-level export: the per-march-word zint_mod_small_signed call of
   the additional-prime walks at the pinned walk shape
   MakeFgAddPrimeShape194.modArgs (dlen = 1). The walked pointer is x
   at its marched position pd and the marched limb is the loaded word
   d0; the section words p/p0i/R2/Rx are the caller's u32 cells and
   slen is the u64 cell 1. Values stay executed words. -/
theorem ms_call (before : State) (pd : ArrayPointer) (d0 pw p0w r2w rxw : BitVec 32)
    (xb : before.arrays "x".toList=some pd) (cap : pd.index≤pd.count)
    (hslen : before.locals "slen".toList=some (.uint64,some (.uint64 1#64)))
    (hp : before.locals "p".toList=some (.uint32,some (.uint32 pw)))
    (hp0i : before.locals "p0i".toList=some (.uint32,some (.uint32 p0w)))
    (hr2 : before.locals "R2".toList=some (.uint32,some (.uint32 r2w)))
    (hrx : before.locals "Rx".toList=some (.uint32,some (.uint32 rxw)))
    (pread : Load32 before.heap pd d0) :
    KeygenZintCall.Call .modSigned before MakeFgAddPrimeShape194.modArgs before
      (some (.uint32 (modSignedWord d0 pw p0w r2w rxw))) := by
  have run := spine_run (msEntry before pd pw p0w r2w rxw) pd d0 pw p0w r2w rxw
    (ms_entry_arrays before pd pw p0w r2w rxw) cap (ms_entry_p before pd pw p0w r2w rxw)
    (ms_entry_p0i before pd pw p0w r2w rxw) (ms_entry_r2 before pd pw p0w r2w rxw)
    (ms_entry_rx before pd pw p0w r2w rxw) (ms_entry_dlen before pd pw p0w r2w rxw)
    (by rw [ms_entry_heap]; exact pread)
  have rv : C99ProcedureReference.ReturnValue (some .uint32)
      (.returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw))))
      (some (.uint32 (modSignedWord d0 pw p0w r2w rxw))) := by
    have h := C99ProcedureReference.ReturnValue.value .uint32
      (.uint32 (modSignedWord d0 pw p0w r2w rxw))
    rw [convert_self32] at h
    exact h
  refine ⟨msEntry before pd pw p0w r2w rxw,
    ⟨msV (msEntry before pd pw p0w r2w rxw) d0 pw p0w r2w rxw,
      .returned (some (.uint32 (modSignedWord d0 pw p0w r2w rxw)))⟩,
    bind_ms before pd pw p0w r2w rxw xb cap hslen hp hp0i hr2 hrx, run, rv, ?_⟩
  rw [Eq.trans (msV_heap (msEntry before pd pw p0w r2w rxw) d0 pw p0w r2w rxw)
    (ms_entry_heap before pd pw p0w r2w rxw)]

end FT1536.Source3.ZintModSignedWord194
