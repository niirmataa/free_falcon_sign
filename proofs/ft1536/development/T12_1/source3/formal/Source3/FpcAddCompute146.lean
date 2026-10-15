import Source3.FftPairClosed140
import Source3.C99ArrayChain146

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FpcAddCompute146
open C99ArrayReference (State Name Stmt Program Exec)
open FftPairShape140 (temporaries)
open FftMulStates140 (Words)
open FftPairStates140 (declared realState imagState)

structure Inputs where
  ar : Name
  ai : Name
  br : Name
  bi : Name

def expr (name : Name) : C99ArrayReference.Expr := .scalar (.var name)
def operations (p : Inputs) : List Stmt := [
  .scalar (.declare .u64 temporaries),
  .assign "fpct_re".toList (FftWordExpressions140.add (expr p.ar) (expr p.br)),
  .assign "fpct_im".toList (FftWordExpressions140.add (expr p.ai) (expr p.bi))]

structure Entry (s : State) (p : Inputs) (x : Words) : Prop where
  ar : s.locals p.ar=some (.uint64,some (.uint64 x.ar))
  ai : s.locals p.ai=some (.uint64,some (.uint64 x.ai))
  br : s.locals p.br=some (.uint64,some (.uint64 x.br))
  bi : s.locals p.bi=some (.uint64,some (.uint64 x.bi))
  arSafe : p.ar∉temporaries
  aiSafe : p.ai∉temporaries
  brSafe : p.br∉temporaries
  biSafe : p.bi∉temporaries

theorem different (name temp : Name) (safe : name∉temporaries) (member : temp∈temporaries) : name≠temp := by
  intro same
  subst name
  exact safe member

theorem declared_outside (s : State) (name : Name) (safe : name∉temporaries) : (declared s).locals name=s.locals name :=
  C99DeclareOutside140.source .uint64 temporaries s.locals name safe

theorem real_outside (s : State) (x : Words) (name : Name) (safe : name∉temporaries) :
    (realState .add s x).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ (different name _ safe (by decide))).trans (declared_outside s name safe)

theorem real_source (program : Program) (s : State) (p : Inputs) (x : Words) (entry : Entry s p x) :
    Exec program (.assign "fpct_re".toList (FftWordExpressions140.add (expr p.ar) (expr p.br)))
      (declared s) (realState .add s x) := by
  apply FftLocalCells140.assign program (declared s) _ _ none (FftPairStates140.real .add x)
  · simp [declared,C99DeclarationStatements.effect,temporaries,C99DeclarationCells.declareCells,C99ScalarReference.set,C99ValueBridge.type]
  · exact FftWordExpressions140.add_source _ _ _ _ _
      (FftLocalCells140.read_var _ _ _ ((declared_outside s p.ar entry.arSafe).trans entry.ar))
      (FftLocalCells140.read_var _ _ _ ((declared_outside s p.br entry.brSafe).trans entry.br))

theorem imag_source (program : Program) (s : State) (p : Inputs) (x : Words) (entry : Entry s p x) :
    Exec program (.assign "fpct_im".toList (FftWordExpressions140.add (expr p.ai) (expr p.bi)))
      (realState .add s x) (imagState .add s x) := by
  apply FftLocalCells140.assign program (realState .add s x) _ _ none (FftPairStates140.imag .add x)
  · simp [realState,FftLocalCells140.put,declared,C99DeclarationStatements.effect,temporaries,C99DeclarationCells.declareCells,C99ScalarReference.set,C99ValueBridge.type]
  · exact FftWordExpressions140.add_source _ _ _ _ _
      (FftLocalCells140.read_var _ _ _ ((real_outside s x p.ai entry.aiSafe).trans entry.ai))
      (FftLocalCells140.read_var _ _ _ ((real_outside s x p.bi entry.biSafe).trans entry.bi))

theorem source (program : Program) (s : State) (p : Inputs) (x : Words) (entry : Entry s p x) :
    Exec program (FpcSourceExpansion.sequence (operations p)) s (imagState .add s x) :=
  .seq _ _ _ _ _ (C99DeclarationStatements.source_exists program .u64 temporaries s)
    (.seq _ _ _ _ _ (real_source program s p x entry)
      (.seq _ _ _ _ _ (imag_source program s p x entry) (.skip _)))

end FT1536.Source3.FpcAddCompute146
