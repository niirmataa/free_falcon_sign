import Source3.EighthStepLoopBase217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.EighthStepInvariant217
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open StepCopyBody190 (addr)
open StepProductFixed203 (Image)
open ThirdStepGenerator215 (gVal)
open EighthStepGenerator217 (Outer)
open EighthStepLayout217 (fd gd fs gs)
open EighthStepLoopBase217 (primeRow col)
open EighthStepInner217 (tableWord)
open CrtPrimePrefix214 (pVal iVal rVal)
open NttInverseWholeBridges201 (scaledWord)
open KeygenFullData127 (primes rev)

def putTables (tables : Nat → Fin 4 → BitVec 32) (u : Nat) (word : Fin 4 → BitVec 32) : Nat → Fin 4 → BitVec 32 :=
  fun k => if k=u then word else tables k

structure RowImage (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 4 → BitVec 32) (k : Nat) : Prop where
  fd : Image s fd k 166 2 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col F k) 2
  gd : Image s gd k 166 2 (pVal (primeRow k)) (iVal (primeRow k)) (rVal (primeRow k)) (col G k) 2
  fs : ∀ j<4, Load32 s.heap (addr fs k j 82) (scaledWord 1 (col F k) (tableWord (tables k)) (pVal (primeRow k)) (iVal (primeRow k)) j)
  gs : ∀ j<4, Load32 s.heap (addr gs k j 82) (scaledWord 1 (col G k) (tableWord (tables k)) (pVal (primeRow k)) (iVal (primeRow k)) j)

structure Active (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 4 → BitVec 32) (u : Nat) : Prop where
  outer : Outer s u
  object : KeygenStaticTables.PrimeObject s.heap primes .ternary
  revBinding : s.tables "REV10".toList=some rev
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  pendingF : ∀ k, u ≤ k → k<82 → ∀ j<4, Load32 s.heap (addr fs k j 82) (col F k j)
  pendingG : ∀ k, u ≤ k → k<82 → ∀ j<4, Load32 s.heap (addr gs k j 82) (col G k j)
  written : ∀ k, k<u → k<82 → RowImage s F G tables k

end FT1536.Source3.EighthStepInvariant217
