import Source3.FourthStepExtraLoop216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FourthStepFull216
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open FourthStepEntry216 (caller fWords gWords)
open FourthStepCrtBody216 (words6)
open FourthStepLoop216 (rowWords)
open FourthStepExtraInvariant216 (Active)

noncomputable def afterF (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (tables : Nat → Fin 64 → BitVec 32) :=
  words6 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) tables)
 noncomputable def afterG (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (tables : Nat → Fin 64 → BitVec 32) :=
  words6 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) tables)

theorem complete (s mid out : State) (front : Exec FourthStepCrtFirst216.fragment s ⟨mid,.normal⟩)
    (last : Exec MakeFgAddPrimeShape194.part4 mid ⟨out,.normal⟩) :
    Exec (KeygenMakeFgSource.code .step) s ⟨out,.normal⟩ := by
  obtain ⟨afterLoop,earlier,crt⟩:=SecondExtraPair212.normal_seq _ _ s mid front
  obtain ⟨afterPrefix,parts01,loop⟩:=SecondExtraPair212.normal_seq _ _ s afterLoop earlier
  obtain ⟨afterDecl,decl,start⟩:=SecondExtraPair212.normal_seq _ _ s afterPrefix parts01
  exact .seqNormal _ _ _ _ _ decl (.seqNormal _ _ _ _ _ start (.seqNormal _ _ _ _ _ loop
    (.seqNormal _ _ _ _ _ crt (.seqNormal _ _ _ _ _ last (SelectedStepAddPrime195.skip_run out)))))

/- The full original d4 source execution is built from the actual earlier
   calls and input, with all twelve output columns on one witness. -/
theorem source : ∃ (callee second third out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (firstTables extraTables : Nat → Fin 64 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (FourthStepEntry216.entry (caller callee second third)) ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (caller callee second third)) ⟨out,.normal⟩ ∧
    Active out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5)
      (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables)
      (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables) extraTables 12 := by
  obtain ⟨callee,second,third,frontOut,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstTables,
    run1,run2,run3,binding,front,outer,first,fsImage,gsImage,object,revB,revS⟩:=FourthStepCrtFirst216.source
  obtain ⟨out,extraTables,last,active⟩:=FourthStepExtraLoop216.source frontOut
    (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5)
    (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables) (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables)
    outer object revB revS fsImage gsImage first
  exact ⟨callee,second,third,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstTables,extraTables,
    run1,run2,run3,binding,complete _ _ _ front last,active⟩

end FT1536.Source3.FourthStepFull216
