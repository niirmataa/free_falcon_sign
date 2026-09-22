import H6PMoment
namespace H6P
def Safe16 (a b : Fin 1536→Int) := ∀i,(-32768≤a i ∧ a i≤32767) ∧ (-32768≤b i ∧ b i≤32767)
def BadPrecast (a b : Fin 1536→Int) := ¬Safe16 a b
theorem joint_bad_has_coefficient (a b : Fin 1536→Int) (h : BadPrecast a b) :
    ∃i,a i≤ -32769 ∨ 32768≤a i ∨ b i≤ -32769 ∨ 32768≤b i := by
  classical
  apply Classical.byContradiction
  intro hn
  apply h
  intro i
  have hi : ¬(a i≤ -32769 ∨ 32768≤a i ∨ b i≤ -32769 ∨ 32768≤b i) := fun hh=>hn ⟨i,hh⟩
  constructor <;> constructor <;> omega
theorem second_vector_matters : BadPrecast (fun _=>0) (fun _=>32768) := by
  intro h
  have hh:=(h ⟨0,by decide⟩).2.2
  change (32768:Int)≤32767 at hh
  omega
theorem negative_safe_tie (w : Int) (h : -1≤2*w+65537 ∧ 2*w+65537≤1) (he : w%2=0) : w= -32768 := by omega
theorem positive_bad_tie (w : Int) (h : -1≤2*w-65535 ∧ 2*w-65535≤1) (he : w%2=0) : w=32768 := by omega
theorem bad_rint_argument (x w scale : Int) (hs : 0<scale)
    (hr : -scale≤2*(scale*w)-2*x ∧ 2*(scale*w)-2*x≤scale)
    (hb : w≤ -32769 ∨ 32768≤w) : 2*x≤ -65537*scale ∨ 65535*scale≤2*x := by
  rcases hb with h|h
  · have hm:=Int.mul_le_mul_of_nonneg_left h (Int.le_of_lt hs)
    have he : scale*(-32769)= -32769*scale := Int.mul_comm _ _
    rw [he] at hm;omega
  · have hm:=Int.mul_le_mul_of_nonneg_left h (Int.le_of_lt hs)
    have he : scale*32768=32768*scale := Int.mul_comm _ _
    rw [he] at hm;omega
theorem error_to_symmetric_tail (actual linear err E threshold : Int)
    (hm : actual=linear+err) (he : -E≤err ∧ err≤E)
    (hb : threshold≤actual ∨ actual≤ -threshold) : threshold-E≤linear ∨ linear≤ -(threshold-E) := by omega
inductive RootResult (A : Type) | live : A→RootResult A | exit : RootResult A
def badEvent {A : Type} (f : A→(Fin 1536→Int)×(Fin 1536→Int)) : RootResult A→Prop
  | .live y=>BadPrecast (f y).1 (f y).2
  | .exit=>False
theorem exit_not_bad {A : Type} (f : A→(Fin 1536→Int)×(Fin 1536→Int)) : ¬badEvent f .exit := by simp [badEvent]
end H6P
