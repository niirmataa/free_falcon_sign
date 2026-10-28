import Source3.BezoutInitStore217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutInitStoreCells217
open C99ArrayReference (State)

theorem a_decl (s : State) : (BezoutPointerSetup217.after s).locals "alen".toList=some (.uint64,none) := by
  change (BezoutDeclarations217.after (DeepestBezoutEntry217.entry s)).locals "alen".toList=some (.uint64,none)
  rfl

theorem b_decl (s : State) : (BezoutPointerSetup217.after s).locals "blen".toList=some (.uint64,none) := by
  change (BezoutDeclarations217.after (DeepestBezoutEntry217.entry s)).locals "blen".toList=some (.uint64,none)
  rfl

theorem u0_binding (s : State) : (BezoutPointerSetup217.after s).arrays "u0".toList=some DeepestBezoutEntry217.Gp := rfl

end FT1536.Source3.BezoutInitStoreCells217
