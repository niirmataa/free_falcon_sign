import CoreStepCount020E13
import CountedLoopBoundary020E13
import CoreCountBounds020E13

namespace FT1536.S05.CoreDriverCount020E13
open ProducerRawCore020E11 CoreCountTypes020E13
attribute [local irreducible] CoreStepCount020E13.run ProducerRawCore020E11.step
attribute [local irreducible] ProducerStored020E6.invoke ProducerPairCount020E13.run ConsumerCount020E13.consume

def run (c : Context) (fuel : Nat) (m : Memory) : Report (Option Memory) :=
  CountedLoop020E13.run ProducerRawDriver020E11.terminal (CoreStepCount020E13.run c) fuel m

theorem plain (c : Context) (fuel : Nat) (m : Memory) :
    CountedLoop020E13.plain ProducerRawDriver020E11.terminal (ProducerRawCore020E11.step c) fuel m=
      ProducerRawDriver020E11.run c fuel m := by
  induction fuel generalizing m with
  | zero => rfl
  | succ fuel ih =>
    simp only [CountedLoop020E13.plain,ProducerRawDriver020E11.run]
    split
    · rfl
    · apply congrArg ((ProducerRawCore020E11.step c m).bind)
      exact funext ih

theorem value_aux (c : Context) (g : Memory → Report (Option Memory))
    (hg : (fun m => (g m).value)=ProducerRawCore020E11.step c) (fuel : Nat) (m : Memory) :
    (CountedLoop020E13.run ProducerRawDriver020E11.terminal g fuel m).value=ProducerRawDriver020E11.run c fuel m := by
  rw [CountedLoop020E13.value,hg]
  exact plain c fuel m

theorem value_function (c : Context) : (fun fuel m => (run c fuel m).value)=ProducerRawDriver020E11.run c :=
  (funext (fun fuel : Nat => funext (fun m : Memory =>
    value_aux c (CoreStepCount020E13.run c) (funext (CoreStepCount020E13.value c)) fuel m)) :
    (fun fuel m => (CountedLoop020E13.run ProducerRawDriver020E11.terminal (CoreStepCount020E13.run c) fuel m).value)=
      ProducerRawDriver020E11.run c)

theorem value (c : Context) (fuel : Nat) (m : Memory) :
    (run c fuel m).value=ProducerRawDriver020E11.run c fuel m :=
  congrFun (congrFun (value_function c) fuel) m

theorem valid (c : Context) : ∀ (fuel : Nat) (m : Memory), Valid (run c fuel m).counts fuel :=
  (CountedLoop020E13.valid ProducerRawDriver020E11.terminal (CoreStepCount020E13.run c) (CoreStepCount020E13.counts c) :
    ∀ (fuel : Nat) (m : Memory),
      Valid (CountedLoop020E13.run ProducerRawDriver020E11.terminal (CoreStepCount020E13.run c) fuel m).counts fuel)

theorem bound (c : Context) (fuel : Nat) (m : Memory) :
    (run c fuel m).counts.cycles≤14733*fuel ∧ (run c fuel m).counts.slots≤32*fuel ∧
    (run c fuel m).counts.writes≤32*fuel ∧ (run c fuel m).counts.tests≤fuel := CoreCountBounds020E13.bounded _ fuel (valid c fuel m)

theorem stopped (c : Context) (fuel : Nat) (m : Memory) (ht : ProducerRawDriver020E11.terminal m=true) :
    run c (fuel+1) m=⟨some m,test zero⟩ :=
  CountedLoopBoundary020E13.stopped ProducerRawDriver020E11.terminal (CoreStepCount020E13.run c) fuel m ht

theorem malformed (c : Context) (fuel : Nat) (m : Memory)
    (ht : ProducerRawDriver020E11.terminal m=false) (he : ProducerRawCore020E11.step c m=none) :
    run c (fuel+1) m=⟨none,test (CoreStepCount020E13.run c m).counts⟩ := by
  have hv : (CoreStepCount020E13.run c m).value=none := (CoreStepCount020E13.value c m).trans he
  exact CountedLoopBoundary020E13.malformed ProducerRawDriver020E11.terminal (CoreStepCount020E13.run c) fuel m ht hv

end FT1536.S05.CoreDriverCount020E13
