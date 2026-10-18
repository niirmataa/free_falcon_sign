import Source3.ModularAtoms178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorDeclarations178
open C99ArrayReference (State)
open C99ModularReference (ModCall)
open KeygenMkgm3Program (declarations)

def withU (s : State) := C99DeclarationStatements.effect .u64 ["u".toList] s
def withK (s : State) := C99DeclarationStatements.effect .u32 ["k".toList] (withU s)
def after (s : State) := C99DeclarationStatements.effect .u32 (["R","R2","w","ig"].map String.toList) (withK s)

theorem source (s : State) : ModularSequence178.Run ModCall declarations s (after s) :=
  .cons _ _ s (withU s) (after s)
    (.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 ["u".toList] s))
    (.cons _ _ (withU s) (withK s) (after s)
      (.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 ["k".toList] (withU s)))
      (.cons _ _ (withK s) (after s) (after s)
        (.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32
          (["R","R2","w","ig"].map String.toList) (withK s))) (.nil (after s))))

end FT1536.Source3.GeneratorDeclarations178
