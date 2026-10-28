import Source3.FourthStepCrtKeep216
import Source3.FourthStepFirst216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FourthStepCrtFirst216
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open FourthStepLayout216 (fd gd fs gs)
open FourthStepEntry216 (caller fWords gWords)
open FourthStepLoop216 (rowWords)
open FourthStepLoopBase216 (primeRow col)
open FourthStepInvariant216 (Active)
open FourthStepGenerator216 (Outer)
open FourthStepCrtBody216 (words6)
open CrtPrimePrefix214 (pVal iVal rVal)
open StepProductFixed203 (Image)
open ZintNormWalkFlat208 (Data)

structure FirstProducts (s : State) (F G : Nat → BitVec 32) : Prop where
  f : ∀ k, k<6 → Image s fd k 12 32 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col F k) 32
  g : ∀ k, k<6 → Image s gd k 12 32 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col G k) 32

theorem part3 (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 64 → BitVec 32) (active : Active s F G tables 6) :
    ∃ out, Exec MakeFgCrtShape194.part3 s ⟨out,.normal⟩ ∧ Outer out 6 ∧ FirstProducts out F G ∧
      Data out fs 384 (words6 (rowWords F tables)) ∧ Data out gs 384 (words6 (rowWords G tables)) ∧
      KeygenStaticTables.PrimeObject out.heap primes .ternary ∧ out.tables "REV10".toList=some rev ∧
      KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  obtain ⟨out,run,outer,fsImage,gsImage,object,revB,revS,keep⟩:=
    FourthStepCrt216.source s (rowWords F tables) (rowWords G tables) active.outer active.object active.revBinding active.revSource
      (FourthStepLoop216.flatF s F G tables active) (FourthStepLoop216.flatG s F G tables active)
  refine ⟨out,run,outer,?_,fsImage,gsImage,object,revB,revS⟩
  constructor
  · intro k kb
    exact FourthStepCrtKeep216.column keep .f k (by omega) _ _ _ _ ((active.written k kb kb).fd)
  · intro k kb
    exact FourthStepCrtKeep216.column keep .g k (by omega) _ _ _ _ ((active.written k kb kb).gd)

def fragment : KeygenMakeFgSource.Stmt := .seq FourthStepFirst216.fragment MakeFgCrtShape194.part3

theorem source : ∃ (callee second third out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (tables : Nat → Fin 64 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (FourthStepEntry216.entry (caller callee second third)) ∧
    Exec fragment (FourthStepEntry216.entry (caller callee second third)) ⟨out,.normal⟩ ∧ Outer out 6 ∧
    FirstProducts out (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) ∧
    Data out fs 384 (words6 (rowWords (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) tables)) ∧
    Data out gs 384 (words6 (rowWords (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5) tables)) ∧
    KeygenStaticTables.PrimeObject out.heap primes .ternary ∧ out.tables "REV10".toList=some rev ∧
    KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  obtain ⟨callee,second,third,first,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,tables,run1,run2,run3,binding,prefixRun,active,_,_⟩:=FourthStepFirst216.source
  obtain ⟨out,crt,outer,images,fsImage,gsImage,object,revB,revS⟩:=part3 first _ _ tables active
  exact ⟨callee,second,third,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,tables,run1,run2,run3,binding,
    .seqNormal _ _ _ _ _ prefixRun crt,outer,images,fsImage,gsImage,object,revB,revS⟩

end FT1536.Source3.FourthStepCrtFirst216
