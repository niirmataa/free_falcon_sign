import Source3.KeygenDecodeNoneRead

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source LP64 long subtraction and int16 narrowing after the real NONE
   carrier guard. The decoded word follows from those operations. -/
namespace FT1536.Source3.KeygenDecodeNoneSubtract
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeWordOps KeygenDecodeNoneCore KeygenDecodeNoneScalar

def rhs : Expr := .binary .sub (.cast .long (.variable "w".toList)) (.cast .long (.variable "q".toList))

theorem self64 (word : BitVec 64) :
    C99IntegerReference.convert .int64 (C99IntegerReference.Value.int64 word).integer=.int64 word := by
  change C99IntegerReference.Value.int64 (BitVec.ofInt 64 word.toInt)=_
  rw [BitVec.ofInt_toInt]

theorem cast_long32 (word : BitVec 32) :
    castInteger .long (.uint32 word)=some (.int64 (BitVec.ofNat 64 word.toNat)) := by
  change some (C99IntegerReference.Value.int64 (BitVec.ofInt 64 (word.toNat : Int)))=_
  rw [BitVec.ofInt_natCast]

theorem long_subtraction (word : BitVec 32) :
    C99IntegerReference.ArithmeticExec .minus (.int64 (BitVec.ofNat 64 word.toNat)) (.int64 18433)
      (.int64 (BitVec.ofInt 64 ((word.toNat : Int)-18433))) := by
  have integer : (C99IntegerReference.Value.int64 (BitVec.ofNat 64 word.toNat)).integer=(word.toNat : Int) :=
    KeygenCodecNoneCursor.signed_nat64 word.toNat (by have bound:=word.isLt; omega)
  have safe : C99IntegerReference.signed .int64=true → C99IntegerReference.fits .int64
      (C99IntegerReference.exact .minus
        (C99IntegerReference.Value.int64 (BitVec.ofNat 64 word.toNat)).integer
        (C99IntegerReference.Value.int64 18433).integer) := by
    intro _
    change -9223372036854775808≤
        (C99IntegerReference.Value.int64 (BitVec.ofNat 64 word.toNat)).integer-18433 ∧
      (C99IntegerReference.Value.int64 (BitVec.ofNat 64 word.toNat)).integer-18433<9223372036854775808
    rw [integer]
    have bound:=word.isLt
    omega
  have source := C99IntegerReference.ArithmeticExec.step .minus
    (.int64 (BitVec.ofNat 64 word.toNat)) (.int64 18433) .int64 rfl
    (.int64 (BitVec.ofNat 64 word.toNat)) (.int64 18433)
    (self64 _).symm rfl safe
  have qvalue : (C99IntegerReference.Value.int64 18433).integer=(18433 : Int) := rfl
  simpa only [C99IntegerReference.exact,integer,qvalue,C99IntegerReference.convert] using source

theorem rhs_calculation (args : Args) (s : State) (input : BitVec 16) (carrier : Carrier input)
    (w : Cell "w" .uint32 (.uint32 (adjusted (high input) (low input))) s.locals)
    (q : Cell "q" .uint32 (.uint32 18433) s.locals) :
    Computes args s.heap s.buf s.locals rhs (.int64 (BitVec.ofInt 64 input.toInt)) := by
  have calculation : Computes args s.heap s.buf s.locals rhs
      (.int64 (BitVec.ofInt 64 (((adjusted (high input) (low input)).toNat : Int)-18433))) :=
    .binary _ _ _ _ _ _
      (.cast _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) w) (cast_long32 _))
      (.cast _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) q) (by decide +kernel))
      (.sub _ _ _ (long_subtraction _))
  simpa only [carrier_subtract input carrier] using calculation

/-- Actual source y assignment, without a decoded-value premise. -/
theorem subtract_source (args : Args) (s t : State) (flow : Flow) (input : BitVec 16) (carrier : Carrier input)
    (w : Cell "w" .uint32 (.uint32 (adjusted (high input) (low input))) s.locals)
    (q : Cell "q" .uint32 (.uint32 18433) s.locals)
    (declaredY : s.locals.scalars "y".toList=some (.int64,none))
    (source : Exec args KeygenDecodeNoneBinding.node030 s t flow) :
    t=withLocals s (localSet s.locals "y".toList .int64 (some (.int64 (BitVec.ofInt 64 input.toInt)))) ∧ flow=.normal := by
  have result := assign_set args s t flow "y".toList .int64 none rhs _ declaredY
    (rhs_calculation args s input carrier w q) source
  simpa only [self64] using result

theorem subtract_exists (args : Args) (s : State) (input : BitVec 16) (carrier : Carrier input)
    (w : Cell "w" .uint32 (.uint32 (adjusted (high input) (low input))) s.locals)
    (q : Cell "q" .uint32 (.uint32 18433) s.locals)
    (declaredY : s.locals.scalars "y".toList=some (.int64,none)) :
    Exec args KeygenDecodeNoneBinding.node030 s
      (withLocals s (localSet s.locals "y".toList .int64 (some (.int64 (BitVec.ofInt 64 input.toInt))))) .normal := by
  have result := assign_exists args s "y".toList .int64 none rhs _ (by decide +kernel) (by decide +kernel)
    declaredY (rhs_calculation args s input carrier w q)
  simpa only [self64,KeygenDecodeNoneBinding.node030,rhs] using result

theorem narrow_calculation (args : Args) (s : State) (input : BitVec 16)
    (y : Cell "y" .int64 (.int64 (BitVec.ofInt 64 input.toInt)) s.locals) :
    Computes args s.heap s.buf s.locals (.cast .i16 (.variable "y".toList))
      (.int32 (BitVec.ofInt 32 input.toInt)) := by
  apply Computes.cast _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) y)
  change some (C99IntegerReference.Value.int32 (BitVec.ofInt 32
    (BitVec.ofInt 16 (BitVec.ofInt 64 input.toInt).toInt).toInt))=_
  have signed : (BitVec.ofInt 64 input.toInt).toInt=input.toInt :=
    BitVec.toInt_ofInt_eq_self (w:=64) (n:=input.toInt) (by decide +kernel)
      (by have bound:=input.le_toInt; omega) (by have bound:=input.toInt_lt; omega)
  rw [signed,BitVec.ofInt_toInt]

/-- Every actual store of the bound source statement writes the SAME input
    int16 word, derived from its long subtraction and narrowing. -/
theorem store_source (args : Args) (s t : State) (flow : Flow) (n : Nat) (bound : n≤1536)
    (input : BitVec 16) (ptr atWord : ArrayPointer)
    (cursor : KeygenDecodeNoneRead.Cursor n s.locals) (held : s.locals.x=some ptr)
    (advance : PointerAdd ptr n atWord)
    (y : Cell "y" .int64 (.int64 (BitVec.ofInt 64 input.toInt)) s.locals)
    (source : Exec args KeygenDecodeNoneBinding.node031 s t flow) :
    Store16 s.heap atWord input t.heap ∧ t.locals=s.locals ∧ t.buf=s.buf ∧ flow=.normal := by
  cases source with
  | store s index rhs middle last actual atActual offset value after original indexValue nonnegative actualAdvance rhsValue write =>
    have samePtr := Option.some.inj (original.symm.trans held)
    subst actual
    have calculation : Computes args s.heap s.buf s.locals (.variable "u".toList)
        (.uint64 (BitVec.ofNat 64 n)) := .scalar _ _ _ (by unfold Ordinary; decide +kernel) cursor
    obtain ⟨same,lastIndex⟩ := computes_eval args s.heap s.buf s.locals _ _ calculation middle (.integer offset) indexValue
    have sameOffset := Value.integer.inj same
    subst offset; subst middle
    have address : (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 n)).integer.toNat=n := by
      rw [KeygenCodecNoneCursor.unsigned_nat64 n (by omega)]; rfl
    rw [address] at actualAdvance
    have sameAddress := pointer_unique _ _ _ _ actualAdvance advance
    subst atActual
    obtain ⟨same,lastValue⟩ := computes_eval args s.heap s.buf s.locals _ _ (narrow_calculation args s input y) last (.integer value) rhsValue
    have sameValue := Value.integer.inj same
    subst value; subst last
    have recovered : BitVec.ofInt 16 (C99IntegerReference.Value.int32 (BitVec.ofInt 32 input.toInt)).integer=input := by
      rw [C99IntegerReference.Value.integer,KeygenCodecStaticCountdown.signed_exact input.toInt
        (by have bound:=input.le_toInt; omega) (by have bound:=input.toInt_lt; omega),BitVec.ofInt_toInt]
    rw [recovered] at write
    exact ⟨write,rfl,rfl,rfl⟩

end FT1536.Source3.KeygenDecodeNoneSubtract
