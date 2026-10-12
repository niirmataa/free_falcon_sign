import ScatterSums020D
import CountedLoop020C
import VectorLoopCore020C

namespace FT1536.S05.ScatterRow020D
open WordRAM020 PairProgram020 ReadSemantics020A Residue020D Interleaved020D IndexReference020D
open BufferField020D ActualScatter020D ScatterSums020D
open FT1536.Relation FT1536.Run2.PolynomialReference
attribute [local irreducible] exec loopState row

def Good (z : StandaloneRuntime019.CachedBox) (h : Rq) (p : Fin 1536) (v : Coeffs)
    (k : Nat) (s : State) : Prop :=
  s.reg 22=word (k:Int) ∧ Holds s (fun r => v r+row h (noise z) p k r) ∧
  BoxImage020C.readVec s=BoxImage020C.image z ∧ s.reg 18=fw (coefficient h (term p)) ∧
  s.reg 23=word (exponentN p.val:Int) ∧ s.reg 21=word (p.val:Int)
def code (count : Nat) : Code := seqs [set 22 (lit 0),.loop count (lit 1) scatterTerm]

theorem step (i : Input) (z : StandaloneRuntime019.CachedBox) (h : Rq) (p : Fin 1536)
    (v : Coeffs) (k : Nat) (s : State) (hk : k<1536) (hs : Good z h p v k s) :
    Good z h p v (k+1) (exec i scatterTerm s) ∧ BufferField020D.Frame s (exec i scatterTerm s) := by
  have post := ActualScatter020D.term_correct i s z h p ⟨k,hk⟩ _ hs.2.2.1 hs.2.1 hs.1 hs.2.2.2.2.1 hs.2.2.2.1
  have ev : (fun r => (v r+row h (noise z) p k r)+contribution h (noise z) p ⟨k,hk⟩ r)=
      (fun r => v r+row h (noise z) p (k+1) r) := by
    funext r
    rw [row_succ _ _ _ _ hk]
    exact add_assoc _ _ _
  refine ⟨⟨post.2.2.1,?_,(frame_image post.2.1).trans hs.2.2.1,post.2.2.2.1,
    post.2.2.2.2.1,post.2.2.2.2.2.trans hs.2.2.2.2.2⟩,post.2.1⟩
  rw [←ev]
  exact post.1

theorem loop_correct (i : Input) (z : StandaloneRuntime019.CachedBox) (h : Rq) (p : Fin 1536)
    (v : Coeffs) (count k : Nat) (s : State) (hb : k+count≤1536) (hs : Good z h p v k s) :
    let t := loopState (exec i scatterTerm) (lit 1) count s
    Good z h p v (k+count) t ∧ BufferField020D.Frame s t :=
  CountedLoop020C.counted (exec i scatterTerm) (lit 1) (Good z h p v) BufferField020D.Frame 1536
    BufferField020D.frame_refl (fun a b => BufferField020D.frame_trans a b)
    (fun j q hj hq => ⟨VectorLoopCore020C.guard_true q,step i z h p v j q hj hq⟩) count k s hb hs

theorem code_shape (i : Input) (count : Nat) (s : State) :
    exec i (code count) s=loopState (exec i scatterTerm) (lit 1) count (put s 22 (word 0)) := by
  simp only [code,exec_seqs_cons,exec_seqs_nil,exec_set,exec_loop]
  rfl

theorem code_correct (i : Input) (z : StandaloneRuntime019.CachedBox) (h : Rq) (p : Fin 1536)
    (v : Coeffs) (count : Nat) (s : State) (hc : count≤1536)
    (hv : Holds s v) (hz : BoxImage020C.readVec s=BoxImage020C.image z)
    (h18 : s.reg 18=fw (coefficient h (term p))) (h23 : s.reg 23=word (exponentN p.val:Int))
    (h21 : s.reg 21=word (p.val:Int)) :
    Good z h p v count (exec i (code count) s) ∧ BufferField020D.Frame s (exec i (code count) s) := by
  let q := put s 22 (word 0)
  have g0 : Good z h p v 0 q := by
    refine ⟨put_same _ _ _,?_,hz,?_,?_,?_⟩
    · intro r
      change s.ram (BufferUpdate020D.slot r)=fw (v r+row h (noise z) p 0 r)
      rw [row_zero,add_zero]
      exact hv r
    · exact (put_other s 22 18 _ (by decide)).trans h18
    · exact (put_other s 22 23 _ (by decide)).trans h23
    · exact (put_other s 22 21 _ (by decide)).trans h21
  have post := loop_correct i z h p v count 0 q (by omega) g0
  change Good z h p v (0+count) (loopState (exec i scatterTerm) (lit 1) count q) ∧
    BufferField020D.Frame q (loopState (exec i scatterTerm) (lit 1) count q) at post
  rw [Nat.zero_add] at post
  rw [code_shape]
  exact ⟨post.1,BufferField020D.frame_trans ⟨rfl,rfl,fun _ _ => rfl⟩ post.2⟩

end FT1536.S05.ScatterRow020D
