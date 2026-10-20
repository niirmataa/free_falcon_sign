import Source3.C99HelperControl

/- Permitted C99 evaluation orders at the effectful sites. Address
   expressions depend exclusively on by-value pointer/index locals, never
   on caller bytes. Thus computing an lvalue after the rhs cannot observe
   the rhs's bad update. Full expressions remain sequenced in source order.
   Scalar argument expressions are already handled in C99ScalarReference;
   only the pointer argument and assignment operands require this lifting. -/
namespace FT1536.Source3.C99HelperOrders
open C99MemoryReference C99HelperReference C99HelperObjects

inductive Order where | leftFirst | rightFirst

inductive Assignment (rhs : State → Word → State → Prop) (base : ArrayPointer) (index : Nat) :
    Order → State → State → Prop where
  | left (s mid out : State) (p : ArrayPointer) (w : Word)
      (address : PointerAdd base index p) (value : rhs s w mid) (write : Store p mid w out) :
      Assignment rhs base index .leftFirst s out
  | right (s mid out : State) (p : ArrayPointer) (w : Word)
      (value : rhs s w mid) (address : PointerAdd base index p) (write : Store p mid w out) :
      Assignment rhs base index .rightFirst s out

theorem assignment_normalizes (rhs : State → Word → State → Prop) (base : ArrayPointer) (index : Nat)
    (order : Order) (s out : State) : Assignment rhs base index order s out ↔
      ∃ p mid w, PointerAdd base index p ∧ rhs s w mid ∧ Store p mid w out := by
  constructor
  · intro h; cases h <;> exact ⟨_,_,_,by assumption,by assumption,by assumption⟩
  · rintro ⟨p,mid,w,hp,hr,hw⟩
    cases order
    · exact Assignment.left s mid out p w hp hr hw
    · exact Assignment.right s mid out p w hr hp hw

theorem all_assignment_orders (rhs : State → Word → State → Prop) (base : ArrayPointer) (i : Nat)
    (a b : Order) (s out : State) : Assignment rhs base i a s out ↔ Assignment rhs base i b s out := by
  rw [assignment_normalizes,assignment_normalizes]

theorem pointer_result (base p : ArrayPointer) (i : Nat) (h : PointerAdd base i p) :
    p={base with index := base.index+i} := by cases h; rfl

def halfRhs (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (sum : Word)
    (s : State) (w : Word) (mid : State) : Prop :=
  ∃ raw, Unary code.firstStore.half sum raw ∧ Positive l s raw w mid

theorem half_assignment_orders (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code)
    (u : Nat) (sum : Word) (order : Order) (s out : State) :
    Assignment (halfRhs l code sum) (scratch l 0) u order s out ↔ HalfStore l code u sum s out := by
  rw [assignment_normalizes]
  constructor
  · rintro ⟨p,mid,w,hp,⟨raw,hh,hc⟩,hw⟩
    have heq : p=scratch l u := by simpa [scratch] using pointer_result _ _ _ hp
    subst p
    exact HalfStore.step s mid out raw w hh hc hw
  · intro h
    cases h with
    | step mid _ raw w hh hc hw =>
        have hu : u<l.length := hw.1.1.2.2.1
        exact ⟨scratch l u,mid,w,scratch_add l u (by omega),⟨raw,hh,hc⟩,hw⟩

def suffixRhs (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code) (product sum : Word)
    (s : State) (w : Word) (mid : State) : Prop :=
  ∃ twice raw, Unary code.secondStore.double product twice ∧ Binary code.secondStore.div twice sum raw ∧
    Positive l s raw w mid

theorem suffix_assignment_orders (l : StableBinary.Layout) (code : StableBinarySourceSyntax.Code)
    (u hn : Nat) (product sum : Word) (order : Order) (s out : State) :
    Assignment (suffixRhs l code product sum) (scratch l 0) (u+hn) order s out ↔
      Suffix l code u hn product sum s out := by
  rw [assignment_normalizes]
  constructor
  · rintro ⟨p,mid,w,hp,⟨twice,raw,hd,hv,hc⟩,hw⟩
    have heq : p=scratch l (u+hn) := by simpa [scratch] using pointer_result _ _ _ hp
    subst p
    exact Suffix.step s mid out twice raw w hd hv hc hw
  · intro h
    cases h with
    | step mid _ twice raw w hd hv hc hw =>
        have hu : u+hn<l.length := hw.1.1.2.2.1
        exact ⟨scratch l (u+hn),mid,w,scratch_add l (u+hn) (by omega),⟨twice,raw,hd,hv,hc⟩,hw⟩

def baseRhs (l : StableBinary.Layout) (start : Nat) (s : State) (z : Word) (mid : State) : Prop :=
  ∃ w, Load64 s.heap (values l start) w ∧ Positive l s w z mid

theorem base_assignment_orders (l : StableBinary.Layout) (start : Nat) (order : Order) (s out : State) :
    Assignment (baseRhs l start) (values l start) 0 order s out ↔
      ∃ mid w z, Load64 s.heap (values l start) w ∧ Positive l s w z mid ∧ Store (values l start) mid z out := by
  rw [assignment_normalizes]
  constructor
  · rintro ⟨p,mid,z,hp,⟨w,hr,hc⟩,hw⟩
    have heq : p=values l start := by simpa using pointer_result _ _ _ hp
    subst p
    exact ⟨mid,w,z,hr,hc,hw⟩
  · rintro ⟨mid,w,z,hr,hc,hw⟩
    have hi : start<l.length := hw.1.1.2.2.1
    exact ⟨values l start,mid,z,by simpa using values_add l start 0 (by omega),⟨w,hr,hc⟩,hw⟩

/- Pure operand evaluation may read a value or execute a value-only FPR
   function. It has no resulting memory state. In all seven checker sites
   of the helper the other argument is the local pointer `bad`. -/
inductive CheckedArguments (operand : State → Word → Prop) (l : StableBinary.Layout) :
    Order → State → Word → State → Prop where
  | valueFirst (s out : State) (w z : Word) (p : ArrayPointer)
      (value : operand s w) (address : PointerAdd (bad l) 0 p)
      (call : C99CheckReference.Check s.heap p w z out.heap) (trace : out.checks=w::s.checks) :
      CheckedArguments operand l .leftFirst s z out
  | pointerFirst (s out : State) (w z : Word) (p : ArrayPointer)
      (address : PointerAdd (bad l) 0 p) (value : operand s w)
      (call : C99CheckReference.Check s.heap p w z out.heap) (trace : out.checks=w::s.checks) :
      CheckedArguments operand l .rightFirst s z out

theorem checker_arguments_normalize (operand : State → Word → Prop) (l : StableBinary.Layout)
    (order : Order) (s out : State) (z : Word) : CheckedArguments operand l order s z out ↔
      ∃ w, operand s w ∧ Positive l s w z out := by
  constructor
  · intro h
    cases h with
    | valueFirst _ _ w _ p hv hp hc ht | pointerFirst _ _ w _ p hp hv hc ht =>
        have heq : p=bad l := by simpa using pointer_result _ _ _ hp
        subst p
        exact ⟨w,hv,hc,ht⟩
  · rintro ⟨w,hv,hc,ht⟩
    have hp : PointerAdd (bad l) 0 (bad l) := by
      simpa [bad] using PointerAdd.within (bad l) 0 (by change 0+0≤1; decide)
    cases order
    · exact CheckedArguments.valueFirst s out w z (bad l) hv hp hc ht
    · exact CheckedArguments.pointerFirst s out w z (bad l) hp hv hc ht

end FT1536.Source3.C99HelperOrders

#print axioms FT1536.Source3.C99HelperOrders.half_assignment_orders
#print axioms FT1536.Source3.C99HelperOrders.suffix_assignment_orders
#print axioms FT1536.Source3.C99HelperOrders.base_assignment_orders
#print axioms FT1536.Source3.C99HelperOrders.checker_arguments_normalize
