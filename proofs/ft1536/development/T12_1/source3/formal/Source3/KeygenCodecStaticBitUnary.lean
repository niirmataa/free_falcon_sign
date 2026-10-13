import Source3.KeygenCodecStaticBitBuffer

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticBitUnary
open KeygenCodecStaticBits KeygenCodecStaticBitBuffer

def unary : Nat → List Bool
  | 0 => []
  | n+1 => (decide (n=0))::unary n

theorem unary_length (n : Nat) : (unary n).length=n := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [unary,List.length_cons,ih]

theorem unary_positive (n : Nat) : unary (n+1)=List.replicate n false++[true] := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [unary,show ¬n+1=0 by omega,decide_false,List.replicate_succ,List.cons_append]
    change false::unary (n+1)=_
    rw [ih]

theorem append_bit (p : Nat) (word : BitVec 32) (b : Bool) (width : p+1≤32) :
    buffer (p+1) ((word <<< 1)+(if b then 1 else 0))=buffer p word++[b] := by
  apply value_injective
  · simp only [buffer_length,List.length_append,List.length_cons,List.length_nil]
  · rw [buffer_value,value_append]
    have append := KeygenCodecStaticUnaryAppend.low_append word (if b then 1 else 0) p width
      (by cases b <;> decide +kernel)
    rw [append,buffer_value]
    cases b <;> simp only [Bool.false_eq_true,ite_false,ite_true,show (0 : BitVec 32).toNat=0 from rfl,
      show (1 : BitVec 32).toNat=1 from rfl,List.length_cons,List.length_nil,value,Bool.toNat_false,Bool.toNat_true,Nat.zero_mul,Nat.zero_add,Nat.one_mul,pow_one]
    all_goals rfl

theorem unary_history (n p : Nat) (word : BitVec 32) (small : p<8) :
    bytesBits (KeygenCodecStaticUnaryHistory.bytes n p word)++
      buffer (KeygenCodecStaticUnaryInvariant.finish n p word).1
        (KeygenCodecStaticUnaryInvariant.finish n p word).2=
      buffer p word++unary n := by
  induction n generalizing p word with
  | zero => simp only [KeygenCodecStaticUnaryHistory.bytes,bytesBits,List.flatMap_nil,List.nil_append,
      KeygenCodecStaticUnaryInvariant.finish,unary,List.append_nil]
  | succ n ih =>
    let b : Bool := decide (n=0)
    let next : BitVec 32 := (word <<< 1)+(if n=0 then 1 else 0)
    have bitSame : next=(word <<< 1)+(if b then 1 else 0) := by simp only [next,b,decide_eq_true_eq]
    have tail := ih ((p+1)%8) next (Nat.mod_lt _ (by decide +kernel))
    have joined : bytesBits (if p=7 then [KeygenCodecStaticByte.byte next] else [])++
        buffer ((p+1)%8) next=buffer p word++[b] := by
      by_cases full : p=7
      · subst p
        simp only [ite_true,bytesBits,List.flatMap_cons,List.flatMap_nil,List.append_nil,
          buffer,digits]
        change digits 8 (KeygenCodecStaticByte.byte next).toNat=buffer 7 word++[b]
        have sameByte : digits 8 (KeygenCodecStaticByte.byte next).toNat=buffer 8 next := by
          apply value_injective
          · simp only [digits_length,buffer_length]
          · rw [digits_value,buffer_value]
            simp only [KeygenCodecStaticByte.byte,KeygenCodecStaticSuffix.low,BitVec.toNat_ofNat,Nat.mod_mod]
        rw [sameByte,bitSame]
        exact append_bit 7 word b (by decide +kernel)
      · have remainder : (p+1)%8=p+1 := Nat.mod_eq_of_lt (by omega)
        simp only [full,ite_false,bytesBits,List.flatMap_nil,List.nil_append,remainder]
        rw [bitSame]
        exact append_bit p word b (by omega)
    simp only [KeygenCodecStaticUnaryHistory.bytes,KeygenCodecStaticUnaryInvariant.finish]
    change bytesBits ((if p=7 then [KeygenCodecStaticByte.byte next] else [])++
      KeygenCodecStaticUnaryHistory.bytes n ((p+1)%8) next)++_= _
    rw [show bytesBits ((if p=7 then [KeygenCodecStaticByte.byte next] else [])++
      KeygenCodecStaticUnaryHistory.bytes n ((p+1)%8) next)=
      bytesBits (if p=7 then [KeygenCodecStaticByte.byte next] else [])++
      bytesBits (KeygenCodecStaticUnaryHistory.bytes n ((p+1)%8) next) by
        exact List.flatMap_append]
    rw [List.append_assoc,tail,←List.append_assoc,joined,List.append_assoc]
    rfl

end FT1536.Source3.KeygenCodecStaticBitUnary
