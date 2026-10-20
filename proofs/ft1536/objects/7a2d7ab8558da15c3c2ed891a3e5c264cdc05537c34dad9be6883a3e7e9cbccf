import FftBind.FftPin
import FftBind.FftGeometry
import Source3.StableBinary

/- Project Niirmata — C_TASK_1_BINBIND / warstwa FFT-NTT.
Semantyka wywołań FFT: makra zespolone FPC_* (falcon-fft.c:55-148) jako
ZPARSOWANE programy wywołań fpr + ich typed execution na stanie
pamięć+zdarzenia (styl Source3). Kontrakt wyjścia dla okna analizy błędów
FPEMU (C_TASK_2_FPERROR): kolejność i argumenty wywołań fpr, ramki pamięci.

GRANICE (anti-collision, decyzja właściciela 2026-09-29):
- wykonanie i kontrakt zaokrągleń fpr_add/mul/div = okno C_TASK_2_FPERROR —
  tutaj wyłącznie SYGNATURY hooków (FftCalls), bez implementacji;
- fpr_half/fpr_double = LINKOWANE wykonanie Source3.StableBinary (parsera
  Sola nie duplikujemy);
- kompozycja KeyGen (ft_keygen_leaf_certificate, stable top/binary, reverse
  reciprocal, caller Frame) = obowiązek Sola — nie ruszam.
Komentarze C ani RN binary64 NIE są założeniami tego modelu. -/

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.FftBind.FftSem
open FT1536.Source3 B20.C
open FT1536.Source3.StableBinary (Event)

abbrev Word := BitVec 64
abbrev Addr := Nat

/-- Obiekt `fpr` = 8 bajtów pod adresem; adresy to przesunięcia bajtowe
(konwencja Source3.StableBinary.addr). -/
def addr (base i : Nat) : Nat := base + 8 * i

/-- Sygnatury wywołań fpr — KONTRAKT dla Warstwy 2 (C_TASK_2_FPERROR).
Pola add/sub/mul/div/sqr/neg/inv/ofInt/inverseOf/scaled są parametrami:
to okno NIE implementuje ich wykonania ani zaokrągleń. -/
structure FftCalls where
  add : Word → Word → Option Word
  sub : Word → Word → Option Word
  mul : Word → Word → Option Word
  div : Word → Word → Option Word
  sqr : Word → Option Word
  neg : Word → Option Word
  inv : Word → Option Word
  ofInt : Word → Option Word
  inverseOf : Word → Option Word
  scaled : Word → Word → Option Word

/-- Pamięć obiektów słownych: none = brak/niezainicjalizowany obiekt
(odczyt = wykonanie niezdefiniowane). -/
structure Mem where
  words : Addr → Option Word

def Mem.store (m : Mem) (a : Addr) (w : Word) : Mem :=
  ⟨fun x => if x = a then some w else m.words x⟩

theorem Mem.store_read (m : Mem) (a : Addr) (w : Word) :
    (m.store a w).words a = some w := by
  simp [Mem.store]

theorem Mem.store_frame (m : Mem) (a : Addr) (w : Word) (x : Addr) (hx : x ≠ a) :
    (m.store a w).words x = m.words x := by
  simp [Mem.store, hx]

/-- Stan wykonania: pamięć + dziennik zdarzeń (najnowsze pierwsze).
Zdarzenia = schemat Source3.StableBinary.Event (link, nie kopia logiki). -/
structure Run where
  mem : Mem
  events : List Event := []

def Run.chronology (r : Run) : List Event := r.events.reverse

/-- Licznik wywołań fpr o danej nazwie w dzienniku (kontrakt liczbowy dla
analizy błędów). -/
def countFpr (name : String) (r : Run) : Nat :=
  (r.events.filter (fun e =>
    match e with
    | .fpr n _ _ => n = name
    | _ => false)).length

def load (r : Run) (a : Addr) : Option (Word × Run) := do
  let w ← r.mem.words a
  pure (w, {r with events := .load a w :: r.events})

def store (r : Run) (a : Addr) (w : Word) : Option Run :=
  some {r with mem := r.mem.store a w, events := .store a w :: r.events}

theorem load_reads_only (r : Run) (a : Addr) (w : Word) (r' : Run)
    (h : load r a = some (w, r')) : r'.mem = r.mem := by
  cases hm : r.mem.words a with
  | none => simp [load, hm] at h
  | some z =>
    simp only [load, hm] at h
    have h2 : r' = { r with events := Event.load a z :: r.events } :=
      (Prod.mk.inj (Option.some.inj h)).2.symm
    rw [h2]

theorem store_writes_only (r : Run) (a : Addr) (w : Word) (r' : Run)
    (h : store r a w = some r') :
    r'.mem.words a = some w ∧ ∀ x, x ≠ a → r'.mem.words x = r.mem.words x := by
  simp only [store] at h
  rw [Eq.symm (Option.some.inj h)]
  exact ⟨Mem.store_read r.mem a w, fun x hx => Mem.store_frame r.mem a w x hx⟩

/-! ## Dispatcher callee fpr

Poziom źródłowy (nagłówek M0): fpr_half/fpr_double są tu LINKOWANE z
Source3.StableBinary (wykonanie z przypiętego nagłówka — praca Sola);
pozostałe nazwy trafiają do hooków FftCalls jako kontrakt Warstwy 2. -/

def applyCallee (c : FftCalls) (f : B20.C.Name) : List Word → Option Word
  | [x, y] =>
      if f = "fpr_add".toList then c.add x y
      else if f = "fpr_sub".toList then c.sub x y
      else if f = "fpr_mul".toList then c.mul x y
      else if f = "fpr_div".toList then c.div x y
      else if f = "fpr_scaled".toList then c.scaled x y
      else none
  | [x] =>
      if f = "fpr_sqr".toList then c.sqr x
      else if f = "fpr_neg".toList then c.neg x
      else if f = "fpr_inv".toList then c.inv x
      else if f = "fpr_of".toList then c.ofInt x
      else if f = "fpr_inverse_of".toList then c.inverseOf x
      else if f = "fpr_half".toList then Source3.StableBinary.half x
      else if f = "fpr_double".toList then Source3.StableBinary.double x
      else none
  | _ => none

/-! ## Warstwa makr FPC_* — ZPARSOWANE programy wywołań

Każde makro jest parsowane z dosłownego, przypiętego tekstu M0 (z usuniętymi
kontynuacjami wierszy `\`, jak `FprPrimitives.macroChars`); parser odrzuca
każdy nadmiarowy lub zmieniony token. `expand` interpretuje sparsowany
program na stanie Run; zagnieżdżone wywołania idą przez `CLogic.Expr`
(prawdziwy parser CLogicParser), kolejność ewaluacji = najpierw argumenty. -/

inductive MacroOp where
  | stmt (s : CLogic.Stmt)
  | passign (dst src : B20.C.Name)
  deriving DecidableEq, Repr

abbrev Macro := List MacroOp

/-- Parser jednego statementu ciała makra. Jedyny dodatek wobec
`CLogicParser.statement` to zapis docelowy `(d) = lhs;` (nawiasowy lvalue),
jak specjalizacja memcpy w `CObjectScalar.parseStmt`. -/
def parseMacroStmt : List Token → Option (MacroOp × List Token)
  | ['(']::dst::[')']::['=']::src::[';']::rest =>
      if dst.all B20.C.wordChar && src.all B20.C.wordChar
      then some (.passign dst src, rest) else none
  | ts => (CLogicParser.statement ts).map (fun (s, rest) => (.stmt s, rest))

def parseMacroBody : Nat → List Token → Option Macro
  | 0,_ => none
  | _+1,[] => none
  | _+1, ['}']::['w','h','i','l','e']::['(']::['0']::[')']::[] => some []
  | fuel+1,ts =>
      if ts.head! = ['}'] then none
      else match parseMacroStmt ts with
        | none => none
        | some (op, rest) => (parseMacroBody fuel rest).map (op :: ·)

/-- Parser całego makra: ciało spod linii kontynuacji (bez `\`), stopka
`do {` na linii nagłówka i `} while (0)` sprawdzane tezami-nagłówkami. -/
def parseMacro (chars : List Char) : Option Macro :=
  (CLogicParser.tokenize (chars.length+1) (chars.filter (· != '\\'))).bind
    (fun ts => parseMacroBody 32 ts)

/-! ## Ewaluacja wyrażeń makra z dziennikiem zdarzeń -/

def evalM (c : FftCalls) (env : B20.C.Name → Option Word) :
    CLogic.Expr → Run → Option (Word × Run)
  | .var n, r =>
    match env n with
    | some z => some (z, r)
    | none => none
  | .call1 f a, r =>
    match evalM c env a r with
    | some p =>
      match applyCallee c f [p.1] with
      | some z => some (z, {p.2 with events := .fpr (String.ofList f) [p.1] z :: p.2.events})
      | none => none
    | none => none
  | .call2 f a b, r =>
    match evalM c env a r with
    | some p =>
      match evalM c env b p.2 with
      | some q =>
        match applyCallee c f [p.1, q.1] with
        | some z => some (z, {q.2 with events := .fpr (String.ofList f) [p.1, q.1] z :: q.2.events})
        | none => none
      | none => none
    | none => none
  | _, _ => none

def runMacroOp (c : FftCalls) (dest : B20.C.Name → Option Addr) :
    MacroOp → (B20.C.Name → Option Word) × Run →
      Option ((B20.C.Name → Option Word) × Run)
  | .stmt (.declare _ _), st => some st
  | .stmt (.assign lhs e), st =>
      match evalM c st.1 e st.2 with
      | some p => some ((fun n => if n = lhs then some p.1 else st.1 n), p.2)
      | none => none
  | .stmt _, _ => none
  | .passign dst src, st =>
      match st.1 src with
      | some w =>
        match dest dst with
        | some a =>
          match store st.2 a w with
          | some r2 => some (st.1, r2)
          | none => none
        | none => none
      | none => none

def runMacro (c : FftCalls) (m : Macro) (env : B20.C.Name → Option Word)
    (dest : B20.C.Name → Option Addr) (r : Run) : Option Run :=
  match m with
  | [] => some r
  | op :: rest => do
      let st ← runMacroOp c dest op (env, r)
      runMacro c rest st.1 dest st.2

/-- Nazwy callee w kolejności wywołań makra (najpierw argumenty —
kolejność ewaluacji C). Kontrakt kolejności dla analizy błędów. -/
def exprCallNames : CLogic.Expr → List B20.C.Name
  | .var _ => []
  | .call1 f a => exprCallNames a ++ [f]
  | .call2 f a b => exprCallNames a ++ exprCallNames b ++ [f]
  | _ => []

def macroCallNames (m : Macro) : List B20.C.Name :=
  m.flatMap (fun op =>
    match op with
    | .stmt (.assign _ e) => exprCallNames e
    | _ => [])

/-! ## Ramka pamięci makr: zapisy TYLKO w sloty docelowe -/

theorem evalM_mem (c : FftCalls) (env : B20.C.Name → Option Word) :
    ∀ (e : CLogic.Expr) (r : Run) (w : Word) (r' : Run),
      evalM c env e r = some (w, r') → r'.mem = r.mem := by
  intro e
  induction e with
  | var n =>
    intro r w r' h
    cases hn : env n with
    | none => simp [evalM, hn] at h
    | some z =>
      simp only [evalM, hn] at h
      exact congrArg Run.mem (Prod.mk.inj (Option.some.inj h)).2.symm
  | literal n => intro r w r' h; simp [evalM] at h
  | cast ty a => intro r w r' h; simp [evalM] at h
  | neg a => intro r w r' h; simp [evalM] at h
  | bitNot a => intro r w r' h; simp [evalM] at h
  | bin op a b => intro r w r' h; simp [evalM] at h
  | cmp op a b => intro r w r' h; simp [evalM] at h
  | land a b => intro r w r' h; simp [evalM] at h
  | lor a b => intro r w r' h; simp [evalM] at h
  | lnot a => intro r w r' h; simp [evalM] at h
  | call1 f a ih =>
    intro r w r' h
    cases ha : evalM c env a r with
    | none => simp [evalM, ha] at h
    | some p =>
      cases hc : applyCallee c f [p.1] with
      | none => simp [evalM, ha, hc] at h
      | some z =>
        simp only [evalM, ha, hc] at h
        have h2 := congrArg Prod.snd (Option.some.inj h)
        have h3 : {p.2 with events := Event.fpr (String.ofList f) [p.1] z :: p.2.events} = r' := by
          simpa using h2
        rw [← h3]
        exact ih r p.1 p.2 ha
  | call2 f a b iha ihb =>
    intro r w r' h
    cases ha : evalM c env a r with
    | none => simp [evalM, ha] at h
    | some p =>
      cases hb : evalM c env b p.2 with
      | none => simp [evalM, ha, hb] at h
      | some q =>
        cases hc : applyCallee c f [p.1, q.1] with
        | none => simp [evalM, ha, hb, hc] at h
        | some z =>
          simp only [evalM, ha, hb, hc] at h
          have h2 := congrArg Prod.snd (Option.some.inj h)
          have h3 : {q.2 with events := Event.fpr (String.ofList f) [p.1, q.1] z :: q.2.events} = r' := by
            simpa using h2
          rw [← h3]
          exact (ihb p.2 q.1 q.2 hb).trans (iha r p.1 p.2 ha)
  | call3 f a b d =>
    intro r w r' h
    simp [evalM] at h

theorem runMacro_nil (c : FftCalls) (env : B20.C.Name → Option Word)
    (dest : B20.C.Name → Option Addr) (r : Run) :
    runMacro c [] env dest r = some r := rfl

theorem runMacro_cons (c : FftCalls) (op : MacroOp) (rest : Macro)
    (env : B20.C.Name → Option Word) (dest : B20.C.Name → Option Addr) (r : Run) :
    runMacro c (op :: rest) env dest r =
      (runMacroOp c dest op (env, r)).bind (fun st => runMacro c rest st.1 dest st.2) := rfl

theorem runMacroOp_frame (c : FftCalls) (dest : B20.C.Name → Option Addr)
    (op : MacroOp) (st st' : (B20.C.Name → Option Word) × Run)
    (h : runMacroOp c dest op st = some st') (x : Addr)
    (hx : ∀ a, dest a ≠ some x) : st'.2.mem.words x = st.2.mem.words x := by
  cases op with
  | stmt s =>
    cases s with
    | declare ty names =>
      simp only [runMacroOp] at h
      rw [Option.some.inj h]
    | assign lhs e =>
      cases he : evalM c st.1 e st.2 with
      | none => simp [runMacroOp, he] at h
      | some p =>
        rcases p with ⟨w0, r0⟩
        simp only [runMacroOp, he] at h
        have hmem := evalM_mem c st.1 e st.2 w0 r0 he
        have h2 := congrArg Prod.snd (Option.some.inj h)
        have h3 : r0 = st'.2 := by simpa using h2
        rw [← h3]
        exact congrArg (fun m => m.words x) hmem
    | update lhs b e => simp [runMacroOp] at h
    | ret e => simp [runMacroOp] at h
  | passign dst src =>
    cases hw : st.1 src with
    | none => simp [runMacroOp, hw] at h
    | some w =>
      cases hd : dest dst with
      | none => simp [runMacroOp, hw, hd] at h
      | some a =>
        cases hs : store st.2 a w with
        | none => simp [runMacroOp, hw, hd, hs] at h
        | some r2 =>
          simp only [runMacroOp, hw, hd, hs] at h
          have hne : x ≠ a := by
            intro heq
            exact hx dst (heq ▸ hd)
          have hfw := store_writes_only st.2 a w r2 hs
          have h2 := congrArg Prod.snd (Option.some.inj h)
          have h3 : r2 = st'.2 := by simpa using h2
          rw [← h3]
          exact hfw.2 x hne

theorem runMacro_frame (c : FftCalls) (dest : B20.C.Name → Option Addr) :
    ∀ (m : Macro) (env : B20.C.Name → Option Word) (r r' : Run),
      runMacro c m env dest r = some r' →
      ∀ x, (∀ a, dest a ≠ some x) → r'.mem.words x = r.mem.words x := by
  intro m
  induction m with
  | nil =>
    intro env r r' h x hx
    rw [runMacro_nil] at h
    rw [Option.some.inj h]
  | cons op rest ih =>
    intro env r r' h x hx
    rw [runMacro_cons] at h
    cases hs : runMacroOp c dest op (env, r) with
    | none => simp [hs] at h
    | some st =>
      simp only [hs] at h
      have hop := runMacroOp_frame c dest op (env, r) st hs x hx
      have hrest := ih st.1 st.2 r' h x hx
      exact hrest.trans hop

/-! ## Makra FPC_* — programy, piny tekstu, parsowanie, kolejności

Nagłówki `#define ... do { \` pinowane równościami całych linii (kontynuacja
wiersza usuwana przez parser, jak `FprPrimitives.macroChars`); ciała
parsowane z przypiętego tekstu. -/

def nm (s : String) : B20.C.Name := s.toList

def envOf (ks : List (B20.C.Name × Word)) : B20.C.Name → Option Word :=
  fun x => (ks.find? (fun p => p.1 = x)).map (fun p => p.2)

def slot2 (d1 d2 : B20.C.Name) (a1 a2 : Addr) : B20.C.Name → Option Addr :=
  fun x => if x = d1 then some a1 else if x = d2 then some a2 else none

def fpcAddMacro : Macro := [
  .stmt (.declare .u64 [nm "fpct_re", nm "fpct_im"]),
  .stmt (.assign (nm "fpct_re") (.call2 (nm "fpr_add") (.var (nm "a_re")) (.var (nm "b_re")))),
  .stmt (.assign (nm "fpct_im") (.call2 (nm "fpr_add") (.var (nm "a_im")) (.var (nm "b_im")))),
  .passign (nm "d_re") (nm "fpct_re"),
  .passign (nm "d_im") (nm "fpct_im")]

def fpcSubMacro : Macro := [
  .stmt (.declare .u64 [nm "fpct_re", nm "fpct_im"]),
  .stmt (.assign (nm "fpct_re") (.call2 (nm "fpr_sub") (.var (nm "a_re")) (.var (nm "b_re")))),
  .stmt (.assign (nm "fpct_im") (.call2 (nm "fpr_sub") (.var (nm "a_im")) (.var (nm "b_im")))),
  .passign (nm "d_re") (nm "fpct_re"),
  .passign (nm "d_im") (nm "fpct_im")]

def fpcMulMacro : Macro := [
  .stmt (.declare .u64 [nm "fpct_a_re", nm "fpct_a_im"]),
  .stmt (.declare .u64 [nm "fpct_b_re", nm "fpct_b_im"]),
  .stmt (.declare .u64 [nm "fpct_d_re", nm "fpct_d_im"]),
  .stmt (.assign (nm "fpct_a_re") (.var (nm "a_re"))),
  .stmt (.assign (nm "fpct_a_im") (.var (nm "a_im"))),
  .stmt (.assign (nm "fpct_b_re") (.var (nm "b_re"))),
  .stmt (.assign (nm "fpct_b_im") (.var (nm "b_im"))),
  .stmt (.assign (nm "fpct_d_re") (.call2 (nm "fpr_sub")
    (.call2 (nm "fpr_mul") (.var (nm "fpct_a_re")) (.var (nm "fpct_b_re")))
    (.call2 (nm "fpr_mul") (.var (nm "fpct_a_im")) (.var (nm "fpct_b_im"))))),
  .stmt (.assign (nm "fpct_d_im") (.call2 (nm "fpr_add")
    (.call2 (nm "fpr_mul") (.var (nm "fpct_a_re")) (.var (nm "fpct_b_im")))
    (.call2 (nm "fpr_mul") (.var (nm "fpct_a_im")) (.var (nm "fpct_b_re"))))),
  .passign (nm "d_re") (nm "fpct_d_re"),
  .passign (nm "d_im") (nm "fpct_d_im")]

def fpcSqrMacro : Macro := [
  .stmt (.declare .u64 [nm "fpct_a_re", nm "fpct_a_im"]),
  .stmt (.declare .u64 [nm "fpct_d_re", nm "fpct_d_im"]),
  .stmt (.assign (nm "fpct_a_re") (.var (nm "a_re"))),
  .stmt (.assign (nm "fpct_a_im") (.var (nm "a_im"))),
  .stmt (.assign (nm "fpct_d_re") (.call2 (nm "fpr_sub")
    (.call1 (nm "fpr_sqr") (.var (nm "fpct_a_re")))
    (.call1 (nm "fpr_sqr") (.var (nm "fpct_a_im"))))),
  .stmt (.assign (nm "fpct_d_im") (.call1 (nm "fpr_double")
    (.call2 (nm "fpr_mul") (.var (nm "fpct_a_re")) (.var (nm "fpct_a_im"))))),
  .passign (nm "d_re") (nm "fpct_d_re"),
  .passign (nm "d_im") (nm "fpct_d_im")]

def fpcInvMacro : Macro := [
  .stmt (.declare .u64 [nm "fpct_a_re", nm "fpct_a_im"]),
  .stmt (.declare .u64 [nm "fpct_d_re", nm "fpct_d_im"]),
  .stmt (.declare .u64 [nm "fpct_m"]),
  .stmt (.assign (nm "fpct_a_re") (.var (nm "a_re"))),
  .stmt (.assign (nm "fpct_a_im") (.var (nm "a_im"))),
  .stmt (.assign (nm "fpct_m") (.call2 (nm "fpr_add")
    (.call1 (nm "fpr_sqr") (.var (nm "fpct_a_re")))
    (.call1 (nm "fpr_sqr") (.var (nm "fpct_a_im"))))),
  .stmt (.assign (nm "fpct_d_re") (.call2 (nm "fpr_div") (.var (nm "fpct_a_re")) (.var (nm "fpct_m")))),
  .stmt (.assign (nm "fpct_d_im") (.call2 (nm "fpr_div")
    (.call1 (nm "fpr_neg") (.var (nm "fpct_a_im"))) (.var (nm "fpct_m")))),
  .passign (nm "d_re") (nm "fpct_d_re"),
  .passign (nm "d_im") (nm "fpct_d_im")]

def fpcDivMacro : Macro := [
  .stmt (.declare .u64 [nm "fpct_a_re", nm "fpct_a_im"]),
  .stmt (.declare .u64 [nm "fpct_b_re", nm "fpct_b_im"]),
  .stmt (.declare .u64 [nm "fpct_d_re", nm "fpct_d_im"]),
  .stmt (.declare .u64 [nm "fpct_m"]),
  .stmt (.assign (nm "fpct_a_re") (.var (nm "a_re"))),
  .stmt (.assign (nm "fpct_a_im") (.var (nm "a_im"))),
  .stmt (.assign (nm "fpct_b_re") (.var (nm "b_re"))),
  .stmt (.assign (nm "fpct_b_im") (.var (nm "b_im"))),
  .stmt (.assign (nm "fpct_m") (.call2 (nm "fpr_add")
    (.call1 (nm "fpr_sqr") (.var (nm "fpct_b_re")))
    (.call1 (nm "fpr_sqr") (.var (nm "fpct_b_im"))))),
  .stmt (.assign (nm "fpct_b_re") (.call2 (nm "fpr_div") (.var (nm "fpct_b_re")) (.var (nm "fpct_m")))),
  .stmt (.assign (nm "fpct_b_im") (.call2 (nm "fpr_div")
    (.call1 (nm "fpr_neg") (.var (nm "fpct_b_im"))) (.var (nm "fpct_m")))),
  .stmt (.assign (nm "fpct_d_re") (.call2 (nm "fpr_sub")
    (.call2 (nm "fpr_mul") (.var (nm "fpct_a_re")) (.var (nm "fpct_b_re")))
    (.call2 (nm "fpr_mul") (.var (nm "fpct_a_im")) (.var (nm "fpct_b_im"))))),
  .stmt (.assign (nm "fpct_d_im") (.call2 (nm "fpr_add")
    (.call2 (nm "fpr_mul") (.var (nm "fpct_a_re")) (.var (nm "fpct_b_im")))
    (.call2 (nm "fpr_mul") (.var (nm "fpct_a_im")) (.var (nm "fpct_b_re"))))),
  .passign (nm "d_re") (nm "fpct_d_re"),
  .passign (nm "d_im") (nm "fpct_d_im")]

/- Piny całych linii nagłówkowych (`do { \` na końcu = kontynuacja wiersza). -/
theorem add_wrapper : FftPin.fftLines[54]? =
    some "#define FPC_ADD(d_re, d_im, a_re, a_im, b_re, b_im)   do { \\\n" := by decide
theorem sub_wrapper : FftPin.fftLines[65]? =
    some "#define FPC_SUB(d_re, d_im, a_re, a_im, b_re, b_im)   do { \\\n" := by decide
theorem mul_wrapper : FftPin.fftLines[76]? =
    some "#define FPC_MUL(d_re, d_im, a_re, a_im, b_re, b_im)   do { \\\n" := by decide
theorem sqr_wrapper : FftPin.fftLines[97]? =
    some "#define FPC_SQR(d_re, d_im, a_re, a_im)   do { \\\n" := by decide
theorem inv_wrapper : FftPin.fftLines[111]? =
    some "#define FPC_INV(d_re, d_im, a_re, a_im)   do { \\\n" := by decide
theorem div_wrapper : FftPin.fftLines[127]? =
    some "#define FPC_DIV(d_re, d_im, a_re, a_im, b_re, b_im)   do { \\\n" := by decide

/- Parsowanie ciał makr z przypiętego tekstu M0. -/
theorem add_parses : parseMacro (FftPin.fftSlice 56 6) = some fpcAddMacro := by decide
theorem sub_parses : parseMacro (FftPin.fftSlice 67 6) = some fpcSubMacro := by decide
theorem mul_parses : parseMacro (FftPin.fftSlice 78 16) = some fpcMulMacro := by decide
theorem sqr_parses : parseMacro (FftPin.fftSlice 99 9) = some fpcSqrMacro := by decide
theorem inv_parses : parseMacro (FftPin.fftSlice 113 11) = some fpcInvMacro := by decide
theorem div_parses : parseMacro (FftPin.fftSlice 129 20) = some fpcDivMacro := by decide

/- Kolejności wywołań fpr każdego makra (kontrakt dla analizy błędów). -/
theorem add_calls : macroCallNames fpcAddMacro = [nm "fpr_add", nm "fpr_add"] := by decide
theorem sub_calls : macroCallNames fpcSubMacro = [nm "fpr_sub", nm "fpr_sub"] := by decide
theorem mul_calls : macroCallNames fpcMulMacro =
    [nm "fpr_mul", nm "fpr_mul", nm "fpr_sub", nm "fpr_mul", nm "fpr_mul", nm "fpr_add"] := by
  decide
theorem sqr_calls : macroCallNames fpcSqrMacro =
    [nm "fpr_sqr", nm "fpr_sqr", nm "fpr_sub", nm "fpr_mul", nm "fpr_double"] := by decide
theorem inv_calls : macroCallNames fpcInvMacro =
    [nm "fpr_sqr", nm "fpr_sqr", nm "fpr_add", nm "fpr_div", nm "fpr_neg", nm "fpr_div"] := by
  decide
theorem div_calls : macroCallNames fpcDivMacro =
    [nm "fpr_sqr", nm "fpr_sqr", nm "fpr_add", nm "fpr_div", nm "fpr_neg", nm "fpr_div",
     nm "fpr_mul", nm "fpr_mul", nm "fpr_sub", nm "fpr_mul", nm "fpr_mul", nm "fpr_add"] := by
  decide

/- Wygodne wywołania makr na slotach pamięci (argumenty ewaluowane przez
wołającego — zgodnie z kolejnością `(a_re)` itd. w makrze). -/
def fpcAdd (c : FftCalls) (r : Run) (drea dima : Addr) (are aim bre bim : Word) : Option Run :=
  runMacro c fpcAddMacro
    (envOf [(nm "a_re", are), (nm "a_im", aim), (nm "b_re", bre), (nm "b_im", bim)])
    (slot2 (nm "d_re") (nm "d_im") drea dima) r

def fpcSub (c : FftCalls) (r : Run) (drea dima : Addr) (are aim bre bim : Word) : Option Run :=
  runMacro c fpcSubMacro
    (envOf [(nm "a_re", are), (nm "a_im", aim), (nm "b_re", bre), (nm "b_im", bim)])
    (slot2 (nm "d_re") (nm "d_im") drea dima) r

def fpcMul (c : FftCalls) (r : Run) (drea dima : Addr) (are aim bre bim : Word) : Option Run :=
  runMacro c fpcMulMacro
    (envOf [(nm "a_re", are), (nm "a_im", aim), (nm "b_re", bre), (nm "b_im", bim)])
    (slot2 (nm "d_re") (nm "d_im") drea dima) r

def fpcSqr (c : FftCalls) (r : Run) (drea dima : Addr) (are aim : Word) : Option Run :=
  runMacro c fpcSqrMacro
    (envOf [(nm "a_re", are), (nm "a_im", aim)])
    (slot2 (nm "d_re") (nm "d_im") drea dima) r

def fpcInv (c : FftCalls) (r : Run) (drea dima : Addr) (are aim : Word) : Option Run :=
  runMacro c fpcInvMacro
    (envOf [(nm "a_re", are), (nm "a_im", aim)])
    (slot2 (nm "d_re") (nm "d_im") drea dima) r

def fpcDiv (c : FftCalls) (r : Run) (drea dima : Addr) (are aim bre bim : Word) : Option Run :=
  runMacro c fpcDivMacro
    (envOf [(nm "a_re", are), (nm "a_im", aim), (nm "b_re", bre), (nm "b_im", bim)])
    (slot2 (nm "d_re") (nm "d_im") drea dima) r

end FT1536.FftBind.FftSem

#print axioms FT1536.FftBind.FftSem.add_parses
#print axioms FT1536.FftBind.FftSem.mul_parses
#print axioms FT1536.FftBind.FftSem.div_parses
#print axioms FT1536.FftBind.FftSem.mul_calls
#print axioms FT1536.FftBind.FftSem.div_calls
#print axioms FT1536.FftBind.FftSem.runMacro_frame
