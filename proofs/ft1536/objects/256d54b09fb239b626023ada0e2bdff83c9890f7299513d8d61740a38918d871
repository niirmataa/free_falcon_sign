import Source3.StableBinaryCalleeBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryStepRefinement
open FT1536.Source3
open FT1536.Source3.StableBinaryRelation

theorem load_positive (l : StableBinary.Layout) (k : Nat) (m : StableBinary.Memory)
    (source source' : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (address : Nat) (z : BitVec 64)
    (hl : l.wellFormed k) (ha : l.allowed address)
    (rel : Related l m source typed)
    (hs : (do
      let w ← StableBinaryCExec.load source address
      StableBinaryCExec.positive l source w)=some (z,source')) :
    ∃ next, (do
      let (w,t) ← StableBinary.load typed address
      StableBinary.stable t w)=some (z,next) ∧ Related l m source' next := by
  obtain ⟨w,hload,hpos⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨t1,ht1,rel1⟩ := load_step l m source typed address w ha rel hload
  obtain ⟨t2,ht2,rel2⟩ := positive_refines l k m source source' t1 w z hl rel1 hpos
  refine ⟨t2,?_,rel2⟩
  simp [ht1,ht2]

private theorem binary_positive (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (source source' : StableBinaryCExec.State)
    (typed : StableBinary.State l m) (name : B20.C.Name)
    (x y z : BitVec 64) (hl : l.wellFormed k)
    (hbridge : ∀ r mid,
      StableBinaryCExec.binary name source x y=some (r,mid) →
      ∃ t1, StableBinarySourceTyped.callBinary typed name x y=some (r,t1) ∧
        Related l m mid t1)
    (hs : (do
      let (r,mid) ← StableBinaryCExec.binary name source x y
      StableBinaryCExec.positive l mid r)=some (z,source')) :
    ∃ next, (do
      let (r,t1) ← StableBinarySourceTyped.callBinary typed name x y
      StableBinary.stable t1 r)=some (z,next) ∧ Related l m source' next := by
  obtain ⟨⟨r,mid⟩,hc,hp⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨t1,ht1,rel1⟩ := hbridge r mid hc
  obtain ⟨t2,ht2,rel2⟩ := positive_refines l k m mid source' t1 r z hl rel1 hp
  refine ⟨t2,?_,rel2⟩
  simp [ht1,ht2]

theorem add_positive (l : StableBinary.Layout) (k : Nat) (m : StableBinary.Memory)
    (source source' : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (x y z : BitVec 64) (hl : l.wellFormed k)
    (rel : Related l m source typed)
    (hs : (do
      let (r,mid) ← StableBinaryCExec.binary "fpr_add".toList source x y
      StableBinaryCExec.positive l mid r)=some (z,source')) :
    ∃ next, (do
      let (r,t1) ← StableBinarySourceTyped.callBinary typed "fpr_add".toList x y
      StableBinary.stable t1 r)=some (z,next) ∧ Related l m source' next := by
  exact binary_positive l k m source source' typed "fpr_add".toList x y z hl
    (fun r mid hc => StableBinaryCalleeBridge.add_refines l m source mid typed x y r rel hc) hs

theorem mul_positive (l : StableBinary.Layout) (k : Nat) (m : StableBinary.Memory)
    (source source' : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (x y z : BitVec 64) (hl : l.wellFormed k)
    (rel : Related l m source typed)
    (hs : (do
      let (r,mid) ← StableBinaryCExec.binary "fpr_mul".toList source x y
      StableBinaryCExec.positive l mid r)=some (z,source')) :
    ∃ next, (do
      let (r,t1) ← StableBinarySourceTyped.callBinary typed "fpr_mul".toList x y
      StableBinary.stable t1 r)=some (z,next) ∧ Related l m source' next := by
  exact binary_positive l k m source source' typed "fpr_mul".toList x y z hl
    (fun r mid hc => StableBinaryCalleeBridge.mul_refines l m source mid typed x y r rel hc) hs

theorem div_positive (l : StableBinary.Layout) (k : Nat) (m : StableBinary.Memory)
    (source source' : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (x y z : BitVec 64) (hl : l.wellFormed k)
    (rel : Related l m source typed)
    (hs : (do
      let (r,mid) ← StableBinaryCExec.binary "fpr_div".toList source x y
      StableBinaryCExec.positive l mid r)=some (z,source')) :
    ∃ next, (do
      let (r,t1) ← StableBinarySourceTyped.callBinary typed "fpr_div".toList x y
      StableBinary.stable t1 r)=some (z,next) ∧ Related l m source' next := by
  exact binary_positive l k m source source' typed "fpr_div".toList x y z hl
    (fun r mid hc => StableBinaryCalleeBridge.div_refines l m source mid typed x y r rel hc) hs

theorem half_positive (l : StableBinary.Layout) (k : Nat) (m : StableBinary.Memory)
    (source source' : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (x z : BitVec 64) (hl : l.wellFormed k)
    (rel : Related l m source typed)
    (hs : (do
      let (r,mid) ← StableBinaryCExec.unary "fpr_half".toList source x
      StableBinaryCExec.positive l mid r)=some (z,source')) :
    ∃ next, (do
      let (r,t1) ← StableBinarySourceTyped.callUnary typed "fpr_half".toList x
      StableBinary.stable t1 r)=some (z,next) ∧ Related l m source' next := by
  obtain ⟨⟨r,mid⟩,hc,hp⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨t1,ht1,rel1⟩ :=
    StableBinaryCalleeBridge.half_refines l m source mid typed x r rel hc
  obtain ⟨t2,ht2,rel2⟩ := positive_refines l k m mid source' t1 r z hl rel1 hp
  refine ⟨t2,?_,rel2⟩
  change (StableBinarySourceTyped.callUnary typed "fpr_half".toList x).bind
      (fun pair => StableBinary.stable pair.2 pair.1) = some (z,t2)
  simp only [Option.bind,ht1,ht2]

theorem double_div_positive (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (source source' : StableBinaryCExec.State)
    (typed : StableBinary.State l m) (product sum z : BitVec 64)
    (hl : l.wellFormed k) (rel : Related l m source typed)
    (hs : (do
      let (twice,mid1) ← StableBinaryCExec.unary "fpr_double".toList source product
      let (quotient,mid2) ← StableBinaryCExec.binary "fpr_div".toList mid1 twice sum
      StableBinaryCExec.positive l mid2 quotient)=some (z,source')) :
    ∃ next, (do
      let (twice,t1) ← StableBinarySourceTyped.callUnary typed "fpr_double".toList product
      let (quotient,t2) ← StableBinarySourceTyped.callBinary t1 "fpr_div".toList twice sum
      StableBinary.stable t2 quotient)=some (z,next) ∧ Related l m source' next := by
  obtain ⟨⟨twice,mid1⟩,hdouble,hrest⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨⟨quotient,mid2⟩,hdiv,hpos⟩ := Option.bind_eq_some_iff.mp hrest
  obtain ⟨t1,ht1,rel1⟩ :=
    StableBinaryCalleeBridge.double_refines l m source mid1 typed product twice rel hdouble
  obtain ⟨t2,ht2,rel2⟩ :=
    StableBinaryCalleeBridge.div_refines l m mid1 mid2 t1 twice sum quotient rel1 hdiv
  obtain ⟨t3,ht3,rel3⟩ := positive_refines l k m mid2 source' t2 quotient z hl rel2 hpos
  refine ⟨t3,?_,rel3⟩
  change (StableBinarySourceTyped.callUnary typed "fpr_double".toList product).bind
      (fun p => (StableBinarySourceTyped.callBinary p.2 "fpr_div".toList p.1 sum).bind
        (fun q => StableBinary.stable q.2 q.1)) = some (z,t3)
  simp only [Option.bind,ht1,ht2,ht3]

end FT1536.Source3.StableBinaryStepRefinement

#print axioms FT1536.Source3.StableBinaryStepRefinement.load_positive
#print axioms FT1536.Source3.StableBinaryStepRefinement.add_positive
#print axioms FT1536.Source3.StableBinaryStepRefinement.mul_positive
#print axioms FT1536.Source3.StableBinaryStepRefinement.div_positive
#print axioms FT1536.Source3.StableBinaryStepRefinement.half_positive
#print axioms FT1536.Source3.StableBinaryStepRefinement.double_div_positive
