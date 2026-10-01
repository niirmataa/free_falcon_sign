import Source3.C99Automatic32

namespace FT1536.Source3.C99AutomaticReadback
open C99MemoryReference

theorem load64_after_leave (caller edge : Memory) (p : ArrayPointer) (w : BitVec 64)
    (live : Allocated caller p) (read : Load64 edge p w) : Load64 (C99Automatic32.leave caller edge) p w := by
  cases read with
  | load bytes allocated typeSize initialized =>
      refine Load64.load _ p bytes (by simpa only [Allocated,C99Automatic32.leave] using live) typeSize ?_
      intro i
      have bound : p.offset+i.val<caller.size p.block := by
        have hi := i.isLt
        have hp := live.2.2.1
        have hs := live.2.2.2.1
        rw [typeSize] at hs
        dsimp [ArrayPointer.offset]
        rw [typeSize]
        omega
      exact (C99Automatic32.leave_preserves_caller caller edge p.block (p.offset+i.val) bound).trans (initialized i)

end FT1536.Source3.C99AutomaticReadback
