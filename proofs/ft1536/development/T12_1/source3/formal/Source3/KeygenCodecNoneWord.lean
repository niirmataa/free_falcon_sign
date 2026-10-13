import Source3.KeygenDecodeNoneScalar
import Source3.KeygenCodecScalarCalculation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual NONE encoder read and the two source RHS calculations.
   This does not yet prove the complete encoder's ordered byte history. -/
namespace FT1536.Source3.KeygenCodecNoneWord
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation

def W (input : BitVec 16) (l : Locals) : Prop :=
  l.scalars "w".toList=some (.uint32,some (.uint32 (input.signExtend 32)))

theorem convert32 (word : BitVec 32) :
    C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 word).integer=.uint32 word := by
  simp only [C99IntegerReference.convert,C99IntegerReference.Value.integer,
    BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]

theorem input_read (args : Args) (s t : State) (flow : Flow)
    (declaredW : s.locals.scalars "w".toList=some (.uint32,none))
    (source : Exec args KeygenCodecNoneBinding.node023 s t flow) :
    ∃ p next : ArrayPointer, ∃ input : BitVec 16,
      s.locals.x=some p ∧ PointerAdd p 1 next ∧ Load16 s.heap p input ∧
      t.locals.x=some next ∧ W input t.locals := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.uint32 ∧ old=none := by
      simpa only [Option.some.injEq,Prod.mk.injEq] using declared.symm.trans declaredW
    obtain ⟨rfl,rfl⟩ := equal
    cases evaluated with
    | unary op e l last v z evaluated operation => cases operation
    | dereference e l last p input evaluated load =>
      cases evaluated with
      | postInc name l last value next updated =>
        cases updated with
        | pointer l p next held advance =>
          cases assigned with
          | set =>
            refine ⟨p,next,input,held,advance,load,rfl,?_⟩
            simp only [W,withLocals,localSet,C99ScalarReference.set,ite_true,
              C99IntegerReference.convert,C99IntegerReference.Value.integer]
            rw [KeygenCodecStaticCountdown.signed_exact input.toInt (by have h:=input.le_toInt; omega)
              (by have h:=input.toInt_lt; omega)]
            rfl

theorem shift_right8 (word : BitVec 32) :
    C99IntegerReference.ShiftExec .right (.uint32 word) (.int32 8) (.uint32 (word >>> 8)) := by
  have source := C99IntegerReference.ShiftExec.right (.uint32 word) (.int32 8) 8 rfl (by change (8 : Nat)<32; decide +kernel)
  have same : C99IntegerReference.convert .uint32 ((C99IntegerReference.Value.uint32 word).integer / 2^8)=
      .uint32 (word >>> 8) := by
    change C99IntegerReference.Value.uint32 (BitVec.ofInt 32 ((word.toNat : Int)/256))=_
    rw [show (word.toNat : Int)/256=((word.toNat/256 : Nat) : Int) by omega,BitVec.ofInt_natCast]
    congr 1
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_ofNat,BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
    have small := word.isLt
    omega
  exact same ▸ source

theorem cast_byte (word : BitVec 32) :
    castInteger .byte (.uint32 word)=some (.int32 (BitVec.ofNat 32 (word.setWidth 8).toNat)) := by
  simp only [castInteger,C99IntegerReference.Value.integer,BitVec.ofInt_natCast,
    BitVec.ofNat_toNat]

theorem high_calculation (l : Locals) (input : BitVec 16) (cell : W input l) :
    Computes l (.cast .byte (.binary .shr (.variable "w".toList) (.number .i32 8)))
      (.int32 (BitVec.ofNat 32 (KeygenDecodeNoneScalar.high input).toNat)) := by
  exact .cast _ _ _ _ (.binary _ _ _ _ _ _
    (.scalar _ _ _ (by unfold Ordinary; decide +kernel) cell)
    (.number _ _ _ (by decide +kernel))
    (.shr _ _ _ (shift_right8 (input.signExtend 32)))) (cast_byte _)

theorem low_calculation (l : Locals) (input : BitVec 16) (cell : W input l) :
    Computes l (.cast .byte (.variable "w".toList))
      (.int32 (BitVec.ofNat 32 (KeygenDecodeNoneScalar.low input).toNat)) :=
  .cast _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) cell) (cast_byte _)

end FT1536.Source3.KeygenCodecNoneWord
