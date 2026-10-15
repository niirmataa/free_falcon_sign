import Source3.FftGroupTwiddle143
import Source3.FftGroupIndex143
import Source3.FftGroupStates143

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupExec143
open C99ArrayReference (State Name)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open FftGroupStates143 (real imag limit initial)

structure Entry (s : State) (m u start ht : Nat) : Prop where
  mCell : Cell s "m".toList m
  uCell : Cell s "u1".toList u
  startCell : Cell s "v1".toList start
  htCell : Cell s "ht".toList ht
  tableIndex : m+u<1024
  sumBound : start+ht<2^64
  tableBinding : s.arrays "fpr_gm3_square".toList=some (FftGlobalMemory.pointer .square)
  pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment s.heap

theorem load (s : State) (target array : Name) (index : CLogic.Expr)
    (pointer : C99MemoryReference.ArrayPointer) (value : BitVec 64)
    (declared : s.locals target=some (.uint64,none))
    (address : C99ArrayReference.Pointer s array index pointer)
    (loaded : C99MemoryReference.Load64 s.heap pointer value) :
    C99ProcedureReference.Exec KeygenSearchFft.program (.base (.assign target (.load array index))) s
      ⟨FftLocalCells140.put s target value,.normal⟩ :=
  .base _ _ _ (FftLocalCells140.assign _ s target (.load array index) none value declared
    (.load array index pointer value address loaded))

theorem real_source (s : State) (m u start ht : Nat) (entry : Entry s m u start ht) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleLoad139.realCode
      (FftGroupDeclare143.after s) ⟨real s (FftGroupTwiddle143.pair (m+u)),.normal⟩ := by
  rw [FftMiddleLoad139.real_shape]
  exact load _ _ _ _ _ _ (FftGroupDeclare143.sr s)
    (FftGroupIndex143.real_pointer _ m u entry.tableIndex
      (FftGroupStates143.declared_cell s _ m (by decide +kernel) entry.mCell)
      (FftGroupStates143.declared_cell s _ u (by decide +kernel) entry.uCell) entry.tableBinding)
    (FftGroupTwiddle143.real_load s.heap entry.pinned (m+u) entry.tableIndex)

theorem imag_source (s : State) (m u start ht : Nat) (entry : Entry s m u start ht) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleLoad139.imagCode
      (real s (FftGroupTwiddle143.pair (m+u))) ⟨imag s (FftGroupTwiddle143.pair (m+u)),.normal⟩ := by
  rw [FftMiddleLoad139.imag_shape]
  exact load _ _ _ _ _ _
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftGroupDeclare143.si s))
    (FftGroupIndex143.imag_pointer _ m u entry.tableIndex
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
        (FftGroupStates143.declared_cell s _ m (by decide +kernel) entry.mCell))
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
        (FftGroupStates143.declared_cell s _ u (by decide +kernel) entry.uCell)) entry.tableBinding)
    (FftGroupTwiddle143.imag_load s.heap entry.pinned (m+u) entry.tableIndex)

theorem limit_shape : FftMiddleLoad139.limitCode=
    .base (.assign "v2".toList (.scalar (.bin .add (.var "v1".toList) (.var "ht".toList)))) := by rfl

theorem initial_shape : FftMiddleShape139.butterflyInitial=
    .base (.scalar (.assign "v".toList (.var "v1".toList))) := by rfl

theorem limit_source (s : State) (x : BitVec 64 × BitVec 64) (start ht : Nat)
    (sumBound : start+ht<2^64) (startCell : Cell s "v1".toList start) (htCell : Cell s "ht".toList ht) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleLoad139.limitCode (imag s x)
      ⟨limit s x start ht,.normal⟩ := by
  rw [limit_shape]
  refine .base _ _ _ (FftLocalCells140.assign _ (imag s x) "v2".toList _ none (word (start+ht)) ?_ ?_)
  · exact (FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftGroupDeclare143.v2 s))
  · exact .scalar _ _ (C99LoopScalar141.add _ _ _ start ht (by omega) (by omega)
      (C99LoopScalar141.read _ _ start (FftGroupStates143.imag_cell s x _ start (by decide +kernel) startCell))
      (C99LoopScalar141.read _ _ ht (FftGroupStates143.imag_cell s x _ ht (by decide +kernel) htCell)))

theorem initial_source (s : State) (x : BitVec 64 × BitVec 64) (start ht : Nat)
    (startCell : Cell s "v1".toList start) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.butterflyInitial
      (limit s x start ht) ⟨initial s x start ht,.normal⟩ := by
  rw [initial_shape]
  unfold initial
  rw [FftLocalCells140.put_bind]
  refine .base _ _ _ (.scalar _ _ _ (.assign (limit s x start ht).locals "v".toList _ .uint64 none (.uint64 (word start)) ?_ ?_))
  · exact (FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
        ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftGroupDeclare143.v s)))
  · exact C99LoopScalar141.read _ _ start ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
      (FftGroupStates143.imag_cell s x _ start (by decide +kernel) startCell))

theorem prologue (s : State) (m u start ht : Nat) (entry : Entry s m u start ht) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftMiddleShape139.groupPrologue s
      ⟨limit s (FftGroupTwiddle143.pair (m+u)) start ht,.normal⟩ := by
  rw [FftMiddleLoad139.prologue_shape]
  apply C99Chain139.append _ _ _ s (FftGroupDeclare143.after s) _ (FftGroupDeclare143.source s)
  exact .seqNormal _ _ _ _ _ (real_source s m u start ht entry)
    (.seqNormal _ _ _ _ _ (imag_source s m u start ht entry)
      (.seqNormal _ _ _ _ _ (limit_source s _ start ht entry.sumBound entry.startCell entry.htCell)
        (.base _ _ _ (.skip _))))

end FT1536.Source3.FftGroupExec143
