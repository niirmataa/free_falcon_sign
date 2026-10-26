import Source3.MkgmRowBody198

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Initialization produced by the four actual row stores, without old reads. -/
namespace FT1536.Source3.MkgmRowInit198
open C99ArrayReference (State)
open C99MemoryReference (Memory ArrayPointer)
open C99InitializationTrace (Preserves)
open Word32Initialized180 (At)
open MkgmParams198 (Level lastIndex)
open KeygenSmallOutput (element)

def four (h : Memory) (p0 p1 p2 p3 : ArrayPointer) (w0 w1 w2 w3 : BitVec 32) : Memory :=
  Word32Memory176.write
    (Word32Memory176.write (Word32Memory176.write (Word32Memory176.write h p0 w0) p1 w1) p2 w2) p3 w3

theorem four_initializes (h : Memory) (p0 p1 p2 p3 : ArrayPointer) (w0 w1 w2 w3 : BitVec 32) :
    At (four h p0 p1 p2 p3 w0 w1 w2 w3) p0 ∧
    At (four h p0 p1 p2 p3 w0 w1 w2 w3) p1 ∧
    At (four h p0 p1 p2 p3 w0 w1 w2 w3) p2 ∧
    At (four h p0 p1 p2 p3 w0 w1 w2 w3) p3 := by
  have p01 := Word32Initialized180.write_preserves (Word32Memory176.write h p0 w0) p1 w1
  have p12 := Word32Initialized180.write_preserves
    (Word32Memory176.write (Word32Memory176.write h p0 w0) p1 w1) p2 w2
  have p23 := Word32Initialized180.write_preserves
    (Word32Memory176.write (Word32Memory176.write (Word32Memory176.write h p0 w0) p1 w1) p2 w2) p3 w3
  exact ⟨Word32Initialized180.transported _ _ p0
      (C99InitializationTrace.preserves_trans _ _ _ p01 (C99InitializationTrace.preserves_trans _ _ _ p12 p23))
      (Word32Initialized180.write_initializes h p0 w0),
    Word32Initialized180.transported _ _ p1 (C99InitializationTrace.preserves_trans _ _ _ p12 p23)
      (Word32Initialized180.write_initializes _ p1 w1),
    Word32Initialized180.transported _ _ p2 p23 (Word32Initialized180.write_initializes _ p2 w2),
    Word32Initialized180.write_initializes _ p3 w3⟩

theorem heap (l : Level) (s : State) (gm igm : ArrayPointer)
    (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (u : Nat) :
    (MkgmRowBody198.after l s gm igm p p0i g2 g4 ig2 ig4 x ix u).heap=
      four s.heap (element gm (lastIndex l u)) (element igm (lastIndex l u))
        (element gm (lastIndex l (u+1))) (element igm (lastIndex l (u+1)))
        x ix (MkgmRowBody198.mul x g4 p p0i) (MkgmRowBody198.mul ix ig4 p p0i) := rfl

theorem pair (l : Level) (s : State) (gm igm : ArrayPointer)
    (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (u : Nat) :
    At (MkgmRowBody198.after l s gm igm p p0i g2 g4 ig2 ig4 x ix u).heap (element gm (lastIndex l u)) ∧
    At (MkgmRowBody198.after l s gm igm p p0i g2 g4 ig2 ig4 x ix u).heap (element igm (lastIndex l u)) ∧
    At (MkgmRowBody198.after l s gm igm p p0i g2 g4 ig2 ig4 x ix u).heap (element gm (lastIndex l (u+1))) ∧
    At (MkgmRowBody198.after l s gm igm p p0i g2 g4 ig2 ig4 x ix u).heap (element igm (lastIndex l (u+1))) := by
  rw [heap]
  exact four_initializes _ _ _ _ _ _ _ _ _

end FT1536.Source3.MkgmRowInit198
