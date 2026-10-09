import Source3.KeygenPublicTripleFold
import Source3.KeygenPublicRadixPolynomial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete source forward evaluations of the ORIGINAL polynomial at all
   1536 physical points. No NTT image, nonzero test or round-trip premise. -/
namespace FT1536.Source3.KeygenPublicEvaluation
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec)
open KeygenPublicAlgebra (R radix)
open KeygenPublicInputCells (Cell Cells)
open KeygenPublicInputMaterial (reduced)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicRadixEntry (Header)
open KeygenPublicSizeOps (Declared)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableControl (frame seq_inv)
open KeygenPublicTripleProgram (seed pass initU initV loop)
open FT1536.Run2

def Evaluations (heap : Memory) (a : ArrayPointer) (original : Geometry.Vec) : Prop :=
  ∀ i : Fin 1536, Cell heap a i.val
    ((CoefficientQuotient.polynomial (Relation.reduceVec original)).eval (KeygenPublicRoots.point i))

theorem init_v_value (s : State) (v : Value) (profile : Slot s "logn" 10)
    (source : KeygenPublicWord.Eval [] s
      (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1))
        (.bin .sub (KeygenPublicTableAtoms.var "logn") (KeygenPublicTableAtoms.literal 1))) v) : v=u64 512 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have ae : a=u64 1 := by
        cases left with
        | cast _ _ value evaluated =>
            rw [KeygenPublicTableAtoms.literal_value [] s 1 value evaluated]; rfl
      have be := KeygenPublicLastEntry.logn_minus_one s b profile right
      subst a; subst b
      obtain ⟨k,hk,_,equal⟩ := KeygenNttForwardExec.shift_left_value _ _ v op
      have nine : k=9 := by change (9 : Int)=(k : Int) at hk; omega
      subst k; exact equal

theorem source_triple (a : Nat → R) (p gm : ArrayPointer) (s : State) (out : Result)
    (header : Header p gm s) (uType : Declared s "u") (vType : Declared s "v")
    (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] KeygenPublicRadixProgram.triple s out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (KeygenPublicTripleFold.value a) := by
  rw [KeygenPublicTripleProgram.source_triple] at source
  obtain ⟨s1,seedExec,rest⟩ := seq_inv seed _ s out (by decide) source
  obtain ⟨final,passExec,last⟩ := seq_inv pass .skip s1 out (by decide) rest
  cases last
  obtain ⟨entry,initial,loopExec⟩ := seq_inv (.seq initU initV) loop s1 ⟨final,.normal⟩ (by decide) passExec
  obtain ⟨s2,uExec,vExec⟩ := seq_inv initU initV s1 ⟨entry,.normal⟩ (by decide) initial
  have rootValue := KeygenPublicFirstEntry.table_load s "gm_square" gm header.fixed.square header.fixed.table
  have seeded := KeygenPublicValueExpr.twiddle_value s _ _ (radix*KeygenPublicRoots.firstRoot) KeygenPublicRoots.firstRoot rootValue rootValue
  have wValue : KeygenPublicValueExpr.Evaluates s
      (KeygenPublicTableAtoms.mont (.load16 "gm_square".toList (.literal .i32 1))
        (.load16 "gm_square".toList (.literal .i32 1))) (radix*KeygenPublicRoots.unity) := by
    have eq : (radix*KeygenPublicRoots.firstRoot)*KeygenPublicRoots.firstRoot=radix*KeygenPublicRoots.unity := by
      rw [KeygenPublicRoots.unity]; ring
    rw [← eq]; exact seeded
  have w := KeygenPublicValueExpr.assign_value s ⟨s1,.normal⟩ "w" _ _ header.wType wValue seedExec
  have f1 := frame _ [] seed s ⟨s1,.normal⟩ (by decide) seedExec
  have heap1 := KeygenPublicTableControl.assign_heap _ _ _ _ seedExec
  have fixed1 : KeygenPublicTripleFold.Fixed p gm s1 := by
    refine ⟨header.fixed.width,header.fixed.separate,?_,?_,?_,?_,w⟩
    · rw [f1.2.1]; exact header.fixed.pointer
    · rw [f1.2.1]; exact header.cubic
    · rw [heap1]; exact header.fixed.table
    · exact (f1.2.2 _ (by decide)).trans header.n
  have uType1 : Declared s1 "u" := by rw [Declared,f1.2.2 _ (by decide)]; exact uType
  obtain ⟨u,heap2⟩ := KeygenPublicSizeOps.init s1 ⟨s2,.normal⟩ "u" 0 (by decide) uType1 uExec
  have f2 := frame _ [] initU s1 ⟨s2,.normal⟩ (by decide) uExec
  have vType2 : Declared s2 "v" := by rw [Declared,f2.2.2 _ (by decide),f1.2.2 _ (by decide)]; exact vType
  have logn2 : Slot s2 "logn" 10 := (f2.2.2 _ (by decide)).trans ((f1.2.2 _ (by decide)).trans header.profile)
  have v := (KeygenPublicSizeOps.assign s2 ⟨entry,.normal⟩ "v" _ 512 (by decide) vType2
    (fun v ev => init_v_value s2 v logn2 ev) vExec).2
  have fixed2 := KeygenPublicTripleFold.fixed_after initU s1 ⟨s2,.normal⟩ p gm (by decide) (by decide) (by decide) fixed1 uExec
  have fixedE := KeygenPublicTripleFold.fixed_after initV s2 ⟨entry,.normal⟩ p gm (by decide) (by decide) (by decide) fixed2 vExec
  have uE : USlot entry "u" 0 := (frame _ [] initV _ _ (by decide) vExec).2.2 _ (by decide) |>.trans u
  have cellsE : Cells entry.heap p 1536 a := by
    rw [KeygenPublicTableControl.assign_heap _ _ _ _ vExec,heap2,heap1]; exact cells
  exact KeygenPublicTripleFold.source_loop a p gm entry ⟨final,.normal⟩ fixedE uE v cellsE loopExec

theorem original_values (original : Geometry.Vec) (i : Fin 1536) :
    KeygenPublicTripleFold.value (KeygenPublicRadixEntry.radixImage original) i.val=
      (CoefficientQuotient.polynomial (Relation.reduceVec original)).eval (KeygenPublicRoots.point i) :=
  (KeygenPublicTripleOrder.all_physical_evaluations _ i).trans (KeygenPublicRadixPolynomial.original_block original i)

theorem source_complete (original : Geometry.Vec) (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT) s out) :
    out.flow=.normal ∧ Evaluations out.state.heap a original := by
  obtain ⟨inner,⟨gm,after,header,_,_,u,vType,image,triple⟩,flow,block⟩ :=
    KeygenPublicRadixInvocation.source_radix original s out a profile input cells source
  obtain ⟨normal,evaluated⟩ := source_triple _ a gm after inner header ⟨_,u⟩ vType image triple
  have observed := KeygenPublicFirstTables.cells_block _ _ a 1536 _ block evaluated
  refine ⟨flow.trans normal,?_⟩
  intro i
  have value := observed i.val i.isLt
  rwa [original_values original i] at value

end FT1536.Source3.KeygenPublicEvaluation
