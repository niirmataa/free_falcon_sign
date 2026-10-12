import PairStores020B

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.VectorPrefix020C
open WordRAM020 PairStores020B PairArithmetic020B

abbrev Values := Nat → Int × Int
def total (v : Values) (k : Nat) : Int :=
  ∑ j ∈ Finset.range k, q2 (v j).1 (v j).2
def Bounded (v : Values) : Prop := ∀ j, j<1536 →
  (-65535≤(v j).1 ∧ (v j).1≤65535) ∧ (-65535≤(v j).2 ∧ (v j).2≤65535)

theorem total_zero (v : Values) : total v 0=0 := by simp [total]
theorem total_succ (v : Values) (k : Nat) :
    total v (k+1)=total v k+q2 (v k).1 (v k).2 := by
  exact Finset.sum_range_succ _ _

theorem total_bound (v : Values) (hv : Bounded v) (k : Nat) (hk : k≤1536) :
    0≤total v k ∧ total v k≤(k:Int)*(3*65535^2) := by
  induction k with
  | zero => simp [total_zero]
  | succ k ih =>
    have prev := ih (by omega)
    have hxy := hv k (by omega)
    have hq := q2_bounds _ _ hxy.1 hxy.2
    rw [total_succ]
    push_cast
    constructor <;> nlinarith

def Prefix (v : Values) (k : Nat) (s : State) : Prop :=
  ∀ p : Fin 1536, p.val<k →
    s.ram (slot0 p)=word (v p.val).1 ∧ s.ram (slot1 p)=word (v p.val).2

theorem prefix_zero (v : Values) (s : State) : Prefix v 0 s := by
  intro p hp
  omega

theorem slots_disjoint (p q : Fin 1536) (h : q≠p) :
    slot0 q≠slot0 p ∧ slot0 q≠slot1 p ∧ slot1 q≠slot0 p ∧ slot1 q≠slot1 p := by
  have hval : q.val≠p.val := fun he => h (Fin.ext he)
  refine ⟨?_,?_,?_,?_⟩ <;> intro he <;> have he' := congrArg Fin.val he
  · change 2*q.val=2*p.val at he'; omega
  · change 2*q.val=2*p.val+1 at he'; omega
  · change 2*q.val+1=2*p.val at he'; omega
  · change 2*q.val+1=2*p.val+1 at he'; omega

theorem prefix_step (v : Values) (p : Fin 1536) (s t : State)
    (old : Prefix v p.val s)
    (first : t.ram (slot0 p)=word (v p.val).1)
    (second : t.ram (slot1 p)=word (v p.val).2)
    (other : ∀ j : Fin ramSize, j≠slot0 p → j≠slot1 p → t.ram j=s.ram j) :
    Prefix v (p.val+1) t := by
  intro q hq
  by_cases hqp : q=p
  · subst q; exact ⟨first,second⟩
  · have hj : q.val<p.val := by have hn : q.val≠p.val := fun he => hqp (Fin.ext he); omega
    have prev := old q hj
    have dis := slots_disjoint p q hqp
    exact ⟨(other _ dis.1 dis.2.1).trans prev.1,
      (other _ dis.2.2.1 dis.2.2.2).trans prev.2⟩

theorem suffix_step (p : Fin 1536) (s t : State)
    (other : ∀ j : Fin ramSize, j≠slot0 p → j≠slot1 p → t.ram j=s.ram j) :
    ∀ j : Fin ramSize, 3072≤j.val → t.ram j=s.ram j := by
  intro j hj
  have hp := p.isLt
  apply other j
  · intro he; have he' := congrArg Fin.val he; change j.val=2*p.val at he'; omega
  · intro he; have he' := congrArg Fin.val he; change j.val=2*p.val+1 at he'; omega

/-- State unchanged by every pair iteration outside its owned register/bank area. -/
def Stable (s t : State) : Prop :=
  t.out=s.out ∧ t.fault=s.fault ∧
  (∀ rr : Reg, (rr.val=0 ∨ 17<rr.val) → rr≠30 → t.reg rr=s.reg rr) ∧
  (∀ j : Fin ramSize, 3072≤j.val → t.ram j=s.ram j)

theorem stable_refl (s : State) : Stable s s := ⟨rfl,rfl,fun _ _ _ => rfl,fun _ _ => rfl⟩
theorem stable_trans {s t u : State} (h : Stable s t) (h' : Stable t u) : Stable s u :=
  ⟨h'.1.trans h.1,h'.2.1.trans h.2.1,
    fun rr hr h30 => (h'.2.2.1 rr hr h30).trans (h.2.2.1 rr hr h30),
    fun j hj => (h'.2.2.2 j hj).trans (h.2.2.2 j hj)⟩

def Good (v : Values) (outer : Word) (k : Nat) (s : State) : Prop :=
  s.reg 0=outer ∧ s.reg 1=word (k:Int) ∧ s.reg 16=word (total v k) ∧ Prefix v k s

end FT1536.S05.VectorPrefix020C
