import Source3.NttTripleScales184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleCells184
open C99ArrayReference (State)
open KeygenModpR2Exec (Slot)
open NttTripleStates184

theorem fA_cell (s : State) (z : Words) : Slot (state11 s z) "fA" (z.a) :=
  (ModularAtoms178.outside (state10 s z) "fC2" "fA" (c2 z) (by decide)).trans ((ModularAtoms178.outside (state9 s z) "fC1" "fA" (c1 z) (by decide)).trans ((ModularAtoms178.outside (state8 s z) "fC0" "fA" (c0 z) (by decide)).trans ((ModularAtoms178.outside (state7 s z) "fB2" "fA" (b2 z) (by decide)).trans ((ModularAtoms178.outside (state6 s z) "fB1" "fA" (b1 z) (by decide)).trans ((ModularAtoms178.outside (state5 s z) "fB0" "fA" (b0 z) (by decide)).trans ((ModularAtoms178.outside (state4 s z) "fC" "fA" (z.c) (by decide)).trans ((ModularAtoms178.outside (state3 s z) "fB" "fA" (z.b) (by decide)).trans (ModularAtoms178.slot (state2 s z) "fA" (z.a)))))))))

theorem fB0_cell (s : State) (z : Words) : Slot (state11 s z) "fB0" (b0 z) :=
  (ModularAtoms178.outside (state10 s z) "fC2" "fB0" (c2 z) (by decide)).trans ((ModularAtoms178.outside (state9 s z) "fC1" "fB0" (c1 z) (by decide)).trans ((ModularAtoms178.outside (state8 s z) "fC0" "fB0" (c0 z) (by decide)).trans ((ModularAtoms178.outside (state7 s z) "fB2" "fB0" (b2 z) (by decide)).trans ((ModularAtoms178.outside (state6 s z) "fB1" "fB0" (b1 z) (by decide)).trans (ModularAtoms178.slot (state5 s z) "fB0" (b0 z))))))

theorem fB1_cell (s : State) (z : Words) : Slot (state11 s z) "fB1" (b1 z) :=
  (ModularAtoms178.outside (state10 s z) "fC2" "fB1" (c2 z) (by decide)).trans ((ModularAtoms178.outside (state9 s z) "fC1" "fB1" (c1 z) (by decide)).trans ((ModularAtoms178.outside (state8 s z) "fC0" "fB1" (c0 z) (by decide)).trans ((ModularAtoms178.outside (state7 s z) "fB2" "fB1" (b2 z) (by decide)).trans (ModularAtoms178.slot (state6 s z) "fB1" (b1 z)))))

theorem fB2_cell (s : State) (z : Words) : Slot (state11 s z) "fB2" (b2 z) :=
  (ModularAtoms178.outside (state10 s z) "fC2" "fB2" (c2 z) (by decide)).trans ((ModularAtoms178.outside (state9 s z) "fC1" "fB2" (c1 z) (by decide)).trans ((ModularAtoms178.outside (state8 s z) "fC0" "fB2" (c0 z) (by decide)).trans (ModularAtoms178.slot (state7 s z) "fB2" (b2 z))))

theorem fC0_cell (s : State) (z : Words) : Slot (state11 s z) "fC0" (c0 z) :=
  (ModularAtoms178.outside (state10 s z) "fC2" "fC0" (c2 z) (by decide)).trans ((ModularAtoms178.outside (state9 s z) "fC1" "fC0" (c1 z) (by decide)).trans (ModularAtoms178.slot (state8 s z) "fC0" (c0 z)))

theorem fC1_cell (s : State) (z : Words) : Slot (state11 s z) "fC1" (c1 z) :=
  (ModularAtoms178.outside (state10 s z) "fC2" "fC1" (c2 z) (by decide)).trans (ModularAtoms178.slot (state9 s z) "fC1" (c1 z))

theorem fC2_cell (s : State) (z : Words) : Slot (state11 s z) "fC2" (c2 z) :=
  ModularAtoms178.slot (state10 s z) "fC2" (c2 z)

end FT1536.Source3.NttTripleCells184
