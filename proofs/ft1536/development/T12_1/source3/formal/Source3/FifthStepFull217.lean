import Source3.FifthStepExtraLoop217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FifthStepFull217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open FifthStepEntry217 (caller fWords gWords)
open FifthStepCrtBody217 (words12)
open FifthStepLoop217 (rowWords)
open FifthStepExtraInvariant217 (Active)

noncomputable def afterF (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (priorFirst priorExtra : Nat → Fin 64 → BitVec 32)
    (tables : Nat → Fin 32 → BitVec 32) :=
  words12 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra) tables)
 noncomputable def afterG (old : Fin 512 → BitVec 32) (iv0 iv1 gv2 : Fin 256 → BitVec 32)
    (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32) (priorFirst priorExtra : Nat → Fin 64 → BitVec 32)
    (tables : Nat → Fin 32 → BitVec 32) :=
  words12 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra) tables)

theorem complete (s mid out : State) (front : Exec FifthStepCrtFirst217.fragment s ⟨mid,.normal⟩)
    (last : Exec MakeFgAddPrimeShape194.part4 mid ⟨out,.normal⟩) :
    Exec (KeygenMakeFgSource.code .step) s ⟨out,.normal⟩ := by
  obtain ⟨afterLoop,earlier,crt⟩:=SecondExtraPair212.normal_seq _ _ s mid front
  obtain ⟨afterPrefix,parts01,loop⟩:=SecondExtraPair212.normal_seq _ _ s afterLoop earlier
  obtain ⟨afterDecl,decl,start⟩:=SecondExtraPair212.normal_seq _ _ s afterPrefix parts01
  exact .seqNormal _ _ _ _ _ decl (.seqNormal _ _ _ _ _ start (.seqNormal _ _ _ _ _ loop
    (.seqNormal _ _ _ _ _ crt (.seqNormal _ _ _ _ _ last (SelectedStepAddPrime195.skip_run out)))))

/- Actual complete d5 source execution and all22 product columns at one output. -/
theorem source : ∃ (callee second third fourth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (firstTables extraTables : Nat → Fin 32 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (FifthStepEntry217.entry (caller callee second third fourth)) ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (caller callee second third fourth)) ⟨out,.normal⟩ ∧
    Active out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra)
      (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables)
      (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables) extraTables 22 := by
  obtain ⟨callee,second,third,fourth,frontOut,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,firstTables,
    run1,run2,run3,run4,binding,front,outer,first,fsImage,gsImage,object,revB,revS⟩:=FifthStepCrtFirst217.source
  obtain ⟨out,extraTables,last,active⟩:=FifthStepExtraLoop217.source frontOut
    (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra) (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra)
    (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables)
    (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables)
    outer object revB revS fsImage gsImage first
  exact ⟨callee,second,third,fourth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,firstTables,extraTables,
    run1,run2,run3,run4,binding,complete _ _ _ front last,active⟩

end FT1536.Source3.FifthStepFull217
