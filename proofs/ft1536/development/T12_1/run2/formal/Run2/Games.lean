import Run2.FiniteDist
import Mathlib.Data.Fintype.Vector

namespace FT1536.Run2
open PublicSimulation
open FT1536.Relation
abbrev Byte := Fin 256
abbrev Bytes := List Byte
abbrev Nonce := List.Vector Byte 40
noncomputable instance nonceFinite : Fintype Nonce := Fintype.ofFinite Nonce
instance : Nonempty Nonce := ⟨List.Vector.replicate 40 0⟩
abbrev Reply := MathSign.Observation Nonce BoxVec
abbrev Table := ROM.State (Option Nonce) Bytes Rq
abbrev Name := ROM.Name (Option Nonce) Bytes

def frame (r : Nonce) (m : Bytes) : Bytes := r.val ++ m

def parse (x : Bytes) : Name :=
  if h : 40 ≤ x.length then
    (some ⟨x.take 40, by simp [List.length_take, Nat.min_eq_left h]⟩, x.drop 40)
  else (none,x)

def unparse (x : Name) : Bytes := match x.1 with
  | none => x.2
  | some r => frame r x.2

theorem unparse_parse (x : Bytes) : unparse (parse x) = x := by
  unfold parse
  split
  · exact List.take_append_drop 40 x
  · rfl

theorem parse_injective : Function.Injective parse := by
  intro x y h
  have hh := congrArg unparse h
  simpa only [unparse_parse] using hh

theorem parse_short (x : Bytes) (hx : x.length < 40) : parse x = (none,x) := by
  simp [parse,Nat.not_le.mpr hx]

theorem parse_frame (r : Nonce) (m : Bytes) : parse (frame r m) = (some r,m) := by
  have hr : r.val.length = 40 := r.property
  simp [parse, frame, List.length_append, hr]
  rfl

theorem nonce_card : Fintype.card Nonce = 2^320 := by
  rw [Fintype.card_congr (Equiv.vectorEquivFin Byte 40)]
  simp only [Fintype.card_fun, Fintype.card_fin]
  calc
    256^40 = (2^8)^40 := rfl
    _ = 2^(8*40) := (pow_mul 2 8 40).symm
    _ = 2^320 := congrArg (fun n : ℕ => 2^n) (by decide)

theorem framing_injective (m : Bytes) : Function.Injective (fun r : Nonce => frame r m) := by
  intro r s h
  have hh := congrArg parse h
  simpa only [parse_frame, Prod.mk.injEq, Option.some.injEq, and_true] using hh

structure Forgery where
  message : Bytes
  nonce : Bytes
  signature : BoxVec

inductive Event where
  | hash : Bytes → Rq → Event
  | sign : Bytes → Reply → Event

structure State where
  table : Table
  events : List Event

def initial : State := ⟨ROM.empty,[]⟩

/- Query counts are structural, not an assumed global advantage bound.
Every branch after a Sign has one fewer Sign token, irrespective of abort. -/
inductive Program : ℕ → ℕ → Type
  | done {s h} : Forgery → Program s h
  | hash {s h} : Bytes → (Rq → Program s h) → Program s (h+1)
  | sign {s h} : Bytes → (Reply → Program s h) → Program (s+1) h

structure Budget where
  qs : ℕ
  qh : ℕ
  coinBits : ℕ
  bytes : ℕ

structure ClassicalAdversary (beta : Budget) where
  code : Rq → (Fin beta.coinBits → Bool) → Program beta.qs beta.qh

/- Full public sampler interface on a fixed FAIR-BIT tape. A function alone
does not supply a cost certificate; computational binding is kept separate. -/
structure Sampler where
  bits : ℕ
  code : Rq → State → Bytes → Nonce → (Fin bits → Bool) → Rq × Option BoxVec

noncomputable def sample (S : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    Dist (Rq × Option BoxVec) := (Dist.draw Law.uniform).map (S.code h st m r)

namespace Games
noncomputable def hashHonest (x : Bytes) (st : State) : Dist (Rq × State) :=
  match ROM.lookup (parse x) st.table with
  | some e => Dist.pure (e.value,st)
  | none => (Dist.draw (Law.uniform : Law Rq)).map fun c =>
      (c, ⟨⟨⟨parse x,c,some st.table.used⟩ :: st.table.table,st.table.seen,
        st.table.used+1⟩,st.events⟩)

/- Fixed finite list: no infinitely available challenge function at runtime. -/
def hashTargets (cs : List Rq) (x : Bytes) (st : State) : Option (Rq × State) :=
  match ROM.lookup (parse x) st.table with
  | some e => some (e.value,st)
  | none => match cs[st.table.used]? with
    | none => none
    | some c => some (c, ⟨⟨⟨parse x,c,some st.table.used⟩ :: st.table.table,
        st.table.seen,st.table.used+1⟩,st.events⟩)

def submitted (m : Bytes) (st : State) : State := {st with table := ROM.submit m st.table}
def recordedHash (x : Bytes) (c : Rq) (st : State) : State :=
  {st with events := Event.hash x c :: st.events}
def recordedSign (m : Bytes) (o : Reply) (st : State) : State :=
  {st with events := Event.sign m o :: st.events}

def programmedReply (st : State) (m : Bytes) (r : Nonce) (co : Rq × Option BoxVec) :
    Option (Reply × State) :=
  let o : Reply := some (r,co.2)
  let tab : Table := ⟨⟨(some r,m),co.1,none⟩ :: st.table.table,st.table.seen,st.table.used⟩
  some (o,recordedSign m o ⟨tab,st.events⟩)

noncomputable def signHonest (h : Rq) (st : State) (m : Bytes) (stop : Bool) :
    Dist (Option (Reply × State)) :=
  let st := submitted m st
  (Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
    match ROM.lookup (parse (frame r m)) st.table with
    | some e => if stop then Dist.pure none else
        (Dist.draw (signBody (SigmaMath.syndrome h) e.value)).map fun o =>
          some (some (r,o),recordedSign m (some (r,o)) st)
    | none => (Dist.draw (SigmaMath.freshHonest h)).map (programmedReply st m r)

noncomputable def signSim (S : Sampler) (h : Rq) (st : State) (m : Bytes) :
    Dist (Option (Reply × State)) :=
  let st := submitted m st
  (Dist.draw (Law.uniform : Law Nonce)).bind fun r =>
    match ROM.lookup (parse (frame r m)) st.table with
    | some _ => Dist.pure none
    | none => (sample S h st m r).map (programmedReply st m r)

structure Finished where
  forgery : Forgery
  state : State

noncomputable def honest (h : Rq) (st : State) (stop : Bool) :
    {s q : ℕ} → Program s q → Dist (Option Finished)
  | _,_,.done f => Dist.pure (some ⟨f,st⟩)
  | _,_,.hash x k => (hashHonest x st).bind fun cs =>
      honest h (recordedHash x cs.1 cs.2) stop (k cs.1)
  | _,_,.sign m k => (signHonest h st m stop).bind fun o => match o with
      | none => Dist.pure none
      | some os => honest h os.2 stop (k os.1)

noncomputable def simulate (S : Sampler) (h : Rq) (cs : List Rq) (st : State) :
    {s q : ℕ} → Program s q → Dist (Option Finished)
  | _,_,.done f => Dist.pure (some ⟨f,st⟩)
  | _,_,.hash x k => match hashTargets cs x st with
      | none => Dist.pure none
      | some ys => simulate S h cs (recordedHash x ys.1 ys.2) (k ys.1)
  | _,_,.sign m k => (signSim S h st m).bind fun o => match o with
      | none => Dist.pure none
      | some os => simulate S h cs os.2 (k os.1)

noncomputable def accepted (h c : Rq) (f : Forgery) : Bool := by
  classical
  exact decide (Verify h c (decodeVec f.signature))

noncomputable def finishHonest (h : Rq) : Option Finished → Dist Bool
  | none => Dist.pure false
  | some f =>
      if f.forgery.message ∈ f.state.table.seen ∨ f.forgery.nonce.length ≠ 40 then Dist.pure false
      else (hashHonest (f.forgery.nonce ++ f.forgery.message) f.state).map fun co =>
        accepted h co.1 f.forgery

abbrev Witness := ℕ × (Geometry.Vec × Geometry.Vec)

noncomputable def finishSim (h : Rq) (cs : List Rq) : Option Finished → Option Witness
  | none => none
  | some f =>
      if f.forgery.message ∈ f.state.table.seen ∨ f.forgery.nonce.length ≠ 40 then none
      else match hashTargets cs (f.forgery.nonce ++ f.forgery.message) f.state with
      | none => none
      | some co => if accepted h co.1 f.forgery then
          match ROM.lookup (parse (f.forgery.nonce ++ f.forgery.message)) co.2.table with
          | none => none
          | some e => e.target.map fun j => (j,extract h co.1 (decodeVec f.forgery.signature))
        else none

noncomputable def runEUF {SK : Type} [Fintype SK] (beta : Budget)
    (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta) (stop : Bool := false) : Dist Bool :=
  (Dist.draw muKey).bind fun key =>
    (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
      (honest key.2 initial stop (A.code key.2 coins)).bind (finishHonest key.2)

structure MTAdversary (T : ℕ) where
  code : Rq → List.Vector Rq T → Dist (Option Witness)

noncomputable def runMT (T : ℕ) (muH : Law Rq) (B : MTAdversary T) : Dist Bool := by
  classical
  exact (Dist.draw muH).bind fun h =>
    (Dist.draw (Law.uniform : Law (List.Vector Rq T))).bind fun cs =>
      (B.code h cs).map fun w => match w with
        | none => false
        | some (j,z) => match cs.val[j]? with
          | none => false
          | some c => decide (ShortPreimage h c z)

noncomputable def AdvEUF {SK : Type} [Fintype SK] (beta : Budget)
    (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta) : ℝ :=
  (runEUF beta muKey A).event (fun b => b = true)

noncomputable def AdvMT (T : ℕ) (muH : Law Rq) (B : MTAdversary T) : ℝ :=
  (runMT T muH B).event (fun b => b = true)

end Games
namespace Reduction
noncomputable def build (beta : Budget) (A : ClassicalAdversary beta) (S : Sampler) :
    Games.MTAdversary (beta.qh+1) where
  code h cs := (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
    (Games.simulate S h cs.val initial (A.code h coins)).map (Games.finishSim h cs.val)
end Reduction
end FT1536.Run2
