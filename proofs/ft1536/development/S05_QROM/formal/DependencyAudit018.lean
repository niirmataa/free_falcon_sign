import ActualInterface017
import Lean.Util.CollectAxioms

/- Compiler dependency inspection, not a new mathematical theorem or review. -/
open Lean Elab Command
namespace FT1536.S05.DependencyAudit018
private def nameOf (s : String) : Name := (s.splitOn ".").foldl Name.str Name.anonymous
private partial def walk (env : Environment) (todo : List Name) (seen missing : NameSet) : NameSet×NameSet :=
  match todo with
  | [] => (seen,missing)
  | n::ns =>
    if seen.contains n then walk env ns seen missing else
    let seen := seen.insert n
    match env.checked.get.find? n with
    | none => walk env ns seen (missing.insert n)
    | some ci =>
      let deps := ci.type.getUsedConstants.toList ++
        (match ci.value? (allowOpaque:=true) with | some v => v.getUsedConstants.toList | none => []) ++
        (match ci with | .inductInfo v => v.ctors | _ => [])
      walk env (deps++ns) seen missing
run_cmd do
  let roots := [``FT1536.S05.ActualInterface017.initial_certificate,
    ``FT1536.S05.ActualInterface017.key_law_under_cover,
    ``FT1536.S05.ActualInterface017.actual_pair_leaves]
  let forbidden := ["FT1536.AdvPrg.assembled_hardness_substitution_chacha",
    "FT1536.AdvPrg.end_to_end_assembled_theorem_statement_chacha",
    "FT1536.Assembly.end_to_end_assembled_theorem_statement",
    "FT1536.Assembly.end_to_end_assembled_theorem_statement_prgTerm",
    "FT1536.Assembly.end_to_end_assembled_theorem_attemptFactor",
    "FT1536.Assembly.exists_assembled_reducer",
    "FT1536.Assembly.assembled_hardness_substitution",
    "FT1536.HacGlue.localJointCertificate_of_named_premises",
    "FT1536.HacGlue.localJointCertificate_of_named_premises_e",
    "FT1536.HacGlue.localJointCertificate_of_pointwise_premises",
    "FT1536.HacGlue.localJointCertificate_of_named_premises_attemptFactor",
    "FT1536.ONoneGeometry.localJointCertificate_of_attemptFactor",
    "FT1536.Source3.KeygenMakeAttemptSpine.attempt_spine",
    "FT1536.Source3.KeygenMakeInvocation.invocation_certificate"].map nameOf
  let (used,missing) := walk (← getEnv) roots {} {}
  let found := forbidden.filter used.contains
  if !found.isEmpty then throwError m!"DO_NOT_CONSUME dependencies found: {found}"
  if !missing.isEmpty then throwError m!"Unresolved dependencies: {missing.toArray}"
  logInfo m!"DEPENDENCY_AUDIT_PASS roots={roots.length} visited={used.toArray.size} forbidden={forbidden.length} found=0 missing=0"
end FT1536.S05.DependencyAudit018
