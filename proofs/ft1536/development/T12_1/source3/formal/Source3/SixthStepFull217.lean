import Source3.SixthStepExtraLoop217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SixthStepFull217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open SixthStepEntry217 (caller fWords gWords)
open SixthStepCrtBody217 (words22)
open SixthStepLoop217 (rowWords)
open SixthStepExtraInvariant217 (Active)

noncomputable def afterF (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (priorFirst priorExtra : Nat → Fin 64 → BitVec 32)
    (first5 extra5 : Nat → Fin 32 → BitVec 32) (tables : Nat → Fin 16 → BitVec 32) :=
  words22 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5) tables)
 noncomputable def afterG (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (priorFirst priorExtra : Nat → Fin 64 → BitVec 32)
    (first5 extra5 : Nat → Fin 32 → BitVec 32) (tables : Nat → Fin 16 → BitVec 32) :=
  words22 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5) tables)

theorem complete (s mid out : State) (front : Exec SixthStepCrtFirst217.fragment s ⟨mid,.normal⟩)
    (last : Exec MakeFgAddPrimeShape194.part4 mid ⟨out,.normal⟩) :
    Exec (KeygenMakeFgSource.code .step) s ⟨out,.normal⟩ := by
  obtain ⟨afterLoop,earlier,crt⟩:=SecondExtraPair212.normal_seq _ _ s mid front
  obtain ⟨afterPrefix,parts01,loop⟩:=SecondExtraPair212.normal_seq _ _ s afterLoop earlier
  obtain ⟨afterDecl,decl,start⟩:=SecondExtraPair212.normal_seq _ _ s afterPrefix parts01
  exact .seqNormal _ _ _ _ _ decl (.seqNormal _ _ _ _ _ start (.seqNormal _ _ _ _ _ loop
    (.seqNormal _ _ _ _ _ crt (.seqNormal _ _ _ _ _ last (SelectedStepAddPrime195.skip_run out)))))

/- Actual complete d6 source execution and all42 product columns at one output. -/
theorem source : ∃ (callee second third fourth fifth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32)
    (firstTables extraTables : Nat → Fin 16 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SixthStepEntry217.entry (caller callee second third fourth fifth)) ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (caller callee second third fourth fifth)) ⟨out,.normal⟩ ∧
    Active out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5)
      (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables)
      (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables) extraTables 42 := by
  obtain ⟨callee,second,third,fourth,fifth,frontOut,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,
    run1,run2,run3,run4,run5,binding,front,outer,first,fsImage,gsImage,object,revB,revS⟩:=SixthStepCrtFirst217.source
  obtain ⟨out,extraTables,last,active⟩:=SixthStepExtraLoop217.source frontOut
    (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5)
    (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5)
    (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables)
    (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables)
    outer object revB revS fsImage gsImage first
  exact ⟨callee,second,third,fourth,fifth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,
    run1,run2,run3,run4,run5,binding,complete _ _ _ front last,active⟩

end FT1536.Source3.SixthStepFull217
