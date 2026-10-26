import Source3.SecondStepProduct203
import Source3.NttInverseSides203

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepInverse203
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec)
open SecondStepCopy203 (Side root)
open SecondStepBasic203 (Basic)
open SecondStepLayout197 (igm)
open StepCopyBody190 (addr elem)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)

theorem separate (side : Side) (u j k : Nat) (different : j≠k) :
    Separate (walk (elem (root side) u) j 2) (walk (elem (root side) u) k 2) := by
  cases side
  · change 31≠31 ∨ 0+4*(1438+u+j*2)+4 ≤ 0+4*(1438+u+k*2) ∨
      0+4*(1438+u+k*2)+4 ≤ 0+4*(1438+u+j*2)
    omega
  · change 31≠31 ∨ 0+4*(1950+u+j*2)+4 ≤ 0+4*(1950+u+k*2) ∨
      0+4*(1950+u+k*2)+4 ≤ 0+4*(1950+u+j*2)
    omega

theorem tw_separate (side : Side) (u j k : Nat) (bound : u<2) (slot : j<256) :
    Separate (walk (elem (root side) u) j 2) (elem igm k) := by
  cases side
  · change 31≠31 ∨ 0+4*(1438+u+j*2)+4 ≤ 0+4*(2718+k) ∨
      0+4*(2718+k)+4 ≤ 0+4*(1438+u+j*2)
    right; left; omega
  · change 31≠31 ∨ 0+4*(1950+u+j*2)+4 ≤ 0+4*(2718+k) ∨
      0+4*(2718+k)+4 ≤ 0+4*(1950+u+j*2)
    right; left; omega

theorem input (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<2) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<256, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<256, Load32 s.heap (addr (root side) u j 2) (F j)) :
    NttInverseSides203.Input side 7 s (root side) igm u 2 p p0i tws F := by
  refine ⟨h.uCell,h.slenCell,h.lognCell,h.pCell,h.iCell,?_,h.igmBinding,by omega,by decide,by decide,
    ?_,?_,by decide,?_,?_,?_,twLoads,data⟩
  · cases side <;> first | exact h.fsBinding | exact h.gsBinding
  · cases side <;> rfl
  · cases side
    · change 1438+u+256*2 ≤ 71680; omega
    · change 1950+u+256*2 ≤ 71680; omega
  · cases side <;> exact h.writable
  · intro j k _ _ different
    exact separate side u j k different
  · intro k _ j slot
    exact tw_separate side u j k bound slot

theorem source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<2) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<256, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<256, Load32 s.heap (addr (root side) u j 2) (F j)) :
    ∃ out, Exec (NttInverseSides203.branch side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ j<256, Load32 out.heap (addr (root side) u j 2) (scaledWord 7 F tws p p0i j)) ∧
      (∀ q : ArrayPointer, (∀ j<256, Separate (addr (root side) u j 2) q) →
        ∀ z, Load32 s.heap q z → Load32 out.heap q z) := by
  obtain ⟨out,run,locals,arrays,image,keeps⟩ := NttInverseSides203.branch_source side 7 s (root side) igm u 2 p p0i tws F
    (input side s u p p0i r2 h bound tws F twLoads data) h.inCell h.terCell
  exact ⟨out,run,SecondStepBasic203.transport h run
    (fun name _ => congrFun locals name) (fun name _ => congrFun arrays name),locals,arrays,image,keeps⟩

end FT1536.Source3.SecondStepInverse203
