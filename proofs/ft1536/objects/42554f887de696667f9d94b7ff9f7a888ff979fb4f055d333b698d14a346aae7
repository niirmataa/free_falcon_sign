import Source3.StableTopBodyBridge

namespace FT1536.Source3.StableTopBodyTotal
open StableTopSyntax StableTopMemory StableTopAtoms StableBinaryByteView
abbrev Names := List B20.C.Name
def Ready (names : Names) (env : StableTopExpr.Env) : Prop := ∀ n∈names, (env n).isSome
def exprCheck (names : Names) (e : Expr) : Bool := (StableTopExpr.vars e).all (fun n => names.contains n)
def stmtCheck (names : Names) : Stmt → Bool
  | .readCheck _ _ => true
  | .letCheck _ e | .storeCheck _ e => exprCheck names e
def nextNames (names : Names) : Stmt → Names
  | .readCheck n _ | .letCheck n _ => n::names
  | .storeCheck _ _ => names
def programCheck : Names → List Stmt → Bool
  | _,[] => true
  | names,s::rest => stmtCheck names s && programCheck (nextNames names s) rest
def Bound (u v : Nat) : Stmt → Prop
  | .readCheck _ d => u+d<768
  | .letCheck _ _ => True
  | .storeCheck off _ => off+v<768
def Written (l : Layout) (v : Nat) (stmt : Stmt) (out : StableBinaryCExec.State) : Prop :=
  match stmt with
  | .storeCheck off _ => (wordRead out.heap (StableBinary.addr l.leaves (off+v))).isSome
  | _ => True

theorem expr_total (names : Names) (env : StableTopExpr.Env) (e : Expr)
    (hr : Ready names env) (hc : exprCheck names e=true) : (StableTopExpr.eval env e).isSome := by
  apply StableTopExpr.total
  intro n hn
  have hmem : names.contains n=true := List.all_eq_true.mp hc n hn
  exact hr n (by simpa using hmem)

theorem ready_put (names : Names) (env : StableTopExpr.Env) (n : B20.C.Name) (w : BitVec 64)
    (h : Ready names env) : Ready (n::names) (StableTopExpr.put env n w) := by
  intro other hm
  by_cases he : other=n
  · subst other; simp [StableTopExpr.put]
  · have hr := h other (List.mem_cons.mp hm |>.resolve_left he)
    simpa [StableTopExpr.put,he] using hr

theorem stmt_total (l : Layout) (hl : WellFormed l) (u v : Nat) (names : Names)
    (s : StableTopExec.State) (stmt : Stmt) (legal : Legal l s.memory.heap)
    (ready : Ready names s.locals) (check : stmtCheck names stmt=true) (bound : Bound u v stmt) :
    ∃ out, StableTopReference.Step l u v stmt (StableTopBodyBridge.decode s) (StableTopBodyBridge.decode out) ∧
      Effect l s.memory out.memory ∧ Ready (nextNames names stmt) out.locals ∧ Written l v stmt out.memory := by
  cases stmt with
  | readCheck name delta =>
      have hi : u+delta<768 := bound
      obtain ⟨raw,hr⟩ := Option.isSome_iff_exists.mp ((HelperMemoryTotal.read_some_iff _ _).mpr (legal.rootsReadable _ hi))
      have ha := roots_allocated l s.memory.heap hl legal _ hi
      have hload : C99MemoryReference.Load64 (C99MemoryBridge.decode s.memory.heap) (rootsPtr l (u+delta)) raw := by
        apply (C99MemoryAccess.load64_iff _ _ _ rfl ha rfl).mpr
        simpa [C99MemoryBridge.encode_decode,rootsPtr,C99MemoryReference.ArrayPointer.offset,StableBinary.addr] using hr
      obtain ⟨w,mid,_,hc,effect⟩ := checked_total l s.memory raw hl legal
      let out : StableTopExec.State := ⟨mid,StableTopExpr.put s.locals name w⟩
      exact ⟨out,StableTopReference.Step.read name delta (StableTopBodyBridge.decode s) (C99HelperAtoms.decode mid)
        raw w hload hc,effect,ready_put names s.locals name w ready,True.intro⟩
  | letCheck name expr =>
      obtain ⟨raw,hr⟩ := Option.isSome_iff_exists.mp (expr_total names s.locals expr ready check)
      obtain ⟨w,mid,_,hc,effect⟩ := checked_total l s.memory raw hl legal
      let out : StableTopExec.State := ⟨mid,StableTopExpr.put s.locals name w⟩
      exact ⟨out,StableTopReference.Step.local name expr (StableTopBodyBridge.decode s) (C99HelperAtoms.decode mid)
        raw w (StableTopExpr.sound s.locals expr raw hr) hc,effect,ready_put names s.locals name w ready,True.intro⟩
  | storeCheck off expr =>
      have hi : off+v<768 := bound
      obtain ⟨raw,hr⟩ := Option.isSome_iff_exists.mp (expr_total names s.locals expr ready check)
      obtain ⟨w,mid,_,hc,emid⟩ := checked_total l s.memory raw hl legal
      obtain ⟨last,_,hw,elast,hread⟩ := stored_total l mid (off+v) w hl emid.legal hi
      let out : StableTopExec.State := ⟨last,s.locals⟩
      refine ⟨out,StableTopReference.Step.write off expr (StableTopBodyBridge.decode s)
        (C99HelperAtoms.decode mid) (C99HelperAtoms.decode last) raw w
        (StableTopExpr.sound s.locals expr raw hr) hc hw,effect_trans emid elast,ready,?_⟩
      rw [Written,hread]; rfl

theorem body_total (l : Layout) (hl : WellFormed l) (u v : Nat) (body : List Stmt) :
    ∀ (names : Names) (s : StableTopExec.State), Legal l s.memory.heap → Ready names s.locals →
      programCheck names body=true → (∀ stmt∈body, Bound u v stmt) →
      ∃ out, StableTopReference.Body l u v body (StableTopBodyBridge.decode s) (StableTopBodyBridge.decode out) ∧
        Effect l s.memory out.memory ∧ ∀ off expr, Stmt.storeCheck off expr∈body →
          (wordRead out.memory.heap (StableBinary.addr l.leaves (off+v))).isSome := by
  induction body with
  | nil =>
      intro names s legal _ _ _
      exact ⟨s,StableTopReference.Body.nil _,effect_refl l s.memory legal,by simp⟩
  | cons stmt rest ih =>
      intro names s legal ready hc hb
      have hchecks : stmtCheck names stmt=true ∧ programCheck (nextNames names stmt) rest=true := (Bool.and_eq_true _ _).mp hc
      obtain ⟨mid,hm,em,rm,wm⟩ := stmt_total l hl u v names s stmt legal ready hchecks.1 (hb stmt (by simp))
      obtain ⟨out,ho,eo,wo⟩ := ih (nextNames names stmt) mid em.legal rm hchecks.2
        (fun x hx => hb x (List.mem_cons_of_mem stmt hx))
      refine ⟨out,StableTopReference.Body.cons stmt rest _ _ _ hm ho,effect_trans em eo,?_⟩
      intro off expr hw
      rcases List.mem_cons.mp hw with heq | htail
      · subst stmt
        exact eo.grows (off+v) (hb (.storeCheck off expr) (by simp)) wm
      · exact wo off expr htail

theorem pinned_check : programCheck ["three".toList] expected.body=true := by decide
theorem pinned_bounds (v : Nat) (hv : v<256) : ∀ stmt∈expected.body, Bound (3*v) v stmt := by
  intro stmt hs
  simp only [expected,List.mem_cons,List.not_mem_nil,or_false] at hs
  rcases hs with h | h | h | h | h | h | h | h | h | h | h | h <;>
    subst stmt <;> dsimp [Bound]
  all_goals first | exact True.intro | omega

end FT1536.Source3.StableTopBodyTotal

#print axioms FT1536.Source3.StableTopBodyTotal.body_total
#print axioms FT1536.Source3.StableTopBodyTotal.pinned_check
