import Source3.NinthStepProduct217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- d9 geometry layer of the original first-prime source loop. -/
namespace FT1536.Source3.NinthStepMarch217
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
open NinthStepLayout217 (fd gd fs gs gm igm t1)
open NinthStepGenerator217 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open NinthStepProduct217 (root)

/- Geometry of the d=9 march layers. -/
def croot : Side → ArrayPointer | .f => fs | .g => gs
def scratch (index : Nat) : ArrayPointer := ⟨31,0,71680,4,index⟩

theorem ordered (a b : Nat) (less : a<b) : Separate (scratch a) (scratch b) := by
  right; left
  change 0+4*a+4 ≤ 0+4*b
  omega

theorem copy_shape (side : Side) (u j : Nat) : addr (croot side) u j 166=
    scratch ((croot side).index+u+j*166) := by cases side <;> rfl

theorem product_shape (side : Side) (u j : Nat) : addr (root side) u j 335=
    scratch ((root side).index+u+j*335) := by cases side <;> rfl

theorem copy_bounds (side : Side) (u j : Nat) (bound : u<166) (slot : j<2) :
    1340 ≤ (croot side).index+u+j*166 ∧ (croot side).index+u+j*166<2004 := by
  have range : 1340 ≤ (croot side).index ∧ (croot side).index ≤ 1672 := by
    cases side <;> decide
  omega

theorem product_bound (side : Side) (u j : Nat) (bound : u<166) (slot : j<1) :
    (root side).index+u+j*335<1340 := by
  have range : (root side).index ≤ 1005 := by cases side <;> decide
  omega

theorem copy_data (side : Side) (u j : Nat) (bound : u<166) (slot : j<2) (i : Fin 2) :
    Separate (elem t1 i.val) (addr (croot side) u j 166) := by
  apply StepCopyFixed190.separate_symm
  rw [copy_shape]
  change Separate (scratch ((croot side).index+u+j*166)) (scratch (2008+i.val))
  exact ordered _ _ (by have h:=copy_bounds side u j bound slot; omega)

theorem copy_twiddle (k : Nat) (slot : k<2) (i : Fin 2) : Separate (elem t1 i.val) (elem igm k) := by
  apply StepCopyFixed190.separate_symm
  change Separate (scratch (2006+k)) (scratch (2008+i.val))
  exact ordered _ _ (by omega)

theorem product_data (destination source : Side) (u j v k : Nat) (bound : u<166) (slot : j<1) :
    Separate (addr (root destination) u j 335) (addr (croot source) v k 166) := by
  rw [product_shape,copy_shape]
  have low:=product_bound destination u j bound slot
  have high : 1340 ≤ (croot source).index := by cases source <;> decide
  exact ordered _ _ (by omega)

theorem product_twiddle (side : Side) (u j k : Nat) (bound : u<166) (slot : j<1) :
    Separate (addr (root side) u j 335) (elem igm k) := by
  rw [product_shape]
  change Separate (scratch ((root side).index+u+j*335)) (scratch (2006+k))
  exact ordered _ _ (by have h:=product_bound side u j bound slot; omega)

theorem fs_gs (u j v k : Nat) (bound : u<166) (slot : j<2) : Separate (addr fs u j 166) (addr gs v k 166) := by
  change Separate (scratch (1340+u+j*166)) (scratch (1672+v+k*166))
  exact ordered _ _ (by have a:=slot; have b:=k; omega)

theorem product_t1 (side : Side) (u i j : Nat) (bound : u<166) (slot : i<1) (tb : j<2) :
    Separate (addr (root side) u i 335) (elem t1 j) := by
  cases side
  · change 31≠31 ∨ 0+4*(670+u+i*335)+4 ≤ 0+4*(2008+j) ∨
      0+4*(2008+j)+4 ≤ 0+4*(670+u+i*335)
    right; left; omega
  · change 31≠31 ∨ 0+4*(1005+u+i*335)+4 ≤ 0+4*(2008+j) ∨
      0+4*(2008+j)+4 ≤ 0+4*(1005+u+i*335)
    right; left; omega

theorem product_cross (u v i j : Nat) (bu : u<166) (bv : v<166) (si : i<1) (sj : j<1) :
    Separate (addr fd u i 335) (addr gd v j 335) := by
  change 31≠31 ∨ 0+4*(670+u+i*335)+4 ≤ 0+4*(1005+v+j*335) ∨
      0+4*(1005+v+j*335)+4 ≤ 0+4*(670+u+i*335)
  right; left; omega


end FT1536.Source3.NinthStepMarch217
