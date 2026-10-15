import Source3.FftTriplingSetup148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTriplingSetupFixed148
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open FftTripleBody147 (Constants)
open FftTriplingInvariant148 (Fixed)

theorem source (s : State) (base : ArrayPointer) (c : Constants) (fixed : Fixed s base c) :
    Fixed (FftTriplingSetup148.initial s) base c :=
  ⟨fixed.width,fixed.capacity,fixed.writable,fixed.binding,
    (FftTriplingSetup148.outside s "hn".toList (by decide) (by decide)).trans fixed.hnCell,
    fixed.tableBinding,fixed.pinned,
    (FftTriplingSetup148.outside s "fpr_W2R".toList (by decide) (by decide)).trans fixed.w2rCell,
    (FftTriplingSetup148.outside s "fpr_W2I".toList (by decide) (by decide)).trans fixed.w2iCell,
    (FftTriplingSetup148.outside s "fpr_W4R".toList (by decide) (by decide)).trans fixed.w4rCell,
    (FftTriplingSetup148.outside s "fpr_W4I".toList (by decide) (by decide)).trans fixed.w4iCell⟩

end FT1536.Source3.FftTriplingSetupFixed148
