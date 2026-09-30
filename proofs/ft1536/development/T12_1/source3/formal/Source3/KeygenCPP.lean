import Source3.KeygenHelpers

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenCPP
open B20.C

/- Conditional-directive fragment needed by the mandatory KeyGen call site.
Unsupported directives fail; the selected M0 build has no distribution
probe macro. This is not a preprocessor for arbitrary C source files. -/
inductive Line where
  | text (s : String)
  | ifdef (name : B20.C.Name)
  | ifndef (name : B20.C.Name)
  | elseBranch
  | endBranch

def readLine (s : String) : Option Line :=
  match s.toList.dropWhile (fun c => c==' ' || c=='\t') with
  | '#'::chars => do
      let tokens ← CLogicParser.tokenize (chars.length+1) chars
      match tokens with
      | [directive,name] =>
          if directive="ifdef".toList then some (.ifdef name)
          else if directive="ifndef".toList then some (.ifndef name) else none
      | [directive] =>
          if directive="else".toList then some .elseBranch
          else if directive="endif".toList then some .endBranch else none
      | _ => none
  | _ => some (.text s)

structure Frame where
  outer : Bool
  condition : Bool
  elseSeen : Bool

def preprocessFrom (defined : B20.C.Name → Bool) :
    List String → Bool → List Frame → Option (List String)
  | [],_,stack => if stack.isEmpty then some [] else none
  | line::lines,active,stack => do
      match ← readLine line with
      | .text text =>
          let rest ← preprocessFrom defined lines active stack
          pure (if active then text::rest else rest)
      | .ifdef name =>
          preprocessFrom defined lines (active && defined name)
            (⟨active,defined name,false⟩::stack)
      | .ifndef name =>
          preprocessFrom defined lines (active && !defined name)
            (⟨active,!defined name,false⟩::stack)
      | .elseBranch =>
          match stack with
          | [] => none
          | f::rest => if f.elseSeen then none else
              preprocessFrom defined lines (f.outer && !f.condition)
                (⟨f.outer,f.condition,true⟩::rest)
      | .endBranch =>
          match stack with
          | [] => none
          | f::rest => preprocessFrom defined lines f.outer rest

def preprocess (defined : B20.C.Name → Bool) (lines : List String) : Option (List String) :=
  preprocessFrom defined lines true []

def mandatoryLines : List String := (Pinned.keygenLines.drop 8108).take 26

def visibleLines : List String :=
  (Pinned.keygenLines.drop 8108).take 4 ++
  (Pinned.keygenLines.drop 8118).take 4 ++
  (Pinned.keygenLines.drop 8129).take 5

theorem mandatory_unprobed_lines : preprocess (fun _ => false) mandatoryLines=some visibleLines := by decide

def mandatoryText : String :=
  "if (ter && logn == 10 && n == 1536) {\n\
  if (!ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G, logn, ter)) {\n\
  continue;\n}\n}\nbreak;\n"

def tokens (lines : List String) : Option (List Token) :=
  let chars:=lines.flatMap String.toList
  CLogicParser.tokenize (chars.length+1) chars

theorem mandatory_tokens :
    (preprocess (fun _ => false) mandatoryLines).bind tokens=
      CLogicParser.tokenize (mandatoryText.toList.length+1) mandatoryText.toList := by
  rw [mandatory_unprobed_lines,Option.bind_some]
  decide

theorem unmatched_end_rejected : preprocess (fun _ => false) ["#endif\n"]=none := by decide
theorem unclosed_if_rejected : preprocess (fun _ => false) ["#ifdef X\n"]=none := by decide
theorem duplicate_else_rejected :
    preprocess (fun _ => false) ["#ifdef X\n","#else\n","#else\n","#endif\n"]=none := by decide

end FT1536.Source3.KeygenCPP

#print FT1536.Source3.KeygenCPP.mandatory_tokens
#print axioms FT1536.Source3.KeygenCPP.mandatory_unprobed_lines
#print axioms FT1536.Source3.KeygenCPP.mandatory_tokens
