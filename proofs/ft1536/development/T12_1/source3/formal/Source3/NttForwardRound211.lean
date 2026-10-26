import Source3.NttForwardU1Image211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generic-size original mInner execution with exact round words. -/
namespace FT1536.Source3.NttForwardRound211
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)
open NttForwardImage211 (Image)
open NttForwardMiddle211
variable {size : Nat}

theorem m_body_image (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (m t h : Nat) (W : Nat → BitVec 32)
    (fixed : MFixed (size:=size) s a gm gvs pw p0i) (image : Image (size:=size) s a W)
    (mt : m*t=size) (th : t=2*h) (mb : 2*m≤size) (tb : t≤256) (hpos : 0<h) (wide : size≤gmn)
    (mc : USlot s "m" m) (tc : USlot s "t" t) :
    ∃ out, Exec mBlock s ⟨out,.normal⟩ ∧ MFixed (size:=size) out a gm gvs pw p0i ∧ USlot out "t" h ∧
      NttWriteFrame182.Frame a size s.heap out.heap ∧
      Image (size:=size) out a (NttForwardU1Image211.roundWords gvs W m t h pw p0i) := by
  have sizeLimit:=fixed.sizeBound
  have dc : Exec (KeygenNttForwardPrograms.sizeDeclaration ["ht","u1","v1"]) s
      ⟨mDeclared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 mNames s)
  have half : t/2=h := by omega
  have hc : USlot (mPrepared s h) "ht" h :=
    KeygenMkgm3RowInit.set64_slot (mDeclared s) "ht" h (by omega)
  have halfRun : Exec KeygenNttForwardPrograms.htAssign (mDeclared s) ⟨mPrepared s h,.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 h) rfl (.scalar _ _
      (by simpa only [half,KeygenNttForwardPrograms.var,KeygenNttForwardPrograms.num,
        KeygenNttLoopSupport.u64,C99NatWord141.word] using
        (C99OuterScalar144.half_eval (mDeclared s) "t".toList t (by omega) tc)))
  obtain ⟨vo,vRun,vFixed,vu,frame,wordImage⟩ := NttForwardU1Image211.u1_loop_full_image m t h mt th mb tb hpos
    (mPrepared s h) a gm gvs pw p0i W wide (m_prepared_fixed s a gm gvs pw p0i h fixed)
    (NttForwardImage211.image_keep image rfl)
    mc tc hc none none rfl rfl
  have htOut : USlot vo "ht" h := KeygenNttControl.keep_u64 vRun (by decide) "ht" h (by decide) hc
  have tOut : USlot vo "t" t := KeygenNttControl.keep_u64 vRun (by decide) "t" t (by decide) tc
  have tRun : Exec KeygenNttForwardPrograms.tFromHalf2 vo
      ⟨bindValue vo "t".toList .uint64 (u64 h),.normal⟩ :=
    .assign _ _ _ .uint64 (some (u64 t)) (u64 h) tOut (.scalar _ _ (.variable _ _ _ htOut))
  have inner : Exec KeygenNttForwardPrograms.mInner s
      ⟨bindValue vo "t".toList .uint64 (u64 h),.normal⟩ :=
    .seqNormal _ _ s (mDeclared s) _ dc
      (.seqNormal _ _ (mDeclared s) (mPrepared s h) _ halfRun
      (.seqNormal _ _ (mPrepared s h) vo _ vRun
      (.seqNormal _ _ vo (bindValue vo "t".toList .uint64 (u64 h)) _ tRun
        (.base .skip _ _ (.skip _)))))
  have run : Exec mBlock s
      ⟨C99ArrayReference.restoreScope s (bindValue vo "t".toList .uint64 (u64 h)) mNames [],.normal⟩ :=
    .scope mNames _ s ⟨bindValue vo "t".toList .uint64 (u64 h),.normal⟩ inner
  refine ⟨C99ArrayReference.restoreScope s (bindValue vo "t".toList .uint64 (u64 h)) mNames [],
    run,?_,?_,?_,?_⟩
  · exact fixed_map vo a gm gvs pw p0i vFixed
      (C99ArrayReference.restoreScope s (bindValue vo "t".toList .uint64 (u64 h)) mNames [])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ScalarReference.set,
        C99ArrayReference.restoreScope,C99ScalarReference.restore])
      (by simp [mNames,C99ArrayReference.bindValue,C99ArrayReference.restoreScope])
      (by simp [mNames,C99ArrayReference.bindValue,C99ArrayReference.restoreScope])
      rfl
  · exact KeygenMkgm3RowInit.set64_slot vo "t" h (by omega)
  · exact frame
  · exact NttForwardImage211.image_keep wordImage rfl


end FT1536.Source3.NttForwardRound211
