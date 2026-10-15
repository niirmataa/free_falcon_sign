import Source3.GeneratedFftTwiddleCheck153Square
import Source3.GeneratedFftTwiddleCheck153Cubic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftCertifiedTwiddle153

def squareValue (i : Nat) : BitVec 64 × BitVec 64 :=
  if inside : i<384 then
    (GeneratedFftTwiddle153Square.word ⟨2*i,by omega⟩,GeneratedFftTwiddle153Square.word ⟨2*i+1,by omega⟩)
  else FftDirectTable153.pair .square i
def cubicValue (i : Nat) : BitVec 64 × BitVec 64 :=
  if inside : 512 ≤ i ∧ i<768 then
    (GeneratedFftTwiddle153Cubic.word ⟨2*(i-512),by omega⟩,GeneratedFftTwiddle153Cubic.word ⟨2*(i-512)+1,by omega⟩)
  else FftDirectTable153.pair .cubic i
def pair : FftTableParser.Table → Nat → BitVec 64 × BitVec 64
  | .square => squareValue
  | .cubic => cubicValue

theorem square_direct (i : Nat) : squareValue i=FftDirectTable153.pair .square i := by
  by_cases inside : i<384
  · rw [squareValue,dite_eq_left inside]
    have real := congrFun GeneratedFftTwiddleCheck153Square.source ⟨2*i,by omega⟩
    have imag := congrFun GeneratedFftTwiddleCheck153Square.source ⟨2*i+1,by omega⟩
    change FftTwiddleFlat153.word .square 0 (2*i)=_ at real
    change FftTwiddleFlat153.word .square 0 (2*i+1)=_ at imag
    rw [FftTwiddleFlat153.even,Nat.zero_add] at real
    rw [FftTwiddleFlat153.odd,Nat.zero_add] at imag
    exact Prod.ext real.symm imag.symm
  · rw [squareValue,dite_eq_right inside]

theorem cubic_direct (i : Nat) : cubicValue i=FftDirectTable153.pair .cubic i := by
  by_cases inside : 512 ≤ i ∧ i<768
  · rw [cubicValue,dite_eq_left inside]
    have real := congrFun GeneratedFftTwiddleCheck153Cubic.source ⟨2*(i-512),by omega⟩
    have imag := congrFun GeneratedFftTwiddleCheck153Cubic.source ⟨2*(i-512)+1,by omega⟩
    change FftTwiddleFlat153.word .cubic 512 (2*(i-512))=_ at real
    change FftTwiddleFlat153.word .cubic 512 (2*(i-512)+1)=_ at imag
    have index : 512+(i-512)=i := by omega
    rw [FftTwiddleFlat153.even,index] at real
    rw [FftTwiddleFlat153.odd,index] at imag
    exact Prod.ext real.symm imag.symm
  · rw [cubicValue,dite_eq_right inside]

theorem square (i : Nat) : pair .square i=FftGroupTwiddle143.pair i := (square_direct i).trans (FftDirectTable153.square i)
theorem cubic (i : Nat) : pair .cubic i=FftCubicWord147.pair i := (cubic_direct i).trans (FftDirectTable153.cubic i)

end FT1536.Source3.FftCertifiedTwiddle153
