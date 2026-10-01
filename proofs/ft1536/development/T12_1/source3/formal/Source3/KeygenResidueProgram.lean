import Source3.C99ModularAnnotation
import Source3.KeygenCheckProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenResidueProgram
open C99ModularReference (Expr Stmt)

def signedNames : List C99ArrayReference.Name := ["f","g","F","G"].map String.toList
def conversion (source : String) : Expr :=
  .call2 "modp_set".toList (.load16 source.toList (.var "u".toList)) (.scalar (.var "p".toList))
def store (dst src : String) : Stmt := .store32 dst.toList (.var "u".toList) (conversion src)
def stores : List (String×String) := [("ft","f"),("gt","g"),("Ft","F"),("Gt","G")]
def chain : List (String×String) → Stmt
  | [] => .base .skip
  | (dst,src)::rest => .seq (store dst src) (chain rest)
def iteration : Stmt := .scope [] (chain stores)
def loop : Stmt := .loop KeygenCheckProgram.guard iteration KeygenCheckProgram.increment
def code : Stmt := .seq (.seq KeygenCheckProgram.counter loop) (.base .skip)

theorem source_header : (Pinned.keygenLines.drop 7278).take 2 =
    ["solve_NTRU(falcon_keygen *fk, int16_t *F, int16_t *G,\n","\tconst int16_t *f, const int16_t *g)\n"] := by decide
theorem source_bound : (C99ModularParser.region 7367 6).map (C99ModularAnnotation.statement signedNames)=some code := by decide

end FT1536.Source3.KeygenResidueProgram
