import Source3.SecondStepColumn203
import Source3.MakeFgSplice203
import Source3.SelectedStepOutNtt194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepPair203
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec skip)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (u64)
open StepCopyBody190 (addr elem)
open SecondStepLayout197 (fd gd fs gs t1 igm)
open SecondStepBasic203 (Basic)
open NttInverseWholeBridges201 (scaledWord)
open SecondStepGeometry203 (scratch ordered)

theorem fs_gs (u j v k : Nat) (bound : u<2) (slot : j<256) : Separate (addr fs u j 2) (addr gs v k 2) := by
  change Separate (scratch (1438+u+j*2)) (scratch (1950+v+k*2))
  exact ordered _ _ (by omega)

def fSteps := [MakeFgTailShape190.s0,MakeFgTailShape190.s1,MakeFgTailShape190.s2,MakeFgTailShape190.s3]
def gSteps := [MakeFgTailShape190.s4,MakeFgTailShape190.s5,MakeFgTailShape190.s6,MakeFgTailShape190.s7]

theorem tail_shape : MakeFgTailShape190.r0=MakeFgSequence187.append fSteps
    (MakeFgSequence187.append gSteps (.seq MakeFgTailShape190.s8 skip)) := by
  rw [MakeFgTailShape190.r0_split,MakeFgTailShape190.r1_split,MakeFgTailShape190.r2_split,
    MakeFgTailShape190.r3_split,MakeFgTailShape190.r4_split,MakeFgTailShape190.r5_split,
    MakeFgTailShape190.r6_split,MakeFgTailShape190.r7_split,MakeFgTailShape190.r8_split,
    MakeFgTailShape190.r9_skip]
  rfl

theorem source (s : State) (u : Nat) (p p0i r2 : BitVec 32) (h : Basic s u p p0i r2) (bound : u<2)
    (tws F G : Nat → BitVec 32)
    (twLoads : ∀ k<256, Load32 s.heap (elem igm k) (tws k))
    (fData : ∀ j<256, Load32 s.heap (addr fs u j 2) (F j))
    (gData : ∀ j<256, Load32 s.heap (addr gs u j 2) (G j))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec MakeFgTailShape190.r0 s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧ Cell out "v".toList 128 ∧
      StepProductFixed203.Image out fd u 3 128 p p0i r2 F 128 ∧
      StepProductFixed203.Image out gd u 3 128 p p0i r2 G 128 ∧
      (∀ j<256, Load32 out.heap (addr fs u j 2) (scaledWord 7 F tws p p0i j)) ∧
      (∀ j<256, Load32 out.heap (addr gs u j 2) (scaledWord 7 G tws p p0i j)) ∧
      (∀ k<256, Load32 out.heap (elem igm k) (tws k)) ∧
      (∀ q : ArrayPointer,
        (∀ i : Fin 256, Separate (elem t1 i.val) q) →
        (∀ i : Fin 128, Separate (addr fd u i.val 3) q) →
        (∀ i : Fin 128, Separate (addr gd u i.val 3) q) →
        (∀ j<256, Separate (addr fs u j 2) q) →
        (∀ j<256, Separate (addr gs u j 2) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨first,fRun,fBasic,fV,fProduct,fImage,fKeep⟩ :=
    SecondStepColumn203.source .f s u p p0i r2 h bound tws F twLoads fData old declared
  have twFirst : ∀ k<256, Load32 first.heap (elem igm k) (tws k) := by
    intro k slot
    exact fKeep _ (SecondStepGeometry203.copy_twiddle k slot)
      (fun i => SecondStepGeometry203.product_twiddle .f u i.val k bound i.isLt)
      (fun j jb => SecondStepInverse203.tw_separate .f u j k bound jb) _ (twLoads k slot)
  have gFirst : ∀ k<256, Load32 first.heap (addr gs u k 2) (G k) := by
    intro k slot
    exact fKeep _ (SecondStepGeometry203.copy_data .g u k bound slot)
      (fun i => SecondStepGeometry203.product_data .f .g u i.val u k bound i.isLt)
      (fun j jb => fs_gs u j u k bound jb) _ (gData k slot)
  obtain ⟨out,gRun,outBasic,outV,gProduct,gImage,gKeep⟩ :=
    SecondStepColumn203.source .g first u p p0i r2 fBasic bound tws G twFirst gFirst (some (u64 128)) fV
  have skipped := SelectedStepOutNtt194.source out outBasic.outCell
  have gRaw : Exec (MakeFgSequence187.append gSteps skip) first ⟨out,.normal⟩ := by
    simpa only [gSteps,SecondStepColumn203.g_shape] using gRun
  have gTail := MakeFgSplice203.append gSteps (.seq MakeFgTailShape190.s8 skip) first out ⟨out,.normal⟩ gRaw
    (.seqNormal _ _ out out _ skipped (SelectedStepAddPrime195.skip_run out))
  have fRaw : Exec (MakeFgSequence187.append fSteps skip) s ⟨first,.normal⟩ := by
    simpa only [fSteps,SecondStepColumn203.f_shape] using fRun
  have run : Exec MakeFgTailShape190.r0 s ⟨out,.normal⟩ := by
    rw [tail_shape]
    exact MakeFgSplice203.append fSteps _ s first _ fRaw gTail
  refine ⟨out,run,outBasic,outV,?_,gProduct,?_,gImage,?_,?_⟩
  · intro i slot
    apply gKeep (addr fd u i.val 3) ?_ ?_ ?_ _ (fProduct i slot)
    · intro k
      apply StepCopyFixed190.separate_symm
      change Separate (scratch (670+u+i.val*3)) (scratch (2974+k.val))
      exact ordered _ _ (by have b:=i.isLt; omega)
    · intro k
      apply StepCopyFixed190.separate_symm
      change Separate (scratch (670+u+i.val*3)) (scratch (1054+u+k.val*3))
      exact ordered _ _ (by have b:=i.isLt; omega)
    · intro j _
      apply StepCopyFixed190.separate_symm
      change Separate (scratch (670+u+i.val*3)) (scratch (1950+u+j*2))
      exact ordered _ _ (by have b:=i.isLt; omega)
  · intro j slot
    apply gKeep (addr fs u j 2) (SecondStepGeometry203.copy_data .f u j bound slot)
      (fun i => SecondStepGeometry203.product_data .g .f u i.val u j bound i.isLt)
      (fun k _ => StepCopyFixed190.separate_symm (fs_gs u j u k bound slot)) _ (fImage j slot)
  · intro k slot
    exact gKeep _ (SecondStepGeometry203.copy_twiddle k slot)
      (fun i => SecondStepGeometry203.product_twiddle .g u i.val k bound i.isLt)
      (fun j jb => SecondStepInverse203.tw_separate .g u j k bound jb) _ (twFirst k slot)
  · intro q copySep fdSep gdSep fsSep gsSep w loaded
    exact gKeep q copySep gdSep gsSep w (fKeep q copySep fdSep fsSep w loaded)

end FT1536.Source3.SecondStepPair203
