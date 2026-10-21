import Source3.ZintSubWord194
import Source3.MakeFgCrtShape194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The zint_norm_zero engine at len = 1 (obligation (b) of the CRT route).
   The pinned body `KeygenZintCall.calleeBody .normZero` is executed in
   full at the selected instance len = 1 with the two data-dependent
   comparison branches resolved by decidable case splits, and exported as
   the executed-word image

     normWord p0 x = if x < p0>>>1 then x
                     else if p0>>>1 < x then (x-p0) &&& 2147483647
                     else x

   (the second case is the zint_sub limb write of ZintSubWord194 at len
   = 1: the parsed store is `w & 0x7FFFFFFF`, so the executed word is the
   masked difference — the route shorthand "x-p0" drops the mask; see the
   ZintSubWord194 trap note). Each of the three cases carries the same
   heap-keeps-except-x[0] frame and the void return flow of the callee:
   `ReturnValue none flow none` holds for both end flows actually reached
   (`.returned none` on both comparison returns, `.normal` on the tie
   path that falls through the false guard into the trailing u wrap).

   The parse shape is the pinned probe record ZintCrtParseProbe194 (job
   510) as recorded in KEYGEN_STEP_GS_194_NEXT_ROUTE.md; no new parse
   recognition is performed here (norm_shape re-binds it by decide).

   Values stay executed words: no normalization, positivity, Z>0, CRT or
   range claim is made here. -/
namespace FT1536.Source3.ZintNormWord194
open C99ArrayReference (State Name Pointer Arg bindValue bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32 Store32 Memory)
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenZintLeaves (Kind)
open ZintSubWord194 (subWord borrowWord)

def uName : Name := "u".toList
def ccName : Name := "cc".toList
def wName : Name := "w".toList
def lenName : Name := "len".toList
def xName : Name := "x".toList
def pName : Name := "p".toList

/- The exported executed-word image of one len = 1 normalization step and
   the callee end flow it takes. -/
def normWord (p0 x : BitVec 32) : BitVec 32 :=
  if x.toNat<(p0>>>1).toNat then x
  else if (p0>>>1).toNat<x.toNat then subWord x p0
  else x

def normImage (entry : State) (px : ArrayPointer) (p0 x : BitVec 32) : Memory :=
  if (p0>>>1).toNat<x.toNat then Word32Memory176.write entry.heap px (subWord x p0)
  else entry.heap

def normFlow (p0 x : BitVec 32) : C99ProcedureReference.Flow :=
  if (p0>>>1).toNat=x.toNat then .normal else .returned none

/- Statement pieces of the pinned body (source-bound by norm_shape). -/
def wskip : KeygenZintCall.Stmt := .word (.modular (.base .skip))
def wordScalar (s : CLogic.Stmt) : KeygenZintCall.Stmt := .word (.modular (.base (.scalar s)))
def wordAssign (name : Name) (e : KeygenWordExpr.Expr) : KeygenZintCall.Stmt := .word (.assign name e)
def uDec : CLogic.Stmt := .update uName .sub (.literal .i32 1)
def loadP : KeygenWordExpr.Expr := .load32 pName (.var uName)
def loadX : KeygenWordExpr.Expr := .load32 xName (.var uName)
def rhsW : KeygenWordExpr.Expr := .bin .bor (.bin .shr loadP (.scalar (.literal .i32 1)))
  (.bin .shl (.scalar (.var ccName)) (.scalar (.literal .i32 30)))
def rhsCC : KeygenWordExpr.Expr := .bin .band loadP (.scalar (.literal .i32 1))
def test1 : KeygenWordExpr.Expr := .cmp .lt loadX (.scalar (.var wName))
def test2 : KeygenWordExpr.Expr := .cmp .gt loadX (.scalar (.var wName))
def normGuard : KeygenWordExpr.Expr := .cmp .gt (.scalar (.var uName)) (.scalar (.literal .i32 0))
def normDeclC : KeygenZintCall.Stmt := wordScalar (.declare .u32 [ccName])
def normDeclU : KeygenZintCall.Stmt := wordScalar (.declare .u64 [uName])
def normCC0 : KeygenZintCall.Stmt := wordAssign ccName (.scalar (.literal .i32 0))
def normSetU : KeygenZintCall.Stmt := wordAssign uName (.scalar (.var lenName))
def normHeadDec : KeygenZintCall.Stmt := wordScalar uDec
def normTailDec : KeygenZintCall.Stmt := wordScalar uDec
def normDeclW : KeygenZintCall.Stmt := wordScalar (.declare .u32 [wName])
def normSetW : KeygenZintCall.Stmt := wordAssign wName rhsW
def normSetCC : KeygenZintCall.Stmt := wordAssign ccName rhsCC
def yes1 : KeygenZintCall.Stmt := .scope [] [] (.seq .retVoid wskip)
def yes2 : KeygenZintCall.Stmt := .scope [] []
  (.seq (.call (.leaf .sub) ZintSubWord194.subArgs .discard) (.seq .retVoid wskip))
def normBranch1 : KeygenZintCall.Stmt := .branch test1 yes1 wskip
def normBranch2 : KeygenZintCall.Stmt := .branch test2 yes2 wskip
def normInner : KeygenZintCall.Stmt :=
  .seq normDeclW (.seq normSetW (.seq normSetCC (.seq normBranch1 (.seq normBranch2 wskip))))
def normScope : KeygenZintCall.Stmt := .scope [wName] [] normInner
def normIter : KeygenZintCall.Stmt := .seq normHeadDec normScope
def normLoop : KeygenZintCall.Stmt := .loop normGuard normIter wskip
def normLoopDec : KeygenZintCall.Stmt := .seq normLoop normTailDec
def normBody : KeygenZintCall.Stmt :=
  .seq normDeclC (.seq normDeclU (.seq normCC0 (.seq normSetU (.seq normLoopDec wskip))))

theorem norm_shape : KeygenZintCall.calleeBody .normZero = normBody := by decide

/- The consumer argument list of the parsed `zint_norm_zero(x, tmp, xlen)`
   call inside the zint_rebuild_CRT normalize loop. -/
def consumerArgs : List Arg :=
  [ .pointer "x".toList C99ProcedureParser.zero,
    .pointer "tmp".toList C99ProcedureParser.zero,
    .scalar (.var "xlen".toList) ]

def normEntry (s : State) (px pp : ArrayPointer) : State :=
  bindPointer (bindPointer
    (bindValue ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩ lenName .uint64 (.uint64 1#64))
    pName pp) xName px

theorem norm_entry_x (s : State) (px pp : ArrayPointer) :
    (normEntry s px pp).arrays xName=some px := by
  simp [normEntry,bindPointer,xName,pName]

theorem norm_entry_p (s : State) (px pp : ArrayPointer) :
    (normEntry s px pp).arrays pName=some pp := by
  simp [normEntry,bindPointer,xName,pName]

theorem norm_entry_len (s : State) (px pp : ArrayPointer) :
    (normEntry s px pp).locals lenName=some (.uint64,some (.uint64 1#64)) := by
  simp only [normEntry,bindPointer,bindValue,C99ScalarReference.set,ite_true]
  rw [ZintSubWord194.convert_u64_one]

theorem norm_entry_heap (s : State) (px pp : ArrayPointer) :
    (normEntry s px pp).heap=s.heap := rfl

theorem bind_norm (s : State) (px pp : ArrayPointer)
    (xa : s.arrays "x".toList=some px) (xb : s.arrays "tmp".toList=some pp)
    (lv : s.locals "xlen".toList=some (.uint64,some (.uint64 1#64)))
    (xbound : px.index+0≤px.count) (pbound : pp.index+0≤pp.count) :
    C99ArrayReference.Bind s (KeygenZintCall.params .normZero) consumerArgs (normEntry s px pp) := by
  have zeroValue : C99ArrayReference.scalar s C99ProcedureParser.zero (.uint64 0#64) :=
    C99ScalarReference.Eval.literal .uint64 0
  have first : Pointer s "x".toList C99ProcedureParser.zero px :=
    .add "x".toList C99ProcedureParser.zero px px (.uint64 0#64) xa zeroValue (by decide)
      (C99MemoryReference.PointerAdd.within px 0 xbound)
  have second : Pointer s "tmp".toList C99ProcedureParser.zero pp :=
    .add "tmp".toList C99ProcedureParser.zero pp pp (.uint64 0#64) xb zeroValue (by decide)
      (C99MemoryReference.PointerAdd.within pp 0 pbound)
  have third : C99ArrayReference.scalar s (.var "xlen".toList) (.uint64 1#64) :=
    C99ScalarReference.Eval.variable "xlen".toList .uint64 (.uint64 1#64) lv
  refine C99ArrayReference.Bind.pointer xName "x".toList C99ProcedureParser.zero px
    [C99ArrayReference.Param.pointer pName,C99ArrayReference.Param.scalar .uint64 lenName]
    [Arg.pointer "tmp".toList C99ProcedureParser.zero,
      Arg.scalar (.var "xlen".toList)] _ first ?_
  refine C99ArrayReference.Bind.pointer pName "tmp".toList C99ProcedureParser.zero pp
    [C99ArrayReference.Param.scalar .uint64 lenName] [Arg.scalar (.var "xlen".toList)] _ second ?_
  refine C99ArrayReference.Bind.scalar .uint64 lenName (.var "xlen".toList) [] []
    ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩ (.uint64 1#64) third ?_
  exact C99ArrayReference.Bind.nil

/- Word-operation helpers for the body expressions. -/
theorem minus_one64 (x : BitVec 64) :
    C99IntegerReference.ArithmeticExec .minus (.uint64 x) (.int32 1#32) (.uint64 (x-1#64)) := by
  have source := C99IntegerReference.ArithmeticExec.step .minus (.uint64 x) (.int32 1#32) .uint64 rfl
    (.uint64 x) (.uint64 1#64) (C99CountedWords.convert_self (.uint64 x)).symm rfl
    (by intro h; cases h)
  have same : C99IntegerReference.convert .uint64
      ((Value.uint64 x).integer-(Value.uint64 1#64).integer)=.uint64 (x-1#64) := by
    simp only [C99IntegerReference.convert,Value.integer,C99ArithmeticBridge.ofInt_sub,
      BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem dec_one : C99IntegerReference.ArithmeticExec .minus (.uint64 1#64) (.int32 1#32)
    (.uint64 0#64) := by
  have h := minus_one64 1#64
  rw [show (1#64:BitVec 64)-1#64=0#64 by decide] at h
  exact h

theorem dec_zero : C99IntegerReference.ArithmeticExec .minus (.uint64 0#64) (.int32 1#32)
    (.uint64 (0#64-1#64)) :=
  minus_one64 0#64

theorem shr_one (a : BitVec 32) :
    C99IntegerReference.ShiftExec .right (.uint32 a) (.int32 1#32) (.uint32 (a >>> 1)) :=
  KeygenDecodeWordOps.right32 a 1 (by decide)

theorem shl_thirty_zero :
    C99IntegerReference.ShiftExec .left (.uint32 0#32) (.int32 30#32) (.uint32 0#32) := by
  have h := KeygenDecodeWordOps.left32 0#32 30 (by decide)
  rw [BitVec.zero_shiftLeft] at h
  exact h

theorem or_zero_right (a : BitVec 32) :
    C99IntegerReference.BitwiseExec .or (.uint32 a) (.uint32 0#32) (.uint32 a) := by
  have source := C99IntegerReference.BitwiseExec.step .or (.uint32 a) (.uint32 0#32) .uint32 rfl
    (.uint32 a) (.uint32 0#32) (ZintSubWord194.convert_self32 a).symm
    (ZintSubWord194.convert_self32 0#32).symm
  have same : C99IntegerReference.convert .uint32
      (C99IntegerReference.bitResult .or (Value.uint32 a).bits (Value.uint32 0#32).bits)
      =.uint32 a := by
    change Value.uint32 (BitVec.ofNat 32 ((a ||| 0#32).toNat))=_
    rw [BitVec.toNat_or,← BitVec.toNat_or,BitVec.ofNat_toNat,BitVec.setWidth_eq,BitVec.or_zero]
  rw [same] at source
  exact source

theorem and_one (a : BitVec 32) :
    C99IntegerReference.BitwiseExec .and (.uint32 a) (.int32 1#32) (.uint32 (a &&& 1#32)) := by
  have source := C99IntegerReference.BitwiseExec.step .and (.uint32 a) (.int32 1#32) .uint32 rfl
    (.uint32 a) (.uint32 1#32) (ZintSubWord194.convert_self32 a).symm rfl
  have same : C99IntegerReference.convert .uint32
      (C99IntegerReference.bitResult .and (Value.uint32 a).bits (Value.uint32 1#32).bits)
      =.uint32 (a &&& 1#32) := by
    change Value.uint32 (BitVec.ofNat 32 ((a &&& 1#32).toNat))=_
    rw [BitVec.toNat_and,← BitVec.toNat_and,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem lt_word (x y : BitVec 32) :
    C99IntegerReference.CompareExec .lt (.uint32 x) (.uint32 y)
      (C99ScalarReference.boolean (decide (x.toNat<y.toNat))) := by
  have raw := C99IntegerReference.CompareExec.step .lt (.uint32 x) (.uint32 y) .uint32 rfl
    (.uint32 x) (.uint32 y) (ZintSubWord194.convert_self32 x).symm
    (ZintSubWord194.convert_self32 y).symm
  change C99IntegerReference.CompareExec .lt (.uint32 x) (.uint32 y)
    (C99ScalarReference.boolean
      (decide ((Value.uint32 x).integer<(Value.uint32 y).integer))) at raw
  have hx : (Value.uint32 x).integer=(x.toNat : Int) := rfl
  have hy : (Value.uint32 y).integer=(y.toNat : Int) := rfl
  rw [hx,hy] at raw
  have same : ((x.toNat : Int)<(y.toNat : Int))↔x.toNat<y.toNat := by omega
  simpa only [same] using raw

theorem gt_word (x y : BitVec 32) :
    C99IntegerReference.CompareExec .gt (.uint32 x) (.uint32 y)
      (C99ScalarReference.boolean (decide (y.toNat<x.toNat))) := by
  have raw := C99IntegerReference.CompareExec.step .gt (.uint32 x) (.uint32 y) .uint32 rfl
    (.uint32 x) (.uint32 y) (ZintSubWord194.convert_self32 x).symm
    (ZintSubWord194.convert_self32 y).symm
  change C99IntegerReference.CompareExec .gt (.uint32 x) (.uint32 y)
    (C99ScalarReference.boolean
      (decide ((Value.uint32 y).integer<(Value.uint32 x).integer))) at raw
  have hx : (Value.uint32 x).integer=(x.toNat : Int) := rfl
  have hy : (Value.uint32 y).integer=(y.toNat : Int) := rfl
  rw [hx,hy] at raw
  have same : ((y.toNat : Int)<(x.toNat : Int))↔y.toNat<x.toNat := by omega
  simpa only [same] using raw

theorem gt_one_true : C99IntegerReference.CompareExec .gt (.uint64 1#64) (.int32 0#32)
    (C99ScalarReference.boolean true) := by
  have source := C99IntegerReference.CompareExec.step .gt (.uint64 1#64) (.int32 0#32) .uint64 rfl
    (.uint64 1#64) (.uint64 0#64) rfl rfl
  have same : (if C99IntegerReference.compare .gt (Value.uint64 1#64).integer
      (Value.uint64 0#64).integer then 1#32 else 0#32)=1#32 := by decide
  rw [same] at source
  exact source

theorem gt_zero_false : C99IntegerReference.CompareExec .gt (.uint64 0#64) (.int32 0#32)
    (C99ScalarReference.boolean false) := by
  have source := C99IntegerReference.CompareExec.step .gt (.uint64 0#64) (.int32 0#32) .uint64 rfl
    (.uint64 0#64) (.uint64 0#64) rfl rfl
  have same : (if C99IntegerReference.compare .gt (Value.uint64 0#64).integer
      (Value.uint64 0#64).integer then 1#32 else 0#32)=0#32 := by decide
  rw [same] at source
  exact source

/- KeygenZintCall-level statement steps over the word-level engine. -/
theorem word_run (code : KeygenWordExec.Stmt) (before : State) (out : Result)
    (run : KeygenWordExec.Exec code before out) : KeygenZintCall.Exec (.word code) before out :=
  KeygenZintCall.Exec.word code before out run

theorem restore_empty (before after : State) : restoreScope before after [] [] = after := rfl

theorem word_declare (ty : B20.C.Ty) (names : List Name) (before : State) :
    KeygenZintCall.Exec (wordScalar (.declare ty names)) before
      ⟨C99DeclarationStatements.effect ty names before,.normal⟩ :=
  word_run _ _ _ (ZintSubWord194.declare_run ty names before)

theorem word_skip (before : State) : KeygenZintCall.Exec wskip before ⟨before,.normal⟩ :=
  word_run _ _ _ (ZintSubWord194.skip_run before)

theorem word_update (before : State) (name : Name) (op : B20.C.BinOp) (e : CLogic.Expr)
    (ty : Ty) (old rhs out : Value)
    (declared : before.locals name=some (ty,some old))
    (rhsEval : C99ArrayReference.scalar before e rhs)
    (operation : C99OperatorBridge.Binary op old rhs out) :
    KeygenZintCall.Exec (wordScalar (.update name op e)) before
      ⟨bindValue before name ty out,.normal⟩ :=
  word_run _ _ _ (ZintSubWord194.update_run before name op e ty old rhs out declared rhsEval operation)

/- The executed run at len = 1: shared states. -/
def t1 (entry : State) : State := C99DeclarationStatements.effect .u32 [ccName] entry
def t2 (entry : State) : State := C99DeclarationStatements.effect .u64 [uName] (t1 entry)
def t3 (entry : State) : State := bindValue (t2 entry) ccName .uint32 (.int32 0#32)
def t4 (entry : State) : State := bindValue (t3 entry) uName .uint64 (.uint64 1#64)
def t5 (entry : State) : State := bindValue (t4 entry) uName .uint64 (.uint64 0#64)
def t6 (entry : State) : State := C99DeclarationStatements.effect .u32 [wName] (t5 entry)
def t7 (entry : State) (pw : BitVec 32) : State :=
  bindValue (t6 entry) wName .uint32 (.uint32 (pw>>>1))
def t8 (entry : State) (pw : BitVec 32) : State :=
  bindValue (t7 entry pw) ccName .uint32 (.uint32 (pw &&& 1))
def t9 (entry : State) (pw : BitVec 32) : State :=
  restoreScope (t5 entry) (t8 entry pw) [wName] []
def tWrap (entry : State) (pw : BitVec 32) : State :=
  bindValue (t9 entry pw) uName .uint64 (.uint64 (0#64-1#64))
def tAfter (entry : State) (px : ArrayPointer) (pw xw : BitVec 32) : State :=
  {(t8 entry pw) with heap := Word32Memory176.write entry.heap px (subWord xw pw)}
def tGt9 (entry : State) (px : ArrayPointer) (pw xw : BitVec 32) : State :=
  restoreScope (t5 entry) (tAfter entry px pw xw) [wName] []

theorem t9_heap (entry : State) (pw : BitVec 32) : (t9 entry pw).heap=entry.heap := rfl
theorem tWrap_heap (entry : State) (pw : BitVec 32) : (tWrap entry pw).heap=entry.heap := rfl
theorem tAfter_heap (entry : State) (px : ArrayPointer) (pw xw : BitVec 32) :
    (tAfter entry px pw xw).heap=Word32Memory176.write entry.heap px (subWord xw pw) := rfl
theorem tGt9_heap (entry : State) (px : ArrayPointer) (pw xw : BitVec 32) :
    (tGt9 entry px pw xw).heap=Word32Memory176.write entry.heap px (subWord xw pw) := rfl

theorem arrays_keep (entry : State) (pw : BitVec 32) :
    (t5 entry).arrays=entry.arrays ∧ (t8 entry pw).arrays=entry.arrays := ⟨rfl,rfl⟩

theorem heap_keep (entry : State) (pw : BitVec 32) :
    (t5 entry).heap=entry.heap ∧ (t7 entry pw).heap=entry.heap ∧
    (t8 entry pw).heap=entry.heap ∧ (t9 entry pw).heap=entry.heap := ⟨rfl,rfl,rfl,rfl⟩

theorem u_at4 (entry : State) : (t4 entry).locals uName=some (.uint64,some (.uint64 1#64)) := by
  show (bindValue (t3 entry) uName .uint64 (.uint64 1#64)).locals uName=_
  rw [ZintSubWord194.bind_cell (t3 entry) uName .uint64 (.uint64 1#64)]
  rw [ZintSubWord194.convert_u64_one]

theorem u_at5 (entry : State) : (t5 entry).locals uName=some (.uint64,some (.uint64 0#64)) := by
  show (bindValue (t4 entry) uName .uint64 (.uint64 0#64)).locals uName=_
  rw [ZintSubWord194.bind_cell (t4 entry) uName .uint64 (.uint64 0#64)]
  rw [show C99IntegerReference.convert .uint64 (Value.uint64 0#64).integer=.uint64 0#64 by decide]

theorem u_at8 (entry : State) (pw : BitVec 32) :
    (t8 entry pw).locals uName=some (.uint64,some (.uint64 0#64)) := by
  show (bindValue (t7 entry pw) ccName .uint32 (.uint32 (pw &&& 1))).locals uName=_
  rw [ZintSubWord194.bind_other (t7 entry pw) ccName uName .uint32 (.uint32 (pw &&& 1))
    (by decide)]
  show (bindValue (t6 entry) wName .uint32 (.uint32 (pw>>>1))).locals uName=_
  rw [ZintSubWord194.bind_other (t6 entry) wName uName .uint32 (.uint32 (pw>>>1)) (by decide)]
  show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals uName=_
  rw [ZintSubWord194.effect_one_other .u32 wName uName (t5 entry) (by decide)]
  exact u_at5 entry

theorem u_at9 (entry : State) (pw : BitVec 32) :
    (t9 entry pw).locals uName=some (.uint64,some (.uint64 0#64)) := by
  show (restoreScope (t5 entry) (t8 entry pw) [wName] []).locals uName=_
  rw [ZintSubWord194.restore_one_cell (t5 entry) (t8 entry pw) wName uName (by decide)]
  exact u_at8 entry pw

theorem cc_at3 (entry : State) : (t3 entry).locals ccName=some (.uint32,some (.uint32 0#32)) := by
  show (bindValue (t2 entry) ccName .uint32 (.int32 0#32)).locals ccName=_
  rw [ZintSubWord194.bind_cell (t2 entry) ccName .uint32 (.int32 0#32)]
  rw [ZintSubWord194.convert_i32_zero_u32]

theorem cc_at7 (entry : State) (pw : BitVec 32) :
    (t7 entry pw).locals ccName=some (.uint32,some (.uint32 0#32)) := by
  show (bindValue (t6 entry) wName .uint32 (.uint32 (pw>>>1))).locals ccName=_
  rw [ZintSubWord194.bind_other (t6 entry) wName ccName .uint32 (.uint32 (pw>>>1)) (by decide)]
  show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals ccName=_
  rw [ZintSubWord194.effect_one_other .u32 wName ccName (t5 entry) (by decide)]
  show (bindValue (t4 entry) uName .uint64 (.uint64 0#64)).locals ccName=_
  rw [ZintSubWord194.bind_other (t4 entry) uName ccName .uint64 (.uint64 0#64) (by decide)]
  show (bindValue (t3 entry) uName .uint64 (.uint64 1#64)).locals ccName=_
  rw [ZintSubWord194.bind_other (t3 entry) uName ccName .uint64 (.uint64 1#64) (by decide)]
  exact cc_at3 entry

theorem cc_at8 (entry : State) (pw : BitVec 32) :
    (t8 entry pw).locals ccName=some (.uint32,some (.uint32 (pw &&& 1))) := by
  show (bindValue (t7 entry pw) ccName .uint32 (.uint32 (pw &&& 1))).locals ccName=_
  rw [ZintSubWord194.bind_cell (t7 entry pw) ccName .uint32 (.uint32 (pw &&& 1))]
  rw [ZintSubWord194.convert_self32 (pw &&& 1)]

theorem w_decl (entry : State) : (t6 entry).locals wName=some (.uint32,none) :=
  ZintSubWord194.effect_one_cell .u32 wName (t5 entry)

theorem w_at7 (entry : State) (pw : BitVec 32) :
    (t7 entry pw).locals wName=some (.uint32,some (.uint32 (pw>>>1))) := by
  show (bindValue (t6 entry) wName .uint32 (.uint32 (pw>>>1))).locals wName=_
  rw [ZintSubWord194.bind_cell (t6 entry) wName .uint32 (.uint32 (pw>>>1))]
  rw [ZintSubWord194.convert_self32 (pw>>>1)]

theorem w_at8 (entry : State) (pw : BitVec 32) :
    (t8 entry pw).locals wName=some (.uint32,some (.uint32 (pw>>>1))) := by
  show (bindValue (t7 entry pw) ccName .uint32 (.uint32 (pw &&& 1))).locals wName=_
  rw [ZintSubWord194.bind_other (t7 entry pw) ccName wName .uint32 (.uint32 (pw &&& 1))
    (by decide)]
  exact w_at7 entry pw

theorem len3 (entry : State)
    (len : entry.locals lenName=some (.uint64,some (.uint64 1#64))) :
    (t3 entry).locals lenName=some (.uint64,some (.uint64 1#64)) := by
  show (bindValue (t2 entry) ccName .uint32 (.int32 0#32)).locals lenName=_
  rw [ZintSubWord194.bind_other (t2 entry) ccName lenName .uint32 (.int32 0#32) (by decide)]
  show (C99DeclarationStatements.effect .u64 [uName] (t1 entry)).locals lenName=_
  rw [ZintSubWord194.effect_one_other .u64 uName lenName (t1 entry) (by decide)]
  show (C99DeclarationStatements.effect .u32 [ccName] entry).locals lenName=_
  rw [ZintSubWord194.effect_one_other .u32 ccName lenName entry (by decide)]
  exact len

theorem len4 (entry : State)
    (len : entry.locals lenName=some (.uint64,some (.uint64 1#64))) :
    (t4 entry).locals lenName=some (.uint64,some (.uint64 1#64)) := by
  show (bindValue (t3 entry) uName .uint64 (.uint64 1#64)).locals lenName=_
  rw [ZintSubWord194.bind_other (t3 entry) uName lenName .uint64 (.uint64 1#64) (by decide)]
  exact len3 entry len

theorem len7 (entry : State) (pw : BitVec 32)
    (len : entry.locals lenName=some (.uint64,some (.uint64 1#64))) :
    (t7 entry pw).locals lenName=some (.uint64,some (.uint64 1#64)) := by
  show (bindValue (t6 entry) wName .uint32 (.uint32 (pw>>>1))).locals lenName=_
  rw [ZintSubWord194.bind_other (t6 entry) wName lenName .uint32 (.uint32 (pw>>>1)) (by decide)]
  show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals lenName=_
  rw [ZintSubWord194.effect_one_other .u32 wName lenName (t5 entry) (by decide)]
  show (bindValue (t4 entry) uName .uint64 (.uint64 0#64)).locals lenName=_
  rw [ZintSubWord194.bind_other (t4 entry) uName lenName .uint64 (.uint64 0#64) (by decide)]
  exact len4 entry len

theorem len8 (entry : State) (pw : BitVec 32)
    (len : entry.locals lenName=some (.uint64,some (.uint64 1#64))) :
    (t8 entry pw).locals lenName=some (.uint64,some (.uint64 1#64)) := by
  show (bindValue (t7 entry pw) ccName .uint32 (.uint32 (pw &&& 1))).locals lenName=_
  rw [ZintSubWord194.bind_other (t7 entry pw) ccName lenName .uint32 (.uint32 (pw &&& 1))
    (by decide)]
  exact len7 entry pw len

theorem len9 (entry : State) (pw : BitVec 32)
    (len : entry.locals lenName=some (.uint64,some (.uint64 1#64))) :
    (t9 entry pw).locals lenName=some (.uint64,some (.uint64 1#64)) := by
  show (restoreScope (t5 entry) (t8 entry pw) [wName] []).locals lenName=_
  rw [ZintSubWord194.restore_one_cell (t5 entry) (t8 entry pw) wName lenName (by decide)]
  exact len8 entry pw len

/- Branch-guard boolean facts. -/
theorem lt_bool_nonzero (xw pw : BitVec 32) (h : xw.toNat<(pw>>>1).toNat) :
    (C99ScalarReference.boolean (decide (xw.toNat<(pw>>>1).toNat))).integer≠0 := by
  simp only [C99ScalarReference.boolean,Value.integer]
  simp only [BitVec.toNat_ushiftRight] at h ⊢
  simp [h]

theorem lt_bool_zero (xw pw : BitVec 32) (h : ¬xw.toNat<(pw>>>1).toNat) :
    (C99ScalarReference.boolean (decide (xw.toNat<(pw>>>1).toNat))).integer=0 := by
  simp only [C99ScalarReference.boolean,Value.integer]
  simp only [BitVec.toNat_ushiftRight] at h ⊢
  simp [h]

theorem gt_bool_nonzero (xw pw : BitVec 32) (h : (pw>>>1).toNat<xw.toNat) :
    (C99ScalarReference.boolean (decide ((pw>>>1).toNat<xw.toNat))).integer≠0 := by
  simp only [C99ScalarReference.boolean,Value.integer]
  simp only [BitVec.toNat_ushiftRight] at h ⊢
  simp [h]

theorem gt_bool_zero (xw pw : BitVec 32) (h : ¬(pw>>>1).toNat<xw.toNat) :
    (C99ScalarReference.boolean (decide ((pw>>>1).toNat<xw.toNat))).integer=0 := by
  simp only [C99ScalarReference.boolean,Value.integer]
  simp only [BitVec.toNat_ushiftRight] at h ⊢
  simp [h]

theorem void_flow (f : C99ProcedureReference.Flow)
    (shape : f=.returned none ∨ f=.normal) :
    C99ProcedureReference.ReturnValue none f none := by
  rcases shape with rfl | rfl
  · exact C99ProcedureReference.ReturnValue.voidReturn
  · exact C99ProcedureReference.ReturnValue.voidEnd

theorem flow_shape (pw xw : BitVec 32) :
    normFlow pw xw=.returned none ∨ normFlow pw xw=.normal := by
  simp only [normFlow]
  split_ifs
  · exact Or.inr rfl
  · exact Or.inl rfl

/- The executed run at len = 1 (the normZero engine). -/
theorem norm_run (entry : State) (px pp : ArrayPointer) (xw pw : BitVec 32)
    (xb : entry.arrays xName=some px) (pb : entry.arrays pName=some pp)
    (len : entry.locals lenName=some (.uint64,some (.uint64 1#64)))
    (xread : Load32 entry.heap px xw) (pread : Load32 entry.heap pp pw)
    (allocX : Allocated entry.heap px) (widthX : px.elementBytes=4)
    (writableX : entry.heap.writable px.block=true)
    (xbound : px.index+0≤px.count) (pbound : pp.index+0≤pp.count) :
    ∃ out : Result, KeygenZintCall.Exec (KeygenZintCall.calleeBody .normZero) entry out
      ∧ out.state.heap=normImage entry px pw xw
      ∧ out.flow=normFlow pw xw
      ∧ Load32 out.state.heap px (normWord pw xw)
      ∧ ∀ block offset, block≠px.block ∨ offset<px.offset ∨ px.offset+4≤offset →
          out.state.heap.bytes block offset=entry.heap.bytes block offset := by
  rw [norm_shape]
  have p1 : KeygenZintCall.Exec normDeclC entry ⟨t1 entry,.normal⟩ :=
    word_declare .u32 [ccName] entry
  have p2 : KeygenZintCall.Exec normDeclU (t1 entry) ⟨t2 entry,.normal⟩ :=
    word_declare .u64 [uName] (t1 entry)
  have p3 : KeygenZintCall.Exec normCC0 (t2 entry) ⟨t3 entry,.normal⟩ :=
    word_run _ _ _ (KeygenWordExec.Exec.assign ccName (.scalar (.literal .i32 0)) (t2 entry)
      .uint32 none (.int32 0#32) (ZintSubWord194.effect_one_cell .u32 ccName (t1 entry))
      (KeygenWordExpr.Eval.scalar (.literal .i32 0) (.int32 0#32)
        (C99ScalarReference.Eval.literal .int32 0)))
  have p4 : KeygenZintCall.Exec normSetU (t3 entry) ⟨t4 entry,.normal⟩ :=
    word_run _ _ _ (KeygenWordExec.Exec.assign uName (.scalar (.var lenName)) (t3 entry)
      .uint64 none (.uint64 1#64)
      (by
        show (bindValue (t2 entry) ccName .uint32 (.int32 0#32)).locals uName=_
        rw [ZintSubWord194.bind_other (t2 entry) ccName uName .uint32 (.int32 0#32) (by decide)]
        show (C99DeclarationStatements.effect .u64 [uName] (t1 entry)).locals uName=_
        exact ZintSubWord194.effect_one_cell .u64 uName (t1 entry))
      (KeygenWordExpr.Eval.scalar (.var lenName) (.uint64 1#64)
        (C99ScalarReference.Eval.variable lenName .uint64 (.uint64 1#64) (len3 entry len))))
  have guard4 : KeygenWordExpr.Eval (t4 entry) normGuard
      (C99ScalarReference.boolean true) :=
    KeygenWordExpr.Eval.cmp .gt (.scalar (.var uName)) (.scalar (.literal .i32 0))
      (.uint64 1#64) (.int32 0#32) (C99ScalarReference.boolean true)
      (KeygenWordExpr.Eval.scalar (.var uName) (.uint64 1#64)
        (C99ScalarReference.Eval.variable uName .uint64 (.uint64 1#64) (u_at4 entry)))
      (KeygenWordExpr.Eval.scalar (.literal .i32 0) (.int32 0#32)
        (C99ScalarReference.Eval.literal .int32 0))
      gt_one_true
  have it1 : KeygenZintCall.Exec normHeadDec (t4 entry) ⟨t5 entry,.normal⟩ :=
    word_update (t4 entry) uName .sub (.literal .i32 1) .uint64 (.uint64 1#64) (.int32 1#32)
      (.uint64 0#64) (u_at4 entry) (C99ScalarReference.Eval.literal .int32 1) (by
        show C99OperatorBridge.Binary .sub (.uint64 1#64) (.int32 1#32) (.uint64 0#64)
        exact dec_one)
  have in1 : KeygenZintCall.Exec normDeclW (t5 entry) ⟨t6 entry,.normal⟩ :=
    word_declare .u32 [wName] (t5 entry)
  have u_at6 : (t6 entry).locals uName=some (.uint64,some (.uint64 0#64)) := by
    show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals uName=_
    rw [ZintSubWord194.effect_one_other .u32 wName uName (t5 entry) (by decide)]
    exact u_at5 entry
  have cc_at6 : (t6 entry).locals ccName=some (.uint32,some (.uint32 0#32)) := by
    show (C99DeclarationStatements.effect .u32 [wName] (t5 entry)).locals ccName=_
    rw [ZintSubWord194.effect_one_other .u32 wName ccName (t5 entry) (by decide)]
    show (bindValue (t4 entry) uName .uint64 (.uint64 0#64)).locals ccName=_
    rw [ZintSubWord194.bind_other (t4 entry) uName ccName .uint64 (.uint64 0#64) (by decide)]
    show (bindValue (t3 entry) uName .uint64 (.uint64 1#64)).locals ccName=_
    rw [ZintSubWord194.bind_other (t3 entry) uName ccName .uint64 (.uint64 1#64) (by decide)]
    exact cc_at3 entry
  have heap6 : (t6 entry).heap=entry.heap := rfl
  have heap7 : (t7 entry pw).heap=entry.heap := rfl
  have heap8 : (t8 entry pw).heap=entry.heap := rfl
  have arrays6 : (t6 entry).arrays=entry.arrays := rfl
  have arrays8 : (t8 entry pw).arrays=entry.arrays := rfl
  have pAt6 : Pointer (t6 entry) pName (.var uName) pp :=
    C99ArrayReference.Pointer.add pName (.var uName) pp pp (.uint64 0#64)
      (by rw [arrays6]; exact pb)
      (C99ScalarReference.Eval.variable uName .uint64 (.uint64 0#64) u_at6) (by decide)
      (C99MemoryReference.PointerAdd.within pp 0 pbound)
  have in2 : KeygenZintCall.Exec normSetW (t6 entry) ⟨t7 entry pw,.normal⟩ :=
    word_run _ _ _ (KeygenWordExec.Exec.assign wName rhsW (t6 entry) .uint32 none
      (.uint32 (pw>>>1)) (w_decl entry) (by
        show KeygenWordExpr.Eval (t6 entry) rhsW (.uint32 (pw>>>1))
        refine KeygenWordExpr.Eval.bin .bor _ _ (.uint32 (pw>>>1)) (.uint32 0#32)
          (.uint32 (pw>>>1)) ?_ ?_ (or_zero_right (pw>>>1))
        · refine KeygenWordExpr.Eval.bin .shr loadP (.scalar (.literal .i32 1))
            (.uint32 pw) (.int32 1#32) (.uint32 (pw>>>1)) ?_ ?_ (shr_one pw)
          · exact KeygenWordExpr.Eval.load32 pName (.var uName) pp pw pAt6
              (by rw [heap6]; exact pread)
          · exact KeygenWordExpr.Eval.scalar (.literal .i32 1) (.int32 1#32)
              (C99ScalarReference.Eval.literal .int32 1)
        · refine KeygenWordExpr.Eval.bin .shl (.scalar (.var ccName)) (.scalar (.literal .i32 30))
            (.uint32 0#32) (.int32 30#32) (.uint32 0#32) ?_ ?_ shl_thirty_zero
          · exact KeygenWordExpr.Eval.scalar (.var ccName) (.uint32 0#32)
              (C99ScalarReference.Eval.variable ccName .uint32 (.uint32 0#32) cc_at6)
          · exact KeygenWordExpr.Eval.scalar (.literal .i32 30) (.int32 30#32)
              (C99ScalarReference.Eval.literal .int32 30)))
  have u_at7 : (t7 entry pw).locals uName=some (.uint64,some (.uint64 0#64)) := by
    show (bindValue (t6 entry) wName .uint32 (.uint32 (pw>>>1))).locals uName=_
    rw [ZintSubWord194.bind_other (t6 entry) wName uName .uint32 (.uint32 (pw>>>1)) (by decide)]
    exact u_at6
  have pAt7 : Pointer (t7 entry pw) pName (.var uName) pp :=
    C99ArrayReference.Pointer.add pName (.var uName) pp pp (.uint64 0#64) pb
      (C99ScalarReference.Eval.variable uName .uint64 (.uint64 0#64) u_at7) (by decide)
      (C99MemoryReference.PointerAdd.within pp 0 pbound)
  have in3 : KeygenZintCall.Exec normSetCC (t7 entry pw) ⟨t8 entry pw,.normal⟩ :=
    word_run _ _ _ (KeygenWordExec.Exec.assign ccName rhsCC (t7 entry pw) .uint32
      (some (.uint32 0#32)) (.uint32 (pw &&& 1)) (cc_at7 entry pw) (by
        show KeygenWordExpr.Eval (t7 entry pw) rhsCC (.uint32 (pw &&& 1))
        refine KeygenWordExpr.Eval.bin .band loadP (.scalar (.literal .i32 1))
          (.uint32 pw) (.int32 1#32) (.uint32 (pw &&& 1)) ?_ ?_ (and_one pw)
        · exact KeygenWordExpr.Eval.load32 pName (.var uName) pp pw pAt7
            (by rw [heap7]; exact pread)
        · exact KeygenWordExpr.Eval.scalar (.literal .i32 1) (.int32 1#32)
            (C99ScalarReference.Eval.literal .int32 1)))
  have xAt8 : Pointer (t8 entry pw) xName (.var uName) px :=
    C99ArrayReference.Pointer.add xName (.var uName) px px (.uint64 0#64)
      (by rw [arrays8]; exact xb)
      (C99ScalarReference.Eval.variable uName .uint64 (.uint64 0#64) (u_at8 entry pw))
      (by decide) (C99MemoryReference.PointerAdd.within px 0 xbound)
  have test1Eval : KeygenWordExpr.Eval (t8 entry pw) test1
      (C99ScalarReference.boolean (decide (xw.toNat<(pw>>>1).toNat))) :=
    KeygenWordExpr.Eval.cmp .lt loadX (.scalar (.var wName)) (.uint32 xw) (.uint32 (pw>>>1))
      (C99ScalarReference.boolean (decide (xw.toNat<(pw>>>1).toNat)))
      (KeygenWordExpr.Eval.load32 xName (.var uName) px xw xAt8 (by rw [heap8]; exact xread))
      (KeygenWordExpr.Eval.scalar (.var wName) (.uint32 (pw>>>1))
        (C99ScalarReference.Eval.variable wName .uint32 (.uint32 (pw>>>1)) (w_at8 entry pw)))
      (lt_word xw (pw>>>1))
  have test2Eval : KeygenWordExpr.Eval (t8 entry pw) test2
      (C99ScalarReference.boolean (decide ((pw>>>1).toNat<xw.toNat))) :=
    KeygenWordExpr.Eval.cmp .gt loadX (.scalar (.var wName)) (.uint32 xw) (.uint32 (pw>>>1))
      (C99ScalarReference.boolean (decide ((pw>>>1).toNat<xw.toNat)))
      (KeygenWordExpr.Eval.load32 xName (.var uName) px xw xAt8 (by rw [heap8]; exact xread))
      (KeygenWordExpr.Eval.scalar (.var wName) (.uint32 (pw>>>1))
        (C99ScalarReference.Eval.variable wName .uint32 (.uint32 (pw>>>1)) (w_at8 entry pw)))
      (gt_word xw (pw>>>1))
  by_cases hlt : xw.toNat<(pw>>>1).toNat
  · -- Case x[0] < p[0]>>>1: the first comparison returns.
    have hltN : xw.toNat<pw.toNat>>>1 := by simpa [BitVec.toNat_ushiftRight] using hlt
    have hgtN : ¬pw.toNat>>>1<xw.toNat := by omega
    have eqN : ¬pw.toNat>>>1=xw.toNat := by omega
    have yes1Run : KeygenZintCall.Exec yes1 (t8 entry pw) ⟨t8 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.scope [] [] (.seq .retVoid wskip) (t8 entry pw)
        ⟨t8 entry pw,.returned none⟩
        (KeygenZintCall.Exec.seqExit .retVoid wskip (t8 entry pw)
          ⟨t8 entry pw,.returned none⟩ (KeygenZintCall.Exec.retVoid (t8 entry pw))
          (by intro h; cases h))
    have branch1Run : KeygenZintCall.Exec normBranch1 (t8 entry pw)
        ⟨t8 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.branchTrue test1 yes1 wskip (t8 entry pw)
        ⟨t8 entry pw,.returned none⟩ (C99ScalarReference.boolean (decide (xw.toNat<(pw>>>1).toNat)))
        test1Eval (lt_bool_nonzero xw pw hlt) yes1Run
    have innerRun : KeygenZintCall.Exec normInner (t5 entry) ⟨t8 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t5 entry) (t6 entry) ⟨t8 entry pw,.returned none⟩ in1
        (KeygenZintCall.Exec.seqNormal _ _ (t6 entry) (t7 entry pw)
          ⟨t8 entry pw,.returned none⟩ in2
          (KeygenZintCall.Exec.seqNormal _ _ (t7 entry pw) (t8 entry pw)
            ⟨t8 entry pw,.returned none⟩ in3
            (KeygenZintCall.Exec.seqExit _ _ (t8 entry pw) ⟨t8 entry pw,.returned none⟩
              branch1Run (by intro h; cases h))))
    have scopeRun : KeygenZintCall.Exec normScope (t5 entry) ⟨t9 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.scope [wName] [] normInner (t5 entry)
        ⟨t8 entry pw,.returned none⟩ innerRun
    have iterRun : KeygenZintCall.Exec normIter (t4 entry) ⟨t9 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t4 entry) (t5 entry) ⟨t9 entry pw,.returned none⟩
        it1 scopeRun
    have loopRun : KeygenZintCall.Exec normLoop (t4 entry) ⟨t9 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.loopReturn normGuard normIter wskip (t4 entry) (t9 entry pw)
        (C99ScalarReference.boolean true) none guard4 (by decide) iterRun
    have loopDecRun : KeygenZintCall.Exec normLoopDec (t4 entry) ⟨t9 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.seqExit _ _ (t4 entry) ⟨t9 entry pw,.returned none⟩ loopRun
        (by intro h; cases h)
    have tailRun : KeygenZintCall.Exec (.seq normLoopDec wskip) (t4 entry)
        ⟨t9 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.seqExit _ _ (t4 entry) ⟨t9 entry pw,.returned none⟩ loopDecRun
        (by intro h; cases h)
    have setURun : KeygenZintCall.Exec (.seq normSetU (.seq normLoopDec wskip)) (t3 entry)
        ⟨t9 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t3 entry) (t4 entry) ⟨t9 entry pw,.returned none⟩
        p4 tailRun
    have cc0Run : KeygenZintCall.Exec (.seq normCC0 (.seq normSetU (.seq normLoopDec wskip)))
        (t2 entry) ⟨t9 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t2 entry) (t3 entry) ⟨t9 entry pw,.returned none⟩
        p3 setURun
    have declURun : KeygenZintCall.Exec
        (.seq normDeclU (.seq normCC0 (.seq normSetU (.seq normLoopDec wskip))))
        (t1 entry) ⟨t9 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t1 entry) (t2 entry) ⟨t9 entry pw,.returned none⟩
        p2 cc0Run
    have fullRun : KeygenZintCall.Exec normBody entry ⟨t9 entry pw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ entry (t1 entry) ⟨t9 entry pw,.returned none⟩
        p1 declURun
    refine ⟨⟨t9 entry pw,.returned none⟩,fullRun,?_,?_,?_,?_⟩
    · rw [t9_heap]; simp [normImage,hgtN]
    · simp [normFlow,eqN]
    · rw [t9_heap]; simp [normWord,hltN]; exact xread
    · intro block offset outside
      rfl
  by_cases hgt : (pw>>>1).toNat<xw.toNat
  · -- Case p[0]>>>1 < x[0]: the second comparison runs zint_sub and returns.
    have hltF : ¬xw.toNat<(pw>>>1).toNat := by omega
    have hgtN : pw.toNat>>>1<xw.toNat := by simpa [BitVec.toNat_ushiftRight] using hgt
    have hltN : ¬xw.toNat<pw.toNat>>>1 := by omega
    have eqN : ¬pw.toNat>>>1=xw.toNat := by omega
    obtain ⟨out,run,flow,heap⟩ := ZintSubWord194.sub_run
      (ZintSubWord194.leafEntry (t8 entry pw) px pp) px pp xw pw
      (ZintSubWord194.leaf_entry_a (t8 entry pw) px pp)
      (ZintSubWord194.leaf_entry_b (t8 entry pw) px pp)
      (ZintSubWord194.leaf_entry_len (t8 entry pw) px pp)
      (by rw [ZintSubWord194.leaf_entry_heap]; rw [heap8]; exact xread)
      (by rw [ZintSubWord194.leaf_entry_heap]; rw [heap8]; exact pread)
      (by rw [ZintSubWord194.leaf_entry_heap]; rw [heap8]; exact allocX) widthX
      (by rw [ZintSubWord194.leaf_entry_heap]; rw [heap8]; exact writableX) xbound pbound
    have xa8 : (t8 entry pw).arrays xName=some px := by rw [arrays8]; exact xb
    have xb8 : (t8 entry pw).arrays pName=some pp := by rw [arrays8]; exact pb
    have lv8 : (t8 entry pw).locals lenName=some (.uint64,some (.uint64 1#64)) :=
      len8 entry pw len
    have callRun : KeygenZintCall.Exec (.call (.leaf .sub) ZintSubWord194.subArgs .discard)
        (t8 entry pw) ⟨{t8 entry pw with heap := out.state.heap},.normal⟩ := by
      refine KeygenZintCall.Exec.call (t8 entry pw) (.leaf .sub) ZintSubWord194.subArgs .discard
        (ZintSubWord194.leafEntry (t8 entry pw) px pp) out
        (some (C99IntegerReference.convert .uint32 ((borrowWord xw pw).toNat : Int)))
        ({t8 entry pw with heap := out.state.heap})
        (ZintSubWord194.bind_leaf (t8 entry pw) px pp xa8 xb8 lv8 xbound pbound) ?_ ?_ ?_
      · exact KeygenZintCall.Exec.word _ _ _ run
      · rw [flow]
        exact C99ProcedureReference.ReturnValue.value .uint32 (.uint32 (borrowWord xw pw))
      · exact KeygenZintCall.ReceiveC.discard _ _
    have stateEq : {t8 entry pw with heap := out.state.heap}=tAfter entry px pw xw := by
      rw [heap,ZintSubWord194.leaf_entry_heap,heap8]
      rfl
    have leafRun : KeygenZintCall.Exec (.call (.leaf .sub) ZintSubWord194.subArgs .discard)
        (t8 entry pw) ⟨tAfter entry px pw xw,.normal⟩ := by
      rw [← stateEq]
      exact callRun
    have retRun : KeygenZintCall.Exec (.seq .retVoid wskip) (tAfter entry px pw xw)
        ⟨tAfter entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.seqExit .retVoid wskip (tAfter entry px pw xw)
        ⟨tAfter entry px pw xw,.returned none⟩
        (KeygenZintCall.Exec.retVoid (tAfter entry px pw xw)) (by intro h; cases h)
    have yes2Run : KeygenZintCall.Exec yes2 (t8 entry pw) ⟨tAfter entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.scope [] [] (.seq (.call (.leaf .sub) ZintSubWord194.subArgs .discard)
        (.seq .retVoid wskip)) (t8 entry pw) ⟨tAfter entry px pw xw,.returned none⟩
        (KeygenZintCall.Exec.seqNormal _ _ (t8 entry pw) (tAfter entry px pw xw)
          ⟨tAfter entry px pw xw,.returned none⟩ leafRun retRun)
    have branch2Run : KeygenZintCall.Exec normBranch2 (t8 entry pw)
        ⟨tAfter entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.branchTrue test2 yes2 wskip (t8 entry pw)
        ⟨tAfter entry px pw xw,.returned none⟩
        (C99ScalarReference.boolean (decide ((pw>>>1).toNat<xw.toNat))) test2Eval
        (gt_bool_nonzero xw pw hgt) yes2Run
    have branch1Run : KeygenZintCall.Exec normBranch1 (t8 entry pw) ⟨t8 entry pw,.normal⟩ :=
      KeygenZintCall.Exec.branchFalse test1 yes1 wskip (t8 entry pw) ⟨t8 entry pw,.normal⟩
        (C99ScalarReference.boolean (decide (xw.toNat<(pw>>>1).toNat))) test1Eval
        (lt_bool_zero xw pw hltF) (word_skip (t8 entry pw))
    have innerTail : KeygenZintCall.Exec (.seq normBranch1 (.seq normBranch2 wskip))
        (t8 entry pw) ⟨tAfter entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t8 entry pw) (t8 entry pw)
        ⟨tAfter entry px pw xw,.returned none⟩ branch1Run
        (KeygenZintCall.Exec.seqExit _ _ (t8 entry pw) ⟨tAfter entry px pw xw,.returned none⟩
          branch2Run (by intro h; cases h))
    have innerRun : KeygenZintCall.Exec normInner (t5 entry)
        ⟨tAfter entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t5 entry) (t6 entry)
        ⟨tAfter entry px pw xw,.returned none⟩ in1
        (KeygenZintCall.Exec.seqNormal _ _ (t6 entry) (t7 entry pw)
          ⟨tAfter entry px pw xw,.returned none⟩ in2
          (KeygenZintCall.Exec.seqNormal _ _ (t7 entry pw) (t8 entry pw)
            ⟨tAfter entry px pw xw,.returned none⟩ in3 innerTail))
    have scopeRun : KeygenZintCall.Exec normScope (t5 entry)
        ⟨tGt9 entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.scope [wName] [] normInner (t5 entry)
        ⟨tAfter entry px pw xw,.returned none⟩ innerRun
    have iterRun : KeygenZintCall.Exec normIter (t4 entry) ⟨tGt9 entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t4 entry) (t5 entry)
        ⟨tGt9 entry px pw xw,.returned none⟩ it1 scopeRun
    have loopRun : KeygenZintCall.Exec normLoop (t4 entry) ⟨tGt9 entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.loopReturn normGuard normIter wskip (t4 entry) (tGt9 entry px pw xw)
        (C99ScalarReference.boolean true) none guard4 (by decide) iterRun
    have loopDecRun : KeygenZintCall.Exec normLoopDec (t4 entry)
        ⟨tGt9 entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.seqExit _ _ (t4 entry) ⟨tGt9 entry px pw xw,.returned none⟩ loopRun
        (by intro h; cases h)
    have tailRun : KeygenZintCall.Exec (.seq normLoopDec wskip) (t4 entry)
        ⟨tGt9 entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.seqExit _ _ (t4 entry) ⟨tGt9 entry px pw xw,.returned none⟩ loopDecRun
        (by intro h; cases h)
    have setURun : KeygenZintCall.Exec (.seq normSetU (.seq normLoopDec wskip)) (t3 entry)
        ⟨tGt9 entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t3 entry) (t4 entry)
        ⟨tGt9 entry px pw xw,.returned none⟩ p4 tailRun
    have cc0Run : KeygenZintCall.Exec (.seq normCC0 (.seq normSetU (.seq normLoopDec wskip)))
        (t2 entry) ⟨tGt9 entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t2 entry) (t3 entry)
        ⟨tGt9 entry px pw xw,.returned none⟩ p3 setURun
    have declURun : KeygenZintCall.Exec
        (.seq normDeclU (.seq normCC0 (.seq normSetU (.seq normLoopDec wskip))))
        (t1 entry) ⟨tGt9 entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t1 entry) (t2 entry)
        ⟨tGt9 entry px pw xw,.returned none⟩ p2 cc0Run
    have fullRun : KeygenZintCall.Exec normBody entry ⟨tGt9 entry px pw xw,.returned none⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ entry (t1 entry)
        ⟨tGt9 entry px pw xw,.returned none⟩ p1 declURun
    refine ⟨⟨tGt9 entry px pw xw,.returned none⟩,fullRun,?_,?_,?_,?_⟩
    · rw [tGt9_heap]
      simp [normImage,hgtN]
    · simp [normFlow,eqN]
    · rw [tGt9_heap]
      simp [normWord,hltN,hgtN]
      exact ZintSubWord194.sub_image entry px xw pw allocX widthX writableX
    · intro block offset outside
      rw [tGt9_heap]
      exact ZintSubWord194.sub_frame entry px xw pw allocX widthX writableX block offset outside
  · -- Tie case: both comparisons false, the loop falls out and u wraps.
    have eq : (pw>>>1).toNat=xw.toNat := by omega
    have hltF : ¬xw.toNat<(pw>>>1).toNat := by omega
    have hgtF : ¬(pw>>>1).toNat<xw.toNat := by omega
    have eqN : pw.toNat>>>1=xw.toNat := by simpa [BitVec.toNat_ushiftRight] using eq
    have hltN : ¬xw.toNat<pw.toNat>>>1 := by omega
    have hgtN : ¬pw.toNat>>>1<xw.toNat := by omega
    have branch1Run : KeygenZintCall.Exec normBranch1 (t8 entry pw) ⟨t8 entry pw,.normal⟩ :=
      KeygenZintCall.Exec.branchFalse test1 yes1 wskip (t8 entry pw) ⟨t8 entry pw,.normal⟩
        (C99ScalarReference.boolean (decide (xw.toNat<(pw>>>1).toNat))) test1Eval
        (lt_bool_zero xw pw hltF) (word_skip (t8 entry pw))
    have branch2Run : KeygenZintCall.Exec normBranch2 (t8 entry pw) ⟨t8 entry pw,.normal⟩ :=
      KeygenZintCall.Exec.branchFalse test2 yes2 wskip (t8 entry pw) ⟨t8 entry pw,.normal⟩
        (C99ScalarReference.boolean (decide ((pw>>>1).toNat<xw.toNat))) test2Eval
        (gt_bool_zero xw pw hgt) (word_skip (t8 entry pw))
    have innerTail : KeygenZintCall.Exec (.seq normBranch1 (.seq normBranch2 wskip))
        (t8 entry pw) ⟨t8 entry pw,.normal⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t8 entry pw) (t8 entry pw)
        ⟨t8 entry pw,.normal⟩ branch1Run
        (KeygenZintCall.Exec.seqNormal _ _ (t8 entry pw) (t8 entry pw)
          ⟨t8 entry pw,.normal⟩ branch2Run (word_skip (t8 entry pw)))
    have innerRun : KeygenZintCall.Exec normInner (t5 entry) ⟨t8 entry pw,.normal⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t5 entry) (t6 entry) ⟨t8 entry pw,.normal⟩ in1
        (KeygenZintCall.Exec.seqNormal _ _ (t6 entry) (t7 entry pw) ⟨t8 entry pw,.normal⟩ in2
          (KeygenZintCall.Exec.seqNormal _ _ (t7 entry pw) (t8 entry pw)
            ⟨t8 entry pw,.normal⟩ in3 innerTail))
    have scopeRun : KeygenZintCall.Exec normScope (t5 entry) ⟨t9 entry pw,.normal⟩ :=
      KeygenZintCall.Exec.scope [wName] [] normInner (t5 entry) ⟨t8 entry pw,.normal⟩ innerRun
    have iterRun : KeygenZintCall.Exec normIter (t4 entry) ⟨t9 entry pw,.normal⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t4 entry) (t5 entry) ⟨t9 entry pw,.normal⟩ it1 scopeRun
    have guard9 : KeygenWordExpr.Eval (t9 entry pw) normGuard
        (C99ScalarReference.boolean false) :=
      KeygenWordExpr.Eval.cmp .gt (.scalar (.var uName)) (.scalar (.literal .i32 0))
        (.uint64 0#64) (.int32 0#32) (C99ScalarReference.boolean false)
        (KeygenWordExpr.Eval.scalar (.var uName) (.uint64 0#64)
          (C99ScalarReference.Eval.variable uName .uint64 (.uint64 0#64) (u_at9 entry pw)))
        (KeygenWordExpr.Eval.scalar (.literal .i32 0) (.int32 0#32)
          (C99ScalarReference.Eval.literal .int32 0))
        gt_zero_false
    have restRun : KeygenZintCall.Exec normLoop (t9 entry pw) ⟨t9 entry pw,.normal⟩ :=
      KeygenZintCall.Exec.loopFalse normGuard normIter wskip (t9 entry pw)
        (C99ScalarReference.boolean false) guard9 (by decide)
    have loopRun : KeygenZintCall.Exec normLoop (t4 entry) ⟨t9 entry pw,.normal⟩ :=
      KeygenZintCall.Exec.loopNormal normGuard normIter wskip (t4 entry) (t9 entry pw)
        (t9 entry pw) ⟨t9 entry pw,.normal⟩ (C99ScalarReference.boolean true) guard4 (by decide)
        iterRun (word_skip (t9 entry pw)) restRun
    have tailDec : KeygenZintCall.Exec normTailDec (t9 entry pw) ⟨tWrap entry pw,.normal⟩ :=
      word_update (t9 entry pw) uName .sub (.literal .i32 1) .uint64 (.uint64 0#64)
        (.int32 1#32) (.uint64 (0#64-1#64)) (u_at9 entry pw)
        (C99ScalarReference.Eval.literal .int32 1) (by
          show C99OperatorBridge.Binary .sub (.uint64 0#64) (.int32 1#32) (.uint64 (0#64-1#64))
          exact dec_zero)
    have loopDecRun : KeygenZintCall.Exec normLoopDec (t4 entry) ⟨tWrap entry pw,.normal⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t4 entry) (t9 entry pw) ⟨tWrap entry pw,.normal⟩
        loopRun tailDec
    have tailRun : KeygenZintCall.Exec (.seq normLoopDec wskip) (t4 entry)
        ⟨tWrap entry pw,.normal⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t4 entry) (tWrap entry pw) ⟨tWrap entry pw,.normal⟩
        loopDecRun (word_skip (tWrap entry pw))
    have setURun : KeygenZintCall.Exec (.seq normSetU (.seq normLoopDec wskip)) (t3 entry)
        ⟨tWrap entry pw,.normal⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t3 entry) (t4 entry) ⟨tWrap entry pw,.normal⟩
        p4 tailRun
    have cc0Run : KeygenZintCall.Exec (.seq normCC0 (.seq normSetU (.seq normLoopDec wskip)))
        (t2 entry) ⟨tWrap entry pw,.normal⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t2 entry) (t3 entry) ⟨tWrap entry pw,.normal⟩
        p3 setURun
    have declURun : KeygenZintCall.Exec
        (.seq normDeclU (.seq normCC0 (.seq normSetU (.seq normLoopDec wskip))))
        (t1 entry) ⟨tWrap entry pw,.normal⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ (t1 entry) (t2 entry) ⟨tWrap entry pw,.normal⟩
        p2 cc0Run
    have fullRun : KeygenZintCall.Exec normBody entry ⟨tWrap entry pw,.normal⟩ :=
      KeygenZintCall.Exec.seqNormal _ _ entry (t1 entry) ⟨tWrap entry pw,.normal⟩ p1 declURun
    refine ⟨⟨tWrap entry pw,.normal⟩,fullRun,?_,?_,?_,?_⟩
    · rw [tWrap_heap]; simp [normImage,hgtN]
    · simp [normFlow,eqN]
    · rw [tWrap_heap]; simp [normWord,hltN,hgtN]; exact xread
    · intro block offset outside
      rw [tWrap_heap]

/- Call-level export: the normZero call statement of the rebuildCrt
   normalize loop at len = 1, with the void return flow. -/
theorem norm_call (before : State) (px pp : ArrayPointer) (xw pw : BitVec 32)
    (xa : before.arrays "x".toList=some px) (xb : before.arrays "tmp".toList=some pp)
    (lv : before.locals "xlen".toList=some (.uint64,some (.uint64 1#64)))
    (xread : Load32 before.heap px xw) (pread : Load32 before.heap pp pw)
    (allocX : Allocated before.heap px) (widthX : px.elementBytes=4)
    (writableX : before.heap.writable px.block=true)
    (xbound : px.index+0≤px.count) (pbound : pp.index+0≤pp.count) :
    KeygenZintCall.Call .normZero before consumerArgs
      {before with heap := normImage before px pw xw} none := by
  obtain ⟨out,run,hheap,hflow,load,frame⟩ := norm_run (normEntry before px pp) px pp xw pw
    (norm_entry_x before px pp) (norm_entry_p before px pp) (norm_entry_len before px pp)
    (by rw [norm_entry_heap]; exact xread) (by rw [norm_entry_heap]; exact pread)
    (by rw [norm_entry_heap]; exact allocX) widthX (by rw [norm_entry_heap]; exact writableX)
    xbound pbound
  refine ⟨normEntry before px pp,out,bind_norm before px pp xa xb lv xbound pbound,run,?_,?_⟩
  · rw [hflow]
    exact void_flow (normFlow pw xw) (flow_shape pw xw)
  · have same : normImage before px pw xw=normImage (normEntry before px pp) px pw xw := by
      simp only [normImage]
      rw [norm_entry_heap]
    rw [same,← hheap]

end FT1536.Source3.ZintNormWord194
