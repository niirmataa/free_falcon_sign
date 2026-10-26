import Source3.SecondStepOutside204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepOneBody204
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open StepCopyBody190 (addr elem)
open SecondStepLayout197 (fd gd fs gs gm igm t1)
open SecondStepOuter204 (Outer)
open SecondStepBasic203 (Basic)
open SecondStepFirstColumn203 (tableWord)
open NttInverseWholeBridges201 (scaledWord)

theorem source (s : State) (h : Outer s 1) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revBinding : s.tables "REV10".toList=some rev) (revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (F G : Nat → BitVec 32)
    (fData : ∀ j<256, Load32 s.heap (addr fs 1 j 2) (F j))
    (gData : ∀ j<256, Load32 s.heap (addr gs 1 j 2) (G j)) :
    ∃ (out : State) (ivs : Fin 256 → BitVec 32),
      Exec StepPrimeShape188.inner s ⟨out,.normal⟩ ∧ Basic out 1 p1 p0i1 r21 ∧
      StepProductFixed203.Image out fd 1 3 128 p1 p0i1 r21 F 128 ∧
      StepProductFixed203.Image out gd 1 3 128 p1 p0i1 r21 G 128 ∧
      (∀ j<256, Load32 out.heap (addr fs 1 j 2) (scaledWord 7 F (tableWord ivs) p1 p0i1 j)) ∧
      (∀ j<256, Load32 out.heap (addr gs 1 j 2) (scaledWord 7 G (tableWord ivs) p1 p0i1 j)) ∧
      (∀ q : ArrayPointer, MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
        (∀ i : Fin 256, Word32Memory176.Separate (elem t1 i.val) q) →
        (∀ i : Fin 128, Word32Memory176.Separate (addr fd 1 i.val 3) q) →
        (∀ i : Fin 128, Word32Memory176.Separate (addr gd 1 i.val 3) q) →
        (∀ j<256, Word32Memory176.Separate (addr fs 1 j 2) q) →
        (∀ j<256, Word32Memory176.Separate (addr gs 1 j 2) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨generated,gvs,ivs,genRun,basic,v,gRead,iRead,genKeep⟩ :=
    SecondStepGeneratorOne204.source s h object revBinding revSource
  have twLoads : ∀ k<256, Load32 generated.heap (elem igm k) (tableWord ivs k) := by
    intro k bound
    simpa only [tableWord,Nat.mod_eq_of_lt bound,StepCopyBody190.elem,KeygenSmallOutput.element] using iRead ⟨k,bound⟩
  have fReady : ∀ j<256, Load32 generated.heap (addr fs 1 j 2) (F j) := by
    intro j bound
    have outside:=SecondStepOutside204.data .f 1 j (by decide) bound
    exact genKeep _ outside.1 outside.2 _ (fData j bound)
  have gReady : ∀ j<256, Load32 generated.heap (addr gs 1 j 2) (G j) := by
    intro j bound
    have outside:=SecondStepOutside204.data .g 1 j (by decide) bound
    exact genKeep _ outside.1 outside.2 _ (gData j bound)
  obtain ⟨out,tailRun,outBasic,_,fdProduct,gdProduct,fImage,gImage,_,pairKeep⟩ :=
    SecondStepPair203.source generated 1 p1 p0i1 r21 basic (by decide) (tableWord ivs) F G twLoads fReady gReady none v
  have inner : Exec StepPrimeShape188.inner s ⟨out,.normal⟩ := by
    rw [StepPrimeShape188.prefix_shape]
    apply SecondStepPrimeOne204.append_source s h object
    rw [StepPrimeShape188.remaining_shape]
    exact .seqNormal _ _ (SecondStepGeneratorOne204.before s) generated _ genRun tailRun
  refine ⟨out,ivs,inner,outBasic,fdProduct,gdProduct,fImage,gImage,?_⟩
  intro q gOutside iOutside copySep fdSep gdSep fsSep gsSep w loaded
  exact pairKeep q copySep fdSep gdSep fsSep gsSep w (genKeep q gOutside iOutside w loaded)

end FT1536.Source3.SecondStepOneBody204
