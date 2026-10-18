import Source3.NttTripleLoads184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleScales184
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open NttTripleStates184
open KeygenNttButterflyPrograms (tripleBody declaration assign read zero scalar write)

theorem h6 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w) :
    Exec (assign "fB0" (KeygenNttButterflyPrograms.mont (scalar "fB") (scalar "x"))) (state5 s z) ⟨state6 s z,.normal⟩ :=
    ModularAtoms178.assign _ "fB0" none _ _ rfl (ModularAtoms178.mont _ _ _ (z.b) (z.x) z.p z.p0i
      (ModularAtoms178.cell _ "fB" (z.b) ((ModularAtoms178.outside (state4 s z) "fC" "fB" (z.c) (by decide)).trans (ModularAtoms178.slot (state3 s z) "fB" (z.b))))
      (ModularAtoms178.cell _ "x" (z.x) ((ModularAtoms178.outside (state4 s z) "fC" "x" (z.c) (by decide)).trans ((ModularAtoms178.outside (state3 s z) "fB" "x" (z.b) (by decide)).trans ((ModularAtoms178.outside (state2 s z) "fA" "x" (z.a) (by decide)).trans ((ModularAtoms178.outside (state1 s z) "x2" "x" (x2 z) (by decide)).trans (ModularAtoms178.slot (declared s) "x" (z.x))))))) fixed.pCell fixed.iCell)

theorem h7 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w) :
    Exec (assign "fB1" (KeygenNttButterflyPrograms.mont (scalar "fB0") (scalar "w"))) (state6 s z) ⟨state7 s z,.normal⟩ :=
    ModularAtoms178.assign _ "fB1" none _ _ rfl (ModularAtoms178.mont _ _ _ (b0 z) (z.w) z.p z.p0i
      (ModularAtoms178.cell _ "fB0" (b0 z) (ModularAtoms178.slot (state5 s z) "fB0" (b0 z)))
      (ModularAtoms178.cell _ "w" (z.w) (fixed.wCell)) fixed.pCell fixed.iCell)

theorem h8 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w) :
    Exec (assign "fB2" (KeygenNttButterflyPrograms.mont (scalar "fB1") (scalar "w"))) (state7 s z) ⟨state8 s z,.normal⟩ :=
    ModularAtoms178.assign _ "fB2" none _ _ rfl (ModularAtoms178.mont _ _ _ (b1 z) (z.w) z.p z.p0i
      (ModularAtoms178.cell _ "fB1" (b1 z) (ModularAtoms178.slot (state6 s z) "fB1" (b1 z)))
      (ModularAtoms178.cell _ "w" (z.w) (fixed.wCell)) fixed.pCell fixed.iCell)

theorem h9 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w) :
    Exec (assign "fC0" (KeygenNttButterflyPrograms.mont (scalar "fC") (scalar "x2"))) (state8 s z) ⟨state9 s z,.normal⟩ :=
    ModularAtoms178.assign _ "fC0" none _ _ rfl (ModularAtoms178.mont _ _ _ (z.c) (x2 z) z.p z.p0i
      (ModularAtoms178.cell _ "fC" (z.c) ((ModularAtoms178.outside (state7 s z) "fB2" "fC" (b2 z) (by decide)).trans ((ModularAtoms178.outside (state6 s z) "fB1" "fC" (b1 z) (by decide)).trans ((ModularAtoms178.outside (state5 s z) "fB0" "fC" (b0 z) (by decide)).trans (ModularAtoms178.slot (state4 s z) "fC" (z.c))))))
      (ModularAtoms178.cell _ "x2" (x2 z) ((ModularAtoms178.outside (state7 s z) "fB2" "x2" (b2 z) (by decide)).trans ((ModularAtoms178.outside (state6 s z) "fB1" "x2" (b1 z) (by decide)).trans ((ModularAtoms178.outside (state5 s z) "fB0" "x2" (b0 z) (by decide)).trans ((ModularAtoms178.outside (state4 s z) "fC" "x2" (z.c) (by decide)).trans ((ModularAtoms178.outside (state3 s z) "fB" "x2" (z.b) (by decide)).trans ((ModularAtoms178.outside (state2 s z) "fA" "x2" (z.a) (by decide)).trans (ModularAtoms178.slot (state1 s z) "x2" (x2 z))))))))) fixed.pCell fixed.iCell)

theorem h10 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w) :
    Exec (assign "fC1" (KeygenNttButterflyPrograms.mont (scalar "fC0") (scalar "w"))) (state9 s z) ⟨state10 s z,.normal⟩ :=
    ModularAtoms178.assign _ "fC1" none _ _ rfl (ModularAtoms178.mont _ _ _ (c0 z) (z.w) z.p z.p0i
      (ModularAtoms178.cell _ "fC0" (c0 z) (ModularAtoms178.slot (state8 s z) "fC0" (c0 z)))
      (ModularAtoms178.cell _ "w" (z.w) (fixed.wCell)) fixed.pCell fixed.iCell)

theorem h11 (s : State)
    (a : ArrayPointer)
    (gm : ArrayPointer)
    (z : Words)
    (fixed : NttFirstFixed182.Fixed s a gm z.p z.p0i z.w) :
    Exec (assign "fC2" (KeygenNttButterflyPrograms.mont (scalar "fC1") (scalar "w"))) (state10 s z) ⟨state11 s z,.normal⟩ :=
    ModularAtoms178.assign _ "fC2" none _ _ rfl (ModularAtoms178.mont _ _ _ (c1 z) (z.w) z.p z.p0i
      (ModularAtoms178.cell _ "fC1" (c1 z) (ModularAtoms178.slot (state9 s z) "fC1" (c1 z)))
      (ModularAtoms178.cell _ "w" (z.w) (fixed.wCell)) fixed.pCell fixed.iCell)

end FT1536.Source3.NttTripleScales184
