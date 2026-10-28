import Source3.ThirdStepCrtKeep216
import Source3.ThirdStepExtraStrong216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ThirdStepCrtExtra216
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open ThirdStepLayout215 (fd gd fs gs)
open SecondStepCopy203 (Side)
open SecondStepProduct203 (root)
open ThirdStepGenerator215 (Outer rxVal)
open CrtPrimePrefix214 (pVal iVal rVal)
open ThirdStepExtra215 (v3 v4 v5)
open ThirdStepExtraPair215 (sWords)
open ZintNormWalkFlat208 (Data)
open StepProductFixed203 (Image)

def Words (F : Nat → BitVec 32) := ThirdStepCrtBody215.words3 F

theorem source (s : State) (F G : Nat → BitVec 32) (outer : Outer s 3)
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revB : s.tables "REV10".toList=some rev) (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (fdata : Data s fs 384 F) (gdata : Data s gs 384 G) :
    ∃ (out : State) (gvs3 gvs4 gvs5 : Fin 128 → BitVec 32),
      Exec (.seq MakeFgCrtShape194.part3 MakeFgAddPrimeShape194.part4) s ⟨out,.normal⟩ ∧ Outer out 6 ∧
      Image out fd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords (Words F) gvs3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64 ∧
      Image out fd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords (Words F) gvs4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64 ∧
      Image out fd 5 6 64 (pVal v5) (iVal v5) (rVal v5) (sWords (Words F) gvs5 (pVal v5) (iVal v5) (rVal v5) (rxVal v5)) 64 ∧
      Image out gd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords (Words G) gvs3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64 ∧
      Image out gd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords (Words G) gvs4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64 ∧
      Image out gd 5 6 64 (pVal v5) (iVal v5) (rVal v5) (sWords (Words G) gvs5 (pVal v5) (iVal v5) (rVal v5) (rxVal v5)) 64 ∧
      Data out fs 384 (Words F) ∧ Data out gs 384 (Words G) ∧
      (∀ (side : Side) (k : Nat), k<3 → ∀ (p pi r2 : BitVec 32) (w : Nat → BitVec 32),
        Image s (root side) k 6 64 p pi r2 w 64 → Image out (root side) k 6 64 p pi r2 w 64) := by
  obtain ⟨mid,crt,midOuter,fImage,gImage,midObject,midRevB,midRevS,crtKeep⟩ :=
    ThirdStepCrt215.source s F G outer object revB revS fdata gdata
  obtain ⟨out,g3,g4,g5,extra,finalOuter,fd3,fd4,fd5,gd3,gd4,gd5,finalF,finalG,_,_,_,extraKeep⟩ :=
    ThirdStepExtraStrong216.source mid (Words F) (Words G) midOuter midObject midRevB midRevS fImage gImage
  refine ⟨out,g3,g4,g5,.seqNormal _ _ _ _ _ crt extra,finalOuter,fd3,fd4,fd5,gd3,gd4,gd5,finalF,finalG,?_⟩
  intro side k kb p pi r2 w old
  exact ThirdStepExtraFrame216.earlier_column extraKeep side k kb p pi r2 w
    (ThirdStepCrtKeep216.column crtKeep side k (by omega) p pi r2 w old)

end FT1536.Source3.ThirdStepCrtExtra216
