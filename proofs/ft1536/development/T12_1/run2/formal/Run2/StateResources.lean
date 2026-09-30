import Run2.BitReduction
import Run2.ProgramResources

namespace FT1536.Run2.StateResources
open Games FT1536.Relation

def eventMessage : Event → Bytes
  | .hash x _ => x
  | .sign m _ => m

def Shape (L n : ℕ) (st : State) : Prop :=
  st.table.table.length≤n ∧ st.table.seen.length≤n ∧ st.events.length≤n ∧
  (∀ e∈st.table.table,e.name.2.length≤L) ∧
  (∀ m∈st.table.seen,m.length≤L) ∧
  (∀ e∈st.events,(eventMessage e).length≤L)

theorem shape_mono (L : ℕ) {n N : ℕ} (hn : n≤N) (st : State) (h : Shape L n st) : Shape L N st :=
  ⟨h.1.trans hn,h.2.1.trans hn,h.2.2.1.trans hn,h.2.2.2⟩

theorem initial_shape (L : ℕ) : Shape L 0 initial := by
  simp [Shape,initial,ROM.empty]

theorem parse_message_length (x : Bytes) : (parse x).2.length≤x.length := by
  unfold parse
  split
  · simp only [List.length_drop]; omega
  · exact Nat.le_refl _

theorem submitted_shape (L n : ℕ) (st : State) (m : Bytes)
    (h : Shape L n st) (hm : m.length≤L) : Shape L (n+1) (submitted m st) := by
  rcases h with ⟨ht,hs,he,hn,hms,hes⟩
  refine ⟨by exact ht.trans (Nat.le_succ n),?_,by exact he.trans (Nat.le_succ n),hn,?_,hes⟩
  · change (m::st.table.seen).length≤n+1
    simpa only [List.length_cons] using Nat.add_le_add_right hs 1
  · simpa only [submitted,ROM.submit,List.forall_mem_cons] using And.intro hm hms

theorem submitted_good (cs : List Rq) (st : State) (m : Bytes) (h : Good cs st) :
    Good cs (submitted m st) :=
  ⟨ROM.submit_good _ _ _ h.1,h.2⟩

theorem hash_shape (cs : List Rq) (x : Bytes) (st : State) (co : Rq × State)
    (L n : ℕ) (h : Shape L n st) (hx : x.length≤L) (hc : hashTargets cs x st=some co) :
    Shape L (n+1) (recordedHash x co.1 co.2) := by
  rcases h with ⟨ht,hs,he,hn,hms,hes⟩
  have hp:=(parse_message_length x).trans hx
  unfold hashTargets at hc
  split at hc
  · cases hc
    refine ⟨ht.trans (Nat.le_succ _),hs.trans (Nat.le_succ _),?_,hn,hms,?_⟩
    · change (Event.hash x _::st.events).length≤n+1
      simpa only [List.length_cons] using Nat.add_le_add_right he 1
    · simpa only [recordedHash,List.forall_mem_cons,eventMessage] using And.intro hx hes
  · split at hc
    · contradiction
    · cases hc
      refine ⟨?_,hs.trans (Nat.le_succ _),?_,?_,hms,?_⟩
      · simpa only [recordedHash,List.length_cons] using Nat.add_le_add_right ht 1
      · simpa only [recordedHash,List.length_cons] using Nat.add_le_add_right he 1
      · simpa only [recordedHash,List.forall_mem_cons] using And.intro hp hn
      · simpa only [recordedHash,List.forall_mem_cons,eventMessage] using And.intro hx hes

theorem programmed_shape (L n : ℕ) (st : State) (m : Bytes) (r : Nonce)
    (co : Rq × Option PublicSimulation.BoxVec) (h : Shape L n st) (hm : m.length≤L) :
    Shape L (n+1)
      (recordedSign m (some (r,co.2))
        ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩) := by
  rcases h with ⟨ht,hs,he,hn,hms,hes⟩
  refine ⟨?_,?_,?_,?_,?_,?_⟩
  · simpa only [recordedSign,List.length_cons] using Nat.add_le_add_right ht 1
  · simpa only [recordedSign,List.length_cons] using Nat.add_le_add_right hs 1
  · simpa only [recordedSign,List.length_cons] using Nat.add_le_add_right he 1
  · simpa only [recordedSign,List.forall_mem_cons] using And.intro hm hn
  · simpa only [recordedSign,List.forall_mem_cons] using And.intro hm hms
  · simpa only [recordedSign,List.forall_mem_cons,eventMessage] using And.intro hm hes

/- A self-delimiting reference representation uses nine bits per stored
byte (eight data bits plus continuation), fixed-width field/BoxVec payloads,
and unary target indices. It counts the complete history passed to S. -/
def targetBits : Option ℕ → ℕ
  | none => 1
  | some j => j+2

def entryBits (e : TableMachine.Entry) : ℕ :=
  9*(TableMachine.nameBytes e.name).length+24580+targetBits e.target

def eventBits : Event → ℕ
  | .hash x _ => 9*x.length+24580
  | .sign m _ => 9*m.length+26440

def stateBits (st : State) : ℕ :=
  (st.table.table.map entryBits).sum+
  (st.table.seen.map (fun m => 9*m.length+2)).sum+
  (st.events.map eventBits).sum+st.table.used+4

def itemBound (L targets : ℕ) : ℕ := 9*(L+41)+27000+targets
def stateBound (L n targets : ℕ) : ℕ := 3*n*itemBound L targets+targets+4

theorem stateBound_mono (L targets : ℕ) {n N : ℕ} (h : n≤N) :
    stateBound L n targets≤stateBound L N targets := by
  unfold stateBound
  exact Nat.add_le_add_right (Nat.add_le_add_right
    (Nat.mul_le_mul_right _ (Nat.mul_le_mul_left 3 h)) targets) 4

theorem programmed_good (cs : List Rq) (st : State) (m : Bytes) (r : Nonce)
    (co : Rq × Option PublicSimulation.BoxVec) (hg : Good cs st)
    (hm : ROM.lookup (some r,m) (submitted m st).table=none) :
    Good cs (recordedSign m (some (r,co.2))
      ⟨⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩,st.events⟩) := by
  have hsub:=ROM.submit_good (targets cs) m st.table hg.1
  have hprogram : ROM.program (some r,m) co.1 (ROM.submit m st.table)=
      some ⟨⟨(some r,m),co.1,none⟩::st.table.table,m::st.table.seen,st.table.used⟩ := by
    rw [ROM.program,show ROM.lookup (some r,m) (ROM.submit m st.table)=none from hm]
    rfl
  have hgood:=(ROM.program_good (targets cs) (some r,m) co.1 _ _ hsub
    (by simp [ROM.submit]) hprogram).1
  have huniq:=ROM.program_unique (some r,m) co.1 (ROM.submit m st.table) _
    (show ROM.Unique (ROM.submit m st.table) from hg.2.1) hprogram
  exact ⟨hgood,huniq,hg.2.2⟩

theorem sum_map_bound {α : Type} (xs : List α) (f : α → ℕ) (M : ℕ)
    (h : ∀ x∈xs,f x≤M) : (xs.map f).sum≤xs.length*M := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
    have hx:=h x (List.mem_cons_self ..)
    have ht:=ih (fun y hy => h y (List.mem_cons_of_mem _ hy))
    simp only [List.map_cons,List.sum_cons,List.length_cons,Nat.add_mul,Nat.one_mul]
    omega

theorem entryBits_bound (L : ℕ) (cs : List Rq) (st : State) (e : TableMachine.Entry)
    (hg : Good cs st) (he : e∈st.table.table) (hl : e.name.2.length≤L) :
    entryBits e ≤ itemBound L cs.length := by
  have hn:=TableMachine.nameBytes_length e.name
  have hgood:=hg.1 e he
  have hused:=hg.2.2
  cases ht : e.target with
  | none => simp only [entryBits,itemBound,targetBits,ht]; omega
  | some j =>
    simp only [ht] at hgood
    simp only [entryBits,itemBound,targetBits,ht]
    omega

theorem stateBits_bound (L n : ℕ) (cs : List Rq) (st : State)
    (h : Shape L n st) (hg : Good cs st) : stateBits st≤stateBound L n cs.length := by
  rcases h with ⟨ht,hs,he,hn,hms,hes⟩
  have htable:=sum_map_bound st.table.table entryBits (itemBound L cs.length)
    (fun e hm => entryBits_bound L cs st e hg hm (hn e hm))
  have hseen:=sum_map_bound st.table.seen (fun m => 9*m.length+2) (itemBound L cs.length) (by
    intro m hm
    have hx:=hms m hm
    dsimp only [itemBound]
    omega)
  have hevents:=sum_map_bound st.events eventBits (itemBound L cs.length) (by
    intro e hm
    have hx:=hes e hm
    cases e <;> simp only [eventBits,itemBound,eventMessage] at * <;> omega)
  have htabcap:=Nat.mul_le_mul_right (itemBound L cs.length) ht
  have hseencap:=Nat.mul_le_mul_right (itemBound L cs.length) hs
  have heventcap:=Nat.mul_le_mul_right (itemBound L cs.length) he
  have hu:=hg.2.2
  unfold stateBits stateBound
  nlinarith

end FT1536.Run2.StateResources
