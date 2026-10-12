import Interleaved020D
import Run2.PolynomialReference

namespace FT1536.S05.IndexReference020D
open Interleaved020D FT1536.Run2.PolynomialReference

def term (j : Fin 1536) : TermIndex := (pairIndex j,if j.val%2=0 then false else true)
def index (p : TermIndex) : Fin 1536 :=
  ⟨2*p.1.val+(if p.2 then 1 else 0),by have := p.1.isLt;split <;> omega⟩

theorem term_even (j : Fin 768) : term ⟨2*j.val,by have := j.isLt;omega⟩=(j,false) := by
  apply Prod.ext
  · apply Fin.ext;change (2*j.val)/2=j.val;omega
  · change (if (2*j.val)%2=0 then false else true)=false
    rw [ite_eq_left (by omega)]

theorem term_odd (j : Fin 768) : term ⟨2*j.val+1,by have := j.isLt;omega⟩=(j,true) := by
  apply Prod.ext
  · apply Fin.ext;change (2*j.val+1)/2=j.val;omega
  · change (if (2*j.val+1)%2=0 then false else true)=true
    rw [ite_eq_right (by omega)]

theorem index_term (j : Fin 1536) : index (term j)=j := by
  apply Fin.ext
  change 2*(j.val/2)+(if (if j.val%2=0 then false else true) then 1 else 0)=j.val
  rcases parity j.val with he|he
  · simp only [he,ite_true,Bool.false_eq_true,ite_false];omega
  · simp only [he,one_ne_zero,ite_false,ite_true];omega

theorem term_index (p : TermIndex) : term (index p)=p := by
  rcases p with ⟨j,b⟩
  cases b
  · exact term_even j
  · exact term_odd j

def termEquiv : Fin 1536 ≃ TermIndex := ⟨term,index,index_term,term_index⟩

theorem exponent_eq (j : Fin 1536) : exponent (term j)=exponentN j.val := by
  unfold exponent term pairIndex exponentN
  rcases parity j.val with he|he <;> simp [he]

theorem coefficient_eq (a : FT1536.Relation.Rq) (j : Fin 1536) :
    coefficient a (term j)=if j.val%2=0 then (a (pairIndex j)).1 else (a (pairIndex j)).2 := by
  unfold coefficient term
  split <;> rfl

theorem sum_term {A : Type} [AddCommMonoid A] (f : TermIndex → A) :
    (∑ j : Fin 1536,f (term j))=∑ p : TermIndex,f p :=
  Fintype.sum_equiv termEquiv _ _ (fun _ => rfl)

end FT1536.S05.IndexReference020D
