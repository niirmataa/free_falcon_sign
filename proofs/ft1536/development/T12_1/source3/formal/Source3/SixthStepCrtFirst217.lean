import Source3.SixthStepCrtKeep217
import Source3.SixthStepFirst217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SixthStepCrtFirst217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open SixthStepLayout217 (fd gd fs gs)
open SixthStepEntry217 (caller fWords gWords)
open SixthStepLoop217 (rowWords)
open SixthStepLoopBase217 (primeRow col)
open SixthStepInvariant217 (Active)
open SixthStepGenerator217 (Outer)
open SixthStepCrtBody217 (words22)
open CrtPrimePrefix214 (pVal iVal rVal)
open StepProductFixed203 (Image)
open ZintNormWalkFlat208 (Data)

structure FirstProducts (s : State) (F G : Nat → BitVec 32) : Prop where
  f : ∀ k, k<22 → Image s fd k 42 8 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col F k) 8
  g : ∀ k, k<22 → Image s gd k 42 8 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col G k) 8

theorem part3 (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 16 → BitVec 32) (active : Active s F G tables 22) :
    ∃ out, Exec MakeFgCrtShape194.part3 s ⟨out,.normal⟩ ∧ Outer out 22 ∧ FirstProducts out F G ∧
      Data out fs 352 (words22 (rowWords F tables)) ∧ Data out gs 352 (words22 (rowWords G tables)) ∧
      KeygenStaticTables.PrimeObject out.heap primes .ternary ∧ out.tables "REV10".toList=some rev ∧
      KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  obtain ⟨out,run,outer,fsImage,gsImage,object,revB,revS,keep⟩:=
    SixthStepCrt217.source s (rowWords F tables) (rowWords G tables) active.outer active.object active.revBinding active.revSource
      (SixthStepLoop217.flatF s F G tables active) (SixthStepLoop217.flatG s F G tables active)
  refine ⟨out,run,outer,?_,fsImage,gsImage,object,revB,revS⟩
  constructor
  · intro k kb
    exact SixthStepCrtKeep217.column keep .f k (by omega) _ _ _ _ ((active.written k kb kb).fd)
  · intro k kb
    exact SixthStepCrtKeep217.column keep .g k (by omega) _ _ _ _ ((active.written k kb kb).gd)

def fragment : KeygenMakeFgSource.Stmt := .seq SixthStepFirst217.fragment MakeFgCrtShape194.part3

theorem source : ∃ (callee second third fourth fifth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (firstTables extraTables : Nat → Fin 32 → BitVec 32)
    (tables : Nat → Fin 16 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SixthStepEntry217.entry (caller callee second third fourth fifth)) ∧
    Exec fragment (SixthStepEntry217.entry (caller callee second third fourth fifth)) ⟨out,.normal⟩ ∧ Outer out 22 ∧
    FirstProducts out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables) ∧
    Data out fs 352 (words22 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables) tables)) ∧
    Data out gs 352 (words22 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra firstTables extraTables) tables)) ∧
    KeygenStaticTables.PrimeObject out.heap primes .ternary ∧ out.tables "REV10".toList=some rev ∧
    KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  obtain ⟨callee,second,third,fourth,fifth,first,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,firstTables,extraTables,tables,
    run1,run2,run3,run4,run5,binding,prefixRun,active,_,_⟩:=SixthStepFirst217.source
  obtain ⟨out,crt,outer,images,fsImage,gsImage,object,revB,revS⟩:=part3 first _ _ tables active
  exact ⟨callee,second,third,fourth,fifth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,firstTables,extraTables,tables,
    run1,run2,run3,run4,run5,binding,.seqNormal _ _ _ _ _ prefixRun crt,outer,images,fsImage,gsImage,object,revB,revS⟩

end FT1536.Source3.SixthStepCrtFirst217
