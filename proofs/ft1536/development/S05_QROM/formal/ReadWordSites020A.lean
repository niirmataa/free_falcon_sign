import ReadWordCorrect020A

set_option exponentiation.threshold 512
namespace FT1536.S05.ReadWordSites020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A ReadWordCorrect020A

/-- The base register of every actual020 readWord call. -/
theorem register_base (i : Input) (s : State) (dst : Reg) (b n : Nat)
    (hn : n≤384) (haddr : b+n≤tapeSize) (hb : s.reg 3=word b) :
    let t := exec i (readWord dst (r 3) n) s
    t.reg dst=word (value (tapeBits i) n b) ∧ Frame s t ∧
      ∀ k : Reg, k≠4 → k≠5 → k≠6 → k≠dst → t.reg k=s.reg k := by
  apply readWord_correct i s dst (r 3) b n hn haddr
  · simp [reads,r]
  · simp [reads,r]
  · simp [reads,r]
  · exact hb

/-- Offsets0/10/384/768 used in020 are covered, with no caller assumption
    that the base expression remains unchanged: it follows from its syntax. -/
theorem offset_base (i : Input) (s : State) (dst : Reg) (b off n : Nat)
    (hn : n≤384) (haddr : b+off+n≤tapeSize) (hb : s.reg 3=word b) :
    let t := exec i (readWord dst (add (r 3) (lit off)) n) s
    t.reg dst=word (value (tapeBits i) n (b+off)) ∧ Frame s t ∧
      ∀ k : Reg, k≠4 → k≠5 → k≠6 → k≠dst → t.reg k=s.reg k := by
  apply readWord_correct i s dst (add (r 3) (lit off)) (b+off) n hn haddr
  · simp [reads,add,r,lit]
  · simp [reads,add,r,lit]
  · simp [reads,add,r,lit]
  · change op .add (s.reg 3) (word off)=word ((b+off : Nat) : Int)
    rw [hb]
    exact add_word _ _ (tiny_fits (by simp only [tapeSize] at haddr; omega))
      (tiny_fits (by simp only [tapeSize] at haddr; omega))

/-- Reading the resulting word as a signed machine integer is still exact. -/
theorem unsigned_result (i : Input) (s : State) (dst : Reg) (base : Expr) (b n : Nat)
    (hn : n≤384) (ha : b+n≤tapeSize)
    (hb4 : (4 : Reg) ∉ reads base) (hb5 : (5 : Reg) ∉ reads base) (hb6 : (6 : Reg) ∉ reads base)
    (hb : eval s base=word b) :
    ((exec i (readWord dst base n) s).reg dst).toInt=value (tapeBits i) n b := by
  rw [(readWord_correct i s dst base b n hn ha hb4 hb5 hb6 hb).1]
  apply decode_word
  apply nat_fits
  exact lt_of_lt_of_le (value_lt (tapeBits i) n b)
    (Nat.pow_le_pow_right (by decide) (by omega))

end FT1536.S05.ReadWordSites020A
