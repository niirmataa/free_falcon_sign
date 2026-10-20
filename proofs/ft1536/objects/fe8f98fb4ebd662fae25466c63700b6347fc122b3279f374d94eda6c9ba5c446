import Source3.CertificateIndex

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateReverse
open CertificateMemory CertificateEffects CertificateAtoms StableBinaryByteView
abbrev Word := BitVec 64

def step (l : Layout) (q : Word) (u : Nat) (s : State) : Option State := do
  if ¬u<768 then none else do
  let x ← read l s u
  let raw ← FprPrimitives.div q x
  let (z,mid) ← positive l s raw
  store l mid (1535-u) z
def loop (l : Layout) (q : Word) : Nat → State → Option State
  | 0,s => some s
  | u+1,s => do step l q u (← loop l q u s)

inductive Step (l : Layout) (q : Word) (u : Nat) : RState → RState → Prop where
  | emit (s mid out : RState) (dst : Nat) (x raw z : Word) (guard : u<768)
      (index : CertificateIndex.IndexEval u dst)
      (load : C99MemoryReference.Load64 s.heap (leafPtr l u) x)
      (divide : C99Frontend.primitiveCall "fpr_div".toList [.uint64 q,.uint64 x] (.uint64 raw))
      (check : Positive l s raw z mid) (write : Store l mid dst z out) : Step l q u s out
inductive Loop (l : Layout) (q : Word) : Nat → RState → RState → Prop where
  | zero (s : RState) : Loop l q 0 s s
  | next (u : Nat) (s mid out : RState) (earlier : Loop l q u s mid) (body : Step l q u mid out) :
      Loop l q (u+1) s out
def Finished (l : Layout) (q : Word) (s out : RState) : Prop := ∃ count, Loop l q count s out ∧ ¬count<768

theorem step_complete (l : Layout) (q : Word) (u : Nat) (s out : RState) (h : Step l q u s out) :
    step l q u (encode s)=some (encode out) := by
  cases h with
  | emit mid _ dst x raw z hu hi hr hd hc hw =>
      have hdst:=CertificateIndex.index_exact u dst hu hi
      subst dst
      have hread : read l (encode s) u=some x := C99MemoryBridge.load64_source_to_interpreter _ _ _ rfl hr
      have hdiv:=C99DivProof.pinned_div_complete q x raw hd
      have hcheck:=positive_complete l s mid raw z hc
      have hwrite:=store_complete l mid out (1535-u) z hw
      simp only [step,hu,not_true_eq_false,ite_false,hread,hdiv,hcheck,hwrite,Bind.bind,Option.bind]
theorem loop_complete (l : Layout) (q : Word) (u : Nat) (s out : RState) (h : Loop l q u s out) :
    loop l q u (encode s)=some (encode out) := by
  induction h with
  | zero _ => rfl
  | next u s mid out _ hs ih =>
      simp only [loop,ih,Bind.bind,Option.bind]
      exact step_complete l q u mid out hs
theorem final_count (l : Layout) (q : Word) (s out : RState) (n : Nat) (h : Loop l q n s out) (hf : ¬n<768) : n=768 := by
  cases h with
  | zero _ => omega
  | next u s mid out _ hb => cases hb with | emit mid dst x raw z hu hi hr hd hc hw => omega

def Snapshot (l : Layout) (D : Fin 768 → Word) (s : State) : Prop := ∀ i : Fin 768, read l s i.val=some (D i)
def Written (l : Layout) (q : Word) (D : Fin 768 → Word) (n : Nat) (s : State) : Prop :=
  ∀ i : Fin 768, i.val<n → ∃ raw,
    C99Frontend.primitiveCall "fpr_div".toList [.uint64 q,.uint64 (D i)] (.uint64 raw) ∧
    read l s (1535-i.val)=some (Run2.KeygenLeafGate.stableWord raw) ∧ Event.positive raw∈s.trace

theorem step_exists (l : Layout) (hl : WellFormed l) (q : Word) (D : Fin 768 → Word)
    (u : Nat) (hu : u<768) (s : State) (legal : Legal l s.heap) (snap : Snapshot l D s) :
    ∃ out, Step l q u (decode s) (decode out) ∧ Effect l s out ∧ Snapshot l D out ∧
      (∃ raw, C99Frontend.primitiveCall "fpr_div".toList [.uint64 q,.uint64 (D ⟨u,hu⟩)] (.uint64 raw) ∧
        read l out (1535-u)=some (Run2.KeygenLeafGate.stableWord raw) ∧ Event.positive raw∈out.trace) ∧
      (∀ j<1536, j≠1535-u → read l out j=read l s j) ∧
      (∀ e∈s.trace, e∈out.trace) := by
  have hx:=snap ⟨u,hu⟩
  have hr:=read_reference l s u (D ⟨u,hu⟩) hl legal (by omega) hx
  obtain ⟨raw,hd⟩:=Option.isSome_iff_exists.mp (FprDivTotal.div_total q (D ⟨u,hu⟩))
  have hdiv:=C99PrimitiveExists.div_sound q (D ⟨u,hu⟩) raw hd
  obtain ⟨z,mid,hcheck,_,hz,emid,preserve⟩:=positive_total l s raw hl legal
  obtain ⟨out,hwrite,_,eout,hread,other⟩:=store_total l mid (1535-u) z hl emid.legal (by omega)
  have frame : ∀ j<1536, j≠1535-u → read l out j=read l s j := by
    intro j hj hne
    exact (other j hj hne).trans (preserve j hj)
  have trace : out.trace=Event.positive raw::s.trace := hwrite.2.trans hcheck.2
  refine ⟨out,Step.emit (decode s) (decode mid) (decode out) (1535-u) (D ⟨u,hu⟩) raw z hu
    (CertificateIndex.index_exists u hu) hr hdiv hcheck hwrite,effect_trans emid eout,?_,⟨raw,hdiv,?_,by rw [trace]; simp⟩,
      frame,by intro e he; rw [trace]; exact List.mem_cons_of_mem _ he⟩
  · intro i
    rw [frame i.val (by have hi:=i.isLt; omega) (by have hi:=i.isLt; omega)]
    exact snap i
  · rw [hz] at hread; exact hread

theorem loop_exists (l : Layout) (hl : WellFormed l) (q : Word) (D : Fin 768 → Word)
    (s : State) (legal : Legal l s.heap) (snap : Snapshot l D s) :
    ∀ n, n≤768 → ∃ out, Loop l q n (decode s) (decode out) ∧ Effect l s out ∧ Snapshot l D out ∧ Written l q D n out := by
  intro n
  induction n with
  | zero => intro _; exact ⟨s,Loop.zero _,effect_refl l s legal,snap,by intro i hi; omega⟩
  | succ u ih =>
      intro hu
      obtain ⟨mid,hm,em,sm,wm⟩:=ih (by omega)
      obtain ⟨out,ho,eo,so,wo,frame,trace⟩:=step_exists l hl q D u (by omega) mid em.legal sm
      refine ⟨out,Loop.next u (decode s) (decode mid) (decode out) hm ho,effect_trans em eo,so,?_⟩
      intro i hi
      by_cases hlt : i.val < u
      · obtain ⟨raw,hr,hw,he⟩:=wm i hlt
        refine ⟨raw,hr,?_,trace _ he⟩
        rw [frame (1535-i.val) (by have hb:=i.isLt; omega) (by have hb:=i.isLt; omega)]
        exact hw
      · have heq : i=⟨u,by omega⟩ := by apply Fin.ext; change i.val=u; omega
        rw [heq]
        exact wo

theorem initialized (l : Layout) (q : Word) (D : Fin 768 → Word) (s : State)
    (snap : Snapshot l D s) (written : Written l q D 768 s) : ∀ i<1536, (read l s i).isSome := by
  intro i hi
  by_cases first : i<768
  · rw [snap ⟨i,first⟩]; rfl
  · obtain ⟨u,hu,heq⟩:=CertificateIndex.covers i (by omega)
    obtain ⟨raw,_,hr,_⟩:=written ⟨u,hu⟩ hu
    rw [heq] at hr
    rw [hr]; rfl

theorem finished_complete (l : Layout) (hl : WellFormed l) (q : Word) (D : Fin 768 → Word)
    (s : State) (out : RState) (legal : Legal l s.heap) (snap : Snapshot l D s)
    (h : Finished l q (decode s) out) :
    loop l q 768 s=some (encode out) ∧ Effect l s (encode out) ∧
      Snapshot l D (encode out) ∧ Written l q D 768 (encode out) := by
  obtain ⟨n,hr,hf⟩:=h
  have hn:=final_count l q (decode s) out n hr hf
  subst n
  have hm:=loop_complete l q 768 (decode s) out hr
  rw [encode_decode] at hm
  obtain ⟨candidate,hc,ec,sc,wc⟩:=loop_exists l hl q D s legal snap 768 (by omega)
  have hmc:=loop_complete l q 768 (decode s) (decode candidate) hc
  rw [encode_decode,encode_decode] at hmc
  have heq : candidate=encode out := Option.some.inj (hmc.symm.trans hm)
  rw [heq] at ec sc wc
  exact ⟨hm,ec,sc,wc⟩

theorem clear_written (l : Layout) (q : Word) (D : Fin 768 → Word) (s : State)
    (before : B20.C.Byte.Memory) (safe : Safe l before s) (hc : flagRead s.heap l.bad=some 0)
    (written : Written l q D 768 s) : ∀ i : Fin 768, ∃ raw,
      C99Frontend.primitiveCall "fpr_div".toList [.uint64 q,.uint64 (D i)] (.uint64 raw) ∧
      read l s (1535-i.val)=some raw ∧ Run2.KeygenLeafGate.positive raw=true := by
  intro i
  obtain ⟨raw,hd,hw,he⟩:=written i i.isLt
  have good:=((safe.clear hc).2 (.positive raw) he)
  refine ⟨raw,hd,?_,good.1⟩
  rw [good.2] at hw
  exact hw

end FT1536.Source3.CertificateReverse

#print axioms FT1536.Source3.CertificateReverse.loop_exists
#print axioms FT1536.Source3.CertificateReverse.initialized
#print axioms FT1536.Source3.CertificateReverse.loop_complete
