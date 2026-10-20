import Source3.C99HelperGroups

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99HelperCopy
open C99MemoryReference C99HelperObjects StableBinaryByteView

theorem write_trace (base i : Nat) (words : List (BitVec 64)) (s out : StableBinaryCExec.State)
    (h : StableBinaryCExec.writeCopy base i words s=some out) : out.checks=s.checks := by
  induction words generalizing i s with
  | nil => have he : s=out := Option.some.inj h; subst out; rfl
  | cons w rest ih =>
      obtain ⟨mid,hm,ht⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨heap,_,hr⟩ := Option.bind_eq_some_iff.mp hm
      have he : mid={s with heap := heap} := (Option.some.inj hr).symm
      have hc : mid.checks=s.checks := by rw [he]
      exact (ih (i+1) mid ht).trans hc

theorem copy_trace (dst src n : Nat) (s out : StableBinaryCExec.State)
    (h : StableBinaryCExec.copy s dst src n=some out) : out.checks=s.checks := by
  obtain ⟨words,_,hw⟩ := Option.bind_eq_some_iff.mp h
  exact write_trace dst 0 words s out hw

theorem model_memory (l : StableBinary.Layout) (k start n : Nat) (s out : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hbound : start+n≤l.length)
    (h : StableBinaryCExec.copy s (StableBinary.addr l.values start) l.scratch n=some out) :
    Memcpy (C99MemoryBridge.decode s.heap) (values l start) (scratch l 0) (8*n) (C99MemoryBridge.decode out.heap) := by
  have hp : 0<l.length := by rw [hl.1]; exact pow_pos (by decide) k
  have lv := values_allocated l k 0 (C99MemoryBridge.decode s.heap) hl
    (by simpa only [C99MemoryBridge.encode_decode] using legal) hp
  have ls := scratch_allocated l k 0 (C99MemoryBridge.decode s.heap) hl
    (by simpa only [C99MemoryBridge.encode_decode] using legal) hp
  have owned := legal.valuesWritable 0 hp
  have contract := StableBinaryMemcpySpec.source_copy_is_byte_memcpy l k start n s out hl hbound h
  have shape := StableBinaryMemcpySpec.copy_shape _ _ _ _ _ h
  refine ⟨?_,?_,lv.2.2.2.2,ls.2.2.2.2,owned.2.2,Or.inr contract.1,?_,shape.1,shape.2,?_,?_⟩
  · dsimp [values,ArrayPointer.offset,C99MemoryBridge.decode]
    have hv := lv.2.2.2.1
    dsimp [values,C99MemoryBridge.decode] at hv
    omega
  · dsimp [scratch,ArrayPointer.offset,C99MemoryBridge.decode]
    have hv := ls.2.2.2.1
    dsimp [scratch,C99MemoryBridge.decode] at hv
    omega
  · intro i hi
    obtain ⟨words,hread,_⟩ := Option.bind_eq_some_iff.mp h
    have hn := StableBinaryCopyRefinement.read_copy_length l.scratch n s words hread
    have hj : i/8<n := by omega
    have hw : words[i/8]?=some words[i/8] := by simp [hn,hj]
    have hr := StableBinaryMemcpySpec.read_copy_word_at l.scratch n s words (i/8) words[i/8] hj hread hw
    have hb := StableBinaryMemcpySpec.loaded_word_reencodes_bytes s.heap (StableBinary.addr l.scratch (i/8))
      words[i/8] ⟨i%8,Nat.mod_lt _ (by decide)⟩ hr
    have heq : (ptr (StableBinary.addr l.scratch (i/8))).add (i%8)=⟨0,l.scratch+i⟩ := by
      simp only [ptr,StableBinary.addr,B20.C.Byte.Pointer.add]
      congr 1
      omega
    rw [heq] at hb
    simp [C99MemoryBridge.decode,scratch,ArrayPointer.offset,hb]
  · intro i hi
    have hj : i/8<n := by omega
    have hc := contract.2.1 (i/8) hj ⟨i%8,Nat.mod_lt _ (by decide)⟩
    have hdst : (ptr (StableBinary.addr (StableBinary.addr l.values start) (i/8))).add (i%8)=
        ⟨0,(values l start).offset+i⟩ := by
      simp only [ptr,StableBinary.addr,B20.C.Byte.Pointer.add,values,ArrayPointer.offset]
      congr 1
      omega
    have hsrc : (ptr (StableBinary.addr l.scratch (i/8))).add (i%8)=⟨0,(scratch l 0).offset+i⟩ := by
      simp only [ptr,StableBinary.addr,B20.C.Byte.Pointer.add,scratch,ArrayPointer.offset]
      congr 1
      omega
    rw [hdst,hsrc] at hc
    exact hc
  · intro b i hout
    exact contract.2.2.1 ⟨b,i⟩ hout

theorem copy_complete (l : StableBinary.Layout) (k start n : Nat) (s out : C99HelperReference.State)
    (hl : l.wellFormed k) (legal : Legal l (C99MemoryBridge.encode s.heap)) (hbound : start+n≤l.length)
    (h : C99HelperReference.Copy l start n s out) :
    StableBinaryCExec.copy (C99HelperAtoms.encode s) (StableBinary.addr l.values start) l.scratch n=
      some (C99HelperAtoms.encode out) ∧ Legal l (C99MemoryBridge.encode out.heap) := by
  have fill : ∀ j<n, (wordRead (C99MemoryBridge.encode s.heap) (StableBinary.addr l.scratch j)).isSome := by
    intro j hj
    apply (HelperMemoryTotal.read_some_iff _ _).mpr
    have ow := legal.scratchWritable j (by omega)
    refine ⟨ow.1,ow.2.1,?_⟩
    intro b
    have hb := h.1.2.2.2.2.2.2.1 (8*j+b.val) (by have hi:=b.isLt; omega)
    simpa [C99MemoryBridge.encode,scratch,ArrayPointer.offset,ptr,B20.C.Byte.Pointer.add,StableBinary.addr,Nat.add_assoc] using hb
  obtain ⟨model,hm,lm,_⟩ := HelperCopyTotal.copy_total l k start n (C99HelperAtoms.encode s) hl legal hbound fill
  have href := model_memory l k start n (C99HelperAtoms.encode s) model hl legal hbound hm
  dsimp only [C99HelperAtoms.encode] at href
  rw [C99MemoryBridge.decode_encode] at href
  have heq : out.heap=C99MemoryBridge.decode model.heap := memcpy_deterministic _ _ _ _ _ _ h.1 href
  have ht := copy_trace _ _ _ _ _ hm
  have he : C99HelperAtoms.encode out=model := by
    cases model
    simp_all [C99HelperAtoms.encode,C99MemoryBridge.encode_decode,h.2]
  rw [← he] at hm lm
  exact ⟨hm,lm⟩

end FT1536.Source3.C99HelperCopy

#print axioms FT1536.Source3.C99HelperCopy.copy_complete
