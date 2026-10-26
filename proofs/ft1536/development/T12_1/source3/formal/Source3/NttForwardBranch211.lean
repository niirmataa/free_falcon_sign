import Source3.NttForwardCall211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttForwardBranch211
open C99ArrayReference (State)
open KeygenModpR2Exec (Slot)
open KeygenMakeFgSource (Exec)

theorem source (s out : State) (ter : Slot s "ter" 1)
    (call : Exec MakeFgAddPrimeShape194.forwardCall s ⟨out,.normal⟩) :
    Exec MakeFgAddPrimeShape194.nttBranch s ⟨out,.normal⟩ := by
  have yes : Exec MakeFgAddPrimeShape194.nttYes s ⟨out,.normal⟩ :=
    MakeFgScope187.source _ s out (.seqNormal _ _ s out _ call (MakeFgDeclarations176.array_source .skip out out (.skip out)))
  exact .branchTrue _ _ _ s ⟨out,.normal⟩ (.uint32 1) (.variable _ _ _ ter) (by decide) yes

end FT1536.Source3.NttForwardBranch211
