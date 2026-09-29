import Std
namespace FT1536M0
abbrev Byte := Fin 256
abbrev Bytes := List Byte
def nonceOK (r : Bytes) : Bool := decide (r.length=40)
def hashInput (r m : Bytes) : Bytes := r++m
def parseTransport (b : Bytes) : Option (Bytes × Bytes) :=
  if 40≤b.length then some (b.take 40,b.drop 40) else none

theorem framing_injective (r s m n : Bytes) (hr : r.length=40) (hs : s.length=40)
    (h : hashInput r m=hashInput s n) : r=s ∧ m=n :=
  List.append_inj h (hr.trans hs.symm)
theorem transport_roundtrip (r b : Bytes) (hr : r.length=40) : parseTransport (r++b)=some (r,b) := by
  have hlen : 40≤(r++b).length := by simp [hr]
  simp only [parseTransport,ite_eq_left hlen,List.take_left' hr,List.drop_left' hr]
theorem repartition_same_input (r : Bytes) (a : Byte) (m : Bytes) :
    hashInput (r++[a]) m=hashInput r (a::m) := by simp [hashInput,List.append_assoc]
theorem repartition_rejected (r : Bytes) (a : Byte) (hr : r.length=39) :
    nonceOK (r++[a])=true ∧ nonceOK r=false := by simp [nonceOK,hr]

structure Budget where
  Qs : Nat
  QH : Nat
  t : Nat
  w : Nat
  L : Nat
  deriving Repr,DecidableEq
def parentBytes (attempts : Nat) : Nat := 40+56*attempts
theorem parent_shake_budget (attempts : Nat) (h : attempts≤16) : parentBytes attempts≤936 := by
  unfold parentBytes;omega
theorem exact_parent_budget : parentBytes 16=936 ∧ (32:Nat)+16+8=56 ∧ 32*8=256 := by decide

#check @framing_injective
#check @repartition_rejected
#check @parent_shake_budget
#print axioms framing_injective
#print axioms transport_roundtrip
#print axioms repartition_same_input
#print axioms repartition_rejected
#print axioms parent_shake_budget
#print axioms exact_parent_budget
end FT1536M0
