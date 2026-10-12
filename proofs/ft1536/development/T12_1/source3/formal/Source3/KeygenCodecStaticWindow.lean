import Source3.KeygenCodecLocalFacts

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Fold the three bound guarded writes through complete source scopes,
   branches and finite loops. The local capacity/u/buf facts are derived
   from source declarations, assignments, expression effects and scope
   restoration. The observed return is unrestricted. -/
namespace FT1536.Source3.KeygenCodecStaticWindow
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecLocalFacts (Valid expression objectsSafe)
open KeygenCodecGuardedWrite (Window guarded)

structure Invariant (args : Args) (s : State) : Prop where
  locals : Valid args s.locals
  buffer : s.buf=none ∨ s.buf=some args.out

theorem window_refl (dst : ArrayPointer) (capacity : Nat) (heap : Memory) : Window dst capacity heap heap :=
  ⟨rfl,rfl,fun _ _ _ => rfl⟩

theorem window_trans (dst : ArrayPointer) (capacity : Nat) (a b c : Memory)
    (first : Window dst capacity a b) (second : Window dst capacity b c) : Window dst capacity a c :=
  ⟨second.sizes.trans first.sizes,second.writable.trans first.writable,
    fun block offset outside => (second.bytes block offset outside).trans (first.bytes block offset outside)⟩

theorem scope_valid (args : Args) (a : Stmt) (s t : State)
    (outer : Invariant args s) (inner : Invariant args t) : Invariant args (scopeExit a s t) := by
  refine ⟨⟨?_,?_,?_⟩,?_⟩
  · change (if _ then s.locals.scalars _ else t.locals.scalars _)=_
    split <;> first | exact outer.locals.capacity | exact inner.locals.capacity
  · intro name ty v held
    change (if _ then s.locals.scalars name else t.locals.scalars name)=_ at held
    split at held
    · exact outer.locals.typed name ty v held
    · exact inner.locals.typed name ty v held
  · intro ty old held
    change (if _ then s.locals.scalars _ else t.locals.scalars _)=_ at held
    split at held
    · exact outer.locals.cursor ty old held
    · exact inner.locals.cursor ty old held
  · change (if _ then s.buf else t.buf)=none ∨ (if _ then s.buf else t.buf)=some args.out
    split <;> first | exact outer.buffer | exact inner.buffer

theorem with_valid (args : Args) (s : State) (l : Locals) (valid : Valid args l)
    (before : Invariant args s) : Invariant args (withLocals s l) := ⟨valid,before.buffer⟩

theorem evaluated_valid (args : Args) (s : State) (e : Expr) (value : Value) (l : Locals)
    (eval : Eval args s.heap s.buf e s.locals value l) (safe : expression e=true)
    (valid : Invariant args s) : Invariant args (withLocals s l) :=
  with_valid args s l (KeygenCodecLocalFacts.eval_valid args s.heap s.buf e _ _ value eval safe valid.locals) valid

def safe : Stmt → Bool
  | .skip => true
  | .declare objects => objectsSafe objects
  | .write (.variable name) op rhs =>
      if name="buf".toList then op==.set && rhs==.variable "out".toList
      else name != "max_out_len".toList && expression rhs
  | .evaluate e => expression e
  | .increment (.variable name) => name != "max_out_len".toList
  | .seq a b =>
      if a=.branch KeygenCodecGuardedWrite.test KeygenCodecGuardedWrite.reject .skip then
        match b with
        | .seq (.write (.index (.variable buf) (.variable u)) .set rhs) .skip =>
            buf=="buf".toList && u=="u".toList && expression rhs
        | _ => safe a && safe b
      else safe a && safe b
  | .scope a => safe a
  | .branch test a b => expression test && safe a && safe b
  | .whileLoop test a => expression test && safe a
  | .loop _ _ _ _ => false
  | .ret e => expression e
  | _ => false

theorem guard_live (args : Args) (s t : State) (flow : Flow) (valid : Valid args s.locals)
    (source : Exec args (.branch KeygenCodecGuardedWrite.test KeygenCodecGuardedWrite.reject .skip) s t flow) :
    ∃ u : BitVec 64, s.locals.scalars "u".toList=some (.uint64,some (.uint64 u)) := by
  have fromEval (value : Value) (l : Locals)
      (eval : Eval args s.heap s.buf KeygenCodecGuardedWrite.test s.locals value l) :
      ∃ u : BitVec 64, s.locals.scalars "u".toList=some (.uint64,some (.uint64 u)) := by
    cases eval with
    | binary op a b l m t x y z first second operation =>
      cases first with
      | scalar name l ty v held =>
        have width := valid.cursor ty (some v) held
        have type := valid.typed "u".toList ty v held
        subst ty
        cases v <;> simp_all [C99IntegerReference.Value.type]
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected => exact fromEval value locals evaluated
  | branchFalse args test a b s t flow value locals evaluated no selected => exact fromEval value locals evaluated

theorem guarded_fold (args : Args) (s t : State) (flow : Flow) (rhs : Expr) (dst : ArrayPointer)
    (out : args.out=some dst) (valid : Invariant args s) (rhsSafe : expression rhs=true)
    (source : Exec args (guarded rhs) s t flow) : Invariant args t ∧ Window dst args.capacity.toNat s.heap t.heap := by
  have getU : ∃ u : BitVec 64, s.locals.scalars "u".toList=some (.uint64,some (.uint64 u)) := by
    cases source with
    | seq args a b s middle t flow first second => exact guard_live args s middle .normal valid.locals first
    | seqReturn args a b s t value first => exact guard_live args s t (.returned value) valid.locals first
  obtain ⟨u,uCell⟩ := getU
  cases source with
  | seq args a b s middle t flow first second =>
    obtain ⟨same,bound⟩ := KeygenCodecGuardedWrite.guard_step args s middle .normal u uCell valid.locals.capacity first
    subst middle
    cases second with
    | seq args a b s middle t flow first second =>
      cases first with
      | store args s index rhs m last ptr offset word after held indexValue nonnegative rhsValue write =>
        have buffer : s.buf=some (some dst) := by rcases valid.buffer with empty | buffer <;> simp_all
        have pointer : ptr=dst := by simpa using held.symm.trans buffer
        subst ptr
        obtain ⟨sameIndex,sameLocals⟩ := KeygenCodecGuardedWrite.u_eval args s.heap s.buf s.locals m (.integer offset) u uCell indexValue
        have sameValue : offset=.uint64 u := Value.integer.inj sameIndex
        subst offset
        subst m
        have values := KeygenCodecLocalFacts.eval_valid args s.heap s.buf rhs s.locals last (.integer word) rhsValue rhsSafe valid.locals
        cases second
        exact ⟨⟨values,valid.buffer⟩,KeygenCodecGuardedWrite.store_window dst args.capacity.toNat u.toNat s.heap after _ (bound rfl) write⟩
    | seqReturn args a b s t value first => cases first
  | seqReturn args a b s t value first =>
    obtain ⟨same,_⟩ := KeygenCodecGuardedWrite.guard_step args s t (.returned value) u uCell valid.locals.capacity first
    subst t
    exact ⟨valid,window_refl dst args.capacity.toNat s.heap⟩

theorem seq_safe (a b : Stmt) (held : safe (.seq a b)=true) :
    (∃ rhs, .seq a b=guarded rhs ∧ expression rhs=true) ∨ (safe a=true ∧ safe b=true) := by
  simp only [safe] at held
  split at held
  · split at held
    · simp only [Bool.and_eq_true,beq_iff_eq] at held
      rcases held with ⟨⟨buf,u⟩,rhs⟩
      left
      refine ⟨_,?_,rhs⟩
      simp_all [guarded]
    · exact Or.inr (KeygenCodecLocalFacts.and_parts held)
  · exact Or.inr (KeygenCodecLocalFacts.and_parts held)

theorem exec_fold (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) (dst : ArrayPointer) (out : args.out=some dst)
    (checked : safe stmt=true) (valid : Invariant args s) :
    Invariant args t ∧ Window dst args.capacity.toNat s.heap t.heap := by
  induction source with
  | skip => exact ⟨valid,window_refl dst _ _⟩
  | declare args s objects locals declarations =>
    refine ⟨⟨KeygenCodecLocalFacts.declare_valid args objects s.locals locals declarations checked valid.locals,?_⟩,
      window_refl dst _ _⟩
    change (if hasBuf objects then none else s.buf)=none ∨ (if hasBuf objects then none else s.buf)=some args.out
    split
    · exact Or.inl rfl
    · exact valid.buffer
  | bind => exact ⟨⟨valid.locals,Or.inr rfl⟩,window_refl dst _ _⟩
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have parts : name≠"max_out_len".toList ∧ expression rhs=true := by
      simpa only [safe,notBuf,ite_false,Bool.and_eq_true,bne_iff_ne] using checked
    have afterEval := KeygenCodecLocalFacts.eval_valid args s.heap s.buf rhs s.locals locals (.integer value) evaluated parts.2 valid.locals
    refine ⟨⟨KeygenCodecLocalFacts.set_valid args locals name ty _ afterEval parts.1 ?_ ?_,valid.buffer⟩,window_refl dst _ _⟩
    · intro same
      exact valid.locals.cursor ty old (by simpa only [same] using declared)
    · intro v same
      cases same
      exact KeygenCodecLocalFacts.convert_type ty result.integer
  | store => simp [safe] at checked
  | increment args s name locals old value step =>
    exact ⟨with_valid args s locals (KeygenCodecLocalFacts.update_valid args name 1 s.locals locals old value step valid.locals (by simpa [safe] using checked)) valid,window_refl dst _ _⟩
  | evaluate args s e value locals evaluated =>
    exact ⟨evaluated_valid args s e value locals evaluated checked valid,window_refl dst _ _⟩
  | seq args a b s m t flow first second ih1 ih2 =>
    rcases seq_safe a b checked with atom | parts
    · obtain ⟨rhs,shape,rhsSafe⟩ := atom
      exact guarded_fold args s t flow rhs dst out valid rhsSafe (shape ▸ Exec.seq args a b s m t flow first second)
    · obtain ⟨middle,frame1⟩ := ih1 out parts.1 valid
      obtain ⟨last,frame2⟩ := ih2 out parts.2 middle
      exact ⟨last,window_trans dst _ _ _ _ frame1 frame2⟩
  | seqReturn args a b s t value first ih =>
    rcases seq_safe a b checked with atom | parts
    · obtain ⟨rhs,shape,rhsSafe⟩ := atom
      exact guarded_fold args s t (.returned value) rhs dst out valid rhsSafe (shape ▸ Exec.seqReturn args a b s t value first)
    · exact ih out parts.1 valid
  | scope args a s t flow noBufShadow inside ih =>
    obtain ⟨last,frame⟩ := ih out checked valid
    exact ⟨scope_valid args a s t valid last,frame⟩
  | branchTrue args test a b s t flow value locals evaluated yes selected ih =>
    have parts : (expression test=true ∧ safe a=true) ∧ safe b=true := by simpa only [safe,Bool.and_eq_true] using checked
    exact ih out parts.1.2 (evaluated_valid args s test value locals evaluated parts.1.1 valid)
  | branchFalse args test a b s t flow value locals evaluated no selected ih =>
    have parts : (expression test=true ∧ safe a=true) ∧ safe b=true := by simpa only [safe,Bool.and_eq_true] using checked
    exact ih out parts.2 (evaluated_valid args s test value locals evaluated parts.1.1 valid)
  | whileDone args test a s value locals evaluated no =>
    have parts : expression test=true ∧ safe a=true := by simpa only [safe,Bool.and_eq_true] using checked
    exact ⟨evaluated_valid args s test value locals evaluated parts.1 valid,window_refl dst _ _⟩
  | whileNext args test a s m t flow value locals evaluated yes iteration rest ih1 ih2 =>
    have parts : expression test=true ∧ safe a=true := by simpa only [safe,Bool.and_eq_true] using checked
    obtain ⟨middle,frame1⟩ := ih1 out parts.2 (evaluated_valid args s test value locals evaluated parts.1 valid)
    obtain ⟨last,frame2⟩ := ih2 out checked middle
    exact ⟨last,window_trans dst _ _ _ _ frame1 frame2⟩
  | whileReturn args test a s t ret value locals evaluated yes iteration ih =>
    have parts : expression test=true ∧ safe a=true := by simpa only [safe,Bool.and_eq_true] using checked
    exact ih out parts.2 (evaluated_valid args s test value locals evaluated parts.1 valid)
  | forLoop => simp [safe] at checked
  | switchNone => simp [safe] at checked
  | switchStatic => simp [safe] at checked
  | switchOther => simp [safe] at checked
  | ret args s e value locals evaluated =>
    exact ⟨evaluated_valid args s e (.integer value) locals evaluated checked valid,window_refl dst _ _⟩
  | call => simp [safe,KeygenCodecLocalFacts.expression] at checked

theorem static_checked : safe KeygenCodecStaticBinding.code=true := by decide +kernel

/-- Complete STATIC body, every finite defined path, every observed flow,
    including return0 after partial writes. The exact capacity window is
    derived without any length/result/frame premise or profile restriction. -/
theorem static_window (args : Args) (before : Memory) (after : State) (flow : Flow)
    (dst : ArrayPointer) (out : args.out=some dst)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    Window dst args.capacity.toNat before after.heap := by
  exact (exec_fold args _ _ after flow source dst out static_checked
    ⟨KeygenCodecLocalFacts.initial_valid args,Or.inl rfl⟩).2

end FT1536.Source3.KeygenCodecStaticWindow
