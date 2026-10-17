import Source3.PublicGenerateUpper159

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Composition of the row-side initializers initK/initB/initU with the
   complete remaining statement (the 256-iteration row loop), feeding the
   afterRows suffix and exposing the WrittenRange 0 1024 handoff on both
   tables. Value-free: constructive executions of the pinned statements
   only; no table image, root property or semantic premise enters. -/
namespace FT1536.Source3.PublicGenerateRemaining159
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value Ty)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicWord (Eval Address)
open KeygenPublicTableAtoms (Slot)
open KeygenNttLoopSupport (USlot u64)
open PublicGenerateTable159 (Tables Written WrittenRange)
open PublicGenerateUpper159 (AfterEntry)
open PublicGenerateRow159 (RowInv)
open KeygenSmallOutput (element)

theorem sub_11_10 : C99IntegerReference.ArithmeticExec .minus
    (C99IntegerReference.convert .int32 11)
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 1)) :=
  C99IntegerReference.ArithmeticExec.step .minus
    (C99IntegerReference.convert .int32 11)
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10)) .uint32 rfl
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 11))
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10)) rfl
    (C99CountedWords.convert_self (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))).symm
    (by intro impossible; cases impossible)

theorem sub_10_1 : C99IntegerReference.ArithmeticExec .minus
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))
    (C99IntegerReference.convert .int32 1)
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 9)) :=
  C99IntegerReference.ArithmeticExec.step .minus
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))
    (C99IntegerReference.convert .int32 1) .uint32 rfl
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))
    (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 1))
    (C99CountedWords.convert_self (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))).symm rfl
    (by intro impossible; cases impossible)

/- Executions of the three row-side initializers. -/
theorem initK_exec (s : State) (logn : Slot s "logn" 10) (old : Option Value)
    (kk : s.locals "k".toList=some (.uint32,old)) :
    Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initK s
      ⟨bindValue s "k".toList .uint32 (.uint32 (BitVec.ofNat 32 1)),.normal⟩ ∧
      Slot (bindValue s "k".toList .uint32 (.uint32 (BitVec.ofNat 32 1))) "k" 1 := by
  have eval : Eval [] s
      (.bin .sub (KeygenPublicTableAtoms.literal 11) (KeygenPublicTableAtoms.var "logn"))
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 1)) :=
    KeygenPublicWord.Eval.bin .sub _ _
      (C99IntegerReference.convert .int32 11) (.uint32 10) _
      (PublicGenerateHead159.eval_lit s 11) (PublicGenerateHead159.eval_var s "logn" 10 logn) sub_11_10
  refine ⟨?_,?_⟩
  · exact .assign "k".toList _ _ .uint32 old (.uint32 (BitVec.ofNat 32 1)) kk eval
  · show (C99ScalarReference.set s.locals "k".toList
      (C99IntegerReference.Ty.uint32,
        some (C99IntegerReference.convert .uint32
          (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 1)).integer))) "k".toList=_
    simp only [C99ScalarReference.set,ite_true]
    rfl

theorem initB_exec (s : State) (logn : Slot s "logn" 10) (old : Option Value)
    (bb : s.locals "b".toList=some (.uint64,old)) :
    Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initB s
      ⟨bindValue s "b".toList .uint64 (u64 512),.normal⟩ ∧
      USlot (bindValue s "b".toList .uint64 (u64 512)) "b" 512 := by
  have inner : Eval [] s
      (.bin .sub (KeygenPublicTableAtoms.var "logn") (KeygenPublicTableAtoms.literal 1))
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 9)) :=
    KeygenPublicWord.Eval.bin .sub _ _ (.uint32 10) (C99IntegerReference.convert .int32 1) _
      (PublicGenerateHead159.eval_var s "logn" 10 logn) (PublicGenerateHead159.eval_lit s 1) sub_10_1
  have outer : Eval [] s
      (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1))
        (.bin .sub (KeygenPublicTableAtoms.var "logn") (KeygenPublicTableAtoms.literal 1)))
      (u64 (2^9)) :=
    KeygenPublicWord.Eval.bin .shl _ _ (u64 1) _ _
      (PublicGenerateIndex159.word_cast_u64_one s) inner
      (PublicGenerateIndex159.shl_pow 9 (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 9))
        (PublicGenerateIndex159.u32_integer 9 (by decide)) (by decide))
  refine ⟨?_,PublicGenerateUpper159.u64_slot_after s "b" 512 (by decide)⟩
  show Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initB s
    ⟨bindValue s "b".toList .uint64 (u64 (2^9)),.normal⟩
  exact .assign "b".toList _ _ .uint64 old (u64 (2^9)) bb outer

theorem initU_exec (s : State) (old : Option Value)
    (uu : s.locals "u".toList=some (.uint64,old)) :
    Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initU s
      ⟨bindValue s "u".toList .uint64 (u64 0),.normal⟩ ∧
      USlot (bindValue s "u".toList .uint64 (u64 0)) "u" 0 := by
  refine ⟨?_,PublicGenerateUpper159.u64_slot_after s "u" 0 (by decide)⟩
  show Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initU s
    ⟨bindValue s "u".toList .uint64 (C99IntegerReference.convert .int32 0),.normal⟩
  exact .assign "u".toList _ _ .uint64 old (C99IntegerReference.convert .int32 0) uu
    (PublicGenerateHead159.eval_lit s 0)

/- Value-free entry of the row part: declared counters and the six factor
   slots; the factor values stay unconstrained. -/
structure RowEntry (s : State) (gm igm : ArrayPointer) : Prop where
  tables : Tables s gm igm
  lognSlot : Slot s "logn" 10
  kCell : ∃ old, s.locals "k".toList=some (.uint32,old)
  bCell : ∃ old, s.locals "b".toList=some (.uint64,old)
  uCell : ∃ old, s.locals "u".toList=some (.uint64,old)
  wCell : s.locals "w".toList=some (.uint32,none)
  xSlot : ∃ w, Slot s "x" w
  ixSlot : ∃ w, Slot s "ix" w
  g2Slot : ∃ w, Slot s "g2" w
  g4Slot : ∃ w, Slot s "g4" w
  ig2Slot : ∃ w, Slot s "ig2" w
  ig4Slot : ∃ w, Slot s "ig4" w

/- initK/initB/initU + the row loop: the complete remaining statement. -/
theorem remaining_source (s : State) (gm igm : ArrayPointer) (entry : RowEntry s gm igm) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicTableRows.remaining s ⟨after,.normal⟩ ∧
      AfterEntry after gm igm ∧ USlot after "u" 512 := by
  rw [KeygenPublicLastProgram.source_remaining]
  obtain ⟨oldK,kk⟩ := entry.kCell
  obtain ⟨oldB,bb⟩ := entry.bCell
  obtain ⟨oldU,uu⟩ := entry.uCell
  obtain ⟨xw,xH⟩ := entry.xSlot
  obtain ⟨ixw,ixH⟩ := entry.ixSlot
  obtain ⟨g2w,g2H⟩ := entry.g2Slot
  obtain ⟨g4w,g4H⟩ := entry.g4Slot
  obtain ⟨ig2w,ig2H⟩ := entry.ig2Slot
  obtain ⟨ig4w,ig4H⟩ := entry.ig4Slot
  set s1 : State := bindValue s "k".toList .uint32 (.uint32 (BitVec.ofNat 32 1))
  have kFacts := initK_exec s entry.lognSlot oldK kk
  have kExec : Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initK s ⟨s1,.normal⟩ := by
    show Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initK s
      ⟨bindValue s "k".toList .uint32 (.uint32 (BitVec.ofNat 32 1)),.normal⟩
    exact kFacts.1
  have kSlot1 : Slot s1 "k" 1 := by
    show Slot (bindValue s "k".toList .uint32 (.uint32 (BitVec.ofNat 32 1))) "k" 1
    exact kFacts.2
  have logn1 : Slot s1 "logn" 10 :=
    (PublicGenerateUpper159.bind_keep s .uint32 (.uint32 (BitVec.ofNat 32 1)) "k" "logn"
      (by decide)).trans entry.lognSlot
  have bCell1 : ∃ old, s1.locals "b".toList=some (.uint64,old) :=
    ⟨oldB,(PublicGenerateUpper159.bind_keep s .uint32 (.uint32 (BitVec.ofNat 32 1)) "k" "b"
      (by decide)).trans bb⟩
  have uEq1 : s1.locals "u".toList=some (.uint64,oldU) :=
    (PublicGenerateUpper159.bind_keep s .uint32 (.uint32 (BitVec.ofNat 32 1)) "k" "u"
      (by decide)).trans uu
  have wCell1 : s1.locals "w".toList=some (.uint32,none) :=
    (PublicGenerateUpper159.bind_keep s .uint32 (.uint32 (BitVec.ofNat 32 1)) "k" "w"
      (by decide)).trans entry.wCell
  have x1 : Slot s1 "x" xw :=
    PublicGenerateUpper159.keep_slot s "x" "k" .uint32 (.uint32 (BitVec.ofNat 32 1)) xw (by decide) xH
  have ix1 : Slot s1 "ix" ixw :=
    PublicGenerateUpper159.keep_slot s "ix" "k" .uint32 (.uint32 (BitVec.ofNat 32 1)) ixw (by decide) ixH
  have g21 : Slot s1 "g2" g2w :=
    PublicGenerateUpper159.keep_slot s "g2" "k" .uint32 (.uint32 (BitVec.ofNat 32 1)) g2w (by decide) g2H
  have g41 : Slot s1 "g4" g4w :=
    PublicGenerateUpper159.keep_slot s "g4" "k" .uint32 (.uint32 (BitVec.ofNat 32 1)) g4w (by decide) g4H
  have ig21 : Slot s1 "ig2" ig2w :=
    PublicGenerateUpper159.keep_slot s "ig2" "k" .uint32 (.uint32 (BitVec.ofNat 32 1)) ig2w (by decide) ig2H
  have ig41 : Slot s1 "ig4" ig4w :=
    PublicGenerateUpper159.keep_slot s "ig4" "k" .uint32 (.uint32 (BitVec.ofNat 32 1)) ig4w (by decide) ig4H
  obtain ⟨oldB1,b1c⟩ := bCell1
  set s2 : State := bindValue s1 "b".toList .uint64 (u64 512)
  have bFacts := initB_exec s1 logn1 oldB1 b1c
  have bExec : Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initB s1 ⟨s2,.normal⟩ := by
    show Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initB s1
      ⟨bindValue s1 "b".toList .uint64 (u64 512),.normal⟩
    exact bFacts.1
  have bSlot2 : USlot s2 "b" 512 := by
    show USlot (bindValue s1 "b".toList .uint64 (u64 512)) "b" 512
    exact bFacts.2
  have kSlot2 : Slot s2 "k" 1 :=
    (PublicGenerateUpper159.keep_slot s1 "k" "b" .uint64 (u64 512) 1 (by decide) kSlot1)
  have logn2 : Slot s2 "logn" 10 :=
    PublicGenerateUpper159.keep_slot s1 "logn" "b" .uint64 (u64 512) 10 (by decide) logn1
  have uCell2 : ∃ old, s2.locals "u".toList=some (.uint64,old) :=
    ⟨oldU,(PublicGenerateUpper159.bind_keep s1 .uint64 (u64 512) "b" "u" (by decide)).trans uEq1⟩
  have wCell2 : s2.locals "w".toList=some (.uint32,none) :=
    (PublicGenerateUpper159.bind_keep s1 .uint64 (u64 512) "b" "w" (by decide)).trans wCell1
  have x2 : Slot s2 "x" xw := PublicGenerateUpper159.keep_slot s1 "x" "b" .uint64 (u64 512) xw (by decide) x1
  have ix2 : Slot s2 "ix" ixw := PublicGenerateUpper159.keep_slot s1 "ix" "b" .uint64 (u64 512) ixw (by decide) ix1
  have g22 : Slot s2 "g2" g2w := PublicGenerateUpper159.keep_slot s1 "g2" "b" .uint64 (u64 512) g2w (by decide) g21
  have g42 : Slot s2 "g4" g4w := PublicGenerateUpper159.keep_slot s1 "g4" "b" .uint64 (u64 512) g4w (by decide) g41
  have ig22 : Slot s2 "ig2" ig2w := PublicGenerateUpper159.keep_slot s1 "ig2" "b" .uint64 (u64 512) ig2w (by decide) ig21
  have ig42 : Slot s2 "ig4" ig4w := PublicGenerateUpper159.keep_slot s1 "ig4" "b" .uint64 (u64 512) ig4w (by decide) ig41
  obtain ⟨oldU2,u2c⟩ := uCell2
  set s3 : State := bindValue s2 "u".toList .uint64 (u64 0)
  have uFacts := initU_exec s2 oldU2 u2c
  have uExec : Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initU s2 ⟨s3,.normal⟩ := by
    show Exec KeygenPublicSource.program [] KeygenPublicLastProgram.initU s2
      ⟨bindValue s2 "u".toList .uint64 (u64 0),.normal⟩
    exact uFacts.1
  have uSlot3 : USlot s3 "u" 0 := by
    show USlot (bindValue s2 "u".toList .uint64 (u64 0)) "u" 0
    exact uFacts.2
  have kSlot3 : Slot s3 "k" 1 :=
    PublicGenerateUpper159.keep_slot s2 "k" "u" .uint64 (u64 0) 1 (by decide) kSlot2
  have bSlot3 : USlot s3 "b" 512 :=
    PublicGenerateRow159.keep_u64 s2 "b" "u" .uint64 (u64 0) 512 (by decide) bSlot2
  have logn3 : Slot s3 "logn" 10 :=
    PublicGenerateUpper159.keep_slot s2 "logn" "u" .uint64 (u64 0) 10 (by decide) logn2
  have wCell3 : s3.locals "w".toList=some (.uint32,none) :=
    (PublicGenerateUpper159.bind_keep s2 .uint64 (u64 0) "u" "w" (by decide)).trans wCell2
  have x3 : Slot s3 "x" xw := PublicGenerateUpper159.keep_slot s2 "x" "u" .uint64 (u64 0) xw (by decide) x2
  have ix3 : Slot s3 "ix" ixw := PublicGenerateUpper159.keep_slot s2 "ix" "u" .uint64 (u64 0) ixw (by decide) ix2
  have g23 : Slot s3 "g2" g2w := PublicGenerateUpper159.keep_slot s2 "g2" "u" .uint64 (u64 0) g2w (by decide) g22
  have g43 : Slot s3 "g4" g4w := PublicGenerateUpper159.keep_slot s2 "g4" "u" .uint64 (u64 0) g4w (by decide) g42
  have ig23 : Slot s3 "ig2" ig2w := PublicGenerateUpper159.keep_slot s2 "ig2" "u" .uint64 (u64 0) ig2w (by decide) ig22
  have ig43 : Slot s3 "ig4" ig4w := PublicGenerateUpper159.keep_slot s2 "ig4" "u" .uint64 (u64 0) ig4w (by decide) ig42
  have inv3 : RowInv s3 gm igm 0 := by
    refine ⟨PublicGenerateUpper159.tables_frame s s3 gm igm entry.tables rfl rfl rfl,
      logn3,uSlot3,kSlot3,bSlot3,
      ⟨xw,x3⟩,⟨ixw,ix3⟩,⟨g2w,g23⟩,⟨g4w,g43⟩,⟨ig2w,ig23⟩,⟨ig4w,ig43⟩,?_⟩
    intro j hj
    omega
  obtain ⟨after,loopExec,invAfter⟩ := PublicGenerateRow159.loop_source 256 0 s3 gm igm inv3 (by decide)
  have top := PublicGenerateRow159.covered_top after gm igm invAfter
  have wCell : after.locals "w".toList=some (.uint32,none) := by
    have keepLoop := PublicGenerateUpper159.cell_frame KeygenPublicLastProgram.loop s3 after "w"
      (by decide) (by decide) loopExec
    rw [keepLoop]
    exact wCell3
  have afterEntry : AfterEntry after gm igm := by
    refine ⟨invAfter.tables,invAfter.lognSlot,?_,?_,wCell,?_⟩
    · exact ⟨some (.uint32 1),invAfter.kSlot⟩
    · exact ⟨some (u64 512),invAfter.counter⟩
    · intro j lo hi
      exact ⟨top.1 j lo hi,top.2 j lo hi⟩
  have uFinal : USlot after "u" 512 := invAfter.counter
  have cLast : Exec KeygenPublicSource.program []
      (.seq (.seq KeygenPublicLastProgram.initU KeygenPublicLastProgram.loop) .skip) s2 ⟨after,.normal⟩ :=
    .seqNormal (.seq KeygenPublicLastProgram.initU KeygenPublicLastProgram.loop) .skip s2 after
      ⟨after,.normal⟩
      (.seqNormal KeygenPublicLastProgram.initU KeygenPublicLastProgram.loop s2 s3 ⟨after,.normal⟩
        uExec loopExec) (.skip after)
  have cB : Exec KeygenPublicSource.program []
      (.seq KeygenPublicLastProgram.initB
        (.seq (.seq KeygenPublicLastProgram.initU KeygenPublicLastProgram.loop) .skip)) s1
      ⟨after,.normal⟩ :=
    .seqNormal KeygenPublicLastProgram.initB _ s1 s2 ⟨after,.normal⟩ bExec cLast
  have cK : Exec KeygenPublicSource.program [] KeygenPublicLastProgram.remaining s ⟨after,.normal⟩ :=
    .seqNormal KeygenPublicLastProgram.initK _ s s1 ⟨after,.normal⟩ kExec cB
  exact ⟨after,cK,afterEntry,uFinal⟩

/- Region 1d handoff to region 2: the whole row part and the generator
   suffix leave WrittenRange 0 1024 on both arrays. -/
theorem generator_suffix_source (s : State) (gm igm : ArrayPointer) (entry : RowEntry s gm igm) :
    ∃ mid after, Exec KeygenPublicSource.program [] KeygenPublicTableRows.remaining s ⟨mid,.normal⟩ ∧
      Exec KeygenPublicSource.program [] KeygenPublicTableRows.afterRows mid ⟨after,.normal⟩ ∧
      WrittenRange after.heap gm 0 1024 ∧ WrittenRange after.heap igm 0 1024 := by
  obtain ⟨mid,restExec,entry',_⟩ := remaining_source s gm igm entry
  obtain ⟨after,tailExec,gmR,igmR⟩ := PublicGenerateUpper159.afterRows_source mid gm igm entry'
  exact ⟨mid,after,restExec,tailExec,gmR,igmR⟩

theorem suffix_seq_source (s : State) (gm igm : ArrayPointer) (entry : RowEntry s gm igm) :
    ∃ after, Exec KeygenPublicSource.program []
      (.seq KeygenPublicTableRows.remaining KeygenPublicTableRows.afterRows) s ⟨after,.normal⟩ ∧
      WrittenRange after.heap gm 0 1024 ∧ WrittenRange after.heap igm 0 1024 := by
  obtain ⟨mid,after,restExec,tailExec,gmR,igmR⟩ := generator_suffix_source s gm igm entry
  exact ⟨after,.seqNormal _ _ s mid ⟨after,.normal⟩ restExec tailExec,gmR,igmR⟩

end FT1536.Source3.PublicGenerateRemaining159
