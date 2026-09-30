import Source3.StableBinaryCopyRefinement

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryRecursionRefinement
open FT1536.Source3

theorem base_refines (l : StableBinary.Layout) (rootK : Nat)
    (m : StableBinary.Memory) (source final : StableBinaryCExec.State)
    (typed : StableBinary.State l m) (start : Nat)
    (hl : l.wellFormed rootK) (hbound : start+1≤l.length)
    (rel : StableBinaryRelation.Related l m source typed)
    (hs : StableBinaryCExec.execute l StableBinarySourceSyntax.expected 0
      (StableBinary.addr l.values start) source=some final) :
    ∃ next, StableBinarySourceTyped.execute l StableBinarySourceSyntax.expected m 0
      (StableBinary.addr l.values start) typed=some next ∧
      StableBinaryRelation.Related l m final next := by
  let v := StableBinary.addr l.values start
  have hav : l.allowed v :=
    StableBinaryByteView.values_allowed l start (by omega)
  have hs0 : (do
      let x ← StableBinaryCExec.load source v
      let (y,s) ← StableBinaryCExec.positive l source x
      StableBinaryCExec.store s v y)=some final := by
    simpa [StableBinaryCExec.execute,StableBinarySourceSyntax.expected,v] using hs
  obtain ⟨x,hload,hrest⟩ := Option.bind_eq_some_iff.mp hs0
  obtain ⟨⟨y,mid⟩,hpositive,hstore⟩ := Option.bind_eq_some_iff.mp hrest
  let initial : StableBinary.State l m :=
    {typed with events := .enter v 1::typed.events}
  have rel0 : StableBinaryRelation.Related l m source initial :=
    ⟨rel.words,rel.flags,rel.checks⟩
  obtain ⟨t1,ht1,rel1⟩ :=
    StableBinaryRelation.load_step l m source initial v x hav rel0 hload
  obtain ⟨t2,ht2,rel2⟩ :=
    StableBinaryRelation.positive_refines l rootK m source mid t1 x y hl rel1 hpositive
  have hm : (StableBinary.store t2 v y).isSome := by simp [StableBinary.store,hav]
  obtain ⟨t3,ht3⟩ := Option.isSome_iff_exists.mp hm
  have rel3 := StableBinaryRelation.store_step l rootK m mid final t2 t3 v y
    hl hav rel2 hstore ht3
  let next : StableBinary.State l m := {t3 with events := .leave v 1::t3.events}
  refine ⟨next,?_,?_⟩
  · change (StableBinary.load initial v).bind
      (fun p1 => (StableBinary.stable p1.2 p1.1).bind
        (fun p2 => (StableBinary.store p2.2 v p2.1).bind
          (fun state => some {state with events := .leave v 1::state.events}))) = some next
    simp only [Option.bind,ht1,ht2,ht3]
    rfl
  · exact ⟨rel3.words,rel3.flags,rel3.checks⟩

theorem execute_refines (l : StableBinary.Layout) (rootK : Nat)
    (m : StableBinary.Memory) (hl : l.wellFormed rootK) :
    ∀ (k start : Nat) (source final : StableBinaryCExec.State)
      (typed : StableBinary.State l m),
      start+2^k≤l.length →
      StableBinaryRelation.Related l m source typed →
      StableBinaryCExec.execute l StableBinarySourceSyntax.expected k
        (StableBinary.addr l.values start) source=some final →
      ∃ next, StableBinarySourceTyped.execute l StableBinarySourceSyntax.expected m k
          (StableBinary.addr l.values start) typed=some next ∧
        StableBinaryRelation.Related l m final next := by
  intro k
  induction k with
  | zero =>
      intro start source final typed hbound rel hs
      exact base_refines l rootK m source final typed start hl (by simpa using hbound) rel hs
  | succ k ih =>
      intro start source final typed hbound rel hs
      let hn := 2^k
      let v := StableBinary.addr l.values start
      have hsub : start+2*hn≤l.length := by
        simpa [hn,pow_succ,Nat.mul_comm] using hbound
      have hrightAddr : v+8*hn=StableBinary.addr l.values (start+hn) := by
        simp [v,StableBinary.addr]
        omega
      have hsrc : (do
          let s0 ← StableBinaryCExec.sourceLoop l StableBinarySourceSyntax.expected v hn hn source
          let s1 ← StableBinaryCExec.copy s0 v l.scratch (2*hn)
          let s2 ← StableBinaryCExec.execute l StableBinarySourceSyntax.expected k v s1
          StableBinaryCExec.execute l StableBinarySourceSyntax.expected k (v+8*hn) s2) =
          some final := by simpa [StableBinaryCExec.execute,hn,v] using hs
      obtain ⟨sloop,hloop,hrest⟩ := Option.bind_eq_some_iff.mp hsrc
      obtain ⟨scopy,hcopy,hrest⟩ := Option.bind_eq_some_iff.mp hrest
      obtain ⟨sleft,hleft,hright⟩ := Option.bind_eq_some_iff.mp hrest
      let initial : StableBinary.State l m :=
        {typed with events := .enter v (2*hn)::typed.events}
      have rel0 : StableBinaryRelation.Related l m source initial :=
        ⟨rel.words,rel.flags,rel.checks⟩
      have haddresses : ∀ u<hn,
          l.allowed (StableBinary.addr v (2*u)) ∧
          l.allowed (StableBinary.addr v (2*u+1)) ∧
          l.allowed (StableBinary.addr l.scratch u) ∧
          l.allowed (StableBinary.addr l.scratch (u+hn)) := by
        intro u hu
        exact StableBinaryLoopRefinement.subtree_addresses l start hn u hsub hu
      obtain ⟨tloop,htloop,relLoop⟩ :=
        StableBinaryLoopRefinement.source_loop_refines l rootK m v hn hn
          source sloop initial hl haddresses rel0 hloop
      obtain ⟨tcopy,htcopy,relCopy⟩ :=
        StableBinaryCopyRefinement.copy_refines l rootK m sloop scopy tloop start
          (2*hn) hl hsub relLoop hcopy
      obtain ⟨tleft,htleft,relLeft⟩ := ih start scopy sleft tcopy
        (by omega) relCopy (by simpa [v] using hleft)
      have hright' : StableBinaryCExec.execute l StableBinarySourceSyntax.expected k
          (StableBinary.addr l.values (start+hn)) sleft=some final := by
        simpa only [← hrightAddr] using hright
      obtain ⟨tright,htright,relRight⟩ := ih (start+hn) sleft final tleft
        (by omega) relLeft hright'
      have htRight' : StableBinarySourceTyped.execute l StableBinarySourceSyntax.expected m k
          (v+8*hn) tleft=some tright := by
        simpa only [hrightAddr] using htright
      let next : StableBinary.State l m :=
        {tright with events := .leave v (2*hn)::tright.events}
      refine ⟨next,?_,?_⟩
      · change (StableBinarySourceTyped.loop l StableBinarySourceSyntax.expected v hn hn initial).bind
          (fun t0 => (StableBinary.copy l t0 v l.scratch (2*hn)).bind
            (fun t1 => (StableBinarySourceTyped.execute l StableBinarySourceSyntax.expected m k v t1).bind
              (fun t2 => (StableBinarySourceTyped.execute l StableBinarySourceSyntax.expected m k
                (v+8*hn) t2).bind
                (fun t3 => some {t3 with events := .leave v (2*hn)::t3.events})))) = some next
        simp only [Option.bind,htloop]
        rw [htcopy]
        dsimp only
        rw [htleft]
        dsimp only
        rw [htRight']
      · exact ⟨relRight.words,relRight.flags,relRight.checks⟩

end FT1536.Source3.StableBinaryRecursionRefinement

#print axioms FT1536.Source3.StableBinaryRecursionRefinement.base_refines
#print axioms FT1536.Source3.StableBinaryRecursionRefinement.execute_refines
