import Source3.CertificateScanStep

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateScan
open CertificateMemory CertificateEffects CertificateAtoms StableBinaryByteView
abbrev Word := BitVec 64

def run (l : Layout) : Nat → Nat → State → Option State
  | 0,_,_ => none
  | fuel+1,i,s => if i<1536 then do run l fuel (i+1) (← CertificateScanStep.run l i s) else some s
inductive Exec (l : Layout) : Nat → RState → RState → Prop where
  | done (i : Nat) (s : RState) (guard : ¬i<1536) : Exec l i s s
  | next (i : Nat) (s mid out : RState) (guard : i<1536)
      (body : CertificateScanStep.Exec l i s mid) (tail : Exec l (i+1) mid out) : Exec l i s out

theorem complete (l : Layout) (remaining : Nat) : ∀ i s out, i+remaining=1536 → Exec l i s out →
    run l (remaining+1) i (encode s)=some (encode out) := by
  induction remaining with
  | zero =>
      intro i s out hi h
      have hn : i=1536 := by omega
      subst i
      cases h with
      | done _ _ _ => rfl
      | next _ _ _ _ guard _ _ => omega
  | succ n ih =>
      intro i s out hi h
      cases h with
      | done _ _ hf => omega
      | next _ _ mid _ hg hb ht =>
          have hm:=CertificateScanStep.complete l i s mid hb
          have htail:=ih (i+1) mid out (by omega) ht
          rw [run,ite_eq_left hg,hm]
          exact htail

def Represents (l : Layout) (s : State) (ws : List Word) : Prop :=
  ws.length=1536 ∧ ∀ i<1536, read l s i=ws[i]?
def snapshot (l : Layout) (s : State) : List Word := List.ofFn (fun i : Fin 1536 => (read l s i.val).getD 0)

theorem snapshot_represents (l : Layout) (s : State) (hr : ∀ i<1536, (read l s i).isSome) : Represents l s (snapshot l s) := by
  refine ⟨by simp only [snapshot,List.length_ofFn],?_⟩
  intro i hi
  obtain ⟨w,hw⟩:=Option.isSome_iff_exists.mp (hr i hi)
  change read l s i=(List.ofFn (fun j : Fin 1536 => (read l s j.val).getD 0))[i]?
  rw [List.getElem?_ofFn,dite_eq_left hi,hw]
  rfl

theorem represents_update (l : Layout) (s out : State) (ws : List Word) (i : Nat) (z : Word)
    (rep : Represents l s ws) (hi : i<1536) (hw : read l out i=some z)
    (frame : ∀ j<1536, j≠i → read l out j=read l s j) : Represents l out (ws.set i z) := by
  refine ⟨by simp [rep.1],?_⟩
  intro j hj
  by_cases he : j=i
  · subst j
    rw [hw,List.getElem?_set_self (by rw [rep.1]; exact hi)]
  · rw [frame j hj he,rep.2 j hj,List.getElem?_set_ne (Ne.symm he)]

theorem exists_from_list (l : Layout) (hl : WellFormed l) (ws : List Word) :
    ∀ pre s bad, Legal l s.heap → Represents l s (pre++ws) → flagRead s.heap l.bad=some bad →
      ∃ out, Exec l pre.length (decode s) (decode out) ∧ Effect l s out ∧
        Represents l out (pre++(Run2.KeygenLeafGate.scan ws bad).1) ∧
        flagRead out.heap l.bad=some (Run2.KeygenLeafGate.scan ws bad).2 ∧
        (∀ e∈s.trace, e∈out.trace) := by
  induction ws with
  | nil =>
      intro pre s bad legal rep hb
      have hi : pre.length=1536 := by simpa using rep.1
      exact ⟨s,Exec.done _ _ (by omega),effect_refl l s legal,rep,hb,fun _ h => h⟩
  | cons x xs ih =>
      intro pre s bad legal rep hb
      have hi : pre.length<1536 := by have h:=rep.1; simp only [List.length_append,List.length_cons] at h; omega
      have hr : read l s pre.length=some x := (rep.2 pre.length hi).trans (LeafScan.get_at_prefix pre x xs)
      obtain ⟨mid,hm,em,hw,frame,badNext,trace⟩:=CertificateScanStep.total l hl pre.length hi s x legal hr
      have rm:=represents_update l s mid (pre++x::xs) pre.length (Run2.KeygenLeafGate.stableWord x) rep hi hw frame
      rw [LeafScan.set_at_prefix] at rm
      obtain ⟨out,ho,eo,ro,bo,traceOut⟩:=ih (pre++[Run2.KeygenLeafGate.stableWord x]) mid
        (Run2.KeygenLeafGate.leafStep x bad).2 em.legal (by simpa only [List.append_assoc,List.singleton_append] using rm) (badNext bad hb)
      have htail : Exec l (pre.length+1) (decode mid) (decode out) := by simpa only [List.length_append,List.length_singleton] using ho
      refine ⟨out,Exec.next pre.length (decode s) (decode mid) (decode out) hi hm htail,effect_trans em eo,?_,bo,?_⟩
      · have first : (Run2.KeygenLeafGate.leafStep x bad).1=Run2.KeygenLeafGate.stableWord x := rfl
        simpa only [Run2.KeygenLeafGate.scan,first,List.append_assoc,List.singleton_append] using ro
      · intro e he; exact traceOut e (trace e he)

theorem exists_execution (l : Layout) (hl : WellFormed l) (s : State) (legal : Legal l s.heap)
    (hr : ∀ i<1536, (read l s i).isSome) : ∃ out,
      Exec l 0 (decode s) (decode out) ∧ Effect l s out ∧
      ∀ bad, flagRead s.heap l.bad=some bad →
        Represents l out (Run2.KeygenLeafGate.scan (snapshot l s) bad).1 ∧
        flagRead out.heap l.bad=some (Run2.KeygenLeafGate.scan (snapshot l s) bad).2 ∧
        (∀ e∈s.trace, e∈out.trace) := by
  obtain ⟨bad,hb⟩:=Option.isSome_iff_exists.mp legal.badReadable
  obtain ⟨out,he,ef,rep,hf,trace⟩:=exists_from_list l hl (snapshot l s) [] s bad legal
    (by simpa using snapshot_represents l s hr) hb
  refine ⟨out,he,ef,?_⟩
  intro other ho
  have heq : other=bad := Option.some.inj (ho.symm.trans hb)
  subst other
  exact ⟨by simpa using rep,hf,trace⟩

theorem source_refinement (l : Layout) (hl : WellFormed l) (s : State) (out : RState)
    (legal : Legal l s.heap) (hr : ∀ i<1536, (read l s i).isSome) (h : Exec l 0 (decode s) out) :
    run l 1537 0 s=some (encode out) ∧ Effect l s (encode out) ∧
      ∀ bad, flagRead s.heap l.bad=some bad →
        Represents l (encode out) (Run2.KeygenLeafGate.scan (snapshot l s) bad).1 ∧
        flagRead (encode out).heap l.bad=some (Run2.KeygenLeafGate.scan (snapshot l s) bad).2 ∧
        (∀ e∈s.trace, e∈(encode out).trace) := by
  have hm:=complete l 1536 0 (decode s) out (by omega) h
  rw [encode_decode] at hm
  obtain ⟨candidate,hc,ec,pc⟩:=exists_execution l hl s legal hr
  have hmc:=complete l 1536 0 (decode s) (decode candidate) (by omega) hc
  rw [encode_decode,encode_decode] at hmc
  have heq : candidate=encode out := Option.some.inj (hmc.symm.trans hm)
  rw [heq] at ec pc
  exact ⟨hm,ec,pc⟩

end FT1536.Source3.CertificateScan

#print axioms FT1536.Source3.CertificateScan.complete
#print axioms FT1536.Source3.CertificateScan.source_refinement
