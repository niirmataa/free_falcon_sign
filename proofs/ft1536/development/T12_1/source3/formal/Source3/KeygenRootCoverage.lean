import Source3.KeygenRootCaller
import Source3.KeygenM0Preprocess

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source partition at the actual control/call boundaries. Non-M0 branches
   are retained in the source certificates. M0 dispatch is justified by
   RootControl.dispatch_enabled and the transported profile, not CPP deletion. -/
namespace FT1536.Source3.KeygenRootCoverage
open KeygenRootSearch (lines)

theorem complete_body : lines 7282 115 =
    lines 7282 55 ++ lines 7337 26 ++ lines 7363 4 ++ lines 7367 6 ++
    lines 7373 1 ++ lines 7374 4 ++ lines 7378 1 ++ lines 7379 7 ++ lines 7386 11 := by
  have generic (xs : List String) : xs.take (55+(26+(4+(6+(1+(4+(1+(7+11)))))))) =
      xs.take 55 ++ (xs.drop 55).take 26 ++ (xs.drop 81).take 4 ++
      (xs.drop 85).take 6 ++ (xs.drop 91).take 1 ++ (xs.drop 92).take 4 ++
      (xs.drop 96).take 1 ++ (xs.drop 97).take 7 ++ (xs.drop 104).take 11 := by
    simp only [List.take_add,List.drop_drop,List.append_assoc]
  simpa only [lines,KeygenLevelNtt.region,List.drop_drop] using generic (Pinned.keygenLines.drop 7281)
theorem mkn_source : Pinned.keygenLines[60]?=some
    "#define MKN(logn, full)   ((size_t)(1 + ((full) << 1)) << ((logn) - (full)))\n" := by decide
theorem mkn_expansion : KeygenRootSearch.sizeExpr=C99ArrayParser.mkn (.var "logn".toList) (.var "ter".toList) := rfl
theorem caller_source : KeygenM0Preprocess.preprocess (lines 8097 10)=some [
    "\t\tif (!solve_NTRU(fk, F, G, f, g)) {\n","\t\t\tcontinue;\n","\t\t}\n"] := by decide
theorem caller_arguments : KeygenRootSource.arguments=[
    .pointer "fk".toList C99ProcedureParser.zero,.pointer "F".toList C99ProcedureParser.zero,
    .pointer "G".toList C99ProcedureParser.zero,.pointer "f".toList C99ProcedureParser.zero,
    .pointer "g".toList C99ProcedureParser.zero] := rfl

end FT1536.Source3.KeygenRootCoverage
