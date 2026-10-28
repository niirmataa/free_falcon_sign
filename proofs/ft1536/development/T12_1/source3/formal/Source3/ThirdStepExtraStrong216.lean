import Source3.ThirdStepExtraFrame216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The counted d=3 additional-prime loop (part 4): `for (u = slen;
   u < tlen; u ++)` at slen = 3 / tlen = 6, the three counted
   iterations over the PRIMES3 rows 3..5 from the u = 3 initializer to
   the false u < 6 guard. The loop produces the fd/gd product columns
   3..5 with exact executed words and preserves the fs/gs reassembled
   images, every earlier column and the readonly tables. Executed
   words only; no NTT/Montgomery/CRT/table law is claimed. -/
namespace FT1536.Source3.ThirdStepExtraStrong216
open C99ArrayReference (State Name restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepCopy203 (Side)
open SecondStepProduct203 (root)
open ThirdStepLayout215 (fd gd fs gs gm igm t1)
open SecondStepGeometry203 (scratch ordered)
open KeygenFullData127 (primes rev)
open KeygenStaticTables (values)
open ThirdStepGenerator215 (Basic Outer rxVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open ZintNormWalkFlat208 (Data)
open StepProductFixed203 (Image)
open ThirdStepExtraPair215 (sWords)
open ThirdStepExtraInner215 (Earlier)
open ThirdStepExtra215
open ThirdStepExtraFrame216 (ThreeKeep)

theorem source (s : State) (F G : Nat → BitVec 32) (o : Outer s 3)
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revB : s.tables "REV10".toList=some rev)
    (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (fdata : Data s fs 384 F) (gdata : Data s gs 384 G) :
    ∃ (out : State) (gvs3 gvs4 gvs5 : Fin 128 → BitVec 32),
      Exec MakeFgAddPrimeShape194.part4 s ⟨out,.normal⟩ ∧ Outer out 6 ∧
      Image out fd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords F gvs3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64 ∧
      Image out fd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords F gvs4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64 ∧
      Image out fd 5 6 64 (pVal v5) (iVal v5) (rVal v5) (sWords F gvs5 (pVal v5) (iVal v5) (rVal v5) (rxVal v5)) 64 ∧
      Image out gd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords G gvs3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64 ∧
      Image out gd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords G gvs4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64 ∧
      Image out gd 5 6 64 (pVal v5) (iVal v5) (rVal v5) (sWords G gvs5 (pVal v5) (iVal v5) (rVal v5) (rxVal v5)) 64 ∧
      Data out fs 384 F ∧ Data out gs 384 G ∧
      KeygenStaticTables.PrimeObject out.heap primes .ternary ∧
      out.tables "REV10".toList=some rev ∧
      KeygenMkgm3RevMemory.SourceTable out.heap rev ∧
      ThreeKeep s out := by
  have input3 : CrtPrimePrefix214.Input s 3 v3 := ⟨by omega,o.uCell,rowV3,o.primesBinding,object⟩
  obtain ⟨out3,gvs3,run3,basic3,fd3,gd3,ls3,ars3,keep3⟩ :=
    ThirdStepExtraInner215.source s 3 v3 F G o input3 (by decide) revB revS fdata gdata
  have object3 : KeygenStaticTables.PrimeObject out3.heap primes .ternary := object_keep object run3
  have revB3 : out3.tables "REV10".toList=some rev := revB_keep revB run3
  have revS3 : KeygenMkgm3RevMemory.SourceTable out3.heap rev := rev_keep revS run3
  let s1 := counter s out3 4
  have object3s : KeygenStaticTables.PrimeObject s1.heap primes .ternary := by rw [counter_heap]; exact object3
  have revS3s : KeygenMkgm3RevMemory.SourceTable s1.heap rev := by rw [counter_heap]; exact revS3
  have revB3s : s1.tables "REV10".toList=some rev := revB3
  have o1 : Outer s1 4 := outer_counter basic3 s 4
  have input4 : CrtPrimePrefix214.Input s1 4 v4 := input_counter basic3 s 4 (by decide) v4 rowV4 object3s
  have fdata1 : Data s1 fs 384 F := by
    intro i bound; rw [counter_heap]; exact keep3 _ _ (earlier_fs 3 (by decide) i bound) (fdata i bound)
  have gdata1 : Data s1 gs 384 G := by
    intro i bound; rw [counter_heap]; exact keep3 _ _ (earlier_gs 3 (by decide) i bound) (gdata i bound)
  obtain ⟨out4,gvs4,run4,basic4,fd4,gd4,ls4,ars4,keep4⟩ :=
    ThirdStepExtraInner215.source s1 4 v4 F G o1 input4 (by decide) revB3s revS3s fdata1 gdata1
  have object4 : KeygenStaticTables.PrimeObject out4.heap primes .ternary := object_keep object3s run4
  have revB4 : out4.tables "REV10".toList=some rev := revB_keep revB3s run4
  have revS4 : KeygenMkgm3RevMemory.SourceTable out4.heap rev := rev_keep revS3s run4
  let s2 := counter s1 out4 5
  have object4s : KeygenStaticTables.PrimeObject s2.heap primes .ternary := by rw [counter_heap]; exact object4
  have revS4s : KeygenMkgm3RevMemory.SourceTable s2.heap rev := by rw [counter_heap]; exact revS4
  have revB4s : s2.tables "REV10".toList=some rev := revB4
  have o2 : Outer s2 5 := outer_counter basic4 s1 5
  have input5 : CrtPrimePrefix214.Input s2 5 v5 := input_counter basic4 s1 5 (by decide) v5 rowV5 object4s
  have fdata2 : Data s2 fs 384 F := fs_keep_u keep4 fdata1 (by decide)
  have gdata2 : Data s2 gs 384 G := gs_keep_u keep4 gdata1 (by decide)
  obtain ⟨out5,gvs5,run5,basic5,fd5,gd5,ls5,ars5,keep5⟩ :=
    ThirdStepExtraInner215.source s2 5 v5 F G o2 input5 (by decide) revB4s revS4s fdata2 gdata2
  have object5 : KeygenStaticTables.PrimeObject out5.heap primes .ternary := object_keep object4s run5
  have revB5 : out5.tables "REV10".toList=some rev := revB_keep revB4s run5
  have revS5 : KeygenMkgm3RevMemory.SourceTable out5.heap rev := rev_keep revS4s run5
  let out := counter s2 out5 6
  have fd3f : Image out fd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords F gvs3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64 :=
    image_keep (u:=5) (k:=3) (side:=.f) keep5
      (image_keep (u:=4) (k:=3) (side:=.f) keep4 fd3 (by decide) (by decide) (by decide))
      (by decide) (by decide) (by decide)
  have fd4f : Image out fd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords F gvs4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64 :=
    image_keep (u:=5) (k:=4) (side:=.f) keep5 fd4 (by decide) (by decide) (by decide)
  have gd3f : Image out gd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords G gvs3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64 :=
    image_keep (u:=5) (k:=3) (side:=.g) keep5
      (image_keep (u:=4) (k:=3) (side:=.g) keep4 gd3 (by decide) (by decide) (by decide))
      (by decide) (by decide) (by decide)
  have gd4f : Image out gd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords G gvs4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64 :=
    image_keep (u:=5) (k:=4) (side:=.g) keep5 gd4 (by decide) (by decide) (by decide)
  have fdataF : Data out fs 384 F := fs_keep_u keep5 (fs_keep_u keep4 fdata1 (by decide)) (by decide)
  have gdataF : Data out gs 384 G := gs_keep_u keep5 (gs_keep_u keep4 gdata1 (by decide)) (by decide)
  have loopEnd : Exec MakeFgAddPrimeShape194.aLoop out ⟨out,.normal⟩ :=
    .loopFalse _ _ _ _ (.int32 0) (guard6 s2 out5 basic5.tlenCell) rfl
  have loop5 : Exec MakeFgAddPrimeShape194.aLoop s2 ⟨out,.normal⟩ :=
    .loopNormal _ _ _ s2 (scopedState s2 out5) out _ (.int32 1) (guard5 s1 out4 basic4.tlenCell) (by decide)
      (scope_source s2 out5 run5) (incrementK s2 out5 5 (by decide) basic5.uCell) loopEnd
  have loop4 : Exec MakeFgAddPrimeShape194.aLoop s1 ⟨out,.normal⟩ :=
    .loopNormal _ _ _ s1 (scopedState s1 out4) s2 _ (.int32 1) (guard4 s out3 basic3.tlenCell) (by decide)
      (scope_source s1 out4 run4) (incrementK s1 out4 4 (by decide) basic4.uCell) loop5
  have loop3 : Exec MakeFgAddPrimeShape194.aLoop s ⟨out,.normal⟩ :=
    .loopNormal _ _ _ s (scopedState s out3) s1 _ (.int32 1) (guard_start s o) (by decide)
      (scope_source s out3 run3) (incrementK s out3 3 (by decide) basic3.uCell) loop4
  have part : Exec MakeFgAddPrimeShape194.part4 s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.part4_split,MakeFgAddPrimeShape194.aFor_split,MakeFgAddPrimeShape194.aTail_skip]
    exact .seqNormal _ _ _ out _ (.seqNormal _ _ _ s _ (init_source s o) loop3)
      (SelectedStepAddPrime195.skip_run out)
  refine ⟨out,gvs3,gvs4,gvs5,part,outer_counter basic5 s2 6,fd3f,fd4f,?_,gd3f,gd4f,?_,fdataF,gdataF,?_,?_,?_,?_⟩
  · intro i bound
    rw [counter_heap]
    exact fd5 i bound
  · intro i bound
    rw [counter_heap]
    exact gd5 i bound
  · rw [counter_heap]; exact object5
  · exact revB5
  · rw [counter_heap]; exact revS5
  · intro q old earlier3 earlier4 earlier5 read
    exact keep5 q old earlier5 (keep4 q old earlier4 (keep3 q old earlier3 read))

end FT1536.Source3.ThirdStepExtraStrong216
