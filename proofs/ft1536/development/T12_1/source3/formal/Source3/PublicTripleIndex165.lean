import Source3.PublicU32Locals165

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTripleIndex165
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value ArithmeticExec)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open PublicTailShape159 (cvar clit caddW)

theorem add_literal (i j : Nat) (leftBound : i < 2^64) (rightBound : j < 2^31) :
    ArithmeticExec .plus (u64 i) (C99IntegerReference.convert .int32 j) (u64 (i+j)) := by
  have conversion : u64 j=C99IntegerReference.convert .uint64
      (C99IntegerReference.convert .int32 j).integer := by
    rw [PublicTailFirst159.lit_integer j rightBound,KeygenNttLoopSupport.convert_u64_nat]
  have raw := ArithmeticExec.step .plus (u64 i) (C99IntegerReference.convert .int32 j) .uint64 rfl
    (u64 i) (u64 j) (C99CountedWords.convert_self (u64 i)).symm conversion
    (by intro impossible; cases impossible)
  change ArithmeticExec .plus (u64 i) (C99IntegerReference.convert .int32 j)
    (.uint64 (BitVec.ofInt 64 ((u64 i).integer+(u64 j).integer))) at raw
  rw [KeygenNttLoopSupport.u64_integer i leftBound,
    KeygenNttLoopSupport.u64_integer j (by omega)] at raw
  have sum : (i:Int)+(j:Int)=((i+j:Nat):Int) := by omega
  rw [sum,BitVec.ofInt_natCast] at raw
  exact raw

theorem address (s : State) (a : ArrayPointer) (u j : Nat)
    (sumBound : u+j < 2^64) (offsetBound : j < 2^31)
    (binding : s.arrays "a".toList=some a) (counter : USlot s "u" u)
    (capacity : a.index+(u+j) ≤ a.count) :
    KeygenPublicWord.Address s "a".toList (caddW "u" j) (element a (u+j)) :=
  .add _ _ a (element a (u+j)) (u64 (u+j)) binding
    (.arithmetic .plus _ _ _ _ _ (PublicGenerateIndex159.var_u64 s "u" u counter)
      (PublicGenerateIndex159.lit_i32 s j) (add_literal u j (by omega) offsetBound))
    (by rw [KeygenNttLoopSupport.u64_integer (u+j) sumBound]; omega)
    (by rw [KeygenNttLoopSupport.u64_toNat (u+j) sumBound]
        exact PublicGenerateIndex159.pointer_within a (u+j) capacity)

end FT1536.Source3.PublicTripleIndex165
