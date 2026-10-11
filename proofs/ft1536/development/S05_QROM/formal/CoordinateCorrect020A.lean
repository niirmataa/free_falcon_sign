import CdfLoop020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CoordinateCorrect020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A ReadWordCorrect020A CdfPrefix020A
attribute [local irreducible] loopState StandaloneRuntime019.search

def result (i : Input) (cdf : Nat → Nat) (b : Nat) : Nat :=
  min (StandaloneRuntime019.search cdf (value (tapeBits i) 384 b % cdf 30720) 15 0 30721).1 30720

def clamp (dst : Reg) : Code :=
  .branch (lt (r 8) (lit 30721)) (set dst (r 8)) (set dst (lit 30720))

theorem program_shape (dst : Reg) (base : Expr) :
    coordinate dst base=seqs [readWord 7 base 384,loadROM 12 (lit 30720),
      set 7 (mod (r 7) (r 12)),set 8 (lit 0),set 9 (lit 30721),
      .loop 15 (nz 9) CdfStep020A.body,clamp dst] := rfl

theorem clamp_correct (i : Input) (s : State) (dst : Reg) (v : Nat)
    (hv : v≤30721) (h8 : s.reg 8=nw v) : exec i (clamp dst) s=put s dst (nw (min v 30720)) := by
  have ev : eval s (lt (r 8) (lit 30721))=word (if (v : Int)<30721 then 1 else 0) := by
    change op .lt (s.reg 8) (word 30721)=_
    rw [h8]
    exact lt_word _ _ (tiny_fits (by omega)) (by norm_num [Fits])
  unfold clamp
  rw [exec_branch,ev]
  by_cases h : v<30721
  · have h' : (v : Int)<30721 := by exact_mod_cast h
    rw [ite_eq_left h',ite_eq_right (show word 1≠0 by decide),exec_set]
    change put s dst (s.reg 8)=_
    rw [h8,Nat.min_eq_left (by omega)]
  · have h' : ¬(v : Int)<30721 := by exact_mod_cast h
    rw [ite_eq_right h',ite_eq_left (show word 0=0 by rfl),exec_set]
    rw [Nat.min_eq_right (by omega)]
    rfl

theorem outside_ne (k j : Reg) (hk : k.val<4 ∨ 12<k.val) (hj : 4≤j.val ∧ j.val≤12) : k≠j := by
  intro he
  subst j
  omega

/-- Whole coordinate routine, including actual bit read, terminal-CDF load,
    modulo, binary search and final clamp, with the real register footprint. -/
theorem coordinate_correct (i : Input) (cdf : Nat → Nat) (s : State) (dst : Reg) (base : Expr) (b : Nat)
    (image : Image i cdf) (cdfWidth : ∀ k<30721, cdf k<2^400)
    (ha : b+384≤tapeSize) (hb : eval s base=nw b)
    (hb4 : (4 : Reg) ∉ reads base) (hb5 : (5 : Reg) ∉ reads base) (hb6 : (6 : Reg) ∉ reads base) :
    let t := exec i (coordinate dst base) s
    t.reg dst=nw (result i cdf b) ∧ Frame s t ∧
      ∀ k : Reg, (k.val<4 ∨ 12<k.val) → k≠30 → k≠dst → t.reg k=s.reg k := by
  let v := value (tapeBits i) 384 b
  let u := v % cdf 30720
  have vu : v<2^384 := value_lt _ _ _
  have uu : u<2^384 := lt_of_le_of_lt (Nat.mod_le _ _) vu
  let s1 := exec i (readWord 7 base 384) s
  have rd := readWord_correct i s 7 base b 384 (by decide) ha hb4 hb5 hb6 hb
  have h17 : s1.reg 7=nw v := rd.1
  let s2 := put s1 12 (nw (cdf 30720))
  have ld : exec i (loadROM 12 (lit 30720)) s1=s2 := by
    rw [exec_rom]
    change (match address romSize (word 30720) with
      | none => fail s1 | some k => put s1 12 (i.rom k))=_
    have ax : address romSize (word 30720)=some (⟨30720,by decide⟩ : Fin romSize) := by
      convert address_exact romSize 30720 (by decide) (by norm_num) using 1
    rw [ax]
    change put s1 12 (i.rom ⟨30720,by decide⟩)=_
    exact congrArg (put s1 12) (image ⟨30720,by decide⟩)
  have emod : eval s2 (mod (r 7) (r 12))=nw u := by
    change op .mod (s2.reg 7) (s2.reg 12)=_
    dsimp [s2]
    rw [put_other _ 12 7 _ (by decide),put_same,h17,mod_word _ _
      (nat_fits (lt_trans vu (by norm_num))) (nat_fits (cdfWidth _ (by decide)))]
    rfl
  let s3 := put s2 7 (nw u)
  let s4 := put s3 8 (nw 0)
  let s5 := put s4 9 (nw 30721)
  have h57 : s5.reg 7=nw u := by
    dsimp [s5,s4,s3]
    rw [put_other _ 9 7 _ (by decide),put_other _ 8 7 _ (by decide),put_same]
  have h58 : s5.reg 8=nw 0 := by dsimp [s5,s4];rw [put_other _ 9 8 _ (by decide),put_same]
  have h59 : s5.reg 9=nw 30721 := put_same _ _ _
  let st := loopState (exec i CdfStep020A.body) (nz 9) 15 s5
  have lp := CdfLoop020A.loop_correct i cdf u 15 0 30721 s5 image cdfWidth uu h57 h58 h59 (by decide)
  have st8 : st.reg 8=nw (StandaloneRuntime019.search cdf u 15 0 30721).1 := lp.1
  have cl : exec i (clamp dst) st=put st dst (nw (result i cdf b)) :=
    clamp_correct i st dst _ (SearchBounds020A.initial_search_bound cdf u 15) st8
  have hex : exec i (coordinate dst base) s=put st dst (nw (result i cdf b)) := by
    rw [program_shape]
    simp only [exec_seqs_cons,exec_seqs_nil]
    change exec i (clamp dst) (exec i (.loop 15 (nz 9) CdfStep020A.body)
      (exec i (set 9 (lit 30721)) (exec i (set 8 (lit 0))
        (exec i (set 7 (mod (r 7) (r 12))) (exec i (loadROM 12 (lit 30720)) s1)))))=_
    rw [ld]
    simp only [exec_set,emod,lit,eval_lit,exec_loop]
    exact cl
  dsimp only
  rw [hex]
  refine ⟨put_same _ _ _,?_,?_⟩
  · have initFrame : Frame s1 s5 :=
      frame_trans (frame_put s1 12 _) (frame_trans (frame_put s2 7 _)
        (frame_trans (frame_put s3 8 _) (frame_put s4 9 _)))
    exact frame_trans rd.2.1 (frame_trans initFrame (frame_trans lp.2.1 (frame_put st dst _)))
  · intro k hk hk30 hkd
    have kn (j : Reg) (hj : 4≤j.val ∧ j.val≤12) : k≠j := outside_ne k j hk hj
    rw [put_other _ dst k _ hkd,lp.2.2 k (kn 8 (by decide)) (kn 9 (by decide))
      (kn 10 (by decide)) (kn 11 (by decide)) (kn 12 (by decide)) hk30]
    dsimp [s5,s4,s3,s2]
    rw [put_other _ 9 k _ (kn 9 (by decide)),put_other _ 8 k _ (kn 8 (by decide)),
      put_other _ 7 k _ (kn 7 (by decide)),put_other _ 12 k _ (kn 12 (by decide))]
    exact rd.2.2 k (kn 4 (by decide)) (kn 5 (by decide)) (kn 6 (by decide)) (kn 7 (by decide))

end FT1536.S05.CoordinateCorrect020A
