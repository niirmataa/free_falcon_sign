import Source3.FifthStepExtraLoopBase217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FifthStepExtraInvariant217
open C99ArrayReference (State)
open FifthStepLayout217 (fd gd fs gs)
open FifthStepGenerator217 (Outer rxVal)
open FifthStepExtraLoopBase217 (extraRow)
open FifthStepExtraPair217 (sWords)
open FifthStepCrtFirst217 (FirstProducts)
open CrtPrimePrefix214 (pVal iVal rVal)
open StepProductFixed203 (Image)
open ZintNormWalkFlat208 (Data)
open KeygenFullData127 (primes rev)

structure ExtraRow (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 32 → BitVec 32) (k : Nat) : Prop where
  f : Image s fd k 22 16 (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k))
    (sWords F (tables k) (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k)) (rxVal (extraRow k))) 16
  g : Image s gd k 22 16 (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k))
    (sWords G (tables k) (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k)) (rxVal (extraRow k))) 16

structure Active (s : State) (F G RF RG : Nat → BitVec 32) (tables : Nat → Fin 32 → BitVec 32) (u : Nat) : Prop where
  outer : Outer s u
  object : KeygenStaticTables.PrimeObject s.heap primes .ternary
  revBinding : s.tables "REV10".toList=some rev
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  fData : Data s fs 384 RF
  gData : Data s gs 384 RG
  first : FirstProducts s F G
  written : ∀ k, 12 ≤ k → k<u → k<22 → ExtraRow s RF RG tables k

end FT1536.Source3.FifthStepExtraInvariant217
