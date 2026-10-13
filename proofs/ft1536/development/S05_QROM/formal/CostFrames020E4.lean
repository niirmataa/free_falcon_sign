import CostBank020E4
import CostFlow020E4
import ArrayFrames020E4
import NodeFrames020E2

namespace FT1536.S05.CostFrames020E4
open CostRun020E4 CostFlow020E4 NodeFrames020E2

abbrev Stack (cap capacity : Nat) := ArrayFrames020E4.Stack (Frame cap) capacity

def top {cap capacity : Nat} (s : Stack cap capacity) : Run (Option (Frame cap)) := overhead 3
  (if h : 0<s.sp.val then CostRun020E4.map some
    (CostBank020E4.read 3 s.bank ⟨s.sp.val-1,by have := s.sp.isLt;omega⟩)
   else CostRun020E4.pure none)

def drop {cap capacity : Nat} (s : Stack cap capacity) (n : Nat) : Run (Stack cap capacity) :=
  charge 4 4 (ArrayFrames020E4.drop s n)

def push {cap capacity : Nat} (s : Stack cap capacity) (f : Frame cap) : Run (Option (Stack cap capacity)) := overhead 4
  (if h : s.sp.val<capacity then CostRun020E4.map
    (fun b => some (⟨b,⟨s.sp.val+1,by omega⟩⟩ : Stack cap capacity))
    (CostBank020E4.write 3 s.bank ⟨s.sp.val,h⟩ f)
   else CostRun020E4.pure none)

def pushMany {cap capacity : Nat} (s : Stack cap capacity) : List (Frame cap) → Run (Option (Stack cap capacity))
  | [] => charge 2 2 (some s)
  | f::fs => overhead 2 (optBind (pushMany s fs) (fun t => push t f))

def pushPrice (capacity : Nat) : Nat := 4+CostBank020E4.writePrice capacity 3

theorem top_value {cap capacity : Nat} (s : Stack cap capacity) : (top s).value=ArrayFrames020E4.top s := by
  unfold top ArrayFrames020E4.top
  split <;> rfl

theorem top_bound {cap capacity : Nat} (s : Stack cap capacity) : Bounded (top s) 8 8 := by
  unfold top
  split <;> norm_num [Bounded,overhead,CostRun020E4.map,CostBank020E4.read,charge,CostRun020E4.pure]

theorem push_value {cap capacity : Nat} (s : Stack cap capacity) (f : Frame cap) :
    (push s f).value=ArrayFrames020E4.push s f := by
  unfold push ArrayFrames020E4.push
  split
  · simp only [overhead,CostRun020E4.map,CostBank020E4.write_value]
    rfl
  · rfl

theorem push_bound {cap capacity : Nat} (s : Stack cap capacity) (f : Frame cap) :
    Bounded (push s f) (pushPrice capacity) (pushPrice capacity) := by
  unfold push
  split
  · exact ⟨le_rfl,le_rfl⟩
  · simp only [Bounded,overhead,CostRun020E4.pure,pushPrice]
    constructor <;> omega

theorem pushMany_value {cap capacity : Nat} (s : Stack cap capacity) (fs : List (Frame cap)) :
    (pushMany s fs).value=ArrayFrames020E4.pushMany s fs := by
  induction fs generalizing s with
  | nil => rfl
  | cons f fs ih =>
    simp only [pushMany,overhead,optBind_value,ih,ArrayFrames020E4.pushMany,push_value]

theorem pushMany_bound {cap capacity : Nat} (s : Stack cap capacity) (fs : List (Frame cap)) :
    Bounded (pushMany s fs) (2+fs.length*(3+pushPrice capacity)) (2+fs.length*(3+pushPrice capacity)) := by
  induction fs generalizing s with
  | nil => simp [Bounded,pushMany,charge]
  | cons f fs ih =>
    have hb := optBind_bound (pushMany s fs) (fun t => push t f) _ _ _ _ (ih s) (fun t => push_bound t f)
    have h := overhead_bound 2 _ _ _ hb
    rcases h with ⟨ht,hm⟩
    simp only [pushMany,Bounded,List.length_cons]
    constructor <;> nlinarith

end FT1536.S05.CostFrames020E4
