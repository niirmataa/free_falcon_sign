import ReadWordStep020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ReadWordLoop020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A ReadWordStep020A

def RegFrame (s t : State) : Prop := ∀ k : Reg, k≠4 → k≠5 → k≠6 → t.reg k=s.reg k

theorem body_frame (i : Input) (s : State) (base : Expr) (b n a : Nat)
    (hbase : eval s base=word b) (hb4 : (4 : Reg) ∉ reads base)
    (h4 : s.reg 4=word ((n+1 : Nat) : Int)) (h5 : s.reg 5=word a)
    (hn : n<384) (ha : a<2^384) (haddr : b+n<tapeSize) :
    Frame s (exec i (body base) s) ∧ RegFrame s (exec i (body base) s) := by
  rw [body_step i s base b n a hbase hb4 h4 h5 hn ha haddr]
  refine ⟨⟨rfl,rfl,rfl⟩,?_⟩
  intro k h4 h5 h6
  rw [put_other _ 5 k _ h5,put_other _ 6 k _ h6,put_other _ 4 k _ h4]

theorem guard_positive (s : State) (n : Nat) (hn : n<384) (h4 : s.reg 4=word ((n+1 : Nat) : Int)) :
    eval s (nz 4) ≠ 0 := by
  change op .lt (word 0) (s.reg 4) ≠ 0
  rw [h4,lt_word _ _ (by norm_num [Fits]) (tiny_fits (by omega))]
  simp only [Nat.cast_add,Nat.cast_one]
  have hpos : (0 : Int)<(n : Int)+1 := by omega
  rw [ite_eq_left hpos]
  decide

/-- Every iteration of the ACTUAL reader, for every valid tape segment.
    Counter/accumulator bounds are proved inductively, not assumed along a run. -/
theorem loop_correct (i : Input) (base : Expr) (b width n a : Nat) (s : State)
    (hw : width≤384) (hn : n≤width) (ha : a<2^(width-n))
    (haddr : b+width≤tapeSize) (hb4 : (4 : Reg) ∉ reads base)
    (hb5 : (5 : Reg) ∉ reads base) (hb6 : (6 : Reg) ∉ reads base)
    (hbase : eval s base=word b) (h4 : s.reg 4=word n) (h5 : s.reg 5=word a) :
    let t := loopState (exec i (body base)) (nz 4) n s
    t.reg 4=word 0 ∧ t.reg 5=word ((2^n*a+value (tapeBits i) n b : Nat) : Int) ∧ Frame s t ∧ RegFrame s t := by
  induction n generalizing s a with
  | zero =>
    simp only [loopState,pow_zero,one_mul,value,Nat.add_zero]
    exact ⟨h4,h5,frame_refl s,fun _ _ _ _ => rfl⟩
  | succ n ih =>
    have hn384 : n<384 := by omega
    have ha384 : a<2^384 := lt_of_lt_of_le ha (Nat.pow_le_pow_right (by decide) (by omega))
    have hadr : b+n<tapeSize := by omega
    let a' := 2*a+bit (tapeBits i (b+n))
    let s' := exec i (body base) s
    have hs : s'=put (put (put s 4 (word n)) 6 (word (bit (tapeBits i (b+n))))) 5 (word a') :=
      body_step i s base b n a hbase hb4 h4 h5 hn384 ha384 hadr
    have h4' : s'.reg 4=word n := by
      rw [hs,put_other _ 5 4 _ (by decide),put_other _ 6 4 _ (by decide),put_same]
    have h5' : s'.reg 5=word a' := by rw [hs,put_same]
    have hb' : eval s' base=word b := by
      rw [hs,eval_put _ _ 5 _ hb5,eval_put _ _ 6 _ hb6,eval_put _ _ 4 _ hb4,hbase]
    have ha' : a'<2^(width-n) := by
      have h := read_accumulator_bound a (width-(n+1)) ha (tapeBits i (b+n))
      have he : width-(n+1)+1=width-n := by omega
      rw [he] at h
      exact h
    have post := ih a' s' (by omega) ha' hb' h4' h5'
    have fr := body_frame i s base b n a hbase hb4 h4 h5 hn384 ha384 hadr
    rw [loopState,ite_eq_right (guard_positive s n hn384 h4)]
    refine ⟨post.1,?_,frame_trans fr.1 post.2.2.1,?_⟩
    · have he : 2^n*a'+value (tapeBits i) n b=2^(n+1)*a+value (tapeBits i) (n+1) b := by
        rw [value_snoc,pow_succ]
        dsimp [a']
        ring
      rw [←he]
      exact post.2.1
    · intro k hk4 hk5 hk6
      exact (post.2.2.2 k hk4 hk5 hk6).trans (fr.2 k hk4 hk5 hk6)

end FT1536.S05.ReadWordLoop020A
