import Source3.KeygenModpR2Exec
import Source3.KeygenRxCallees
import Source3.ZintSubWord194
import Source3.KeygenDecodeWordOps

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The modp_Rx engine at the empty-loop instance x = 1 (the
   additional-prime prologue statement `Rx = modp_Rx(slen, p, p0i, R2)`
   at slen = 1, MakeFgAddPrimeShape194.rxSet, make_fg_step part 4).
   The pinned body C99ModularReference.rxCode (source binding
   KeygenRxCallees.rx_source_bound / rx_transcription) is executed in
   full at x = 1: the x decrement leaves 0, the r = R2 store, the
   z = modp_R(p) leaf call at its pinned body (KeygenModpR), the EMPTY
   loop (the guard `(1U << i) <= x` is false already at i = 0) and the z
   return — so the executed word of the whole callee is the pinned leaf
   word KeygenModpR.word p. This replaces the earlier paper note "the
   intended word is modp_R(p)" by a kernel-checked statement, in the
   KeygenModpR2Exec body_exists pattern at the LeafCall stratum;
   body_exact shows the same returned word for EVERY derivation.

   Values stay executed words: no residue range, Montgomery law,
   positivity or correctness claim of the C algorithm is made here. -/
namespace FT1536.Source3.KeygenModpRxExec
open C99ModularReference
open C99ArrayReference (State bindValue)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)

/- Statement pieces of the pinned body rxCode. -/
def declI : Stmt := .base (.scalar (.declare .i32 ["i".toList]))
def declRZ : Stmt := .base (.scalar (.declare .u32 ["r".toList,"z".toList]))
def xDec : Stmt := .base (.scalar (.update "x".toList .sub (.literal .i32 1)))
def rSet : Stmt := .assign "r".toList (rxCell "R2")
def zSet : Stmt := .assign "z".toList (.call1 "modp_R".toList (rxCell "p"))
def iInit : Stmt := .assign "i".toList (.scalar (.literal .i32 0))
def loopRun : Stmt := .loop rxLoopGuard rxLoopBody rxLoopStep
def retZ : Stmt := .ret (rxCell "z")

theorem loop_split : rxLoop=.seq iInit loopRun := rfl
theorem code_split : rxCode=chainOf [declI,declRZ,xDec,rSet,zSet,rxLoop,retZ] := rfl

/- Executed states at x = 1 (p/p0i/r2 arbitrary words). -/
def entry (base : State) (p p0i r2 : BitVec 32) : State :=
  bindParams base rxParams [.uint32 1#32,.uint32 p,.uint32 p0i,.uint32 r2]
def s1 (base : State) (p p0i r2 : BitVec 32) : State :=
  C99DeclarationStatements.effect .i32 ["i".toList] (entry base p p0i r2)
def s2 (base : State) (p p0i r2 : BitVec 32) : State :=
  C99DeclarationStatements.effect .u32 ["r".toList,"z".toList] (s1 base p p0i r2)
def s3 (base : State) (p p0i r2 : BitVec 32) : State :=
  bindValue (s2 base p p0i r2) "x".toList .uint32 (.uint32 0#32)
def s4 (base : State) (p p0i r2 : BitVec 32) : State :=
  bindValue (s3 base p p0i r2) "r".toList .uint32 (.uint32 r2)
def s5 (base : State) (p p0i r2 : BitVec 32) : State :=
  bindValue (s4 base p p0i r2) "z".toList .uint32 (.uint32 (KeygenModpR.word p))
def s6 (base : State) (p p0i r2 : BitVec 32) : State :=
  bindValue (s5 base p p0i r2) "i".toList .int32 (.int32 0#32)

/- Cell facts of the executed states (consumed by both directions). The
   literal-word cells are kernel reductions; the variable-word cells
   convert through ZintSubWord194.convert_self32. -/
theorem entry_x (base : State) (p p0i r2 : BitVec 32) :
    (entry base p p0i r2).locals "x".toList=some (.uint32,some (.uint32 1#32)) := rfl

theorem entry_p (base : State) (p p0i r2 : BitVec 32) :
    (entry base p p0i r2).locals "p".toList=some (.uint32,some (.uint32 p)) := by
  have h : (entry base p p0i r2).locals "p".toList=
      some (.uint32,some (C99IntegerReference.convert .uint32 (Value.uint32 p).integer)) := rfl
  rw [h]
  exact congrArg (fun w => some (C99IntegerReference.Ty.uint32,some w))
    (ZintSubWord194.convert_self32 p)

theorem entry_R2 (base : State) (p p0i r2 : BitVec 32) :
    (entry base p p0i r2).locals "R2".toList=some (.uint32,some (.uint32 r2)) := by
  have h : (entry base p p0i r2).locals "R2".toList=
      some (.uint32,some (C99IntegerReference.convert .uint32 (Value.uint32 r2).integer)) := rfl
  rw [h]
  exact congrArg (fun w => some (C99IntegerReference.Ty.uint32,some w))
    (ZintSubWord194.convert_self32 r2)

theorem s2_x (base : State) (p p0i r2 : BitVec 32) :
    (s2 base p p0i r2).locals "x".toList=some (.uint32,some (.uint32 1#32)) := rfl

theorem s3_r (base : State) (p p0i r2 : BitVec 32) :
    (s3 base p p0i r2).locals "r".toList=some (.uint32,none) := rfl

theorem s3_R2 (base : State) (p p0i r2 : BitVec 32) :
    (s3 base p p0i r2).locals "R2".toList=some (.uint32,some (.uint32 r2)) := by
  have h : (s3 base p p0i r2).locals "R2".toList=
      some (.uint32,some (C99IntegerReference.convert .uint32 (Value.uint32 r2).integer)) := rfl
  rw [h]
  exact congrArg (fun w => some (C99IntegerReference.Ty.uint32,some w))
    (ZintSubWord194.convert_self32 r2)

theorem s4_z (base : State) (p p0i r2 : BitVec 32) :
    (s4 base p p0i r2).locals "z".toList=some (.uint32,none) := rfl

theorem s4_p (base : State) (p p0i r2 : BitVec 32) :
    (s4 base p p0i r2).locals "p".toList=some (.uint32,some (.uint32 p)) := by
  have h : (s4 base p p0i r2).locals "p".toList=
      some (.uint32,some (C99IntegerReference.convert .uint32 (Value.uint32 p).integer)) := rfl
  rw [h]
  exact congrArg (fun w => some (C99IntegerReference.Ty.uint32,some w))
    (ZintSubWord194.convert_self32 p)

theorem s5_i (base : State) (p p0i r2 : BitVec 32) :
    (s5 base p p0i r2).locals "i".toList=some (.int32,none) := rfl

theorem s5_x (base : State) (p p0i r2 : BitVec 32) :
    (s5 base p p0i r2).locals "x".toList=some (.uint32,some (.uint32 0#32)) := rfl

theorem s6_i (base : State) (p p0i r2 : BitVec 32) :
    (s6 base p p0i r2).locals "i".toList=some (.int32,some (.int32 0#32)) := rfl

theorem s6_x (base : State) (p p0i r2 : BitVec 32) :
    (s6 base p p0i r2).locals "x".toList=some (.uint32,some (.uint32 0#32)) := rfl

theorem s6_z (base : State) (p p0i r2 : BitVec 32) :
    (s6 base p p0i r2).locals "z".toList=some (.uint32,some (.uint32 (KeygenModpR.word p))) := by
  have h : (s6 base p p0i r2).locals "z".toList=
      some (.uint32,some (C99IntegerReference.convert .uint32
        (Value.uint32 (KeygenModpR.word p)).integer)) := rfl
  rw [h]
  exact congrArg (fun w => some (C99IntegerReference.Ty.uint32,some w))
    (ZintSubWord194.convert_self32 (KeygenModpR.word p))

/- Cell plumbing across one bindValue of the i cell. -/
theorem i_cell (s : State) :
    (bindValue s "i".toList .int32 (.int32 0#32)).locals "i".toList=
      some (.int32,some (.int32 0#32)) := rfl

theorem x_keep (s : State) :
    (bindValue s "i".toList .int32 (.int32 0#32)).locals "x".toList=s.locals "x".toList := by
  simp [bindValue,C99ScalarReference.set]

/- Word-operation bridges for the x decrement and the loop guard. -/
theorem minus_one32 (x : BitVec 32) :
    C99IntegerReference.ArithmeticExec .minus (.uint32 x) (.int32 1#32) (.uint32 (x-1#32)) := by
  have source := C99IntegerReference.ArithmeticExec.step .minus (.uint32 x) (.int32 1#32) .uint32 rfl
    (.uint32 x) (.uint32 1#32) (ZintSubWord194.convert_self32 x).symm rfl
    (by intro h; cases h)
  have same : C99IntegerReference.convert .uint32
      ((Value.uint32 x).integer-(Value.uint32 1#32).integer)=.uint32 (x-1#32) := by
    simp only [C99IntegerReference.convert,Value.integer,C99ArithmeticBridge.ofInt_sub,
      BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
  exact same ▸ source

theorem dec_one32 : C99IntegerReference.ArithmeticExec .minus (.uint32 1#32) (.int32 1#32)
    (.uint32 0#32) := by
  have h := minus_one32 1#32
  rw [show (1#32:BitVec 32)-1#32=0#32 by decide] at h
  exact h

theorem shift_one_zero :
    C99IntegerReference.ShiftExec .left (.uint32 1#32) (.int32 0#32) (.uint32 1#32) := by
  have h := KeygenDecodeWordOps.left32 1#32 0 (by decide)
  rw [BitVec.shiftLeft_zero] at h
  exact h

theorem le_one_zero : C99IntegerReference.CompareExec .le (.uint32 1#32) (.uint32 0#32)
    (C99ScalarReference.boolean false) := by
  have source := C99IntegerReference.CompareExec.step .le (.uint32 1#32) (.uint32 0#32) .uint32 rfl
    (.uint32 1#32) (.uint32 0#32) rfl rfl
  have same : (if C99IntegerReference.compare .le (Value.uint32 1#32).integer
      (Value.uint32 0#32).integer then 1#32 else 0#32)=0#32 := by decide
  rw [same] at source
  exact source

/- Loop-guard evaluation at the loop state (i = 0, x = 0): false. -/
def guardExpr : C99ScalarReference.Expr :=
  .compare .le (.shift .left (.literal .uint32 1) (.variable "i".toList)) (.variable "x".toList)

theorem guard_view : C99Frontend.expression rxLoopGuard=guardExpr := rfl

theorem guard_exists (s : State)
    (hi : s.locals "i".toList=some (.int32,some (.int32 0#32)))
    (hx : s.locals "x".toList=some (.uint32,some (.uint32 0#32))) :
    C99ArrayReference.scalar s rxLoopGuard (C99ScalarReference.boolean false) := by
  show C99ScalarReference.Eval FprPrefixCalls.calls s.locals guardExpr
    (C99ScalarReference.boolean false)
  refine C99ScalarReference.Eval.compare .le _ _
    (.uint32 1#32) (.uint32 0#32) (C99ScalarReference.boolean false) ?_ ?_ le_one_zero
  · refine C99ScalarReference.Eval.shift .left (.literal .uint32 1) (.variable "i".toList)
      (.uint32 1#32) (.int32 0#32) (.uint32 1#32) ?_ ?_ shift_one_zero
    · exact C99ScalarReference.Eval.literal .uint32 1
    · exact C99ScalarReference.Eval.variable "i".toList .int32 (.int32 0#32) hi
  · exact C99ScalarReference.Eval.variable "x".toList .uint32 (.uint32 0#32) hx

/- Statement runs (existence direction). -/
theorem seq_run (head tail : Stmt) (before middle : State) (result : Result)
    (first : GenExec LeafCall head before ⟨middle,.normal⟩)
    (second : GenExec LeafCall tail middle result) :
    GenExec LeafCall (.seq head tail) before result :=
  GenExec.seqNormal head tail before middle result first second

theorem declI_run (before : State) : GenExec LeafCall declI before
    ⟨C99DeclarationStatements.effect .i32 ["i".toList] before,.normal⟩ :=
  GenExec.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .i32
    ["i".toList] before)

theorem declRZ_run (before : State) : GenExec LeafCall declRZ before
    ⟨C99DeclarationStatements.effect .u32 ["r".toList,"z".toList] before,.normal⟩ :=
  GenExec.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32
    ["r".toList,"z".toList] before)

theorem xdec_run (before : State)
    (hx : before.locals "x".toList=some (.uint32,some (.uint32 1#32))) :
    GenExec LeafCall xDec before ⟨bindValue before "x".toList .uint32 (.uint32 0#32),.normal⟩ := by
  refine GenExec.base _ _ _
    (C99ArrayReference.Exec.scalar before _ (.update "x".toList .sub (.literal .i32 1)) ?_)
  refine C99ScalarReference.Exec.assign before.locals "x".toList
    (C99Frontend.binary .sub (.variable "x".toList) (C99Frontend.expression (.literal .i32 1)))
    .uint32 (some (.uint32 1#32)) (.uint32 0#32) hx ?_
  show C99ScalarReference.Eval FprPrefixCalls.calls before.locals
    (.arithmetic .minus (.variable "x".toList) (.literal .int32 1)) (.uint32 0#32)
  exact C99ScalarReference.Eval.arithmetic .minus (.variable "x".toList) (.literal .int32 1)
    (.uint32 1#32) (.int32 1#32) (.uint32 0#32)
    (C99ScalarReference.Eval.variable "x".toList .uint32 (.uint32 1#32) hx)
    (C99ScalarReference.Eval.literal .int32 1) dec_one32

theorem rset_run (before : State) (w : BitVec 32) (old : Option Value)
    (hr : before.locals "r".toList=some (.uint32,old))
    (hR2 : before.locals "R2".toList=some (.uint32,some (.uint32 w))) :
    GenExec LeafCall rSet before ⟨bindValue before "r".toList .uint32 (.uint32 w),.normal⟩ :=
  GenExec.assign "r".toList (rxCell "R2") before .uint32 old (.uint32 w) hr
    (KeygenModpR2Exec.cell_exists before "R2" w hR2)

theorem zset_run (before : State) (p : BitVec 32) (old : Option Value)
    (hz : before.locals "z".toList=some (.uint32,old))
    (hp : before.locals "p".toList=some (.uint32,some (.uint32 p))) :
    GenExec LeafCall zSet before
      ⟨bindValue before "z".toList .uint32 (.uint32 (KeygenModpR.word p)),.normal⟩ :=
  GenExec.assign "z".toList (.call1 "modp_R".toList (rxCell "p")) before .uint32 old
    (.uint32 (KeygenModpR.word p)) hz
    (GenEval.call1 "modp_R".toList (rxCell "p") (.uint32 p) (.uint32 (KeygenModpR.word p))
      (KeygenModpR2Exec.cell_exists before "p" p hp)
      (LeafCall.r [.uint32 p] (.uint32 (KeygenModpR.word p)) (KeygenModpR.source_exists p)))

theorem iinit_run (before : State) (old : Option Value)
    (hi : before.locals "i".toList=some (.int32,old)) :
    GenExec LeafCall iInit before ⟨bindValue before "i".toList .int32 (.int32 0#32),.normal⟩ :=
  GenExec.assign "i".toList (.scalar (.literal .i32 0)) before .int32 old (.int32 0#32) hi
    (GenEval.scalar _ _ (C99ScalarReference.Eval.literal .int32 0))

theorem loop_false (before : State)
    (hi : before.locals "i".toList=some (.int32,some (.int32 0#32)))
    (hx : before.locals "x".toList=some (.uint32,some (.uint32 0#32))) :
    GenExec LeafCall loopRun before ⟨before,.normal⟩ :=
  GenExec.loopFalse rxLoopGuard rxLoopBody rxLoopStep before
    (C99ScalarReference.boolean false) (guard_exists before hi hx) (by decide)

theorem rxloop_run (before : State) (old : Option Value)
    (hi : before.locals "i".toList=some (.int32,old))
    (hi2 : (bindValue before "i".toList .int32 (.int32 0#32)).locals "i".toList=
      some (.int32,some (.int32 0#32)))
    (hx2 : (bindValue before "i".toList .int32 (.int32 0#32)).locals "x".toList=
      some (.uint32,some (.uint32 0#32))) :
    GenExec LeafCall rxLoop before ⟨bindValue before "i".toList .int32 (.int32 0#32),.normal⟩ := by
  rw [loop_split]
  exact seq_run iInit loopRun before (bindValue before "i".toList .int32 (.int32 0#32)) _
    (iinit_run before old hi) (loop_false _ hi2 hx2)

theorem body_exists (base : State) (p p0i r2 : BitVec 32) :
    ∃ after, GenExec LeafCall rxCode (entry base p p0i r2)
      ⟨after,.returned (some (.uint32 (KeygenModpR.word p)))⟩ := by
  refine ⟨s6 base p p0i r2,?_⟩
  have run7 : GenExec LeafCall (chainOf [retZ]) (s6 base p p0i r2)
      ⟨s6 base p p0i r2,.returned (some (.uint32 (KeygenModpR.word p)))⟩ :=
    KeygenModpR2Exec.return_exists (s6 base p p0i r2) (KeygenModpR.word p) (s6_z base p p0i r2)
  have run6 : GenExec LeafCall (chainOf [rxLoop,retZ]) (s5 base p p0i r2)
      ⟨s6 base p p0i r2,.returned (some (.uint32 (KeygenModpR.word p)))⟩ :=
    seq_run rxLoop (chainOf [retZ]) (s5 base p p0i r2) (s6 base p p0i r2) _
      (rxloop_run (s5 base p p0i r2) none (s5_i base p p0i r2) (i_cell (s5 base p p0i r2))
        (by rw [x_keep]; exact s5_x base p p0i r2)) run7
  have run5 : GenExec LeafCall (chainOf [zSet,rxLoop,retZ]) (s4 base p p0i r2)
      ⟨s6 base p p0i r2,.returned (some (.uint32 (KeygenModpR.word p)))⟩ :=
    seq_run zSet (chainOf [rxLoop,retZ]) (s4 base p p0i r2) (s5 base p p0i r2) _
      (zset_run (s4 base p p0i r2) p none (s4_z base p p0i r2) (s4_p base p p0i r2)) run6
  have run4 : GenExec LeafCall (chainOf [rSet,zSet,rxLoop,retZ]) (s3 base p p0i r2)
      ⟨s6 base p p0i r2,.returned (some (.uint32 (KeygenModpR.word p)))⟩ :=
    seq_run rSet (chainOf [zSet,rxLoop,retZ]) (s3 base p p0i r2) (s4 base p p0i r2) _
      (rset_run (s3 base p p0i r2) r2 none (s3_r base p p0i r2) (s3_R2 base p p0i r2)) run5
  have run3 : GenExec LeafCall (chainOf [xDec,rSet,zSet,rxLoop,retZ]) (s2 base p p0i r2)
      ⟨s6 base p p0i r2,.returned (some (.uint32 (KeygenModpR.word p)))⟩ :=
    seq_run xDec (chainOf [rSet,zSet,rxLoop,retZ]) (s2 base p p0i r2) (s3 base p p0i r2) _
      (xdec_run (s2 base p p0i r2) (s2_x base p p0i r2)) run4
  have run2 : GenExec LeafCall (chainOf [declRZ,xDec,rSet,zSet,rxLoop,retZ]) (s1 base p p0i r2)
      ⟨s6 base p p0i r2,.returned (some (.uint32 (KeygenModpR.word p)))⟩ :=
    seq_run declRZ (chainOf [xDec,rSet,zSet,rxLoop,retZ]) (s1 base p p0i r2) (s2 base p p0i r2) _
      (declRZ_run (s1 base p p0i r2)) run3
  have run1 : GenExec LeafCall (chainOf [declI,declRZ,xDec,rSet,zSet,rxLoop,retZ])
      (entry base p p0i r2)
      ⟨s6 base p p0i r2,.returned (some (.uint32 (KeygenModpR.word p)))⟩ :=
    seq_run declI (chainOf [declRZ,xDec,rSet,zSet,rxLoop,retZ]) (entry base p p0i r2)
      (s1 base p p0i r2) _ (declI_run (entry base p p0i r2)) run2
  exact run1

/- Uniqueness pieces (exact direction: every derivation returns the word). -/
theorem decl_unique (ty : B20.C.Ty) (names : List C99ArrayReference.Name) (before : State)
    (out : Result) (source : GenExec LeafCall (.base (.scalar (.declare ty names))) before out) :
    out=⟨C99DeclarationStatements.effect ty names before,.normal⟩ := by
  cases source with
  | base _ _ after h => rw [C99DeclarationStatements.source_result ty names before after h]

theorem update_value_exact (env : C99ScalarReference.Env) (v : Value)
    (hx : env "x".toList=some (.uint32,some (.uint32 1#32)))
    (source : C99ScalarReference.Eval FprPrefixCalls.calls env
      (C99Frontend.binary .sub (.variable "x".toList) (C99Frontend.expression (.literal .i32 1))) v) :
    v=.uint32 0#32 := by
  change C99ScalarReference.Eval FprPrefixCalls.calls env
    (.arithmetic .minus (.variable "x".toList) (.literal .int32 1)) v at source
  cases source with
  | arithmetic _ _ _ x _ _ ha hb hop =>
      cases ha with
      | «variable» _ _ _ bound =>
          have hv : x=Value.uint32 1#32 :=
            Option.some.inj (congrArg Prod.snd (Option.some.inj (bound.symm.trans hx)))
          subst hv
          cases hb with
          | literal =>
              exact C99IntegerReference.arithmetic_deterministic .minus (.uint32 1#32)
                (C99IntegerReference.convert .int32 1) v (.uint32 0#32) hop dec_one32

theorem xdec_unique (before : State) (out : Result)
    (hx : before.locals "x".toList=some (.uint32,some (.uint32 1#32)))
    (source : GenExec LeafCall xDec before out) :
    out=⟨bindValue before "x".toList .uint32 (.uint32 0#32),.normal⟩ := by
  cases source with
  | base _ _ after h =>
      cases h with
      | scalar _ env _ body =>
          change C99ScalarReference.Exec FprPrefixCalls.calls before.locals
            (.assign "x".toList (C99Frontend.binary .sub (.variable "x".toList)
              (C99Frontend.expression (.literal .i32 1)))) (.normal env) at body
          cases body with
          | assign _ _ _ ty _ v declared evaluated =>
              have hty : .uint32=ty :=
                congrArg Prod.fst (Option.some.inj (hx.symm.trans declared))
              have hv : v=.uint32 0#32 := update_value_exact before.locals v hx evaluated
              subst hty
              subst hv
              rfl

theorem rset_unique (before : State) (w : BitVec 32) (old : Option Value) (out : Result)
    (hr : before.locals "r".toList=some (.uint32,old))
    (hR2 : before.locals "R2".toList=some (.uint32,some (.uint32 w)))
    (source : GenExec LeafCall rSet before out) :
    out=⟨bindValue before "r".toList .uint32 (.uint32 w),.normal⟩ := by
  cases source with
  | assign _ _ _ ty _ v declared evaluated =>
      have hty : .uint32=ty :=
        congrArg Prod.fst (Option.some.inj (hr.symm.trans declared))
      have hv : v=.uint32 w := KeygenModpR2Exec.cell_exact before "R2" w v hR2 evaluated
      subst hty
      subst hv
      rfl

theorem zset_unique (before : State) (p : BitVec 32) (old : Option Value) (out : Result)
    (hz : before.locals "z".toList=some (.uint32,old))
    (hp : before.locals "p".toList=some (.uint32,some (.uint32 p)))
    (source : GenExec LeafCall zSet before out) :
    out=⟨bindValue before "z".toList .uint32 (.uint32 (KeygenModpR.word p)),.normal⟩ := by
  cases source with
  | assign _ _ _ ty _ v declared evaluated =>
      have hty : .uint32=ty :=
        congrArg Prod.fst (Option.some.inj (hz.symm.trans declared))
      cases evaluated with
      | call1 _ _ x _ arg call =>
          have hx : x=.uint32 p := KeygenModpR2Exec.cell_exact before "p" p x hp arg
          subst hx
          cases call with
          | r _ _ body =>
              have hv : v=.uint32 (KeygenModpR.word p) := KeygenModpR.source_exact p v body
              subst hty
              subst hv
              rfl

theorem iinit_unique (before : State) (old : Option Value) (out : Result)
    (hi : before.locals "i".toList=some (.int32,old))
    (source : GenExec LeafCall iInit before out) :
    out=⟨bindValue before "i".toList .int32 (.int32 0#32),.normal⟩ := by
  cases source with
  | assign _ _ _ ty _ v declared evaluated =>
      have hty : .int32=ty :=
        congrArg Prod.fst (Option.some.inj (hi.symm.trans declared))
      cases evaluated with
      | scalar _ _ source =>
          cases source with
          | literal _ _ =>
              subst hty
              rfl

theorem shift_value_exact (env : C99ScalarReference.Env) (v : Value)
    (hi : env "i".toList=some (.int32,some (.int32 0#32)))
    (source : C99ScalarReference.Eval FprPrefixCalls.calls env
      (.shift .left (.literal .uint32 1) (.variable "i".toList)) v) :
    v=.uint32 1#32 := by
  cases source with
  | shift _ _ _ _ y _ ha hb hop =>
      cases ha with
      | literal =>
          cases hb with
          | «variable» _ _ _ bound =>
              have hv : y=Value.int32 0#32 :=
                Option.some.inj (congrArg Prod.snd (Option.some.inj (bound.symm.trans hi)))
              subst hv
              exact C99IntegerReference.shift_deterministic .left
                (C99IntegerReference.convert .uint32 1) (.int32 0#32) v (.uint32 1#32) hop
                shift_one_zero

theorem guard_value_exact (env : C99ScalarReference.Env) (v : Value)
    (hi : env "i".toList=some (.int32,some (.int32 0#32)))
    (hx : env "x".toList=some (.uint32,some (.uint32 0#32)))
    (source : C99ScalarReference.Eval FprPrefixCalls.calls env guardExpr v) :
    v=C99ScalarReference.boolean false := by
  cases source with
  | compare _ _ _ x y _ ha hb hop =>
      cases hb with
      | «variable» _ _ _ bound =>
          have hv : y=Value.uint32 0#32 :=
            Option.some.inj (congrArg Prod.snd (Option.some.inj (bound.symm.trans hx)))
          subst hv
          have hz : x=Value.uint32 1#32 := shift_value_exact env x hi ha
          subst hz
          cases hop with
          | step ct cht ca cb cha chb =>
              subst cht
              have same : (if C99IntegerReference.compare .le ca.integer cb.integer
                  then 1#32 else 0#32)=0#32 := by rw [cha,chb]; decide
              rw [same]
              rfl

theorem loop_unique (before : State) (out : Result)
    (hi : before.locals "i".toList=some (.int32,some (.int32 0#32)))
    (hx : before.locals "x".toList=some (.uint32,some (.uint32 0#32)))
    (source : GenExec LeafCall loopRun before out) : out=⟨before,.normal⟩ := by
  cases source with
  | loopFalse _ _ _ _ _ _ _ => rfl
  | loopNormal _ _ _ _ _ _ _ v g nz _ _ _ =>
      rw [guard_value_exact _ v hi hx g] at nz
      exact (nz (by decide)).elim
  | loopReturn _ _ _ _ _ v _ g nz _ =>
      rw [guard_value_exact _ v hi hx g] at nz
      exact (nz (by decide)).elim

theorem rxloop_unique (before : State) (old : Option Value) (out : Result)
    (hi : before.locals "i".toList=some (.int32,old))
    (hx : before.locals "x".toList=some (.uint32,some (.uint32 0#32)))
    (source : GenExec LeafCall rxLoop before out) :
    out=⟨bindValue before "i".toList .int32 (.int32 0#32),.normal⟩ := by
  rw [loop_split] at source
  have mid := KeygenModpR2Exec.continuation iInit loopRun before
    (bindValue before "i".toList .int32 (.int32 0#32)) out
    (fun r h => iinit_unique before old r hi h) source
  have hx' : (bindValue before "i".toList .int32 (.int32 0#32)).locals "x".toList=
      some (.uint32,some (.uint32 0#32)) := by rw [x_keep]; exact hx
  exact loop_unique (bindValue before "i".toList .int32 (.int32 0#32)) out
    (i_cell before) hx' mid

/- Exact-direction chain: one complete lemma per statement step, then
   the returned-word export. Split for kernel locality (księga: a single
   multi-step `have` chain hit the kernel memory limit at this arity). -/
theorem exact_t2 (base : State) (p p0i r2 : BitVec 32) (out : Result)
    (source : GenExec LeafCall (chainOf [declI,declRZ,xDec,rSet,zSet,rxLoop,retZ])
      (entry base p p0i r2) out) :
    GenExec LeafCall (chainOf [declRZ,xDec,rSet,zSet,rxLoop,retZ]) (s1 base p p0i r2) out :=
  KeygenModpR2Exec.continuation declI (chainOf [declRZ,xDec,rSet,zSet,rxLoop,retZ])
    (entry base p p0i r2) (s1 base p p0i r2) out
    (decl_unique .i32 ["i".toList] (entry base p p0i r2)) source

theorem exact_t3 (base : State) (p p0i r2 : BitVec 32) (out : Result)
    (prev : GenExec LeafCall (chainOf [declRZ,xDec,rSet,zSet,rxLoop,retZ]) (s1 base p p0i r2) out) :
    GenExec LeafCall (chainOf [xDec,rSet,zSet,rxLoop,retZ]) (s2 base p p0i r2) out :=
  KeygenModpR2Exec.continuation declRZ (chainOf [xDec,rSet,zSet,rxLoop,retZ])
    (s1 base p p0i r2) (s2 base p p0i r2) out
    (decl_unique .u32 ["r".toList,"z".toList] (s1 base p p0i r2)) prev

theorem exact_t4 (base : State) (p p0i r2 : BitVec 32) (out : Result)
    (prev : GenExec LeafCall (chainOf [xDec,rSet,zSet,rxLoop,retZ]) (s2 base p p0i r2) out) :
    GenExec LeafCall (chainOf [rSet,zSet,rxLoop,retZ]) (s3 base p p0i r2) out :=
  KeygenModpR2Exec.continuation xDec (chainOf [rSet,zSet,rxLoop,retZ])
    (s2 base p p0i r2) (s3 base p p0i r2) out
    (fun r h => xdec_unique (s2 base p p0i r2) r (s2_x base p p0i r2) h) prev

theorem exact_t5 (base : State) (p p0i r2 : BitVec 32) (out : Result)
    (prev : GenExec LeafCall (chainOf [rSet,zSet,rxLoop,retZ]) (s3 base p p0i r2) out) :
    GenExec LeafCall (chainOf [zSet,rxLoop,retZ]) (s4 base p p0i r2) out :=
  KeygenModpR2Exec.continuation rSet (chainOf [zSet,rxLoop,retZ])
    (s3 base p p0i r2) (s4 base p p0i r2) out
    (fun r h => rset_unique (s3 base p p0i r2) r2 none r (s3_r base p p0i r2) (s3_R2 base p p0i r2) h) prev

theorem exact_t6 (base : State) (p p0i r2 : BitVec 32) (out : Result)
    (prev : GenExec LeafCall (chainOf [zSet,rxLoop,retZ]) (s4 base p p0i r2) out) :
    GenExec LeafCall (chainOf [rxLoop,retZ]) (s5 base p p0i r2) out :=
  KeygenModpR2Exec.continuation zSet (chainOf [rxLoop,retZ])
    (s4 base p p0i r2) (s5 base p p0i r2) out
    (fun r h => zset_unique (s4 base p p0i r2) p none r (s4_z base p p0i r2) (s4_p base p p0i r2) h) prev

theorem exact_t7 (base : State) (p p0i r2 : BitVec 32) (out : Result)
    (prev : GenExec LeafCall (chainOf [rxLoop,retZ]) (s5 base p p0i r2) out) :
    GenExec LeafCall (chainOf [retZ]) (s6 base p p0i r2) out :=
  KeygenModpR2Exec.continuation rxLoop (chainOf [retZ])
    (s5 base p p0i r2) (s6 base p p0i r2) out
    (fun r h => rxloop_unique (s5 base p p0i r2) none r (s5_i base p p0i r2) (s5_x base p p0i r2) h) prev

theorem body_exact (base : State) (p p0i r2 : BitVec 32) (out : Result)
    (source : GenExec LeafCall rxCode (entry base p p0i r2) out) :
    out.flow=.returned (some (.uint32 (KeygenModpR.word p))) :=
  congrArg Result.flow
    (KeygenModpR2Exec.return_exact (s6 base p p0i r2) (KeygenModpR.word p) out
      (s6_z base p p0i r2) (exact_t7 base p p0i r2 out (exact_t6 base p p0i r2 out
        (exact_t5 base p p0i r2 out (exact_t4 base p p0i r2 out
          (exact_t3 base p p0i r2 out (exact_t2 base p p0i r2 out source)))))))

/- Call-level exports at the pinned call shape of the rxSet statement. -/
def SourceExec (p p0i r2 : BitVec 32) (v : Value) : Prop :=
  rxBody [.uint32 1#32,.uint32 p,.uint32 p0i,.uint32 r2] v

theorem source_exact (p p0i r2 : BitVec 32) (v : Value) (source : SourceExec p p0i r2 v) :
    v=.uint32 (KeygenModpR.word p) := by
  obtain ⟨base,after,body⟩ := source
  exact Option.some.inj (C99ProcedureReference.Flow.returned.inj
    (body_exact base p p0i r2 _ body))

theorem source_exists (base : State) (p p0i r2 : BitVec 32) :
    SourceExec p p0i r2 (.uint32 (KeygenModpR.word p)) := by
  obtain ⟨after,body⟩ := body_exists base p p0i r2
  exact ⟨base,after,body⟩

/- The same export at the u64 first argument of the parsed call4
   `modp_Rx(slen, p, p0i, R2)` (the slen = 1 u64 cell): the bound
   parameter cell is the same executed word. -/
def SourceExec64 (p p0i r2 : BitVec 32) (v : Value) : Prop :=
  rxBody [.uint64 1#64,.uint32 p,.uint32 p0i,.uint32 r2] v

theorem entry64 (base : State) (p p0i r2 : BitVec 32) :
    bindParams base rxParams [.uint64 1#64,.uint32 p,.uint32 p0i,.uint32 r2]=entry base p p0i r2 := by
  simp [entry,bindParams,rxParams,bindValue,C99IntegerReference.convert,Value.integer]

theorem source64_exact (p p0i r2 : BitVec 32) (v : Value) (source : SourceExec64 p p0i r2 v) :
    v=.uint32 (KeygenModpR.word p) :=
  source_exact p p0i r2 v source

theorem source64_exists (base : State) (p p0i r2 : BitVec 32) :
    SourceExec64 p p0i r2 (.uint32 (KeygenModpR.word p)) :=
  source_exists base p p0i r2

end FT1536.Source3.KeygenModpRxExec
