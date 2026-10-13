import Source3.KeygenCodecStaticDrain

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual int16 read, magnitude/sign and unary quotient. Conditions are
   local entry cells, and the read exposes its real pointer/load witnesses. -/
namespace FT1536.Source3.KeygenCodecStaticCoefficient
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticProfile KeygenCodecScalarCalculation KeygenCodecControl

def magnitude (n : Int) : Int := if n<0 then -n else n
def signWord (n : Int) : BitVec 32 := if n<0 then 256 else 0
def W (n : Int) (l : Locals) : Prop := Cell "w".toList .int32 (.int32 (BitVec.ofInt 32 n)) l

theorem magnitude_bounds (n : Int) (lower : -32768≤n) (upper : n≤32767) :
    0≤magnitude n ∧ magnitude n≤32768 := by
  unfold magnitude
  split <;> omega

theorem input_read (args : Args) (s t : State) (flow : Flow)
    (declaredW : s.locals.scalars "w".toList=some (.int32,none))
    (source : Exec args KeygenCodecStaticBinding.node025 s t flow) :
    ∃ p next : ArrayPointer, ∃ word : BitVec 16,
      s.locals.x=some p ∧ PointerAdd p 1 next ∧ Load16 s.heap p word ∧
      t.locals.x=some next ∧ W word.toInt t.locals ∧ -32768≤word.toInt ∧ word.toInt≤32767 := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.int32 ∧ old=none := by
      simpa only [Option.some.injEq,Prod.mk.injEq] using declared.symm.trans declaredW
    obtain ⟨rfl,rfl⟩ := equal
    cases evaluated with
    | unary op e l last v z evaluated operation => cases operation
    | dereference e l last p word evaluated load =>
      cases evaluated with
      | postInc name l last value next updated =>
        cases updated with
        | pointer l p next held operation =>
          cases assigned with
          | set =>
            refine ⟨p,next,word,held,operation,load,rfl,?_,?_,?_⟩
            · simp only [W,Cell,withLocals,localSet,C99ScalarReference.set,ite_true,
                KeygenCodecStaticCountdown.self_convert]
            · exact word.le_toInt
            · have upper := word.toInt_lt
              omega

theorem negative_eval (args : Args) (s : State) (l : Locals) (value : Value) (n : Int)
    (lower : -32768≤n) (upper : n≤32767) (cell : W n s.locals)
    (source : Eval args s.heap s.buf KeygenCodecStaticBinding.guard037 s.locals value l) :
    truth value=decide (n<0) ∧ l=s.locals := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals _ (.int32 (BitVec.ofInt 32 n))
      (.scalar _ _ _ (by unfold Ordinary; decide +kernel) cell) middle x first
    subst x
    subst middle
    obtain ⟨same,last⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 0 (.int32 0) s.locals l y (by decide +kernel) second
    subst y
    cases operation with
    | lt x y z compared =>
      cases compared with
      | step ty ht a b ha hb =>
        subst ty
        subst a
        subst b
        constructor
        · simp only [C99IntegerReference.Value.type,C99IntegerReference.promote,C99IntegerReference.usual,
            ite_true,C99IntegerReference.convert,C99IntegerReference.Value.integer,BitVec.ofInt_toInt,
            KeygenCodecStaticCountdown.signed_exact n (by omega) (by omega),C99IntegerReference.compare]
          by_cases negative : n<0 <;> simp [truth,negative,C99IntegerReference.Value.integer]
        · exact last

theorem negate_calculation (l : Locals) (n : Int) (lower : -32768≤n) (upper : n≤32767)
    (cell : W n l) : Computes l (.unary .neg (.variable "w".toList)) (.int32 (BitVec.ofInt 32 (-n))) := by
  apply Computes.unary _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) cell)
  apply UnaryOp.neg
  apply (C99IntegerReference.neg_iff _ _).mpr
  simp only [C99IntegerReference.Value.type,C99IntegerReference.Value.integer,
    KeygenCodecStaticCountdown.signed_exact n (by omega) (by omega)]
  exact ⟨fun _ => ⟨by change -2147483648≤ -n; omega,by change -n<2147483648; omega⟩,rfl⟩

/-- Both real sign branches derive the mathematical magnitude and its
    sign bit, including the input -32768 whose magnitude is 32768. -/
theorem sign_magnitude (args : Args) (s t : State) (flow : Flow) (n : Int)
    (lower : -32768≤n) (upper : n≤32767) (cell : W n s.locals)
    (lo : s.locals.scalars "lo".toList=some (.uint32,none))
    (j : Cell "j".toList .int32 (.int32 8) s.locals)
    (source : Exec args KeygenCodecStaticBinding.node037 s t flow) :
    W (magnitude n) t.locals ∧ Cell "lo".toList .uint32 (.uint32 (signWord n)) t.locals := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    obtain ⟨test,last⟩ := negative_eval args s locals value n lower upper cell evaluated
    rw [test] at yes
    have negative : n<0 := by simpa using yes
    subst locals
    cases selected with
    | scope args a s t flow noBufShadow inside =>
      obtain ⟨m,negate,rest⟩ := seq_split args KeygenCodecStaticBinding.node027 KeygenCodecStaticBinding.node030 s t flow inside (by rfl)
      obtain ⟨last,signSource,rest⟩ := seq_split args KeygenCodecStaticBinding.node028 KeygenCodecStaticBinding.node029 m t flow rest (by rfl)
      have mag := assignment args s m .normal "w".toList .int32 _ _ _ cell (negate_calculation s.locals n lower upper cell) negate
      have heldJ := (KeygenCodecCellFrame.exec_frame "j".toList args _ s m .normal negate (by decide +kernel)).trans j
      have heldLo := (KeygenCodecCellFrame.exec_frame "lo".toList args _ s m .normal negate (by decide +kernel)).trans lo
      have calculation : Computes m.locals (.binary .shl (.number .u32 1) (.variable "j".toList)) (.uint32 256) :=
        .binary _ _ _ (.uint32 1) (.int32 8) _ (.number _ _ _ (by decide +kernel))
          (.scalar _ _ _ (by unfold Ordinary; decide +kernel) heldJ)
          (.shl _ _ _ (.unsignedLeft (.uint32 1) (.int32 8) 8 (by decide +kernel) rfl (by decide +kernel)))
      have sign := assignment args m last .normal "lo".toList .uint32 none _ _ heldLo calculation signSource
      have keptW := (KeygenCodecCellFrame.exec_frame "w".toList args _ m last .normal signSource (by decide +kernel)).trans mag
      cases rest
      constructor
      · simpa [W,Cell,scopeExit,show scopeObjects KeygenCodecStaticBinding.node031=[] from rfl,magnitude,negative,KeygenCodecStaticCountdown.self_convert] using keptW
      · simpa [Cell,scopeExit,show scopeObjects KeygenCodecStaticBinding.node031=[] from rfl,signWord,negative,KeygenCodecStaticAppend.convert_word] using sign
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    obtain ⟨test,last⟩ := negative_eval args s locals value n lower upper cell evaluated
    rw [test] at no
    have positive : ¬n<0 := by simpa using no
    subst locals
    cases selected with
    | scope args a s t flow noBufShadow inside =>
      obtain ⟨m,sign,rest⟩ := seq_split args KeygenCodecStaticBinding.node033 KeygenCodecStaticBinding.node034 s t flow inside (by rfl)
      have written := assignment args s m .normal "lo".toList .uint32 none _ (.int32 0) lo (.number _ _ _ (by decide +kernel)) sign
      have keptW := (KeygenCodecCellFrame.exec_frame "w".toList args _ s m .normal sign (by decide +kernel)).trans cell
      cases rest
      exact ⟨by simpa [W,Cell,scopeExit,show scopeObjects KeygenCodecStaticBinding.node035=[] from rfl,magnitude,positive] using keptW,
        by simpa [Cell,scopeExit,show scopeObjects KeygenCodecStaticBinding.node035=[] from rfl,signWord,positive,C99IntegerReference.convert,C99IntegerReference.Value.integer] using written⟩

theorem quotient_calculation (l : Locals) (n : Int) (lower : 0≤n) (upper : n≤32768)
    (cell : W n l) (j : Cell "j".toList .int32 (.int32 8) l) :
    Computes l (.binary .shr (.variable "w".toList) (.variable "j".toList))
      (.int32 (BitVec.ofInt 32 (n/256))) := by
  apply Computes.binary _ _ _ (.int32 (BitVec.ofInt 32 n)) (.int32 8) _
  · exact .scalar _ _ _ (by unfold Ordinary; decide +kernel) cell
  · exact .scalar _ _ _ (by unfold Ordinary; decide +kernel) j
  · apply BinaryOp.shr
    have canonical := C99IntegerReference.ShiftExec.right (.int32 (BitVec.ofInt 32 n)) (.int32 8) 8 rfl (by change (8 : Nat)<32; decide +kernel)
    simpa only [C99IntegerReference.Value.type,C99IntegerReference.convert,C99IntegerReference.Value.integer,KeygenCodecStaticCountdown.signed_exact n (by omega) (by omega),show (2 : Int)^8=256 by decide +kernel] using canonical

/-- The actual source quotient supplies the complete unary loop's local
    counter range; no solver coefficient bound is required for int16 input. -/
theorem quotient (args : Args) (s t : State) (flow : Flow) (n : Int)
    (lower : 0≤n) (upper : n≤32768) (cell : W n s.locals)
    (j : Cell "j".toList .int32 (.int32 8) s.locals)
    (declaredNe : s.locals.scalars "ne".toList=some (.int32,none))
    (source : Exec args KeygenCodecStaticBinding.node039 s t flow) :
    KeygenCodecStaticCountdown.Cell (n/256) t.locals ∧ 0≤n/256 ∧ n/256≤128 := by
  refine ⟨?_,by omega,by omega⟩
  have written := assignment args s t flow "ne".toList .int32 none _ _ declaredNe
    (quotient_calculation s.locals n lower upper cell j) source
  simpa only [KeygenCodecStaticCountdown.Cell,Cell,KeygenCodecStaticCountdown.self_convert] using written

end FT1536.Source3.KeygenCodecStaticCoefficient
