import Source3.StepPrimeShape188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepPrimeDeclarations188
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open MakeFgDeclarations176 (array_source)

def withWords (s : State) := C99DeclarationStatements.effect .u32 ["p".toList,"p0i".toList,"R2".toList] s
def withV (s : State) := C99DeclarationStatements.effect .u64 ["v".toList] (withWords s)
def after (s : State) := DeepestDeclarations175.clear (withV s) "x".toList

theorem source (s : State) : MakeFgSequence187.Run StepPrimeShape188.declarations s (after s) := by
  have words : Exec (MakeFgDeclarations176.arrayCode (.scalar (.declare .u32 ["p".toList,"p0i".toList,"R2".toList]))) s ⟨withWords s,.normal⟩ :=
    array_source _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 ["p".toList,"p0i".toList,"R2".toList] s)
  have v : Exec (MakeFgDeclarations176.arrayCode (.scalar (.declare .u64 ["v".toList]))) (withWords s) ⟨withV s,.normal⟩ :=
    array_source _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 ["v".toList] (withWords s))
  have ptr : Exec (KeygenMakeFgSource.modular (DeepestDeclarations175.pointerCode ["x".toList] (.base .skip))) (withV s) ⟨after s,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (DeepestDeclarations175.pointer_source ["x".toList] (withV s) (.base .skip)
      ⟨after s,.normal⟩ (.base .skip _ _ (.skip _))))
  exact .cons _ _ _ _ _ words (.cons _ _ _ _ _ v (.cons _ _ _ _ _ ptr (.nil (after s))))

end FT1536.Source3.StepPrimeDeclarations188
