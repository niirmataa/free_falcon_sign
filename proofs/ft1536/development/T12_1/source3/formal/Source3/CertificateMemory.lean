import Source3.CertificateSuffixSyntax
import Source3.StableTop001Outcome

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateMemory
open StableBinaryByteView

/- Entry snapshot of suffix7757: g00 and t3 are live by-value pointer
   bindings from the prefix; n=1536, hn=768. The backing t3 region contains
   1536 output fpr cells followed by the 256-cell scratch view. No premise
   about FFT, Gram, roots positivity or previous leaf initialization. -/
structure Layout where
  g00 : Nat
  t3 : Nat
  bad : Nat
  deriving Repr
def leaves (l : Layout) : Nat := l.t3
def scratch (l : Layout) : Nat := l.t3+8*1536
def top (l : Layout) : StableTopMemory.Layout := ⟨l.g00,leaves l,scratch l,l.bad⟩
structure WellFormed (l : Layout) : Prop where
  rootsAligned : l.g00%8=0
  t3Aligned : l.t3%8=0
  badAligned : l.bad%4=0
  rootsBound : l.g00+6144<2^64
  bufferBound : l.t3+14336<2^64
  badBound : l.bad+4<2^64
  rootsBuffer : StableTopMemory.Separate l.g00 6144 l.t3 14336
  rootsBad : StableTopMemory.Separate l.g00 6144 l.bad 4
  bufferBad : StableTopMemory.Separate l.t3 14336 l.bad 4
structure Legal (l : Layout) (h : B20.C.Byte.Memory) : Prop where
  rootsReadable : ∀ i<768, B20.C.Byte.ReadRegion h (ptr (StableBinary.addr l.g00 i))
  leavesWritable : ∀ i<1536, OwnedWriteRegion h (ptr (StableBinary.addr (leaves l) i))
  scratchWritable : ∀ i<256, OwnedWriteRegion h (ptr (StableBinary.addr (scratch l) i))
  badReadable : (flagRead h l.bad).isSome
  badWritable : FlagWritable h l.bad

def t3Ptr (l : Layout) : C99MemoryReference.ArrayPointer := ⟨0,l.t3,1792,8,0⟩
def leafPtr (l : Layout) (i : Nat) : C99MemoryReference.ArrayPointer := ⟨0,l.t3,1536,8,i⟩
def scratchPtr (l : Layout) : C99MemoryReference.ArrayPointer := ⟨0,scratch l,256,8,0⟩
def badPtr (l : Layout) : C99MemoryReference.ArrayPointer := ⟨0,l.bad,1,4,0⟩
def Allowed (l : Layout) (p : B20.C.Byte.Pointer) : Prop := p.block=0 ∧
  ((l.t3≤p.offset ∧ p.offset<l.t3+14336) ∨ (l.bad≤p.offset ∧ p.offset<l.bad+4))

theorem top_wellFormed (l : Layout) (h : WellFormed l) : StableTopMemory.WellFormed (top l) := by
  have hr:=h.rootsBuffer; have hb:=h.bufferBad
  have ha:=h.t3Aligned; have hmax:=h.bufferBound
  dsimp [StableTopMemory.Separate] at hr hb
  refine ⟨h.rootsAligned,h.t3Aligned,?_,h.badAligned,h.rootsBound,?_,?_,h.badBound,?_,?_,h.rootsBad,?_,?_,?_⟩
  all_goals dsimp [top,leaves,scratch,StableTopMemory.Separate]; omega
theorem top_legal (l : Layout) (h : B20.C.Byte.Memory) (legal : Legal l h) : StableTopMemory.Legal (top l) h :=
  ⟨legal.rootsReadable,fun i hi => legal.leavesWritable i (by change i<768 at hi; omega),
    legal.scratchWritable,legal.badReadable,legal.badWritable⟩

theorem alias_and_pointer_add (l : Layout) : leaves l=(t3Ptr l).offset ∧
    ∃ p, C99MemoryReference.PointerAdd (t3Ptr l) 1536 p ∧ p.offset=(scratchPtr l).offset ∧
      p.index+256=p.count := by
  refine ⟨by simp [leaves,t3Ptr,C99MemoryReference.ArrayPointer.offset],
    {t3Ptr l with index := 1536},C99MemoryReference.PointerAdd.within _ _ (by change 0+1536≤1792; decide),?_,rfl⟩
  simp [t3Ptr,scratchPtr,scratch,C99MemoryReference.ArrayPointer.offset]

theorem leaf_allocated (l : Layout) (h : B20.C.Byte.Memory) (hl : WellFormed l) (legal : Legal l h)
    (i : Nat) (hi : i<1536) : C99MemoryReference.Allocated (C99MemoryBridge.decode h) (leafPtr l i) := by
  have hb:=legal.leavesWritable 1535 (by decide)
  refine ⟨by change 0<8; decide,hl.t3Aligned,hi,?_,hb.2.1⟩
  simpa [leafPtr,C99MemoryBridge.decode,ptr,StableBinary.addr,leaves] using hb.1
theorem bad_allocated (l : Layout) (h : B20.C.Byte.Memory) (hl : WellFormed l) (legal : Legal l h) :
    C99MemoryReference.Allocated (C99MemoryBridge.decode h) (badPtr l) :=
  StableTopMemory.bad_allocated (top l) h (top_wellFormed l hl) (top_legal l h legal)

theorem top_allowed_subset (l : Layout) (p : B20.C.Byte.Pointer) (h : StableTopMemory.Allowed (top l) p) : Allowed l p := by
  dsimp [StableTopMemory.Allowed,Allowed,top,leaves,scratch] at *
  omega
theorem root_outside (l : Layout) (hl : WellFormed l) (i : Nat) (hi : i<768) (byte : Fin 8) :
    ¬Allowed l ((ptr (StableBinary.addr l.g00 i)).add byte.val) := by
  have h1:=hl.rootsBuffer; have h2:=hl.rootsBad; have hbyte:=byte.isLt
  dsimp [StableTopMemory.Separate,Allowed,ptr,B20.C.Byte.Pointer.add,StableBinary.addr] at *
  omega

end FT1536.Source3.CertificateMemory

#print axioms FT1536.Source3.CertificateMemory.alias_and_pointer_add
#print axioms FT1536.Source3.CertificateMemory.top_legal
