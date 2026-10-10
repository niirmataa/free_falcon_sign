import Source3.KeygenPublicInverseTables
import Source3.KeygenPublicTripleFold

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual inverse triple assignments, scaled-left Montgomery calls and all
   three chronological canonical stores. No inverse-correctness premise. -/
namespace FT1536.Source3.KeygenPublicInverseValues
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R radix value)
open KeygenPublicInputCells (Cell)
open KeygenPublicValueExpr (Local Evaluates local_value twiddle_value add_value meaning)
open KeygenPublicValueLists (Typed Known assignment)
open KeygenPublicRangeExpr (word word_range word_argument)
open KeygenNttLoopSupport (USlot)
open KeygenPublicTableControl (seq_inv frame)
open KeygenPublicInverseProgram (index names1 names2 assignments stores body)

def names : List String := ["f0","f1","f2","x","x2","f11","f12","f21","f22"]
def assignmentCode (i : Nat) : Stmt := (assignments[i]?).getD .skip
def storeCode (i : Nat) : Stmt := (stores[i]?).getD .skip
structure Fixed (p igm : ArrayPointer) (u v : Nat) (s : State) : Prop where
  pointer : s.arrays "a".toList=some p
  cubic : s.arrays "igm_cubic".toList=some igm
  low : USlot s "u" u
  high : USlot s "v" v
def fixedNames : List Name := ["u".toList,"v".toList]
theorem fixed_after (code : Stmt) (s : State) (out : Result) (p igm : ArrayPointer) (u v : Nat)
    (ok : KeygenPublicTableControl.supported code=true)
    (keep : ∀ name∈fixedNames, name∉KeygenPublicTableControl.writes code)
    (fixed : Fixed p igm u v s) (source : Exec KeygenPublicSource.program [] code s out) : Fixed p igm u v out.state := by
  have f := frame _ [] code s out ok source
  exact ⟨by rw [f.2.1]; exact fixed.pointer,by rw [f.2.1]; exact fixed.cubic,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.low,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.high⟩

theorem scaled_left (s : State) (a b : KeygenWordExpr.Expr) (z x : R)
    (left : Evaluates s a (radix*z)) (right : Evaluates s b x) :
    Evaluates s (KeygenPublicTableAtoms.mont a b) (z*x) := by
  intro v source
  cases source with
  | call4 _ _ _ _ _ av bv qv iv _ first second third fourth called =>
      obtain ⟨ar,ae⟩ := left av first
      obtain ⟨br,be⟩ := right bv second
      have qm := KeygenPublicTableAtoms.literal_argument [] s 18433 qv third
      have im := KeygenPublicTableAtoms.literal_argument [] s 18431 iv fourth
      have eq := KeygenPublicArguments.source_mul_exact (word av) (word bv) av bv qv iv v
        (word_argument av ar) (word_argument bv br) qm im called
      rw [eq] at called ⊢
      obtain ⟨range,law⟩ := KeygenPublicArguments.source_mul _ _ _ av bv qv iv (word_range av ar) (word_range bv br)
        (word_argument av ar) (word_argument bv br) qm im called
      rw [KeygenPublicValueExpr.word_meaning av ar,KeygenPublicValueExpr.word_meaning bv br,ae,be] at law
      refine ⟨KeygenPublicRangeExpr.uint32_range _ range,?_⟩
      change value _=z*x
      calc
        value _=(value _*radix)*radix⁻¹ := by rw [mul_assoc,KeygenPublicAlgebra.radix_inverse,mul_one]
        _=((radix*z)*x)*radix⁻¹ := by rw [law]
        _=(z*x)*(radix*radix⁻¹) := by ring
        _=z*x := by rw [KeygenPublicAlgebra.radix_inverse,mul_one]

def ResultCells (heap : Memory) (p : ArrayPointer) (u : Nat) (A B C x w : R) : Prop :=
  Cell heap p u (A+(B+C)) ∧
  Cell heap p (u+1) (x*(A+(B*w+C*w^2))) ∧
  Cell heap p (u+2) (x^2*(A+(B*w^2+C*w)))

theorem source_body (s : State) (out : Result) (p igm : ArrayPointer) (u v : Nat) (A B C x w : R)
    (hu : u+2<1536) (hv : v<1024) (width : p.elementBytes=2) (fixed : Fixed p igm u v s)
    (first : Cell s.heap p u A) (second : Cell s.heap p (u+1) B) (third : Cell s.heap p (u+2) C)
    (root : Cell s.heap igm v (radix*x)) (unity : Local s "w" (radix*w))
    (source : Exec KeygenPublicSource.program [] body s out) :
    ResultCells out.state.heap p u A B C x w ∧ KeygenPublicTripleValues.Stores s.heap out.state.heap p u := by
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
      obtain ⟨s12,st0,rest12⟩ := seq_inv _ _ s11 result (by decide) rest11
      obtain ⟨s13,st1,rest13⟩ := seq_inv _ _ s12 result (by decide) rest12
      obtain ⟨s14,st2,last⟩ := seq_inv _ _ s13 result (by decide) rest13
      cases last
      have ds1 := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s .u32 names1 ⟨s1,.normal⟩ d1)
      have ds2 := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s1 .u32 names2 ⟨s2,.normal⟩ d2)
      dsimp only at ds1 ds2
      have typed : Typed s2 names := by
        intro n hn
        simp only [names,List.mem_cons,List.not_mem_nil,or_false] at hn
        rcases hn with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
        all_goals exact ⟨none,by rw [ds2,ds1]; rfl⟩
      have fixed1 := fixed_after (.scalar (.declare .u32 names1)) s ⟨s1,.normal⟩ p igm u v (by decide) (by decide) fixed d1
      have fixed2 := fixed_after (.scalar (.declare .u32 names2)) s1 ⟨s2,.normal⟩ p igm u v (by decide) (by decide) fixed1 d2
      have fixed3 := fixed_after (assignmentCode 0) s2 ⟨s3,.normal⟩ p igm u v (by decide) (by decide) fixed2 a0
      have fixed4 := fixed_after (assignmentCode 1) s3 ⟨s4,.normal⟩ p igm u v (by decide) (by decide) fixed3 a1
      have fixed5 := fixed_after (assignmentCode 2) s4 ⟨s5,.normal⟩ p igm u v (by decide) (by decide) fixed4 a2
      have heap2 : s2.heap=s.heap := by rw [ds2,ds1]
      have known : Known s2 [("w",radix*w)] := by
        intro entry member
        have eq := List.mem_singleton.mp member
        subst entry
        have first := KeygenPublicValueExpr.local_after (.scalar (.declare .u32 names1)) s ⟨s1,.normal⟩ "w" _
          (by decide) (by decide) unity d1
        exact KeygenPublicValueExpr.local_after (.scalar (.declare .u32 names2)) s1 ⟨s2,.normal⟩ "w" _
          (by decide) (by decide) first d2
      obtain ⟨ty3,k3,h3⟩ := assignment s2 ⟨s3,.normal⟩ names [("w",radix*w)] "f0" _ A typed (by simp [names])
        (by simp) known
        (KeygenPublicFirstValues.load_value s2 p (index 0) u A fixed2.pointer
          (fun value ev => by simpa only [Nat.add_zero] using KeygenPublicTripleExpr.index_value s2 u 0 (by omega) (by decide) value fixed2.low ev)
          (by rw [heap2]; exact first)) a0
      obtain ⟨ty4,k4,h4⟩ := assignment s3 ⟨s4,.normal⟩ names _ "f1" _ B ty3 (by simp [names])
        (by simp) k3
        (KeygenPublicFirstValues.load_value s3 p (index 1) (u+1) B fixed3.pointer
          (fun value ev => KeygenPublicTripleExpr.index_value s3 u 1 (by omega) (by decide) value fixed3.low ev)
          (by rw [h3,heap2]; exact second)) a1
      obtain ⟨ty5,k5,h5⟩ := assignment s4 ⟨s5,.normal⟩ names _ "f2" _ C ty4 (by simp [names])
        (by simp) k4
        (KeygenPublicFirstValues.load_value s4 p (index 2) (u+2) C fixed4.pointer
          (fun value ev => KeygenPublicTripleExpr.index_value s4 u 2 (by omega) (by decide) value fixed4.low ev)
          (by rw [h4,h3,heap2]; exact third)) a2
      obtain ⟨ty6,k6,h6⟩ := assignment s5 ⟨s6,.normal⟩ names _ "x" _ (radix*x) ty5 (by simp [names])
        (by simp) k5
        (KeygenPublicValueFrames.load_value s5 "igm_cubic" igm (.var "v".toList) v (radix*x) fixed5.cubic
          (fun value ev => by rw [KeygenPublicTableIndex.variable64 s5 "v" v value fixed5.high ev]; exact KeygenNttLoopSupport.u64_toNat v (by omega))
          (by rw [h5,h4,h3,heap2]; exact root)) a3
      obtain ⟨ty7,k7,h7⟩ := assignment s6 ⟨s7,.normal⟩ names _ "x2" _ (radix*x^2) ty6 (by simp [names])
        (by simp) k6 (KeygenPublicTripleExpr.square_scaled s6 _ x (local_value s6 "x" _ (k6 ("x",radix*x) (by simp)))) a4
      obtain ⟨ty8,k8,h8⟩ := assignment s7 ⟨s8,.normal⟩ names _ "f11" _ (B*w) ty7 (by simp [names])
        (by simp) k7 (twiddle_value s7 _ _ B w (local_value s7 "f1" _ (k7 ("f1",B) (by simp))) (local_value s7 "w" _ (k7 ("w",radix*w) (by simp)))) a5
      obtain ⟨ty9,k9,h9⟩ := assignment s8 ⟨s9,.normal⟩ names _ "f12" _ (B*w*w) ty8 (by simp [names])
        (by simp) k8 (twiddle_value s8 _ _ (B*w) w (local_value s8 "f11" _ (k8 ("f11",B*w) (by simp))) (local_value s8 "w" _ (k8 ("w",radix*w) (by simp)))) a6
      obtain ⟨ty10,k10,h10⟩ := assignment s9 ⟨s10,.normal⟩ names _ "f21" _ (C*w) ty9 (by simp [names])
        (by simp) k9 (twiddle_value s9 _ _ C w (local_value s9 "f2" _ (k9 ("f2",C) (by simp))) (local_value s9 "w" _ (k9 ("w",radix*w) (by simp)))) a7
      obtain ⟨_,k11,h11⟩ := assignment s10 ⟨s11,.normal⟩ names _ "f22" _ (C*w*w) ty10 (by simp [names])
        (by simp) k10 (twiddle_value s10 _ _ (C*w) w (local_value s10 "f21" _ (k10 ("f21",C*w) (by simp))) (local_value s10 "w" _ (k10 ("w",radix*w) (by simp)))) a8
      have fixed6 := fixed_after (assignmentCode 3) s5 ⟨s6,.normal⟩ p igm u v (by decide) (by decide) fixed5 a3
      have fixed7 := fixed_after (assignmentCode 4) s6 ⟨s7,.normal⟩ p igm u v (by decide) (by decide) fixed6 a4
      have fixed8 := fixed_after (assignmentCode 5) s7 ⟨s8,.normal⟩ p igm u v (by decide) (by decide) fixed7 a5
      have fixed9 := fixed_after (assignmentCode 6) s8 ⟨s9,.normal⟩ p igm u v (by decide) (by decide) fixed8 a6
      have fixed10 := fixed_after (assignmentCode 7) s9 ⟨s10,.normal⟩ p igm u v (by decide) (by decide) fixed9 a7
      have fixed11 := fixed_after (assignmentCode 8) s10 ⟨s11,.normal⟩ p igm u v (by decide) (by decide) fixed10 a8
      obtain ⟨c0,w0,store0⟩ := KeygenPublicFirstValues.store_value s11 ⟨s12,.normal⟩ p (index 0) u _ _ fixed11.pointer
        (fun value ev => by simpa only [Nat.add_zero] using KeygenPublicTripleExpr.index_value s11 u 0 (by omega) (by decide) value fixed11.low ev)
        (add_value s11 _ _ A (B+C) (local_value s11 "f0" _ (k11 ("f0",A) (by simp)))
          (add_value s11 _ _ B C (local_value s11 "f1" _ (k11 ("f1",B) (by simp))) (local_value s11 "f2" _ (k11 ("f2",C) (by simp))))) st0
      have k12 := KeygenPublicValueLists.keep s11 ⟨s12,.normal⟩ (storeCode 0) _ (by decide) (by simp [storeCode,stores,KeygenPublicTableControl.writes]) k11 st0
      have fixed12 := fixed_after (storeCode 0) s11 ⟨s12,.normal⟩ p igm u v (by decide) (by decide) fixed11 st0
      obtain ⟨c1,w1,store1⟩ := KeygenPublicFirstValues.store_value s12 ⟨s13,.normal⟩ p (index 1) (u+1) _ _ fixed12.pointer
        (fun value ev => KeygenPublicTripleExpr.index_value s12 u 1 (by omega) (by decide) value fixed12.low ev)
        (scaled_left s12 _ _ x (A+(B*w+C*w*w)) (local_value s12 "x" _ (k12 ("x",radix*x) (by simp)))
          (add_value s12 _ _ A (B*w+C*w*w) (local_value s12 "f0" _ (k12 ("f0",A) (by simp)))
            (add_value s12 _ _ (B*w) (C*w*w) (local_value s12 "f11" _ (k12 ("f11",B*w) (by simp))) (local_value s12 "f22" _ (k12 ("f22",C*w*w) (by simp)))))) st1
      have k13 := KeygenPublicValueLists.keep s12 ⟨s13,.normal⟩ (storeCode 1) _ (by decide) (by simp [storeCode,stores,KeygenPublicTableControl.writes]) k12 st1
      have fixed13 := fixed_after (storeCode 1) s12 ⟨s13,.normal⟩ p igm u v (by decide) (by decide) fixed12 st1
      obtain ⟨c2,w2,store2⟩ := KeygenPublicFirstValues.store_value s13 ⟨s14,.normal⟩ p (index 2) (u+2) _ _ fixed13.pointer
        (fun value ev => KeygenPublicTripleExpr.index_value s13 u 2 (by omega) (by decide) value fixed13.low ev)
        (scaled_left s13 _ _ (x^2) (A+(B*w*w+C*w)) (local_value s13 "x2" _ (k13 ("x2",radix*x^2) (by simp)))
          (add_value s13 _ _ A (B*w*w+C*w) (local_value s13 "f0" _ (k13 ("f0",A) (by simp)))
            (add_value s13 _ _ (B*w*w) (C*w) (local_value s13 "f12" _ (k13 ("f12",B*w*w) (by simp))) (local_value s13 "f21" _ (k13 ("f21",C*w) (by simp)))))) st2
      have c01 := KeygenPublicInputCells.preserves _ _ p width (u+1) u (by omega) w1 _ store1 c0
      have c02 := KeygenPublicInputCells.preserves _ _ p width (u+2) u (by omega) w2 _ store2 c01
      have c12 := KeygenPublicInputCells.preserves _ _ p width (u+2) (u+1) (by omega) w2 _ store2 c1
      rw [h11,h10,h9,h8,h7,h6,h5,h4,h3,heap2] at store0
      have eqB : B*w*w=B*w^2 := by ring
      have eqC : C*w*w=C*w^2 := by ring
      rw [eqB] at c2
      rw [eqC] at c12
      exact ⟨⟨c02,c12,c2⟩,s12.heap,s13.heap,w0,w1,w2,store0,store1,store2⟩

end FT1536.Source3.KeygenPublicInverseValues
