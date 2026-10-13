import Source3.KeygenDecodeNoneCounter

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-readable honest bytes at the current coefficient cursor.
   Original encoder readback supplies these images; actual int16 writes
   preserve them under physical input/output block separation. -/
namespace FT1536.Source3.KeygenDecodeNoneImages
open KeygenDecodeValues KeygenDecodeExecution C99MemoryReference KeygenDecodeNoneScalar
open KeygenDecodeNoneMemory
open KeygenDecodeNonePairs (wire wire_length)

def ImagesAt (heap : Memory) (src : ArrayPointer) (n : Nat) (inputs : List (BitVec 16)) : Prop :=
  ∀ i : Fin inputs.length, ∃ hiPtr loPtr,
    PointerAdd src (2*(n+i.val)) hiPtr ∧ PointerAdd src (2*(n+i.val)+1) loPtr ∧
    LoadByte heap hiPtr (high inputs[i]) ∧ LoadByte heap loPtr (low inputs[i])

theorem head (heap : Memory) (src : ArrayPointer) (n : Nat) (input : BitVec 16) (rest : List (BitVec 16))
    (images : ImagesAt heap src n (input::rest)) : ∃ hiPtr loPtr,
    PointerAdd src (2*n) hiPtr ∧ PointerAdd src (2*n+1) loPtr ∧
    LoadByte heap hiPtr (high input) ∧ LoadByte heap loPtr (low input) := by
  obtain ⟨hiPtr,loPtr,hiStep,loStep,hiLoad,loLoad⟩ := images ⟨0,by simp⟩
  exact ⟨hiPtr,loPtr,by simpa only [Nat.add_zero] using hiStep,
    by simpa only [Nat.add_zero] using loStep,hiLoad,loLoad⟩

theorem tail (heap : Memory) (src : ArrayPointer) (n : Nat) (input : BitVec 16) (rest : List (BitVec 16))
    (images : ImagesAt heap src n (input::rest)) : ImagesAt heap src (n+1) rest := by
  intro i
  obtain ⟨hiPtr,loPtr,hiStep,loStep,hiLoad,loLoad⟩ := images i.succ
  exact ⟨hiPtr,loPtr,by simpa only [Fin.val_succ,show n+(i.val+1)=n+1+i.val by omega] using hiStep,
    by simpa only [Fin.val_succ,show n+(i.val+1)=n+1+i.val by omega] using loStep,hiLoad,loLoad⟩

theorem preserved (a b : Memory) (src atWord : ArrayPointer) (n : Nat) (input : BitVec 16)
    (inputs : List (BitVec 16)) (images : ImagesAt a src n inputs)
    (store : Store16 a atWord input b) (separate : src.block≠atWord.block) : ImagesAt b src n inputs := by
  intro i
  obtain ⟨hiPtr,loPtr,hiStep,loStep,hiLoad,loLoad⟩ := images i
  have hiBlock : hiPtr.block=src.block := by cases hiStep; rfl
  have loBlock : loPtr.block=src.block := by cases loStep; rfl
  exact ⟨hiPtr,loPtr,hiStep,loStep,
    KeygenDecodeWrite16.byte_preserved a b atWord hiPtr input _ store (by rw [hiBlock]; exact separate) hiLoad,
    KeygenDecodeWrite16.byte_preserved a b atWord loPtr input _ store (by rw [loBlock]; exact separate) loLoad⟩

theorem wire_high (inputs : List (BitVec 16)) (i : Nat) (bound : i < inputs.length) :
    (wire inputs)[2*i]'(by rw [wire_length]; omega)=high inputs[i] := by
  induction inputs generalizing i with
  | nil => simp only [List.length_nil] at bound; omega
  | cons input rest ih =>
    cases i with
    | zero => rfl
    | succ i =>
      have less : i < rest.length := by simp only [List.length_cons] at bound; omega
      simpa only [wire,show 2*(i+1)=2*i+2 by omega,List.getElem_cons_succ] using ih i less

theorem wire_low (inputs : List (BitVec 16)) (i : Nat) (bound : i < inputs.length) :
    (wire inputs)[2*i+1]'(by rw [wire_length]; omega)=low inputs[i] := by
  induction inputs generalizing i with
  | nil => simp only [List.length_nil] at bound; omega
  | cons input rest ih =>
    cases i with
    | zero => rfl
    | succ i =>
      have less : i < rest.length := by simp only [List.length_cons] at bound; omega
      simpa only [wire,show 2*(i+1)+1=(2*i+1)+2 by omega,List.getElem_cons_succ] using ih i less

theorem byte_advance (heap : Memory) (ptr : ArrayPointer) (n : Nat)
    (allocated : Allocated heap (KeygenCodecExecution.byteOff ptr n)) :
    PointerAdd (KeygenCodecExecution.byteOff ptr 0) n (KeygenCodecExecution.byteOff ptr n) := by
  have indices : (KeygenCodecExecution.byteOff ptr 0).index+n=(KeygenCodecExecution.byteOff ptr n).index := by
    simp only [KeygenCodecExecution.byteOff,ArrayPointer.offset]
    omega
  have bound : (KeygenCodecExecution.byteOff ptr 0).index+n≤(KeygenCodecExecution.byteOff ptr 0).count := by
    rw [indices]
    exact Nat.le_of_lt allocated.2.2.1
  have same : {KeygenCodecExecution.byteOff ptr 0 with index := (KeygenCodecExecution.byteOff ptr 0).index+n}=
      KeygenCodecExecution.byteOff ptr n := by
    cases ptr
    simp only [KeygenCodecExecution.byteOff,ArrayPointer.offset] at indices ⊢
    congr 1
  rw [←same]
  exact .within _ n bound

theorem load_allocated (heap : Memory) (ptr : ArrayPointer) (word : BitVec 8)
    (load : LoadByte heap ptr word) : Allocated heap ptr := by cases load; assumption

/-- The actual encoder's final byte readback supplies the decoder's physical
    byte images. No independently assumed encoded-stream agreement is needed. -/
theorem from_wire_reads (heap : Memory) (out : ArrayPointer) (inputs : List (BitVec 16))
    (reads : ∀ i : Fin (wire inputs).length,
      LoadByte heap (KeygenCodecExecution.byteOff out i.val) (wire inputs)[i]) :
    ImagesAt heap (KeygenCodecExecution.byteOff out 0) 0 inputs := by
  intro i
  have hiBound : 2*i.val < (wire inputs).length := by rw [wire_length]; have bound:=i.isLt; omega
  have loBound : 2*i.val+1<(wire inputs).length := by rw [wire_length]; have bound:=i.isLt; omega
  have hiRead := reads ⟨2*i.val,hiBound⟩
  have loRead := reads ⟨2*i.val+1,loBound⟩
  have highWord : (wire inputs)[(⟨2*i.val,hiBound⟩ : Fin (wire inputs).length)]=high inputs[i] := wire_high inputs i.val i.isLt
  have lowWord : (wire inputs)[(⟨2*i.val+1,loBound⟩ : Fin (wire inputs).length)]=low inputs[i] := wire_low inputs i.val i.isLt
  rw [highWord] at hiRead
  rw [lowWord] at loRead
  exact ⟨KeygenCodecExecution.byteOff out (2*i.val),KeygenCodecExecution.byteOff out (2*i.val+1),
    by simpa only [Nat.zero_add] using byte_advance heap out (2*i.val) (load_allocated _ _ _ hiRead),
    by simpa only [Nat.zero_add] using byte_advance heap out (2*i.val+1) (load_allocated _ _ _ loRead),
    hiRead,loRead⟩

end FT1536.Source3.KeygenDecodeNoneImages
