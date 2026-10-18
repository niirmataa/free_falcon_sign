import Source3.NttTripleFacts184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleLoads184
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open NttTripleStates184
open KeygenNttButterflyPrograms (tripleBody declaration assign read zero scalar write)

theorem dA (s : State) :
    Exec (declaration ["fA","fB","fC","fB0","fB1","fB2","fC0","fC1","fC2"]) s ⟨declaredA s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 namesA s)

theorem dB (s : State) :
    Exec (declaration ["x","x2"]) (declaredA s) ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 namesB (declaredA s))

theorem h1 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (r : Nat)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w)
    (rb : r<1024)
    (rc : USlot s "r" r)
    (readX : Load32 s.heap (element gm r) z.x) :
    Exec (assign "x" (read "gm" (.var "r".toList))) (declared s) ⟨state1 s z,.normal⟩ :=
    ModularAtoms178.assign _ "x" none _ _ rfl (.load32 _ _ (element gm r) (z.x) (NttTripleAddress184.table (declared s) gm r rb z.x fixed.gmBinding rc readX) readX)

theorem h2 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w) :
    Exec (assign "x2" (KeygenNttButterflyPrograms.mont (scalar "x") (scalar "x"))) (state1 s z) ⟨state2 s z,.normal⟩ :=
    ModularAtoms178.assign _ "x2" none _ _ rfl (ModularAtoms178.mont _ _ _ (z.x) (z.x) z.p z.p0i
      (ModularAtoms178.cell _ "x" (z.x) (ModularAtoms178.slot (declared s) "x" (z.x)))
      (ModularAtoms178.cell _ "x" (z.x) (ModularAtoms178.slot (declared s) "x" (z.x))) fixed.pCell fixed.iCell)

theorem h3 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (i : Nat)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w)
    (bound : i+2<1536)
    (r1 : s.arrays "r1".toList=some (element a i))
    (readA : Load32 s.heap (element a i) z.a) :
    Exec (assign "fA" (read "r1")) (state2 s z) ⟨state3 s z,.normal⟩ :=
    ModularAtoms178.assign _ "fA" none _ _ rfl (.load32 _ _ (element a i) (z.a) (RootBinding175.zero (state2 s z) "r1" (element a i) r1 (Nat.le_of_lt (fixed.allocated i (by omega)).2.2.1)) readA)

theorem h4 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (i : Nat)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w)
    (bound : i+2<1536)
    (r1 : s.arrays "r1".toList=some (element a i))
    (readB : Load32 s.heap (element a (i+1)) z.b) :
    Exec (assign "fB" (read "r1" KeygenNttButterflyPrograms.stride)) (state3 s z) ⟨state4 s z,.normal⟩ :=
    ModularAtoms178.assign _ "fB" none _ _ rfl (.load32 _ _ (element a (i+1)) (z.b) (NttFirstControl182.address (state3 s z) "r1" a i r1 fixed.stride (by have := fixed.capacity; omega)) readB)

theorem h5 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (i : Nat)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w)
    (bound : i+2<1536)
    (r1 : s.arrays "r1".toList=some (element a i))
    (readC : Load32 s.heap (element a (i+2)) z.c) :
    Exec (assign "fC" (read "r1" KeygenNttButterflyPrograms.twiceStride)) (state4 s z) ⟨state5 s z,.normal⟩ :=
    ModularAtoms178.assign _ "fC" none _ _ rfl (.load32 _ _ (element a (i+2)) (z.c) (NttTripleAddress184.offset (state4 s z) a i 2 _ r1 (NttTripleAddress184.small_product (state4 s z) fixed.stride 2 (by decide)) (by decide) (by have := fixed.capacity; omega)) readC)

end FT1536.Source3.NttTripleLoads184
