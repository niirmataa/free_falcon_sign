import Source3.FftMiddleLoad139
import Source3.C99ControlShift142
import Source3.C99PointerNat141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupIndex143
open C99ArrayReference (State scalar)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)

def shifted : CLogic.Expr := .bin .shl (.bin .add (.var "m".toList) (.var "u1".toList)) (.literal .i32 1)

theorem real_shape : FftMiddleLoad139.loadIndex FftMiddleLoad139.realCode=.bin .add shifted (.literal .i32 0) := by rfl
theorem imag_shape : FftMiddleLoad139.loadIndex FftMiddleLoad139.imagCode=.bin .add shifted (.literal .i32 1) := by rfl

theorem add_zero (n : Nat) (bound : n<2^64) :
    C99IntegerReference.ArithmeticExec .plus (.uint64 (word n)) (.int32 0) (.uint64 (word n)) := by
  have raw := C99IntegerReference.ArithmeticExec.step .plus (.uint64 (word n)) (.int32 0) .uint64 rfl
    (.uint64 (word n)) (.uint64 0)
    (C99CountedWords.convert_self (.uint64 (word n))).symm rfl (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .plus (.uint64 (word n)) (.int32 0)
    (.uint64 (BitVec.ofInt 64 ((C99IntegerReference.Value.uint64 (word n)).integer+0))) at raw
  rw [C99NatWord141.integer n bound, Int.add_zero, BitVec.ofInt_natCast] at raw
  exact raw

theorem shift_eval (s : State) (m u : Nat) (bound : m+u<1024)
    (mCell : Cell s "m".toList m) (uCell : Cell s "u1".toList u) :
    scalar s shifted (.uint64 (word (2*(m+u)))) := by
  have addition := C99LoopScalar141.add s _ _ m u (by omega) (by omega)
    (C99LoopScalar141.read s _ m mCell) (C99LoopScalar141.read s _ u uCell)
  have shift := C99ControlShift142.double_word (m+u) (by omega)
  rw [Nat.mul_comm (m+u) 2] at shift
  exact .shift .left _ _ _ _ _ addition (.literal .int32 1) shift

theorem real_eval (s : State) (m u : Nat) (bound : m+u<1024)
    (mCell : Cell s "m".toList m) (uCell : Cell s "u1".toList u) :
    scalar s (FftMiddleLoad139.loadIndex FftMiddleLoad139.realCode) (.uint64 (word (2*(m+u)))) := by
  rw [real_shape]
  exact .arithmetic .plus _ _ _ _ _ (shift_eval s m u bound mCell uCell) (.literal .int32 0)
    (add_zero (2*(m+u)) (by omega))

theorem imag_eval (s : State) (m u : Nat) (bound : m+u<1024)
    (mCell : Cell s "m".toList m) (uCell : Cell s "u1".toList u) :
    scalar s (FftMiddleLoad139.loadIndex FftMiddleLoad139.imagCode) (.uint64 (word (2*(m+u)+1))) := by
  rw [imag_shape]
  exact .arithmetic .plus _ _ _ _ _ (shift_eval s m u bound mCell uCell) (.literal .int32 1)
    (C99NatWord141.add_one (2*(m+u)) (by omega))

theorem real_pointer (s : State) (m u : Nat) (bound : m+u<1024)
    (mCell : Cell s "m".toList m) (uCell : Cell s "u1".toList u)
    (binding : s.arrays "fpr_gm3_square".toList=some (FftGlobalMemory.pointer .square)) :
    C99ArrayReference.Pointer s "fpr_gm3_square".toList (FftMiddleLoad139.loadIndex FftMiddleLoad139.realCode)
      {FftGlobalMemory.pointer .square with index := 2*(m+u)} := by
  simpa only [FftGlobalMemory.pointer, Nat.zero_add] using C99PointerNat141.source s _ _ (FftGlobalMemory.pointer .square) (2*(m+u)) (by omega)
    (by change 0+2*(m+u)≤2048; omega) binding (real_eval s m u bound mCell uCell)

theorem imag_pointer (s : State) (m u : Nat) (bound : m+u<1024)
    (mCell : Cell s "m".toList m) (uCell : Cell s "u1".toList u)
    (binding : s.arrays "fpr_gm3_square".toList=some (FftGlobalMemory.pointer .square)) :
    C99ArrayReference.Pointer s "fpr_gm3_square".toList (FftMiddleLoad139.loadIndex FftMiddleLoad139.imagCode)
      {FftGlobalMemory.pointer .square with index := 2*(m+u)+1} := by
  simpa only [FftGlobalMemory.pointer, Nat.zero_add] using C99PointerNat141.source s _ _ (FftGlobalMemory.pointer .square) (2*(m+u)+1) (by omega)
    (by change 0+(2*(m+u)+1)≤2048; omega) binding (imag_eval s m u bound mCell uCell)

end FT1536.Source3.FftGroupIndex143
