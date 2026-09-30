import Source3.C99HeaderSignature

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99ScalarToFpr
open B20.C

theorem lower_scalars (body : List CLogic.Stmt) :
    C99Frontend.lowerBody (body.map FprPrimitives.Instr.scalar)=some (C99Frontend.scalars body) := by
  induction body with
  | nil => simp [C99Frontend.lowerBody,C99Frontend.scalars]
  | cons stmt rest ih => simp [C99Frontend.lowerBody,C99Frontend.scalars,ih]

theorem return_to_block (body : List CLogic.Stmt) (result : Ty) (s : B20.C.Scalar.State)
    (word : Val) (fuel : Nat) (hroom : body.length<fuel)
    (he : CLogic.evalBody FprPrimitives.headerCalls result body s=some word) :
    ∃ out, FprPrimitives.execBlock fuel result (body.map FprPrimitives.Instr.scalar) s=
      some (out,some word) := by
  induction body generalizing s fuel with
  | nil => simp [CLogic.evalBody] at he
  | cons stmt rest ih =>
      cases fuel with
      | zero => simp at hroom
      | succ fuel =>
          cases stmt with
          | ret e =>
              obtain ⟨v,hv,hr⟩ := Option.map_eq_some_iff.mp he
              refine ⟨s,?_⟩
              simp [FprPrimitives.execBlock,hv,hr]
          | declare ty names =>
              obtain ⟨mid,hm,htail⟩ := Option.bind_eq_some_iff.mp he
              obtain ⟨out,ho⟩ := ih mid fuel (by simp only [List.length_cons] at hroom; omega) htail
              refine ⟨out,?_⟩
              simp [FprPrimitives.execBlock,FprPrimitives.execScalar,hm,ho]
          | assign name e =>
              obtain ⟨mid,hm,htail⟩ := Option.bind_eq_some_iff.mp he
              obtain ⟨out,ho⟩ := ih mid fuel (by simp only [List.length_cons] at hroom; omega) htail
              refine ⟨out,?_⟩
              simp [FprPrimitives.execBlock,FprPrimitives.execScalar,hm,ho]
          | update name op e =>
              obtain ⟨mid,hm,htail⟩ := Option.bind_eq_some_iff.mp he
              obtain ⟨out,ho⟩ := ih mid fuel (by simp only [List.length_cons] at hroom; omega) htail
              refine ⟨out,?_⟩
              simp [FprPrimitives.execBlock,FprPrimitives.execScalar,hm,ho]

theorem scalar_function (f : FprPrimitives.Function) (body : List CLogic.Stmt)
    (hs : f.body=body.map FprPrimitives.Instr.scalar) (hn : body.length<256)
    (args : List Val) (word : Val)
    (h : CLogic.execute FprPrimitives.headerCalls ⟨f.name,f.result,f.params,body⟩ args=some word) :
    FprPrimitives.execute f args=some word := by
  obtain ⟨s,hbind,hbody⟩ := Option.bind_eq_some_iff.mp h
  obtain ⟨out,ho⟩ := return_to_block body f.result s word 256 hn hbody
  simp [FprPrimitives.execute,hbind,hs,ho]

end FT1536.Source3.C99ScalarToFpr

#print axioms FT1536.Source3.C99ScalarToFpr.scalar_function
