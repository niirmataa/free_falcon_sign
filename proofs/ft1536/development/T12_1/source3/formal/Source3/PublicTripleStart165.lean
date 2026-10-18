import Source3.PublicTripleLoop165

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTripleStart165
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenPublicTableAtoms (Slot var literal)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open PublicRoundContext163 (Arrays)
open PublicTripleLoop165 (Fixed)
open PublicTailShape159 (wSet tripleInit tripleLoop tripling)

theorem v_eval (s : State) (profile : Slot s "logn" 10) :
    Eval [] s (.bin .shl (.cast .uint64 (literal 1)) (.bin .sub (var "logn") (literal 1))) (u64 512) :=
  .bin .shl _ _ (u64 1) (.uint32 9) (u64 512)
    (PublicGenerateIndex159.word_cast_u64_one s)
    (.bin .sub _ _ (.uint32 10) (C99IntegerReference.convert .int32 1) (.uint32 9)
      (PublicGenerateHead159.eval_var s "logn" 10 profile) (PublicGenerateHead159.eval_lit s 1)
      PublicGenerateRemaining159.sub_10_1)
    (PublicGenerateIndex159.shl_pow 9 (.uint32 9)
      (PublicGenerateIndex159.u32_integer 9 (by decide)) (by decide))

theorem initial_source (s : State) (a gm : ArrayPointer) (ctx : Arrays s a gm)
    (cubic : s.arrays "gm_cubic".toList=some gm)
    (length : USlot s "n" 1536) (profile : Slot s "logn" 10)
    (uCell : ∃ old, s.locals "u".toList=some (.uint64,old))
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old))
    (wCell : ∃ old, s.locals "w".toList=some (.uint32,old)) :
    ∃ after, Exec KeygenPublicSource.program [] (.seq wSet tripleInit) s ⟨after,.normal⟩ ∧
      Fixed after a gm ∧ USlot after "u" 0 ∧ USlot after "v" 512 := by
  obtain ⟨w,read⟩ := ctx.tableWritten 1 (by decide)
  obtain ⟨oldW,declaredW⟩ := wCell
  obtain ⟨oldU,declaredU⟩ := uCell
  obtain ⟨oldV,declaredV⟩ := vCell
  have capacity := ctx.tableCapacity
  have address := PublicTailFirst159.address_lit s "gm_square" gm 1 (by decide) ctx.tableBinding (by omega)
  have loaded : Eval [] s (PublicTailShape159.load "gm_square" (PublicTailShape159.clit 1))
      (C99NarrowReads.unsignedPromotion w) := .load16 _ _ (element gm 1) w address read
  let word := PublicGenerateRow159.rowValue (BitVec.ofNat 32 w.toNat) (BitVec.ofNat 32 w.toNat)
  have squared : Eval [] s
      (PublicTailShape159.mont (PublicTailShape159.load "gm_square" (PublicTailShape159.clit 1))
        (PublicTailShape159.load "gm_square" (PublicTailShape159.clit 1))) (.uint32 word) :=
    PublicGenerateUpper159.mont_u32 s _ _ _ _ _ _ loaded loaded
      (KeygenPublicTableCells.unsigned_argument w) (KeygenPublicTableCells.unsigned_argument w)
  let withW := bindValue s "w".toList .uint32 (.uint32 word)
  let withU := bindValue withW "u".toList .uint64 (u64 0)
  let after := bindValue withU "v".toList .uint64 (u64 512)
  have wRun : Exec KeygenPublicSource.program [] wSet s ⟨withW,.normal⟩ :=
    .assign _ _ _ .uint32 oldW (.uint32 word) declaredW squared
  have uRun : Exec KeygenPublicSource.program [] (.assign "u".toList (literal 0)) withW ⟨withU,.normal⟩ :=
    .assign _ _ _ .uint64 oldU (.int32 0) declaredU (.scalar _ _ (.literal .int32 0))
  have vRun : Exec KeygenPublicSource.program [] PublicTailShape159.vInit withU ⟨after,.normal⟩ :=
    .assign _ _ _ .uint64 oldV (u64 512) declaredV (v_eval withU profile)
  have w0 := PublicGenerateRow159.u32_slot_after s "w" word
  have w1 := PublicGenerateRow159.keep_slot withW "w" "u" .uint64 (u64 0) word (by decide) w0
  have w2 := PublicGenerateRow159.keep_slot withU "w" "v" .uint64 (u64 512) word (by decide) w1
  have fixed : Fixed after a gm :=
    ⟨PublicTailPrefix164.initialized_arrays s after a gm ctx rfl (PublicInitializedFrame164.refl s.heap),
      cubic,length,word,w2⟩
  exact ⟨after,.seqNormal _ _ s withW ⟨after,.normal⟩ wRun
    (.seqNormal _ _ withW withU ⟨after,.normal⟩ uRun vRun),fixed,
    PublicGenerateRow159.keep_u64 withU "u" "v" .uint64 (u64 512) 0 (by decide)
      (PublicGenerateRow159.u64_slot_after withW "u" 0 (by decide)),
    PublicGenerateRow159.u64_slot_after withU "v" 512 (by decide)⟩

theorem source (s : State) (a gm : ArrayPointer) (ctx : Arrays s a gm)
    (cubic : s.arrays "gm_cubic".toList=some gm)
    (length : USlot s "n" 1536) (profile : Slot s "logn" 10)
    (uCell : ∃ old, s.locals "u".toList=some (.uint64,old))
    (vCell : ∃ old, s.locals "v".toList=some (.uint64,old))
    (wCell : ∃ old, s.locals "w".toList=some (.uint32,old)) :
    ∃ after, Exec KeygenPublicSource.program [] tripling s ⟨after,.normal⟩ ∧
      Fixed after a gm ∧ USlot after "u" 1536 ∧ USlot after "v" 1024 := by
  obtain ⟨initial,initRun,fixed,uSlot,vSlot⟩ := initial_source s a gm ctx cubic length profile uCell vCell wCell
  obtain ⟨after,loopRun,lastFixed,lastU,lastV⟩ := PublicTripleLoop165.source initial a gm fixed uSlot vSlot
  cases initRun with
  | seqNormal _ _ _ middle _ seed init =>
      exact ⟨after,.seqNormal _ _ s middle ⟨after,.normal⟩ seed
        (.seqNormal _ _ middle after ⟨after,.normal⟩
          (.seqNormal _ _ middle initial ⟨after,.normal⟩ init loopRun) (.skip after)),lastFixed,lastU,lastV⟩
  | seqExit _ _ _ _ _ exit => exact (exit rfl).elim

end FT1536.Source3.PublicTripleStart165
