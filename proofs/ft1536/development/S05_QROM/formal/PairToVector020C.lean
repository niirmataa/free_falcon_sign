import PairCompose020B
import VectorPrefix020C

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PairToVector020C
open WordRAM020 PairCompose020B VectorPrefix020C

/-- Logical step: a full pair postcondition extends the RAM prefix and the
    EXACT accumulated sum, and yields a transitive frame for the outer loop. -/
theorem extend (v : Values) (outer : Word) (p : Fin 1536) (s t : State)
    (good : Good v outer p.val s)
    (post : PairPost s t p (total v p.val) (v p.val).1 (v p.val).2) :
    Good v outer (p.val+1) t ∧ Stable s t := by
  refine ⟨⟨?_,post.2.2.2.2.1,?_,?_⟩,?_,post.2.2.2.2.2.2.1,
    post.2.2.2.2.2.2.2,suffix_step p s t post.2.2.1⟩
  · exact (post.2.2.2.2.2.2.2 0 (by decide) (by decide)).trans good.1
  · rw [total_succ]
    exact post.2.2.2.1
  · exact prefix_step v p s t good.2.2.2 post.1 post.2.1 post.2.2.1
  · exact post.2.2.2.2.2.1

end FT1536.S05.PairToVector020C
