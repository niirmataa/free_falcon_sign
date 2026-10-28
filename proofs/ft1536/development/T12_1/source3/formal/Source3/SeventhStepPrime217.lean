import Source3.SeventhStepGenerator217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual first-prime prefix at the d=7 layout, generic in the row. -/
namespace FT1536.Source3.SeventhStepPrime217
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
open SeventhStepLayout217 (fd gd fs gs gm igm t1)
open SeventhStepGenerator217 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)

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


end FT1536.Source3.SeventhStepPrime217
