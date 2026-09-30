import Source3.C99InitializationTrace
import Source3.CertificateMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateWorkspace
open C99MemoryReference C99InitializationTrace StableBinaryByteView

def bytes : Nat := (22*1536+4*(1536/3))*8
def slot (base k : Nat) : Nat := base+12288*k
def layout (base bad : Nat) : CertificateMemory.Layout := ⟨slot base 4,slot base 20,bad⟩
def view (base k : Nat) : ArrayPointer := ⟨0,slot base k,1536,8,0⟩

structure Legal (base bad : Nat) (h : Memory) : Prop where
  baseAligned : base%8=0
  badAligned : bad%4=0
  workspaceExtent : base+bytes≤h.size 0
  badExtent : bad+4≤h.size 0
  addressBound : h.size 0<2^64
  writable : h.writable 0=true
  separateBad : StableTopMemory.Separate base bytes bad 4

theorem workspace_size : bytes=286720 := by decide
theorem suffix_wellFormed (base bad : Nat) (h : Memory) (legal : Legal base bad h) :
    CertificateMemory.WellFormed (layout base bad) := by
  have hw := legal.workspaceExtent
  have hb := legal.badExtent
  have hm := legal.addressBound
  have hs := legal.separateBad
  have ha := legal.baseAligned
  dsimp [bytes,StableTopMemory.Separate] at hw hs
  refine ⟨?_,?_,legal.badAligned,?_,?_,?_,?_,?_,?_⟩
  all_goals dsimp [layout,slot,StableTopMemory.Separate]; omega

theorem legal_preserved (base bad : Nat) (before after : Memory)
    (legal : Legal base bad before) (h : Preserves before after) : Legal base bad after := by
  exact ⟨legal.baseAligned,legal.badAligned,by rw [h.size]; exact legal.workspaceExtent,
    by rw [h.size]; exact legal.badExtent,by rw [h.size]; exact legal.addressBound,
    by rw [h.writable]; exact legal.writable,legal.separateBad⟩

theorem initialized_bad_readable (base bad : Nat) (h : Memory) (legal : Legal base bad h)
    (initialized : Initialized h 0 bad 4) : (flagRead (C99MemoryBridge.encode h) bad).isSome := by
  classical
  have hi : ∀ i : Fin 4, ∃ b : Byte, h.bytes 0 (bad+i.val)=some b :=
    fun i => Option.isSome_iff_exists.mp (initialized i.val i.isLt)
  choose b hb using hi
  let p : ArrayPointer := ⟨0,bad,1,4,0⟩
  have ha : Allocated h p :=
    ⟨by decide,legal.badAligned,by decide,by simpa [p] using legal.badExtent,legal.addressBound⟩
  have hr : Load32 h p (le32 b) := Load32.load h p b ha rfl hb
  have hm := C99MemoryAccess.load32_to_model h p (le32 b) rfl hr
  simpa only [p,ArrayPointer.offset,Nat.mul_zero,Nat.add_zero,hm] using congrArg Option.isSome hm

theorem suffix_legal (base bad : Nat) (h : Memory) (legal : Legal base bad h)
    (roots : Initialized h 0 (slot base 4) 12288) (flag : Initialized h 0 bad 4) :
    CertificateMemory.Legal (layout base bad) (C99MemoryBridge.encode h) := by
  have hw := legal.workspaceExtent
  dsimp [bytes] at hw
  refine ⟨?_,?_,?_,initialized_bad_readable base bad h legal flag,?_⟩
  · intro i hi
    refine ⟨?_,legal.addressBound,?_⟩
    · dsimp [layout,slot,StableBinary.addr,ptr,C99MemoryBridge.encode]
      omega
    · intro b
      have hin : 8*i+b.val<12288 := by have := b.isLt; omega
      have hr := roots (8*i+b.val) hin
      simpa [layout,slot,StableBinary.addr,ptr,C99MemoryBridge.encode,B20.C.Byte.Pointer.add,Nat.add_assoc] using hr
  · intro i hi
    refine ⟨?_,legal.addressBound,legal.writable⟩
    dsimp [layout,slot,CertificateMemory.leaves,StableBinary.addr,ptr,C99MemoryBridge.encode]
    omega
  · intro i hi
    refine ⟨?_,legal.addressBound,legal.writable⟩
    dsimp [layout,slot,CertificateMemory.scratch,StableBinary.addr,ptr,C99MemoryBridge.encode]
    omega
  · refine ⟨⟨?_,legal.addressBound⟩,⟨?_,legal.addressBound⟩,legal.writable⟩
    all_goals
      dsimp [layout,ptr,B20.C.Byte.inBounds,B20.C.Byte.Pointer.add,C99MemoryBridge.encode]
      have := legal.badExtent
      omega

/- The actual line7727 copy initializes g00. Later defined primitive stores
   and copies cannot make initialized bytes unreadable. No initial read of
   leaves or scratch is required. Extraction of these transitions from the
   complete source prefix is still required by the enclosing theorem. -/
theorem after_root_copy (base bad : Nat) (before copied after : Memory)
    (legal : Legal base bad before) (flag : Initialized before 0 bad 4)
    (copy : Memcpy before (view base 4) (view base 1) 12288 copied)
    (rest : Steps copied after) :
    CertificateMemory.WellFormed (layout base bad) ∧
    CertificateMemory.Legal (layout base bad) (C99MemoryBridge.encode after) := by
  have hc := memcpy_preserves before copied (view base 4) (view base 1) 12288 copy
  have hr := steps_preserve copied after rest
  have ha := preserves_trans before copied after hc hr
  have roots : Initialized copied 0 (slot base 4) 12288 := memcpy_initializes before copied _ _ _ copy
  refine ⟨suffix_wellFormed base bad before legal,
    suffix_legal base bad after (legal_preserved base bad before after legal ha)
      (region_preserved copied after hr _ _ _ roots) (region_preserved before after ha _ _ _ flag)⟩

end FT1536.Source3.CertificateWorkspace
