import NodeControlShape020E2
import NodeLoop020E2

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.NodeRun020E2
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1 ArenaToken020E1
open NodeFrames020E2 NodeAction020E2

theorem dispatch_atom {cap : Nat} (a : Arena cap) (i : Input) (s q : State)
    (pc : Ptr cap) (n : Node cap) (t : Token)
    (h : NodeAtom020E2.withEval (NodeExpr020E2.evaluate a.used.val a s) i s n t=some q) :
    dispatch a i s pc n t=some ([],q) := by
  cases t
  all_goals first
    | exact congrArg (fun v : Option State => v.map (fun z => (([] : List (Frame cap)),z))) h
    | simp [NodeAtom020E2.withEval] at h

theorem correct {cap : Nat} (a : Arena cap) (i : Input) (s : State)
    (mu : Meaning) (hh : HeapValid a mu) (pc : Ptr cap) (c : Code)
    (hp : pc.val<a.used.val) (hm : mu pc.val=.code c) (hc : SyntaxLegal020E.maxCap c<2^511) :
    ∃ fs : List (Frame cap), start a i s pc=some (fs,(ControlStack020E.next i c [] s).2) ∧
      Related a mu fs (ControlStack020E.next i c [] s).1 := by
  obtain ⟨n,t,ht,hkids,hs⟩ := NodeRead020E2.inspect_exists a mu hh pc hp
  rw [hm] at hs
  have child : ∀ p∈children t n,p.val<a.used.val := fun p h => (hkids p h).trans hp
  cases c with
  | atom b =>
    have ha := NodeAtom020E2.from_shape (NodeExpr020E2.evaluate a.used.val a s) i s n t mu b hs
      (fun p h e he => NodeExpr020E2.correct a.used.val a mu s hh p e (child p h) (child p h) he)
    refine ⟨[],?_,List.Forall₂.nil⟩
    rw [start,ht]
    simp only [Option.bind_some,ControlStack020E.next,ExprBackend020E.atom_eq]
    exact dispatch_atom a i s (atomRun i b s) pc n t ha
  | seq b d =>
    obtain ⟨rfl,hd,hb⟩ := NodeControlShape020E2.seq_shape n t mu b d hs
    have hbl : SyntaxLegal020E.maxCap b<2^511 := lt_of_le_of_lt (le_max_left _ _) hc
    have hdl : SyntaxLegal020E.maxCap d<2^511 := lt_of_le_of_lt (le_max_right _ _) hc
    refine ⟨[.run n.second,.run n.first],?_,?_⟩
    · rw [start,ht];rfl
    · exact List.Forall₂.cons (Rel.run n.second b (child _ (by simp [children,arity,needs])) hb hbl)
        (List.Forall₂.cons (Rel.run n.first d (child _ (by simp [children,arity,needs])) hd hdl) List.Forall₂.nil)
  | branch g b d =>
    obtain ⟨rfl,hd,hb,hg⟩ := NodeControlShape020E2.branch_shape n t mu g b d hs
    have hbl : SyntaxLegal020E.maxCap b<2^511 := lt_of_le_of_lt (le_max_left _ _) hc
    have hdl : SyntaxLegal020E.maxCap d<2^511 := lt_of_le_of_lt (le_max_right _ _) hc
    have hgp := child n.third (by simp [children,arity,needs])
    have heval := NodeExpr020E2.correct a.used.val a mu s hh n.third g hgp hgp hg
    by_cases hz : eval s g=0
    · refine ⟨[.run n.first],?_,?_⟩
      · rw [start,ht]
        simp only [Option.bind_some,dispatch,heval,Option.map_some,ite_eq_left hz]
        rfl
      · change Related a mu [.run n.first] (if ExprBackend020E.value s g=0 then [d] else [b])
        rw [ExprBackend020E.value_eq,ite_eq_left hz]
        exact List.Forall₂.cons (Rel.run n.first d (child _ (by simp [children,arity,needs])) hd hdl) List.Forall₂.nil
    · refine ⟨[.run n.second],?_,?_⟩
      · rw [start,ht]
        simp only [Option.bind_some,dispatch,heval,Option.map_some,ite_eq_right hz]
        rfl
      · change Related a mu [.run n.second] (if ExprBackend020E.value s g=0 then [d] else [b])
        rw [ExprBackend020E.value_eq,ite_eq_right hz]
        exact List.Forall₂.cons (Rel.run n.second b (child _ (by simp [children,arity,needs])) hb hbl) List.Forall₂.nil
  | loop limit g b =>
    obtain ⟨rfl,hb,hg⟩ := NodeControlShape020E2.loop_shape n t mu limit g b hs
    obtain ⟨fs,hf,hr⟩ := NodeLoop020E2.correct a s mu hh pc n.first n.second limit limit g b hp hm hc
      (child _ (by simp [children,arity,needs])) hb (child _ (by simp [children,arity,needs])) hg (le_refl _)
    refine ⟨fs,?_,?_⟩
    · rw [start,ht]
      simpa only [Option.bind_some,dispatch,ControlNext020E2.loop_shape] using hf
    · simpa only [ControlNext020E2.loop_shape] using hr

end FT1536.S05.NodeRun020E2
