import Source3.SecondStepCrtDomain208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepCrtPair208
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepLayout197 (fs gs gm)
open SecondStepCopy203 (Side)
open SecondStepOuter204 (Outer)
open KeygenFullData127 (primes)
open ZintNormWalkFlat208 (Data)
open KeygenMakeFgSource (Exec)

def Keeps (before after : State) : Prop :=
  ∀ q old, (∀ i, i < 512 → Separate (elem fs i) q) → (∀ i, i < 512 → Separate (elem gs i) q) →
    Separate gm q → Separate (ZintAddMulWord205.next gm) q → Load32 before.heap q old → Load32 after.heap q old

theorem source (s : State) (FW GW : Nat → BitVec 32) (outer : Outer s 2)
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (fdata : Data s fs 512 FW) (gdata : Data s gs 512 GW) :
    ∃ out, Exec MakeFgCrtShape194.part3 s ⟨out,.normal⟩ ∧ Outer out 2 ∧
      Data out fs 512 (CrtBody208.words FW) ∧ Data out gs 512 (CrtBody208.words GW) ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧ Keeps s out := by
  obtain ⟨fOut,fCall,fImage,fLocals,fArrays,fKeep⟩:=CrtCall208.source "fs" s fs gm FW
    outer.fsBinding outer.gmBinding outer.primesBinding outer.slenCell outer.nCell
    (SecondStepCrtDomain208.domain .f s 2 outer object) fdata
  have fStable:=KeygenMemoryStability.zint _ _ _ fCall
  have fOuter:=SecondStepCrtDomain208.outer s fOut 2 outer fLocals fArrays fStable
  have fObject:=SecondStepCrtDomain208.prime_object s fOut _ fCall object
  have gDataAtF : Data fOut gs 512 GW := by
    intro j bound
    exact fKeep _ _ (fun i ib => SecondStepCrtDomain208.cross i j ib)
      (SecondStepCrtDomain208.data_tmp .g j 0 bound) (SecondStepCrtDomain208.data_tmp .g j 1 bound) (gdata j bound)
  obtain ⟨out,gCall,gImage,gLocals,gArrays,gKeep⟩:=CrtCall208.source "gs" fOut gs gm GW
    fOuter.gsBinding fOuter.gmBinding fOuter.primesBinding fOuter.slenCell fOuter.nCell
    (SecondStepCrtDomain208.domain .g fOut 2 fOuter fObject) gDataAtF
  have finalOuter:=SecondStepCrtDomain208.outer fOut out 2 fOuter gLocals gArrays (KeygenMemoryStability.zint _ _ _ gCall)
  have fDataAtG : Data out fs 512 (CrtBody208.words FW) := by
    intro j bound
    exact gKeep _ _ (fun i _ => StepCopyFixed203.separate_symm (SecondStepCrtDomain208.cross j i bound))
      (SecondStepCrtDomain208.data_tmp .f j 0 bound) (SecondStepCrtDomain208.data_tmp .f j 1 bound) (fImage j bound)
  have first : Exec MakeFgCrtShape194.first3 s ⟨fOut,.normal⟩ := by
    rw [MakeFgCrtShape194.first3_shape]
    exact .zint _ _ _ fCall
  have second : Exec MakeFgCrtShape194.second3 fOut ⟨out,.normal⟩ := by
    rw [MakeFgCrtShape194.second3_shape]
    exact .zint _ _ _ gCall
  have last : Exec MakeFgCrtShape194.tail3 out ⟨out,.normal⟩ := by
    rw [MakeFgCrtShape194.tail3_skip]
    exact MakeFgDeclarations176.array_source .skip out out (.skip out)
  have full : Exec MakeFgCrtShape194.part3 s ⟨out,.normal⟩ := by
    rw [MakeFgCrtShape194.part3_split,MakeFgCrtShape194.rest3_split]
    exact .seqNormal _ _ _ _ _ first (.seqNormal _ _ _ _ _ second last)
  refine ⟨out,full,finalOuter,fDataAtG,gImage,gLocals.trans fLocals,gArrays.trans fArrays,?_⟩
  intro q old fApart gApart tmpApart highApart read
  exact gKeep q old gApart tmpApart highApart (fKeep q old fApart tmpApart highApart read)

theorem product (s out : State) (keep : Keeps s out) (side : Side) (u : Nat) (ub : u < 2)
    (p pi r2 : BitVec 32) (fv : Nat → BitVec 32)
    (image : StepProductFixed203.Image s (SecondStepProduct203.root side) u 3 128 p pi r2 fv 128) :
    StepProductFixed203.Image out (SecondStepProduct203.root side) u 3 128 p pi r2 fv 128 := by
  intro j bound
  exact keep _ _ (fun i _ => SecondStepCrtDomain208.data_product .f side i u j.val ub j.isLt)
    (fun i _ => SecondStepCrtDomain208.data_product .g side i u j.val ub j.isLt)
    (SecondStepCrtDomain208.tmp_product side 0 u j.val ub j.isLt)
    (SecondStepCrtDomain208.tmp_product side 1 u j.val ub j.isLt) (image j bound)

end FT1536.Source3.SecondStepCrtPair208
