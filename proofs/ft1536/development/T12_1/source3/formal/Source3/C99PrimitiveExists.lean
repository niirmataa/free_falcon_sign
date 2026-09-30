import Source3.C99DivSound
import Source3.FprAllTotal

namespace FT1536.Source3.C99PrimitiveExists
open B20.C C99ValueBridge

theorem call_inv (f : FprPrimitives.Function) (x y z : BitVec 64)
    (h : FprPrimitives.call (some f) x y=some z) :
    FprPrimitives.execute f [.u64 x,.u64 y]=some (.u64 z) := by
  change (FprPrimitives.execute f [.u64 x,.u64 y]).bind
    (fun v => match v with | .u64 w => some w | _ => none)=some z at h
  obtain ⟨v,hv,hr⟩ := Option.bind_eq_some_iff.mp h
  cases v <;> simp_all

theorem add_sound (x y z : BitVec 64) (h : FprPrimitives.add x y=some z) :
    C99Frontend.primitiveCall ['f','p','r','_','a','d','d'] [.uint64 x,.uint64 y] (.uint64 z) := by
  rw [FprPrimitives.add,FprAST.add_binding] at h
  exact ⟨_,by simp [C99Frontend.lookup,C99AddProof.lowering],
    C99AddMulSound.add_sound _ _ (call_inv _ _ _ _ h)⟩

theorem mul_sound (x y z : BitVec 64) (h : FprPrimitives.mul x y=some z) :
    C99Frontend.primitiveCall ['f','p','r','_','m','u','l'] [.uint64 x,.uint64 y] (.uint64 z) := by
  rw [FprPrimitives.mul,FprAST.mul_binding] at h
  exact ⟨_,by simp [C99Frontend.lookup,C99MulProof.lowering],
    C99AddMulSound.mul_sound _ _ (call_inv _ _ _ _ h)⟩

theorem div_sound (x y z : BitVec 64) (h : FprPrimitives.div x y=some z) :
    C99Frontend.primitiveCall ['f','p','r','_','d','i','v'] [.uint64 x,.uint64 y] (.uint64 z) := by
  rw [FprPrimitives.div,FprAST.div_binding] at h
  exact ⟨_,by simp [C99Frontend.lookup,C99DivProof.lowering],
    C99DivSound.div_sound _ _ _ (call_inv _ _ _ _ h)⟩

theorem all_primitives_inhabited (x y : BitVec 64) :
    (∃ z, C99Frontend.primitiveCall ['f','p','r','_','a','d','d'] [.uint64 x,.uint64 y] (.uint64 z)) ∧
    (∃ z, C99Frontend.primitiveCall ['f','p','r','_','m','u','l'] [.uint64 x,.uint64 y] (.uint64 z)) ∧
    (∃ z, C99Frontend.primitiveCall ['f','p','r','_','d','i','v'] [.uint64 x,.uint64 y] (.uint64 z)) := by
  obtain ⟨a,ha⟩ := Option.isSome_iff_exists.mp (FprAddTotal.add_total x y)
  obtain ⟨m,hm⟩ := Option.isSome_iff_exists.mp (FprMulTotal.mul_total x y)
  obtain ⟨d,hd⟩ := Option.isSome_iff_exists.mp (FprDivTotal.div_total x y)
  exact ⟨⟨a,add_sound x y a ha⟩,⟨m,mul_sound x y m hm⟩,⟨d,div_sound x y d hd⟩⟩

end FT1536.Source3.C99PrimitiveExists

#check @FT1536.Source3.C99PrimitiveExists.all_primitives_inhabited
#print axioms FT1536.Source3.C99PrimitiveExists.all_primitives_inhabited
