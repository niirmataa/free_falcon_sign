import Source3.KeygenMkgm3Table
import Source3.KeygenNttButterflyCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMkgm3Atoms
open C99ModularReference (Expr Stmt Exec Eval)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenMkgm3Program (cell mont)
open KeygenNttButterflyCalls (U32Slot U32Declared)
open KeygenMkgm3Rows (Scaled)

def Params (s : State) (p0i : BitVec 32) : Prop :=
  U32Slot s "p" KeygenNinv31.prime ∧ U32Slot s "p0i" p0i
def Word (s : State) (name : String) (e : Nat) : Prop :=
  ∃ w, U32Slot s name w ∧ Scaled e w
def EvalWord (s : State) (expr : Expr) (e : Nat) : Prop :=
  ∀ v, Eval s expr v → ∃ w, v=.uint32 w ∧ Scaled e w

theorem params_transport (code : Stmt) (before : State) (out : Result) (p0i : BitVec 32)
    (support : KeygenMkgm3Control.supported code=true)
    (pkeep : "p".toList∉KeygenMkgm3Control.writes code)
    (ikeep : "p0i".toList∉KeygenMkgm3Control.writes code)
    (params : Params before p0i) (source : Exec code before out) : Params out.state p0i := by
  have h := (KeygenMkgm3Control.frame code before out support source).2.2
  exact ⟨(h _ pkeep).trans params.1,(h _ ikeep).trans params.2⟩

theorem word_transport (code : Stmt) (before : State) (out : Result) (name : String) (e : Nat)
    (support : KeygenMkgm3Control.supported code=true)
    (keep : name.toList∉KeygenMkgm3Control.writes code)
    (word : Word before name e) (source : Exec code before out) : Word out.state name e := by
  obtain ⟨w,slot,law⟩ := word
  exact ⟨w,((KeygenMkgm3Control.frame code before out support source).2.2 _ keep).trans slot,law⟩

theorem cell_word (s : State) (name : String) (e : Nat) (h : Word s name e) : EvalWord s (cell name) e := by
  obtain ⟨w,slot,law⟩ := h
  intro v source
  exact ⟨w,KeygenNttButterflyCalls.variable_u32 s name w v slot
    (KeygenNttForwardExec.eval_scalar s _ v source),law⟩

theorem mont_word (s : State) (p0i : BitVec 32) (left right : Expr) (a b : Nat)
    (params : Params s p0i)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (hl : EvalWord s left a) (hr : EvalWord s right b) : EvalWord s (mont left right) (a+b) := by
  intro v source
  cases source with
  | call4 nm e1 e2 e3 e4 x y p inv out first second third fourth called =>
      obtain ⟨xw,hx,lx⟩ := hl x first
      obtain ⟨yw,hy,ly⟩ := hr y second
      have hp := KeygenNttButterflyCalls.variable_u32 s "p" KeygenNinv31.prime p params.1
        (KeygenNttForwardExec.eval_scalar s _ p third)
      have hi := KeygenNttButterflyCalls.variable_u32 s "p0i" p0i inv params.2
        (KeygenNttForwardExec.eval_scalar s _ inv fourth)
      subst x; subst y; subst p; subst inv
      have body := KeygenNttButterflyCalls.mont_inv called
      have he := KeygenModpWord.source_exact xw yw KeygenNinv31.prime p0i v body
      rw [he] at body
      exact ⟨_,he,KeygenMkgm3Rows.scaled_product xw yw _ p0i a b initialization lx ly body⟩

theorem assign_word (s : State) (out : Result) (name : String) (expr : Expr) (e : Nat)
    (declared : U32Declared s name) (value : EvalWord s expr e)
    (source : Exec (.assign name.toList expr) s out) :
    Word out.state name e ∧ out.state.heap=s.heap := by
  obtain ⟨old,hd⟩ := declared
  cases source with
  | assign name expr before ty previous v has evaluated =>
      have ht := congrArg Prod.fst (Option.some.inj (has.symm.trans hd))
      change ty=Ty.uint32 at ht
      subst ty
      obtain ⟨w,hv,law⟩ := value v evaluated
      subst v
      refine ⟨⟨w,?_,law⟩,rfl⟩
      simp [U32Slot,C99ArrayReference.bindValue,C99ScalarReference.set,KeygenNttButterflyCalls.convert_u32]

theorem word_declared (s : State) (name : String) (e : Nat) (h : Word s name e) : U32Declared s name := by
  obtain ⟨w,slot,_⟩ := h
  exact ⟨some (.uint32 w),slot⟩

theorem assign_heap (s : State) (out : Result) (name : C99ArrayReference.Name) (e : Expr)
    (source : Exec (.assign name e) s out) : out.state.heap=s.heap := by
  cases source
  rfl

def pure : Stmt → Bool
  | .base .skip | .base (.scalar _) | .assign _ _ => true
  | .seq a b | .branch _ a b | .loop _ a b => pure a && pure b
  | .scope _ body => pure body
  | _ => false

theorem pure_heap (code : Stmt) (s : State) (out : Result) (hp : pure code=true)
    (source : Exec code s out) : out.state.heap=s.heap := by
  induction source with
  | base code before after source =>
      cases source with
      | skip | scalar => rfl
      | assign | declarePtr | bindPtr | store64 | store32 | copy | seq | scope
      | branchTrue | branchFalse | whileFalse | whileTrue | call => cases hp
  | assign => rfl
  | store32 | storeRev | ret | retVoid => cases hp
  | seqNormal first second before middle result head tail ih1 ih2 =>
      exact (ih2 (Bool.and_eq_true_iff.mp hp).2).trans (ih1 (Bool.and_eq_true_iff.mp hp).1)
  | seqExit first second before result head exit ih => exact ih (Bool.and_eq_true_iff.mp hp).1
  | scope names body before result inner ih => exact ih hp
  | branchTrue condition yes no before result v guard nonzero body ih => exact ih (Bool.and_eq_true_iff.mp hp).1
  | branchFalse condition yes no before result v guard zero body ih => exact ih (Bool.and_eq_true_iff.mp hp).2
  | loopFalse => rfl
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact (ih3 hp).trans ((ih2 (Bool.and_eq_true_iff.mp hp).2).trans (ih1 (Bool.and_eq_true_iff.mp hp).1))
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      exact ih (Bool.and_eq_true_iff.mp hp).1

theorem pointer_index (s : State) (name : String) (index : CLogic.Expr)
    (root p : C99MemoryReference.ArrayPointer) (i : Nat)
    (binding : s.arrays name.toList=some root)
    (value : ∀ v, C99ArrayReference.scalar s index v → v.integer.toNat=i)
    (source : C99ArrayReference.Pointer s name.toList index p) : p=KeygenSmallOutput.element root i := by
  obtain ⟨v,ev,hp⟩ := KeygenNttLoopSupport.pointer_root s name.toList index root p binding source
  rw [hp,value v ev]
  rfl

theorem u_index (s : State) (name : String) (i : Nat) (hi : i<2^64)
    (slot : KeygenNttLoopSupport.USlot s name i) :
    ∀ v, C99ArrayReference.scalar s (.var name.toList) v → v.integer.toNat=i := by
  intro v h
  rw [KeygenNttLoopSupport.variable_u64 s name i v slot h,KeygenNttLoopSupport.u64_toNat i hi]

theorem literal_index (s : State) (i : Nat) (hi : i<2^31) :
    ∀ v, C99ArrayReference.scalar s (KeygenMkgm3Program.num i) v → v.integer.toNat=i := by
  intro v h
  rw [KeygenNttLoopSupport.literal_i32 s i v h]
  have he : (BitVec.ofInt 32 (i : Int)).toInt=(i : Int) := by
    exact BitVec.toInt_ofInt_eq_self (by decide) (by norm_num) (by norm_num; omega)
  change Int.toNat (BitVec.ofInt 32 (i : Int)).toInt=i
  rw [he]
  rfl

theorem load_word (s : State) (name : String) (index : CLogic.Expr)
    (gm : C99MemoryReference.ArrayPointer) (i e : Nat)
    (binding : s.arrays name.toList=some gm)
    (value : ∀ v, C99ArrayReference.scalar s index v → v.integer.toNat=i)
    (read : ∃ w, C99MemoryReference.Load32 s.heap (KeygenSmallOutput.element gm i) w ∧ Scaled e w) :
    EvalWord s (KeygenMkgm3Program.load name index) e := by
  intro v source
  obtain ⟨w,loaded,scaled⟩ := read
  cases source with
  | load32 _ _ p actual address load =>
      rw [pointer_index s name index gm p i binding value address] at load
      have he := Gate00Memory.load32_deterministic s.heap _ actual w load loaded
      subst actual
      exact ⟨w,rfl,scaled⟩

theorem store_word (s : State) (out : Result) (name : String) (index : CLogic.Expr)
    (expr : Expr) (gm : C99MemoryReference.ArrayPointer) (i e : Nat)
    (binding : s.arrays name.toList=some gm)
    (value : ∀ v, C99ArrayReference.scalar s index v → v.integer.toNat=i)
    (scaled : EvalWord s expr e) (source : Exec (.store32 name.toList index expr) s out) :
    ∃ w, C99MemoryReference.Store32 s.heap (KeygenSmallOutput.element gm i) w out.state.heap ∧ Scaled e w := by
  cases source with
  | store32 _ _ _ before after p v address evaluated write =>
      rw [pointer_index s name index gm p i binding value address] at write
      obtain ⟨w,hv,law⟩ := scaled v evaluated
      subst v
      rw [KeygenNttButterflyCalls.ofInt_u32] at write
      exact ⟨w,write,law⟩

end FT1536.Source3.KeygenMkgm3Atoms
