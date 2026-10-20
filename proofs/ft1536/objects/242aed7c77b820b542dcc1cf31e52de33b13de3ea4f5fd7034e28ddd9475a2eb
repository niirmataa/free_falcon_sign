import Source3.KeygenPublicUpperProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicUpperAtoms
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer)
open KeygenPublicWord (Eval scalar)
open KeygenPublicExec (Stmt Exec)
open KeygenPublicTableAtoms (var mont)
open KeygenPublicTableStore (Word EvalWord)
open KeygenPublicDivisionAlgebra (Scaled multiply)
open KeygenPublicAlgebra (R)
open KeygenNttLoopSupport (USlot u64)

def Argument (s : State) (e : KeygenWordExpr.Expr) (z : R) : Prop :=
  ∀ v, Eval [] s e v → ∃ w, KeygenPublicArguments.U32 v w ∧ Scaled w z
theorem word_argument (s : State) (e : KeygenWordExpr.Expr) (z : R) (word : EvalWord s e z) : Argument s e z := by
  intro v hv
  obtain ⟨w,equal,scaled⟩ := word v hv
  subst v
  exact ⟨w,KeygenPublicArguments.u32_self w,scaled⟩
theorem load_argument (s : State) (name : String) (index : CLogic.Expr) (p : ArrayPointer) (i : Nat) (z : R)
    (binding : s.arrays name.toList=some p)
    (value : ∀ v, scalar s index v → v.integer.toNat=i) (cell : KeygenPublicTableCells.Cell s.heap p i z) :
    Argument s (.load16 name.toList index) z := by
  intro v source
  obtain ⟨w,read,arg,scaled⟩ := KeygenPublicTableCells.promoted_cell s.heap p i z cell
  cases source with
  | load16 _ _ actual word address loaded =>
      rw [KeygenPublicTableIndex.address s name index p actual i binding value address] at loaded
      have equal := C99NarrowReads.load16_deterministic s.heap _ word w loaded read
      subst word
      exact ⟨_,arg,scaled⟩
theorem mont_arguments (s : State) (a b : KeygenWordExpr.Expr) (x y : R)
    (left : Argument s a x) (right : Argument s b y) : EvalWord s (mont a b) (x*y) := by
  intro v source
  cases source with
  | call4 _ _ _ _ _ av bv qv iv _ first second third fourth invoked =>
      obtain ⟨aw,ae,as⟩ := left av first
      obtain ⟨bw,be,bs⟩ := right bv second
      have qe := KeygenPublicTableAtoms.literal_value [] s 18433 qv third
      have ie := KeygenPublicTableAtoms.literal_value [] s 18431 iv fourth
      subst qv; subst iv
      exact ⟨multiply aw bw,KeygenPublicArguments.source_mul_exact aw bw _ _ _ _ v ae be
        (KeygenPublicArguments.u32_literal 18433) (KeygenPublicArguments.u32_literal 18431) invoked,
        KeygenPublicDivisionAlgebra.scaled_product aw bw x y as bs⟩
theorem assign_argument (s : State) (out : Result) (name : String) (e : KeygenWordExpr.Expr) (z : R)
    (declared : ∃ old, s.locals name.toList=some (.uint32,old)) (value : Argument s e z)
    (source : Exec KeygenPublicSource.program [] (.assign name.toList e) s out) : Word out.state name z := by
  obtain ⟨old,bound⟩ := declared
  cases source with
  | assign _ _ _ ty previous v slot evaluated =>
      have te := congrArg Prod.fst (Option.some.inj (slot.symm.trans bound))
      dsimp only at te
      subst ty
      obtain ⟨w,converted,scaled⟩ := value v evaluated
      refine ⟨w,?_,scaled⟩
      simp only [KeygenPublicTableAtoms.Slot,C99ArrayReference.bindValue,C99ScalarReference.set,ite_true]
      exact congrArg (fun v => some (C99IntegerReference.Ty.uint32,some v)) converted
theorem index_value (s : State) (name : String) (i : Nat) (hi : i<2^64)
    (counter : USlot s name i) :
    ∀ v, scalar s (KeygenPublicLastProgram.scalarVar name) v → v.integer.toNat=i := by
  intro v source
  rw [KeygenPublicTableIndex.variable64 s name i v counter source,KeygenNttLoopSupport.u64_toNat i hi]
theorem double_value (s : State) (i : Nat) (hi : i<1024) (counter : USlot s "u" i) :
    ∀ v, scalar s KeygenPublicUpperProgram.doubleU v → v.integer.toNat=2*i := by
  intro v source
  cases source with
  | shift _ _ _ a b _ left right op =>
      have av := KeygenPublicTableIndex.variable64 s "u" i a counter left
      have bv := KeygenPublicTableIndex.literal s 1 b right
      subst a; subst b
      rw [KeygenNttLoopSupport.shl_one_u64 i (by omega) v op,KeygenNttLoopSupport.u64_toNat _ (by omega)]
      omega
theorem stored_word (s : State) (out : Result) (name : String) (index : CLogic.Expr)
    (e : KeygenWordExpr.Expr) (p : ArrayPointer) (i : Nat) (z : R)
    (binding : s.arrays name.toList=some p) (value : ∀ v, scalar s index v → v.integer.toNat=i)
    (word : EvalWord s e z)
    (source : Exec KeygenPublicSource.program [] (.store name.toList index true e) s out) :
    ∃ w, Scaled w z ∧ KeygenSmallOutput.Store16 s.heap (KeygenSmallOutput.element p i)
      (KeygenPublicWord.narrow (.uint32 w)) out.state.heap := by
  cases source with
  | store _ _ _ _ before heap actual v address evaluated write =>
      rw [KeygenPublicTableIndex.address s name index p actual i binding value address] at write
      obtain ⟨w,ve,scaled⟩ := word v evaluated
      subst v
      exact ⟨w,scaled,write⟩
theorem declaration_heap (ty : B20.C.Ty) (names : List C99ArrayReference.Name) (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program [] (.scalar (.declare ty names)) s out) : out.state.heap=s.heap := by
  cases source
  rfl
theorem declared_member (ty : B20.C.Ty) (names : List C99ArrayReference.Name) (s : State) (out : Result)
    (name : C99ArrayReference.Name) (member : name∈names)
    (source : Exec KeygenPublicSource.program [] (.scalar (.declare ty names)) s out) :
    out.state.locals name=some (C99ValueBridge.type ty,none) := by
  rw [KeygenPublicTableAtoms.declaration_result _ _ s ty names out source]
  exact KeygenPublicTableRows.declaration_member _ _ _ _ member
theorem local_frame (names : List C99ArrayReference.Name) (code : Stmt) (s : State) (out : Result)
    (ok : KeygenPublicTableControl.supported code=true)
    (limited : KeygenPublicTableControl.writes code ⊆ names)
    (source : Exec KeygenPublicSource.program [] (.scope names [] code) s out) :
    out.flow=.normal ∧ out.state.locals=s.locals ∧ out.state.arrays=s.arrays := by
  cases source with
  | scope _ _ _ _ inner executed =>
      have frame := KeygenPublicTableControl.frame _ _ code s inner ok executed
      refine ⟨frame.1,?_,frame.2.1⟩
      funext n
      change (if names.contains n then s.locals n else inner.state.locals n)=s.locals n
      split_ifs with h
      · rfl
      · exact frame.2.2 n (fun hn => h (List.contains_iff_mem.mpr (limited hn)))

end FT1536.Source3.KeygenPublicUpperAtoms
