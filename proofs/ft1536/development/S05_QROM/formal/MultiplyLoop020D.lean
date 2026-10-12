import MultiplyRow020D
import ClearBuffer020D
import BufferTransport020D

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.MultiplyLoop020D
open WordRAM020 PairProgram020 ReadSemantics020A Residue020D BufferField020D
open ActualScatter020D ScatterSums020D
open FT1536.Relation JointInterface019
attribute [local irreducible] exec loopState outer

def Good (z : StandaloneRuntime019.CachedBox) (h : Rq) (k : Nat) (s : State) : Prop :=
  s.reg 21=word (k:Int) ∧ Holds s (outer h (noise z) k) ∧ BoxImage020C.readVec s=BoxImage020C.image z
def code (count : Nat) : Code := seqs [set 21 (lit 0),.loop count (lit 1) MultiplyRow020D.body]

theorem step (h : Rq) (tape : Bits tapeSize) (z : StandaloneRuntime019.CachedBox)
    (k : Nat) (s : State) (hk : k<1536) (hs : Good z h k s) :
    Good z h (k+1) (exec (InputLayout020.encode h tape) MultiplyRow020D.body s) ∧
      BufferField020D.Frame s (exec (InputLayout020.encode h tape) MultiplyRow020D.body s) := by
  have post := MultiplyRow020D.body_correct h tape s z ⟨k,hk⟩ (outer h (noise z) k) hs.1 hs.2.1 hs.2.2
  have ev : (fun r => outer h (noise z) k r+row h (noise z) ⟨k,hk⟩ 1536 r)=outer h (noise z) (k+1) := by
    funext r;exact (outer_succ _ _ k hk r).symm
  refine ⟨⟨post.2.2,?_,(frame_image post.2.1).trans hs.2.2⟩,post.2.1⟩
  rw [←ev];exact post.1

theorem loop_correct (h : Rq) (tape : Bits tapeSize) (z : StandaloneRuntime019.CachedBox)
    (count k : Nat) (s : State) (hb : k+count≤1536) (hs : Good z h k s) :
    let t := loopState (exec (InputLayout020.encode h tape) MultiplyRow020D.body) (lit 1) count s
    Good z h (k+count) t ∧ BufferField020D.Frame s t :=
  CountedLoop020C.counted (exec (InputLayout020.encode h tape) MultiplyRow020D.body) (lit 1)
    (Good z h) BufferField020D.Frame 1536 BufferField020D.frame_refl
    (fun a b => BufferField020D.frame_trans a b)
    (fun j q hj hq => ⟨VectorLoopCore020C.guard_true q,step h tape z j q hj hq⟩) count k s hb hs

theorem code_shape (i : Input) (count : Nat) (s : State) :
    exec i (code count) s=loopState (exec i MultiplyRow020D.body) (lit 1) count (put s 21 (word 0)) := by
  simp only [code,exec_seqs_cons,exec_seqs_nil,exec_set,exec_loop]
  rfl

theorem code_correct (h : Rq) (tape : Bits tapeSize) (z : StandaloneRuntime019.CachedBox)
    (count : Nat) (s : State) (hc : count≤1536)
    (hv : Holds s (fun _ => 0)) (hz : BoxImage020C.readVec s=BoxImage020C.image z) :
    let i := InputLayout020.encode h tape
    Good z h count (exec i (code count) s) ∧ BufferField020D.Frame s (exec i (code count) s) := by
  let q := put s 21 (word 0)
  have g0 : Good z h 0 q := by
    refine ⟨put_same _ _ _,?_,hz⟩
    intro r
    change s.ram (BufferUpdate020D.slot r)=fw (outer h (noise z) 0 r)
    rw [outer_zero]
    exact hv r
  have post := loop_correct h tape z count 0 q (by omega) g0
  change Good z h (0+count) (loopState (exec (InputLayout020.encode h tape) MultiplyRow020D.body) (lit 1) count q) ∧
    BufferField020D.Frame q (loopState (exec (InputLayout020.encode h tape) MultiplyRow020D.body) (lit 1) count q) at post
  rw [Nat.zero_add] at post
  dsimp only
  rw [code_shape]
  exact ⟨post.1,BufferField020D.frame_trans ⟨rfl,rfl,fun _ _ => rfl⟩ post.2⟩

theorem multiply_shape (i : Input) (s : State) :
    exec i multiply s=exec i (code 1536) (exec i (ClearBuffer020D.code 1536) s) :=
  CdfStep020A.seqs_append i [set 21 (lit 0),.loop 1536 (lit 1) ClearBuffer020D.body]
    [set 21 (lit 0),.loop 1536 (lit 1) MultiplyRow020D.body] s

/-- Original multiply code, not a replacement. All key-load, signed-data,
    branch and loop premises have actual instances. -/
theorem multiply_outer (h : Rq) (tape : Bits tapeSize) (z : StandaloneRuntime019.CachedBox)
    (s : State) (hz : BoxImage020C.readVec s=BoxImage020C.image z) :
    let i := InputLayout020.encode h tape
    Holds (exec i multiply s) (outer h (noise z) 1536) ∧
      BufferField020D.Frame s (exec i multiply s) := by
  let i := InputLayout020.encode h tape
  let q := exec i (ClearBuffer020D.code 1536) s
  have clear := ClearBuffer020D.clear_correct i s
  have post := code_correct h tape z 1536 q (by decide) clear.1 ((frame_image clear.2).trans hz)
  dsimp only
  rw [multiply_shape]
  exact ⟨post.1.2.1,BufferField020D.frame_trans clear.2 post.2⟩

theorem multiply_correct (h : Rq) (tape : Bits tapeSize) (z : StandaloneRuntime019.CachedBox)
    (s : State) (hz : BoxImage020C.readVec s=BoxImage020C.image z) :
    let i := InputLayout020.encode h tape
    Holds (exec i multiply s) (fun r => (StandaloneRuntime019.Scatter.multiply h (noise z))[r.val]) ∧
      BufferField020D.Frame s (exec i multiply s) :=
  ⟨BufferTransport020D.holds_congr _ _ _ (multiply_outer h tape z s hz).1
    (original_multiply h (noise z)),(multiply_outer h tape z s hz).2⟩

end FT1536.S05.MultiplyLoop020D
