import ProducerWordLaws020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerBoolLaws020E6
open WordRAM020 WordCodec020E5 ProducerScalar020E6

theorem bool_zero (b : Bool) : boolWord b=0 ↔ b=false := by cases b <;> decide +kernel

theorem choose_word (b : Bool) (yes no : Word) : (if boolWord b=0 then no else yes)=if b then yes else no := by
  cases b <;> rfl

theorem eq_word (x y : Word) : WordRAM020.op .eq x y=boolWord (decide (x=y)) := by
  change word (if x=y then 1 else 0)=(if decide (x=y) then (1 : Word) else 0)
  by_cases h : x=y
  · simp only [h,ite_true,decide_true];rfl
  · simp only [h,ite_false,decide_false];rfl

theorem not_word (b : Bool) : WordRAM020.op .eq (boolWord b) 0=boolWord (!b) := by
  cases b <;> rfl

theorem and_word (a b : Bool) : (if boolWord a=0 then (0 : Word) else boolWord b)=boolWord (a && b) := by
  cases a <;> cases b <;> rfl

theorem or_word (a b : Bool) : (if boolWord a=0 then boolWord b else (1 : Word))=boolWord (a || b) := by
  cases a <;> cases b <;> rfl

end FT1536.S05.ProducerBoolLaws020E6
