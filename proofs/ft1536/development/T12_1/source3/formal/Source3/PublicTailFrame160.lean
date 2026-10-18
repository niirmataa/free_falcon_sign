import Source3.PublicTailFirst159
import Source3.KeygenPublicFirstValues

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Extract the two actual stores without a polynomial or twiddle premise.
   Their byte frames preserve every initialized input cell of the next
   butterfly. The constructive body itself is reused from job108. -/
namespace FT1536.Source3.PublicTailFrame160
open C99ArrayReference (State)
open C99MemoryReference (Memory ArrayPointer Allocated)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec)
open KeygenSmallOutput (Store16 element)
open PublicGenerateTable159 (Written)
open PublicTailFirst159 (FirstInv)
open KeygenPublicFirstValues (Fixed body declaration readLow readHigh multiply storeLow storeHigh
  fixed_after low_value high_value)

theorem body_eq : PublicTailShape159.firstBody = body := rfl

theorem store_trace (s : State) (out : Result) (a : ArrayPointer)
    (index : CLogic.Expr) (i : Nat) (value : KeygenWordExpr.Expr)
    (binding : s.arrays "a".toList = some a)
    (atIndex : ∀ v, KeygenPublicWord.scalar s index v → v.integer.toNat = i)
    (run : Exec KeygenPublicSource.program [] (.store "a".toList index false value) s out) :
    ∃ w, Store16 s.heap (element a i) w out.state.heap := by
  cases run with
  | store _ _ _ _ before heap actual v address evaluated write =>
      rw [KeygenPublicTableIndex.address s "a" index a actual i binding atIndex address] at write
      exact ⟨_,write⟩

theorem body_trace (s : State) (out : Result) (a : ArrayPointer) (u : Nat)
    (hu : u < 768) (fixed : Fixed s a u)
    (run : Exec KeygenPublicSource.program [] body s out) :
    ∃ (middle : Memory) (low high : BitVec 16),
      Store16 s.heap (element a u) low middle ∧
      Store16 middle (element a (u+768)) high out.state.heap := by
  cases run with
  | scope _ _ _ _ result executed =>
      obtain ⟨s1,decl,rest1⟩ := KeygenPublicTableControl.seq_inv _ _ s result (by decide) executed
      obtain ⟨s2,read0,rest2⟩ := KeygenPublicTableControl.seq_inv _ _ s1 result (by decide) rest1
      obtain ⟨s3,read1,rest3⟩ := KeygenPublicTableControl.seq_inv _ _ s2 result (by decide) rest2
      obtain ⟨s4,mult,rest4⟩ := KeygenPublicTableControl.seq_inv _ _ s3 result (by decide) rest3
      obtain ⟨s5,low,rest5⟩ := KeygenPublicTableControl.seq_inv _ _ s4 result (by decide) rest4
      obtain ⟨s6,high,last⟩ := KeygenPublicTableControl.seq_inv _ _ s5 result (by decide) rest5
      cases last
      have declared := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s
        .u32 KeygenPublicFirstValues.names ⟨s1,.normal⟩ decl)
      dsimp only at declared
      have f1 := fixed_after declaration s ⟨s1,.normal⟩ a u fixed (by decide) (by decide) decl
      have f2 := fixed_after readLow s1 ⟨s2,.normal⟩ a u f1 (by decide) (by decide) read0
      have f3 := fixed_after readHigh s2 ⟨s3,.normal⟩ a u f2 (by decide) (by decide) read1
      have f4 := fixed_after multiply s3 ⟨s4,.normal⟩ a u f3 (by decide) (by decide) mult
      have f5 := fixed_after storeLow s4 ⟨s5,.normal⟩ a u f4 (by decide) (by decide) low
      have heap1 : s1.heap = s.heap := by rw [declared]
      have heap2 := (KeygenPublicTableControl.assign_heap _ _ _ _ read0).trans heap1
      have heap3 := (KeygenPublicTableControl.assign_heap _ _ _ _ read1).trans heap2
      have heap4 := (KeygenPublicTableControl.assign_heap _ _ _ _ mult).trans heap3
      obtain ⟨lw,writeLow⟩ := store_trace s4 ⟨s5,.normal⟩ a _ u _ f4.pointer
        (fun v ev => low_value s4 u hu v f4.u ev) low
      obtain ⟨hw,writeHigh⟩ := store_trace s5 ⟨s6,.normal⟩ a _ (u+768) _ f5.pointer
        (fun v ev => high_value s5 u hu v f5.u f5.hn ev) high
      rw [heap4] at writeLow
      exact ⟨s5.heap,lw,hw,writeLow,writeHigh⟩

theorem written_after_store (before after : Memory) (a : ArrayPointer)
    (width : a.elementBytes = 2) (i j : Nat) (w : BitVec 16)
    (write : Store16 before (element a i) w after)
    (old : Written before (element a j)) : Written after (element a j) := by
  by_cases equal : i=j
  · subst j
    exact ⟨w,KeygenPublicTableCells.stored_load _ _ _ _ write⟩
  · obtain ⟨v,read⟩ := old
    exact ⟨v,C99NarrowReads.load16_transport _ _ _ _ read write.2.2.2.1
      (fun byte => write.2.2.2.2.2.2 _ _
        (KeygenPublicTableCells.different_cell a width i j equal byte))⟩

theorem body_invariant (s after : State) (a gm : ArrayPointer) (u : Nat)
    (hu : u < 768) (inv : FirstInv s a gm u)
    (run : Exec KeygenPublicSource.program [] PublicTailShape159.firstBody s ⟨after,.normal⟩) :
    FirstInv after a gm u := by
  rw [body_eq] at run
  obtain ⟨middle,lw,hw,low,high⟩ := body_trace s ⟨after,.normal⟩ a u hu
    ⟨inv.aBinding,inv.uSlot,inv.hnSlot⟩ run
  obtain ⟨_,arrays,locals⟩ := KeygenPublicTableControl.frame _ _ _ _ _
    KeygenPublicFirstValues.body_supported run
  have sizes : after.heap.size = s.heap.size := high.2.2.2.1.trans low.2.2.2.1
  have writable : after.heap.writable = s.heap.writable :=
    high.2.2.2.2.1.trans low.2.2.2.2.1
  refine ⟨by rw [arrays]; exact inv.aBinding,
    by rw [arrays]; exact inv.squareBinding,
    (locals _ (by decide)).trans inv.nSlot,
    (locals _ (by decide)).trans inv.hnSlot,
    (locals _ (by decide)).trans inv.lognSlot,?_,
    (locals _ (by decide)).trans inv.uSlot,?_,inv.aWidth,?_,?_,inv.aCount⟩
  · obtain ⟨w,slot⟩ := inv.rSlot
    exact ⟨w,(locals _ (by decide)).trans slot⟩
  · intro j hj
    exact written_after_store middle after.heap a inv.aWidth (u+768) j hw high
      (written_after_store s.heap middle a inv.aWidth u j lw low (inv.aImage j hj))
  · rw [writable]; exact inv.aWritable
  · intro j hj
    simpa only [Allocated,sizes] using inv.aAllocated j hj

theorem body_source (s : State) (a gm : ArrayPointer) (u : Nat)
    (hu : u < 768) (inv : FirstInv s a gm u) :
    ∃ after, Exec KeygenPublicSource.program [] PublicTailShape159.firstBody s ⟨after,.normal⟩ ∧
      FirstInv after a gm u := by
  obtain ⟨after,run,_,_⟩ := PublicTailFirst159.firstBody_exec s a gm u hu (by omega) inv
  exact ⟨after,run,body_invariant s after a gm u hu inv run⟩

end FT1536.Source3.PublicTailFrame160
