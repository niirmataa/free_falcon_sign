import BufferField020D
import ScalarExpr020D
import CdfPrefix020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ScatterBranches020D
open WordRAM020 PairProgram020 ReadSemantics020A Residue020D BufferField020D ScalarExpr020D CdfPrefix020A
attribute [local irreducible] exec loopState

def reduced (v : Coeffs) (e : Fin 3072) (c : F) : Coeffs :=
  if h : e.val<1536 then addAt v ⟨e.val,h⟩ c else
  if h' : e.val<2304 then addAt (addAt v ⟨e.val-768,by omega⟩ c) ⟨e.val-1536,by omega⟩ (-c)
  else addAt v ⟨e.val-2304,by have := e.isLt;omega⟩ (-c)
def branches : Code :=
  .branch (lt (r 17) (lit 1536)) (update (r 17) (r 25))
    (.branch (lt (r 17) (lit 2304))
      (seqs [update (sub (r 17) (lit 768)) (r 25),
        update (sub (r 17) (lit 1536)) (sub (lit 0) (r 25))])
      (update (sub (r 17) (lit 2304)) (sub (lit 0) (r 25))))
def Post (s t : State) (v : Coeffs) : Prop := Holds t v ∧ BufferField020D.Frame s t ∧
  ∀ rr : Reg, rr≠26 → rr≠27 → t.reg rr=s.reg rr

theorem positive (i : Input) (s : State) (v : Coeffs) (k : Fin 1536) (idx : Expr) (c : F)
    (hv : Holds s v) (hi : eval s idx=word (k.val:Int)) (h25 : s.reg 25=fw c) :
    Post s (exec i (update idx (r 25)) s) (addAt v k c) := by
  have hc := field_bounds c
  have post := update_holds i s v k (c.val:Int) idx (r 25) hv (by omega) hi h25
    (by simp [reads,r]) (by simp [reads,r])
  rw [value_cast] at post
  exact post

theorem negative (i : Input) (s : State) (v : Coeffs) (k : Fin 1536) (idx : Expr) (c : F)
    (hv : Holds s v) (hi : eval s idx=word (k.val:Int)) (h25 : s.reg 25=fw c) :
    Post s (exec i (update idx (sub (lit 0) (r 25))) s) (addAt v k (-c)) := by
  have hc := field_bounds c
  have post := update_holds i s v k (-(c.val:Int)) idx (sub (lit 0) (r 25)) hv (by omega) hi
    (negate_field s 25 c h25) (by simp [reads,sub,lit,r]) (by simp [reads,sub,lit,r])
  rw [neg_value_cast] at post
  exact post

/-- The actual three-way reduction; both writes of the middle case retained. -/
theorem branches_correct (i : Input) (s : State) (v : Coeffs) (e : Fin 3072) (c : F)
    (hv : Holds s v) (h17 : s.reg 17=word (e.val:Int)) (h25 : s.reg 25=fw c) :
    Post s (exec i branches s) (reduced v e c) := by
  have he := e.isLt
  have one : word 1≠0 := by decide
  have gate0 : eval s (lt (r 17) (lit 1536))=word (if e.val<1536 then 1 else 0) := nat_lt s 17 e.val 1536 (by omega) (by decide) h17
  have gate1 : eval s (lt (r 17) (lit 2304))=word (if e.val<2304 then 1 else 0) := nat_lt s 17 e.val 2304 (by omega) (by decide) h17
  rw [branches,exec_branch,gate0]
  by_cases lo : e.val<1536
  · rw [ite_eq_left lo,ite_eq_right one]
    simpa only [reduced,dite_eq_left lo] using positive i s v ⟨e.val,lo⟩ (r 17) c hv h17 h25
  · rw [ite_eq_right lo,ite_eq_left (show word 0=0 by rfl),exec_branch,gate1]
    by_cases mid : e.val<2304
    · rw [ite_eq_left mid,ite_eq_right one]
      let k1 : Fin 1536 := ⟨e.val-768,by omega⟩
      let k2 : Fin 1536 := ⟨e.val-1536,by omega⟩
      let q := exec i (update (sub (r 17) (lit 768)) (r 25)) s
      have p1 := positive i s v k1 (sub (r 17) (lit 768)) c hv
        (nat_sub s 17 e.val 768 (by omega) (by omega) h17) h25
      have q17 : q.reg 17=word (e.val:Int) := (p1.2.2 17 (by decide) (by decide)).trans h17
      have q25 : q.reg 25=fw c := (p1.2.2 25 (by decide) (by decide)).trans h25
      have p2 := negative i q (addAt v k1 c) k2 (sub (r 17) (lit 1536)) c p1.1
        (nat_sub q 17 e.val 1536 (by omega) (by omega) q17) q25
      simp only [exec_seqs_cons,exec_seqs_nil]
      refine ⟨?_,BufferField020D.frame_trans p1.2.1 p2.2.1,?_⟩
      · simpa only [reduced,dite_eq_right lo,dite_eq_left mid] using p2.1
      · intro rr h26 h27
        exact (p2.2.2 rr h26 h27).trans (p1.2.2 rr h26 h27)
    · rw [ite_eq_right mid,ite_eq_left (show word 0=0 by rfl)]
      have post := negative i s v ⟨e.val-2304,by omega⟩ (sub (r 17) (lit 2304)) c hv
        (nat_sub s 17 e.val 2304 (by omega) (by omega) h17) h25
      simpa only [reduced,dite_eq_right lo,dite_eq_right mid] using post

end FT1536.S05.ScatterBranches020D
