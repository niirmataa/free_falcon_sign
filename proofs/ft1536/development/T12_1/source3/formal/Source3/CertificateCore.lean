import Source3.CertificateExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateCore
open CertificateMemory CertificateEffects CertificateAtoms StableBinaryByteView

def firstSnapshot (l : Layout) (s : State) : Fin 768 → BitVec 64 := fun i => (read l s i.val).getD 0
theorem snapshot_valid (l : Layout) (s : State) (hr : ∀ i<768, (read l s i).isSome) :
    CertificateReverse.Snapshot l (firstSnapshot l s) s := by
  intro i
  obtain ⟨w,hw⟩:=Option.isSome_iff_exists.mp (hr i.val i.isLt)
  simp [firstSnapshot,hw]

structure Parts (l : Layout) (initial : State) (out : RState) (ret : Bool)
    (topState reverseState : State) (D : Fin 768 → BitVec 64) : Prop where
  top : CertificateTop.Exec l (decode initial) (decode topState)
  reverse : CertificateReverse.Finished l CertificateQSquared.word (decode topState) (decode reverseState)
  scan : CertificateScan.Exec l 0 (decode reverseState) out
  returned : CertificateReturn.Exec l out ret
  topEffect : Effect l initial topState
  reverseEffect : Effect l topState reverseState
  scanEffect : Effect l reverseState (encode out)
  first : CertificateReverse.Snapshot l D topState
  preserved : CertificateReverse.Snapshot l D reverseState
  writes : CertificateReverse.Written l CertificateQSquared.word D 768 reverseState

theorem reference_exists (l : Layout) (before : C99MemoryReference.Memory) (hl : WellFormed l)
    (legal : Legal l (C99MemoryBridge.encode before)) :
    ∃ after trace ret, CertificateExec.PinnedExec l before after trace ret := by
  let initial : State:=⟨C99MemoryBridge.encode before,[]⟩
  obtain ⟨topState,ht,et,rt⟩:=CertificateTop.exists_execution l hl initial legal
  let D:=firstSnapshot l topState
  have snap : CertificateReverse.Snapshot l D topState := snapshot_valid l topState rt
  obtain ⟨reverseState,hr,er,sr,wr⟩:=CertificateReverse.loop_exists l hl CertificateQSquared.word D
    topState et.legal snap 768 (by omega)
  have reads:=CertificateReverse.initialized l CertificateQSquared.word D reverseState sr wr
  obtain ⟨out,hs,es,_⟩:=CertificateScan.exists_execution l hl reverseState er.legal reads
  obtain ⟨ret,hret,_⟩:=CertificateReturn.exists_execution l hl out es.legal
  refine ⟨C99MemoryBridge.decode out.heap,out.trace,ret,CertificateSuffixSyntax.expected,
    CertificateSuffixSyntax.pinned_source,?_⟩
  apply CertificateExec.Exec.sequence (decode topState) (decode reverseState) (decode out)
    CertificateQSquared.word ret rfl (CertificateExec.bound_pointers l)
  · simpa only [initial,decode,C99MemoryBridge.decode_encode] using ht
  · exact CertificateQSquared.source_exists
  · exact ⟨768,hr,by omega⟩
  · exact hs
  · exact hret

theorem complete (l : Layout) (before after : C99MemoryReference.Memory) (trace : List Event) (ret : Bool)
    (hl : WellFormed l) (legal : Legal l (C99MemoryBridge.encode before))
    (h : CertificateExec.PinnedExec l before after trace ret) :
    CertificateExec.run l (C99MemoryBridge.encode before)=some ⟨⟨C99MemoryBridge.encode after,trace⟩,ret⟩ ∧
      Safe l (C99MemoryBridge.encode before) ⟨C99MemoryBridge.encode after,trace⟩ ∧
      ∃ topState reverseState D, Parts l ⟨C99MemoryBridge.encode before,[]⟩ ⟨after,trace⟩ ret topState reverseState D := by
  obtain ⟨code,_,he⟩:=h
  cases he with
  | sequence topRef reverseRef _ q _ hform _ ht hq hr hs hret =>
      subst code
      have hqword : q=CertificateQSquared.word := C99IntegerReference.Value.uint64.inj (CertificateQSquared.source_exact _ hq)
      subst q
      let initial : State:=⟨C99MemoryBridge.encode before,[]⟩
      have ht' : CertificateTop.Exec l (decode initial) topRef := by simpa only [initial,decode,C99MemoryBridge.decode_encode] using ht
      obtain ⟨hmt,et,readsTop⟩:=CertificateTop.complete l hl initial topRef legal ht'
      let D:=firstSnapshot l (encode topRef)
      have snap : CertificateReverse.Snapshot l D (encode topRef) := snapshot_valid l (encode topRef) readsTop
      have hr' : CertificateReverse.Finished l CertificateQSquared.word (decode (encode topRef)) reverseRef := by
        simpa only [decode_encode] using hr
      obtain ⟨hmr,er,sr,wr⟩:=CertificateReverse.finished_complete l hl CertificateQSquared.word D (encode topRef) reverseRef et.legal snap hr'
      have reads:=CertificateReverse.initialized l CertificateQSquared.word D (encode reverseRef) sr wr
      have hs' : CertificateScan.Exec l 0 (decode (encode reverseRef)) ⟨after,trace⟩ := by simpa only [decode_encode] using hs
      obtain ⟨hms,es,_⟩:=CertificateScan.source_refinement l hl (encode reverseRef) ⟨after,trace⟩ er.legal reads hs'
      have hmret:=CertificateReturn.complete l ⟨after,trace⟩ ret hret
      have safe:=(effect_trans (effect_trans et er) es).safe _ (safe_initial l (C99MemoryBridge.encode before))
      refine ⟨?_,safe,encode topRef,encode reverseRef,D,?_⟩
      · rw [CertificateExec.run_expansion]
        change (CertificateTop.run l initial).bind _ = _
        rw [hmt]
        dsimp only [Option.bind]
        rw [hmr]
        dsimp only [Option.bind]
        rw [hms]
        dsimp only [Option.bind]
        rw [hmret]
        rfl
      · refine ⟨?_,?_,hs',hret,et,er,es,snap,sr,wr⟩
        · simpa only [decode_encode] using ht'
        · simpa only [decode_encode] using hr'

end FT1536.Source3.CertificateCore

#check @FT1536.Source3.CertificateCore.reference_exists
#check @FT1536.Source3.CertificateCore.complete
#print axioms FT1536.Source3.CertificateCore.reference_exists
#print axioms FT1536.Source3.CertificateCore.complete
