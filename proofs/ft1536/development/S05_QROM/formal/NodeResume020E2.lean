import NodeRun020E2

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.NodeResume020E2
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1
open NodeFrames020E2 NodeAction020E2

theorem correct {cap : Nat} (a : Arena cap) (i : Input) (s : State) (mu : Meaning)
    (hh : HeapValid a mu) (pc : Ptr cap) (remaining : Count) (limit : Nat) (g : Expr) (b : Code)
    (hp : pc.val<a.used.val) (hm : mu pc.val=.code (.loop limit g b))
    (hc : SyntaxLegal020E.maxCap (.loop limit g b)<2^511) (hn : remaining.val≤limit) :
    ∃ fs : List (Frame cap),resume a s pc remaining=
      some (fs,(ControlStack020E.next i (.loop remaining.val g b) [] s).2) ∧
      Related a mu fs (ControlStack020E.next i (.loop remaining.val g b) [] s).1 := by
  obtain ⟨n,t,ht,hkids,hs⟩ := NodeRead020E2.inspect_exists a mu hh pc hp
  rw [hm] at hs
  obtain ⟨rfl,hb,hg⟩ := NodeControlShape020E2.loop_shape n t mu limit g b hs
  have child : ∀ p∈children (.loop limit) n,p.val<a.used.val := fun p h => (hkids p h).trans hp
  obtain ⟨fs,hf,hr⟩ := NodeLoop020E2.correct a s mu hh pc n.first n.second limit remaining.val g b hp hm hc
    (child _ (by simp [children,arity,needs])) hb (child _ (by simp [children,arity,needs])) hg hn
  refine ⟨fs,?_,?_⟩
  · rw [resume,ht]
    simpa only [Option.bind_some,ite_eq_left hn,ControlNext020E2.loop_shape] using hf
  · simpa only [ControlNext020E2.loop_shape] using hr

theorem action_correct {cap : Nat} (a : Arena cap) (i : Input) (s : State) (mu : Meaning)
    (hh : HeapValid a mu) (f : Frame cap) (c : Code) (h : Rel a mu f c) :
    ∃ fs : List (Frame cap),action a i s f=some (fs,(ControlStack020E.next i c [] s).2) ∧
      Related a mu fs (ControlStack020E.next i c [] s).1 := by
  cases h with
  | run pc c hp hm hc => exact NodeRun020E2.correct a i s mu hh pc c hp hm hc
  | again pc remaining limit g b hp hm hc hn => exact correct a i s mu hh pc remaining limit g b hp hm hc hn

end FT1536.S05.NodeResume020E2
