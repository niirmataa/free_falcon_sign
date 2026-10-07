import Source3.KeygenMkgm3Control
import Source3.KeygenNttButterflyCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Structural frames for NTT pointer binds and block-local declarations.
   Scope restoration removes exactly the declared scalar names. These
   frames do not assert anything about the values written to memory. -/
namespace FT1536.Source3.KeygenNttControl
open C99ModularReference (Stmt Exec)
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open KeygenNttLoopSupport (USlot PSlot)
open KeygenNttButterflyCalls (U32Slot)

def localsWritten : Stmt → List Name
  | .scope names body => (localsWritten body).filter (fun n => !names.contains n)
  | .seq a b | .branch _ a b | .loop _ a b => localsWritten a++localsWritten b
  | code => KeygenMkgm3Control.writes code

def pointersWritten : Stmt → List Name
  | .base (.bindPtr n _ _) | .base (.declarePtr n) => [n]
  | .seq a b | .branch _ a b | .loop _ a b => pointersWritten a++pointersWritten b
  | .scope _ body => pointersWritten body
  | _ => []

def supported : Stmt → Bool
  | .base (.bindPtr _ _ _) | .base (.declarePtr _) => true
  | .seq a b | .branch _ a b | .loop _ a b => supported a && supported b
  | .scope _ body => supported body
  | code => KeygenMkgm3Control.supported code

def Frame (code : Stmt) (before : State) (out : Result) : Prop :=
  out.flow=.normal ∧
    (∀ n, n∉localsWritten code → out.state.locals n=before.locals n) ∧
    (∀ n, n∉pointersWritten code → out.state.arrays n=before.arrays n)

theorem frame (code : Stmt) (before : State) (out : Result)
    (hs : supported code=true) (source : Exec code before out) : Frame code before out := by
  induction source with
  | base code before after body =>
      cases code with
      | bindPtr name origin index =>
          cases body with
          | bindPtr s name origin index p address =>
              refine ⟨rfl,fun _ _ => rfl,?_⟩
              intro n hn
              have ne : n≠name := by simpa only [pointersWritten,List.mem_singleton] using hn
              simp only [C99ArrayReference.bindPointer,ne,ite_false]
      | declarePtr name =>
          cases body with
          | declarePtr s name =>
              refine ⟨rfl,fun _ _ => rfl,?_⟩
              intro n hn
              have ne : n≠name := by simpa only [pointersWritten,List.mem_singleton] using hn
              simp only [ne,ite_false]
      | skip | scalar =>
          have old := KeygenMkgm3Control.frame _ _ _ hs (.base _ _ _ body)
          exact ⟨old.1,old.2.2,fun n _ => congrFun old.2.1 n⟩
      | assign | store64 | store32 | copy | seq | scope | branch | «while» | call => cases hs
  | assign name e before ty old v declared value =>
      have old := KeygenMkgm3Control.frame _ _ _ hs (.assign _ _ _ _ _ _ declared value)
      exact ⟨old.1,old.2.2,fun n _ => congrFun old.2.1 n⟩
  | store32 | storeRev => exact ⟨rfl,fun _ _ => rfl,fun _ _ => rfl⟩
  | seqNormal first second before middle out head tail ih1 ih2 =>
      have h := Bool.and_eq_true_iff.mp hs
      obtain ⟨_,la,pa⟩ := ih1 h.1
      obtain ⟨flow,lb,pb⟩ := ih2 h.2
      refine ⟨flow,?_,?_⟩
      · intro n hn
        have h : n∉localsWritten first ∧ n∉localsWritten second :=
          by simpa only [localsWritten,List.mem_append,not_or] using hn
        exact (lb n h.2).trans (la n h.1)
      · intro n hn
        have h : n∉pointersWritten first ∧ n∉pointersWritten second :=
          by simpa only [pointersWritten,List.mem_append,not_or] using hn
        exact (pb n h.2).trans (pa n h.1)
  | seqExit first second before out head exit ih =>
      exact (exit (ih (Bool.and_eq_true_iff.mp hs).1).1).elim
  | scope names body before out execution ih =>
      obtain ⟨flow,hl,hp⟩ := ih hs
      refine ⟨flow,?_,hp⟩
      intro n hn
      change (if names.contains n then before.locals n else out.state.locals n)=before.locals n
      split_ifs with restored
      · rfl
      · apply hl n
        intro member
        apply hn
        exact List.mem_filter.mpr ⟨member,by simpa using restored⟩
  | branchTrue cond yes no before out v guard nonzero execution ih =>
      obtain ⟨flow,hl,hp⟩ := ih (Bool.and_eq_true_iff.mp hs).1
      exact ⟨flow,fun n hn => hl n (fun h => hn (List.mem_append_left _ h)),
        fun n hn => hp n (fun h => hn (List.mem_append_left _ h))⟩
  | branchFalse cond yes no before out v guard zero execution ih =>
      obtain ⟨flow,hl,hp⟩ := ih (Bool.and_eq_true_iff.mp hs).2
      exact ⟨flow,fun n hn => hl n (fun h => hn (List.mem_append_right _ h)),
        fun n hn => hp n (fun h => hn (List.mem_append_right _ h))⟩
  | loopFalse => exact ⟨rfl,fun _ _ => rfl,fun _ _ => rfl⟩
  | loopNormal cond body inc before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      have h := Bool.and_eq_true_iff.mp hs
      obtain ⟨_,la,pa⟩ := ih1 h.1
      obtain ⟨_,lb,pb⟩ := ih2 h.2
      obtain ⟨flow,lc,pc⟩ := ih3 hs
      refine ⟨flow,?_,?_⟩
      · intro n hn
        have h : n∉localsWritten body ∧ n∉localsWritten inc :=
          by simpa only [localsWritten,List.mem_append,not_or] using hn
        exact (lc n hn).trans ((lb n h.2).trans (la n h.1))
      · intro n hn
        have h : n∉pointersWritten body ∧ n∉pointersWritten inc :=
          by simpa only [pointersWritten,List.mem_append,not_or] using hn
        exact (pc n hn).trans ((pb n h.2).trans (pa n h.1))
  | loopReturn cond body inc before after v value guard nonzero iteration ih =>
      have flow := (ih (Bool.and_eq_true_iff.mp hs).1).1
      cases flow
  | ret | retVoid => cases hs

theorem seq_inv (first second : Stmt) (before : State) (out : Result)
    (normal : supported first=true) (source : Exec (.seq first second) before out) :
    ∃ middle, Exec first before ⟨middle,.normal⟩ ∧ Exec second middle out := by
  cases source with
  | seqNormal _ _ _ middle _ head tail => exact ⟨middle,head,tail⟩
  | seqExit _ _ _ _ head exit => exact (exit (frame first before out normal head).1).elim

theorem keep_u64 {code : Stmt} {before : State} {out : Result} (source : Exec code before out)
    (checked : supported code=true) (name : String) (n : Nat)
    (fresh : name.toList∉localsWritten code) (slot : USlot before name n) : USlot out.state name n :=
  ((frame code before out checked source).2.1 name.toList fresh).trans slot

theorem keep_u32 {code : Stmt} {before : State} {out : Result} (source : Exec code before out)
    (checked : supported code=true) (name : String) (n : BitVec 32)
    (fresh : name.toList∉localsWritten code) (slot : U32Slot before name n) : U32Slot out.state name n :=
  ((frame code before out checked source).2.1 name.toList fresh).trans slot

theorem keep_pointer {code : Stmt} {before : State} {out : Result} (source : Exec code before out)
    (checked : supported code=true) (name : String) (p : C99MemoryReference.ArrayPointer)
    (fresh : name.toList∉pointersWritten code) (slot : PSlot before name p) : PSlot out.state name p :=
  ((frame code before out checked source).2.2 name.toList fresh).trans slot

end FT1536.Source3.KeygenNttControl
