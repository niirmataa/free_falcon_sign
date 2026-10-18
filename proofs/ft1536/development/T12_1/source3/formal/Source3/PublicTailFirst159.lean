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
      s1.arrays=s.arrays ∧ s1.heap=s.heap ∧
      s1.locals "u".toList=s.locals "u".toList ∧
      s1.locals "hn".toList=s.locals "hn".toList ∧
      s1.locals "r".toList=s.locals "r".toList := by
  set s1 : State := {s with locals := C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals}
  refine ⟨s1,?_,?_,?_,?_,rfl,rfl,?_,?_,?_⟩
  · exact .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32
      ["a0".toList,"a1".toList,"b".toList] s.locals)
  · show (C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals) "a0".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
  · show (C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals) "a1".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
  · show (C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals) "b".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
  · show (C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals) "u".toList=s.locals "u".toList
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
  · show (C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals) "hn".toList=s.locals "hn".toList
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
  · show (C99DeclarationCells.declareCells .uint32 ["a0".toList,"a1".toList,"b".toList] s.locals) "r".toList=s.locals "r".toList
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

/- Store a[u] = mq_add(a0, b). -/
theorem store_a0_exec (s : State) (a : ArrayPointer) (u : Nat) (hu : u<2^64)
    (w0 bw : BitVec 32)
    (aBinding : s.arrays "a".toList=some a) (uSlot : USlot s "u" u)
    (a0Slot : Slot s "a0" w0) (bSlot : Slot s "b" bw)
    (aWidth : a.elementBytes=2) (aWritable : s.heap.writable a.block=true)
    (aAllocated : Allocated s.heap (element a u))
    (capacity : a.index+u ≤ a.count) :
    ∃ s', Exec KeygenPublicSource.program []
      (.store "a".toList (cvar "u") false (addQ (var "a0") (var "b"))) s ⟨s',.normal⟩ ∧
      Written s'.heap (element a u) ∧ s'.arrays=s.arrays ∧ s'.locals=s.locals ∧
      s'.heap=Word16Memory158.write s.heap (element a u)
        (KeygenPublicWord.narrow (.uint32 (KeygenModpAddSub.result .add
          (PublicArgumentSource157.word (.u32 w0)) (PublicArgumentSource157.word (.u32 bw))
          (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433)))))) := by
  set sumW : BitVec 32 := KeygenModpAddSub.result .add
    (PublicArgumentSource157.word (.u32 w0)) (PublicArgumentSource157.word (.u32 bw))
    (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433)))
  have addCall : KeygenPublicScalar.Call (KeygenPublicScalar.name .add)
      [.uint32 w0,.uint32 bw,C99IntegerReference.convert .int32 18433] (.uint32 sumW) :=
    PublicArgumentSource157.add (.u32 w0) (.u32 bw) (.i32 (BitVec.ofInt 32 18433))
  have addEval : Eval [] s (addQ (var "a0") (var "b")) (.uint32 sumW) :=
    KeygenPublicWord.Eval.call3 _ _ _ _ (.uint32 w0) (.uint32 bw)
      (C99IntegerReference.convert .int32 18433) _
      (eval_var s "a0" w0 a0Slot) (eval_var s "b" bw bSlot) (eval_lit s 18433) addCall
  have addr : Address s "a".toList (cvar "u") (element a u) :=
    address_u s "a" a u hu aBinding uSlot capacity
  set h' := Word16Memory158.write s.heap (element a u) (KeygenPublicWord.narrow (.uint32 sumW))
  refine ⟨{s with heap := h'},?_,?_,rfl,rfl,rfl⟩
  · exact store_a s a u (.uint32 sumW) (addQ (var "a0") (var "b")) (cvar "u")
      aWidth aWritable aAllocated addr addEval
  · exact ⟨_,Word16Memory158.here s.heap (element a u) _ aAllocated aWidth aWritable⟩

/- Store a[u+hn] = mq_sub(mq_add(a0,a1), b). -/
theorem store_a1_exec (s : State) (a : ArrayPointer) (u : Nat) (hu : u<2^64)
    (hsum : u+768<2^64) (w0 w1 bw : BitVec 32)
    (aBinding : s.arrays "a".toList=some a) (uSlot : USlot s "u" u) (hnSlot : USlot s "hn" 768)
    (a0Slot : Slot s "a0" w0) (a1Slot : Slot s "a1" w1) (bSlot : Slot s "b" bw)
    (aWidth : a.elementBytes=2) (aWritable : s.heap.writable a.block=true)
    (aAllocated : Allocated s.heap (element a (768+u)))
    (capacity : a.index+(u+768) ≤ a.count) :
    ∃ s', Exec KeygenPublicSource.program []
      (.store "a".toList (cadd (cvar "u") (cvar "hn")) false
        (subQ (addQ (var "a0") (var "a1")) (var "b"))) s ⟨s',.normal⟩ ∧
      Written s'.heap (element a (768+u)) ∧ s'.arrays=s.arrays ∧ s'.locals=s.locals ∧
      s'.heap=Word16Memory158.write s.heap (element a (768+u))
        (KeygenPublicWord.narrow (.uint32 (KeygenModpAddSub.result .sub
          (PublicArgumentSource157.word (.u32 (KeygenModpAddSub.result .add
            (PublicArgumentSource157.word (.u32 w0)) (PublicArgumentSource157.word (.u32 w1))
            (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433))))))
          (PublicArgumentSource157.word (.u32 bw))
          (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433)))))) := by
  set midW : BitVec 32 := KeygenModpAddSub.result .add
    (PublicArgumentSource157.word (.u32 w0)) (PublicArgumentSource157.word (.u32 w1))
    (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433)))
  have addCall : KeygenPublicScalar.Call (KeygenPublicScalar.name .add)
      [.uint32 w0,.uint32 w1,C99IntegerReference.convert .int32 18433] (.uint32 midW) :=
    PublicArgumentSource157.add (.u32 w0) (.u32 w1) (.i32 (BitVec.ofInt 32 18433))
  have addEval : Eval [] s (addQ (var "a0") (var "a1")) (.uint32 midW) :=
    KeygenPublicWord.Eval.call3 _ _ _ _ (.uint32 w0) (.uint32 w1)
      (C99IntegerReference.convert .int32 18433) _
      (eval_var s "a0" w0 a0Slot) (eval_var s "a1" w1 a1Slot) (eval_lit s 18433) addCall
  set subW : BitVec 32 := KeygenModpAddSub.result .sub
    (PublicArgumentSource157.word (.u32 midW)) (PublicArgumentSource157.word (.u32 bw))
    (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433)))
  have subCall : KeygenPublicScalar.Call (KeygenPublicScalar.name .sub)
      [.uint32 midW,.uint32 bw,C99IntegerReference.convert .int32 18433] (.uint32 subW) :=
    PublicArgumentSource157.sub (.u32 midW) (.u32 bw) (.i32 (BitVec.ofInt 32 18433))
  have subEval : Eval [] s (subQ (addQ (var "a0") (var "a1")) (var "b")) (.uint32 subW) :=
    KeygenPublicWord.Eval.call3 _ _ _ _ (.uint32 midW) (.uint32 bw)
      (C99IntegerReference.convert .int32 18433) _
      addEval (eval_var s "b" bw bSlot) (eval_lit s 18433) subCall
  have addr : Address s "a".toList (cadd (cvar "u") (cvar "hn")) (element a (768+u)) := by
    simpa [Nat.add_comm] using
      address_u_plus_hn s "a" a u 768 hu (by decide) hsum aBinding uSlot hnSlot capacity
  set h' := Word16Memory158.write s.heap (element a (768+u)) (KeygenPublicWord.narrow (.uint32 subW))
  refine ⟨{s with heap := h'},?_,?_,rfl,rfl,rfl⟩
  · exact store_a s a (768+u) (.uint32 subW)
      (subQ (addQ (var "a0") (var "a1")) (var "b")) (cadd (cvar "u") (cvar "hn"))
      aWidth aWritable aAllocated addr subEval
  · exact ⟨_,Word16Memory158.here s.heap (element a (768+u)) _ aAllocated aWidth aWritable⟩

/- Two writes: a[u] and a[u+hn], given the read slots. -/
theorem writes2 (s : State) (a : ArrayPointer) (u : Nat) (hu : u<768) (hsum : u+768<2^64)
    (aBinding : s.arrays "a".toList=some a) (uSlot : USlot s "u" u) (hnSlot : USlot s "hn" 768)
    (w0 w1 bw : BitVec 32)
    (a0Slot : Slot s "a0" w0) (a1Slot : Slot s "a1" w1) (bSlot : Slot s "b" bw)
    (aWidth : a.elementBytes=2) (aWritable : s.heap.writable a.block=true)
    (aAllocated : ∀ i, i<1536 → Allocated s.heap (element a i))
    (capacityU : a.index+u ≤ a.count) (capacityH : a.index+(u+768) ≤ a.count) :
    ∃ s2, Exec KeygenPublicSource.program []
        (KeygenPublicExec.chain [
          .store "a".toList (cvar "u") false (addQ (var "a0") (var "b")),
          .store "a".toList (cadd (cvar "u") (cvar "hn")) false
            (subQ (addQ (var "a0") (var "a1")) (var "b"))]) s ⟨s2,.normal⟩ ∧
      Written s2.heap (element a u) ∧ Written s2.heap (element a (768+u)) := by
  obtain ⟨s5,store1,low1,arrays5,locals5,heap5⟩ := store_a0_exec s a u (by omega) w0 bw
    aBinding uSlot a0Slot bSlot aWidth aWritable (aAllocated u (by omega)) capacityU
  have u5 : USlot s5 "u" u := by
    show s5.locals "u".toList=some (.uint64,some (u64 u)); rw [locals5]; exact uSlot
  have hn5 : USlot s5 "hn" 768 := by
    show s5.locals "hn".toList=some (.uint64,some (u64 768)); rw [locals5]; exact hnSlot
  have a0Slot5 : Slot s5 "a0" w0 := by
    show s5.locals "a0".toList=some (.uint32,some (.uint32 w0)); rw [locals5]; exact a0Slot
  have a1Slot5 : Slot s5 "a1" w1 := by
    show s5.locals "a1".toList=some (.uint32,some (.uint32 w1)); rw [locals5]; exact a1Slot
  have bSlot5 : Slot s5 "b" bw := by
    show s5.locals "b".toList=some (.uint32,some (.uint32 bw)); rw [locals5]; exact bSlot
  have aB5 : s5.arrays "a".toList=some a := by rw [arrays5]; exact aBinding
  have allocH : Allocated s5.heap (element a (768+u)) := by
    rw [heap5]
    exact PublicGenerateTable159.allocated_write s.heap (element a u) (element a (768+u))
      (KeygenPublicWord.narrow (.uint32 (KeygenModpAddSub.result .add
        (PublicArgumentSource157.word (.u32 w0)) (PublicArgumentSource157.word (.u32 bw))
        (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433))))))
      (aAllocated (768+u) (by omega))
  obtain ⟨s6,store2,high1,arrays6,locals6,heap6⟩ := store_a1_exec s5 a u (by omega) hsum w0 w1 bw
    aB5 u5 hn5 a0Slot5 a1Slot5 bSlot5 aWidth
    (by rw [heap5]; exact aWritable) allocH capacityH
  have writes : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain [
        .store "a".toList (cvar "u") false (addQ (var "a0") (var "b")),
        .store "a".toList (cadd (cvar "u") (cvar "hn")) false
          (subQ (addQ (var "a0") (var "a1")) (var "b"))]) s ⟨s6,.normal⟩ :=
    chain_step _ _ s s5 ⟨s6,.normal⟩ store1
      (chain_step _ _ s5 s6 ⟨s6,.normal⟩ store2 (.skip s6))
  refine ⟨s6,writes,?_,high1⟩
  -- low1 is Written s5.heap; transport across the second write
  have sep : Word16Memory158.Separate (element a (768+u)) (element a u) := by
    refine .inr (.inr ?_)
    show (element a u).offset+2 ≤ (element a (768+u)).offset
    show a.base+a.elementBytes*(a.index+u)+2 ≤ a.base+a.elementBytes*(a.index+(768+u))
    rw [aWidth]; omega
  rw [heap6]
  exact PublicGenerateTable159.written_preserved s5.heap (element a (768+u)) (element a u) _ sep low1

/- declare + load a0. -/
theorem reads2a (s : State) (a : ArrayPointer) (u : Nat) (hu : u<768)
    (inv : FirstInv s a gm u) :
    ∃ s2, Exec KeygenPublicSource.program []
        (KeygenPublicExec.chain [
          .scalar (.declare .u32 ["a0".toList,"a1".toList,"b".toList]),
          .assign "a0".toList (load "a" (cvar "u"))]) s ⟨s2,.normal⟩ ∧
      s2.arrays "a".toList=some a ∧ USlot s2 "u" u ∧ USlot s2 "hn" 768 ∧
      (∃ rw, Slot s2 "r" rw) ∧ (∃ w0, Slot s2 "a0" w0) ∧
      s2.locals "a1".toList=some (.uint32,none) ∧
      s2.locals "b".toList=some (.uint32,none) := by
  obtain ⟨rw,rSlot⟩ := inv.rSlot
  obtain ⟨s1,dExec,a0Cell1,a1Cell1,bCell1,arrays1,heap1,eqU1,eqHn1,eqR1⟩ := declare_abc s
  have u1 : USlot s1 "u" u := by
    show s1.locals "u".toList=some (.uint64,some (u64 u)); rw [eqU1]; exact inv.uSlot
  have hn1 : USlot s1 "hn" 768 := by
    show s1.locals "hn".toList=some (.uint64,some (u64 768)); rw [eqHn1]; exact inv.hnSlot
  have r1 : Slot s1 "r" rw := by
    show s1.locals "r".toList=some (.uint32,some (.uint32 rw)); rw [eqR1]; exact rSlot
  have aB1 : s1.arrays "a".toList=some a := by rw [arrays1]; exact inv.aBinding
  have image1 : Written s1.heap (element a u) := by rw [heap1]; exact inv.aImage u (by omega)
  have capU : a.index+u ≤ a.count := by have := inv.aCount; omega
  obtain ⟨w0,a0Exec,a0Slot⟩ := load_a0_exec s1 a u (by omega) aB1 u1 image1 a0Cell1 capU
  set s2 : State := bindValue s1 "a0".toList .uint32 (C99NarrowReads.unsignedPromotion w0)
  have u2 : USlot s2 "u" u := keep_u64 s1 "u" "a0" .uint32 _ u (by decide) u1
  have hn2 : USlot s2 "hn" 768 := keep_u64 s1 "hn" "a0" .uint32 _ 768 (by decide) hn1
  have r2 : Slot s2 "r" rw := keep_slot s1 "r" "a0" .uint32 _ rw (by decide) r1
  have a1Cell2 : s2.locals "a1".toList=some (.uint32,none) := by
    show (bindValue s1 "a0".toList _ _).locals "a1".toList=_
    simp [C99ArrayReference.bindValue,C99ScalarReference.set]; exact a1Cell1
  have bCell2 : s2.locals "b".toList=some (.uint32,none) := by
    show (bindValue s1 "a0".toList _ _).locals "b".toList=_
    simp [C99ArrayReference.bindValue,C99ScalarReference.set]; exact bCell1
  have reads : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain [
        .scalar (.declare .u32 ["a0".toList,"a1".toList,"b".toList]),
        .assign "a0".toList (load "a" (cvar "u"))]) s ⟨s2,.normal⟩ :=
    chain_step _ _ s s1 ⟨s2,.normal⟩ dExec
      (chain_step _ _ s1 s2 ⟨s2,.normal⟩ a0Exec (.skip s2))
  exact ⟨s2,reads,aB1,u2,hn2,⟨rw,r2⟩,⟨_,a0Slot⟩,a1Cell2,bCell2⟩

/- declare + load a0, with individual execs for firstBody_chain. -/
theorem reads2a_steps (s : State) (a : ArrayPointer) (u : Nat) (hu : u<768)
    (inv : FirstInv s a gm u) :
    ∃ s1 s2, Exec KeygenPublicSource.program []
        (.scalar (.declare .u32 ["a0".toList,"a1".toList,"b".toList])) s ⟨s1,.normal⟩ ∧
      Exec KeygenPublicSource.program []
        (.assign "a0".toList (load "a" (cvar "u"))) s1 ⟨s2,.normal⟩ ∧
      s2.arrays "a".toList=some a ∧ USlot s2 "u" u ∧ USlot s2 "hn" 768 ∧
      (∃ rw, Slot s2 "r" rw) ∧ (∃ w0, Slot s2 "a0" w0) ∧
      s2.locals "a1".toList=some (.uint32,none) ∧
      s2.locals "b".toList=some (.uint32,none) ∧
      s2.heap=s.heap := by
  obtain ⟨rw,rSlot⟩ := inv.rSlot
  obtain ⟨s1,dExec,a0Cell1,a1Cell1,bCell1,arrays1,heap1,eqU1,eqHn1,eqR1⟩ := declare_abc s
  have u1 : USlot s1 "u" u := by
    show s1.locals "u".toList=some (.uint64,some (u64 u)); rw [eqU1]; exact inv.uSlot
  have hn1 : USlot s1 "hn" 768 := by
    show s1.locals "hn".toList=some (.uint64,some (u64 768)); rw [eqHn1]; exact inv.hnSlot
  have r1 : Slot s1 "r" rw := by
    show s1.locals "r".toList=some (.uint32,some (.uint32 rw)); rw [eqR1]; exact rSlot
  have aB1 : s1.arrays "a".toList=some a := by rw [arrays1]; exact inv.aBinding
  have image1 : Written s1.heap (element a u) := by rw [heap1]; exact inv.aImage u (by omega)
  have capU : a.index+u ≤ a.count := by have := inv.aCount; omega
  obtain ⟨w0,a0Exec,a0Slot⟩ := load_a0_exec s1 a u (by omega) aB1 u1 image1 a0Cell1 capU
  set s2 : State := bindValue s1 "a0".toList .uint32 (C99NarrowReads.unsignedPromotion w0)
  have u2 : USlot s2 "u" u := keep_u64 s1 "u" "a0" .uint32 _ u (by decide) u1
  have hn2 : USlot s2 "hn" 768 := keep_u64 s1 "hn" "a0" .uint32 _ 768 (by decide) hn1
  have r2 : Slot s2 "r" rw := keep_slot s1 "r" "a0" .uint32 _ rw (by decide) r1
  have a1Cell2 : s2.locals "a1".toList=some (.uint32,none) := by
    show (bindValue s1 "a0".toList _ _).locals "a1".toList=_
    simp [C99ArrayReference.bindValue,C99ScalarReference.set]; exact a1Cell1
  have bCell2 : s2.locals "b".toList=some (.uint32,none) := by
    show (bindValue s1 "a0".toList _ _).locals "b".toList=_
    simp [C99ArrayReference.bindValue,C99ScalarReference.set]; exact bCell1
  exact ⟨s1,s2,dExec,a0Exec,aB1,u2,hn2,⟨rw,r2⟩,⟨_,a0Slot⟩,a1Cell2,bCell2,heap1⟩

/- load a1 + mont b. -/
theorem reads2b (s : State) (a : ArrayPointer) (u : Nat) (hu : u<2^64) (hsum : u+768<2^64)
    (aBinding : s.arrays "a".toList=some a) (uSlot : USlot s "u" u) (hnSlot : USlot s "hn" 768)
    (rw : BitVec 32) (rSlot : Slot s "r" rw) (w0 : BitVec 32) (a0Slot : Slot s "a0" w0)
    (a1Cell : s.locals "a1".toList=some (.uint32,none))
    (bCell : s.locals "b".toList=some (.uint32,none))
    (aImage : Written s.heap (element a (768+u)))
    (capacity : a.index+(u+768) ≤ a.count) :
    ∃ (s2 : State) (w1 : BitVec 16) (bw : BitVec 32), Exec KeygenPublicSource.program []
        (KeygenPublicExec.chain [
          .assign "a1".toList (load "a" (cadd (cvar "u") (cvar "hn"))),
          .assign "b".toList (PublicTailShape159.mont (var "a1") (var "r"))]) s ⟨s2,.normal⟩ ∧
      Slot s2 "a1" (BitVec.ofNat 32 w1.toNat) ∧ Slot s2 "b" bw ∧ Slot s2 "r" rw ∧
      Slot s2 "a0" w0 ∧ USlot s2 "u" u ∧ USlot s2 "hn" 768 ∧
      s2.arrays "a".toList=some a := by
  obtain ⟨w1,a1Exec,a1Slot⟩ := load_a1_exec s a u hu hsum aBinding uSlot hnSlot aImage a1Cell capacity
  set s1 : State := bindValue s "a1".toList .uint32 (C99NarrowReads.unsignedPromotion w1)
  have r1 : Slot s1 "r" rw := keep_slot s "r" "a1" .uint32 _ rw (by decide) rSlot
  have a01 : Slot s1 "a0" w0 := keep_slot s "a0" "a1" .uint32 _ w0 (by decide) a0Slot
  have u1 : USlot s1 "u" u := keep_u64 s "u" "a1" .uint32 _ u (by decide) uSlot
  have hn1 : USlot s1 "hn" 768 := keep_u64 s "hn" "a1" .uint32 _ 768 (by decide) hnSlot
  have bCell1 : s1.locals "b".toList=some (.uint32,none) := by
    show (bindValue s "a1".toList _ _).locals "b".toList=_
    simp [C99ArrayReference.bindValue,C99ScalarReference.set]; exact bCell
  obtain ⟨bw,bExec,bSlot⟩ := mont_b_exec s1 rw w1 a1Slot r1 bCell1
  set s2 : State := bindValue s1 "b".toList .uint32 (.uint32 bw)
  have reads : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain [
        .assign "a1".toList (load "a" (cadd (cvar "u") (cvar "hn"))),
        .assign "b".toList (PublicTailShape159.mont (var "a1") (var "r"))]) s ⟨s2,.normal⟩ :=
    chain_step _ _ s s1 ⟨s2,.normal⟩ a1Exec
      (chain_step _ _ s1 s2 ⟨s2,.normal⟩ bExec (.skip s2))
  have a1Slot2 : Slot s2 "a1" (BitVec.ofNat 32 w1.toNat) :=
    keep_slot s1 "a1" "b" .uint32 _ _ (by decide) a1Slot
  have r2 : Slot s2 "r" rw := keep_slot s1 "r" "b" .uint32 _ rw (by decide) r1
  have a02 : Slot s2 "a0" w0 := keep_slot s1 "a0" "b" .uint32 _ w0 (by decide) a01
  have u2 : USlot s2 "u" u := keep_u64 s1 "u" "b" .uint32 _ u (by decide) u1
  have hn2 : USlot s2 "hn" 768 := keep_u64 s1 "hn" "b" .uint32 _ 768 (by decide) hn1
  exact ⟨s2,w1,bw,reads,a1Slot2,bSlot,r2,a02,u2,hn2,aBinding⟩

/- load a1 + mont b, with individual execs for firstBody_chain. -/
theorem reads2b_steps (s : State) (a : ArrayPointer) (u : Nat) (hu : u<2^64) (hsum : u+768<2^64)
    (aBinding : s.arrays "a".toList=some a) (uSlot : USlot s "u" u) (hnSlot : USlot s "hn" 768)
    (rw : BitVec 32) (rSlot : Slot s "r" rw) (w0 : BitVec 32) (a0Slot : Slot s "a0" w0)
    (a1Cell : s.locals "a1".toList=some (.uint32,none))
    (bCell : s.locals "b".toList=some (.uint32,none))
    (aImage : Written s.heap (element a (768+u)))
    (capacity : a.index+(u+768) ≤ a.count) :
    ∃ (s1 s2 : State) (w1 : BitVec 16) (bw : BitVec 32),
      Exec KeygenPublicSource.program []
        (.assign "a1".toList (load "a" (cadd (cvar "u") (cvar "hn")))) s ⟨s1,.normal⟩ ∧
      Exec KeygenPublicSource.program []
        (.assign "b".toList (PublicTailShape159.mont (var "a1") (var "r"))) s1 ⟨s2,.normal⟩ ∧
      Slot s2 "a1" (BitVec.ofNat 32 w1.toNat) ∧ Slot s2 "b" bw ∧ Slot s2 "r" rw ∧
      Slot s2 "a0" w0 ∧ USlot s2 "u" u ∧ USlot s2 "hn" 768 ∧
      s2.arrays "a".toList=some a ∧ s2.heap=s.heap := by
  obtain ⟨w1,a1Exec,a1Slot⟩ := load_a1_exec s a u hu hsum aBinding uSlot hnSlot aImage a1Cell capacity
  set s1 : State := bindValue s "a1".toList .uint32 (C99NarrowReads.unsignedPromotion w1)
  have r1 : Slot s1 "r" rw := keep_slot s "r" "a1" .uint32 _ rw (by decide) rSlot
  have a01 : Slot s1 "a0" w0 := keep_slot s "a0" "a1" .uint32 _ w0 (by decide) a0Slot
  have u1 : USlot s1 "u" u := keep_u64 s "u" "a1" .uint32 _ u (by decide) uSlot
  have hn1 : USlot s1 "hn" 768 := keep_u64 s "hn" "a1" .uint32 _ 768 (by decide) hnSlot
  have bCell1 : s1.locals "b".toList=some (.uint32,none) := by
    show (bindValue s "a1".toList _ _).locals "b".toList=_
    simp [C99ArrayReference.bindValue,C99ScalarReference.set]; exact bCell
  obtain ⟨bw,bExec,bSlot⟩ := mont_b_exec s1 rw w1 a1Slot r1 bCell1
  set s2 : State := bindValue s1 "b".toList .uint32 (.uint32 bw)
  have a1Slot2 : Slot s2 "a1" (BitVec.ofNat 32 w1.toNat) :=
    keep_slot s1 "a1" "b" .uint32 _ _ (by decide) a1Slot
  have r2 : Slot s2 "r" rw := keep_slot s1 "r" "b" .uint32 _ rw (by decide) r1
  have a02 : Slot s2 "a0" w0 := keep_slot s1 "a0" "b" .uint32 _ w0 (by decide) a01
  have u2 : USlot s2 "u" u := keep_u64 s1 "u" "b" .uint32 _ u (by decide) u1
  have hn2 : USlot s2 "hn" 768 := keep_u64 s1 "hn" "b" .uint32 _ 768 (by decide) hn1
  exact ⟨s1,s2,w1,bw,a1Exec,bExec,a1Slot2,bSlot,r2,a02,u2,hn2,aBinding,rfl⟩

/- Individual store execs for firstBody_chain. -/
theorem writes2_steps (s : State) (a : ArrayPointer) (u : Nat) (hu : u<768) (hsum : u+768<2^64)
    (aBinding : s.arrays "a".toList=some a) (uSlot : USlot s "u" u) (hnSlot : USlot s "hn" 768)
    (w0 w1 bw : BitVec 32)
    (a0Slot : Slot s "a0" w0) (a1Slot : Slot s "a1" w1) (bSlot : Slot s "b" bw)
    (aWidth : a.elementBytes=2) (aWritable : s.heap.writable a.block=true)
    (aAllocated : ∀ i, i<1536 → Allocated s.heap (element a i))
    (capacityU : a.index+u ≤ a.count) (capacityH : a.index+(u+768) ≤ a.count) :
    ∃ s5 s6, Exec KeygenPublicSource.program []
        (.store "a".toList (cvar "u") false (addQ (var "a0") (var "b"))) s ⟨s5,.normal⟩ ∧
      Exec KeygenPublicSource.program []
        (.store "a".toList (cadd (cvar "u") (cvar "hn")) false
          (subQ (addQ (var "a0") (var "a1")) (var "b"))) s5 ⟨s6,.normal⟩ ∧
      Written s6.heap (element a u) ∧ Written s6.heap (element a (768+u)) := by
  obtain ⟨s5,store1,low1,arrays5,locals5,heap5⟩ := store_a0_exec s a u (by omega) w0 bw
    aBinding uSlot a0Slot bSlot aWidth aWritable (aAllocated u (by omega)) capacityU
  have u5 : USlot s5 "u" u := by
    show s5.locals "u".toList=some (.uint64,some (u64 u)); rw [locals5]; exact uSlot
  have hn5 : USlot s5 "hn" 768 := by
    show s5.locals "hn".toList=some (.uint64,some (u64 768)); rw [locals5]; exact hnSlot
  have a0Slot5 : Slot s5 "a0" w0 := by
    show s5.locals "a0".toList=some (.uint32,some (.uint32 w0)); rw [locals5]; exact a0Slot
  have a1Slot5 : Slot s5 "a1" w1 := by
    show s5.locals "a1".toList=some (.uint32,some (.uint32 w1)); rw [locals5]; exact a1Slot
  have bSlot5 : Slot s5 "b" bw := by
    show s5.locals "b".toList=some (.uint32,some (.uint32 bw)); rw [locals5]; exact bSlot
  have aB5 : s5.arrays "a".toList=some a := by rw [arrays5]; exact aBinding
  have allocH : Allocated s5.heap (element a (768+u)) := by
    rw [heap5]
    exact PublicGenerateTable159.allocated_write s.heap (element a u) (element a (768+u))
      (KeygenPublicWord.narrow (.uint32 (KeygenModpAddSub.result .add
        (PublicArgumentSource157.word (.u32 w0)) (PublicArgumentSource157.word (.u32 bw))
        (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433))))))
      (aAllocated (768+u) (by omega))
  obtain ⟨s6,store2,high1,arrays6,locals6,heap6⟩ := store_a1_exec s5 a u (by omega) hsum w0 w1 bw
    aB5 u5 hn5 a0Slot5 a1Slot5 bSlot5 aWidth
    (by rw [heap5]; exact aWritable) allocH capacityH
  have sep : Word16Memory158.Separate (element a (768+u)) (element a u) := by
    refine .inr (.inr ?_)
    show (element a u).offset+2 ≤ (element a (768+u)).offset
    show a.base+a.elementBytes*(a.index+u)+2 ≤ a.base+a.elementBytes*(a.index+(768+u))
    rw [aWidth]; omega
  refine ⟨s5,s6,store1,store2,?_,high1⟩
  rw [heap6]
  exact PublicGenerateTable159.written_preserved s5.heap (element a (768+u)) (element a u) _ sep low1

/- Thin assembly: steps + firstBody_chain. -/
theorem firstBody_exec (s : State) (a gm : ArrayPointer) (u : Nat)
    (hu : u<768) (hsum : u+768<2^64) (inv : FirstInv s a gm u) :
    ∃ after, Exec KeygenPublicSource.program [] PublicTailShape159.firstBody s
        ⟨after,.normal⟩ ∧
      Written after.heap (element a u) ∧ Written after.heap (element a (768+u)) := by
  obtain ⟨s1,s2,dExec,a0Exec,aB2,u2,hn2,⟨rw,r2⟩,⟨w0,a0s⟩,a1c,bc,heap2⟩ :=
    reads2a_steps s a u hu inv
  have image : Written s2.heap (element a (768+u)) := by
    rw [heap2]; exact inv.aImage (768+u) (by omega)
  have capH : a.index+(u+768) ≤ a.count := by have := inv.aCount; omega
  have capU : a.index+u ≤ a.count := by have := inv.aCount; omega
  obtain ⟨s3,s4,w1,bw,a1Exec,bExec,a1s,bs,r4,a0s4,u4,hn4,aB4,heap4b⟩ :=
    reads2b_steps s2 a u (by omega) hsum aB2 u2 hn2 rw r2 w0 a0s a1c bc image capH
  have heap4 : s4.heap=s.heap := heap4b.trans heap2
  have aWidth : a.elementBytes=2 := inv.aWidth
  have aWritable4 : s4.heap.writable a.block=true := by rw [heap4]; exact inv.aWritable
  have aAlloc4 : ∀ i, i<1536 → Allocated s4.heap (element a i) := by
    intro i hi; rw [heap4]; exact inv.aAllocated i hi
  obtain ⟨s5,s6,store1,store2,low,high⟩ := writes2_steps s4 a u hu hsum aB4 u4 hn4
    w0 (BitVec.ofNat 32 w1.toNat) bw a0s4 a1s bs aWidth aWritable4 aAlloc4 capU capH
  refine ⟨C99ArrayReference.restoreScope s s6 ["a0".toList,"a1".toList,"b".toList] [],
    firstBody_chain s s1 s2 s3 s4 s5 s6 dExec a0Exec a1Exec bExec store1 store2,?_,?_⟩
  · exact low
  · exact high

/- FirstInv after the scoped body (locals restored, heap = s6). -/
theorem firstInv_after_body (s s6 : State) (a gm : ArrayPointer) (u : Nat)
    (inv : FirstInv s a gm u)
    (arrays6 : s6.arrays=s.arrays)
    (localsU : s6.locals "u".toList=s.locals "u".toList)
    (localsHn : s6.locals "hn".toList=s.locals "hn".toList)
    (localsN : s6.locals "n".toList=s.locals "n".toList)
    (localsLogn : s6.locals "logn".toList=s.locals "logn".toList)
    (localsR : s6.locals "r".toList=s.locals "r".toList)
    (writable6 : s6.heap.writable=s.heap.writable)
    (alloc6 : ∀ i, i<1536 → Allocated s6.heap (element a i))
    (aImage : ∀ i, i<1536 → Written s6.heap (element a i)) :
    FirstInv (C99ArrayReference.restoreScope s s6 ["a0".toList,"a1".toList,"b".toList] []) a gm u := by
  set s7 : State := C99ArrayReference.restoreScope s s6 ["a0".toList,"a1".toList,"b".toList] []
  have aB : s7.arrays "a".toList=some a := by
    show s6.arrays "a".toList=_
    rw [arrays6]; exact inv.aBinding
  have sq : s7.arrays "gm_square".toList=some gm := by
    show s6.arrays "gm_square".toList=_
    rw [arrays6]; exact inv.squareBinding
  have uSlot : USlot s7 "u" u := by
    show (C99ScalarReference.restore s.locals s6.locals ["a0".toList,"a1".toList,"b".toList]) "u".toList=some (.uint64,some (u64 u))
    exact localsU.trans inv.uSlot
  have hnSlot : USlot s7 "hn" 768 := by
    show (C99ScalarReference.restore s.locals s6.locals ["a0".toList,"a1".toList,"b".toList]) "hn".toList=some (.uint64,some (u64 768))
    exact localsHn.trans inv.hnSlot
  have nSlot : USlot s7 "n" 1536 := by
    show (C99ScalarReference.restore s.locals s6.locals ["a0".toList,"a1".toList,"b".toList]) "n".toList=some (.uint64,some (u64 1536))
    exact localsN.trans inv.nSlot
  have lognSlot : Slot s7 "logn" 10 := by
    show s6.locals "logn".toList=some (.uint32,some (.uint32 10))
    exact localsLogn.trans inv.lognSlot
  have rSlot : ∃ w, Slot s7 "r" w := by
    obtain ⟨w,hw⟩ := inv.rSlot
    exact ⟨w,localsR.trans hw⟩
  refine ⟨aB,sq,nSlot,hnSlot,lognSlot,rSlot,uSlot,aImage,inv.aWidth,?_,?_,inv.aCount⟩
  · show s6.heap.writable a.block=true
    rw [writable6]; exact inv.aWritable
  · intro i hi
    show Allocated s6.heap (element a i)
    exact alloc6 i hi

/- FirstInv after u := u+1 (heap unchanged). -/
theorem firstInv_next (s : State) (a gm : ArrayPointer) (u : Nat) (hu : u+1<2^64)
    (inv : FirstInv s a gm u) :
    FirstInv (bindValue s "u".toList .uint64 (u64 (u+1))) a gm (u+1) := by
  refine ⟨inv.aBinding,inv.squareBinding,inv.nSlot,inv.hnSlot,inv.lognSlot,inv.rSlot,
    u64_slot_after s "u" (u+1) hu,?_,inv.aWidth,inv.aWritable,inv.aAllocated,inv.aCount⟩
  intro i hi
  show Written (bindValue s "u".toList .uint64 (u64 (u+1))).heap (element a i)
  exact inv.aImage i (by omega)

end FT1536.Source3.PublicTailFirst159
