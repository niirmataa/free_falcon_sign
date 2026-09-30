import Source3.CertificateSuffix001Outcome

namespace FT1536.Source3.CertificateOrders
open CertificateMemory CertificateEffects CertificateAtoms C99HelperOrders

def Rhs (l : Layout) (q : BitVec 64) (u : Nat) (s : RState) (z : BitVec 64) (mid : RState) : Prop :=
  ∃ x raw, C99MemoryReference.Load64 s.heap (leafPtr l u) x ∧
    C99Frontend.primitiveCall "fpr_div".toList [.uint64 q,.uint64 x] (.uint64 raw) ∧ Positive l s raw z mid
inductive Assignment (l : Layout) (q : BitVec 64) (u : Nat) : Order → RState → RState → Prop where
  | left (s mid out : RState) (dst : Nat) (z : BitVec 64)
      (index : CertificateIndex.IndexEval u dst) (rhs : Rhs l q u s z mid) (write : Store l mid dst z out) :
      Assignment l q u .leftFirst s out
  | right (s mid out : RState) (dst : Nat) (z : BitVec 64)
      (rhs : Rhs l q u s z mid) (index : CertificateIndex.IndexEval u dst) (write : Store l mid dst z out) :
      Assignment l q u .rightFirst s out

/- IndexEval depends on immutable by-value n/u only. It therefore has the
   same result before and after RHS bad RMW; it never reads the byte heap.
   Both C99 assignment orders normalize to the selected source Step. -/
theorem reverse_orders (l : Layout) (q : BitVec 64) (u : Nat) (hu : u<768) (order : Order) (s out : RState) :
    Assignment l q u order s out ↔ CertificateReverse.Step l q u s out := by
  constructor
  · intro h
    cases h with
    | left _ mid _ dst z hi hr hw | right _ mid _ dst z hr hi hw =>
        obtain ⟨x,raw,hload,hdiv,hcheck⟩:=hr
        exact CertificateReverse.Step.emit s mid out dst x raw z hu hi hload hdiv hcheck hw
  · intro h
    cases h with
    | emit mid _ dst x raw z _ hi hr hd hc hw =>
        cases order
        · exact Assignment.left s mid out dst z hi ⟨x,raw,hr,hd,hc⟩ hw
        · exact Assignment.right s mid out dst z ⟨x,raw,hr,hd,hc⟩ hi hw

theorem scan_guard (u : Nat) (hu : u≤1536) :
    C99IntegerReference.CompareExec .lt (C99HelperControl.sizeValue u) (C99HelperControl.sizeValue 1536)
      (C99ScalarReference.boolean (decide (u<1536))) := C99HelperControl.guard_exact _ _ (by omega) (by decide)
theorem scan_increment_no_wrap (u : Nat) (hu : u<1536) : u+1≤1536 ∧ u+1<2^64 := by omega
theorem fresh_scan_locals (bits : BitVec 64) (bad : BitVec 32) :
    CertificateRange.initialEnv bits bad "valid".toList=some (.uint32,none) ∧
    CertificateRange.initialEnv bits bad "bits".toList=some (.uint64,some (.uint64 bits)) := by
  simp [CertificateRange.initialEnv]
theorem private_scope_exit (outer inner : C99ScalarReference.Env) :
    C99ScalarReference.restore outer inner ["bits".toList,"valid".toList] "bits".toList=outer "bits".toList ∧
    C99ScalarReference.restore outer inner ["bits".toList,"valid".toList] "valid".toList=outer "valid".toList := by
  simp [C99ScalarReference.restore]

end FT1536.Source3.CertificateOrders

#print axioms FT1536.Source3.CertificateOrders.reverse_orders
#print axioms FT1536.Source3.CertificateOrders.fresh_scan_locals
