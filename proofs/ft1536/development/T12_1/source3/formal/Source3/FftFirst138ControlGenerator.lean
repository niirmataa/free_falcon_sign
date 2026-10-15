import Source3.FftFirstAll138Generator
import Source3.Fft138CallsGenerator
import Source3.GeneratedFft138FirstCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftFirst138ControlGenerator

def words (state : C99CompactState115.State) (offset : Nat) : IO (Array String) := do
  let mut out := #[]
  for i in List.range 1536 do
    let some word := C99FiniteRead114.read64 state.heap ⟨31,0,35840,8,offset+i⟩ |
      throw (IO.userError "First FFT control read failed")
    out := out.push (toString word.toNat)
  pure out

def generate : IO Unit := do
  let initial ← FftFirst138Generator.initial
  let gBefore ← words initial 1536
  let mut state := initial
  for count in FftFirstAll138Generator.counts do state := (← FftFirst138Generator.segment count state)
  let fAfter ← words state 0
  let gAfter ← words state 1536
  if gBefore != gAfter then throw (IO.userError "First FFT candidate changed g output")
  let some block := C99FiniteMap114.lookup state.heap.blocks 31 |
    throw (IO.userError "First FFT control block missing")
  IO.FS.writeFile "../FFT138_CONTROL_BLOCK.txt" (Process122Generator.blockText block)
  let events := GeneratedFft138FirstCalls.events.map (fun e => Lean.Json.mkObj [
    ("name",Lean.toJson (String.ofList e.name)),
    ("args",Lean.toJson (e.args.map (fun v => toString v.integer))),
    ("out",Lean.toJson (toString e.out.integer))])
  IO.FS.writeFile "../FFT138_CONTROL_CANDIDATE.json" (Lean.Json.pretty (Lean.Json.mkObj [
    ("status",Lean.toJson "FINITE_CONSISTENCY_CONTROL_ONLY"),("f_words",Lean.toJson fAfter),
    ("g_preserved",Lean.toJson true),("events",Lean.toJson events),
    ("real",Lean.toJson (toString (Fft138CallsGenerator.constant "fpr_W1R").toNat)),
    ("imag",Lean.toJson (toString (Fft138CallsGenerator.constant "fpr_W1I").toNat))]))

end FT1536.Source3.FftFirst138ControlGenerator
#eval FT1536.Source3.FftFirst138ControlGenerator.generate
