import Source3.NttInverseFinalBody192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Execution of one original degree-1 butterfly iteration of the accepted
   modp_iNTT3_ext final pass and of its three-clause increment: the a0/a1
   block declarations, the two r1/r2 loads, the exact modp_add/modp_sub/
   modp_montymul words, the two stores and the u/r1/r2 updates. Values
   are only the executed operations; no root or transform property is
   assumed. -/
namespace FT1536.Source3.NttInverseFinalExec192
open C99ArrayReference (State Name Pointer bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk walk_width walk_step)
open NttInverseFinalBody192 (bb subA mid low high names declared withA0 withA1 withB withC
  firstHeap first secondHeap second output)

def next (s : State) (a : ArrayPointer) (stride hn i : Nat) : State :=
  bindPointer (bindPointer (FftLocalCells140.put s "u".toList (word (i+1)))
    "r1".toList (walk a (i+1) stride)) "r2".toList (walk a (i+1+hn) stride)

theorem a0_fresh (s : State) : (declared s).locals "a0".toList=some (.uint32,none) := rfl
theorem a1_fresh (s : State) (a0 : BitVec 32) :
    (withA0 s a0).locals "a1".toList=some (.uint32,none) := rfl
theorem b_fresh (s : State) (a0 a1 : BitVec 32) :
    (withA1 s a0 a1).locals "b".toList=some (.uint32,none) := rfl
theorem c_fresh (s : State) (a0 a1 p : BitVec 32) :
    (withB s a0 a1 p).locals "c".toList=some (.uint32,none) := rfl

theorem set_keep (s : State) (target : String) (w : BitVec 32) (name : String) (v : BitVec 32)
    (different : name.toList≠target.toList) (base : Slot s name v) :
    Slot (ModularAtoms178.set s target w) name v :=
  (ModularAtoms178.outside s target name w different).trans base

theorem declared_keep (s : State) (name : String) (v : BitVec 32) (base : Slot s name v)
    (absent : name.toList∉names) : Slot (declared s) name v :=
  (NttInverseFinalBody192.declared_outside s name.toList absent).trans base

theorem a0_slot (s : State) (a0 : BitVec 32) : Slot (withA0 s a0) "a0" a0 :=
  ModularAtoms178.slot (declared s) "a0" a0

theorem body_run (s : State) (a : ArrayPointer) (stride hn i : Nat) (p p0i w : BitVec 32)
    (fv0 fv1 : BitVec 32) (pCell : Slot s "p" p) (iCell : Slot s "p0i" p0i)
    (wCell : Slot s "w" w)
    (r1Binding : s.arrays "r1".toList=some (walk a i stride))
    (r2Binding : s.arrays "r2".toList=some (walk a (i+hn) stride))
    (r1Read : Load32 s.heap (walk a i stride) fv0)
    (r2Read : Load32 s.heap (walk a (i+hn) stride) fv1)
    (aWidth : a.elementBytes=4) (aWritable : s.heap.writable a.block=true) :
    Exec NttInversePrograms192.fBody s ⟨output s a stride hn i fv0 fv1 w p p0i,.normal⟩ := by
  have r1Alloc : Allocated s.heap (walk a i stride) :=
    StepProductFixed191.load_allocated r1Read
  have r2Alloc : Allocated s.heap (walk a (i+hn) stride) :=
    StepProductFixed191.load_allocated r2Read
  have r1Cap : (walk a i stride).index≤(walk a i stride).count := Nat.le_of_lt r1Alloc.2.2.1
  have r2Cap : (walk a (i+hn) stride).index≤(walk a (i+hn) stride).count :=
    Nat.le_of_lt r2Alloc.2.2.1
  have declareRun : Exec (NttInversePrograms192.declareU32 ["a0","a1","b","c"]) s
      ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 names s)
  have a0Address : Pointer (declared s) "r1".toList NttInversePrograms192.zero
      (walk a i stride) :=
    StepCopyBody190.zero_pointer (declared s) "r1".toList (walk a i stride) r1Binding r1Cap
  have a0Run : Exec NttInversePrograms192.a0Read (declared s) ⟨withA0 s fv0,.normal⟩ :=
    ModularAtoms178.assign (declared s) "a0" none
      (NttInversePrograms192.read "r1" NttInversePrograms192.zero) fv0 (a0_fresh s)
      (.load32 "r1".toList NttInversePrograms192.zero (walk a i stride) fv0 a0Address r1Read)
  have a1Address : Pointer (withA0 s fv0) "r2".toList NttInversePrograms192.zero
      (walk a (i+hn) stride) :=
    StepCopyBody190.zero_pointer (withA0 s fv0) "r2".toList (walk a (i+hn) stride)
      r2Binding r2Cap
  have a1Run : Exec NttInversePrograms192.a1Read (withA0 s fv0) ⟨withA1 s fv0 fv1,.normal⟩ :=
    ModularAtoms178.assign (withA0 s fv0) "a1" none
      (NttInversePrograms192.read "r2" NttInversePrograms192.zero) fv1 (a1_fresh s fv0)
      (.load32 "r2".toList NttInversePrograms192.zero (walk a (i+hn) stride) fv1
        a1Address r2Read)
  have bEval : C99ModularReference.Eval (withA1 s fv0 fv1)
      (NttInversePrograms192.call3 "modp_add"
        (NttInversePrograms192.scalar (NttInversePrograms192.var "a0"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "a1"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p")))
      (.uint32 (bb fv0 fv1 p)) :=
    ModularWordOps182.add (withA1 s fv0 fv1) _ _ fv0 fv1 p
      (ModularAtoms178.cell (withA1 s fv0 fv1) "a0" fv0
        (set_keep (withA0 s fv0) "a1" fv1 "a0" fv0 (by decide) (a0_slot s fv0)))
      (ModularAtoms178.cell (withA1 s fv0 fv1) "a1" fv1
        (ModularAtoms178.slot (withA0 s fv0) "a1" fv1))
      (set_keep (withA0 s fv0) "a1" fv1 "p" p (by decide)
        (declared_keep s "p" p pCell (by decide)))
  have bRun : Exec NttInversePrograms192.bAssign (withA1 s fv0 fv1)
      ⟨withB s fv0 fv1 p,.normal⟩ :=
    ModularAtoms178.assign (withA1 s fv0 fv1) "b" none
      (NttInversePrograms192.call3 "modp_add"
        (NttInversePrograms192.scalar (NttInversePrograms192.var "a0"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "a1"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p")))
      (bb fv0 fv1 p) (b_fresh s fv0 fv1) bEval
  have wEval : C99ModularReference.Eval (withB s fv0 fv1 p)
      (NttInversePrograms192.scalar (NttInversePrograms192.var "w")) (.uint32 w) :=
    .scalar _ _ (.variable _ _ _
      (set_keep (withA1 s fv0 fv1) "b" (bb fv0 fv1 p) "w" w (by decide)
        (set_keep (withA0 s fv0) "a1" fv1 "w" w (by decide)
          (declared_keep s "w" w wCell (by decide)))))
  have subEval : C99ModularReference.Eval (withB s fv0 fv1 p)
      (NttInversePrograms192.call3 "modp_sub"
        (NttInversePrograms192.scalar (NttInversePrograms192.var "a0"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "a1"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p")))
      (.uint32 (subA fv0 fv1 p)) :=
    ModularWordOps182.sub (withB s fv0 fv1 p) _ _ fv0 fv1 p
      (ModularAtoms178.cell (withB s fv0 fv1 p) "a0" fv0
        (set_keep (withA1 s fv0 fv1) "b" (bb fv0 fv1 p) "a0" fv0 (by decide)
          (set_keep (withA0 s fv0) "a1" fv1 "a0" fv0 (by decide) (a0_slot s fv0))))
      (ModularAtoms178.cell (withB s fv0 fv1 p) "a1" fv1
        (set_keep (withA1 s fv0 fv1) "b" (bb fv0 fv1 p) "a1" fv1 (by decide)
          (ModularAtoms178.slot (withA0 s fv0) "a1" fv1)))
      (set_keep (withA1 s fv0 fv1) "b" (bb fv0 fv1 p) "p" p (by decide)
        (set_keep (withA0 s fv0) "a1" fv1 "p" p (by decide)
          (declared_keep s "p" p pCell (by decide))))
  have cEval : C99ModularReference.Eval (withB s fv0 fv1 p)
      (NttInversePrograms192.call4 "modp_montymul"
        (NttInversePrograms192.scalar (NttInversePrograms192.var "w"))
        (NttInversePrograms192.call3 "modp_sub"
          (NttInversePrograms192.scalar (NttInversePrograms192.var "a0"))
          (NttInversePrograms192.scalar (NttInversePrograms192.var "a1"))
          (NttInversePrograms192.scalar (NttInversePrograms192.var "p")))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p0i")))
      (.uint32 (mid fv0 fv1 w p p0i)) :=
    ModularAtoms178.mont (withB s fv0 fv1 p) _ _
      w (subA fv0 fv1 p) p p0i wEval subEval
      (set_keep (withA1 s fv0 fv1) "b" (bb fv0 fv1 p) "p" p (by decide)
        (set_keep (withA0 s fv0) "a1" fv1 "p" p (by decide)
          (declared_keep s "p" p pCell (by decide))))
      (set_keep (withA1 s fv0 fv1) "b" (bb fv0 fv1 p) "p0i" p0i (by decide)
        (set_keep (withA0 s fv0) "a1" fv1 "p0i" p0i (by decide)
          (declared_keep s "p0i" p0i iCell (by decide))))
  have cRun : Exec NttInversePrograms192.cAssign (withB s fv0 fv1 p)
      ⟨withC s fv0 fv1 w p p0i,.normal⟩ :=
    ModularAtoms178.assign (withB s fv0 fv1 p) "c" none
      (NttInversePrograms192.call4 "modp_montymul"
        (NttInversePrograms192.scalar (NttInversePrograms192.var "w"))
        (NttInversePrograms192.call3 "modp_sub"
          (NttInversePrograms192.scalar (NttInversePrograms192.var "a0"))
          (NttInversePrograms192.scalar (NttInversePrograms192.var "a1"))
          (NttInversePrograms192.scalar (NttInversePrograms192.var "p")))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p0i")))
      (mid fv0 fv1 w p p0i) (c_fresh s fv0 fv1 p) cEval
  have lowEval : C99ModularReference.Eval (withC s fv0 fv1 w p p0i)
      (NttInversePrograms192.call3 "modp_sub"
        (NttInversePrograms192.scalar (NttInversePrograms192.var "b"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "c"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p")))
      (.uint32 (low fv0 fv1 w p p0i)) :=
    ModularWordOps182.sub (withC s fv0 fv1 w p p0i) _ _
      (bb fv0 fv1 p) (mid fv0 fv1 w p p0i) p
      (ModularAtoms178.cell (withC s fv0 fv1 w p p0i) "b" (bb fv0 fv1 p)
        (set_keep (withB s fv0 fv1 p) "c" (mid fv0 fv1 w p p0i) "b" (bb fv0 fv1 p) (by decide)
          (ModularAtoms178.slot (withA1 s fv0 fv1) "b" (bb fv0 fv1 p))))
      (ModularAtoms178.cell (withC s fv0 fv1 w p p0i) "c" (mid fv0 fv1 w p p0i)
        (ModularAtoms178.slot (withB s fv0 fv1 p) "c" (mid fv0 fv1 w p p0i)))
      (set_keep (withB s fv0 fv1 p) "c" (mid fv0 fv1 w p p0i) "p" p (by decide)
        (set_keep (withA1 s fv0 fv1) "b" (bb fv0 fv1 p) "p" p (by decide)
          (set_keep (withA0 s fv0) "a1" fv1 "p" p (by decide)
            (declared_keep s "p" p pCell (by decide)))))
  have lowAddress : Pointer (withC s fv0 fv1 w p p0i) "r1".toList
      NttInversePrograms192.zero (walk a i stride) :=
    StepCopyBody190.zero_pointer (withC s fv0 fv1 w p p0i) "r1".toList (walk a i stride)
      r1Binding r1Cap
  have lowStored : C99MemoryReference.Store32 (withC s fv0 fv1 w p p0i).heap
      (walk a i stride)
      (BitVec.ofInt 32 (C99IntegerReference.Value.integer (.uint32 (low fv0 fv1 w p p0i))))
      (Word32Memory176.write (withC s fv0 fv1 w p p0i).heap (walk a i stride)
        (low fv0 fv1 w p p0i)) := by
    simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
      BitVec.setWidth_eq] using
      Word32Memory176.source (withC s fv0 fv1 w p p0i).heap (walk a i stride)
        (low fv0 fv1 w p p0i) r1Alloc ((walk_width a i stride).trans aWidth) aWritable
  have lowRun : Exec NttInversePrograms192.fWriteLow (withC s fv0 fv1 w p p0i)
      ⟨first s a stride i fv0 fv1 w p p0i,.normal⟩ :=
    .store32 "r1".toList NttInversePrograms192.zero _
      (withC s fv0 fv1 w p p0i)
      (Word32Memory176.write (withC s fv0 fv1 w p p0i).heap (walk a i stride)
        (low fv0 fv1 w p p0i))
      (walk a i stride) (.uint32 (low fv0 fv1 w p p0i)) lowAddress lowEval lowStored
  have highEval : C99ModularReference.Eval (first s a stride i fv0 fv1 w p p0i)
      (NttInversePrograms192.call3 "modp_add"
        (NttInversePrograms192.scalar (NttInversePrograms192.var "c"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "c"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p")))
      (.uint32 (high fv0 fv1 w p p0i)) :=
    ModularWordOps182.add (first s a stride i fv0 fv1 w p p0i) _ _
      (mid fv0 fv1 w p p0i) (mid fv0 fv1 w p p0i) p
      (ModularAtoms178.cell (first s a stride i fv0 fv1 w p p0i) "c" (mid fv0 fv1 w p p0i)
        (by
          show Slot (withC s fv0 fv1 w p p0i) "c" (mid fv0 fv1 w p p0i)
          exact ModularAtoms178.slot (withB s fv0 fv1 p) "c" (mid fv0 fv1 w p p0i)))
      (ModularAtoms178.cell (first s a stride i fv0 fv1 w p p0i) "c" (mid fv0 fv1 w p p0i)
        (by
          show Slot (withC s fv0 fv1 w p p0i) "c" (mid fv0 fv1 w p p0i)
          exact ModularAtoms178.slot (withB s fv0 fv1 p) "c" (mid fv0 fv1 w p p0i)))
      (set_keep (withB s fv0 fv1 p) "c" (mid fv0 fv1 w p p0i) "p" p (by decide)
        (set_keep (withA1 s fv0 fv1) "b" (bb fv0 fv1 p) "p" p (by decide)
          (set_keep (withA0 s fv0) "a1" fv1 "p" p (by decide)
            (declared_keep s "p" p pCell (by decide)))))
  have highAddress : Pointer (first s a stride i fv0 fv1 w p p0i) "r2".toList
      NttInversePrograms192.zero (walk a (i+hn) stride) :=
    StepCopyBody190.zero_pointer (first s a stride i fv0 fv1 w p p0i) "r2".toList
      (walk a (i+hn) stride) r2Binding r2Cap
  have highStored : C99MemoryReference.Store32 (first s a stride i fv0 fv1 w p p0i).heap
      (walk a (i+hn) stride)
      (BitVec.ofInt 32 (C99IntegerReference.Value.integer (.uint32 (high fv0 fv1 w p p0i))))
      (Word32Memory176.write (first s a stride i fv0 fv1 w p p0i).heap
        (walk a (i+hn) stride) (high fv0 fv1 w p p0i)) := by
    simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
      BitVec.setWidth_eq] using
      Word32Memory176.source (first s a stride i fv0 fv1 w p p0i).heap
        (walk a (i+hn) stride) (high fv0 fv1 w p p0i) r2Alloc
        ((walk_width a (i+hn) stride).trans aWidth) aWritable
  have highRun : Exec NttInversePrograms192.fWriteHigh (first s a stride i fv0 fv1 w p p0i)
      ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ :=
    .store32 "r2".toList NttInversePrograms192.zero _
      (first s a stride i fv0 fv1 w p p0i)
      (Word32Memory176.write (first s a stride i fv0 fv1 w p p0i).heap
        (walk a (i+hn) stride) (high fv0 fv1 w p p0i))
      (walk a (i+hn) stride) (.uint32 (high fv0 fv1 w p p0i)) highAddress highEval highStored
  have tail : Exec (.seq NttInversePrograms192.fWriteHigh (.base .skip))
      (first s a stride i fv0 fv1 w p p0i) ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ :=
    .seqNormal _ _ (first s a stride i fv0 fv1 w p p0i)
      (second s a stride hn i fv0 fv1 w p p0i) ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩
      highRun (.base _ _ _ (.skip _))
  have lowBoth : Exec (.seq NttInversePrograms192.fWriteLow
      (.seq NttInversePrograms192.fWriteHigh (.base .skip)))
      (withC s fv0 fv1 w p p0i) ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ :=
    .seqNormal _ _ (withC s fv0 fv1 w p p0i) (first s a stride i fv0 fv1 w p p0i)
      ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ lowRun tail
  have cBoth : Exec (.seq NttInversePrograms192.cAssign
      (.seq NttInversePrograms192.fWriteLow
        (.seq NttInversePrograms192.fWriteHigh (.base .skip))))
      (withB s fv0 fv1 p) ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ :=
    .seqNormal _ _ (withB s fv0 fv1 p) (withC s fv0 fv1 w p p0i)
      ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ cRun lowBoth
  have bBoth : Exec (.seq NttInversePrograms192.bAssign
      (.seq NttInversePrograms192.cAssign
        (.seq NttInversePrograms192.fWriteLow
          (.seq NttInversePrograms192.fWriteHigh (.base .skip)))))
      (withA1 s fv0 fv1) ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ :=
    .seqNormal _ _ (withA1 s fv0 fv1) (withB s fv0 fv1 p)
      ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ bRun cBoth
  have a1Both : Exec (.seq NttInversePrograms192.a1Read
      (.seq NttInversePrograms192.bAssign
        (.seq NttInversePrograms192.cAssign
          (.seq NttInversePrograms192.fWriteLow
            (.seq NttInversePrograms192.fWriteHigh (.base .skip))))))
      (withA0 s fv0) ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ :=
    .seqNormal _ _ (withA0 s fv0) (withA1 s fv0 fv1)
      ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ a1Run bBoth
  have a0Both : Exec (.seq NttInversePrograms192.a0Read
      (.seq NttInversePrograms192.a1Read
        (.seq NttInversePrograms192.bAssign
          (.seq NttInversePrograms192.cAssign
            (.seq NttInversePrograms192.fWriteLow
              (.seq NttInversePrograms192.fWriteHigh (.base .skip)))))))
      (declared s) ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ :=
    .seqNormal _ _ (declared s) (withA0 s fv0)
      ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ a0Run a1Both
  have inner : Exec (.seq (NttInversePrograms192.declareU32 ["a0","a1","b","c"])
      (.seq NttInversePrograms192.a0Read
        (.seq NttInversePrograms192.a1Read
          (.seq NttInversePrograms192.bAssign
            (.seq NttInversePrograms192.cAssign
              (.seq NttInversePrograms192.fWriteLow
                (.seq NttInversePrograms192.fWriteHigh (.base .skip))))))))
      s ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ :=
    .seqNormal _ _ s (declared s) ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩
      declareRun a0Both
  exact .scope names (.seq (NttInversePrograms192.declareU32 ["a0","a1","b","c"])
    (.seq NttInversePrograms192.a0Read
      (.seq NttInversePrograms192.a1Read
        (.seq NttInversePrograms192.bAssign
          (.seq NttInversePrograms192.cAssign
            (.seq NttInversePrograms192.fWriteLow
              (.seq NttInversePrograms192.fWriteHigh (.base .skip))))))))
    s ⟨second s a stride hn i fv0 fv1 w p p0i,.normal⟩ inner

theorem inc_run (s : State) (a : ArrayPointer) (stride hn i : Nat)
    (strideCell : USlot s "stride" stride) (strideBound : stride<2^64)
    (uCell : Cell s "u".toList i) (iBound : i<2^64)
    (r1Binding : s.arrays "r1".toList=some (walk a i stride))
    (r2Binding : s.arrays "r2".toList=some (walk a (i+hn) stride))
    (r1Capacity : (walk a i stride).index+stride≤(walk a i stride).count)
    (r2Capacity : (walk a (i+hn) stride).index+stride≤(walk a (i+hn) stride).count) :
    Exec NttInversePrograms192.uStep s ⟨next s a stride hn i,.normal⟩ := by
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (NttInversePrograms192.num 1)))
      s (FftLocalCells140.put s "u".toList (word (i+1))) := by
    cases C99LoopScalar141.increment (fun _ => none) s "u".toList i iBound uCell with
    | base _ _ _ source => exact source
  set mid : State := FftLocalCells140.put s "u".toList (word (i+1)) with midEq
  have r1After : mid.arrays "r1".toList=some (walk a i stride) := by
    rw [midEq]
    exact r1Binding
  have r2After : mid.arrays "r2".toList=some (walk a (i+hn) stride) := by
    rw [midEq]
    exact r2Binding
  have strideAfter : USlot mid "stride" stride := by
    rw [midEq]
    exact (FftLocalCells140.outside s "u".toList "stride".toList (word (i+1)) (by decide)).trans
      strideCell
  have walked : Pointer mid "r1".toList (NttInversePrograms192.var "stride")
      ({walk a i stride with index := (walk a i stride).index+stride}) := by
    refine .add _ _ (walk a i stride) _ (.uint64 (word stride)) r1After
      (.variable _ _ _ strideAfter) ?_ ?_
    · rw [C99NatWord141.integer stride strideBound]
      omega
    · rw [C99NatWord141.integer stride strideBound]
      exact .within (walk a i stride) stride r1Capacity
  have walkedFinal : Pointer mid "r1".toList (NttInversePrograms192.var "stride")
      (walk a (i+1) stride) := by
    rw [← walk_step a stride i]
    exact walked
  have bind1 : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr "r1".toList "r1".toList (NttInversePrograms192.var "stride")) mid
      (bindPointer mid "r1".toList (walk a (i+1) stride)) :=
    .bindPtr _ _ _ _ _ walkedFinal
  have r2FinalBinding :
      (bindPointer mid "r1".toList (walk a (i+1) stride)).arrays "r2".toList
        =some (walk a (i+hn) stride) := by
    rw [StepProductFixed191.bindPointer_arrays mid "r1".toList (walk a (i+1) stride)
      "r2".toList (by decide)]
    exact r2After
  have strideFinal : USlot (bindPointer mid "r1".toList (walk a (i+1) stride))
      "stride" stride := strideAfter
  have walked2 : Pointer (bindPointer mid "r1".toList (walk a (i+1) stride)) "r2".toList
      (NttInversePrograms192.var "stride")
      ({walk a (i+hn) stride with index := (walk a (i+hn) stride).index+stride}) := by
    refine .add _ _ (walk a (i+hn) stride) _ (.uint64 (word stride)) r2FinalBinding
      (.variable _ _ _ strideFinal) ?_ ?_
    · rw [C99NatWord141.integer stride strideBound]
      omega
    · rw [C99NatWord141.integer stride strideBound]
      exact .within (walk a (i+hn) stride) stride r2Capacity
  have walked2Final : Pointer (bindPointer mid "r1".toList (walk a (i+1) stride)) "r2".toList
      (NttInversePrograms192.var "stride") (walk a (i+1+hn) stride) := by
    have nums : i+hn+1=i+1+hn := by omega
    rw [← nums,← walk_step a stride (i+hn)]
    exact walked2
  have bind2 : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr "r2".toList "r2".toList (NttInversePrograms192.var "stride"))
      (bindPointer mid "r1".toList (walk a (i+1) stride))
      (bindPointer (bindPointer mid "r1".toList (walk a (i+1) stride)) "r2".toList
        (walk a (i+1+hn) stride)) :=
    .bindPtr _ _ _ _ _ walked2Final
  have r1Step : C99ModularReference.Exec
      (.base (.bindPtr "r1".toList "r1".toList (NttInversePrograms192.var "stride")))
      mid ⟨bindPointer mid "r1".toList (walk a (i+1) stride),.normal⟩ := by
    exact .base _ _ _ bind1
  have r2Step : C99ModularReference.Exec
      (.base (.bindPtr "r2".toList "r2".toList (NttInversePrograms192.var "stride")))
      (bindPointer mid "r1".toList (walk a (i+1) stride))
      ⟨next s a stride hn i,.normal⟩ := by
    refine .base _ _ _ ?_
    rw [midEq]
    exact bind2
  have pair : C99ModularReference.Exec NttInversePrograms192.pairStep mid
      ⟨next s a stride hn i,.normal⟩ :=
    .seqNormal _ _ mid (bindPointer mid "r1".toList (walk a (i+1) stride))
      ⟨next s a stride hn i,.normal⟩ r1Step r2Step
  have head : C99ModularReference.Exec
      (.base (.scalar (.update "u".toList .add (NttInversePrograms192.num 1))))
      s ⟨mid,.normal⟩ := by
    rw [midEq]
    exact .base _ _ _ update
  exact .seqNormal _ _ s mid ⟨next s a stride hn i,.normal⟩ head pair

end FT1536.Source3.NttInverseFinalExec192
