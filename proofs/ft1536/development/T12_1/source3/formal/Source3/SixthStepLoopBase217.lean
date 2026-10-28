import Source3.SixthStepInner217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Shared source control and separation facts for the d=6 first-prime loop. -/
namespace FT1536.Source3.SixthStepLoopBase217
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
open SixthStepLayout217 (fd gd fs gs gm igm t1)
open SixthStepGenerator217 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open SixthStepProduct217 (root)
open SixthStepMarch217
open SixthStepInner217

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

theorem incrementK (before out : State) (k : Nat) (kb : k<22) (u : Cell out "u".toList k) :
    Exec StepPrimeShape188.increment (bodyState before out) ⟨counter before out (k+1),.normal⟩ := by
  have cell : Cell (bodyState before out) "u".toList k := (scope_locals before out "u".toList (by decide)).trans u
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (MakeFgTailShape190.num 1))) (bodyState before out) (counter before out (k+1)) := by
    cases C99LoopScalar141.increment (fun _ => none) (bodyState before out) "u".toList k (by omega) cell with
    | base _ _ _ source => exact source
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem counter_u (before out : State) (k : Nat) : Cell (counter before out k) "u".toList k :=
  FftLocalCells140.cell_at _ _ _

theorem counter_slen (before out : State) (k : Nat) (slen : Cell out "slen".toList 22) :
    Cell (counter before out k) "slen".toList 22 :=
  (FftLocalCells140.outside (bodyState before out) "u".toList "slen".toList _ (by decide)).trans
    ((scope_locals before out "slen".toList (by decide)).trans slen)

def Keep (s out : State) (u : Nat) : Prop :=
  ∀ q : ArrayPointer,
    (∀ i : Fin 16, Separate (elem t1 i.val) q) →
    (∀ i : Fin 8, Separate (addr fd u i.val 42) q) →
    (∀ i : Fin 8, Separate (addr gd u i.val 42) q) →
    (∀ j<16, Separate (addr fs u j 22) q) →
    (∀ j<16, Separate (addr gs u j 22) q) →
    MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
    ∀ w, Load32 s.heap q w → Load32 out.heap q w

theorem diff_copy (side : Side) (u v j k : Nat) (hne : u≠v) (ub : u<22) (vb : v<22) :
    Separate (addr (croot side) u j 22) (addr (croot side) v k 22) := by
  rw [copy_shape,copy_shape]
  by_cases h : (croot side).index+u+j*22 < (croot side).index+v+k*22
  · exact ordered _ _ h
  · exact StepCopyFixed190.separate_symm (ordered _ _ (by omega))

theorem diff_prod (side : Side) (u v j k : Nat) (hne : u≠v) (ub : u<22) (vb : v<22) :
    Separate (addr (root side) u j 42) (addr (root side) v k 42) := by
  rw [product_shape,product_shape]
  by_cases h : (root side).index+u+j*42 < (root side).index+v+k*42
  · exact ordered _ _ h
  · exact StepCopyFixed190.separate_symm (ordered _ _ (by omega))

theorem keep_fd {s out : State} {m k i : Nat} (keep : Keep s out m) (hne : k≠m) (mb : m<22) (kb : k<22)
    (slot : i<8) (w : BitVec 32) (read : Load32 s.heap (addr fd k i 42) w) :
    Load32 out.heap (addr fd k i 42) w :=
  keep (addr fd k i 42)
    (fun j => StepCopyFixed190.separate_symm (product_t1 .f k i j.val kb slot j.isLt))
    (fun j => diff_prod .f m k j.val i (by omega) mb kb)
    (fun j => StepCopyFixed190.separate_symm (product_cross k m i j.val kb mb slot j.isLt))
    (fun j _ => StepCopyFixed190.separate_symm (product_data .f .f k i m j kb slot))
    (fun j _ => StepCopyFixed190.separate_symm (product_data .f .g k i m j kb slot))
    (col_outside (670+k+i*42) (by omega)).1 (col_outside (670+k+i*42) (by omega)).2 w read

theorem keep_gd {s out : State} {m k i : Nat} (keep : Keep s out m) (hne : k≠m) (mb : m<22) (kb : k<22)
    (slot : i<8) (w : BitVec 32) (read : Load32 s.heap (addr gd k i 42) w) :
    Load32 out.heap (addr gd k i 42) w :=
  keep (addr gd k i 42)
    (fun j => StepCopyFixed190.separate_symm (product_t1 .g k i j.val kb slot j.isLt))
    (fun j => product_cross m k j.val i mb kb j.isLt slot)
    (fun j => diff_prod .g m k j.val i (by omega) mb kb)
    (fun j _ => StepCopyFixed190.separate_symm (product_data .g .f k i m j kb slot))
    (fun j _ => StepCopyFixed190.separate_symm (product_data .g .g k i m j kb slot))
    (col_outside (1006+k+i*42) (by omega)).1 (col_outside (1006+k+i*42) (by omega)).2 w read

theorem keep_fs {s out : State} {m k j : Nat} (keep : Keep s out m) (hne : k≠m) (mb : m<22) (kb : k<22)
    (slot : j<16) (w : BitVec 32) (read : Load32 s.heap (addr fs k j 22) w) :
    Load32 out.heap (addr fs k j 22) w :=
  keep (addr fs k j 22)
    (fun i => copy_data .f k j kb slot i)
    (fun i => product_data .f .f m i.val k j mb i.isLt)
    (fun i => product_data .g .f m i.val k j mb i.isLt)
    (fun i _ => diff_copy .f m k i j (by omega) mb kb)
    (fun i _ => StepCopyFixed190.separate_symm (fs_gs k j m i kb slot))
    (col_outside (1342+k+j*22) (by omega)).1 (col_outside (1342+k+j*22) (by omega)).2 w read

theorem keep_gs {s out : State} {m k j : Nat} (keep : Keep s out m) (hne : k≠m) (mb : m<22) (kb : k<22)
    (slot : j<16) (w : BitVec 32) (read : Load32 s.heap (addr gs k j 22) w) :
    Load32 out.heap (addr gs k j 22) w :=
  keep (addr gs k j 22)
    (fun i => copy_data .g k j kb slot i)
    (fun i => product_data .f .g m i.val k j mb i.isLt)
    (fun i => product_data .g .g m i.val k j mb i.isLt)
    (fun i b => fs_gs m i k j mb b)
    (fun i _ => diff_copy .g m k i j (by omega) mb kb)
    (col_outside (1694+k+j*22) (by omega)).1 (col_outside (1694+k+j*22) (by omega)).2 w read

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
    (before : State) (k : Nat) (kb : k<22) (v : Nat×Nat×Nat) (rowV : (values .ternary)[k]?=some v)
    (object : KeygenStaticTables.PrimeObject out.heap primes .ternary) :
    CrtPrimePrefix214.Input (counter before out k) k v :=
  ⟨by omega,FftLocalCells140.cell_at _ _ _,rowV,
    ((counter_arrays before out k "primes".toList).trans
      ((scope_arrays before out "primes".toList (by decide)).trans b.primesBinding)),
    by rw [counter_heap]; exact object⟩



def primeRow (k : Nat) : Nat×Nat×Nat := IndexedPrimeRows217.row k
 def col (W : Nat → BitVec 32) (k : Nat) : Nat → BitVec 32 := fun j => W (k+j*22)

theorem primeRow_value (k : Nat) (kb : k<22) : (values .ternary)[k]?=some (primeRow k) :=
  IndexedPrimeRows217.source k (by change k<1101; omega)

theorem guard (s : State) (u : Nat) (outer : Outer s u) (ub : u<2^64) :
    C99ArrayReference.scalar s StepPrimeShape188.condition (C99ScalarReference.boolean (decide (u<22))) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ outer.uCell) (.variable _ _ _ outer.slenCell)
    (C99NatWord141.less u 22 ub (by decide))

end FT1536.Source3.SixthStepLoopBase217
