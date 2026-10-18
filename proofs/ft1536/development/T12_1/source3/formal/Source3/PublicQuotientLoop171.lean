import Source3.PublicQuotientBody171

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicQuotientLoop171
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open FftLocalCells140 (put)
open PublicQuotientBody171 (Fixed)
open PublicMiddleWrites161 (MemoryFrame)
open KeygenPublicExec (Exec)
open KeygenPublicInputProgram (signed)

theorem fixed_put (s : State) (t h : ArrayPointer) (fixed : Fixed s t h) (w : BitVec 64) :
    Fixed (put s "u".toList w) t h :=
  ⟨fixed.hBinding,fixed.tBinding,
    (FftLocalCells140.outside s "u".toList "n".toList w (by decide)).trans fixed.nCell,
    (FftLocalCells140.outside s "u".toList "logn".toList w (by decide)).trans fixed.profile,
    (FftLocalCells140.outside s "u".toList "ternary".toList w (by decide)).trans fixed.ternary,
    fixed.separate,fixed.data,fixed.nonzero⟩

theorem remaining (count i : Nat) (s : State) (t h : ArrayPointer)
    (fixed : Fixed s t h) (counter : Cell s "u".toList i) (finish : i+count=1536) :
    ∃ after, Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.loop s ⟨after,.normal⟩ ∧
      Fixed after t h ∧ Cell after "u".toList 1536 ∧ MemoryFrame s after h := by
  induction count generalizing i s with
  | zero =>
      have equal : i=1536 := by omega
      subst i
      have guard := PublicNat158.guard s 1536 1536 (by decide) (by decide) counter fixed.nCell
      have no : KeygenPublicWord.Eval signed s KeygenPublicInputProgram.condition (C99ScalarReference.boolean false) := by
        simpa only [Nat.lt_irrefl,decide_false] using guard
      exact ⟨s,.loopFalse _ _ _ _ _ no (by decide),fixed,counter,PublicMiddleLoop161.frame_refl s h⟩
  | succ count ih =>
      have inside : i<1536 := by omega
      obtain ⟨middle,bodyRun,middleFixed,middleCounter,memory⟩ := PublicQuotientBody171.source s t h i inside fixed counter
      let next := put middle "u".toList (word (i+1))
      have step := PublicNat158.increment middle i (by omega) middleCounter
      have nextFixed := fixed_put middle t h middleFixed (word (i+1))
      have nextCounter : Cell next "u".toList (i+1) := FftLocalCells140.cell_at middle "u".toList (word (i+1))
      obtain ⟨after,rest,lastFixed,lastCounter,lastMemory⟩ := ih (i+1) next nextFixed nextCounter (by omega)
      have guard := PublicNat158.guard s i 1536 (by omega) (by decide) counter fixed.nCell
      have yes : KeygenPublicWord.Eval signed s KeygenPublicInputProgram.condition (C99ScalarReference.boolean true) := by
        simpa only [inside,decide_true] using guard
      have updated : MemoryFrame s next h := ⟨memory.size,memory.writable,memory.outside,memory.written⟩
      exact ⟨after,.loopNormal _ _ _ s middle next ⟨after,.normal⟩ (C99ScalarReference.boolean true)
        yes (by decide) bodyRun step rest,lastFixed,lastCounter,
        PublicMiddleLoop161.frame_trans s next after h updated lastMemory⟩

theorem source (s : State) (t h : ArrayPointer) (fixed : Fixed s t h)
    (old : Option C99IntegerReference.Value) (declared : s.locals "u".toList=some (.uint64,old)) :
    ∃ after, Exec KeygenPublicSource.program signed KeygenPublicSuffixProgram.pass s ⟨after,.normal⟩ ∧
      Fixed after t h ∧ Cell after "u".toList 1536 ∧ MemoryFrame s after h := by
  let initial := put s "u".toList 0
  obtain ⟨after,run,last,counter,memory⟩ := remaining 1536 0 initial t h (fixed_put s t h fixed 0)
    (FftLocalCells140.cell_at s "u".toList 0) rfl
  have original : MemoryFrame s after h := ⟨memory.size,memory.writable,memory.outside,memory.written⟩
  exact ⟨after,.seqNormal _ _ _ initial _ (PublicNat158.initial s old declared) run,last,counter,original⟩

end FT1536.Source3.PublicQuotientLoop171
