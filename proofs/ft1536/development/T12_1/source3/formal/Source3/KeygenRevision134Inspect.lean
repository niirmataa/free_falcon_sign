import Source3.KeygenSuccessMass112
import Source3.KeygenFirstMass112
import Source3.KeygenCountTarget112
import Source3.KeygenAttemptNorm133
import Lean.Util.FoldConsts

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Diagnostic dependency graph, not a mathematical premise. Every proposed
   revised declaration still requires ordinary source elaboration/kernel checking. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let env ← Lean.getEnv
  let mut rows : Array Lean.Json := #[]
  for (name,info) in env.constants do
    if name.toString.startsWith "FT1536.Source3." then
      let used := info.getUsedConstantsAsSet.toList.filter (fun n => n.toString.startsWith "FT1536.Source3.")
      let moduleName := match env.getModuleIdxFor? name with
        | some index => env.header.moduleNames[index]!.toString
        | none => "CURRENT"
      rows := rows.push (Lean.Json.mkObj [
        ("name",Lean.toJson name.toString),("module",Lean.toJson moduleName),
        ("dependencies",Lean.toJson (used.map Lean.Name.toString))])
  IO.FS.writeFile "../REVISION134_CONSTANT_DEPENDENCIES.json" (Lean.Json.pretty (Lean.Json.arr rows))
