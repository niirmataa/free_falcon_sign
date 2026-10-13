import CostBoot020E4
import CostExecute020E4
import ArrayProgram020E4

namespace FT1536.S05.CostProgram020E4
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 CostRun020E4 CostFlow020E4

def frames (cap capacity : Nat) : Run (CostFrames020E4.Stack cap capacity) := overhead 2
  (CostRun020E4.map (fun bank => ⟨bank,0⟩)
    (CostBank020E4.zero capacity 3 (Frame.run (0 : Ptr cap))))

def fromArena {cap : Nat} (capacity : Nat) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (fuel : Nat) (s : ArrayState020E4.State) : Run (Option ArrayState020E4.State) := overhead 4
  (if a.sp.val=1 then CostRun020E4.bind (frames cap capacity) (fun st =>
    CostRun020E4.bind (CostParserRead020E4.peek a 0) (fun root =>
      optBind (CostFrames020E4.push st (.run root)) (fun q => CostExecute020E4.execute a i fuel q s)))
   else CostRun020E4.pure none)

def fromPrice (cap capacity fuel : Nat) : Nat :=
  4+((6+capacity*7)+(7+(CostFrames020E4.pushPrice capacity+1+CostExecute020E4.price cap capacity fuel)))

theorem frames_value (cap capacity : Nat) : (frames cap capacity).value=
    ArrayFrames020E4.empty capacity (Frame.run (0 : Ptr cap)) := by
  simp only [frames,overhead_value,CostRun020E4.map,CostBank020E4.zero_value,ArrayFrames020E4.empty]

theorem frames_bound (cap capacity : Nat) : Bounded (frames cap capacity) (6+capacity*7) (6+capacity*7) := by
  have h := CostBank020E4.zero_budget capacity 3 (Frame.run (0 : Ptr cap))
  constructor <;> dsimp [frames,overhead,CostRun020E4.map] <;> omega

theorem from_value {cap : Nat} (capacity : Nat) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (fuel : Nat) (s : ArrayState020E4.State) :
    (fromArena capacity a i fuel s).value=ArrayProgram020E4.fromArena capacity a i fuel s := by
  unfold fromArena ArrayProgram020E4.fromArena
  split
  · simp only [overhead_value,CostRun020E4.bind_value,frames_value,CostParserRead020E4.peek_value,
      optBind_value,CostFrames020E4.push_value,CostExecute020E4.value]
  · rfl

theorem from_bound {cap : Nat} (capacity : Nat) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (fuel : Nat) (s : ArrayState020E4.State) :
    Bounded (fromArena capacity a i fuel s) (fromPrice cap capacity fuel) (fromPrice cap capacity fuel) := by
  unfold fromArena
  split
  · apply overhead_bound 4 _ _
    apply bind_bound _ _ (6+capacity*7) (6+capacity*7) _ _ (frames_bound cap capacity)
    intro st
    apply bind_bound _ _ 7 7 _ _ (CostParserRead020E4.peek_bound a 0)
    intro root
    exact optBind_bound _ _ _ _ _ _ (CostFrames020E4.push_bound st (.run root))
      (fun q => CostExecute020E4.bound a i fuel q s)
  · constructor <;> change 4≤fromPrice cap capacity fuel <;> unfold fromPrice <;> omega

def actual (i : ArrayState020E4.Input) (s : ArrayState020E4.State) : Run (Option ArrayState020E4.State) :=
  optBind CostBoot020E4.boot (fun a => fromArena BankProgram020E3.frameCapacity a i NodeProgram020E2.controlLimit s)

def price : Nat := CostBoot020E4.price+1+fromPrice 877 BankProgram020E3.frameCapacity NodeProgram020E2.controlLimit

theorem value (i : ArrayState020E4.Input) (s : ArrayState020E4.State) :
    (actual i s).value=ArrayProgram020E4.actual i s := by
  simp only [actual,optBind_value,CostBoot020E4.value,from_value,ArrayProgram020E4.actual]

theorem bound (i : ArrayState020E4.Input) (s : ArrayState020E4.State) : Bounded (actual i s) price price :=
  optBind_bound _ _ _ _ _ _ CostBoot020E4.bound (fun a => from_bound _ a i _ s)

end FT1536.S05.CostProgram020E4
