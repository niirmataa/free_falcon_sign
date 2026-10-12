import OutputChunks020D
import CountedLoop020C
import VectorLoopCore020C

namespace FT1536.S05.OutputLoop020D
open WordRAM020 PairProgram020 ReadSemantics020A
open FT1536.Run2.BitArithmetic
attribute [local irreducible] exec loopState

def Good (f : Fin 1536 → Nat) (start width : Nat) (hb : start+1536*width≤outputSize)
    (s0 : State) (k : Nat) (s : State) : Prop :=
  s.reg 21=word (k:Int) ∧ s.reg 28=word ((start+width*k:Nat):Int) ∧
    OutputChunks020D.Prefix f start width hb k s.out ∧ s.ram=s0.ram
def Frame (start width : Nat) (s t : State) : Prop :=
  t.ram=s.ram ∧ t.fault=s.fault ∧ OutputChunks020D.Frame start width s.out t.out
def code (body : Code) (count : Nat) : Code := seqs [set 21 (lit 0),.loop count (lit 1) body]

theorem frame_refl (start width : Nat) (s : State) : Frame start width s s :=
  ⟨rfl,rfl,OutputChunks020D.frame_refl _ _ _⟩
theorem frame_trans (start width : Nat) {s t u : State}
    (a : Frame start width s t) (b : Frame start width t u) : Frame start width s u :=
  ⟨b.1.trans a.1,b.2.1.trans a.2.1,OutputChunks020D.frame_trans _ _ a.2.2 b.2.2⟩

def Step (i : Input) (body : Code) (f : Fin 1536 → Nat) (start width : Nat) (s0 : State) : Prop :=
  ∀ (p : Fin 1536) (s : State), s.reg 21=word (p.val:Int) →
    s.reg 28=word ((start+width*p.val:Nat):Int) → s.ram=s0.ram →
    let t := exec i body s
    t.reg 21=word ((p.val+1:Nat):Int) ∧ t.reg 28=word ((start+width*p.val+width:Nat):Int) ∧
      t.out=OutputSlice020D.write s.out (start+width*p.val) (encodeNat (f p) width) ∧
      t.ram=s.ram ∧ t.fault=s.fault

theorem step (i : Input) (body : Code) (f : Fin 1536 → Nat) (start width : Nat)
    (hb : start+1536*width≤outputSize) (s0 : State) (hspec : Step i body f start width s0)
    (k : Nat) (s : State) (hk : k<1536) (hs : Good f start width hb s0 k s) :
    Good f start width hb s0 (k+1) (exec i body s) ∧ Frame start width s (exec i body s) := by
  have post := hspec ⟨k,hk⟩ s hs.1 hs.2.1 hs.2.2.2
  refine ⟨⟨post.1,?_,?_,post.2.2.2.1.trans hs.2.2.2⟩,post.2.2.2.1,post.2.2.2.2,?_⟩
  · have he : start+width*k+width=start+width*(k+1) := by ring
    exact post.2.1.trans (congrArg (fun n : Nat => word (n:Int)) he)
  · rw [post.2.2.1]
    exact OutputChunks020D.prefix_step f start width hb ⟨k,hk⟩ s.out hs.2.2.1
  · rw [post.2.2.1]
    exact OutputChunks020D.write_frame start width ⟨k,hk⟩ s.out (f ⟨k,hk⟩)

theorem loop_correct (i : Input) (body : Code) (f : Fin 1536 → Nat) (start width : Nat)
    (hb : start+1536*width≤outputSize) (s0 : State) (hspec : Step i body f start width s0)
    (count k : Nat) (s : State) (hc : k+count≤1536) (hs : Good f start width hb s0 k s) :
    let t := loopState (exec i body) (lit 1) count s
    Good f start width hb s0 (k+count) t ∧ Frame start width s t :=
  CountedLoop020C.counted (exec i body) (lit 1) (Good f start width hb s0) (Frame start width) 1536
    (frame_refl start width) (fun a b => frame_trans start width a b)
    (fun j q hj hq => ⟨VectorLoopCore020C.guard_true q,step i body f start width hb s0 hspec j q hj hq⟩)
    count k s hc hs

theorem code_shape (i : Input) (body : Code) (count : Nat) (s : State) :
    exec i (code body count) s=loopState (exec i body) (lit 1) count (put s 21 (word 0)) := by
  simp only [code,exec_seqs_cons,exec_seqs_nil,exec_set,exec_loop]
  rfl

theorem code_correct (i : Input) (body : Code) (f : Fin 1536 → Nat) (start width : Nat)
    (hb : start+1536*width≤outputSize) (s : State) (hspec : Step i body f start width s)
    (count : Nat) (hc : count≤1536) (h28 : s.reg 28=word (start:Int)) :
    Good f start width hb s count (exec i (code body count) s) ∧ Frame start width s (exec i (code body count) s) := by
  let q := put s 21 (word 0)
  have g0 : Good f start width hb s 0 q := by
    refine ⟨put_same _ _ _,?_,OutputChunks020D.prefix_zero _ _ _ _ _,rfl⟩
    simpa only [Nat.mul_zero,Nat.add_zero] using (put_other s 21 28 (word 0) (by decide)).trans h28
  have post := loop_correct i body f start width hb s hspec count 0 q (by omega) g0
  change Good f start width hb s (0+count) (loopState (exec i body) (lit 1) count q) ∧
    Frame start width q (loopState (exec i body) (lit 1) count q) at post
  rw [Nat.zero_add] at post
  rw [code_shape]
  exact ⟨post.1,frame_trans start width ⟨rfl,rfl,fun _ _ => rfl⟩ post.2⟩

end FT1536.S05.OutputLoop020D
