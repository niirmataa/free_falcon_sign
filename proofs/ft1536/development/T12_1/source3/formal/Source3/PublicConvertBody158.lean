import Source3.PublicNat158
import Source3.PublicCalls157
import Source3.Word16Memory158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicConvertBody158
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated)
open C99NarrowReads (Load16)
open KeygenPublicWord (Address Eval)
open KeygenPublicInputProgram (signed index)

def lifted (word : BitVec 16) : BitVec 32 := KeygenModpSet.word (BitVec.ofInt 32 word.toInt) 18433
def converted (word : BitVec 16) : BitVec 16 := KeygenPublicWord.narrow (.uint32 (lifted word))
def afterFirst (s : State) (t : ArrayPointer) (f : BitVec 16) : State := {s with heap := Word16Memory158.write s.heap t (converted f)}
def output (s : State) (t h : ArrayPointer) (f g : BitVec 16) : State :=
  {s with heap := Word16Memory158.write (Word16Memory158.write s.heap t (converted f)) h (converted g)}

theorem expression (s : State) (name : String) (p : ArrayPointer) (word : BitVec 16)
    (isSigned : signed.contains name.toList=true) (address : Address s name.toList index p)
    (read : Load16 s.heap p word) (q : s.locals "q".toList=some (.uint32,some (.uint32 18433))) :
    Eval signed s (KeygenPublicInputProgram.converted name) (.uint32 (lifted word)) := by
  have loaded := Eval.load16 (signed:=signed) (s:=s) name.toList index p word address read
  rw [isSigned] at loaded
  exact .call2 _ _ _ (C99NarrowReads.signedPromotion word) (.uint32 18433) _ loaded
    (.scalar _ _ (.variable _ _ _ q)) (PublicLeafSource157.conv (BitVec.ofInt 32 word.toInt) 18433)

theorem source (s : State) (f g t h : ArrayPointer) (x y : BitVec 16)
    (fAddress : Address s "f".toList index f) (gAddress : Address s "g".toList index g)
    (tAddress : Address s "t".toList index t) (hAddress : Address s "h".toList index h)
    (fRead : Load16 s.heap f x) (gRead : Load16 s.heap g y)
    (tAllocated : Allocated s.heap t) (hAllocated : Allocated s.heap h)
    (tWidth : t.elementBytes=2) (hWidth : h.elementBytes=2)
    (tWritable : s.heap.writable t.block=true) (hWritable : s.heap.writable h.block=true)
    (tg : Word16Memory158.Separate t g) (q : s.locals "q".toList=some (.uint32,some (.uint32 18433))) :
    KeygenPublicExec.Exec KeygenPublicSource.program signed KeygenPublicInputProgram.body s ⟨output s t h x y,.normal⟩ := by
  have first : KeygenPublicExec.Exec KeygenPublicSource.program signed KeygenPublicInputProgram.firstStore s ⟨afterFirst s t x,.normal⟩ :=
    .store _ _ _ _ s _ t (.uint32 (lifted x)) tAddress (expression s "f" f x (by decide) fAddress fRead q)
      (Word16Memory158.source s.heap t (converted x) tAllocated tWidth tWritable)
  have nextG : Load16 (afterFirst s t x).heap g y := Word16Memory158.outside s.heap t g (converted x) y tg gRead
  have second : KeygenPublicExec.Exec KeygenPublicSource.program signed KeygenPublicInputProgram.secondStore (afterFirst s t x)
      ⟨output s t h x y,.normal⟩ :=
    .store _ _ _ _ _ _ h (.uint32 (lifted y)) (PublicNat158.address_heap s _ _ _ h hAddress)
      (expression (afterFirst s t x) "g" g y (by decide) (PublicNat158.address_heap s _ _ _ g gAddress) nextG q)
      (Word16Memory158.source (afterFirst s t x).heap h (converted y) hAllocated hWidth hWritable)
  exact .scope _ _ _ _ _ (.seqNormal _ _ _ _ _ first (.seqNormal _ _ _ _ _ second (.skip _)))

end FT1536.Source3.PublicConvertBody158
