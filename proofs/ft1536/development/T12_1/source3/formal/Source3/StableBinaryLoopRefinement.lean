import Source3.StableBinaryStepAssembly

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryLoopRefinement
open FT1536.Source3

theorem scratch_allowed (l : StableBinary.Layout) (i : Nat)
    (hi : i<l.length) : l.allowed (StableBinary.addr l.scratch i) := by
  unfold StableBinary.Layout.allowed
  have hright : (List.range l.length).any
      (fun j => StableBinary.addr l.scratch i == StableBinary.addr l.scratch j) = true :=
    List.any_eq_true.mpr ⟨i,List.mem_range.mpr hi,by simp⟩
  simp [hright]

theorem subtree_addresses (l : StableBinary.Layout) (start hn u : Nat)
    (hsub : start+2*hn≤l.length) (hu : u<hn) :
    l.allowed (StableBinary.addr (StableBinary.addr l.values start) (2*u)) ∧
    l.allowed (StableBinary.addr (StableBinary.addr l.values start) (2*u+1)) ∧
    l.allowed (StableBinary.addr l.scratch u) ∧
    l.allowed (StableBinary.addr l.scratch (u+hn)) := by
  have h0 : StableBinary.addr (StableBinary.addr l.values start) (2*u) =
      StableBinary.addr l.values (start+2*u) := by simp [StableBinary.addr]; omega
  have h1 : StableBinary.addr (StableBinary.addr l.values start) (2*u+1) =
      StableBinary.addr l.values (start+2*u+1) := by simp [StableBinary.addr]; omega
  refine ⟨?_,?_,?_,?_⟩
  · rw [h0]
    exact StableBinaryByteView.values_allowed l (start+2*u) (by omega)
  · rw [h1]
    exact StableBinaryByteView.values_allowed l (start+2*u+1) (by omega)
  · exact scratch_allowed l u (by omega)
  · exact scratch_allowed l (u+hn) (by omega)

theorem source_loop_refines (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (v hn n : Nat)
    (source final : StableBinaryCExec.State)
    (typed : StableBinary.State l m)
    (hl : l.wellFormed k)
    (haddresses : ∀ u<n,
      l.allowed (StableBinary.addr v (2*u)) ∧
      l.allowed (StableBinary.addr v (2*u+1)) ∧
      l.allowed (StableBinary.addr l.scratch u) ∧
      l.allowed (StableBinary.addr l.scratch (u+hn)))
    (rel : StableBinaryRelation.Related l m source typed)
    (hs : StableBinaryCExec.sourceLoop l StableBinarySourceSyntax.expected v hn n source=
      some final) :
    ∃ next,
      StableBinarySourceTyped.loop l StableBinarySourceSyntax.expected v hn n typed=
        some next ∧ StableBinaryRelation.Related l m final next := by
  induction n generalizing source final typed with
  | zero =>
      have heq : source=final := Option.some.inj (by simpa [StableBinaryCExec.sourceLoop] using hs)
      subst final
      exact ⟨typed,rfl,rel⟩
  | succ n ih =>
      have hsmall : ∀ u<n,
          l.allowed (StableBinary.addr v (2*u)) ∧
          l.allowed (StableBinary.addr v (2*u+1)) ∧
          l.allowed (StableBinary.addr l.scratch u) ∧
          l.allowed (StableBinary.addr l.scratch (u+hn)) := by
        intro u hu
        exact haddresses u (Nat.lt_succ_of_lt hu)
      have hs' : (do
          let mid ← StableBinaryCExec.sourceLoop l StableBinarySourceSyntax.expected v hn n source
          StableBinaryCExec.sourceStep l StableBinarySourceSyntax.expected v n hn mid) =
            some final := by simpa [StableBinaryCExec.sourceLoop] using hs
      obtain ⟨mid,hloop,hstep⟩ := Option.bind_eq_some_iff.mp hs'
      obtain ⟨typedMid,htLoop,relMid⟩ := ih source mid typed hsmall rel hloop
      obtain ⟨typedFinal,htStep,relFinal⟩ :=
        StableBinaryStepAssembly.source_step_refines l k m mid final typedMid v n hn
          hl relMid
          (haddresses n (Nat.lt_succ_self n)).1
          (haddresses n (Nat.lt_succ_self n)).2.1
          (haddresses n (Nat.lt_succ_self n)).2.2.1
          (haddresses n (Nat.lt_succ_self n)).2.2.2
          hstep
      refine ⟨typedFinal,?_,relFinal⟩
      simp [StableBinarySourceTyped.loop,htLoop,htStep]

end FT1536.Source3.StableBinaryLoopRefinement

#print axioms FT1536.Source3.StableBinaryLoopRefinement.source_loop_refines
#print axioms FT1536.Source3.StableBinaryLoopRefinement.subtree_addresses
