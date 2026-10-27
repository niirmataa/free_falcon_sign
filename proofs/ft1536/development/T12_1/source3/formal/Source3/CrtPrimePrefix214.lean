import Source3.SelectedStepAddPrime195
import Source3.KeygenStaticTables
import Source3.CrtState205
import Source3.CrtRoundShape205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The generalized prime prefix of the CRT prime round. The original
   CrtPrimePrefix206 consumed the fixed u = 1 row constants of
   SelectedStepAddPrime195; this module executes the same seven statements
   with p/s read from the actual PrimeObject at the loop index u through
   KeygenLevelCalls.PrimeRead, and p0i/R2 computed by the actual source
   bodies of modp_ninv31 and modp_R2 (KeygenNinv31.source_exists and
   KeygenModpR2Exec.source_exists). The executed words are the table words
   pVal/sVal of the u-th PRIMES3 row and their derived words iVal/rVal.

   Values stay executed words: no transform property, table law, root law,
   positivity or Z>0 claim is made here. No desired output, certificate or
   CRT law is supplied as a premise. -/
namespace FT1536.Source3.CrtPrimePrefix214
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer Load32)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open CrtState205 (Slot64 set32)
open KeygenFullData127 (primes)
open KeygenModpR2Exec (Slot)
open KeygenStaticTables (PrimeObject primeField fieldValue values)
open KeygenZintCall (Stmt Exec)
open CrtRoundShape205 (localNames declare cell)

/- The four private u32 words declared by the prefix. -/
def words : List Name := ["p".toList,"p0i".toList,"s".toList,"R2".toList]

/- Executed words of the u-th table row v: the p/s struct reads and the
   words returned by the actual modp_ninv31 / modp_R2 source bodies. -/
def pVal (v : Nat×Nat×Nat) : BitVec 32 := BitVec.ofNat 32 (fieldValue v .p)
def sVal (v : Nat×Nat×Nat) : BitVec 32 := BitVec.ofNat 32 (fieldValue v .s)
def iVal (v : Nat×Nat×Nat) : BitVec 32 := KeygenNinv31.word (pVal v)
def rVal (v : Nat×Nat×Nat) : BitVec 32 := KeygenModpR2Word.word (pVal v) (iVal v)

/- Ordinary input domain of the prefix at loop index u: the u cell word,
   the actual PRIMES3 object and its u-th parsed row. -/
structure Input (s : State) (u : Nat) (v : Nat×Nat×Nat) : Prop where
  uBound : u < 2^64
  uCell : Slot64 s "u" (C99NatWord141.word u)
  rowValue : (values .ternary)[u]? = some v
  primesBinding : s.arrays "primes".toList = some primes
  primeObject : PrimeObject s.heap primes .ternary

theorem rows_bound {s : State} {u : Nat} {v : Nat×Nat×Nat} (input : Input s u v) :
    u < KeygenStaticTables.rowCount .ternary := by
  obtain ⟨bound,_⟩ := List.getElem?_eq_some_iff.mp input.rowValue
  rw [KeygenPrimeTableBinding.source_length] at bound
  exact bound

/- The row pointer reached from the primes array by the u cell word. -/
def rowPointer (u : Nat) : ArrayPointer := {primes with index := primes.index+u}

theorem fieldPointer_row (input : Input s u v) (field : KeygenLevelCalls.Field) :
    KeygenLevelCalls.fieldPointer (rowPointer u) field = primeField primes u field := by
  simp only [rowPointer,KeygenLevelCalls.fieldPointer,primeField,ArrayPointer.offset,
    input.primeObject.1,input.primeObject.2.1,Nat.zero_add,Nat.mul_zero,Nat.add_zero]

/- The struct-member read at index u on any state with the same arrays,
   u cell and heap: the p/s words come from the PrimeObject. -/
theorem primeRead (s : State) (u : Nat) (v : Nat×Nat×Nat) (input : Input s u v)
    (field : KeygenLevelCalls.Field) (t : State) (binding : t.arrays "primes".toList=some primes)
    (cell : Slot64 t "u" (C99NatWord141.word u)) (heap : t.heap=s.heap) :
    KeygenLevelCalls.PrimeRead t "primes".toList (.var "u".toList) field
      (.uint32 (BitVec.ofNat 32 (fieldValue v field))) := by
  have nonneg : (0:Int)≤(Value.uint64 (C99NatWord141.word u)).integer := by
    rw [C99NatWord141.integer u input.uBound]
    exact Int.natCast_nonneg u
  have within : C99MemoryReference.PointerAdd primes (Value.uint64 (C99NatWord141.word u)).integer.toNat
      (rowPointer u) := by
    rw [C99NatWord141.integer u input.uBound]
    refine C99MemoryReference.PointerAdd.within primes u ?_
    have h := rows_bound input
    rw [input.primeObject.2.1,input.primeObject.2.2.1]
    omega
  have extent : (rowPointer u).index<primes.count := by
    have h := rows_bound input
    simp only [rowPointer]
    rw [input.primeObject.2.1,input.primeObject.2.2.1]
    omega
  have loaded : Load32 t.heap (primeField primes u field)
      (BitVec.ofNat 32 (fieldValue v field)) := by
    rw [heap]
    exact input.primeObject.2.2.2.2.2.2 u v input.rowValue field
  refine .read (rowPointer u) (BitVec.ofNat 32 (fieldValue v field))
    (.add _ _ primes (rowPointer u) (.uint64 (C99NatWord141.word u)) binding
      (.variable _ _ _ cell) nonneg within) ?_ extent ?_
  · exact input.primeObject.1
  · rw [fieldPointer_row input field]
    exact loaded

/- The seven-statement prefix: declare p/p0i/s/R2 (u32) and v (u64),
   read p = primes[u].p, s = primes[u].s, then p0i = modp_ninv31(p)
   and R2 = modp_R2(p, p0i), and continue with tail. -/
def prepend (tail : Stmt) : Stmt :=
  .seq (declare .u32 words)
    (.seq (declare .u64 ["v".toList])
      (.seq (.prime "p".toList "primes".toList (.var "u".toList) .p)
        (.seq (.prime "s".toList "primes".toList (.var "u".toList) .s)
          (.seq (.word (.assign "p0i".toList (.call1 "modp_ninv31".toList (cell "p"))))
            (.seq (.word (.assign "R2".toList (.call2 "modp_R2".toList (cell "p") (cell "p0i"))))
              tail)))))

theorem inner_shape : CrtRoundShape205.inner =
    prepend (.seq (.seq CrtRoundShape205.walkInit CrtRoundShape205.walk)
      (.seq CrtRoundShape205.mulCall CrtRoundShape205.skip)) := rfl

/- Private state chain of the prefix carrying the executed words. -/
def declared (s : State) : State :=
  C99DeclarationStatements.effect .u64 ["v".toList] (C99DeclarationStatements.effect .u32 words s)
def withP (s : State) (pw : BitVec 32) : State := set32 (declared s) "p" pw
def withS (s : State) (pw sw : BitVec 32) : State := set32 (withP s pw) "s" sw
def withI (s : State) (pw sw : BitVec 32) : State := set32 (withS s pw sw) "p0i" (KeygenNinv31.word pw)
def after_prefix (s : State) (pw sw : BitVec 32) : State :=
  set32 (withI s pw sw) "R2" (KeygenModpR2Word.word pw (KeygenNinv31.word pw))

theorem declared_outside (s : State) (name : Name) (absent : name∉localNames) :
    (declared s).locals name=s.locals name := by
  have nv : name≠"v".toList := fun eq => absent (eq ▸ (by decide))
  have nw : name∉words := fun member => absent (by
    change name∈words++["v".toList]
    exact List.mem_append_left _ member)
  exact (ZintSubWord194.effect_one_other .u64 "v".toList name _ nv).trans
    (SelectedStepAddPrime195.effect_locals .u32 words s name nw)

/- State keeps outside the declared names through the whole prefix. -/
theorem outside (s : State) (pw sw : BitVec 32) (name : Name) (absent : name∉localNames) :
    (after_prefix s pw sw).locals name=s.locals name := by
  have np : name≠"p".toList := fun eq => absent (eq ▸ (by decide))
  have ns : name≠"s".toList := fun eq => absent (eq ▸ (by decide))
  have ni : name≠"p0i".toList := fun eq => absent (eq ▸ (by decide))
  have nr : name≠"R2".toList := fun eq => absent (eq ▸ (by decide))
  exact (SelectedStepAddPrime195.locals_keep (withI s pw sw) "R2".toList .uint32
      (.uint32 (KeygenModpR2Word.word pw (KeygenNinv31.word pw))) name nr).trans
    ((SelectedStepAddPrime195.locals_keep (withS s pw sw) "p0i".toList .uint32
      (.uint32 (KeygenNinv31.word pw)) name ni).trans
      ((SelectedStepAddPrime195.locals_keep (withP s pw) "s".toList .uint32 (.uint32 sw) name ns).trans
        ((SelectedStepAddPrime195.locals_keep (declared s) "p".toList .uint32 (.uint32 pw) name np).trans
          (declared_outside s name absent))))

/- Cell theorems for p, s, p0i, R2 at the end of the prefix: the executed
   table words and their derived source-body words. -/
theorem pCell (s : State) (pw sw : BitVec 32) : Slot (after_prefix s pw sw) "p" pw :=
  (CrtState205.keep32 (withI s pw sw) "R2" "p" (KeygenModpR2Word.word pw (KeygenNinv31.word pw)) (by decide)).trans
    ((CrtState205.keep32 (withS s pw sw) "p0i" "p" (KeygenNinv31.word pw) (by decide)).trans
      ((CrtState205.keep32 (withP s pw) "s" "p" sw (by decide)).trans (CrtState205.cell32 _ _ _)))

theorem sCell (s : State) (pw sw : BitVec 32) : Slot (after_prefix s pw sw) "s" sw :=
  (CrtState205.keep32 (withI s pw sw) "R2" "s" (KeygenModpR2Word.word pw (KeygenNinv31.word pw)) (by decide)).trans
    ((CrtState205.keep32 (withS s pw sw) "p0i" "s" (KeygenNinv31.word pw) (by decide)).trans
      (CrtState205.cell32 _ _ _))

theorem iCell (s : State) (pw sw : BitVec 32) : Slot (after_prefix s pw sw) "p0i" (KeygenNinv31.word pw) :=
  (CrtState205.keep32 (withI s pw sw) "R2" "p0i" (KeygenModpR2Word.word pw (KeygenNinv31.word pw)) (by decide)).trans
    (CrtState205.cell32 _ _ _)

theorem rCell (s : State) (pw sw : BitVec 32) :
    Slot (after_prefix s pw sw) "R2" (KeygenModpR2Word.word pw (KeygenNinv31.word pw)) :=
  CrtState205.cell32 _ _ _

theorem vDeclared (s : State) (pw sw : BitVec 32) :
    (after_prefix s pw sw).locals "v".toList=some (.uint64,none) := by
  have chain : (after_prefix s pw sw).locals "v".toList=(declared s).locals "v".toList := by
    simp only [after_prefix,withI,withS,withP,set32,ModularAtoms178.set,C99ArrayReference.bindValue,C99ScalarReference.set]
    rfl
  exact chain.trans (ZintSubWord194.effect_one_cell .u64 "v".toList _)

/- Main source theorem: executing the seven-statement prefix with the
   actual PrimeObject reads produces the executed words pVal/sVal and the
   source-body words iVal/rVal, then continues with tail from the
   completed prefix state. -/
theorem source (s : State) (u : Nat) (v : Nat×Nat×Nat) (input : Input s u v)
    (tail : Stmt) (out : Result) (rest : Exec tail (after_prefix s (pVal v) (sVal v)) out) :
    Exec (prepend tail) s out := by
  have declaredU : Slot64 (declared s) "u" (C99NatWord141.word u) :=
    (declared_outside s "u".toList (by decide)).trans input.uCell
  have pRead : KeygenLevelCalls.PrimeRead (declared s) "primes".toList (.var "u".toList) .p
      (.uint32 (pVal v)) := primeRead s u v input .p (declared s) input.primesBinding declaredU rfl
  have pRun : Exec (.prime "p".toList "primes".toList (.var "u".toList) .p) (declared s)
      ⟨withP s (pVal v),.normal⟩ :=
    .prime _ _ _ _ _ .uint32 none (.uint32 (pVal v)) rfl pRead
  have withPU : Slot64 (withP s (pVal v)) "u" (C99NatWord141.word u) :=
    (CrtState205.keep32 (declared s) "p" "u" (pVal v) (by decide)).trans declaredU
  have sRead : KeygenLevelCalls.PrimeRead (withP s (pVal v)) "primes".toList (.var "u".toList) .s
      (.uint32 (sVal v)) := primeRead s u v input .s (withP s (pVal v)) input.primesBinding withPU rfl
  have sRun : Exec (.prime "s".toList "primes".toList (.var "u".toList) .s) (withP s (pVal v))
      ⟨withS s (pVal v) (sVal v),.normal⟩ :=
    .prime _ _ _ _ _ .uint32 none (.uint32 (sVal v)) rfl sRead
  have pS : Slot (withS s (pVal v) (sVal v)) "p" (pVal v) :=
    (CrtState205.keep32 (withP s (pVal v)) "s" "p" (sVal v) (by decide)).trans (CrtState205.cell32 _ _ _)
  have iRun : Exec (.word (.assign "p0i".toList (.call1 "modp_ninv31".toList (cell "p"))))
      (withS s (pVal v) (sVal v)) ⟨withI s (pVal v) (sVal v),.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign32 _ "p0i" none _ (iVal v) rfl
      (.call1 _ _ _ _ (CrtState205.expr32 _ "p" (pVal v) pS) (.inverse _ _ (KeygenNinv31.source_exists (pVal v)))))
  have pI : Slot (withI s (pVal v) (sVal v)) "p" (pVal v) :=
    (CrtState205.keep32 (withS s (pVal v) (sVal v)) "p0i" "p" (iVal v) (by decide)).trans pS
  have iI : Slot (withI s (pVal v) (sVal v)) "p0i" (iVal v) := CrtState205.cell32 _ _ _
  have rRun : Exec (.word (.assign "R2".toList (.call2 "modp_R2".toList (cell "p") (cell "p0i"))))
      (withI s (pVal v) (sVal v)) ⟨after_prefix s (pVal v) (sVal v),.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign32 _ "R2" none _ (rVal v) rfl
      (.call2 _ _ _ _ _ _ (CrtState205.expr32 _ "p" (pVal v) pI) (CrtState205.expr32 _ "p0i" (iVal v) iI)
        (.r2 _ _ (KeygenModpR2Exec.source_exists (withI s (pVal v) (sVal v)) (pVal v) (iVal v)))))
  exact .seqNormal _ _ _ _ _ (.word _ _ _ (ZintSubWord194.declare_run .u32 words s))
    (.seqNormal _ _ _ _ _ (.word _ _ _ (ZintSubWord194.declare_run .u64 ["v".toList] _))
      (.seqNormal _ _ _ _ _ pRun (.seqNormal _ _ _ _ _ sRun
        (.seqNormal _ _ _ _ _ iRun (.seqNormal _ _ _ _ _ rRun rest)))))

end FT1536.Source3.CrtPrimePrefix214
