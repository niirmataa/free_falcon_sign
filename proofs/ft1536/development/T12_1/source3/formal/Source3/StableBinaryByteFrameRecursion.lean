import Source3.StableBinaryByteFrameGroups
import Source3.StableBinaryLoopRefinement

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryByteFrameRecursion
open FT1536.Source3
open FT1536.Source3.StableBinaryByteFrame

theorem loop_frame (l : StableBinary.Layout) (start hn n : Nat)
    (source final : StableBinaryCExec.State)
    (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hsub : start+2*hn≤l.length) (hnBound : n≤hn)
    (hs : StableBinaryCExec.sourceLoop l StableBinarySourceSyntax.expected
      (StableBinary.addr l.values start) hn n source=some final) :
    final.heap.contents q=source.heap.contents q := by
  induction n generalizing source final with
  | zero =>
      have heq : source=final := Option.some.inj (by simpa [StableBinaryCExec.sourceLoop] using hs)
      subst final
      rfl
  | succ n ih =>
      have hs' : (do
          let mid ← StableBinaryCExec.sourceLoop l StableBinarySourceSyntax.expected
            (StableBinary.addr l.values start) hn n source
          StableBinaryCExec.sourceStep l StableBinarySourceSyntax.expected
            (StableBinary.addr l.values start) n hn mid)=some final := by
        simpa [StableBinaryCExec.sourceLoop] using hs
      obtain ⟨mid,hloop,hstep⟩ := Option.bind_eq_some_iff.mp hs'
      have hfirst := ih source mid (by omega) hloop
      have haddr := StableBinaryLoopRefinement.subtree_addresses l start hn n hsub (by omega)
      have hlast := StableBinaryByteFrameGroups.step_frame l (StableBinary.addr l.values start)
        n hn mid final q hq haddr.2.2.1 haddr.2.2.2 hstep
      exact hlast.trans hfirst

theorem write_copy_frame (l : StableBinary.Layout) (start i : Nat)
    (words : List (BitVec 64)) (source final : StableBinaryCExec.State)
    (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hbound : start+i+words.length≤l.length)
    (hs : StableBinaryCExec.writeCopy (StableBinary.addr l.values start) i
      words source=some final) :
    final.heap.contents q=source.heap.contents q := by
  induction words generalizing i source final with
  | nil =>
      have heq : source=final := Option.some.inj (by simpa [StableBinaryCExec.writeCopy] using hs)
      subst final
      rfl
  | cons w rest ih =>
      let v := StableBinary.addr l.values start
      have haddr : StableBinary.addr v i=StableBinary.addr l.values (start+i) := by
        simp [v,StableBinary.addr]
        omega
      have ha : l.allowed (StableBinary.addr v i) := by
        rw [haddr]
        exact StableBinaryByteView.values_allowed l (start+i) (by
          simp only [List.length_cons] at hbound
          omega)
      have hs' : (do
          let mid ← StableBinaryCExec.store source (StableBinary.addr v i) w
          StableBinaryCExec.writeCopy v (i+1) rest mid)=some final := by
        simpa [StableBinaryCExec.writeCopy,v] using hs
      obtain ⟨mid,hstore,hrest⟩ := Option.bind_eq_some_iff.mp hs'
      have hfirst := StableBinaryByteFrame.store_frame l source mid (StableBinary.addr v i)
        w q ha hq hstore
      have hlast := ih (i+1) mid final (by
        simp only [List.length_cons] at hbound
        omega) hrest
      exact hlast.trans hfirst

theorem copy_frame (l : StableBinary.Layout) (start n : Nat)
    (source final : StableBinaryCExec.State)
    (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hbound : start+n≤l.length)
    (hs : StableBinaryCExec.copy source (StableBinary.addr l.values start)
      l.scratch n=some final) :
    final.heap.contents q=source.heap.contents q := by
  unfold StableBinaryCExec.copy at hs
  obtain ⟨words,hread,hwrite⟩ := Option.bind_eq_some_iff.mp hs
  have hlen := StableBinaryCopyRefinement.read_copy_length l.scratch n source words hread
  exact write_copy_frame l start 0 words source final q hq (by simp [hlen] at hbound ⊢; omega) hwrite

theorem execute_frame (l : StableBinary.Layout) (q : B20.C.Byte.Pointer)
    (hq : outside l q) :
    ∀ (k start : Nat) (source final : StableBinaryCExec.State),
      start+2^k≤l.length →
      StableBinaryCExec.execute l StableBinarySourceSyntax.expected k
        (StableBinary.addr l.values start) source=some final →
      final.heap.contents q=source.heap.contents q := by
  intro k
  induction k with
  | zero =>
      intro start source final hbound hs
      let v := StableBinary.addr l.values start
      have ha : l.allowed v := StableBinaryByteView.values_allowed l start (by
        simpa using hbound)
      have hsrc : (do
          let x ← StableBinaryCExec.load source v
          let (out,mid) ← StableBinaryCExec.positive l source x
          StableBinaryCExec.store mid v out)=some final := by
        simpa [StableBinaryCExec.execute,StableBinarySourceSyntax.expected,v] using hs
      obtain ⟨x,_,hrest⟩ := Option.bind_eq_some_iff.mp hsrc
      obtain ⟨⟨out,mid⟩,hpositive,hstore⟩ := Option.bind_eq_some_iff.mp hrest
      exact (StableBinaryByteFrame.store_frame l mid final v out q ha hq hstore).trans
        (StableBinaryByteFrame.positive_frame l source mid x out q hq hpositive)
  | succ k ih =>
      intro start source final hbound hs
      let hn := 2^k
      let v := StableBinary.addr l.values start
      have hsub : start+2*hn≤l.length := by
        simpa [hn,pow_succ,Nat.mul_comm] using hbound
      have hrightAddr : v+8*hn=StableBinary.addr l.values (start+hn) := by
        simp [v,StableBinary.addr]
        omega
      have hsrc : (do
          let s0 ← StableBinaryCExec.sourceLoop l StableBinarySourceSyntax.expected v hn hn source
          let s1 ← StableBinaryCExec.copy s0 v l.scratch (2*hn)
          let s2 ← StableBinaryCExec.execute l StableBinarySourceSyntax.expected k v s1
          StableBinaryCExec.execute l StableBinarySourceSyntax.expected k (v+8*hn) s2)=
          some final := by simpa [StableBinaryCExec.execute,hn,v] using hs
      obtain ⟨sloop,hloop,hrest⟩ := Option.bind_eq_some_iff.mp hsrc
      obtain ⟨scopy,hcopy,hrest⟩ := Option.bind_eq_some_iff.mp hrest
      obtain ⟨sleft,hleft,hright⟩ := Option.bind_eq_some_iff.mp hrest
      have h0 := loop_frame l start hn hn source sloop q hq hsub (by omega) hloop
      have h1 := copy_frame l start (2*hn) sloop scopy q hq hsub hcopy
      have h2 := ih start scopy sleft (by omega) (by simpa [v] using hleft)
      have hright' : StableBinaryCExec.execute l StableBinarySourceSyntax.expected k
          (StableBinary.addr l.values (start+hn)) sleft=some final := by
        simpa only [← hrightAddr] using hright
      have h3 := ih (start+hn) sleft final (by omega) hright'
      exact h3.trans (h2.trans (h1.trans h0))

end FT1536.Source3.StableBinaryByteFrameRecursion

#print axioms FT1536.Source3.StableBinaryByteFrameRecursion.loop_frame
#print axioms FT1536.Source3.StableBinaryByteFrameRecursion.copy_frame
#print axioms FT1536.Source3.StableBinaryByteFrameRecursion.execute_frame
