import BankAction020E3
import BoundedStack020E3
import FrameReserve020E3

namespace FT1536.S05.BankStep020E3
open WordRAM020 ArenaTypes020E1 ArenaHeap020E1 NodeFrames020E2
open BoundedStack020E3 ControlStack020E ControlSpace020E

abbrev Frames (cap capacity : Nat) := Stack (Frame cap) capacity

def step {cap capacity : Nat} (a : Arena cap) (i : Input) (s : State) (st : Frames cap capacity) :
    Option (Frames cap capacity × State) :=
  (top st).bind (fun f => (BankAction020E3.action a i s f).bind (fun q =>
    (pushMany (drop st 1) q.1).map (fun t => (t,q.2))))

theorem correct {cap capacity : Nat} (a : Arena cap) (i : Input) (s : State) (mu : Meaning)
    (hh : HeapValid a mu) (st : Frames cap capacity) (f : Frame cap) (fs : List (Frame cap))
    (c : Code) (cs : List Code) (hv : view st=f::fs)
    (hf : Rel a mu f c) (ht : Related a mu fs cs) (room : reserve (c::cs)≤capacity) :
    ∃ t,step a i s st=some (t,(next i c cs s).2) ∧ Related a mu (view t) (next i c cs s).1 := by
  obtain ⟨gs,hg,hr⟩ := NodeResume020E2.action_correct a i s mu hh f c hf
  have hdrop : view (drop st 1)=fs := by rw [view_drop,hv];rfl
  have hfull : Related a mu (gs++fs) (next i c cs s).1 := by
    rw [ControlNext020E2.next_tail i c cs s]
    exact NodeExecute020E2.related_append a mu hr ht
  have hlen : gs.length+(drop st 1).sp.val≤capacity := by
    have hl := hfull.length_eq
    rw [List.length_append] at hl
    have hd := view_length (drop st 1)
    rw [hdrop] at hd
    have bound := (FrameReserve020E3.next_length_bound i c cs s).trans room
    omega
  obtain ⟨t,hpush,hview⟩ := pushMany_correct (drop st 1) gs hlen
  refine ⟨t,?_,?_⟩
  · rw [step,top_cons st f fs hv,Option.bind_some,BankAction020E3.correct a i s mu hh f,hg,Option.bind_some,hpush,Option.map_some]
    rw [ControlNext020E2.next_tail i c cs s]
  · rw [hview,hdrop]
    exact hfull

end FT1536.S05.BankStep020E3
