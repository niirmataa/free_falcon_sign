import TrialFinish020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.TrialCorrect020A
open WordRAM020 PairProgram020 ReadSemantics020A BitValue020A CdfPrefix020A TrialFinish020A
open FT1536.Relation JointInterface019
attribute [local irreducible] exec StandaloneRuntime019.coord

def coinsAt (i : Input) (b : Nat) : StandaloneRuntime019.PairBits :=
  (fun j => tapeBits i (b+j.val), (fun j => tapeBits i (b+384+j.val),fun j => tapeBits i (b+768+j.val)))
def xi (i : Input) (b : Nat) : Fin 30721 := StandaloneRuntime019.coord StandaloneRuntime019.tables (coinsAt i b).1
def yi (i : Input) (b : Nat) : Fin 30721 := StandaloneRuntime019.coord StandaloneRuntime019.tables (coinsAt i b).2.1

def encoded (z : StandaloneRuntime019.Block) : Word × Word :=
  (word ((z.1.val : Int)-65535),word ((z.2.val : Int)-65535))
def answer (s : State) : Option (Word × Word) := if s.reg 15=0 then none else some (s.reg 13,s.reg 14)

theorem embed_encoded (x y : Fin 30721) : encoded (StandaloneRuntime019.embedCoord x,StandaloneRuntime019.embedCoord y)=
    (word ((x.val : Int)-15360),word ((y.val : Int)-15360)) := by
  apply Prod.ext
  · change word (((x.val+50175 : Nat) : Int)-65535)=word ((x.val : Int)-15360)
    apply congrArg word
    push_cast
    ring
  · change word (((y.val+50175 : Nat) : Int)-65535)=word ((y.val : Int)-15360)
    apply congrArg word
    push_cast
    ring

theorem reference_trial (i : Input) (b : Nat) :
    (StandaloneRuntime019.pairTrial StandaloneRuntime019.tables (coinsAt i b)).map encoded =
      if value (tapeBits i) 256 (b+768)<threshold (xi i b) (yi i b) then
        some (word (((xi i b).val : Int)-15360),word (((yi i b).val : Int)-15360)) else none := by
  unfold StandaloneRuntime019.pairTrial StandaloneRuntime019.word
  change (if StandaloneRuntime019.value 256 (fun j => tapeBits i (b+768+j.val)) < threshold (xi i b) (yi i b)
    then some (StandaloneRuntime019.embedCoord (xi i b),StandaloneRuntime019.embedCoord (yi i b)) else none).map encoded = _
  rw [reference_value]
  split_ifs
  · rw [Option.map_some,embed_encoded]
  · rfl

theorem finish_answer (s : State) (x y : Fin 30721) (u k : Nat) (h15 : s.reg 15=0) :
    answer (finishState s x y u k)=if u<threshold x y then
      some (word ((x.val : Int)-15360),word ((y.val : Int)-15360)) else none := by
  have hOne : word 1≠0 := by decide
  by_cases hc : u<threshold x y
  · simp [answer,finishState,hc,put]
    exact hOne
  · simp [answer,finishState,hc,put,h15]

theorem finish_counter (s : State) (x y : Fin 30721) (u k : Nat) :
    (finishState s x y u k).reg 2=nw (k+1) := put_same _ _ _

theorem finish_frame (s : State) (x y : Fin 30721) (u k : Nat) : Frame s (finishState s x y u k) := by
  unfold finishState
  split <;> exact ⟨rfl,rfl,rfl⟩

theorem finish_register (s : State) (x y : Fin 30721) (u k : Nat) (r : Reg)
    (hr : r.val<2 ∨ 15<r.val) : (finishState s x y u k).reg r=s.reg r := by
  have hn (j : Reg) (hj : 2≤j.val ∧ j.val≤15) : r≠j := by intro he;subst j;omega
  unfold finishState
  split
  · simp [put,Function.update,hn 2 (by decide),hn 12 (by decide),hn 13 (by decide),hn 14 (by decide),hn 15 (by decide)]
  · simp [put,Function.update,hn 2 (by decide),hn 12 (by decide)]

theorem trial_shape (i : Input) (s : State) : exec i trial s=exec i finishCode (exec i TrialRead020A.readPrefix s) := by
  simp only [trial,finishCode,TrialRead020A.readPrefix,exec_seqs_cons,exec_seqs_nil]
  rfl

/-- The WHOLE actual trial: both CDF draws, fresh acceptance bits, real threshold,
    both outcomes and retry advance. The source result is NOT a premise. -/
theorem trial_correct (h : Rq) (tape : Bits tapeSize) (s : State) (n p k : Nat)
    (hn : n<196) (hp : p<1536) (hk : k<80)
    (h0 : s.reg 0=nw n) (h1 : s.reg 1=nw p) (h2 : s.reg 2=nw k) (h15 : s.reg 15=0) :
    let i := InputLayout020.encode h tape
    let b := TrialAddress020A.base n p k
    let t := exec i trial s
    answer t=(StandaloneRuntime019.pairTrial StandaloneRuntime019.tables (coinsAt i b)).map encoded ∧
      t.reg 2=nw (k+1) ∧ Frame s t ∧
      ∀ r : Reg, (r.val<2 ∨ 15<r.val) → r≠30 → t.reg r=s.reg r := by
  let i := InputLayout020.encode h tape
  let b := TrialAddress020A.base n p k
  let q := exec i TrialRead020A.readPrefix s
  let u := value (tapeBits i) 256 (b+768)
  have pr := TrialRead020A.read_correct h tape s n p k hn hp hk h0 h1 h2
  have q2 : q.reg 2=nw k := (pr.2.2.2.2 2 (by decide) (by decide)).trans h2
  have q15 : q.reg 15=0 := (pr.2.2.2.2 15 (by decide) (by decide)).trans h15
  have fin := finish_correct h tape q (xi i b) (yi i b) u k (value_lt _ _ _) hk pr.1 pr.2.1 pr.2.2.1 q2
  have he : exec i trial s=finishState q (xi i b) (yi i b) u k := by rw [trial_shape,fin]
  dsimp only
  rw [he]
  refine ⟨?_,finish_counter _ _ _ _ _,frame_trans pr.2.2.2.1 (finish_frame _ _ _ _ _),?_⟩
  · rw [reference_trial,finish_answer _ _ _ _ _ q15]
  · intro r hr hr30
    exact (finish_register q (xi i b) (yi i b) u k r hr).trans (pr.2.2.2.2 r (by omega) hr30)

end FT1536.S05.TrialCorrect020A
