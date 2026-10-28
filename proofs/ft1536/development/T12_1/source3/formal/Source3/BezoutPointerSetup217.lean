import Source3.BezoutDeclarations217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source bezout part1: six working pointers over selected 335-word buffers. -/
namespace FT1536.Source3.BezoutPointerSetup217
open C99ArrayReference (State bindPointer)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open KeygenZintCall (Stmt Exec)
open KeygenSmallOutput (element)
open ZintNormWalk194 (wordArray)
open DeepestBezoutEntry217 (Fp Gp)
open DeepestSelectedCrt217 (tmp)

def varLen : CLogic.Expr := .var "len".toList
def bind (target source : String) (index : CLogic.Expr) : Stmt := wordArray (.bindPtr target.toList source.toList index)
def code : Stmt := KeygenZintCall.chain [bind "u0" "u" C99ProcedureParser.zero,bind "v0" "v" C99ProcedureParser.zero,
  bind "u1" "tmp" C99ProcedureParser.zero,bind "v1" "u1" varLen,bind "a" "v1" varLen,bind "b" "a" varLen]

def before (s : State) := BezoutDeclarations217.after (DeepestBezoutEntry217.entry s)
def v1 := element tmp 335
def a := element v1 335
def b := element a 335
def s1 (s : State) := bindPointer (before s) "u0".toList Gp
def s2 (s : State) := bindPointer (s1 s) "v0".toList Fp
def s3 (s : State) := bindPointer (s2 s) "u1".toList tmp
def s4 (s : State) := bindPointer (s3 s) "v1".toList v1
def s5 (s : State) := bindPointer (s4 s) "a".toList a
def after (s : State) := bindPointer (s5 s) "b".toList b

theorem shape : KeygenZintCall.bezoutPart 1=code := by decide

theorem source (s : State) : Exec (KeygenZintCall.bezoutPart 1) (before s) ⟨after s,.normal⟩ := by
  rw [shape]
  have first : Exec (bind "u0" "u" C99ProcedureParser.zero) (before s) ⟨s1 s,.normal⟩ :=
    ZintNormWord194.word_run _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ Gp
      (RootBinding175.zero _ "u" Gp rfl (by decide)))))
  have second : Exec (bind "v0" "v" C99ProcedureParser.zero) (s1 s) ⟨s2 s,.normal⟩ :=
    ZintNormWord194.word_run _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ Fp
      (RootBinding175.zero _ "v" Fp rfl (by decide)))))
  have third : Exec (bind "u1" "tmp" C99ProcedureParser.zero) (s2 s) ⟨s3 s,.normal⟩ :=
    ZintNormWord194.word_run _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ tmp
      (RootBinding175.zero _ "tmp" tmp rfl (by decide)))))
  have fourth : Exec (bind "v1" "u1" varLen) (s3 s) ⟨s4 s,.normal⟩ :=
    ZintNormWord194.word_run _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ v1
      (.add _ _ tmp v1 (.uint64 335) rfl (.variable _ _ _ (show Cell (s3 s) "len".toList 335 from by rfl))
        (by decide) (.within tmp 335 (by decide))))))
  have fifth : Exec (bind "a" "v1" varLen) (s4 s) ⟨s5 s,.normal⟩ :=
    ZintNormWord194.word_run _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ a
      (.add _ _ v1 a (.uint64 335) rfl (.variable _ _ _ (show Cell (s4 s) "len".toList 335 from by rfl))
        (by decide) (.within v1 335 (by decide))))))
  have sixth : Exec (bind "b" "a" varLen) (s5 s) ⟨after s,.normal⟩ :=
    ZintNormWord194.word_run _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ b
      (.add _ _ a b (.uint64 335) rfl (.variable _ _ _ (show Cell (s5 s) "len".toList 335 from by rfl))
        (by decide) (.within a 335 (by decide))))))
  exact .seqNormal _ _ _ _ _ first (.seqNormal _ _ _ _ _ second (.seqNormal _ _ _ _ _ third
    (.seqNormal _ _ _ _ _ fourth (.seqNormal _ _ _ _ _ fifth (.seqNormal _ _ _ _ _ sixth (ZintNormWord194.word_skip _))))))

theorem heap (s : State) : (after s).heap=s.heap := by
  change (before s).heap=s.heap
  exact (BezoutDeclarations217.heap _).trans rfl
theorem x_binding (s : State) : (after s).arrays "x".toList=some NinthStepLayout217.fd := rfl
theorem y_binding (s : State) : (after s).arrays "y".toList=some NinthStepLayout217.gd := rfl

end FT1536.Source3.BezoutPointerSetup217
