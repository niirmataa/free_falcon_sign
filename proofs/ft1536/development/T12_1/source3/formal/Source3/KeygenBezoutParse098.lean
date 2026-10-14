import Source3.KeygenBezoutTokens098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBezoutParse098
open B20.C (Token)
open C99ArrayReference (Name)
open KeygenZintCall (Stmt skip)

def sourceChars (start count : Nat) : List Char :=
  ((Pinned.keygenLines.drop (start - 1)).take count).flatMap String.toList ++ ['}']

def after (types : KeygenWordExpr.Types) (ptrs : List Name) (lexed : List Token) : Option Stmt := do
  let (code, _, rest) ← KeygenZintCall.parseBody types ptrs 512 lexed
  if rest.isEmpty then pure code else none

def fromChars (types : KeygenWordExpr.Types) (ptrs : List Name) (chars : List Char) : Option Stmt :=
  (KeygenZintCall.tokens chars).bind (after types ptrs)

theorem region_source (types : KeygenWordExpr.Types) (ptrs : List Name) (start count : Nat) :
    KeygenZintCall.region types ptrs start count = fromChars types ptrs (sourceChars start count) := rfl

theorem after_lexer (types : KeygenWordExpr.Types) (ptrs : List Name) (chars : List Char) (lexed : List Token)
    (source : KeygenZintCall.tokens chars = some lexed) : fromChars types ptrs chars = after types ptrs lexed := by
  unfold fromChars
  rw [source]
  rfl

theorem region_alias : KeygenZintCall.bezoutParsed 7 =
    KeygenZintCall.region (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs 4015 185 := rfl

theorem chars_link : sourceChars 4015 185 = KeygenBezoutTokens098.chars := rfl

theorem source_parsed : KeygenZintCall.bezoutParsed 7 =
    after (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs KeygenBezoutTokens098.tokens :=
  region_alias.trans ((region_source _ _ 4015 185).trans
    ((congrArg (fromChars (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs) chars_link).trans
      (after_lexer _ _ _ _ KeygenBezoutTokens098.source)))

def codeFromTokens (lexed : List Token) : Stmt :=
  (after (KeygenZintCall.widths .bezout) KeygenZintCall.bezoutPtrs lexed).getD skip

theorem getD_congr (a b : Option Stmt) (source : a = b) : a.getD skip = b.getD skip :=
  congrArg (fun result : Option Stmt => result.getD skip) source

theorem part_alias : KeygenZintCall.bezoutPart 7 = (KeygenZintCall.bezoutParsed 7).getD skip := rfl

theorem source_code : KeygenZintCall.bezoutPart 7 = codeFromTokens KeygenBezoutTokens098.tokens :=
  part_alias.trans (getD_congr _ _ source_parsed)

end FT1536.Source3.KeygenBezoutParse098
