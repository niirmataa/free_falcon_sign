import Source3.StableBinaryLoopRefinement

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryCopyRefinement
open FT1536.Source3

theorem read_copy_refines (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (n : Nat) (words : List (BitVec 64)) (hn : n≤l.length)
    (rel : StableBinaryRelation.Related l m source typed)
    (hs : StableBinaryCExec.readCopy l.scratch n source=some words) :
    ∃ next, StableBinary.collect l l.scratch n typed=some (words,next) ∧
      StableBinaryRelation.Related l m source next := by
  induction n generalizing typed words with
  | zero =>
      have hw : words=[] := by simpa [StableBinaryCExec.readCopy] using hs.symm
      subst words
      exact ⟨typed,rfl,rel⟩
  | succ n ih =>
      have hsource : (do
          let xs ← StableBinaryCExec.readCopy l.scratch n source
          let w ← StableBinaryCExec.load source (StableBinary.addr l.scratch n)
          pure (xs++[w]))=some words := by simpa [StableBinaryCExec.readCopy] using hs
      obtain ⟨xs,hxs,hrest⟩ := Option.bind_eq_some_iff.mp hsource
      obtain ⟨w,hw,hret⟩ := Option.bind_eq_some_iff.mp hrest
      have hwords : words=xs++[w] := (Option.some.inj hret).symm
      obtain ⟨t1,ht1,rel1⟩ := ih typed xs (by omega) rel hxs
      obtain ⟨t2,ht2,rel2⟩ := StableBinaryRelation.load_step l m source t1
        (StableBinary.addr l.scratch n) w
        (StableBinaryLoopRefinement.scratch_allowed l n (by omega)) rel1 hw
      subst words
      refine ⟨t2,?_,rel2⟩
      simp [StableBinary.collect,ht1,ht2]

theorem write_copy_refines (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (source final : StableBinaryCExec.State)
    (typed : StableBinary.State l m) (start i : Nat)
    (words : List (BitVec 64))
    (hl : l.wellFormed k) (hbound : start+i+words.length≤l.length)
    (rel : StableBinaryRelation.Related l m source typed)
    (hs : StableBinaryCExec.writeCopy (StableBinary.addr l.values start) i words source=
      some final) :
    ∃ next, StableBinary.place l (StableBinary.addr l.values start) i words typed=
      some next ∧ StableBinaryRelation.Related l m final next := by
  induction words generalizing i source final typed with
  | nil =>
      have heq : source=final := Option.some.inj (by simpa [StableBinaryCExec.writeCopy] using hs)
      subst final
      exact ⟨typed,rfl,rel⟩
  | cons w rest ih =>
      let base := StableBinary.addr l.values start
      have haddr : StableBinary.addr base i = StableBinary.addr l.values (start+i) := by
        simp [base,StableBinary.addr]
        omega
      have ha : l.allowed (StableBinary.addr base i) := by
        rw [haddr]
        exact StableBinaryByteView.values_allowed l (start+i) (by
          simp only [List.length_cons] at hbound
          omega)
      have hsrc : (do
          let mid ← StableBinaryCExec.store source (StableBinary.addr base i) w
          StableBinaryCExec.writeCopy base (i+1) rest mid)=some final := by
        simpa [StableBinaryCExec.writeCopy,base] using hs
      obtain ⟨mid,hwrite,hrest⟩ := Option.bind_eq_some_iff.mp hsrc
      have hmodel : (StableBinary.store typed (StableBinary.addr base i) w).isSome := by
        simp [StableBinary.store,ha]
      obtain ⟨typedMid,htwrite⟩ := Option.isSome_iff_exists.mp hmodel
      have relMid := StableBinaryRelation.store_step l k m source mid typed typedMid
        (StableBinary.addr base i) w hl ha rel hwrite htwrite
      have htail : start+(i+1)+rest.length≤l.length := by
        simp only [List.length_cons] at hbound
        omega
      obtain ⟨next,htrest,relNext⟩ := ih mid final typedMid (i+1) htail relMid hrest
      refine ⟨next,?_,relNext⟩
      simp [StableBinary.place,htwrite,htrest,base]

theorem read_copy_length (scratch n : Nat) (source : StableBinaryCExec.State)
    (words : List (BitVec 64))
    (h : StableBinaryCExec.readCopy scratch n source=some words) : words.length=n := by
  induction n generalizing words with
  | zero =>
      have hw : words=[] := by simpa [StableBinaryCExec.readCopy] using h.symm
      subst words
      rfl
  | succ n ih =>
      have he : (do
          let xs ← StableBinaryCExec.readCopy scratch n source
          let w ← StableBinaryCExec.load source (StableBinary.addr scratch n)
          pure (xs++[w]))=some words := by simpa [StableBinaryCExec.readCopy] using h
      obtain ⟨xs,hxs,hrest⟩ := Option.bind_eq_some_iff.mp he
      obtain ⟨w,_,hret⟩ := Option.bind_eq_some_iff.mp hrest
      have hw : words=xs++[w] := (Option.some.inj hret).symm
      rw [hw,List.length_append,List.length_singleton,ih xs hxs]

theorem copy_refines (l : StableBinary.Layout) (k : Nat) (m : StableBinary.Memory)
    (source final : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (start n : Nat) (hl : l.wellFormed k) (hbound : start+n≤l.length)
    (rel : StableBinaryRelation.Related l m source typed)
    (hs : StableBinaryCExec.copy source (StableBinary.addr l.values start) l.scratch n=
      some final) :
    ∃ next, StableBinary.copy l typed (StableBinary.addr l.values start) l.scratch n=
      some next ∧ StableBinaryRelation.Related l m final next := by
  unfold StableBinaryCExec.copy at hs
  obtain ⟨words,hread,hwrite⟩ := Option.bind_eq_some_iff.mp hs
  obtain ⟨tr,htread,relRead⟩ := read_copy_refines l m source typed n words
    (by omega) rel hread
  have hlen := read_copy_length l.scratch n source words hread
  obtain ⟨tf,htwrite,relFinal⟩ := write_copy_refines l k m source final tr
    start 0 words hl (by simp [hlen] at hbound ⊢; omega) relRead hwrite
  let next : StableBinary.State l m :=
    {tf with events := .copy (StableBinary.addr l.values start) l.scratch (8*n)::tf.events}
  refine ⟨next,?_,?_⟩
  · simp [StableBinary.copy,htread,htwrite,next]
  · exact ⟨relFinal.words,relFinal.flags,relFinal.checks⟩

end FT1536.Source3.StableBinaryCopyRefinement

#print axioms FT1536.Source3.StableBinaryCopyRefinement.read_copy_refines
#print axioms FT1536.Source3.StableBinaryCopyRefinement.write_copy_refines
#print axioms FT1536.Source3.StableBinaryCopyRefinement.copy_refines
