import Source3.FprTable138
import Source3.FftGlobalScalars

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.Fft138CallsGenerator
open FprBoundEvents135 (Event)

def constant (name : String) : BitVec 64 :=
  ((FftGlobalScalars.expected.find? (fun pair => pair.1==name.toList)).map Prod.snd).getD 0

def events : List Event := Id.run do
  let values : List (BitVec 64) := [FprTernary136.negative,0,FprTernary136.positive]
  let real := constant "fpr_W1R"
  let imag := constant "fpr_W1I"
  let mut result := []
  for x in values do
    for y in [real,imag] do
      result := result++[⟨"fpr_mul".toList,[.u64 x,.u64 y],.u64 (FprMulFast137.word x y)⟩]
  for x in values do
    for y in values do
      let scaled := FprMulFast137.word y real
      result := result++[⟨"fpr_add".toList,[.u64 x,.u64 scaled],.u64 (FprAddFast137.word x scaled)⟩]
  return result

def generate : IO Unit := do
  let mut text := "import Source3.FprTable138\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.GeneratedFft138FirstCalls\n\n"
  for event in events, i in [:events.length] do
    let name := "event"++toString i
    text := text++"def "++name++" : FprBoundEvents135.Event :=\n  "++(reprStr event).replace "\n" "\n  "++"\n\n"
    text := text++"theorem checked"++toString i++" : FprFastCalls137.calls "++name++".name "++name++".args=some "++name++".out := by decide +kernel\n\n"
    text := text++"theorem valid"++toString i++" : FprTable138.Valid "++name++" := FprTable138.checked "++name++" checked"++toString i++"\n\n"
  text := text++"def events : List FprBoundEvents135.Event := ["++String.intercalate "," ((List.range events.length).map (fun i => "event"++toString i))++"]\n\n"
  text := text++"theorem valid : ∀ event∈events, FprTable138.Valid event := by\n  intro event member\n  simp only [events,List.mem_cons,List.not_mem_nil,or_false] at member\n  rcases member with "++String.intercalate "|" ((List.range events.length).map (fun _ => "rfl"))++"\n"
  for i in List.range events.length do text := text++"  · exact valid"++toString i++"\n"
  text := text++"\nend FT1536.Source3.GeneratedFft138FirstCalls\n"
  IO.FS.writeFile "../GeneratedFft138FirstCalls.lean" text

end FT1536.Source3.Fft138CallsGenerator
#eval FT1536.Source3.Fft138CallsGenerator.generate
