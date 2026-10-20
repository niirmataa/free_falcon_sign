import Source3.FprPrimitives

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinaryFpr
open FT1536.Source3
open FT1536.Source3.StableBinary
open FT1536.Source3.FprPrimitives
open B20.C

/- Each model callee invokes the parsed, active M0 source AST. The FPR,
   ulsh and ursh calls inside it are likewise run from the pinned M0 header.
   This is an *operational* instantiation, not a new mathematical oracle. -/
def boundOps : FprCalls := ⟨FprPrimitives.add,FprPrimitives.mul,FprPrimitives.div⟩

theorem callee_output_is_parsed (p : Option FprPrimitives.Function)
    (x y z : BitVec 64) (h : FprPrimitives.call p x y=some z) :
    ∃ f, p=some f ∧ FprPrimitives.execute f [.u64 x,.u64 y]=some (.u64 z) := by
  cases hp : p with
  | none => simp [FprPrimitives.call,hp] at h
  | some f =>
      cases he : FprPrimitives.execute f [.u64 x,.u64 y] with
      | none => simp [FprPrimitives.call,hp,he] at h
      | some v =>
          cases v with
          | u64 w =>
              have hz : w=z := by simpa [FprPrimitives.call,hp,he] using h
              subst z
              exact ⟨f,rfl,he⟩
          | u32 w => simp [FprPrimitives.call,hp,he] at h
          | i32 w => simp [FprPrimitives.call,hp,he] at h
          | i64 w => simp [FprPrimitives.call,hp,he] at h

theorem parsed_output_has_frame (p : Option FprPrimitives.Function)
    (x y z : BitVec 64) (m : α)
    (h : FprPrimitives.call p x y=some z) :
    FprPrimitives.callerCall p x y m=some (z,m) := by
  simp [FprPrimitives.callerCall,h]

theorem bound_add_exec_and_frame (x y z : BitVec 64)
    (h : boundOps.add x y=some z) :
    (∃ f, FprPrimitives.addProgram=some f ∧
      FprPrimitives.execute f [.u64 x,.u64 y]=some (.u64 z)) ∧
    ∀ (m : StableBinary.Memory),
      FprPrimitives.callerCall FprPrimitives.addProgram x y m=some (z,m) := by
  exact ⟨callee_output_is_parsed _ x y z h,
    fun m => parsed_output_has_frame _ x y z m h⟩

theorem bound_mul_exec_and_frame (x y z : BitVec 64)
    (h : boundOps.mul x y=some z) :
    (∃ f, FprPrimitives.mulProgram=some f ∧
      FprPrimitives.execute f [.u64 x,.u64 y]=some (.u64 z)) ∧
    ∀ (m : StableBinary.Memory),
      FprPrimitives.callerCall FprPrimitives.mulProgram x y m=some (z,m) := by
  exact ⟨callee_output_is_parsed _ x y z h,
    fun m => parsed_output_has_frame _ x y z m h⟩

theorem bound_div_exec_and_frame (x y z : BitVec 64)
    (h : boundOps.div x y=some z) :
    (∃ f, FprPrimitives.divProgram=some f ∧
      FprPrimitives.execute f [.u64 x,.u64 y]=some (.u64 z)) ∧
    ∀ (m : StableBinary.Memory),
      FprPrimitives.callerCall FprPrimitives.divProgram x y m=some (z,m) := by
  exact ⟨callee_output_is_parsed _ x y z h,
    fun m => parsed_output_has_frame _ x y z m h⟩

/- This export is intentionally labeled MODEL: the source parser of the
   *whole helper* presently recognizes tokens, but has no independently
   interpreted C99/LP64 memory execution/refinement theorem. -/
theorem bound_model_outcome (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (s : StableBinary.State l m)
    (hl : l.wellFormed k) (hm : m.initialized l)
    (hrun : StableBinary.run l boundOps k m=some s)
    (hclear : s.memory.flags l.bad=some 0#32) :
    m.flags l.bad=some 0#32 ∧
    (∀ w∈s.checks,
      Run2.KeygenLeafGate.positive w=true ∧ Run2.KeygenLeafGate.stableWord w=w) ∧
    (∀ a, ¬l.allowed a → s.memory.words a=m.words a) ∧
    (∀ a, a≠l.bad → s.memory.flags a=m.flags a) ∧
    StableBinary.execute l boundOps StableBinary.program m k l.values l.scratch
      {firstBad := s.firstBad, badInitially := s.badInitially}=some s := by
  exact source_recursion_memory_and_sticky l boundOps k m s hl hm hrun hclear

theorem bound_model_any_prior_bad (l : StableBinary.Layout) (k : Nat)
    (m : StableBinary.Memory) (s : StableBinary.State l m)
    (b : StableBinary.Flag) (hrun : StableBinary.run l boundOps k m=some s)
    (hb : m.flags l.bad=some b) (hn : b≠0#32) :
    s.memory.flags l.bad≠some 0#32 :=
  StableBinary.source_preserves_any_nonzero_bad l boundOps k m s b hrun hb hn

end FT1536.Source3.StableBinaryFpr

#check @FT1536.Source3.StableBinaryFpr.bound_add_exec_and_frame
#check @FT1536.Source3.StableBinaryFpr.bound_mul_exec_and_frame
#check @FT1536.Source3.StableBinaryFpr.bound_div_exec_and_frame
#check @FT1536.Source3.StableBinaryFpr.bound_model_outcome
#check @FT1536.Source3.StableBinaryFpr.bound_model_any_prior_bad
#print FT1536.Source3.StableBinaryFpr.bound_model_outcome
#print axioms FT1536.Source3.StableBinaryFpr.bound_add_exec_and_frame
#print axioms FT1536.Source3.StableBinaryFpr.bound_mul_exec_and_frame
#print axioms FT1536.Source3.StableBinaryFpr.bound_div_exec_and_frame
#print axioms FT1536.Source3.StableBinaryFpr.bound_model_outcome
#print axioms FT1536.Source3.StableBinaryFpr.bound_model_any_prior_bad
