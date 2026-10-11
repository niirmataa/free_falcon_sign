#!/usr/bin/env python3
"""Generate the codec-only rejecting grammar from the pinned caller grammar.
The caller grammar and its witnesses are left byte-exact.
"""
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
OUTPUT=(ROOT/sys.argv[1]).resolve() if len(sys.argv)==2 else ROOT/'formal/Source3'
assert OUTPUT.is_relative_to(ROOT)
OUTPUT.mkdir(parents=True,exist_ok=True)
s=(ROOT/'formal/Source3/KeygenMakeSyntax.lean').read_text()
s=s.replace('namespace FT1536.Source3.KeygenMakeSyntax','namespace FT1536.Source3.KeygenCodecSyntax').replace('end FT1536.Source3.KeygenMakeSyntax','end FT1536.Source3.KeygenCodecSyntax')
a=s.index('/- Rejecting whole-caller grammar.');b=s.index('namespace ',a)
s=s[:a]+'''/- Codec-only grammar: both dispatch cases, while loops, unsigned
   numerals, compound assignments and pre/post increment/decrement remain
   explicit syntax. The pinned caller grammar is not changed. -/
'''+s[b:]
s=s.replace('| pointer (element : Ty)', '| readonly (element : Ty)\n  | pointer (element : Ty)')
s=s.replace('def typeToken : List Token → Option (Ty × List Token)\n', '''def typeToken : List Token → Option (Ty × List Token)
  | ['c','o','n','s','t']::rest => do
      let (ty,tail) ← typeToken rest
      pure (.readonly ty,tail)
''')
a=s.index('/- An enumerated destination');b=s.index('inductive Op where',a)
s=s[:a]+'''/- Fixed codec call table; no arbitrary callback. -/
inductive Callee where
  | none | static
  deriving DecidableEq, Repr
def calleeName : Callee → Name
  | .none => "compress_none".toList | .static => "compress_static".toList
def allCallees : List Callee := [.none,.static]
def callee (name : Name) : Option Callee := allCallees.find? (fun k => calleeName k==name)
def arity (_ : Callee) : Nat := 5
'''+s[b:]
s=s.replace('| variable (name : Name)', '| preInc (value : Expr) | postInc (value : Expr)\n  | preDec (value : Expr) | postDec (value : Expr)\n  | variable (name : Name)')
s=s.replace("let (ty,digits) := if token.getLast?=some 'L' then", "let (ty,digits) := if token.getLast?=some 'U' then (Ty.u32,token.take (token.length-1)) else if token.getLast?=some 'L' then")
s=s.replace("    | fuel+1,['(']::rest =>", "    | fuel+1,['+','+']::rest => (unary fuel rest).map (fun (e,tail) => (.preInc e,tail))\n    | fuel+1,['-']::['-']::rest => (unary fuel rest).map (fun (e,tail) => (.preDec e,tail))\n    | fuel+1,['(']::rest =>",1)
s=s.replace("    | fuel+1,e,['[']::rest =>", "    | fuel+1,e,['+','+']::rest => suffix fuel (.postInc e) rest\n    | fuel+1,e,['-']::['-']::rest => suffix fuel (.postDec e) rest\n    | fuel+1,e,['[']::rest =>")
s=s.replace('| set | add', '| set | add | sub | band | bor | shl')
s=s.replace('| loop (initial : Stmt)', '| whileLoop (test : Expr) (body : Stmt)\n  | switch (test : Expr) (noneCase staticCase fallback : Stmt)\n  | loop (initial : Stmt)')
s=s.replace("def clause (ts : List Token)", '''def assignOp : Token → Option Assign
  | ['='] => some .set | ['+','='] => some .add | ['-','='] => some .sub
  | ['&','='] => some .band | ['|','='] => some .bor | ['<','<','='] => some .shl
  | _ => none
def clause (ts : List Token)''')
a=s.index("    if op=['='] || op=['+','='] then do");b=s.index("  | [] => pure (.evaluate e,[])",a)
s=s[:a]+'''    match assignOp op with
    | some operation => do
      if !lvalue e then none else do
      let (value,tail) ← expression 24 0 tail
      pure (.write e operation value,tail)
    | none => pure (.evaluate e,op::tail)
'''+s[b:]
s=s.replace("    | fuel+1,['f','o','r']::['(']::rest =>", '''    | fuel+1,['w','h','i','l','e']::['(']::rest => do
      let (test,tail) ← expression 24 0 rest
      match tail with
      | [')']::tail => do
        let (inner,tail) ← statement fuel tail
        pure (.whileLoop test inner,tail)
      | _ => none
    | fuel+1,['f','o','r']::['(']::rest =>''')
# A compositional switch witness below keeps all case delimiters; the
# monolithic parser is deliberately not advertised as supporting switch.
s=s.replace('def header (ts : List Token)', 'def headerCore (ts : List Token)')
s=s.replace('def parseTokens (ts : List Token)', '''def header (ts : List Token) : Option (Header × List Token) :=
  headerCore (if ts.head?=some "static".toList then ts.drop 1 else ts)
def parseTokens (ts : List Token)''')
a=s.index('def expand (ts : List Token)');b=s.index('\nend FT1536.Source3.',a)
s=s[:a]+'''def expand (ts : List Token) : List Token := ts.map (fun token =>
  if token="FALCON_COMP_NONE".toList then ['0'] else
  if token="FALCON_COMP_STATIC".toList then ['1'] else token)
def tokens (text : List Char) : Option (List Token) :=
  (KeygenZintTop.tokenize (text.length+1) text).map expand
'''+s[b:]
target=OUTPUT/'KeygenCodecSyntax.lean'
assert not target.exists()
target.write_text(s)
# Extend the compositional grammar; the scalar parsers are rejecting and
# every switch arm here is exactly a returning statement, no fallthrough.
s=(ROOT/'formal/Source3/KeygenMakeGrammar.lean').read_text().replace('KeygenMake','KeygenCodec')
needle='  inductive Body : Stmt → List Token → Prop where'
s=s.replace(needle,'''    | whileLoop (e : Expr) (inner : Stmt) (test bodyTokens : List Token)
        (condition : guard e test) (iteration : Statement inner bodyTokens) :
        Statement (.whileLoop e inner)
          (["while".toList,['(']]++test++[[')']]++bodyTokens)
    | switch (test : Expr) (a b c : Expr) (ts firstTokens bt ct : List Token)
        (condition : guard test ts)
        (first : KeygenCodecSyntax.simple firstTokens=some (.ret a,[]))
        (second : KeygenCodecSyntax.simple bt=some (.ret b,[]))
        (fallback : KeygenCodecSyntax.simple ct=some (.ret c,[])) :
        Statement (.switch test (.ret a) (.ret b) (.ret c))
          (["switch".toList,['(']]++ts++[[')'],['{'],"case".toList,['0'],[':']]++firstTokens++
            ["case".toList,['1'],[':']]++bt++["default".toList,[':']]++ct++[['}']])
'''+needle)
(OUTPUT/'KeygenCodecGrammar.lean').write_text(s)
