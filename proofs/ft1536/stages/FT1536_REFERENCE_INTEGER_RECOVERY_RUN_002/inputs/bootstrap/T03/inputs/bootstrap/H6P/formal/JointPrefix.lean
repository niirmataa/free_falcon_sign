import JointOrder
namespace OrderedJoint
inductive Reach {S : Type} (step : S→S→Prop) (s : S) : S→Prop
  | entry : Reach step s s
  | next {a b} : Reach step s a → step a b → Reach step s b
inductive SupportPrefix {S Y : Type} (step : S→Y→S) (support : S→Y→Prop) (s : S) : S→List Y→Prop
  | nil : SupportPrefix step support s s []
  | snoc {a ys y} : SupportPrefix step support s a ys → support a y → SupportPrefix step support s (step a y) (ys++[y])
theorem support_realizes {S Y : Type} (step : S→Y→S) (support : S→Y→Prop)
    (sourceStep : S→S→Prop) (s a : S) (ys : List Y)
    (witness : ∀b y,Reach sourceStep s b→support b y→sourceStep b (step b y))
    (h : SupportPrefix step support s a ys) : Reach sourceStep s a := by
  induction h with
  | nil => exact .entry
  | snoc h hs ih => exact .next ih (witness _ _ ih hs)
theorem before_next {S Y : Type} (step : S→Y→S) (support : S→Y→Prop)
    (sourceStep : S→S→Prop) (legal : S→Prop) (s a : S) (ys : List Y)
    (witness : ∀b y,Reach sourceStep s b→support b y→sourceStep b (step b y))
    (forward : ∀b,Reach sourceStep s b→legal b)
    (h : SupportPrefix step support s a ys) : legal a := by
  exact forward a (support_realizes step support sourceStep s a ys witness h)
def valueRun {S Y : Type} (step : S→Y→S) (s : S) (ys : List Y) := ys.foldl step s
theorem same_value_projection {S Y : Type} (step : S→Y→S) (s : S) (ys zs : List Y)
    (h : ys=zs) : valueRun step s ys=valueRun step s zs := by rw [h]
theorem zero_atom_not_support (n : Nat) : (0<n)→n≠0 := by omega
theorem positive_atom_has_element {A : Type} (xs : List A) (h : 0<xs.length) : ∃a,a∈xs := by
  cases xs with
  | nil => simp at h
  | cons a xs => exact ⟨a,by simp⟩
theorem paired_terminal_identity (r0 r1 u e : Int) (h : 2*r0+r1=2*u+e) :
    4*(r0*r0+r0*r1+r1*r1)=(2*u+e)^2+3*r1^2 := by
  have hh:=LeftRoot.terminal_defect_identity r0 r1 u e h
  grind
end OrderedJoint
