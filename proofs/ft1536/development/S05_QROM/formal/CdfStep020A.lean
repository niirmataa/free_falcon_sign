import CdfPrefix020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CdfStep020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A SearchBounds020A CdfPrefix020A

def choice : Code := .branch (lt (r 7) (r 12)) (set 9 (r 10))
  (seqs [set 8 (add (r 11) (lit 1)),set 9 (sub (sub (r 9) (r 10)) (lit 1))])
def body : Code := seqs (prefixList ++ [choice])

def next (cdf : Nat → Nat) (u lo len : Nat) : Nat × Nat :=
  if u<cdf (lo+len/2) then (lo,len/2) else (lo+len/2+1,len-len/2-1)

def RegFrame (s t : State) : Prop := ∀ k : Reg,
  k≠8 → k≠9 → k≠10 → k≠11 → k≠12 → k≠30 → t.reg k=s.reg k

theorem seqs_append (i : Input) (xs ys : List Code) (s : State) :
    exec i (seqs (xs++ys)) s=exec i (seqs ys) (exec i (seqs xs) s) := by
  induction xs generalizing s with
  | nil => simp only [List.nil_append,exec_seqs_nil]
  | cons a xs ih => simp only [List.cons_append,exec_seqs_cons,ih]

theorem body_run (i : Input) (cdf : Nat → Nat) (s : State) (lo len : Nat)
    (image : Image i cdf) (hlo : s.reg 8=nw lo) (hlen : s.reg 9=nw len)
    (hp : 0<len) (hbound : lo+len≤30721) :
    exec i body s=exec i choice (loaded s lo len cdf) := by
  rw [body,seqs_append,prefix_correct i cdf s lo len image hlo hlen hp hbound]
  simp only [exec_seqs_cons,exec_seqs_nil]

/-- Actual comparison and BOTH updates of the machine loop. -/
theorem body_correct (i : Input) (cdf : Nat → Nat) (s : State) (u lo len : Nat)
    (image : Image i cdf) (cdfWidth : ∀ k<30721, cdf k<2^400)
    (huWidth : u<2^384) (h7 : s.reg 7=nw u) (hlo : s.reg 8=nw lo) (hlen : s.reg 9=nw len)
    (hp : 0<len) (hbound : lo+len≤30721) :
    let t := exec i body s
    t.reg 8=nw (next cdf u lo len).1 ∧ t.reg 9=nw (next cdf u lo len).2 ∧
      Frame s t ∧ RegFrame s t := by
  have hi := (interval_step lo len hp hbound).1
  have hm := (interval_step lo len hp hbound).2.2.2
  have fu : Fits (u : Int) := nat_fits (lt_trans huWidth (by norm_num))
  have fc : Fits ((cdf (lo+len/2) : Nat) : Int) := nat_fits (cdfWidth _ hi)
  have fi : Fits ((lo+len/2 : Nat) : Int) := tiny_fits (by omega)
  have fl : Fits (len : Int) := tiny_fits (by omega)
  have fm : Fits ((len/2 : Nat) : Int) := tiny_fits (by omega)
  have fd : Fits ((len-len/2 : Nat) : Int) := tiny_fits (by omega)
  have f1 : Fits (1 : Int) := by norm_num [Fits]
  let q := loaded s lo len cdf
  have q7 : q.reg 7=nw u := by simp [q,loaded,put,h7]
  have q8 : q.reg 8=nw lo := by simp [q,loaded,put,hlo]
  have q9 : q.reg 9=nw len := by simp [q,loaded,put,hlen]
  have q10 : q.reg 10=nw (len/2) := by simp [q,loaded,put]
  have q11 : q.reg 11=nw (lo+len/2) := by simp [q,loaded,put]
  have q12 : q.reg 12=nw (cdf (lo+len/2)) := by simp [q,loaded,put]
  have cmp : eval q (lt (r 7) (r 12))=word (if (u : Int)<(cdf (lo+len/2) : Int) then 1 else 0) := by
    change op .lt (q.reg 7) (q.reg 12)=_
    rw [q7,q12]
    exact lt_word _ _ fu fc
  have eql : exec i (set 9 (r 10)) q=put q 9 (nw (len/2)) := by
    rw [exec_set];change put q 9 (q.reg 10)=_;rw [q10]
  have eqr : exec i (seqs [set 8 (add (r 11) (lit 1)),set 9 (sub (sub (r 9) (r 10)) (lit 1))]) q=
      put (put q 8 (nw (lo+len/2+1))) 9 (nw (len-len/2-1)) := by
    have ea : eval q (add (r 11) (lit 1))=nw (lo+len/2+1) := by
      change op .add (q.reg 11) (word 1)=_
      rw [q11]
      exact add_word _ _ fi f1
    let q' := put q 8 (nw (lo+len/2+1))
    have ed : eval q' (sub (sub (r 9) (r 10)) (lit 1))=nw (len-len/2-1) := by
      change op .sub (op .sub (q'.reg 9) (q'.reg 10)) (word 1)=_
      dsimp [q']
      rw [put_other _ 8 9 _ (by decide),put_other _ 8 10 _ (by decide),q9,q10,
        sub_word _ _ fl fm]
      have hd : (len : Int)-(len/2 : Nat)=((len-len/2 : Nat) : Int) := by omega
      rw [hd,sub_word _ _ fd f1]
      have hd' : ((len-len/2 : Nat) : Int)-1=((len-len/2-1 : Nat) : Int) := by omega
      rw [hd']
    simp only [exec_seqs_cons,exec_seqs_nil,exec_set,ea]
    exact congrArg (put q' 9) ed
  dsimp only
  rw [body_run i cdf s lo len image hlo hlen hp hbound]
  change let t := exec i choice q; _
  unfold choice
  rw [exec_branch,cmp]
  by_cases hu : u<cdf (lo+len/2)
  · have hu' : (u : Int)<(cdf (lo+len/2) : Int) := by exact_mod_cast hu
    rw [ite_eq_left hu',ite_eq_right (show word 1≠0 by decide),eql]
    refine ⟨?_,?_,⟨rfl,rfl,rfl⟩,?_⟩
    · simpa [next,hu,put] using q8
    · simp [next,hu,put]
    · intro k _hk8 hk9 hk10 hk11 hk12 hk30
      simp [q,loaded,put,Function.update,hk9,hk10,hk11,hk12,hk30]
  · have hu' : ¬(u : Int)<(cdf (lo+len/2) : Int) := by exact_mod_cast hu
    rw [ite_eq_right hu',ite_eq_left (show word 0=0 by rfl),eqr]
    refine ⟨?_,?_,⟨rfl,rfl,rfl⟩,?_⟩
    · simp [next,hu,put]
    · simp [next,hu,put]
    · intro k hk8 hk9 hk10 hk11 hk12 hk30
      simp [q,loaded,put,Function.update,hk8,hk9,hk10,hk11,hk12,hk30]

end FT1536.S05.CdfStep020A
