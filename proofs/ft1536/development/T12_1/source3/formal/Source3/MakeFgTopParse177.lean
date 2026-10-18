import Source3.MakeFgTopNormalize177

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MakeFgTopParse177

def parsed : Option KeygenLevelExec.Stmt := do
  let (code,_,rest) ← KeygenLevelParser.body (KeygenMakeFgTop.types.map Prod.fst) 512 MakeFgTopNormalize177.tokens
  if rest.isEmpty then pure code else none

theorem source : KeygenMakeFgTop.parsed=parsed := by
  unfold KeygenMakeFgTop.parsed KeygenLevelParser.region
  rw [MakeFgTopBytes177.bytes]
  change (do
    let tokens ← KeygenLevelParser.tokenize (MakeFgTopBytes177.chars.length+1) MakeFgTopBytes177.chars
    let tokens ← KeygenSearchParser.sizes KeygenMakeFgTop.types (C99ArrayParser.normalizeTypes tokens)
    let (code,_,rest) ← KeygenLevelParser.body (KeygenMakeFgTop.types.map Prod.fst) 512 tokens
    if rest.isEmpty then pure code else none)=parsed
  rw [MakeFgTopLex177.source]
  change (do
    let tokens ← KeygenSearchParser.sizes KeygenMakeFgTop.types (C99ArrayParser.normalizeTypes MakeFgTopLex177.tokens)
    let (code,_,rest) ← KeygenLevelParser.body (KeygenMakeFgTop.types.map Prod.fst) 512 tokens
    if rest.isEmpty then pure code else none)=parsed
  rw [MakeFgTopNormalize177.source]
  rfl

theorem code : KeygenMakeFgTop.code=parsed.getD KeygenLevelExec.skip :=
  congrArg (fun x => x.getD KeygenLevelExec.skip) source

end FT1536.Source3.MakeFgTopParse177
