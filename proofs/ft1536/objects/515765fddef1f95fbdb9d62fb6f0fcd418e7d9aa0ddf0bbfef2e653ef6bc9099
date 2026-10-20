import Source3.KeygenPublicValueLists

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual triple assignments and chronological uint16 stores. The ordinary
   coefficient values and the scaled x/w/x2 values remain distinct. -/
namespace FT1536.Source3.KeygenPublicTripleValues
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R radix)
open KeygenPublicInputCells (Cell)
open KeygenPublicValueExpr (Local local_value twiddle_value add_value)
open KeygenPublicValueLists (Typed Known assignment)
open KeygenNttLoopSupport (USlot)
open KeygenPublicTableControl (seq_inv frame)
open KeygenPublicTripleProgram (index names1 names2 assignments stores body)

def names : List String := ["fA","fB","fC","x","x2","fB0","fB1","fB2","fC0","fC1","fC2"]
def assignmentCode (i : Nat) : Stmt := (assignments[i]?).getD .skip
def storeCode (i : Nat) : Stmt := (stores[i]?).getD .skip
structure Fixed (p gm : ArrayPointer) (u v : Nat) (s : State) : Prop where
  pointer : s.arrays "a".toList=some p
  cubic : s.arrays "gm_cubic".toList=some gm
  low : USlot s "u" u
  high : USlot s "v" v
def fixedNames : List Name := ["u".toList,"v".toList]
theorem fixed_after (code : Stmt) (s : State) (out : Result) (p gm : ArrayPointer) (u v : Nat)
    (ok : KeygenPublicTableControl.supported code=true)
    (keep : ∀ name∈fixedNames, name∉KeygenPublicTableControl.writes code)
    (fixed : Fixed p gm u v s) (source : Exec KeygenPublicSource.program [] code s out) : Fixed p gm u v out.state := by
  have f := frame _ [] code s out ok source
  exact ⟨by rw [f.2.1]; exact fixed.pointer,by rw [f.2.1]; exact fixed.cubic,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.low,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.high⟩

def ResultCells (heap : Memory) (p : ArrayPointer) (u : Nat) (A B C x w : R) : Prop :=
  Cell heap p u (A+(B*x+C*x^2)) ∧
  Cell heap p (u+1) (A+(B*x*w+C*x^2*w^2)) ∧
  Cell heap p (u+2) (A+(B*x*w^2+C*x^2*w))
def Stores (before after : Memory) (p : ArrayPointer) (u : Nat) : Prop :=
  ∃ h1 h2 w0 w1 w2,
    KeygenSmallOutput.Store16 before (KeygenSmallOutput.element p u) w0 h1 ∧
    KeygenSmallOutput.Store16 h1 (KeygenSmallOutput.element p (u+1)) w1 h2 ∧
    KeygenSmallOutput.Store16 h2 (KeygenSmallOutput.element p (u+2)) w2 after

theorem source_body (s : State) (out : Result) (p gm : ArrayPointer) (u v : Nat) (A B C x w : R)
    (hu : u+2<1536) (hv : v<1024) (width : p.elementBytes=2) (fixed : Fixed p gm u v s)
    (first : Cell s.heap p u A) (second : Cell s.heap p (u+1) B) (third : Cell s.heap p (u+2) C)
    (root : Cell s.heap gm v (radix*x)) (unity : Local s "w" (radix*w))
    (source : Exec KeygenPublicSource.program [] body s out) :
    ResultCells out.state.heap p u A B C x w ∧ Stores s.heap out.state.heap p u := by
  cases source with
  | scope _ _ _ _ result executed =>
      obtain ⟨s1,d1,rest1⟩ := seq_inv _ _ s result (by decide) executed
      obtain ⟨s2,d2,rest2⟩ := seq_inv _ _ s1 result (by decide) rest1
      obtain ⟨s3,a0,rest3⟩ := seq_inv _ _ s2 result (by decide) rest2
      obtain ⟨s4,a1,rest4⟩ := seq_inv _ _ s3 result (by decide) rest3
      obtain ⟨s5,a2,rest5⟩ := seq_inv _ _ s4 result (by decide) rest4
      obtain ⟨s6,a3,rest6⟩ := seq_inv _ _ s5 result (by decide) rest5
      obtain ⟨s7,a4,rest7⟩ := seq_inv _ _ s6 result (by decide) rest6
      obtain ⟨s8,a5,rest8⟩ := seq_inv _ _ s7 result (by decide) rest7
      obtain ⟨s9,a6,rest9⟩ := seq_inv _ _ s8 result (by decide) rest8
      obtain ⟨s10,a7,rest10⟩ := seq_inv _ _ s9 result (by decide) rest9
      obtain ⟨s11,a8,rest11⟩ := seq_inv _ _ s10 result (by decide) rest10
      obtain ⟨s12,a9,rest12⟩ := seq_inv _ _ s11 result (by decide) rest11
      obtain ⟨s13,a10,rest13⟩ := seq_inv _ _ s12 result (by decide) rest12
      obtain ⟨s14,st0,rest14⟩ := seq_inv _ _ s13 result (by decide) rest13
      obtain ⟨s15,st1,rest15⟩ := seq_inv _ _ s14 result (by decide) rest14
      obtain ⟨s16,st2,last⟩ := seq_inv _ _ s15 result (by decide) rest15
      cases last
      have ds1 := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s .u32 names1 ⟨s1,.normal⟩ d1)
      have ds2 := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s1 .u32 names2 ⟨s2,.normal⟩ d2)
      dsimp only at ds1 ds2
      have typed : Typed s2 names := by
        intro n hn
        simp only [names,List.mem_cons,List.not_mem_nil,or_false] at hn
        rcases hn with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
        all_goals exact ⟨none,by rw [ds2,ds1]; rfl⟩
      have fixed1 := fixed_after (.scalar (.declare .u32 names1)) s ⟨s1,.normal⟩ p gm u v (by decide) (by decide) fixed d1
      have fixed2 := fixed_after (.scalar (.declare .u32 names2)) s1 ⟨s2,.normal⟩ p gm u v (by decide) (by decide) fixed1 d2
      have fixed3 := fixed_after (assignmentCode 0) s2 ⟨s3,.normal⟩ p gm u v (by decide) (by decide) fixed2 a0
      have fixed4 := fixed_after (assignmentCode 1) s3 ⟨s4,.normal⟩ p gm u v (by decide) (by decide) fixed3 a1
      have fixed5 := fixed_after (assignmentCode 2) s4 ⟨s5,.normal⟩ p gm u v (by decide) (by decide) fixed4 a2
      have heap2 : s2.heap=s.heap := by rw [ds2,ds1]
      have known : Known s2 [("w",radix*w)] := by
        intro entry member
        have eq := List.mem_singleton.mp member
        subst entry
        have first := KeygenPublicValueExpr.local_after (.scalar (.declare .u32 names1)) s ⟨s1,.normal⟩ "w" _
          (by decide) (by decide) unity d1
        exact KeygenPublicValueExpr.local_after (.scalar (.declare .u32 names2)) s1 ⟨s2,.normal⟩ "w" _
          (by decide) (by decide) first d2
      obtain ⟨ty3,k3,h3⟩ := assignment s2 ⟨s3,.normal⟩ names [("w",radix*w)] "fA" _ A typed (by simp [names])
        (by simp) known
        (KeygenPublicFirstValues.load_value s2 p (index 0) u A fixed2.pointer
          (fun value ev => by simpa only [Nat.add_zero] using KeygenPublicTripleExpr.index_value s2 u 0 (by omega) (by decide) value fixed2.low ev)
          (by rw [heap2]; exact first)) a0
      obtain ⟨ty4,k4,h4⟩ := assignment s3 ⟨s4,.normal⟩ names _ "fB" _ B ty3 (by simp [names])
        (by simp) k3
        (KeygenPublicFirstValues.load_value s3 p (index 1) (u+1) B fixed3.pointer
          (fun value ev => KeygenPublicTripleExpr.index_value s3 u 1 (by omega) (by decide) value fixed3.low ev)
          (by rw [h3,heap2]; exact second)) a1
      obtain ⟨ty5,k5,h5⟩ := assignment s4 ⟨s5,.normal⟩ names _ "fC" _ C ty4 (by simp [names])
        (by simp) k4
        (KeygenPublicFirstValues.load_value s4 p (index 2) (u+2) C fixed4.pointer
          (fun value ev => KeygenPublicTripleExpr.index_value s4 u 2 (by omega) (by decide) value fixed4.low ev)
          (by rw [h4,h3,heap2]; exact third)) a2
      obtain ⟨ty6,k6,h6⟩ := assignment s5 ⟨s6,.normal⟩ names _ "x" _ (radix*x) ty5 (by simp [names])
        (by simp) k5
        (KeygenPublicValueFrames.load_value s5 "gm_cubic" gm (.var "v".toList) v (radix*x) fixed5.cubic
          (fun value ev => by rw [KeygenPublicTableIndex.variable64 s5 "v" v value fixed5.high ev]; exact KeygenNttLoopSupport.u64_toNat v (by omega))
          (by rw [h5,h4,h3,heap2]; exact root)) a3
      obtain ⟨ty7,k7,h7⟩ := assignment s6 ⟨s7,.normal⟩ names _ "x2" _ (radix*x^2) ty6 (by simp [names])
        (by simp) k6 (KeygenPublicTripleExpr.square_scaled s6 _ x (local_value s6 "x" _ (k6 ("x",radix*x) (by simp)))) a4
      obtain ⟨ty8,k8,h8⟩ := assignment s7 ⟨s8,.normal⟩ names _ "fB0" _ (B*x) ty7 (by simp [names])
        (by simp) k7 (twiddle_value s7 _ _ B x (local_value s7 "fB" _ (k7 ("fB",B) (by simp))) (local_value s7 "x" _ (k7 ("x",radix*x) (by simp)))) a5
      obtain ⟨ty9,k9,h9⟩ := assignment s8 ⟨s9,.normal⟩ names _ "fB1" _ (B*x*w) ty8 (by simp [names])
        (by simp) k8 (twiddle_value s8 _ _ (B*x) w (local_value s8 "fB0" _ (k8 ("fB0",B*x) (by simp))) (local_value s8 "w" _ (k8 ("w",radix*w) (by simp)))) a6
      obtain ⟨ty10,k10,h10⟩ := assignment s9 ⟨s10,.normal⟩ names _ "fB2" _ (B*x*w*w) ty9 (by simp [names])
        (by simp) k9 (twiddle_value s9 _ _ (B*x*w) w (local_value s9 "fB1" _ (k9 ("fB1",B*x*w) (by simp))) (local_value s9 "w" _ (k9 ("w",radix*w) (by simp)))) a7
      obtain ⟨ty11,k11,h11⟩ := assignment s10 ⟨s11,.normal⟩ names _ "fC0" _ (C*x^2) ty10 (by simp [names])
        (by simp) k10 (twiddle_value s10 _ _ C (x^2) (local_value s10 "fC" _ (k10 ("fC",C) (by simp))) (local_value s10 "x2" _ (k10 ("x2",radix*x^2) (by simp)))) a8
      obtain ⟨ty12,k12,h12⟩ := assignment s11 ⟨s12,.normal⟩ names _ "fC1" _ (C*x^2*w) ty11 (by simp [names])
        (by simp) k11 (twiddle_value s11 _ _ (C*x^2) w (local_value s11 "fC0" _ (k11 ("fC0",C*x^2) (by simp))) (local_value s11 "w" _ (k11 ("w",radix*w) (by simp)))) a9
      obtain ⟨_,k13,h13⟩ := assignment s12 ⟨s13,.normal⟩ names _ "fC2" _ (C*x^2*w*w) ty12 (by simp [names])
        (by simp) k12 (twiddle_value s12 _ _ (C*x^2*w) w (local_value s12 "fC1" _ (k12 ("fC1",C*x^2*w) (by simp))) (local_value s12 "w" _ (k12 ("w",radix*w) (by simp)))) a10
      have fixed6 := fixed_after (assignmentCode 3) s5 ⟨s6,.normal⟩ p gm u v (by decide) (by decide) fixed5 a3
      have fixed7 := fixed_after (assignmentCode 4) s6 ⟨s7,.normal⟩ p gm u v (by decide) (by decide) fixed6 a4
      have fixed8 := fixed_after (assignmentCode 5) s7 ⟨s8,.normal⟩ p gm u v (by decide) (by decide) fixed7 a5
      have fixed9 := fixed_after (assignmentCode 6) s8 ⟨s9,.normal⟩ p gm u v (by decide) (by decide) fixed8 a6
      have fixed10 := fixed_after (assignmentCode 7) s9 ⟨s10,.normal⟩ p gm u v (by decide) (by decide) fixed9 a7
      have fixed11 := fixed_after (assignmentCode 8) s10 ⟨s11,.normal⟩ p gm u v (by decide) (by decide) fixed10 a8
      have fixed12 := fixed_after (assignmentCode 9) s11 ⟨s12,.normal⟩ p gm u v (by decide) (by decide) fixed11 a9
      have fixed13 := fixed_after (assignmentCode 10) s12 ⟨s13,.normal⟩ p gm u v (by decide) (by decide) fixed12 a10
      obtain ⟨c0,w0,store0⟩ := KeygenPublicFirstValues.store_value s13 ⟨s14,.normal⟩ p (index 0) u _ _ fixed13.pointer
        (fun value ev => by simpa only [Nat.add_zero] using KeygenPublicTripleExpr.index_value s13 u 0 (by omega) (by decide) value fixed13.low ev)
        (add_value s13 _ _ A (B*x+C*x^2) (local_value s13 "fA" _ (k13 ("fA",A) (by simp)))
          (add_value s13 _ _ (B*x) (C*x^2) (local_value s13 "fB0" _ (k13 ("fB0",B*x) (by simp))) (local_value s13 "fC0" _ (k13 ("fC0",C*x^2) (by simp))))) st0
      have k14 := KeygenPublicValueLists.keep s13 ⟨s14,.normal⟩ (storeCode 0) _ (by decide) (by simp [storeCode,stores,KeygenPublicTableControl.writes]) k13 st0
      have fixed14 := fixed_after (storeCode 0) s13 ⟨s14,.normal⟩ p gm u v (by decide) (by decide) fixed13 st0
      obtain ⟨c1,w1,store1⟩ := KeygenPublicFirstValues.store_value s14 ⟨s15,.normal⟩ p (index 1) (u+1) _ _ fixed14.pointer
        (fun value ev => KeygenPublicTripleExpr.index_value s14 u 1 (by omega) (by decide) value fixed14.low ev)
        (add_value s14 _ _ A (B*x*w+C*x^2*w*w) (local_value s14 "fA" _ (k14 ("fA",A) (by simp)))
          (add_value s14 _ _ (B*x*w) (C*x^2*w*w) (local_value s14 "fB1" _ (k14 ("fB1",B*x*w) (by simp))) (local_value s14 "fC2" _ (k14 ("fC2",C*x^2*w*w) (by simp))))) st1
      have k15 := KeygenPublicValueLists.keep s14 ⟨s15,.normal⟩ (storeCode 1) _ (by decide) (by simp [storeCode,stores,KeygenPublicTableControl.writes]) k14 st1
      have fixed15 := fixed_after (storeCode 1) s14 ⟨s15,.normal⟩ p gm u v (by decide) (by decide) fixed14 st1
      obtain ⟨c2,w2,store2⟩ := KeygenPublicFirstValues.store_value s15 ⟨s16,.normal⟩ p (index 2) (u+2) _ _ fixed15.pointer
        (fun value ev => KeygenPublicTripleExpr.index_value s15 u 2 (by omega) (by decide) value fixed15.low ev)
        (add_value s15 _ _ A (B*x*w*w+C*x^2*w) (local_value s15 "fA" _ (k15 ("fA",A) (by simp)))
          (add_value s15 _ _ (B*x*w*w) (C*x^2*w) (local_value s15 "fB2" _ (k15 ("fB2",B*x*w*w) (by simp))) (local_value s15 "fC1" _ (k15 ("fC1",C*x^2*w) (by simp))))) st2
      have c01 := KeygenPublicInputCells.preserves _ _ p width (u+1) u (by omega) w1 _ store1 c0
      have c02 := KeygenPublicInputCells.preserves _ _ p width (u+2) u (by omega) w2 _ store2 c01
      have c12 := KeygenPublicInputCells.preserves _ _ p width (u+2) (u+1) (by omega) w2 _ store2 c1
      rw [h13,h12,h11,h10,h9,h8,h7,h6,h5,h4,h3,heap2] at store0
      have eqB : B*x*w*w=B*x*w^2 := by ring
      have eqC : C*x^2*w*w=C*x^2*w^2 := by ring
      rw [eqB] at c2
      rw [eqC] at c12
      exact ⟨⟨c02,c12,c2⟩,s14.heap,s15.heap,w0,w1,w2,store0,store1,store2⟩

end FT1536.Source3.KeygenPublicTripleValues
