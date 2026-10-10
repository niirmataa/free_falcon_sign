import Source3.KeygenPublicRootInverseProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual first-root inverse: b=z*(x-y), low=x+y-b, high=b+b.
   The source r is scaled, while both chronological stores are ordinary. -/
namespace FT1536.Source3.KeygenPublicRootInverseValues
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicValueExpr (Local)
open KeygenPublicInputCells (Cell)
open KeygenPublicAlgebra (R radix)
open KeygenPublicTableControl (seq_inv frame)
open KeygenPublicFirstValues (Fixed fixed_after low_value high_value load_value store_value)
open KeygenPublicRootInverseProgram

def PairUpdate (before after : Memory) (a : ArrayPointer) (i : Nat) (x y z : R) : Prop :=
  Cell after a i (x+y-z*(x-y)) ∧ Cell after a (i+768) (z*(x-y)+z*(x-y)) ∧
    ∃ (middle : Memory) (low high : BitVec 16),
      KeygenSmallOutput.Store16 before (KeygenSmallOutput.element a i) low middle ∧
      KeygenSmallOutput.Store16 middle (KeygenSmallOutput.element a (i+768)) high after

theorem source_body (s : State) (out : Result) (a : ArrayPointer) (i : Nat) (x y z : R)
    (hi : i<768) (width : a.elementBytes=2) (fixed : Fixed s a i)
    (first : Cell s.heap a i x) (second : Cell s.heap a (i+768) y)
    (r : Local s "r" (radix*z)) (source : Exec KeygenPublicSource.program [] body s out) :
    PairUpdate s.heap out.state.heap a i x y z := by
  cases source with
  | scope _ _ _ _ result executed =>
      obtain ⟨s1,decl,rest1⟩ := seq_inv _ _ s result (by decide) executed
      obtain ⟨s2,read0,rest2⟩ := seq_inv _ _ s1 result (by decide) rest1
      obtain ⟨s3,read1,rest3⟩ := seq_inv _ _ s2 result (by decide) rest2
      obtain ⟨s4,mult,rest4⟩ := seq_inv _ _ s3 result (by decide) rest3
      obtain ⟨s5,low,rest5⟩ := seq_inv _ _ s4 result (by decide) rest4
      obtain ⟨s6,high,last⟩ := seq_inv _ _ s5 result (by decide) rest5
      cases last
      have declared := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s .u32 names ⟨s1,.normal⟩ decl)
      dsimp only at declared
      have f1 := fixed_after declaration s ⟨s1,.normal⟩ a i fixed (by decide) (by decide) decl
      have f2 := fixed_after readLow s1 ⟨s2,.normal⟩ a i f1 (by decide) (by decide) read0
      have f3 := fixed_after readHigh s2 ⟨s3,.normal⟩ a i f2 (by decide) (by decide) read1
      have f4 := fixed_after multiply s3 ⟨s4,.normal⟩ a i f3 (by decide) (by decide) mult
      have f5 := fixed_after storeLow s4 ⟨s5,.normal⟩ a i f4 (by decide) (by decide) low
      have heap1 : s1.heap=s.heap := by rw [declared]
      have heap2 : s2.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ read0).trans heap1
      have heap3 : s3.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ read1).trans heap2
      have heap4 : s4.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ mult).trans heap3
      have a0 := KeygenPublicValueExpr.assign_value s1 ⟨s2,.normal⟩ "a0" _ x
        ⟨none,by rw [declared]; rfl⟩
        (load_value s1 a lowIndex i x f1.pointer (fun v ev => low_value s1 i hi v f1.u ev)
          (by rw [heap1]; exact first)) read0
      have a1Declared : ∃ old, s2.locals "a1".toList=some (.uint32,old) := by
        refine ⟨none,?_⟩
        rw [(frame _ _ _ _ _ (by decide) read0).2.2 _ (by decide),declared]; rfl
      have a1 := KeygenPublicValueExpr.assign_value s2 ⟨s3,.normal⟩ "a1" _ y a1Declared
        (load_value s2 a highIndex (i+768) y f2.pointer (fun v ev => high_value s2 i hi v f2.u f2.hn ev)
          (by rw [heap2]; exact second)) read1
      have a03 := KeygenPublicValueExpr.local_after readHigh s2 ⟨s3,.normal⟩ "a0" x (by decide) (by decide) a0 read1
      have r1 := KeygenPublicValueExpr.local_after declaration s ⟨s1,.normal⟩ "r" _ (by decide) (by decide) r decl
      have r2 := KeygenPublicValueExpr.local_after readLow s1 ⟨s2,.normal⟩ "r" _ (by decide) (by decide) r1 read0
      have r3 := KeygenPublicValueExpr.local_after readHigh s2 ⟨s3,.normal⟩ "r" _ (by decide) (by decide) r2 read1
      have bDeclared : ∃ old, s3.locals "b".toList=some (.uint32,old) := by
        refine ⟨none,?_⟩
        rw [(frame _ _ _ _ _ (by decide) read1).2.2 _ (by decide),
          (frame _ _ _ _ _ (by decide) read0).2.2 _ (by decide),declared]; rfl
      have b := KeygenPublicValueExpr.assign_value s3 ⟨s4,.normal⟩ "b" _ (z*(x-y)) bDeclared
        (KeygenPublicInverseValues.scaled_left s3 _ _ z (x-y)
          (KeygenPublicValueExpr.local_value _ "r" _ r3)
          (KeygenPublicValueExpr.sub_value s3 _ _ x y
            (KeygenPublicValueExpr.local_value _ "a0" _ a03) (KeygenPublicValueExpr.local_value _ "a1" _ a1))) mult
      have a04 := KeygenPublicValueExpr.local_after multiply s3 ⟨s4,.normal⟩ "a0" x (by decide) (by decide) a03 mult
      have a14 := KeygenPublicValueExpr.local_after multiply s3 ⟨s4,.normal⟩ "a1" y (by decide) (by decide) a1 mult
      obtain ⟨lowCell,lw,lowStore⟩ := store_value s4 ⟨s5,.normal⟩ a lowIndex i _ (x+y-z*(x-y)) f4.pointer
        (fun v ev => low_value s4 i hi v f4.u ev)
        (KeygenPublicValueExpr.sub_value s4 _ _ (x+y) (z*(x-y))
          (KeygenPublicValueExpr.add_value s4 _ _ x y
            (KeygenPublicValueExpr.local_value _ "a0" _ a04) (KeygenPublicValueExpr.local_value _ "a1" _ a14))
          (KeygenPublicValueExpr.local_value _ "b" _ b)) low
      have b5 := KeygenPublicValueExpr.local_after storeLow s4 ⟨s5,.normal⟩ "b" _ (by decide) (by decide) b low
      obtain ⟨highCell,hw,highStore⟩ := store_value s5 ⟨s6,.normal⟩ a highIndex (i+768) _ (z*(x-y)+z*(x-y)) f5.pointer
        (fun v ev => high_value s5 i hi v f5.u f5.hn ev)
        (KeygenPublicValueExpr.add_value s5 _ _ _ _
          (KeygenPublicValueExpr.local_value _ "b" _ b5) (KeygenPublicValueExpr.local_value _ "b" _ b5)) high
      have finalLow := KeygenPublicInputCells.preserves _ _ a width (i+768) i (by omega) hw _ highStore lowCell
      rw [heap4] at lowStore
      exact ⟨finalLow,highCell,s5.heap,lw,hw,lowStore,highStore⟩

end FT1536.Source3.KeygenPublicRootInverseValues
