import Source3.StableBinaryByteSimulation
import Source3.StableBinaryBytePositive
import Source3.StableBinarySourceTyped

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryRelation
open FT1536.Source3
open FT1536.Source3.StableBinaryByteView
open FT1536.Source3.StableBinaryByteSimulation

/- The exact simulation invariant; unregistered/unaligned byte windows are
   not invented as additional C objects. Checks are newest first in both
   executions. The source heap is independently updated as raw bytes. -/
structure Related (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source : StableBinaryCExec.State) (typed : StableBinary.State l m) : Prop where
  words : ∀ a, typed.memory.words a=(view l source.heap).words a
  flags : ∀ a, typed.memory.flags a=(view l source.heap).flags a
  checks : typed.checks=source.checks

theorem initial (l : StableBinary.Layout) (heap : B20.C.Byte.Memory)
    (b : StableBinary.Flag)
    (hb : (view l heap).flags l.bad=some b) :
    Related l (view l heap) {heap} {firstBad := b,badInitially := hb} := by
  refine ⟨?_,?_,rfl⟩
  · intro a
    rfl
  · intro a
    by_cases eq : a=l.bad
    · subst a
      simpa [StableBinary.State.memory,StableBinary.State.bad,
        StableBinary.State.checks,CRefWord.store_read] using hb.symm
    · simp [StableBinary.State.memory,CRefWord.store_frame,eq]

theorem store_step (l : StableBinary.Layout) (k : Nat) (m : StableBinary.Memory)
    (source source' : StableBinaryCExec.State)
    (typed typed' : StableBinary.State l m) (a : Nat) (w : BitVec 64)
    (hl : l.wellFormed k) (ha : l.allowed a)
    (rel : Related l m source typed)
    (hs : StableBinaryCExec.store source a w=some source')
    (ht : StableBinary.store typed a w=some typed') :
    Related l m source' typed' := by
  have owned : OwnedWriteRegion source.heap (ptr a) := by
    by_contra hn
    simp [StableBinaryCExec.store,wordWrite,hn] at hs
  have eqs : source'={source with heap := B20.Word.LE.stored source.heap (ptr a) w} := by
    simpa [StableBinaryCExec.store,wordWrite,owned] using hs.symm
  have eqt : typed'={typed with
      writes := ⟨a,w,ha⟩::typed.writes,
      events := .store a w::typed.events} := by
    simpa [StableBinary.store,ha] using ht.symm
  subst source'
  subst typed'
  refine ⟨?_,?_,?_⟩
  · intro b
    rw [word_store_typed_words l k source.heap a b w hl ha owned]
    by_cases eq : b=a
    · subst b
      simp [StableBinary.State.memory,StableBinary.lookup]
    · have hne : a≠b := Ne.symm eq
      simp only [StableBinary.State.memory,StableBinary.lookup,hne,eq,ite_false]
      simpa only [StableBinary.State.memory] using rel.words b
  · intro b
    rw [word_store_typed_flags l k source.heap a b w hl ha]
    simpa [StableBinary.State.memory,StableBinary.State.bad] using rel.flags b
  · exact rel.checks

theorem load_step (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (a : Nat) (w : BitVec 64)
    (ha : l.allowed a) (rel : Related l m source typed)
    (hs : StableBinaryCExec.load source a=some w) :
    ∃ next, StableBinary.load typed a=some (w,next) ∧ Related l m source next := by
  let next : StableBinary.State l m := {typed with events := .load a w::typed.events}
  refine ⟨next,?_,?_⟩
  · have hw : typed.memory.words a=some w := by
      rw [rel.words a]
      simpa [view,ha,StableBinaryCExec.load] using hs
    simp [StableBinary.load,ha,hw,next]
  · exact ⟨rel.words,rel.flags,rel.checks⟩

theorem call2_related (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source : StableBinaryCExec.State) (typed next : StableBinary.State l m)
    (name : String) (f : BitVec 64 → BitVec 64 → Option (BitVec 64))
    (x y z : BitVec 64) (rel : Related l m source typed)
    (hc : StableBinary.call2 typed name f x y=some (z,next)) :
    Related l m source next := by
  cases hf : f x y with
  | none => simp [StableBinary.call2,hf] at hc
  | some word =>
      simp only [StableBinary.call2,hf] at hc
      have hn := (Prod.mk.inj (Option.some.inj hc)).2.symm
      subst next
      exact ⟨rel.words,rel.flags,rel.checks⟩

theorem call1_related (l : StableBinary.Layout) (m : StableBinary.Memory)
    (source : StableBinaryCExec.State) (typed next : StableBinary.State l m)
    (name : String) (f : BitVec 64 → Option (BitVec 64))
    (x z : BitVec 64) (rel : Related l m source typed)
    (hc : StableBinary.call1 typed name f x=some (z,next)) :
    Related l m source next := by
  cases hf : f x with
  | none => simp [StableBinary.call1,hf] at hc
  | some word =>
      simp only [StableBinary.call1,hf] at hc
      have hn := (Prod.mk.inj (Option.some.inj hc)).2.symm
      subst next
      exact ⟨rel.words,rel.flags,rel.checks⟩

theorem positive_step (l : StableBinary.Layout) (k : Nat) (m : StableBinary.Memory)
    (source source' : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (w z : BitVec 64) (old : BitVec 32)
    (hl : l.wellFormed k) (rel : Related l m source typed)
    (hb : flagRead source.heap l.bad=some old)
    (legal : FlagWritable source.heap l.bad)
    (hs : StableBinaryCExec.positive l source w=some (z,source')) :
    StableBinary.stable typed w=some
      (z,StableBinary.recordCheck typed w (Run2.KeygenLeafGate.stableWord w)) ∧
    Related l m source'
      (StableBinary.recordCheck typed w (Run2.KeygenLeafGate.stableWord w)) := by
  obtain ⟨hz,hchecks,hheap,_⟩ :=
    StableBinaryBytePositive.source_positive_bad_update l source source' w z old hb legal hs
  subst z
  have hbad : typed.bad=old := by
    have ht : typed.memory.flags l.bad=some typed.bad := by
      simp [StableBinary.State.memory,CRefWord.store_read]
    have hv : (view l source.heap).flags l.bad=some old := by simpa [view] using hb
    exact Option.some.inj (ht.symm.trans ((rel.flags l.bad).trans hv))
  constructor
  · exact StableBinary.stable_source typed w
  · refine ⟨?_,?_,?_⟩
    · intro a
      rw [hheap,flag_store_typed_words l k source.heap a
        (Run2.KeygenLeafGate.stableBad w old) hl legal]
      exact rel.words a
    · intro a
      rw [hheap,flag_store_typed_flags l source.heap a
        (Run2.KeygenLeafGate.stableBad w old) legal]
      by_cases eq : a=l.bad
      · subst a
        simp [StableBinary.State.memory,StableBinary.State.bad,
          StableBinary.recordCheck,CRefWord.store_read]
        exact congrArg (Run2.KeygenLeafGate.stableBad w) hbad
      · simpa [StableBinary.State.memory,StableBinary.recordCheck,
          CRefWord.store_frame,eq] using rel.flags a
    · simp [StableBinary.recordCheck,hchecks,rel.checks]

theorem positive_refines (l : StableBinary.Layout) (k : Nat) (m : StableBinary.Memory)
    (source source' : StableBinaryCExec.State) (typed : StableBinary.State l m)
    (w z : BitVec 64)
    (hl : l.wellFormed k) (rel : Related l m source typed)
    (hs : StableBinaryCExec.positive l source w=some (z,source')) :
    ∃ next, StableBinary.stable typed w=some (z,next) ∧
      Related l m source' next := by
  obtain ⟨old,hb,legal⟩ :=
    StableBinaryBytePositive.defined_positive_has_memory l source source' w z hs
  have h := positive_step l k m source source' typed w z old hl rel hb legal hs
  exact ⟨_,h.1,h.2⟩

end FT1536.Source3.StableBinaryRelation

#print axioms FT1536.Source3.StableBinaryRelation.initial
