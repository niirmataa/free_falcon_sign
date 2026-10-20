import Source3.C99HelperExists

namespace FT1536.Source3.C99HelperControl
open B20.C C99IntegerReference

def sizeValue (n : Nat) : Value := .uint64 (BitVec.ofNat 64 n)

theorem size_integer (n : Nat) (hn : n<2^64) : (sizeValue n).integer=(n : Int) := by
  change ((n%2^64 : Nat) : Int)=(n : Int)
  rw [Nat.mod_eq_of_lt hn]

theorem guard_exact (u hn : Nat) (hu : u<2^64) (hh : hn<2^64) :
    CompareExec .lt (sizeValue u) (sizeValue hn) (C99ScalarReference.boolean (decide (u<hn))) := by
  have h := C99IntegerSound.compare_sound CLogic.Cmp.lt (.u64 (BitVec.ofNat 64 u)) (.u64 (BitVec.ofNat 64 hn))
  have huI : (u : Int)%18446744073709551616=(u : Int) := by omega
  have hhI : (hn : Int)%18446744073709551616=(hn : Int) := by omega
  simpa [sizeValue,CLogic.compare,CLogic.boolean,commonTy,Val.ty,B20.C.cast,Val.integer,
    BitVec.toNat_ofNat,huI,hhI,C99ScalarReference.boolean,
    C99ValueBridge.value,C99Frontend.comparison] using h

theorem half_exact (n : Nat) (hn : n<2^64) :
    ShiftExec .right (sizeValue n) (.int32 1) (sizeValue (n/2)) := by
  have hword : (BitVec.ofNat 64 n >>> 1)=BitVec.ofNat 64 (n/2) := by
    apply BitVec.eq_of_toNat_eq
    have hhalf : n/2<2^64 := by omega
    change (n%2^64) >>> 1=(n/2)%2^64
    rw [Nat.mod_eq_of_lt hn,Nat.mod_eq_of_lt hhalf,Nat.shiftRight_eq_div_pow]
  exact C99ShiftSound.right_sound (.u64 (BitVec.ofNat 64 n)) (.i32 1) (.u64 (BitVec.ofNat 64 (n/2)))
    (by simp [B20.C.bin,B20.C.shift,hword])

theorem increment_exact (u : Nat) :
    ArithmeticExec .plus (sizeValue u) (.int32 1) (sizeValue (u+1)) := by
  exact C99IntegerSound.arithmetic_sound .plus (.u64 (BitVec.ofNat 64 u)) (.i32 1) (.u64 (BitVec.ofNat 64 (u+1)))
    (by simp [C99ArithmeticBridge.operation,B20.C.bin,commonTy,Val.ty,B20.C.cast,bitsOp,BitVec.ofNat_add])

theorem copy_size_exact (n : Nat) :
    ArithmeticExec .times (sizeValue n) (sizeValue 8) (sizeValue (n*8)) := by
  exact C99IntegerSound.arithmetic_sound .times (.u64 (BitVec.ofNat 64 n)) (.u64 8) (.u64 (BitVec.ofNat 64 (n*8)))
    (by simp [C99ArithmeticBridge.operation,B20.C.bin,commonTy,Val.ty,B20.C.cast,bitsOp,BitVec.ofNat_mul])

theorem iteration_bounds (l : StableBinary.Layout) (rootK k start u : Nat)
    (hl : l.wellFormed rootK) (hb : start+2^(k+1)≤l.length) (hu : u<2^k) :
    u+1<2^64 ∧ u*2+1<2^64 ∧ u+2^k<l.length ∧ start+(u*2+1)<l.length ∧ 8*2^(k+1)<2^64 := by
  have hlen := C99HelperExists.length_bound l rootK hl
  have hp : 2^(k+1)=2*(2^k) := by rw [pow_succ,Nat.mul_comm]
  rw [hp] at hb ⊢
  omega

def iterationNames : List C99ScalarReference.Name := ["a".toList,"b".toList,"product".toList,"sum".toList]
def emptyEnv : C99ScalarReference.Env := fun _ => none
def iterationEnv : C99ScalarReference.Env :=
  C99ScalarReference.set (C99ScalarReference.set (C99ScalarReference.set (C99ScalarReference.set
    emptyEnv "a".toList (.uint64,none)) "b".toList (.uint64,none)) "product".toList (.uint64,none)) "sum".toList (.uint64,none)

theorem iteration_locals_new : C99ScalarReference.Exec C99Frontend.noCalls emptyEnv
    (C99Frontend.declarations .uint64 iterationNames) (.normal iterationEnv) := by
  repeat first
    | apply C99ScalarReference.Exec.seqNormal
    | apply C99ScalarReference.Exec.declare
    | apply C99ScalarReference.Exec.skip

theorem iteration_locals_dead (outer inner : C99ScalarReference.Env) (name : C99ScalarReference.Name)
    (hn : name∈iterationNames) : C99ScalarReference.restore outer inner iterationNames name=outer name := by
  simp [C99ScalarReference.restore,hn]

theorem pinned_local_declarations :
    StableBinarySourceSyntax.words StableBinaryPin.lines 10 2 =
      LeafScan.tokenize 256 "for (u = 0; u < hn; u ++) { fpr a, b, product, sum;".toList := by decide

theorem pinned_parameter_declarations :
    StableBinarySourceSyntax.words StableBinaryPin.lines 0 5 =
      LeafScan.tokenize 256 ("static void ft_stable_binary_inplace_keygen(fpr *values, size_t n, fpr *scratch, uint32_t *bad) { size_t hn, u;".toList) := by decide

end FT1536.Source3.C99HelperControl

#print axioms FT1536.Source3.C99HelperControl.half_exact
#print axioms FT1536.Source3.C99HelperControl.guard_exact
#print axioms FT1536.Source3.C99HelperControl.iteration_locals_new
