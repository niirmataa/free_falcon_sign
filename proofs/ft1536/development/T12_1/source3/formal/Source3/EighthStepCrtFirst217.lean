import Source3.EighthStepCrtKeep217
import Source3.EighthStepFirst217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.EighthStepCrtFirst217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open EighthStepLayout217 (fd gd fs gs)
open EighthStepEntry217 (caller fWords gWords)
open EighthStepLoop217 (rowWords)
open EighthStepLoopBase217 (primeRow col)
open EighthStepInvariant217 (Active)
open EighthStepGenerator217 (Outer)
open EighthStepCrtBody217 (words82)
open CrtPrimePrefix214 (pVal iVal rVal)
open StepProductFixed203 (Image)
open ZintNormWalkFlat208 (Data)

structure FirstProducts (s : State) (F G : Nat → BitVec 32) : Prop where
  f : ∀ k, k<82 → Image s fd k 166 2 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col F k) 2
  g : ∀ k, k<82 → Image s gd k 166 2 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col G k) 2

theorem part3 (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 4 → BitVec 32) (active : Active s F G tables 82) :
    ∃ out, Exec MakeFgCrtShape194.part3 s ⟨out,.normal⟩ ∧ Outer out 82 ∧ FirstProducts out F G ∧
      Data out fs 328 (words82 (rowWords F tables)) ∧ Data out gs 328 (words82 (rowWords G tables)) ∧
      KeygenStaticTables.PrimeObject out.heap primes .ternary ∧ out.tables "REV10".toList=some rev ∧
      KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  obtain ⟨out,run,outer,fsImage,gsImage,object,revB,revS,keep⟩:=
    EighthStepCrt217.source s (rowWords F tables) (rowWords G tables) active.outer active.object active.revBinding active.revSource
      (EighthStepLoop217.flatF s F G tables active) (EighthStepLoop217.flatG s F G tables active)
  refine ⟨out,run,outer,?_,fsImage,gsImage,object,revB,revS⟩
  constructor
  · intro k kb
    exact EighthStepCrtKeep217.column keep .f k (by omega) _ _ _ _ ((active.written k kb kb).fd)
  · intro k kb
    exact EighthStepCrtKeep217.column keep .g k (by omega) _ _ _ _ ((active.written k kb kb).gd)

def fragment : KeygenMakeFgSource.Stmt := .seq EighthStepFirst217.fragment MakeFgCrtShape194.part3

theorem source : ∃ (callee second third fourth fifth sixth seventh out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (first7 extra7 : Nat → Fin 8 → BitVec 32)
    (tables : Nat → Fin 4 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ⟨sixth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth)) ⟨seventh,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth sixth seventh) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (EighthStepEntry217.entry (caller callee second third fourth fifth sixth seventh)) ∧
    Exec fragment (EighthStepEntry217.entry (caller callee second third fourth fifth sixth seventh)) ⟨out,.normal⟩ ∧ Outer out 82 ∧
    FirstProducts out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7)
      (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7) ∧
    Data out fs 328 (words82 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7) tables)) ∧
    Data out gs 328 (words82 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7) tables)) ∧
    KeygenStaticTables.PrimeObject out.heap primes .ternary ∧ out.tables "REV10".toList=some rev ∧
    KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,first,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,tables,
    run1,run2,run3,run4,run5,run6,run7,binding,prefixRun,active,_,_⟩:=EighthStepFirst217.source
  obtain ⟨out,crt,outer,images,fsImage,gsImage,object,revB,revS⟩:=part3 first _ _ tables active
  exact ⟨callee,second,third,fourth,fifth,sixth,seventh,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,tables,
    run1,run2,run3,run4,run5,run6,run7,binding,.seqNormal _ _ _ _ _ prefixRun crt,outer,images,fsImage,gsImage,object,revB,revS⟩

end FT1536.Source3.EighthStepCrtFirst217
