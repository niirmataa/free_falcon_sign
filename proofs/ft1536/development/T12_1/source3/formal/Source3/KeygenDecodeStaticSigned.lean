import Source3.KeygenDecodeWordOps
import Source3.KeygenDecodeStaticAssignments

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The source casts lo to int16 BEFORE unary minus, then stores int16.
   The endpoint -32768 is valid: promoted negation is in int32. -/
namespace FT1536.Source3.KeygenDecodeStaticSigned
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeCalculation C99MemoryReference
open C99IntegerReference (NegExec)

abbrev IV := C99IntegerReference.Value
def narrow (word : BitVec 16) : IV := .int32 (BitVec.ofInt 32 word.toInt)
def negated (word : BitVec 16) : IV := .int32 (BitVec.ofInt 32 (-word.toInt))

theorem narrow_integer (word : BitVec 16) : (narrow word).integer=word.toInt := by
  change (BitVec.ofInt 32 word.toInt).toInt=word.toInt
  exact BitVec.toInt_ofInt_eq_self (by decide +kernel)
    (by have bound:=word.le_toInt; omega) (by have bound:=word.toInt_lt; omega)

theorem negated_integer (word : BitVec 16) : (negated word).integer= -word.toInt := by
  change (BitVec.ofInt 32 (-word.toInt)).toInt= -word.toInt
  exact BitVec.toInt_ofInt_eq_self (by decide +kernel)
    (by have bound:=word.toInt_lt; omega) (by have bound:=word.le_toInt; omega)

theorem negate_defined (word : BitVec 16) : NegExec (narrow word) (negated word) := by
  have source := NegExec.step (narrow word) (by
    intro _
    change -(2^(32-1) : Int)≤ -(narrow word).integer ∧ -(narrow word).integer<2^(32-1)
    rw [narrow_integer]
    have lower:=word.le_toInt
    have upper:=word.toInt_lt
    constructor <;> omega)
  change NegExec (narrow word) (.int32 (BitVec.ofInt 32 (-(narrow word).integer))) at source
  rw [narrow_integer] at source
  exact source

theorem cast_magnitude (m : Nat) (bound : m≤32768) :
    castInteger .i16 (.uint32 (BitVec.ofNat 32 m))=some (narrow (BitVec.ofNat 16 m)) := by
  have less : m<2^32 := by omega
  simp only [castInteger,C99IntegerReference.Value.integer,BitVec.toNat_ofNat,Nat.mod_eq_of_lt less,
    BitVec.ofInt_natCast,narrow]

theorem positive_store (word : BitVec 16) : BitVec.ofInt 16 (narrow word).integer=word := by
  rw [narrow_integer,BitVec.ofInt_toInt]

theorem negative_store (word : BitVec 16) : BitVec.ofInt 16 (negated word).integer= -word := by
  rw [negated_integer,BitVec.ofInt_neg,BitVec.ofInt_toInt]

theorem positive_calculation (args : Args) (s : State) (m : Nat) (bound : m≤32768)
    (lo : s.locals.scalars "lo".toList=some (.uint32,some (.uint32 (BitVec.ofNat 32 m)))) :
    Computes args s.heap s.buf s.locals (.cast .i16 (.variable "lo".toList)) (narrow (BitVec.ofNat 16 m)) :=
  .cast _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) lo) (cast_magnitude m bound)

theorem negative_calculation (args : Args) (s : State) (m : Nat) (bound : m≤32768)
    (lo : s.locals.scalars "lo".toList=some (.uint32,some (.uint32 (BitVec.ofNat 32 m)))) :
    Computes args s.heap s.buf s.locals (.unary .neg (.cast .i16 (.variable "lo".toList)))
      (negated (BitVec.ofNat 16 m)) :=
  .unary _ _ _ _ (positive_calculation args s m bound lo) (.neg _ _ (negate_defined _))

end FT1536.Source3.KeygenDecodeStaticSigned
