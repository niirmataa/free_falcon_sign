import Source3.ModularStore184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModularSum184
open C99ArrayReference (State)
open C99ModularReference (Eval)
open KeygenModpR2Exec (Slot)
open KeygenNttButterflyPrograms (scalar add)

theorem source (s : State) (aName bName cName : String) (a b c p : BitVec 32)
    (ac : Slot s aName a) (bc : Slot s bName b) (cc : Slot s cName c) (pc : Slot s "p" p) :
    Eval s (add (scalar aName) (add (scalar bName) (scalar cName)))
      (.uint32 (KeygenModpAddSub.result .add a (KeygenModpAddSub.result .add b c p) p)) :=
  ModularWordOps182.add s (scalar aName) (add (scalar bName) (scalar cName)) a
    (KeygenModpAddSub.result .add b c p) p (ModularAtoms178.cell s aName a ac)
    (ModularWordOps182.add s (scalar bName) (scalar cName) b c p
      (ModularAtoms178.cell s bName b bc) (ModularAtoms178.cell s cName c cc) pc) pc

end FT1536.Source3.ModularSum184
