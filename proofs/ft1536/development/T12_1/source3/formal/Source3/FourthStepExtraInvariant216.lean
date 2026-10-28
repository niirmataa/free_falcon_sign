import Source3.FourthStepExtraLoopBase216

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FourthStepExtraInvariant216
open C99ArrayReference (State)
open FourthStepLayout216 (fd gd fs gs)
open FourthStepGenerator216 (Outer rxVal)
open FourthStepExtraLoopBase216 (extraRow)
open FourthStepExtraPair216 (sWords)
open FourthStepCrtFirst216 (FirstProducts)
open CrtPrimePrefix214 (pVal iVal rVal)
open StepProductFixed203 (Image)
open ZintNormWalkFlat208 (Data)
open KeygenFullData127 (primes rev)

structure ExtraRow (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 64 → BitVec 32) (k : Nat) : Prop where
  f : Image s fd k 12 32 (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k))
    (sWords F (tables k) (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k)) (rxVal (extraRow k))) 32
  g : Image s gd k 12 32 (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k))
    (sWords G (tables k) (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k)) (rxVal (extraRow k))) 32

structure Active (s : State) (F G RF RG : Nat → BitVec 32) (tables : Nat → Fin 64 → BitVec 32) (u : Nat) : Prop where
  outer : Outer s u
  object : KeygenStaticTables.PrimeObject s.heap primes .ternary
  revBinding : s.tables "REV10".toList=some rev
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  fData : Data s fs 384 RF
  gData : Data s gs 384 RG
  first : FirstProducts s F G
  written : ∀ k, 6 ≤ k → k<u → k<12 → ExtraRow s RF RG tables k

end FT1536.Source3.FourthStepExtraInvariant216
