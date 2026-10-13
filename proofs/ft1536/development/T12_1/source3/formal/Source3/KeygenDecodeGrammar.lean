import Source3.KeygenDecodeSyntax

/- Compositional form of the same rejecting grammar. Atomic clauses and
   conditions use the checked parser unchanged. Control constructors keep
   every delimiter, BOTH runtime arms and every scope. This avoids reducing
   the whole source and all nested parser calls in one kernel equality. -/
namespace FT1536.Source3.KeygenDecodeGrammar
open B20.C (Token)
open KeygenDecodeSyntax

abbrev guard (e : Expr) (ts : List Token) : Prop := expression 24 0 ts=some (e,[])
abbrev initialClause (code : Stmt) (ts : List Token) : Prop :=
  endedClause [';'] (ts++[[';']])=some (code,[])
abbrev incrementClause (code : Stmt) (ts : List Token) : Prop :=
  endedClause [')'] (ts++[[')']])=some (code,[])
inductive Test : Option Expr → List Token → Prop where
  | absent : Test none []
  | present (e : Expr) (ts : List Token) (parsed : guard e ts) : Test (some e) ts
mutual
  inductive Statement : Stmt → List Token → Prop where
    | simple (code : Stmt) (ts : List Token) (parsed : KeygenDecodeSyntax.simple ts=some (code,[])) :
        Statement code ts
    | scope (code : Stmt) (ts : List Token) (body : Body code ts) :
        Statement (.scope code) ([['{']]++ts++[['}']])
    | ifOnly (e : Expr) (yes : Stmt) (test yesTokens : List Token)
        (condition : guard e test) (branch : Statement yes yesTokens) :
        Statement (.branch e yes .skip) (["if".toList,['(']]++test++[[')']]++yesTokens)
    | ifElse (e : Expr) (yes no : Stmt) (test yesTokens noTokens : List Token)
        (condition : guard e test) (first : Statement yes yesTokens) (second : Statement no noTokens) :
        Statement (.branch e yes no) (["if".toList,['(']]++test++[[')']]++yesTokens++["else".toList]++noTokens)
    | loop (init update body : Stmt) (e : Option Expr) (first test last inner : List Token)
        (initial : initialClause init first) (condition : Test e test)
        (increment : incrementClause update last) (iteration : Statement body inner) :
        Statement (.loop init e update body)
          (["for".toList,['(']]++first++[[';']]++test++[[';']]++last++[[')']]++inner)
    | whileLoop (e : Expr) (inner : Stmt) (test bodyTokens : List Token)
        (condition : guard e test) (iteration : Statement inner bodyTokens) :
        Statement (.whileLoop e inner)
          (["while".toList,['(']]++test++[[')']]++bodyTokens)
    | switch (test : Expr) (a b c : Expr) (ts firstTokens bt ct : List Token)
        (condition : guard test ts)
        (first : KeygenDecodeSyntax.simple firstTokens=some (.ret a,[]))
        (second : KeygenDecodeSyntax.simple bt=some (.ret b,[]))
        (fallback : KeygenDecodeSyntax.simple ct=some (.ret c,[])) :
        Statement (.switch test (.ret a) (.ret b) (.ret c))
          (["switch".toList,['(']]++ts++[[')'],['{'],"case".toList,['0'],[':']]++firstTokens++
            ["case".toList,['1'],[':']]++bt++["default".toList,[':']]++ct++[['}']])
  inductive Body : Stmt → List Token → Prop where
    | nil : Body .skip []
    | cons (head tail : Stmt) (first rest : List Token)
        (statement : Statement head first) (body : Body tail rest) :
        Body (.seq head tail) (first++rest)
end
inductive Whole : List Token → Header → Stmt → Prop where
  | function (ts beginning inner : List Token) (h : Header) (body : Stmt)
      (signature : KeygenDecodeSyntax.header beginning=some (h,[]))
      (statements : Body body inner) (allBytes : ts=beginning++inner++[['}']]) :
      Whole ts h (.scope body)

end FT1536.Source3.KeygenDecodeGrammar
