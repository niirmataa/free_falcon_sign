import Source3.KeygenPublicUpperAtoms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Both source upward bodies, with unsigned16 promotion and both directions'
   actual nested Montgomery calls and interleaved stores. -/
namespace FT1536.Source3.KeygenPublicUpperBody
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec chain)
open KeygenPublicTableControl (seq_inv writes)
open KeygenPublicTableAtoms (var mont)
open KeygenPublicTableStore
open KeygenPublicUpperAtoms
open KeygenPublicUpperProgram
open KeygenPublicTableCells (Cell)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicRoots (root)
open KeygenMkgm3Indices (tableExponent)

def PairCell (heap : C99MemoryReference.Memory) (gm igm : ArrayPointer) (i : Nat) : Prop :=
  Cell heap gm i (root^tableExponent i) ∧ Cell heap igm i ((root⁻¹)^tableExponent i)
def RowUpdate (gm igm : ArrayPointer) (i : Nat) (before after : C99MemoryReference.Memory) : Prop :=
  PairUpdate gm igm i (root^tableExponent i) ((root⁻¹)^tableExponent i) before after
theorem counter_after (code : KeygenPublicExec.Stmt) (s : State) (out : Result) (i : Nat)
    (counter : USlot s "u" i) (ok : KeygenPublicTableControl.supported code=true)
    (keep : "u".toList∉writes code) (source : Exec KeygenPublicSource.program [] code s out) : USlot out.state "u" i :=
  KeygenPublicLastBody.counter_after code s out i counter ok keep source
theorem cube_word (s : State) (name : String) (z : KeygenPublicAlgebra.R) (word : Word s name z) :
    EvalWord s (mont (var name) (mont (var name) (var name))) (z^3) := by
  have value := variable_word s name z word
  have result := mont_word s _ _ z (z*z) value (mont_word s _ _ z z value value)
  simpa only [pow_succ,pow_zero,one_mul,mul_assoc] using result

theorem cube_body (s : State) (out : Result) (gm igm : ArrayPointer) (i : Nat)
    (lower : 256 ≤ i) (upper : i<512) (gw : gm.elementBytes=2) (iw : igm.elementBytes=2)
    (separate : Separate gm igm) (pointers : Pointers s gm igm) (counter : USlot s "u" i)
    (input : PairCell s.heap gm igm (2*i))
    (source : Exec KeygenPublicSource.program [] cubeBody s out) :
    out.flow=.normal ∧ out.state.locals=s.locals ∧ out.state.arrays=s.arrays ∧
      RowUpdate gm igm i s.heap out.state.heap := by
  have outerFrame := local_frame ["y".toList,"z".toList] (chain cubeSteps) s out
    (by decide) (by decide) source
  cases source with
  | scope _ _ _ _ inner executed =>
      obtain ⟨s1,d,tail1⟩ := seq_inv _ _ s inner rfl executed
      obtain ⟨s2,yload,tail2⟩ := seq_inv _ _ s1 inner rfl tail1
      obtain ⟨s3,zload,tail3⟩ := seq_inv _ _ s2 inner rfl tail2
      obtain ⟨s4,gst,tail4⟩ := seq_inv _ _ s3 inner rfl tail3
      obtain ⟨s5,ist,last⟩ := seq_inv _ _ s4 inner rfl tail4
      have h1 := declaration_heap _ _ s ⟨s1,.normal⟩ d
      have h2 := KeygenPublicTableControl.assign_heap _ _ s1 ⟨s2,.normal⟩ yload
      have h3 := KeygenPublicTableControl.assign_heap _ _ s2 ⟨s3,.normal⟩ zload
      dsimp only at h1 h2 h3
      have p1 := pointers_after _ s ⟨s1,.normal⟩ gm igm rfl pointers d
      have p2 := pointers_after _ s1 ⟨s2,.normal⟩ gm igm rfl p1 yload
      have p3 := pointers_after _ s2 ⟨s3,.normal⟩ gm igm rfl p2 zload
      have p4 := pointers_after _ s3 ⟨s4,.normal⟩ gm igm rfl p3 gst
      have u1 := counter_after _ s ⟨s1,.normal⟩ i counter rfl (by decide) d
      have u2 := counter_after _ s1 ⟨s2,.normal⟩ i u1 rfl (by decide) yload
      have u3 := counter_after _ s2 ⟨s3,.normal⟩ i u2 rfl (by decide) zload
      have u4 := counter_after _ s3 ⟨s4,.normal⟩ i u3 rfl (by decide) gst
      have yd := declared_member _ _ s ⟨s1,.normal⟩ "y".toList (by simp) d
      have zd := declared_member _ _ s ⟨s1,.normal⟩ "z".toList (by simp) d
      have zd2 := ((KeygenPublicTableControl.frame _ _ _ s1 ⟨s2,.normal⟩ rfl yload).2.2 "z".toList (by decide)).trans zd
      have y := assign_argument s1 ⟨s2,.normal⟩ "y" _ _ ⟨none,yd⟩
        (load_argument s1 "gm" doubleU gm (2*i) (root^tableExponent (2*i)) p1.1 (double_value s1 i (by omega) u1)
          (by simpa only [h1] using input.1)) yload
      have z := assign_argument s2 ⟨s3,.normal⟩ "z" _ _ ⟨none,zd2⟩
        (load_argument s2 "igm" doubleU igm (2*i) ((root⁻¹)^tableExponent (2*i)) p2.2 (double_value s2 i (by omega) u2)
          (by simpa only [h2,h1] using input.2)) zload
      have y3 := word_after _ s2 ⟨s3,.normal⟩ "y" _ rfl (by decide) y zload
      have z4 := word_after _ s3 ⟨s4,.normal⟩ "z" _ rfl (by decide) z gst
      obtain ⟨w,scaled,write⟩ := stored_word s3 ⟨s4,.normal⟩ "gm" u _ gm i _ p3.1
        (index_value s3 "u" i (by omega) u3) (cube_word s3 "y" _ y3) gst
      obtain ⟨v,inverse,iwrite⟩ := stored_word s4 ⟨s5,.normal⟩ "igm" u _ igm i _ p4.2
        (index_value s4 "u" i (by omega) u4) (cube_word s4 "z" _ z4) ist
      have exponentLaw := (KeygenMkgm3IndexCert.all_indices i (by omega)).2.1 ⟨lower,upper⟩
      have scaled' : KeygenPublicDivisionAlgebra.Scaled w (root^tableExponent i) := by
        rw [exponentLaw,Nat.mul_comm 3, pow_mul]
        exact scaled
      have inverse' : KeygenPublicDivisionAlgebra.Scaled v ((root⁻¹)^tableExponent i) := by
        rw [exponentLaw,Nat.mul_comm 3,pow_mul]
        exact inverse
      have updated := paired_writes s3.heap s4.heap s5.heap gm igm gw iw separate i (by omega) w v _ _ scaled' inverse' write iwrite
      cases last
      exact ⟨outerFrame.1,outerFrame.2.1,outerFrame.2.2,by simpa only [RowUpdate,C99ArrayReference.restoreScope,h3,h2,h1] using updated⟩

theorem v_value (s : State) (i : Nat) (upper : i<256) (counter : USlot s "u" i)
    (v : Value) (source : KeygenPublicWord.Eval [] s (.bin .shl (var "u") (KeygenPublicTableAtoms.literal 1)) v) :
    v=u64 (2*i) := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := KeygenPublicTableIndex.word64 s "u" i a counter left
      have bv := KeygenPublicTableAtoms.literal_value [] s 1 b right
      subst a; subst b
      simpa only [Nat.mul_comm] using KeygenNttLoopSupport.shl_one_u64 i (by omega) v op
theorem square_body (s : State) (out : Result) (gm igm : ArrayPointer) (i : Nat)
    (lower : 1 ≤ i) (upper : i<256) (gw : gm.elementBytes=2) (iw : igm.elementBytes=2)
    (separate : Separate gm igm) (pointers : Pointers s gm igm) (counter : USlot s "u" i)
    (input : PairCell s.heap gm igm (2*i))
    (source : Exec KeygenPublicSource.program [] squareBody s out) :
    out.flow=.normal ∧ out.state.locals=s.locals ∧ out.state.arrays=s.arrays ∧
      RowUpdate gm igm i s.heap out.state.heap := by
  have outerFrame := local_frame ["v".toList] (chain squareSteps) s out (by decide) (by decide) source
  cases source with
  | scope _ _ _ _ inner executed =>
      obtain ⟨s1,d,tail1⟩ := seq_inv _ _ s inner rfl executed
      obtain ⟨s2,vset,tail2⟩ := seq_inv _ _ s1 inner rfl tail1
      obtain ⟨s3,gst,tail3⟩ := seq_inv _ _ s2 inner rfl tail2
      obtain ⟨s4,ist,last⟩ := seq_inv _ _ s3 inner rfl tail3
      have h1 := declaration_heap _ _ s ⟨s1,.normal⟩ d
      have h2 := KeygenPublicTableControl.assign_heap _ _ s1 ⟨s2,.normal⟩ vset
      dsimp only at h1 h2
      have p1 := pointers_after _ s ⟨s1,.normal⟩ gm igm rfl pointers d
      have p2 := pointers_after _ s1 ⟨s2,.normal⟩ gm igm rfl p1 vset
      have p3 := pointers_after _ s2 ⟨s3,.normal⟩ gm igm rfl p2 gst
      have u1 := counter_after _ s ⟨s1,.normal⟩ i counter rfl (by decide) d
      have u2 := counter_after _ s1 ⟨s2,.normal⟩ i u1 rfl (by decide) vset
      have u3 := counter_after _ s2 ⟨s3,.normal⟩ i u2 rfl (by decide) gst
      have vd := declared_member _ _ s ⟨s1,.normal⟩ "v".toList (by simp) d
      have ve := congrArg Result.state (KeygenPublicLastEntry.assign64_result s1 ⟨s2,.normal⟩ "v" _ (u64 (2*i))
        ⟨none,vd⟩ (v_value s1 i upper u1) vset)
      dsimp only at ve
      have v2 : USlot s2 "v" (2*i) := by
        rw [ve]
        simp only [USlot,C99ArrayReference.bindValue,C99ScalarReference.set,ite_true,
          KeygenNttLoopSupport.convert_u64_self (2*i) (by omega)]
      have v3 : USlot s3 "v" (2*i) :=
        ((KeygenPublicTableControl.frame _ _ _ s2 ⟨s3,.normal⟩ rfl gst).2.2 "v".toList (by decide)).trans v2
      have loaded := load_argument s2 "gm" _ gm (2*i) (root^tableExponent (2*i)) p2.1 (index_value s2 "v" (2*i) (by omega) v2)
        (by simpa only [h2,h1] using input.1)
      obtain ⟨w,scaled,write⟩ := stored_word s2 ⟨s3,.normal⟩ "gm" u _ gm i _ p2.1
        (index_value s2 "u" i (by omega) u2) (mont_arguments s2 _ _ _ _ loaded loaded) gst
      have inverseCell : Cell s3.heap igm (2*i) ((root⁻¹)^tableExponent (2*i)) :=
        cross_preserves s2.heap s3.heap igm gm iw gw (separate_symm gm igm separate) i (2*i) (by omega) (by omega) _ _ write
          (by simpa only [h2,h1] using input.2)
      have iloaded := load_argument s3 "igm" _ igm (2*i) _ p3.2 (index_value s3 "v" (2*i) (by omega) v3) inverseCell
      obtain ⟨v,inverse,iwrite⟩ := stored_word s3 ⟨s4,.normal⟩ "igm" u _ igm i _ p3.2
        (index_value s3 "u" i (by omega) u3) (mont_arguments s3 _ _ _ _ iloaded iloaded) ist
      have exponentLaw := (KeygenMkgm3IndexCert.all_indices i (by omega)).2.2.1 ⟨lower,upper⟩
      have scaled' : KeygenPublicDivisionAlgebra.Scaled w (root^tableExponent i) := by
        rw [exponentLaw,two_mul,pow_add]
        exact scaled
      have inverse' : KeygenPublicDivisionAlgebra.Scaled v ((root⁻¹)^tableExponent i) := by
        rw [exponentLaw,two_mul,pow_add]
        exact inverse
      have updated := paired_writes s2.heap s3.heap s4.heap gm igm gw iw separate i (by omega) w v _ _ scaled' inverse' write iwrite
      cases last
      exact ⟨outerFrame.1,outerFrame.2.1,outerFrame.2.2,by simpa only [RowUpdate,C99ArrayReference.restoreScope,h2,h1] using updated⟩

end FT1536.Source3.KeygenPublicUpperBody
