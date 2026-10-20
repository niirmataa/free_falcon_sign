import Source3.StableBinary

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryAudit
open FT1536.Source3.StableBinary

/- Change just the second recursive pointer; the pinned parser rejects it. -/
def wrongRight : List String := StableBinaryPin.lines.set 22
  "\tft_stable_binary_inplace_keygen(values, hn, scratch, bad);\n"

theorem rejects_wrong_right :
    parse (wrongRight.flatMap String.toList)=none := by decide

/- Change the *source* RMW `|=` into a reset. The already-proved parser of
   the callee cannot turn that mutant into its accepted CRefWord.Function. -/
def resetBad : List String :=
  ((Pinned.keygenLines.drop 7477).take 12).set 6 "\t*bad = 0;\n"

theorem rejects_bad_reset :
    CRefWord.parse (resetBad.flatMap String.toList)≠
      some StablePositive.program := by decide

/- Even when all subsequent words pass, a pre-existing set flag cannot be
   cleared. This uses the actual source-refined stable-positive update. -/
theorem detects_erased_bad (l : Layout) (m : Memory) (s : State l m)
    (h : s.firstBad=1#32) : s.memory.flags l.bad≠some 0#32 := by
  intro hc
  have hb : s.bad=0#32 := Option.some.inj (by
    simpa only [State.memory,CRefWord.store_read] using hc)
  exact (never_clears_bad s (by rw [h]; decide)) hb

theorem correct_right_not_left :
    addr 0 (program.rightStride*1)≠addr 0 program.leftOffset := by decide

end FT1536.Source3.StableBinaryAudit

#print axioms FT1536.Source3.StableBinaryAudit.rejects_wrong_right
#print axioms FT1536.Source3.StableBinaryAudit.rejects_bad_reset
#print axioms FT1536.Source3.StableBinaryAudit.detects_erased_bad
