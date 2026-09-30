import Source3.StableBinaryRelation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryCalleeBridge
open FT1536.Source3

theorem add_source_word_and_frame (source : StableBinaryCExec.State)
    (x y : BitVec 64) :
    StableBinaryCExec.binary "fpr_add".toList source x y =
      (FprPrimitives.add x y).map (fun z => (z,source)) := by
  simp [StableBinaryCExec.binary,FprCErasure.source_call_model,FprPrimitives.add]
  cases h : FprPrimitives.call FprPrimitives.addProgram x y <;> rfl

theorem mul_source_word_and_frame (source : StableBinaryCExec.State)
    (x y : BitVec 64) :
    StableBinaryCExec.binary "fpr_mul".toList source x y =
      (FprPrimitives.mul x y).map (fun z => (z,source)) := by
  simp [StableBinaryCExec.binary,FprCErasure.source_call_model,FprPrimitives.mul]
  cases h : FprPrimitives.call FprPrimitives.mulProgram x y <;> rfl

theorem div_source_word_and_frame (source : StableBinaryCExec.State)
    (x y : BitVec 64) :
    StableBinaryCExec.binary "fpr_div".toList source x y =
      (FprPrimitives.div x y).map (fun z => (z,source)) := by
  simp [StableBinaryCExec.binary,FprCErasure.source_call_model,FprPrimitives.div]
  cases h : FprPrimitives.call FprPrimitives.divProgram x y <;> rfl

theorem half_source_word_and_frame (source : StableBinaryCExec.State)
    (x : BitVec 64) :
    StableBinaryCExec.unary "fpr_half".toList source x =
      (StableBinary.half x).map (fun z => (z,source)) := by
  simp [StableBinaryCExec.unary,StableBinary.half,StableBinary.half_parses]
  cases h : CLogic.execute (fun _ _ => none) StableBinary.halfProgram [.u64 x] with
  | none => rfl
  | some v => cases v <;> rfl

theorem double_source_word_and_frame (source : StableBinaryCExec.State)
    (x : BitVec 64) :
    StableBinaryCExec.unary "fpr_double".toList source x =
      (StableBinary.double x).map (fun z => (z,source)) := by
  simp [StableBinaryCExec.unary,StableBinary.double,StableBinary.double_parses]
  cases h : CLogic.execute (fun _ _ => none) StableBinary.doubleProgram [.u64 x] with
  | none => rfl
  | some v => cases v <;> rfl

private theorem lift_binary (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source after : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (codeName : B20.C.Name) (event : String)
    (f : BitVec 64 → BitVec 64 → Option (BitVec 64))
    (x y z : BitVec 64) (rel : StableBinaryRelation.Related l m source typed)
    (hsrc : StableBinaryCExec.binary codeName source x y=
      (f x y).map (fun out => (out,source)))
    (hmodel : StableBinarySourceTyped.callBinary typed codeName x y=
      StableBinary.call2 typed event f x y)
    (hs : StableBinaryCExec.binary codeName source x y=some (z,after)) :
    ∃ next, StableBinarySourceTyped.callBinary typed codeName x y=some (z,next) ∧
      StableBinaryRelation.Related l m after next := by
  rw [hsrc] at hs
  cases hf : f x y with
  | none => simp [hf] at hs
  | some word =>
      have heq : (word,source)=(z,after) := by simpa [hf] using hs
      have hz : word=z := (Prod.mk.inj heq).1
      have hstate : source=after := (Prod.mk.inj heq).2
      subst z
      subst after
      let next : StableBinary.State l m :=
        {typed with events := .fpr event [x,y] word::typed.events}
      refine ⟨next,?_,?_⟩
      · rw [hmodel]
        simp [StableBinary.call2,hf,next]
      · exact ⟨rel.words,rel.flags,rel.checks⟩

theorem add_refines (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source after : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (x y z : BitVec 64) (rel : StableBinaryRelation.Related l m source typed)
    (hs : StableBinaryCExec.binary "fpr_add".toList source x y=some (z,after)) :
    ∃ next, StableBinarySourceTyped.callBinary typed "fpr_add".toList x y=
        some (z,next) ∧ StableBinaryRelation.Related l m after next := by
  exact lift_binary l m source after typed "fpr_add".toList "fpr_add"
    FprPrimitives.add x y z rel (add_source_word_and_frame source x y)
    (by rfl) hs

theorem mul_refines (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source after : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (x y z : BitVec 64) (rel : StableBinaryRelation.Related l m source typed)
    (hs : StableBinaryCExec.binary "fpr_mul".toList source x y=some (z,after)) :
    ∃ next, StableBinarySourceTyped.callBinary typed "fpr_mul".toList x y=
        some (z,next) ∧ StableBinaryRelation.Related l m after next := by
  exact lift_binary l m source after typed "fpr_mul".toList "fpr_mul"
    FprPrimitives.mul x y z rel (mul_source_word_and_frame source x y)
    (by rfl) hs

theorem div_refines (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source after : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (x y z : BitVec 64) (rel : StableBinaryRelation.Related l m source typed)
    (hs : StableBinaryCExec.binary "fpr_div".toList source x y=some (z,after)) :
    ∃ next, StableBinarySourceTyped.callBinary typed "fpr_div".toList x y=
        some (z,next) ∧ StableBinaryRelation.Related l m after next := by
  exact lift_binary l m source after typed "fpr_div".toList "fpr_div"
    FprPrimitives.div x y z rel (div_source_word_and_frame source x y)
    (by rfl) hs

private theorem lift_unary (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source after : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (codeName : B20.C.Name) (event : String)
    (f : BitVec 64 → Option (BitVec 64))
    (x z : BitVec 64) (rel : StableBinaryRelation.Related l m source typed)
    (hsrc : StableBinaryCExec.unary codeName source x=
      (f x).map (fun out => (out,source)))
    (hmodel : StableBinarySourceTyped.callUnary typed codeName x=
      StableBinary.call1 typed event f x)
    (hs : StableBinaryCExec.unary codeName source x=some (z,after)) :
    ∃ next, StableBinarySourceTyped.callUnary typed codeName x=some (z,next) ∧
      StableBinaryRelation.Related l m after next := by
  rw [hsrc] at hs
  cases hf : f x with
  | none => simp [hf] at hs
  | some word =>
      have heq : (word,source)=(z,after) := by simpa [hf] using hs
      have hz : word=z := (Prod.mk.inj heq).1
      have hstate : source=after := (Prod.mk.inj heq).2
      subst z
      subst after
      let next : StableBinary.State l m :=
        {typed with events := .fpr event [x] word::typed.events}
      refine ⟨next,?_,?_⟩
      · rw [hmodel]
        simp [StableBinary.call1,hf,next]
      · exact ⟨rel.words,rel.flags,rel.checks⟩

theorem half_refines (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source after : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (x z : BitVec 64) (rel : StableBinaryRelation.Related l m source typed)
    (hs : StableBinaryCExec.unary "fpr_half".toList source x=some (z,after)) :
    ∃ next, StableBinarySourceTyped.callUnary typed "fpr_half".toList x=
        some (z,next) ∧ StableBinaryRelation.Related l m after next := by
  exact lift_unary l m source after typed "fpr_half".toList "fpr_half"
    StableBinary.half x z rel (half_source_word_and_frame source x)
    (by rfl) hs

theorem double_refines (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source after : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (x z : BitVec 64) (rel : StableBinaryRelation.Related l m source typed)
    (hs : StableBinaryCExec.unary "fpr_double".toList source x=some (z,after)) :
    ∃ next, StableBinarySourceTyped.callUnary typed "fpr_double".toList x=
        some (z,next) ∧ StableBinaryRelation.Related l m after next := by
  exact lift_unary l m source after typed "fpr_double".toList "fpr_double"
    StableBinary.double x z rel (double_source_word_and_frame source x)
    (by rfl) hs

end FT1536.Source3.StableBinaryCalleeBridge

#print axioms FT1536.Source3.StableBinaryCalleeBridge.add_source_word_and_frame
#print axioms FT1536.Source3.StableBinaryCalleeBridge.mul_source_word_and_frame
#print axioms FT1536.Source3.StableBinaryCalleeBridge.div_source_word_and_frame
#print axioms FT1536.Source3.StableBinaryCalleeBridge.half_source_word_and_frame
#print axioms FT1536.Source3.StableBinaryCalleeBridge.double_source_word_and_frame
#print axioms FT1536.Source3.StableBinaryCalleeBridge.add_refines
#print axioms FT1536.Source3.StableBinaryCalleeBridge.mul_refines
#print axioms FT1536.Source3.StableBinaryCalleeBridge.div_refines
#print axioms FT1536.Source3.StableBinaryCalleeBridge.half_refines
#print axioms FT1536.Source3.StableBinaryCalleeBridge.double_refines
