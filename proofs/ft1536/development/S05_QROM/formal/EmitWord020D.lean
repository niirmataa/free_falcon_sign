import EmitStep020D
import CapCore020B
import Run2.WordEncoding

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.EmitWord020D
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020 ScalarExpr020D
open CapCore020B EmitStep020D
open FT1536.Run2.BitArithmetic (encodeNat encodeNat_length)
attribute [local irreducible] exec loopState

def RegFrame (s t : State) : Prop := ∀ rr : Reg, rr≠4 → rr≠28 → rr≠30 → t.reg rr=s.reg rr

theorem guard_positive (s : State) (n : Nat) (hn : n<384)
    (h4 : s.reg 4=word ((n+1:Nat):Int)) : eval s (nz 4)≠0 := by
  change op .lt (word 0) (s.reg 4)≠0
  rw [h4,lt_word (0:Int) ((n+1:Nat):Int) (show Fits (0:Int) from small_nat 0 (by decide))
    (small_nat (n+1) (by omega))]
  rw [ite_eq_left (by omega)]
  decide

theorem loop_correct (i : Input) (n b a : Nat) (s : State)
    (hn : n≤384) (hb : b+n≤outputSize) (ha : a<2^n)
    (h4 : s.reg 4=word (n:Int)) (h28 : s.reg 28=word (b:Int)) (h30 : s.reg 30=word (a:Int)) :
    let t := loopState (exec i body) (nz 4) n s
    t.reg 4=word 0 ∧ t.reg 30=word 0 ∧ t.reg 28=word ((b+n:Nat):Int) ∧
      t.out=OutputSlice020D.write s.out b (encodeNat a n) ∧ t.ram=s.ram ∧ t.fault=s.fault ∧ RegFrame s t := by
  induction n generalizing b a s with
  | zero =>
    have hz : a=0 := by simpa using ha
    subst a
    dsimp only
    rw [loop_zero]
    refine ⟨h4,h30,h28,?_,rfl,rfl,fun _ _ _ _ => rfl⟩
    rw [encodeNat,OutputSlice020D.write_nil]
  | succ n ih =>
    have bn : b<outputSize := by omega
    have aa : a<2^384 := lt_of_lt_of_le ha (Nat.pow_le_pow_right (by decide) hn)
    have half : a/2<2^n := by rw [pow_succ] at ha;omega
    let q := result s ⟨b,bn⟩ a n
    have st := body_correct i s ⟨b,bn⟩ a n aa (by omega) h28 h30 h4
    have post := ih (b:=b+1) (a:=a/2) (s:=q) (by omega) (by omega) half
      (result_remaining _ _ _ _) (result_cursor _ _ _ _) (result_value _ _ _ _)
    dsimp only
    rw [loop_succ,ite_eq_right (guard_positive s n (by omega) h4),st]
    refine ⟨post.1,post.2.1,?_,?_,post.2.2.2.2.1.trans (result_frame _ _ _ _).1,
      post.2.2.2.2.2.1.trans (result_frame _ _ _ _).2,?_⟩
    · have he : (b+1)+n=b+(n+1) := by omega
      exact post.2.2.1.trans (congrArg (fun k : Nat => word (k:Int)) he)
    · rw [post.2.2.2.1]
      change OutputSlice020D.write (Function.update s.out ⟨b,bn⟩ (decide (a%2=1))) (b+1)
        (encodeNat (a/2) n)=OutputSlice020D.write s.out b (encodeNat a (n+1))
      rw [OutputSlice020D.write_cons _ _ _ _ (by rw [encodeNat_length];omega)]
      rfl
    · intro rr hr4 hr28 hr30
      exact (post.2.2.2.2.2.2 rr hr4 hr28 hr30).trans (result_other _ _ _ _ rr hr4 hr28 hr30)

theorem code_shape (i : Input) (s : State) (n : Nat) :
    exec i (emitWord n) s=loopState (exec i body) (nz 4) n (put s 4 (word (n:Int))) := by
  simp only [emitWord,exec_seqs_cons,exec_seqs_nil,exec_set,exec_loop]
  rfl

theorem emitWord_correct (i : Input) (s : State) (n b a : Nat)
    (hn : n≤384) (hb : b+n≤outputSize) (ha : a<2^n)
    (h28 : s.reg 28=word (b:Int)) (h30 : s.reg 30=word (a:Int)) :
    let t := exec i (emitWord n) s
    t.reg 4=word 0 ∧ t.reg 30=word 0 ∧ t.reg 28=word ((b+n:Nat):Int) ∧
      t.out=OutputSlice020D.write s.out b (encodeNat a n) ∧ t.ram=s.ram ∧ t.fault=s.fault ∧ RegFrame s t := by
  let q := put s 4 (word (n:Int))
  have q28 : q.reg 28=word (b:Int) := (put_other s 4 28 _ (by decide)).trans h28
  have q30 : q.reg 30=word (a:Int) := (put_other s 4 30 _ (by decide)).trans h30
  have post := loop_correct i n b a q hn hb ha (put_same _ _ _) q28 q30
  dsimp only
  rw [code_shape]
  refine ⟨post.1,post.2.1,post.2.2.1,post.2.2.2.1,post.2.2.2.2.1,post.2.2.2.2.2.1,?_⟩
  intro rr h4 _ _
  exact (post.2.2.2.2.2.2 rr h4 (by assumption) (by assumption)).trans (put_other s 4 rr _ h4)

end FT1536.S05.EmitWord020D
