import Source3.KeygenNttForwardPrograms
import Source3.C99ControlInversion
import Source3.C99CountedWords

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Execution derivations for the pinned forward-NTT prologue. The M0 path
   values n=1536, hn=768 and the logn0 guard verdict are extracted FROM an
   Exec derivation of the parsed prologue: no success constructor carries
   evaluations and no NTT oracle appears. stride=1 is the pinned wrapper
   argument (KeygenNttButterflyPrograms.wrapper_source); its caller-frame
   instantiation belongs to the whole-KeyGen control step. -/
namespace FT1536.Source3.KeygenNttForwardExec
open C99ModularReference (Stmt Exec)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenNttForwardPrograms (var num word pointers earlyExit nAssign hnAssign locals prologue)

def lognAt (s : State) : Prop := s.locals "logn".toList=some (.uint32,some (.uint32 10))
def fullAt (s : State) : Prop := s.locals "full".toList=some (.uint32,some (.uint32 1))
def nCell : Ty×Option Value := (.uint64,some (C99IntegerReference.convert .uint64 1536))
def hnCell : Ty×Option Value := (.uint64,some (C99IntegerReference.convert .uint64 768))
def names6 : List B20.C.Name := ["n","hn","u","r","m","t"].map String.toList

def declareCell (env : C99ScalarReference.Env) (name : String) (ty : Ty) : C99ScalarReference.Env :=
  C99ScalarReference.set env name.toList (ty,none)
def env6 (env : C99ScalarReference.Env) : C99ScalarReference.Env :=
  declareCell (declareCell (declareCell (declareCell (declareCell
    (declareCell env "n" .uint64) "hn" .uint64) "u" .uint64) "r" .uint64) "m" .uint64) "t" .uint64
def afterLocals (before : State) : State := {before with locals := env6 before.locals}
def afterWord (before : State) : State := {before with locals := declareCell before.locals "w" .uint32}
def afterPointers (before : State) : State :=
  {before with arrays := fun n =>
    if n="r2".toList then none else if n="r1".toList then none else before.arrays n}
def afterN (before : State) : State :=
  {before with locals := C99ScalarReference.set before.locals "n".toList nCell}
def afterCompute (before : State) : State :=
  {before with locals := C99ScalarReference.set before.locals "hn".toList hnCell}
def ready (before : State) : State :=
  afterCompute (afterN (afterPointers (afterWord (afterLocals before))))

/- Ground conversions at the statement boundaries. -/
theorem convert_1536 : C99IntegerReference.convert .uint64 1536=Value.uint64 1536 := by decide
theorem convert_768 : C99IntegerReference.convert .uint64 768=Value.uint64 768 := by decide

/- Predictable inversions: the major premise has variable indices, so no
   constructor field is determined and every binder appears exactly once. -/
theorem eval_scalar (s : State) (e : CLogic.Expr) (v : Value)
    (h : C99ModularReference.Eval s (.scalar e) v) : C99ArrayReference.scalar s e v := by
  cases h with
  | scalar e v source => exact source

theorem eval_cast (env : C99ScalarReference.Env) (t : Ty) (e : C99ScalarReference.Expr) (v : Value)
    (h : C99ScalarReference.Eval FprPrefixCalls.calls env (.cast t e) v) :
    ∃ u, C99ScalarReference.Eval FprPrefixCalls.calls env e u ∧
      v=C99IntegerReference.convert t u.integer := by
  cases h with
  | cast t e u inner => exact ⟨u,inner,rfl⟩

theorem eval_arith (env : C99ScalarReference.Env) (op : C99IntegerReference.Arithmetic)
    (a b : C99ScalarReference.Expr) (v : Value)
    (h : C99ScalarReference.Eval FprPrefixCalls.calls env (.arithmetic op a b) v) :
    ∃ x y, C99ScalarReference.Eval FprPrefixCalls.calls env a x ∧
      C99ScalarReference.Eval FprPrefixCalls.calls env b y ∧
      C99IntegerReference.ArithmeticExec op x y v := by
  cases h with
  | arithmetic op a b x y z hx hy hop => exact ⟨x,y,hx,hy,hop⟩

theorem eval_shift (env : C99ScalarReference.Env) (op : C99IntegerReference.Shift)
    (a b : C99ScalarReference.Expr) (v : Value)
    (h : C99ScalarReference.Eval FprPrefixCalls.calls env (.shift op a b) v) :
    ∃ x y, C99ScalarReference.Eval FprPrefixCalls.calls env a x ∧
      C99ScalarReference.Eval FprPrefixCalls.calls env b y ∧
      C99IntegerReference.ShiftExec op x y v := by
  cases h with
  | shift op a b x y z hx hy hop => exact ⟨x,y,hx,hy,hop⟩

theorem eval_compare (env : C99ScalarReference.Env) (op : C99IntegerReference.Comparison)
    (a b : C99ScalarReference.Expr) (v : Value)
    (h : C99ScalarReference.Eval FprPrefixCalls.calls env (.compare op a b) v) :
    ∃ x y, C99ScalarReference.Eval FprPrefixCalls.calls env a x ∧
      C99ScalarReference.Eval FprPrefixCalls.calls env b y ∧
      C99IntegerReference.CompareExec op x y v := by
  cases h with
  | compare op a b x y z hx hy hop => exact ⟨x,y,hx,hy,hop⟩

theorem shift_left_value (x y z : Value) (h : C99IntegerReference.ShiftExec .left x y z) :
    ∃ n : Nat, y.integer=(n : Int) ∧ n<C99IntegerReference.width x.type ∧
      z=C99IntegerReference.convert x.type (x.integer * 2^n) := by
  cases h with
  | unsignedLeft x y n unsigned count bound => exact ⟨n,count,bound,rfl⟩
  | signedLeft x y n isSigned count bound positive safe => exact ⟨n,count,bound,rfl⟩

theorem assign_inv (s : State) (name : B20.C.Name) (e : C99ModularReference.Expr) (out : Result)
    (h : Exec (.assign name e) s out) :
    ∃ ty old v, s.locals name=some (ty,old) ∧ C99ModularReference.Eval s e v ∧
      out=⟨C99ArrayReference.bindValue s name ty v,.normal⟩ := by
  cases h with
  | assign name e before ty old v declared value => exact ⟨ty,old,v,declared,value,rfl⟩

theorem base_inv (code : C99ArrayReference.Stmt) (s : State) (out : Result)
    (h : Exec (.base code) s out) :
    ∃ mid, C99ArrayReference.Exec FftLeafPrograms.program code s mid ∧ out=⟨mid,.normal⟩ := by
  cases h with
  | base code before after execution => exact ⟨after,execution,rfl⟩

theorem scalar_inv (stmt : CLogic.Stmt) (s : State) (mid : State)
    (h : C99ArrayReference.Exec FftLeafPrograms.program (.scalar stmt) s mid) :
    ∃ env, C99ScalarReference.Exec FprPrefixCalls.calls s.locals (C99Frontend.scalar stmt)
        (C99ScalarReference.Result.normal env) ∧ mid={s with locals := env} := by
  cases h with
  | scalar before env stmt body => exact ⟨env,body,rfl⟩

theorem declarePtr_inv (name : B20.C.Name) (s : State) (mid : State)
    (h : C99ArrayReference.Exec FftLeafPrograms.program (.declarePtr name) s mid) :
    mid={s with arrays := fun n => if n=name then none else s.arrays n} := by
  cases h
  rfl

theorem seq_inv (a b : Stmt) (s : State) (out : Result) (h : Exec (.seq a b) s out) :
    (∃ mid, Exec a s ⟨mid,.normal⟩ ∧ Exec b mid out) ∨
      (∃ r, Exec a s r ∧ r.flow≠.normal ∧ out=r) := by
  cases h with
  | seqNormal _ _ _ mid _ head tail => exact Or.inl ⟨mid,head,tail⟩
  | seqExit _ _ _ _ head exit => exact Or.inr ⟨out,head,exit,rfl⟩

theorem branch_inv (c : CLogic.Expr) (yes no : Stmt) (s : State) (out : Result)
    (h : Exec (.branch c yes no) s out) :
    (∃ v, C99ArrayReference.scalar s c v ∧ v.integer≠0 ∧ Exec yes s out) ∨
      (∃ v, C99ArrayReference.scalar s c v ∧ v.integer=0 ∧ Exec no s out) := by
  cases h with
  | branchTrue condition yes no before result v guard nonzero body =>
      exact Or.inl ⟨v,guard,nonzero,body⟩
  | branchFalse condition yes no before result v guard zero body =>
      exact Or.inr ⟨v,guard,zero,body⟩

/- Source expression values on the M0 path. -/
theorem literal_value (s : State) (t : B20.C.Ty) (n : Nat) (v : Value)
    (source : C99ArrayReference.scalar s (.literal t n) v) :
    v=C99IntegerReference.convert (C99ValueBridge.type t) n := by
  change C99ScalarReference.Eval _ _ (.literal (C99ValueBridge.type t) n) v at source
  cases source
  rfl

theorem guard_value (s : State) (v : Value) (logn : lognAt s)
    (source : C99ArrayReference.scalar s KeygenNttForwardPrograms.lognZero v) :
    v=C99ScalarReference.boolean false := by
  change C99ScalarReference.Eval _ _
    (.compare .eq (.variable "logn".toList) (.literal .int32 0)) v at source
  obtain ⟨x,y,hx,hy,operation⟩ := eval_compare s.locals .eq _ _ v source
  have hx1 := C99CountedWords.variable_exact s "logn".toList .uint32 (.uint32 10) x logn hx
  subst x
  have hy1 := literal_value s B20.C.Ty.i32 0 y hy
  subst y
  rw [C99CountedWords.comparison_result .eq (Value.uint32 10)
    (C99IntegerReference.convert (C99ValueBridge.type .i32) 0) v operation]
  decide

theorem shl_full_value (s : State) (v : Value) (full : fullAt s)
    (source : C99ArrayReference.scalar s (.bin .shl (var "full") (num 1)) v) :
    v=C99IntegerReference.convert .uint32 2 := by
  change C99ScalarReference.Eval _ _
    (.shift .left (.variable "full".toList) (.literal .int32 1)) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := eval_shift s.locals .left _ _ v source
  have hx1 := C99CountedWords.variable_exact s "full".toList .uint32 (.uint32 1) x full hx
  subst x
  have hy1 := literal_value s B20.C.Ty.i32 1 y hy
  subst y
  obtain ⟨n,hn,hb,he⟩ := shift_left_value _ _ v hop
  have hnn : n=1 := by
    have h1 : (C99IntegerReference.convert (C99ValueBridge.type B20.C.Ty.i32) ((1:Nat):Int)).integer=(1:Int) :=
      by decide
    rw [h1] at hn
    omega
  subst n
  rw [he]
  decide

theorem plus_three_value (s : State) (v : Value) (full : fullAt s)
    (source : C99ArrayReference.scalar s (.bin .add (num 1) (.bin .shl (var "full") (num 1))) v) :
    v=C99IntegerReference.convert .uint32 3 := by
  change C99ScalarReference.Eval _ _
    (.arithmetic .plus (.literal .int32 1)
      (.shift .left (.variable "full".toList) (.literal .int32 1))) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := eval_arith s.locals .plus _ _ v source
  have hx1 := literal_value s B20.C.Ty.i32 1 x hx
  have hy1 := shl_full_value s y full hy
  subst x
  subst y
  have he := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp hop).2
  rw [he]
  decide

theorem minus_nine_value (s : State) (v : Value) (logn : lognAt s) (full : fullAt s)
    (source : C99ArrayReference.scalar s (.bin .sub (var "logn") (var "full")) v) :
    v=C99IntegerReference.convert .uint32 9 := by
  change C99ScalarReference.Eval _ _
    (.arithmetic .minus (.variable "logn".toList) (.variable "full".toList)) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := eval_arith s.locals .minus _ _ v source
  have hx1 := C99CountedWords.variable_exact s "logn".toList .uint32 (.uint32 10) x logn hx
  have hy1 := C99CountedWords.variable_exact s "full".toList .uint32 (.uint32 1) y full hy
  subst x
  subst y
  have he := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp hop).2
  rw [he]
  decide

theorem mkn_value (s : State) (v : Value) (logn : lognAt s) (full : fullAt s)
    (source : C99ArrayReference.scalar s (C99ArrayParser.mkn (var "logn") (var "full")) v) :
    v.integer=1536 := by
  change C99ScalarReference.Eval _ _
    (.shift .left (.cast .uint64 (.arithmetic .plus (.literal .int32 1)
        (.shift .left (.variable "full".toList) (.literal .int32 1))))
      (.arithmetic .minus (.variable "logn".toList) (.variable "full".toList))) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := eval_shift s.locals .left _ _ v source
  have hy1 := minus_nine_value s y logn full hy
  subst y
  obtain ⟨u,hsum,hcast⟩ := eval_cast s.locals .uint64 _ x hx
  have hu := plus_three_value s u full hsum
  subst u
  have hxeq : x=C99IntegerReference.convert .uint64 3 := by
    rw [hcast]
    decide
  subst x
  obtain ⟨n,hn,hb,he⟩ := shift_left_value _ _ v hop
  have hnn : n=9 := by
    have h9 : (C99IntegerReference.convert .uint32 9).integer=9 := by decide
    rw [h9] at hn
    omega
  subst n
  rw [he]
  decide

theorem half_value (s : State) (v : Value) (slot : s.locals "n".toList=some nCell)
    (source : C99ArrayReference.scalar s (.bin .shr (var "n") (num 1)) v) :
    v.integer=768 := by
  change C99ScalarReference.Eval _ _
    (.shift .right (.variable "n".toList) (.literal .int32 1)) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := eval_shift s.locals .right _ _ v source
  have hx1 : x=C99IntegerReference.convert .uint64 1536 :=
    C99CountedWords.variable_exact s "n".toList .uint64 (C99IntegerReference.convert .uint64 1536) x
      (by simpa [nCell] using slot) hx
  subst x
  have hy1 := literal_value s B20.C.Ty.i32 1 y hy
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

/- Statement-level extraction from Exec derivations. -/
theorem declarations_result (env : C99ScalarReference.Env) (ty : Ty) (names : List B20.C.Name)
    (out : C99ScalarReference.Result)
    (source : C99ScalarReference.Exec FprPrefixCalls.calls env
      (C99Frontend.declarations ty names) out) :
    out=.normal (names.foldl (fun e n => C99ScalarReference.set e n (ty,none)) env) := by
  induction names generalizing env out with
  | nil => exact C99ControlInversion.skip_inv _ env out source
  | cons n rest ih =>
      obtain ⟨mid,head,tail⟩ := (C99ControlInversion.seq_inv _ env _ _ out source).resolve_right (by
        rintro ⟨v,h,he⟩
        cases C99ControlInversion.declare_inv _ env ty n (C99ScalarReference.Result.returned v) h)
      have hm := C99ControlInversion.declare_inv _ env ty n (C99ScalarReference.Result.normal mid) head
      cases hm
      exact ih _ _ tail

theorem locals_u (s : State) : ∀ out, Exec KeygenNttForwardPrograms.locals s out →
    out=⟨afterLocals s,.normal⟩ := by
  intro out source
  obtain ⟨mid,execution,he⟩ := base_inv _ s out (by
    simpa [KeygenNttForwardPrograms.locals,KeygenNttForwardPrograms.sizeDeclaration] using source)
  obtain ⟨env,body,hmid⟩ := scalar_inv _ s mid execution
  have hd := declarations_result s.locals (C99ValueBridge.type .u64) names6
    (C99ScalarReference.Result.normal env) body
  cases hd
  rw [he,hmid]
  rfl

theorem word_u (s : State) : ∀ out, Exec KeygenNttForwardPrograms.word s out →
    out=⟨afterWord s,.normal⟩ := by
  intro out source
  obtain ⟨mid,execution,he⟩ := base_inv _ s out (by
    simpa [KeygenNttForwardPrograms.word,KeygenNttForwardPrograms.wordDeclaration] using source)
  obtain ⟨env,body,hmid⟩ := scalar_inv _ s mid execution
  have hd := declarations_result s.locals (C99ValueBridge.type .u32) ["w".toList]
    (C99ScalarReference.Result.normal env) body
  cases hd
  rw [he,hmid]
  rfl

theorem declarePtr_step (name : B20.C.Name) (s : State) :
    ∀ out, Exec (.base (.declarePtr name)) s out →
      out=⟨{s with arrays := fun n => if n=name then none else s.arrays n},.normal⟩ := by
  intro out source
  obtain ⟨mid,execution,he⟩ := base_inv _ s out source
  rw [he,declarePtr_inv name s mid execution]

theorem pointers_u (s : State) : ∀ out, Exec KeygenNttForwardPrograms.pointers s out →
    out=⟨afterPointers s,.normal⟩ := by
  intro out source
  obtain h := seq_inv _ _ s out source
  cases h with
  | inl h =>
      obtain ⟨mid,head,tail⟩ := h
      have h1 := declarePtr_step "r1".toList s ⟨mid,.normal⟩ head
      have hm1 : mid={s with arrays := fun n => if n="r1".toList then none else s.arrays n} :=
        congrArg Result.state h1
      subst mid
      obtain h2 := seq_inv _ _ _ out tail
      cases h2 with
      | inl h =>
          obtain ⟨mid2,head2,tail2⟩ := h
          have h3 := declarePtr_step "r2".toList _ ⟨mid2,.normal⟩ head2
          have hm2 : mid2={s with arrays := fun n => if n="r2".toList then none else
              (if n="r1".toList then none else s.arrays n)} := congrArg Result.state h3
          subst mid2
          have h4 := C99ModularReference.skip_result _ out tail2
          rw [h4]
          rfl
      | inr h =>
          obtain ⟨r,head2,exit,he⟩ := h
          subst r
          obtain ⟨mid2,execution,hm⟩ := base_inv _ _ out head2
          rw [hm] at exit
          exact (exit rfl).elim
  | inr h =>
      obtain ⟨r,head,exit,he⟩ := h
      subst r
      obtain ⟨mid,execution,hm⟩ := base_inv _ s out head
      rw [hm] at exit
      exact (exit rfl).elim

theorem early_u (s : State) (logn : lognAt s) :
    ∀ out, Exec KeygenNttForwardPrograms.earlyExit s out → out=⟨s,.normal⟩ := by
  intro out source
  obtain h := branch_inv _ _ _ s out source
  cases h with
  | inl h =>
      obtain ⟨v,guard,nonzero,body⟩ := h
      rw [guard_value s v logn guard] at nonzero
      simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero
  | inr h =>
      obtain ⟨v,guard,zero,body⟩ := h
      exact C99ModularReference.skip_result s out body

theorem n_u (s : State) (logn : lognAt s) (full : fullAt s)
    (slot : s.locals "n".toList=some (.uint64,none)) :
    ∀ out, Exec KeygenNttForwardPrograms.nAssign s out → out=⟨afterN s,.normal⟩ := by
  intro out source
  obtain ⟨ty,old,v,declared,value,he⟩ := assign_inv s "n".toList _ out source
  have ht : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
  subst ty
  have hv : v.integer=1536 := mkn_value s v logn full (eval_scalar s _ v value)
  have heq : C99ArrayReference.bindValue s "n".toList .uint64 v=afterN s := by
    simp [C99ArrayReference.bindValue,afterN,nCell,hv]
  rw [he,heq]

theorem hn_u (s : State) (slot : s.locals "n".toList=some nCell)
    (free : s.locals "hn".toList=some (.uint64,none)) :
    ∀ out, Exec KeygenNttForwardPrograms.hnAssign s out → out=⟨afterCompute s,.normal⟩ := by
  intro out source
  obtain ⟨ty,old,v,declared,value,he⟩ := assign_inv s "hn".toList _ out source
  have ht : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans free))
  subst ty
  have hv : v.integer=768 := half_value s v slot (eval_scalar s _ v value)
  have heq : C99ArrayReference.bindValue s "hn".toList .uint64 v=afterCompute s := by
    simp [C99ArrayReference.bindValue,afterCompute,hnCell,hv]
  rw [he,heq]

/- Slot transports along the prologue states. -/
theorem logn_keep (s : State) (h : lognAt s) : lognAt (afterPointers (afterWord (afterLocals s))) := by
  simpa [lognAt,afterPointers,afterWord,afterLocals,env6,declareCell,C99ScalarReference.set] using h
theorem full_keep (s : State) (h : fullAt s) : fullAt (afterPointers (afterWord (afterLocals s))) := by
  simpa [fullAt,afterPointers,afterWord,afterLocals,env6,declareCell,C99ScalarReference.set] using h
theorem n_free (s : State) :
    (afterPointers (afterWord (afterLocals s))).locals "n".toList=some (.uint64,none) := by
  simp [afterPointers,afterWord,afterLocals,env6,declareCell,C99ScalarReference.set]
theorem n_bound (s : State) : (afterN s).locals "n".toList=some nCell := by
  simp [afterN,C99ScalarReference.set]
theorem hn_free (s : State) :
    (afterN (afterPointers (afterWord (afterLocals s)))).locals "hn".toList=some (.uint64,none) := by
  simp [afterN,afterPointers,afterWord,afterLocals,env6,declareCell,C99ScalarReference.set,nCell]

/- The complete prologue: the M0 values come from execution. -/
def rest1 : Stmt := KeygenNttButterflyPrograms.chain [word,pointers,earlyExit,nAssign,hnAssign]
def rest2 : Stmt := KeygenNttButterflyPrograms.chain [pointers,earlyExit,nAssign,hnAssign]
def rest3 : Stmt := KeygenNttButterflyPrograms.chain [earlyExit,nAssign,hnAssign]
def rest4 : Stmt := KeygenNttButterflyPrograms.chain [nAssign,hnAssign]
def rest5 : Stmt := KeygenNttButterflyPrograms.chain [hnAssign]
theorem prologue_shape : prologue=.seq locals rest1 := rfl
theorem rest1_shape : rest1=.seq word rest2 := rfl
theorem rest2_shape : rest2=.seq pointers rest3 := rfl
theorem rest3_shape : rest3=.seq earlyExit rest4 := rfl
theorem rest4_shape : rest4=.seq nAssign rest5 := rfl
theorem rest5_shape : rest5=.seq hnAssign (.base .skip) := rfl

theorem prologue_result (before : State) (result : Result)
    (logn : lognAt before) (full : fullAt before)
    (source : Exec prologue before result) : result=⟨ready before,.normal⟩ := by
  rw [prologue_shape] at source
  have e1 := C99ModularReference.continuation locals rest1 before (afterLocals before) result
    (locals_u before) source
  rw [rest1_shape] at e1
  have e2 := C99ModularReference.continuation word rest2 (afterLocals before)
    (afterWord (afterLocals before)) result (word_u (afterLocals before)) e1
  rw [rest2_shape] at e2
  have e3 := C99ModularReference.continuation pointers rest3 (afterWord (afterLocals before))
    (afterPointers (afterWord (afterLocals before))) result
    (pointers_u (afterWord (afterLocals before))) e2
  rw [rest3_shape] at e3
  have e4 := C99ModularReference.continuation earlyExit rest4
    (afterPointers (afterWord (afterLocals before)))
    (afterPointers (afterWord (afterLocals before))) result
    (early_u _ (logn_keep before logn)) e3
  rw [rest4_shape] at e4
  have e5 := C99ModularReference.continuation nAssign rest5
    (afterPointers (afterWord (afterLocals before))) (afterN (afterPointers (afterWord (afterLocals before))))
    result (n_u _ (logn_keep before logn) (full_keep before full) (n_free before)) e4
  rw [rest5_shape] at e5
  have e6 := C99ModularReference.continuation hnAssign (.base .skip)
    (afterN (afterPointers (afterWord (afterLocals before))))
    (afterCompute (afterN (afterPointers (afterWord (afterLocals before))))) result
    (hn_u _ (n_bound _) (hn_free _)) e5
  rw [C99ModularReference.skip_result _ result e6]
  rfl

theorem ready_n_slot (before : State) :
    (ready before).locals "n".toList=some (.uint64,some (.uint64 1536)) := by
  have h : (ready before).locals "n".toList=some nCell := by
    simp [ready,afterCompute,afterN,C99ScalarReference.set]
  simpa [nCell,convert_1536] using h

theorem ready_hn_slot (before : State) :
    (ready before).locals "hn".toList=some (.uint64,some (.uint64 768)) := by
  have h : (ready before).locals "hn".toList=some hnCell := by
    simp [ready,afterCompute,afterN,C99ScalarReference.set,nCell]
  simpa [hnCell,convert_768] using h

end FT1536.Source3.KeygenNttForwardExec
