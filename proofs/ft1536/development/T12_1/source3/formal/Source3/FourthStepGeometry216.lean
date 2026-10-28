import Source3.FourthStepProduct216

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The first slen = 6 prime loop of the d=4 body (the marsze layer):
   the original `for (u = 0; u < slen; u ++)` over the PRIMES3 rows 0..5
   at n = 64 / hn = 32, with its copy marches at stride 6, the false
   !in_ntt skips, the fd/gd Montgomery product marches, the taken in_ntt
   modp_iNTT3_ext column visits at Level 5 (logn 6) and the modp_mkgm3
   generator of FourthStepGenerator216. All words are executed words of
   the actual table rows and source bodies; no NTT/root/table law is
   claimed. -/
namespace FT1536.Source3.FourthStepMarch216
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
open FourthStepLayout216 (fd gd fs gs gm igm t1)
open FourthStepGenerator216 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open SecondStepProduct203 (root)

/- Geometry of the d=4 march layers. -/
def croot : Side → ArrayPointer | .f => fs | .g => gs
def scratch (index : Nat) : ArrayPointer := ⟨31,0,71680,4,index⟩

theorem ordered (a b : Nat) (less : a<b) : Separate (scratch a) (scratch b) := by
  right; left
  change 0+4*a+4 ≤ 0+4*b
  omega

theorem copy_shape (side : Side) (u j : Nat) : addr (croot side) u j 6=
    scratch ((croot side).index+u+j*6) := by cases side <;> rfl

theorem product_shape (side : Side) (u j : Nat) : addr (root side) u j 12=
    scratch ((root side).index+u+j*12) := by cases side <;> rfl

theorem copy_bounds (side : Side) (u j : Nat) (bound : u<6) (slot : j<64) :
    1438 ≤ (croot side).index+u+j*6 ∧ (croot side).index+u+j*6<2206 := by
  have range : 1438 ≤ (croot side).index ∧ (croot side).index ≤ 1822 := by
    cases side <;> decide
  omega

theorem product_bound (side : Side) (u j : Nat) (bound : u<6) (slot : j<32) :
    (root side).index+u+j*12<1438 := by
  have range : (root side).index ≤ 1054 := by cases side <;> decide
  omega

theorem copy_data (side : Side) (u j : Nat) (bound : u<6) (slot : j<64) (i : Fin 64) :
    Separate (elem t1 i.val) (addr (croot side) u j 6) := by
  apply StepCopyFixed190.separate_symm
  rw [copy_shape]
  change Separate (scratch ((croot side).index+u+j*6)) (scratch (2334+i.val))
  exact ordered _ _ (by have h:=copy_bounds side u j bound slot; omega)

theorem copy_twiddle (k : Nat) (slot : k<64) (i : Fin 64) : Separate (elem t1 i.val) (elem igm k) := by
  apply StepCopyFixed190.separate_symm
  change Separate (scratch (2270+k)) (scratch (2334+i.val))
  exact ordered _ _ (by omega)

theorem product_data (destination source : Side) (u j v k : Nat) (bound : u<6) (slot : j<32) :
    Separate (addr (root destination) u j 12) (addr (croot source) v k 6) := by
  rw [product_shape,copy_shape]
  have low:=product_bound destination u j bound slot
  have high : 1438 ≤ (croot source).index := by cases source <;> decide
  exact ordered _ _ (by omega)

theorem product_twiddle (side : Side) (u j k : Nat) (bound : u<6) (slot : j<32) :
    Separate (addr (root side) u j 12) (elem igm k) := by
  rw [product_shape]
  change Separate (scratch ((root side).index+u+j*12)) (scratch (2270+k))
  exact ordered _ _ (by have h:=product_bound side u j bound slot; omega)

theorem fs_gs (u j v k : Nat) (bound : u<6) (slot : j<64) : Separate (addr fs u j 6) (addr gs v k 6) := by
  change Separate (scratch (1438+u+j*6)) (scratch (1822+v+k*6))
  exact ordered _ _ (by have a:=slot; have b:=k; omega)

theorem product_t1 (side : Side) (u i j : Nat) (bound : u<6) (slot : i<32) (tb : j<64) :
    Separate (addr (root side) u i 12) (elem t1 j) := by
  cases side
  · change 31≠31 ∨ 0+4*(670+u+i*12)+4 ≤ 0+4*(2334+j) ∨
      0+4*(2334+j)+4 ≤ 0+4*(670+u+i*12)
    right; left; omega
  · change 31≠31 ∨ 0+4*(1054+u+i*12)+4 ≤ 0+4*(2334+j) ∨
      0+4*(2334+j)+4 ≤ 0+4*(1054+u+i*12)
    right; left; omega

theorem product_cross (u v i j : Nat) (bu : u<6) (bv : v<6) (si : i<32) (sj : j<32) :
    Separate (addr fd u i 12) (addr gd v j 12) := by
  change 31≠31 ∨ 0+4*(670+u+i*12)+4 ≤ 0+4*(1054+v+j*12) ∨
      0+4*(1054+v+j*12)+4 ≤ 0+4*(670+u+i*12)
  right; left; omega


end FT1536.Source3.FourthStepMarch216
