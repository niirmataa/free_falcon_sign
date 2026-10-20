import Source3.Gate00Memory
import Source3.C99InitializationTrace

namespace FT1536.Source3.Gate00Initialization
open C99MemoryReference C99InitializationTrace CertificateMemory

theorem step_memory_steps (l : Layout) (i : Nat) (before after : Memory) (w : BitVec 64)
    (source : Gate00Memory.Step l i before after w) : Steps before after := by
  cases source with
  | step middle after w z old flag guard positiveRead compareRead badRead scalar badWrite bitsRead rootWrite =>
      exact .write32 before middle after (badPtr l) flag badWrite
        (.write64 middle after after (Gate00Memory.rootPtr l i) z rootWrite (.done after))

theorem loop_memory_steps (l : Layout) (i : Nat) (before after : Memory) (trace : List (BitVec 64))
    (source : Gate00Memory.Loop l i before after trace) : Steps before after := by
  induction source with
  | done => exact .done _
  | next i before middle after w tail guard step rest ih =>
      exact steps_trans before middle after (step_memory_steps l i before middle w step) ih

end FT1536.Source3.Gate00Initialization
