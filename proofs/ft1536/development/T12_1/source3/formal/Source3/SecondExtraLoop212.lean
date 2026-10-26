import Source3.SecondExtraExit212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondExtraLoop212
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open SecondStepOuter204 (Outer)
open SecondStepLayout197 (fd gd fs gs)
open KeygenFullData127 (primes rev)
open SecondExtraPrime212 (p2 i2 r22 rx2)
open ZintNormWalkFlat208 (Data)
open SecondExtraSide212 (words)
open SecondExtraInner212 (Earlier)

theorem source (s : State) (F G : Nat → BitVec 32) (h : Outer s 2)
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revBinding : s.tables "REV10".toList=some rev) (revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (fdata : Data s fs 512 F) (gdata : Data s gs 512 G) :
    ∃ (out : State) (gvs : Fin 256 → BitVec 32),
      Exec MakeFgAddPrimeShape194.part4 s ⟨out,.normal⟩ ∧ Outer out 3 ∧
      StepProductFixed203.Image out fd 2 3 128 p2 i2 r22 (words F gvs p2 i2 r22 rx2) 128 ∧
      StepProductFixed203.Image out gd 2 3 128 p2 i2 r22 (words G gvs p2 i2 r22 rx2) 128 ∧
      (∀ name : Name, name≠"u".toList → out.locals name=s.locals name) ∧ out.arrays=s.arrays ∧
      (∀ q old, Earlier q → Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨inner,gvs,irun,ib,fdImage,gdImage,ls,ars,keep⟩:=SecondExtraInner212.source s F G h object revBinding revSource fdata gdata
  let out:=SecondExtraExit212.next s inner
  have outer:=SecondExtraExit212.outer s inner h irun ls ars
  have loop : Exec MakeFgAddPrimeShape194.aLoop s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.loop_shape]
    exact .loopNormal _ _ _ s (SecondExtraExit212.scopedState s inner) out _ (.int32 1)
      (SecondExtraExit212.true_guard s h) (by decide) (SecondExtraExit212.scope_source s inner irun)
      (SecondExtraExit212.increment s inner ib.uCell) (by rw [←MakeFgAddPrimeShape194.loop_shape]; exact SecondExtraExit212.loop_end out outer)
  have part : Exec MakeFgAddPrimeShape194.part4 s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.part4_split,MakeFgAddPrimeShape194.aFor_split,MakeFgAddPrimeShape194.aTail_skip]
    exact .seqNormal _ _ _ out _ (.seqNormal _ _ _ s _ (SecondExtraExit212.init_source s h) loop) (SelectedStepAddPrime195.skip_run out)
  exact ⟨out,gvs,part,outer,fdImage,gdImage,SecondExtraExit212.locals s inner ls,SecondExtraExit212.arrays s inner ars,keep⟩

theorem earlier_product (s out : State)
    (keep : ∀ q old, Earlier q → Load32 s.heap q old → Load32 out.heap q old)
    (side : SecondStepCopy203.Side) (u : Nat) (ub : u<2) (p pi r2 : BitVec 32) (fv : Nat → BitVec 32)
    (image : StepProductFixed203.Image s (SecondExtraProduct212.root side) u 3 128 p pi r2 fv 128) :
    StepProductFixed203.Image out (SecondExtraProduct212.root side) u 3 128 p pi r2 fv 128 := by
  intro i bound
  exact keep _ _ (SecondExtraInner212.product_earlier side u i.val ub i.isLt) (image i bound)

end FT1536.Source3.SecondExtraLoop212
