import Source3.PublicTailFrame160

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Parametric source steps shared by the remaining public NTT butterflies.
   Existing modular helper proofs supply every arithmetic call. -/
namespace FT1536.Source3.PublicWordSteps161
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer Allocated)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval Address)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableAtoms (Slot)
open PublicGenerateTable159 (Written)
open PublicTailShape159 (cvar cadd load addQ subQ)

def addWord (x y : BitVec 32) : BitVec 32 := KeygenModpAddSub.result .add
  (PublicArgumentSource157.word (.u32 x)) (PublicArgumentSource157.word (.u32 y))
  (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433)))
def subWord (x y : BitVec 32) : BitVec 32 := KeygenModpAddSub.result .sub
  (PublicArgumentSource157.word (.u32 x)) (PublicArgumentSource157.word (.u32 y))
  (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433)))

theorem add_eval (s : State) (left right : KeygenWordExpr.Expr) (x y : BitVec 32)
    (hx : Eval [] s left (.uint32 x)) (hy : Eval [] s right (.uint32 y)) :
    Eval [] s (addQ left right) (.uint32 (addWord x y)) :=
  .call3 _ _ _ _ (.uint32 x) (.uint32 y) (C99IntegerReference.convert .int32 18433) _
    hx hy (PublicGenerateHead159.eval_lit s 18433)
    (PublicArgumentSource157.add (.u32 x) (.u32 y) (.i32 (BitVec.ofInt 32 18433)))

theorem sub_eval (s : State) (left right : KeygenWordExpr.Expr) (x y : BitVec 32)
    (hx : Eval [] s left (.uint32 x)) (hy : Eval [] s right (.uint32 y)) :
    Eval [] s (subQ left right) (.uint32 (subWord x y)) :=
  .call3 _ _ _ _ (.uint32 x) (.uint32 y) (C99IntegerReference.convert .int32 18433) _
    hx hy (PublicGenerateHead159.eval_lit s 18433)
    (PublicArgumentSource157.sub (.u32 x) (.u32 y) (.i32 (BitVec.ofInt 32 18433)))

theorem address_var (s : State) (array index : String) (a : ArrayPointer) (i : Nat)
    (bound : i < 2^64) (binding : s.arrays array.toList=some a)
    (slot : USlot s index i) (capacity : a.index+i ≤ a.count) :
    Address s array.toList (cvar index) (element a i) :=
  .add _ _ a (element a i) (u64 i) binding
    (PublicGenerateIndex159.var_u64 s index i slot)
    (by rw [KeygenNttLoopSupport.u64_integer i bound]; omega)
    (by rw [KeygenNttLoopSupport.u64_toNat i bound]
        exact PublicGenerateIndex159.pointer_within a i capacity)

theorem address_sum (s : State) (array left right : String) (a : ArrayPointer)
    (i j : Nat) (sumBound : i+j < 2^64)
    (binding : s.arrays array.toList=some a)
    (leftSlot : USlot s left i) (rightSlot : USlot s right j)
    (capacity : a.index+(i+j) ≤ a.count) :
    Address s array.toList (cadd (cvar left) (cvar right)) (element a (i+j)) :=
  .add _ _ a (element a (i+j)) (u64 (i+j)) binding
    (.arithmetic .plus _ _ _ _ _
      (PublicGenerateIndex159.var_u64 s left i leftSlot)
      (PublicGenerateIndex159.var_u64 s right j rightSlot)
      (C99NatWord141.add i j (by omega) (by omega)))
    (by rw [KeygenNttLoopSupport.u64_integer (i+j) sumBound]; omega)
    (by rw [KeygenNttLoopSupport.u64_toNat (i+j) sumBound]
        exact PublicGenerateIndex159.pointer_within a (i+j) capacity)

theorem load_assign (s : State) (dst array : String) (index : CLogic.Expr)
    (p : ArrayPointer) (old : Option Value)
    (cell : s.locals dst.toList=some (.uint32,old))
    (address : Address s array.toList index p) (written : Written s.heap p) :
    ∃ w : BitVec 16,
      Exec KeygenPublicSource.program [] (.assign dst.toList (load array index)) s
        ⟨bindValue s dst.toList .uint32 (C99NarrowReads.unsignedPromotion w),.normal⟩ ∧
      Slot (bindValue s dst.toList .uint32 (C99NarrowReads.unsignedPromotion w)) dst
        (BitVec.ofNat 32 w.toNat) := by
  obtain ⟨w,read⟩ := written
  exact ⟨w,.assign _ _ _ .uint32 old _ cell (.load16 _ _ p w address read),
    PublicGenerateUpper159.load_slot s dst w⟩

theorem store (s : State) (array : String) (index : CLogic.Expr) (p : ArrayPointer)
    (expr : KeygenWordExpr.Expr) (v : Value)
    (address : Address s array.toList index p) (value : Eval [] s expr v)
    (allocated : Allocated s.heap p) (width : p.elementBytes=2)
    (writable : s.heap.writable p.block=true) :
    Exec KeygenPublicSource.program [] (.store array.toList index false expr) s
      ⟨{s with heap := Word16Memory158.write s.heap p (KeygenPublicWord.narrow v)},.normal⟩ :=
  .store _ _ _ _ _ _ p v address value
    (Word16Memory158.source s.heap p (KeygenPublicWord.narrow v) allocated width writable)

end FT1536.Source3.PublicWordSteps161
