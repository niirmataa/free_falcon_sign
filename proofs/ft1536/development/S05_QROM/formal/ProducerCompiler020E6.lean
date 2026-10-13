import ProducerFrame020E6

namespace FT1536.S05.ProducerCompiler020E6
open WordRAM020 ArrayBank020E4 ProducerMachine020E6 ProducerExpr020E6

/-- The generated code computes every scalar through closed instructions.
    The register bound concerns its actual execution, not just result size. -/
theorem correct {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (e : Expr regions) (base : Nat) (h : base+need e≤64) (q : State codeSize) :
    read (executeList sources (compile e base h) q).regs ⟨base,by have := positive e;omega⟩=eval sources e := by
  induction e generalizing base q with
  | literal w => exact ProducerPrimitive020E6.literal_value sources q _ w
  | load r a ih =>
    change base+need a≤64 at h
    simp only [compile,append,executeList]
    rw [ProducerPrimitive020E6.load_value,ih]
    rfl
  | binary o a b ha hb =>
    simp only [compile,append,executeList]
    rw [ProducerPrimitive020E6.binary_value]
    rw [ProducerFrame020E6.compiled_below sources b (base+1) _ _ _ (by change base<base+1;omega)]
    rw [ha,hb]
    rfl
  | select c z n hc hz hn =>
    simp only [compile,append,executeList]
    rw [ProducerPrimitive020E6.select_value]
    rw [ProducerFrame020E6.compiled_below sources n (base+2) _ _ (⟨base,by have := positive c;simp only [need] at h;omega⟩ : Register) (by change base<base+2;omega)]
    rw [ProducerFrame020E6.compiled_below sources z (base+1) _ _ _ (by change base<base+1;omega)]
    rw [hc]
    rw [ProducerFrame020E6.compiled_below sources n (base+2) _ _ (⟨base+1,by have := positive z;simp only [need] at h;omega⟩ : Register) (by change base+1<base+2;omega)]
    rw [hz,hn]
    rfl

end FT1536.S05.ProducerCompiler020E6
