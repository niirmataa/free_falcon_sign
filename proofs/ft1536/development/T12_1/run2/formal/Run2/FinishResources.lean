import Run2.PrefixResources

namespace FT1536.Run2.FinishResources
open Games FT1536.Relation PublicSimulation StateResources LocalMachineCode
open FT1536.BitCost MachineAccounting MeteredExecution FileVerifier FileArithmetic BitArithmetic

/- Final extraction emits finite signed-word files. decodeWords is only
their mathematical denotation; no infinite vector oracle runs at the port. -/
structure FileWitness where
  index : ℕ
  left : List SignedWord
  right : List SignedWord

def FileWitness.meaning (w : FileWitness) : Witness :=
  (w.index,(BitFinish.decodeWords w.left,BitFinish.decodeWords w.right))
def signedBits (ws : List SignedWord) : List Bool := ws.flatMap fun w => w.negative::w.magnitude
def FileWitness.bits (w : FileWitness) : List Bool :=
  PublicEncoding.target (some w.index)++signedBits w.left++signedBits w.right
def extracted (h c : Rq) (s : BoxVec) (j : ℕ) : FileWitness :=
  ⟨j,residual (fieldEncoding h) (fieldEncoding c) (signatureEncoding s),signatureEncoding s⟩

theorem extracted_meaning (h c : Rq) (s : BoxVec) (j : ℕ) :
    (extracted h c s j).meaning=(j,BitFinish.extract h c s) := by
  simp only [extracted,FileWitness.meaning,BitFinish.extract]

theorem signedBits_bound (ws : List SignedWord) (hw : ∀ w∈ws,w.magnitude.length≤16) :
    (signedBits ws).length≤17*ws.length := by
  induction ws with
  | nil => simp [signedBits]
  | cons w ws ih =>
    have hh:=hw w (List.mem_cons_self ..)
    have ht:=ih (fun x hx => hw x (List.mem_cons_of_mem _ hx))
    simp only [signedBits,List.flatMap_cons,List.length_append,List.length_cons] at ht ⊢
    omega

theorem extracted_length (h c : Rq) (s : BoxVec) (j : ℕ) :
    (extracted h c s j).bits.length≤j+52226 := by
  have hl:=signedBits_bound (residual (fieldEncoding h) (fieldEncoding c) (signatureEncoding s))
    (centeredFile_word_length _ _)
  have hr:=signedBits_bound (signatureEncoding s) (signatureEncoding_width s)
  have hn : (residual (fieldEncoding h) (fieldEncoding c) (signatureEncoding s)).length=1536 := by
    simp only [FileVerifier.residual,resultWords,centeredFile,List.length_map,List.length_ofFn]
  rw [hn] at hl
  rw [signatureEncoding_length] at hr
  simp only [FileWitness.bits,extracted,List.length_append,PublicEncoding.target_length,targetBits]
  omega

def residualSteps (hs cs : List (List Bool)) (ss : List SignedWord) : ℕ :=
  fieldFileSteps (reducedFile ss)+PolynomialMachine.multiplyFileSteps (polynomialInput hs ss)+
    signedFileSteps (centeredFile cs (product hs ss))
def residualAllocation (hs cs : List (List Bool)) (ss : List SignedWord) : ℕ :=
  VerifierAllocation.reduceFile ss+VerifierAllocation.multiplyFile (polynomialInput hs ss)+
    VerifierAllocation.centeredFile cs (product hs ss)

theorem residualSteps_le (hs cs : List (List Bool)) (ss : List SignedWord) :
    residualSteps hs cs ss≤decisionSteps hs cs ss := by
  simp only [residualSteps,decisionSteps]
  omega
theorem residualAllocation_le (hs cs : List (List Bool)) (ss : List SignedWord) :
    residualAllocation hs cs ss≤32*residualSteps hs cs ss := by
  have hr:=VerifierAllocation.reduceFile_bound ss
  have hm:=VerifierAllocation.multiplyFile_bound (polynomialInput hs ss)
  have hc:=VerifierAllocation.centeredFile_bound cs (product hs ss)
  unfold residualAllocation residualSteps
  omega

def arithmetic (h c : Rq) (s : BoxVec) : Cost :=
  let hs:=fieldEncoding h
  let cs:=fieldEncoding c
  let ss:=signatureEncoding s
  primitive (decisionSteps hs cs ss+residualSteps hs cs ss)
    (VerifierAllocation.decision hs cs ss+residualAllocation hs cs ss)

theorem arithmetic_bound (h c : Rq) (s : BoxVec) : arithmetic h c s≤⟨2^67,2^72,0⟩ := by
  have hd:=concrete_bit_verifier_steps h c s
  have hr:=(residualSteps_le (fieldEncoding h) (fieldEncoding c) (signatureEncoding s)).trans hd
  have ha:=VerifierAllocation.concrete_decision_bound h c s
  have hb:=(residualAllocation_le (fieldEncoding h) (fieldEncoding c) (signatureEncoding s)).trans
    (Nat.mul_le_mul_left 32 hr)
  change _≤_ ∧ _≤_ ∧ _≤_
  dsimp only [arithmetic,primitive]
  exact ⟨by omega,by omega,le_rfl⟩

def finalTarget (cs : List Rq) (f : Finished) : Rq × State :=
  (TableMachine.hash cs (f.forgery.nonce++f.forgery.message) f.state).1.getD (0,f.state)
def finalEntry (cs : List Rq) (f : Finished) : Option TableMachine.Entry :=
  (TableMachine.lookup (parse (f.forgery.nonce++f.forgery.message)) (finalTarget cs f).2.table.table).1
def finalIndex (cs : List Rq) (f : Finished) : ℕ := ((finalEntry cs f).bind (·.target)).getD 0

/- An eager public finishing schedule. It materializes the hash/fallback,
verification, extraction and prospective output file even on a rejecting
branch, then emits none if any test fails. This deliberate padding makes
all intermediate work explicit; the next lemma proves the same result. -/
def fileFinish (h : Rq) (cs : List Rq) (f : Finished) : Option FileWitness :=
  if (TableMachine.seen f.forgery.message f.state.table.seen).1 || decide (f.forgery.nonce.length≠40) then none
  else match (TableMachine.hash cs (f.forgery.nonce++f.forgery.message) f.state).1 with
    | none => none
    | some co => if BitFinish.accepted h co.1 f.forgery then
        ((TableMachine.lookup (parse (f.forgery.nonce++f.forgery.message)) co.2.table.table).1.bind (·.target)).map
          (extracted h co.1 f.forgery.signature)
      else none

theorem fileFinish_correct (h : Rq) (cs : List Rq) (f : Finished) :
    (fileFinish h cs f).map FileWitness.meaning=BitFinish.finish h cs (some f) := by
  by_cases hb : ((TableMachine.seen f.forgery.message f.state.table.seen).1 ||
      decide (f.forgery.nonce.length≠40))=true
  · simp only [fileFinish,BitFinish.finish,hb,ite_true,Option.map_none]
  · simp only [fileFinish,BitFinish.finish,hb,Bool.false_eq_true,ite_false]
    cases hc : (TableMachine.hash cs (f.forgery.nonce++f.forgery.message) f.state).1 with
    | none => rfl
    | some co =>
      by_cases hv : BitFinish.accepted h co.1 f.forgery=true
      · simp only [hv,ite_true]
        cases he : (TableMachine.lookup (parse (f.forgery.nonce++f.forgery.message)) co.2.table.table).1 with
        | none => rfl
        | some e => simp only [Option.bind_some,Option.map_map,Function.comp_def,extracted_meaning]
      · simp only [hv,Bool.false_eq_true,ite_false,Option.map_none]

def finalCost (h : Rq) (cs : List Rq) (f : Finished) : Cost :=
  let x:=f.forgery.nonce++f.forgery.message
  let co:=finalTarget cs f
  let files:=(extracted h co.1 f.forgery.signature (finalIndex cs f)).bits
  plus (frameCost f.state f.state (.done f.forgery))
    (plus (frameCost f.state co.2 (.done f.forgery))
      (plus (primitive
        ((TableMachine.seen f.forgery.message f.state.table.seen).2+
          (TableMachine.hash cs x f.state).2+(TableMachine.lookup (parse x) co.2.table.table).2+
          f.forgery.nonce.length+16)
        (TableAllocation.seen f.forgery.message f.state.table.seen+
          TableAllocation.hash cs x f.state+TableAllocation.lookup (parse x) co.2.table.table+
          f.forgery.nonce.length+512))
        (plus (arithmetic h co.1 f.forgery.signature) (transport files))))

def finalBound (beta : Budget) : Cost :=
  let p:=MachineAccounting.hashBound beta.bytes (beta.qs+beta.qh+1) (beta.qh+1)+
    2*MachineAccounting.lookupBound beta.bytes (beta.qs+beta.qh+1)+beta.bytes+16
  let out:=beta.qh+1+52226
  plus (frameBound beta) (plus (frameBound beta)
    (plus ⟨p,32*p,0⟩ (plus ⟨2^67,2^72,0⟩ ⟨16*out+1,16*out,out⟩)))

theorem shape_unrecorded (L n : ℕ) (st : State) (x : Bytes) (c : Rq)
    (hs : Shape L n (recordedHash x c st)) : Shape L n st := by
  rcases hs with ⟨ht,hn,he,hname,hseen,hev⟩
  refine ⟨ht,hn,?_,hname,hseen,?_⟩
  · change (Event.hash x c::st.events).length≤n at he
    simp only [List.length_cons] at he
    omega
  · intro e hm
    exact hev e (List.mem_cons_of_mem _ hm)

theorem finalTarget_good (beta : Budget) (cs : List.Vector Rq (beta.qh+1)) (f : Finished)
    (hv : PrefixResources.ValidFinished beta cs.val (some f)) :
    Good cs.val (finalTarget cs.val f).2 ∧
      Shape beta.bytes (beta.qs+beta.qh+1) (finalTarget cs.val f).2 := by
  rw [finalTarget,TableMachine.hash_correct]
  cases hc : hashTargets cs.val (f.forgery.nonce++f.forgery.message) f.state with
  | none => exact ⟨hv.2.1,shape_mono beta.bytes (by omega) _ hv.1⟩
  | some co =>
    have hx : (f.forgery.nonce++f.forgery.message).length≤beta.bytes := by
      simp only [List.length_append]; have hh:=hv.2.2; omega
    have hs:=hash_shape cs.val _ f.state co beta.bytes (beta.qs+beta.qh) hv.1 hx hc
    exact ⟨(hashTargets_good cs.val _ f.state co hv.2.1 hc).1,shape_unrecorded _ _ co.2 _ _ hs⟩

theorem finalIndex_bound (beta : Budget) (cs : List.Vector Rq (beta.qh+1)) (f : Finished)
    (hv : PrefixResources.ValidFinished beta cs.val (some f)) : finalIndex cs.val f≤beta.qh+1 := by
  have hg:=(finalTarget_good beta cs f hv).1
  have hu : (finalTarget cs.val f).2.table.used≤beta.qh+1 := by simpa only [cs.property] using hg.2.2
  unfold finalIndex finalEntry
  rw [TableMachine.lookup_correct]
  cases he : ROM.lookup (parse (f.forgery.nonce++f.forgery.message)) (finalTarget cs.val f).2.table with
  | none => simp
  | some e =>
    have hh:=hg.1 e (ROM.lookup_mem _ _ e he).1
    cases hj : e.target with
    | none => simp [hj]
    | some j =>
      simp only [hj] at hh
      simp only [Option.bind_some,hj,Option.getD_some]
      omega

theorem finalCost_bound (beta : Budget) (h : Rq) (cs : List.Vector Rq (beta.qh+1)) (f : Finished)
    (hv : PrefixResources.ValidFinished beta cs.val (some f)) : finalCost h cs.val f≤finalBound beta := by
  have hg:=finalTarget_good beta cs f hv
  have hs:=state_cap beta cs f.state (beta.qs+beta.qh) hv.1 hv.2.1 (by omega)
  have hn:=state_cap beta cs (finalTarget cs.val f).2 (beta.qs+beta.qh+1) hg.2 hg.1 le_rfl
  have hcmd : (commandBits (.done f.forgery)).length≤AdversaryMachine.outputCap beta :=
    AdversaryMachine.headBits_length beta (.done f.forgery : Program 0 0) hv.2.2
  rcases frame_bound beta f.state f.state (.done f.forgery) hs hs hcmd with ⟨hft,hfw,hfL⟩
  rcases frame_bound beta f.state (finalTarget cs.val f).2 (.done f.forgery) hs hn hcmd with ⟨hgt,hgw,hgL⟩
  have hx : (f.forgery.nonce++f.forgery.message).length≤beta.bytes := by
    simp only [List.length_append]; have hh:=hv.2.2; omega
  have hm : f.forgery.message.length≤beta.bytes := by have hh:=hv.2.2; omega
  have hr : f.forgery.nonce.length≤beta.bytes := by have hh:=hv.2.2; omega
  have ht : f.state.table.table.length≤beta.qs+beta.qh+1 := hv.1.1.trans (by omega)
  have hseen:=MachineAccounting.seen_bound beta.bytes (beta.qs+beta.qh+1) f.forgery.message f.state
    (hv.1.2.1.trans (by omega)) hm
  have hhash:=MachineAccounting.hash_bound beta.bytes (beta.qs+beta.qh+1) (beta.qh+1) cs.val
    (f.forgery.nonce++f.forgery.message) f.state ht (by simpa only [cs.property] using hv.2.1.2.2) hx
  have hl:=MachineAccounting.lookup_bound beta.bytes (beta.qs+beta.qh+1)
    (parse (f.forgery.nonce++f.forgery.message)) (finalTarget cs.val f).2 hg.2.1
    ((parse_message_length _).trans hx)
  have as':=TableAllocation.seen_bound f.forgery.message f.state.table.seen
  have ah:=TableAllocation.hash_bound cs.val (f.forgery.nonce++f.forgery.message) f.state
  have al:=TableAllocation.lookup_bound (parse (f.forgery.nonce++f.forgery.message)) (finalTarget cs.val f).2.table.table
  rcases arithmetic_bound h (finalTarget cs.val f).1 f.forgery.signature with ⟨hat,haw,haL⟩
  dsimp only at hat haw haL
  have hj:=finalIndex_bound beta cs f hv
  have ho:=extracted_length h (finalTarget cs.val f).1 f.forgery.signature (finalIndex cs.val f)
  change _≤_ ∧ _≤_ ∧ _≤_
  dsimp only [finalCost,finalBound,plus,primitive]
  rw [transport_exact]
  dsimp only
  omega

end FT1536.Run2.FinishResources

#print axioms FT1536.Run2.FinishResources.fileFinish_correct
#print axioms FT1536.Run2.FinishResources.finalCost_bound
