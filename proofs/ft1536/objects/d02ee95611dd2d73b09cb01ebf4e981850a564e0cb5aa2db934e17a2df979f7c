import Source3.KeygenSearchFft

/- Diagnostic only; nonempty stdout is not accepted proof evidence. -/
namespace FT1536.Source3.KeygenIntermediateProbe
def increments : List B20.C.Token → List B20.C.Token
  | name::['-']::['-']::[')']::rest => name::['-','=']::['1']::[')']::increments rest
  | t::rest => t::increments rest
  | [] => []
def text (start count : Nat) : List Char :=
  ((FT1536.FftBind.FftPin.fftLines.drop (start-1)).take count).flatMap String.toList
def parse (start count : Nat) := do
  let ts ← C99ProcedureParser.tokens (text start count++['}'])
  C99ProcedureParser.body (fun _ => none) ["f".toList] 256
    (increments (ts.map (fun t => if t="int".toList then "int32_t".toList else t)))
#eval (C99ProcedureParser.tokens (text 306 1)).map (fun ts => ts.map String.ofList)
#eval ([ (300,6), (306,29), (340,8), (343,1) ].map (fun (a,b) => (a,(parse a b).isSome)))
#eval (C99ProcedureParser.tokens (text 343 1)).map (fun ts => ts.map String.ofList)
#eval C99ArrayParser.pureExpr (["-","(","int32_t",")","logn",")",";"].map String.toList)
#eval C99ArrayParser.expr 24 (["fpr_scaled","(","2",",","-","(","int32_t",")","logn",")",";"].map String.toList)
#eval ["int","int32_t","signed","int64_t","long"].map (fun s => (s,B20.C.Scalar.typeToken s.toList))
#eval C99ArrayParser.pureExpr (["-","(","int",")","logn",")",";"].map String.toList)
#eval C99ArrayParser.expr 24 (["fpr_scaled","(","2",",","-","(","int",")","logn",")",";"].map String.toList)
end FT1536.Source3.KeygenIntermediateProbe
