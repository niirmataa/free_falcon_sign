import Source3.EighthStepExtraLoop217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.EighthStepFull217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open EighthStepEntry217 (caller fWords gWords)
open EighthStepCrtBody217 (words82)
open EighthStepLoop217 (rowWords)
open EighthStepExtraInvariant217 (Active)

noncomputable def afterF (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (priorFirst priorExtra : Nat → Fin 64 → BitVec 32)
    (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (first7 extra7 : Nat → Fin 8 → BitVec 32) (tables : Nat → Fin 4 → BitVec 32) :=
  words82 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7) tables)
 noncomputable def afterG (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (priorFirst priorExtra : Nat → Fin 64 → BitVec 32)
    (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (first7 extra7 : Nat → Fin 8 → BitVec 32) (tables : Nat → Fin 4 → BitVec 32) :=
  words82 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7) tables)

theorem complete (s mid out : State) (front : Exec EighthStepCrtFirst217.fragment s ⟨mid,.normal⟩)
    (last : Exec MakeFgAddPrimeShape194.part4 mid ⟨out,.normal⟩) :
    Exec (KeygenMakeFgSource.code .step) s ⟨out,.normal⟩ := by
  obtain ⟨afterLoop,earlier,crt⟩:=SecondExtraPair212.normal_seq _ _ s mid front
  obtain ⟨afterPrefix,parts01,loop⟩:=SecondExtraPair212.normal_seq _ _ s afterLoop earlier
  obtain ⟨afterDecl,decl,start⟩:=SecondExtraPair212.normal_seq _ _ s afterPrefix parts01
  exact .seqNormal _ _ _ _ _ decl (.seqNormal _ _ _ _ _ start (.seqNormal _ _ _ _ _ loop
    (.seqNormal _ _ _ _ _ crt (.seqNormal _ _ _ _ _ last (SelectedStepAddPrime195.skip_run out)))))

/- Actual complete d8 source execution and all166 product columns at one output. -/
theorem source : ∃ (callee second third fourth fifth sixth seventh out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (first7 extra7 : Nat → Fin 8 → BitVec 32)
    (firstTables extraTables : Nat → Fin 4 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ⟨sixth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth)) ⟨seventh,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth sixth seventh) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (EighthStepEntry217.entry (caller callee second third fourth fifth sixth seventh)) ∧
    Exec (KeygenMakeFgSource.code .step) (EighthStepEntry217.entry (caller callee second third fourth fifth sixth seventh)) ⟨out,.normal⟩ ∧
    Active out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7)
      (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 firstTables)
      (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 firstTables) extraTables 166 := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,frontOut,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,firstTables,
    run1,run2,run3,run4,run5,run6,run7,binding,front,outer,first,fsImage,gsImage,object,revB,revS⟩:=EighthStepCrtFirst217.source
  obtain ⟨out,extraTables,last,active⟩:=EighthStepExtraLoop217.source frontOut
    (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7)
    (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7)
    (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 firstTables)
    (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 firstTables)
    outer object revB revS fsImage gsImage first
  exact ⟨callee,second,third,fourth,fifth,sixth,seventh,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,run7,binding,complete _ _ _ front last,active⟩

end FT1536.Source3.EighthStepFull217
