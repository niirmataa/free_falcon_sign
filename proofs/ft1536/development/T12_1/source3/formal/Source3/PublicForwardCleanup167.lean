import Source3.PublicForwardDomains167

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicForwardCleanup167
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open PublicForwardEntry159 (entryT)
open PublicForwardBody159 (bodyState tailState)
open KeygenRngSource (Fresh disposed)

theorem fresh_g (s : State) (a : ArrayPointer) (g i : Nat) (last : State)
    (fresh : Fresh s.heap g) : Fresh (bodyState (entryT s a) g i last).heap g := by
  change Fresh (disposed s.heap (tailState (entryT s a) g i last).heap g) g
  simpa only [Fresh,disposed,ite_true] using fresh

theorem fresh_i (s : State) (a : ArrayPointer) (g i : Nat) (last : State)
    (fresh : Fresh (KeygenPublicExec.allocated s.heap g 2048) i) :
    Fresh (bodyState (entryT s a) g i last).heap i := by
  have different := (PublicForwardMemory167.distinct_tables s.heap g i fresh).symm
  change Fresh (disposed s.heap (disposed (KeygenPublicExec.allocated s.heap g 2048) last.heap i) g) i
  simpa only [Fresh,disposed,different,ite_false,ite_true] using fresh

end FT1536.Source3.PublicForwardCleanup167
