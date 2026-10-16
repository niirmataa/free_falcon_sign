import Source3.PublicConvertInvariant158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicConvertLoop158
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open Word16Memory158 (Represents)
open PublicConvertInvariant158
open KeygenPublicInputProgram (signed)

theorem counter_fixed (s : State) (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16)
    (fixed : Fixed s f g t h n fv gv) (word : BitVec 64) : Fixed (FftLocalCells140.put s "u".toList word) f g t h n fv gv :=
  ⟨fixed.wordBound,fixed.fCapacity,fixed.gCapacity,fixed.tCapacity,fixed.hCapacity,fixed.tWidth,fixed.hWidth,
    fixed.fBinding,fixed.gBinding,fixed.tBinding,fixed.hBinding,
    (FftLocalCells140.outside _ "u".toList "n".toList _ (by decide)).trans fixed.nCell,
    (FftLocalCells140.outside _ "u".toList "q".toList _ (by decide)).trans fixed.qCell,
    fixed.tAllocated,fixed.hAllocated,fixed.tWritable,fixed.hWritable,fixed.fImage,fixed.gImage,
    fixed.tf,fixed.tg,fixed.hf,fixed.hg,fixed.th⟩

theorem remaining (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16) (count u : Nat) (s : State)
    (fixed : Fixed s f g t h n fv gv) (counter : Cell s "u".toList u)
    (tImage : PrefixImage s t (image fv) u) (hImage : PrefixImage s h (image gv) u) (finish : u+count=n) :
    ∃ after, KeygenPublicExec.Exec KeygenPublicSource.program signed KeygenPublicInputProgram.loop s ⟨after,.normal⟩ ∧
      Fixed after f g t h n fv gv ∧ Cell after "u".toList n ∧
      Represents after.heap t (image fv) ∧ Represents after.heap h (image gv) ∧ PublicConvertFrame158.Frame t h n s after := by
  induction count generalizing u s with
  | zero =>
    have same : u=n := by omega
    subst u
    have guard : KeygenPublicWord.Eval signed s KeygenPublicInputProgram.condition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using PublicNat158.guard s n n fixed.wordBound fixed.wordBound counter fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) guard (by decide),fixed,counter,
      fun i => tImage i i.isLt,fun i => hImage i i.isLt,PublicConvertFrame158.refl t h n s⟩
  | succ count ih =>
    have inside : u<n := by omega
    have bound:=fixed.wordBound
    let slot : Fin n := ⟨u,inside⟩
    let mid := middle s t h fv gv slot
    let afterStep := next s t h fv gv slot
    have body := body_source s f g t h n fv gv fixed slot counter
    have increment : KeygenPublicExec.Exec KeygenPublicSource.program signed KeygenPublicInputProgram.increment mid ⟨afterStep,.normal⟩ :=
      PublicNat158.increment mid u (by omega) counter
    have nextFixed := next_fixed s f g t h n fv gv fixed slot
    have nextU : Cell afterStep "u".toList (u+1) := FftLocalCells140.cell_at mid "u".toList _
    have nextImages := next_images s f g t h n fv gv fixed slot tImage hImage
    obtain ⟨after,tail,lastFixed,lastU,lastT,lastH,frame⟩ := ih (u+1) afterStep nextFixed nextU nextImages.1 nextImages.2 (by omega)
    have guard : KeygenPublicWord.Eval signed s KeygenPublicInputProgram.condition (.int32 1) := by
      simpa [inside,C99ScalarReference.boolean] using PublicNat158.guard s u n (by omega) fixed.wordBound counter fixed.nCell
    have firstFrame : PublicConvertFrame158.Frame t h n s afterStep :=
      PublicConvertFrame158.trans t h n s mid afterStep
        (PublicConvertFrame158.body s t h slot (fv slot) (gv slot) fixed.tWidth fixed.hWidth)
        (PublicConvertFrame158.counter t h n mid _)
    exact ⟨after,.loopNormal _ _ _ s mid afterStep ⟨after,.normal⟩ (.int32 1) guard (by decide) body increment tail,
      lastFixed,lastU,lastT,lastH,PublicConvertFrame158.trans t h n s afterStep after firstFrame frame⟩

/-- The original conversion loop fills both outputs while preserving signed inputs and all other bytes. -/
theorem source (s : State) (f g t h : ArrayPointer) (n : Nat) (fv gv : Fin n → BitVec 16)
    (fixed : Fixed s f g t h n fv gv) (counter : Cell s "u".toList 0) :
    ∃ after, KeygenPublicExec.Exec KeygenPublicSource.program signed KeygenPublicInputProgram.loop s ⟨after,.normal⟩ ∧
      Fixed after f g t h n fv gv ∧ Cell after "u".toList n ∧
      Represents after.heap t (image fv) ∧ Represents after.heap h (image gv) ∧ PublicConvertFrame158.Frame t h n s after :=
  remaining f g t h n fv gv n 0 s fixed counter (by intro i impossible; omega) (by intro i impossible; omega) (Nat.zero_add n)

end FT1536.Source3.PublicConvertLoop158
