import Source3.DeepestBezoutEntry217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact source declarations of the zint_bezout callee. -/
namespace FT1536.Source3.BezoutDeclarations217
open C99ArrayReference (State Name)
open KeygenZintCall (Stmt Exec)
open DeepestDeclarations175 (clear clearAll)
open ZintNormWord194 (wordScalar wskip)

def pointers : List Name := ["u0","u1","v0","v1","a","b"].map String.toList
def lengths : List Name := ["xlen","ylen","alen","blen","mlen"].map String.toList
def words : List Name := ["x0i","y0i"].map String.toList
def ptrCode : List Name → Stmt
  | [] => wskip
  | n::rest => .seq (ZintNormWalk194.wordArray (.declarePtr n)) (ptrCode rest)
def code : Stmt := .seq (ptrCode pointers)
  (.seq (wordScalar (.declare .u64 lengths)) (.seq (wordScalar (.declare .u32 words)) wskip))

def afterPointers (s : State) := clearAll s pointers
def afterLengths (s : State) := C99DeclarationStatements.effect .u64 lengths (afterPointers s)
def after (s : State) := C99DeclarationStatements.effect .u32 words (afterLengths s)

theorem shape : KeygenZintCall.bezoutPart 0=code := by decide

theorem ptr_source (ns : List Name) (s : State) : Exec (ptrCode ns) s ⟨clearAll s ns,.normal⟩ := by
  induction ns generalizing s with
  | nil => exact ZintNormWord194.word_skip s
  | cons n rest ih =>
    exact .seqNormal _ _ s (clear s n) _ (ZintRebuildCrt194.declarePtr_run s n) (ih (clear s n))

theorem source (s : State) : Exec (KeygenZintCall.bezoutPart 0) s ⟨after s,.normal⟩ := by
  rw [shape]
  exact .seqNormal _ _ s (afterPointers s) _ (ptr_source pointers s)
    (.seqNormal _ _ (afterPointers s) (afterLengths s) _ (ZintNormWord194.word_declare .u64 lengths _)
      (.seqNormal _ _ (afterLengths s) (after s) _ (ZintNormWord194.word_declare .u32 words _)
        (ZintNormWord194.word_skip _)))

theorem heap (s : State) : (after s).heap=s.heap := rfl

theorem tables (s : State) : (after s).tables=s.tables := rfl

end FT1536.Source3.BezoutDeclarations217
