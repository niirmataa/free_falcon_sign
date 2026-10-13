import CostAction020E4
import CostFrames020E4
import ArrayExecute020E4

namespace FT1536.S05.CostExecute020E4
open WordRAM020 NodeFrames020E2 CostRun020E4 CostFlow020E4

def step {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (st : CostFrames020E4.Stack cap capacity) : Run (Option (CostFrames020E4.Stack cap capacity × ArrayState020E4.State)) := overhead 4
  (optBind (CostFrames020E4.top st) (fun f => optBind (CostAction020E4.action a i s f) (fun q =>
    CostRun020E4.bind (CostFrames020E4.drop st 1) (fun dropped =>
      CostRun020E4.map (Option.map (fun t => (t,q.2))) (CostFrames020E4.pushMany dropped q.1)))))

def execute {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) :
    Nat → CostFrames020E4.Stack cap capacity → ArrayState020E4.State → Run (Option ArrayState020E4.State)
  | 0,st,s => charge 4 4 (if st.sp.val=0 then some s else none)
  | fuel+1,st,s => overhead 4 (if st.sp.val=0 then CostRun020E4.pure (some s) else
      optBind (step a i s st) (fun q => execute a i fuel q.1 q.2))

def pushManyPrice (capacity : Nat) : Nat := 2+2*(3+CostFrames020E4.pushPrice capacity)
def stepPrice (cap capacity : Nat) : Nat := 18+CostAction020E4.price cap+pushManyPrice capacity
def price (cap capacity fuel : Nat) : Nat := 4+fuel*(5+stepPrice cap capacity)

theorem step_value {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (st : CostFrames020E4.Stack cap capacity) :
    (step a i s st).value=ArrayExecute020E4.step a i s st := by
  simp only [step,overhead_value,optBind_value,CostFrames020E4.top_value,CostAction020E4.value,
    CostRun020E4.bind_value,CostFrames020E4.drop,charge,CostRun020E4.map,
    CostFrames020E4.pushMany_value,ArrayExecute020E4.step]

theorem value {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (fuel : Nat) (st : CostFrames020E4.Stack cap capacity) (s : ArrayState020E4.State) :
    (execute a i fuel st s).value=ArrayExecute020E4.execute a i fuel st s := by
  induction fuel generalizing st s with
  | zero => rfl
  | succ fuel ih =>
    simp only [execute,ArrayExecute020E4.execute]
    split
    · rfl
    · simp only [overhead_value,optBind_value,step_value,ih]

theorem step_bound {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (st : CostFrames020E4.Stack cap capacity) :
    Bounded (step a i s st) (stepPrice cap capacity) (stepPrice cap capacity) := by
  apply CostBounds020E4.weaken (overhead_bound 4 (8+1+(CostAction020E4.price cap+1+(4+pushManyPrice capacity)))
    (8+1+(CostAction020E4.price cap+1+(4+pushManyPrice capacity))) _ ?_) (by unfold stepPrice;omega) (by unfold stepPrice;omega)
  apply optBind_bound _ _ 8 8 _ _ (CostFrames020E4.top_bound st)
  intro f
  apply CostBounds020E4.optBind_bound_on _ _ _ _ _ _ (CostAction020E4.bound a i s f)
  intro q hq
  have hlen := CostAction020E4.prefix_bound a i s f q hq
  apply bind_bound _ _ 4 4 (pushManyPrice capacity) (pushManyPrice capacity) ⟨le_rfl,le_rfl⟩
  intro dropped
  have h := CostFrames020E4.pushMany_bound dropped q.1
  exact CostBounds020E4.weaken h
    (by unfold pushManyPrice;exact Nat.add_le_add_left (Nat.mul_le_mul_right _ hlen) 2)
    (by unfold pushManyPrice;exact Nat.add_le_add_left (Nat.mul_le_mul_right _ hlen) 2)

theorem bound {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (fuel : Nat) (st : CostFrames020E4.Stack cap capacity) (s : ArrayState020E4.State) :
    Bounded (execute a i fuel st s) (price cap capacity fuel) (price cap capacity fuel) := by
  induction fuel generalizing st s with
  | zero => simp only [price,Nat.zero_mul,Nat.add_zero,execute,Bounded,charge,le_refl,and_self]
  | succ fuel ih =>
    unfold execute
    split
    · constructor <;> dsimp [overhead,CostRun020E4.pure,price] <;> omega
    · have h := optBind_bound (step a i s st) _ (stepPrice cap capacity) (stepPrice cap capacity)
        (price cap capacity fuel) (price cap capacity fuel) (step_bound a i s st) (fun q => ih q.1 q.2)
      have hh := overhead_bound 4 _ _ _ h
      exact CostBounds020E4.weaken hh (by simp only [price,Nat.add_mul,Nat.one_mul];omega) (by simp only [price,Nat.add_mul,Nat.one_mul];omega)

end FT1536.S05.CostExecute020E4
