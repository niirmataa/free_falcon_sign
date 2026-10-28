import Source3.EighthStepColumn217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- d8 pair layer of the original first-prime source loop. -/
namespace FT1536.Source3.EighthStepMarch217
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
open EighthStepLayout217 (fd gd fs gs gm igm t1)
open EighthStepGenerator217 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open EighthStepProduct217 (root)

/- Both sides and the false !out_ntt skip: the complete loop tail. -/
theorem tail_shape : MakeFgTailShape190.r0=MakeFgSequence187.append SecondStepPair203.fSteps
    (MakeFgSequence187.append SecondStepPair203.gSteps (.seq MakeFgTailShape190.s8 KeygenMakeFgSource.skip)) :=
  SecondStepPair203.tail_shape

theorem out_skip (s : State) (p p0i r2 : BitVec 32) (h : Basic s u p p0i r2) :
    Exec MakeFgTailShape190.s8 s ⟨s,.normal⟩ := by
  exact SelectedStepOutNtt194.source s h.outCell

theorem sourcePair (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<82) (tws F G : Nat → BitVec 32)
    (twLoads : ∀ k<4, Load32 s.heap (elem igm k) (tws k))
    (fData : ∀ j<4, Load32 s.heap (addr fs u j 82) (F j))
    (gData : ∀ j<4, Load32 s.heap (addr gs u j 82) (G j))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec MakeFgTailShape190.r0 s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧ Cell out "v".toList 2 ∧
      Image out fd u 166 2 p p0i r2 F 2 ∧ Image out gd u 166 2 p p0i r2 G 2 ∧
      (∀ j<4, Load32 out.heap (addr fs u j 82) (scaledWord 1 F tws p p0i j)) ∧
      (∀ j<4, Load32 out.heap (addr gs u j 82) (scaledWord 1 G tws p p0i j)) ∧
      (∀ k<4, Load32 out.heap (elem igm k) (tws k)) ∧
      (∀ q : ArrayPointer,
        (∀ i : Fin 4, Separate (elem t1 i.val) q) →
        (∀ i : Fin 2, Separate (addr fd u i.val 166) q) →
        (∀ i : Fin 2, Separate (addr gd u i.val 166) q) →
        (∀ j<4, Separate (addr fs u j 82) q) →
        (∀ j<4, Separate (addr gs u j 82) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨first,fRun,fBasic,fV,fProduct,fImage,fKeep⟩ :=
    sourceCol .f s u p p0i r2 h bound tws F twLoads fData old declared
  have twFirst : ∀ k<4, Load32 first.heap (elem igm k) (tws k) := by
    intro k slot
    exact fKeep _ (copy_twiddle k slot) (fun i => product_twiddle .f u i.val k bound i.isLt)
      (fun j jb => tw_sepI .f u j k bound jb) _ (twLoads k slot)
  have gFirst : ∀ k<4, Load32 first.heap (addr gs u k 82) (G k) := by
    intro k slot
    exact fKeep _ (copy_data .g u k bound slot) (fun i => product_data .f .g u i.val u k bound i.isLt)
      (fun j jb => fs_gs u j u k bound jb) _ (gData k slot)
  obtain ⟨out,gRun,outBasic,outV,gProduct,gImage,gKeep⟩ :=
    sourceCol .g first u p p0i r2 fBasic bound tws G twFirst gFirst (some (u64 2)) fV
  have skipped := out_skip out p p0i r2 outBasic
  have gRaw : Exec (MakeFgSequence187.append SecondStepPair203.gSteps KeygenMakeFgSource.skip) first ⟨out,.normal⟩ := by
    simpa only [SecondStepPair203.gSteps,SecondStepColumn203.g_shape] using gRun
  have gTail := MakeFgSplice203.append SecondStepPair203.gSteps (.seq MakeFgTailShape190.s8 KeygenMakeFgSource.skip)
    first out ⟨out,.normal⟩ gRaw
    (.seqNormal _ _ out out _ skipped (SelectedStepAddPrime195.skip_run out))
  have fRaw : Exec (MakeFgSequence187.append SecondStepPair203.fSteps KeygenMakeFgSource.skip) s ⟨first,.normal⟩ := by
    simpa only [SecondStepPair203.fSteps,SecondStepColumn203.f_shape] using fRun
  have run : Exec MakeFgTailShape190.r0 s ⟨out,.normal⟩ := by
    rw [tail_shape]
    exact MakeFgSplice203.append SecondStepPair203.fSteps _ s first _ fRaw gTail
  refine ⟨out,run,outBasic,outV,?_,gProduct,?_,gImage,?_,?_⟩
  · intro i bound'
    exact gKeep _ (fun j => StepCopyFixed190.separate_symm (product_t1 .f u i.val j.val bound i.isLt j.isLt))
      (fun j => StepCopyFixed190.separate_symm (product_cross u u i.val j.val bound bound i.isLt j.isLt))
      (fun j _ => StepCopyFixed190.separate_symm (product_data .f .g u i.val u j bound i.isLt))
      _ (fProduct i bound')
  · intro j bound'
    exact gKeep _ (fun i => copy_data .f u j bound bound' i)
      (fun i => product_data .g .f u i.val u j bound i.isLt)
      (fun i _ => StepCopyFixed190.separate_symm (fs_gs u j u i bound bound')) _ (fImage j bound')
  · intro k slot
    exact gKeep _ (fun i => copy_twiddle k slot i)
      (fun i => product_twiddle .g u i.val k bound i.isLt)
      (fun j b => tw_sepI .g u j k bound b) _ (twFirst k slot)
  · intro q tSep fdSep gdSep fsSep gsSep w loaded
    exact gKeep q tSep (fun i => gdSep i) (fun j => gsSep j) w (fKeep q tSep (fun i => fdSep i) (fun j => fsSep j) w loaded)

end FT1536.Source3.EighthStepMarch217
