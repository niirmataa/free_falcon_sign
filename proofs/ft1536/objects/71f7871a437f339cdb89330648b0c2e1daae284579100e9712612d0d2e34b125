import Source3.StableTopBodyTotal

namespace FT1536.Source3.StableTopLoop
open StableTopSyntax StableTopMemory StableTopEffects StableTopAtoms StableBinaryByteView

def Filled (l : Layout) (count : Nat) (heap : B20.C.Byte.Memory) : Prop :=
  ∀ b : Fin 3, ∀ i<count, (wordRead heap (StableBinary.addr l.leaves (256*b.val+i))).isSome
def storeExpr (b : Fin 3) : Expr :=
  if b.val=0 then .bin .div (v "e1") (v "three")
  else if b.val=1 then .bin .div (v "e2") (v "e1")
  else .bin .div (.bin .mul (v "three") (v "abc")) (v "e2")
theorem pinned_store (b : Fin 3) : Stmt.storeCheck (256*b.val) (storeExpr b)∈expected.body := by
  fin_cases b <;> decide

theorem initial_ready (three : BitVec 64) :
    StableTopBodyTotal.Ready ["three".toList] (StableTopExec.initialLocals three) := by
  intro n hn
  have he : n="three".toList := by simpa using hn
  subst n
  simp [StableTopExec.initialLocals]

theorem loop_exists (l : Layout) (hl : WellFormed l) (three : BitVec 64) (s : StableBinaryCExec.State)
    (legal : Legal l s.heap) : ∀ i, i≤256 → ∃ out,
      StableTopReference.Loop l expected three i (C99HelperAtoms.decode s) (C99HelperAtoms.decode out) ∧
      Effect l s out ∧ Filled l i out.heap := by
  intro i
  induction i with
  | zero =>
      intro _
      exact ⟨s,StableTopReference.Loop.zero _,effect_refl l s legal,by intro b i hi; omega⟩
  | succ i ih =>
      intro hi
      obtain ⟨mid,hrmid,emid,fill⟩ := ih (by omega)
      obtain ⟨out,hrout,eout,writes⟩ := StableTopBodyTotal.body_total l hl (3*i) i expected.body ["three".toList]
        ⟨mid,StableTopExec.initialLocals three⟩ emid.legal (initial_ready three)
        StableTopBodyTotal.pinned_check (StableTopBodyTotal.pinned_bounds i (by omega))
      refine ⟨out.memory,StableTopReference.Loop.next i (C99HelperAtoms.decode s) (C99HelperAtoms.decode mid)
        (StableTopBodyBridge.decode out) hrmid (by change 0+3*i<768; omega) ?_,effect_trans emid eout,?_⟩
      · change StableTopReference.Body l (0+3*i) (0+1*i) expected.body
          (StableTopBodyBridge.decode ⟨mid,StableTopExec.initialLocals three⟩) (StableTopBodyBridge.decode out)
        simpa only [Nat.zero_add,Nat.one_mul] using hrout
      · intro b j hj
        by_cases hji : j < i
        · have idx : 256*b.val+j<768 := by have hb:=b.isLt; omega
          exact eout.grows _ idx (fill b j hji)
        · have he : j=i := by omega
          subst j
          exact writes (256*b.val) (storeExpr b) (pinned_store b)

theorem filled_all (l : Layout) (heap : B20.C.Byte.Memory) (h : Filled l 256 heap) :
    ∀ i<768, (wordRead heap (StableBinary.addr l.leaves i)).isSome := by
  intro i hi
  let b : Fin 3 := ⟨i/256,by omega⟩
  have hj : i%256<256 := Nat.mod_lt _ (by decide)
  have hm := h b (i%256) hj
  have he : 256*b.val+i%256=i := by dsimp [b]; omega
  rw [he] at hm
  exact hm

theorem counters (i : Nat) (hi : i≤256) :
    expected.loop.initialU+expected.loop.stepU*i=3*i ∧
    expected.loop.initialV+expected.loop.stepV*i=i ∧ 3*i≤768 := by
  change 0+3*i=3*i ∧ 0+1*i=i ∧ 3*i≤768
  omega

end FT1536.Source3.StableTopLoop

#print axioms FT1536.Source3.StableTopLoop.loop_exists
#print axioms FT1536.Source3.StableTopLoop.filled_all
#print axioms FT1536.Source3.StableTopLoop.counters
