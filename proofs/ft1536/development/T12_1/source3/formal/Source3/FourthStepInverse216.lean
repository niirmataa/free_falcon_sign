import Source3.FourthStepCopy216

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

/- The iNTT3_ext column visits at Level 5 / stride 6. -/
theorem sepI (side : Side) (u j k : Nat) (different : j≠k) :
    Separate (walk (elem (croot side) u) j 6) (walk (elem (croot side) u) k 6) := by
  cases side
  · change 31≠31 ∨ 0+4*(1438+u+j*6)+4 ≤ 0+4*(1438+u+k*6) ∨
      0+4*(1438+u+k*6)+4 ≤ 0+4*(1438+u+j*6)
    omega
  · change 31≠31 ∨ 0+4*(1822+u+j*6)+4 ≤ 0+4*(1822+u+k*6) ∨
      0+4*(1822+u+k*6)+4 ≤ 0+4*(1822+u+j*6)
    omega

theorem tw_sepI (side : Side) (u j k : Nat) (bound : u<6) (slot : j<64) :
    Separate (walk (elem (croot side) u) j 6) (elem igm k) := by
  cases side
  · change 31≠31 ∨ 0+4*(1438+u+j*6)+4 ≤ 0+4*(2270+k) ∨
      0+4*(2270+k)+4 ≤ 0+4*(1438+u+j*6)
    right; left; omega
  · change 31≠31 ∨ 0+4*(1822+u+j*6)+4 ≤ 0+4*(2270+k) ∨
      0+4*(2270+k)+4 ≤ 0+4*(1822+u+j*6)
    right; left; omega

theorem inputI (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<6) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<64, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<64, Load32 s.heap (addr (croot side) u j 6) (F j)) :
    NttInverseSides203.Input side 5 s (croot side) igm u 6 p p0i tws F := by
  refine ⟨h.uCell,h.slenCell,by exact h.lognCell,h.pCell,h.iCell,?_,h.igmBinding,by omega,by decide,by decide,
    ?_,?_,by decide,?_,?_,?_,twLoads,data⟩
  · cases side <;> first | exact h.fsBinding | exact h.gsBinding
  · cases side <;> rfl
  · cases side
    · change 1438+u+64*6 ≤ 71680; omega
    · change 1822+u+64*6 ≤ 71680; omega
  · cases side <;> exact h.writable
  · intro j k _ _ different
    exact sepI side u j k different
  · intro k _ j slot
    exact tw_sepI side u j k bound slot

theorem sourceI (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<6) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<64, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<64, Load32 s.heap (addr (croot side) u j 6) (F j)) :
    ∃ out, Exec (NttInverseSides203.branch side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ j<64, Load32 out.heap (addr (croot side) u j 6) (scaledWord 5 F tws p p0i j)) ∧
      (∀ q : ArrayPointer, (∀ j<64, Separate (addr (croot side) u j 6) q) →
        ∀ z, Load32 s.heap q z → Load32 out.heap q z) := by
  obtain ⟨out,run,locals,arrays,image,keeps⟩ := NttInverseSides203.branch_source side 5 s (croot side) igm u 6 p p0i tws F
    (inputI side s u p p0i r2 h bound tws F twLoads data) h.inCell h.terCell
  exact ⟨out,run,FourthStepGenerator216.transport h run
    (fun name _ => congrFun locals name) (fun name _ => congrFun arrays name),locals,arrays,image,keeps⟩


end FT1536.Source3.FourthStepMarch216
