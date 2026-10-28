import Source3.SelectedBezoutNormalNinv217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact stored C word values after the two actual modp_ninv31 calls. -/
namespace FT1536.Source3.BezoutNormalNinvCells217
open C99ArrayReference (State)
open C99NatWord141 (word)

theorem x (s : State) (x y : BitVec 32) :
    (BezoutNormalNinv217.after s x y).locals "x0i".toList=some (.uint32,some (.uint32 (KeygenNinv31.word x))) := by
  exact (SelectedStepAddPrime195.locals_keep (BezoutNormalNinv217.afterX s x) "y0i".toList .uint32
    (.uint32 (KeygenNinv31.word y)) "x0i".toList (by decide)).trans (ModularAtoms178.slot s "x0i" (KeygenNinv31.word x))

theorem y (s : State) (x y : BitVec 32) :
    (BezoutNormalNinv217.after s x y).locals "y0i".toList=some (.uint32,some (.uint32 (KeygenNinv31.word y))) := ModularAtoms178.slot (BezoutNormalNinv217.afterX s x) "y0i" (KeygenNinv31.word y)

theorem heap (s : State) (x y : BitVec 32) : (BezoutNormalNinv217.after s x y).heap=s.heap := rfl

theorem arrays (s : State) (x y : BitVec 32) : (BezoutNormalNinv217.after s x y).arrays=s.arrays := rfl

end FT1536.Source3.BezoutNormalNinvCells217
