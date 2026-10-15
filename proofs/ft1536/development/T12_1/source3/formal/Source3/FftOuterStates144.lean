import Source3.FftOuterShape144
import Source3.C99OuterScalar144
import Source3.C99DeclareOutside140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftOuterStates144
open C99ArrayReference (State Name)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open FftLocalCells140 (put)
open FftOuterShape144 (names)

def declared (s : State) := C99DeclarationStatements.effect .u64 names s
def halfT (s : State) (t : Nat) := put (declared s) "ht".toList (word (t/2))
def halfM (s : State) (t m : Nat) := put (halfT s t) "hm".toList (word (m/2))
def zeroU (s : State) (t m : Nat) := put (halfM s t m) "u1".toList (word 0)
def initial (s : State) (t m : Nat) := put (zeroU s t m) "v1".toList (word 0)

theorem declared_outside (s : State) (name : Name) (outside : name∉names) :
    (declared s).locals name=s.locals name := C99DeclareOutside140.source .uint64 names s.locals name outside

theorem initial_outside (s : State) (t m : Nat) (name : Name) (outside : name∉names) :
    (initial s t m).locals name=s.locals name := by
  have notHt : name≠"ht".toList := by intro same; subst name; exact outside (by decide)
  have notHm : name≠"hm".toList := by intro same; subst name; exact outside (by decide)
  have notU : name≠"u1".toList := by intro same; subst name; exact outside (by decide)
  have notV : name≠"v1".toList := by intro same; subst name; exact outside (by decide)
  exact (FftLocalCells140.outside _ _ _ _ notV).trans
    ((FftLocalCells140.outside _ _ _ _ notU).trans
      ((FftLocalCells140.outside _ _ _ _ notHm).trans
        ((FftLocalCells140.outside _ _ _ _ notHt).trans (declared_outside s name outside))))

theorem cell (s : State) (t m : Nat) (name : Name) (value : Nat) (outside : name∉names)
    (old : Cell s name value) : Cell (initial s t m) name value := (initial_outside s t m name outside).trans old

theorem ht (s : State) (t m : Nat) : Cell (initial s t m) "ht".toList (t/2) :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _)))

theorem hm (s : State) (t m : Nat) : Cell (initial s t m) "hm".toList (m/2) :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _))

theorem u1 (s : State) (t m : Nat) : Cell (initial s t m) "u1".toList 0 :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _)

theorem v1 (s : State) (t m : Nat) : Cell (initial s t m) "v1".toList 0 := FftLocalCells140.cell_at _ _ _

theorem ht_declared (s : State) : (declared s).locals "ht".toList=some (.uint64,none) := by
  simp [declared,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftOuterShape144.names,C99ScalarReference.set,C99ValueBridge.type]

theorem hm_declared (s : State) : (declared s).locals "hm".toList=some (.uint64,none) := by
  simp [declared,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftOuterShape144.names,C99ScalarReference.set,C99ValueBridge.type]

theorem u_declared (s : State) : (declared s).locals "u1".toList=some (.uint64,none) := by
  simp [declared,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftOuterShape144.names,C99ScalarReference.set,C99ValueBridge.type]

theorem v_declared (s : State) : (declared s).locals "v1".toList=some (.uint64,none) := by
  simp [declared,C99DeclarationStatements.effect,C99DeclarationCells.declareCells,FftOuterShape144.names,C99ScalarReference.set,C99ValueBridge.type]

end FT1536.Source3.FftOuterStates144
