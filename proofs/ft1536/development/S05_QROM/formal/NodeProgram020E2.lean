import NodeExecute020E2
import ArenaProgram020E1
import ProgramRefinement020D

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.NodeProgram020E2
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1 ArenaInvariant020E1
open JointInterface019 FT1536.Relation

/-- This entry reads the parsed root address. No Code or Meaning is rebuilt. -/
def fromArena {cap : Nat} (a : Arena cap) (i : Input) (fuel : Nat) (s : State) : Option State :=
  if a.sp.val=1 then NodeExecute020E2.execute a i fuel [.run (ArenaStack020E1.peek a 0)] s else none

theorem invariant_correct {cap : Nat} (a : Arena cap) (i : Input) (s : State) (mu : Meaning)
    (c : Code) (hi : Inv a mu [.code c]) (hc : SyntaxLegal020E.maxCap c<2^511)
    (fuel : Nat) (hf : ControlStack020E.work c≤fuel) :
    fromArena a i fuel s=some (run i c s).1 := by
  have hsp : a.sp.val=1 := (logical_length a mu [.code c] hi).symm
  have hv := ArenaDecode020E1.view_singleton a hsp
  have hp : (ArenaStack020E1.peek a 0).val<a.used.val := hi.2.1 _ (by rw [hv];simp)
  have hm := hi.2.2.2
  rw [hv,List.map_cons,List.map_nil] at hm
  have he : mu (ArenaStack020E1.peek a 0).val=.code c := (List.cons.inj hm).1
  rw [fromArena,ite_eq_left hsp]
  exact NodeExecute020E2.singleton a i s mu hi.1 _ c hp he hc fuel hf

theorem built_correct (cap : Nat) (c : Code) (hc : SyntaxLegal020E.maxCap c<2^511)
    (room : nodes c≤cap) (fuel : Nat) (hf : ControlStack020E.work c≤fuel) (i : Input) (s : State) :
    (ArenaProgram020E1.build cap c).bind (fun a => fromArena a i fuel s)=some (run i c s).1 := by
  obtain ⟨a,mu,ha,hi,_⟩ := ArenaProgram020E1.build_invariant cap c hc room
  rw [ha,Option.bind_some]
  exact invariant_correct a i s mu c hi hc fuel hf

/-- Bound on control transitions only, inherited from the same original
    program. Expression recursion, input construction and total time are separate. -/
def controlLimit : Nat := 1106642201817

theorem work_fits : ControlStack020E.work PairProgram020.program≤controlLimit := by
  have h := ControlSpace020E.work_le_bound PairProgram020.program
  rw [ProgramCost020.program_bound_value] at h
  exact h

/-- The existing exact source-image parser followed by direct node execution. -/
def actual (i : Input) (s : State) : Option State :=
  ArenaProgram020E1.actual.bind (fun a => fromArena a i controlLimit s)

theorem actual_correct (i : Input) (s : State) :
    actual i s=some (run i PairProgram020.program s).1 := by
  exact built_correct 877 PairProgram020.program
    (by rw [ProgramResources020E.cap_value];norm_num)
    (by rw [ProgramCost020.program_nodes]) controlLimit work_fits i s

theorem on_actual_arena (a : Arena 877) (ha : ArenaProgram020E1.actual=some a) (i : Input) (s : State) :
    fromArena a i controlLimit s=some (run i PairProgram020.program s).1 := by
  have h := actual_correct i s
  rw [actual,ha,Option.bind_some] at h
  exact h

/-- Every tape and every incoming state, including its existing fault flag. -/
theorem every_state (h : Rq) (tape : Bits tapeSize) (s : State) :
    ∃ t : State,actual (InputLayout020.encode h tape) s=some t ∧ t.fault=s.fault ∧
      List.ofFn t.out=PairEncoding020.encode ((StandaloneRuntime019.publicCode h).code tape) := by
  refine ⟨(run (InputLayout020.encode h tape) PairProgram020.program s).1,actual_correct _ _,?_,?_⟩
  · exact (ProgramRefinement020D.program_correct h tape s).2
  · exact (ProgramRefinement020D.program_correct h tape s).1

theorem public_initial (h : Rq) (tape : Bits tapeSize) :
    ∃ t : State,actual (InputLayout020.encode h tape) initial=some t ∧ t.fault=false ∧
      List.ofFn t.out=PairEncoding020.encode ((StandaloneRuntime019.publicCode h).code tape) :=
  ⟨(run (InputLayout020.encode h tape) PairProgram020.program initial).1,
    actual_correct _ _,ProgramRefinement020D.every_tape h tape⟩

end FT1536.S05.NodeProgram020E2
