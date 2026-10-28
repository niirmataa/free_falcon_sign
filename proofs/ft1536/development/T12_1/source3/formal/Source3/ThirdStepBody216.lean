import Source3.ThirdStepCrtExtra216
import Source3.ThirdStepLoop215

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ThirdStepBody216
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open ThirdStepLayout215 (fd gd fs gs)
open ThirdStepGenerator215 (Outer rxVal)
open CrtPrimePrefix214 (pVal iVal rVal)
open ThirdStepLoop215 (v0 v1 v2 colF colG sWord init0)
open ThirdStepExtra215 (v3 v4 v5)
open ThirdStepExtraPair215 (sWords)
open ThirdStepCrtExtra216 (Words)
open StepProductFixed203 (Image)
open ZintNormWalkFlat208 (Data)

def firstRow (k : Nat) : Nat×Nat×Nat := if k=0 then v0 else if k=1 then v1 else v2
 def merged (W : Nat → BitVec 32) (i0 i1 i2 : Fin 128 → BitVec 32) :=
  SecondStepImage212.interleave (sWord W 0 i0 v0) (sWord W 1 i1 v1) (sWord W 2 i2 v2)

structure FirstImages (s : State) (F G : Nat → BitVec 32) : Prop where
  f : ∀ k, k<3 → Image s fd k 6 64 (pVal (firstRow k)) (iVal (firstRow k)) (rVal (firstRow k)) (colF F k) 64
  g : ∀ k, k<3 → Image s gd k 6 64 (pVal (firstRow k)) (iVal (firstRow k)) (rVal (firstRow k)) (colG G k) 64

structure ExtraImages (s : State) (F G : Nat → BitVec 32) (g3 g4 g5 : Fin 128 → BitVec 32) : Prop where
  f3 : Image s fd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords F g3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64
  f4 : Image s fd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords F g4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64
  f5 : Image s fd 5 6 64 (pVal v5) (iVal v5) (rVal v5) (sWords F g5 (pVal v5) (iVal v5) (rVal v5) (rxVal v5)) 64
  g3 : Image s gd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords G g3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64
  g4 : Image s gd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords G g4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64
  g5 : Image s gd 5 6 64 (pVal v5) (iVal v5) (rVal v5) (sWords G g5 (pVal v5) (iVal v5) (rVal v5) (rxVal v5)) 64

theorem source (s : State) (F G : Nat → BitVec 32)
    (uDeclared : s.locals "u".toList=some (.uint64,none)) (outer : Outer (init0 s) 0)
    (object : KeygenStaticTables.PrimeObject (init0 s).heap primes .ternary)
    (revB : (init0 s).tables "REV10".toList=some rev) (revS : KeygenMkgm3RevMemory.SourceTable (init0 s).heap rev)
    (fdata : Data (init0 s) fs 384 F) (gdata : Data (init0 s) gs 384 G) :
    ∃ (out : State) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32),
      Exec (.seq (KeygenMakeFgSource.part .step 2) (.seq MakeFgCrtShape194.part3 MakeFgAddPrimeShape194.part4)) s ⟨out,.normal⟩ ∧
      Outer out 6 ∧ FirstImages out F G ∧
      ExtraImages out (Words (merged F i0 i1 i2)) (Words (merged G i0 i1 i2)) g3 g4 g5 ∧
      Data out fs 384 (Words (merged F i0 i1 i2)) ∧ Data out gs 384 (Words (merged G i0 i1 i2)) := by
  obtain ⟨first,i0,i1,i2,loopRun,firstOuter,fd0,fd1,fd2,gd0,gd1,gd2,_,_,_,_,_,_,fRows,gRows,firstObject,firstRevB,firstRevS⟩ :=
    ThirdStepLoop215.body_run s F G uDeclared outer object revB revS fdata gdata
  obtain ⟨out,g3,g4,g5,laterRun,finalOuter,fd3,fd4,fd5,gd3,gd4,gd5,finalF,finalG,keep⟩ :=
    ThirdStepCrtExtra216.source first (merged F i0 i1 i2) (merged G i0 i1 i2)
      firstOuter firstObject firstRevB firstRevS fRows gRows
  refine ⟨out,i0,i1,i2,g3,g4,g5,.seqNormal _ _ _ _ _ loopRun laterRun,finalOuter,?_,⟨fd3,fd4,fd5,gd3,gd4,gd5⟩,finalF,finalG⟩
  constructor
  · intro k kb
    have choices : k=0 ∨ k=1 ∨ k=2 := by omega
    rcases choices with eq | eq | eq <;> subst k
    · exact keep .f 0 (by decide) _ _ _ _ fd0
    · exact keep .f 1 (by decide) _ _ _ _ fd1
    · exact keep .f 2 (by decide) _ _ _ _ fd2
  · intro k kb
    have choices : k=0 ∨ k=1 ∨ k=2 := by omega
    rcases choices with eq | eq | eq <;> subst k
    · exact keep .g 0 (by decide) _ _ _ _ gd0
    · exact keep .g 1 (by decide) _ _ _ _ gd1
    · exact keep .g 2 (by decide) _ _ _ _ gd2

end FT1536.Source3.ThirdStepBody216
