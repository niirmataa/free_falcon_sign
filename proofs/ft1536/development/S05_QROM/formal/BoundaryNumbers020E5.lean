import BoundaryPayload020E5

set_option maxRecDepth 8192
namespace FT1536.S05.BoundaryNumbers020E5
/-- Exact size of the represented resident data, not a bound for all
    producer/controller temporaries or native process memory. -/
theorem payload : BoundaryPayload020E5.payloadWords=24662927270 := by
  rfl

theorem represented_resident {n : Nat} (d : BoundaryPayload020E5.Data) (hn : n≤2^511)
    (b : ScriptBuffer020E5.Buffer n 32) (cursor : Fin 33) :
    RegionRam020E5.live (BoundaryPayload020E5.withScratch d hn b cursor)=24662927381 := by
  rw [BoundaryPayload020E5.withScratch_live,payload]

theorem padded_bytes : 64*(24662927381 : Nat)=1578427352384 := by norm_num

end FT1536.S05.BoundaryNumbers020E5
