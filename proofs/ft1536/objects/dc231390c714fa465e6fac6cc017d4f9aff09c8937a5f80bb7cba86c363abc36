import Run2.StateResources

namespace FT1536.Run2.PublicEncoding
open Games FT1536.Relation PublicSimulation BitArithmetic StateResources FileVerifier

def bytes (xs : Bytes) : List Bool :=
  (xs.flatMap fun b => true::encodeNat b.val 8)++[false]

theorem bytes_length (xs : Bytes) : (bytes xs).length=9*xs.length+1 := by
  induction xs with
  | nil => rfl
  | cons b xs ih =>
    simp only [bytes,List.flatMap_cons,List.length_append,List.length_cons,encodeNat_length] at *
    omega

def field (a : Rq) : List Bool := (fieldEncoding a).flatten

theorem field_length (a : Rq) : (field a).length=24576 := by
  simp only [field,fieldEncoding,List.length_flatten,List.map_ofFn,List.sum_ofFn,Function.comp_def,encodeNat_length]
  simp only [Finset.sum_const,Finset.card_univ,Fintype.card_fin,smul_eq_mul]

def signature (s : BoxVec) : List Bool :=
  (signatureEncoding s).flatMap fun w => w.negative::w.magnitude

theorem signature_length (s : BoxVec) : (signature s).length=26112 := by
  simp only [signature,signatureEncoding,List.length_flatMap,List.map_ofFn,List.sum_ofFn,
    Function.comp_def,List.length_cons,encodeSigned_length]
  simp only [Finset.sum_const,Finset.card_univ,Fintype.card_fin,smul_eq_mul]

def nonce (r : Nonce) : List Bool := r.val.flatMap fun b => encodeNat b.val 8

theorem nonce_length (r : Nonce) : (nonce r).length=320 := by
  simp only [nonce,List.length_flatMap]
  have hm : (r.val.map fun b => (encodeNat b.val 8).length).sum=8*r.val.length := by
    simp only [encodeNat_length,List.map_const',List.sum_replicate,smul_eq_mul]
    omega
  simpa only [r.property] using hm

def target : Option ℕ → List Bool
  | none => [false]
  | some n => true::(List.replicate n true++[false])

theorem target_length (n : Option ℕ) : (target n).length=targetBits n := by
  cases n <;> simp [target,targetBits,List.length_replicate]

def entry (e : TableMachine.Entry) : List Bool :=
  bytes (TableMachine.nameBytes e.name)++field e.value++target e.target

theorem entry_length (e : TableMachine.Entry) : (entry e).length+1≤entryBits e := by
  simp only [entry,List.length_append,bytes_length,field_length,target_length,entryBits]
  omega

def reply : Reply → List Bool
  | none => [false]
  | some (r,none) => true::(nonce r++[false])
  | some (r,some s) => true::(nonce r++true::signature s)

theorem reply_length (o : Reply) : (reply o).length≤26434 := by
  cases o with
  | none => decide
  | some o =>
    obtain ⟨r,o⟩:=o
    cases o <;> simp only [reply,List.length_cons,List.length_append,List.length_nil,nonce_length,signature_length] <;> omega

def event : Event → List Bool
  | .hash x c => false::(bytes x++field c)
  | .sign m o => true::(bytes m++reply o)

theorem event_length (e : Event) : (event e).length+1≤eventBits e := by
  cases e with
  | hash x c =>
    simp only [event,List.length_cons,List.length_append,bytes_length,field_length,eventBits]
    omega
  | sign m o =>
    have hr:=reply_length o
    simp only [event,List.length_cons,List.length_append,bytes_length,eventBits]
    omega

def sequence {α : Type} (f : α → List Bool) : List α → List Bool
  | [] => [false]
  | x::xs => true::(f x++sequence f xs)

theorem sequence_bound {α : Type} (f : α → List Bool) (xs : List α) (cost : α → ℕ)
    (h : ∀ x∈xs,(f x).length+1≤cost x) :
    (sequence f xs).length≤(xs.map cost).sum+1 := by
  induction xs with
  | nil => simp [sequence]
  | cons x xs ih =>
    have hx:=h x (List.mem_cons_self ..)
    have ht:=ih (fun y hy => h y (List.mem_cons_of_mem _ hy))
    simp only [sequence,List.length_cons,List.length_append,List.map_cons,List.sum_cons]
    omega

def state (st : State) : List Bool :=
  sequence entry st.table.table++sequence bytes st.table.seen++sequence event st.events++
    List.replicate st.table.used true++[false]

theorem state_length (st : State) : (state st).length≤stateBits st := by
  have ht:=sequence_bound entry st.table.table entryBits (fun e _ => entry_length e)
  have hs:=sequence_bound bytes st.table.seen (fun m => 9*m.length+2) (by
    intro m _; rw [bytes_length])
  have he:=sequence_bound event st.events eventBits (fun e _ => event_length e)
  simp only [state,List.length_append,List.length_replicate,List.length_cons,List.length_nil,stateBits]
  omega

def samplerInput (S : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce)
    (coins : Fin S.bits → Bool) : List Bool :=
  field h++state st++bytes m++nonce r++List.ofFn coins

def samplerOutput (o : Rq × Option BoxVec) : List Bool :=
  field o.1++match o.2 with | none => [false] | some s => true::signature s

theorem samplerInput_length (S : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce)
    (coins : Fin S.bits → Bool) :
    (samplerInput S h st m r coins).length≤24900+stateBits st+9*m.length+S.bits := by
  have hs:=state_length st
  simp only [samplerInput,List.length_append,field_length,bytes_length,nonce_length,List.length_ofFn]
  omega

theorem samplerOutput_length (o : Rq × Option BoxVec) : (samplerOutput o).length≤50689 := by
  unfold samplerOutput
  cases o.2 <;> simp only [List.length_append,field_length,List.length_cons,List.length_nil,signature_length] <;> omega

end FT1536.Run2.PublicEncoding
