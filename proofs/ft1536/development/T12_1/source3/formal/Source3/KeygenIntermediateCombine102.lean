import Source3.KeygenIntermediateDeterminism102

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenIntermediateCombine102
open KeygenIntermediateExec (Stmt chain)
open KeygenIntermediateDeterminism102 (checkedCode chain_checked)

theorem six (c0 c1 c2 c3 c4 c5 : Stmt)
    (h0 : checkedCode c0 = true)
    (h1 : checkedCode c1 = true)
    (h2 : checkedCode c2 = true)
    (h3 : checkedCode c3 = true)
    (h4 : checkedCode c4 = true)
    (h5 : checkedCode c5 = true)
    : checkedCode (chain [c0, c1, c2, c3, c4, c5]) = true := by
  apply chain_checked
  intro c member
  simp only [List.mem_cons, List.not_mem_nil, or_false] at member
  rcases member with rfl | rfl | rfl | rfl | rfl | rfl
  · exact h0
  · exact h1
  · exact h2
  · exact h3
  · exact h4
  · exact h5

theorem ten (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 : Stmt)
    (h0 : checkedCode c0 = true)
    (h1 : checkedCode c1 = true)
    (h2 : checkedCode c2 = true)
    (h3 : checkedCode c3 = true)
    (h4 : checkedCode c4 = true)
    (h5 : checkedCode c5 = true)
    (h6 : checkedCode c6 = true)
    (h7 : checkedCode c7 = true)
    (h8 : checkedCode c8 = true)
    (h9 : checkedCode c9 = true)
    : checkedCode (chain [c0, c1, c2, c3, c4, c5, c6, c7, c8, c9]) = true := by
  apply chain_checked
  intro c member
  simp only [List.mem_cons, List.not_mem_nil, or_false] at member
  rcases member with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact h0
  · exact h1
  · exact h2
  · exact h3
  · exact h4
  · exact h5
  · exact h6
  · exact h7
  · exact h8
  · exact h9

theorem lift_shell (body : Stmt) (checked : checkedCode body = true) :
    checkedCode (.seq KeygenIntermediateLiftData.initial
      (.loop KeygenIntermediateLiftData.condition
        (.scope KeygenIntermediateLiftData.locals KeygenIntermediateLiftData.pointers body)
        KeygenIntermediateLiftData.increment)) = true := by
  change (true && ((true && checkedCode body) && true)) = true
  rw [checked]
  rfl

theorem reduce_shell (body : Stmt) (checked : checkedCode body = true) :
    checkedCode (.seq .skip (.loop KeygenIntermediateReduceData.condition
      (.scope KeygenIntermediateReduceData.locals [] body) .skip)) = true := by
  change (true && ((true && checkedCode body) && true)) = true
  rw [checked]
  rfl

end FT1536.Source3.KeygenIntermediateCombine102
