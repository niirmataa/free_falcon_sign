import BankExecute020E3
import NodeProgram020E2

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.BankProgram020E3
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1 ArenaInvariant020E1
open NodeFrames020E2 BoundedStack020E3 BankStep020E3 ControlStack020E ControlSpace020E
open JointInterface019 FT1536.Relation

def fromArena {cap : Nat} (capacity : Nat) (a : Arena cap) (i : Input) (fuel : Nat) (s : State) : Option State :=
  if a.sp.val=1 then
    (push (BoundedStack020E3.empty capacity (Frame.run (0 : Ptr cap))) (.run (ArenaStack020E1.peek a 0))).bind
      (fun st => BankExecute020E3.execute a i fuel st s)
  else none

theorem invariant_correct {cap : Nat} (capacity : Nat) (a : Arena cap) (i : Input) (s : State)
    (mu : Meaning) (c : Code) (hi : Inv a mu [.code c]) (hc : SyntaxLegal020E.maxCap c<2^511)
    (room : reserve [c]≤capacity) (fuel : Nat) (hf : work c≤fuel) :
    fromArena capacity a i fuel s=some (WordRAM020.run i c s).1 := by
  have hsp : a.sp.val=1 := (logical_length a mu [.code c] hi).symm
  have hv := ArenaDecode020E1.view_singleton a hsp
  have hp : (ArenaStack020E1.peek a 0).val<a.used.val := hi.2.1 _ (by rw [hv];simp)
  have hm := hi.2.2.2
  rw [hv,List.map_cons,List.map_nil] at hm
  have he : mu (ArenaStack020E1.peek a 0).val=.code c := (List.cons.inj hm).1
  let z := BoundedStack020E3.empty capacity (Frame.run (0 : Ptr cap))
  have hz : z.sp.val<capacity := by
    have hr := FrameReserve020E3.length_le_reserve [c]
    change 0<capacity
    simp only [List.length_singleton] at hr
    omega
  let st := put z (.run (ArenaStack020E1.peek a 0)) hz
  have hs : view st=[.run (ArenaStack020E1.peek a 0)] := view_put z _ hz
  have rel : Related a mu (view st) [c] := by
    rw [hs]
    exact List.Forall₂.cons (Rel.run _ c hp he hc) List.Forall₂.nil
  rw [fromArena,ite_eq_left hsp,(push_correct z _ hz).1,Option.bind_some]
  rw [BankExecute020E3.correct a i mu hi.1 fuel st [c] s rel room]
  exact ControlStack020E.correct i fuel [c] s (by simpa only [total,Nat.add_zero] using hf)

def frameCapacity : Nat := 28941

def actual (i : Input) (s : State) : Option State :=
  ArenaProgram020E1.actual.bind (fun a => fromArena frameCapacity a i NodeProgram020E2.controlLimit s)

theorem actual_correct (i : Input) (s : State) :
    actual i s=some (WordRAM020.run i PairProgram020.program s).1 := by
  have hc : SyntaxLegal020E.maxCap PairProgram020.program<2^511 := by rw [ProgramResources020E.cap_value];norm_num
  obtain ⟨a,mu,ha,hi,_⟩ := ArenaProgram020E1.build_invariant 877 PairProgram020.program hc
    (by rw [ProgramCost020.program_nodes])
  have ha' : ArenaProgram020E1.actual=some a := ha
  rw [actual,ha',Option.bind_some]
  exact invariant_correct frameCapacity a i s mu PairProgram020.program hi hc
    FrameReserve020E3.actual_reserve NodeProgram020E2.controlLimit NodeProgram020E2.work_fits

theorem node_execution_eq (i : Input) (s : State) : actual i s=NodeProgram020E2.actual i s := by
  rw [actual_correct,NodeProgram020E2.actual_correct]

theorem public_initial (h : Rq) (tape : Bits tapeSize) :
    ∃ t : State,actual (InputLayout020.encode h tape) initial=some t ∧ t.fault=false ∧
      List.ofFn t.out=PairEncoding020.encode ((StandaloneRuntime019.publicCode h).code tape) := by
  rw [node_execution_eq]
  exact NodeProgram020E2.public_initial h tape

end FT1536.S05.BankProgram020E3
