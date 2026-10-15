import Source3.FftTriplingInvariant148
import Source3.C99OuterScalar144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTriplingSetup148
open C99ArrayReference (State)
open C99NatWord141 (word)
open C99IntegerReference (Value)

def declaration : C99ProcedureReference.Stmt := .base (.scalar (.declare .u64 ["v".toList]))
def shift : CLogic.Expr := .bin .shl (.cast .u64 (.literal .i32 1)) (.var "logn".toList)
def declared (s : State) := C99DeclarationStatements.effect .u64 ["v".toList] s
def zero (s : State) := FftLocalCells140.put (declared s) "u".toList (word 0)
def initial (s : State) := FftLocalCells140.put (zero s) "v".toList (word 1024)

theorem branch_shape : FftTripleShape145.code=.branch (.var "full".toList) FftTripleShape145.yes (.base .skip) := by rfl

theorem yes_shape : FftTripleShape145.yes=.scope ["v".toList] []
    (.seq declaration (.seq (.seq FftTripleShape145.initial FftTripleShape145.loop) (.base .skip))) := by rfl

theorem initial_shape : FftTripleShape145.initial=.seq (.base (.scalar (.assign "u".toList (.literal .i32 0))))
    (.base (.scalar (.assign "v".toList shift))) := by rfl

theorem declaration_source (s : State) : C99ProcedureReference.Exec KeygenSearchFft.program declaration s ⟨declared s,.normal⟩ :=
  .base _ _ _ (C99DeclarationStatements.source_exists _ .u64 ["v".toList] s)

theorem shift_source (s : State) (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))) :
    C99ArrayReference.scalar s shift (.uint64 (word 1024)) :=
  .shift .left _ _ (.uint64 1) (.uint32 10) (.uint64 (word 1024))
    (.cast .uint64 _ (.int32 1) (.literal .int32 1))
    (.variable "logn".toList .uint32 (.uint32 10) logn)
    (.unsignedLeft (.uint64 1) (.uint32 10) 10 rfl rfl (by decide))

theorem initialization (s : State) (old : Option Value)
    (uDeclared : s.locals "u".toList=some (.uint64,old))
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.initial (declared s) ⟨initial s,.normal⟩ := by
  rw [initial_shape]
  have uCell : (declared s).locals "u".toList=some (.uint64,old) :=
    (C99DeclareOutside140.source .uint64 ["v".toList] s.locals "u".toList (by decide)).trans uDeclared
  have lognCell : (zero s).locals "logn".toList=some (.uint32,some (.uint32 10)) :=
    (FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((C99DeclareOutside140.source .uint64 ["v".toList] s.locals "logn".toList (by decide)).trans logn)
  refine .seqNormal _ _ _ (zero s) _ (C99OuterScalar144.clear _ (declared s) "u".toList old uCell) ?_
  unfold initial
  rw [FftLocalCells140.put_bind]
  refine .base _ _ _ (.scalar _ _ _ (.assign (zero s).locals "v".toList _ .uint64 none (.uint64 (word 1024)) ?_ (shift_source (zero s) lognCell)))
  exact (FftLocalCells140.outside _ _ _ _ (by decide)).trans
    (C99Declared147.member .uint64 ["v".toList] s.locals "v".toList (by decide))

theorem outside (s : State) (name : C99ArrayReference.Name) (notU : name≠"u".toList) (notV : name≠"v".toList) :
    (initial s).locals name=s.locals name :=
  (FftLocalCells140.outside _ _ name _ notV).trans
    ((FftLocalCells140.outside _ _ name _ notU).trans
      (C99DeclareOutside140.source .uint64 ["v".toList] s.locals name (by simpa only [List.mem_singleton] using notV)))

theorem u_cell (s : State) : C99LoopScalar141.Cell (initial s) "u".toList 0 :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _)
theorem v_cell (s : State) : C99LoopScalar141.Cell (initial s) "v".toList 1024 := FftLocalCells140.cell_at _ _ _

end FT1536.Source3.FftTriplingSetup148
