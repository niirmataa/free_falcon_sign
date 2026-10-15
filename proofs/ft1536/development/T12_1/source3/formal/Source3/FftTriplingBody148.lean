import Source3.FftTriplingInvariant148

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTriplingBody148
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open FftTripleBody147 (Constants Context)

/-- Expose a fresh reference endpoint, avoiding reduction of its symbolic heap. -/
theorem source (s : State) (base : ArrayPointer) (u q : Nat) (input : Fin 1536 → BitVec 64) (c : Constants)
    (context : Context s base 1536 768 u q c) (represented : Represents s.heap base input) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.loopBody s ⟨after,.normal⟩ ∧
      Represents after.heap base (FftTripleBody147.values 1536 768 u q context.write.inside context.write.length input c) ∧
      FftGroupFrame143.Frame base 1536 s after :=
  ⟨FftTripleBody147.output s base 1536 768 u q context.write.inside context.write.length input c,
    FftTripleBody147.source_and_image s base 1536 768 u q input c context represented⟩

end FT1536.Source3.FftTriplingBody148
