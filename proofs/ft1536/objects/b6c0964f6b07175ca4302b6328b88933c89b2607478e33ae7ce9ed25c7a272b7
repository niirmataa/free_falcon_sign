import Source3.C99MemoryAccess
import Source3.C99HeaderSound

/- By-value uint64_t parameter and distinct local uint64_t object. The two
   automatic objects live in the callee's private storage, not the caller's
   address space; their addresses are never returned. Both use the pinned
   M0 typedef. Memcpy still copies the pre-call eight-byte representation. -/
namespace FT1536.Source3.C99BitcastReference
open C99MemoryReference

def src : ArrayPointer := ⟨0,0,1,8,0⟩
def dst : ArrayPointer := ⟨1,0,1,8,0⟩
def entry (x : BitVec 64) : Memory where
  size b := if b<2 then 8 else 0
  writable b := decide (b<2)
  bytes b i := if b=0 ∧ i<8 then some ((x >>> (8*i)).setWidth 8) else none
def copied (x : BitVec 64) : Memory where
  size := (entry x).size
  writable := (entry x).writable
  bytes b i := if b=1 ∧ i<8 then (entry x).bytes 0 i else (entry x).bytes b i

def Exec (x z : BitVec 64) : Prop :=
  ∃ after, Memcpy (entry x) dst src 8 after ∧ Load64 after dst z

theorem copy_execution (x : BitVec 64) : Memcpy (entry x) dst src 8 (copied x) := by
  refine ⟨by simp [dst,entry,ArrayPointer.offset],by simp [src,entry,ArrayPointer.offset],
    by simp [dst,entry],by simp [src,entry],by simp [dst,entry],Or.inl (by decide),?_,rfl,rfl,?_,?_⟩
  · intro i hi; simp [entry,src,ArrayPointer.offset,hi]
  · intro i hi; simp [copied,dst,src,ArrayPointer.offset,hi]
  · intro b i ho
    simp only [dst,ArrayPointer.offset] at ho
    simp [copied]
    intro hb hi
    omega

theorem copy_loaded (x : BitVec 64) : Load64 (copied x) dst x := by
  have he : le64 (byte64 x)=x := B20.Word.LE.join_byteOf x
  have hl : Load64 (copied x) dst (le64 (byte64 x)) := by
    apply Load64.load (copied x) dst (byte64 x)
    · simp [Allocated,copied,entry,dst]
    · rfl
    · intro i
      simp [copied,entry,dst,ArrayPointer.offset,i.isLt,byte64]
  rw [he] at hl
  exact hl

theorem inhabited (x : BitVec 64) : Exec x x := ⟨copied x,copy_execution x,copy_loaded x⟩

theorem result_exact (x z : BitVec 64) (h : Exec x z) : z=x := by
  obtain ⟨after,hcopy,hload⟩ := h
  have heq := memcpy_deterministic (entry x) dst src 8 after (copied x) hcopy (copy_execution x)
  subst after
  exact load64_deterministic (copied x) dst z x hload (copy_loaded x)

def calls : C99ScalarReference.CallRelation := fun name args z =>
  ∃ x y, args=[.uint64 x] ∧ z=.uint64 y ∧
    (name=KeygenHelpers.bitsName ∨ name=KeygenHelpers.fromBitsName) ∧ Exec x y

theorem calls_complete (name : B20.C.Name) (args : List C99IntegerReference.Value) (z : C99IntegerReference.Value)
    (h : calls name args z) :
    KeygenHelpers.calls name (args.map C99ValueBridge.encode)=some (C99ValueBridge.encode z) := by
  obtain ⟨x,y,rfl,rfl,hn,he⟩ := h
  have hy := result_exact x y he
  subst y
  rcases hn with rfl | rfl
  · exact KeygenHelpers.bits_call x
  · simp [KeygenHelpers.calls,KeygenHelpers.fromBitsName,KeygenHelpers.bitsName,KeygenHelpers.fromBits_execution,C99ValueBridge.encode]

theorem calls_sound : C99ExpressionSound.CallsSound calls KeygenHelpers.calls := by
  intro name args v h
  cases args with
  | nil => simp [KeygenHelpers.calls] at h
  | cons a rest =>
      cases rest with
      | cons _ _ => simp [KeygenHelpers.calls] at h
      | nil =>
          cases a with
          | i64 _ | i32 _ | u32 _ => simp [KeygenHelpers.calls] at h
          | u64 x =>
              by_cases hn : name=KeygenHelpers.bitsName
              · subst name
                rw [KeygenHelpers.bits_call] at h
                have hv : v=.u64 x := (Option.some.inj h).symm
                subst v
                exact ⟨x,x,rfl,rfl,Or.inl rfl,inhabited x⟩
              · by_cases hf : name=KeygenHelpers.fromBitsName
                · subst name
                  have hv : v=.u64 x := by
                    simpa [KeygenHelpers.calls,hn,KeygenHelpers.fromBits_execution] using h.symm
                  subst v
                  exact ⟨x,x,rfl,rfl,Or.inr rfl,inhabited x⟩
                · simp [KeygenHelpers.calls,hn,hf] at h

def signature : C99Typing.Types := fun name =>
  if name=KeygenHelpers.bitsName ∨ name=KeygenHelpers.fromBitsName then some .u64 else none
theorem calls_ok : C99ExpressionBridge.CallsOK signature calls KeygenHelpers.calls := by
  intro name args z t ht hc
  obtain ⟨x,y,hargs,hz,hn,he⟩ := hc
  have htype : t=.u64 := by simpa [signature,hn] using ht.symm
  subst t
  exact ⟨calls_complete name args z ⟨x,y,hargs,hz,hn,he⟩,by rw [hz]; rfl⟩

end FT1536.Source3.C99BitcastReference

#print axioms FT1536.Source3.C99BitcastReference.result_exact
#print axioms FT1536.Source3.C99BitcastReference.inhabited
