import ArenaInvariant020E1

namespace FT1536.S05.ArenaParse020E1
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1 ArenaStep020E1 ArenaInvariant020E1

def runTokens {cap : Nat} : List Token → Arena cap → Option (Arena cap)
  | [],s => some s
  | t::ts,s => (step t s).bind (runTokens ts)

def runCells {cap : Nat} : List SyntaxCells020E.Cell → Arena cap → Option (Arena cap)
  | [],s => some s
  | c::cs,s => (stepCell c s).bind (runCells cs)

theorem encoded_run {cap : Nat} (ts : List Token) (s : Arena cap) (ht : SyntaxLegal020E.All ts) :
    runCells (ts.map SyntaxCells020E.encode) s=runTokens ts s := by
  induction ts generalizing s with
  | nil => rfl
  | cons t ts ih =>
    have h1 := ht t (by simp)
    have htail : SyntaxLegal020E.All ts := fun x hx => ht x (by simp [hx])
    simp only [List.map_cons,runCells,runTokens,encoded_step s t h1]
    cases hs : step t s with
    | none => rfl
    | some q => exact ih q htail

/-- Every successful source prefix has a concrete arena run. One fresh node
    per token, with all child addresses and stack slots within fixed banks. -/
theorem parse_refines {cap : Nat} (ts : List Token) (s : Arena cap) (mu : Meaning) (ps qs : List Piece)
    (ht : SyntaxLegal020E.All ts) (hi : Inv s mu ps) (room : s.used.val+ts.length≤cap)
    (hp : parse ts ps=some qs) :
    ∃ q : Arena cap,∃ nu : Meaning,runTokens ts s=some q ∧ Inv q nu qs ∧
      q.used.val=s.used.val+ts.length := by
  induction ts generalizing s mu ps with
  | nil =>
    have he : ps=qs := Option.some.inj hp
    subst qs
    exact ⟨s,mu,rfl,hi,by simp⟩
  | cons t ts ih =>
    have h1 := ht t (by simp)
    have htail : SyntaxLegal020E.All ts := fun x hx => ht x (by simp [hx])
    have hu : s.used.val<cap := by simp only [List.length_cons] at room;omega
    cases hs : push t ps with
    | none => simp only [parse,hs,Option.bind_none] at hp;cases hp
    | some middle =>
      have hp' : parse ts middle=some qs := by simpa only [parse,hs,Option.bind_some] using hp
      obtain ⟨r,nu,hr,hir,hused⟩ := step_refines s mu ps middle t h1 hi hu hs
      have room' : r.used.val+ts.length≤cap := by simp only [List.length_cons] at room;omega
      obtain ⟨q,nu',hq,hiq,hcount⟩ := ih r nu middle htail hir room' hp'
      refine ⟨q,nu',?_,hiq,?_⟩
      · simp only [runTokens,hr,Option.bind_some]
        exact hq
      · simp only [List.length_cons]
        omega

end FT1536.S05.ArenaParse020E1
