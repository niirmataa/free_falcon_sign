import Source3.SixthStepProduct217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- d6 geometry layer of the original first-prime source loop. -/
namespace FT1536.Source3.SixthStepMarch217
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
open SixthStepLayout217 (fd gd fs gs gm igm t1)
open SixthStepGenerator217 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open SixthStepProduct217 (root)

/- Geometry of the d=6 march layers. -/
def croot : Side → ArrayPointer | .f => fs | .g => gs
def scratch (index : Nat) : ArrayPointer := ⟨31,0,71680,4,index⟩

theorem ordered (a b : Nat) (less : a<b) : Separate (scratch a) (scratch b) := by
  right; left
  change 0+4*a+4 ≤ 0+4*b
  omega

theorem copy_shape (side : Side) (u j : Nat) : addr (croot side) u j 22=
    scratch ((croot side).index+u+j*22) := by cases side <;> rfl

theorem product_shape (side : Side) (u j : Nat) : addr (root side) u j 42=
    scratch ((root side).index+u+j*42) := by cases side <;> rfl

theorem copy_bounds (side : Side) (u j : Nat) (bound : u<22) (slot : j<16) :
    1342 ≤ (croot side).index+u+j*22 ∧ (croot side).index+u+j*22<2046 := by
  have range : 1342 ≤ (croot side).index ∧ (croot side).index ≤ 1694 := by
    cases side <;> decide
  omega

theorem product_bound (side : Side) (u j : Nat) (bound : u<22) (slot : j<8) :
    (root side).index+u+j*42<1342 := by
  have range : (root side).index ≤ 1006 := by cases side <;> decide
  omega

theorem copy_data (side : Side) (u j : Nat) (bound : u<22) (slot : j<16) (i : Fin 16) :
    Separate (elem t1 i.val) (addr (croot side) u j 22) := by
  apply StepCopyFixed190.separate_symm
  rw [copy_shape]
  change Separate (scratch ((croot side).index+u+j*22)) (scratch (2078+i.val))
  exact ordered _ _ (by have h:=copy_bounds side u j bound slot; omega)

theorem copy_twiddle (k : Nat) (slot : k<16) (i : Fin 16) : Separate (elem t1 i.val) (elem igm k) := by
  apply StepCopyFixed190.separate_symm
  change Separate (scratch (2062+k)) (scratch (2078+i.val))
  exact ordered _ _ (by omega)

theorem product_data (destination source : Side) (u j v k : Nat) (bound : u<22) (slot : j<8) :
    Separate (addr (root destination) u j 42) (addr (croot source) v k 22) := by
  rw [product_shape,copy_shape]
  have low:=product_bound destination u j bound slot
  have high : 1342 ≤ (croot source).index := by cases source <;> decide
  exact ordered _ _ (by omega)

theorem product_twiddle (side : Side) (u j k : Nat) (bound : u<22) (slot : j<8) :
    Separate (addr (root side) u j 42) (elem igm k) := by
  rw [product_shape]
  change Separate (scratch ((root side).index+u+j*42)) (scratch (2062+k))
  exact ordered _ _ (by have h:=product_bound side u j bound slot; omega)

theorem fs_gs (u j v k : Nat) (bound : u<22) (slot : j<16) : Separate (addr fs u j 22) (addr gs v k 22) := by
  change Separate (scratch (1342+u+j*22)) (scratch (1694+v+k*22))
  exact ordered _ _ (by have a:=slot; have b:=k; omega)

theorem product_t1 (side : Side) (u i j : Nat) (bound : u<22) (slot : i<8) (tb : j<16) :
    Separate (addr (root side) u i 42) (elem t1 j) := by
  cases side
  · change 31≠31 ∨ 0+4*(670+u+i*42)+4 ≤ 0+4*(2078+j) ∨
      0+4*(2078+j)+4 ≤ 0+4*(670+u+i*42)
    right; left; omega
  · change 31≠31 ∨ 0+4*(1006+u+i*42)+4 ≤ 0+4*(2078+j) ∨
      0+4*(2078+j)+4 ≤ 0+4*(1006+u+i*42)
    right; left; omega

theorem product_cross (u v i j : Nat) (bu : u<22) (bv : v<22) (si : i<8) (sj : j<8) :
    Separate (addr fd u i 42) (addr gd v j 42) := by
  change 31≠31 ∨ 0+4*(670+u+i*42)+4 ≤ 0+4*(1006+v+j*42) ∨
      0+4*(1006+v+j*42)+4 ≤ 0+4*(670+u+i*42)
  right; left; omega


end FT1536.Source3.SixthStepMarch217
