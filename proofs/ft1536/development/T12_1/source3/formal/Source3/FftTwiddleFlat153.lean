import Source3.FftDirectTable153
import Source3.FiniteWordVector153

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTwiddleFlat153

def word (table : FftTableParser.Table) (start i : Nat) : BitVec 64 :=
  if i%2=0 then (FftDirectTable153.pair table (start+i/2)).1 else (FftDirectTable153.pair table (start+i/2)).2
def square (i : Fin 768) : BitVec 64 := word .square 0 i.val
def cubic (i : Fin 512) : BitVec 64 := word .cubic 512 i.val

theorem even (table : FftTableParser.Table) (start i : Nat) : word table start (2*i)=(FftDirectTable153.pair table (start+i)).1 := by
  have parity : (2*i)%2=0 := by omega
  have quotient : (2*i)/2=i := by omega
  simp only [word,parity,ite_true,quotient]

theorem odd (table : FftTableParser.Table) (start i : Nat) : word table start (2*i+1)=(FftDirectTable153.pair table (start+i)).2 := by
  have parity : ¬(2*i+1)%2=0 := by omega
  have quotient : (2*i+1)/2=i := by omega
  simp only [word,ite_eq_right parity,quotient]

end FT1536.Source3.FftTwiddleFlat153
