import Source3.EighthStepPair217
import Source3.EighthStepPrime217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete first-prime iteration at the d=4 layout, generic in the row. -/
namespace FT1536.Source3.EighthStepInner217
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
open EighthStepLayout217 (fd gd fs gs gm igm t1)
open EighthStepGenerator217 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open EighthStepProduct217 (root)
open EighthStepMarch217
open EighthStepPrime217

/- One complete loop iteration at index u and row v: prefix, generator
   and the two-sided march/product/iNTT tail. -/
def tableWord (ivs : Fin 4 → BitVec 32) (j : Nat) := ivs ⟨j%4,Nat.mod_lt _ (by decide)⟩

theorem col_outside (n : Nat) (bound : n<1990) :
    MkgmCallKeep203.Outside gm (scratch n) ∧ MkgmCallKeep203.Outside igm (scratch n) := by
  constructor <;> intro byte <;> right <;> left
  · change 0+4*n+byte.val<0+4*1990; omega
  · change 0+4*n+byte.val<0+4*1994; omega

theorem inner_source (s : State) (u : Nat) (v : Nat×Nat×Nat) (F G : Nat → BitVec 32)
    (o : Outer s u) (input : CrtPrimePrefix214.Input s u v) (bound : u<82)
    (revB : s.tables "REV10".toList=some rev) (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (fData : ∀ j<4, Load32 s.heap (addr fs u j 82) (F j))
    (gData : ∀ j<4, Load32 s.heap (addr gs u j 82) (G j)) :
    ∃ (out : State) (ivs : Fin 4 → BitVec 32),
      Exec StepPrimeShape188.inner s ⟨out,.normal⟩ ∧
      Basic out u (pVal v) (iVal v) (rVal v) ∧
      Image out fd u 166 2 (pVal v) (iVal v) (rVal v) F 2 ∧
      Image out gd u 166 2 (pVal v) (iVal v) (rVal v) G 2 ∧
      (∀ j<4, Load32 out.heap (addr fs u j 82) (scaledWord 1 F (tableWord ivs) (pVal v) (iVal v) j)) ∧
      (∀ j<4, Load32 out.heap (addr gs u j 82) (scaledWord 1 G (tableWord ivs) (pVal v) (iVal v) j)) ∧
      (∀ q : ArrayPointer,
        (∀ i : Fin 4, Separate (elem t1 i.val) q) →
        (∀ i : Fin 2, Separate (addr fd u i.val 166) q) →
        (∀ i : Fin 2, Separate (addr gd u i.val 166) q) →
        (∀ j<4, Separate (addr fs u j 82) q) →
        (∀ j<4, Separate (addr gs u j 82) q) →
        MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨generated,gvs,ivs,genRun,genBasic,gLocals,gArrays,gRead,iRead,genKeep⟩ :=
    EighthStepGenerator217.generator (afterP s v) u v (pVal v) (iVal v) (rVal v)
      (basicP s u v o) (inputP s u v input) revB (by rw [heapP]; exact revS)
  have vNone : generated.locals "v".toList=some (.uint64,none) := (congrFun gLocals "v".toList).trans (v_declP s v)
  have twLoads : ∀ k<4, Load32 generated.heap (elem igm k) (tableWord ivs k) := by
    intro k bound'
    simpa only [tableWord,Nat.mod_eq_of_lt bound',KeygenSmallOutput.element,StepCopyBody190.elem] using iRead ⟨k,bound'⟩
  have fReady : ∀ j<4, Load32 generated.heap (addr fs u j 82) (F j) := by
    intro j slot
    have outside := col_outside (1334+u+j*82) (by have h:=copy_bounds .f u j bound slot; omega)
    show Load32 generated.heap (scratch (1334+u+j*82)) (F j)
    exact genKeep _ outside.1 outside.2 _ (fData j slot)
  have gReady : ∀ j<4, Load32 generated.heap (addr gs u j 82) (G j) := by
    intro j slot
    have outside := col_outside (1662+u+j*82) (by have h:=copy_bounds .g u j bound slot; omega)
    show Load32 generated.heap (scratch (1662+u+j*82)) (G j)
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


end FT1536.Source3.EighthStepInner217
