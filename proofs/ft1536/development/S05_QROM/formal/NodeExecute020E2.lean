import NodeResume020E2

namespace FT1536.S05.NodeExecute020E2
open WordRAM020 ArenaTypes020E1 ArenaHeap020E1 NodeFrames020E2

/-- The prefix contains at most the pending body and its loop continuation.
    All live jobs are address/count frames; the arena is immutable. -/
def step {cap : Nat} (a : Arena cap) (i : Input) (s : State) (f : Frame cap)
    (rest : List (Frame cap)) : Option (List (Frame cap) × State) :=
  (NodeAction020E2.action a i s f).map (fun q => (q.1++rest,q.2))

def execute {cap : Nat} (a : Arena cap) (i : Input) : Nat → List (Frame cap) → State → Option State
  | _,[],s => some s
  | 0,_::_,_ => none
  | fuel+1,f::fs,s => (step a i s f fs).bind (fun q => execute a i fuel q.1 q.2)

theorem related_append {cap : Nat} (a : Arena cap) (mu : Meaning)
    {fs gs : List (Frame cap)} {cs ds : List Code}
    (h : Related a mu fs cs) (k : Related a mu gs ds) : Related a mu (fs++gs) (cs++ds) := by
  induction h with
  | nil => exact k
  | cons hf ht ih => exact List.Forall₂.cons hf ih

theorem step_correct {cap : Nat} (a : Arena cap) (i : Input) (s : State) (mu : Meaning)
    (hh : HeapValid a mu) (f : Frame cap) (c : Code) (fs : List (Frame cap)) (cs : List Code)
    (hf : Rel a mu f c) (ht : Related a mu fs cs) :
    ∃ gs,step a i s f fs=some (gs,(ControlStack020E.next i c cs s).2) ∧
      Related a mu gs (ControlStack020E.next i c cs s).1 := by
  obtain ⟨gs,hg,hr⟩ := NodeResume020E2.action_correct a i s mu hh f c hf
  refine ⟨gs++fs,?_,?_⟩
  · rw [step,hg,Option.map_some,ControlNext020E2.next_tail i c cs s]
  · rw [ControlNext020E2.next_tail i c cs s]
    exact related_append a mu hr ht

/-- Exact at every fuel, including exhaustion. Meaning and source jobs
    are used in this theorem only, never by execute. -/
theorem correct {cap : Nat} (a : Arena cap) (i : Input) (mu : Meaning) (hh : HeapValid a mu)
    (fuel : Nat) (fs : List (Frame cap)) (cs : List Code) (s : State)
    (h : Related a mu fs cs) : execute a i fuel fs s=ControlStack020E.execute i fuel cs s := by
  induction fuel generalizing fs cs s with
  | zero =>
    cases h with
    | nil => rfl
    | cons hf ht => rfl
  | succ fuel ih =>
    cases h with
    | nil => rfl
    | @cons f c fs cs hf ht =>
      obtain ⟨gs,hg,hr⟩ := step_correct a i s mu hh f c fs cs hf ht
      rw [execute,hg,Option.bind_some,ControlStack020E.execute]
      exact ih gs _ _ hr

theorem singleton {cap : Nat} (a : Arena cap) (i : Input) (s : State) (mu : Meaning)
    (hh : HeapValid a mu) (pc : Ptr cap) (c : Code)
    (hp : pc.val<a.used.val) (hm : mu pc.val=SyntaxTape020E.Piece.code c)
    (hc : SyntaxLegal020E.maxCap c<2^511) (fuel : Nat) (hf : ControlStack020E.work c≤fuel) :
    execute a i fuel [.run pc] s=some (run i c s).1 := by
  rw [correct a i mu hh fuel [.run pc] [c] s
    (List.Forall₂.cons (Rel.run pc c hp hm hc) List.Forall₂.nil)]
  exact ControlStack020E.correct i fuel [c] s (by simpa only [ControlStack020E.total,Nat.add_zero] using hf)

end FT1536.S05.NodeExecute020E2
