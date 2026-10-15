import Source3.C99Declared147
import Source3.FftTripleShape145

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleDeclare147
open C99ArrayReference (State Name)

def inputNames : List Name := ["fAr".toList,"fAi".toList,"fBr".toList,"fBi".toList,"fCr".toList,"fCi".toList]
def qNames : List Name := ["xr".toList,"xi".toList]
def bNames : List Name := ["fB0r".toList,"fB0i".toList,"fB1r".toList,"fB1i".toList,"fB2r".toList,"fB2i".toList]
def cNames : List Name := ["fC0r".toList,"fC0i".toList,"fC1r".toList,"fC1i".toList,"fC2r".toList,"fC2i".toList]
def names := inputNames++(qNames++(bNames++cNames))
def first (s : State) := C99DeclarationStatements.effect .u64 inputNames s
def second (s : State) := C99DeclarationStatements.effect .u64 qNames (first s)
def third (s : State) := C99DeclarationStatements.effect .u64 bNames (second s)
def after (s : State) := C99DeclarationStatements.effect .u64 cNames (third s)
def code := C99ProcedureParser.chain (FftTripleShape145.statements.take 4)

theorem shape : code=C99ProcedureParser.chain [
    .base (.scalar (.declare .u64 inputNames)),.base (.scalar (.declare .u64 qNames)),
    .base (.scalar (.declare .u64 bNames)),.base (.scalar (.declare .u64 cNames))] := by rfl

theorem scope_names : FftMiddleShape139.scopeLocals FftTripleShape145.loopBody=names := by rfl
theorem scope_pointers : FftMiddleShape139.scopePointers FftTripleShape145.loopBody=[] := by rfl

theorem flat (s : State) : after s=C99DeclarationStatements.effect .u64 names s := by rfl

theorem source (s : State) : C99ProcedureReference.Exec KeygenSearchFft.program code s ⟨after s,.normal⟩ := by
  rw [shape]
  exact .seqNormal _ _ _ (first s) _ (.base _ _ _ (C99DeclarationStatements.source_exists _ .u64 inputNames s))
    (.seqNormal _ _ _ (second s) _ (.base _ _ _ (C99DeclarationStatements.source_exists _ .u64 qNames (first s)))
    (.seqNormal _ _ _ (third s) _ (.base _ _ _ (C99DeclarationStatements.source_exists _ .u64 bNames (second s)))
    (.seqNormal _ _ _ (after s) _ (.base _ _ _ (C99DeclarationStatements.source_exists _ .u64 cNames (third s))) (.base _ _ _ (.skip _)))))

theorem uninitialized (s : State) (name : Name) (found : name∈names) : (after s).locals name=some (.uint64,none) := by
  rw [flat]
  exact C99Declared147.member .uint64 names s.locals name found

theorem declared (s : State) : C99Declared147.Declared (after s) names := fun name found => ⟨none,uninitialized s name found⟩

theorem outside (s : State) (name : Name) (absent : name∉names) : (after s).locals name=s.locals name := by
  rw [flat]
  exact C99DeclareOutside140.source .uint64 names s.locals name absent

end FT1536.Source3.FftTripleDeclare147
