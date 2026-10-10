import Source3.KeygenPublicNormalizeProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- At logn10 the LIVE source call computes radix/1536, not a table lookup.
   Its scaled meaning and both actual argument conversions are proved. -/
namespace FT1536.Source3.KeygenPublicNormalizeAtoms
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec)
open KeygenPublicAlgebra (R radix value)
open KeygenPublicValueExpr (Local Evaluates)
open KeygenPublicTableAtoms (Slot)
open KeygenNttLoopSupport (USlot)
open KeygenPublicNormalizeProgram

noncomputable def inverseN : R := (1536 : R)⁻¹
theorem dimension_nonzero : (1536 : R)≠0 := by decide
theorem dimension_cancel : (1536 : R)*inverseN=1 := mul_inv_cancel₀ dimension_nonzero

theorem live_value (s : State) (n : USlot s "n" 1536) : Evaluates s live (radix*inverseN) := by
  intro v source
  cases source with
  | call2 _ _ _ av bv _ first second called =>
      have ae := KeygenPublicTableAtoms.literal_value [] s 10237 av first
      have be : bv=.uint32 (1536#32) := by
        cases second with
        | cast _ _ old evaluated =>
            rw [KeygenPublicTableIndex.word64 s "n" 1536 old n evaluated]
            rfl
      subst av; subst bv
      have normalized := KeygenPublicDivisionAlgebra.normalize_call (10237#32) (1536#32)
        (C99IntegerReference.convert .int32 10237) (.uint32 (1536#32)) v (by rfl) (by rfl) called
      have exactResult := KeygenPublicDivisionWords.source_exact (10237#32) (1536#32) v normalized
      rw [exactResult] at normalized ⊢
      obtain ⟨range,_,law⟩ := KeygenPublicDivisionAlgebra.source_division _ _ _
        (by change 10237<18433; decide) (by change 1536<18433; decide) (by decide) normalized
      rw [KeygenPublicAlgebra.radix_word] at law
      refine ⟨KeygenPublicRangeExpr.uint32_range _ range,?_⟩
      change value _=radix*inverseN
      exact law

theorem source_ni (s : State) (out : Result) (profile : Slot s "logn" 10) (n : USlot s "n" 1536)
    (declared : ∃ old, s.locals "ni".toList=some (.uint32,old))
    (source : Exec KeygenPublicSource.program [] niSet s out) :
    Local out.state "ni" (radix*inverseN) ∧ out.state.heap=s.heap := by
  cases source with
  | branchTrue _ _ _ _ _ v guard nonzero inner =>
      rw [KeygenPublicForwardRange.condition_value s v profile guard] at nonzero
      exact (nonzero rfl).elim
  | branchFalse _ _ _ _ _ v guard zero inner =>
      exact ⟨KeygenPublicValueExpr.assign_value s out "ni" live _ declared (live_value s n) inner,
        KeygenPublicTableControl.assign_heap _ _ _ _ inner⟩

theorem index_value (s : State) (i : Nat) (hi : i<1536) (u : USlot s "u" i)
    (v : Value) (source : KeygenPublicWord.scalar s index v) : v.integer.toNat=i := by
  rw [KeygenPublicTableIndex.variable64 s "u" i v u source]
  exact KeygenNttLoopSupport.u64_toNat i (by omega)

theorem source_body (s : State) (out : Result) (p : ArrayPointer) (i : Nat) (x z : R)
    (hi : i<1536) (pointer : s.arrays "a".toList=some p) (counter : USlot s "u" i)
    (cell : KeygenPublicInputCells.Cell s.heap p i x) (ni : Local s "ni" (radix*z))
    (source : Exec KeygenPublicSource.program [] body s out) :
    KeygenPublicInputCells.Cell out.state.heap p i (x*z) ∧
      ∃ w, KeygenSmallOutput.Store16 s.heap (KeygenSmallOutput.element p i) w out.state.heap := by
  cases source with
  | scope _ _ _ _ inner executed =>
      obtain ⟨after,stored,last⟩ := KeygenPublicTableControl.seq_inv _ _ s inner (by decide) executed
      cases last
      exact KeygenPublicFirstValues.store_value s ⟨after,.normal⟩ p index i _ (x*z) pointer
        (index_value s i hi counter)
        (KeygenPublicValueExpr.twiddle_value s _ _ x z
          (KeygenPublicFirstValues.load_value s p index i x pointer (index_value s i hi counter) cell)
          (KeygenPublicValueExpr.local_value s "ni" _ ni)) stored

end FT1536.Source3.KeygenPublicNormalizeAtoms
