import Source3.NttTripleAddress184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleStates184
open C99ArrayReference (State restoreScope)
open C99MemoryReference (ArrayPointer)
open KeygenSmallOutput (element)

structure Words where
  a : BitVec 32
  b : BitVec 32
  c : BitVec 32
  x : BitVec 32
  w : BitVec 32
  p : BitVec 32
  p0i : BitVec 32

def mont (z : Words) (a b : BitVec 32) := KeygenModpWord.montgomery a b z.p z.p0i
def add (z : Words) (a b : BitVec 32) := KeygenModpAddSub.result .add a b z.p
def x2 (z : Words) := mont z z.x z.x
def b0 (z : Words) := mont z z.b z.x
def b1 (z : Words) := mont z (b0 z) z.w
def b2 (z : Words) := mont z (b1 z) z.w
def c0 (z : Words) := mont z z.c (x2 z)
def c1 (z : Words) := mont z (c0 z) z.w
def c2 (z : Words) := mont z (c1 z) z.w
def firstWord (z : Words) := add z z.a (add z (b0 z) (c0 z))
def secondWord (z : Words) := add z z.a (add z (b1 z) (c2 z))
def thirdWord (z : Words) := add z z.a (add z (b2 z) (c1 z))
def namesA := ["fA","fB","fC","fB0","fB1","fB2","fC0","fC1","fC2"].map String.toList
def namesB := ["x","x2"].map String.toList
def names := namesA++namesB
def declaredA (s : State) := C99DeclarationStatements.effect .u32 namesA s
def declared (s : State) := C99DeclarationStatements.effect .u32 namesB (declaredA s)
def state1 (s : State) (z : Words) := ModularAtoms178.set (declared s) "x" (z.x)
def state2 (s : State) (z : Words) := ModularAtoms178.set (state1 s z) "x2" (x2 z)
def state3 (s : State) (z : Words) := ModularAtoms178.set (state2 s z) "fA" (z.a)
def state4 (s : State) (z : Words) := ModularAtoms178.set (state3 s z) "fB" (z.b)
def state5 (s : State) (z : Words) := ModularAtoms178.set (state4 s z) "fC" (z.c)
def state6 (s : State) (z : Words) := ModularAtoms178.set (state5 s z) "fB0" (b0 z)
def state7 (s : State) (z : Words) := ModularAtoms178.set (state6 s z) "fB1" (b1 z)
def state8 (s : State) (z : Words) := ModularAtoms178.set (state7 s z) "fB2" (b2 z)
def state9 (s : State) (z : Words) := ModularAtoms178.set (state8 s z) "fC0" (c0 z)
def state10 (s : State) (z : Words) := ModularAtoms178.set (state9 s z) "fC1" (c1 z)
def state11 (s : State) (z : Words) := ModularAtoms178.set (state10 s z) "fC2" (c2 z)

def first (s : State) (a : ArrayPointer) (i : Nat) (z : Words) : State :=
  {state11 s z with heap:=Word32Memory176.write s.heap (element a i) (firstWord z)}
def second (s : State) (a : ArrayPointer) (i : Nat) (z : Words) : State :=
  {first s a i z with heap:=Word32Memory176.write (first s a i z).heap (element a (i+1)) (secondWord z)}
def third (s : State) (a : ArrayPointer) (i : Nat) (z : Words) : State :=
  {second s a i z with heap:=Word32Memory176.write (second s a i z).heap (element a (i+2)) (thirdWord z)}
def after (s : State) (a : ArrayPointer) (i : Nat) (z : Words) := restoreScope s (third s a i z) names []

end FT1536.Source3.NttTripleStates184
