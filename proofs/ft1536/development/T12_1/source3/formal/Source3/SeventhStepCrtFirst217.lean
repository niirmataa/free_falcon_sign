import Source3.SeventhStepCrtKeep217
import Source3.SeventhStepFirst217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SeventhStepCrtFirst217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open SeventhStepLayout217 (fd gd fs gs)
open SeventhStepEntry217 (caller fWords gWords)
open SeventhStepLoop217 (rowWords)
open SeventhStepLoopBase217 (primeRow col)
open SeventhStepInvariant217 (Active)
open SeventhStepGenerator217 (Outer)
open SeventhStepCrtBody217 (words42)
open CrtPrimePrefix214 (pVal iVal rVal)
open StepProductFixed203 (Image)
open ZintNormWalkFlat208 (Data)

structure FirstProducts (s : State) (F G : Nat → BitVec 32) : Prop where
  f : ∀ k, k<42 → Image s fd k 82 4 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col F k) 4
  g : ∀ k, k<42 → Image s gd k 82 4 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col G k) 4

theorem part3 (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 8 → BitVec 32) (active : Active s F G tables 42) :
    ∃ out, Exec MakeFgCrtShape194.part3 s ⟨out,.normal⟩ ∧ Outer out 42 ∧ FirstProducts out F G ∧
      Data out fs 336 (words42 (rowWords F tables)) ∧ Data out gs 336 (words42 (rowWords G tables)) ∧
      KeygenStaticTables.PrimeObject out.heap primes .ternary ∧ out.tables "REV10".toList=some rev ∧
      KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  obtain ⟨out,run,outer,fsImage,gsImage,object,revB,revS,keep⟩:=
    SeventhStepCrt217.source s (rowWords F tables) (rowWords G tables) active.outer active.object active.revBinding active.revSource
      (SeventhStepLoop217.flatF s F G tables active) (SeventhStepLoop217.flatG s F G tables active)
  refine ⟨out,run,outer,?_,fsImage,gsImage,object,revB,revS⟩
  constructor
  · intro k kb
    exact SeventhStepCrtKeep217.column keep .f k (by omega) _ _ _ _ ((active.written k kb kb).fd)
  · intro k kb
    exact SeventhStepCrtKeep217.column keep .g k (by omega) _ _ _ _ ((active.written k kb kb).gd)

def fragment : KeygenMakeFgSource.Stmt := .seq SeventhStepFirst217.fragment MakeFgCrtShape194.part3

theorem source : ∃ (callee second third fourth fifth sixth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (firstTables extraTables : Nat → Fin 16 → BitVec 32)
    (tables : Nat → Fin 8 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ⟨sixth,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth sixth) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SeventhStepEntry217.entry (caller callee second third fourth fifth sixth)) ∧
    Exec fragment (SeventhStepEntry217.entry (caller callee second third fourth fifth sixth)) ⟨out,.normal⟩ ∧ Outer out 42 ∧
    FirstProducts out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables) ∧
    Data out fs 336 (words42 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables) tables)) ∧
    Data out gs 336 (words42 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables extraTables) tables)) ∧
    KeygenStaticTables.PrimeObject out.heap primes .ternary ∧ out.tables "REV10".toList=some rev ∧
    KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,first,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,tables,
    run1,run2,run3,run4,run5,run6,binding,prefixRun,active,_,_⟩:=SeventhStepFirst217.source
  obtain ⟨out,crt,outer,images,fsImage,gsImage,object,revB,revS⟩:=part3 first _ _ tables active
  exact ⟨callee,second,third,fourth,fifth,sixth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,tables,
    run1,run2,run3,run4,run5,run6,binding,.seqNormal _ _ _ _ _ prefixRun crt,outer,images,fsImage,gsImage,object,revB,revS⟩

end FT1536.Source3.SeventhStepCrtFirst217
