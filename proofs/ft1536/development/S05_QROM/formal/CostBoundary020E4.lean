import CostInput020E4
import ArrayDriver020E4

namespace FT1536.S05.CostBoundary020E4
open WordRAM020 CostRun020E4 CostFlow020E4

def initial : Run ArrayState020E4.State := overhead 4
  (CostRun020E4.bind (CostBank020E4.zero 32 1 (0 : Word)) (fun reg =>
    CostRun020E4.bind (CostBank020E4.zero ramSize 1 (0 : Word)) (fun ram =>
      CostRun020E4.map (fun out => ⟨reg,ram,out,false⟩) (CostBank020E4.zero outputSize 1 false))))

def copy (out : ArrayBank020E4.Bank Bool outputSize) : Run (ArrayBank020E4.Bank Bool outputSize) :=
  CostBank020E4.tabulate 1 (CostBank020E4.read 1 out)

def initialPrice : Nat := 4+((4+32*5)+((4+ramSize*5)+(4+outputSize*5)))
def copyPrice : Nat := 4+outputSize*5+outputSize*3

theorem initial_value : initial.value=ArrayState020E4.initial := by
  simp only [initial,overhead_value,CostRun020E4.bind_value,CostBank020E4.zero_value,CostRun020E4.map,ArrayState020E4.initial]

theorem initial_bound : Bounded initial initialPrice initialPrice := by
  apply overhead_bound 4 _ _
  apply bind_bound _ _ (4+32*5) (4+32*5) _ _
  · exact ⟨(CostBank020E4.zero_budget 32 1 (0 : Word)).1.le,(CostBank020E4.zero_budget 32 1 (0 : Word)).2.le⟩
  · intro reg
    apply bind_bound _ _ (4+ramSize*5) (4+ramSize*5) (4+outputSize*5) (4+outputSize*5)
    · exact ⟨(CostBank020E4.zero_budget ramSize 1 (0 : Word)).1.le,(CostBank020E4.zero_budget ramSize 1 (0 : Word)).2.le⟩
    · intro ram
      exact ⟨(CostBank020E4.zero_budget outputSize 1 false).1.le,(CostBank020E4.zero_budget outputSize 1 false).2.le⟩

theorem copy_value (out : ArrayBank020E4.Bank Bool outputSize) : (copy out).value=out :=
  ArrayBank020E4.load_read out

theorem copy_bound (out : ArrayBank020E4.Bank Bool outputSize) : Bounded (copy out) copyPrice copyPrice :=
  CostBank020E4.tabulate_bound 1 3 3 (CostBank020E4.read 1 out) (fun _ => ⟨le_rfl,le_rfl⟩)

end FT1536.S05.CostBoundary020E4
