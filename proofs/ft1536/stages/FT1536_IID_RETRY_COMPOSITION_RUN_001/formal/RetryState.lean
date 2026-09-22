import H6PEvent
import SourceBytes
namespace RetryIID
theorem counter_guard (n : Nat) (h : n≤16) :
    (n+1>16 ↔ n=16) ∧ n+1<4294967296 := by omega
theorem reached_index (n : Nat) (h : ¬n+1>16) : 1≤n+1 ∧ n+1≤16 := by omega
theorem guard17_before_init : (17:Nat)>16 := by decide
theorem source_reset_pointer : (0:Nat)<4096 := by decide
def targets {K H T : Type} (build : K→H→T) (key : K) (hm : H) (_old : T) := build key hm
theorem target_overwrite {K H T : Type} (build : K→H→T) (key : K) (hm : H) (old1 old2 : T) :
    targets build key hm old1=targets build key hm old2 := by rfl
inductive Reached {S : Type} (reject : S→S→Prop) (s : S) : S→Prop
  | first : Reached reject s s
  | next {a b} : Reached reject s a → reject a b → Reached reject s b
theorem reentry_induction {S : Type} (ready : S→Prop) (reject : S→S→Prop) (s t : S)
    (h0 : ready s) (preserve : ∀a b,ready a→reject a b→ready b) (h : Reached reject s t) : ready t := by
  induction h with
  | first => exact h0
  | next h step ih => exact preserve _ _ ih step
theorem safe_interfaces (a b : Fin 1536→Int) : H6P.Safe16 a b ↔ Postprocess.Safe16 a b := by rfl
end RetryIID
