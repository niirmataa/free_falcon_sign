import Source3.KeygenBezoutCheck098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBezoutArity098
open KeygenZintCall
open KeygenZintDeterminism098 (checkedCode)

theorem part0 : checkedCode (bezoutPart 0) = true := by decide +kernel
theorem part1 : checkedCode (bezoutPart 1) = true := by decide +kernel
theorem part2 : checkedCode (bezoutPart 2) = true := by decide +kernel
theorem part3 : checkedCode (bezoutPart 3) = true := by decide +kernel
theorem part4 : checkedCode (bezoutPart 4) = true := by decide +kernel
theorem part5 : checkedCode (bezoutPart 5) = true := by decide +kernel
theorem part6 : checkedCode (bezoutPart 6) = true := by decide +kernel
theorem part7 : checkedCode (bezoutPart 7) = true := KeygenBezoutCheck098.source

theorem body : checkedCode (calleeBody .bezout) = true := by
  apply KeygenZintExtractArity098.chain_checked
  intro code member
  simp only [List.mem_cons, List.not_mem_nil, or_false] at member
  rcases member with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact part0
  · exact part1
  · exact part2
  · exact part3
  · exact part4
  · exact part5
  · exact part6
  · exact part7

end FT1536.Source3.KeygenBezoutArity098
