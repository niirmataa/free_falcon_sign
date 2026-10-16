import Source3.PublicLeafSource157
import Source3.KeygenPublicArguments

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicArgumentSource157
open B20.C (Val)
open C99ValueBridge (value)
open KeygenPublicArguments (Conversion)

def word (v : Val) : BitVec 32 := BitVec.ofInt 32 v.integer
theorem unsigned (v : Val) : C99IntegerReference.convert .uint32 (value v).integer=.uint32 (word v) := by
  rw [C99ValueBridge.integer_matches]
  rfl
theorem signed (v : Val) : C99IntegerReference.convert .int32 (value v).integer=.int32 (word v) := by
  rw [C99ValueBridge.integer_matches]
  rfl

theorem cons_unsigned (name : C99ArrayReference.Name) (v : Val) (ps : List (C99IntegerReference.Ty×C99ArrayReference.Name))
    (xs ys : List C99IntegerReference.Value) (rest : Conversion ps xs ys) :
    Conversion ((.uint32,name)::ps) (.uint32 (word v)::xs) (value v::ys) :=
  .cons _ _ _ _ _ _ _ ((C99CountedWords.convert_self (.uint32 (word v))).trans (unsigned v).symm) rest
theorem cons_signed (name : C99ArrayReference.Name) (v : Val) (ps : List (C99IntegerReference.Ty×C99ArrayReference.Name))
    (xs ys : List C99IntegerReference.Value) (rest : Conversion ps xs ys) :
    Conversion ((.int32,name)::ps) (.int32 (word v)::xs) (value v::ys) :=
  .cons _ _ _ _ _ _ _ ((C99CountedWords.convert_self (.int32 (word v))).trans (signed v).symm) rest

theorem add (a b q : Val) : KeygenPublicScalar.Call "mq_add".toList [value a,value b,value q]
    (.uint32 (KeygenModpAddSub.result .add (word a) (word b) (word q))) :=
  KeygenPublicArguments.call_leaf_conversion .add (by decide) _ _ _
    (cons_unsigned _ a _ _ _ (cons_unsigned _ b _ _ _ (cons_unsigned _ q _ _ _ .nil)))
    (PublicLeafSource157.add (word a) (word b) (word q))
theorem sub (a b q : Val) : KeygenPublicScalar.Call "mq_sub".toList [value a,value b,value q]
    (.uint32 (KeygenModpAddSub.result .sub (word a) (word b) (word q))) :=
  KeygenPublicArguments.call_leaf_conversion .sub (by decide) _ _ _
    (cons_unsigned _ a _ _ _ (cons_unsigned _ b _ _ _ (cons_unsigned _ q _ _ _ .nil)))
    (PublicLeafSource157.sub (word a) (word b) (word q))
theorem mul (a b q qi : Val) : KeygenPublicScalar.Call "mq_montymul".toList [value a,value b,value q,value qi]
    (.uint32 (KeygenPublicLeafWords.montgomery (word a) (word b) (word q) (word qi))) :=
  KeygenPublicArguments.call_leaf_conversion .mul (by decide) _ _ _
    (cons_unsigned _ a _ _ _ (cons_unsigned _ b _ _ _ (cons_unsigned _ q _ _ _ (cons_unsigned _ qi _ _ _ .nil))))
    (PublicLeafSource157.mul (word a) (word b) (word q) (word qi))
theorem conv (x q : Val) : KeygenPublicScalar.Call "mq_conv_small".toList [value x,value q]
    (.uint32 (KeygenModpSet.word (word x) (word q))) :=
  KeygenPublicArguments.call_leaf_conversion .conv (by decide) _ _ _
    (cons_signed _ x _ _ _ (cons_unsigned _ q _ _ _ .nil)) (PublicLeafSource157.conv (word x) (word q))
theorem half (x q : Val) : KeygenPublicScalar.Call "mq_rshift1".toList [value x,value q]
    (.uint32 (KeygenPublicLeafWords.half (word x) (word q))) :=
  KeygenPublicArguments.call_leaf_conversion .half (by decide) _ _ _
    (cons_unsigned _ x _ _ _ (cons_unsigned _ q _ _ _ .nil)) (PublicLeafSource157.half (word x) (word q))

end FT1536.Source3.PublicArgumentSource157
