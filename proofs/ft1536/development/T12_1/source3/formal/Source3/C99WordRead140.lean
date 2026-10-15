import Source3.C99WordStore140
import Source3.FftGlobalMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99WordRead140
open C99MemoryReference

def Separate (p q : ArrayPointer) : Prop :=
  p.block≠q.block ∨ p.offset+8≤q.offset ∨ q.offset+8≤p.offset

theorem here (before : Memory) (p : ArrayPointer) (word : BitVec 64)
    (allocated : Allocated before p) (width : p.elementBytes=8) (writable : before.writable p.block=true) :
    Load64 (C99WordStore140.write before p word) p word := by
  have stored := C99WordStore140.source before p word allocated width writable
  have raw : Load64 (C99WordStore140.write before p word) p (le64 (byte64 word)) :=
    .load _ _ (byte64 word) allocated width stored.2.2.2.2.2.1
  have joined := B20.Word.LE.join_byteOf word
  change le64 (byte64 word)=word at joined
  simpa only [joined] using raw

theorem outside (before : Memory) (p q : ArrayPointer) (stored word : BitVec 64)
    (separate : Separate p q) (read : Load64 before q word) :
    Load64 (C99WordStore140.write before p stored) q word := by
  cases read with
  | load bytes allocated width initialized =>
    refine .load _ _ bytes allocated width ?_
    intro i
    have bound := i.isLt
    have absent : ¬(q.block=p.block ∧ p.offset≤q.offset+i.val ∧ q.offset+i.val<p.offset+8) := by
      unfold Separate at separate
      omega
    change (if inside : q.block=p.block ∧ p.offset≤q.offset+i.val ∧ q.offset+i.val<p.offset+8 then
      some (byte64 stored ⟨q.offset+i.val-p.offset,by omega⟩) else before.bytes q.block (q.offset+i.val))=some (bytes i)
    rw [dite_eq_right absent]
    exact initialized i

end FT1536.Source3.C99WordRead140
