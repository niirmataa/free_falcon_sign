import Source3.KeygenDecodeNoneScalar

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Honest NONE pair-stream adapter. All pair calculations are proved from
   the source scalar expressions, but this adapter is not the complete
   source execution relation. No memory/frame or source round-trip is claimed. -/
namespace FT1536.Source3.KeygenDecodeNonePairs
open KeygenDecodeNoneScalar

def wire : List (BitVec 16) → List (BitVec 8)
  | [] => []
  | input::rest => high input::low input::wire rest

def parse : Nat → List (BitVec 8) → Option (List (BitVec 16) × List (BitVec 8))
  | 0,bytes => some ([],bytes)
  | n+1,hi::lo::rest => do
      let input ← decodePair hi lo
      let (inputs,tail) ← parse n rest
      pure (input::inputs,tail)
  | _+1,_ => none

def CarrierList (inputs : List (BitVec 16)) : Prop := ∀ input, input∈inputs → Carrier input

theorem wire_length (inputs : List (BitVec 16)) : (wire inputs).length=2*inputs.length := by
  induction inputs with
  | nil => rfl
  | cons input rest ih => simp only [wire,List.length_cons,ih]; omega

/-- The adapter consumes precisely the honest segment, retaining an arbitrary
    tail. A full decoder theorem must additionally derive this adapter from
    its actual byte loads, source loop and int16 stores. -/
theorem segment_roundtrip (inputs : List (BitVec 16)) (tail : List (BitVec 8))
    (carrier : CarrierList inputs) : parse inputs.length (wire inputs++tail)=some (inputs,tail) := by
  induction inputs with
  | nil => rfl
  | cons input rest ih =>
    have first := pair_roundtrip input (carrier input List.mem_cons_self)
    have later := ih (fun value member => carrier value (List.mem_cons_of_mem input member))
    simp only [wire,List.cons_append,List.length_cons,parse,first,later]
    rfl

end FT1536.Source3.KeygenDecodeNonePairs
