import Source3.KeygenPublicUpperLoops

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The exceptional finish of mq_mkgm3 (source 881-884): the gm[0] copy, the
   w read and the exceptional igm[0] division. Its stored word is
   radix/(2*firstRoot-1), NOT radix/firstRoot; the naive continuation
   (root^-1)^tableExponent 0 is proved different. With both upper loops this
   yields the complete BOTH table images and the caller-visible frames. -/
namespace FT1536.Source3.KeygenPublicUpperFinish
open C99ArrayReference (State bindValue)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer Memory)
open KeygenPublicExec (Exec chain)
open KeygenPublicTableAtoms (Slot var literal mont divide)
open KeygenPublicTableControl (seq_inv)
open KeygenPublicTableStore (Pointers Separate Word)
open KeygenPublicTableCells (Cell)
open KeygenPublicUpperBody (PairCell)
open KeygenPublicUpperFrames (UpperFrame)
open KeygenPublicUpperLoops (PairCells Common)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicRoots (root firstRoot)
open KeygenMkgm3Indices (tableExponent)
open KeygenPublicAlgebra (R value Canonical radix)
open KeygenPublicMontgomery (modulus)
open KeygenPublicDivisionAlgebra (Scaled)

def clit (n : Nat) : CLogic.Expr := .literal .i32 n
def gStore : KeygenPublicExec.Stmt :=
  .store "gm".toList (clit 0) false (.load16 "gm".toList (clit 1))
def wSet : KeygenPublicExec.Stmt := .assign "w".toList (.load16 "gm".toList (clit 1))
def addExpr : KeygenWordExpr.Expr :=
  .call3 (KeygenPublicScalar.name .add) (var "w") (var "w") (literal 18433)
def subExpr : KeygenWordExpr.Expr :=
  .call3 (KeygenPublicScalar.name .sub) addExpr (literal 10237) (literal 18433)
def iStore : KeygenPublicExec.Stmt :=
  .store "igm".toList (clit 0) true (divide (literal 4564) subExpr)
theorem source_finish : KeygenPublicUpperProgram.finish=chain [gStore,wSet,iStore] := by decide

theorem index_zero (s : State) :
    ∀ v, KeygenPublicWord.scalar s (clit 0) v → v.integer.toNat=0 := by
  intro v source
  have equal := KeygenPublicTableIndex.literal s 0 v source
  rw [equal]
  rfl
theorem index_one (s : State) :
    ∀ v, KeygenPublicWord.scalar s (clit 1) v → v.integer.toNat=1 := by
  intro v source
  have equal := KeygenPublicTableIndex.literal s 1 v source
  rw [equal]
  rfl
theorem load_two (s : State) (name : String) (p : ArrayPointer) (z : R) (v : Value)
    (binding : s.arrays name.toList=some p) (cell : Cell s.heap p 1 z)
    (source : KeygenPublicWord.Eval [] s (.load16 name.toList (clit 1)) v) :
    ∃ w : BitVec 16, v=C99NarrowReads.unsignedPromotion w ∧
      Scaled (BitVec.ofNat 32 w.toNat) z := by
  obtain ⟨w,read,arg,scaled⟩ := KeygenPublicTableCells.promoted_cell s.heap p 1 z cell
  cases source with
  | load16 _ _ actual word address loaded =>
      rw [KeygenPublicTableIndex.address s name (clit 1) p actual 1 binding
        (index_one s) address] at loaded
      have equal := C99NarrowReads.load16_deterministic s.heap _ word w loaded read
      subst word
      exact ⟨w,rfl,scaled⟩

/- Word-level normalization of the three fixed scalar calls. -/
theorem add_normal (p : BitVec 32) (av bv qv v : Value)
    (ax : KeygenPublicArguments.U32 av p) (bq : KeygenPublicArguments.U32 bv p)
    (qm : KeygenPublicArguments.U32 qv modulus)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .add) [av,bv,qv] v) :
    KeygenPublicScalar.Call (KeygenPublicScalar.name .add) [.uint32 p,.uint32 p,.uint32 modulus] v :=
  KeygenPublicArguments.call_leaf_conversion .add (by decide) [av,bv,qv]
    [.uint32 p,.uint32 p,.uint32 modulus] v
    (.cons _ _ _ _ _ _ _ (ax.trans (KeygenPublicArguments.u32_self p).symm)
      (.cons _ _ _ _ _ _ _ (bq.trans (KeygenPublicArguments.u32_self p).symm)
        (.cons _ _ _ _ _ _ _ (qm.trans (KeygenPublicArguments.u32_self modulus).symm) .nil))) source
theorem sub_normal (x y : BitVec 32) (av bv qv v : Value)
    (ax : KeygenPublicArguments.U32 av x) (bq : KeygenPublicArguments.U32 bv y)
    (qm : KeygenPublicArguments.U32 qv modulus)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .sub) [av,bv,qv] v) :
    KeygenPublicScalar.Call (KeygenPublicScalar.name .sub) [.uint32 x,.uint32 y,.uint32 modulus] v :=
  KeygenPublicArguments.call_leaf_conversion .sub (by decide) [av,bv,qv]
    [.uint32 x,.uint32 y,.uint32 modulus] v
    (.cons _ _ _ _ _ _ _ (ax.trans (KeygenPublicArguments.u32_self x).symm)
      (.cons _ _ _ _ _ _ _ (bq.trans (KeygenPublicArguments.u32_self y).symm)
        (.cons _ _ _ _ _ _ _ (qm.trans (KeygenPublicArguments.u32_self modulus).symm) .nil))) source

theorem add_word (p : BitVec 32) (av bv qv v : Value)
    (ax : KeygenPublicArguments.U32 av p) (bq : KeygenPublicArguments.U32 bv p)
    (qm : KeygenPublicArguments.U32 qv modulus)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .add) [av,bv,qv] v) :
    v=.uint32 (KeygenModpAddSub.result .add p p modulus) :=
  KeygenPublicLeafWords.source_add _ p p modulus v
    (KeygenPublicAlgebra.call_leaf .add (by decide) _ _ (add_normal p av bv qv v ax bq qm source))
theorem sub_word (x y : BitVec 32) (av bv qv v : Value)
    (ax : KeygenPublicArguments.U32 av x) (bq : KeygenPublicArguments.U32 bv y)
    (qm : KeygenPublicArguments.U32 qv modulus)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .sub) [av,bv,qv] v) :
    v=.uint32 (KeygenModpAddSub.result .sub x y modulus) :=
  KeygenPublicLeafWords.source_sub _ x y modulus v
    (KeygenPublicAlgebra.call_leaf .sub (by decide) _ _ (sub_normal x y av bv qv v ax bq qm source))
theorem div_word (x y : BitVec 32) (av bv v : Value)
    (ax : KeygenPublicArguments.U32 av x) (bq : KeygenPublicArguments.U32 bv y)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .divT) [av,bv] v) :
    v=.uint32 (KeygenPublicDivisionWords.division x y) :=
  KeygenPublicDivisionWords.source_exact x y v
    (KeygenPublicDivisionAlgebra.normalize_call x y av bv v ax bq source)

/- Field algebra of the exceptional word. -/
theorem te_zero : tableExponent 0=768 := by decide
theorem te_one : tableExponent 1=768 := by decide
theorem two_first_root_nonzero : (2*firstRoot-1 : R)≠0 := by decide
theorem exceptional : ((2*firstRoot-1)⁻¹ : R)≠(root⁻¹)^tableExponent 0 := by
  rw [te_zero,inv_pow]
  intro equal
  have inject := inv_injective equal
  have h : (2*firstRoot-1 : R)=firstRoot := by rw [inject]; rfl
  have one : (firstRoot : R)=1 := by linear_combination h
  have rel := KeygenPublicRoots.first_root_relation
  rw [one] at rel
  simp at rel

theorem add_field (p : BitVec 32) (av bv qv v : Value) (x : R)
    (hp : Canonical p) (scaled : value p=radix*x)
    (ax : KeygenPublicArguments.U32 av p) (bq : KeygenPublicArguments.U32 bv p)
    (qm : KeygenPublicArguments.U32 qv modulus)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .add) [av,bv,qv] v) :
    Canonical (KeygenModpAddSub.result .add p p modulus) ∧
      value (KeygenModpAddSub.result .add p p modulus)=radix*(x+x) := by
  have normalized := add_normal p av bv qv v ax bq qm source
  rw [add_word p av bv qv v ax bq qm source] at normalized
  have law := KeygenPublicAlgebra.source_add p p _ hp hp normalized
  refine ⟨law.1,?_⟩
  rw [law.2,scaled,mul_add]

theorem sub_field (x y : BitVec 32) (av bv qv v : Value) (a b : R)
    (hx : Canonical x) (hy : Canonical y) (left : value x=radix*a) (right : value y=radix*b)
    (ax : KeygenPublicArguments.U32 av x) (bq : KeygenPublicArguments.U32 bv y)
    (qm : KeygenPublicArguments.U32 qv modulus)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .sub) [av,bv,qv] v) :
    Canonical (KeygenModpAddSub.result .sub x y modulus) ∧
      value (KeygenModpAddSub.result .sub x y modulus)=radix*(a-b) := by
  have normalized := sub_normal x y av bv qv v ax bq qm source
  rw [sub_word x y av bv qv v ax bq qm source] at normalized
  have law := KeygenPublicAlgebra.source_sub x y _ hx hy normalized
  refine ⟨law.1,?_⟩
  rw [law.2,left,right,mul_sub]

theorem division_scaled (x y : BitVec 32) (a b : R)
    (hx : Canonical x) (hy : Canonical y) (left : value x=radix^2*a) (right : value y=radix*b)
    (nonzero : y.toNat≠0) (bnonzero : b≠0) :
    Canonical (KeygenPublicDivisionWords.division x y) ∧
      value (KeygenPublicDivisionWords.division x y)=radix*(a*b⁻¹) := by
  have power := KeygenPublicDivisionAlgebra.division_power x y hx hy
  have nz : value y≠0 := KeygenPublicDivisionAlgebra.nonzero_value y hy nonzero
  have fermat : value y^18432=1 := ZMod.pow_card_sub_one_eq_one nz
  have product : value y^18431*value y=1 := by
    rw [← pow_succ,fermat]
  have inv : value y^18431=(value y)⁻¹ := eq_inv_of_mul_eq_one_left product
  have rinv := KeygenPublicAlgebra.radix_inverse
  have split : (radix*b : R)⁻¹=radix⁻¹*b⁻¹ := by
    have check : (radix*b)*(radix⁻¹*b⁻¹)=1 := by
      have rearranged : (radix*b)*(radix⁻¹*b⁻¹)=(radix*radix⁻¹)*(b*b⁻¹) := by ring
      rw [rearranged,rinv,mul_inv_cancel₀ bnonzero,mul_one]
    exact (eq_inv_of_mul_eq_one_right check).symm
  refine ⟨power.1,?_⟩
  calc
    value (KeygenPublicDivisionWords.division x y) = value x*(value y)⁻¹ := by rw [power.2,inv]
    _ = radix^2*a*(radix*b)⁻¹ := by rw [left,right]
    _ = radix^2*a*(radix⁻¹*b⁻¹) := by rw [split]
    _ = (radix*(radix*radix⁻¹))*(a*b⁻¹) := by ring
    _ = (radix*1)*(a*b⁻¹) := by rw [rinv]
    _ = radix*(a*b⁻¹) := by ring

end FT1536.Source3.KeygenPublicUpperFinish
