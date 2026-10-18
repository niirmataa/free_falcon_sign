import Source3.PublicRootStart174
import Source3.KeygenPublicNormalizeProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicNormalizeBody174
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenNttLoopSupport (USlot)
open KeygenPublicTableAtoms (var)
open KeygenSmallOutput (element)

structure Fixed (s : State) (a : ArrayPointer) : Prop where
  data : PublicForwardMemory167.Data s.heap a
  binding : s.arrays "a".toList=some a
  length : USlot s "n" 1536
  factor : PublicU32Locals165.Has s "ni"

theorem source (s : State) (a : ArrayPointer) (u : Nat) (inside : u<1536)
    (fixed : Fixed s a) (counter : USlot s "u" u) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicNormalizeProgram.body s ⟨after,.normal⟩ ∧
      Fixed after a ∧ USlot after "u" u ∧ PublicInitializedFrame164.Frame s.heap after.heap := by
  obtain ⟨w,read⟩ := fixed.data.written u inside
  obtain ⟨ni,slot⟩ := fixed.factor
  have cap:=PublicForwardMemory167.capacity s.heap a fixed.data
  have address := PublicWordSteps161.address_var s "a" "u" a u (by omega) fixed.binding counter (by omega)
  have loaded : Eval [] s (.load16 "a".toList (.var "u".toList)) (C99NarrowReads.unsignedPromotion w) :=
    .load16 _ _ (element a u) w address read
  have value := PublicGenerateUpper159.mont_u32 s _ _ _ _ _ _ loaded
    (PublicGenerateHead159.eval_var s "ni" ni slot) (KeygenPublicTableCells.unsigned_argument w)
    (KeygenPublicArguments.u32_self ni)
  have allocated := (KeygenPublicRangeMemory.load_allocated _ _ _ read).1
  have width := (KeygenPublicRangeMemory.load_allocated _ _ _ read).2
  have store := PublicWordSteps161.store s "a" (.var "u".toList) (element a u) _ _ address value allocated width fixed.data.writable
  let word := KeygenPublicWord.narrow (.uint32 (KeygenPublicLeafWords.montgomery (BitVec.ofNat 32 w.toNat) ni 18433#32 18431#32))
  let after : State := {s with heap:=Word16Memory158.write s.heap (element a u) word}
  have run : Exec KeygenPublicSource.program [] KeygenPublicNormalizeProgram.body s ⟨after,.normal⟩ :=
    .scope [] [] _ s ⟨after,.normal⟩ (.seqNormal _ _ s after ⟨after,.normal⟩ store (.skip after))
  have memory := PublicInitializedFrame164.source _ _ _ _ _ (by decide) run
  exact ⟨after,run,⟨PublicForwardMemory167.after_generator _ _ a fixed.data memory,
    fixed.binding,fixed.length,fixed.factor⟩,counter,memory⟩

end FT1536.Source3.PublicNormalizeBody174
