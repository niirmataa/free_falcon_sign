import Source3.ThirdStepMarch215

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The counted first slen = 3 loop of the d=3 body: the per-row prime
   prefix, the complete iteration (prefix + generator + two-sided march
   tail) and the three counted iterations over the PRIMES3 rows 0..2
   from the u = 0 initializer to the false u < slen guard. All words
   stay executed words; no NTT/root/table law is claimed. -/
namespace FT1536.Source3.ThirdStepLoop215
open C99ArrayReference (State Name bindValue bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (addr elem)
open SecondStepCopy203 (Side)
open StepProductFixed203 (Image)
open ThirdStepLayout215 (fd gd fs gs gm igm t1)
open ThirdStepGenerator215 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open SecondStepProduct203 (root)
open ThirdStepMarch215

/- The per-row prime prefix of the loop body (declares p/p0i/R2/v/x,
   reads p = primes[u].p and executes p0i = modp_ninv31(p),
   R2 = modp_R2(p, p0i)), generic in the loop index u and its row v. -/
def declS (s : State) := StepPrimeDeclarations188.after s
def withP (s : State) (v : Nat×Nat×Nat) := bindValue (declS s) "p".toList .uint32 (.uint32 (pVal v))
def withI (s : State) (v : Nat×Nat×Nat) := bindValue (withP s v) "p0i".toList .uint32 (.uint32 (iVal v))
def afterP (s : State) (v : Nat×Nat×Nat) := bindValue (withI s v) "R2".toList .uint32 (.uint32 (rVal v))

theorem heapP (s : State) (v : Nat×Nat×Nat) : (afterP s v).heap=s.heap := rfl

theorem declS_arrays (s : State) (name : Name) (different : name≠"x".toList) :
    (declS s).arrays name=s.arrays name := by
  change (if name="x".toList then none else s.arrays name)=s.arrays name
  simp only [different,ite_false]

theorem arraysP (s : State) (v : Nat×Nat×Nat) (name : Name) (different : name≠"x".toList) :
    (afterP s v).arrays name=s.arrays name := declS_arrays s name different

theorem not_private (name : Name) (absent : name∉StepPrimeShape188.localNames) (word : String)
    (member : word.toList∈StepPrimeShape188.localNames) : name≠word.toList := by
  intro same
  apply absent
  rw [same]
  exact member

theorem declS_locals (s : State) (name : Name) (absent : name∉StepPrimeShape188.localNames) :
    (declS s).locals name=s.locals name := by
  have subset : ["p".toList,"p0i".toList,"R2".toList] ⊆ StepPrimeShape188.localNames := by decide
  have first := SelectedStepAddPrime195.effect_locals .u32 ["p".toList,"p0i".toList,"R2".toList] s name
    (fun member => absent (subset member))
  have second := SelectedStepAddPrime195.effect_locals .u64 ["v".toList] (StepPrimeDeclarations188.withWords s) name
    (by simpa only [List.mem_singleton] using not_private name absent "v" (by decide))
  exact second.trans first

theorem localsP (s : State) (v : Nat×Nat×Nat) (name : Name) (absent : name∉StepPrimeShape188.localNames) :
    (afterP s v).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (withI s v) "R2".toList .uint32 (.uint32 (rVal v)) name
      (not_private name absent "R2" (by decide))).trans
    ((SelectedStepAddPrime195.locals_keep (withP s v) "p0i".toList .uint32 (.uint32 (iVal v)) name
      (not_private name absent "p0i" (by decide))).trans
      ((SelectedStepAddPrime195.locals_keep (declS s) "p".toList .uint32 (.uint32 (pVal v)) name
        (not_private name absent "p" (by decide))).trans (declS_locals s name absent)))

theorem p_cellP (s : State) (v : Nat×Nat×Nat) : Slot (afterP s v) "p" (pVal v) :=
  (SelectedStepAddPrime195.locals_keep (withI s v) "R2".toList .uint32 (.uint32 (rVal v)) "p".toList (by decide)).trans
    ((SelectedStepAddPrime195.locals_keep (withP s v) "p0i".toList .uint32 (.uint32 (iVal v)) "p".toList (by decide)).trans
      (ModularAtoms178.slot (declS s) "p" (pVal v)))

theorem i_cellP (s : State) (v : Nat×Nat×Nat) : Slot (afterP s v) "p0i" (iVal v) :=
  (SelectedStepAddPrime195.locals_keep (withI s v) "R2".toList .uint32 (.uint32 (rVal v)) "p0i".toList (by decide)).trans
    (ModularAtoms178.slot (withP s v) "p0i" (iVal v))

theorem r2_cellP (s : State) (v : Nat×Nat×Nat) : Slot (afterP s v) "R2" (rVal v) :=
  ModularAtoms178.slot (withI s v) "R2" (rVal v)

theorem v_declP (s : State) (v : Nat×Nat×Nat) : (afterP s v).locals "v".toList=some (.uint64,none) :=
  (SelectedStepAddPrime195.locals_keep (withI s v) "R2".toList .uint32 (.uint32 (rVal v)) "v".toList (by decide)).trans
    ((SelectedStepAddPrime195.locals_keep (withP s v) "p0i".toList .uint32 (.uint32 (iVal v)) "v".toList (by decide)).trans
      ((SelectedStepAddPrime195.locals_keep (declS s) "p".toList .uint32 (.uint32 (pVal v)) "v".toList (by decide)).trans rfl))

theorem p_read (s : State) (u : Nat) (v : Nat×Nat×Nat) (input : CrtPrimePrefix214.Input s u v) :
    KeygenLevelCalls.PrimeRead (declS s) "primes".toList (FirstStepEntry187.var "u") .p (.uint32 (pVal v)) :=
  CrtPrimePrefix214.primeRead s u v input .p (declS s)
    ((declS_arrays s "primes".toList (by decide)).trans input.primesBinding)
    ((declS_locals s "u".toList (by decide)).trans input.uCell) rfl

theorem p_source (s : State) (u : Nat) (v : Nat×Nat×Nat) (input : CrtPrimePrefix214.Input s u v) :
    Exec StepPrimeShape188.pSet (declS s) ⟨withP s v,.normal⟩ :=
  .level _ _ _ (.prime _ _ _ _ _ .uint32 none (.uint32 (pVal v)) rfl (p_read s u v input))

theorem i_source (s : State) (v : Nat×Nat×Nat) : Exec StepPrimeShape188.iSet (withP s v) ⟨withI s v,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign (withP s v) "p0i" none _ (iVal v) rfl
    (.call1 _ _ _ _ (ModularAtoms178.cell (withP s v) "p" (pVal v) (ModularAtoms178.slot (declS s) "p" (pVal v)))
      (.inverse _ _ (KeygenNinv31.source_exists (pVal v))))))

theorem r_source (s : State) (v : Nat×Nat×Nat) : Exec StepPrimeShape188.rSet (withI s v) ⟨afterP s v,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign (withI s v) "R2" none _ (rVal v) rfl
    (.call2 _ _ _ _ _ _ (ModularAtoms178.cell (withI s v) "p" (pVal v)
      ((SelectedStepAddPrime195.locals_keep (withP s v) "p0i".toList .uint32 (.uint32 (iVal v)) "p".toList (by decide)).trans
        (ModularAtoms178.slot (declS s) "p" (pVal v))))
      (ModularAtoms178.cell (withI s v) "p0i" (iVal v) (ModularAtoms178.slot (withP s v) "p0i" (iVal v)))
      (.r2 _ _ (KeygenModpR2Exec.source_exists (withI s v) (pVal v) (iVal v))))))

theorem appendP (s : State) (u : Nat) (v : Nat×Nat×Nat) (input : CrtPrimePrefix214.Input s u v)
    (tail : KeygenMakeFgSource.Stmt) (out : C99ProcedureReference.Result) (rest : Exec tail (afterP s v) out) :
    Exec (MakeFgSequence187.append StepPrimeShape188.prefixSteps tail) s out :=
  MakeFgSequence187.source StepPrimeShape188.declarations s (declS s) (StepPrimeDeclarations188.source s)
    (.seq StepPrimeShape188.pSet (.seq StepPrimeShape188.iSet (.seq StepPrimeShape188.rSet tail))) out
    (.seqNormal _ _ _ (withP s v) _ (p_source s u v input)
      (.seqNormal _ _ _ (withI s v) _ (i_source s v) (.seqNormal _ _ _ (afterP s v) _ (r_source s v) rest)))

theorem basicP (s : State) (u : Nat) (v : Nat×Nat×Nat) (o : Outer s u) :
    Basic (afterP s v) u (pVal v) (iVal v) (rVal v) := by
  refine ⟨(localsP _ _ _ (by decide)).trans o.nCell,(localsP _ _ _ (by decide)).trans o.hnCell,
    (localsP _ _ _ (by decide)).trans o.slenCell,(localsP _ _ _ (by decide)).trans o.tlenCell,
    (localsP _ _ _ (by decide)).trans o.uCell,p_cellP s v,i_cellP s v,r2_cellP s v,
    (localsP _ _ _ (by decide)).trans o.lognCell,(localsP _ _ _ (by decide)).trans o.terCell,
    (localsP _ _ _ (by decide)).trans o.inCell,(localsP _ _ _ (by decide)).trans o.outCell,
    (arraysP _ _ _ (by decide)).trans o.fdBinding,(arraysP _ _ _ (by decide)).trans o.gdBinding,
    (arraysP _ _ _ (by decide)).trans o.fsBinding,(arraysP _ _ _ (by decide)).trans o.gsBinding,
    (arraysP _ _ _ (by decide)).trans o.gmBinding,(arraysP _ _ _ (by decide)).trans o.igmBinding,
    (arraysP _ _ _ (by decide)).trans o.t1Binding,(arraysP _ _ _ (by decide)).trans o.primesBinding,?_,?_⟩
  · rw [heapP]; exact o.writable
  · intro index bound; rw [heapP]; exact o.allocated index bound

theorem inputP (s : State) (u : Nat) (v : Nat×Nat×Nat) (input : CrtPrimePrefix214.Input s u v) :
    CrtPrimePrefix214.Input (afterP s v) u v := by
  have uCell : (afterP s v).locals "u".toList=s.locals "u".toList :=
    localsP s v "u".toList (by decide)
  refine ⟨input.uBound,?_,input.rowValue,(arraysP s v "primes".toList (by decide)).trans input.primesBinding,
    by rw [heapP]; exact input.primeObject⟩
  exact uCell.trans input.uCell

/- One complete loop iteration at index u and row v: prefix, generator
   and the two-sided march/product/iNTT tail. -/
def tableWord (ivs : Fin 128 → BitVec 32) (j : Nat) := ivs ⟨j%128,Nat.mod_lt _ (by decide)⟩

theorem col_outside (n : Nat) (bound : n<2206) :
    MkgmCallKeep203.Outside gm (scratch n) ∧ MkgmCallKeep203.Outside igm (scratch n) := by
  constructor <;> intro byte <;> right <;> left
  · change 0+4*n+byte.val<0+4*2206; omega
  · change 0+4*n+byte.val<0+4*2334; omega

theorem inner_source (s : State) (u : Nat) (v : Nat×Nat×Nat) (F G : Nat → BitVec 32)
    (o : Outer s u) (input : CrtPrimePrefix214.Input s u v) (bound : u<3)
    (revB : s.tables "REV10".toList=some rev) (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (fData : ∀ j<128, Load32 s.heap (addr fs u j 3) (F j))
    (gData : ∀ j<128, Load32 s.heap (addr gs u j 3) (G j)) :
    ∃ (out : State) (ivs : Fin 128 → BitVec 32),
      Exec StepPrimeShape188.inner s ⟨out,.normal⟩ ∧
      Basic out u (pVal v) (iVal v) (rVal v) ∧
      Image out fd u 6 64 (pVal v) (iVal v) (rVal v) F 64 ∧
      Image out gd u 6 64 (pVal v) (iVal v) (rVal v) G 64 ∧
      (∀ j<128, Load32 out.heap (addr fs u j 3) (scaledWord 6 F (tableWord ivs) (pVal v) (iVal v) j)) ∧
      (∀ j<128, Load32 out.heap (addr gs u j 3) (scaledWord 6 G (tableWord ivs) (pVal v) (iVal v) j)) ∧
      (∀ q : ArrayPointer,
        (∀ i : Fin 128, Separate (elem t1 i.val) q) →
        (∀ i : Fin 64, Separate (addr fd u i.val 6) q) →
        (∀ i : Fin 64, Separate (addr gd u i.val 6) q) →
        (∀ j<128, Separate (addr fs u j 3) q) →
        (∀ j<128, Separate (addr gs u j 3) q) →
        MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨generated,gvs,ivs,genRun,genBasic,gLocals,gArrays,gRead,iRead,genKeep⟩ :=
    ThirdStepGenerator215.generator (afterP s v) u v (pVal v) (iVal v) (rVal v)
      (basicP s u v o) (inputP s u v input) revB (by rw [heapP]; exact revS)
  have vNone : generated.locals "v".toList=some (.uint64,none) := (congrFun gLocals "v".toList).trans (v_declP s v)
  have twLoads : ∀ k<128, Load32 generated.heap (elem igm k) (tableWord ivs k) := by
    intro k bound'
    simpa only [tableWord,Nat.mod_eq_of_lt bound',KeygenSmallOutput.element,StepCopyBody190.elem] using iRead ⟨k,bound'⟩
  have fReady : ∀ j<128, Load32 generated.heap (addr fs u j 3) (F j) := by
    intro j slot
    have outside := col_outside (1438+u+j*3) (by have h:=copy_bounds .f u j bound slot; omega)
    show Load32 generated.heap (scratch (1438+u+j*3)) (F j)
    exact genKeep _ outside.1 outside.2 _ (fData j slot)
  have gReady : ∀ j<128, Load32 generated.heap (addr gs u j 3) (G j) := by
    intro j slot
    have outside := col_outside (1822+u+j*3) (by have h:=copy_bounds .g u j bound slot; omega)
    show Load32 generated.heap (scratch (1822+u+j*3)) (G j)
    exact genKeep _ outside.1 outside.2 _ (gData j slot)
  obtain ⟨out,pairRun,pairBasic,pairV,fProduct,gProduct,fScaled,gScaled,twFinal,pairKeep⟩ :=
    sourcePair generated u (pVal v) (iVal v) (rVal v) genBasic bound (tableWord ivs) F G twLoads fReady gReady none vNone
  have inner : Exec StepPrimeShape188.inner s ⟨out,.normal⟩ := by
    rw [StepPrimeShape188.prefix_shape]
    exact appendP s u v input _ _
      (by rw [StepPrimeShape188.remaining_shape]
          exact .seqNormal _ _ _ generated _ genRun pairRun)
  exact ⟨out,ivs,inner,pairBasic,fProduct,gProduct,fScaled,gScaled,fun q tSep fdSep gdSep fsSep gsSep gmO igmO w loaded =>
    pairKeep q tSep fdSep gdSep fsSep gsSep w (genKeep q gmO igmO w loaded)⟩

/- Loop states: the u = 0 initializer, the scope-restored iteration
   states and their u counters. -/
def init0 (s : State) := bindValue s "u".toList .uint64 (.uint64 0)
def bodyState (before out : State) := restoreScope before out StepPrimeShape188.localNames StepPrimeShape188.pointerNames
def counter (before out : State) (k : Nat) := FftLocalCells140.put (bodyState before out) "u".toList (C99NatWord141.word k)

theorem init0_heap (s : State) : (init0 s).heap=s.heap := rfl

theorem init_source (s : State) (uDeclared : s.locals "u".toList=some (.uint64,none)) :
    Exec StepPrimeShape188.initial s ⟨init0 s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 none (.int32 0) uDeclared (.scalar _ _ (.literal .int32 0))))

theorem scope_source (s out : State) (run : Exec StepPrimeShape188.inner s ⟨out,.normal⟩) :
    Exec StepPrimeShape188.body s ⟨bodyState s out,.normal⟩ := by
  rw [StepPrimeShape188.body_shape]
  exact .scope _ _ _ s ⟨out,.normal⟩ run

theorem scope_locals (before out : State) (name : Name) (absent : name∉StepPrimeShape188.localNames) :
    (bodyState before out).locals name=out.locals name := by
  simp only [bodyState,restoreScope,C99ScalarReference.restore,List.contains_iff_mem,absent,ite_false]

theorem incrementK (before out : State) (k : Nat) (kb : k<3) (u : Cell out "u".toList k) :
    Exec StepPrimeShape188.increment (bodyState before out) ⟨counter before out (k+1),.normal⟩ := by
  have cell : Cell (bodyState before out) "u".toList k := (scope_locals before out "u".toList (by decide)).trans u
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (MakeFgTailShape190.num 1))) (bodyState before out) (counter before out (k+1)) := by
    cases C99LoopScalar141.increment (fun _ => none) (bodyState before out) "u".toList k (by omega) cell with
    | base _ _ _ source => exact source
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem counter_u (before out : State) (k : Nat) : Cell (counter before out k) "u".toList k :=
  FftLocalCells140.cell_at _ _ _

theorem counter_slen (before out : State) (k : Nat) (slen : Cell out "slen".toList 3) :
    Cell (counter before out k) "slen".toList 3 :=
  (FftLocalCells140.outside (bodyState before out) "u".toList "slen".toList _ (by decide)).trans
    ((scope_locals before out "slen".toList (by decide)).trans slen)

theorem guard_init0 (s : State) (slen : Cell (init0 s) "slen".toList 3) :
    C99ArrayReference.scalar (init0 s) StepPrimeShape188.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ rfl) (.variable _ _ _ slen)
    (.step .lt (.uint64 0) (.uint64 3) .uint64 rfl (.uint64 0) (.uint64 3) rfl rfl)

theorem guard1 (before out : State) (slen : Cell out "slen".toList 3) :
    C99ArrayReference.scalar (counter before out 1) StepPrimeShape188.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (counter_u before out 1)) (.variable _ _ _ (counter_slen before out 1 slen))
    (.step .lt (.uint64 1) (.uint64 3) .uint64 rfl (.uint64 1) (.uint64 3) rfl rfl)

theorem guard2 (before out : State) (slen : Cell out "slen".toList 3) :
    C99ArrayReference.scalar (counter before out 2) StepPrimeShape188.condition (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (counter_u before out 2)) (.variable _ _ _ (counter_slen before out 2 slen))
    (.step .lt (.uint64 2) (.uint64 3) .uint64 rfl (.uint64 2) (.uint64 3) rfl rfl)

theorem guard3 (before out : State) (slen : Cell out "slen".toList 3) :
    C99ArrayReference.scalar (counter before out 3) StepPrimeShape188.condition (.int32 0) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (counter_u before out 3)) (.variable _ _ _ (counter_slen before out 3 slen))
    (.step .lt (.uint64 3) (.uint64 3) .uint64 rfl (.uint64 3) (.uint64 3) rfl rfl)



/- Preservation glue: earlier columns survive later iterations. -/
def Keep (s out : State) (u : Nat) : Prop :=
  ∀ q : ArrayPointer,
    (∀ i : Fin 128, Separate (elem t1 i.val) q) →
    (∀ i : Fin 64, Separate (addr fd u i.val 6) q) →
    (∀ i : Fin 64, Separate (addr gd u i.val 6) q) →
    (∀ j<128, Separate (addr fs u j 3) q) →
    (∀ j<128, Separate (addr gs u j 3) q) →
    MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
    ∀ w, Load32 s.heap q w → Load32 out.heap q w

theorem diff_copy (side : Side) (u v j k : Nat) (hne : u≠v) (ub : u<3) (vb : v<3) :
    Separate (addr (croot side) u j 3) (addr (croot side) v k 3) := by
  rw [copy_shape,copy_shape]
  by_cases h : (croot side).index+u+j*3 < (croot side).index+v+k*3
  · exact ordered _ _ h
  · exact StepCopyFixed190.separate_symm (ordered _ _ (by omega))

theorem diff_prod (side : Side) (u v j k : Nat) (hne : u≠v) (ub : u<3) (vb : v<3) :
    Separate (addr (root side) u j 6) (addr (root side) v k 6) := by
  rw [product_shape,product_shape]
  by_cases h : (root side).index+u+j*6 < (root side).index+v+k*6
  · exact ordered _ _ h
  · exact StepCopyFixed190.separate_symm (ordered _ _ (by omega))

theorem keep_fd {s out : State} {m k i : Nat} (keep : Keep s out m) (hne : k≠m) (mb : m<3) (kb : k<3)
    (slot : i<64) (w : BitVec 32) (read : Load32 s.heap (addr fd k i 6) w) :
    Load32 out.heap (addr fd k i 6) w :=
  keep (addr fd k i 6)
    (fun j => StepCopyFixed190.separate_symm (product_t1 .f k i j.val kb slot j.isLt))
    (fun j => diff_prod .f m k j.val i (by omega) mb kb)
    (fun j => StepCopyFixed190.separate_symm (product_cross k m i j.val kb mb slot j.isLt))
    (fun j _ => StepCopyFixed190.separate_symm (product_data .f .f k i m j kb slot))
    (fun j _ => StepCopyFixed190.separate_symm (product_data .f .g k i m j kb slot))
    (col_outside (670+k+i*6) (by omega)).1 (col_outside (670+k+i*6) (by omega)).2 w read

theorem keep_gd {s out : State} {m k i : Nat} (keep : Keep s out m) (hne : k≠m) (mb : m<3) (kb : k<3)
    (slot : i<64) (w : BitVec 32) (read : Load32 s.heap (addr gd k i 6) w) :
    Load32 out.heap (addr gd k i 6) w :=
  keep (addr gd k i 6)
    (fun j => StepCopyFixed190.separate_symm (product_t1 .g k i j.val kb slot j.isLt))
    (fun j => product_cross m k j.val i mb kb j.isLt slot)
    (fun j => diff_prod .g m k j.val i (by omega) mb kb)
    (fun j _ => StepCopyFixed190.separate_symm (product_data .g .f k i m j kb slot))
    (fun j _ => StepCopyFixed190.separate_symm (product_data .g .g k i m j kb slot))
    (col_outside (1054+k+i*6) (by omega)).1 (col_outside (1054+k+i*6) (by omega)).2 w read

theorem keep_fs {s out : State} {m k j : Nat} (keep : Keep s out m) (hne : k≠m) (mb : m<3) (kb : k<3)
    (slot : j<128) (w : BitVec 32) (read : Load32 s.heap (addr fs k j 3) w) :
    Load32 out.heap (addr fs k j 3) w :=
  keep (addr fs k j 3)
    (fun i => copy_data .f k j kb slot i)
    (fun i => product_data .f .f m i.val k j mb i.isLt)
    (fun i => product_data .g .f m i.val k j mb i.isLt)
    (fun i _ => diff_copy .f m k i j (by omega) mb kb)
    (fun i _ => StepCopyFixed190.separate_symm (fs_gs k j m i kb slot))
    (col_outside (1438+k+j*3) (by omega)).1 (col_outside (1438+k+j*3) (by omega)).2 w read

theorem keep_gs {s out : State} {m k j : Nat} (keep : Keep s out m) (hne : k≠m) (mb : m<3) (kb : k<3)
    (slot : j<128) (w : BitVec 32) (read : Load32 s.heap (addr gs k j 3) w) :
    Load32 out.heap (addr gs k j 3) w :=
  keep (addr gs k j 3)
    (fun i => copy_data .g k j kb slot i)
    (fun i => product_data .f .g m i.val k j mb i.isLt)
    (fun i => product_data .g .g m i.val k j mb i.isLt)
    (fun i b => fs_gs m i k j mb b)
    (fun i _ => diff_copy .g m k i j (by omega) mb kb)
    (col_outside (1822+k+j*3) (by omega)).1 (col_outside (1822+k+j*3) (by omega)).2 w read

/- Readonly-block transports across any executed statement. -/
theorem object_keep {s out : State} {code : KeygenMakeFgSource.Stmt}
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary) (run : Exec code s ⟨out,.normal⟩) :
    KeygenStaticTables.PrimeObject out.heap primes .ternary := by
  have stable:=KeygenHelperStability.make _ _ _ run
  have block : KeygenMakeObjects.Block s.heap out.heap primes.block :=
    ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset object.2.2.2.1⟩
  exact KeygenMakeEntry.prime_block _ _ primes block object

theorem rev_keep {s out : State} {code : KeygenMakeFgSource.Stmt}
    (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev) (run : Exec code s ⟨out,.normal⟩) :
    KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  have stable:=KeygenHelperStability.make _ _ _ run
  have block : KeygenMakeObjects.Block s.heap out.heap rev.block :=
    ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset revS.1⟩
  exact KeygenMakeEntry.rev_block _ _ rev block revS

theorem revB_keep {s out : State} {code : KeygenMakeFgSource.Stmt}
    (revB : s.tables "REV10".toList=some rev) (run : Exec code s ⟨out,.normal⟩) :
    out.tables "REV10".toList=some rev :=
  (congrFun (KeygenTables204.make _ _ _ run) "REV10".toList).trans revB

/- Outer reconstruction at the counter state after one iteration. -/
theorem scope_arrays (before out : State) (name : Name) (absent : name∉StepPrimeShape188.pointerNames) :
    (bodyState before out).arrays name=out.arrays name := by
  change (if StepPrimeShape188.pointerNames.contains name then before.arrays name else out.arrays name)=out.arrays name
  simp only [List.contains_iff_mem,absent,ite_false]

theorem counter_arrays (before out : State) (k : Nat) (name : Name) :
    (counter before out k).arrays name=(bodyState before out).arrays name := rfl

theorem counter_heap (before out : State) (k : Nat) : (counter before out k).heap=out.heap := rfl

theorem outer_counter {out : State} {u : Nat} {p pp rr : BitVec 32} (b : Basic out u p pp rr)
    (before : State) (k : Nat) : Outer (counter before out k) k := by
  have loc (name : Name) (notU : name≠"u".toList) (absent : name∉StepPrimeShape188.localNames) :
      (counter before out k).locals name=out.locals name :=
    (FftLocalCells140.outside (bodyState before out) "u".toList name (C99NatWord141.word k) notU).trans
      (scope_locals before out name absent)
  have arr (name : Name) (absent : name∉StepPrimeShape188.pointerNames) :
      (counter before out k).arrays name=out.arrays name :=
    (counter_arrays before out k name).trans (scope_arrays before out name absent)
  refine ⟨(loc _ (by decide) (by decide)).trans b.nCell,(loc _ (by decide) (by decide)).trans b.hnCell,
    (loc _ (by decide) (by decide)).trans b.slenCell,(loc _ (by decide) (by decide)).trans b.tlenCell,
    FftLocalCells140.cell_at _ _ _,(loc _ (by decide) (by decide)).trans b.lognCell,
    (loc _ (by decide) (by decide)).trans b.terCell,
    (loc _ (by decide) (by decide)).trans b.inCell,(loc _ (by decide) (by decide)).trans b.outCell,
    (arr _ (by decide)).trans b.fdBinding,(arr _ (by decide)).trans b.gdBinding,
    (arr _ (by decide)).trans b.fsBinding,(arr _ (by decide)).trans b.gsBinding,
    (arr _ (by decide)).trans b.gmBinding,(arr _ (by decide)).trans b.igmBinding,
    (arr _ (by decide)).trans b.t1Binding,(arr _ (by decide)).trans b.primesBinding,?_,?_⟩
  · rw [counter_heap]; exact b.writable
  · intro index bound; rw [counter_heap]; exact b.allocated index bound

theorem input_counter {out : State} {u : Nat} {p pp rr : BitVec 32} (b : Basic out u p pp rr)
    (before : State) (k : Nat) (kb : k<3) (v : Nat×Nat×Nat) (rowV : (values .ternary)[k]?=some v)
    (object : KeygenStaticTables.PrimeObject out.heap primes .ternary) :
    CrtPrimePrefix214.Input (counter before out k) k v :=
  ⟨by omega,FftLocalCells140.cell_at _ _ _,rowV,
    ((counter_arrays before out k "primes".toList).trans
      ((scope_arrays before out "primes".toList (by decide)).trans b.primesBinding)),
    by rw [counter_heap]; exact object⟩

/- The three executed PRIMES3 rows of the first loop. -/
def v0 : Nat×Nat×Nat := (2147355649,1907584673,127999)
def v1 : Nat×Nat×Nat := (2147346433,1119654270,238827065)
def v2 : Nat×Nat×Nat := (2147309569,686923925,434763914)

theorem rowV0 : (values .ternary)[0]?=some v0 := ThirdStepGenerator215.row0_value
theorem rowV1 : (values .ternary)[1]?=some v1 := ThirdStepGenerator215.row1_value
theorem rowV2 : (values .ternary)[2]?=some v2 := ThirdStepGenerator215.row2_value

/- Column word families of the moved rows and their iNTT images. -/
def colF (W : Nat → BitVec 32) (k : Nat) : Nat → BitVec 32 := fun j => W (k+j*3)
def colG (W : Nat → BitVec 32) (k : Nat) : Nat → BitVec 32 := colF W k
def sWord (W : Nat → BitVec 32) (k : Nat) (ivs : Fin 128 → BitVec 32) (v : Nat×Nat×Nat) : Nat → BitVec 32 :=
  fun j => scaledWord 6 (colF W k) (tableWord ivs) (pVal v) (iVal v) j

theorem col_read (s : State) (W : Nat → BitVec 32) (k j : Nat)
    (image : ZintNormWalkFlat208.Data s fs 384 W) (bound : k+j*3<384) :
    Load32 s.heap (addr fs k j 3) (colF W k j) := by
  have read := image (k+j*3) bound
  have eq : addr fs k j 3=elem fs (k+j*3) :=
    congrArg (fun n : Nat => (⟨fs.block,fs.base,fs.count,fs.elementBytes,n⟩ : ArrayPointer))
      (show fs.index+k+j*3=fs.index+(k+j*3) by omega)
  rw [eq]
  exact read

theorem col_read_g (s : State) (W : Nat → BitVec 32) (k j : Nat)
    (image : ZintNormWalkFlat208.Data s gs 384 W) (bound : k+j*3<384) :
    Load32 s.heap (addr gs k j 3) (colG W k j) := by
  have read := image (k+j*3) bound
  have eq : addr gs k j 3=elem gs (k+j*3) :=
    congrArg (fun n : Nat => (⟨gs.block,gs.base,gs.count,gs.elementBytes,n⟩ : ArrayPointer))
      (show gs.index+k+j*3=gs.index+(k+j*3) by omega)
  rw [eq]
  exact read

theorem init0_u (s : State) : CrtState205.Slot64 (init0 s) "u" (C99NatWord141.word 0) := rfl

/- The complete first slen = 3 loop from the u = 0 initializer: three
   counted iterations over the PRIMES3 rows 0..2 and the false terminal
   guard, with all six product columns, the six iNTT column visits, the
   flat moved-row images and the readonly table facts at the exit. -/
theorem body_run (s : State) (Wf Wg : Nat → BitVec 32)
    (uDeclared : s.locals "u".toList=some (.uint64,none))
    (o : Outer (init0 s) 0)
    (object : KeygenStaticTables.PrimeObject (init0 s).heap primes .ternary)
    (revB : (init0 s).tables "REV10".toList=some rev)
    (revS : KeygenMkgm3RevMemory.SourceTable (init0 s).heap rev)
    (fImage : ZintNormWalkFlat208.Data (init0 s) fs 384 Wf)
    (gImage : ZintNormWalkFlat208.Data (init0 s) gs 384 Wg) :
    ∃ (out : State) (ivs0 ivs1 ivs2 : Fin 128 → BitVec 32),
      Exec (KeygenMakeFgSource.part .step 2) s ⟨out,.normal⟩ ∧
      Outer out 3 ∧
      Image out fd 0 6 64 (pVal v0) (iVal v0) (rVal v0) (colF Wf 0) 64 ∧
      Image out fd 1 6 64 (pVal v1) (iVal v1) (rVal v1) (colF Wf 1) 64 ∧
      Image out fd 2 6 64 (pVal v2) (iVal v2) (rVal v2) (colF Wf 2) 64 ∧
      Image out gd 0 6 64 (pVal v0) (iVal v0) (rVal v0) (colG Wg 0) 64 ∧
      Image out gd 1 6 64 (pVal v1) (iVal v1) (rVal v1) (colG Wg 1) 64 ∧
      Image out gd 2 6 64 (pVal v2) (iVal v2) (rVal v2) (colG Wg 2) 64 ∧
      (∀ j<128, Load32 out.heap (addr fs 0 j 3) (sWord Wf 0 ivs0 v0 j)) ∧
      (∀ j<128, Load32 out.heap (addr fs 1 j 3) (sWord Wf 1 ivs1 v1 j)) ∧
      (∀ j<128, Load32 out.heap (addr fs 2 j 3) (sWord Wf 2 ivs2 v2 j)) ∧
      (∀ j<128, Load32 out.heap (addr gs 0 j 3) (sWord Wg 0 ivs0 v0 j)) ∧
      (∀ j<128, Load32 out.heap (addr gs 1 j 3) (sWord Wg 1 ivs1 v1 j)) ∧
      (∀ j<128, Load32 out.heap (addr gs 2 j 3) (sWord Wg 2 ivs2 v2 j)) ∧
      ZintNormWalkFlat208.Data out fs 384
        (SecondStepImage212.interleave (sWord Wf 0 ivs0 v0) (sWord Wf 1 ivs1 v1) (sWord Wf 2 ivs2 v2)) ∧
      ZintNormWalkFlat208.Data out gs 384
        (SecondStepImage212.interleave (sWord Wg 0 ivs0 v0) (sWord Wg 1 ivs1 v1) (sWord Wg 2 ivs2 v2)) ∧
      KeygenStaticTables.PrimeObject out.heap primes .ternary ∧
      out.tables "REV10".toList=some rev ∧
      KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  have input0 : CrtPrimePrefix214.Input (init0 s) 0 v0 :=
    ⟨by omega,init0_u s,rowV0,o.primesBinding,object⟩
  have fData0 : ∀ j<128, Load32 (init0 s).heap (addr fs 0 j 3) (colF Wf 0 j) :=
    fun j slot => col_read (init0 s) Wf 0 j fImage (by omega)
  have gData0 : ∀ j<128, Load32 (init0 s).heap (addr gs 0 j 3) (colG Wg 0 j) :=
    fun j slot => col_read_g (init0 s) Wg 0 j gImage (by omega)
  obtain ⟨out0,ivs0,run0,basic0,fd0,gd0,fs0,gs0,keep0⟩ :=
    inner_source (init0 s) 0 v0 (colF Wf 0) (colG Wg 0) o input0 (by decide) revB revS fData0 gData0
  have object0 := object_keep (s:=init0 s) object run0
  have revB0 := revB_keep (s:=init0 s) revB run0
  have revS0 := rev_keep (s:=init0 s) revS run0
  let s1 := counter (init0 s) out0 1
  have o1 : Outer s1 1 := outer_counter basic0 (init0 s) 1
  have input1 : CrtPrimePrefix214.Input s1 1 v1 := input_counter basic0 (init0 s) 1 (by decide) v1 rowV1 object0
  have fData1 : ∀ j<128, Load32 s1.heap (addr fs 1 j 3) (colF Wf 1 j) := by
    intro j slot
    rw [counter_heap]
    exact keep_fs keep0 (by omega) (by omega) (by omega) slot _ (col_read (init0 s) Wf 1 j fImage (by omega))
  have gData1 : ∀ j<128, Load32 s1.heap (addr gs 1 j 3) (colG Wg 1 j) := by
    intro j slot
    rw [counter_heap]
    exact keep_gs keep0 (by omega) (by omega) (by omega) slot _ (col_read_g (init0 s) Wg 1 j gImage (by omega))
  obtain ⟨out1,ivs1,run1,basic1,fd1,gd1,fs1,gs1,keep1⟩ :=
    inner_source s1 1 v1 (colF Wf 1) (colG Wg 1) o1 input1 (by decide) revB0 revS0 fData1 gData1
  have object1 := object_keep (s:=s1) object0 run1
  have revB1 := revB_keep (s:=s1) revB0 run1
  have revS1 := rev_keep (s:=s1) revS0 run1
  let s2 := counter s1 out1 2
  have o2 : Outer s2 2 := outer_counter basic1 s1 2
  have input2 : CrtPrimePrefix214.Input s2 2 v2 := input_counter basic1 s1 2 (by decide) v2 rowV2 object1
  have fData2 : ∀ j<128, Load32 s2.heap (addr fs 2 j 3) (colF Wf 2 j) := by
    intro j slot
    rw [counter_heap]
    exact keep_fs keep1 (by omega) (by omega) (by omega) slot _
      (keep_fs keep0 (by omega) (by omega) (by omega) slot _
        (col_read (init0 s) Wf 2 j fImage (by omega)))
  have gData2 : ∀ j<128, Load32 s2.heap (addr gs 2 j 3) (colG Wg 2 j) := by
    intro j slot
    rw [counter_heap]
    exact keep_gs keep1 (by omega) (by omega) (by omega) slot _
      (keep_gs keep0 (by omega) (by omega) (by omega) slot _
        (col_read_g (init0 s) Wg 2 j gImage (by omega)))
  obtain ⟨out2,ivs2,run2,basic2,fd2,gd2,fs2,gs2,keep2⟩ :=
    inner_source s2 2 v2 (colF Wf 2) (colG Wg 2) o2 input2 (by decide) revB1 revS1 fData2 gData2
  have object2 := object_keep (s:=s2) object1 run2
  have revB2 := revB_keep (s:=s2) revB1 run2
  have revS2 := rev_keep (s:=s2) revS1 run2
  let out := counter s2 out2 3
  have scope0 := scope_source (init0 s) out0 run0
  have update0 := incrementK (init0 s) out0 0 (by decide) basic0.uCell
  have scope1 := scope_source s1 out1 run1
  have update1 := incrementK s1 out1 1 (by decide) basic1.uCell
  have scope2 := scope_source s2 out2 run2
  have update2 := incrementK s2 out2 2 (by decide) basic2.uCell
  have loopEnd : Exec StepPrimeShape188.loop out ⟨out,.normal⟩ :=
    .loopFalse _ _ _ _ (.int32 0) (guard3 s2 out2 basic2.slenCell) rfl
  have loop2 : Exec StepPrimeShape188.loop s2 ⟨out,.normal⟩ :=
    .loopNormal _ _ _ s2 (bodyState s2 out2) out _ (.int32 1) (guard2 s1 out1 basic1.slenCell) (by decide)
      scope2 update2 loopEnd
  have loop1 : Exec StepPrimeShape188.loop s1 ⟨out,.normal⟩ :=
    .loopNormal _ _ _ s1 (bodyState s1 out1) s2 _ (.int32 1) (guard1 (init0 s) out0 basic0.slenCell) (by decide)
      scope1 update1 loop2
  have loop0 : Exec StepPrimeShape188.loop (init0 s) ⟨out,.normal⟩ :=
    .loopNormal _ _ _ (init0 s) (bodyState (init0 s) out0) s1 _ (.int32 1) (guard_init0 s o.slenCell) (by decide)
      scope0 update0 loop1
  have part2run : Exec (KeygenMakeFgSource.part .step 2) s ⟨out,.normal⟩ := by
    rw [StepPrimeShape188.loop_shape]
    exact .seqNormal _ _ _ out _
      (.seqNormal _ _ _ (init0 s) _ (init_source s uDeclared) loop0) (SelectedStepAddPrime195.skip_run out)
  refine ⟨out,ivs0,ivs1,ivs2,part2run,outer_counter basic2 s2 3,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · intro i bound'; rw [counter_heap]; exact keep_fd keep2 (by omega) (by omega) (by omega) i.isLt _
      (keep_fd keep1 (by omega) (by omega) (by omega) i.isLt _ (fd0 i bound'))
  · intro i bound'; rw [counter_heap]; exact keep_fd keep2 (by omega) (by omega) (by omega) i.isLt _ (fd1 i bound')
  · intro i bound'; rw [counter_heap]; exact fd2 i bound'
  · intro i bound'; rw [counter_heap]; exact keep_gd keep2 (by omega) (by omega) (by omega) i.isLt _
      (keep_gd keep1 (by omega) (by omega) (by omega) i.isLt _ (gd0 i bound'))
  · intro i bound'; rw [counter_heap]; exact keep_gd keep2 (by omega) (by omega) (by omega) i.isLt _ (gd1 i bound')
  · intro i bound'; rw [counter_heap]; exact gd2 i bound'
  · intro j bound'; rw [counter_heap]; exact keep_fs keep2 (by omega) (by omega) (by omega) bound' _
      (keep_fs keep1 (by omega) (by omega) (by omega) bound' _ (fs0 j bound'))
  · intro j bound'; rw [counter_heap]; exact keep_fs keep2 (by omega) (by omega) (by omega) bound' _ (fs1 j bound')
  · intro j bound'; rw [counter_heap]; exact fs2 j bound'
  · intro j bound'; rw [counter_heap]; exact keep_gs keep2 (by omega) (by omega) (by omega) bound' _
      (keep_gs keep1 (by omega) (by omega) (by omega) bound' _ (gs0 j bound'))
  · intro j bound'; rw [counter_heap]; exact keep_gs keep2 (by omega) (by omega) (by omega) bound' _ (gs1 j bound')
  · intro j bound'; rw [counter_heap]; exact gs2 j bound'
  · intro i bound
    dsimp only [SecondStepImage212.interleave]
    split_ifs with h0 h1
    · rw [SecondStepImage212.pointer fs i 0 h0]
      exact keep_fs keep2 (by omega) (by omega) (by omega) (by omega) _
        (keep_fs keep1 (by omega) (by omega) (by omega) (by omega) _ (fs0 (i/3) (by omega)))
    · rw [SecondStepImage212.pointer fs i 1 h1]
      exact keep_fs keep2 (by omega) (by omega) (by omega) (by omega) _ (fs1 (i/3) (by omega))
    · have two : i%3=2 := by have mb:=Nat.mod_lt i (by decide : 0<3); omega
      rw [SecondStepImage212.pointer fs i 2 two]
      exact fs2 (i/3) (by omega)
  · intro i bound
    dsimp only [SecondStepImage212.interleave]
    split_ifs with h0 h1
    · rw [SecondStepImage212.pointer gs i 0 h0]
      exact keep_gs keep2 (by omega) (by omega) (by omega) (by omega) _
        (keep_gs keep1 (by omega) (by omega) (by omega) (by omega) _ (gs0 (i/3) (by omega)))
    · rw [SecondStepImage212.pointer gs i 1 h1]
      exact keep_gs keep2 (by omega) (by omega) (by omega) (by omega) _ (gs1 (i/3) (by omega))
    · have two : i%3=2 := by have mb:=Nat.mod_lt i (by decide : 0<3); omega
      rw [SecondStepImage212.pointer gs i 2 two]
      exact gs2 (i/3) (by omega)
  · rw [counter_heap]; exact object2
  · exact revB2
  · rw [counter_heap]; exact revS2

end FT1536.Source3.ThirdStepLoop215
