import Source3.KeygenMkgm3Callees
import Source3.KeygenModpR2Word
import Source3.MknReference
import Source3.C99DeclarationStatements
import Source3.C99CountedWords

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Refinement of the existing r2Body judgment, whose actual leaf callees
   execute pinned source bodies. All source assignments and the return are
   consumed; neither an arithmetic postcondition nor an evaluator is added
   to the execution relation. Additional local bindings are unrestricted. -/
namespace FT1536.Source3.KeygenModpR2Exec
open C99ModularReference
open C99ArrayReference (State bindValue)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenModpR2Word (doubled squares halve word)

def cell (name : String) : Expr := .scalar (.var name.toList)
def rExpr : Expr := .call1 "modp_R".toList (cell "p")
def addExpr : Expr := .call3 "modp_add".toList (cell "z") (cell "z") (cell "p")
def halfExpr : Expr := .scalar r2Halving
def finish : List Stmt := [.assign "z".toList halfExpr,.ret (cell "z")]
def afterDouble (n : Nat) : List Stmt := List.replicate n (.assign "z".toList montZZ)++finish

def Slot (s : State) (name : String) (v : BitVec 32) : Prop :=
  s.locals name.toList=some (.uint32,some (.uint32 v))
def Params (s : State) (p p0i : BitVec 32) : Prop := Slot s "p" p ∧ Slot s "p0i" p0i
def ZType (s : State) : Prop := ∃ old, s.locals "z".toList=some (.uint32,old)
def setZ (s : State) (z : BitVec 32) : State := bindValue s "z".toList .uint32 (.uint32 z)

theorem setZ_slot (s : State) (z : BitVec 32) : Slot (setZ s z) "z" z := by
  simp [Slot,setZ,bindValue,C99ScalarReference.set,C99IntegerReference.convert,Value.integer]

theorem setZ_params (s : State) (p p0i z : BitVec 32) (params : Params s p p0i) :
    Params (setZ s z) p p0i := by
  simpa [Params,Slot,setZ,bindValue,C99ScalarReference.set] using params

theorem slot_type (s : State) (z : BitVec 32) (slot : Slot s "z" z) : ZType s :=
  ⟨some (.uint32 z),slot⟩

theorem cell_exact (s : State) (name : String) (w : BitVec 32) (v : Value)
    (slot : Slot s name w) (source : GenEval LeafCall s (cell name) v) : v=.uint32 w := by
  cases source with
  | scalar _ _ source =>
      exact C99CountedWords.variable_exact s name.toList .uint32 (.uint32 w) v slot source

theorem cell_exists (s : State) (name : String) (w : BitVec 32) (slot : Slot s name w) :
    GenEval LeafCall s (cell name) (.uint32 w) :=
  .scalar _ _ (.variable name.toList .uint32 (.uint32 w) slot)

/- The final scalar expression is transported by its read set only. -/
def halfParams : List (B20.C.Ty×B20.C.Name) := [(.u32,"z".toList),(.u32,"p".toList)]
def halfModel (z p : BitVec 32) : B20.C.Scalar.State :=
  (B20.C.Scalar.bindArgs halfParams [.u32 z,.u32 p]).getD B20.C.Scalar.emptyState

theorem half_typed (z p : BitVec 32) : C99Typing.WellTyped (halfModel z p) :=
  (C99HeaderSound.bind_sound halfParams [.u32 z,.u32 p] (halfModel z p) rfl).2

theorem half_checked (z p : BitVec 32) :
    C99Typing.infer CertificatePrologue.noSignatures (halfModel z p).types r2Halving=some .u32 := rfl

theorem half_model (z p : BitVec 32) :
    ExpressionFuel.unbounded CertificatePrologue.emptyCalls (halfModel z p).values r2Halving=
      some (.u32 (halve z p)) := by
  simp [ExpressionFuel.unbounded,halfModel,halfParams,r2Halving,halve,
    B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,B20.C.Scalar.assign,
    B20.C.update,B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,
    B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe,B20.C.shift,B20.C.neg]

theorem half_agreement (s : State) (z p : BitVec 32) (hz : Slot s "z" z) (hp : Slot s "p" p) :
    C99ExpressionEnvironment.Agree s.locals (C99Typing.environment (halfModel z p))
      (C99ExpressionEnvironment.readNames (C99Frontend.expression r2Halving)) := by
  intro name member
  change name∈["z".toList,"p".toList,"z".toList] at member
  simp only [List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl | rfl | rfl
  · exact hz
  · exact hp
  · exact hz

theorem half_exact (s : State) (z p : BitVec 32) (v : Value)
    (hz : Slot s "z" z) (hp : Slot s "p" p) (source : GenEval LeafCall s halfExpr v) :
    v=.uint32 (halve z p) := by
  cases source with
  | scalar _ _ source =>
      have hs := C99ExpressionEnvironment.transport FprPrefixCalls.calls s.locals
        (C99Typing.environment (halfModel z p)) _ v source (half_agreement s z p hz hp)
      have he := (C99ExpressionBridge.expression_complete CertificatePrologue.noSignatures
        FprPrefixCalls.calls CertificatePrologue.emptyCalls CertificatePrologue.pure_calls_complete
        (halfModel z p) (half_typed z p) r2Halving .u32 v (half_checked z p) hs).1
      rw [half_model] at he
      have hv := congrArg C99ValueBridge.value (Option.some.inj he)
      rw [C99ValueBridge.value_encode] at hv
      exact hv.symm

theorem half_exists (s : State) (z p : BitVec 32) (hz : Slot s "z" z) (hp : Slot s "p" p) :
    GenEval LeafCall s halfExpr (.uint32 (halve z p)) := by
  have hs := C99ExpressionSound.expression_sound FprPrefixCalls.calls CertificatePrologue.emptyCalls
    CertificatePrologue.pure_calls_sound (halfModel z p) (half_typed z p) r2Halving _ (half_model z p)
  exact .scalar _ _ (C99ExpressionEnvironment.transport FprPrefixCalls.calls
    (C99Typing.environment (halfModel z p)) s.locals _ _ hs
    (fun name member => (half_agreement s z p hz hp name member).symm))

theorem r_exact (s : State) (p : BitVec 32) (v : Value)
    (hp : Slot s "p" p) (source : GenEval LeafCall s rExpr v) : v=.uint32 (KeygenModpR.word p) := by
  cases source with
  | call1 _ _ x _ arg call =>
      have hx := cell_exact s "p" p x hp arg
      subst x
      cases call with
      | r _ _ body => exact KeygenModpR.source_exact p v body

theorem add_exact (s : State) (z p : BitVec 32) (v : Value)
    (hz : Slot s "z" z) (hp : Slot s "p" p) (source : GenEval LeafCall s addExpr v) :
    v=.uint32 (KeygenModpAddSub.result .add z z p) := by
  cases source with
  | call3 _ _ _ _ x y t _ first second third call =>
      have hx := cell_exact s "z" z x hz first
      have hy := cell_exact s "z" z y hz second
      have ht := cell_exact s "p" p t hp third
      subst x; subst y; subst t
      cases call with
      | add _ _ body => exact KeygenModpAddSub.source_exact .add z z p v body

theorem mont_exact (s : State) (z p p0i : BitVec 32) (v : Value)
    (hz : Slot s "z" z) (params : Params s p p0i) (source : GenEval LeafCall s montZZ v) :
    v=.uint32 (KeygenModpWord.montgomery z z p p0i) := by
  cases source with
  | call4 _ _ _ _ _ x y t u _ first second third fourth call =>
      have hx := cell_exact s "z" z x hz first
      have hy := cell_exact s "z" z y hz second
      have ht := cell_exact s "p" p t params.1 third
      have hu := cell_exact s "p0i" p0i u params.2 fourth
      subst x; subst y; subst t; subst u
      cases call with
      | montgomery _ _ body => exact KeygenModpWord.source_exact z z p p0i v body

theorem r_exists (s : State) (p : BitVec 32) (hp : Slot s "p" p) :
    GenEval LeafCall s rExpr (.uint32 (KeygenModpR.word p)) :=
  .call1 _ _ _ _ (cell_exists s "p" p hp) (.r _ _ (KeygenModpR.source_exists p))

theorem add_exists (s : State) (z p : BitVec 32) (hz : Slot s "z" z) (hp : Slot s "p" p) :
    GenEval LeafCall s addExpr (.uint32 (KeygenModpAddSub.result .add z z p)) :=
  .call3 _ _ _ _ _ _ _ _ (cell_exists s "z" z hz) (cell_exists s "z" z hz)
    (cell_exists s "p" p hp) (.add _ _ (KeygenModpAddSub.source_exists .add z z p))

theorem mont_exists (s : State) (z p p0i : BitVec 32)
    (hz : Slot s "z" z) (params : Params s p p0i) :
    GenEval LeafCall s montZZ (.uint32 (KeygenModpWord.montgomery z z p p0i)) :=
  .call4 _ _ _ _ _ _ _ _ _ _ (cell_exists s "z" z hz) (cell_exists s "z" z hz)
    (cell_exists s "p" p params.1) (cell_exists s "p0i" p0i params.2)
    (.montgomery _ _ (KeygenModpWord.source_exists z z p p0i))

/- Straight-line control facts at the leaf-call stratum. -/
theorem continuation (head tail : Stmt) (s next : State) (out : Result)
    (unique : ∀ r, GenExec LeafCall head s r → r=⟨next,.normal⟩)
    (source : GenExec LeafCall (.seq head tail) s out) : GenExec LeafCall tail next out := by
  cases source with
  | seqNormal _ _ _ middle _ first rest =>
      have he : middle=next := congrArg Result.state (unique _ first)
      subst middle
      exact rest
  | seqExit _ _ _ _ first exit =>
      exact False.elim (exit (congrArg Result.flow (unique _ first)))

theorem assign_result (s : State) (e : Expr) (w : BitVec 32) (out : Result)
    (declared : ZType s) (exactValue : ∀ v, GenEval LeafCall s e v → v=.uint32 w)
    (source : GenExec LeafCall (.assign "z".toList e) s out) : out=⟨setZ s w,.normal⟩ := by
  obtain ⟨old,hd⟩ := declared
  cases source with
  | assign name e before ty previous v declared evaluated =>
      have hty := congrArg Prod.fst (Option.some.inj (declared.symm.trans hd))
      change ty=C99IntegerReference.Ty.uint32 at hty
      subst ty
      rw [exactValue v evaluated]
      rfl

theorem assign_tail (s : State) (e : Expr) (w : BitVec 32) (tail : List Stmt) (out : Result)
    (declared : ZType s) (exactValue : ∀ v, GenEval LeafCall s e v → v=.uint32 w)
    (source : GenExec LeafCall (chainOf (.assign "z".toList e::tail)) s out) :
    GenExec LeafCall (chainOf tail) (setZ s w) out :=
  continuation _ _ s (setZ s w) out (fun r h => assign_result s e w r declared exactValue h) source

theorem assign_run (s : State) (e : Expr) (w : BitVec 32)
    (declared : ZType s) (value : GenEval LeafCall s e (.uint32 w)) :
    GenExec LeafCall (.assign "z".toList e) s ⟨setZ s w,.normal⟩ := by
  obtain ⟨old,hd⟩ := declared
  exact .assign _ _ _ _ old _ hd value

theorem return_exact (s : State) (z : BitVec 32) (out : Result) (hz : Slot s "z" z)
    (source : GenExec LeafCall (chainOf [.ret (cell "z")]) s out) :
    out=⟨s,.returned (some (.uint32 z))⟩ := by
  cases source with
  | seqNormal _ _ _ _ _ first _ => cases first
  | seqExit _ _ _ _ first _ =>
      cases first with
      | ret _ _ v evaluated => rw [cell_exact s "z" z v hz evaluated]

theorem return_exists (s : State) (z : BitVec 32) (hz : Slot s "z" z) :
    GenExec LeafCall (chainOf [.ret (cell "z")]) s ⟨s,.returned (some (.uint32 z))⟩ :=
  .seqExit _ _ _ _ (.ret _ _ _ (cell_exists s "z" z hz)) (by intro h; cases h)

theorem finish_exact (s : State) (z p p0i : BitVec 32) (out : Result)
    (hz : Slot s "z" z) (params : Params s p p0i)
    (source : GenExec LeafCall (chainOf finish) s out) :
    out.flow=.returned (some (.uint32 (halve z p))) := by
  have tail := assign_tail s halfExpr (halve z p) _ out (slot_type s z hz)
    (fun v h => half_exact s z p v hz params.1 h) source
  exact congrArg Result.flow (return_exact _ _ out (setZ_slot s (halve z p)) tail)

theorem finish_exists (s : State) (z p p0i : BitVec 32)
    (hz : Slot s "z" z) (params : Params s p p0i) :
    ∃ after, GenExec LeafCall (chainOf finish) s ⟨after,.returned (some (.uint32 (halve z p)))⟩ := by
  refine ⟨setZ s (halve z p),.seqNormal _ _ _ (setZ s (halve z p)) _ ?_ ?_⟩
  · exact assign_run s halfExpr _ (slot_type s z hz) (half_exists s z p hz params.1)
  · exact return_exists _ _ (setZ_slot s (halve z p))

theorem squares_exact (n i : Nat) (s : State) (p p0i : BitVec 32) (out : Result)
    (hz : Slot s "z" (squares p p0i i)) (params : Params s p p0i)
    (source : GenExec LeafCall (chainOf (afterDouble n)) s out) :
    out.flow=.returned (some (.uint32 (halve (squares p p0i (i+n)) p))) := by
  induction n generalizing i s with
  | zero => exact finish_exact s _ p p0i out hz params source
  | succ n ih =>
      change GenExec LeafCall (chainOf (.assign "z".toList montZZ::afterDouble n)) s out at source
      have tail := assign_tail s montZZ (squares p p0i (i+1)) _ out (slot_type s _ hz)
        (fun v h => mont_exact s _ p p0i v hz params h) source
      have he := ih (i+1) _ (setZ_slot s _) (setZ_params s p p0i _ params) tail
      simpa only [Nat.add_assoc,Nat.add_comm 1 n] using he

theorem squares_exists (n i : Nat) (s : State) (p p0i : BitVec 32)
    (hz : Slot s "z" (squares p p0i i)) (params : Params s p p0i) :
    ∃ after, GenExec LeafCall (chainOf (afterDouble n)) s
      ⟨after,.returned (some (.uint32 (halve (squares p p0i (i+n)) p)))⟩ := by
  induction n generalizing i s with
  | zero => exact finish_exists s _ p p0i hz params
  | succ n ih =>
      obtain ⟨after,rest⟩ := ih (i+1) (setZ s (squares p p0i (i+1)))
        (setZ_slot s _) (setZ_params s p p0i _ params)
      refine ⟨after,.seqNormal _ _ _ (setZ s (squares p p0i (i+1))) _ ?_ ?_⟩
      · exact assign_run s montZZ _ (slot_type s _ hz) (mont_exists s _ p p0i hz params)
      · simpa only [afterDouble,HAppend.hAppend,Append.append,Nat.add_assoc,Nat.add_comm 1 n] using rest

def entry (base : State) (p p0i : BitVec 32) : State :=
  bindParams base r2Params [.uint32 p,.uint32 p0i]
def declared (base : State) (p p0i : BitVec 32) : State :=
  C99DeclarationStatements.effect .u32 ["z".toList] (entry base p p0i)

theorem declared_params (base : State) (p p0i : BitVec 32) : Params (declared base p p0i) p p0i := by
  simp [Params,Slot,declared,entry,bindParams,r2Params,C99DeclarationStatements.effect,
    C99DeclarationCells.declareCells,bindValue,C99ScalarReference.set,
    C99IntegerReference.convert,Value.integer,C99ValueBridge.type]

theorem declared_z (base : State) (p p0i : BitVec 32) : ZType (declared base p p0i) :=
  ⟨none,rfl⟩

theorem declaration_result (base : State) (p p0i : BitVec 32) (out : Result)
    (source : GenExec LeafCall (.base (.scalar (.declare .u32 ["z".toList]))) (entry base p p0i) out) :
    out=⟨declared base p p0i,.normal⟩ := by
  cases source with
  | base _ _ after h => rw [C99DeclarationStatements.source_result .u32 _ _ after h]; rfl

theorem body_exact (base : State) (p p0i : BitVec 32) (out : Result)
    (source : GenExec LeafCall r2Code (entry base p p0i) out) :
    out.flow=.returned (some (.uint32 (word p p0i))) := by
  have tail := continuation _ _ _ _ out (declaration_result base p p0i) source
  have tailR := assign_tail (declared base p p0i) rExpr (KeygenModpR.word p) _ out
    (declared_z base p p0i) (fun v h => r_exact _ p v (declared_params base p p0i).1 h) tail
  have paramsR := setZ_params _ p p0i (KeygenModpR.word p) (declared_params base p p0i)
  have tailD := assign_tail _ addExpr (doubled p) _ out (slot_type _ _ (setZ_slot _ _))
    (fun v h => add_exact _ _ p v (setZ_slot _ _) paramsR.1 h) tailR
  exact squares_exact 5 0 _ p p0i out (setZ_slot _ _) (setZ_params _ p p0i _ paramsR) tailD

theorem body_exists (base : State) (p p0i : BitVec 32) :
    ∃ after, GenExec LeafCall r2Code (entry base p p0i)
      ⟨after,.returned (some (.uint32 (word p p0i)))⟩ := by
  have hp := declared_params base p p0i
  have hpR := setZ_params _ p p0i (KeygenModpR.word p) hp
  obtain ⟨after,rest⟩ := squares_exists 5 0
    (setZ (setZ (declared base p p0i) (KeygenModpR.word p)) (doubled p)) p p0i
    (setZ_slot _ _) (setZ_params _ p p0i _ hpR)
  refine ⟨after,.seqNormal _ _ _ (declared base p p0i) _ ?_
    (.seqNormal _ _ _ (setZ (declared base p p0i) (KeygenModpR.word p)) _ ?_
      (.seqNormal _ _ _ _ _ ?_ rest))⟩
  · exact .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 _ _)
  · exact assign_run _ rExpr _ (declared_z base p p0i) (r_exists _ p hp.1)
  · exact assign_run _ addExpr _ (slot_type _ _ (setZ_slot _ _))
      (add_exists _ _ p (setZ_slot _ _) hpR.1)

def SourceExec (p p0i : BitVec 32) (v : Value) : Prop := r2Body [.uint32 p,.uint32 p0i] v

theorem source_exact (p p0i : BitVec 32) (v : Value) (source : SourceExec p p0i v) :
    v=.uint32 (word p p0i) := by
  obtain ⟨base,after,body⟩ := source
  exact Option.some.inj (C99ProcedureReference.Flow.returned.inj (body_exact base p p0i _ body))

theorem source_exists (base : State) (p p0i : BitVec 32) : SourceExec p p0i (.uint32 (word p p0i)) := by
  obtain ⟨after,body⟩ := body_exists base p p0i
  exact ⟨base,after,body⟩

end FT1536.Source3.KeygenModpR2Exec
