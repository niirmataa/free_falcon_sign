import Source3.SeventhStepLoopBase217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SeventhStepInvariant217
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open StepCopyBody190 (addr)
open StepProductFixed203 (Image)
open ThirdStepGenerator215 (gVal)
open SeventhStepGenerator217 (Outer)
open SeventhStepLayout217 (fd gd fs gs)
open SeventhStepLoopBase217 (primeRow col)
open SeventhStepInner217 (tableWord)
open CrtPrimePrefix214 (pVal iVal rVal)
open NttInverseWholeBridges201 (scaledWord)
open KeygenFullData127 (primes rev)

def putTables (tables : Nat → Fin 8 → BitVec 32) (u : Nat) (word : Fin 8 → BitVec 32) : Nat → Fin 8 → BitVec 32 :=
  fun k => if k=u then word else tables k

structure RowImage (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 8 → BitVec 32) (k : Nat) : Prop where
  fd : Image s fd k 82 4 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col F k) 4
  gd : Image s gd k 82 4 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col G k) 4
  fs : ∀ j<8, Load32 s.heap (addr fs k j 42) (scaledWord 2 (col F k) (tableWord (tables k)) (pVal (primeRow k)) (iVal (primeRow k)) j)
  gs : ∀ j<8, Load32 s.heap (addr gs k j 42) (scaledWord 2 (col G k) (tableWord (tables k)) (pVal (primeRow k)) (iVal (primeRow k)) j)

structure Active (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 8 → BitVec 32) (u : Nat) : Prop where
  outer : Outer s u
  object : KeygenStaticTables.PrimeObject s.heap primes .ternary
  revBinding : s.tables "REV10".toList=some rev
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  pendingF : ∀ k, u ≤ k → k<42 → ∀ j<8, Load32 s.heap (addr fs k j 42) (col F k j)
  pendingG : ∀ k, u ≤ k → k<42 → ∀ j<8, Load32 s.heap (addr gs k j 42) (col G k j)
  written : ∀ k, k<u → k<42 → RowImage s F G tables k

end FT1536.Source3.SeventhStepInvariant217
