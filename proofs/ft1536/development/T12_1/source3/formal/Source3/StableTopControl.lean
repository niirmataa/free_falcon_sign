import Source3.StableTopLoop
import Source3.C99HelperOrders

namespace FT1536.Source3.StableTopControl
open StableTopSyntax C99IntegerReference

theorem guard (v : Nat) (hv : v≤256) :
    CompareExec .lt (C99HelperControl.sizeValue (3*v)) (C99HelperControl.sizeValue 768)
      (C99ScalarReference.boolean (decide (v<256))) := by
  have h := C99HelperControl.guard_exact (3*v) 768 (by omega) (by decide)
  have he : (3*v<768)=(v<256) := propext (by omega)
  simpa only [he] using h
theorem increment_u (v : Nat) : ArithmeticExec .plus (C99HelperControl.sizeValue (3*v)) (.int32 3)
    (C99HelperControl.sizeValue (3*(v+1))) := by
  apply C99IntegerSound.arithmetic_sound .plus (.u64 (BitVec.ofNat 64 (3*v))) (.i32 3)
    (.u64 (BitVec.ofNat 64 (3*(v+1))))
  have hn : 3*(v+1)=3*v+3 := by omega
  simp [C99ArithmeticBridge.operation,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,B20.C.cast,B20.C.bitsOp,hn,BitVec.ofNat_add]

def counterEnv (v : Nat) : C99ScalarReference.Env :=
  C99ScalarReference.set (C99ScalarReference.set (fun _ => none) ['u'] (.uint64,some (C99HelperControl.sizeValue (3*v))))
    ['v'] (.uint64,some (C99HelperControl.sizeValue v))
def counterStep : C99ScalarReference.Stmt :=
  .seq (.assign ['u'] (.arithmetic .plus (.variable ['u']) (.literal .int32 3)))
    (.assign ['v'] (.arithmetic .plus (.variable ['v']) (.literal .int32 1)))

theorem convert_size (n : Nat) : convert .uint64 (C99HelperControl.sizeValue n).integer=C99HelperControl.sizeValue n := by
  exact (C99ValueBridge.cast_matches B20.C.Ty.u64 (B20.C.Val.u64 (BitVec.ofNat 64 n))).symm

theorem comma_increment (v : Nat) :
    C99ScalarReference.Exec C99Frontend.noCalls (counterEnv v) counterStep (.normal (counterEnv (v+1))) := by
  let mid := C99ScalarReference.set (counterEnv v) ['u'] (.uint64,some (C99HelperControl.sizeValue (3*(v+1))))
  have hu : C99ScalarReference.Exec C99Frontend.noCalls (counterEnv v)
      (.assign ['u'] (.arithmetic .plus (.variable ['u']) (.literal .int32 3))) (.normal mid) := by
    have h := C99ScalarReference.Exec.assign (calls:=C99Frontend.noCalls) (counterEnv v) ['u'] _ .uint64
      (some (C99HelperControl.sizeValue (3*v))) (C99HelperControl.sizeValue (3*(v+1)))
      (by simp [counterEnv,C99ScalarReference.set])
      (C99ScalarReference.Eval.arithmetic _ _ _ _ _ _
        (C99ScalarReference.Eval.variable ['u'] .uint64 _ (by simp [counterEnv,C99ScalarReference.set]))
        (C99ScalarReference.Eval.literal .int32 3) (increment_u v))
    simpa only [convert_size] using h
  have hv : C99ScalarReference.Exec C99Frontend.noCalls mid
      (.assign ['v'] (.arithmetic .plus (.variable ['v']) (.literal .int32 1)))
      (.normal (C99ScalarReference.set mid ['v'] (.uint64,some (C99HelperControl.sizeValue (v+1))))) := by
    have h := C99ScalarReference.Exec.assign (calls:=C99Frontend.noCalls) mid ['v'] _ .uint64
      (some (C99HelperControl.sizeValue v)) (C99HelperControl.sizeValue (v+1))
      (by simp [mid,counterEnv,C99ScalarReference.set])
      (C99ScalarReference.Eval.arithmetic _ _ _ _ _ _
        (C99ScalarReference.Eval.variable ['v'] .uint64 _ (by simp [mid,counterEnv,C99ScalarReference.set]))
        (C99ScalarReference.Eval.literal .int32 1) (C99HelperControl.increment_exact v))
    simpa only [convert_size] using h
  have he : C99ScalarReference.set mid ['v'] (.uint64,some (C99HelperControl.sizeValue (v+1)))=counterEnv (v+1) := by
    funext n
    by_cases hu : n=['u'] <;> by_cases hv : n=['v'] <;> simp_all [mid,counterEnv,C99ScalarReference.set]
  rw [he] at hv
  exact C99ScalarReference.Exec.seqNormal _ _ _ _ _ hu hv

def destinations : List Stmt → List B20.C.Name
  | [] => []
  | .readCheck n _::rest | .letCheck n _::rest => n::destinations rest
  | .storeCheck _ _::rest => destinations rest
theorem counters_and_three_not_assigned :
    ['u']∉destinations expected.body ∧ ['v']∉destinations expected.body ∧
      "three".toList∉destinations expected.body := by decide

theorem store_orders (l : StableTopMemory.Layout) (u v off : Nat) (expr : Expr)
    (s out : StableTopReference.State) (order : C99HelperOrders.Order) :
    StableTopReference.Step l u v (.storeCheck off expr) s out ↔
      ∃ raw, StableTopExpr.Eval s.locals expr raw ∧ out.locals=s.locals ∧
        C99HelperOrders.Assignment
          (fun before w after => C99HelperReference.Positive (StableTopMemory.branch l 0) before raw w after)
          (StableTopMemory.leavesPtr l 0) (off+v) order s.memory out.memory := by
  constructor
  · intro h
    cases h with
    | write off expr s mid out raw w he hc hw =>
        refine ⟨raw,he,rfl,(C99HelperOrders.assignment_normalizes _ _ _ _ _ _).mpr ?_⟩
        have hi : off+v<768 := hw.1.1.2.2.1
        have hp : C99MemoryReference.PointerAdd (StableTopMemory.leavesPtr l 0) (off+v)
            (StableTopMemory.leavesPtr l (off+v)) := by
          simpa [StableTopMemory.leavesPtr] using C99MemoryReference.PointerAdd.within
            (StableTopMemory.leavesPtr l 0) (off+v) (by change 0+(off+v)≤768; omega)
        exact ⟨_,mid,w,hp,hc,hw⟩
  · rintro ⟨raw,he,hloc,ha⟩
    obtain ⟨p,mid,w,hp,hc,hw⟩ := (C99HelperOrders.assignment_normalizes _ _ _ _ _ _).mp ha
    have hptr : p=StableTopMemory.leavesPtr l (off+v) := by
      simpa [StableTopMemory.leavesPtr] using C99HelperOrders.pointer_result _ _ _ hp
    subst p
    have hout : out=⟨out.memory,s.locals⟩ := by cases out; simp_all
    rw [hout]
    exact StableTopReference.Step.write off expr s mid out.memory raw w he hc hw

end FT1536.Source3.StableTopControl

#print axioms FT1536.Source3.StableTopControl.comma_increment
#print axioms FT1536.Source3.StableTopControl.store_orders
