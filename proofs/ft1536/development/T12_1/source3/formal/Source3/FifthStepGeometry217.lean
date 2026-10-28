import Source3.FifthStepProduct217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- d5 geometry layer of the original first-prime source loop. -/
namespace FT1536.Source3.FifthStepMarch217
open C99ArrayReference (State Name bindValue bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (addr elem)
open SecondStepCopy203 (Side)
open StepCopyFixed203 (PrefixImage)
open StepProductFixed203 (Image)
open FifthStepLayout217 (fd gd fs gs gm igm t1)
open FifthStepGenerator217 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open FifthStepProduct217 (root)

/- Geometry of the d=5 march layers. -/
def croot : Side → ArrayPointer | .f => fs | .g => gs
def scratch (index : Nat) : ArrayPointer := ⟨31,0,71680,4,index⟩

theorem ordered (a b : Nat) (less : a<b) : Separate (scratch a) (scratch b) := by
  right; left
  change 0+4*a+4 ≤ 0+4*b
  omega

theorem copy_shape (side : Side) (u j : Nat) : addr (croot side) u j 12=
    scratch ((croot side).index+u+j*12) := by cases side <;> rfl

theorem product_shape (side : Side) (u j : Nat) : addr (root side) u j 22=
    scratch ((root side).index+u+j*22) := by cases side <;> rfl

theorem copy_bounds (side : Side) (u j : Nat) (bound : u<12) (slot : j<32) :
    1374 ≤ (croot side).index+u+j*12 ∧ (croot side).index+u+j*12<2142 := by
  have range : 1374 ≤ (croot side).index ∧ (croot side).index ≤ 1758 := by
    cases side <;> decide
  omega

theorem product_bound (side : Side) (u j : Nat) (bound : u<12) (slot : j<16) :
    (root side).index+u+j*22<1374 := by
  have range : (root side).index ≤ 1022 := by cases side <;> decide
  omega

theorem copy_data (side : Side) (u j : Nat) (bound : u<12) (slot : j<32) (i : Fin 32) :
    Separate (elem t1 i.val) (addr (croot side) u j 12) := by
  apply StepCopyFixed190.separate_symm
  rw [copy_shape]
  change Separate (scratch ((croot side).index+u+j*12)) (scratch (2206+i.val))
  exact ordered _ _ (by have h:=copy_bounds side u j bound slot; omega)

theorem copy_twiddle (k : Nat) (slot : k<32) (i : Fin 32) : Separate (elem t1 i.val) (elem igm k) := by
  apply StepCopyFixed190.separate_symm
  change Separate (scratch (2174+k)) (scratch (2206+i.val))
  exact ordered _ _ (by omega)

theorem product_data (destination source : Side) (u j v k : Nat) (bound : u<12) (slot : j<16) :
    Separate (addr (root destination) u j 22) (addr (croot source) v k 12) := by
  rw [product_shape,copy_shape]
  have low:=product_bound destination u j bound slot
  have high : 1374 ≤ (croot source).index := by cases source <;> decide
  exact ordered _ _ (by omega)

theorem product_twiddle (side : Side) (u j k : Nat) (bound : u<12) (slot : j<16) :
    Separate (addr (root side) u j 22) (elem igm k) := by
  rw [product_shape]
  change Separate (scratch ((root side).index+u+j*22)) (scratch (2174+k))
  exact ordered _ _ (by have h:=product_bound side u j bound slot; omega)

theorem fs_gs (u j v k : Nat) (bound : u<12) (slot : j<32) : Separate (addr fs u j 12) (addr gs v k 12) := by
  change Separate (scratch (1374+u+j*12)) (scratch (1758+v+k*12))
  exact ordered _ _ (by have a:=slot; have b:=k; omega)

theorem product_t1 (side : Side) (u i j : Nat) (bound : u<12) (slot : i<16) (tb : j<32) :
    Separate (addr (root side) u i 22) (elem t1 j) := by
  cases side
  · change 31≠31 ∨ 0+4*(670+u+i*22)+4 ≤ 0+4*(2206+j) ∨
      0+4*(2206+j)+4 ≤ 0+4*(670+u+i*22)
    right; left; omega
  · change 31≠31 ∨ 0+4*(1022+u+i*22)+4 ≤ 0+4*(2206+j) ∨
      0+4*(2206+j)+4 ≤ 0+4*(1022+u+i*22)
    right; left; omega

theorem product_cross (u v i j : Nat) (bu : u<12) (bv : v<12) (si : i<16) (sj : j<16) :
    Separate (addr fd u i 22) (addr gd v j 22) := by
  change 31≠31 ∨ 0+4*(670+u+i*22)+4 ≤ 0+4*(1022+v+j*22) ∨
      0+4*(1022+v+j*22)+4 ≤ 0+4*(670+u+i*22)
  right; left; omega


end FT1536.Source3.FifthStepMarch217
