import Source3.PublicGenerateRemaining159
import Source3.PublicTailShape159

set_option maxRecDepth 524288
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Region 2 first pass (fragment 1001 61): r = gm_square[1] and one
   iteration of the 768-iteration X^2-X+1 loop on a[u], a[u+hn].
   Value-free: constructive executions of the pinned statements only;
   no NTT evaluation, twiddle property or semantic premise enters. -/
namespace FT1536.Source3.PublicTailFirst159
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer Memory PointerAdd Allocated)
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicWord (Eval Address)
open KeygenPublicTableAtoms (Slot var literal mont)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open PublicTailShape159
open PublicGenerateTable159 (Written WrittenRange)
open PublicGenerateIndex159 (lit_i32 var_u64 pointer_within)
open PublicGenerateHead159 (eval_lit eval_var)
open PublicGenerateRow159 (rowValue mont_var keep_slot keep_u64 u32_slot_after u64_slot_after
  restoreScope_empty scope_empty chain_step)
open PublicGenerateUpper159 (load_slot)

theorem lit_integer (i : Nat) (hi : i<2^31) :
    (C99IntegerReference.convert .int32 i).integer=(i:Int) := by
  show (BitVec.ofInt 32 (i:Int)).toInt=(i:Int)
  exact BitVec.toInt_ofInt_eq_self (by decide) (by omega) (by omega)

theorem address_lit (s : State) (name : String) (p : ArrayPointer) (i : Nat)
    (hi : i<2^31) (binding : s.arrays name.toList=some p)
    (capacity : p.index+i ≤ p.count) :
    Address s name.toList (clit i) (element p i) :=
  .add name.toList (clit i) p (element p i)
    (C99IntegerReference.convert .int32 i) binding (lit_i32 s i)
    (by rw [lit_integer i hi]; omega)
    (by rw [lit_integer i hi]; exact pointer_within p i capacity)

theorem address_u (s : State) (name : String) (p : ArrayPointer) (i : Nat)
    (hi : i<2^64) (binding : s.arrays name.toList=some p) (slot : USlot s "u" i)
    (capacity : p.index+i ≤ p.count) :
    Address s name.toList (cvar "u") (element p i) :=
  PublicGenerateIndex159.address_u64 s name p i hi binding slot capacity

/- u + hn as an unsigned64 scalar, then as an address. -/
theorem u64_add_exec (u hn : Nat) (hu : u<2^64) (hhn : hn<2^64) (_hsum : u+hn<2^64) :
    C99IntegerReference.ArithmeticExec .plus (u64 u) (u64 hn) (u64 (u+hn)) := by
  have raw := C99IntegerReference.ArithmeticExec.step .plus (u64 u) (u64 hn) .uint64 rfl
    (u64 u) (u64 hn)
    (KeygenNttLoopSupport.convert_u64_self u hu).symm
    (KeygenNttLoopSupport.convert_u64_self hn hhn).symm
    (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .plus (u64 u) (u64 hn)
    (.uint64 (BitVec.ofInt 64 ((u64 u).integer+(u64 hn).integer))) at raw
  rw [KeygenNttLoopSupport.u64_integer u hu,KeygenNttLoopSupport.u64_integer hn hhn] at raw
  have sum : (u: Int)+(hn: Int)=((u+hn: Nat): Int) := by omega
  rw [sum,BitVec.ofInt_natCast] at raw
  exact raw

theorem scalar_u_plus_hn (s : State) (u hn : Nat) (hu : u<2^64) (hhn : hn<2^64)
    (hsum : u+hn<2^64) (uSlot : USlot s "u" u) (hnSlot : USlot s "hn" hn) :
    KeygenPublicWord.scalar s (cadd (cvar "u") (cvar "hn")) (u64 (u+hn)) :=
  C99ScalarReference.Eval.arithmetic .plus _ _ _ _ _
    (var_u64 s "u" u uSlot) (var_u64 s "hn" hn hnSlot) (u64_add_exec u hn hu hhn hsum)

theorem address_u_plus_hn (s : State) (name : String) (p : ArrayPointer)
    (u hn : Nat) (hu : u<2^64) (hhn : hn<2^64) (hsum : u+hn<2^64)
    (binding : s.arrays name.toList=some p)
    (uSlot : USlot s "u" u) (hnSlot : USlot s "hn" hn)
    (capacity : p.index+(u+hn) ≤ p.count) :
    Address s name.toList (cadd (cvar "u") (cvar "hn")) (element p (u+hn)) :=
  .add name.toList (cadd (cvar "u") (cvar "hn")) p (element p (u+hn))
    (u64 (u+hn)) binding (scalar_u_plus_hn s u hn hu hhn hsum uSlot hnSlot)
    (by rw [KeygenNttLoopSupport.u64_integer (u+hn) hsum]; omega)
    (by rw [KeygenNttLoopSupport.u64_toNat (u+hn) hsum]
        exact pointer_within p (u+hn) capacity)

/- Legal 16-bit store to an a-cell. -/
theorem store_a (s : State) (a : ArrayPointer) (i : Nat) (v : Value)
    (val : KeygenWordExpr.Expr) (index : CLogic.Expr)
    (aWidth : a.elementBytes=2) (aWritable : s.heap.writable a.block=true)
    (aAllocated : Allocated s.heap (element a i))
    (address : Address s "a".toList index (element a i))
    (value : Eval [] s val v) :
    Exec KeygenPublicSource.program [] (.store "a".toList index false val) s
      ⟨{s with heap := Word16Memory158.write s.heap (element a i) (KeygenPublicWord.narrow v)},.normal⟩ :=
  .store "a".toList index false val s
    (Word16Memory158.write s.heap (element a i) (KeygenPublicWord.narrow v))
    (element a i) v address value
    (Word16Memory158.source s.heap (element a i) (KeygenPublicWord.narrow v)
      aAllocated aWidth aWritable)

/- Entry of the tail: a[0..1536) image, gm_square[1] readable, dims bound. -/
structure TailEntry (s : State) (a gm : ArrayPointer) : Prop where
  aBinding : s.arrays "a".toList=some a
  squareBinding : s.arrays "gm_square".toList=some gm
  nSlot : USlot s "n" 1536
  hnSlot : USlot s "hn" 768
  lognSlot : Slot s "logn" 10
  aImage : ∀ i, i<1536 → Written s.heap (element a i)
  gmImage : Written s.heap (element gm 1)
  rCell : ∃ old, s.locals "r".toList=some (.uint32,old)
  wCell : ∃ old, s.locals "w".toList=some (.uint32,old)
  uCell : ∃ old, s.locals "u".toList=some (.uint64,old)
  aWidth : a.elementBytes=2
  aWritable : s.heap.writable a.block=true
  aAllocated : ∀ i, i<1536 → Allocated s.heap (element a i)
  aCount : a.index+1536 ≤ a.count
  gmWidth : gm.elementBytes=2
  gmWritable : s.heap.writable gm.block=true
  gmAllocated : Allocated s.heap (element gm 1)
  gmCount : gm.index+1 ≤ gm.count

/- r = gm_square[1]. -/
theorem rSet_exec (s : State) (a gm : ArrayPointer) (e : TailEntry s a gm) :
    ∃ w, C99NarrowReads.Load16 s.heap (element gm 1) w ∧
      Exec KeygenPublicSource.program [] PublicTailShape159.rSet s
        ⟨bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w),.normal⟩ ∧
      Slot (bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w)) "r"
        (BitVec.ofNat 32 w.toNat) := by
  obtain ⟨w,read⟩ := e.gmImage
  obtain ⟨oldR,rEq⟩ := e.rCell
  have address : Address s "gm_square".toList (clit 1) (element gm 1) :=
    address_lit s "gm_square" gm 1 (by decide) e.squareBinding e.gmCount
  have loadEval : Eval [] s (load "gm_square" (clit 1))
      (C99NarrowReads.unsignedPromotion w) :=
    .load16 "gm_square".toList (clit 1) (element gm 1) w address read
  have exec : Exec KeygenPublicSource.program [] PublicTailShape159.rSet s
      ⟨bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w),.normal⟩ :=
    .assign "r".toList _ s .uint32 oldR
      (C99NarrowReads.unsignedPromotion w) rEq loadEval
  have slot : Slot (bindValue s "r".toList .uint32 (C99NarrowReads.unsignedPromotion w)) "r"
      (BitVec.ofNat 32 w.toNat) :=
    load_slot s "r" w
  exact ⟨w,read,exec,slot⟩

/- First-pass invariant after u iterations: all 1536 a-cells stay Written
   (the image is only overwritten, never erased); counters and dims fixed. -/
structure FirstInv (s : State) (a gm : ArrayPointer) (u : Nat) : Prop where
  aBinding : s.arrays "a".toList=some a
  squareBinding : s.arrays "gm_square".toList=some gm
  nSlot : USlot s "n" 1536
  hnSlot : USlot s "hn" 768
  lognSlot : Slot s "logn" 10
  rSlot : ∃ w, Slot s "r" w
  uSlot : USlot s "u" u
  aImage : ∀ i, i<1536 → Written s.heap (element a i)
  aWidth : a.elementBytes=2
  aWritable : s.heap.writable a.block=true
  aAllocated : ∀ i, i<1536 → Allocated s.heap (element a i)
  aCount : a.index+1536 ≤ a.count

/- Assemble the six first-body statements into the scoped chain. -/
theorem firstBody_chain (s s1 s2 s3 s4 s5 s6 : State)
    (dExec : Exec KeygenPublicSource.program []
      (.scalar (.declare .u32 ["a0".toList,"a1".toList,"b".toList])) s ⟨s1,.normal⟩)
    (a0Exec : Exec KeygenPublicSource.program []
      (.assign "a0".toList (load "a" (cvar "u"))) s1 ⟨s2,.normal⟩)
    (a1Exec : Exec KeygenPublicSource.program []
      (.assign "a1".toList (load "a" (cadd (cvar "u") (cvar "hn")))) s2 ⟨s3,.normal⟩)
    (bExec : Exec KeygenPublicSource.program []
      (.assign "b".toList (PublicTailShape159.mont (var "a1") (var "r"))) s3 ⟨s4,.normal⟩)
    (store1 : Exec KeygenPublicSource.program []
      (.store "a".toList (cvar "u") false (addQ (var "a0") (var "b"))) s4 ⟨s5,.normal⟩)
    (store2 : Exec KeygenPublicSource.program []
      (.store "a".toList (cadd (cvar "u") (cvar "hn")) false
        (subQ (addQ (var "a0") (var "a1")) (var "b"))) s5 ⟨s6,.normal⟩) :
    Exec KeygenPublicSource.program [] PublicTailShape159.firstBody s
      ⟨C99ArrayReference.restoreScope s s6 ["a0".toList,"a1".toList,"b".toList] [],.normal⟩ := by
  have chainExec : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain [
        .scalar (.declare .u32 ["a0".toList,"a1".toList,"b".toList]),
        .assign "a0".toList (load "a" (cvar "u")),
        .assign "a1".toList (load "a" (cadd (cvar "u") (cvar "hn"))),
        .assign "b".toList (PublicTailShape159.mont (var "a1") (var "r")),
        .store "a".toList (cvar "u") false (addQ (var "a0") (var "b")),
        .store "a".toList (cadd (cvar "u") (cvar "hn")) false
          (subQ (addQ (var "a0") (var "a1")) (var "b"))]) s ⟨s6,.normal⟩ :=
    chain_step _ _ s s1 ⟨s6,.normal⟩ dExec
      (chain_step _ _ s1 s2 ⟨s6,.normal⟩ a0Exec
        (chain_step _ _ s2 s3 ⟨s6,.normal⟩ a1Exec
          (chain_step _ _ s3 s4 ⟨s6,.normal⟩ bExec
            (chain_step _ _ s4 s5 ⟨s6,.normal⟩ store1
              (chain_step _ _ s5 s6 ⟨s6,.normal⟩ store2 (.skip s6))))))
  exact KeygenPublicExec.Exec.scope ["a0".toList,"a1".toList,"b".toList] []
    (KeygenPublicExec.chain _) s ⟨s6,.normal⟩ chainExec

/- Individual first-body steps (small proof terms; compose via firstBody_chain). -/

theorem declare_abc (s : State) :
    ∃ s1, Exec KeygenPublicSource.program []
      (.scalar (.declare .u32 ["a0".toList,"a1".toList,"b".toList])) s ⟨s1,.normal⟩ ∧
      s1.locals "a0".toList=some (.uint32,none) ∧
      s1.locals "a1".toList=some (.uint32,none) ∧
      s1.locals "b".toList=some (.uint32,none) ∧
      s1.arrays=s.arrays := by
  set s1 : State := {s with locals := C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals}
  refine ⟨s1,?_,?_,?_,?_,rfl⟩
  · exact .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32
      ["a0".toList,"a1".toList,"b".toList] s.locals)
  · show (C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals) "a0".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
  · show (C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals) "a1".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
  · show (C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals) "b".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]

theorem load_a0_exec (s : State) (a : ArrayPointer) (u : Nat) (hu : u<2^64)
    (aBinding : s.arrays "a".toList=some a) (uSlot : USlot s "u" u)
    (aImage : Written s.heap (element a u)) (a0Cell : s.locals "a0".toList=some (.uint32,none))
    (capacity : a.index+u ≤ a.count) :
    ∃ w, Exec KeygenPublicSource.program []
      (.assign "a0".toList (load "a" (cvar "u"))) s
      ⟨bindValue s "a0".toList .uint32 (C99NarrowReads.unsignedPromotion w),.normal⟩ ∧
      Slot (bindValue s "a0".toList .uint32 (C99NarrowReads.unsignedPromotion w)) "a0"
        (BitVec.ofNat 32 w.toNat) := by
  obtain ⟨w,read⟩ := aImage
  refine ⟨w,?_,load_slot s "a0" w⟩
  exact .assign "a0".toList _ _ .uint32 none (C99NarrowReads.unsignedPromotion w) a0Cell
    (.load16 "a".toList (cvar "u") (element a u) w
      (address_u s "a" a u hu aBinding uSlot capacity) read)

theorem load_a1_exec (s : State) (a : ArrayPointer) (u : Nat) (hu : u<2^64) (hsum : u+768<2^64)
    (aBinding : s.arrays "a".toList=some a) (uSlot : USlot s "u" u) (hnSlot : USlot s "hn" 768)
    (aImage : Written s.heap (element a (768+u))) (a1Cell : s.locals "a1".toList=some (.uint32,none))
    (capacity : a.index+(u+768) ≤ a.count) :
    ∃ w, Exec KeygenPublicSource.program []
      (.assign "a1".toList (load "a" (cadd (cvar "u") (cvar "hn")))) s
      ⟨bindValue s "a1".toList .uint32 (C99NarrowReads.unsignedPromotion w),.normal⟩ ∧
      Slot (bindValue s "a1".toList .uint32 (C99NarrowReads.unsignedPromotion w)) "a1"
        (BitVec.ofNat 32 w.toNat) := by
  obtain ⟨w,read⟩ := aImage
  refine ⟨w,?_,load_slot s "a1" w⟩
  have addr : Address s "a".toList (cadd (cvar "u") (cvar "hn")) (element a (768+u)) := by
    simpa [Nat.add_comm] using
      address_u_plus_hn s "a" a u 768 hu (by decide) hsum aBinding uSlot hnSlot capacity
  exact .assign "a1".toList _ _ .uint32 none (C99NarrowReads.unsignedPromotion w) a1Cell
    (.load16 "a".toList (cadd (cvar "u") (cvar "hn")) (element a (768+u)) w addr read)

theorem mont_b_exec (s : State) (rw : BitVec 32) (w1 : BitVec 16)
    (a1Slot : Slot s "a1" (BitVec.ofNat 32 w1.toNat)) (rSlot : Slot s "r" rw)
    (bCell : s.locals "b".toList=some (.uint32,none)) :
    ∃ bw, Exec KeygenPublicSource.program []
      (.assign "b".toList (PublicTailShape159.mont (var "a1") (var "r"))) s
      ⟨bindValue s "b".toList .uint32 (.uint32 bw),.normal⟩ ∧
      Slot (bindValue s "b".toList .uint32 (.uint32 bw)) "b" bw := by
  set bw : BitVec 32 := rowValue (BitVec.ofNat 32 w1.toNat) rw
  refine ⟨bw,?_,?_⟩
  · exact .assign "b".toList _ _ .uint32 none (.uint32 bw) bCell
      (mont_var s "a1" "r" (BitVec.ofNat 32 w1.toNat) rw a1Slot rSlot)
  · exact u32_slot_after s "b" bw

end FT1536.Source3.PublicTailFirst159
