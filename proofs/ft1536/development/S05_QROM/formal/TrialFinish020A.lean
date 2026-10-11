import TrialRead020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.TrialFinish020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A CdfPrefix020A
open FT1536.Relation JointInterface019
attribute [local irreducible] TableData016.threshold

def threshold (x y : Fin 30721) : Nat := StandaloneRuntime019.tables.threshold
  ⟨x.val+y.val,by have := x.isLt; have := y.isLt; omega⟩

def acceptCode : Code := .branch (lt (r 7) (r 12))
  (seqs [set 15 (lit 1),set 13 (sub (r 13) (lit 15360)),set 14 (sub (r 14) (lit 15360))]) skip

def finishCode : Code := seqs [loadROM 12 (add (lit 30721) (add (r 13) (r 14))),acceptCode,inc 2]

def finishState (s : State) (x y : Fin 30721) (u k : Nat) : State :=
  let q := put s 12 (nw (threshold x y))
  let t := if u<threshold x y then
    put (put (put q 15 (word 1)) 13 (word ((x.val : Int)-15360))) 14 (word ((y.val : Int)-15360)) else q
  put t 2 (nw (k+1))

theorem actual_threshold_image (h : Rq) (tape : Bits tapeSize) (x y : Fin 30721) :
    (InputLayout020.encode h tape).rom ⟨30721+x.val+y.val,by have := x.isLt; have := y.isLt; simp only [romSize]; omega⟩=
      nw (threshold x y) := by
  have hx := x.isLt; have hy := y.isLt
  change InputLayout020.image h _=_
  unfold InputLayout020.image
  rw [dite_eq_right (show ¬30721+x.val+y.val<30721 by omega),
    dite_eq_left (show 30721+x.val+y.val<92162 by omega)]
  change nw (StandaloneRuntime019.tables.threshold ⟨30721+x.val+y.val-30721,by omega⟩)=
    nw (StandaloneRuntime019.tables.threshold ⟨x.val+y.val,by omega⟩)
  apply congrArg (fun j : Fin 61441 => nw (StandaloneRuntime019.tables.threshold j))
  apply Fin.ext
  change 30721+x.val+y.val-30721=x.val+y.val
  omega

theorem threshold_fits (x y : Fin 30721) : Fits ((threshold x y : Nat) : Int) := by
  apply nat_fits
  have hh := WordBounds018.threshold_width (⟨x.val+y.val,by have := x.isLt; have := y.isLt; omega⟩ : SamplerCode016.PairIndex)
  exact lt_trans hh (by norm_num)

/-- The actual final table load, comparison, accepted signed coordinates and
    retry-counter increment. No acceptance outcome is supplied as a premise. -/
theorem finish_correct (h : Rq) (tape : Bits tapeSize) (s : State) (x y : Fin 30721) (u k : Nat)
    (hu : u<2^256) (hk : k<80) (h13 : s.reg 13=nw x.val) (h14 : s.reg 14=nw y.val)
    (h7 : s.reg 7=nw u) (h2 : s.reg 2=nw k) :
    exec (InputLayout020.encode h tape) finishCode s=finishState s x y u k := by
  let i := InputLayout020.encode h tape
  have hx := x.isLt;have hy := y.isLt
  have fx : Fits (x.val : Int) := tiny_fits (by omega)
  have fy : Fits (y.val : Int) := tiny_fits (by omega)
  have fxy : Fits ((x.val+y.val : Nat) : Int) := tiny_fits (by omega)
  have f30721 : Fits (30721 : Int) := by norm_num [Fits]
  have f15360 : Fits (15360 : Int) := by norm_num [Fits]
  have fu : Fits (u : Int) := nat_fits (lt_trans hu (by norm_num))
  have fk : Fits (k : Int) := tiny_fits (by omega)
  have adr : eval s (add (lit 30721) (add (r 13) (r 14)))=nw (30721+x.val+y.val) := by
    change op .add (word 30721) (op .add (s.reg 13) (s.reg 14))=_
    rw [h13,h14,add_word _ _ fx fy]
    change op .add (word 30721) (nw (x.val+y.val))=_
    rw [add_word _ _ f30721 fxy]
    congr 1
    push_cast
    ring
  let q := put s 12 (nw (threshold x y))
  have ld : exec i (loadROM 12 (add (lit 30721) (add (r 13) (r 14)))) s=q := by
    rw [exec_rom,adr]
    have ha : 30721+x.val+y.val<romSize := by simp only [romSize];omega
    have hw : ((30721+x.val+y.val : Nat) : Int)<2^511 := (tiny_fits (n:=30721+x.val+y.val) (by omega)).2
    rw [address_exact _ _ ha hw]
    change put s 12 (i.rom ⟨30721+x.val+y.val,ha⟩)=_
    exact congrArg (put s 12) (actual_threshold_image h tape x y)
  have q2 : q.reg 2=nw k := by dsimp [q];rw [put_other _ 12 2 _ (by decide),h2]
  have q7 : q.reg 7=nw u := by dsimp [q];rw [put_other _ 12 7 _ (by decide),h7]
  have q13 : q.reg 13=nw x.val := by dsimp [q];rw [put_other _ 12 13 _ (by decide),h13]
  have q14 : q.reg 14=nw y.val := by dsimp [q];rw [put_other _ 12 14 _ (by decide),h14]
  have cmp : eval q (lt (r 7) (r 12))=word (if (u : Int)<(threshold x y : Int) then 1 else 0) := by
    change op .lt (q.reg 7) (q.reg 12)=_
    rw [q7,put_same]
    exact lt_word _ _ fu (threshold_fits x y)
  let yes := put (put (put q 15 (word 1)) 13 (word ((x.val : Int)-15360))) 14 (word ((y.val : Int)-15360))
  have ey : exec i (seqs [set 15 (lit 1),set 13 (sub (r 13) (lit 15360)),set 14 (sub (r 14) (lit 15360))]) q=yes := by
    have ex : eval (put q 15 (word 1)) (sub (r 13) (lit 15360))=word ((x.val : Int)-15360) := by
      change op .sub ((put q 15 (word 1)).reg 13) (word 15360)=_
      rw [put_other _ 15 13 _ (by decide),q13]
      exact sub_word _ _ fx f15360
    have ey' : eval (put (put q 15 (word 1)) 13 (word ((x.val : Int)-15360))) (sub (r 14) (lit 15360))=
        word ((y.val : Int)-15360) := by
      change op .sub ((put (put q 15 (word 1)) 13 (word ((x.val : Int)-15360))).reg 14) (word 15360)=_
      rw [put_other _ 13 14 _ (by decide),put_other _ 15 14 _ (by decide),q14]
      exact sub_word _ _ fy f15360
    have eflag : eval q (lit 1)=word 1 := rfl
    simp only [exec_seqs_cons,exec_seqs_nil,exec_set,eflag,ex,ey']
    rfl
  have nextCounter (t : State) (ht : t.reg 2=nw k) : exec i (inc 2) t=put t 2 (nw (k+1)) := by
    rw [inc,exec_set]
    change put t 2 (op .add (t.reg 2) (word 1))=_
    rw [ht,add_word _ _ fk (by norm_num [Fits])]
    rfl
  simp only [finishCode,exec_seqs_cons,exec_seqs_nil]
  rw [ld]
  unfold acceptCode
  rw [exec_branch,cmp]
  by_cases hc : u<threshold x y
  · have hc' : (u : Int)<(threshold x y : Int) := by exact_mod_cast hc
    rw [ite_eq_left hc',ite_eq_right (show word 1≠0 by decide),ey,nextCounter yes (by simp [yes,put,q2])]
    simp only [finishState,ite_eq_left hc]
    rfl
  · have hc' : ¬(u : Int)<(threshold x y : Int) := by exact_mod_cast hc
    rw [ite_eq_right hc',ite_eq_left (show word 0=0 by rfl),exec_skip,nextCounter q q2]
    simp only [finishState,ite_eq_right hc]
    rfl

end FT1536.S05.TrialFinish020A
