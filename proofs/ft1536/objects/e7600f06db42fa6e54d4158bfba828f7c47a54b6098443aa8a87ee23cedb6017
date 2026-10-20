import Source3.KeygenZintTop

/- Source lexical decomposition at whitespace boundaries. Each part must
   start with whitespace and end with a newline; its complete inherited
   lexer must succeed (in particular a block comment cannot remain open).
   Concatenation therefore never splits a C word, operator or comment.
   No character or unrecognized construct is silently removed. -/
namespace FT1536.Source3.KeygenLexicalChunks
def chars (lines : List String) : List Char := lines.flatMap String.toList
def boundary (lines : List String) : Bool :=
  ((chars lines).head?).any (fun c => c==' ' || c=='\t' || c=='\n' || c=='\r') &&
  (chars lines).getLast?==some '\n'
def Checked (lines : List String) (tokens : List B20.C.Token) : Prop :=
  boundary lines=true ∧ KeygenZintTop.tokens (chars lines)=some tokens
def closing : List B20.C.Token := [['}']]
inductive Bound (source : List String) (tokens : List B20.C.Token) : Prop where
  | parts (groups : List (List String)) (words : List (List B20.C.Token))
      (partition : groups.flatten=source)
      (lexed : List.Forall₂ Checked groups words)
      (joined : words.flatten++closing=tokens) : Bound source tokens
theorem transport (before after : List String) (tokens : List B20.C.Token)
    (same : before=after) (binding : Bound after tokens) : Bound before tokens := same.symm ▸ binding
end FT1536.Source3.KeygenLexicalChunks
