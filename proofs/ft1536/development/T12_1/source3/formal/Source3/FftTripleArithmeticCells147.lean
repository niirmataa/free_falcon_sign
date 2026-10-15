import Source3.C99ScopeFrame147
import Source3.C99Declared147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleArithmeticCells147
open C99ArrayReference (State Name)
open FftLocalCells140 (put)

def two (s : State) (dr di : Name) (real imag : BitVec 64) := put (put s dr real) di imag

theorem heap (s : State) (dr di : Name) (real imag : BitVec 64) : (two s dr di real imag).heap=s.heap := rfl

theorem real_cell (s : State) (dr di : Name) (real imag : BitVec 64) (different : dr≠di) :
    (two s dr di real imag).locals dr=some (.uint64,some (.uint64 real)) :=
  (FftLocalCells140.outside (put s dr real) di dr imag different).trans (FftLocalCells140.cell_at s dr real)

theorem imag_cell (s : State) (dr di : Name) (real imag : BitVec 64) :
    (two s dr di real imag).locals di=some (.uint64,some (.uint64 imag)) := FftLocalCells140.cell_at (put s dr real) di imag

theorem outside (s : State) (dr di : Name) (real imag : BitVec 64) (key : Name) (notReal : key≠dr) (notImag : key≠di) :
    (two s dr di real imag).locals key=s.locals key :=
  (FftLocalCells140.outside (put s dr real) di key imag notImag).trans (FftLocalCells140.outside s dr key real notReal)

theorem declared (s : State) (names : List Name) (dr di : Name) (real imag : BitVec 64)
    (old : C99Declared147.Declared s names) : C99Declared147.Declared (two s dr di real imag) names :=
  C99Declared147.put _ names di imag (C99Declared147.put s names dr real old)

theorem frame (s : State) (names : List Name) (dr di : Name) (real imag : BitVec 64)
    (realMember : dr∈names) (imagMember : di∈names) : C99ScopeFrame147.Frame names s (two s dr di real imag) :=
  C99ScopeFrame147.trans names s (put s dr real) _ (C99ScopeFrame147.put names s dr real realMember)
    (C99ScopeFrame147.put names (put s dr real) di imag imagMember)

end FT1536.Source3.FftTripleArithmeticCells147
