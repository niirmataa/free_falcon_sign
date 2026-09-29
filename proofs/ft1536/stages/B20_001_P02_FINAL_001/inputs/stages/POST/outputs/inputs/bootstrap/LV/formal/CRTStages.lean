import Evaluation
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Forward
open FT1536Global

def blockBase (h pos : Nat) : Nat := (pos/h)*h
def rootLabel (pos : Nat) : Int := if pos<768 then 14649 else 1-14649
def splitLabel (m h pos : Nat) : Int :=
  let s:=ordinary (gmAt (m+pos/(2*h)))
  if h≤pos%(2*h) then -s else s

theorem split_layout (h pos k : Nat) (hh : HalfOK h) (hp : pos<1536) (hk : k<h) :
    let b:=(pos/(2*h))*h+k
    b<768 ∧ b/h=pos/(2*h) ∧
    pairAddr h b false=blockBase (2*h) pos+k ∧
    pairAddr h b true=blockBase (2*h) pos+(h+k) ∧
    (if h≤pos%(2*h) then pairAddr h b true else pairAddr h b false)=blockBase h pos+k := by
  rcases hh with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl
  all_goals
    dsimp [pairAddr,blockBase]
    split <;> omega

theorem binary_block_coefficient (h m pos k : Nat) (hh : HalfOK h) (hp : pos<1536) (hk : k<h) (s : Mem) :
    pairStage h (forwardBinaryOp m h) s (blockBase h pos+k)=
      (s (blockBase (2*h) pos+k)+splitLabel m h pos*s (blockBase (2*h) pos+(h+k)))%18433 := by
  obtain ⟨hb,div,a0,a1,child⟩:=split_layout h pos k hh hp hk
  have hc:=binary_coefficients h m hh s ((pos/(2*h))*h+k) hb
  rw [a0,a1,div] at hc
  by_cases side : h≤pos%(2*h)
  · rw [ite_eq_left side,a1] at child
    rw [←child,hc.2]
    simp only [splitLabel,ite_eq_left side,Int.neg_mul]
    rw [Int.mul_comm (ordinary (gmAt (m+pos/(2*h)))),Int.sub_eq_add_neg]
  · rw [ite_eq_right side,a0] at child
    rw [←child,hc.1]
    simp only [splitLabel,ite_eq_right side,Int.mul_comm]

theorem binary_block_eval (h m pos : Nat) (hh : HalfOK h) (hp : pos<1536)
    (s : Mem) (z : Int) (hz : z^h%18433=splitLabel m h pos%18433) :
    blockEval h (blockBase h pos) (pairStage h (forwardBinaryOp m h) s) z=
      blockEval (2*h) (blockBase (2*h) pos) s z := by
  unfold blockEval
  calc
    peval h (fun k => pairStage h (forwardBinaryOp m h) s (blockBase h pos+k)) z =
        peval h (fun k => (s (blockBase (2*h) pos+k)+splitLabel m h pos*s (blockBase (2*h) pos+(h+k)))%18433) z := by
      apply eval_congr
      intro k hk; rw [binary_block_coefficient h m pos k hh hp hk s]
    _ = peval (2*h) (fun k => s (blockBase (2*h) pos+k)) z := by
      simpa only [Nat.two_mul] using split_preserves_eval h (fun k => s (blockBase (2*h) pos+k)) (splitLabel m h pos) z hz

theorem root_block_eval (pos : Nat) (hp : pos<1536) (s : Mem) (z : Int)
    (hz : z^768%18433=rootLabel pos%18433) :
    blockEval 768 (blockBase 768 pos) (pairStage 768 forwardRootOp s) z=peval 1536 s z := by
  have hc : ∀ k, k<768 → pairStage 768 forwardRootOp s (blockBase 768 pos+k)=
      (s k+rootLabel pos*s (768+k))%18433 := by
    intro k hk
    have hr:=root_coefficients s k hk
    by_cases side : pos<768
    · have hb : blockBase 768 pos=0 := by unfold blockBase; omega
      simpa [rootLabel,side,hb,Nat.add_comm] using hr.1
    · have hb : blockBase 768 pos=768 := by unfold blockBase; omega
      simpa only [rootLabel,ite_eq_right side,hb,Nat.add_comm] using hr.2
  unfold blockEval
  calc
    peval 768 (fun k => pairStage 768 forwardRootOp s (blockBase 768 pos+k)) z =
        peval 768 (fun k => (s k+rootLabel pos*s (768+k))%18433) z := by
      apply eval_congr; intro k hk; rw [hc k hk]
    _ = peval 1536 s z := split_preserves_eval 768 s (rootLabel pos) z hz

#check @binary_block_eval
#check @root_block_eval
#print axioms split_layout
#print axioms binary_block_coefficient
#print axioms binary_block_eval
#print axioms root_block_eval
end FT1536Forward
