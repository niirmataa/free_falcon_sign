import Source3.BezoutPointerSetup217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.BezoutPointerCells217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)

theorem len (s : State) : Cell (BezoutPointerSetup217.after s) "len".toList 335 := by
  change Cell (BezoutDeclarations217.after (DeepestBezoutEntry217.entry s)) "len".toList 335
  rfl

theorem xdecl (s : State) : (BezoutPointerSetup217.after s).locals "xlen".toList=some (.uint64,none) := by
  change (BezoutDeclarations217.after (DeepestBezoutEntry217.entry s)).locals "xlen".toList=some (.uint64,none)
  rfl

theorem ydecl (s : State) : (BezoutPointerSetup217.after s).locals "ylen".toList=some (.uint64,none) := by
  change (BezoutDeclarations217.after (DeepestBezoutEntry217.entry s)).locals "ylen".toList=some (.uint64,none)
  rfl

end FT1536.Source3.BezoutPointerCells217
