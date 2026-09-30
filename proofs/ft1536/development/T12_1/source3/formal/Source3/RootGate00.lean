import Source3.CElementLoop
import Source3.FprCompare

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.RootGate00
open B20.C CLogic KeygenHelpers
open FT1536.Run2.KeygenLeafGate

def halfBits : Word := 0x3fe0000000000000#64
def ltName : B20.C.Name := "fpr_lt".toList

theorem half_source : Pinned.fprLines[78]?=
    some "static const fpr fpr_onehalf = 0x3fe0000000000000ULL;\n" := by decide

def calls : B20.C.Scalar.Calls := fun name args =>
  if name=ltName then CObjectScalar.execute (fun _ _ => none) FprCompare.program args
  else StablePositive.pureCalls name args

theorem compare_call (x y : Word) : calls ltName [.u64 x,.u64 y]=some (.i32 (FprCompare.spec x y)) := by
  simp only [calls,ite_true,FprCompare.execute_bits]
theorem positive_call (w : Word) : calls positiveName [.u64 w]=some (boolean (positive w)) := by
  have hn : positiveName≠ltName := by decide
  simp only [calls,hn,ite_false,StablePositive.positive_call]
theorem bits_call (w : Word) : calls bitsName [.u64 w]=some (.u64 w) := by
  have hn : bitsName≠ltName := by decide
  simp only [calls,hn,ite_false,StablePositive.bits_call]
theorem fromBits_call (w : Word) : calls fromBitsName [.u64 w]=some (.u64 w) := by
  have hn : fromBitsName≠ltName := by decide
  simp only [calls,hn,ite_false,StablePositive.fromBits_call]

def globals : Env := fun name =>
  if name="fpr_onehalf".toList then some (.u64 halfBits)
  else if name="fpr_one".toList then some (.u64 oneBits) else none

def program : CElementLoop.Loop where
  index := "u".toList
  bound := "hn".toList
  array := "g00".toList
  body := [
    .declare .u32 ["valid".toList],
    .declare .u64 ["mask".toList,"xb".toList],
    .assign "valid".toList (.cast .u32 (.call1 positiveName (.var CElementLoop.cellName))),
    .update "valid".toList .band (.cast .u32 (.bin .xor (.literal .i32 1)
      (.call2 ltName (.var CElementLoop.cellName) (.var "fpr_onehalf".toList)))),
    .update "bad".toList .bor (.bin .xor (.var "valid".toList) (.literal .u32 1)),
    .assign "mask".toList (.bin .sub (.cast .u64 (.literal .i32 0)) (.cast .u64 (.var "valid".toList))),
    .assign "xb".toList (.call1 bitsName (.var CElementLoop.cellName)),
    .assign CElementLoop.cellName (.call1 fromBitsName (.bin .bor
      (.bin .band (.var "xb".toList) (.var "mask".toList))
      (.bin .band (.call1 bitsName (.var "fpr_one".toList)) (.bitNot (.var "mask".toList)))))]

theorem source_parses : CElementLoop.parse "g00".toList (slice 7745 11)=some program := by decide

def valid (w : Word) : Flag := positiveFlag w &&& (1#32 ^^^ FprCompare.spec w halfBits)
def selectMask (w : Word) : Word := 0#64-(valid w).setWidth 64
def step (w : Word) (bad : Flag) : Word × Flag :=
  ((w &&& selectMask w) ||| (oneBits &&& ~~~selectMask w), bad ||| (valid w ^^^ 1#32))

theorem body_binding (w : Word) (bad : Flag) :
    CElementLoop.body calls globals program w bad=some (step w bad) := by
  cases hp : positive w <;>
    simp [CElementLoop.body,CElementLoop.initial,CElementLoop.cellName,program,
      LeafRange.runStmts,CLogic.step,CLogic.eval,
      B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,
      B20.C.Scalar.assign,B20.C.update,globals,positive_call,compare_call,bits_call,fromBits_call,
      B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,B20.C.bitsOp,
      B20.C.signedBitsOp,B20.C.signedSafe,CLogic.boolean,B20.C.notBits,
      step,selectMask,valid,positiveFlag,hp]

def allowed (w : Word) : Prop := positive w=true ∧ halfBits.toNat≤w.toNat
instance (w : Word) : Decidable (allowed w) := inferInstanceAs (Decidable (_ ∧ _))

theorem step_cases (w : Word) (bad : Flag) :
    step w bad=if allowed w then (w,bad) else (oneBits,bad ||| 1#32) := by
  cases hp : positive w
  · simp [step,selectMask,valid,positiveFlag,hp,allowed]
    exact BitVec.and_allOnes
  · have hc:=FprCompare.spec_of_nonnegative_words w halfBits (positive_sign w hp) (by decide)
    by_cases hlt : w.toNat<halfBits.toNat
    · simp [step,selectMask,valid,positiveFlag,hp,hc,hlt,allowed,Nat.not_le_of_lt hlt]
      exact BitVec.and_allOnes
    · have hle:=Nat.le_of_not_gt hlt
      simp [step,selectMask,valid,positiveFlag,hp,hc,hlt,allowed,hle]
      exact BitVec.and_allOnes

theorem step_clear (w : Word) (bad : Flag) : (step w bad).2=0#32 ↔ bad=0#32 ∧ allowed w := by
  rw [step_cases]
  by_cases ha : allowed w <;> simp [ha,BitVec.or_eq_zero_iff]

theorem scan_clear (ws : List Word) (bad : Flag) :
    (CElementLoop.scan step ws bad).2=0#32 ↔ bad=0#32 ∧ ∀ w∈ws,allowed w := by
  induction ws generalizing bad with
  | nil => simp [CElementLoop.scan]
  | cons w ws ih =>
      simp only [CElementLoop.scan,ih,step_clear,List.mem_cons,forall_eq_or_imp]
      tauto

theorem scan_preserves (ws : List Word) (bad : Flag)
    (hc : (CElementLoop.scan step ws bad).2=0#32) : (CElementLoop.scan step ws bad).1=ws := by
  induction ws generalizing bad with
  | nil => rfl
  | cons w ws ih =>
      have hw:=((scan_clear (w::ws) bad).mp hc).2 w (by simp)
      have hr : (CElementLoop.scan step ws (step w bad).2).2=0#32 := hc
      change (step w bad).1::(CElementLoop.scan step ws (step w bad).2).1=w::ws
      rw [ih _ hr,step_cases,ite_eq_left hw]

theorem allowed_real_lower (w : Word) (hw : allowed w) : (1/2 : ℝ)≤positiveNormalValue w := by
  have hn:=hw.2
  have he : 1022≤w.toNat/2^52 := by norm_num [halfBits] at hn; omega
  have hz : (-53 : ℤ)≤(w.toNat/2^52 : ℕ)-(1075 : ℤ) := by omega
  have hp:=zpow_le_zpow_right₀ (by norm_num : (1 : ℝ)≤2) hz
  have hm : (2^52 : ℝ)≤((2^52+w.toNat%2^52 : ℕ) : ℝ) := by
    exact_mod_cast Nat.le_add_right (2^52) (w.toNat%2^52)
  calc
    (1/2 : ℝ)=2^52*(2 : ℝ)^(-53 : ℤ) := by norm_num
    _ ≤ 2^52*(2 : ℝ)^((w.toNat/2^52 : ℕ)-(1075 : ℤ)) :=
      mul_le_mul_of_nonneg_left hp (by norm_num)
    _ ≤ positiveNormalValue w :=
      mul_le_mul_of_nonneg_right hm (zpow_nonneg (by norm_num) _)

theorem source_scan_768 (ws : List Word) (bad : Flag) (hlen : ws.length=768) :
    (CElementLoop.parse "g00".toList (slice 7745 11)).bind
      (fun code => CElementLoop.run calls globals code 768#64 769 0#64 ws bad)=
      some (CElementLoop.scan step ws bad) := by
  rw [source_parses,Option.bind_some]
  have hh:=CElementLoop.scan_binding calls globals program step body_binding ws bad (by rw [hlen]; decide)
  simpa only [hlen] using hh

theorem source_clear_forces_root_bounds (ws result : List Word) (bad : Flag)
    (hlen : ws.length=768)
    (hexec : (CElementLoop.parse "g00".toList (slice 7745 11)).bind
      (fun code => CElementLoop.run calls globals code 768#64 769 0#64 ws bad)=some (result,0#32)) :
    result=ws ∧ bad=0#32 ∧ ∀ w∈ws,positive w=true ∧ (1/2 : ℝ)≤positiveNormalValue w := by
  rw [source_scan_768 ws bad hlen] at hexec
  have he:=Option.some.inj hexec
  have hc : (CElementLoop.scan step ws bad).2=0#32 := congrArg Prod.snd he
  have ha:=(scan_clear ws bad).mp hc
  refine ⟨(congrArg Prod.fst he).symm.trans (scan_preserves ws bad hc),ha.1,?_⟩
  intro w hw
  exact ⟨(ha.2 w hw).1,allowed_real_lower w (ha.2 w hw)⟩

end FT1536.Source3.RootGate00

#print FT1536.Source3.RootGate00.source_clear_forces_root_bounds
#print axioms FT1536.Source3.RootGate00.source_parses
#print axioms FT1536.Source3.RootGate00.body_binding
#print axioms FT1536.Source3.RootGate00.source_clear_forces_root_bounds
