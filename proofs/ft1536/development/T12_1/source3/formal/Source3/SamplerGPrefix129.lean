import Source3.GeneratedSampler129G24
import Source3.EventValid129G02
import Source3.EventValid129G08
import Source3.EventValid129G15
import Source3.EventValid129G21
import Source3.KeygenPrefixCompose128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SamplerGPrefix129
open C99CompactState115 (reference)
open SelectedGStart129 (ctx initial)

theorem through01 : KeygenSamplerPrefix128.Prefix ctx 64
    (reference initial) (reference GeneratedSampler129G01.after) :=
  GeneratedSampler129G01.closed

theorem through02 : KeygenSamplerPrefix128.Prefix ctx 128
    (reference initial) (reference GeneratedSampler129G02.after) :=
  KeygenPrefixCompose128.append ctx 64 64 _ _ _ through01 EventValid129G02.closed

theorem through03 : KeygenSamplerPrefix128.Prefix ctx 192
    (reference initial) (reference GeneratedSampler129G03.after) :=
  KeygenPrefixCompose128.append ctx 128 64 _ _ _ through02 GeneratedSampler129G03.closed

theorem through04 : KeygenSamplerPrefix128.Prefix ctx 256
    (reference initial) (reference GeneratedSampler129G04.after) :=
  KeygenPrefixCompose128.append ctx 192 64 _ _ _ through03 GeneratedSampler129G04.closed

theorem through05 : KeygenSamplerPrefix128.Prefix ctx 320
    (reference initial) (reference GeneratedSampler129G05.after) :=
  KeygenPrefixCompose128.append ctx 256 64 _ _ _ through04 GeneratedSampler129G05.closed

theorem through06 : KeygenSamplerPrefix128.Prefix ctx 384
    (reference initial) (reference GeneratedSampler129G06.after) :=
  KeygenPrefixCompose128.append ctx 320 64 _ _ _ through05 GeneratedSampler129G06.closed

theorem through07 : KeygenSamplerPrefix128.Prefix ctx 448
    (reference initial) (reference GeneratedSampler129G07.after) :=
  KeygenPrefixCompose128.append ctx 384 64 _ _ _ through06 GeneratedSampler129G07.closed

theorem through08 : KeygenSamplerPrefix128.Prefix ctx 512
    (reference initial) (reference GeneratedSampler129G08.after) :=
  KeygenPrefixCompose128.append ctx 448 64 _ _ _ through07 EventValid129G08.closed

theorem through09 : KeygenSamplerPrefix128.Prefix ctx 576
    (reference initial) (reference GeneratedSampler129G09.after) :=
  KeygenPrefixCompose128.append ctx 512 64 _ _ _ through08 GeneratedSampler129G09.closed

theorem through10 : KeygenSamplerPrefix128.Prefix ctx 640
    (reference initial) (reference GeneratedSampler129G10.after) :=
  KeygenPrefixCompose128.append ctx 576 64 _ _ _ through09 GeneratedSampler129G10.closed

theorem through11 : KeygenSamplerPrefix128.Prefix ctx 704
    (reference initial) (reference GeneratedSampler129G11.after) :=
  KeygenPrefixCompose128.append ctx 640 64 _ _ _ through10 GeneratedSampler129G11.closed

theorem through12 : KeygenSamplerPrefix128.Prefix ctx 768
    (reference initial) (reference GeneratedSampler129G12.after) :=
  KeygenPrefixCompose128.append ctx 704 64 _ _ _ through11 GeneratedSampler129G12.closed

theorem through13 : KeygenSamplerPrefix128.Prefix ctx 832
    (reference initial) (reference GeneratedSampler129G13.after) :=
  KeygenPrefixCompose128.append ctx 768 64 _ _ _ through12 GeneratedSampler129G13.closed

theorem through14 : KeygenSamplerPrefix128.Prefix ctx 896
    (reference initial) (reference GeneratedSampler129G14.after) :=
  KeygenPrefixCompose128.append ctx 832 64 _ _ _ through13 GeneratedSampler129G14.closed

theorem through15 : KeygenSamplerPrefix128.Prefix ctx 960
    (reference initial) (reference GeneratedSampler129G15.after) :=
  KeygenPrefixCompose128.append ctx 896 64 _ _ _ through14 EventValid129G15.closed

theorem through16 : KeygenSamplerPrefix128.Prefix ctx 1024
    (reference initial) (reference GeneratedSampler129G16.after) :=
  KeygenPrefixCompose128.append ctx 960 64 _ _ _ through15 GeneratedSampler129G16.closed

theorem through17 : KeygenSamplerPrefix128.Prefix ctx 1088
    (reference initial) (reference GeneratedSampler129G17.after) :=
  KeygenPrefixCompose128.append ctx 1024 64 _ _ _ through16 GeneratedSampler129G17.closed

theorem through18 : KeygenSamplerPrefix128.Prefix ctx 1152
    (reference initial) (reference GeneratedSampler129G18.after) :=
  KeygenPrefixCompose128.append ctx 1088 64 _ _ _ through17 GeneratedSampler129G18.closed

theorem through19 : KeygenSamplerPrefix128.Prefix ctx 1216
    (reference initial) (reference GeneratedSampler129G19.after) :=
  KeygenPrefixCompose128.append ctx 1152 64 _ _ _ through18 GeneratedSampler129G19.closed

theorem through20 : KeygenSamplerPrefix128.Prefix ctx 1280
    (reference initial) (reference GeneratedSampler129G20.after) :=
  KeygenPrefixCompose128.append ctx 1216 64 _ _ _ through19 GeneratedSampler129G20.closed

theorem through21 : KeygenSamplerPrefix128.Prefix ctx 1344
    (reference initial) (reference GeneratedSampler129G21.after) :=
  KeygenPrefixCompose128.append ctx 1280 64 _ _ _ through20 EventValid129G21.closed

theorem through22 : KeygenSamplerPrefix128.Prefix ctx 1408
    (reference initial) (reference GeneratedSampler129G22.after) :=
  KeygenPrefixCompose128.append ctx 1344 64 _ _ _ through21 GeneratedSampler129G22.closed

theorem through23 : KeygenSamplerPrefix128.Prefix ctx 1472
    (reference initial) (reference GeneratedSampler129G23.after) :=
  KeygenPrefixCompose128.append ctx 1408 64 _ _ _ through22 GeneratedSampler129G23.closed

theorem through24 : KeygenSamplerPrefix128.Prefix ctx 1536
    (reference initial) (reference GeneratedSampler129G24.after) :=
  KeygenPrefixCompose128.append ctx 1472 64 _ _ _ through23 GeneratedSampler129G24.closed

end FT1536.Source3.SamplerGPrefix129
