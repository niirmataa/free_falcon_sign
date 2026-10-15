import Source3.Packing130Generator

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Finite proposal/control only; source witnesses are checked separately. -/
namespace FT1536.Source3.ResultantTail130Generator

def words (state : C99CompactState115.State) : IO (Array Nat) := do
  let mut values := #[]
  for i in List.range 96 do
    match C99FiniteRead114.read32 state.heap ⟨7,0,96,4,i⟩ with
    | some word => values := values.push word.toNat
    | none => throw (IO.userError "Candidate b word unreadable")
  pure values

def generate : IO Unit := do
  let mut rows : Array Lean.Json := #[]
  for name in ["f","g"] do
    let initial ← Packing130Generator.initial name
    let packed ← Packing130Generator.segment 1536 initial
    let reduced ← match KeygenWordEndpoints130.normal 256 (GeneratedResultantSyntax130.reduction 10) packed with
      | some value => pure value | none => throw (IO.userError "Candidate reduction failed")
    let (last,value) ← match KeygenWordEndpoints130.returned 32 GeneratedResultantSyntax130.ending reduced with
      | some value => pure value | none => throw (IO.userError "Candidate tail failed")
    rows := rows.push (Lean.Json.mkObj [("array",Lean.toJson name),("packed",Lean.toJson (← words packed)),
      ("reduced",Lean.toJson (← words reduced)),("return",Lean.toJson value.integer),
      ("final",Lean.toJson (← words last))])
  IO.FS.writeFile "../RESULTANT130_CANDIDATES.json" (Lean.Json.arr rows |>.pretty)

end FT1536.Source3.ResultantTail130Generator

#eval FT1536.Source3.ResultantTail130Generator.generate
