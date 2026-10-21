import Source3.KeygenZintCall098
import Source3.KeygenDecodeWordOps
import Source3.Word32Memory176
import Source3.C99NatWord141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The zint_sub leaf engine at len = 1 (the leaf half of the normZero
   engine). The pinned leaf body `KeygenZintLeaves.code .sub` is executed
   in full at the selected instance len = 1 and exported as executed
   words: the single limb write `a[0] := (a[0]-b[0]) & 0x7FFFFFFF` (the
   parsed store is `w & 0x7FFFFFFF` with `w = a[0]-b[0]-cc`, `cc = 0` on
   the only iteration) and the returned borrow word `(a[0]-b[0]) >>> 31`.
   Everything outside the a[0] cell keeps its bytes (the Store32 frame).

   Route discrepancy, retained as a trap: the CRT route's shorthand "the
   zint_sub write at len = 1 is the unconditional word x-p0" drops the
   31-bit limb mask of the parsed store. The honest executed word is
   `(x - p0) &&& 2147483647`, i.e. the 31-bit limb difference, which is
   NOT the bare 32-bit `x - p0` whenever bit 31 of the difference is set.
   The export here follows the pinned parse record (probe job 510), not
   the shorthand.

   Values stay executed words: no normalization, positivity, CRT or
   range claim is made here. -/
namespace FT1536.Source3.ZintSubWord194
open C99ArrayReference (State Name Pointer Arg bindValue bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32 Store32)
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenZintLeaves (Kind)
open KeygenWordExec (Stmt)

def aName : Name := "a".toList
def bName : Name := "b".toList
def uName : Name := "u".toList
def ccName : Name := "cc".toList
def wName : Name := "w".toList
def lenName : Name := "len".toList

/- The two exported words of one len = 1 limb step. -/
def subWord (x p : BitVec 32) : BitVec 32 := (x - p) &&& 2147483647
def borrowWord (x p : BitVec 32) : BitVec 32 := (x - p) >>> 31

/- Value-conversion bridges used by the cell facts. -/
theorem ofInt_word (w : BitVec 32) : BitVec.ofInt 32 (w.toNat : Int) = w :=
  Value.uint32.inj (KeygenDecodeWordOps.self32 w)

theorem convert_self32 (w : BitVec 32) :
    C99IntegerReference.convert .uint32 (Value.uint32 w).integer=.uint32 w :=
  KeygenDecodeWordOps.self32 w

theorem convert_i32_zero_u64 :
    C99IntegerReference.convert .uint64 (Value.int32 0#32).integer=.uint64 0#64 := by decide

theorem convert_i32_zero_u32 :
    C99IntegerReference.convert .uint32 (Value.int32 0#32).integer=.uint32 0#32 := by decide

theorem convert_u64_one :
    C99IntegerReference.convert .uint64 (Value.uint64 1#64).integer=.uint64 1#64 := by decide

/- Statement pieces of the pinned leaf body (source-bound by sub_shape). -/
def loadA : KeygenWordExpr.Expr := .load32 aName (.var uName)
def loadB : KeygenWordExpr.Expr := .load32 bName (.var uName)
def rhsW : KeygenWordExpr.Expr := .bin .sub (.bin .sub loadA loadB) (.scalar (.var ccName))
def rhsStore : KeygenWordExpr.Expr := .bin .band (.scalar (.var wName))
  (.scalar (.literal .i32 2147483647))
def rhsCC : KeygenWordExpr.Expr := .bin .shr (.scalar (.var wName)) (.scalar (.literal .i32 31))
def declU : Stmt := .modular (.base (.scalar (.declare .u64 [uName])))
def declCC : Stmt := .modular (.base (.scalar (.declare .u32 [ccName])))
def setCC0 : Stmt := .assign ccName (.scalar (.literal .i32 0))
def setU0 : Stmt := .assign uName (.scalar (.literal .i32 0))
def declW : Stmt := .modular (.base (.scalar (.declare .u32 [wName])))
def setW : Stmt := .assign wName rhsW
def storeA : Stmt := .store aName (.var uName) rhsStore
def setCC1 : Stmt := .assign ccName rhsCC
def bodySkip : Stmt := .modular (.base .skip)
def bodyInner : Stmt := .seq declW (.seq setW (.seq storeA (.seq setCC1 bodySkip)))
def bodyScope : Stmt := .scope [wName] bodyInner
def guard : KeygenWordExpr.Expr := .cmp .lt (.scalar (.var uName)) (.scalar (.var lenName))
def increment : Stmt := .modular (.base (.scalar (.update uName .add (.literal .i32 1))))
def loop : Stmt := .loop guard bodyScope increment
def tailRet : Stmt := .ret (.scalar (.var ccName))
def tail : Stmt := .seq tailRet bodySkip
def loopPart : Stmt := .seq setU0 loop
def body : Stmt := .seq declU (.seq declCC (.seq setCC0 (.seq loopPart tail)))

theorem sub_shape : KeygenZintLeaves.code .sub = body := by decide

/- The concrete argument list of the parsed `zint_sub(x, p, len)` call
   inside the zint_norm_zero second branch. -/
def subArgs : List Arg :=
  [ .pointer "x".toList C99ProcedureParser.zero,
    .pointer "p".toList C99ProcedureParser.zero,
    .scalar (.var lenName) ]

/- Entry state created by `Bind` for subArgs at len = 1: fresh frame from
   the caller, then len := 1, b := pb, a := pa (binding order a, b, len). -/
def leafEntry (s : State) (pa pb : ArrayPointer) : State :=
  bindPointer (bindPointer
    (bindValue ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩ lenName .uint64 (.uint64 1#64))
    bName pb) aName pa

theorem leaf_entry_a (s : State) (pa pb : ArrayPointer) :
    (leafEntry s pa pb).arrays aName=some pa := by
  simp [leafEntry,bindPointer,aName,bName]

theorem leaf_entry_b (s : State) (pa pb : ArrayPointer) :
    (leafEntry s pa pb).arrays bName=some pb := by
  simp [leafEntry,bindPointer,aName,bName]

theorem leaf_entry_len (s : State) (pa pb : ArrayPointer) :
    (leafEntry s pa pb).locals lenName=some (.uint64,some (.uint64 1#64)) := by
  simp only [leafEntry,bindPointer,bindValue,C99ScalarReference.set,ite_true]
  rw [convert_u64_one]

theorem leaf_entry_heap (s : State) (pa pb : ArrayPointer) :
    (leafEntry s pa pb).heap=s.heap := rfl

theorem bind_leaf (s : State) (pa pb : ArrayPointer)
    (xa : s.arrays "x".toList=some pa) (xb : s.arrays "p".toList=some pb)
    (lv : s.locals lenName=some (.uint64,some (.uint64 1#64)))
    (abound : pa.index+0≤pa.count) (bbound : pb.index+0≤pb.count) :
    C99ArrayReference.Bind s (KeygenZintLeaves.params .sub) subArgs (leafEntry s pa pb) := by
  have zeroValue : C99ArrayReference.scalar s C99ProcedureParser.zero (.uint64 0#64) :=
    C99ScalarReference.Eval.literal .uint64 0
  have first : Pointer s "x".toList C99ProcedureParser.zero pa :=
    .add "x".toList C99ProcedureParser.zero pa pa (.uint64 0#64) xa zeroValue (by decide)
      (C99MemoryReference.PointerAdd.within pa 0 abound)
  have second : Pointer s "p".toList C99ProcedureParser.zero pb :=
    .add "p".toList C99ProcedureParser.zero pb pb (.uint64 0#64) xb zeroValue (by decide)
      (C99MemoryReference.PointerAdd.within pb 0 bbound)
  have third : C99ArrayReference.scalar s (.var lenName) (.uint64 1#64) :=
    C99ScalarReference.Eval.variable lenName .uint64 (.uint64 1#64) lv
  refine C99ArrayReference.Bind.pointer aName "x".toList C99ProcedureParser.zero pa
    [C99ArrayReference.Param.pointer bName,C99ArrayReference.Param.scalar .uint64 lenName]
    [Arg.pointer "p".toList C99ProcedureParser.zero,Arg.scalar (.var lenName)] _ first ?_
  refine C99ArrayReference.Bind.pointer bName "p".toList C99ProcedureParser.zero pb
    [C99ArrayReference.Param.scalar .uint64 lenName] [Arg.scalar (.var lenName)] _ second ?_
  refine C99ArrayReference.Bind.scalar .uint64 lenName (.var lenName) [] []
    ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩ (.uint64 1#64) third ?_
  exact C99ArrayReference.Bind.nil

/- Word-operation helpers on executed words (the mask/borrow constants of
   the parsed leaf body). -/
theorem minus_cc0 (x : BitVec 32) :
    C99IntegerReference.ArithmeticExec .minus (.uint32 x) (.uint32 0#32) (.uint32 x) := by
  have h := KeygenDecodeWordOps.sub32 x 0#32
  rw [BitVec.sub_zero] at h
  exact h

theorem and_mask (a : BitVec 32) :
    C99IntegerReference.BitwiseExec .and (.uint32 a) (.int32 2147483647#32)
      (.uint32 (a &&& 2147483647#32)) := by
  have source := C99IntegerReference.BitwiseExec.step .and (.uint32 a) (.int32 2147483647#32)
    .uint32 rfl (.uint32 a) (.uint32 2147483647#32) (KeygenDecodeWordOps.self32 a).symm rfl
  have same : C99IntegerReference.convert .uint32
      (C99IntegerReference.bitResult .and (Value.uint32 a).bits
        (Value.uint32 2147483647#32).bits)=.uint32 (a &&& 2147483647#32) := by
    change Value.uint32 (BitVec.ofNat 32 (a &&& 2147483647#32).toNat)=_
    rw [BitVec.toNat_and,← BitVec.toNat_and,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem shr_borrow (a : BitVec 32) :
    C99IntegerReference.ShiftExec .right (.uint32 a) (.int32 31#32) (.uint32 (a >>> 31)) :=
  KeygenDecodeWordOps.right32 a 31 (by decide)

theorem guard_true : C99IntegerReference.CompareExec .lt (.uint64 0#64) (.uint64 1#64)
    (C99ScalarReference.boolean true) := by
  have source := C99IntegerReference.CompareExec.step .lt (.uint64 0#64) (.uint64 1#64) .uint64 rfl
    (.uint64 0#64) (.uint64 1#64) rfl rfl
  have same : (if C99IntegerReference.compare .lt (Value.uint64 0#64).integer
      (Value.uint64 1#64).integer then 1#32 else 0#32)=1#32 := by decide
  rw [same] at source
  exact source

theorem guard_false : C99IntegerReference.CompareExec .lt (.uint64 1#64) (.uint64 1#64)
    (C99ScalarReference.boolean false) := by
  have source := C99IntegerReference.CompareExec.step .lt (.uint64 1#64) (.uint64 1#64) .uint64 rfl
    (.uint64 1#64) (.uint64 1#64) rfl rfl
  have same : (if C99IntegerReference.compare .lt (Value.uint64 1#64).integer
      (Value.uint64 1#64).integer then 1#32 else 0#32)=0#32 := by decide
  rw [same] at source
  exact source

theorem inc_one : C99IntegerReference.ArithmeticExec .plus (.uint64 0#64) (.int32 1#32)
    (.uint64 1#64) :=
  C99NatWord141.add_one 0 (by decide)

/- Generic statement steps at the word level. -/
theorem declare_run (ty : B20.C.Ty) (names : List Name) (before : State) :
    KeygenWordExec.Exec (.modular (.base (.scalar (.declare ty names)))) before
      ⟨C99DeclarationStatements.effect ty names before,.normal⟩ :=
  KeygenWordExec.Exec.modular _ _ _
    (C99ModularReference.GenExec.base _ _ _
      (C99DeclarationStatements.source_exists FftLeafPrograms.program ty names before))

theorem skip_run (before : State) : KeygenWordExec.Exec bodySkip before ⟨before,.normal⟩ :=
  KeygenWordExec.Exec.modular _ _ _
    (C99ModularReference.GenExec.base _ _ _ (C99ArrayReference.Exec.skip before))

theorem update_run (before : State) (name : Name) (op : B20.C.BinOp) (e : CLogic.Expr)
    (ty : Ty) (old rhs out : Value)
    (declared : before.locals name=some (ty,some old))
    (rhsEval : C99ArrayReference.scalar before e rhs)
    (operation : C99OperatorBridge.Binary op old rhs out) :
    KeygenWordExec.Exec (.modular (.base (.scalar (.update name op e)))) before
      ⟨bindValue before name ty out,.normal⟩ := by
  refine KeygenWordExec.Exec.modular _ _ _
    (C99ModularReference.GenExec.base _ _ _
      (C99ArrayReference.Exec.scalar before _ (.update name op e) ?_))
  have head : C99ScalarReference.Eval FprPrefixCalls.calls before.locals
      (C99Frontend.expression (.var name)) old :=
    C99ScalarReference.Eval.variable name ty old declared
  have rhs : C99ScalarReference.Eval FprPrefixCalls.calls before.locals
      (C99Frontend.expression e) rhs := rhsEval
  refine C99ScalarReference.Exec.assign before.locals name _ ty (some old) out declared ?_
  cases op with
  | add => exact C99ScalarReference.Eval.arithmetic .plus _ _ _ _ _ head rhs operation
  | sub => exact C99ScalarReference.Eval.arithmetic .minus _ _ _ _ _ head rhs operation
  | mul => exact C99ScalarReference.Eval.arithmetic .times _ _ _ _ _ head rhs operation
  | band => exact C99ScalarReference.Eval.bitwise .and _ _ _ _ _ head rhs operation
  | bor => exact C99ScalarReference.Eval.bitwise .or _ _ _ _ _ head rhs operation
  | xor => exact C99ScalarReference.Eval.bitwise .xor _ _ _ _ _ head rhs operation
  | shr => exact C99ScalarReference.Eval.shift .right _ _ _ _ _ head rhs operation
  | shl => exact C99ScalarReference.Eval.shift .left _ _ _ _ _ head rhs operation

/- Cell facts. -/
theorem bind_cell (s : State) (name : Name) (ty : Ty) (v : Value) :
    (bindValue s name ty v).locals name=some (ty,some (C99IntegerReference.convert ty v.integer)) :=
  by simp [bindValue,C99ScalarReference.set]

theorem bind_other (s : State) (name other : Name) (ty : Ty) (v : Value)
    (different : other≠name) : (bindValue s name ty v).locals other=s.locals other := by
  simp [bindValue,C99ScalarReference.set,different]

theorem effect_one_cell (ty : B20.C.Ty) (name : Name) (s : State) :
    (C99DeclarationStatements.effect ty [name] s).locals name=
      some (C99ValueBridge.type ty,none) := by
  simp [C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ScalarReference.set]

theorem effect_one_other (ty : B20.C.Ty) (name other : Name) (s : State)
    (different : other≠name) :
    (C99DeclarationStatements.effect ty [name] s).locals other=s.locals other := by
  simp [C99DeclarationStatements.effect,C99DeclarationCells.declareCells,
    C99ScalarReference.set,different]

theorem restore_one_cell (before after : State) (name other : Name)
    (different : other≠name) :
    (restoreScope before after [name] []).locals other=after.locals other := by
  simp [restoreScope,C99ScalarReference.restore,different]

/- The executed run at len = 1. -/
def s1 (entry : State) : State := C99DeclarationStatements.effect .u64 [uName] entry
def s2 (entry : State) : State := C99DeclarationStatements.effect .u32 [ccName] (s1 entry)
def s3 (entry : State) : State := bindValue (s2 entry) ccName .uint32 (.int32 0#32)
def s4 (entry : State) : State := bindValue (s3 entry) uName .uint64 (.int32 0#32)
def s5 (entry : State) : State := C99DeclarationStatements.effect .u32 [wName] (s4 entry)
def s6 (entry : State) (aw bw : BitVec 32) : State :=
  bindValue (s5 entry) wName .uint32 (.uint32 (aw-bw))
def s7 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) : State :=
  {s6 entry aw bw with heap := Word32Memory176.write entry.heap pa (subWord aw bw)}
def s8 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) : State :=
  bindValue (s7 entry pa aw bw) ccName .uint32 (.uint32 (borrowWord aw bw))
def s9 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) : State :=
  restoreScope (s4 entry) (s8 entry pa aw bw) [wName] []
def s10 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) : State :=
  bindValue (s9 entry pa aw bw) uName .uint64 (.uint64 1#64)

theorem arrays_keep (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) :
    (s5 entry).arrays=entry.arrays ∧ (s6 entry aw bw).arrays=entry.arrays ∧
    (s7 entry pa aw bw).arrays=entry.arrays := ⟨rfl,rfl,rfl⟩

theorem heap_keep (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) :
    (s5 entry).heap=entry.heap ∧ (s6 entry aw bw).heap=entry.heap ∧
    (s7 entry pa aw bw).heap=Word32Memory176.write entry.heap pa (subWord aw bw) ∧
    (s10 entry pa aw bw).heap=Word32Memory176.write entry.heap pa (subWord aw bw) :=
  ⟨rfl,rfl,rfl,rfl⟩

theorem u_zero (entry : State) : (s4 entry).locals uName=some (.uint64,some (.uint64 0#64)) := by
  show (bindValue (s3 entry) uName .uint64 (.int32 0#32)).locals uName=_
  rw [bind_cell (s3 entry) uName .uint64 (.int32 0#32)]
  rw [convert_i32_zero_u64]

theorem u_zero5 (entry : State) : (s5 entry).locals uName=some (.uint64,some (.uint64 0#64)) := by
  show (C99DeclarationStatements.effect .u32 [wName] (s4 entry)).locals uName=_
  rw [effect_one_other .u32 wName uName (s4 entry) (by decide)]
  exact u_zero entry

theorem u_zero6 (entry : State) (aw bw : BitVec 32) :
    (s6 entry aw bw).locals uName=some (.uint64,some (.uint64 0#64)) := by
  show (bindValue (s5 entry) wName .uint32 (.uint32 (aw-bw))).locals uName=_
  rw [bind_other (s5 entry) wName uName .uint32 (.uint32 (aw-bw)) (by decide)]
  exact u_zero5 entry

theorem u_zero7 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) :
    (s7 entry pa aw bw).locals uName=some (.uint64,some (.uint64 0#64)) :=
  u_zero6 entry aw bw

theorem u_zero9 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) :
    (s9 entry pa aw bw).locals uName=some (.uint64,some (.uint64 0#64)) := by
  show (restoreScope (s4 entry) (s8 entry pa aw bw) [wName] []).locals uName=_
  rw [restore_one_cell (s4 entry) (s8 entry pa aw bw) wName uName (by decide)]
  show (bindValue (s7 entry pa aw bw) ccName .uint32 (.uint32 (borrowWord aw bw))).locals uName=_
  rw [bind_other (s7 entry pa aw bw) ccName uName .uint32 (.uint32 (borrowWord aw bw))
    (by decide)]
  exact u_zero7 entry pa aw bw

theorem u_one10 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) :
    (s10 entry pa aw bw).locals uName=some (.uint64,some (.uint64 1#64)) := by
  show (bindValue (s9 entry pa aw bw) uName .uint64 (.uint64 1#64)).locals uName=_
  rw [bind_cell (s9 entry pa aw bw) uName .uint64 (.uint64 1#64)]
  rw [convert_u64_one]

theorem cc_zero (entry : State) : (s3 entry).locals ccName=some (.uint32,some (.uint32 0#32)) := by
  show (bindValue (s2 entry) ccName .uint32 (.int32 0#32)).locals ccName=_
  rw [bind_cell (s2 entry) ccName .uint32 (.int32 0#32)]
  rw [convert_i32_zero_u32]

theorem cc_zero5 (entry : State) : (s5 entry).locals ccName=some (.uint32,some (.uint32 0#32)) := by
  show (C99DeclarationStatements.effect .u32 [wName] (s4 entry)).locals ccName=_
  rw [effect_one_other .u32 wName ccName (s4 entry) (by decide)]
  show (bindValue (s3 entry) uName .uint64 (.int32 0#32)).locals ccName=_
  rw [bind_other (s3 entry) uName ccName .uint64 (.int32 0#32) (by decide)]
  exact cc_zero entry

theorem cc_zero6 (entry : State) (aw bw : BitVec 32) :
    (s6 entry aw bw).locals ccName=some (.uint32,some (.uint32 0#32)) := by
  show (bindValue (s5 entry) wName .uint32 (.uint32 (aw-bw))).locals ccName=_
  rw [bind_other (s5 entry) wName ccName .uint32 (.uint32 (aw-bw)) (by decide)]
  exact cc_zero5 entry

theorem cc_zero7 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) :
    (s7 entry pa aw bw).locals ccName=some (.uint32,some (.uint32 0#32)) :=
  cc_zero6 entry aw bw

theorem w_decl (entry : State) : (s5 entry).locals wName=some (.uint32,none) :=
  effect_one_cell .u32 wName (s4 entry)

theorem w_set (entry : State) (aw bw : BitVec 32) :
    (s6 entry aw bw).locals wName=some (.uint32,some (.uint32 (aw-bw))) := by
  show (bindValue (s5 entry) wName .uint32 (.uint32 (aw-bw))).locals wName=_
  rw [bind_cell (s5 entry) wName .uint32 (.uint32 (aw-bw))]
  rw [convert_self32 (aw-bw)]

theorem w_set7 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) :
    (s7 entry pa aw bw).locals wName=some (.uint32,some (.uint32 (aw-bw))) :=
  w_set entry aw bw

theorem cc_set8 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) :
    (s8 entry pa aw bw).locals ccName=some (.uint32,some (.uint32 (borrowWord aw bw))) := by
  show (bindValue (s7 entry pa aw bw) ccName .uint32 (.uint32 (borrowWord aw bw))).locals ccName=_
  rw [bind_cell (s7 entry pa aw bw) ccName .uint32 (.uint32 (borrowWord aw bw))]
  rw [convert_self32 (borrowWord aw bw)]

theorem cc_set10 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32) :
    (s10 entry pa aw bw).locals ccName=some (.uint32,some (.uint32 (borrowWord aw bw))) := by
  show (bindValue (s9 entry pa aw bw) uName .uint64 (.uint64 1#64)).locals ccName=_
  rw [bind_other (s9 entry pa aw bw) uName ccName .uint64 (.uint64 1#64) (by decide)]
  show (restoreScope (s4 entry) (s8 entry pa aw bw) [wName] []).locals ccName=_
  rw [restore_one_cell (s4 entry) (s8 entry pa aw bw) wName ccName (by decide)]
  exact cc_set8 entry pa aw bw

theorem len4 (entry : State) (len : entry.locals lenName=some (.uint64,some (.uint64 1#64))) :
    (s4 entry).locals lenName=some (.uint64,some (.uint64 1#64)) := by
  show (bindValue (s3 entry) uName .uint64 (.int32 0#32)).locals lenName=_
  rw [bind_other (s3 entry) uName lenName .uint64 (.int32 0#32) (by decide)]
  show (bindValue (s2 entry) ccName .uint32 (.int32 0#32)).locals lenName=_
  rw [bind_other (s2 entry) ccName lenName .uint32 (.int32 0#32) (by decide)]
  show (C99DeclarationStatements.effect .u32 [ccName] (s1 entry)).locals lenName=_
  rw [effect_one_other .u32 ccName lenName (s1 entry) (by decide)]
  show (C99DeclarationStatements.effect .u64 [uName] entry).locals lenName=_
  rw [effect_one_other .u64 uName lenName entry (by decide)]
  exact len

theorem len10 (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32)
    (len : entry.locals lenName=some (.uint64,some (.uint64 1#64))) :
    (s10 entry pa aw bw).locals lenName=some (.uint64,some (.uint64 1#64)) := by
  show (bindValue (s9 entry pa aw bw) uName .uint64 (.uint64 1#64)).locals lenName=_
  rw [bind_other (s9 entry pa aw bw) uName lenName .uint64 (.uint64 1#64) (by decide)]
  show (restoreScope (s4 entry) (s8 entry pa aw bw) [wName] []).locals lenName=_
  rw [restore_one_cell (s4 entry) (s8 entry pa aw bw) wName lenName (by decide)]
  show (bindValue (s7 entry pa aw bw) ccName .uint32 (.uint32 (borrowWord aw bw))).locals lenName=_
  rw [bind_other (s7 entry pa aw bw) ccName lenName .uint32 (.uint32 (borrowWord aw bw))
    (by decide)]
  show (bindValue (s6 entry aw bw) wName .uint32 (.uint32 (aw-bw))).locals lenName=_
  rw [bind_other (s6 entry aw bw) wName lenName .uint32 (.uint32 (aw-bw)) (by decide)]
  show (C99DeclarationStatements.effect .u32 [wName] (s4 entry)).locals lenName=_
  rw [effect_one_other .u32 wName lenName (s4 entry) (by decide)]
  show (bindValue (s3 entry) uName .uint64 (.int32 0#32)).locals lenName=_
  rw [bind_other (s3 entry) uName lenName .uint64 (.int32 0#32) (by decide)]
  show (bindValue (s2 entry) ccName .uint32 (.int32 0#32)).locals lenName=_
  rw [bind_other (s2 entry) ccName lenName .uint32 (.int32 0#32) (by decide)]
  show (C99DeclarationStatements.effect .u32 [ccName] (s1 entry)).locals lenName=_
  rw [effect_one_other .u32 ccName lenName (s1 entry) (by decide)]
  show (C99DeclarationStatements.effect .u64 [uName] entry).locals lenName=_
  rw [effect_one_other .u64 uName lenName entry (by decide)]
  exact len

theorem sub_run (entry : State) (pa pb : ArrayPointer) (aw bw : BitVec 32)
    (aa : entry.arrays aName=some pa) (ba : entry.arrays bName=some pb)
    (len : entry.locals lenName=some (.uint64,some (.uint64 1#64)))
    (aread : Load32 entry.heap pa aw) (bread : Load32 entry.heap pb bw)
    (alloc : Allocated entry.heap pa) (width : pa.elementBytes=4)
    (writable : entry.heap.writable pa.block=true)
    (abound : pa.index+0≤pa.count) (bbound : pb.index+0≤pb.count) :
    ∃ out : Result, KeygenWordExec.Exec (KeygenZintLeaves.code .sub) entry out
      ∧ out.flow=.returned (some (.uint32 (borrowWord aw bw)))
      ∧ out.state.heap=Word32Memory176.write entry.heap pa (subWord aw bw) := by
  rw [sub_shape]
  have arrays := arrays_keep entry pa aw bw
  have heaps := heap_keep entry pa aw bw
  have aAt (s : State) (same : s.arrays=entry.arrays)
      (u : s.locals uName=some (.uint64,some (.uint64 0#64))) :
      Pointer s aName (.var uName) pa :=
    C99ArrayReference.Pointer.add aName (.var uName) pa pa (.uint64 0#64)
      (by rw [same]; exact aa)
      (C99ScalarReference.Eval.variable uName .uint64 (.uint64 0#64) u) (by decide)
      (C99MemoryReference.PointerAdd.within pa 0 abound)
  have bAt (s : State) (same : s.arrays=entry.arrays)
      (u : s.locals uName=some (.uint64,some (.uint64 0#64))) :
      Pointer s bName (.var uName) pb :=
    C99ArrayReference.Pointer.add bName (.var uName) pb pb (.uint64 0#64)
      (by rw [same]; exact ba)
      (C99ScalarReference.Eval.variable uName .uint64 (.uint64 0#64) u) (by decide)
      (C99MemoryReference.PointerAdd.within pb 0 bbound)
  have h1 : KeygenWordExec.Exec declU entry ⟨s1 entry,.normal⟩ :=
    declare_run .u64 [uName] entry
  have h2 : KeygenWordExec.Exec declCC (s1 entry) ⟨s2 entry,.normal⟩ :=
    declare_run .u32 [ccName] (s1 entry)
  have h3 : KeygenWordExec.Exec setCC0 (s2 entry) ⟨s3 entry,.normal⟩ :=
    KeygenWordExec.Exec.assign ccName (.scalar (.literal .i32 0)) (s2 entry) .uint32 none
      (.int32 0#32) (effect_one_cell .u32 ccName (s1 entry))
      (KeygenWordExpr.Eval.scalar (.literal .i32 0) (.int32 0#32)
        (C99ScalarReference.Eval.literal .int32 0))
  have uDecl3 : (s3 entry).locals uName=some (.uint64,none) := by
    show (bindValue (s2 entry) ccName .uint32 (.int32 0#32)).locals uName=_
    rw [bind_other (s2 entry) ccName uName .uint32 (.int32 0#32) (by decide)]
    show (C99DeclarationStatements.effect .u32 [ccName] (s1 entry)).locals uName=_
    rw [effect_one_other .u32 ccName uName (s1 entry) (by decide)]
    show (C99DeclarationStatements.effect .u64 [uName] entry).locals uName=_
    exact effect_one_cell .u64 uName entry
  have h4 : KeygenWordExec.Exec setU0 (s3 entry) ⟨s4 entry,.normal⟩ :=
    KeygenWordExec.Exec.assign uName (.scalar (.literal .i32 0)) (s3 entry) .uint64 none
      (.int32 0#32) uDecl3
      (KeygenWordExpr.Eval.scalar (.literal .i32 0) (.int32 0#32)
        (C99ScalarReference.Eval.literal .int32 0))
  have h5 : KeygenWordExec.Exec declW (s4 entry) ⟨s5 entry,.normal⟩ :=
    declare_run .u32 [wName] (s4 entry)
  have h6 : KeygenWordExec.Exec setW (s5 entry) ⟨s6 entry aw bw,.normal⟩ :=
    KeygenWordExec.Exec.assign wName rhsW (s5 entry) .uint32 none (.uint32 (aw-bw))
      (w_decl entry) (by
        show KeygenWordExpr.Eval (s5 entry) rhsW (.uint32 (aw-bw))
        refine KeygenWordExpr.Eval.bin .sub (.bin .sub loadA loadB) (.scalar (.var ccName))
          (.uint32 (aw-bw)) (.uint32 0#32) (.uint32 (aw-bw)) ?_ ?_ (minus_cc0 (aw-bw))
        · refine KeygenWordExpr.Eval.bin .sub loadA loadB (.uint32 aw) (.uint32 bw)
            (.uint32 (aw-bw)) ?_ ?_ (KeygenDecodeWordOps.sub32 aw bw)
          · exact KeygenWordExpr.Eval.load32 aName (.var uName) pa aw
              (aAt (s5 entry) arrays.1 (u_zero5 entry)) (by rw [heaps.1]; exact aread)
          · exact KeygenWordExpr.Eval.load32 bName (.var uName) pb bw
              (bAt (s5 entry) arrays.1 (u_zero5 entry)) (by rw [heaps.1]; exact bread)
        · exact KeygenWordExpr.Eval.scalar (.var ccName) (.uint32 0#32)
            (C99ScalarReference.Eval.variable ccName .uint32 (.uint32 0#32)
              (cc_zero5 entry)))
  have stored : Store32 (s6 entry aw bw).heap pa
      (BitVec.ofInt 32 ((subWord aw bw).toNat : Int))
      (Word32Memory176.write entry.heap pa (subWord aw bw)) := by
    rw [heaps.2.1,ofInt_word]
    exact Word32Memory176.source entry.heap pa (subWord aw bw) alloc width writable
  have h7 : KeygenWordExec.Exec storeA (s6 entry aw bw) ⟨s7 entry pa aw bw,.normal⟩ :=
    KeygenWordExec.Exec.store aName (.var uName) rhsStore (s6 entry aw bw)
      (Word32Memory176.write entry.heap pa (subWord aw bw)) pa (.uint32 (subWord aw bw))
      (aAt (s6 entry aw bw) arrays.2.1 (u_zero6 entry aw bw))
      (KeygenWordExpr.Eval.bin .band (.scalar (.var wName)) (.scalar (.literal .i32 2147483647))
        (.uint32 (aw-bw)) (.int32 2147483647#32) (.uint32 (subWord aw bw))
        (KeygenWordExpr.Eval.scalar (.var wName) (.uint32 (aw-bw))
          (C99ScalarReference.Eval.variable wName .uint32 (.uint32 (aw-bw)) (w_set entry aw bw)))
        (KeygenWordExpr.Eval.scalar (.literal .i32 2147483647) (.int32 2147483647#32)
          (C99ScalarReference.Eval.literal .int32 2147483647))
        (by
          show C99IntegerReference.BitwiseExec .and (.uint32 (aw-bw)) (.int32 2147483647#32)
            (.uint32 (subWord aw bw))
          rw [subWord]
          exact and_mask (aw-bw)))
      stored
  have h8 : KeygenWordExec.Exec setCC1 (s7 entry pa aw bw) ⟨s8 entry pa aw bw,.normal⟩ :=
    KeygenWordExec.Exec.assign ccName rhsCC (s7 entry pa aw bw) .uint32 (some (.uint32 0#32))
      (.uint32 (borrowWord aw bw)) (cc_zero7 entry pa aw bw)
      (KeygenWordExpr.Eval.bin .shr (.scalar (.var wName)) (.scalar (.literal .i32 31))
        (.uint32 (aw-bw)) (.int32 31#32) (.uint32 (borrowWord aw bw))
        (KeygenWordExpr.Eval.scalar (.var wName) (.uint32 (aw-bw))
          (C99ScalarReference.Eval.variable wName .uint32 (.uint32 (aw-bw)) (w_set7 entry pa aw bw)))
        (KeygenWordExpr.Eval.scalar (.literal .i32 31) (.int32 31#32)
          (C99ScalarReference.Eval.literal .int32 31))
        (by
          show C99IntegerReference.ShiftExec .right (.uint32 (aw-bw)) (.int32 31#32)
            (.uint32 (borrowWord aw bw))
          rw [borrowWord]
          exact shr_borrow (aw-bw)))
  have h9 : KeygenWordExec.Exec bodySkip (s8 entry pa aw bw) ⟨s8 entry pa aw bw,.normal⟩ :=
    skip_run _
  have hInner : KeygenWordExec.Exec bodyInner (s4 entry) ⟨s8 entry pa aw bw,.normal⟩ :=
    KeygenWordExec.Exec.seqNormal _ _ (s4 entry) (s5 entry) ⟨s8 entry pa aw bw,.normal⟩ h5
      (KeygenWordExec.Exec.seqNormal _ _ (s5 entry) (s6 entry aw bw)
        ⟨s8 entry pa aw bw,.normal⟩ h6
        (KeygenWordExec.Exec.seqNormal _ _ (s6 entry aw bw) (s7 entry pa aw bw)
          ⟨s8 entry pa aw bw,.normal⟩ h7
          (KeygenWordExec.Exec.seqNormal _ _ (s7 entry pa aw bw) (s8 entry pa aw bw)
            ⟨s8 entry pa aw bw,.normal⟩ h8 h9)))
  have hScope : KeygenWordExec.Exec bodyScope (s4 entry) ⟨s9 entry pa aw bw,.normal⟩ :=
    KeygenWordExec.Exec.scope [wName] bodyInner (s4 entry) ⟨s8 entry pa aw bw,.normal⟩ hInner
  have hInc : KeygenWordExec.Exec increment (s9 entry pa aw bw) ⟨s10 entry pa aw bw,.normal⟩ :=
    update_run (s9 entry pa aw bw) uName .add (.literal .i32 1) .uint64 (.uint64 0#64)
      (.int32 1#32) (.uint64 1#64) (u_zero9 entry pa aw bw)
      (C99ScalarReference.Eval.literal .int32 1) (by
        show C99OperatorBridge.Binary .add (.uint64 0#64) (.int32 1#32) (.uint64 1#64)
        exact inc_one)
  have hRest : KeygenWordExec.Exec loop (s10 entry pa aw bw) ⟨s10 entry pa aw bw,.normal⟩ :=
    KeygenWordExec.Exec.loopFalse guard bodyScope increment (s10 entry pa aw bw) (.int32 0#32)
      (KeygenWordExpr.Eval.cmp .lt (.scalar (.var uName)) (.scalar (.var lenName))
        (.uint64 1#64) (.uint64 1#64) (.int32 0#32)
        (KeygenWordExpr.Eval.scalar (.var uName) (.uint64 1#64)
          (C99ScalarReference.Eval.variable uName .uint64 (.uint64 1#64)
            (u_one10 entry pa aw bw)))
        (KeygenWordExpr.Eval.scalar (.var lenName) (.uint64 1#64)
          (C99ScalarReference.Eval.variable lenName .uint64 (.uint64 1#64)
            (len10 entry pa aw bw len)))
        guard_false)
      (by decide)
  have hLoop : KeygenWordExec.Exec loop (s4 entry) ⟨s10 entry pa aw bw,.normal⟩ :=
    KeygenWordExec.Exec.loopNormal guard bodyScope increment (s4 entry) (s9 entry pa aw bw)
      (s10 entry pa aw bw) ⟨s10 entry pa aw bw,.normal⟩ (.int32 1#32)
      (KeygenWordExpr.Eval.cmp .lt (.scalar (.var uName)) (.scalar (.var lenName))
        (.uint64 0#64) (.uint64 1#64) (.int32 1#32)
        (KeygenWordExpr.Eval.scalar (.var uName) (.uint64 0#64)
          (C99ScalarReference.Eval.variable uName .uint64 (.uint64 0#64) (u_zero entry)))
        (KeygenWordExpr.Eval.scalar (.var lenName) (.uint64 1#64)
          (C99ScalarReference.Eval.variable lenName .uint64 (.uint64 1#64) (len4 entry len)))
        guard_true)
      (by decide) hScope hInc hRest
  have hLoopPart : KeygenWordExec.Exec loopPart (s3 entry) ⟨s10 entry pa aw bw,.normal⟩ :=
    KeygenWordExec.Exec.seqNormal _ _ (s3 entry) (s4 entry) ⟨s10 entry pa aw bw,.normal⟩ h4 hLoop
  have hRet : KeygenWordExec.Exec tailRet (s10 entry pa aw bw)
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ :=
    KeygenWordExec.Exec.ret (.scalar (.var ccName)) (s10 entry pa aw bw)
      (.uint32 (borrowWord aw bw))
      (KeygenWordExpr.Eval.scalar (.var ccName) (.uint32 (borrowWord aw bw))
        (C99ScalarReference.Eval.variable ccName .uint32 (.uint32 (borrowWord aw bw))
          (cc_set10 entry pa aw bw)))
  have hTail : KeygenWordExec.Exec tail (s10 entry pa aw bw)
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ :=
    KeygenWordExec.Exec.seqExit _ _ (s10 entry pa aw bw)
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ hRet (by intro h; cases h)
  have hRest3 : KeygenWordExec.Exec (.seq loopPart tail) (s3 entry)
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ :=
    KeygenWordExec.Exec.seqNormal _ _ (s3 entry) (s10 entry pa aw bw)
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ hLoopPart hTail
  have hCC0 : KeygenWordExec.Exec (.seq setCC0 (.seq loopPart tail)) (s2 entry)
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ :=
    KeygenWordExec.Exec.seqNormal _ _ (s2 entry) (s3 entry)
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ h3 hRest3
  have hDeclCC : KeygenWordExec.Exec (.seq declCC (.seq setCC0 (.seq loopPart tail))) (s1 entry)
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ :=
    KeygenWordExec.Exec.seqNormal _ _ (s1 entry) (s2 entry)
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ h2 hCC0
  have hFull : KeygenWordExec.Exec body entry
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ :=
    KeygenWordExec.Exec.seqNormal _ _ entry (s1 entry)
      ⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩ h1 hDeclCC
  exact ⟨⟨s10 entry pa aw bw,.returned (some (.uint32 (borrowWord aw bw)))⟩,hFull,rfl,
    heaps.2.2.2⟩

/- Image and frame corollaries of the single limb write. -/
theorem sub_image (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32)
    (alloc : Allocated entry.heap pa) (width : pa.elementBytes=4)
    (writable : entry.heap.writable pa.block=true) :
    Load32 (Word32Memory176.write entry.heap pa (subWord aw bw)) pa (subWord aw bw) :=
  Word32Memory176.here entry.heap pa (subWord aw bw) alloc width writable

theorem sub_frame (entry : State) (pa : ArrayPointer) (aw bw : BitVec 32)
    (alloc : Allocated entry.heap pa) (width : pa.elementBytes=4)
    (writable : entry.heap.writable pa.block=true) :
    ∀ block offset, block≠pa.block ∨ offset<pa.offset ∨ pa.offset+4≤offset →
      (Word32Memory176.write entry.heap pa (subWord aw bw)).bytes block offset=
        entry.heap.bytes block offset :=
  (Word32Memory176.source entry.heap pa (subWord aw bw) alloc width writable).2.2.2.2.2.2

/- Call-level export: the leaf call statement at len = 1. -/
theorem call_len1 (s : State) (pa pb : ArrayPointer) (aw bw : BitVec 32)
    (xa : s.arrays "x".toList=some pa) (xb : s.arrays "p".toList=some pb)
    (lv : s.locals lenName=some (.uint64,some (.uint64 1#64)))
    (aread : Load32 s.heap pa aw) (bread : Load32 s.heap pb bw)
    (alloc : Allocated s.heap pa) (width : pa.elementBytes=4)
    (writable : s.heap.writable pa.block=true)
    (abound : pa.index+0≤pa.count) (bbound : pb.index+0≤pb.count) :
    KeygenZintLeaves.Call .sub s subArgs
      {s with heap := Word32Memory176.write s.heap pa (subWord aw bw)}
      (some (C99IntegerReference.convert .uint32 ((borrowWord aw bw).toNat : Int))) := by
  obtain ⟨out,run,flow,heap⟩ := sub_run (leafEntry s pa pb) pa pb aw bw
    (leaf_entry_a s pa pb) (leaf_entry_b s pa pb) (leaf_entry_len s pa pb)
    (by rw [leaf_entry_heap]; exact aread) (by rw [leaf_entry_heap]; exact bread)
    (by rw [leaf_entry_heap]; exact alloc) width (by rw [leaf_entry_heap]; exact writable)
    abound bbound
  rw [← leaf_entry_heap,← heap]
  refine KeygenZintLeaves.Call.run (leafEntry s pa pb) out
    (some (C99IntegerReference.convert .uint32 ((borrowWord aw bw).toNat : Int)))
    (bind_leaf s pa pb xa xb lv abound bbound) run ?_
  rw [flow]
  exact C99ProcedureReference.ReturnValue.value .uint32 (.uint32 (borrowWord aw bw))
end FT1536.Source3.ZintSubWord194
