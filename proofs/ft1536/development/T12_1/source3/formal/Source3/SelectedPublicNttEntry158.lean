import Source3.SelectedPublicTail158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPublicNttEntry158
open SelectedPublicConvert158 (after frame output_fixed)

theorem logn : after.locals "logn".toList=some (.uint32,some (.uint32 10)) :=
  (frame.locals "logn".toList (by decide)).trans SelectedPublicStart157.logn
theorem ternary : after.locals "ternary".toList=some (.int32,some (.int32 1)) :=
  (frame.locals "ternary".toList (by decide)).trans SelectedPublicStart157.ternary
theorem n : C99LoopScalar141.Cell after "n".toList 1536 := output_fixed.nCell
theorem q : after.locals "q".toList=some (.uint32,some (.uint32 18433)) := output_fixed.qCell
theorem counter : C99LoopScalar141.Cell after "u".toList 1536 := (Classical.choose_spec SelectedPublicConvert158.exists_loop).2.2.1
theorem h_binding : after.arrays "h".toList=some SelectedPublicBinding157.h := output_fixed.hBinding
theorem t_binding : after.arrays "t".toList=some SelectedPublicStart157.t := output_fixed.tBinding
theorem globals : after.globals=SelectedPublicStart157.ready.globals := frame.globals
theorem tables : after.tables=SelectedPublicStart157.ready.tables := frame.tables

end FT1536.Source3.SelectedPublicNttEntry158
