import Source3.KeygenMakeBindingPart11
import Source3.KeygenMakeTokens

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

def signatureTokens : List B20.C.Token := ["int","falcon_keygen_make","(","falcon_keygen","*","fk",",","int","comp",",","void","*","privkey",",","size_t","*","privkey_len",",","void","*","pubkey",",","size_t","*","pubkey_len",")","{"].map String.toList
run_cmd IO.FS.writeFile "../MAKE_BINDING_PROGRESS.json" "{\"boundary\":\"all303nodes\"}\n"
theorem signature_source : header signatureTokens=some (expectedHeader,[]) := by rfl
def code : Stmt := .scope node302
def completeTokens : List B20.C.Token := signatureTokens++node302Tokens++[['}']]
theorem complete_tokens_source : completeTokens=KeygenMakeTokens.all := by rfl
theorem source_bound : Whole KeygenMakeTokens.all expectedHeader code := by
  exact .function _ _ _ _ _ signature_source node302_source complete_tokens_source.symm

end FT1536.Source3.KeygenMakeBinding
