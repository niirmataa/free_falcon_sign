import Source3.StableTopAtoms

namespace FT1536.Source3.StableTopBodyBridge
open StableTopSyntax StableTopMemory

def encode (s : StableTopReference.State) : StableTopExec.State := ⟨C99HelperAtoms.encode s.memory,s.locals⟩
def decode (s : StableTopExec.State) : StableTopReference.State := ⟨C99HelperAtoms.decode s.memory,s.locals⟩
theorem encode_decode (s : StableTopExec.State) : encode (decode s)=s := by cases s; rfl

theorem step_complete (l : Layout) (u v : Nat) (stmt : Stmt) (s out : StableTopReference.State)
    (h : StableTopReference.Step l u v stmt s out) : StableTopExec.step l u v (encode s) stmt=some (encode out) := by
  cases h with
  | read name delta s mid raw w hr hc =>
      have hr' : StableBinaryCExec.load (C99HelperAtoms.encode s.memory) (StableBinary.addr l.roots (u+delta))=some raw :=
        C99MemoryBridge.load64_source_to_interpreter _ _ _ rfl hr
      have hc' := C99HelperAtoms.positive_complete (branch l 0) s.memory mid raw w hc
      simp only [StableTopExec.step,encode,hr',hc',Bind.bind,Option.bind]
      rfl
  | «local» name expr s mid raw w he hc =>
      have he' := StableTopExpr.complete _ _ _ he
      have hc' := C99HelperAtoms.positive_complete (branch l 0) s.memory mid raw w hc
      simp only [StableTopExec.step,encode,he',hc',Bind.bind,Option.bind]
      rfl
  | write offset expr s mid out raw w he hc hw =>
      have he' := StableTopExpr.complete _ _ _ he
      have hc' := C99HelperAtoms.positive_complete (branch l 0) s.memory mid raw w hc
      have hw' : StableBinaryCExec.store (C99HelperAtoms.encode mid) (StableBinary.addr l.leaves (offset+v)) w=
          some (C99HelperAtoms.encode out) := C99HelperAtoms.store_complete _ mid out w rfl hw
      simp only [StableTopExec.step,encode,he',hc',hw',Bind.bind,Option.bind]
      rfl

theorem body_complete (l : Layout) (u v : Nat) (body : List Stmt) (s out : StableTopReference.State)
    (h : StableTopReference.Body l u v body s out) : StableTopExec.body l u v body (encode s)=some (encode out) := by
  induction h with
  | nil _ => rfl
  | cons stmt rest s mid out hs _ ih =>
      have hm := step_complete l u v stmt s mid hs
      simp only [StableTopExec.body,hm,Bind.bind,Option.bind]
      exact ih

theorem loop_complete (l : Layout) (code : Code) (three : BitVec 64) (i : Nat) (s out : C99HelperReference.State)
    (h : StableTopReference.Loop l code three i s out) :
    StableTopExec.loop l code three i (C99HelperAtoms.encode s)=some (C99HelperAtoms.encode out) := by
  induction h with
  | zero _ => rfl
  | next i s mid out _ hg hb ih =>
      have hm := body_complete _ _ _ _ _ _ hb
      change StableTopExec.body l _ _ _ ⟨C99HelperAtoms.encode mid,StableTopExec.initialLocals three⟩=
        some (encode out) at hm
      simp [StableTopExec.loop,ih,hg,hm,encode]

theorem loop_index_bound (l : Layout) (three : BitVec 64) (i : Nat) (s out : C99HelperReference.State)
    (h : StableTopReference.Loop l expected three i s out) : i≤256 := by
  cases h with
  | zero _ => omega
  | next j s mid out _ hg _ =>
      change 0+3*j<768 at hg
      omega

theorem final_index (l : Layout) (three : BitVec 64) (i : Nat) (s out : C99HelperReference.State)
    (h : StableTopReference.Loop l expected three i s out)
    (hf : ¬expected.loop.initialU+expected.loop.stepU*i<expected.loop.bound) : i=256 := by
  have hb := loop_index_bound l three i s out h
  change ¬0+3*i<768 at hf
  omega

end FT1536.Source3.StableTopBodyBridge

#print axioms FT1536.Source3.StableTopBodyBridge.loop_complete
#print axioms FT1536.Source3.StableTopBodyBridge.final_index
