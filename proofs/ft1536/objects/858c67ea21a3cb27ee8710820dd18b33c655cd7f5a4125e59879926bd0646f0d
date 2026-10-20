import Source3.KeygenPublicInputMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual MKN, ternary q branch and initialized caller dimensions. -/
namespace FT1536.Source3.KeygenPublicInputSetup
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt chain)
open KeygenPublicInputProgram (signed)
open KeygenPublicTableAtoms (Slot var literal)
open KeygenNttLoopSupport (USlot u64)

def ternaryShift : KeygenWordExpr.Expr := .bin .shl (var "ternary") (literal 1)
def leftCount : KeygenWordExpr.Expr := .cast .uint64 (.bin .add (literal 1) ternaryShift)
def rightCount : KeygenWordExpr.Expr := .bin .sub (var "logn") (var "ternary")
def dimension : KeygenWordExpr.Expr := .bin .shl leftCount rightCount
def declareQ : Stmt := .scalar (.declare .u32 ["q".toList])
def nSet : Stmt := .assign "n".toList dimension
def qSet : Stmt := .branch (var "ternary") (.assign "q".toList (literal 18433)) (.assign "q".toList (literal 12289))
def complete : Stmt := chain [declareQ,nSet,qSet]

theorem source_complete : KeygenPublicInputProgram.setup=complete := by decide
theorem supported : KeygenPublicTableControl.supported complete=true := by decide
theorem writes : KeygenPublicTableControl.writes complete=["q".toList,"n".toList,"q".toList,"q".toList] := by decide

theorem ternary_value (s : State) (v : Value) (profile : KeygenPublicForwardWrapper.Ternary s)
    (source : KeygenPublicWord.Eval signed s (var "ternary") v) : v=.int32 1 := by
  cases source
  cases ‹KeygenPublicWord.scalar _ _ _› with
  | «variable» _ _ _ binding =>
      exact Option.some.inj (congrArg Prod.snd (Option.some.inj (binding.symm.trans profile)))

theorem dimension_value (s : State) (v : Value) (logn : Slot s "logn" 10)
    (ternary : KeygenPublicForwardWrapper.Ternary s) (source : KeygenPublicWord.Eval signed s dimension v) : v=u64 1536 := by
  cases source with
  | bin _ _ _ av bv _ left right op =>
      have be : bv=.uint32 9 := by
        cases right with
        | bin _ _ _ x y _ first second subtract =>
            have xe := KeygenPublicTableAtoms.variable_value signed s "logn" 10 x logn first
            have ye := ternary_value s y ternary second
            subst x; subst y
            exact ((C99IntegerReference.arithmetic_iff _ _ _ _).mp subtract).2
      have ae : av=u64 3 := by
        cases left with
        | cast _ _ x casted =>
            cases casted with
            | bin _ _ _ a b _ first second addition =>
                have aeq := KeygenPublicTableAtoms.literal_value signed s 1 a first
                subst a
                cases second with
                | bin _ _ _ t one _ ter oneEval shift =>
                    have te := ternary_value s t ternary ter
                    have oe := KeygenPublicTableAtoms.literal_value signed s 1 one oneEval
                    subst t; subst one
                    obtain ⟨amount,count,_,equal⟩ := KeygenNttForwardExec.shift_left_value _ _ b shift
                    have amountEq : amount=1 := by change (1 : Int)=(amount : Int) at count; omega
                    subst amount
                    have bEq : b=.int32 2 := equal
                    subst b
                    have sum := ((C99IntegerReference.arithmetic_iff _ _ _ _).mp addition).2
                    rw [sum]
                    rfl
      subst av; subst bv
      obtain ⟨amount,count,_,equal⟩ := KeygenNttForwardExec.shift_left_value _ _ v op
      have amountEq : amount=9 := by change (9 : Int)=(amount : Int) at count; omega
      subst amount
      exact equal

theorem source_setup (s : State) (out : Result) (p : KeygenPublicInputLoop.Pointers)
    (logn : Slot s "logn" 10) (ternary : KeygenPublicForwardWrapper.Ternary s)
    (arrays : s.arrays "f".toList=some p.f ∧ s.arrays "g".toList=some p.g ∧
      s.arrays "t".toList=some p.t ∧ s.arrays "h".toList=some p.h)
    (old : Option Value) (nDeclared : s.locals "n".toList=some (.uint64,old))
    (source : Exec KeygenPublicSource.program signed KeygenPublicInputProgram.setup s out) :
    out.flow=.normal ∧ out.state.heap=s.heap ∧ KeygenPublicInputLoop.Fixed p out.state := by
  rw [source_complete] at source
  obtain ⟨s1,decl,rest1⟩ := KeygenPublicInputAtoms.seq_inv signed declareQ _ s out (by decide) source
  obtain ⟨s2,nExec,rest2⟩ := KeygenPublicInputAtoms.seq_inv signed nSet _ s1 out (by decide) rest1
  obtain ⟨s3,qExec,last⟩ := KeygenPublicInputAtoms.seq_inv signed qSet .skip s2 out (by decide) rest2
  cases last
  have firstState := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ signed s .u32 ["q".toList] ⟨s1,.normal⟩ decl)
  dsimp only at firstState
  have logn1 : Slot s1 "logn" 10 := by rw [firstState]; exact logn
  have ternary1 : KeygenPublicForwardWrapper.Ternary s1 := by rw [firstState]; exact ternary
  have n1 : s1.locals "n".toList=some (.uint64,old) := by rw [firstState]; exact nDeclared
  have nEq : s2=C99ArrayReference.bindValue s1 "n".toList .uint64 (u64 1536) := by
    cases nExec with
    | assign _ _ _ ty previous v declared evaluated =>
        have te := congrArg Prod.fst (Option.some.inj (declared.symm.trans n1))
        dsimp only at te
        subst ty
        rw [dimension_value s1 v logn1 ternary1 evaluated]
  have n2 : USlot s2 "n" 1536 := by
    rw [nEq]
    simp only [USlot,C99ArrayReference.bindValue,C99ScalarReference.set,ite_true,
      KeygenNttLoopSupport.convert_u64_self 1536 (by decide)]
  have ternary2 : KeygenPublicForwardWrapper.Ternary s2 := by rw [nEq]; exact ternary1
  have q2 : ∃ old, s2.locals "q".toList=some (.uint32,old) := by
    rw [nEq,firstState]
    exact ⟨none,rfl⟩
  have q3 : Slot s3 "q" 18433 := by
    cases qExec with
    | branchTrue _ _ _ _ _ v guard nonzero inner =>
        obtain ⟨old,bound⟩ := q2
        cases inner with
        | assign _ _ _ ty previous v declared evaluated =>
            have te := congrArg Prod.fst (Option.some.inj (declared.symm.trans bound))
            dsimp only at te
            subst ty
            rw [KeygenPublicTableAtoms.literal_value signed s2 18433 v evaluated]
            rfl
    | branchFalse _ _ _ _ _ v guard zero inner =>
        rw [ternary_value s2 v ternary2 guard] at zero
        contradiction
  have n3 : USlot s3 "n" 1536 :=
    (KeygenPublicTableControl.frame _ _ qSet s2 ⟨s3,.normal⟩ (by decide) qExec).2.2 _ (by decide) |>.trans n2
  have arr3 := (KeygenPublicTableControl.frame _ _ complete s ⟨s3,.normal⟩ supported source).2.1
  have heap1 : s1.heap=s.heap := by rw [firstState]
  have heap2 : s2.heap=s1.heap := by rw [nEq]; rfl
  have heap3 : s3.heap=s2.heap := by
    cases qExec with
    | branchTrue _ _ _ _ _ _ _ _ inner => cases inner; rfl
    | branchFalse _ _ _ _ _ _ _ _ inner => cases inner; rfl
  exact ⟨rfl,heap3.trans (heap2.trans heap1),
    ⟨by rw [arr3]; exact arrays.1,by rw [arr3]; exact arrays.2.1,
      by rw [arr3]; exact arrays.2.2.1,by rw [arr3]; exact arrays.2.2.2,n3,q3⟩⟩

end FT1536.Source3.KeygenPublicInputSetup
