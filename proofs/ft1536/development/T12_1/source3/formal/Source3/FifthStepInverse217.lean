import Source3.FifthStepCopy217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- d5 inverse layer of the original first-prime source loop. -/
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

/- The iNTT3_ext column visits at Level 4 / stride 12. -/
theorem sepI (side : Side) (u j k : Nat) (different : j≠k) :
    Separate (walk (elem (croot side) u) j 12) (walk (elem (croot side) u) k 12) := by
  cases side
  · change 31≠31 ∨ 0+4*(1374+u+j*12)+4 ≤ 0+4*(1374+u+k*12) ∨
      0+4*(1374+u+k*12)+4 ≤ 0+4*(1374+u+j*12)
    omega
  · change 31≠31 ∨ 0+4*(1758+u+j*12)+4 ≤ 0+4*(1758+u+k*12) ∨
      0+4*(1758+u+k*12)+4 ≤ 0+4*(1758+u+j*12)
    omega

theorem tw_sepI (side : Side) (u j k : Nat) (bound : u<12) (slot : j<32) :
    Separate (walk (elem (croot side) u) j 12) (elem igm k) := by
  cases side
  · change 31≠31 ∨ 0+4*(1374+u+j*12)+4 ≤ 0+4*(2174+k) ∨
      0+4*(2174+k)+4 ≤ 0+4*(1374+u+j*12)
    right; left; omega
  · change 31≠31 ∨ 0+4*(1758+u+j*12)+4 ≤ 0+4*(2174+k) ∨
      0+4*(2174+k)+4 ≤ 0+4*(1758+u+j*12)
    right; left; omega

theorem inputI (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<12) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<32, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<32, Load32 s.heap (addr (croot side) u j 12) (F j)) :
    NttInverseSides203.Input side 4 s (croot side) igm u 12 p p0i tws F := by
  refine ⟨h.uCell,h.slenCell,by exact h.lognCell,h.pCell,h.iCell,?_,h.igmBinding,by omega,by decide,by decide,
    ?_,?_,by decide,?_,?_,?_,twLoads,data⟩
  · cases side <;> first | exact h.fsBinding | exact h.gsBinding
  · cases side <;> rfl
  · cases side
    · change 1374+u+32*12 ≤ 71680; omega
    · change 1758+u+32*12 ≤ 71680; omega
  · cases side <;> exact h.writable
  · intro j k _ _ different
    exact sepI side u j k different
  · intro k _ j slot
    exact tw_sepI side u j k bound slot

theorem sourceI (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<12) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<32, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<32, Load32 s.heap (addr (croot side) u j 12) (F j)) :
    ∃ out, Exec (NttInverseSides203.branch side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ j<32, Load32 out.heap (addr (croot side) u j 12) (scaledWord 4 F tws p p0i j)) ∧
      (∀ q : ArrayPointer, (∀ j<32, Separate (addr (croot side) u j 12) q) →
        ∀ z, Load32 s.heap q z → Load32 out.heap q z) := by
  obtain ⟨out,run,locals,arrays,image,keeps⟩ := NttInverseSides203.branch_source side 4 s (croot side) igm u 12 p p0i tws F
    (inputI side s u p p0i r2 h bound tws F twLoads data) h.inCell h.terCell
  exact ⟨out,run,FifthStepGenerator217.transport h run
    (fun name _ => congrFun locals name) (fun name _ => congrFun arrays name),locals,arrays,image,keeps⟩


end FT1536.Source3.FifthStepMarch217
