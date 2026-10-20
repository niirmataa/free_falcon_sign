import Source3.C99ProcedureSequence

/- Exact pointer assignments by zero or the M0 local n. This is a source
   execution adapter: pointer bounds are checked by the reference arithmetic
   and by the executable model, rather than inferred from output values. -/
namespace FT1536.Source3.C99AliasSequence
open C99ArrayReference (Name State)
open C99MemoryReference
open C99ProcedureReference (Stmt Exec Result Program)

structure Alias where
  target : Name
  source : Name
  next : Bool
  deriving DecidableEq, Repr

def index (next : Bool) : CLogic.Expr := if next then .var "n".toList else .literal .u64 0
def amount (next : Bool) : Nat := if next then 1536 else 0
def advance (p : ArrayPointer) (next : Bool) : ArrayPointer := {p with index := p.index+amount next}
def statement (a : Alias) : Stmt := .base (.bindPtr a.target a.source (index a.next))
def evaluate (a : Alias) (s : State) : Option State := do
  let p ← s.arrays a.source
  if p.index+amount a.next≤p.count then
    pure (C99ArrayReference.bindPointer s a.target (advance p a.next)) else none
def run : List Alias → State → Option State
  | [],s => some s
  | a::rest,s => (evaluate a s).bind (run rest)
def thenCode : List Alias → Stmt → Stmt
  | [],tail => tail
  | a::rest,tail => .seq (statement a) (thenCode rest tail)

def HasN (s : State) : Prop := s.locals "n".toList=some (.uint64,some (.uint64 1536))

theorem index_value (s : State) (next : Bool) (v : C99IntegerReference.Value)
    (hn : HasN s) (h : C99ArrayReference.scalar s (index next) v) :
    v=.uint64 (BitVec.ofNat 64 (amount next)) := by
  cases next with
  | false =>
      change C99ScalarReference.Eval _ _ (.literal .uint64 0) v at h
      cases h
      rfl
  | true =>
      change C99ScalarReference.Eval _ _ (.variable "n".toList) v at h
      cases h with
      | «variable» _ _ _ bound =>
          exact Option.some.inj (congrArg Prod.snd (Option.some.inj (bound.symm.trans hn)))

theorem index_exists (s : State) (next : Bool) (hn : HasN s) :
    C99ArrayReference.scalar s (index next) (.uint64 (BitVec.ofNat 64 (amount next))) := by
  cases next with
  | false => exact C99ScalarReference.Eval.literal .uint64 0
  | true => exact C99ScalarReference.Eval.variable "n".toList .uint64 (.uint64 1536) hn

theorem pointer_origin (s : State) (name : Name) (e : CLogic.Expr) (p : ArrayPointer)
    (h : C99ArrayReference.Pointer s name e p) : ∃ root, s.arrays name=some root := by
  cases h with
  | add root _ value binding evaluated nonnegative within => exact ⟨root,binding⟩

theorem pointer_exact (s : State) (name : Name) (next : Bool) (root p : ArrayPointer)
    (hn : HasN s) (binding : s.arrays name=some root)
    (h : C99ArrayReference.Pointer s name (index next) p) :
    p=advance root next ∧ root.index+amount next≤root.count := by
  cases h with
  | add original _ value bound evaluated nonnegative within =>
      have he : original=root := Option.some.inj (bound.symm.trans binding)
      subst original
      have hv := index_value s next value hn evaluated
      subst value
      cases next <;> cases within with
      | within hbound => exact ⟨rfl,hbound⟩

theorem step_complete (program : Program) (a : Alias) (before : State) (result : Result)
    (hn : HasN before) (source : Exec program (statement a) before result) :
    evaluate a before=some result.state ∧ result.flow=.normal ∧ result.state.locals=before.locals := by
  cases source with
  | base _ _ _ execution =>
      cases execution with
      | bindPtr before name src e p value =>
          obtain ⟨root,hr⟩ := pointer_origin before a.source (index a.next) p value
          obtain ⟨hp,hb⟩ := pointer_exact before a.source a.next root p hn hr value
          subst p
          refine ⟨?_,rfl,rfl⟩
          simp [evaluate,hr,hb]

theorem step_sound (program : Program) (a : Alias) (before after : State)
    (hn : HasN before) (h : evaluate a before=some after) :
    Exec program (statement a) before ⟨after,.normal⟩ ∧ after.locals=before.locals := by
  cases hp : before.arrays a.source with
  | none => simp [evaluate,hp] at h
  | some p =>
      by_cases hb : p.index+amount a.next≤p.count
      · have he : C99ArrayReference.bindPointer before a.target (advance p a.next)=after :=
          Option.some.inj (by simpa [evaluate,hp,hb] using h)
        subst after
        refine ⟨.base _ _ _ (.bindPtr before a.target a.source (index a.next) (advance p a.next) ?_),rfl⟩
        have hn0 : (0 : Int)≤(C99IntegerReference.Value.uint64 (BitVec.ofNat 64 (amount a.next))).integer := by
          change (0 : Int)≤((BitVec.ofNat 64 (amount a.next)).toNat : Int)
          omega
        apply C99ArrayReference.Pointer.add a.source (index a.next) p (advance p a.next)
          (.uint64 (BitVec.ofNat 64 (amount a.next))) hp (index_exists before a.next hn) hn0
        have he : (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 (amount a.next))).integer.toNat=amount a.next := by
          cases a.next <;> rfl
        rw [he]
        exact PointerAdd.within p _ hb
      · simp [evaluate,hp,hb] at h

theorem sequence_complete (program : Program) (aliases : List Alias) (tail : Stmt)
    (before : State) (result : Result) (hn : HasN before)
    (source : Exec program (thenCode aliases tail) before result) :
    ∃ out, run aliases before=some out ∧ out.locals=before.locals ∧ Exec program tail out result := by
  induction aliases generalizing before with
  | nil => exact ⟨before,rfl,rfl,source⟩
  | cons a rest ih =>
      cases source with
      | seqNormal x y before middle result first second =>
          obtain ⟨hs,_,hl⟩ := step_complete program a before ⟨middle,.normal⟩ hn first
          change middle.locals=before.locals at hl
          obtain ⟨out,ho,he,ht⟩ := ih middle (by simpa only [HasN,hl] using hn) second
          refine ⟨out,?_,he.trans hl,ht⟩
          change (evaluate a before).bind (run rest)=some out
          rw [hs]
          exact ho
      | seqExit x y before result first exit =>
          exact False.elim (exit (step_complete program a before result hn first).2.1)

theorem sequence_sound (program : Program) (aliases : List Alias) (tail : Stmt)
    (before after : State) (result : Result) (hn : HasN before)
    (h : run aliases before=some after) (continuation : Exec program tail after result) :
    Exec program (thenCode aliases tail) before result := by
  induction aliases generalizing before with
  | nil => have he := Option.some.inj h; subst after; exact continuation
  | cons a rest ih =>
      obtain ⟨middle,hm,hr⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨hs,hl⟩ := step_sound program a before middle hn hm
      exact .seqNormal (statement a) (thenCode rest tail) before middle result hs
        (ih middle (by simpa only [HasN,hl] using hn) hr)

end FT1536.Source3.C99AliasSequence
