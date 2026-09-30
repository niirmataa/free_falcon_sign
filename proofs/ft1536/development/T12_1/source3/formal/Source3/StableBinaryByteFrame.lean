import Source3.StableBinaryFinalBridge
import Source3.StableBinaryRefinementGoal
import Source3.StableBinaryByteLayout

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryByteFrame
open FT1536.Source3
open FT1536.Source3.StableBinaryByteView

abbrev outside (l : StableBinary.Layout) (q : B20.C.Byte.Pointer) : Prop :=
  ¬StableBinaryRefinementGoal.allowedByte l q

theorem outside_word (l : StableBinary.Layout) (a : Nat)
    (q : B20.C.Byte.Pointer) (ha : l.allowed a) (hq : outside l q) :
    ∀ i : Fin 8, q≠(ptr a).add i.val := by
  intro i he
  apply hq
  have hb : q.block=0 := by
    have hh := congrArg B20.C.Byte.Pointer.block he
    simpa [ptr,B20.C.Byte.Pointer.add] using hh
  have ho : q.offset=a+i.val := by
    have hh := congrArg B20.C.Byte.Pointer.offset he
    simpa [ptr,B20.C.Byte.Pointer.add] using hh
  refine ⟨hb,?_⟩
  rcases StableBinaryByteLayout.allowed_index l a ha with ⟨j,hj,hval⟩ | ⟨j,hj,hscr⟩
  · left
    unfold StableBinary.inBytes
    rw [ho,hval]
    dsimp [StableBinary.addr]
    have hi := i.isLt
    omega
  · right
    left
    unfold StableBinary.inBytes
    rw [ho,hscr]
    dsimp [StableBinary.addr]
    have hi := i.isLt
    omega

theorem outside_bad (l : StableBinary.Layout) (q : B20.C.Byte.Pointer)
    (hq : outside l q) :
    q.block≠0 ∨ q.offset<l.bad ∨ l.bad+4≤q.offset := by
  by_cases hb : q.block=0
  · right
    by_contra hn
    apply hq
    refine ⟨hb,Or.inr (Or.inr ?_)⟩
    omega
  · exact Or.inl hb

theorem store_frame (l : StableBinary.Layout)
    (source final : StableBinaryCExec.State) (a : Nat) (w : BitVec 64)
    (q : B20.C.Byte.Pointer) (ha : l.allowed a) (hq : outside l q)
    (hs : StableBinaryCExec.store source a w=some final) :
    final.heap.contents q=source.heap.contents q := by
  have owned : OwnedWriteRegion source.heap (ptr a) := by
    by_contra hn
    simp [StableBinaryCExec.store,wordWrite,hn] at hs
  have eqs : final={source with heap := B20.Word.LE.stored source.heap (ptr a) w} := by
    simpa [StableBinaryCExec.store,wordWrite,owned] using hs.symm
  subst final
  exact word_write_byte_frame source.heap a w q (outside_word l a q ha hq)

theorem positive_frame (l : StableBinary.Layout)
    (source final : StableBinaryCExec.State) (w z : BitVec 64)
    (q : B20.C.Byte.Pointer) (hq : outside l q)
    (hs : StableBinaryCExec.positive l source w=some (z,final)) :
    final.heap.contents q=source.heap.contents q := by
  obtain ⟨old,hbad,legal⟩ :=
    StableBinaryBytePositive.defined_positive_has_memory l source final w z hs
  obtain ⟨_,_,hheap,_⟩ :=
    StableBinaryBytePositive.source_positive_bad_update l source final w z old hbad legal hs
  rw [hheap]
  have hw : flagWrite source.heap l.bad (Run2.KeygenLeafGate.stableBad w old)=
      some (flagStored source.heap l.bad (Run2.KeygenLeafGate.stableBad w old)) := by
    simp [flagWrite,legal]
  exact flag_write_byte_frame source.heap
    (flagStored source.heap l.bad (Run2.KeygenLeafGate.stableBad w old))
    l.bad (Run2.KeygenLeafGate.stableBad w old) q hw (outside_bad l q hq)

private theorem map_state_unchanged (result : Option (BitVec 64))
    (source final : StableBinaryCExec.State) (z : BitVec 64)
    (hs : result.map (fun r => (r,source))=some (z,final)) : final=source := by
  cases hr : result with
  | none => simp [hr] at hs
  | some r =>
      have hp : (r,source)=(z,final) := by simpa [hr] using hs
      exact (Prod.mk.inj hp).2.symm

theorem add_frame (source final : StableBinaryCExec.State) (x y z : BitVec 64)
    (hs : StableBinaryCExec.binary "fpr_add".toList source x y=some (z,final)) :
    final=source := by
  rw [StableBinaryCalleeBridge.add_source_word_and_frame] at hs
  exact map_state_unchanged _ source final z hs

theorem mul_frame (source final : StableBinaryCExec.State) (x y z : BitVec 64)
    (hs : StableBinaryCExec.binary "fpr_mul".toList source x y=some (z,final)) :
    final=source := by
  rw [StableBinaryCalleeBridge.mul_source_word_and_frame] at hs
  exact map_state_unchanged _ source final z hs

theorem div_frame (source final : StableBinaryCExec.State) (x y z : BitVec 64)
    (hs : StableBinaryCExec.binary "fpr_div".toList source x y=some (z,final)) :
    final=source := by
  rw [StableBinaryCalleeBridge.div_source_word_and_frame] at hs
  exact map_state_unchanged _ source final z hs

theorem half_frame (source final : StableBinaryCExec.State) (x z : BitVec 64)
    (hs : StableBinaryCExec.unary "fpr_half".toList source x=some (z,final)) :
    final=source := by
  rw [StableBinaryCalleeBridge.half_source_word_and_frame] at hs
  exact map_state_unchanged _ source final z hs

theorem double_frame (source final : StableBinaryCExec.State) (x z : BitVec 64)
    (hs : StableBinaryCExec.unary "fpr_double".toList source x=some (z,final)) :
    final=source := by
  rw [StableBinaryCalleeBridge.double_source_word_and_frame] at hs
  exact map_state_unchanged _ source final z hs

end FT1536.Source3.StableBinaryByteFrame

#print axioms FT1536.Source3.StableBinaryByteFrame.store_frame
#print axioms FT1536.Source3.StableBinaryByteFrame.positive_frame
#print axioms FT1536.Source3.StableBinaryByteFrame.add_frame
#print axioms FT1536.Source3.StableBinaryByteFrame.mul_frame
#print axioms FT1536.Source3.StableBinaryByteFrame.div_frame
