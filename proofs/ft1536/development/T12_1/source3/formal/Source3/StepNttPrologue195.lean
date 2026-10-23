import Source3.StepNttFirst195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The forward-NTT prologue run at the selected call words logn = 9 /
   full = 0 (n = 512, hn = 256), the w = gm[1] assign and the first-pass
   walk initialiser (firstInit). The prologue derivations of
   KeygenNttForwardExec transfer to the new words: the logn0 guard is
   kernel-checked false at logn = 9, the MKN macro evaluates to n = 512
   and the halving to hn = 256 (both extracted FROM the Exec derivations,
   no oracle). The w assign executes one load32 of the gm word at index 1;
   firstInit sets u = 0, r1 = a + 0 and r2 = a + hn * stride (the pinned
   stride = 1 gives the elem a hn pointer). Statements are the pinned
   KeygenNttForwardPrograms projections; the parse map, the per-cell
   keeps and the step layer of the previous window are consumed, not
   re-derived. Values stay executed words: no transform property, table
   law, root law or positivity claim is made here. -/
namespace FT1536.Source3.StepNttPrologue195
open C99ModularReference (Stmt Exec Eval)
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer PointerAdd Load32)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (elem)

/-! ## The selected words and the MKN path values -/

def lognAt (s : State) : Prop := s.locals "logn".toList=some (.uint32,some (.uint32 9))
def fullAt (s : State) : Prop := s.locals "full".toList=some (.uint32,some (.uint32 0))
def nCell : Ty×Option Value := (.uint64,some (C99IntegerReference.convert .uint64 512))
def hnCell : Ty×Option Value := (.uint64,some (C99IntegerReference.convert .uint64 256))

theorem convert_512 : C99IntegerReference.convert .uint64 512=Value.uint64 (C99NatWord141.word 512) :=
  by decide
theorem convert_256 : C99IntegerReference.convert .uint64 256=Value.uint64 (C99NatWord141.word 256) :=
  by decide

/- The logn0 guard reads false at the selected words. -/
theorem guard_value (s : State) (v : Value) (logn : lognAt s)
    (source : C99ArrayReference.scalar s KeygenNttForwardPrograms.lognZero v) :
    v=C99ScalarReference.boolean false := by
  change C99ScalarReference.Eval _ _
    (.compare .eq (.variable "logn".toList) (.literal .int32 0)) v at source
  obtain ⟨x,y,hx,hy,operation⟩ := KeygenNttForwardExec.eval_compare s.locals .eq _ _ v source
  have hx1 := C99CountedWords.variable_exact s "logn".toList .uint32 (.uint32 9) x logn hx
  subst x
  have hy1 := KeygenNttForwardExec.literal_value s B20.C.Ty.i32 0 y hy
  subst y
  rw [C99CountedWords.comparison_result .eq (Value.uint32 9)
    (C99IntegerReference.convert (C99ValueBridge.type .i32) 0) v operation]
  decide

/- MKN at full = 0: (1 + (0 << 1)) << (logn - 0). -/
theorem shl_zero_value (s : State) (v : Value) (full : fullAt s)
    (source : C99ArrayReference.scalar s (.bin .shl (KeygenNttForwardPrograms.var "full")
      (KeygenNttForwardPrograms.num 1)) v) : v=C99IntegerReference.convert .uint32 0 := by
  change C99ScalarReference.Eval _ _
    (.shift .left (.variable "full".toList) (.literal .int32 1)) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_shift s.locals .left _ _ v source
  have hx1 := C99CountedWords.variable_exact s "full".toList .uint32 (.uint32 0) x full hx
  subst x
  have hy1 := KeygenNttForwardExec.literal_value s B20.C.Ty.i32 1 y hy
  subst y
  obtain ⟨n,hn,hb,he⟩ := KeygenNttForwardExec.shift_left_value _ _ v hop
  have hnn : n=1 := by
    have h1 : (C99IntegerReference.convert (C99ValueBridge.type B20.C.Ty.i32) ((1:Nat):Int)).integer=(1:Int) :=
      by decide
    rw [h1] at hn
    omega
  subst n
  rw [he]
  decide

theorem plus_one_value (s : State) (v : Value) (full : fullAt s)
    (source : C99ArrayReference.scalar s (.bin .add (KeygenNttForwardPrograms.num 1)
      (.bin .shl (KeygenNttForwardPrograms.var "full") (KeygenNttForwardPrograms.num 1))) v) :
    v=C99IntegerReference.convert .uint32 1 := by
  change C99ScalarReference.Eval _ _
    (.arithmetic .plus (.literal .int32 1)
      (.shift .left (.variable "full".toList) (.literal .int32 1))) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .plus _ _ v source
  have hx1 := KeygenNttForwardExec.literal_value s B20.C.Ty.i32 1 x hx
  have hy1 := shl_zero_value s y full hy
  subst x
  subst y
  have he := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp hop).2
  rw [he]
  decide

theorem minus_nine_value (s : State) (v : Value) (logn : lognAt s) (full : fullAt s)
    (source : C99ArrayReference.scalar s (.bin .sub (KeygenNttForwardPrograms.var "logn")
      (KeygenNttForwardPrograms.var "full")) v) : v=C99IntegerReference.convert .uint32 9 := by
  change C99ScalarReference.Eval _ _
    (.arithmetic .minus (.variable "logn".toList) (.variable "full".toList)) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .minus _ _ v source
  have hx1 := C99CountedWords.variable_exact s "logn".toList .uint32 (.uint32 9) x logn hx
  have hy1 := C99CountedWords.variable_exact s "full".toList .uint32 (.uint32 0) y full hy
  subst x
  subst y
  have he := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp hop).2
  rw [he]
  decide

/- The MKN macro word at the selected call: 512. -/
theorem mkn_value (s : State) (v : Value) (logn : lognAt s) (full : fullAt s)
    (source : C99ArrayReference.scalar s (C99ArrayParser.mkn (KeygenNttForwardPrograms.var "logn")
      (KeygenNttForwardPrograms.var "full")) v) : v.integer=512 := by
  change C99ScalarReference.Eval _ _
    (.shift .left (.cast .uint64 (.arithmetic .plus (.literal .int32 1)
        (.shift .left (.variable "full".toList) (.literal .int32 1))))
      (.arithmetic .minus (.variable "logn".toList) (.variable "full".toList))) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_shift s.locals .left _ _ v source
  have hy1 := minus_nine_value s y logn full hy
  subst y
  obtain ⟨u,hsum,hcast⟩ := KeygenNttForwardExec.eval_cast s.locals .uint64 _ x hx
  have hu := plus_one_value s u full hsum
  subst u
  have hxeq : x=C99IntegerReference.convert .uint64 1 := by
    rw [hcast]
    decide
  subst x
  obtain ⟨n,hn,hb,he⟩ := KeygenNttForwardExec.shift_left_value _ _ v hop
  have hnn : n=9 := by
    have h9 : (C99IntegerReference.convert .uint32 9).integer=9 := by decide
    rw [h9] at hn
    omega
  subst n
  rw [he]
  decide

/- The halving word: 256. -/
theorem half_value (s : State) (v : Value) (slot : s.locals "n".toList=some nCell)
    (source : C99ArrayReference.scalar s (.bin .shr (KeygenNttForwardPrograms.var "n")
      (KeygenNttForwardPrograms.num 1)) v) : v.integer=256 := by
  change C99ScalarReference.Eval _ _
    (.shift .right (.variable "n".toList) (.literal .int32 1)) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_shift s.locals .right _ _ v source
  have hx1 : x=C99IntegerReference.convert .uint64 512 :=
    C99CountedWords.variable_exact s "n".toList .uint64 (C99IntegerReference.convert .uint64 512) x
      (by simpa [nCell] using slot) hx
  subst x
  have hy1 := KeygenNttForwardExec.literal_value s B20.C.Ty.i32 1 y hy
  subst y
  obtain ⟨n,hn,hb,he⟩ := (C99IntegerReference.shift_right_iff _ _ _).mp hop
  have hnn : n=1 := by
    have h1 : (C99IntegerReference.convert (C99ValueBridge.type B20.C.Ty.i32) ((1:Nat):Int)).integer=(1:Int) :=
      by decide
    rw [h1] at hn
    omega
  subst n
  rw [he]
  decide

/-! ## Statement-level prologue results at the selected words -/

theorem early_u (s : State) (logn : lognAt s) :
    ∀ out, Exec KeygenNttForwardPrograms.earlyExit s out → out=⟨s,.normal⟩ := by
  intro out source
  obtain h := KeygenNttForwardExec.branch_inv _ _ _ s out source
  cases h with
  | inl h =>
      obtain ⟨v,guard,nonzero,body⟩ := h
      rw [guard_value s v logn guard] at nonzero
      simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero
  | inr h =>
      obtain ⟨v,guard,zero,body⟩ := h
      exact C99ModularReference.skip_result s out body

def afterN (before : State) : State :=
  {before with locals := C99ScalarReference.set before.locals "n".toList nCell}
def afterCompute (before : State) : State :=
  {before with locals := C99ScalarReference.set before.locals "hn".toList hnCell}
def ready (before : State) : State :=
  afterCompute (afterN (KeygenNttForwardExec.afterPointers
    (KeygenNttForwardExec.afterWord (KeygenNttForwardExec.afterLocals before))))

theorem n_u (s : State) (logn : lognAt s) (full : fullAt s)
    (slot : s.locals "n".toList=some (.uint64,none)) :
    ∀ out, Exec KeygenNttForwardPrograms.nAssign s out → out=⟨afterN s,.normal⟩ := by
  intro out source
  obtain ⟨ty,old,v,declared,value,he⟩ := KeygenNttForwardExec.assign_inv s "n".toList _ out source
  have ht : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
  subst ty
  have hv : v.integer=512 := mkn_value s v logn full (KeygenNttForwardExec.eval_scalar s _ v value)
  have heq : C99ArrayReference.bindValue s "n".toList .uint64 v=afterN s := by
    simp [C99ArrayReference.bindValue,afterN,nCell,hv]
  rw [he,heq]

theorem hn_u (s : State) (slot : s.locals "n".toList=some nCell)
    (free : s.locals "hn".toList=some (.uint64,none)) :
    ∀ out, Exec KeygenNttForwardPrograms.hnAssign s out → out=⟨afterCompute s,.normal⟩ := by
  intro out source
  obtain ⟨ty,old,v,declared,value,he⟩ := KeygenNttForwardExec.assign_inv s "hn".toList _ out source
  have ht : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans free))
  subst ty
  have hv : v.integer=256 := half_value s v slot (KeygenNttForwardExec.eval_scalar s _ v value)
  have heq : C99ArrayReference.bindValue s "hn".toList .uint64 v=afterCompute s := by
    simp [C99ArrayReference.bindValue,afterCompute,hnCell,hv]
  rw [he,heq]

/- Slot transports along the prologue states. -/
theorem logn_keep (s : State) (h : lognAt s) :
    lognAt (KeygenNttForwardExec.afterPointers
      (KeygenNttForwardExec.afterWord (KeygenNttForwardExec.afterLocals s))) := by
  simpa [lognAt,KeygenNttForwardExec.afterPointers,KeygenNttForwardExec.afterWord,
    KeygenNttForwardExec.afterLocals,KeygenNttForwardExec.env6,KeygenNttForwardExec.declareCell,
    C99ScalarReference.set] using h
theorem full_keep (s : State) (h : fullAt s) :
    fullAt (KeygenNttForwardExec.afterPointers
      (KeygenNttForwardExec.afterWord (KeygenNttForwardExec.afterLocals s))) := by
  simpa [fullAt,KeygenNttForwardExec.afterPointers,KeygenNttForwardExec.afterWord,
    KeygenNttForwardExec.afterLocals,KeygenNttForwardExec.env6,KeygenNttForwardExec.declareCell,
    C99ScalarReference.set] using h
theorem n_free (s : State) :
    (KeygenNttForwardExec.afterPointers
      (KeygenNttForwardExec.afterWord (KeygenNttForwardExec.afterLocals s))).locals "n".toList=
      some (.uint64,none) := by
  simp [KeygenNttForwardExec.afterPointers,KeygenNttForwardExec.afterWord,
    KeygenNttForwardExec.afterLocals,KeygenNttForwardExec.env6,KeygenNttForwardExec.declareCell,
    C99ScalarReference.set]
theorem n_bound (s : State) : (afterN s).locals "n".toList=some nCell := by
  simp [afterN,C99ScalarReference.set]
theorem hn_free (s : State) :
    (afterN (KeygenNttForwardExec.afterPointers
      (KeygenNttForwardExec.afterWord (KeygenNttForwardExec.afterLocals s)))).locals "hn".toList=
      some (.uint64,none) := by
  simp [afterN,KeygenNttForwardExec.afterPointers,KeygenNttForwardExec.afterWord,
    KeygenNttForwardExec.afterLocals,KeygenNttForwardExec.env6,KeygenNttForwardExec.declareCell,
    C99ScalarReference.set,nCell]

/- The complete prologue run at the selected words. -/
theorem prologue_result (before : State) (result : Result)
    (logn : lognAt before) (full : fullAt before)
    (source : Exec KeygenNttForwardPrograms.prologue before result) : result=⟨ready before,.normal⟩ := by
  rw [KeygenNttForwardExec.prologue_shape] at source
  have e1 := C99ModularReference.continuation KeygenNttForwardPrograms.locals
    KeygenNttForwardExec.rest1 before (KeygenNttForwardExec.afterLocals before) result
    (KeygenNttForwardExec.locals_u before) source
  rw [KeygenNttForwardExec.rest1_shape] at e1
  have e2 := C99ModularReference.continuation KeygenNttForwardPrograms.word
    KeygenNttForwardExec.rest2 (KeygenNttForwardExec.afterLocals before)
    (KeygenNttForwardExec.afterWord (KeygenNttForwardExec.afterLocals before)) result
    (KeygenNttForwardExec.word_u (KeygenNttForwardExec.afterLocals before)) e1
  rw [KeygenNttForwardExec.rest2_shape] at e2
  have e3 := C99ModularReference.continuation KeygenNttForwardPrograms.pointers
    KeygenNttForwardExec.rest3 (KeygenNttForwardExec.afterWord (KeygenNttForwardExec.afterLocals before))
    (KeygenNttForwardExec.afterPointers (KeygenNttForwardExec.afterWord
      (KeygenNttForwardExec.afterLocals before)))
    result
    (KeygenNttForwardExec.pointers_u (KeygenNttForwardExec.afterWord
      (KeygenNttForwardExec.afterLocals before))) e2
  rw [KeygenNttForwardExec.rest3_shape] at e3
  have e4 := C99ModularReference.continuation KeygenNttForwardPrograms.earlyExit
    KeygenNttForwardExec.rest4
    (KeygenNttForwardExec.afterPointers (KeygenNttForwardExec.afterWord
      (KeygenNttForwardExec.afterLocals before)))
    (KeygenNttForwardExec.afterPointers (KeygenNttForwardExec.afterWord
      (KeygenNttForwardExec.afterLocals before))) result
    (early_u _ (logn_keep before logn)) e3
  rw [KeygenNttForwardExec.rest4_shape] at e4
  have e5 := C99ModularReference.continuation KeygenNttForwardPrograms.nAssign
    KeygenNttForwardExec.rest5
    (KeygenNttForwardExec.afterPointers (KeygenNttForwardExec.afterWord
      (KeygenNttForwardExec.afterLocals before)))
    (afterN (KeygenNttForwardExec.afterPointers (KeygenNttForwardExec.afterWord
      (KeygenNttForwardExec.afterLocals before))))
    result (n_u _ (logn_keep before logn) (full_keep before full)
      (KeygenNttForwardExec.n_free before)) e4
  rw [KeygenNttForwardExec.rest5_shape] at e5
  have e6 := C99ModularReference.continuation KeygenNttForwardPrograms.hnAssign (.base .skip)
    (afterN (KeygenNttForwardExec.afterPointers (KeygenNttForwardExec.afterWord
      (KeygenNttForwardExec.afterLocals before))))
    (afterCompute (afterN (KeygenNttForwardExec.afterPointers (KeygenNttForwardExec.afterWord
      (KeygenNttForwardExec.afterLocals before)))))
    result (hn_u _ (n_bound _) (hn_free _)) e5
  rw [C99ModularReference.skip_result _ result e6]
  rfl

/-! ## Cell exports of the ready state -/

theorem ready_n (before : State) :
    (ready before).locals "n".toList=some (.uint64,some (.uint64 (C99NatWord141.word 512))) := by
  have h : (ready before).locals "n".toList=some nCell := by
    simp [ready,afterCompute,afterN,C99ScalarReference.set]
  simpa [nCell,convert_512] using h

theorem ready_hn (before : State) :
    (ready before).locals "hn".toList=some (.uint64,some (.uint64 (C99NatWord141.word 256))) := by
  have h : (ready before).locals "hn".toList=some hnCell := by
    simp [ready,afterCompute,afterN,C99ScalarReference.set,nCell]
  simpa [hnCell,convert_256] using h

theorem ready_hn_cell (before : State) : Cell (ready before) "hn".toList 256 := ready_hn before

theorem ready_logn (before : State) :
    (ready before).locals "logn".toList=before.locals "logn".toList := by
  simp [ready,afterCompute,afterN,KeygenNttForwardExec.afterPointers,
    KeygenNttForwardExec.afterWord,KeygenNttForwardExec.afterLocals,
    KeygenNttForwardExec.env6,KeygenNttForwardExec.declareCell,C99ScalarReference.set]
theorem ready_full (before : State) :
    (ready before).locals "full".toList=before.locals "full".toList := by
  simp [ready,afterCompute,afterN,KeygenNttForwardExec.afterPointers,
    KeygenNttForwardExec.afterWord,KeygenNttForwardExec.afterLocals,
    KeygenNttForwardExec.env6,KeygenNttForwardExec.declareCell,C99ScalarReference.set]
theorem ready_p (before : State) :
    (ready before).locals "p".toList=before.locals "p".toList := by
  simp [ready,afterCompute,afterN,KeygenNttForwardExec.afterPointers,
    KeygenNttForwardExec.afterWord,KeygenNttForwardExec.afterLocals,
    KeygenNttForwardExec.env6,KeygenNttForwardExec.declareCell,C99ScalarReference.set]
theorem ready_p0i (before : State) :
    (ready before).locals "p0i".toList=before.locals "p0i".toList := by
  simp [ready,afterCompute,afterN,KeygenNttForwardExec.afterPointers,
    KeygenNttForwardExec.afterWord,KeygenNttForwardExec.afterLocals,
    KeygenNttForwardExec.env6,KeygenNttForwardExec.declareCell,C99ScalarReference.set]
theorem ready_stride (before : State) :
    (ready before).locals "stride".toList=before.locals "stride".toList := by
  simp [ready,afterCompute,afterN,KeygenNttForwardExec.afterPointers,
    KeygenNttForwardExec.afterWord,KeygenNttForwardExec.afterLocals,
    KeygenNttForwardExec.env6,KeygenNttForwardExec.declareCell,C99ScalarReference.set]
theorem ready_a (before : State) :
    (ready before).arrays "a".toList=before.arrays "a".toList := by
  simp [ready,afterCompute,afterN,KeygenNttForwardExec.afterPointers,
    KeygenNttForwardExec.afterWord,KeygenNttForwardExec.afterLocals]
theorem ready_gm (before : State) :
    (ready before).arrays "gm".toList=before.arrays "gm".toList := by
  simp [ready,afterCompute,afterN,KeygenNttForwardExec.afterPointers,
    KeygenNttForwardExec.afterWord,KeygenNttForwardExec.afterLocals]

/-! ## Constructive runs of the prologue statements (existence direction)

The MKN path values are constructed as concrete evaluations; the
inversion lemmas above extract the same words from arbitrary
derivations. -/

theorem locals_run (s : State) :
    Exec KeygenNttForwardPrograms.locals s ⟨KeygenNttForwardExec.afterLocals s,.normal⟩ :=
  .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64
    KeygenNttForwardExec.names6 s)

theorem word_run (s : State) :
    Exec KeygenNttForwardPrograms.word s ⟨KeygenNttForwardExec.afterWord s,.normal⟩ :=
  .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32
    ["w".toList] s)

theorem pointers_run (s : State) :
    Exec KeygenNttForwardPrograms.pointers s ⟨KeygenNttForwardExec.afterPointers s,.normal⟩ := by
  refine .seqNormal _ _ _ _ _ (.base _ _ _ (.declarePtr _ "r1".toList))
    (.seqNormal _ _ _ _ _ (.base _ _ _ (.declarePtr _ "r2".toList)) (.base _ _ _ (.skip _)))

theorem shl_full_eval (s : State) (full : fullAt s) :
    C99ArrayReference.scalar s (.bin .shl (KeygenNttForwardPrograms.var "full")
      (KeygenNttForwardPrograms.num 1)) (C99IntegerReference.convert .uint32 0) := by
  change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
    (.shift .left (.variable "full".toList) (.literal .int32 1))
    (C99IntegerReference.convert .uint32 0)
  refine C99ScalarReference.Eval.shift .left (.variable "full".toList) (.literal .int32 1)
    (C99IntegerReference.Value.uint32 0) (C99IntegerReference.convert .int32 1)
    (C99IntegerReference.convert .uint32 0) ?_ ?_ ?_
  · exact .variable "full".toList .uint32 (C99IntegerReference.Value.uint32 0) full
  · exact .literal .int32 1
  · refine C99IntegerReference.ShiftExec.unsignedLeft (C99IntegerReference.Value.uint32 0)
      (C99IntegerReference.convert .int32 1) 1 ?_ ?_ ?_
    · decide
    · decide
    · decide

theorem plus_one_eval (s : State) (full : fullAt s) :
    C99ArrayReference.scalar s (.bin .add (KeygenNttForwardPrograms.num 1)
      (.bin .shl (KeygenNttForwardPrograms.var "full") (KeygenNttForwardPrograms.num 1)))
      (C99IntegerReference.convert .uint32 1) := by
  change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
    (.arithmetic .plus (.literal .int32 1)
      (.shift .left (.variable "full".toList) (.literal .int32 1)))
    (C99IntegerReference.convert .uint32 1)
  have shl : C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (C99ScalarReference.Expr.shift .left (.variable "full".toList) (.literal .int32 1))
      (C99IntegerReference.convert .uint32 0) := shl_full_eval s full
  refine C99ScalarReference.Eval.arithmetic .plus (.literal .int32 1)
    (C99ScalarReference.Expr.shift .left (.variable "full".toList) (.literal .int32 1))
    (C99IntegerReference.convert .int32 1) (C99IntegerReference.convert .uint32 0)
    (C99IntegerReference.convert .uint32 1) (.literal .int32 1) shl ?_
  refine C99IntegerReference.ArithmeticExec.step .plus (C99IntegerReference.convert .int32 1)
    (C99IntegerReference.convert .uint32 0) .uint32 rfl
    (C99IntegerReference.convert .uint32 ((C99IntegerReference.convert .int32 1).integer))
    (C99IntegerReference.convert .uint32 ((C99IntegerReference.convert .uint32 0).integer))
    rfl rfl ?_
  intro h
  exact absurd h (by decide)

theorem minus_eval (s : State) (logn : lognAt s) (full : fullAt s) :
    C99ArrayReference.scalar s (.bin .sub (KeygenNttForwardPrograms.var "logn")
      (KeygenNttForwardPrograms.var "full")) (C99IntegerReference.convert .uint32 9) := by
  change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
    (.arithmetic .minus (.variable "logn".toList) (.variable "full".toList))
    (C99IntegerReference.convert .uint32 9)
  refine C99ScalarReference.Eval.arithmetic .minus (.variable "logn".toList)
    (.variable "full".toList) (C99IntegerReference.Value.uint32 9)
    (C99IntegerReference.Value.uint32 0) (C99IntegerReference.convert .uint32 9)
    (.variable "logn".toList .uint32 (C99IntegerReference.Value.uint32 9) logn)
    (.variable "full".toList .uint32 (C99IntegerReference.Value.uint32 0) full) ?_
  refine C99IntegerReference.ArithmeticExec.step .minus (C99IntegerReference.Value.uint32 9)
    (C99IntegerReference.Value.uint32 0) .uint32 rfl
    (C99IntegerReference.convert .uint32 9) (C99IntegerReference.convert .uint32 0)
    rfl rfl ?_
  intro h
  exact absurd h (by decide)

/- The MKN macro word at the selected call: 512, constructed. -/
theorem mkn_eval (s : State) (logn : lognAt s) (full : fullAt s) :
    C99ArrayReference.scalar s (C99ArrayParser.mkn (KeygenNttForwardPrograms.var "logn")
      (KeygenNttForwardPrograms.var "full")) (C99IntegerReference.convert .uint64 512) := by
  change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
    (.shift .left (.cast .uint64 (.arithmetic .plus (.literal .int32 1)
        (.shift .left (.variable "full".toList) (.literal .int32 1))))
      (.arithmetic .minus (.variable "logn".toList) (.variable "full".toList)))
    (C99IntegerReference.convert .uint64 512)
  have plus : C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (C99ScalarReference.Expr.arithmetic .plus (.literal .int32 1)
        (C99ScalarReference.Expr.shift .left (.variable "full".toList) (.literal .int32 1)))
      (C99IntegerReference.convert .uint32 1) := plus_one_eval s full
  refine C99ScalarReference.Eval.shift .left
    (C99ScalarReference.Expr.cast .uint64 (C99ScalarReference.Expr.arithmetic .plus
      (.literal .int32 1) (C99ScalarReference.Expr.shift .left (.variable "full".toList)
      (.literal .int32 1))))
    (C99ScalarReference.Expr.arithmetic .minus (.variable "logn".toList)
      (.variable "full".toList))
    (C99IntegerReference.convert .uint64 ((C99IntegerReference.convert .uint32 1).integer))
    (C99IntegerReference.convert .uint32 9) (C99IntegerReference.convert .uint64 512) ?_ ?_ ?_
  · exact .cast .uint64 _ _ plus
  · exact minus_eval s logn full
  · refine C99IntegerReference.ShiftExec.unsignedLeft
      (C99IntegerReference.convert .uint64 ((C99IntegerReference.convert .uint32 1).integer))
      (C99IntegerReference.convert .uint32 9) 9 ?_ ?_ ?_
    · decide
    · decide
    · decide

theorem half_eval (s : State) (slot : s.locals "n".toList=some nCell) :
    C99ArrayReference.scalar s (.bin .shr (KeygenNttForwardPrograms.var "n")
      (KeygenNttForwardPrograms.num 1)) (C99IntegerReference.convert .uint64 256) := by
  change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
    (.shift .right (.variable "n".toList) (.literal .int32 1))
    (C99IntegerReference.convert .uint64 256)
  have nEval : C99ScalarReference.Eval FprPrefixCalls.calls s.locals (.variable "n".toList)
      (C99IntegerReference.convert .uint64 512) :=
    .variable "n".toList .uint64 (C99IntegerReference.convert .uint64 512) (by
      simpa [nCell] using slot)
  refine C99ScalarReference.Eval.shift .right (.variable "n".toList) (.literal .int32 1)
    (C99IntegerReference.convert .uint64 512) (C99IntegerReference.convert .int32 1)
    (C99IntegerReference.convert .uint64 256) nEval (.literal .int32 1) ?_
  refine C99IntegerReference.ShiftExec.right (C99IntegerReference.convert .uint64 512)
    (C99IntegerReference.convert .int32 1) 1 ?_ ?_
  · decide
  · decide

theorem early_run (s : State) (logn : lognAt s) :
    Exec KeygenNttForwardPrograms.earlyExit s ⟨s,.normal⟩ := by
  have guard : C99ArrayReference.scalar s KeygenNttForwardPrograms.lognZero
      (C99ScalarReference.boolean false) := by
    change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (.compare .eq (.variable "logn".toList) (.literal .int32 0))
      (C99ScalarReference.boolean false)
    refine C99ScalarReference.Eval.compare .eq (.variable "logn".toList) (.literal .int32 0)
      (C99IntegerReference.Value.uint32 9) (C99IntegerReference.convert .int32 0)
      (C99ScalarReference.boolean false) ?_ ?_ ?_
    · exact .variable "logn".toList .uint32 (C99IntegerReference.Value.uint32 9) logn
    · exact .literal .int32 0
    · refine C99IntegerReference.CompareExec.step .eq (C99IntegerReference.Value.uint32 9)
        (C99IntegerReference.convert .int32 0) .uint32 rfl
        (C99IntegerReference.convert .uint32 9) (C99IntegerReference.convert .uint32 0) ?_ ?_
      · rfl
      · rfl
  refine .branchFalse _ _ _ _ ⟨s,.normal⟩ (C99ScalarReference.boolean false) guard ?_ ?_
  · decide
  · exact .base _ _ _ (.skip _)

theorem n_run (s : State) (logn : lognAt s) (full : fullAt s)
    (slot : s.locals "n".toList=some (.uint64,none)) :
    Exec KeygenNttForwardPrograms.nAssign s ⟨afterN s,.normal⟩ :=
  .assign "n".toList (.scalar (C99ArrayParser.mkn (KeygenNttForwardPrograms.var "logn")
    (KeygenNttForwardPrograms.var "full"))) s .uint64 none
    (C99IntegerReference.convert .uint64 512) slot (.scalar _ _ (mkn_eval s logn full))

theorem hn_run (s : State) (slot : s.locals "n".toList=some nCell)
    (free : s.locals "hn".toList=some (.uint64,none)) :
    Exec KeygenNttForwardPrograms.hnAssign s ⟨afterCompute s,.normal⟩ :=
  .assign "hn".toList (.scalar (.bin .shr (KeygenNttForwardPrograms.var "n")
    (KeygenNttForwardPrograms.num 1))) s .uint64 none
    (C99IntegerReference.convert .uint64 256) free (.scalar _ _ (half_eval s slot))

/- The complete prologue run at the selected words. -/
theorem prologue_run (before : State) (logn : lognAt before) (full : fullAt before) :
    Exec KeygenNttForwardPrograms.prologue before ⟨ready before,.normal⟩ := by
  rw [KeygenNttForwardExec.prologue_shape]
  refine .seqNormal _ _ _ _ _ (locals_run before) ?_
  rw [KeygenNttForwardExec.rest1_shape]
  refine .seqNormal _ _ _ _ _ (word_run _) ?_
  rw [KeygenNttForwardExec.rest2_shape]
  refine .seqNormal _ _ _ _ _ (pointers_run _) ?_
  rw [KeygenNttForwardExec.rest3_shape]
  refine .seqNormal _ _ _ _ _ (early_run _ (logn_keep before logn)) ?_
  rw [KeygenNttForwardExec.rest4_shape]
  refine .seqNormal _ _ _ _ _ (n_run _ (logn_keep before logn) (full_keep before full)
    (KeygenNttForwardExec.n_free before)) ?_
  rw [KeygenNttForwardExec.rest5_shape]
  refine .seqNormal _ _ _ _ _ (hn_run _ (n_bound _) (hn_free _)) (.base _ _ _ (.skip _))

/-! ## The w = gm[1] assign -/

theorem gm_one_pointer (s : State) (gm : ArrayPointer) (gmBinding : s.arrays "gm".toList=some gm)
    (capacity : gm.index+1≤gm.count) :
    Pointer s "gm".toList (KeygenNttForwardPrograms.num 1) (elem gm 1) := by
  have value : C99ArrayReference.scalar s (KeygenNttForwardPrograms.num 1)
      (C99IntegerReference.convert .int32 1) := C99ScalarReference.Eval.literal .int32 1
  have nonneg : (0:Int)≤(C99IntegerReference.convert .int32 1).integer := by decide
  have toNat : ((C99IntegerReference.convert .int32 1).integer).toNat=1 := by decide
  have within : PointerAdd gm ((C99IntegerReference.convert .int32 1).integer).toNat (elem gm 1) := by
    rw [toNat]
    exact PointerAdd.within gm 1 capacity
  exact Pointer.add "gm".toList (KeygenNttForwardPrograms.num 1) gm (elem gm 1)
    (C99IntegerReference.convert .int32 1) gmBinding value nonneg within

theorem w_run (s : State) (gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (gmOne : 1<gmn) (wDeclared : ∃ old, s.locals "w".toList=some (.uint32,old))
    (gmBinding : s.arrays "gm".toList=some gm) (capacity : gm.index+1≤gm.count)
    (gmRead : Load32 s.heap (elem gm 1) (gvs ⟨1,gmOne⟩)) :
    Exec KeygenNttForwardPrograms.wAssign s
      ⟨ModularAtoms178.set s "w" (gvs ⟨1,gmOne⟩),.normal⟩ ∧
      Slot (ModularAtoms178.set s "w" (gvs ⟨1,gmOne⟩)) "w" (gvs ⟨1,gmOne⟩) := by
  obtain ⟨old,declared⟩ := wDeclared
  have address : Pointer s "gm".toList (KeygenNttForwardPrograms.num 1) (elem gm 1) :=
    gm_one_pointer s gm gmBinding capacity
  have run : Exec KeygenNttForwardPrograms.wAssign s
      ⟨C99ArrayReference.bindValue s "w".toList .uint32 (.uint32 (gvs ⟨1,gmOne⟩)),.normal⟩ :=
    .assign "w".toList (.load32 "gm".toList (KeygenNttForwardPrograms.num 1)) s .uint32 old
      (.uint32 (gvs ⟨1,gmOne⟩)) declared
      (.load32 "gm".toList (KeygenNttForwardPrograms.num 1) (elem gm 1) (gvs ⟨1,gmOne⟩) address
        gmRead)
  have same : C99ArrayReference.bindValue s "w".toList .uint32 (.uint32 (gvs ⟨1,gmOne⟩)) =
      ModularAtoms178.set s "w" (gvs ⟨1,gmOne⟩) := rfl
  rw [same] at run
  exact ⟨run,ModularAtoms178.slot s "w" (gvs ⟨1,gmOne⟩)⟩

/-! ## The first-pass walk initialiser (firstInit) -/

theorem r2_pointer (s : State) (a : ArrayPointer) (hn : Nat) (hnBound : hn<2^64)
    (hnCell : Cell s "hn".toList hn) (strideCell : Cell s "stride".toList 1)
    (aBinding : s.arrays "a".toList=some a) (capacity : a.index+hn*1≤a.count) :
    Pointer s "a".toList (.bin .mul (KeygenNttForwardPrograms.var "hn")
      (KeygenNttForwardPrograms.var "stride")) (elem a hn) := by
  have product : C99ArrayReference.scalar s
      (.bin .mul (KeygenNttForwardPrograms.var "hn") (KeygenNttForwardPrograms.var "stride"))
      (.uint64 (C99NatWord141.word (hn*1))) := by
    change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
      (C99ScalarReference.Expr.arithmetic .times (.variable "hn".toList)
        (.variable "stride".toList)) (.uint64 (C99NatWord141.word (hn*1)))
    exact .arithmetic .times _ _ _ _ _
      (C99LoopScalar141.read s "hn".toList hn hnCell)
      (C99LoopScalar141.read s "stride".toList 1 strideCell)
      (StepNttFirst195.times_word hn 1 hnBound (by decide))
  have nonneg : (0:Int)≤(C99IntegerReference.Value.uint64 (C99NatWord141.word (hn*1))).integer := by
    rw [C99NatWord141.integer (hn*1) (by omega)]
    omega
  have toNat : ((C99IntegerReference.Value.uint64 (C99NatWord141.word (hn*1))).integer).toNat=hn*1 := by
    rw [C99NatWord141.integer (hn*1) (by omega)]
    exact Int.toNat_natCast (hn*1)
  have within : PointerAdd a
      ((C99IntegerReference.Value.uint64 (C99NatWord141.word (hn*1))).integer).toNat (elem a hn) := by
    rw [toNat]
    rw [← StepNttFirst195.elem_half a hn]
    exact PointerAdd.within a (hn*1) capacity
  exact Pointer.add "a".toList _ a (elem a hn) (.uint64 (C99NatWord141.word (hn*1)))
    aBinding product nonneg within

def initState (s : State) (a : ArrayPointer) (hn : Nat) : State :=
  bindPointer (bindPointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
    "r1".toList (elem a 0)) "r2".toList (elem a hn)

theorem init_u (s : State) (a : ArrayPointer) (hn : Nat) :
    Cell (initState s a hn) "u".toList 0 :=
  FftLocalCells140.cell_at s "u".toList (C99NatWord141.word 0)

theorem init_r1 (s : State) (a : ArrayPointer) (hn : Nat) :
    (initState s a hn).arrays "r1".toList=some (elem a 0) := by
  show (bindPointer (bindPointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
    "r1".toList (elem a 0)) "r2".toList (elem a hn)).arrays "r1".toList=_
  rw [StepCopyFixed190.bindPointer_arrays _ _ _ _ (by decide)]
  rfl

theorem init_r2 (s : State) (a : ArrayPointer) (hn : Nat) :
    (initState s a hn).arrays "r2".toList=some (elem a hn) := rfl

theorem init_locals (s : State) (a : ArrayPointer) (hn : Nat) (name : Name)
    (different : name≠"u".toList) : (initState s a hn).locals name=s.locals name := by
  show (FftLocalCells140.put s "u".toList (C99NatWord141.word 0)).locals name=s.locals name
  exact FftLocalCells140.outside s "u".toList name (C99NatWord141.word 0) different

theorem init_arrays (s : State) (a : ArrayPointer) (hn : Nat) (name : Name)
    (first : name≠"r1".toList) (second : name≠"r2".toList) :
    (initState s a hn).arrays name=s.arrays name := by
  show (bindPointer (bindPointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
    "r1".toList (elem a 0)) "r2".toList (elem a hn)).arrays name=_
  rw [StepCopyFixed190.bindPointer_arrays _ _ _ _ second]
  rw [StepCopyFixed190.bindPointer_arrays _ _ _ _ first]
  rfl

theorem init_run (s : State) (a : ArrayPointer) (hn : Nat)
    (hnBound : hn<2^64) (hnCell : Cell s "hn".toList hn) (strideCell : Cell s "stride".toList 1)
    (uDeclared : ∃ old, s.locals "u".toList=some (.uint64,old))
    (aBinding : s.arrays "a".toList=some a) (aCapacity : a.index+2*hn≤a.count) :
    Exec KeygenNttForwardPrograms.firstInit s ⟨initState s a hn,.normal⟩ := by
  obtain ⟨old,declared⟩ := uDeclared
  have assign : Exec (.assign "u".toList (.scalar (KeygenNttForwardPrograms.num 0))) s
      ⟨FftLocalCells140.put s "u".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))
  have aCap : a.index≤a.count := by omega
  have mid1Hn : Cell (FftLocalCells140.put s "u".toList (C99NatWord141.word 0)) "hn".toList hn :=
    (FftLocalCells140.outside s "u".toList "hn".toList (C99NatWord141.word 0)
      (by decide)).trans hnCell
  have mid1Stride : Cell (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
      "stride".toList 1 :=
    (FftLocalCells140.outside s "u".toList "stride".toList (C99NatWord141.word 0)
      (by decide)).trans strideCell
  have mid1A : (FftLocalCells140.put s "u".toList (C99NatWord141.word 0)).arrays "a".toList=
      some a := aBinding
  have r1Pointer : Pointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
      "a".toList KeygenNttButterflyPrograms.zero (elem a 0) :=
    StepCopyBody190.zero_pointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
      "a".toList a mid1A aCap
  have r1Run' : Exec (.base (.bindPtr "r1".toList "a".toList KeygenNttButterflyPrograms.zero))
      (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
      ⟨bindPointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
        "r1".toList (elem a 0),.normal⟩ :=
    .base _ _ _ (.bindPtr _ "r1".toList "a".toList KeygenNttButterflyPrograms.zero
      (elem a 0) r1Pointer)
  have mid2A : (bindPointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
      "r1".toList (elem a 0)).arrays "a".toList=some a :=
    (StepCopyFixed190.bindPointer_arrays (FftLocalCells140.put s "u".toList
      (C99NatWord141.word 0)) "r1".toList (elem a 0) "a".toList (by decide)).trans mid1A
  have mid2Hn : Cell (bindPointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
      "r1".toList (elem a 0)) "hn".toList hn := mid1Hn
  have mid2Stride : Cell (bindPointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
      "r1".toList (elem a 0)) "stride".toList 1 := mid1Stride
  have r2Pointer : Pointer (bindPointer (FftLocalCells140.put s "u".toList
      (C99NatWord141.word 0)) "r1".toList (elem a 0)) "a".toList
      (.bin .mul (KeygenNttForwardPrograms.var "hn") (KeygenNttForwardPrograms.var "stride"))
      (elem a hn) :=
    r2_pointer (bindPointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
      "r1".toList (elem a 0)) a hn hnBound mid2Hn mid2Stride mid2A (by omega)
  have r2Run : Exec (.base (.bindPtr "r2".toList "a".toList (.bin .mul
      (KeygenNttForwardPrograms.var "hn") (KeygenNttForwardPrograms.var "stride"))))
      (bindPointer (FftLocalCells140.put s "u".toList (C99NatWord141.word 0))
        "r1".toList (elem a 0)) ⟨initState s a hn,.normal⟩ :=
    .base _ _ _ (.bindPtr _ "r2".toList "a".toList
      (.bin .mul (KeygenNttForwardPrograms.var "hn") (KeygenNttForwardPrograms.var "stride"))
      (elem a hn) r2Pointer)
  exact .seqNormal _ _ _ _ _ assign (.seqNormal _ _ _ _ _ r1Run' r2Run)

end FT1536.Source3.StepNttPrologue195
