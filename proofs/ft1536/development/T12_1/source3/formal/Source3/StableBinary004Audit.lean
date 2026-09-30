import Source3.StableBinary004Outcome
import Source3.C99HelperOrders

namespace FT1536.Source3.StableBinary004Audit
open B20.C

def wrongMul (x y : BitVec 64) : Option (BitVec 64) := (FprPrimitives.mul x y).map (· ^^^ 1)

theorem wrong_word_still_some_detected (x y z : BitVec 64)
    (hs : C99Frontend.primitiveCall "fpr_mul".toList [.uint64 x,.uint64 y] (.uint64 z)) :
    (wrongMul x y).isSome ∧ wrongMul x y≠some z := by
  have hm := C99MulProof.pinned_mul_complete x y z hs
  have hz : z ^^^ (1 : BitVec 64)≠z := by
    intro heq
    have hbit := congrArg (fun w : BitVec 64 => w.getLsbD 0) heq
    simp at hbit
  simpa [wrongMul,hm] using hz

theorem missing_block_exit_detected (outer inner : B20.C.Scalar.State)
    (ho : outer.types=FprUnsignedPrefixes.divTypes) (hi : inner.types=C99DivLoopBridge.roundTypes) :
    B20.C.Scalar.declareOne inner .u64 ['b']=none ∧
      (B20.C.Scalar.declareOne (FprPrimitives.leaveBlock outer inner [['b']]) .u64 ['b']).isSome := by
  simp [B20.C.Scalar.declareOne,FprPrimitives.leaveBlock,ho,hi,C99DivLoopBridge.roundTypes,
    FprUnsignedPrefixes.divTypes,FprUnsignedPrefixes.xyTypes,UnsignedState.setType]

def properParam : C99ScalarReference.Env := C99ScalarReference.set (fun _ => none) ['x']
  (.uint64,some (C99IntegerReference.convert .uint64 (C99IntegerReference.Value.int32 0xffffffff#32).integer))
def zeroExtendedParam : C99ScalarReference.Env := C99ScalarReference.set (fun _ => none) ['x']
  (.uint64,some (.uint64 0x00000000ffffffff#64))

theorem wrong_by_value_conversion_detected :
    C99ScalarReference.BindArgs [(.uint64,['x'])] [.int32 0xffffffff#32] properParam ∧
      properParam ['x']≠zeroExtendedParam ['x'] := by
  exact ⟨C99ScalarReference.BindArgs.cons _ _ _ _ _ _ C99ScalarReference.BindArgs.nil,by decide⟩

theorem missing_control_detected (l : StableBinary.Layout) (s out : C99HelperReference.State)
    (w z : BitVec 64) (h : C99HelperReference.Positive l s w z out) :
    out.checks.tail≠out.checks := by
  rw [h.2]
  intro heq
  have hn := congrArg List.length heq
  simp at hn

def zeroHeap : C99MemoryReference.Memory := C99BitcastReference.entry 0
def flagPointer : C99MemoryReference.ArrayPointer := ⟨0,0,1,4,0⟩

theorem omitted_flag_store_detected (z : BitVec 64) :
    ¬C99CheckReference.Check zeroHeap flagPointer 0 z zeroHeap := by
  intro h
  obtain ⟨_,old,hr,hw⟩ := (C99CheckBridge.check_iff _ _ _ _ _).mp h
  have hread := C99MemoryAccess.load32_to_model zeroHeap flagPointer old rfl hr
  have hzero : StableBinaryByteView.flagRead (C99MemoryBridge.encode zeroHeap) 0=some 0 := by decide
  have hold : old=0 := Option.some.inj (hread.symm.trans hzero)
  subst old
  have hbyte := hw.2.2.2.2.2.1 (0 : Fin 4)
  have no : (0 : BitVec 8)=1 := Option.some.inj hbyte
  cases no

end FT1536.Source3.StableBinary004Audit

#print axioms FT1536.Source3.StableBinary004Audit.wrong_word_still_some_detected
#print axioms FT1536.Source3.StableBinary004Audit.missing_block_exit_detected
#print axioms FT1536.Source3.StableBinary004Audit.wrong_by_value_conversion_detected
#print axioms FT1536.Source3.StableBinary004Audit.missing_control_detected
#print axioms FT1536.Source3.StableBinary004Audit.omitted_flag_store_detected
