import Source3.ShakeProcessEvents128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeProcessProposal128
open C99CompactState115 (State)
open C99MemoryReference (ArrayPointer)

/-- Untrusted candidate transition. Matching its input never establishes
    correctness of its output; every logged call still needs Valid. -/
structure Transition where
  before : List (BitVec 64)
  after : List (BitVec 64)

def candidateMatches (state : State) (pointer : ArrayPointer) (candidate : Transition) : Bool :=
  (candidate.before.length==25) && (candidate.after.length==25) &&
    (List.range 25).all (fun i => C99FiniteRead114.read64 state.heap (KeygenSmallOutput.element pointer i)==candidate.before[i]?)

def propose (candidates : List Transition) (state : State) (pointer : ArrayPointer) : Option (List (BitVec 64)) :=
  (candidates.find? (candidateMatches state pointer)).map Transition.after

end FT1536.Source3.ShakeProcessProposal128
