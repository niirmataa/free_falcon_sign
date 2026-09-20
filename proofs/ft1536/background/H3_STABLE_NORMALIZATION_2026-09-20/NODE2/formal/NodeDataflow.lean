import Std
namespace Node3
structure Complex (α : Type) where
  re : α
  im : α
structure Ops (α : Type) where
  add : α → α → α
  sub : α → α → α
  mul : α → α → α
  div : α → α → α
  neg : α → α
  zero : α
def adj {α : Type} (o : Ops α) (a : Complex α) : Complex α := ⟨a.re,o.neg a.im⟩
def cadd {α : Type} (o : Ops α) (a b : Complex α) : Complex α := ⟨o.add a.re b.re,o.add a.im b.im⟩
def csub {α : Type} (o : Ops α) (a b : Complex α) : Complex α := ⟨o.sub a.re b.re,o.sub a.im b.im⟩
def cneg {α : Type} (o : Ops α) (a : Complex α) : Complex α := ⟨o.neg a.re,o.neg a.im⟩
def cmul {α : Type} (o : Ops α) (a b : Complex α) : Complex α :=
  ⟨o.sub (o.mul a.re b.re) (o.mul a.im b.im),o.add (o.mul a.re b.im) (o.mul a.im b.re)⟩
def divReal {α : Type} (o : Ops α) (a b : Complex α) : Complex α := ⟨o.div a.re b.re,o.div a.im b.re⟩
def mulReal {α : Type} (o : Ops α) (a b : Complex α) : Complex α := ⟨o.mul a.re b.re,o.mul a.im b.re⟩
def selfadj {α : Type} (o : Ops α) (a : Complex α) : Complex α := ⟨o.add (o.mul a.re a.re) (o.mul a.im a.im),o.zero⟩
structure Out (α : Type) where
  d11 : Complex α
  d22 : Complex α
  l10 : Complex α
  l20 : Complex α
  l21 : Complex α
def node {α : Type} (o : Ops α) (h τ : α) (b c : Complex α) : Out α :=
  let a : Complex α := ⟨h,τ⟩
  let l10 := divReal o b a
  let d11 := cadd o (cneg o (cmul o b (adj o l10))) a
  let l20 := divReal o c a
  let n21 := cadd o (cneg o (divReal o (cmul o c (adj o b)) a)) b
  let l21 := divReal o n21 d11
  let q2 := cadd o (cneg o (cmul o l20 (adj o c))) a
  let tmp := mulReal o (selfadj o l21) d11
  ⟨d11,csub o q2 tmp,l10,l20,l21⟩
def realView {α : Type} (s : Out α) := (s.d11.re,s.d22.re,s.l10,s.l20,s.l21)
theorem real_slot_noninterference {α : Type} (o : Ops α) (h τ τ' : α) (b c : Complex α) :
    realView (node o h τ b c)=realView (node o h τ' b c) := by rfl
theorem divReal_ignores_imag {α : Type} (o : Ops α) (a : Complex α) (h τ τ' : α) :
    divReal o a ⟨h,τ⟩=divReal o a ⟨h,τ'⟩ := by rfl
theorem mulReal_ignores_imag {α : Type} (o : Ops α) (a : Complex α) (h τ τ' : α) :
    mulReal o a ⟨h,τ⟩=mulReal o a ⟨h,τ'⟩ := by rfl
theorem selfadj_imag_store {α : Type} (o : Ops α) (a : Complex α) : (selfadj o a).im=o.zero := by rfl
end Node3
