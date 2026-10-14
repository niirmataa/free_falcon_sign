import Source3.KeygenPublicWord095

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicRename095
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open C99MemoryReference
open C99ProcedureReference (Result)
open C99BlockRename090
open C99ModularRename093 (result)

theorem address (r : Renaming) (s : State) (name : Name) (index : CLogic.Expr) (p : ArrayPointer)
    (source : KeygenPublicWord.Address s name index p) : KeygenPublicWord.Address (state r s) name index (ptr r p) := by
  cases source with
  | add root p value binding evaluated nonnegative within =>
      exact .add name index (ptr r root) (ptr r p) value
        (by simp only [state, binding, Option.map_some]) evaluated nonnegative (pointer_add r root p _ within)

theorem expression (r : Renaming) (signed : List Name) (s : State) (e : KeygenWordExpr.Expr) (v : Value)
    (source : KeygenPublicWord.Eval signed s e v) : KeygenPublicWord.Eval signed (state r s) e v := by
  induction source with
  | scalar e v source => exact .scalar e v source
  | load16 name index p word addressed read =>
      exact .load16 name index (ptr r p) word (address r s name index p addressed)
        (C99ArrayRename093.load16 r s.heap p word read)
  | cast ty e v source ih => exact .cast ty e v ih
  | neg e v z source op ih => exact .neg e v z ih op
  | bitNot e v z source op ih => exact .bitNot e v z ih op
  | lnot e v source ih => exact .lnot e v ih
  | bin op a b x y z left right operation ih1 ih2 => exact .bin op a b x y z ih1 ih2 operation
  | cmp op a b x y z left right operation ih1 ih2 => exact .cmp op a b x y z ih1 ih2 operation
  | andFalse a b x left zero ih => exact .andFalse a b x ih zero
  | andTrue a b x y left nonzero right ih1 ih2 => exact .andTrue a b x y ih1 nonzero ih2
  | orTrue a b x left nonzero ih => exact .orTrue a b x ih nonzero
  | orFalse a b x y left zero right ih1 ih2 => exact .orFalse a b x y ih1 zero ih2
  | call1 name a x out first source ih => exact .call1 name a x out ih source
  | call2 name a b x y out first second source ih1 ih2 => exact .call2 name a b x y out ih1 ih2 source
  | call3 name a b c x y z out first second third source ih1 ih2 ih3 => exact .call3 name a b c x y z out ih1 ih2 ih3 source
  | call4 name a b c d x y z t out first second third fourth source ih1 ih2 ih3 ih4 =>
      exact .call4 name a b c d x y z t out ih1 ih2 ih3 ih4 source

theorem parameters (r : Renaming) (caller : State) (params : List C99ArrayReference.Param)
    (args : List C99ArrayReference.Arg) (out : State) (source : KeygenPublicWord.Bind caller params args out) :
    KeygenPublicWord.Bind (state r caller) params args (state r out) := by
  induction source with
  | nil => exact .nil
  | scalar ty name e ps args out v value rest ih =>
      rw [C99StateRename090.bindValue]
      exact .scalar ty name e ps args _ v value ih
  | pointer name src index p ps args out value rest ih =>
      rw [C99StateRename090.bindPointer]
      exact .pointer name src index (ptr r p) ps args _ (address r caller src index p value) ih

theorem store16 (r : Renaming) (before after : Memory) (p : ArrayPointer) (w : BitVec 16)
    (source : KeygenSmallOutput.Store16 before p w after) : KeygenSmallOutput.Store16 (heap r before) (ptr r p) w (heap r after) := by
  obtain ⟨legal, width, writable, sizes, permissions, bytes, frame⟩ := source
  have writes := byte_write r before after p 2 (KeygenSmallOutput.byte16 w) ⟨sizes, permissions, bytes, frame⟩
  exact ⟨C99BlockRename090.allocated r before p legal, width,
    by simpa only [ptr, heap, Equiv.symm_apply_apply] using writable,
    writes.sizes, writes.writable, writes.bytes, writes.frame⟩

theorem allocation (r : Renaming) (before : Memory) (block count : Nat) :
    heap r (KeygenPublicExec.allocated before block count) = KeygenPublicExec.allocated (heap r before) (r block) count := by
  apply RngTemporarySwap090.memory_ext
  · funext b o; simp only [heap, KeygenPublicExec.allocated, RngTemporarySwap090.preimage_eq]
  · funext b; simp only [heap, KeygenPublicExec.allocated, RngTemporarySwap090.preimage_eq]
  · funext b; simp only [heap, KeygenPublicExec.allocated, RngTemporarySwap090.preimage_eq]

theorem entering (r : Renaming) (before : State) (name : Name) (block count : Nat) :
    state r (KeygenPublicExec.localEntry before name block count) = KeygenPublicExec.localEntry (state r before) name (r block) count := by
  unfold KeygenPublicExec.localEntry
  rw [C99StateRename090.bindPointer]
  change C99ArrayReference.bindPointer {state r before with heap := heap r (KeygenPublicExec.allocated before.heap block count)}
    name (ptr r (KeygenPublicExec.localPointer block count)) = _
  rw [allocation]
  rfl

theorem exiting (r : Renaming) (before after : State) (name : Name) (block : Nat) :
    state r (KeygenPublicExec.localExit before after name block) =
      KeygenPublicExec.localExit (state r before) (state r after) name (r block) := by
  unfold KeygenPublicExec.localExit
  rw [C99StateRename090.restoreScope]
  change C99ArrayReference.restoreScope (state r before)
    {state r after with heap := heap r (KeygenRngSource.disposed before.heap after.heap block)} [] [name] = _
  rw [RngTemporarySwap090.disposal_rename]
  rfl

theorem fresh (r : Renaming) (before : Memory) (block : Nat) (source : KeygenRngSource.Fresh before block) :
    KeygenRngSource.Fresh (heap r before) (r block) := by
  simpa only [KeygenRngSource.Fresh, size_at, writable_at, bytes_at] using source

theorem execution (r : Renaming) (program : KeygenPublicExec.Program) (signed : List Name)
    (code : KeygenPublicExec.Stmt) (before : State) (out : Result)
    (source : KeygenPublicExec.Exec program signed code before out) :
    KeygenPublicExec.Exec program signed code (state r before) (result r out) := by
  induction source with
  | skip => exact .skip _
  | scalar code before env source => exact .scalar code _ env source
  | assign name e before ty old v declared source => exact .assign name e _ ty old v declared (expression r _ before e v source)
  | declarePointer name before =>
      change KeygenPublicExec.Exec program _ (.declarePointer name) (state r before)
        ⟨state r {before with arrays := fun n => if n = name then none else before.arrays n}, .normal⟩
      rw [C99StateRename090.declarePointer]
      exact .declarePointer name _
  | pointer dst src index before p source =>
      change KeygenPublicExec.Exec program _ (.pointer dst src index) (state r before)
        ⟨state r (C99ArrayReference.bindPointer before dst p), .normal⟩
      rw [C99StateRename090.bindPointer]
      exact .pointer dst src index _ (ptr r p) (address r before src index p source)
  | store name index cast e before after p v addressed value write =>
      exact .store name index cast e _ (heap r after) (ptr r p) v
        (address r before name index p addressed) (expression r _ before e v value) (store16 r before.heap after p _ write)
  | call name args f before entry out lookup binding source returned ih =>
      exact .call name args f _ _ _ lookup (parameters r before f.params args entry binding) ih returned
  | seqNormal a b before middle out head tail ih1 ih2 => exact .seqNormal a b _ _ _ ih1 ih2
  | seqExit a b before out head exit ih => exact .seqExit a b _ _ ih exit
  | scope locals pointers body before out source ih =>
      change KeygenPublicExec.Exec program _ (.scope locals pointers body) (state r before)
        ⟨state r (C99ArrayReference.restoreScope before out.state locals pointers), out.flow⟩
      rw [C99StateRename090.restoreScope]
      exact .scope locals pointers body _ _ ih
  | arrayScope name count code before out block positive size isFresh source ih =>
      rw [entering] at ih
      change KeygenPublicExec.Exec program _ (.arrayScope name count code) (state r before)
        ⟨state r (KeygenPublicExec.localExit before out.state name block), out.flow⟩
      rw [exiting]
      exact .arrayScope name count code _ _ (r block) positive size (fresh r before.heap block isFresh) ih
  | branchTrue c yes no before out v guard nonzero body ih => exact .branchTrue c yes no _ _ v (expression r _ before c v guard) nonzero ih
  | branchFalse c yes no before out v guard zero body ih => exact .branchFalse c yes no _ _ v (expression r _ before c v guard) zero ih
  | loopFalse c body increment before v guard zero => exact .loopFalse c body increment _ v (expression r _ before c v guard) zero
  | loopNormal c body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact .loopNormal c body increment _ _ _ _ v (expression r _ before c v guard) nonzero ih1 ih2 ih3
  | loopReturn c body increment before after v ret guard nonzero iteration ih =>
      exact .loopReturn c body increment _ _ v ret (expression r _ before c v guard) nonzero ih
  | ret e before v value => exact .ret e _ v (expression r _ before e v value)
  | retVoid => exact .retVoid _

end FT1536.Source3.KeygenPublicRename095
