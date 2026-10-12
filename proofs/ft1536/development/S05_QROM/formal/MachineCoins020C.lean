import SeedSlices020C
import VectorValues020C

namespace FT1536.S05.MachineCoins020C
open WordRAM020 JointInterface019 BitValue020A TrialCorrect020A TrialAddress020A
open TapeIndex020C SeedSlices020C
open FT1536.Relation

theorem norm_bit (h : Rq) (t : Bits tapeSize) (n : Fin 196) (p : Fin 1536)
    (k : Fin 80) (j : Fin 1024) :
    tapeBits (InputLayout020.encode h t) (base n.val p.val k.val+j.val)=normBlock t n p k j := by
  have hb := (window n.val p.val k.val n.isLt p.isLt k.isLt).2
  exact tapeBits_at (InputLayout020.encode h t) ⟨base n.val p.val k.val+j.val,by omega⟩

theorem trial_coins (h : Rq) (t : Bits tapeSize) (n : Fin 196) (p : Fin 1536) (k : Fin 80) :
    coinsAt (InputLayout020.encode h t) (base n.val p.val k.val)=
      StandaloneRuntime019.pairEquiv (normBlock t n p k) := by
  apply Prod.ext
  · funext j
    rw [pair_first]
    exact norm_bit h t n p k ⟨j.val,by omega⟩
  · apply Prod.ext
    · funext j
      rw [pair_second]
      have hb := norm_bit h t n p k ⟨384+j.val,by omega⟩
      simpa only [coinsAt,Nat.add_assoc] using hb
    · funext j
      rw [pair_acceptance]
      have hb := norm_bit h t n p k ⟨768+j.val,by omega⟩
      simpa only [coinsAt,Nat.add_assoc] using hb

theorem left_coins (h : Rq) (t : Bits tapeSize) (n : Fin 196) (p : Fin 768) :
    ((StandaloneRuntime019.seedEquiv t).1 n).1 p=
      CapDraw020B.coins (InputLayout020.encode h t) n.val p.val := by
  funext k
  exact (norm_left t n p k).trans (trial_coins h t n ⟨p.val,by omega⟩ k).symm

theorem right_coins (h : Rq) (t : Bits tapeSize) (n : Fin 196) (p : Fin 768) :
    ((StandaloneRuntime019.seedEquiv t).1 n).2 p=
      CapDraw020B.coins (InputLayout020.encode h t) n.val (768+p.val) := by
  funext k
  exact (norm_right t n p k).trans (trial_coins h t n ⟨768+p.val,by omega⟩ k).symm

end FT1536.S05.MachineCoins020C
