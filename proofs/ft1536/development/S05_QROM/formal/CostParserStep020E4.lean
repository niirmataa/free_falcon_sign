import CostParserRead020E4

namespace FT1536.S05.CostParserStep020E4
open SyntaxTape020E ArenaTypes020E1 CostRun020E4 CostFlow020E4

def commit {cap : Nat} (a : ArrayArena020E4.Arena cap) (t : Token) (n : Node cap)
    (hu : a.used.val<cap) (hr : a.sp.val-arity t<cap) : Run (ArrayArena020E4.Arena cap) := overhead 12
  (CostRun020E4.bind (CostBank020E4.write 5 a.bank ⟨a.used.val,hu⟩ n) (fun bank =>
    CostRun020E4.map (fun stack => ⟨bank,stack,⟨a.used.val+1,by omega⟩,⟨a.sp.val-arity t+1,by omega⟩⟩)
      (CostBank020E4.write 1 a.stack ⟨a.sp.val-arity t,hr⟩ a.used)))

def step {cap : Nat} (t : Token) (a : ArrayArena020E4.Arena cap) : Run (Option (ArrayArena020E4.Arena cap)) := overhead 32
  (if hu : a.used.val<cap then
    if arity t≤a.sp.val then
      if hr : a.sp.val-arity t<cap then
        CostRun020E4.bind (CostParserRead020E4.fresh a t) (fun n =>
          CostRun020E4.bind (CostParserRead020E4.kinds a (children t n)) (fun ks => overhead 32
            (if ks=(needs t).map some then CostRun020E4.map some (commit a t n hu hr) else CostRun020E4.pure none)))
      else CostRun020E4.pure none
    else CostRun020E4.pure none
  else CostRun020E4.pure none)

def commitPrice (cap : Nat) : Nat := 12+(CostBank020E4.writePrice cap 5+CostBank020E4.writePrice cap 1)
def price (cap : Nat) : Nat := 313+commitPrice cap

theorem commit_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (t : Token)
    (hu : a.used.val<cap) (hr : a.sp.val-arity t<cap) :
    (commit a t (ArenaStackRead020E1.freshNode (ArrayArena020E4.model a) t) hu hr).value=ArrayArena020E4.commit a t hu hr := by
  simp only [commit,overhead_value,CostRun020E4.bind_value,CostRun020E4.map,CostBank020E4.write_value,ArrayArena020E4.commit]

theorem commit_budget {cap : Nat} (a : ArrayArena020E4.Arena cap) (t : Token) (n : Node cap)
    (hu : a.used.val<cap) (hr : a.sp.val-arity t<cap) :
    Bounded (commit a t n hu hr) (commitPrice cap) (commitPrice cap) := ⟨le_rfl,le_rfl⟩

theorem value {cap : Nat} (t : Token) (a : ArrayArena020E4.Arena cap) :
    (step t a).value=ArrayArena020E4.step t a := by
  unfold step ArrayArena020E4.step
  split
  · split
    · split
      · simp only [overhead_value,CostRun020E4.bind_value,CostParserRead020E4.fresh_value,CostParserRead020E4.kinds_value]
        split
        · simp only [CostRun020E4.map,commit_value]
        · rfl
      · rfl
    · rfl
  · rfl

theorem bound {cap : Nat} (t : Token) (a : ArrayArena020E4.Arena cap) : Bounded (step t a) (price cap) (price cap) := by
  unfold step
  split
  · split
    · split
      · apply CostBounds020E4.weaken (overhead_bound 32 (61+(188+(32+commitPrice cap)))
          (61+(188+(32+commitPrice cap))) _ ?_) (by unfold price;omega) (by unfold price;omega)
        apply bind_bound _ _ 61 61 _ _ (CostParserRead020E4.fresh_bound a t)
        intro n
        apply bind_bound _ _ 188 188 (32+commitPrice cap) (32+commitPrice cap)
        · have h := CostParserRead020E4.kinds_bound a (children t n)
          have ht := arity_bound t
          exact CostBounds020E4.weaken h (by rw [children_length];omega) (by rw [children_length];omega)
        · intro ks
          apply overhead_bound 32 (commitPrice cap) (commitPrice cap)
          split
          · exact commit_budget a t n _ _
          · exact ⟨Nat.zero_le _,Nat.zero_le _⟩
      · constructor <;> change 32≤price cap <;> unfold price <;> omega
    · constructor <;> change 32≤price cap <;> unfold price <;> omega
  · constructor <;> change 32≤price cap <;> unfold price <;> omega

end FT1536.S05.CostParserStep020E4
