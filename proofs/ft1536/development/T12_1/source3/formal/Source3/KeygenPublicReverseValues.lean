import Source3.KeygenPublicReverseProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The reverse butterfly has ordinary outputs x+y and (x-y)*z.
   Its two writes are chronological; the loaded twiddle is radix*z. -/
namespace FT1536.Source3.KeygenPublicReverseValues
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicValueExpr (Local)
open KeygenPublicInputCells (Cell)
open KeygenPublicAlgebra (R radix)
open KeygenPublicTableControl (seq_inv frame)
open KeygenPublicReverseProgram
open KeygenPublicRadixValues (Fixed fixed_after low_value high_value)

def PairUpdate (before after : Memory) (a : ArrayPointer) (i h : Nat) (x y z : R) : Prop :=
  Cell after a i (x+y) ∧ Cell after a (i+h) ((x-y)*z) ∧
    ∃ (middle : Memory) (low high : BitVec 16),
      KeygenSmallOutput.Store16 before (KeygenSmallOutput.element a i) low middle ∧
      KeygenSmallOutput.Store16 middle (KeygenSmallOutput.element a (i+h)) high after

theorem source_body (s : State) (out : Result) (a : ArrayPointer) (i h : Nat) (x y z : R)
    (positive : 0 < h) (bound : i+h<1536) (width : a.elementBytes=2) (fixed : Fixed s a i h)
    (first : Cell s.heap a i x) (second : Cell s.heap a (i+h) y)
    (twiddle : Local s "s" (radix*z)) (source : Exec KeygenPublicSource.program [] body s out) :
    PairUpdate s.heap out.state.heap a i h x y z := by
  cases source with
  | scope _ _ _ _ result executed =>
      obtain ⟨s1,decl,rest1⟩ := seq_inv _ _ s result (by decide) executed
      obtain ⟨s2,read0,rest2⟩ := seq_inv _ _ s1 result (by decide) rest1
      obtain ⟨s3,read1,rest3⟩ := seq_inv _ _ s2 result (by decide) rest2
      obtain ⟨s4,low,rest4⟩ := seq_inv _ _ s3 result (by decide) rest3
      obtain ⟨s5,high,last⟩ := seq_inv _ _ s4 result (by decide) rest4
      cases last
      have declared := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s .u32 names ⟨s1,.normal⟩ decl)
      dsimp only at declared
      have f1 := fixed_after declaration s ⟨s1,.normal⟩ a i h fixed (by decide) (by decide) decl
      have f2 := fixed_after readLow s1 ⟨s2,.normal⟩ a i h f1 (by decide) (by decide) read0
      have f3 := fixed_after readHigh s2 ⟨s3,.normal⟩ a i h f2 (by decide) (by decide) read1
      have f4 := fixed_after storeLow s3 ⟨s4,.normal⟩ a i h f3 (by decide) (by decide) low
      have heap1 : s1.heap=s.heap := by rw [declared]
      have heap2 : s2.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ read0).trans heap1
      have heap3 : s3.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ read1).trans heap2
      have a0 := KeygenPublicValueExpr.assign_value s1 ⟨s2,.normal⟩ "a0" _ x ⟨none,by rw [declared]; rfl⟩
        (KeygenPublicFirstValues.load_value s1 a lowIndex i x f1.pointer (fun v ev => low_value s1 i (by omega) v f1.v ev)
          (by rw [heap1]; exact first)) read0
      have a1Declared : ∃ old, s2.locals "a1".toList=some (.uint32,old) := by
        refine ⟨none,?_⟩
        rw [(frame _ _ _ _ _ (by decide) read0).2.2 _ (by decide),declared]; rfl
      have a1 := KeygenPublicValueExpr.assign_value s2 ⟨s3,.normal⟩ "a1" _ y a1Declared
        (KeygenPublicFirstValues.load_value s2 a highIndex (i+h) y f2.pointer
          (fun v ev => high_value s2 i h bound v f2.v f2.ht ev) (by rw [heap2]; exact second)) read1
      have a03 := KeygenPublicValueExpr.local_after readHigh s2 ⟨s3,.normal⟩ "a0" x (by decide) (by decide) a0 read1
      obtain ⟨lowCell,lw,lowStore⟩ := KeygenPublicFirstValues.store_value s3 ⟨s4,.normal⟩ a lowIndex i _ (x+y) f3.pointer
        (fun v ev => low_value s3 i (by omega) v f3.v ev)
        (KeygenPublicValueExpr.add_value s3 _ _ x y
          (KeygenPublicValueExpr.local_value _ "a0" _ a03) (KeygenPublicValueExpr.local_value _ "a1" _ a1)) low
      have a04 := KeygenPublicValueExpr.local_after storeLow s3 ⟨s4,.normal⟩ "a0" x (by decide) (by decide) a03 low
      have a14 := KeygenPublicValueExpr.local_after storeLow s3 ⟨s4,.normal⟩ "a1" y (by decide) (by decide) a1 low
      have z1 := KeygenPublicValueExpr.local_after declaration s ⟨s1,.normal⟩ "s" _ (by decide) (by decide) twiddle decl
      have z2 := KeygenPublicValueExpr.local_after readLow s1 ⟨s2,.normal⟩ "s" _ (by decide) (by decide) z1 read0
      have z3 := KeygenPublicValueExpr.local_after readHigh s2 ⟨s3,.normal⟩ "s" _ (by decide) (by decide) z2 read1
      have z4 := KeygenPublicValueExpr.local_after storeLow s3 ⟨s4,.normal⟩ "s" _ (by decide) (by decide) z3 low
      obtain ⟨highCell,hw,highStore⟩ := KeygenPublicFirstValues.store_value s4 ⟨s5,.normal⟩ a highIndex (i+h) _ ((x-y)*z) f4.pointer
        (fun v ev => high_value s4 i h bound v f4.v f4.ht ev)
        (KeygenPublicValueExpr.twiddle_value s4 _ _ (x-y) z
          (KeygenPublicValueExpr.sub_value s4 _ _ x y
            (KeygenPublicValueExpr.local_value _ "a0" _ a04) (KeygenPublicValueExpr.local_value _ "a1" _ a14))
          (KeygenPublicValueExpr.local_value _ "s" _ z4)) high
      have finalLow := KeygenPublicInputCells.preserves _ _ a width (i+h) i (by omega) hw _ highStore lowCell
      rw [heap3] at lowStore
      exact ⟨finalLow,highCell,s4.heap,lw,hw,lowStore,highStore⟩

end FT1536.Source3.KeygenPublicReverseValues
