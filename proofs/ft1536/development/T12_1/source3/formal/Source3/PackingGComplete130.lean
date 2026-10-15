import Source3.GeneratedPacking130G23

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PackingGComplete130
open C99CompactState115 (reference)
open PackingShape130 (condition body increment)

theorem through00 : KeygenWordSegments130.Prefix condition body increment 64
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G00.after) :=
  GeneratedPacking130G00.closed

theorem through01 : KeygenWordSegments130.Prefix condition body increment 128
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G01.after) :=
  KeygenWordSegments130.append condition body increment 64 64 _ _ _ through00 GeneratedPacking130G01.closed

theorem through02 : KeygenWordSegments130.Prefix condition body increment 192
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G02.after) :=
  KeygenWordSegments130.append condition body increment 128 64 _ _ _ through01 GeneratedPacking130G02.closed

theorem through03 : KeygenWordSegments130.Prefix condition body increment 256
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G03.after) :=
  KeygenWordSegments130.append condition body increment 192 64 _ _ _ through02 GeneratedPacking130G03.closed

theorem through04 : KeygenWordSegments130.Prefix condition body increment 320
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G04.after) :=
  KeygenWordSegments130.append condition body increment 256 64 _ _ _ through03 GeneratedPacking130G04.closed

theorem through05 : KeygenWordSegments130.Prefix condition body increment 384
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G05.after) :=
  KeygenWordSegments130.append condition body increment 320 64 _ _ _ through04 GeneratedPacking130G05.closed

theorem through06 : KeygenWordSegments130.Prefix condition body increment 448
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G06.after) :=
  KeygenWordSegments130.append condition body increment 384 64 _ _ _ through05 GeneratedPacking130G06.closed

theorem through07 : KeygenWordSegments130.Prefix condition body increment 512
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G07.after) :=
  KeygenWordSegments130.append condition body increment 448 64 _ _ _ through06 GeneratedPacking130G07.closed

theorem through08 : KeygenWordSegments130.Prefix condition body increment 576
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G08.after) :=
  KeygenWordSegments130.append condition body increment 512 64 _ _ _ through07 GeneratedPacking130G08.closed

theorem through09 : KeygenWordSegments130.Prefix condition body increment 640
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G09.after) :=
  KeygenWordSegments130.append condition body increment 576 64 _ _ _ through08 GeneratedPacking130G09.closed

theorem through10 : KeygenWordSegments130.Prefix condition body increment 704
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G10.after) :=
  KeygenWordSegments130.append condition body increment 640 64 _ _ _ through09 GeneratedPacking130G10.closed

theorem through11 : KeygenWordSegments130.Prefix condition body increment 768
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G11.after) :=
  KeygenWordSegments130.append condition body increment 704 64 _ _ _ through10 GeneratedPacking130G11.closed

theorem through12 : KeygenWordSegments130.Prefix condition body increment 832
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G12.after) :=
  KeygenWordSegments130.append condition body increment 768 64 _ _ _ through11 GeneratedPacking130G12.closed

theorem through13 : KeygenWordSegments130.Prefix condition body increment 896
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G13.after) :=
  KeygenWordSegments130.append condition body increment 832 64 _ _ _ through12 GeneratedPacking130G13.closed

theorem through14 : KeygenWordSegments130.Prefix condition body increment 960
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G14.after) :=
  KeygenWordSegments130.append condition body increment 896 64 _ _ _ through13 GeneratedPacking130G14.closed

theorem through15 : KeygenWordSegments130.Prefix condition body increment 1024
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G15.after) :=
  KeygenWordSegments130.append condition body increment 960 64 _ _ _ through14 GeneratedPacking130G15.closed

theorem through16 : KeygenWordSegments130.Prefix condition body increment 1088
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G16.after) :=
  KeygenWordSegments130.append condition body increment 1024 64 _ _ _ through15 GeneratedPacking130G16.closed

theorem through17 : KeygenWordSegments130.Prefix condition body increment 1152
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G17.after) :=
  KeygenWordSegments130.append condition body increment 1088 64 _ _ _ through16 GeneratedPacking130G17.closed

theorem through18 : KeygenWordSegments130.Prefix condition body increment 1216
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G18.after) :=
  KeygenWordSegments130.append condition body increment 1152 64 _ _ _ through17 GeneratedPacking130G18.closed

theorem through19 : KeygenWordSegments130.Prefix condition body increment 1280
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G19.after) :=
  KeygenWordSegments130.append condition body increment 1216 64 _ _ _ through18 GeneratedPacking130G19.closed

theorem through20 : KeygenWordSegments130.Prefix condition body increment 1344
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G20.after) :=
  KeygenWordSegments130.append condition body increment 1280 64 _ _ _ through19 GeneratedPacking130G20.closed

theorem through21 : KeygenWordSegments130.Prefix condition body increment 1408
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G21.after) :=
  KeygenWordSegments130.append condition body increment 1344 64 _ _ _ through20 GeneratedPacking130G21.closed

theorem through22 : KeygenWordSegments130.Prefix condition body increment 1472
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G22.after) :=
  KeygenWordSegments130.append condition body increment 1408 64 _ _ _ through21 GeneratedPacking130G22.closed

theorem through23 : KeygenWordSegments130.Prefix condition body increment 1536
    (reference SelectedPackingG130.initial) (reference GeneratedPacking130G23.after) :=
  KeygenWordSegments130.append condition body increment 1472 64 _ _ _ through22 GeneratedPacking130G23.closed

def after := GeneratedPacking130G23.after

theorem final_guard : KeygenWordCompute130.evaluate after condition=some (.i32 0) := by decide +kernel

theorem loop_source : KeygenWordExec.Exec PackingShape130.loop
    (reference SelectedPackingG130.initial) ⟨reference after,.normal⟩ :=
  KeygenWordSegments130.finish condition body increment 1536 _ _ _ through23
    (.loopFalse condition body increment (reference after) (.int32 0)
      (KeygenWordComputeSound130.sound after condition (.i32 0) final_guard) (by decide +kernel))

theorem source : KeygenWordExec.Exec KeygenResultantSource.packing
    (reference SelectedPackingG130.zeroed) ⟨reference after,.normal⟩ :=
  PackingShape130.assemble _ _ _ SelectedPackingG130.initial_source loop_source

end FT1536.Source3.PackingGComplete130
