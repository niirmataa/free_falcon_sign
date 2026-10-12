import PairArithmetic020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.Interleaved020D
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020 PairArithmetic020B

def exponentN (j : Nat) : Nat := j/2+(j%2)*768
def pairIndex (j : Fin 1536) : Fin 768 := ⟨j.val/2,by have := j.isLt;omega⟩

theorem parity (j : Nat) : j%2=0 ∨ j%2=1 := by omega
theorem rebuild (j : Nat) : 2*(j/2)+j%2=j := by omega
theorem exponent_bound (j : Nat) (hj : j<1536) : exponentN j<1536 := by
  unfold exponentN
  have he := parity j
  rcases he with he|he <;> rw [he] <;> omega

theorem exponent_even (j : Fin 768) : exponentN (2*j.val)=j.val := by
  simp [exponentN]
theorem exponent_odd (j : Fin 768) : exponentN (2*j.val+1)=j.val+768 := by
  have hd : (2*j.val+1)/2=j.val := by omega
  have hm : (2*j.val+1)%2=1 := by omega
  simp only [exponentN,hd,hm,one_mul]

theorem exponent_eval (s : State) (rr : Reg) (j : Nat) (hj : j<1536)
    (hr : s.reg rr=word (j:Int)) :
    eval s (PairProgram020.exponent rr)=word (exponentN j:Int) := by
  have fj : Fits (j:Int) := bounded_fits _ (by omega) (by omega)
  have f2 : Fits 2 := bounded_fits _ (by norm_num) (by norm_num)
  have f768 : Fits 768 := bounded_fits _ (by norm_num) (by norm_num)
  have fd : Fits ((j:Int)/2) := bounded_fits _ (by omega) (by omega)
  have fm : Fits ((j:Int)%2) := bounded_fits _ (by omega) (by omega)
  have fp : Fits (((j:Int)%2)*768) := bounded_fits _ (by omega) (by omega)
  change op .add (op .div (s.reg rr) (word 2)) (op .mul (op .mod (s.reg rr) (word 2)) (word 768))=_
  rw [hr,div_word _ _ fj f2,mod_word _ _ fj f2,mul_word _ _ fm f768,add_word _ _ fd fp]
  apply congrArg word
  simp only [exponentN,Nat.cast_add,Nat.cast_mul,Int.natCast_ediv,Int.natCast_emod,Nat.cast_ofNat]

end FT1536.S05.Interleaved020D
