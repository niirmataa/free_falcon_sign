import Source3.StableTopExpr
import Source3.C99HelperExists

namespace FT1536.Source3.StableTopMemory
open StableBinaryByteView

structure Layout where
  roots : Nat
  leaves : Nat
  scratch : Nat
  bad : Nat
  deriving Repr
def Separate (a an b bn : Nat) : Prop := a+an≤b ∨ b+bn≤a
structure WellFormed (l : Layout) : Prop where
  rootsAligned : l.roots%8=0
  leavesAligned : l.leaves%8=0
  scratchAligned : l.scratch%8=0
  badAligned : l.bad%4=0
  rootsBound : l.roots+6144<2^64
  leavesBound : l.leaves+6144<2^64
  scratchBound : l.scratch+2048<2^64
  badBound : l.bad+4<2^64
  rootsLeaves : Separate l.roots 6144 l.leaves 6144
  rootsScratch : Separate l.roots 6144 l.scratch 2048
  rootsBad : Separate l.roots 6144 l.bad 4
  leavesScratch : Separate l.leaves 6144 l.scratch 2048
  leavesBad : Separate l.leaves 6144 l.bad 4
  scratchBad : Separate l.scratch 2048 l.bad 4

structure Legal (l : Layout) (h : B20.C.Byte.Memory) : Prop where
  rootsReadable : ∀ i<768, B20.C.Byte.ReadRegion h (ptr (StableBinary.addr l.roots i))
  leavesWritable : ∀ i<768, OwnedWriteRegion h (ptr (StableBinary.addr l.leaves i))
  scratchWritable : ∀ i<256, OwnedWriteRegion h (ptr (StableBinary.addr l.scratch i))
  badReadable : (flagRead h l.bad).isSome
  badWritable : FlagWritable h l.bad

def branch (l : Layout) (j : Nat) : StableBinary.Layout := ⟨l.leaves+2048*j,l.scratch,l.bad,256⟩
def rootsPtr (l : Layout) (i : Nat) : C99MemoryReference.ArrayPointer := ⟨0,l.roots,768,8,i⟩
def leavesPtr (l : Layout) (i : Nat) : C99MemoryReference.ArrayPointer := ⟨0,l.leaves,768,8,i⟩
def badPtr (l : Layout) : C99MemoryReference.ArrayPointer := ⟨0,l.bad,1,4,0⟩
def Allowed (l : Layout) (p : B20.C.Byte.Pointer) : Prop := p.block=0 ∧
  ((l.leaves≤p.offset ∧ p.offset<l.leaves+6144) ∨
   (l.scratch≤p.offset ∧ p.offset<l.scratch+2048) ∨
   (l.bad≤p.offset ∧ p.offset<l.bad+4))

theorem branch_wellFormed (l : Layout) (hl : WellFormed l) (j : Nat) (hj : j<3) :
    (branch l j).wellFormed 8 := by
  have hls := hl.leavesScratch
  have hlb := hl.leavesBad
  have hsb := hl.scratchBad
  have halign := hl.leavesAligned
  dsimp [Separate] at hls hlb hsb
  unfold StableBinary.Layout.wellFormed branch
  dsimp only
  refine ⟨by decide,by decide,?_,hl.scratchAligned,hl.badAligned,?_,hl.scratchBound,hl.badBound,?_,?_,?_,?_,?_⟩
  · omega
  · have h := hl.leavesBound; omega
  · omega
  all_goals
    unfold StableBinary.inBytes
    omega

theorem roots_allocated (l : Layout) (h : B20.C.Byte.Memory) (hl : WellFormed l) (legal : Legal l h)
    (i : Nat) (hi : i<768) : C99MemoryReference.Allocated (C99MemoryBridge.decode h) (rootsPtr l i) := by
  have hb := legal.rootsReadable 767 (by decide)
  refine ⟨by change 0<8; decide,hl.rootsAligned,hi,?_,hb.2.1⟩
  simpa [rootsPtr,C99MemoryBridge.decode,ptr,StableBinary.addr] using hb.1
theorem leaves_allocated (l : Layout) (h : B20.C.Byte.Memory) (hl : WellFormed l) (legal : Legal l h)
    (i : Nat) (hi : i<768) : C99MemoryReference.Allocated (C99MemoryBridge.decode h) (leavesPtr l i) := by
  have hb := legal.leavesWritable 767 (by decide)
  refine ⟨by change 0<8; decide,hl.leavesAligned,hi,?_,hb.2.1⟩
  simpa [leavesPtr,C99MemoryBridge.decode,ptr,StableBinary.addr] using hb.1
theorem bad_allocated (l : Layout) (h : B20.C.Byte.Memory) (hl : WellFormed l) (legal : Legal l h) :
    C99MemoryReference.Allocated (C99MemoryBridge.decode h) (badPtr l) := by
  have hb := legal.badWritable.2.1
  dsimp [B20.C.Byte.inBounds,ptr,B20.C.Byte.Pointer.add] at hb
  refine ⟨by change 0<4; decide,hl.badAligned,by change 0<1; decide,?_,hb.2⟩
  dsimp [badPtr,C99MemoryBridge.decode]
  omega

end FT1536.Source3.StableTopMemory

#print axioms FT1536.Source3.StableTopMemory.branch_wellFormed
