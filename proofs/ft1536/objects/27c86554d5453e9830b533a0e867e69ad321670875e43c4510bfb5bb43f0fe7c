import Source3.CertificateFunctionWitness

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateFunctionSyntax

def region (start count : Nat) : List String := (Pinned.keygenLines.drop (start-1)).take count
def sections : List (Nat×Nat) :=
  [(7689,6),(7695,8),(7703,1),(7704,1),(7705,4),(7709,8),
   (7717,4),(7721,25),(7746,11),(7757,20),(7777,2)]

theorem whole_function_partition : region 7689 90=sections.flatMap (fun pair => region pair.1 pair.2) := by decide

def badStatement : Option CLogic.Stmt := do
  let chars := (region 7703 1).flatMap String.toList
  let tokens ← CLogicParser.tokenize (chars.length+1) chars
  let (statement,rest) ← CLogicParser.statement tokens
  if rest.isEmpty then pure statement else none
theorem bad_statement_bound : badStatement=some (.assign "bad".toList CertificateBadAssignment.value) := by decide

def Bound : Prop :=
  CertificateAfterConversion.parseRegion 7695 8=some CertificatePrologue.code ∧
  badStatement=some (.assign "bad".toList CertificateBadAssignment.value) ∧
  CertificateAfterConversion.parseRegion 7705 4=some CertificateDeclarations.code ∧
  CertificateAfterConversion.parseRegion 7709 8=some CertificateAliases.code ∧
  CertificateConversions.sourceBody=some CertificateConversions.code ∧
  CertificateAfterConversion.parseRegion 7721 25=some CertificateAfterConversion.code ∧
  CElementLoop.parse "g00".toList (KeygenHelpers.slice 7745 11)=some RootGate00.program ∧
  CertificateSuffixSyntax.source=some CertificateSuffixSyntax.expected

theorem bound : Bound :=
  ⟨CertificatePrologue.source_bound,bad_statement_bound,CertificateDeclarations.source_bound,
   CertificateAliases.source_bound,CertificateConversions.source_bound,CertificateAfterConversion.source_bound,
   RootGate00.source_parses,CertificateSuffixSyntax.pinned_source⟩

end FT1536.Source3.CertificateFunctionSyntax
