import Source3.NttMiddleTable183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttU1Setup183
open C99ArrayReference (State bindPointer)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot)
open NttFirstFixed182 (Fixed)
open KeygenNttForwardPrograms

def declaredV (s : State) := C99DeclarationStatements.effect .u64 ["v".toList] s
def declaredS (s : State) := C99DeclarationStatements.effect .u32 ["s".toList] (declaredV s)
def withS (s : State) (tw : BitVec 32) := ModularAtoms178.set (declaredS s) "s" tw
def withR1 (s : State) (a : ArrayPointer) (l : Nat) (tw : BitVec 32) := bindPointer (withS s tw) "r1".toList (element a l)
def after (s : State) (a : ArrayPointer) (l h : Nat) (tw : BitVec 32) := bindPointer (withR1 s a l tw) "r2".toList (element a (l+h))
def code := KeygenNttButterflyPrograms.chain [sizeDeclaration ["v"],wordDeclaration ["s"],sAssign,v1Bind,htBind]

theorem source (s : State) (a gm : ArrayPointer) (p p0i w tw : BitVec 32) (m j l h : Nat)
    (fixed : Fixed s a gm p p0i w) (range : l+2*h≤1536) (tableBound : m+j<1024)
    (mc : USlot s "m" m) (jc : USlot s "u1" j) (lc : USlot s "v1" l) (hc : USlot s "ht" h)
    (read : Load32 s.heap (element gm (m+j)) tw) : Exec code s ⟨after s a l h tw,.normal⟩ := by
  have v : Exec (sizeDeclaration ["v"]) s ⟨declaredV s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 ["v".toList] s)
  have d : Exec (wordDeclaration ["s"]) (declaredV s) ⟨declaredS s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 ["s".toList] (declaredV s))
  have set : Exec sAssign (declaredS s) ⟨withS s tw,.normal⟩ :=
    ModularAtoms178.assign _ "s" none _ _ rfl (.load32 _ _ (element gm (m+j)) tw
      (NttMiddleAddress183.table (declaredS s) gm m j tableBound tw fixed.gmBinding mc jc read) read)
  have r1 : Exec v1Bind (withS s tw) ⟨withR1 s a l tw,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ (element a l)
      (by simpa only [Nat.zero_add,KeygenNttForwardPrograms.var] using (NttMiddleAddress183.product (withS s tw) "a" "v1" a 0 l (by omega) fixed.aBinding lc fixed.stride
        (by have := fixed.capacity; omega))))
  have r2 : Exec htBind (withR1 s a l tw) ⟨after s a l h tw,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ (element a (l+h))
      (NttMiddleAddress183.product (withR1 s a l tw) "r1" "ht" a l h (by omega) rfl hc fixed.stride
        (by have := fixed.capacity; omega)))
  exact .seqNormal _ _ s (declaredV s) _ v (.seqNormal _ _ (declaredV s) (declaredS s) _ d
    (.seqNormal _ _ (declaredS s) (withS s tw) _ set (.seqNormal _ _ (withS s tw) (withR1 s a l tw) _ r1
      (.seqNormal _ _ (withR1 s a l tw) (after s a l h tw) _ r2 (.base .skip _ _ (.skip _))))))

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w tw : BitVec 32) (l h : Nat)
    (f : Fixed s a gm p p0i w) : Fixed (after s a l h tw) a gm p p0i w :=
  ⟨f.pCell,f.iCell,f.wCell,f.nCell,f.hnCell,f.stride,f.aBinding,f.gmBinding,f.width,f.capacity,f.allocated,f.writable,f.initialized⟩

theorem limit (s : State) (a : ArrayPointer) (l h : Nat) (tw : BitVec 32) (hc : USlot s "ht" h) :
    USlot (after s a l h tw) "ht" h := hc

theorem twiddle (s : State) (a : ArrayPointer) (l h : Nat) (tw : BitVec 32) :
    KeygenModpR2Exec.Slot (after s a l h tw) "s" tw := ModularAtoms178.slot (declaredS s) "s" tw

end FT1536.Source3.NttU1Setup183
