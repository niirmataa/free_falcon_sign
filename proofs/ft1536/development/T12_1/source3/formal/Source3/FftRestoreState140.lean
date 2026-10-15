import Source3.C99RestoreCells140
import Source3.FftLocalCells140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftRestoreState140
open C99ArrayReference (State Name restoreScope)
open FftLocalCells140 (put)

theorem inside (before after : State) (names : List Name) (name : Name) (word : BitVec 64)
    (member : name∈names) :
    restoreScope before (put after name word) names []=restoreScope before after names [] := by
  unfold restoreScope put
  rw [C99RestoreCells140.inside before.locals after.locals names name _ member]

theorem outside (before after : State) (names : List Name) (name : Name) (word : BitVec 64)
    (absent : name∉names) :
    restoreScope before (put after name word) names []=put (restoreScope before after names []) name word := by
  unfold restoreScope put
  rw [C99RestoreCells140.outside before.locals after.locals names name _ absent]

theorem declarations (before after : State) (scope names : List Name) (ty : B20.C.Ty)
    (subset : ∀ name∈names, name∈scope) :
    restoreScope before (C99DeclarationStatements.effect ty names after) scope []=
      restoreScope before after scope [] := by
  unfold restoreScope C99DeclarationStatements.effect
  rw [C99RestoreCells140.declarations before.locals after.locals scope names _ subset]

theorem self (before : State) (names : List Name) : restoreScope before before names []=before := by
  unfold restoreScope
  rw [C99RestoreCells140.self]
  rfl

end FT1536.Source3.FftRestoreState140
