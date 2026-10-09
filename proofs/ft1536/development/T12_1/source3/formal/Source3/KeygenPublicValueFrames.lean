import Source3.KeygenPublicSizeOps

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Frame the generated table through the actual a-only passes, without a
   table immutability premise: gm is a writable automatic object. -/
namespace FT1536.Source3.KeygenPublicValueFrames
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicForwardMemory (Block block_refl block_trans)
open KeygenPublicTableControl (supported frame)
open KeygenPublicFirstTables (Table)

def onlyA : Stmt → Bool
  | .store name _ _ _ => name=="a".toList
  | .seq a b | .branch _ a b | .loop _ a b => onlyA a && onlyA b
  | .scope _ _ b => onlyA b
  | _ => true

theorem other_block (program : KeygenPublicExec.Program) (signed : List Name)
    (code : Stmt) (s : State) (out : Result) (ok : supported code=true) (only : onlyA code=true)
    (a : ArrayPointer) (block : Nat) (separate : a.block≠block)
    (pointer : s.arrays "a".toList=some a) (source : Exec program signed code s out) :
    Block s.heap out.state.heap block := by
  induction source with
  | skip | scalar | assign | loopFalse => exact block_refl _ _
  | store name index cast e before heap p v address value write =>
      have nameEq : name="a".toList := by simpa only [onlyA,beq_iff_eq] using only
      subst name
      have outside : p.block≠block := by
        cases address with
        | add root actual i bound evaluated nonnegative within =>
            have eq := Option.some.inj (bound.symm.trans pointer)
            subst root
            cases within
            exact separate
      exact ⟨congrFun write.2.2.2.1 block,
        fun offset => write.2.2.2.2.2.2 block offset (Or.inl (Ne.symm outside))⟩
  | seqNormal aCode bCode before middle result first second ih1 ih2 =>
      obtain ⟨oa,ob⟩ := Bool.and_eq_true_iff.mp ok
      obtain ⟨wa,wb⟩ := Bool.and_eq_true_iff.mp only
      have p : middle.arrays "a".toList=some a := by rw [(frame _ _ _ _ _ oa first).2.1]; exact pointer
      exact block_trans _ _ _ block (ih1 oa wa pointer) (ih2 ob wb p)
  | seqExit _ _ _ _ first exit ih =>
      exact ih (Bool.and_eq_true_iff.mp ok).1 (Bool.and_eq_true_iff.mp only).1 pointer
  | scope names pointers body before result inner ih =>
      cases pointers with
      | nil => exact ih ok only pointer
      | cons => cases ok
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp ok).1 (Bool.and_eq_true_iff.mp only).1 pointer
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp ok).2 (Bool.and_eq_true_iff.mp only).2 pointer
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      obtain ⟨ob,oi⟩ := Bool.and_eq_true_iff.mp ok
      obtain ⟨wb,wi⟩ := Bool.and_eq_true_iff.mp only
      have pm : middle.arrays "a".toList=some a := by rw [(frame _ _ _ _ _ ob iteration).2.1]; exact pointer
      have pn : next.arrays "a".toList=some a := by rw [(frame _ _ _ _ _ oi update).2.1]; exact pm
      exact block_trans _ _ _ block (ih1 ob wb pointer)
        (block_trans _ _ _ block (ih2 oi wi pm) (ih3 ok only pn))
  | loopReturn _ _ _ _ _ _ _ _ _ iteration ih =>
      exact ih (Bool.and_eq_true_iff.mp ok).1 (Bool.and_eq_true_iff.mp only).1 pointer
  | declarePointer | pointer | call | arrayScope | ret | retVoid => cases ok

theorem table_after (code : Stmt) (s : State) (out : Result) (a gm : ArrayPointer)
    (ok : supported code=true) (only : onlyA code=true) (separate : a.block≠gm.block)
    (pointer : s.arrays "a".toList=some a) (table : Table s.heap gm)
    (source : Exec KeygenPublicSource.program [] code s out) : Table out.state.heap gm := by
  have block := other_block _ [] code s out ok only a gm.block separate pointer source
  intro i hi
  obtain ⟨w,read,range,value⟩ := table i hi
  exact ⟨w,KeygenPublicForwardMemory.load_block s.heap out.state.heap (KeygenSmallOutput.element gm i) w block read,range,value⟩

theorem load_value (s : State) (name : String) (p : ArrayPointer) (e : CLogic.Expr) (i : Nat)
    (z : KeygenPublicAlgebra.R) (binding : s.arrays name.toList=some p)
    (index : ∀ v, KeygenPublicWord.scalar s e v → v.integer.toNat=i)
    (cell : KeygenPublicInputCells.Cell s.heap p i z) :
    KeygenPublicValueExpr.Evaluates s (.load16 name.toList e) z := by
  intro v source
  cases source with
  | load16 _ _ actual w address read =>
      rw [KeygenPublicTableIndex.address s name e p actual i binding index address] at read
      obtain ⟨old,loaded,range,eq⟩ := cell
      have we := C99NarrowReads.load16_deterministic _ _ _ _ read loaded
      subst w
      refine ⟨?_,?_⟩
      · change KeygenPublicRangeExpr.Ranged (C99NarrowReads.unsignedPromotion old)
        unfold KeygenPublicRangeExpr.Ranged
        rw [C99NarrowReads.unsigned_promotion_exact]
        exact ⟨Int.natCast_nonneg _,by exact_mod_cast range⟩
      · change ((C99NarrowReads.unsignedPromotion old).integer : KeygenPublicAlgebra.R)=z
        rw [C99NarrowReads.unsigned_promotion_exact,Int.cast_natCast]
        exact eq

end FT1536.Source3.KeygenPublicValueFrames
