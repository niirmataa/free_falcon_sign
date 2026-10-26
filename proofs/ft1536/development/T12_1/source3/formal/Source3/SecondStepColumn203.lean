import Source3.SecondStepGeometry203

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepColumn203
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (u64)
open StepCopyBody190 (addr elem)
open SecondStepCopy203 (Side)
open SecondStepLayout197 (t1 igm)
open SecondStepBasic203 (Basic)
open NttInverseWholeBridges201 (scaledWord)

def code (side : Side) : KeygenMakeFgSource.Stmt :=
  .seq (SecondStepCopy203.code side) (.seq (SecondStepCopy203.skipped side)
    (.seq (SecondStepProduct203.code side) (.seq (NttInverseSides203.branch side) KeygenMakeFgSource.skip)))

theorem f_shape : code .f=MakeFgSequence187.append
    [MakeFgTailShape190.s0,MakeFgTailShape190.s1,MakeFgTailShape190.s2,MakeFgTailShape190.s3] KeygenMakeFgSource.skip := by
  unfold code
  rw [SecondStepCopy203.f_shape,← MakeFgTailShape190.s0_shape,SecondStepProduct203.f_shape]
  rfl

theorem g_shape : code .g=MakeFgSequence187.append
    [MakeFgTailShape190.s4,MakeFgTailShape190.s5,MakeFgTailShape190.s6,MakeFgTailShape190.s7] KeygenMakeFgSource.skip := by
  unfold code
  rw [SecondStepCopy203.g_shape,SecondStepProduct203.g_shape]
  rfl

theorem source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<2) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<256, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<256, Load32 s.heap (addr (SecondStepCopy203.root side) u j 2) (F j))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (code side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧ Cell out "v".toList 128 ∧
      StepProductFixed203.Image out (SecondStepProduct203.root side) u 3 128 p p0i r2 F 128 ∧
      (∀ j<256, Load32 out.heap (addr (SecondStepCopy203.root side) u j 2) (scaledWord 7 F tws p p0i j)) ∧
      (∀ q : ArrayPointer,
        (∀ i : Fin 256, Separate (elem t1 i.val) q) →
        (∀ i : Fin 128, Separate (addr (SecondStepProduct203.root side) u i.val 3) q) →
        (∀ j<256, Separate (addr (SecondStepCopy203.root side) u j 2) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨copied,copyRun,copyBasic,copyV,copiedImage,copyLocals,copyArrays,copyKeep⟩ :=
    SecondStepCopy203.source side s u p p0i r2 h bound (fun i => F i.val) (fun i => data i.val i.isLt) old declared
  have skipped := SecondStepCopy203.skip_source side copied u p p0i r2 copyBasic
  have copyTw : ∀ k<256, Load32 copied.heap (elem igm k) (tws k) := by
    intro k slot
    exact copyKeep (elem igm k) (SecondStepGeometry203.copy_twiddle k slot) (tws k) (twLoads k slot)
  have copyData : ∀ j<256, Load32 copied.heap (addr (SecondStepCopy203.root side) u j 2) (F j) := by
    intro j slot
    exact copyKeep _ (SecondStepGeometry203.copy_data side u j bound slot) (F j) (data j slot)
  obtain ⟨products,productRun,productBasic,productV,productImage,productLocals,productArrays,productKeep⟩ :=
    SecondStepProduct203.source side copied u p p0i r2 copyBasic bound F
      (fun i => copiedImage i i.isLt) (some (u64 256)) copyV
  have productTw : ∀ k<256, Load32 products.heap (elem igm k) (tws k) := by
    intro k slot
    exact productKeep _ (fun i => SecondStepGeometry203.product_twiddle side u i.val k bound i.isLt) _ (copyTw k slot)
  have productData : ∀ j<256, Load32 products.heap (addr (SecondStepCopy203.root side) u j 2) (F j) := by
    intro j slot
    exact productKeep _ (fun i => SecondStepGeometry203.product_data side side u i.val u j bound i.isLt) _ (copyData j slot)
  obtain ⟨out,inverseRun,outBasic,inverseLocals,inverseArrays,image,inverseKeep⟩ :=
    SecondStepInverse203.source side products u p p0i r2 productBasic bound tws F productTw productData
  have run : Exec (code side) s ⟨out,.normal⟩ :=
    .seqNormal _ _ s copied _ copyRun (.seqNormal _ _ copied copied _ skipped
      (.seqNormal _ _ copied products _ productRun (.seqNormal _ _ products out _ inverseRun (SelectedStepAddPrime195.skip_run out))))
  refine ⟨out,run,outBasic,(congrFun inverseLocals "v".toList).trans productV,?_,image,?_⟩
  · intro i slot
    exact inverseKeep _ (fun j _ => StepCopyFixed190.separate_symm
      (SecondStepGeometry203.product_data side side u i.val u j bound i.isLt)) _ (productImage i slot)
  · intro q copySep productSep inverseSep w loaded
    exact inverseKeep q inverseSep w (productKeep q productSep w (copyKeep q copySep w loaded))

end FT1536.Source3.SecondStepColumn203
